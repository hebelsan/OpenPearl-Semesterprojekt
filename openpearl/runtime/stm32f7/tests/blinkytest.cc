
#include "PearlIncludes.h"
#include "stm32f7xx_hal_rcc.h"
 

//Quick hack, approximately 1ms delay
void ms_delay(int ms)
{
   while (ms-- > 0) {
      volatile int x=10000;
      while (x-- > 0)
         __asm("nop");
   }
}



//Flash orange LED at about 1hz
int main(void)		//Wir nutzen den PIN PC7 - PI1 sollte eine LED ansteuern
{
    RCC->AHB1ENR |= RCC_AHB1ENR_GPIOIEN;  // enable the clock to GPIOD
    __asm("dsb");                         // stall instruction pipeline, until instruction completes, as
                                          //    per Errata 2.1.13, "Delay after an RCC peripheral clock enabling"
    GPIOI->MODER = (1 << 2);             // set pin 13 to be general purpose output

    for (;;) {
       ms_delay(500);
       GPIOI->ODR ^= (1 << 1);           // Toggle the pin 
    }
}
