`include "pldff.v"
module ex_mem_pipeline_reg (
    //data input
    input [15:0] pc_next_id_ex,
    input [15:0] alu_out,
    input ovfl,
    input [3:0]  write_reg_id_ex,
    input [15:0] read_data2_id_ex,
    input [3:0] read_reg2_id_ex,

    //control input
    input clk,
    input rst,
    input wen,
    input hlt_id_ex,
    input RegWrite_id_ex,
    input MemRead_id_ex,
    input MemWrite_id_ex,
    input flag_z_en_id_ex,
    input flag_v_en_id_ex,
    input flag_n_en_id_ex,
    input [1:0] WheretoReg_id_ex,

    //data output
    output [15:0] pc_next_ex_mem,
    output [15:0] alu_out_ex_mem,
    output ovfl_ex_mem,
    output [15:0] read_data2_ex_mem,
    output [3:0]  write_reg_ex_mem,
    output [3:0] read_reg2_ex_mem,

    //control output
    output hlt_ex_mem,
    output RegWrite_ex_mem,
    output MemRead_ex_mem,
    output MemWrite_ex_mem,
    output flag_z_en_ex_mem,
    output flag_v_en_ex_mem,
    output flag_n_en_ex_mem,
    output [1:0] WheretoReg_ex_mem

);
pldff #(.WIDTH(9)) ex_mem_control_pldff(
    .d({hlt_id_ex,
        RegWrite_id_ex,
        MemRead_id_ex,
        MemWrite_id_ex,
        flag_v_en_id_ex,
        flag_z_en_id_ex,
        flag_n_en_id_ex,
        WheretoReg_id_ex}),
    .q({hlt_ex_mem,
        RegWrite_ex_mem,
        MemRead_ex_mem,
        MemWrite_ex_mem,
        flag_v_en_ex_mem,
        flag_z_en_ex_mem,
        flag_n_en_ex_mem,
        WheretoReg_ex_mem}),
    .rst(rst),
    .clk(clk),
    .wen(wen)
);

pldff #(.WIDTH(57)) ex_mem_data_pldff(
    .d({ pc_next_id_ex,
         alu_out,
         ovfl,
         read_data2_id_ex,
         read_reg2_id_ex,
         write_reg_id_ex}),
    .q({pc_next_ex_mem,
        alu_out_ex_mem,
        ovfl_ex_mem,
        read_data2_ex_mem,
        read_reg2_ex_mem,
        write_reg_ex_mem}),
    .rst(rst),
    .clk(clk),
    .wen(wen)
);


    
endmodule