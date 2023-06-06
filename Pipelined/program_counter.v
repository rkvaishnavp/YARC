`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/24/2023 03:50:12 AM
// Design Name: 
// Module Name: program_counter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module program_counter(
input clk,
input rst,
input [31:0] pc_in,
output [31:0] pc_out,
output reg [31:0] pc_reg_out,
output reg if_id_ins_valid
);

assign pc_out[31:0] = pc_reg_out;

initial begin
    pc_reg_out = -1;
    if_id_ins_valid = 1;
end

always @(posedge clk) begin
    if(!rst) begin
        pc_reg_out = pc_reg_out + 1;
        if_id_ins_valid = 1;
    end
    else begin
        if_id_ins_valid = 0;
        pc_reg_out = 0;
    end
end
endmodule
