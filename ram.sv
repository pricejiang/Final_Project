/*
 * ECE385-HelperTools/PNG-To-Txt
 * Author: Rishi Thakkar
 *
 */

module  frameRAM
(
		//input [4:0] data_In,
		input [18:0] read_address,
		input Clk,

		output logic [3:0] data_Out
		//output logic [6:0]  HEX0, HEX1
);

// mem has width of 3 bits and a total of 35031 addresses
logic [3:0] mem [0:35031];

initial
begin
	 $readmemh("Game2.txt", mem);
end


always_ff @ (posedge Clk) begin
		data_Out<= mem[read_address];

end


endmodule
