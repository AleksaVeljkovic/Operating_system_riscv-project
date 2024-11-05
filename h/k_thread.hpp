
#include "../lib/hw.h"
#include "./k_FIFOList.hpp"
#ifndef OSALEKSA_K_THREAD_HPP
#define OSALEKSA_K_THREAD_HPP

#define MAX_NUM_OF_THREADS 128
#define READY 1
#define BLOCKED 2
#define FINISHED 3
#define NO_MEMORY -1
#define NOT_ABLE_TO_SWITCH_CONTEXT -1;
#define SSTATUS_FOR_SUPERVISOR 0x120
#define SSTATUS_FOR_USER 0x020
#define SSTEK_SPACE 4096

class _thread;
typedef _thread* thread_t;

class _thread {
    //Ne dodaje se prije sp i pc
    uint64 sp;
    uint64 pc;
    uint64 rezim;

    struct kernelContext{
        uint64 ssp;
        uint64 ra;
    };

    kernelContext context;
    uint8 sstek [SSTEK_SPACE];

    void *stek;
    uint64 status;
    void (*body)(void *);
    void *arg;
   // _fifoLista;
   _fifoList * joinQueue = nullptr;

   int id;

public:

    _thread();

    _thread(void *, void(*body)(void *), void *arg);

    void *operator new(size_t size);

    void operator delete(void *ptr) noexcept;

    static int __thread_create(thread_t *handle, void(*start_routine)(void *), void *arg, void *stack);

    static int __main_thread_create();

    static int __thread_exit();

    static void __thread_dispatch();

    static void __thread_join(thread_t);

    static void threadWrapper();

    static thread_t getRunning();

    static void setRunning(thread_t);

    friend class _sem;

    static int getThreadId();

    int ThreadId();
};
//_thread *t = new _thread(..);
//t->x[0] == (uint64*)t[0]
// new _thread(...)

#endif //OSALEKSA_K_THREAD_HPP
