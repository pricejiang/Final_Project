
module final_project_soc (
	clk_clk,
	keycode_export,
	m1alive_export,
	m1posx_export,
	m1posy_export,
	m2alive_export,
	m2posx_export,
	m2posy_export,
	mapposx_export,
	p1_att_export,
	p1d_export,
	p1hp_export,
	p1posx_export,
	p1posy_export,
	press_export,
	reset_reset_n,
	rocket_on_export,
	rposx_export,
	rposy_export,
	score_export,
	sdram_clk_clk,
	sdram_wire_addr,
	sdram_wire_ba,
	sdram_wire_cas_n,
	sdram_wire_cke,
	sdram_wire_cs_n,
	sdram_wire_dq,
	sdram_wire_dqm,
	sdram_wire_ras_n,
	sdram_wire_we_n,
	stage_export,
	win_export);	

	input		clk_clk;
	input	[7:0]	keycode_export;
	output		m1alive_export;
	output	[11:0]	m1posx_export;
	output	[9:0]	m1posy_export;
	output		m2alive_export;
	output	[11:0]	m2posx_export;
	output	[9:0]	m2posy_export;
	output	[11:0]	mapposx_export;
	output		p1_att_export;
	output		p1d_export;
	output	[2:0]	p1hp_export;
	output	[11:0]	p1posx_export;
	output	[9:0]	p1posy_export;
	input		press_export;
	input		reset_reset_n;
	output		rocket_on_export;
	output	[11:0]	rposx_export;
	output	[9:0]	rposy_export;
	output	[4:0]	score_export;
	output		sdram_clk_clk;
	output	[12:0]	sdram_wire_addr;
	output	[1:0]	sdram_wire_ba;
	output		sdram_wire_cas_n;
	output		sdram_wire_cke;
	output		sdram_wire_cs_n;
	inout	[31:0]	sdram_wire_dq;
	output	[3:0]	sdram_wire_dqm;
	output		sdram_wire_ras_n;
	output		sdram_wire_we_n;
	output	[1:0]	stage_export;
	output		win_export;
endmodule
