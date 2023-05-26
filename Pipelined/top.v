`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/24/2023 03:52:53 AM
// Design Name: 
// Module Name: top
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


module top(
input clk,
input rst
);

core core(
.clk(clk),
.rst(rst),
.rsta_busy(rsta_busy),
.rstb_busy(rstb_busy),
.s_axi_awaddr(s_axi_awaddr),
.s_axi_awvalid(s_axi_awvalid),
.s_axi_awready(s_axi_awready),
.s_axi_wdata(s_axi_wdata),
.s_axi_wstrb(s_axi_wstrb),
.s_axi_wvalid(s_axi_wvalid),
.s_axi_wready(s_axi_wready),
.s_axi_bresp(s_axi_bresp),
.s_axi_bvalid(s_axi_bvalid),
.s_axi_bready(s_axi_bready),
.s_axi_araddr(s_axi_araddr),
.s_axi_arvalid(s_axi_arvalid),
.s_axi_arready(s_axi_arready),
.s_axi_rdata(s_axi_rdata),
.s_axi_rresp(s_axi_rresp),
.s_axi_rvalid(s_axi_rvalid),
.s_axi_rready(s_axi_rready)
);

blk_mem_gen_0 memory (
.rsta_busy(rsta_busy),          // output wire rsta_busy
.rstb_busy(rstb_busy),          // output wire rstb_busy
.s_aclk(clk),                // input wire s_aclk
.s_aresetn(rst),          // input wire s_aresetn
.s_axi_awaddr(s_axi_awaddr),    // input wire [31 : 0] s_axi_awaddr
.s_axi_awvalid(s_axi_awvalid),  // input wire s_axi_awvalid
.s_axi_awready(s_axi_awready),  // output wire s_axi_awready
.s_axi_wdata(s_axi_wdata),      // input wire [31 : 0] s_axi_wdata
.s_axi_wstrb(s_axi_wstrb),      // input wire [3 : 0] s_axi_wstrb
.s_axi_wvalid(s_axi_wvalid),    // input wire s_axi_wvalid
.s_axi_wready(s_axi_wready),    // output wire s_axi_wready
.s_axi_bresp(s_axi_bresp),      // output wire [1 : 0] s_axi_bresp
.s_axi_bvalid(s_axi_bvalid),    // output wire s_axi_bvalid
.s_axi_bready(s_axi_bready),    // input wire s_axi_bready
.s_axi_araddr(s_axi_araddr),    // input wire [31 : 0] s_axi_araddr
.s_axi_arvalid(s_axi_arvalid),  // input wire s_axi_arvalid
.s_axi_arready(s_axi_arready),  // output wire s_axi_arready
.s_axi_rdata(s_axi_rdata),      // output wire [31 : 0] s_axi_rdata
.s_axi_rresp(s_axi_rresp),      // output wire [1 : 0] s_axi_rresp
.s_axi_rvalid(s_axi_rvalid),    // output wire s_axi_rvalid
.s_axi_rready(s_axi_rready)     // input wire s_axi_rready
);

endmodule
