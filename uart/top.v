`include "uart_rx.v"
`include "ram_block.v"


module top(input CLK, PMODL1, PMODL3 output PMOD1, PMOD2, PMOD3, PMOD4, PMOD5, PMOD6, PMOD7, PMOD8, PMODL2, PMODL4 );
	
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


    	reg [0:0] reset; // Active-high reset
    	wire [7:0] byte_buffer_in;
    	wire valid_byte;
    	wire error;

	// USB<-->SERIAL UART PMOD	
	// C5 / PMODL4 - TXD
	// B6 / PMODL3 - RXD
	// A3 / PMODL2 - RTS#
	// B3 / PMODL1 - CTS# 
	uart_rx uart_in ( .clk (CLK), .reset (reset), .rx (PMODL3), .cts (PMODL1), .rts (PMODL2), .data_read (byte_buffer_in), .valid_byte(valid_byte), .error (error) );
 	
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
	
	
	always @ (error==1) begin
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
	

    		
endmodule


