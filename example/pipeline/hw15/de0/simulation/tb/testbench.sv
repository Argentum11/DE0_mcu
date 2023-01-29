module testbench;

	logic clk,reset;
	logic [7:0] port_b_out;

	cpu cpu_test(
		.clk(clk),
		.reset(reset),
		.port_b_out(port_b_out)
	);

	always #10 clk = ~clk;
	initial begin
		clk = 0; reset = 1;
		#20 reset = 0;
		#2000 $stop;
	end
endmodule