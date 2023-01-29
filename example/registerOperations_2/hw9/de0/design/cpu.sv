module cpu (
    input clk,
    input reset,
    output logic [7:0] w_q
);
    logic [13:0] rom_q, ir_q;
    logic [10:0] pc_next, pc_q, mar_q;
    logic load_pc, load_mar, load_ir, reset_ir, load_w, sel_pc, ram_en, sel_alu, d, sel_bus;
    logic [3:0] ps,ns;
    logic [7:0] alu_q, ram_out, mux1_out, databus;
    logic [3:0] op;
    logic [5:0] opcode;
    //mux 0
    always_comb begin
        if(sel_pc) begin
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

    //mux 1 (select data into ALU)
    always_comb begin
        if(sel_alu) begin
            mux1_out = ram_out;
        end
        else begin
            mux1_out = ir_q;
        end
    end    

    assign d = ir_q[7];
    assign MOVLW = (ir_q[13:8]==6'h30);
    assign ADDLW = (ir_q[13:8]==6'h3E);
    assign IORLW = (ir_q[13:8]==6'h38);
    assign ANDLW = (ir_q[13:8]==6'h39);
    assign SUBLW = (ir_q[13:8]==6'h3C);
    assign XORLW = (ir_q[13:8]==6'h3A);

    assign ADDWF = (ir_q[13:8]==6'h07);
    assign ANDWF = (ir_q[13:8]==6'h05);
    assign CLRF  = (ir_q[13:8]==6'h01 && d==1);
    assign CLRW  = (ir_q[13:4]==10'h010 && ir_q[3:2]==2'h0);
    assign COMF  = (ir_q[13:8]==6'h09);
    assign DECF  = (ir_q[13:8]==6'h03);
    assign GOTO  = (ir_q[13:11]==3'b101);

    assign INCF  = (ir_q[13:8]==6'h0A);
    assign IORWF = (ir_q[13:8]==6'h04);
    assign MOVF  = (ir_q[13:8]==6'h08);
    assign MOVWF = (ir_q[13:8]==6'h00 && ir_q[7]==1'b1);
    assign SUBWF = (ir_q[13:8]==6'h02);
    assign XORWF = (ir_q[13:8]==6'h06);

    //ALU
    ALU ALU_1(
        .op(op),
        .w_q(w_q),
        .mux1_out(mux1_out),
        .alu_q(alu_q)
    );
    
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
        ram_en=0;
        op =0;
        ns=0;
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
                    ram_en = 1;
                    sel_bus = 1;
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