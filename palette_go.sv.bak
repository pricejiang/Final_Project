module palette_go (
						input [3:0] 			index,
						output logic [23:0] 	RGB
);

	always_comb
	begin  
		unique case (index)
			4'h0 		: RGB = 24'h100000;
			4'h1 		: RGB = 24'h301b08;
			4'h2 		: RGB = 24'h7eb819;
			4'h3 		: RGB = 24'h5e3a15;
			4'h4 		: RGB = 24'h7f5828;
			4'h5 		: RGB = 24'hdac06f;
			4'h6 		: RGB = 24'hae8656;
			4'h7 		: RGB = 24'h906838;
			default  : RGB = 24'h000000;
		endcase
	end
endmodule	