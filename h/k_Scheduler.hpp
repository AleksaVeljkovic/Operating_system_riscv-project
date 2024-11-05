
#ifndef OSALEKSA_K_SCHEDULER_H
#define OSALEKSA_K_SCHEDULER_H
#include "./k_FIFOList.hpp"

class Scheduler{

    static Scheduler* instance;
    _fifoList* lista;

    Scheduler(){
        lista = new _fifoList();
    }

public:

    static Scheduler* getInstance(){

        if(instance == 0){
            instance = new Scheduler();
        }

        return instance;
    }

    void put(thread_t t){
        lista->insertAtEnd(t);
    }

    thread_t get(){
        return lista->removeFromStart();
    }

    void *operator new(size_t size);

    void operator delete(void *ptr) noexcept;

};

#endif //OSALEKSA_K_SCHEDULER_H
