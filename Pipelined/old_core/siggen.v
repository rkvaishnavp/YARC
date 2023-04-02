module siggen(instype, subtype, raddr, ren, wen, instruction, clk, rst);
input [31:0] instruction;
input clk, rst;
output reg[8:0] instype;
output reg[7:0] subtype;
output reg ren, wen;
output reg[4:0] rdaddr;
output reg instruction1;

always @(posedge clk ) begin
    case(instruction[6:2])
        5'b01100 : instype = 9'b000000001;  //register  rd = rs1 op rs2
        5'b00100 : instype = 9'b000000010;  //immediate rd = rs1 op Iimm
        5'b01000 : instype = 9'b000000100;  //store     datamemory[rs1+Simm] = rs2(8,16,32)
        5'b00000 : instype = 9'b000001000;  //load      rd = datamemory[rs1+Iimm](8,16,32)
        5'b11000 : instype = 9'b000010000;  //branch    if(rs1 op rs2) then programcounter = programcounter + 4 + Bimm
        5'b01101 : instype = 9'b000100000;  //lui       rd = Uimm
        5'b00101 : instype = 9'b001000000;  //auipc     rd = programcounter + Uimm
        5'b11011 : instype = 9'b010000000;  //jal       rd = programcounter + 4 //programcounter = programcounter + Jimm
        5'b11001 : instype = 9'b100000000;  //jalr      rd = programcounter + 4 //programcounter = rs1 + Iimm
        default : instype = 9'b0;
    endcase

    if(instruction[6:2] == 5'b01000) begin
        wen = 1;
    end
    else begin
        wen = 0;
    end
    if(instruction[6:2] == 5'b00000) begin
        ren = 1;
    end
    else begin
        ren = 0;
    end
    
    subtype = 8'b00000001 << instruction[14:12];
    instruction1 = [30]instruction;
    raddr = instruction[11:7];
end
endmodule