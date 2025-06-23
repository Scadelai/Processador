module regs (write_adr, read_adr1, read_adr2, clock, writeRegs, write_data32, write_data64, readRD, readRS, readRT, hilo, hi, lo);
input [5:0] read_adr1;
input [5:0] read_adr2;
input [5:0] write_adr; //enderecos de leitura e escrita
input clock, writeRegs, hilo; //clock e flags de escrita
input [63:0] write_data64; //dados de escrita 64bit
input [31:0] write_data32; //dados de escrita 32bit
output [31:0] readRS; //leitura do registrador source
output [31:0] readRD; //leitura do registrador destination
output [31:0] readRT; //leitura do registrador target
output [31:0] hi;
output [31:0] lo;
reg[31:0] regs [63:0]; // registradores

always @ (posedge clock) 
begin
    if (writeRegs) 
    begin
        if(hilo)
        begin
            regs[3] = write_data64[31:0];
            regs[4] = write_data64[63:32];
        end
        else
        begin
            regs[write_adr] = write_data32;
        end
    end
end

assign hi = regs[4];
assign lo = regs[3];
assign readRD = regs[write_adr];
assign readRS = regs[read_adr1];
assign readRT = regs[read_adr2];

endmodule