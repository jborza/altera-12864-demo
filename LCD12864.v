//let's have a module that displays data off 64-byte RAM
module LCD12864 (clk, rs, rw, en,dat);  
input clk;  
 output [7:0] dat; 
 output  rs,rw,en; 
 //tri en; 
 reg e; 
 reg [7:0] dat; 
 reg rs;   
 reg  [14:0] counter;  //TODO set to 10:0
 reg [5:0] current,next; 
 reg clk_display; 

 reg [7:0] mem [0:63];
 reg [3:0] x;
 
 // state machine states
 parameter  set0=6'h0; 
 parameter  set1=6'h1; 
 parameter  set2=6'h2; 
 parameter  set3=6'h3; 
 parameter  move_to_row1=6'h4; 
 parameter  move_to_row2=6'h5;
 parameter  move_to_row3=6'h6;  

 parameter  row0=6'h7; 
 parameter  row1=6'h8; 
 parameter  row2=6'h9; 
 parameter  row3=6'hA;    
  
 parameter  loop=6'h3F; 
 // end of state machine states
 
 // line offsets
 parameter line0=8'h80;
 parameter line1=8'h90;
 parameter line2=8'h88;
 parameter line3=8'h98;
 
 // ST7920 display instructions
 parameter SET_8BIT_BASIC_INSTR = 8'b00110000;
 parameter SET_DISP_ON_CURSOR_OFF_BLINK_OFF = 8'b00001100;
 parameter SET_CURSOR_POS = 8'b00000110;
 parameter CLEAR = 8'h1;
 parameter STANDBY = 8'b00000000;
 parameter HOME = 8'b00000010;
 
 task write_characters_row;
	input [2:0] y;
	input [5:0] next_state;

	begin
		rs <= 1;
		dat <= mem[y*16 + x];
		x <= x + 1;
		if(x == 15) begin
			next <= next_state;
		end
	end
 endtask
 
  task command;
	input [7:0] data;
	input [5:0] next_state;
	
	begin
		rs <= 0;
		dat <= data;
		next <= next_state;
	end
 endtask
 
 initial begin;
	$readmemb("ram.txt", mem);
 end
 
always @(posedge clk)        
 begin 
  //we want to hit 72 us per display instruction. 72 us 
  counter=counter+1; 
  //clk_display inverted on every overflow of 11-bit counter -> is toggled every 50,000,000 / (2^11*2) = 12 khz -> 82 us
  if(counter==12'h000f) begin										
		clk_display=~clk_display; 
	end
end 
always @(posedge clk_display) 
begin 
 current=next; 
  case(current) 
    //initialize display mode
    set0: begin command(SET_8BIT_BASIC_INSTR, set1); end
    set1: begin command(SET_DISP_ON_CURSOR_OFF_BLINK_OFF, set2); end  
    set2: begin command(SET_CURSOR_POS, set3); end  
    set3: begin command(SET_8BIT_BASIC_INSTR, row0); x <= 0; end
	 
	 row0: begin
		write_characters_row(0, move_to_row1);
	 end

    move_to_row1:   begin command(line1, row1); x <= 0; end 
	 
	 row1: begin
		write_characters_row(1, move_to_row2);
	 end

    move_to_row2:   begin command(line2, row2); x <= 0; end 
	 
	 row2: begin
		write_characters_row(2, move_to_row3);
	 end

    move_to_row3:   begin command(line3, row3); x <= 0; end
	 
	 row3: begin
		write_characters_row(3, loop);
	 end
	 
	 loop: begin command(HOME, set0);
			mem[0] <= mem[0]-1; //TODO remove - a dynamic element until the display buffer is extracted
			mem[20] <= mem[20]-1; //TODO remove - a dynamic element until the display buffer is extracted
			mem[40] <= mem[40]-1; //TODO remove - a dynamic element until the display buffer is extracted
			mem[60] <= mem[60]-1; //TODO remove - a dynamic element until the display buffer is extracted
	  end
   default:   next=set0; 
    endcase 
 end 
assign en=clk_display|e; 
assign rw=0; 
endmodule  