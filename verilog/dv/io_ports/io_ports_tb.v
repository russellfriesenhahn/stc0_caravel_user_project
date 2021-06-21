// SPDX-FileCopyrightText: 2020 Efabless Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0

`default_nettype none

`timescale 1 ns / 1 ps

`include "uprj_netlists.v"
`include "caravel_netlists.v"
`include "spiflash.v"

module io_ports_tb;
	reg clock;
	reg RSTB;
	reg CSB;
	reg power1, power2;
	reg power3, power4;

    	wire gpio;
    	wire [37:0] mprj_io;
	wire [7:0] mprj_io_0;

    reg [37:0] mprj_i;


    assign mprj_io[36] = mprj_i[36];
    assign mprj_io[34] = mprj_i[34];
    //assign mprj_io[32] = mprj_i[32];
    assign mprj_io[32] = extClk;
    assign mprj_io[31] = mprj_i[31];
    assign mprj_io[30:27] = Ingress[7:4];
    assign mprj_io[25:22] = Ingress[3:0];
    assign mprj_io[26] = IngressValid;


    assign mprj_io[10] = mprj_i[10];
    assign mprj_io[8] = mprj_i[8];

    reg [7:0] Ingress = 0;
    reg  IngressValid = 0;
    wire [7:0] Egress = {mprj_io[20:17],mprj_io[15:12]};
    wire EgressValid = mprj_io[16];
    reg extClk;
    wire LFSRext0 = mprj_io[33];
    wire LFSRext1 = mprj_io[35];
    wire LFSRint0 = mprj_io[11];
    wire LFSRint1 = mprj_io[9];

    reg [7:0] lfsrByteExt0;
    reg [7:0] lfsrByteExt1;
    reg [7:0] lfsrByteInt0;
    reg [7:0] lfsrByteInt1;

	assign mprj_io_0 = mprj_io[7:0];
	// assign mprj_io_0 = {mprj_io[8:4],mprj_io[2:0]};

	assign mprj_io[3] = (CSB == 1'b1) ? 1'b1 : 1'bz;
	// assign mprj_io[3] = 1'b1;

	// External clock is used by default.  Make this artificially fast for the
	// simulation.  Normally this would be a slow clock and the digital PLL
	// would be the fast clock.

	always #5 clock <= (clock === 1'b0);

	always #6 extClk <= (extClk === 1'b0);

	initial begin
		clock = 0;
        extClk = 0;
	end

    always @(posedge extClk or negedge mprj_i[36]) begin
        if (mprj_i[36] == 1'b0) begin
            lfsrByteExt0 <= 0;
            lfsrByteExt1 <= 0;
        end else begin
            lfsrByteExt0 <= {lfsrByteExt0[6:0], LFSRext0};
            lfsrByteExt1 <= {lfsrByteExt1[6:0], LFSRext1};
        end
    end
    always @(posedge clock or negedge mprj_i[8]) begin
        if (mprj_i[8] == 1'b0) begin
            lfsrByteInt0 <= 0;
            lfsrByteInt1 <= 0;
        end else begin
            lfsrByteInt0 <= {lfsrByteInt0[6:0], LFSRint0};
            lfsrByteInt1 <= {lfsrByteInt1[6:0], LFSRint1};
        end
    end
	initial begin
		$dumpfile("io_ports.lxt2");
		$dumpvars(0, io_ports_tb);

		// Repeat cycles of 1000 clock edges as needed to complete testbench
		repeat (50) begin
			repeat (1000) @(posedge clock);
			// $display("+1000 cycles");
		end
		$display("%c[1;31m",27);
		`ifdef GL
			$display ("Monitor: Timeout, Test Mega-Project IO Ports (GL) Failed");
		`else
			$display ("Monitor: Timeout, Test Mega-Project IO Ports (RTL) Failed");
		`endif
		$display("%c[0m",27);
		$finish;
	end

	initial begin
        //mprj_i[31] <= 1'b0;
        //mprj_i[36] <= 1'b0;
        //mprj_i[8] <= 1'b0;
	    // Observe Output pins [7:0]
	    //wait(mprj_io_0 == 8'h01);
	    //wait(mprj_io_0 == 8'h02);
	    //wait(mprj_io_0 == 8'h03);
    	    //wait(mprj_io_0 == 8'h04);
	    //wait(mprj_io_0 == 8'h05);
            //wait(mprj_io_0 == 8'h06);
	    //wait(mprj_io_0 == 8'h07);
            //wait(mprj_io_0 == 8'h08);
	    //wait(mprj_io_0 == 8'h09);
            //wait(mprj_io_0 == 8'h0A);   
	    //wait(mprj_io_0 == 8'hFF);
	    //wait(mprj_io_0 == 8'h00);
		
        //mprj_i[31] <= 1'b1;
        //mprj_i[36] <= 1'b1;
        //mprj_i[8] <= 1'b1;
        wait(CSB == 1'b0)
        wait(Egress == 8'hDE);
        wait((lfsrByteExt0 == 8'h47) && (lfsrByteExt1 == 8'hD6))
        wait((lfsrByteInt0 == 8'hDB) && (lfsrByteInt1 == 8'h9A))

        //#100000
		`ifdef GL
	    	$display("Monitor: Test 1 Mega-Project IO (GL) Passed");
		`else
		    $display("Monitor: Test 1 Mega-Project IO (RTL) Passed");
		`endif
	    $finish;
	end

	initial begin
        mprj_i <= 0;
		RSTB <= 1'b0;
		CSB  <= 1'b1;		// Force CSB high
		#2000;
		RSTB <= 1'b1;	    	// Release reset
		#170000;
		CSB = 1'b0;		// CSB can be released
        mprj_i[31] <= 1'b1;
        mprj_i[36] <= 1'b1;
        mprj_i[8] <= 1'b1;
	end

	initial begin		// Power-up sequence
		power1 <= 1'b0;
		power2 <= 1'b0;
		power3 <= 1'b0;
		power4 <= 1'b0;
		#100;
		power1 <= 1'b1;
		#100;
		power2 <= 1'b1;
		#100;
		power3 <= 1'b1;
		#100;
		power4 <= 1'b1;
	end

	always @(mprj_io) begin
		#1 $display("MPRJ-IO state = %b ", mprj_io[7:0]);
	end

	wire flash_csb;
	wire flash_clk;
	wire flash_io0;
	wire flash_io1;

	wire VDD3V3 = power1;
	wire VDD1V8 = power2;
	wire USER_VDD3V3 = power3;
	wire USER_VDD1V8 = power4;
	wire VSS = 1'b0;

	caravel uut (
		.vddio	  (VDD3V3),
		.vssio	  (VSS),
		.vdda	  (VDD3V3),
		.vssa	  (VSS),
		.vccd	  (VDD1V8),
		.vssd	  (VSS),
		.vdda1    (USER_VDD3V3),
		.vdda2    (USER_VDD3V3),
		.vssa1	  (VSS),
		.vssa2	  (VSS),
		.vccd1	  (USER_VDD1V8),
		.vccd2	  (USER_VDD1V8),
		.vssd1	  (VSS),
		.vssd2	  (VSS),
		.clock	  (clock),
		.gpio     (gpio),
        .mprj_io  (mprj_io),
		.flash_csb(flash_csb),
		.flash_clk(flash_clk),
		.flash_io0(flash_io0),
		.flash_io1(flash_io1),
		.resetb	  (RSTB)
	);

	spiflash #(
		.FILENAME("io_ports.hex")
	) spiflash (
		.csb(flash_csb),
		.clk(flash_clk),
		.io0(flash_io0),
		.io1(flash_io1),
		.io2(),			// not used
		.io3()			// not used
	);

endmodule
`default_nettype wire
