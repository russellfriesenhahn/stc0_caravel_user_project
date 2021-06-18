// vim: ts=4 sw=4 expandtab
//
// THIS IS GENERATED CODE.
// 
// This code is Public Domain.
// Permission to use, copy, modify, and/or distribute this software for any
// purpose with or without fee is hereby granted.
// 
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
// WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
// MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
// SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER
// RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT,
// NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE
// USE OR PERFORMANCE OF THIS SOFTWARE.

`ifndef LFSR_V_
`define LFSR_V_

// LFSR polynomial coeffiecients: x^32 + x^22 + x^2 + x^1 + 1
// LFSR width: 32 bits

`default_nettype none
module lfsr32 (
`ifdef USE_POWER_PINS
    inout vdda1,	// User area 1 3.3V supply
    inout vdda2,	// User area 2 3.3V supply
    inout vssa1,	// User area 1 analog ground
    inout vssa2,	// User area 2 analog ground
    inout vccd1,	// User area 1 1.8V supply
    inout vccd2,	// User area 2 1.8v supply
    inout vssd1,	// User area 1 digital ground
    inout vssd2,	// User area 2 digital ground
`endif
	input wire  Clk,
	input wire  ARstb,
	input wire  Enable,
	input wire  Load,
	input wire  [31:0] Seed,
	output wire LFSR0out,
    input  wire LFSR1in,
	output wire LFSR1out
);
    reg [31:0] lfsr0;
    reg [31:0] lfsr1;
    assign LFSR0out = lfsr0[0];
    assign LFSR1out = lfsr1[0];

    wire ARst;
    rstSync#(.NUM_SYNC_CLKS(5)) rstSync(.Clk(Clk),.ARstb(ARstb),.Rst(ARst));

	always @(posedge Clk or posedge ARst) begin
		if (ARst == 1'b1) begin
            lfsr0 <= 1;
            lfsr1 <= 1;
		end else begin
			if (Load == 1'b1) begin
                lfsr0 <= Seed;
                lfsr1 <= Seed;
			end else if (Enable == 1'b1) begin
                lfsr0[31:22] <= {lfsr0[0],lfsr0[31:23]};
                lfsr0[21] <= lfsr0[0] ^ lfsr0[22];
                lfsr0[20:2] <= lfsr0[21:3];
                lfsr0[1] <= lfsr0[0] ^ lfsr0[2];
                lfsr0[0] <= lfsr0[0] ^ lfsr0[1];

                lfsr1[31:22] <= {LFSR1in,lfsr1[31:23]};
                lfsr1[21] <= lfsr1[0] ^ lfsr1[22];
                lfsr1[20:2] <= lfsr1[21:3];
                lfsr1[1] <= lfsr1[0] ^ lfsr1[2];
                lfsr1[0] <= lfsr1[0] ^ lfsr1[1];
			end
		end
	end
endmodule
`endif // lfsr_reg_V_
`default_nettype wire
