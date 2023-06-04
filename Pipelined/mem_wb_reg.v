module mem_wb_reg(
    input clk,
    input rst,

    input[4:0] ex_mem_rs1,
    input[4:0] ex_mem_rs2,
    input[4:0] ex_mem_rd,
    input ex_mem_mem_to_reg,
    input ex_mem_regwrite,
    input [31:0]aluout1,
    input [31:0]aluout2,

    output reg[4:0] mem_wb_rs1,
    output reg[4:0] mem_wb_rs2,
    output reg[4:0] mem_wb_rd,
    output reg mem_wb_mem_to_reg,
    output reg mem_wb_regwrite,
    output reg[31:0] mem_wb_aluout1,
    output reg[31:0] mem_wb_aluout2
);

initial begin
    mem_wb_rs1 = 0;
    mem_wb_rs2 = 0;
    mem_wb_rd = 0;
    mem_wb_mem_to_reg = 0;
    mem_wb_regwrite = 0;
    mem_wb_aluout1 = 0;
    mem_wb_aluout2 = 0;        
end

always @(posedge clk ) begin
    if(!rst) begin
        mem_wb_rs1 = ex_mem_rs1;
        mem_wb_rs2 = ex_mem_rs2;
        mem_wb_rd = ex_mem_rd;
        mem_wb_mem_to_reg = ex_mem_mem_to_reg;
        mem_wb_regwrite = ex_mem_regwrite;
        mem_wb_aluout1 = aluout1;
        mem_wb_aluout2 = aluout2;        
    end
    else begin
        mem_wb_rs1 = 0;
        mem_wb_rs2 = 0;
        mem_wb_rd = 0;
        mem_wb_mem_to_reg = 0;
        mem_wb_regwrite = 0;
        mem_wb_aluout1 = 0;
        mem_wb_aluout2 = 0;        
    end
end

endmodule