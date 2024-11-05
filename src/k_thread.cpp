
#include "../h/k_thread.hpp"
#include "../h/k_Scheduler.hpp"
#include "../h/k_memory.h"

static _thread allThreads[MAX_NUM_OF_THREADS];
static bool isOcc[MAX_NUM_OF_THREADS]={false};
//thread_t _thread::running = nullptr;
thread_t running = nullptr;
int globalId = 0;

extern "C" void start_thread();

_thread::_thread() {

    this->body = nullptr;
    this->arg = nullptr;
    this->stek = nullptr;
    this->status = READY;
    running = this;
    this->context.ssp = (uint64) sstek + SSTEK_SPACE;
    this->context.ra = (uint64)start_thread;
    this->rezim = SSTATUS_FOR_SUPERVISOR;
    this->id = 0;
}


_thread::_thread(void *stek, void (*body)(void *), void *arg) {

    this->stek = stek;
    this->body = body;
    this->arg = arg;
    this->sp = (uint64)stek + DEFAULT_STACK_SIZE-256;
    for(int i=1; i<32;i++){
        ((uint64*)sp)[i] = 0;
    }
    this->status = READY;
    this->pc = (uint64)threadWrapper;
    this->context.ssp = (uint64) sstek + SSTEK_SPACE - 256;
    this->context.ra = (uint64)start_thread;
    this->rezim = SSTATUS_FOR_USER;
    globalId++;
    this->id = globalId;
}


thread_t _thread::getRunning(){
    return running;
}

void _thread::setRunning(thread_t t){
    running = t;
}


void * _thread::operator new(size_t size) {

    for(int i =0; i<MAX_NUM_OF_THREADS;i++){

        if(!isOcc[i]){
            isOcc[i]= true;
            return (void*)(allThreads+i);
        }
    }

    return allThreads;
   // return __mem_alloc((size+MEM_BLOCK_SIZE-1)/MEM_BLOCK_SIZE);
  //  __mem_alloc()
}


void _thread::operator delete(void *ptr) noexcept {

    int index = (_thread*)ptr - allThreads;
    isOcc[index] = false;

}


int _thread::__thread_create(thread_t *handle, void (*start_routine)(void *), void *arg, void *stack) {

    *handle = new _thread(stack,start_routine,arg);

    if(*handle == nullptr) return NO_MEMORY;

    Scheduler::getInstance()->put(*handle);

    return 0;
}


int _thread::__main_thread_create(){
    new _thread();
    return 0;
}

void initMainThread(){
    //__putc('M');
    _thread::__main_thread_create();
}


int thread_exit();
void _thread::threadWrapper() {
    running->body(running->arg);
    thread_exit();

}


int _thread::__thread_exit(){

    running->status = FINISHED;


    if(running->joinQueue){

        thread_t t = running->joinQueue->removeFromStart();

        while(t!= nullptr){

            t->status = READY;
            Scheduler::getInstance()->put(t);
            t = running->joinQueue->removeFromStart();

        }

        delete running->joinQueue;
        running->joinQueue = nullptr;
    }



    __mem_free(running->stek);
   //  delete running;
    __thread_dispatch();

    return NOT_ABLE_TO_SWITCH_CONTEXT;
}

extern "C" void context_switch(void* oldThread, void* newThread);

void _thread::__thread_dispatch(){

    thread_t oldThread = running;

    if(oldThread->status == READY){
        Scheduler::getInstance()->put(oldThread);
    }

    thread_t newThread = Scheduler::getInstance()->get();

    if(oldThread == newThread) return;

    running = newThread;

    context_switch(&(oldThread->context), &(newThread->context));

}


void _thread::__thread_join(thread_t t){


    if(t == running) return;


    if(t->status == FINISHED) return;

    if(t->joinQueue == nullptr){
        t->joinQueue = new _fifoList();
    }

    t->joinQueue->insertAtEnd(running);
    running->status = BLOCKED;

    __thread_dispatch();

}

int _thread::getThreadId(){
    //__thread_dispatch();
    return running->id;
}

int _thread::ThreadId() {
    return this->id;
}

/*
 int _thread::killThread(int id) {

    if(running->id == id){
        return -2;
    }

    _fifoList* hs = new _fifoList();

    thread_t t = Scheduler::getInstance()->get();
    thread_t kill = nullptr;
    while (t != nullptr){
        if(t->id != id) {
            hs->insertAtEnd(t);
            if(t->joinQueue != nullptr){
                kill = t->joinQueue->removeThread(id);
            }
        }
        else{
            kill = t;
        }
        t = Scheduler::getInstance()->get();
    }

    t = hs->removeFromStart();
    while(t != nullptr){
        Scheduler::getInstance()->put(t);
        t = hs->removeFromStart();
    }
    delete(hs);

    if(kill != nullptr){
        kill->status = FINISHED;


        if(kill->joinQueue){

            thread_t thread = kill->joinQueue->removeFromStart();

            while(thread != nullptr){

                thread->status = READY;
                Scheduler::getInstance()->put(thread);
                thread = running->joinQueue->removeFromStart();

            }

            delete kill->joinQueue;
            kill->joinQueue = nullptr;
        }
*/

/*
 void _thread::exec() {
    thread_t t;
    size_t size = DEFAULT_STACK_SIZE/MEM_BLOCK_SIZE;

    void * stack = __mem_alloc(size);
    __thread_create(&t, running->body, running->arg, stack);

    __thread_exit();
}
 */



/*
 void _thread::send(thread_t handle,char *msg) {
//
//    if(handle->fleg1 && handle->fleg2){
//        _sem::__sem_open(&handle->s1,1);
//
//        _sem::__sem_open(&handle->s2, 0);
//
//        handle->fleg1 = false;
//        handle->fleg2 = false;
//    }

    //_sem::__sem_wait(handle->s1);
    while(!handle->bw1){
        __thread_dispatch();
    }
    handle->bw1 = false;

    if(handle->no_message){
        //_sem::__sem_signal(handle->s2);
        handle->bw2 = true;
        handle->no_message = false;
    }

    handle->message = msg;

}

char *_thread::receive() {
//    if(running->fleg1 && running->fleg2){
//        _sem::__sem_open(&running->s1, 1);
//        _sem::__sem_open(&running->s2, 0);
//        running->fleg1 = false;
//        running->fleg2 = false;
//    }

    if(running->message == nullptr){
        running->no_message = true;
        //_sem::__sem_wait(running->s2);
        while(!running->bw2){
            __thread_dispatch();
        }
        running->bw2 = false;

    }

    //_sem::__sem_signal(running->s1);
    running->bw1 = true;
    char * msg = running->message;
    running->message = nullptr;
    return msg;
}
 */