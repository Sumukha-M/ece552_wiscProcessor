`include "cla_16bit.v"
module cla_16bit_tb ();
reg [15:0] a;
reg [15:0] b;
reg is_sub;
wire [15:0] sum;
wire ovfl;

initial begin
    $dumpfile("cla2.vcd");
    $dumpvars(0,iDUT);
end

cla_16bit iDUT(.a(a),.b_in(b),.is_sub(is_sub),.ovfl(ovfl),.sum(sum));
initial begin
    is_sub = 0;
    a = 16'h1200;
    b = 16'h3600;
    #5
    if(sum === a+b)
    $display("Addition success");
    is_sub = 1;
    #5
    if(sum === a-b)
    $display("Substraction sucesss");
    is_sub = 0;
    a = 16'h7FFF;
    b = 16'h7FFF;
    #5
    if(ovfl == 1)
    $display("Overflow works");
    #5
    $finish;

end
endmodule