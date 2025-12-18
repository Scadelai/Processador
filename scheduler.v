module scheduler(
    input clock,
    input progIndexToSet[3:0],  // RS of the program to set as runnable
    input set_prog,             // Signal to set which program can run
    input halt,                 // Signal to remove program from scheduling
    output reg [3:0] progIndex  // Current running program index
);

reg runnable_programs [9:0]; // Bitmask of runnable programs

initial begin
    progIndex = 4'b0000;
    integer i;
    for (i = 0; i < 10; i = i + 1) begin
        runnable_programs[i] = 1'b0;
    end
end




endmodule