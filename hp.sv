module hp (
				input [2:0] hp,
				output logic [6:0] hp_value

);
	always_comb
	begin
		unique case (hp)
			3'd0 		: hp_value = 7'b0000000;
			3'd1		: hp_value = 7'b0000001;
			3'd2		: hp_value = 7'b0000011;
			3'd3		: hp_value = 7'b0000111;
			3'd4		: hp_value = 7'b0001111;
			3'd5		: hp_value = 7'b0011111;
			3'd6		: hp_value = 7'b0111111;
			3'd7		: hp_value = 7'b1111111;
			default  : hp_value = 7'b0000000;
		endcase
	end

endmodule 