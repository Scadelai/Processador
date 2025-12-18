module SO_Control (
    input clock,
    input reset,
    input halt,
    input timer_irq,
    input user_mode,
    input clear_irq,
    input reti,
    input ctx_busy,
    output reg OSUsage,
    output reg clear
);

initial begin
    OSUsage = 1'b1;
    clear = 1'b1;
end

always @ (posedge clock) begin
    if (reset) begin
        OSUsage <= 1'b1;
        clear <= 1'b1;
    end else begin
        clear <= 1'b0;
        if (user_mode || reti) begin
            OSUsage <= 1'b0;
        end else if (((timer_irq && !clear_irq) || halt) && !ctx_busy) begin
            OSUsage <= 1'b1;
        end
    end
end

endmodule