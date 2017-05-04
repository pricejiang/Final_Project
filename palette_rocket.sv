module palette_rocket (
						input [3:0] 			index,
						output logic [23:0] 	RGB
);

	always_comb
	begin  
		unique case (index)
			4'h0 		: RGB = 24'hff4295;
			4'h1 		: RGB = 24'hfdfbe2;
			4'h2 		: RGB = 24'hfce693;
			4'h3 		: RGB = 24'hefc260;
			4'h4 		: RGB = 24'ha18759;
			4'h5 		: RGB = 24'hc2bfaa;
			4'h6 		: RGB = 24'h3a3319;
			default  : RGB = 24'h000000;
			
		endcase
	end
endmodule	
