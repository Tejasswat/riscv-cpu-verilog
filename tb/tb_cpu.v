`timescale 1ns / 1ps

module tb_cpu_top;

    // Inputs
    reg clk;
    reg reset;

    // Outputs from CPU (ports)
    wire [31:0] x1;
    wire [31:0] x2;
    wire [31:0] x3;
    wire [31:0] pc_out;
    wire [31:0] instr_out;
    wire [31:0] alu_out;
    wire        reg_write_out;

    // Instantiate DUT
    cpu_top dut (
        .clk(clk),
        .reset(reset),
        .x1(x1),
        .x2(x2),
        .x3(x3),
        .pc_out(pc_out),
        .instr_out(instr_out),
        .alu_out(alu_out),
        .reg_write_out(reg_write_out)
    );

    // -------------------------------------------------
    // INTERNAL SIGNAL VISIBILITY (branch + ALU + mem)
    // -------------------------------------------------
    wire [31:0] pc_next     = dut.pc_next;
    wire [31:0] rd1         = dut.rd1;
    wire [31:0] rd2         = dut.rd2;
    wire [31:0] write_data = dut.write_data;

    wire        mem_to_reg = dut.mem_to_reg;
    wire        mem_write  = dut.mem_write;

    wire [6:0]  opcode = dut.opcode;
    wire [2:0]  funct3 = dut.funct3;

    // Clock generation: 10 ns period
    always #5 clk = ~clk;

    initial begin
        clk   = 0;
        reset = 1;

        // Hold reset
        #20;
        reset = 0;

        // Run long enough for branches + jumps + immediates
        #600;

        $finish;
    end

    // Optional waveform dump (for non-Vivado simulators)
    initial begin
        $dumpfile("cpu_waveform.vcd");
        $dumpvars(0, tb_cpu_top);
    end

endmodule
