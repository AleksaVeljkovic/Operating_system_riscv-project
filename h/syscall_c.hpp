#include "../lib/hw.h"
#include "../h/k_thread.hpp"
#include "../h/k_sem.hpp"

#define MEM_ALLOC_VALUE        0x01
#define MEM_FREE_VALUE         0x02
#define THREAD_CREATE_VALUE    0x11
#define THREAD_EXIT_VALUE      0x12
#define THREAD_DISPATCH_VALUE  0x13
#define THREAD_JOIN_VALUE      0x14
#define SEM_OPEN_VALUE         0x21
#define SEM_CLOSE_VALUE        0x22
#define SEM_WAIT_VALUE         0x23
#define SEM_SIGNAL_VALUE       0x24
#define SEM_TRY_WAIT_VALUE     0x26
#define GET_C_VALUE            0x41
#define PUT_C_VALUE            0x42
#define GET_ID 0x50


void *mem_alloc(uint64);

int mem_free(void *);

class _thread;

typedef _thread *thread_t;

int thread_create( thread_t *handle, void(*start_routine)(void *), void *arg);

int thread_exit ();

void thread_dispatch ();

void thread_join ( thread_t handle);

class _sem;

typedef _sem* sem_t;

int sem_open ( sem_t* handle, unsigned init);

int sem_close (sem_t handle);

int sem_wait (sem_t id);

int sem_signal (sem_t id);

int sem_trywait (sem_t id);

char getc();

void putc(char c);

int getThreadId();