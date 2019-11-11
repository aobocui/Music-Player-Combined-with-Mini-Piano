`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:36:20 11/16/2016 
// Design Name: 
// Module Name:    music3 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module piano(clk,song_sel,led,speakers,light_9,type,a, b, push);

input a, b, push;
reg qa = 0, qb = 0;
reg qa_dly = 0;
reg rot_event = 0; 
reg rot_left = 0;


input clk;
input song_sel;
output [6:0]led; 
input type;//模式控制
reg speaker;
output speakers;
output [7:0]light_9;
reg[7:0] lcd_9;

reg [31:0]p;
reg clk_8Hz;
always@(posedge clk)
	begin
		if(p==25000000/4-1)			
		begin clk_8Hz=~clk_8Hz;
			p<=0;
			end
		else p<=p+1;
	end	
reg[2:0] code;//简谱码0、1、2、3、4、5、6、7
reg[6:0] led;//指示0,1,2,3,4,5,6,7
reg[4:0] note;//乐曲曲谱中的音符输出：0~21
reg [1069:0]buf_music1;
		reg [639:0]buf_music2;
		parameter s0=1'b0,s1=1'b1;
		reg state1,state2;
		reg [9:0]cnt;//计数器的位数由存放音乐的长度决定
//将整首乐曲记录在一个参数里：每个音符用{高中低音，简谱码}表示
//2位高中低音：00表示低音，01表示中音，10表示高音
//3位简谱码对应：0、1、2、3、4、5、6、7
parameter music1={{2'b01,3'd7},{2'b01,3'd7},{2'b01,3'd6},{2'b01,3'd6},{2'b01,3'd7},{2'b01,3'd7},
{2'b01,3'd5},{2'b01,3'd5},{2'b01,3'd5},{2'b01,3'd6},{2'b01,3'd4},{2'b01,3'd4},{2'b01,3'd3},{2'b01,3'd3},
{2'b01,3'd2},{2'b01,3'd3},{2'b01,3'd4},{2'b01,3'd3},{2'b01,3'd5},{2'b01,3'd5},{2'b01,3'd5},{2'b01,3'd3},
{2'b01,3'd2},{2'b01,3'd3},{2'b01,3'd5},{2'b01,3'd2},{2'b01,3'd3},{2'b01,3'd4},{2'b01,3'd3},{2'b01,3'd2},
{2'b01,3'd1},{2'b01,3'd1},{2'b01,3'd1},{2'b01,3'd1},{2'b01,3'd1},{2'b01,3'd1},{2'b01,3'd5},{2'b01,3'd5},
{2'b00,3'd7},{2'b00,3'd7},{2'b01,3'd2},{2'b01,3'd2},{2'b00,3'd6},{2'b00,3'd6},{2'b01,3'd1},{2'b01,3'd1},
{2'b00,3'd5},{2'b00,3'd5},{2'b00,3'd5},{2'b00,3'd5},{2'b00,3'd5},{2'b00,3'd5},{2'b00,3'd6},{2'b01,3'd1},
{2'b00,3'd5},{2'b00,3'd5},{2'b00,3'd5},{2'b00,3'd5},{2'b00,3'd5},{2'b00,3'd5},{2'b00,3'd5},{2'b00,3'd5},
{2'b00,3'd3},{2'b00,3'd3},{2'b00,3'd3},{2'b00,3'd3},{2'b00,3'd5},{2'b00,3'd5},{2'b00,3'd5},{2'b00,3'd6},
{2'b01,3'd1},{2'b01,3'd1},{2'b01,3'd1},{2'b01,3'd2},{2'b00,3'd6},{2'b01,3'd1},{2'b00,3'd5},{2'b00,3'd5},
{2'b01,3'd5},{2'b01,3'd5},{2'b01,3'd5},{2'b10,3'd1},{2'b01,3'd6},{2'b01,3'd5},{2'b01,3'd3},{2'b01,3'd5},
{2'b01,3'd2},{2'b01,3'd2},{2'b01,3'd2},{2'b01,3'd2},{2'b01,3'd2},{2'b01,3'd2},{2'b01,3'd2},{2'b01,3'd2},
{2'b01,3'd2},{2'b01,3'd2},{2'b01,3'd2},{2'b01,3'd3},{2'b00,3'd7},{2'b00,3'd7},{2'b00,3'd6},{2'b00,3'd6},
{2'b00,3'd5},{2'b00,3'd5},{2'b00,3'd5},{2'b00,3'd6},{2'b01,3'd1},{2'b01,3'd1},{2'b01,3'd2},{2'b01,3'd2},		
{2'b00,3'd3},{2'b00,3'd3},{2'b01,3'd1},{2'b01,3'd1},{2'b00,3'd6},{2'b00,3'd5},{2'b00,3'd6},{2'b01,3'd1},
{2'b00,3'd5},{2'b00,3'd5},{2'b00,3'd5},{2'b00,3'd5},{2'b00,3'd5},{2'b00,3'd5},{2'b00,3'd5},{2'b00,3'd5},	
{2'b01,3'd3},{2'b01,3'd3},{2'b01,3'd3},{2'b01,3'd5},{2'b00,3'd7},{2'b00,3'd7},{2'b01,3'd2},{2'b01,3'd2},
{2'b00,3'd6},{2'b01,3'd1},{2'b00,3'd5},{2'b00,3'd5},{2'b00,3'd5},{2'b00,3'd5},{2'b00,3'd5},{2'b00,3'd5},
{2'b00,3'd3},{2'b00,3'd5},{2'b00,3'd5},{2'b00,3'd3},{2'b00,3'd5},{2'b00,3'd6},{2'b00,3'd7},{2'b01,3'd2},	
{2'b00,3'd6},{2'b00,3'd6},{2'b00,3'd6},{2'b00,3'd6},{2'b00,3'd6},{2'b00,3'd6},{2'b00,3'd5},{2'b00,3'd6},	
{2'b01,3'd1},{2'b01,3'd1},{2'b01,3'd1},{2'b01,3'd2},{2'b01,3'd5},{2'b01,3'd5},{2'b01,3'd3},{2'b01,3'd3},	
{2'b01,3'd2},{2'b01,3'd2},{2'b01,3'd3},{2'b01,3'd2},{2'b01,3'd1},{2'b01,3'd1},{2'b00,3'd6},{2'b00,3'd5},
{2'b00,3'd3},{2'b00,3'd3},{2'b00,3'd3},{2'b00,3'd3},{2'b01,3'd1},{2'b01,3'd1},{2'b01,3'd1},{2'b01,3'd1},	
{2'b00,3'd6},{2'b01,3'd1},{2'b00,3'd6},{2'b00,3'd5},{2'b00,3'd3},{2'b00,3'd5},{2'b00,3'd6},{2'b01,3'd1},	
{2'b00,3'd5},{2'b00,3'd5},{2'b00,3'd5},{2'b00,3'd5},{2'b00,3'd5},{2'b00,3'd5},{2'b01,3'd3},{2'b01,3'd5},
{2'b01,3'd2},{2'b01,3'd3},{2'b01,3'd2},{2'b01,3'd1},{2'b00,3'd7},{2'b00,3'd7},{2'b00,3'd6},{2'b00,3'd6},
{2'b00,3'd5},{2'b00,3'd5},{2'b00,3'd5},{2'b00,3'd5},{2'b00,3'd5},{2'b00,3'd5},{2'b00,3'd5},{2'b00,3'd5}};
parameter music2={{2'd1,3'd1},{2'd1,3'd1},{2'd1,3'd1},{2'd1,3'd1},
{2'd1,3'd2},{2'd1,3'd2},{2'd1,3'd2},{2'd1,3'd2},
{2'd1,3'd3},{2'd1,3'd3},{2'd1,3'd3},{2'd1,3'd3},
{2'd1,3'd1},{2'd1,3'd1},{2'd1,3'd1},{2'd1,3'd1},
{2'd1,3'd1},{2'd1,3'd1},{2'd1,3'd1},{2'd1,3'd1},	
{2'd1,3'd2},{2'd1,3'd2},{2'd1,3'd2},{2'd1,3'd2},
{2'd1,3'd3},{2'd1,3'd3},{2'd1,3'd3},{2'd1,3'd3},
{2'd1,3'd1},{2'd1,3'd1},{2'd1,3'd1},{2'd1,3'd1},
{2'd1,3'd3},{2'd1,3'd3},{2'd1,3'd3},{2'd1,3'd3},
{2'd1,3'd4},{2'd1,3'd4},{2'd1,3'd4},{2'd1,3'd4},
{2'd1,3'd5},{2'd1,3'd5},{2'd1,3'd5},{2'd1,3'd5},
{2'd1,3'd5},{2'd1,3'd5},{2'd1,3'd5},{2'd1,3'd5},
{2'd1,3'd3},{2'd1,3'd3},{2'd1,3'd3},{2'd1,3'd3},
{2'd1,3'd4},{2'd1,3'd4},{2'd1,3'd4},{2'd1,3'd4},
{2'd1,3'd5},{2'd1,3'd5},{2'd1,3'd5},{2'd1,3'd5},
{2'd1,3'd5},{2'd1,3'd5},{2'd1,3'd5},{2'd1,3'd6},
{2'd1,3'd5},{2'd1,3'd5},{2'd1,3'd5},{2'd1,3'd4},
{2'd1,3'd3},{2'd1,3'd3},{2'd1,3'd3},{2'd1,3'd3},
{2'd1,3'd1},{2'd1,3'd1},{2'd1,3'd1},{2'd1,3'd1},
{2'd1,3'd5},{2'd1,3'd5},{2'd1,3'd5},{2'd1,3'd6},
{2'd1,3'd5},{2'd1,3'd5},{2'd1,3'd5},{2'd1,3'd4},
{2'd1,3'd3},{2'd1,3'd3},{2'd1,3'd3},{2'd1,3'd3},
{2'd1,3'd1},{2'd1,3'd1},{2'd1,3'd1},{2'd1,3'd1},
{2'd1,3'd1},{2'd1,3'd1},{2'd1,3'd1},{2'd1,3'd1},
{2'd1,3'd5},{2'd1,3'd5},{2'd1,3'd5},{2'd1,3'd5},
{2'd1,3'd1},{2'd1,3'd1},{2'd1,3'd1},{2'd1,3'd1},
{2'd1,3'd1},{2'd1,3'd1},{2'd1,3'd1},{2'd1,3'd1},
{2'd1,3'd5},{2'd1,3'd5},{2'd1,3'd5},{2'd1,3'd5},
{2'd1,3'd1},{2'd1,3'd1},{2'd1,3'd1},{2'd1,3'd1}};


always @(posedge clk)		
begin
case ({a,b})
	2'b00:
		begin
			qa <= 0;
			qb <= qb;
		end
	2'b11:
		begin
			qa <= 1;
			qb <= qb;
		end
	2'b01:
		begin
			qa <= qa;
			qb <= 1;
		end
	2'b10:
		begin
			qa <= qa;
			qb <= 0;
		end
	default:
		begin
			qa <= qa;
			qb <= qb;
		end
endcase
end

always @(posedge clk)		
begin
	qa_dly <= qa;			
	if ((qa_dly == 0) && (qa == 1))		
		begin
			rot_event = 1; 
			rot_left = qb;		
		end
	else
		begin
			rot_event = 0; 
			rot_left = rot_left;
		end
end

reg [31:0]flag;
initial flag=0;

reg [31:0]flags;
always @(posedge clk)
begin		
			if (rot_event==1&&rot_left==1)
				begin
			flag<=flag-1;
				end
			else if(rot_event==1&&rot_left==0)
				begin
			flag<=flag+1;
				end
			if(push)
			flags<=flag;
end



always @(posedge clk_8Hz)
	begin
		
		if(song_sel)//多首曲子根据按键进行选择
			begin
						case(state1)
								s0:begin 
										buf_music1[1069:0]<=music1;
										state1<=s1;
										cnt<=0;
									end
								s1:if(cnt==(1070/5-1))
											begin 
											cnt<=0;
											state1<=s0;
											end
									else 
											begin 
											cnt<=cnt+1;
											buf_music1[1069:0]<=buf_music1[1069:0]<<5;
											end
								default:state1<=s0;
						endcase
							note=buf_music1[1067:1065]+7*buf_music1[1069:1068];
							code=buf_music1[1067:1065];
							led=(buf_music1[1067:1065]==3'b001)?7'b0000001:((buf_music1[1067:1065]==3'b010)?7'b0000010:((buf_music1[1067:1065]==3'b011)?7'b0000100:((buf_music1[1067:1065]==3'b100)?7'b0001000:((buf_music1[1067:1065]==3'b101)?7'b0010000:((buf_music1[1067:1065]==3'b110)?7'b0100000:((buf_music1[1067:1065]==3'b111)?7'b1000000:7'b1111111))))));
				end
		else
				begin
					case(state2)
						s0:
								begin 
								buf_music2[639:0]<=music2;
								state2<=s1;cnt<=0;
								end
						s1:
								if(cnt==(640/5-1))
								begin cnt<=0;state2<=s0;
								end
								else 
								begin cnt<=cnt+1;
								buf_music2[639:0]<=buf_music2[639:0]<<5;
								end
								default:state2<=s0;
				    endcase
					note=buf_music2[637:635]+7*buf_music2[639:638];
					code=buf_music2[637:635];
					led=(buf_music2[637:635]==3'b001)?7'b0000001:((buf_music2[637:635]==3'b010)?7'b0000010:((buf_music2[637:635]==3'b011)?7'b0000100:((buf_music2[637:635]==3'b100)?7'b0001000:((buf_music2[637:635]==3'b101)?7'b0010000:((buf_music2[637:635]==3'b110)?7'b0100000:((buf_music2[637:635]==3'b111)?7'b1000000:7'b1111111))))));
					end
				end
				

reg[10:0]Tone;
//1MHz分频预置数，跟音符相匹配
parameter pre_divf={11'b11111111111,11'd137,11'd345,11'd531,11'd616,11'd773,11'd912,11'd1036,11'd1092,11'd1197,11'd1290,11'd1332,11'd1410,11'd1480,11'd1542,11'd1570,11'd1622,11'd1668,11'd1690,11'd1728,11'd1764,11'd1795};
reg[241:0]pre_divf_buf;


task ascll;
input[3:0]ascll_in;
output[7:0]ascll_out;
		begin
			case(ascll_in)
			4'b0000: ascll_out=8'b00110000;
			4'b0001: ascll_out=8'b00110001;
			4'b0010: ascll_out=8'b00110010;
			4'b0011: ascll_out=8'b00110011;
			4'b0100: ascll_out=8'b00110100;
			4'b0101: ascll_out=8'b00110101;
			4'b0110: ascll_out=8'b00110110;
			4'b0111: ascll_out=8'b00110111;
			4'b1000: ascll_out=8'b00111000;
			4'b1001: ascll_out=8'b00111001;
			default: ascll_out=8'b0010000;
			endcase
		end
endtask

always@(code or flags)//输出显示
	begin	
	if(type)
		ascll(code,lcd_9);
	else
		ascll(flag,lcd_9);
	end
	
assign light_9=lcd_9;




always@(note or flags)//根据音符得到对应的分频数
	begin
			if(type)
			begin
				pre_divf_buf=pre_divf;
				pre_divf_buf=pre_divf_buf<<(note*11);
				Tone=pre_divf_buf[241:231];//每次读一个音符（音符对应11位预置）
			end	
			else	
			begin
			pre_divf_buf=pre_divf;
				pre_divf_buf=pre_divf_buf<<(flag*11);
				Tone=pre_divf_buf[241:231];//每次读一个音符（音符对应11位预置）
				end
  end
reg PreCLK,FullSpkS;
reg [6:0]count;
always @(posedge clk)
	begin		
		PreCLK<=0;//将CLK进行25分频，PreCLK为CLK的25分频
		if(count>24)
			begin 
			PreCLK<=1;
			count=0;
			end
		else
			count=count+1;
	end
	
reg [10:0]Count11;	

always@(posedge PreCLK)
	begin//11位可预置计数器
		
		if(Count11==11'h7FF)
			begin 
			Count11=Tone;
			FullSpkS<=1;
			end
		else
			begin 
			Count11=Count11+1;
			FullSpkS<=0;
			end
		end
		
		
always@(posedge FullSpkS)
	begin//将输出再2分频，展宽脉冲，使扬声器有足够的功率发声
		speaker=~speaker;
	end
assign speakers=speaker;
endmodule

