`include "3to1mux_shifter.v"
module shifter_tb();
reg  signed [15:0] shift_in;
wire signed  [15:0] shift_out;
reg [3:0] shift_val;
reg [1:0] mode;

shifter_3to1 iDUT(.shift_in(shift_in),.shift_out(shift_out),.mode(mode),.shift_val(shift_val));

initial begin
    $dumpfile("shifter.vcd");
    $dumpvars(0,iDUT);
end


initial begin
 shift_in = 16'hCC33;
 mode = 2'b00;
 // Test left shifts
 for (integer i = 0; i < 16; i++) begin
    shift_val = i;
    #40;
    if (shift_in << shift_val == shift_out)
        $display("Left shift successful: got %b and shifted by %b to %b \n", shift_in, shift_val, shift_out);
end

// Change mode to arithmetic right shift
mode = 2'b01;

// Test arithmetic right shifts
for (integer i = 0; i < 16; i++) begin
    shift_val = i;
    #40;
    if (shift_in >>> shift_val == shift_out)
        $display("Arithmetic right shift successful: got %b and shifted by %b to %b \n", shift_in, shift_val, shift_out);
end

 mode = 2'b10;
for(integer i = 0; i < 16; i++) begin
 shift_val = i;
 #40;
 if(((shift_out == ((shift_in >> shift_val) | (shift_in << (16 - shift_val))))))
 $display("Rotate Right successful: got %b and shifted by %b to %b \n",shift_in,shift_val,shift_out);

end
$finish;
end
endmodule