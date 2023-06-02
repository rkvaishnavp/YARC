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
input rst

);

wire [31:0]if_id_instruction;   //32-bit instruction from IF to ID stage
assign if_id_instruction1 = if_id_instruction[30];  //[30] bit of instruction for ADD,SUB


wire[31:0] if_pc_out; //between PC and Instruction memory

wire hold_pc;
wire exe_ip_1;
wire exe_ip_2;

assign exe_ip_1 = (rs1_forward==0)?id_ex_rs1data:(rs1_forward==1)?aluout1:0;
assign exe_ip_2 = (rs2_forward==0)?id_ex_rs2data:(rs2_forward==1)?aluout1:0;

/*  IF Stage  */
//  Instruction to be loaded from BlockRam AXI4-Lite Interface
//  pc_out is address given to memory module
program_counter program_counter(
    .rst(rst),
    .pc_in(pc_in),
    .pc_out(if_pc_out)
);
insmemory insmemory(
    .clk(clk),
    .pc_out(if_pc_out),
    .if_id_instruction(if_id_instruction)
);

/*  IF/ID Registers  */
if_id_reg if_id_reg(
    .clk(clk),
    .rst(rst),
    .hold_pc(0),
    .pc_out(if_pc_out),
    .if_id_pc_out(if_id_pc_out)
);

/*  ID Stage  */ 
//  Nothing else to add in this stage
registerfile registerfile(
    .clk(clk),
    .rst(rst),
    .if_id_instruction(if_id_instruction),
    .rd(read_data),
    .regwrite(regwrite),
    .rs1data(id_ex_rs1data),
    .rs2data(id_ex_rs2data)
);
immmaker immmaker(
    .clk(clk),
    .instruction(if_id_instruction),
    .imm(id_ex_imm)
);
control control(
    .clk(clk),
    .rst(rst),
    .if_id_instruction(if_id_instruction),
    .id_ex_memread(id_ex_memread),
    .id_ex_memwrite(id_ex_memwrite),
    .id_ex_mem_to_reg(id_ex_mem_to_reg),
    .id_ex_pc_src(id_ex_pc_src),
    .id_ex_rd(id_ex_rd),
    .id_ex_instruction1(id_ex_instruction1),
    .id_ex_regwrite(id_ex_regwrite),
    .id_ex_branch(id_ex_branch),
    .id_ex_instype(id_ex_instype),
    .id_ex_subtype(id_ex_subtype)
);

/*  ID/EXE Stage  */
id_ex_reg id_ex_reg(
    .clk(clk),
    .rst(rst),
    .if_id_instruction(if_id_instruction),
    .if_id_pc_out(if_id_pc_out),
    .id_ex_rs1(id_ex_rs1),
    .id_ex_rs2(id_ex_rs2),
    .id_ex_rd(id_ex_rs2),
    .id_ex_pc_out(id_ex_pc_out)
);


/*  EXE Stage  */
//  Have to add mux for Forwarding the Data and Control Hazards
exeunit exeunit(
    .clk(clk),
    .rst(rst),
    .id_ex_instype(id_ex_instype),
    .id_ex_subtype(id_ex_subtype),
    .id_ex_rs1data(exe_ip_1),
    .id_ex_rs2data(exe_ip_2),
    .id_ex_rd(id_ex_rd),
    .id_ex_imm(id_ex_imm),
    .id_ex_pc_out(id_ex_pc_out),
    .id_ex_instruction1(instruction1),
    .aluout1(aluout1),
    .aluout2(aluout2)
);


/*  EXE/MEM Stage  */
ex_mem_reg ex_mem_reg(
    .clk(clk),
    .rst(rst),
    .id_ex_memread(id_ex_memread),
    .id_ex_memwrite(id_ex_memwrite),
    .id_ex_mem_to_reg(id_ex_mem_to_reg),
    .id_ex_pc_src(id_ex_pc_src),
    .id_ex_rd(id_ex_rd),
    .id_ex_regwrite(id_ex_regwrite),
    .ex_mem_memread(ex_mem_memread),
    .ex_mem_memwrite(ex_mem_memwrite),
    .ex_mem_mem_to_reg(ex_mem_mem_to_reg),
    .ex_mem_pc_src(ex_mem_pc_src),
    .ex_mem_rd(ex_mem_rd),
    .ex_mem_regwrite(ex_mem_regwrite),
    .id_ex_rs1(id_ex_rs1),
    .id_ex_rs2(id_ex_rs2),
    .ex_mem_rs1(ex_mem_rs1),
    .ex_mem_rs2(ex_mem_rs2)
);


/*  MEM Stage  */
//  Write Back is done in this stage also and will save 1 cycle of wastage
//  AXI4-Lite Memory Interface
//  Have to add Support for AXI4-Lite Interface (READ/WRITE)
datamemory datamemory(
    .clk(clk),
    .rst(rst),
    .read_address_aluout1(aluout1),
    .write_address_aluout1(aluout1),
    .write_data_aluout2(aluout2),
    .ex_mem_memwrite(ex_mem_memwrite),
    .ex_mem_memread(ex_mem_memread),
    .read_data(read_data)
);

/*  MEM/WB Stage  */
mem_wb_reg mem_wb_reg(
    .clk(clk),
    .rst(rst),
    .ex_mem_rs1(ex_mem_rs1),
    .ex_mem_rs2(ex_mem_rs2),
    .ex_mem_rd(ex_mem_rs2),
    .mem_wb_rs1(mem_wb_rs1),
    .mem_wb_rs2(mem_wb_rs2),
    .mem_wb_rd(mem_wb_rd)
);


/*  WB Stage  */
// Write Back happens in this stage



//  Write will be directly done from AXI4-Lite Memory
//  Have to add Forwarding support as well



//hazard_detection hazard_detection();

forwarding_unit forwarding_unit(
    .id_ex_rs1(id_ex_rs1),
    .id_ex_rs2(id_ex_rs2),
    .ex_mem_rd(ex_mem_rd),
    .mem_wb_rd(mem_wb_rd),
    .rs1_forward(rs1_forward),
    .rs2_forward(rs2_forward)
);

endmodule
