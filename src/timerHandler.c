//
// Created by os on 1/25/24.
//
#include "../lib/hw.h"
#include "../lib/console.h"
void timer_handler(){
   // __putc('T');
    uint64 sip;
    __asm__ volatile("csrr %0, sip": "=r"(sip));
    sip &= ~2;
    __asm__ volatile("csrw sip, %0"::"r"(sip));
    return;
}