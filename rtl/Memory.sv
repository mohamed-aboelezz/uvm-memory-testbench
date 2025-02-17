module Memory (intf intf0);
    reg [31:0] memory [0:15];  // 16 words of memory

    always_ff @(posedge intf0.clk or posedge intf0.rst) begin
        if (intf0.rst)
            intf0.data_out <= 32'b0;  // Reset data output
        else if (intf0.en)
            intf0.data_out <= memory[intf0.addr];  // Read from memory
    end
endmodule
