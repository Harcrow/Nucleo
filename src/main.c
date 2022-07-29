/* Main program. */
#include "stm32f410rx.h"

#define BUTTON 13
#define LED 5

volatile uint8_t led_on;

void EXTI15_10_IRQHandler(void);
void clock_config(void);

int main(void) {
	led_on = 0;
	
	clock_config();
	//want to enable the button (B1 -- PC13) and the LED (LD2-- PA5)
	
	/*https://en.wikipedia.org/wiki/Advanced_Microcontroller_Bus_Architecture#:~:text=provide%20timing%20closure.-,Advanced%20High%2Dperformance%20Bus%20(AHB),-%5Bedit%5D*/
	
	//Start by enabling RCC -- Reset and Clock ctl.  Every peripheral will access the clock.
	//AHB is the 'Advanced High-performance Bus' 
	//APB is 'Advanced Peripheral Bus'
	
	//Button is pulled to VCC
	//LD2 is active high
	
	//RCC enable of APB2ENR register 
	RCC -> APB2ENR |= RCC_APB2ENR_SYSCFGEN;
	
	//RCC == reset and clock control
	RCC -> AHB1ENR |= RCC_AHB1ENR_GPIOAEN;
	RCC -> AHB1ENR |= RCC_AHB1ENR_GPIOCEN;
	
	/************************************************
	INTERUPPRTS
	1. Enable the SYSCFG/AFIO bit in RCC register 
	2. Configure the EXTI configuration Register in the SYSCFG/AFIO
	3. Disable the EXTI Mask using Interrupt Mask Register (IMR)
	4. Configure the Rising Edge / Falling Edge Trigger
	5. Set the Interrupt Priority
	6. Enable the interrupt
	**************************************************/
	
	
	//setting output pushpull mode of PA5
	
	GPIOA -> MODER &= ~(0x3 << (LED*2));
	GPIOA -> MODER |= (0x1 << LED*2);
	GPIOA -> OTYPER &= ~(1 << LED);
	
	//Setting input with no PU on PC14
	GPIOC -> MODER &= ~(0x3 << (BUTTON*2));
	GPIOC -> PUPDR &=  ~(0x3 << (BUTTON*2));
	GPIOC -> PUPDR &= (0x0 << (BUTTON*2));
	
	//maps interrupt to pin
	//SYSCFG -> EXTICR[3] &= ~(SYSCFG_EXTICR4_EXTI13_Msk);
	//SYSCFG -> EXTICR[3] |= (SYSCFG_EXTICR4_EXTI13_PC);
	
	SYSCFG->EXTICR[(BUTTON/4)] &= ~(0xF << ((BUTTON% 4) * 4));
	SYSCFG->EXTICR[(BUTTON/4)] |=  (0x2 << ((BUTTON% 4) * 4));

	
	//GPIOA->ODR |= (1 << LED);
	
	//Setup buttons EXTI line as interuppt
	EXTI -> IMR |= (1 << BUTTON);
	//disables the rising edge trigger
	EXTI -> RTSR &= ~(1 << BUTTON);
	//enables the falling edge trigger
	EXTI -> FTSR |= (1 << BUTTON);
	
	//Sets nested vector interrupt controller
	NVIC_SetPriority(EXTI15_10_IRQn, 0x03);
	NVIC_EnableIRQ(EXTI15_10_IRQn);

	while (1) {
    if (led_on) {
      GPIOA -> ODR |= (1 << LED);
    }
    else {
      GPIOA -> ODR &= ~(1 << LED);
    }
  }
}



void EXTI15_10_IRQHandler(void) {
  if (EXTI->PR && (1 << BUTTON)) {
    // Clear the EXTI status flag.
    EXTI->PR = (1 << BUTTON);
    // Toggle the global 'led on?' variable.
    led_on = !led_on;
  }
}

