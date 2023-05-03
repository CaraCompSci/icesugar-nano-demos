
module uart_rx (
    input wire clk,
    input wire reset,
    input wire rx,
    input wire cts, // Clear to Send (CTS) input
    output reg rts, // Request to Send (RTS) output
    output reg tx,
    output reg [7:0] data_read,
    output reg valid_byte,
    output reg error,
    output reg [7:0] debug 
);

// Set your desired baud rate and correct FPGA clock rate
parameter BAUD_RATE = 115200; // change as required
parameter CLK_FREQ = 12000000; // change as required
parameter SAMPLE_RATE = 1; // Keep as 1, super sampling not implemented yet
parameter [31:0] TICKS_PER_UART_BIT = CLK_FREQ / BAUD_RATE - 1;
parameter [31:0] TICKS_UNTIL_UART_SAMPLE = TICKS_PER_UART_BIT / (SAMPLE_RATE+1);

// UART states (keep track of two states, one for RX, one for TX)
parameter WAIT				= 4'b0000;
parameter START_BIT			= 4'b0010;
parameter DATA_BIT_1			= 4'b0011;
parameter DATA_BIT_2			= 4'b0100;
parameter DATA_BIT_3			= 4'b0101;
parameter DATA_BIT_4			= 4'b0110;
parameter DATA_BIT_5			= 4'b0111;
parameter DATA_BIT_6			= 4'b1000;
parameter DATA_BIT_7			= 4'b1001;
parameter DATA_BIT_8			= 4'b1010;
parameter STOP_BIT			= 4'b1011;
parameter ERROR				= 4'b1100;


reg [3:0] rx_state;
reg [3:0] tx_state;
reg [31:0] clk_counter;
reg data_started;
reg start_bit_detected;

initial begin
	clk_counter <= 0;
	error <= 0;
	rx_state <= WAIT;
	tx_state <= WAIT;
	valid_byte <= 0;
	data_read <= 8'b00000000;
	start_bit_detected = 0;
end

always @(negedge rx ) begin
	debug <= 8'b10101010; 	
	if ( rx_state == WAIT ) begin
		// Start bit of next byte.
		start_bit_detected <= 1;
		// sync counter
		clk_counter <= 0;
	end
end

always @( posedge clk or posedge reset ) begin
    debug <= 8'b10011001; 	
    if (reset) begin
        clk_counter <= 0;
 	valid_byte <= 0;
	rx_state <= WAIT;
	start_bit_detected = 0;
        rts <= 1'b0; // Assert RTS signal, low is set
        $display("Reset received");
    end 
    else begin
    	clk_counter = clk_counter + 1;
	$display("clk_counter=%b TICKS_UNTIL_UART_SAMPLE=%b, TICKS_PER_UART_BIT=%b rx=%b data_read=%b", clk_counter, TICKS_UNTIL_UART_SAMPLE, TICKS_PER_UART_BIT, rx, data_read );
    	$display("Case statement");
        case (rx_state)
        	WAIT: begin
        		$display("WAIT state");
			if( start_bit_detected ) begin
				start_bit_detected <= 0; //reset this for next byte
				rx_state <= START_BIT;
				$display("Detected start bit");
		        end
	        end
	        START_BIT: begin
               		$display("START_BIT state");
        	    	if ( clk_counter == TICKS_UNTIL_UART_SAMPLE) begin
 		        	$display("Sampling bit value mid clock cycle.");
		            	if( rx == 1) begin
		            		// error, start bit should be low
		            		$display("Detected high start bit - error condition.");
		            		rx_state <= ERROR;
		            		error <= 1;
		            		rts <= 1'b1; // Unassert RTS signal   	
		            	end
       		   	end
        		if ( clk_counter == TICKS_PER_UART_BIT ) begin
        			clk_counter <= 0;
        			rx_state <= DATA_BIT_1;
        			$display("Detected data bit 1");
        			tx <= 0;
        		end
	        end    
	        DATA_BIT_1: begin
		        $display("DATA_BIT_1 state");
        	    	if ( clk_counter == TICKS_UNTIL_UART_SAMPLE) begin
		            	data_read[0] <= rx;
		            	$display("Sampling bit value mid clock cycle.");
		            	tx <= rx;
       		   	end
        		if ( clk_counter == TICKS_PER_UART_BIT ) begin
        			clk_counter <= 0;
        			rx_state <= DATA_BIT_2;
        			$display("STATE changed to DATA_BIT_2");

        		end 
       		end
	        DATA_BIT_2: begin
    			$display("DATA_BIT_2 state");
        	    	if ( clk_counter == TICKS_UNTIL_UART_SAMPLE) begin
		            	data_read[1] <= rx;
		            	$display("Sampling bit value mid clock cycle.");
		            	tx <= rx;
       		   	end
        		if ( clk_counter == TICKS_PER_UART_BIT ) begin
        			clk_counter <= 0;
        			rx_state <= DATA_BIT_3;
        			$display("STATE changed to DATA_BIT_3");
        		end 
       		end
	        DATA_BIT_3: begin
			$display("DATA_BIT_3 state");
        	    	if ( clk_counter == TICKS_UNTIL_UART_SAMPLE) begin
		            	data_read[2] <= rx;
		            	$display("Sampling bit value mid clock cycle.");
		            	tx <= rx;
       		   	end
        		if ( clk_counter == TICKS_PER_UART_BIT ) begin
        			clk_counter <= 0;
        			rx_state <= DATA_BIT_4;
        			$display("STATE changed to DATA_BIT_4");
        		end 
       		end
	        DATA_BIT_4: begin
	        	$display("DATA_BIT_4 state");
        	    	if ( clk_counter == TICKS_UNTIL_UART_SAMPLE) begin
		            	data_read[3] <= rx;
		            	$display("Sampling bit value mid clock cycle.");
		            	tx <= rx;
       		   	end
        		if ( clk_counter == TICKS_PER_UART_BIT ) begin
        			clk_counter <= 0;
        			rx_state <= DATA_BIT_5;
        			$display("STATE changed to DATA_BIT_5");
        		end 
       		end
	        DATA_BIT_5: begin
		        $display("DATA_BIT_5 state");
        	    	if ( clk_counter == TICKS_UNTIL_UART_SAMPLE) begin
		            	data_read[4] <= rx;
		            	$display("Sampling bit value mid clock cycle.");
		            	tx <= rx;
       		   	end
        		if ( clk_counter == TICKS_PER_UART_BIT ) begin
        			clk_counter <= 0;
        			rx_state <= DATA_BIT_6;
        			$display("STATE changed to DATA_BIT_6");
        		end 
       		end
	        DATA_BIT_6: begin
	        	$display("DATA_BIT_6 state");
        	    	if ( clk_counter == TICKS_UNTIL_UART_SAMPLE) begin
		            	data_read[5] <= rx;
		            	$display("Sampling bit value mid clock cycle.");
		            	tx <= rx;
       		   	end
        		if ( clk_counter == TICKS_PER_UART_BIT ) begin
        			clk_counter <= 0;
        			rx_state <= DATA_BIT_7;
        			$display("STATE changed to DATA_BIT_7");
        		end 
       		end
	        DATA_BIT_7: begin
	        	$display("DATA_BIT_7 state");
        	    	if ( clk_counter == TICKS_UNTIL_UART_SAMPLE) begin
		            	data_read[6] <= rx;
		            	$display("Sampling bit value mid clock cycle.");
		            	tx <= rx;
       		   	end
        		if ( clk_counter == TICKS_PER_UART_BIT ) begin
        			clk_counter <= 0;
        			rx_state <= DATA_BIT_8;
        			$display("STATE changed to DATA_BIT_8");
        		end 
       		end
	        DATA_BIT_8: begin
	        	$display("DATA_BIT_8 state");
        	    	if ( clk_counter == TICKS_UNTIL_UART_SAMPLE) begin
		            	data_read[7] <= rx;
		            	$display("Sampling bit value mid clock cycle.");
		            	tx <= rx;
       		   	end
        		if ( clk_counter == TICKS_PER_UART_BIT ) begin
        			clk_counter <= 0;
        			rx_state <= STOP_BIT;
        			$display("STATE changed to STOP_BIT");
        		end 
       		end
	        STOP_BIT: begin
		        $display("STOP_BIT state");
		        if ( clk_counter == TICKS_UNTIL_UART_SAMPLE) begin
	       		     	// check for high stop bit
	       		     	$display("Sampling bit value mid clock cycle.");
		    		if( rx == 1) begin
		    			rx_state <= WAIT; // start wait for next new byte
		    			$display("STATE changed to WAIT");
		    			valid_byte <= 1;
			    		clk_counter <= 0;   
			    		tx <= rx;         			
			    	end
			    	else begin
			             	rx_state <= ERROR;
			      		error <= 1;
	       		     		valid_byte <= 0;
			    		clk_counter <= 0;
			    		rts <= 1'b1; // Unassert RTS signal   	
			    		$display("Stop bit is low, error condition.");
			    	end		            	
       		   	end
        		if ( clk_counter == TICKS_PER_UART_BIT ) begin
        			clk_counter <= 0;
        			rx_state <= WAIT;
        			$display("STATE changed to WAIT");
        		end 
        	    end            
            	ERROR: begin            
              		// count 20 uart cycles and then set rts high ???
            	end
        endcase
    end
end



endmodule

