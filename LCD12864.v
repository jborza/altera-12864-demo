module LCD12864 (clk, rs, rw, en,dat);  
input clk;  
 output [7:0] dat; 
 output  rs,rw,en; 
 //tri en; 
 reg e; 
 reg [7:0] dat; 
 reg rs;   
 reg  [15:0] counter; 
 reg [5:0] current,next; 
 reg clkr; 
 reg [1:0] cnt; 

 reg [7:0] mem [0:63];
 reg [3:0] mem_index;
 
 
 parameter  set0=6'h0; 
 parameter  set1=6'h1; 
 parameter  set2=6'h2; 
 parameter  set3=6'h3; 
 parameter  set4=6'h4; 
 parameter  set5=6'h5;
 parameter  set6=6'h6;  

 parameter  row0=6'h7; 
 parameter  row1=6'h8; 
 parameter  row2=6'h9; 
 parameter  row3=6'hA;    
  
 parameter  loop=6'h3F; 
 
 parameter line0=8'h80;
 parameter line1=8'h90;
 parameter line2=8'h88;
 parameter line3=8'h98;
 
 parameter SET_8BIT_BASIC_INSTR = 8'b00110000;
 parameter SET_DISP_ON_CURSOR_OFF_BLINK_OFF = 8'b00001100;
 parameter SET_CURSOR_POS = 8'b00000110;
 parameter CLEAR = 8'h1;
 parameter STANDBY = 8'b00000000;
 parameter HOME = 8'b00000010;
 
 task write_row;
	input [2:0] mem_row;
	input [5:0] next_state;

	begin
		rs <= 1;
		dat <= mem[mem_row*16 + mem_index];
		mem_index <= mem_index + 1;
		if(mem_index == 15) begin
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
  counter=counter+1; 
  if(counter==16'h000f)  
  clkr=~clkr; 
end 
always @(posedge clkr) 
begin 
 current=next; 
  case(current) 
    set0: begin command(SET_8BIT_BASIC_INSTR, set1); end
    set1: begin command(SET_DISP_ON_CURSOR_OFF_BLINK_OFF, set2); end  
    set2: begin command(SET_CURSOR_POS, set3); end  
    set3: begin command(SET_8BIT_BASIC_INSTR, row0); mem_index <= 0; end
	 
	 row0: begin
		write_row(0, set4);
	 end

    set4:   begin command(line1, row1); mem_index <= 0; end 
	 
	 row1: begin
		write_row(1, set5);
	 end


    set5:   begin command(line2, row2); mem_index <= 0; end 
	 
	 row2: begin
		write_row(2, set6);
	 end

    set6:   begin command(line3, row3); mem_index <= 0; end
	 
	 row3: begin
		write_row(3, loop);
	 end
	 
	 loop: begin command(HOME, set0);
			mem[63] = mem[63]+1;
			mem[0] = mem[0]-1; end

   default:   next=set0; 
    endcase 
 end 
assign en=clkr|e; 
assign rw=0; 
endmodule  