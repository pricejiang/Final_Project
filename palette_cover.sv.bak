module palette_cover (
						input [3:0] 			index,
						output logic [23:0] 	RGB
);

	always_comb
	begin  
		unique case (index)
			4'h0 		: RGB = 24'h130705;
			4'h1 		: RGB = 24'h3b281b;
			4'h2 		: RGB = 24'h605744;
			4'h3 		: RGB = 24'h807861;
			4'h4 		: RGB = 24'h941c05;
			4'h5 		: RGB = 24'hf59009;
			4'h6 		: RGB = 24'hd04705;
			4'h7 		: RGB = 24'hdfdad0;
			default  : RGB = 24'h000000;

		endcase
	end
endmodule	