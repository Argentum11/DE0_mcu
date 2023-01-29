module testbench;

	logic clk,reset;
	logic [13:0] ir_out;
 
	cpu cpu_test(
		.clk(clk),
		.reset(reset),
		.IR(ir_out)
	);

	always #10 clk = ~clk;
	initial begin
		clk = 0; reset = 1;
		#20 reset = 0;
		#1000 $stop;
	end
endmodule