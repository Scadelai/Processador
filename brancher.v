module brancher(
    input [11:0] in,
    input jump,
  input jumpReg,
    input branch,
    input out1ULA,
    input clk,
    input OSUsage,          // OS mode indicator (1=OS, 0=User)
    input [11:0] pc,        // Current PC for branch calculation
    output reg [11:0] address
    );

// User programs start at ROM address 512, so we need to add offset
// Compiler generates absolute addresses for jumps, relative for branches
// For jumps: target_rom = (program_line + 512)
// For branches: imm is relative to current PC, which is ALREADY in user space (512+)
//   So: target = pc + imm (NO additional 512 offset needed)
wire in_user_space = OSUsage ? 1'b0 : 1'b1; // If in OS mode, not in user space
wire [11:0] adjusted_jump = in_user_space ? (in + 12'd512) : in;
wire [11:0] adjusted_branch = in_user_space ? (in + 12'd512) : in;
always @ (*)
begin
  if(jump) begin
    // If this is a jump-register (JR), the value in the register
    // is already an absolute ROM address (no +512 offset), so use it
    // directly. For normal jumps (immediate), keep existing behavior
    // of adding user-space offset and +1.
    if (jumpReg)
      address = in;
    else
      address = adjusted_jump;
  end
    else if(branch && out1ULA) begin
      $display("Branch taken to addr %d", adjusted_branch);
      address = adjusted_branch;  // Use pc + offset, then add 512 if user mode
    end
	else
		address = 12'b0; // Fixed width to match output
end

endmodule