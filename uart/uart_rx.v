
module uart_rx (
    input wire clk,
    input wire reset,
    input wire rx,
    input wire cts, // Clear to Send (CTS) input
    output reg rts, // Request to Send (RTS) output
    output reg [7:0] data_read,
    output reg valid_byte
);

// Set your desired baud rate and correct FPGA clock rate
parameter BAUD_RATE = 115200; // change as required
parameter CLK_FREQ = 12000000; // change as required
parameter TICKS_PER_UART_CLOCK_CYCLE = CLK_FREQ / BAUD_RATE - 1;
parameter TICKS_PER_UART_HALF_CLOCK_CYCLE = COUNTER_MAX / TICKS_PER_UART_CLOCK_CYCLE;

// UART states (keep track of two states, one for RX, one for TX)
parameter STATE_WAIT			= 4'b0000;
parameter STATE_START_BIT_FALLING_EDGE	= 4'b0001; // at beginning of start bit
parameter STATE_START_BIT		= 4'b0010;
parameter STATE_START_OF_DATA_BIT	= 4'b0011;
parameter STATE_MIDDLE_OF_DATA_BIT	= 4'b0100;
parameter STATE_STOP_BIT_RISING_EDGE	= 4'b0101; // at beginning of Stop bit
parameter STATE_STOP_BIT		= 4'b0110;
parameter STATE_ERROR			= 4'b0111;
parameter STATE_RESET			= 4'b1000;
parameter STATE_NEW_CTS			= 4'b1001;
parameter STATE_NEW_RTS			= 4'b1010;

reg [3:0] rx_state = STATE_WAIT;
reg [3:0] tx_state = STATE_WAIT;


reg [31:0] counter = 0;
reg [3:0] bit_count = 0;
reg state = 0; // 0: idle, 1: receiving


always @(negedge rx and bit_count==7) begin
	rx_state <= STATE_STOP_BIT_RISING_EDGE;
	valid_byte <= 1; 
end

always @(posedge clk or posedge reset) begin
    if (reset) begin
        counter <= 0;
        bit_count <= 0;
 	valid_byte = 0;
	state <= STATE_WAIT;
        rts <= 1'b0; // Assert RTS signal
        //data_valid <= 1'b0;
    end else begin
        case (rx_state)
            STATE_WAIT: begin // idle
                if (!rx) begin // Start bit detected
                    state <= 1;
                    counter <= 0;
                end
            end
            STATE_START_BIT_FALLING_EDGE: begin
            end
            STATE_START_BIT: begin
            end
            STATE_DATA_BITS: begin
            end
            STATE_STOP_BIT: begin
            end
            STATE_STOP_BIT_RISING_EDGE: begin
            end
            STATE_ERROR: begin
            end
            STATE_RESET: begin
            end
            STATE_NEW_RTS: begin
            end
/*            
            1: begin // receiving
                if (counter == COUNTER_MID_BIT) begin
                    counter <= 0;
                    data_in[bit_count] <= rx;
                    bit_count <= bit_count + 1;
                    if (bit_count == 8) begin
                        state <= 0;
                        bit_count <= 0;
                        //data_valid <= 1'b1;
                    end
                end else begin
                    counter <= counter + 1;
                end
            end */
        endcase
    end
end

always @(posedge clk) begin
    //if (data_valid) begin
    //    data_valid <= 1'b0;
   //end
end

endmodule

