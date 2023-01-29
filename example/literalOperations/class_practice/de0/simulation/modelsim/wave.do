onerror {resume}
quietly WaveActivateNextPane {} 0

#add wave -noupdate -divider {TOP LEVEL INPUTS}

#add wave -noupdate -format Logic /testbench/clk
#add wave -noupdate -format Logic /testbench/rst



add wave -noupdate -divider {adder}

add wave -noupdate -format Literal -radix Unsigned 		/testbench/clk
add wave -noupdate -format Literal -radix Unsigned 	/testbench/cpu_test/ps
add wave -noupdate -format Literal -radix Unsigned 		/testbench/reset
add wave -noupdate -format Literal -radix Hexadecimal 		/testbench/cpu_test/w_q