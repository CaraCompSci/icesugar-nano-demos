/* PMOD2 unused */
module top(input CLK, PMODL1, PMODL2, output PMODL3, PMODL4, PMOD1, PMOD3, PMOD4, PMOD5, PMOD6, PMOD7, PMOD8 );
	reg [6:0] leds;
	assign PMOD7 = ~leds[0];
	assign PMOD5 = ~leds[1];
	assign PMOD3 = ~leds[2];
	assign PMOD1 = ~leds[3];
	assign PMOD8 = ~leds[4];
	assign PMOD6 = ~leds[5];
	assign PMOD4 = ~leds[6];

	initial begin
		leds <= 0;
	end
	
	always @(posedge CLK)
	begin
		PMODL4 <= 1;
		PMODL3 <= 0;
		if (PMODL1==1) begin leds <= 1;  end
		else if (PMODL2==1) begin leds <= 2; end
		else begin leds <= 127; end	
		PMODL3 <= 1;
		PMODL4 <= 0;
		if (PMODL1==1) begin leds <= 16;  end
		else if (PMODL2==1) begin leds <= 8; end
		else begin leds <= 127; end

	end
endmodule

