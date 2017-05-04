module palette_mc (
						input [3:0] 			index,
						output logic [23:0] 	RGB
);

	always_comb
	begin  
		unique case (index)
			4'h0 		: RGB = 24'hff4295;
			4'h1 		: RGB = 24'he6cec1;
			4'h2 		: RGB = 24'hbe9082;
			4'h3 		: RGB = 24'h934e34;
			4'h4 		: RGB = 24'hdf6829;
			4'h5 		: RGB = 24'hf1b760;
			4'h6 		: RGB = 24'hb91e10;
			default  : RGB = 24'h000000;
			
		endcase
	end
endmodule	
