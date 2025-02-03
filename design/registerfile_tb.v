`include "registerfile.v"
module registerfile_tb();
reg clk;
reg rst;
reg [3:0] src_reg1;
reg [3:0] src_reg2;
reg [3:0] dst_reg;
reg write_reg;
reg [15:0] dst_data;
wire [15:0] src_data1;
wire [15:0] src_data2;

registerfile iDUT ( .clk(clk),.rst(rst),.src_data1(src_data1),.src_data2(src_data2),.src_reg2(src_reg2),
                    .dst_reg(dst_reg),.write_reg(write_reg),.dst_data(dst_data),.src_reg1(src_reg1));

initial begin
    $dumpfile("test2.vcd");
    $dumpvars(0,iDUT);
end
initial begin
clk = 0;
rst = 1;
@(posedge clk);
@(negedge clk);
rst = 0;
dst_reg = 4'b0001;
dst_data = 16'h5151;
write_reg = 1'b1;
repeat (1) @(posedge clk);
src_reg1 = 4'b0001;
src_reg2 = 4'b0001;
repeat (20) @(posedge clk);
if(src_data1 == 16'h5151)
$display("Reading matched written value");
write_reg = 1'b0;
dst_data = 16'heeee;
repeat (20) @(posedge clk);
if(src_data1 == 16'h5151)
$display("The read enable works");
repeat (20) @(posedge clk);
$finish;
end

always
#5 clk = ~clk;

endmodule

