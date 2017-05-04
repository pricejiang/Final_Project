//-------------------------------------------------------------------------
//    Ball.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  03-03-2017                               --
//    Spring 2017 Distribution                                           --
//                                                                       --
//    For use with ECE 298 Lab 7                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module  ball ( input         Reset, 
                             frame_clk, 							  // The clock indicating a new frame (~60Hz)
					input[7:0]	  keycode,
               output [9:0]  BallX, BallY, BallS // Ball coordinates and size
              );
    
    logic [9:0] Ball_X_Pos, Ball_X_Motion, Ball_Y_Pos, Ball_Y_Motion;
    logic [9:0] Ball_X_Pos_in, Ball_X_Motion_in, Ball_Y_Pos_in, Ball_Y_Motion_in;
     
    parameter [9:0] Ball_X_Center=320;  // Center position on the X axis
    parameter [9:0] Ball_Y_Center=240;  // Center position on the Y axis
    parameter [9:0] Ball_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Ball_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] Ball_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Ball_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] Ball_X_Step=1;      // Step size on the X axis
    parameter [9:0] Ball_Y_Step=4;      // Step size on the Y axis
    parameter [9:0] Ball_Size=4;        // Ball size
    parameter [9:0] width = 10'd24;
	 parameter [9:0] height = 10'd33;
	 
    assign BallX = Ball_X_Pos;
    assign BallY = Ball_Y_Pos;
    assign BallS = Ball_Size;
	 
	 
	 
    map_position map	(.currentX(Ball_X_Pos), .currentY(Ball_Y_Pos), .size_X(width/2), .size_Y(height/2), 
							 .mX(Ball_X_Motion_in), .mY(Ball_Y_Motion_in), .motionInX(x_motion), .motionInY(y_motion) );
	 
    always_ff @ (posedge frame_clk)
    begin
        if (Reset)
        begin
            Ball_X_Pos <= Ball_X_Center;
            Ball_Y_Pos <= Ball_Y_Center;
            Ball_X_Motion <= 10'd0;
            Ball_Y_Motion <= 10'd0;
        end
        else 
        begin
            Ball_X_Pos <= Ball_X_Pos_in;
            Ball_Y_Pos <= Ball_Y_Pos_in;
            Ball_X_Motion <= x_motion;
            Ball_Y_Motion <= y_motion;
        end
    end
    logic[9:0] x_motion, y_motion;
    always_comb
    begin
        // By default, keep motion unchanged
        Ball_X_Motion_in = 0;
        Ball_Y_Motion_in = 10'd3;
        
        // Be careful when using comparators with "logic" datatype becuase compiler treats 
        //   both sides of the operator UNSIGNED numbers. (unless with further type casting)
        // e.g. Ball_Y_Pos - Ball_Size <= Ball_Y_Min 
        // If Ball_Y_Pos is 0, then Ball_Y_Pos - Ball_Size will not be -4, but rather a large positive number.
		  unique case(keycode[7:0])
				8'h1D: //up
			begin
				Ball_X_Motion_in = 10'd0;
				Ball_Y_Motion_in = (~(Ball_Y_Step) + 1'b1);
			end
				8'h1B: //down
			begin
				Ball_X_Motion_in = 10'd0;
				Ball_Y_Motion_in = Ball_Y_Step;
			end
				8'h1C: //left
			begin
				Ball_X_Motion_in = ~(Ball_X_Step) + 1'b1;
				Ball_Y_Motion_in = 10'd5;
				
			end
				8'h23: //right
			begin
				Ball_X_Motion_in = Ball_X_Step;
				Ball_Y_Motion_in = 10'd5;
			end
			
			default:
			begin
				Ball_X_Motion_in = 0;
				Ball_Y_Motion_in = 10'd5;
			end
			
			endcase
			
        
        // Update the ball's position with its motion
        Ball_X_Pos_in = Ball_X_Pos + x_motion;
        Ball_Y_Pos_in = Ball_Y_Pos + y_motion;
        
    /**************************************************************************************
        ATTENTION! Please answer the following quesiton in your lab report! Points will be allocated for the answers!
        Hidden Question #2/2:
          Notice that Ball_Y_Pos is updated using Ball_Y_Motion. 
          Will the new value of Ball_Y_Motion be used when Ball_Y_Pos is updated, or the old? 
          What is the difference between writing
            "Ball_Y_Pos_in = Ball_Y_Pos + Ball_Y_Motion;" and 
            "Ball_Y_Pos_in = Ball_Y_Pos + Ball_Y_Motion_in;"?
          How will this impact behavior of the ball during a bounce, and how might that interact with a response to a keypress?
          Give an answer in your Post-Lab.
    **************************************************************************************/
        
    end
    
endmodule
