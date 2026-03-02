`timescale 1ns / 1ps

module quantization(
  input logic clk, rst,
  input logic [15:0] d_in,
  output logic [7:0] d_out
);

  logic sel;
  logic [7:0] d_w1, d_w2;

  assign sel = | d_in[14:11];

  assign d_w1 = d_in[3] ? {{d_in[15]}, {d_in[10:4]}} : {{d_in[15]}, {d_in[10:4]}} + 1;
  assign d_w2 = sel ? d_w1 : 8'b01111111;

  always_ff @ (posedge clk) begin
    d_out <= (rst) ? 0 : d_w2;
  end

endmodule
