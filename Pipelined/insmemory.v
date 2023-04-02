`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/03/2023 12:00:06 AM
// Design Name: 
// Module Name: insmmeory
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

module insmemory(
input clk,
input rst,

input insmem_en,
input[31:0] pc_out,

output reg [31:0] instruction
);

reg [31:0]insmemory[0:11];

always @(posedge clk ) begin
    if(!rst) begin
        if(insmem_en) begin
            instruction = insmemory[pc_out];
        end
    end
    else begin
        for(integer i=0;i<12;i=i+1) begin
            insmemory[i] = 0;
        end
    end
end

endmodule