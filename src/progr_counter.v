// pc.v
`timescale 1ns / 1ps
module pc (
    input  wire        clk,
    input  wire        reset,
    output reg  [31:0] pc
);
    always @(posedge clk or posedge reset) begin
        if (reset)
            pc <= 32'd0;
        else
            pc <= pc + 32'd4;
    end
endmodule
