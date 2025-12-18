// Debounce Module for Button Input (active-high button)
// Filters mechanical switch bounce to produce clean signal transitions.
// Uses a counter-based approach: state changes only after stable for COUNTER_MAX cycles.
// Generates a single pulse of fixed length (2 clock cycles) on the debounced rising edge.

module Debounce(
    input clk,           // System clock
    input button_in,     // Raw button input (active HIGH: 1 = pressed)
    output reg button_out, // Debounced output (reflects stable button state)
    output reg button_pulse // Pulse asserted for 2 cycles on debounced rising edge
);
    // Synchronization registers (prevent metastability)
    reg button_sync0, button_sync1;

    always @(posedge clk) begin
        button_sync0 <= button_in;
        button_sync1 <= button_sync0;
    end

    reg [26:0] counter;  // Smaller for faster simulation
    localparam [26:0] COUNTER_MAX = 27'd1; // testing
    // localparam [26:0] COUNTER_MAX = 27'd500;

    // Pulse length counter (counts down, pulse asserted while >0)
    reg [2:0] pulse_counter;

    // Initialize outputs and counters
    initial begin
        button_out = 1'b0;  // Default: not pressed
        counter = 0;
        button_pulse = 1'b0;
        pulse_counter = 3'd0;
    end

    // Debounce and pulse-generation logic
    always @(posedge clk) begin
        // Debounce: wait until sync input is stable for COUNTER_MAX cycles
        if (button_out == button_sync1) begin
            // State is stable, reset counter
            counter <= 0;
        end else begin
            // State changed, increment counter
            counter <= counter + 1;
            // If counter reaches threshold, update debounced output
            if (counter >= COUNTER_MAX) begin
                // Detect rising edge: new sync is 1 and old debounced output was 0
                if ((button_sync1 == 1'b1) && (button_out == 1'b0)) begin
                    // Start a 4-cycle pulse (value 4 -> four clock cycles)
                    pulse_counter <= 3'd4;
                end
                button_out <= button_sync1;
                counter <= 0;
            end
        end

        // Pulse counter: while >0 assert `button_pulse` and decrement
        if (pulse_counter != 2'd0) begin
            button_pulse <= 1'b1;
            pulse_counter <= pulse_counter - 1;
        end else begin
            button_pulse <= 1'b0;
        end
    end
endmodule
