module Program_Rom (//1114 class lesson
    output logic [13:0] Rom_data_out,
    input [10:0] Rom_addr_in
);
    logic [13:0] data;
    always_comb begin
        case (Rom_addr_in)
            11'h0: data = 14'h01A5;   //CLRF            ram[25]=0
            11'h1: data = 14'h0103;   //CLRW            w=0
            11'h2: data = 14'h3006;   //MOVLW 6         w=6
            11'h3: data = 14'h07A5;   //ADDLW 0x25,1    ram[25]=6
            11'h4: data = 14'h3005;   //MOVLW 5         w=5
            11'h5: data = 14'h0725;   //ADDWF 0x25,0    w=11
            11'h6: data = 14'h3E02;   //ADDLW 2         w=13
            11'h7: data = 14'h05A5;   //ANDWF 0x25,1    ram[25]=4
            11'h8: data = 14'h03A5;   //DECF 0x25       ram[25]=3
            11'h9: data = 14'h09A5;   //COMF 0x25       ram[25]=252
            11'ha: data = 14'h280A;   //GOTO 8
            //MPLAB清除暫存器的指令
            11'hb: data = 14'h3400;
            11'hc: data = 14'h3400;
            default: data = 14'h0;
        endcase
    end
    assign Rom_data_out = data;

endmodule