module ContextSwitcher (
    input clock,
    input reset,
    input save_trigger,
    input restore_trigger,
    input [3:0] progIndex,
    input [11:0] current_PC,
    output reg [5:0] reg_addr,
    output reg reg_write,
    output reg [31:0] reg_data_out,
    input [31:0] reg_data_in,
    output reg [11:0] ram_addr,
    output reg ram_write,
    output reg [31:0] ram_data_out,
    input [31:0] ram_data_in,
    output reg [11:0] restored_PC,
    output reg restore_PC_valid,
    output reg ram_active,
    output wire busy
);

reg [5:0] counter;
reg saving;
reg is_save_op;
reg op_done;

assign busy = ((save_trigger || restore_trigger) && !op_done) || saving;

wire [11:0] prog_base_addr = {progIndex + 4'd1, 8'b0};

initial begin
    counter = 0;
    saving = 0;
    is_save_op = 0;
    op_done = 0;
    reg_addr = 0;
    reg_write = 0;
    reg_data_out = 0;
    ram_addr = 0;
    ram_write = 0;
    ram_data_out = 0;
    restored_PC = 0;
    restore_PC_valid = 0;
    ram_active = 0;
end

always @(posedge clock) begin
    if (reset) begin
        counter <= 0;
        saving <= 0;
        is_save_op <= 0;
        op_done <= 0;
        reg_addr <= 0;
        reg_write <= 0;
        reg_data_out <= 0;
        ram_addr <= 0;
        ram_write <= 0;
        ram_data_out <= 0;
        restored_PC <= 0;
        restore_PC_valid <= 0;
    end else if (saving) begin
        reg_write <= 0;
        ram_write <= 0;
        restore_PC_valid <= 0;
        ram_active <= 1;
        
        if (is_save_op) begin
            if (counter == 0) begin
                ram_addr <= prog_base_addr;
                ram_data_out <= {20'b0, current_PC};
                ram_write <= 1;
                reg_addr <= 0;
                counter <= 1;
            end else if (counter <= 32) begin
                ram_addr <= prog_base_addr + {5'b0, counter};
                ram_data_out <= reg_data_in;
                ram_write <= 1;

                if (counter < 32) begin
                    reg_addr <= counter[5:0];
                end
                counter <= counter + 1;
            end else begin
                saving <= 0;
                op_done <= 1;
                ram_active <= 0;
            end
            
        end else begin
            if (counter == 0) begin
                ram_addr <= prog_base_addr;
                counter <= 1;
            end else if (counter == 1) begin
                restored_PC <= ram_data_in[11:0];
                restore_PC_valid <= 1;
                ram_addr <= prog_base_addr + 1;
                counter <= 2;
            end else if (counter <= 33) begin
                reg_addr <= counter - 2;
                reg_data_out <= ram_data_in;
                reg_write <= 1;

                if (counter < 33) begin
                    ram_addr <= prog_base_addr + {5'b0, counter[5:0]};
                end
                counter <= counter + 1;
            end else begin
                saving <= 0;
                op_done <= 1;
                ram_active <= 0;
            end
        end
        
    end else if (save_trigger && !op_done) begin
        saving <= 1;
        is_save_op <= 1;
        counter <= 0;
        ram_active <= 0;
        
    end else if (restore_trigger && !op_done) begin
        saving <= 1;
        is_save_op <= 0;
        counter <= 0;
        ram_active <= 0;
        
    end else if (!save_trigger && !restore_trigger) begin
        op_done <= 0;
        restore_PC_valid <= 0;
    end else if (restore_trigger && op_done && is_save_op) begin
        saving <= 1;
        is_save_op <= 0;
        counter <= 0;
        op_done <= 0;
    end else if (save_trigger && op_done && !is_save_op) begin
        saving <= 1;
        is_save_op <= 1;
        counter <= 0;
        op_done <= 0;
    end
end

endmodule
