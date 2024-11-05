//
// Created by os on 1/26/24.
//
#include "../h/k_sem.hpp"
#include "../h/k_thread.hpp"
#include "../h/k_Scheduler.hpp"

static _sem allSemaphores[MAX_NUM_OF_SEMAPHORE];
static bool isOcc[MAX_NUM_OF_SEMAPHORE] = {false};


//thread_exit i thread join
_sem::_sem(){}


_sem::_sem(int init){

    this->val = init;
    this->open = true;
}



int _sem::__sem_open(sem_t* handle, int init=1){

    *handle = new _sem(init);

    if(*handle == nullptr) return NO_MEMORY;

    return 0;
}



int _sem::__sem_close(sem_t handle){

    if(!handle->open) return SEMAPHORE_CLOSED;

    while(_thread* t = handle->semQueue.removeFromStart()){

        t->status = READY;
        Scheduler::getInstance()->put(t);

    }

    handle->open = false;


    if(handle->val < 0) {

        //delete handle;
        return THREADS_WAITING;
    }

    else{

        //delete handle;
        return 0;
    }

}



int _sem::__sem_wait(sem_t id){

    if(!id->open) return SEMAPHORE_CLOSED;

    if(--id->val < 0){

        _thread* t = _thread::getRunning();
        t->status = BLOCKED;

        id->semQueue.insertAtEnd(t);
        _thread::__thread_dispatch();

        if (!id->open)  return SEMAPHORE_CLOSED_BEFORE_THREADS_SIGNAL;
    }

    return 0;
}



int _sem::__sem_signal(sem_t id){

    if(!id->open) return SEMAPHORE_CLOSED;

    if(++id->val <= 0){

        _thread *t = id->semQueue.removeFromStart();

        if(t == nullptr) {

            return NO_THREADS_WAITING;
        }

        t->status = READY;
        Scheduler::getInstance()->put(t);
    }

    return 0;

}


int _sem::__sem_trywait(sem_t id){

    if(!id->open) return SEMAPHORE_CLOSED;

    if(--id->val < 0) {

        ++id->val;
        return SEMAPHORE_LOCKED;
    }

    if(id->val > 0) return SEMAPHORE_NOT_LOCKED;

    return  0;
}

void* _sem::operator new(size_t size){

    for(int i =0; i<MAX_NUM_OF_SEMAPHORE;i++){

        if(!isOcc[i]){
            isOcc[i]= true;
            return (void*)(allSemaphores+i);
        }
    }

    return allSemaphores;

}


void _sem::operator delete(void* ptr) noexcept{

    int index = (_sem*)ptr - allSemaphores;
    isOcc[index] = false;
}


