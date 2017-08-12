# ramfile
Generic RAM blocks described in Verilog HDL for FPGA Verification.

It's merely a RTL model without any gate-level descriptions, and only used for the verification.

<br/>dpram_sclk.v      (a dual-port synchronous RAM file)
<br/>dpram_async.v     (a dual-port asynchronous RAM file)
<br/>cpram_sclk_2w1r.v (2 writing ports, 1 reading port synchronous RAM file)
<br/>cpram_sclk_4w1r.v (4 writing ports, 1 reading port synchronous RAM file)

## parameters

```verilog
parameter ADDR_WIDTH = 32    /* the bits of address bus */
parameter DATA_WIDTH = 32    /* the bits of data bus */
parameter CLEAR_ON_INIT = 1  /* set the initial zero ? (only for simulation) */
parameter ENABLE_BYPASS = 1  /* enable the bypass network ? */
```
