module ULA (
    input  [3:0]  controle,
    input  [31:0] in1,   
    input  [31:0] in2,
    input  [31:0] in3,
    output [31:0] out_32,
    output [63:0] out_64,
    output reg    out1,
    output reg    sign_hilo
);

reg [31:0] res32;
reg [63:0] res64;

always @(*) begin
    sign_hilo = 1'b0;
    case (controle)
        4'b0000: begin
            res32 = in1 + in2;
            res64 = 64'd0;
            out1  = 1'b0;
        end

        4'b0001: begin
            res32 = in1 - in2;
            res64 = 64'd0;
            out1  = 1'b0;
        end

        4'b0010: begin
            res32 = in1 * in2;
            res64 = 64'd0;
            out1  = 1'b0;
        end

        4'b0011: begin
            res32 = (in2 != 0) ? (in1 / in2) : 32'd0;
            res64 = 64'd0;
            out1  = 1'b0; 
        end

        4'b0100: begin
            res32 = in1 & in2;
            res64 = 64'd0;
            out1  = 1'b0;
        end

        4'b0101: begin
            res32 = in1 | in2;
            res64 = 64'd0;
            out1  = 1'b0;
        end

        4'b0110: begin
            res32 = (in1 < in2) ? 32'd1 : 32'd0;
            res64 = 64'd0;
            out1  = (in1 < in2);
        end

        4'b0111: begin
            res32 = (in1 > in2) ? 32'd1 : 32'd0;
            res64 = 64'd0;
            out1  = (in1 > in2);
        end

        4'b1000: begin
            res32 = (in1 == in2) ? 32'd1 : 32'd0;
            res64 = 64'd0;
            out1  = (in1 == in2);
        end

        4'b1001: begin
            res32 = (in1 <= in2) ? 32'd1 : 32'd0;
            res64 = 64'd0;
            out1  = (in1 <= in2);
        end

        4'b1010: begin
            res32 = (in1 >= in2) ? 32'd1 : 32'd0;
            res64 = 64'd0;
            out1  = (in1 >= in2);
        end

        4'b1011: begin
            res32 = in1 << in2[4:0];
            res64 = 64'd0;
            out1  = 1'b0;
        end

        4'b1100: begin
            res32 = in1 >> in2[4:0];
            res64 = 64'd0;
            out1  = 1'b0;
        end

        4'b1101: begin
            res32 = (in1 != in2) ? 32'd1 : 32'd0;
            res64 = 64'd0;
            out1  = (in1 != in2);
        end

        default: begin
            res32 = 32'd0;
            res64 = 64'd0;
            out1  = 1'b0;
        end
    endcase
end

assign out_32 = res32;
assign out_64 = res64;

endmodule
