module RAMOffset (
    input OSUsage,
    input [3:0] progIndex,
    input [11:0] local_addr,
    output reg [11:0] actual_addr
);

reg [11:0] protected_addr;
always @(*) begin
    if (local_addr[11:8] != 4'b0000) begin
        protected_addr = {4'b0, local_addr[7:0]};
    end else begin
        protected_addr = local_addr;
    end
end

always @(*) begin
    if (OSUsage) begin
        actual_addr = local_addr;
    end else begin
        case (progIndex)
            4'd0: actual_addr <= protected_addr + 12'd256;   // 0x100
            4'd1: actual_addr <= protected_addr + 12'd512;   // 0x200
            4'd2: actual_addr <= protected_addr + 12'd768;   // 0x300
            4'd3: actual_addr <= protected_addr + 12'd1024;  // 0x400
            4'd4: actual_addr <= protected_addr + 12'd1280;  // 0x500
            4'd5: actual_addr <= protected_addr + 12'd1536;  // 0x600
            4'd6: actual_addr <= protected_addr + 12'd1792;  // 0x700
            4'd7: actual_addr <= protected_addr + 12'd2048;  // 0x800
            4'd8: actual_addr <= protected_addr + 12'd2304;  // 0x900
            4'd9: actual_addr <= protected_addr + 12'd2560;  // 0xA00
            default: actual_addr <= 12'd33;
        endcase
    end
end
endmodule