module map_position (input [9:0] currentX, currentY, size_X, size_Y,
							input	[9:0] mX, mY,
							output [9:0] motionInX, motionInY);

always_comb
begin
	motionInX = mX;
	motionInY = mY;
	if(currentX  < 10'd210 && currentX >= 0)
	begin
		if(currentY + size_Y  <  10'd420 && currentY + size_Y + mY > 10'd420 )
			motionInY = 10'd420 - currentY - size_Y;
		else if(currentY + size_Y  ==  10'd420 && currentY + size_Y + mY > 10'd420 )
			motionInY = 0;

		if(currentX + mX + size_X > 10'd210 && currentY + size_Y > 10'd360 && currentX + size_X == 10'd210)
			motionInX = 10'b0;
		if(currentX == size_X && currentX + mX < size_X)
			motionInX = 10'b0;
	end
	
		
	if(currentX < 10'd420 && currentX >= 10'd210 )
	begin
		
		if(currentY + size_Y  < 10'd360 &&  currentY + size_Y + mY > 10'd360)
			motionInY = 10'd360 - currentY - size_Y;
		else if(currentY + size_Y  == 10'd360 &&  currentY + size_Y + mY > 10'd360)
			motionInY = 0;

		if(currentX + mX < 10'd210 && currentY + size_Y == 10'd360 && currentY + size_Y + mY > 10'd360)
			motionInX = ~(size_X) + 1'b1 + mX;
		if(currentX + mX > 10'd420 && currentY + size_Y == 10'd360 && currentY + size_Y + mY > 10'd360)
			motionInX = size_X;
		
	end
	
		
	if(currentX >= 10'd420)
	begin
		if(currentY + size_Y  < 10'd420 &&  currentY + size_Y + mY > 10'd420)
			motionInY = 10'd420 - currentY - size_Y;
		else if(currentY + size_Y  == 10'd420 &&  currentY + size_Y + mY > 10'd420)
			motionInY = 0;

		if(currentX  == 10'd420 + size_X && currentX + mX  < 10'd420 + size_X && currentY + size_Y > 10'd360)
			motionInX = 10'b0;
		if(currentX +size_X == 10'd640 && currentX +size_X +  mX > 10'd640)
			motionInX = ~(size_X) + 1'b1;
	end
		
end
endmodule
	
			
			
		