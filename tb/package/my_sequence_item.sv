class my_sequence_item extends uvm_sequence_item;
    rand logic [3:0]  addr;
    rand logic [31:0] data_in;
    rand logic        en;
    rand logic        re;
    rand logic        rst;
    
    logic [31:0] data_out;
    logic        valid_out;
    logic        clk;

    `uvm_object_utils_begin(my_sequence_item)
        `uvm_field_int(addr, UVM_ALL_ON)
        `uvm_field_int(data_in, UVM_ALL_ON)
        `uvm_field_int(en, UVM_ALL_ON)
        `uvm_field_int(re, UVM_ALL_ON)
        `uvm_field_int(rst, UVM_ALL_ON)
        `uvm_field_int(data_out, UVM_ALL_ON)
        `uvm_field_int(valid_out, UVM_ALL_ON)
    `uvm_object_utils_end

    constraint valid_ops {
        en != re;  // Can't have both read and write at same time
        rst == 0 -> en == 0 && re == 0;  // No operations during reset
    }

    function new(string name = "my_sequence_item");
        super.new(name);
    endfunction
endclass