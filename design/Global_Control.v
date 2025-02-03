module Global_Control(
	input [6:0] opcode_ccc,	//Instruction [15:9] (opcode + ccc)
	input [2:0] f,	// flags (F = {N, V, Z})
	input [3:0] dst_write_reg, ///// write register inputted to check if its zero
    output reg RegWrite, //Write enable to register rd
	output reg MemWrite, //Write enable to memory
	output reg MemRead,  //Read enable to memory
	output reg ALUSrc, //Select between Read Register 2 data and immediate
	output reg Reg1Select, //Select between rd and rs for Read Register 1
	output reg [1:0] WheretoReg,	//to select register data source  
	output reg [3:0] ALUOp, //Select line for ALU operation
    //output reg b, //for Branch instruction (replsaced with brb)
    //output reg br, //for Branch Register instruction (replace with brb)
	output reg pcs,	//for PCS instruction (IT WAS NEVER USED IN STAGE 1)
    output reg hlt, //halt signal
    output reg not_hlt,	//for HLT instruction
    output reg flag_z_en,
    output reg flag_v_en,
    output reg flag_n_en,
    output reg branch,
    output reg [1:0] brb
);
     
	/* RegWrite = 0, for SW, B, BR, HLT
			   1, otherwise
			   
	MemWrite = 1, for SW
			   0, otherwise
				
	MemRead = 1, for LW
			  0, otherwise
			  
	WheretoReg = 00, for PCS
				 01, for LW
				 10, otherwise
				 
	ALUSrc = 1, for LW, SW, SLL, SRA, ROR, LLB, LHB
	         0, otherwise
			 
	ALUOp = opcode
	
	Reg1Select = 1, for LLB, LHB; Reg 1 = rd [11:8]
				 0, otherwise; Reg 2 = rs [7:4] 
				 
	b = 1, for B and if condition matches
		0, otherwise 
		
	br = 1, for BR and if condition matches
		 0, otherwise
		 
	//pcs = 1, for PCS
		  0, otherwise
		  
	hlt = 1, for HLT
		  0, otherwsie */
	
	// Flags
	wire N = f[2]; // Sign Bit flag
	wire V = f[1]; // Overflow flag
	wire Z = f[0]; // Zero flag
    wire not_dest_reg_0 = (|dst_write_reg);    ////////when dst reg is 0 this should be 1
	
	reg cond_match; // wire to check if opcode and flag condition matches

	// Define different instructions using localparam
    localparam ADD = 4'b0000;
    localparam SUB = 4'b0001;
    localparam XOR = 4'b0010;
    localparam RED = 4'b0011;
    localparam SLL = 4'b0100;
    localparam SRA = 4'b0101;
    localparam ROR = 4'b0110;
    localparam PADDSB = 4'b0111;
	localparam LW = 4'b1000;
    localparam SW = 4'b1001;
    localparam LLB = 4'b1010;
    localparam LHB = 4'b1011;
    localparam B = 4'b1100;
    localparam BR = 4'b1101;
    localparam PCS = 4'b1110;
    localparam HLT = 4'b1111;
	
	//checking condition for B and BR instructions
	always @(*) begin
		case (opcode_ccc[2:0])
			3'b000: cond_match = ~Z; // Not Equal (Z = 0)
			3'b001: cond_match = Z;	// Equal (Z = 1)
			3'b010: cond_match = ~Z & ~N; // Greater Than (Z = N = 0)
			3'b011: cond_match = N; // Less Than (N = 1)
			3'b100: cond_match = Z | (~Z & ~N); // Greater Than or Equal (Z = 1 or Z = N = 0)
			3'b101: cond_match = N | Z; // Less Than or Equal (N = 1 or Z = 1)
			3'b110: cond_match = V; // Overflow (V = 1)
			3'b111: cond_match = 1'b1; // Unconditional	
		endcase
	end	
	
	//Setting control signals for each instruction
	always @(*) begin
        RegWrite = 1'b0;
        MemWrite = 1'b0;
        MemRead = 1'b0;
        ALUSrc = 1'b0;
        Reg1Select = 1'b0;
        WheretoReg = 2'b00;
        ALUOp = 4'b0000;
        brb = 2'b00;
        // b = 1'b0;
        // br = 1'b0;
        pcs = 1'b0;
        hlt = 1'b0;
        not_hlt = 1'b1;
        flag_z_en = 0;
        flag_n_en = 0;
        flag_v_en = 0;
        branch = 0;
		case (opcode_ccc[6:3])
			ADD: begin
                RegWrite = 1'b1;
                MemWrite = 1'b0;
                MemRead = 1'b0;
                ALUSrc = 1'b0;
                Reg1Select = 1'b0;
                WheretoReg = 2'b10;
                ALUOp = ADD;
				// b = 1'b0;
				// br = 1'b0;
				pcs = 0;
                brb = 2'b00;
				hlt = 1'b0;
                not_hlt = 1'b1;
                flag_z_en = 1; //& not_dest_reg_0;
                flag_n_en = 1; //& not_dest_reg_0;
                flag_v_en = 1; //& not_dest_reg_0;
                branch = 0;
            end
            SUB: begin
                RegWrite = 1'b1;
                MemWrite = 1'b0;
                MemRead = 1'b0;
                ALUSrc = 1'b0;
                Reg1Select = 1'b0;
                WheretoReg = 2'b10;
                ALUOp = SUB;
				// b = 1'b0;
				// br = 1'b0;
				pcs = 0;
                brb = 2'b00;
				hlt = 1'b0;
                not_hlt = 1'b1;
                flag_z_en = 1; //& not_dest_reg_0;
                flag_n_en = 1; //& not_dest_reg_0;
                flag_v_en = 1; //& not_dest_reg_0;
                branch = 0;
            end
            XOR: begin
                RegWrite = 1'b1;
                MemWrite = 1'b0;
                MemRead = 1'b0;
                ALUSrc = 1'b0;
                Reg1Select = 1'b0;
                WheretoReg = 2'b10;
                ALUOp = XOR;
				// b = 1'b0;
				// br = 1'b0;
				pcs = 0;
                brb = 2'b00;
				hlt = 1'b0;
                not_hlt = 1'b1;
                flag_z_en = 1 & not_dest_reg_0;
                flag_n_en = 0;
                flag_v_en = 0;
                branch = 0;
            end
            RED: begin
                RegWrite = 1'b1;
                MemWrite = 1'b0;
                MemRead = 1'b0;
                ALUSrc = 1'b0;
                Reg1Select = 1'b0;
                WheretoReg = 2'b10;
                ALUOp = RED;
                brb = 2'b00;
				// b = 1'b0;
				// br = 1'b0;
				pcs = 1'b0;
				hlt = 1'b0;
                not_hlt = 1'b1;
                flag_z_en = 0;
                flag_n_en = 0;
                flag_v_en = 0;
                branch = 0;
            end
            SLL: begin
                RegWrite = 1'b1;
                MemWrite = 1'b0;
                MemRead = 1'b0;
                ALUSrc = 1'b1;
                Reg1Select = 1'b0;
                WheretoReg = 2'b10;
                ALUOp = SLL;
                brb = 2'b00;
				// b = 1'b0;
				// br = 1'b0;
				pcs = 1'b0;
				hlt = 1'b0;
                not_hlt = 1'b1;
                flag_z_en = 1; //& not_dest_reg_0;
                flag_n_en = 0;
                flag_v_en = 0;
                branch = 0;
            end
            SRA: begin
                RegWrite = 1'b1;
                MemWrite = 1'b0;
                MemRead = 1'b0;
                ALUSrc = 1'b1;
                Reg1Select = 1'b0;
                WheretoReg = 2'b10;
                ALUOp = SRA;
                brb = 2'b00;
				// b = 1'b0;
				// br = 1'b0;
				pcs = 1'b0;
				hlt = 1'b0;
                not_hlt = 1'b1;
                flag_z_en = 1; //& not_dest_reg_0;
                flag_n_en = 0;
                flag_v_en = 0;
                branch = 0;
            end
            ROR: begin
                RegWrite = 1'b1;
                MemWrite = 1'b0;
                MemRead = 1'b0;
                ALUSrc = 1'b1;
                Reg1Select = 1'b0;
                WheretoReg = 2'b10;
                ALUOp = ROR;
                brb = 2'b00;
				// b = 1'b0;
				// br = 1'b0;
				pcs = 1'b0;
				hlt = 1'b0;
                not_hlt = 1'b1;
                flag_z_en = 1; //& not_dest_reg_0;
                flag_n_en = 0;
                flag_v_en = 0;
                branch = 0;
            end
            PADDSB: begin
                RegWrite = 1'b1;
                MemWrite = 1'b0;
                MemRead = 1'b0;
                ALUSrc = 1'b0;
                Reg1Select = 1'b0;
                WheretoReg = 2'b10;
                ALUOp = PADDSB;
                brb = 2'b00;
				// b = 1'b0;
				// br = 1'b0;
				pcs = 1'b0;
				hlt = 1'b0;
                not_hlt = 1'b1;
                flag_z_en = 0;
                flag_n_en = 0;
                flag_v_en = 0;
                branch = 0;
            end
            LW: begin
                RegWrite = 1'b1;
                MemWrite = 1'b0;
                MemRead = 1'b1;
                ALUSrc = 1'b1;
                Reg1Select = 1'b0;
                WheretoReg = 2'b01;
                ALUOp = LW;
                brb = 2'b00;
				// b = 1'b0;
				// br = 1'b0;
				pcs = 1'b0;
				hlt = 1'b0;
                not_hlt = 1'b1;
                flag_z_en = 0;
                flag_n_en = 0;
                flag_v_en = 0;
                branch = 0;
            end
            SW: begin
                RegWrite = 1'b0;
                MemWrite = 1'b1;
                MemRead = 1'b0;
                ALUSrc = 1'b1;
                Reg1Select = 1'b0;
                WheretoReg = 2'b10;
                ALUOp = SW;
                brb = 2'b00;
				// b = 1'b0;
				// br = 1'b0;
				pcs = 1'b0;
				hlt = 1'b0;
                not_hlt = 1'b1;
                flag_z_en = 0;
                flag_n_en = 0;
                flag_v_en = 0;
                branch = 0;
            end
            LLB: begin
                RegWrite = 1'b1;
                MemWrite = 1'b0;
                MemRead = 1'b0;
                ALUSrc = 1'b1;
                Reg1Select = 1'b1;
                WheretoReg = 2'b10;
                ALUOp = LLB;
                brb = 2'b00;
				// b = 1'b0;
				// br = 1'b0;
				pcs = 1'b0;
				hlt = 1'b0;
                not_hlt = 1'b1;
                flag_z_en = 0;
                flag_n_en = 0;
                flag_v_en = 0;
                branch = 0;
            end
            LHB: begin
                RegWrite = 1'b1;
                MemWrite = 1'b0;
                MemRead = 1'b0;
                ALUSrc = 1'b1;
                Reg1Select = 1'b1;
                WheretoReg = 2'b10;
                ALUOp = LHB;
                brb = 2'b00;
				// b = 1'b0;
				// br = 1'b0;
				pcs = 1'b0;
				hlt = 1'b0;
                not_hlt = 1'b1;
                flag_z_en = 0;
                flag_n_en = 0;
                flag_v_en = 0;
                branch = 0;
            end
            B: begin
                RegWrite = 1'b0;
                MemWrite = 1'b0;
                MemRead = 1'b0;
                ALUSrc = 1'b0;
                Reg1Select = 1'b0;
                WheretoReg = 2'b10;
                ALUOp = B;
                brb = (cond_match)?2'b01:2'b00;
				//b = (cond_match) ? 1'b1 : 1'b0;
				//br = 1'b0;
				pcs = (cond_match) ? 1'b1: 1'b0;
				hlt = 1'b0;
                not_hlt = 1'b1;
                flag_z_en = 0;
                flag_n_en = 0;
                flag_v_en = 0;
                branch = 1;
            end
            BR: begin
                RegWrite = 1'b0;
                MemWrite = 1'b0;
                MemRead = 1'b0;
                ALUSrc = 1'b0;
                Reg1Select = 1'b0;
                WheretoReg = 2'b10;
                ALUOp = BR;
                brb = (cond_match)?2'b10:2'b00;
				//b = 1'b0;
				//br = (cond_match) ? 1'b1 : 1'b0;
				pcs = (cond_match)?1'b1:1'b0;
				hlt = 1'b0;
                not_hlt = 1'b1;
                flag_z_en = 0;
                flag_n_en = 0;
                flag_v_en = 0;
                branch = 1;
            end
            PCS: begin
                RegWrite = 1'b1;
                MemWrite = 1'b0;
                MemRead = 1'b0;
                ALUSrc = 1'b0;
                Reg1Select = 1'b0;
                WheretoReg = 2'b00;
                ALUOp = PCS;
                brb = 2'b00;
				// b = 1'b0;
				// br = 1'b0;
				pcs = 1'b0;
				hlt = 1'b0;
                not_hlt = 1'b1;
                flag_z_en = 0;
                flag_n_en = 0;
                flag_v_en = 0;
                branch = 0;
            end
            HLT: begin
                RegWrite = 1'b0;
                MemWrite = 1'b0;
                MemRead = 1'b0;
                ALUSrc = 1'b0;
                Reg1Select = 1'b0;
                WheretoReg = 2'b10;
                ALUOp = HLT;
                brb = 2'b00;
				// b = 1'b0;
				// br = 1'b0;
				pcs = 1'b0;
				hlt = 1'b1;
                not_hlt = 1'b0;
                flag_z_en = 0;
                flag_n_en = 0;
                flag_v_en = 0;
                branch = 0;
            end
			default: begin
				RegWrite = 1'b0;
				MemWrite = 1'b0;
				MemRead = 1'b0;
				ALUSrc = 1'b0;
				Reg1Select = 1'b0;
				WheretoReg = 2'b00;
				ALUOp = 4'b0000;
                brb = 2'b00;
				// b = 1'b0;
				// br = 1'b0;
				pcs = 1'b0;
				hlt = 1'b0;
                not_hlt = 1'b1;
                flag_z_en = 0;
                flag_n_en = 0;
                flag_v_en = 0;
                branch = 0;
			end
		endcase
	end
endmodule