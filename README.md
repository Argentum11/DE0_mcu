# Environment
- chip : PIC16LF1826
- assembly editor : MPLAB v8.92
- project program : Quartus || Web Edition 13.1
- simulation : ModelSim ALTERA STARTER EDITION 10.1d
# PIC16F1826 Instruction set
|instruction|description|save to||signal|
|---|---|---|---|---|
|Literal Operations||||number = kkkk kkkk|
|MOVLW|move a number to w|||11 0000 kkkk kkkk|
|ADDLW| kkkk_kkkk + w|w||11 1110 kkkk kkkk|
|IORLW| kkkk_kkkk \| w|w||11 1000 kkkk kkkk|
|ANDLW| kkkk_kkkk & w|w||11 1001 kkkk kkkk|
|SUBLW| kkkk_kkkk - w|w||11 1100 kkkk kkkk|
|XORLW| kkkk_kkkk ^ w (XOR)|w||11 1010 kkkk kkkk|
||||| . |
|Register Operations||d=ir_out[7]|||
|ADDWF|w + fff_ffff (register file address 0x00~0x7f)|d==0|w|00 0111 dfff ffff|
|||d==1|register||
|ANDWF|w & fff_ffff|d==0|w|00 0101 dfff ffff|
|||d==1|register||
|CLRF|clear fff_ffff to 0|register||00 0001 1fff ffff|
|CLRW|clear w to 0|w||00 0001 0000 00xx (x:Don't care)|
|COMF|not fff_ffff|d==0|w|00 1001 dfff ffff|
|||d==1|register||
|DECF|fff_ffff - 1|d==0|w|00 0011 dfff ffff|
|||d==1|register||
|INCF|fff_ffff + 1|d==0|w|00 1010 dfff ffff|
|||d==1|register||
|IORWF|w \| fff_ffff|d==0|w|00 0100 dfff ffff|
|||d==1|register||
|MOVF|move fff_ffff to|d==0|w|00 1000 dfff ffff|
|||d==1|register||
|SUBWF| fff_ffff - w | d==0 | w | 00 0010 dfff ffff |
|||d==1|register||
|XORWF| fff_ffff ^ w | d==0 | w | 00 0110 dfff ffff |
|||d==1|register||
|||addr_port_b = (ir_out[6:0]==7'h0d) |||
|MOVWF| move w to | addr_port_b == 0 | register | 00 0000 1fff ffff |
||| addr_port_b == 1 | port_b | |
| | | sel_bit=ir_out[9:7] |||
|BCF| bit clear f (set sel_bit to 0) | register ||  01 00bb bfff ffff |
|BSF| bit set f (set sel_bit to 1) | register || 01 01bb bfff ffff |
| | | | | . |
|Skip Operations|||||
|BTFSC| bit Test f, Skip if Clear (sel_bit==0) ||| 01 10bb bfff ffff |
|BTFSS| bit Test f, Skip if Set (sel_bit==1) ||| 01 11bb bfff ffff |
|DECFSZ| Decrement f, Skip if 0 ||| 00 1011 dfff ffff |
|INCFSZ| Increment f, Skip if 0 ||| 00 1111 dfff ffff |
|PORTBCSZ| skip 2 instructions if((port_b_out & port_c_out) == 0)| | | 00 0000 0000 0011 |
|INCFEQCSZ| Increment register(ir_out[7:0]), Skip if it equals port_c_out | | | 11 0100 kkkk kkkk |
| | | | | . |
|Rotate Operations|||||
|ASRF| remain sign bit and right shift fff_ffff | d==0 | w |  11 0111 dfff ffff |
|| =>{ mux1_out[7],mux1_out[7:1] }| d==1 | register ||
|LSLF| left shift fff_ffff |  d==0 | w | 11 0101 dfff ffff |
|| =>{ mux1_out[6:0], 1'b0 } | d==1 | register ||
|LSRF| right shift fff_ffff |  d==0 | w | 11 0110 dfff ffff |
|| =>{ 1'b0, mux1_out[7:1] } | d==1 | register ||
|RLF| rotate left fff_ffff |  d==0 | w | 00 1101 dfff ffff |
|| =>{ mux1_out[6:0], mux1_out[7] } | d==1 | register ||
|RRF| rotate right fff_ffff |  d==0 | w | 00 1100 dfff ffff |
|| =>{ mux1_out[0], mux1_out[7:1] } | d==1 | register ||
|SWAP|do half swap on fff_ffff |  d==0 | w | 00 1110 dfff ffff |
|| {m7, m6,...m4, m3,...m0} => {m3,...m0, m7, m6,...m4} | d==1 | register ||
| | | | | . |
|Control Operations|||||
|GOTO| PC_out = ir_out[10:0]|||10 1fff ffff ffff|
|CALL|stack[stk_ptr + 1]=pc_q||| 10 0kkk kkkk kkkk |
|RETURN| pc_q = stack[stk_ptr]||| 00 0000 0000 1000 |
|BRA| pc_next = pc_q + {ir_out[8], ir_out[8], ir_out[8:0]} - 1|limit: 255 instructions backward or 256 instructions forward|| 11 001k kkkk kkkk |
|BRW| pc_next = pc_q + {3'b0, w_q} - 1|||00 0000 0000 1011 |
|NOP|No Operation||| 00 0000 0000 0000 |

# Hardware structure
![structure](https://user-images.githubusercontent.com/92793837/209782348-1ddfa761-8ad5-4a9b-8e7f-489c1e762a50.PNG)
