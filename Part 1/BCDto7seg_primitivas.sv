module BCDto7seg #(parameter common_cathode=1)(output a, b, c, d, e, f, g, input [3:0] BCD);
  wire [3:0] nBCD;
  not (nBCD, BCD);

  generate
    if(common_cathode==1)
      begin
        wire nB2nB0, B2B0, nB1nB0, B1B0, nB2B1, B1nB0, B2nB1, B2nB0, B2nB1B0;

        and (B2nB1B0, BCD[2], nBCD[1], BCD[0]);
        and (nB2nB0, nBCD[2], nBCD[0]);
        and (nB1nB0, nBCD[1], nBCD[0]);
        and (nB2B1, nBCD[2], BCD[1]);
        and (B2nB1, BCD[2], nBCD[1]);
        and (B2nB0, BCD[2], nBCD[0]);
        and (B1nB0, BCD[1], nBCD[0]);
        and (B2B0, BCD[2], BCD[0]);
        and (B1B0, BCD[1], BCD[0]);
        
        or (a, BCD[3], BCD[1], nB2nB0, B2B0);
        or (b, nBCD[2], nB1nB0, B1B0);
        or (c, BCD[2], nBCD[1], BCD[0]);
        or (d, BCD[3], nB2nB0 , nB2B1, B1nB0, B2nB1B0);
        or (e, nB2nB0, B1nB0);
        or (f, BCD[3], nB1nB0, B2nB1, B2nB0);
        or (g, BCD[3], B1nB0, nB2B1, B2nB1);
      end
    else
      begin
        wire B2nB1nB0, nB3nB2nB1B0, B2nB1B0, B2B1nB0, nB3nB2B0, nB3nB2nB1, B2B1B0, B2nB1, nB2B1, B1B0;

        and (B2nB1nB0, BCD[2], nBCD[1], nBCD[0]);
        and (nB3nB2nB1B0, nBCD[3], nBCD[2], nBCD[1], BCD[0]);
        and (B2nB1B0, BCD[2], nBCD[1], BCD[0]);
        and (B2B1nB0, BCD[2], BCD[1], nBCD[0]);
        and (c, nBCD[2], BCD[1], nBCD[0]);
        and (nB3nB2B0, nBCD[3], nBCD[2], BCD[0]);
        and (nB3nB2nB1, nBCD[3], nBCD[2], nBCD[1]);
        and (B2B1B0, BCD[2], BCD[1], BCD[0]);
        and (B2nB1, BCD[2], nBCD[1]);
        and (nB2B1, nBCD[2], BCD[1]);
        and (B1B0, BCD[1], BCD[0]);

        or(a, B2nB1nB0, nB3nB2nB1B0);
        or(b, B2nB1B0, B2B1nB0);
        or(d, nB3nB2nB1B0, B2B1B0, B2nB1nB0);
        or(e, B2nB1, BCD[0]);
        or(f, nB2B1, B1B0, nB3nB2B0);
        or(g, B2B1B0, nB3nB2nB1);
      end
  endgenerate
endmodule