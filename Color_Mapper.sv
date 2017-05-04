//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  03-03-2017                               --
//                                                                       --
//    Spring 2017 Distribution                                           --
//                                                                       --
//    For use with ECE 385 Lab 7                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------
//
//		Color_Mapper.sv
//		Modified by Minghao Jiang and Xingjian Zhao
//		
//		Used for Final Project ECE385 Spring 2017
//
//-------------------------------------------------------------------------


module  color_mapper ( input 					 Clk,
							  input        [11:0] p1PosX, m1PosX, m2PosX, rPosX, 	// Objects x coordinates     
                       input			[9:0]  p1PosY, m1PosY, m2PosY, rPosY, 	// Objects y coordinates
							  input 			[9:0]  DrawX, DrawY,
							  input 					 m1Alive, m2Alive,								// Monsters alive 
							  input					 rocket_on,					// Rocket on/off
							  input					 p1D,						// Player direction
							  input 					 p1_Att,
							  input			[6:0]  hp_value,
							  input 			[4:0]  score,
							  input 			[1:0]  stage,
							  input 					 win,
							  input 			[11:0]  mapPosX,
							  input 	      [23:0] RGB_COVER,
							  input 			[23:0] RGB_GO,
							  input			[23:0] RGB_BG,
                       output logic [7:0]  VGA_R, VGA_G, VGA_B 	// VGA RGB output
                     );
    
    // Initialize Logic
	 logic player_left_on, player_right_on, attack_right_on; 
	 logic m1_on, m2_on;
	 logic r_on;
    logic [7:0] Red, Green, Blue;
	 // player RGB
	 logic [23:0] p1RGB_L, p1RGB_R, attRGB_R;
	 // monster RGB
	 logic [23:0] m1RGB, m2RGB;
	 logic [23:0] rRGB;
	 // hp 
	 logic 			hp7_on, hp6_on, hp5_on, hp4_on, hp3_on, hp2_on, hp1_on;
	 logic [23:0]  hp7RGB, hp6RGB, hp5RGB, hp4RGB, hp3RGB, hp2RGB, hp1RGB;
	 
	 //tank
	 logic 		  s_tank_on;
	 logic 		  p_tank_on;
	 logic [23:0] stankRGB;
	 logic [23:0] ptankRGB;
	 
	 //mission complete
	 logic 		  mc_on;
	 logic [23:0] mcRGB;
	 
	 // ram_out
	 logic [3:0] p1Ram_L, p1Ram_R, attRam_R, m1Ram, m2Ram, rRam, hp7Ram, hp6Ram, hp5Ram, hp4Ram, hp3Ram, hp2Ram, hp1Ram, stankRam, ptankRam, mcRam;
	 
	 // DrawX, DrawY int
	 int x_draw, y_draw;
	 assign x_draw = DrawX;
	 assign y_draw = DrawY;
	 
	 // player int
	 int p1MemX, p1MemY, p1X, p1Y, attMemX, attMemY;
	 assign p1X = p1PosX;
	 assign p1Y = p1PosY;
	 assign p1MemX = x_draw-(p1X-p1Width/2); 
	 assign p1MemY = y_draw-(p1Y-p1Height/2);
	 assign attMemX = x_draw-(p1X-attWidth/2);
	 assign attMemY = y_draw-(p1Y-attHeight/2);
	 
	 // monster int
	 int m1MemX, m1MemY, m1X, m1Y;
	 int m2MemX, m2MemY, m2X, m2Y;
	 assign m1X = m1PosX;
	 assign m1Y = m1PosY;
	 assign m2X = m2PosX;
	 assign m2Y = m2PosY;
	 assign m1MemX = x_draw-(m1X-mWidth/2);
	 assign m1MemY = y_draw-(m1Y-mHeight/2);
	 assign m2MemX = x_draw-(m2X-mWidth/2);
	 assign m2MemY = y_draw-(m2Y-mHeight/2);
	 
	 // rocket int
	 int rMemX, rMemY, rX,rY;
	 assign rX = rPosX;
	 assign rY = rPosY;
	 assign rMemX = x_draw-(rX-rWidth/2);
	 assign rMemY = y_draw-(rY-rHeight/2);
	 
	 // HP int
	 int hp7MemX, hp6MemX, hp5MemX, hp4MemX, hp3MemX, hp2MemX, hp1MemX, hpMemY;
	 assign hpMemY = y_draw-(hpY-hpHeight/2);
	 assign hp7MemX = x_draw-(hp7X - hpWidth/2);
	 assign hp6MemX = x_draw-(hp6X - hpWidth/2);
	 assign hp5MemX = x_draw-(hp5X - hpWidth/2);
	 assign hp4MemX = x_draw-(hp4X - hpWidth/2);
	 assign hp3MemX = x_draw-(hp3X - hpWidth/2);
	 assign hp2MemX = x_draw-(hp2X - hpWidth/2);
	 assign hp1MemX = x_draw-(hp1X - hpWidth/2);
	 
	 //mc int
	 int mcMemX, mcMemY;
	 parameter [9:0] mcX = 10'd320;
	 parameter [9:0] mcY = 10'd240;
	 parameter [9:0] mcWidth = 10'd295;
	 parameter [9:0] mcHeight = 10'd76;
	 assign mcMemX = x_draw-(mcX-mcWidth/2);
	 assign mcMemY = y_draw-(mcY-mcHeight/2);
	 
	 //tank int
	 int stankMemX, stankMemY, ptankMemX, ptankMemY;
	 logic [11:0] stankX;
	 assign stankX = 20'd1835-mapPosX;
	 parameter [9:0] stankY = 10'd340-tankHeight/2;
	 logic [11:0] ptankX;
	 assign ptankX = p1X;
	 logic [9:0] ptankY;
	 assign ptankY = p1Y;
	 parameter [9:0] tankWidth = 10'd53;
	 parameter [9:0] tankHeight = 10'd50;
	 assign stankMemX = x_draw-(stankX-tankWidth/2);
	 assign stankMemY = y_draw-(stankY-tankHeight/2);
	 assign ptankMemX = x_draw-(ptankX-tankWidth/2);
	 assign ptankMemY = y_draw-(ptankY-tankHeight/2);
	 
  	 // Player parameter
	 parameter [9:0] p1Width = 10'd32;
	 parameter [9:0] p1Height = 10'd50;
	 parameter [9:0] attWidth = 10'd56;
	 parameter [9:0] attHeight = 10'd52;
	 
	 // Monster parameter
	 parameter [9:0] mWidth = 10'd60;
	 parameter [9:0] mHeight = 10'd58;
	 
	 // Rocekt parameter
	 parameter [9:0] rWidth = 10'd30;
	 parameter [9:0] rHeight = 10'd9;
	 
	 // HP parameter
	 parameter [9:0] hpWidth = 10'd10;
	 parameter [9:0] hpHeight = 10'd10;
	 parameter [9:0] hpY = 10'd140;
	 parameter [9:0] hp7X = 10'd130;
	 parameter [9:0] hp6X = 10'd115;
	 parameter [9:0] hp5X = 10'd100;
	 parameter [9:0] hp4X = 10'd85;
	 parameter [9:0] hp3X = 10'd70;
	 parameter [9:0] hp2X = 10'd55;
	 parameter [9:0] hp1X = 10'd40;
	 
	 // Font Drawing
	 logic [9:0]  fontWidth = 8;
	 logic [9:0]  fontHeight = 16;
	 // Font 'S'
	 logic 		  Sfont_on;
	 logic [9:0]  SfontX = 10'd15;
	 logic [9:0]  SfontY = 10'd155;
	 logic [10:0] SfontAddr;
	 logic [7:0]  SfontData;
	 parameter [7:0] Scode = 8'h53;
	 font_rom SfontDraw (.addr(SfontAddr), .data(SfontData));
	 // Font 'C'
	 logic		  Cfont_on;
	 logic [9:0]  CfontX = 10'd25;
	 logic [9:0]  CfontY = 10'd155;
	 logic [10:0] CfontAddr;
	 logic [7:0]  CfontData;
	 parameter [7:0] Ccode = 8'h43;
	 font_rom CfontDraw (.addr(CfontAddr), .data(CfontData));
	 // Font 'O'
	 logic		  Ofont_on;
	 logic [9:0]  OfontX = 10'd35;
	 logic [9:0]  OfontY = 10'd155;
	 logic [10:0] OfontAddr;
	 logic [7:0]  OfontData;
	 parameter [7:0] Ocode = 8'h4f;
	 font_rom OfontDraw (.addr(OfontAddr), .data(OfontData));
	 // Font 'R'
	 logic		  Rfont_on;
	 logic [9:0]  RfontX = 10'd45;
	 logic [9:0]  RfontY = 10'd155;
	 logic [10:0] RfontAddr;
	 logic [7:0]  RfontData;
	 parameter [7:0] Rcode = 8'h52;
	 font_rom RfontDraw (.addr(RfontAddr), .data(RfontData));
	 // Font 'E'
	 logic		  Efont_on;
	 logic [9:0]  EfontX = 10'd55;
	 logic [9:0]  EfontY = 10'd155;
	 logic [10:0] EfontAddr;
	 logic [7:0]  EfontData;
	 parameter [7:0] Ecode = 8'h45;
	 font_rom EfontDraw (.addr(EfontAddr), .data(EfontData));
	 // Font 'H'
	 logic		  Hfont_on;
	 logic [9:0]  HfontX = 10'd15;
	 logic [9:0]  HfontY = 10'd133;
	 logic [10:0] HfontAddr;
	 logic [7:0]  HfontData;
	 parameter [7:0] Hcode = 8'h48;
	 font_rom HfontDraw (.addr(HfontAddr), .data(HfontData));
	 // Font 'P'
	 logic		  Pfont_on;
	 logic [9:0]  PfontX = 10'd25;
	 logic [9:0]  PfontY = 10'd133;
	 logic [10:0] PfontAddr;
	 logic [7:0]  PfontData;
	 parameter [7:0] Pcode = 8'h50;
	 font_rom PfontDraw (.addr(PfontAddr), .data(PfontData));
	 // Font digit1
	 logic 		  d1font_on;
	 logic [9:0]  d1fontX = 10'd80;
	 logic [9:0]  d1fontY = 10'd155;
	 logic [10:0] d1fontAddr;
	 logic [7:0]  d1fontData;
	 logic [7:0]  d1code;
	 font_rom d1fontDraw (.addr(d1fontAddr), .data(d1fontData));
	 // Font digit2
	 logic 		  d2font_on;
	 logic [9:0]  d2fontX = 10'd70;
	 logic [9:0]  d2fontY = 10'd155;
	 logic [10:0] d2fontAddr;
	 logic [7:0]  d2fontData;
	 logic [7:0]  d2code;
	 font_rom d2fontDraw (.addr(d2fontAddr), .data(d2fontData));
	 always_comb
	 begin
		if(score >= 20)
		begin
			d1code = score - 5'd20 + 8'h30;
			d2code = 8'h32;
		end
		else if(score >= 10)
		begin	
			d1code = score - 4'd10 + 8'h30;
			d2code = 8'h31;
		end
		else 
		begin
			d1code = score + 8'h30;
			d2code = 8'h30;
		end
	 end
	 
	 // Read from On Chip Memory
	 frameRAM playerRight (.read_address(p1MemY*p1Width+p1MemX), .Clk(Clk), .data_Out(p1Ram_R));
	 frameRAM playerLeft	 (.read_address(p1MemY*p1Width+p1MemX+15'd1600), .Clk(Clk), .data_Out(p1Ram_L));
	 frameRAM attackRight (.read_address(attMemY*attWidth+attMemX+15'd3200), .Clk(Clk), .data_Out(attRam_R));
	 frameRAM monster1Left (.read_address(m1MemY*mWidth+m1MemX+15'd6112), .Clk(Clk), .data_Out(m1Ram));
	 frameRAM monster2Left (.read_address(m2MemY*mWidth+m2MemX+15'd6112), .Clk(Clk), .data_Out(m2Ram));
	 frameRAM rocket	 (.read_address(rMemY*rWidth+rMemX+15'd9592), .Clk(Clk), .data_Out(rRam));
	 frameRAM mc (.read_address(mcMemY*mcWidth+mcMemX+15'd12612), .Clk(Clk), .data_Out(mcRam));
	 frameRAM stank (.read_address(stankMemY*tankWidth+stankMemX+15'd9962), .Clk(Clk), .data_Out(stankRam));
	 frameRAM ptank (.read_address(ptankMemY*tankWidth+ptankMemX+15'd9962), .Clk(Clk), .data_Out(ptankRam));
	 
	 // hp memory
	 frameRAM hp7 (.read_address(hpMemY*hpWidth+hp7MemX+15'd9862), .Clk(Clk), .data_Out(hp7Ram));
	 frameRAM hp6 (.read_address(hpMemY*hpWidth+hp6MemX+15'd9862), .Clk(Clk), .data_Out(hp6Ram));
	 frameRAM hp5 (.read_address(hpMemY*hpWidth+hp5MemX+15'd9862), .Clk(Clk), .data_Out(hp5Ram));
	 frameRAM hp4 (.read_address(hpMemY*hpWidth+hp4MemX+15'd9862), .Clk(Clk), .data_Out(hp4Ram));
	 frameRAM hp3 (.read_address(hpMemY*hpWidth+hp3MemX+15'd9862), .Clk(Clk), .data_Out(hp3Ram));
	 frameRAM hp2 (.read_address(hpMemY*hpWidth+hp2MemX+15'd9862), .Clk(Clk), .data_Out(hp2Ram));
	 frameRAM hp1 (.read_address(hpMemY*hpWidth+hp1MemX+15'd9862), .Clk(Clk), .data_Out(hp1Ram));
	 
	 // palette
	 palette_toad toad1 (.index(m1Ram), .RGB(m1RGB));
	 palette_toad toad2 (.index(m2Ram), .RGB(m2RGB));
	 palette_rocket r (.index(rRam), .RGB(rRGB));
	 palette_player_attack attack (.index(attRam_R), .RGB(attRGB_R));
	 palette_player p1R (.index(p1Ram_R), .RGB(p1RGB_R));
	 palette_player p1L (.index(p1Ram_L), .RGB(p1RGB_L));
	 palette_hp h7 (.index(hp7Ram), .RGB(hp7RGB));
	 palette_hp h6 (.index(hp6Ram), .RGB(hp6RGB));
	 palette_hp h5 (.index(hp5Ram), .RGB(hp5RGB));
	 palette_hp h4 (.index(hp4Ram), .RGB(hp4RGB));
	 palette_hp h3 (.index(hp3Ram), .RGB(hp3RGB));
	 palette_hp h2 (.index(hp2Ram), .RGB(hp2RGB));
	 palette_hp h1 (.index(hp1Ram), .RGB(hp1RGB));
	 palette_mc mcpalette (.index(mcRam), .RGB(mcRGB));
	 palette_tank stankpalette (.index(stankRam), .RGB(stankRGB));
	 palette_tank ptankpalette (.index(ptankRam), .RGB(ptankRGB));
	 
	 
    assign VGA_R = Red;
    assign VGA_G = Green;
    assign VGA_B = Blue;
	
	 // Player facing left condition
	 always_comb
    begin : player_left_on_proc
		  if( p1MemX >= 0 && p1MemX < p1Width && p1MemY >= 0 && p1MemY < p1Height && p1RGB_L != 24'hff4295 && p1D == 1 && p1_Att == 0 && stage == 1 && win == 0)
            player_left_on = 1'b1;
        else 
            player_left_on = 1'b0;
    end
	
	 // Player facing right condition
    always_comb
    begin : player_right_on_proc
		  if( p1MemX >= 0 && p1MemX < p1Width && p1MemY >= 0 && p1MemY < p1Height && p1RGB_R != 24'hff4295 && p1D == 0 && p1_Att == 0 && stage == 1 && win == 0)
            player_right_on = 1'b1;
        else 
            player_right_on = 1'b0;
    end
    
	 // Player attack facing right
	 always_comb 
	 begin : attack_right_on_proc
			if( attMemX >= 0 && attMemX < attWidth && attMemY >= 0 && attMemY < attHeight && attRGB_R != 24'hff4295 && p1_Att == 1 && stage == 1 && win == 0)
			//if( p1MemX >= 0 && p1MemX < p1Width && p1MemY >= 0 && p1MemY < p1Height && p1RGB_R != 24'hff4295  && p1_Att == 1)
				attack_right_on = 1'b1;
			else
				attack_right_on = 1'b0;
	 end
	 
	 // static tank 
	 always_comb
	 begin : tank_static_on_proc
			if(stankMemX >= 0 && stankMemX < tankWidth && stankMemY >= 0 && stankMemY < tankHeight && stankRGB != 24'hff4295 && win == 0)
				s_tank_on = 1'b1;
			else 
				s_tank_on = 1'b0;
	 end
	 
	 always_comb
	 begin : player_tank_on_proc
			if(ptankMemX >= 0 && ptankMemX < tankWidth && ptankMemY >= 0 && ptankMemY < tankHeight && ptankRGB != 24'hff4295 && win == 1)
				p_tank_on = 1'b1;
			else
				p_tank_on = 1'b0;
	 end
	 
	 always_comb
	 begin : M1_on_proc
			if( m1MemX >= 0 && m1MemX < mWidth && m1MemY >= 0 && m1MemY < mHeight && m1RGB != 24'hff4295 && m1Alive == 1 && stage == 1)
				m1_on = 1'b1;
			else
				m1_on = 1'b0;
	 end
	
	 always_comb
	 begin : M2_on_proc
			if( m2MemX >= 0 && m2MemX < mWidth && m2MemY >= 0 && m2MemY < mHeight && m2RGB != 24'hff4295 && m2Alive == 1 && stage == 1)
				m2_on = 1'b1;
			else
				m2_on = 1'b0;
	 end
	 
	 // Rocket
	 always_comb 
	 begin : Rocket_on_proc
			if(rMemX >= 0 && rMemX < rWidth && rMemY >= 0 && rMemY < rHeight && rRGB != 24'hff4295 && rocket_on == 1 && stage == 1)
				r_on = 1'b1;
			else
				r_on = 1'b0;
	 end 
	 
	 // HP display
	 always_comb
	 begin : HP7_on_proc
			if(hp7MemX >= 0 && hp7MemX < hpWidth && hpMemY >= 0 && hpMemY < hpHeight && hp7RGB != 24'hff4295 && hp_value[6] == 1 && stage == 1)
				hp7_on = 1'b1;
			else 
				hp7_on = 1'b0;
	end
	always_comb
	 begin : HP6_on_proc
			if(hp6MemX >= 0 && hp6MemX < hpWidth && hpMemY >= 0 && hpMemY < hpHeight && hp6RGB != 24'hff4295 && hp_value[5] == 1 && stage == 1)
				hp6_on = 1'b1;
			else 
				hp6_on = 1'b0;
	end
	always_comb
	 begin : HP5_on_proc
			if(hp5MemX >= 0 && hp5MemX < hpWidth && hpMemY >= 0 && hpMemY < hpHeight && hp5RGB != 24'hff4295 && hp_value[4] == 1 && stage == 1)
				hp5_on = 1'b1;
			else 
				hp5_on = 1'b0;
	end
	always_comb
	 begin : HP4_on_proc
			if(hp4MemX >= 0 && hp4MemX < hpWidth && hpMemY >= 0 && hpMemY < hpHeight && hp4RGB != 24'hff4295 && hp_value[3] == 1 && stage == 1)
				hp4_on = 1'b1;
			else 
				hp4_on = 1'b0;
	end
	always_comb
	 begin : HP3_on_proc
			if(hp3MemX >= 0 && hp3MemX < hpWidth && hpMemY >= 0 && hpMemY < hpHeight && hp3RGB != 24'hff4295 && hp_value[2] == 1 && stage == 1)
				hp3_on = 1'b1;
			else 
				hp3_on = 1'b0;
	end
	always_comb
	 begin : HP2_on_proc
			if(hp2MemX >= 0 && hp2MemX < hpWidth && hpMemY >= 0 && hpMemY < hpHeight && hp2RGB != 24'hff4295 && hp_value[1] == 1 && stage == 1)
				hp2_on = 1'b1;
			else 
				hp2_on = 1'b0;
	end
	always_comb
	 begin : HP1_on_proc
			if(hp1MemX >= 0 && hp1MemX < hpWidth && hpMemY >= 0 && hpMemY < hpHeight && hp1RGB != 24'hff4295 && hp_value[0] == 1 && stage == 1)
				hp1_on = 1'b1;
			else 
				hp1_on = 1'b0;
	end
	
	// Font display
	always_comb
	begin : SFont_on_proc // Font 'S'
			if(DrawX >= SfontX && DrawX < SfontX + fontWidth && DrawY >= SfontY && DrawY < SfontY + fontHeight && stage == 1)
			begin
				Sfont_on = 1'b1;
				SfontAddr = (DrawY - SfontY + 11'd16 * Scode);
			end
			else
			begin
				Sfont_on = 1'b0;
				SfontAddr = 11'b0;
			end
	end
	always_comb
	begin : CFont_on_proc // Font 'C'
			if(DrawX >= CfontX && DrawX < CfontX + fontWidth && DrawY >= CfontY && DrawY < CfontY + fontHeight && stage == 1)
			begin
				Cfont_on = 1'b1;
				CfontAddr = (DrawY - CfontY + 11'd16 * Ccode);
			end
			else
			begin
				Cfont_on = 1'b0;
				CfontAddr = 11'b0;
			end
	end
	always_comb
	begin : OFont_on_proc // Font 'O'
			if(DrawX >= OfontX && DrawX < OfontX + fontWidth && DrawY >= OfontY && DrawY < OfontY + fontHeight && stage == 1)
			begin
				Ofont_on = 1'b1;
				OfontAddr = (DrawY - OfontY + 11'd16 * Ocode);
			end
			else
			begin
				Ofont_on = 1'b0;
				OfontAddr = 11'b0;
			end
	end
	always_comb
	begin : RFont_on_proc // Font 'R'
			if(DrawX >= RfontX && DrawX < RfontX + fontWidth && DrawY >= RfontY && DrawY < RfontY + fontHeight && stage == 1)
			begin
				Rfont_on = 1'b1;
				RfontAddr = (DrawY - RfontY + 11'd16 * Rcode);
			end
			else
			begin
				Rfont_on = 1'b0;
				RfontAddr = 11'b0;
			end
	end
	always_comb
	begin : EFont_on_proc // Font 'E'
			if(DrawX >= EfontX && DrawX < EfontX + fontWidth && DrawY >= EfontY && DrawY < EfontY + fontHeight && stage == 1)
			begin
				Efont_on = 1'b1;
				EfontAddr = (DrawY - EfontY + 11'd16 * Ecode);
			end
			else
			begin
				Efont_on = 1'b0;
				EfontAddr = 11'b0;
			end
	end
	always_comb
	begin : HFont_on_proc // Font 'H'
			if(DrawX >= HfontX && DrawX < HfontX + fontWidth && DrawY >= HfontY && DrawY < HfontY + fontHeight && stage == 1)
			begin
				Hfont_on = 1'b1;
				HfontAddr = (DrawY - HfontY + 11'd16 * Hcode);
			end
			else
			begin
				Hfont_on = 1'b0;
				HfontAddr = 11'b0;
			end
	end
	always_comb
	begin : PFont_on_proc // Font 'P'
			if(DrawX >= PfontX && DrawX < PfontX + fontWidth && DrawY >= PfontY && DrawY < PfontY + fontHeight && stage == 1)
			begin
				Pfont_on = 1'b1;
				PfontAddr = (DrawY - PfontY + 11'd16 * Pcode);
			end
			else
			begin
				Pfont_on = 1'b0;
				PfontAddr = 11'b0;
			end
	end
	always_comb
	begin : d1Font_on_proc // Font digit1
			if(DrawX >= d1fontX && DrawX < d1fontX + fontWidth && DrawY >= d1fontY && DrawY < d1fontY + fontHeight && stage == 1)
			begin
				d1font_on = 1'b1;
				d1fontAddr = (DrawY - d1fontY + 11'd16 * d1code);
			end
			else
			begin
				d1font_on = 1'b0;
				d1fontAddr = 11'b0;
			end
	end 
	always_comb
	begin : d2Font_on_proc // Font digit1
			if(DrawX >= d2fontX && DrawX < d2fontX + fontWidth && DrawY >= d2fontY && DrawY < d2fontY + fontHeight && stage == 1)
			begin
				d2font_on = 1'b1;
				d2fontAddr = (DrawY - d2fontY + 11'd16 * d2code);
			end
			else
			begin
				d2font_on = 1'b0;
				d2fontAddr = 11'b0;
			end
	end 
	always_comb
	 begin : mc_on_proc
			if(mcMemX >= 0 && mcMemX < mcWidth && mcMemY >= 0 && mcMemY < mcHeight && mcRGB != 24'hff4295 && win == 1)
				mc_on = 1'b1;
			else 
				mc_on = 1'b0;
	end
	
    // Assign color based on player_on signal
    always_comb
    begin : RGB_Display
        if ((player_left_on == 1'b1)) // Draw facing left
        begin
            // player facing left draw
            Red = p1RGB_L[23:16];
            Green = p1RGB_L[15:8];
            Blue = p1RGB_L[7:0];
				
        end
		  else if ((player_right_on == 1'b1)) // Draw facing right
        begin
            // player facing right draw
            Red = p1RGB_R[23:16];
            Green = p1RGB_R[15:8];
            Blue = p1RGB_R[7:0];
				
        end
		  else if ((attack_right_on == 1'b1)) // Draw attack facing right
        begin
            // attack facing right draw
            Red = attRGB_R[23:16];
            Green = attRGB_R[15:8];
            Blue = attRGB_R[7:0];
        end
		  else if ((s_tank_on == 1'b1)) // tank
        begin
            Red = stankRGB[23:16];
            Green = stankRGB[15:8];
            Blue = stankRGB[7:0];
				
        end
		  else if ((p_tank_on == 1'b1)) // tank
        begin
            Red = ptankRGB[23:16];
            Green = ptankRGB[15:8];
            Blue = ptankRGB[7:0];
				
        end
		  else if((m1_on == 1'b1))
		  begin
				// monster1
				Red = m1RGB[23:16];
				Green = m1RGB[15:8];
				Blue = m1RGB[7:0];
			
		  end
		  
		  else if((m2_on == 1'b1))
		  begin
				// monster2 
				Red = m2RGB[23:16];
				Green = m2RGB[15:8];
				Blue = m2RGB[7:0];
			
		  end
		  
		  else if((r_on == 1'b1))
		  begin
				// rocket 
				Red = rRGB[23:16];
				Green = rRGB[15:8];
				Blue = rRGB[7:0];
			
		  end
		  
		  else if((hp7_on == 1'b1))
		  begin
				// HP7 
				Red = hp7RGB[23:16];
				Green = hp7RGB[15:8];
				Blue = hp7RGB[7:0];
			
		  end
		  else if((hp6_on == 1'b1))
		  begin
				// HP6 
				Red = hp6RGB[23:16];
				Green = hp6RGB[15:8];
				Blue = hp6RGB[7:0];
			
		  end
		  else if((hp5_on == 1'b1))
		  begin
				// HP5 
				Red = hp5RGB[23:16];
				Green = hp5RGB[15:8];
				Blue = hp5RGB[7:0];
			
		  end
		  else if((hp4_on == 1'b1))
		  begin
				// HP4 
				Red = hp4RGB[23:16];
				Green = hp4RGB[15:8];
				Blue =  hp4RGB[7:0];
			
		  end
		  else if((hp3_on == 1'b1))
		  begin
				// HP3 
				Red = hp3RGB[23:16];
				Green = hp3RGB[15:8];
				Blue =  hp3RGB[7:0];
			
		  end
		  else if((hp2_on == 1'b1))
		  begin
				// HP2 
				Red = hp2RGB[23:16];
				Green = hp2RGB[15:8];
				Blue =  hp2RGB[7:0];
			
		  end
		  else if((hp1_on == 1'b1))
		  begin
				// HP1 
				Red = hp1RGB[23:16];
				Green = hp1RGB[15:8];
				Blue =  hp1RGB[7:0];
			
		  end
		  // Font 'S'
		  else if(Sfont_on == 1'b1 && SfontData[SfontX-DrawX] == 1'b1)
		  begin 
				Red = 8'hff;
				Green = 8'hff;
				Blue = 8'hff;
		  end
		  // Font 'C'
		  else if(Cfont_on == 1'b1 && CfontData[CfontX-DrawX] == 1'b1)
		  begin 
				Red = 8'hff;
				Green = 8'hff;
				Blue = 8'hff;
		  end
		  // Font 'O'
		  else if(Ofont_on == 1'b1 && OfontData[OfontX-DrawX] == 1'b1)
		  begin 
				Red = 8'hff;
				Green = 8'hff;
				Blue = 8'hff;
		  end
		  // Font 'R'
		  else if(Rfont_on == 1'b1 && RfontData[RfontX-DrawX] == 1'b1)
		  begin 
				Red = 8'hff;
				Green = 8'hff;
				Blue = 8'hff;
		  end
		  // Font 'E'
		  else if(Efont_on == 1'b1 && EfontData[EfontX-DrawX] == 1'b1)
		  begin 
				Red = 8'hff;
				Green = 8'hff;
				Blue = 8'hff;
		  end
		  // Font 'H'
		  else if(Hfont_on == 1'b1 && HfontData[HfontX-DrawX] == 1'b1)
		  begin 
				Red = 8'hff;
				Green = 8'hff;
				Blue = 8'hff;
		  end
		  // Font 'P'
		  else if(Pfont_on == 1'b1 && PfontData[PfontX-DrawX] == 1'b1)
		  begin 
				Red = 8'hff;
				Green = 8'hff;
				Blue = 8'hff;
		  end
		  // Font digit1
		  else if(d1font_on == 1'b1 && d1fontData[d1fontX-DrawX] == 1'b1)
		  begin 
				Red = 8'hff;
				Green = 8'hff;
				Blue = 8'hff;
		  end
		  // Font digit2
		  else if(d2font_on == 1'b1 && d2fontData[d2fontX-DrawX] == 1'b1)
		  begin 
				Red = 8'hff;
				Green = 8'hff;
				Blue = 8'hff;
		  end
		  else if(mc_on == 1)
		  begin 
				Red = mcRGB[23:16];
				Green = mcRGB[15:8];
				Blue = mcRGB[7:0];
		  end
		  
        else 
        begin
            // Background with nice color gradient
				Red = RGB_BG[23:16];
				Green = RGB_BG[15:8];
				Blue = RGB_BG[7:0];
				
				if(stage == 2'd0)
				begin
					Red = RGB_COVER[23:16];
					Green = RGB_COVER[15:8];
					Blue = RGB_COVER[7:0];
				end
				
				if(stage == 2'd2)
				begin
					Red = RGB_GO[23:16];
					Green = RGB_GO[15:8];
					Blue = RGB_GO[7:0];
			   end
				  

				if(DrawY > 10'd359)
				begin
					Red = 8'h00;
					Green = 8'h00;
					Blue = 8'h00;
				end
				else if(DrawY < 10'd120)
				begin 
					Red = 8'h00;
					Green = 8'h00;
					Blue = 8'h00;
				end

		end 
  end  
endmodule
