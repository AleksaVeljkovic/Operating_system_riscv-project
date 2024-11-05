
#include "../h/k_FIFOList.hpp"
#include "../h/k_thread.hpp"

static node allNodes[MAX_NUM_OF_THREADS];
static bool isOcc[MAX_NUM_OF_THREADS] = {false};


static _fifoList allLists[MAX_NUM_OF_LISTS];
static bool isOccList[MAX_NUM_OF_LISTS] = {false};


void _fifoList::insertAtEnd(thread_t t) {

    node* n = new node(t);


    if(first != nullptr){

        last->next = n;
        last = n;
    }

    else{

        first = last = n;
    }

}

thread_t _fifoList::removeFromStart() {

    if(first != nullptr) {

        node *n = first;
        delete(first);

        if (first == last) {
            first = last = nullptr;
        }

        else{
            first = first->next;
        }

        n->next = nullptr;

        return n->data;
    }

    return nullptr;
}


thread_t _fifoList::removeThread(int id) {
    node* prev = nullptr;
    node* curr = first;


    while (curr != nullptr) {
        if (curr->data->ThreadId() == id) {
            if (prev == nullptr) {

                first = curr->next;
            } else {

                prev->next = curr->next;
            }

            if (curr == last) {
                last = prev;
            }

            thread_t removedThread = curr->data;
            curr->next = nullptr;
            delete curr;
            return removedThread;
        }

        prev = curr;
        curr = curr->next;
    }


    return nullptr;
}

bool _fifoList::findThread(int id) {
    node* curr = first;
    while(curr != nullptr){
        if(curr->data->ThreadId() == id){
            return true;
        }
        curr = curr->next;
    }
    return false;
}

void *node::operator new(size_t size) {

//    __putc('N');__putc('O');

    for (int i = 0; i < MAX_NUM_OF_THREADS; i++) {

        if (!isOcc[i]) {
            isOcc[i] = true;
            return (void *) (allNodes + i);
        }
    }
    //__mem_alloc
    return allNodes;

    // return __mem_alloc((size+MEM_BLOCK_SIZE-1)/MEM_BLOCK_SIZE);

}

void node::operator delete(void *ptr) noexcept {

 //   __putc('D');__putc('O');
    int index = (node *)ptr - allNodes;
    isOcc[index] = false;

}

void *_fifoList::operator new(size_t size) {

    for (int i = 0; i < MAX_NUM_OF_LISTS; i++) {

        if (!isOccList[i]) {
            isOccList[i] = true;
            return (void *) (allLists + i);
        }
    }

    return allLists;

    // return __mem_alloc((size+MEM_BLOCK_SIZE-1)/MEM_BLOCK_SIZE);
    //  __mem_alloc()
}

void _fifoList::operator delete(void *ptr) noexcept {

    int index = (_fifoList *)ptr - allLists;
    isOccList[index] = false;

}
