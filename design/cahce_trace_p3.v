module cache_trace_p3 (
    input clk,
    input rst,
    input enable,
    input [15:0] addr,
    input stall,
    input halt,
    output req,
    output hit,
    output miss

);

  reg [15:0] addr_d;
  reg stall_d, rst_d;

  always @(posedge clk) begin
    rst_d <= rst;
    if (rst) begin
      addr_d <= 16'h0;
    end else begin
      addr_d <= addr;
    end

  end

  wire tracking_enabled = ~rst & enable;
  wire addr_changed = addr != addr_d;
  // req: not halt or reset, but either clock came out of reset or address changed, and enable.
  assign req  = tracking_enabled & (rst_d | addr_changed);
  // Hit is defined as enable/stall and it didn't just stop stalling,
  // as the first clock after stall drop is the miss now "hitting".
  assign hit  = tracking_enabled & ~stall & addr_changed;
  assign miss = req & ~hit;
endmodule  // hit_detect
