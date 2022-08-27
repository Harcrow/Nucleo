#include "GPIO.h"

//MODER settings
#define INPUT 0
#define OUTPUT 1

#define PUSH_PULL 0 
#define OPEN_DRAIN 1



int setDigitalOutput(PORT, PIN, MODE){

	//RCC enable of APB2ENR register 
	RCC -> APB2ENR |= RCC_APB2ENR_SYSCFGEN;
	
	if(PORT == PORT_A){
		//enable RCC clock for PORT A
		RCC -> AHB1ENR |= RCC_AHB1ENR_GPIOAEN;
		
		//Resetting the two MODER bits (generally doesn't have to happen with single bit registers)
		GPIOA -> MODER &= (INPUT << PIN*2);
	
		GPIOA -> MODER |= (OUTPUT << PIN*2);
		GPIOA -> OTYPER &= (MODE << PIN);
		
	}
	if(port == PORT_B){
		RCC -> AHB1ENR |= RCC_AHB1ENR_GPIOBEN;
		//enable RCC clock for PORT A
		
		GPIOB -> MODER &= (INPUT << PIN*2);
		
		GPIOB -> MODER |= (OUTPUT << PIN*2);
		GPIOB -> OTYPER &= (MODE << PIN);
		
	}
	if(port == PORT_C){
		RCC -> AHB1ENR |= RCC_AHB1ENR_GPIOCEN;
		
		GPIOC -> MODER &= (INPUT << PIN*2);
		
		GPIOC -> MODER |= (OUTPUT << PIN*2);
		GPIOC -> OTYPER &= (MODE << PIN);
		
	}
	
int setDigitalInput(PORT, PIN, 
	
	
	//RCC == reset and clock control
	
	//setting output pushpull mode of PA5
	
	GPIOA -> MODER &= ~(0x3 << (LED*2));
	GPIOA -> MODER |= (0x1 << LED*2);
	GPIOA -> OTYPER &= ~(1 << LED);
	
	//Setting input with no PU on PC14
	GPIOC -> MODER &= ~(0x3 << (BUTTON*2));
	GPIOC -> PUPDR &=  ~(0x3 << (BUTTON*2));
	GPIOC -> PUPDR &= (0x0 << (BUTTON*2));
