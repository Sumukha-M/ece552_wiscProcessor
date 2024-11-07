`include "reduction.v"
module reduction_tb();
  reg signed  [7:0] a;
  reg signed  [7:0] b;
  reg signed  [7:0] c;
  reg signed [7:0] d;
  wire signed [15:0] sum;
  
  initial begin
    $dumpfile("reduction.vcd");
    $dumpvars(0,iDUT);
  end

  reduction iDUT(.a(a),.b(b),.c(c),.d(d),.sum3(sum));

  initial begin
    a = 8'hFF;
    c = 8'hFF;

    b = 8'hFF;
    d = 8'hFF;
    #5
    if(sum === a+b+c+d)
    $display("Success: Added %d, %d, %d, %d and got %d",a,c,b,d,sum);
    $finish;
  end


endmodule