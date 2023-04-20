`include "uart_rx.v"
`include "ram_block.v"


module top(input CLK, output PMODL1, PMODL2, PMODL3, PMODL4, PMODR1, PMODR2, PMODR4 );
	
	// 8x LED PMOD
	assign PMOD7 = !leds[7];
	assign PMOD5 = !leds[6];
	assign PMOD3 = !leds[5];
	assign PMOD1 = !leds[4];
	assign PMOD8 = !leds[3];
	assign PMOD6 = !leds[2];
	assign PMOD4 = !leds[1];
	assign PMOD2 = !leds[0];

	reg [31:0] counter;
	reg [7:0] leds;
	reg [7:0] leds_next;
	reg [0:0] direction;

    	
	// USB<-->SERIAL UART PMOD	
	assign PMODL4 = !leds[3];  // C5 - TXD
	assign PMODL3 = !leds[2];  // B6 - RXD
	assign PMODL2 = !leds[1];  // A3 - RTS#
	assign PMODL1 = !leds[0];  // B3 - CTS#
	
    	reg [0:0] reset; // Active-high reset IN
    	reg [0:0] tx_data_ready; // Signals new data to transmit IN
    	reg [7:0] tx_data; // Data to transmit IN
    	reg [0:0] tx_busy; // Indicates when the UART is transmitting OUT
    	wire [7:0] byte_buffer_in;
    	wire valid_byte;
    	    	
	uart_rx uart_in ( .clk (CLK), .reset (reset), .rx (PMODL4), .cts (PMODL1), .rts (PMODL2), .data_read (byte_buffer_in), .valid_byte(valid_byte) );
 	
	initial begin
		counter = 0;
		leds = 1;
		direction = 1;
		leds_next = 1;
		address = 0;
	end
	
	always @ (posedge valid_byte ) begin
		leds <= byte_buffer_in;
	end
	
	
/*	always @ (posedge CLK) begin
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
		
	end
*/	

    		
endmodule


