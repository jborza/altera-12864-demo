module lcd_clock_divider(
	clk,
	clk_div);
	
input clk;
output reg clk_div;

localparam clk_div_ticks = 2048 - 1;

reg  [10:0] counter; 

//we want to hit 72 us per display instruction. 
always @(posedge clk) begin
	counter <= counter+1; 
	//clk_display inverted on every overflow of 11-bit counter -> is toggled every 50,000,000 / (2^11*2) = 12 khz -> 82 us
	if(counter == clk_div_ticks) begin										
		clk_div <= ~clk_div; 
	end
end
endmodule