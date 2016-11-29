#include "SystemConsole.h"
#include "Stm32f7xxUartInternal.h"

namespace pearlrt {
   GenericUart* SystemConsole::console = 0;

   GenericUart* SystemConsole::getInstance() {
      if (! console) {
         console =
            stm32f7xxUartInternal::getInstance(0, 115200, 8, 1 , 'N', false);
      }

      return console;
   }
}

