`timescale 1ns / 1ps

module Risc_V_Top_TB();
    reg clk;
    reg rst;
    
    wire [31:0] pc, ins, r1, r2, imm, alu_res, wb_data;
    wire rw;
    wire [1:0] aluop;
    
    // Instantiate UUT
    Risc_V_top_module uut (
        .clk(clk), .rst(rst), .pc_out(pc), .instruction(ins), 
        .read_data1(r1), .read_data2(r2), .imm_ext(imm), 
        .reg_write_ctrl(rw), .alu_op_ctrl(aluop),
        .alu_result(alu_res), .write_back_data(wb_data)
    );
    
    always #5 clk = ~clk;
    
    initial begin
        $display("\n========================================");
        $display("RISC-V Processor Test with BRANCH");
        $display("========================================\n");
        
        clk = 0; rst = 1;
        
        // --- טעינת תוכנית כולל Branch ---
        uut.imem.mem[0] = 32'h00F00093; // 0x00: ADDI x1, x0, 15
        uut.imem.mem[1] = 32'h002081B3; // 0x04: ADD  x3, x1, x2 (15+100=115)
        uut.imem.mem[2] = 32'h00112223; // 0x08: SW   x1, 4(x2)
        uut.imem.mem[3] = 32'h00412203; // 0x0C: LW   x4, 4(x2)
        
        // פקודת Branch: אם x1 == x4 (שניהם 15), קפוץ 2 פקודות קדימה (לכתובת 0x18)
        // BEQ x1, x4, offset 8 -> 0x00408463
        uut.imem.mem[4] = 32'h00408463; 
        
        // פקודה בכתובת 0x14 - המעבד אמור לדלג עליה!
        uut.imem.mem[5] = 32'h01F00F93; // ADDI x31, x0, 31 (Should be skipped)

        $display("[%0t] Program loaded with BEQ at 0x10", $time);
        
        #20;
        @(negedge clk); #2; rst = 0;
        
        // אתחול x2 ל-100
        force uut.registers.registers[2] = 32'd100;
        #1; release uut.registers.registers[2];

        @(posedge clk); // Execution Start
        
        // --- Cycles 1-4 (אותו דבר כמו קודם) ---
        repeat(4) @(posedge clk);
        #1;
        
        // === Clock Cycle 5: Execute BEQ ===
        $display("[%0t] Cycle 5 - Executing BEQ x1, x4, offset 8", $time);
        $display("  PC             : 0x%h", pc);
        $display("  Instruction    : 0x%h", ins);
        $display("  rs1 (x1) value : %0d", r1);
        $display("  rs2 (x4) value : %0d", r2);
        $display("  Branch Offset  : %0d", imm);
        $display("  ALU Zero Flag  : %b", uut.zero_flag);
        $display("  Branch Taken   : %b", uut.pc_sel);
        
        @(posedge clk);
        #1;
        $display("[%0t] Cycle 6 - After Branch", $time);
        $display("  New PC         : 0x%h (Expected 0x18 if taken)", pc);

        if (pc == 32'h18)
            $display("✓ PASS: Branch taken successfully to 0x18");
        else
            $display("✗ FAIL: Branch not taken or wrong address. PC is 0x%h", pc);

        #50;
        $finish;
    end
endmodule