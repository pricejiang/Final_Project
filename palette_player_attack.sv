module palette_player_attack (
						input [3:0] 			index,
						output logic [23:0] 	RGB
);

	always_comb
	begin  
		unique case (index)
			4'h0 		: RGB = 24'hff4295;
			4'h1 		: RGB = 24'h321a07;
			4'h2 		: RGB = 24'hc7ab62;
			4'h3 		: RGB = 24'hae3f00;
			4'h4 		: RGB = 24'h756332;
			4'h5 		: RGB = 24'hf6f2cf;
			4'h6 		: RGB = 24'ha08548;
			default  : RGB = 24'h000000;
			
		endcase
	end
endmodule	
