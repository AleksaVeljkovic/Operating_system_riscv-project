.global resolver
.global __mem_alloc
.global __mem_free
.global _ZN7_thread15__thread_createEPPS_PFvPvES2_S2_
.global _ZN7_thread13__thread_exitEv
.global _ZN7_thread17__thread_dispatchEv
.global _ZN7_thread13__thread_joinEPS_
.global _ZN4_sem10__sem_openEPPS_i
.global _ZN4_sem11__sem_closeEPS_
.global _ZN4_sem10__sem_waitEPS_
.global _ZN4_sem12__sem_signalEPS_
.global _ZN4_sem13__sem_trywaitEPS_
.global __getc
.global __putc
.global _ZN7_thread11getThreadIdEv
#.global __thread_create
.align 4
resolver:

    mv t1, a0

    #pomeranje argumenata
    mv a0, a1
    mv a1, a2
    mv a2, a3
    mv a3, a4
    mv a4, a5
    #cuvanje ra registra
    addi sp,sp,-16
    sd ra, 0(sp)


    li t0, 0x01
    beq t1, t0, call_mem_alloc
    li t0, 0x02
    beq t1, t0, call_mem_free
    li t0, 0x11
    beq t1, t0, call_thread_create
    li t0, 0x12
    beq t1, t0, call_thread_exit
    li t0, 0x13
    beq t1, t0, call_thread_dispatch
    li t0, 0x14
    beq t1, t0, call_thread_join
    li t0, 0x21
    beq t1, t0, call_sem_open
    li t0, 0x22
    beq t1, t0, call_sem_close
    li t0, 0x23
    beq t1, t0, call_sem_wait
    li t0, 0x24
    beq t1, t0, call_sem_signal
    li t0, 0x26
    beq t1, t0, call_sem_trywait
    li t0, 0x41
    beq t1, t0, call_getc
    li t0, 0x42
    beq t1, t0, call_putc
    li t0, 0x50
    beq t1, t0, call_get_id

end:
    ld ra, 0(sp)
    addi sp,sp, 16
    ret


call_mem_alloc:
    call __mem_alloc
    j end


call_mem_free:
    call __mem_free
    j end


call_thread_create:
    call _ZN7_thread15__thread_createEPPS_PFvPvES2_S2_
    j end


call_thread_exit:
    call _ZN7_thread13__thread_exitEv
    j end


call_thread_dispatch:
    call _ZN7_thread17__thread_dispatchEv
    j end


call_thread_join:
    call _ZN7_thread13__thread_joinEPS_
    j end

call_sem_open:
    call _ZN4_sem10__sem_openEPPS_i
    j end

call_sem_close:
    call _ZN4_sem11__sem_closeEPS_
    j end

call_sem_wait:
    call _ZN4_sem10__sem_waitEPS_
    j end

call_sem_signal:
    call _ZN4_sem12__sem_signalEPS_
    j end

call_sem_trywait:
    call _ZN4_sem13__sem_trywaitEPS_
    j end

call_getc:
    call __getc
    j end

call_putc:
    call __putc
    j end

call_get_id:
    call _ZN7_thread11getThreadIdEv
    j end