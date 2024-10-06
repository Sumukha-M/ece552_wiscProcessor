`include "PC_inc_mem.v"
module PC_and_mem_tb ();
wire [15:0] read_addr;
reg clk;
reg rst;
wire [15:0] data_out;
reg enable;

PC_and_imem iDUT(.read_addr(read_addr),.clk(clk),.rst(rst),.data_out(data_out),.enable(enable));

initial begin
    $dumpvars(0,iDUT);
    $dumpfile("PC_mem_test.vcd");
end


initial begin
    clk = 0;
    rst = 1;
    @(posedge clk);
    @(negedge clk) rst = 0;
    enable = 1;
    repeat (40) @(posedge clk);
    $finish;
end
always 
#5 clk = ~clk;
endmodule