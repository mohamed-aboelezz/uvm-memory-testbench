class my_test extends uvm_test;
    virtual intf vif;
    my_env env;
    my_sequence sequence;

    `uvm_component_utils(my_test)

    function new(string name = "my_test", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        env = my_env::type_id::create("env", this);
        sequence = my_sequence::type_id::create("sequence", this);

        if (!uvm_config_db#(virtual intf)::get(this, "", "vif", vif)) begin
            `uvm_fatal("my_test", "Failed to get vif from config DB!")
        end
        uvm_config_db#(virtual intf)::set(this, "env", "vif", vif); // Set interface
    endfunction

    function void connect_phase (uvm_phase phase);
        super.connect_phase(phase);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        phase.raise_objection(this);
        sequence.start(env.agent.sequencer);
        phase.drop_objection(this);
    endtask
endclass
