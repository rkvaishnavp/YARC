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
input hold_pc,
input pc_write,
input [31:0] pc_in,
output [31:0] pc_out,
output reg [31:0] pc_reg_out
);

assign pc_out = pc_reg_out;

always @(posedge clk) begin
    if(!rst) begin
        if(!pc_write) begin
            if(!hold_pc) begin
                pc_reg_out = pc_reg_out + 1;
            end
            else begin
                pc_reg_out = pc_reg_out;
            end
        end
        else begin
            pc_reg_out = pc_in;
        end
    end
    else begin
        pc_reg_out = 0;
    end
end
endmodule
