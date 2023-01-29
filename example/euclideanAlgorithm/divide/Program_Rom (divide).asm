#include	<p16Lf1826.inc>

a		equ 0x25
c		equ 0x24
answer	equ 0x23	; ram[35]
count	equ 0x22	; ram[34]
temp	equ 0x21
mod 	equ 0x20

;________Program start_________
		org	0x00
		; int count = 0
		clrw			; w = 0
		movwf	count
		
		movlw	.21	; int a = 21
		movwf	a

		movlw	.3	; int c=3
		movwf	c
		
		; int temp = 0
		clrw
		movwf	temp

loop	movf	c,0		; w = c
		subwf	a,1		; a = a - w

		incf	count,1	; count++

		btfss	a,7		; if(a<0) break;
		goto loop

		decf	count,1	; count--

		; answer = a / c
		movf	count,0	; w = count
		movwf	answer	; answer = w

		; cout << count
		movf	count,0	; w = count 
		movwf	PORTB	; port_b = w

		; temp = 0 - a
		movf	a,0		; w = a
		sublw	0		; w = 0 - w
		movwf 	temp

		; mod = c - temp
		movf	temp,0	; w = temp
		subwf	c,0		; w = c - w
		movwf	PORTB	; port_b = w
		end
