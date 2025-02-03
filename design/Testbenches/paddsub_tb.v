`include "paddsub.v"
module paddsub_tb ();
 reg [15:0] a;
 reg [15:0] b;
 wire [15:0] sum;

 paddsub idut(.a(a),.b(b),.sum(sum));

 initial begin
    $dumpfile("paddsub.vcd");
    $dumpvars(0,idut);
 end


initial begin
    a = 16'h8833;
    b = 16'h8833;
    #5;
    if(sum === 16'h8866)
    $display("Success: Parallely added  %h and %h and got %h ",a,b,sum);
end
endmodule