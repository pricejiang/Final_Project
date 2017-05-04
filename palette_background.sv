module palette_background (
						input [3:0] 			index,
						output logic [23:0] 	RGB
);

	always_comb
	begin  
		unique case (index)
			4'h0 		: RGB = 24'h565746;
			4'h1 		: RGB = 24'h3f433c;
			4'h2 		: RGB = 24'h675234;
			4'h3 		: RGB = 24'h523d22;
			4'h4 		: RGB = 24'h3b2f1d;
			4'h5 		: RGB = 24'h909d8d;
			4'h6 		: RGB = 24'he0cb83;
			4'h7 		: RGB = 24'h8f8961;
			4'h8 		: RGB = 24'hbea666;
			4'h9 		: RGB = 24'h847047;
			4'ha 		: RGB = 24'h6a6d55;
			4'hb 		: RGB = 24'ha0b3ae;
			4'hc 		: RGB = 24'h647a7d;
			4'hd 		: RGB = 24'hb6ced9;
			4'he 		: RGB = 24'hc6dce3;
			4'hf 		: RGB = 24'h495d60;
			default  : RGB = 24'h000000;
		endcase
	end
endmodule	