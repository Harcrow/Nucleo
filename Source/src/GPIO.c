#include "GPIO.h"

#define INPUT 0
#define GENERAL_PURPOSE 1
#define ALTERNATE 2
#define ANALOG 3
#define PUSH_PULL 0
#define OPEN_DRAIN 1

int pinMode(PORT, PIN, MODE){

	RCC -> APB2ENR |= RCC_APB2ENR_SYSCFGEN;
	if(port == GPIOA){
		RCC -> AHB1ENR |= RCC_AHB1ENR_GPIOAEN;
	}
	if(port == GPIOB){
		RCC -> AHB1ENR |= RCC_AHB1ENR_GPIOBEN;
	}
	if(port == GPIOC){
		RCC -> AHB1ENR |= RCC_AHB1ENR_GPIOCEN;
	}
	
	//RCC enable of APB2ENR register 
	
	
	//RCC == reset and clock control
	
	
	
	
	
	
	//setting output pushpull mode of PA5
	
	GPIOA -> MODER &= ~(0x3 << (LED*2));
	GPIOA -> MODER |= (0x1 << LED*2);
	GPIOA -> OTYPER &= ~(1 << LED);
	
	//Setting input with no PU on PC14
	GPIOC -> MODER &= ~(0x3 << (BUTTON*2));
	GPIOC -> PUPDR &=  ~(0x3 << (BUTTON*2));
	GPIOC -> PUPDR &= (0x0 << (BUTTON*2));
