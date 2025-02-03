`include "read_decoder_4_16.v"
module read_decoder_4_16tb();
reg [3:0] in;
wire [15:0] wordline;

read_decoder_4_16 iDUT(.reg_id(in),.wordline(wordline));


initial begin
    $dumpfile("test.vcd");
    $dumpvars(0,iDUT);
end
initial begin
    in = 4'b0010;
    #15
    in = 4'b1001;
    #15
    in = 4'b1110;
    #15;
    $finish;
end

endmodule
