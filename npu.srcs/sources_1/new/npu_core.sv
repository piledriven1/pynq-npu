`timescale 1ns / 1ps

module npu_core(
  input logic clk, rst,
  input logic en_pe, en_reg_array, rd_reg, wrt_reg, bias, en_bias,
  input logic en_relu, layer3_sel,
  input logic [1:0] mux_out,
  input logic [5:0] addr,
  input logic [7:0] dA_in, dB_in, dC_in,
  output logic [7:0] out
);

  logic [15:0] dA0_1, dB0_1, dC0_1;
  logic [15:0] dA1_2, dB1_2, dC1_2;
  logic [15:0] dA2_3, dB2_3, dC2_3;
  logic [15:0] pe0_reg, pe1_reg, pe2_reg, pe3_reg;

  proc_elem #(.PE_ID(0))
      pe0(
    .*, .dA_out(dA0_1), .dB_out(dB0_1), .dC_out(dC0_1), .pe_out(pe0_reg)
  );
  proc_elem #(.PE_ID(1))
      pe1(
    .*, .dA_in(dA0_1), .dB_in(dB0_1), .dC_in(dC0_1),
    .dA_out(dA1_2), .dB_out(dB1_2), .dC_out(dC1_2), .pe_out(pe1_reg)
  );
  proc_elem #(.PE_ID(2))
      pe2(
    .*, .dA_in(dA1_2), .dB_in(dB1_2), .dC_in(dC1_2),
    .dA_out(dA2_3), .dB_out(dB2_3), .dC_out(dC2_3), .pe_out(pe2_reg)
  );
  proc_elem #(.PE_ID(3))
      pe3(
    .*, .dA_in(dA2_3), .dB_in(dB2_3), .dC_in(dC2_3),
    .dA_out(dA2_3), .dB_out(dB2_3), .dC_out(dC2_3), .pe_out(pe3_reg)
  );

  logic [15:0] quant_in;
  logic [7:0] quant_out;

  // Mux for quantization
  always_comb begin
    unique case(mux_out)
      2'b00: quant_in = pe0_reg;
      2'b01: quant_in = pe1_reg;
      2'b10: quant_in = pe2_reg;
      2'b11: quant_in = pe3_reg;
    endcase
  end

  logic [16:0] acomp_out, comp_out;
  // TODO: implement autocomp module here

  // quantization module
  quantization quant(
    .*, .d_in(quant_in), .d_out(quant_out)
  );

  logic [7:0] relu_out;
  relu relu(
    .*, .d_in(quant_out), .relu_out(relu_out)
  );

  // TODO: implement comp module here

  assign out = layer3_sel ? acomp_out : comp_out;

endmodule
