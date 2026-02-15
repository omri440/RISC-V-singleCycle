`timescale 1ns / 1ps

module Risc_V_top_module(
    input clk,
    input rst,
    output [31:0] pc_out,
    output [31:0] instruction,
    output [31:0] read_data1,
    output [31:0] read_data2,
    output [31:0] imm_ext,
    output reg_write_ctrl,
    output [1:0] alu_op_ctrl,
    output [31:0] alu_result,      // נחוץ לטסטבנץ'
    output [31:0] write_back_data  // נחוץ לטסטבנץ'
    );

    // חוטים פנימיים לחיבור המודולים
    wire [31:0] pc_next;
    wire [31:0] alu_input_b, mem_read_data;
    wire [3:0] alu_control_signal;
    wire alu_src, mem_to_reg, mem_read, mem_write, branch, zero_flag;
    wire [31:0] pc_plus_4;      // תוצאת ה-PC+4 הרגיל
    wire [31:0] pc_branch_target; // תוצאת ה-PC + Immediate
    wire pc_sel;

    // 1. PC וקידום
    PC pc_inst (.clk(clk), .rst(rst), .PC_in(pc_next), .PC_out(pc_out));
    PCplus4 pc_plus(.a_in(pc_out) ,.out(pc_plus_4));
    assign pc_next = (pc_sel) ? pc_branch_target : pc_plus_4;
    // 2. זיכרון פקודות אסינכרוני
    // הערה: השתמשתי בשמות הפורטים מהקובץ InstructionMe.v שהעלית
    InstructionMe imem (.rst(rst), .A(pc_out), .InsOut(instruction));

    // 3. יחידת בקרה
    Control control_unit (
        .Opcode(instruction[6:0]),
        .Branch(branch), .MemRead(mem_read), .MemtoReg(mem_to_reg),
        .ALUOp(alu_op_ctrl), .MemWrite(mem_write), .ALUSrc(alu_src), 
        .RegWrite(reg_write_ctrl)
    );

    // 4. קובץ רגיסטרים
    RegFile registers (
        .clk(clk), .rst(rst), .RegWrite(reg_write_ctrl),
        .readReg1(instruction[19:15]), .readReg2(instruction[24:20]), 
        .WriteRegister(instruction[11:7]),
        .WriteData(write_back_data), // המידע שחוזר מה-WB Mux
        .ReadData1(read_data1), .ReadData2(read_data2)
    );

    // 5. מחולל אימידיאט
    ImmGen imm_gen_unit (.instruction(instruction), .ImmExt(imm_ext));


    //
    // 2. חישוב כתובת הקפיצה (מודול חדש)
    Branch_Addr_Calc br_adder (
        .pc_in(pc_out),
        .imm_ext(imm_ext),
        .br_addr_out(pc_branch_target)
    );

    // 3. לוגיקת החלטה (מודול חדש)
    Branch_Logic br_logic (
        .branch_ctrl(branch),
        .alu_zero(zero_flag),
        .pc_src(pc_sel)
    );

    // 4. Mux לבחירת ה-PC הבא
    // אפשר להשתמש במודול ALU_Mux הקיים שלך או ב-Assign פשוט
    // 6. Mux לכניסת ALU
    ALU_Mux alu_mux_inst (
        .ReadData2(read_data2), .ImmExt(imm_ext), 
        .ALUSrc(alu_src), .out(alu_input_b)
    );

    // 7. בקרת ALU
    ALU_Control alu_ctrl_unit (
        .ALUOp(alu_op_ctrl), .fun7(instruction[30]), 
        .fun3(instruction[14:12]), .Control_out(alu_control_signal)
    );

    // 8. יחידת ALU
    ALU_unit alu_inst (
        .A(read_data1), .B(alu_input_b), 
        .ALU_Control(alu_control_signal), 
        .res(alu_result), .zero(zero_flag)
    );

    // 9. זיכרון נתונים (Data Memory)
    DataMemory dmem (
        .clk(clk), .rst(rst), 
        .memWrite(mem_write), .memRead(mem_read), 
        .address(alu_result), .writeData(read_data2), 
        .readData(mem_read_data)
    );

    // 10. Mux לכתיבה חזרה (Write Back)
    WriteBack_Mux wb_mux (
        .ALU_Result(alu_result), .Mem_Data(mem_read_data), 
        .MemtoReg(mem_to_reg), .out(write_back_data)
    );

endmodule