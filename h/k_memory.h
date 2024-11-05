#include "../lib/hw.h"

#ifdef __cplusplus
extern "C" {
#endif

#define OUT_OF_BOUNDS -1;
#define NOT_ALIGNED -2;
#define ALREADY_FREE -3;



void initMemory();

void * __mem_alloc(uint64);

int __mem_free(void*);

#ifdef __cplusplus
}
#endif
