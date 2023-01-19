module programcounter (clk, rst, pc_in, pc_out, next_pc_out);

input clk, rst;
input[31:0] pc_in;
output [31:0] pc_out;
output reg[31:0] next_pc_out;

assign pc_out = pc_in;
always @(posedge clk ) begin
    next_pc_out <= pc_out + 32'b1;        
end
endmodule