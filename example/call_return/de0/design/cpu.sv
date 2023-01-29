module cpu (
    input clk,
    input reset,
    output logic [7:0] port_b_out
);
    logic [13:0] rom_q, ir_q;
    logic [10:0] pc_next, pc_q, mar_q;
    logic load_pc, load_mar, load_ir, reset_ir, load_w, ram_en, sel_alu, d, sel_bus;
    logic load_port_b;
    logic [1:0] sel_pc;
    logic [3:0] ps,ns;
    logic [7:0] w_q, alu_q, ram_out, mux1_out, bcf_mux, bsf_mux, ram_mux;
    logic [7:0] databus;
    logic [3:0] op;
    logic [5:0] opcode;
    logic [2:0] sel_bit;
    logic [1:0] sel_ram_mux;
    //for Stack
    logic pop, push;
    logic [10:0] stack_out;

    //Stack
    Stack Stack_1(
        .stack_out(stack_out),
        .stack_in(pc_q),
        .push(push),
        .pop(pop),
        .reset(reset),
        .clk(clk)
    );

    //mux 0 (select next PC address)
    always_comb begin
        if(sel_pc == 2) begin
            pc_next = stack_out;   
        end
        else if(sel_pc == 1) begin
            pc_next = ir_q;   
        end
        else begin
            pc_next = pc_q + 1;
        end
    end    

    //pc
    always_ff @( posedge clk ) begin
        if(reset)
            pc_q <= 0;
        else if(load_pc)
            pc_q <= pc_next;
    end

    //mar
    always_ff @( posedge clk ) begin
        if(load_mar)
            mar_q <= pc_q;
    end

    //ROM
    Program_Rom ROM_1(
        .Rom_addr_in(mar_q),
        .Rom_data_out(rom_q)
    );

    //IR
    always_ff @( posedge clk ) begin
        if(reset)
            ir_q <= 0;
        else if(load_ir)
            ir_q <= rom_q;
    end

    //RAM
    single_port_ram_128x8 single_port_ram_128x8_1(
        .data(databus),
        .addr(ir_q[6:0]),
        .ram_en(ram_en),
        .clk(clk),
        .ram_out(ram_out)
    );

    assign sel_bit = ir_q[9:7];

    //BCF mux
    always_comb begin
        case (sel_bit)
            3'b000: bcf_mux = ram_out & 8'b1111_1110;
            3'b001: bcf_mux = ram_out & 8'b1111_1101;
            3'b010: bcf_mux = ram_out & 8'b1111_1011;
            3'b011: bcf_mux = ram_out & 8'b1111_0111;
            3'b100: bcf_mux = ram_out & 8'b1110_1111;
            3'b101: bcf_mux = ram_out & 8'b1101_1111;
            3'b110: bcf_mux = ram_out & 8'b1011_1111;
            3'b111: bcf_mux = ram_out & 8'b0111_1111;
        endcase
    end

    //BSF mux
    always_comb begin
        case (sel_bit)
            3'b000: bsf_mux = ram_out | 8'b0000_0001;
            3'b001: bsf_mux = ram_out | 8'b0000_0010;
            3'b010: bsf_mux = ram_out | 8'b0000_0100;
            3'b011: bsf_mux = ram_out | 8'b0000_1000;
            3'b100: bsf_mux = ram_out | 8'b0001_0000;
            3'b101: bsf_mux = ram_out | 8'b0010_0000;
            3'b110: bsf_mux = ram_out | 8'b0100_0000;
            3'b111: bsf_mux = ram_out | 8'b1000_0000;
        endcase
    end

    //ram mux (select data into mux1)
    always_comb begin
        case (sel_ram_mux)
            0: ram_mux = ram_out;
            1: ram_mux = bcf_mux;
            2: ram_mux = bsf_mux;
        endcase
    end

    //mux 1 (select data into ALU)
    always_comb begin
        if(sel_alu) begin
            mux1_out = ram_mux;
        end
        else begin
            mux1_out = ir_q;
        end
    end    

    assign d = ir_q[7];
    assign  MOVLW = (ir_q[13:8]==6'h30);
    assign  ADDLW = (ir_q[13:8]==6'h3E);
    assign  IORLW = (ir_q[13:8]==6'h38);
    assign  ANDLW = (ir_q[13:8]==6'h39);
    assign  SUBLW = (ir_q[13:8]==6'h3C);
    assign  XORLW = (ir_q[13:8]==6'h3A);

    assign  ADDWF = (ir_q[13:8]==6'h07);
    assign  ANDWF = (ir_q[13:8]==6'h05);
    assign   CLRF = (ir_q[13:8]==6'h01 && d==1);
    assign   CLRW = (ir_q[13:4]==10'h010 && ir_q[3:2]==2'h0);
    assign   COMF = (ir_q[13:8]==6'h09);
    assign   DECF = (ir_q[13:8]==6'h03);
    assign   GOTO = (ir_q[13:11]==3'b101);

    assign   INCF = (ir_q[13:8]==6'h0A);
    assign  IORWF = (ir_q[13:8]==6'h04);
    assign   MOVF = (ir_q[13:8]==6'h08);
    assign  MOVWF = (ir_q[13:8]==6'h00 && ir_q[7]==1'b1);
    assign  SUBWF = (ir_q[13:8]==6'h02);
    assign  XORWF = (ir_q[13:8]==6'h06);

    assign    BCF = (ir_q[13:12]==2'b01 && ir_q[11:10]==2'b00);
    assign    BSF = (ir_q[13:12]==2'b01 && ir_q[11:10]==2'b01);
    assign  BTFSC = (ir_q[13:12]==2'b01 && ir_q[11:10]==2'b10);
    assign  BTFSS = (ir_q[13:12]==2'b01 && ir_q[11:10]==2'b11);
    assign DECFSZ = (ir_q[13:8]==6'h0B);
    assign INCFSZ = (ir_q[13:8]==6'h0F);
    
    assign btfsc_skip_bit = (ram_out[ir_q[9:7]]==0);
    assign btfss_skip_bit = (ram_out[ir_q[9:7]]==1);
    assign btfsc_btfss_skip_bit = (BTFSC&btfsc_skip_bit) | 
                                  (BTFSS&btfss_skip_bit);
    assign   ASRF = (ir_q[13:8]==6'h37);        // arithmetic right shift
    assign   LSLF = (ir_q[13:8]==6'h35);        // logical left shift
    assign   LSRF = (ir_q[13:8]==6'h36);        // logical right shift
    assign    RLF = (ir_q[13:8]==6'h0D);        // rotate left f
    assign    RRF = (ir_q[13:8]==6'h0C);        // rotate right f
    assign   SWAP = (ir_q[13:8]==6'h0E); //{m7, m6,...m4, m3,...m0} => {m3,...m0, m7, m6,...m4}
    
    assign   CALL = ir_q[13:12]==2'b10 && ir_q[11]==0;
    assign RETURN = ir_q == 0;

    //ALU
    ALU ALU_1(
        .op(op),
        .w_q(w_q),
        .mux1_out(mux1_out),
        .alu_q(alu_q)
    );
    assign aluout_zero = (alu_q == 0);
    
    //register
    always_ff @( posedge clk ) begin
        if(load_w)
            w_q <= alu_q;
    end

    //mux 2 (select data into RAM)
    always_comb begin
        if(sel_bus) begin
            databus = w_q;
        end
        else begin
            databus = alu_q;
        end
    end

    //Port_b
    always_ff @( posedge clk ) begin
        if(reset) begin
            port_b_out <= 0;
        end
        else if(load_port_b) begin
            port_b_out <= databus;
        end
    end

    assign addr_port_b = (ir_q[6:0] == 7'h0D);

    //controller
    parameter T0 = 0;
    parameter T1 = 1;
    parameter T2 = 2;
    parameter T3 = 3;
    parameter T4 = 4;
    parameter T5 = 5;
    parameter T6 = 6;

    always_ff @( posedge clk ) begin
        if(reset) ps <= 0;
        else ps <= ns;
    end

    always_comb begin
        sel_alu = 0;
        sel_pc = 0;
        load_mar = 0;
        load_pc = 0;
        reset_ir = 1;
        load_ir = 0;
        load_w = 0;
        ram_en = 0;
        op =0;
        sel_ram_mux = 0;
        sel_bus = 0;
        load_port_b = 0;
        ns=0;
        //for Stack
        push = 0;
        pop = 0;
        case(ps)
            T0: begin
                ns = T1;
            end
            T1: begin
                load_mar = 1;
                load_pc = 0;
                reset_ir = 0;
                load_ir = 0;
                load_w = 0;
                ns = T2;
            end
            T2: begin
                sel_pc = 0;
                load_mar = 0;
                load_pc = 1;
                reset_ir = 0;
                load_ir = 0;
                load_w = 0;
                ns = T3;
            end
            T3: begin
                load_mar = 0;
                load_pc = 0;
                reset_ir = 0;
                load_ir = 1;
                load_w = 0;
                ns = T4;
            end
            T4: begin
                load_mar = 0;
                load_pc = 0;
                reset_ir = 0;
                load_ir = 0;
                
                if(MOVLW) begin
                    sel_alu = 0;
                    op = 5;
                    load_w = 1;
                end
                else if(ADDLW) begin
                    sel_alu = 0;
                    op = 0;
                    load_w = 1;
                end
                else if(IORLW) begin
                    sel_alu = 0;
                    op = 3;
                    load_w = 1;
                end
                else if(ANDLW) begin
                    sel_alu = 0;
                    op = 2;
                    load_w = 1;
                end
                else if(SUBLW) begin
                    sel_alu = 0;
                    op = 1;
                    load_w = 1;
                end
                else if(XORLW) begin
                    sel_alu = 0;
                    op = 4;
                    load_w = 1;
                end

                
                else if(GOTO) begin
                    sel_pc = 1;
                    load_pc = 1;
                end
                else if(ADDWF) begin
                    op = 0;
                    sel_alu = 1;
                    if(d) begin
                        ram_en = 1;
                    end
                    else begin
                        load_w = 1; 
                    end
                end
                else if(ANDWF) begin
                    op = 2;
                    sel_alu = 1;
                    if(d) begin
                        ram_en = 1;
                    end
                    else begin
                        load_w = 1; 
                    end
                end
                else if(CLRF) begin
                    op = 8;
                    ram_en = 1;
                end
                else if(CLRW) begin
                    op = 8;
                    load_w = 1;
                end
                else if(COMF) begin
                    op = 9;
                    sel_alu = 1;
                    ram_en = 1;
                end
                else if(DECF) begin
                    op = 7;
                    sel_alu = 1;
                    ram_en = 1;
                end

                else if(INCF) begin
                    op = 6;
                    sel_alu = 1;
                    if(d) begin
                        ram_en = 1;
                        sel_bus = 0;
                    end
                    else begin
                        load_w = 1;
                    end
                end
                else if(IORWF) begin
                    op = 3;
                    sel_alu = 1;
                    if(d) begin
                        ram_en = 1;
                        sel_bus = 0;
                    end
                    else begin
                        load_w = 1;
                    end
                end
                else if(MOVF) begin
                    op = 5;
                    sel_alu = 1;
                    if(d) begin
                        ram_en = 1;
                        sel_bus = 0;
                    end
                    else begin
                        load_w = 1;
                    end
                end
                else if(MOVWF) begin
                    sel_bus = 1;
                    if(addr_port_b)begin
                        load_port_b = 1;
                    end
                    else begin
                        ram_en = 1;
                    end
                end
                else if(SUBWF) begin
                    op = 1;
                    sel_alu = 1;
                    if(d) begin
                        ram_en = 1;
                        sel_bus = 0;
                    end
                    else begin
                        load_w = 1;
                    end
                end
                else if(XORWF) begin
                    op = 4;
                    sel_alu = 1;
                    if(d) begin
                        ram_en = 1;
                        sel_bus = 0;
                    end
                    else begin
                        load_w = 1;
                    end
                end
                else if(BCF)begin
                    sel_alu = 1;
                    sel_ram_mux = 1;
                    op = 5;
                    sel_bus = 0;
                    ram_en = 1;
                end
                else if(BSF)begin
                    sel_alu = 1;
                    sel_ram_mux = 2;
                    op = 5;
                    sel_bus = 0;
                    ram_en = 1;
                end
                else if(BTFSC || BTFSS)begin
                    if( btfsc_btfss_skip_bit )begin
                        load_pc = 1;
                        sel_pc = 0;
                    end
                end
                else if(DECFSZ)begin
                    sel_alu = 1;
                    op = 7;
                    if(aluout_zero)begin
                        load_pc = 1;
                        sel_pc = 0;
                    end

                    if(d)begin
                        ram_en = 1;
                        sel_bus = 0;
                    end
                    else begin
                        load_w = 1;
                    end
                end
                else if(INCFSZ) begin
                    sel_alu = 1;
                    op = 6;
                    if(aluout_zero)begin
                        load_pc = 1;
                        sel_pc = 0;
                    end
                    
                    if(d)begin
                        ram_en = 1;
                        sel_bus = 0;
                    end
                    else begin
                        load_w = 1;
                    end
                end

                else if(ASRF) begin
                    sel_alu = 1;
                    sel_ram_mux = 0;
                    op = 4'hA;
                    if(d)begin
                        sel_bus = 0;
                        ram_en = 1;
                    end
                    else begin
                        load_w = 1;
                    end
                end
                else if(LSLF) begin
                    sel_alu = 1;
                    sel_ram_mux = 0;
                    op = 4'hB;
                    if(d)begin
                        sel_bus = 0;
                        ram_en = 1;
                    end
                    else begin
                        load_w = 1;
                    end
                end
                else if(LSRF) begin
                    sel_alu = 1;
                    sel_ram_mux = 0;
                    op = 4'hC;
                    if(d)begin
                        sel_bus = 0;
                        ram_en = 1;
                    end
                    else begin
                        load_w = 1;
                    end
                end
                else if(RLF) begin
                    sel_alu = 1;
                    sel_ram_mux = 0;
                    op = 4'hD;
                    if(d)begin
                        sel_bus = 0;
                        ram_en = 1;
                    end
                    else begin
                        load_w = 1;
                    end
                end
                else if(RRF) begin
                    sel_alu = 1;
                    sel_ram_mux = 0;
                    op = 4'hE;
                    if(d)begin
                        sel_bus = 0;
                        ram_en = 1;
                    end
                    else begin
                        load_w = 1;
                    end
                end
                else if(SWAP) begin
                    sel_alu = 1;
                    sel_ram_mux = 0;
                    op = 4'hF;
                    if(d)begin
                        sel_bus = 0;
                        ram_en = 1;
                    end
                    else begin
                        load_w = 1;
                    end
                end
                
                else if(CALL) begin
                    sel_pc = 1;
                    load_pc = 1;
                    push = 1;
                end
                else if(RETURN) begin
                    sel_pc = 2;
                    load_pc = 1;
                    pop = 1;
                end
                ns = T5;
            end
            T5: begin
                ns = T6;
            end
            T6: begin
                ns = T1;
            end
        endcase
    end
endmodule