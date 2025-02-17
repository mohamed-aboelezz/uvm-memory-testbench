class my_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(my_scoreboard)
    
    uvm_tlm_analysis_fifo #(my_sequence_item) scoreboard_fifo;
    my_sequence_item transaction;
    
    // Shadow memory to track expected values
    logic [31:0] shadow_mem [16];
    
    // Coverage and error counters
    int error_count = 0;
    int total_transactions = 0;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        scoreboard_fifo = new("scoreboard_fifo", this);
        initialize_shadow_mem();
    endfunction

    function void initialize_shadow_mem();
        foreach(shadow_mem[i]) shadow_mem[i] = 32'h0;
    endfunction

    task run_phase(uvm_phase phase);
        forever begin
            scoreboard_fifo.get(transaction);
            total_transactions++;
            
            // Handle reset
            if(transaction.rst === 0) begin
                initialize_shadow_mem();
                `uvm_info("SCOREBOARD", "Reset detected - Shadow memory cleared", UVM_MEDIUM)
                continue;
            end

            // Write operation check
            if(transaction.en && !transaction.re) begin
                shadow_mem[transaction.addr] = transaction.data_in;
                `uvm_info("SCOREBOARD", $sformatf("Write recorded - Addr: 0x%0h Data: 0x%0h", 
                    transaction.addr, transaction.data_in), UVM_HIGH)
            end
            
            // Read operation check
            if(transaction.re && !transaction.en) begin
                logic [31:0] expected = shadow_mem[transaction.addr];
                if(transaction.data_out !== expected) begin
                    error_count++;
                    `uvm_error("SCOREBOARD", $sformatf("Read mismatch! Addr: 0x%0h  Expected: 0x%0h  Actual: 0x%0h",
                        transaction.addr, expected, transaction.data_out))
                end
                else begin
                    `uvm_info("SCOREBOARD", $sformatf("Read match - Addr: 0x%0h Data: 0x%0h", 
                        transaction.addr, transaction.data_out), UVM_HIGH)
                end
                
                // Check valid_out
                if(!transaction.valid_out) begin
                    error_count++;
                    `uvm_error("SCOREBOARD", "valid_out not asserted during read operation")
                end
            end
            
            // Final report
            if(total_transactions % 100 == 0) begin
                `uvm_info("SCOREBOARD", $sformatf("Progress: %0d transactions processed, %0d errors", 
                    total_transactions, error_count), UVM_MEDIUM)
            end
        end
    endtask

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("SCOREBOARD", $sformatf("\n\nTEST SUMMARY:\nTotal Transactions: %0d\nErrors: %0d\n", 
            total_transactions, error_count), UVM_NONE)
    endfunction
endclass