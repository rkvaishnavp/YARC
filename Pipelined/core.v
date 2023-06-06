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

wire [31:0]pc_out;
wire [31:0]pc_in;
wire [31:0]if_id_pc_out;
program_counter program_counter(
    .clk(clk),
    .rst(rst),
    .pc_in(pc_in),
    .pc_out(pc_out),
    .pc_reg_out(if_id_pc_out),
    .if_id_ins_valid(if_id_ins_valid)
);

wire [31:0]if_id_instruction;
insmemory insmemory(
    .clk(clk),
    .pc_out(pc_out),
    .if_id_instruction(if_id_instruction)
);

wire [31:0]wdata;
assign wdata = (mem_wb_mem_to_reg==1)?read_data:mem_wb_aluout1;
wire [31:0]id_ex_rs1data;
wire [31:0]id_ex_rs2data;
wire [4:0]mem_wb_rd;
registerfile registerfile(
    .clk(clk),
    .rst(rst),
    .if_id_instruction(if_id_instruction),
    .rd(mem_wb_rd),
    .wdata(wdata),
    .regwrite(mem_wb_regwrite),
    .rs1data(id_ex_rs1data),
    .rs2data(id_ex_rs2data)
);

wire [31:0]id_ex_imm;
immmaker immmaker(
    .clk(clk),
    .instruction(if_id_instruction),
    .imm(id_ex_imm)
);

wire id_ex_mem_to_reg;
wire [8:0]id_ex_instype;
wire [7:0]id_ex_subtype;
wire [4:0]id_ex_rd;
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

wire [4:0]id_ex_rs1;
wire [4:0]id_ex_rs2;
wire [31:0]id_ex_pc_out;
id_ex_reg id_ex_reg(
    .clk(clk),
    .rst(rst),
    .if_id_instruction(if_id_instruction),
    .if_id_pc_out(if_id_pc_out),
    .id_ex_rs1(id_ex_rs1),
    .id_ex_rs2(id_ex_rs2),
    .id_ex_rd(),
    .id_ex_pc_out(id_ex_pc_out),
    .if_id_ins_valid(if_id_ins_valid),
    .id_ex_ins_valid(id_ex_ins_valid)
);

wire [31:0]aluout1;
wire [31:0]aluout2;
exeunit exeunit(
    .clk(clk),
    .rst(rst),
    .id_ex_instype(id_ex_instype),
    .id_ex_subtype(id_ex_subtype),
    .id_ex_rs1data(id_ex_rs1data),
    .id_ex_rs2data(id_ex_rs2data),
    .id_ex_rd(id_ex_rd),
    .id_ex_imm(id_ex_imm),
    .id_ex_pc_out(id_ex_pc_out),
    .id_ex_instruction1(id_ex_instruction1),
    .aluout1(aluout1),
    .aluout2(aluout2)
);

wire [31:0]ex_mem_pc_src;
wire [4:0]ex_mem_rd;
wire [4:0]ex_mem_rs1;
wire [4:0]ex_mem_rs2;
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
    .ex_mem_rs2(ex_mem_rs2),
    .id_ex_ins_valid(id_ex_ins_valid),
    .ex_mem_ins_valid(ex_mem_ins_valid)
);

wire [31:0]read_data;
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

wire [4:0]mem_wb_rs1;
wire [4:0]mem_wb_rs2;
wire [31:0]mem_wb_aluout1;
wire [31:0]mem_wb_aluout2;
mem_wb_reg mem_wb_reg(
    .clk(clk),
    .rst(rst),
    .ex_mem_rs1(ex_mem_rs1),
    .ex_mem_rs2(ex_mem_rs2),
    .ex_mem_rd(ex_mem_rd),
    .ex_mem_regwrite(ex_mem_regwrite),
    .ex_mem_mem_to_reg(ex_mem_mem_to_reg),
    .mem_wb_rs1(mem_wb_rs1),
    .mem_wb_rs2(mem_wb_rs2),
    .mem_wb_rd(mem_wb_rd),
    .mem_wb_mem_to_reg(mem_wb_mem_to_reg),
    .mem_wb_regwrite(mem_wb_regwrite),
    .aluout1(aluout1),
    .aluout2(aluout2),
    .mem_wb_aluout1(mem_wb_aluout1),
    .mem_wb_aluout2(mem_wb_aluout2),
    .ex_mem_ins_valid(ex_mem_ins_valid),
    .mem_wb_ins_valid(mem_wb_ins_valid)
);
endmodule
