#include	<p16Lf1826.inc>

a		equ 0x25
c		equ 0x24
answer	equ 0x23
count	equ 0x22

;________Program start
		org	0x00
		
		movlw	.5	; int a=5
		movwf	a

		movlw	.3	; int c=3
		movwf	c
		
		; int count=c
		movf	c,0		; move c to w
		movwf	count	; move w to count

		; int answer = 0
		clrw			; w=0
		movwf	answer	; answer=w

loop	movf	a,0			; w=a
		addwf	answer,1	; answer= answer+w
		decfsz	count
		goto	loop
		
		movf	answer,0	; w=answer
		movwf	PORTB
		end
