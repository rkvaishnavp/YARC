module insmemory(instruction, pc_out, clk);

output reg [31:0] instruction;
input[31:0] pc_out;
input clk;

reg [31:0]insmemory[0:31];
always @(posedge clk ) begin
    if(insmem_pc) begin
        instruction <= insmemory[pc_out];
    end
end

endmodule