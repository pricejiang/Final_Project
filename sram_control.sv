module SRAM_controller(
								input [9:0]					DrawX, DrawY, 
								input [11:0]				Offset,
								input [1:0]					stage,
								output logic [19:0] 		ADDR
								);
				always_comb
				begin 
					if(DrawY < 10'd120 || DrawY > 10'd359 || DrawX > 10'd639 || DrawX < 0) // Out of bound, address to 0
						ADDR = 20'd0;
					else if(stage == 0)
						ADDR = (DrawY-10'd120) * 10'd640 + DrawX + 20'd486000;
					else if(stage == 1)
						ADDR = (DrawY-10'd120) * 20'd2025 + Offset + DrawX;
					else if(stage == 2)
						ADDR = (DrawY-10'd120) * 10'd640 + DrawX + 20'd639600;
					else 
						ADDR = 20'd0;
				end				
endmodule 