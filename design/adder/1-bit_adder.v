
module full_adder_1bit (
	input a, 
	input b,
	input cin,
	output sum,
	output cout
	);
	
	wire t1, t2, t3;	// Intermediate signals for storing sum
	
	xor X1 (sum, a, b, cin);
	and A1 (t1, a, b);
	and A2 (t2, b, cin);
	and A3 (t3, a, cin);
	or  O1 (cout, t1, t2, t3);
	
endmodule
