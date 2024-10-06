module CLA_16bit (
    input [15:0] a, b,
    input cin,
    output [15:0] sum,
    output cout
);
    wire [3:0] c;

    // Instantiate four 4-bit CLAs
    CLA_4bit cla0 (.a(a[3:0]), .b(b[3:0]), .cin(cin), .sum(sum[3:0]), .cout(c[0]));
    CLA_4bit cla1 (.a(a[7:4]), .b(b[7:4]), .cin(c[0]), .sum(sum[7:4]), .cout(c[1]));
    CLA_4bit cla2 (.a(a[11:8]), .b(b[11:8]), .cin(c[1]), .sum(sum[11:8]), .cout(c[2]));
    CLA_4bit cla3 (.a(a[15:12]), .b(b[15:12]), .cin(c[2]), .sum(sum[15:12]), .cout(cout));

endmodule
