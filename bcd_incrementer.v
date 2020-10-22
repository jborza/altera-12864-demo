//BCD uses 4 bits to represent 10 decimal digits.
//a BCD incrementer adds 1 to a number in BCD format
//e.g. 0010 0101 1001 (259) becomes 0010 0110 0000 (260)
//: design a three digit incrementor
//: design a testbench
//: parametrize to N digits #parameter
module bcd_incrementer(
	bcd_in, 
	bcd_out
);

//inputs, outputs
input wire [11:0] bcd_in;
output wire [11:0] bcd_out;

//we carry 
//digit one = add + carry out
wire [4:0] digit2;
assign digit2 = bcd_in[3:0] + 1;

//wire carry2 = digit2[4];

wire [4:0] digit1;
assign digit1 = bcd_in[7:4] + digit2[4];

wire [3:0] digit0;
assign digit0 = bcd_in[11:8] + digit1[4];

assign bcd_out = {digit0[3:0], digit1[3:0], digit2[3:0]};
//assign bcd_out = bcd_in;

endmodule
