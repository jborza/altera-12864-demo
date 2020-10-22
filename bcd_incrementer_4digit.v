module bcd_incrementer_4digit(
	bcd_in, 
	bcd_out,
	enable
);

input wire [15:0] bcd_in;
output wire [15:0] bcd_out;
input wire enable;

wire c2, c1, c0;
wire temp;

bcd_incrementer bcd_digit3(
	.bcd_in(bcd_in[3:0]),
	.enable(enable), 
	.bcd_out(bcd_out[3:0]), 
	.carry(c2));
	
bcd_incrementer bcd_digit2(
	.bcd_in(bcd_in[7:4]),
	.enable(c2), 
	.bcd_out(bcd_out[7:4]), 
	.carry(c1));
	
bcd_incrementer bcd_digit1(
	.bcd_in(bcd_in[11:8]),
	.enable(c1), 
	.bcd_out(bcd_out[11:8]), 
	.carry(c0));
	
bcd_incrementer bcd_digit0(
	.bcd_in(bcd_in[15:12]),
	.enable(c0), 
	.bcd_out(bcd_out[15:12]), 
	.carry(temp));
		
	
endmodule