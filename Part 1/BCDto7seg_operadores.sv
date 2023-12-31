module BCDto7seg #(parameter common_cathode=1)(output a, b, c, d, e, f, g, input [3:0] BCD);
  wire [3:0] nBCD;
  assign nBCD = ~BCD;

  generate
    if(common_cathode == 1)
      begin
        assign a = BCD[3] | BCD[1] | nBCD[2]&nBCD[0] | BCD[2]&BCD[0];
        assign b = nBCD[2] | nBCD[1]&nBCD[0] | BCD[1]&BCD[0];
        assign c = BCD[2] | nBCD[1] | BCD[0];
        assign d = BCD[3] | nBCD[2]&nBCD[0] | nBCD[2]&BCD[1] | BCD[1]&nBCD[0] | BCD[2]&nBCD[1]&BCD[0];
        assign e = nBCD[2]&nBCD[0] | BCD[1]&nBCD[0];
        assign f = BCD[3] | nBCD[1]&nBCD[0] | BCD[2]&nBCD[1] | BCD[2]&nBCD[0];
        assign g = BCD[3] | BCD[1]&nBCD[0] | nBCD[2]&BCD[1] | BCD[2]&nBCD[1];
      end
    else
      begin
        assign a = BCD[2]&nBCD[1]&nBCD[0] | nBCD[3]&nBCD[2]&nBCD[1]&BCD[0];
        assign b = BCD[2]&nBCD[1]&BCD[0] | BCD[2]&BCD[1]&nBCD[0];
        assign c = nBCD[2]&BCD[1]&nBCD[0];
        assign d = nBCD[3]&nBCD[2]&nBCD[1]&BCD[0] | BCD[2]&BCD[1]&BCD[0] | BCD[2]&nBCD[1]&nBCD[0];
        assign e = BCD[2]&nBCD[1] | BCD[0];
        assign f = nBCD[2]&BCD[1] | BCD[1]&BCD[0] | nBCD[3]&nBCD[2]&BCD[0];
        assign g = BCD[2]&BCD[1]&BCD[0] | nBCD[3]&nBCD[2]&nBCD[1];
      end
  endgenerate
endmodule