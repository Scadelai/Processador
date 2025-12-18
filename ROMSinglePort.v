// Quartus Prime Verilog Template
// Single Port ROM

module ROMSinglePort
#(parameter DATA_WIDTH=32, parameter ADDR_WIDTH=10)
(
	input [(ADDR_WIDTH-1):0] addr_read, addr_write,
	input [DATA_WIDTH-1:0] data,
	input clk, we,
	output reg [(DATA_WIDTH-1):0] q
);

	// Declare the ROM variable
	reg [DATA_WIDTH-1:0] rom[0:2**ADDR_WIDTH-1];

	// Initialize the ROM with $readmemb.  Put the memory contents
	// in the file single_port_rom_init.txt.  Without this file,
	// this design will not compile.

	// See Verilog LRM 1364-2001 Section 17.2.8 for details on the
	// format of this file, or see the "Using $readmemb and $readmemh"
	// template later in this section.

	integer i;
	initial
	begin
		for (i = 0; i < 2**ADDR_WIDTH; i = i + 1)
			rom[i] = 0;
		$readmemb("rom_os.txt", rom);
	end

	always @ (posedge clk)
	begin
		if (we) begin
			rom[addr_write] <= data;
			$display("[ROMSinglePort] WRITE: addr=%0d data=%b time=%0t", addr_write, data, $time);
		end
	end

	always @ (negedge clk)
	begin
		q <= rom[addr_read];
	end

endmodule