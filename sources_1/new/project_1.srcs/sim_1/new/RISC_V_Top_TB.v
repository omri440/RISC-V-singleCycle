`timescale 1ns / 1ps

module RISC_V_Top_TB();
    reg clk;
    reg rst;

    // חיבור המעבד
    RISC_V_Top UUT (
        .clk(clk),
        .rst(rst)
    );

    // יצירת שעון
    always #5 clk = ~clk;

    initial begin
        // --- שלב א': טעינת הפקודות לזיכרון ---
        // אנחנו ניגשים למערך שנמצא בתוך ההיררכיה של UUT
        UUT.inst_mem.I_Mem[0] = 32'h00a00093; // addi x1, x0, 10
        UUT.inst_mem.I_Mem[1] = 32'h01400113; // addi x2, x0, 20
        UUT.inst_mem.I_Mem[2] = 32'h002081b3; // add x3, x1, x2
        UUT.inst_mem.I_Mem[3] = 32'h00302223; // sw x3, 4(x0)
        UUT.inst_mem.I_Mem[4] = 32'h00402203; // lw x4, 4(x0)
        UUT.inst_mem.I_Mem[5] = 32'h401202b3; // sub x5, x4, x1
        UUT.inst_mem.I_Mem[6] = 32'h0020f333; // and x6, x1, x2
        UUT.inst_mem.I_Mem[7] = 32'h0020e3b3; // or x7, x1, x2
        UUT.inst_mem.I_Mem[8] = 32'h00108263; // beq x1, x1, 4 (קפיצה לפקודה 10)
        UUT.inst_mem.I_Mem[9] = 32'h06300413; // addi x8, x0, 99 (דילוג!)

        // --- שלב ב': הרצת המעבד ---
        clk = 0;
        rst = 1;      // איפוס
        #15 rst = 0;  // שחרור איפוס
        
        // הרצה למשך 200ns (מספיק ל-10 פקודות בשעון של 10ns)
        #200; 
        
        $display("Done! Check the waveforms.");
        $stop;
    end
endmodule