module forwarding_unit (

    input [3:0] read_reg1_id_ex,
    input [3:0] read_reg2_id_ex,
    input [3:0] write_reg_ex_mem,
    input [3:0] write_reg_mem_wb,
    input [3:0] read_reg2_ex_mem,
    input RegWrite_ex_mem,
    input RegWrite_mem_wb,

    output [1:0] forward_reg1,
    output [1:0] forward_reg2,
    output forward_mem_mem
);


assign forward_reg1 = (RegWrite_ex_mem & (|write_reg_ex_mem) & (write_reg_ex_mem == read_reg1_id_ex))? 2'b10:
                       ////EX-EX forwarding for Reg1
                      (RegWrite_mem_wb & (|write_reg_mem_wb) & (write_reg_mem_wb == read_reg1_id_ex))? 2'b01:
                       ////MEM-EX forwarding for Reg1
                      2'b00;

assign forward_reg2 = (RegWrite_ex_mem & (|write_reg_ex_mem) & (write_reg_ex_mem == read_reg2_id_ex))? 2'b10:
                      ////EX-EX forwarding for Reg2
                      (RegWrite_mem_wb & (|write_reg_mem_wb) & (write_reg_mem_wb == read_reg2_id_ex))? 2'b01:
                      ////MEM-EX forwarding for Reg2
                      2'b00;

                      ////MEM-MEM Forwarding
assign forward_mem_mem = (RegWrite_mem_wb & (|write_reg_mem_wb) & (write_reg_mem_wb == read_reg2_ex_mem))? 1'b1:1'b0;

    
endmodule