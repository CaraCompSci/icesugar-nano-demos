`include "uart_rx.v"
`include "ram_block.v"


module top(
	input wire CLK,
	input wire PMODL2,
	input wire PMODL4,
	
	
	output wire PMOD1,
	output wire PMOD2,
	output wire PMOD3,
	output wire PMOD4,
	output wire PMOD5, 
	output wire PMOD6, 
	output wire PMOD7, 
	output wire PMOD8, 
	output wire PMODL1, 
	output wire PMODL3
);

	reg [31:0] counter;
	reg [7:0] leds;
	reg [7:0] leds_next;
	reg [0:0] direction;
	
	// 8x LED PMOD
	assign PMOD7 = !leds[7];
	assign PMOD5 = !leds[6];
	assign PMOD3 = !leds[5];
	assign PMOD1 = !leds[4];
	assign PMOD8 = !leds[3];
	assign PMOD6 = !leds[2];
	assign PMOD4 = !leds[1];
	assign PMOD2 = !leds[0];

	reg valid_byte;
    	reg [7:0] byte_buffer_in;
    	reg error; 
    	reg reset; // Active-high reset
    	assign PMODL1 = rts;
    	assign PMODL3 = tx;
	// USB<-->SERIAL UART PMOD	
	// C5 / PMODL3 - TXD
	// B6 / PMODL4 - RXD
	// A3 / PMODL1 - RTS#
	// B3 / PMODL2 - CTS# 
	
	uart_rx uart_in ( .clk (CLK), .reset (reset), .rx (PMODL4), .tx ( PMODL3 ), .cts (PMODL2), .rts (PMODL1), .data_read (byte_buffer_in), .valid_byte (valid_byte), .error (error), .debug( leds)  );
	
 	
	initial begin
		counter = 0;
		leds = 0;
		direction = 1;
		leds_next = 1;
		reset = 0;
	end
	
		
	always @(posedge CLK ) begin	
		if (valid_byte == 1 ) begin
			leds <= byte_buffer_in; 	
		end

		/*counter <= counter + 1;
		if (counter[10] && !counter[19]) begin
			leds <= leds_next;
		end
		if (counter[19]) begin
			if( direction ) begin
				if (leds == 'b10000000 ) begin
					leds_next <= leds >> 1;
					direction <= 0;
				end else begin
					leds_next <= leds << 1;		
				end
			end else begin
				if (leds == 'b00000001 ) begin
					leds_next <= leds << 1;
					direction <= 1;
				end else begin
					leds_next <= leds >> 1;		
				end
			end
		end*/
		
	end 
	    		
endmodule


