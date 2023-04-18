module ram_block (
    input wire clk,
    input wire [7:0] address,
    input wire [7:0] data_in,
    input wire write_enable,
    output reg [7:0] data_out
);

// Declare a 256x8 RAM block
reg [7:0] mem [0:255];

always @(posedge clk) begin
    if (write_enable) begin
        // Write data to memory
        mem[address] <= data_in;
    end else begin
        // Read data from memory
        data_out <= mem[address];
    end
end

endmodule
