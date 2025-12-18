// Quartus Prime Verilog Template
// Dual Port RAM with separate read/write addresses
// Memory Layout (2816 words used of 4096):
// 0x000-0x0FF: OS/Kernel  (256 words)
// 0x100-0x1FF: Program 0  (256 words)
// 0x200-0x2FF: Program 1  (256 words)
// 0x300-0x3FF: Program 2  (256 words)
// 0x400-0x4FF: Program 3  (256 words)
// 0x500-0x5FF: Program 4  (256 words)
// 0x600-0x6FF: Program 5  (256 words)
// 0x700-0x7FF: Program 6  (256 words)
// 0x800-0x8FF: Program 7  (256 words)
// 0x900-0x9FF: Program 8  (256 words)
// 0xA00-0xAFF: Program 9  (256 words)

module RAMDualPortDualClock
#(parameter DATA_WIDTH=32, parameter ADDR_WIDTH=12)
(
	input [(DATA_WIDTH-1):0] data,
	input [(ADDR_WIDTH-1):0] addr,
	input we, clock, fast_clock, reset,
	output reg [(DATA_WIDTH-1):0] q, 
	output [(DATA_WIDTH-1):0] data_wrote
);
	
	// Declare the RAM variable
	reg [DATA_WIDTH-1:0] ram[(1<<ADDR_WIDTH)-1:0];	
	reg [DATA_WIDTH-1:0] aux;
	integer i;

	initial
	begin
		// Initialize RAM with zeros
		for (i = 0; i < (1<<ADDR_WIDTH); i = i + 1)
			ram[i] = 0;
        
        // Initialize PC for programs 0-2 to 512 (Start of User Code)
        ram[256] = 32'd512;  // Program 0 PC
        ram[512] = 32'd512;  // Program 1 PC
        ram[768] = 32'd512;  // Program 2 PC
		ram[1024] = 32'd512; // Program 3 PC
		ram[1280] = 32'd512; // Program 4 PC
		ram[1536] = 32'd512; // Program 5 PC
		ram[1792] = 32'd512; // Program 6 PC
		ram[2048] = 32'd512; // Program 7 PC
		ram[2304] = 32'd512; // Program 8 PC
		ram[2560] = 32'd512; // Program 9 PC
        
        // ram[258] = 32'd0; // Initialize to 0 for clean counter start
	end
	
	// Write on slow clock posedge
	always @ (posedge clock)
	begin
		if (we)
		begin
			// Normal write operation
			ram[addr] <= data;
			aux <= data;
            // $display("RAM: Writing %h to Addr %d", data, addr);
		end
	end

	// Read on fast clock negedge - faster than slow clock, so data ready before register write
	always @ (negedge fast_clock)
	begin
		q <= ram[addr];
	end

	assign data_wrote = aux;

endmodule