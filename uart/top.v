`include "uart_rx.v"
`include "ram_block.v"


module top(input CLK , PMODL2, PMODL4, output PMOD1, PMOD2, PMOD3, PMOD4, PMOD5, PMOD6, PMOD7, PMOD8, PMODL1, PMODL3 );

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

	wire valid_byte;
    	wire [7:0] byte_buffer_in;
    	wire error; 
    	reg reset; // Active-high reset
    	wire rts;
    	wire tx;
    	assign PMODL1 = rts;
    	assign PMODL3 = tx;
	// USB<-->SERIAL UART PMOD	
	// C5 / PMODL3 - TXD
	// B6 / PMODL4 - RXD
	// A3 / PMODL1 - RTS#
	// B3 / PMODL2 - CTS# 
	uart_rx uart_in ( .clk (CLK), .reset (reset), .rx (PMODL4), .tx ( PMODL3 ), .cts (PMODL2), .rts (PMODL1), .data_read (byte_buffer_in), .valid_byte (valid_byte), .error (error) );
	
 	
	initial begin
		counter = 0;
		leds = 1;
		direction = 1;
		leds_next = 1;
		reset = 0;
		rts = 1; // low is off
		tx = 0;
	end
	
	
	always @ (posedge valid_byte ) begin
		leds <= byte_buffer_in; 
	end
	
	
	
	/*always @ (posedge CLK ) begin
		counter <= counter + 1;
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
		end
		
	end */
	

    		
endmodule


