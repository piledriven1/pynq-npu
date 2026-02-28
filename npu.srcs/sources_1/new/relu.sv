`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/27/2026 02:27:06 AM
// Design Name: 
// Module Name: relu
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module relu(
  input logic clk, rst, en_relu,
  input logic [15:0] d_in,
  output logic [15:0] relu_out
);

  logic [15:0] d_reg;

  always_comb begin
    d_reg = (d_in[15]) ? 0 : d_in;
  end
  
  always_ff @ (posedge clk) begin
    if(rst) begin
      relu_out <= 0;
    end else begin
      relu_out <= d_reg;
    end
  end
endmodule
