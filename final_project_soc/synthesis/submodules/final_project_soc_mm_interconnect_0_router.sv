// (C) 2001-2015 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.



// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


// $Id: //acds/rel/15.0/ip/merlin/altera_merlin_router/altera_merlin_router.sv.terp#1 $
// $Revision: #1 $
// $Date: 2015/02/08 $
// $Author: swbranch $

// -------------------------------------------------------
// Merlin Router
//
// Asserts the appropriate one-hot encoded channel based on 
// either (a) the address or (b) the dest id. The DECODER_TYPE
// parameter controls this behaviour. 0 means address decoder,
// 1 means dest id decoder.
//
// In the case of (a), it also sets the destination id.
// -------------------------------------------------------

`timescale 1 ns / 1 ns

module final_project_soc_mm_interconnect_0_router_default_decode
  #(
     parameter DEFAULT_CHANNEL = 5,
               DEFAULT_WR_CHANNEL = -1,
               DEFAULT_RD_CHANNEL = -1,
               DEFAULT_DESTID = 22 
   )
  (output [96 - 92 : 0] default_destination_id,
   output [26-1 : 0] default_wr_channel,
   output [26-1 : 0] default_rd_channel,
   output [26-1 : 0] default_src_channel
  );

  assign default_destination_id = 
    DEFAULT_DESTID[96 - 92 : 0];

  generate
    if (DEFAULT_CHANNEL == -1) begin : no_default_channel_assignment
      assign default_src_channel = '0;
    end
    else begin : default_channel_assignment
      assign default_src_channel = 26'b1 << DEFAULT_CHANNEL;
    end
  endgenerate

  generate
    if (DEFAULT_RD_CHANNEL == -1) begin : no_default_rw_channel_assignment
      assign default_wr_channel = '0;
      assign default_rd_channel = '0;
    end
    else begin : default_rw_channel_assignment
      assign default_wr_channel = 26'b1 << DEFAULT_WR_CHANNEL;
      assign default_rd_channel = 26'b1 << DEFAULT_RD_CHANNEL;
    end
  endgenerate

endmodule


module final_project_soc_mm_interconnect_0_router
(
    // -------------------
    // Clock & Reset
    // -------------------
    input clk,
    input reset,

    // -------------------
    // Command Sink (Input)
    // -------------------
    input                       sink_valid,
    input  [110-1 : 0]    sink_data,
    input                       sink_startofpacket,
    input                       sink_endofpacket,
    output                      sink_ready,

    // -------------------
    // Command Source (Output)
    // -------------------
    output                          src_valid,
    output reg [110-1    : 0] src_data,
    output reg [26-1 : 0] src_channel,
    output                          src_startofpacket,
    output                          src_endofpacket,
    input                           src_ready
);

    // -------------------------------------------------------
    // Local parameters and variables
    // -------------------------------------------------------
    localparam PKT_ADDR_H = 65;
    localparam PKT_ADDR_L = 36;
    localparam PKT_DEST_ID_H = 96;
    localparam PKT_DEST_ID_L = 92;
    localparam PKT_PROTECTION_H = 100;
    localparam PKT_PROTECTION_L = 98;
    localparam ST_DATA_W = 110;
    localparam ST_CHANNEL_W = 26;
    localparam DECODER_TYPE = 0;

    localparam PKT_TRANS_WRITE = 68;
    localparam PKT_TRANS_READ  = 69;

    localparam PKT_ADDR_W = PKT_ADDR_H-PKT_ADDR_L + 1;
    localparam PKT_DEST_ID_W = PKT_DEST_ID_H-PKT_DEST_ID_L + 1;



    // -------------------------------------------------------
    // Figure out the number of bits to mask off for each slave span
    // during address decoding
    // -------------------------------------------------------
    localparam PAD0 = log2ceil(64'h10000000 - 64'h8000000); 
    localparam PAD1 = log2ceil(64'h10001000 - 64'h10000800); 
    localparam PAD2 = log2ceil(64'h10001020 - 64'h10001010); 
    localparam PAD3 = log2ceil(64'h10001030 - 64'h10001020); 
    localparam PAD4 = log2ceil(64'h10001040 - 64'h10001030); 
    localparam PAD5 = log2ceil(64'h10001050 - 64'h10001040); 
    localparam PAD6 = log2ceil(64'h10001058 - 64'h10001050); 
    localparam PAD7 = log2ceil(64'h10001060 - 64'h10001058); 
    localparam PAD8 = log2ceil(64'h10001080 - 64'h10001070); 
    localparam PAD9 = log2ceil(64'h10001090 - 64'h10001080); 
    localparam PAD10 = log2ceil(64'h100010a0 - 64'h10001090); 
    localparam PAD11 = log2ceil(64'h100010b0 - 64'h100010a0); 
    localparam PAD12 = log2ceil(64'h100010c0 - 64'h100010b0); 
    localparam PAD13 = log2ceil(64'h100010e0 - 64'h100010d0); 
    localparam PAD14 = log2ceil(64'h100010f0 - 64'h100010e0); 
    localparam PAD15 = log2ceil(64'h10001100 - 64'h100010f0); 
    localparam PAD16 = log2ceil(64'h20000010 - 64'h20000000); 
    localparam PAD17 = log2ceil(64'h20000020 - 64'h20000010); 
    localparam PAD18 = log2ceil(64'h20000030 - 64'h20000020); 
    localparam PAD19 = log2ceil(64'h20000040 - 64'h20000030); 
    localparam PAD20 = log2ceil(64'h20000050 - 64'h20000040); 
    localparam PAD21 = log2ceil(64'h20000060 - 64'h20000050); 
    localparam PAD22 = log2ceil(64'h20000070 - 64'h20000060); 
    localparam PAD23 = log2ceil(64'h20000080 - 64'h20000070); 
    localparam PAD24 = log2ceil(64'h20000090 - 64'h20000080); 
    localparam PAD25 = log2ceil(64'h200000a0 - 64'h20000090); 
    // -------------------------------------------------------
    // Work out which address bits are significant based on the
    // address range of the slaves. If the required width is too
    // large or too small, we use the address field width instead.
    // -------------------------------------------------------
    localparam ADDR_RANGE = 64'h200000a0;
    localparam RANGE_ADDR_WIDTH = log2ceil(ADDR_RANGE);
    localparam OPTIMIZED_ADDR_H = (RANGE_ADDR_WIDTH > PKT_ADDR_W) ||
                                  (RANGE_ADDR_WIDTH == 0) ?
                                        PKT_ADDR_H :
                                        PKT_ADDR_L + RANGE_ADDR_WIDTH - 1;

    localparam RG = RANGE_ADDR_WIDTH-1;
    localparam REAL_ADDRESS_RANGE = OPTIMIZED_ADDR_H - PKT_ADDR_L;

      reg [PKT_ADDR_W-1 : 0] address;
      always @* begin
        address = {PKT_ADDR_W{1'b0}};
        address [REAL_ADDRESS_RANGE:0] = sink_data[OPTIMIZED_ADDR_H : PKT_ADDR_L];
      end   

    // -------------------------------------------------------
    // Pass almost everything through, untouched
    // -------------------------------------------------------
    assign sink_ready        = src_ready;
    assign src_valid         = sink_valid;
    assign src_startofpacket = sink_startofpacket;
    assign src_endofpacket   = sink_endofpacket;
    wire [PKT_DEST_ID_W-1:0] default_destid;
    wire [26-1 : 0] default_src_channel;




    // -------------------------------------------------------
    // Write and read transaction signals
    // -------------------------------------------------------
    wire read_transaction;
    assign read_transaction  = sink_data[PKT_TRANS_READ];


    final_project_soc_mm_interconnect_0_router_default_decode the_default_decode(
      .default_destination_id (default_destid),
      .default_wr_channel   (),
      .default_rd_channel   (),
      .default_src_channel  (default_src_channel)
    );

    always @* begin
        src_data    = sink_data;
        src_channel = default_src_channel;
        src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = default_destid;

        // --------------------------------------------------
        // Address Decoder
        // Sets the channel and destination ID based on the address
        // --------------------------------------------------

    // ( 0x8000000 .. 0x10000000 )
    if ( {address[RG:PAD0],{PAD0{1'b0}}} == 30'h8000000   ) begin
            src_channel = 26'b00000000000000000000100000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 22;
    end

    // ( 0x10000800 .. 0x10001000 )
    if ( {address[RG:PAD1],{PAD1{1'b0}}} == 30'h10000800   ) begin
            src_channel = 26'b00000000000000000000000100;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 10;
    end

    // ( 0x10001010 .. 0x10001020 )
    if ( {address[RG:PAD2],{PAD2{1'b0}}} == 30'h10001010  && read_transaction  ) begin
            src_channel = 26'b00000000001000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 17;
    end

    // ( 0x10001020 .. 0x10001030 )
    if ( {address[RG:PAD3],{PAD3{1'b0}}} == 30'h10001020   ) begin
            src_channel = 26'b00000000000100000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 3;
    end

    // ( 0x10001030 .. 0x10001040 )
    if ( {address[RG:PAD4],{PAD4{1'b0}}} == 30'h10001030   ) begin
            src_channel = 26'b00000000000010000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 12;
    end

    // ( 0x10001040 .. 0x10001050 )
    if ( {address[RG:PAD5],{PAD5{1'b0}}} == 30'h10001040   ) begin
            src_channel = 26'b00000000000001000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 16;
    end

    // ( 0x10001050 .. 0x10001058 )
    if ( {address[RG:PAD6],{PAD6{1'b0}}} == 30'h10001050   ) begin
            src_channel = 26'b00000000000000000000000001;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 1;
    end

    // ( 0x10001058 .. 0x10001060 )
    if ( {address[RG:PAD7],{PAD7{1'b0}}} == 30'h10001058  && read_transaction  ) begin
            src_channel = 26'b00000000000000000000000010;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 24;
    end

    // ( 0x10001070 .. 0x10001080 )
    if ( {address[RG:PAD8],{PAD8{1'b0}}} == 30'h10001070   ) begin
            src_channel = 26'b00000000000000100000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 13;
    end

    // ( 0x10001080 .. 0x10001090 )
    if ( {address[RG:PAD9],{PAD9{1'b0}}} == 30'h10001080   ) begin
            src_channel = 26'b00000000000000010000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 5;
    end

    // ( 0x10001090 .. 0x100010a0 )
    if ( {address[RG:PAD10],{PAD10{1'b0}}} == 30'h10001090   ) begin
            src_channel = 26'b00000000000000001000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 4;
    end

    // ( 0x100010a0 .. 0x100010b0 )
    if ( {address[RG:PAD11],{PAD11{1'b0}}} == 30'h100010a0   ) begin
            src_channel = 26'b00000000000000000100000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 15;
    end

    // ( 0x100010b0 .. 0x100010c0 )
    if ( {address[RG:PAD12],{PAD12{1'b0}}} == 30'h100010b0   ) begin
            src_channel = 26'b00000000000000000010000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 14;
    end

    // ( 0x100010d0 .. 0x100010e0 )
    if ( {address[RG:PAD13],{PAD13{1'b0}}} == 30'h100010d0  && read_transaction  ) begin
            src_channel = 26'b00000000000000000001000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 2;
    end

    // ( 0x100010e0 .. 0x100010f0 )
    if ( {address[RG:PAD14],{PAD14{1'b0}}} == 30'h100010e0   ) begin
            src_channel = 26'b00000000000000000000010000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 11;
    end

    // ( 0x100010f0 .. 0x10001100 )
    if ( {address[RG:PAD15],{PAD15{1'b0}}} == 30'h100010f0   ) begin
            src_channel = 26'b00000000000000000000001000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 21;
    end

    // ( 0x20000000 .. 0x20000010 )
    if ( {address[RG:PAD16],{PAD16{1'b0}}} == 30'h20000000   ) begin
            src_channel = 26'b00000000010000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 7;
    end

    // ( 0x20000010 .. 0x20000020 )
    if ( {address[RG:PAD17],{PAD17{1'b0}}} == 30'h20000010   ) begin
            src_channel = 26'b00000000100000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 8;
    end

    // ( 0x20000020 .. 0x20000030 )
    if ( {address[RG:PAD18],{PAD18{1'b0}}} == 30'h20000020   ) begin
            src_channel = 26'b00000001000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 6;
    end

    // ( 0x20000030 .. 0x20000040 )
    if ( {address[RG:PAD19],{PAD19{1'b0}}} == 30'h20000030   ) begin
            src_channel = 26'b00000010000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 9;
    end

    // ( 0x20000040 .. 0x20000050 )
    if ( {address[RG:PAD20],{PAD20{1'b0}}} == 30'h20000040   ) begin
            src_channel = 26'b00010000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 20;
    end

    // ( 0x20000050 .. 0x20000060 )
    if ( {address[RG:PAD21],{PAD21{1'b0}}} == 30'h20000050   ) begin
            src_channel = 26'b00000100000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 18;
    end

    // ( 0x20000060 .. 0x20000070 )
    if ( {address[RG:PAD22],{PAD22{1'b0}}} == 30'h20000060   ) begin
            src_channel = 26'b00001000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 19;
    end

    // ( 0x20000070 .. 0x20000080 )
    if ( {address[RG:PAD23],{PAD23{1'b0}}} == 30'h20000070   ) begin
            src_channel = 26'b00100000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 0;
    end

    // ( 0x20000080 .. 0x20000090 )
    if ( {address[RG:PAD24],{PAD24{1'b0}}} == 30'h20000080   ) begin
            src_channel = 26'b01000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 23;
    end

    // ( 0x20000090 .. 0x200000a0 )
    if ( {address[RG:PAD25],{PAD25{1'b0}}} == 30'h20000090   ) begin
            src_channel = 26'b10000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 25;
    end

end


    // --------------------------------------------------
    // Ceil(log2()) function
    // --------------------------------------------------
    function integer log2ceil;
        input reg[65:0] val;
        reg [65:0] i;

        begin
            i = 1;
            log2ceil = 0;

            while (i < val) begin
                log2ceil = log2ceil + 1;
                i = i << 1;
            end
        end
    endfunction

endmodule


