module testbench;

	logic clk,reset;
	logic [7:0] w_q;

	cpu cpu_test(
		.clk(clk),
		.reset(reset),
		.w_q(w_q)
	);

	always #10 clk = ~clk;
	initial begin
		clk = 0; reset = 1;
		#20 reset = 0;
		#1300 $stop;
	end
endmodule