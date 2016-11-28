#include "PearlIncludes.h"
#include "stm32f4xx.h"

pearlrt::Stm32f7xxClock myClock(0);
//pearlrt::Lpc17xxDigitalOut leds(2,7,8);
//pearlrt::Lpc17xxDigitalIn joy(1,29,5);

SPCTASK(TASK1);

DCLTASK(TASK1, pearlrt::Prio(110), pearlrt::BitString<1>(1)) {

   while(1) {
       RCC->AHB1ENR |= RCC_AHB1ENR_GPIOIEN;  // enable the clock to GPIOD
       __asm("dsb");                            // stall instruction pipeline, until instruction completes, as
       PIOI->MODER = (1 << 2);                  //    per Errata 2.1.13, "Delay after an RCC peripheral clock enabling"
 
       GPIOI->ODR ^= (1 << 1); //toggle the pin

      TASK1.resume(Task::AFTER,
                   pearlrt::Clock(),
                   pearlrt::Duration(0.2));
   }
}

SPCTASK(TASK2);

DCLTASK(TASK2, pearlrt::Prio(111), pearlrt::BitString<1>(1)){
    
  

   while(1) {

      GPIOI->ODR ^= (1 << 1); //toggle the pin	
      
      TASK1.resume(Task::AFTER,
                   pearlrt::Clock(),
                   pearlrt::Duration(0.3));
   }


}