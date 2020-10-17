// sample top module
// connects RAM, LCD driver and modifies the memory
module lcd_top (clk, rs, rw, en, dat, led);  
 input clk;  
 output wire [7:0] dat; 
 output wire rs,rw,en; 
 output led;
 
 //wire [7:0] dat; 
 //wire rs;   
 
 //tri en; 
 //wire e; 
 reg  [23:0] counter;  //TODO set to 10:0
 reg [5:0] current,next; 
 reg clk_display; 
 
 reg we;
 reg [5:0] write_address;
 wire [5:0] read_address;
 reg [7:0] ram_in;//, ram_out;
 wire [7:0] ram_out;
 
// reg [7:0] buffer [0:63];
  
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

 always @(posedge clk)        
 begin 
  counter=counter+16'h1; 
  //clk_display inverted on every overflow of 11-bit counter -> is toggled every 50,000,000 / (2^11*2) = 12 khz -> 82 us
  if(counter==16'h000f) begin										
		clk_display=~clk_display; 
	end
 end
 
 always @(posedge clk_display) 
 begin 
	//buffer[0] <= buffer[0]-1;
	we <= 1;
	write_address <= 0;
 end
 
 assign led = clk_display;
 
endmodule  
 