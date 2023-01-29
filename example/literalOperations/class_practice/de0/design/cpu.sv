module cpu (
    input clk,
    input reset,
    output logic [13:0] IR
);
    logic [13:0] rom_q, ir_q;
    logic [10:0] pc_next, pc_q, mar_q;
    logic load_pc, load_mar,load_ir,reset_ir,load_w;
    logic [3:0] ps,ns;
    logic [7:0] w_q,alu_q;
    logic [3:0] op;
    logic [5:0] opcode;
    //pc
    assign pc_next = pc_q + 1;

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
            IR <= 0;
        else if(load_ir)
            IR <= rom_q;
    end

    assign opcode = IR[13:8];
    assign MOVLW = (opcode==6'h30);
    assign ADDLW = (opcode==6'h3E);
    assign IORLW = (opcode==6'h38);
    assign ANDLW = (opcode==6'h39);
    assign SUBLW = (opcode==6'h3C);
    assign XORLW = (opcode==6'h3A);
    
    //ALU
    ALU ALU_1(
    .op(op),
    .w_q(w_q),
    .ir_q(IR[7:0]),
    .alu_q(alu_q)
);
    
    always_ff @( posedge clk ) begin
        if(load_w)
            w_q <= alu_q;
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
        load_mar = 0;
        load_pc = 0;
        reset_ir = 1;//////////////////////////////
        load_ir = 0;
        load_w = 0;
        op =0;
        ns=0;
        case(ps)
            T0: begin
                load_mar = 0;
                load_pc = 0;
                reset_ir = 0;
                load_ir = 0;
                load_w = 0;
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
                load_w = 1;
                if(MOVLW)
                    op = 5;
                else if(ADDLW)
                    op = 0;
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