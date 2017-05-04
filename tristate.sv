//------------------------------------------------------------------------------
// Company: 		 UIUC ECE Dept.
// Engineer:		 Stephen Kempf
//
// Create Date:    
// Design Name:    ECE 385 Lab 6 Given Code - Tristate buffer for SRAM
// Module Name:    tristate
//
// Comments:
//    Revised 02-13-2017
//    Spring 2017 Distribution
//
//------------------------------------------------------------------------------
//
//	This code is from ECE 385 Lab 6
//	
//	Modification has been made
//
//------------------------------------------------------------------------------




module tristate #(N = 16) (
	input logic Clk, 
	output logic [N-1:0] Data_read, // Data to Mem2IO
	inout wire [N-1:0] Data // inout bus to SRAM
);

// Registers are needed between synchronized circuit and asynchronized SRAM 
logic [N-1:0] Data_read_buffer;

always_ff @(posedge Clk)
begin

	Data_read_buffer <= Data;
	
end

// Assign Data_read_buffer to output Data_read
assign Data_read = Data_read_buffer;

endmodule
