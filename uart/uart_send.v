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

