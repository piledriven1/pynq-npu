`timescale 1ns / 1ps

module relu(
  input logic clk, rst, en_relu,
  input logic [15:0] d_in,
  output logic [15:0] relu_out
);

  logic [15:0] d_reg;
  logic sel = d_in[15];

  always_comb begin
    d_reg = (sel) ? 16'b0 : d_in;
  end

  always_ff @ (posedge clk) begin
    if(rst) begin
      relu_out <= 0;
    end else begin
      relu_out <= d_reg;
    end
  end
endmodule
