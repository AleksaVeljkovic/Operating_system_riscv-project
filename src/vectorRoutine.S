.global vectorRoutine
.align 4
vectorRoutine:
    j ecallInterruptRoutine
    j timerInterruptRoutine # 0x8000000000000000001
    sret
    sret
    sret
    sret
    sret
    sret
    sret
    j consoleInterruptRoutine #0x800000000000000009
