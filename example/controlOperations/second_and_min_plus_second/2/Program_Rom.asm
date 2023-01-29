#include	<p16Lf1826.inc>;

temp		equ 0x25
temp1		equ 0x24
temp2		equ 0x23
count1		equ h'20'
count2		equ h'21'
second		equ 0x22
minute		equ 0x21

;Program start
			org		0x00	;reset vector
start1		movlw	.60		; w = 15
			movwf	temp2	;
			clrf	minute	;
			
start2		movlw	.59		; w = 15
			movwf	temp1	; ram[36] = w = 15
			clrf	second	; ram[37] <= 0
			clrw			; w <= 0
loop1		movf	temp,0	; w = ram[37] = 1
			movwf	PORTB	; PORTB = w = 1
			movlw	1		; w <= 1
			addwf	second,1; ram[37] = w+ram[37] = 1+0 = 1
			decfsz	temp1,1 ; if(ram[36]-1==0) -> bra start
			goto loop1
			addwf	minute,1;
			decfsz	temp2,1 ;
			goto start2
			goto start1
			end