`include "cla_16bit.v"
`include "paddsub.v"
`include "reduction.v"
`include "3to1mux_shifter.v"

// 16-bit ALU module
module alu_16bit(
    input [15:0] alu_in1,
    input [15:0] alu_in2,
    input [3:0] opcode,
    output reg  [15:0] alu_out,
    output ovfl
);

// opcodes
localparam ADD = 4'b0000;
localparam SUB = 4'b0001;
localparam XOR = 4'b0010;
localparam RED = 4'b0011;
localparam SLL = 4'b0100;
localparam SRA = 4'b0101;
localparam ROR = 4'b0110;
localparam PADDSB = 4'b0111;
localparam LW = 4'b1000;
localparam SW = 4'b1001;
localparam LLB = 4'b1010;
localparam LHB = 4'b1011;

//creating few variables to handle ADD, SUB, LW, SW
wire is_sub;
wire [15:0] adder_in1;
wire [15:0] adder_in2;
wire [15:0] sum;

//handling 16 bit CLA inputs for ADD SUB LW and SW
wire [3:0]imm_memi;
assign imm_memi = alu_in2[3:0];
wire [15:0] adder_in3;
assign adder_in3 = {{12{imm_memi[3]}},imm_memi};
assign is_sub = (opcode[0] & (~opcode[3]))?1'b1:1'b0;
assign adder_in1 = (opcode[3])?(alu_in1 & 16'hfffe):(alu_in1); //handling for lw and sw only
assign adder_in2 = (opcode[3])?(adder_in3 << 1):(alu_in2); // handling for lw and sw only
cla_16bit alu_adder(.a(adder_in1),.b_in(adder_in2),.sum(sum),.ovfl(ovfl),.is_sub(is_sub));

//shifter output holding variable
wire [15:0] shifter_out;
//shifter operations
shifter_3to1 alu_shifter(
	.shift_in(alu_in1),
	.shift_val(alu_in2[3:0]),
	.mode(opcode[1:0]),
	.shift_out(shifter_out)
	);

//parallel add sub word
wire[15:0] paddsub;
//paddsub instantiation
paddsub alu_paddsub(
	.a(alu_in1),
	.b(alu_in2),
	.sum(paddsub)
	);

//reduction 
wire [8:0] red;
//reduction instantiation
reduction alu_red(
	.a(alu_in1[7:0]),
	.b(alu_in1[15:8]),
	.c(alu_in2[7:0]),
	.d(alu_in2[15:8]),
	.sum2(red)
	);

//load lower byte
wire [15:0] llb;
// llb read - write - modify operation
assign llb = (alu_in1[15:0] & 16'hff00) | alu_in2[7:0];

//load higher byte
wire [15:0] lhb;
assign lhb = (alu_in1[15:0] & 16'h00ff) | (alu_in2[7:0]<<8);



//final alu_output assignment
always @(*) begin
    case(opcode)
    ADD: begin
           alu_out = (ovfl)?((alu_in1[0])?(16'h8000):(16'h7fff)):sum;
         end
    SUB: begin
           alu_out = (ovfl)?((~alu_in1[0])?(16'h8000):(16'h7fff)):sum;
         end
    XOR: begin
            alu_out = alu_in1 ^ alu_in2;
         end
    RED: begin
            alu_out = {{7{red[8]}},red};
         end
    SLL: begin
            alu_out = shifter_out;
         end
    SRA: begin
            alu_out = shifter_out;
         end
    ROR: begin
            alu_out = shifter_out;
         end
    LW:  begin
            alu_out = sum;
         end
    SW:  begin
            alu_out = sum;
         end
    LLB: begin
            alu_out = llb;
         end
    LHB: begin
            alu_out = lhb;
         end
    PADDSB: begin
            alu_out = paddsub;
            end
    endcase
    
end

endmodule