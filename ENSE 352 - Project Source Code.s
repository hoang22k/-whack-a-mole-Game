;;______________________________________
;;
;; Name: Khoa Hoang
;; SID: 200 354 230 
;; ENSE 350 Term Project  				
;;______________________________________

;; GPIO Test program - Dave Duguid, 2011
;; Modified Trevor Douglas 2014

;;; Directives
            PRESERVE8
            THUMB       
        		 
;;; Equates

INITIAL_MSP	EQU		0x20001000	; Initial Main Stack Pointer Value

;PORT A GPIO - Base Addr: 0x40010800
GPIOA_CRL	EQU		0x40010800	; (0x00) Port Configuration Register for Px7 -> Px0 
GPIOA_CRH	EQU		0x40010804	; (0x04) Port Configuration Register for Px15 -> Px8 
GPIOA_IDR	EQU		0x40010808	; (0x08) Port Input Data Register 
GPIOA_ODR	EQU		0x4001080C	; (0x0C) Port Output Data Register 
GPIOA_BSRR	EQU		0x40010810	; (0x10) Port Bit Set/Reset Register 
GPIOA_BRR	EQU		0x40010814	; (0x14) Port Bit Reset Register 
GPIOA_LCKR	EQU		0x40010818	; (0x18) Port Configuration Lock Register 
 
;PORT B GPIO - Base Addr: 0x40010C00 
GPIOB_CRL	EQU		0x40010C00	; (0x00) Port Configuration Register for Px7 -> Px0 
GPIOB_CRH	EQU		0x40010C04	; (0x04) Port Configuration Register for Px15 -> Px8 
GPIOB_IDR	EQU		0x40010C08	; (0x08) Port Input Data Register 
GPIOB_ODR	EQU		0x40010C0C	; (0x0C) Port Output Data Register 
GPIOB_BSRR	EQU		0x40010C10	; (0x10) Port Bit Set/Reset Register 
GPIOB_BRR	EQU		0x40010C14	; (0x14) Port Bit Reset Register 
GPIOB_LCKR	EQU		0x40010C18	; (0x18) Port Configuration Lock Register 
 
;The onboard LEDS are on port C bits 8 and 9 
;PORT C GPIO - Base Addr: 0x40011000 
GPIOC_CRL	EQU		0x40011000	; (0x00) Port Configuration Register for Px7 -> Px0 
GPIOC_CRH	EQU		0x40011004	; (0x04) Port Configuration Register for Px15 -> Px8 
GPIOC_IDR	EQU		0x40011008	; (0x08) Port Input Data Register 
GPIOC_ODR	EQU		0x4001100C	; (0x0C) Port Output Data Register 
GPIOC_BSRR	EQU		0x40011010	; (0x10) Port Bit Set/Reset Register 
GPIOC_BRR	EQU		0x40011014	; (0x14) Port Bit Reset Register 
GPIOC_LCKR	EQU		0x40011018	; (0x18) Port Configuration Lock Register 
 
;Registers for configuring and enabling the clocks 
;RCC Registers - Base Addr: 0x40021000 
RCC_CR			EQU		0x40021000	; Clock Control Register 
RCC_CFGR		EQU		0x40021004	; Clock Configuration Register 
RCC_CIR			EQU		0x40021008	; Clock Interrupt Register 
RCC_APB2RSTR	EQU		0x4002100C	; APB2 Peripheral Reset Register 
RCC_APB1RSTR	EQU		0x40021010	; APB1 Peripheral Reset Register 
RCC_AHBENR		EQU		0x40021014	; AHB Peripheral Clock Enable Register 
 
RCC_APB2ENR	EQU		0x40021018	; APB2 Peripheral Clock Enable Register  -- Used 
 
RCC_APB1ENR	EQU		0x4002101C	; APB1 Peripheral Clock Enable Register 
RCC_BDCR	EQU		0x40021020	; Backup Domain Control Register 
RCC_CSR		EQU		0x40021024	; Control/Status Register 
RCC_CFGR2	EQU		0x4002102C	; Clock Configuration Register 2 

; Times for delay routines
        
PreLim_DELAYTIME	EQU	1600000		; (200 ms/24MHz PLL) 
DELAYTIME_WAIT 		EQU 150000
Win_Delay 			EQU 200000
GAME_OVER_DELAY		EQU 1600000
RandomSeed			EQU 0x39484157
ReactTime 			EQU 0x6B009400
NumCycles 			EQU 16	
	
; Vector Table Mapped to Address 0 at Reset 
            AREA    RESET, Data, READONLY 
            EXPORT  __Vectors 
 
__Vectors	DCD		INITIAL_MSP			; stack pointer value when stack is empty 
        	DCD		Reset_Handler		; reset vector 
			 
            AREA    MYCODE, CODE, READONLY 
			EXPORT	Reset_Handler 
			ENTRY 
 
Reset_Handler		PROC 
 
		BL GPIO_ClockInit 			;; Clock initialization
		BL GPIO_init 				;; Ports init
	 
mainLoop 
		ldr r7, =RandomSeed			;; Initializing the seed
		
		;; Note that we don't need to code UC1
		;; because the Reset button is built in. We need to press reset after
		;; loading the project 
		
		BL wait_UC2
		
		;bl random
		;B	mainLoop 
		ENDP 
			
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	This routine will enable the clock for the Ports 
;;	For this project, Ports A, B and C are needed
;; 		- Port A: Bit 2
;;		- Port B: Bit 3
;; 		- Port C: Bit 4
;;		

	ALIGN 
GPIO_ClockInit PROC 
 	
	LDR r4, =RCC_APB2ENR	; clock intialization
	MOV r1, #0x1c			
	STR r1, [r4]			; Store bits 2,3, and 4 into r4 
	 
	BX LR 
	ENDP 
		 
	 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	 
;;	This routine enables the GPIO for the LED's.  
;; 	The LED's on the board are on PA 9, 10, 11, and 12
;; 		- We want the LED's to be output -> MODE: 11
;;		- and it is general purpose output push-pull -> CNF: 00
;;		- Therefore, 0011 = 3 for each LED

	ALIGN 
GPIO_init  PROC 
	
	ldr r7, =GPIOA_CRH		
	ldr r12, =0x44433334
	str r12,[r7]
	
    BX LR 
	ENDP 
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	Purpose: 
;;		UC2 Waiting for Player: Display light pattern
;;		Check for user input to start the game
;;		Subtract the seed (R7) based on how long the game is in waiting state
;;	Notes:	
;;		* During the light pattern loopings, this subroutine is also
;;		calling another function to detect if there is an input. If
;;		an input is detected, the game will go into PreLimWait, then Normal Game Play 
;;
;;		* When this patern is looping, it is also subtracting the seed amount.
;;		This number will be random because it depends on how long the user let 
;;		the game stay in Wait state. 

		
wait_UC2 PROC					
	ldr r1, =GPIOA_ODR					;; R1 is the output register
	ldr r11, =DELAYTIME_WAIT			;; Declare delay time
	
first_led								 
	mov r0,#0x200						;; My light pattern is 
	str r0, [r1]						;; Led 1 OFF, Led 2, 3, 4 ON
	sub r11, #1					 		
	cmp r11, #0
	bne first_led						;; Subtract and loop until Delay time is over
	ldr r11, =DELAYTIME_WAIT	
	
second_led
	mov r0, #0x400						;; Second LED: LED 2 OFF, LED 1, 3, 4: ON
	str r0, [r1]				
	sub r11, #1					
	cmp r11, #0
	bne second_led				
	ldr r11, =DELAYTIME_WAIT
	
third_led
	mov r0, #0x800						;; Third LED: LED 3 OFF, LED 1, 2, 4: ON
	str r0, [r1]				
	sub r11, #1					
	cmp r11, #0
	bne third_led
	ldr r11, =DELAYTIME_WAIT
		
fourth_led
	mov r0, #0x1000						;; Fourth LED: LED 4 OFF, LED 1, 2, 3: ON
	str r0, [r1]				
	sub r11, #1					
	cmp r11, #0
	bne fourth_led	
					
	bl start							;; Branch to start to check for user input
	sub r7, #4							;; Subtract the seed
	b wait_UC2							;; Branch back to WAIT mode if input not found 
	ENDP	
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 	Purpose:
;;		Check for user input during WAIT mode
;; 			R4 = Green Button (SW5) - PA5
;;			R5 = Red and Black Buttons (SW 2 & 3) - PB 8 & PB 9
;;			R6 = Blue button (SW 4) - PC12
;;		If a button is pressed, go to PrelimWait then Normal Game
;;		Button not pressed, return to WAIT mode 
;;
;;	Notes: 
;; 		* Our switches are active low, so when a button is pressed,
;;		the corresponding bit will be 0. 
;; 		* SW 5: XXXX XXXX XX1X XXXX	(bit 5)
;;		* SW 4: XXX1 XXXX XXXX XXXX	(bit 12)
;; 		* SW 3: XXXX XX1X XXXX XXXX	(bit 9)
;;		* SW 2: XXXX XXX1 XXXX XXXX (bit 8)
		
start PROC
	
	ldr r1, =GPIOA_IDR		;; R1 = input at port A
	ldr r2, =GPIOB_IDR		;; R2 = input at port B
	ldr r3, =GPIOC_IDR		;; R3 = input at port C

	ldr r4, [r1]			;; R4 = input at SW 5 (Green) - PA5
	and r4, #0x20			;; Extract bit 5 by ANDing it with #0x20
	
	ldr r5, [r2]			;; R5 = input at SW 2 & SW 3 (Red & Black ) - PA 8 & PA9
	and r5, #0x300			;; Extract bit 8 and 9
	
	ldr r6, [r3]			;; R6 = input at SW 4 (Blue) - PC 12
	and r6, #0x1000			;; Extract bit 12 
	
	orr r5, r4				;; Adding all the inputs together
	orr r6, r5	
	cmp r6, #0x1320			;; Comparing the result with #0x1320, which is the value if
							;; no buttons are pressed. If the result is something other than #0x1320, 
							;; that means one of the buttons are pressed.
	bne PrelimWait			;; Go to PrelimWait if (result != #0x1320); Else, return to WAIT
	bx lr 					 
	ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	Purpose: 
;;		Give the game a delay time before the first random LED turns on
;;	Notes:
;;		* Passing 1's to the output will turn off the LED's because
;;		LED's are active low
		
PrelimWait PROC				
	ldr r9, =GPIOA_ODR		;; R9 = Output
	mov r12, #0xFFFF		;; R12 = 0xFFFF (all 1's)
	str r12, [r9]			;; Pass R12 into R9 (Output) to turn off LED's
	ldr r12, =PreLim_DELAYTIME
PrelimWait_loop
	sub r12, #1				;; Decrement DELAYTIME 
	cmp r12, #0
	bne PrelimWait_loop		;; When DELAYTIME = 0; start Normal Game
	
	ENDP	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	Purpose:
;; 		Turn on a random LED 
;; 		
;;	Notes:
;; 		* This is the Normal Game Play State
;;		* My RANDOM subroutine is used to turn on a random LED
;;		* The method used for random number is Linear Congruential Generator (LCG) 
;;		where the general formula is Xn+1 = a*Xn + c (MOD 4).
;; 			- Xn is the "seed"				
;;			- a & c are selected constants
;;			- Modulus of 4 to get 4 different results corresponding to 4 LED's
;; 			- The computed result is the next seed for next round 
;;		* Based on the computed result, the corresponding LED will turn on 
;; 			- R7 = First seed 
;;			- R3 = Seed for round 2 and above

random proc
	mov r3, r7				;; R3 = R7 ; R7 is the first seed from the WAIT mode
	mov r10, #0				;; R10 = NumCycles (Level)
	ldr r12, =ReactTime		;; R12 = ReactTime ; React Time = 0x8B009400 ~ 10920 Seconds 

random_generator

	mov r4, #4567			;; R4 = Constant A
	mov r5, #8901			;; R5 = Constant C
	
	ldr r9, =GPIOA_ODR		;; R9 = Output 
	
	mul r1, r4, r3			;; R1 = a * Seed
	add r1, r1, r5			;; R1 = a * Seed + C
	
	lsr r8, r1, #2			;; R1 = R1 / 4

	mov r0, r8				;; R0 = R8 ; R0 is a temporary register 
		
	and r8, #3				;; Extract the last 2 bits of R8
	
	cmp r8, #0				;; If R8 = 0, turn on LED_4
	beq led_4				
	
	cmp r8, #1				;; If R8 = 1, turn on LED_3
	beq led_3
	
	cmp r8, #2				;; If R8 = 2, turn on LED_2
	beq led_2
	
	cmp r8, #3				;; If R8 = 3, turn on LED_1
	beq led_1
	endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	Purpose:
;; 		Detect input when after a random LED is lit 
;; 		Same concept with the "Start" subroutine from above
;;	Notes:
;;		* This subroutine is called after an LED is lit
;; 		* This subroutine is called in led_1, led_2, led_3, and led_4
;; 

check_input proc
	ldr r1, =GPIOA_IDR
	ldr r2, =GPIOB_IDR
	ldr r3, =GPIOC_IDR

	ldr r4, [r1]
	and r4, #0x20
	
	ldr r5, [r2]
	and r5, #0x300
	
	ldr r6, [r3]
	and r6, #0x1000
	
	orr r5, r4
	orr r6, r5
	
	bx lr
	endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	Purpose: 
;;		Display the NumCycles (levels) the user has passed
;;		After displaying the NumCycles, go back to WAIT state 
;;		Reverse the order of the NumCycles to display it 
;;	Notes: 
;;		* R10 is where I increment and store the NumCycles
;;		* Since the LED's are active low, and the order of the LED's on the board 
;;		is reversed;
;;		* To display the result correctly, I took the 1's complement of R10
;;		and store it in R0, then I extracted each bit and switch their position.
;;		After their positions are swapped, I added them together. Finally, shift them
;;		by 9 to the left because the first bit of the LED starts at bit 9
;;		
;;		* If user did not pass level 1, the NumCycles = 0 (All LED's OFF)
;; 		* If user passes level 16, user wins the game
;;		* If user fail between level 1-15; the level will be displayed in binary 

game_over proc
	ldr r12, =GAME_OVER_DELAY
game_over_loop
	sub r12, #1			;; Subtract the DELAYTIME
	mvn r0, r10			;; Take the 1's complement of R10 and store it in R0
	
	and r2, r0, #1		;; Extract bit 0 
	lsl r2, #3			;; and shift left to bit 3
	
	and r3, r0,#2		;; Extract bit 1
	lsl r3, #1			;; and shift left to bit 2
	
	and r4, r0,#4		;; Extract bit 2
	lsr r4, #1			;; and shift right to bit 1
	
	and r5, r0,#8		;; Extract bit 3
	lsr r5, #3			;; and shift right to bit 0
	
	orr r4,r5			;; R4 = R4 + R5
	orr r3,r4			;; R3 = R3 + r4
	orr r2, r3			;; R2 = R2 + R3
	mov r0, r2			;; R0 = R2
	
	lsl r0, #9			;; Left shift the result to the left 9 times because the LED's 
						;; starts at bit 9
	ldr r9, =GPIOA_ODR	;; R9 = Output
	str r0, [r9]		;; Store the result into the output 
	cmp r12, #0			;; Keep looping the store until the time runs out
	bne game_over_loop	
	b wait_UC2			;; When the time runs out, go back to WAIT mode
	endp
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	Purpose: 
;;		* Turn on LED_4
;; 		* Check if there is an input detected before ReactTime expires
;;		* Check detected input is right or wrong
;;			- If right input, go to HIT subroutine
;;			- If wrong input, go to GAME_OVER 
;;			- If ReactTime runs out, go to GAME_OVER
;;
;;	Notes:
;;		* In HIT subroutine: increase NumCycles (Level), decrease ReactTime, and then another random LED
;;		* In GAME_OVER subroutine: display the level completed, then go back to WAIT mode
;;		* Switches and LED's are active LOW
;;		* R6 = the result of the input (check_input subroutine) 
;;		* R9 = Output 
;; 		* #0x1300 is the result when the wrong buttons are not pressed (they are still 1)
;; 		* LED 4 = SW 5
		
led_4 proc
	mov r11, #0x0e00			;; Turn ON LED 4 (bit 12) - 0000 1110 0000 0000 
	str r11, [r9]				;; Pass result to R9, which is the Output 
led_4_loop
	sub r12, #1					;; Subtract the ReactTime
	
	bl check_input 				;; Check for CORRECT input 
	and r7, r6, #0x20			;; R7 = R6 && #0x20 ; To extract bit 5
	cmp r7, #0					;; If bit 5 is 0, then a correct input is dectected
	beq hit 					;; Go to HIT if bit 5 is 0
	
	and r6, #0x1300				;; Check for WRONG input
	cmp r6, #0x1300				;; If R6 is not equal to #0x1300, that means a wrong button 
	bne game_over				;; is pressed. Go to game_over if this is the case
								;; 
	
	cmp r12, #0					;; If ReactTime = 0, then go to game_over
	bne led_4_loop				;; Else keep looping led_4_loop
	bl game_over

	endp
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	Purpose: 
;;		Turn on LED_3
;; 		Check if there is an input detected before ReactTime expires
;;		Check detected input is right or wrong
;;		- If right input, go to HIT subroutine
;;		- If wrong input, go to GAME_OVER 
;;		- If ReactTime runs out, go to GAME_OVER
;;
;;	Notes:
;;		* In HIT subroutine: increase NumCycles (Level), decrease ReactTime, and then another random LED
;;		* In GAME_OVER subroutine: display the level completed, then go back to WAIT mode
;;		* R6 = the result of the input 
;; 		* R9 = Output 
;;		* LED 3 = SW 4
		
led_3 proc
	
	mov r11, #0x1600			;; Turn on LED 3 at bit 11 - 0001 0110 0000 0000 
	str r11, [r9]				;; Store R11 to R9
led_3_loop
	sub r12, #1					;; Subtract the ReactTime
	bl check_input				;; Check for input 
	
	and r7, r6, #0x1000			;; Extract bit 12 from the input result
	cmp r7, #0					;; If R7 = 0; correct input is detected 
	beq hit						;; Branch to HIT if correct input is detected
	
	and r6, #0x320				;; Check other bits (bit 9, bit 8, and bit 5)
	cmp r6, #0x320				;; If one of the bits is not 0, then go to game_over
	bne game_over
	
	cmp r12, #0					;; If ReactTime runs out, go to game_over
	bne led_3_loop				;; else, keep looping
	bl game_over
	endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	Purpose: 
;;		Turn on LED_2
;; 		Check if there is an input detected before ReactTime expires
;;		Check detected input is right or wrong
;;		- If right input, go to HIT subroutine
;;		- If wrong input, go to GAME_OVER 
;;		- If ReactTime runs out, go to GAME_OVER
;;
;;	Notes:
;;		* In HIT subroutine: increase NumCycles (Level), decrease ReactTime, and then another random LED
;;		* In GAME_OVER subroutine: display the level completed, then go back to WAIT mode
;;		* R6 = the result of the input 
;; 		* R9 = Output 
;; 		* LED 2 = SW 3
;;		

led_2 proc
	mov r11, #0x1a00			;; Turn on LED 2 at bit 10 - 0001 1010 0000 0000 
	str r11, [r9]				;; Store result into the Output (R9)
led_2_loop
	sub r12, #1					;; Subtract the ReactTime 
	bl check_input				;; Check for input 
	
	and r7, r6, #0x200			;; Check for correct input by extracting bit 9
	cmp r7, #0					;; If result = 0; correct input detected 
	beq hit						;; Branch to HIT if right
	
	and r6, #0x1120				;; Check for wrong inputs
	cmp r6, #0x1120				;; If anyother bits are set, which means a wrong input is detected
	bne game_over				;; Branch to game_over if wrong input is detected

	cmp r12, #0					;; Compare if ReactTime runs out 
	bne led_2_loop				;; If ReactTime runs out, go to game over
	bl game_over				;; Else, go back go to led_2_loop
	endp
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	Purpose: 
;;		Turn on LED_1
;; 		Check if there is an input detected before ReactTime expires
;;		Check detected input is right or wrong
;;		- If right input, go to HIT subroutine
;;		- If wrong input, go to GAME_OVER 
;;		- If ReactTime runs out, go to GAME_OVER
;;
;;	Notes:
;;		* In HIT subroutine: increase NumCycles (Level), decrease ReactTime, and then another random LED
;;		* In GAME_OVER subroutine: display the level completed, then go back to WAIT mode
;;		* R6 = the result of the input 
;; 		* R9 = Output 
;;		* LED 1 = SW 2	

led_1 proc
	mov r11, #0x1c00			;; Turn on LED 1 at bit 9 - 0001 1100 0000 0000 
	str r11, [r9]				;; Store result into the Output 
led_1_loop
	sub r12,#1					;; Decrement the ReactTime
	bl check_input 				;; Branch to check for input 
	
	and r7, r6, #0x100			;; Extract bit 8 from input result
	cmp r7, #0					;; If bit 8 = 0 -> correct input detected -> go to HIT
	beq hit						;; 
	
	and r6, #0x1220				;; Check for wrong input 
	cmp r6, #0x1220				;; If sum of input != #0x1220 -> game_over
	bne game_over	
	
	cmp r12, #0					;; Check if ReactTime runs out
	bne led_1_loop				;; If ReactTime runs out -> go to game_over
	bl game_over				;; Else, branch back to led_1
	endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	Purpose:
;;		Indicate that the user has won the game by flashing LED 1 & 3 then LED 2 & 4
;;		Go back to WAIT mode after flashing the winning signal 10 times
;;	Notes:
;;		R8 = Number of winning signal flashes
;;		R9 = Output 
;;		R12 = Winning signal time
;; 		
won PROC			
	mov r8, #10							;; Number of winning cycles
	ldr r9, =GPIOA_ODR					
won_loop
	ldr r12, =Win_Delay					
won_loop1
	mov r11, #0x1400					;; 0001 0100 0000 0000 = LED 1 & 3
	str r11, [r9]						;; Turn on LED 1 & 3 
	sub r12, #1							;; Decrement delay time
	cmp r12,#0							
	bne won_loop1						;; Branch back to won_loop_1 if delay time is not over
	ldr r12, =Win_Delay					
won_loop2
	mov r11, #0x0a00					;; 0000 1010 0000 0000 = LED 2 & 4
	str r11, [r9]						;; Turn on LED 2 & 4
	sub r12, #1							;; Decrement delay time
	
	cmp r12, #0							;; Check if LED loop is over
	bne won_loop2						;;
	sub r8, #1							;; Check if 10 cycles have been completed
	cmp r8, #0							;;
	
	beq goback
	bne won_loop
	endp
		
goback
	b wait_UC2							;; Go back to WAIT once finish with winning signal 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	Purpose:
;;		Turn off all LED's after a correct HIT is detected
;;		Give a delay time before the next random LED is lit 
;;	Notes:
;;		This is very similar to the PrelimWait loop done above 
;;		R9 = Output

Random_PrelimWait PROC
	mov r12, #0xffff				;; Turn off all LED's by passing 1's to output
	str r12, [r9]
	ldr r12, =PreLim_DELAYTIME
Random_PrelimWait_loop
	sub r12, #1
	cmp r12, #0
	bne Random_PrelimWait_loop
	BX LR
	ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	Purpose: 
;;		Increase and keep track of NumCycles (levels)
;; 		Check if user has won the game
;;		Reduce ReactTime 
;; 		Update the new "seed"
;;	Notes:
;; 		* This game has 16 levels
;; 		* R0 was the temporary register to hold the first result
;; 			- R3 will be used as the seed for round 2 or greater
;;		* R12 = ReactTime 

hit PROC
	push{r12}					;; Push the current ReactTime on SP
	BL Random_PrelimWait		;; Branch to Random_PrelimWait
	pop{r12}					;; Pop R12 back (I did this because I used R12 in Random_PrelimWait)
	
	ldr r11, =NumCycles			;; load R11 with the NumCycles
	add r10, #1					;; Increment level
	cmp r10, r11				;; Check if the user has won the game 
	beq won						;; Branch to won if user beats the game
	
	;mov32 r11, #213333
	;sub r12, r11				;; Reduce the ReactTime 
	
	lsr r12, #1					;; Reduce the ReactTime (divide it by 2)
	mov r3, r0					;; Update the seed
	BL random_generator			;; Return to the Random Generator number 
	ENDP


	ALIGN 
	END 