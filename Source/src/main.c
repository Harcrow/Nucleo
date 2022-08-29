/* Main program. */

volatile uint8_t led_on;


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
	
	/************************************************
	INTERUPPRTS
	1. Enable the SYSCFG/AFIO bit in RCC register 
	2. Configure the EXTI configuration Register in the SYSCFG/AFIO
	3. Disable the EXTI Mask using Interrupt Mask Register (IMR)
	4. Configure the Rising Edge / Falling Edge Trigger
	5. Set the Interrupt Priority
	6. Enable the interrupt
	**************************************************/
	
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




