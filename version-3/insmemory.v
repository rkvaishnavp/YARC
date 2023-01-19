module insmemory(instruction, pc_out, clk);

output reg [31:0] instruction;
input[31:0] pc_out;
input clk;

reg [31:0]insmemory[0:31];
initial begin
    insmemory[0] = 32'b1;
    insmemory[1] = 32'h00000000;
end
always @(posedge clk ) begin
    if(insmem_pc) begin
        instruction <= insmemory[pc_out];
    end
end

endmodule