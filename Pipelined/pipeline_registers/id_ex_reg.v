module id_ex_reg(
    input clk,
    input rst,

    input[31:0] if_id_instruction,
    input[31:0] if_id_pc_out,
    
    output reg[4:0] id_ex_rs1,
    output reg[4:0] id_ex_rs2,
    output reg[4:0] id_ex_rd,
    
    output reg[31:0] id_ex_pc_out
);

always @(posedge clk ) begin
    if(!rst) begin
        id_ex_rs1 = if_id_instruction[19:15];
        id_ex_rs2 = if_id_instruction[24:20];
        id_ex_rd = if_id_instruction[11:7];
        id_ex_pc_out = if_id_pc_out;
    end
    else begin
        id_ex_rs1 = 0;
        id_ex_rs2 = 0;
        id_ex_rd = 0;
        id_ex_pc_out = 0;
    end
end

endmodule