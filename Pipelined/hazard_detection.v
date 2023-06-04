`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/24/2023 03:52:26 AM
// Design Name: 
// Module Name: hazarddetection
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


module hazard_detection(
    input [31:0] if_id_instruction,
    input rst,

    input id_ex_memread,
    input mem_wb_regwrite,

    input [4:0]id_ex_rs1,
    input [4:0]id_ex_rs2,
    input [4:0]id_ex_rd,
    
    output reg holdpc    
);
assign if_id_rs1 = if_id_instruction[19:15];
assign if_id_rs2 = if_id_instruction[24:20];
assign if_id_rd = if_id_instruction[11:7];

localparam jalr = 5'b11001;
localparam jal = 5'b11011;
localparam branch = 5'b11000;

assign jump_condition = (if_id_instruction[6:2] == jalr) || (if_id_instruction[6:2] == jalr) || (if_id_instruction[6:2] == branch);

initial begin
    holdpc = 0;
end

always @(*) begin
    if(!rst) begin
        if(jump_condition) begin
            holdpc = 1;
        end
        else if(mem_wb_regwrite) begin
            holdpc = 1;
        end
    end
    else begin
        holdpc = 0;
    end
end

endmodule
