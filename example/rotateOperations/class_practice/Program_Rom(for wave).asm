#include	<p16Lf1826.inc>;

temp		equ 0x25
count1		equ h'20'
count2		equ h'21'
count3		equ h'22'

;Program start
			org		0x00	;reset vector
			
			clrf	temp	;ram[37]<=0
			clrw			;w<=0
			movlw	1		;w<=1
			movwf	temp	;ram[37]<=0000_0001
			movwf	PORTB
			
loop1		lslf	temp,1	;ramp[37] shift left and save to w
			movf	temp,0
			movwf	PORTB	;
			btfss	temp,7	;
			goto	loop1	;from 0000_0001 to 1000_0000

loop2		lsrf	temp,1	;ram[37] shift right and save to w
			movf	temp,0
			movwf	PORTB
			btfss	temp,0			
			goto	loop2	;from 1000_0000 to 0000_0001
			goto	loop1
			end