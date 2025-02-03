module Global_Control_tb();

	reg [6:0] opcode_ccc;
	reg [2:0] f;
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
	
    Global_Control uut (
        .opcode_ccc(opcode_ccc),
		.f(f),
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
		.hlt(hlt)
    );
	
	initial begin 
        
        opcode_ccc[6:3] = ADD; 
		#10;		
		$display("ADD: opcode = %b, RegWrite = %b, MemWrite = %b, MemRead = %b, ALUSrc = %b, Reg1Select = %b, WheretoReg = %b, ALUOp = %b, b = %b, br = %b, pcs = %b, hlt = %b",
                  opcode_ccc[6:3], RegWrite, MemWrite, MemRead, ALUSrc, Reg1Select, WheretoReg, ALUOp, b, br, pcs, hlt);
        #10;

        opcode_ccc[6:3] = SUB;
		#10;
		$display("SUB: opcode = %b, RegWrite = %b, MemWrite = %b, MemRead = %b, ALUSrc = %b, Reg1Select = %b, WheretoReg = %b, ALUOp = %b, b = %b, br = %b, pcs = %b, hlt = %b",
                  opcode_ccc[6:3], RegWrite, MemWrite, MemRead, ALUSrc, Reg1Select, WheretoReg, ALUOp, b, br, pcs, hlt);
        #10;

        opcode_ccc[6:3] = XOR;
		#10;
		$display("XOR: opcode = %b, RegWrite = %b, MemWrite = %b, MemRead = %b, ALUSrc = %b, Reg1Select = %b, WheretoReg = %b, ALUOp = %b, b = %b, br = %b, pcs = %b, hlt = %b",
                  opcode_ccc[6:3], RegWrite, MemWrite, MemRead, ALUSrc, Reg1Select, WheretoReg, ALUOp, b, br, pcs, hlt);
        #10;

        opcode_ccc[6:3] = RED;
		#10;
		$display("RED: opcode = %b, RegWrite = %b, MemWrite = %b, MemRead = %b, ALUSrc = %b, Reg1Select = %b, WheretoReg = %b, ALUOp = %b, b = %b, br = %b, pcs = %b, hlt = %b", 
				  opcode_ccc[6:3], RegWrite, MemWrite, MemRead, ALUSrc, Reg1Select, WheretoReg, ALUOp, b, br, pcs, hlt);
        #10;

        opcode_ccc[6:3] = SLL;
		#10;
		$display("SLL: opcode = %b, RegWrite = %b, MemWrite = %b, MemRead = %b, ALUSrc = %b, Reg1Select = %b, WheretoReg = %b, ALUOp = %b, b = %b, br = %b, pcs = %b, hlt = %b",
                  opcode_ccc[6:3], RegWrite, MemWrite, MemRead, ALUSrc, Reg1Select, WheretoReg, ALUOp, b, br, pcs, hlt);
        #10;

        opcode_ccc[6:3] = SRA;
		#10;
		$display("SRA: opcode = %b, RegWrite = %b, MemWrite = %b, MemRead = %b, ALUSrc = %b, Reg1Select = %b, WheretoReg = %b, ALUOp = %b, b = %b, br = %b, pcs = %b, hlt = %b",
                  opcode_ccc[6:3], RegWrite, MemWrite, MemRead, ALUSrc, Reg1Select, WheretoReg, ALUOp, b, br, pcs, hlt);
        #10;

        opcode_ccc[6:3] = ROR;
		#10;
		$display("ROR: opcode = %b, RegWrite = %b, MemWrite = %b, MemRead = %b, ALUSrc = %b, Reg1Select = %b, WheretoReg = %b, ALUOp = %b, b = %b, br = %b, pcs = %b, hlt = %b",
                  opcode_ccc[6:3], RegWrite, MemWrite, MemRead, ALUSrc, Reg1Select, WheretoReg, ALUOp, b, br, pcs, hlt);
        #10;

        opcode_ccc[6:3] = PADDSB;
		#10;
		$display("PADDSB: opcode = %b, RegWrite = %b, MemWrite = %b, MemRead = %b, ALUSrc = %b, Reg1Select = %b, WheretoReg = %b, ALUOp = %b, b = %b, br = %b, pcs = %b, hlt = %b",
                  opcode_ccc[6:3], RegWrite, MemWrite, MemRead, ALUSrc, Reg1Select, WheretoReg, ALUOp, b, br, pcs, hlt);
        #10;

        opcode_ccc[6:3] = LW;
		#10;
		$display("LW: opcode = %b, RegWrite = %b, MemWrite = %b, MemRead = %b, ALUSrc = %b, Reg1Select = %b, WheretoReg = %b, ALUOp = %b, b = %b, br = %b, pcs = %b, hlt = %b",
                  opcode_ccc[6:3], RegWrite, MemWrite, MemRead, ALUSrc, Reg1Select, WheretoReg, ALUOp, b, br, pcs, hlt);
        #10;

        opcode_ccc[6:3] = SW;
		#10;
		$display("SW: opcode = %b, RegWrite = %b, MemWrite = %b, MemRead = %b, ALUSrc = %b, Reg1Select = %b, WheretoReg = %b, ALUOp = %b, b = %b, br = %b, pcs = %b, hlt = %b",
                  opcode_ccc[6:3], RegWrite, MemWrite, MemRead, ALUSrc, Reg1Select, WheretoReg, ALUOp, b, br, pcs, hlt);
        #10;

        opcode_ccc[6:3] = LLB;
		#10;
		$display("LLB: opcode = %b, RegWrite = %b, MemWrite = %b, MemRead = %b, ALUSrc = %b, Reg1Select = %b, WheretoReg = %b, ALUOp = %b, b = %b, br = %b, pcs = %b, hlt = %b",
                  opcode_ccc[6:3], RegWrite, MemWrite, MemRead, ALUSrc, Reg1Select, WheretoReg, ALUOp, b, br, pcs, hlt);
        #10;

        opcode_ccc[6:3] = LHB;
		#10;
		$display("LHB: opcode = %b, RegWrite = %b, MemWrite = %b, MemRead = %b, ALUSrc = %b, Reg1Select = %b, WheretoReg = %b, ALUOp = %b, b = %b, br = %b, pcs = %b, hlt = %b",
                  opcode_ccc[6:3], RegWrite, MemWrite, MemRead, ALUSrc, Reg1Select, WheretoReg, ALUOp, b, br, pcs, hlt);
        #10;

        opcode_ccc[6:3] = B;
		#10;
		$display("B: opcode = %b, RegWrite = %b, MemWrite = %b, MemRead = %b, ALUSrc = %b, Reg1Select = %b, WheretoReg = %b, ALUOp = %b, br = %b, pcs = %b, hlt = %b",
                  opcode_ccc[6:3], RegWrite, MemWrite, MemRead, ALUSrc, Reg1Select, WheretoReg, ALUOp, br, pcs, hlt);
        #10;
		
		opcode_ccc[2:0] = 3'b000;	// Not Equal condition
		f = 3'b000; // Flags: {N, V, Z} = {0, 0, 0}
		#10;
		$display("B: ccc = %b (Not Equal (Z = 0)), f = %b, b = %b",
                  opcode_ccc[2:0], f, b);
        #10;
		
		opcode_ccc[2:0] = 3'b001; // Equal condition
		f = 3'b001; // Flags: {N, V, Z} = {0, 0, 1}
		#10;
		$display("B: ccc = %b (Equal (Z = 1)), f = %b, b = %b",
                  opcode_ccc[2:0], f, b);
        #10;
		
		opcode_ccc[2:0] = 3'b010; // Greater Than condition
		f = 3'b000; // Flags: {N, V, Z} = {0, 0, 0}
		#10;
		$display("B: ccc = %b (Greater Than (Z = N = 0)), f = %b, b = %b",
                  opcode_ccc[2:0], f, b);
        #10;
		
		opcode_ccc[2:0] = 3'b011; // Less Than condition
		f = 3'b100; // Flags: {N, V, Z} = {1, 0, 0}
		#10;
		$display("B: ccc = %b (Less Than (N = 1)), f = %b, b = %b",
                  opcode_ccc[2:0], f, b);
        #10;
		
		opcode_ccc[2:0] = 3'b100; // Greater Than or Equal condition
		f = 3'b010; // Flags: {N, V, Z} = {0, 1, 0}
		#10;
		$display("B: ccc = %b (Greater Than or Equal (Z = 1 or Z = N = 0)), f = %b, b = %b",
                  opcode_ccc[2:0], f, b);
        #10;
		
		opcode_ccc[2:0] = 3'b101; // Less Than or Equal condition
		f = 3'b100; // Flags: {N, V, Z} = {1, 0, 0}
		#10;
		$display("B: ccc = %b (Less Than or Equal (N = 1 or Z = 1)), f = %b, b = %b",
                  opcode_ccc[2:0], f, b);
        #10;
		
		opcode_ccc[2:0] = 3'b110; // Overflow
		f = 3'b010; // Flags: {N, V, Z} = {0, 1, 0}
		#10;
		$display("B: ccc = %b (Overflow (V = 1)), f = %b, b = %b",
                  opcode_ccc[2:0], f, b);
        #10;
		
		opcode_ccc[2:0] = 3'b111; // Unconditional condition
		#10;
		$display("B: ccc = %b (Unconditional), b = %b",
                  opcode_ccc[2:0], b);
        #10;

        opcode_ccc[6:3] = BR;
		#10;
		$display("BR: opcode = %b, RegWrite = %b, MemWrite = %b, MemRead = %b, ALUSrc = %b, Reg1Select = %b, WheretoReg = %b, ALUOp = %b, b = %b, pcs = %b, hlt = %b",
                  opcode_ccc[6:3], RegWrite, MemWrite, MemRead, ALUSrc, Reg1Select, WheretoReg, ALUOp, b, pcs, hlt);
        #10;
		
		opcode_ccc[2:0] = 3'b000;	// Not Equal condition
		f = 3'b000; // Flags: {N, V, Z} = {0, 0, 0}
		#10;
		$display("BR: ccc = %b (Not Equal (Z = 0)), f = %b, br = %b",
                  opcode_ccc[2:0], f, br);
        #10;
		
		opcode_ccc[2:0] = 3'b001; // Equal condition
		f = 3'b001; // Flags: {N, V, Z} = {0, 0, 1}
		#10;
		$display("BR: ccc = %b (Equal (Z = 1)), f = %b, br = %b",
                  opcode_ccc[2:0], f, br);
        #10;
		
		opcode_ccc[2:0] = 3'b010; // Greater Than condition
		f = 3'b000; // Flags: {N, V, Z} = {0, 0, 0}
		#10;
		$display("BR: ccc = %b (Greater Than (Z = N = 0)), f = %b, br = %b",
                  opcode_ccc[2:0], f, br);
        #10;
		
		opcode_ccc[2:0] = 3'b011; // Less Than condition
		f = 3'b100; // Flags: {N, V, Z} = {1, 0, 0}
		#10;
		$display("BR: ccc = %b (Less Than (N = 1)), f = %b, br = %b",
                  opcode_ccc[2:0], f, br);
        #10;
		
		opcode_ccc[2:0] = 3'b100; // Greater Than or Equal condition
		f = 3'b010; // Flags: {N, V, Z} = {0, 1, 0}
		#10;
		$display("BR: ccc = %b (Greater Than or Equal (Z = 1 or Z = N = 0)), f = %b, br = %b",
                  opcode_ccc[2:0], f, br);
        #10;
		
		opcode_ccc[2:0] = 3'b101; // Less Than or Equal condition
		f = 3'b100; // Flags: {N, V, Z} = {1, 0, 0}
		#10;
		$display("BR: ccc = %b (Less Than or Equal (N = 1 or Z = 1)), f = %b, br = %b",
                  opcode_ccc[2:0], f, br);
        #10;
		
		opcode_ccc[2:0] = 3'b110; // Overflow
		f = 3'b010; // Flags: {N, V, Z} = {0, 1, 0}
		#10;
		$display("BR: ccc = %b (Overflow (V = 1)), f = %b, br = %b",
                  opcode_ccc[2:0], f, br);
        #10;
		
		opcode_ccc[2:0] = 3'b111; // Unconditional condition
		#10;
		$display("BR: ccc = %b (Unconditional), br = %b",
                  opcode_ccc[2:0], br);
        #10;

        opcode_ccc[6:3] = PCS;
		#10;
		$display("PCS: opcode = %b, RegWrite = %b, MemWrite = %b, MemRead = %b, ALUSrc = %b, Reg1Select = %b, WheretoReg = %b, ALUOp = %b, b = %b, br = %b, pcs = %b, hlt = %b",
                  opcode_ccc[6:3], RegWrite, MemWrite, MemRead, ALUSrc, Reg1Select, WheretoReg, ALUOp, b, br, pcs, hlt);
        #10;

        opcode_ccc[6:3] = HLT;
		#10;
		$display("HLT: opcode = %b, RegWrite = %b, MemWrite = %b, MemRead = %b, ALUSrc = %b, Reg1Select = %b, WheretoReg = %b, ALUOp = %b, b = %b, br = %b, pcs = %b, hlt = %b",
                  opcode_ccc[6:3], RegWrite, MemWrite, MemRead, ALUSrc, Reg1Select, WheretoReg, ALUOp, b, br, pcs, hlt);
        #10;

        $finish;
	end 
	
endmodule