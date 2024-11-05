//
// Created by os on 1/19/24.
//
#include "../lib/hw.h"
#include "../lib/console.h"
#include "../h/init.h"
#include "../h/syscall_c.hpp"
#include "../h/syscall_cpp.hpp"
#include "../h/k_memory.h"
#include "../h/k_FIFOList.hpp"
#include "../test/printing.hpp"
void userMain();
void initMainThread();

void test(void* arg){
    userMain();
}



void main() {

    initInterrupt();

    initMemory();

    initMainThread();

    initTimer();

    Thread* t = new Thread(test, 0);
    t->start();
    //thread_create(&t, test, 0);
    //thread_join(t);
    //userMain();
    t->join();
    delete t;


    return;
}