# ramfile
Generic RAM blocks described in Verilog HDL for FPGA Verification.

It's only a RTL model without any gate-level description, and only used for the verification.

dpram_sclk.v      (a dual-port synchronous RAM file)
dpram_async.v     (a dual-port asynchronous RAM file)
cpram_sclk_2w1r.v (2 writing ports, 1 reading ports synchronous RAM file)
cpram_sclk_4w1r.v (4 writing ports, 1 reading ports synchronous RAM file)

## parameters

```verilog
parameter ADDR_WIDTH = 32    /* the bits of address bus */
parameter DATA_WIDTH = 32    /* the bits of data bus */
parameter CLEAR_ON_INIT = 1  /* set initial zero ? (only for simulation) */
parameter ENABLE_BYPASS = 1  /* enable the bypass network ? */
```
