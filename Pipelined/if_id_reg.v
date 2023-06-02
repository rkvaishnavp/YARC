module if_id_reg(
input clk,
input rst,

input hold_pc,
input [31:0] pc_out,
output reg [31:0] if_id_pc_out
);

always @(posedge clk ) begin
    if(!rst) begin
        if(!hold_pc) begin
            if_id_pc_out = pc_out + 1;
        end
        else begin
            if_id_pc_out = pc_out;
        end
    end
    else begin
        if_id_pc_out = 0;
    end
end
endmodule