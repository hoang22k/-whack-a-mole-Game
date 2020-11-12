# -whack-a-mole-Game

Name: Khoa Hoang		
SID: 200 354 230 		
ENSE 352 - Term Project 
__________________________

1. What is the game?
	For this year project, we are tasked to create a whack-a-mole game.

2. How to play?
	- To play this game, there will be a random mole that will pop up, and you have to hit it before the timer runs out. For this project, the moles will be our LED's, and their corresponding switches are the 'hammer.'
	
	- The game starts in the waiting state, where there is a light pattern looping back and forth until the user presses one of the four switches to indicate that they are ready. After an input is detected, the game enters Normal Game Play state. 
	
	- In this state, a random LED (mole) comes on and the user has to hit the corresponding button for that LED. In addition, when an LED is on, there is a timer on which the user has to hit the correct switch before the time expires. If the user successfully hit the correct button before the timer runs out, the game will go to the next level, where the timer is only half of what it previously was. If the user unsuccessfully hit the correct button before the timer ends or hit the wrong button, the game will enter game failure mode. 
	
	- In the game failure mode, it will display the number of levels that were completed in binary using the 4 LED's. I have designed the game to have 16 levels, if the user successully complete all 16 levels, the game will go into 'end success' or 'won' state, where a pattern of LED's is displayed. After displaying this, it will return back to the waiting for player state. If the user is unable to complete the first level, all LED's will be turned off to represent 0. After a couple seconds, it will go back to the waiting state. 
	

3. Any information about problems encountered, features you failed to implement,
extra features you implemented beyond the basic requirements, possible future
expansion, etc.

	- The main problem that I have encountered in this project is branching out of range. When branching with condition (BEQ or BNE), the range is much less compared to BL or B {label}. I had to take out some of my BEQ/BNE, shorten up come code, as well as moving some of the subroutines around. Fortunately, I was able to implement all features without any errors. Given the time constraints, I was not able to add any extra features that are beyond the basic requirements. If I have an opportunity, I would like to implement this program in an actual whack-a-mole gaming station. 

4. How the user can adjust the game parameters, including:

(a) PrelimWait: at the beginning of a cycle, the time to wait before lighting
a LED
	- I have 2 PrelimWait in this program. One of them is placed after the game exits 'waiting' state. The purpose of this is to give the user a short delay before the first LED comes on. The next PrelimWait is called Random_PrelimWait. This is executed after the program detects a correct 'hit' from the user. The purpose of this Random_PrelimWait is to give the user a short delay before the next LED comes on. 
	- To adjust this PrelimWait, the constant is located at line 64 of the program. The constant is called PreLim_DELAYTIME.
	

(b) ReactTime, the time allowed for the user to press the correct button to
avoid terminating the game.
	- To change the parameter of the ReactTime, the constant is declared at line 69 of the program. It is called ReactTime. 
	- My program gives the user plenty of time for lower levels. However, the timer gets cut in half every level, making it difficult for the higher levels. At around level 13 and above, there is only about half a second to react. 

(c) The number of cycles in a game: NumCycles
	- To change this parameter, this can be modified at line 70 in the program. The current NumCycles is 16 (16 levels). 

(d) values of WinningSignalTime and LosingSignalTime.
	- WinningSingalTime can be modified at line 66. It is called Win_Delay in the program.
	- LosingSignalTime can be modified at line 67. It is called GAME_OVER_DELAY in the program. 
