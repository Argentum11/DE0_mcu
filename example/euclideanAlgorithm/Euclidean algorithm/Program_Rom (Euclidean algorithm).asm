#include	<p16Lf1826.inc>
aTwo	equ 0x26	; ram[38]
a		equ 0x25	; ram[37]
c		equ 0x24	; ram[36]
answer	equ 0x23	; ram[35]
count	equ 0x22	; ram[34]
temp	equ 0x21	; ram[33]
mod 	equ 0x20	; ram[32]
cmOne	equ 0x19	; ram[31]

;________Program start_________
		org	0x00
		
		movlw	.36	; int a = 36
		movwf	a

		movlw	.21	; int c = 21
		movwf	c

		; int count = 0
loop1	clrw			; w = 0
		movwf	count
		
		; aTwo = a
		movf	a,0 	; w = a
		movwf	aTwo	; aTwo = w

; loop for calculating mod
loop2	movf	c,0		; w = c
		subwf	aTwo,1	; aTwo = aTwo - w

		incf	count,1	; count++

		btfss	aTwo,7	; if(aTwo<0) break;
		goto loop2
		
		; temp = a % c = aTwo + c
		movf	aTwo,0	; w = aTwo
		movwf	temp	; temp = w
		
		movf	c,0		; w = c
		addwf	temp,1	; temp = temp + w		

		; a = c
		movf	c,0	; w = c
		movwf	a		; a = w

		; c = temp
		movf	temp,0	; w = temp
		movwf	c		; c = w

		; if (c<0) break
		btfss	c,7		; skip if less than 0
		goto check
		goto final

check	movf	c,0		; w = c
		movwf	cmOne	; cmOne = w
		decf	cmOne,1
		btfss	cmOne,7	; skip if equal 0
		goto loop1

final	movf	a,0		; w = a
		movwf	answer	; answer = a
		end
