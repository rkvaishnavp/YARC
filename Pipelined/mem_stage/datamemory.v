module datamemory(
input clk,
input rst,
input [31:0] read_address_aluout1, 
input [31:0] write_address_aluout1,
input [31:0] write_data_aluout2,
input ex_mem_memwrite, 
input ex_mem_memread,
output reg [31:0] read_data
);


reg [31:0]datamemory[0:31];

always @(posedge clk ) begin
    if(!rst) begin
        if(ex_mem_memwrite) begin
            datamemory[write_address_aluout1] <= write_data_aluout2;
        end
        
        else if(ex_mem_memread) begin
            read_data = datamemory[read_address_aluout1];
        end
    end
end

endmodule