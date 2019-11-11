`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:42:48 11/21/2015 
// Design Name: 
// Module Name:    lcd 
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
module lcd( clk, LCD_E,reset,rst2, type,a,b,push,LCD_RS, LCD_RW, SF_D ,chg,cal,sw_3,hsync,vsync,vga_r,vga_g,vga_b,song_sel,led, speakers);
	 input a,b,push,type;
	 input clk,reset,rst2;
	 output [6:0]led;
	 output speakers;
    output reg LCD_E;//ʹ�ܶˣ�0---��Ч��1--�ɶ���д
    output reg LCD_RS;//0---���1----����
    output reg LCD_RW;//��д���� 0---д�� 1---��
    output  [11:8] SF_D;//�����ߣ�����λ
	 input song_sel;
	 input cal,chg,sw_3;//switch_1�л�1��ʱ��0�����  switch_2 1:���� switch_3 1:����
	 wire[8:0] light_0,light_1,light_2,light_3,light_4,light_5,light_6,light_7,light_8,light_9;
	 output hsync;  //��ͬ���ź�
    output vsync;
      //��ɫ�ź���RGB
	 output vga_r;
    output vga_g;
    output vga_b;
	 
	 
	 
	 reg [3:0]sf_d;
	 assign SF_D = sf_d;
	 
	 reg [7:0]dataTran;
	 reg inited;//�ж��Ƿ��Ѿ��ܹ���ʼ��
	 reg dataIn;//�жϴ�ʱ�Ƿ�������Ҫ����
	 reg cmd_data;//��ǰʱ���Ƿ�д����״̬
	 reg dataTranDone;//�ж������Ƿ��ͽ���
	 reg dataState;//��ǰʱ��??����д��?

	 reg state_change;
	 reg [20:0]cnt;
	 
	 reg [5:0]dspState;
	 reg dspState_change;
	 reg [24:0]dsp_cnt;
	 parameter dspStateA = 6'd0;
	 parameter dspStateB = 6'd1;
	 parameter dspStateC = 6'd2;
	 parameter dspStateD = 6'd3;
	 parameter dspStateE = 6'd4;
	 parameter dspStateF = 6'd5;
	 parameter dspStateG = 6'd6;
	 parameter dspStateD1 = 6'd7;
	 
	 reg [7:0]address;//��ַ
	 reg [7:0]dataWrite;//д�������
	 
	 initial begin
		dsp_cnt <= 25'd0;
		dspState_change <= 1'b1;
		dspState <= dspStateA;
	 end 
	 
	 always@(posedge clk)begin
		dsp_cnt <= dsp_cnt-1;
		if(reset)begin                       //�˴�ԭΪreset
			cmd_data <= 1'b0;//��������??ʽ
			dspState <= dspStateA;
			dspState_change <= 1'b1;
			dsp_cnt <= 25'd0;
			dataIn <= 1'b0;
			address<=8'hc0; //address <= (8'h00|8'h80);//��һ�е�һ��λ��
			dataWrite <= 8'h41;//A
		end
		else if(dsp_cnt==0)dspState_change <=1'b1;
		else if(dspState_change) begin//��һ�����ݴ���������Դ�����һ��
			case(dspState) 
				dspStateA:begin
								if(dataTranDone)begin
								dataIn <= 1'b1;// �������� ������������
								cmd_data <= 0;//��������ģʽ
								dataTran <= 8'h28;//��������0x28
								dspState <= dspStateB;
								dspState_change <=1'b0;
								dsp_cnt <= 25'd2120;
								//$display($time," dspStateA! dataTranDone=%b",dataTranDone);
								end
							end
				dspStateB:begin
								if(dataTranDone)begin
									dataIn <= 1'b1;
									cmd_data <= 1'b0;
									dataTran <= 8'h06;
									dspState_change <=1'b0;
									dspState <= dspStateC;
									dsp_cnt <= 25'd2120;
									//$display($time," dspStateB! dataTranDone=%b",dataTranDone);
								end
							end
				dspStateC:begin
								if(dataTranDone)begin
									dataIn <=1'b1;
									cmd_data <=1'b0;
									dataTran <= 8'h0c;
									dspState_change <= 1'b0;
									dspState <= dspStateD;
									dsp_cnt <= 25'd2120;
									//$display($time," dspStateC! dataTranDone=%b",dataTranDone);
								end
							end
				dspStateD:begin
								if(dataTranDone)begin
									dataIn <= 1'b1;
									dsp_cnt <= 25'd2120; 
									dspState_change <=1'b0;
									cmd_data <= 1'b0;
									dataTran <= 8'h01;//����������
									dspState <= dspStateD1;
									//$display($time," dspStateD! dataTranDone=%b",dataTranDone);
								end
							end
				dspStateD1:begin
								if(dataTranDone)begin
									dataIn <= 1'b0;
									dspState_change <= 1'b0;
									dsp_cnt <= 25'd8200;//dsp_cnt <= 25'd82000;//�ȴ�1.64ms
									dspState <= dspStateE;
									//$display($time," dspStateD1! dataTranDone=%b",dataTranDone);
								end
							end
				dspStateE:begin
							//	if(dataTranDone)begin//�����ַ
									dataTran <= address;
									dataIn <= 1'b1;
									cmd_data <=1'b0;
									dspState_change <= 1'b0;
									dspState <= dspStateF;
									dsp_cnt <= 25'd2120;
									//$display($time," dspStateE! dataTranDone=%b",dataTranDone);
							//	end
							end
				dspStateF:begin
								if(dataTranDone)begin
									dataIn <= 1'b1;
									cmd_data <= 1'b1;//д������
									dataTran <= dataWrite;//д������
									dspState <= dspStateG;
									dspState_change <= 1'b0;
									dsp_cnt <= 25'd2120;
							   	//$display($time," dspStateF! dataTranDone=%b",dataTranDone);
								end
							end
				dspStateG:begin
								if(dataTranDone)begin
									dataIn <= 1'b0;//�ر�
									dsp_cnt <= 25'h0_00ff_ff;//�ȴ�����ʱ��
									dspState_change <= 1'b0;
									dspState <= dspStateE;
									
									if(address < (8'h8f) ) address <= address+1;
									else 	
									begin
									address<=8'hbf;
									if(address < (8'hcf) ) address <= address+1;
									else
									address<=8'h7f;
									end
									
									//�ڶ�λ
								//	if(dataWrite < (8'h5a))	dataWrite <= dataWrite+1;//A---Z
								//	else dataWrite <= 8'h41;  //A---Z
									//$display($time," dspStateG! dataTranDone=%b",dataTranDone);
									
										if(song_sel)
										begin
										case(address)
									8'hc0:dataWrite<=8'b01001101;    //M
									8'hc1:dataWrite<=8'b01010101;    //U
									8'hc2:dataWrite<=8'b01010011;    //S
									8'hc3:dataWrite<=8'b01001001;    //I
									8'hc4:dataWrite<=8'b01000011;    //C
									8'hc5:dataWrite<=8'b00111010;    //:
									8'hc6:dataWrite<=8'b01001100;    //L
									8'hc7:dataWrite<=8'b01011010;    //Z
									
										
									8'h80:dataWrite<=8'b01000011;    //C
									8'h81:dataWrite<=8'b01000001;    //A
									8'h82:dataWrite<=8'b01000010;    //B
									8'h83:dataWrite<=8'b01011110;    //^
			               	8'h84:dataWrite<=8'b01011111;    //- 
									8'h85:dataWrite<=8'b01011110;    //^
									8'h86:dataWrite<=8'b01010111;    //W
									8'h87:dataWrite<=8'b01101111;    //o
									8'h88:dataWrite<=8'b01110010;    //r
									8'h89:dataWrite<=8'b01101100;    //l
									8'h8a:dataWrite<=8'b01100100;    //d
									8'h8b:dataWrite<=8'b10110000;
									8'h8c:dataWrite<=light_9;    //
								   default:dataWrite<=8'b0010000;
									endcase
									end
									
									else
									begin
									case(address)
									8'hc0:dataWrite<=8'b01001101;    //M
									8'hc1:dataWrite<=8'b01010101;    //U
									8'hc2:dataWrite<=8'b01010011;    //S
									8'hc3:dataWrite<=8'b01001001;    //I
									8'hc4:dataWrite<=8'b01000011;    //C
									8'hc5:dataWrite<=8'b00111010;    //:
									8'hc6:dataWrite<=8'b01001100;    //L
									8'hc7:dataWrite<=8'b01011010;    //Z
									8'hc8:dataWrite<=8'b01001100;    //L
									8'hc9:dataWrite<=8'b01001000;		//H
								
								   8'h80:dataWrite<=8'b01000011;    //C
									8'h81:dataWrite<=8'b01000001;    //A
									8'h82:dataWrite<=8'b01000010;    //B
									8'h83:dataWrite<=8'b01011110;    //^
			               	8'h84:dataWrite<=8'b01011111;    //- 
									8'h85:dataWrite<=8'b01011110;    //^
									8'h86:dataWrite<=8'b01010111;    //W
									8'h87:dataWrite<=8'b01101111;    //o
									8'h88:dataWrite<=8'b01110010;    //r
									8'h89:dataWrite<=8'b01101100;    //l
									8'h8a:dataWrite<=8'b01100100;    //d
									8'h8b:dataWrite<=8'b10110000;
									8'h8c:dataWrite<=light_9;    //
								   default:dataWrite<=8'b0010000;
									endcase
									end
									
								end
							
							end
			endcase
		end
	 end
	 
	 parameter initStateA = 6'h0;
	 parameter initStateB = 6'h1;
	 parameter initStateC = 6'h2;
	 parameter initStateD = 6'h3;
	 parameter initStateE = 6'h4;
	 parameter initStateF = 6'h5;
	 parameter initStateG = 6'h6;
	 parameter initStateH = 6'h7;
	 parameter initStateI = 6'h8;
	 parameter initStateDone = 6'h9;
	 
	 parameter dataStateA = 6'd10;
	 parameter dataStateB = 6'd11;
	 parameter dataStateC = 6'd12;
	 parameter dataStateD = 6'd13;
	 parameter dataStateE = 6'd14;
	 parameter dataStateF = 6'd15;
	 
	 reg [5:0]state;

	 initial begin
		inited <= 0 ;
		state <= initStateA;
		dataState<=0; //δ��ʼ��
	 end

	 always@(posedge clk)begin//lcd������??	 	cnt <= cnt-1;
		cnt <= cnt-1;
		if(reset)begin                       //�˴�ԭreset
			inited <= 0;
			state_change <= 1;
			cnt <= 0;
			state <= initStateA;
			dataState<=0;
			dataTranDone <=1'b0;
		end
	else if(cnt==0) state_change <= 1;
		else if(state_change&& !inited) begin
			case(state)
			initStateA:begin//�ȴ�15ms
					cnt <= 20'd750000; //cnt <= 20'd750000;
					state <= initStateB;
					state_change <= 0;//�ȴ�15ms
					//$display($time," initStateA!");
					//LCD_E <= 1'b1;/////////////////////////////////////////
					end
			initStateB:begin//дSF_D<11:8>=0x3��LCD_E���ָߵ�ƽ12ʱ�����ڡ�
					cnt <= 20'd12;
					LCD_E <= 1;
					LCD_RW <= 0;
					sf_d <= 4'h3;
					state <= initStateC;
					state_change <= 0;
					//$display($time," initStateB!");
					end
			initStateC:begin//�ȴ�4.1ms�����������50MHzʱ��205000ʱ�����ڡ�
					cnt <=20'd205000; //cnt <= 20'd205000;
					state <= initStateD;
					state_change <= 0;
					//$display($time," initStateC!");
					end
			initStateD:begin//дSF_D<11:8>=0x3��LCD_E���ָߵ�ƽ12ʱ��?��ڡ?					cnt <= 20'd12;
					LCD_E <= 1;
					LCD_RW <= 0;
					sf_d <= 4'h3;
					state <= initStateE;
					state_change <= 0;
					//$display($time," initStateD!");
					end
			initStateE:begin//�ȴ�100us�����������50MHzʱ��5000ʱ�����ڡ�
					cnt <=20'd5000; //cnt <= 20'd5000;
					state <= initStateF;
					state_change <= 0;
					//$display($time," initStateE!");
					end
			initStateF:begin//??SF_D<11:8>=0x3��LCD_E���ָߵ�ƽ12ʱ�����ڡ�
					cnt <= 20'd12;
					LCD_E <= 1;
					LCD_RW <= 0;
					sf_d <= 4'h3;
					state <= initStateG;
					state_change <= 0;
					//$display($time," initStateF!");
					end
			initStateG:begin//�ȴ�40us�����������50MHzʱ��2000ʱ��??�ڡ�
					cnt <=20'd2000; //cnt <= 20'd2000;
					state <= initStateH;
					state_change <= 0;
					//$display($time," initStateG!");
					end
			initStateH:begin//дSF_D<11:8>=0x2��LCD_E���ָߵ�ƽ12ʱ�����ڡ�
					cnt <= 20'd12;
					LCD_E <= 1'b1;
					LCD_RW <= 1'b0;
					sf_d <= 4'h2;
					state <= initStateI;
					state_change <= 0;
					//$display($time," initStateH!");
					end
			initStateI:begin//�ȴ�40us���������??0MHzʱ��2000ʱ�����ڡ�
					cnt <= 20'd2000; //cnt <= 20'd2000;
					state <= initStateDone;
					state_change <= 0;
					//$display($time," initStateI!");
					end
			initStateDone:begin
					inited <= 1;
					state <= dataStateA;
					state_change <= 1'b0;
					cnt <= 20'b1;
					dataTranDone <= 1'b1;
					//$display($time," initStateDone!");
					end
			endcase
		end
		else if(state_change && inited && dataIn)begin
			case(state)
				dataStateA:begin
							//$display($time," dataStateA_1! dataTranDone=%b",dataTranDone);
							dataTranDone <= 1'b0;//���ݴ��Ϳ�ʼ,���ݴ���δ����							
							sf_d <= dataTran[7:4];//���͸���λ
							LCD_E <= 1'b0;
							LCD_RW <= 1'b0;
							LCD_RS <= cmd_data;
							cnt <= 20'd3;//40ns
							state <= dataStateB;
							state_change <=1'b0;
							//$display($time," dataStateA! dataTranDone=%b",dataTranDone); 
							end
				dataStateB:begin
							dataTranDone <= 1'b0;//���ݴ���δ����	
							cnt <= 20'd12;//230ns
							LCD_E <= 1'b1;  
							LCD_RW <= 1'b0;
							LCD_RS <= cmd_data; 
							state <= dataStateC;
							state_change <= 1'b0;
							//$display($time," dataStateB! dataTranDone=%b",dataTranDone);
							end
				dataStateC:begin
							dataTranDone <= 1'b0;//���ݴ���δ����							
							LCD_E <= 1'b0;
							cnt <= 20'd53;//1us
							state <= dataStateD;
							cnt <= 20'd1;
							state_change <= 1'b0;
							//$display($time," dataStateC! dataTranDone=%b",dataTranDone);
							end
				dataStateD:begin
							dataTranDone <= 1'b0;//���ݴ���δ����	
							sf_d <= dataTran[3:0];//���͵���λ
							LCD_E <= 1'b0;
							LCD_RW <= 1'b0;
							LCD_RS <= cmd_data;
							cnt <= 20'd3;//40ns
							state <= dataStateE;
							state_change <=1'b0;
							cnt <= 20'b1;
							//$display($time," dataStateD! dataTranDone=%b",dataTranDone);
							end
				dataStateE:begin
							dataTranDone <= 1'b0;//���ݴ���δ����	
							cnt <= 20'd12;//230ns
							LCD_E <= 1'b1;
							LCD_RW <= 1'b0;
							LCD_RS <= cmd_data;
							state <= dataStateF;
							state_change <= 1'b0;
							cnt <= 20'd1;
							//$display($time," dataStateE! dataTranDone=%b",dataTranDone);
							end
				dataStateF:begin
							LCD_E <= 1'b0;
			 				cnt <= 20'd2120;//40us
							state_change <= 1'b0;
							state <= dataStateA;
							dataTranDone <= 1'b1;//���ݴ��ͽ���	
							//$display($time," dataStateF! dataTranDone=%b",dataTranDone);
							end
			endcase
		end
	 end

clk_3 U1(clk,cal,chg,light_0,light_1,light_2,light_3,light_4,light_5,light_6,light_7,light_8);
VGA   U2(clk,rst2,hsync,vsync,vga_r,vga_g,vga_b,a, b);
piano U3(clk,song_sel,led,speakers,light_9,type,a, b, push);
endmodule

