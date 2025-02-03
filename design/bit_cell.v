`include "dff.v"

// bit cell module declaration
module bit_cell (
	input clk,
	input rst,
	input d,
	input wren,
	input rden1,
	input rden2,
	inout bitline1,
	inout bitline2
);

// wire for dff output
wire q;

// instantiate the dff DUT
dff cell_dff(
	.d(d),
	.rst(rst),
	.clk(clk),
	.wen(wren),
	.q(q)
	);

// buffer for bitline 1 based on read en signal
bufif1(bitline1,q,rden1);

//buffer for bitline2 based on read en signal
bufif1(bitline2,q,rden2);

endmodule
