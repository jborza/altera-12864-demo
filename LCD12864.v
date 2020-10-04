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
 
 reg [7:0] mem0 [0:15];
 reg [7:0] mem1 [0:15];
 reg [7:0] mem2 [0:15];
 reg [7:0] mem3 [0:15];
 reg [3:0] mem_index;
 
 
 parameter  set0=6'h0; 
 parameter  set1=6'h1; 
 parameter  set2=6'h2; 
 parameter  set3=6'h3; 
 parameter  set4=6'h4; 
 parameter  set5=6'h5;
 parameter  set6=6'h6;  

 parameter  dat0=6'h7; 
 parameter  dat1=6'h8; 
 parameter  dat2=6'h9; 
 parameter  dat3=6'hA;    
  
 parameter  nul=6'hF1; 
 
 task write_row;
	//input [7:0] mem[0:15];
	input [5:0] next_state;
	begin
		rs <= 1;
		dat <= mem0[mem_index];
		mem_index <= mem_index + 1;
		if(mem_index == 15) begin
			next <= next_state;
		end
	end
 endtask
 
 initial begin;
	$readmemb("ram0.txt", mem0);
	$readmemb("ram1.txt", mem1);
	$readmemb("ram2.txt", mem2);
	$readmemb("ram3.txt", mem3);
 end
 
always @(posedge clk)         //da de shi zhong pinlv 
 begin 
  counter=counter+1; 
  if(counter==16'h000f)  
  clkr=~clkr; 
end 
always @(posedge clkr) 
begin 
 current=next; 
  case(current) 
    set0:   begin  rs<=0; dat<=8'h30; next<=set1; end 
    set1:   begin  rs<=0; dat<=8'h0c; next<=set2; end 
    set2:   begin  rs<=0; dat<=8'h6; next<=set3; end 
    set3:   begin  rs<=0; dat<=8'h1; next<=dat0; mem_index <= 0; end 
	 
	 dat0: begin
		rs <= 1;
		dat <= mem0[mem_index];
		mem_index <= mem_index + 1;
		if(mem_index == 15)
			next <= set4;
	end

    set4:   begin  rs<=0; dat<=8'h90; next<=dat1; mem_index <= 0; end 
	 
	 dat1: begin
		rs <= 1;
		dat <= mem1[mem_index];
		mem_index <= mem_index + 1;
		if(mem_index == 15)
			next <= set5;
	 end


    set5:   begin  rs<=0; dat<=8'h88; next<=dat2; mem_index <= 0; end //ĎÔĘžľÚČýĐĐ
	 
	 dat2: begin
		rs <= 1;
		dat <= mem2[mem_index];
		mem_index <= mem_index + 1;
		if(mem_index == 15)
			next <= set6;
	 end

    set6:   begin  rs<=0; dat<=8'h98; next<=dat3; mem_index <= 0; end //ĎÔĘžľÚËÄĐĐ
	 
	 dat3: begin
		rs <= 1;
		dat <= mem3[mem_index];
		mem_index <= mem_index + 1;
		if(mem_index == 15)
			next <= nul;
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