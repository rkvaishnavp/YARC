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

module registers (instruction, clk, wdata, waddr, rs1data, rs2data);
    
    input [31:0] instruction;
    input [4:0] waddr;
    input clk;
    input [31:0] wdata;
    output[31:0] rs1data, rs2data;

    wire[4:0] rs1addr, rs2addr;
    assign rs1addr = instruction[19:15];
    assign rs2addr = instruction[24:20];

    reg [31:0]registers[0:4];
    always @(posedge clk ) begin
        
        if(wen) begin
            wdata <= registers[waddr];
        end
        
        rs1data <= registers[rs1addr];
        rs2data <= registers[rs2addr];

    end
    
endmodule