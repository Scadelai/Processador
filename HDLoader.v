module HDLoader (
    input clock,
    input reset,
    input [3:0] progIndex,
    input loadFlag,
    output reg [11:0] HDReadAddr,
    output reg [9:0] ROMWriteAddr,
    output reg loadinginternal,
    output wire loading,
    output wire writeEnable
);

    reg loaddone;
    reg [1:0] flaglowcnt;
    reg first_read;
    
    assign loading = (loadFlag && !loaddone) || loadinginternal;
    assign writeEnable = loadinginternal && !first_read;

    initial begin
        HDReadAddr = 12'b0;
        ROMWriteAddr = 10'b0;
        loadinginternal = 1'b0;
        loaddone = 1'b0;
        flaglowcnt = 2'b0;
        first_read = 1'b0;
    end

    always @(posedge clock) begin
        if (reset) begin
            HDReadAddr <= 12'b0;
            ROMWriteAddr <= 10'b0;
            loadinginternal <= 1'b0;
            loaddone <= 1'b0;
            flaglowcnt <= 2'b0;
            first_read <= 1'b0;
        end
        else if (loadinginternal) begin
            if (first_read) begin
                first_read <= 1'b0;
            end
            else if (ROMWriteAddr < 10'd812) begin
                HDReadAddr <= HDReadAddr + 12'b1;
                ROMWriteAddr <= ROMWriteAddr + 10'b1;
            end
            else begin
                loadinginternal <= 1'b0;
                loaddone <= 1'b1;
                flaglowcnt <= 2'b0;
            end
        end
        else if (loadFlag && !loaddone) begin
            loadinginternal <= 1'b1;
            HDReadAddr <= progIndex * 12'd300;
            ROMWriteAddr <= 10'd512;
            first_read <= 1'b1;
            flaglowcnt <= 2'b0;
        end
        else if (!loadFlag) begin
            if (flaglowcnt < 2'd2) begin
                flaglowcnt <= flaglowcnt + 1'b1;
            end
            else begin
                loaddone <= 1'b0;
            end
        end
        else begin
            flaglowcnt <= 2'b0;
        end
    end

endmodule
