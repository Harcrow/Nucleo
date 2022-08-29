#include "nvic.h"


void EXTI15_10_IRQHandler(void) {
  if (EXTI->PR && (1 << BUTTON)) {
    // Clear the EXTI status flag.
    EXTI->PR = (1 << BUTTON);
    // Toggle the global 'led on?' variable.
    led_on = !led_on;
  }
}