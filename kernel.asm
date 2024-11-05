
kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000b117          	auipc	sp,0xb
    80000004:	33013103          	ld	sp,816(sp) # 8000b330 <_GLOBAL_OFFSET_TABLE_+0x10>
    80000008:	00001537          	lui	a0,0x1
    8000000c:	f14025f3          	csrr	a1,mhartid
    80000010:	00158593          	addi	a1,a1,1
    80000014:	02b50533          	mul	a0,a0,a1
    80000018:	00a10133          	add	sp,sp,a0
    8000001c:	741050ef          	jal	ra,80005f5c <start>

0000000080000020 <spin>:
    80000020:	0000006f          	j	80000020 <spin>
	...

0000000080001000 <ecallInterruptRoutine>:
.global running
.global start_thread
.align 4
ecallInterruptRoutine:

    addi sp, sp, -256
    80001000:	f0010113          	addi	sp,sp,-256
    .irp index, 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
    sd x\index, \index * 8(sp)
    .endr
    80001004:	00113423          	sd	ra,8(sp)
    80001008:	00213823          	sd	sp,16(sp)
    8000100c:	00313c23          	sd	gp,24(sp)
    80001010:	02413023          	sd	tp,32(sp)
    80001014:	02513423          	sd	t0,40(sp)
    80001018:	02613823          	sd	t1,48(sp)
    8000101c:	02713c23          	sd	t2,56(sp)
    80001020:	04813023          	sd	s0,64(sp)
    80001024:	04913423          	sd	s1,72(sp)
    80001028:	04a13823          	sd	a0,80(sp)
    8000102c:	04b13c23          	sd	a1,88(sp)
    80001030:	06c13023          	sd	a2,96(sp)
    80001034:	06d13423          	sd	a3,104(sp)
    80001038:	06e13823          	sd	a4,112(sp)
    8000103c:	06f13c23          	sd	a5,120(sp)
    80001040:	09013023          	sd	a6,128(sp)
    80001044:	09113423          	sd	a7,136(sp)
    80001048:	09213823          	sd	s2,144(sp)
    8000104c:	09313c23          	sd	s3,152(sp)
    80001050:	0b413023          	sd	s4,160(sp)
    80001054:	0b513423          	sd	s5,168(sp)
    80001058:	0b613823          	sd	s6,176(sp)
    8000105c:	0b713c23          	sd	s7,184(sp)
    80001060:	0d813023          	sd	s8,192(sp)
    80001064:	0d913423          	sd	s9,200(sp)
    80001068:	0da13823          	sd	s10,208(sp)
    8000106c:	0db13c23          	sd	s11,216(sp)
    80001070:	0fc13023          	sd	t3,224(sp)
    80001074:	0fd13423          	sd	t4,232(sp)
    80001078:	0fe13823          	sd	t5,240(sp)
    8000107c:	0ff13c23          	sd	t6,248(sp)


    ld t3, running      #running->sp = sp
    80001080:	0000be17          	auipc	t3,0xb
    80001084:	258e3e03          	ld	t3,600(t3) # 8000c2d8 <running>
    sd sp, 0(t3)
    80001088:	002e3023          	sd	sp,0(t3)
    ld sp, 24(t3)
    8000108c:	018e3103          	ld	sp,24(t3)



#samo ako je softverski prekid

    csrr t1, scause
    80001090:	14202373          	csrr	t1,scause

    li t0, 0x08
    80001094:	00800293          	li	t0,8
    beq t1, t0, call_resolver
    80001098:	00530863          	beq	t1,t0,800010a8 <call_resolver>

    li t0, 0x09
    8000109c:	00900293          	li	t0,9
    beq t1, t0, call_resolver
    800010a0:	00530463          	beq	t1,t0,800010a8 <call_resolver>

    call errorHandler
    800010a4:	7fc000ef          	jal	ra,800018a0 <errorHandler>

00000000800010a8 <call_resolver>:


call_resolver:
    csrr t0, sepc
    800010a8:	141022f3          	csrr	t0,sepc
    addi t0,t0,4
    800010ac:	00428293          	addi	t0,t0,4
    sd t0, 8(t3)        #running->pc = sepc
    800010b0:	005e3423          	sd	t0,8(t3)


    call resolver
    800010b4:	0ac000ef          	jal	ra,80001160 <resolver>

00000000800010b8 <start_thread>:

start_thread:
    ld t3, running
    800010b8:	0000be17          	auipc	t3,0xb
    800010bc:	220e3e03          	ld	t3,544(t3) # 8000c2d8 <running>
    sd sp, 24(t3)
    800010c0:	002e3c23          	sd	sp,24(t3)
    ld sp, 0(t3)        #sp = running->sp
    800010c4:	000e3103          	ld	sp,0(t3)
    ld t0, 8(t3)        #sepc = running->pc
    800010c8:	008e3283          	ld	t0,8(t3)

    csrw sepc, t0
    800010cc:	14129073          	csrw	sepc,t0

    ld t0, 16(t3)
    800010d0:	010e3283          	ld	t0,16(t3)
    csrw sstatus, t0    #sstatus = running->rezim
    800010d4:	10029073          	csrw	sstatus,t0

    .irp index, 1,3,4,5,6,7,8,9,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
    ld x\index, \index * 8(sp)
    .endr
    800010d8:	00813083          	ld	ra,8(sp)
    800010dc:	01813183          	ld	gp,24(sp)
    800010e0:	02013203          	ld	tp,32(sp)
    800010e4:	02813283          	ld	t0,40(sp)
    800010e8:	03013303          	ld	t1,48(sp)
    800010ec:	03813383          	ld	t2,56(sp)
    800010f0:	04013403          	ld	s0,64(sp)
    800010f4:	04813483          	ld	s1,72(sp)
    800010f8:	05813583          	ld	a1,88(sp)
    800010fc:	06013603          	ld	a2,96(sp)
    80001100:	06813683          	ld	a3,104(sp)
    80001104:	07013703          	ld	a4,112(sp)
    80001108:	07813783          	ld	a5,120(sp)
    8000110c:	08013803          	ld	a6,128(sp)
    80001110:	08813883          	ld	a7,136(sp)
    80001114:	09013903          	ld	s2,144(sp)
    80001118:	09813983          	ld	s3,152(sp)
    8000111c:	0a013a03          	ld	s4,160(sp)
    80001120:	0a813a83          	ld	s5,168(sp)
    80001124:	0b013b03          	ld	s6,176(sp)
    80001128:	0b813b83          	ld	s7,184(sp)
    8000112c:	0c013c03          	ld	s8,192(sp)
    80001130:	0c813c83          	ld	s9,200(sp)
    80001134:	0d013d03          	ld	s10,208(sp)
    80001138:	0d813d83          	ld	s11,216(sp)
    8000113c:	0e013e03          	ld	t3,224(sp)
    80001140:	0e813e83          	ld	t4,232(sp)
    80001144:	0f013f03          	ld	t5,240(sp)
    80001148:	0f813f83          	ld	t6,248(sp)
    addi sp, sp, 256
    8000114c:	10010113          	addi	sp,sp,256

    80001150:	10200073          	sret
	...

0000000080001160 <resolver>:
.global _ZN7_thread11getThreadIdEv
#.global __thread_create
.align 4
resolver:

    mv t1, a0
    80001160:	00050313          	mv	t1,a0

    #pomeranje argumenata
    mv a0, a1
    80001164:	00058513          	mv	a0,a1
    mv a1, a2
    80001168:	00060593          	mv	a1,a2
    mv a2, a3
    8000116c:	00068613          	mv	a2,a3
    mv a3, a4
    80001170:	00070693          	mv	a3,a4
    mv a4, a5
    80001174:	00078713          	mv	a4,a5
    #cuvanje ra registra
    addi sp,sp,-16
    80001178:	ff010113          	addi	sp,sp,-16
    sd ra, 0(sp)
    8000117c:	00113023          	sd	ra,0(sp)


    li t0, 0x01
    80001180:	00100293          	li	t0,1
    beq t1, t0, call_mem_alloc
    80001184:	06530c63          	beq	t1,t0,800011fc <call_mem_alloc>
    li t0, 0x02
    80001188:	00200293          	li	t0,2
    beq t1, t0, call_mem_free
    8000118c:	06530c63          	beq	t1,t0,80001204 <call_mem_free>
    li t0, 0x11
    80001190:	01100293          	li	t0,17
    beq t1, t0, call_thread_create
    80001194:	06530c63          	beq	t1,t0,8000120c <call_thread_create>
    li t0, 0x12
    80001198:	01200293          	li	t0,18
    beq t1, t0, call_thread_exit
    8000119c:	06530c63          	beq	t1,t0,80001214 <call_thread_exit>
    li t0, 0x13
    800011a0:	01300293          	li	t0,19
    beq t1, t0, call_thread_dispatch
    800011a4:	06530c63          	beq	t1,t0,8000121c <call_thread_dispatch>
    li t0, 0x14
    800011a8:	01400293          	li	t0,20
    beq t1, t0, call_thread_join
    800011ac:	06530c63          	beq	t1,t0,80001224 <call_thread_join>
    li t0, 0x21
    800011b0:	02100293          	li	t0,33
    beq t1, t0, call_sem_open
    800011b4:	06530c63          	beq	t1,t0,8000122c <call_sem_open>
    li t0, 0x22
    800011b8:	02200293          	li	t0,34
    beq t1, t0, call_sem_close
    800011bc:	06530c63          	beq	t1,t0,80001234 <call_sem_close>
    li t0, 0x23
    800011c0:	02300293          	li	t0,35
    beq t1, t0, call_sem_wait
    800011c4:	06530c63          	beq	t1,t0,8000123c <call_sem_wait>
    li t0, 0x24
    800011c8:	02400293          	li	t0,36
    beq t1, t0, call_sem_signal
    800011cc:	06530c63          	beq	t1,t0,80001244 <call_sem_signal>
    li t0, 0x26
    800011d0:	02600293          	li	t0,38
    beq t1, t0, call_sem_trywait
    800011d4:	06530c63          	beq	t1,t0,8000124c <call_sem_trywait>
    li t0, 0x41
    800011d8:	04100293          	li	t0,65
    beq t1, t0, call_getc
    800011dc:	06530c63          	beq	t1,t0,80001254 <call_getc>
    li t0, 0x42
    800011e0:	04200293          	li	t0,66
    beq t1, t0, call_putc
    800011e4:	06530c63          	beq	t1,t0,8000125c <call_putc>
    li t0, 0x50
    800011e8:	05000293          	li	t0,80
    beq t1, t0, call_get_id
    800011ec:	06530c63          	beq	t1,t0,80001264 <call_get_id>

00000000800011f0 <end>:

end:
    ld ra, 0(sp)
    800011f0:	00013083          	ld	ra,0(sp)
    addi sp,sp, 16
    800011f4:	01010113          	addi	sp,sp,16
    ret
    800011f8:	00008067          	ret

00000000800011fc <call_mem_alloc>:


call_mem_alloc:
    call __mem_alloc
    800011fc:	4f4000ef          	jal	ra,800016f0 <__mem_alloc>
    j end
    80001200:	ff1ff06f          	j	800011f0 <end>

0000000080001204 <call_mem_free>:


call_mem_free:
    call __mem_free
    80001204:	600000ef          	jal	ra,80001804 <__mem_free>
    j end
    80001208:	fe9ff06f          	j	800011f0 <end>

000000008000120c <call_thread_create>:


call_thread_create:
    call _ZN7_thread15__thread_createEPPS_PFvPvES2_S2_
    8000120c:	7c5000ef          	jal	ra,800021d0 <_ZN7_thread15__thread_createEPPS_PFvPvES2_S2_>
    j end
    80001210:	fe1ff06f          	j	800011f0 <end>

0000000080001214 <call_thread_exit>:


call_thread_exit:
    call _ZN7_thread13__thread_exitEv
    80001214:	29c010ef          	jal	ra,800024b0 <_ZN7_thread13__thread_exitEv>
    j end
    80001218:	fd9ff06f          	j	800011f0 <end>

000000008000121c <call_thread_dispatch>:


call_thread_dispatch:
    call _ZN7_thread17__thread_dispatchEv
    8000121c:	12c010ef          	jal	ra,80002348 <_ZN7_thread17__thread_dispatchEv>
    j end
    80001220:	fd1ff06f          	j	800011f0 <end>

0000000080001224 <call_thread_join>:


call_thread_join:
    call _ZN7_thread13__thread_joinEPS_
    80001224:	3fc010ef          	jal	ra,80002620 <_ZN7_thread13__thread_joinEPS_>
    j end
    80001228:	fc9ff06f          	j	800011f0 <end>

000000008000122c <call_sem_open>:

call_sem_open:
    call _ZN4_sem10__sem_openEPPS_i
    8000122c:	63d010ef          	jal	ra,80003068 <_ZN4_sem10__sem_openEPPS_i>
    j end
    80001230:	fc1ff06f          	j	800011f0 <end>

0000000080001234 <call_sem_close>:

call_sem_close:
    call _ZN4_sem11__sem_closeEPS_
    80001234:	2b1010ef          	jal	ra,80002ce4 <_ZN4_sem11__sem_closeEPS_>
    j end
    80001238:	fb9ff06f          	j	800011f0 <end>

000000008000123c <call_sem_wait>:

call_sem_wait:
    call _ZN4_sem10__sem_waitEPS_
    8000123c:	3b1010ef          	jal	ra,80002dec <_ZN4_sem10__sem_waitEPS_>
    j end
    80001240:	fb1ff06f          	j	800011f0 <end>

0000000080001244 <call_sem_signal>:

call_sem_signal:
    call _ZN4_sem12__sem_signalEPS_
    80001244:	445010ef          	jal	ra,80002e88 <_ZN4_sem12__sem_signalEPS_>
    j end
    80001248:	fa9ff06f          	j	800011f0 <end>

000000008000124c <call_sem_trywait>:

call_sem_trywait:
    call _ZN4_sem13__sem_trywaitEPS_
    8000124c:	549010ef          	jal	ra,80002f94 <_ZN4_sem13__sem_trywaitEPS_>
    j end
    80001250:	fa1ff06f          	j	800011f0 <end>

0000000080001254 <call_getc>:

call_getc:
    call __getc
    80001254:	605060ef          	jal	ra,80008058 <__getc>
    j end
    80001258:	f99ff06f          	j	800011f0 <end>

000000008000125c <call_putc>:

call_putc:
    call __putc
    8000125c:	5c1060ef          	jal	ra,8000801c <__putc>
    j end
    80001260:	f91ff06f          	j	800011f0 <end>

0000000080001264 <call_get_id>:

call_get_id:
    call _ZN7_thread11getThreadIdEv
    80001264:	488010ef          	jal	ra,800026ec <_ZN7_thread11getThreadIdEv>
    80001268:	f89ff06f          	j	800011f0 <end>
    8000126c:	0000                	unimp
	...

0000000080001270 <consoleInterruptRoutine>:
.global consoleInterruptRoutine
.global console_handler
.align 4
consoleInterruptRoutine:

    addi sp, sp, -256
    80001270:	f0010113          	addi	sp,sp,-256
    .irp index, 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
    sd x\index, \index * 8(sp)
    .endr
    80001274:	00113423          	sd	ra,8(sp)
    80001278:	00213823          	sd	sp,16(sp)
    8000127c:	00313c23          	sd	gp,24(sp)
    80001280:	02413023          	sd	tp,32(sp)
    80001284:	02513423          	sd	t0,40(sp)
    80001288:	02613823          	sd	t1,48(sp)
    8000128c:	02713c23          	sd	t2,56(sp)
    80001290:	04813023          	sd	s0,64(sp)
    80001294:	04913423          	sd	s1,72(sp)
    80001298:	04a13823          	sd	a0,80(sp)
    8000129c:	04b13c23          	sd	a1,88(sp)
    800012a0:	06c13023          	sd	a2,96(sp)
    800012a4:	06d13423          	sd	a3,104(sp)
    800012a8:	06e13823          	sd	a4,112(sp)
    800012ac:	06f13c23          	sd	a5,120(sp)
    800012b0:	09013023          	sd	a6,128(sp)
    800012b4:	09113423          	sd	a7,136(sp)
    800012b8:	09213823          	sd	s2,144(sp)
    800012bc:	09313c23          	sd	s3,152(sp)
    800012c0:	0b413023          	sd	s4,160(sp)
    800012c4:	0b513423          	sd	s5,168(sp)
    800012c8:	0b613823          	sd	s6,176(sp)
    800012cc:	0b713c23          	sd	s7,184(sp)
    800012d0:	0d813023          	sd	s8,192(sp)
    800012d4:	0d913423          	sd	s9,200(sp)
    800012d8:	0da13823          	sd	s10,208(sp)
    800012dc:	0db13c23          	sd	s11,216(sp)
    800012e0:	0fc13023          	sd	t3,224(sp)
    800012e4:	0fd13423          	sd	t4,232(sp)
    800012e8:	0fe13823          	sd	t5,240(sp)
    800012ec:	0ff13c23          	sd	t6,248(sp)

    call console_handler
    800012f0:	5a1060ef          	jal	ra,80008090 <console_handler>


    .irp index, 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
    ld x\index, \index * 8(sp)
    .endr
    800012f4:	00813083          	ld	ra,8(sp)
    800012f8:	01013103          	ld	sp,16(sp)
    800012fc:	01813183          	ld	gp,24(sp)
    80001300:	02013203          	ld	tp,32(sp)
    80001304:	02813283          	ld	t0,40(sp)
    80001308:	03013303          	ld	t1,48(sp)
    8000130c:	03813383          	ld	t2,56(sp)
    80001310:	04013403          	ld	s0,64(sp)
    80001314:	04813483          	ld	s1,72(sp)
    80001318:	05013503          	ld	a0,80(sp)
    8000131c:	05813583          	ld	a1,88(sp)
    80001320:	06013603          	ld	a2,96(sp)
    80001324:	06813683          	ld	a3,104(sp)
    80001328:	07013703          	ld	a4,112(sp)
    8000132c:	07813783          	ld	a5,120(sp)
    80001330:	08013803          	ld	a6,128(sp)
    80001334:	08813883          	ld	a7,136(sp)
    80001338:	09013903          	ld	s2,144(sp)
    8000133c:	09813983          	ld	s3,152(sp)
    80001340:	0a013a03          	ld	s4,160(sp)
    80001344:	0a813a83          	ld	s5,168(sp)
    80001348:	0b013b03          	ld	s6,176(sp)
    8000134c:	0b813b83          	ld	s7,184(sp)
    80001350:	0c013c03          	ld	s8,192(sp)
    80001354:	0c813c83          	ld	s9,200(sp)
    80001358:	0d013d03          	ld	s10,208(sp)
    8000135c:	0d813d83          	ld	s11,216(sp)
    80001360:	0e013e03          	ld	t3,224(sp)
    80001364:	0e813e83          	ld	t4,232(sp)
    80001368:	0f013f03          	ld	t5,240(sp)
    8000136c:	0f813f83          	ld	t6,248(sp)
    addi sp, sp, 256
    80001370:	10010113          	addi	sp,sp,256

    80001374:	10200073          	sret
	...

0000000080001380 <context_switch>:
.global context_switch
.align 4

context_switch:

    addi sp, sp, -256
    80001380:	f0010113          	addi	sp,sp,-256
    .irp index, 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
    sd x\index, \index * 8(sp)
    .endr
    80001384:	00113423          	sd	ra,8(sp)
    80001388:	00213823          	sd	sp,16(sp)
    8000138c:	00313c23          	sd	gp,24(sp)
    80001390:	02413023          	sd	tp,32(sp)
    80001394:	02513423          	sd	t0,40(sp)
    80001398:	02613823          	sd	t1,48(sp)
    8000139c:	02713c23          	sd	t2,56(sp)
    800013a0:	04813023          	sd	s0,64(sp)
    800013a4:	04913423          	sd	s1,72(sp)
    800013a8:	04a13823          	sd	a0,80(sp)
    800013ac:	04b13c23          	sd	a1,88(sp)
    800013b0:	06c13023          	sd	a2,96(sp)
    800013b4:	06d13423          	sd	a3,104(sp)
    800013b8:	06e13823          	sd	a4,112(sp)
    800013bc:	06f13c23          	sd	a5,120(sp)
    800013c0:	09013023          	sd	a6,128(sp)
    800013c4:	09113423          	sd	a7,136(sp)
    800013c8:	09213823          	sd	s2,144(sp)
    800013cc:	09313c23          	sd	s3,152(sp)
    800013d0:	0b413023          	sd	s4,160(sp)
    800013d4:	0b513423          	sd	s5,168(sp)
    800013d8:	0b613823          	sd	s6,176(sp)
    800013dc:	0b713c23          	sd	s7,184(sp)
    800013e0:	0d813023          	sd	s8,192(sp)
    800013e4:	0d913423          	sd	s9,200(sp)
    800013e8:	0da13823          	sd	s10,208(sp)
    800013ec:	0db13c23          	sd	s11,216(sp)
    800013f0:	0fc13023          	sd	t3,224(sp)
    800013f4:	0fd13423          	sd	t4,232(sp)
    800013f8:	0fe13823          	sd	t5,240(sp)
    800013fc:	0ff13c23          	sd	t6,248(sp)

		sd sp, 0(a0)
    80001400:	00253023          	sd	sp,0(a0) # 1000 <_entry-0x7ffff000>
		sd ra, 8(a0)
    80001404:	00153423          	sd	ra,8(a0)
		ld sp, 0(a1)
    80001408:	0005b103          	ld	sp,0(a1)
		ld ra, 8(a1)
    8000140c:	0085b083          	ld	ra,8(a1)


	.irp index, 3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
        ld x\index, \index * 8(sp)
        .endr
    80001410:	01813183          	ld	gp,24(sp)
    80001414:	02013203          	ld	tp,32(sp)
    80001418:	02813283          	ld	t0,40(sp)
    8000141c:	03013303          	ld	t1,48(sp)
    80001420:	03813383          	ld	t2,56(sp)
    80001424:	04013403          	ld	s0,64(sp)
    80001428:	04813483          	ld	s1,72(sp)
    8000142c:	05013503          	ld	a0,80(sp)
    80001430:	05813583          	ld	a1,88(sp)
    80001434:	06013603          	ld	a2,96(sp)
    80001438:	06813683          	ld	a3,104(sp)
    8000143c:	07013703          	ld	a4,112(sp)
    80001440:	07813783          	ld	a5,120(sp)
    80001444:	08013803          	ld	a6,128(sp)
    80001448:	08813883          	ld	a7,136(sp)
    8000144c:	09013903          	ld	s2,144(sp)
    80001450:	09813983          	ld	s3,152(sp)
    80001454:	0a013a03          	ld	s4,160(sp)
    80001458:	0a813a83          	ld	s5,168(sp)
    8000145c:	0b013b03          	ld	s6,176(sp)
    80001460:	0b813b83          	ld	s7,184(sp)
    80001464:	0c013c03          	ld	s8,192(sp)
    80001468:	0c813c83          	ld	s9,200(sp)
    8000146c:	0d013d03          	ld	s10,208(sp)
    80001470:	0d813d83          	ld	s11,216(sp)
    80001474:	0e013e03          	ld	t3,224(sp)
    80001478:	0e813e83          	ld	t4,232(sp)
    8000147c:	0f013f03          	ld	t5,240(sp)
    80001480:	0f813f83          	ld	t6,248(sp)
        addi sp, sp, 256
    80001484:	10010113          	addi	sp,sp,256

    80001488:	00008067          	ret
	...

00000000800014a0 <timerInterruptRoutine>:
.global timerInterruptRoutine
.global timer_handler
.align 4
timerInterruptRoutine:

    addi sp, sp, -256
    800014a0:	f0010113          	addi	sp,sp,-256
    .irp index, 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
    sd x\index, \index * 8(sp)
    .endr
    800014a4:	00113423          	sd	ra,8(sp)
    800014a8:	00213823          	sd	sp,16(sp)
    800014ac:	00313c23          	sd	gp,24(sp)
    800014b0:	02413023          	sd	tp,32(sp)
    800014b4:	02513423          	sd	t0,40(sp)
    800014b8:	02613823          	sd	t1,48(sp)
    800014bc:	02713c23          	sd	t2,56(sp)
    800014c0:	04813023          	sd	s0,64(sp)
    800014c4:	04913423          	sd	s1,72(sp)
    800014c8:	04a13823          	sd	a0,80(sp)
    800014cc:	04b13c23          	sd	a1,88(sp)
    800014d0:	06c13023          	sd	a2,96(sp)
    800014d4:	06d13423          	sd	a3,104(sp)
    800014d8:	06e13823          	sd	a4,112(sp)
    800014dc:	06f13c23          	sd	a5,120(sp)
    800014e0:	09013023          	sd	a6,128(sp)
    800014e4:	09113423          	sd	a7,136(sp)
    800014e8:	09213823          	sd	s2,144(sp)
    800014ec:	09313c23          	sd	s3,152(sp)
    800014f0:	0b413023          	sd	s4,160(sp)
    800014f4:	0b513423          	sd	s5,168(sp)
    800014f8:	0b613823          	sd	s6,176(sp)
    800014fc:	0b713c23          	sd	s7,184(sp)
    80001500:	0d813023          	sd	s8,192(sp)
    80001504:	0d913423          	sd	s9,200(sp)
    80001508:	0da13823          	sd	s10,208(sp)
    8000150c:	0db13c23          	sd	s11,216(sp)
    80001510:	0fc13023          	sd	t3,224(sp)
    80001514:	0fd13423          	sd	t4,232(sp)
    80001518:	0fe13823          	sd	t5,240(sp)
    8000151c:	0ff13c23          	sd	t6,248(sp)

    call timer_handler
    80001520:	130000ef          	jal	ra,80001650 <timer_handler>


    .irp index, 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
    ld x\index, \index * 8(sp)
    .endr
    80001524:	00813083          	ld	ra,8(sp)
    80001528:	01013103          	ld	sp,16(sp)
    8000152c:	01813183          	ld	gp,24(sp)
    80001530:	02013203          	ld	tp,32(sp)
    80001534:	02813283          	ld	t0,40(sp)
    80001538:	03013303          	ld	t1,48(sp)
    8000153c:	03813383          	ld	t2,56(sp)
    80001540:	04013403          	ld	s0,64(sp)
    80001544:	04813483          	ld	s1,72(sp)
    80001548:	05013503          	ld	a0,80(sp)
    8000154c:	05813583          	ld	a1,88(sp)
    80001550:	06013603          	ld	a2,96(sp)
    80001554:	06813683          	ld	a3,104(sp)
    80001558:	07013703          	ld	a4,112(sp)
    8000155c:	07813783          	ld	a5,120(sp)
    80001560:	08013803          	ld	a6,128(sp)
    80001564:	08813883          	ld	a7,136(sp)
    80001568:	09013903          	ld	s2,144(sp)
    8000156c:	09813983          	ld	s3,152(sp)
    80001570:	0a013a03          	ld	s4,160(sp)
    80001574:	0a813a83          	ld	s5,168(sp)
    80001578:	0b013b03          	ld	s6,176(sp)
    8000157c:	0b813b83          	ld	s7,184(sp)
    80001580:	0c013c03          	ld	s8,192(sp)
    80001584:	0c813c83          	ld	s9,200(sp)
    80001588:	0d013d03          	ld	s10,208(sp)
    8000158c:	0d813d83          	ld	s11,216(sp)
    80001590:	0e013e03          	ld	t3,224(sp)
    80001594:	0e813e83          	ld	t4,232(sp)
    80001598:	0f013f03          	ld	t5,240(sp)
    8000159c:	0f813f83          	ld	t6,248(sp)
    addi sp, sp, 256
    800015a0:	10010113          	addi	sp,sp,256

    800015a4:	10200073          	sret
	...

00000000800015b0 <vectorRoutine>:
.global vectorRoutine
.align 4
vectorRoutine:
    j ecallInterruptRoutine
    800015b0:	a51ff06f          	j	80001000 <ecallInterruptRoutine>
    j timerInterruptRoutine # 0x8000000000000000001
    800015b4:	eedff06f          	j	800014a0 <timerInterruptRoutine>
    sret
    800015b8:	10200073          	sret
    sret
    800015bc:	10200073          	sret
    sret
    800015c0:	10200073          	sret
    sret
    800015c4:	10200073          	sret
    sret
    800015c8:	10200073          	sret
    sret
    800015cc:	10200073          	sret
    sret
    800015d0:	10200073          	sret
    j consoleInterruptRoutine #0x800000000000000009
    800015d4:	c9dff06f          	j	80001270 <consoleInterruptRoutine>
	...

00000000800015e4 <copy_and_swap>:
# a1 holds expected value
# a2 holds desired value
# a0 holds return value, 0 if successful, !0 otherwise
.global copy_and_swap
copy_and_swap:
    lr.w t0, (a0)          # Load original value.
    800015e4:	100522af          	lr.w	t0,(a0)
    bne t0, a1, fail       # Doesn’t match, so fail.
    800015e8:	00b29a63          	bne	t0,a1,800015fc <fail>
    sc.w t0, a2, (a0)      # Try to update.
    800015ec:	18c522af          	sc.w	t0,a2,(a0)
    bnez t0, copy_and_swap # Retry if store-conditional failed.
    800015f0:	fe029ae3          	bnez	t0,800015e4 <copy_and_swap>
    li a0, 0               # Set return to success.
    800015f4:	00000513          	li	a0,0
    jr ra                  # Return.
    800015f8:	00008067          	ret

00000000800015fc <fail>:
    fail:
    li a0, 1               # Set return to failure.
    800015fc:	00100513          	li	a0,1
    80001600:	00008067          	ret

0000000080001604 <initInterrupt>:
//
// Created by os on 1/19/24.
//
#include "../lib/hw.h"
void vectorRoutine();
void initInterrupt(){
    80001604:	ff010113          	addi	sp,sp,-16
    80001608:	00813423          	sd	s0,8(sp)
    8000160c:	01010413          	addi	s0,sp,16
    asm volatile("csrw stvec, %0" : : "r" ((uint64)vectorRoutine|1)); //0x820141284121
    80001610:	00000797          	auipc	a5,0x0
    80001614:	fa078793          	addi	a5,a5,-96 # 800015b0 <vectorRoutine>
    80001618:	0017e793          	ori	a5,a5,1
    8000161c:	10579073          	csrw	stvec,a5
}
    80001620:	00813403          	ld	s0,8(sp)
    80001624:	01010113          	addi	sp,sp,16
    80001628:	00008067          	ret

000000008000162c <initTimer>:

void initTimer(){
    8000162c:	ff010113          	addi	sp,sp,-16
    80001630:	00813423          	sd	s0,8(sp)
    80001634:	01010413          	addi	s0,sp,16
    uint64 sstatus;
    asm volatile("csrr %0, sstatus" : "=r"(sstatus));
    80001638:	100027f3          	csrr	a5,sstatus
    sstatus |= 1<<1;
    8000163c:	0027e793          	ori	a5,a5,2
    asm volatile("csrw sstatus, %0" : : "r"(sstatus));
    80001640:	10079073          	csrw	sstatus,a5
}
    80001644:	00813403          	ld	s0,8(sp)
    80001648:	01010113          	addi	sp,sp,16
    8000164c:	00008067          	ret

0000000080001650 <timer_handler>:
//
// Created by os on 1/25/24.
//
#include "../lib/hw.h"
#include "../lib/console.h"
void timer_handler(){
    80001650:	ff010113          	addi	sp,sp,-16
    80001654:	00813423          	sd	s0,8(sp)
    80001658:	01010413          	addi	s0,sp,16
   // __putc('T');
    uint64 sip;
    __asm__ volatile("csrr %0, sip": "=r"(sip));
    8000165c:	144027f3          	csrr	a5,sip
    sip &= ~2;
    80001660:	ffd7f793          	andi	a5,a5,-3
    __asm__ volatile("csrw sip, %0"::"r"(sip));
    80001664:	14479073          	csrw	sip,a5
    return;
    80001668:	00813403          	ld	s0,8(sp)
    8000166c:	01010113          	addi	sp,sp,16
    80001670:	00008067          	ret

0000000080001674 <initMemory>:
#include "../lib/console.h"
uint64 num_of_all_blocks;
char* headers;
void* blocks;

void initMemory() {
    80001674:	ff010113          	addi	sp,sp,-16
    80001678:	00813423          	sd	s0,8(sp)
    8000167c:	01010413          	addi	s0,sp,16

    uint64 heap_size = (uint64)HEAP_END_ADDR - (uint64)HEAP_START_ADDR;    // VELICINA CELE MEMORIJE
    80001680:	0000a717          	auipc	a4,0xa
    80001684:	b1873703          	ld	a4,-1256(a4) # 8000b198 <HEAP_START_ADDR>
    80001688:	0000a797          	auipc	a5,0xa
    8000168c:	b087b783          	ld	a5,-1272(a5) # 8000b190 <HEAP_END_ADDR>
    80001690:	40e787b3          	sub	a5,a5,a4

    num_of_all_blocks = heap_size / (MEM_BLOCK_SIZE + sizeof(char));             // UKUPAN BROJ BLOKOVA,  VELICINA_CELE_MEMORIJE/65B
    80001694:	04100693          	li	a3,65
    80001698:	02d7d7b3          	divu	a5,a5,a3
    8000169c:	0000a697          	auipc	a3,0xa
    800016a0:	cef6b223          	sd	a5,-796(a3) # 8000b380 <num_of_all_blocks>

    headers = (char*)HEAP_START_ADDR;
    800016a4:	0000a697          	auipc	a3,0xa
    800016a8:	cce6ba23          	sd	a4,-812(a3) # 8000b378 <headers>

    blocks = (void*)((uint64)HEAP_START_ADDR + (num_of_all_blocks * sizeof(char)));
    800016ac:	00f707b3          	add	a5,a4,a5
    800016b0:	0000a717          	auipc	a4,0xa
    800016b4:	ccf73023          	sd	a5,-832(a4) # 8000b370 <blocks>



    uint64 i = 0;
    800016b8:	00000793          	li	a5,0

    while (i < num_of_all_blocks){
    800016bc:	0000a717          	auipc	a4,0xa
    800016c0:	cc473703          	ld	a4,-828(a4) # 8000b380 <num_of_all_blocks>
    800016c4:	02e7f063          	bgeu	a5,a4,800016e4 <initMemory+0x70>
        headers[i] = 'S';
    800016c8:	0000a717          	auipc	a4,0xa
    800016cc:	cb073703          	ld	a4,-848(a4) # 8000b378 <headers>
    800016d0:	00f70733          	add	a4,a4,a5
    800016d4:	05300693          	li	a3,83
    800016d8:	00d70023          	sb	a3,0(a4)
        i++;
    800016dc:	00178793          	addi	a5,a5,1
    800016e0:	fddff06f          	j	800016bc <initMemory+0x48>
        if(headers[3] == 'S') __putc('G');
        __putc('\n');
    */


}
    800016e4:	00813403          	ld	s0,8(sp)
    800016e8:	01010113          	addi	sp,sp,16
    800016ec:	00008067          	ret

00000000800016f0 <__mem_alloc>:
    uint64 from = 0;
    uint64 counter = 0;
    void* address = 0;
    char greska = 'D';

    for(uint64 i = 0; i < num_of_all_blocks; i++){      // num_of_all_blocks GLOBALNA PROMENLJIVA, POCETAK PRVOG BLOKA U MEMORIJI
    800016f0:	00000793          	li	a5,0
    uint64 counter = 0;
    800016f4:	00000693          	li	a3,0
    uint64 from = 0;
    800016f8:	00000593          	li	a1,0
    for(uint64 i = 0; i < num_of_all_blocks; i++){      // num_of_all_blocks GLOBALNA PROMENLJIVA, POCETAK PRVOG BLOKA U MEMORIJI
    800016fc:	0140006f          	j	80001710 <__mem_alloc+0x20>
            counter++;
        }

        else{
            counter = 0;
            from = i + 1;
    80001700:	00178593          	addi	a1,a5,1
            counter = 0;
    80001704:	00000693          	li	a3,0
        }

        if(counter == numOfBlocks){
    80001708:	02a68a63          	beq	a3,a0,8000173c <__mem_alloc+0x4c>
    for(uint64 i = 0; i < num_of_all_blocks; i++){      // num_of_all_blocks GLOBALNA PROMENLJIVA, POCETAK PRVOG BLOKA U MEMORIJI
    8000170c:	00178793          	addi	a5,a5,1
    80001710:	0000a717          	auipc	a4,0xa
    80001714:	c7073703          	ld	a4,-912(a4) # 8000b380 <num_of_all_blocks>
    80001718:	08e7f063          	bgeu	a5,a4,80001798 <__mem_alloc+0xa8>
        if(headers[i] == 'S'){
    8000171c:	0000a717          	auipc	a4,0xa
    80001720:	c5c73703          	ld	a4,-932(a4) # 8000b378 <headers>
    80001724:	00f70733          	add	a4,a4,a5
    80001728:	00074603          	lbu	a2,0(a4)
    8000172c:	05300713          	li	a4,83
    80001730:	fce618e3          	bne	a2,a4,80001700 <__mem_alloc+0x10>
            counter++;
    80001734:	00168693          	addi	a3,a3,1
    80001738:	fd1ff06f          	j	80001708 <__mem_alloc+0x18>

            uint64 j = from;
            uint64 end = from +numOfBlocks;
    8000173c:	00a58533          	add	a0,a1,a0
            uint64 j = from;
    80001740:	00058793          	mv	a5,a1

            while(j < end) {
    80001744:	01c0006f          	j	80001760 <__mem_alloc+0x70>
                    // PROVERA
                    //__putc('P');
                }

                else{
                    headers[j] = 'Z';
    80001748:	0000a717          	auipc	a4,0xa
    8000174c:	c3073703          	ld	a4,-976(a4) # 8000b378 <headers>
    80001750:	00f70733          	add	a4,a4,a5
    80001754:	05a00693          	li	a3,90
    80001758:	00d70023          	sb	a3,0(a4)

                    // PROVERA
                    //__putc('Z');
                }

                j++;
    8000175c:	00178793          	addi	a5,a5,1
            while(j < end) {
    80001760:	02a7f263          	bgeu	a5,a0,80001784 <__mem_alloc+0x94>
                if (j == end - 1){
    80001764:	fff50713          	addi	a4,a0,-1
    80001768:	fef710e3          	bne	a4,a5,80001748 <__mem_alloc+0x58>
                    headers[j] = 'P';
    8000176c:	0000a717          	auipc	a4,0xa
    80001770:	c0c73703          	ld	a4,-1012(a4) # 8000b378 <headers>
    80001774:	00f70733          	add	a4,a4,a5
    80001778:	05000693          	li	a3,80
    8000177c:	00d70023          	sb	a3,0(a4)
    80001780:	fddff06f          	j	8000175c <__mem_alloc+0x6c>

            }

            greska = 'N';

            address =  (void *)((uint64)blocks + (from * MEM_BLOCK_SIZE));
    80001784:	00659593          	slli	a1,a1,0x6
    80001788:	0000a517          	auipc	a0,0xa
    8000178c:	be853503          	ld	a0,-1048(a0) # 8000b370 <blocks>
    80001790:	00a58533          	add	a0,a1,a0
        __putc('A');
    }


    return address;
}
    80001794:	00008067          	ret
void * __mem_alloc(uint64 numOfBlocks){
    80001798:	ff010113          	addi	sp,sp,-16
    8000179c:	00113423          	sd	ra,8(sp)
    800017a0:	00813023          	sd	s0,0(sp)
    800017a4:	01010413          	addi	s0,sp,16
        __putc('G');
    800017a8:	04700513          	li	a0,71
    800017ac:	00007097          	auipc	ra,0x7
    800017b0:	870080e7          	jalr	-1936(ra) # 8000801c <__putc>
        __putc('R');
    800017b4:	05200513          	li	a0,82
    800017b8:	00007097          	auipc	ra,0x7
    800017bc:	864080e7          	jalr	-1948(ra) # 8000801c <__putc>
        __putc('E');
    800017c0:	04500513          	li	a0,69
    800017c4:	00007097          	auipc	ra,0x7
    800017c8:	858080e7          	jalr	-1960(ra) # 8000801c <__putc>
        __putc('S');
    800017cc:	05300513          	li	a0,83
    800017d0:	00007097          	auipc	ra,0x7
    800017d4:	84c080e7          	jalr	-1972(ra) # 8000801c <__putc>
        __putc('K');
    800017d8:	04b00513          	li	a0,75
    800017dc:	00007097          	auipc	ra,0x7
    800017e0:	840080e7          	jalr	-1984(ra) # 8000801c <__putc>
        __putc('A');
    800017e4:	04100513          	li	a0,65
    800017e8:	00007097          	auipc	ra,0x7
    800017ec:	834080e7          	jalr	-1996(ra) # 8000801c <__putc>
    void* address = 0;
    800017f0:	00000513          	li	a0,0
}
    800017f4:	00813083          	ld	ra,8(sp)
    800017f8:	00013403          	ld	s0,0(sp)
    800017fc:	01010113          	addi	sp,sp,16
    80001800:	00008067          	ret

0000000080001804 <__mem_free>:

int __mem_free(void* ptr){
    80001804:	ff010113          	addi	sp,sp,-16
    80001808:	00813423          	sd	s0,8(sp)
    8000180c:	01010413          	addi	s0,sp,16

    if(ptr > HEAP_END_ADDR || ptr < blocks) {       // GRESKA: VAN OPSEGA MEMORIJE HIPA
    80001810:	0000a797          	auipc	a5,0xa
    80001814:	9807b783          	ld	a5,-1664(a5) # 8000b190 <HEAP_END_ADDR>
    80001818:	06a7e063          	bltu	a5,a0,80001878 <__mem_free+0x74>
    8000181c:	0000a717          	auipc	a4,0xa
    80001820:	b5473703          	ld	a4,-1196(a4) # 8000b370 <blocks>
    80001824:	04e56e63          	bltu	a0,a4,80001880 <__mem_free+0x7c>

        return OUT_OF_BOUNDS;

    }

    uint64 from_start = (uint64)ptr - (uint64)blocks;
    80001828:	40e50533          	sub	a0,a0,a4

    if(from_start%MEM_BLOCK_SIZE != 0){             // GRESKA: PTR NE POKAZUJE NA POCETAK BLOKA
    8000182c:	03f57793          	andi	a5,a0,63
    80001830:	04079c63          	bnez	a5,80001888 <__mem_free+0x84>

        return NOT_ALIGNED;

    }

    uint64 index = from_start/MEM_BLOCK_SIZE;
    80001834:	00655713          	srli	a4,a0,0x6

    for(uint64 i = index; ; i++){

        if(headers[i] == 'S'){                      // GRESKA: BLOK JE VEC SLOBODAN
    80001838:	0000a797          	auipc	a5,0xa
    8000183c:	b407b783          	ld	a5,-1216(a5) # 8000b378 <headers>
    80001840:	00e787b3          	add	a5,a5,a4
    80001844:	0007c683          	lbu	a3,0(a5)
    80001848:	05300613          	li	a2,83
    8000184c:	04c68263          	beq	a3,a2,80001890 <__mem_free+0x8c>

            return ALREADY_FREE;

        }

        if(headers[i] == 'P'){
    80001850:	05000613          	li	a2,80
    80001854:	00c68a63          	beq	a3,a2,80001868 <__mem_free+0x64>
            break;
        }

        else{

            headers[i] = 'S';
    80001858:	05300693          	li	a3,83
    8000185c:	00d78023          	sb	a3,0(a5)
    for(uint64 i = index; ; i++){
    80001860:	00170713          	addi	a4,a4,1
        if(headers[i] == 'S'){                      // GRESKA: BLOK JE VEC SLOBODAN
    80001864:	fd5ff06f          	j	80001838 <__mem_free+0x34>
            headers[i] = 'S';
    80001868:	05300713          	li	a4,83
    8000186c:	00e78023          	sb	a4,0(a5)
            //__putc('S');

        }
    }

    return  0;
    80001870:	00000513          	li	a0,0
    80001874:	0200006f          	j	80001894 <__mem_free+0x90>
        return OUT_OF_BOUNDS;
    80001878:	fff00513          	li	a0,-1
    8000187c:	0180006f          	j	80001894 <__mem_free+0x90>
    80001880:	fff00513          	li	a0,-1
    80001884:	0100006f          	j	80001894 <__mem_free+0x90>
        return NOT_ALIGNED;
    80001888:	ffe00513          	li	a0,-2
    8000188c:	0080006f          	j	80001894 <__mem_free+0x90>
            return ALREADY_FREE;
    80001890:	ffd00513          	li	a0,-3
    80001894:	00813403          	ld	s0,8(sp)
    80001898:	01010113          	addi	sp,sp,16
    8000189c:	00008067          	ret

00000000800018a0 <errorHandler>:
#include "../lib/console.h"
#include "../h/errorHandler.h"
#include "../lib/hw.h"

void errorHandler(){
    800018a0:	fd010113          	addi	sp,sp,-48
    800018a4:	02113423          	sd	ra,40(sp)
    800018a8:	02813023          	sd	s0,32(sp)
    800018ac:	00913c23          	sd	s1,24(sp)
    800018b0:	03010413          	addi	s0,sp,48


    uint64 volatile scause;
    __asm__ volatile ("csrr %[scause], scause" : [scause] "=r"(scause));
    800018b4:	142027f3          	csrr	a5,scause
    800018b8:	fcf43c23          	sd	a5,-40(s0)

    if(scause == 0x02) {            // ILEGALNA INSTRUKCIJA
    800018bc:	fd843703          	ld	a4,-40(s0)
    800018c0:	00200793          	li	a5,2
    800018c4:	02f70063          	beq	a4,a5,800018e4 <errorHandler+0x44>
            string++;
        }
        __putc('\n');
    }

    else if(scause == 0x05){        // NEDOZVOLJENA ADRESA CITANJA
    800018c8:	fd843703          	ld	a4,-40(s0)
    800018cc:	00500793          	li	a5,5
    800018d0:	04f70a63          	beq	a4,a5,80001924 <errorHandler+0x84>
            string++;
        }
        __putc('\n');
    }

    else if(scause == 0x07){        // NEDOZVOLJENA ADRESA UPISA
    800018d4:	fd843703          	ld	a4,-40(s0)
    800018d8:	00700793          	li	a5,7
    800018dc:	08f70463          	beq	a4,a5,80001964 <errorHandler+0xc4>
//
//    else if(scause == 0x8000000000000001){      // SOFTVERSKI PREKID IZ TRECEG REZIMA
//
//    }

    while(1){
    800018e0:	0000006f          	j	800018e0 <errorHandler+0x40>
        __putc('\n');
    800018e4:	00a00513          	li	a0,10
    800018e8:	00006097          	auipc	ra,0x6
    800018ec:	734080e7          	jalr	1844(ra) # 8000801c <__putc>
        char *string = "Ilegalna Instrukcija  scause = 0x02\n";
    800018f0:	00007497          	auipc	s1,0x7
    800018f4:	73048493          	addi	s1,s1,1840 # 80009020 <CONSOLE_STATUS+0x10>
        while (*string != '\n')
    800018f8:	0100006f          	j	80001908 <errorHandler+0x68>
            __putc(*string);
    800018fc:	00006097          	auipc	ra,0x6
    80001900:	720080e7          	jalr	1824(ra) # 8000801c <__putc>
            string++;
    80001904:	00148493          	addi	s1,s1,1
        while (*string != '\n')
    80001908:	0004c503          	lbu	a0,0(s1)
    8000190c:	00a00793          	li	a5,10
    80001910:	fef516e3          	bne	a0,a5,800018fc <errorHandler+0x5c>
        __putc('\n');
    80001914:	00a00513          	li	a0,10
    80001918:	00006097          	auipc	ra,0x6
    8000191c:	704080e7          	jalr	1796(ra) # 8000801c <__putc>
    80001920:	fc1ff06f          	j	800018e0 <errorHandler+0x40>
        __putc('\n');
    80001924:	00a00513          	li	a0,10
    80001928:	00006097          	auipc	ra,0x6
    8000192c:	6f4080e7          	jalr	1780(ra) # 8000801c <__putc>
        char *string = "Nedozvoljena adresa citanja  scause = 0x05\n";
    80001930:	00007497          	auipc	s1,0x7
    80001934:	71848493          	addi	s1,s1,1816 # 80009048 <CONSOLE_STATUS+0x38>
        while (*string != '\n')
    80001938:	0100006f          	j	80001948 <errorHandler+0xa8>
            __putc(*string);
    8000193c:	00006097          	auipc	ra,0x6
    80001940:	6e0080e7          	jalr	1760(ra) # 8000801c <__putc>
            string++;
    80001944:	00148493          	addi	s1,s1,1
        while (*string != '\n')
    80001948:	0004c503          	lbu	a0,0(s1)
    8000194c:	00a00793          	li	a5,10
    80001950:	fef516e3          	bne	a0,a5,8000193c <errorHandler+0x9c>
        __putc('\n');
    80001954:	00a00513          	li	a0,10
    80001958:	00006097          	auipc	ra,0x6
    8000195c:	6c4080e7          	jalr	1732(ra) # 8000801c <__putc>
    80001960:	f81ff06f          	j	800018e0 <errorHandler+0x40>
        __putc('\n');
    80001964:	00a00513          	li	a0,10
    80001968:	00006097          	auipc	ra,0x6
    8000196c:	6b4080e7          	jalr	1716(ra) # 8000801c <__putc>
        char *string = "Nedozvoljena adresa upisa  scause = 0x07\n";
    80001970:	00007497          	auipc	s1,0x7
    80001974:	70848493          	addi	s1,s1,1800 # 80009078 <CONSOLE_STATUS+0x68>
        while (*string != '\n')
    80001978:	0100006f          	j	80001988 <errorHandler+0xe8>
            __putc(*string);
    8000197c:	00006097          	auipc	ra,0x6
    80001980:	6a0080e7          	jalr	1696(ra) # 8000801c <__putc>
            string++;
    80001984:	00148493          	addi	s1,s1,1
        while (*string != '\n')
    80001988:	0004c503          	lbu	a0,0(s1)
    8000198c:	00a00793          	li	a5,10
    80001990:	fef516e3          	bne	a0,a5,8000197c <errorHandler+0xdc>
        __putc('\n');
    80001994:	00a00513          	li	a0,10
    80001998:	00006097          	auipc	ra,0x6
    8000199c:	684080e7          	jalr	1668(ra) # 8000801c <__putc>
    800019a0:	f41ff06f          	j	800018e0 <errorHandler+0x40>

00000000800019a4 <_Z9mem_allocm>:

#include "../h/syscall_c.hpp"

void * mem_alloc(uint64 size){
    800019a4:	ff010113          	addi	sp,sp,-16
    800019a8:	00813423          	sd	s0,8(sp)
    800019ac:	01010413          	addi	s0,sp,16

    if (size%MEM_BLOCK_SIZE != 0) {
    800019b0:	03f57793          	andi	a5,a0,63
    800019b4:	00078863          	beqz	a5,800019c4 <_Z9mem_allocm+0x20>
        size = (size / MEM_BLOCK_SIZE + 1) * MEM_BLOCK_SIZE;     // size in MEM_BLOCK_SIZE
    800019b8:	00655513          	srli	a0,a0,0x6
    800019bc:	00150513          	addi	a0,a0,1
    800019c0:	00651513          	slli	a0,a0,0x6
    }

    size = size/MEM_BLOCK_SIZE;
    800019c4:	00655513          	srli	a0,a0,0x6
    void * address;
    __asm__ volatile("mv a1, %0" :: "r" (size));
    800019c8:	00050593          	mv	a1,a0
    __asm__ volatile("li a0, %0" :: "i" (MEM_ALLOC_VALUE));
    800019cc:	00100513          	li	a0,1
    __asm__ volatile("ecall");
    800019d0:	00000073          	ecall

    __asm volatile("mv %0, a0" : "=r"(address));
    800019d4:	00050513          	mv	a0,a0

    return address;
}
    800019d8:	00813403          	ld	s0,8(sp)
    800019dc:	01010113          	addi	sp,sp,16
    800019e0:	00008067          	ret

00000000800019e4 <_Z8mem_freePv>:


int mem_free(void* adr){
    800019e4:	ff010113          	addi	sp,sp,-16
    800019e8:	00813423          	sd	s0,8(sp)
    800019ec:	01010413          	addi	s0,sp,16

    int free;

    __asm__ volatile ("mv a1, %0"::"r"(adr));
    800019f0:	00050593          	mv	a1,a0
    __asm__ volatile ("li a0, %0" : : "i"(MEM_FREE_VALUE));
    800019f4:	00200513          	li	a0,2
    __asm__ volatile("ecall");
    800019f8:	00000073          	ecall

    __asm__ volatile("mv %0, a0":"=r"(free));
    800019fc:	00050513          	mv	a0,a0

    return free;
}
    80001a00:	0005051b          	sext.w	a0,a0
    80001a04:	00813403          	ld	s0,8(sp)
    80001a08:	01010113          	addi	sp,sp,16
    80001a0c:	00008067          	ret

0000000080001a10 <_Z13thread_createPP7_threadPFvPvES2_>:


int thread_create(thread_t* handle, void(*start_routine)(void*), void* arg){
    80001a10:	fd010113          	addi	sp,sp,-48
    80001a14:	02113423          	sd	ra,40(sp)
    80001a18:	02813023          	sd	s0,32(sp)
    80001a1c:	00913c23          	sd	s1,24(sp)
    80001a20:	01213823          	sd	s2,16(sp)
    80001a24:	01313423          	sd	s3,8(sp)
    80001a28:	03010413          	addi	s0,sp,48
    80001a2c:	00050493          	mv	s1,a0
    80001a30:	00058913          	mv	s2,a1
    80001a34:	00060993          	mv	s3,a2

    int thread;

    void* adr_stek = mem_alloc(DEFAULT_STACK_SIZE);
    80001a38:	00001537          	lui	a0,0x1
    80001a3c:	00000097          	auipc	ra,0x0
    80001a40:	f68080e7          	jalr	-152(ra) # 800019a4 <_Z9mem_allocm>

    __asm__ volatile ("mv a4, %0"::"r"(adr_stek));
    80001a44:	00050713          	mv	a4,a0
    __asm__ volatile ("mv a3, %0"::"r"(arg));
    80001a48:	00098693          	mv	a3,s3
    __asm__ volatile ("mv a2, %0"::"r"(start_routine));
    80001a4c:	00090613          	mv	a2,s2
    __asm__ volatile ("mv a1, %0"::"r"(handle));
    80001a50:	00048593          	mv	a1,s1
    __asm__ volatile ("li a0, %0" : : "i"(THREAD_CREATE_VALUE));
    80001a54:	01100513          	li	a0,17

    __asm__ volatile("ecall");
    80001a58:	00000073          	ecall

    __asm__ volatile("mv %0, a0":"=r"(thread));
    80001a5c:	00050513          	mv	a0,a0

    //thread_dispatch();

    return thread;
}
    80001a60:	0005051b          	sext.w	a0,a0
    80001a64:	02813083          	ld	ra,40(sp)
    80001a68:	02013403          	ld	s0,32(sp)
    80001a6c:	01813483          	ld	s1,24(sp)
    80001a70:	01013903          	ld	s2,16(sp)
    80001a74:	00813983          	ld	s3,8(sp)
    80001a78:	03010113          	addi	sp,sp,48
    80001a7c:	00008067          	ret

0000000080001a80 <_Z11thread_exitv>:


int thread_exit (){
    80001a80:	ff010113          	addi	sp,sp,-16
    80001a84:	00813423          	sd	s0,8(sp)
    80001a88:	01010413          	addi	s0,sp,16

    int error;

    __asm__ volatile ("li a0, %0" : : "i"(THREAD_EXIT_VALUE));
    80001a8c:	01200513          	li	a0,18
    __asm__ volatile("ecall");
    80001a90:	00000073          	ecall

    __asm__ volatile("mv %0, a0":"=r"(error));
    80001a94:	00050513          	mv	a0,a0

    return error;

}
    80001a98:	0005051b          	sext.w	a0,a0
    80001a9c:	00813403          	ld	s0,8(sp)
    80001aa0:	01010113          	addi	sp,sp,16
    80001aa4:	00008067          	ret

0000000080001aa8 <_Z15thread_dispatchv>:


void thread_dispatch (){
    80001aa8:	ff010113          	addi	sp,sp,-16
    80001aac:	00813423          	sd	s0,8(sp)
    80001ab0:	01010413          	addi	s0,sp,16
    __asm__ volatile ("li a0, %0" : : "i"(THREAD_DISPATCH_VALUE));
    80001ab4:	01300513          	li	a0,19
    __asm__ volatile("ecall");
    80001ab8:	00000073          	ecall
}
    80001abc:	00813403          	ld	s0,8(sp)
    80001ac0:	01010113          	addi	sp,sp,16
    80001ac4:	00008067          	ret

0000000080001ac8 <_Z11thread_joinP7_thread>:


void thread_join ( thread_t handle){
    80001ac8:	ff010113          	addi	sp,sp,-16
    80001acc:	00813423          	sd	s0,8(sp)
    80001ad0:	01010413          	addi	s0,sp,16

    __asm__ volatile ("mv a1, %0"::"r"(handle));
    80001ad4:	00050593          	mv	a1,a0
    __asm__ volatile ("li a0, %0" : : "i"(THREAD_JOIN_VALUE));
    80001ad8:	01400513          	li	a0,20
    __asm__ volatile("ecall");
    80001adc:	00000073          	ecall

}
    80001ae0:	00813403          	ld	s0,8(sp)
    80001ae4:	01010113          	addi	sp,sp,16
    80001ae8:	00008067          	ret

0000000080001aec <_Z8sem_openPP4_semj>:


int sem_open ( sem_t* handle, unsigned init){
    80001aec:	ff010113          	addi	sp,sp,-16
    80001af0:	00813423          	sd	s0,8(sp)
    80001af4:	01010413          	addi	s0,sp,16

    int open;

    __asm__ volatile ("mv a2, %0"::"r"(init));
    80001af8:	00058613          	mv	a2,a1
    __asm__ volatile ("mv a1, %0"::"r"(handle));
    80001afc:	00050593          	mv	a1,a0
    __asm__ volatile ("li a0, %0" : : "i"(SEM_OPEN_VALUE));
    80001b00:	02100513          	li	a0,33
    __asm__ volatile("ecall");
    80001b04:	00000073          	ecall

    __asm__ volatile("mv %0, a0":"=r"(open));
    80001b08:	00050513          	mv	a0,a0

    return open;
}
    80001b0c:	0005051b          	sext.w	a0,a0
    80001b10:	00813403          	ld	s0,8(sp)
    80001b14:	01010113          	addi	sp,sp,16
    80001b18:	00008067          	ret

0000000080001b1c <_Z9sem_closeP4_sem>:


int sem_close (sem_t handle){
    80001b1c:	ff010113          	addi	sp,sp,-16
    80001b20:	00813423          	sd	s0,8(sp)
    80001b24:	01010413          	addi	s0,sp,16

    int close;

    __asm__ volatile ("mv a1, %0"::"r"(handle));
    80001b28:	00050593          	mv	a1,a0
    __asm__ volatile ("li a0, %0" : : "i"(SEM_CLOSE_VALUE));
    80001b2c:	02200513          	li	a0,34
    __asm__ volatile("ecall");
    80001b30:	00000073          	ecall

    __asm__ volatile("mv %0, a0":"=r"(close));
    80001b34:	00050513          	mv	a0,a0

    return close;
}
    80001b38:	0005051b          	sext.w	a0,a0
    80001b3c:	00813403          	ld	s0,8(sp)
    80001b40:	01010113          	addi	sp,sp,16
    80001b44:	00008067          	ret

0000000080001b48 <_Z8sem_waitP4_sem>:


int sem_wait (sem_t id){
    80001b48:	ff010113          	addi	sp,sp,-16
    80001b4c:	00813423          	sd	s0,8(sp)
    80001b50:	01010413          	addi	s0,sp,16

    int wait;

    __asm__ volatile ("mv a1, %0"::"r"(id));
    80001b54:	00050593          	mv	a1,a0
    __asm__ volatile ("li a0, %0" : : "i"(SEM_WAIT_VALUE));
    80001b58:	02300513          	li	a0,35
    __asm__ volatile("ecall");
    80001b5c:	00000073          	ecall

    __asm__ volatile("mv %0, a0":"=r"(wait));
    80001b60:	00050513          	mv	a0,a0

    return wait;
}
    80001b64:	0005051b          	sext.w	a0,a0
    80001b68:	00813403          	ld	s0,8(sp)
    80001b6c:	01010113          	addi	sp,sp,16
    80001b70:	00008067          	ret

0000000080001b74 <_Z10sem_signalP4_sem>:


int sem_signal (sem_t id){
    80001b74:	ff010113          	addi	sp,sp,-16
    80001b78:	00813423          	sd	s0,8(sp)
    80001b7c:	01010413          	addi	s0,sp,16

    int signal;

    __asm__ volatile ("mv a1, %0"::"r"(id));
    80001b80:	00050593          	mv	a1,a0
    __asm__ volatile ("li a0, %0" : : "i"(SEM_SIGNAL_VALUE));
    80001b84:	02400513          	li	a0,36
    __asm__ volatile("ecall");
    80001b88:	00000073          	ecall

    __asm__ volatile("mv %0, a0":"=r"(signal));
    80001b8c:	00050513          	mv	a0,a0

    return signal;
}
    80001b90:	0005051b          	sext.w	a0,a0
    80001b94:	00813403          	ld	s0,8(sp)
    80001b98:	01010113          	addi	sp,sp,16
    80001b9c:	00008067          	ret

0000000080001ba0 <_Z11sem_trywaitP4_sem>:


int sem_trywait (sem_t id){
    80001ba0:	ff010113          	addi	sp,sp,-16
    80001ba4:	00813423          	sd	s0,8(sp)
    80001ba8:	01010413          	addi	s0,sp,16

    int trywait;

    __asm__ volatile ("mv a1, %0"::"r"(id));
    80001bac:	00050593          	mv	a1,a0
    __asm__ volatile ("li a0, %0" : : "i"(SEM_TRY_WAIT_VALUE));
    80001bb0:	02600513          	li	a0,38
    __asm__ volatile("ecall");
    80001bb4:	00000073          	ecall

    __asm__ volatile("mv %0, a0":"=r"(trywait));
    80001bb8:	00050513          	mv	a0,a0

    return trywait;
}
    80001bbc:	0005051b          	sext.w	a0,a0
    80001bc0:	00813403          	ld	s0,8(sp)
    80001bc4:	01010113          	addi	sp,sp,16
    80001bc8:	00008067          	ret

0000000080001bcc <_Z4getcv>:


char getc(){
    80001bcc:	ff010113          	addi	sp,sp,-16
    80001bd0:	00813423          	sd	s0,8(sp)
    80001bd4:	01010413          	addi	s0,sp,16

    char character;

    __asm__ volatile ("li a0, %0" : : "i"(GET_C_VALUE));
    80001bd8:	04100513          	li	a0,65
    __asm__ volatile("ecall");
    80001bdc:	00000073          	ecall

    __asm__ volatile("mv %0, a0":"=r"(character));
    80001be0:	00050513          	mv	a0,a0

    return character;
}
    80001be4:	0ff57513          	andi	a0,a0,255
    80001be8:	00813403          	ld	s0,8(sp)
    80001bec:	01010113          	addi	sp,sp,16
    80001bf0:	00008067          	ret

0000000080001bf4 <_Z4putcc>:


void putc(char c){
    80001bf4:	ff010113          	addi	sp,sp,-16
    80001bf8:	00813423          	sd	s0,8(sp)
    80001bfc:	01010413          	addi	s0,sp,16

    __asm__ volatile ("mv a1, %0"::"r"(c));
    80001c00:	00050593          	mv	a1,a0
    __asm__ volatile ("li a0, %0" : : "i"(PUT_C_VALUE));
    80001c04:	04200513          	li	a0,66
    __asm__ volatile("ecall");
    80001c08:	00000073          	ecall

}
    80001c0c:	00813403          	ld	s0,8(sp)
    80001c10:	01010113          	addi	sp,sp,16
    80001c14:	00008067          	ret

0000000080001c18 <_Z11getThreadIdv>:

int getThreadId(){
    80001c18:	ff010113          	addi	sp,sp,-16
    80001c1c:	00813423          	sd	s0,8(sp)
    80001c20:	01010413          	addi	s0,sp,16

    int id;

    __asm__ volatile ("li a0, %0" : : "i"(GET_ID));
    80001c24:	05000513          	li	a0,80
    __asm__ volatile("ecall");
    80001c28:	00000073          	ecall

    __asm__ volatile("mv %0, a0":"=r"(id));
    80001c2c:	00050513          	mv	a0,a0

    return id;
}
    80001c30:	0005051b          	sext.w	a0,a0
    80001c34:	00813403          	ld	s0,8(sp)
    80001c38:	01010113          	addi	sp,sp,16
    80001c3c:	00008067          	ret

0000000080001c40 <_Z41__static_initialization_and_destruction_0ii>:
void _fifoList::operator delete(void *ptr) noexcept {

    int index = (_fifoList *)ptr - allLists;
    isOccList[index] = false;

}
    80001c40:	ff010113          	addi	sp,sp,-16
    80001c44:	00813423          	sd	s0,8(sp)
    80001c48:	01010413          	addi	s0,sp,16
    80001c4c:	00100793          	li	a5,1
    80001c50:	00f50863          	beq	a0,a5,80001c60 <_Z41__static_initialization_and_destruction_0ii+0x20>
    80001c54:	00813403          	ld	s0,8(sp)
    80001c58:	01010113          	addi	sp,sp,16
    80001c5c:	00008067          	ret
    80001c60:	000107b7          	lui	a5,0x10
    80001c64:	fff78793          	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80001c68:	fef596e3          	bne	a1,a5,80001c54 <_Z41__static_initialization_and_destruction_0ii+0x14>
static node allNodes[MAX_NUM_OF_THREADS];
    80001c6c:	07f00793          	li	a5,127
    80001c70:	0007c663          	bltz	a5,80001c7c <_Z41__static_initialization_and_destruction_0ii+0x3c>
    80001c74:	fff78793          	addi	a5,a5,-1
    80001c78:	ff9ff06f          	j	80001c70 <_Z41__static_initialization_and_destruction_0ii+0x30>
static _fifoList allLists[MAX_NUM_OF_LISTS];
    80001c7c:	06300713          	li	a4,99
    80001c80:	00009797          	auipc	a5,0x9
    80001c84:	73078793          	addi	a5,a5,1840 # 8000b3b0 <_ZL8allLists>
    80001c88:	fc0746e3          	bltz	a4,80001c54 <_Z41__static_initialization_and_destruction_0ii+0x14>
    node* first;
    node* last;
public:

    _fifoList(){
        first = last = nullptr;
    80001c8c:	0007b423          	sd	zero,8(a5)
    80001c90:	0007b023          	sd	zero,0(a5)
    80001c94:	01078793          	addi	a5,a5,16
    80001c98:	fff70713          	addi	a4,a4,-1
    80001c9c:	fedff06f          	j	80001c88 <_Z41__static_initialization_and_destruction_0ii+0x48>

0000000080001ca0 <_ZN4nodenwEm>:
void *node::operator new(size_t size) {
    80001ca0:	ff010113          	addi	sp,sp,-16
    80001ca4:	00813423          	sd	s0,8(sp)
    80001ca8:	01010413          	addi	s0,sp,16
    for (int i = 0; i < MAX_NUM_OF_THREADS; i++) {
    80001cac:	00000793          	li	a5,0
    80001cb0:	0080006f          	j	80001cb8 <_ZN4nodenwEm+0x18>
    80001cb4:	0017879b          	addiw	a5,a5,1
    80001cb8:	07f00713          	li	a4,127
    80001cbc:	04f74463          	blt	a4,a5,80001d04 <_ZN4nodenwEm+0x64>
        if (!isOcc[i]) {
    80001cc0:	00009717          	auipc	a4,0x9
    80001cc4:	6f070713          	addi	a4,a4,1776 # 8000b3b0 <_ZL8allLists>
    80001cc8:	00f70733          	add	a4,a4,a5
    80001ccc:	64074703          	lbu	a4,1600(a4)
    80001cd0:	fe0712e3          	bnez	a4,80001cb4 <_ZN4nodenwEm+0x14>
            isOcc[i] = true;
    80001cd4:	00009717          	auipc	a4,0x9
    80001cd8:	6dc70713          	addi	a4,a4,1756 # 8000b3b0 <_ZL8allLists>
    80001cdc:	00f70733          	add	a4,a4,a5
    80001ce0:	00100693          	li	a3,1
    80001ce4:	64d70023          	sb	a3,1600(a4)
            return (void *) (allNodes + i);
    80001ce8:	00479793          	slli	a5,a5,0x4
    80001cec:	0000a517          	auipc	a0,0xa
    80001cf0:	dec50513          	addi	a0,a0,-532 # 8000bad8 <_ZL8allNodes>
    80001cf4:	00a78533          	add	a0,a5,a0
}
    80001cf8:	00813403          	ld	s0,8(sp)
    80001cfc:	01010113          	addi	sp,sp,16
    80001d00:	00008067          	ret
    return allNodes;
    80001d04:	0000a517          	auipc	a0,0xa
    80001d08:	dd450513          	addi	a0,a0,-556 # 8000bad8 <_ZL8allNodes>
    80001d0c:	fedff06f          	j	80001cf8 <_ZN4nodenwEm+0x58>

0000000080001d10 <_ZN9_fifoList11insertAtEndEP7_thread>:
void _fifoList::insertAtEnd(thread_t t) {
    80001d10:	fe010113          	addi	sp,sp,-32
    80001d14:	00113c23          	sd	ra,24(sp)
    80001d18:	00813823          	sd	s0,16(sp)
    80001d1c:	00913423          	sd	s1,8(sp)
    80001d20:	01213023          	sd	s2,0(sp)
    80001d24:	02010413          	addi	s0,sp,32
    80001d28:	00050493          	mv	s1,a0
    80001d2c:	00058913          	mv	s2,a1
    node* n = new node(t);
    80001d30:	01000513          	li	a0,16
    80001d34:	00000097          	auipc	ra,0x0
    80001d38:	f6c080e7          	jalr	-148(ra) # 80001ca0 <_ZN4nodenwEm>
        data = _data;
    80001d3c:	01253023          	sd	s2,0(a0)
        next = nullptr;
    80001d40:	00053423          	sd	zero,8(a0)
    if(first != nullptr){
    80001d44:	0004b783          	ld	a5,0(s1)
    80001d48:	02078463          	beqz	a5,80001d70 <_ZN9_fifoList11insertAtEndEP7_thread+0x60>
        last->next = n;
    80001d4c:	0084b783          	ld	a5,8(s1)
    80001d50:	00a7b423          	sd	a0,8(a5)
        last = n;
    80001d54:	00a4b423          	sd	a0,8(s1)
}
    80001d58:	01813083          	ld	ra,24(sp)
    80001d5c:	01013403          	ld	s0,16(sp)
    80001d60:	00813483          	ld	s1,8(sp)
    80001d64:	00013903          	ld	s2,0(sp)
    80001d68:	02010113          	addi	sp,sp,32
    80001d6c:	00008067          	ret
        first = last = n;
    80001d70:	00a4b423          	sd	a0,8(s1)
    80001d74:	00a4b023          	sd	a0,0(s1)
}
    80001d78:	fe1ff06f          	j	80001d58 <_ZN9_fifoList11insertAtEndEP7_thread+0x48>

0000000080001d7c <_ZN4nodedlEPv>:
void node::operator delete(void *ptr) noexcept {
    80001d7c:	ff010113          	addi	sp,sp,-16
    80001d80:	00813423          	sd	s0,8(sp)
    80001d84:	01010413          	addi	s0,sp,16
    int index = (node *)ptr - allNodes;
    80001d88:	0000a797          	auipc	a5,0xa
    80001d8c:	d5078793          	addi	a5,a5,-688 # 8000bad8 <_ZL8allNodes>
    80001d90:	40f50533          	sub	a0,a0,a5
    80001d94:	40455513          	srai	a0,a0,0x4
    80001d98:	0005051b          	sext.w	a0,a0
    isOcc[index] = false;
    80001d9c:	00009797          	auipc	a5,0x9
    80001da0:	61478793          	addi	a5,a5,1556 # 8000b3b0 <_ZL8allLists>
    80001da4:	00a78533          	add	a0,a5,a0
    80001da8:	64050023          	sb	zero,1600(a0)
}
    80001dac:	00813403          	ld	s0,8(sp)
    80001db0:	01010113          	addi	sp,sp,16
    80001db4:	00008067          	ret

0000000080001db8 <_ZN9_fifoList15removeFromStartEv>:
thread_t _fifoList::removeFromStart() {
    80001db8:	fe010113          	addi	sp,sp,-32
    80001dbc:	00113c23          	sd	ra,24(sp)
    80001dc0:	00813823          	sd	s0,16(sp)
    80001dc4:	00913423          	sd	s1,8(sp)
    80001dc8:	01213023          	sd	s2,0(sp)
    80001dcc:	02010413          	addi	s0,sp,32
    if(first != nullptr) {
    80001dd0:	00053903          	ld	s2,0(a0)
    80001dd4:	02090863          	beqz	s2,80001e04 <_ZN9_fifoList15removeFromStartEv+0x4c>
    80001dd8:	00050493          	mv	s1,a0
        delete(first);
    80001ddc:	00090513          	mv	a0,s2
    80001de0:	00000097          	auipc	ra,0x0
    80001de4:	f9c080e7          	jalr	-100(ra) # 80001d7c <_ZN4nodedlEPv>
        if (first == last) {
    80001de8:	0004b783          	ld	a5,0(s1)
    80001dec:	0084b703          	ld	a4,8(s1)
    80001df0:	02e78863          	beq	a5,a4,80001e20 <_ZN9_fifoList15removeFromStartEv+0x68>
            first = first->next;
    80001df4:	0087b783          	ld	a5,8(a5)
    80001df8:	00f4b023          	sd	a5,0(s1)
        n->next = nullptr;
    80001dfc:	00093423          	sd	zero,8(s2)
        return n->data;
    80001e00:	00093903          	ld	s2,0(s2)
}
    80001e04:	00090513          	mv	a0,s2
    80001e08:	01813083          	ld	ra,24(sp)
    80001e0c:	01013403          	ld	s0,16(sp)
    80001e10:	00813483          	ld	s1,8(sp)
    80001e14:	00013903          	ld	s2,0(sp)
    80001e18:	02010113          	addi	sp,sp,32
    80001e1c:	00008067          	ret
            first = last = nullptr;
    80001e20:	0004b423          	sd	zero,8(s1)
    80001e24:	0004b023          	sd	zero,0(s1)
    80001e28:	fd5ff06f          	j	80001dfc <_ZN9_fifoList15removeFromStartEv+0x44>

0000000080001e2c <_ZN9_fifoListnwEm>:
void *_fifoList::operator new(size_t size) {
    80001e2c:	ff010113          	addi	sp,sp,-16
    80001e30:	00813423          	sd	s0,8(sp)
    80001e34:	01010413          	addi	s0,sp,16
    for (int i = 0; i < MAX_NUM_OF_LISTS; i++) {
    80001e38:	00000793          	li	a5,0
    80001e3c:	0080006f          	j	80001e44 <_ZN9_fifoListnwEm+0x18>
    80001e40:	0017879b          	addiw	a5,a5,1
    80001e44:	06300713          	li	a4,99
    80001e48:	04f74063          	blt	a4,a5,80001e88 <_ZN9_fifoListnwEm+0x5c>
        if (!isOccList[i]) {
    80001e4c:	00009717          	auipc	a4,0x9
    80001e50:	56470713          	addi	a4,a4,1380 # 8000b3b0 <_ZL8allLists>
    80001e54:	00f70733          	add	a4,a4,a5
    80001e58:	6c074703          	lbu	a4,1728(a4)
    80001e5c:	fe0712e3          	bnez	a4,80001e40 <_ZN9_fifoListnwEm+0x14>
            isOccList[i] = true;
    80001e60:	00009517          	auipc	a0,0x9
    80001e64:	55050513          	addi	a0,a0,1360 # 8000b3b0 <_ZL8allLists>
    80001e68:	00f50733          	add	a4,a0,a5
    80001e6c:	00100693          	li	a3,1
    80001e70:	6cd70023          	sb	a3,1728(a4)
            return (void *) (allLists + i);
    80001e74:	00479793          	slli	a5,a5,0x4
    80001e78:	00f50533          	add	a0,a0,a5
}
    80001e7c:	00813403          	ld	s0,8(sp)
    80001e80:	01010113          	addi	sp,sp,16
    80001e84:	00008067          	ret
    return allLists;
    80001e88:	00009517          	auipc	a0,0x9
    80001e8c:	52850513          	addi	a0,a0,1320 # 8000b3b0 <_ZL8allLists>
    80001e90:	fedff06f          	j	80001e7c <_ZN9_fifoListnwEm+0x50>

0000000080001e94 <_ZN9_fifoListdlEPv>:
void _fifoList::operator delete(void *ptr) noexcept {
    80001e94:	ff010113          	addi	sp,sp,-16
    80001e98:	00813423          	sd	s0,8(sp)
    80001e9c:	01010413          	addi	s0,sp,16
    int index = (_fifoList *)ptr - allLists;
    80001ea0:	00009797          	auipc	a5,0x9
    80001ea4:	51078793          	addi	a5,a5,1296 # 8000b3b0 <_ZL8allLists>
    80001ea8:	40f50533          	sub	a0,a0,a5
    80001eac:	40455513          	srai	a0,a0,0x4
    80001eb0:	0005051b          	sext.w	a0,a0
    isOccList[index] = false;
    80001eb4:	00a78533          	add	a0,a5,a0
    80001eb8:	6c050023          	sb	zero,1728(a0)
}
    80001ebc:	00813403          	ld	s0,8(sp)
    80001ec0:	01010113          	addi	sp,sp,16
    80001ec4:	00008067          	ret

0000000080001ec8 <_GLOBAL__sub_I__ZN9_fifoList11insertAtEndEP7_thread>:
    80001ec8:	ff010113          	addi	sp,sp,-16
    80001ecc:	00113423          	sd	ra,8(sp)
    80001ed0:	00813023          	sd	s0,0(sp)
    80001ed4:	01010413          	addi	s0,sp,16
    80001ed8:	000105b7          	lui	a1,0x10
    80001edc:	fff58593          	addi	a1,a1,-1 # ffff <_entry-0x7fff0001>
    80001ee0:	00100513          	li	a0,1
    80001ee4:	00000097          	auipc	ra,0x0
    80001ee8:	d5c080e7          	jalr	-676(ra) # 80001c40 <_Z41__static_initialization_and_destruction_0ii>
    80001eec:	00813083          	ld	ra,8(sp)
    80001ef0:	00013403          	ld	s0,0(sp)
    80001ef4:	01010113          	addi	sp,sp,16
    80001ef8:	00008067          	ret

0000000080001efc <_ZN7_thread13threadWrapperEv>:
    _thread::__main_thread_create();
}


int thread_exit();
void _thread::threadWrapper() {
    80001efc:	ff010113          	addi	sp,sp,-16
    80001f00:	00113423          	sd	ra,8(sp)
    80001f04:	00813023          	sd	s0,0(sp)
    80001f08:	01010413          	addi	s0,sp,16
    running->body(running->arg);
    80001f0c:	0000a797          	auipc	a5,0xa
    80001f10:	3cc7b783          	ld	a5,972(a5) # 8000c2d8 <running>
    80001f14:	00001737          	lui	a4,0x1
    80001f18:	00e787b3          	add	a5,a5,a4
    80001f1c:	0387b703          	ld	a4,56(a5)
    80001f20:	0407b503          	ld	a0,64(a5)
    80001f24:	000700e7          	jalr	a4 # 1000 <_entry-0x7ffff000>
    thread_exit();
    80001f28:	00000097          	auipc	ra,0x0
    80001f2c:	b58080e7          	jalr	-1192(ra) # 80001a80 <_Z11thread_exitv>

}
    80001f30:	00813083          	ld	ra,8(sp)
    80001f34:	00013403          	ld	s0,0(sp)
    80001f38:	01010113          	addi	sp,sp,16
    80001f3c:	00008067          	ret

0000000080001f40 <_ZN7_threadC1Ev>:
_thread::_thread() {
    80001f40:	ff010113          	addi	sp,sp,-16
    80001f44:	00813423          	sd	s0,8(sp)
    80001f48:	01010413          	addi	s0,sp,16
    80001f4c:	000016b7          	lui	a3,0x1
    80001f50:	00d507b3          	add	a5,a0,a3
    80001f54:	0407b423          	sd	zero,72(a5)
    this->body = nullptr;
    80001f58:	0207bc23          	sd	zero,56(a5)
    this->arg = nullptr;
    80001f5c:	0407b023          	sd	zero,64(a5)
    this->stek = nullptr;
    80001f60:	0207b423          	sd	zero,40(a5)
    this->status = READY;
    80001f64:	00100713          	li	a4,1
    80001f68:	02e7b823          	sd	a4,48(a5)
    running = this;
    80001f6c:	0000a717          	auipc	a4,0xa
    80001f70:	36a73623          	sd	a0,876(a4) # 8000c2d8 <running>
    this->context.ssp = (uint64) sstek + SSTEK_SPACE;
    80001f74:	02850713          	addi	a4,a0,40
    80001f78:	00d70733          	add	a4,a4,a3
    80001f7c:	00e53c23          	sd	a4,24(a0)
    this->context.ra = (uint64)start_thread;
    80001f80:	00009717          	auipc	a4,0x9
    80001f84:	3a873703          	ld	a4,936(a4) # 8000b328 <_GLOBAL_OFFSET_TABLE_+0x8>
    80001f88:	02e53023          	sd	a4,32(a0)
    this->rezim = SSTATUS_FOR_SUPERVISOR;
    80001f8c:	12000713          	li	a4,288
    80001f90:	00e53823          	sd	a4,16(a0)
    this->id = 0;
    80001f94:	0407a823          	sw	zero,80(a5)
}
    80001f98:	00813403          	ld	s0,8(sp)
    80001f9c:	01010113          	addi	sp,sp,16
    80001fa0:	00008067          	ret

0000000080001fa4 <_Z41__static_initialization_and_destruction_0ii>:
}

int _thread::getThreadId(){
    //__thread_dispatch();
    return running->id;
}
    80001fa4:	00100793          	li	a5,1
    80001fa8:	00f50463          	beq	a0,a5,80001fb0 <_Z41__static_initialization_and_destruction_0ii+0xc>
    80001fac:	00008067          	ret
    80001fb0:	000107b7          	lui	a5,0x10
    80001fb4:	fff78793          	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80001fb8:	fef59ae3          	bne	a1,a5,80001fac <_Z41__static_initialization_and_destruction_0ii+0x8>
    80001fbc:	fe010113          	addi	sp,sp,-32
    80001fc0:	00113c23          	sd	ra,24(sp)
    80001fc4:	00813823          	sd	s0,16(sp)
    80001fc8:	00913423          	sd	s1,8(sp)
    80001fcc:	01213023          	sd	s2,0(sp)
    80001fd0:	02010413          	addi	s0,sp,32
static _thread allThreads[MAX_NUM_OF_THREADS];
    80001fd4:	07f00493          	li	s1,127
    80001fd8:	0000a917          	auipc	s2,0xa
    80001fdc:	39090913          	addi	s2,s2,912 # 8000c368 <_ZL10allThreads>
    80001fe0:	0204c263          	bltz	s1,80002004 <_Z41__static_initialization_and_destruction_0ii+0x60>
    80001fe4:	00090513          	mv	a0,s2
    80001fe8:	00000097          	auipc	ra,0x0
    80001fec:	f58080e7          	jalr	-168(ra) # 80001f40 <_ZN7_threadC1Ev>
    80001ff0:	000017b7          	lui	a5,0x1
    80001ff4:	05878793          	addi	a5,a5,88 # 1058 <_entry-0x7fffefa8>
    80001ff8:	00f90933          	add	s2,s2,a5
    80001ffc:	fff48493          	addi	s1,s1,-1
    80002000:	fe1ff06f          	j	80001fe0 <_Z41__static_initialization_and_destruction_0ii+0x3c>
}
    80002004:	01813083          	ld	ra,24(sp)
    80002008:	01013403          	ld	s0,16(sp)
    8000200c:	00813483          	ld	s1,8(sp)
    80002010:	00013903          	ld	s2,0(sp)
    80002014:	02010113          	addi	sp,sp,32
    80002018:	00008067          	ret

000000008000201c <_ZN7_threadC1EPvPFvS0_ES0_>:
_thread::_thread(void *stek, void (*body)(void *), void *arg) {
    8000201c:	ff010113          	addi	sp,sp,-16
    80002020:	00813423          	sd	s0,8(sp)
    80002024:	01010413          	addi	s0,sp,16
    80002028:	000017b7          	lui	a5,0x1
    8000202c:	00f50733          	add	a4,a0,a5
    80002030:	04073423          	sd	zero,72(a4)
    this->stek = stek;
    80002034:	02b73423          	sd	a1,40(a4)
    this->body = body;
    80002038:	02c73c23          	sd	a2,56(a4)
    this->arg = arg;
    8000203c:	04d73023          	sd	a3,64(a4)
    this->sp = (uint64)stek + DEFAULT_STACK_SIZE-256;
    80002040:	f0078793          	addi	a5,a5,-256 # f00 <_entry-0x7ffff100>
    80002044:	00f585b3          	add	a1,a1,a5
    80002048:	00b53023          	sd	a1,0(a0)
    for(int i=1; i<32;i++){
    8000204c:	00100793          	li	a5,1
    80002050:	0180006f          	j	80002068 <_ZN7_threadC1EPvPFvS0_ES0_+0x4c>
        ((uint64*)sp)[i] = 0;
    80002054:	00053683          	ld	a3,0(a0)
    80002058:	00379713          	slli	a4,a5,0x3
    8000205c:	00d70733          	add	a4,a4,a3
    80002060:	00073023          	sd	zero,0(a4)
    for(int i=1; i<32;i++){
    80002064:	0017879b          	addiw	a5,a5,1
    80002068:	01f00713          	li	a4,31
    8000206c:	fef754e3          	bge	a4,a5,80002054 <_ZN7_threadC1EPvPFvS0_ES0_+0x38>
    this->status = READY;
    80002070:	000017b7          	lui	a5,0x1
    80002074:	00f506b3          	add	a3,a0,a5
    80002078:	00100713          	li	a4,1
    8000207c:	02e6b823          	sd	a4,48(a3) # 1030 <_entry-0x7fffefd0>
    this->pc = (uint64)threadWrapper;
    80002080:	00000717          	auipc	a4,0x0
    80002084:	e7c70713          	addi	a4,a4,-388 # 80001efc <_ZN7_thread13threadWrapperEv>
    80002088:	00e53423          	sd	a4,8(a0)
    this->context.ssp = (uint64) sstek + SSTEK_SPACE - 256;
    8000208c:	02850713          	addi	a4,a0,40
    80002090:	f0078793          	addi	a5,a5,-256 # f00 <_entry-0x7ffff100>
    80002094:	00f707b3          	add	a5,a4,a5
    80002098:	00f53c23          	sd	a5,24(a0)
    this->context.ra = (uint64)start_thread;
    8000209c:	00009797          	auipc	a5,0x9
    800020a0:	28c7b783          	ld	a5,652(a5) # 8000b328 <_GLOBAL_OFFSET_TABLE_+0x8>
    800020a4:	02f53023          	sd	a5,32(a0)
    this->rezim = SSTATUS_FOR_USER;
    800020a8:	02000793          	li	a5,32
    800020ac:	00f53823          	sd	a5,16(a0)
    globalId++;
    800020b0:	0000a717          	auipc	a4,0xa
    800020b4:	22870713          	addi	a4,a4,552 # 8000c2d8 <running>
    800020b8:	00872783          	lw	a5,8(a4)
    800020bc:	0017879b          	addiw	a5,a5,1
    800020c0:	00f72423          	sw	a5,8(a4)
    this->id = globalId;
    800020c4:	04f6a823          	sw	a5,80(a3)
}
    800020c8:	00813403          	ld	s0,8(sp)
    800020cc:	01010113          	addi	sp,sp,16
    800020d0:	00008067          	ret

00000000800020d4 <_ZN7_thread10getRunningEv>:
thread_t _thread::getRunning(){
    800020d4:	ff010113          	addi	sp,sp,-16
    800020d8:	00813423          	sd	s0,8(sp)
    800020dc:	01010413          	addi	s0,sp,16
}
    800020e0:	0000a517          	auipc	a0,0xa
    800020e4:	1f853503          	ld	a0,504(a0) # 8000c2d8 <running>
    800020e8:	00813403          	ld	s0,8(sp)
    800020ec:	01010113          	addi	sp,sp,16
    800020f0:	00008067          	ret

00000000800020f4 <_ZN7_thread10setRunningEPS_>:
void _thread::setRunning(thread_t t){
    800020f4:	ff010113          	addi	sp,sp,-16
    800020f8:	00813423          	sd	s0,8(sp)
    800020fc:	01010413          	addi	s0,sp,16
    running = t;
    80002100:	0000a797          	auipc	a5,0xa
    80002104:	1ca7bc23          	sd	a0,472(a5) # 8000c2d8 <running>
}
    80002108:	00813403          	ld	s0,8(sp)
    8000210c:	01010113          	addi	sp,sp,16
    80002110:	00008067          	ret

0000000080002114 <_ZN7_threadnwEm>:
void * _thread::operator new(size_t size) {
    80002114:	ff010113          	addi	sp,sp,-16
    80002118:	00813423          	sd	s0,8(sp)
    8000211c:	01010413          	addi	s0,sp,16
    for(int i =0; i<MAX_NUM_OF_THREADS;i++){
    80002120:	00000793          	li	a5,0
    80002124:	0080006f          	j	8000212c <_ZN7_threadnwEm+0x18>
    80002128:	0017879b          	addiw	a5,a5,1
    8000212c:	07f00713          	li	a4,127
    80002130:	04f74863          	blt	a4,a5,80002180 <_ZN7_threadnwEm+0x6c>
        if(!isOcc[i]){
    80002134:	0000a717          	auipc	a4,0xa
    80002138:	1a470713          	addi	a4,a4,420 # 8000c2d8 <running>
    8000213c:	00f70733          	add	a4,a4,a5
    80002140:	01074703          	lbu	a4,16(a4)
    80002144:	fe0712e3          	bnez	a4,80002128 <_ZN7_threadnwEm+0x14>
            isOcc[i]= true;
    80002148:	0000a717          	auipc	a4,0xa
    8000214c:	19070713          	addi	a4,a4,400 # 8000c2d8 <running>
    80002150:	00f70733          	add	a4,a4,a5
    80002154:	00100693          	li	a3,1
    80002158:	00d70823          	sb	a3,16(a4)
            return (void*)(allThreads+i);
    8000215c:	00001537          	lui	a0,0x1
    80002160:	05850513          	addi	a0,a0,88 # 1058 <_entry-0x7fffefa8>
    80002164:	02a787b3          	mul	a5,a5,a0
    80002168:	0000a517          	auipc	a0,0xa
    8000216c:	20050513          	addi	a0,a0,512 # 8000c368 <_ZL10allThreads>
    80002170:	00a78533          	add	a0,a5,a0
}
    80002174:	00813403          	ld	s0,8(sp)
    80002178:	01010113          	addi	sp,sp,16
    8000217c:	00008067          	ret
    return allThreads;
    80002180:	0000a517          	auipc	a0,0xa
    80002184:	1e850513          	addi	a0,a0,488 # 8000c368 <_ZL10allThreads>
    80002188:	fedff06f          	j	80002174 <_ZN7_threadnwEm+0x60>

000000008000218c <_ZN7_threaddlEPv>:
void _thread::operator delete(void *ptr) noexcept {
    8000218c:	ff010113          	addi	sp,sp,-16
    80002190:	00813423          	sd	s0,8(sp)
    80002194:	01010413          	addi	s0,sp,16
    int index = (_thread*)ptr - allThreads;
    80002198:	0000a797          	auipc	a5,0xa
    8000219c:	1d078793          	addi	a5,a5,464 # 8000c368 <_ZL10allThreads>
    800021a0:	40f50533          	sub	a0,a0,a5
    800021a4:	40355513          	srai	a0,a0,0x3
    800021a8:	00007797          	auipc	a5,0x7
    800021ac:	f007b783          	ld	a5,-256(a5) # 800090a8 <CONSOLE_STATUS+0x98>
    800021b0:	02f5053b          	mulw	a0,a0,a5
    isOcc[index] = false;
    800021b4:	0000a797          	auipc	a5,0xa
    800021b8:	12478793          	addi	a5,a5,292 # 8000c2d8 <running>
    800021bc:	00a78533          	add	a0,a5,a0
    800021c0:	00050823          	sb	zero,16(a0)
}
    800021c4:	00813403          	ld	s0,8(sp)
    800021c8:	01010113          	addi	sp,sp,16
    800021cc:	00008067          	ret

00000000800021d0 <_ZN7_thread15__thread_createEPPS_PFvPvES2_S2_>:
int _thread::__thread_create(thread_t *handle, void (*start_routine)(void *), void *arg, void *stack) {
    800021d0:	fc010113          	addi	sp,sp,-64
    800021d4:	02113c23          	sd	ra,56(sp)
    800021d8:	02813823          	sd	s0,48(sp)
    800021dc:	02913423          	sd	s1,40(sp)
    800021e0:	03213023          	sd	s2,32(sp)
    800021e4:	01313c23          	sd	s3,24(sp)
    800021e8:	01413823          	sd	s4,16(sp)
    800021ec:	01513423          	sd	s5,8(sp)
    800021f0:	04010413          	addi	s0,sp,64
    800021f4:	00050913          	mv	s2,a0
    800021f8:	00058a13          	mv	s4,a1
    800021fc:	00060a93          	mv	s5,a2
    80002200:	00068993          	mv	s3,a3
    *handle = new _thread(stack,start_routine,arg);
    80002204:	00001537          	lui	a0,0x1
    80002208:	05850513          	addi	a0,a0,88 # 1058 <_entry-0x7fffefa8>
    8000220c:	00000097          	auipc	ra,0x0
    80002210:	f08080e7          	jalr	-248(ra) # 80002114 <_ZN7_threadnwEm>
    80002214:	00050493          	mv	s1,a0
    80002218:	000a8693          	mv	a3,s5
    8000221c:	000a0613          	mv	a2,s4
    80002220:	00098593          	mv	a1,s3
    80002224:	00000097          	auipc	ra,0x0
    80002228:	df8080e7          	jalr	-520(ra) # 8000201c <_ZN7_threadC1EPvPFvS0_ES0_>
    8000222c:	00993023          	sd	s1,0(s2)
    if(*handle == nullptr) return NO_MEMORY;
    80002230:	0a048663          	beqz	s1,800022dc <_ZN7_thread15__thread_createEPPS_PFvPvES2_S2_+0x10c>

public:

    static Scheduler* getInstance(){

        if(instance == 0){
    80002234:	00009797          	auipc	a5,0x9
    80002238:	1047b783          	ld	a5,260(a5) # 8000b338 <_GLOBAL_OFFSET_TABLE_+0x18>
    8000223c:	0007b783          	ld	a5,0(a5)
    80002240:	04078463          	beqz	a5,80002288 <_ZN7_thread15__thread_createEPPS_PFvPvES2_S2_+0xb8>
            instance = new Scheduler();
        }

        return instance;
    80002244:	00009797          	auipc	a5,0x9
    80002248:	0f47b783          	ld	a5,244(a5) # 8000b338 <_GLOBAL_OFFSET_TABLE_+0x18>
    8000224c:	0007b783          	ld	a5,0(a5)
    }

    void put(thread_t t){
        lista->insertAtEnd(t);
    80002250:	00093583          	ld	a1,0(s2)
    80002254:	0007b503          	ld	a0,0(a5)
    80002258:	00000097          	auipc	ra,0x0
    8000225c:	ab8080e7          	jalr	-1352(ra) # 80001d10 <_ZN9_fifoList11insertAtEndEP7_thread>
    return 0;
    80002260:	00000513          	li	a0,0
}
    80002264:	03813083          	ld	ra,56(sp)
    80002268:	03013403          	ld	s0,48(sp)
    8000226c:	02813483          	ld	s1,40(sp)
    80002270:	02013903          	ld	s2,32(sp)
    80002274:	01813983          	ld	s3,24(sp)
    80002278:	01013a03          	ld	s4,16(sp)
    8000227c:	00813a83          	ld	s5,8(sp)
    80002280:	04010113          	addi	sp,sp,64
    80002284:	00008067          	ret
            instance = new Scheduler();
    80002288:	00800513          	li	a0,8
    8000228c:	00000097          	auipc	ra,0x0
    80002290:	5a4080e7          	jalr	1444(ra) # 80002830 <_ZN9SchedulernwEm>
    80002294:	00050493          	mv	s1,a0
        lista = new _fifoList();
    80002298:	01000513          	li	a0,16
    8000229c:	00000097          	auipc	ra,0x0
    800022a0:	b90080e7          	jalr	-1136(ra) # 80001e2c <_ZN9_fifoListnwEm>
    node* first;
    node* last;
public:

    _fifoList(){
        first = last = nullptr;
    800022a4:	00053423          	sd	zero,8(a0)
    800022a8:	00053023          	sd	zero,0(a0)
    800022ac:	00a4b023          	sd	a0,0(s1)
            instance = new Scheduler();
    800022b0:	00009797          	auipc	a5,0x9
    800022b4:	0887b783          	ld	a5,136(a5) # 8000b338 <_GLOBAL_OFFSET_TABLE_+0x18>
    800022b8:	0097b023          	sd	s1,0(a5)
    800022bc:	f89ff06f          	j	80002244 <_ZN7_thread15__thread_createEPPS_PFvPvES2_S2_+0x74>
    800022c0:	00050913          	mv	s2,a0
    800022c4:	00048513          	mv	a0,s1
    800022c8:	00000097          	auipc	ra,0x0
    800022cc:	5a8080e7          	jalr	1448(ra) # 80002870 <_ZN9SchedulerdlEPv>
    800022d0:	00090513          	mv	a0,s2
    800022d4:	0008e097          	auipc	ra,0x8e
    800022d8:	764080e7          	jalr	1892(ra) # 80090a38 <_Unwind_Resume>
    if(*handle == nullptr) return NO_MEMORY;
    800022dc:	fff00513          	li	a0,-1
    800022e0:	f85ff06f          	j	80002264 <_ZN7_thread15__thread_createEPPS_PFvPvES2_S2_+0x94>

00000000800022e4 <_ZN7_thread20__main_thread_createEv>:
int _thread::__main_thread_create(){
    800022e4:	ff010113          	addi	sp,sp,-16
    800022e8:	00113423          	sd	ra,8(sp)
    800022ec:	00813023          	sd	s0,0(sp)
    800022f0:	01010413          	addi	s0,sp,16
    new _thread();
    800022f4:	00001537          	lui	a0,0x1
    800022f8:	05850513          	addi	a0,a0,88 # 1058 <_entry-0x7fffefa8>
    800022fc:	00000097          	auipc	ra,0x0
    80002300:	e18080e7          	jalr	-488(ra) # 80002114 <_ZN7_threadnwEm>
    80002304:	00000097          	auipc	ra,0x0
    80002308:	c3c080e7          	jalr	-964(ra) # 80001f40 <_ZN7_threadC1Ev>
}
    8000230c:	00000513          	li	a0,0
    80002310:	00813083          	ld	ra,8(sp)
    80002314:	00013403          	ld	s0,0(sp)
    80002318:	01010113          	addi	sp,sp,16
    8000231c:	00008067          	ret

0000000080002320 <_Z14initMainThreadv>:
void initMainThread(){
    80002320:	ff010113          	addi	sp,sp,-16
    80002324:	00113423          	sd	ra,8(sp)
    80002328:	00813023          	sd	s0,0(sp)
    8000232c:	01010413          	addi	s0,sp,16
    _thread::__main_thread_create();
    80002330:	00000097          	auipc	ra,0x0
    80002334:	fb4080e7          	jalr	-76(ra) # 800022e4 <_ZN7_thread20__main_thread_createEv>
}
    80002338:	00813083          	ld	ra,8(sp)
    8000233c:	00013403          	ld	s0,0(sp)
    80002340:	01010113          	addi	sp,sp,16
    80002344:	00008067          	ret

0000000080002348 <_ZN7_thread17__thread_dispatchEv>:
void _thread::__thread_dispatch(){
    80002348:	fe010113          	addi	sp,sp,-32
    8000234c:	00113c23          	sd	ra,24(sp)
    80002350:	00813823          	sd	s0,16(sp)
    80002354:	00913423          	sd	s1,8(sp)
    80002358:	01213023          	sd	s2,0(sp)
    8000235c:	02010413          	addi	s0,sp,32
    thread_t oldThread = running;
    80002360:	0000a497          	auipc	s1,0xa
    80002364:	f784b483          	ld	s1,-136(s1) # 8000c2d8 <running>
    if(oldThread->status == READY){
    80002368:	000017b7          	lui	a5,0x1
    8000236c:	00f487b3          	add	a5,s1,a5
    80002370:	0307b703          	ld	a4,48(a5) # 1030 <_entry-0x7fffefd0>
    80002374:	00100793          	li	a5,1
    80002378:	06f70063          	beq	a4,a5,800023d8 <_ZN7_thread17__thread_dispatchEv+0x90>
        if(instance == 0){
    8000237c:	00009797          	auipc	a5,0x9
    80002380:	fbc7b783          	ld	a5,-68(a5) # 8000b338 <_GLOBAL_OFFSET_TABLE_+0x18>
    80002384:	0007b783          	ld	a5,0(a5)
    80002388:	0c078a63          	beqz	a5,8000245c <_ZN7_thread17__thread_dispatchEv+0x114>
        return instance;
    8000238c:	00009797          	auipc	a5,0x9
    80002390:	fac7b783          	ld	a5,-84(a5) # 8000b338 <_GLOBAL_OFFSET_TABLE_+0x18>
    80002394:	0007b783          	ld	a5,0(a5)
    }

    thread_t get(){
        return lista->removeFromStart();
    80002398:	0007b503          	ld	a0,0(a5)
    8000239c:	00000097          	auipc	ra,0x0
    800023a0:	a1c080e7          	jalr	-1508(ra) # 80001db8 <_ZN9_fifoList15removeFromStartEv>
    if(oldThread == newThread) return;
    800023a4:	00a48e63          	beq	s1,a0,800023c0 <_ZN7_thread17__thread_dispatchEv+0x78>
    running = newThread;
    800023a8:	0000a797          	auipc	a5,0xa
    800023ac:	f2a7b823          	sd	a0,-208(a5) # 8000c2d8 <running>
    context_switch(&(oldThread->context), &(newThread->context));
    800023b0:	01850593          	addi	a1,a0,24
    800023b4:	01848513          	addi	a0,s1,24
    800023b8:	fffff097          	auipc	ra,0xfffff
    800023bc:	fc8080e7          	jalr	-56(ra) # 80001380 <context_switch>
}
    800023c0:	01813083          	ld	ra,24(sp)
    800023c4:	01013403          	ld	s0,16(sp)
    800023c8:	00813483          	ld	s1,8(sp)
    800023cc:	00013903          	ld	s2,0(sp)
    800023d0:	02010113          	addi	sp,sp,32
    800023d4:	00008067          	ret
        if(instance == 0){
    800023d8:	00009797          	auipc	a5,0x9
    800023dc:	f607b783          	ld	a5,-160(a5) # 8000b338 <_GLOBAL_OFFSET_TABLE_+0x18>
    800023e0:	0007b783          	ld	a5,0(a5)
    800023e4:	02078263          	beqz	a5,80002408 <_ZN7_thread17__thread_dispatchEv+0xc0>
        return instance;
    800023e8:	00009797          	auipc	a5,0x9
    800023ec:	f507b783          	ld	a5,-176(a5) # 8000b338 <_GLOBAL_OFFSET_TABLE_+0x18>
    800023f0:	0007b783          	ld	a5,0(a5)
        lista->insertAtEnd(t);
    800023f4:	00048593          	mv	a1,s1
    800023f8:	0007b503          	ld	a0,0(a5)
    800023fc:	00000097          	auipc	ra,0x0
    80002400:	914080e7          	jalr	-1772(ra) # 80001d10 <_ZN9_fifoList11insertAtEndEP7_thread>
    }
    80002404:	f79ff06f          	j	8000237c <_ZN7_thread17__thread_dispatchEv+0x34>
            instance = new Scheduler();
    80002408:	00800513          	li	a0,8
    8000240c:	00000097          	auipc	ra,0x0
    80002410:	424080e7          	jalr	1060(ra) # 80002830 <_ZN9SchedulernwEm>
    80002414:	00050913          	mv	s2,a0
        lista = new _fifoList();
    80002418:	01000513          	li	a0,16
    8000241c:	00000097          	auipc	ra,0x0
    80002420:	a10080e7          	jalr	-1520(ra) # 80001e2c <_ZN9_fifoListnwEm>
    80002424:	00053423          	sd	zero,8(a0)
    80002428:	00053023          	sd	zero,0(a0)
    8000242c:	00a93023          	sd	a0,0(s2)
            instance = new Scheduler();
    80002430:	00009797          	auipc	a5,0x9
    80002434:	f087b783          	ld	a5,-248(a5) # 8000b338 <_GLOBAL_OFFSET_TABLE_+0x18>
    80002438:	0127b023          	sd	s2,0(a5)
    8000243c:	fadff06f          	j	800023e8 <_ZN7_thread17__thread_dispatchEv+0xa0>
    80002440:	00050493          	mv	s1,a0
    80002444:	00090513          	mv	a0,s2
    80002448:	00000097          	auipc	ra,0x0
    8000244c:	428080e7          	jalr	1064(ra) # 80002870 <_ZN9SchedulerdlEPv>
    80002450:	00048513          	mv	a0,s1
    80002454:	0008e097          	auipc	ra,0x8e
    80002458:	5e4080e7          	jalr	1508(ra) # 80090a38 <_Unwind_Resume>
    8000245c:	00800513          	li	a0,8
    80002460:	00000097          	auipc	ra,0x0
    80002464:	3d0080e7          	jalr	976(ra) # 80002830 <_ZN9SchedulernwEm>
    80002468:	00050913          	mv	s2,a0
        lista = new _fifoList();
    8000246c:	01000513          	li	a0,16
    80002470:	00000097          	auipc	ra,0x0
    80002474:	9bc080e7          	jalr	-1604(ra) # 80001e2c <_ZN9_fifoListnwEm>
    80002478:	00053423          	sd	zero,8(a0)
    8000247c:	00053023          	sd	zero,0(a0)
    80002480:	00a93023          	sd	a0,0(s2)
            instance = new Scheduler();
    80002484:	00009797          	auipc	a5,0x9
    80002488:	eb47b783          	ld	a5,-332(a5) # 8000b338 <_GLOBAL_OFFSET_TABLE_+0x18>
    8000248c:	0127b023          	sd	s2,0(a5)
    80002490:	efdff06f          	j	8000238c <_ZN7_thread17__thread_dispatchEv+0x44>
    80002494:	00050493          	mv	s1,a0
    80002498:	00090513          	mv	a0,s2
    8000249c:	00000097          	auipc	ra,0x0
    800024a0:	3d4080e7          	jalr	980(ra) # 80002870 <_ZN9SchedulerdlEPv>
    800024a4:	00048513          	mv	a0,s1
    800024a8:	0008e097          	auipc	ra,0x8e
    800024ac:	590080e7          	jalr	1424(ra) # 80090a38 <_Unwind_Resume>

00000000800024b0 <_ZN7_thread13__thread_exitEv>:
int _thread::__thread_exit(){
    800024b0:	fe010113          	addi	sp,sp,-32
    800024b4:	00113c23          	sd	ra,24(sp)
    800024b8:	00813823          	sd	s0,16(sp)
    800024bc:	00913423          	sd	s1,8(sp)
    800024c0:	01213023          	sd	s2,0(sp)
    800024c4:	02010413          	addi	s0,sp,32
    running->status = FINISHED;
    800024c8:	0000a797          	auipc	a5,0xa
    800024cc:	e107b783          	ld	a5,-496(a5) # 8000c2d8 <running>
    800024d0:	00001737          	lui	a4,0x1
    800024d4:	00e787b3          	add	a5,a5,a4
    800024d8:	00300713          	li	a4,3
    800024dc:	02e7b823          	sd	a4,48(a5)
    if(running->joinQueue){
    800024e0:	0487b503          	ld	a0,72(a5)
    800024e4:	0e050e63          	beqz	a0,800025e0 <_ZN7_thread13__thread_exitEv+0x130>
        thread_t t = running->joinQueue->removeFromStart();
    800024e8:	00000097          	auipc	ra,0x0
    800024ec:	8d0080e7          	jalr	-1840(ra) # 80001db8 <_ZN9_fifoList15removeFromStartEv>
    800024f0:	00050493          	mv	s1,a0
    800024f4:	0580006f          	j	8000254c <_ZN7_thread13__thread_exitEv+0x9c>
    800024f8:	00053423          	sd	zero,8(a0)
    800024fc:	00053023          	sd	zero,0(a0)
        lista = new _fifoList();
    80002500:	00a93023          	sd	a0,0(s2)
            instance = new Scheduler();
    80002504:	00009797          	auipc	a5,0x9
    80002508:	e347b783          	ld	a5,-460(a5) # 8000b338 <_GLOBAL_OFFSET_TABLE_+0x18>
    8000250c:	0127b023          	sd	s2,0(a5)
        return instance;
    80002510:	00009797          	auipc	a5,0x9
    80002514:	e287b783          	ld	a5,-472(a5) # 8000b338 <_GLOBAL_OFFSET_TABLE_+0x18>
    80002518:	0007b783          	ld	a5,0(a5)
        lista->insertAtEnd(t);
    8000251c:	00048593          	mv	a1,s1
    80002520:	0007b503          	ld	a0,0(a5)
    80002524:	fffff097          	auipc	ra,0xfffff
    80002528:	7ec080e7          	jalr	2028(ra) # 80001d10 <_ZN9_fifoList11insertAtEndEP7_thread>
            t = running->joinQueue->removeFromStart();
    8000252c:	0000a797          	auipc	a5,0xa
    80002530:	dac7b783          	ld	a5,-596(a5) # 8000c2d8 <running>
    80002534:	00001737          	lui	a4,0x1
    80002538:	00e787b3          	add	a5,a5,a4
    8000253c:	0487b503          	ld	a0,72(a5)
    80002540:	00000097          	auipc	ra,0x0
    80002544:	878080e7          	jalr	-1928(ra) # 80001db8 <_ZN9_fifoList15removeFromStartEv>
    80002548:	00050493          	mv	s1,a0
        while(t!= nullptr){
    8000254c:	06048063          	beqz	s1,800025ac <_ZN7_thread13__thread_exitEv+0xfc>
            t->status = READY;
    80002550:	000017b7          	lui	a5,0x1
    80002554:	00f487b3          	add	a5,s1,a5
    80002558:	00100713          	li	a4,1
    8000255c:	02e7b823          	sd	a4,48(a5) # 1030 <_entry-0x7fffefd0>
        if(instance == 0){
    80002560:	00009797          	auipc	a5,0x9
    80002564:	dd87b783          	ld	a5,-552(a5) # 8000b338 <_GLOBAL_OFFSET_TABLE_+0x18>
    80002568:	0007b783          	ld	a5,0(a5)
    8000256c:	fa0792e3          	bnez	a5,80002510 <_ZN7_thread13__thread_exitEv+0x60>
            instance = new Scheduler();
    80002570:	00800513          	li	a0,8
    80002574:	00000097          	auipc	ra,0x0
    80002578:	2bc080e7          	jalr	700(ra) # 80002830 <_ZN9SchedulernwEm>
    8000257c:	00050913          	mv	s2,a0
        lista = new _fifoList();
    80002580:	01000513          	li	a0,16
    80002584:	00000097          	auipc	ra,0x0
    80002588:	8a8080e7          	jalr	-1880(ra) # 80001e2c <_ZN9_fifoListnwEm>
    8000258c:	f6dff06f          	j	800024f8 <_ZN7_thread13__thread_exitEv+0x48>
    80002590:	00050493          	mv	s1,a0
            instance = new Scheduler();
    80002594:	00090513          	mv	a0,s2
    80002598:	00000097          	auipc	ra,0x0
    8000259c:	2d8080e7          	jalr	728(ra) # 80002870 <_ZN9SchedulerdlEPv>
    800025a0:	00048513          	mv	a0,s1
    800025a4:	0008e097          	auipc	ra,0x8e
    800025a8:	494080e7          	jalr	1172(ra) # 80090a38 <_Unwind_Resume>
        delete running->joinQueue;
    800025ac:	0000a797          	auipc	a5,0xa
    800025b0:	d2c7b783          	ld	a5,-724(a5) # 8000c2d8 <running>
    800025b4:	00001737          	lui	a4,0x1
    800025b8:	00e787b3          	add	a5,a5,a4
    800025bc:	0487b503          	ld	a0,72(a5)
    800025c0:	00050663          	beqz	a0,800025cc <_ZN7_thread13__thread_exitEv+0x11c>
    800025c4:	00000097          	auipc	ra,0x0
    800025c8:	8d0080e7          	jalr	-1840(ra) # 80001e94 <_ZN9_fifoListdlEPv>
        running->joinQueue = nullptr;
    800025cc:	0000a797          	auipc	a5,0xa
    800025d0:	d0c7b783          	ld	a5,-756(a5) # 8000c2d8 <running>
    800025d4:	00001737          	lui	a4,0x1
    800025d8:	00e787b3          	add	a5,a5,a4
    800025dc:	0407b423          	sd	zero,72(a5)
    __mem_free(running->stek);
    800025e0:	0000a797          	auipc	a5,0xa
    800025e4:	cf87b783          	ld	a5,-776(a5) # 8000c2d8 <running>
    800025e8:	00001737          	lui	a4,0x1
    800025ec:	00e787b3          	add	a5,a5,a4
    800025f0:	0287b503          	ld	a0,40(a5)
    800025f4:	fffff097          	auipc	ra,0xfffff
    800025f8:	210080e7          	jalr	528(ra) # 80001804 <__mem_free>
    __thread_dispatch();
    800025fc:	00000097          	auipc	ra,0x0
    80002600:	d4c080e7          	jalr	-692(ra) # 80002348 <_ZN7_thread17__thread_dispatchEv>
}
    80002604:	fff00513          	li	a0,-1
    80002608:	01813083          	ld	ra,24(sp)
    8000260c:	01013403          	ld	s0,16(sp)
    80002610:	00813483          	ld	s1,8(sp)
    80002614:	00013903          	ld	s2,0(sp)
    80002618:	02010113          	addi	sp,sp,32
    8000261c:	00008067          	ret

0000000080002620 <_ZN7_thread13__thread_joinEPS_>:
    if(t == running) return;
    80002620:	0000a797          	auipc	a5,0xa
    80002624:	cb87b783          	ld	a5,-840(a5) # 8000c2d8 <running>
    80002628:	0ca78063          	beq	a5,a0,800026e8 <_ZN7_thread13__thread_joinEPS_+0xc8>
void _thread::__thread_join(thread_t t){
    8000262c:	fd010113          	addi	sp,sp,-48
    80002630:	02113423          	sd	ra,40(sp)
    80002634:	02813023          	sd	s0,32(sp)
    80002638:	00913c23          	sd	s1,24(sp)
    8000263c:	01213823          	sd	s2,16(sp)
    80002640:	01313423          	sd	s3,8(sp)
    80002644:	03010413          	addi	s0,sp,48
    80002648:	00050493          	mv	s1,a0
    if(t->status == FINISHED) return;
    8000264c:	000017b7          	lui	a5,0x1
    80002650:	00f507b3          	add	a5,a0,a5
    80002654:	0307b703          	ld	a4,48(a5) # 1030 <_entry-0x7fffefd0>
    80002658:	00300793          	li	a5,3
    8000265c:	04f70663          	beq	a4,a5,800026a8 <_ZN7_thread13__thread_joinEPS_+0x88>
    if(t->joinQueue == nullptr){
    80002660:	000017b7          	lui	a5,0x1
    80002664:	00f507b3          	add	a5,a0,a5
    80002668:	0487b783          	ld	a5,72(a5) # 1048 <_entry-0x7fffefb8>
    8000266c:	04078c63          	beqz	a5,800026c4 <_ZN7_thread13__thread_joinEPS_+0xa4>
    t->joinQueue->insertAtEnd(running);
    80002670:	00001937          	lui	s2,0x1
    80002674:	012484b3          	add	s1,s1,s2
    80002678:	0000a997          	auipc	s3,0xa
    8000267c:	c6098993          	addi	s3,s3,-928 # 8000c2d8 <running>
    80002680:	0009b583          	ld	a1,0(s3)
    80002684:	0484b503          	ld	a0,72(s1)
    80002688:	fffff097          	auipc	ra,0xfffff
    8000268c:	688080e7          	jalr	1672(ra) # 80001d10 <_ZN9_fifoList11insertAtEndEP7_thread>
    running->status = BLOCKED;
    80002690:	0009b783          	ld	a5,0(s3)
    80002694:	012787b3          	add	a5,a5,s2
    80002698:	00200713          	li	a4,2
    8000269c:	02e7b823          	sd	a4,48(a5)
    __thread_dispatch();
    800026a0:	00000097          	auipc	ra,0x0
    800026a4:	ca8080e7          	jalr	-856(ra) # 80002348 <_ZN7_thread17__thread_dispatchEv>
}
    800026a8:	02813083          	ld	ra,40(sp)
    800026ac:	02013403          	ld	s0,32(sp)
    800026b0:	01813483          	ld	s1,24(sp)
    800026b4:	01013903          	ld	s2,16(sp)
    800026b8:	00813983          	ld	s3,8(sp)
    800026bc:	03010113          	addi	sp,sp,48
    800026c0:	00008067          	ret
        t->joinQueue = new _fifoList();
    800026c4:	01000513          	li	a0,16
    800026c8:	fffff097          	auipc	ra,0xfffff
    800026cc:	764080e7          	jalr	1892(ra) # 80001e2c <_ZN9_fifoListnwEm>
    800026d0:	00053423          	sd	zero,8(a0)
    800026d4:	00053023          	sd	zero,0(a0)
    800026d8:	000017b7          	lui	a5,0x1
    800026dc:	00f487b3          	add	a5,s1,a5
    800026e0:	04a7b423          	sd	a0,72(a5) # 1048 <_entry-0x7fffefb8>
    800026e4:	f8dff06f          	j	80002670 <_ZN7_thread13__thread_joinEPS_+0x50>
    800026e8:	00008067          	ret

00000000800026ec <_ZN7_thread11getThreadIdEv>:
int _thread::getThreadId(){
    800026ec:	ff010113          	addi	sp,sp,-16
    800026f0:	00813423          	sd	s0,8(sp)
    800026f4:	01010413          	addi	s0,sp,16
    return running->id;
    800026f8:	0000a797          	auipc	a5,0xa
    800026fc:	be07b783          	ld	a5,-1056(a5) # 8000c2d8 <running>
    80002700:	00001737          	lui	a4,0x1
    80002704:	00e787b3          	add	a5,a5,a4
}
    80002708:	0507a503          	lw	a0,80(a5)
    8000270c:	00813403          	ld	s0,8(sp)
    80002710:	01010113          	addi	sp,sp,16
    80002714:	00008067          	ret

0000000080002718 <_GLOBAL__sub_I_running>:
    80002718:	ff010113          	addi	sp,sp,-16
    8000271c:	00113423          	sd	ra,8(sp)
    80002720:	00813023          	sd	s0,0(sp)
    80002724:	01010413          	addi	s0,sp,16
    80002728:	000105b7          	lui	a1,0x10
    8000272c:	fff58593          	addi	a1,a1,-1 # ffff <_entry-0x7fff0001>
    80002730:	00100513          	li	a0,1
    80002734:	00000097          	auipc	ra,0x0
    80002738:	870080e7          	jalr	-1936(ra) # 80001fa4 <_Z41__static_initialization_and_destruction_0ii>
    8000273c:	00813083          	ld	ra,8(sp)
    80002740:	00013403          	ld	s0,0(sp)
    80002744:	01010113          	addi	sp,sp,16
    80002748:	00008067          	ret

000000008000274c <_Z4testPv>:
#include "../h/k_FIFOList.hpp"
#include "../test/printing.hpp"
void userMain();
void initMainThread();

void test(void* arg){
    8000274c:	ff010113          	addi	sp,sp,-16
    80002750:	00113423          	sd	ra,8(sp)
    80002754:	00813023          	sd	s0,0(sp)
    80002758:	01010413          	addi	s0,sp,16
    userMain();
    8000275c:	00003097          	auipc	ra,0x3
    80002760:	db0080e7          	jalr	-592(ra) # 8000550c <_Z8userMainv>
}
    80002764:	00813083          	ld	ra,8(sp)
    80002768:	00013403          	ld	s0,0(sp)
    8000276c:	01010113          	addi	sp,sp,16
    80002770:	00008067          	ret

0000000080002774 <main>:
//        }
//
//    }
//}

void main() {
    80002774:	fe010113          	addi	sp,sp,-32
    80002778:	00113c23          	sd	ra,24(sp)
    8000277c:	00813823          	sd	s0,16(sp)
    80002780:	00913423          	sd	s1,8(sp)
    80002784:	01213023          	sd	s2,0(sp)
    80002788:	02010413          	addi	s0,sp,32

    initInterrupt();
    8000278c:	fffff097          	auipc	ra,0xfffff
    80002790:	e78080e7          	jalr	-392(ra) # 80001604 <initInterrupt>

    initMemory();
    80002794:	fffff097          	auipc	ra,0xfffff
    80002798:	ee0080e7          	jalr	-288(ra) # 80001674 <initMemory>

    initMainThread();
    8000279c:	00000097          	auipc	ra,0x0
    800027a0:	b84080e7          	jalr	-1148(ra) # 80002320 <_Z14initMainThreadv>

    initTimer();
    800027a4:	fffff097          	auipc	ra,0xfffff
    800027a8:	e88080e7          	jalr	-376(ra) # 8000162c <initTimer>

    Thread* t = new Thread(test, 0);
    800027ac:	02000513          	li	a0,32
    800027b0:	00000097          	auipc	ra,0x0
    800027b4:	19c080e7          	jalr	412(ra) # 8000294c <_Znwm>
    800027b8:	00050493          	mv	s1,a0
    800027bc:	00000613          	li	a2,0
    800027c0:	00000597          	auipc	a1,0x0
    800027c4:	f8c58593          	addi	a1,a1,-116 # 8000274c <_Z4testPv>
    800027c8:	00000097          	auipc	ra,0x0
    800027cc:	254080e7          	jalr	596(ra) # 80002a1c <_ZN6ThreadC1EPFvPvES0_>
    t->start();
    800027d0:	00048513          	mv	a0,s1
    800027d4:	00000097          	auipc	ra,0x0
    800027d8:	274080e7          	jalr	628(ra) # 80002a48 <_ZN6Thread5startEv>
    //thread_create(&t, test, 0);
    //thread_join(t);
    //userMain();
    t->join();
    800027dc:	00048513          	mv	a0,s1
    800027e0:	00000097          	auipc	ra,0x0
    800027e4:	29c080e7          	jalr	668(ra) # 80002a7c <_ZN6Thread4joinEv>
    delete t;
    800027e8:	00048a63          	beqz	s1,800027fc <main+0x88>
    800027ec:	0004b783          	ld	a5,0(s1)
    800027f0:	0087b783          	ld	a5,8(a5)
    800027f4:	00048513          	mv	a0,s1
    800027f8:	000780e7          	jalr	a5
//    for(int i =0; i < 3; i++){
//        niti[i]->join();
//    }

    return;
    800027fc:	01813083          	ld	ra,24(sp)
    80002800:	01013403          	ld	s0,16(sp)
    80002804:	00813483          	ld	s1,8(sp)
    80002808:	00013903          	ld	s2,0(sp)
    8000280c:	02010113          	addi	sp,sp,32
    80002810:	00008067          	ret
    80002814:	00050913          	mv	s2,a0
    Thread* t = new Thread(test, 0);
    80002818:	00048513          	mv	a0,s1
    8000281c:	00000097          	auipc	ra,0x0
    80002820:	158080e7          	jalr	344(ra) # 80002974 <_ZdlPv>
    80002824:	00090513          	mv	a0,s2
    80002828:	0008e097          	auipc	ra,0x8e
    8000282c:	210080e7          	jalr	528(ra) # 80090a38 <_Unwind_Resume>

0000000080002830 <_ZN9SchedulernwEm>:

#include "../h/k_Scheduler.hpp"
#include "../h/k_memory.h"

void *Scheduler::operator new(size_t size) {
    80002830:	ff010113          	addi	sp,sp,-16
    80002834:	00113423          	sd	ra,8(sp)
    80002838:	00813023          	sd	s0,0(sp)
    8000283c:	01010413          	addi	s0,sp,16

    if (size%MEM_BLOCK_SIZE != 0) {
    80002840:	03f57793          	andi	a5,a0,63
    80002844:	00078863          	beqz	a5,80002854 <_ZN9SchedulernwEm+0x24>
        size = (size / MEM_BLOCK_SIZE + 1) * MEM_BLOCK_SIZE;     // size in MEM_BLOCK_SIZE
    80002848:	00655513          	srli	a0,a0,0x6
    8000284c:	00150513          	addi	a0,a0,1
    80002850:	00651513          	slli	a0,a0,0x6
    }

    size = size/MEM_BLOCK_SIZE;

    return __mem_alloc(size);
    80002854:	00655513          	srli	a0,a0,0x6
    80002858:	fffff097          	auipc	ra,0xfffff
    8000285c:	e98080e7          	jalr	-360(ra) # 800016f0 <__mem_alloc>
}
    80002860:	00813083          	ld	ra,8(sp)
    80002864:	00013403          	ld	s0,0(sp)
    80002868:	01010113          	addi	sp,sp,16
    8000286c:	00008067          	ret

0000000080002870 <_ZN9SchedulerdlEPv>:


void Scheduler::operator delete(void *ptr) noexcept {
    80002870:	ff010113          	addi	sp,sp,-16
    80002874:	00113423          	sd	ra,8(sp)
    80002878:	00813023          	sd	s0,0(sp)
    8000287c:	01010413          	addi	s0,sp,16

    __mem_free(ptr);
    80002880:	fffff097          	auipc	ra,0xfffff
    80002884:	f84080e7          	jalr	-124(ra) # 80001804 <__mem_free>
}
    80002888:	00813083          	ld	ra,8(sp)
    8000288c:	00013403          	ld	s0,0(sp)
    80002890:	01010113          	addi	sp,sp,16
    80002894:	00008067          	ret

0000000080002898 <_ZN6Thread2twEPv>:
    body = tw ;
    arg = this;
}

void Thread::tw(void *arg) {
    if(arg!= nullptr)
    80002898:	02050863          	beqz	a0,800028c8 <_ZN6Thread2twEPv+0x30>
void Thread::tw(void *arg) {
    8000289c:	ff010113          	addi	sp,sp,-16
    800028a0:	00113423          	sd	ra,8(sp)
    800028a4:	00813023          	sd	s0,0(sp)
    800028a8:	01010413          	addi	s0,sp,16
        ((Thread*)arg)->run();
    800028ac:	00053783          	ld	a5,0(a0)
    800028b0:	0107b783          	ld	a5,16(a5)
    800028b4:	000780e7          	jalr	a5
}
    800028b8:	00813083          	ld	ra,8(sp)
    800028bc:	00013403          	ld	s0,0(sp)
    800028c0:	01010113          	addi	sp,sp,16
    800028c4:	00008067          	ret
    800028c8:	00008067          	ret

00000000800028cc <_ZN6ThreadD1Ev>:
Thread::~Thread (){
    800028cc:	00009797          	auipc	a5,0x9
    800028d0:	8ec78793          	addi	a5,a5,-1812 # 8000b1b8 <_ZTV6Thread+0x10>
    800028d4:	00f53023          	sd	a5,0(a0)
    delete myHandle;
    800028d8:	00853503          	ld	a0,8(a0)
    800028dc:	02050663          	beqz	a0,80002908 <_ZN6ThreadD1Ev+0x3c>
Thread::~Thread (){
    800028e0:	ff010113          	addi	sp,sp,-16
    800028e4:	00113423          	sd	ra,8(sp)
    800028e8:	00813023          	sd	s0,0(sp)
    800028ec:	01010413          	addi	s0,sp,16
    delete myHandle;
    800028f0:	00000097          	auipc	ra,0x0
    800028f4:	89c080e7          	jalr	-1892(ra) # 8000218c <_ZN7_threaddlEPv>
}
    800028f8:	00813083          	ld	ra,8(sp)
    800028fc:	00013403          	ld	s0,0(sp)
    80002900:	01010113          	addi	sp,sp,16
    80002904:	00008067          	ret
    80002908:	00008067          	ret

000000008000290c <_ZN9SemaphoreD1Ev>:

Semaphore::Semaphore (unsigned init){
    sem_open(&myHandle, init);
}

Semaphore::~Semaphore (){
    8000290c:	00009797          	auipc	a5,0x9
    80002910:	8d478793          	addi	a5,a5,-1836 # 8000b1e0 <_ZTV9Semaphore+0x10>
    80002914:	00f53023          	sd	a5,0(a0)
    delete myHandle;
    80002918:	00853503          	ld	a0,8(a0)
    8000291c:	02050663          	beqz	a0,80002948 <_ZN9SemaphoreD1Ev+0x3c>
Semaphore::~Semaphore (){
    80002920:	ff010113          	addi	sp,sp,-16
    80002924:	00113423          	sd	ra,8(sp)
    80002928:	00813023          	sd	s0,0(sp)
    8000292c:	01010413          	addi	s0,sp,16
    delete myHandle;
    80002930:	00000097          	auipc	ra,0x0
    80002934:	7a8080e7          	jalr	1960(ra) # 800030d8 <_ZN4_semdlEPv>
}
    80002938:	00813083          	ld	ra,8(sp)
    8000293c:	00013403          	ld	s0,0(sp)
    80002940:	01010113          	addi	sp,sp,16
    80002944:	00008067          	ret
    80002948:	00008067          	ret

000000008000294c <_Znwm>:
void* operator new (size_t size){
    8000294c:	ff010113          	addi	sp,sp,-16
    80002950:	00113423          	sd	ra,8(sp)
    80002954:	00813023          	sd	s0,0(sp)
    80002958:	01010413          	addi	s0,sp,16
    return mem_alloc(size);
    8000295c:	fffff097          	auipc	ra,0xfffff
    80002960:	048080e7          	jalr	72(ra) # 800019a4 <_Z9mem_allocm>
}
    80002964:	00813083          	ld	ra,8(sp)
    80002968:	00013403          	ld	s0,0(sp)
    8000296c:	01010113          	addi	sp,sp,16
    80002970:	00008067          	ret

0000000080002974 <_ZdlPv>:
void operator delete (void* ptr) noexcept{
    80002974:	ff010113          	addi	sp,sp,-16
    80002978:	00113423          	sd	ra,8(sp)
    8000297c:	00813023          	sd	s0,0(sp)
    80002980:	01010413          	addi	s0,sp,16
    mem_free(ptr);
    80002984:	fffff097          	auipc	ra,0xfffff
    80002988:	060080e7          	jalr	96(ra) # 800019e4 <_Z8mem_freePv>
}
    8000298c:	00813083          	ld	ra,8(sp)
    80002990:	00013403          	ld	s0,0(sp)
    80002994:	01010113          	addi	sp,sp,16
    80002998:	00008067          	ret

000000008000299c <_ZN6ThreadD0Ev>:
Thread::~Thread (){
    8000299c:	fe010113          	addi	sp,sp,-32
    800029a0:	00113c23          	sd	ra,24(sp)
    800029a4:	00813823          	sd	s0,16(sp)
    800029a8:	00913423          	sd	s1,8(sp)
    800029ac:	02010413          	addi	s0,sp,32
    800029b0:	00050493          	mv	s1,a0
}
    800029b4:	00000097          	auipc	ra,0x0
    800029b8:	f18080e7          	jalr	-232(ra) # 800028cc <_ZN6ThreadD1Ev>
    800029bc:	00048513          	mv	a0,s1
    800029c0:	00000097          	auipc	ra,0x0
    800029c4:	fb4080e7          	jalr	-76(ra) # 80002974 <_ZdlPv>
    800029c8:	01813083          	ld	ra,24(sp)
    800029cc:	01013403          	ld	s0,16(sp)
    800029d0:	00813483          	ld	s1,8(sp)
    800029d4:	02010113          	addi	sp,sp,32
    800029d8:	00008067          	ret

00000000800029dc <_ZN9SemaphoreD0Ev>:
Semaphore::~Semaphore (){
    800029dc:	fe010113          	addi	sp,sp,-32
    800029e0:	00113c23          	sd	ra,24(sp)
    800029e4:	00813823          	sd	s0,16(sp)
    800029e8:	00913423          	sd	s1,8(sp)
    800029ec:	02010413          	addi	s0,sp,32
    800029f0:	00050493          	mv	s1,a0
}
    800029f4:	00000097          	auipc	ra,0x0
    800029f8:	f18080e7          	jalr	-232(ra) # 8000290c <_ZN9SemaphoreD1Ev>
    800029fc:	00048513          	mv	a0,s1
    80002a00:	00000097          	auipc	ra,0x0
    80002a04:	f74080e7          	jalr	-140(ra) # 80002974 <_ZdlPv>
    80002a08:	01813083          	ld	ra,24(sp)
    80002a0c:	01013403          	ld	s0,16(sp)
    80002a10:	00813483          	ld	s1,8(sp)
    80002a14:	02010113          	addi	sp,sp,32
    80002a18:	00008067          	ret

0000000080002a1c <_ZN6ThreadC1EPFvPvES0_>:
Thread::Thread (void (*body)(void*), void* arg){
    80002a1c:	ff010113          	addi	sp,sp,-16
    80002a20:	00813423          	sd	s0,8(sp)
    80002a24:	01010413          	addi	s0,sp,16
    80002a28:	00008797          	auipc	a5,0x8
    80002a2c:	79078793          	addi	a5,a5,1936 # 8000b1b8 <_ZTV6Thread+0x10>
    80002a30:	00f53023          	sd	a5,0(a0)
    this->body = body;
    80002a34:	00b53823          	sd	a1,16(a0)
    this->arg  = arg;
    80002a38:	00c53c23          	sd	a2,24(a0)
}
    80002a3c:	00813403          	ld	s0,8(sp)
    80002a40:	01010113          	addi	sp,sp,16
    80002a44:	00008067          	ret

0000000080002a48 <_ZN6Thread5startEv>:
int Thread::start (){
    80002a48:	ff010113          	addi	sp,sp,-16
    80002a4c:	00113423          	sd	ra,8(sp)
    80002a50:	00813023          	sd	s0,0(sp)
    80002a54:	01010413          	addi	s0,sp,16
    return thread_create(&myHandle,body,arg);
    80002a58:	01853603          	ld	a2,24(a0)
    80002a5c:	01053583          	ld	a1,16(a0)
    80002a60:	00850513          	addi	a0,a0,8
    80002a64:	fffff097          	auipc	ra,0xfffff
    80002a68:	fac080e7          	jalr	-84(ra) # 80001a10 <_Z13thread_createPP7_threadPFvPvES2_>
}
    80002a6c:	00813083          	ld	ra,8(sp)
    80002a70:	00013403          	ld	s0,0(sp)
    80002a74:	01010113          	addi	sp,sp,16
    80002a78:	00008067          	ret

0000000080002a7c <_ZN6Thread4joinEv>:
void Thread::join(){
    80002a7c:	ff010113          	addi	sp,sp,-16
    80002a80:	00113423          	sd	ra,8(sp)
    80002a84:	00813023          	sd	s0,0(sp)
    80002a88:	01010413          	addi	s0,sp,16
    thread_join(myHandle);
    80002a8c:	00853503          	ld	a0,8(a0)
    80002a90:	fffff097          	auipc	ra,0xfffff
    80002a94:	038080e7          	jalr	56(ra) # 80001ac8 <_Z11thread_joinP7_thread>
}
    80002a98:	00813083          	ld	ra,8(sp)
    80002a9c:	00013403          	ld	s0,0(sp)
    80002aa0:	01010113          	addi	sp,sp,16
    80002aa4:	00008067          	ret

0000000080002aa8 <_ZN6Thread8dispatchEv>:
void Thread::dispatch (){
    80002aa8:	ff010113          	addi	sp,sp,-16
    80002aac:	00113423          	sd	ra,8(sp)
    80002ab0:	00813023          	sd	s0,0(sp)
    80002ab4:	01010413          	addi	s0,sp,16
    thread_dispatch();
    80002ab8:	fffff097          	auipc	ra,0xfffff
    80002abc:	ff0080e7          	jalr	-16(ra) # 80001aa8 <_Z15thread_dispatchv>
}
    80002ac0:	00813083          	ld	ra,8(sp)
    80002ac4:	00013403          	ld	s0,0(sp)
    80002ac8:	01010113          	addi	sp,sp,16
    80002acc:	00008067          	ret

0000000080002ad0 <_ZN6ThreadC1Ev>:
Thread::Thread (){
    80002ad0:	ff010113          	addi	sp,sp,-16
    80002ad4:	00813423          	sd	s0,8(sp)
    80002ad8:	01010413          	addi	s0,sp,16
    80002adc:	00008797          	auipc	a5,0x8
    80002ae0:	6dc78793          	addi	a5,a5,1756 # 8000b1b8 <_ZTV6Thread+0x10>
    80002ae4:	00f53023          	sd	a5,0(a0)
    body = tw ;
    80002ae8:	00000797          	auipc	a5,0x0
    80002aec:	db078793          	addi	a5,a5,-592 # 80002898 <_ZN6Thread2twEPv>
    80002af0:	00f53823          	sd	a5,16(a0)
    arg = this;
    80002af4:	00a53c23          	sd	a0,24(a0)
}
    80002af8:	00813403          	ld	s0,8(sp)
    80002afc:	01010113          	addi	sp,sp,16
    80002b00:	00008067          	ret

0000000080002b04 <_ZN9SemaphoreC1Ej>:
Semaphore::Semaphore (unsigned init){
    80002b04:	ff010113          	addi	sp,sp,-16
    80002b08:	00113423          	sd	ra,8(sp)
    80002b0c:	00813023          	sd	s0,0(sp)
    80002b10:	01010413          	addi	s0,sp,16
    80002b14:	00008797          	auipc	a5,0x8
    80002b18:	6cc78793          	addi	a5,a5,1740 # 8000b1e0 <_ZTV9Semaphore+0x10>
    80002b1c:	00f53023          	sd	a5,0(a0)
    sem_open(&myHandle, init);
    80002b20:	00850513          	addi	a0,a0,8
    80002b24:	fffff097          	auipc	ra,0xfffff
    80002b28:	fc8080e7          	jalr	-56(ra) # 80001aec <_Z8sem_openPP4_semj>
}
    80002b2c:	00813083          	ld	ra,8(sp)
    80002b30:	00013403          	ld	s0,0(sp)
    80002b34:	01010113          	addi	sp,sp,16
    80002b38:	00008067          	ret

0000000080002b3c <_ZN9Semaphore4waitEv>:

int Semaphore::wait (){
    80002b3c:	ff010113          	addi	sp,sp,-16
    80002b40:	00113423          	sd	ra,8(sp)
    80002b44:	00813023          	sd	s0,0(sp)
    80002b48:	01010413          	addi	s0,sp,16
    return sem_wait(myHandle);
    80002b4c:	00853503          	ld	a0,8(a0)
    80002b50:	fffff097          	auipc	ra,0xfffff
    80002b54:	ff8080e7          	jalr	-8(ra) # 80001b48 <_Z8sem_waitP4_sem>
}
    80002b58:	00813083          	ld	ra,8(sp)
    80002b5c:	00013403          	ld	s0,0(sp)
    80002b60:	01010113          	addi	sp,sp,16
    80002b64:	00008067          	ret

0000000080002b68 <_ZN9Semaphore6signalEv>:

int Semaphore::signal (){
    80002b68:	ff010113          	addi	sp,sp,-16
    80002b6c:	00113423          	sd	ra,8(sp)
    80002b70:	00813023          	sd	s0,0(sp)
    80002b74:	01010413          	addi	s0,sp,16
    return sem_signal(myHandle);
    80002b78:	00853503          	ld	a0,8(a0)
    80002b7c:	fffff097          	auipc	ra,0xfffff
    80002b80:	ff8080e7          	jalr	-8(ra) # 80001b74 <_Z10sem_signalP4_sem>
}
    80002b84:	00813083          	ld	ra,8(sp)
    80002b88:	00013403          	ld	s0,0(sp)
    80002b8c:	01010113          	addi	sp,sp,16
    80002b90:	00008067          	ret

0000000080002b94 <_ZN9Semaphore7tryWaitEv>:

int Semaphore::tryWait (){
    80002b94:	ff010113          	addi	sp,sp,-16
    80002b98:	00113423          	sd	ra,8(sp)
    80002b9c:	00813023          	sd	s0,0(sp)
    80002ba0:	01010413          	addi	s0,sp,16
    return sem_trywait(myHandle);
    80002ba4:	00853503          	ld	a0,8(a0)
    80002ba8:	fffff097          	auipc	ra,0xfffff
    80002bac:	ff8080e7          	jalr	-8(ra) # 80001ba0 <_Z11sem_trywaitP4_sem>
}
    80002bb0:	00813083          	ld	ra,8(sp)
    80002bb4:	00013403          	ld	s0,0(sp)
    80002bb8:	01010113          	addi	sp,sp,16
    80002bbc:	00008067          	ret

0000000080002bc0 <_ZN7Console4putcEc>:

void Console::putc(char c) {
    80002bc0:	ff010113          	addi	sp,sp,-16
    80002bc4:	00113423          	sd	ra,8(sp)
    80002bc8:	00813023          	sd	s0,0(sp)
    80002bcc:	01010413          	addi	s0,sp,16
    ::putc(c);
    80002bd0:	fffff097          	auipc	ra,0xfffff
    80002bd4:	024080e7          	jalr	36(ra) # 80001bf4 <_Z4putcc>
}
    80002bd8:	00813083          	ld	ra,8(sp)
    80002bdc:	00013403          	ld	s0,0(sp)
    80002be0:	01010113          	addi	sp,sp,16
    80002be4:	00008067          	ret

0000000080002be8 <_ZN7Console4getcEv>:

char Console::getc() {
    80002be8:	ff010113          	addi	sp,sp,-16
    80002bec:	00113423          	sd	ra,8(sp)
    80002bf0:	00813023          	sd	s0,0(sp)
    80002bf4:	01010413          	addi	s0,sp,16
    return ::getc();
    80002bf8:	fffff097          	auipc	ra,0xfffff
    80002bfc:	fd4080e7          	jalr	-44(ra) # 80001bcc <_Z4getcv>
    80002c00:	00813083          	ld	ra,8(sp)
    80002c04:	00013403          	ld	s0,0(sp)
    80002c08:	01010113          	addi	sp,sp,16
    80002c0c:	00008067          	ret

0000000080002c10 <_ZN6Thread3runEv>:

protected:

    Thread ();

    virtual void run () {}
    80002c10:	ff010113          	addi	sp,sp,-16
    80002c14:	00813423          	sd	s0,8(sp)
    80002c18:	01010413          	addi	s0,sp,16
    80002c1c:	00813403          	ld	s0,8(sp)
    80002c20:	01010113          	addi	sp,sp,16
    80002c24:	00008067          	ret

0000000080002c28 <_ZN4_semC1Ev>:
static _sem allSemaphores[MAX_NUM_OF_SEMAPHORE];
static bool isOcc[MAX_NUM_OF_SEMAPHORE] = {false};


//thread_exit i thread join
_sem::_sem(){}
    80002c28:	ff010113          	addi	sp,sp,-16
    80002c2c:	00813423          	sd	s0,8(sp)
    80002c30:	01010413          	addi	s0,sp,16
        first = last = nullptr;
    80002c34:	00053823          	sd	zero,16(a0)
    80002c38:	00053423          	sd	zero,8(a0)
    80002c3c:	00813403          	ld	s0,8(sp)
    80002c40:	01010113          	addi	sp,sp,16
    80002c44:	00008067          	ret

0000000080002c48 <_Z41__static_initialization_and_destruction_0ii>:

void _sem::operator delete(void* ptr) noexcept{

    int index = (_sem*)ptr - allSemaphores;
    isOcc[index] = false;
}
    80002c48:	00100793          	li	a5,1
    80002c4c:	00f50463          	beq	a0,a5,80002c54 <_Z41__static_initialization_and_destruction_0ii+0xc>
    80002c50:	00008067          	ret
    80002c54:	000107b7          	lui	a5,0x10
    80002c58:	fff78793          	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80002c5c:	fef59ae3          	bne	a1,a5,80002c50 <_Z41__static_initialization_and_destruction_0ii+0x8>
    80002c60:	fe010113          	addi	sp,sp,-32
    80002c64:	00113c23          	sd	ra,24(sp)
    80002c68:	00813823          	sd	s0,16(sp)
    80002c6c:	00913423          	sd	s1,8(sp)
    80002c70:	01213023          	sd	s2,0(sp)
    80002c74:	02010413          	addi	s0,sp,32
static _sem allSemaphores[MAX_NUM_OF_SEMAPHORE];
    80002c78:	06300493          	li	s1,99
    80002c7c:	0008c917          	auipc	s2,0x8c
    80002c80:	35c90913          	addi	s2,s2,860 # 8008efd8 <_ZL13allSemaphores>
    80002c84:	0004ce63          	bltz	s1,80002ca0 <_Z41__static_initialization_and_destruction_0ii+0x58>
    80002c88:	00090513          	mv	a0,s2
    80002c8c:	00000097          	auipc	ra,0x0
    80002c90:	f9c080e7          	jalr	-100(ra) # 80002c28 <_ZN4_semC1Ev>
    80002c94:	01890913          	addi	s2,s2,24
    80002c98:	fff48493          	addi	s1,s1,-1
    80002c9c:	fe9ff06f          	j	80002c84 <_Z41__static_initialization_and_destruction_0ii+0x3c>
}
    80002ca0:	01813083          	ld	ra,24(sp)
    80002ca4:	01013403          	ld	s0,16(sp)
    80002ca8:	00813483          	ld	s1,8(sp)
    80002cac:	00013903          	ld	s2,0(sp)
    80002cb0:	02010113          	addi	sp,sp,32
    80002cb4:	00008067          	ret

0000000080002cb8 <_ZN4_semC1Ei>:
_sem::_sem(int init){
    80002cb8:	ff010113          	addi	sp,sp,-16
    80002cbc:	00813423          	sd	s0,8(sp)
    80002cc0:	01010413          	addi	s0,sp,16
    80002cc4:	00053823          	sd	zero,16(a0)
    80002cc8:	00053423          	sd	zero,8(a0)
    this->val = init;
    80002ccc:	00b52023          	sw	a1,0(a0)
    this->open = true;
    80002cd0:	00100793          	li	a5,1
    80002cd4:	00f50223          	sb	a5,4(a0)
}
    80002cd8:	00813403          	ld	s0,8(sp)
    80002cdc:	01010113          	addi	sp,sp,16
    80002ce0:	00008067          	ret

0000000080002ce4 <_ZN4_sem11__sem_closeEPS_>:
int _sem::__sem_close(sem_t handle){
    80002ce4:	fd010113          	addi	sp,sp,-48
    80002ce8:	02113423          	sd	ra,40(sp)
    80002cec:	02813023          	sd	s0,32(sp)
    80002cf0:	00913c23          	sd	s1,24(sp)
    80002cf4:	01213823          	sd	s2,16(sp)
    80002cf8:	01313423          	sd	s3,8(sp)
    80002cfc:	03010413          	addi	s0,sp,48
    80002d00:	00050913          	mv	s2,a0
    if(!handle->open) return SEMAPHORE_CLOSED;
    80002d04:	00454783          	lbu	a5,4(a0)
    80002d08:	04079063          	bnez	a5,80002d48 <_ZN4_sem11__sem_closeEPS_+0x64>
    80002d0c:	ffe00513          	li	a0,-2
    80002d10:	0b80006f          	j	80002dc8 <_ZN4_sem11__sem_closeEPS_+0xe4>
    80002d14:	00053423          	sd	zero,8(a0)
    80002d18:	00053023          	sd	zero,0(a0)
        lista = new _fifoList();
    80002d1c:	00a9b023          	sd	a0,0(s3)
            instance = new Scheduler();
    80002d20:	00008797          	auipc	a5,0x8
    80002d24:	6187b783          	ld	a5,1560(a5) # 8000b338 <_GLOBAL_OFFSET_TABLE_+0x18>
    80002d28:	0137b023          	sd	s3,0(a5)
        return instance;
    80002d2c:	00008797          	auipc	a5,0x8
    80002d30:	60c7b783          	ld	a5,1548(a5) # 8000b338 <_GLOBAL_OFFSET_TABLE_+0x18>
    80002d34:	0007b783          	ld	a5,0(a5)
        lista->insertAtEnd(t);
    80002d38:	00048593          	mv	a1,s1
    80002d3c:	0007b503          	ld	a0,0(a5)
    80002d40:	fffff097          	auipc	ra,0xfffff
    80002d44:	fd0080e7          	jalr	-48(ra) # 80001d10 <_ZN9_fifoList11insertAtEndEP7_thread>
    while(_thread* t = handle->semQueue.removeFromStart()){
    80002d48:	00890513          	addi	a0,s2,8
    80002d4c:	fffff097          	auipc	ra,0xfffff
    80002d50:	06c080e7          	jalr	108(ra) # 80001db8 <_ZN9_fifoList15removeFromStartEv>
    80002d54:	00050493          	mv	s1,a0
    80002d58:	06050063          	beqz	a0,80002db8 <_ZN4_sem11__sem_closeEPS_+0xd4>
        t->status = READY;
    80002d5c:	000017b7          	lui	a5,0x1
    80002d60:	00f507b3          	add	a5,a0,a5
    80002d64:	00100713          	li	a4,1
    80002d68:	02e7b823          	sd	a4,48(a5) # 1030 <_entry-0x7fffefd0>
        if(instance == 0){
    80002d6c:	00008797          	auipc	a5,0x8
    80002d70:	5cc7b783          	ld	a5,1484(a5) # 8000b338 <_GLOBAL_OFFSET_TABLE_+0x18>
    80002d74:	0007b783          	ld	a5,0(a5)
    80002d78:	fa079ae3          	bnez	a5,80002d2c <_ZN4_sem11__sem_closeEPS_+0x48>
            instance = new Scheduler();
    80002d7c:	00800513          	li	a0,8
    80002d80:	00000097          	auipc	ra,0x0
    80002d84:	ab0080e7          	jalr	-1360(ra) # 80002830 <_ZN9SchedulernwEm>
    80002d88:	00050993          	mv	s3,a0
        lista = new _fifoList();
    80002d8c:	01000513          	li	a0,16
    80002d90:	fffff097          	auipc	ra,0xfffff
    80002d94:	09c080e7          	jalr	156(ra) # 80001e2c <_ZN9_fifoListnwEm>
    80002d98:	f7dff06f          	j	80002d14 <_ZN4_sem11__sem_closeEPS_+0x30>
    80002d9c:	00050493          	mv	s1,a0
            instance = new Scheduler();
    80002da0:	00098513          	mv	a0,s3
    80002da4:	00000097          	auipc	ra,0x0
    80002da8:	acc080e7          	jalr	-1332(ra) # 80002870 <_ZN9SchedulerdlEPv>
    80002dac:	00048513          	mv	a0,s1
    80002db0:	0008e097          	auipc	ra,0x8e
    80002db4:	c88080e7          	jalr	-888(ra) # 80090a38 <_Unwind_Resume>
    handle->open = false;
    80002db8:	00090223          	sb	zero,4(s2)
    if(handle->val < 0) {
    80002dbc:	00092783          	lw	a5,0(s2)
    80002dc0:	0207c263          	bltz	a5,80002de4 <_ZN4_sem11__sem_closeEPS_+0x100>
        return 0;
    80002dc4:	00000513          	li	a0,0
}
    80002dc8:	02813083          	ld	ra,40(sp)
    80002dcc:	02013403          	ld	s0,32(sp)
    80002dd0:	01813483          	ld	s1,24(sp)
    80002dd4:	01013903          	ld	s2,16(sp)
    80002dd8:	00813983          	ld	s3,8(sp)
    80002ddc:	03010113          	addi	sp,sp,48
    80002de0:	00008067          	ret
        return THREADS_WAITING;
    80002de4:	ffc00513          	li	a0,-4
    80002de8:	fe1ff06f          	j	80002dc8 <_ZN4_sem11__sem_closeEPS_+0xe4>

0000000080002dec <_ZN4_sem10__sem_waitEPS_>:
    if(!id->open) return SEMAPHORE_CLOSED;
    80002dec:	00454783          	lbu	a5,4(a0)
    80002df0:	08078463          	beqz	a5,80002e78 <_ZN4_sem10__sem_waitEPS_+0x8c>
int _sem::__sem_wait(sem_t id){
    80002df4:	fe010113          	addi	sp,sp,-32
    80002df8:	00113c23          	sd	ra,24(sp)
    80002dfc:	00813823          	sd	s0,16(sp)
    80002e00:	00913423          	sd	s1,8(sp)
    80002e04:	02010413          	addi	s0,sp,32
    80002e08:	00050493          	mv	s1,a0
    if(--id->val < 0){
    80002e0c:	00052783          	lw	a5,0(a0)
    80002e10:	fff7879b          	addiw	a5,a5,-1
    80002e14:	00f52023          	sw	a5,0(a0)
    80002e18:	02079713          	slli	a4,a5,0x20
    80002e1c:	00074e63          	bltz	a4,80002e38 <_ZN4_sem10__sem_waitEPS_+0x4c>
    return 0;
    80002e20:	00000513          	li	a0,0
}
    80002e24:	01813083          	ld	ra,24(sp)
    80002e28:	01013403          	ld	s0,16(sp)
    80002e2c:	00813483          	ld	s1,8(sp)
    80002e30:	02010113          	addi	sp,sp,32
    80002e34:	00008067          	ret
        _thread* t = _thread::getRunning();
    80002e38:	fffff097          	auipc	ra,0xfffff
    80002e3c:	29c080e7          	jalr	668(ra) # 800020d4 <_ZN7_thread10getRunningEv>
    80002e40:	00050593          	mv	a1,a0
        t->status = BLOCKED;
    80002e44:	000017b7          	lui	a5,0x1
    80002e48:	00f507b3          	add	a5,a0,a5
    80002e4c:	00200713          	li	a4,2
    80002e50:	02e7b823          	sd	a4,48(a5) # 1030 <_entry-0x7fffefd0>
        id->semQueue.insertAtEnd(t);
    80002e54:	00848513          	addi	a0,s1,8
    80002e58:	fffff097          	auipc	ra,0xfffff
    80002e5c:	eb8080e7          	jalr	-328(ra) # 80001d10 <_ZN9_fifoList11insertAtEndEP7_thread>
        _thread::__thread_dispatch();
    80002e60:	fffff097          	auipc	ra,0xfffff
    80002e64:	4e8080e7          	jalr	1256(ra) # 80002348 <_ZN7_thread17__thread_dispatchEv>
        if (!id->open)  return SEMAPHORE_CLOSED_BEFORE_THREADS_SIGNAL;
    80002e68:	0044c783          	lbu	a5,4(s1)
    80002e6c:	00078a63          	beqz	a5,80002e80 <_ZN4_sem10__sem_waitEPS_+0x94>
    return 0;
    80002e70:	00000513          	li	a0,0
    80002e74:	fb1ff06f          	j	80002e24 <_ZN4_sem10__sem_waitEPS_+0x38>
    if(!id->open) return SEMAPHORE_CLOSED;
    80002e78:	ffe00513          	li	a0,-2
}
    80002e7c:	00008067          	ret
        if (!id->open)  return SEMAPHORE_CLOSED_BEFORE_THREADS_SIGNAL;
    80002e80:	ffb00513          	li	a0,-5
    80002e84:	fa1ff06f          	j	80002e24 <_ZN4_sem10__sem_waitEPS_+0x38>

0000000080002e88 <_ZN4_sem12__sem_signalEPS_>:
    if(!id->open) return SEMAPHORE_CLOSED;
    80002e88:	00454783          	lbu	a5,4(a0)
    80002e8c:	0e078c63          	beqz	a5,80002f84 <_ZN4_sem12__sem_signalEPS_+0xfc>
    if(++id->val <= 0){
    80002e90:	00052783          	lw	a5,0(a0)
    80002e94:	0017879b          	addiw	a5,a5,1
    80002e98:	0007871b          	sext.w	a4,a5
    80002e9c:	00f52023          	sw	a5,0(a0)
    80002ea0:	00e05663          	blez	a4,80002eac <_ZN4_sem12__sem_signalEPS_+0x24>
    return 0;
    80002ea4:	00000513          	li	a0,0
}
    80002ea8:	00008067          	ret
int _sem::__sem_signal(sem_t id){
    80002eac:	fe010113          	addi	sp,sp,-32
    80002eb0:	00113c23          	sd	ra,24(sp)
    80002eb4:	00813823          	sd	s0,16(sp)
    80002eb8:	00913423          	sd	s1,8(sp)
    80002ebc:	01213023          	sd	s2,0(sp)
    80002ec0:	02010413          	addi	s0,sp,32
        _thread *t = id->semQueue.removeFromStart();
    80002ec4:	00850513          	addi	a0,a0,8
    80002ec8:	fffff097          	auipc	ra,0xfffff
    80002ecc:	ef0080e7          	jalr	-272(ra) # 80001db8 <_ZN9_fifoList15removeFromStartEv>
    80002ed0:	00050493          	mv	s1,a0
        if(t == nullptr) {
    80002ed4:	0a050c63          	beqz	a0,80002f8c <_ZN4_sem12__sem_signalEPS_+0x104>
        t->status = READY;
    80002ed8:	000017b7          	lui	a5,0x1
    80002edc:	00f507b3          	add	a5,a0,a5
    80002ee0:	00100713          	li	a4,1
    80002ee4:	02e7b823          	sd	a4,48(a5) # 1030 <_entry-0x7fffefd0>
        if(instance == 0){
    80002ee8:	00008797          	auipc	a5,0x8
    80002eec:	4507b783          	ld	a5,1104(a5) # 8000b338 <_GLOBAL_OFFSET_TABLE_+0x18>
    80002ef0:	0007b783          	ld	a5,0(a5)
    80002ef4:	02078e63          	beqz	a5,80002f30 <_ZN4_sem12__sem_signalEPS_+0xa8>
        return instance;
    80002ef8:	00008797          	auipc	a5,0x8
    80002efc:	4407b783          	ld	a5,1088(a5) # 8000b338 <_GLOBAL_OFFSET_TABLE_+0x18>
    80002f00:	0007b783          	ld	a5,0(a5)
        lista->insertAtEnd(t);
    80002f04:	00048593          	mv	a1,s1
    80002f08:	0007b503          	ld	a0,0(a5)
    80002f0c:	fffff097          	auipc	ra,0xfffff
    80002f10:	e04080e7          	jalr	-508(ra) # 80001d10 <_ZN9_fifoList11insertAtEndEP7_thread>
    return 0;
    80002f14:	00000513          	li	a0,0
}
    80002f18:	01813083          	ld	ra,24(sp)
    80002f1c:	01013403          	ld	s0,16(sp)
    80002f20:	00813483          	ld	s1,8(sp)
    80002f24:	00013903          	ld	s2,0(sp)
    80002f28:	02010113          	addi	sp,sp,32
    80002f2c:	00008067          	ret
            instance = new Scheduler();
    80002f30:	00800513          	li	a0,8
    80002f34:	00000097          	auipc	ra,0x0
    80002f38:	8fc080e7          	jalr	-1796(ra) # 80002830 <_ZN9SchedulernwEm>
    80002f3c:	00050913          	mv	s2,a0
        lista = new _fifoList();
    80002f40:	01000513          	li	a0,16
    80002f44:	fffff097          	auipc	ra,0xfffff
    80002f48:	ee8080e7          	jalr	-280(ra) # 80001e2c <_ZN9_fifoListnwEm>
    80002f4c:	00053423          	sd	zero,8(a0)
    80002f50:	00053023          	sd	zero,0(a0)
    80002f54:	00a93023          	sd	a0,0(s2)
            instance = new Scheduler();
    80002f58:	00008797          	auipc	a5,0x8
    80002f5c:	3e07b783          	ld	a5,992(a5) # 8000b338 <_GLOBAL_OFFSET_TABLE_+0x18>
    80002f60:	0127b023          	sd	s2,0(a5)
    80002f64:	f95ff06f          	j	80002ef8 <_ZN4_sem12__sem_signalEPS_+0x70>
    80002f68:	00050493          	mv	s1,a0
    80002f6c:	00090513          	mv	a0,s2
    80002f70:	00000097          	auipc	ra,0x0
    80002f74:	900080e7          	jalr	-1792(ra) # 80002870 <_ZN9SchedulerdlEPv>
    80002f78:	00048513          	mv	a0,s1
    80002f7c:	0008e097          	auipc	ra,0x8e
    80002f80:	abc080e7          	jalr	-1348(ra) # 80090a38 <_Unwind_Resume>
    if(!id->open) return SEMAPHORE_CLOSED;
    80002f84:	ffe00513          	li	a0,-2
    80002f88:	00008067          	ret
            return NO_THREADS_WAITING;
    80002f8c:	ffd00513          	li	a0,-3
    80002f90:	f89ff06f          	j	80002f18 <_ZN4_sem12__sem_signalEPS_+0x90>

0000000080002f94 <_ZN4_sem13__sem_trywaitEPS_>:
int _sem::__sem_trywait(sem_t id){
    80002f94:	ff010113          	addi	sp,sp,-16
    80002f98:	00813423          	sd	s0,8(sp)
    80002f9c:	01010413          	addi	s0,sp,16
    if(!id->open) return SEMAPHORE_CLOSED;
    80002fa0:	00454783          	lbu	a5,4(a0)
    80002fa4:	02078e63          	beqz	a5,80002fe0 <_ZN4_sem13__sem_trywaitEPS_+0x4c>
    if(--id->val < 0) {
    80002fa8:	00052703          	lw	a4,0(a0)
    80002fac:	fff7079b          	addiw	a5,a4,-1
    80002fb0:	0007869b          	sext.w	a3,a5
    80002fb4:	00f52023          	sw	a5,0(a0)
    80002fb8:	02079613          	slli	a2,a5,0x20
    80002fbc:	00064c63          	bltz	a2,80002fd4 <_ZN4_sem13__sem_trywaitEPS_+0x40>
    if(id->val > 0) return SEMAPHORE_NOT_LOCKED;
    80002fc0:	02d04463          	bgtz	a3,80002fe8 <_ZN4_sem13__sem_trywaitEPS_+0x54>
    return  0;
    80002fc4:	00000513          	li	a0,0
}
    80002fc8:	00813403          	ld	s0,8(sp)
    80002fcc:	01010113          	addi	sp,sp,16
    80002fd0:	00008067          	ret
        ++id->val;
    80002fd4:	00e52023          	sw	a4,0(a0)
        return SEMAPHORE_LOCKED;
    80002fd8:	ffa00513          	li	a0,-6
    80002fdc:	fedff06f          	j	80002fc8 <_ZN4_sem13__sem_trywaitEPS_+0x34>
    if(!id->open) return SEMAPHORE_CLOSED;
    80002fe0:	ffe00513          	li	a0,-2
    80002fe4:	fe5ff06f          	j	80002fc8 <_ZN4_sem13__sem_trywaitEPS_+0x34>
    if(id->val > 0) return SEMAPHORE_NOT_LOCKED;
    80002fe8:	00100513          	li	a0,1
    80002fec:	fddff06f          	j	80002fc8 <_ZN4_sem13__sem_trywaitEPS_+0x34>

0000000080002ff0 <_ZN4_semnwEm>:
void* _sem::operator new(size_t size){
    80002ff0:	ff010113          	addi	sp,sp,-16
    80002ff4:	00813423          	sd	s0,8(sp)
    80002ff8:	01010413          	addi	s0,sp,16
    for(int i =0; i<MAX_NUM_OF_SEMAPHORE;i++){
    80002ffc:	00000793          	li	a5,0
    80003000:	0080006f          	j	80003008 <_ZN4_semnwEm+0x18>
    80003004:	0017879b          	addiw	a5,a5,1
    80003008:	06300713          	li	a4,99
    8000300c:	04f74863          	blt	a4,a5,8000305c <_ZN4_semnwEm+0x6c>
        if(!isOcc[i]){
    80003010:	0008c717          	auipc	a4,0x8c
    80003014:	f6070713          	addi	a4,a4,-160 # 8008ef70 <_ZL5isOcc>
    80003018:	00f70733          	add	a4,a4,a5
    8000301c:	00074703          	lbu	a4,0(a4)
    80003020:	fe0712e3          	bnez	a4,80003004 <_ZN4_semnwEm+0x14>
            isOcc[i]= true;
    80003024:	0008c717          	auipc	a4,0x8c
    80003028:	f4c70713          	addi	a4,a4,-180 # 8008ef70 <_ZL5isOcc>
    8000302c:	00f70733          	add	a4,a4,a5
    80003030:	00100693          	li	a3,1
    80003034:	00d70023          	sb	a3,0(a4)
            return (void*)(allSemaphores+i);
    80003038:	00179713          	slli	a4,a5,0x1
    8000303c:	00f707b3          	add	a5,a4,a5
    80003040:	00379513          	slli	a0,a5,0x3
    80003044:	0008c797          	auipc	a5,0x8c
    80003048:	f9478793          	addi	a5,a5,-108 # 8008efd8 <_ZL13allSemaphores>
    8000304c:	00f50533          	add	a0,a0,a5
}
    80003050:	00813403          	ld	s0,8(sp)
    80003054:	01010113          	addi	sp,sp,16
    80003058:	00008067          	ret
    return allSemaphores;
    8000305c:	0008c517          	auipc	a0,0x8c
    80003060:	f7c50513          	addi	a0,a0,-132 # 8008efd8 <_ZL13allSemaphores>
    80003064:	fedff06f          	j	80003050 <_ZN4_semnwEm+0x60>

0000000080003068 <_ZN4_sem10__sem_openEPPS_i>:
int _sem::__sem_open(sem_t* handle, int init=1){
    80003068:	fd010113          	addi	sp,sp,-48
    8000306c:	02113423          	sd	ra,40(sp)
    80003070:	02813023          	sd	s0,32(sp)
    80003074:	00913c23          	sd	s1,24(sp)
    80003078:	01213823          	sd	s2,16(sp)
    8000307c:	01313423          	sd	s3,8(sp)
    80003080:	03010413          	addi	s0,sp,48
    80003084:	00050913          	mv	s2,a0
    80003088:	00058993          	mv	s3,a1
    *handle = new _sem(init);
    8000308c:	01800513          	li	a0,24
    80003090:	00000097          	auipc	ra,0x0
    80003094:	f60080e7          	jalr	-160(ra) # 80002ff0 <_ZN4_semnwEm>
    80003098:	00050493          	mv	s1,a0
    8000309c:	00098593          	mv	a1,s3
    800030a0:	00000097          	auipc	ra,0x0
    800030a4:	c18080e7          	jalr	-1000(ra) # 80002cb8 <_ZN4_semC1Ei>
    800030a8:	00993023          	sd	s1,0(s2)
    if(*handle == nullptr) return NO_MEMORY;
    800030ac:	02048263          	beqz	s1,800030d0 <_ZN4_sem10__sem_openEPPS_i+0x68>
    return 0;
    800030b0:	00000513          	li	a0,0
}
    800030b4:	02813083          	ld	ra,40(sp)
    800030b8:	02013403          	ld	s0,32(sp)
    800030bc:	01813483          	ld	s1,24(sp)
    800030c0:	01013903          	ld	s2,16(sp)
    800030c4:	00813983          	ld	s3,8(sp)
    800030c8:	03010113          	addi	sp,sp,48
    800030cc:	00008067          	ret
    if(*handle == nullptr) return NO_MEMORY;
    800030d0:	fff00513          	li	a0,-1
    800030d4:	fe1ff06f          	j	800030b4 <_ZN4_sem10__sem_openEPPS_i+0x4c>

00000000800030d8 <_ZN4_semdlEPv>:
void _sem::operator delete(void* ptr) noexcept{
    800030d8:	ff010113          	addi	sp,sp,-16
    800030dc:	00813423          	sd	s0,8(sp)
    800030e0:	01010413          	addi	s0,sp,16
    int index = (_sem*)ptr - allSemaphores;
    800030e4:	0008c797          	auipc	a5,0x8c
    800030e8:	ef478793          	addi	a5,a5,-268 # 8008efd8 <_ZL13allSemaphores>
    800030ec:	40f50533          	sub	a0,a0,a5
    800030f0:	40355513          	srai	a0,a0,0x3
    800030f4:	00006797          	auipc	a5,0x6
    800030f8:	fbc7b783          	ld	a5,-68(a5) # 800090b0 <CONSOLE_STATUS+0xa0>
    800030fc:	02f5053b          	mulw	a0,a0,a5
    isOcc[index] = false;
    80003100:	0008c797          	auipc	a5,0x8c
    80003104:	e7078793          	addi	a5,a5,-400 # 8008ef70 <_ZL5isOcc>
    80003108:	00a78533          	add	a0,a5,a0
    8000310c:	00050023          	sb	zero,0(a0)
}
    80003110:	00813403          	ld	s0,8(sp)
    80003114:	01010113          	addi	sp,sp,16
    80003118:	00008067          	ret

000000008000311c <_GLOBAL__sub_I__ZN4_semC2Ev>:
    8000311c:	ff010113          	addi	sp,sp,-16
    80003120:	00113423          	sd	ra,8(sp)
    80003124:	00813023          	sd	s0,0(sp)
    80003128:	01010413          	addi	s0,sp,16
    8000312c:	000105b7          	lui	a1,0x10
    80003130:	fff58593          	addi	a1,a1,-1 # ffff <_entry-0x7fff0001>
    80003134:	00100513          	li	a0,1
    80003138:	00000097          	auipc	ra,0x0
    8000313c:	b10080e7          	jalr	-1264(ra) # 80002c48 <_Z41__static_initialization_and_destruction_0ii>
    80003140:	00813083          	ld	ra,8(sp)
    80003144:	00013403          	ld	s0,0(sp)
    80003148:	01010113          	addi	sp,sp,16
    8000314c:	00008067          	ret

0000000080003150 <_ZL16producerKeyboardPv>:
    sem_t wait;
};

static volatile int threadEnd = 0;

static void producerKeyboard(void *arg) {
    80003150:	fe010113          	addi	sp,sp,-32
    80003154:	00113c23          	sd	ra,24(sp)
    80003158:	00813823          	sd	s0,16(sp)
    8000315c:	00913423          	sd	s1,8(sp)
    80003160:	01213023          	sd	s2,0(sp)
    80003164:	02010413          	addi	s0,sp,32
    80003168:	00050493          	mv	s1,a0
    struct thread_data *data = (struct thread_data *) arg;

    int key;
    int i = 0;
    8000316c:	00000913          	li	s2,0
    80003170:	00c0006f          	j	8000317c <_ZL16producerKeyboardPv+0x2c>
    while ((key = getc()) != 0x1b) {
        data->buffer->put(key);
        i++;

        if (i % (10 * data->id) == 0) {
            thread_dispatch();
    80003174:	fffff097          	auipc	ra,0xfffff
    80003178:	934080e7          	jalr	-1740(ra) # 80001aa8 <_Z15thread_dispatchv>
    while ((key = getc()) != 0x1b) {
    8000317c:	fffff097          	auipc	ra,0xfffff
    80003180:	a50080e7          	jalr	-1456(ra) # 80001bcc <_Z4getcv>
    80003184:	0005059b          	sext.w	a1,a0
    80003188:	01b00793          	li	a5,27
    8000318c:	02f58a63          	beq	a1,a5,800031c0 <_ZL16producerKeyboardPv+0x70>
        data->buffer->put(key);
    80003190:	0084b503          	ld	a0,8(s1)
    80003194:	00003097          	auipc	ra,0x3
    80003198:	b44080e7          	jalr	-1212(ra) # 80005cd8 <_ZN6Buffer3putEi>
        i++;
    8000319c:	0019071b          	addiw	a4,s2,1
    800031a0:	0007091b          	sext.w	s2,a4
        if (i % (10 * data->id) == 0) {
    800031a4:	0004a683          	lw	a3,0(s1)
    800031a8:	0026979b          	slliw	a5,a3,0x2
    800031ac:	00d787bb          	addw	a5,a5,a3
    800031b0:	0017979b          	slliw	a5,a5,0x1
    800031b4:	02f767bb          	remw	a5,a4,a5
    800031b8:	fc0792e3          	bnez	a5,8000317c <_ZL16producerKeyboardPv+0x2c>
    800031bc:	fb9ff06f          	j	80003174 <_ZL16producerKeyboardPv+0x24>
        }
    }

    threadEnd = 1;
    800031c0:	00100793          	li	a5,1
    800031c4:	0008c717          	auipc	a4,0x8c
    800031c8:	76f72a23          	sw	a5,1908(a4) # 8008f938 <_ZL9threadEnd>
    data->buffer->put('!');
    800031cc:	02100593          	li	a1,33
    800031d0:	0084b503          	ld	a0,8(s1)
    800031d4:	00003097          	auipc	ra,0x3
    800031d8:	b04080e7          	jalr	-1276(ra) # 80005cd8 <_ZN6Buffer3putEi>

    sem_signal(data->wait);
    800031dc:	0104b503          	ld	a0,16(s1)
    800031e0:	fffff097          	auipc	ra,0xfffff
    800031e4:	994080e7          	jalr	-1644(ra) # 80001b74 <_Z10sem_signalP4_sem>
}
    800031e8:	01813083          	ld	ra,24(sp)
    800031ec:	01013403          	ld	s0,16(sp)
    800031f0:	00813483          	ld	s1,8(sp)
    800031f4:	00013903          	ld	s2,0(sp)
    800031f8:	02010113          	addi	sp,sp,32
    800031fc:	00008067          	ret

0000000080003200 <_ZL8producerPv>:

static void producer(void *arg) {
    80003200:	fe010113          	addi	sp,sp,-32
    80003204:	00113c23          	sd	ra,24(sp)
    80003208:	00813823          	sd	s0,16(sp)
    8000320c:	00913423          	sd	s1,8(sp)
    80003210:	01213023          	sd	s2,0(sp)
    80003214:	02010413          	addi	s0,sp,32
    80003218:	00050493          	mv	s1,a0
    struct thread_data *data = (struct thread_data *) arg;

    int i = 0;
    8000321c:	00000913          	li	s2,0
    80003220:	00c0006f          	j	8000322c <_ZL8producerPv+0x2c>
    while (!threadEnd) {
        data->buffer->put(data->id + '0');
        i++;

        if (i % (10 * data->id) == 0) {
            thread_dispatch();
    80003224:	fffff097          	auipc	ra,0xfffff
    80003228:	884080e7          	jalr	-1916(ra) # 80001aa8 <_Z15thread_dispatchv>
    while (!threadEnd) {
    8000322c:	0008c797          	auipc	a5,0x8c
    80003230:	70c7a783          	lw	a5,1804(a5) # 8008f938 <_ZL9threadEnd>
    80003234:	02079e63          	bnez	a5,80003270 <_ZL8producerPv+0x70>
        data->buffer->put(data->id + '0');
    80003238:	0004a583          	lw	a1,0(s1)
    8000323c:	0305859b          	addiw	a1,a1,48
    80003240:	0084b503          	ld	a0,8(s1)
    80003244:	00003097          	auipc	ra,0x3
    80003248:	a94080e7          	jalr	-1388(ra) # 80005cd8 <_ZN6Buffer3putEi>
        i++;
    8000324c:	0019071b          	addiw	a4,s2,1
    80003250:	0007091b          	sext.w	s2,a4
        if (i % (10 * data->id) == 0) {
    80003254:	0004a683          	lw	a3,0(s1)
    80003258:	0026979b          	slliw	a5,a3,0x2
    8000325c:	00d787bb          	addw	a5,a5,a3
    80003260:	0017979b          	slliw	a5,a5,0x1
    80003264:	02f767bb          	remw	a5,a4,a5
    80003268:	fc0792e3          	bnez	a5,8000322c <_ZL8producerPv+0x2c>
    8000326c:	fb9ff06f          	j	80003224 <_ZL8producerPv+0x24>
        }
    }

    sem_signal(data->wait);
    80003270:	0104b503          	ld	a0,16(s1)
    80003274:	fffff097          	auipc	ra,0xfffff
    80003278:	900080e7          	jalr	-1792(ra) # 80001b74 <_Z10sem_signalP4_sem>
}
    8000327c:	01813083          	ld	ra,24(sp)
    80003280:	01013403          	ld	s0,16(sp)
    80003284:	00813483          	ld	s1,8(sp)
    80003288:	00013903          	ld	s2,0(sp)
    8000328c:	02010113          	addi	sp,sp,32
    80003290:	00008067          	ret

0000000080003294 <_ZL8consumerPv>:

static void consumer(void *arg) {
    80003294:	fd010113          	addi	sp,sp,-48
    80003298:	02113423          	sd	ra,40(sp)
    8000329c:	02813023          	sd	s0,32(sp)
    800032a0:	00913c23          	sd	s1,24(sp)
    800032a4:	01213823          	sd	s2,16(sp)
    800032a8:	01313423          	sd	s3,8(sp)
    800032ac:	03010413          	addi	s0,sp,48
    800032b0:	00050913          	mv	s2,a0
    struct thread_data *data = (struct thread_data *) arg;

    int i = 0;
    800032b4:	00000993          	li	s3,0
    800032b8:	01c0006f          	j	800032d4 <_ZL8consumerPv+0x40>
        i++;

        putc(key);

        if (i % (5 * data->id) == 0) {
            thread_dispatch();
    800032bc:	ffffe097          	auipc	ra,0xffffe
    800032c0:	7ec080e7          	jalr	2028(ra) # 80001aa8 <_Z15thread_dispatchv>
    800032c4:	0500006f          	j	80003314 <_ZL8consumerPv+0x80>
        }

        if (i % 80 == 0) {
            putc('\n');
    800032c8:	00a00513          	li	a0,10
    800032cc:	fffff097          	auipc	ra,0xfffff
    800032d0:	928080e7          	jalr	-1752(ra) # 80001bf4 <_Z4putcc>
    while (!threadEnd) {
    800032d4:	0008c797          	auipc	a5,0x8c
    800032d8:	6647a783          	lw	a5,1636(a5) # 8008f938 <_ZL9threadEnd>
    800032dc:	06079063          	bnez	a5,8000333c <_ZL8consumerPv+0xa8>
        int key = data->buffer->get();
    800032e0:	00893503          	ld	a0,8(s2)
    800032e4:	00003097          	auipc	ra,0x3
    800032e8:	a84080e7          	jalr	-1404(ra) # 80005d68 <_ZN6Buffer3getEv>
        i++;
    800032ec:	0019849b          	addiw	s1,s3,1
    800032f0:	0004899b          	sext.w	s3,s1
        putc(key);
    800032f4:	0ff57513          	andi	a0,a0,255
    800032f8:	fffff097          	auipc	ra,0xfffff
    800032fc:	8fc080e7          	jalr	-1796(ra) # 80001bf4 <_Z4putcc>
        if (i % (5 * data->id) == 0) {
    80003300:	00092703          	lw	a4,0(s2)
    80003304:	0027179b          	slliw	a5,a4,0x2
    80003308:	00e787bb          	addw	a5,a5,a4
    8000330c:	02f4e7bb          	remw	a5,s1,a5
    80003310:	fa0786e3          	beqz	a5,800032bc <_ZL8consumerPv+0x28>
        if (i % 80 == 0) {
    80003314:	05000793          	li	a5,80
    80003318:	02f4e4bb          	remw	s1,s1,a5
    8000331c:	fa049ce3          	bnez	s1,800032d4 <_ZL8consumerPv+0x40>
    80003320:	fa9ff06f          	j	800032c8 <_ZL8consumerPv+0x34>
        }
    }

    while (data->buffer->getCnt() > 0) {
        int key = data->buffer->get();
    80003324:	00893503          	ld	a0,8(s2)
    80003328:	00003097          	auipc	ra,0x3
    8000332c:	a40080e7          	jalr	-1472(ra) # 80005d68 <_ZN6Buffer3getEv>
        putc(key);
    80003330:	0ff57513          	andi	a0,a0,255
    80003334:	fffff097          	auipc	ra,0xfffff
    80003338:	8c0080e7          	jalr	-1856(ra) # 80001bf4 <_Z4putcc>
    while (data->buffer->getCnt() > 0) {
    8000333c:	00893503          	ld	a0,8(s2)
    80003340:	00003097          	auipc	ra,0x3
    80003344:	ab4080e7          	jalr	-1356(ra) # 80005df4 <_ZN6Buffer6getCntEv>
    80003348:	fca04ee3          	bgtz	a0,80003324 <_ZL8consumerPv+0x90>
    }

    sem_signal(data->wait);
    8000334c:	01093503          	ld	a0,16(s2)
    80003350:	fffff097          	auipc	ra,0xfffff
    80003354:	824080e7          	jalr	-2012(ra) # 80001b74 <_Z10sem_signalP4_sem>
}
    80003358:	02813083          	ld	ra,40(sp)
    8000335c:	02013403          	ld	s0,32(sp)
    80003360:	01813483          	ld	s1,24(sp)
    80003364:	01013903          	ld	s2,16(sp)
    80003368:	00813983          	ld	s3,8(sp)
    8000336c:	03010113          	addi	sp,sp,48
    80003370:	00008067          	ret

0000000080003374 <_Z22producerConsumer_C_APIv>:

void producerConsumer_C_API() {
    80003374:	f9010113          	addi	sp,sp,-112
    80003378:	06113423          	sd	ra,104(sp)
    8000337c:	06813023          	sd	s0,96(sp)
    80003380:	04913c23          	sd	s1,88(sp)
    80003384:	05213823          	sd	s2,80(sp)
    80003388:	05313423          	sd	s3,72(sp)
    8000338c:	05413023          	sd	s4,64(sp)
    80003390:	03513c23          	sd	s5,56(sp)
    80003394:	03613823          	sd	s6,48(sp)
    80003398:	07010413          	addi	s0,sp,112
        sem_wait(waitForAll);
    }

    sem_close(waitForAll);

    delete buffer;
    8000339c:	00010b13          	mv	s6,sp
    printString("Unesite broj proizvodjaca?\n");
    800033a0:	00006517          	auipc	a0,0x6
    800033a4:	d1850513          	addi	a0,a0,-744 # 800090b8 <CONSOLE_STATUS+0xa8>
    800033a8:	00002097          	auipc	ra,0x2
    800033ac:	a9c080e7          	jalr	-1380(ra) # 80004e44 <_Z11printStringPKc>
    getString(input, 30);
    800033b0:	01e00593          	li	a1,30
    800033b4:	fa040493          	addi	s1,s0,-96
    800033b8:	00048513          	mv	a0,s1
    800033bc:	00002097          	auipc	ra,0x2
    800033c0:	b10080e7          	jalr	-1264(ra) # 80004ecc <_Z9getStringPci>
    threadNum = stringToInt(input);
    800033c4:	00048513          	mv	a0,s1
    800033c8:	00002097          	auipc	ra,0x2
    800033cc:	bdc080e7          	jalr	-1060(ra) # 80004fa4 <_Z11stringToIntPKc>
    800033d0:	00050913          	mv	s2,a0
    printString("Unesite velicinu bafera?\n");
    800033d4:	00006517          	auipc	a0,0x6
    800033d8:	d0450513          	addi	a0,a0,-764 # 800090d8 <CONSOLE_STATUS+0xc8>
    800033dc:	00002097          	auipc	ra,0x2
    800033e0:	a68080e7          	jalr	-1432(ra) # 80004e44 <_Z11printStringPKc>
    getString(input, 30);
    800033e4:	01e00593          	li	a1,30
    800033e8:	00048513          	mv	a0,s1
    800033ec:	00002097          	auipc	ra,0x2
    800033f0:	ae0080e7          	jalr	-1312(ra) # 80004ecc <_Z9getStringPci>
    n = stringToInt(input);
    800033f4:	00048513          	mv	a0,s1
    800033f8:	00002097          	auipc	ra,0x2
    800033fc:	bac080e7          	jalr	-1108(ra) # 80004fa4 <_Z11stringToIntPKc>
    80003400:	00050493          	mv	s1,a0
    printString("Broj proizvodjaca "); printInt(threadNum);
    80003404:	00006517          	auipc	a0,0x6
    80003408:	cf450513          	addi	a0,a0,-780 # 800090f8 <CONSOLE_STATUS+0xe8>
    8000340c:	00002097          	auipc	ra,0x2
    80003410:	a38080e7          	jalr	-1480(ra) # 80004e44 <_Z11printStringPKc>
    80003414:	00000613          	li	a2,0
    80003418:	00a00593          	li	a1,10
    8000341c:	00090513          	mv	a0,s2
    80003420:	00002097          	auipc	ra,0x2
    80003424:	bd4080e7          	jalr	-1068(ra) # 80004ff4 <_Z8printIntiii>
    printString(" i velicina bafera "); printInt(n);
    80003428:	00006517          	auipc	a0,0x6
    8000342c:	ce850513          	addi	a0,a0,-792 # 80009110 <CONSOLE_STATUS+0x100>
    80003430:	00002097          	auipc	ra,0x2
    80003434:	a14080e7          	jalr	-1516(ra) # 80004e44 <_Z11printStringPKc>
    80003438:	00000613          	li	a2,0
    8000343c:	00a00593          	li	a1,10
    80003440:	00048513          	mv	a0,s1
    80003444:	00002097          	auipc	ra,0x2
    80003448:	bb0080e7          	jalr	-1104(ra) # 80004ff4 <_Z8printIntiii>
    printString(".\n");
    8000344c:	00006517          	auipc	a0,0x6
    80003450:	cdc50513          	addi	a0,a0,-804 # 80009128 <CONSOLE_STATUS+0x118>
    80003454:	00002097          	auipc	ra,0x2
    80003458:	9f0080e7          	jalr	-1552(ra) # 80004e44 <_Z11printStringPKc>
    if(threadNum > n) {
    8000345c:	0324c463          	blt	s1,s2,80003484 <_Z22producerConsumer_C_APIv+0x110>
    } else if (threadNum < 1) {
    80003460:	03205c63          	blez	s2,80003498 <_Z22producerConsumer_C_APIv+0x124>
    Buffer *buffer = new Buffer(n);
    80003464:	03800513          	li	a0,56
    80003468:	fffff097          	auipc	ra,0xfffff
    8000346c:	4e4080e7          	jalr	1252(ra) # 8000294c <_Znwm>
    80003470:	00050a13          	mv	s4,a0
    80003474:	00048593          	mv	a1,s1
    80003478:	00002097          	auipc	ra,0x2
    8000347c:	7c4080e7          	jalr	1988(ra) # 80005c3c <_ZN6BufferC1Ei>
    80003480:	0300006f          	j	800034b0 <_Z22producerConsumer_C_APIv+0x13c>
        printString("Broj proizvodjaca ne sme biti manji od velicine bafera!\n");
    80003484:	00006517          	auipc	a0,0x6
    80003488:	cac50513          	addi	a0,a0,-852 # 80009130 <CONSOLE_STATUS+0x120>
    8000348c:	00002097          	auipc	ra,0x2
    80003490:	9b8080e7          	jalr	-1608(ra) # 80004e44 <_Z11printStringPKc>
        return;
    80003494:	0140006f          	j	800034a8 <_Z22producerConsumer_C_APIv+0x134>
        printString("Broj proizvodjaca mora biti veci od nula!\n");
    80003498:	00006517          	auipc	a0,0x6
    8000349c:	cd850513          	addi	a0,a0,-808 # 80009170 <CONSOLE_STATUS+0x160>
    800034a0:	00002097          	auipc	ra,0x2
    800034a4:	9a4080e7          	jalr	-1628(ra) # 80004e44 <_Z11printStringPKc>
        return;
    800034a8:	000b0113          	mv	sp,s6
    800034ac:	1500006f          	j	800035fc <_Z22producerConsumer_C_APIv+0x288>
    sem_open(&waitForAll, 0);
    800034b0:	00000593          	li	a1,0
    800034b4:	0008c517          	auipc	a0,0x8c
    800034b8:	48c50513          	addi	a0,a0,1164 # 8008f940 <_ZL10waitForAll>
    800034bc:	ffffe097          	auipc	ra,0xffffe
    800034c0:	630080e7          	jalr	1584(ra) # 80001aec <_Z8sem_openPP4_semj>
    thread_t threads[threadNum];
    800034c4:	00391793          	slli	a5,s2,0x3
    800034c8:	00f78793          	addi	a5,a5,15
    800034cc:	ff07f793          	andi	a5,a5,-16
    800034d0:	40f10133          	sub	sp,sp,a5
    800034d4:	00010a93          	mv	s5,sp
    struct thread_data data[threadNum + 1];
    800034d8:	0019071b          	addiw	a4,s2,1
    800034dc:	00171793          	slli	a5,a4,0x1
    800034e0:	00e787b3          	add	a5,a5,a4
    800034e4:	00379793          	slli	a5,a5,0x3
    800034e8:	00f78793          	addi	a5,a5,15
    800034ec:	ff07f793          	andi	a5,a5,-16
    800034f0:	40f10133          	sub	sp,sp,a5
    800034f4:	00010993          	mv	s3,sp
    data[threadNum].id = threadNum;
    800034f8:	00191613          	slli	a2,s2,0x1
    800034fc:	012607b3          	add	a5,a2,s2
    80003500:	00379793          	slli	a5,a5,0x3
    80003504:	00f987b3          	add	a5,s3,a5
    80003508:	0127a023          	sw	s2,0(a5)
    data[threadNum].buffer = buffer;
    8000350c:	0147b423          	sd	s4,8(a5)
    data[threadNum].wait = waitForAll;
    80003510:	0008c717          	auipc	a4,0x8c
    80003514:	43073703          	ld	a4,1072(a4) # 8008f940 <_ZL10waitForAll>
    80003518:	00e7b823          	sd	a4,16(a5)
    thread_create(&consumerThread, consumer, data + threadNum);
    8000351c:	00078613          	mv	a2,a5
    80003520:	00000597          	auipc	a1,0x0
    80003524:	d7458593          	addi	a1,a1,-652 # 80003294 <_ZL8consumerPv>
    80003528:	f9840513          	addi	a0,s0,-104
    8000352c:	ffffe097          	auipc	ra,0xffffe
    80003530:	4e4080e7          	jalr	1252(ra) # 80001a10 <_Z13thread_createPP7_threadPFvPvES2_>
    for (int i = 0; i < threadNum; i++) {
    80003534:	00000493          	li	s1,0
    80003538:	0280006f          	j	80003560 <_Z22producerConsumer_C_APIv+0x1ec>
        thread_create(threads + i,
    8000353c:	00000597          	auipc	a1,0x0
    80003540:	c1458593          	addi	a1,a1,-1004 # 80003150 <_ZL16producerKeyboardPv>
                      data + i);
    80003544:	00179613          	slli	a2,a5,0x1
    80003548:	00f60633          	add	a2,a2,a5
    8000354c:	00361613          	slli	a2,a2,0x3
        thread_create(threads + i,
    80003550:	00c98633          	add	a2,s3,a2
    80003554:	ffffe097          	auipc	ra,0xffffe
    80003558:	4bc080e7          	jalr	1212(ra) # 80001a10 <_Z13thread_createPP7_threadPFvPvES2_>
    for (int i = 0; i < threadNum; i++) {
    8000355c:	0014849b          	addiw	s1,s1,1
    80003560:	0524d263          	bge	s1,s2,800035a4 <_Z22producerConsumer_C_APIv+0x230>
        data[i].id = i;
    80003564:	00149793          	slli	a5,s1,0x1
    80003568:	009787b3          	add	a5,a5,s1
    8000356c:	00379793          	slli	a5,a5,0x3
    80003570:	00f987b3          	add	a5,s3,a5
    80003574:	0097a023          	sw	s1,0(a5)
        data[i].buffer = buffer;
    80003578:	0147b423          	sd	s4,8(a5)
        data[i].wait = waitForAll;
    8000357c:	0008c717          	auipc	a4,0x8c
    80003580:	3c473703          	ld	a4,964(a4) # 8008f940 <_ZL10waitForAll>
    80003584:	00e7b823          	sd	a4,16(a5)
        thread_create(threads + i,
    80003588:	00048793          	mv	a5,s1
    8000358c:	00349513          	slli	a0,s1,0x3
    80003590:	00aa8533          	add	a0,s5,a0
    80003594:	fa9054e3          	blez	s1,8000353c <_Z22producerConsumer_C_APIv+0x1c8>
    80003598:	00000597          	auipc	a1,0x0
    8000359c:	c6858593          	addi	a1,a1,-920 # 80003200 <_ZL8producerPv>
    800035a0:	fa5ff06f          	j	80003544 <_Z22producerConsumer_C_APIv+0x1d0>
    thread_dispatch();
    800035a4:	ffffe097          	auipc	ra,0xffffe
    800035a8:	504080e7          	jalr	1284(ra) # 80001aa8 <_Z15thread_dispatchv>
    for (int i = 0; i <= threadNum; i++) {
    800035ac:	00000493          	li	s1,0
    800035b0:	00994e63          	blt	s2,s1,800035cc <_Z22producerConsumer_C_APIv+0x258>
        sem_wait(waitForAll);
    800035b4:	0008c517          	auipc	a0,0x8c
    800035b8:	38c53503          	ld	a0,908(a0) # 8008f940 <_ZL10waitForAll>
    800035bc:	ffffe097          	auipc	ra,0xffffe
    800035c0:	58c080e7          	jalr	1420(ra) # 80001b48 <_Z8sem_waitP4_sem>
    for (int i = 0; i <= threadNum; i++) {
    800035c4:	0014849b          	addiw	s1,s1,1
    800035c8:	fe9ff06f          	j	800035b0 <_Z22producerConsumer_C_APIv+0x23c>
    sem_close(waitForAll);
    800035cc:	0008c517          	auipc	a0,0x8c
    800035d0:	37453503          	ld	a0,884(a0) # 8008f940 <_ZL10waitForAll>
    800035d4:	ffffe097          	auipc	ra,0xffffe
    800035d8:	548080e7          	jalr	1352(ra) # 80001b1c <_Z9sem_closeP4_sem>
    delete buffer;
    800035dc:	000a0e63          	beqz	s4,800035f8 <_Z22producerConsumer_C_APIv+0x284>
    800035e0:	000a0513          	mv	a0,s4
    800035e4:	00003097          	auipc	ra,0x3
    800035e8:	898080e7          	jalr	-1896(ra) # 80005e7c <_ZN6BufferD1Ev>
    800035ec:	000a0513          	mv	a0,s4
    800035f0:	fffff097          	auipc	ra,0xfffff
    800035f4:	384080e7          	jalr	900(ra) # 80002974 <_ZdlPv>
    800035f8:	000b0113          	mv	sp,s6

}
    800035fc:	f9040113          	addi	sp,s0,-112
    80003600:	06813083          	ld	ra,104(sp)
    80003604:	06013403          	ld	s0,96(sp)
    80003608:	05813483          	ld	s1,88(sp)
    8000360c:	05013903          	ld	s2,80(sp)
    80003610:	04813983          	ld	s3,72(sp)
    80003614:	04013a03          	ld	s4,64(sp)
    80003618:	03813a83          	ld	s5,56(sp)
    8000361c:	03013b03          	ld	s6,48(sp)
    80003620:	07010113          	addi	sp,sp,112
    80003624:	00008067          	ret
    80003628:	00050493          	mv	s1,a0
    Buffer *buffer = new Buffer(n);
    8000362c:	000a0513          	mv	a0,s4
    80003630:	fffff097          	auipc	ra,0xfffff
    80003634:	344080e7          	jalr	836(ra) # 80002974 <_ZdlPv>
    80003638:	00048513          	mv	a0,s1
    8000363c:	0008d097          	auipc	ra,0x8d
    80003640:	3fc080e7          	jalr	1020(ra) # 80090a38 <_Unwind_Resume>

0000000080003644 <_ZL9fibonaccim>:
static volatile bool finishedA = false;
static volatile bool finishedB = false;
static volatile bool finishedC = false;
static volatile bool finishedD = false;

static uint64 fibonacci(uint64 n) {
    80003644:	fe010113          	addi	sp,sp,-32
    80003648:	00113c23          	sd	ra,24(sp)
    8000364c:	00813823          	sd	s0,16(sp)
    80003650:	00913423          	sd	s1,8(sp)
    80003654:	01213023          	sd	s2,0(sp)
    80003658:	02010413          	addi	s0,sp,32
    8000365c:	00050493          	mv	s1,a0
    if (n == 0 || n == 1) { return n; }
    80003660:	00100793          	li	a5,1
    80003664:	02a7f863          	bgeu	a5,a0,80003694 <_ZL9fibonaccim+0x50>
    if (n % 10 == 0) { thread_dispatch(); }
    80003668:	00a00793          	li	a5,10
    8000366c:	02f577b3          	remu	a5,a0,a5
    80003670:	02078e63          	beqz	a5,800036ac <_ZL9fibonaccim+0x68>
    return fibonacci(n - 1) + fibonacci(n - 2);
    80003674:	fff48513          	addi	a0,s1,-1
    80003678:	00000097          	auipc	ra,0x0
    8000367c:	fcc080e7          	jalr	-52(ra) # 80003644 <_ZL9fibonaccim>
    80003680:	00050913          	mv	s2,a0
    80003684:	ffe48513          	addi	a0,s1,-2
    80003688:	00000097          	auipc	ra,0x0
    8000368c:	fbc080e7          	jalr	-68(ra) # 80003644 <_ZL9fibonaccim>
    80003690:	00a90533          	add	a0,s2,a0
}
    80003694:	01813083          	ld	ra,24(sp)
    80003698:	01013403          	ld	s0,16(sp)
    8000369c:	00813483          	ld	s1,8(sp)
    800036a0:	00013903          	ld	s2,0(sp)
    800036a4:	02010113          	addi	sp,sp,32
    800036a8:	00008067          	ret
    if (n % 10 == 0) { thread_dispatch(); }
    800036ac:	ffffe097          	auipc	ra,0xffffe
    800036b0:	3fc080e7          	jalr	1020(ra) # 80001aa8 <_Z15thread_dispatchv>
    800036b4:	fc1ff06f          	j	80003674 <_ZL9fibonaccim+0x30>

00000000800036b8 <_ZN7WorkerA11workerBodyAEPv>:
    void run() override {
        workerBodyD(nullptr);
    }
};

void WorkerA::workerBodyA(void *arg) {
    800036b8:	fe010113          	addi	sp,sp,-32
    800036bc:	00113c23          	sd	ra,24(sp)
    800036c0:	00813823          	sd	s0,16(sp)
    800036c4:	00913423          	sd	s1,8(sp)
    800036c8:	01213023          	sd	s2,0(sp)
    800036cc:	02010413          	addi	s0,sp,32
    for (uint64 i = 0; i < 10; i++) {
    800036d0:	00000913          	li	s2,0
    800036d4:	0380006f          	j	8000370c <_ZN7WorkerA11workerBodyAEPv+0x54>
        printString("A: i="); printInt(i); printString("\n");
        for (uint64 j = 0; j < 10000; j++) {
            for (uint64 k = 0; k < 30000; k++) { /* busy wait */ }
            thread_dispatch();
    800036d8:	ffffe097          	auipc	ra,0xffffe
    800036dc:	3d0080e7          	jalr	976(ra) # 80001aa8 <_Z15thread_dispatchv>
        for (uint64 j = 0; j < 10000; j++) {
    800036e0:	00148493          	addi	s1,s1,1
    800036e4:	000027b7          	lui	a5,0x2
    800036e8:	70f78793          	addi	a5,a5,1807 # 270f <_entry-0x7fffd8f1>
    800036ec:	0097ee63          	bltu	a5,s1,80003708 <_ZN7WorkerA11workerBodyAEPv+0x50>
            for (uint64 k = 0; k < 30000; k++) { /* busy wait */ }
    800036f0:	00000713          	li	a4,0
    800036f4:	000077b7          	lui	a5,0x7
    800036f8:	52f78793          	addi	a5,a5,1327 # 752f <_entry-0x7fff8ad1>
    800036fc:	fce7eee3          	bltu	a5,a4,800036d8 <_ZN7WorkerA11workerBodyAEPv+0x20>
    80003700:	00170713          	addi	a4,a4,1
    80003704:	ff1ff06f          	j	800036f4 <_ZN7WorkerA11workerBodyAEPv+0x3c>
    for (uint64 i = 0; i < 10; i++) {
    80003708:	00190913          	addi	s2,s2,1
    8000370c:	00900793          	li	a5,9
    80003710:	0527e063          	bltu	a5,s2,80003750 <_ZN7WorkerA11workerBodyAEPv+0x98>
        printString("A: i="); printInt(i); printString("\n");
    80003714:	00006517          	auipc	a0,0x6
    80003718:	a8c50513          	addi	a0,a0,-1396 # 800091a0 <CONSOLE_STATUS+0x190>
    8000371c:	00001097          	auipc	ra,0x1
    80003720:	728080e7          	jalr	1832(ra) # 80004e44 <_Z11printStringPKc>
    80003724:	00000613          	li	a2,0
    80003728:	00a00593          	li	a1,10
    8000372c:	0009051b          	sext.w	a0,s2
    80003730:	00002097          	auipc	ra,0x2
    80003734:	8c4080e7          	jalr	-1852(ra) # 80004ff4 <_Z8printIntiii>
    80003738:	00006517          	auipc	a0,0x6
    8000373c:	ce850513          	addi	a0,a0,-792 # 80009420 <CONSOLE_STATUS+0x410>
    80003740:	00001097          	auipc	ra,0x1
    80003744:	704080e7          	jalr	1796(ra) # 80004e44 <_Z11printStringPKc>
        for (uint64 j = 0; j < 10000; j++) {
    80003748:	00000493          	li	s1,0
    8000374c:	f99ff06f          	j	800036e4 <_ZN7WorkerA11workerBodyAEPv+0x2c>
        }
    }
    printString("A finished!\n");
    80003750:	00006517          	auipc	a0,0x6
    80003754:	a5850513          	addi	a0,a0,-1448 # 800091a8 <CONSOLE_STATUS+0x198>
    80003758:	00001097          	auipc	ra,0x1
    8000375c:	6ec080e7          	jalr	1772(ra) # 80004e44 <_Z11printStringPKc>
    finishedA = true;
    80003760:	00100793          	li	a5,1
    80003764:	0008c717          	auipc	a4,0x8c
    80003768:	1ef70223          	sb	a5,484(a4) # 8008f948 <_ZL9finishedA>
}
    8000376c:	01813083          	ld	ra,24(sp)
    80003770:	01013403          	ld	s0,16(sp)
    80003774:	00813483          	ld	s1,8(sp)
    80003778:	00013903          	ld	s2,0(sp)
    8000377c:	02010113          	addi	sp,sp,32
    80003780:	00008067          	ret

0000000080003784 <_ZN7WorkerB11workerBodyBEPv>:

void WorkerB::workerBodyB(void *arg) {
    80003784:	fe010113          	addi	sp,sp,-32
    80003788:	00113c23          	sd	ra,24(sp)
    8000378c:	00813823          	sd	s0,16(sp)
    80003790:	00913423          	sd	s1,8(sp)
    80003794:	01213023          	sd	s2,0(sp)
    80003798:	02010413          	addi	s0,sp,32
    for (uint64 i = 0; i < 16; i++) {
    8000379c:	00000913          	li	s2,0
    800037a0:	0380006f          	j	800037d8 <_ZN7WorkerB11workerBodyBEPv+0x54>
        printString("B: i="); printInt(i); printString("\n");
        for (uint64 j = 0; j < 10000; j++) {
            for (uint64 k = 0; k < 30000; k++) { /* busy wait */ }
            thread_dispatch();
    800037a4:	ffffe097          	auipc	ra,0xffffe
    800037a8:	304080e7          	jalr	772(ra) # 80001aa8 <_Z15thread_dispatchv>
        for (uint64 j = 0; j < 10000; j++) {
    800037ac:	00148493          	addi	s1,s1,1
    800037b0:	000027b7          	lui	a5,0x2
    800037b4:	70f78793          	addi	a5,a5,1807 # 270f <_entry-0x7fffd8f1>
    800037b8:	0097ee63          	bltu	a5,s1,800037d4 <_ZN7WorkerB11workerBodyBEPv+0x50>
            for (uint64 k = 0; k < 30000; k++) { /* busy wait */ }
    800037bc:	00000713          	li	a4,0
    800037c0:	000077b7          	lui	a5,0x7
    800037c4:	52f78793          	addi	a5,a5,1327 # 752f <_entry-0x7fff8ad1>
    800037c8:	fce7eee3          	bltu	a5,a4,800037a4 <_ZN7WorkerB11workerBodyBEPv+0x20>
    800037cc:	00170713          	addi	a4,a4,1
    800037d0:	ff1ff06f          	j	800037c0 <_ZN7WorkerB11workerBodyBEPv+0x3c>
    for (uint64 i = 0; i < 16; i++) {
    800037d4:	00190913          	addi	s2,s2,1
    800037d8:	00f00793          	li	a5,15
    800037dc:	0527e063          	bltu	a5,s2,8000381c <_ZN7WorkerB11workerBodyBEPv+0x98>
        printString("B: i="); printInt(i); printString("\n");
    800037e0:	00006517          	auipc	a0,0x6
    800037e4:	9d850513          	addi	a0,a0,-1576 # 800091b8 <CONSOLE_STATUS+0x1a8>
    800037e8:	00001097          	auipc	ra,0x1
    800037ec:	65c080e7          	jalr	1628(ra) # 80004e44 <_Z11printStringPKc>
    800037f0:	00000613          	li	a2,0
    800037f4:	00a00593          	li	a1,10
    800037f8:	0009051b          	sext.w	a0,s2
    800037fc:	00001097          	auipc	ra,0x1
    80003800:	7f8080e7          	jalr	2040(ra) # 80004ff4 <_Z8printIntiii>
    80003804:	00006517          	auipc	a0,0x6
    80003808:	c1c50513          	addi	a0,a0,-996 # 80009420 <CONSOLE_STATUS+0x410>
    8000380c:	00001097          	auipc	ra,0x1
    80003810:	638080e7          	jalr	1592(ra) # 80004e44 <_Z11printStringPKc>
        for (uint64 j = 0; j < 10000; j++) {
    80003814:	00000493          	li	s1,0
    80003818:	f99ff06f          	j	800037b0 <_ZN7WorkerB11workerBodyBEPv+0x2c>
        }
    }
    printString("B finished!\n");
    8000381c:	00006517          	auipc	a0,0x6
    80003820:	9a450513          	addi	a0,a0,-1628 # 800091c0 <CONSOLE_STATUS+0x1b0>
    80003824:	00001097          	auipc	ra,0x1
    80003828:	620080e7          	jalr	1568(ra) # 80004e44 <_Z11printStringPKc>
    finishedB = true;
    8000382c:	00100793          	li	a5,1
    80003830:	0008c717          	auipc	a4,0x8c
    80003834:	10f70ca3          	sb	a5,281(a4) # 8008f949 <_ZL9finishedB>
    thread_dispatch();
    80003838:	ffffe097          	auipc	ra,0xffffe
    8000383c:	270080e7          	jalr	624(ra) # 80001aa8 <_Z15thread_dispatchv>
}
    80003840:	01813083          	ld	ra,24(sp)
    80003844:	01013403          	ld	s0,16(sp)
    80003848:	00813483          	ld	s1,8(sp)
    8000384c:	00013903          	ld	s2,0(sp)
    80003850:	02010113          	addi	sp,sp,32
    80003854:	00008067          	ret

0000000080003858 <_ZN7WorkerC11workerBodyCEPv>:

void WorkerC::workerBodyC(void *arg) {
    80003858:	fe010113          	addi	sp,sp,-32
    8000385c:	00113c23          	sd	ra,24(sp)
    80003860:	00813823          	sd	s0,16(sp)
    80003864:	00913423          	sd	s1,8(sp)
    80003868:	01213023          	sd	s2,0(sp)
    8000386c:	02010413          	addi	s0,sp,32
    uint8 i = 0;
    80003870:	00000493          	li	s1,0
    80003874:	0400006f          	j	800038b4 <_ZN7WorkerC11workerBodyCEPv+0x5c>
    for (; i < 3; i++) {
        printString("C: i="); printInt(i); printString("\n");
    80003878:	00006517          	auipc	a0,0x6
    8000387c:	95850513          	addi	a0,a0,-1704 # 800091d0 <CONSOLE_STATUS+0x1c0>
    80003880:	00001097          	auipc	ra,0x1
    80003884:	5c4080e7          	jalr	1476(ra) # 80004e44 <_Z11printStringPKc>
    80003888:	00000613          	li	a2,0
    8000388c:	00a00593          	li	a1,10
    80003890:	00048513          	mv	a0,s1
    80003894:	00001097          	auipc	ra,0x1
    80003898:	760080e7          	jalr	1888(ra) # 80004ff4 <_Z8printIntiii>
    8000389c:	00006517          	auipc	a0,0x6
    800038a0:	b8450513          	addi	a0,a0,-1148 # 80009420 <CONSOLE_STATUS+0x410>
    800038a4:	00001097          	auipc	ra,0x1
    800038a8:	5a0080e7          	jalr	1440(ra) # 80004e44 <_Z11printStringPKc>
    for (; i < 3; i++) {
    800038ac:	0014849b          	addiw	s1,s1,1
    800038b0:	0ff4f493          	andi	s1,s1,255
    800038b4:	00200793          	li	a5,2
    800038b8:	fc97f0e3          	bgeu	a5,s1,80003878 <_ZN7WorkerC11workerBodyCEPv+0x20>
    }

    printString("C: dispatch\n");
    800038bc:	00006517          	auipc	a0,0x6
    800038c0:	91c50513          	addi	a0,a0,-1764 # 800091d8 <CONSOLE_STATUS+0x1c8>
    800038c4:	00001097          	auipc	ra,0x1
    800038c8:	580080e7          	jalr	1408(ra) # 80004e44 <_Z11printStringPKc>
    __asm__ ("li t1, 7");
    800038cc:	00700313          	li	t1,7
    thread_dispatch();
    800038d0:	ffffe097          	auipc	ra,0xffffe
    800038d4:	1d8080e7          	jalr	472(ra) # 80001aa8 <_Z15thread_dispatchv>

    uint64 t1 = 0;
    __asm__ ("mv %[t1], t1" : [t1] "=r"(t1));
    800038d8:	00030913          	mv	s2,t1

    printString("C: t1="); printInt(t1); printString("\n");
    800038dc:	00006517          	auipc	a0,0x6
    800038e0:	90c50513          	addi	a0,a0,-1780 # 800091e8 <CONSOLE_STATUS+0x1d8>
    800038e4:	00001097          	auipc	ra,0x1
    800038e8:	560080e7          	jalr	1376(ra) # 80004e44 <_Z11printStringPKc>
    800038ec:	00000613          	li	a2,0
    800038f0:	00a00593          	li	a1,10
    800038f4:	0009051b          	sext.w	a0,s2
    800038f8:	00001097          	auipc	ra,0x1
    800038fc:	6fc080e7          	jalr	1788(ra) # 80004ff4 <_Z8printIntiii>
    80003900:	00006517          	auipc	a0,0x6
    80003904:	b2050513          	addi	a0,a0,-1248 # 80009420 <CONSOLE_STATUS+0x410>
    80003908:	00001097          	auipc	ra,0x1
    8000390c:	53c080e7          	jalr	1340(ra) # 80004e44 <_Z11printStringPKc>

    uint64 result = fibonacci(12);
    80003910:	00c00513          	li	a0,12
    80003914:	00000097          	auipc	ra,0x0
    80003918:	d30080e7          	jalr	-720(ra) # 80003644 <_ZL9fibonaccim>
    8000391c:	00050913          	mv	s2,a0
    printString("C: fibonaci="); printInt(result); printString("\n");
    80003920:	00006517          	auipc	a0,0x6
    80003924:	8d050513          	addi	a0,a0,-1840 # 800091f0 <CONSOLE_STATUS+0x1e0>
    80003928:	00001097          	auipc	ra,0x1
    8000392c:	51c080e7          	jalr	1308(ra) # 80004e44 <_Z11printStringPKc>
    80003930:	00000613          	li	a2,0
    80003934:	00a00593          	li	a1,10
    80003938:	0009051b          	sext.w	a0,s2
    8000393c:	00001097          	auipc	ra,0x1
    80003940:	6b8080e7          	jalr	1720(ra) # 80004ff4 <_Z8printIntiii>
    80003944:	00006517          	auipc	a0,0x6
    80003948:	adc50513          	addi	a0,a0,-1316 # 80009420 <CONSOLE_STATUS+0x410>
    8000394c:	00001097          	auipc	ra,0x1
    80003950:	4f8080e7          	jalr	1272(ra) # 80004e44 <_Z11printStringPKc>
    80003954:	0400006f          	j	80003994 <_ZN7WorkerC11workerBodyCEPv+0x13c>

    for (; i < 6; i++) {
        printString("C: i="); printInt(i); printString("\n");
    80003958:	00006517          	auipc	a0,0x6
    8000395c:	87850513          	addi	a0,a0,-1928 # 800091d0 <CONSOLE_STATUS+0x1c0>
    80003960:	00001097          	auipc	ra,0x1
    80003964:	4e4080e7          	jalr	1252(ra) # 80004e44 <_Z11printStringPKc>
    80003968:	00000613          	li	a2,0
    8000396c:	00a00593          	li	a1,10
    80003970:	00048513          	mv	a0,s1
    80003974:	00001097          	auipc	ra,0x1
    80003978:	680080e7          	jalr	1664(ra) # 80004ff4 <_Z8printIntiii>
    8000397c:	00006517          	auipc	a0,0x6
    80003980:	aa450513          	addi	a0,a0,-1372 # 80009420 <CONSOLE_STATUS+0x410>
    80003984:	00001097          	auipc	ra,0x1
    80003988:	4c0080e7          	jalr	1216(ra) # 80004e44 <_Z11printStringPKc>
    for (; i < 6; i++) {
    8000398c:	0014849b          	addiw	s1,s1,1
    80003990:	0ff4f493          	andi	s1,s1,255
    80003994:	00500793          	li	a5,5
    80003998:	fc97f0e3          	bgeu	a5,s1,80003958 <_ZN7WorkerC11workerBodyCEPv+0x100>
    }

    printString("A finished!\n");
    8000399c:	00006517          	auipc	a0,0x6
    800039a0:	80c50513          	addi	a0,a0,-2036 # 800091a8 <CONSOLE_STATUS+0x198>
    800039a4:	00001097          	auipc	ra,0x1
    800039a8:	4a0080e7          	jalr	1184(ra) # 80004e44 <_Z11printStringPKc>
    finishedC = true;
    800039ac:	00100793          	li	a5,1
    800039b0:	0008c717          	auipc	a4,0x8c
    800039b4:	f8f70d23          	sb	a5,-102(a4) # 8008f94a <_ZL9finishedC>
    thread_dispatch();
    800039b8:	ffffe097          	auipc	ra,0xffffe
    800039bc:	0f0080e7          	jalr	240(ra) # 80001aa8 <_Z15thread_dispatchv>
}
    800039c0:	01813083          	ld	ra,24(sp)
    800039c4:	01013403          	ld	s0,16(sp)
    800039c8:	00813483          	ld	s1,8(sp)
    800039cc:	00013903          	ld	s2,0(sp)
    800039d0:	02010113          	addi	sp,sp,32
    800039d4:	00008067          	ret

00000000800039d8 <_ZN7WorkerD11workerBodyDEPv>:

void WorkerD::workerBodyD(void* arg) {
    800039d8:	fe010113          	addi	sp,sp,-32
    800039dc:	00113c23          	sd	ra,24(sp)
    800039e0:	00813823          	sd	s0,16(sp)
    800039e4:	00913423          	sd	s1,8(sp)
    800039e8:	01213023          	sd	s2,0(sp)
    800039ec:	02010413          	addi	s0,sp,32
    uint8 i = 10;
    800039f0:	00a00493          	li	s1,10
    800039f4:	0400006f          	j	80003a34 <_ZN7WorkerD11workerBodyDEPv+0x5c>
    for (; i < 13; i++) {
        printString("D: i="); printInt(i); printString("\n");
    800039f8:	00006517          	auipc	a0,0x6
    800039fc:	80850513          	addi	a0,a0,-2040 # 80009200 <CONSOLE_STATUS+0x1f0>
    80003a00:	00001097          	auipc	ra,0x1
    80003a04:	444080e7          	jalr	1092(ra) # 80004e44 <_Z11printStringPKc>
    80003a08:	00000613          	li	a2,0
    80003a0c:	00a00593          	li	a1,10
    80003a10:	00048513          	mv	a0,s1
    80003a14:	00001097          	auipc	ra,0x1
    80003a18:	5e0080e7          	jalr	1504(ra) # 80004ff4 <_Z8printIntiii>
    80003a1c:	00006517          	auipc	a0,0x6
    80003a20:	a0450513          	addi	a0,a0,-1532 # 80009420 <CONSOLE_STATUS+0x410>
    80003a24:	00001097          	auipc	ra,0x1
    80003a28:	420080e7          	jalr	1056(ra) # 80004e44 <_Z11printStringPKc>
    for (; i < 13; i++) {
    80003a2c:	0014849b          	addiw	s1,s1,1
    80003a30:	0ff4f493          	andi	s1,s1,255
    80003a34:	00c00793          	li	a5,12
    80003a38:	fc97f0e3          	bgeu	a5,s1,800039f8 <_ZN7WorkerD11workerBodyDEPv+0x20>
    }

    printString("D: dispatch\n");
    80003a3c:	00005517          	auipc	a0,0x5
    80003a40:	7cc50513          	addi	a0,a0,1996 # 80009208 <CONSOLE_STATUS+0x1f8>
    80003a44:	00001097          	auipc	ra,0x1
    80003a48:	400080e7          	jalr	1024(ra) # 80004e44 <_Z11printStringPKc>
    __asm__ ("li t1, 5");
    80003a4c:	00500313          	li	t1,5
    thread_dispatch();
    80003a50:	ffffe097          	auipc	ra,0xffffe
    80003a54:	058080e7          	jalr	88(ra) # 80001aa8 <_Z15thread_dispatchv>

    uint64 result = fibonacci(16);
    80003a58:	01000513          	li	a0,16
    80003a5c:	00000097          	auipc	ra,0x0
    80003a60:	be8080e7          	jalr	-1048(ra) # 80003644 <_ZL9fibonaccim>
    80003a64:	00050913          	mv	s2,a0
    printString("D: fibonaci="); printInt(result); printString("\n");
    80003a68:	00005517          	auipc	a0,0x5
    80003a6c:	7b050513          	addi	a0,a0,1968 # 80009218 <CONSOLE_STATUS+0x208>
    80003a70:	00001097          	auipc	ra,0x1
    80003a74:	3d4080e7          	jalr	980(ra) # 80004e44 <_Z11printStringPKc>
    80003a78:	00000613          	li	a2,0
    80003a7c:	00a00593          	li	a1,10
    80003a80:	0009051b          	sext.w	a0,s2
    80003a84:	00001097          	auipc	ra,0x1
    80003a88:	570080e7          	jalr	1392(ra) # 80004ff4 <_Z8printIntiii>
    80003a8c:	00006517          	auipc	a0,0x6
    80003a90:	99450513          	addi	a0,a0,-1644 # 80009420 <CONSOLE_STATUS+0x410>
    80003a94:	00001097          	auipc	ra,0x1
    80003a98:	3b0080e7          	jalr	944(ra) # 80004e44 <_Z11printStringPKc>
    80003a9c:	0400006f          	j	80003adc <_ZN7WorkerD11workerBodyDEPv+0x104>

    for (; i < 16; i++) {
        printString("D: i="); printInt(i); printString("\n");
    80003aa0:	00005517          	auipc	a0,0x5
    80003aa4:	76050513          	addi	a0,a0,1888 # 80009200 <CONSOLE_STATUS+0x1f0>
    80003aa8:	00001097          	auipc	ra,0x1
    80003aac:	39c080e7          	jalr	924(ra) # 80004e44 <_Z11printStringPKc>
    80003ab0:	00000613          	li	a2,0
    80003ab4:	00a00593          	li	a1,10
    80003ab8:	00048513          	mv	a0,s1
    80003abc:	00001097          	auipc	ra,0x1
    80003ac0:	538080e7          	jalr	1336(ra) # 80004ff4 <_Z8printIntiii>
    80003ac4:	00006517          	auipc	a0,0x6
    80003ac8:	95c50513          	addi	a0,a0,-1700 # 80009420 <CONSOLE_STATUS+0x410>
    80003acc:	00001097          	auipc	ra,0x1
    80003ad0:	378080e7          	jalr	888(ra) # 80004e44 <_Z11printStringPKc>
    for (; i < 16; i++) {
    80003ad4:	0014849b          	addiw	s1,s1,1
    80003ad8:	0ff4f493          	andi	s1,s1,255
    80003adc:	00f00793          	li	a5,15
    80003ae0:	fc97f0e3          	bgeu	a5,s1,80003aa0 <_ZN7WorkerD11workerBodyDEPv+0xc8>
    }

    printString("D finished!\n");
    80003ae4:	00005517          	auipc	a0,0x5
    80003ae8:	74450513          	addi	a0,a0,1860 # 80009228 <CONSOLE_STATUS+0x218>
    80003aec:	00001097          	auipc	ra,0x1
    80003af0:	358080e7          	jalr	856(ra) # 80004e44 <_Z11printStringPKc>
    finishedD = true;
    80003af4:	00100793          	li	a5,1
    80003af8:	0008c717          	auipc	a4,0x8c
    80003afc:	e4f709a3          	sb	a5,-429(a4) # 8008f94b <_ZL9finishedD>
    thread_dispatch();
    80003b00:	ffffe097          	auipc	ra,0xffffe
    80003b04:	fa8080e7          	jalr	-88(ra) # 80001aa8 <_Z15thread_dispatchv>
}
    80003b08:	01813083          	ld	ra,24(sp)
    80003b0c:	01013403          	ld	s0,16(sp)
    80003b10:	00813483          	ld	s1,8(sp)
    80003b14:	00013903          	ld	s2,0(sp)
    80003b18:	02010113          	addi	sp,sp,32
    80003b1c:	00008067          	ret

0000000080003b20 <_Z20Threads_CPP_API_testv>:


void Threads_CPP_API_test() {
    80003b20:	fc010113          	addi	sp,sp,-64
    80003b24:	02113c23          	sd	ra,56(sp)
    80003b28:	02813823          	sd	s0,48(sp)
    80003b2c:	02913423          	sd	s1,40(sp)
    80003b30:	03213023          	sd	s2,32(sp)
    80003b34:	04010413          	addi	s0,sp,64
    Thread* threads[4];

    threads[0] = new WorkerA();
    80003b38:	02000513          	li	a0,32
    80003b3c:	fffff097          	auipc	ra,0xfffff
    80003b40:	e10080e7          	jalr	-496(ra) # 8000294c <_Znwm>
    80003b44:	00050493          	mv	s1,a0
    WorkerA():Thread() {}
    80003b48:	fffff097          	auipc	ra,0xfffff
    80003b4c:	f88080e7          	jalr	-120(ra) # 80002ad0 <_ZN6ThreadC1Ev>
    80003b50:	00007797          	auipc	a5,0x7
    80003b54:	6b078793          	addi	a5,a5,1712 # 8000b200 <_ZTV7WorkerA+0x10>
    80003b58:	00f4b023          	sd	a5,0(s1)
    threads[0] = new WorkerA();
    80003b5c:	fc943023          	sd	s1,-64(s0)
    printString("ThreadA created\n");
    80003b60:	00005517          	auipc	a0,0x5
    80003b64:	6d850513          	addi	a0,a0,1752 # 80009238 <CONSOLE_STATUS+0x228>
    80003b68:	00001097          	auipc	ra,0x1
    80003b6c:	2dc080e7          	jalr	732(ra) # 80004e44 <_Z11printStringPKc>

    threads[1] = new WorkerB();
    80003b70:	02000513          	li	a0,32
    80003b74:	fffff097          	auipc	ra,0xfffff
    80003b78:	dd8080e7          	jalr	-552(ra) # 8000294c <_Znwm>
    80003b7c:	00050493          	mv	s1,a0
    WorkerB():Thread() {}
    80003b80:	fffff097          	auipc	ra,0xfffff
    80003b84:	f50080e7          	jalr	-176(ra) # 80002ad0 <_ZN6ThreadC1Ev>
    80003b88:	00007797          	auipc	a5,0x7
    80003b8c:	6a078793          	addi	a5,a5,1696 # 8000b228 <_ZTV7WorkerB+0x10>
    80003b90:	00f4b023          	sd	a5,0(s1)
    threads[1] = new WorkerB();
    80003b94:	fc943423          	sd	s1,-56(s0)
    printString("ThreadB created\n");
    80003b98:	00005517          	auipc	a0,0x5
    80003b9c:	6b850513          	addi	a0,a0,1720 # 80009250 <CONSOLE_STATUS+0x240>
    80003ba0:	00001097          	auipc	ra,0x1
    80003ba4:	2a4080e7          	jalr	676(ra) # 80004e44 <_Z11printStringPKc>

    threads[2] = new WorkerC();
    80003ba8:	02000513          	li	a0,32
    80003bac:	fffff097          	auipc	ra,0xfffff
    80003bb0:	da0080e7          	jalr	-608(ra) # 8000294c <_Znwm>
    80003bb4:	00050493          	mv	s1,a0
    WorkerC():Thread() {}
    80003bb8:	fffff097          	auipc	ra,0xfffff
    80003bbc:	f18080e7          	jalr	-232(ra) # 80002ad0 <_ZN6ThreadC1Ev>
    80003bc0:	00007797          	auipc	a5,0x7
    80003bc4:	69078793          	addi	a5,a5,1680 # 8000b250 <_ZTV7WorkerC+0x10>
    80003bc8:	00f4b023          	sd	a5,0(s1)
    threads[2] = new WorkerC();
    80003bcc:	fc943823          	sd	s1,-48(s0)
    printString("ThreadC created\n");
    80003bd0:	00005517          	auipc	a0,0x5
    80003bd4:	69850513          	addi	a0,a0,1688 # 80009268 <CONSOLE_STATUS+0x258>
    80003bd8:	00001097          	auipc	ra,0x1
    80003bdc:	26c080e7          	jalr	620(ra) # 80004e44 <_Z11printStringPKc>

    threads[3] = new WorkerD();
    80003be0:	02000513          	li	a0,32
    80003be4:	fffff097          	auipc	ra,0xfffff
    80003be8:	d68080e7          	jalr	-664(ra) # 8000294c <_Znwm>
    80003bec:	00050493          	mv	s1,a0
    WorkerD():Thread() {}
    80003bf0:	fffff097          	auipc	ra,0xfffff
    80003bf4:	ee0080e7          	jalr	-288(ra) # 80002ad0 <_ZN6ThreadC1Ev>
    80003bf8:	00007797          	auipc	a5,0x7
    80003bfc:	68078793          	addi	a5,a5,1664 # 8000b278 <_ZTV7WorkerD+0x10>
    80003c00:	00f4b023          	sd	a5,0(s1)
    threads[3] = new WorkerD();
    80003c04:	fc943c23          	sd	s1,-40(s0)
    printString("ThreadD created\n");
    80003c08:	00005517          	auipc	a0,0x5
    80003c0c:	67850513          	addi	a0,a0,1656 # 80009280 <CONSOLE_STATUS+0x270>
    80003c10:	00001097          	auipc	ra,0x1
    80003c14:	234080e7          	jalr	564(ra) # 80004e44 <_Z11printStringPKc>

    for(int i=0; i<4; i++) {
    80003c18:	00000493          	li	s1,0
    80003c1c:	00300793          	li	a5,3
    80003c20:	0297c663          	blt	a5,s1,80003c4c <_Z20Threads_CPP_API_testv+0x12c>
        threads[i]->start();
    80003c24:	00349793          	slli	a5,s1,0x3
    80003c28:	fe040713          	addi	a4,s0,-32
    80003c2c:	00f707b3          	add	a5,a4,a5
    80003c30:	fe07b503          	ld	a0,-32(a5)
    80003c34:	fffff097          	auipc	ra,0xfffff
    80003c38:	e14080e7          	jalr	-492(ra) # 80002a48 <_ZN6Thread5startEv>
    for(int i=0; i<4; i++) {
    80003c3c:	0014849b          	addiw	s1,s1,1
    80003c40:	fddff06f          	j	80003c1c <_Z20Threads_CPP_API_testv+0xfc>
    }

    while (!(finishedA && finishedB && finishedC && finishedD)) {
        Thread::dispatch();
    80003c44:	fffff097          	auipc	ra,0xfffff
    80003c48:	e64080e7          	jalr	-412(ra) # 80002aa8 <_ZN6Thread8dispatchEv>
    while (!(finishedA && finishedB && finishedC && finishedD)) {
    80003c4c:	0008c797          	auipc	a5,0x8c
    80003c50:	cfc7c783          	lbu	a5,-772(a5) # 8008f948 <_ZL9finishedA>
    80003c54:	fe0788e3          	beqz	a5,80003c44 <_Z20Threads_CPP_API_testv+0x124>
    80003c58:	0008c797          	auipc	a5,0x8c
    80003c5c:	cf17c783          	lbu	a5,-783(a5) # 8008f949 <_ZL9finishedB>
    80003c60:	fe0782e3          	beqz	a5,80003c44 <_Z20Threads_CPP_API_testv+0x124>
    80003c64:	0008c797          	auipc	a5,0x8c
    80003c68:	ce67c783          	lbu	a5,-794(a5) # 8008f94a <_ZL9finishedC>
    80003c6c:	fc078ce3          	beqz	a5,80003c44 <_Z20Threads_CPP_API_testv+0x124>
    80003c70:	0008c797          	auipc	a5,0x8c
    80003c74:	cdb7c783          	lbu	a5,-805(a5) # 8008f94b <_ZL9finishedD>
    80003c78:	fc0786e3          	beqz	a5,80003c44 <_Z20Threads_CPP_API_testv+0x124>
    80003c7c:	fc040493          	addi	s1,s0,-64
    80003c80:	0080006f          	j	80003c88 <_Z20Threads_CPP_API_testv+0x168>
    }

    for (auto thread: threads) { delete thread; }
    80003c84:	00848493          	addi	s1,s1,8
    80003c88:	fe040793          	addi	a5,s0,-32
    80003c8c:	08f48663          	beq	s1,a5,80003d18 <_Z20Threads_CPP_API_testv+0x1f8>
    80003c90:	0004b503          	ld	a0,0(s1)
    80003c94:	fe0508e3          	beqz	a0,80003c84 <_Z20Threads_CPP_API_testv+0x164>
    80003c98:	00053783          	ld	a5,0(a0)
    80003c9c:	0087b783          	ld	a5,8(a5)
    80003ca0:	000780e7          	jalr	a5
    80003ca4:	fe1ff06f          	j	80003c84 <_Z20Threads_CPP_API_testv+0x164>
    80003ca8:	00050913          	mv	s2,a0
    threads[0] = new WorkerA();
    80003cac:	00048513          	mv	a0,s1
    80003cb0:	fffff097          	auipc	ra,0xfffff
    80003cb4:	cc4080e7          	jalr	-828(ra) # 80002974 <_ZdlPv>
    80003cb8:	00090513          	mv	a0,s2
    80003cbc:	0008d097          	auipc	ra,0x8d
    80003cc0:	d7c080e7          	jalr	-644(ra) # 80090a38 <_Unwind_Resume>
    80003cc4:	00050913          	mv	s2,a0
    threads[1] = new WorkerB();
    80003cc8:	00048513          	mv	a0,s1
    80003ccc:	fffff097          	auipc	ra,0xfffff
    80003cd0:	ca8080e7          	jalr	-856(ra) # 80002974 <_ZdlPv>
    80003cd4:	00090513          	mv	a0,s2
    80003cd8:	0008d097          	auipc	ra,0x8d
    80003cdc:	d60080e7          	jalr	-672(ra) # 80090a38 <_Unwind_Resume>
    80003ce0:	00050913          	mv	s2,a0
    threads[2] = new WorkerC();
    80003ce4:	00048513          	mv	a0,s1
    80003ce8:	fffff097          	auipc	ra,0xfffff
    80003cec:	c8c080e7          	jalr	-884(ra) # 80002974 <_ZdlPv>
    80003cf0:	00090513          	mv	a0,s2
    80003cf4:	0008d097          	auipc	ra,0x8d
    80003cf8:	d44080e7          	jalr	-700(ra) # 80090a38 <_Unwind_Resume>
    80003cfc:	00050913          	mv	s2,a0
    threads[3] = new WorkerD();
    80003d00:	00048513          	mv	a0,s1
    80003d04:	fffff097          	auipc	ra,0xfffff
    80003d08:	c70080e7          	jalr	-912(ra) # 80002974 <_ZdlPv>
    80003d0c:	00090513          	mv	a0,s2
    80003d10:	0008d097          	auipc	ra,0x8d
    80003d14:	d28080e7          	jalr	-728(ra) # 80090a38 <_Unwind_Resume>
}
    80003d18:	03813083          	ld	ra,56(sp)
    80003d1c:	03013403          	ld	s0,48(sp)
    80003d20:	02813483          	ld	s1,40(sp)
    80003d24:	02013903          	ld	s2,32(sp)
    80003d28:	04010113          	addi	sp,sp,64
    80003d2c:	00008067          	ret

0000000080003d30 <_ZN7WorkerAD1Ev>:
class WorkerA: public Thread {
    80003d30:	ff010113          	addi	sp,sp,-16
    80003d34:	00113423          	sd	ra,8(sp)
    80003d38:	00813023          	sd	s0,0(sp)
    80003d3c:	01010413          	addi	s0,sp,16
    80003d40:	00007797          	auipc	a5,0x7
    80003d44:	4c078793          	addi	a5,a5,1216 # 8000b200 <_ZTV7WorkerA+0x10>
    80003d48:	00f53023          	sd	a5,0(a0)
    80003d4c:	fffff097          	auipc	ra,0xfffff
    80003d50:	b80080e7          	jalr	-1152(ra) # 800028cc <_ZN6ThreadD1Ev>
    80003d54:	00813083          	ld	ra,8(sp)
    80003d58:	00013403          	ld	s0,0(sp)
    80003d5c:	01010113          	addi	sp,sp,16
    80003d60:	00008067          	ret

0000000080003d64 <_ZN7WorkerAD0Ev>:
    80003d64:	fe010113          	addi	sp,sp,-32
    80003d68:	00113c23          	sd	ra,24(sp)
    80003d6c:	00813823          	sd	s0,16(sp)
    80003d70:	00913423          	sd	s1,8(sp)
    80003d74:	02010413          	addi	s0,sp,32
    80003d78:	00050493          	mv	s1,a0
    80003d7c:	00007797          	auipc	a5,0x7
    80003d80:	48478793          	addi	a5,a5,1156 # 8000b200 <_ZTV7WorkerA+0x10>
    80003d84:	00f53023          	sd	a5,0(a0)
    80003d88:	fffff097          	auipc	ra,0xfffff
    80003d8c:	b44080e7          	jalr	-1212(ra) # 800028cc <_ZN6ThreadD1Ev>
    80003d90:	00048513          	mv	a0,s1
    80003d94:	fffff097          	auipc	ra,0xfffff
    80003d98:	be0080e7          	jalr	-1056(ra) # 80002974 <_ZdlPv>
    80003d9c:	01813083          	ld	ra,24(sp)
    80003da0:	01013403          	ld	s0,16(sp)
    80003da4:	00813483          	ld	s1,8(sp)
    80003da8:	02010113          	addi	sp,sp,32
    80003dac:	00008067          	ret

0000000080003db0 <_ZN7WorkerBD1Ev>:
class WorkerB: public Thread {
    80003db0:	ff010113          	addi	sp,sp,-16
    80003db4:	00113423          	sd	ra,8(sp)
    80003db8:	00813023          	sd	s0,0(sp)
    80003dbc:	01010413          	addi	s0,sp,16
    80003dc0:	00007797          	auipc	a5,0x7
    80003dc4:	46878793          	addi	a5,a5,1128 # 8000b228 <_ZTV7WorkerB+0x10>
    80003dc8:	00f53023          	sd	a5,0(a0)
    80003dcc:	fffff097          	auipc	ra,0xfffff
    80003dd0:	b00080e7          	jalr	-1280(ra) # 800028cc <_ZN6ThreadD1Ev>
    80003dd4:	00813083          	ld	ra,8(sp)
    80003dd8:	00013403          	ld	s0,0(sp)
    80003ddc:	01010113          	addi	sp,sp,16
    80003de0:	00008067          	ret

0000000080003de4 <_ZN7WorkerBD0Ev>:
    80003de4:	fe010113          	addi	sp,sp,-32
    80003de8:	00113c23          	sd	ra,24(sp)
    80003dec:	00813823          	sd	s0,16(sp)
    80003df0:	00913423          	sd	s1,8(sp)
    80003df4:	02010413          	addi	s0,sp,32
    80003df8:	00050493          	mv	s1,a0
    80003dfc:	00007797          	auipc	a5,0x7
    80003e00:	42c78793          	addi	a5,a5,1068 # 8000b228 <_ZTV7WorkerB+0x10>
    80003e04:	00f53023          	sd	a5,0(a0)
    80003e08:	fffff097          	auipc	ra,0xfffff
    80003e0c:	ac4080e7          	jalr	-1340(ra) # 800028cc <_ZN6ThreadD1Ev>
    80003e10:	00048513          	mv	a0,s1
    80003e14:	fffff097          	auipc	ra,0xfffff
    80003e18:	b60080e7          	jalr	-1184(ra) # 80002974 <_ZdlPv>
    80003e1c:	01813083          	ld	ra,24(sp)
    80003e20:	01013403          	ld	s0,16(sp)
    80003e24:	00813483          	ld	s1,8(sp)
    80003e28:	02010113          	addi	sp,sp,32
    80003e2c:	00008067          	ret

0000000080003e30 <_ZN7WorkerCD1Ev>:
class WorkerC: public Thread {
    80003e30:	ff010113          	addi	sp,sp,-16
    80003e34:	00113423          	sd	ra,8(sp)
    80003e38:	00813023          	sd	s0,0(sp)
    80003e3c:	01010413          	addi	s0,sp,16
    80003e40:	00007797          	auipc	a5,0x7
    80003e44:	41078793          	addi	a5,a5,1040 # 8000b250 <_ZTV7WorkerC+0x10>
    80003e48:	00f53023          	sd	a5,0(a0)
    80003e4c:	fffff097          	auipc	ra,0xfffff
    80003e50:	a80080e7          	jalr	-1408(ra) # 800028cc <_ZN6ThreadD1Ev>
    80003e54:	00813083          	ld	ra,8(sp)
    80003e58:	00013403          	ld	s0,0(sp)
    80003e5c:	01010113          	addi	sp,sp,16
    80003e60:	00008067          	ret

0000000080003e64 <_ZN7WorkerCD0Ev>:
    80003e64:	fe010113          	addi	sp,sp,-32
    80003e68:	00113c23          	sd	ra,24(sp)
    80003e6c:	00813823          	sd	s0,16(sp)
    80003e70:	00913423          	sd	s1,8(sp)
    80003e74:	02010413          	addi	s0,sp,32
    80003e78:	00050493          	mv	s1,a0
    80003e7c:	00007797          	auipc	a5,0x7
    80003e80:	3d478793          	addi	a5,a5,980 # 8000b250 <_ZTV7WorkerC+0x10>
    80003e84:	00f53023          	sd	a5,0(a0)
    80003e88:	fffff097          	auipc	ra,0xfffff
    80003e8c:	a44080e7          	jalr	-1468(ra) # 800028cc <_ZN6ThreadD1Ev>
    80003e90:	00048513          	mv	a0,s1
    80003e94:	fffff097          	auipc	ra,0xfffff
    80003e98:	ae0080e7          	jalr	-1312(ra) # 80002974 <_ZdlPv>
    80003e9c:	01813083          	ld	ra,24(sp)
    80003ea0:	01013403          	ld	s0,16(sp)
    80003ea4:	00813483          	ld	s1,8(sp)
    80003ea8:	02010113          	addi	sp,sp,32
    80003eac:	00008067          	ret

0000000080003eb0 <_ZN7WorkerDD1Ev>:
class WorkerD: public Thread {
    80003eb0:	ff010113          	addi	sp,sp,-16
    80003eb4:	00113423          	sd	ra,8(sp)
    80003eb8:	00813023          	sd	s0,0(sp)
    80003ebc:	01010413          	addi	s0,sp,16
    80003ec0:	00007797          	auipc	a5,0x7
    80003ec4:	3b878793          	addi	a5,a5,952 # 8000b278 <_ZTV7WorkerD+0x10>
    80003ec8:	00f53023          	sd	a5,0(a0)
    80003ecc:	fffff097          	auipc	ra,0xfffff
    80003ed0:	a00080e7          	jalr	-1536(ra) # 800028cc <_ZN6ThreadD1Ev>
    80003ed4:	00813083          	ld	ra,8(sp)
    80003ed8:	00013403          	ld	s0,0(sp)
    80003edc:	01010113          	addi	sp,sp,16
    80003ee0:	00008067          	ret

0000000080003ee4 <_ZN7WorkerDD0Ev>:
    80003ee4:	fe010113          	addi	sp,sp,-32
    80003ee8:	00113c23          	sd	ra,24(sp)
    80003eec:	00813823          	sd	s0,16(sp)
    80003ef0:	00913423          	sd	s1,8(sp)
    80003ef4:	02010413          	addi	s0,sp,32
    80003ef8:	00050493          	mv	s1,a0
    80003efc:	00007797          	auipc	a5,0x7
    80003f00:	37c78793          	addi	a5,a5,892 # 8000b278 <_ZTV7WorkerD+0x10>
    80003f04:	00f53023          	sd	a5,0(a0)
    80003f08:	fffff097          	auipc	ra,0xfffff
    80003f0c:	9c4080e7          	jalr	-1596(ra) # 800028cc <_ZN6ThreadD1Ev>
    80003f10:	00048513          	mv	a0,s1
    80003f14:	fffff097          	auipc	ra,0xfffff
    80003f18:	a60080e7          	jalr	-1440(ra) # 80002974 <_ZdlPv>
    80003f1c:	01813083          	ld	ra,24(sp)
    80003f20:	01013403          	ld	s0,16(sp)
    80003f24:	00813483          	ld	s1,8(sp)
    80003f28:	02010113          	addi	sp,sp,32
    80003f2c:	00008067          	ret

0000000080003f30 <_ZN7WorkerA3runEv>:
    void run() override {
    80003f30:	ff010113          	addi	sp,sp,-16
    80003f34:	00113423          	sd	ra,8(sp)
    80003f38:	00813023          	sd	s0,0(sp)
    80003f3c:	01010413          	addi	s0,sp,16
        workerBodyA(nullptr);
    80003f40:	00000593          	li	a1,0
    80003f44:	fffff097          	auipc	ra,0xfffff
    80003f48:	774080e7          	jalr	1908(ra) # 800036b8 <_ZN7WorkerA11workerBodyAEPv>
    }
    80003f4c:	00813083          	ld	ra,8(sp)
    80003f50:	00013403          	ld	s0,0(sp)
    80003f54:	01010113          	addi	sp,sp,16
    80003f58:	00008067          	ret

0000000080003f5c <_ZN7WorkerB3runEv>:
    void run() override {
    80003f5c:	ff010113          	addi	sp,sp,-16
    80003f60:	00113423          	sd	ra,8(sp)
    80003f64:	00813023          	sd	s0,0(sp)
    80003f68:	01010413          	addi	s0,sp,16
        workerBodyB(nullptr);
    80003f6c:	00000593          	li	a1,0
    80003f70:	00000097          	auipc	ra,0x0
    80003f74:	814080e7          	jalr	-2028(ra) # 80003784 <_ZN7WorkerB11workerBodyBEPv>
    }
    80003f78:	00813083          	ld	ra,8(sp)
    80003f7c:	00013403          	ld	s0,0(sp)
    80003f80:	01010113          	addi	sp,sp,16
    80003f84:	00008067          	ret

0000000080003f88 <_ZN7WorkerC3runEv>:
    void run() override {
    80003f88:	ff010113          	addi	sp,sp,-16
    80003f8c:	00113423          	sd	ra,8(sp)
    80003f90:	00813023          	sd	s0,0(sp)
    80003f94:	01010413          	addi	s0,sp,16
        workerBodyC(nullptr);
    80003f98:	00000593          	li	a1,0
    80003f9c:	00000097          	auipc	ra,0x0
    80003fa0:	8bc080e7          	jalr	-1860(ra) # 80003858 <_ZN7WorkerC11workerBodyCEPv>
    }
    80003fa4:	00813083          	ld	ra,8(sp)
    80003fa8:	00013403          	ld	s0,0(sp)
    80003fac:	01010113          	addi	sp,sp,16
    80003fb0:	00008067          	ret

0000000080003fb4 <_ZN7WorkerD3runEv>:
    void run() override {
    80003fb4:	ff010113          	addi	sp,sp,-16
    80003fb8:	00113423          	sd	ra,8(sp)
    80003fbc:	00813023          	sd	s0,0(sp)
    80003fc0:	01010413          	addi	s0,sp,16
        workerBodyD(nullptr);
    80003fc4:	00000593          	li	a1,0
    80003fc8:	00000097          	auipc	ra,0x0
    80003fcc:	a10080e7          	jalr	-1520(ra) # 800039d8 <_ZN7WorkerD11workerBodyDEPv>
    }
    80003fd0:	00813083          	ld	ra,8(sp)
    80003fd4:	00013403          	ld	s0,0(sp)
    80003fd8:	01010113          	addi	sp,sp,16
    80003fdc:	00008067          	ret

0000000080003fe0 <_ZL9fibonaccim>:
static volatile bool finishedA = false;
static volatile bool finishedB = false;
static volatile bool finishedC = false;
static volatile bool finishedD = false;

static uint64 fibonacci(uint64 n) {
    80003fe0:	fe010113          	addi	sp,sp,-32
    80003fe4:	00113c23          	sd	ra,24(sp)
    80003fe8:	00813823          	sd	s0,16(sp)
    80003fec:	00913423          	sd	s1,8(sp)
    80003ff0:	01213023          	sd	s2,0(sp)
    80003ff4:	02010413          	addi	s0,sp,32
    80003ff8:	00050493          	mv	s1,a0
    if (n == 0 || n == 1) { return n; }
    80003ffc:	00100793          	li	a5,1
    80004000:	02a7f863          	bgeu	a5,a0,80004030 <_ZL9fibonaccim+0x50>
    if (n % 10 == 0) { thread_dispatch(); }
    80004004:	00a00793          	li	a5,10
    80004008:	02f577b3          	remu	a5,a0,a5
    8000400c:	02078e63          	beqz	a5,80004048 <_ZL9fibonaccim+0x68>
    return fibonacci(n - 1) + fibonacci(n - 2);
    80004010:	fff48513          	addi	a0,s1,-1
    80004014:	00000097          	auipc	ra,0x0
    80004018:	fcc080e7          	jalr	-52(ra) # 80003fe0 <_ZL9fibonaccim>
    8000401c:	00050913          	mv	s2,a0
    80004020:	ffe48513          	addi	a0,s1,-2
    80004024:	00000097          	auipc	ra,0x0
    80004028:	fbc080e7          	jalr	-68(ra) # 80003fe0 <_ZL9fibonaccim>
    8000402c:	00a90533          	add	a0,s2,a0
}
    80004030:	01813083          	ld	ra,24(sp)
    80004034:	01013403          	ld	s0,16(sp)
    80004038:	00813483          	ld	s1,8(sp)
    8000403c:	00013903          	ld	s2,0(sp)
    80004040:	02010113          	addi	sp,sp,32
    80004044:	00008067          	ret
    if (n % 10 == 0) { thread_dispatch(); }
    80004048:	ffffe097          	auipc	ra,0xffffe
    8000404c:	a60080e7          	jalr	-1440(ra) # 80001aa8 <_Z15thread_dispatchv>
    80004050:	fc1ff06f          	j	80004010 <_ZL9fibonaccim+0x30>

0000000080004054 <_ZL11workerBodyDPv>:
    printString("A finished!\n");
    finishedC = true;
    thread_dispatch();
}

static void workerBodyD(void* arg) {
    80004054:	fe010113          	addi	sp,sp,-32
    80004058:	00113c23          	sd	ra,24(sp)
    8000405c:	00813823          	sd	s0,16(sp)
    80004060:	00913423          	sd	s1,8(sp)
    80004064:	01213023          	sd	s2,0(sp)
    80004068:	02010413          	addi	s0,sp,32
    uint8 i = 10;
    8000406c:	00a00493          	li	s1,10
    80004070:	0400006f          	j	800040b0 <_ZL11workerBodyDPv+0x5c>
    for (; i < 13; i++) {
        printString("D: i="); printInt(i); printString("\n");
    80004074:	00005517          	auipc	a0,0x5
    80004078:	18c50513          	addi	a0,a0,396 # 80009200 <CONSOLE_STATUS+0x1f0>
    8000407c:	00001097          	auipc	ra,0x1
    80004080:	dc8080e7          	jalr	-568(ra) # 80004e44 <_Z11printStringPKc>
    80004084:	00000613          	li	a2,0
    80004088:	00a00593          	li	a1,10
    8000408c:	00048513          	mv	a0,s1
    80004090:	00001097          	auipc	ra,0x1
    80004094:	f64080e7          	jalr	-156(ra) # 80004ff4 <_Z8printIntiii>
    80004098:	00005517          	auipc	a0,0x5
    8000409c:	38850513          	addi	a0,a0,904 # 80009420 <CONSOLE_STATUS+0x410>
    800040a0:	00001097          	auipc	ra,0x1
    800040a4:	da4080e7          	jalr	-604(ra) # 80004e44 <_Z11printStringPKc>
    for (; i < 13; i++) {
    800040a8:	0014849b          	addiw	s1,s1,1
    800040ac:	0ff4f493          	andi	s1,s1,255
    800040b0:	00c00793          	li	a5,12
    800040b4:	fc97f0e3          	bgeu	a5,s1,80004074 <_ZL11workerBodyDPv+0x20>
    }

    printString("D: dispatch\n");
    800040b8:	00005517          	auipc	a0,0x5
    800040bc:	15050513          	addi	a0,a0,336 # 80009208 <CONSOLE_STATUS+0x1f8>
    800040c0:	00001097          	auipc	ra,0x1
    800040c4:	d84080e7          	jalr	-636(ra) # 80004e44 <_Z11printStringPKc>
    __asm__ ("li t1, 5");
    800040c8:	00500313          	li	t1,5
    thread_dispatch();
    800040cc:	ffffe097          	auipc	ra,0xffffe
    800040d0:	9dc080e7          	jalr	-1572(ra) # 80001aa8 <_Z15thread_dispatchv>

    uint64 result = fibonacci(16);
    800040d4:	01000513          	li	a0,16
    800040d8:	00000097          	auipc	ra,0x0
    800040dc:	f08080e7          	jalr	-248(ra) # 80003fe0 <_ZL9fibonaccim>
    800040e0:	00050913          	mv	s2,a0
    printString("D: fibonaci="); printInt(result); printString("\n");
    800040e4:	00005517          	auipc	a0,0x5
    800040e8:	13450513          	addi	a0,a0,308 # 80009218 <CONSOLE_STATUS+0x208>
    800040ec:	00001097          	auipc	ra,0x1
    800040f0:	d58080e7          	jalr	-680(ra) # 80004e44 <_Z11printStringPKc>
    800040f4:	00000613          	li	a2,0
    800040f8:	00a00593          	li	a1,10
    800040fc:	0009051b          	sext.w	a0,s2
    80004100:	00001097          	auipc	ra,0x1
    80004104:	ef4080e7          	jalr	-268(ra) # 80004ff4 <_Z8printIntiii>
    80004108:	00005517          	auipc	a0,0x5
    8000410c:	31850513          	addi	a0,a0,792 # 80009420 <CONSOLE_STATUS+0x410>
    80004110:	00001097          	auipc	ra,0x1
    80004114:	d34080e7          	jalr	-716(ra) # 80004e44 <_Z11printStringPKc>
    80004118:	0400006f          	j	80004158 <_ZL11workerBodyDPv+0x104>

    for (; i < 16; i++) {
        printString("D: i="); printInt(i); printString("\n");
    8000411c:	00005517          	auipc	a0,0x5
    80004120:	0e450513          	addi	a0,a0,228 # 80009200 <CONSOLE_STATUS+0x1f0>
    80004124:	00001097          	auipc	ra,0x1
    80004128:	d20080e7          	jalr	-736(ra) # 80004e44 <_Z11printStringPKc>
    8000412c:	00000613          	li	a2,0
    80004130:	00a00593          	li	a1,10
    80004134:	00048513          	mv	a0,s1
    80004138:	00001097          	auipc	ra,0x1
    8000413c:	ebc080e7          	jalr	-324(ra) # 80004ff4 <_Z8printIntiii>
    80004140:	00005517          	auipc	a0,0x5
    80004144:	2e050513          	addi	a0,a0,736 # 80009420 <CONSOLE_STATUS+0x410>
    80004148:	00001097          	auipc	ra,0x1
    8000414c:	cfc080e7          	jalr	-772(ra) # 80004e44 <_Z11printStringPKc>
    for (; i < 16; i++) {
    80004150:	0014849b          	addiw	s1,s1,1
    80004154:	0ff4f493          	andi	s1,s1,255
    80004158:	00f00793          	li	a5,15
    8000415c:	fc97f0e3          	bgeu	a5,s1,8000411c <_ZL11workerBodyDPv+0xc8>
    }

    printString("D finished!\n");
    80004160:	00005517          	auipc	a0,0x5
    80004164:	0c850513          	addi	a0,a0,200 # 80009228 <CONSOLE_STATUS+0x218>
    80004168:	00001097          	auipc	ra,0x1
    8000416c:	cdc080e7          	jalr	-804(ra) # 80004e44 <_Z11printStringPKc>
    finishedD = true;
    80004170:	00100793          	li	a5,1
    80004174:	0008b717          	auipc	a4,0x8b
    80004178:	7cf70c23          	sb	a5,2008(a4) # 8008f94c <_ZL9finishedD>
    thread_dispatch();
    8000417c:	ffffe097          	auipc	ra,0xffffe
    80004180:	92c080e7          	jalr	-1748(ra) # 80001aa8 <_Z15thread_dispatchv>
}
    80004184:	01813083          	ld	ra,24(sp)
    80004188:	01013403          	ld	s0,16(sp)
    8000418c:	00813483          	ld	s1,8(sp)
    80004190:	00013903          	ld	s2,0(sp)
    80004194:	02010113          	addi	sp,sp,32
    80004198:	00008067          	ret

000000008000419c <_ZL11workerBodyCPv>:
static void workerBodyC(void* arg) {
    8000419c:	fe010113          	addi	sp,sp,-32
    800041a0:	00113c23          	sd	ra,24(sp)
    800041a4:	00813823          	sd	s0,16(sp)
    800041a8:	00913423          	sd	s1,8(sp)
    800041ac:	01213023          	sd	s2,0(sp)
    800041b0:	02010413          	addi	s0,sp,32
    uint8 i = 0;
    800041b4:	00000493          	li	s1,0
    800041b8:	0400006f          	j	800041f8 <_ZL11workerBodyCPv+0x5c>
        printString("C: i="); printInt(i); printString("\n");
    800041bc:	00005517          	auipc	a0,0x5
    800041c0:	01450513          	addi	a0,a0,20 # 800091d0 <CONSOLE_STATUS+0x1c0>
    800041c4:	00001097          	auipc	ra,0x1
    800041c8:	c80080e7          	jalr	-896(ra) # 80004e44 <_Z11printStringPKc>
    800041cc:	00000613          	li	a2,0
    800041d0:	00a00593          	li	a1,10
    800041d4:	00048513          	mv	a0,s1
    800041d8:	00001097          	auipc	ra,0x1
    800041dc:	e1c080e7          	jalr	-484(ra) # 80004ff4 <_Z8printIntiii>
    800041e0:	00005517          	auipc	a0,0x5
    800041e4:	24050513          	addi	a0,a0,576 # 80009420 <CONSOLE_STATUS+0x410>
    800041e8:	00001097          	auipc	ra,0x1
    800041ec:	c5c080e7          	jalr	-932(ra) # 80004e44 <_Z11printStringPKc>
    for (; i < 3; i++) {
    800041f0:	0014849b          	addiw	s1,s1,1
    800041f4:	0ff4f493          	andi	s1,s1,255
    800041f8:	00200793          	li	a5,2
    800041fc:	fc97f0e3          	bgeu	a5,s1,800041bc <_ZL11workerBodyCPv+0x20>
    printString("C: dispatch\n");
    80004200:	00005517          	auipc	a0,0x5
    80004204:	fd850513          	addi	a0,a0,-40 # 800091d8 <CONSOLE_STATUS+0x1c8>
    80004208:	00001097          	auipc	ra,0x1
    8000420c:	c3c080e7          	jalr	-964(ra) # 80004e44 <_Z11printStringPKc>
    __asm__ ("li t1, 7");
    80004210:	00700313          	li	t1,7
    thread_dispatch();
    80004214:	ffffe097          	auipc	ra,0xffffe
    80004218:	894080e7          	jalr	-1900(ra) # 80001aa8 <_Z15thread_dispatchv>
    __asm__ ("mv %[t1], t1" : [t1] "=r"(t1));
    8000421c:	00030913          	mv	s2,t1
    printString("C: t1="); printInt(t1); printString("\n");
    80004220:	00005517          	auipc	a0,0x5
    80004224:	fc850513          	addi	a0,a0,-56 # 800091e8 <CONSOLE_STATUS+0x1d8>
    80004228:	00001097          	auipc	ra,0x1
    8000422c:	c1c080e7          	jalr	-996(ra) # 80004e44 <_Z11printStringPKc>
    80004230:	00000613          	li	a2,0
    80004234:	00a00593          	li	a1,10
    80004238:	0009051b          	sext.w	a0,s2
    8000423c:	00001097          	auipc	ra,0x1
    80004240:	db8080e7          	jalr	-584(ra) # 80004ff4 <_Z8printIntiii>
    80004244:	00005517          	auipc	a0,0x5
    80004248:	1dc50513          	addi	a0,a0,476 # 80009420 <CONSOLE_STATUS+0x410>
    8000424c:	00001097          	auipc	ra,0x1
    80004250:	bf8080e7          	jalr	-1032(ra) # 80004e44 <_Z11printStringPKc>
    uint64 result = fibonacci(12);
    80004254:	00c00513          	li	a0,12
    80004258:	00000097          	auipc	ra,0x0
    8000425c:	d88080e7          	jalr	-632(ra) # 80003fe0 <_ZL9fibonaccim>
    80004260:	00050913          	mv	s2,a0
    printString("C: fibonaci="); printInt(result); printString("\n");
    80004264:	00005517          	auipc	a0,0x5
    80004268:	f8c50513          	addi	a0,a0,-116 # 800091f0 <CONSOLE_STATUS+0x1e0>
    8000426c:	00001097          	auipc	ra,0x1
    80004270:	bd8080e7          	jalr	-1064(ra) # 80004e44 <_Z11printStringPKc>
    80004274:	00000613          	li	a2,0
    80004278:	00a00593          	li	a1,10
    8000427c:	0009051b          	sext.w	a0,s2
    80004280:	00001097          	auipc	ra,0x1
    80004284:	d74080e7          	jalr	-652(ra) # 80004ff4 <_Z8printIntiii>
    80004288:	00005517          	auipc	a0,0x5
    8000428c:	19850513          	addi	a0,a0,408 # 80009420 <CONSOLE_STATUS+0x410>
    80004290:	00001097          	auipc	ra,0x1
    80004294:	bb4080e7          	jalr	-1100(ra) # 80004e44 <_Z11printStringPKc>
    80004298:	0400006f          	j	800042d8 <_ZL11workerBodyCPv+0x13c>
        printString("C: i="); printInt(i); printString("\n");
    8000429c:	00005517          	auipc	a0,0x5
    800042a0:	f3450513          	addi	a0,a0,-204 # 800091d0 <CONSOLE_STATUS+0x1c0>
    800042a4:	00001097          	auipc	ra,0x1
    800042a8:	ba0080e7          	jalr	-1120(ra) # 80004e44 <_Z11printStringPKc>
    800042ac:	00000613          	li	a2,0
    800042b0:	00a00593          	li	a1,10
    800042b4:	00048513          	mv	a0,s1
    800042b8:	00001097          	auipc	ra,0x1
    800042bc:	d3c080e7          	jalr	-708(ra) # 80004ff4 <_Z8printIntiii>
    800042c0:	00005517          	auipc	a0,0x5
    800042c4:	16050513          	addi	a0,a0,352 # 80009420 <CONSOLE_STATUS+0x410>
    800042c8:	00001097          	auipc	ra,0x1
    800042cc:	b7c080e7          	jalr	-1156(ra) # 80004e44 <_Z11printStringPKc>
    for (; i < 6; i++) {
    800042d0:	0014849b          	addiw	s1,s1,1
    800042d4:	0ff4f493          	andi	s1,s1,255
    800042d8:	00500793          	li	a5,5
    800042dc:	fc97f0e3          	bgeu	a5,s1,8000429c <_ZL11workerBodyCPv+0x100>
    printString("A finished!\n");
    800042e0:	00005517          	auipc	a0,0x5
    800042e4:	ec850513          	addi	a0,a0,-312 # 800091a8 <CONSOLE_STATUS+0x198>
    800042e8:	00001097          	auipc	ra,0x1
    800042ec:	b5c080e7          	jalr	-1188(ra) # 80004e44 <_Z11printStringPKc>
    finishedC = true;
    800042f0:	00100793          	li	a5,1
    800042f4:	0008b717          	auipc	a4,0x8b
    800042f8:	64f70ca3          	sb	a5,1625(a4) # 8008f94d <_ZL9finishedC>
    thread_dispatch();
    800042fc:	ffffd097          	auipc	ra,0xffffd
    80004300:	7ac080e7          	jalr	1964(ra) # 80001aa8 <_Z15thread_dispatchv>
}
    80004304:	01813083          	ld	ra,24(sp)
    80004308:	01013403          	ld	s0,16(sp)
    8000430c:	00813483          	ld	s1,8(sp)
    80004310:	00013903          	ld	s2,0(sp)
    80004314:	02010113          	addi	sp,sp,32
    80004318:	00008067          	ret

000000008000431c <_ZL11workerBodyBPv>:
static void workerBodyB(void* arg) {
    8000431c:	fe010113          	addi	sp,sp,-32
    80004320:	00113c23          	sd	ra,24(sp)
    80004324:	00813823          	sd	s0,16(sp)
    80004328:	00913423          	sd	s1,8(sp)
    8000432c:	01213023          	sd	s2,0(sp)
    80004330:	02010413          	addi	s0,sp,32
    for (uint64 i = 0; i < 16; i++) {
    80004334:	00000913          	li	s2,0
    80004338:	0380006f          	j	80004370 <_ZL11workerBodyBPv+0x54>
            thread_dispatch();
    8000433c:	ffffd097          	auipc	ra,0xffffd
    80004340:	76c080e7          	jalr	1900(ra) # 80001aa8 <_Z15thread_dispatchv>
        for (uint64 j = 0; j < 10000; j++) {
    80004344:	00148493          	addi	s1,s1,1
    80004348:	000027b7          	lui	a5,0x2
    8000434c:	70f78793          	addi	a5,a5,1807 # 270f <_entry-0x7fffd8f1>
    80004350:	0097ee63          	bltu	a5,s1,8000436c <_ZL11workerBodyBPv+0x50>
            for (uint64 k = 0; k < 30000; k++) { /* busy wait */ }
    80004354:	00000713          	li	a4,0
    80004358:	000077b7          	lui	a5,0x7
    8000435c:	52f78793          	addi	a5,a5,1327 # 752f <_entry-0x7fff8ad1>
    80004360:	fce7eee3          	bltu	a5,a4,8000433c <_ZL11workerBodyBPv+0x20>
    80004364:	00170713          	addi	a4,a4,1
    80004368:	ff1ff06f          	j	80004358 <_ZL11workerBodyBPv+0x3c>
    for (uint64 i = 0; i < 16; i++) {
    8000436c:	00190913          	addi	s2,s2,1
    80004370:	00f00793          	li	a5,15
    80004374:	0527e063          	bltu	a5,s2,800043b4 <_ZL11workerBodyBPv+0x98>
        printString("B: i="); printInt(i); printString("\n");
    80004378:	00005517          	auipc	a0,0x5
    8000437c:	e4050513          	addi	a0,a0,-448 # 800091b8 <CONSOLE_STATUS+0x1a8>
    80004380:	00001097          	auipc	ra,0x1
    80004384:	ac4080e7          	jalr	-1340(ra) # 80004e44 <_Z11printStringPKc>
    80004388:	00000613          	li	a2,0
    8000438c:	00a00593          	li	a1,10
    80004390:	0009051b          	sext.w	a0,s2
    80004394:	00001097          	auipc	ra,0x1
    80004398:	c60080e7          	jalr	-928(ra) # 80004ff4 <_Z8printIntiii>
    8000439c:	00005517          	auipc	a0,0x5
    800043a0:	08450513          	addi	a0,a0,132 # 80009420 <CONSOLE_STATUS+0x410>
    800043a4:	00001097          	auipc	ra,0x1
    800043a8:	aa0080e7          	jalr	-1376(ra) # 80004e44 <_Z11printStringPKc>
        for (uint64 j = 0; j < 10000; j++) {
    800043ac:	00000493          	li	s1,0
    800043b0:	f99ff06f          	j	80004348 <_ZL11workerBodyBPv+0x2c>
    printString("B finished!\n");
    800043b4:	00005517          	auipc	a0,0x5
    800043b8:	e0c50513          	addi	a0,a0,-500 # 800091c0 <CONSOLE_STATUS+0x1b0>
    800043bc:	00001097          	auipc	ra,0x1
    800043c0:	a88080e7          	jalr	-1400(ra) # 80004e44 <_Z11printStringPKc>
    finishedB = true;
    800043c4:	00100793          	li	a5,1
    800043c8:	0008b717          	auipc	a4,0x8b
    800043cc:	58f70323          	sb	a5,1414(a4) # 8008f94e <_ZL9finishedB>
    thread_dispatch();
    800043d0:	ffffd097          	auipc	ra,0xffffd
    800043d4:	6d8080e7          	jalr	1752(ra) # 80001aa8 <_Z15thread_dispatchv>
}
    800043d8:	01813083          	ld	ra,24(sp)
    800043dc:	01013403          	ld	s0,16(sp)
    800043e0:	00813483          	ld	s1,8(sp)
    800043e4:	00013903          	ld	s2,0(sp)
    800043e8:	02010113          	addi	sp,sp,32
    800043ec:	00008067          	ret

00000000800043f0 <_ZL11workerBodyAPv>:
static void workerBodyA(void* arg) {
    800043f0:	fe010113          	addi	sp,sp,-32
    800043f4:	00113c23          	sd	ra,24(sp)
    800043f8:	00813823          	sd	s0,16(sp)
    800043fc:	00913423          	sd	s1,8(sp)
    80004400:	01213023          	sd	s2,0(sp)
    80004404:	02010413          	addi	s0,sp,32
    for (uint64 i = 0; i < 10; i++) {
    80004408:	00000913          	li	s2,0
    8000440c:	0380006f          	j	80004444 <_ZL11workerBodyAPv+0x54>
            thread_dispatch();
    80004410:	ffffd097          	auipc	ra,0xffffd
    80004414:	698080e7          	jalr	1688(ra) # 80001aa8 <_Z15thread_dispatchv>
        for (uint64 j = 0; j < 10000; j++) {
    80004418:	00148493          	addi	s1,s1,1
    8000441c:	000027b7          	lui	a5,0x2
    80004420:	70f78793          	addi	a5,a5,1807 # 270f <_entry-0x7fffd8f1>
    80004424:	0097ee63          	bltu	a5,s1,80004440 <_ZL11workerBodyAPv+0x50>
            for (uint64 k = 0; k < 30000; k++) { /* busy wait */ }
    80004428:	00000713          	li	a4,0
    8000442c:	000077b7          	lui	a5,0x7
    80004430:	52f78793          	addi	a5,a5,1327 # 752f <_entry-0x7fff8ad1>
    80004434:	fce7eee3          	bltu	a5,a4,80004410 <_ZL11workerBodyAPv+0x20>
    80004438:	00170713          	addi	a4,a4,1
    8000443c:	ff1ff06f          	j	8000442c <_ZL11workerBodyAPv+0x3c>
    for (uint64 i = 0; i < 10; i++) {
    80004440:	00190913          	addi	s2,s2,1
    80004444:	00900793          	li	a5,9
    80004448:	0527e063          	bltu	a5,s2,80004488 <_ZL11workerBodyAPv+0x98>
        printString("A: i="); printInt(i); printString("\n");
    8000444c:	00005517          	auipc	a0,0x5
    80004450:	d5450513          	addi	a0,a0,-684 # 800091a0 <CONSOLE_STATUS+0x190>
    80004454:	00001097          	auipc	ra,0x1
    80004458:	9f0080e7          	jalr	-1552(ra) # 80004e44 <_Z11printStringPKc>
    8000445c:	00000613          	li	a2,0
    80004460:	00a00593          	li	a1,10
    80004464:	0009051b          	sext.w	a0,s2
    80004468:	00001097          	auipc	ra,0x1
    8000446c:	b8c080e7          	jalr	-1140(ra) # 80004ff4 <_Z8printIntiii>
    80004470:	00005517          	auipc	a0,0x5
    80004474:	fb050513          	addi	a0,a0,-80 # 80009420 <CONSOLE_STATUS+0x410>
    80004478:	00001097          	auipc	ra,0x1
    8000447c:	9cc080e7          	jalr	-1588(ra) # 80004e44 <_Z11printStringPKc>
        for (uint64 j = 0; j < 10000; j++) {
    80004480:	00000493          	li	s1,0
    80004484:	f99ff06f          	j	8000441c <_ZL11workerBodyAPv+0x2c>
    printString("A finished!\n");
    80004488:	00005517          	auipc	a0,0x5
    8000448c:	d2050513          	addi	a0,a0,-736 # 800091a8 <CONSOLE_STATUS+0x198>
    80004490:	00001097          	auipc	ra,0x1
    80004494:	9b4080e7          	jalr	-1612(ra) # 80004e44 <_Z11printStringPKc>
    finishedA = true;
    80004498:	00100793          	li	a5,1
    8000449c:	0008b717          	auipc	a4,0x8b
    800044a0:	4af709a3          	sb	a5,1203(a4) # 8008f94f <_ZL9finishedA>
}
    800044a4:	01813083          	ld	ra,24(sp)
    800044a8:	01013403          	ld	s0,16(sp)
    800044ac:	00813483          	ld	s1,8(sp)
    800044b0:	00013903          	ld	s2,0(sp)
    800044b4:	02010113          	addi	sp,sp,32
    800044b8:	00008067          	ret

00000000800044bc <_Z18Threads_C_API_testv>:


void Threads_C_API_test() {
    800044bc:	fd010113          	addi	sp,sp,-48
    800044c0:	02113423          	sd	ra,40(sp)
    800044c4:	02813023          	sd	s0,32(sp)
    800044c8:	03010413          	addi	s0,sp,48
    thread_t threads[4];
    thread_create(&threads[0], workerBodyA, nullptr);
    800044cc:	00000613          	li	a2,0
    800044d0:	00000597          	auipc	a1,0x0
    800044d4:	f2058593          	addi	a1,a1,-224 # 800043f0 <_ZL11workerBodyAPv>
    800044d8:	fd040513          	addi	a0,s0,-48
    800044dc:	ffffd097          	auipc	ra,0xffffd
    800044e0:	534080e7          	jalr	1332(ra) # 80001a10 <_Z13thread_createPP7_threadPFvPvES2_>
    printString("ThreadA created\n");
    800044e4:	00005517          	auipc	a0,0x5
    800044e8:	d5450513          	addi	a0,a0,-684 # 80009238 <CONSOLE_STATUS+0x228>
    800044ec:	00001097          	auipc	ra,0x1
    800044f0:	958080e7          	jalr	-1704(ra) # 80004e44 <_Z11printStringPKc>

    thread_create(&threads[1], workerBodyB, nullptr);
    800044f4:	00000613          	li	a2,0
    800044f8:	00000597          	auipc	a1,0x0
    800044fc:	e2458593          	addi	a1,a1,-476 # 8000431c <_ZL11workerBodyBPv>
    80004500:	fd840513          	addi	a0,s0,-40
    80004504:	ffffd097          	auipc	ra,0xffffd
    80004508:	50c080e7          	jalr	1292(ra) # 80001a10 <_Z13thread_createPP7_threadPFvPvES2_>
    printString("ThreadB created\n");
    8000450c:	00005517          	auipc	a0,0x5
    80004510:	d4450513          	addi	a0,a0,-700 # 80009250 <CONSOLE_STATUS+0x240>
    80004514:	00001097          	auipc	ra,0x1
    80004518:	930080e7          	jalr	-1744(ra) # 80004e44 <_Z11printStringPKc>

    thread_create(&threads[2], workerBodyC, nullptr);
    8000451c:	00000613          	li	a2,0
    80004520:	00000597          	auipc	a1,0x0
    80004524:	c7c58593          	addi	a1,a1,-900 # 8000419c <_ZL11workerBodyCPv>
    80004528:	fe040513          	addi	a0,s0,-32
    8000452c:	ffffd097          	auipc	ra,0xffffd
    80004530:	4e4080e7          	jalr	1252(ra) # 80001a10 <_Z13thread_createPP7_threadPFvPvES2_>
    printString("ThreadC created\n");
    80004534:	00005517          	auipc	a0,0x5
    80004538:	d3450513          	addi	a0,a0,-716 # 80009268 <CONSOLE_STATUS+0x258>
    8000453c:	00001097          	auipc	ra,0x1
    80004540:	908080e7          	jalr	-1784(ra) # 80004e44 <_Z11printStringPKc>

    thread_create(&threads[3], workerBodyD, nullptr);
    80004544:	00000613          	li	a2,0
    80004548:	00000597          	auipc	a1,0x0
    8000454c:	b0c58593          	addi	a1,a1,-1268 # 80004054 <_ZL11workerBodyDPv>
    80004550:	fe840513          	addi	a0,s0,-24
    80004554:	ffffd097          	auipc	ra,0xffffd
    80004558:	4bc080e7          	jalr	1212(ra) # 80001a10 <_Z13thread_createPP7_threadPFvPvES2_>
    printString("ThreadD created\n");
    8000455c:	00005517          	auipc	a0,0x5
    80004560:	d2450513          	addi	a0,a0,-732 # 80009280 <CONSOLE_STATUS+0x270>
    80004564:	00001097          	auipc	ra,0x1
    80004568:	8e0080e7          	jalr	-1824(ra) # 80004e44 <_Z11printStringPKc>
    8000456c:	00c0006f          	j	80004578 <_Z18Threads_C_API_testv+0xbc>

    while (!(finishedA && finishedB && finishedC && finishedD)) {
        thread_dispatch();
    80004570:	ffffd097          	auipc	ra,0xffffd
    80004574:	538080e7          	jalr	1336(ra) # 80001aa8 <_Z15thread_dispatchv>
    while (!(finishedA && finishedB && finishedC && finishedD)) {
    80004578:	0008b797          	auipc	a5,0x8b
    8000457c:	3d77c783          	lbu	a5,983(a5) # 8008f94f <_ZL9finishedA>
    80004580:	fe0788e3          	beqz	a5,80004570 <_Z18Threads_C_API_testv+0xb4>
    80004584:	0008b797          	auipc	a5,0x8b
    80004588:	3ca7c783          	lbu	a5,970(a5) # 8008f94e <_ZL9finishedB>
    8000458c:	fe0782e3          	beqz	a5,80004570 <_Z18Threads_C_API_testv+0xb4>
    80004590:	0008b797          	auipc	a5,0x8b
    80004594:	3bd7c783          	lbu	a5,957(a5) # 8008f94d <_ZL9finishedC>
    80004598:	fc078ce3          	beqz	a5,80004570 <_Z18Threads_C_API_testv+0xb4>
    8000459c:	0008b797          	auipc	a5,0x8b
    800045a0:	3b07c783          	lbu	a5,944(a5) # 8008f94c <_ZL9finishedD>
    800045a4:	fc0786e3          	beqz	a5,80004570 <_Z18Threads_C_API_testv+0xb4>
    }

}
    800045a8:	02813083          	ld	ra,40(sp)
    800045ac:	02013403          	ld	s0,32(sp)
    800045b0:	03010113          	addi	sp,sp,48
    800045b4:	00008067          	ret

00000000800045b8 <_ZN16ProducerKeyboard16producerKeyboardEPv>:
    void run() override {
        producerKeyboard(td);
    }
};

void ProducerKeyboard::producerKeyboard(void *arg) {
    800045b8:	fd010113          	addi	sp,sp,-48
    800045bc:	02113423          	sd	ra,40(sp)
    800045c0:	02813023          	sd	s0,32(sp)
    800045c4:	00913c23          	sd	s1,24(sp)
    800045c8:	01213823          	sd	s2,16(sp)
    800045cc:	01313423          	sd	s3,8(sp)
    800045d0:	03010413          	addi	s0,sp,48
    800045d4:	00050993          	mv	s3,a0
    800045d8:	00058493          	mv	s1,a1
    struct thread_data *data = (struct thread_data *) arg;

    int key;
    int i = 0;
    800045dc:	00000913          	li	s2,0
    800045e0:	00c0006f          	j	800045ec <_ZN16ProducerKeyboard16producerKeyboardEPv+0x34>
    while ((key = getc()) != 0x1b) {
        data->buffer->put(key);
        i++;

        if (i % (10 * data->id) == 0) {
            Thread::dispatch();
    800045e4:	ffffe097          	auipc	ra,0xffffe
    800045e8:	4c4080e7          	jalr	1220(ra) # 80002aa8 <_ZN6Thread8dispatchEv>
    while ((key = getc()) != 0x1b) {
    800045ec:	ffffd097          	auipc	ra,0xffffd
    800045f0:	5e0080e7          	jalr	1504(ra) # 80001bcc <_Z4getcv>
    800045f4:	0005059b          	sext.w	a1,a0
    800045f8:	01b00793          	li	a5,27
    800045fc:	02f58a63          	beq	a1,a5,80004630 <_ZN16ProducerKeyboard16producerKeyboardEPv+0x78>
        data->buffer->put(key);
    80004600:	0084b503          	ld	a0,8(s1)
    80004604:	00001097          	auipc	ra,0x1
    80004608:	c64080e7          	jalr	-924(ra) # 80005268 <_ZN9BufferCPP3putEi>
        i++;
    8000460c:	0019071b          	addiw	a4,s2,1
    80004610:	0007091b          	sext.w	s2,a4
        if (i % (10 * data->id) == 0) {
    80004614:	0004a683          	lw	a3,0(s1)
    80004618:	0026979b          	slliw	a5,a3,0x2
    8000461c:	00d787bb          	addw	a5,a5,a3
    80004620:	0017979b          	slliw	a5,a5,0x1
    80004624:	02f767bb          	remw	a5,a4,a5
    80004628:	fc0792e3          	bnez	a5,800045ec <_ZN16ProducerKeyboard16producerKeyboardEPv+0x34>
    8000462c:	fb9ff06f          	j	800045e4 <_ZN16ProducerKeyboard16producerKeyboardEPv+0x2c>
        }
    }

    threadEnd = 1;
    80004630:	00100793          	li	a5,1
    80004634:	0008b717          	auipc	a4,0x8b
    80004638:	30f72e23          	sw	a5,796(a4) # 8008f950 <_ZL9threadEnd>
    td->buffer->put('!');
    8000463c:	0209b783          	ld	a5,32(s3)
    80004640:	02100593          	li	a1,33
    80004644:	0087b503          	ld	a0,8(a5)
    80004648:	00001097          	auipc	ra,0x1
    8000464c:	c20080e7          	jalr	-992(ra) # 80005268 <_ZN9BufferCPP3putEi>

    data->wait->signal();
    80004650:	0104b503          	ld	a0,16(s1)
    80004654:	ffffe097          	auipc	ra,0xffffe
    80004658:	514080e7          	jalr	1300(ra) # 80002b68 <_ZN9Semaphore6signalEv>
}
    8000465c:	02813083          	ld	ra,40(sp)
    80004660:	02013403          	ld	s0,32(sp)
    80004664:	01813483          	ld	s1,24(sp)
    80004668:	01013903          	ld	s2,16(sp)
    8000466c:	00813983          	ld	s3,8(sp)
    80004670:	03010113          	addi	sp,sp,48
    80004674:	00008067          	ret

0000000080004678 <_ZN12ProducerSync8producerEPv>:
    void run() override {
        producer(td);
    }
};

void ProducerSync::producer(void *arg) {
    80004678:	fe010113          	addi	sp,sp,-32
    8000467c:	00113c23          	sd	ra,24(sp)
    80004680:	00813823          	sd	s0,16(sp)
    80004684:	00913423          	sd	s1,8(sp)
    80004688:	01213023          	sd	s2,0(sp)
    8000468c:	02010413          	addi	s0,sp,32
    80004690:	00058493          	mv	s1,a1
    struct thread_data *data = (struct thread_data *) arg;

    int i = 0;
    80004694:	00000913          	li	s2,0
    80004698:	00c0006f          	j	800046a4 <_ZN12ProducerSync8producerEPv+0x2c>
    while (!threadEnd) {
        data->buffer->put(data->id + '0');
        i++;

        if (i % (10 * data->id) == 0) {
            Thread::dispatch();
    8000469c:	ffffe097          	auipc	ra,0xffffe
    800046a0:	40c080e7          	jalr	1036(ra) # 80002aa8 <_ZN6Thread8dispatchEv>
    while (!threadEnd) {
    800046a4:	0008b797          	auipc	a5,0x8b
    800046a8:	2ac7a783          	lw	a5,684(a5) # 8008f950 <_ZL9threadEnd>
    800046ac:	02079e63          	bnez	a5,800046e8 <_ZN12ProducerSync8producerEPv+0x70>
        data->buffer->put(data->id + '0');
    800046b0:	0004a583          	lw	a1,0(s1)
    800046b4:	0305859b          	addiw	a1,a1,48
    800046b8:	0084b503          	ld	a0,8(s1)
    800046bc:	00001097          	auipc	ra,0x1
    800046c0:	bac080e7          	jalr	-1108(ra) # 80005268 <_ZN9BufferCPP3putEi>
        i++;
    800046c4:	0019071b          	addiw	a4,s2,1
    800046c8:	0007091b          	sext.w	s2,a4
        if (i % (10 * data->id) == 0) {
    800046cc:	0004a683          	lw	a3,0(s1)
    800046d0:	0026979b          	slliw	a5,a3,0x2
    800046d4:	00d787bb          	addw	a5,a5,a3
    800046d8:	0017979b          	slliw	a5,a5,0x1
    800046dc:	02f767bb          	remw	a5,a4,a5
    800046e0:	fc0792e3          	bnez	a5,800046a4 <_ZN12ProducerSync8producerEPv+0x2c>
    800046e4:	fb9ff06f          	j	8000469c <_ZN12ProducerSync8producerEPv+0x24>
        }
    }

    data->wait->signal();
    800046e8:	0104b503          	ld	a0,16(s1)
    800046ec:	ffffe097          	auipc	ra,0xffffe
    800046f0:	47c080e7          	jalr	1148(ra) # 80002b68 <_ZN9Semaphore6signalEv>
}
    800046f4:	01813083          	ld	ra,24(sp)
    800046f8:	01013403          	ld	s0,16(sp)
    800046fc:	00813483          	ld	s1,8(sp)
    80004700:	00013903          	ld	s2,0(sp)
    80004704:	02010113          	addi	sp,sp,32
    80004708:	00008067          	ret

000000008000470c <_ZN12ConsumerSync8consumerEPv>:
    void run() override {
        consumer(td);
    }
};

void ConsumerSync::consumer(void *arg) {
    8000470c:	fd010113          	addi	sp,sp,-48
    80004710:	02113423          	sd	ra,40(sp)
    80004714:	02813023          	sd	s0,32(sp)
    80004718:	00913c23          	sd	s1,24(sp)
    8000471c:	01213823          	sd	s2,16(sp)
    80004720:	01313423          	sd	s3,8(sp)
    80004724:	01413023          	sd	s4,0(sp)
    80004728:	03010413          	addi	s0,sp,48
    8000472c:	00050993          	mv	s3,a0
    80004730:	00058913          	mv	s2,a1
    struct thread_data *data = (struct thread_data *) arg;

    int i = 0;
    80004734:	00000a13          	li	s4,0
    80004738:	01c0006f          	j	80004754 <_ZN12ConsumerSync8consumerEPv+0x48>
        i++;

        putc(key);

        if (i % (5 * data->id) == 0) {
            Thread::dispatch();
    8000473c:	ffffe097          	auipc	ra,0xffffe
    80004740:	36c080e7          	jalr	876(ra) # 80002aa8 <_ZN6Thread8dispatchEv>
    80004744:	0500006f          	j	80004794 <_ZN12ConsumerSync8consumerEPv+0x88>
        }

        if (i % 80 == 0) {
            putc('\n');
    80004748:	00a00513          	li	a0,10
    8000474c:	ffffd097          	auipc	ra,0xffffd
    80004750:	4a8080e7          	jalr	1192(ra) # 80001bf4 <_Z4putcc>
    while (!threadEnd) {
    80004754:	0008b797          	auipc	a5,0x8b
    80004758:	1fc7a783          	lw	a5,508(a5) # 8008f950 <_ZL9threadEnd>
    8000475c:	06079263          	bnez	a5,800047c0 <_ZN12ConsumerSync8consumerEPv+0xb4>
        int key = data->buffer->get();
    80004760:	00893503          	ld	a0,8(s2)
    80004764:	00001097          	auipc	ra,0x1
    80004768:	b94080e7          	jalr	-1132(ra) # 800052f8 <_ZN9BufferCPP3getEv>
        i++;
    8000476c:	001a049b          	addiw	s1,s4,1
    80004770:	00048a1b          	sext.w	s4,s1
        putc(key);
    80004774:	0ff57513          	andi	a0,a0,255
    80004778:	ffffd097          	auipc	ra,0xffffd
    8000477c:	47c080e7          	jalr	1148(ra) # 80001bf4 <_Z4putcc>
        if (i % (5 * data->id) == 0) {
    80004780:	00092703          	lw	a4,0(s2)
    80004784:	0027179b          	slliw	a5,a4,0x2
    80004788:	00e787bb          	addw	a5,a5,a4
    8000478c:	02f4e7bb          	remw	a5,s1,a5
    80004790:	fa0786e3          	beqz	a5,8000473c <_ZN12ConsumerSync8consumerEPv+0x30>
        if (i % 80 == 0) {
    80004794:	05000793          	li	a5,80
    80004798:	02f4e4bb          	remw	s1,s1,a5
    8000479c:	fa049ce3          	bnez	s1,80004754 <_ZN12ConsumerSync8consumerEPv+0x48>
    800047a0:	fa9ff06f          	j	80004748 <_ZN12ConsumerSync8consumerEPv+0x3c>
        }
    }


    while (td->buffer->getCnt() > 0) {
        int key = td->buffer->get();
    800047a4:	0209b783          	ld	a5,32(s3)
    800047a8:	0087b503          	ld	a0,8(a5)
    800047ac:	00001097          	auipc	ra,0x1
    800047b0:	b4c080e7          	jalr	-1204(ra) # 800052f8 <_ZN9BufferCPP3getEv>
        Console::putc(key);
    800047b4:	0ff57513          	andi	a0,a0,255
    800047b8:	ffffe097          	auipc	ra,0xffffe
    800047bc:	408080e7          	jalr	1032(ra) # 80002bc0 <_ZN7Console4putcEc>
    while (td->buffer->getCnt() > 0) {
    800047c0:	0209b783          	ld	a5,32(s3)
    800047c4:	0087b503          	ld	a0,8(a5)
    800047c8:	00001097          	auipc	ra,0x1
    800047cc:	bbc080e7          	jalr	-1092(ra) # 80005384 <_ZN9BufferCPP6getCntEv>
    800047d0:	fca04ae3          	bgtz	a0,800047a4 <_ZN12ConsumerSync8consumerEPv+0x98>
    }

    data->wait->signal();
    800047d4:	01093503          	ld	a0,16(s2)
    800047d8:	ffffe097          	auipc	ra,0xffffe
    800047dc:	390080e7          	jalr	912(ra) # 80002b68 <_ZN9Semaphore6signalEv>
}
    800047e0:	02813083          	ld	ra,40(sp)
    800047e4:	02013403          	ld	s0,32(sp)
    800047e8:	01813483          	ld	s1,24(sp)
    800047ec:	01013903          	ld	s2,16(sp)
    800047f0:	00813983          	ld	s3,8(sp)
    800047f4:	00013a03          	ld	s4,0(sp)
    800047f8:	03010113          	addi	sp,sp,48
    800047fc:	00008067          	ret

0000000080004800 <_Z29producerConsumer_CPP_Sync_APIv>:

void producerConsumer_CPP_Sync_API() {
    80004800:	f8010113          	addi	sp,sp,-128
    80004804:	06113c23          	sd	ra,120(sp)
    80004808:	06813823          	sd	s0,112(sp)
    8000480c:	06913423          	sd	s1,104(sp)
    80004810:	07213023          	sd	s2,96(sp)
    80004814:	05313c23          	sd	s3,88(sp)
    80004818:	05413823          	sd	s4,80(sp)
    8000481c:	05513423          	sd	s5,72(sp)
    80004820:	05613023          	sd	s6,64(sp)
    80004824:	03713c23          	sd	s7,56(sp)
    80004828:	03813823          	sd	s8,48(sp)
    8000482c:	03913423          	sd	s9,40(sp)
    80004830:	08010413          	addi	s0,sp,128
    for (int i = 0; i < threadNum; i++) {
        delete threads[i];
    }
    delete consumerThread;
    delete waitForAll;
    delete buffer;
    80004834:	00010b93          	mv	s7,sp
    printString("Unesite broj proizvodjaca?\n");
    80004838:	00005517          	auipc	a0,0x5
    8000483c:	88050513          	addi	a0,a0,-1920 # 800090b8 <CONSOLE_STATUS+0xa8>
    80004840:	00000097          	auipc	ra,0x0
    80004844:	604080e7          	jalr	1540(ra) # 80004e44 <_Z11printStringPKc>
    getString(input, 30);
    80004848:	01e00593          	li	a1,30
    8000484c:	f8040493          	addi	s1,s0,-128
    80004850:	00048513          	mv	a0,s1
    80004854:	00000097          	auipc	ra,0x0
    80004858:	678080e7          	jalr	1656(ra) # 80004ecc <_Z9getStringPci>
    threadNum = stringToInt(input);
    8000485c:	00048513          	mv	a0,s1
    80004860:	00000097          	auipc	ra,0x0
    80004864:	744080e7          	jalr	1860(ra) # 80004fa4 <_Z11stringToIntPKc>
    80004868:	00050913          	mv	s2,a0
    printString("Unesite velicinu bafera?\n");
    8000486c:	00005517          	auipc	a0,0x5
    80004870:	86c50513          	addi	a0,a0,-1940 # 800090d8 <CONSOLE_STATUS+0xc8>
    80004874:	00000097          	auipc	ra,0x0
    80004878:	5d0080e7          	jalr	1488(ra) # 80004e44 <_Z11printStringPKc>
    getString(input, 30);
    8000487c:	01e00593          	li	a1,30
    80004880:	00048513          	mv	a0,s1
    80004884:	00000097          	auipc	ra,0x0
    80004888:	648080e7          	jalr	1608(ra) # 80004ecc <_Z9getStringPci>
    n = stringToInt(input);
    8000488c:	00048513          	mv	a0,s1
    80004890:	00000097          	auipc	ra,0x0
    80004894:	714080e7          	jalr	1812(ra) # 80004fa4 <_Z11stringToIntPKc>
    80004898:	00050493          	mv	s1,a0
    printString("Broj proizvodjaca "); printInt(threadNum);
    8000489c:	00005517          	auipc	a0,0x5
    800048a0:	85c50513          	addi	a0,a0,-1956 # 800090f8 <CONSOLE_STATUS+0xe8>
    800048a4:	00000097          	auipc	ra,0x0
    800048a8:	5a0080e7          	jalr	1440(ra) # 80004e44 <_Z11printStringPKc>
    800048ac:	00000613          	li	a2,0
    800048b0:	00a00593          	li	a1,10
    800048b4:	00090513          	mv	a0,s2
    800048b8:	00000097          	auipc	ra,0x0
    800048bc:	73c080e7          	jalr	1852(ra) # 80004ff4 <_Z8printIntiii>
    printString(" i velicina bafera "); printInt(n);
    800048c0:	00005517          	auipc	a0,0x5
    800048c4:	85050513          	addi	a0,a0,-1968 # 80009110 <CONSOLE_STATUS+0x100>
    800048c8:	00000097          	auipc	ra,0x0
    800048cc:	57c080e7          	jalr	1404(ra) # 80004e44 <_Z11printStringPKc>
    800048d0:	00000613          	li	a2,0
    800048d4:	00a00593          	li	a1,10
    800048d8:	00048513          	mv	a0,s1
    800048dc:	00000097          	auipc	ra,0x0
    800048e0:	718080e7          	jalr	1816(ra) # 80004ff4 <_Z8printIntiii>
    printString(".\n");
    800048e4:	00005517          	auipc	a0,0x5
    800048e8:	84450513          	addi	a0,a0,-1980 # 80009128 <CONSOLE_STATUS+0x118>
    800048ec:	00000097          	auipc	ra,0x0
    800048f0:	558080e7          	jalr	1368(ra) # 80004e44 <_Z11printStringPKc>
    if(threadNum > n) {
    800048f4:	0324c463          	blt	s1,s2,8000491c <_Z29producerConsumer_CPP_Sync_APIv+0x11c>
    } else if (threadNum < 1) {
    800048f8:	03205c63          	blez	s2,80004930 <_Z29producerConsumer_CPP_Sync_APIv+0x130>
    BufferCPP *buffer = new BufferCPP(n);
    800048fc:	03800513          	li	a0,56
    80004900:	ffffe097          	auipc	ra,0xffffe
    80004904:	04c080e7          	jalr	76(ra) # 8000294c <_Znwm>
    80004908:	00050a93          	mv	s5,a0
    8000490c:	00048593          	mv	a1,s1
    80004910:	00001097          	auipc	ra,0x1
    80004914:	804080e7          	jalr	-2044(ra) # 80005114 <_ZN9BufferCPPC1Ei>
    80004918:	0300006f          	j	80004948 <_Z29producerConsumer_CPP_Sync_APIv+0x148>
        printString("Broj proizvodjaca ne sme biti manji od velicine bafera!\n");
    8000491c:	00005517          	auipc	a0,0x5
    80004920:	81450513          	addi	a0,a0,-2028 # 80009130 <CONSOLE_STATUS+0x120>
    80004924:	00000097          	auipc	ra,0x0
    80004928:	520080e7          	jalr	1312(ra) # 80004e44 <_Z11printStringPKc>
        return;
    8000492c:	0140006f          	j	80004940 <_Z29producerConsumer_CPP_Sync_APIv+0x140>
        printString("Broj proizvodjaca mora biti veci od nula!\n");
    80004930:	00005517          	auipc	a0,0x5
    80004934:	84050513          	addi	a0,a0,-1984 # 80009170 <CONSOLE_STATUS+0x160>
    80004938:	00000097          	auipc	ra,0x0
    8000493c:	50c080e7          	jalr	1292(ra) # 80004e44 <_Z11printStringPKc>
        return;
    80004940:	000b8113          	mv	sp,s7
    80004944:	2380006f          	j	80004b7c <_Z29producerConsumer_CPP_Sync_APIv+0x37c>
    waitForAll = new Semaphore(0);
    80004948:	01000513          	li	a0,16
    8000494c:	ffffe097          	auipc	ra,0xffffe
    80004950:	000080e7          	jalr	ra # 8000294c <_Znwm>
    80004954:	00050493          	mv	s1,a0
    80004958:	00000593          	li	a1,0
    8000495c:	ffffe097          	auipc	ra,0xffffe
    80004960:	1a8080e7          	jalr	424(ra) # 80002b04 <_ZN9SemaphoreC1Ej>
    80004964:	0008b797          	auipc	a5,0x8b
    80004968:	fe97ba23          	sd	s1,-12(a5) # 8008f958 <_ZL10waitForAll>
    Thread* threads[threadNum];
    8000496c:	00391793          	slli	a5,s2,0x3
    80004970:	00f78793          	addi	a5,a5,15
    80004974:	ff07f793          	andi	a5,a5,-16
    80004978:	40f10133          	sub	sp,sp,a5
    8000497c:	00010993          	mv	s3,sp
    struct thread_data data[threadNum + 1];
    80004980:	0019071b          	addiw	a4,s2,1
    80004984:	00171793          	slli	a5,a4,0x1
    80004988:	00e787b3          	add	a5,a5,a4
    8000498c:	00379793          	slli	a5,a5,0x3
    80004990:	00f78793          	addi	a5,a5,15
    80004994:	ff07f793          	andi	a5,a5,-16
    80004998:	40f10133          	sub	sp,sp,a5
    8000499c:	00010a13          	mv	s4,sp
    data[threadNum].id = threadNum;
    800049a0:	00191c13          	slli	s8,s2,0x1
    800049a4:	012c07b3          	add	a5,s8,s2
    800049a8:	00379793          	slli	a5,a5,0x3
    800049ac:	00fa07b3          	add	a5,s4,a5
    800049b0:	0127a023          	sw	s2,0(a5)
    data[threadNum].buffer = buffer;
    800049b4:	0157b423          	sd	s5,8(a5)
    data[threadNum].wait = waitForAll;
    800049b8:	0097b823          	sd	s1,16(a5)
    consumerThread = new ConsumerSync(data+threadNum);
    800049bc:	02800513          	li	a0,40
    800049c0:	ffffe097          	auipc	ra,0xffffe
    800049c4:	f8c080e7          	jalr	-116(ra) # 8000294c <_Znwm>
    800049c8:	00050b13          	mv	s6,a0
    800049cc:	012c0c33          	add	s8,s8,s2
    800049d0:	003c1c13          	slli	s8,s8,0x3
    800049d4:	018a0c33          	add	s8,s4,s8
    ConsumerSync(thread_data* _td):Thread(), td(_td) {}
    800049d8:	ffffe097          	auipc	ra,0xffffe
    800049dc:	0f8080e7          	jalr	248(ra) # 80002ad0 <_ZN6ThreadC1Ev>
    800049e0:	00007797          	auipc	a5,0x7
    800049e4:	91078793          	addi	a5,a5,-1776 # 8000b2f0 <_ZTV12ConsumerSync+0x10>
    800049e8:	00fb3023          	sd	a5,0(s6)
    800049ec:	038b3023          	sd	s8,32(s6)
    consumerThread->start();
    800049f0:	000b0513          	mv	a0,s6
    800049f4:	ffffe097          	auipc	ra,0xffffe
    800049f8:	054080e7          	jalr	84(ra) # 80002a48 <_ZN6Thread5startEv>
    for (int i = 0; i < threadNum; i++) {
    800049fc:	00000493          	li	s1,0
    80004a00:	0380006f          	j	80004a38 <_Z29producerConsumer_CPP_Sync_APIv+0x238>
    ProducerSync(thread_data* _td):Thread(), td(_td) {}
    80004a04:	00007797          	auipc	a5,0x7
    80004a08:	8c478793          	addi	a5,a5,-1852 # 8000b2c8 <_ZTV12ProducerSync+0x10>
    80004a0c:	00fcb023          	sd	a5,0(s9)
    80004a10:	038cb023          	sd	s8,32(s9)
            threads[i] = new ProducerSync(data+i);
    80004a14:	00349793          	slli	a5,s1,0x3
    80004a18:	00f987b3          	add	a5,s3,a5
    80004a1c:	0197b023          	sd	s9,0(a5)
        threads[i]->start();
    80004a20:	00349793          	slli	a5,s1,0x3
    80004a24:	00f987b3          	add	a5,s3,a5
    80004a28:	0007b503          	ld	a0,0(a5)
    80004a2c:	ffffe097          	auipc	ra,0xffffe
    80004a30:	01c080e7          	jalr	28(ra) # 80002a48 <_ZN6Thread5startEv>
    for (int i = 0; i < threadNum; i++) {
    80004a34:	0014849b          	addiw	s1,s1,1
    80004a38:	0b24d063          	bge	s1,s2,80004ad8 <_Z29producerConsumer_CPP_Sync_APIv+0x2d8>
        data[i].id = i;
    80004a3c:	00149793          	slli	a5,s1,0x1
    80004a40:	009787b3          	add	a5,a5,s1
    80004a44:	00379793          	slli	a5,a5,0x3
    80004a48:	00fa07b3          	add	a5,s4,a5
    80004a4c:	0097a023          	sw	s1,0(a5)
        data[i].buffer = buffer;
    80004a50:	0157b423          	sd	s5,8(a5)
        data[i].wait = waitForAll;
    80004a54:	0008b717          	auipc	a4,0x8b
    80004a58:	f0473703          	ld	a4,-252(a4) # 8008f958 <_ZL10waitForAll>
    80004a5c:	00e7b823          	sd	a4,16(a5)
        if(i>0) {
    80004a60:	02905863          	blez	s1,80004a90 <_Z29producerConsumer_CPP_Sync_APIv+0x290>
            threads[i] = new ProducerSync(data+i);
    80004a64:	02800513          	li	a0,40
    80004a68:	ffffe097          	auipc	ra,0xffffe
    80004a6c:	ee4080e7          	jalr	-284(ra) # 8000294c <_Znwm>
    80004a70:	00050c93          	mv	s9,a0
    80004a74:	00149c13          	slli	s8,s1,0x1
    80004a78:	009c0c33          	add	s8,s8,s1
    80004a7c:	003c1c13          	slli	s8,s8,0x3
    80004a80:	018a0c33          	add	s8,s4,s8
    ProducerSync(thread_data* _td):Thread(), td(_td) {}
    80004a84:	ffffe097          	auipc	ra,0xffffe
    80004a88:	04c080e7          	jalr	76(ra) # 80002ad0 <_ZN6ThreadC1Ev>
    80004a8c:	f79ff06f          	j	80004a04 <_Z29producerConsumer_CPP_Sync_APIv+0x204>
            threads[i] = new ProducerKeyboard(data+i);
    80004a90:	02800513          	li	a0,40
    80004a94:	ffffe097          	auipc	ra,0xffffe
    80004a98:	eb8080e7          	jalr	-328(ra) # 8000294c <_Znwm>
    80004a9c:	00050c93          	mv	s9,a0
    80004aa0:	00149c13          	slli	s8,s1,0x1
    80004aa4:	009c0c33          	add	s8,s8,s1
    80004aa8:	003c1c13          	slli	s8,s8,0x3
    80004aac:	018a0c33          	add	s8,s4,s8
    ProducerKeyboard(thread_data* _td):Thread(), td(_td) {}
    80004ab0:	ffffe097          	auipc	ra,0xffffe
    80004ab4:	020080e7          	jalr	32(ra) # 80002ad0 <_ZN6ThreadC1Ev>
    80004ab8:	00006797          	auipc	a5,0x6
    80004abc:	7e878793          	addi	a5,a5,2024 # 8000b2a0 <_ZTV16ProducerKeyboard+0x10>
    80004ac0:	00fcb023          	sd	a5,0(s9)
    80004ac4:	038cb023          	sd	s8,32(s9)
            threads[i] = new ProducerKeyboard(data+i);
    80004ac8:	00349793          	slli	a5,s1,0x3
    80004acc:	00f987b3          	add	a5,s3,a5
    80004ad0:	0197b023          	sd	s9,0(a5)
    80004ad4:	f4dff06f          	j	80004a20 <_Z29producerConsumer_CPP_Sync_APIv+0x220>
    Thread::dispatch();
    80004ad8:	ffffe097          	auipc	ra,0xffffe
    80004adc:	fd0080e7          	jalr	-48(ra) # 80002aa8 <_ZN6Thread8dispatchEv>
    for (int i = 0; i <= threadNum; i++) {
    80004ae0:	00000493          	li	s1,0
    80004ae4:	00994e63          	blt	s2,s1,80004b00 <_Z29producerConsumer_CPP_Sync_APIv+0x300>
        waitForAll->wait();
    80004ae8:	0008b517          	auipc	a0,0x8b
    80004aec:	e7053503          	ld	a0,-400(a0) # 8008f958 <_ZL10waitForAll>
    80004af0:	ffffe097          	auipc	ra,0xffffe
    80004af4:	04c080e7          	jalr	76(ra) # 80002b3c <_ZN9Semaphore4waitEv>
    for (int i = 0; i <= threadNum; i++) {
    80004af8:	0014849b          	addiw	s1,s1,1
    80004afc:	fe9ff06f          	j	80004ae4 <_Z29producerConsumer_CPP_Sync_APIv+0x2e4>
    for (int i = 0; i < threadNum; i++) {
    80004b00:	00000493          	li	s1,0
    80004b04:	0080006f          	j	80004b0c <_Z29producerConsumer_CPP_Sync_APIv+0x30c>
    80004b08:	0014849b          	addiw	s1,s1,1
    80004b0c:	0324d263          	bge	s1,s2,80004b30 <_Z29producerConsumer_CPP_Sync_APIv+0x330>
        delete threads[i];
    80004b10:	00349793          	slli	a5,s1,0x3
    80004b14:	00f987b3          	add	a5,s3,a5
    80004b18:	0007b503          	ld	a0,0(a5)
    80004b1c:	fe0506e3          	beqz	a0,80004b08 <_Z29producerConsumer_CPP_Sync_APIv+0x308>
    80004b20:	00053783          	ld	a5,0(a0)
    80004b24:	0087b783          	ld	a5,8(a5)
    80004b28:	000780e7          	jalr	a5
    80004b2c:	fddff06f          	j	80004b08 <_Z29producerConsumer_CPP_Sync_APIv+0x308>
    delete consumerThread;
    80004b30:	000b0a63          	beqz	s6,80004b44 <_Z29producerConsumer_CPP_Sync_APIv+0x344>
    80004b34:	000b3783          	ld	a5,0(s6)
    80004b38:	0087b783          	ld	a5,8(a5)
    80004b3c:	000b0513          	mv	a0,s6
    80004b40:	000780e7          	jalr	a5
    delete waitForAll;
    80004b44:	0008b517          	auipc	a0,0x8b
    80004b48:	e1453503          	ld	a0,-492(a0) # 8008f958 <_ZL10waitForAll>
    80004b4c:	00050863          	beqz	a0,80004b5c <_Z29producerConsumer_CPP_Sync_APIv+0x35c>
    80004b50:	00053783          	ld	a5,0(a0)
    80004b54:	0087b783          	ld	a5,8(a5)
    80004b58:	000780e7          	jalr	a5
    delete buffer;
    80004b5c:	000a8e63          	beqz	s5,80004b78 <_Z29producerConsumer_CPP_Sync_APIv+0x378>
    80004b60:	000a8513          	mv	a0,s5
    80004b64:	00001097          	auipc	ra,0x1
    80004b68:	8a8080e7          	jalr	-1880(ra) # 8000540c <_ZN9BufferCPPD1Ev>
    80004b6c:	000a8513          	mv	a0,s5
    80004b70:	ffffe097          	auipc	ra,0xffffe
    80004b74:	e04080e7          	jalr	-508(ra) # 80002974 <_ZdlPv>
    80004b78:	000b8113          	mv	sp,s7

}
    80004b7c:	f8040113          	addi	sp,s0,-128
    80004b80:	07813083          	ld	ra,120(sp)
    80004b84:	07013403          	ld	s0,112(sp)
    80004b88:	06813483          	ld	s1,104(sp)
    80004b8c:	06013903          	ld	s2,96(sp)
    80004b90:	05813983          	ld	s3,88(sp)
    80004b94:	05013a03          	ld	s4,80(sp)
    80004b98:	04813a83          	ld	s5,72(sp)
    80004b9c:	04013b03          	ld	s6,64(sp)
    80004ba0:	03813b83          	ld	s7,56(sp)
    80004ba4:	03013c03          	ld	s8,48(sp)
    80004ba8:	02813c83          	ld	s9,40(sp)
    80004bac:	08010113          	addi	sp,sp,128
    80004bb0:	00008067          	ret
    80004bb4:	00050493          	mv	s1,a0
    BufferCPP *buffer = new BufferCPP(n);
    80004bb8:	000a8513          	mv	a0,s5
    80004bbc:	ffffe097          	auipc	ra,0xffffe
    80004bc0:	db8080e7          	jalr	-584(ra) # 80002974 <_ZdlPv>
    80004bc4:	00048513          	mv	a0,s1
    80004bc8:	0008c097          	auipc	ra,0x8c
    80004bcc:	e70080e7          	jalr	-400(ra) # 80090a38 <_Unwind_Resume>
    80004bd0:	00050913          	mv	s2,a0
    waitForAll = new Semaphore(0);
    80004bd4:	00048513          	mv	a0,s1
    80004bd8:	ffffe097          	auipc	ra,0xffffe
    80004bdc:	d9c080e7          	jalr	-612(ra) # 80002974 <_ZdlPv>
    80004be0:	00090513          	mv	a0,s2
    80004be4:	0008c097          	auipc	ra,0x8c
    80004be8:	e54080e7          	jalr	-428(ra) # 80090a38 <_Unwind_Resume>
    80004bec:	00050493          	mv	s1,a0
    consumerThread = new ConsumerSync(data+threadNum);
    80004bf0:	000b0513          	mv	a0,s6
    80004bf4:	ffffe097          	auipc	ra,0xffffe
    80004bf8:	d80080e7          	jalr	-640(ra) # 80002974 <_ZdlPv>
    80004bfc:	00048513          	mv	a0,s1
    80004c00:	0008c097          	auipc	ra,0x8c
    80004c04:	e38080e7          	jalr	-456(ra) # 80090a38 <_Unwind_Resume>
    80004c08:	00050493          	mv	s1,a0
            threads[i] = new ProducerSync(data+i);
    80004c0c:	000c8513          	mv	a0,s9
    80004c10:	ffffe097          	auipc	ra,0xffffe
    80004c14:	d64080e7          	jalr	-668(ra) # 80002974 <_ZdlPv>
    80004c18:	00048513          	mv	a0,s1
    80004c1c:	0008c097          	auipc	ra,0x8c
    80004c20:	e1c080e7          	jalr	-484(ra) # 80090a38 <_Unwind_Resume>
    80004c24:	00050493          	mv	s1,a0
            threads[i] = new ProducerKeyboard(data+i);
    80004c28:	000c8513          	mv	a0,s9
    80004c2c:	ffffe097          	auipc	ra,0xffffe
    80004c30:	d48080e7          	jalr	-696(ra) # 80002974 <_ZdlPv>
    80004c34:	00048513          	mv	a0,s1
    80004c38:	0008c097          	auipc	ra,0x8c
    80004c3c:	e00080e7          	jalr	-512(ra) # 80090a38 <_Unwind_Resume>

0000000080004c40 <_ZN12ConsumerSyncD1Ev>:
class ConsumerSync:public Thread {
    80004c40:	ff010113          	addi	sp,sp,-16
    80004c44:	00113423          	sd	ra,8(sp)
    80004c48:	00813023          	sd	s0,0(sp)
    80004c4c:	01010413          	addi	s0,sp,16
    80004c50:	00006797          	auipc	a5,0x6
    80004c54:	6a078793          	addi	a5,a5,1696 # 8000b2f0 <_ZTV12ConsumerSync+0x10>
    80004c58:	00f53023          	sd	a5,0(a0)
    80004c5c:	ffffe097          	auipc	ra,0xffffe
    80004c60:	c70080e7          	jalr	-912(ra) # 800028cc <_ZN6ThreadD1Ev>
    80004c64:	00813083          	ld	ra,8(sp)
    80004c68:	00013403          	ld	s0,0(sp)
    80004c6c:	01010113          	addi	sp,sp,16
    80004c70:	00008067          	ret

0000000080004c74 <_ZN12ConsumerSyncD0Ev>:
    80004c74:	fe010113          	addi	sp,sp,-32
    80004c78:	00113c23          	sd	ra,24(sp)
    80004c7c:	00813823          	sd	s0,16(sp)
    80004c80:	00913423          	sd	s1,8(sp)
    80004c84:	02010413          	addi	s0,sp,32
    80004c88:	00050493          	mv	s1,a0
    80004c8c:	00006797          	auipc	a5,0x6
    80004c90:	66478793          	addi	a5,a5,1636 # 8000b2f0 <_ZTV12ConsumerSync+0x10>
    80004c94:	00f53023          	sd	a5,0(a0)
    80004c98:	ffffe097          	auipc	ra,0xffffe
    80004c9c:	c34080e7          	jalr	-972(ra) # 800028cc <_ZN6ThreadD1Ev>
    80004ca0:	00048513          	mv	a0,s1
    80004ca4:	ffffe097          	auipc	ra,0xffffe
    80004ca8:	cd0080e7          	jalr	-816(ra) # 80002974 <_ZdlPv>
    80004cac:	01813083          	ld	ra,24(sp)
    80004cb0:	01013403          	ld	s0,16(sp)
    80004cb4:	00813483          	ld	s1,8(sp)
    80004cb8:	02010113          	addi	sp,sp,32
    80004cbc:	00008067          	ret

0000000080004cc0 <_ZN12ProducerSyncD1Ev>:
class ProducerSync:public Thread {
    80004cc0:	ff010113          	addi	sp,sp,-16
    80004cc4:	00113423          	sd	ra,8(sp)
    80004cc8:	00813023          	sd	s0,0(sp)
    80004ccc:	01010413          	addi	s0,sp,16
    80004cd0:	00006797          	auipc	a5,0x6
    80004cd4:	5f878793          	addi	a5,a5,1528 # 8000b2c8 <_ZTV12ProducerSync+0x10>
    80004cd8:	00f53023          	sd	a5,0(a0)
    80004cdc:	ffffe097          	auipc	ra,0xffffe
    80004ce0:	bf0080e7          	jalr	-1040(ra) # 800028cc <_ZN6ThreadD1Ev>
    80004ce4:	00813083          	ld	ra,8(sp)
    80004ce8:	00013403          	ld	s0,0(sp)
    80004cec:	01010113          	addi	sp,sp,16
    80004cf0:	00008067          	ret

0000000080004cf4 <_ZN12ProducerSyncD0Ev>:
    80004cf4:	fe010113          	addi	sp,sp,-32
    80004cf8:	00113c23          	sd	ra,24(sp)
    80004cfc:	00813823          	sd	s0,16(sp)
    80004d00:	00913423          	sd	s1,8(sp)
    80004d04:	02010413          	addi	s0,sp,32
    80004d08:	00050493          	mv	s1,a0
    80004d0c:	00006797          	auipc	a5,0x6
    80004d10:	5bc78793          	addi	a5,a5,1468 # 8000b2c8 <_ZTV12ProducerSync+0x10>
    80004d14:	00f53023          	sd	a5,0(a0)
    80004d18:	ffffe097          	auipc	ra,0xffffe
    80004d1c:	bb4080e7          	jalr	-1100(ra) # 800028cc <_ZN6ThreadD1Ev>
    80004d20:	00048513          	mv	a0,s1
    80004d24:	ffffe097          	auipc	ra,0xffffe
    80004d28:	c50080e7          	jalr	-944(ra) # 80002974 <_ZdlPv>
    80004d2c:	01813083          	ld	ra,24(sp)
    80004d30:	01013403          	ld	s0,16(sp)
    80004d34:	00813483          	ld	s1,8(sp)
    80004d38:	02010113          	addi	sp,sp,32
    80004d3c:	00008067          	ret

0000000080004d40 <_ZN16ProducerKeyboardD1Ev>:
class ProducerKeyboard:public Thread {
    80004d40:	ff010113          	addi	sp,sp,-16
    80004d44:	00113423          	sd	ra,8(sp)
    80004d48:	00813023          	sd	s0,0(sp)
    80004d4c:	01010413          	addi	s0,sp,16
    80004d50:	00006797          	auipc	a5,0x6
    80004d54:	55078793          	addi	a5,a5,1360 # 8000b2a0 <_ZTV16ProducerKeyboard+0x10>
    80004d58:	00f53023          	sd	a5,0(a0)
    80004d5c:	ffffe097          	auipc	ra,0xffffe
    80004d60:	b70080e7          	jalr	-1168(ra) # 800028cc <_ZN6ThreadD1Ev>
    80004d64:	00813083          	ld	ra,8(sp)
    80004d68:	00013403          	ld	s0,0(sp)
    80004d6c:	01010113          	addi	sp,sp,16
    80004d70:	00008067          	ret

0000000080004d74 <_ZN16ProducerKeyboardD0Ev>:
    80004d74:	fe010113          	addi	sp,sp,-32
    80004d78:	00113c23          	sd	ra,24(sp)
    80004d7c:	00813823          	sd	s0,16(sp)
    80004d80:	00913423          	sd	s1,8(sp)
    80004d84:	02010413          	addi	s0,sp,32
    80004d88:	00050493          	mv	s1,a0
    80004d8c:	00006797          	auipc	a5,0x6
    80004d90:	51478793          	addi	a5,a5,1300 # 8000b2a0 <_ZTV16ProducerKeyboard+0x10>
    80004d94:	00f53023          	sd	a5,0(a0)
    80004d98:	ffffe097          	auipc	ra,0xffffe
    80004d9c:	b34080e7          	jalr	-1228(ra) # 800028cc <_ZN6ThreadD1Ev>
    80004da0:	00048513          	mv	a0,s1
    80004da4:	ffffe097          	auipc	ra,0xffffe
    80004da8:	bd0080e7          	jalr	-1072(ra) # 80002974 <_ZdlPv>
    80004dac:	01813083          	ld	ra,24(sp)
    80004db0:	01013403          	ld	s0,16(sp)
    80004db4:	00813483          	ld	s1,8(sp)
    80004db8:	02010113          	addi	sp,sp,32
    80004dbc:	00008067          	ret

0000000080004dc0 <_ZN16ProducerKeyboard3runEv>:
    void run() override {
    80004dc0:	ff010113          	addi	sp,sp,-16
    80004dc4:	00113423          	sd	ra,8(sp)
    80004dc8:	00813023          	sd	s0,0(sp)
    80004dcc:	01010413          	addi	s0,sp,16
        producerKeyboard(td);
    80004dd0:	02053583          	ld	a1,32(a0)
    80004dd4:	fffff097          	auipc	ra,0xfffff
    80004dd8:	7e4080e7          	jalr	2020(ra) # 800045b8 <_ZN16ProducerKeyboard16producerKeyboardEPv>
    }
    80004ddc:	00813083          	ld	ra,8(sp)
    80004de0:	00013403          	ld	s0,0(sp)
    80004de4:	01010113          	addi	sp,sp,16
    80004de8:	00008067          	ret

0000000080004dec <_ZN12ProducerSync3runEv>:
    void run() override {
    80004dec:	ff010113          	addi	sp,sp,-16
    80004df0:	00113423          	sd	ra,8(sp)
    80004df4:	00813023          	sd	s0,0(sp)
    80004df8:	01010413          	addi	s0,sp,16
        producer(td);
    80004dfc:	02053583          	ld	a1,32(a0)
    80004e00:	00000097          	auipc	ra,0x0
    80004e04:	878080e7          	jalr	-1928(ra) # 80004678 <_ZN12ProducerSync8producerEPv>
    }
    80004e08:	00813083          	ld	ra,8(sp)
    80004e0c:	00013403          	ld	s0,0(sp)
    80004e10:	01010113          	addi	sp,sp,16
    80004e14:	00008067          	ret

0000000080004e18 <_ZN12ConsumerSync3runEv>:
    void run() override {
    80004e18:	ff010113          	addi	sp,sp,-16
    80004e1c:	00113423          	sd	ra,8(sp)
    80004e20:	00813023          	sd	s0,0(sp)
    80004e24:	01010413          	addi	s0,sp,16
        consumer(td);
    80004e28:	02053583          	ld	a1,32(a0)
    80004e2c:	00000097          	auipc	ra,0x0
    80004e30:	8e0080e7          	jalr	-1824(ra) # 8000470c <_ZN12ConsumerSync8consumerEPv>
    }
    80004e34:	00813083          	ld	ra,8(sp)
    80004e38:	00013403          	ld	s0,0(sp)
    80004e3c:	01010113          	addi	sp,sp,16
    80004e40:	00008067          	ret

0000000080004e44 <_Z11printStringPKc>:

#define LOCK() while(copy_and_swap(lockPrint, 0, 1)) thread_dispatch()
#define UNLOCK() while(copy_and_swap(lockPrint, 1, 0))

void printString(char const *string)
{
    80004e44:	fe010113          	addi	sp,sp,-32
    80004e48:	00113c23          	sd	ra,24(sp)
    80004e4c:	00813823          	sd	s0,16(sp)
    80004e50:	00913423          	sd	s1,8(sp)
    80004e54:	02010413          	addi	s0,sp,32
    80004e58:	00050493          	mv	s1,a0
    LOCK();
    80004e5c:	00100613          	li	a2,1
    80004e60:	00000593          	li	a1,0
    80004e64:	0008b517          	auipc	a0,0x8b
    80004e68:	afc50513          	addi	a0,a0,-1284 # 8008f960 <lockPrint>
    80004e6c:	ffffc097          	auipc	ra,0xffffc
    80004e70:	778080e7          	jalr	1912(ra) # 800015e4 <copy_and_swap>
    80004e74:	00050863          	beqz	a0,80004e84 <_Z11printStringPKc+0x40>
    80004e78:	ffffd097          	auipc	ra,0xffffd
    80004e7c:	c30080e7          	jalr	-976(ra) # 80001aa8 <_Z15thread_dispatchv>
    80004e80:	fddff06f          	j	80004e5c <_Z11printStringPKc+0x18>
    while (*string != '\0')
    80004e84:	0004c503          	lbu	a0,0(s1)
    80004e88:	00050a63          	beqz	a0,80004e9c <_Z11printStringPKc+0x58>
    {
        putc(*string);
    80004e8c:	ffffd097          	auipc	ra,0xffffd
    80004e90:	d68080e7          	jalr	-664(ra) # 80001bf4 <_Z4putcc>
        string++;
    80004e94:	00148493          	addi	s1,s1,1
    while (*string != '\0')
    80004e98:	fedff06f          	j	80004e84 <_Z11printStringPKc+0x40>
    }
    UNLOCK();
    80004e9c:	00000613          	li	a2,0
    80004ea0:	00100593          	li	a1,1
    80004ea4:	0008b517          	auipc	a0,0x8b
    80004ea8:	abc50513          	addi	a0,a0,-1348 # 8008f960 <lockPrint>
    80004eac:	ffffc097          	auipc	ra,0xffffc
    80004eb0:	738080e7          	jalr	1848(ra) # 800015e4 <copy_and_swap>
    80004eb4:	fe0514e3          	bnez	a0,80004e9c <_Z11printStringPKc+0x58>
}
    80004eb8:	01813083          	ld	ra,24(sp)
    80004ebc:	01013403          	ld	s0,16(sp)
    80004ec0:	00813483          	ld	s1,8(sp)
    80004ec4:	02010113          	addi	sp,sp,32
    80004ec8:	00008067          	ret

0000000080004ecc <_Z9getStringPci>:

char* getString(char *buf, int max) {
    80004ecc:	fd010113          	addi	sp,sp,-48
    80004ed0:	02113423          	sd	ra,40(sp)
    80004ed4:	02813023          	sd	s0,32(sp)
    80004ed8:	00913c23          	sd	s1,24(sp)
    80004edc:	01213823          	sd	s2,16(sp)
    80004ee0:	01313423          	sd	s3,8(sp)
    80004ee4:	01413023          	sd	s4,0(sp)
    80004ee8:	03010413          	addi	s0,sp,48
    80004eec:	00050993          	mv	s3,a0
    80004ef0:	00058a13          	mv	s4,a1
    LOCK();
    80004ef4:	00100613          	li	a2,1
    80004ef8:	00000593          	li	a1,0
    80004efc:	0008b517          	auipc	a0,0x8b
    80004f00:	a6450513          	addi	a0,a0,-1436 # 8008f960 <lockPrint>
    80004f04:	ffffc097          	auipc	ra,0xffffc
    80004f08:	6e0080e7          	jalr	1760(ra) # 800015e4 <copy_and_swap>
    80004f0c:	00050863          	beqz	a0,80004f1c <_Z9getStringPci+0x50>
    80004f10:	ffffd097          	auipc	ra,0xffffd
    80004f14:	b98080e7          	jalr	-1128(ra) # 80001aa8 <_Z15thread_dispatchv>
    80004f18:	fddff06f          	j	80004ef4 <_Z9getStringPci+0x28>
    int i, cc;
    char c;

    for(i=0; i+1 < max; ){
    80004f1c:	00000913          	li	s2,0
    80004f20:	00090493          	mv	s1,s2
    80004f24:	0019091b          	addiw	s2,s2,1
    80004f28:	03495a63          	bge	s2,s4,80004f5c <_Z9getStringPci+0x90>
        cc = getc();
    80004f2c:	ffffd097          	auipc	ra,0xffffd
    80004f30:	ca0080e7          	jalr	-864(ra) # 80001bcc <_Z4getcv>
        if(cc < 1)
    80004f34:	02050463          	beqz	a0,80004f5c <_Z9getStringPci+0x90>
            break;
        c = cc;
        buf[i++] = c;
    80004f38:	009984b3          	add	s1,s3,s1
    80004f3c:	00a48023          	sb	a0,0(s1)
        if(c == '\n' || c == '\r')
    80004f40:	00a00793          	li	a5,10
    80004f44:	00f50a63          	beq	a0,a5,80004f58 <_Z9getStringPci+0x8c>
    80004f48:	00d00793          	li	a5,13
    80004f4c:	fcf51ae3          	bne	a0,a5,80004f20 <_Z9getStringPci+0x54>
        buf[i++] = c;
    80004f50:	00090493          	mv	s1,s2
    80004f54:	0080006f          	j	80004f5c <_Z9getStringPci+0x90>
    80004f58:	00090493          	mv	s1,s2
            break;
    }
    buf[i] = '\0';
    80004f5c:	009984b3          	add	s1,s3,s1
    80004f60:	00048023          	sb	zero,0(s1)

    UNLOCK();
    80004f64:	00000613          	li	a2,0
    80004f68:	00100593          	li	a1,1
    80004f6c:	0008b517          	auipc	a0,0x8b
    80004f70:	9f450513          	addi	a0,a0,-1548 # 8008f960 <lockPrint>
    80004f74:	ffffc097          	auipc	ra,0xffffc
    80004f78:	670080e7          	jalr	1648(ra) # 800015e4 <copy_and_swap>
    80004f7c:	fe0514e3          	bnez	a0,80004f64 <_Z9getStringPci+0x98>
    return buf;
}
    80004f80:	00098513          	mv	a0,s3
    80004f84:	02813083          	ld	ra,40(sp)
    80004f88:	02013403          	ld	s0,32(sp)
    80004f8c:	01813483          	ld	s1,24(sp)
    80004f90:	01013903          	ld	s2,16(sp)
    80004f94:	00813983          	ld	s3,8(sp)
    80004f98:	00013a03          	ld	s4,0(sp)
    80004f9c:	03010113          	addi	sp,sp,48
    80004fa0:	00008067          	ret

0000000080004fa4 <_Z11stringToIntPKc>:

int stringToInt(const char *s) {
    80004fa4:	ff010113          	addi	sp,sp,-16
    80004fa8:	00813423          	sd	s0,8(sp)
    80004fac:	01010413          	addi	s0,sp,16
    80004fb0:	00050693          	mv	a3,a0
    int n;

    n = 0;
    80004fb4:	00000513          	li	a0,0
    while ('0' <= *s && *s <= '9')
    80004fb8:	0006c603          	lbu	a2,0(a3)
    80004fbc:	fd06071b          	addiw	a4,a2,-48
    80004fc0:	0ff77713          	andi	a4,a4,255
    80004fc4:	00900793          	li	a5,9
    80004fc8:	02e7e063          	bltu	a5,a4,80004fe8 <_Z11stringToIntPKc+0x44>
        n = n * 10 + *s++ - '0';
    80004fcc:	0025179b          	slliw	a5,a0,0x2
    80004fd0:	00a787bb          	addw	a5,a5,a0
    80004fd4:	0017979b          	slliw	a5,a5,0x1
    80004fd8:	00168693          	addi	a3,a3,1
    80004fdc:	00c787bb          	addw	a5,a5,a2
    80004fe0:	fd07851b          	addiw	a0,a5,-48
    while ('0' <= *s && *s <= '9')
    80004fe4:	fd5ff06f          	j	80004fb8 <_Z11stringToIntPKc+0x14>
    return n;
}
    80004fe8:	00813403          	ld	s0,8(sp)
    80004fec:	01010113          	addi	sp,sp,16
    80004ff0:	00008067          	ret

0000000080004ff4 <_Z8printIntiii>:

char digits[] = "0123456789ABCDEF";

void printInt(int xx, int base, int sgn)
{
    80004ff4:	fc010113          	addi	sp,sp,-64
    80004ff8:	02113c23          	sd	ra,56(sp)
    80004ffc:	02813823          	sd	s0,48(sp)
    80005000:	02913423          	sd	s1,40(sp)
    80005004:	03213023          	sd	s2,32(sp)
    80005008:	01313c23          	sd	s3,24(sp)
    8000500c:	04010413          	addi	s0,sp,64
    80005010:	00050493          	mv	s1,a0
    80005014:	00058913          	mv	s2,a1
    80005018:	00060993          	mv	s3,a2
    LOCK();
    8000501c:	00100613          	li	a2,1
    80005020:	00000593          	li	a1,0
    80005024:	0008b517          	auipc	a0,0x8b
    80005028:	93c50513          	addi	a0,a0,-1732 # 8008f960 <lockPrint>
    8000502c:	ffffc097          	auipc	ra,0xffffc
    80005030:	5b8080e7          	jalr	1464(ra) # 800015e4 <copy_and_swap>
    80005034:	00050863          	beqz	a0,80005044 <_Z8printIntiii+0x50>
    80005038:	ffffd097          	auipc	ra,0xffffd
    8000503c:	a70080e7          	jalr	-1424(ra) # 80001aa8 <_Z15thread_dispatchv>
    80005040:	fddff06f          	j	8000501c <_Z8printIntiii+0x28>
    char buf[16];
    int i, neg;
    uint x;

    neg = 0;
    if(sgn && xx < 0){
    80005044:	00098463          	beqz	s3,8000504c <_Z8printIntiii+0x58>
    80005048:	0804c463          	bltz	s1,800050d0 <_Z8printIntiii+0xdc>
        neg = 1;
        x = -xx;
    } else {
        x = xx;
    8000504c:	0004851b          	sext.w	a0,s1
    neg = 0;
    80005050:	00000593          	li	a1,0
    }

    i = 0;
    80005054:	00000493          	li	s1,0
    do{
        buf[i++] = digits[x % base];
    80005058:	0009079b          	sext.w	a5,s2
    8000505c:	0325773b          	remuw	a4,a0,s2
    80005060:	00048613          	mv	a2,s1
    80005064:	0014849b          	addiw	s1,s1,1
    80005068:	02071693          	slli	a3,a4,0x20
    8000506c:	0206d693          	srli	a3,a3,0x20
    80005070:	00006717          	auipc	a4,0x6
    80005074:	29870713          	addi	a4,a4,664 # 8000b308 <digits>
    80005078:	00d70733          	add	a4,a4,a3
    8000507c:	00074683          	lbu	a3,0(a4)
    80005080:	fd040713          	addi	a4,s0,-48
    80005084:	00c70733          	add	a4,a4,a2
    80005088:	fed70823          	sb	a3,-16(a4)
    }while((x /= base) != 0);
    8000508c:	0005071b          	sext.w	a4,a0
    80005090:	0325553b          	divuw	a0,a0,s2
    80005094:	fcf772e3          	bgeu	a4,a5,80005058 <_Z8printIntiii+0x64>
    if(neg)
    80005098:	00058c63          	beqz	a1,800050b0 <_Z8printIntiii+0xbc>
        buf[i++] = '-';
    8000509c:	fd040793          	addi	a5,s0,-48
    800050a0:	009784b3          	add	s1,a5,s1
    800050a4:	02d00793          	li	a5,45
    800050a8:	fef48823          	sb	a5,-16(s1)
    800050ac:	0026049b          	addiw	s1,a2,2

    while(--i >= 0)
    800050b0:	fff4849b          	addiw	s1,s1,-1
    800050b4:	0204c463          	bltz	s1,800050dc <_Z8printIntiii+0xe8>
        putc(buf[i]);
    800050b8:	fd040793          	addi	a5,s0,-48
    800050bc:	009787b3          	add	a5,a5,s1
    800050c0:	ff07c503          	lbu	a0,-16(a5)
    800050c4:	ffffd097          	auipc	ra,0xffffd
    800050c8:	b30080e7          	jalr	-1232(ra) # 80001bf4 <_Z4putcc>
    800050cc:	fe5ff06f          	j	800050b0 <_Z8printIntiii+0xbc>
        x = -xx;
    800050d0:	4090053b          	negw	a0,s1
        neg = 1;
    800050d4:	00100593          	li	a1,1
        x = -xx;
    800050d8:	f7dff06f          	j	80005054 <_Z8printIntiii+0x60>

    UNLOCK();
    800050dc:	00000613          	li	a2,0
    800050e0:	00100593          	li	a1,1
    800050e4:	0008b517          	auipc	a0,0x8b
    800050e8:	87c50513          	addi	a0,a0,-1924 # 8008f960 <lockPrint>
    800050ec:	ffffc097          	auipc	ra,0xffffc
    800050f0:	4f8080e7          	jalr	1272(ra) # 800015e4 <copy_and_swap>
    800050f4:	fe0514e3          	bnez	a0,800050dc <_Z8printIntiii+0xe8>
    800050f8:	03813083          	ld	ra,56(sp)
    800050fc:	03013403          	ld	s0,48(sp)
    80005100:	02813483          	ld	s1,40(sp)
    80005104:	02013903          	ld	s2,32(sp)
    80005108:	01813983          	ld	s3,24(sp)
    8000510c:	04010113          	addi	sp,sp,64
    80005110:	00008067          	ret

0000000080005114 <_ZN9BufferCPPC1Ei>:
#include "buffer_CPP_API.hpp"

BufferCPP::BufferCPP(int _cap) : cap(_cap + 1), head(0), tail(0) {
    80005114:	fd010113          	addi	sp,sp,-48
    80005118:	02113423          	sd	ra,40(sp)
    8000511c:	02813023          	sd	s0,32(sp)
    80005120:	00913c23          	sd	s1,24(sp)
    80005124:	01213823          	sd	s2,16(sp)
    80005128:	01313423          	sd	s3,8(sp)
    8000512c:	03010413          	addi	s0,sp,48
    80005130:	00050493          	mv	s1,a0
    80005134:	00058913          	mv	s2,a1
    80005138:	0015879b          	addiw	a5,a1,1
    8000513c:	0007851b          	sext.w	a0,a5
    80005140:	00f4a023          	sw	a5,0(s1)
    80005144:	0004a823          	sw	zero,16(s1)
    80005148:	0004aa23          	sw	zero,20(s1)
    buffer = (int *)mem_alloc(sizeof(int) * cap);
    8000514c:	00251513          	slli	a0,a0,0x2
    80005150:	ffffd097          	auipc	ra,0xffffd
    80005154:	854080e7          	jalr	-1964(ra) # 800019a4 <_Z9mem_allocm>
    80005158:	00a4b423          	sd	a0,8(s1)
    itemAvailable = new Semaphore(0);
    8000515c:	01000513          	li	a0,16
    80005160:	ffffd097          	auipc	ra,0xffffd
    80005164:	7ec080e7          	jalr	2028(ra) # 8000294c <_Znwm>
    80005168:	00050993          	mv	s3,a0
    8000516c:	00000593          	li	a1,0
    80005170:	ffffe097          	auipc	ra,0xffffe
    80005174:	994080e7          	jalr	-1644(ra) # 80002b04 <_ZN9SemaphoreC1Ej>
    80005178:	0334b023          	sd	s3,32(s1)
    spaceAvailable = new Semaphore(_cap);
    8000517c:	01000513          	li	a0,16
    80005180:	ffffd097          	auipc	ra,0xffffd
    80005184:	7cc080e7          	jalr	1996(ra) # 8000294c <_Znwm>
    80005188:	00050993          	mv	s3,a0
    8000518c:	00090593          	mv	a1,s2
    80005190:	ffffe097          	auipc	ra,0xffffe
    80005194:	974080e7          	jalr	-1676(ra) # 80002b04 <_ZN9SemaphoreC1Ej>
    80005198:	0134bc23          	sd	s3,24(s1)
    mutexHead = new Semaphore(1);
    8000519c:	01000513          	li	a0,16
    800051a0:	ffffd097          	auipc	ra,0xffffd
    800051a4:	7ac080e7          	jalr	1964(ra) # 8000294c <_Znwm>
    800051a8:	00050913          	mv	s2,a0
    800051ac:	00100593          	li	a1,1
    800051b0:	ffffe097          	auipc	ra,0xffffe
    800051b4:	954080e7          	jalr	-1708(ra) # 80002b04 <_ZN9SemaphoreC1Ej>
    800051b8:	0324b423          	sd	s2,40(s1)
    mutexTail = new Semaphore(1);
    800051bc:	01000513          	li	a0,16
    800051c0:	ffffd097          	auipc	ra,0xffffd
    800051c4:	78c080e7          	jalr	1932(ra) # 8000294c <_Znwm>
    800051c8:	00050913          	mv	s2,a0
    800051cc:	00100593          	li	a1,1
    800051d0:	ffffe097          	auipc	ra,0xffffe
    800051d4:	934080e7          	jalr	-1740(ra) # 80002b04 <_ZN9SemaphoreC1Ej>
    800051d8:	0324b823          	sd	s2,48(s1)
}
    800051dc:	02813083          	ld	ra,40(sp)
    800051e0:	02013403          	ld	s0,32(sp)
    800051e4:	01813483          	ld	s1,24(sp)
    800051e8:	01013903          	ld	s2,16(sp)
    800051ec:	00813983          	ld	s3,8(sp)
    800051f0:	03010113          	addi	sp,sp,48
    800051f4:	00008067          	ret
    800051f8:	00050493          	mv	s1,a0
    itemAvailable = new Semaphore(0);
    800051fc:	00098513          	mv	a0,s3
    80005200:	ffffd097          	auipc	ra,0xffffd
    80005204:	774080e7          	jalr	1908(ra) # 80002974 <_ZdlPv>
    80005208:	00048513          	mv	a0,s1
    8000520c:	0008c097          	auipc	ra,0x8c
    80005210:	82c080e7          	jalr	-2004(ra) # 80090a38 <_Unwind_Resume>
    80005214:	00050493          	mv	s1,a0
    spaceAvailable = new Semaphore(_cap);
    80005218:	00098513          	mv	a0,s3
    8000521c:	ffffd097          	auipc	ra,0xffffd
    80005220:	758080e7          	jalr	1880(ra) # 80002974 <_ZdlPv>
    80005224:	00048513          	mv	a0,s1
    80005228:	0008c097          	auipc	ra,0x8c
    8000522c:	810080e7          	jalr	-2032(ra) # 80090a38 <_Unwind_Resume>
    80005230:	00050493          	mv	s1,a0
    mutexHead = new Semaphore(1);
    80005234:	00090513          	mv	a0,s2
    80005238:	ffffd097          	auipc	ra,0xffffd
    8000523c:	73c080e7          	jalr	1852(ra) # 80002974 <_ZdlPv>
    80005240:	00048513          	mv	a0,s1
    80005244:	0008b097          	auipc	ra,0x8b
    80005248:	7f4080e7          	jalr	2036(ra) # 80090a38 <_Unwind_Resume>
    8000524c:	00050493          	mv	s1,a0
    mutexTail = new Semaphore(1);
    80005250:	00090513          	mv	a0,s2
    80005254:	ffffd097          	auipc	ra,0xffffd
    80005258:	720080e7          	jalr	1824(ra) # 80002974 <_ZdlPv>
    8000525c:	00048513          	mv	a0,s1
    80005260:	0008b097          	auipc	ra,0x8b
    80005264:	7d8080e7          	jalr	2008(ra) # 80090a38 <_Unwind_Resume>

0000000080005268 <_ZN9BufferCPP3putEi>:
    delete mutexTail;
    delete mutexHead;

}

void BufferCPP::put(int val) {
    80005268:	fe010113          	addi	sp,sp,-32
    8000526c:	00113c23          	sd	ra,24(sp)
    80005270:	00813823          	sd	s0,16(sp)
    80005274:	00913423          	sd	s1,8(sp)
    80005278:	01213023          	sd	s2,0(sp)
    8000527c:	02010413          	addi	s0,sp,32
    80005280:	00050493          	mv	s1,a0
    80005284:	00058913          	mv	s2,a1
    spaceAvailable->wait();
    80005288:	01853503          	ld	a0,24(a0)
    8000528c:	ffffe097          	auipc	ra,0xffffe
    80005290:	8b0080e7          	jalr	-1872(ra) # 80002b3c <_ZN9Semaphore4waitEv>

    mutexTail->wait();
    80005294:	0304b503          	ld	a0,48(s1)
    80005298:	ffffe097          	auipc	ra,0xffffe
    8000529c:	8a4080e7          	jalr	-1884(ra) # 80002b3c <_ZN9Semaphore4waitEv>
    buffer[tail] = val;
    800052a0:	0084b783          	ld	a5,8(s1)
    800052a4:	0144a703          	lw	a4,20(s1)
    800052a8:	00271713          	slli	a4,a4,0x2
    800052ac:	00e787b3          	add	a5,a5,a4
    800052b0:	0127a023          	sw	s2,0(a5)
    tail = (tail + 1) % cap;
    800052b4:	0144a783          	lw	a5,20(s1)
    800052b8:	0017879b          	addiw	a5,a5,1
    800052bc:	0004a703          	lw	a4,0(s1)
    800052c0:	02e7e7bb          	remw	a5,a5,a4
    800052c4:	00f4aa23          	sw	a5,20(s1)
    mutexTail->signal();
    800052c8:	0304b503          	ld	a0,48(s1)
    800052cc:	ffffe097          	auipc	ra,0xffffe
    800052d0:	89c080e7          	jalr	-1892(ra) # 80002b68 <_ZN9Semaphore6signalEv>

    itemAvailable->signal();
    800052d4:	0204b503          	ld	a0,32(s1)
    800052d8:	ffffe097          	auipc	ra,0xffffe
    800052dc:	890080e7          	jalr	-1904(ra) # 80002b68 <_ZN9Semaphore6signalEv>

}
    800052e0:	01813083          	ld	ra,24(sp)
    800052e4:	01013403          	ld	s0,16(sp)
    800052e8:	00813483          	ld	s1,8(sp)
    800052ec:	00013903          	ld	s2,0(sp)
    800052f0:	02010113          	addi	sp,sp,32
    800052f4:	00008067          	ret

00000000800052f8 <_ZN9BufferCPP3getEv>:

int BufferCPP::get() {
    800052f8:	fe010113          	addi	sp,sp,-32
    800052fc:	00113c23          	sd	ra,24(sp)
    80005300:	00813823          	sd	s0,16(sp)
    80005304:	00913423          	sd	s1,8(sp)
    80005308:	01213023          	sd	s2,0(sp)
    8000530c:	02010413          	addi	s0,sp,32
    80005310:	00050493          	mv	s1,a0
    itemAvailable->wait();
    80005314:	02053503          	ld	a0,32(a0)
    80005318:	ffffe097          	auipc	ra,0xffffe
    8000531c:	824080e7          	jalr	-2012(ra) # 80002b3c <_ZN9Semaphore4waitEv>

    mutexHead->wait();
    80005320:	0284b503          	ld	a0,40(s1)
    80005324:	ffffe097          	auipc	ra,0xffffe
    80005328:	818080e7          	jalr	-2024(ra) # 80002b3c <_ZN9Semaphore4waitEv>

    int ret = buffer[head];
    8000532c:	0084b703          	ld	a4,8(s1)
    80005330:	0104a783          	lw	a5,16(s1)
    80005334:	00279693          	slli	a3,a5,0x2
    80005338:	00d70733          	add	a4,a4,a3
    8000533c:	00072903          	lw	s2,0(a4)
    head = (head + 1) % cap;
    80005340:	0017879b          	addiw	a5,a5,1
    80005344:	0004a703          	lw	a4,0(s1)
    80005348:	02e7e7bb          	remw	a5,a5,a4
    8000534c:	00f4a823          	sw	a5,16(s1)
    mutexHead->signal();
    80005350:	0284b503          	ld	a0,40(s1)
    80005354:	ffffe097          	auipc	ra,0xffffe
    80005358:	814080e7          	jalr	-2028(ra) # 80002b68 <_ZN9Semaphore6signalEv>

    spaceAvailable->signal();
    8000535c:	0184b503          	ld	a0,24(s1)
    80005360:	ffffe097          	auipc	ra,0xffffe
    80005364:	808080e7          	jalr	-2040(ra) # 80002b68 <_ZN9Semaphore6signalEv>

    return ret;
}
    80005368:	00090513          	mv	a0,s2
    8000536c:	01813083          	ld	ra,24(sp)
    80005370:	01013403          	ld	s0,16(sp)
    80005374:	00813483          	ld	s1,8(sp)
    80005378:	00013903          	ld	s2,0(sp)
    8000537c:	02010113          	addi	sp,sp,32
    80005380:	00008067          	ret

0000000080005384 <_ZN9BufferCPP6getCntEv>:

int BufferCPP::getCnt() {
    80005384:	fe010113          	addi	sp,sp,-32
    80005388:	00113c23          	sd	ra,24(sp)
    8000538c:	00813823          	sd	s0,16(sp)
    80005390:	00913423          	sd	s1,8(sp)
    80005394:	01213023          	sd	s2,0(sp)
    80005398:	02010413          	addi	s0,sp,32
    8000539c:	00050493          	mv	s1,a0
    int ret;

    mutexHead->wait();
    800053a0:	02853503          	ld	a0,40(a0)
    800053a4:	ffffd097          	auipc	ra,0xffffd
    800053a8:	798080e7          	jalr	1944(ra) # 80002b3c <_ZN9Semaphore4waitEv>
    mutexTail->wait();
    800053ac:	0304b503          	ld	a0,48(s1)
    800053b0:	ffffd097          	auipc	ra,0xffffd
    800053b4:	78c080e7          	jalr	1932(ra) # 80002b3c <_ZN9Semaphore4waitEv>

    if (tail >= head) {
    800053b8:	0144a783          	lw	a5,20(s1)
    800053bc:	0104a903          	lw	s2,16(s1)
    800053c0:	0327ce63          	blt	a5,s2,800053fc <_ZN9BufferCPP6getCntEv+0x78>
        ret = tail - head;
    800053c4:	4127893b          	subw	s2,a5,s2
    } else {
        ret = cap - head + tail;
    }

    mutexTail->signal();
    800053c8:	0304b503          	ld	a0,48(s1)
    800053cc:	ffffd097          	auipc	ra,0xffffd
    800053d0:	79c080e7          	jalr	1948(ra) # 80002b68 <_ZN9Semaphore6signalEv>
    mutexHead->signal();
    800053d4:	0284b503          	ld	a0,40(s1)
    800053d8:	ffffd097          	auipc	ra,0xffffd
    800053dc:	790080e7          	jalr	1936(ra) # 80002b68 <_ZN9Semaphore6signalEv>

    return ret;
}
    800053e0:	00090513          	mv	a0,s2
    800053e4:	01813083          	ld	ra,24(sp)
    800053e8:	01013403          	ld	s0,16(sp)
    800053ec:	00813483          	ld	s1,8(sp)
    800053f0:	00013903          	ld	s2,0(sp)
    800053f4:	02010113          	addi	sp,sp,32
    800053f8:	00008067          	ret
        ret = cap - head + tail;
    800053fc:	0004a703          	lw	a4,0(s1)
    80005400:	4127093b          	subw	s2,a4,s2
    80005404:	00f9093b          	addw	s2,s2,a5
    80005408:	fc1ff06f          	j	800053c8 <_ZN9BufferCPP6getCntEv+0x44>

000000008000540c <_ZN9BufferCPPD1Ev>:
BufferCPP::~BufferCPP() {
    8000540c:	fe010113          	addi	sp,sp,-32
    80005410:	00113c23          	sd	ra,24(sp)
    80005414:	00813823          	sd	s0,16(sp)
    80005418:	00913423          	sd	s1,8(sp)
    8000541c:	02010413          	addi	s0,sp,32
    80005420:	00050493          	mv	s1,a0
    Console::putc('\n');
    80005424:	00a00513          	li	a0,10
    80005428:	ffffd097          	auipc	ra,0xffffd
    8000542c:	798080e7          	jalr	1944(ra) # 80002bc0 <_ZN7Console4putcEc>
    printString("Buffer deleted!\n");
    80005430:	00004517          	auipc	a0,0x4
    80005434:	e6850513          	addi	a0,a0,-408 # 80009298 <CONSOLE_STATUS+0x288>
    80005438:	00000097          	auipc	ra,0x0
    8000543c:	a0c080e7          	jalr	-1524(ra) # 80004e44 <_Z11printStringPKc>
    while (getCnt()) {
    80005440:	00048513          	mv	a0,s1
    80005444:	00000097          	auipc	ra,0x0
    80005448:	f40080e7          	jalr	-192(ra) # 80005384 <_ZN9BufferCPP6getCntEv>
    8000544c:	02050c63          	beqz	a0,80005484 <_ZN9BufferCPPD1Ev+0x78>
        char ch = buffer[head];
    80005450:	0084b783          	ld	a5,8(s1)
    80005454:	0104a703          	lw	a4,16(s1)
    80005458:	00271713          	slli	a4,a4,0x2
    8000545c:	00e787b3          	add	a5,a5,a4
        Console::putc(ch);
    80005460:	0007c503          	lbu	a0,0(a5)
    80005464:	ffffd097          	auipc	ra,0xffffd
    80005468:	75c080e7          	jalr	1884(ra) # 80002bc0 <_ZN7Console4putcEc>
        head = (head + 1) % cap;
    8000546c:	0104a783          	lw	a5,16(s1)
    80005470:	0017879b          	addiw	a5,a5,1
    80005474:	0004a703          	lw	a4,0(s1)
    80005478:	02e7e7bb          	remw	a5,a5,a4
    8000547c:	00f4a823          	sw	a5,16(s1)
    while (getCnt()) {
    80005480:	fc1ff06f          	j	80005440 <_ZN9BufferCPPD1Ev+0x34>
    Console::putc('!');
    80005484:	02100513          	li	a0,33
    80005488:	ffffd097          	auipc	ra,0xffffd
    8000548c:	738080e7          	jalr	1848(ra) # 80002bc0 <_ZN7Console4putcEc>
    Console::putc('\n');
    80005490:	00a00513          	li	a0,10
    80005494:	ffffd097          	auipc	ra,0xffffd
    80005498:	72c080e7          	jalr	1836(ra) # 80002bc0 <_ZN7Console4putcEc>
    mem_free(buffer);
    8000549c:	0084b503          	ld	a0,8(s1)
    800054a0:	ffffc097          	auipc	ra,0xffffc
    800054a4:	544080e7          	jalr	1348(ra) # 800019e4 <_Z8mem_freePv>
    delete itemAvailable;
    800054a8:	0204b503          	ld	a0,32(s1)
    800054ac:	00050863          	beqz	a0,800054bc <_ZN9BufferCPPD1Ev+0xb0>
    800054b0:	00053783          	ld	a5,0(a0)
    800054b4:	0087b783          	ld	a5,8(a5)
    800054b8:	000780e7          	jalr	a5
    delete spaceAvailable;
    800054bc:	0184b503          	ld	a0,24(s1)
    800054c0:	00050863          	beqz	a0,800054d0 <_ZN9BufferCPPD1Ev+0xc4>
    800054c4:	00053783          	ld	a5,0(a0)
    800054c8:	0087b783          	ld	a5,8(a5)
    800054cc:	000780e7          	jalr	a5
    delete mutexTail;
    800054d0:	0304b503          	ld	a0,48(s1)
    800054d4:	00050863          	beqz	a0,800054e4 <_ZN9BufferCPPD1Ev+0xd8>
    800054d8:	00053783          	ld	a5,0(a0)
    800054dc:	0087b783          	ld	a5,8(a5)
    800054e0:	000780e7          	jalr	a5
    delete mutexHead;
    800054e4:	0284b503          	ld	a0,40(s1)
    800054e8:	00050863          	beqz	a0,800054f8 <_ZN9BufferCPPD1Ev+0xec>
    800054ec:	00053783          	ld	a5,0(a0)
    800054f0:	0087b783          	ld	a5,8(a5)
    800054f4:	000780e7          	jalr	a5
}
    800054f8:	01813083          	ld	ra,24(sp)
    800054fc:	01013403          	ld	s0,16(sp)
    80005500:	00813483          	ld	s1,8(sp)
    80005504:	02010113          	addi	sp,sp,32
    80005508:	00008067          	ret

000000008000550c <_Z8userMainv>:
#include "../test/ConsumerProducer_CPP_API_test.hpp"
#include "System_Mode_test.hpp"

#endif

void userMain() {
    8000550c:	fe010113          	addi	sp,sp,-32
    80005510:	00113c23          	sd	ra,24(sp)
    80005514:	00813823          	sd	s0,16(sp)
    80005518:	00913423          	sd	s1,8(sp)
    8000551c:	01213023          	sd	s2,0(sp)
    80005520:	02010413          	addi	s0,sp,32
    printString("Unesite broj testa? [1-7]\n");
    80005524:	00004517          	auipc	a0,0x4
    80005528:	d8c50513          	addi	a0,a0,-628 # 800092b0 <CONSOLE_STATUS+0x2a0>
    8000552c:	00000097          	auipc	ra,0x0
    80005530:	918080e7          	jalr	-1768(ra) # 80004e44 <_Z11printStringPKc>
    int test = getc() - '0';
    80005534:	ffffc097          	auipc	ra,0xffffc
    80005538:	698080e7          	jalr	1688(ra) # 80001bcc <_Z4getcv>
    8000553c:	00050913          	mv	s2,a0
    80005540:	fd05049b          	addiw	s1,a0,-48
    getc(); // Enter posle broja
    80005544:	ffffc097          	auipc	ra,0xffffc
    80005548:	688080e7          	jalr	1672(ra) # 80001bcc <_Z4getcv>
            printString("Nije navedeno da je zadatak 3 implementiran\n");
            return;
        }
    }

    if (test >= 5 && test <= 6) {
    8000554c:	fcb9091b          	addiw	s2,s2,-53
    80005550:	00100793          	li	a5,1
    80005554:	0327f463          	bgeu	a5,s2,8000557c <_Z8userMainv+0x70>
            printString("Nije navedeno da je zadatak 4 implementiran\n");
            return;
        }
    }

    switch (test) {
    80005558:	00700793          	li	a5,7
    8000555c:	0e97e263          	bltu	a5,s1,80005640 <_Z8userMainv+0x134>
    80005560:	00249493          	slli	s1,s1,0x2
    80005564:	00004717          	auipc	a4,0x4
    80005568:	f6470713          	addi	a4,a4,-156 # 800094c8 <CONSOLE_STATUS+0x4b8>
    8000556c:	00e484b3          	add	s1,s1,a4
    80005570:	0004a783          	lw	a5,0(s1)
    80005574:	00e787b3          	add	a5,a5,a4
    80005578:	00078067          	jr	a5
            printString("Nije navedeno da je zadatak 4 implementiran\n");
    8000557c:	00004517          	auipc	a0,0x4
    80005580:	d5450513          	addi	a0,a0,-684 # 800092d0 <CONSOLE_STATUS+0x2c0>
    80005584:	00000097          	auipc	ra,0x0
    80005588:	8c0080e7          	jalr	-1856(ra) # 80004e44 <_Z11printStringPKc>
#endif
            break;
        default:
            printString("Niste uneli odgovarajuci broj za test\n");
    }
    8000558c:	01813083          	ld	ra,24(sp)
    80005590:	01013403          	ld	s0,16(sp)
    80005594:	00813483          	ld	s1,8(sp)
    80005598:	00013903          	ld	s2,0(sp)
    8000559c:	02010113          	addi	sp,sp,32
    800055a0:	00008067          	ret
            Threads_C_API_test();
    800055a4:	fffff097          	auipc	ra,0xfffff
    800055a8:	f18080e7          	jalr	-232(ra) # 800044bc <_Z18Threads_C_API_testv>
            printString("TEST 1 (zadatak 2, niti C API i sinhrona promena konteksta)\n");
    800055ac:	00004517          	auipc	a0,0x4
    800055b0:	d5450513          	addi	a0,a0,-684 # 80009300 <CONSOLE_STATUS+0x2f0>
    800055b4:	00000097          	auipc	ra,0x0
    800055b8:	890080e7          	jalr	-1904(ra) # 80004e44 <_Z11printStringPKc>
            break;
    800055bc:	fd1ff06f          	j	8000558c <_Z8userMainv+0x80>
            Threads_CPP_API_test();
    800055c0:	ffffe097          	auipc	ra,0xffffe
    800055c4:	560080e7          	jalr	1376(ra) # 80003b20 <_Z20Threads_CPP_API_testv>
            printString("TEST 2 (zadatak 2., niti CPP API i sinhrona promena konteksta)\n");
    800055c8:	00004517          	auipc	a0,0x4
    800055cc:	d7850513          	addi	a0,a0,-648 # 80009340 <CONSOLE_STATUS+0x330>
    800055d0:	00000097          	auipc	ra,0x0
    800055d4:	874080e7          	jalr	-1932(ra) # 80004e44 <_Z11printStringPKc>
            break;
    800055d8:	fb5ff06f          	j	8000558c <_Z8userMainv+0x80>
            producerConsumer_C_API();
    800055dc:	ffffe097          	auipc	ra,0xffffe
    800055e0:	d98080e7          	jalr	-616(ra) # 80003374 <_Z22producerConsumer_C_APIv>
            printString("TEST 3 (zadatak 3., kompletan C API sa semaforima, sinhrona promena konteksta)\n");
    800055e4:	00004517          	auipc	a0,0x4
    800055e8:	d9c50513          	addi	a0,a0,-612 # 80009380 <CONSOLE_STATUS+0x370>
    800055ec:	00000097          	auipc	ra,0x0
    800055f0:	858080e7          	jalr	-1960(ra) # 80004e44 <_Z11printStringPKc>
            break;
    800055f4:	f99ff06f          	j	8000558c <_Z8userMainv+0x80>
            producerConsumer_CPP_Sync_API();
    800055f8:	fffff097          	auipc	ra,0xfffff
    800055fc:	208080e7          	jalr	520(ra) # 80004800 <_Z29producerConsumer_CPP_Sync_APIv>
            printString("TEST 4 (zadatak 3., kompletan CPP API sa semaforima, sinhrona promena konteksta)\n");
    80005600:	00004517          	auipc	a0,0x4
    80005604:	dd050513          	addi	a0,a0,-560 # 800093d0 <CONSOLE_STATUS+0x3c0>
    80005608:	00000097          	auipc	ra,0x0
    8000560c:	83c080e7          	jalr	-1988(ra) # 80004e44 <_Z11printStringPKc>
            break;
    80005610:	f7dff06f          	j	8000558c <_Z8userMainv+0x80>
            System_Mode_test();
    80005614:	00000097          	auipc	ra,0x0
    80005618:	52c080e7          	jalr	1324(ra) # 80005b40 <_Z16System_Mode_testv>
            printString("Test se nije uspesno zavrsio\n");
    8000561c:	00004517          	auipc	a0,0x4
    80005620:	e0c50513          	addi	a0,a0,-500 # 80009428 <CONSOLE_STATUS+0x418>
    80005624:	00000097          	auipc	ra,0x0
    80005628:	820080e7          	jalr	-2016(ra) # 80004e44 <_Z11printStringPKc>
            printString("TEST 7 (zadatak 2., testiranje da li se korisnicki kod izvrsava u korisnickom rezimu)\n");
    8000562c:	00004517          	auipc	a0,0x4
    80005630:	e1c50513          	addi	a0,a0,-484 # 80009448 <CONSOLE_STATUS+0x438>
    80005634:	00000097          	auipc	ra,0x0
    80005638:	810080e7          	jalr	-2032(ra) # 80004e44 <_Z11printStringPKc>
            break;
    8000563c:	f51ff06f          	j	8000558c <_Z8userMainv+0x80>
            printString("Niste uneli odgovarajuci broj za test\n");
    80005640:	00004517          	auipc	a0,0x4
    80005644:	e6050513          	addi	a0,a0,-416 # 800094a0 <CONSOLE_STATUS+0x490>
    80005648:	fffff097          	auipc	ra,0xfffff
    8000564c:	7fc080e7          	jalr	2044(ra) # 80004e44 <_Z11printStringPKc>
    80005650:	f3dff06f          	j	8000558c <_Z8userMainv+0x80>

0000000080005654 <_ZL9fibonaccim>:
static volatile bool finishedA = false;
static volatile bool finishedB = false;
static volatile bool finishedC = false;
static volatile bool finishedD = false;

static uint64 fibonacci(uint64 n) {
    80005654:	fe010113          	addi	sp,sp,-32
    80005658:	00113c23          	sd	ra,24(sp)
    8000565c:	00813823          	sd	s0,16(sp)
    80005660:	00913423          	sd	s1,8(sp)
    80005664:	01213023          	sd	s2,0(sp)
    80005668:	02010413          	addi	s0,sp,32
    8000566c:	00050493          	mv	s1,a0
    if (n == 0 || n == 1) { return n; }
    80005670:	00100793          	li	a5,1
    80005674:	02a7f863          	bgeu	a5,a0,800056a4 <_ZL9fibonaccim+0x50>
    if (n % 10 == 0) { thread_dispatch(); }
    80005678:	00a00793          	li	a5,10
    8000567c:	02f577b3          	remu	a5,a0,a5
    80005680:	02078e63          	beqz	a5,800056bc <_ZL9fibonaccim+0x68>
    return fibonacci(n - 1) + fibonacci(n - 2);
    80005684:	fff48513          	addi	a0,s1,-1
    80005688:	00000097          	auipc	ra,0x0
    8000568c:	fcc080e7          	jalr	-52(ra) # 80005654 <_ZL9fibonaccim>
    80005690:	00050913          	mv	s2,a0
    80005694:	ffe48513          	addi	a0,s1,-2
    80005698:	00000097          	auipc	ra,0x0
    8000569c:	fbc080e7          	jalr	-68(ra) # 80005654 <_ZL9fibonaccim>
    800056a0:	00a90533          	add	a0,s2,a0
}
    800056a4:	01813083          	ld	ra,24(sp)
    800056a8:	01013403          	ld	s0,16(sp)
    800056ac:	00813483          	ld	s1,8(sp)
    800056b0:	00013903          	ld	s2,0(sp)
    800056b4:	02010113          	addi	sp,sp,32
    800056b8:	00008067          	ret
    if (n % 10 == 0) { thread_dispatch(); }
    800056bc:	ffffc097          	auipc	ra,0xffffc
    800056c0:	3ec080e7          	jalr	1004(ra) # 80001aa8 <_Z15thread_dispatchv>
    800056c4:	fc1ff06f          	j	80005684 <_ZL9fibonaccim+0x30>

00000000800056c8 <_ZL11workerBodyDPv>:
    printString("A finished!\n");
    finishedC = true;
    thread_dispatch();
}

static void workerBodyD(void* arg) {
    800056c8:	fe010113          	addi	sp,sp,-32
    800056cc:	00113c23          	sd	ra,24(sp)
    800056d0:	00813823          	sd	s0,16(sp)
    800056d4:	00913423          	sd	s1,8(sp)
    800056d8:	01213023          	sd	s2,0(sp)
    800056dc:	02010413          	addi	s0,sp,32
    uint8 i = 10;
    800056e0:	00a00493          	li	s1,10
    800056e4:	0400006f          	j	80005724 <_ZL11workerBodyDPv+0x5c>
    for (; i < 13; i++) {
        printString("D: i="); printInt(i); printString("\n");
    800056e8:	00004517          	auipc	a0,0x4
    800056ec:	b1850513          	addi	a0,a0,-1256 # 80009200 <CONSOLE_STATUS+0x1f0>
    800056f0:	fffff097          	auipc	ra,0xfffff
    800056f4:	754080e7          	jalr	1876(ra) # 80004e44 <_Z11printStringPKc>
    800056f8:	00000613          	li	a2,0
    800056fc:	00a00593          	li	a1,10
    80005700:	00048513          	mv	a0,s1
    80005704:	00000097          	auipc	ra,0x0
    80005708:	8f0080e7          	jalr	-1808(ra) # 80004ff4 <_Z8printIntiii>
    8000570c:	00004517          	auipc	a0,0x4
    80005710:	d1450513          	addi	a0,a0,-748 # 80009420 <CONSOLE_STATUS+0x410>
    80005714:	fffff097          	auipc	ra,0xfffff
    80005718:	730080e7          	jalr	1840(ra) # 80004e44 <_Z11printStringPKc>
    for (; i < 13; i++) {
    8000571c:	0014849b          	addiw	s1,s1,1
    80005720:	0ff4f493          	andi	s1,s1,255
    80005724:	00c00793          	li	a5,12
    80005728:	fc97f0e3          	bgeu	a5,s1,800056e8 <_ZL11workerBodyDPv+0x20>
    }

    printString("D: dispatch\n");
    8000572c:	00004517          	auipc	a0,0x4
    80005730:	adc50513          	addi	a0,a0,-1316 # 80009208 <CONSOLE_STATUS+0x1f8>
    80005734:	fffff097          	auipc	ra,0xfffff
    80005738:	710080e7          	jalr	1808(ra) # 80004e44 <_Z11printStringPKc>
    __asm__ ("li t1, 5");
    8000573c:	00500313          	li	t1,5
    thread_dispatch();
    80005740:	ffffc097          	auipc	ra,0xffffc
    80005744:	368080e7          	jalr	872(ra) # 80001aa8 <_Z15thread_dispatchv>

    uint64 result = fibonacci(16);
    80005748:	01000513          	li	a0,16
    8000574c:	00000097          	auipc	ra,0x0
    80005750:	f08080e7          	jalr	-248(ra) # 80005654 <_ZL9fibonaccim>
    80005754:	00050913          	mv	s2,a0
    printString("D: fibonaci="); printInt(result); printString("\n");
    80005758:	00004517          	auipc	a0,0x4
    8000575c:	ac050513          	addi	a0,a0,-1344 # 80009218 <CONSOLE_STATUS+0x208>
    80005760:	fffff097          	auipc	ra,0xfffff
    80005764:	6e4080e7          	jalr	1764(ra) # 80004e44 <_Z11printStringPKc>
    80005768:	00000613          	li	a2,0
    8000576c:	00a00593          	li	a1,10
    80005770:	0009051b          	sext.w	a0,s2
    80005774:	00000097          	auipc	ra,0x0
    80005778:	880080e7          	jalr	-1920(ra) # 80004ff4 <_Z8printIntiii>
    8000577c:	00004517          	auipc	a0,0x4
    80005780:	ca450513          	addi	a0,a0,-860 # 80009420 <CONSOLE_STATUS+0x410>
    80005784:	fffff097          	auipc	ra,0xfffff
    80005788:	6c0080e7          	jalr	1728(ra) # 80004e44 <_Z11printStringPKc>
    8000578c:	0400006f          	j	800057cc <_ZL11workerBodyDPv+0x104>

    for (; i < 16; i++) {
        printString("D: i="); printInt(i); printString("\n");
    80005790:	00004517          	auipc	a0,0x4
    80005794:	a7050513          	addi	a0,a0,-1424 # 80009200 <CONSOLE_STATUS+0x1f0>
    80005798:	fffff097          	auipc	ra,0xfffff
    8000579c:	6ac080e7          	jalr	1708(ra) # 80004e44 <_Z11printStringPKc>
    800057a0:	00000613          	li	a2,0
    800057a4:	00a00593          	li	a1,10
    800057a8:	00048513          	mv	a0,s1
    800057ac:	00000097          	auipc	ra,0x0
    800057b0:	848080e7          	jalr	-1976(ra) # 80004ff4 <_Z8printIntiii>
    800057b4:	00004517          	auipc	a0,0x4
    800057b8:	c6c50513          	addi	a0,a0,-916 # 80009420 <CONSOLE_STATUS+0x410>
    800057bc:	fffff097          	auipc	ra,0xfffff
    800057c0:	688080e7          	jalr	1672(ra) # 80004e44 <_Z11printStringPKc>
    for (; i < 16; i++) {
    800057c4:	0014849b          	addiw	s1,s1,1
    800057c8:	0ff4f493          	andi	s1,s1,255
    800057cc:	00f00793          	li	a5,15
    800057d0:	fc97f0e3          	bgeu	a5,s1,80005790 <_ZL11workerBodyDPv+0xc8>
    }

    printString("D finished!\n");
    800057d4:	00004517          	auipc	a0,0x4
    800057d8:	a5450513          	addi	a0,a0,-1452 # 80009228 <CONSOLE_STATUS+0x218>
    800057dc:	fffff097          	auipc	ra,0xfffff
    800057e0:	668080e7          	jalr	1640(ra) # 80004e44 <_Z11printStringPKc>
    finishedD = true;
    800057e4:	00100793          	li	a5,1
    800057e8:	0008a717          	auipc	a4,0x8a
    800057ec:	18f70023          	sb	a5,384(a4) # 8008f968 <_ZL9finishedD>
    thread_dispatch();
    800057f0:	ffffc097          	auipc	ra,0xffffc
    800057f4:	2b8080e7          	jalr	696(ra) # 80001aa8 <_Z15thread_dispatchv>
}
    800057f8:	01813083          	ld	ra,24(sp)
    800057fc:	01013403          	ld	s0,16(sp)
    80005800:	00813483          	ld	s1,8(sp)
    80005804:	00013903          	ld	s2,0(sp)
    80005808:	02010113          	addi	sp,sp,32
    8000580c:	00008067          	ret

0000000080005810 <_ZL11workerBodyCPv>:
static void workerBodyC(void* arg) {
    80005810:	fe010113          	addi	sp,sp,-32
    80005814:	00113c23          	sd	ra,24(sp)
    80005818:	00813823          	sd	s0,16(sp)
    8000581c:	00913423          	sd	s1,8(sp)
    80005820:	01213023          	sd	s2,0(sp)
    80005824:	02010413          	addi	s0,sp,32
    uint8 i = 0;
    80005828:	00000493          	li	s1,0
    8000582c:	0400006f          	j	8000586c <_ZL11workerBodyCPv+0x5c>
        printString("C: i="); printInt(i); printString("\n");
    80005830:	00004517          	auipc	a0,0x4
    80005834:	9a050513          	addi	a0,a0,-1632 # 800091d0 <CONSOLE_STATUS+0x1c0>
    80005838:	fffff097          	auipc	ra,0xfffff
    8000583c:	60c080e7          	jalr	1548(ra) # 80004e44 <_Z11printStringPKc>
    80005840:	00000613          	li	a2,0
    80005844:	00a00593          	li	a1,10
    80005848:	00048513          	mv	a0,s1
    8000584c:	fffff097          	auipc	ra,0xfffff
    80005850:	7a8080e7          	jalr	1960(ra) # 80004ff4 <_Z8printIntiii>
    80005854:	00004517          	auipc	a0,0x4
    80005858:	bcc50513          	addi	a0,a0,-1076 # 80009420 <CONSOLE_STATUS+0x410>
    8000585c:	fffff097          	auipc	ra,0xfffff
    80005860:	5e8080e7          	jalr	1512(ra) # 80004e44 <_Z11printStringPKc>
    for (; i < 3; i++) {
    80005864:	0014849b          	addiw	s1,s1,1
    80005868:	0ff4f493          	andi	s1,s1,255
    8000586c:	00200793          	li	a5,2
    80005870:	fc97f0e3          	bgeu	a5,s1,80005830 <_ZL11workerBodyCPv+0x20>
    printString("C: dispatch\n");
    80005874:	00004517          	auipc	a0,0x4
    80005878:	96450513          	addi	a0,a0,-1692 # 800091d8 <CONSOLE_STATUS+0x1c8>
    8000587c:	fffff097          	auipc	ra,0xfffff
    80005880:	5c8080e7          	jalr	1480(ra) # 80004e44 <_Z11printStringPKc>
    __asm__ ("li t1, 7");
    80005884:	00700313          	li	t1,7
    thread_dispatch();
    80005888:	ffffc097          	auipc	ra,0xffffc
    8000588c:	220080e7          	jalr	544(ra) # 80001aa8 <_Z15thread_dispatchv>
    __asm__ ("mv %[t1], t1" : [t1] "=r"(t1));
    80005890:	00030913          	mv	s2,t1
    printString("C: t1="); printInt(t1); printString("\n");
    80005894:	00004517          	auipc	a0,0x4
    80005898:	95450513          	addi	a0,a0,-1708 # 800091e8 <CONSOLE_STATUS+0x1d8>
    8000589c:	fffff097          	auipc	ra,0xfffff
    800058a0:	5a8080e7          	jalr	1448(ra) # 80004e44 <_Z11printStringPKc>
    800058a4:	00000613          	li	a2,0
    800058a8:	00a00593          	li	a1,10
    800058ac:	0009051b          	sext.w	a0,s2
    800058b0:	fffff097          	auipc	ra,0xfffff
    800058b4:	744080e7          	jalr	1860(ra) # 80004ff4 <_Z8printIntiii>
    800058b8:	00004517          	auipc	a0,0x4
    800058bc:	b6850513          	addi	a0,a0,-1176 # 80009420 <CONSOLE_STATUS+0x410>
    800058c0:	fffff097          	auipc	ra,0xfffff
    800058c4:	584080e7          	jalr	1412(ra) # 80004e44 <_Z11printStringPKc>
    uint64 result = fibonacci(12);
    800058c8:	00c00513          	li	a0,12
    800058cc:	00000097          	auipc	ra,0x0
    800058d0:	d88080e7          	jalr	-632(ra) # 80005654 <_ZL9fibonaccim>
    800058d4:	00050913          	mv	s2,a0
    printString("C: fibonaci="); printInt(result); printString("\n");
    800058d8:	00004517          	auipc	a0,0x4
    800058dc:	91850513          	addi	a0,a0,-1768 # 800091f0 <CONSOLE_STATUS+0x1e0>
    800058e0:	fffff097          	auipc	ra,0xfffff
    800058e4:	564080e7          	jalr	1380(ra) # 80004e44 <_Z11printStringPKc>
    800058e8:	00000613          	li	a2,0
    800058ec:	00a00593          	li	a1,10
    800058f0:	0009051b          	sext.w	a0,s2
    800058f4:	fffff097          	auipc	ra,0xfffff
    800058f8:	700080e7          	jalr	1792(ra) # 80004ff4 <_Z8printIntiii>
    800058fc:	00004517          	auipc	a0,0x4
    80005900:	b2450513          	addi	a0,a0,-1244 # 80009420 <CONSOLE_STATUS+0x410>
    80005904:	fffff097          	auipc	ra,0xfffff
    80005908:	540080e7          	jalr	1344(ra) # 80004e44 <_Z11printStringPKc>
    8000590c:	0400006f          	j	8000594c <_ZL11workerBodyCPv+0x13c>
        printString("C: i="); printInt(i); printString("\n");
    80005910:	00004517          	auipc	a0,0x4
    80005914:	8c050513          	addi	a0,a0,-1856 # 800091d0 <CONSOLE_STATUS+0x1c0>
    80005918:	fffff097          	auipc	ra,0xfffff
    8000591c:	52c080e7          	jalr	1324(ra) # 80004e44 <_Z11printStringPKc>
    80005920:	00000613          	li	a2,0
    80005924:	00a00593          	li	a1,10
    80005928:	00048513          	mv	a0,s1
    8000592c:	fffff097          	auipc	ra,0xfffff
    80005930:	6c8080e7          	jalr	1736(ra) # 80004ff4 <_Z8printIntiii>
    80005934:	00004517          	auipc	a0,0x4
    80005938:	aec50513          	addi	a0,a0,-1300 # 80009420 <CONSOLE_STATUS+0x410>
    8000593c:	fffff097          	auipc	ra,0xfffff
    80005940:	508080e7          	jalr	1288(ra) # 80004e44 <_Z11printStringPKc>
    for (; i < 6; i++) {
    80005944:	0014849b          	addiw	s1,s1,1
    80005948:	0ff4f493          	andi	s1,s1,255
    8000594c:	00500793          	li	a5,5
    80005950:	fc97f0e3          	bgeu	a5,s1,80005910 <_ZL11workerBodyCPv+0x100>
    printString("A finished!\n");
    80005954:	00004517          	auipc	a0,0x4
    80005958:	85450513          	addi	a0,a0,-1964 # 800091a8 <CONSOLE_STATUS+0x198>
    8000595c:	fffff097          	auipc	ra,0xfffff
    80005960:	4e8080e7          	jalr	1256(ra) # 80004e44 <_Z11printStringPKc>
    finishedC = true;
    80005964:	00100793          	li	a5,1
    80005968:	0008a717          	auipc	a4,0x8a
    8000596c:	00f700a3          	sb	a5,1(a4) # 8008f969 <_ZL9finishedC>
    thread_dispatch();
    80005970:	ffffc097          	auipc	ra,0xffffc
    80005974:	138080e7          	jalr	312(ra) # 80001aa8 <_Z15thread_dispatchv>
}
    80005978:	01813083          	ld	ra,24(sp)
    8000597c:	01013403          	ld	s0,16(sp)
    80005980:	00813483          	ld	s1,8(sp)
    80005984:	00013903          	ld	s2,0(sp)
    80005988:	02010113          	addi	sp,sp,32
    8000598c:	00008067          	ret

0000000080005990 <_ZL11workerBodyBPv>:
static void workerBodyB(void* arg) {
    80005990:	fe010113          	addi	sp,sp,-32
    80005994:	00113c23          	sd	ra,24(sp)
    80005998:	00813823          	sd	s0,16(sp)
    8000599c:	00913423          	sd	s1,8(sp)
    800059a0:	01213023          	sd	s2,0(sp)
    800059a4:	02010413          	addi	s0,sp,32
    for (uint64 i = 0; i < 16; i++) {
    800059a8:	00000913          	li	s2,0
    800059ac:	0400006f          	j	800059ec <_ZL11workerBodyBPv+0x5c>
            thread_dispatch();
    800059b0:	ffffc097          	auipc	ra,0xffffc
    800059b4:	0f8080e7          	jalr	248(ra) # 80001aa8 <_Z15thread_dispatchv>
        for (uint64 j = 0; j < 10000; j++) {
    800059b8:	00148493          	addi	s1,s1,1
    800059bc:	000027b7          	lui	a5,0x2
    800059c0:	70f78793          	addi	a5,a5,1807 # 270f <_entry-0x7fffd8f1>
    800059c4:	0097ee63          	bltu	a5,s1,800059e0 <_ZL11workerBodyBPv+0x50>
            for (uint64 k = 0; k < 30000; k++) { /* busy wait */ }
    800059c8:	00000713          	li	a4,0
    800059cc:	000077b7          	lui	a5,0x7
    800059d0:	52f78793          	addi	a5,a5,1327 # 752f <_entry-0x7fff8ad1>
    800059d4:	fce7eee3          	bltu	a5,a4,800059b0 <_ZL11workerBodyBPv+0x20>
    800059d8:	00170713          	addi	a4,a4,1
    800059dc:	ff1ff06f          	j	800059cc <_ZL11workerBodyBPv+0x3c>
        if (i == 10) {
    800059e0:	00a00793          	li	a5,10
    800059e4:	04f90663          	beq	s2,a5,80005a30 <_ZL11workerBodyBPv+0xa0>
    for (uint64 i = 0; i < 16; i++) {
    800059e8:	00190913          	addi	s2,s2,1
    800059ec:	00f00793          	li	a5,15
    800059f0:	0527e463          	bltu	a5,s2,80005a38 <_ZL11workerBodyBPv+0xa8>
        printString("B: i="); printInt(i); printString("\n");
    800059f4:	00003517          	auipc	a0,0x3
    800059f8:	7c450513          	addi	a0,a0,1988 # 800091b8 <CONSOLE_STATUS+0x1a8>
    800059fc:	fffff097          	auipc	ra,0xfffff
    80005a00:	448080e7          	jalr	1096(ra) # 80004e44 <_Z11printStringPKc>
    80005a04:	00000613          	li	a2,0
    80005a08:	00a00593          	li	a1,10
    80005a0c:	0009051b          	sext.w	a0,s2
    80005a10:	fffff097          	auipc	ra,0xfffff
    80005a14:	5e4080e7          	jalr	1508(ra) # 80004ff4 <_Z8printIntiii>
    80005a18:	00004517          	auipc	a0,0x4
    80005a1c:	a0850513          	addi	a0,a0,-1528 # 80009420 <CONSOLE_STATUS+0x410>
    80005a20:	fffff097          	auipc	ra,0xfffff
    80005a24:	424080e7          	jalr	1060(ra) # 80004e44 <_Z11printStringPKc>
        for (uint64 j = 0; j < 10000; j++) {
    80005a28:	00000493          	li	s1,0
    80005a2c:	f91ff06f          	j	800059bc <_ZL11workerBodyBPv+0x2c>
            asm volatile("csrr t6, sepc");
    80005a30:	14102ff3          	csrr	t6,sepc
    80005a34:	fb5ff06f          	j	800059e8 <_ZL11workerBodyBPv+0x58>
    printString("B finished!\n");
    80005a38:	00003517          	auipc	a0,0x3
    80005a3c:	78850513          	addi	a0,a0,1928 # 800091c0 <CONSOLE_STATUS+0x1b0>
    80005a40:	fffff097          	auipc	ra,0xfffff
    80005a44:	404080e7          	jalr	1028(ra) # 80004e44 <_Z11printStringPKc>
    finishedB = true;
    80005a48:	00100793          	li	a5,1
    80005a4c:	0008a717          	auipc	a4,0x8a
    80005a50:	f0f70f23          	sb	a5,-226(a4) # 8008f96a <_ZL9finishedB>
    thread_dispatch();
    80005a54:	ffffc097          	auipc	ra,0xffffc
    80005a58:	054080e7          	jalr	84(ra) # 80001aa8 <_Z15thread_dispatchv>
}
    80005a5c:	01813083          	ld	ra,24(sp)
    80005a60:	01013403          	ld	s0,16(sp)
    80005a64:	00813483          	ld	s1,8(sp)
    80005a68:	00013903          	ld	s2,0(sp)
    80005a6c:	02010113          	addi	sp,sp,32
    80005a70:	00008067          	ret

0000000080005a74 <_ZL11workerBodyAPv>:
static void workerBodyA(void* arg) {
    80005a74:	fe010113          	addi	sp,sp,-32
    80005a78:	00113c23          	sd	ra,24(sp)
    80005a7c:	00813823          	sd	s0,16(sp)
    80005a80:	00913423          	sd	s1,8(sp)
    80005a84:	01213023          	sd	s2,0(sp)
    80005a88:	02010413          	addi	s0,sp,32
    for (uint64 i = 0; i < 10; i++) {
    80005a8c:	00000913          	li	s2,0
    80005a90:	0380006f          	j	80005ac8 <_ZL11workerBodyAPv+0x54>
            thread_dispatch();
    80005a94:	ffffc097          	auipc	ra,0xffffc
    80005a98:	014080e7          	jalr	20(ra) # 80001aa8 <_Z15thread_dispatchv>
        for (uint64 j = 0; j < 10000; j++) {
    80005a9c:	00148493          	addi	s1,s1,1
    80005aa0:	000027b7          	lui	a5,0x2
    80005aa4:	70f78793          	addi	a5,a5,1807 # 270f <_entry-0x7fffd8f1>
    80005aa8:	0097ee63          	bltu	a5,s1,80005ac4 <_ZL11workerBodyAPv+0x50>
            for (uint64 k = 0; k < 30000; k++) { /* busy wait */ }
    80005aac:	00000713          	li	a4,0
    80005ab0:	000077b7          	lui	a5,0x7
    80005ab4:	52f78793          	addi	a5,a5,1327 # 752f <_entry-0x7fff8ad1>
    80005ab8:	fce7eee3          	bltu	a5,a4,80005a94 <_ZL11workerBodyAPv+0x20>
    80005abc:	00170713          	addi	a4,a4,1
    80005ac0:	ff1ff06f          	j	80005ab0 <_ZL11workerBodyAPv+0x3c>
    for (uint64 i = 0; i < 10; i++) {
    80005ac4:	00190913          	addi	s2,s2,1
    80005ac8:	00900793          	li	a5,9
    80005acc:	0527e063          	bltu	a5,s2,80005b0c <_ZL11workerBodyAPv+0x98>
        printString("A: i="); printInt(i); printString("\n");
    80005ad0:	00003517          	auipc	a0,0x3
    80005ad4:	6d050513          	addi	a0,a0,1744 # 800091a0 <CONSOLE_STATUS+0x190>
    80005ad8:	fffff097          	auipc	ra,0xfffff
    80005adc:	36c080e7          	jalr	876(ra) # 80004e44 <_Z11printStringPKc>
    80005ae0:	00000613          	li	a2,0
    80005ae4:	00a00593          	li	a1,10
    80005ae8:	0009051b          	sext.w	a0,s2
    80005aec:	fffff097          	auipc	ra,0xfffff
    80005af0:	508080e7          	jalr	1288(ra) # 80004ff4 <_Z8printIntiii>
    80005af4:	00004517          	auipc	a0,0x4
    80005af8:	92c50513          	addi	a0,a0,-1748 # 80009420 <CONSOLE_STATUS+0x410>
    80005afc:	fffff097          	auipc	ra,0xfffff
    80005b00:	348080e7          	jalr	840(ra) # 80004e44 <_Z11printStringPKc>
        for (uint64 j = 0; j < 10000; j++) {
    80005b04:	00000493          	li	s1,0
    80005b08:	f99ff06f          	j	80005aa0 <_ZL11workerBodyAPv+0x2c>
    printString("A finished!\n");
    80005b0c:	00003517          	auipc	a0,0x3
    80005b10:	69c50513          	addi	a0,a0,1692 # 800091a8 <CONSOLE_STATUS+0x198>
    80005b14:	fffff097          	auipc	ra,0xfffff
    80005b18:	330080e7          	jalr	816(ra) # 80004e44 <_Z11printStringPKc>
    finishedA = true;
    80005b1c:	00100793          	li	a5,1
    80005b20:	0008a717          	auipc	a4,0x8a
    80005b24:	e4f705a3          	sb	a5,-437(a4) # 8008f96b <_ZL9finishedA>
}
    80005b28:	01813083          	ld	ra,24(sp)
    80005b2c:	01013403          	ld	s0,16(sp)
    80005b30:	00813483          	ld	s1,8(sp)
    80005b34:	00013903          	ld	s2,0(sp)
    80005b38:	02010113          	addi	sp,sp,32
    80005b3c:	00008067          	ret

0000000080005b40 <_Z16System_Mode_testv>:


void System_Mode_test() {
    80005b40:	fd010113          	addi	sp,sp,-48
    80005b44:	02113423          	sd	ra,40(sp)
    80005b48:	02813023          	sd	s0,32(sp)
    80005b4c:	03010413          	addi	s0,sp,48
    thread_t threads[4];
    thread_create(&threads[0], workerBodyA, nullptr);
    80005b50:	00000613          	li	a2,0
    80005b54:	00000597          	auipc	a1,0x0
    80005b58:	f2058593          	addi	a1,a1,-224 # 80005a74 <_ZL11workerBodyAPv>
    80005b5c:	fd040513          	addi	a0,s0,-48
    80005b60:	ffffc097          	auipc	ra,0xffffc
    80005b64:	eb0080e7          	jalr	-336(ra) # 80001a10 <_Z13thread_createPP7_threadPFvPvES2_>
    printString("ThreadA created\n");
    80005b68:	00003517          	auipc	a0,0x3
    80005b6c:	6d050513          	addi	a0,a0,1744 # 80009238 <CONSOLE_STATUS+0x228>
    80005b70:	fffff097          	auipc	ra,0xfffff
    80005b74:	2d4080e7          	jalr	724(ra) # 80004e44 <_Z11printStringPKc>

    thread_create(&threads[1], workerBodyB, nullptr);
    80005b78:	00000613          	li	a2,0
    80005b7c:	00000597          	auipc	a1,0x0
    80005b80:	e1458593          	addi	a1,a1,-492 # 80005990 <_ZL11workerBodyBPv>
    80005b84:	fd840513          	addi	a0,s0,-40
    80005b88:	ffffc097          	auipc	ra,0xffffc
    80005b8c:	e88080e7          	jalr	-376(ra) # 80001a10 <_Z13thread_createPP7_threadPFvPvES2_>
    printString("ThreadB created\n");
    80005b90:	00003517          	auipc	a0,0x3
    80005b94:	6c050513          	addi	a0,a0,1728 # 80009250 <CONSOLE_STATUS+0x240>
    80005b98:	fffff097          	auipc	ra,0xfffff
    80005b9c:	2ac080e7          	jalr	684(ra) # 80004e44 <_Z11printStringPKc>

    thread_create(&threads[2], workerBodyC, nullptr);
    80005ba0:	00000613          	li	a2,0
    80005ba4:	00000597          	auipc	a1,0x0
    80005ba8:	c6c58593          	addi	a1,a1,-916 # 80005810 <_ZL11workerBodyCPv>
    80005bac:	fe040513          	addi	a0,s0,-32
    80005bb0:	ffffc097          	auipc	ra,0xffffc
    80005bb4:	e60080e7          	jalr	-416(ra) # 80001a10 <_Z13thread_createPP7_threadPFvPvES2_>
    printString("ThreadC created\n");
    80005bb8:	00003517          	auipc	a0,0x3
    80005bbc:	6b050513          	addi	a0,a0,1712 # 80009268 <CONSOLE_STATUS+0x258>
    80005bc0:	fffff097          	auipc	ra,0xfffff
    80005bc4:	284080e7          	jalr	644(ra) # 80004e44 <_Z11printStringPKc>

    thread_create(&threads[3], workerBodyD, nullptr);
    80005bc8:	00000613          	li	a2,0
    80005bcc:	00000597          	auipc	a1,0x0
    80005bd0:	afc58593          	addi	a1,a1,-1284 # 800056c8 <_ZL11workerBodyDPv>
    80005bd4:	fe840513          	addi	a0,s0,-24
    80005bd8:	ffffc097          	auipc	ra,0xffffc
    80005bdc:	e38080e7          	jalr	-456(ra) # 80001a10 <_Z13thread_createPP7_threadPFvPvES2_>
    printString("ThreadD created\n");
    80005be0:	00003517          	auipc	a0,0x3
    80005be4:	6a050513          	addi	a0,a0,1696 # 80009280 <CONSOLE_STATUS+0x270>
    80005be8:	fffff097          	auipc	ra,0xfffff
    80005bec:	25c080e7          	jalr	604(ra) # 80004e44 <_Z11printStringPKc>
    80005bf0:	00c0006f          	j	80005bfc <_Z16System_Mode_testv+0xbc>

    while (!(finishedA && finishedB && finishedC && finishedD)) {
        thread_dispatch();
    80005bf4:	ffffc097          	auipc	ra,0xffffc
    80005bf8:	eb4080e7          	jalr	-332(ra) # 80001aa8 <_Z15thread_dispatchv>
    while (!(finishedA && finishedB && finishedC && finishedD)) {
    80005bfc:	0008a797          	auipc	a5,0x8a
    80005c00:	d6f7c783          	lbu	a5,-657(a5) # 8008f96b <_ZL9finishedA>
    80005c04:	fe0788e3          	beqz	a5,80005bf4 <_Z16System_Mode_testv+0xb4>
    80005c08:	0008a797          	auipc	a5,0x8a
    80005c0c:	d627c783          	lbu	a5,-670(a5) # 8008f96a <_ZL9finishedB>
    80005c10:	fe0782e3          	beqz	a5,80005bf4 <_Z16System_Mode_testv+0xb4>
    80005c14:	0008a797          	auipc	a5,0x8a
    80005c18:	d557c783          	lbu	a5,-683(a5) # 8008f969 <_ZL9finishedC>
    80005c1c:	fc078ce3          	beqz	a5,80005bf4 <_Z16System_Mode_testv+0xb4>
    80005c20:	0008a797          	auipc	a5,0x8a
    80005c24:	d487c783          	lbu	a5,-696(a5) # 8008f968 <_ZL9finishedD>
    80005c28:	fc0786e3          	beqz	a5,80005bf4 <_Z16System_Mode_testv+0xb4>
    }

}
    80005c2c:	02813083          	ld	ra,40(sp)
    80005c30:	02013403          	ld	s0,32(sp)
    80005c34:	03010113          	addi	sp,sp,48
    80005c38:	00008067          	ret

0000000080005c3c <_ZN6BufferC1Ei>:
#include "buffer.hpp"

Buffer::Buffer(int _cap) : cap(_cap + 1), head(0), tail(0) {
    80005c3c:	fe010113          	addi	sp,sp,-32
    80005c40:	00113c23          	sd	ra,24(sp)
    80005c44:	00813823          	sd	s0,16(sp)
    80005c48:	00913423          	sd	s1,8(sp)
    80005c4c:	01213023          	sd	s2,0(sp)
    80005c50:	02010413          	addi	s0,sp,32
    80005c54:	00050493          	mv	s1,a0
    80005c58:	00058913          	mv	s2,a1
    80005c5c:	0015879b          	addiw	a5,a1,1
    80005c60:	0007851b          	sext.w	a0,a5
    80005c64:	00f4a023          	sw	a5,0(s1)
    80005c68:	0004a823          	sw	zero,16(s1)
    80005c6c:	0004aa23          	sw	zero,20(s1)
    buffer = (int *)mem_alloc(sizeof(int) * cap);
    80005c70:	00251513          	slli	a0,a0,0x2
    80005c74:	ffffc097          	auipc	ra,0xffffc
    80005c78:	d30080e7          	jalr	-720(ra) # 800019a4 <_Z9mem_allocm>
    80005c7c:	00a4b423          	sd	a0,8(s1)
    sem_open(&itemAvailable, 0);
    80005c80:	00000593          	li	a1,0
    80005c84:	02048513          	addi	a0,s1,32
    80005c88:	ffffc097          	auipc	ra,0xffffc
    80005c8c:	e64080e7          	jalr	-412(ra) # 80001aec <_Z8sem_openPP4_semj>
    sem_open(&spaceAvailable, _cap);
    80005c90:	00090593          	mv	a1,s2
    80005c94:	01848513          	addi	a0,s1,24
    80005c98:	ffffc097          	auipc	ra,0xffffc
    80005c9c:	e54080e7          	jalr	-428(ra) # 80001aec <_Z8sem_openPP4_semj>
    sem_open(&mutexHead, 1);
    80005ca0:	00100593          	li	a1,1
    80005ca4:	02848513          	addi	a0,s1,40
    80005ca8:	ffffc097          	auipc	ra,0xffffc
    80005cac:	e44080e7          	jalr	-444(ra) # 80001aec <_Z8sem_openPP4_semj>
    sem_open(&mutexTail, 1);
    80005cb0:	00100593          	li	a1,1
    80005cb4:	03048513          	addi	a0,s1,48
    80005cb8:	ffffc097          	auipc	ra,0xffffc
    80005cbc:	e34080e7          	jalr	-460(ra) # 80001aec <_Z8sem_openPP4_semj>
}
    80005cc0:	01813083          	ld	ra,24(sp)
    80005cc4:	01013403          	ld	s0,16(sp)
    80005cc8:	00813483          	ld	s1,8(sp)
    80005ccc:	00013903          	ld	s2,0(sp)
    80005cd0:	02010113          	addi	sp,sp,32
    80005cd4:	00008067          	ret

0000000080005cd8 <_ZN6Buffer3putEi>:
    sem_close(spaceAvailable);
    sem_close(mutexTail);
    sem_close(mutexHead);
}

void Buffer::put(int val) {
    80005cd8:	fe010113          	addi	sp,sp,-32
    80005cdc:	00113c23          	sd	ra,24(sp)
    80005ce0:	00813823          	sd	s0,16(sp)
    80005ce4:	00913423          	sd	s1,8(sp)
    80005ce8:	01213023          	sd	s2,0(sp)
    80005cec:	02010413          	addi	s0,sp,32
    80005cf0:	00050493          	mv	s1,a0
    80005cf4:	00058913          	mv	s2,a1
    sem_wait(spaceAvailable);
    80005cf8:	01853503          	ld	a0,24(a0)
    80005cfc:	ffffc097          	auipc	ra,0xffffc
    80005d00:	e4c080e7          	jalr	-436(ra) # 80001b48 <_Z8sem_waitP4_sem>

    sem_wait(mutexTail);
    80005d04:	0304b503          	ld	a0,48(s1)
    80005d08:	ffffc097          	auipc	ra,0xffffc
    80005d0c:	e40080e7          	jalr	-448(ra) # 80001b48 <_Z8sem_waitP4_sem>
    buffer[tail] = val;
    80005d10:	0084b783          	ld	a5,8(s1)
    80005d14:	0144a703          	lw	a4,20(s1)
    80005d18:	00271713          	slli	a4,a4,0x2
    80005d1c:	00e787b3          	add	a5,a5,a4
    80005d20:	0127a023          	sw	s2,0(a5)
    tail = (tail + 1) % cap;
    80005d24:	0144a783          	lw	a5,20(s1)
    80005d28:	0017879b          	addiw	a5,a5,1
    80005d2c:	0004a703          	lw	a4,0(s1)
    80005d30:	02e7e7bb          	remw	a5,a5,a4
    80005d34:	00f4aa23          	sw	a5,20(s1)
    sem_signal(mutexTail);
    80005d38:	0304b503          	ld	a0,48(s1)
    80005d3c:	ffffc097          	auipc	ra,0xffffc
    80005d40:	e38080e7          	jalr	-456(ra) # 80001b74 <_Z10sem_signalP4_sem>

    sem_signal(itemAvailable);
    80005d44:	0204b503          	ld	a0,32(s1)
    80005d48:	ffffc097          	auipc	ra,0xffffc
    80005d4c:	e2c080e7          	jalr	-468(ra) # 80001b74 <_Z10sem_signalP4_sem>

}
    80005d50:	01813083          	ld	ra,24(sp)
    80005d54:	01013403          	ld	s0,16(sp)
    80005d58:	00813483          	ld	s1,8(sp)
    80005d5c:	00013903          	ld	s2,0(sp)
    80005d60:	02010113          	addi	sp,sp,32
    80005d64:	00008067          	ret

0000000080005d68 <_ZN6Buffer3getEv>:

int Buffer::get() {
    80005d68:	fe010113          	addi	sp,sp,-32
    80005d6c:	00113c23          	sd	ra,24(sp)
    80005d70:	00813823          	sd	s0,16(sp)
    80005d74:	00913423          	sd	s1,8(sp)
    80005d78:	01213023          	sd	s2,0(sp)
    80005d7c:	02010413          	addi	s0,sp,32
    80005d80:	00050493          	mv	s1,a0
    sem_wait(itemAvailable);
    80005d84:	02053503          	ld	a0,32(a0)
    80005d88:	ffffc097          	auipc	ra,0xffffc
    80005d8c:	dc0080e7          	jalr	-576(ra) # 80001b48 <_Z8sem_waitP4_sem>

    sem_wait(mutexHead);
    80005d90:	0284b503          	ld	a0,40(s1)
    80005d94:	ffffc097          	auipc	ra,0xffffc
    80005d98:	db4080e7          	jalr	-588(ra) # 80001b48 <_Z8sem_waitP4_sem>

    int ret = buffer[head];
    80005d9c:	0084b703          	ld	a4,8(s1)
    80005da0:	0104a783          	lw	a5,16(s1)
    80005da4:	00279693          	slli	a3,a5,0x2
    80005da8:	00d70733          	add	a4,a4,a3
    80005dac:	00072903          	lw	s2,0(a4)
    head = (head + 1) % cap;
    80005db0:	0017879b          	addiw	a5,a5,1
    80005db4:	0004a703          	lw	a4,0(s1)
    80005db8:	02e7e7bb          	remw	a5,a5,a4
    80005dbc:	00f4a823          	sw	a5,16(s1)
    sem_signal(mutexHead);
    80005dc0:	0284b503          	ld	a0,40(s1)
    80005dc4:	ffffc097          	auipc	ra,0xffffc
    80005dc8:	db0080e7          	jalr	-592(ra) # 80001b74 <_Z10sem_signalP4_sem>

    sem_signal(spaceAvailable);
    80005dcc:	0184b503          	ld	a0,24(s1)
    80005dd0:	ffffc097          	auipc	ra,0xffffc
    80005dd4:	da4080e7          	jalr	-604(ra) # 80001b74 <_Z10sem_signalP4_sem>

    return ret;
}
    80005dd8:	00090513          	mv	a0,s2
    80005ddc:	01813083          	ld	ra,24(sp)
    80005de0:	01013403          	ld	s0,16(sp)
    80005de4:	00813483          	ld	s1,8(sp)
    80005de8:	00013903          	ld	s2,0(sp)
    80005dec:	02010113          	addi	sp,sp,32
    80005df0:	00008067          	ret

0000000080005df4 <_ZN6Buffer6getCntEv>:

int Buffer::getCnt() {
    80005df4:	fe010113          	addi	sp,sp,-32
    80005df8:	00113c23          	sd	ra,24(sp)
    80005dfc:	00813823          	sd	s0,16(sp)
    80005e00:	00913423          	sd	s1,8(sp)
    80005e04:	01213023          	sd	s2,0(sp)
    80005e08:	02010413          	addi	s0,sp,32
    80005e0c:	00050493          	mv	s1,a0
    int ret;

    sem_wait(mutexHead);
    80005e10:	02853503          	ld	a0,40(a0)
    80005e14:	ffffc097          	auipc	ra,0xffffc
    80005e18:	d34080e7          	jalr	-716(ra) # 80001b48 <_Z8sem_waitP4_sem>
    sem_wait(mutexTail);
    80005e1c:	0304b503          	ld	a0,48(s1)
    80005e20:	ffffc097          	auipc	ra,0xffffc
    80005e24:	d28080e7          	jalr	-728(ra) # 80001b48 <_Z8sem_waitP4_sem>

    if (tail >= head) {
    80005e28:	0144a783          	lw	a5,20(s1)
    80005e2c:	0104a903          	lw	s2,16(s1)
    80005e30:	0327ce63          	blt	a5,s2,80005e6c <_ZN6Buffer6getCntEv+0x78>
        ret = tail - head;
    80005e34:	4127893b          	subw	s2,a5,s2
    } else {
        ret = cap - head + tail;
    }

    sem_signal(mutexTail);
    80005e38:	0304b503          	ld	a0,48(s1)
    80005e3c:	ffffc097          	auipc	ra,0xffffc
    80005e40:	d38080e7          	jalr	-712(ra) # 80001b74 <_Z10sem_signalP4_sem>
    sem_signal(mutexHead);
    80005e44:	0284b503          	ld	a0,40(s1)
    80005e48:	ffffc097          	auipc	ra,0xffffc
    80005e4c:	d2c080e7          	jalr	-724(ra) # 80001b74 <_Z10sem_signalP4_sem>

    return ret;
}
    80005e50:	00090513          	mv	a0,s2
    80005e54:	01813083          	ld	ra,24(sp)
    80005e58:	01013403          	ld	s0,16(sp)
    80005e5c:	00813483          	ld	s1,8(sp)
    80005e60:	00013903          	ld	s2,0(sp)
    80005e64:	02010113          	addi	sp,sp,32
    80005e68:	00008067          	ret
        ret = cap - head + tail;
    80005e6c:	0004a703          	lw	a4,0(s1)
    80005e70:	4127093b          	subw	s2,a4,s2
    80005e74:	00f9093b          	addw	s2,s2,a5
    80005e78:	fc1ff06f          	j	80005e38 <_ZN6Buffer6getCntEv+0x44>

0000000080005e7c <_ZN6BufferD1Ev>:
Buffer::~Buffer() {
    80005e7c:	fe010113          	addi	sp,sp,-32
    80005e80:	00113c23          	sd	ra,24(sp)
    80005e84:	00813823          	sd	s0,16(sp)
    80005e88:	00913423          	sd	s1,8(sp)
    80005e8c:	02010413          	addi	s0,sp,32
    80005e90:	00050493          	mv	s1,a0
    putc('\n');
    80005e94:	00a00513          	li	a0,10
    80005e98:	ffffc097          	auipc	ra,0xffffc
    80005e9c:	d5c080e7          	jalr	-676(ra) # 80001bf4 <_Z4putcc>
    printString("Buffer deleted!\n");
    80005ea0:	00003517          	auipc	a0,0x3
    80005ea4:	3f850513          	addi	a0,a0,1016 # 80009298 <CONSOLE_STATUS+0x288>
    80005ea8:	fffff097          	auipc	ra,0xfffff
    80005eac:	f9c080e7          	jalr	-100(ra) # 80004e44 <_Z11printStringPKc>
    while (getCnt() > 0) {
    80005eb0:	00048513          	mv	a0,s1
    80005eb4:	00000097          	auipc	ra,0x0
    80005eb8:	f40080e7          	jalr	-192(ra) # 80005df4 <_ZN6Buffer6getCntEv>
    80005ebc:	02a05c63          	blez	a0,80005ef4 <_ZN6BufferD1Ev+0x78>
        char ch = buffer[head];
    80005ec0:	0084b783          	ld	a5,8(s1)
    80005ec4:	0104a703          	lw	a4,16(s1)
    80005ec8:	00271713          	slli	a4,a4,0x2
    80005ecc:	00e787b3          	add	a5,a5,a4
        putc(ch);
    80005ed0:	0007c503          	lbu	a0,0(a5)
    80005ed4:	ffffc097          	auipc	ra,0xffffc
    80005ed8:	d20080e7          	jalr	-736(ra) # 80001bf4 <_Z4putcc>
        head = (head + 1) % cap;
    80005edc:	0104a783          	lw	a5,16(s1)
    80005ee0:	0017879b          	addiw	a5,a5,1
    80005ee4:	0004a703          	lw	a4,0(s1)
    80005ee8:	02e7e7bb          	remw	a5,a5,a4
    80005eec:	00f4a823          	sw	a5,16(s1)
    while (getCnt() > 0) {
    80005ef0:	fc1ff06f          	j	80005eb0 <_ZN6BufferD1Ev+0x34>
    putc('!');
    80005ef4:	02100513          	li	a0,33
    80005ef8:	ffffc097          	auipc	ra,0xffffc
    80005efc:	cfc080e7          	jalr	-772(ra) # 80001bf4 <_Z4putcc>
    putc('\n');
    80005f00:	00a00513          	li	a0,10
    80005f04:	ffffc097          	auipc	ra,0xffffc
    80005f08:	cf0080e7          	jalr	-784(ra) # 80001bf4 <_Z4putcc>
    mem_free(buffer);
    80005f0c:	0084b503          	ld	a0,8(s1)
    80005f10:	ffffc097          	auipc	ra,0xffffc
    80005f14:	ad4080e7          	jalr	-1324(ra) # 800019e4 <_Z8mem_freePv>
    sem_close(itemAvailable);
    80005f18:	0204b503          	ld	a0,32(s1)
    80005f1c:	ffffc097          	auipc	ra,0xffffc
    80005f20:	c00080e7          	jalr	-1024(ra) # 80001b1c <_Z9sem_closeP4_sem>
    sem_close(spaceAvailable);
    80005f24:	0184b503          	ld	a0,24(s1)
    80005f28:	ffffc097          	auipc	ra,0xffffc
    80005f2c:	bf4080e7          	jalr	-1036(ra) # 80001b1c <_Z9sem_closeP4_sem>
    sem_close(mutexTail);
    80005f30:	0304b503          	ld	a0,48(s1)
    80005f34:	ffffc097          	auipc	ra,0xffffc
    80005f38:	be8080e7          	jalr	-1048(ra) # 80001b1c <_Z9sem_closeP4_sem>
    sem_close(mutexHead);
    80005f3c:	0284b503          	ld	a0,40(s1)
    80005f40:	ffffc097          	auipc	ra,0xffffc
    80005f44:	bdc080e7          	jalr	-1060(ra) # 80001b1c <_Z9sem_closeP4_sem>
}
    80005f48:	01813083          	ld	ra,24(sp)
    80005f4c:	01013403          	ld	s0,16(sp)
    80005f50:	00813483          	ld	s1,8(sp)
    80005f54:	02010113          	addi	sp,sp,32
    80005f58:	00008067          	ret

0000000080005f5c <start>:
    80005f5c:	ff010113          	addi	sp,sp,-16
    80005f60:	00813423          	sd	s0,8(sp)
    80005f64:	01010413          	addi	s0,sp,16
    80005f68:	300027f3          	csrr	a5,mstatus
    80005f6c:	ffffe737          	lui	a4,0xffffe
    80005f70:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ff6dc2f>
    80005f74:	00e7f7b3          	and	a5,a5,a4
    80005f78:	00001737          	lui	a4,0x1
    80005f7c:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005f80:	00e7e7b3          	or	a5,a5,a4
    80005f84:	30079073          	csrw	mstatus,a5
    80005f88:	00000797          	auipc	a5,0x0
    80005f8c:	16078793          	addi	a5,a5,352 # 800060e8 <system_main>
    80005f90:	34179073          	csrw	mepc,a5
    80005f94:	00000793          	li	a5,0
    80005f98:	18079073          	csrw	satp,a5
    80005f9c:	000107b7          	lui	a5,0x10
    80005fa0:	fff78793          	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005fa4:	30279073          	csrw	medeleg,a5
    80005fa8:	30379073          	csrw	mideleg,a5
    80005fac:	104027f3          	csrr	a5,sie
    80005fb0:	2227e793          	ori	a5,a5,546
    80005fb4:	10479073          	csrw	sie,a5
    80005fb8:	fff00793          	li	a5,-1
    80005fbc:	00a7d793          	srli	a5,a5,0xa
    80005fc0:	3b079073          	csrw	pmpaddr0,a5
    80005fc4:	00f00793          	li	a5,15
    80005fc8:	3a079073          	csrw	pmpcfg0,a5
    80005fcc:	f14027f3          	csrr	a5,mhartid
    80005fd0:	0200c737          	lui	a4,0x200c
    80005fd4:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005fd8:	0007869b          	sext.w	a3,a5
    80005fdc:	00269713          	slli	a4,a3,0x2
    80005fe0:	000f4637          	lui	a2,0xf4
    80005fe4:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005fe8:	00d70733          	add	a4,a4,a3
    80005fec:	0037979b          	slliw	a5,a5,0x3
    80005ff0:	020046b7          	lui	a3,0x2004
    80005ff4:	00d787b3          	add	a5,a5,a3
    80005ff8:	00c585b3          	add	a1,a1,a2
    80005ffc:	00371693          	slli	a3,a4,0x3
    80006000:	0008a717          	auipc	a4,0x8a
    80006004:	97070713          	addi	a4,a4,-1680 # 8008f970 <timer_scratch>
    80006008:	00b7b023          	sd	a1,0(a5)
    8000600c:	00d70733          	add	a4,a4,a3
    80006010:	00f73c23          	sd	a5,24(a4)
    80006014:	02c73023          	sd	a2,32(a4)
    80006018:	34071073          	csrw	mscratch,a4
    8000601c:	00000797          	auipc	a5,0x0
    80006020:	6e478793          	addi	a5,a5,1764 # 80006700 <timervec>
    80006024:	30579073          	csrw	mtvec,a5
    80006028:	300027f3          	csrr	a5,mstatus
    8000602c:	0087e793          	ori	a5,a5,8
    80006030:	30079073          	csrw	mstatus,a5
    80006034:	304027f3          	csrr	a5,mie
    80006038:	0807e793          	ori	a5,a5,128
    8000603c:	30479073          	csrw	mie,a5
    80006040:	f14027f3          	csrr	a5,mhartid
    80006044:	0007879b          	sext.w	a5,a5
    80006048:	00078213          	mv	tp,a5
    8000604c:	30200073          	mret
    80006050:	00813403          	ld	s0,8(sp)
    80006054:	01010113          	addi	sp,sp,16
    80006058:	00008067          	ret

000000008000605c <timerinit>:
    8000605c:	ff010113          	addi	sp,sp,-16
    80006060:	00813423          	sd	s0,8(sp)
    80006064:	01010413          	addi	s0,sp,16
    80006068:	f14027f3          	csrr	a5,mhartid
    8000606c:	0200c737          	lui	a4,0x200c
    80006070:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80006074:	0007869b          	sext.w	a3,a5
    80006078:	00269713          	slli	a4,a3,0x2
    8000607c:	000f4637          	lui	a2,0xf4
    80006080:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80006084:	00d70733          	add	a4,a4,a3
    80006088:	0037979b          	slliw	a5,a5,0x3
    8000608c:	020046b7          	lui	a3,0x2004
    80006090:	00d787b3          	add	a5,a5,a3
    80006094:	00c585b3          	add	a1,a1,a2
    80006098:	00371693          	slli	a3,a4,0x3
    8000609c:	0008a717          	auipc	a4,0x8a
    800060a0:	8d470713          	addi	a4,a4,-1836 # 8008f970 <timer_scratch>
    800060a4:	00b7b023          	sd	a1,0(a5)
    800060a8:	00d70733          	add	a4,a4,a3
    800060ac:	00f73c23          	sd	a5,24(a4)
    800060b0:	02c73023          	sd	a2,32(a4)
    800060b4:	34071073          	csrw	mscratch,a4
    800060b8:	00000797          	auipc	a5,0x0
    800060bc:	64878793          	addi	a5,a5,1608 # 80006700 <timervec>
    800060c0:	30579073          	csrw	mtvec,a5
    800060c4:	300027f3          	csrr	a5,mstatus
    800060c8:	0087e793          	ori	a5,a5,8
    800060cc:	30079073          	csrw	mstatus,a5
    800060d0:	304027f3          	csrr	a5,mie
    800060d4:	0807e793          	ori	a5,a5,128
    800060d8:	30479073          	csrw	mie,a5
    800060dc:	00813403          	ld	s0,8(sp)
    800060e0:	01010113          	addi	sp,sp,16
    800060e4:	00008067          	ret

00000000800060e8 <system_main>:
    800060e8:	fe010113          	addi	sp,sp,-32
    800060ec:	00813823          	sd	s0,16(sp)
    800060f0:	00913423          	sd	s1,8(sp)
    800060f4:	00113c23          	sd	ra,24(sp)
    800060f8:	02010413          	addi	s0,sp,32
    800060fc:	00000097          	auipc	ra,0x0
    80006100:	0c4080e7          	jalr	196(ra) # 800061c0 <cpuid>
    80006104:	00005497          	auipc	s1,0x5
    80006108:	28448493          	addi	s1,s1,644 # 8000b388 <started>
    8000610c:	02050263          	beqz	a0,80006130 <system_main+0x48>
    80006110:	0004a783          	lw	a5,0(s1)
    80006114:	0007879b          	sext.w	a5,a5
    80006118:	fe078ce3          	beqz	a5,80006110 <system_main+0x28>
    8000611c:	0ff0000f          	fence
    80006120:	00003517          	auipc	a0,0x3
    80006124:	3f850513          	addi	a0,a0,1016 # 80009518 <CONSOLE_STATUS+0x508>
    80006128:	00001097          	auipc	ra,0x1
    8000612c:	a74080e7          	jalr	-1420(ra) # 80006b9c <panic>
    80006130:	00001097          	auipc	ra,0x1
    80006134:	9c8080e7          	jalr	-1592(ra) # 80006af8 <consoleinit>
    80006138:	00001097          	auipc	ra,0x1
    8000613c:	154080e7          	jalr	340(ra) # 8000728c <printfinit>
    80006140:	00003517          	auipc	a0,0x3
    80006144:	2e050513          	addi	a0,a0,736 # 80009420 <CONSOLE_STATUS+0x410>
    80006148:	00001097          	auipc	ra,0x1
    8000614c:	ab0080e7          	jalr	-1360(ra) # 80006bf8 <__printf>
    80006150:	00003517          	auipc	a0,0x3
    80006154:	39850513          	addi	a0,a0,920 # 800094e8 <CONSOLE_STATUS+0x4d8>
    80006158:	00001097          	auipc	ra,0x1
    8000615c:	aa0080e7          	jalr	-1376(ra) # 80006bf8 <__printf>
    80006160:	00003517          	auipc	a0,0x3
    80006164:	2c050513          	addi	a0,a0,704 # 80009420 <CONSOLE_STATUS+0x410>
    80006168:	00001097          	auipc	ra,0x1
    8000616c:	a90080e7          	jalr	-1392(ra) # 80006bf8 <__printf>
    80006170:	00001097          	auipc	ra,0x1
    80006174:	4a8080e7          	jalr	1192(ra) # 80007618 <kinit>
    80006178:	00000097          	auipc	ra,0x0
    8000617c:	148080e7          	jalr	328(ra) # 800062c0 <trapinit>
    80006180:	00000097          	auipc	ra,0x0
    80006184:	16c080e7          	jalr	364(ra) # 800062ec <trapinithart>
    80006188:	00000097          	auipc	ra,0x0
    8000618c:	5b8080e7          	jalr	1464(ra) # 80006740 <plicinit>
    80006190:	00000097          	auipc	ra,0x0
    80006194:	5d8080e7          	jalr	1496(ra) # 80006768 <plicinithart>
    80006198:	00000097          	auipc	ra,0x0
    8000619c:	078080e7          	jalr	120(ra) # 80006210 <userinit>
    800061a0:	0ff0000f          	fence
    800061a4:	00100793          	li	a5,1
    800061a8:	00003517          	auipc	a0,0x3
    800061ac:	35850513          	addi	a0,a0,856 # 80009500 <CONSOLE_STATUS+0x4f0>
    800061b0:	00f4a023          	sw	a5,0(s1)
    800061b4:	00001097          	auipc	ra,0x1
    800061b8:	a44080e7          	jalr	-1468(ra) # 80006bf8 <__printf>
    800061bc:	0000006f          	j	800061bc <system_main+0xd4>

00000000800061c0 <cpuid>:
    800061c0:	ff010113          	addi	sp,sp,-16
    800061c4:	00813423          	sd	s0,8(sp)
    800061c8:	01010413          	addi	s0,sp,16
    800061cc:	00020513          	mv	a0,tp
    800061d0:	00813403          	ld	s0,8(sp)
    800061d4:	0005051b          	sext.w	a0,a0
    800061d8:	01010113          	addi	sp,sp,16
    800061dc:	00008067          	ret

00000000800061e0 <mycpu>:
    800061e0:	ff010113          	addi	sp,sp,-16
    800061e4:	00813423          	sd	s0,8(sp)
    800061e8:	01010413          	addi	s0,sp,16
    800061ec:	00020793          	mv	a5,tp
    800061f0:	00813403          	ld	s0,8(sp)
    800061f4:	0007879b          	sext.w	a5,a5
    800061f8:	00779793          	slli	a5,a5,0x7
    800061fc:	0008a517          	auipc	a0,0x8a
    80006200:	7a450513          	addi	a0,a0,1956 # 800909a0 <cpus>
    80006204:	00f50533          	add	a0,a0,a5
    80006208:	01010113          	addi	sp,sp,16
    8000620c:	00008067          	ret

0000000080006210 <userinit>:
    80006210:	ff010113          	addi	sp,sp,-16
    80006214:	00813423          	sd	s0,8(sp)
    80006218:	01010413          	addi	s0,sp,16
    8000621c:	00813403          	ld	s0,8(sp)
    80006220:	01010113          	addi	sp,sp,16
    80006224:	ffffc317          	auipc	t1,0xffffc
    80006228:	55030067          	jr	1360(t1) # 80002774 <main>

000000008000622c <either_copyout>:
    8000622c:	ff010113          	addi	sp,sp,-16
    80006230:	00813023          	sd	s0,0(sp)
    80006234:	00113423          	sd	ra,8(sp)
    80006238:	01010413          	addi	s0,sp,16
    8000623c:	02051663          	bnez	a0,80006268 <either_copyout+0x3c>
    80006240:	00058513          	mv	a0,a1
    80006244:	00060593          	mv	a1,a2
    80006248:	0006861b          	sext.w	a2,a3
    8000624c:	00002097          	auipc	ra,0x2
    80006250:	c58080e7          	jalr	-936(ra) # 80007ea4 <__memmove>
    80006254:	00813083          	ld	ra,8(sp)
    80006258:	00013403          	ld	s0,0(sp)
    8000625c:	00000513          	li	a0,0
    80006260:	01010113          	addi	sp,sp,16
    80006264:	00008067          	ret
    80006268:	00003517          	auipc	a0,0x3
    8000626c:	2d850513          	addi	a0,a0,728 # 80009540 <CONSOLE_STATUS+0x530>
    80006270:	00001097          	auipc	ra,0x1
    80006274:	92c080e7          	jalr	-1748(ra) # 80006b9c <panic>

0000000080006278 <either_copyin>:
    80006278:	ff010113          	addi	sp,sp,-16
    8000627c:	00813023          	sd	s0,0(sp)
    80006280:	00113423          	sd	ra,8(sp)
    80006284:	01010413          	addi	s0,sp,16
    80006288:	02059463          	bnez	a1,800062b0 <either_copyin+0x38>
    8000628c:	00060593          	mv	a1,a2
    80006290:	0006861b          	sext.w	a2,a3
    80006294:	00002097          	auipc	ra,0x2
    80006298:	c10080e7          	jalr	-1008(ra) # 80007ea4 <__memmove>
    8000629c:	00813083          	ld	ra,8(sp)
    800062a0:	00013403          	ld	s0,0(sp)
    800062a4:	00000513          	li	a0,0
    800062a8:	01010113          	addi	sp,sp,16
    800062ac:	00008067          	ret
    800062b0:	00003517          	auipc	a0,0x3
    800062b4:	2b850513          	addi	a0,a0,696 # 80009568 <CONSOLE_STATUS+0x558>
    800062b8:	00001097          	auipc	ra,0x1
    800062bc:	8e4080e7          	jalr	-1820(ra) # 80006b9c <panic>

00000000800062c0 <trapinit>:
    800062c0:	ff010113          	addi	sp,sp,-16
    800062c4:	00813423          	sd	s0,8(sp)
    800062c8:	01010413          	addi	s0,sp,16
    800062cc:	00813403          	ld	s0,8(sp)
    800062d0:	00003597          	auipc	a1,0x3
    800062d4:	2c058593          	addi	a1,a1,704 # 80009590 <CONSOLE_STATUS+0x580>
    800062d8:	0008a517          	auipc	a0,0x8a
    800062dc:	74850513          	addi	a0,a0,1864 # 80090a20 <tickslock>
    800062e0:	01010113          	addi	sp,sp,16
    800062e4:	00001317          	auipc	t1,0x1
    800062e8:	5c430067          	jr	1476(t1) # 800078a8 <initlock>

00000000800062ec <trapinithart>:
    800062ec:	ff010113          	addi	sp,sp,-16
    800062f0:	00813423          	sd	s0,8(sp)
    800062f4:	01010413          	addi	s0,sp,16
    800062f8:	00000797          	auipc	a5,0x0
    800062fc:	2f878793          	addi	a5,a5,760 # 800065f0 <kernelvec>
    80006300:	10579073          	csrw	stvec,a5
    80006304:	00813403          	ld	s0,8(sp)
    80006308:	01010113          	addi	sp,sp,16
    8000630c:	00008067          	ret

0000000080006310 <usertrap>:
    80006310:	ff010113          	addi	sp,sp,-16
    80006314:	00813423          	sd	s0,8(sp)
    80006318:	01010413          	addi	s0,sp,16
    8000631c:	00813403          	ld	s0,8(sp)
    80006320:	01010113          	addi	sp,sp,16
    80006324:	00008067          	ret

0000000080006328 <usertrapret>:
    80006328:	ff010113          	addi	sp,sp,-16
    8000632c:	00813423          	sd	s0,8(sp)
    80006330:	01010413          	addi	s0,sp,16
    80006334:	00813403          	ld	s0,8(sp)
    80006338:	01010113          	addi	sp,sp,16
    8000633c:	00008067          	ret

0000000080006340 <kerneltrap>:
    80006340:	fe010113          	addi	sp,sp,-32
    80006344:	00813823          	sd	s0,16(sp)
    80006348:	00113c23          	sd	ra,24(sp)
    8000634c:	00913423          	sd	s1,8(sp)
    80006350:	02010413          	addi	s0,sp,32
    80006354:	142025f3          	csrr	a1,scause
    80006358:	100027f3          	csrr	a5,sstatus
    8000635c:	0027f793          	andi	a5,a5,2
    80006360:	10079c63          	bnez	a5,80006478 <kerneltrap+0x138>
    80006364:	142027f3          	csrr	a5,scause
    80006368:	0207ce63          	bltz	a5,800063a4 <kerneltrap+0x64>
    8000636c:	00003517          	auipc	a0,0x3
    80006370:	26c50513          	addi	a0,a0,620 # 800095d8 <CONSOLE_STATUS+0x5c8>
    80006374:	00001097          	auipc	ra,0x1
    80006378:	884080e7          	jalr	-1916(ra) # 80006bf8 <__printf>
    8000637c:	141025f3          	csrr	a1,sepc
    80006380:	14302673          	csrr	a2,stval
    80006384:	00003517          	auipc	a0,0x3
    80006388:	26450513          	addi	a0,a0,612 # 800095e8 <CONSOLE_STATUS+0x5d8>
    8000638c:	00001097          	auipc	ra,0x1
    80006390:	86c080e7          	jalr	-1940(ra) # 80006bf8 <__printf>
    80006394:	00003517          	auipc	a0,0x3
    80006398:	26c50513          	addi	a0,a0,620 # 80009600 <CONSOLE_STATUS+0x5f0>
    8000639c:	00001097          	auipc	ra,0x1
    800063a0:	800080e7          	jalr	-2048(ra) # 80006b9c <panic>
    800063a4:	0ff7f713          	andi	a4,a5,255
    800063a8:	00900693          	li	a3,9
    800063ac:	04d70063          	beq	a4,a3,800063ec <kerneltrap+0xac>
    800063b0:	fff00713          	li	a4,-1
    800063b4:	03f71713          	slli	a4,a4,0x3f
    800063b8:	00170713          	addi	a4,a4,1
    800063bc:	fae798e3          	bne	a5,a4,8000636c <kerneltrap+0x2c>
    800063c0:	00000097          	auipc	ra,0x0
    800063c4:	e00080e7          	jalr	-512(ra) # 800061c0 <cpuid>
    800063c8:	06050663          	beqz	a0,80006434 <kerneltrap+0xf4>
    800063cc:	144027f3          	csrr	a5,sip
    800063d0:	ffd7f793          	andi	a5,a5,-3
    800063d4:	14479073          	csrw	sip,a5
    800063d8:	01813083          	ld	ra,24(sp)
    800063dc:	01013403          	ld	s0,16(sp)
    800063e0:	00813483          	ld	s1,8(sp)
    800063e4:	02010113          	addi	sp,sp,32
    800063e8:	00008067          	ret
    800063ec:	00000097          	auipc	ra,0x0
    800063f0:	3c8080e7          	jalr	968(ra) # 800067b4 <plic_claim>
    800063f4:	00a00793          	li	a5,10
    800063f8:	00050493          	mv	s1,a0
    800063fc:	06f50863          	beq	a0,a5,8000646c <kerneltrap+0x12c>
    80006400:	fc050ce3          	beqz	a0,800063d8 <kerneltrap+0x98>
    80006404:	00050593          	mv	a1,a0
    80006408:	00003517          	auipc	a0,0x3
    8000640c:	1b050513          	addi	a0,a0,432 # 800095b8 <CONSOLE_STATUS+0x5a8>
    80006410:	00000097          	auipc	ra,0x0
    80006414:	7e8080e7          	jalr	2024(ra) # 80006bf8 <__printf>
    80006418:	01013403          	ld	s0,16(sp)
    8000641c:	01813083          	ld	ra,24(sp)
    80006420:	00048513          	mv	a0,s1
    80006424:	00813483          	ld	s1,8(sp)
    80006428:	02010113          	addi	sp,sp,32
    8000642c:	00000317          	auipc	t1,0x0
    80006430:	3c030067          	jr	960(t1) # 800067ec <plic_complete>
    80006434:	0008a517          	auipc	a0,0x8a
    80006438:	5ec50513          	addi	a0,a0,1516 # 80090a20 <tickslock>
    8000643c:	00001097          	auipc	ra,0x1
    80006440:	490080e7          	jalr	1168(ra) # 800078cc <acquire>
    80006444:	00005717          	auipc	a4,0x5
    80006448:	f4870713          	addi	a4,a4,-184 # 8000b38c <ticks>
    8000644c:	00072783          	lw	a5,0(a4)
    80006450:	0008a517          	auipc	a0,0x8a
    80006454:	5d050513          	addi	a0,a0,1488 # 80090a20 <tickslock>
    80006458:	0017879b          	addiw	a5,a5,1
    8000645c:	00f72023          	sw	a5,0(a4)
    80006460:	00001097          	auipc	ra,0x1
    80006464:	538080e7          	jalr	1336(ra) # 80007998 <release>
    80006468:	f65ff06f          	j	800063cc <kerneltrap+0x8c>
    8000646c:	00001097          	auipc	ra,0x1
    80006470:	094080e7          	jalr	148(ra) # 80007500 <uartintr>
    80006474:	fa5ff06f          	j	80006418 <kerneltrap+0xd8>
    80006478:	00003517          	auipc	a0,0x3
    8000647c:	12050513          	addi	a0,a0,288 # 80009598 <CONSOLE_STATUS+0x588>
    80006480:	00000097          	auipc	ra,0x0
    80006484:	71c080e7          	jalr	1820(ra) # 80006b9c <panic>

0000000080006488 <clockintr>:
    80006488:	fe010113          	addi	sp,sp,-32
    8000648c:	00813823          	sd	s0,16(sp)
    80006490:	00913423          	sd	s1,8(sp)
    80006494:	00113c23          	sd	ra,24(sp)
    80006498:	02010413          	addi	s0,sp,32
    8000649c:	0008a497          	auipc	s1,0x8a
    800064a0:	58448493          	addi	s1,s1,1412 # 80090a20 <tickslock>
    800064a4:	00048513          	mv	a0,s1
    800064a8:	00001097          	auipc	ra,0x1
    800064ac:	424080e7          	jalr	1060(ra) # 800078cc <acquire>
    800064b0:	00005717          	auipc	a4,0x5
    800064b4:	edc70713          	addi	a4,a4,-292 # 8000b38c <ticks>
    800064b8:	00072783          	lw	a5,0(a4)
    800064bc:	01013403          	ld	s0,16(sp)
    800064c0:	01813083          	ld	ra,24(sp)
    800064c4:	00048513          	mv	a0,s1
    800064c8:	0017879b          	addiw	a5,a5,1
    800064cc:	00813483          	ld	s1,8(sp)
    800064d0:	00f72023          	sw	a5,0(a4)
    800064d4:	02010113          	addi	sp,sp,32
    800064d8:	00001317          	auipc	t1,0x1
    800064dc:	4c030067          	jr	1216(t1) # 80007998 <release>

00000000800064e0 <devintr>:
    800064e0:	142027f3          	csrr	a5,scause
    800064e4:	00000513          	li	a0,0
    800064e8:	0007c463          	bltz	a5,800064f0 <devintr+0x10>
    800064ec:	00008067          	ret
    800064f0:	fe010113          	addi	sp,sp,-32
    800064f4:	00813823          	sd	s0,16(sp)
    800064f8:	00113c23          	sd	ra,24(sp)
    800064fc:	00913423          	sd	s1,8(sp)
    80006500:	02010413          	addi	s0,sp,32
    80006504:	0ff7f713          	andi	a4,a5,255
    80006508:	00900693          	li	a3,9
    8000650c:	04d70c63          	beq	a4,a3,80006564 <devintr+0x84>
    80006510:	fff00713          	li	a4,-1
    80006514:	03f71713          	slli	a4,a4,0x3f
    80006518:	00170713          	addi	a4,a4,1
    8000651c:	00e78c63          	beq	a5,a4,80006534 <devintr+0x54>
    80006520:	01813083          	ld	ra,24(sp)
    80006524:	01013403          	ld	s0,16(sp)
    80006528:	00813483          	ld	s1,8(sp)
    8000652c:	02010113          	addi	sp,sp,32
    80006530:	00008067          	ret
    80006534:	00000097          	auipc	ra,0x0
    80006538:	c8c080e7          	jalr	-884(ra) # 800061c0 <cpuid>
    8000653c:	06050663          	beqz	a0,800065a8 <devintr+0xc8>
    80006540:	144027f3          	csrr	a5,sip
    80006544:	ffd7f793          	andi	a5,a5,-3
    80006548:	14479073          	csrw	sip,a5
    8000654c:	01813083          	ld	ra,24(sp)
    80006550:	01013403          	ld	s0,16(sp)
    80006554:	00813483          	ld	s1,8(sp)
    80006558:	00200513          	li	a0,2
    8000655c:	02010113          	addi	sp,sp,32
    80006560:	00008067          	ret
    80006564:	00000097          	auipc	ra,0x0
    80006568:	250080e7          	jalr	592(ra) # 800067b4 <plic_claim>
    8000656c:	00a00793          	li	a5,10
    80006570:	00050493          	mv	s1,a0
    80006574:	06f50663          	beq	a0,a5,800065e0 <devintr+0x100>
    80006578:	00100513          	li	a0,1
    8000657c:	fa0482e3          	beqz	s1,80006520 <devintr+0x40>
    80006580:	00048593          	mv	a1,s1
    80006584:	00003517          	auipc	a0,0x3
    80006588:	03450513          	addi	a0,a0,52 # 800095b8 <CONSOLE_STATUS+0x5a8>
    8000658c:	00000097          	auipc	ra,0x0
    80006590:	66c080e7          	jalr	1644(ra) # 80006bf8 <__printf>
    80006594:	00048513          	mv	a0,s1
    80006598:	00000097          	auipc	ra,0x0
    8000659c:	254080e7          	jalr	596(ra) # 800067ec <plic_complete>
    800065a0:	00100513          	li	a0,1
    800065a4:	f7dff06f          	j	80006520 <devintr+0x40>
    800065a8:	0008a517          	auipc	a0,0x8a
    800065ac:	47850513          	addi	a0,a0,1144 # 80090a20 <tickslock>
    800065b0:	00001097          	auipc	ra,0x1
    800065b4:	31c080e7          	jalr	796(ra) # 800078cc <acquire>
    800065b8:	00005717          	auipc	a4,0x5
    800065bc:	dd470713          	addi	a4,a4,-556 # 8000b38c <ticks>
    800065c0:	00072783          	lw	a5,0(a4)
    800065c4:	0008a517          	auipc	a0,0x8a
    800065c8:	45c50513          	addi	a0,a0,1116 # 80090a20 <tickslock>
    800065cc:	0017879b          	addiw	a5,a5,1
    800065d0:	00f72023          	sw	a5,0(a4)
    800065d4:	00001097          	auipc	ra,0x1
    800065d8:	3c4080e7          	jalr	964(ra) # 80007998 <release>
    800065dc:	f65ff06f          	j	80006540 <devintr+0x60>
    800065e0:	00001097          	auipc	ra,0x1
    800065e4:	f20080e7          	jalr	-224(ra) # 80007500 <uartintr>
    800065e8:	fadff06f          	j	80006594 <devintr+0xb4>
    800065ec:	0000                	unimp
	...

00000000800065f0 <kernelvec>:
    800065f0:	f0010113          	addi	sp,sp,-256
    800065f4:	00113023          	sd	ra,0(sp)
    800065f8:	00213423          	sd	sp,8(sp)
    800065fc:	00313823          	sd	gp,16(sp)
    80006600:	00413c23          	sd	tp,24(sp)
    80006604:	02513023          	sd	t0,32(sp)
    80006608:	02613423          	sd	t1,40(sp)
    8000660c:	02713823          	sd	t2,48(sp)
    80006610:	02813c23          	sd	s0,56(sp)
    80006614:	04913023          	sd	s1,64(sp)
    80006618:	04a13423          	sd	a0,72(sp)
    8000661c:	04b13823          	sd	a1,80(sp)
    80006620:	04c13c23          	sd	a2,88(sp)
    80006624:	06d13023          	sd	a3,96(sp)
    80006628:	06e13423          	sd	a4,104(sp)
    8000662c:	06f13823          	sd	a5,112(sp)
    80006630:	07013c23          	sd	a6,120(sp)
    80006634:	09113023          	sd	a7,128(sp)
    80006638:	09213423          	sd	s2,136(sp)
    8000663c:	09313823          	sd	s3,144(sp)
    80006640:	09413c23          	sd	s4,152(sp)
    80006644:	0b513023          	sd	s5,160(sp)
    80006648:	0b613423          	sd	s6,168(sp)
    8000664c:	0b713823          	sd	s7,176(sp)
    80006650:	0b813c23          	sd	s8,184(sp)
    80006654:	0d913023          	sd	s9,192(sp)
    80006658:	0da13423          	sd	s10,200(sp)
    8000665c:	0db13823          	sd	s11,208(sp)
    80006660:	0dc13c23          	sd	t3,216(sp)
    80006664:	0fd13023          	sd	t4,224(sp)
    80006668:	0fe13423          	sd	t5,232(sp)
    8000666c:	0ff13823          	sd	t6,240(sp)
    80006670:	cd1ff0ef          	jal	ra,80006340 <kerneltrap>
    80006674:	00013083          	ld	ra,0(sp)
    80006678:	00813103          	ld	sp,8(sp)
    8000667c:	01013183          	ld	gp,16(sp)
    80006680:	02013283          	ld	t0,32(sp)
    80006684:	02813303          	ld	t1,40(sp)
    80006688:	03013383          	ld	t2,48(sp)
    8000668c:	03813403          	ld	s0,56(sp)
    80006690:	04013483          	ld	s1,64(sp)
    80006694:	04813503          	ld	a0,72(sp)
    80006698:	05013583          	ld	a1,80(sp)
    8000669c:	05813603          	ld	a2,88(sp)
    800066a0:	06013683          	ld	a3,96(sp)
    800066a4:	06813703          	ld	a4,104(sp)
    800066a8:	07013783          	ld	a5,112(sp)
    800066ac:	07813803          	ld	a6,120(sp)
    800066b0:	08013883          	ld	a7,128(sp)
    800066b4:	08813903          	ld	s2,136(sp)
    800066b8:	09013983          	ld	s3,144(sp)
    800066bc:	09813a03          	ld	s4,152(sp)
    800066c0:	0a013a83          	ld	s5,160(sp)
    800066c4:	0a813b03          	ld	s6,168(sp)
    800066c8:	0b013b83          	ld	s7,176(sp)
    800066cc:	0b813c03          	ld	s8,184(sp)
    800066d0:	0c013c83          	ld	s9,192(sp)
    800066d4:	0c813d03          	ld	s10,200(sp)
    800066d8:	0d013d83          	ld	s11,208(sp)
    800066dc:	0d813e03          	ld	t3,216(sp)
    800066e0:	0e013e83          	ld	t4,224(sp)
    800066e4:	0e813f03          	ld	t5,232(sp)
    800066e8:	0f013f83          	ld	t6,240(sp)
    800066ec:	10010113          	addi	sp,sp,256
    800066f0:	10200073          	sret
    800066f4:	00000013          	nop
    800066f8:	00000013          	nop
    800066fc:	00000013          	nop

0000000080006700 <timervec>:
    80006700:	34051573          	csrrw	a0,mscratch,a0
    80006704:	00b53023          	sd	a1,0(a0)
    80006708:	00c53423          	sd	a2,8(a0)
    8000670c:	00d53823          	sd	a3,16(a0)
    80006710:	01853583          	ld	a1,24(a0)
    80006714:	02053603          	ld	a2,32(a0)
    80006718:	0005b683          	ld	a3,0(a1)
    8000671c:	00c686b3          	add	a3,a3,a2
    80006720:	00d5b023          	sd	a3,0(a1)
    80006724:	00200593          	li	a1,2
    80006728:	14459073          	csrw	sip,a1
    8000672c:	01053683          	ld	a3,16(a0)
    80006730:	00853603          	ld	a2,8(a0)
    80006734:	00053583          	ld	a1,0(a0)
    80006738:	34051573          	csrrw	a0,mscratch,a0
    8000673c:	30200073          	mret

0000000080006740 <plicinit>:
    80006740:	ff010113          	addi	sp,sp,-16
    80006744:	00813423          	sd	s0,8(sp)
    80006748:	01010413          	addi	s0,sp,16
    8000674c:	00813403          	ld	s0,8(sp)
    80006750:	0c0007b7          	lui	a5,0xc000
    80006754:	00100713          	li	a4,1
    80006758:	02e7a423          	sw	a4,40(a5) # c000028 <_entry-0x73ffffd8>
    8000675c:	00e7a223          	sw	a4,4(a5)
    80006760:	01010113          	addi	sp,sp,16
    80006764:	00008067          	ret

0000000080006768 <plicinithart>:
    80006768:	ff010113          	addi	sp,sp,-16
    8000676c:	00813023          	sd	s0,0(sp)
    80006770:	00113423          	sd	ra,8(sp)
    80006774:	01010413          	addi	s0,sp,16
    80006778:	00000097          	auipc	ra,0x0
    8000677c:	a48080e7          	jalr	-1464(ra) # 800061c0 <cpuid>
    80006780:	0085171b          	slliw	a4,a0,0x8
    80006784:	0c0027b7          	lui	a5,0xc002
    80006788:	00e787b3          	add	a5,a5,a4
    8000678c:	40200713          	li	a4,1026
    80006790:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>
    80006794:	00813083          	ld	ra,8(sp)
    80006798:	00013403          	ld	s0,0(sp)
    8000679c:	00d5151b          	slliw	a0,a0,0xd
    800067a0:	0c2017b7          	lui	a5,0xc201
    800067a4:	00a78533          	add	a0,a5,a0
    800067a8:	00052023          	sw	zero,0(a0)
    800067ac:	01010113          	addi	sp,sp,16
    800067b0:	00008067          	ret

00000000800067b4 <plic_claim>:
    800067b4:	ff010113          	addi	sp,sp,-16
    800067b8:	00813023          	sd	s0,0(sp)
    800067bc:	00113423          	sd	ra,8(sp)
    800067c0:	01010413          	addi	s0,sp,16
    800067c4:	00000097          	auipc	ra,0x0
    800067c8:	9fc080e7          	jalr	-1540(ra) # 800061c0 <cpuid>
    800067cc:	00813083          	ld	ra,8(sp)
    800067d0:	00013403          	ld	s0,0(sp)
    800067d4:	00d5151b          	slliw	a0,a0,0xd
    800067d8:	0c2017b7          	lui	a5,0xc201
    800067dc:	00a78533          	add	a0,a5,a0
    800067e0:	00452503          	lw	a0,4(a0)
    800067e4:	01010113          	addi	sp,sp,16
    800067e8:	00008067          	ret

00000000800067ec <plic_complete>:
    800067ec:	fe010113          	addi	sp,sp,-32
    800067f0:	00813823          	sd	s0,16(sp)
    800067f4:	00913423          	sd	s1,8(sp)
    800067f8:	00113c23          	sd	ra,24(sp)
    800067fc:	02010413          	addi	s0,sp,32
    80006800:	00050493          	mv	s1,a0
    80006804:	00000097          	auipc	ra,0x0
    80006808:	9bc080e7          	jalr	-1604(ra) # 800061c0 <cpuid>
    8000680c:	01813083          	ld	ra,24(sp)
    80006810:	01013403          	ld	s0,16(sp)
    80006814:	00d5179b          	slliw	a5,a0,0xd
    80006818:	0c201737          	lui	a4,0xc201
    8000681c:	00f707b3          	add	a5,a4,a5
    80006820:	0097a223          	sw	s1,4(a5) # c201004 <_entry-0x73dfeffc>
    80006824:	00813483          	ld	s1,8(sp)
    80006828:	02010113          	addi	sp,sp,32
    8000682c:	00008067          	ret

0000000080006830 <consolewrite>:
    80006830:	fb010113          	addi	sp,sp,-80
    80006834:	04813023          	sd	s0,64(sp)
    80006838:	04113423          	sd	ra,72(sp)
    8000683c:	02913c23          	sd	s1,56(sp)
    80006840:	03213823          	sd	s2,48(sp)
    80006844:	03313423          	sd	s3,40(sp)
    80006848:	03413023          	sd	s4,32(sp)
    8000684c:	01513c23          	sd	s5,24(sp)
    80006850:	05010413          	addi	s0,sp,80
    80006854:	06c05c63          	blez	a2,800068cc <consolewrite+0x9c>
    80006858:	00060993          	mv	s3,a2
    8000685c:	00050a13          	mv	s4,a0
    80006860:	00058493          	mv	s1,a1
    80006864:	00000913          	li	s2,0
    80006868:	fff00a93          	li	s5,-1
    8000686c:	01c0006f          	j	80006888 <consolewrite+0x58>
    80006870:	fbf44503          	lbu	a0,-65(s0)
    80006874:	0019091b          	addiw	s2,s2,1
    80006878:	00148493          	addi	s1,s1,1
    8000687c:	00001097          	auipc	ra,0x1
    80006880:	a9c080e7          	jalr	-1380(ra) # 80007318 <uartputc>
    80006884:	03298063          	beq	s3,s2,800068a4 <consolewrite+0x74>
    80006888:	00048613          	mv	a2,s1
    8000688c:	00100693          	li	a3,1
    80006890:	000a0593          	mv	a1,s4
    80006894:	fbf40513          	addi	a0,s0,-65
    80006898:	00000097          	auipc	ra,0x0
    8000689c:	9e0080e7          	jalr	-1568(ra) # 80006278 <either_copyin>
    800068a0:	fd5518e3          	bne	a0,s5,80006870 <consolewrite+0x40>
    800068a4:	04813083          	ld	ra,72(sp)
    800068a8:	04013403          	ld	s0,64(sp)
    800068ac:	03813483          	ld	s1,56(sp)
    800068b0:	02813983          	ld	s3,40(sp)
    800068b4:	02013a03          	ld	s4,32(sp)
    800068b8:	01813a83          	ld	s5,24(sp)
    800068bc:	00090513          	mv	a0,s2
    800068c0:	03013903          	ld	s2,48(sp)
    800068c4:	05010113          	addi	sp,sp,80
    800068c8:	00008067          	ret
    800068cc:	00000913          	li	s2,0
    800068d0:	fd5ff06f          	j	800068a4 <consolewrite+0x74>

00000000800068d4 <consoleread>:
    800068d4:	f9010113          	addi	sp,sp,-112
    800068d8:	06813023          	sd	s0,96(sp)
    800068dc:	04913c23          	sd	s1,88(sp)
    800068e0:	05213823          	sd	s2,80(sp)
    800068e4:	05313423          	sd	s3,72(sp)
    800068e8:	05413023          	sd	s4,64(sp)
    800068ec:	03513c23          	sd	s5,56(sp)
    800068f0:	03613823          	sd	s6,48(sp)
    800068f4:	03713423          	sd	s7,40(sp)
    800068f8:	03813023          	sd	s8,32(sp)
    800068fc:	06113423          	sd	ra,104(sp)
    80006900:	01913c23          	sd	s9,24(sp)
    80006904:	07010413          	addi	s0,sp,112
    80006908:	00060b93          	mv	s7,a2
    8000690c:	00050913          	mv	s2,a0
    80006910:	00058c13          	mv	s8,a1
    80006914:	00060b1b          	sext.w	s6,a2
    80006918:	0008a497          	auipc	s1,0x8a
    8000691c:	13048493          	addi	s1,s1,304 # 80090a48 <cons>
    80006920:	00400993          	li	s3,4
    80006924:	fff00a13          	li	s4,-1
    80006928:	00a00a93          	li	s5,10
    8000692c:	05705e63          	blez	s7,80006988 <consoleread+0xb4>
    80006930:	09c4a703          	lw	a4,156(s1)
    80006934:	0984a783          	lw	a5,152(s1)
    80006938:	0007071b          	sext.w	a4,a4
    8000693c:	08e78463          	beq	a5,a4,800069c4 <consoleread+0xf0>
    80006940:	07f7f713          	andi	a4,a5,127
    80006944:	00e48733          	add	a4,s1,a4
    80006948:	01874703          	lbu	a4,24(a4) # c201018 <_entry-0x73dfefe8>
    8000694c:	0017869b          	addiw	a3,a5,1
    80006950:	08d4ac23          	sw	a3,152(s1)
    80006954:	00070c9b          	sext.w	s9,a4
    80006958:	0b370663          	beq	a4,s3,80006a04 <consoleread+0x130>
    8000695c:	00100693          	li	a3,1
    80006960:	f9f40613          	addi	a2,s0,-97
    80006964:	000c0593          	mv	a1,s8
    80006968:	00090513          	mv	a0,s2
    8000696c:	f8e40fa3          	sb	a4,-97(s0)
    80006970:	00000097          	auipc	ra,0x0
    80006974:	8bc080e7          	jalr	-1860(ra) # 8000622c <either_copyout>
    80006978:	01450863          	beq	a0,s4,80006988 <consoleread+0xb4>
    8000697c:	001c0c13          	addi	s8,s8,1
    80006980:	fffb8b9b          	addiw	s7,s7,-1
    80006984:	fb5c94e3          	bne	s9,s5,8000692c <consoleread+0x58>
    80006988:	000b851b          	sext.w	a0,s7
    8000698c:	06813083          	ld	ra,104(sp)
    80006990:	06013403          	ld	s0,96(sp)
    80006994:	05813483          	ld	s1,88(sp)
    80006998:	05013903          	ld	s2,80(sp)
    8000699c:	04813983          	ld	s3,72(sp)
    800069a0:	04013a03          	ld	s4,64(sp)
    800069a4:	03813a83          	ld	s5,56(sp)
    800069a8:	02813b83          	ld	s7,40(sp)
    800069ac:	02013c03          	ld	s8,32(sp)
    800069b0:	01813c83          	ld	s9,24(sp)
    800069b4:	40ab053b          	subw	a0,s6,a0
    800069b8:	03013b03          	ld	s6,48(sp)
    800069bc:	07010113          	addi	sp,sp,112
    800069c0:	00008067          	ret
    800069c4:	00001097          	auipc	ra,0x1
    800069c8:	1d8080e7          	jalr	472(ra) # 80007b9c <push_on>
    800069cc:	0984a703          	lw	a4,152(s1)
    800069d0:	09c4a783          	lw	a5,156(s1)
    800069d4:	0007879b          	sext.w	a5,a5
    800069d8:	fef70ce3          	beq	a4,a5,800069d0 <consoleread+0xfc>
    800069dc:	00001097          	auipc	ra,0x1
    800069e0:	234080e7          	jalr	564(ra) # 80007c10 <pop_on>
    800069e4:	0984a783          	lw	a5,152(s1)
    800069e8:	07f7f713          	andi	a4,a5,127
    800069ec:	00e48733          	add	a4,s1,a4
    800069f0:	01874703          	lbu	a4,24(a4)
    800069f4:	0017869b          	addiw	a3,a5,1
    800069f8:	08d4ac23          	sw	a3,152(s1)
    800069fc:	00070c9b          	sext.w	s9,a4
    80006a00:	f5371ee3          	bne	a4,s3,8000695c <consoleread+0x88>
    80006a04:	000b851b          	sext.w	a0,s7
    80006a08:	f96bf2e3          	bgeu	s7,s6,8000698c <consoleread+0xb8>
    80006a0c:	08f4ac23          	sw	a5,152(s1)
    80006a10:	f7dff06f          	j	8000698c <consoleread+0xb8>

0000000080006a14 <consputc>:
    80006a14:	10000793          	li	a5,256
    80006a18:	00f50663          	beq	a0,a5,80006a24 <consputc+0x10>
    80006a1c:	00001317          	auipc	t1,0x1
    80006a20:	9f430067          	jr	-1548(t1) # 80007410 <uartputc_sync>
    80006a24:	ff010113          	addi	sp,sp,-16
    80006a28:	00113423          	sd	ra,8(sp)
    80006a2c:	00813023          	sd	s0,0(sp)
    80006a30:	01010413          	addi	s0,sp,16
    80006a34:	00800513          	li	a0,8
    80006a38:	00001097          	auipc	ra,0x1
    80006a3c:	9d8080e7          	jalr	-1576(ra) # 80007410 <uartputc_sync>
    80006a40:	02000513          	li	a0,32
    80006a44:	00001097          	auipc	ra,0x1
    80006a48:	9cc080e7          	jalr	-1588(ra) # 80007410 <uartputc_sync>
    80006a4c:	00013403          	ld	s0,0(sp)
    80006a50:	00813083          	ld	ra,8(sp)
    80006a54:	00800513          	li	a0,8
    80006a58:	01010113          	addi	sp,sp,16
    80006a5c:	00001317          	auipc	t1,0x1
    80006a60:	9b430067          	jr	-1612(t1) # 80007410 <uartputc_sync>

0000000080006a64 <consoleintr>:
    80006a64:	fe010113          	addi	sp,sp,-32
    80006a68:	00813823          	sd	s0,16(sp)
    80006a6c:	00913423          	sd	s1,8(sp)
    80006a70:	01213023          	sd	s2,0(sp)
    80006a74:	00113c23          	sd	ra,24(sp)
    80006a78:	02010413          	addi	s0,sp,32
    80006a7c:	0008a917          	auipc	s2,0x8a
    80006a80:	fcc90913          	addi	s2,s2,-52 # 80090a48 <cons>
    80006a84:	00050493          	mv	s1,a0
    80006a88:	00090513          	mv	a0,s2
    80006a8c:	00001097          	auipc	ra,0x1
    80006a90:	e40080e7          	jalr	-448(ra) # 800078cc <acquire>
    80006a94:	02048c63          	beqz	s1,80006acc <consoleintr+0x68>
    80006a98:	0a092783          	lw	a5,160(s2)
    80006a9c:	09892703          	lw	a4,152(s2)
    80006aa0:	07f00693          	li	a3,127
    80006aa4:	40e7873b          	subw	a4,a5,a4
    80006aa8:	02e6e263          	bltu	a3,a4,80006acc <consoleintr+0x68>
    80006aac:	00d00713          	li	a4,13
    80006ab0:	04e48063          	beq	s1,a4,80006af0 <consoleintr+0x8c>
    80006ab4:	07f7f713          	andi	a4,a5,127
    80006ab8:	00e90733          	add	a4,s2,a4
    80006abc:	0017879b          	addiw	a5,a5,1
    80006ac0:	0af92023          	sw	a5,160(s2)
    80006ac4:	00970c23          	sb	s1,24(a4)
    80006ac8:	08f92e23          	sw	a5,156(s2)
    80006acc:	01013403          	ld	s0,16(sp)
    80006ad0:	01813083          	ld	ra,24(sp)
    80006ad4:	00813483          	ld	s1,8(sp)
    80006ad8:	00013903          	ld	s2,0(sp)
    80006adc:	0008a517          	auipc	a0,0x8a
    80006ae0:	f6c50513          	addi	a0,a0,-148 # 80090a48 <cons>
    80006ae4:	02010113          	addi	sp,sp,32
    80006ae8:	00001317          	auipc	t1,0x1
    80006aec:	eb030067          	jr	-336(t1) # 80007998 <release>
    80006af0:	00a00493          	li	s1,10
    80006af4:	fc1ff06f          	j	80006ab4 <consoleintr+0x50>

0000000080006af8 <consoleinit>:
    80006af8:	fe010113          	addi	sp,sp,-32
    80006afc:	00113c23          	sd	ra,24(sp)
    80006b00:	00813823          	sd	s0,16(sp)
    80006b04:	00913423          	sd	s1,8(sp)
    80006b08:	02010413          	addi	s0,sp,32
    80006b0c:	0008a497          	auipc	s1,0x8a
    80006b10:	f3c48493          	addi	s1,s1,-196 # 80090a48 <cons>
    80006b14:	00048513          	mv	a0,s1
    80006b18:	00003597          	auipc	a1,0x3
    80006b1c:	af858593          	addi	a1,a1,-1288 # 80009610 <CONSOLE_STATUS+0x600>
    80006b20:	00001097          	auipc	ra,0x1
    80006b24:	d88080e7          	jalr	-632(ra) # 800078a8 <initlock>
    80006b28:	00000097          	auipc	ra,0x0
    80006b2c:	7ac080e7          	jalr	1964(ra) # 800072d4 <uartinit>
    80006b30:	01813083          	ld	ra,24(sp)
    80006b34:	01013403          	ld	s0,16(sp)
    80006b38:	00000797          	auipc	a5,0x0
    80006b3c:	d9c78793          	addi	a5,a5,-612 # 800068d4 <consoleread>
    80006b40:	0af4bc23          	sd	a5,184(s1)
    80006b44:	00000797          	auipc	a5,0x0
    80006b48:	cec78793          	addi	a5,a5,-788 # 80006830 <consolewrite>
    80006b4c:	0cf4b023          	sd	a5,192(s1)
    80006b50:	00813483          	ld	s1,8(sp)
    80006b54:	02010113          	addi	sp,sp,32
    80006b58:	00008067          	ret

0000000080006b5c <console_read>:
    80006b5c:	ff010113          	addi	sp,sp,-16
    80006b60:	00813423          	sd	s0,8(sp)
    80006b64:	01010413          	addi	s0,sp,16
    80006b68:	00813403          	ld	s0,8(sp)
    80006b6c:	0008a317          	auipc	t1,0x8a
    80006b70:	f9433303          	ld	t1,-108(t1) # 80090b00 <devsw+0x10>
    80006b74:	01010113          	addi	sp,sp,16
    80006b78:	00030067          	jr	t1

0000000080006b7c <console_write>:
    80006b7c:	ff010113          	addi	sp,sp,-16
    80006b80:	00813423          	sd	s0,8(sp)
    80006b84:	01010413          	addi	s0,sp,16
    80006b88:	00813403          	ld	s0,8(sp)
    80006b8c:	0008a317          	auipc	t1,0x8a
    80006b90:	f7c33303          	ld	t1,-132(t1) # 80090b08 <devsw+0x18>
    80006b94:	01010113          	addi	sp,sp,16
    80006b98:	00030067          	jr	t1

0000000080006b9c <panic>:
    80006b9c:	fe010113          	addi	sp,sp,-32
    80006ba0:	00113c23          	sd	ra,24(sp)
    80006ba4:	00813823          	sd	s0,16(sp)
    80006ba8:	00913423          	sd	s1,8(sp)
    80006bac:	02010413          	addi	s0,sp,32
    80006bb0:	00050493          	mv	s1,a0
    80006bb4:	00003517          	auipc	a0,0x3
    80006bb8:	a6450513          	addi	a0,a0,-1436 # 80009618 <CONSOLE_STATUS+0x608>
    80006bbc:	0008a797          	auipc	a5,0x8a
    80006bc0:	fe07a623          	sw	zero,-20(a5) # 80090ba8 <pr+0x18>
    80006bc4:	00000097          	auipc	ra,0x0
    80006bc8:	034080e7          	jalr	52(ra) # 80006bf8 <__printf>
    80006bcc:	00048513          	mv	a0,s1
    80006bd0:	00000097          	auipc	ra,0x0
    80006bd4:	028080e7          	jalr	40(ra) # 80006bf8 <__printf>
    80006bd8:	00003517          	auipc	a0,0x3
    80006bdc:	84850513          	addi	a0,a0,-1976 # 80009420 <CONSOLE_STATUS+0x410>
    80006be0:	00000097          	auipc	ra,0x0
    80006be4:	018080e7          	jalr	24(ra) # 80006bf8 <__printf>
    80006be8:	00100793          	li	a5,1
    80006bec:	00004717          	auipc	a4,0x4
    80006bf0:	7af72223          	sw	a5,1956(a4) # 8000b390 <panicked>
    80006bf4:	0000006f          	j	80006bf4 <panic+0x58>

0000000080006bf8 <__printf>:
    80006bf8:	f3010113          	addi	sp,sp,-208
    80006bfc:	08813023          	sd	s0,128(sp)
    80006c00:	07313423          	sd	s3,104(sp)
    80006c04:	09010413          	addi	s0,sp,144
    80006c08:	05813023          	sd	s8,64(sp)
    80006c0c:	08113423          	sd	ra,136(sp)
    80006c10:	06913c23          	sd	s1,120(sp)
    80006c14:	07213823          	sd	s2,112(sp)
    80006c18:	07413023          	sd	s4,96(sp)
    80006c1c:	05513c23          	sd	s5,88(sp)
    80006c20:	05613823          	sd	s6,80(sp)
    80006c24:	05713423          	sd	s7,72(sp)
    80006c28:	03913c23          	sd	s9,56(sp)
    80006c2c:	03a13823          	sd	s10,48(sp)
    80006c30:	03b13423          	sd	s11,40(sp)
    80006c34:	0008a317          	auipc	t1,0x8a
    80006c38:	f5c30313          	addi	t1,t1,-164 # 80090b90 <pr>
    80006c3c:	01832c03          	lw	s8,24(t1)
    80006c40:	00b43423          	sd	a1,8(s0)
    80006c44:	00c43823          	sd	a2,16(s0)
    80006c48:	00d43c23          	sd	a3,24(s0)
    80006c4c:	02e43023          	sd	a4,32(s0)
    80006c50:	02f43423          	sd	a5,40(s0)
    80006c54:	03043823          	sd	a6,48(s0)
    80006c58:	03143c23          	sd	a7,56(s0)
    80006c5c:	00050993          	mv	s3,a0
    80006c60:	4a0c1663          	bnez	s8,8000710c <__printf+0x514>
    80006c64:	60098c63          	beqz	s3,8000727c <__printf+0x684>
    80006c68:	0009c503          	lbu	a0,0(s3)
    80006c6c:	00840793          	addi	a5,s0,8
    80006c70:	f6f43c23          	sd	a5,-136(s0)
    80006c74:	00000493          	li	s1,0
    80006c78:	22050063          	beqz	a0,80006e98 <__printf+0x2a0>
    80006c7c:	00002a37          	lui	s4,0x2
    80006c80:	00018ab7          	lui	s5,0x18
    80006c84:	000f4b37          	lui	s6,0xf4
    80006c88:	00989bb7          	lui	s7,0x989
    80006c8c:	70fa0a13          	addi	s4,s4,1807 # 270f <_entry-0x7fffd8f1>
    80006c90:	69fa8a93          	addi	s5,s5,1695 # 1869f <_entry-0x7ffe7961>
    80006c94:	23fb0b13          	addi	s6,s6,575 # f423f <_entry-0x7ff0bdc1>
    80006c98:	67fb8b93          	addi	s7,s7,1663 # 98967f <_entry-0x7f676981>
    80006c9c:	00148c9b          	addiw	s9,s1,1
    80006ca0:	02500793          	li	a5,37
    80006ca4:	01998933          	add	s2,s3,s9
    80006ca8:	38f51263          	bne	a0,a5,8000702c <__printf+0x434>
    80006cac:	00094783          	lbu	a5,0(s2)
    80006cb0:	00078c9b          	sext.w	s9,a5
    80006cb4:	1e078263          	beqz	a5,80006e98 <__printf+0x2a0>
    80006cb8:	0024849b          	addiw	s1,s1,2
    80006cbc:	07000713          	li	a4,112
    80006cc0:	00998933          	add	s2,s3,s1
    80006cc4:	38e78a63          	beq	a5,a4,80007058 <__printf+0x460>
    80006cc8:	20f76863          	bltu	a4,a5,80006ed8 <__printf+0x2e0>
    80006ccc:	42a78863          	beq	a5,a0,800070fc <__printf+0x504>
    80006cd0:	06400713          	li	a4,100
    80006cd4:	40e79663          	bne	a5,a4,800070e0 <__printf+0x4e8>
    80006cd8:	f7843783          	ld	a5,-136(s0)
    80006cdc:	0007a603          	lw	a2,0(a5)
    80006ce0:	00878793          	addi	a5,a5,8
    80006ce4:	f6f43c23          	sd	a5,-136(s0)
    80006ce8:	42064a63          	bltz	a2,8000711c <__printf+0x524>
    80006cec:	00a00713          	li	a4,10
    80006cf0:	02e677bb          	remuw	a5,a2,a4
    80006cf4:	00003d97          	auipc	s11,0x3
    80006cf8:	94cd8d93          	addi	s11,s11,-1716 # 80009640 <digits>
    80006cfc:	00900593          	li	a1,9
    80006d00:	0006051b          	sext.w	a0,a2
    80006d04:	00000c93          	li	s9,0
    80006d08:	02079793          	slli	a5,a5,0x20
    80006d0c:	0207d793          	srli	a5,a5,0x20
    80006d10:	00fd87b3          	add	a5,s11,a5
    80006d14:	0007c783          	lbu	a5,0(a5)
    80006d18:	02e656bb          	divuw	a3,a2,a4
    80006d1c:	f8f40023          	sb	a5,-128(s0)
    80006d20:	14c5d863          	bge	a1,a2,80006e70 <__printf+0x278>
    80006d24:	06300593          	li	a1,99
    80006d28:	00100c93          	li	s9,1
    80006d2c:	02e6f7bb          	remuw	a5,a3,a4
    80006d30:	02079793          	slli	a5,a5,0x20
    80006d34:	0207d793          	srli	a5,a5,0x20
    80006d38:	00fd87b3          	add	a5,s11,a5
    80006d3c:	0007c783          	lbu	a5,0(a5)
    80006d40:	02e6d73b          	divuw	a4,a3,a4
    80006d44:	f8f400a3          	sb	a5,-127(s0)
    80006d48:	12a5f463          	bgeu	a1,a0,80006e70 <__printf+0x278>
    80006d4c:	00a00693          	li	a3,10
    80006d50:	00900593          	li	a1,9
    80006d54:	02d777bb          	remuw	a5,a4,a3
    80006d58:	02079793          	slli	a5,a5,0x20
    80006d5c:	0207d793          	srli	a5,a5,0x20
    80006d60:	00fd87b3          	add	a5,s11,a5
    80006d64:	0007c503          	lbu	a0,0(a5)
    80006d68:	02d757bb          	divuw	a5,a4,a3
    80006d6c:	f8a40123          	sb	a0,-126(s0)
    80006d70:	48e5f263          	bgeu	a1,a4,800071f4 <__printf+0x5fc>
    80006d74:	06300513          	li	a0,99
    80006d78:	02d7f5bb          	remuw	a1,a5,a3
    80006d7c:	02059593          	slli	a1,a1,0x20
    80006d80:	0205d593          	srli	a1,a1,0x20
    80006d84:	00bd85b3          	add	a1,s11,a1
    80006d88:	0005c583          	lbu	a1,0(a1)
    80006d8c:	02d7d7bb          	divuw	a5,a5,a3
    80006d90:	f8b401a3          	sb	a1,-125(s0)
    80006d94:	48e57263          	bgeu	a0,a4,80007218 <__printf+0x620>
    80006d98:	3e700513          	li	a0,999
    80006d9c:	02d7f5bb          	remuw	a1,a5,a3
    80006da0:	02059593          	slli	a1,a1,0x20
    80006da4:	0205d593          	srli	a1,a1,0x20
    80006da8:	00bd85b3          	add	a1,s11,a1
    80006dac:	0005c583          	lbu	a1,0(a1)
    80006db0:	02d7d7bb          	divuw	a5,a5,a3
    80006db4:	f8b40223          	sb	a1,-124(s0)
    80006db8:	46e57663          	bgeu	a0,a4,80007224 <__printf+0x62c>
    80006dbc:	02d7f5bb          	remuw	a1,a5,a3
    80006dc0:	02059593          	slli	a1,a1,0x20
    80006dc4:	0205d593          	srli	a1,a1,0x20
    80006dc8:	00bd85b3          	add	a1,s11,a1
    80006dcc:	0005c583          	lbu	a1,0(a1)
    80006dd0:	02d7d7bb          	divuw	a5,a5,a3
    80006dd4:	f8b402a3          	sb	a1,-123(s0)
    80006dd8:	46ea7863          	bgeu	s4,a4,80007248 <__printf+0x650>
    80006ddc:	02d7f5bb          	remuw	a1,a5,a3
    80006de0:	02059593          	slli	a1,a1,0x20
    80006de4:	0205d593          	srli	a1,a1,0x20
    80006de8:	00bd85b3          	add	a1,s11,a1
    80006dec:	0005c583          	lbu	a1,0(a1)
    80006df0:	02d7d7bb          	divuw	a5,a5,a3
    80006df4:	f8b40323          	sb	a1,-122(s0)
    80006df8:	3eeaf863          	bgeu	s5,a4,800071e8 <__printf+0x5f0>
    80006dfc:	02d7f5bb          	remuw	a1,a5,a3
    80006e00:	02059593          	slli	a1,a1,0x20
    80006e04:	0205d593          	srli	a1,a1,0x20
    80006e08:	00bd85b3          	add	a1,s11,a1
    80006e0c:	0005c583          	lbu	a1,0(a1)
    80006e10:	02d7d7bb          	divuw	a5,a5,a3
    80006e14:	f8b403a3          	sb	a1,-121(s0)
    80006e18:	42eb7e63          	bgeu	s6,a4,80007254 <__printf+0x65c>
    80006e1c:	02d7f5bb          	remuw	a1,a5,a3
    80006e20:	02059593          	slli	a1,a1,0x20
    80006e24:	0205d593          	srli	a1,a1,0x20
    80006e28:	00bd85b3          	add	a1,s11,a1
    80006e2c:	0005c583          	lbu	a1,0(a1)
    80006e30:	02d7d7bb          	divuw	a5,a5,a3
    80006e34:	f8b40423          	sb	a1,-120(s0)
    80006e38:	42ebfc63          	bgeu	s7,a4,80007270 <__printf+0x678>
    80006e3c:	02079793          	slli	a5,a5,0x20
    80006e40:	0207d793          	srli	a5,a5,0x20
    80006e44:	00fd8db3          	add	s11,s11,a5
    80006e48:	000dc703          	lbu	a4,0(s11)
    80006e4c:	00a00793          	li	a5,10
    80006e50:	00900c93          	li	s9,9
    80006e54:	f8e404a3          	sb	a4,-119(s0)
    80006e58:	00065c63          	bgez	a2,80006e70 <__printf+0x278>
    80006e5c:	f9040713          	addi	a4,s0,-112
    80006e60:	00f70733          	add	a4,a4,a5
    80006e64:	02d00693          	li	a3,45
    80006e68:	fed70823          	sb	a3,-16(a4)
    80006e6c:	00078c93          	mv	s9,a5
    80006e70:	f8040793          	addi	a5,s0,-128
    80006e74:	01978cb3          	add	s9,a5,s9
    80006e78:	f7f40d13          	addi	s10,s0,-129
    80006e7c:	000cc503          	lbu	a0,0(s9)
    80006e80:	fffc8c93          	addi	s9,s9,-1
    80006e84:	00000097          	auipc	ra,0x0
    80006e88:	b90080e7          	jalr	-1136(ra) # 80006a14 <consputc>
    80006e8c:	ffac98e3          	bne	s9,s10,80006e7c <__printf+0x284>
    80006e90:	00094503          	lbu	a0,0(s2)
    80006e94:	e00514e3          	bnez	a0,80006c9c <__printf+0xa4>
    80006e98:	1a0c1663          	bnez	s8,80007044 <__printf+0x44c>
    80006e9c:	08813083          	ld	ra,136(sp)
    80006ea0:	08013403          	ld	s0,128(sp)
    80006ea4:	07813483          	ld	s1,120(sp)
    80006ea8:	07013903          	ld	s2,112(sp)
    80006eac:	06813983          	ld	s3,104(sp)
    80006eb0:	06013a03          	ld	s4,96(sp)
    80006eb4:	05813a83          	ld	s5,88(sp)
    80006eb8:	05013b03          	ld	s6,80(sp)
    80006ebc:	04813b83          	ld	s7,72(sp)
    80006ec0:	04013c03          	ld	s8,64(sp)
    80006ec4:	03813c83          	ld	s9,56(sp)
    80006ec8:	03013d03          	ld	s10,48(sp)
    80006ecc:	02813d83          	ld	s11,40(sp)
    80006ed0:	0d010113          	addi	sp,sp,208
    80006ed4:	00008067          	ret
    80006ed8:	07300713          	li	a4,115
    80006edc:	1ce78a63          	beq	a5,a4,800070b0 <__printf+0x4b8>
    80006ee0:	07800713          	li	a4,120
    80006ee4:	1ee79e63          	bne	a5,a4,800070e0 <__printf+0x4e8>
    80006ee8:	f7843783          	ld	a5,-136(s0)
    80006eec:	0007a703          	lw	a4,0(a5)
    80006ef0:	00878793          	addi	a5,a5,8
    80006ef4:	f6f43c23          	sd	a5,-136(s0)
    80006ef8:	28074263          	bltz	a4,8000717c <__printf+0x584>
    80006efc:	00002d97          	auipc	s11,0x2
    80006f00:	744d8d93          	addi	s11,s11,1860 # 80009640 <digits>
    80006f04:	00f77793          	andi	a5,a4,15
    80006f08:	00fd87b3          	add	a5,s11,a5
    80006f0c:	0007c683          	lbu	a3,0(a5)
    80006f10:	00f00613          	li	a2,15
    80006f14:	0007079b          	sext.w	a5,a4
    80006f18:	f8d40023          	sb	a3,-128(s0)
    80006f1c:	0047559b          	srliw	a1,a4,0x4
    80006f20:	0047569b          	srliw	a3,a4,0x4
    80006f24:	00000c93          	li	s9,0
    80006f28:	0ee65063          	bge	a2,a4,80007008 <__printf+0x410>
    80006f2c:	00f6f693          	andi	a3,a3,15
    80006f30:	00dd86b3          	add	a3,s11,a3
    80006f34:	0006c683          	lbu	a3,0(a3) # 2004000 <_entry-0x7dffc000>
    80006f38:	0087d79b          	srliw	a5,a5,0x8
    80006f3c:	00100c93          	li	s9,1
    80006f40:	f8d400a3          	sb	a3,-127(s0)
    80006f44:	0cb67263          	bgeu	a2,a1,80007008 <__printf+0x410>
    80006f48:	00f7f693          	andi	a3,a5,15
    80006f4c:	00dd86b3          	add	a3,s11,a3
    80006f50:	0006c583          	lbu	a1,0(a3)
    80006f54:	00f00613          	li	a2,15
    80006f58:	0047d69b          	srliw	a3,a5,0x4
    80006f5c:	f8b40123          	sb	a1,-126(s0)
    80006f60:	0047d593          	srli	a1,a5,0x4
    80006f64:	28f67e63          	bgeu	a2,a5,80007200 <__printf+0x608>
    80006f68:	00f6f693          	andi	a3,a3,15
    80006f6c:	00dd86b3          	add	a3,s11,a3
    80006f70:	0006c503          	lbu	a0,0(a3)
    80006f74:	0087d813          	srli	a6,a5,0x8
    80006f78:	0087d69b          	srliw	a3,a5,0x8
    80006f7c:	f8a401a3          	sb	a0,-125(s0)
    80006f80:	28b67663          	bgeu	a2,a1,8000720c <__printf+0x614>
    80006f84:	00f6f693          	andi	a3,a3,15
    80006f88:	00dd86b3          	add	a3,s11,a3
    80006f8c:	0006c583          	lbu	a1,0(a3)
    80006f90:	00c7d513          	srli	a0,a5,0xc
    80006f94:	00c7d69b          	srliw	a3,a5,0xc
    80006f98:	f8b40223          	sb	a1,-124(s0)
    80006f9c:	29067a63          	bgeu	a2,a6,80007230 <__printf+0x638>
    80006fa0:	00f6f693          	andi	a3,a3,15
    80006fa4:	00dd86b3          	add	a3,s11,a3
    80006fa8:	0006c583          	lbu	a1,0(a3)
    80006fac:	0107d813          	srli	a6,a5,0x10
    80006fb0:	0107d69b          	srliw	a3,a5,0x10
    80006fb4:	f8b402a3          	sb	a1,-123(s0)
    80006fb8:	28a67263          	bgeu	a2,a0,8000723c <__printf+0x644>
    80006fbc:	00f6f693          	andi	a3,a3,15
    80006fc0:	00dd86b3          	add	a3,s11,a3
    80006fc4:	0006c683          	lbu	a3,0(a3)
    80006fc8:	0147d79b          	srliw	a5,a5,0x14
    80006fcc:	f8d40323          	sb	a3,-122(s0)
    80006fd0:	21067663          	bgeu	a2,a6,800071dc <__printf+0x5e4>
    80006fd4:	02079793          	slli	a5,a5,0x20
    80006fd8:	0207d793          	srli	a5,a5,0x20
    80006fdc:	00fd8db3          	add	s11,s11,a5
    80006fe0:	000dc683          	lbu	a3,0(s11)
    80006fe4:	00800793          	li	a5,8
    80006fe8:	00700c93          	li	s9,7
    80006fec:	f8d403a3          	sb	a3,-121(s0)
    80006ff0:	00075c63          	bgez	a4,80007008 <__printf+0x410>
    80006ff4:	f9040713          	addi	a4,s0,-112
    80006ff8:	00f70733          	add	a4,a4,a5
    80006ffc:	02d00693          	li	a3,45
    80007000:	fed70823          	sb	a3,-16(a4)
    80007004:	00078c93          	mv	s9,a5
    80007008:	f8040793          	addi	a5,s0,-128
    8000700c:	01978cb3          	add	s9,a5,s9
    80007010:	f7f40d13          	addi	s10,s0,-129
    80007014:	000cc503          	lbu	a0,0(s9)
    80007018:	fffc8c93          	addi	s9,s9,-1
    8000701c:	00000097          	auipc	ra,0x0
    80007020:	9f8080e7          	jalr	-1544(ra) # 80006a14 <consputc>
    80007024:	ff9d18e3          	bne	s10,s9,80007014 <__printf+0x41c>
    80007028:	0100006f          	j	80007038 <__printf+0x440>
    8000702c:	00000097          	auipc	ra,0x0
    80007030:	9e8080e7          	jalr	-1560(ra) # 80006a14 <consputc>
    80007034:	000c8493          	mv	s1,s9
    80007038:	00094503          	lbu	a0,0(s2)
    8000703c:	c60510e3          	bnez	a0,80006c9c <__printf+0xa4>
    80007040:	e40c0ee3          	beqz	s8,80006e9c <__printf+0x2a4>
    80007044:	0008a517          	auipc	a0,0x8a
    80007048:	b4c50513          	addi	a0,a0,-1204 # 80090b90 <pr>
    8000704c:	00001097          	auipc	ra,0x1
    80007050:	94c080e7          	jalr	-1716(ra) # 80007998 <release>
    80007054:	e49ff06f          	j	80006e9c <__printf+0x2a4>
    80007058:	f7843783          	ld	a5,-136(s0)
    8000705c:	03000513          	li	a0,48
    80007060:	01000d13          	li	s10,16
    80007064:	00878713          	addi	a4,a5,8
    80007068:	0007bc83          	ld	s9,0(a5)
    8000706c:	f6e43c23          	sd	a4,-136(s0)
    80007070:	00000097          	auipc	ra,0x0
    80007074:	9a4080e7          	jalr	-1628(ra) # 80006a14 <consputc>
    80007078:	07800513          	li	a0,120
    8000707c:	00000097          	auipc	ra,0x0
    80007080:	998080e7          	jalr	-1640(ra) # 80006a14 <consputc>
    80007084:	00002d97          	auipc	s11,0x2
    80007088:	5bcd8d93          	addi	s11,s11,1468 # 80009640 <digits>
    8000708c:	03ccd793          	srli	a5,s9,0x3c
    80007090:	00fd87b3          	add	a5,s11,a5
    80007094:	0007c503          	lbu	a0,0(a5)
    80007098:	fffd0d1b          	addiw	s10,s10,-1
    8000709c:	004c9c93          	slli	s9,s9,0x4
    800070a0:	00000097          	auipc	ra,0x0
    800070a4:	974080e7          	jalr	-1676(ra) # 80006a14 <consputc>
    800070a8:	fe0d12e3          	bnez	s10,8000708c <__printf+0x494>
    800070ac:	f8dff06f          	j	80007038 <__printf+0x440>
    800070b0:	f7843783          	ld	a5,-136(s0)
    800070b4:	0007bc83          	ld	s9,0(a5)
    800070b8:	00878793          	addi	a5,a5,8
    800070bc:	f6f43c23          	sd	a5,-136(s0)
    800070c0:	000c9a63          	bnez	s9,800070d4 <__printf+0x4dc>
    800070c4:	1080006f          	j	800071cc <__printf+0x5d4>
    800070c8:	001c8c93          	addi	s9,s9,1
    800070cc:	00000097          	auipc	ra,0x0
    800070d0:	948080e7          	jalr	-1720(ra) # 80006a14 <consputc>
    800070d4:	000cc503          	lbu	a0,0(s9)
    800070d8:	fe0518e3          	bnez	a0,800070c8 <__printf+0x4d0>
    800070dc:	f5dff06f          	j	80007038 <__printf+0x440>
    800070e0:	02500513          	li	a0,37
    800070e4:	00000097          	auipc	ra,0x0
    800070e8:	930080e7          	jalr	-1744(ra) # 80006a14 <consputc>
    800070ec:	000c8513          	mv	a0,s9
    800070f0:	00000097          	auipc	ra,0x0
    800070f4:	924080e7          	jalr	-1756(ra) # 80006a14 <consputc>
    800070f8:	f41ff06f          	j	80007038 <__printf+0x440>
    800070fc:	02500513          	li	a0,37
    80007100:	00000097          	auipc	ra,0x0
    80007104:	914080e7          	jalr	-1772(ra) # 80006a14 <consputc>
    80007108:	f31ff06f          	j	80007038 <__printf+0x440>
    8000710c:	00030513          	mv	a0,t1
    80007110:	00000097          	auipc	ra,0x0
    80007114:	7bc080e7          	jalr	1980(ra) # 800078cc <acquire>
    80007118:	b4dff06f          	j	80006c64 <__printf+0x6c>
    8000711c:	40c0053b          	negw	a0,a2
    80007120:	00a00713          	li	a4,10
    80007124:	02e576bb          	remuw	a3,a0,a4
    80007128:	00002d97          	auipc	s11,0x2
    8000712c:	518d8d93          	addi	s11,s11,1304 # 80009640 <digits>
    80007130:	ff700593          	li	a1,-9
    80007134:	02069693          	slli	a3,a3,0x20
    80007138:	0206d693          	srli	a3,a3,0x20
    8000713c:	00dd86b3          	add	a3,s11,a3
    80007140:	0006c683          	lbu	a3,0(a3)
    80007144:	02e557bb          	divuw	a5,a0,a4
    80007148:	f8d40023          	sb	a3,-128(s0)
    8000714c:	10b65e63          	bge	a2,a1,80007268 <__printf+0x670>
    80007150:	06300593          	li	a1,99
    80007154:	02e7f6bb          	remuw	a3,a5,a4
    80007158:	02069693          	slli	a3,a3,0x20
    8000715c:	0206d693          	srli	a3,a3,0x20
    80007160:	00dd86b3          	add	a3,s11,a3
    80007164:	0006c683          	lbu	a3,0(a3)
    80007168:	02e7d73b          	divuw	a4,a5,a4
    8000716c:	00200793          	li	a5,2
    80007170:	f8d400a3          	sb	a3,-127(s0)
    80007174:	bca5ece3          	bltu	a1,a0,80006d4c <__printf+0x154>
    80007178:	ce5ff06f          	j	80006e5c <__printf+0x264>
    8000717c:	40e007bb          	negw	a5,a4
    80007180:	00002d97          	auipc	s11,0x2
    80007184:	4c0d8d93          	addi	s11,s11,1216 # 80009640 <digits>
    80007188:	00f7f693          	andi	a3,a5,15
    8000718c:	00dd86b3          	add	a3,s11,a3
    80007190:	0006c583          	lbu	a1,0(a3)
    80007194:	ff100613          	li	a2,-15
    80007198:	0047d69b          	srliw	a3,a5,0x4
    8000719c:	f8b40023          	sb	a1,-128(s0)
    800071a0:	0047d59b          	srliw	a1,a5,0x4
    800071a4:	0ac75e63          	bge	a4,a2,80007260 <__printf+0x668>
    800071a8:	00f6f693          	andi	a3,a3,15
    800071ac:	00dd86b3          	add	a3,s11,a3
    800071b0:	0006c603          	lbu	a2,0(a3)
    800071b4:	00f00693          	li	a3,15
    800071b8:	0087d79b          	srliw	a5,a5,0x8
    800071bc:	f8c400a3          	sb	a2,-127(s0)
    800071c0:	d8b6e4e3          	bltu	a3,a1,80006f48 <__printf+0x350>
    800071c4:	00200793          	li	a5,2
    800071c8:	e2dff06f          	j	80006ff4 <__printf+0x3fc>
    800071cc:	00002c97          	auipc	s9,0x2
    800071d0:	454c8c93          	addi	s9,s9,1108 # 80009620 <CONSOLE_STATUS+0x610>
    800071d4:	02800513          	li	a0,40
    800071d8:	ef1ff06f          	j	800070c8 <__printf+0x4d0>
    800071dc:	00700793          	li	a5,7
    800071e0:	00600c93          	li	s9,6
    800071e4:	e0dff06f          	j	80006ff0 <__printf+0x3f8>
    800071e8:	00700793          	li	a5,7
    800071ec:	00600c93          	li	s9,6
    800071f0:	c69ff06f          	j	80006e58 <__printf+0x260>
    800071f4:	00300793          	li	a5,3
    800071f8:	00200c93          	li	s9,2
    800071fc:	c5dff06f          	j	80006e58 <__printf+0x260>
    80007200:	00300793          	li	a5,3
    80007204:	00200c93          	li	s9,2
    80007208:	de9ff06f          	j	80006ff0 <__printf+0x3f8>
    8000720c:	00400793          	li	a5,4
    80007210:	00300c93          	li	s9,3
    80007214:	dddff06f          	j	80006ff0 <__printf+0x3f8>
    80007218:	00400793          	li	a5,4
    8000721c:	00300c93          	li	s9,3
    80007220:	c39ff06f          	j	80006e58 <__printf+0x260>
    80007224:	00500793          	li	a5,5
    80007228:	00400c93          	li	s9,4
    8000722c:	c2dff06f          	j	80006e58 <__printf+0x260>
    80007230:	00500793          	li	a5,5
    80007234:	00400c93          	li	s9,4
    80007238:	db9ff06f          	j	80006ff0 <__printf+0x3f8>
    8000723c:	00600793          	li	a5,6
    80007240:	00500c93          	li	s9,5
    80007244:	dadff06f          	j	80006ff0 <__printf+0x3f8>
    80007248:	00600793          	li	a5,6
    8000724c:	00500c93          	li	s9,5
    80007250:	c09ff06f          	j	80006e58 <__printf+0x260>
    80007254:	00800793          	li	a5,8
    80007258:	00700c93          	li	s9,7
    8000725c:	bfdff06f          	j	80006e58 <__printf+0x260>
    80007260:	00100793          	li	a5,1
    80007264:	d91ff06f          	j	80006ff4 <__printf+0x3fc>
    80007268:	00100793          	li	a5,1
    8000726c:	bf1ff06f          	j	80006e5c <__printf+0x264>
    80007270:	00900793          	li	a5,9
    80007274:	00800c93          	li	s9,8
    80007278:	be1ff06f          	j	80006e58 <__printf+0x260>
    8000727c:	00002517          	auipc	a0,0x2
    80007280:	3ac50513          	addi	a0,a0,940 # 80009628 <CONSOLE_STATUS+0x618>
    80007284:	00000097          	auipc	ra,0x0
    80007288:	918080e7          	jalr	-1768(ra) # 80006b9c <panic>

000000008000728c <printfinit>:
    8000728c:	fe010113          	addi	sp,sp,-32
    80007290:	00813823          	sd	s0,16(sp)
    80007294:	00913423          	sd	s1,8(sp)
    80007298:	00113c23          	sd	ra,24(sp)
    8000729c:	02010413          	addi	s0,sp,32
    800072a0:	0008a497          	auipc	s1,0x8a
    800072a4:	8f048493          	addi	s1,s1,-1808 # 80090b90 <pr>
    800072a8:	00048513          	mv	a0,s1
    800072ac:	00002597          	auipc	a1,0x2
    800072b0:	38c58593          	addi	a1,a1,908 # 80009638 <CONSOLE_STATUS+0x628>
    800072b4:	00000097          	auipc	ra,0x0
    800072b8:	5f4080e7          	jalr	1524(ra) # 800078a8 <initlock>
    800072bc:	01813083          	ld	ra,24(sp)
    800072c0:	01013403          	ld	s0,16(sp)
    800072c4:	0004ac23          	sw	zero,24(s1)
    800072c8:	00813483          	ld	s1,8(sp)
    800072cc:	02010113          	addi	sp,sp,32
    800072d0:	00008067          	ret

00000000800072d4 <uartinit>:
    800072d4:	ff010113          	addi	sp,sp,-16
    800072d8:	00813423          	sd	s0,8(sp)
    800072dc:	01010413          	addi	s0,sp,16
    800072e0:	100007b7          	lui	a5,0x10000
    800072e4:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>
    800072e8:	f8000713          	li	a4,-128
    800072ec:	00e781a3          	sb	a4,3(a5)
    800072f0:	00300713          	li	a4,3
    800072f4:	00e78023          	sb	a4,0(a5)
    800072f8:	000780a3          	sb	zero,1(a5)
    800072fc:	00e781a3          	sb	a4,3(a5)
    80007300:	00700693          	li	a3,7
    80007304:	00d78123          	sb	a3,2(a5)
    80007308:	00e780a3          	sb	a4,1(a5)
    8000730c:	00813403          	ld	s0,8(sp)
    80007310:	01010113          	addi	sp,sp,16
    80007314:	00008067          	ret

0000000080007318 <uartputc>:
    80007318:	00004797          	auipc	a5,0x4
    8000731c:	0787a783          	lw	a5,120(a5) # 8000b390 <panicked>
    80007320:	00078463          	beqz	a5,80007328 <uartputc+0x10>
    80007324:	0000006f          	j	80007324 <uartputc+0xc>
    80007328:	fd010113          	addi	sp,sp,-48
    8000732c:	02813023          	sd	s0,32(sp)
    80007330:	00913c23          	sd	s1,24(sp)
    80007334:	01213823          	sd	s2,16(sp)
    80007338:	01313423          	sd	s3,8(sp)
    8000733c:	02113423          	sd	ra,40(sp)
    80007340:	03010413          	addi	s0,sp,48
    80007344:	00004917          	auipc	s2,0x4
    80007348:	05490913          	addi	s2,s2,84 # 8000b398 <uart_tx_r>
    8000734c:	00093783          	ld	a5,0(s2)
    80007350:	00004497          	auipc	s1,0x4
    80007354:	05048493          	addi	s1,s1,80 # 8000b3a0 <uart_tx_w>
    80007358:	0004b703          	ld	a4,0(s1)
    8000735c:	02078693          	addi	a3,a5,32
    80007360:	00050993          	mv	s3,a0
    80007364:	02e69c63          	bne	a3,a4,8000739c <uartputc+0x84>
    80007368:	00001097          	auipc	ra,0x1
    8000736c:	834080e7          	jalr	-1996(ra) # 80007b9c <push_on>
    80007370:	00093783          	ld	a5,0(s2)
    80007374:	0004b703          	ld	a4,0(s1)
    80007378:	02078793          	addi	a5,a5,32
    8000737c:	00e79463          	bne	a5,a4,80007384 <uartputc+0x6c>
    80007380:	0000006f          	j	80007380 <uartputc+0x68>
    80007384:	00001097          	auipc	ra,0x1
    80007388:	88c080e7          	jalr	-1908(ra) # 80007c10 <pop_on>
    8000738c:	00093783          	ld	a5,0(s2)
    80007390:	0004b703          	ld	a4,0(s1)
    80007394:	02078693          	addi	a3,a5,32
    80007398:	fce688e3          	beq	a3,a4,80007368 <uartputc+0x50>
    8000739c:	01f77693          	andi	a3,a4,31
    800073a0:	0008a597          	auipc	a1,0x8a
    800073a4:	81058593          	addi	a1,a1,-2032 # 80090bb0 <uart_tx_buf>
    800073a8:	00d586b3          	add	a3,a1,a3
    800073ac:	00170713          	addi	a4,a4,1
    800073b0:	01368023          	sb	s3,0(a3)
    800073b4:	00e4b023          	sd	a4,0(s1)
    800073b8:	10000637          	lui	a2,0x10000
    800073bc:	02f71063          	bne	a4,a5,800073dc <uartputc+0xc4>
    800073c0:	0340006f          	j	800073f4 <uartputc+0xdc>
    800073c4:	00074703          	lbu	a4,0(a4)
    800073c8:	00f93023          	sd	a5,0(s2)
    800073cc:	00e60023          	sb	a4,0(a2) # 10000000 <_entry-0x70000000>
    800073d0:	00093783          	ld	a5,0(s2)
    800073d4:	0004b703          	ld	a4,0(s1)
    800073d8:	00f70e63          	beq	a4,a5,800073f4 <uartputc+0xdc>
    800073dc:	00564683          	lbu	a3,5(a2)
    800073e0:	01f7f713          	andi	a4,a5,31
    800073e4:	00e58733          	add	a4,a1,a4
    800073e8:	0206f693          	andi	a3,a3,32
    800073ec:	00178793          	addi	a5,a5,1
    800073f0:	fc069ae3          	bnez	a3,800073c4 <uartputc+0xac>
    800073f4:	02813083          	ld	ra,40(sp)
    800073f8:	02013403          	ld	s0,32(sp)
    800073fc:	01813483          	ld	s1,24(sp)
    80007400:	01013903          	ld	s2,16(sp)
    80007404:	00813983          	ld	s3,8(sp)
    80007408:	03010113          	addi	sp,sp,48
    8000740c:	00008067          	ret

0000000080007410 <uartputc_sync>:
    80007410:	ff010113          	addi	sp,sp,-16
    80007414:	00813423          	sd	s0,8(sp)
    80007418:	01010413          	addi	s0,sp,16
    8000741c:	00004717          	auipc	a4,0x4
    80007420:	f7472703          	lw	a4,-140(a4) # 8000b390 <panicked>
    80007424:	02071663          	bnez	a4,80007450 <uartputc_sync+0x40>
    80007428:	00050793          	mv	a5,a0
    8000742c:	100006b7          	lui	a3,0x10000
    80007430:	0056c703          	lbu	a4,5(a3) # 10000005 <_entry-0x6ffffffb>
    80007434:	02077713          	andi	a4,a4,32
    80007438:	fe070ce3          	beqz	a4,80007430 <uartputc_sync+0x20>
    8000743c:	0ff7f793          	andi	a5,a5,255
    80007440:	00f68023          	sb	a5,0(a3)
    80007444:	00813403          	ld	s0,8(sp)
    80007448:	01010113          	addi	sp,sp,16
    8000744c:	00008067          	ret
    80007450:	0000006f          	j	80007450 <uartputc_sync+0x40>

0000000080007454 <uartstart>:
    80007454:	ff010113          	addi	sp,sp,-16
    80007458:	00813423          	sd	s0,8(sp)
    8000745c:	01010413          	addi	s0,sp,16
    80007460:	00004617          	auipc	a2,0x4
    80007464:	f3860613          	addi	a2,a2,-200 # 8000b398 <uart_tx_r>
    80007468:	00004517          	auipc	a0,0x4
    8000746c:	f3850513          	addi	a0,a0,-200 # 8000b3a0 <uart_tx_w>
    80007470:	00063783          	ld	a5,0(a2)
    80007474:	00053703          	ld	a4,0(a0)
    80007478:	04f70263          	beq	a4,a5,800074bc <uartstart+0x68>
    8000747c:	100005b7          	lui	a1,0x10000
    80007480:	00089817          	auipc	a6,0x89
    80007484:	73080813          	addi	a6,a6,1840 # 80090bb0 <uart_tx_buf>
    80007488:	01c0006f          	j	800074a4 <uartstart+0x50>
    8000748c:	0006c703          	lbu	a4,0(a3)
    80007490:	00f63023          	sd	a5,0(a2)
    80007494:	00e58023          	sb	a4,0(a1) # 10000000 <_entry-0x70000000>
    80007498:	00063783          	ld	a5,0(a2)
    8000749c:	00053703          	ld	a4,0(a0)
    800074a0:	00f70e63          	beq	a4,a5,800074bc <uartstart+0x68>
    800074a4:	01f7f713          	andi	a4,a5,31
    800074a8:	00e806b3          	add	a3,a6,a4
    800074ac:	0055c703          	lbu	a4,5(a1)
    800074b0:	00178793          	addi	a5,a5,1
    800074b4:	02077713          	andi	a4,a4,32
    800074b8:	fc071ae3          	bnez	a4,8000748c <uartstart+0x38>
    800074bc:	00813403          	ld	s0,8(sp)
    800074c0:	01010113          	addi	sp,sp,16
    800074c4:	00008067          	ret

00000000800074c8 <uartgetc>:
    800074c8:	ff010113          	addi	sp,sp,-16
    800074cc:	00813423          	sd	s0,8(sp)
    800074d0:	01010413          	addi	s0,sp,16
    800074d4:	10000737          	lui	a4,0x10000
    800074d8:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    800074dc:	0017f793          	andi	a5,a5,1
    800074e0:	00078c63          	beqz	a5,800074f8 <uartgetc+0x30>
    800074e4:	00074503          	lbu	a0,0(a4)
    800074e8:	0ff57513          	andi	a0,a0,255
    800074ec:	00813403          	ld	s0,8(sp)
    800074f0:	01010113          	addi	sp,sp,16
    800074f4:	00008067          	ret
    800074f8:	fff00513          	li	a0,-1
    800074fc:	ff1ff06f          	j	800074ec <uartgetc+0x24>

0000000080007500 <uartintr>:
    80007500:	100007b7          	lui	a5,0x10000
    80007504:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80007508:	0017f793          	andi	a5,a5,1
    8000750c:	0a078463          	beqz	a5,800075b4 <uartintr+0xb4>
    80007510:	fe010113          	addi	sp,sp,-32
    80007514:	00813823          	sd	s0,16(sp)
    80007518:	00913423          	sd	s1,8(sp)
    8000751c:	00113c23          	sd	ra,24(sp)
    80007520:	02010413          	addi	s0,sp,32
    80007524:	100004b7          	lui	s1,0x10000
    80007528:	0004c503          	lbu	a0,0(s1) # 10000000 <_entry-0x70000000>
    8000752c:	0ff57513          	andi	a0,a0,255
    80007530:	fffff097          	auipc	ra,0xfffff
    80007534:	534080e7          	jalr	1332(ra) # 80006a64 <consoleintr>
    80007538:	0054c783          	lbu	a5,5(s1)
    8000753c:	0017f793          	andi	a5,a5,1
    80007540:	fe0794e3          	bnez	a5,80007528 <uartintr+0x28>
    80007544:	00004617          	auipc	a2,0x4
    80007548:	e5460613          	addi	a2,a2,-428 # 8000b398 <uart_tx_r>
    8000754c:	00004517          	auipc	a0,0x4
    80007550:	e5450513          	addi	a0,a0,-428 # 8000b3a0 <uart_tx_w>
    80007554:	00063783          	ld	a5,0(a2)
    80007558:	00053703          	ld	a4,0(a0)
    8000755c:	04f70263          	beq	a4,a5,800075a0 <uartintr+0xa0>
    80007560:	100005b7          	lui	a1,0x10000
    80007564:	00089817          	auipc	a6,0x89
    80007568:	64c80813          	addi	a6,a6,1612 # 80090bb0 <uart_tx_buf>
    8000756c:	01c0006f          	j	80007588 <uartintr+0x88>
    80007570:	0006c703          	lbu	a4,0(a3)
    80007574:	00f63023          	sd	a5,0(a2)
    80007578:	00e58023          	sb	a4,0(a1) # 10000000 <_entry-0x70000000>
    8000757c:	00063783          	ld	a5,0(a2)
    80007580:	00053703          	ld	a4,0(a0)
    80007584:	00f70e63          	beq	a4,a5,800075a0 <uartintr+0xa0>
    80007588:	01f7f713          	andi	a4,a5,31
    8000758c:	00e806b3          	add	a3,a6,a4
    80007590:	0055c703          	lbu	a4,5(a1)
    80007594:	00178793          	addi	a5,a5,1
    80007598:	02077713          	andi	a4,a4,32
    8000759c:	fc071ae3          	bnez	a4,80007570 <uartintr+0x70>
    800075a0:	01813083          	ld	ra,24(sp)
    800075a4:	01013403          	ld	s0,16(sp)
    800075a8:	00813483          	ld	s1,8(sp)
    800075ac:	02010113          	addi	sp,sp,32
    800075b0:	00008067          	ret
    800075b4:	00004617          	auipc	a2,0x4
    800075b8:	de460613          	addi	a2,a2,-540 # 8000b398 <uart_tx_r>
    800075bc:	00004517          	auipc	a0,0x4
    800075c0:	de450513          	addi	a0,a0,-540 # 8000b3a0 <uart_tx_w>
    800075c4:	00063783          	ld	a5,0(a2)
    800075c8:	00053703          	ld	a4,0(a0)
    800075cc:	04f70263          	beq	a4,a5,80007610 <uartintr+0x110>
    800075d0:	100005b7          	lui	a1,0x10000
    800075d4:	00089817          	auipc	a6,0x89
    800075d8:	5dc80813          	addi	a6,a6,1500 # 80090bb0 <uart_tx_buf>
    800075dc:	01c0006f          	j	800075f8 <uartintr+0xf8>
    800075e0:	0006c703          	lbu	a4,0(a3)
    800075e4:	00f63023          	sd	a5,0(a2)
    800075e8:	00e58023          	sb	a4,0(a1) # 10000000 <_entry-0x70000000>
    800075ec:	00063783          	ld	a5,0(a2)
    800075f0:	00053703          	ld	a4,0(a0)
    800075f4:	02f70063          	beq	a4,a5,80007614 <uartintr+0x114>
    800075f8:	01f7f713          	andi	a4,a5,31
    800075fc:	00e806b3          	add	a3,a6,a4
    80007600:	0055c703          	lbu	a4,5(a1)
    80007604:	00178793          	addi	a5,a5,1
    80007608:	02077713          	andi	a4,a4,32
    8000760c:	fc071ae3          	bnez	a4,800075e0 <uartintr+0xe0>
    80007610:	00008067          	ret
    80007614:	00008067          	ret

0000000080007618 <kinit>:
    80007618:	fc010113          	addi	sp,sp,-64
    8000761c:	02913423          	sd	s1,40(sp)
    80007620:	fffff7b7          	lui	a5,0xfffff
    80007624:	0008a497          	auipc	s1,0x8a
    80007628:	5ab48493          	addi	s1,s1,1451 # 80091bcf <end+0xfff>
    8000762c:	02813823          	sd	s0,48(sp)
    80007630:	01313c23          	sd	s3,24(sp)
    80007634:	00f4f4b3          	and	s1,s1,a5
    80007638:	02113c23          	sd	ra,56(sp)
    8000763c:	03213023          	sd	s2,32(sp)
    80007640:	01413823          	sd	s4,16(sp)
    80007644:	01513423          	sd	s5,8(sp)
    80007648:	04010413          	addi	s0,sp,64
    8000764c:	000017b7          	lui	a5,0x1
    80007650:	01100993          	li	s3,17
    80007654:	00f487b3          	add	a5,s1,a5
    80007658:	01b99993          	slli	s3,s3,0x1b
    8000765c:	06f9e063          	bltu	s3,a5,800076bc <kinit+0xa4>
    80007660:	00089a97          	auipc	s5,0x89
    80007664:	570a8a93          	addi	s5,s5,1392 # 80090bd0 <end>
    80007668:	0754ec63          	bltu	s1,s5,800076e0 <kinit+0xc8>
    8000766c:	0734fa63          	bgeu	s1,s3,800076e0 <kinit+0xc8>
    80007670:	00088a37          	lui	s4,0x88
    80007674:	fffa0a13          	addi	s4,s4,-1 # 87fff <_entry-0x7ff78001>
    80007678:	00004917          	auipc	s2,0x4
    8000767c:	d3090913          	addi	s2,s2,-720 # 8000b3a8 <kmem>
    80007680:	00ca1a13          	slli	s4,s4,0xc
    80007684:	0140006f          	j	80007698 <kinit+0x80>
    80007688:	000017b7          	lui	a5,0x1
    8000768c:	00f484b3          	add	s1,s1,a5
    80007690:	0554e863          	bltu	s1,s5,800076e0 <kinit+0xc8>
    80007694:	0534f663          	bgeu	s1,s3,800076e0 <kinit+0xc8>
    80007698:	00001637          	lui	a2,0x1
    8000769c:	00100593          	li	a1,1
    800076a0:	00048513          	mv	a0,s1
    800076a4:	00000097          	auipc	ra,0x0
    800076a8:	5e4080e7          	jalr	1508(ra) # 80007c88 <__memset>
    800076ac:	00093783          	ld	a5,0(s2)
    800076b0:	00f4b023          	sd	a5,0(s1)
    800076b4:	00993023          	sd	s1,0(s2)
    800076b8:	fd4498e3          	bne	s1,s4,80007688 <kinit+0x70>
    800076bc:	03813083          	ld	ra,56(sp)
    800076c0:	03013403          	ld	s0,48(sp)
    800076c4:	02813483          	ld	s1,40(sp)
    800076c8:	02013903          	ld	s2,32(sp)
    800076cc:	01813983          	ld	s3,24(sp)
    800076d0:	01013a03          	ld	s4,16(sp)
    800076d4:	00813a83          	ld	s5,8(sp)
    800076d8:	04010113          	addi	sp,sp,64
    800076dc:	00008067          	ret
    800076e0:	00002517          	auipc	a0,0x2
    800076e4:	f7850513          	addi	a0,a0,-136 # 80009658 <digits+0x18>
    800076e8:	fffff097          	auipc	ra,0xfffff
    800076ec:	4b4080e7          	jalr	1204(ra) # 80006b9c <panic>

00000000800076f0 <freerange>:
    800076f0:	fc010113          	addi	sp,sp,-64
    800076f4:	000017b7          	lui	a5,0x1
    800076f8:	02913423          	sd	s1,40(sp)
    800076fc:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    80007700:	009504b3          	add	s1,a0,s1
    80007704:	fffff537          	lui	a0,0xfffff
    80007708:	02813823          	sd	s0,48(sp)
    8000770c:	02113c23          	sd	ra,56(sp)
    80007710:	03213023          	sd	s2,32(sp)
    80007714:	01313c23          	sd	s3,24(sp)
    80007718:	01413823          	sd	s4,16(sp)
    8000771c:	01513423          	sd	s5,8(sp)
    80007720:	01613023          	sd	s6,0(sp)
    80007724:	04010413          	addi	s0,sp,64
    80007728:	00a4f4b3          	and	s1,s1,a0
    8000772c:	00f487b3          	add	a5,s1,a5
    80007730:	06f5e463          	bltu	a1,a5,80007798 <freerange+0xa8>
    80007734:	00089a97          	auipc	s5,0x89
    80007738:	49ca8a93          	addi	s5,s5,1180 # 80090bd0 <end>
    8000773c:	0954e263          	bltu	s1,s5,800077c0 <freerange+0xd0>
    80007740:	01100993          	li	s3,17
    80007744:	01b99993          	slli	s3,s3,0x1b
    80007748:	0734fc63          	bgeu	s1,s3,800077c0 <freerange+0xd0>
    8000774c:	00058a13          	mv	s4,a1
    80007750:	00004917          	auipc	s2,0x4
    80007754:	c5890913          	addi	s2,s2,-936 # 8000b3a8 <kmem>
    80007758:	00002b37          	lui	s6,0x2
    8000775c:	0140006f          	j	80007770 <freerange+0x80>
    80007760:	000017b7          	lui	a5,0x1
    80007764:	00f484b3          	add	s1,s1,a5
    80007768:	0554ec63          	bltu	s1,s5,800077c0 <freerange+0xd0>
    8000776c:	0534fa63          	bgeu	s1,s3,800077c0 <freerange+0xd0>
    80007770:	00001637          	lui	a2,0x1
    80007774:	00100593          	li	a1,1
    80007778:	00048513          	mv	a0,s1
    8000777c:	00000097          	auipc	ra,0x0
    80007780:	50c080e7          	jalr	1292(ra) # 80007c88 <__memset>
    80007784:	00093703          	ld	a4,0(s2)
    80007788:	016487b3          	add	a5,s1,s6
    8000778c:	00e4b023          	sd	a4,0(s1)
    80007790:	00993023          	sd	s1,0(s2)
    80007794:	fcfa76e3          	bgeu	s4,a5,80007760 <freerange+0x70>
    80007798:	03813083          	ld	ra,56(sp)
    8000779c:	03013403          	ld	s0,48(sp)
    800077a0:	02813483          	ld	s1,40(sp)
    800077a4:	02013903          	ld	s2,32(sp)
    800077a8:	01813983          	ld	s3,24(sp)
    800077ac:	01013a03          	ld	s4,16(sp)
    800077b0:	00813a83          	ld	s5,8(sp)
    800077b4:	00013b03          	ld	s6,0(sp)
    800077b8:	04010113          	addi	sp,sp,64
    800077bc:	00008067          	ret
    800077c0:	00002517          	auipc	a0,0x2
    800077c4:	e9850513          	addi	a0,a0,-360 # 80009658 <digits+0x18>
    800077c8:	fffff097          	auipc	ra,0xfffff
    800077cc:	3d4080e7          	jalr	980(ra) # 80006b9c <panic>

00000000800077d0 <kfree>:
    800077d0:	fe010113          	addi	sp,sp,-32
    800077d4:	00813823          	sd	s0,16(sp)
    800077d8:	00113c23          	sd	ra,24(sp)
    800077dc:	00913423          	sd	s1,8(sp)
    800077e0:	02010413          	addi	s0,sp,32
    800077e4:	03451793          	slli	a5,a0,0x34
    800077e8:	04079c63          	bnez	a5,80007840 <kfree+0x70>
    800077ec:	00089797          	auipc	a5,0x89
    800077f0:	3e478793          	addi	a5,a5,996 # 80090bd0 <end>
    800077f4:	00050493          	mv	s1,a0
    800077f8:	04f56463          	bltu	a0,a5,80007840 <kfree+0x70>
    800077fc:	01100793          	li	a5,17
    80007800:	01b79793          	slli	a5,a5,0x1b
    80007804:	02f57e63          	bgeu	a0,a5,80007840 <kfree+0x70>
    80007808:	00001637          	lui	a2,0x1
    8000780c:	00100593          	li	a1,1
    80007810:	00000097          	auipc	ra,0x0
    80007814:	478080e7          	jalr	1144(ra) # 80007c88 <__memset>
    80007818:	00004797          	auipc	a5,0x4
    8000781c:	b9078793          	addi	a5,a5,-1136 # 8000b3a8 <kmem>
    80007820:	0007b703          	ld	a4,0(a5)
    80007824:	01813083          	ld	ra,24(sp)
    80007828:	01013403          	ld	s0,16(sp)
    8000782c:	00e4b023          	sd	a4,0(s1)
    80007830:	0097b023          	sd	s1,0(a5)
    80007834:	00813483          	ld	s1,8(sp)
    80007838:	02010113          	addi	sp,sp,32
    8000783c:	00008067          	ret
    80007840:	00002517          	auipc	a0,0x2
    80007844:	e1850513          	addi	a0,a0,-488 # 80009658 <digits+0x18>
    80007848:	fffff097          	auipc	ra,0xfffff
    8000784c:	354080e7          	jalr	852(ra) # 80006b9c <panic>

0000000080007850 <kalloc>:
    80007850:	fe010113          	addi	sp,sp,-32
    80007854:	00813823          	sd	s0,16(sp)
    80007858:	00913423          	sd	s1,8(sp)
    8000785c:	00113c23          	sd	ra,24(sp)
    80007860:	02010413          	addi	s0,sp,32
    80007864:	00004797          	auipc	a5,0x4
    80007868:	b4478793          	addi	a5,a5,-1212 # 8000b3a8 <kmem>
    8000786c:	0007b483          	ld	s1,0(a5)
    80007870:	02048063          	beqz	s1,80007890 <kalloc+0x40>
    80007874:	0004b703          	ld	a4,0(s1)
    80007878:	00001637          	lui	a2,0x1
    8000787c:	00500593          	li	a1,5
    80007880:	00048513          	mv	a0,s1
    80007884:	00e7b023          	sd	a4,0(a5)
    80007888:	00000097          	auipc	ra,0x0
    8000788c:	400080e7          	jalr	1024(ra) # 80007c88 <__memset>
    80007890:	01813083          	ld	ra,24(sp)
    80007894:	01013403          	ld	s0,16(sp)
    80007898:	00048513          	mv	a0,s1
    8000789c:	00813483          	ld	s1,8(sp)
    800078a0:	02010113          	addi	sp,sp,32
    800078a4:	00008067          	ret

00000000800078a8 <initlock>:
    800078a8:	ff010113          	addi	sp,sp,-16
    800078ac:	00813423          	sd	s0,8(sp)
    800078b0:	01010413          	addi	s0,sp,16
    800078b4:	00813403          	ld	s0,8(sp)
    800078b8:	00b53423          	sd	a1,8(a0)
    800078bc:	00052023          	sw	zero,0(a0)
    800078c0:	00053823          	sd	zero,16(a0)
    800078c4:	01010113          	addi	sp,sp,16
    800078c8:	00008067          	ret

00000000800078cc <acquire>:
    800078cc:	fe010113          	addi	sp,sp,-32
    800078d0:	00813823          	sd	s0,16(sp)
    800078d4:	00913423          	sd	s1,8(sp)
    800078d8:	00113c23          	sd	ra,24(sp)
    800078dc:	01213023          	sd	s2,0(sp)
    800078e0:	02010413          	addi	s0,sp,32
    800078e4:	00050493          	mv	s1,a0
    800078e8:	10002973          	csrr	s2,sstatus
    800078ec:	100027f3          	csrr	a5,sstatus
    800078f0:	ffd7f793          	andi	a5,a5,-3
    800078f4:	10079073          	csrw	sstatus,a5
    800078f8:	fffff097          	auipc	ra,0xfffff
    800078fc:	8e8080e7          	jalr	-1816(ra) # 800061e0 <mycpu>
    80007900:	07852783          	lw	a5,120(a0)
    80007904:	06078e63          	beqz	a5,80007980 <acquire+0xb4>
    80007908:	fffff097          	auipc	ra,0xfffff
    8000790c:	8d8080e7          	jalr	-1832(ra) # 800061e0 <mycpu>
    80007910:	07852783          	lw	a5,120(a0)
    80007914:	0004a703          	lw	a4,0(s1)
    80007918:	0017879b          	addiw	a5,a5,1
    8000791c:	06f52c23          	sw	a5,120(a0)
    80007920:	04071063          	bnez	a4,80007960 <acquire+0x94>
    80007924:	00100713          	li	a4,1
    80007928:	00070793          	mv	a5,a4
    8000792c:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80007930:	0007879b          	sext.w	a5,a5
    80007934:	fe079ae3          	bnez	a5,80007928 <acquire+0x5c>
    80007938:	0ff0000f          	fence
    8000793c:	fffff097          	auipc	ra,0xfffff
    80007940:	8a4080e7          	jalr	-1884(ra) # 800061e0 <mycpu>
    80007944:	01813083          	ld	ra,24(sp)
    80007948:	01013403          	ld	s0,16(sp)
    8000794c:	00a4b823          	sd	a0,16(s1)
    80007950:	00013903          	ld	s2,0(sp)
    80007954:	00813483          	ld	s1,8(sp)
    80007958:	02010113          	addi	sp,sp,32
    8000795c:	00008067          	ret
    80007960:	0104b903          	ld	s2,16(s1)
    80007964:	fffff097          	auipc	ra,0xfffff
    80007968:	87c080e7          	jalr	-1924(ra) # 800061e0 <mycpu>
    8000796c:	faa91ce3          	bne	s2,a0,80007924 <acquire+0x58>
    80007970:	00002517          	auipc	a0,0x2
    80007974:	cf050513          	addi	a0,a0,-784 # 80009660 <digits+0x20>
    80007978:	fffff097          	auipc	ra,0xfffff
    8000797c:	224080e7          	jalr	548(ra) # 80006b9c <panic>
    80007980:	00195913          	srli	s2,s2,0x1
    80007984:	fffff097          	auipc	ra,0xfffff
    80007988:	85c080e7          	jalr	-1956(ra) # 800061e0 <mycpu>
    8000798c:	00197913          	andi	s2,s2,1
    80007990:	07252e23          	sw	s2,124(a0)
    80007994:	f75ff06f          	j	80007908 <acquire+0x3c>

0000000080007998 <release>:
    80007998:	fe010113          	addi	sp,sp,-32
    8000799c:	00813823          	sd	s0,16(sp)
    800079a0:	00113c23          	sd	ra,24(sp)
    800079a4:	00913423          	sd	s1,8(sp)
    800079a8:	01213023          	sd	s2,0(sp)
    800079ac:	02010413          	addi	s0,sp,32
    800079b0:	00052783          	lw	a5,0(a0)
    800079b4:	00079a63          	bnez	a5,800079c8 <release+0x30>
    800079b8:	00002517          	auipc	a0,0x2
    800079bc:	cb050513          	addi	a0,a0,-848 # 80009668 <digits+0x28>
    800079c0:	fffff097          	auipc	ra,0xfffff
    800079c4:	1dc080e7          	jalr	476(ra) # 80006b9c <panic>
    800079c8:	01053903          	ld	s2,16(a0)
    800079cc:	00050493          	mv	s1,a0
    800079d0:	fffff097          	auipc	ra,0xfffff
    800079d4:	810080e7          	jalr	-2032(ra) # 800061e0 <mycpu>
    800079d8:	fea910e3          	bne	s2,a0,800079b8 <release+0x20>
    800079dc:	0004b823          	sd	zero,16(s1)
    800079e0:	0ff0000f          	fence
    800079e4:	0f50000f          	fence	iorw,ow
    800079e8:	0804a02f          	amoswap.w	zero,zero,(s1)
    800079ec:	ffffe097          	auipc	ra,0xffffe
    800079f0:	7f4080e7          	jalr	2036(ra) # 800061e0 <mycpu>
    800079f4:	100027f3          	csrr	a5,sstatus
    800079f8:	0027f793          	andi	a5,a5,2
    800079fc:	04079a63          	bnez	a5,80007a50 <release+0xb8>
    80007a00:	07852783          	lw	a5,120(a0)
    80007a04:	02f05e63          	blez	a5,80007a40 <release+0xa8>
    80007a08:	fff7871b          	addiw	a4,a5,-1
    80007a0c:	06e52c23          	sw	a4,120(a0)
    80007a10:	00071c63          	bnez	a4,80007a28 <release+0x90>
    80007a14:	07c52783          	lw	a5,124(a0)
    80007a18:	00078863          	beqz	a5,80007a28 <release+0x90>
    80007a1c:	100027f3          	csrr	a5,sstatus
    80007a20:	0027e793          	ori	a5,a5,2
    80007a24:	10079073          	csrw	sstatus,a5
    80007a28:	01813083          	ld	ra,24(sp)
    80007a2c:	01013403          	ld	s0,16(sp)
    80007a30:	00813483          	ld	s1,8(sp)
    80007a34:	00013903          	ld	s2,0(sp)
    80007a38:	02010113          	addi	sp,sp,32
    80007a3c:	00008067          	ret
    80007a40:	00002517          	auipc	a0,0x2
    80007a44:	c4850513          	addi	a0,a0,-952 # 80009688 <digits+0x48>
    80007a48:	fffff097          	auipc	ra,0xfffff
    80007a4c:	154080e7          	jalr	340(ra) # 80006b9c <panic>
    80007a50:	00002517          	auipc	a0,0x2
    80007a54:	c2050513          	addi	a0,a0,-992 # 80009670 <digits+0x30>
    80007a58:	fffff097          	auipc	ra,0xfffff
    80007a5c:	144080e7          	jalr	324(ra) # 80006b9c <panic>

0000000080007a60 <holding>:
    80007a60:	00052783          	lw	a5,0(a0)
    80007a64:	00079663          	bnez	a5,80007a70 <holding+0x10>
    80007a68:	00000513          	li	a0,0
    80007a6c:	00008067          	ret
    80007a70:	fe010113          	addi	sp,sp,-32
    80007a74:	00813823          	sd	s0,16(sp)
    80007a78:	00913423          	sd	s1,8(sp)
    80007a7c:	00113c23          	sd	ra,24(sp)
    80007a80:	02010413          	addi	s0,sp,32
    80007a84:	01053483          	ld	s1,16(a0)
    80007a88:	ffffe097          	auipc	ra,0xffffe
    80007a8c:	758080e7          	jalr	1880(ra) # 800061e0 <mycpu>
    80007a90:	01813083          	ld	ra,24(sp)
    80007a94:	01013403          	ld	s0,16(sp)
    80007a98:	40a48533          	sub	a0,s1,a0
    80007a9c:	00153513          	seqz	a0,a0
    80007aa0:	00813483          	ld	s1,8(sp)
    80007aa4:	02010113          	addi	sp,sp,32
    80007aa8:	00008067          	ret

0000000080007aac <push_off>:
    80007aac:	fe010113          	addi	sp,sp,-32
    80007ab0:	00813823          	sd	s0,16(sp)
    80007ab4:	00113c23          	sd	ra,24(sp)
    80007ab8:	00913423          	sd	s1,8(sp)
    80007abc:	02010413          	addi	s0,sp,32
    80007ac0:	100024f3          	csrr	s1,sstatus
    80007ac4:	100027f3          	csrr	a5,sstatus
    80007ac8:	ffd7f793          	andi	a5,a5,-3
    80007acc:	10079073          	csrw	sstatus,a5
    80007ad0:	ffffe097          	auipc	ra,0xffffe
    80007ad4:	710080e7          	jalr	1808(ra) # 800061e0 <mycpu>
    80007ad8:	07852783          	lw	a5,120(a0)
    80007adc:	02078663          	beqz	a5,80007b08 <push_off+0x5c>
    80007ae0:	ffffe097          	auipc	ra,0xffffe
    80007ae4:	700080e7          	jalr	1792(ra) # 800061e0 <mycpu>
    80007ae8:	07852783          	lw	a5,120(a0)
    80007aec:	01813083          	ld	ra,24(sp)
    80007af0:	01013403          	ld	s0,16(sp)
    80007af4:	0017879b          	addiw	a5,a5,1
    80007af8:	06f52c23          	sw	a5,120(a0)
    80007afc:	00813483          	ld	s1,8(sp)
    80007b00:	02010113          	addi	sp,sp,32
    80007b04:	00008067          	ret
    80007b08:	0014d493          	srli	s1,s1,0x1
    80007b0c:	ffffe097          	auipc	ra,0xffffe
    80007b10:	6d4080e7          	jalr	1748(ra) # 800061e0 <mycpu>
    80007b14:	0014f493          	andi	s1,s1,1
    80007b18:	06952e23          	sw	s1,124(a0)
    80007b1c:	fc5ff06f          	j	80007ae0 <push_off+0x34>

0000000080007b20 <pop_off>:
    80007b20:	ff010113          	addi	sp,sp,-16
    80007b24:	00813023          	sd	s0,0(sp)
    80007b28:	00113423          	sd	ra,8(sp)
    80007b2c:	01010413          	addi	s0,sp,16
    80007b30:	ffffe097          	auipc	ra,0xffffe
    80007b34:	6b0080e7          	jalr	1712(ra) # 800061e0 <mycpu>
    80007b38:	100027f3          	csrr	a5,sstatus
    80007b3c:	0027f793          	andi	a5,a5,2
    80007b40:	04079663          	bnez	a5,80007b8c <pop_off+0x6c>
    80007b44:	07852783          	lw	a5,120(a0)
    80007b48:	02f05a63          	blez	a5,80007b7c <pop_off+0x5c>
    80007b4c:	fff7871b          	addiw	a4,a5,-1
    80007b50:	06e52c23          	sw	a4,120(a0)
    80007b54:	00071c63          	bnez	a4,80007b6c <pop_off+0x4c>
    80007b58:	07c52783          	lw	a5,124(a0)
    80007b5c:	00078863          	beqz	a5,80007b6c <pop_off+0x4c>
    80007b60:	100027f3          	csrr	a5,sstatus
    80007b64:	0027e793          	ori	a5,a5,2
    80007b68:	10079073          	csrw	sstatus,a5
    80007b6c:	00813083          	ld	ra,8(sp)
    80007b70:	00013403          	ld	s0,0(sp)
    80007b74:	01010113          	addi	sp,sp,16
    80007b78:	00008067          	ret
    80007b7c:	00002517          	auipc	a0,0x2
    80007b80:	b0c50513          	addi	a0,a0,-1268 # 80009688 <digits+0x48>
    80007b84:	fffff097          	auipc	ra,0xfffff
    80007b88:	018080e7          	jalr	24(ra) # 80006b9c <panic>
    80007b8c:	00002517          	auipc	a0,0x2
    80007b90:	ae450513          	addi	a0,a0,-1308 # 80009670 <digits+0x30>
    80007b94:	fffff097          	auipc	ra,0xfffff
    80007b98:	008080e7          	jalr	8(ra) # 80006b9c <panic>

0000000080007b9c <push_on>:
    80007b9c:	fe010113          	addi	sp,sp,-32
    80007ba0:	00813823          	sd	s0,16(sp)
    80007ba4:	00113c23          	sd	ra,24(sp)
    80007ba8:	00913423          	sd	s1,8(sp)
    80007bac:	02010413          	addi	s0,sp,32
    80007bb0:	100024f3          	csrr	s1,sstatus
    80007bb4:	100027f3          	csrr	a5,sstatus
    80007bb8:	0027e793          	ori	a5,a5,2
    80007bbc:	10079073          	csrw	sstatus,a5
    80007bc0:	ffffe097          	auipc	ra,0xffffe
    80007bc4:	620080e7          	jalr	1568(ra) # 800061e0 <mycpu>
    80007bc8:	07852783          	lw	a5,120(a0)
    80007bcc:	02078663          	beqz	a5,80007bf8 <push_on+0x5c>
    80007bd0:	ffffe097          	auipc	ra,0xffffe
    80007bd4:	610080e7          	jalr	1552(ra) # 800061e0 <mycpu>
    80007bd8:	07852783          	lw	a5,120(a0)
    80007bdc:	01813083          	ld	ra,24(sp)
    80007be0:	01013403          	ld	s0,16(sp)
    80007be4:	0017879b          	addiw	a5,a5,1
    80007be8:	06f52c23          	sw	a5,120(a0)
    80007bec:	00813483          	ld	s1,8(sp)
    80007bf0:	02010113          	addi	sp,sp,32
    80007bf4:	00008067          	ret
    80007bf8:	0014d493          	srli	s1,s1,0x1
    80007bfc:	ffffe097          	auipc	ra,0xffffe
    80007c00:	5e4080e7          	jalr	1508(ra) # 800061e0 <mycpu>
    80007c04:	0014f493          	andi	s1,s1,1
    80007c08:	06952e23          	sw	s1,124(a0)
    80007c0c:	fc5ff06f          	j	80007bd0 <push_on+0x34>

0000000080007c10 <pop_on>:
    80007c10:	ff010113          	addi	sp,sp,-16
    80007c14:	00813023          	sd	s0,0(sp)
    80007c18:	00113423          	sd	ra,8(sp)
    80007c1c:	01010413          	addi	s0,sp,16
    80007c20:	ffffe097          	auipc	ra,0xffffe
    80007c24:	5c0080e7          	jalr	1472(ra) # 800061e0 <mycpu>
    80007c28:	100027f3          	csrr	a5,sstatus
    80007c2c:	0027f793          	andi	a5,a5,2
    80007c30:	04078463          	beqz	a5,80007c78 <pop_on+0x68>
    80007c34:	07852783          	lw	a5,120(a0)
    80007c38:	02f05863          	blez	a5,80007c68 <pop_on+0x58>
    80007c3c:	fff7879b          	addiw	a5,a5,-1
    80007c40:	06f52c23          	sw	a5,120(a0)
    80007c44:	07853783          	ld	a5,120(a0)
    80007c48:	00079863          	bnez	a5,80007c58 <pop_on+0x48>
    80007c4c:	100027f3          	csrr	a5,sstatus
    80007c50:	ffd7f793          	andi	a5,a5,-3
    80007c54:	10079073          	csrw	sstatus,a5
    80007c58:	00813083          	ld	ra,8(sp)
    80007c5c:	00013403          	ld	s0,0(sp)
    80007c60:	01010113          	addi	sp,sp,16
    80007c64:	00008067          	ret
    80007c68:	00002517          	auipc	a0,0x2
    80007c6c:	a4850513          	addi	a0,a0,-1464 # 800096b0 <digits+0x70>
    80007c70:	fffff097          	auipc	ra,0xfffff
    80007c74:	f2c080e7          	jalr	-212(ra) # 80006b9c <panic>
    80007c78:	00002517          	auipc	a0,0x2
    80007c7c:	a1850513          	addi	a0,a0,-1512 # 80009690 <digits+0x50>
    80007c80:	fffff097          	auipc	ra,0xfffff
    80007c84:	f1c080e7          	jalr	-228(ra) # 80006b9c <panic>

0000000080007c88 <__memset>:
    80007c88:	ff010113          	addi	sp,sp,-16
    80007c8c:	00813423          	sd	s0,8(sp)
    80007c90:	01010413          	addi	s0,sp,16
    80007c94:	1a060e63          	beqz	a2,80007e50 <__memset+0x1c8>
    80007c98:	40a007b3          	neg	a5,a0
    80007c9c:	0077f793          	andi	a5,a5,7
    80007ca0:	00778693          	addi	a3,a5,7
    80007ca4:	00b00813          	li	a6,11
    80007ca8:	0ff5f593          	andi	a1,a1,255
    80007cac:	fff6071b          	addiw	a4,a2,-1
    80007cb0:	1b06e663          	bltu	a3,a6,80007e5c <__memset+0x1d4>
    80007cb4:	1cd76463          	bltu	a4,a3,80007e7c <__memset+0x1f4>
    80007cb8:	1a078e63          	beqz	a5,80007e74 <__memset+0x1ec>
    80007cbc:	00b50023          	sb	a1,0(a0)
    80007cc0:	00100713          	li	a4,1
    80007cc4:	1ae78463          	beq	a5,a4,80007e6c <__memset+0x1e4>
    80007cc8:	00b500a3          	sb	a1,1(a0)
    80007ccc:	00200713          	li	a4,2
    80007cd0:	1ae78a63          	beq	a5,a4,80007e84 <__memset+0x1fc>
    80007cd4:	00b50123          	sb	a1,2(a0)
    80007cd8:	00300713          	li	a4,3
    80007cdc:	18e78463          	beq	a5,a4,80007e64 <__memset+0x1dc>
    80007ce0:	00b501a3          	sb	a1,3(a0)
    80007ce4:	00400713          	li	a4,4
    80007ce8:	1ae78263          	beq	a5,a4,80007e8c <__memset+0x204>
    80007cec:	00b50223          	sb	a1,4(a0)
    80007cf0:	00500713          	li	a4,5
    80007cf4:	1ae78063          	beq	a5,a4,80007e94 <__memset+0x20c>
    80007cf8:	00b502a3          	sb	a1,5(a0)
    80007cfc:	00700713          	li	a4,7
    80007d00:	18e79e63          	bne	a5,a4,80007e9c <__memset+0x214>
    80007d04:	00b50323          	sb	a1,6(a0)
    80007d08:	00700e93          	li	t4,7
    80007d0c:	00859713          	slli	a4,a1,0x8
    80007d10:	00e5e733          	or	a4,a1,a4
    80007d14:	01059e13          	slli	t3,a1,0x10
    80007d18:	01c76e33          	or	t3,a4,t3
    80007d1c:	01859313          	slli	t1,a1,0x18
    80007d20:	006e6333          	or	t1,t3,t1
    80007d24:	02059893          	slli	a7,a1,0x20
    80007d28:	40f60e3b          	subw	t3,a2,a5
    80007d2c:	011368b3          	or	a7,t1,a7
    80007d30:	02859813          	slli	a6,a1,0x28
    80007d34:	0108e833          	or	a6,a7,a6
    80007d38:	03059693          	slli	a3,a1,0x30
    80007d3c:	003e589b          	srliw	a7,t3,0x3
    80007d40:	00d866b3          	or	a3,a6,a3
    80007d44:	03859713          	slli	a4,a1,0x38
    80007d48:	00389813          	slli	a6,a7,0x3
    80007d4c:	00f507b3          	add	a5,a0,a5
    80007d50:	00e6e733          	or	a4,a3,a4
    80007d54:	000e089b          	sext.w	a7,t3
    80007d58:	00f806b3          	add	a3,a6,a5
    80007d5c:	00e7b023          	sd	a4,0(a5)
    80007d60:	00878793          	addi	a5,a5,8
    80007d64:	fed79ce3          	bne	a5,a3,80007d5c <__memset+0xd4>
    80007d68:	ff8e7793          	andi	a5,t3,-8
    80007d6c:	0007871b          	sext.w	a4,a5
    80007d70:	01d787bb          	addw	a5,a5,t4
    80007d74:	0ce88e63          	beq	a7,a4,80007e50 <__memset+0x1c8>
    80007d78:	00f50733          	add	a4,a0,a5
    80007d7c:	00b70023          	sb	a1,0(a4)
    80007d80:	0017871b          	addiw	a4,a5,1
    80007d84:	0cc77663          	bgeu	a4,a2,80007e50 <__memset+0x1c8>
    80007d88:	00e50733          	add	a4,a0,a4
    80007d8c:	00b70023          	sb	a1,0(a4)
    80007d90:	0027871b          	addiw	a4,a5,2
    80007d94:	0ac77e63          	bgeu	a4,a2,80007e50 <__memset+0x1c8>
    80007d98:	00e50733          	add	a4,a0,a4
    80007d9c:	00b70023          	sb	a1,0(a4)
    80007da0:	0037871b          	addiw	a4,a5,3
    80007da4:	0ac77663          	bgeu	a4,a2,80007e50 <__memset+0x1c8>
    80007da8:	00e50733          	add	a4,a0,a4
    80007dac:	00b70023          	sb	a1,0(a4)
    80007db0:	0047871b          	addiw	a4,a5,4
    80007db4:	08c77e63          	bgeu	a4,a2,80007e50 <__memset+0x1c8>
    80007db8:	00e50733          	add	a4,a0,a4
    80007dbc:	00b70023          	sb	a1,0(a4)
    80007dc0:	0057871b          	addiw	a4,a5,5
    80007dc4:	08c77663          	bgeu	a4,a2,80007e50 <__memset+0x1c8>
    80007dc8:	00e50733          	add	a4,a0,a4
    80007dcc:	00b70023          	sb	a1,0(a4)
    80007dd0:	0067871b          	addiw	a4,a5,6
    80007dd4:	06c77e63          	bgeu	a4,a2,80007e50 <__memset+0x1c8>
    80007dd8:	00e50733          	add	a4,a0,a4
    80007ddc:	00b70023          	sb	a1,0(a4)
    80007de0:	0077871b          	addiw	a4,a5,7
    80007de4:	06c77663          	bgeu	a4,a2,80007e50 <__memset+0x1c8>
    80007de8:	00e50733          	add	a4,a0,a4
    80007dec:	00b70023          	sb	a1,0(a4)
    80007df0:	0087871b          	addiw	a4,a5,8
    80007df4:	04c77e63          	bgeu	a4,a2,80007e50 <__memset+0x1c8>
    80007df8:	00e50733          	add	a4,a0,a4
    80007dfc:	00b70023          	sb	a1,0(a4)
    80007e00:	0097871b          	addiw	a4,a5,9
    80007e04:	04c77663          	bgeu	a4,a2,80007e50 <__memset+0x1c8>
    80007e08:	00e50733          	add	a4,a0,a4
    80007e0c:	00b70023          	sb	a1,0(a4)
    80007e10:	00a7871b          	addiw	a4,a5,10
    80007e14:	02c77e63          	bgeu	a4,a2,80007e50 <__memset+0x1c8>
    80007e18:	00e50733          	add	a4,a0,a4
    80007e1c:	00b70023          	sb	a1,0(a4)
    80007e20:	00b7871b          	addiw	a4,a5,11
    80007e24:	02c77663          	bgeu	a4,a2,80007e50 <__memset+0x1c8>
    80007e28:	00e50733          	add	a4,a0,a4
    80007e2c:	00b70023          	sb	a1,0(a4)
    80007e30:	00c7871b          	addiw	a4,a5,12
    80007e34:	00c77e63          	bgeu	a4,a2,80007e50 <__memset+0x1c8>
    80007e38:	00e50733          	add	a4,a0,a4
    80007e3c:	00b70023          	sb	a1,0(a4)
    80007e40:	00d7879b          	addiw	a5,a5,13
    80007e44:	00c7f663          	bgeu	a5,a2,80007e50 <__memset+0x1c8>
    80007e48:	00f507b3          	add	a5,a0,a5
    80007e4c:	00b78023          	sb	a1,0(a5)
    80007e50:	00813403          	ld	s0,8(sp)
    80007e54:	01010113          	addi	sp,sp,16
    80007e58:	00008067          	ret
    80007e5c:	00b00693          	li	a3,11
    80007e60:	e55ff06f          	j	80007cb4 <__memset+0x2c>
    80007e64:	00300e93          	li	t4,3
    80007e68:	ea5ff06f          	j	80007d0c <__memset+0x84>
    80007e6c:	00100e93          	li	t4,1
    80007e70:	e9dff06f          	j	80007d0c <__memset+0x84>
    80007e74:	00000e93          	li	t4,0
    80007e78:	e95ff06f          	j	80007d0c <__memset+0x84>
    80007e7c:	00000793          	li	a5,0
    80007e80:	ef9ff06f          	j	80007d78 <__memset+0xf0>
    80007e84:	00200e93          	li	t4,2
    80007e88:	e85ff06f          	j	80007d0c <__memset+0x84>
    80007e8c:	00400e93          	li	t4,4
    80007e90:	e7dff06f          	j	80007d0c <__memset+0x84>
    80007e94:	00500e93          	li	t4,5
    80007e98:	e75ff06f          	j	80007d0c <__memset+0x84>
    80007e9c:	00600e93          	li	t4,6
    80007ea0:	e6dff06f          	j	80007d0c <__memset+0x84>

0000000080007ea4 <__memmove>:
    80007ea4:	ff010113          	addi	sp,sp,-16
    80007ea8:	00813423          	sd	s0,8(sp)
    80007eac:	01010413          	addi	s0,sp,16
    80007eb0:	0e060863          	beqz	a2,80007fa0 <__memmove+0xfc>
    80007eb4:	fff6069b          	addiw	a3,a2,-1
    80007eb8:	0006881b          	sext.w	a6,a3
    80007ebc:	0ea5e863          	bltu	a1,a0,80007fac <__memmove+0x108>
    80007ec0:	00758713          	addi	a4,a1,7
    80007ec4:	00a5e7b3          	or	a5,a1,a0
    80007ec8:	40a70733          	sub	a4,a4,a0
    80007ecc:	0077f793          	andi	a5,a5,7
    80007ed0:	00f73713          	sltiu	a4,a4,15
    80007ed4:	00174713          	xori	a4,a4,1
    80007ed8:	0017b793          	seqz	a5,a5
    80007edc:	00e7f7b3          	and	a5,a5,a4
    80007ee0:	10078863          	beqz	a5,80007ff0 <__memmove+0x14c>
    80007ee4:	00900793          	li	a5,9
    80007ee8:	1107f463          	bgeu	a5,a6,80007ff0 <__memmove+0x14c>
    80007eec:	0036581b          	srliw	a6,a2,0x3
    80007ef0:	fff8081b          	addiw	a6,a6,-1
    80007ef4:	02081813          	slli	a6,a6,0x20
    80007ef8:	01d85893          	srli	a7,a6,0x1d
    80007efc:	00858813          	addi	a6,a1,8
    80007f00:	00058793          	mv	a5,a1
    80007f04:	00050713          	mv	a4,a0
    80007f08:	01088833          	add	a6,a7,a6
    80007f0c:	0007b883          	ld	a7,0(a5)
    80007f10:	00878793          	addi	a5,a5,8
    80007f14:	00870713          	addi	a4,a4,8
    80007f18:	ff173c23          	sd	a7,-8(a4)
    80007f1c:	ff0798e3          	bne	a5,a6,80007f0c <__memmove+0x68>
    80007f20:	ff867713          	andi	a4,a2,-8
    80007f24:	02071793          	slli	a5,a4,0x20
    80007f28:	0207d793          	srli	a5,a5,0x20
    80007f2c:	00f585b3          	add	a1,a1,a5
    80007f30:	40e686bb          	subw	a3,a3,a4
    80007f34:	00f507b3          	add	a5,a0,a5
    80007f38:	06e60463          	beq	a2,a4,80007fa0 <__memmove+0xfc>
    80007f3c:	0005c703          	lbu	a4,0(a1)
    80007f40:	00e78023          	sb	a4,0(a5)
    80007f44:	04068e63          	beqz	a3,80007fa0 <__memmove+0xfc>
    80007f48:	0015c603          	lbu	a2,1(a1)
    80007f4c:	00100713          	li	a4,1
    80007f50:	00c780a3          	sb	a2,1(a5)
    80007f54:	04e68663          	beq	a3,a4,80007fa0 <__memmove+0xfc>
    80007f58:	0025c603          	lbu	a2,2(a1)
    80007f5c:	00200713          	li	a4,2
    80007f60:	00c78123          	sb	a2,2(a5)
    80007f64:	02e68e63          	beq	a3,a4,80007fa0 <__memmove+0xfc>
    80007f68:	0035c603          	lbu	a2,3(a1)
    80007f6c:	00300713          	li	a4,3
    80007f70:	00c781a3          	sb	a2,3(a5)
    80007f74:	02e68663          	beq	a3,a4,80007fa0 <__memmove+0xfc>
    80007f78:	0045c603          	lbu	a2,4(a1)
    80007f7c:	00400713          	li	a4,4
    80007f80:	00c78223          	sb	a2,4(a5)
    80007f84:	00e68e63          	beq	a3,a4,80007fa0 <__memmove+0xfc>
    80007f88:	0055c603          	lbu	a2,5(a1)
    80007f8c:	00500713          	li	a4,5
    80007f90:	00c782a3          	sb	a2,5(a5)
    80007f94:	00e68663          	beq	a3,a4,80007fa0 <__memmove+0xfc>
    80007f98:	0065c703          	lbu	a4,6(a1)
    80007f9c:	00e78323          	sb	a4,6(a5)
    80007fa0:	00813403          	ld	s0,8(sp)
    80007fa4:	01010113          	addi	sp,sp,16
    80007fa8:	00008067          	ret
    80007fac:	02061713          	slli	a4,a2,0x20
    80007fb0:	02075713          	srli	a4,a4,0x20
    80007fb4:	00e587b3          	add	a5,a1,a4
    80007fb8:	f0f574e3          	bgeu	a0,a5,80007ec0 <__memmove+0x1c>
    80007fbc:	02069613          	slli	a2,a3,0x20
    80007fc0:	02065613          	srli	a2,a2,0x20
    80007fc4:	fff64613          	not	a2,a2
    80007fc8:	00e50733          	add	a4,a0,a4
    80007fcc:	00c78633          	add	a2,a5,a2
    80007fd0:	fff7c683          	lbu	a3,-1(a5)
    80007fd4:	fff78793          	addi	a5,a5,-1
    80007fd8:	fff70713          	addi	a4,a4,-1
    80007fdc:	00d70023          	sb	a3,0(a4)
    80007fe0:	fec798e3          	bne	a5,a2,80007fd0 <__memmove+0x12c>
    80007fe4:	00813403          	ld	s0,8(sp)
    80007fe8:	01010113          	addi	sp,sp,16
    80007fec:	00008067          	ret
    80007ff0:	02069713          	slli	a4,a3,0x20
    80007ff4:	02075713          	srli	a4,a4,0x20
    80007ff8:	00170713          	addi	a4,a4,1
    80007ffc:	00e50733          	add	a4,a0,a4
    80008000:	00050793          	mv	a5,a0
    80008004:	0005c683          	lbu	a3,0(a1)
    80008008:	00178793          	addi	a5,a5,1
    8000800c:	00158593          	addi	a1,a1,1
    80008010:	fed78fa3          	sb	a3,-1(a5)
    80008014:	fee798e3          	bne	a5,a4,80008004 <__memmove+0x160>
    80008018:	f89ff06f          	j	80007fa0 <__memmove+0xfc>

000000008000801c <__putc>:
    8000801c:	fe010113          	addi	sp,sp,-32
    80008020:	00813823          	sd	s0,16(sp)
    80008024:	00113c23          	sd	ra,24(sp)
    80008028:	02010413          	addi	s0,sp,32
    8000802c:	00050793          	mv	a5,a0
    80008030:	fef40593          	addi	a1,s0,-17
    80008034:	00100613          	li	a2,1
    80008038:	00000513          	li	a0,0
    8000803c:	fef407a3          	sb	a5,-17(s0)
    80008040:	fffff097          	auipc	ra,0xfffff
    80008044:	b3c080e7          	jalr	-1220(ra) # 80006b7c <console_write>
    80008048:	01813083          	ld	ra,24(sp)
    8000804c:	01013403          	ld	s0,16(sp)
    80008050:	02010113          	addi	sp,sp,32
    80008054:	00008067          	ret

0000000080008058 <__getc>:
    80008058:	fe010113          	addi	sp,sp,-32
    8000805c:	00813823          	sd	s0,16(sp)
    80008060:	00113c23          	sd	ra,24(sp)
    80008064:	02010413          	addi	s0,sp,32
    80008068:	fe840593          	addi	a1,s0,-24
    8000806c:	00100613          	li	a2,1
    80008070:	00000513          	li	a0,0
    80008074:	fffff097          	auipc	ra,0xfffff
    80008078:	ae8080e7          	jalr	-1304(ra) # 80006b5c <console_read>
    8000807c:	fe844503          	lbu	a0,-24(s0)
    80008080:	01813083          	ld	ra,24(sp)
    80008084:	01013403          	ld	s0,16(sp)
    80008088:	02010113          	addi	sp,sp,32
    8000808c:	00008067          	ret

0000000080008090 <console_handler>:
    80008090:	fe010113          	addi	sp,sp,-32
    80008094:	00813823          	sd	s0,16(sp)
    80008098:	00113c23          	sd	ra,24(sp)
    8000809c:	00913423          	sd	s1,8(sp)
    800080a0:	02010413          	addi	s0,sp,32
    800080a4:	14202773          	csrr	a4,scause
    800080a8:	100027f3          	csrr	a5,sstatus
    800080ac:	0027f793          	andi	a5,a5,2
    800080b0:	06079e63          	bnez	a5,8000812c <console_handler+0x9c>
    800080b4:	00074c63          	bltz	a4,800080cc <console_handler+0x3c>
    800080b8:	01813083          	ld	ra,24(sp)
    800080bc:	01013403          	ld	s0,16(sp)
    800080c0:	00813483          	ld	s1,8(sp)
    800080c4:	02010113          	addi	sp,sp,32
    800080c8:	00008067          	ret
    800080cc:	0ff77713          	andi	a4,a4,255
    800080d0:	00900793          	li	a5,9
    800080d4:	fef712e3          	bne	a4,a5,800080b8 <console_handler+0x28>
    800080d8:	ffffe097          	auipc	ra,0xffffe
    800080dc:	6dc080e7          	jalr	1756(ra) # 800067b4 <plic_claim>
    800080e0:	00a00793          	li	a5,10
    800080e4:	00050493          	mv	s1,a0
    800080e8:	02f50c63          	beq	a0,a5,80008120 <console_handler+0x90>
    800080ec:	fc0506e3          	beqz	a0,800080b8 <console_handler+0x28>
    800080f0:	00050593          	mv	a1,a0
    800080f4:	00001517          	auipc	a0,0x1
    800080f8:	4c450513          	addi	a0,a0,1220 # 800095b8 <CONSOLE_STATUS+0x5a8>
    800080fc:	fffff097          	auipc	ra,0xfffff
    80008100:	afc080e7          	jalr	-1284(ra) # 80006bf8 <__printf>
    80008104:	01013403          	ld	s0,16(sp)
    80008108:	01813083          	ld	ra,24(sp)
    8000810c:	00048513          	mv	a0,s1
    80008110:	00813483          	ld	s1,8(sp)
    80008114:	02010113          	addi	sp,sp,32
    80008118:	ffffe317          	auipc	t1,0xffffe
    8000811c:	6d430067          	jr	1748(t1) # 800067ec <plic_complete>
    80008120:	fffff097          	auipc	ra,0xfffff
    80008124:	3e0080e7          	jalr	992(ra) # 80007500 <uartintr>
    80008128:	fddff06f          	j	80008104 <console_handler+0x74>
    8000812c:	00001517          	auipc	a0,0x1
    80008130:	58c50513          	addi	a0,a0,1420 # 800096b8 <digits+0x78>
    80008134:	fffff097          	auipc	ra,0xfffff
    80008138:	a68080e7          	jalr	-1432(ra) # 80006b9c <panic>
	...
