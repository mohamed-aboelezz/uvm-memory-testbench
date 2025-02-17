module top;
    logic clk = 0;
    always #5 clk = ~clk;  

    import uvm_pkg::*;
    import pack1::*;
    intf vif();
    assign vif.clk = clk;

    Memory mem (vif); 

    initial begin
        uvm_config_db#(virtual intf)::set(null, "uvm_test_top", "vif", vif); // Set the interface
        run_test("my_test");
    end

endmodule