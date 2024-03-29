`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/24/2023 03:52:26 AM
// Design Name: 
// Module Name: forwarding_unit
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


module forwarding_unit(
input clk,
input rst,
input [4:0]id_ex_rs1,
input [4:0]id_ex_rs2,
input [4:0]ex_mem_rd,
input [4:0]mem_wb_rd,
input ex_mem_ins_valid,
input mem_wb_ins_valid,
output reg [1:0] rs1_forward,
output reg [1:0] rs2_forward
);


always @(posedge clk) begin
    if(!rst) begin
        {rs1_forward,rs2_forward} = 0;
        
        if(ex_mem_ins_valid && ex_mem_rd == id_ex_rs1) begin
            rs1_forward = 2'b01;
        end
        else if(mem_wb_ins_valid && mem_wb_rd == id_ex_rs1) begin
            rs1_forward = 2'b10;
        end
    
        if(ex_mem_ins_valid && ex_mem_rd == id_ex_rs2) begin
            rs2_forward = 2'b01;
        end
        else if(mem_wb_ins_valid && mem_wb_rd == id_ex_rs2) begin
            rs2_forward = 2'b10;
        end
    end
    else begin
        rs1_forward = 2'b11;
        rs2_forward = 2'b11;
    end
end
endmodule
