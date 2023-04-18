`include "uart_send.v"
`include "ram_block.v"

module uart (
    input wire clk, // 50 MHz clock
    input wire reset, // Active-high reset
    input wire tx_data_ready, // Signals new data to transmit
    input wire [7:0] tx_data, // Data to transmit
    output reg tx, // Transmitted data
    output reg tx_busy // Indicates when the UART is transmitting
);

// Constants for the baud rate and counter
localparam BAUD_RATE = 115200;
localparam CLK_RATE = 12000000;
localparam COUNTER_MAX = CLK_RATE / BAUD_RATE - 1;

// Internal signals and registers
reg [15:0] counter;
reg [9:0] shift_reg;
reg [3:0] bit_counter;

// UART state machine
always @(posedge clk or posedge reset) begin
    if (reset) begin
        tx <= 1'b1;
        tx_busy <= 1'b0;
        counter <= 16'b0;
        shift_reg <= 10'b0;
        bit_counter <= 4'b0;
    end else begin
        // Baud rate counter
        if (counter == COUNTER_MAX) begin
            counter <= 16'b0;

            // State machine
            case (bit_counter)
                4'b0: begin // Idle
                    if (tx_data_ready) begin
                        tx_busy <= 1'b1;
                        shift_reg <= {1'b1, tx_data, 1'b0}; // Start bit, data bits, stop bit
                        tx <= 1'b0; // Start bit
                        bit_counter <= 4'b1;
                    end
                end
                4'b1001: begin // Stop bit
                    tx <= 1'b1;
                    tx_busy <= 1'b0;
                    bit_counter <= 4'b0;
                end
                default: begin // Data bits
                    tx <= shift_reg[0];
                    shift_reg <= shift_reg >> 1;
                    bit_counter <= bit_counter + 1;
                end
            endcase
        end else begin
            counter <= counter + 1;
        end
    end
end

endmodule


module top(input CLK, output PMODL1, PMODL2, PMODL3, PMODL4, PMODR1, PMODR2, PMODR4 );
	reg [31:0] counter;
	reg [7:0] leds;
	reg [7:0] leds_next;
	reg [0:0] direction;
		
	//assign PMODR1 = !leds[7];
	assign PMODR2 = !leds[6];
	//assign PMODR3 = !leds[5];
	assign PMODR4 = !leds[4];
	assign PMODL4 = !leds[3];
	assign PMODL3 = !leds[2];
	assign PMODL2 = !leds[1];
	assign PMODL1 = !leds[0];

	
	initial begin
		counter = 0;
		leds = 1;
		direction = 1;
		leds_next = 1;
	end
	
	always @ (posedge CLK) begin
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
	
    	reg [0:0] treset; // Active-high reset IN
    	reg [0:0] ttx_data_ready; // Signals new data to transmit IN
    	reg [7:0] ttx_data; // Data to transmit IN
   	//reg [0:0] ttx; // Transmitted data  OUT
    	reg [0:0] ttx_busy; // Indicates when the UART is transmitting OUT
 
 
 	uart uart_sender ( .clk (CLK), .reset (treset), .tx_data_ready (ttx_data_ready), .tx_data (ttx_data), .tx (PMODR1), .tx_busy (ttx_busy) );
 
	always @ (posedge CLK) begin
		ttx_data <= 'd67; // ASCII capital C
		ttx_data_ready <= 1;
		treset <= 0;
	end
	
endmodule


