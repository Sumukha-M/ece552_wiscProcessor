// 3to8 decoder declaration
module decoder_3to8_2 (
    input [2:0] in,
    output [7:0] out
);

// assigning output based on input combo
assign out[0] = (~in[2] & ~in[1] & ~in[0]);
assign out[1] = (~in[2] & ~in[1] &  in[0]);
assign out[2] = (~in[2] &  in[1] & ~in[0]);
assign out[3] = (~in[2] &  in[1] &  in[0]);
assign out[4] = ( in[2] & ~in[1] & ~in[0]);
assign out[5] = ( in[2] & ~in[1] &  in[0]);
assign out[6] = ( in[2] &  in[1] & ~in[0]);
assign out[7] = ( in[2] &  in[1] &  in[0]);

endmodule

//4to16 write decoder declaration
module write_decoder_4_16 (
  input [3:0] reg_id,
  input write_reg,
  output [15:0] wordline
);

// wire for decoder ouputs
wire [7:0] lower_wordline;
wire [7:0] upper_wordline;

// instantiating 3to8 decoders for lower and upper wordlines
decoder_3to8_2 first(
	.in(reg_id[2:0]),
	.out(lower_wordline[7:0])
	);
decoder_3to8_2 second(
	.in(reg_id[2:0]),
	.out(upper_wordline[7:0]));

// selecting between lower and upper wordline based on write enable and msb of reg_id
assign wordline = (write_reg)?((reg_id[3])?({upper_wordline[7:0],8'h00}):({8'h00,lower_wordline[7:0]})):16'h0000;

endmodule

