module DivFreq
// #(parameter FREQ = 500000) // 5000000
#(parameter FREQ = 1) // testing
(
    input clock,
    output reg clock_div
);

reg [26:0] counter;

// `ifdef SIMULATION
//     localparam MAX_COUNT = 1; // Fast clock for simulation
// `else
    localparam MAX_COUNT = FREQ;
// `endif

initial begin
    counter = 0;
    clock_div = 0;
end

always @(posedge clock) 
begin
    if (counter >= MAX_COUNT) 
	 begin
        counter <= 27'd0;
        clock_div <= ~clock_div;
        // $display("DivFreq: clock_div toggled to %b at time %t", ~clock_div, $time);
    end
    else 
	 begin
        counter <= counter + 27'd1;
    end
end

endmodule