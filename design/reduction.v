`include "cla_4bit.v"

// reduction module declaration
module reduction (
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [8:0] sum2
);

////////////////////////
// Level 0 : 4 adders//
//////////////////////
//1st addition
wire [7:0] sum0;
wire P00,G00;
wire carry00;
cla_4bit cla00 (
	.a(a[3:0]),
	.b(c[3:0]),
	.is_sub(1'b0),
	.P(P00),
	.G(G00),
	.sum(sum0[3:0])
	);
assign carry00 = G00;

//2nd addition
wire P01,G01;
cla_4bit cla01(
	.a(a[7:4]),
	.b(c[7:4]),
	.is_sub(carry00),
	.P(P01),
	.G(G01),
	.sum(sum0[7:4])
	);

//3rd addition
wire P02,G02;
wire carry02;
wire [7:0] sum1;
cla_4bit cla02 (
	.a(b[3:0]),
	.b(d[3:0]),
	.is_sub(1'b0),
	.P(P02),
	.G(G02),
	.sum(sum1[3:0])
	);
assign carry02 = G00;

//4th addition
wire P03,G03;
cla_4bit cla03(
	.a(b[7:4]),
	.b(d[7:4]),
	.is_sub(carry02),
	.P(P03),
	.G(G03),
	.sum(sum1[7:4])
	);

////////////////////////
// Level 1 : 3 adders//
//////////////////////

//1st addition
wire [8:0] sum2;
wire P10,G10;
wire carry10;
cla_4bit cla10 (	
	.a(sum0[3:0]),
	.b(sum1[3:0]),
	.is_sub(1'b0),
	.P(P10),
	.G(G10),
	.sum(sum2[3:0])
	);
assign carry10 = G10;

//2nd addition
wire P11,G11;
wire carry11;
cla_4bit cla11 (
	.a(sum0[7:4]),
	.b(sum1[7:4]),
	.is_sub(carry10),
	.P(P11),
	.G(G11),
	.sum(sum2[7:4])
	);
assign carry11 = G11 | P11 & carry10;

//3rd addition
wire P12,G12;
wire carry12;
cla_4bit cla12 (
	.a(4'b0000),
	.b(4'b0000),
	.is_sub(carry11),
	.P(P12),
	.G(G12),
	.sum(sum2[8])
	);

endmodule