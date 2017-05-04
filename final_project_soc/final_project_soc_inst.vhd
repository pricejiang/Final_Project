	component final_project_soc is
		port (
			clk_clk          : in    std_logic                     := 'X';             -- clk
			keycode_export   : in    std_logic_vector(7 downto 0)  := (others => 'X'); -- export
			m1alive_export   : out   std_logic;                                        -- export
			m1posx_export    : out   std_logic_vector(11 downto 0);                    -- export
			m1posy_export    : out   std_logic_vector(9 downto 0);                     -- export
			m2alive_export   : out   std_logic;                                        -- export
			m2posx_export    : out   std_logic_vector(11 downto 0);                    -- export
			m2posy_export    : out   std_logic_vector(9 downto 0);                     -- export
			mapposx_export   : out   std_logic_vector(11 downto 0);                    -- export
			p1_att_export    : out   std_logic;                                        -- export
			p1d_export       : out   std_logic;                                        -- export
			p1hp_export      : out   std_logic_vector(2 downto 0);                     -- export
			p1posx_export    : out   std_logic_vector(11 downto 0);                    -- export
			p1posy_export    : out   std_logic_vector(9 downto 0);                     -- export
			press_export     : in    std_logic                     := 'X';             -- export
			reset_reset_n    : in    std_logic                     := 'X';             -- reset_n
			rocket_on_export : out   std_logic;                                        -- export
			rposx_export     : out   std_logic_vector(11 downto 0);                    -- export
			rposy_export     : out   std_logic_vector(9 downto 0);                     -- export
			score_export     : out   std_logic_vector(4 downto 0);                     -- export
			sdram_clk_clk    : out   std_logic;                                        -- clk
			sdram_wire_addr  : out   std_logic_vector(12 downto 0);                    -- addr
			sdram_wire_ba    : out   std_logic_vector(1 downto 0);                     -- ba
			sdram_wire_cas_n : out   std_logic;                                        -- cas_n
			sdram_wire_cke   : out   std_logic;                                        -- cke
			sdram_wire_cs_n  : out   std_logic;                                        -- cs_n
			sdram_wire_dq    : inout std_logic_vector(31 downto 0) := (others => 'X'); -- dq
			sdram_wire_dqm   : out   std_logic_vector(3 downto 0);                     -- dqm
			sdram_wire_ras_n : out   std_logic;                                        -- ras_n
			sdram_wire_we_n  : out   std_logic;                                        -- we_n
			stage_export     : out   std_logic_vector(1 downto 0);                     -- export
			win_export       : out   std_logic                                         -- export
		);
	end component final_project_soc;

	u0 : component final_project_soc
		port map (
			clk_clk          => CONNECTED_TO_clk_clk,          --        clk.clk
			keycode_export   => CONNECTED_TO_keycode_export,   --    keycode.export
			m1alive_export   => CONNECTED_TO_m1alive_export,   --    m1alive.export
			m1posx_export    => CONNECTED_TO_m1posx_export,    --     m1posx.export
			m1posy_export    => CONNECTED_TO_m1posy_export,    --     m1posy.export
			m2alive_export   => CONNECTED_TO_m2alive_export,   --    m2alive.export
			m2posx_export    => CONNECTED_TO_m2posx_export,    --     m2posx.export
			m2posy_export    => CONNECTED_TO_m2posy_export,    --     m2posy.export
			mapposx_export   => CONNECTED_TO_mapposx_export,   --    mapposx.export
			p1_att_export    => CONNECTED_TO_p1_att_export,    --     p1_att.export
			p1d_export       => CONNECTED_TO_p1d_export,       --        p1d.export
			p1hp_export      => CONNECTED_TO_p1hp_export,      --       p1hp.export
			p1posx_export    => CONNECTED_TO_p1posx_export,    --     p1posx.export
			p1posy_export    => CONNECTED_TO_p1posy_export,    --     p1posy.export
			press_export     => CONNECTED_TO_press_export,     --      press.export
			reset_reset_n    => CONNECTED_TO_reset_reset_n,    --      reset.reset_n
			rocket_on_export => CONNECTED_TO_rocket_on_export, --  rocket_on.export
			rposx_export     => CONNECTED_TO_rposx_export,     --      rposx.export
			rposy_export     => CONNECTED_TO_rposy_export,     --      rposy.export
			score_export     => CONNECTED_TO_score_export,     --      score.export
			sdram_clk_clk    => CONNECTED_TO_sdram_clk_clk,    --  sdram_clk.clk
			sdram_wire_addr  => CONNECTED_TO_sdram_wire_addr,  -- sdram_wire.addr
			sdram_wire_ba    => CONNECTED_TO_sdram_wire_ba,    --           .ba
			sdram_wire_cas_n => CONNECTED_TO_sdram_wire_cas_n, --           .cas_n
			sdram_wire_cke   => CONNECTED_TO_sdram_wire_cke,   --           .cke
			sdram_wire_cs_n  => CONNECTED_TO_sdram_wire_cs_n,  --           .cs_n
			sdram_wire_dq    => CONNECTED_TO_sdram_wire_dq,    --           .dq
			sdram_wire_dqm   => CONNECTED_TO_sdram_wire_dqm,   --           .dqm
			sdram_wire_ras_n => CONNECTED_TO_sdram_wire_ras_n, --           .ras_n
			sdram_wire_we_n  => CONNECTED_TO_sdram_wire_we_n,  --           .we_n
			stage_export     => CONNECTED_TO_stage_export,     --      stage.export
			win_export       => CONNECTED_TO_win_export        --        win.export
		);

