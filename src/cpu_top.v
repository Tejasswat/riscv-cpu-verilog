// cpu_top.v
`timescale 1ns / 1ps

module cpu_top(
    input  wire        clk,
    input  wire        reset,
    output wire [31:0] x1,
    output wire [31:0] x2,
    output wire [31:0] x3,
    output wire [31:0] pc_out,
    output wire [31:0] instr_out,
    output wire [31:0] alu_out,
    output wire        reg_write_out
);

    // =====================================================
    // 1. SIGNAL DECLARATIONS
    // =====================================================

    // PC
    wire [31:0] pc;
    reg  [31:0] pc_next;

    // Instruction
    wire [31:0] instr;

    // Decode fields
    wire [6:0] opcode = instr[6:0];
    wire [2:0] funct3 = instr[14:12];
    wire [6:0] funct7 = instr[31:25];
    wire [4:0] rd     = instr[11:7];
    wire [4:0] rs1    = instr[19:15];
    wire [4:0] rs2    = instr[24:20];

    // Immediates
    wire [31:0] imm_i = {{20{instr[31]}}, instr[31:20]};
    wire [31:0] imm_b = {{19{instr[31]}},
                         instr[31],
                         instr[7],
                         instr[30:25],
                         instr[11:8],
                         1'b0};
    // S-type immediate (for SW)
    wire [31:0] imm_s = {{20{instr[31]}},
                         instr[31:25],
                         instr[11:7]};
                         
    // J-type immediate (for JAL)
    wire [31:0] imm_j = {{11{instr[31]}},
                         instr[31],
                         instr[19:12],
                         instr[20],
                         instr[30:21],
                         1'b0};
                         
                         

    // Register file
    wire [31:0] rd1;
    wire [31:0] rd2;
    wire [31:0] write_data;
    wire reg_write;

    // ALU / control
    reg  [31:0] alu_out_r;
    reg         reg_write_r;
    reg         mem_to_reg;

    // Data memory
    wire [31:0] mem_read_data;
    wire mem_write;
    reg mem_write_r;
    
    // =====================================================
    // 2. MODULE INSTANTIATIONS
    // =====================================================

    // PC
    pc PC0 (
        .clk(clk),
        .reset(reset),
        .pc_next(pc_next),
        .pc(pc)
    );

    // Instruction memory
    instr_mem IMEM (
        .addr(pc),
        .instr(instr)
    );

    // Register file
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

    // Data memory
    data_mem DMEM (
        .clk(clk),
        .mem_write(mem_write),
        .addr(alu_out_r),
        .write_data(rd2),
        .read_data(mem_read_data)
    );

    // =====================================================
    // 3. CONTROL / DECODE LOGIC
    // =====================================================

    always @(*) begin
        // ---------- defaults ----------
        alu_out_r   = 32'd0;
        reg_write_r = 1'b0;
        mem_to_reg  = 1'b0;
        pc_next     = pc + 32'd4;
        mem_write_r = 1'b0;   // default: no memory write


        case (opcode)

            // ADDI
            7'b0010011: begin
                if (funct3 == 3'b000) begin
                    alu_out_r   = rd1 + imm_i;
                    reg_write_r = 1'b1;
                end
            end

            // R-type ALU
            7'b0110011: begin
                if (funct3 == 3'b000 && funct7 == 7'b0000000) begin
                    alu_out_r   = rd1 + rd2; // ADD
                    reg_write_r = 1'b1;
                end else if (funct3 == 3'b000 && funct7 == 7'b0100000) begin
                    alu_out_r   = rd1 - rd2; // SUB
                    reg_write_r = 1'b1;
                end else if (funct3 == 3'b111) begin
                    alu_out_r   = rd1 & rd2; // AND
                    reg_write_r = 1'b1;
                end else if (funct3 == 3'b110) begin
                    alu_out_r   = rd1 | rd2; // OR
                    reg_write_r = 1'b1;
                end else if (funct3 == 3'b100) begin
                    alu_out_r   = rd1 ^ rd2; // XOR
                    reg_write_r = 1'b1;
                end else if (funct3 == 3'b001) begin
                    alu_out_r   = rd1 << rd2[4:0]; // SLL
                    reg_write_r = 1'b1;
                end else if (funct3 == 3'b101 && funct7 == 7'b0000000) begin
                    alu_out_r   = rd1 >> rd2[4:0]; // SRL
                    reg_write_r = 1'b1;
                end else if (funct3 == 3'b101 && funct7 == 7'b0100000) begin
                    alu_out_r   = $signed(rd1) >>> rd2[4:0]; // SRA
                    reg_write_r = 1'b1;
                end
            end

            // BEQ / BNE / BLT
            7'b1100011: begin
                if (funct3 == 3'b000) begin // BEQ
                    if (rd1 == rd2)
                        pc_next = pc + imm_b;
                end else if (funct3 == 3'b001) begin // BNE
                    if (rd1 != rd2)
                        pc_next = pc + imm_b;
                end else if (funct3 == 3'b100) begin // BLT
                        if ($signed(rd1) < $signed(rd2))
                            pc_next = pc + imm_b;
                end else if (funct3 == 3'b101) begin // BGE
                        if ($signed(rd1) >= $signed(rd2))
                            pc_next = pc + imm_b;
                end else if (funct3 == 3'b110) begin // BLTU
                        if (rd1 < rd2)
                            pc_next = pc + imm_b;
                end else if (funct3 == 3'b111) begin // BGEU
                        if (rd1 >= rd2)
                            pc_next = pc + imm_b;
                end
                reg_write_r = 1'b0;
            end

            // LW
            7'b0000011: begin
                if (funct3 == 3'b010) begin
                    alu_out_r   = rd1 + imm_i; // address
                    reg_write_r = 1'b1;
                    mem_to_reg  = 1'b1;
                end
            end
            //SW
            7'b0100011: begin   // STORE instructions
                if (funct3 == 3'b010) begin // SW
                    alu_out_r    = rd1 + imm_s;  // address calculation
                    mem_write_r = 1'b1;          // enable memory write
                    reg_write_r = 1'b0;          // no register write
                    mem_to_reg  = 1'b0;          // irrelevant, but safe
                end
            end
            //JAL
            7'b1101111: begin
                alu_out_r   = pc + 32'd4;   
                reg_write_r = 1'b1;         
                mem_to_reg  = 1'b0;         
                pc_next     = pc + imm_j;   
            end
            
            //JALR
            7'b1100111: begin
                if (funct3 == 000) begin
                    alu_out_r   = pc + 32'd4;   
                    reg_write_r = 1'b1;         
                    mem_to_reg  = 1'b0;         
                    pc_next     = (rd1 + imm_i) & ~32'd1;   
                end
            end
            

        endcase
    end

    // =====================================================
    // 4. WRITEBACK / FIXED ASSIGNS
    // =====================================================

    assign write_data = mem_to_reg ? mem_read_data : alu_out_r;
    assign reg_write  = reg_write_r;
    assign mem_write = mem_write_r;


    // =====================================================
    // 5. DEBUG OUTPUTS
    // =====================================================

    assign x1 = RF.regs[1];
    assign x2 = RF.regs[2];
    assign x3 = RF.regs[3];

    assign pc_out        = pc;
    assign instr_out     = instr;
    assign alu_out       = alu_out_r;
    assign reg_write_out = reg_write_r;

endmodule
