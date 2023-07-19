module dff(output reg q, qb, input clk, d, enb, rst);
  always @ (negedge clk or posedge rst)
    if (rst)
      q = 1'b0;
  	else if (enb)
  	  q = d;
  
  assign qb = ~q;
endmodule

module counter_s #(parameter width=4, max_count=10)(output [width-1:0] q, output cnt_max, input clk, enb, rst_s);
  wire [width-1:0] qb;
  wire [width-1:0] de;
  wire rst;
  parameter max = max_count - 1;
  
  genvar i;
  generate
    for (i=0; i<width; i=i+1)
      begin
        if (i == 0)
          begin
            assign de[i] = q[i]^1;
            dff u0 (.q(q[i]), .qb(qb[i]), .clk(clk), .d(de[i]), .enb(enb), .rst(rst));
          end
        else
          begin
        	assign de[i] = (&q[i-1:0])^q[i];
            dff ui (.q(q[i]), .qb(qb[i]), .clk(clk), .d(de[i]), .enb(enb), .rst(rst));
          end
      end
  endgenerate
  assign cnt_max = &(max[width-1:0] ~^ q[width-1:0]);
  assign rst = &(max_count[width-1:0] ~^ q[width-1:0]) | rst_s;
endmodule