module CPU (
    input clock,
    input reset,
	input button,
    input [16:0] switches,
    output [6:0] display1,
    output [6:0] display2,
    output [6:0] display3,
    output [6:0] display4,
    output [6:0] display5,
    output [6:0] display6,
    output [6:0] display7,
    output [6:0] display8,
    output loading_out,        // HD Loading status
    output ctx_save_out,       // Context Save status
    output ctx_restore_out,    // Context Restore status
	output [31:0] instruction, rsval, rdval, rtval, disp, immediate,    // Dados de debug
	output [11:0] addrrom, // addrpc,      // Endereços da ROM e PC (debug)
	output jumpSign, branchSign, ulaOut1, but,       // Sinais de controle (debug)
    output [5:0] ram_addr_in,             // Endereço de escrita na RAM (debug)
    output [31:0] ramIn, //ramWrote,      // Dados escritos na RAM (debug)
    output [31:0] ramOut, //ulaOut32,     // Dados lidos da RAM e saída da ULA (debug)
    // output [5:0] addr_rs, addr_rt, addr_rd,     // Endereços dos registradores (debug)
    // output timer_irq_out,              // IRQ do timer (debug)
    // output [31:0] timer_counter_out,   // Contador do timer (debug)
    // output [11:0] epc_out,             // EPC (debug)
    output [10:0] ram_addr_out,        // RAM address (debug)
    output os_usage_out               // OS mode (debug)
    // output mem_write_out,              // Memory write enable (debug)
    // output slow_clk_out                // Slow clock (debug)
    // LCD outputs
    // output [31:0] LCD_OUT
    );

wire [3:0] controleULA;
wire [31:0] rs;
wire [31:0] rt;
wire [31:0] rd;
wire [31:0] out32ULA;
wire [63:0] out64ULA;
wire out1ULA;
wire sign_hilo;
wire [31:0] instrucao;
wire [31:0] regvalue32;
wire [31:0] in2ula;
wire [63:0] value64;
wire [31:0] hi;
wire [31:0] lo;
wire writeregs;
wire [5:0] addr_read_ram;
wire [5:0] addr_write_ram;
wire [31:0] data_write_ram;
wire [31:0] outram;
wire [11:0] addr_read_rom;
wire controleJump;
wire [11:0] pc_addr;
wire controleBranch;
wire controleImediato;
wire controleJumpReg;
wire [2:0] controleRegWrite;
wire controleMemWrite;
wire movhi;
wire movlo;
wire outuse;
wire [1:0] extent;
wire [11:0] JumpAddress;
wire OutputReset;
wire [31:0] outoutput;
wire halt;
wire inputuse;
wire readregs;
wire outreg;
wire [31:0] data_display;
wire clk;
wire [5:0] write_addr; // Endereco de escrita do registrador destino
wire [1:0] rTD; // Seleciona o endereco de escrita do registrador destino
wire [11:0] JalAddress;
wire [31:0] data_wrote;
wire lcd_write_enable;
wire lcd_clear;
wire lcd_ready;
wire [1:0] lcd_mode;  // OS mode signal: 00=char, 01=selecting, 10=running

// Novos wires para Timer e Interrupções
wire timer_irq;
wire [31:0] timer_counter;
wire clear_timer_irq;
wire reti;
wire [11:0] EPC;

// Sinais para SO Controler
wire user_mode;
wire OSUsage;
wire [3:0] progIndex;   // Sempre reg 61 do banco
wire clearProgramRam;
wire [11:0] ram_addr;

// Sinal HD
wire loading;
wire loadinginternal;
wire rom_write_enable;
// Registered ROM write signals to avoid same-delta race between HDLoader and ROM
reg rom_write_enable_r;
reg [9:0] ROMWriteAddr_r;
wire loadFlag;
wire [31:0] HDInstrucao;
wire [11:0] HDReadAddr;
wire [9:0] ROMWriteAddr;

// Sinais para Context Switcher
wire saveContext;
wire restoreContext;
wire [5:0] ctx_read_addr;
wire [31:0] ctx_read_data;
wire [5:0] ctx_write_addr;
wire [31:0] ctx_write_data;
wire ctx_write_en;
wire ctx_busy;
wire [11:0] ctx_restored_PC;
wire ctx_restore_PC_valid;
wire ctx_ram_active;

// Context Switcher RAM interface
wire [11:0] ctx_ram_addr;
wire ctx_ram_write;
wire [31:0] ctx_ram_data_out;
wire [31:0] ctx_ram_data_in;

// Debounced button signal
wire button_debounced;

// Frequency Divider
DivFreq DivFreq_inst (
    .clock(clock),
    .clock_div(clk)
);

// Button Debounce - filters mechanical bounce for clean signal
Debounce debounce_inst (
    .clk(clock),
    .button_in(button),
    .button_pulse(button_debounced)
);

// Branch Address Calculator
brancher brancher_inst (
    .in(JumpAddress),
    .jump(controleJump),
    .jumpReg(controleJumpReg),
    .branch(controleBranch),
    .out1ULA(out1ULA),
    .clk(clk),
    .OSUsage(OSUsage),
    .pc(addr_read_rom),
    .address(pc_addr)
);

// Jump Register Selector
MUX2_12bit mux_jump_reg (
    .A(instrucao[11:0]),
    .B(rs[11:0]),
    .S(controleJumpReg),
    .X(JumpAddress)
);

ProgramCounter pc_inst (
    .clk(clk),
    .reset(reset),
    .enable(inputuse),
    .halt(halt),
    .button(button_debounced),      // Debounced button (active low)
    .jump(controleJump),
    .branch(controleBranch),
    .out1ULA(out1ULA),
    .addr(pc_addr),                 // Use adjusted address from brancher
    .timer_irq(timer_irq),
    .reti(reti),
    .loading(loading),
    .ctx_busy(ctx_busy),
    .ctx_restore_valid(ctx_restore_PC_valid),
    .ctx_restored_PC(ctx_restored_PC),
    .clear_timer_irq(clear_timer_irq),
    .JalAddress(JalAddress),
    .pc(addr_read_rom),
    .EPC(EPC)
);

HD_sim hd_sim_inst (
    .data(32'b0), // Do not write to HD in this design
    .read_addr(HDReadAddr),
    .write_addr(12'b0),
    .we(1'b0),
    .clock(clk),
    .q(HDInstrucao),
    .data_wrote()
);

HDLoader hd_loader_inst (
    .clock(clk),
    .reset(reset),
    .progIndex(progIndex),
    .loadFlag(loadFlag),
    .HDReadAddr(HDReadAddr),
    .ROMWriteAddr(ROMWriteAddr),
    .loadinginternal(loadinginternal),
    .loading(loading),
    .writeEnable(rom_write_enable)
);

// Instruction ROM
ROMSinglePort rom_inst (
    .addr_read(addr_read_rom[9:0]),
    .addr_write(ROMWriteAddr_r),
    .data(HDInstrucao),
    .clk(clk),
    .we(rom_write_enable_r),
    .q(instrucao)
);

// Register write enable and address one cycle earlier on clk
always @(posedge clk) begin
    rom_write_enable_r <= rom_write_enable;
    ROMWriteAddr_r <= ROMWriteAddr;
end

// Instruction Decoder
Controle controle_inst (
    .opcode(instrucao[31:26]),
    .controleULA(controleULA),
    .controleImediato(controleImediato),
    .controleWriteRegs(writeregs),
    .controleReadRegs(readregs),
    .controleRegInput(controleRegWrite),
    .controleMemWrite(controleMemWrite),
    .controleJump(controleJump),
    .controleBranch(controleBranch),
    .controleJumpReg(controleJumpReg),
    .movhi(movhi),
    .movlo(movlo),
    .outuse(outuse),
    .extent(extent),
    .outputreset(OutputReset),
    .inputuse(inputuse),
    .outreg(outreg),
    .rTD(rTD),
    .halt(halt),
    .reti(reti),
    .lcd_write_enable(lcd_write_enable),
    .lcd_clear(lcd_clear),
    .lcd_mode(lcd_mode),
    .UserRegUsage(user_mode),
    .loadFlag(loadFlag),
    .saveContext(saveContext),
    .restoreContext(restoreContext)
);

// SO Controler
SO_Control so_control_inst (
    .clock(clk),
    .reset(reset),
    .halt(halt),
    .timer_irq(timer_irq),
    .user_mode(user_mode),
    .clear_irq(clear_timer_irq),
    .reti(reti),                               // RETI will cause return to user mode
    .ctx_busy(ctx_busy),
    .OSUsage(OSUsage)
);

// Register File
Registradores registradores_inst (
    .endereco_leitura1(instrucao[25:20]),
    .endereco_leitura2(instrucao[19:14]),
    .endereco_escrita(write_addr),
    // .test_addr(6'b0),
    .clock(clock),
    .rclock(clk),
    .writeRegs(writeregs),
    .readRegs(readregs),
    .hilo(sign_hilo),
    .OSUsage(OSUsage),
    .dados_escrita_32(regvalue32),
    .dados_escrita_64(out64ULA),
    // Context Switcher interface
    .ctx_read_addr(ctx_read_addr),
    .ctx_read_data(ctx_read_data),
    .ctx_write_addr(ctx_write_addr),
    .ctx_write_data(ctx_write_data),
    .ctx_write_en(ctx_write_en),
    .ctx_busy(ctx_busy),
    // Normal outputs
    .leituraRS(rs),
    .leituraRT(rt),
    .leituraRD(rd),
    .hi(hi),
    .lo(lo),
    .progIndex(progIndex)
);

// Write Address Multiplexer
MUX_6bits mux_reg_write_addr (
    .A(instrucao[19:14]),
    .B(instrucao[13:8]),
    .C(6'b011111),
    .D(6'b0),
    .S(rTD),
    .X(write_addr)
);

// Register Data Multiplexer
MUX8 mux_reg (
    .A(out32ULA),
    .B(outram),
    .C({15'b0, switches}),
    .D({18'b0, instrucao[13:0]}),
    .E(rs),
    .F({20'b0, JalAddress}),
    .G(hi),
    .H(lo),
    .S(controleRegWrite),
    .X(regvalue32)
);

// Immediate Value Multiplexer
MUX mux_imm (
    .A(rt),
    .B({18'b0, instrucao[13:0]}),
    .C(32'b0),
    .D(32'b0),
    .S({1'b0, controleImediato}),
    .X(in2ula)
);

// Arithmetic Logic Unit
ULA ULA_inst (
    .controle(controleULA),
    .in1(rs),
    .in2(in2ula),
    .in3(32'b0),
    .out_32(out32ULA),
    .out_64(out64ULA),
    .out1(out1ULA),
    .sign_hilo(sign_hilo)
);

// RAM/Register Multiplexer
MUX2 mux_ram_reg (
    .A(outram),
    .B(rs),
    .S(outreg),
    .X(data_display)
);

// RAM Offset Calculator
RAMOffset ram_offset_inst (
    .OSUsage(OSUsage),
    .progIndex(progIndex),
    .local_addr(out32ULA[11:0]),
    .actual_addr(ram_addr)
);

// RAM access mux: Context Switcher has priority when busy
// RAM access mux: Context Switcher has priority only when it is actively accessing RAM
wire [11:0] ram_addr_muxed = ctx_ram_active ? ctx_ram_addr : ram_addr;
wire [31:0] ram_data_muxed = ctx_ram_active ? ctx_ram_data_out : rt;
wire ram_we_muxed = ctx_ram_active ? ctx_ram_write : controleMemWrite;

// Data RAM (Dual Port, Dual Clock)
RAMDualPortDualClock ram_inst (
    .data(ram_data_muxed),
    .addr(ram_addr_muxed),
    .we(ram_we_muxed),
    .clock(clk),
    .fast_clock(clock),
    .reset(reset),
    .q(outram),
    .data_wrote(data_wrote)
);

// Connect RAM output to context switcher
assign ctx_ram_data_in = outram;

// Output Display Controller
OutputMod output_inst (
    .in(data_display),
    .address({1'b0, instrucao[25:20]}),
    .reset(OutputReset),
    .clk(clk),
        .write(outuse),
        .progIndex(progIndex),
    .out(outoutput), // outoutput is 1 bit, out is 32 bits. This is still a mismatch.
    .display1(display1),
    .display2(display2),
    .display3(display3),
    .display4(display4),
    .display5(display5),
    .display6(display6),
    .display7(display7),
    .display8(display8)
);

// Instância do Timer
// Timer pauses when inputuse=1 (INPUT/OUTPUT active, user I/O shouldn't consume quantum)
// Timer also pauses during program loading (loading=1)
// Timer also pauses during context switching (ctx_busy=1)
// Timer counts when normal execution (no I/O, no loading, no ctx switch)
Timer timer_inst (
    .clock(clk),
    .reset(reset),
    .opcode(instrucao[31:26]),
    .rs_value(rs),
    .clear_irq(clear_timer_irq),
    .enable(!inputuse && !loading && !ctx_busy),  // Only count during normal execution
    .irq_out(timer_irq),
    .counter_out(timer_counter)
);

// Context Switcher Instance
ContextSwitcher context_switcher_inst (
    .clock(clk),
    .reset(reset),
    .save_trigger(saveContext),
    .restore_trigger(restoreContext),
    .progIndex(progIndex),
    .current_PC(EPC),
    // Register file interface
    .reg_addr(ctx_read_addr),
    .reg_write(ctx_write_en),
    .reg_data_out(ctx_write_data),
    .reg_data_in(ctx_read_data),
    // RAM interface  
    .ram_addr(ctx_ram_addr),
    .ram_write(ctx_ram_write),
    .ram_data_out(ctx_ram_data_out),
    .ram_data_in(ctx_ram_data_in),
    // PC restore
    .restored_PC(ctx_restored_PC),
    .restore_PC_valid(ctx_restore_PC_valid),
    .ram_active(ctx_ram_active),
    // Status
    .busy(ctx_busy)
);

// Connect context switcher write address to read address (same signal for this module)
assign ctx_write_addr = ctx_read_addr;

assign loading_out = loading;
assign ctx_save_out = saveContext;
assign ctx_restore_out = restoreContext;

// assign instruction = instrucao;
assign rsval = rs;
assign rdval = regvalue32;
assign rtval = rt;
// assign disp = data_display;
assign addrrom = OSUsage ? addr_read_rom : (addr_read_rom - 12'd512);
// assign addrpc = JalAddress;
assign jumpSign = controleJump;
assign branchSign = controleBranch;
assign ulaOut1 = out1ULA;
assign but = button_debounced;
assign ram_addr_in = ram_addr_muxed;
assign ramIn = ram_data_muxed;
assign ramOut = outram;
// assign addr_rs = instrucao[25:20];
// assign addr_rt = instrucao[19:14];
// assign addr_rd = write_addr;
// assign immediate = in2ula;
// assign ulaOut32 = out32ULA;
// assign ramWrote = data_wrote;
// assign timer_irq_out = timer_irq;
// assign timer_counter_out = timer_counter;
// assign epc_out = EPC;
// assign ram_addr_out = ram_addr;
assign os_usage_out = OSUsage;
// assign mem_write_out = controleMemWrite;
// assign slow_clk_out = clk;

endmodule