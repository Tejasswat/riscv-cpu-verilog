`timescale 1ns / 1ps

module instr_mem(
    input  wire [31:0] addr,   // Byte address
    output wire [31:0] instr
);

    reg [31:0] mem [0:255];
    integer i;

    initial begin
        // =================================================
        // Test Program
        // =================================================

        // x1 = 0
        mem[0] = 32'h00000093; // addi x1, x0, 0

        // x2 = 10
        mem[1] = 32'h00A00113; // addi x2, x0, 10

        // store x2 into mem[0]
        mem[2] = 32'h0020A023; // sw x2, 0(x1)

        // load mem[0] into x3
        mem[3] = 32'h0000A183; // lw x3, 0(x1)

        // if x2 == x3, branch to label
        mem[4] = 32'h00310463; // beq x2, x3, +8

        // should be skipped if branch works
        mem[5] = 32'h00118193; // addi x3, x3, 1

        // jump over next instruction
        mem[6] = 32'h008000EF; // jal x1, +8

        // should be skipped if JAL works
        mem[7] = 32'h00120213; // addi x4, x4, 1

        // jump target
        mem[8] = 32'h00500293; // addi x5, x0, 5

        // =================================================
        // Fill rest with NOPs
        // =================================================
        for (i = 9; i < 256; i = i + 1)
            mem[i] = 32'h00000013; // NOP
    end

    // Word-aligned access
    assign instr = mem[addr[9:2]];

endmodule
