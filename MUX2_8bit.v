module MUX2_8bit(
  input [7:0] A, B,
  input S,
  output reg [7:0] X
);

  always @(A or B or S)
  begin
    case (S)
      1'b0: X = A;
      1'b1: X = B;
    endcase
  end

endmodule
