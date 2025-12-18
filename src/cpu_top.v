// cpu_top.v
`timescale 1ns / 1ps
module cpu_top(
    input  wire        clk,
    input  wire        reset,
    output wire [31:0] x1,    // exposed for easy debug
    output wire [31:0] x2,
    output wire [31:0] x3,
    output wire [31:0] pc_out,
output wire [31:0] instr_out,
output wire [31:0] alu_out,
output wire        reg_write_out

    
);

    // ---------- PC ----------
    wire [31:0] pc;
    pc PC0 (
        .clk(clk),
        .reset(reset),
        .pc(pc)
    );

    // ---------- Instruction fetch ----------
    wire [31:0] instr;
    instr_mem IMEM (
        .addr(pc),
        .instr(instr)
    );

    // ---------- Decode fields ----------
    wire [6:0] opcode = instr[6:0];
    wire [2:0] funct3 = instr[14:12];
    wire [6:0] funct7 = instr[31:25];

    wire [4:0] rd  = instr[11:7];
    wire [4:0] rs1 = instr[19:15];
    wire [4:0] rs2 = instr[24:20];

    // I-type immediate (sign-extended)
    wire [31:0] imm_i = {{20{instr[31]}}, instr[31:20]};

    // ---------- Register file ----------
    wire [31:0] rd1, rd2;
    wire [31:0] write_data;
    wire        reg_write;

    regfile RF (
        .clk(clk),
        .rs1(rs1),
        .rs2(rs2),
        .rd1(rd1),
        .rd2(rd2),
        .rd(rd),
        .wd(write_data),
        .reg_write(reg_write)
    );

    // ---------- Simple ALU & Control (supports ADDI and ADD) ----------
    // Operation: produce write_data and reg_write combinationally
    reg [31:0] alu_out_r;
    reg        reg_write_r;

    always @(*) begin
        // defaults
        alu_out_r    = 32'd0;
        reg_write_r  = 1'b0;

        case (opcode)
            // ADDI (I-type): opcode = 0010011, funct3 == 000 for ADDI
            7'b0010011: begin
                if (funct3 == 3'b000) begin
                    alu_out_r   = rd1 + imm_i;
                    reg_write_r = 1'b1;
                end else begin
                    // other I-type not supported -> no write
                    alu_out_r   = 32'd0;
                    reg_write_r = 1'b0;
                end
            end

            // R-type (ADD): opcode = 0110011, funct3==000 and funct7==0000000
            7'b0110011: begin
                if (funct3 == 3'b000 && funct7 == 7'b0000000) begin
                    alu_out_r   = rd1 + rd2;
                    reg_write_r = 1'b1;
                end else begin
                    alu_out_r   = 32'd0;
                    reg_write_r = 1'b0;
                end
            end

            default: begin
                alu_out_r   = 32'd0;
                reg_write_r = 1'b0;
            end
        endcase
    end

    // outputs from combinational logic
    assign write_data = alu_out_r;
    assign reg_write  = reg_write_r;

    // ---------- Expose registers for debug ----------
    // Allow easy waveform/console check: x1,x2,x3
    assign x1 = RF.regs[1];
    assign x2 = RF.regs[2];
    assign x3 = RF.regs[3];
assign pc_out        = pc;
assign instr_out     = instr;
assign alu_out       = alu_out_r;
assign reg_write_out = reg_write_r;

endmodule
