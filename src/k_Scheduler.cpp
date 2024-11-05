
#include "../h/k_Scheduler.hpp"
#include "../h/k_memory.h"

void *Scheduler::operator new(size_t size) {

    if (size%MEM_BLOCK_SIZE != 0) {
        size = (size / MEM_BLOCK_SIZE + 1) * MEM_BLOCK_SIZE;     // size in MEM_BLOCK_SIZE
    }

    size = size/MEM_BLOCK_SIZE;

    return __mem_alloc(size);
}


void Scheduler::operator delete(void *ptr) noexcept {

    __mem_free(ptr);
}

Scheduler * Scheduler::instance = nullptr;