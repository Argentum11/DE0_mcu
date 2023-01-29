#include	<p16Lf1826.inc>

temp	equ	0x25

;________Program start
	org	0x00

		clrw
loop	movlw	.0
		movwf	PORTB
		movlw	.0
		movwf	PORTB
		movlw	.9
		movwf	PORTB
		movlw	.5
		movwf	PORTB
		movlw	.7
		movwf	PORTB
		movlw	.0
		movwf	PORTB
		movlw	.5
		movwf	PORTB
		movlw	.0
		movwf	PORTB
		goto	loop

		end
