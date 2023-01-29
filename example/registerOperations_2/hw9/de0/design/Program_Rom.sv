module Program_Rom (//1121
    output logic [13:0] Rom_data_out,
    input [10:0] Rom_addr_in
);
    logic [13:0] data;
    always_comb begin
        case (Rom_addr_in)
            11'h0: data = 14'h01A5;   //CLRF            ram[25]=0
            11'h1: data = 14'h0103;   //CLRW            w=0
            11'h2: data = 14'h3007;   //MOVLW 7         w=7
            11'h3: data = 14'h07A5;   //ADDWF 0x25,1    ram[25]=7
            11'h4: data = 14'h3005;   //MOVLW 5         w=5
            11'h5: data = 14'h0AA5;   // INCF 0x25,1    ram[25]=8
            11'h6: data = 14'h04A5;   //IORWF 0x25,1    ram[25]=D
            11'h7: data = 14'h00A4;   //MOVWF 0x24,1    ram[24]=5
            11'h8: data = 14'h0225;   //SUBWF 0x25,0    w=8
            11'h9: data = 14'h0825;   // MOVF 0x25,0    w=D
            11'ha: data = 14'h06A4;   //XORWF 0x24,1    ram[24]=8
            //MPLAB清除暫存器的指令
            11'hb: data = 14'h3400;
            11'hc: data = 14'h3400;
            default: data = 14'h0;
        endcase
    end
    assign Rom_data_out = data;

endmodule