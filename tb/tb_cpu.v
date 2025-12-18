`timescale 1ns / 1ps
module cpu_tb();

    reg clk;
    reg reset;

    // CPU outputs exposed for easy debugging
    wire [31:0] x1, x2, x3;           // registers
    wire [31:0] pc_out, instr_out, alu_out;  // internal signals
    wire        reg_write_out;               

    // Instantiate CPU
    cpu_top DUT (
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

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 10ns period
    end

    initial begin
        $display("===== CPU TEST START =====");
        reset = 1;
        #20;
        reset = 0;

        // run simulation
        #200;

        // print register values
        $display("x1=%0d x2=%0d x3=%0d", x1, x2, x3);
        $display("===== CPU TEST END =====");
        $finish;
    end

endmodule
