onerror {resume}
quietly WaveActivateNextPane {} 0

add wave -noupdate -divider {1128}

add wave -noupdate -format Literal -radix decimal 		/testbench/cpu_test/clk
add wave -noupdate -format Literal -radix decimal 	    /testbench/cpu_test/reset
add wave -noupdate -format Literal -radix Hexadecimal       /testbench/cpu_test/w_q
add wave -noupdate -format Literal -radix Hexadecimal       /testbench/cpu_test/single_port_ram_128x8_1/ram\[37\]
add wave -noupdate -format Literal -radix Hexadecimal       /testbench/cpu_test/single_port_ram_128x8_1/ram\[36\]