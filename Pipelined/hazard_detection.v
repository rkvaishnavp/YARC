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
    
    input id_ex_memread,
    
    input [4:0]id_ex_rs1,
    input [4:0]id_ex_rs2,
    input [4:0]id_ex_rd,
    
    output holdpc,
    output pc_write
    
);

always @(*) begin
    
end

endmodule
