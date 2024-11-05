//
// Created by os on 1/19/24.
//
#include "../h/k_memory.h"
#include "../lib/console.h"
uint64 num_of_all_blocks;
char* headers;
void* blocks;

void initMemory() {

    uint64 heap_size = (uint64)HEAP_END_ADDR - (uint64)HEAP_START_ADDR;    // VELICINA CELE MEMORIJE

    num_of_all_blocks = heap_size / (MEM_BLOCK_SIZE + sizeof(char));             // UKUPAN BROJ BLOKOVA,  VELICINA_CELE_MEMORIJE/65B

    headers = (char*)HEAP_START_ADDR;

    blocks = (void*)((uint64)HEAP_START_ADDR + (num_of_all_blocks * sizeof(char)));



    uint64 i = 0;

    while (i < num_of_all_blocks){
        headers[i] = 'S';
        i++;
    }


    /*
        //PROVERA DA LI JE UPISANO 'S' NA NEKIM POZICIJAMA

        if(headers[0] == 'S') __putc('D');
        if(headers[num_of_all_blocks - 1] == 'S') __putc('D');
        if(headers[3] == 'S') __putc('G');
        __putc('\n');
    */


}

void * __mem_alloc(uint64 numOfBlocks){

    uint64 from = 0;
    uint64 counter = 0;
    void* address = 0;
    char greska = 'D';

    for(uint64 i = 0; i < num_of_all_blocks; i++){      // num_of_all_blocks GLOBALNA PROMENLJIVA, POCETAK PRVOG BLOKA U MEMORIJI

        if(headers[i] == 'S'){
            counter++;
        }

        else{
            counter = 0;
            from = i + 1;
        }

        if(counter == numOfBlocks){

            uint64 j = from;
            uint64 end = from +numOfBlocks;

            while(j < end) {

                if (j == end - 1){
                    headers[j] = 'P';

                    // PROVERA
                    //__putc('P');
                }

                else{
                    headers[j] = 'Z';

                    // PROVERA
                    //__putc('Z');
                }

                j++;

            }

            greska = 'N';

            address =  (void *)((uint64)blocks + (from * MEM_BLOCK_SIZE));


            /*
                PROVERA ADRESE

                if(address > HEAP_START_ADDR && address < HEAP_END_ADDR){
                    __putc('m');
                }

                if(address == (void*)(&headers[num_of_all_blocks + 128])){
                    __putc('m');
                }

            */


            break;
        }
    }


    // OBRADJIVANJE GRESKE ZATO STO NE POSTOJI DOVOLJNO MESTA U MEMORIJI

    if(greska == 'D'){
        __putc('G');
        __putc('R');
        __putc('E');
        __putc('S');
        __putc('K');
        __putc('A');
    }


    return address;
}

int __mem_free(void* ptr){

    if(ptr > HEAP_END_ADDR || ptr < blocks) {       // GRESKA: VAN OPSEGA MEMORIJE HIPA

        return OUT_OF_BOUNDS;

    }

    uint64 from_start = (uint64)ptr - (uint64)blocks;

    if(from_start%MEM_BLOCK_SIZE != 0){             // GRESKA: PTR NE POKAZUJE NA POCETAK BLOKA

        return NOT_ALIGNED;

    }

    uint64 index = from_start/MEM_BLOCK_SIZE;

    for(uint64 i = index; ; i++){

        if(headers[i] == 'S'){                      // GRESKA: BLOK JE VEC SLOBODAN

            return ALREADY_FREE;

        }

        if(headers[i] == 'P'){

            headers[i] = 'S';

            //PROVERA
            //__putc('S');

            break;
        }

        else{

            headers[i] = 'S';

            //PROVERA
            //__putc('S');

        }
    }

    return  0;
}