`include "alu.v"
`include "cla_16bit.v"
`include "dff.v"
`include "memory1c_data.v"
`include "memory1c_instr.v"
`include "GLobal_Control.v"
`include "registerfile.v"

// cpu module declaration
module cpu (
    input clk,
    input rst,
    output hlt,
    output [15:0] pc
);

//flag register
wire [2:0] flag;


//pc signals
wire [15:0] pc_next; 
wire [15:0] pc_curr;

//instruction signals
wire [15:0] instruction;

//global control unit wires
wire RegWrite;
wire MemWrite;
wire MemRead;
wire ALUSrc;
wire Reg1Select;
wire [1:0] WheretoReg;
wire [3:0] ALUOp;
wire b;
wire br;
wire pcs;
wire hlt;
wire not_hlt;
wire flag_z_en;
wire flag_n_en;
wire flag_v_en;

//register file wires
wire [3:0] read_reg1;
wire [3:0] read_reg2;
wire [3:0] write_reg;
wire [15:0] write_data;
wire [15:0] read_data1;
wire [15:0] read_data2;

//alu wires
wire [8:0] immediate;
wire [15:0] sign_ext_immediate;
wire [15:0] alu_in1;
wire [15:0] alu_in2;
wire [15:0] alu_out;

//data memory wires
wire [15:0] data_addr;
wire [15:0] write_data_mem;
wire [15:0] read_data_mem;

//branching wires
wire [15:0] lshift_immediate; //16 bit immediate value with shift
wire [15:0] pc1; //next_addr_without_branching
wire [15:0] pc2; //next_addr_for_B
wire [15:0] pc3; //either pc1 or pc2
wire [15:0] pc4; //pc3 or read_data_1

// instantiate global control module
Global_Control global_control (
    .opcode_ccc(instruction[15:9]),
    .f(flag),
    .RegWrite(RegWrite),
    .MemWrite(MemWrite),
    .MemRead(MemRead),
    .ALUSrc(ALUSrc),
    .Reg1Select(Reg1Select),
    .WheretoReg(WheretoReg),
    .ALUOp(ALUOp),
    .b(b),
    .br(br),
    .pcs(pcs),
    .hlt(hlt),
    .not_hlt(not_hlt),
    .flag_z_en(flag_z_en),
    .flag_v_en(flag_v_en),
    .flag_n_en(flag_n_en)
);

//pc instantiation inputs and outputs
dff pc_reg[15:0](
    .clk(clk), 
    .rst(rst), 
    .wen(not_hlt), 
    .d(pc_next), 
    .q(pc_curr)
);

//flag register 

//instantiating memory
memory1c_instr instruction_memory (
    .data_out(instruction),
    .addr(pc_curr),
    .data_in(16'hzzzz),
    .wr(1'b0),
    .enable(1'b1),
    .clk(clk),
    .rst(rst)
);

//register file instantiation
assign read_reg1 = (Reg1Select)?(instruction[11:8]):instruction[7:4];
assign read_reg2 = (MemWrite)?(instruction[11:8]):instruction[3:0];
assign write_reg = instruction[11:8];
assign write_data = (WheretoReg == 00) ? (pc_next):
                    (WheretoReg == 01) ? (read_data_mem):
                    (WheretoReg == 10) ? (alu_out):
                    alu_out; 

registerfile registerfile ( 
    .clk(clk),
    .rst(rst),
    .src_reg1(read_reg1),
    .src_reg2(read_reg2),
    .src_data1(read_data1),
    .src_data2(read_data2),
    .dst_reg(write_reg),
    .dst_data(write_data),
    .write_reg(RegWrite) 
);


//alu_instantiation
assign immediate = instruction[8:0];
assign sign_ext_immediate = {{7{immediate[8]}},immediate[8:0]};
assign alu_in1 = read_data1;
assign alu_in2 = (ALUSrc) ? (sign_ext_immediate) : (read_data2);

wire ovfl;
alu_16bit alu(
    .alu_in1(alu_in1),
    .alu_in2(alu_in2),
    .opcode(ALUOp),
    .alu_out(alu_out),
    .ovfl(ovfl)
);
dff z(.clk(clk),.rst(rst),.d(~(|alu_out)),.q(flag[0]),.wen(flag_z_en));
dff v(.clk(clk),.rst(rst),.d(ovfl),.q(flag[1]),.wen(flag_v_en));
dff n(.clk(clk),.rst(rst),.d(alu_out[15]),.q(flag[2]),.wen(flag_n_en));

//data_memory instantiation
assign data_addr = alu_out;
assign write_data_mem = read_data2;

memory1c_data data_memory (
    .data_out(read_data_mem),
    .addr(data_addr),
    .data_in(write_data_mem),
    .wr(MemWrite),
    .enable(MemRead | MemWrite),
    .clk(clk),
    .rst(rst)
);

//handling branch instructions
assign lshift_immediate = {{7{(immediate[8])}}, (immediate << 1)};
//pc adder
cla_16bit pc_adder1(
	.a(pc_curr),
	.b_in(16'h0002),
	.sum(pc1),
	.ovfl(),
	.is_sub(1'b0)
	);
	
cla_16bit pc_adder2(
	.a(pc1),
	.b_in(lshift_immediate),
	.sum(pc2),
	.ovfl(),
	.is_sub(1'b0)
	);
	
assign pc3 = (b) ? (pc2) : (pc1);
assign pc4 = (br) ? (read_data1) : (pc3);
assign pc_next = (hlt) ? (pc_curr) : (pc4);

//CPU outputs
assign pc = pc_curr;

endmodule

