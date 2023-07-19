// Decodificador BCD para display 7 segmentos, produzido na parte 1
module BCDto7seg #(parameter common_cathode=1)(output a, b, c, d, e, f, g, input [3:0] BCD);
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

// Flip-Flop tipo D com sinal 'enb'
module dff_4bit(output reg [3:0] q, input [3:0] d, input clk, enb);
  always @ (posedge clk)
    if (enb)
      q = d;
endmodule

// Contador parametrizavel comportamental, produzido na parte 2
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

// Contador digital BCD de 000 a 999, com 21 fios de output para 3 displays de 7 segmentos
module counter_999 (output [20:0] display, output cnt_max, input clk, enb, rst_s, ld);

  reg [3:0] qx[3];
  reg [3:0] qs[3];
  wire max[3];

  // Gera 3 contadores de 0 a 9 em sequência
  genvar i;
  generate
    for (i=0; i<3; i=i+1)
      begin
        if (i == 0)
          // Primeiro contador
          behav_counter #(.width(4), .max_count(10))
          u0 (.q(qx[0]), .cnt_max(max[0]), .clk(clk), .enb(enb), .rst_s(rst_s));
        else
          // Contadores seguintes, com a saida 'cnt_max' do anterior entrando em 'enb' no seguinte
          behav_counter #(.width(4), .max_count(10))
          ui (.q(qx[i]), .cnt_max(max[i]), .clk(clk), .enb(max[i-1]), .rst_s(rst_s));

        dff_4bit register (.q(qs[i]), .clk(clk), .d(qx[i]), .enb(ld));

        // Decodificador BCD para 7 segmentos recebendo 'q' do contador atual e retornando os 7 fios de display
        BCDto7seg #(.common_cathode(1))
        bcdi (.a(display[i*7]), .b(display[1+i*7]), .c(display[2+i*7]), .d(display[3+i*7]),
         .e(display[4+i*7]), .f(display[5+i*7]), .g(display[6+i*7]), .BCD(qs[i]));
      end
  endgenerate
  
  assign cnt_max = max[2];

endmodule

module control_machine( input inicio,
                        input clk,
                        input enb_3,
                        input Vint_z,
                        output ch_vm,
                        output ch_vr,
                        output ch_zr,
                        output rst_s,
                        output enb_0);
  reg working;
  reg [2:0] next_phase;
  always @(posedge clk) begin
    // Inicia o sistema
    if(inicio) begin
      working = 1'b1; // Inicia operacao
      next_phase = 1; // Inicia na primeira fase do controlador
      rst_s = 1'b1;
      enb = 1'b0;
    end
    
    // Logica das fases de operacao
    else if(working == 1'b1) begin
      if(next_phase == 1) begin
        ch_vm = 1'b1;
        ch_vr = 1'b0;
        ch_zr = 1'b0;
        rst_s = 1'b0;
        enb_0 = 1'b1;
        next_phase = 2;
      end else if (next_phase == 2 && enb_3) begin
        ch_vm = 1'b0;
        ch_vr = 1'b1;
        next_phase = 3;
      end else if (next_phase == 3 && Vint_z) begin
        ch_vr = 1'b0;
        ch_zr = 1'b1;
        enb_0 = 1'b0;
        next_phase = 4;
      end else if (next_phase == 4) begin
        ch_zr = 1'b0;
        rst_s = 1'b1;
        working = 1'b0; // Finaliza operacao
      end 
    end
  end
endmodule

module controler( input inicio,
                  input clk,
                  input Vint_z,
                  output ch_vm,
                  output ch_vr,
                  output ch_zr,
                  output [20:0] display);

  wire enb_0, enb_3, Vint_z, rst;

  control_machine contr(.inicio(inicio), .clk(clk), .enb_3(enb_3), .Vint_z(Vint_z),
  .ch_vm(ch_vm), .ch_vr(ch_vr), .ch_zr(ch_zr), .rst_s(rst), .enb_0(enb_0));

  counter_999 cnt(.display(display), .cnt_max(enb_3), .clk(clk), .enb(enb_0), .rst_s(rst), .ld(Vint_z));

endmodule