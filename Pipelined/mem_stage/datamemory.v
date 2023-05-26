module datamemory(rd_data, rd_addr, wr_data, wr_addr, wen, ren, clk);

output reg [31:0] rd_data;
input [31:0] rd_addr, wr_addr;
input [31:0] wr_data;
input wen, ren;
input clk;
input rst;

reg [31:0]datamemory[0:31];

always @(posedge clk ) begin
    if(!rst) begin
        if(wen) begin
            datamemory[wr_addr] <= wr_data;
        end
        
        if(ren) begin
            rd_data <= datamemory[rd_addr];
        end
    end
    else begin
        datamemory = 0;
    end
end

endmodule