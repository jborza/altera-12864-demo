module bcd_incrementer_3digit(
	bcd_in, 
	bcd_out,
	enable
);

input wire [11:0] bcd_in;
output wire [11:0] bcd_out;
input wire enable;

wire c1, c0;
wire temp;

bcd_incrementer bcd_digit2(
	.bcd_in(bcd_in[3:0]),
	.enable(enable), 
	.bcd_out(bcd_out[3:0]), 
	.carry(c1));
	
bcd_incrementer bcd_digit1(
	.bcd_in(bcd_in[7:4]),
	.enable(c1), 
	.bcd_out(bcd_out[7:4]), 
	.carry(c0));
	
bcd_incrementer bcd_digit0(
	.bcd_in(bcd_in[11:8]),
	.enable(c0), 
	.bcd_out(bcd_out[11:8]), 
	.carry(temp));
endmodule