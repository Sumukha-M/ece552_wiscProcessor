
module memory_tb ();

reg clk;
reg rst;
reg [15:0] data_in; // 2 byte data input port
reg wen;
reg [15:0] i_addr;
reg [15:0] d_addr; //address input port
reg i_read_en;
reg d_read_en;

wire [15:0] d_data_out, i_data_out;
wire d_stall;
wire i_stall;

reg [15:0] addr; ///test addresses
integer i;


memory imem(
     .clk(clk),
     .rst(rst),
     .data_in(data_in), // 2 byte data input port
     .wen(wen),
     .i_addr(i_addr),
     .d_addr(d_addr), //address input port
     .i_read_en(i_read_en), 
     .d_read_en(d_read_en),
     .d_stall(d_stall), 
     .i_stall(i_stall),
     .d_data_out(d_data_out),
     .i_data_out(i_data_out)
);

initial begin
    clk = 0;
    rst = 1;
    wen = 0;
    d_read_en = 0;
    i_read_en = 0;
    i_addr = 16'b0000;
    d_addr = 16'h0000;
    repeat (3) @(negedge clk);
    rst =0;
    addr[15:4] = 12'h000;
    addr[0] = 0;
    repeat(10) @(posedge clk);
    for (i=0; i<8; i = i+1) begin
        addr[3:1] = i;
        $display("Data in memory at address %h = %h",addr,imem.imemory.mem[addr[15:1]]);
    end

    addr[15:4] = 12'h080;
    addr[0] = 0;
    repeat(10) @(posedge clk);
    for (i=0; i<8; i = i+1) begin
        addr[3:1] = i;
        $display("Data in memory at address %h = %h",addr,imem.imemory.mem[addr[15:1]]);
    end
    
    
    @(negedge clk);
    d_read_en = 1;
    d_addr = 16'h0002;
    repeat(40) @(posedge clk);
    for (i = 0; i < 8 ;i = i + 1 ) begin
        d_addr[3:1] = i;
	@(posedge clk);
        $display("Data at %h in D_cache is : %h",d_addr,d_data_out);
    end
    d_read_en = 0;

    @(negedge clk);
    d_read_en = 1;
    d_addr = 16'h0804;
    repeat(40) @(posedge clk);
    for (i = 0; i < 8 ;i = i + 1 ) begin
        d_addr[3:1] = i;
	@(posedge clk);
        $display("Data at %h in D_cache is : %h",d_addr,d_data_out);
    end
    d_read_en = 0;

    @(negedge clk);
    d_read_en = 1;
    d_addr = 16'h0002;
    repeat(40) @(posedge clk);
    for (i = 0; i < 8 ;i = i + 1 ) begin
        d_addr[3:1] = i;
	@(posedge clk);
        $display("Data at %h in D_cache is : %h",d_addr,d_data_out);
    end
    d_read_en = 0;


    @(negedge clk);
    d_read_en = 1;
    d_addr = 16'h0c02;
    repeat(40) @(posedge clk);
    for (i = 0; i < 8 ;i = i + 1 ) begin
        d_addr[3:1] = i;
	@(posedge clk);
        $display("Data at %h in D_cache is : %h",d_addr,d_data_out);
    end
    d_read_en = 0;
    
    
/*

    @(negedge clk);
    d_read_en = 1;
    d_addr = 16'h0002;
    repeat(3) @(posedge clk);
    i_read_en = 1;
    i_addr = 16'h0004;
    repeat(50) @(posedge clk); 
    for (i = 0; i < 8 ;i = i + 1 ) begin
        d_addr[3:1] = i;
	@(posedge clk);
        $display("Data at %h in D_cache_again is : %h",d_addr,data_out);
    end
    d_read_en = 0;
    for (i = 0; i < 8 ;i = i + 1 ) begin
        i_addr[3:1] = i;
	@(posedge clk);
        $display("Data at %h in I_cache_again is : %h",i_addr,data_out);
    end
    i_read_en = 0; */

    addr[15:4] = 12'h050;
    addr[0] = 0;
    repeat(10) @(posedge clk);
    for (i=0; i<8; i = i+1) begin
        addr[3:1] = i;
        $display("Data in memory at address %h = %h",addr,imem.imemory.mem[addr[15:1]]);
    end
    
    repeat(30) @(posedge clk);
    @(negedge clk);
    wen = 1;
    d_addr = 16'h0502;
    data_in = 16'h5959;
    repeat(40) @(posedge clk);
    if(d_stall === 1'b0)
    wen = 0;
    for (i=0; i<8; i = i+1) begin
        d_addr[3:1] = i;
        $display("Data in memory at address %h = %h",d_addr,imem.imemory.mem[d_addr[15:1]]);
    end
    

    @(negedge clk);
    d_read_en = 1;
    for (i = 0; i < 8 ;i = i + 1 ) begin
        d_addr[3:1] = i;
	@(posedge clk);
        $display("Data at %h in D_cache is : %h",d_addr,d_data_out);
    end
    d_read_en = 0;

    $stop;


end

always 
#5 clk = ~clk;
    
endmodule