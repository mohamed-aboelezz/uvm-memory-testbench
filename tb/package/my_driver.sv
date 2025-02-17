class my_driver extends uvm_driver #(my_sequence_item);
    virtual intf vif;
    my_sequence_item sequence_item;

    `uvm_component_utils(my_driver);

    function new(string name = "my_driver", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sequence_item = my_sequence_item::type_id::create("sequence_item", this);
        if (!uvm_config_db#(virtual intf)::get(this, "", "vif", vif))
            `uvm_fatal("my_driver", "Failed to get vif from config DB!")
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            @(posedge vif.clk);
            seq_item_port.get_next_item(sequence_item);
            vif.re <= sequence_item.re;
            vif.en <= sequence_item.en;
            vif.rst <= sequence_item.rst;
            vif.addr <= sequence_item.addr;
            vif.data_in <= sequence_item.data_in;
            seq_item_port.item_done();
        end
    endtask
endclass