module ProgramCounter(
  input clk,
  input reset,
  input enable,
  input halt,
  input button,               
  input jump,
  input branch,
  input out1ULA,
  input [11:0] addr,
  input timer_irq,
  input reti,
  input loading,
  input ctx_busy,
  input ctx_restore_valid,
  input [11:0] ctx_restored_PC,
  output reg clear_timer_irq,
  output reg [11:0] JalAddress,
  output reg [11:0] pc,
  output reg [11:0] EPC
);
  integer first_clk = 1;
  reg in_isr;
  reg prev_en;
  reg prev_ctx;
  reg prev_irq;
  reg prev_ret;
  reg [11:0] prev_pc;
  reg prev_ld;
  reg prev_hlt;
  reg prev_btn;
  reg prev_jmp;
  reg prev_br;
  reg prev_ula;
  
  always @(posedge clk)
  begin
    if (first_clk == 1)
    begin
      pc <= 12'b0;
      EPC <= 12'b0;
      in_isr <= 1'b0;
      clear_timer_irq <= 1'b0;
      prev_en <= 1'bx;
      prev_ctx <= 1'bx;
      prev_irq <= 1'bx;
      prev_ret <= 1'bx;
      prev_pc <= 12'bx;
      prev_ld <= 1'bx;
      prev_hlt <= 1'bx;
      prev_btn <= 1'bx;
      prev_jmp <= 1'bx;
      prev_br <= 1'bx;
      prev_ula <= 1'bx;
      first_clk <= 2;
    end
    else if (reset)
    begin
      pc <= 12'b0;
      EPC <= 12'b0;
      in_isr <= 1'b0;
      clear_timer_irq <= 1'b0;
    end
    else
    begin
      clear_timer_irq <= 1'b0;
      
      if (timer_irq && !in_isr && !clear_timer_irq && !halt && !enable && !ctx_busy)
      begin
        EPC <= pc + 1;
        pc <= 12'd83;
        in_isr <= 1'b1;
      end
      
      else if (ctx_restore_valid)
      begin
        EPC <= ctx_restored_PC;
        in_isr <= 1'b1;
        clear_timer_irq <= 1'b1;
      end
      
      else if (reti && in_isr)
      begin
        pc <= EPC;
        in_isr <= 1'b0;
        clear_timer_irq <= 1'b1;
      end
      
      else if (halt)
      begin
        pc <= 12'd157;
      end
      
      else if (enable && !button)
      begin
        pc <= pc;
      end
      
      else if (jump)
      begin
        JalAddress <= pc + 1;
        pc <= addr;
        if (in_isr && addr >= 12'd512) begin
          in_isr <= 1'b0;
          clear_timer_irq <= 1'b1;
        end
      end
      
      else if (branch && out1ULA)
      begin
        pc <= addr;
      end

      else if (ctx_busy)
      begin
        pc <= pc;
      end
      
      else if (loading)
      begin
        pc <= pc;
      end
      
      else begin
        pc <= pc + 1;
      end

      prev_en <= enable;
      prev_ctx <= ctx_busy;
      prev_irq <= timer_irq;
      prev_ret <= reti;
      prev_pc <= pc;
      prev_ld <= loading;
      prev_hlt <= halt;
      prev_btn <= button;
      prev_jmp <= jump;
      prev_br <= branch;
      prev_ula <= out1ULA;
    end
  end
endmodule