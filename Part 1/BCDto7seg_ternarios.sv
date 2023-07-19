module BCDto7seg #(parameter common_cathode=1)(output a, b, c, d, e, f, g, input [3:0] BCD);
  generate
    if (common_cathode == 1)
      assign {a, b, c, d, e, f, g} =
        (BCD == 4'b0000) ? 7'b1111110 : 
        (BCD == 4'b0001) ? 7'b0110000 : 
        (BCD == 4'b0010) ? 7'b1101101 : 
        (BCD == 4'b0011) ? 7'b1111001 : 
        (BCD == 4'b0100) ? 7'b0110011 : 
        (BCD == 4'b0101) ? 7'b1011011 : 
        (BCD == 4'b0110) ? 7'b1011111 : 
        (BCD == 4'b0111) ? 7'b1110000 : 
        (BCD == 4'b1000) ? 7'b1111111 : 
        (BCD == 4'b1001) ? 7'b1111011 :
        7'b1001111;
    else
      assign {a, b, c, d, e, f, g} =
        (BCD == 4'b0000) ? 7'b0000001 : 
        (BCD == 4'b0001) ? 7'b1001111 : 
        (BCD == 4'b0010) ? 7'b0010010 : 
        (BCD == 4'b0011) ? 7'b0000110 : 
        (BCD == 4'b0100) ? 7'b1001100 : 
        (BCD == 4'b0101) ? 7'b0100100 : 
        (BCD == 4'b0110) ? 7'b0100000 : 
        (BCD == 4'b0111) ? 7'b0001111 : 
        (BCD == 4'b1000) ? 7'b0000000 : 
        (BCD == 4'b1001) ? 7'b0000100 :
        7'b0110000 ;
  endgenerate
endmodule