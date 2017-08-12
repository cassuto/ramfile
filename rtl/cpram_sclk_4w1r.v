/**@file
 * combi port Sync RAM (2write 1read).
 */

/**@notice
 * don't try to write to the same address though multi-ports.
 */
 
/*
 * OpenProcessor-X architecture (OpenPX)
 *
 * Copyleft (C) 2016, the 1st Middle School in Yongsheng,Lijiang,China
 * This file is part of OpenPX (Open Processor-X architecture)
 * project. It is a free item; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License (GPL), in version 2
 * as it comes in the "COPYING" file of the OpenPX distribution. OpenPX
 * is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY of any kind.
 */

module cpram_sclk_4w1r
#(
    parameter ADDR_WIDTH = 5,
    parameter DATA_WIDTH = 32,
    parameter CLEAR_ON_INIT = 1,
    parameter ENABLE_BYPASS = 1
)
(
    clk,
    rst,
    we1,
    waddr1,
    wdata1,
    we2,
    waddr2,
    wdata2,
    we3,
    waddr3,
    wdata3,
    we4,
    waddr4,
    wdata4,
    re,
    raddr,
    rdata
);

/*
 Ports
 */
input                           clk;
input                           rst;
input                           we1;
input [ADDR_WIDTH-1:0]          waddr1;
input [DATA_WIDTH-1:0]          wdata1;
input                           we2;
input [ADDR_WIDTH-1:0]          waddr2;
input [DATA_WIDTH-1:0]          wdata2;
input                           we3;
input [ADDR_WIDTH-1:0]          waddr3;
input [DATA_WIDTH-1:0]          wdata3;
input                           we4;
input [ADDR_WIDTH-1:0]          waddr4;
input [DATA_WIDTH-1:0]          wdata4;
input                           re;
input [ADDR_WIDTH-1:0]          raddr;
output [DATA_WIDTH-1:0]         rdata;

/*
 Internals
 */
wire [DATA_WIDTH-1:0]           dout;
wire [DATA_WIDTH-1:0]           dout0;
wire [DATA_WIDTH-1:0]           dout1;
wire [DATA_WIDTH-1:0]           dout2;
wire [DATA_WIDTH-1:0]           dout3;
reg [1:0]                       sel_map[(1<<ADDR_WIDTH)-1:0];

// instance of sync dpram #0
dpram_sclk
    #(
      .ADDR_WIDTH       (ADDR_WIDTH),
      .DATA_WIDTH       (DATA_WIDTH),
      .CLEAR_ON_INIT    (CLEAR_ON_INIT),
      .ENABLE_BYPASS    (ENABLE_BYPASS)
    )
   mem0
    (
      .clk          (clk),
      .rst          (rst),
      .dout         (dout0),
      .raddr        (raddr),
      .re           (re),
      .waddr        (waddr1),
      .we           (we1),
      .din          (wdata1)
    );
// instance of sync dpram #1
dpram_sclk
    #(
      .ADDR_WIDTH       (ADDR_WIDTH),
      .DATA_WIDTH       (DATA_WIDTH),
      .CLEAR_ON_INIT    (CLEAR_ON_INIT),
      .ENABLE_BYPASS    (ENABLE_BYPASS)
    )
   mem1
    (
      .clk          (clk),
      .rst          (rst),
      .dout         (dout2),
      .raddr        (raddr),
      .re           (re),
      .waddr        (waddr2),
      .we           (we2),
      .din          (wdata2)
    );
// instance of sync dpram #2
dpram_sclk
    #(
      .ADDR_WIDTH       (ADDR_WIDTH),
      .DATA_WIDTH       (DATA_WIDTH),
      .CLEAR_ON_INIT    (CLEAR_ON_INIT),
      .ENABLE_BYPASS    (ENABLE_BYPASS)
    )
   mem2
    (
      .clk          (clk),
      .rst          (rst),
      .dout         (dout3),
      .raddr        (raddr),
      .re           (re),
      .waddr        (waddr3),
      .we           (we3),
      .din          (wdata3)
    );
// instance of sync dpram #3
dpram_sclk
    #(
      .ADDR_WIDTH       (ADDR_WIDTH),
      .DATA_WIDTH       (DATA_WIDTH),
      .CLEAR_ON_INIT    (CLEAR_ON_INIT),
      .ENABLE_BYPASS    (ENABLE_BYPASS)
    )
   mem3
    (
      .clk          (clk),
      .rst          (rst),
      .dout         (dout3),
      .raddr        (raddr),
      .re           (re),
      .waddr        (waddr4),
      .we           (we4),
      .din          (wdata4)
    );
    
    // mux
assign dout = sel_map[raddr]==2'd0 ? dout0 :
              sel_map[raddr]==2'd1 ? dout1 :
              sel_map[raddr]==2'd2 ? dout2 :
              sel_map[raddr]==2'd3 ? dout3 :
              {DATA_WIDTH{1'b0}}; /* never got this */

    /*
     Read
     */
generate
    if (ENABLE_BYPASS) begin : bypass_gen
assign rdata =
        (we1 && (raddr==waddr1)) ? wdata1 :
        (we2 && (raddr==waddr2)) ? wdata2 :
        (we3 && (raddr==waddr3)) ? wdata3 :
        (we4 && (raddr==waddr4)) ? wdata4 :
        dout;
    end else begin
assign rdata = dout;
    end
endgenerate
    
    /*
     Process selection map
     */
    always @(posedge clk) begin
        if (we1)
            sel_map[waddr1] <= 2'd0;
        if (we2)
            sel_map[waddr2] <= 2'd1;
        if (we3)
            sel_map[waddr3] <= 2'd2;
        if (we4)
            sel_map[waddr4] <= 2'd3;
    end
endmodule
