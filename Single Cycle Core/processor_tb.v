module processor_tb;

reg clk, rst;
wire clk;

always #5 clk = ~clk;

initial begin
    
end
endmodule