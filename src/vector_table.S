/*
 * Test program to boot an STM32 chip with the absolute
 * minimum required code for teaching about the chips.
 *
 * Copyright William Ransohoff, Vivonomicon, LLC, 2017
 *
 * Open source under the MIT License
 */

.syntax unified
.cpu cortex-m4
.fpu softvfp
.thumb

.global vtable
.global default_interrupt_handler

/* start address for the initialization values of the .data section. 
defined in linker script */
.word  _sidata
/* start address for the .data section. defined in linker script */
.word  _sdata
/* end address for the .data section. defined in linker script */
.word  _edata
/* start address for the .bss section. defined in linker script */
.word  _sbss
/* end address for the .bss section. defined in linker script */
.word  _ebss
/* stack used for SystemInit_ExtMemCtl; always internal RAM used */


    .section  .text.Reset_Handler
  .weak  Reset_Handler
  .type  Reset_Handler, %function
Reset_Handler:  
  ldr   sp, =_estack       /* set stack pointer */

/* Copy the data segment initializers from flash to SRAM */
  movs  r1, #0
  b  LoopCopyDataInit

CopyDataInit:
  ldr  r3, =_sidata
  ldr  r3, [r3, r1]
  str  r3, [r0, r1]
  adds  r1, r1, #4
    
LoopCopyDataInit:
  ldr  r0, =_sdata
  ldr  r3, =_edata
  adds  r2, r0, r1
  cmp  r2, r3
  bcc  CopyDataInit
  ldr  r2, =_sbss
  b  LoopFillZerobss
/* Zero fill the bss segment. */
FillZerobss:
  movs  r3, #0
  str  r3, [r2], #4
    
LoopFillZerobss:
  ldr  r3, = _ebss
  cmp  r2, r3
  bcc  FillZerobss

/* Call the applications entry point.*/
  bl  main
  bx  lr    
.size  Reset_Handler, .-Reset_Handler

/**
 * @brief  This is the code that gets called when the processor receives an 
 *         unexpected interrupt.  This simply enters an infinite loop, preserving
 *         the system state for examination by a debugger.
 * @param  None     
 * @retval None       
*/
    .section  .text.Default_Handler,"ax",%progbits
Default_Handler:
Infinite_Loop:
  b  Infinite_Loop
  .size  Default_Handler, .-Default_Handler

/*
 * The vector table.
 */
.type vtable, %object
.section .vector_table,"a",%progbits
vtable:
  .word  _estack
  .word  Reset_Handler
  .word  NMI_Handler
  .word  HardFault_Handler
  .word  MemManage_Handler
  .word  BusFault_Handler
  .word  UsageFault_Handler
  .word  0
  .word  0
  .word  0
  .word  0
  .word  SVC_Handler
  .word  DebugMon_Handler
  .word  0
  .word  PendSV_Handler
  .word  SysTick_Handler

  /* External Interrupts */
  .word     WWDG_IRQHandler                   /* Window WatchDog                             */
  .word     PVD_IRQHandler                    /* PVD through EXTI Line detection             */
  .word     TAMP_STAMP_IRQHandler             /* Tamper and TimeStamps through the EXTI line */
  .word     RTC_WKUP_IRQHandler               /* RTC Wakeup through the EXTI line            */
  .word     FLASH_IRQHandler                  /* FLASH                                       */
  .word     RCC_IRQHandler                    /* RCC                                         */
  .word     EXTI0_IRQHandler                  /* EXTI Line0                                  */
  .word     EXTI1_IRQHandler                  /* EXTI Line1                                  */
  .word     EXTI2_IRQHandler                  /* EXTI Line2                                  */
  .word     EXTI3_IRQHandler                  /* EXTI Line3                                  */
  .word     EXTI4_IRQHandler                  /* EXTI Line4                                  */
  .word     DMA1_Stream0_IRQHandler           /* DMA1 Stream 0                               */
  .word     DMA1_Stream1_IRQHandler           /* DMA1 Stream 1                               */
  .word     DMA1_Stream2_IRQHandler           /* DMA1 Stream 2                               */
  .word     DMA1_Stream3_IRQHandler           /* DMA1 Stream 3                               */
  .word     DMA1_Stream4_IRQHandler           /* DMA1 Stream 4                               */
  .word     DMA1_Stream5_IRQHandler           /* DMA1 Stream 5                               */
  .word     DMA1_Stream6_IRQHandler           /* DMA1 Stream 6                               */
  .word     ADC_IRQHandler                    /* ADC1, ADC2 and ADC3s                        */
  .word     0                                 /* Reserved                                    */
  .word     0                                 /* Reserved                                    */
  .word     0                                 /* Reserved                                    */
  .word     0                                 /* Reserved                                    */
  .word     EXTI9_5_IRQHandler                /* External Line[9:5]s                         */
  .word     TIM1_BRK_TIM9_IRQHandler          /* TIM1 Break and TIM9                         */
  .word     TIM1_UP_IRQHandler                /* TIM1 Update                                 */
  .word     TIM1_TRG_COM_TIM11_IRQHandler     /* TIM1 Trigger and Commutation and TIM11      */
  .word     TIM1_CC_IRQHandler                /* TIM1 Capture Compare                        */
  .word     0                                 /* Reserved                                    */
  .word     0                                 /* Reserved                                    */
  .word     0                                 /* Reserved                                    */
  .word     I2C1_EV_IRQHandler                /* I2C1 Event                                  */
  .word     I2C1_ER_IRQHandler                /* I2C1 Error                                  */
  .word     I2C2_EV_IRQHandler                /* I2C2 Event                                  */
  .word     I2C2_ER_IRQHandler                /* I2C2 Error                                  */
  .word     SPI1_IRQHandler                   /* SPI1                                        */
  .word     SPI2_IRQHandler                   /* SPI2                                        */
  .word     USART1_IRQHandler                 /* USART1                                      */
  .word     USART2_IRQHandler                 /* USART2                                      */
  .word     0                                 /* Reserved                                    */
  .word     EXTI15_10_IRQHandler              /* External Line[15:10]s                       */
  .word     RTC_Alarm_IRQHandler              /* RTC Alarm (A and B) through EXTI Line       */
  .word     0                                 /* Reserved                                    */
  .word     0                                 /* Reserved                                    */
  .word     0                                 /* Reserved                                    */
  .word     0                                 /* Reserved                                    */
  .word     0                                 /* Reserved                                    */
  .word     DMA1_Stream7_IRQHandler           /* DMA1 Stream7                                */
  .word     0                                 /* Reserved                                    */
  .word     0                                 /* Reserved                                    */
  .word     TIM5_IRQHandler                   /* TIM5                                        */
  .word     0                                 /* Reserved                                    */
  .word     0                                 /* Reserved                                    */
  .word     0                                 /* Reserved                                    */
  .word     TIM6_DAC_IRQHandler               /* TIM6 and DAC                                */
  .word     0                                 /* Reserved                                    */
  .word     DMA2_Stream0_IRQHandler           /* DMA2 Stream 0                               */
  .word     DMA2_Stream1_IRQHandler           /* DMA2 Stream 1                               */
  .word     DMA2_Stream2_IRQHandler           /* DMA2 Stream 2                               */
  .word     DMA2_Stream3_IRQHandler           /* DMA2 Stream 3                               */
  .word     DMA2_Stream4_IRQHandler           /* DMA2 Stream 4                               */
  .word     0                                 /* Reserved                                    */
  .word     0                                 /* Reserved                                    */
  .word     0                                 /* Reserved                                    */
  .word     0                                 /* Reserved                                    */
  .word     0                                 /* Reserved                                    */
  .word     0                                 /* Reserved                                    */
  .word     0                                 /* Reserved                                    */
  .word     DMA2_Stream5_IRQHandler           /* DMA2 Stream 5                               */
  .word     DMA2_Stream6_IRQHandler           /* DMA2 Stream 6                               */
  .word     DMA2_Stream7_IRQHandler           /* DMA2 Stream 7                               */
  .word     USART6_IRQHandler                 /* USART6                                      */
  .word     0                                 /* Reserved                                    */
  .word     0                                 /* Reserved                                    */
  .word     0                                 /* Reserved                                    */
  .word     0                                 /* Reserved                                    */
  .word     0                                 /* Reserved                                    */
  .word     0                                 /* Reserved                                    */
  .word     0                                 /* Reserved                                    */
  .word     0                                 /* Reserved                                    */
  .word     RNG_IRQHandler                    /* RNG                                         */
  .word     FPU_IRQHandler                    /* FPU                                         */
  .word     0                                 /* Reserved                                    */
  .word     0                                 /* Reserved                                    */
  .word     0                                 /* Reserved                                    */
  .word     SPI5_IRQHandler                   /* SPI5                                        */
  .word     0                                 /* Reserved                                    */
  .word     0                                 /* Reserved                                    */
  .word     0                                 /* Reserved                                    */
  .word     0                                 /* Reserved                                    */
  .word     0                                 /* Reserved                                    */
  .word     0                                 /* Reserved                                    */
  .word     0                                 /* Reserved                                    */
  .word     0                                 /* Reserved                                    */
  .word     0                                 /* Reserved                                    */
  .word     FMPI2C1_EV_IRQHandler             /* FMPI2C1 Event                               */
  .word     FMPI2C1_ER_IRQHandler             /* FMPI2C1 Error                               */
  .word     LPTIM1_IRQHandler                 /* LP TIM1                                     */

/*******************************************************************************
*
* Provide weak aliases for each Exception handler to the default_interrupt_handler. 
* As they are weak aliases, any function with the same name will override 
* this definition.
*
*******************************************************************************/
   .weak      NMI_Handler
   .thumb_set NMI_Handler,default_interrupt_handler

   .weak      HardFault_Handler
   .thumb_set HardFault_Handler,default_interrupt_handler

   .weak      MemManage_Handler
   .thumb_set MemManage_Handler,default_interrupt_handler
  
   .weak      BusFault_Handler
   .thumb_set BusFault_Handler,default_interrupt_handler

   .weak      UsageFault_Handler
   .thumb_set UsageFault_Handler,default_interrupt_handler

   .weak      SVC_Handler
   .thumb_set SVC_Handler,default_interrupt_handler

   .weak      DebugMon_Handler
   .thumb_set DebugMon_Handler,default_interrupt_handler

   .weak      PendSV_Handler
   .thumb_set PendSV_Handler,default_interrupt_handler

   .weak      SysTick_Handler
   .thumb_set SysTick_Handler,default_interrupt_handler

   .weak      WWDG_IRQHandler
   .thumb_set WWDG_IRQHandler,default_interrupt_handler

   .weak      PVD_IRQHandler
   .thumb_set PVD_IRQHandler,default_interrupt_handler

   .weak      TAMP_STAMP_IRQHandler
   .thumb_set TAMP_STAMP_IRQHandler,default_interrupt_handler

   .weak      RTC_WKUP_IRQHandler
   .thumb_set RTC_WKUP_IRQHandler,default_interrupt_handler

   .weak      FLASH_IRQHandler
   .thumb_set FLASH_IRQHandler,default_interrupt_handler

   .weak      RCC_IRQHandler
   .thumb_set RCC_IRQHandler,default_interrupt_handler

   .weak      EXTI0_IRQHandler
   .thumb_set EXTI0_IRQHandler,default_interrupt_handler

   .weak      EXTI1_IRQHandler
   .thumb_set EXTI1_IRQHandler,default_interrupt_handler

   .weak      EXTI2_IRQHandler
   .thumb_set EXTI2_IRQHandler,default_interrupt_handler 

   .weak      EXTI3_IRQHandler
   .thumb_set EXTI3_IRQHandler,default_interrupt_handler

   .weak      EXTI4_IRQHandler
   .thumb_set EXTI4_IRQHandler,default_interrupt_handler

   .weak      DMA1_Stream0_IRQHandler
   .thumb_set DMA1_Stream0_IRQHandler,default_interrupt_handler

   .weak      DMA1_Stream1_IRQHandler
   .thumb_set DMA1_Stream1_IRQHandler,default_interrupt_handler

   .weak      DMA1_Stream2_IRQHandler
   .thumb_set DMA1_Stream2_IRQHandler,default_interrupt_handler

   .weak      DMA1_Stream3_IRQHandler
   .thumb_set DMA1_Stream3_IRQHandler,default_interrupt_handler

   .weak      DMA1_Stream4_IRQHandler
   .thumb_set DMA1_Stream4_IRQHandler,default_interrupt_handler

   .weak      DMA1_Stream5_IRQHandler
   .thumb_set DMA1_Stream5_IRQHandler,default_interrupt_handler

   .weak      DMA1_Stream6_IRQHandler
   .thumb_set DMA1_Stream6_IRQHandler,default_interrupt_handler

   .weak      ADC_IRQHandler
   .thumb_set ADC_IRQHandler,default_interrupt_handler

   .weak      EXTI9_5_IRQHandler
   .thumb_set EXTI9_5_IRQHandler,default_interrupt_handler

   .weak      TIM1_BRK_TIM9_IRQHandler
   .thumb_set TIM1_BRK_TIM9_IRQHandler,default_interrupt_handler

   .weak      TIM1_UP_IRQHandler
   .thumb_set TIM1_UP_IRQHandler,default_interrupt_handler

   .weak      TIM1_TRG_COM_TIM11_IRQHandler
   .thumb_set TIM1_TRG_COM_TIM11_IRQHandler,default_interrupt_handler

   .weak      TIM1_CC_IRQHandler
   .thumb_set TIM1_CC_IRQHandler,default_interrupt_handler

   .weak      I2C1_EV_IRQHandler
   .thumb_set I2C1_EV_IRQHandler,default_interrupt_handler

   .weak      I2C1_ER_IRQHandler
   .thumb_set I2C1_ER_IRQHandler,default_interrupt_handler

   .weak      I2C2_EV_IRQHandler
   .thumb_set I2C2_EV_IRQHandler,default_interrupt_handler

   .weak      I2C2_ER_IRQHandler
   .thumb_set I2C2_ER_IRQHandler,default_interrupt_handler

   .weak      SPI1_IRQHandler
   .thumb_set SPI1_IRQHandler,default_interrupt_handler

   .weak      SPI2_IRQHandler
   .thumb_set SPI2_IRQHandler,default_interrupt_handler

   .weak      USART1_IRQHandler
   .thumb_set USART1_IRQHandler,default_interrupt_handler

   .weak      USART2_IRQHandler
   .thumb_set USART2_IRQHandler,default_interrupt_handler

   .weak      EXTI15_10_IRQHandler
   .thumb_set EXTI15_10_IRQHandler,default_interrupt_handler

   .weak      RTC_Alarm_IRQHandler
   .thumb_set RTC_Alarm_IRQHandler,default_interrupt_handler

   .weak      DMA1_Stream7_IRQHandler
   .thumb_set DMA1_Stream7_IRQHandler,default_interrupt_handler

   .weak      TIM5_IRQHandler
   .thumb_set TIM5_IRQHandler,default_interrupt_handler

   .weak      TIM6_DAC_IRQHandler
   .thumb_set TIM6_DAC_IRQHandler,default_interrupt_handler

   .weak      DMA2_Stream0_IRQHandler
   .thumb_set DMA2_Stream0_IRQHandler,default_interrupt_handler

   .weak      DMA2_Stream1_IRQHandler
   .thumb_set DMA2_Stream1_IRQHandler,default_interrupt_handler

   .weak      DMA2_Stream2_IRQHandler
   .thumb_set DMA2_Stream2_IRQHandler,default_interrupt_handler

   .weak      DMA2_Stream3_IRQHandler
   .thumb_set DMA2_Stream3_IRQHandler,default_interrupt_handler

   .weak      DMA2_Stream4_IRQHandler
   .thumb_set DMA2_Stream4_IRQHandler,default_interrupt_handler

   .weak      DMA2_Stream5_IRQHandler
   .thumb_set DMA2_Stream5_IRQHandler,default_interrupt_handler

   .weak      DMA2_Stream6_IRQHandler
   .thumb_set DMA2_Stream6_IRQHandler,default_interrupt_handler

   .weak      DMA2_Stream7_IRQHandler
   .thumb_set DMA2_Stream7_IRQHandler,default_interrupt_handler

   .weak      USART6_IRQHandler
   .thumb_set USART6_IRQHandler,default_interrupt_handler

   .weak      RNG_IRQHandler
   .thumb_set RNG_IRQHandler,default_interrupt_handler

   .weak      FPU_IRQHandler
   .thumb_set FPU_IRQHandler,default_interrupt_handler

   .weak      SPI5_IRQHandler
   .thumb_set SPI5_IRQHandler,default_interrupt_handler

    .weak     FMPI2C1_EV_IRQHandler
   .thumb_set FMPI2C1_EV_IRQHandler,default_interrupt_handler

   .weak      FMPI2C1_ER_IRQHandler
   .thumb_set FMPI2C1_ER_IRQHandler,default_interrupt_handler

   .weak      LPTIM1_IRQHandler
   .thumb_set LPTIM1_IRQHandler,default_interrupt_handler
.size vtable, .-vtable

/*
 * A 'Default' interrupt handler. This is where interrupts
 * which are not otherwise configured will go.
 * It is an infinite loop, because...well, we werent
 * expecting the interrupt, so what can we do?
 */
.section .text.default_interrupt_handler,"ax",%progbits
default_interrupt_handler:
    default_interrupt_loop:
      B default_interrupt_loop
.size default_interrupt_handler, .-default_interrupt_handler
