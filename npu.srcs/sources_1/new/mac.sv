`timescale 1ns / 1ps

module mac(
  input logic clk, rst, en_mac,
  input logic unsigned [7:0] A, B,
  output logic [15:0] C
);

  logic unsigned [15:0] prod, acc;

  // Use PYNQ's DSP48E1 for more efficient multiplication
  (* USE_DSP_48 = "yes" *)
  always_comb begin
    prod = A * B;
  end

  always_ff @ (posedge clk) begin
    if(rst)
      acc <= 0;
    else
      acc <= (en_mac) ? acc + prod : prod;
  end

  assign C = acc;

endmodule
