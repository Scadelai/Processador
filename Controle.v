module Controle (
  input [5:0] opcode,
  output reg [3:0] controleULA,
  output reg controleImediato,
  output reg controleWriteRegs,
  output reg controleReadRegs,
  output reg [2:0] controleRegInput,
  output reg controleMemWrite,
  output reg controleJump,
  output reg controleBranch,
  output reg controleJumpReg,
  output reg movhi,
  output reg movlo,
  output reg outuse,
  output reg [1:0] extent,
  output reg outputreset,
  output reg inputuse,
  output reg outreg,
  output reg [1:0] rTD,
  output reg halt,
  output reg reti,              // Sinal de RETI
  output reg lcd_write_enable,  // Novo: Habilitar escrita no LCD
  output reg lcd_clear,         // Novo: Limpar LCD
  output reg [1:0] lcd_mode,    // Novo: Modo LCD (00=char, 01=selecting, 10=running)
  output reg UserRegUsage,      // Novo: Indica uso do banco de registradores do SO
  output reg loadFlag,          // Novo: Indica carregamento de programa
  output reg saveContext,       // Novo: Trigger context save to RAM
  output reg restoreContext      // Novo: Trigger context restore from RAM
);

always @(*)
begin
outreg = 1'b0;
rTD = 2'b01;                    // Padrão: destino RD(13:8) 
halt = 1'b0;
controleBranch = 1'b0;
reti = 1'b0;                    // Padrão RETI
lcd_write_enable = 1'b0;        // Padrão: sem escrita LCD
lcd_clear = 1'b0;               // Padrão: sem limpeza LCD
lcd_mode = 2'b00;               // Padrão: modo caractere individual
UserRegUsage = 1'b0;            // Padrão: uso normal dos registradores
loadFlag = 1'b0;                // Padrão: não carregar programa
saveContext = 1'b0;             // Padrão: não salvar contexto
restoreContext = 1'b0;          // Padrão: não restaurar contexto
    case(opcode)
    //ADD
    6'b000000:
        begin
        outreg = 1'b0;
        movhi = 1'b0;
        movlo = 1'b0;
        controleJumpReg = 1'b0;
        outuse = 1'b0;
        extent = 2'b0;
        outputreset = 1'b0;
        controleReadRegs = 1'b1;
        inputuse = 1'b0;
        controleULA = 4'b0000;
        controleImediato = 1'b0;
        controleWriteRegs = 1'b1;
        controleRegInput = 3'b000;
        controleMemWrite = 1'b0;
        controleJump = 1'b0;
        end
      //SUB
      6'b000001:
        begin
        outreg = 1'b0;
        movhi = 1'b0;
        movlo = 1'b0;
        controleJumpReg = 1'b0;
        outuse = 1'b0;
        extent = 2'b0;
        outputreset = 1'b0;
        controleReadRegs = 1'b1;
        inputuse = 1'b0;
        controleULA = 4'b0001;
        controleImediato = 1'b0;
        controleWriteRegs = 1'b1;
        controleRegInput = 3'b000;
        controleMemWrite = 1'b0;
        controleJump = 1'b0;
        end
      //MULT
      6'b000010:
        begin
        outreg = 1'b0;
        movhi = 1'b0;
        movlo = 1'b0;
        controleJumpReg = 1'b0;
        outuse = 1'b0;
        extent = 2'b0;
        outputreset = 1'b0;
        controleReadRegs = 1'b1;
        inputuse = 1'b0;
        controleULA = 4'b0010;
        controleImediato = 1'b0;
        controleWriteRegs = 1'b1;
        controleRegInput = 3'b000;
        controleMemWrite = 1'b0;
        controleJump = 1'b0;
        end
      //DIV
      6'b000011:
        begin
        outreg = 1'b0;
        movhi = 1'b0;
        movlo = 1'b0;
        controleJumpReg = 1'b0;
        outuse = 1'b0;
        extent = 2'b0;
        outputreset = 1'b0;
        controleReadRegs = 1'b1;
        inputuse = 1'b0;
        controleULA = 4'b0011;
        controleImediato = 1'b0;
        controleWriteRegs = 1'b1;
        controleRegInput = 3'b000;
        controleMemWrite = 1'b0;
        controleJump = 1'b0;
        end
      //AND
      6'b000100:
        begin
        outreg = 1'b0;
        movhi = 1'b0;
        movlo = 1'b0;
        controleJumpReg = 1'b0;
        outuse = 1'b0;
        extent = 2'b0;
        outputreset = 1'b0;
        controleReadRegs = 1'b1;
        inputuse = 1'b0;
        controleULA = 4'b0100;
        controleImediato = 1'b0;
        controleWriteRegs = 1'b1;
        controleRegInput = 3'b000;
        controleMemWrite = 1'b0;
        controleJump = 1'b0;
        end
      //OR
      6'b000101:
        begin
        outreg = 1'b0;
        movhi = 1'b0;
        movlo = 1'b0;
        controleJumpReg = 1'b0;
        outuse = 1'b0;
        extent = 2'b0;
        outputreset = 1'b0;
        controleReadRegs = 1'b1;
        inputuse = 1'b0;
        controleULA = 4'b0101;
        controleImediato = 1'b0;
        controleWriteRegs = 1'b1;
        controleRegInput = 3'b000;
        controleMemWrite = 1'b0;
        controleJump = 1'b0;
        end
      //SLL
      6'b000110:
        begin
        outreg = 1'b0;
        movhi = 1'b0;
        movlo = 1'b0;
        controleJumpReg = 1'b0;
        outuse = 1'b0;
        extent = 2'b0;
        outputreset = 1'b0;
        controleReadRegs = 1'b1;
        inputuse = 1'b0;
        controleULA = 4'b1011;
        controleImediato = 1'b1;
        controleWriteRegs = 1'b1;
        controleRegInput = 3'b000;
        controleMemWrite = 1'b0;
        controleJump = 1'b0;
        end
      //SRL
      6'b000111:
        begin
        outreg = 1'b0;
        movhi = 1'b0;
        movlo = 1'b0;
        controleJumpReg = 1'b0;
        outuse = 1'b0;
        extent = 2'b0;
        outputreset = 1'b0;
        controleReadRegs = 1'b1;
        inputuse = 1'b0;
        controleULA = 4'b1100;
        controleImediato = 1'b1;
        controleWriteRegs = 1'b1;
        controleRegInput = 3'b000;
        controleMemWrite = 1'b0;
        controleJump = 1'b0;
        end
      //SLT
      6'b001000:
        begin
        outreg = 1'b0;
        movhi = 1'b0;
        movlo = 1'b0;
        controleJumpReg = 1'b0;
        outuse = 1'b0;
        extent = 2'b0;
        outputreset = 1'b0;
        controleReadRegs = 1'b1;
        inputuse = 1'b0;
        controleULA = 4'b0110;
        controleImediato = 1'b0;
        controleWriteRegs = 1'b1;
        controleRegInput = 3'b000;
        controleMemWrite = 1'b0;
        controleJump = 1'b0; 
        end      
      //MFHI
      6'b001001:
        begin
        outreg = 1'b0;
        movlo = 1'b0;
        controleJumpReg = 1'b0;
        outuse = 1'b0;
        extent = 2'b0;
        outputreset = 1'b0;
        controleReadRegs = 1'b1;
        inputuse = 1'b0;
        controleULA = 4'bXXXX;
        controleImediato = 1'b0;
        controleWriteRegs = 1'b1;
        controleRegInput = 3'b110;
        controleMemWrite = 1'b0;
        controleJump = 1'b0;
        movhi = 1'b1;
        end
      //MFLO
      6'b001010:
        begin
        outreg = 1'b0;
        movhi = 1'b0;
        controleJumpReg = 1'b0;
        outuse = 1'b0;
        extent = 2'b0;
        outputreset = 1'b0;
        controleReadRegs = 1'b1;
        inputuse = 1'b0;
        controleULA = 4'bXXXX;
        controleImediato = 1'b0;
        controleWriteRegs = 1'b1;
        controleRegInput = 3'b111;
        controleMemWrite = 1'b0;
        controleJump = 1'b0;
        movlo = 1'b1;
        end
      //MOVE
      6'b001011:
        begin
        outreg = 1'b0;
        movhi = 1'b0;
        movlo = 1'b0;
        controleJumpReg = 1'b0;
        outuse = 1'b0;
        extent = 2'b0;
        outputreset = 1'b0;
        controleReadRegs = 1'b1;
        inputuse = 1'b0;
        controleULA = 4'bXXXX;
        controleImediato = 1'b0;
        controleWriteRegs = 1'b1;
        controleRegInput = 3'b100;
        controleMemWrite = 1'b0;
        controleJump = 1'b0;
        end
      //JR
      6'b001100:
        begin
        outreg = 1'b0;
        movhi = 1'b0;
        movlo = 1'b0;
        outuse = 1'b0;
        extent = 2'b0;
        outputreset = 1'b0;
        controleReadRegs = 1'b1;
        inputuse = 1'b0;
        controleULA = 4'bXXXX;
        controleImediato = 1'b0;
        controleWriteRegs = 1'b0;
        controleRegInput = 3'b000;
        controleMemWrite = 1'b0;
        controleJump = 1'b1;
        controleJumpReg = 1'b1;
        end
      //JALR
      6'b001101:
        begin
        outreg = 1'b0;
        movhi = 1'b0;
        movlo = 1'b0;
        outuse = 1'b0;
        extent = 2'b0;
        outputreset = 1'b0;
        controleReadRegs = 1'b1;
        inputuse = 1'b0;
        controleULA = 4'bXXXX;
        controleImediato = 1'b0;
        controleWriteRegs = 1'b1;
        controleRegInput = 3'b000;
        controleMemWrite = 1'b0;
        controleJump = 1'b0;
        controleJumpReg = 1'b1;
        end
      //LA
      6'b001110:
        begin
        outreg = 1'b0;
        movhi = 1'b0;
        movlo = 1'b0;
        controleJumpReg = 1'b0;
        outuse = 1'b0;
        extent = 2'b0;
        outputreset = 1'b0;
        controleReadRegs = 1'b1;
        inputuse = 1'b0;
        controleULA = 4'bXXXX;
        controleImediato = 1'b0;
        controleWriteRegs = 1'b1;
        controleRegInput = 3'b001;
        controleMemWrite = 1'b0;
        controleJump = 1'b0;
        rTD = 2'b00;
        end
      //ADDI
      6'b001111:
        begin
        outreg = 1'b0;
        movhi = 1'b0;
        movlo = 1'b0;
        controleJumpReg = 1'b0;
        outuse = 1'b0;
        extent = 2'b0;
        outputreset = 1'b0;
        controleReadRegs = 1'b1;
        inputuse = 1'b0;
        controleULA = 4'b0000;
        controleImediato = 1'b1;
        controleWriteRegs = 1'b1;
        controleRegInput = 3'b000;
        controleMemWrite = 1'b0;
        controleJump = 1'b0;
        rTD = 2'b00;
        end
      //SUBI
      6'b010000:
        begin
        outreg = 1'b0;
        movhi = 1'b0;
        movlo = 1'b0;
        controleJumpReg = 1'b0;
        outuse = 1'b0;
        extent = 2'b0;
        outputreset = 1'b0;
        controleReadRegs = 1'b1;
        inputuse = 1'b0;
        controleULA = 4'b0001;
        controleImediato = 1'b1;
        controleWriteRegs = 1'b1;
        controleRegInput = 3'b000;
        controleMemWrite = 1'b0;
        controleJump = 1'b0; 
        rTD = 2'b00;
        end
      //ANDI
      6'b010001:
        begin
        outreg = 1'b0;
        movhi = 1'b0;
        movlo = 1'b0;
        controleJumpReg = 1'b0;
        outuse = 1'b0;
        extent = 2'b0;
        outputreset = 1'b0;
        controleReadRegs = 1'b1;
        inputuse = 1'b0;
        controleULA = 4'b0100;
        controleImediato = 1'b1;
        controleWriteRegs = 1'b1;
        controleRegInput = 3'b000;
        controleMemWrite = 1'b0;
        controleJump = 1'b0;
        rTD = 2'b00;
        end
      //ORI
      6'b010010:
        begin
        outreg = 1'b0;
        movhi = 1'b0;
        movlo = 1'b0;
        controleJumpReg = 1'b0;
        outuse = 1'b0;
        extent = 2'b0;
        outputreset = 1'b0;
        controleReadRegs = 1'b1;
        inputuse = 1'b0;
        controleULA = 4'b0101;
        controleImediato = 1'b1;
        controleWriteRegs = 1'b1;
        controleRegInput = 3'b000;
        controleMemWrite = 1'b0; 
        controleJump = 1'b0;
        rTD = 2'b00;
        end
      //BEQ
      6'b010011:
        begin
        outreg = 1'b0;
        movhi = 1'b0;
        movlo = 1'b0;
        controleJumpReg = 1'b0;
        outuse = 1'b0;
        outputreset = 1'b0;
        controleReadRegs = 1'b1;
        inputuse = 1'b0;
        controleULA = 4'b1000;
        controleImediato = 2'b00;
        controleWriteRegs = 1'b0;
        controleRegInput = 3'b000;
        controleMemWrite = 1'b0; 
        controleJump = 1'b0;
		    extent = 2'b01;
        controleBranch = 1'b1;
        end
      //BNE
      6'b010100:
        begin
        outreg = 1'b0;
        movhi = 1'b0;
        movlo = 1'b0;
        controleJumpReg = 1'b0;
        outuse = 1'b0;
        outputreset = 1'b0;
        controleReadRegs = 1'b1;
        inputuse = 1'b0;
        controleULA = 4'b1101;
        controleImediato = 1'b0;
        controleWriteRegs = 1'b0;
        controleRegInput = 3'b000;
        controleMemWrite = 1'b0; 
        controleJump = 1'b0;
		    extent = 2'b01;
        controleBranch = 1'b1;
        end
      //BGT
      6'b010101:
        begin
        outreg = 1'b0;
        movhi = 1'b0;
        movlo = 1'b0;
        controleJumpReg = 1'b0;
        outuse = 1'b0;
        outputreset = 1'b0;
        controleReadRegs = 1'b1;
        inputuse = 1'b0;
        controleULA = 4'b0111;
        controleImediato = 1'b0;
        controleWriteRegs = 1'b0;
        controleRegInput = 3'b000;
        controleMemWrite = 1'b0; 
        controleJump = 1'b0;
		    extent = 2'b01;
        controleBranch = 1'b1;
        end
      //BGTE
      6'b010110:
        begin
        outreg = 1'b0;
        movhi = 1'b0;
        movlo = 1'b0;
        controleJumpReg = 1'b0;
        outuse = 1'b0;
        outputreset = 1'b0;
        controleReadRegs = 1'b1;
        inputuse = 1'b0;
        controleULA = 4'b1010;
        controleImediato = 1'b0;
        controleWriteRegs = 1'b0;
        controleRegInput = 3'b000;
        controleMemWrite = 1'b0; 
        controleJump = 1'b0;
		    extent = 2'b01;
        controleBranch = 1'b1;
        end
      //BLT
      6'b010111:
        begin
        outreg = 1'b0;
        movhi = 1'b0;
        movlo = 1'b0;
        controleJumpReg = 1'b0;
        outuse = 1'b0;
        outputreset = 1'b0;
        controleReadRegs = 1'b1;
        inputuse = 1'b0;
        controleULA = 4'b0110;
        controleImediato = 1'b0;
        controleWriteRegs = 1'b0;
        controleRegInput = 3'b000;
        controleMemWrite = 1'b0; 
        controleJump = 1'b0;
		    extent = 2'b01;
        controleBranch = 1'b1;
        end
      //BLTE
      6'b011000:
        begin
        outreg = 1'b0;
        movhi = 1'b0;
        movlo = 1'b0;
        controleJumpReg = 1'b0;
        outuse = 1'b0;
        outputreset = 1'b0;
        controleReadRegs = 1'b1;
        inputuse = 1'b0;
        controleULA = 4'b1001;
        controleImediato = 1'b0;
        controleWriteRegs = 1'b0;
        controleRegInput = 3'b000;
        controleMemWrite = 1'b0; 
        controleJump = 1'b0;
		    extent = 2'b01;
        controleBranch = 1'b1;
        end
      //LW
      6'b011001:
        begin
        outreg = 1'b0;
        movhi = 1'b0;
        movlo = 1'b0;
        controleJumpReg = 1'b0;
        outuse = 1'b0;
        extent = 2'b0;
        outputreset = 1'b0;
        controleReadRegs = 1'b1;
        inputuse = 1'b0;
        controleULA = 4'b0000;
        controleImediato = 1'b1;
        controleWriteRegs = 1'b1;
        controleRegInput = 3'b001;
        controleMemWrite = 1'b0; 
        controleJump = 1'b0;
        rTD = 2'b00;
        end
      //SW
      6'b011010:
        begin
        outreg = 1'b0;
        movhi = 1'b0;
        movlo = 1'b0;
        controleJumpReg = 1'b0;
        outuse = 1'b0;
        extent = 2'b0;
        outputreset = 1'b0;
        controleReadRegs = 1'b0;
        inputuse = 1'b0;
        controleULA = 4'b0000;
        controleImediato = 1'b1;
        controleWriteRegs = 1'b0;
        controleRegInput = 3'b000;
        controleMemWrite = 1'b1;
        controleJump = 1'b0;
        end
      //LI
      6'b011011:
        begin
        outreg = 1'b0;
        movhi = 1'b0;
        movlo = 1'b0;
        controleJumpReg = 1'b0;
        outuse = 1'b0;
        extent = 2'b0;
        outputreset = 1'b0;
        controleReadRegs = 1'b1;
        inputuse = 1'b0;
        controleULA = 4'bXXXX;
        controleImediato = 1'b1;
        controleWriteRegs = 1'b1;
        controleRegInput = 3'b011;
        controleMemWrite = 1'b0; 
        controleJump = 1'b0;
        rTD = 2'b00;
        end
      //J
      6'b011100:
        begin
        outreg = 1'b0;
        movhi = 1'b0;
        movlo = 1'b0;
        controleJumpReg = 1'b0;
        outuse = 1'b0;
        outputreset = 1'b0;
        controleReadRegs = 1'b0;
        inputuse = 1'b0;
        controleULA = 4'bXXXX;
        controleImediato = 1'b0;
        controleWriteRegs = 1'b0;
        controleRegInput = 3'b000;
        controleMemWrite = 1'b0; 
        controleJump = 1'b1;
		    extent = 2'b00;
        end
      //JAL
      6'b011101:
        begin
        outreg = 1'b0;
        movhi = 1'b0;
        movlo = 1'b0;
        controleJumpReg = 1'b0;
        outuse = 1'b0;
        outputreset = 1'b0;
        controleReadRegs = 1'b1;
        inputuse = 1'b0;
        controleULA = 4'bXXXX;
        controleImediato = 1'b0;
        controleWriteRegs = 1'b1;
        controleRegInput = 3'b101;
        controleMemWrite = 1'b0; 
        controleJump = 1'b1;
		    extent = 2'b00;
        rTD = 2'b10;
        end
      //HALT
      6'b011110:
        begin
        outreg = 1'b0;
        movhi = 1'b0;
        movlo = 1'b0;
        controleJumpReg = 1'b0;
        outuse = 1'b0;
        extent = 2'b0;
        outputreset = 1'b0;
        controleReadRegs = 1'b0;
        inputuse = 1'b1;
        controleULA = 4'bXXXX;
        controleImediato = 1'b0;
        controleWriteRegs = 1'b0;
        controleRegInput = 3'b000;
        controleMemWrite = 1'b0; 
        controleJump = 1'b0;
        halt = 1'b1;
        end
		  //OUTPUTMEM
      6'b011111:
        begin
        $display("*** OUTPUTMEM instruction detected at time %t ***", $time);
        outreg = 1'b0;
        movhi = 1'b0;
        movlo = 1'b0;
        controleJumpReg = 1'b0;
        extent = 2'b0;
        outputreset = 1'b0;
        controleReadRegs = 1'b1;
        controleULA = 4'b1111;
        controleImediato = 1'b0;
        controleWriteRegs = 1'b0;
        controleRegInput = 3'b001;
        controleMemWrite = 1'b0; 
        controleJump = 1'b0;
        outuse = 1'b1;
        inputuse = 1'b1;
        end
		  //OUTPUTREG
		  6'b100000:
        begin
        $display("*** OUTPUTREG instruction detected at time %t ***", $time);
        outreg = 1'b1;
        movhi = 1'b0;
        movlo = 1'b0;
        controleJumpReg = 1'b0;
        extent = 2'b0;
        outputreset = 1'b0;
        controleReadRegs = 1'b1;
        controleULA = 4'b1111;
        controleImediato = 1'b0;
        controleWriteRegs = 1'b0;
        controleRegInput = 3'b000;
        controleMemWrite = 1'b0; 
        controleJump = 1'b0;
        outuse = 1'b1;
		    inputuse = 1'b1;
        end
		   //OUTPUT RESET
		  6'b100001:
        begin
        outreg = 1'b0;
        movhi = 1'b0;
        movlo = 1'b0;
        controleJumpReg = 1'b0;
        extent = 2'b0;
        controleReadRegs = 1'b1;
        inputuse = 1'b0;
        controleULA = 4'bXXXX;
        controleImediato = 1'bX;
        controleWriteRegs = 1'b0;
        controleRegInput = 3'b000;
        controleMemWrite = 1'b0; 
        controleJump = 1'b0;
        outuse = 1'b0;
			outputreset = 1'b1;
        end
		  //INPUT
		 6'b100010:
        begin
        $display("*** INPUT instruction detected at time %t, waiting for user input ***", $time);
        outreg = 1'b0;
        movhi = 1'b0;
        movlo = 1'b0;
        controleJumpReg = 1'b0;
        outuse = 1'b0;
        extent = 2'b0;
        outputreset = 1'b0;
        controleReadRegs = 1'b0;
        controleULA = 4'bXXXX;
        controleImediato = 1'bX;
        controleWriteRegs = 1'b1;
        controleRegInput = 3'b010;
        controleMemWrite = 1'b0; 
        controleJump = 1'b0;
		    inputuse = 1'b1;
        end
		 
      // RETI (opcode 0x23 = 35 decimal)
      6'b100011:
        begin
        reti = 1'b1;
        controleJump = 1'b1;       // Força salto para EPC
        controleWriteRegs = 1'b0;  // Não escreve registrador
        controleReadRegs = 1'b0;
        controleMemWrite = 1'b0;
        controleULA = 4'b0000;
        controleImediato = 1'b0;
        controleRegInput = 3'b000;
        movhi = 1'b0;
        movlo = 1'b0;
        controleJumpReg = 1'b0;
        outuse = 1'b0;
        extent = 2'b0;
        outputreset = 1'b0;
        inputuse = 1'b0;
        outreg = 1'b0;
        UserRegUsage = 1'b1;       // CORREÇÃO: Voltar para modo usuário
        end
      
      // SET_QUANTUM (opcode 0x24 = 36 decimal)
      // ENABLE_TIMER (opcode 0x25 = 37 decimal)
      // DISABLE_TIMER (opcode 0x26 = 38 decimal)
      // Decodificadas pelo TimerController, aqui são NOP
      6'b100100, 6'b100101, 6'b100110:
        begin
        controleWriteRegs = 1'b0;
        controleReadRegs = 1'b1;   // Lê RS para SET_QUANTUM
        controleMemWrite = 1'b0;
        controleULA = 4'b0000;
        controleImediato = 1'b0;
        controleRegInput = 3'b000;
        controleJump = 1'b0;
        movhi = 1'b0;
        movlo = 1'b0;
        controleJumpReg = 1'b0;
        outuse = 1'b0;
        extent = 2'b0;
        outputreset = 1'b0;
        inputuse = 1'b0;
        outreg = 1'b0;
        end
		 
      // LCD_WRITE (opcode 0x27 = 39 decimal)
      // Escreve caractere no LCD
      // LCD_WRITE_CHAR (opcode 0x27 = 39 decimal)
      // Escreve caractere individual (modo 00)
      // RS = caractere, RT[7:4] = linha, RT[3:0] = coluna
      6'b100111:
        begin
        controleWriteRegs = 1'b0;
        controleReadRegs = 1'b1;   // Lê RS e RT
        controleMemWrite = 1'b0;
        controleULA = 4'b0000;
        controleImediato = 1'b0;
        controleRegInput = 3'b000;
        controleJump = 1'b0;
        movhi = 1'b0;
        movlo = 1'b0;
        controleJumpReg = 1'b0;
        outuse = 1'b0;
        extent = 2'b0;
        outputreset = 1'b0;
        inputuse = 1'b0;
        outreg = 1'b0;
        lcd_write_enable = 1'b1;
        lcd_mode = 2'b00;          // Modo: caractere individual
        end
        
      // LCD_CLEAR (opcode 0x28 = 40 decimal)
      // Limpa o display LCD
      6'b101000:
        begin
        controleWriteRegs = 1'b0;
        controleReadRegs = 1'b0;
        controleMemWrite = 1'b0;
        controleULA = 4'b0000;
        controleImediato = 1'b0;
        controleRegInput = 3'b000;
        controleJump = 1'b0;
        movhi = 1'b0;
        movlo = 1'b0;
        controleJumpReg = 1'b0;
        outuse = 1'b0;
        extent = 2'b0;
        outputreset = 1'b0;
        inputuse = 1'b0;
        outreg = 1'b0;
        lcd_clear = 1'b1;
        end
      
      // LCD_WRITE_OS_SELECTING (opcode 0x29 = 41 decimal)
      // Escreve "program X" com status "selecting" (modo 01)
      // RS = número do programa (0-9)
      6'b101001:
        begin
        controleWriteRegs = 1'b0;
        controleReadRegs = 1'b1;   // Lê RS (programa)
        controleMemWrite = 1'b0;
        controleULA = 4'b0000;
        controleImediato = 1'b0;
        controleRegInput = 3'b000;
        controleJump = 1'b0;
        movhi = 1'b0;
        movlo = 1'b0;
        controleJumpReg = 1'b0;
        outuse = 1'b0;
        extent = 2'b0;
        outputreset = 1'b0;
        inputuse = 1'b0;
        outreg = 1'b0;
        lcd_write_enable = 1'b1;
        lcd_mode = 2'b01;          // Modo: program X "selecting"
        end
      
      // LCD_WRITE_OS_RUNNING (opcode 0x2A = 42 decimal)
      // Escreve "program X" com status "running" (modo 10)
      // RS = número do programa (0-9)
      6'b101010:
        begin
        controleWriteRegs = 1'b0;
        controleReadRegs = 1'b1;   // Lê RS (programa)
        controleMemWrite = 1'b0;
        controleULA = 4'b0000;
        controleImediato = 1'b0;
        controleRegInput = 3'b000;
        controleJump = 1'b0;
        movhi = 1'b0;
        movlo = 1'b0;
        controleJumpReg = 1'b0;
        outuse = 1'b0;
        extent = 2'b0;
        outputreset = 1'b0;
        inputuse = 1'b0;
        outreg = 1'b0;
        lcd_write_enable = 1'b1;
        lcd_mode = 2'b10;          // Modo: program X "running"
        end
      
      // Call prog x (opcode 0x2B = 43 decimal)
      // Faz um JR enviando sinal de troca para registradores do usuário
      6'b101011:
        begin
        outreg = 1'b0;
        movhi = 1'b0;
        movlo = 1'b0;
        outuse = 1'b0;
        extent = 2'b0;
        outputreset = 1'b0;
        controleReadRegs = 1'b1;
        inputuse = 1'b0;
        controleULA = 4'bXXXX;
        controleImediato = 1'b0;
        controleWriteRegs = 1'b0;
        controleRegInput = 3'b000;
        controleMemWrite = 1'b0;
        controleJump = 1'b1;
        controleJumpReg = 1'b1;
        UserRegUsage = 1'b1;
        end

      // Load prog x (opcode 0x2C = 44 decimal)
      // Indica carregamento de programa
      // PC stalls via 'loading' signal from HDLoader, not inputuse
      6'b101100:
        begin
          loadFlag = 1'b1;
          inputuse = 1'b0;    // Normal PC operation (PC stalls via 'loading' signal)
          controleJump = 1'b0;
          controleBranch = 1'b0;
          halt = 1'b0;
          controleWriteRegs = 1'b0;
          controleMemWrite = 1'b0;
          controleReadRegs = 1'b0;
          outuse = 1'b0;
        end
      
      // SAVE_CTX (opcode 0x2D = 45 decimal)
      // Salva contexto (32 regs + PC) para RAM no segmento do programa atual
      6'b101101:
        begin
          $display("*** SAVE_CTX instruction detected at time %t ***", $time);
          saveContext = 1'b1;
          inputuse = 1'b0;
          controleJump = 1'b0;
          controleBranch = 1'b0;
          halt = 1'b0;
          controleWriteRegs = 1'b0;
          controleMemWrite = 1'b0;
          controleReadRegs = 1'b0;
          outuse = 1'b0;
          controleJumpReg = 1'b0;
          movhi = 1'b0;
          movlo = 1'b0;
          extent = 2'b0;
          outputreset = 1'b0;
          controleULA = 4'b0000;
          controleImediato = 1'b0;
          controleRegInput = 3'b000;
        end

      // LOAD_CTX (opcode 0x2E = 46 decimal)
      // Restaura contexto (32 regs + PC) da RAM do segmento do próximo programa
      // User mode switch is handled by SO_Control when ctx_restore_done is high
      6'b101110:
        begin
          $display("*** LOAD_CTX instruction detected at time %t ***", $time);
          restoreContext = 1'b1;
          inputuse = 1'b0;
          controleJump = 1'b0;
          controleBranch = 1'b0;
          halt = 1'b0;
          controleWriteRegs = 1'b0;
          controleMemWrite = 1'b0;
          controleReadRegs = 1'b0;
          outuse = 1'b0;
          controleJumpReg = 1'b0;
          movhi = 1'b0;
          movlo = 1'b0;
          extent = 2'b0;
          outputreset = 1'b0;
          controleULA = 4'b0000;
          controleImediato = 1'b0;
          controleRegInput = 3'b000;
        end
      // NOP (opcode 0x2F = 47 decimal) - formerly INC_PROG, now handled via software
      6'b101111:
        begin
          // NOP - does nothing, progIndex update done via ADDI in ISR
          inputuse = 1'b0;
          controleJump = 1'b0;
          controleBranch = 1'b0;
          halt = 1'b0;
          controleWriteRegs = 1'b0;
          controleMemWrite = 1'b0;
          controleReadRegs = 1'b0;
          outuse = 1'b0;
          controleJumpReg = 1'b0;
          movhi = 1'b0;
          movlo = 1'b0;
          extent = 2'b0;
          outputreset = 1'b0;
          controleULA = 4'b0000;
          controleImediato = 1'b0;
          controleRegInput = 3'b000;
        end
      
      default:
        begin
        controleWriteRegs = 1'b0;
        controleReadRegs = 1'b1;   // Lê RS (programa)
        controleMemWrite = 1'b0;
        controleULA = 4'b0000;
        controleImediato = 1'b0;
        controleRegInput = 3'b000;
        controleJump = 1'b0;
        movhi = 1'b0;
        movlo = 1'b0;
        controleJumpReg = 1'b0;
        outuse = 1'b0;
        extent = 2'b0;
        outputreset = 1'b0;
        inputuse = 1'b0;
        outreg = 1'b0;
        lcd_write_enable = 1'b1;
        lcd_mode = 2'b10;          // Modo: program X "running"
        end
    endcase
end
endmodule
