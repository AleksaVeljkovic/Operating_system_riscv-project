
#ifndef OSALEKSA_K_FIFOLIST_H
#define OSALEKSA_K_FIFOLIST_H

#include "../lib/console.h"
#include "../lib/hw.h"
#define MAX_NUM_OF_LISTS 100

class _thread;
typedef _thread * thread_t;

class node{

public:

    thread_t data;
    node* next;

    node(){
      //  __putc('N');
      //  __putc('C');
    }

    node(thread_t _data){
        data = _data;
        next = nullptr;
    }

    void *operator new(size_t size);

    void operator delete(void *ptr) noexcept;

};

class _fifoList{

    node* first;
    node* last;
public:

    _fifoList(){
        first = last = nullptr;
    }

    void insertAtEnd(thread_t t);

    thread_t removeFromStart();

    thread_t removeThread(int id);

    bool findThread(int id);

    void *operator new(size_t size);

    void operator delete(void *ptr) noexcept;

};

//_fifoList<int> a; // nema new
//_fifoList<int *a = new _fifoList<int>();
#endif //OSALEKSA_K_FIFOLIST_H
