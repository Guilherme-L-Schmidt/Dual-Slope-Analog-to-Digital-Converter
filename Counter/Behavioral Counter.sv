module behav_counter #(parameter width=4, max_count=10)(input clk, rst_s, enb, output reg [width-1:0] q, output cnt_max);
  
  always @ (posedge clk, posedge rst_s)
    begin
      cnt_max<=0;
      if (rst_s)
        q <= 0;
      else if (enb)
        begin
          if (q < max_count-2)
            q<=q+1;
          else if (q == max_count-2)
            begin
              q<=q+1;
              cnt_max<=1;
            end
          else
            q<=0;
         end
     end

endmodule