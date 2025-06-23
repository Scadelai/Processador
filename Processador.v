module Processador(control, in1, in2, in3, out_32, out_64, sign_hilo);
input [31:0] in1;   
input [31:0] in2;
input [31:0] in3;
input [3:0] control;
output [31:0] out_32;
output [63:0] out_64;
output reg sign_hilo;
reg [31:0] result_32;
reg [63:0] result_64;
reg [63:0] hilo;
always @(in1 or in2 or control)
begin
sign_hilo = 1'b0;
  case(control)
   4'b0000://soma
		begin
		result_32 = in1 + in2;
		result_64 = 64'd0;
		end
	
	4'b0001://subtração
		begin
		result_32 = in1 - in2;
		result_64 = 64'd0;
		end
		
	4'b0010://multiplicação
		begin
		hilo = in1 * in2;
		result_64[63:32] = hilo[63:32];
		result_64[31:0] = hilo[31:0];
		sign_hilo = 1;
		end

	4'b0011://divisão
		begin
		hilo = in1 / in2;
		result_64[63:32] = hilo;
		result_64[31:0] = in1 % in2;
		sign_hilo = 1;
		end

	4'b0100://and
		begin
		result_32 = in1 & in2;
		result_64 = 64'd0;
		end
	
	4'b0101://or
		begin
		result_32 = in1 | in2;
		result_64 = 64'd0;
		end

	4'b0110://less than
		begin
		result_32 = in1 < in2;
		result_64 = 64'd0;
		end

	4'b0111://greater than
		begin
		result_32 = in1 > in2;
		result_64 = 64'd0;
		end

	4'b1000:// if equal
		begin
		result_32 = in1 == in2;
		result_64 = 64'd0;
		end

	4'b1001:// less or equal
		begin
		result_32 = in1 <= in2;
		result_64 = 64'd0;
		end

	4'b1010://more or equal
		begin
		result_32 = in1 >= in2;
		result_64 = 64'd0;
		end

   default:
		begin
		result_32 = 32'd0;
		result_64 = 64'd0;
		end

  endcase
end

assign out_32 = result_32;
assign out_64 = result_64;
endmodule