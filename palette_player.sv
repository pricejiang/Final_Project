module palette_player (
						input [3:0] 			index,
						output logic [23:0] 	RGB
);

	always_comb
	begin  
		unique case (index)
			4'h0 		: RGB = 24'hff4295;
			4'h1 		: RGB = 24'h412608;
			4'h2 		: RGB = 24'hc9a35b;
			4'h3 		: RGB = 24'hf5e9a5;
			4'h4 		: RGB = 24'h935116;
			4'h5 		: RGB = 24'h111108;
			4'h6 		: RGB = 24'h726839;
			default  : RGB = 24'h000000;
			
		endcase
	end
endmodule	

