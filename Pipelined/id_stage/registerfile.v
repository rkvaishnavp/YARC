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
input registers_en,
input [31:0] instruction,
input [4:0] waddr,
input wen,
output reg [31:0]rs1data,
output reg [31:0]rs2data
);

reg [31:0] registers [0:31];

assign rs1addr = instruction[19:15];
assign rs2addr = instruction[24:20];

always @(posedge clk) begin
    if(!rst && registers_en) begin
        if(wen) begin
            registers[waddr] = wdata;
        end
        else begin
            rs1data = registers[rs1addr];
            rs2data = registers[rs2addr];
        end
    end
    else if(rst) begin
        registers = 0;
    end
end
endmodule
