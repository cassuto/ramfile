/**@file
 * Double port Sync RAM
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

module dpram_sclk
#(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32,
    parameter CLEAR_ON_INIT = 1,
    parameter ENABLE_BYPASS = 1
)
(
    clk,
    rst,
    raddr,
    re,
    waddr,
    we,
    din,
    dout
);

/*
 Ports
 */
input                           clk;
input                           rst;
input [ADDR_WIDTH-1:0]          raddr;
input                           re;
input [ADDR_WIDTH-1:0]          waddr;
input                           we;
input [DATA_WIDTH-1:0]          din;
output [DATA_WIDTH-1:0]         dout;
    
/*
 Internals
 */
reg [DATA_WIDTH-1:0]            mem[(1<<ADDR_WIDTH)-1:0];
reg [DATA_WIDTH-1:0]            rdata;
reg                             re_r;
wire [DATA_WIDTH-1:0]           dout_w;

    /*
     reset in verification
     */
generate
  if(CLEAR_ON_INIT) begin :clear_on_init
    integer               idx;
    initial
    for(idx=0; idx < (1<<ADDR_WIDTH); idx=idx+1)
        mem[idx] = {DATA_WIDTH{1'b0}};
  end
endgenerate

    /*
     bypass control
     */
generate
  if (ENABLE_BYPASS) begin : bypass_gen
    reg [DATA_WIDTH-1:0]  din_r;
    reg                   bypass;

    assign dout_w = bypass ? din_r : rdata;

    always @(posedge clk)
        if (re)
            din_r <= din;

    always @(posedge clk)
        if (waddr == raddr && we && re)
            bypass <= 1;
        else
            bypass <= 0;
  end else begin
    assign dout_w = rdata;
  end
endgenerate

integer idx;

/*
 Reset logic
 */
always @(posedge clk)
    if (rst) begin
        re_r <= 1'b0;
    end else
        re_r <= re;

assign dout = re_r ? dout_w : {DATA_WIDTH{1'b0}};

/*
 R/W logic
 */
always @(posedge clk) begin
    if (we)
        mem[waddr] <= din;
    if (re)
        rdata <= mem[raddr];
end

endmodule
