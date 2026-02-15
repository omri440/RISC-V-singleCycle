module PC_tb;
    reg clk, rst;
    reg [31:0] nextPC;
    wire [31:0] PC;

    PC dut(.clk(clk), .rst(rst), .nextPC(nextPC), .PC(PC));

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        nextPC = 0;

        #10 rst = 0;
        repeat (5) begin
            nextPC = PC + 4;
            #10;
        end

        $stop;
    end
endmodule
