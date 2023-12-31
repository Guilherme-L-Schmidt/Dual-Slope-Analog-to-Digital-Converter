module BCDto7seg #(parameter common_cathode=0)(output a, b, c, d, e, f, g, input [3:0] BCD);
  reg [6:0] seg;

  generate
    if (common_cathode == 1) 
      always @ (BCD)
        begin   
          case(BCD)
            0: seg = 7'b1111110;
            1: seg = 7'b0110000;
            2: seg = 7'b1101101;
            3: seg = 7'b1111001;
            4: seg = 7'b0110011;
            5: seg = 7'b1011011;
            6: seg = 7'b1011111;
            7: seg = 7'b1110000;
            8: seg = 7'b1111111;
            9: seg = 7'b1111011;
            default: seg=7'b1001111;
          endcase
        end
	else
      always @ (BCD)
        begin
          case(BCD)
            0: seg = 7'b0000001;
            1: seg = 7'b1001111;
            2: seg = 7'b0010010;
            3: seg = 7'b0000110;
            4: seg = 7'b1001100;
            5: seg = 7'b0100100;
            6: seg = 7'b0100000;
            7: seg = 7'b0001111;
            8: seg = 7'b0000000;
            9: seg = 7'b0000100;
            default: seg=7'b0110000;
          endcase
        end
  endgenerate
  assign {a,b,c,d,e,f,g} = seg;
endmodule