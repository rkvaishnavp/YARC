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
input holdpc,
input [31:0] pc_in,
output [31:0] pc_out,
output reg [31:0] pc_reg_out
);

reg [31:0] pc = 0;

assign pc_out[31:0] = pc;

always @(posedge clk) begin
    if(!rst) begin
        if(!holdpc) begin
            pc = pc + 1;
        end
        else begin
            pc = pc;
        end
        pc_reg_out = pc;
    end
    else begin
        pc = 0;
    end
end
endmodule
