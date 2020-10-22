//BCD uses 4 bits to represent 10 decimal digits.
//a BCD incrementer adds 1 to a number in BCD format
//e.g. 0101 is 9, becomes 0000 and activates carry
module bcd_incrementer(
	input wire[3:0] bcd_in,
	input wire enable,
	output wire[3:0] bcd_out,
	output wire carry
);

localparam nine = 4'b1001;
localparam one  = 4'b0001;
localparam zero = 4'b0000;

assign bcd_out = enable == 1'b1 ? bcd_in == nine ? zero : bcd_in + one : bcd_in;
assign carry = enable == 1'b1 ? bcd_in == nine ? 1'b1 : 1'b0 : 1'b0;

endmodule
