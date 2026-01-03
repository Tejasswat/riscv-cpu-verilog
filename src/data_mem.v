module data_mem (
    input  wire        clk,
    input  wire        mem_write,
    input  wire [31:0] addr,
    input  wire [31:0] write_data,
    output wire [31:0] read_data
);
    reg [31:0] mem [0:255];

    assign read_data = mem[addr[9:2]];

    always @(posedge clk) begin
        if (mem_write)
            mem[addr[9:2]] <= write_data;
    end
endmodule
