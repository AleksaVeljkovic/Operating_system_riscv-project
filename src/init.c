//
// Created by os on 1/19/24.
//
#include "../lib/hw.h"
void vectorRoutine();
void initInterrupt(){
    asm volatile("csrw stvec, %0" : : "r" ((uint64)vectorRoutine|1)); //0x820141284121
}

void initTimer(){
    uint64 sstatus;
    asm volatile("csrr %0, sstatus" : "=r"(sstatus));
    sstatus |= 1<<1;
    asm volatile("csrw sstatus, %0" : : "r"(sstatus));
}

//typedef  void(*initFunction)();
//class Initializer{
//    private:
//    static Initializer* instance;
//
//    static Initializer* getInstance(){}
//
//    addInit(initFunction);
//
//    static initAll();
//
//};