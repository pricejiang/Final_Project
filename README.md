# A Metal Slug Game
This is my Final Project for ECE385 - Digital System Lab
## Introduction
In this Final Project of ECE385, we built a “Metal Slug” game based on the knowledge we have learned through the semester. We designed and implemented the 2D video on the FPGA. The main character is controlled by a P/S 2 keyboard inputs with forward, backward, and jump motion. It has two more keyboard inputs to attack (melee) and shoot rocket (range). We designed a background and stage for the game. The main character needs to eliminate aggressive opponents in order to pass the game. The aggressive opponents will have their  own AI to move and attack. The main character has a health bar, and the player will lose if the health bar drops to 0. After the player reached the final checkpoint, “mission complete” would be displayed at the center of the screen, and the player will change into a tank. 

## Description of Project
Written Description of Project System
The Final Project is largely based on the ECE385 Lab8 with additional features  designed by us. The entire system is controlled by the game logic in software side written in C program and implemented by the FPGA hardware. So we need to set up the configuration of the SoC before we could write the software code.  The Qsys file is based on lab 8. We first removed all PIOs from lab 8.  We added one input PIO (8 bit ) for the keycode. We added several output PIOs to the hardware which contains the information about the game.The FPGA side reads keyboard input and transfers them through PIO to the software side. The software functions will process the inputs and generate corresponding outputs transferring through PIOs to the hardware side. The hardware side uses these outputs to read the images we wrote into either On Chip Memory or SRAM. The FPGA will display these images through VGA to the monitor. 

## Description of System Verilog Program
Module: 	11_reg.sv

Inputs:	Clk, Reset, Shift_In, Load, Shift_En, [10:0] D
Outputs: 	Shift_Out, [10:0] Data_Out
	
Description: 	This module is implemented as a 11 bit shift register. 

Purpose: 	This module is used by the keyboard.sv to store PS/2 keyboard input data. 

Reference: 	Sai Ma, Marie Liu. 11-13-2014. For use with ECE 385 Final Project. ECE Department @ UIUC. 



Module: 	Color_Mapper.sv

Inputs:	Clk, [11:0] p1PosX, m1PosX, m2PosX, rPosX, [9:0] p1PosY, m1PosY, m2PosY, rPosY, [9:0]  DrawX, DrawY,  m1Alive, m2Alive, rocket_on, p1D, p1_Att, [6:0] hp_value, [4:0] score, [1:0] stage, win, [23:0] RGB_COVER, [23:0] RGB_GO, [23:0] RGB_BG 
Outputs: 	[7:0]  VGA_R, VGA_G, VGA_B
	
Description: 	This module is the Color_Mapper module that reads the PIOs’ outputs and data from SRAM. On Chip Memory module is instantiated according to PIOs’ data multiple times in this module. Then the RGB value of each image will be read from corresponding pallette modules  . The RGB value of the VGA would be determined by the proc on logic of each image.  Images include player facing left, playing facing right, frog, player attack, tank, health, rocket, “mission complete” font, and background image. 

Purpose: 	This module outputs the VGA RGB signals for display. 

Reference: 	This module is based on Color_Mapper.sv from ECE385 Lab 8. Modification has been made. 


Module: 	D_reg.sv

Inputs:	Clk, Load, Reset, D
Outputs: 	Q
	
Description: 	This module is implemented as a register. 

Purpose: 	This module is used by the keyboard.sv for PS/2 clock edge detector. 

Reference: 	Sai Ma, Marie Liu. 11-13-2014. For use with ECE 385 Final Project. ECE Department @ UIUC. 


Module: 	font_rom.sv

Inputs:	addr
Outputs: 	data
	
Description: 	This module stores the font data like a read-only memory. We can use address to read the data from it. 

Purpose: 	This module outputs data that can be drawn on the VGA display. 

Reference: 	Daniel Chen. ECE385 Final Project. ECE Department @ UIUC. 


Module: 	hp.sv

Inputs:	[2:0] hp
Outputs: 	[6:0] hp_value
	
Description: 	This module reads the hp value output from software side and outputs one-hot hp_value to determine if each hp display is on. 

Purpose: 	This module outputs hp_value that can be easily interpreted by color_mapper module to display HP on display. 
Original Work


Module: 	keyboard.sv 

Inputs:	Clk, psClk, psData, reset,
Outputs: 	[7:0] keyCode, press

Description: 	This module reads PS/2 keyboard data and process it to output 8 bit keycode. 

Purpose: 	This module outputs the keyCode that will be transferred to software side for further processing. 

Reference: 	Sai Ma, Marie Liu. 11-13-2014. For use with ECE 385 Final Project. ECE Department @ UIUC. 


Module: 	palette_*.sv

Inputs:	[3:0] index
Outputs: 	[23:0] RGB

Description: 	These modules read the last 4 bit data from On Chip Memory or SRAM. Each palette file has a MUX that uses index as a key to output corresponding RGB value (24 bits) . 

Purpose: 	All of our images are first changed to at most 16 colors and then are changed to txt files (Using the ECE385-Helper-Tool from Rishi. URL: https://github.com/Atrifex/ECE385-HelperTools ). The RGB values in the txt files are changed to hex numbers from 0-f. Each Hex value represents the RGB value in the corresponding image. These palette modules serve like lookup tables so that the Color_Mapper would retrieve the original RGB values. 
Original Work


Module: 	ram.sv

Inputs:	[18:0] read_address, Clk
Outputs: 	[23:0] data_Out

Description: 	This module initializes the On Chip Memory by reading the txt file. The on-chip memory is configured into 35032  addresses with each address stores 4 bits data.  It outputs the value from the OCM. 

Purpose: 	This module sets the our image texts into OCM and output the value according to the address. 

Reference: 	Rishi. ECE385-Helper-Tool. URL: https://github.com/Atrifex/ECE385-HelperTools


Module: 	sram_controller.sv

Inputs:	[9:0] DrawX, DrawY,  [11:0]	Offset, [1:0] stage
Outputs: 	[19:0] 	ADDR

Description: 	This module inputs the drawing pixel coordinates and the two PIOs (Offset and stage) from software side. According to these variables, this module will generate the address for SRAM reading background image/ game covers. 

Purpose: 	This module generates SRAM read address for specific image that should be displayed. 
Original Work


Module: 	tristate.sv

Inputs:	Clk, [15:0] Data_read
	Outputs: 	[15:0] Data
	
Description: 	This module process the data from SRAM which is a bidirectional inout type to single direction. 

Purpose: 	This module outputs the SRAM data to Color_Mapper for VGA display. 

Reference: 	From ECE385 Lab 8. Modification has been made. 


Module: 	VGA_controller.sv

Inputs:	Clk, Reset
	Outputs: 	VGA_HS, VGA_VS, VGA_CLK, VGA_BLANK_N, VGA_SYNC_N
			[9:0] DrawX, DrawY
			
Description: 	This module generates the VGA clock and control signals. This modules loops through each horizontal line for the VGA device, and outputs sync pulse signals and  the coordinates of the current pixel.

Purpose: 	This module outputs the signal to the VGA device which is PC monitor in this lab, so the monitor can display graphics. 

Reference: 	From ECE385 Lab 8. 


## Description of C Program
The logic of our game is computed in the software which allows us to testing our code easier (building project in software is much faster compared to compiling the project in Quartus II).  The output PIOs can be grouped into position information, and logic information. Position information includes playerPostionX, playerPostionY, monster1PostionX, monster1PositionY, monster2PositionX, monster2PositionY, rocketX, rocketY, mapOffset. Logic information includes  playerDirection, playerAttackOn, playerHealth, monster1Alive, monster2Alive,  rocketOn, Score, Stage, and Win.   
The position information PIOs are sent to the hardware so it knows whether/ where to draw these  images on the screen. Since these X positions can be larger than the maximum screen horizontal pixel number (640),  the position of these images on the screen are obtained by position subtracting mapOffset. mapOffset increases when playerPositon is greater than an offset plus mapOffset, and it enables the screen to scroll horizontally. The background image horizontal size is  2025, thus it would be a bad idea to draw the entire background image on one screen. 
The logic information PIOs determines which image to draw on the screen .PlayerDirection can be either 0 (facing left) and 1 (facing right). We use this value to determine the corresponding player image to draw on the screen. PlayerAttackOn is 1 when player pressed the attack key ([J]), and player on the screen would have an attack animation. PlayerHealth stores the number of health, and the initial value is set to 7. The number of health is displayed on the screen. If Monster1Alive / Monster2Alive is 1, monster1/2 is displayed on the screen, and the software runs the AI for the monster.  If RocketOn is 1, rocket is displayed on the screen, and the software runs the AI for the rocket. Score store the game score in the game, and this number is displayed on the screen.. If Stage is 0, the screen displays the game start cover. If Stage is 1,  the screen displays the game. If Stage is 2, the screen displays the game over cover. If win is 1, a “mission complete” font is displayed in the center of the game, and the player image is replaced by a tank. 
	The software has several functions to help the game run correctly. stageCheck() checks stage of the game. If PlayeHealth equals 0, stage is set to 2 (game over). If PlayerPosition is greater than 1900 (player reaches the final check point), win is set to 1 (mission complete).   stage1() initializes the variables in stage 1. The variables includes playerPositionX, playerPositionY, mapOffset, floor1, floor2, score (0), monster1Alive(0), monster2Alive(0),  rocketOn(0), win(0). setMonster1(), setMonster2(), setMonster3(),  setMonster4(), setMonster5(), setMonster6() are functions which set the parameters of the monster. These includes position X/Y , center, range, alive, speed of corresponding  monster and the total number of monsters. There is one additional variable advance. If advance is 1, an advanced monster AI (the monster can jump, and takes multiple hits to die) would be running instead of an easier AI. rocket() is the AI for the rocket. The rocket moves horizontally to the right. When it hits the monster, rocketOn is set to 0. Meanwhile, monster alive is set to 0 if  advanced = 0, or monster health  decreases by 1 if advanced = 1. If a monster die, score is incremented and the number of monsters decreases by 1. RocketOn is also set to 0 when it  is outside the range of the player. M1AI()/ M2AI() is the AI for monster(easier version). Monster will drops vertically first from the sky. When the monster  reaches the floor, it starts to move horizontally inside its range. If the monster hits the player, player health is decreased by 1, and player moves backward by an offset. If the player hits the monster, monster Alive is set to 0 and score increases.  AdvanceAI() is  the advanced AI for monster. The monster can jump and has more health. Each time a player hits the monster, monster health decreases by 1. If monster health is 0, monster alive is set to 0 and score increases. 
kbInput() receives the keyboard input, and set playerDirX, playerDirY, attackOn, rocketOn based on the keyCode. playerMove() determines the movements of the player. If jump is not pressed, the player falls downward by gravity. We need to check the vertical movement of the player so he would not fall under the ground. We also check the horizontal boundary of the player so he would not move out of the screen. playerMove() also determines mapOffset so the background scrolls as player moves horizontally. In the main function, stage is initally set to 0. It will stays as 0 until [Enter] is pressed (stage = 1). When stage is 1, stage1() is called to initialize the variables. A loop inside stage 1 calls kbinput(), playerMov(), monster AI (if monster is alive ).setMonster will be called if previous monstersare all cleared  (number of monsters = 0)  and the player reaches a checkpoint. checkStage is called in the end of the loop to check if the stage is still 1. If stage is 2, it will stays in 2 until [R] is pressed to restart the game (stage = 0). 

## Conclusion
Conclusion
	This lab is the final lab of this course, and we spent four weeks to complete it. When we started this lab in week one, we thought the most challenging part is to display the images on the screen. We spent the first two week to find the images for our game and learn how to write the images into the FPGA memory. We also did some testing of the  movement of the player using  the ball from lab 8. 
In the last two weeks, we finished loading all images and the game logic code for our project. We loaded all of our images except the background onto the on chip memory. We first tried to store 24 bits (3 bits for R/G/B) for each pixel of the image, but we found out that on chip memory does not have enough space for our images. So we reduced the number of colors of each image to 8 and stores its index (3 bits )in the memory. Then we create several pallette lookup modules to restore the actual color based on the index read from the memory. We also use SRAM to store the background image for our project. We could not store it on on-chip memory because its size is too large. SRAM can store at most 16 bits on each address. So we changed the number of colors of our background image to 16, and store their indices (4 bit) in the SRAM. When we tried to display background image the first time, we could not see it successfully. We realized that there was 4050 * 480  pixels on the image which requires 1,9440, 000 addresses in the SRAM, but the SRAM has maximum of 1,000,000 addresses. So we decided to reduce our background image size to 2025 * 240. 
Each of the team member has individual work for this lab. Minghao Jiang is responsible for displaying the images/font successfully on the screen (hardware side). Xingjian Zhao is responsible for the game logic (software side). There were several other problems during this lab which requires collaboration of the two members such as which game variables are needed to set as PIOs to communicate between software and software. We also helped each other to debug since the other person can view the problem from another perspective and provide valuable ideas.  Throughout this lab, we learned how to use FPGA memory, display image and design a game using both hardware and software. We believed that we have learned the knowledge of digital computer design by attending lecture and finishing labs  this semester. 

