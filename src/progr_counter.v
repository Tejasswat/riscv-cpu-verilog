// pc.v
`timescale 1ns / 1ps

module pc (
    input  wire        clk,
    input  wire        reset,
    input  wire [31:0] pc_next,   // next PC decided by control logic
    output reg  [31:0] pc
);
    always @(posedge clk or posedge reset) begin
        if (reset)
            pc <= 32'd0;
        else
            pc <= pc_next;
    end
endmodule
