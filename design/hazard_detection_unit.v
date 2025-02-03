
module hazard_detection_unit (
    input MemRead_id_ex,
    input [3:0] read_reg2_id_ex,
    input [3:0] write_reg_id_ex,
    input [3:0] read_reg1,
    input [3:0]read_reg2,
    input branch,
    input [1:0] brb,                    ///inputted for implementing flush logic
    input [3:0] opcode,
    input [2:0] ccc,

    input RegWrite_id_ex,              ///////inputted for br using same register that is being written
    input RegWrite_ex_mem,
    input [3:0] write_reg_ex_mem,

    input flag_z_en_id_ex,
    input flag_v_en_id_ex,
    input flag_n_en_id_ex,

    input flag_z_en_ex_mem,
    input flag_v_en_ex_mem,
    input flag_n_en_ex_mem,

    output pc_write,
    output if_id_write,
    output stall_control,
    output flush
);

wire br_reg_stall;
wire load_stall;
wire branch_stall;
reg ccc_flag_match;

//////////load to use stall
assign load_stall = (MemRead_id_ex & (|write_reg_id_ex) & 
                    ((write_reg_id_ex == read_reg1) | (write_reg_id_ex == read_reg2) &
                    opcode != 4'b1001));

////branches waiting for flags to be written
always @(*) begin
    case(ccc)
        000: begin
        ccc_flag_match = flag_z_en_id_ex | flag_z_en_ex_mem;
        end
        001: begin
        ccc_flag_match = flag_z_en_id_ex | flag_z_en_ex_mem;
        end
        010: begin
        ccc_flag_match = flag_z_en_id_ex | flag_z_en_ex_mem | flag_n_en_id_ex | flag_n_en_ex_mem;
        end
        011: begin
        ccc_flag_match = flag_n_en_id_ex | flag_n_en_ex_mem;
        end
        100: begin
        ccc_flag_match = flag_z_en_id_ex | flag_z_en_ex_mem | flag_n_en_id_ex | flag_n_en_ex_mem;
        end
        101: begin
        ccc_flag_match = flag_z_en_id_ex | flag_z_en_ex_mem | flag_n_en_id_ex | flag_n_en_ex_mem;
        end
        110: begin
        ccc_flag_match = flag_v_en_id_ex | flag_v_en_ex_mem;
        end
        111: begin
        ccc_flag_match = 1'b0;
        end
        
    endcase
end

/////BR waiting for register
assign br_reg_stall =  (((RegWrite_id_ex  & (|write_reg_id_ex)) | (RegWrite_ex_mem & (|write_reg_ex_mem))) &
                       (opcode == 4'b1101) &
                       ((write_reg_id_ex == read_reg1) | (write_reg_ex_mem == read_reg1))); 


assign branch_stall = ccc_flag_match & branch;

assign stall_control = branch_stall | load_stall | br_reg_stall;

assign if_id_write = ~stall_control;

assign pc_write = ~stall_control;

assign flush = (brb == 2'b01) | (brb == 2'b10);
    
endmodule