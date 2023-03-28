module top(input CLK, output PMOD2);
	reg [23:0] counter;
	assign PMOD2 = counter[23];
	initial begin
		counter = 0;
	end
	always @(posedge CLK)
	begin
		counter <= counter + 1;
	end
endmodule

