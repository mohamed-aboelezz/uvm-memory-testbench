class my_subscriber extends uvm_subscriber #(my_sequence_item);
    my_sequence_item sequence_item;

    covergroup cg;
        coverpoint sequence_item.re {
            bins read = {1};
            bins no_read = {0};
        }
        coverpoint sequence_item.en {
            bins write = {1};
            bins no_write = {0};
        }
        coverpoint sequence_item.addr {
            bins addr_range[4] = {[0:15]};
        }
    endgroup

    `uvm_component_utils(my_subscriber);

    function new(string name = "my_subscriber", uvm_component parent);
        super.new(name, parent);
        cg = new();
    endfunction

    function void write(my_sequence_item t);
        sequence_item = t;
        cg.sample();
    endfunction
endclass