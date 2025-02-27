module palette_tank(
						input [3:0] 			index,
						output logic [23:0] 	RGB
);

	always_comb
	begin  
		unique case (index)
			4'h0 		: RGB = 24'hff4295;
			4'h1 		: RGB = 24'h7a785a;
			4'h2 		: RGB = 24'h423f21;
			4'h3 		: RGB = 24'h979678;
			4'h4 		: RGB = 24'hcdcdb7;
			4'h5 		: RGB = 24'h1c1c03;
			4'h6 		: RGB = 24'h636245;
			default  : RGB = 24'h000000;
			
		endcase
	end
endmodule	

