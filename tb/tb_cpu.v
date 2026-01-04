`timescale 1ns / 1ps

module tb_cpu_top;

    // ----------------------------
    // Inputs
    // ----------------------------
    reg clk;
    reg reset;

    // ----------------------------
    // Outputs from CPU (ports)
    // ----------------------------
    wire [31:0] x1;
    wire [31:0] x2;
    wire [31:0] x3;
    wire [31:0] pc_out;
    wire [31:0] instr_out;
    wire [31:0] alu_out;
    wire        reg_write_out;

    // ----------------------------
    // Instantiate DUT
    // ----------------------------
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

    // ----------------------------
    // Internal signal visibility
    // (Datapath + Control)
    // ----------------------------
    wire [31:0] pc_next     = dut.pc_next;

    wire [31:0] rd1         = dut.rd1;
    wire [31:0] rd2         = dut.rd2;
    wire [31:0] write_data  = dut.write_data;

    wire        mem_write   = dut.mem_write;
    wire        mem_to_reg  = dut.mem_to_reg;

    wire [6:0]  opcode      = dut.opcode;
    wire [2:0]  funct3      = dut.funct3;

    // ----------------------------
    // Clock generation
    // ----------------------------
    always #5 clk = ~clk;   // 10 ns period

    // ----------------------------
    // Test sequence
    // ----------------------------
    initial begin
        clk   = 1'b0;
        reset = 1'b1;

        // Hold reset
        #20;
        reset = 1'b0;

        // Run long enough to execute full program
        #800;

        $finish;
    end

    // ----------------------------
    // Waveform dump (for non-Vivado simulators)
    // ----------------------------
    initial begin
        $dumpfile("rv32i_cpu_waveform.vcd");
        $dumpvars(0, tb_cpu_top);
    end

endmodule
