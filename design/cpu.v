module cpu (
    input clk,
    input rst,
    output hlt_sig,
    output [15:0] pc
);

//pc signals
wire [15:0] pc_next_cal;
wire [15:0] pc_next; 
wire [15:0] pc_curr;

//instruction signals
wire [15:0] instruction;

//flag register
wire [2:0] flag;

///IF STAGE NETS/////
wire not_hlt;
wire [15:0] pc_next_if_id;
wire [15:0] instruction_if_id;

////CACHE_STALL_SIGNALS/////
wire d_stall;
wire i_stall;

///ID STAGE NETS///
 
///RF bypass control
    wire flag_bypass;
    wire [2:0] flag_out; ///flag values that actually go into control
    wire bypass_control_reg1;
    wire bypass_control_reg2;
    wire [15:0] read_data1_rf;
    wire [15:0] read_data2_rf;
///Hazard Detection Unit Wires
    wire pc_write;
    wire if_id_write;
    wire stall_control;
    wire flush;
    reg ccc_flag_match;
 //Reg File Wires
    wire [3:0] read_reg1;
    wire [3:0] read_reg2;
    wire [3:0] write_reg;
    wire [15:0] write_data;
    wire [15:0] read_data1;
    wire [15:0] read_data2;

 //Global Control Unit Wires
    wire RegWrite;
    wire MemWrite;
    wire MemRead;
    wire ALUSrc;
    wire Reg1Select;
    wire [1:0] WheretoReg;
    wire [3:0] ALUOp;
    wire [1:0] brb;
    wire pcs;
    wire hlt;
    wire flag_z_en;
    wire flag_n_en;
    wire flag_v_en;
    wire branch;

 //Immediate Wires
    wire [8:0] immediate;
    wire [15:0] sign_ext_immediate;

 //Branch decode Wires
    wire [8:0] lshift_immediate;
    wire [15:0] b_addr;
    wire [15:0] br_addr;
    wire [15:0] pc_brb_addr;

/////ID-EX pipeline reg wires/////
    wire hlt_id_ex;
    wire ALUSrc_id_ex;
    wire [3:0] ALUOp_id_ex;
    wire RegWrite_id_ex;
    wire MemRead_id_ex;
    wire MemWrite_id_ex;
    wire flag_z_en_id_ex;
    wire flag_v_en_id_ex;
    wire flag_n_en_id_ex;
    wire [1:0] WheretoReg_id_ex;

    wire [15:0] pc_next_id_ex;
    wire [15:0] read_data1_id_ex;
    wire [15:0] read_data2_id_ex;
    wire [3:0] write_reg_id_ex;
    wire [15:0] sign_ext_immediate_id_ex;
    wire [3:0] read_reg1_id_ex;
    wire [3:0] read_reg2_id_ex;

///EX STAGE NETS////

 ///Forwarding Unit Wires
    wire [1:0] forward_reg1;
    wire [1:0] forward_reg2;
    wire forward_mem_mem;
 //ALU Wires
    wire [15:0] alu_in1;
    wire [15:0] alu_in2;
    wire [15:0] alu_in2_temp; /////////////////decide between this and immediate
    wire [3:0]  opcode;
    wire [15:0] alu_out;
    wire ovfl;

///EX_MEM pipeline register wires///
    wire [15:0] pc_next_ex_mem;
    wire [15:0] alu_out_ex_mem;
    wire ovfl_ex_mem;
    wire [15:0] read_data2_ex_mem;
    wire [3:0]  write_reg_ex_mem;
    wire [3:0] read_reg2_ex_mem;
 
    //control output
    wire hlt_ex_mem;
    wire RegWrite_ex_mem;
    wire MemRead_ex_mem;
    wire MemWrite_ex_mem;
    wire flag_z_en_ex_mem;
    wire flag_v_en_ex_mem;
    wire flag_n_en_ex_mem;
    wire [1:0] WheretoReg_ex_mem;

////MEM STAGE NETS////////
 //DATA MEM Wires
    wire [15:0] data_addr;
    wire [15:0] write_data_mem;
    wire [15:0] read_data_mem;
///MEM_WB pipeline register wire ///
    wire hlt_mem_wb;
    wire RegWrite_mem_wb;
    wire flag_z_en_mem_wb;
    wire flag_v_en_mem_wb;
    wire flag_n_en_mem_wb;
    wire [1:0] WheretoReg_mem_wb;

    //data outputs
    wire [15:0] pc_next_mem_wb;
    wire [15:0] alu_out_mem_wb;
    wire ovfl_mem_wb;
    wire [3:0]  write_reg_mem_wb;
    wire [15:0] read_data_mem_mem_wb;


 


///////////////IF STAGE//////////////////
//checking if fetched instruction is a halt
assign not_hlt = (!(&instruction[15:12]) | flush & ((!stall_control ) | (!i_stall) | (!d_stall)));

////PC Register/////////
assign pc_next_cal = (pcs) ? (pc_brb_addr):pc_next;
dff pc_reg[15:0](
    .clk(clk), 
    .rst(rst), 
    .wen(not_hlt & pc_write & (!i_stall) & (!d_stall)), 
    .d(pc_next_cal), 
    .q(pc_curr)
);

//computation of PC of next instruction
cla_16bit pc_adder1(
	.a(pc_curr),
	.b_in(16'h0002),
	.sum(pc_next),
	.ovfl(),
	.is_sub(1'b0)
	);

//fetching instruction from IM
/*
memory1c_instr instruction_memory (
    .data_out(instruction),
    .addr(pc_curr),
    .data_in(16'hzzzz),
    .wr(1'b0),
    .enable(1'b1),
    .clk(clk),
    .rst(rst)
);*/
/////////////////////////////MEMORY HIERARCHY//////////////////////
//////D_CACHE////I_CACHE//////CACHE_FILL_FSM//////////MAIN_MEMORY//
//////////////////////////////////////////////////////////////////
memory imem(
    .clk(clk),
    .rst(rst),
    .data_in(write_data_mem), // 2 byte data input port
    .wen(MemWrite_ex_mem),
    .i_addr(pc_curr),
    .d_addr(data_addr), //address input port
    .i_read_en(1'b1), 
    .d_read_en(MemRead_ex_mem | MemWrite_ex_mem),
    . d_data_out(read_data_mem),
    . i_data_out(instruction),
    . d_stall(d_stall), 
    . i_stall(i_stall)
);

assign if_id_write = (stall_control == 1'b1 | (i_stall) | (d_stall)) ? 1'b0:1'b1;
//storing the results of IF stage in IF_ID pipeline Register
if_id_pipeline_reg if_id_pipeline_reg (
    //control signals
    .clk(clk),
    .rst(rst | (flush & (~stall_control))),
    .if_id_write(if_id_write),
    //data
    .pc_next(pc_next),
    .instruction(instruction),
    //data outputs
    .pc_next_if_id(pc_next_if_id),
    .instruction_if_id(instruction_if_id)
);

//////////////ID STAGE///////////////

dff z(.clk(clk),.rst(rst),.d(~(|alu_out_mem_wb)),.q(flag[0]),.wen(flag_z_en_mem_wb ));
dff v(.clk(clk),.rst(rst),.d(ovfl_mem_wb),.q(flag[1]),.wen(flag_v_en_mem_wb ));
dff n(.clk(clk),.rst(rst),.d(alu_out_mem_wb[15]),.q(flag[2]),.wen(flag_n_en_mem_wb ));

assign bypass_control_reg1 = (read_reg1 == write_reg_mem_wb) & RegWrite_mem_wb;
assign bypass_control_reg2 = (read_reg2 == write_reg_mem_wb) & RegWrite_mem_wb;

assign read_data1 = (bypass_control_reg1) ? (write_data): (read_data1_rf);
assign read_data2 = (bypass_control_reg2) ? (write_data): (read_data2_rf); 

assign flag_bypass = branch & (flag_n_en_mem_wb | flag_v_en_mem_wb | flag_z_en_mem_wb);
 
assign flag_out[2:0] = (flag_bypass) ? ({alu_out_mem_wb[15],ovfl_mem_wb,~(|alu_out_mem_wb)}) : flag;


hazard_detection_unit hazard_detection_unit(
    .MemRead_id_ex(MemRead_id_ex),
    .read_reg2_id_ex(read_reg2_id_ex),
    .write_reg_id_ex(write_reg_id_ex),
    .read_reg1(read_reg1),
    .read_reg2(read_reg2),
    .brb(brb),
    .branch(branch),
    .ccc(instruction_if_id[11:9]),
    .opcode(instruction_if_id[15:12]),
    .flag_z_en_id_ex(flag_z_en_id_ex),
    .flag_v_en_id_ex(flag_v_en_id_ex),
    .flag_n_en_id_ex(flag_n_en_id_ex),

    .RegWrite_id_ex(RegWrite_id_ex),
    .RegWrite_ex_mem(RegWrite_ex_mem),
    .write_reg_ex_mem(write_reg_ex_mem),

    .flag_z_en_ex_mem(flag_z_en_ex_mem),
    .flag_v_en_ex_mem(flag_v_en_ex_mem),
    .flag_n_en_ex_mem(flag_n_en_ex_mem),

    .pc_write(pc_write),
    .if_id_write(),
    .stall_control(stall_control),
    .flush(flush)

);



Global_Control global_control (
    .opcode_ccc(instruction_if_id[15:9]),
    .f(flag_out),
    .pcs(pcs),
    .RegWrite(RegWrite),
    .MemWrite(MemWrite),
    .MemRead(MemRead),
    .ALUSrc(ALUSrc),
    .Reg1Select(Reg1Select),
    .WheretoReg(WheretoReg),
    .ALUOp(ALUOp),
    .brb(brb),
    .hlt(hlt),
    .flag_z_en(flag_z_en),
    .flag_v_en(flag_v_en),
    .flag_n_en(flag_n_en),
    .branch(branch),
    .dst_write_reg(instruction_if_id[11:8])
);

//register file inputs decode
assign read_reg1 = (Reg1Select)?(instruction_if_id[11:8]):instruction_if_id[7:4];
assign read_reg2 = (MemWrite)?(instruction_if_id[11:8]):instruction_if_id[3:0];
assign write_reg = instruction_if_id[11:8];

registerfile registerfile ( 
    .clk(clk),
    .rst(rst),
    .src_reg1(read_reg1),
    .src_reg2(read_reg2),
    .src_data1(read_data1_rf),
    .src_data2(read_data2_rf),
    .dst_reg(write_reg_mem_wb),
    .dst_data(write_data),
    .write_reg(RegWrite_mem_wb) 
);

//immediate
assign immediate = instruction_if_id[8:0];
assign sign_ext_immediate = {{7{immediate[8]}},immediate[8:0]};

//branch decode

//b addr computation
assign lshift_immediate = immediate << 1;
cla_16bit b_adder(
	.a(pc_next_if_id),
	.b_in({{7{immediate[8]}},lshift_immediate}),
	.sum(b_addr),
	.ovfl(),
	.is_sub(1'b0)
	);

assign br_addr = read_data1;

//PC addr decode logic
assign pc_brb_addr = (brb == 2'b00)?pc_next_if_id:
                     (brb == 2'b01)?b_addr:
                     (brb == 2'b10)?br_addr:
                     pc_next_if_id;

id_ex_pipeline_reg id_ex_pipeline_reg (
    //data
    .clk(clk),
    .rst(rst),
    .wen(~d_stall),
    .rst_control(stall_control | i_stall),
    .pc_next_if_id(pc_next_if_id),
    .read_data1(read_data1),
    .read_data2(read_data2),
    .write_reg(write_reg),
    .sign_ext_immediate(sign_ext_immediate),
    .read_reg1(read_reg1),
    .read_reg2(read_reg2),

    //control signals
    .hlt(hlt),
    .ALUSrc(ALUSrc),
    .ALUOp(ALUOp),
    .RegWrite(RegWrite),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .flag_z_en(flag_z_en),
    .flag_v_en(flag_v_en),
    .flag_n_en(flag_n_en),
    .WheretoReg(WheretoReg),

    //control outputs
    .hlt_id_ex(hlt_id_ex),
    .ALUSrc_id_ex(ALUSrc_id_ex),
    .ALUOp_id_ex(ALUOp_id_ex),
    .RegWrite_id_ex(RegWrite_id_ex),
    .MemRead_id_ex(MemRead_id_ex),
    .MemWrite_id_ex(MemWrite_id_ex),
    .flag_z_en_id_ex(flag_z_en_id_ex),
    .flag_v_en_id_ex(flag_v_en_id_ex),
    .flag_n_en_id_ex(flag_n_en_id_ex),
    .WheretoReg_id_ex(WheretoReg_id_ex),

    //data outputs
     .pc_next_id_ex(pc_next_id_ex),
     .read_data1_id_ex(read_data1_id_ex),
     .read_data2_id_ex(read_data2_id_ex),
     .write_reg_id_ex(write_reg_id_ex),
     .sign_ext_immediate_id_ex(sign_ext_immediate_id_ex),
     .read_reg1_id_ex(read_reg1_id_ex),
     .read_reg2_id_ex(read_reg2_id_ex)

);

//////////////////////EX STAGE////////////////////////////
//////////////////Forwarding Unit/////////
forwarding_unit forwarding_unit(
    .read_reg1_id_ex(read_reg1_id_ex),
    .read_reg2_id_ex(read_reg2_id_ex),
    .write_reg_ex_mem(write_reg_ex_mem),
    .write_reg_mem_wb(write_reg_mem_wb),
    .read_reg2_ex_mem(read_reg2_ex_mem), 
    .RegWrite_ex_mem(RegWrite_ex_mem),
    .RegWrite_mem_wb(RegWrite_mem_wb),
    .forward_reg1(forward_reg1),
    .forward_reg2(forward_reg2), 
    .forward_mem_mem(forward_mem_mem)
);


assign opcode = ALUOp_id_ex;
assign alu_in1 = (forward_reg1 == 2'b10) ? (alu_out_ex_mem):
                 (forward_reg1 == 2'b01) ? (write_data):
                  read_data1_id_ex;

assign alu_in2_temp = (forward_reg2 == 2'b10) ? (alu_out_ex_mem):
                      (forward_reg2 == 2'b01) ? (write_data):
                      read_data2_id_ex;

/*wire [15:0] read_data2_id_ex_frwd;
assign read_data2_id_ex_frwd = ((forward_reg2 == 2'b01)) ? write_data : read_data2_id_ex;*/

assign alu_in2 = (ALUSrc_id_ex)?(sign_ext_immediate_id_ex):(alu_in2_temp);
alu_16bit alu(
    .alu_in1(alu_in1),
    .alu_in2(alu_in2),
    .opcode(opcode),
    .alu_out(alu_out),
    .ovfl(ovfl)
 );

ex_mem_pipeline_reg ex_mem_pipeline_reg(
    .pc_next_id_ex(pc_next_id_ex),
    .alu_out(alu_out),
    .ovfl(ovfl),
    .read_data2_id_ex(alu_in2_temp),
    .write_reg_id_ex(write_reg_id_ex),
    //control input
    .clk(clk),
    .rst(rst),
    .wen(~d_stall),
    .hlt_id_ex(hlt_id_ex),
    .RegWrite_id_ex(RegWrite_id_ex),
    .MemRead_id_ex(MemRead_id_ex),
    .MemWrite_id_ex(MemWrite_id_ex),
    .flag_z_en_id_ex(flag_z_en_id_ex),
    .flag_v_en_id_ex(flag_v_en_id_ex),
    .flag_n_en_id_ex(flag_n_en_id_ex),
    .WheretoReg_id_ex(WheretoReg_id_ex),
    .read_reg2_id_ex(read_reg2_id_ex),

    //data output
    .pc_next_ex_mem(pc_next_ex_mem),
    .alu_out_ex_mem(alu_out_ex_mem),
    .ovfl_ex_mem(ovfl_ex_mem),
    .read_data2_ex_mem(read_data2_ex_mem),
    .write_reg_ex_mem(write_reg_ex_mem),
    .read_reg2_ex_mem(read_reg2_ex_mem),

    //control output
    .hlt_ex_mem(hlt_ex_mem),
    .RegWrite_ex_mem(RegWrite_ex_mem),
    .MemRead_ex_mem(MemRead_ex_mem),
    .MemWrite_ex_mem(MemWrite_ex_mem),
    .flag_z_en_ex_mem(flag_z_en_ex_mem),
    .flag_v_en_ex_mem(flag_v_en_ex_mem),
    .flag_n_en_ex_mem(flag_n_en_ex_mem),
    .WheretoReg_ex_mem(WheretoReg_ex_mem)
);

//////////////////MEM STAGE////////////////////////
  assign data_addr = alu_out_ex_mem;
  assign write_data_mem = (forward_mem_mem) ? (write_data) : read_data2_ex_mem;

 /* memory1c_data data_memory (
        .data_out(read_data_mem),
        .addr(data_addr),
        .data_in(write_data_mem),
        .wr(MemWrite_ex_mem),
        .enable(MemRead_ex_mem | MemWrite_ex_mem),
        .clk(clk),
        .rst(rst)
    );*/
mem_wb_pipeline_reg mem_wb_pipeline_reg (
    //control inputs
     .clk(clk),
     .rst(rst),
     .wen(~d_stall),
     .hlt_ex_mem(hlt_ex_mem),
     .RegWrite_ex_mem(RegWrite_ex_mem),
     .flag_z_en_ex_mem(flag_z_en_ex_mem),
     .flag_v_en_ex_mem(flag_v_en_ex_mem),
     .flag_n_en_ex_mem(flag_n_en_ex_mem),
     .WheretoReg_ex_mem(WheretoReg_ex_mem),

    //data inputs
    .pc_next_ex_mem(pc_next_ex_mem),
    .alu_out_ex_mem(alu_out_ex_mem),
    .ovfl_ex_mem(ovfl_ex_mem),
    .write_reg_ex_mem(write_reg_ex_mem),
    .read_data_mem(read_data_mem),

    //control outputs
     .hlt_mem_wb(hlt_mem_wb),
     .RegWrite_mem_wb(RegWrite_mem_wb),
     .flag_z_en_mem_wb(flag_z_en_mem_wb),
     .flag_v_en_mem_wb(flag_v_en_mem_wb),
     .flag_n_en_mem_wb(flag_n_en_mem_wb),
     .WheretoReg_mem_wb(WheretoReg_mem_wb),

    //data outputs
     .pc_next_mem_wb(pc_next_mem_wb),
     .alu_out_mem_wb(alu_out_mem_wb),
     .ovfl_mem_wb(ovfl_mem_wb),
     .write_reg_mem_wb(write_reg_mem_wb),
     .read_data_mem_mem_wb(read_data_mem_mem_wb)
);
////////////////WB STAGE////////////////////////
assign write_data = (WheretoReg_mem_wb == 2'b00)? pc_next_mem_wb:
                    (WheretoReg_mem_wb == 2'b01)? read_data_mem_mem_wb:
                    (WheretoReg_mem_wb == 2'b10)? alu_out_mem_wb:
                    alu_out_mem_wb;

assign hlt_sig = hlt_mem_wb;
assign pc = pc_curr;

endmodule