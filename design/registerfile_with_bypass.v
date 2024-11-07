`include "register.v"
`include "read_decoder_4_16.v"
`include "write_decoder_4_16.v"

// register file module declaration
module registerfile (
	input clk,
	input rst,
	input [3:0] src_reg1,
	input [3:0] src_reg2,
	input [3:0] dst_reg,
	input write_reg,
	input [15:0] dst_data,
	inout [15:0] src_data1,
	inout [15:0] src_data2
);

//wire for decoder outputs
wire [15:0]rden1;
wire [15:0]rden2;
wire [15:0]wren;

// instantiating read decoders
read_decoder_4_16 src_reg1_dec(
	.reg_id(src_reg1),
	.wordline(rden1[15:0])
	);
read_decoder_4_16 src_reg2_dec(
	.reg_id(src_reg2),
	.wordline(rden2[15:0])
	);

// instantiating write decoder
write_decoder_4_16 dest_reg_dec(.reg_id(dst_reg),.wordline(wren[15:0]),.write_reg(write_reg));

register registers [15:0] (
	.clk(clk),
	.rst(rst),
	.d(dst_data),
	.write_reg(wren),
	.rden1(rden1),
	.rden2(rden2),
	.bitline1(src_data1),
	.bitline2(src_data2)
	);

endmodule