module sevenSegmentDecoder(
  output logic [6:0] signal,
  input [3:0]num
);
  always_comb
  begin
    case(num)
       4'd0 : signal =7'b100_0000;
       4'd1 : signal =7'b111_1001;
       4'd2 : signal =7'b010_0100;
       4'd3 : signal =7'b011_0000;
       4'd4 : signal =7'b001_1001;
       4'd5 : signal =7'b001_0010;
       4'd6 : signal =7'b000_0010;
       4'd7 : signal =7'b111_1000;
       4'd8 : signal =7'b000_0000;
       4'd9 : signal =7'b001_0000;
      4'd10 : signal =7'b000_1000;
      4'd11 : signal =7'b000_0011;
      4'd12 : signal =7'b100_0110;
      4'd13 : signal =7'b010_0001;
      4'd14 : signal =7'b000_0110;
      4'd15 : signal =7'b000_1110;
    endcase
  end
endmodule
