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
 
 reg [7:0] mem [0:15];
 reg [7:0] mem2 [0:15];
 reg [7:0] mem3 [0:15];
 reg [7:0] mem4 [0:15];
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
 parameter  dat4=6'hB; 
 parameter  dat5=6'hC;
 parameter  dat6=6'hD; 
 parameter  dat7=6'hE; 
 parameter  dat8=6'hF; 
 parameter  dat9=6'h10;

 parameter  dat10=6'h12; 
 parameter  dat11=6'h13; 
 parameter  dat12=6'h14; 
 parameter  dat13=6'h15; 
 parameter  dat14=6'h16; 
 parameter  dat15=6'h17;
 parameter  dat16=6'h18; 
 parameter  dat17=6'h19; 
 parameter  dat18=6'h1A; 
 parameter  dat19=6'h1B; 
 parameter  dat20=6'h1C;
 parameter  dat21=6'h1D; 
 parameter  dat22=6'h1E; 
 parameter  dat23=6'h1F; 
 parameter  dat24=6'h20; 
 parameter  dat25=6'h21; 
 parameter  dat26=6'h22;     
  
 parameter  nul=6'hF1; 
 
 initial begin;
	 mem[0] = "H";
	 mem[1]  = "e";
	 mem[2]  = "l";
	 mem[3]  = "l";
	 mem[4]  = "o";
	 mem[5]  = " ";
	 mem[6]  = "W";
	 mem[7]  = "o";
	 mem[8]  = "r";
	 mem[9]  = "l";
	 mem[10] = "d";
	 mem[11] = "!";
	 mem[12] = " ";
	 mem[13] = "*";
	 mem[14] = "#";
	 mem[15] = "^";
	mem2[0] = "L";
	mem2[1] = "C";
	mem2[2] = "D";
	mem2[3] = "1";
	mem2[4] = "2";
	mem2[5] = "8";
	mem2[6] = "x";
	mem2[7] = "6";
	mem2[8] = "4";
	mem2[9] = " ";
	mem2[10] = "s";
	mem2[11] = "c";
	mem2[12] = "r";
	mem2[13] = "e";
	mem2[14] = "e";
	mem2[15] = "n";
	mem3[0] = "L";
	mem3[1] = "o";
	mem3[2] = "r";
	mem3[3] = "e";
	mem3[4] = "m";
	mem3[5] = " ";
	mem3[6] = "i";
	mem3[7] = "p";
	mem3[8] = "s";
	mem3[9] = "u";
	mem3[10] = "m";
	mem3[11] = " ";
	mem3[12] = " ";
	mem3[13] = " ";
	mem3[14] = " ";
	mem3[15] = " ";
	mem4[0] = "d";
	mem4[1] = "o";
	mem4[2] = "l";
	mem4[3] = "o";
	mem4[4] = "r";
	mem4[5] = " ";
	mem4[6] = "s";
	mem4[7] = "i";
	mem4[8] = "t";
	mem4[9] = " ";
	mem4[10] = "a";
	mem4[11] = "m";
	mem4[12] = "e";
	mem4[13] = "t";
	mem4[14] = ".";
	mem4[15] = " ";
//	$readmemb("row3.txt", mem3);
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
		dat <= mem[mem_index];
		mem_index <= mem_index + 1;
		if(mem_index == 15)
			next <= set4;
		else
			next <= dat0;
	end

    set4:   begin  rs<=0; dat<=8'h90; next<=dat1; mem_index <= 0; end 
	 
	 dat1: begin
		rs <= 1;
		dat <= mem2[mem_index];
		mem_index <= mem_index + 1;
		if(mem_index == 15)
			next <= set5;
		else
			next <= dat1;
	 end


    set5:   begin  rs<=0; dat<=8'h88; next<=dat2; mem_index <= 0; end //ĎÔĘžľÚČýĐĐ
	 
	 dat2: begin
		rs <= 1;
		dat <= mem3[mem_index];
		mem_index <= mem_index + 1;
		if(mem_index == 15)
			next <= set6;
		else
			next <= dat2;
	 end

    set6:   begin  rs<=0; dat<=8'h98; next<=dat3; mem_index <= 0; end //ĎÔĘžľÚËÄĐĐ
	 
	 dat3: begin
		rs <= 1;
		dat <= mem4[mem_index];
		mem_index <= mem_index + 1;
		if(mem_index == 15)
			next <= nul;
		else
			next <= dat3;
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