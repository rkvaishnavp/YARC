`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2023 11:27:55 PM
// Design Name: 
// Module Name: registers
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

module registers (
input clk,
input rst,

input [31:0] instruction,

input [4:0] waddr,
input [31:0] wdata,

input registers_wen,

output[31:0] rs1data,
output[31:0] rs2data
);

wire[4:0] rs1addr, rs2addr;
assign rs1addr = instruction[19:15];
assign rs2addr = instruction[24:20];

reg [31:0]registers[0:4];

assign rs1data = registers[rs1addr];
assign rs2data = registers[rs2addr];

always @(posedge clk ) begin
    if(!rst) begin
        if(registers_wen) begin
            registers[waddr] <= wdata;
        end
    end
    else begin
        for(integer i=0;i<32;i=i+1) begin
            registers[i] = 0;
        end
    end
end

endmodule
