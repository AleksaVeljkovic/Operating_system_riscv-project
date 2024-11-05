
#include "../h/syscall_c.hpp"

void * mem_alloc(uint64 size){

    if (size%MEM_BLOCK_SIZE != 0) {
        size = (size / MEM_BLOCK_SIZE + 1) * MEM_BLOCK_SIZE;     // size in MEM_BLOCK_SIZE
    }

    size = size/MEM_BLOCK_SIZE;
    void * address;
    __asm__ volatile("mv a1, %0" :: "r" (size));
    __asm__ volatile("li a0, %0" :: "i" (MEM_ALLOC_VALUE));
    __asm__ volatile("ecall");

    __asm volatile("mv %0, a0" : "=r"(address));

    return address;
}


int mem_free(void* adr){

    int free;

    __asm__ volatile ("mv a1, %0"::"r"(adr));
    __asm__ volatile ("li a0, %0" : : "i"(MEM_FREE_VALUE));
    __asm__ volatile("ecall");

    __asm__ volatile("mv %0, a0":"=r"(free));

    return free;
}


int thread_create(thread_t* handle, void(*start_routine)(void*), void* arg){

    int thread;

    void* adr_stek = mem_alloc(DEFAULT_STACK_SIZE);

    __asm__ volatile ("mv a4, %0"::"r"(adr_stek));
    __asm__ volatile ("mv a3, %0"::"r"(arg));
    __asm__ volatile ("mv a2, %0"::"r"(start_routine));
    __asm__ volatile ("mv a1, %0"::"r"(handle));
    __asm__ volatile ("li a0, %0" : : "i"(THREAD_CREATE_VALUE));

    __asm__ volatile("ecall");

    __asm__ volatile("mv %0, a0":"=r"(thread));

    //thread_dispatch();

    return thread;
}


int thread_exit (){

    int error;

    __asm__ volatile ("li a0, %0" : : "i"(THREAD_EXIT_VALUE));
    __asm__ volatile("ecall");

    __asm__ volatile("mv %0, a0":"=r"(error));

    return error;

}


void thread_dispatch (){
    __asm__ volatile ("li a0, %0" : : "i"(THREAD_DISPATCH_VALUE));
    __asm__ volatile("ecall");
}


void thread_join ( thread_t handle){

    __asm__ volatile ("mv a1, %0"::"r"(handle));
    __asm__ volatile ("li a0, %0" : : "i"(THREAD_JOIN_VALUE));
    __asm__ volatile("ecall");

}


int sem_open ( sem_t* handle, unsigned init){

    int open;

    __asm__ volatile ("mv a2, %0"::"r"(init));
    __asm__ volatile ("mv a1, %0"::"r"(handle));
    __asm__ volatile ("li a0, %0" : : "i"(SEM_OPEN_VALUE));
    __asm__ volatile("ecall");

    __asm__ volatile("mv %0, a0":"=r"(open));

    return open;
}


int sem_close (sem_t handle){

    int close;

    __asm__ volatile ("mv a1, %0"::"r"(handle));
    __asm__ volatile ("li a0, %0" : : "i"(SEM_CLOSE_VALUE));
    __asm__ volatile("ecall");

    __asm__ volatile("mv %0, a0":"=r"(close));

    return close;
}


int sem_wait (sem_t id){

    int wait;

    __asm__ volatile ("mv a1, %0"::"r"(id));
    __asm__ volatile ("li a0, %0" : : "i"(SEM_WAIT_VALUE));
    __asm__ volatile("ecall");

    __asm__ volatile("mv %0, a0":"=r"(wait));

    return wait;
}


int sem_signal (sem_t id){

    int signal;

    __asm__ volatile ("mv a1, %0"::"r"(id));
    __asm__ volatile ("li a0, %0" : : "i"(SEM_SIGNAL_VALUE));
    __asm__ volatile("ecall");

    __asm__ volatile("mv %0, a0":"=r"(signal));

    return signal;
}


int sem_trywait (sem_t id){

    int trywait;

    __asm__ volatile ("mv a1, %0"::"r"(id));
    __asm__ volatile ("li a0, %0" : : "i"(SEM_TRY_WAIT_VALUE));
    __asm__ volatile("ecall");

    __asm__ volatile("mv %0, a0":"=r"(trywait));

    return trywait;
}


char getc(){

    char character;

    __asm__ volatile ("li a0, %0" : : "i"(GET_C_VALUE));
    __asm__ volatile("ecall");

    __asm__ volatile("mv %0, a0":"=r"(character));

    return character;
}


void putc(char c){

    __asm__ volatile ("mv a1, %0"::"r"(c));
    __asm__ volatile ("li a0, %0" : : "i"(PUT_C_VALUE));
    __asm__ volatile("ecall");

}

int getThreadId(){

    int id;

    __asm__ volatile ("li a0, %0" : : "i"(GET_ID));
    __asm__ volatile("ecall");

    __asm__ volatile("mv %0, a0":"=r"(id));

    return id;
}

