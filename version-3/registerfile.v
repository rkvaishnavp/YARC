module registerfile (instruction, clk, wdata, waddr, rs1data, rs2data);
    
    input [31:0] instruction;
    input [4:0] waddr;
    input clk;
    input [31:0] wdata;
    output[31:0] rs1data, rs2data;

    wire[4:0] rs1addr, rs2addr;
    assign rs1addr = instruction[19:15];
    assign rs2addr = instruction[24:20];

    reg [31:0]registers[0:4];
    initial begin
        registers[0] = 32'b0;
        registers[1] = 32'b00000000000000000000000000001111;
        registers[2] = 32'b00000000000000000000000000001111;
        registers[3] = 32'b00000000000000000000000000010000;
    end
    always @(posedge clk ) begin
        
        if(wen) begin
            wdata <= registers[waddr];
        end
        
        rs1data <= registers[rs1addr];
        rs2data <= registers[rs2addr];

    end
    
endmodule