//
// Created by os on 1/25/24.
//

#ifndef OSALEKSA_K_SEM_HPP
#define OSALEKSA_K_SEM_HPP
#include "k_FIFOList.hpp"
#define MAX_NUM_OF_SEMAPHORE 100
#define SEMAPHORE_NOT_LOCKED 1
#define NO_MEMORY -1
#define SEMAPHORE_CLOSED -2
#define NO_THREADS_WAITING -3
#define THREADS_WAITING -4
#define SEMAPHORE_CLOSED_BEFORE_THREADS_SIGNAL -5
#define SEMAPHORE_LOCKED -6


class _sem;
typedef _sem* sem_t;

class _sem {

private:

    int val;
    bool open;
   // _fifoList * semQueue = nullptr;
    _fifoList semQueue;

public:

    _sem();

    _sem(int init); // sem_open

    static int __sem_open(sem_t* handle ,int init);

    static int __sem_close(sem_t handle);

    static int __sem_wait(sem_t id);

    static int __sem_signal(sem_t id);

    static int __sem_trywait(sem_t id);

//    void unblock();
//    void block();


    void* operator new(size_t size);

    void operator delete(void* ptr) noexcept;

};


#endif //OSALEKSA_K_SEM_HPP
