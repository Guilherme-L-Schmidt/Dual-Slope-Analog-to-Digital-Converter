module dff(output reg q, qb, input clk, d, enb, rst);
  always @ (negedge clk or posedge rst)
    if (rst)
      q = 1'b0;
    else if (enb)
      q = d;
  
  assign qb = ~q;
endmodule

module counter_a #(parameter width=4, max_count=10)(output [width-1:0] q, output cnt_max, input clk, enb, rst_s);
  wire [width-1:0] qb;
  wire rst;
  parameter max = max_count - 1;
  
  genvar i;
  generate
    for (i=0; i<width; i=i+1)
      if (i == 0)
        dff u0 (.q(q[i]), .qb(qb[i]), .clk(clk), .d(qb[i]), .enb(enb), .rst(rst));
      else
      	dff ui (.q(q[i]), .qb(qb[i]), .clk(q[i-1]), .d(qb[i]), .enb(enb), .rst(rst));
  endgenerate
  assign cnt_max = &(max[width-1:0] ~^ q[width-1:0]);
  assign rst = &(max_count[width-1:0] ~^ q[width-1:0]) | rst_s;
endmodule