.global resolver
.global ecallInterruptRoutine
.global errorHandler
.global running
.global start_thread
.align 4
ecallInterruptRoutine:

    addi sp, sp, -256
    .irp index, 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
    sd x\index, \index * 8(sp)
    .endr


    ld t3, running      #running->sp = sp
    sd sp, 0(t3)
    ld sp, 24(t3)



#samo ako je softverski prekid

    csrr t1, scause

    li t0, 0x08
    beq t1, t0, call_resolver

    li t0, 0x09
    beq t1, t0, call_resolver

    call errorHandler


call_resolver:
    csrr t0, sepc
    addi t0,t0,4
    sd t0, 8(t3)        #running->pc = sepc


    call resolver

start_thread:
    ld t3, running
    sd sp, 24(t3)
    ld sp, 0(t3)        #sp = running->sp
    ld t0, 8(t3)        #sepc = running->pc

    csrw sepc, t0

    ld t0, 16(t3)
    csrw sstatus, t0    #sstatus = running->rezim

    .irp index, 1,3,4,5,6,7,8,9,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
    ld x\index, \index * 8(sp)
    .endr
    addi sp, sp, 256

    sret