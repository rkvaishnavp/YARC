`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/24/2023 03:50:12 AM
// Design Name: 
// Module Name: core
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


module core(

input clk,
input rst,

);

wire [31:0]if_id_instruction;   //32-bit instruction from IF to ID stage
assign if_id_instruction1 = if_id_instruction[30];  //[30] bit of instruction for ADD,SUB


wire if_pc_out; //between PC and Instruction memory

wire hold_pc;

/*  IF Stage  */
//  Instruction to be loaded from BlockRam AXI4-Lite Interface
//  pc_out is address given to memory module
programcounter programcounter(
    .clk(clk),
    .rst(rst),
    .pc_in(pc_in),
    .pc_out(if_pc_out),
);
insmemory insmemory(
    .clk(clk),
    .pc_out(if_pc_out),
    .instruction(if_id_instruction)
);

/*  IF/ID Registers  */
if_id_reg if_id_reg(
    .clk(clk),
    .rst(rst),
    .hold_pc(hold_pc),
    .pc_out(if_pc_out),
    .if_id_pc_out(if_id_pc_out)
);

/*  ID Stage  */ 
//  Nothing else to add in this stage
registersfile registersfile(
    .clk(clk),
    .rst(rst),
    .registers_en(registers_en),
    .instruction(if_id_instruction),
    .waddr(waddr),
    .wen(wen),
    .rs1data(if_id_rs1data),
    .rs2data(rs2data)
);
immmaker immmaker(
    .clk(clk),
    .instruction(if_id_instruction),
    .imm(if_id_imm)
);
siggen siggen(
    .clk(clk),
    .rst(rst),
    .instruction(if_id_instruction),
    .instype(instype),
    .subtype(subtype),
    .ren(ren),
    .wen(wen),
    .rdaddr(rdaddr),
    .instruction1(instruction1)
);
control control(
    
);


/*  ID/EXE Stage  */



/*  EXE Stage  */
//  Have to add mux for Forwarding the Data and Control Hazards
exeunit exeunit(
    .clk(clk),
    .rst(rst),
    .instype(instype),
    .subtype(subtype),
    .rs1data(rs1data),
    .rs2data(rs2data),
    .rdaddr(rdaddr),
    .imm(imm),
    .next_pc_out(next_pc_out),
    .instruction1(instruction1),
    .aluout1(aluout1),
    .aluout2(aluout2),
    .branch(branch)
);


/*  EXE/MEM Stage  */



/*  MEM Stage  */
//  AXI4-Lite Memory Interface
//  Have to add Support for AXI4-Lite Interface (READ/WRITE)
datamemory datamemory(
    .clk(clk),
    .rst(rst),
    .wen(wen),
    .ren(ren),
    .wr_data(wr_data),
    .rd_data(rd_data),
    .rd_addr(rd_addr)
);

/*  MEM/WB Stage  */



/*  WB Stage  */



//  Write will be directly done from AXI4-Lite Memory
//  Have to add Forwarding support as well



hazarddetection hazarddetection();
forwardingunit forwardingunit();

endmodule
