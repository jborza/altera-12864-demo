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
localparam nine = 4'b1001;
localparam ninenine = 8'b10011001;
localparam one  = 4'b0001;
localparam zero = 4'b0000;

//carry on nine
//digit one = add + carry out
wire [4:0] digit2;
assign digit2 = bcd_in[3:0] == nine ? zero : bcd_in[3:0] + 1;

wire [4:0] digit1; //carry over first nine
assign digit1 = bcd_in[3:0] == nine ? bcd_in[7:4] + one: bcd_in[7:4];

wire [3:0] digit0; //carry over second nine
assign digit0 = bcd_in[7:0] == ninenine ? bcd_in[11:8] + one : bcd_in[11:8];

assign bcd_out = {digit0[3:0], digit1[3:0], digit2[3:0]};

endmodule
