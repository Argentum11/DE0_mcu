# mcu
|instruction|description|signal|
|---|---|---|
|Literal Operations||number = kkkk_kkkk|
|MOVLW|move a number to w|11_0000_kkkk_kkkk|
|ADDLW|do add operations between another number and w, then save it to w|11_1110_kkkk_kkkk|
|IORLW|do OR operations between another number and w, then save it to w|11_1000_kkkk_kkkk|
|ANDLW|do AND operations between another number and w, then save it to w|11_1001_kkkk_kkkk|
|SUBLW|do minus operations between another number and w, then save it to w|11_1100_kkkk_kkkk|
|XORLW|do XOR operations between another number and w, then save it to w|11_1010_kkkk_kkkk|
|---|---|
|ADDLW||
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
