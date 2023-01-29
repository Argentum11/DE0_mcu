onerror {resume}
quietly WaveActivateNextPane {} 0

add wave -noupdate -divider {0 to 59}

add wave -noupdate -format Literal -radix Unsigned 		/testbench/clk
add wave -noupdate -format Literal -radix decimal 	    /testbench/reset
add wave -noupdate -format Literal -radix Hexadecimal 	    /testbench/port_b_out
add wave -noupdate -format Literal -radix Binary   /testbench/cpu_test/seg0
add wave -noupdate -format Literal -radix Binary   /testbench/cpu_test/seg1