module Timer (
    input wire clock,
    input wire reset,
    input wire [5:0] opcode,
    input wire [31:0] rs_value,
    input wire clear_irq,
    input wire enable,
    output wire irq_out,
    output wire [31:0] counter_out
);

reg [31:0] quantum;
reg enabled;
reg [31:0] cnt;
reg irq_flag;
reg prev_cnt_en;

always @(posedge clock or posedge reset) begin
    if (reset) begin
        quantum <= 32'd100;
        enabled <= 1'b0;
    end
    else begin
        case (opcode)
            6'b100100: begin
                if (rs_value > 10) begin
                    quantum <= rs_value;
                end
            end
            6'b100101: begin
                enabled <= 1'b1;
            end
            6'b100110: begin
                enabled <= 1'b0;
            end
            default: begin
            end
        endcase
    end
end

always @(posedge clock or posedge reset) begin
    if (reset) begin
        cnt <= 32'b0;
        irq_flag <= 1'b0;
    end
    else if (clear_irq) begin
        irq_flag <= 1'b0;
        cnt <= 32'b0;
        prev_cnt_en <= 1'b0;
    end
    else if (enabled && !irq_flag && enable) begin
        if (!prev_cnt_en) begin
            prev_cnt_en <= 1'b1;
        end
        if (cnt >= quantum - 1) begin
            cnt <= 32'b0;
            irq_flag <= 1'b1;
        end
        else begin
            cnt <= cnt + 1;
        end
    end
    else begin
        prev_cnt_en <= 1'b0;
    end
end

assign irq_out = irq_flag;
assign counter_out = cnt;

endmodule
