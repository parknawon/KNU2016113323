module RSP(clk, rst,dot_col, dot_row , INPUT, NUMBER, cwn, uwn, STATE, DELAY, LED_U, LED_C);


output [3:0] STATE;
reg [3:0]STATE;  
output [2:0]DELAY;
reg [2:0]DELAY;

input 	clk, rst;
input [2:0]INPUT;
output [9:0]dot_col;
reg [9:0]dot_col;	
output [0:13]dot_row;
reg [0:13]dot_row;
output [1:0] NUMBER;
reg [1:0] NUMBER;
reg	[2:0]	state;
reg [13:0]  counts1 ,counts2;
reg clk1, clk2;
wire key_stop;
reg [1:0] RANDOM;
reg [1:0] user_number;
reg [1:0] ENTRY, WIN;
reg r_key_stop;
reg [5:0] SCR_P;
reg [5:0] SCR_E;
output [5:0]LED_U;
reg [5:0] LED_U;
output [5:0]LED_C;
reg [5:0] LED_C;

output [3:0] cwn;
output [3:0] uwn;
reg [3:0] cwn;
reg [3:0] uwn;

	reg [5:0] data1;
	reg [5:0] data2;
	// define state of FSM
	parameter no_scan = 3'b000;
	parameter column1 = 3'b001;
	parameter column2 = 3'b010;
	parameter column3 = 3'b100; 
	
	assign key_stop = INPUT[0] | INPUT[1] | INPUT[2] ;
	assign key_col = state;
	
	
	always@(*)
	begin
	case(cwn)
	0:LED_C <= 6'b000000;
	1:LED_C <= 6'b100000;
	2:LED_C <= 6'b110000;
	3:LED_C <= 6'b111000;
	4:LED_C <= 6'b111100;
	5:LED_C <= 6'b111110;
	6:LED_C <= 6'b111111;
	endcase
	
	case(uwn)
	0:LED_U <= 6'b000000;
	1:LED_U <= 6'b100000;
	2:LED_U <= 6'b110000;
	3:LED_U <= 6'b111000;
	4:LED_U <= 6'b111100;
	5:LED_U <= 6'b111110;
	6:LED_U <= 6'b111111;
	endcase
	end
	
	
	always@(posedge key_stop) begin
	case(INPUT) 
	3'b001: user_number=2'b01;
	3'b010: user_number=2'b10;
	3'b100: user_number=2'b11;
	endcase
	
	end
	
	
	always @(posedge clk or posedge rst) // 매우 빠른 clock을 RANDOM에 할당 
	begin
	if(rst) RANDOM <= 2'b01;
	else begin
	 if(!key_stop)begin
			if(RANDOM==2'b11)
				begin 
					RANDOM<=2'b01;   
				end		
			else 
				begin 
					RANDOM <= RANDOM+2'b01; 
				end
	end
	else ENTRY<=RANDOM;
	end

	end
	
	
	compare c (NUMBER, user_number,clk, ENTRY);
	DOT d1(cwn, uwn,  ENTRY, NUMBER, clk, rst,  key_stop, dot_col, dot_row, STATE, DELAY); 
	
endmodule
	

module compare (NUMBER, user_number,clk, ENTRY);

input clk;
output [1:0] NUMBER;
input [1:0] user_number;
input [1:0] ENTRY;
reg [1:0] NUMBER;

always @(*) begin
if(user_number==ENTRY) begin NUMBER=2'b00; end

else if (((user_number==(2'b01))&&(ENTRY==(2'b10))) || ((user_number==(2'b10))&&(ENTRY==(2'b11))) || ((user_number==(2'b11))&&(ENTRY==(2'b01)))) begin NUMBER=2'b01; end//win 

else begin NUMBER=2'b10; end

end

endmodule
	
module DOT(cwn, uwn, cc, outcome, clk, reset, key_stop, dot_col, dot_row, STATE, DELAY); 
//com_win_num, user_win_num, com_choice , outcome

input clk, reset, key_stop;
input [1:0]outcome;
input [1:0]cc;


reg clk1, clk2, clk3, clk4;  //분주 clk1,2,3,4
reg [3:0]row_show = 0;       //화면에 나타날 행바꿈 
reg [14:0]clk_count;     //for clk1
reg [21:0]clk_count2;    //for clk2
reg [24:0]clk_count3;    //for clk3
reg [23:0]clk_count4;    //for clk4
reg [5:0]n1=0;         //for WIN,DRAW,LOSE
reg [3:0]n2=0;         //for HAPPY
reg [4:0]n3=0;         //for SAD
reg [3:0]DELAY_COUNT;
reg [2:0]DELAY;
output [2:0]DELAY;


output [10:0] cwn;
output [10:0] uwn;
reg [10:0] cwn;
reg [10:0] uwn;



output [9:0]dot_col;
reg [9:0]dot_col;
output [0:13]dot_row;
reg [0:13]dot_row;

reg [0:13]DOT_ROW1[43:0];
reg [0:13]DOT_ROW2[43:0];
reg [0:13]DOT_ROW3[43:0];
reg [0:13]DOT_ROW4[19:0];
reg [0:13]DOT_ROW5[39:0];


output [3:0] STATE;
reg [3:0]STATE;        //화면에 어떤 모듈을 띄울 것 인가? 

always@(negedge clk or posedge reset)     //clk1 = clk/9000
if(reset) clk1 <=0;
else if (clk_count==8999) begin clk_count <=0; clk1 <=1; end
else if (clk_count==4499) begin clk_count <= clk_count +1; clk1<=0; end
else begin clk_count <= clk_count +1; end 

always@(negedge clk or posedge reset)     //clk2 = clk/2500000 =0.1sec
if(reset) clk2 <=0;
else if (clk_count2==1249999) begin clk_count2 <=0; clk2 <=1; end
else if (clk_count2==624999) begin clk_count2 <= clk_count2 +1; clk2<=0; end
else begin clk_count2 <= clk_count2 +1; end 

always@(negedge clk or posedge reset)     //clk3 = clk/25000000 =1sec 
if(reset) clk3 <=0;
else if (clk_count3==24999999) begin clk_count3 <=0; clk3 <=1; end
else if (clk_count3==12499999) begin clk_count3 <= clk_count3 +1; clk3<=0; end
else begin clk_count3 <= clk_count3 +1; end 



//clk4 = clk/12500000 => 주기 0.5sec 
always@(negedge clk or posedge reset)    
	if(reset) clk4 <=0;
	else if (clk_count4==12499999) 
		begin 
			clk_count4 <=0; clk4 <=1; 
		end
	else if (clk_count4==6249999) 
		begin 
			clk_count4 <= clk_count4 +1; clk4<=0; 
		end
	else 
		begin 
			clk_count4 <= clk_count4 +1; 
		end 


always@(negedge clk1)   //출력 행 0->1->2->3->4->5->6->7->8->9->0->1->...
  if (row_show == 9) row_show <= 0;
  else row_show <= row_show +1;

always@(negedge clk2)             // 0.05초 마다 n1변환 
  if (n1 == 34) n1 <= 0; 
  else n1 <= n1 +1;

always@(negedge clk3)             // 1초 마다 n2변환 
  if (n2 == 10) n2 <= 0; 
  else n2 <= n2 +10;

always@(negedge clk4)             // 0.5초 마다 n3변환 
  if (n3 == 30) n3 <= 0; 
  else n3 <= n3 +10;








always@(negedge key_stop or posedge clk4) // clk4 주기 : 0.5sec 
begin
	if(key_stop==0) 
		begin 
			DELAY<=1; DELAY_COUNT <=0; 
		end
		
	else if (DELAY_COUNT == 2)  // +1sec after
		begin 
			DELAY <= 2;  DELAY_COUNT <= DELAY_COUNT +1; 
		end
		
	else if (DELAY_COUNT == 6)  // +2sec after
		begin 
			DELAY <=3; 
		end  
		
	else                        //0.5sec에 한번 +1
		begin 
			DELAY_COUNT <= DELAY_COUNT +1; 
		end   
end




always@(DELAY or key_stop) // if com_choice occur
begin
if(key_stop==0)
STATE<=0;
else
  if(DELAY==3)
begin
  if(cwn >= 3)      //최종 우승 com(10판 6승제 ) 
    begin
    STATE <=8 ;  //SAD
    end

  else if(uwn >= 3) //최종 우승 user
    begin
    STATE <=7;   //HAPPY
    end

  else if (uwn <6 & cwn <6)
  begin
  STATE <=0;
end

end

  else 
    begin
    if (DELAY == 1)                                           //0~1sec
      case(cc)        //com_choice에 따라 해당 이미지 출력
      1 : STATE <=1;  //ROCK
      2 : STATE <=2;  //SCISSORS
      3 : STATE <=3;  //PAPER
		default : STATE <=0;
      endcase

    else if(DELAY == 2)                                       //1~3.5sec
      case(outcome)   //승패 결과에 따른 이미지 출력
      1 : begin STATE <=4;  end  //WIN
      0 : STATE <=5;  //DRAW
      2 : begin STATE <=6;  end //LOSE
		default : STATE <=0;				  
      endcase
	else STATE <=0;
    end
end


always@(posedge reset or posedge DELAY)
begin
if(reset)
begin
uwn =0;
cwn =0;
end
else
begin
if (DELAY==1)
case(outcome)
0:begin uwn<=uwn;cwn<=cwn;end
1: uwn<=uwn+1;
2: cwn<=cwn+1;
default : begin uwn<=uwn;cwn<=cwn;end
endcase
end
end




always@(row_show)
  if(STATE==1)
  case(row_show)
  0: begin dot_col <=  1; dot_row <=    14'b00000000000000 ; end
  1: begin dot_col <=  2; dot_row <=    14'b00000011111100 ; end
  2: begin dot_col <=  4; dot_row <=    14'b00000010000010 ; end
  3: begin dot_col <=  8; dot_row <=    14'b00000010000010 ; end
  4: begin dot_col <=  16; dot_row <=   14'b00000010000010 ; end
  5: begin dot_col <=  32; dot_row <=   14'b00000010000010 ; end
  6: begin dot_col <=  64; dot_row <=   14'b00000010000010 ; end
  7: begin dot_col <=  128; dot_row <=  14'b00000011111100 ; end
  8: begin dot_col <=  256; dot_row <=  14'b00000000000000 ; end
  9: begin dot_col <=  512; dot_row <=  14'b00000000000000 ; end
  endcase
  else if(STATE==2)
  case(row_show)
  0: begin dot_col <=  1; dot_row <=    14'b 00000000000000 ; end
  1: begin dot_col <=  2; dot_row <=    14'b 00000011111100 ; end
  2: begin dot_col <=  4; dot_row <=    14'b 00000010000010 ; end
  3: begin dot_col <=  8; dot_row <=    14'b 00000010000010 ; end
  4: begin dot_col <=  16; dot_row <=   14'b 00000010000010 ; end
  5: begin dot_col <=  32; dot_row <=   14'b 01111110000010 ; end
  6: begin dot_col <=  64; dot_row <=   14'b 00000010000010 ; end
  7: begin dot_col <=  128; dot_row <=  14'b 00111111111100 ; end
  8: begin dot_col <=  256; dot_row <=  14'b 00000000000000 ; end
  9: begin dot_col <=  512; dot_row <=  14'b 00000000000000 ; end
  endcase

  else if(STATE==3)
  case(row_show)
  0: begin dot_col <=  1; dot_row <=    14'b 00000000000000 ; end
  1: begin dot_col <=  2; dot_row <=    14'b 00111111111100 ; end
  2: begin dot_col <=  4; dot_row <=    14'b 00000010000010 ; end
  3: begin dot_col <=  8; dot_row <=    14'b 01111110000010 ; end
  4: begin dot_col <=  16; dot_row <=   14'b 00000010000010 ; end
  5: begin dot_col <=  32; dot_row <=   14'b 01111110000010 ; end
  6: begin dot_col <=  64; dot_row <=   14'b 00000010000010 ; end
  7: begin dot_col <=  128; dot_row <=  14'b 00111111111100 ; end
  8: begin dot_col <=  256; dot_row <=  14'b 00000000100000 ; end
  9: begin dot_col <=  512; dot_row <=  14'b 00000001000000 ; end
  endcase

  else if(STATE==0)
  case(row_show)
  0: begin dot_col <=  1; dot_row <=    14'b 00000000000000 ; end
  1: begin dot_col <=  2; dot_row <=    14'b 00000000000000 ; end
  2: begin dot_col <=  4; dot_row <=    14'b 00000000000000 ; end
  3: begin dot_col <=  8; dot_row <=    14'b 00000000000000 ; end
  4: begin dot_col <=  16; dot_row <=   14'b 00000000000000 ; end
  5: begin dot_col <=  32; dot_row <=   14'b 00000000000000 ; end
  6: begin dot_col <=  64; dot_row <=   14'b 00000000000000 ; end
  7: begin dot_col <=  128; dot_row <=  14'b 00000000000000 ; end
  8: begin dot_col <=  256; dot_row <=  14'b 00000000000000 ; end
  9: begin dot_col <=  512; dot_row <=  14'b 00000000000000 ; end
  endcase

  else if(STATE==4)
  case(row_show)
  0: begin dot_col <=  1;   dot_row <=DOT_ROW1[n1]; end
  1: begin dot_col <=  2;   dot_row <= DOT_ROW1[n1+1] ; end
  2: begin dot_col <=  4;   dot_row <= DOT_ROW1[n1+2] ; end
  3: begin dot_col <=  8;   dot_row <= DOT_ROW1[n1+3] ; end
  4: begin dot_col <=  16;  dot_row <= DOT_ROW1[n1+4] ; end
  5: begin dot_col <=  32;  dot_row <= DOT_ROW1[n1+5] ; end
  6: begin dot_col <=  64;  dot_row <= DOT_ROW1[n1+6] ; end
  7: begin dot_col <=  128; dot_row <= DOT_ROW1[n1+7] ; end
  8: begin dot_col <=  256; dot_row <= DOT_ROW1[n1+8] ; end
  9: begin dot_col <=  512; dot_row <= DOT_ROW1[n1+9] ; end
  endcase
  else if(STATE==5)
  case(row_show)
  0: begin dot_col <=  1;   dot_row <= DOT_ROW2[n1]; end
  1: begin dot_col <=  2;   dot_row <= DOT_ROW2[n1+1] ; end
  2: begin dot_col <=  4;   dot_row <= DOT_ROW2[n1+2] ; end
  3: begin dot_col <=  8;   dot_row <= DOT_ROW2[n1+3] ; end
  4: begin dot_col <=  16;  dot_row <= DOT_ROW2[n1+4] ; end
  5: begin dot_col <=  32;  dot_row <= DOT_ROW2[n1+5] ; end
  6: begin dot_col <=  64;  dot_row <= DOT_ROW2[n1+6] ; end
  7: begin dot_col <=  128; dot_row <= DOT_ROW2[n1+7] ; end
  8: begin dot_col <=  256; dot_row <= DOT_ROW2[n1+8] ; end
  9: begin dot_col <=  512; dot_row <= DOT_ROW2[n1+9] ; end
  endcase
else if(STATE==6)
  case(row_show)
  0: begin dot_col <=  1;   dot_row <= DOT_ROW3[n1]; end
  1: begin dot_col <=  2;   dot_row <= DOT_ROW3[n1+1] ; end
  2: begin dot_col <=  4;   dot_row <= DOT_ROW3[n1+2] ; end
  3: begin dot_col <=  8;   dot_row <= DOT_ROW3[n1+3] ; end
  4: begin dot_col <=  16;  dot_row <= DOT_ROW3[n1+4] ; end
  5: begin dot_col <=  32;  dot_row <= DOT_ROW3[n1+5] ; end
  6: begin dot_col <=  64;  dot_row <= DOT_ROW3[n1+6] ; end
  7: begin dot_col <=  128; dot_row <= DOT_ROW3[n1+7] ; end
  8: begin dot_col <=  256; dot_row <= DOT_ROW3[n1+8] ; end
  9: begin dot_col <=  512; dot_row <= DOT_ROW3[n1+9] ; end
  endcase
else if(STATE==7)
  case(row_show)
  0: begin dot_col <=  1;   dot_row <= DOT_ROW4[n2]; end
  1: begin dot_col <=  2;   dot_row <= DOT_ROW4[n2+1] ; end
  2: begin dot_col <=  4;   dot_row <= DOT_ROW4[n2+2] ; end
  3: begin dot_col <=  8;   dot_row <= DOT_ROW4[n2+3] ; end
  4: begin dot_col <=  16;  dot_row <= DOT_ROW4[n2+4] ; end
  5: begin dot_col <=  32;  dot_row <= DOT_ROW4[n2+5] ; end
  6: begin dot_col <=  64;  dot_row <= DOT_ROW4[n2+6] ; end
  7: begin dot_col <=  128; dot_row <= DOT_ROW4[n2+7] ; end
  8: begin dot_col <=  256; dot_row <= DOT_ROW4[n2+8] ; end
  9: begin dot_col <=  512; dot_row <= DOT_ROW4[n2+9] ; end
  endcase
else if(STATE==8)
  case(row_show)
  0: begin dot_col <=  1;   dot_row <= DOT_ROW5[n3]; end
  1: begin dot_col <=  2;   dot_row <= DOT_ROW5[n3+1] ; end
  2: begin dot_col <=  4;   dot_row <= DOT_ROW5[n3+2] ; end
  3: begin dot_col <=  8;   dot_row <= DOT_ROW5[n3+3] ; end
  4: begin dot_col <=  16;  dot_row <= DOT_ROW5[n3+4] ; end
  5: begin dot_col <=  32;  dot_row <= DOT_ROW5[n3+5] ; end
  6: begin dot_col <=  64;  dot_row <= DOT_ROW5[n3+6] ; end
  7: begin dot_col <=  128; dot_row <= DOT_ROW5[n3+7] ; end
  8: begin dot_col <=  256; dot_row <= DOT_ROW5[n3+8] ; end
  9: begin dot_col <=  512; dot_row <= DOT_ROW5[n3+9] ; end
  endcase


always@(negedge clk)
  begin
DOT_ROW1[0] = 14'b00000000000000;
DOT_ROW1[1] = 14'b00000000000000;
DOT_ROW1[2] = 14'b00000000000000;
DOT_ROW1[3] = 14'b00000000000000;
DOT_ROW1[4] = 14'b00000000000000;
DOT_ROW1[5] = 14'b00000000000000;
DOT_ROW1[6] = 14'b00000000000000;
DOT_ROW1[7] = 14'b00000000000000;
DOT_ROW1[8] = 14'b00000000000000;
DOT_ROW1[9] = 14'b00000000000000;
DOT_ROW1[10]  = 14'b00000000000000;
DOT_ROW1[11]  = 14'b00001111100000;
DOT_ROW1[12]  = 14'b00000000010000;
DOT_ROW1[13]  = 14'b00001111100000;
DOT_ROW1[14]  = 14'b00000000010000;
DOT_ROW1[15]  = 14'b00001111100000;
DOT_ROW1[16]  = 14'b00000000000000;
DOT_ROW1[17]  = 14'b00000000000000;
DOT_ROW1[18]  = 14'b00001000010000;
DOT_ROW1[19]  = 14'b00001111110000;
DOT_ROW1[20] = 14'b00001000010000;
DOT_ROW1[21] = 14'b00000000000000;
DOT_ROW1[22] = 14'b00000000000000;
DOT_ROW1[23] = 14'b00001111110000;
DOT_ROW1[24] = 14'b00000100000000;
DOT_ROW1[25] = 14'b00000010000000;
DOT_ROW1[26] = 14'b00000001000000;
DOT_ROW1[27] = 14'b00001111110000;
DOT_ROW1[28] = 14'b00000000000000;
DOT_ROW1[29] = 14'b00000000000000;
DOT_ROW1[30] = 14'b00001111010000;
DOT_ROW1[31] = 14'b00000000000000;
DOT_ROW1[32] = 14'b00001111010000;
DOT_ROW1[33] = 14'b00000000000000;
DOT_ROW1[34] = 14'b00000000000000;
DOT_ROW1[35] = 14'b00000000000000;
DOT_ROW1[36] = 14'b00000000000000;
DOT_ROW1[37] = 14'b00000000000000;
DOT_ROW1[38] = 14'b00000000000000;
DOT_ROW1[39] = 14'b00000000000000;
DOT_ROW1[40] = 14'b00000000000000;
DOT_ROW1[41] = 14'b00000000000000;
DOT_ROW1[42] = 14'b00000000000000;
DOT_ROW1[43] = 14'b00000000000000;

DOT_ROW2[0] = 14'b00000000000000;
DOT_ROW2[1] = 14'b00000000000000;
DOT_ROW2[2] = 14'b00000000000000;
DOT_ROW2[3] = 14'b00000000000000;
DOT_ROW2[4] = 14'b00000000000000;
DOT_ROW2[5] = 14'b00000000000000;
DOT_ROW2[6] = 14'b00000000000000;
DOT_ROW2[7] = 14'b00000000000000;
DOT_ROW2[8] = 14'b00000000000000;
DOT_ROW2[9] = 14'b00000000000000;
DOT_ROW2[10]  =14'b00000000000000;
DOT_ROW2[11]  =14'b00001111110000;
DOT_ROW2[12]  =14'b00001000010000;
DOT_ROW2[13]  =14'b00001000010000;
DOT_ROW2[14]  =14'b00000111100000;
DOT_ROW2[15]  =14'b00000000000000;
DOT_ROW2[16]  =14'b00000000000000;
DOT_ROW2[17]  =14'b00001111110000;
DOT_ROW2[18]  =14'b00001011000000;
DOT_ROW2[19]  =14'b00001010100000;
DOT_ROW2[20] =14'b00000110010000;
DOT_ROW2[21] =14'b00000000000000;
DOT_ROW2[22] =14'b00000000000000;
DOT_ROW2[23] =14'b00000111110000;
DOT_ROW2[24] =14'b00001010000000;
DOT_ROW2[25] =14'b00001010000000;
DOT_ROW2[26] =14'b00000111110000;
DOT_ROW2[27] =14'b00000000000000;
DOT_ROW2[28] =14'b00000000000000;
DOT_ROW2[29] =14'b00001111100000;
DOT_ROW2[30] =14'b00000000010000;
DOT_ROW2[31] =14'b00001111100000;
DOT_ROW2[32] =14'b00000000010000;
DOT_ROW2[33] =14'b00001111100000;
DOT_ROW2[34] =14'b00000000000000;
DOT_ROW2[35] =14'b00000000000000;
DOT_ROW2[36] =14'b00000000000000;
DOT_ROW2[37] =14'b00000000000000;
DOT_ROW2[38] =14'b00000000000000;
DOT_ROW2[39] =14'b00000000000000;
DOT_ROW2[40] =14'b00000000000000;
DOT_ROW2[41] =14'b00000000000000;
DOT_ROW2[42] =14'b00000000000000;
DOT_ROW2[43] =14'b00000000000000;

DOT_ROW3[0] = 14'b00000000000000;
DOT_ROW3[1] = 14'b00000000000000;
DOT_ROW3[2] = 14'b00000000000000;
DOT_ROW3[3] = 14'b00000000000000;
DOT_ROW3[4] = 14'b00000000000000;
DOT_ROW3[5] = 14'b00000000000000;
DOT_ROW3[6] = 14'b00000000000000;
DOT_ROW3[7] = 14'b00000000000000;
DOT_ROW3[8] = 14'b00000000000000;
DOT_ROW3[9] = 14'b00000000000000;
DOT_ROW3[10]  =14'b00000000000000;
DOT_ROW3[11]  =14'b00001111110000;
DOT_ROW3[12]  =14'b00000000010000;
DOT_ROW3[13]  =14'b00000000010000;
DOT_ROW3[14]  =14'b00000000010000;
DOT_ROW3[15]  =14'b00000000000000;
DOT_ROW3[16]  =14'b00000000000000;
DOT_ROW3[17]  =14'b00000111100000;
DOT_ROW3[18]  =14'b00001000010000;
DOT_ROW3[19]  =14'b00001000010000;
DOT_ROW3[20] =14'b00000111100000;
DOT_ROW3[21] =14'b00000000000000;
DOT_ROW3[22] =14'b00000000000000;
DOT_ROW3[23] =14'b00000110010000;
DOT_ROW3[24] =14'b00001010010000;
DOT_ROW3[25] =14'b00001010010000;
DOT_ROW3[26] =14'b00001011100000;
DOT_ROW3[27] =14'b00000000000000;
DOT_ROW3[28] =14'b00000000000000;
DOT_ROW3[29] =14'b00001111110000;
DOT_ROW3[30] =14'b00001010010000;
DOT_ROW3[31] =14'b00001010010000;
DOT_ROW3[32] =14'b00001010010000;
DOT_ROW3[33] =14'b00000000000000;
DOT_ROW3[34] =14'b00000000000000;
DOT_ROW3[35] =14'b00000000000000;
DOT_ROW3[36] =14'b00000000000000;
DOT_ROW3[37] =14'b00000000000000;
DOT_ROW3[38] =14'b00000000000000;
DOT_ROW3[39] =14'b00000000000000;
DOT_ROW3[40] =14'b00000000000000;
DOT_ROW3[41] =14'b00000000000000;
DOT_ROW3[42] =14'b00000000000000;
DOT_ROW3[43] =14'b00000000000000;

DOT_ROW4[0]  =14'b00000000000000;
DOT_ROW4[1]  =14'b00000000000000;
DOT_ROW4[2]  =14'b00011001000000;
DOT_ROW4[3]  =14'b00000000100000;
DOT_ROW4[4]  =14'b00000000010000;
DOT_ROW4[5]  =14'b00000000010000;
DOT_ROW4[6]  =14'b00000000100000;
DOT_ROW4[7]  =14'b00011001000000;
DOT_ROW4[8]  =14'b00000000000000;
DOT_ROW4[9]  =14'b00000000000000;
DOT_ROW4[10] =14'b00000000000000;
DOT_ROW4[11] =14'b00001000000000;
DOT_ROW4[12] =14'b00010001000000;
DOT_ROW4[13] =14'b00001001100000;
DOT_ROW4[14] =14'b00000001010000;
DOT_ROW4[15] =14'b00000001010000;
DOT_ROW4[16] =14'b00001001100000;
DOT_ROW4[17] =14'b00010001000000;
DOT_ROW4[18] =14'b00001000000000;
DOT_ROW4[19] =14'b00000000000000;

DOT_ROW5[0]  =14'b00000000000000;
DOT_ROW5[1]  =14'b00010000000000;
DOT_ROW5[2]  =14'b00010000000000;
DOT_ROW5[3]  =14'b00010000100000;
DOT_ROW5[4]  =14'b00000001000000;
DOT_ROW5[5]  =14'b00000001000000;
DOT_ROW5[6]  =14'b00010000100000;
DOT_ROW5[7]  =14'b00010000000000;
DOT_ROW5[8]  =14'b00010000000000;
DOT_ROW5[9]  =14'b00000000000000;
DOT_ROW5[10] =14'b00000000000000;
DOT_ROW5[11] =14'b00010000000000;
DOT_ROW5[12] =14'b00011000000000;
DOT_ROW5[13] =14'b00010000100000;
DOT_ROW5[14] =14'b00000001000000;
DOT_ROW5[15] =14'b00000001000000;
DOT_ROW5[16] =14'b00010000100000;
DOT_ROW5[17] =14'b00011000000000;
DOT_ROW5[18] =14'b00010000000000;
DOT_ROW5[19] =14'b00000000000000;
DOT_ROW5[20] =14'b00000000000000;
DOT_ROW5[21] =14'b00010000000000;
DOT_ROW5[22] =14'b00011100000000;
DOT_ROW5[23] =14'b00010000100000;
DOT_ROW5[24] =14'b00000001000000;
DOT_ROW5[25] =14'b00000001000000;
DOT_ROW5[26] =14'b00010000100000;
DOT_ROW5[27] =14'b00011100000000;
DOT_ROW5[28] =14'b00010000000000;
DOT_ROW5[29] =14'b00000000000000;
DOT_ROW5[30] =14'b00000000000000;
DOT_ROW5[31] =14'b00010000000000;
DOT_ROW5[32] =14'b00011110000000;
DOT_ROW5[33] =14'b00010000100000;
DOT_ROW5[34] =14'b00000001000000;
DOT_ROW5[35] =14'b00000001000000;
DOT_ROW5[36] =14'b00010000100000;
DOT_ROW5[37] =14'b00011110000000;
DOT_ROW5[38] =14'b00010000000000;
DOT_ROW5[39] =14'b00000000000000;
  end



endmodule
