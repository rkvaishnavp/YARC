module ex_mem_reg(
    input clk,
    input rst,

    input[4:0] id_ex_rs1addr,
    input[4:0] id_ex_rs2addr,
    input[4:0] id_ex_rdaddr,

    output reg[4:0] ex_mem_rs1addr,
    output reg[4:0] ex_mem_rs2addr,
    output reg[4:0] ex_mem_rdaddr
);

always @(posedge clk ) begin
    if(!rst) begin
        ex_mem_rs1addr = id_ex_rs1addr;
        ex_mem_rs2addr = id_ex_rs2addr;
        ex_mem_rdaddr = id_ex_rdaddr;
    end
    else begin
        ex_mem_rs1addr = 0;
        ex_mem_rs2addr = 0;
        ex_mem_rdaddr = 0;
    end
end

endmodule