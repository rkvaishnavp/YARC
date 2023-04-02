module datamemory(rd_data, rd_addr, wr_data, wr_addr, wen, ren, clk);

output reg [31:0] rd_data;
input [31:0] rd_addr, wr_addr;
input [31:0] wr_data;
input wen, ren;
input clk;

reg [31:0]datamemory[0:31];

always @(posedge clk ) begin
    
    if(wen) begin
        datamemory[wr_addr] <= wr_data;
    end
    
    if(ren) begin
        rd_data <= datamemory[rd_addr];
    end
end

endmodule
module exeunit(aluout1, aluout2, rden, branch, rs1data, rs2data, rdaddr, imm, instype, clk, rst);

input clk, rst;
input[9:0] instype;
input[7:0] subtype;
input[31:0] rs1data, rs2data;
input[4:0] rdaddr;
input[31:0] imm;
input[31:0] next_pc_out;
input instruction1;
output reg [31:0] aluout1;
output reg [31:0] aluout2;
output reg branch;

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
    instruction1 = instruction[30];
    raddr = instruction[11:7];
end
endmodule
module immmaker (
    imm, instruction, clk
);
output reg [31:0] imm;
input[31:0] instruction, clk;
always @(posedge clk ) begin
    case(instruction[6:2])
        5'b00100 : imm = {{21{instruction[31]}},instruction[30:25],instruction[24:21],instruction[20]};                         //immediate rd = rs1 op Iimm
        5'b01000 : imm = {{21{instruction[31]}},instruction[30:25],instruction[11:8],instruction[7]};                           //store     datamemory[rs1+Simm] = rs2(8,16,32)
        5'b00000 : imm = {{21{instruction[31]}},instruction[30:25],instruction[24:21],instruction[20]};                         //load      rd = datamemory[rs1+Iimm](8,16,32)
        5'b11000 : imm = {{20{instruction[31]}},instruction[7],instruction[30:25],instruction[11:8],1'b0};                      //branch    if(rs1 op rs2) then programcounter = programcounter + 4 + Bimm
        5'b01101 : imm = {instruction[31:12],12'b0};                                                                            //lui       rd = Uimm
        5'b00101 : imm = {instruction[31:12],12'b0};                                                                            //auipc     rd = programcounter + Uimm
        5'b11011 : imm = {{12{instruction[31]}},instruction[19:12],instruction[20],instruction[30:25],instruction[24:21],1'b0}; //jal       rd = programcounter + 4 //programcounter = programcounter + Jimm
        5'b11001 : imm = {{21{instruction[31]}},instruction[30:25],instruction[24:21],instruction[20]};                         //jalr      rd = programcounter + 4 //programcounter = rs1 + Iimm
        default  : imm = 32'b0;
    endcase
end
endmodule
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
module insmemory(instruction, pc_out, clk);

output reg [31:0] instruction;
input[31:0] pc_out;
input clk;

reg [31:0]insmemory[0:31];
initial begin
    insmemory[0] = 32'b1;
    insmemory[1] = 32'h00000000;
end
always @(posedge clk ) begin
    instruction <= insmemory[pc_out];
end

endmodule
module programcounter (clk, rst, pc_in, pc_out, next_pc_out);

input clk, rst;
input[31:0] pc_in;
output [31:0] pc_out;
output reg[31:0] next_pc_out;

assign pc_out = pc_in;
always @(posedge clk ) begin
    next_pc_out <= pc_out + 32'b1;        
end
endmodule
module processor (clk, rst);
    input clk, rst;
    wire[31:0] w1;
    wire[31:0] q1;
    wire[31:0] q2;
    wire[31:0] r1;
    wire[31:0] r2;
    wire[31:0] r3;
    wire[31:0] r4;
    wire[8:0] r5;
    wire[7:0] r6;
    wire[4:0] r7;
    wire r8;
    wire r9;
    wire r10;
    wire[31:0] s0;
    wire s1;
    wire[31:0] s2;
    wire[31:0] s3;
    wire s4;
    wire s5;
    wire s6;
    wire[31:0] s7;
    wire[31:0] t0;
    wire[31:0] t1;
    wire[31:0] t2;
    wire t3;
    wire[31:0] t4;

    always @(posedge clk ) begin
        r1 = q2;
        s0 = r1;
        s5 = r9;
        s6 = r10;
        t3 = s4;
    end
    assign s7 = s1 ? s2 : s0;
    assign t4 = t3 ? t0 : t2;
    programcounter programcounter1(.clk(clk),.rst(1'b0),.pc_in(s7),.pc_out(w1),.next_pc_out(q2));
    insmemory insmemory1(.clk(clk),.pc_out(w1),.instruction(q1));
    registerfile registerfile1(.clk(clk),.instruction(q1),.wdata(t1),.waddr(t4),.rs1data(r2),.rs2data(r3));
    siggen siggen1(.clk(clk),.rst(0),.instruction(q1),.instype(r5),.subtype(r6),.rdaddr(r7),.instruction1(r8),.wen(r9),.ren(r10));
    immmaker immmaker1(.clk(clk),.instruction(q1),.imm(r4));
    exeunit exeunit1(.clk(clk),.rst(0),.branch(s1),.rden(s4),.aluout1(s2),.aluout2(s3),.next_pc_out(r1),.rs1data(r2),.rs2data(r3),.imm(r4),.instype(r5),.subtype(r6),.rdaddr(r7),.instruction1(r8));
    datamemory datamemory(.clk(clk),.rd_addr(s2),.wr_addr(s2),.wr_data(s3),.ren(s6),.wen(s5),.rddata(t2));
endmodule