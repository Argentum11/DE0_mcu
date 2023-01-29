onerror {resume}
quietly WaveActivateNextPane {} 0


add wave -noupdate -divider {1114}

add wave -noupdate -format Literal -radix decimal 		/testbench/cpu_test/clk
add wave -noupdate -format Literal -radix decimal 	    /testbench/cpu_test/reset
add wave -noupdate -format Literal -radix decimal       /testbench/cpu_test/w_q
add wave -noupdate -format Literal -radix decimal       /testbench/cpu_test/ns
add wave -noupdate -format Literal -radix decimal       /testbench/cpu_test/ram_out
add wave -noupdate -format Literal -radix decimal       /testbench/cpu_test/ADDWF
add wave -noupdate -format Literal -radix decimal       /testbench/cpu_test/ANDWF
add wave -noupdate -format Literal -radix decimal       /testbench/cpu_test/CLRF
add wave -noupdate -format Literal -radix decimal       /testbench/cpu_test/CLRW
add wave -noupdate -format Literal -radix decimal       /testbench/cpu_test/COMF
add wave -noupdate -format Literal -radix decimal       /testbench/cpu_test/DECF
add wave -noupdate -format Literal -radix decimal       /testbench/cpu_test/GOTO