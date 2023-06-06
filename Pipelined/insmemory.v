module insmemory(if_id_instruction, pc_out, clk);

output reg [31:0] if_id_instruction;
input[31:0] pc_out;
input clk;

reg [31:0]insmemory[0:31];

initial begin
    insmemory[0] = 32'b00000000000000000000000000110011;    //add zero,zero,zero
end

always @(posedge clk ) begin
    if_id_instruction = insmemory[pc_out];
end

endmodule