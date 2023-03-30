module top(input CLK, output LED, PMOD1, PMOD2, PMOD3, PMOD4, PMOD5, PMOD6, PMOD7, PMOD8);
	reg [31:0] counter;
	reg [7:0] leds;
	reg [7:0] shifted_leds;
	reg [3:0] shift;
	reg [3:0] shift_next;
	
	assign PMOD7 = !leds[7];
	assign PMOD5 = !leds[6];
	assign PMOD3 = !leds[5];
	assign PMOD1 = !leds[4];
	assign PMOD8 = !leds[3];
	assign PMOD6 = !leds[2];
	assign PMOD4 = !leds[1];
	assign PMOD2 = !leds[0];
	assign LED = !counter[23];

	
	initial begin
		counter = 0;
		shift_next = 4;
		shifted_leds = 8'b00010000;
	end
	
	always @ (posedge CLK) begin
		leds <= shifted_leds;
		shift <= shift_next;
		counter <= counter + 1;
	end
	
	always @ (counter[24]) begin
		if( shift<7 ) begin
			shift_next <= shift + 1;
			shifted_leds <= leds << 1;
		end
		else begin 
			shift_next <= 0;
			shifted_leds <= 8'b00000001;
		end
	end
	
endmodule

