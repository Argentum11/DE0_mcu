onerror {resume}
quietly WaveActivateNextPane {} 0

add wave -noupdate -divider {fetch}

add wave -noupdate -format Literal -radix Unsigned 		/testbench/clk
add wave -noupdate -format Literal -radix Unsigned      /testbench/reset
add wave -noupdate -format Literal -radix Unsigned 		/testbench/cpu_test/ROM_1/Rom_addr_in
add wave -noupdate -format Literal -radix Hexadecimal 		/testbench/cpu_test/ROM_1/Rom_data_out
add wave -noupdate -format Literal -radix Hexadecimal 		/testbench/cpu_test/opcode
add wave -noupdate -format Literal -radix Unsigned 		/testbench/cpu_test/ps
add wave -noupdate -format Literal -radix Hexadecimal 		/testbench/cpu_test/w_q