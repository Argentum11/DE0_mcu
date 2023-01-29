module ALU (
    input [3:0]op,
    input [7:0]w_q, ir_q,
    output logic [7:0]alu_q
);
always_comb
begin
    case(op)
        0: alu_q = ir_q[7:0] + w_q;
        1: alu_q = ir_q[7:0] - w_q;
        2: alu_q = ir_q[7:0] & w_q;
        3: alu_q = ir_q[7:0] | w_q;
        4: alu_q = ir_q[7:0] ^ w_q;
        5: alu_q = ir_q[7:0];
        default: alu_q = ir_q[7:0] + w_q;
    endcase
end
    
endmodule