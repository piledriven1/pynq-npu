`timescale 1ns / 1ps

module reg_arr0(
  input logic clk, rst, en_reg_array, rd_reg, wrt_reg,
  input logic [5:0] addr,
  input logic [7:0] dA_in, dB_in, dC_in,
  output logic [15:0] dA_reg, dB_reg, dC_reg
);

  // 4x4x4 array of 8-bit registers
  logic [7:0] reg_arr_A [4][4][4];
  logic [7:0] reg_arr_B [4][4][4];
  logic [7:0] reg_arr_C [4][4][4];

  always_ff @(posedge clk) begin
    if(rst) begin
      {dA_reg, dB_reg, dC_reg} <= {16'b0, 16'b0, 16'b0};
      reg_arr_A <= '{default: '0};
      reg_arr_B <= '{default: '0};
      reg_arr_C <= '{default: '0};
    end else begin
      if(en_reg_array) begin
        if(wrt_reg) begin
            reg_arr_A[addr[5:4]][addr[3:2]][addr[1:0]] <= dA_in;
            reg_arr_B[addr[5:4]][addr[3:2]][addr[1:0]] <= dB_in;
            reg_arr_C[addr[5:4]][addr[3:2]][addr[1:0]] <= dC_in;
        end else begin
          reg_arr_A <= reg_arr_A;
          reg_arr_B <= reg_arr_B;
          reg_arr_C <= reg_arr_C;
        end
        if(rd_reg) begin
          dA_reg <= reg_arr_A[addr[5:4]][addr[3:2]][addr[1:0]];
          dB_reg <= reg_arr_B[addr[5:4]][addr[3:2]][addr[1:0]];
          dC_reg <= reg_arr_C[addr[5:4]][addr[3:2]][addr[1:0]];
        end else begin
          {dA_reg, dB_reg, dC_reg} <= {dA_reg, dB_reg, dC_reg};
        end
      end else begin
        reg_arr_A <= reg_arr_A;
        reg_arr_B <= reg_arr_B;
        reg_arr_C <= reg_arr_C;
      end
    end
  end

endmodule
