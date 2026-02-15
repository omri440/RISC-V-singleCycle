`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
module Branch_Logic(
    input branch_ctrl,      // מה-Control Unit
    input alu_zero,         // מה-ALU
    output pc_src           // בורר עבור ה-Mux
    );
    
    assign pc_src = branch_ctrl & alu_zero;
    
endmodule