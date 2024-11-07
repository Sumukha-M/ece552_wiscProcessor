`include "alu.v"
module alu_tb ();
reg signed [15:0] alu_in1;
reg signed [15:0] alu_in2;
reg  [3:0] opcode;
wire signed [15:0] alu_out;
wire [2:0] flag;

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

alu_16bit idut(.alu_in1(alu_in1),.alu_in2(alu_in2),.alu_out(alu_out),.flag(flag),.opcode(opcode));

initial begin
    $dumpfile("alu.vcd");
    $dumpvars(0,idut);
end

initial begin
   opcode = ADD;
   alu_in1 = 16'hAB00;
   alu_in2 = 16'h00CD;
   #5;
   if(alu_in1 + alu_in2 === alu_out)
   $display("Success::Added %b and %b and got %b \n",alu_in1,alu_in2,alu_out);
   else
   $display("Fail \n");

   opcode = SUB;
   alu_in1 = 16'hAB00;
   alu_in2 = 16'h00CD;
   #5;
   if(alu_in1 - alu_in2 === alu_out)
   $display("Success::Subtracted %b and %b and got %b \n",alu_in1,alu_in2,alu_out);
   else
   $display("Addition Fail \n");

   opcode = RED;
   alu_in1 = 16'hAB00;
   alu_in2 = 16'h00CD;
   #5;
   if(alu_in1[7:0]+alu_in2[7:0]+alu_in1[15:8]+alu_in2[15:8])
   $display("Success: Reduced %b, %b, %b, %b and got %b \n",alu_in1[7:0],alu_in2[7:0],alu_in1[15:8],alu_in2[15:8],alu_out);
   else
   $display("Substraction Fail \n");

   opcode = XOR;
   alu_in1 = 16'hAB00;
   alu_in2 = 16'h00CD;
   #5;
   if(alu_in1^alu_in2 === alu_out)
   $display("Success: XORed %b and %b and got %b \n",alu_in1[15:0],alu_in2[15:0],alu_out);
   else
   $display("Fail \n");

   opcode = SRA;
   alu_in1 = 16'hAB00;
   alu_in2 = 16'h0008;
   #5;
   if(alu_out === alu_in1 >>> alu_in2)
   $display("Success: Arithmethic Right shifted %b by %b and got %b \n",alu_in1,alu_in2,alu_out);
   else
   $display("Fail: Arithmethic Right shifted %b by %b and got %b \n",alu_in1,alu_in2,alu_out);

   opcode = SLL;
   alu_in1 = 16'hAB00;
   alu_in2 = 16'h0008;
   #5;
   if(alu_out === alu_in1 << alu_in2)
   $display("Success: Left shifted %b by %b and got %b \n",alu_in1,alu_in2,alu_out);
   else
   $display("Fail: Left shifted %b by %b and got %b \n",alu_in1,alu_in2,alu_out);

   opcode = ROR;
   alu_in1 = 16'hAB00;
   alu_in2 = 16'h0008;
   #5;
   if(((alu_out === ((alu_in1 >> alu_in2) | (alu_in1 << (16 - alu_in2))))))
   $display("Success: Rotated %b by %b and got %b \n",alu_in1,alu_in2,alu_out);
   else
   $display("Fail: Rotated %b by %b and got %b \n",alu_in1,alu_in2,alu_out);

   opcode = PADDSB;
   alu_in1 = 16'hAB00;
   alu_in2 = 16'h00CD;
   #5;
   if(alu_out === 16'hABCD)
   $display("Success: PADDSB: harcoded values!!!: Please change otherwise \n");
   else
   $display("PADDSUB Fail \n");

   
end
endmodule