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
	
	parameter CHECK_LINE1 = 1;
	parameter CHECK_LINE2 = 2;
	parameter CHECK_LINE3 = 4;
	parameter CHECK_LINE4 = 8;

	reg [3:0] state;

	initial begin
		leds <= 0;
		state = CHECK_LINE1;
	end
	
	always @(posedge CLK)
	begin
		case( state )
			CHECK_LINE1 : begin
				PMODL3 = 1;
				PMODL4 = 0;
				if (PMODL1==1) begin
					leds <= 1;
				end
				else if (PMODL2==1) begin
					leds <= 2;
				end
				state = CHECK_LINE2;
			end
			CHECK_LINE2 : begin
				PMODL3 = 0;
				PMODL4 = 1;
				if (PMODL1==1) begin
					leds <= 4;
				end
				else if (PMODL2==1) begin
					leds <= 8;
				end
				state = CHECK_LINE3;			
			end
			CHECK_LINE3 : begin
				state = CHECK_LINE4;
			end
			CHECK_LINE4 : begin
				// Restart line check loop next clock
				state = CHECK_LINE1;
			end
			default	: begin end
		endcase
		
	end
endmodule

