module shifter_3to1 (
    input [15:0]shift_in,
    input [3:0] shift_val,
    input [1:0] mode,
    output reg [15:0] shift_out
);
// intermediate wire for base 3 shift value
wire [5:0] shift_val_base3;

// determining base 3 shift value based on shift amount
assign shift_val_base3 = (shift_val == 4'b0000)? 6'b00_00_00:
						 (shift_val == 4'b0001)? 6'b00_00_01:
						 (shift_val == 4'b0010)? 6'b00_00_10:
						 (shift_val == 4'b0011)? 6'b00_01_00:
						 (shift_val == 4'b0100)? 6'b00_01_01:
						 (shift_val == 4'b0101)? 6'b00_01_10:
						 (shift_val == 4'b0110)? 6'b00_10_00:
						 (shift_val == 4'b0111)? 6'b00_10_01:
						 (shift_val == 4'b1000)? 6'b00_10_10:
						 (shift_val == 4'b1001)? 6'b01_00_00:
						 (shift_val == 4'b1010)? 6'b01_00_01:
						 (shift_val == 4'b1011)? 6'b01_00_10:
						 (shift_val == 4'b1100)? 6'b01_01_00:
						 (shift_val == 4'b1101)? 6'b01_01_01:
						 (shift_val == 4'b1110)? 6'b01_01_10:
						 (shift_val == 4'b1111)? 6'b01_10_00:
						  6'bzz_zz_zz;
						  
// temporary wires for intermediate shift values
reg [15:0] t1;
reg [15:0] t2;
always @(*) begin
    case(mode) 
    2'b00: begin
        t1[0] = (shift_val_base3[1:0] == 2'b00)?(shift_in[0]):(shift_val_base3[1:0] == 2'b01)?(1'b0):(1'b0);
        t1[1] = (shift_val_base3[1:0] == 2'b00)?(shift_in[1]):(shift_val_base3[1:0] == 2'b01)?(shift_in[0]):(1'b0);
        t1[2] = (shift_val_base3[1:0] == 2'b00)?(shift_in[2]):(shift_val_base3[1:0] == 2'b01)?(shift_in[1]):(shift_in[0]);
        t1[3] = (shift_val_base3[1:0] == 2'b00)?(shift_in[3]):(shift_val_base3[1:0] == 2'b01)?(shift_in[2]):(shift_in[1]);
        t1[4] = (shift_val_base3[1:0] == 2'b00)?(shift_in[4]):(shift_val_base3[1:0] == 2'b01)?(shift_in[3]):(shift_in[2]);
        t1[5] = (shift_val_base3[1:0] == 2'b00)?(shift_in[5]):(shift_val_base3[1:0] == 2'b01)?(shift_in[4]):(shift_in[3]);
        t1[6] = (shift_val_base3[1:0] == 2'b00)?(shift_in[6]):(shift_val_base3[1:0] == 2'b01)?(shift_in[5]):(shift_in[4]);
        t1[7] = (shift_val_base3[1:0] == 2'b00)?(shift_in[7]):(shift_val_base3[1:0] == 2'b01)?(shift_in[6]):(shift_in[5]);
        t1[8] = (shift_val_base3[1:0] == 2'b00)?(shift_in[8]):(shift_val_base3[1:0] == 2'b01)?(shift_in[7]):(shift_in[6]);
        t1[9] = (shift_val_base3[1:0] == 2'b00)?(shift_in[9]):(shift_val_base3[1:0] == 2'b01)?(shift_in[8]):(shift_in[7]);
        t1[10] = (shift_val_base3[1:0] == 2'b00)?(shift_in[10]):(shift_val_base3[1:0] == 2'b01)?(shift_in[9]):(shift_in[8]);
        t1[11] = (shift_val_base3[1:0] == 2'b00)?(shift_in[11]):(shift_val_base3[1:0] == 2'b01)?(shift_in[10]):(shift_in[9]);
        t1[12] = (shift_val_base3[1:0] == 2'b00)?(shift_in[12]):(shift_val_base3[1:0] == 2'b01)?(shift_in[11]):(shift_in[10]);
        t1[13] = (shift_val_base3[1:0] == 2'b00)?(shift_in[13]):(shift_val_base3[1:0] == 2'b01)?(shift_in[12]):(shift_in[11]);
        t1[14] = (shift_val_base3[1:0] == 2'b00)?(shift_in[14]):(shift_val_base3[1:0] == 2'b01)?(shift_in[13]):(shift_in[12]);
        t1[15] = (shift_val_base3[1:0] == 2'b00)?(shift_in[15]):(shift_val_base3[1:0] == 2'b01)?(shift_in[14]):(shift_in[13]);

        t2[0] = (shift_val_base3[3:2] == 2'b00)?(t1[0]):(shift_val_base3[3:2] == 2'b01)?(1'b0):(1'b0);
        t2[1] = (shift_val_base3[3:2] == 2'b00)?(t1[1]):(shift_val_base3[3:2] == 2'b01)?(1'b0):(1'b0);
        t2[2] = (shift_val_base3[3:2] == 2'b00)?(t1[2]):(shift_val_base3[3:2] == 2'b01)?(1'b0):(1'b0);
        t2[3] = (shift_val_base3[3:2] == 2'b00)?(t1[3]):(shift_val_base3[3:2] == 2'b01)?(t1[0]):(1'b0);
        t2[4] = (shift_val_base3[3:2] == 2'b00)?(t1[4]):(shift_val_base3[3:2] == 2'b01)?(t1[1]):(1'b0);
        t2[5] = (shift_val_base3[3:2] == 2'b00)?(t1[5]):(shift_val_base3[3:2] == 2'b01)?(t1[2]):(1'b0);
        t2[6] = (shift_val_base3[3:2] == 2'b00)?(t1[6]):(shift_val_base3[3:2] == 2'b01)?(t1[3]):(t1[0]);
        t2[7] = (shift_val_base3[3:2] == 2'b00)?(t1[7]):(shift_val_base3[3:2] == 2'b01)?(t1[4]):(t1[1]);
        t2[8] = (shift_val_base3[3:2] == 2'b00)?(t1[8]):(shift_val_base3[3:2] == 2'b01)?(t1[5]):(t1[2]);
        t2[9] = (shift_val_base3[3:2] == 2'b00)?(t1[9]):(shift_val_base3[3:2] == 2'b01)?(t1[6]):(t1[3]);
        t2[10] = (shift_val_base3[3:2] == 2'b00)?(t1[10]):(shift_val_base3[3:2] == 2'b01)?(t1[7]):(t1[4]);
        t2[11] = (shift_val_base3[3:2] == 2'b00)?(t1[11]):(shift_val_base3[3:2] == 2'b01)?(t1[8]):(t1[5]);
        t2[12] = (shift_val_base3[3:2] == 2'b00)?(t1[12]):(shift_val_base3[3:2] == 2'b01)?(t1[9]):(t1[6]);
        t2[13] = (shift_val_base3[3:2] == 2'b00)?(t1[13]):(shift_val_base3[3:2] == 2'b01)?(t1[10]):(t1[7]);
        t2[14] = (shift_val_base3[3:2] == 2'b00)?(t1[14]):(shift_val_base3[3:2] == 2'b01)?(t1[11]):(t1[8]);
        t2[15] = (shift_val_base3[3:2] == 2'b00)?(t1[15]):(shift_val_base3[3:2] == 2'b01)?(t1[12]):(t1[9]);

        shift_out[0] = (shift_val_base3[5:4] == 2'b00)?(t2[0]):(shift_val_base3[5:4] == 2'b01)?(1'b0):(1'b0);
        shift_out[1] = (shift_val_base3[5:4] == 2'b00)?(t2[1]):(shift_val_base3[5:4] == 2'b01)?(1'b0):(1'b0);
        shift_out[2] = (shift_val_base3[5:4] == 2'b00)?(t2[2]):(shift_val_base3[5:4] == 2'b01)?(1'b0):(1'b0);
        shift_out[3] = (shift_val_base3[5:4] == 2'b00)?(t2[3]):(shift_val_base3[5:4] == 2'b01)?(1'b0):(1'b0);
        shift_out[4] = (shift_val_base3[5:4] == 2'b00)?(t2[4]):(shift_val_base3[5:4] == 2'b01)?(1'b0):(1'b0);
        shift_out[5] = (shift_val_base3[5:4] == 2'b00)?(t2[5]):(shift_val_base3[5:4] == 2'b01)?(1'b0):(1'b0);
        shift_out[6] = (shift_val_base3[5:4] == 2'b00)?(t2[6]):(shift_val_base3[5:4] == 2'b01)?(1'b0):(1'b0);
        shift_out[7] = (shift_val_base3[5:4] == 2'b00)?(t2[7]):(shift_val_base3[5:4] == 2'b01)?(1'b0):(1'b0);
        shift_out[8] = (shift_val_base3[5:4] == 2'b00)?(t2[8]):(shift_val_base3[5:4] == 2'b01)?(1'b0):(1'b0);
        shift_out[9] = (shift_val_base3[5:4] == 2'b00)?(t2[9]):(shift_val_base3[5:4] == 2'b01)?(t2[0]):(1'b0);
        shift_out[10] = (shift_val_base3[5:4] == 2'b00)?(t2[10]):(shift_val_base3[5:4] == 2'b01)?(t2[1]):(1'b0);
        shift_out[11] = (shift_val_base3[5:4] == 2'b00)?(t2[11]):(shift_val_base3[5:4] == 2'b01)?(t2[2]):(1'b0);
        shift_out[12] = (shift_val_base3[5:4] == 2'b00)?(t2[12]):(shift_val_base3[5:4] == 2'b01)?(t2[3]):(1'b0);
        shift_out[13] = (shift_val_base3[5:4] == 2'b00)?(t2[13]):(shift_val_base3[5:4] == 2'b01)?(t2[4]):(1'b0);
        shift_out[14] = (shift_val_base3[5:4] == 2'b00)?(t2[14]):(shift_val_base3[5:4] == 2'b01)?(t2[5]):(1'b0);
        shift_out[15] = (shift_val_base3[5:4] == 2'b00)?(t2[15]):(shift_val_base3[5:4] == 2'b01)?(t2[6]):(1'b0);
    end
    2'b01: begin
        t1[0] = (shift_val_base3[1:0] == 2'b00)?(shift_in[0]):(shift_val_base3[1:0] == 2'b01)?(shift_in[1]):(shift_in[2]);
        t1[1] = (shift_val_base3[1:0] == 2'b00)?(shift_in[1]):(shift_val_base3[1:0] == 2'b01)?(shift_in[2]):(shift_in[3]);
        t1[2] = (shift_val_base3[1:0] == 2'b00)?(shift_in[2]):(shift_val_base3[1:0] == 2'b01)?(shift_in[3]):(shift_in[4]);
        t1[3] = (shift_val_base3[1:0] == 2'b00)?(shift_in[3]):(shift_val_base3[1:0] == 2'b01)?(shift_in[4]):(shift_in[5]);
        t1[4] = (shift_val_base3[1:0] == 2'b00)?(shift_in[4]):(shift_val_base3[1:0] == 2'b01)?(shift_in[5]):(shift_in[6]);
        t1[5] = (shift_val_base3[1:0] == 2'b00)?(shift_in[5]):(shift_val_base3[1:0] == 2'b01)?(shift_in[6]):(shift_in[7]);
        t1[6] = (shift_val_base3[1:0] == 2'b00)?(shift_in[6]):(shift_val_base3[1:0] == 2'b01)?(shift_in[7]):(shift_in[8]);
        t1[7] = (shift_val_base3[1:0] == 2'b00)?(shift_in[7]):(shift_val_base3[1:0] == 2'b01)?(shift_in[8]):(shift_in[9]);
        t1[8] = (shift_val_base3[1:0] == 2'b00)?(shift_in[8]):(shift_val_base3[1:0] == 2'b01)?(shift_in[9]):(shift_in[10]);
        t1[9] = (shift_val_base3[1:0] == 2'b00)?(shift_in[9]):(shift_val_base3[1:0] == 2'b01)?(shift_in[10]):(shift_in[11]);
        t1[10] = (shift_val_base3[1:0] == 2'b00)?(shift_in[10]):(shift_val_base3[1:0] == 2'b01)?(shift_in[11]):(shift_in[12]);
        t1[11] = (shift_val_base3[1:0] == 2'b00)?(shift_in[11]):(shift_val_base3[1:0] == 2'b01)?(shift_in[12]):(shift_in[13]);
        t1[12] = (shift_val_base3[1:0] == 2'b00)?(shift_in[12]):(shift_val_base3[1:0] == 2'b01)?(shift_in[13]):(shift_in[14]);
        t1[13] = (shift_val_base3[1:0] == 2'b00)?(shift_in[13]):(shift_val_base3[1:0] == 2'b01)?(shift_in[14]):(shift_in[15]);
        t1[14] = (shift_val_base3[1:0] == 2'b00)?(shift_in[14]):(shift_val_base3[1:0] == 2'b01)?(shift_in[15]):(shift_in[15]);
        t1[15] = (shift_val_base3[1:0] == 2'b00)?(shift_in[15]):(shift_val_base3[1:0] == 2'b01)?(shift_in[15]):(shift_in[15]);

        t2[0] = (shift_val_base3[3:2] == 2'b00)?(t1[0]):(shift_val_base3[3:2] == 2'b01)?(t1[3]):(t1[6]);
        t2[1] = (shift_val_base3[3:2] == 2'b00)?(t1[1]):(shift_val_base3[3:2] == 2'b01)?(t1[4]):(t1[7]);
        t2[2] = (shift_val_base3[3:2] == 2'b00)?(t1[2]):(shift_val_base3[3:2] == 2'b01)?(t1[5]):(t1[8]);
        t2[3] = (shift_val_base3[3:2] == 2'b00)?(t1[3]):(shift_val_base3[3:2] == 2'b01)?(t1[6]):(t1[9]);
        t2[4] = (shift_val_base3[3:2] == 2'b00)?(t1[4]):(shift_val_base3[3:2] == 2'b01)?(t1[7]):(t1[10]);
        t2[5] = (shift_val_base3[3:2] == 2'b00)?(t1[5]):(shift_val_base3[3:2] == 2'b01)?(t1[8]):(t1[11]);
        t2[6] = (shift_val_base3[3:2] == 2'b00)?(t1[6]):(shift_val_base3[3:2] == 2'b01)?(t1[9]):(t1[12]);
        t2[7] = (shift_val_base3[3:2] == 2'b00)?(t1[7]):(shift_val_base3[3:2] == 2'b01)?(t1[10]):(t1[13]);
        t2[8] = (shift_val_base3[3:2] == 2'b00)?(t1[8]):(shift_val_base3[3:2] == 2'b01)?(t1[11]):(t1[14]);
        t2[9] = (shift_val_base3[3:2] == 2'b00)?(t1[9]):(shift_val_base3[3:2] == 2'b01)?(t1[12]):(t1[15]);
        t2[10] = (shift_val_base3[3:2] == 2'b00)?(t1[10]):(shift_val_base3[3:2] == 2'b01)?(t1[13]):(t1[15]);
        t2[11] = (shift_val_base3[3:2] == 2'b00)?(t1[11]):(shift_val_base3[3:2] == 2'b01)?(t1[14]):(t1[15]);
        t2[12] = (shift_val_base3[3:2] == 2'b00)?(t1[12]):(shift_val_base3[3:2] == 2'b01)?(t1[15]):(t1[15]);
        t2[13] = (shift_val_base3[3:2] == 2'b00)?(t1[13]):(shift_val_base3[3:2] == 2'b01)?(t1[15]):(t1[15]);
        t2[14] = (shift_val_base3[3:2] == 2'b00)?(t1[14]):(shift_val_base3[3:2] == 2'b01)?(t1[15]):(t1[15]);
        t2[15] = (shift_val_base3[3:2] == 2'b00)?(t1[15]):(shift_val_base3[3:2] == 2'b01)?(t1[15]):(t1[15]);

        shift_out[0] = (shift_val_base3[5:4] == 2'b00)?(t2[0]):(shift_val_base3[5:4] == 2'b01)?(t2[9]):(t2[15]);
        shift_out[1] = (shift_val_base3[5:4] == 2'b00)?(t2[1]):(shift_val_base3[5:4] == 2'b01)?(t2[10]):(t2[15]);
        shift_out[2] = (shift_val_base3[5:4] == 2'b00)?(t2[2]):(shift_val_base3[5:4] == 2'b01)?(t2[11]):(t2[15]);
        shift_out[3] = (shift_val_base3[5:4] == 2'b00)?(t2[3]):(shift_val_base3[5:4] == 2'b01)?(t2[12]):(t2[15]);
        shift_out[4] = (shift_val_base3[5:4] == 2'b00)?(t2[4]):(shift_val_base3[5:4] == 2'b01)?(t2[13]):(t2[15]);
        shift_out[5] = (shift_val_base3[5:4] == 2'b00)?(t2[5]):(shift_val_base3[5:4] == 2'b01)?(t2[14]):(t2[15]);
        shift_out[6] = (shift_val_base3[5:4] == 2'b00)?(t2[6]):(shift_val_base3[5:4] == 2'b01)?(t2[15]):(t2[15]);
        shift_out[7] = (shift_val_base3[5:4] == 2'b00)?(t2[7]):(shift_val_base3[5:4] == 2'b01)?(t2[15]):(t2[15]);
        shift_out[8] = (shift_val_base3[5:4] == 2'b00)?(t2[8]):(shift_val_base3[5:4] == 2'b01)?(t2[15]):(t2[15]);
        shift_out[9] = (shift_val_base3[5:4] == 2'b00)?(t2[9]):(shift_val_base3[5:4] == 2'b01)?(t2[15]):(t2[15]);
        shift_out[10] = (shift_val_base3[5:4] == 2'b00)?(t2[10]):(shift_val_base3[5:4] == 2'b01)?(t2[15]):(t2[15]);
        shift_out[11] = (shift_val_base3[5:4] == 2'b00)?(t2[11]):(shift_val_base3[5:4] == 2'b01)?(t2[15]):(t2[15]);
        shift_out[12] = (shift_val_base3[5:4] == 2'b00)?(t2[12]):(shift_val_base3[5:4] == 2'b01)?(t2[15]):(t2[15]);
        shift_out[13] = (shift_val_base3[5:4] == 2'b00)?(t2[13]):(shift_val_base3[5:4] == 2'b01)?(t2[15]):(t2[15]);
        shift_out[14] = (shift_val_base3[5:4] == 2'b00)?(t2[14]):(shift_val_base3[5:4] == 2'b01)?(t2[15]):(t2[15]);
        shift_out[15] = (shift_val_base3[5:4] == 2'b00)?(t2[15]):(shift_val_base3[5:4] == 2'b01)?(t2[15]):(t2[15]);
    end
    2'b10: begin
        t1[0] = (shift_val_base3[1:0] == 2'b00)?(shift_in[0]):(shift_val_base3[1:0] == 2'b01)?(shift_in[1]):(shift_in[2]);
        t1[1] = (shift_val_base3[1:0] == 2'b00)?(shift_in[1]):(shift_val_base3[1:0] == 2'b01)?(shift_in[2]):(shift_in[3]);
        t1[2] = (shift_val_base3[1:0] == 2'b00)?(shift_in[2]):(shift_val_base3[1:0] == 2'b01)?(shift_in[3]):(shift_in[4]);
        t1[3] = (shift_val_base3[1:0] == 2'b00)?(shift_in[3]):(shift_val_base3[1:0] == 2'b01)?(shift_in[4]):(shift_in[5]);
        t1[4] = (shift_val_base3[1:0] == 2'b00)?(shift_in[4]):(shift_val_base3[1:0] == 2'b01)?(shift_in[5]):(shift_in[6]);
        t1[5] = (shift_val_base3[1:0] == 2'b00)?(shift_in[5]):(shift_val_base3[1:0] == 2'b01)?(shift_in[6]):(shift_in[7]);
        t1[6] = (shift_val_base3[1:0] == 2'b00)?(shift_in[6]):(shift_val_base3[1:0] == 2'b01)?(shift_in[7]):(shift_in[8]);
        t1[7] = (shift_val_base3[1:0] == 2'b00)?(shift_in[7]):(shift_val_base3[1:0] == 2'b01)?(shift_in[8]):(shift_in[9]);
        t1[8] = (shift_val_base3[1:0] == 2'b00)?(shift_in[8]):(shift_val_base3[1:0] == 2'b01)?(shift_in[9]):(shift_in[10]);
        t1[9] = (shift_val_base3[1:0] == 2'b00)?(shift_in[9]):(shift_val_base3[1:0] == 2'b01)?(shift_in[10]):(shift_in[11]);
        t1[10] = (shift_val_base3[1:0] == 2'b00)?(shift_in[10]):(shift_val_base3[1:0] == 2'b01)?(shift_in[11]):(shift_in[12]);
        t1[11] = (shift_val_base3[1:0] == 2'b00)?(shift_in[11]):(shift_val_base3[1:0] == 2'b01)?(shift_in[12]):(shift_in[13]);
        t1[12] = (shift_val_base3[1:0] == 2'b00)?(shift_in[12]):(shift_val_base3[1:0] == 2'b01)?(shift_in[13]):(shift_in[14]);
        t1[13] = (shift_val_base3[1:0] == 2'b00)?(shift_in[13]):(shift_val_base3[1:0] == 2'b01)?(shift_in[14]):(shift_in[15]);
        t1[14] = (shift_val_base3[1:0] == 2'b00)?(shift_in[14]):(shift_val_base3[1:0] == 2'b01)?(shift_in[15]):(shift_in[0]);
        t1[15] = (shift_val_base3[1:0] == 2'b00)?(shift_in[15]):(shift_val_base3[1:0] == 2'b01)?(shift_in[0]):(shift_in[1]);

        t2[0] = (shift_val_base3[3:2] == 2'b00)?(t1[0]):(shift_val_base3[3:2] == 2'b01)?(t1[3]):(t1[6]);
        t2[1] = (shift_val_base3[3:2] == 2'b00)?(t1[1]):(shift_val_base3[3:2] == 2'b01)?(t1[4]):(t1[7]);
        t2[2] = (shift_val_base3[3:2] == 2'b00)?(t1[2]):(shift_val_base3[3:2] == 2'b01)?(t1[5]):(t1[8]);
        t2[3] = (shift_val_base3[3:2] == 2'b00)?(t1[3]):(shift_val_base3[3:2] == 2'b01)?(t1[6]):(t1[9]);
        t2[4] = (shift_val_base3[3:2] == 2'b00)?(t1[4]):(shift_val_base3[3:2] == 2'b01)?(t1[7]):(t1[10]);
        t2[5] = (shift_val_base3[3:2] == 2'b00)?(t1[5]):(shift_val_base3[3:2] == 2'b01)?(t1[8]):(t1[11]);
        t2[6] = (shift_val_base3[3:2] == 2'b00)?(t1[6]):(shift_val_base3[3:2] == 2'b01)?(t1[9]):(t1[12]);
        t2[7] = (shift_val_base3[3:2] == 2'b00)?(t1[7]):(shift_val_base3[3:2] == 2'b01)?(t1[10]):(t1[13]);
        t2[8] = (shift_val_base3[3:2] == 2'b00)?(t1[8]):(shift_val_base3[3:2] == 2'b01)?(t1[11]):(t1[14]);
        t2[9] = (shift_val_base3[3:2] == 2'b00)?(t1[9]):(shift_val_base3[3:2] == 2'b01)?(t1[12]):(t1[15]);
        t2[10] = (shift_val_base3[3:2] == 2'b00)?(t1[10]):(shift_val_base3[3:2] == 2'b01)?(t1[13]):(t1[0]);
        t2[11] = (shift_val_base3[3:2] == 2'b00)?(t1[11]):(shift_val_base3[3:2] == 2'b01)?(t1[14]):(t1[1]);
        t2[12] = (shift_val_base3[3:2] == 2'b00)?(t1[12]):(shift_val_base3[3:2] == 2'b01)?(t1[15]):(t1[2]);
        t2[13] = (shift_val_base3[3:2] == 2'b00)?(t1[13]):(shift_val_base3[3:2] == 2'b01)?(t1[0]):(t1[3]);
        t2[14] = (shift_val_base3[3:2] == 2'b00)?(t1[14]):(shift_val_base3[3:2] == 2'b01)?(t1[1]):(t1[4]);
        t2[15] = (shift_val_base3[3:2] == 2'b00)?(t1[15]):(shift_val_base3[3:2] == 2'b01)?(t1[2]):(t1[5]);

        
        shift_out[0] = (shift_val_base3[5:4] == 2'b00)?(t2[0]):(shift_val_base3[5:4] == 2'b01)?(t2[9]):(t2[3]);
        shift_out[1] = (shift_val_base3[5:4] == 2'b00)?(t2[1]):(shift_val_base3[5:4] == 2'b01)?(t2[10]):(t2[4]);
        shift_out[2] = (shift_val_base3[5:4] == 2'b00)?(t2[2]):(shift_val_base3[5:4] == 2'b01)?(t2[11]):(t2[5]);
        shift_out[3] = (shift_val_base3[5:4] == 2'b00)?(t2[3]):(shift_val_base3[5:4] == 2'b01)?(t2[12]):(t2[6]);
        shift_out[4] = (shift_val_base3[5:4] == 2'b00)?(t2[4]):(shift_val_base3[5:4] == 2'b01)?(t2[13]):(t2[7]);
        shift_out[5] = (shift_val_base3[5:4] == 2'b00)?(t2[5]):(shift_val_base3[5:4] == 2'b01)?(t2[14]):(t2[8]);
        shift_out[6] = (shift_val_base3[5:4] == 2'b00)?(t2[6]):(shift_val_base3[5:4] == 2'b01)?(t2[15]):(t2[9]);
        shift_out[7] = (shift_val_base3[5:4] == 2'b00)?(t2[7]):(shift_val_base3[5:4] == 2'b01)?(t2[0]):(t2[10]);
        shift_out[8] = (shift_val_base3[5:4] == 2'b00)?(t2[8]):(shift_val_base3[5:4] == 2'b01)?(t2[1]):(t2[11]);
        shift_out[9] = (shift_val_base3[5:4] == 2'b00)?(t2[9]):(shift_val_base3[5:4] == 2'b01)?(t2[2]):(t2[12]);
        shift_out[10] = (shift_val_base3[5:4] == 2'b00)?(t2[10]):(shift_val_base3[5:4] == 2'b01)?(t2[3]):(t2[13]);
        shift_out[11] = (shift_val_base3[5:4] == 2'b00)?(t2[11]):(shift_val_base3[5:4] == 2'b01)?(t2[4]):(t2[14]);
        shift_out[12] = (shift_val_base3[5:4] == 2'b00)?(t2[12]):(shift_val_base3[5:4] == 2'b01)?(t2[5]):(t2[15]);
        shift_out[13] = (shift_val_base3[5:4] == 2'b00)?(t2[13]):(shift_val_base3[5:4] == 2'b01)?(t2[6]):(t2[0]);
        shift_out[14] = (shift_val_base3[5:4] == 2'b00)?(t2[14]):(shift_val_base3[5:4] == 2'b01)?(t2[7]):(t2[1]);
        shift_out[15] = (shift_val_base3[5:4] == 2'b00)?(t2[15]):(shift_val_base3[5:4] == 2'b01)?(t2[8]):(t2[2]);
    end
        
          
    endcase
end  
endmodule