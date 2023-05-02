`timescale 1ns/100ps

`include "uart_rx.v"

module uart_tb;

	// Declare wires for input and output
	// input
	reg CLK;
	wire PMODL2;
	reg PMODL4;
	// output
	wire PMOD1, PMOD2, PMOD3, PMOD4, PMOD5, PMOD6, PMOD7, PMOD8, PMODL1, PMODL3;
	
 
 	// Instantiate the design module 
	reg [31:0] counter;
	wire [7:0] leds;
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
	// USB<-->SERIAL UART PMOD	
	// C5 / PMODL3 - TXD
	// B6 / PMODL4 - RXD
	// A3 / PMODL1 - RTS#
	// B3 / PMODL2 - CTS# 
	
	uart_rx uart_in ( .clk (CLK), .reset (reset), .rx (PMODL4), .tx ( PMODL3 ), .cts (PMODL2), .rts (PMODL1), .data_read (byte_buffer_in), .valid_byte (valid_byte), .error (error), .debug( leds)  );

    // Apply test stimuli and display outputs
    initial begin
    	CLK = 0;
    	reset = 0;
        // Apply input values
        #20 PMODL4 = 1;
        #20 PMODL4 = 0;
        #20 PMODL4 = 1;
        #20 PMODL4 = 0;
        #20 PMODL4 = 1;
        #20 PMODL4 = 0;
        #20 PMODL4 = 1;
        #20 PMODL4 = 0;
        #20 PMODL4 = 1;
        #20 PMODL4 = 0;
        
        // Wait some time and finish the simulation
        #20 $finish;
    end

    // Monitor and display the inputs and outputs
    initial begin
        $monitor("At time %t: PMODL4=%b byte_buffer_in=%b", $time, PMODL4, byte_buffer_in);
    end
    
    // Generate the clock signal with a period of 20ns
    always begin
        #10 CLK = ~CLK;  // Toggle the clock signal every 10ns (half-period)
    end
    
    
endmodule
