`timescale 1ns / 1ps

module proc_elem #(
  parameter logic [1:0] PE_ID = 2'b00
) (
  input logic clk, rst, en_pe, en_reg_array, rd_reg, wrt_reg, bias, en_bias,
  input logic [5:0] addr,
  input logic [7:0] dA_in, dB_in, dC_in,
  output logic [15:0] dA_out, dB_out, dC_out, pe_out
);

  always_ff @(posedge clk) begin
    if(rst) begin
      dA_out <= 16'b0;
      dB_out <= 16'b0;
      dC_out <= 16'b0;
    end else begin
      dA_out <= {8'b0, dA_in};
      dB_out <= {8'b0, dB_in};
      dC_out <= {8'b0, dC_in};
    end
  end

  // implement bias
  logic [15:0] dA_bias;
  always_ff @ (posedge clk) begin
    if(rst) begin
      dA_bias <= 0;
    end else begin
      dA_bias <= bias ? dA_bias : 16'b0;
    end
  end

  logic [15:0] dA_reg, dB_reg, dC_reg;
  // implement register arrays
  generate
    if(!PE_ID) begin : gen_reg_arr0
      reg_arr0 reg_arr0(.*);
    end else begin : gen_reg_arr1
      reg_arr1 reg_arr1(.*);
    end
  endgenerate

  // multiply d_out with d_reg then accumulate
  logic [15:0] dA_mult, dB_mult, dC_mult, d_acc, pe_reg;

  (* USE_DSP_48 = "yes" *)
  always_comb begin
    dA_mult = dA_out * dA_reg;
    dB_mult = dB_out * dB_reg;
    dC_mult = dC_out * dC_reg;
  end

  // perform multiply-accumulate
  assign d_acc = pe_out + dA_mult + dB_mult + dC_mult;

  // select between bias value and accumulated value
  assign pe_bias = en_bias ? dA_bias : d_acc;

  // output pe_bias
  always_ff @ (posedge clk) begin
    if(rst) begin
      pe_out <= 16'b0;
    end else if(en_pe) begin
      pe_out <= pe_bias;
    end
  end

endmodule
