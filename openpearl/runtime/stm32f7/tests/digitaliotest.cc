#include "PearlIncludes.h"

//pearlrt::BitString<1> x;
pearlrt::Stm32f7xxClock myClock(0);
//pearlrt::Lpc17xxDigitalOut leds(2,7,8);
//pearlrt::Lpc17xxDigitalIn joy(1,29,5);

SPCTASK(TASK1);
SPCTASK(TASK2);

int *rcc = (int*) 0x40023800;
int *ahb1enr = (int*) (0x40023800+0x30);
int *gpioi_mdr = (int*) (0x40022000);
int *gpioi_odr = (int*) (0x40022014); 

DCLTASK(TASK1, pearlrt::Prio(110), pearlrt::BitString<1>(1)) {

      *ahb1enr |= 0x100;	  		// enable the clock to GPIOD
       __asm("dsb");                            // stall instruction pipeline, until instruction completes, as
       *gpioi_mdr = (1 << 2);  	                //  per Errata 2.1.13, "Delay after an RCC peripheral clock enabling"
       TASK2.activate(me);

   while(1) {

       *gpioi_odr |= (1 << 1);			 //set the pin

      TASK1.resume(Task::AFTER,
                   pearlrt::Clock(),
                   pearlrt::Duration(1.0));
   }
}


DCLTASK(TASK2, pearlrt::Prio(111), pearlrt::BitString<1>(0)){

   while(1) {

      *gpioi_odr &= ~(1 << 1); //clear the pin	

      TASK1.resume(Task::AFTER,
                   pearlrt::Clock(),
                   pearlrt::Duration(0.3));
   }


}
