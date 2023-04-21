
module uart_rx (
    input wire clk,
    input wire reset,
    input wire rx,
    input wire cts, // Clear to Send (CTS) input
    output reg rts, // Request to Send (RTS) output
    output reg [7:0] data_read,
    output reg valid_byte,
    output reg error
);

// Set your desired baud rate and correct FPGA clock rate
parameter BAUD_RATE = 115200; // change as required
parameter CLK_FREQ = 12000000; // change as required
parameter [31:0] TICKS_PER_UART_MAX = CLK_FREQ / BAUD_RATE - 1;
parameter [31:0] TICKS_PER_UART_HALF_CLOCK_CYCLE = TICKS_PER_UART_MAX / 2;

// UART states (keep track of two states, one for RX, one for TX)
parameter WAIT				= 3'b000;
parameter START_BIT_FALLING_EDGE	= 3'b001; // at beginning of start bit
parameter START_BIT			= 3'b010;
parameter FIRST_BIT_READ		= 3'b011;
parameter DATA_BIT_READ			= 3'b100;
parameter LAST_BIT_READ			= 3'b101;


reg [2:0] rx_state = WAIT;
reg [2:0] tx_state = WAIT;

reg [31:0] counter = 0;
reg [3:0] bit_count = 0;
reg state = WAIT;
reg uart_clock = 0;

initial begin
	counter = 0;
	error = 0;
	bit_count =0;
	rx_state = WAIT;
	rts = 1'b0; // Assert RTS signal
	uart_clock = 0;
end

always @(negedge rx) begin
	if ( rx_state == WAIT ) begin
		// Start bit of next byte.
		rx_state <= START_BIT_FALLING_EDGE;
		// sync counter
		counter <= 0;
		bit_count <= 0;
	end
end

always @( posedge uart_clock or posedge reset ) begin
    if (reset) begin
        counter <= 0;
        bit_count <= 0;
 	valid_byte = 0;
	state <= WAIT;
        rts <= 1'b0; // Assert RTS signal
    end 
    else begin
        case (rx_state)
            START_BIT_FALLING_EDGE: begin
            	// check rx is low for start bit, or trigger error
            	if( rx == 0 ) begin
            		state <= START_BIT;	
            	end
            	else begin
            		state = ERROR;
            		error = 1;
            		valid_byte = 0;
            		counter = 0;
  		        rts <= 1'b1; // Unassert RTS signal   	
            	end
            end
            START_BIT: begin
            	// Now in:
            	state = FIRST_BIT_READ;
            	data_read[0] = rx;
            	bit_count = 0;
            end
            FIRST_BIT_READ: begin
            	// Now in:
            	state = DATA_BIT_READ;
            	data_read[bit_counter+1] <= rx;
            	bit_count <= bit_count + 1;
            end
            DATA_BIT_READ: begin
            	if( bit_counter < 6 ) begin
            		data_read[bit_counter+1] <= rx;	
		   	bit_count <= bit_count + 1;
   	            	// Now in:
   	            	if( bit_counter == 7) begin
			   	state = LAST_BIT_READ;
			   	valid_byte = 1;
			end
		end            
            end
            LAST_BIT_READ: begin
            	// check for high stop bit
            	if( rx == 1) begin
            		state = WAIT; // start wait for next new byte
            	end
            	else begin
                     	state = ERROR;
	      		error = 1;
            		valid_byte = 0;
            		counter = 0;
            		rts <= 1'b1; // Unassert RTS signal   	
            	end
            end            
            ERROR: begin            
              // count 20 uart cycles and then set rts high ???
            end
        endcase
    end
end

always @(posedge clk) begin
    counter <= counter + 1;
    if (counter<=TICKS_PER_UART_HALF_CLOCK_CYCLE ) begin
    	uart_clock<=0;
    end
    else begin
    	uart_clock<=1;
    end
    if( counter >= TICKS_PER_UART_MAX) begin
    	counter <= 0;
    end
end

endmodule

