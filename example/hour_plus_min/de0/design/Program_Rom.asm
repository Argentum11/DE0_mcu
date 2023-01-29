#include	<p16Lf1826.inc>

temp1		equ	0x24	; 36
temp2		equ 0x23	; 35
minute		equ 0x22	; 34
hour		equ 0x21	; 33

;________Program start
		org	0x00
	
start1		movlw	.24
			movwf temp2
			clrf hour

start2		movlw	.59
			movwf	temp1
			clrf	minute
			clrw
loop		movlw .1
			addwf	minute,1
			decfsz temp1,1
			bra loop
			addwf	hour,1
			decfsz	temp2,1
			bra		start2
			bra		start1
			end