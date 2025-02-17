class my_sequence extends uvm_sequence #(my_sequence_item);
    `uvm_object_utils(my_sequence)

    function new(string name = "my_sequence");
        super.new(name);
    endfunction

    task body();
        my_sequence_item transaction;
        repeat (100) begin
            transaction = my_sequence_item::type_id::create("transaction");
            start_item(transaction);
            if (!transaction.randomize())
                `uvm_error("SEQUENCE", "Randomization failed")
            finish_item(transaction);
        end
    endtask
endclass