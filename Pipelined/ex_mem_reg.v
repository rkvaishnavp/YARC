module ex_mem_reg(
    input clk,
    input rst,

    input id_ex_memread,
    input id_ex_memwrite,
    input id_ex_mem_to_reg,
    input id_ex_pc_src,
    input[4:0] id_ex_rd,
    input id_ex_regwrite,
    input id_ex_ins_valid,

    output reg ex_mem_memread,
    output reg ex_mem_memwrite,
    output reg ex_mem_mem_to_reg,
    output reg ex_mem_pc_src,
    output reg[4:0] ex_mem_rd,
    output reg ex_mem_regwrite,
    output reg ex_mem_ins_valid,
    
    
    input[4:0] id_ex_rs1,
    input[4:0] id_ex_rs2,

    output reg[4:0] ex_mem_rs1,
    output reg[4:0] ex_mem_rs2
);

always @(posedge clk ) begin
    if(!rst) begin
        ex_mem_rs1 = id_ex_rs1;
        ex_mem_rs2 = id_ex_rs2;
        ex_mem_rd = id_ex_rd;
        
        ex_mem_memread = id_ex_memread;
        ex_mem_memwrite = id_ex_memwrite;
        ex_mem_mem_to_reg = id_ex_mem_to_reg;
        ex_mem_pc_src = id_ex_pc_src;
        ex_mem_rd = id_ex_rd;
        ex_mem_regwrite = id_ex_regwrite;   
        ex_mem_ins_valid = id_ex_ins_valid;         
    end
    else begin
        ex_mem_rs1 = 0;
        ex_mem_rs2 = 0;
        ex_mem_rd = 0;
        
        ex_mem_memread = 0;
        ex_mem_memwrite = 0;
        ex_mem_mem_to_reg = 0;
        ex_mem_pc_src = 0;
        ex_mem_rd = 0;
        ex_mem_regwrite = 0;
        ex_mem_ins_valid = 0;         
    end
end

endmodule