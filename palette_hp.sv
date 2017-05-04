module palette_hp (
						input [3:0] 			index,
						output logic [23:0] 	RGB
);

	always_comb
	begin  
		unique case (index)
			4'h0 		: RGB = 24'hff4295;
			4'h1 		: RGB = 24'hdbd2d2;
			4'h2 		: RGB = 24'hf61b1b;
			default  : RGB = 24'h000000;
			
		endcase
	end
endmodule	
