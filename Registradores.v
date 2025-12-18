module Registradores (
    input [5:0] endereco_leitura1,
    input [5:0] endereco_leitura2, 
    input [5:0] endereco_escrita,
    input clock, 
    input rclock, 
    input writeRegs, 
    input readRegs, 
    input hilo, 
    input OSUsage,
    input [31:0] dados_escrita_32,
    input [63:0] dados_escrita_64,
    input [5:0] ctx_read_addr,
    output [31:0] ctx_read_data,
    input [5:0] ctx_write_addr,
    input [31:0] ctx_write_data,
    input ctx_write_en,
    input ctx_busy,
    output [31:0] leituraRS,
    output [31:0] leituraRT, 
    output [31:0] leituraRD, 
    output [31:0] hi, 
    output [31:0] lo,
    output [3:0] progIndex
);

reg [31:0] regs [63:0];

integer i;
initial begin
    for (i = 0; i < 64; i = i + 1)
        regs[i] = 32'b0;
end

wire [31:0] rd_val, rs_val, rt_val;

always @ (negedge rclock) 
begin
    if (ctx_write_en && ctx_write_addr < 6'd32) begin
        regs[ctx_write_addr] <= ctx_write_data;
    end
    else if (writeRegs && !ctx_busy) 
    begin
        if (hilo) 
        begin
            regs[62] <= dados_escrita_64[31:0];
            regs[63] <= dados_escrita_64[63:32];
        end
        else 
        begin
            if (OSUsage) 
            begin
                if (endereco_escrita < 6'd32) 
                begin
                    regs[endereco_escrita + 6'd32] <= dados_escrita_32;
                end
            end 
            else 
            begin
                if (endereco_escrita < 6'd32) 
                begin
                    regs[endereco_escrita] <= dados_escrita_32;
                end
            end
        end
    end
end

assign ctx_read_data = (ctx_read_addr < 6'd32) ? regs[ctx_read_addr] : 32'b0;

assign rd_val = OSUsage ? 
    ((endereco_escrita < 6'd32) ? regs[endereco_escrita + 6'd32] : 32'b0) : 
    ((endereco_escrita < 6'd32) ? regs[endereco_escrita] : 32'b0);
    
assign rs_val = OSUsage ? 
    ((endereco_leitura1 < 6'd32) ? regs[endereco_leitura1 + 6'd32] : 32'b0) : 
    ((endereco_leitura1 < 6'd32) ? regs[endereco_leitura1] : 32'b0);
    
assign rt_val = OSUsage ? 
    ((endereco_leitura2 < 6'd32) ? regs[endereco_leitura2 + 6'd32] : 32'b0) : 
    ((endereco_leitura2 < 6'd32) ? regs[endereco_leitura2] : 32'b0);

assign progIndex = regs[59][3:0];

assign hi = regs[63];
assign lo = regs[62];

assign leituraRD = rd_val;
assign leituraRS = rs_val;
assign leituraRT = rt_val;

endmodule