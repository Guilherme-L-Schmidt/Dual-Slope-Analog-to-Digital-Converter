
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