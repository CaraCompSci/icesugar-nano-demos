
module uart_rx (
    input wire clk,
    input wire reset,
    input wire rx,
    input wire cts, // Clear to Send (CTS) input
    output reg rts, // Request to Send (RTS) output
    output reg [7:0] data_out,
    output reg data_valid
);

// Set your desired baud rate
parameter BAUD_RATE = 115200;
parameter CLK_FREQ = 12000000;
parameter COUNTER_MAX = CLK_FREQ / BAUD_RATE - 1;

reg [31:0] counter = 0;
reg [3:0] bit_count = 0;
reg state = 0; // 0: idle, 1: receiving

always @(posedge clk or posedge reset) begin
    if (reset) begin
        counter <= 0;
        bit_count <= 0;
        state <= 0;
        rts <= 1'b0; // Assert RTS signal
        data_valid <= 1'b0;
    end else begin
        case (state)
            0: begin // idle
                if (!rx) begin // Start bit detected
                    state <= 1;
                    counter <= COUNTER_MAX / 2;
                    rts <= cts; // Update RTS based on CTS value
                end
            end
            1: begin // receiving
                if (counter == COUNTER_MAX) begin
                    counter <= 0;
                    data_out[bit_count] <= rx;
                    bit_count <= bit_count + 1;
                    if (bit_count == 8) begin
                        state <= 0;
                        bit_count <= 0;
                        data_valid <= 1'b1;
                    end
                end else begin
                    counter <= counter + 1;
                end
            end
        endcase
    end
end

always @(posedge clk) begin
    if (data_valid) begin
        data_valid <= 1'b0;
    end
end

endmodule

