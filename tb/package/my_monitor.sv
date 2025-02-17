class my_monitor extends uvm_monitor;
    `uvm_component_utils(my_monitor)
    
    virtual intf vif;
    uvm_analysis_port #(my_sequence_item) mon_ap;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        mon_ap = new("mon_ap", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual intf)::get(this, "", "vif", vif))
            `uvm_fatal("MONITOR", "Failed to get interface")
    endfunction

    task run_phase(uvm_phase phase);
        my_sequence_item transaction;
        forever begin
            @(posedge vif.clk);
            transaction = my_sequence_item::type_id::create("transaction");
            transaction.rst     = vif.rst;
            transaction.en      = vif.en;
            transaction.re      = vif.re;
            transaction.addr    = vif.addr;
            transaction.data_in = vif.data_in;
            transaction.data_out = vif.data_out;
            transaction.valid_out = vif.valid_out;
            mon_ap.write(transaction);
        end
    endtask
endclass