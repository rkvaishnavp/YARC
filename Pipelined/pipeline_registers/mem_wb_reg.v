module mem_wb_reg(
    input clk,
    input rst,

    input[4:0] ex_mem_rs1addr,
    input[4:0] ex_mem_rs2addr,
    input[4:0] ex_mem_rdaddr,

    output reg[4:0] mem_wb_rs1addr,
    output reg[4:0] mem_wb_rs2addr,
    output reg[4:0] mem_wb_rdaddr
);

always @(posedge clk ) begin
    if(!rst) begin
        mem_wb_rs1addr = ex_mem_rs1addr;
        mem_wb_rs2addr = ex_mem_rs2addr;
        mem_wb_rdaddr = ex_mem_rdaddr;
    end
    else begin
        mem_wb_rs1addr = 0;
        mem_wb_rs2addr = 0;
        mem_wb_rdaddr = 0;
    end
end

endmodule