`include "bit_cell.v"

// register module declaration
module register (
    input clk,
    input rst,
    input [15:0] d,
    input write_reg,
    input rden1, // read enable signal for bitline1
    input rden2, // read enable signal for bitline2
    inout [15:0] bitline1,
    inout [15:0] bitline2
);
bit_cell bitcells [15:0] (
	.clk(clk),
	.rst(rst),
	.d(d),
	.wren(write_reg),
	.rden1(rden1),
	.rden2(rden2),
	.bitline1(bitline1),
	.bitline2(bitline2)
	);
endmodule
