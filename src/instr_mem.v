`timescale 1ns / 1ps

module instr_mem(
    input  wire [31:0] addr,   // Byte address
    output wire [31:0] instr   // Instruction output
);

    // Instruction memory: 256 words
    reg [31:0] mem [0:255];

    integer i;

    initial begin
        // Program:
        // 0: addi x1, x0, 5   -> x1 = 5
        // 1: addi x2, x1, 3   -> x2 = 8
        // 2: add  x3, x2, x2  -> x3 = 16

        mem[0] = 32'h00500093;  // addi x1, x0, 5
        mem[1] = 32'h00308113;  // addi x2, x1, 3
        mem[2] = 32'h002101B3;  // add  x3, x2, x2

        // Fill the rest with NOP (addi x0,x0,0)
        for (i = 3; i < 256; i = i + 1)
            mem[i] = 32'h00000013;
    end

    // Word-aligned access: drop lowest 2 bits
    assign instr = mem[addr[9:2]];

endmodule
