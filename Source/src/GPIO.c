#include "GPIO.h"

//MODER settings
#define INPUT 0
#define OUTPUT 1

#define PUSH_PULL 0 
#define OPEN_DRAIN 1

#define LOW 0
#define HIGH 1

#define FLOAT 0
#define PULL_UP 1
#define PULL_DOWN 2

int setDigitalOutput(PORT, PIN, MODE){

	//RCC enable of APB2ENR register 
	RCC -> APB2ENR |= RCC_APB2ENR_SYSCFGEN;
	
	switch(PORT){
		
		case 'A':
			//enable RCC clock for PORT A
			RCC -> AHB1ENR |= RCC_AHB1ENR_GPIOAEN;
			
			//Resetting the two MODER bits (generally doesn't have to happen with single bit registers)
			GPIOA -> MODER &= (INPUT << PIN*2);
			GPIOA -> MODER |= (OUTPUT << PIN*2);
			
			GPIOA -> OTYPER &= (MODE << PIN);
			
			break;
		
		case 'B':
			//enable RCC clock for PORT B
			RCC -> AHB1ENR |= RCC_AHB1ENR_GPIOBEN;
			//enable RCC clock for PORT A
			
			//Resetting the two MODER bits (generally doesn't have to happen with single bit registers)
			GPIOB -> MODER &= (INPUT << PIN*2);
			GPIOB -> MODER |= (OUTPUT << PIN*2);
			
			GPIOB -> OTYPER &= (MODE << PIN);
			
			break;
		
		case 'C':
			//enable RCC clock for PORT C
			RCC -> AHB1ENR |= RCC_AHB1ENR_GPIOCEN;
			
			//Resetting the two MODER bits (generally doesn't have to happen with single bit registers)
			GPIOC -> MODER &= (INPUT << PIN*2);
			GPIOC -> MODER |= (OUTPUT << PIN*2);
			
			GPIOC -> OTYPER &= (MODE << PIN);
			
			break;
		default:
		
	}
	return 1;
}
	
int setOutputState(PORT, PIN, STATE){
	if(PORT == 'A'){
		if(STATE == HIGH){
			GPIOA -> ODR |= (HIGH << PIN);
		}
		if(STATE == LOW){
			GPIOA -> ODR |= ( LOW` << PIN);
		}
	}
	if(PORT == 'B'){
		if(STATE == HIGH){
			GPIOB -> ODR |= (HIGH << PIN);
		}
		if(STATE == LOW){
			GPIOB -> ODR |= ( LOW << PIN);
		}
	}
	if(PORT == 'C'){
		if(STATE == HIGH){
			GPIOC -> ODR |= (HIGH << PIN);
		}
		if(STATE == LOW){
			GPIOC -> ODR |= ( LOW << PIN);
		}
	}
}

int setDigitalInput(PORT, PIN, MODE){
	switch(PORT){
		
		case 'A':
			//enable RCC clock for PORT A
			RCC -> AHB1ENR |= RCC_AHB1ENR_GPIOAEN;
			
			//Resetting the two MODER bits (generally doesn't have to happen with single bit registers)
			GPIOA -> MODER &= (INPUT << PIN*2);
			
			GPIOA -> PUPDR &= (MODE << PIN);
			
			break;
		
		case 'B':
			//enable RCC clock for PORT B
			RCC -> AHB1ENR |= RCC_AHB1ENR_GPIOBEN;
			//enable RCC clock for PORT A
			
			//Resetting the two MODER bits (generally doesn't have to happen with single bit registers)
			GPIOB -> MODER &= (INPUT << PIN*2);
			
			GPIOB -> OTYPER &= (MODE << PIN);
			
			break;
		
		case 'C':
			//enable RCC clock for PORT C
			RCC -> AHB1ENR |= RCC_AHB1ENR_GPIOCEN;
			
			//Resetting the two MODER bits (generally doesn't have to happen with single bit registers)
			GPIOC -> MODER &= (INPUT << PIN*2);
			
			GPIOC -> OTYPER &= (MODE << PIN);
			
			break;
		default:
		
	}
	return 1;
}

int readDigitalInput(PORT, PIN){
	
	switch(PORT){
		case 'A':
			return (GPIOA -> IDR & (1 << PIN));
			break;
		case 'B':
			return (GPIOB -> IDR & (1 << PIN));
			break;
		case 'C':
			return (GPIOC -> IDR & (1 << PIN));
				
