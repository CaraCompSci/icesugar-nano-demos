module top(input CLK, output LED, PMOD1, PMOD2, PMOD3, PMOD4, PMOD5, PMOD6, PMOD7, PMOD8);
	reg [31:0] counter;
	assign PMOD7 = ~counter[31];
	assign PMOD5 = ~counter[30];
	assign PMOD3 = ~counter[29];
	assign PMOD1 = ~counter[28];
	assign PMOD8 = ~counter[27];
	assign PMOD6 = ~counter[26];
	assign PMOD4 = ~counter[25];
	assign PMOD2 = ~counter[24];
	assign LED = ~counter[23];
	initial begin
		counter = 0;
	end
	always @(posedge CLK)
	begin
		counter <= counter + 1;
	end
endmodule

