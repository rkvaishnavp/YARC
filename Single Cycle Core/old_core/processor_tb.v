module processor_tb;

reg rst, clk;
wire pc;
processor processor_test(pc , rst, clk);
initial begin
    rst = 0;
    clk = 0;
    $monitor("time = %d, pc = %d, rst = %d, clk = %d",$time, pc, rst, clk);
    clk = ~clk;
    #5 clk = ~clk;
    #5 clk = ~clk;
    #5 clk = ~clk;
end
endmodule