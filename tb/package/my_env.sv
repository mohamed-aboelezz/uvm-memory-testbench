class my_env extends uvm_env;
    virtual intf vif;
    my_agent agent;

    `uvm_component_utils(my_env)

    function new(string name = "my_env", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        agent = my_agent::type_id::create("agent", this);
        uvm_config_db#(virtual intf)::get(this, "", "vif", vif);
    endfunction

    function void connect_phase (uvm_phase phase);
        super.connect_phase(phase);
        agent.seq_item_port.connect(agent.sequencer.seq_item_export);
    endfunction
endclass
