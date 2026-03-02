`timescale 1ns / 1ps

module fsm(
  input logic clk, rst_fsm, en_fsm, en_wrt,
  output logic rst, en_bias, rd_reg, wrt_reg, en_pe, en_reg_array, en_relu, layer3_sel
);

  typedef enum logic [3:0] {
    INIT = 0,
    IDLE = 1,
    WRITE = 2,
    READ = 3,
    BIAS_ADDR_RD_EN = 4,
    COMPARE = 5,
    RST_COMP = 6,
    DONE = 7
  } state_t;
  state_t PS, NS;

  logic layer3_fsm, en_rd, en_comp, en_rst_comp, done;

  always_ff @ (posedge clk) begin
    if(rst_fsm)
      PS <= IDLE;
    else
      PS <= NS;
  end

  always_comb begin
    layer3_fsm = 0;
    en_rd = 0;
    en_comp = 0;
    en_rst_comp = 0;
    done = 0;

    rst = 0;
    en_bias = 0;
    rd_reg = 0;
    wrt_reg = 0;
    en_pe = 0;
    en_reg_array = 0;
    en_relu = 0;
    layer3_sel = 0;

    case(PS)
      INIT: begin
        NS = IDLE;
        rst = 1;
      end
      IDLE: begin
        if(layer3_sel) begin
          
        end else begin
          
        end
        NS = (en_wrt) ? WRITE : IDLE;
      end
      WRITE: begin
        if(layer3_sel) begin
          
        end else begin
          wrt_reg = 1;
        end
        NS = (en_rd) ? READ : WRITE;
      end
      READ: begin
        if(layer3_sel) begin
          NS = IDLE;
        end else begin
          if(en_bias && rd_reg) begin
            NS = BIAS_ADDR_RD_EN;
          end else if(en_comp) begin
            NS = COMPARE;
          end else if(en_rst_comp) begin
            NS = RST_COMP;
          end else begin
            NS = DONE;
          end
        end
      end
      BIAS_ADDR_RD_EN: begin
        NS = (en_pe) ? DONE : COMPARE;
      end
      COMPARE: begin
        NS = (en_pe) ? WRITE : RST_COMP;
      end
      RST_COMP: begin
        NS = (en_pe) ? WRITE : DONE;
      end
      DONE: begin
        NS = (rst) ? IDLE : DONE;
      end
      default: begin
        NS = INIT;
      end
    endcase
  end

endmodule
