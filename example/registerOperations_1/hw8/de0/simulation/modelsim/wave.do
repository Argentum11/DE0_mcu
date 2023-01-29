onerror {resume}
quietly WaveActivateNextPane {} 0

add wave -noupdate -divider {1114}

add wave -noupdate -format Literal -radix decimal 		/testbench/cpu_test/clk
add wave -noupdate -format Literal -radix decimal 	    /testbench/cpu_test/reset
add wave -noupdate -format Literal -radix decimal       /testbench/cpu_test/w_q
add wave -noupdate -format Literal -radix Unsigned       /testbench/cpu_test/ram_out