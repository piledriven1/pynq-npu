`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/26/2026 05:26:12 PM
// Design Name: 
// Module Name: systolic
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


module systolic(
  input logic clk, rst, en_mac,
  input logic [7:0] a0, a1, b0, b1,
  output logic [15:0] p00, p01, p10, p11
);

  // systolic 2x2 array
  mac pe00 (.*, .A(a0), .B(b0), .C(p00));
  mac pe01 (.*, .A(a0), .B(b1), .C(p01));
  mac pe10 (.*, .A(a1), .B(b0), .C(p10));
  mac pe11 (.*, .A(a1), .B(b1), .C(p11));

endmodule
