module dff(output reg q, qb, input clk, d, enb, rst);
  always @ (negedge clk or posedge rst)
    if (rst)
      q = 1'b0;
  	else if (enb)
  	  q = d;
  
  assign qb = ~q;
endmodule