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
input[9:0] instype,
input[7:0] subtype,
input[31:0] rs1data,
input[31:0] rs2data,
input[4:0] rdaddr,
input[31:0] imm,
input[31:0] next_pc_out,
input instruction1,
output reg [31:0] aluout1,
output reg [31:0] aluout2,
output reg branch
);

wire [31:0]aluin1 = rs1data;
wire [31:0]aluin2 =       subtype[0] | subtype[4] ? rs2data
                        : subtype[1] | subtype[2] | subtype[8] | subtype[3] ? imm
                        : 32'b00000;

wire [31:0]aluplus = aluin1 + aluin2;
wire [32:0]aluminus = {1'b0,aluin1} + {1'b1,~aluin2} + 32'b1;

wire EQ = (rs1data == rs2data) ? 1'b1 : 1'b0;
wire NE = !EQ;
wire LT = (rs1data[31] ^ rs2data[31]);
wire GE = !LT;
wire LTU = aluminus[32];
wire GEU = !LTU;

always @(posedge clk ) begin
    //Register
    if(instype[0]) begin
        aluout1 =     subtype[0] ? (instruction1==0 ? aluplus : aluminus[31:0])
                    : subtype[1] ? (aluin1 << aluin2[4:0])
                    : subtype[2] ? (LT ? aluin1[31] : aluminus[32])
                    : subtype[3] ? (LTU ? 32'b1 : 32'b0)
                    : subtype[4] ? (aluin1 ^ aluin2)
                    : subtype[5] ? (~instruction ? (aluin1 >> aluin2[4:0]) : (aluin1 >>> aluin2[4:0]))
                    : subtype[6] ? (aluin1 | aluin2)
                    : subtype[7] ? (aluin1 & aluin2)
                    : 32'h00000000;
        aluout2 = {27'b0, rdaddr};
        rden = 0;
    end

    //Immediate
    else if(instype[1]) begin
        aluout1 =     subtype[0] ? aluplus
                    : subtype[1] ? aluin1 << aluin2[4:0]
                    : subtype[2] ? LT ? aluin1[31] : aluminus[32]
                    : subtype[3] ? LTU ? 32'b1 : 32'b0
                    : subtype[4] ? aluin1 ^ aluin2
                    : subtype[5] ? ~instruction1 ? (aluin1 >> aluin2[4:0]) : (aluin1 >>> aluin2[4:0])
                    : subtype[6] ? aluin1 | aluin2
                    : subtype[7] ? aluin1 & aluin2
                    : 32'h00000000;
        aluout2 = {27'b0, rdaddr};
        rden = 0;
    end
    
    //Store
    else if(instype[2]) begin
        aluout1 = subtype[2] ? aluplus : 32'b0;
        aluout2 = rs2data;
        rden = 0;
    end
    
    //Load
    else if(instype[3]) begin
        aluout1 = aluplus;
        aluout2 = {27'b0, rdaddr};
        rden = 1;
    end
    
    //Branch
    else if(instype[4]) begin
        branch = ((subtype[0] & EQ) | (subtype[1] & NE) | (subtype[4] & LT) | (subtype[5] & GE) | (subtype[6] & LTU) | (subtype[7] & GEU)); 
        aluout1 = next_pc_out + imm;
        aluout2 = 32'b0;
        rden = 0;
    end
    
    //lui
    else if(instype[5]) begin
        aluout1 = imm;
        aluout2 = {27'b0, rdaddr};
        rden = 0;
    end
    
    //auipc
    else if(instype[6]) begin
        aluout1 = next_pc_out + imm;
        aluout2 = {27'b0, rdaddr};
        rden = 0;
    end
    
    //jal
    else if(instype[7]) begin
        aluout1 = next_pc_out + imm;
        aluout2 = {27'b0, rdaddr};
        rden = 0;
    end
    
    //jalr
    else if(instype[8]) begin
        aluout1 = aluplus;
        aluout2 = {27'b0, rdaddr};
        rden = 0;
    end
end

endmodule
