module id_ex_reg(
    input clk,
    input rst,

    input[31:0] if_id_instruction,

    output reg[4:0] id_ex_rs1addr,
    output reg[4:0] id_ex_rs2addr,
    output reg[4:0] id_ex_rdaddr
);

always @(posedge clk ) begin
    if(!rst) begin
        id_ex_rs1addr = instruction[19:15];
        id_ex_rs2addr = instruction[24:20];
        id_ex_rdaddr = isntruction[11:7];
    end
    else begin
        id_ex_rs1addr = 0;
        id_ex_rs2addr = 0;
        id_ex_rdaddr = 0;
    end
end

endmodule