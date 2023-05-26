`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/24/2023 04:46:16 AM
// Design Name: 
// Module Name: control
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


module control(
input clk,
input rst,

input [31:0]if_id_instruction,


output reg id_ex_memread,
output reg id_ex_memwrite,
output reg id_ex_mem_to_reg,

output reg id_ex_pc_src,

output reg[4:0] id_ex_rd,
output reg id_ex_instruction1,
output reg id_ex_regwrite

output reg id_ex_branch,
output reg[8:0] id_ex_instype,
output reg[7:0] id_ex_subtype
);




always @(posedge clk ) begin
    if(!rst) begin
        case (if_id_instruction[6:2])
            5'b01100 : begin
                id_ex_instype = 9'b000000001;  //register  rd = rs1 op rs2
                id_ex_branch =
                id_ex_subtype =

                id_ex_memread =
                id_ex_memwrite =
                id_ex_mem_to_reg =

                id_ex_pc_src =

                id_ex_rd =
                id_ex_instruction1 =
                id_ex_regwrite
            end
            5'b00100 : begin
                id_ex_instype = 9'b000000010;  //immediate rd = rs1 op Iimm
                id_ex_branch = 0;
            end
            5'b01000 : begin
                id_ex_instype = 9'b000000100;  //store     datamemory[rs1+Simm] = rs2(8,16,32)
                id_ex_branch = 0;
            end
            5'b00000 : begin
                id_ex_instype = 9'b000001000;  //load      rd = datamemory[rs1+Iimm](8,16,32)
                id_ex_branch = 0;
            end
            5'b11000 : begin
                id_ex_instype = 9'b000010000;  //branch    if(rs1 op rs2) then programcounter = programcounter + 4 + Bimm
                id_ex_branch = 1;
            end
            5'b01101 : begin
                id_ex_instype = 9'b000100000;  //lui       rd = Uimm
                id_ex_branch = 0;
            end
            5'b00101 : begin
                id_ex_instype = 9'b001000000;  //auipc     rd = programcounter + Uimm
                id_ex_branch = 0;
            end
            5'b11011 : begin
                id_ex_instype = 9'b010000000;  //jal       rd = programcounter + 4 //programcounter = programcounter + Jimm
                id_ex_branch = 1;
            end
            5'b11001 : begin
                id_ex_instype = 9'b100000000;  //jalr      rd = programcounter + 4 //programcounter = rs1 + Iimm
                id_ex_branch = 1;
            end
            default : begin
                id_ex_instype = 9'b0;
                id_ex_branch = 0;
            end
        endcase
        
        if (if_id_instruction[6:2] == 5'b01000) begin
            
        end
        else if(if_id_instruction[6:2] == 5'b00000) begin
            
        end

        id_ex_subtype = 8'b00000001 << id_ex_instruction[14:12];
        id_ex_rd = if_id_instruction[11:7];
        id_ex_instruction1 = if_id_instruction[30];
    end
    else begin
        
    end
end

endmodule
