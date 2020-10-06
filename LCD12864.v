//ąžĘľŃéĘÇÓĂLCD12864ĎÔĘžÓ˘ÎÄĄŁŁ¨LCD´ř×ÖżâŁŠ

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
  
 parameter  nul=6'hF1; 
 
 parameter line0=8'h80;
 parameter line1=8'h90;
 parameter line2=8'h88;
 parameter line3=8'h98;
 
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
    set0:   begin  rs<=0; dat<=8'h30; next<=set1; end //00110000 - set 8-bit interface, basic instruction set
    set1:   begin  rs<=0; dat<=8'h0c; next<=set2; end //00001100 - display on, cursor off, blink off
    set2:   begin  rs<=0; dat<=8'h6; next<=set3; end  //00000110 - set cursor position and display shift?
    set3:   begin  rs<=0; dat<=8'h1; next<=row0; mem_index <= 0; end  //CLEAR
	 
	 row0: begin
		write_row(0, set4);
	 end

    set4:   begin  rs<=0; dat<=line1; next<=row1; mem_index <= 0; end 
	 
	 row1: begin
		write_row(1, set5);
	 end


    set5:   begin  rs<=0; dat<=line2; next<=row2; mem_index <= 0; end 
	 
	 row2: begin
		write_row(2, set6);
	 end

    set6:   begin  rs<=0; dat<=line3; next<=row3; mem_index <= 0; end
	 
	 row3: begin
		write_row(3, nul);
	 end

	 //reset?
     nul:   begin rs<=0;  dat<=8'h00;                    // °ŃŇşž§ľÄE ˝Ĺ Ŕ­¸ß 
              if(cnt!=2'h2)  
                  begin  
                       e<=0;next<=set0;cnt<=cnt+1;  
                  end  
                   else  
                     begin next<=nul; e<=1; 
                    end    
              end 
   default:   next=set0; 
    endcase 
 end 
assign en=clkr|e; 
assign rw=0; 
endmodule  