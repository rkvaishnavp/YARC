module processor(pc, rst, clk);

output reg pc;
input rst;
input clk;

reg [255:0] insmemory[31:0];    //Instruction Memory
reg [255:0] datamemory[31:0];   //Data Memory
reg [31:0] registers[31:0];     //Registers
reg [12:0] programcounter;      //Program Counter

wire [31:0]instruction;         //Instruction
assign instruction = insmemory[programcounter>>2]; //Assign Instruction wire

//Wiring funct3 and funct7
wire [7:0]funct3 = 8'b00000001 << instruction[14:12];
wire funct7 = instruction[30];

//Immediates of 5 immediate type of instruction
wire [31:0]Iimm = {{21{instruction[31]}},instruction[30:25],instruction[24:21],instruction[20]};
wire [31:0]Simm = {{21{instruction[31]}},instruction[30:25],instruction[11:8],instruction[7]};
wire [31:0]Bimm = {{20{instruction[31]}},instruction[7],instruction[30:25],instruction[11:8],1'b0};
wire [31:0]Uimm = {instruction[31:12],12'b0};
wire [31:0]Jimm = {{12{instruction[31]}},instruction[19:12],instruction[20],instruction[30:25],instruction[24:21],1'b0};

//Defining rs1, rs2, rd
wire [31:0]rs1, rs2;
assign rs1 = registers[instruction[19:15]];
assign rs2 = registers[instruction[24:20]];
wire [4:0]rdadd = instruction[11:7];

//Defining Oprogramcounterodes
wire register = (instruction[6:2] == 5'b01100); //rd = rs1 op rs2
wire immediate = (instruction[6:2] == 5'b00100);//rd = rs1 op Iimm
wire store = (instruction[6:2] == 5'b01000);    //datamemory[rs1+Simm] = rs2(8,16,32)
wire load = (instruction[6:2] == 5'b00000);     //rd = datamemory[rs1+Iimm](8,16,32)
wire branch = (instruction[6:2] == 5'b11000);   //if(rs1 op rs2) then programcounter = programcounter + 4 + Bimm
wire lui = (instruction[6:2] == 5'b01101);      //rd = Uimm
wire auipc = (instruction[6:2] == 5'b00101);    //rd = programcounter + Uimm
wire jal = (instruction[6:2] == 5'b11011);      //rd = programcounter + 4 //programcounter = programcounter + Jimm
wire jalr = (instruction[6:2] == 5'b11001);     //rd = programcounter + 4 //programcounter = rs1 + Iimm

//ALU input
wire [31:0]aluin1 = rs1;
wire [31:0]aluin2 =     (
                        register | branch ? rs2
                        : immediate | jalr | load ? Iimm
                        : store ? Simm
                        : 32'b00000
                        );

//ALU Plus and Minus
wire [31:0]aluplus = aluin1 + aluin2;
wire [32:0]aluminus = {1'b0,aluin1} + {1'b1,~aluin2} + 32'b1;

//Branch Conditions
wire EQ = (aluin1 == aluin2) ? 1'b1 : 1'b0;
wire NE = !EQ;
wire LT = (aluin1[31] ^ aluin2[31]);
wire GE = !LT;
wire LTU = aluminus[32];
wire GEU = !LTU;

//ALU Output
wire [31:0]aluout = (
                    register | immediate ? 
                            ( funct3[0] ? (instruction[5]==1 ? (instruction[30]==0 ? aluplus : aluminus[31:0]): aluplus)
                            : funct3[1] ? (aluin1 << aluin2[4:0])
                            : funct3[2] ? (LT ? aluin1[31] : aluminus[32])
                            : funct3[3] ? (LTU ? 32'b1 : 32'b0)
                            : funct3[4] ? (aluin1 ^ aluin2)
                            : funct3[5] ? (~instruction[30] ? (aluin1 >> aluin2[4:0]) : (aluin1 >>> aluin2[4:0]))
                            : funct3[6] ? (aluin1 | aluin2)
                            : funct3[7] ? (aluin1 & aluin2)
                            : 32'h00000000)
                    : store ?
                            ( funct3[2] ? aluplus
                            : 32'b0)
                    : load ? 
                            ( funct3[0] ? ({24'h000000,datamemory[aluplus][7:0]})
                            : funct3[1] ? ({16'h0000,datamemory[aluplus][15:0]})
                            : funct3[2] ? (datamemory[aluplus])
                            : funct3[3] ? ({{24{datamemory[aluplus][7]}},datamemory[aluplus][7:0]})
                            : funct3[4] ? ({{16{datamemory[aluplus][15]}},datamemory[aluplus][15:0]})
                            : 32'h00000000)
                    : branch ?
                            {31'b0,
                            ( funct3[0] & EQ
                            | funct3[1] & NE
                            | funct3[4] & LT
                            | funct3[5] & GE
                            | funct3[6] & LTU
                            | funct3[7] & GEU)}
                    : lui ? Uimm
                    : auipc ? programcounter + Uimm
                    : (jal|jalr) ? programcounter + 4
                    : 32'h00000000
                    );

always @(posedge clk ) begin
        pc = programcounter;
        registers[0] = 32'b0;
        if (!rst) begin
        programcounter = programcounter + 4;

        if (register | immediate | load | lui | auipc | jal | jalr) begin
                if(rdadd != 0) begin
                registers[rdadd] = aluout;
                end

                if (jal) begin
                        programcounter = programcounter + Jimm;
                end
                else if (jalr) begin
                        programcounter = aluplus;
                end
        end
        else if (store) begin
                datamemory[aluout] = rs2;
        end
        else if (branch && aluout) begin
                programcounter = programcounter + Bimm;
        end
        end
        else begin
        programcounter = 0;
        registers[1] = 32'b0;
        registers[2] = 32'b0;
        registers[3] = 32'b0;
        registers[4] = 32'b0;
        registers[5] = 32'b0;
        registers[6] = 32'b0;
        registers[7] = 32'b0;
        registers[8] = 32'b0;
        registers[9] = 32'b0;
        registers[10] = 32'b0;
        registers[11] = 32'b0;
        registers[12] = 32'b0;
        registers[13] = 32'b0;
        registers[14] = 32'b0;
        registers[15] = 32'b0;
        registers[16] = 32'b0;
        registers[17] = 32'b0;
        registers[18] = 32'b0;
        registers[19] = 32'b0;
        registers[20] = 32'b0;
        registers[21] = 32'b0;
        registers[23] = 32'b0;
        registers[24] = 32'b0;
        registers[25] = 32'b0;
        registers[26] = 32'b0;
        registers[27] = 32'b0;
        registers[28] = 32'b0;
        registers[29] = 32'b0;
        registers[30] = 32'b0;
        registers[31] = 32'b0;
        end
end
endmodule