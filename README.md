# mcu
|instruction|description|save to||signal|
|---|---|---|---|---|
|Literal Operations||||number = kkkk kkkk|
|MOVLW|move a number to w|||11 0000 kkkk kkkk|
|ADDLW|do add operations between another number and w, then save it to w|||11 1110 kkkk kkkk|
|IORLW|do OR operations between another number and w, then save it to w|||11 1000 kkkk kkkk|
|ANDLW|do AND operations between another number and w, then save it to w|||11 1001 kkkk kkkk|
|SUBLW|do minus operations between another number and w, then save it to w|||11 1100 kkkk kkkk|
|XORLW|do XOR operations between another number and w, then save it to w|||11 1010 kkkk kkkk|
|---|---|
|ADDLW|w + fff_ffff (register file address 0x00~0x7f)|d==0|w|00 0111 dfff ffff|
|||d==1|register||
|ANDWF||
|CLRF||
|CLRW||
|COMF||
|DECF||
|GOTO||
|---|---|
|INCF||
|IORWF||
|MOVF||
|MOVWF||
|SUBWF||
|XORWF||
|---|---|
|BCF||
|BSF||
|BTFSC||
|BTFSS||
|DECFSZ||
|INCFSZ||
|---|---|
|ASRF||
|LSLF||
|LSRF||
|RLF||
|RRF||
|SWAP||
|---|---|
|CALL||
|RETURN||
|---|---|
|BRA||
|BRW||
|NOP||
