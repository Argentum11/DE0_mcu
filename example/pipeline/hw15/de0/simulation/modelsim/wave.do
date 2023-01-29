onerror {resume}
quietly WaveActivateNextPane {} 0

add wave -noupdate -divider {pipeline test 1}

add wave -noupdate -format Literal -radix Unsigned 		/testbench/clk
add wave -noupdate -format Logic -radix decimal 	    /testbench/reset
add wave -noupdate -format Literal -radix Unsigned   /testbench/cpu_test/w_q
add wave -noupdate -format Literal -radix Unsigned   /testbench/cpu_test/single_port_ram_128x8_1/ram\[37\]
