#include	<p16Lf1826.inc>;

temp		equ 0x25
temp1		equ 0x24
count1		equ h'20'
count2		equ h'21'
count3		equ h'22'

;Program start
			org		0x00	;reset vector
			
start		movlw	.15		; w = 15
			movwf	temp1	; ram[36] = w = 15
			clrf	temp	; ram[37] <= 0
			clrw			; w <= 1
loop1		movlw	1		; w <= 1
			addwf	temp,1	; ram[37] = w+ram[37] = 1+0 = 1
			movf	temp,0	; w = ram[37] = 1
			movwf	PORTB	; PORTB = w = 1
			call	delay
			decfsz	temp1,1 ; if(ram[36]-1==0) -> line 23
			goto loop1
			movlw	.15		; w = 15
			movwf	temp1	; ram[36] = w = 15
loop2		movlw	1		; w = 1
			subwf	temp,1	; ram[37]-=w => 0
			movf	temp,0	; w = ram[37] = 0
			movwf	PORTB	; PORTB=w=0
			call	delay
			decfsz	temp1,1 ; if(ram[36]-1==0)
			goto	loop2
			goto	start

delay		movlw	.30
			return

			end