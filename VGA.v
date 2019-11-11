`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:43:25 11/21/2015 
// Design Name: 
// Module Name:    VGA 
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
module VGA(clk,rst2,hsync,vsync,vga_r,vga_g,vga_b,a, b);
input a,b;
 input clk;    //50MHz
 input rst2;  //低电平复位
 
output hsync;  //行同步信号
output vsync;
//颜色信号线RGB
output vga_r; 
output vga_g;
output vga_b;
//----------------------------------------------------------------------
reg [10:0] x_cnt; //行坐标
reg [9:0] y_cnt;  //列坐标
//-----------------------------------------------------------------
wire [10:0]xpos;  //有效显示行坐标
wire [9:0]ypos;  //有效显示列坐标
//------------------------------------------------------------------
reg hsync_r,vsync_r;           //同步信号
wire valid;                    //有效显示区标志
reg [2:0]vga_rgb;              //显示像素颜色
reg [5:0]char1_bit;             //取模的位数
//-------------------------------------------------------------------
//定义存放数据的寄存器
reg [15:0]char_line0[9:0];
reg [15:0]char_line1[9:0];
reg [15:0]char_line2[9:0];
reg [15:0]char_line3[9:0];
reg [15:0]char_line4[9:0];
reg [15:0]char_line5[9:0];
reg [15:0]char_line6[9:0];
reg [15:0]char_line7[9:0];
reg [15:0]char_line8[9:0];
reg [15:0]char_line9[9:0];
reg [15:0]char_line10[9:0];
reg [15:0]char_line11[9:0];
reg [15:0]char_line12[9:0];
reg [15:0]char_line13[9:0];
reg [15:0]char_line14[9:0];
reg [15:0]char_line15[9:0];
reg [15:0]char_line16[9:0];
reg [15:0]char_line17[9:0];
reg [15:0]char_line18[9:0];
reg [15:0]char_line19[9:0];
reg [15:0]char_line20[9:0];
reg [15:0]char_line21[9:0];
reg [15:0]char_line22[9:0];
reg [15:0]char_line23[9:0];
reg [15:0]char_line24[9:0];
reg [15:0]char_line25[9:0];
reg [15:0]char_line26[9:0];
reg [15:0]char_line27[9:0];
reg [15:0]char_line28[9:0];
reg [15:0]char_line29[9:0];
reg [15:0]char_line30[9:0];
reg [15:0]char_line31[9:0];
//-------------------------------------------------------------------------------------
//定义扫描显示的数据，wire型
wire [95:0]line0;                //第1行
wire [95:0]line1;                //第2行
wire [95:0]line2;                //第3行
wire [95:0]line3;                //第4行
wire [95:0]line4;                //第5行
wire [95:0]line5;                //第6行
wire [95:0]line6;                //第7行
wire [95:0]line7;                //第8行
wire [95:0]line8;                //第9行
wire [95:0]line9;                //第10行
wire [95:0]line10;               //第11行
wire [95:0]line11;               //第12行
wire [95:0]line12;               //第13行
wire [95:0]line13;               //第14行
wire [95:0]line14;               //第15行
wire [95:0]line15;               //第16行
wire [95:0]line16;               //第17行 
wire [95:0]line17;               //第18行
wire [95:0]line18;               //第19行
wire [95:0]line19;               //第20行
wire [95:0]line20;               //第21行
wire [95:0]line21;               //第22行
wire [95:0]line22;               //第23行 
wire [95:0]line23;               //第24行
wire [95:0]line24;               //第25行
wire [95:0]line25;               //第26行 
wire [95:0]line26;               //第27行
wire [95:0]line27;               //第28行 
wire [95:0]line28;               //第29行
wire [95:0]line29;               //第30行
wire [95:0]line30;               //第31行
wire [95:0]line31;               //第32行
//---------------------------------------------------------------------------------------
wire [25:0]cnt;       
reg [25:0]cnt_r;             //计数，产生一秒的时间
//reg [3:0]ge_r,shi_r,bai_r;   //计数时间，三位数，个十百
wire [3:0]shi1,shi2,fen1,fen2,miao1,miao2; 
//---------------------------------------------------------------------------------------
//将0123456789的取模数据存入到寄存器中，16*32
//每个字符将其最上面的数据存到line0中，然后依次往下推
//将数字x的取模数据存到地址为x的寄存器中，例如0的数据就存到地址为0的存储单元中
always 
begin
          char_line0[0] <= 16'h0000;    //0的字模
          char_line1[0] <= 16'h0000;
          char_line2[0] <= 16'h0000;
          char_line3[0] <= 16'h0000;
          char_line4[0] <= 16'h0000;
          char_line5[0] <= 16'h0000;
          char_line6[0] <= 16'h03f0;
          char_line7[0] <= 16'h0738;
          char_line8[0] <= 16'h0e1c;
          char_line9[0] <= 16'h1c0e;
          char_line10[0] <= 16'h1c0e;
          char_line11[0] <= 16'h1c06;
          char_line12[0] <= 16'h3807;
          char_line13[0] <= 16'h3807;
          char_line14[0] <= 16'h3807;
          char_line15[0] <= 16'h3807;
          char_line16[0] <= 16'h3807;
          char_line17[0] <= 16'h3807;
          char_line18[0] <= 16'h3807;
          char_line19[0] <= 16'h3807;
          char_line20[0] <= 16'h3807;
          char_line21[0] <= 16'h1c06;
          char_line22[0] <= 16'h1c0e;
          char_line23[0] <= 16'h1c0e;
          char_line24[0] <= 16'h0e1c;
          char_line25[0] <= 16'h0738;
          char_line26[0] <= 16'h03f0;
          char_line27[0] <= 16'h0000;
          char_line28[0] <= 16'h0000;
          char_line29[0] <= 16'h0000;
          char_line30[0] <= 16'h0000;  
          char_line31[0] <= 16'h0000; 
          
          char_line0[1] <= 16'h0000;    //1的字模
          char_line1[1] <= 16'h0000;
          char_line2[1] <= 16'h0000;
          char_line3[1] <= 16'h0000;
          char_line4[1] <= 16'h0000;
          char_line5[1] <= 16'h0000;
          char_line6[1] <= 16'h00c0;
          char_line7[1] <= 16'h01c0;
          char_line8[1] <= 16'h1fc0;
          char_line9[1] <= 16'h01c0;
          char_line10[1] <= 16'h01c0;
          char_line11[1] <= 16'h01c0;
          char_line12[1] <= 16'h01c0;
          char_line13[1] <= 16'h01c0;
          char_line14[1] <= 16'h01c0;
          char_line15[1] <= 16'h01c0;
          char_line16[1] <= 16'h01c0;
          char_line17[1] <= 16'h01c0;
          char_line18[1] <= 16'h01c0;
          char_line19[1] <= 16'h01c0;
          char_line20[1] <= 16'h01c0;
          char_line21[1] <= 16'h01c0;
          char_line22[1] <= 16'h01c0;
          char_line23[1] <= 16'h01c0;
          char_line24[1] <= 16'h01c0;
          char_line25[1] <= 16'h03e0;
          char_line26[1] <= 16'h1ffc;
          char_line27[1] <= 16'h0000;
          char_line28[1] <= 16'h0000;
          char_line29[1] <= 16'h0000;
          char_line30[1] <= 16'h0000;  
          char_line31[1] <= 16'h0000;
			 
          char_line0[2] <= 16'h0000;    //2的字模
          char_line1[2] <= 16'h0000;
          char_line2[2] <= 16'h0000;
          char_line3[2] <= 16'h0000;
          char_line4[2] <= 16'h0000;
          char_line5[2] <= 16'h0000;
          char_line6[2] <= 16'h07f0;
          char_line7[2] <= 16'h0c3c;
          char_line8[2] <= 16'h181c;
          char_line9[2] <= 16'h300e;
          char_line10[2] <= 16'h300e;
          char_line11[2] <= 16'h380e;
          char_line12[2] <= 16'h380e;
          char_line13[2] <= 16'h000e;
          char_line14[2] <= 16'h001c;
          char_line15[2] <= 16'h0018;
          char_line16[2] <= 16'h0030;
          char_line17[2] <= 16'h0060;
          char_line18[2] <= 16'h00c0;
          char_line19[2] <= 16'h0180;
          char_line20[2] <= 16'h0300;
          char_line21[2] <= 16'h0606;
          char_line22[2] <= 16'h0c06;
          char_line23[2] <= 16'h1806;
          char_line24[2] <= 16'h300e;
          char_line25[2] <= 16'h3ffc;
          char_line26[2] <= 16'h3ffc;
          char_line27[2] <= 16'h0000;
          char_line28[2] <= 16'h0000;
          char_line29[2] <= 16'h0000;
          char_line30[2] <= 16'h0000;  
          char_line31[2] <= 16'h0000;
			 
          char_line0[3] <= 16'h0000;    //3的字模
          char_line1[3] <= 16'h0000;
          char_line2[3] <= 16'h0000;
          char_line3[3] <= 16'h0000;
          char_line4[3] <= 16'h0000;
          char_line5[3] <= 16'h0000;
          char_line6[3] <= 16'h07e0;
          char_line7[3] <= 16'h1c78;
          char_line8[3] <= 16'h3838;
          char_line9[3] <= 16'h381c;
          char_line10[3] <= 16'h381c;
          char_line11[3] <= 16'h381c;
          char_line12[3] <= 16'h001c;
          char_line13[3] <= 16'h0038;
          char_line14[3] <= 16'h0070;
          char_line15[3] <= 16'h03e0;
          char_line16[3] <= 16'h0078;
          char_line17[3] <= 16'h001c;
          char_line18[3] <= 16'h000c;
          char_line19[3] <= 16'h000e;
          char_line20[3] <= 16'h000e;
          char_line21[3] <= 16'h380e;
          char_line22[3] <= 16'h380e;
          char_line23[3] <= 16'h380c;
          char_line24[3] <= 16'h381c;
          char_line25[3] <= 16'h1c38;
          char_line26[3] <= 16'h07e0;
          char_line27[3] <= 16'h0000;
          char_line28[3] <= 16'h0000;
          char_line29[3] <= 16'h0000;
          char_line30[3] <= 16'h0000;  
          char_line31[3] <= 16'h0000;
			 
          char_line0[4] <= 16'h0000;    //4的字模
          char_line1[4] <= 16'h0000;
          char_line2[4] <= 16'h0000;
          char_line3[4] <= 16'h0000;
          char_line4[4] <= 16'h0000;
          char_line5[4] <= 16'h0000;
          char_line6[4] <= 16'h0038;
          char_line7[4] <= 16'h0078;
          char_line8[4] <= 16'h0078;
          char_line9[4] <= 16'h00f8;
          char_line10[4] <= 16'h01f8;
          char_line11[4] <= 16'h01f8;
          char_line12[4] <= 16'h0378;
          char_line13[4] <= 16'h0778;
          char_line14[4] <= 16'h0678;
          char_line15[4] <= 16'h0c78;
          char_line16[4] <= 16'h0c78;
          char_line17[4] <= 16'h1878;
          char_line18[4] <= 16'h3078;
          char_line19[4] <= 16'h3078;
          char_line20[4] <= 16'h7eff;
          char_line21[4] <= 16'h0078;
          char_line22[4] <= 16'h0078;
          char_line23[4] <= 16'h0078;
          char_line24[4] <= 16'h0078;
          char_line25[4] <= 16'h0078;
          char_line26[4] <= 16'h0078;
          char_line27[4] <= 16'h03ff;
          char_line28[4] <= 16'h0000;
          char_line29[4] <= 16'h0000;
          char_line30[4] <= 16'h0000;  
          char_line31[4] <= 16'h0000;
			 
          char_line0[5] <= 16'h0000;    //5的字模
          char_line1[5] <= 16'h0000;
          char_line2[5] <= 16'h0000;
          char_line3[5] <= 16'h0000;
          char_line4[5] <= 16'h0000;
          char_line5[5] <= 16'h0000;
          char_line6[5] <= 16'h0ffe;
          char_line7[5] <= 16'h0ffe;
          char_line8[5] <= 16'h0c00;
          char_line9[5] <= 16'h0c00;
          char_line10[5] <= 16'h0c00;
          char_line11[5] <= 16'h1800;
          char_line12[5] <= 16'h1800;
          char_line13[5] <= 16'h1bf0;
          char_line14[5] <= 16'h1e38;
          char_line15[5] <= 16'h1c1c;
          char_line16[5] <= 16'h180c;
          char_line17[5] <= 16'h000e;
          char_line18[5] <= 16'h000e;
          char_line19[5] <= 16'h000e;
          char_line20[5] <= 16'h000e;
          char_line21[5] <= 16'h380e;
          char_line22[5] <= 16'h380e;
          char_line23[5] <= 16'h301c;
          char_line24[5] <= 16'h301c;
          char_line25[5] <= 16'h1838;
          char_line26[5] <= 16'h0fe0;
          char_line27[5] <= 16'h0000;
          char_line28[5] <= 16'h0000;
          char_line29[5] <= 16'h0000;
          char_line30[5] <= 16'h0000;  
          char_line31[5] <= 16'h0000;
			 
          char_line0[6] <= 16'h0000;    //6的字模
          char_line1[6] <= 16'h0000;
          char_line2[6] <= 16'h0000;
          char_line3[6] <= 16'h0000;
          char_line4[6] <= 16'h0000;
          char_line5[6] <= 16'h0000;
          char_line6[6] <= 16'h01f8;
          char_line7[6] <= 16'h038c;
          char_line8[6] <= 16'h060e;
          char_line9[6] <= 16'h0c0e;
          char_line10[6] <= 16'h1c00;
          char_line11[6] <= 16'h1c00;
          char_line12[6] <= 16'h1800;
          char_line13[6] <= 16'h3800;
          char_line14[6] <= 16'h39f8;
          char_line15[6] <= 16'h3f1c;
          char_line16[6] <= 16'h3e0e;
          char_line17[6] <= 16'h3c07;
          char_line18[6] <= 16'h3807;
          char_line19[6] <= 16'h3807;
          char_line20[6] <= 16'h3807;
          char_line21[6] <= 16'h3807;
          char_line22[6] <= 16'h1c07;
          char_line23[6] <= 16'h1c06;
          char_line24[6] <= 16'h0e0e;
          char_line25[6] <= 16'h071c;
          char_line26[6] <= 16'h03f0;
          char_line27[6] <= 16'h0000;
          char_line28[6] <= 16'h0000;
          char_line29[6] <= 16'h0000;
          char_line30[6] <= 16'h0000;  
          char_line31[6] <= 16'h0000;
			 
          char_line0[7] <= 16'h0000;    //7的字模
          char_line1[7] <= 16'h0000;
          char_line2[7] <= 16'h0000;
          char_line3[7] <= 16'h0000;
          char_line4[7] <= 16'h0000;
          char_line5[7] <= 16'h0000;
          char_line6[7] <= 16'h1ffe;
          char_line7[7] <= 16'h1ffe;
          char_line8[7] <= 16'h3c0c;
          char_line9[7] <= 16'h3818;
          char_line10[7] <= 16'h3018;
          char_line11[7] <= 16'h3030;
          char_line12[7] <= 16'h0030;
          char_line13[7] <= 16'h0060;
          char_line14[7] <= 16'h0060;
          char_line15[7] <= 16'h00c0;
          char_line16[7] <= 16'h00c0;
          char_line17[7] <= 16'h00c0;
          char_line18[7] <= 16'h0180;
          char_line19[7] <= 16'h0180;
          char_line20[7] <= 16'h0180;
          char_line21[7] <= 16'h0380;
          char_line22[7] <= 16'h0380;
          char_line23[7] <= 16'h0380;
          char_line24[7] <= 16'h0380;
          char_line25[7] <= 16'h0380;
          char_line26[7] <= 16'h0380;
          char_line27[7] <= 16'h0000;
          char_line28[7] <= 16'h0000;
          char_line29[7] <= 16'h0000;
          char_line30[7] <= 16'h0000;  
          char_line31[7] <= 16'h0000;
			 
          char_line0[8] <= 16'h0000;    //8的字模
          char_line1[8] <= 16'h0000;
          char_line2[8] <= 16'h0000;
          char_line3[8] <= 16'h0000;
          char_line4[8] <= 16'h0000;
          char_line5[8] <= 16'h0000;
          char_line6[8] <= 16'h03f0;
          char_line7[8] <= 16'h07f0;
          char_line8[8] <= 16'h1c1c;
          char_line9[8] <= 16'h380e;
          char_line10[8] <= 16'h380e;
          char_line11[8] <= 16'h380e;
          char_line12[8] <= 16'h3c0e;
          char_line13[8] <= 16'h1e1c;
          char_line14[8] <= 16'h0f18;
          char_line15[8] <= 16'h07f0;
          char_line16[8] <= 16'h0ff0;
          char_line17[8] <= 16'h1c78;
          char_line18[8] <= 16'h383c;
          char_line19[8] <= 16'h701e;
          char_line20[8] <= 16'h700e;
          char_line21[8] <= 16'h700e;
          char_line22[8] <= 16'h700e;
          char_line23[8] <= 16'h700e;
          char_line24[8] <= 16'h381c;
          char_line25[8] <= 16'h1c38;
          char_line26[8] <= 16'h07e0;
          char_line27[8] <= 16'h0000;
          char_line28[8] <= 16'h0000;
          char_line29[8] <= 16'h0000;
          char_line30[8] <= 16'h0000;  
          char_line31[8] <= 16'h0000;
			 
          char_line0[9] <= 16'h0000;    //9的字模
          char_line1[9] <= 16'h0000;
          char_line2[9] <= 16'h0000;
          char_line3[9] <= 16'h0000;
          char_line4[9] <= 16'h0000;
          char_line5[9] <= 16'h0000;
          char_line6[9] <= 16'h07e0;
          char_line7[9] <= 16'h1c30;
          char_line8[9] <= 16'h3818;
          char_line9[9] <= 16'h381c;
          char_line10[9] <= 16'h700c;
          char_line11[9] <= 16'h700e;
          char_line12[9] <= 16'h700e;
          char_line13[9] <= 16'h700e;
          char_line14[9] <= 16'h700e;
          char_line15[9] <= 16'h701e;
          char_line16[9] <= 16'h383e;
          char_line17[9] <= 16'h1c7e;
          char_line18[9] <= 16'h0fce;
          char_line19[9] <= 16'h000e;
          char_line20[9] <= 16'h001c;
          char_line21[9] <= 16'h001c;
          char_line22[9] <= 16'h001c;
          char_line23[9] <= 16'h3838;
          char_line24[9] <= 16'h3870;
          char_line25[9] <= 16'h38e0;
          char_line26[9] <= 16'h0fc0;
          char_line27[9] <= 16'h0000;
          char_line28[9] <= 16'h0000;
          char_line29[9] <= 16'h0000;
          char_line30[9] <= 16'h0000;  
          char_line31[9] <= 16'h0000;
end
//对时钟信号进行分频处理，并得到同步信号
always @ (posedge clk or negedge rst2) 
begin
 if(!rst2)
   x_cnt<=0;
 else if(x_cnt==1039)   //分频
   x_cnt<=0;
 else 
   x_cnt<=x_cnt+1'b1;
end
always @ (posedge clk or negedge rst2)
begin
  if(!rst2)
    y_cnt<=0;
  else if(y_cnt==665)   //分频
    y_cnt<=0;
  else if(x_cnt==1039)
    y_cnt<=y_cnt+1'b1;
end
always @ (posedge clk or negedge rst2)
begin
  if(!rst2)
    hsync_r<=1;
  else if(x_cnt==0)  
    hsync_r<=0;
  else if(x_cnt==120)      //行同步信号的产生
    hsync_r<=1;
end
 
always @ (posedge clk or negedge rst2)
begin
  if(!rst2)
    vsync_r<=1;
  else if(y_cnt==0) 
    vsync_r<=0;
  else if(y_cnt==6)        //场同步信号的产生
    vsync_r<=1;
end 
 
assign hsync=hsync_r;     //用组合逻辑连接寄存器，避免产生多余的寄存器
assign vsync=vsync_r;  
//-------------------------------------------------------------------------------------
// 有效显示区标志
assign valid = (x_cnt>=0) && (x_cnt<1039) && (y_cnt>=31) && (y_cnt<631);
//有效显示区坐标
assign xpos = x_cnt - 11'd0;
assign ypos = y_cnt - 10'd31;
//以上就是将vga显示的时序及显示有效坐标都写好了，下面给出各个坐标上要显示的像素的颜色
//-------------------------------------------------------------------------------------
//分频产生一秒的计时


always @ (posedge clk or negedge rst2)
begin
  if(!rst2)
    cnt_r<=0;
  else if(cnt_r==49_999_999)
    cnt_r<=0;
  else 
    cnt_r<=cnt_r+1'b1;
 end
 assign cnt=cnt_r;

always @ (posedge clk or negedge rst2)
begin
  if(!rst2)
    char1_bit<=6'h3f;
  else if(xpos==380)
    char1_bit<=95;
  else if(xpos>=380&&xpos<476)
    char1_bit<=char1_bit-1'b1;
end


//旋钮控制

reg [4:0]flag=1;
reg [31:0]xl,xh;//尚未初始化
initial xl=200;
initial xh=220;
//弹
assign finger = ( (xpos>=xl) && (xpos<=xh) ) && ( (ypos>=225) && (ypos<=250) );
//音阶
assign point1 = ( (xpos>=xl) && (xpos<=xh) ) && ( (ypos>=xl+280-30) && (ypos<=xh+280-30) );
//-------------------------------------------------- 
reg qa = 0, qb = 0;
reg qa_dly = 0;
reg rot_event = 0; 
reg rot_left = 0;
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

always @(posedge clk)
begin		
			if (rot_event==1&&rot_left==1)
				begin
			xl<=xl-11'd25;xh<=xh-11'd25;
				end
			else if(rot_event==1&&rot_left==0)
				begin
			xl<=xl+11'd25;xh<=xh+11'd25;
				end
			
end



//--------------------------------------------------
/*--------------------------------------------------------------------------------------



VGA彩色信号
RGB = 000  黑色    RGB = 100   红色
    = 001  蓝色        = 101   紫色
    = 010  绿色        = 110   黄色
    = 011  青色        = 111   白色
----------------------------------------------------------------------------------------*/
//VGA显示的坐标定位，显示为绿色，背景为白色
wire black1,black2,black3,black4,black5;
wire whiteb1,whiteb2,whiteb3,whiteb4,whiteb5,whiteb6,whiteb7,whiteb8,whiteb9,whiteb10,whiteb11,whiteb12,whiteb13,whiteb14;
wire whites1,whites2,whites3,whites4,whites5,whites6,whites7,whites8,whites9,whites10;
wire feng1,feng2,feng3,feng4,feng5;
wire lines1,lines2,lines3,lines4,lines5;
wire points1;
//黑
assign black1 = ( (xpos>=220) && (xpos<=225) ) && ( (ypos>=100) && (ypos<=150) );
assign black2 = ( (xpos>=245) && (xpos<=250) ) && ( (ypos>=100) && (ypos<=150) );
assign black3 = ( (xpos>=290) && (xpos<=295) ) && ( (ypos>=100) && (ypos<=150) );
assign black4 = ( (xpos>=315) && (xpos<=320) ) && ( (ypos>=100) && (ypos<=150) );
assign black5 = ( (xpos>=340) && (xpos<=345) ) && ( (ypos>=100) && (ypos<=150) );
assign black6 = ( (xpos>=360) && (xpos<=365) ) && ( (ypos>=100) && (ypos<=150) );
assign black7 = ( (xpos>=405) && (xpos<=410) ) && ( (ypos>=100) && (ypos<=150) );
assign black8 = ( (xpos>=430) && (xpos<=435) ) && ( (ypos>=100) && (ypos<=150) );
assign black9 = ( (xpos>=455) && (xpos<=460) ) && ( (ypos>=100) && (ypos<=150) );
assign black10 = ( (xpos>=500) && (xpos<=505) ) && ( (ypos>=100) && (ypos<=150) );
assign black11 = ( (xpos>=525) && (xpos<=530) ) && ( (ypos>=100) && (ypos<=150) );
assign black12 = ( (xpos>=570) && (xpos<=575) ) && ( (ypos>=100) && (ypos<=150) );
assign black13 = ( (xpos>=595) && (xpos<=600) ) && ( (ypos>=100) && (ypos<=150) );
assign black14 = ( (xpos>=620) && (xpos<=625) ) && ( (ypos>=100) && (ypos<=150) );
assign black15 = ( (xpos>=665) && (xpos<=670) ) && ( (ypos>=100) && (ypos<=150) );
//白大
assign whiteb1 = ( (xpos>=200) && (xpos<=220) ) && ( (ypos>=100) && (ypos<=200) );
assign whiteb2 = ( (xpos>=225) && (xpos<=245) ) && ( (ypos>=100) && (ypos<=200) );
assign whiteb3 = ( (xpos>=250) && (xpos<=270) ) && ( (ypos>=100) && (ypos<=200) );
assign whiteb4 = ( (xpos>=275) && (xpos<=295) ) && ( (ypos>=100) && (ypos<=200) );
assign whiteb5 = ( (xpos>=300) && (xpos<=320) ) && ( (ypos>=100) && (ypos<=200) );
assign whiteb6 = ( (xpos>=325) && (xpos<=345) ) && ( (ypos>=100) && (ypos<=200) );
assign whiteb7 = ( (xpos>=350) && (xpos<=370) ) && ( (ypos>=100) && (ypos<=200) );
assign whiteb8 = ( (xpos>=375) && (xpos<=395) ) && ( (ypos>=100) && (ypos<=200) );
assign whiteb9 = ( (xpos>=400) && (xpos<=420) ) && ( (ypos>=100) && (ypos<=200) );
assign whiteb10 = ( (xpos>=425) && (xpos<=445) ) && ( (ypos>=100) && (ypos<=200) );
assign whiteb11 = ( (xpos>=450) && (xpos<=470) ) && ( (ypos>=100) && (ypos<=200) );
assign whiteb12 = ( (xpos>=475) && (xpos<=495) ) && ( (ypos>=100) && (ypos<=200) );
assign whiteb13 = ( (xpos>=500) && (xpos<=520) ) && ( (ypos>=100) && (ypos<=200) );
assign whiteb14 = ( (xpos>=525) && (xpos<=545) ) && ( (ypos>=100) && (ypos<=200) );
assign whiteb15 = ( (xpos>=550) && (xpos<=570) ) && ( (ypos>=100) && (ypos<=200) );
assign whiteb16 = ( (xpos>=575) && (xpos<=595) ) && ( (ypos>=100) && (ypos<=200) );
assign whiteb17 = ( (xpos>=600) && (xpos<=620) ) && ( (ypos>=100) && (ypos<=200) );
assign whiteb18 = ( (xpos>=625) && (xpos<=645) ) && ( (ypos>=100) && (ypos<=200) );
assign whiteb19 = ( (xpos>=650) && (xpos<=670) ) && ( (ypos>=100) && (ypos<=200) );
assign whiteb20 = ( (xpos>=675) && (xpos<=695) ) && ( (ypos>=100) && (ypos<=200) );
assign whiteb21 = ( (xpos>=700) && (xpos<=720) ) && ( (ypos>=100) && (ypos<=200) );
//白小
assign whites1 = ( (xpos>=220) && (xpos<=222) ) && ( (ypos>=150) && (ypos<=200) );
assign whites2 = ( (xpos>=223) && (xpos<=225) ) && ( (ypos>=150) && (ypos<=200) );
assign whites3 = ( (xpos>=245) && (xpos<=247) ) && ( (ypos>=150) && (ypos<=200) );
assign whites4 = ( (xpos>=248) && (xpos<=250) ) && ( (ypos>=150) && (ypos<=200) );
assign whites5 = ( (xpos>=270) && (xpos<=272) ) && ( (ypos>=150) && (ypos<=200) );
assign whites6 = ( (xpos>=273) && (xpos<=275) ) && ( (ypos>=150) && (ypos<=200) );
assign whites7 = ( (xpos>=295) && (xpos<=297) ) && ( (ypos>=150) && (ypos<=200) );
assign whites8 = ( (xpos>=298) && (xpos<=300) ) && ( (ypos>=150) && (ypos<=200) );
assign whites9 = ( (xpos>=320) && (xpos<=322) ) && ( (ypos>=150) && (ypos<=200) );
assign whites10 = ( (xpos>=323) && (xpos<=325) ) && ( (ypos>=150) && (ypos<=200) );
assign whites11 = ( (xpos>=345) && (xpos<=347) ) && ( (ypos>=150) && (ypos<=200) );
assign whites12 = ( (xpos>=348) && (xpos<=350) ) && ( (ypos>=150) && (ypos<=200) );
assign whites13 = ( (xpos>=370) && (xpos<=372) ) && ( (ypos>=150) && (ypos<=200) );
assign whites14 = ( (xpos>=373) && (xpos<=375) ) && ( (ypos>=150) && (ypos<=200) );
assign whites15 = ( (xpos>=395) && (xpos<=397) ) && ( (ypos>=150) && (ypos<=200) );
assign whites16 = ( (xpos>=398) && (xpos<=400) ) && ( (ypos>=150) && (ypos<=200) );
assign whites17 = ( (xpos>=420) && (xpos<=422) ) && ( (ypos>=150) && (ypos<=200) );
assign whites18 = ( (xpos>=423) && (xpos<=425) ) && ( (ypos>=150) && (ypos<=200) );
assign whites19 = ( (xpos>=445) && (xpos<=447) ) && ( (ypos>=150) && (ypos<=200) );
assign whites20 = ( (xpos>=448) && (xpos<=405) ) && ( (ypos>=150) && (ypos<=200) );


//缝
assign feng1 = ( (xpos>=222) && (xpos<=223) ) && ( (ypos>=150) && (ypos<=200) );
assign feng2 = ( (xpos>=247) && (xpos<=248) ) && ( (ypos>=150) && (ypos<=200) );
assign feng3 = ( (xpos>=292) && (xpos<=293) ) && ( (ypos>=150) && (ypos<=200) );
assign feng4 = ( (xpos>=317) && (xpos<=318) ) && ( (ypos>=150) && (ypos<=200) );
assign feng5 = ( (xpos>=342) && (xpos<=343) ) && ( (ypos>=150) && (ypos<=200) );
assign feng6 = ( (xpos>=347) && (xpos<=348) ) && ( (ypos>=150) && (ypos<=200) );
assign feng7 = ( (xpos>=372) && (xpos<=373) ) && ( (ypos>=150) && (ypos<=200) );
assign feng8 = ( (xpos>=397) && (xpos<=398) ) && ( (ypos>=150) && (ypos<=200) );
assign feng9 = ( (xpos>=422) && (xpos<=423) ) && ( (ypos>=150) && (ypos<=200) );
assign feng10 = ( (xpos>=447) && (xpos<=448) ) && ( (ypos>=150) && (ypos<=200) );
assign feng11 = ( (xpos>=472) && (xpos<=473) ) && ( (ypos>=150) && (ypos<=200) );
assign feng12 = ( (xpos>=497) && (xpos<=498) ) && ( (ypos>=150) && (ypos<=200) );
assign feng13 = ( (xpos>=522) && (xpos<=523) ) && ( (ypos>=150) && (ypos<=200) );
assign feng14 = ( (xpos>=547) && (xpos<=548) ) && ( (ypos>=150) && (ypos<=200) );
assign feng15 = ( (xpos>=572) && (xpos<=573) ) && ( (ypos>=150) && (ypos<=200) );
assign feng16 = ( (xpos>=597) && (xpos<=598) ) && ( (ypos>=150) && (ypos<=200) );
assign feng17 = ( (xpos>=622) && (xpos<=623) ) && ( (ypos>=150) && (ypos<=200) );
assign feng18 = ( (xpos>=647) && (xpos<=648) ) && ( (ypos>=150) && (ypos<=200) );
assign feng19 = ( (xpos>=672) && (xpos<=673) ) && ( (ypos>=150) && (ypos<=200) );
assign feng20 = ( (xpos>=702) && (xpos<=703) ) && ( (ypos>=150) && (ypos<=200) );
//线
/*assign lines1 = ( (xpos>=200) && (xpos<=600) ) && ( (ypos>=300) && (ypos<=305) );
assign lines2 = ( (xpos>=200) && (xpos<=600) ) && ( (ypos>=330) && (ypos<=335) );
assign lines3 = ( (xpos>=200) && (xpos<=600) ) && ( (ypos>=360) && (ypos<=365) );
assign lines4 = ( (xpos>=200) && (xpos<=600) ) && ( (ypos>=390) && (ypos<=395) );
assign lines5 = ( (xpos>=200) && (xpos<=600) ) && ( (ypos>=420) && (ypos<=425) );*/



//弹
assign finger = ( (xpos>=xl) && (xpos<=xh) ) && ( (ypos>=225) && (ypos<=250) );



//音阶
/*assign points1 = ( (xpos>=xl) && (xpos<=xh) ) && ( (ypos>=538-xl/2) && (ypos<=558-xh/2) );*/
//-------------------------------------------------- 
always @ (posedge clk)
begin
 if(!valid) vga_rgb<=7;
 else 
 begin

     if(black1 | black2 | black3 | black4 | black5|black6 | black7 | black8 | black9 | black10| black11 | black12 | black13 | black14 | black15)
             vga_rgb<=0;
     else if(whiteb1 | whiteb2 | whiteb3 | whiteb4 | whiteb5 | whiteb6 | whiteb7 |whiteb8 | whiteb9 | whiteb10 | whiteb11 | whiteb12 | whiteb13 | whiteb14 | whiteb15 | whiteb16 | whiteb17 | whiteb18 | whiteb19 | whiteb20 | whiteb21)
             vga_rgb<=7;
     else if(whites1 | whites2 | whites3 | whites4 | whites5 | whites6 | whites7 | whites8 | whites9 | whites10 | whites11 
	  | whites12 | whites13 | whites14 | whites15 | whites16 | whites17 | whites18 | whites19 | whites20)
             vga_rgb<=7;
     else if(feng1 | feng2 | feng3 | feng4 | feng5 |feng6 | feng7 | feng8 | feng9 | feng10 |feng11 | feng12 | feng13 | feng14 | feng15 |feng16 | feng17 | feng18 | feng19 | feng20)
             vga_rgb<=0;
	/*else if(lines1 | lines2 | lines3 | lines4 | lines5 )
             vga_rgb<=7;*/
				 else if(finger)
				 vga_rgb<=7;
				/* else if(points1)
				 vga_rgb<=7;*/
  else
  vga_rgb<=0;
  end
end
//r,g,b控制液晶屏颜色显示
assign vga_r = vga_rgb[2];
assign vga_g = vga_rgb[1];
assign vga_b = vga_rgb[0];  
 
endmodule
