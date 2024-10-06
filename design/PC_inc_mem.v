`include "dff.v"
`include "memory1c_instr.v"
module PC_and_imem(
    output [15:0] read_addr,
    input clk,
    input rst,
    output [15:0] data_out,
    input enable
);
wire [15:0] inc_addr_2;
dff pc0(.d(inc_addr_2[0]),.q(read_addr[0]),.wen(1'b1),.clk(clk),.rst(rst));
dff pc1(.d(inc_addr_2[1]),.q(read_addr[1]),.wen(1'b1),.clk(clk),.rst(rst));
dff pc2(.d(inc_addr_2[2]),.q(read_addr[2]),.wen(1'b1),.clk(clk),.rst(rst));
dff pc3(.d(inc_addr_2[3]),.q(read_addr[3]),.wen(1'b1),.clk(clk),.rst(rst));
dff pc4(.d(inc_addr_2[4]),.q(read_addr[4]),.wen(1'b1),.clk(clk),.rst(rst));
dff pc5(.d(inc_addr_2[5]),.q(read_addr[5]),.wen(1'b1),.clk(clk),.rst(rst));
dff pc6(.d(inc_addr_2[6]),.q(read_addr[6]),.wen(1'b1),.clk(clk),.rst(rst));
dff pc7(.d(inc_addr_2[7]),.q(read_addr[7]),.wen(1'b1),.clk(clk),.rst(rst));
dff pc8(.d(inc_addr_2[8]),.q(read_addr[8]),.wen(1'b1),.clk(clk),.rst(rst));
dff pc9(.d(inc_addr_2[9]),.q(read_addr[9]),.wen(1'b1),.clk(clk),.rst(rst));
dff pc10(.d(inc_addr_2[10]),.q(read_addr[10]),.wen(1'b1),.clk(clk),.rst(rst));
dff pc11(.d(inc_addr_2[11]),.q(read_addr[11]),.wen(1'b1),.clk(clk),.rst(rst));
dff pc12(.d(inc_addr_2[12]),.q(read_addr[12]),.wen(1'b1),.clk(clk),.rst(rst));
dff pc13(.d(inc_addr_2[13]),.q(read_addr[13]),.wen(1'b1),.clk(clk),.rst(rst));
dff pc14(.d(inc_addr_2[14]),.q(read_addr[14]),.wen(1'b1),.clk(clk),.rst(rst));
dff pc15(.d(inc_addr_2[15]),.q(read_addr[15]),.wen(1'b1),.clk(clk),.rst(rst));
    
assign inc_addr_2 = read_addr + 2;

memory1c_instr imem(.data_out(data_out),.addr(read_addr),.data_in(16'hzzzz),.wr(1'b0),
                    .enable(enable),.clk(clk),.rst(rst));

endmodule