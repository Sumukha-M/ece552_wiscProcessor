`ifndef CLA_16BIT_V
`define CLA_16BIT_V
`include "cla_4bit.v"

// cla 16bit module declaration
module cla_16bit (
    input [15:0] a,
    input [15:0] b_in,
    input is_sub, // for subtraction
    output [15:0]sum,
    output ovfl
);

wire [3:0] P; //propagate for 4 bit
wire [3:0] G; //generate for 4 bit
wire [3:0] C; //carry signal
wire [15:0] b; 

// complement and add for subtraction
assign b = (is_sub)?(~b_in):(b_in);

// instantiate 4-bit cla
// and calculating carries
cla_4bit cla1(
	.a(a[3:0]),
	.b(b[3:0]),
	.is_sub(is_sub),
	.sum(sum[3:0]),
	.P(P[0]),
	.G(G[0])
	);
assign C[0] = G[0] | (P[0]&is_sub);

cla_4bit cla2(
	.a(a[7:4]),
	.b(b[7:4]),
	.is_sub(C[0]),
	.sum(sum[7:4]),
	.P(P[1]),
	.G(G[1])
	);
assign C[1] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & is_sub);

cla_4bit cla3(
	.a(a[11:8]),
	.b(b[11:8]),
	.is_sub(C[1]),
	.sum(sum[11:8]),
	.P(P[2]),
	.G(G[2]));
assign C[2] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | ( P[2] & P[1] & P[0] & is_sub);

cla_4bit cla4(
	.a(a[15:12]),
	.b(b[15:12]),
	.is_sub(C[2]),
	.sum(sum[15:12]),
	.P(P[3]),
	.G(G[3]));
assign C[3] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & is_sub);

// calculating overflow flag
assign ovfl = C[3]^C[2];
endmodule
`endif