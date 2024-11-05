#include "../lib/console.h"
#include "../h/errorHandler.h"
#include "../lib/hw.h"

void errorHandler(){


    uint64 volatile scause;
    __asm__ volatile ("csrr %[scause], scause" : [scause] "=r"(scause));

    if(scause == 0x02) {            // ILEGALNA INSTRUKCIJA

        __putc('\n');
        char *string = "Ilegalna Instrukcija  scause = 0x02\n";

        while (*string != '\n')
        {
            __putc(*string);
            string++;
        }
        __putc('\n');
    }

    else if(scause == 0x05){        // NEDOZVOLJENA ADRESA CITANJA

        __putc('\n');
        char *string = "Nedozvoljena adresa citanja  scause = 0x05\n";

        while (*string != '\n')
        {
            __putc(*string);
            string++;
        }
        __putc('\n');
    }

    else if(scause == 0x07){        // NEDOZVOLJENA ADRESA UPISA

        __putc('\n');
        char *string = "Nedozvoljena adresa upisa  scause = 0x07\n";

        while (*string != '\n')
        {
            __putc(*string);
            string++;
        }
        __putc('\n');
    }

//    else if(scause == 0x8000000000000009){      // SPOLJASNI HARDVERSKI PREKID
//        console_handler();
//        return;
//    }
//
//    else if(scause == 0x8000000000000001){      // SOFTVERSKI PREKID IZ TRECEG REZIMA
//
//    }

    while(1){

    }
}