class my_agent extends uvm_agent;
    my_driver driver;
    my_monitor monitor;
    my_sequencer sequencer;
    virtual intf vif;

    `uvm_component_utils(my_agent);

    function new(string name = "my_agent", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        driver = my_driver::type_id::create("driver", this);
        monitor = my_monitor::type_id::create("monitor", this);
        sequencer = my_sequencer::type_id::create("sequencer", this);
        if (!uvm_config_db#(virtual intf)::get(this, "", "vif", vif))
            `uvm_fatal("my_agent", "Failed to get vif from config DB!")
        uvm_config_db#(virtual intf)::set(this, "driver", "vif", vif); // Pass vif to driver
        uvm_config_db#(virtual intf)::set(this, "monitor", "vif", vif); // Pass vif to monitor
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        driver.seq_item_port.connect(sequencer.seq_item_export); // Connect driver to sequencer
    endfunction
endclass