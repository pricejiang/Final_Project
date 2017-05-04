//-------------------------------------------------------------------------
//      lab7_usb.sv                                                      --
//      Christine Chen                                                   --
//      Fall 2014                                                        --
//                                                                       --
//      Fall 2014 Distribution                                           --
//                                                                       --
//      For use with ECE 385 Lab 7                                       --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------


module final_project( input               CLOCK_50,
							 input        [3:0]  KEY,          //bit 0 is set up as Reset
							 output logic [6:0]  HEX0, HEX1,
							 // VGA Interface 
							 output logic [7:0]  VGA_R,        //VGA Red
														VGA_G,        //VGA Green
														VGA_B,        //VGA Blue
							 output logic        VGA_CLK,      //VGA Clock
														VGA_SYNC_N,   //VGA Sync signal
														VGA_BLANK_N,  //VGA Blank signal
														VGA_VS,       //VGA virtical sync signal
														VGA_HS,       //VGA horizontal sync signal
//							 // CY7C67200 Interface
//							 inout  wire  [15:0] OTG_DATA,     //CY7C67200 Data bus 16 Bits
//							 output logic [1:0]  OTG_ADDR,     //CY7C67200 Address 2 Bits
//							 output logic        OTG_CS_N,     //CY7C67200 Chip Select
//														OTG_RD_N,     //CY7C67200 Write
//														OTG_WR_N,     //CY7C67200 Read
//														OTG_RST_N,    //CY7C67200 Reset
//							 input               OTG_INT,      //CY7C67200 Interrupt
							 // SDRAM Interface for Nios II Software
							 output logic [12:0] DRAM_ADDR,    //SDRAM Address 13 Bits
							 inout  wire  [31:0] DRAM_DQ,      //SDRAM Data 32 Bits
							 output logic [1:0]  DRAM_BA,      //SDRAM Bank Address 2 Bits
							 output logic [3:0]  DRAM_DQM,     //SDRAM Data Mast 4 Bits
							 output logic        DRAM_RAS_N,   //SDRAM Row Address Strobe
														DRAM_CAS_N,   //SDRAM Column Address Strobe
														DRAM_CKE,     //SDRAM Clock Enable
														DRAM_WE_N,    //SDRAM Write Enable
														DRAM_CS_N,    //SDRAM Chip Select
														DRAM_CLK,      //SDRAM Clock
											
							 // PS/2 Keyboard inputs
							 input 					ps2_CLK,		  //PS/2 Clock
							 input					ps2_DAT,		  //PS/2 Data
											
							 // SRAM Interface for Images
							 output logic 			SRAM_CE, SRAM_UB, SRAM_LB, SRAM_OE, SRAM_WE,	//SRAM control signals
							 output logic [19:0] SRAM_ADDR,						//SRAM address
							 inout wire [15:0] 	SRAM_Data //tristate buffers need to be of type wire
);
    
    logic Reset_h, Clk, Clk_25;

    
    assign Clk = CLOCK_50;
	 assign Clk_25 = VGA_CLK;
    assign {Reset_h} = ~(KEY[1]);  // The push buttons are active low
    
	 // SRAM control signal
	 assign SRAM_CE = 1'b0;
	 assign SRAM_UB = 1'b0;
	 assign SRAM_LB = 1'b0;
	 assign SRAM_OE = 1'b0;
	 assign SRAM_WE = 1'b1;
	 
	 logic [15:0] SRAM_Out;
	 logic [23:0] RGB_BG;
	 logic [23:0] RGB_COVER;
	 logic [23:0] RGB_GO;
    
	 // Screen Draw Variable
	 logic [9:0] DrawX, DrawY;
	 
	 // Game set variable
    logic [7:0]  keycode;
	 logic 		  press;
	 logic [11:0] mapPosX;
	 logic [4:0]  score;
	 logic [1:0]  stage;
	 logic 		  win;
  	 
	 // Game variable
	 // Player
	 logic [11:0] p1PosX;
	 logic [9:0]  p1PosY;
	 logic p1_Att, p1D;
	 logic [2:0]  p1HP;
	 logic [6:0]  hp_value;
	 //logic [7:0]  d1code;
	 // Monster
	 logic [11:0] m1PosX;
	 logic [9:0]  m1PosY;
	 logic [11:0] m2PosX;
	 logic [9:0]  m2PosY;
	 logic m1Alive, m2Alive; 
	 // Rocket
	 logic rocket_on;
	 logic [11:0] rPosX;
	 logic [9:0]  rPosY;
     
     // The connections for nios_system might be named different depending on how you set up Qsys
     final_project_soc NiosII_Processor(
											// Nios II
											.clk_clk(Clk),         
											.reset_reset_n(KEY[0]),   
											.sdram_wire_addr(DRAM_ADDR), 
											.sdram_wire_ba(DRAM_BA),   
											.sdram_wire_cas_n(DRAM_CAS_N),
											.sdram_wire_cke(DRAM_CKE),  
											.sdram_wire_cs_n(DRAM_CS_N), 
											.sdram_wire_dq(DRAM_DQ),   
											.sdram_wire_dqm(DRAM_DQM),  
											.sdram_wire_ras_n(DRAM_RAS_N),
											.sdram_wire_we_n(DRAM_WE_N), 
											.sdram_clk_clk(DRAM_CLK),
											// Game
											.keycode_export(keycode),
											.press_export(press),
											.mapposx_export(mapPosX),
											.score_export(score),
											.stage_export(stage),
											.win_export(win),
											//	Monster 1
											.m1alive_export(m1Alive),
											.m1posx_export(m1PosX),
											.m1posy_export(m1PosY),
											//	Player 1
											.p1_att_export(p1_Att),
											.p1d_export(p1D),
											.p1hp_export(p1HP),
											.p1posx_export(p1PosX),
											.p1posy_export(p1PosY),
											// 	Monster 2
											.m2posx_export(m2PosX),
											.m2posy_export(m2PosY),
											.m2alive_export(m2Alive),
											// Rocket
											.rocket_on_export(rocket_on),
											.rposx_export(rPosX),
											.rposy_export(rPosY)
    );
    
	 
    //Fill in the connections for the rest of the modules 
    VGA_controller vga_control(
											.Clk(Clk), 
											.Reset(Reset_h), 
											.VGA_HS(VGA_HS), 
											.VGA_VS(VGA_VS), 
											.VGA_CLK(VGA_CLK), 
											.VGA_BLANK_N(VGA_BLANK_N), 
											.VGA_SYNC_N(VGA_SYNC_N), 
											.DrawX(DrawX),
											.DrawY(DrawY)
	 );
   
//    ball ball_instance(
//								.Reset(Reset_h),
//								.frame_clk(VGA_VS),
//								.keycode(keycode),
//								.BallX(BallX),
//								.BallY(BallY),
//								.BallS(BallS)
//								
//	 
//	 );
	 
	 keyboard ps2Keyboard(
											.Clk(Clk),
											.psClk(ps2_CLK),
											.psData(ps2_DAT), 
											.reset(reset_h),
											.keyCode(keycode),
											.press(press)
	 );
    
    color_mapper color_instance(
											.Clk(Clk),
											.DrawX(DrawX),
											.DrawY(DrawY),
											.VGA_R(VGA_R),
											.VGA_G(VGA_G),
											.VGA_B(VGA_B),
											.RGB_BG(RGB_BG),
											.RGB_COVER(RGB_COVER),
											.RGB_GO(RGB_GO),
											.score(score),
											.stage(stage),
											.win(win),
											.mapPosX(mapPosX),
											// Objects drawing
											.p1PosX(p1PosX-mapPosX),
											.p1PosY(p1PosY),
											.p1D(p1D),
											.p1_Att(p1_Att),
											.hp_value(hp_value),
											// Monster 1
											.m1PosX(m1PosX-mapPosX),
											.m1PosY(m1PosY),
											.m1Alive(m1Alive),
											// Monster 2
											.m2PosX(m2PosX-mapPosX),
											.m2PosY(m2PosY),
											.m2Alive(m2Alive),
											// Rocket
											.rocket_on(rocket_on),
											.rPosX(rPosX-mapPosX),
											.rPosY(rPosY)
											
	 );
	 


	// The tri-state buffer manages the SRAM
	tristate #(.N(16)) tr0(
											.Clk(Clk_25), 
											.Data_read(SRAM_Out), 
											.Data(SRAM_Data)
	);
	
	// The SRAM controller
	SRAM_controller SRAM0 (
											.DrawX(DrawX),
											.DrawY(DrawY),
											.Offset(mapPosX),
											.ADDR(SRAM_ADDR),
											.stage(stage)
	);
	
	// The palette lookup table
	palette_background palette_b (
											.index(SRAM_Out[3:0]),
											.RGB(RGB_BG)
	);
	
	palette_cover palette_c (
											.index(SRAM_Out[3:0]),
											.RGB(RGB_COVER)
	);
	
	palette_go palette_g (
											.index(SRAM_Out[3:0]),
											.RGB(RGB_GO)
	);
	
	hp player_p	(
											.hp(p1HP),
											.hp_value(hp_value)
	);
    
//    HexDriver hex_inst_0 (d1code[3:0], HEX0);
//    HexDriver hex_inst_1 (d1code[7:4], HEX1);
    
endmodule
