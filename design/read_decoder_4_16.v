// 3-to-8 decoder module declaration
module decoder_3to8 (
  input [2:0] in,
  output [7:0] out
);

// assigning out bits based on input combinations
assign out[0] = (~in[2] & ~in[1] & ~in[0]);
assign out[1] = (~in[2] & ~in[1] &  in[0]);
assign out[2] = (~in[2] &  in[1] & ~in[0]);
assign out[3] = (~in[2] &  in[1] &  in[0]);
assign out[4] = ( in[2] & ~in[1] & ~in[0]);
assign out[5] = ( in[2] & ~in[1] &  in[0]);
assign out[6] = ( in[2] &  in[1] & ~in[0]);
assign out[7] = ( in[2] &  in[1] &  in[0]);

endmodule

// 4to16 read decoder declaration
module read_decoder_4_16 (
  input [3:0] reg_id,
  output [15:0] wordline
);

// wires for 3to8 decoder outputs
wire [7:0] lower_wordline;
wire [7:0] upper_wordline;

// instantiate 3to8 decoders twice, one for upper and one for lower wordline
decoder_3to8 first(
	.in(reg_id[2:0]),
	.out(lower_wordline[7:0])
	);
	
decoder_3to8 second(
	.in(reg_id[2:0]),
	.out(upper_wordline[7:0])
	);

// select between lower and upper wordline based on msb of reg_id
assign wordline = (reg_id[3])?({upper_wordline[7:0],8'h00}):({8'h00,lower_wordline[7:0]});

endmodule

