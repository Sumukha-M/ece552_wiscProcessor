`include "cla_4bit.v"
module cla_4bit_tb();
reg [3:0]a;
reg [3:0]b;
reg  is_sub;
wire [3:0]sum;
cla_4bit iDUT(.a(a),.b_in(b),.is_sub(is_sub),.sum(sum));


initial begin
  $dumpfile ("button_deb.vcd");
  $dumpvars (0, iDUT);
  #1;
end


initial begin
a = 4'b0101;
b = 4'b0110;
is_sub = 1'b0;
#15
if(a+b == sum) begin
is_sub = 1'b1;
#15
if(a-b == sum) begin
$display("Test passed\n");
$finish;
end
else begin
$display("Subtraction failed\n");
$stop;
end
end
else begin
$display("Addition failed\n");
end
end

endmodule
