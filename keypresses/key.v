
module keypad_led(
    input clk,          	// clock input
    input [1:0] row,    	// row select input
    output [1:0] col,    // column output
    output [3:0] leds    	// LED outputs
);

// Declare internal wires and registers
reg [3:0] leds_next;
reg [1:0] col_synced;
reg [1:0] col_next;

initial begin
	leds = 4'b0000;
	leds_next = 4'b0000;
end

// Assign the current LED values to the LED outputs
always @(*) begin
    leds = leds_next;
end

// Update the column value based on the row select input
always @(posedge clk) begin
    col <= col_next;
end

// Logic for updating the column and LED values based on the keypad input
always @(*) begin
    case({row, col})
        4'b10_10: begin col_next = 2'b01; leds_next = 4'b0001; end
        4'b10_01: begin col_next = 2'b10; leds_next = 4'b0010; end
        4'b01_10: begin col_next = 2'b01; leds_next = 4'b0100; end
        4'b01_01: begin col_next = 2'b10; leds_next = 4'b1000; end
        default: begin col_next = 2'b01; leds_next = 4'b0000; end
    endcase
end

endmodule



module top(input CLK, PMODL3, PMODL4, output PMODL1, PMODL2, PMOD2, PMOD4, PMOD6, PMOD8  ); /* PMOD1, PMOD2, PMOD3, PMOD4, PMOD5, PMOD6, PMOD7, PMOD8 */
	/* LEDs */
	/* PMOD8, PMOD6, PMOD4, PMOD2, PMOD7, PMOD5, PMOD3, PMOD1 */
	/* check lines 	PMODL2, PMODL4 */
	/* scan lines PMODL1 and PMODL3  (B3, B6) to read off key presses */
	// Declare internal wires and registers
	reg [3:0] leds;
	reg [1:0] col;
	reg [1:0] row;
	assign row[0] = PMODL3;
	assign row[1] = PMODL4;
	assign PMODL1 = col[0];
	assign PMODL2 = col[1];
	assign PMOD2 = leds[0];
	assign PMOD4 = leds[1];
	assign PMOD6 = leds[2];	
	assign PMOD8 = leds[3];
	
	keypad_led kp (
		.clk (CLK),
		.row ( row ),
		.col ( col ),
		.leds ( leds )
		);
		
endmodule






