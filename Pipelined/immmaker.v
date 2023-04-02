`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2023 11:27:55 PM
// Design Name: 
// Module Name: immmaker
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

module immmaker (
    input clk,
    input[31:0] instruction,
    output reg [31:0] imm
);
always @(posedge clk ) begin
    case(instruction[6:2])
        5'b00100 : imm = {{21{instruction[31]}},instruction[30:25],instruction[24:21],instruction[20]};                         //immediate rd = rs1 op Iimm
        5'b01000 : imm = {{21{instruction[31]}},instruction[30:25],instruction[11:8],instruction[7]};                           //store     datamemory[rs1+Simm] = rs2(8,16,32)
        5'b00000 : imm = {{21{instruction[31]}},instruction[30:25],instruction[24:21],instruction[20]};                         //load      rd = datamemory[rs1+Iimm](8,16,32)
        5'b11000 : imm = {{20{instruction[31]}},instruction[7],instruction[30:25],instruction[11:8],1'b0};                      //branch    if(rs1 op rs2) then programcounter = programcounter + 4 + Bimm
        5'b01101 : imm = {instruction[31:12],12'b0};                                                                            //lui       rd = Uimm
        5'b00101 : imm = {instruction[31:12],12'b0};                                                                            //auipc     rd = programcounter + Uimm
        5'b11011 : imm = {{12{instruction[31]}},instruction[19:12],instruction[20],instruction[30:25],instruction[24:21],1'b0}; //jal       rd = programcounter + 4 //programcounter = programcounter + Jimm
        5'b11001 : imm = {{21{instruction[31]}},instruction[30:25],instruction[24:21],instruction[20]};                         //jalr      rd = programcounter + 4 //programcounter = rs1 + Iimm
        default  : imm = 32'b0;
    endcase
end
endmodule