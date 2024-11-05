//
// Created by os on 1/26/24.
//
#include "../h/syscall_cpp.hpp"

void* operator new (size_t size){
    return mem_alloc(size);
}

void operator delete (void* ptr) noexcept{
    mem_free(ptr);
}

Thread::Thread (void (*body)(void*), void* arg){
    this->body = body;
    this->arg  = arg;
}

Thread::~Thread (){
    delete myHandle;
}

int Thread::start (){
    return thread_create(&myHandle,body,arg);
}

void Thread::join(){
    thread_join(myHandle);
}

void Thread::dispatch (){
    thread_dispatch();
}


Thread::Thread (){
    body = tw ;
    arg = this;
}

void Thread::tw(void *arg) {
    if(arg!= nullptr)
        ((Thread*)arg)->run();
}


Semaphore::Semaphore (unsigned init){
    sem_open(&myHandle, init);
}

Semaphore::~Semaphore (){
    delete myHandle;
}

int Semaphore::wait (){
    return sem_wait(myHandle);
}

int Semaphore::signal (){
    return sem_signal(myHandle);
}

int Semaphore::tryWait (){
    return sem_trywait(myHandle);
}

void Console::putc(char c) {
    ::putc(c);
}

char Console::getc() {
    return ::getc();
}