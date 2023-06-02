`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/24/2023 03:52:26 AM
// Design Name: 
// Module Name: exeunit
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


module exeunit(
input clk,
input rst,

input[8:0] id_ex_instype,
input[7:0] id_ex_subtype,

input[31:0] id_ex_rs1data,
input[31:0] id_ex_rs2data,
input[4:0] id_ex_rd,

input[31:0] id_ex_imm,
input[31:0] id_ex_pc_out,

input id_ex_instruction1,

output reg [31:0] aluout1,
output reg [31:0] aluout2
);

wire [31:0]aluin1 = id_ex_rs1data;
wire [31:0]aluin2 =       id_ex_subtype[0] | id_ex_subtype[4] ? id_ex_rs2data
                        : id_ex_subtype[1] | id_ex_subtype[2] | id_ex_subtype[3] | id_ex_subtype[8] ? id_ex_imm
                        : 32'b00000;

wire [31:0]aluplus = aluin1 + aluin2;
wire [32:0]aluminus = {1'b0,aluin1} + {1'b1,~aluin2} + 32'b1;

wire EQ = (id_ex_rs1data == id_ex_rs2data) ? 1'b1 : 1'b0;
wire NE = !EQ;
wire LT = (id_ex_rs1data[31] ^ id_ex_rs2data[31]);
wire GE = !LT;
wire LTU = aluminus[32];
wire GEU = !LTU;

always @(posedge clk ) begin
    if(!rst) begin
        //Register
        if(id_ex_instype[0]) begin
            aluout1 =     id_ex_subtype[0] ? (id_ex_instruction1==0 ? aluplus : aluminus[31:0])
                        : id_ex_subtype[1] ? (aluin1 << aluin2[4:0])
                        : id_ex_subtype[2] ? (LT ? aluin1[31] : aluminus[32])
                        : id_ex_subtype[3] ? (LTU ? 32'b1 : 32'b0)
                        : id_ex_subtype[4] ? (aluin1 ^ aluin2)
                        : id_ex_subtype[5] ? (~id_ex_instruction1 ? (aluin1 >> aluin2[4:0]) : (aluin1 >>> aluin2[4:0]))
                        : id_ex_subtype[6] ? (aluin1 | aluin2)
                        : id_ex_subtype[7] ? (aluin1 & aluin2)
                        : 32'h00000000;
            aluout2 = {27'b0, id_ex_rd};
        end
    
        //Immediate
        else if(id_ex_instype[1]) begin
            aluout1 =     id_ex_subtype[0] ? aluplus
                        : id_ex_subtype[1] ? aluin1 << aluin2[4:0]
                        : id_ex_subtype[2] ? LT ? aluin1[31] : aluminus[32]
                        : id_ex_subtype[3] ? LTU ? 32'b1 : 32'b0
                        : id_ex_subtype[4] ? aluin1 ^ aluin2
                        : id_ex_subtype[5] ? ~id_ex_instruction1 ? (aluin1 >> aluin2[4:0]) : (aluin1 >>> aluin2[4:0])
                        : id_ex_subtype[6] ? aluin1 | aluin2
                        : id_ex_subtype[7] ? aluin1 & aluin2
                        : 32'h00000000;
            aluout2 = {27'b0, id_ex_rd};
        end
        
        //Store
        else if(id_ex_instype[2]) begin
            aluout1 = id_ex_subtype[2] ? aluplus : 32'b0;
            aluout2 = id_ex_rs2data;
        end
        
        //Load
        else if(id_ex_instype[3]) begin
            aluout1 = aluplus;
            aluout2 = {27'b0, id_ex_rd};
        end
        
        //Branch
        else if(id_ex_instype[4]) begin
            aluout1 = {id_ex_pc_out + id_ex_imm};
            aluout2 = 32'b0;
        end
        
        //lui
        else if(id_ex_instype[5]) begin
            aluout1 = id_ex_imm;
            aluout2 = {27'b0, id_ex_rd};
        end
        
        //auipc
        else if(id_ex_instype[6]) begin
            aluout1 = {id_ex_pc_out + id_ex_imm};
            aluout2 = {27'b0, id_ex_rd};
        end
        
        //jal
        else if(id_ex_instype[7]) begin
            aluout1 = {id_ex_pc_out + id_ex_imm};
            aluout2 = {27'b0, id_ex_rd};
        end
        
        //jalr
        else if(id_ex_instype[8]) begin
            aluout1 = aluplus;
            aluout2 = {27'b0, id_ex_rd};
        end
    end
end

endmodule
