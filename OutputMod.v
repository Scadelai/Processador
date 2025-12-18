module OutputMod (
	input [31:0] in,
	input [6:0] address,
	input reset,
	input clk, write,
	input [3:0] progIndex,
	output [31:0] out,
	output [6:0] display1,
	output [6:0] display2,
	output [6:0] display3,
	output [6:0] display4,
	output [6:0] display5,
	output [6:0] display6,
	output [6:0] display7,
	output [6:0] display8 
	);

integer PrimeiroClock = 0;
reg [6:0] displays [7:0];
wire [15:0] bcd_reg;
wire [6:0] segments [3:0];

bcd bcd_inst(in, bcd_reg);
seg7 seg7_inst(bcd_reg, segments[0], segments[1], segments[2], segments[3]);

// ProgIndex display: two digits (tens, ones)
wire [3:0] prog_tens = (progIndex >= 4'd10) ? 4'd1 : 4'd0;
wire [3:0] prog_ones = (progIndex >= 4'd10) ? (progIndex - 4'd10) : progIndex;
wire [15:0] bcd_prog = {8'b0, prog_tens, prog_ones};
wire [6:0] prog_segments [3:0];
seg7 seg7_prog(bcd_prog, prog_segments[0], prog_segments[1], prog_segments[2], prog_segments[3]);

always @(negedge clk)
	begin
			if(PrimeiroClock == 0 || reset == 1)
				begin
					PrimeiroClock = 1;
					displays[0] = 7'b1000000;
					displays[1] = 7'b1000000;
					displays[2] = 7'b1000000;
					displays[3] = 7'b1000000;
					displays[4] = 7'b1000000;
					displays[5] = 7'b1000000;
					displays[6] = 7'b1000000;
					displays[7] = 7'b1000000;
				end
				
			if(write == 0)
				begin
				displays[0] = 7'b1000000;
				displays[1] = 7'b1000000;
				displays[2] = 7'b1000000;
				displays[3] = 7'b1000000;
				end
			else
				begin
				$display("*** OUTPUT: Displaying value %d (0x%h) at time %t ***", in, in, $time);
				displays[0] = segments[0];
				displays[1] = segments[1];
				displays[2] = segments[2];
				displays[3] = segments[3];
				end

			// Displays 4 and 5 reserved (left unchanged by writes)
			// Displays 6 and 7 (last two) are always driven by progIndex
			displays[6] = prog_segments[0]; // ones
			displays[7] = prog_segments[1]; // tens
   end

assign display1 = displays[0];
assign display2 = displays[1];
assign display3 = displays[2];
assign display4 = displays[3];
assign display5 = displays[4];
assign display6 = displays[5];
assign display7 = displays[6];
assign display8 = displays[7];
assign out = in;

endmodule