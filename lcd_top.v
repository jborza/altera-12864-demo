// sample top module
// connects RAM, LCD driver and modifies the memory
module lcd_top (clk, rs, rw, en, dat, led);  
 input clk;  
 output wire [7:0] dat; 
 output wire rs,rw,en; 
 output led;
 
 reg  [20:0] counter;  //TODO set to 10:0
 reg [5:0] current,next; 
 reg clk_display; 
 
 reg we; //ram write enable
 reg [5:0] write_address;
 wire [5:0] read_address;
 reg [7:0] ram_in;
 wire [7:0] ram_out;
 

reg [7:0] char0;

reg [15:0] bcd; //hopefully initialized to zero
wire [15:0] bcd_out;

reg [1:0] ram_update_address;

localparam PERIOD_100MS = 5000000;
localparam ASCII_ZERO = 8'h30;
reg [23:0] stopwatch_counter;

reg bcd_incrementer_enable;
  
  ram ram(
   .clk(clk),
	.q(ram_out), 
	.d(ram_in), 
	.write_address(write_address), 
	.read_address(read_address), 
	.we(we)
	);
	
	LCD12864 lcd(
		.clk(clk),
		.rs(rs), 
		.rw(rw), 
		.en(en), 
		.dat(dat),
		.address_out(read_address),
		.data_in(ram_out)
	);
	
	bcd_incrementer_4digit incrementer(
		.bcd_in(bcd), 
		.bcd_out(bcd_out),
		.enable(bcd_incrementer_enable)
	);

 always @(posedge clk)        
 begin 
  counter<=counter+16'h1; 
  //clk_display inverted on every overflow of 11-bit counter -> is toggled every 50,000,000 / (2^11*2) = 12 khz -> 82 us
  if(counter==16'h000f) begin										
		clk_display=~clk_display; 
	end
 end
 
 //hundredths of second ticker -> 50,000,000 / 500,000
 always @(posedge clk)
 begin
	stopwatch_counter <= stopwatch_counter + 1;
	bcd_incrementer_enable <= 0;
	if(stopwatch_counter == PERIOD_100MS)
	begin
		stopwatch_counter <= 0;
		bcd_incrementer_enable <= 1;
	end
	bcd <= bcd_out;
 end
 
 //memory updater process, always writing out BCD digits
 always @(posedge clk)
 begin
	//update BCD
	we <= 1;
	ram_update_address <= ram_update_address + 1;
	write_address <= ram_update_address;
	case(write_address)
		0: ram_in = bcd[3:0] + ASCII_ZERO;
		1: ram_in = bcd[7:4] + ASCII_ZERO;
		2: ram_in = bcd[11:8] + ASCII_ZERO;
		3: ram_in = bcd[15:12] + ASCII_ZERO;		
	endcase
 end
 
// always @(posedge clk_display) 
// begin 
//	//buffer[0] <= buffer[0]-1;
//	we <= 1;
////	if(char0[0] == 1) begin
////		write_address <= 0;
////	end else begin
////		write_address <= 1;
////	end
////	write_address <= char0 / 4;
//	write_address <= 48;
//	ram_in <= char0;
//	char0 <= char0 + 8'h1;
// end
 
 assign led = clk_display;
 
endmodule  
 