`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/24/2023 03:52:26 AM
// Design Name: 
// Module Name: registerfile
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


module registerfile(

input clk,
input rst,
input [31:0] if_id_instruction,
input [4:0] rd,
input [31:0] wdata,
input regwrite,
output reg [31:0]rs1data,
output reg [31:0]rs2data
);

reg [31:0] registers [0:31];

assign rs1addr = if_id_instruction[19:15];
assign rs2addr = if_id_instruction[24:20];

always @(posedge clk) begin
    if(!rst) begin
        if(regwrite) begin
            registers[rd] = wdata;
        end
        else begin
            rs1data = registers[rs1addr];
            rs2data = registers[rs2addr];
        end
    end
end
endmodule
