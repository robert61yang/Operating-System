
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00008117          	auipc	sp,0x8
    80000004:	c6013103          	ld	sp,-928(sp) # 80007c60 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	04a000ef          	jal	ra,80000060 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
#define MIE_STIE (1L << 5)  // supervisor timer
static inline uint64
r_mie()
{
  uint64 x;
  asm volatile("csrr %0, mie" : "=r" (x) );
    80000022:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80000026:	0207e793          	ori	a5,a5,32
}

static inline void 
w_mie(uint64 x)
{
  asm volatile("csrw mie, %0" : : "r" (x));
    8000002a:	30479073          	csrw	mie,a5
static inline uint64
r_menvcfg()
{
  uint64 x;
  // asm volatile("csrr %0, menvcfg" : "=r" (x) );
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    8000002e:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80000032:	577d                	li	a4,-1
    80000034:	177e                	slli	a4,a4,0x3f
    80000036:	8fd9                	or	a5,a5,a4

static inline void 
w_menvcfg(uint64 x)
{
  // asm volatile("csrw menvcfg, %0" : : "r" (x));
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80000038:	30a79073          	csrw	0x30a,a5

static inline uint64
r_mcounteren()
{
  uint64 x;
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    8000003c:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80000040:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80000044:	30679073          	csrw	mcounteren,a5
// machine-mode cycle counter
static inline uint64
r_time()
{
  uint64 x;
  asm volatile("csrr %0, time" : "=r" (x) );
    80000048:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    8000004c:	000f4737          	lui	a4,0xf4
    80000050:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80000054:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80000056:	14d79073          	csrw	0x14d,a5
}
    8000005a:	6422                	ld	s0,8(sp)
    8000005c:	0141                	addi	sp,sp,16
    8000005e:	8082                	ret

0000000080000060 <start>:
{
    80000060:	1141                	addi	sp,sp,-16
    80000062:	e406                	sd	ra,8(sp)
    80000064:	e022                	sd	s0,0(sp)
    80000066:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000068:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000006c:	7779                	lui	a4,0xffffe
    8000006e:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffc27ff>
    80000072:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80000074:	6705                	lui	a4,0x1
    80000076:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    8000007a:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000007c:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80000080:	00001797          	auipc	a5,0x1
    80000084:	db878793          	addi	a5,a5,-584 # 80000e38 <main>
    80000088:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    8000008c:	4781                	li	a5,0
    8000008e:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80000092:	67c1                	lui	a5,0x10
    80000094:	17fd                	addi	a5,a5,-1
    80000096:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    8000009a:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    8000009e:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000a2:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000a6:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800000aa:	57fd                	li	a5,-1
    800000ac:	83a9                	srli	a5,a5,0xa
    800000ae:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800000b2:	47bd                	li	a5,15
    800000b4:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000b8:	f65ff0ef          	jal	ra,8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000bc:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000c0:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000c2:	823e                	mv	tp,a5
  asm volatile("mret");
    800000c4:	30200073          	mret
}
    800000c8:	60a2                	ld	ra,8(sp)
    800000ca:	6402                	ld	s0,0(sp)
    800000cc:	0141                	addi	sp,sp,16
    800000ce:	8082                	ret

00000000800000d0 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800000d0:	715d                	addi	sp,sp,-80
    800000d2:	e486                	sd	ra,72(sp)
    800000d4:	e0a2                	sd	s0,64(sp)
    800000d6:	fc26                	sd	s1,56(sp)
    800000d8:	f84a                	sd	s2,48(sp)
    800000da:	f44e                	sd	s3,40(sp)
    800000dc:	f052                	sd	s4,32(sp)
    800000de:	ec56                	sd	s5,24(sp)
    800000e0:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    800000e2:	04c05263          	blez	a2,80000126 <consolewrite+0x56>
    800000e6:	8a2a                	mv	s4,a0
    800000e8:	84ae                	mv	s1,a1
    800000ea:	89b2                	mv	s3,a2
    800000ec:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800000ee:	5afd                	li	s5,-1
    800000f0:	4685                	li	a3,1
    800000f2:	8626                	mv	a2,s1
    800000f4:	85d2                	mv	a1,s4
    800000f6:	fbf40513          	addi	a0,s0,-65
    800000fa:	0d0020ef          	jal	ra,800021ca <either_copyin>
    800000fe:	01550a63          	beq	a0,s5,80000112 <consolewrite+0x42>
      break;
    uartputc(c);
    80000102:	fbf44503          	lbu	a0,-65(s0)
    80000106:	7da000ef          	jal	ra,800008e0 <uartputc>
  for(i = 0; i < n; i++){
    8000010a:	2905                	addiw	s2,s2,1
    8000010c:	0485                	addi	s1,s1,1
    8000010e:	ff2991e3          	bne	s3,s2,800000f0 <consolewrite+0x20>
  }

  return i;
}
    80000112:	854a                	mv	a0,s2
    80000114:	60a6                	ld	ra,72(sp)
    80000116:	6406                	ld	s0,64(sp)
    80000118:	74e2                	ld	s1,56(sp)
    8000011a:	7942                	ld	s2,48(sp)
    8000011c:	79a2                	ld	s3,40(sp)
    8000011e:	7a02                	ld	s4,32(sp)
    80000120:	6ae2                	ld	s5,24(sp)
    80000122:	6161                	addi	sp,sp,80
    80000124:	8082                	ret
  for(i = 0; i < n; i++){
    80000126:	4901                	li	s2,0
    80000128:	b7ed                	j	80000112 <consolewrite+0x42>

000000008000012a <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000012a:	7159                	addi	sp,sp,-112
    8000012c:	f486                	sd	ra,104(sp)
    8000012e:	f0a2                	sd	s0,96(sp)
    80000130:	eca6                	sd	s1,88(sp)
    80000132:	e8ca                	sd	s2,80(sp)
    80000134:	e4ce                	sd	s3,72(sp)
    80000136:	e0d2                	sd	s4,64(sp)
    80000138:	fc56                	sd	s5,56(sp)
    8000013a:	f85a                	sd	s6,48(sp)
    8000013c:	f45e                	sd	s7,40(sp)
    8000013e:	f062                	sd	s8,32(sp)
    80000140:	ec66                	sd	s9,24(sp)
    80000142:	e86a                	sd	s10,16(sp)
    80000144:	1880                	addi	s0,sp,112
    80000146:	8aaa                	mv	s5,a0
    80000148:	8a2e                	mv	s4,a1
    8000014a:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    8000014c:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80000150:	00010517          	auipc	a0,0x10
    80000154:	b7050513          	addi	a0,a0,-1168 # 8000fcc0 <cons>
    80000158:	243000ef          	jal	ra,80000b9a <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000015c:	00010497          	auipc	s1,0x10
    80000160:	b6448493          	addi	s1,s1,-1180 # 8000fcc0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80000164:	00010917          	auipc	s2,0x10
    80000168:	bf490913          	addi	s2,s2,-1036 # 8000fd58 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    8000016c:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000016e:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80000170:	4ca9                	li	s9,10
  while(n > 0){
    80000172:	07305363          	blez	s3,800001d8 <consoleread+0xae>
    while(cons.r == cons.w){
    80000176:	0984a783          	lw	a5,152(s1)
    8000017a:	09c4a703          	lw	a4,156(s1)
    8000017e:	02f71163          	bne	a4,a5,800001a0 <consoleread+0x76>
      if(killed(myproc())){
    80000182:	6d6010ef          	jal	ra,80001858 <myproc>
    80000186:	6d7010ef          	jal	ra,8000205c <killed>
    8000018a:	e125                	bnez	a0,800001ea <consoleread+0xc0>
      sleep(&cons.r, &cons.lock);
    8000018c:	85a6                	mv	a1,s1
    8000018e:	854a                	mv	a0,s2
    80000190:	495010ef          	jal	ra,80001e24 <sleep>
    while(cons.r == cons.w){
    80000194:	0984a783          	lw	a5,152(s1)
    80000198:	09c4a703          	lw	a4,156(s1)
    8000019c:	fef703e3          	beq	a4,a5,80000182 <consoleread+0x58>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001a0:	0017871b          	addiw	a4,a5,1
    800001a4:	08e4ac23          	sw	a4,152(s1)
    800001a8:	07f7f713          	andi	a4,a5,127
    800001ac:	9726                	add	a4,a4,s1
    800001ae:	01874703          	lbu	a4,24(a4)
    800001b2:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    800001b6:	057d0f63          	beq	s10,s7,80000214 <consoleread+0xea>
    cbuf = c;
    800001ba:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800001be:	4685                	li	a3,1
    800001c0:	f9f40613          	addi	a2,s0,-97
    800001c4:	85d2                	mv	a1,s4
    800001c6:	8556                	mv	a0,s5
    800001c8:	7b9010ef          	jal	ra,80002180 <either_copyout>
    800001cc:	01850663          	beq	a0,s8,800001d8 <consoleread+0xae>
    dst++;
    800001d0:	0a05                	addi	s4,s4,1
    --n;
    800001d2:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    800001d4:	f99d1fe3          	bne	s10,s9,80000172 <consoleread+0x48>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    800001d8:	00010517          	auipc	a0,0x10
    800001dc:	ae850513          	addi	a0,a0,-1304 # 8000fcc0 <cons>
    800001e0:	253000ef          	jal	ra,80000c32 <release>

  return target - n;
    800001e4:	413b053b          	subw	a0,s6,s3
    800001e8:	a801                	j	800001f8 <consoleread+0xce>
        release(&cons.lock);
    800001ea:	00010517          	auipc	a0,0x10
    800001ee:	ad650513          	addi	a0,a0,-1322 # 8000fcc0 <cons>
    800001f2:	241000ef          	jal	ra,80000c32 <release>
        return -1;
    800001f6:	557d                	li	a0,-1
}
    800001f8:	70a6                	ld	ra,104(sp)
    800001fa:	7406                	ld	s0,96(sp)
    800001fc:	64e6                	ld	s1,88(sp)
    800001fe:	6946                	ld	s2,80(sp)
    80000200:	69a6                	ld	s3,72(sp)
    80000202:	6a06                	ld	s4,64(sp)
    80000204:	7ae2                	ld	s5,56(sp)
    80000206:	7b42                	ld	s6,48(sp)
    80000208:	7ba2                	ld	s7,40(sp)
    8000020a:	7c02                	ld	s8,32(sp)
    8000020c:	6ce2                	ld	s9,24(sp)
    8000020e:	6d42                	ld	s10,16(sp)
    80000210:	6165                	addi	sp,sp,112
    80000212:	8082                	ret
      if(n < target){
    80000214:	0009871b          	sext.w	a4,s3
    80000218:	fd6770e3          	bgeu	a4,s6,800001d8 <consoleread+0xae>
        cons.r--;
    8000021c:	00010717          	auipc	a4,0x10
    80000220:	b2f72e23          	sw	a5,-1220(a4) # 8000fd58 <cons+0x98>
    80000224:	bf55                	j	800001d8 <consoleread+0xae>

0000000080000226 <consputc>:
{
    80000226:	1141                	addi	sp,sp,-16
    80000228:	e406                	sd	ra,8(sp)
    8000022a:	e022                	sd	s0,0(sp)
    8000022c:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    8000022e:	10000793          	li	a5,256
    80000232:	00f50863          	beq	a0,a5,80000242 <consputc+0x1c>
    uartputc_sync(c);
    80000236:	5d4000ef          	jal	ra,8000080a <uartputc_sync>
}
    8000023a:	60a2                	ld	ra,8(sp)
    8000023c:	6402                	ld	s0,0(sp)
    8000023e:	0141                	addi	sp,sp,16
    80000240:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80000242:	4521                	li	a0,8
    80000244:	5c6000ef          	jal	ra,8000080a <uartputc_sync>
    80000248:	02000513          	li	a0,32
    8000024c:	5be000ef          	jal	ra,8000080a <uartputc_sync>
    80000250:	4521                	li	a0,8
    80000252:	5b8000ef          	jal	ra,8000080a <uartputc_sync>
    80000256:	b7d5                	j	8000023a <consputc+0x14>

0000000080000258 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80000258:	1101                	addi	sp,sp,-32
    8000025a:	ec06                	sd	ra,24(sp)
    8000025c:	e822                	sd	s0,16(sp)
    8000025e:	e426                	sd	s1,8(sp)
    80000260:	e04a                	sd	s2,0(sp)
    80000262:	1000                	addi	s0,sp,32
    80000264:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80000266:	00010517          	auipc	a0,0x10
    8000026a:	a5a50513          	addi	a0,a0,-1446 # 8000fcc0 <cons>
    8000026e:	12d000ef          	jal	ra,80000b9a <acquire>

  switch(c){
    80000272:	47d5                	li	a5,21
    80000274:	0af48063          	beq	s1,a5,80000314 <consoleintr+0xbc>
    80000278:	0297c663          	blt	a5,s1,800002a4 <consoleintr+0x4c>
    8000027c:	47a1                	li	a5,8
    8000027e:	0cf48f63          	beq	s1,a5,8000035c <consoleintr+0x104>
    80000282:	47c1                	li	a5,16
    80000284:	10f49063          	bne	s1,a5,80000384 <consoleintr+0x12c>
  case C('P'):  // Print process list.
    procdump();
    80000288:	78d010ef          	jal	ra,80002214 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    8000028c:	00010517          	auipc	a0,0x10
    80000290:	a3450513          	addi	a0,a0,-1484 # 8000fcc0 <cons>
    80000294:	19f000ef          	jal	ra,80000c32 <release>
}
    80000298:	60e2                	ld	ra,24(sp)
    8000029a:	6442                	ld	s0,16(sp)
    8000029c:	64a2                	ld	s1,8(sp)
    8000029e:	6902                	ld	s2,0(sp)
    800002a0:	6105                	addi	sp,sp,32
    800002a2:	8082                	ret
  switch(c){
    800002a4:	07f00793          	li	a5,127
    800002a8:	0af48a63          	beq	s1,a5,8000035c <consoleintr+0x104>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800002ac:	00010717          	auipc	a4,0x10
    800002b0:	a1470713          	addi	a4,a4,-1516 # 8000fcc0 <cons>
    800002b4:	0a072783          	lw	a5,160(a4)
    800002b8:	09872703          	lw	a4,152(a4)
    800002bc:	9f99                	subw	a5,a5,a4
    800002be:	07f00713          	li	a4,127
    800002c2:	fcf765e3          	bltu	a4,a5,8000028c <consoleintr+0x34>
      c = (c == '\r') ? '\n' : c;
    800002c6:	47b5                	li	a5,13
    800002c8:	0cf48163          	beq	s1,a5,8000038a <consoleintr+0x132>
      consputc(c);
    800002cc:	8526                	mv	a0,s1
    800002ce:	f59ff0ef          	jal	ra,80000226 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800002d2:	00010797          	auipc	a5,0x10
    800002d6:	9ee78793          	addi	a5,a5,-1554 # 8000fcc0 <cons>
    800002da:	0a07a683          	lw	a3,160(a5)
    800002de:	0016871b          	addiw	a4,a3,1
    800002e2:	0007061b          	sext.w	a2,a4
    800002e6:	0ae7a023          	sw	a4,160(a5)
    800002ea:	07f6f693          	andi	a3,a3,127
    800002ee:	97b6                	add	a5,a5,a3
    800002f0:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    800002f4:	47a9                	li	a5,10
    800002f6:	0af48f63          	beq	s1,a5,800003b4 <consoleintr+0x15c>
    800002fa:	4791                	li	a5,4
    800002fc:	0af48c63          	beq	s1,a5,800003b4 <consoleintr+0x15c>
    80000300:	00010797          	auipc	a5,0x10
    80000304:	a587a783          	lw	a5,-1448(a5) # 8000fd58 <cons+0x98>
    80000308:	9f1d                	subw	a4,a4,a5
    8000030a:	08000793          	li	a5,128
    8000030e:	f6f71fe3          	bne	a4,a5,8000028c <consoleintr+0x34>
    80000312:	a04d                	j	800003b4 <consoleintr+0x15c>
    while(cons.e != cons.w &&
    80000314:	00010717          	auipc	a4,0x10
    80000318:	9ac70713          	addi	a4,a4,-1620 # 8000fcc0 <cons>
    8000031c:	0a072783          	lw	a5,160(a4)
    80000320:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80000324:	00010497          	auipc	s1,0x10
    80000328:	99c48493          	addi	s1,s1,-1636 # 8000fcc0 <cons>
    while(cons.e != cons.w &&
    8000032c:	4929                	li	s2,10
    8000032e:	f4f70fe3          	beq	a4,a5,8000028c <consoleintr+0x34>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80000332:	37fd                	addiw	a5,a5,-1
    80000334:	07f7f713          	andi	a4,a5,127
    80000338:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    8000033a:	01874703          	lbu	a4,24(a4)
    8000033e:	f52707e3          	beq	a4,s2,8000028c <consoleintr+0x34>
      cons.e--;
    80000342:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80000346:	10000513          	li	a0,256
    8000034a:	eddff0ef          	jal	ra,80000226 <consputc>
    while(cons.e != cons.w &&
    8000034e:	0a04a783          	lw	a5,160(s1)
    80000352:	09c4a703          	lw	a4,156(s1)
    80000356:	fcf71ee3          	bne	a4,a5,80000332 <consoleintr+0xda>
    8000035a:	bf0d                	j	8000028c <consoleintr+0x34>
    if(cons.e != cons.w){
    8000035c:	00010717          	auipc	a4,0x10
    80000360:	96470713          	addi	a4,a4,-1692 # 8000fcc0 <cons>
    80000364:	0a072783          	lw	a5,160(a4)
    80000368:	09c72703          	lw	a4,156(a4)
    8000036c:	f2f700e3          	beq	a4,a5,8000028c <consoleintr+0x34>
      cons.e--;
    80000370:	37fd                	addiw	a5,a5,-1
    80000372:	00010717          	auipc	a4,0x10
    80000376:	9ef72723          	sw	a5,-1554(a4) # 8000fd60 <cons+0xa0>
      consputc(BACKSPACE);
    8000037a:	10000513          	li	a0,256
    8000037e:	ea9ff0ef          	jal	ra,80000226 <consputc>
    80000382:	b729                	j	8000028c <consoleintr+0x34>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80000384:	f00484e3          	beqz	s1,8000028c <consoleintr+0x34>
    80000388:	b715                	j	800002ac <consoleintr+0x54>
      consputc(c);
    8000038a:	4529                	li	a0,10
    8000038c:	e9bff0ef          	jal	ra,80000226 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000390:	00010797          	auipc	a5,0x10
    80000394:	93078793          	addi	a5,a5,-1744 # 8000fcc0 <cons>
    80000398:	0a07a703          	lw	a4,160(a5)
    8000039c:	0017069b          	addiw	a3,a4,1
    800003a0:	0006861b          	sext.w	a2,a3
    800003a4:	0ad7a023          	sw	a3,160(a5)
    800003a8:	07f77713          	andi	a4,a4,127
    800003ac:	97ba                	add	a5,a5,a4
    800003ae:	4729                	li	a4,10
    800003b0:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    800003b4:	00010797          	auipc	a5,0x10
    800003b8:	9ac7a423          	sw	a2,-1624(a5) # 8000fd5c <cons+0x9c>
        wakeup(&cons.r);
    800003bc:	00010517          	auipc	a0,0x10
    800003c0:	99c50513          	addi	a0,a0,-1636 # 8000fd58 <cons+0x98>
    800003c4:	2ad010ef          	jal	ra,80001e70 <wakeup>
    800003c8:	b5d1                	j	8000028c <consoleintr+0x34>

00000000800003ca <consoleinit>:

void
consoleinit(void)
{
    800003ca:	1141                	addi	sp,sp,-16
    800003cc:	e406                	sd	ra,8(sp)
    800003ce:	e022                	sd	s0,0(sp)
    800003d0:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    800003d2:	00007597          	auipc	a1,0x7
    800003d6:	c3e58593          	addi	a1,a1,-962 # 80007010 <etext+0x10>
    800003da:	00010517          	auipc	a0,0x10
    800003de:	8e650513          	addi	a0,a0,-1818 # 8000fcc0 <cons>
    800003e2:	738000ef          	jal	ra,80000b1a <initlock>

  uartinit();
    800003e6:	3d8000ef          	jal	ra,800007be <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    800003ea:	0003c797          	auipc	a5,0x3c
    800003ee:	a3678793          	addi	a5,a5,-1482 # 8003be20 <devsw>
    800003f2:	00000717          	auipc	a4,0x0
    800003f6:	d3870713          	addi	a4,a4,-712 # 8000012a <consoleread>
    800003fa:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    800003fc:	00000717          	auipc	a4,0x0
    80000400:	cd470713          	addi	a4,a4,-812 # 800000d0 <consolewrite>
    80000404:	ef98                	sd	a4,24(a5)
}
    80000406:	60a2                	ld	ra,8(sp)
    80000408:	6402                	ld	s0,0(sp)
    8000040a:	0141                	addi	sp,sp,16
    8000040c:	8082                	ret

000000008000040e <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    8000040e:	7179                	addi	sp,sp,-48
    80000410:	f406                	sd	ra,40(sp)
    80000412:	f022                	sd	s0,32(sp)
    80000414:	ec26                	sd	s1,24(sp)
    80000416:	e84a                	sd	s2,16(sp)
    80000418:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    8000041a:	c219                	beqz	a2,80000420 <printint+0x12>
    8000041c:	06054f63          	bltz	a0,8000049a <printint+0x8c>
    x = -xx;
  else
    x = xx;
    80000420:	4881                	li	a7,0
    80000422:	fd040693          	addi	a3,s0,-48

  i = 0;
    80000426:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    80000428:	00007617          	auipc	a2,0x7
    8000042c:	c1060613          	addi	a2,a2,-1008 # 80007038 <digits>
    80000430:	883e                	mv	a6,a5
    80000432:	2785                	addiw	a5,a5,1
    80000434:	02b57733          	remu	a4,a0,a1
    80000438:	9732                	add	a4,a4,a2
    8000043a:	00074703          	lbu	a4,0(a4)
    8000043e:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    80000442:	872a                	mv	a4,a0
    80000444:	02b55533          	divu	a0,a0,a1
    80000448:	0685                	addi	a3,a3,1
    8000044a:	feb773e3          	bgeu	a4,a1,80000430 <printint+0x22>

  if(sign)
    8000044e:	00088b63          	beqz	a7,80000464 <printint+0x56>
    buf[i++] = '-';
    80000452:	fe040713          	addi	a4,s0,-32
    80000456:	97ba                	add	a5,a5,a4
    80000458:	02d00713          	li	a4,45
    8000045c:	fee78823          	sb	a4,-16(a5)
    80000460:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
    80000464:	02f05563          	blez	a5,8000048e <printint+0x80>
    80000468:	fd040713          	addi	a4,s0,-48
    8000046c:	00f704b3          	add	s1,a4,a5
    80000470:	fff70913          	addi	s2,a4,-1
    80000474:	993e                	add	s2,s2,a5
    80000476:	37fd                	addiw	a5,a5,-1
    80000478:	1782                	slli	a5,a5,0x20
    8000047a:	9381                	srli	a5,a5,0x20
    8000047c:	40f90933          	sub	s2,s2,a5
    consputc(buf[i]);
    80000480:	fff4c503          	lbu	a0,-1(s1)
    80000484:	da3ff0ef          	jal	ra,80000226 <consputc>
  while(--i >= 0)
    80000488:	14fd                	addi	s1,s1,-1
    8000048a:	ff249be3          	bne	s1,s2,80000480 <printint+0x72>
}
    8000048e:	70a2                	ld	ra,40(sp)
    80000490:	7402                	ld	s0,32(sp)
    80000492:	64e2                	ld	s1,24(sp)
    80000494:	6942                	ld	s2,16(sp)
    80000496:	6145                	addi	sp,sp,48
    80000498:	8082                	ret
    x = -xx;
    8000049a:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    8000049e:	4885                	li	a7,1
    x = -xx;
    800004a0:	b749                	j	80000422 <printint+0x14>

00000000800004a2 <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    800004a2:	7155                	addi	sp,sp,-208
    800004a4:	e506                	sd	ra,136(sp)
    800004a6:	e122                	sd	s0,128(sp)
    800004a8:	fca6                	sd	s1,120(sp)
    800004aa:	f8ca                	sd	s2,112(sp)
    800004ac:	f4ce                	sd	s3,104(sp)
    800004ae:	f0d2                	sd	s4,96(sp)
    800004b0:	ecd6                	sd	s5,88(sp)
    800004b2:	e8da                	sd	s6,80(sp)
    800004b4:	e4de                	sd	s7,72(sp)
    800004b6:	e0e2                	sd	s8,64(sp)
    800004b8:	fc66                	sd	s9,56(sp)
    800004ba:	f86a                	sd	s10,48(sp)
    800004bc:	f46e                	sd	s11,40(sp)
    800004be:	0900                	addi	s0,sp,144
    800004c0:	8a2a                	mv	s4,a0
    800004c2:	e40c                	sd	a1,8(s0)
    800004c4:	e810                	sd	a2,16(s0)
    800004c6:	ec14                	sd	a3,24(s0)
    800004c8:	f018                	sd	a4,32(s0)
    800004ca:	f41c                	sd	a5,40(s0)
    800004cc:	03043823          	sd	a6,48(s0)
    800004d0:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2, locking;
  char *s;

  locking = pr.locking;
    800004d4:	00010797          	auipc	a5,0x10
    800004d8:	8ac7a783          	lw	a5,-1876(a5) # 8000fd80 <pr+0x18>
    800004dc:	f6f43c23          	sd	a5,-136(s0)
  if(locking)
    800004e0:	eb9d                	bnez	a5,80000516 <printf+0x74>
    acquire(&pr.lock);

  va_start(ap, fmt);
    800004e2:	00840793          	addi	a5,s0,8
    800004e6:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800004ea:	00054503          	lbu	a0,0(a0)
    800004ee:	24050463          	beqz	a0,80000736 <printf+0x294>
    800004f2:	4981                	li	s3,0
    if(cx != '%'){
    800004f4:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    800004f8:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    800004fc:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    80000500:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    80000504:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    80000508:	07000d93          	li	s11,112
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000050c:	00007b97          	auipc	s7,0x7
    80000510:	b2cb8b93          	addi	s7,s7,-1236 # 80007038 <digits>
    80000514:	a081                	j	80000554 <printf+0xb2>
    acquire(&pr.lock);
    80000516:	00010517          	auipc	a0,0x10
    8000051a:	85250513          	addi	a0,a0,-1966 # 8000fd68 <pr>
    8000051e:	67c000ef          	jal	ra,80000b9a <acquire>
  va_start(ap, fmt);
    80000522:	00840793          	addi	a5,s0,8
    80000526:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000052a:	000a4503          	lbu	a0,0(s4)
    8000052e:	f171                	bnez	a0,800004f2 <printf+0x50>
#endif
  }
  va_end(ap);

  if(locking)
    release(&pr.lock);
    80000530:	00010517          	auipc	a0,0x10
    80000534:	83850513          	addi	a0,a0,-1992 # 8000fd68 <pr>
    80000538:	6fa000ef          	jal	ra,80000c32 <release>
    8000053c:	aaed                	j	80000736 <printf+0x294>
      consputc(cx);
    8000053e:	ce9ff0ef          	jal	ra,80000226 <consputc>
      continue;
    80000542:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80000544:	0014899b          	addiw	s3,s1,1
    80000548:	013a07b3          	add	a5,s4,s3
    8000054c:	0007c503          	lbu	a0,0(a5)
    80000550:	1c050f63          	beqz	a0,8000072e <printf+0x28c>
    if(cx != '%'){
    80000554:	ff5515e3          	bne	a0,s5,8000053e <printf+0x9c>
    i++;
    80000558:	0019849b          	addiw	s1,s3,1
    c0 = fmt[i+0] & 0xff;
    8000055c:	009a07b3          	add	a5,s4,s1
    80000560:	0007c903          	lbu	s2,0(a5)
    if(c0) c1 = fmt[i+1] & 0xff;
    80000564:	1c090563          	beqz	s2,8000072e <printf+0x28c>
    80000568:	0017c783          	lbu	a5,1(a5)
    c1 = c2 = 0;
    8000056c:	86be                	mv	a3,a5
    if(c1) c2 = fmt[i+2] & 0xff;
    8000056e:	c789                	beqz	a5,80000578 <printf+0xd6>
    80000570:	009a0733          	add	a4,s4,s1
    80000574:	00274683          	lbu	a3,2(a4)
    if(c0 == 'd'){
    80000578:	03690463          	beq	s2,s6,800005a0 <printf+0xfe>
    } else if(c0 == 'l' && c1 == 'd'){
    8000057c:	03890e63          	beq	s2,s8,800005b8 <printf+0x116>
    } else if(c0 == 'u'){
    80000580:	0b990d63          	beq	s2,s9,8000063a <printf+0x198>
    } else if(c0 == 'x'){
    80000584:	11a90363          	beq	s2,s10,8000068a <printf+0x1e8>
    } else if(c0 == 'p'){
    80000588:	13b90b63          	beq	s2,s11,800006be <printf+0x21c>
    } else if(c0 == 's'){
    8000058c:	07300793          	li	a5,115
    80000590:	16f90363          	beq	s2,a5,800006f6 <printf+0x254>
    } else if(c0 == '%'){
    80000594:	03591c63          	bne	s2,s5,800005cc <printf+0x12a>
      consputc('%');
    80000598:	8556                	mv	a0,s5
    8000059a:	c8dff0ef          	jal	ra,80000226 <consputc>
    8000059e:	b75d                	j	80000544 <printf+0xa2>
      printint(va_arg(ap, int), 10, 1);
    800005a0:	f8843783          	ld	a5,-120(s0)
    800005a4:	00878713          	addi	a4,a5,8
    800005a8:	f8e43423          	sd	a4,-120(s0)
    800005ac:	4605                	li	a2,1
    800005ae:	45a9                	li	a1,10
    800005b0:	4388                	lw	a0,0(a5)
    800005b2:	e5dff0ef          	jal	ra,8000040e <printint>
    800005b6:	b779                	j	80000544 <printf+0xa2>
    } else if(c0 == 'l' && c1 == 'd'){
    800005b8:	03678163          	beq	a5,s6,800005da <printf+0x138>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800005bc:	03878d63          	beq	a5,s8,800005f6 <printf+0x154>
    } else if(c0 == 'l' && c1 == 'u'){
    800005c0:	09978963          	beq	a5,s9,80000652 <printf+0x1b0>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    800005c4:	03878b63          	beq	a5,s8,800005fa <printf+0x158>
    } else if(c0 == 'l' && c1 == 'x'){
    800005c8:	0da78d63          	beq	a5,s10,800006a2 <printf+0x200>
      consputc('%');
    800005cc:	8556                	mv	a0,s5
    800005ce:	c59ff0ef          	jal	ra,80000226 <consputc>
      consputc(c0);
    800005d2:	854a                	mv	a0,s2
    800005d4:	c53ff0ef          	jal	ra,80000226 <consputc>
    800005d8:	b7b5                	j	80000544 <printf+0xa2>
      printint(va_arg(ap, uint64), 10, 1);
    800005da:	f8843783          	ld	a5,-120(s0)
    800005de:	00878713          	addi	a4,a5,8
    800005e2:	f8e43423          	sd	a4,-120(s0)
    800005e6:	4605                	li	a2,1
    800005e8:	45a9                	li	a1,10
    800005ea:	6388                	ld	a0,0(a5)
    800005ec:	e23ff0ef          	jal	ra,8000040e <printint>
      i += 1;
    800005f0:	0029849b          	addiw	s1,s3,2
    800005f4:	bf81                	j	80000544 <printf+0xa2>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800005f6:	03668463          	beq	a3,s6,8000061e <printf+0x17c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    800005fa:	07968a63          	beq	a3,s9,8000066e <printf+0x1cc>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    800005fe:	fda697e3          	bne	a3,s10,800005cc <printf+0x12a>
      printint(va_arg(ap, uint64), 16, 0);
    80000602:	f8843783          	ld	a5,-120(s0)
    80000606:	00878713          	addi	a4,a5,8
    8000060a:	f8e43423          	sd	a4,-120(s0)
    8000060e:	4601                	li	a2,0
    80000610:	45c1                	li	a1,16
    80000612:	6388                	ld	a0,0(a5)
    80000614:	dfbff0ef          	jal	ra,8000040e <printint>
      i += 2;
    80000618:	0039849b          	addiw	s1,s3,3
    8000061c:	b725                	j	80000544 <printf+0xa2>
      printint(va_arg(ap, uint64), 10, 1);
    8000061e:	f8843783          	ld	a5,-120(s0)
    80000622:	00878713          	addi	a4,a5,8
    80000626:	f8e43423          	sd	a4,-120(s0)
    8000062a:	4605                	li	a2,1
    8000062c:	45a9                	li	a1,10
    8000062e:	6388                	ld	a0,0(a5)
    80000630:	ddfff0ef          	jal	ra,8000040e <printint>
      i += 2;
    80000634:	0039849b          	addiw	s1,s3,3
    80000638:	b731                	j	80000544 <printf+0xa2>
      printint(va_arg(ap, int), 10, 0);
    8000063a:	f8843783          	ld	a5,-120(s0)
    8000063e:	00878713          	addi	a4,a5,8
    80000642:	f8e43423          	sd	a4,-120(s0)
    80000646:	4601                	li	a2,0
    80000648:	45a9                	li	a1,10
    8000064a:	4388                	lw	a0,0(a5)
    8000064c:	dc3ff0ef          	jal	ra,8000040e <printint>
    80000650:	bdd5                	j	80000544 <printf+0xa2>
      printint(va_arg(ap, uint64), 10, 0);
    80000652:	f8843783          	ld	a5,-120(s0)
    80000656:	00878713          	addi	a4,a5,8
    8000065a:	f8e43423          	sd	a4,-120(s0)
    8000065e:	4601                	li	a2,0
    80000660:	45a9                	li	a1,10
    80000662:	6388                	ld	a0,0(a5)
    80000664:	dabff0ef          	jal	ra,8000040e <printint>
      i += 1;
    80000668:	0029849b          	addiw	s1,s3,2
    8000066c:	bde1                	j	80000544 <printf+0xa2>
      printint(va_arg(ap, uint64), 10, 0);
    8000066e:	f8843783          	ld	a5,-120(s0)
    80000672:	00878713          	addi	a4,a5,8
    80000676:	f8e43423          	sd	a4,-120(s0)
    8000067a:	4601                	li	a2,0
    8000067c:	45a9                	li	a1,10
    8000067e:	6388                	ld	a0,0(a5)
    80000680:	d8fff0ef          	jal	ra,8000040e <printint>
      i += 2;
    80000684:	0039849b          	addiw	s1,s3,3
    80000688:	bd75                	j	80000544 <printf+0xa2>
      printint(va_arg(ap, int), 16, 0);
    8000068a:	f8843783          	ld	a5,-120(s0)
    8000068e:	00878713          	addi	a4,a5,8
    80000692:	f8e43423          	sd	a4,-120(s0)
    80000696:	4601                	li	a2,0
    80000698:	45c1                	li	a1,16
    8000069a:	4388                	lw	a0,0(a5)
    8000069c:	d73ff0ef          	jal	ra,8000040e <printint>
    800006a0:	b555                	j	80000544 <printf+0xa2>
      printint(va_arg(ap, uint64), 16, 0);
    800006a2:	f8843783          	ld	a5,-120(s0)
    800006a6:	00878713          	addi	a4,a5,8
    800006aa:	f8e43423          	sd	a4,-120(s0)
    800006ae:	4601                	li	a2,0
    800006b0:	45c1                	li	a1,16
    800006b2:	6388                	ld	a0,0(a5)
    800006b4:	d5bff0ef          	jal	ra,8000040e <printint>
      i += 1;
    800006b8:	0029849b          	addiw	s1,s3,2
    800006bc:	b561                	j	80000544 <printf+0xa2>
      printptr(va_arg(ap, uint64));
    800006be:	f8843783          	ld	a5,-120(s0)
    800006c2:	00878713          	addi	a4,a5,8
    800006c6:	f8e43423          	sd	a4,-120(s0)
    800006ca:	0007b983          	ld	s3,0(a5)
  consputc('0');
    800006ce:	03000513          	li	a0,48
    800006d2:	b55ff0ef          	jal	ra,80000226 <consputc>
  consputc('x');
    800006d6:	856a                	mv	a0,s10
    800006d8:	b4fff0ef          	jal	ra,80000226 <consputc>
    800006dc:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006de:	03c9d793          	srli	a5,s3,0x3c
    800006e2:	97de                	add	a5,a5,s7
    800006e4:	0007c503          	lbu	a0,0(a5)
    800006e8:	b3fff0ef          	jal	ra,80000226 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800006ec:	0992                	slli	s3,s3,0x4
    800006ee:	397d                	addiw	s2,s2,-1
    800006f0:	fe0917e3          	bnez	s2,800006de <printf+0x23c>
    800006f4:	bd81                	j	80000544 <printf+0xa2>
      if((s = va_arg(ap, char*)) == 0)
    800006f6:	f8843783          	ld	a5,-120(s0)
    800006fa:	00878713          	addi	a4,a5,8
    800006fe:	f8e43423          	sd	a4,-120(s0)
    80000702:	0007b903          	ld	s2,0(a5)
    80000706:	00090d63          	beqz	s2,80000720 <printf+0x27e>
      for(; *s; s++)
    8000070a:	00094503          	lbu	a0,0(s2)
    8000070e:	e2050be3          	beqz	a0,80000544 <printf+0xa2>
        consputc(*s);
    80000712:	b15ff0ef          	jal	ra,80000226 <consputc>
      for(; *s; s++)
    80000716:	0905                	addi	s2,s2,1
    80000718:	00094503          	lbu	a0,0(s2)
    8000071c:	f97d                	bnez	a0,80000712 <printf+0x270>
    8000071e:	b51d                	j	80000544 <printf+0xa2>
        s = "(null)";
    80000720:	00007917          	auipc	s2,0x7
    80000724:	8f890913          	addi	s2,s2,-1800 # 80007018 <etext+0x18>
      for(; *s; s++)
    80000728:	02800513          	li	a0,40
    8000072c:	b7dd                	j	80000712 <printf+0x270>
  if(locking)
    8000072e:	f7843783          	ld	a5,-136(s0)
    80000732:	de079fe3          	bnez	a5,80000530 <printf+0x8e>

  return 0;
}
    80000736:	4501                	li	a0,0
    80000738:	60aa                	ld	ra,136(sp)
    8000073a:	640a                	ld	s0,128(sp)
    8000073c:	74e6                	ld	s1,120(sp)
    8000073e:	7946                	ld	s2,112(sp)
    80000740:	79a6                	ld	s3,104(sp)
    80000742:	7a06                	ld	s4,96(sp)
    80000744:	6ae6                	ld	s5,88(sp)
    80000746:	6b46                	ld	s6,80(sp)
    80000748:	6ba6                	ld	s7,72(sp)
    8000074a:	6c06                	ld	s8,64(sp)
    8000074c:	7ce2                	ld	s9,56(sp)
    8000074e:	7d42                	ld	s10,48(sp)
    80000750:	7da2                	ld	s11,40(sp)
    80000752:	6169                	addi	sp,sp,208
    80000754:	8082                	ret

0000000080000756 <panic>:

void
panic(char *s)
{
    80000756:	1101                	addi	sp,sp,-32
    80000758:	ec06                	sd	ra,24(sp)
    8000075a:	e822                	sd	s0,16(sp)
    8000075c:	e426                	sd	s1,8(sp)
    8000075e:	1000                	addi	s0,sp,32
    80000760:	84aa                	mv	s1,a0
  pr.locking = 0;
    80000762:	0000f797          	auipc	a5,0xf
    80000766:	6007af23          	sw	zero,1566(a5) # 8000fd80 <pr+0x18>
  printf("panic: ");
    8000076a:	00007517          	auipc	a0,0x7
    8000076e:	8b650513          	addi	a0,a0,-1866 # 80007020 <etext+0x20>
    80000772:	d31ff0ef          	jal	ra,800004a2 <printf>
  printf("%s\n", s);
    80000776:	85a6                	mv	a1,s1
    80000778:	00007517          	auipc	a0,0x7
    8000077c:	8b050513          	addi	a0,a0,-1872 # 80007028 <etext+0x28>
    80000780:	d23ff0ef          	jal	ra,800004a2 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80000784:	4785                	li	a5,1
    80000786:	00007717          	auipc	a4,0x7
    8000078a:	4ef72d23          	sw	a5,1274(a4) # 80007c80 <panicked>
  for(;;)
    8000078e:	a001                	j	8000078e <panic+0x38>

0000000080000790 <printfinit>:
    ;
}

void
printfinit(void)
{
    80000790:	1101                	addi	sp,sp,-32
    80000792:	ec06                	sd	ra,24(sp)
    80000794:	e822                	sd	s0,16(sp)
    80000796:	e426                	sd	s1,8(sp)
    80000798:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    8000079a:	0000f497          	auipc	s1,0xf
    8000079e:	5ce48493          	addi	s1,s1,1486 # 8000fd68 <pr>
    800007a2:	00007597          	auipc	a1,0x7
    800007a6:	88e58593          	addi	a1,a1,-1906 # 80007030 <etext+0x30>
    800007aa:	8526                	mv	a0,s1
    800007ac:	36e000ef          	jal	ra,80000b1a <initlock>
  pr.locking = 1;
    800007b0:	4785                	li	a5,1
    800007b2:	cc9c                	sw	a5,24(s1)
}
    800007b4:	60e2                	ld	ra,24(sp)
    800007b6:	6442                	ld	s0,16(sp)
    800007b8:	64a2                	ld	s1,8(sp)
    800007ba:	6105                	addi	sp,sp,32
    800007bc:	8082                	ret

00000000800007be <uartinit>:

void uartstart();

void
uartinit(void)
{
    800007be:	1141                	addi	sp,sp,-16
    800007c0:	e406                	sd	ra,8(sp)
    800007c2:	e022                	sd	s0,0(sp)
    800007c4:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800007c6:	100007b7          	lui	a5,0x10000
    800007ca:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800007ce:	f8000713          	li	a4,-128
    800007d2:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800007d6:	470d                	li	a4,3
    800007d8:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800007dc:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800007e0:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800007e4:	469d                	li	a3,7
    800007e6:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800007ea:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800007ee:	00007597          	auipc	a1,0x7
    800007f2:	86258593          	addi	a1,a1,-1950 # 80007050 <digits+0x18>
    800007f6:	0000f517          	auipc	a0,0xf
    800007fa:	59250513          	addi	a0,a0,1426 # 8000fd88 <uart_tx_lock>
    800007fe:	31c000ef          	jal	ra,80000b1a <initlock>
}
    80000802:	60a2                	ld	ra,8(sp)
    80000804:	6402                	ld	s0,0(sp)
    80000806:	0141                	addi	sp,sp,16
    80000808:	8082                	ret

000000008000080a <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000080a:	1101                	addi	sp,sp,-32
    8000080c:	ec06                	sd	ra,24(sp)
    8000080e:	e822                	sd	s0,16(sp)
    80000810:	e426                	sd	s1,8(sp)
    80000812:	1000                	addi	s0,sp,32
    80000814:	84aa                	mv	s1,a0
  push_off();
    80000816:	344000ef          	jal	ra,80000b5a <push_off>

  if(panicked){
    8000081a:	00007797          	auipc	a5,0x7
    8000081e:	4667a783          	lw	a5,1126(a5) # 80007c80 <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000822:	10000737          	lui	a4,0x10000
  if(panicked){
    80000826:	c391                	beqz	a5,8000082a <uartputc_sync+0x20>
    for(;;)
    80000828:	a001                	j	80000828 <uartputc_sync+0x1e>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000082a:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    8000082e:	0207f793          	andi	a5,a5,32
    80000832:	dfe5                	beqz	a5,8000082a <uartputc_sync+0x20>
    ;
  WriteReg(THR, c);
    80000834:	0ff4f513          	andi	a0,s1,255
    80000838:	100007b7          	lui	a5,0x10000
    8000083c:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80000840:	39e000ef          	jal	ra,80000bde <pop_off>
}
    80000844:	60e2                	ld	ra,24(sp)
    80000846:	6442                	ld	s0,16(sp)
    80000848:	64a2                	ld	s1,8(sp)
    8000084a:	6105                	addi	sp,sp,32
    8000084c:	8082                	ret

000000008000084e <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000084e:	00007797          	auipc	a5,0x7
    80000852:	43a7b783          	ld	a5,1082(a5) # 80007c88 <uart_tx_r>
    80000856:	00007717          	auipc	a4,0x7
    8000085a:	43a73703          	ld	a4,1082(a4) # 80007c90 <uart_tx_w>
    8000085e:	06f70c63          	beq	a4,a5,800008d6 <uartstart+0x88>
{
    80000862:	7139                	addi	sp,sp,-64
    80000864:	fc06                	sd	ra,56(sp)
    80000866:	f822                	sd	s0,48(sp)
    80000868:	f426                	sd	s1,40(sp)
    8000086a:	f04a                	sd	s2,32(sp)
    8000086c:	ec4e                	sd	s3,24(sp)
    8000086e:	e852                	sd	s4,16(sp)
    80000870:	e456                	sd	s5,8(sp)
    80000872:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      ReadReg(ISR);
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000874:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80000878:	0000fa17          	auipc	s4,0xf
    8000087c:	510a0a13          	addi	s4,s4,1296 # 8000fd88 <uart_tx_lock>
    uart_tx_r += 1;
    80000880:	00007497          	auipc	s1,0x7
    80000884:	40848493          	addi	s1,s1,1032 # 80007c88 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80000888:	00007997          	auipc	s3,0x7
    8000088c:	40898993          	addi	s3,s3,1032 # 80007c90 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000890:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80000894:	02077713          	andi	a4,a4,32
    80000898:	c715                	beqz	a4,800008c4 <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000089a:	01f7f713          	andi	a4,a5,31
    8000089e:	9752                	add	a4,a4,s4
    800008a0:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    800008a4:	0785                	addi	a5,a5,1
    800008a6:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    800008a8:	8526                	mv	a0,s1
    800008aa:	5c6010ef          	jal	ra,80001e70 <wakeup>
    
    WriteReg(THR, c);
    800008ae:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    800008b2:	609c                	ld	a5,0(s1)
    800008b4:	0009b703          	ld	a4,0(s3)
    800008b8:	fcf71ce3          	bne	a4,a5,80000890 <uartstart+0x42>
      ReadReg(ISR);
    800008bc:	100007b7          	lui	a5,0x10000
    800008c0:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>
  }
}
    800008c4:	70e2                	ld	ra,56(sp)
    800008c6:	7442                	ld	s0,48(sp)
    800008c8:	74a2                	ld	s1,40(sp)
    800008ca:	7902                	ld	s2,32(sp)
    800008cc:	69e2                	ld	s3,24(sp)
    800008ce:	6a42                	ld	s4,16(sp)
    800008d0:	6aa2                	ld	s5,8(sp)
    800008d2:	6121                	addi	sp,sp,64
    800008d4:	8082                	ret
      ReadReg(ISR);
    800008d6:	100007b7          	lui	a5,0x10000
    800008da:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>
      return;
    800008de:	8082                	ret

00000000800008e0 <uartputc>:
{
    800008e0:	7179                	addi	sp,sp,-48
    800008e2:	f406                	sd	ra,40(sp)
    800008e4:	f022                	sd	s0,32(sp)
    800008e6:	ec26                	sd	s1,24(sp)
    800008e8:	e84a                	sd	s2,16(sp)
    800008ea:	e44e                	sd	s3,8(sp)
    800008ec:	e052                	sd	s4,0(sp)
    800008ee:	1800                	addi	s0,sp,48
    800008f0:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800008f2:	0000f517          	auipc	a0,0xf
    800008f6:	49650513          	addi	a0,a0,1174 # 8000fd88 <uart_tx_lock>
    800008fa:	2a0000ef          	jal	ra,80000b9a <acquire>
  if(panicked){
    800008fe:	00007797          	auipc	a5,0x7
    80000902:	3827a783          	lw	a5,898(a5) # 80007c80 <panicked>
    80000906:	efbd                	bnez	a5,80000984 <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000908:	00007717          	auipc	a4,0x7
    8000090c:	38873703          	ld	a4,904(a4) # 80007c90 <uart_tx_w>
    80000910:	00007797          	auipc	a5,0x7
    80000914:	3787b783          	ld	a5,888(a5) # 80007c88 <uart_tx_r>
    80000918:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    8000091c:	0000f997          	auipc	s3,0xf
    80000920:	46c98993          	addi	s3,s3,1132 # 8000fd88 <uart_tx_lock>
    80000924:	00007497          	auipc	s1,0x7
    80000928:	36448493          	addi	s1,s1,868 # 80007c88 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000092c:	00007917          	auipc	s2,0x7
    80000930:	36490913          	addi	s2,s2,868 # 80007c90 <uart_tx_w>
    80000934:	00e79d63          	bne	a5,a4,8000094e <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    80000938:	85ce                	mv	a1,s3
    8000093a:	8526                	mv	a0,s1
    8000093c:	4e8010ef          	jal	ra,80001e24 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000940:	00093703          	ld	a4,0(s2)
    80000944:	609c                	ld	a5,0(s1)
    80000946:	02078793          	addi	a5,a5,32
    8000094a:	fee787e3          	beq	a5,a4,80000938 <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    8000094e:	0000f497          	auipc	s1,0xf
    80000952:	43a48493          	addi	s1,s1,1082 # 8000fd88 <uart_tx_lock>
    80000956:	01f77793          	andi	a5,a4,31
    8000095a:	97a6                	add	a5,a5,s1
    8000095c:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80000960:	0705                	addi	a4,a4,1
    80000962:	00007797          	auipc	a5,0x7
    80000966:	32e7b723          	sd	a4,814(a5) # 80007c90 <uart_tx_w>
  uartstart();
    8000096a:	ee5ff0ef          	jal	ra,8000084e <uartstart>
  release(&uart_tx_lock);
    8000096e:	8526                	mv	a0,s1
    80000970:	2c2000ef          	jal	ra,80000c32 <release>
}
    80000974:	70a2                	ld	ra,40(sp)
    80000976:	7402                	ld	s0,32(sp)
    80000978:	64e2                	ld	s1,24(sp)
    8000097a:	6942                	ld	s2,16(sp)
    8000097c:	69a2                	ld	s3,8(sp)
    8000097e:	6a02                	ld	s4,0(sp)
    80000980:	6145                	addi	sp,sp,48
    80000982:	8082                	ret
    for(;;)
    80000984:	a001                	j	80000984 <uartputc+0xa4>

0000000080000986 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80000986:	1141                	addi	sp,sp,-16
    80000988:	e422                	sd	s0,8(sp)
    8000098a:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    8000098c:	100007b7          	lui	a5,0x10000
    80000990:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80000994:	8b85                	andi	a5,a5,1
    80000996:	cb91                	beqz	a5,800009aa <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80000998:	100007b7          	lui	a5,0x10000
    8000099c:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    800009a0:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    800009a4:	6422                	ld	s0,8(sp)
    800009a6:	0141                	addi	sp,sp,16
    800009a8:	8082                	ret
    return -1;
    800009aa:	557d                	li	a0,-1
    800009ac:	bfe5                	j	800009a4 <uartgetc+0x1e>

00000000800009ae <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800009ae:	1101                	addi	sp,sp,-32
    800009b0:	ec06                	sd	ra,24(sp)
    800009b2:	e822                	sd	s0,16(sp)
    800009b4:	e426                	sd	s1,8(sp)
    800009b6:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800009b8:	54fd                	li	s1,-1
    800009ba:	a019                	j	800009c0 <uartintr+0x12>
      break;
    consoleintr(c);
    800009bc:	89dff0ef          	jal	ra,80000258 <consoleintr>
    int c = uartgetc();
    800009c0:	fc7ff0ef          	jal	ra,80000986 <uartgetc>
    if(c == -1)
    800009c4:	fe951ce3          	bne	a0,s1,800009bc <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800009c8:	0000f497          	auipc	s1,0xf
    800009cc:	3c048493          	addi	s1,s1,960 # 8000fd88 <uart_tx_lock>
    800009d0:	8526                	mv	a0,s1
    800009d2:	1c8000ef          	jal	ra,80000b9a <acquire>
  uartstart();
    800009d6:	e79ff0ef          	jal	ra,8000084e <uartstart>
  release(&uart_tx_lock);
    800009da:	8526                	mv	a0,s1
    800009dc:	256000ef          	jal	ra,80000c32 <release>
}
    800009e0:	60e2                	ld	ra,24(sp)
    800009e2:	6442                	ld	s0,16(sp)
    800009e4:	64a2                	ld	s1,8(sp)
    800009e6:	6105                	addi	sp,sp,32
    800009e8:	8082                	ret

00000000800009ea <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    800009ea:	1101                	addi	sp,sp,-32
    800009ec:	ec06                	sd	ra,24(sp)
    800009ee:	e822                	sd	s0,16(sp)
    800009f0:	e426                	sd	s1,8(sp)
    800009f2:	e04a                	sd	s2,0(sp)
    800009f4:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    800009f6:	03451793          	slli	a5,a0,0x34
    800009fa:	e7a9                	bnez	a5,80000a44 <kfree+0x5a>
    800009fc:	84aa                	mv	s1,a0
    800009fe:	0003b797          	auipc	a5,0x3b
    80000a02:	60278793          	addi	a5,a5,1538 # 8003c000 <end>
    80000a06:	02f56f63          	bltu	a0,a5,80000a44 <kfree+0x5a>
    80000a0a:	47c5                	li	a5,17
    80000a0c:	07ee                	slli	a5,a5,0x1b
    80000a0e:	02f57b63          	bgeu	a0,a5,80000a44 <kfree+0x5a>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a12:	6605                	lui	a2,0x1
    80000a14:	4585                	li	a1,1
    80000a16:	258000ef          	jal	ra,80000c6e <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a1a:	0000f917          	auipc	s2,0xf
    80000a1e:	3a690913          	addi	s2,s2,934 # 8000fdc0 <kmem>
    80000a22:	854a                	mv	a0,s2
    80000a24:	176000ef          	jal	ra,80000b9a <acquire>
  r->next = kmem.freelist;
    80000a28:	01893783          	ld	a5,24(s2)
    80000a2c:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a2e:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a32:	854a                	mv	a0,s2
    80000a34:	1fe000ef          	jal	ra,80000c32 <release>
}
    80000a38:	60e2                	ld	ra,24(sp)
    80000a3a:	6442                	ld	s0,16(sp)
    80000a3c:	64a2                	ld	s1,8(sp)
    80000a3e:	6902                	ld	s2,0(sp)
    80000a40:	6105                	addi	sp,sp,32
    80000a42:	8082                	ret
    panic("kfree");
    80000a44:	00006517          	auipc	a0,0x6
    80000a48:	61450513          	addi	a0,a0,1556 # 80007058 <digits+0x20>
    80000a4c:	d0bff0ef          	jal	ra,80000756 <panic>

0000000080000a50 <freerange>:
{
    80000a50:	7179                	addi	sp,sp,-48
    80000a52:	f406                	sd	ra,40(sp)
    80000a54:	f022                	sd	s0,32(sp)
    80000a56:	ec26                	sd	s1,24(sp)
    80000a58:	e84a                	sd	s2,16(sp)
    80000a5a:	e44e                	sd	s3,8(sp)
    80000a5c:	e052                	sd	s4,0(sp)
    80000a5e:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000a60:	6785                	lui	a5,0x1
    80000a62:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    80000a66:	94aa                	add	s1,s1,a0
    80000a68:	757d                	lui	a0,0xfffff
    80000a6a:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a6c:	94be                	add	s1,s1,a5
    80000a6e:	0095ec63          	bltu	a1,s1,80000a86 <freerange+0x36>
    80000a72:	892e                	mv	s2,a1
    kfree(p);
    80000a74:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a76:	6985                	lui	s3,0x1
    kfree(p);
    80000a78:	01448533          	add	a0,s1,s4
    80000a7c:	f6fff0ef          	jal	ra,800009ea <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a80:	94ce                	add	s1,s1,s3
    80000a82:	fe997be3          	bgeu	s2,s1,80000a78 <freerange+0x28>
}
    80000a86:	70a2                	ld	ra,40(sp)
    80000a88:	7402                	ld	s0,32(sp)
    80000a8a:	64e2                	ld	s1,24(sp)
    80000a8c:	6942                	ld	s2,16(sp)
    80000a8e:	69a2                	ld	s3,8(sp)
    80000a90:	6a02                	ld	s4,0(sp)
    80000a92:	6145                	addi	sp,sp,48
    80000a94:	8082                	ret

0000000080000a96 <kinit>:
{
    80000a96:	1141                	addi	sp,sp,-16
    80000a98:	e406                	sd	ra,8(sp)
    80000a9a:	e022                	sd	s0,0(sp)
    80000a9c:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000a9e:	00006597          	auipc	a1,0x6
    80000aa2:	5c258593          	addi	a1,a1,1474 # 80007060 <digits+0x28>
    80000aa6:	0000f517          	auipc	a0,0xf
    80000aaa:	31a50513          	addi	a0,a0,794 # 8000fdc0 <kmem>
    80000aae:	06c000ef          	jal	ra,80000b1a <initlock>
  freerange(end, (void*)PHYSTOP);
    80000ab2:	45c5                	li	a1,17
    80000ab4:	05ee                	slli	a1,a1,0x1b
    80000ab6:	0003b517          	auipc	a0,0x3b
    80000aba:	54a50513          	addi	a0,a0,1354 # 8003c000 <end>
    80000abe:	f93ff0ef          	jal	ra,80000a50 <freerange>
}
    80000ac2:	60a2                	ld	ra,8(sp)
    80000ac4:	6402                	ld	s0,0(sp)
    80000ac6:	0141                	addi	sp,sp,16
    80000ac8:	8082                	ret

0000000080000aca <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000aca:	1101                	addi	sp,sp,-32
    80000acc:	ec06                	sd	ra,24(sp)
    80000ace:	e822                	sd	s0,16(sp)
    80000ad0:	e426                	sd	s1,8(sp)
    80000ad2:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000ad4:	0000f497          	auipc	s1,0xf
    80000ad8:	2ec48493          	addi	s1,s1,748 # 8000fdc0 <kmem>
    80000adc:	8526                	mv	a0,s1
    80000ade:	0bc000ef          	jal	ra,80000b9a <acquire>
  r = kmem.freelist;
    80000ae2:	6c84                	ld	s1,24(s1)
  if(r)
    80000ae4:	c485                	beqz	s1,80000b0c <kalloc+0x42>
    kmem.freelist = r->next;
    80000ae6:	609c                	ld	a5,0(s1)
    80000ae8:	0000f517          	auipc	a0,0xf
    80000aec:	2d850513          	addi	a0,a0,728 # 8000fdc0 <kmem>
    80000af0:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000af2:	140000ef          	jal	ra,80000c32 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000af6:	6605                	lui	a2,0x1
    80000af8:	4595                	li	a1,5
    80000afa:	8526                	mv	a0,s1
    80000afc:	172000ef          	jal	ra,80000c6e <memset>
  return (void*)r;
}
    80000b00:	8526                	mv	a0,s1
    80000b02:	60e2                	ld	ra,24(sp)
    80000b04:	6442                	ld	s0,16(sp)
    80000b06:	64a2                	ld	s1,8(sp)
    80000b08:	6105                	addi	sp,sp,32
    80000b0a:	8082                	ret
  release(&kmem.lock);
    80000b0c:	0000f517          	auipc	a0,0xf
    80000b10:	2b450513          	addi	a0,a0,692 # 8000fdc0 <kmem>
    80000b14:	11e000ef          	jal	ra,80000c32 <release>
  if(r)
    80000b18:	b7e5                	j	80000b00 <kalloc+0x36>

0000000080000b1a <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000b1a:	1141                	addi	sp,sp,-16
    80000b1c:	e422                	sd	s0,8(sp)
    80000b1e:	0800                	addi	s0,sp,16
  lk->name = name;
    80000b20:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000b22:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000b26:	00053823          	sd	zero,16(a0)
}
    80000b2a:	6422                	ld	s0,8(sp)
    80000b2c:	0141                	addi	sp,sp,16
    80000b2e:	8082                	ret

0000000080000b30 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000b30:	411c                	lw	a5,0(a0)
    80000b32:	e399                	bnez	a5,80000b38 <holding+0x8>
    80000b34:	4501                	li	a0,0
  return r;
}
    80000b36:	8082                	ret
{
    80000b38:	1101                	addi	sp,sp,-32
    80000b3a:	ec06                	sd	ra,24(sp)
    80000b3c:	e822                	sd	s0,16(sp)
    80000b3e:	e426                	sd	s1,8(sp)
    80000b40:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000b42:	6904                	ld	s1,16(a0)
    80000b44:	4f9000ef          	jal	ra,8000183c <mycpu>
    80000b48:	40a48533          	sub	a0,s1,a0
    80000b4c:	00153513          	seqz	a0,a0
}
    80000b50:	60e2                	ld	ra,24(sp)
    80000b52:	6442                	ld	s0,16(sp)
    80000b54:	64a2                	ld	s1,8(sp)
    80000b56:	6105                	addi	sp,sp,32
    80000b58:	8082                	ret

0000000080000b5a <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000b5a:	1101                	addi	sp,sp,-32
    80000b5c:	ec06                	sd	ra,24(sp)
    80000b5e:	e822                	sd	s0,16(sp)
    80000b60:	e426                	sd	s1,8(sp)
    80000b62:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000b64:	100024f3          	csrr	s1,sstatus
    80000b68:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000b6c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000b6e:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000b72:	4cb000ef          	jal	ra,8000183c <mycpu>
    80000b76:	5d3c                	lw	a5,120(a0)
    80000b78:	cb99                	beqz	a5,80000b8e <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000b7a:	4c3000ef          	jal	ra,8000183c <mycpu>
    80000b7e:	5d3c                	lw	a5,120(a0)
    80000b80:	2785                	addiw	a5,a5,1
    80000b82:	dd3c                	sw	a5,120(a0)
}
    80000b84:	60e2                	ld	ra,24(sp)
    80000b86:	6442                	ld	s0,16(sp)
    80000b88:	64a2                	ld	s1,8(sp)
    80000b8a:	6105                	addi	sp,sp,32
    80000b8c:	8082                	ret
    mycpu()->intena = old;
    80000b8e:	4af000ef          	jal	ra,8000183c <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000b92:	8085                	srli	s1,s1,0x1
    80000b94:	8885                	andi	s1,s1,1
    80000b96:	dd64                	sw	s1,124(a0)
    80000b98:	b7cd                	j	80000b7a <push_off+0x20>

0000000080000b9a <acquire>:
{
    80000b9a:	1101                	addi	sp,sp,-32
    80000b9c:	ec06                	sd	ra,24(sp)
    80000b9e:	e822                	sd	s0,16(sp)
    80000ba0:	e426                	sd	s1,8(sp)
    80000ba2:	1000                	addi	s0,sp,32
    80000ba4:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000ba6:	fb5ff0ef          	jal	ra,80000b5a <push_off>
  if(holding(lk))
    80000baa:	8526                	mv	a0,s1
    80000bac:	f85ff0ef          	jal	ra,80000b30 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000bb0:	4705                	li	a4,1
  if(holding(lk))
    80000bb2:	e105                	bnez	a0,80000bd2 <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000bb4:	87ba                	mv	a5,a4
    80000bb6:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000bba:	2781                	sext.w	a5,a5
    80000bbc:	ffe5                	bnez	a5,80000bb4 <acquire+0x1a>
  __sync_synchronize();
    80000bbe:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000bc2:	47b000ef          	jal	ra,8000183c <mycpu>
    80000bc6:	e888                	sd	a0,16(s1)
}
    80000bc8:	60e2                	ld	ra,24(sp)
    80000bca:	6442                	ld	s0,16(sp)
    80000bcc:	64a2                	ld	s1,8(sp)
    80000bce:	6105                	addi	sp,sp,32
    80000bd0:	8082                	ret
    panic("acquire");
    80000bd2:	00006517          	auipc	a0,0x6
    80000bd6:	49650513          	addi	a0,a0,1174 # 80007068 <digits+0x30>
    80000bda:	b7dff0ef          	jal	ra,80000756 <panic>

0000000080000bde <pop_off>:

void
pop_off(void)
{
    80000bde:	1141                	addi	sp,sp,-16
    80000be0:	e406                	sd	ra,8(sp)
    80000be2:	e022                	sd	s0,0(sp)
    80000be4:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000be6:	457000ef          	jal	ra,8000183c <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000bea:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000bee:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000bf0:	e78d                	bnez	a5,80000c1a <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000bf2:	5d3c                	lw	a5,120(a0)
    80000bf4:	02f05963          	blez	a5,80000c26 <pop_off+0x48>
    panic("pop_off");
  c->noff -= 1;
    80000bf8:	37fd                	addiw	a5,a5,-1
    80000bfa:	0007871b          	sext.w	a4,a5
    80000bfe:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000c00:	eb09                	bnez	a4,80000c12 <pop_off+0x34>
    80000c02:	5d7c                	lw	a5,124(a0)
    80000c04:	c799                	beqz	a5,80000c12 <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c06:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000c0a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c0e:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000c12:	60a2                	ld	ra,8(sp)
    80000c14:	6402                	ld	s0,0(sp)
    80000c16:	0141                	addi	sp,sp,16
    80000c18:	8082                	ret
    panic("pop_off - interruptible");
    80000c1a:	00006517          	auipc	a0,0x6
    80000c1e:	45650513          	addi	a0,a0,1110 # 80007070 <digits+0x38>
    80000c22:	b35ff0ef          	jal	ra,80000756 <panic>
    panic("pop_off");
    80000c26:	00006517          	auipc	a0,0x6
    80000c2a:	46250513          	addi	a0,a0,1122 # 80007088 <digits+0x50>
    80000c2e:	b29ff0ef          	jal	ra,80000756 <panic>

0000000080000c32 <release>:
{
    80000c32:	1101                	addi	sp,sp,-32
    80000c34:	ec06                	sd	ra,24(sp)
    80000c36:	e822                	sd	s0,16(sp)
    80000c38:	e426                	sd	s1,8(sp)
    80000c3a:	1000                	addi	s0,sp,32
    80000c3c:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000c3e:	ef3ff0ef          	jal	ra,80000b30 <holding>
    80000c42:	c105                	beqz	a0,80000c62 <release+0x30>
  lk->cpu = 0;
    80000c44:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000c48:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000c4c:	0f50000f          	fence	iorw,ow
    80000c50:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000c54:	f8bff0ef          	jal	ra,80000bde <pop_off>
}
    80000c58:	60e2                	ld	ra,24(sp)
    80000c5a:	6442                	ld	s0,16(sp)
    80000c5c:	64a2                	ld	s1,8(sp)
    80000c5e:	6105                	addi	sp,sp,32
    80000c60:	8082                	ret
    panic("release");
    80000c62:	00006517          	auipc	a0,0x6
    80000c66:	42e50513          	addi	a0,a0,1070 # 80007090 <digits+0x58>
    80000c6a:	aedff0ef          	jal	ra,80000756 <panic>

0000000080000c6e <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000c6e:	1141                	addi	sp,sp,-16
    80000c70:	e422                	sd	s0,8(sp)
    80000c72:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000c74:	ca19                	beqz	a2,80000c8a <memset+0x1c>
    80000c76:	87aa                	mv	a5,a0
    80000c78:	1602                	slli	a2,a2,0x20
    80000c7a:	9201                	srli	a2,a2,0x20
    80000c7c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000c80:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000c84:	0785                	addi	a5,a5,1
    80000c86:	fee79de3          	bne	a5,a4,80000c80 <memset+0x12>
  }
  return dst;
}
    80000c8a:	6422                	ld	s0,8(sp)
    80000c8c:	0141                	addi	sp,sp,16
    80000c8e:	8082                	ret

0000000080000c90 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000c90:	1141                	addi	sp,sp,-16
    80000c92:	e422                	sd	s0,8(sp)
    80000c94:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000c96:	ca05                	beqz	a2,80000cc6 <memcmp+0x36>
    80000c98:	fff6069b          	addiw	a3,a2,-1
    80000c9c:	1682                	slli	a3,a3,0x20
    80000c9e:	9281                	srli	a3,a3,0x20
    80000ca0:	0685                	addi	a3,a3,1
    80000ca2:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000ca4:	00054783          	lbu	a5,0(a0)
    80000ca8:	0005c703          	lbu	a4,0(a1)
    80000cac:	00e79863          	bne	a5,a4,80000cbc <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000cb0:	0505                	addi	a0,a0,1
    80000cb2:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000cb4:	fed518e3          	bne	a0,a3,80000ca4 <memcmp+0x14>
  }

  return 0;
    80000cb8:	4501                	li	a0,0
    80000cba:	a019                	j	80000cc0 <memcmp+0x30>
      return *s1 - *s2;
    80000cbc:	40e7853b          	subw	a0,a5,a4
}
    80000cc0:	6422                	ld	s0,8(sp)
    80000cc2:	0141                	addi	sp,sp,16
    80000cc4:	8082                	ret
  return 0;
    80000cc6:	4501                	li	a0,0
    80000cc8:	bfe5                	j	80000cc0 <memcmp+0x30>

0000000080000cca <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000cca:	1141                	addi	sp,sp,-16
    80000ccc:	e422                	sd	s0,8(sp)
    80000cce:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000cd0:	c205                	beqz	a2,80000cf0 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000cd2:	02a5e263          	bltu	a1,a0,80000cf6 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000cd6:	1602                	slli	a2,a2,0x20
    80000cd8:	9201                	srli	a2,a2,0x20
    80000cda:	00c587b3          	add	a5,a1,a2
{
    80000cde:	872a                	mv	a4,a0
      *d++ = *s++;
    80000ce0:	0585                	addi	a1,a1,1
    80000ce2:	0705                	addi	a4,a4,1
    80000ce4:	fff5c683          	lbu	a3,-1(a1)
    80000ce8:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000cec:	fef59ae3          	bne	a1,a5,80000ce0 <memmove+0x16>

  return dst;
}
    80000cf0:	6422                	ld	s0,8(sp)
    80000cf2:	0141                	addi	sp,sp,16
    80000cf4:	8082                	ret
  if(s < d && s + n > d){
    80000cf6:	02061693          	slli	a3,a2,0x20
    80000cfa:	9281                	srli	a3,a3,0x20
    80000cfc:	00d58733          	add	a4,a1,a3
    80000d00:	fce57be3          	bgeu	a0,a4,80000cd6 <memmove+0xc>
    d += n;
    80000d04:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000d06:	fff6079b          	addiw	a5,a2,-1
    80000d0a:	1782                	slli	a5,a5,0x20
    80000d0c:	9381                	srli	a5,a5,0x20
    80000d0e:	fff7c793          	not	a5,a5
    80000d12:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000d14:	177d                	addi	a4,a4,-1
    80000d16:	16fd                	addi	a3,a3,-1
    80000d18:	00074603          	lbu	a2,0(a4)
    80000d1c:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000d20:	fee79ae3          	bne	a5,a4,80000d14 <memmove+0x4a>
    80000d24:	b7f1                	j	80000cf0 <memmove+0x26>

0000000080000d26 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000d26:	1141                	addi	sp,sp,-16
    80000d28:	e406                	sd	ra,8(sp)
    80000d2a:	e022                	sd	s0,0(sp)
    80000d2c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000d2e:	f9dff0ef          	jal	ra,80000cca <memmove>
}
    80000d32:	60a2                	ld	ra,8(sp)
    80000d34:	6402                	ld	s0,0(sp)
    80000d36:	0141                	addi	sp,sp,16
    80000d38:	8082                	ret

0000000080000d3a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000d3a:	1141                	addi	sp,sp,-16
    80000d3c:	e422                	sd	s0,8(sp)
    80000d3e:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000d40:	ce11                	beqz	a2,80000d5c <strncmp+0x22>
    80000d42:	00054783          	lbu	a5,0(a0)
    80000d46:	cf89                	beqz	a5,80000d60 <strncmp+0x26>
    80000d48:	0005c703          	lbu	a4,0(a1)
    80000d4c:	00f71a63          	bne	a4,a5,80000d60 <strncmp+0x26>
    n--, p++, q++;
    80000d50:	367d                	addiw	a2,a2,-1
    80000d52:	0505                	addi	a0,a0,1
    80000d54:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000d56:	f675                	bnez	a2,80000d42 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000d58:	4501                	li	a0,0
    80000d5a:	a809                	j	80000d6c <strncmp+0x32>
    80000d5c:	4501                	li	a0,0
    80000d5e:	a039                	j	80000d6c <strncmp+0x32>
  if(n == 0)
    80000d60:	ca09                	beqz	a2,80000d72 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000d62:	00054503          	lbu	a0,0(a0)
    80000d66:	0005c783          	lbu	a5,0(a1)
    80000d6a:	9d1d                	subw	a0,a0,a5
}
    80000d6c:	6422                	ld	s0,8(sp)
    80000d6e:	0141                	addi	sp,sp,16
    80000d70:	8082                	ret
    return 0;
    80000d72:	4501                	li	a0,0
    80000d74:	bfe5                	j	80000d6c <strncmp+0x32>

0000000080000d76 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000d76:	1141                	addi	sp,sp,-16
    80000d78:	e422                	sd	s0,8(sp)
    80000d7a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000d7c:	872a                	mv	a4,a0
    80000d7e:	8832                	mv	a6,a2
    80000d80:	367d                	addiw	a2,a2,-1
    80000d82:	01005963          	blez	a6,80000d94 <strncpy+0x1e>
    80000d86:	0705                	addi	a4,a4,1
    80000d88:	0005c783          	lbu	a5,0(a1)
    80000d8c:	fef70fa3          	sb	a5,-1(a4)
    80000d90:	0585                	addi	a1,a1,1
    80000d92:	f7f5                	bnez	a5,80000d7e <strncpy+0x8>
    ;
  while(n-- > 0)
    80000d94:	86ba                	mv	a3,a4
    80000d96:	00c05c63          	blez	a2,80000dae <strncpy+0x38>
    *s++ = 0;
    80000d9a:	0685                	addi	a3,a3,1
    80000d9c:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000da0:	fff6c793          	not	a5,a3
    80000da4:	9fb9                	addw	a5,a5,a4
    80000da6:	010787bb          	addw	a5,a5,a6
    80000daa:	fef048e3          	bgtz	a5,80000d9a <strncpy+0x24>
  return os;
}
    80000dae:	6422                	ld	s0,8(sp)
    80000db0:	0141                	addi	sp,sp,16
    80000db2:	8082                	ret

0000000080000db4 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000db4:	1141                	addi	sp,sp,-16
    80000db6:	e422                	sd	s0,8(sp)
    80000db8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000dba:	02c05363          	blez	a2,80000de0 <safestrcpy+0x2c>
    80000dbe:	fff6069b          	addiw	a3,a2,-1
    80000dc2:	1682                	slli	a3,a3,0x20
    80000dc4:	9281                	srli	a3,a3,0x20
    80000dc6:	96ae                	add	a3,a3,a1
    80000dc8:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000dca:	00d58963          	beq	a1,a3,80000ddc <safestrcpy+0x28>
    80000dce:	0585                	addi	a1,a1,1
    80000dd0:	0785                	addi	a5,a5,1
    80000dd2:	fff5c703          	lbu	a4,-1(a1)
    80000dd6:	fee78fa3          	sb	a4,-1(a5)
    80000dda:	fb65                	bnez	a4,80000dca <safestrcpy+0x16>
    ;
  *s = 0;
    80000ddc:	00078023          	sb	zero,0(a5)
  return os;
}
    80000de0:	6422                	ld	s0,8(sp)
    80000de2:	0141                	addi	sp,sp,16
    80000de4:	8082                	ret

0000000080000de6 <strlen>:

int
strlen(const char *s)
{
    80000de6:	1141                	addi	sp,sp,-16
    80000de8:	e422                	sd	s0,8(sp)
    80000dea:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000dec:	00054783          	lbu	a5,0(a0)
    80000df0:	cf91                	beqz	a5,80000e0c <strlen+0x26>
    80000df2:	0505                	addi	a0,a0,1
    80000df4:	87aa                	mv	a5,a0
    80000df6:	4685                	li	a3,1
    80000df8:	9e89                	subw	a3,a3,a0
    80000dfa:	00f6853b          	addw	a0,a3,a5
    80000dfe:	0785                	addi	a5,a5,1
    80000e00:	fff7c703          	lbu	a4,-1(a5)
    80000e04:	fb7d                	bnez	a4,80000dfa <strlen+0x14>
    ;
  return n;
}
    80000e06:	6422                	ld	s0,8(sp)
    80000e08:	0141                	addi	sp,sp,16
    80000e0a:	8082                	ret
  for(n = 0; s[n]; n++)
    80000e0c:	4501                	li	a0,0
    80000e0e:	bfe5                	j	80000e06 <strlen+0x20>

0000000080000e10 <check>:
#include "debug.h"
#include "defs.h"
#include "slab.h"

void check()
{
    80000e10:	1141                	addi	sp,sp,-16
    80000e12:	e406                	sd	ra,8(sp)
    80000e14:	e022                	sd	s0,0(sp)
    80000e16:	0800                	addi	s0,sp,16
  debug("[MP2] Slab size: %lu\n", sizeof(struct slab) / sizeof(void *));
    80000e18:	145040ef          	jal	ra,8000575c <get_mode>
    80000e1c:	2501                	sext.w	a0,a0
    80000e1e:	e509                	bnez	a0,80000e28 <check+0x18>
}
    80000e20:	60a2                	ld	ra,8(sp)
    80000e22:	6402                	ld	s0,0(sp)
    80000e24:	0141                	addi	sp,sp,16
    80000e26:	8082                	ret
  debug("[MP2] Slab size: %lu\n", sizeof(struct slab) / sizeof(void *));
    80000e28:	458d                	li	a1,3
    80000e2a:	00006517          	auipc	a0,0x6
    80000e2e:	26e50513          	addi	a0,a0,622 # 80007098 <digits+0x60>
    80000e32:	e70ff0ef          	jal	ra,800004a2 <printf>
}
    80000e36:	b7ed                	j	80000e20 <check+0x10>

0000000080000e38 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000e38:	1141                	addi	sp,sp,-16
    80000e3a:	e406                	sd	ra,8(sp)
    80000e3c:	e022                	sd	s0,0(sp)
    80000e3e:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000e40:	1ed000ef          	jal	ra,8000182c <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000e44:	00007717          	auipc	a4,0x7
    80000e48:	e5470713          	addi	a4,a4,-428 # 80007c98 <started>
  if(cpuid() == 0){
    80000e4c:	c51d                	beqz	a0,80000e7a <main+0x42>
    while(started == 0)
    80000e4e:	431c                	lw	a5,0(a4)
    80000e50:	2781                	sext.w	a5,a5
    80000e52:	dff5                	beqz	a5,80000e4e <main+0x16>
      ;
    __sync_synchronize();
    80000e54:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000e58:	1d5000ef          	jal	ra,8000182c <cpuid>
    80000e5c:	85aa                	mv	a1,a0
    80000e5e:	00006517          	auipc	a0,0x6
    80000e62:	26a50513          	addi	a0,a0,618 # 800070c8 <digits+0x90>
    80000e66:	e3cff0ef          	jal	ra,800004a2 <printf>
    kvminithart();    // turn on paging
    80000e6a:	084000ef          	jal	ra,80000eee <kvminithart>
    trapinithart();   // install kernel trap vector
    80000e6e:	4d6010ef          	jal	ra,80002344 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000e72:	352040ef          	jal	ra,800051c4 <plicinithart>
  }

  scheduler();        
    80000e76:	615000ef          	jal	ra,80001c8a <scheduler>
    consoleinit();
    80000e7a:	d50ff0ef          	jal	ra,800003ca <consoleinit>
    printfinit();
    80000e7e:	913ff0ef          	jal	ra,80000790 <printfinit>
    printf("\n");
    80000e82:	00007517          	auipc	a0,0x7
    80000e86:	8fe50513          	addi	a0,a0,-1794 # 80007780 <syscalls+0x2d8>
    80000e8a:	e18ff0ef          	jal	ra,800004a2 <printf>
    printf("xv6 kernel is booting\n");
    80000e8e:	00006517          	auipc	a0,0x6
    80000e92:	22250513          	addi	a0,a0,546 # 800070b0 <digits+0x78>
    80000e96:	e0cff0ef          	jal	ra,800004a2 <printf>
    printf("\n");
    80000e9a:	00007517          	auipc	a0,0x7
    80000e9e:	8e650513          	addi	a0,a0,-1818 # 80007780 <syscalls+0x2d8>
    80000ea2:	e00ff0ef          	jal	ra,800004a2 <printf>
    check();
    80000ea6:	f6bff0ef          	jal	ra,80000e10 <check>
    kinit();         // physical page allocator
    80000eaa:	bedff0ef          	jal	ra,80000a96 <kinit>
    kvminit();       // create kernel page table
    80000eae:	2ca000ef          	jal	ra,80001178 <kvminit>
    kvminithart();   // turn on paging
    80000eb2:	03c000ef          	jal	ra,80000eee <kvminithart>
    procinit();      // process table
    80000eb6:	0cf000ef          	jal	ra,80001784 <procinit>
    trapinit();      // trap vectors
    80000eba:	466010ef          	jal	ra,80002320 <trapinit>
    trapinithart();  // install kernel trap vector
    80000ebe:	486010ef          	jal	ra,80002344 <trapinithart>
    plicinit();      // set up interrupt controller
    80000ec2:	2ec040ef          	jal	ra,800051ae <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000ec6:	2fe040ef          	jal	ra,800051c4 <plicinithart>
    binit();         // buffer cache
    80000eca:	2a5010ef          	jal	ra,8000296e <binit>
    iinit();         // inode table
    80000ece:	084020ef          	jal	ra,80002f52 <iinit>
    fileinit();      // file table
    80000ed2:	68d020ef          	jal	ra,80003d5e <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000ed6:	3de040ef          	jal	ra,800052b4 <virtio_disk_init>
    userinit();      // first user process
    80000eda:	3e7000ef          	jal	ra,80001ac0 <userinit>
    __sync_synchronize();
    80000ede:	0ff0000f          	fence
    started = 1;
    80000ee2:	4785                	li	a5,1
    80000ee4:	00007717          	auipc	a4,0x7
    80000ee8:	daf72a23          	sw	a5,-588(a4) # 80007c98 <started>
    80000eec:	b769                	j	80000e76 <main+0x3e>

0000000080000eee <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000eee:	1141                	addi	sp,sp,-16
    80000ef0:	e422                	sd	s0,8(sp)
    80000ef2:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000ef4:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000ef8:	00007797          	auipc	a5,0x7
    80000efc:	da87b783          	ld	a5,-600(a5) # 80007ca0 <kernel_pagetable>
    80000f00:	83b1                	srli	a5,a5,0xc
    80000f02:	577d                	li	a4,-1
    80000f04:	177e                	slli	a4,a4,0x3f
    80000f06:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000f08:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000f0c:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000f10:	6422                	ld	s0,8(sp)
    80000f12:	0141                	addi	sp,sp,16
    80000f14:	8082                	ret

0000000080000f16 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000f16:	7139                	addi	sp,sp,-64
    80000f18:	fc06                	sd	ra,56(sp)
    80000f1a:	f822                	sd	s0,48(sp)
    80000f1c:	f426                	sd	s1,40(sp)
    80000f1e:	f04a                	sd	s2,32(sp)
    80000f20:	ec4e                	sd	s3,24(sp)
    80000f22:	e852                	sd	s4,16(sp)
    80000f24:	e456                	sd	s5,8(sp)
    80000f26:	e05a                	sd	s6,0(sp)
    80000f28:	0080                	addi	s0,sp,64
    80000f2a:	84aa                	mv	s1,a0
    80000f2c:	89ae                	mv	s3,a1
    80000f2e:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000f30:	57fd                	li	a5,-1
    80000f32:	83e9                	srli	a5,a5,0x1a
    80000f34:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000f36:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000f38:	02b7fc63          	bgeu	a5,a1,80000f70 <walk+0x5a>
    panic("walk");
    80000f3c:	00006517          	auipc	a0,0x6
    80000f40:	1a450513          	addi	a0,a0,420 # 800070e0 <digits+0xa8>
    80000f44:	813ff0ef          	jal	ra,80000756 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000f48:	060a8263          	beqz	s5,80000fac <walk+0x96>
    80000f4c:	b7fff0ef          	jal	ra,80000aca <kalloc>
    80000f50:	84aa                	mv	s1,a0
    80000f52:	c139                	beqz	a0,80000f98 <walk+0x82>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000f54:	6605                	lui	a2,0x1
    80000f56:	4581                	li	a1,0
    80000f58:	d17ff0ef          	jal	ra,80000c6e <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000f5c:	00c4d793          	srli	a5,s1,0xc
    80000f60:	07aa                	slli	a5,a5,0xa
    80000f62:	0017e793          	ori	a5,a5,1
    80000f66:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80000f6a:	3a5d                	addiw	s4,s4,-9
    80000f6c:	036a0063          	beq	s4,s6,80000f8c <walk+0x76>
    pte_t *pte = &pagetable[PX(level, va)];
    80000f70:	0149d933          	srl	s2,s3,s4
    80000f74:	1ff97913          	andi	s2,s2,511
    80000f78:	090e                	slli	s2,s2,0x3
    80000f7a:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000f7c:	00093483          	ld	s1,0(s2)
    80000f80:	0014f793          	andi	a5,s1,1
    80000f84:	d3f1                	beqz	a5,80000f48 <walk+0x32>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000f86:	80a9                	srli	s1,s1,0xa
    80000f88:	04b2                	slli	s1,s1,0xc
    80000f8a:	b7c5                	j	80000f6a <walk+0x54>
    }
  }
  return &pagetable[PX(0, va)];
    80000f8c:	00c9d513          	srli	a0,s3,0xc
    80000f90:	1ff57513          	andi	a0,a0,511
    80000f94:	050e                	slli	a0,a0,0x3
    80000f96:	9526                	add	a0,a0,s1
}
    80000f98:	70e2                	ld	ra,56(sp)
    80000f9a:	7442                	ld	s0,48(sp)
    80000f9c:	74a2                	ld	s1,40(sp)
    80000f9e:	7902                	ld	s2,32(sp)
    80000fa0:	69e2                	ld	s3,24(sp)
    80000fa2:	6a42                	ld	s4,16(sp)
    80000fa4:	6aa2                	ld	s5,8(sp)
    80000fa6:	6b02                	ld	s6,0(sp)
    80000fa8:	6121                	addi	sp,sp,64
    80000faa:	8082                	ret
        return 0;
    80000fac:	4501                	li	a0,0
    80000fae:	b7ed                	j	80000f98 <walk+0x82>

0000000080000fb0 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000fb0:	57fd                	li	a5,-1
    80000fb2:	83e9                	srli	a5,a5,0x1a
    80000fb4:	00b7f463          	bgeu	a5,a1,80000fbc <walkaddr+0xc>
    return 0;
    80000fb8:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000fba:	8082                	ret
{
    80000fbc:	1141                	addi	sp,sp,-16
    80000fbe:	e406                	sd	ra,8(sp)
    80000fc0:	e022                	sd	s0,0(sp)
    80000fc2:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000fc4:	4601                	li	a2,0
    80000fc6:	f51ff0ef          	jal	ra,80000f16 <walk>
  if(pte == 0)
    80000fca:	c105                	beqz	a0,80000fea <walkaddr+0x3a>
  if((*pte & PTE_V) == 0)
    80000fcc:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000fce:	0117f693          	andi	a3,a5,17
    80000fd2:	4745                	li	a4,17
    return 0;
    80000fd4:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000fd6:	00e68663          	beq	a3,a4,80000fe2 <walkaddr+0x32>
}
    80000fda:	60a2                	ld	ra,8(sp)
    80000fdc:	6402                	ld	s0,0(sp)
    80000fde:	0141                	addi	sp,sp,16
    80000fe0:	8082                	ret
  pa = PTE2PA(*pte);
    80000fe2:	00a7d513          	srli	a0,a5,0xa
    80000fe6:	0532                	slli	a0,a0,0xc
  return pa;
    80000fe8:	bfcd                	j	80000fda <walkaddr+0x2a>
    return 0;
    80000fea:	4501                	li	a0,0
    80000fec:	b7fd                	j	80000fda <walkaddr+0x2a>

0000000080000fee <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000fee:	715d                	addi	sp,sp,-80
    80000ff0:	e486                	sd	ra,72(sp)
    80000ff2:	e0a2                	sd	s0,64(sp)
    80000ff4:	fc26                	sd	s1,56(sp)
    80000ff6:	f84a                	sd	s2,48(sp)
    80000ff8:	f44e                	sd	s3,40(sp)
    80000ffa:	f052                	sd	s4,32(sp)
    80000ffc:	ec56                	sd	s5,24(sp)
    80000ffe:	e85a                	sd	s6,16(sp)
    80001000:	e45e                	sd	s7,8(sp)
    80001002:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80001004:	03459793          	slli	a5,a1,0x34
    80001008:	e7a9                	bnez	a5,80001052 <mappages+0x64>
    8000100a:	8aaa                	mv	s5,a0
    8000100c:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    8000100e:	03461793          	slli	a5,a2,0x34
    80001012:	e7b1                	bnez	a5,8000105e <mappages+0x70>
    panic("mappages: size not aligned");

  if(size == 0)
    80001014:	ca39                	beqz	a2,8000106a <mappages+0x7c>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    80001016:	79fd                	lui	s3,0xfffff
    80001018:	964e                	add	a2,a2,s3
    8000101a:	00b609b3          	add	s3,a2,a1
  a = va;
    8000101e:	892e                	mv	s2,a1
    80001020:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80001024:	6b85                	lui	s7,0x1
    80001026:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    8000102a:	4605                	li	a2,1
    8000102c:	85ca                	mv	a1,s2
    8000102e:	8556                	mv	a0,s5
    80001030:	ee7ff0ef          	jal	ra,80000f16 <walk>
    80001034:	c539                	beqz	a0,80001082 <mappages+0x94>
    if(*pte & PTE_V)
    80001036:	611c                	ld	a5,0(a0)
    80001038:	8b85                	andi	a5,a5,1
    8000103a:	ef95                	bnez	a5,80001076 <mappages+0x88>
    *pte = PA2PTE(pa) | perm | PTE_V;
    8000103c:	80b1                	srli	s1,s1,0xc
    8000103e:	04aa                	slli	s1,s1,0xa
    80001040:	0164e4b3          	or	s1,s1,s6
    80001044:	0014e493          	ori	s1,s1,1
    80001048:	e104                	sd	s1,0(a0)
    if(a == last)
    8000104a:	05390863          	beq	s2,s3,8000109a <mappages+0xac>
    a += PGSIZE;
    8000104e:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    80001050:	bfd9                	j	80001026 <mappages+0x38>
    panic("mappages: va not aligned");
    80001052:	00006517          	auipc	a0,0x6
    80001056:	09650513          	addi	a0,a0,150 # 800070e8 <digits+0xb0>
    8000105a:	efcff0ef          	jal	ra,80000756 <panic>
    panic("mappages: size not aligned");
    8000105e:	00006517          	auipc	a0,0x6
    80001062:	0aa50513          	addi	a0,a0,170 # 80007108 <digits+0xd0>
    80001066:	ef0ff0ef          	jal	ra,80000756 <panic>
    panic("mappages: size");
    8000106a:	00006517          	auipc	a0,0x6
    8000106e:	0be50513          	addi	a0,a0,190 # 80007128 <digits+0xf0>
    80001072:	ee4ff0ef          	jal	ra,80000756 <panic>
      panic("mappages: remap");
    80001076:	00006517          	auipc	a0,0x6
    8000107a:	0c250513          	addi	a0,a0,194 # 80007138 <digits+0x100>
    8000107e:	ed8ff0ef          	jal	ra,80000756 <panic>
      return -1;
    80001082:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80001084:	60a6                	ld	ra,72(sp)
    80001086:	6406                	ld	s0,64(sp)
    80001088:	74e2                	ld	s1,56(sp)
    8000108a:	7942                	ld	s2,48(sp)
    8000108c:	79a2                	ld	s3,40(sp)
    8000108e:	7a02                	ld	s4,32(sp)
    80001090:	6ae2                	ld	s5,24(sp)
    80001092:	6b42                	ld	s6,16(sp)
    80001094:	6ba2                	ld	s7,8(sp)
    80001096:	6161                	addi	sp,sp,80
    80001098:	8082                	ret
  return 0;
    8000109a:	4501                	li	a0,0
    8000109c:	b7e5                	j	80001084 <mappages+0x96>

000000008000109e <kvmmap>:
{
    8000109e:	1141                	addi	sp,sp,-16
    800010a0:	e406                	sd	ra,8(sp)
    800010a2:	e022                	sd	s0,0(sp)
    800010a4:	0800                	addi	s0,sp,16
    800010a6:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800010a8:	86b2                	mv	a3,a2
    800010aa:	863e                	mv	a2,a5
    800010ac:	f43ff0ef          	jal	ra,80000fee <mappages>
    800010b0:	e509                	bnez	a0,800010ba <kvmmap+0x1c>
}
    800010b2:	60a2                	ld	ra,8(sp)
    800010b4:	6402                	ld	s0,0(sp)
    800010b6:	0141                	addi	sp,sp,16
    800010b8:	8082                	ret
    panic("kvmmap");
    800010ba:	00006517          	auipc	a0,0x6
    800010be:	08e50513          	addi	a0,a0,142 # 80007148 <digits+0x110>
    800010c2:	e94ff0ef          	jal	ra,80000756 <panic>

00000000800010c6 <kvmmake>:
{
    800010c6:	1101                	addi	sp,sp,-32
    800010c8:	ec06                	sd	ra,24(sp)
    800010ca:	e822                	sd	s0,16(sp)
    800010cc:	e426                	sd	s1,8(sp)
    800010ce:	e04a                	sd	s2,0(sp)
    800010d0:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    800010d2:	9f9ff0ef          	jal	ra,80000aca <kalloc>
    800010d6:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800010d8:	6605                	lui	a2,0x1
    800010da:	4581                	li	a1,0
    800010dc:	b93ff0ef          	jal	ra,80000c6e <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800010e0:	4719                	li	a4,6
    800010e2:	6685                	lui	a3,0x1
    800010e4:	10000637          	lui	a2,0x10000
    800010e8:	100005b7          	lui	a1,0x10000
    800010ec:	8526                	mv	a0,s1
    800010ee:	fb1ff0ef          	jal	ra,8000109e <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800010f2:	4719                	li	a4,6
    800010f4:	6685                	lui	a3,0x1
    800010f6:	10001637          	lui	a2,0x10001
    800010fa:	100015b7          	lui	a1,0x10001
    800010fe:	8526                	mv	a0,s1
    80001100:	f9fff0ef          	jal	ra,8000109e <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    80001104:	4719                	li	a4,6
    80001106:	040006b7          	lui	a3,0x4000
    8000110a:	0c000637          	lui	a2,0xc000
    8000110e:	0c0005b7          	lui	a1,0xc000
    80001112:	8526                	mv	a0,s1
    80001114:	f8bff0ef          	jal	ra,8000109e <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80001118:	00006917          	auipc	s2,0x6
    8000111c:	ee890913          	addi	s2,s2,-280 # 80007000 <etext>
    80001120:	4729                	li	a4,10
    80001122:	80006697          	auipc	a3,0x80006
    80001126:	ede68693          	addi	a3,a3,-290 # 7000 <_entry-0x7fff9000>
    8000112a:	4605                	li	a2,1
    8000112c:	067e                	slli	a2,a2,0x1f
    8000112e:	85b2                	mv	a1,a2
    80001130:	8526                	mv	a0,s1
    80001132:	f6dff0ef          	jal	ra,8000109e <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80001136:	4719                	li	a4,6
    80001138:	46c5                	li	a3,17
    8000113a:	06ee                	slli	a3,a3,0x1b
    8000113c:	412686b3          	sub	a3,a3,s2
    80001140:	864a                	mv	a2,s2
    80001142:	85ca                	mv	a1,s2
    80001144:	8526                	mv	a0,s1
    80001146:	f59ff0ef          	jal	ra,8000109e <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    8000114a:	4729                	li	a4,10
    8000114c:	6685                	lui	a3,0x1
    8000114e:	00005617          	auipc	a2,0x5
    80001152:	eb260613          	addi	a2,a2,-334 # 80006000 <_trampoline>
    80001156:	040005b7          	lui	a1,0x4000
    8000115a:	15fd                	addi	a1,a1,-1
    8000115c:	05b2                	slli	a1,a1,0xc
    8000115e:	8526                	mv	a0,s1
    80001160:	f3fff0ef          	jal	ra,8000109e <kvmmap>
  proc_mapstacks(kpgtbl);
    80001164:	8526                	mv	a0,s1
    80001166:	594000ef          	jal	ra,800016fa <proc_mapstacks>
}
    8000116a:	8526                	mv	a0,s1
    8000116c:	60e2                	ld	ra,24(sp)
    8000116e:	6442                	ld	s0,16(sp)
    80001170:	64a2                	ld	s1,8(sp)
    80001172:	6902                	ld	s2,0(sp)
    80001174:	6105                	addi	sp,sp,32
    80001176:	8082                	ret

0000000080001178 <kvminit>:
{
    80001178:	1141                	addi	sp,sp,-16
    8000117a:	e406                	sd	ra,8(sp)
    8000117c:	e022                	sd	s0,0(sp)
    8000117e:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80001180:	f47ff0ef          	jal	ra,800010c6 <kvmmake>
    80001184:	00007797          	auipc	a5,0x7
    80001188:	b0a7be23          	sd	a0,-1252(a5) # 80007ca0 <kernel_pagetable>
}
    8000118c:	60a2                	ld	ra,8(sp)
    8000118e:	6402                	ld	s0,0(sp)
    80001190:	0141                	addi	sp,sp,16
    80001192:	8082                	ret

0000000080001194 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80001194:	715d                	addi	sp,sp,-80
    80001196:	e486                	sd	ra,72(sp)
    80001198:	e0a2                	sd	s0,64(sp)
    8000119a:	fc26                	sd	s1,56(sp)
    8000119c:	f84a                	sd	s2,48(sp)
    8000119e:	f44e                	sd	s3,40(sp)
    800011a0:	f052                	sd	s4,32(sp)
    800011a2:	ec56                	sd	s5,24(sp)
    800011a4:	e85a                	sd	s6,16(sp)
    800011a6:	e45e                	sd	s7,8(sp)
    800011a8:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800011aa:	03459793          	slli	a5,a1,0x34
    800011ae:	e795                	bnez	a5,800011da <uvmunmap+0x46>
    800011b0:	8a2a                	mv	s4,a0
    800011b2:	892e                	mv	s2,a1
    800011b4:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800011b6:	0632                	slli	a2,a2,0xc
    800011b8:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    800011bc:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800011be:	6b05                	lui	s6,0x1
    800011c0:	0535ea63          	bltu	a1,s3,80001214 <uvmunmap+0x80>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    800011c4:	60a6                	ld	ra,72(sp)
    800011c6:	6406                	ld	s0,64(sp)
    800011c8:	74e2                	ld	s1,56(sp)
    800011ca:	7942                	ld	s2,48(sp)
    800011cc:	79a2                	ld	s3,40(sp)
    800011ce:	7a02                	ld	s4,32(sp)
    800011d0:	6ae2                	ld	s5,24(sp)
    800011d2:	6b42                	ld	s6,16(sp)
    800011d4:	6ba2                	ld	s7,8(sp)
    800011d6:	6161                	addi	sp,sp,80
    800011d8:	8082                	ret
    panic("uvmunmap: not aligned");
    800011da:	00006517          	auipc	a0,0x6
    800011de:	f7650513          	addi	a0,a0,-138 # 80007150 <digits+0x118>
    800011e2:	d74ff0ef          	jal	ra,80000756 <panic>
      panic("uvmunmap: walk");
    800011e6:	00006517          	auipc	a0,0x6
    800011ea:	f8250513          	addi	a0,a0,-126 # 80007168 <digits+0x130>
    800011ee:	d68ff0ef          	jal	ra,80000756 <panic>
      panic("uvmunmap: not mapped");
    800011f2:	00006517          	auipc	a0,0x6
    800011f6:	f8650513          	addi	a0,a0,-122 # 80007178 <digits+0x140>
    800011fa:	d5cff0ef          	jal	ra,80000756 <panic>
      panic("uvmunmap: not a leaf");
    800011fe:	00006517          	auipc	a0,0x6
    80001202:	f9250513          	addi	a0,a0,-110 # 80007190 <digits+0x158>
    80001206:	d50ff0ef          	jal	ra,80000756 <panic>
    *pte = 0;
    8000120a:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000120e:	995a                	add	s2,s2,s6
    80001210:	fb397ae3          	bgeu	s2,s3,800011c4 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    80001214:	4601                	li	a2,0
    80001216:	85ca                	mv	a1,s2
    80001218:	8552                	mv	a0,s4
    8000121a:	cfdff0ef          	jal	ra,80000f16 <walk>
    8000121e:	84aa                	mv	s1,a0
    80001220:	d179                	beqz	a0,800011e6 <uvmunmap+0x52>
    if((*pte & PTE_V) == 0)
    80001222:	6108                	ld	a0,0(a0)
    80001224:	00157793          	andi	a5,a0,1
    80001228:	d7e9                	beqz	a5,800011f2 <uvmunmap+0x5e>
    if(PTE_FLAGS(*pte) == PTE_V)
    8000122a:	3ff57793          	andi	a5,a0,1023
    8000122e:	fd7788e3          	beq	a5,s7,800011fe <uvmunmap+0x6a>
    if(do_free){
    80001232:	fc0a8ce3          	beqz	s5,8000120a <uvmunmap+0x76>
      uint64 pa = PTE2PA(*pte);
    80001236:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80001238:	0532                	slli	a0,a0,0xc
    8000123a:	fb0ff0ef          	jal	ra,800009ea <kfree>
    8000123e:	b7f1                	j	8000120a <uvmunmap+0x76>

0000000080001240 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80001240:	1101                	addi	sp,sp,-32
    80001242:	ec06                	sd	ra,24(sp)
    80001244:	e822                	sd	s0,16(sp)
    80001246:	e426                	sd	s1,8(sp)
    80001248:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    8000124a:	881ff0ef          	jal	ra,80000aca <kalloc>
    8000124e:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001250:	c509                	beqz	a0,8000125a <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80001252:	6605                	lui	a2,0x1
    80001254:	4581                	li	a1,0
    80001256:	a19ff0ef          	jal	ra,80000c6e <memset>
  return pagetable;
}
    8000125a:	8526                	mv	a0,s1
    8000125c:	60e2                	ld	ra,24(sp)
    8000125e:	6442                	ld	s0,16(sp)
    80001260:	64a2                	ld	s1,8(sp)
    80001262:	6105                	addi	sp,sp,32
    80001264:	8082                	ret

0000000080001266 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80001266:	7179                	addi	sp,sp,-48
    80001268:	f406                	sd	ra,40(sp)
    8000126a:	f022                	sd	s0,32(sp)
    8000126c:	ec26                	sd	s1,24(sp)
    8000126e:	e84a                	sd	s2,16(sp)
    80001270:	e44e                	sd	s3,8(sp)
    80001272:	e052                	sd	s4,0(sp)
    80001274:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80001276:	6785                	lui	a5,0x1
    80001278:	04f67063          	bgeu	a2,a5,800012b8 <uvmfirst+0x52>
    8000127c:	8a2a                	mv	s4,a0
    8000127e:	89ae                	mv	s3,a1
    80001280:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80001282:	849ff0ef          	jal	ra,80000aca <kalloc>
    80001286:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80001288:	6605                	lui	a2,0x1
    8000128a:	4581                	li	a1,0
    8000128c:	9e3ff0ef          	jal	ra,80000c6e <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80001290:	4779                	li	a4,30
    80001292:	86ca                	mv	a3,s2
    80001294:	6605                	lui	a2,0x1
    80001296:	4581                	li	a1,0
    80001298:	8552                	mv	a0,s4
    8000129a:	d55ff0ef          	jal	ra,80000fee <mappages>
  memmove(mem, src, sz);
    8000129e:	8626                	mv	a2,s1
    800012a0:	85ce                	mv	a1,s3
    800012a2:	854a                	mv	a0,s2
    800012a4:	a27ff0ef          	jal	ra,80000cca <memmove>
}
    800012a8:	70a2                	ld	ra,40(sp)
    800012aa:	7402                	ld	s0,32(sp)
    800012ac:	64e2                	ld	s1,24(sp)
    800012ae:	6942                	ld	s2,16(sp)
    800012b0:	69a2                	ld	s3,8(sp)
    800012b2:	6a02                	ld	s4,0(sp)
    800012b4:	6145                	addi	sp,sp,48
    800012b6:	8082                	ret
    panic("uvmfirst: more than a page");
    800012b8:	00006517          	auipc	a0,0x6
    800012bc:	ef050513          	addi	a0,a0,-272 # 800071a8 <digits+0x170>
    800012c0:	c96ff0ef          	jal	ra,80000756 <panic>

00000000800012c4 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800012c4:	1101                	addi	sp,sp,-32
    800012c6:	ec06                	sd	ra,24(sp)
    800012c8:	e822                	sd	s0,16(sp)
    800012ca:	e426                	sd	s1,8(sp)
    800012cc:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800012ce:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800012d0:	00b67d63          	bgeu	a2,a1,800012ea <uvmdealloc+0x26>
    800012d4:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800012d6:	6785                	lui	a5,0x1
    800012d8:	17fd                	addi	a5,a5,-1
    800012da:	00f60733          	add	a4,a2,a5
    800012de:	767d                	lui	a2,0xfffff
    800012e0:	8f71                	and	a4,a4,a2
    800012e2:	97ae                	add	a5,a5,a1
    800012e4:	8ff1                	and	a5,a5,a2
    800012e6:	00f76863          	bltu	a4,a5,800012f6 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800012ea:	8526                	mv	a0,s1
    800012ec:	60e2                	ld	ra,24(sp)
    800012ee:	6442                	ld	s0,16(sp)
    800012f0:	64a2                	ld	s1,8(sp)
    800012f2:	6105                	addi	sp,sp,32
    800012f4:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800012f6:	8f99                	sub	a5,a5,a4
    800012f8:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800012fa:	4685                	li	a3,1
    800012fc:	0007861b          	sext.w	a2,a5
    80001300:	85ba                	mv	a1,a4
    80001302:	e93ff0ef          	jal	ra,80001194 <uvmunmap>
    80001306:	b7d5                	j	800012ea <uvmdealloc+0x26>

0000000080001308 <uvmalloc>:
  if(newsz < oldsz)
    80001308:	08b66963          	bltu	a2,a1,8000139a <uvmalloc+0x92>
{
    8000130c:	7139                	addi	sp,sp,-64
    8000130e:	fc06                	sd	ra,56(sp)
    80001310:	f822                	sd	s0,48(sp)
    80001312:	f426                	sd	s1,40(sp)
    80001314:	f04a                	sd	s2,32(sp)
    80001316:	ec4e                	sd	s3,24(sp)
    80001318:	e852                	sd	s4,16(sp)
    8000131a:	e456                	sd	s5,8(sp)
    8000131c:	e05a                	sd	s6,0(sp)
    8000131e:	0080                	addi	s0,sp,64
    80001320:	8aaa                	mv	s5,a0
    80001322:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80001324:	6985                	lui	s3,0x1
    80001326:	19fd                	addi	s3,s3,-1
    80001328:	95ce                	add	a1,a1,s3
    8000132a:	79fd                	lui	s3,0xfffff
    8000132c:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001330:	06c9f763          	bgeu	s3,a2,8000139e <uvmalloc+0x96>
    80001334:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001336:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    8000133a:	f90ff0ef          	jal	ra,80000aca <kalloc>
    8000133e:	84aa                	mv	s1,a0
    if(mem == 0){
    80001340:	c11d                	beqz	a0,80001366 <uvmalloc+0x5e>
    memset(mem, 0, PGSIZE);
    80001342:	6605                	lui	a2,0x1
    80001344:	4581                	li	a1,0
    80001346:	929ff0ef          	jal	ra,80000c6e <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000134a:	875a                	mv	a4,s6
    8000134c:	86a6                	mv	a3,s1
    8000134e:	6605                	lui	a2,0x1
    80001350:	85ca                	mv	a1,s2
    80001352:	8556                	mv	a0,s5
    80001354:	c9bff0ef          	jal	ra,80000fee <mappages>
    80001358:	e51d                	bnez	a0,80001386 <uvmalloc+0x7e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000135a:	6785                	lui	a5,0x1
    8000135c:	993e                	add	s2,s2,a5
    8000135e:	fd496ee3          	bltu	s2,s4,8000133a <uvmalloc+0x32>
  return newsz;
    80001362:	8552                	mv	a0,s4
    80001364:	a039                	j	80001372 <uvmalloc+0x6a>
      uvmdealloc(pagetable, a, oldsz);
    80001366:	864e                	mv	a2,s3
    80001368:	85ca                	mv	a1,s2
    8000136a:	8556                	mv	a0,s5
    8000136c:	f59ff0ef          	jal	ra,800012c4 <uvmdealloc>
      return 0;
    80001370:	4501                	li	a0,0
}
    80001372:	70e2                	ld	ra,56(sp)
    80001374:	7442                	ld	s0,48(sp)
    80001376:	74a2                	ld	s1,40(sp)
    80001378:	7902                	ld	s2,32(sp)
    8000137a:	69e2                	ld	s3,24(sp)
    8000137c:	6a42                	ld	s4,16(sp)
    8000137e:	6aa2                	ld	s5,8(sp)
    80001380:	6b02                	ld	s6,0(sp)
    80001382:	6121                	addi	sp,sp,64
    80001384:	8082                	ret
      kfree(mem);
    80001386:	8526                	mv	a0,s1
    80001388:	e62ff0ef          	jal	ra,800009ea <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000138c:	864e                	mv	a2,s3
    8000138e:	85ca                	mv	a1,s2
    80001390:	8556                	mv	a0,s5
    80001392:	f33ff0ef          	jal	ra,800012c4 <uvmdealloc>
      return 0;
    80001396:	4501                	li	a0,0
    80001398:	bfe9                	j	80001372 <uvmalloc+0x6a>
    return oldsz;
    8000139a:	852e                	mv	a0,a1
}
    8000139c:	8082                	ret
  return newsz;
    8000139e:	8532                	mv	a0,a2
    800013a0:	bfc9                	j	80001372 <uvmalloc+0x6a>

00000000800013a2 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800013a2:	7179                	addi	sp,sp,-48
    800013a4:	f406                	sd	ra,40(sp)
    800013a6:	f022                	sd	s0,32(sp)
    800013a8:	ec26                	sd	s1,24(sp)
    800013aa:	e84a                	sd	s2,16(sp)
    800013ac:	e44e                	sd	s3,8(sp)
    800013ae:	e052                	sd	s4,0(sp)
    800013b0:	1800                	addi	s0,sp,48
    800013b2:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800013b4:	84aa                	mv	s1,a0
    800013b6:	6905                	lui	s2,0x1
    800013b8:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800013ba:	4985                	li	s3,1
    800013bc:	a811                	j	800013d0 <freewalk+0x2e>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800013be:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    800013c0:	0532                	slli	a0,a0,0xc
    800013c2:	fe1ff0ef          	jal	ra,800013a2 <freewalk>
      pagetable[i] = 0;
    800013c6:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800013ca:	04a1                	addi	s1,s1,8
    800013cc:	01248f63          	beq	s1,s2,800013ea <freewalk+0x48>
    pte_t pte = pagetable[i];
    800013d0:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800013d2:	00f57793          	andi	a5,a0,15
    800013d6:	ff3784e3          	beq	a5,s3,800013be <freewalk+0x1c>
    } else if(pte & PTE_V){
    800013da:	8905                	andi	a0,a0,1
    800013dc:	d57d                	beqz	a0,800013ca <freewalk+0x28>
      panic("freewalk: leaf");
    800013de:	00006517          	auipc	a0,0x6
    800013e2:	dea50513          	addi	a0,a0,-534 # 800071c8 <digits+0x190>
    800013e6:	b70ff0ef          	jal	ra,80000756 <panic>
    }
  }
  kfree((void*)pagetable);
    800013ea:	8552                	mv	a0,s4
    800013ec:	dfeff0ef          	jal	ra,800009ea <kfree>
}
    800013f0:	70a2                	ld	ra,40(sp)
    800013f2:	7402                	ld	s0,32(sp)
    800013f4:	64e2                	ld	s1,24(sp)
    800013f6:	6942                	ld	s2,16(sp)
    800013f8:	69a2                	ld	s3,8(sp)
    800013fa:	6a02                	ld	s4,0(sp)
    800013fc:	6145                	addi	sp,sp,48
    800013fe:	8082                	ret

0000000080001400 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80001400:	1101                	addi	sp,sp,-32
    80001402:	ec06                	sd	ra,24(sp)
    80001404:	e822                	sd	s0,16(sp)
    80001406:	e426                	sd	s1,8(sp)
    80001408:	1000                	addi	s0,sp,32
    8000140a:	84aa                	mv	s1,a0
  if(sz > 0)
    8000140c:	e989                	bnez	a1,8000141e <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    8000140e:	8526                	mv	a0,s1
    80001410:	f93ff0ef          	jal	ra,800013a2 <freewalk>
}
    80001414:	60e2                	ld	ra,24(sp)
    80001416:	6442                	ld	s0,16(sp)
    80001418:	64a2                	ld	s1,8(sp)
    8000141a:	6105                	addi	sp,sp,32
    8000141c:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    8000141e:	6605                	lui	a2,0x1
    80001420:	167d                	addi	a2,a2,-1
    80001422:	962e                	add	a2,a2,a1
    80001424:	4685                	li	a3,1
    80001426:	8231                	srli	a2,a2,0xc
    80001428:	4581                	li	a1,0
    8000142a:	d6bff0ef          	jal	ra,80001194 <uvmunmap>
    8000142e:	b7c5                	j	8000140e <uvmfree+0xe>

0000000080001430 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80001430:	c65d                	beqz	a2,800014de <uvmcopy+0xae>
{
    80001432:	715d                	addi	sp,sp,-80
    80001434:	e486                	sd	ra,72(sp)
    80001436:	e0a2                	sd	s0,64(sp)
    80001438:	fc26                	sd	s1,56(sp)
    8000143a:	f84a                	sd	s2,48(sp)
    8000143c:	f44e                	sd	s3,40(sp)
    8000143e:	f052                	sd	s4,32(sp)
    80001440:	ec56                	sd	s5,24(sp)
    80001442:	e85a                	sd	s6,16(sp)
    80001444:	e45e                	sd	s7,8(sp)
    80001446:	0880                	addi	s0,sp,80
    80001448:	8b2a                	mv	s6,a0
    8000144a:	8aae                	mv	s5,a1
    8000144c:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    8000144e:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80001450:	4601                	li	a2,0
    80001452:	85ce                	mv	a1,s3
    80001454:	855a                	mv	a0,s6
    80001456:	ac1ff0ef          	jal	ra,80000f16 <walk>
    8000145a:	c121                	beqz	a0,8000149a <uvmcopy+0x6a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    8000145c:	6118                	ld	a4,0(a0)
    8000145e:	00177793          	andi	a5,a4,1
    80001462:	c3b1                	beqz	a5,800014a6 <uvmcopy+0x76>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80001464:	00a75593          	srli	a1,a4,0xa
    80001468:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    8000146c:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80001470:	e5aff0ef          	jal	ra,80000aca <kalloc>
    80001474:	892a                	mv	s2,a0
    80001476:	c129                	beqz	a0,800014b8 <uvmcopy+0x88>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80001478:	6605                	lui	a2,0x1
    8000147a:	85de                	mv	a1,s7
    8000147c:	84fff0ef          	jal	ra,80000cca <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80001480:	8726                	mv	a4,s1
    80001482:	86ca                	mv	a3,s2
    80001484:	6605                	lui	a2,0x1
    80001486:	85ce                	mv	a1,s3
    80001488:	8556                	mv	a0,s5
    8000148a:	b65ff0ef          	jal	ra,80000fee <mappages>
    8000148e:	e115                	bnez	a0,800014b2 <uvmcopy+0x82>
  for(i = 0; i < sz; i += PGSIZE){
    80001490:	6785                	lui	a5,0x1
    80001492:	99be                	add	s3,s3,a5
    80001494:	fb49eee3          	bltu	s3,s4,80001450 <uvmcopy+0x20>
    80001498:	a805                	j	800014c8 <uvmcopy+0x98>
      panic("uvmcopy: pte should exist");
    8000149a:	00006517          	auipc	a0,0x6
    8000149e:	d3e50513          	addi	a0,a0,-706 # 800071d8 <digits+0x1a0>
    800014a2:	ab4ff0ef          	jal	ra,80000756 <panic>
      panic("uvmcopy: page not present");
    800014a6:	00006517          	auipc	a0,0x6
    800014aa:	d5250513          	addi	a0,a0,-686 # 800071f8 <digits+0x1c0>
    800014ae:	aa8ff0ef          	jal	ra,80000756 <panic>
      kfree(mem);
    800014b2:	854a                	mv	a0,s2
    800014b4:	d36ff0ef          	jal	ra,800009ea <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800014b8:	4685                	li	a3,1
    800014ba:	00c9d613          	srli	a2,s3,0xc
    800014be:	4581                	li	a1,0
    800014c0:	8556                	mv	a0,s5
    800014c2:	cd3ff0ef          	jal	ra,80001194 <uvmunmap>
  return -1;
    800014c6:	557d                	li	a0,-1
}
    800014c8:	60a6                	ld	ra,72(sp)
    800014ca:	6406                	ld	s0,64(sp)
    800014cc:	74e2                	ld	s1,56(sp)
    800014ce:	7942                	ld	s2,48(sp)
    800014d0:	79a2                	ld	s3,40(sp)
    800014d2:	7a02                	ld	s4,32(sp)
    800014d4:	6ae2                	ld	s5,24(sp)
    800014d6:	6b42                	ld	s6,16(sp)
    800014d8:	6ba2                	ld	s7,8(sp)
    800014da:	6161                	addi	sp,sp,80
    800014dc:	8082                	ret
  return 0;
    800014de:	4501                	li	a0,0
}
    800014e0:	8082                	ret

00000000800014e2 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    800014e2:	1141                	addi	sp,sp,-16
    800014e4:	e406                	sd	ra,8(sp)
    800014e6:	e022                	sd	s0,0(sp)
    800014e8:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    800014ea:	4601                	li	a2,0
    800014ec:	a2bff0ef          	jal	ra,80000f16 <walk>
  if(pte == 0)
    800014f0:	c901                	beqz	a0,80001500 <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    800014f2:	611c                	ld	a5,0(a0)
    800014f4:	9bbd                	andi	a5,a5,-17
    800014f6:	e11c                	sd	a5,0(a0)
}
    800014f8:	60a2                	ld	ra,8(sp)
    800014fa:	6402                	ld	s0,0(sp)
    800014fc:	0141                	addi	sp,sp,16
    800014fe:	8082                	ret
    panic("uvmclear");
    80001500:	00006517          	auipc	a0,0x6
    80001504:	d1850513          	addi	a0,a0,-744 # 80007218 <digits+0x1e0>
    80001508:	a4eff0ef          	jal	ra,80000756 <panic>

000000008000150c <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    8000150c:	c6c9                	beqz	a3,80001596 <copyout+0x8a>
{
    8000150e:	711d                	addi	sp,sp,-96
    80001510:	ec86                	sd	ra,88(sp)
    80001512:	e8a2                	sd	s0,80(sp)
    80001514:	e4a6                	sd	s1,72(sp)
    80001516:	e0ca                	sd	s2,64(sp)
    80001518:	fc4e                	sd	s3,56(sp)
    8000151a:	f852                	sd	s4,48(sp)
    8000151c:	f456                	sd	s5,40(sp)
    8000151e:	f05a                	sd	s6,32(sp)
    80001520:	ec5e                	sd	s7,24(sp)
    80001522:	e862                	sd	s8,16(sp)
    80001524:	e466                	sd	s9,8(sp)
    80001526:	e06a                	sd	s10,0(sp)
    80001528:	1080                	addi	s0,sp,96
    8000152a:	8baa                	mv	s7,a0
    8000152c:	8aae                	mv	s5,a1
    8000152e:	8b32                	mv	s6,a2
    80001530:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80001532:	74fd                	lui	s1,0xfffff
    80001534:	8ced                	and	s1,s1,a1
    if(va0 >= MAXVA)
    80001536:	57fd                	li	a5,-1
    80001538:	83e9                	srli	a5,a5,0x1a
    8000153a:	0697e063          	bltu	a5,s1,8000159a <copyout+0x8e>
      return -1;
    pte = walk(pagetable, va0, 0);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    8000153e:	4cd5                	li	s9,21
    80001540:	6d05                	lui	s10,0x1
    if(va0 >= MAXVA)
    80001542:	8c3e                	mv	s8,a5
    80001544:	a025                	j	8000156c <copyout+0x60>
       (*pte & PTE_W) == 0)
      return -1;
    pa0 = PTE2PA(*pte);
    80001546:	83a9                	srli	a5,a5,0xa
    80001548:	07b2                	slli	a5,a5,0xc
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    8000154a:	409a8533          	sub	a0,s5,s1
    8000154e:	0009061b          	sext.w	a2,s2
    80001552:	85da                	mv	a1,s6
    80001554:	953e                	add	a0,a0,a5
    80001556:	f74ff0ef          	jal	ra,80000cca <memmove>

    len -= n;
    8000155a:	412989b3          	sub	s3,s3,s2
    src += n;
    8000155e:	9b4a                	add	s6,s6,s2
  while(len > 0){
    80001560:	02098963          	beqz	s3,80001592 <copyout+0x86>
    if(va0 >= MAXVA)
    80001564:	034c6d63          	bltu	s8,s4,8000159e <copyout+0x92>
    va0 = PGROUNDDOWN(dstva);
    80001568:	84d2                	mv	s1,s4
    dstva = va0 + PGSIZE;
    8000156a:	8ad2                	mv	s5,s4
    pte = walk(pagetable, va0, 0);
    8000156c:	4601                	li	a2,0
    8000156e:	85a6                	mv	a1,s1
    80001570:	855e                	mv	a0,s7
    80001572:	9a5ff0ef          	jal	ra,80000f16 <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80001576:	c515                	beqz	a0,800015a2 <copyout+0x96>
    80001578:	611c                	ld	a5,0(a0)
    8000157a:	0157f713          	andi	a4,a5,21
    8000157e:	05971163          	bne	a4,s9,800015c0 <copyout+0xb4>
    n = PGSIZE - (dstva - va0);
    80001582:	01a48a33          	add	s4,s1,s10
    80001586:	415a0933          	sub	s2,s4,s5
    if(n > len)
    8000158a:	fb29fee3          	bgeu	s3,s2,80001546 <copyout+0x3a>
    8000158e:	894e                	mv	s2,s3
    80001590:	bf5d                	j	80001546 <copyout+0x3a>
  }
  return 0;
    80001592:	4501                	li	a0,0
    80001594:	a801                	j	800015a4 <copyout+0x98>
    80001596:	4501                	li	a0,0
}
    80001598:	8082                	ret
      return -1;
    8000159a:	557d                	li	a0,-1
    8000159c:	a021                	j	800015a4 <copyout+0x98>
    8000159e:	557d                	li	a0,-1
    800015a0:	a011                	j	800015a4 <copyout+0x98>
      return -1;
    800015a2:	557d                	li	a0,-1
}
    800015a4:	60e6                	ld	ra,88(sp)
    800015a6:	6446                	ld	s0,80(sp)
    800015a8:	64a6                	ld	s1,72(sp)
    800015aa:	6906                	ld	s2,64(sp)
    800015ac:	79e2                	ld	s3,56(sp)
    800015ae:	7a42                	ld	s4,48(sp)
    800015b0:	7aa2                	ld	s5,40(sp)
    800015b2:	7b02                	ld	s6,32(sp)
    800015b4:	6be2                	ld	s7,24(sp)
    800015b6:	6c42                	ld	s8,16(sp)
    800015b8:	6ca2                	ld	s9,8(sp)
    800015ba:	6d02                	ld	s10,0(sp)
    800015bc:	6125                	addi	sp,sp,96
    800015be:	8082                	ret
      return -1;
    800015c0:	557d                	li	a0,-1
    800015c2:	b7cd                	j	800015a4 <copyout+0x98>

00000000800015c4 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    800015c4:	c6a5                	beqz	a3,8000162c <copyin+0x68>
{
    800015c6:	715d                	addi	sp,sp,-80
    800015c8:	e486                	sd	ra,72(sp)
    800015ca:	e0a2                	sd	s0,64(sp)
    800015cc:	fc26                	sd	s1,56(sp)
    800015ce:	f84a                	sd	s2,48(sp)
    800015d0:	f44e                	sd	s3,40(sp)
    800015d2:	f052                	sd	s4,32(sp)
    800015d4:	ec56                	sd	s5,24(sp)
    800015d6:	e85a                	sd	s6,16(sp)
    800015d8:	e45e                	sd	s7,8(sp)
    800015da:	e062                	sd	s8,0(sp)
    800015dc:	0880                	addi	s0,sp,80
    800015de:	8b2a                	mv	s6,a0
    800015e0:	8a2e                	mv	s4,a1
    800015e2:	8c32                	mv	s8,a2
    800015e4:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    800015e6:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800015e8:	6a85                	lui	s5,0x1
    800015ea:	a00d                	j	8000160c <copyin+0x48>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    800015ec:	018505b3          	add	a1,a0,s8
    800015f0:	0004861b          	sext.w	a2,s1
    800015f4:	412585b3          	sub	a1,a1,s2
    800015f8:	8552                	mv	a0,s4
    800015fa:	ed0ff0ef          	jal	ra,80000cca <memmove>

    len -= n;
    800015fe:	409989b3          	sub	s3,s3,s1
    dst += n;
    80001602:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80001604:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001608:	02098063          	beqz	s3,80001628 <copyin+0x64>
    va0 = PGROUNDDOWN(srcva);
    8000160c:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001610:	85ca                	mv	a1,s2
    80001612:	855a                	mv	a0,s6
    80001614:	99dff0ef          	jal	ra,80000fb0 <walkaddr>
    if(pa0 == 0)
    80001618:	cd01                	beqz	a0,80001630 <copyin+0x6c>
    n = PGSIZE - (srcva - va0);
    8000161a:	418904b3          	sub	s1,s2,s8
    8000161e:	94d6                	add	s1,s1,s5
    if(n > len)
    80001620:	fc99f6e3          	bgeu	s3,s1,800015ec <copyin+0x28>
    80001624:	84ce                	mv	s1,s3
    80001626:	b7d9                	j	800015ec <copyin+0x28>
  }
  return 0;
    80001628:	4501                	li	a0,0
    8000162a:	a021                	j	80001632 <copyin+0x6e>
    8000162c:	4501                	li	a0,0
}
    8000162e:	8082                	ret
      return -1;
    80001630:	557d                	li	a0,-1
}
    80001632:	60a6                	ld	ra,72(sp)
    80001634:	6406                	ld	s0,64(sp)
    80001636:	74e2                	ld	s1,56(sp)
    80001638:	7942                	ld	s2,48(sp)
    8000163a:	79a2                	ld	s3,40(sp)
    8000163c:	7a02                	ld	s4,32(sp)
    8000163e:	6ae2                	ld	s5,24(sp)
    80001640:	6b42                	ld	s6,16(sp)
    80001642:	6ba2                	ld	s7,8(sp)
    80001644:	6c02                	ld	s8,0(sp)
    80001646:	6161                	addi	sp,sp,80
    80001648:	8082                	ret

000000008000164a <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    8000164a:	c2d5                	beqz	a3,800016ee <copyinstr+0xa4>
{
    8000164c:	715d                	addi	sp,sp,-80
    8000164e:	e486                	sd	ra,72(sp)
    80001650:	e0a2                	sd	s0,64(sp)
    80001652:	fc26                	sd	s1,56(sp)
    80001654:	f84a                	sd	s2,48(sp)
    80001656:	f44e                	sd	s3,40(sp)
    80001658:	f052                	sd	s4,32(sp)
    8000165a:	ec56                	sd	s5,24(sp)
    8000165c:	e85a                	sd	s6,16(sp)
    8000165e:	e45e                	sd	s7,8(sp)
    80001660:	0880                	addi	s0,sp,80
    80001662:	8a2a                	mv	s4,a0
    80001664:	8b2e                	mv	s6,a1
    80001666:	8bb2                	mv	s7,a2
    80001668:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    8000166a:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    8000166c:	6985                	lui	s3,0x1
    8000166e:	a035                	j	8000169a <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80001670:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80001674:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80001676:	0017b793          	seqz	a5,a5
    8000167a:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    8000167e:	60a6                	ld	ra,72(sp)
    80001680:	6406                	ld	s0,64(sp)
    80001682:	74e2                	ld	s1,56(sp)
    80001684:	7942                	ld	s2,48(sp)
    80001686:	79a2                	ld	s3,40(sp)
    80001688:	7a02                	ld	s4,32(sp)
    8000168a:	6ae2                	ld	s5,24(sp)
    8000168c:	6b42                	ld	s6,16(sp)
    8000168e:	6ba2                	ld	s7,8(sp)
    80001690:	6161                	addi	sp,sp,80
    80001692:	8082                	ret
    srcva = va0 + PGSIZE;
    80001694:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80001698:	c4b9                	beqz	s1,800016e6 <copyinstr+0x9c>
    va0 = PGROUNDDOWN(srcva);
    8000169a:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    8000169e:	85ca                	mv	a1,s2
    800016a0:	8552                	mv	a0,s4
    800016a2:	90fff0ef          	jal	ra,80000fb0 <walkaddr>
    if(pa0 == 0)
    800016a6:	c131                	beqz	a0,800016ea <copyinstr+0xa0>
    n = PGSIZE - (srcva - va0);
    800016a8:	41790833          	sub	a6,s2,s7
    800016ac:	984e                	add	a6,a6,s3
    if(n > max)
    800016ae:	0104f363          	bgeu	s1,a6,800016b4 <copyinstr+0x6a>
    800016b2:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    800016b4:	955e                	add	a0,a0,s7
    800016b6:	41250533          	sub	a0,a0,s2
    while(n > 0){
    800016ba:	fc080de3          	beqz	a6,80001694 <copyinstr+0x4a>
    800016be:	985a                	add	a6,a6,s6
    800016c0:	87da                	mv	a5,s6
      if(*p == '\0'){
    800016c2:	41650633          	sub	a2,a0,s6
    800016c6:	14fd                	addi	s1,s1,-1
    800016c8:	9b26                	add	s6,s6,s1
    800016ca:	00f60733          	add	a4,a2,a5
    800016ce:	00074703          	lbu	a4,0(a4)
    800016d2:	df59                	beqz	a4,80001670 <copyinstr+0x26>
        *dst = *p;
    800016d4:	00e78023          	sb	a4,0(a5)
      --max;
    800016d8:	40fb04b3          	sub	s1,s6,a5
      dst++;
    800016dc:	0785                	addi	a5,a5,1
    while(n > 0){
    800016de:	ff0796e3          	bne	a5,a6,800016ca <copyinstr+0x80>
      dst++;
    800016e2:	8b42                	mv	s6,a6
    800016e4:	bf45                	j	80001694 <copyinstr+0x4a>
    800016e6:	4781                	li	a5,0
    800016e8:	b779                	j	80001676 <copyinstr+0x2c>
      return -1;
    800016ea:	557d                	li	a0,-1
    800016ec:	bf49                	j	8000167e <copyinstr+0x34>
  int got_null = 0;
    800016ee:	4781                	li	a5,0
  if(got_null){
    800016f0:	0017b793          	seqz	a5,a5
    800016f4:	40f00533          	neg	a0,a5
}
    800016f8:	8082                	ret

00000000800016fa <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    800016fa:	7139                	addi	sp,sp,-64
    800016fc:	fc06                	sd	ra,56(sp)
    800016fe:	f822                	sd	s0,48(sp)
    80001700:	f426                	sd	s1,40(sp)
    80001702:	f04a                	sd	s2,32(sp)
    80001704:	ec4e                	sd	s3,24(sp)
    80001706:	e852                	sd	s4,16(sp)
    80001708:	e456                	sd	s5,8(sp)
    8000170a:	e05a                	sd	s6,0(sp)
    8000170c:	0080                	addi	s0,sp,64
    8000170e:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80001710:	0000f497          	auipc	s1,0xf
    80001714:	b0048493          	addi	s1,s1,-1280 # 80010210 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80001718:	8b26                	mv	s6,s1
    8000171a:	00006a97          	auipc	s5,0x6
    8000171e:	8e6a8a93          	addi	s5,s5,-1818 # 80007000 <etext>
    80001722:	04000937          	lui	s2,0x4000
    80001726:	197d                	addi	s2,s2,-1
    80001728:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    8000172a:	0002ba17          	auipc	s4,0x2b
    8000172e:	4e6a0a13          	addi	s4,s4,1254 # 8002cc10 <tickslock>
    char *pa = kalloc();
    80001732:	b98ff0ef          	jal	ra,80000aca <kalloc>
    80001736:	862a                	mv	a2,a0
    if(pa == 0)
    80001738:	c121                	beqz	a0,80001778 <proc_mapstacks+0x7e>
    uint64 va = KSTACK((int) (p - proc));
    8000173a:	416485b3          	sub	a1,s1,s6
    8000173e:	858d                	srai	a1,a1,0x3
    80001740:	000ab783          	ld	a5,0(s5)
    80001744:	02f585b3          	mul	a1,a1,a5
    80001748:	2585                	addiw	a1,a1,1
    8000174a:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    8000174e:	4719                	li	a4,6
    80001750:	6685                	lui	a3,0x1
    80001752:	40b905b3          	sub	a1,s2,a1
    80001756:	854e                	mv	a0,s3
    80001758:	947ff0ef          	jal	ra,8000109e <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000175c:	72848493          	addi	s1,s1,1832
    80001760:	fd4499e3          	bne	s1,s4,80001732 <proc_mapstacks+0x38>
  }
}
    80001764:	70e2                	ld	ra,56(sp)
    80001766:	7442                	ld	s0,48(sp)
    80001768:	74a2                	ld	s1,40(sp)
    8000176a:	7902                	ld	s2,32(sp)
    8000176c:	69e2                	ld	s3,24(sp)
    8000176e:	6a42                	ld	s4,16(sp)
    80001770:	6aa2                	ld	s5,8(sp)
    80001772:	6b02                	ld	s6,0(sp)
    80001774:	6121                	addi	sp,sp,64
    80001776:	8082                	ret
      panic("kalloc");
    80001778:	00006517          	auipc	a0,0x6
    8000177c:	ab050513          	addi	a0,a0,-1360 # 80007228 <digits+0x1f0>
    80001780:	fd7fe0ef          	jal	ra,80000756 <panic>

0000000080001784 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80001784:	7139                	addi	sp,sp,-64
    80001786:	fc06                	sd	ra,56(sp)
    80001788:	f822                	sd	s0,48(sp)
    8000178a:	f426                	sd	s1,40(sp)
    8000178c:	f04a                	sd	s2,32(sp)
    8000178e:	ec4e                	sd	s3,24(sp)
    80001790:	e852                	sd	s4,16(sp)
    80001792:	e456                	sd	s5,8(sp)
    80001794:	e05a                	sd	s6,0(sp)
    80001796:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80001798:	00006597          	auipc	a1,0x6
    8000179c:	a9858593          	addi	a1,a1,-1384 # 80007230 <digits+0x1f8>
    800017a0:	0000e517          	auipc	a0,0xe
    800017a4:	64050513          	addi	a0,a0,1600 # 8000fde0 <pid_lock>
    800017a8:	b72ff0ef          	jal	ra,80000b1a <initlock>
  initlock(&wait_lock, "wait_lock");
    800017ac:	00006597          	auipc	a1,0x6
    800017b0:	a8c58593          	addi	a1,a1,-1396 # 80007238 <digits+0x200>
    800017b4:	0000e517          	auipc	a0,0xe
    800017b8:	64450513          	addi	a0,a0,1604 # 8000fdf8 <wait_lock>
    800017bc:	b5eff0ef          	jal	ra,80000b1a <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    800017c0:	0000f497          	auipc	s1,0xf
    800017c4:	a5048493          	addi	s1,s1,-1456 # 80010210 <proc>
      initlock(&p->lock, "proc");
    800017c8:	00006b17          	auipc	s6,0x6
    800017cc:	a80b0b13          	addi	s6,s6,-1408 # 80007248 <digits+0x210>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    800017d0:	8aa6                	mv	s5,s1
    800017d2:	00006a17          	auipc	s4,0x6
    800017d6:	82ea0a13          	addi	s4,s4,-2002 # 80007000 <etext>
    800017da:	04000937          	lui	s2,0x4000
    800017de:	197d                	addi	s2,s2,-1
    800017e0:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    800017e2:	0002b997          	auipc	s3,0x2b
    800017e6:	42e98993          	addi	s3,s3,1070 # 8002cc10 <tickslock>
      initlock(&p->lock, "proc");
    800017ea:	85da                	mv	a1,s6
    800017ec:	8526                	mv	a0,s1
    800017ee:	b2cff0ef          	jal	ra,80000b1a <initlock>
      p->state = UNUSED;
    800017f2:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    800017f6:	415487b3          	sub	a5,s1,s5
    800017fa:	878d                	srai	a5,a5,0x3
    800017fc:	000a3703          	ld	a4,0(s4)
    80001800:	02e787b3          	mul	a5,a5,a4
    80001804:	2785                	addiw	a5,a5,1
    80001806:	00d7979b          	slliw	a5,a5,0xd
    8000180a:	40f907b3          	sub	a5,s2,a5
    8000180e:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80001810:	72848493          	addi	s1,s1,1832
    80001814:	fd349be3          	bne	s1,s3,800017ea <procinit+0x66>
  }
}
    80001818:	70e2                	ld	ra,56(sp)
    8000181a:	7442                	ld	s0,48(sp)
    8000181c:	74a2                	ld	s1,40(sp)
    8000181e:	7902                	ld	s2,32(sp)
    80001820:	69e2                	ld	s3,24(sp)
    80001822:	6a42                	ld	s4,16(sp)
    80001824:	6aa2                	ld	s5,8(sp)
    80001826:	6b02                	ld	s6,0(sp)
    80001828:	6121                	addi	sp,sp,64
    8000182a:	8082                	ret

000000008000182c <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    8000182c:	1141                	addi	sp,sp,-16
    8000182e:	e422                	sd	s0,8(sp)
    80001830:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001832:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80001834:	2501                	sext.w	a0,a0
    80001836:	6422                	ld	s0,8(sp)
    80001838:	0141                	addi	sp,sp,16
    8000183a:	8082                	ret

000000008000183c <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    8000183c:	1141                	addi	sp,sp,-16
    8000183e:	e422                	sd	s0,8(sp)
    80001840:	0800                	addi	s0,sp,16
    80001842:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001844:	2781                	sext.w	a5,a5
    80001846:	079e                	slli	a5,a5,0x7
  return c;
}
    80001848:	0000e517          	auipc	a0,0xe
    8000184c:	5c850513          	addi	a0,a0,1480 # 8000fe10 <cpus>
    80001850:	953e                	add	a0,a0,a5
    80001852:	6422                	ld	s0,8(sp)
    80001854:	0141                	addi	sp,sp,16
    80001856:	8082                	ret

0000000080001858 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80001858:	1101                	addi	sp,sp,-32
    8000185a:	ec06                	sd	ra,24(sp)
    8000185c:	e822                	sd	s0,16(sp)
    8000185e:	e426                	sd	s1,8(sp)
    80001860:	1000                	addi	s0,sp,32
  push_off();
    80001862:	af8ff0ef          	jal	ra,80000b5a <push_off>
    80001866:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001868:	2781                	sext.w	a5,a5
    8000186a:	079e                	slli	a5,a5,0x7
    8000186c:	0000e717          	auipc	a4,0xe
    80001870:	57470713          	addi	a4,a4,1396 # 8000fde0 <pid_lock>
    80001874:	97ba                	add	a5,a5,a4
    80001876:	7b84                	ld	s1,48(a5)
  pop_off();
    80001878:	b66ff0ef          	jal	ra,80000bde <pop_off>
  return p;
}
    8000187c:	8526                	mv	a0,s1
    8000187e:	60e2                	ld	ra,24(sp)
    80001880:	6442                	ld	s0,16(sp)
    80001882:	64a2                	ld	s1,8(sp)
    80001884:	6105                	addi	sp,sp,32
    80001886:	8082                	ret

0000000080001888 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80001888:	1141                	addi	sp,sp,-16
    8000188a:	e406                	sd	ra,8(sp)
    8000188c:	e022                	sd	s0,0(sp)
    8000188e:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001890:	fc9ff0ef          	jal	ra,80001858 <myproc>
    80001894:	b9eff0ef          	jal	ra,80000c32 <release>

  if (first) {
    80001898:	00006797          	auipc	a5,0x6
    8000189c:	3787a783          	lw	a5,888(a5) # 80007c10 <first.1>
    800018a0:	e799                	bnez	a5,800018ae <forkret+0x26>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    800018a2:	2bb000ef          	jal	ra,8000235c <usertrapret>
}
    800018a6:	60a2                	ld	ra,8(sp)
    800018a8:	6402                	ld	s0,0(sp)
    800018aa:	0141                	addi	sp,sp,16
    800018ac:	8082                	ret
    fsinit(ROOTDEV);
    800018ae:	4505                	li	a0,1
    800018b0:	636010ef          	jal	ra,80002ee6 <fsinit>
    first = 0;
    800018b4:	00006797          	auipc	a5,0x6
    800018b8:	3407ae23          	sw	zero,860(a5) # 80007c10 <first.1>
    __sync_synchronize();
    800018bc:	0ff0000f          	fence
    800018c0:	b7cd                	j	800018a2 <forkret+0x1a>

00000000800018c2 <allocpid>:
{
    800018c2:	1101                	addi	sp,sp,-32
    800018c4:	ec06                	sd	ra,24(sp)
    800018c6:	e822                	sd	s0,16(sp)
    800018c8:	e426                	sd	s1,8(sp)
    800018ca:	e04a                	sd	s2,0(sp)
    800018cc:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    800018ce:	0000e917          	auipc	s2,0xe
    800018d2:	51290913          	addi	s2,s2,1298 # 8000fde0 <pid_lock>
    800018d6:	854a                	mv	a0,s2
    800018d8:	ac2ff0ef          	jal	ra,80000b9a <acquire>
  pid = nextpid;
    800018dc:	00006797          	auipc	a5,0x6
    800018e0:	33878793          	addi	a5,a5,824 # 80007c14 <nextpid>
    800018e4:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    800018e6:	0014871b          	addiw	a4,s1,1
    800018ea:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    800018ec:	854a                	mv	a0,s2
    800018ee:	b44ff0ef          	jal	ra,80000c32 <release>
}
    800018f2:	8526                	mv	a0,s1
    800018f4:	60e2                	ld	ra,24(sp)
    800018f6:	6442                	ld	s0,16(sp)
    800018f8:	64a2                	ld	s1,8(sp)
    800018fa:	6902                	ld	s2,0(sp)
    800018fc:	6105                	addi	sp,sp,32
    800018fe:	8082                	ret

0000000080001900 <proc_pagetable>:
{
    80001900:	1101                	addi	sp,sp,-32
    80001902:	ec06                	sd	ra,24(sp)
    80001904:	e822                	sd	s0,16(sp)
    80001906:	e426                	sd	s1,8(sp)
    80001908:	e04a                	sd	s2,0(sp)
    8000190a:	1000                	addi	s0,sp,32
    8000190c:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    8000190e:	933ff0ef          	jal	ra,80001240 <uvmcreate>
    80001912:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001914:	cd05                	beqz	a0,8000194c <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001916:	4729                	li	a4,10
    80001918:	00004697          	auipc	a3,0x4
    8000191c:	6e868693          	addi	a3,a3,1768 # 80006000 <_trampoline>
    80001920:	6605                	lui	a2,0x1
    80001922:	040005b7          	lui	a1,0x4000
    80001926:	15fd                	addi	a1,a1,-1
    80001928:	05b2                	slli	a1,a1,0xc
    8000192a:	ec4ff0ef          	jal	ra,80000fee <mappages>
    8000192e:	02054663          	bltz	a0,8000195a <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001932:	4719                	li	a4,6
    80001934:	05893683          	ld	a3,88(s2)
    80001938:	6605                	lui	a2,0x1
    8000193a:	020005b7          	lui	a1,0x2000
    8000193e:	15fd                	addi	a1,a1,-1
    80001940:	05b6                	slli	a1,a1,0xd
    80001942:	8526                	mv	a0,s1
    80001944:	eaaff0ef          	jal	ra,80000fee <mappages>
    80001948:	00054f63          	bltz	a0,80001966 <proc_pagetable+0x66>
}
    8000194c:	8526                	mv	a0,s1
    8000194e:	60e2                	ld	ra,24(sp)
    80001950:	6442                	ld	s0,16(sp)
    80001952:	64a2                	ld	s1,8(sp)
    80001954:	6902                	ld	s2,0(sp)
    80001956:	6105                	addi	sp,sp,32
    80001958:	8082                	ret
    uvmfree(pagetable, 0);
    8000195a:	4581                	li	a1,0
    8000195c:	8526                	mv	a0,s1
    8000195e:	aa3ff0ef          	jal	ra,80001400 <uvmfree>
    return 0;
    80001962:	4481                	li	s1,0
    80001964:	b7e5                	j	8000194c <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001966:	4681                	li	a3,0
    80001968:	4605                	li	a2,1
    8000196a:	040005b7          	lui	a1,0x4000
    8000196e:	15fd                	addi	a1,a1,-1
    80001970:	05b2                	slli	a1,a1,0xc
    80001972:	8526                	mv	a0,s1
    80001974:	821ff0ef          	jal	ra,80001194 <uvmunmap>
    uvmfree(pagetable, 0);
    80001978:	4581                	li	a1,0
    8000197a:	8526                	mv	a0,s1
    8000197c:	a85ff0ef          	jal	ra,80001400 <uvmfree>
    return 0;
    80001980:	4481                	li	s1,0
    80001982:	b7e9                	j	8000194c <proc_pagetable+0x4c>

0000000080001984 <proc_freepagetable>:
{
    80001984:	1101                	addi	sp,sp,-32
    80001986:	ec06                	sd	ra,24(sp)
    80001988:	e822                	sd	s0,16(sp)
    8000198a:	e426                	sd	s1,8(sp)
    8000198c:	e04a                	sd	s2,0(sp)
    8000198e:	1000                	addi	s0,sp,32
    80001990:	84aa                	mv	s1,a0
    80001992:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001994:	4681                	li	a3,0
    80001996:	4605                	li	a2,1
    80001998:	040005b7          	lui	a1,0x4000
    8000199c:	15fd                	addi	a1,a1,-1
    8000199e:	05b2                	slli	a1,a1,0xc
    800019a0:	ff4ff0ef          	jal	ra,80001194 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    800019a4:	4681                	li	a3,0
    800019a6:	4605                	li	a2,1
    800019a8:	020005b7          	lui	a1,0x2000
    800019ac:	15fd                	addi	a1,a1,-1
    800019ae:	05b6                	slli	a1,a1,0xd
    800019b0:	8526                	mv	a0,s1
    800019b2:	fe2ff0ef          	jal	ra,80001194 <uvmunmap>
  uvmfree(pagetable, sz);
    800019b6:	85ca                	mv	a1,s2
    800019b8:	8526                	mv	a0,s1
    800019ba:	a47ff0ef          	jal	ra,80001400 <uvmfree>
}
    800019be:	60e2                	ld	ra,24(sp)
    800019c0:	6442                	ld	s0,16(sp)
    800019c2:	64a2                	ld	s1,8(sp)
    800019c4:	6902                	ld	s2,0(sp)
    800019c6:	6105                	addi	sp,sp,32
    800019c8:	8082                	ret

00000000800019ca <freeproc>:
{
    800019ca:	1101                	addi	sp,sp,-32
    800019cc:	ec06                	sd	ra,24(sp)
    800019ce:	e822                	sd	s0,16(sp)
    800019d0:	e426                	sd	s1,8(sp)
    800019d2:	1000                	addi	s0,sp,32
    800019d4:	84aa                	mv	s1,a0
  if(p->trapframe)
    800019d6:	6d28                	ld	a0,88(a0)
    800019d8:	c119                	beqz	a0,800019de <freeproc+0x14>
    kfree((void*)p->trapframe);
    800019da:	810ff0ef          	jal	ra,800009ea <kfree>
  p->trapframe = 0;
    800019de:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    800019e2:	68a8                	ld	a0,80(s1)
    800019e4:	c501                	beqz	a0,800019ec <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    800019e6:	64ac                	ld	a1,72(s1)
    800019e8:	f9dff0ef          	jal	ra,80001984 <proc_freepagetable>
  p->pagetable = 0;
    800019ec:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    800019f0:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    800019f4:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    800019f8:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    800019fc:	70048c23          	sb	zero,1816(s1)
  p->chan = 0;
    80001a00:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001a04:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001a08:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001a0c:	0004ac23          	sw	zero,24(s1)
}
    80001a10:	60e2                	ld	ra,24(sp)
    80001a12:	6442                	ld	s0,16(sp)
    80001a14:	64a2                	ld	s1,8(sp)
    80001a16:	6105                	addi	sp,sp,32
    80001a18:	8082                	ret

0000000080001a1a <allocproc>:
{
    80001a1a:	1101                	addi	sp,sp,-32
    80001a1c:	ec06                	sd	ra,24(sp)
    80001a1e:	e822                	sd	s0,16(sp)
    80001a20:	e426                	sd	s1,8(sp)
    80001a22:	e04a                	sd	s2,0(sp)
    80001a24:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001a26:	0000e497          	auipc	s1,0xe
    80001a2a:	7ea48493          	addi	s1,s1,2026 # 80010210 <proc>
    80001a2e:	0002b917          	auipc	s2,0x2b
    80001a32:	1e290913          	addi	s2,s2,482 # 8002cc10 <tickslock>
    acquire(&p->lock);
    80001a36:	8526                	mv	a0,s1
    80001a38:	962ff0ef          	jal	ra,80000b9a <acquire>
    if(p->state == UNUSED) {
    80001a3c:	4c9c                	lw	a5,24(s1)
    80001a3e:	cb91                	beqz	a5,80001a52 <allocproc+0x38>
      release(&p->lock);
    80001a40:	8526                	mv	a0,s1
    80001a42:	9f0ff0ef          	jal	ra,80000c32 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001a46:	72848493          	addi	s1,s1,1832
    80001a4a:	ff2496e3          	bne	s1,s2,80001a36 <allocproc+0x1c>
  return 0;
    80001a4e:	4481                	li	s1,0
    80001a50:	a089                	j	80001a92 <allocproc+0x78>
  p->pid = allocpid();
    80001a52:	e71ff0ef          	jal	ra,800018c2 <allocpid>
    80001a56:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001a58:	4785                	li	a5,1
    80001a5a:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001a5c:	86eff0ef          	jal	ra,80000aca <kalloc>
    80001a60:	892a                	mv	s2,a0
    80001a62:	eca8                	sd	a0,88(s1)
    80001a64:	cd15                	beqz	a0,80001aa0 <allocproc+0x86>
  p->pagetable = proc_pagetable(p);
    80001a66:	8526                	mv	a0,s1
    80001a68:	e99ff0ef          	jal	ra,80001900 <proc_pagetable>
    80001a6c:	892a                	mv	s2,a0
    80001a6e:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001a70:	c121                	beqz	a0,80001ab0 <allocproc+0x96>
  memset(&p->context, 0, sizeof(p->context));
    80001a72:	07000613          	li	a2,112
    80001a76:	4581                	li	a1,0
    80001a78:	06048513          	addi	a0,s1,96
    80001a7c:	9f2ff0ef          	jal	ra,80000c6e <memset>
  p->context.ra = (uint64)forkret;
    80001a80:	00000797          	auipc	a5,0x0
    80001a84:	e0878793          	addi	a5,a5,-504 # 80001888 <forkret>
    80001a88:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001a8a:	60bc                	ld	a5,64(s1)
    80001a8c:	6705                	lui	a4,0x1
    80001a8e:	97ba                	add	a5,a5,a4
    80001a90:	f4bc                	sd	a5,104(s1)
}
    80001a92:	8526                	mv	a0,s1
    80001a94:	60e2                	ld	ra,24(sp)
    80001a96:	6442                	ld	s0,16(sp)
    80001a98:	64a2                	ld	s1,8(sp)
    80001a9a:	6902                	ld	s2,0(sp)
    80001a9c:	6105                	addi	sp,sp,32
    80001a9e:	8082                	ret
    freeproc(p);
    80001aa0:	8526                	mv	a0,s1
    80001aa2:	f29ff0ef          	jal	ra,800019ca <freeproc>
    release(&p->lock);
    80001aa6:	8526                	mv	a0,s1
    80001aa8:	98aff0ef          	jal	ra,80000c32 <release>
    return 0;
    80001aac:	84ca                	mv	s1,s2
    80001aae:	b7d5                	j	80001a92 <allocproc+0x78>
    freeproc(p);
    80001ab0:	8526                	mv	a0,s1
    80001ab2:	f19ff0ef          	jal	ra,800019ca <freeproc>
    release(&p->lock);
    80001ab6:	8526                	mv	a0,s1
    80001ab8:	97aff0ef          	jal	ra,80000c32 <release>
    return 0;
    80001abc:	84ca                	mv	s1,s2
    80001abe:	bfd1                	j	80001a92 <allocproc+0x78>

0000000080001ac0 <userinit>:
{
    80001ac0:	1101                	addi	sp,sp,-32
    80001ac2:	ec06                	sd	ra,24(sp)
    80001ac4:	e822                	sd	s0,16(sp)
    80001ac6:	e426                	sd	s1,8(sp)
    80001ac8:	1000                	addi	s0,sp,32
  p = allocproc();
    80001aca:	f51ff0ef          	jal	ra,80001a1a <allocproc>
    80001ace:	84aa                	mv	s1,a0
  initproc = p;
    80001ad0:	00006797          	auipc	a5,0x6
    80001ad4:	1ca7bc23          	sd	a0,472(a5) # 80007ca8 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001ad8:	03400613          	li	a2,52
    80001adc:	00006597          	auipc	a1,0x6
    80001ae0:	14458593          	addi	a1,a1,324 # 80007c20 <initcode>
    80001ae4:	6928                	ld	a0,80(a0)
    80001ae6:	f80ff0ef          	jal	ra,80001266 <uvmfirst>
  p->sz = PGSIZE;
    80001aea:	6785                	lui	a5,0x1
    80001aec:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001aee:	6cb8                	ld	a4,88(s1)
    80001af0:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001af4:	6cb8                	ld	a4,88(s1)
    80001af6:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001af8:	4641                	li	a2,16
    80001afa:	00005597          	auipc	a1,0x5
    80001afe:	75658593          	addi	a1,a1,1878 # 80007250 <digits+0x218>
    80001b02:	71848513          	addi	a0,s1,1816
    80001b06:	aaeff0ef          	jal	ra,80000db4 <safestrcpy>
  p->cwd = namei("/");
    80001b0a:	00005517          	auipc	a0,0x5
    80001b0e:	75650513          	addi	a0,a0,1878 # 80007260 <digits+0x228>
    80001b12:	4b3010ef          	jal	ra,800037c4 <namei>
    80001b16:	70a4b823          	sd	a0,1808(s1)
  p->state = RUNNABLE;
    80001b1a:	478d                	li	a5,3
    80001b1c:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001b1e:	8526                	mv	a0,s1
    80001b20:	912ff0ef          	jal	ra,80000c32 <release>
}
    80001b24:	60e2                	ld	ra,24(sp)
    80001b26:	6442                	ld	s0,16(sp)
    80001b28:	64a2                	ld	s1,8(sp)
    80001b2a:	6105                	addi	sp,sp,32
    80001b2c:	8082                	ret

0000000080001b2e <growproc>:
{
    80001b2e:	1101                	addi	sp,sp,-32
    80001b30:	ec06                	sd	ra,24(sp)
    80001b32:	e822                	sd	s0,16(sp)
    80001b34:	e426                	sd	s1,8(sp)
    80001b36:	e04a                	sd	s2,0(sp)
    80001b38:	1000                	addi	s0,sp,32
    80001b3a:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001b3c:	d1dff0ef          	jal	ra,80001858 <myproc>
    80001b40:	84aa                	mv	s1,a0
  sz = p->sz;
    80001b42:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001b44:	01204c63          	bgtz	s2,80001b5c <growproc+0x2e>
  } else if(n < 0){
    80001b48:	02094463          	bltz	s2,80001b70 <growproc+0x42>
  p->sz = sz;
    80001b4c:	e4ac                	sd	a1,72(s1)
  return 0;
    80001b4e:	4501                	li	a0,0
}
    80001b50:	60e2                	ld	ra,24(sp)
    80001b52:	6442                	ld	s0,16(sp)
    80001b54:	64a2                	ld	s1,8(sp)
    80001b56:	6902                	ld	s2,0(sp)
    80001b58:	6105                	addi	sp,sp,32
    80001b5a:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001b5c:	4691                	li	a3,4
    80001b5e:	00b90633          	add	a2,s2,a1
    80001b62:	6928                	ld	a0,80(a0)
    80001b64:	fa4ff0ef          	jal	ra,80001308 <uvmalloc>
    80001b68:	85aa                	mv	a1,a0
    80001b6a:	f16d                	bnez	a0,80001b4c <growproc+0x1e>
      return -1;
    80001b6c:	557d                	li	a0,-1
    80001b6e:	b7cd                	j	80001b50 <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001b70:	00b90633          	add	a2,s2,a1
    80001b74:	6928                	ld	a0,80(a0)
    80001b76:	f4eff0ef          	jal	ra,800012c4 <uvmdealloc>
    80001b7a:	85aa                	mv	a1,a0
    80001b7c:	bfc1                	j	80001b4c <growproc+0x1e>

0000000080001b7e <fork>:
{
    80001b7e:	7139                	addi	sp,sp,-64
    80001b80:	fc06                	sd	ra,56(sp)
    80001b82:	f822                	sd	s0,48(sp)
    80001b84:	f426                	sd	s1,40(sp)
    80001b86:	f04a                	sd	s2,32(sp)
    80001b88:	ec4e                	sd	s3,24(sp)
    80001b8a:	e852                	sd	s4,16(sp)
    80001b8c:	e456                	sd	s5,8(sp)
    80001b8e:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001b90:	cc9ff0ef          	jal	ra,80001858 <myproc>
    80001b94:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001b96:	e85ff0ef          	jal	ra,80001a1a <allocproc>
    80001b9a:	0e050663          	beqz	a0,80001c86 <fork+0x108>
    80001b9e:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001ba0:	048ab603          	ld	a2,72(s5)
    80001ba4:	692c                	ld	a1,80(a0)
    80001ba6:	050ab503          	ld	a0,80(s5)
    80001baa:	887ff0ef          	jal	ra,80001430 <uvmcopy>
    80001bae:	04054863          	bltz	a0,80001bfe <fork+0x80>
  np->sz = p->sz;
    80001bb2:	048ab783          	ld	a5,72(s5)
    80001bb6:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001bba:	058ab683          	ld	a3,88(s5)
    80001bbe:	87b6                	mv	a5,a3
    80001bc0:	058a3703          	ld	a4,88(s4)
    80001bc4:	12068693          	addi	a3,a3,288
    80001bc8:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001bcc:	6788                	ld	a0,8(a5)
    80001bce:	6b8c                	ld	a1,16(a5)
    80001bd0:	6f90                	ld	a2,24(a5)
    80001bd2:	01073023          	sd	a6,0(a4)
    80001bd6:	e708                	sd	a0,8(a4)
    80001bd8:	eb0c                	sd	a1,16(a4)
    80001bda:	ef10                	sd	a2,24(a4)
    80001bdc:	02078793          	addi	a5,a5,32
    80001be0:	02070713          	addi	a4,a4,32
    80001be4:	fed792e3          	bne	a5,a3,80001bc8 <fork+0x4a>
  np->trapframe->a0 = 0;
    80001be8:	058a3783          	ld	a5,88(s4)
    80001bec:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001bf0:	0d0a8493          	addi	s1,s5,208
    80001bf4:	0d0a0913          	addi	s2,s4,208
    80001bf8:	710a8993          	addi	s3,s5,1808
    80001bfc:	a00d                	j	80001c1e <fork+0xa0>
    freeproc(np);
    80001bfe:	8552                	mv	a0,s4
    80001c00:	dcbff0ef          	jal	ra,800019ca <freeproc>
    release(&np->lock);
    80001c04:	8552                	mv	a0,s4
    80001c06:	82cff0ef          	jal	ra,80000c32 <release>
    return -1;
    80001c0a:	597d                	li	s2,-1
    80001c0c:	a09d                	j	80001c72 <fork+0xf4>
      np->ofile[i] = filedup(p->ofile[i]);
    80001c0e:	212020ef          	jal	ra,80003e20 <filedup>
    80001c12:	00a93023          	sd	a0,0(s2)
  for(i = 0; i < NOFILE; i++)
    80001c16:	04a1                	addi	s1,s1,8
    80001c18:	0921                	addi	s2,s2,8
    80001c1a:	01348563          	beq	s1,s3,80001c24 <fork+0xa6>
    if(p->ofile[i])
    80001c1e:	6088                	ld	a0,0(s1)
    80001c20:	f57d                	bnez	a0,80001c0e <fork+0x90>
    80001c22:	bfd5                	j	80001c16 <fork+0x98>
  np->cwd = idup(p->cwd);
    80001c24:	710ab503          	ld	a0,1808(s5)
    80001c28:	4b4010ef          	jal	ra,800030dc <idup>
    80001c2c:	70aa3823          	sd	a0,1808(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001c30:	4641                	li	a2,16
    80001c32:	718a8593          	addi	a1,s5,1816
    80001c36:	718a0513          	addi	a0,s4,1816
    80001c3a:	97aff0ef          	jal	ra,80000db4 <safestrcpy>
  pid = np->pid;
    80001c3e:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001c42:	8552                	mv	a0,s4
    80001c44:	feffe0ef          	jal	ra,80000c32 <release>
  acquire(&wait_lock);
    80001c48:	0000e497          	auipc	s1,0xe
    80001c4c:	1b048493          	addi	s1,s1,432 # 8000fdf8 <wait_lock>
    80001c50:	8526                	mv	a0,s1
    80001c52:	f49fe0ef          	jal	ra,80000b9a <acquire>
  np->parent = p;
    80001c56:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001c5a:	8526                	mv	a0,s1
    80001c5c:	fd7fe0ef          	jal	ra,80000c32 <release>
  acquire(&np->lock);
    80001c60:	8552                	mv	a0,s4
    80001c62:	f39fe0ef          	jal	ra,80000b9a <acquire>
  np->state = RUNNABLE;
    80001c66:	478d                	li	a5,3
    80001c68:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001c6c:	8552                	mv	a0,s4
    80001c6e:	fc5fe0ef          	jal	ra,80000c32 <release>
}
    80001c72:	854a                	mv	a0,s2
    80001c74:	70e2                	ld	ra,56(sp)
    80001c76:	7442                	ld	s0,48(sp)
    80001c78:	74a2                	ld	s1,40(sp)
    80001c7a:	7902                	ld	s2,32(sp)
    80001c7c:	69e2                	ld	s3,24(sp)
    80001c7e:	6a42                	ld	s4,16(sp)
    80001c80:	6aa2                	ld	s5,8(sp)
    80001c82:	6121                	addi	sp,sp,64
    80001c84:	8082                	ret
    return -1;
    80001c86:	597d                	li	s2,-1
    80001c88:	b7ed                	j	80001c72 <fork+0xf4>

0000000080001c8a <scheduler>:
{
    80001c8a:	715d                	addi	sp,sp,-80
    80001c8c:	e486                	sd	ra,72(sp)
    80001c8e:	e0a2                	sd	s0,64(sp)
    80001c90:	fc26                	sd	s1,56(sp)
    80001c92:	f84a                	sd	s2,48(sp)
    80001c94:	f44e                	sd	s3,40(sp)
    80001c96:	f052                	sd	s4,32(sp)
    80001c98:	ec56                	sd	s5,24(sp)
    80001c9a:	e85a                	sd	s6,16(sp)
    80001c9c:	e45e                	sd	s7,8(sp)
    80001c9e:	e062                	sd	s8,0(sp)
    80001ca0:	0880                	addi	s0,sp,80
    80001ca2:	8792                	mv	a5,tp
  int id = r_tp();
    80001ca4:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001ca6:	00779b13          	slli	s6,a5,0x7
    80001caa:	0000e717          	auipc	a4,0xe
    80001cae:	13670713          	addi	a4,a4,310 # 8000fde0 <pid_lock>
    80001cb2:	975a                	add	a4,a4,s6
    80001cb4:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001cb8:	0000e717          	auipc	a4,0xe
    80001cbc:	16070713          	addi	a4,a4,352 # 8000fe18 <cpus+0x8>
    80001cc0:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    80001cc2:	4c11                	li	s8,4
        c->proc = p;
    80001cc4:	079e                	slli	a5,a5,0x7
    80001cc6:	0000ea17          	auipc	s4,0xe
    80001cca:	11aa0a13          	addi	s4,s4,282 # 8000fde0 <pid_lock>
    80001cce:	9a3e                	add	s4,s4,a5
        found = 1;
    80001cd0:	4b85                	li	s7,1
    for(p = proc; p < &proc[NPROC]; p++) {
    80001cd2:	0002b997          	auipc	s3,0x2b
    80001cd6:	f3e98993          	addi	s3,s3,-194 # 8002cc10 <tickslock>
    80001cda:	a0a9                	j	80001d24 <scheduler+0x9a>
      release(&p->lock);
    80001cdc:	8526                	mv	a0,s1
    80001cde:	f55fe0ef          	jal	ra,80000c32 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001ce2:	72848493          	addi	s1,s1,1832
    80001ce6:	03348563          	beq	s1,s3,80001d10 <scheduler+0x86>
      acquire(&p->lock);
    80001cea:	8526                	mv	a0,s1
    80001cec:	eaffe0ef          	jal	ra,80000b9a <acquire>
      if(p->state == RUNNABLE) {
    80001cf0:	4c9c                	lw	a5,24(s1)
    80001cf2:	ff2795e3          	bne	a5,s2,80001cdc <scheduler+0x52>
        p->state = RUNNING;
    80001cf6:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    80001cfa:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001cfe:	06048593          	addi	a1,s1,96
    80001d02:	855a                	mv	a0,s6
    80001d04:	5b2000ef          	jal	ra,800022b6 <swtch>
        c->proc = 0;
    80001d08:	020a3823          	sd	zero,48(s4)
        found = 1;
    80001d0c:	8ade                	mv	s5,s7
    80001d0e:	b7f9                	j	80001cdc <scheduler+0x52>
    if(found == 0) {
    80001d10:	000a9a63          	bnez	s5,80001d24 <scheduler+0x9a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d14:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d18:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d1c:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    80001d20:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d24:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d28:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d2c:	10079073          	csrw	sstatus,a5
    int found = 0;
    80001d30:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80001d32:	0000e497          	auipc	s1,0xe
    80001d36:	4de48493          	addi	s1,s1,1246 # 80010210 <proc>
      if(p->state == RUNNABLE) {
    80001d3a:	490d                	li	s2,3
    80001d3c:	b77d                	j	80001cea <scheduler+0x60>

0000000080001d3e <sched>:
{
    80001d3e:	7179                	addi	sp,sp,-48
    80001d40:	f406                	sd	ra,40(sp)
    80001d42:	f022                	sd	s0,32(sp)
    80001d44:	ec26                	sd	s1,24(sp)
    80001d46:	e84a                	sd	s2,16(sp)
    80001d48:	e44e                	sd	s3,8(sp)
    80001d4a:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001d4c:	b0dff0ef          	jal	ra,80001858 <myproc>
    80001d50:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001d52:	ddffe0ef          	jal	ra,80000b30 <holding>
    80001d56:	c92d                	beqz	a0,80001dc8 <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001d58:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001d5a:	2781                	sext.w	a5,a5
    80001d5c:	079e                	slli	a5,a5,0x7
    80001d5e:	0000e717          	auipc	a4,0xe
    80001d62:	08270713          	addi	a4,a4,130 # 8000fde0 <pid_lock>
    80001d66:	97ba                	add	a5,a5,a4
    80001d68:	0a87a703          	lw	a4,168(a5)
    80001d6c:	4785                	li	a5,1
    80001d6e:	06f71363          	bne	a4,a5,80001dd4 <sched+0x96>
  if(p->state == RUNNING)
    80001d72:	4c98                	lw	a4,24(s1)
    80001d74:	4791                	li	a5,4
    80001d76:	06f70563          	beq	a4,a5,80001de0 <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d7a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001d7e:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001d80:	e7b5                	bnez	a5,80001dec <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001d82:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001d84:	0000e917          	auipc	s2,0xe
    80001d88:	05c90913          	addi	s2,s2,92 # 8000fde0 <pid_lock>
    80001d8c:	2781                	sext.w	a5,a5
    80001d8e:	079e                	slli	a5,a5,0x7
    80001d90:	97ca                	add	a5,a5,s2
    80001d92:	0ac7a983          	lw	s3,172(a5)
    80001d96:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001d98:	2781                	sext.w	a5,a5
    80001d9a:	079e                	slli	a5,a5,0x7
    80001d9c:	0000e597          	auipc	a1,0xe
    80001da0:	07c58593          	addi	a1,a1,124 # 8000fe18 <cpus+0x8>
    80001da4:	95be                	add	a1,a1,a5
    80001da6:	06048513          	addi	a0,s1,96
    80001daa:	50c000ef          	jal	ra,800022b6 <swtch>
    80001dae:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001db0:	2781                	sext.w	a5,a5
    80001db2:	079e                	slli	a5,a5,0x7
    80001db4:	97ca                	add	a5,a5,s2
    80001db6:	0b37a623          	sw	s3,172(a5)
}
    80001dba:	70a2                	ld	ra,40(sp)
    80001dbc:	7402                	ld	s0,32(sp)
    80001dbe:	64e2                	ld	s1,24(sp)
    80001dc0:	6942                	ld	s2,16(sp)
    80001dc2:	69a2                	ld	s3,8(sp)
    80001dc4:	6145                	addi	sp,sp,48
    80001dc6:	8082                	ret
    panic("sched p->lock");
    80001dc8:	00005517          	auipc	a0,0x5
    80001dcc:	4a050513          	addi	a0,a0,1184 # 80007268 <digits+0x230>
    80001dd0:	987fe0ef          	jal	ra,80000756 <panic>
    panic("sched locks");
    80001dd4:	00005517          	auipc	a0,0x5
    80001dd8:	4a450513          	addi	a0,a0,1188 # 80007278 <digits+0x240>
    80001ddc:	97bfe0ef          	jal	ra,80000756 <panic>
    panic("sched running");
    80001de0:	00005517          	auipc	a0,0x5
    80001de4:	4a850513          	addi	a0,a0,1192 # 80007288 <digits+0x250>
    80001de8:	96ffe0ef          	jal	ra,80000756 <panic>
    panic("sched interruptible");
    80001dec:	00005517          	auipc	a0,0x5
    80001df0:	4ac50513          	addi	a0,a0,1196 # 80007298 <digits+0x260>
    80001df4:	963fe0ef          	jal	ra,80000756 <panic>

0000000080001df8 <yield>:
{
    80001df8:	1101                	addi	sp,sp,-32
    80001dfa:	ec06                	sd	ra,24(sp)
    80001dfc:	e822                	sd	s0,16(sp)
    80001dfe:	e426                	sd	s1,8(sp)
    80001e00:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001e02:	a57ff0ef          	jal	ra,80001858 <myproc>
    80001e06:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001e08:	d93fe0ef          	jal	ra,80000b9a <acquire>
  p->state = RUNNABLE;
    80001e0c:	478d                	li	a5,3
    80001e0e:	cc9c                	sw	a5,24(s1)
  sched();
    80001e10:	f2fff0ef          	jal	ra,80001d3e <sched>
  release(&p->lock);
    80001e14:	8526                	mv	a0,s1
    80001e16:	e1dfe0ef          	jal	ra,80000c32 <release>
}
    80001e1a:	60e2                	ld	ra,24(sp)
    80001e1c:	6442                	ld	s0,16(sp)
    80001e1e:	64a2                	ld	s1,8(sp)
    80001e20:	6105                	addi	sp,sp,32
    80001e22:	8082                	ret

0000000080001e24 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001e24:	7179                	addi	sp,sp,-48
    80001e26:	f406                	sd	ra,40(sp)
    80001e28:	f022                	sd	s0,32(sp)
    80001e2a:	ec26                	sd	s1,24(sp)
    80001e2c:	e84a                	sd	s2,16(sp)
    80001e2e:	e44e                	sd	s3,8(sp)
    80001e30:	1800                	addi	s0,sp,48
    80001e32:	89aa                	mv	s3,a0
    80001e34:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001e36:	a23ff0ef          	jal	ra,80001858 <myproc>
    80001e3a:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001e3c:	d5ffe0ef          	jal	ra,80000b9a <acquire>
  release(lk);
    80001e40:	854a                	mv	a0,s2
    80001e42:	df1fe0ef          	jal	ra,80000c32 <release>

  // Go to sleep.
  p->chan = chan;
    80001e46:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001e4a:	4789                	li	a5,2
    80001e4c:	cc9c                	sw	a5,24(s1)

  sched();
    80001e4e:	ef1ff0ef          	jal	ra,80001d3e <sched>

  // Tidy up.
  p->chan = 0;
    80001e52:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001e56:	8526                	mv	a0,s1
    80001e58:	ddbfe0ef          	jal	ra,80000c32 <release>
  acquire(lk);
    80001e5c:	854a                	mv	a0,s2
    80001e5e:	d3dfe0ef          	jal	ra,80000b9a <acquire>
}
    80001e62:	70a2                	ld	ra,40(sp)
    80001e64:	7402                	ld	s0,32(sp)
    80001e66:	64e2                	ld	s1,24(sp)
    80001e68:	6942                	ld	s2,16(sp)
    80001e6a:	69a2                	ld	s3,8(sp)
    80001e6c:	6145                	addi	sp,sp,48
    80001e6e:	8082                	ret

0000000080001e70 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001e70:	7139                	addi	sp,sp,-64
    80001e72:	fc06                	sd	ra,56(sp)
    80001e74:	f822                	sd	s0,48(sp)
    80001e76:	f426                	sd	s1,40(sp)
    80001e78:	f04a                	sd	s2,32(sp)
    80001e7a:	ec4e                	sd	s3,24(sp)
    80001e7c:	e852                	sd	s4,16(sp)
    80001e7e:	e456                	sd	s5,8(sp)
    80001e80:	0080                	addi	s0,sp,64
    80001e82:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001e84:	0000e497          	auipc	s1,0xe
    80001e88:	38c48493          	addi	s1,s1,908 # 80010210 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001e8c:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001e8e:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001e90:	0002b917          	auipc	s2,0x2b
    80001e94:	d8090913          	addi	s2,s2,-640 # 8002cc10 <tickslock>
    80001e98:	a801                	j	80001ea8 <wakeup+0x38>
      }
      release(&p->lock);
    80001e9a:	8526                	mv	a0,s1
    80001e9c:	d97fe0ef          	jal	ra,80000c32 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001ea0:	72848493          	addi	s1,s1,1832
    80001ea4:	03248263          	beq	s1,s2,80001ec8 <wakeup+0x58>
    if(p != myproc()){
    80001ea8:	9b1ff0ef          	jal	ra,80001858 <myproc>
    80001eac:	fea48ae3          	beq	s1,a0,80001ea0 <wakeup+0x30>
      acquire(&p->lock);
    80001eb0:	8526                	mv	a0,s1
    80001eb2:	ce9fe0ef          	jal	ra,80000b9a <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001eb6:	4c9c                	lw	a5,24(s1)
    80001eb8:	ff3791e3          	bne	a5,s3,80001e9a <wakeup+0x2a>
    80001ebc:	709c                	ld	a5,32(s1)
    80001ebe:	fd479ee3          	bne	a5,s4,80001e9a <wakeup+0x2a>
        p->state = RUNNABLE;
    80001ec2:	0154ac23          	sw	s5,24(s1)
    80001ec6:	bfd1                	j	80001e9a <wakeup+0x2a>
    }
  }
}
    80001ec8:	70e2                	ld	ra,56(sp)
    80001eca:	7442                	ld	s0,48(sp)
    80001ecc:	74a2                	ld	s1,40(sp)
    80001ece:	7902                	ld	s2,32(sp)
    80001ed0:	69e2                	ld	s3,24(sp)
    80001ed2:	6a42                	ld	s4,16(sp)
    80001ed4:	6aa2                	ld	s5,8(sp)
    80001ed6:	6121                	addi	sp,sp,64
    80001ed8:	8082                	ret

0000000080001eda <reparent>:
{
    80001eda:	7179                	addi	sp,sp,-48
    80001edc:	f406                	sd	ra,40(sp)
    80001ede:	f022                	sd	s0,32(sp)
    80001ee0:	ec26                	sd	s1,24(sp)
    80001ee2:	e84a                	sd	s2,16(sp)
    80001ee4:	e44e                	sd	s3,8(sp)
    80001ee6:	e052                	sd	s4,0(sp)
    80001ee8:	1800                	addi	s0,sp,48
    80001eea:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001eec:	0000e497          	auipc	s1,0xe
    80001ef0:	32448493          	addi	s1,s1,804 # 80010210 <proc>
      pp->parent = initproc;
    80001ef4:	00006a17          	auipc	s4,0x6
    80001ef8:	db4a0a13          	addi	s4,s4,-588 # 80007ca8 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001efc:	0002b997          	auipc	s3,0x2b
    80001f00:	d1498993          	addi	s3,s3,-748 # 8002cc10 <tickslock>
    80001f04:	a029                	j	80001f0e <reparent+0x34>
    80001f06:	72848493          	addi	s1,s1,1832
    80001f0a:	01348b63          	beq	s1,s3,80001f20 <reparent+0x46>
    if(pp->parent == p){
    80001f0e:	7c9c                	ld	a5,56(s1)
    80001f10:	ff279be3          	bne	a5,s2,80001f06 <reparent+0x2c>
      pp->parent = initproc;
    80001f14:	000a3503          	ld	a0,0(s4)
    80001f18:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001f1a:	f57ff0ef          	jal	ra,80001e70 <wakeup>
    80001f1e:	b7e5                	j	80001f06 <reparent+0x2c>
}
    80001f20:	70a2                	ld	ra,40(sp)
    80001f22:	7402                	ld	s0,32(sp)
    80001f24:	64e2                	ld	s1,24(sp)
    80001f26:	6942                	ld	s2,16(sp)
    80001f28:	69a2                	ld	s3,8(sp)
    80001f2a:	6a02                	ld	s4,0(sp)
    80001f2c:	6145                	addi	sp,sp,48
    80001f2e:	8082                	ret

0000000080001f30 <exit>:
{
    80001f30:	7179                	addi	sp,sp,-48
    80001f32:	f406                	sd	ra,40(sp)
    80001f34:	f022                	sd	s0,32(sp)
    80001f36:	ec26                	sd	s1,24(sp)
    80001f38:	e84a                	sd	s2,16(sp)
    80001f3a:	e44e                	sd	s3,8(sp)
    80001f3c:	e052                	sd	s4,0(sp)
    80001f3e:	1800                	addi	s0,sp,48
    80001f40:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001f42:	917ff0ef          	jal	ra,80001858 <myproc>
    80001f46:	89aa                	mv	s3,a0
  if(p == initproc)
    80001f48:	00006797          	auipc	a5,0x6
    80001f4c:	d607b783          	ld	a5,-672(a5) # 80007ca8 <initproc>
    80001f50:	0d050493          	addi	s1,a0,208
    80001f54:	71050913          	addi	s2,a0,1808
    80001f58:	00a79f63          	bne	a5,a0,80001f76 <exit+0x46>
    panic("init exiting");
    80001f5c:	00005517          	auipc	a0,0x5
    80001f60:	35450513          	addi	a0,a0,852 # 800072b0 <digits+0x278>
    80001f64:	ff2fe0ef          	jal	ra,80000756 <panic>
      fileclose(f);
    80001f68:	6ff010ef          	jal	ra,80003e66 <fileclose>
      p->ofile[fd] = 0;
    80001f6c:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001f70:	04a1                	addi	s1,s1,8
    80001f72:	01248563          	beq	s1,s2,80001f7c <exit+0x4c>
    if(p->ofile[fd]){
    80001f76:	6088                	ld	a0,0(s1)
    80001f78:	f965                	bnez	a0,80001f68 <exit+0x38>
    80001f7a:	bfdd                	j	80001f70 <exit+0x40>
  begin_op();
    80001f7c:	221010ef          	jal	ra,8000399c <begin_op>
  iput(p->cwd);
    80001f80:	7109b503          	ld	a0,1808(s3)
    80001f84:	30c010ef          	jal	ra,80003290 <iput>
  end_op();
    80001f88:	285010ef          	jal	ra,80003a0c <end_op>
  p->cwd = 0;
    80001f8c:	7009b823          	sd	zero,1808(s3)
  acquire(&wait_lock);
    80001f90:	0000e497          	auipc	s1,0xe
    80001f94:	e6848493          	addi	s1,s1,-408 # 8000fdf8 <wait_lock>
    80001f98:	8526                	mv	a0,s1
    80001f9a:	c01fe0ef          	jal	ra,80000b9a <acquire>
  reparent(p);
    80001f9e:	854e                	mv	a0,s3
    80001fa0:	f3bff0ef          	jal	ra,80001eda <reparent>
  wakeup(p->parent);
    80001fa4:	0389b503          	ld	a0,56(s3)
    80001fa8:	ec9ff0ef          	jal	ra,80001e70 <wakeup>
  acquire(&p->lock);
    80001fac:	854e                	mv	a0,s3
    80001fae:	bedfe0ef          	jal	ra,80000b9a <acquire>
  p->xstate = status;
    80001fb2:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001fb6:	4795                	li	a5,5
    80001fb8:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001fbc:	8526                	mv	a0,s1
    80001fbe:	c75fe0ef          	jal	ra,80000c32 <release>
  sched();
    80001fc2:	d7dff0ef          	jal	ra,80001d3e <sched>
  panic("zombie exit");
    80001fc6:	00005517          	auipc	a0,0x5
    80001fca:	2fa50513          	addi	a0,a0,762 # 800072c0 <digits+0x288>
    80001fce:	f88fe0ef          	jal	ra,80000756 <panic>

0000000080001fd2 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001fd2:	7179                	addi	sp,sp,-48
    80001fd4:	f406                	sd	ra,40(sp)
    80001fd6:	f022                	sd	s0,32(sp)
    80001fd8:	ec26                	sd	s1,24(sp)
    80001fda:	e84a                	sd	s2,16(sp)
    80001fdc:	e44e                	sd	s3,8(sp)
    80001fde:	1800                	addi	s0,sp,48
    80001fe0:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001fe2:	0000e497          	auipc	s1,0xe
    80001fe6:	22e48493          	addi	s1,s1,558 # 80010210 <proc>
    80001fea:	0002b997          	auipc	s3,0x2b
    80001fee:	c2698993          	addi	s3,s3,-986 # 8002cc10 <tickslock>
    acquire(&p->lock);
    80001ff2:	8526                	mv	a0,s1
    80001ff4:	ba7fe0ef          	jal	ra,80000b9a <acquire>
    if(p->pid == pid){
    80001ff8:	589c                	lw	a5,48(s1)
    80001ffa:	01278b63          	beq	a5,s2,80002010 <kill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001ffe:	8526                	mv	a0,s1
    80002000:	c33fe0ef          	jal	ra,80000c32 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80002004:	72848493          	addi	s1,s1,1832
    80002008:	ff3495e3          	bne	s1,s3,80001ff2 <kill+0x20>
  }
  return -1;
    8000200c:	557d                	li	a0,-1
    8000200e:	a819                	j	80002024 <kill+0x52>
      p->killed = 1;
    80002010:	4785                	li	a5,1
    80002012:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80002014:	4c98                	lw	a4,24(s1)
    80002016:	4789                	li	a5,2
    80002018:	00f70d63          	beq	a4,a5,80002032 <kill+0x60>
      release(&p->lock);
    8000201c:	8526                	mv	a0,s1
    8000201e:	c15fe0ef          	jal	ra,80000c32 <release>
      return 0;
    80002022:	4501                	li	a0,0
}
    80002024:	70a2                	ld	ra,40(sp)
    80002026:	7402                	ld	s0,32(sp)
    80002028:	64e2                	ld	s1,24(sp)
    8000202a:	6942                	ld	s2,16(sp)
    8000202c:	69a2                	ld	s3,8(sp)
    8000202e:	6145                	addi	sp,sp,48
    80002030:	8082                	ret
        p->state = RUNNABLE;
    80002032:	478d                	li	a5,3
    80002034:	cc9c                	sw	a5,24(s1)
    80002036:	b7dd                	j	8000201c <kill+0x4a>

0000000080002038 <setkilled>:

void
setkilled(struct proc *p)
{
    80002038:	1101                	addi	sp,sp,-32
    8000203a:	ec06                	sd	ra,24(sp)
    8000203c:	e822                	sd	s0,16(sp)
    8000203e:	e426                	sd	s1,8(sp)
    80002040:	1000                	addi	s0,sp,32
    80002042:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002044:	b57fe0ef          	jal	ra,80000b9a <acquire>
  p->killed = 1;
    80002048:	4785                	li	a5,1
    8000204a:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    8000204c:	8526                	mv	a0,s1
    8000204e:	be5fe0ef          	jal	ra,80000c32 <release>
}
    80002052:	60e2                	ld	ra,24(sp)
    80002054:	6442                	ld	s0,16(sp)
    80002056:	64a2                	ld	s1,8(sp)
    80002058:	6105                	addi	sp,sp,32
    8000205a:	8082                	ret

000000008000205c <killed>:

int
killed(struct proc *p)
{
    8000205c:	1101                	addi	sp,sp,-32
    8000205e:	ec06                	sd	ra,24(sp)
    80002060:	e822                	sd	s0,16(sp)
    80002062:	e426                	sd	s1,8(sp)
    80002064:	e04a                	sd	s2,0(sp)
    80002066:	1000                	addi	s0,sp,32
    80002068:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    8000206a:	b31fe0ef          	jal	ra,80000b9a <acquire>
  k = p->killed;
    8000206e:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80002072:	8526                	mv	a0,s1
    80002074:	bbffe0ef          	jal	ra,80000c32 <release>
  return k;
}
    80002078:	854a                	mv	a0,s2
    8000207a:	60e2                	ld	ra,24(sp)
    8000207c:	6442                	ld	s0,16(sp)
    8000207e:	64a2                	ld	s1,8(sp)
    80002080:	6902                	ld	s2,0(sp)
    80002082:	6105                	addi	sp,sp,32
    80002084:	8082                	ret

0000000080002086 <wait>:
{
    80002086:	715d                	addi	sp,sp,-80
    80002088:	e486                	sd	ra,72(sp)
    8000208a:	e0a2                	sd	s0,64(sp)
    8000208c:	fc26                	sd	s1,56(sp)
    8000208e:	f84a                	sd	s2,48(sp)
    80002090:	f44e                	sd	s3,40(sp)
    80002092:	f052                	sd	s4,32(sp)
    80002094:	ec56                	sd	s5,24(sp)
    80002096:	e85a                	sd	s6,16(sp)
    80002098:	e45e                	sd	s7,8(sp)
    8000209a:	e062                	sd	s8,0(sp)
    8000209c:	0880                	addi	s0,sp,80
    8000209e:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800020a0:	fb8ff0ef          	jal	ra,80001858 <myproc>
    800020a4:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800020a6:	0000e517          	auipc	a0,0xe
    800020aa:	d5250513          	addi	a0,a0,-686 # 8000fdf8 <wait_lock>
    800020ae:	aedfe0ef          	jal	ra,80000b9a <acquire>
    havekids = 0;
    800020b2:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    800020b4:	4a15                	li	s4,5
        havekids = 1;
    800020b6:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800020b8:	0002b997          	auipc	s3,0x2b
    800020bc:	b5898993          	addi	s3,s3,-1192 # 8002cc10 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800020c0:	0000ec17          	auipc	s8,0xe
    800020c4:	d38c0c13          	addi	s8,s8,-712 # 8000fdf8 <wait_lock>
    havekids = 0;
    800020c8:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800020ca:	0000e497          	auipc	s1,0xe
    800020ce:	14648493          	addi	s1,s1,326 # 80010210 <proc>
    800020d2:	a899                	j	80002128 <wait+0xa2>
          pid = pp->pid;
    800020d4:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800020d8:	000b0c63          	beqz	s6,800020f0 <wait+0x6a>
    800020dc:	4691                	li	a3,4
    800020de:	02c48613          	addi	a2,s1,44
    800020e2:	85da                	mv	a1,s6
    800020e4:	05093503          	ld	a0,80(s2)
    800020e8:	c24ff0ef          	jal	ra,8000150c <copyout>
    800020ec:	00054f63          	bltz	a0,8000210a <wait+0x84>
          freeproc(pp);
    800020f0:	8526                	mv	a0,s1
    800020f2:	8d9ff0ef          	jal	ra,800019ca <freeproc>
          release(&pp->lock);
    800020f6:	8526                	mv	a0,s1
    800020f8:	b3bfe0ef          	jal	ra,80000c32 <release>
          release(&wait_lock);
    800020fc:	0000e517          	auipc	a0,0xe
    80002100:	cfc50513          	addi	a0,a0,-772 # 8000fdf8 <wait_lock>
    80002104:	b2ffe0ef          	jal	ra,80000c32 <release>
          return pid;
    80002108:	a891                	j	8000215c <wait+0xd6>
            release(&pp->lock);
    8000210a:	8526                	mv	a0,s1
    8000210c:	b27fe0ef          	jal	ra,80000c32 <release>
            release(&wait_lock);
    80002110:	0000e517          	auipc	a0,0xe
    80002114:	ce850513          	addi	a0,a0,-792 # 8000fdf8 <wait_lock>
    80002118:	b1bfe0ef          	jal	ra,80000c32 <release>
            return -1;
    8000211c:	59fd                	li	s3,-1
    8000211e:	a83d                	j	8000215c <wait+0xd6>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002120:	72848493          	addi	s1,s1,1832
    80002124:	03348063          	beq	s1,s3,80002144 <wait+0xbe>
      if(pp->parent == p){
    80002128:	7c9c                	ld	a5,56(s1)
    8000212a:	ff279be3          	bne	a5,s2,80002120 <wait+0x9a>
        acquire(&pp->lock);
    8000212e:	8526                	mv	a0,s1
    80002130:	a6bfe0ef          	jal	ra,80000b9a <acquire>
        if(pp->state == ZOMBIE){
    80002134:	4c9c                	lw	a5,24(s1)
    80002136:	f9478fe3          	beq	a5,s4,800020d4 <wait+0x4e>
        release(&pp->lock);
    8000213a:	8526                	mv	a0,s1
    8000213c:	af7fe0ef          	jal	ra,80000c32 <release>
        havekids = 1;
    80002140:	8756                	mv	a4,s5
    80002142:	bff9                	j	80002120 <wait+0x9a>
    if(!havekids || killed(p)){
    80002144:	c709                	beqz	a4,8000214e <wait+0xc8>
    80002146:	854a                	mv	a0,s2
    80002148:	f15ff0ef          	jal	ra,8000205c <killed>
    8000214c:	c50d                	beqz	a0,80002176 <wait+0xf0>
      release(&wait_lock);
    8000214e:	0000e517          	auipc	a0,0xe
    80002152:	caa50513          	addi	a0,a0,-854 # 8000fdf8 <wait_lock>
    80002156:	addfe0ef          	jal	ra,80000c32 <release>
      return -1;
    8000215a:	59fd                	li	s3,-1
}
    8000215c:	854e                	mv	a0,s3
    8000215e:	60a6                	ld	ra,72(sp)
    80002160:	6406                	ld	s0,64(sp)
    80002162:	74e2                	ld	s1,56(sp)
    80002164:	7942                	ld	s2,48(sp)
    80002166:	79a2                	ld	s3,40(sp)
    80002168:	7a02                	ld	s4,32(sp)
    8000216a:	6ae2                	ld	s5,24(sp)
    8000216c:	6b42                	ld	s6,16(sp)
    8000216e:	6ba2                	ld	s7,8(sp)
    80002170:	6c02                	ld	s8,0(sp)
    80002172:	6161                	addi	sp,sp,80
    80002174:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002176:	85e2                	mv	a1,s8
    80002178:	854a                	mv	a0,s2
    8000217a:	cabff0ef          	jal	ra,80001e24 <sleep>
    havekids = 0;
    8000217e:	b7a9                	j	800020c8 <wait+0x42>

0000000080002180 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002180:	7179                	addi	sp,sp,-48
    80002182:	f406                	sd	ra,40(sp)
    80002184:	f022                	sd	s0,32(sp)
    80002186:	ec26                	sd	s1,24(sp)
    80002188:	e84a                	sd	s2,16(sp)
    8000218a:	e44e                	sd	s3,8(sp)
    8000218c:	e052                	sd	s4,0(sp)
    8000218e:	1800                	addi	s0,sp,48
    80002190:	84aa                	mv	s1,a0
    80002192:	892e                	mv	s2,a1
    80002194:	89b2                	mv	s3,a2
    80002196:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002198:	ec0ff0ef          	jal	ra,80001858 <myproc>
  if(user_dst){
    8000219c:	cc99                	beqz	s1,800021ba <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    8000219e:	86d2                	mv	a3,s4
    800021a0:	864e                	mv	a2,s3
    800021a2:	85ca                	mv	a1,s2
    800021a4:	6928                	ld	a0,80(a0)
    800021a6:	b66ff0ef          	jal	ra,8000150c <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800021aa:	70a2                	ld	ra,40(sp)
    800021ac:	7402                	ld	s0,32(sp)
    800021ae:	64e2                	ld	s1,24(sp)
    800021b0:	6942                	ld	s2,16(sp)
    800021b2:	69a2                	ld	s3,8(sp)
    800021b4:	6a02                	ld	s4,0(sp)
    800021b6:	6145                	addi	sp,sp,48
    800021b8:	8082                	ret
    memmove((char *)dst, src, len);
    800021ba:	000a061b          	sext.w	a2,s4
    800021be:	85ce                	mv	a1,s3
    800021c0:	854a                	mv	a0,s2
    800021c2:	b09fe0ef          	jal	ra,80000cca <memmove>
    return 0;
    800021c6:	8526                	mv	a0,s1
    800021c8:	b7cd                	j	800021aa <either_copyout+0x2a>

00000000800021ca <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800021ca:	7179                	addi	sp,sp,-48
    800021cc:	f406                	sd	ra,40(sp)
    800021ce:	f022                	sd	s0,32(sp)
    800021d0:	ec26                	sd	s1,24(sp)
    800021d2:	e84a                	sd	s2,16(sp)
    800021d4:	e44e                	sd	s3,8(sp)
    800021d6:	e052                	sd	s4,0(sp)
    800021d8:	1800                	addi	s0,sp,48
    800021da:	892a                	mv	s2,a0
    800021dc:	84ae                	mv	s1,a1
    800021de:	89b2                	mv	s3,a2
    800021e0:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800021e2:	e76ff0ef          	jal	ra,80001858 <myproc>
  if(user_src){
    800021e6:	cc99                	beqz	s1,80002204 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    800021e8:	86d2                	mv	a3,s4
    800021ea:	864e                	mv	a2,s3
    800021ec:	85ca                	mv	a1,s2
    800021ee:	6928                	ld	a0,80(a0)
    800021f0:	bd4ff0ef          	jal	ra,800015c4 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800021f4:	70a2                	ld	ra,40(sp)
    800021f6:	7402                	ld	s0,32(sp)
    800021f8:	64e2                	ld	s1,24(sp)
    800021fa:	6942                	ld	s2,16(sp)
    800021fc:	69a2                	ld	s3,8(sp)
    800021fe:	6a02                	ld	s4,0(sp)
    80002200:	6145                	addi	sp,sp,48
    80002202:	8082                	ret
    memmove(dst, (char*)src, len);
    80002204:	000a061b          	sext.w	a2,s4
    80002208:	85ce                	mv	a1,s3
    8000220a:	854a                	mv	a0,s2
    8000220c:	abffe0ef          	jal	ra,80000cca <memmove>
    return 0;
    80002210:	8526                	mv	a0,s1
    80002212:	b7cd                	j	800021f4 <either_copyin+0x2a>

0000000080002214 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80002214:	715d                	addi	sp,sp,-80
    80002216:	e486                	sd	ra,72(sp)
    80002218:	e0a2                	sd	s0,64(sp)
    8000221a:	fc26                	sd	s1,56(sp)
    8000221c:	f84a                	sd	s2,48(sp)
    8000221e:	f44e                	sd	s3,40(sp)
    80002220:	f052                	sd	s4,32(sp)
    80002222:	ec56                	sd	s5,24(sp)
    80002224:	e85a                	sd	s6,16(sp)
    80002226:	e45e                	sd	s7,8(sp)
    80002228:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    8000222a:	00005517          	auipc	a0,0x5
    8000222e:	55650513          	addi	a0,a0,1366 # 80007780 <syscalls+0x2d8>
    80002232:	a70fe0ef          	jal	ra,800004a2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002236:	0000e497          	auipc	s1,0xe
    8000223a:	6f248493          	addi	s1,s1,1778 # 80010928 <proc+0x718>
    8000223e:	0002b917          	auipc	s2,0x2b
    80002242:	0ea90913          	addi	s2,s2,234 # 8002d328 <bcache+0x700>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002246:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80002248:	00005997          	auipc	s3,0x5
    8000224c:	08898993          	addi	s3,s3,136 # 800072d0 <digits+0x298>
    printf("%d %s %s", p->pid, state, p->name);
    80002250:	00005a97          	auipc	s5,0x5
    80002254:	088a8a93          	addi	s5,s5,136 # 800072d8 <digits+0x2a0>
    printf("\n");
    80002258:	00005a17          	auipc	s4,0x5
    8000225c:	528a0a13          	addi	s4,s4,1320 # 80007780 <syscalls+0x2d8>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002260:	00005b97          	auipc	s7,0x5
    80002264:	0b8b8b93          	addi	s7,s7,184 # 80007318 <states.0>
    80002268:	a829                	j	80002282 <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    8000226a:	9186a583          	lw	a1,-1768(a3)
    8000226e:	8556                	mv	a0,s5
    80002270:	a32fe0ef          	jal	ra,800004a2 <printf>
    printf("\n");
    80002274:	8552                	mv	a0,s4
    80002276:	a2cfe0ef          	jal	ra,800004a2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000227a:	72848493          	addi	s1,s1,1832
    8000227e:	03248163          	beq	s1,s2,800022a0 <procdump+0x8c>
    if(p->state == UNUSED)
    80002282:	86a6                	mv	a3,s1
    80002284:	9004a783          	lw	a5,-1792(s1)
    80002288:	dbed                	beqz	a5,8000227a <procdump+0x66>
      state = "???";
    8000228a:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000228c:	fcfb6fe3          	bltu	s6,a5,8000226a <procdump+0x56>
    80002290:	1782                	slli	a5,a5,0x20
    80002292:	9381                	srli	a5,a5,0x20
    80002294:	078e                	slli	a5,a5,0x3
    80002296:	97de                	add	a5,a5,s7
    80002298:	6390                	ld	a2,0(a5)
    8000229a:	fa61                	bnez	a2,8000226a <procdump+0x56>
      state = "???";
    8000229c:	864e                	mv	a2,s3
    8000229e:	b7f1                	j	8000226a <procdump+0x56>
  }
}
    800022a0:	60a6                	ld	ra,72(sp)
    800022a2:	6406                	ld	s0,64(sp)
    800022a4:	74e2                	ld	s1,56(sp)
    800022a6:	7942                	ld	s2,48(sp)
    800022a8:	79a2                	ld	s3,40(sp)
    800022aa:	7a02                	ld	s4,32(sp)
    800022ac:	6ae2                	ld	s5,24(sp)
    800022ae:	6b42                	ld	s6,16(sp)
    800022b0:	6ba2                	ld	s7,8(sp)
    800022b2:	6161                	addi	sp,sp,80
    800022b4:	8082                	ret

00000000800022b6 <swtch>:
    800022b6:	00153023          	sd	ra,0(a0)
    800022ba:	00253423          	sd	sp,8(a0)
    800022be:	e900                	sd	s0,16(a0)
    800022c0:	ed04                	sd	s1,24(a0)
    800022c2:	03253023          	sd	s2,32(a0)
    800022c6:	03353423          	sd	s3,40(a0)
    800022ca:	03453823          	sd	s4,48(a0)
    800022ce:	03553c23          	sd	s5,56(a0)
    800022d2:	05653023          	sd	s6,64(a0)
    800022d6:	05753423          	sd	s7,72(a0)
    800022da:	05853823          	sd	s8,80(a0)
    800022de:	05953c23          	sd	s9,88(a0)
    800022e2:	07a53023          	sd	s10,96(a0)
    800022e6:	07b53423          	sd	s11,104(a0)
    800022ea:	0005b083          	ld	ra,0(a1)
    800022ee:	0085b103          	ld	sp,8(a1)
    800022f2:	6980                	ld	s0,16(a1)
    800022f4:	6d84                	ld	s1,24(a1)
    800022f6:	0205b903          	ld	s2,32(a1)
    800022fa:	0285b983          	ld	s3,40(a1)
    800022fe:	0305ba03          	ld	s4,48(a1)
    80002302:	0385ba83          	ld	s5,56(a1)
    80002306:	0405bb03          	ld	s6,64(a1)
    8000230a:	0485bb83          	ld	s7,72(a1)
    8000230e:	0505bc03          	ld	s8,80(a1)
    80002312:	0585bc83          	ld	s9,88(a1)
    80002316:	0605bd03          	ld	s10,96(a1)
    8000231a:	0685bd83          	ld	s11,104(a1)
    8000231e:	8082                	ret

0000000080002320 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002320:	1141                	addi	sp,sp,-16
    80002322:	e406                	sd	ra,8(sp)
    80002324:	e022                	sd	s0,0(sp)
    80002326:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002328:	00005597          	auipc	a1,0x5
    8000232c:	02058593          	addi	a1,a1,32 # 80007348 <states.0+0x30>
    80002330:	0002b517          	auipc	a0,0x2b
    80002334:	8e050513          	addi	a0,a0,-1824 # 8002cc10 <tickslock>
    80002338:	fe2fe0ef          	jal	ra,80000b1a <initlock>
}
    8000233c:	60a2                	ld	ra,8(sp)
    8000233e:	6402                	ld	s0,0(sp)
    80002340:	0141                	addi	sp,sp,16
    80002342:	8082                	ret

0000000080002344 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002344:	1141                	addi	sp,sp,-16
    80002346:	e422                	sd	s0,8(sp)
    80002348:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000234a:	00003797          	auipc	a5,0x3
    8000234e:	e0678793          	addi	a5,a5,-506 # 80005150 <kernelvec>
    80002352:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002356:	6422                	ld	s0,8(sp)
    80002358:	0141                	addi	sp,sp,16
    8000235a:	8082                	ret

000000008000235c <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    8000235c:	1141                	addi	sp,sp,-16
    8000235e:	e406                	sd	ra,8(sp)
    80002360:	e022                	sd	s0,0(sp)
    80002362:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002364:	cf4ff0ef          	jal	ra,80001858 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002368:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000236c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000236e:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002372:	00004617          	auipc	a2,0x4
    80002376:	c8e60613          	addi	a2,a2,-882 # 80006000 <_trampoline>
    8000237a:	00004697          	auipc	a3,0x4
    8000237e:	c8668693          	addi	a3,a3,-890 # 80006000 <_trampoline>
    80002382:	8e91                	sub	a3,a3,a2
    80002384:	040007b7          	lui	a5,0x4000
    80002388:	17fd                	addi	a5,a5,-1
    8000238a:	07b2                	slli	a5,a5,0xc
    8000238c:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000238e:	10569073          	csrw	stvec,a3
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002392:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002394:	180026f3          	csrr	a3,satp
    80002398:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    8000239a:	6d38                	ld	a4,88(a0)
    8000239c:	6134                	ld	a3,64(a0)
    8000239e:	6585                	lui	a1,0x1
    800023a0:	96ae                	add	a3,a3,a1
    800023a2:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    800023a4:	6d38                	ld	a4,88(a0)
    800023a6:	00000697          	auipc	a3,0x0
    800023aa:	10c68693          	addi	a3,a3,268 # 800024b2 <usertrap>
    800023ae:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    800023b0:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    800023b2:	8692                	mv	a3,tp
    800023b4:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800023b6:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    800023ba:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    800023be:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800023c2:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    800023c6:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    800023c8:	6f18                	ld	a4,24(a4)
    800023ca:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    800023ce:	6928                	ld	a0,80(a0)
    800023d0:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    800023d2:	00004717          	auipc	a4,0x4
    800023d6:	cca70713          	addi	a4,a4,-822 # 8000609c <userret>
    800023da:	8f11                	sub	a4,a4,a2
    800023dc:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    800023de:	577d                	li	a4,-1
    800023e0:	177e                	slli	a4,a4,0x3f
    800023e2:	8d59                	or	a0,a0,a4
    800023e4:	9782                	jalr	a5
}
    800023e6:	60a2                	ld	ra,8(sp)
    800023e8:	6402                	ld	s0,0(sp)
    800023ea:	0141                	addi	sp,sp,16
    800023ec:	8082                	ret

00000000800023ee <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    800023ee:	1101                	addi	sp,sp,-32
    800023f0:	ec06                	sd	ra,24(sp)
    800023f2:	e822                	sd	s0,16(sp)
    800023f4:	e426                	sd	s1,8(sp)
    800023f6:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    800023f8:	c34ff0ef          	jal	ra,8000182c <cpuid>
    800023fc:	cd19                	beqz	a0,8000241a <clockintr+0x2c>
  asm volatile("csrr %0, time" : "=r" (x) );
    800023fe:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    80002402:	000f4737          	lui	a4,0xf4
    80002406:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    8000240a:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    8000240c:	14d79073          	csrw	0x14d,a5
}
    80002410:	60e2                	ld	ra,24(sp)
    80002412:	6442                	ld	s0,16(sp)
    80002414:	64a2                	ld	s1,8(sp)
    80002416:	6105                	addi	sp,sp,32
    80002418:	8082                	ret
    acquire(&tickslock);
    8000241a:	0002a497          	auipc	s1,0x2a
    8000241e:	7f648493          	addi	s1,s1,2038 # 8002cc10 <tickslock>
    80002422:	8526                	mv	a0,s1
    80002424:	f76fe0ef          	jal	ra,80000b9a <acquire>
    ticks++;
    80002428:	00006517          	auipc	a0,0x6
    8000242c:	88850513          	addi	a0,a0,-1912 # 80007cb0 <ticks>
    80002430:	411c                	lw	a5,0(a0)
    80002432:	2785                	addiw	a5,a5,1
    80002434:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    80002436:	a3bff0ef          	jal	ra,80001e70 <wakeup>
    release(&tickslock);
    8000243a:	8526                	mv	a0,s1
    8000243c:	ff6fe0ef          	jal	ra,80000c32 <release>
    80002440:	bf7d                	j	800023fe <clockintr+0x10>

0000000080002442 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80002442:	1101                	addi	sp,sp,-32
    80002444:	ec06                	sd	ra,24(sp)
    80002446:	e822                	sd	s0,16(sp)
    80002448:	e426                	sd	s1,8(sp)
    8000244a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000244c:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    80002450:	57fd                	li	a5,-1
    80002452:	17fe                	slli	a5,a5,0x3f
    80002454:	07a5                	addi	a5,a5,9
    80002456:	00f70d63          	beq	a4,a5,80002470 <devintr+0x2e>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    8000245a:	57fd                	li	a5,-1
    8000245c:	17fe                	slli	a5,a5,0x3f
    8000245e:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    80002460:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    80002462:	04f70463          	beq	a4,a5,800024aa <devintr+0x68>
  }
}
    80002466:	60e2                	ld	ra,24(sp)
    80002468:	6442                	ld	s0,16(sp)
    8000246a:	64a2                	ld	s1,8(sp)
    8000246c:	6105                	addi	sp,sp,32
    8000246e:	8082                	ret
    int irq = plic_claim();
    80002470:	589020ef          	jal	ra,800051f8 <plic_claim>
    80002474:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80002476:	47a9                	li	a5,10
    80002478:	02f50363          	beq	a0,a5,8000249e <devintr+0x5c>
    } else if(irq == VIRTIO0_IRQ){
    8000247c:	4785                	li	a5,1
    8000247e:	02f50363          	beq	a0,a5,800024a4 <devintr+0x62>
    return 1;
    80002482:	4505                	li	a0,1
    } else if(irq){
    80002484:	d0ed                	beqz	s1,80002466 <devintr+0x24>
      printf("unexpected interrupt irq=%d\n", irq);
    80002486:	85a6                	mv	a1,s1
    80002488:	00005517          	auipc	a0,0x5
    8000248c:	ec850513          	addi	a0,a0,-312 # 80007350 <states.0+0x38>
    80002490:	812fe0ef          	jal	ra,800004a2 <printf>
      plic_complete(irq);
    80002494:	8526                	mv	a0,s1
    80002496:	583020ef          	jal	ra,80005218 <plic_complete>
    return 1;
    8000249a:	4505                	li	a0,1
    8000249c:	b7e9                	j	80002466 <devintr+0x24>
      uartintr();
    8000249e:	d10fe0ef          	jal	ra,800009ae <uartintr>
    800024a2:	bfcd                	j	80002494 <devintr+0x52>
      virtio_disk_intr();
    800024a4:	1e4030ef          	jal	ra,80005688 <virtio_disk_intr>
    800024a8:	b7f5                	j	80002494 <devintr+0x52>
    clockintr();
    800024aa:	f45ff0ef          	jal	ra,800023ee <clockintr>
    return 2;
    800024ae:	4509                	li	a0,2
    800024b0:	bf5d                	j	80002466 <devintr+0x24>

00000000800024b2 <usertrap>:
{
    800024b2:	1101                	addi	sp,sp,-32
    800024b4:	ec06                	sd	ra,24(sp)
    800024b6:	e822                	sd	s0,16(sp)
    800024b8:	e426                	sd	s1,8(sp)
    800024ba:	e04a                	sd	s2,0(sp)
    800024bc:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800024be:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    800024c2:	1007f793          	andi	a5,a5,256
    800024c6:	ef85                	bnez	a5,800024fe <usertrap+0x4c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    800024c8:	00003797          	auipc	a5,0x3
    800024cc:	c8878793          	addi	a5,a5,-888 # 80005150 <kernelvec>
    800024d0:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800024d4:	b84ff0ef          	jal	ra,80001858 <myproc>
    800024d8:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    800024da:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800024dc:	14102773          	csrr	a4,sepc
    800024e0:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    800024e2:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    800024e6:	47a1                	li	a5,8
    800024e8:	02f70163          	beq	a4,a5,8000250a <usertrap+0x58>
  } else if((which_dev = devintr()) != 0){
    800024ec:	f57ff0ef          	jal	ra,80002442 <devintr>
    800024f0:	892a                	mv	s2,a0
    800024f2:	c135                	beqz	a0,80002556 <usertrap+0xa4>
  if(killed(p))
    800024f4:	8526                	mv	a0,s1
    800024f6:	b67ff0ef          	jal	ra,8000205c <killed>
    800024fa:	cd1d                	beqz	a0,80002538 <usertrap+0x86>
    800024fc:	a81d                	j	80002532 <usertrap+0x80>
    panic("usertrap: not from user mode");
    800024fe:	00005517          	auipc	a0,0x5
    80002502:	e7250513          	addi	a0,a0,-398 # 80007370 <states.0+0x58>
    80002506:	a50fe0ef          	jal	ra,80000756 <panic>
    if(killed(p))
    8000250a:	b53ff0ef          	jal	ra,8000205c <killed>
    8000250e:	e121                	bnez	a0,8000254e <usertrap+0x9c>
    p->trapframe->epc += 4;
    80002510:	6cb8                	ld	a4,88(s1)
    80002512:	6f1c                	ld	a5,24(a4)
    80002514:	0791                	addi	a5,a5,4
    80002516:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002518:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000251c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002520:	10079073          	csrw	sstatus,a5
    syscall();
    80002524:	248000ef          	jal	ra,8000276c <syscall>
  if(killed(p))
    80002528:	8526                	mv	a0,s1
    8000252a:	b33ff0ef          	jal	ra,8000205c <killed>
    8000252e:	c901                	beqz	a0,8000253e <usertrap+0x8c>
    80002530:	4901                	li	s2,0
    exit(-1);
    80002532:	557d                	li	a0,-1
    80002534:	9fdff0ef          	jal	ra,80001f30 <exit>
  if(which_dev == 2)
    80002538:	4789                	li	a5,2
    8000253a:	04f90563          	beq	s2,a5,80002584 <usertrap+0xd2>
  usertrapret();
    8000253e:	e1fff0ef          	jal	ra,8000235c <usertrapret>
}
    80002542:	60e2                	ld	ra,24(sp)
    80002544:	6442                	ld	s0,16(sp)
    80002546:	64a2                	ld	s1,8(sp)
    80002548:	6902                	ld	s2,0(sp)
    8000254a:	6105                	addi	sp,sp,32
    8000254c:	8082                	ret
      exit(-1);
    8000254e:	557d                	li	a0,-1
    80002550:	9e1ff0ef          	jal	ra,80001f30 <exit>
    80002554:	bf75                	j	80002510 <usertrap+0x5e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002556:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    8000255a:	5890                	lw	a2,48(s1)
    8000255c:	00005517          	auipc	a0,0x5
    80002560:	e3450513          	addi	a0,a0,-460 # 80007390 <states.0+0x78>
    80002564:	f3ffd0ef          	jal	ra,800004a2 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002568:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000256c:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80002570:	00005517          	auipc	a0,0x5
    80002574:	e5050513          	addi	a0,a0,-432 # 800073c0 <states.0+0xa8>
    80002578:	f2bfd0ef          	jal	ra,800004a2 <printf>
    setkilled(p);
    8000257c:	8526                	mv	a0,s1
    8000257e:	abbff0ef          	jal	ra,80002038 <setkilled>
    80002582:	b75d                	j	80002528 <usertrap+0x76>
    yield();
    80002584:	875ff0ef          	jal	ra,80001df8 <yield>
    80002588:	bf5d                	j	8000253e <usertrap+0x8c>

000000008000258a <kerneltrap>:
{
    8000258a:	7179                	addi	sp,sp,-48
    8000258c:	f406                	sd	ra,40(sp)
    8000258e:	f022                	sd	s0,32(sp)
    80002590:	ec26                	sd	s1,24(sp)
    80002592:	e84a                	sd	s2,16(sp)
    80002594:	e44e                	sd	s3,8(sp)
    80002596:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002598:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000259c:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    800025a0:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    800025a4:	1004f793          	andi	a5,s1,256
    800025a8:	c795                	beqz	a5,800025d4 <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800025aa:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800025ae:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    800025b0:	eb85                	bnez	a5,800025e0 <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    800025b2:	e91ff0ef          	jal	ra,80002442 <devintr>
    800025b6:	c91d                	beqz	a0,800025ec <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    800025b8:	4789                	li	a5,2
    800025ba:	04f50a63          	beq	a0,a5,8000260e <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    800025be:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800025c2:	10049073          	csrw	sstatus,s1
}
    800025c6:	70a2                	ld	ra,40(sp)
    800025c8:	7402                	ld	s0,32(sp)
    800025ca:	64e2                	ld	s1,24(sp)
    800025cc:	6942                	ld	s2,16(sp)
    800025ce:	69a2                	ld	s3,8(sp)
    800025d0:	6145                	addi	sp,sp,48
    800025d2:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    800025d4:	00005517          	auipc	a0,0x5
    800025d8:	e1450513          	addi	a0,a0,-492 # 800073e8 <states.0+0xd0>
    800025dc:	97afe0ef          	jal	ra,80000756 <panic>
    panic("kerneltrap: interrupts enabled");
    800025e0:	00005517          	auipc	a0,0x5
    800025e4:	e3050513          	addi	a0,a0,-464 # 80007410 <states.0+0xf8>
    800025e8:	96efe0ef          	jal	ra,80000756 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800025ec:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800025f0:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    800025f4:	85ce                	mv	a1,s3
    800025f6:	00005517          	auipc	a0,0x5
    800025fa:	e3a50513          	addi	a0,a0,-454 # 80007430 <states.0+0x118>
    800025fe:	ea5fd0ef          	jal	ra,800004a2 <printf>
    panic("kerneltrap");
    80002602:	00005517          	auipc	a0,0x5
    80002606:	e5650513          	addi	a0,a0,-426 # 80007458 <states.0+0x140>
    8000260a:	94cfe0ef          	jal	ra,80000756 <panic>
  if(which_dev == 2 && myproc() != 0)
    8000260e:	a4aff0ef          	jal	ra,80001858 <myproc>
    80002612:	d555                	beqz	a0,800025be <kerneltrap+0x34>
    yield();
    80002614:	fe4ff0ef          	jal	ra,80001df8 <yield>
    80002618:	b75d                	j	800025be <kerneltrap+0x34>

000000008000261a <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    8000261a:	1101                	addi	sp,sp,-32
    8000261c:	ec06                	sd	ra,24(sp)
    8000261e:	e822                	sd	s0,16(sp)
    80002620:	e426                	sd	s1,8(sp)
    80002622:	1000                	addi	s0,sp,32
    80002624:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002626:	a32ff0ef          	jal	ra,80001858 <myproc>
  switch (n) {
    8000262a:	4795                	li	a5,5
    8000262c:	0497e163          	bltu	a5,s1,8000266e <argraw+0x54>
    80002630:	048a                	slli	s1,s1,0x2
    80002632:	00005717          	auipc	a4,0x5
    80002636:	e5e70713          	addi	a4,a4,-418 # 80007490 <states.0+0x178>
    8000263a:	94ba                	add	s1,s1,a4
    8000263c:	409c                	lw	a5,0(s1)
    8000263e:	97ba                	add	a5,a5,a4
    80002640:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002642:	6d3c                	ld	a5,88(a0)
    80002644:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002646:	60e2                	ld	ra,24(sp)
    80002648:	6442                	ld	s0,16(sp)
    8000264a:	64a2                	ld	s1,8(sp)
    8000264c:	6105                	addi	sp,sp,32
    8000264e:	8082                	ret
    return p->trapframe->a1;
    80002650:	6d3c                	ld	a5,88(a0)
    80002652:	7fa8                	ld	a0,120(a5)
    80002654:	bfcd                	j	80002646 <argraw+0x2c>
    return p->trapframe->a2;
    80002656:	6d3c                	ld	a5,88(a0)
    80002658:	63c8                	ld	a0,128(a5)
    8000265a:	b7f5                	j	80002646 <argraw+0x2c>
    return p->trapframe->a3;
    8000265c:	6d3c                	ld	a5,88(a0)
    8000265e:	67c8                	ld	a0,136(a5)
    80002660:	b7dd                	j	80002646 <argraw+0x2c>
    return p->trapframe->a4;
    80002662:	6d3c                	ld	a5,88(a0)
    80002664:	6bc8                	ld	a0,144(a5)
    80002666:	b7c5                	j	80002646 <argraw+0x2c>
    return p->trapframe->a5;
    80002668:	6d3c                	ld	a5,88(a0)
    8000266a:	6fc8                	ld	a0,152(a5)
    8000266c:	bfe9                	j	80002646 <argraw+0x2c>
  panic("argraw");
    8000266e:	00005517          	auipc	a0,0x5
    80002672:	dfa50513          	addi	a0,a0,-518 # 80007468 <states.0+0x150>
    80002676:	8e0fe0ef          	jal	ra,80000756 <panic>

000000008000267a <fetchaddr>:
{
    8000267a:	1101                	addi	sp,sp,-32
    8000267c:	ec06                	sd	ra,24(sp)
    8000267e:	e822                	sd	s0,16(sp)
    80002680:	e426                	sd	s1,8(sp)
    80002682:	e04a                	sd	s2,0(sp)
    80002684:	1000                	addi	s0,sp,32
    80002686:	84aa                	mv	s1,a0
    80002688:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000268a:	9ceff0ef          	jal	ra,80001858 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    8000268e:	653c                	ld	a5,72(a0)
    80002690:	02f4f663          	bgeu	s1,a5,800026bc <fetchaddr+0x42>
    80002694:	00848713          	addi	a4,s1,8
    80002698:	02e7e463          	bltu	a5,a4,800026c0 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    8000269c:	46a1                	li	a3,8
    8000269e:	8626                	mv	a2,s1
    800026a0:	85ca                	mv	a1,s2
    800026a2:	6928                	ld	a0,80(a0)
    800026a4:	f21fe0ef          	jal	ra,800015c4 <copyin>
    800026a8:	00a03533          	snez	a0,a0
    800026ac:	40a00533          	neg	a0,a0
}
    800026b0:	60e2                	ld	ra,24(sp)
    800026b2:	6442                	ld	s0,16(sp)
    800026b4:	64a2                	ld	s1,8(sp)
    800026b6:	6902                	ld	s2,0(sp)
    800026b8:	6105                	addi	sp,sp,32
    800026ba:	8082                	ret
    return -1;
    800026bc:	557d                	li	a0,-1
    800026be:	bfcd                	j	800026b0 <fetchaddr+0x36>
    800026c0:	557d                	li	a0,-1
    800026c2:	b7fd                	j	800026b0 <fetchaddr+0x36>

00000000800026c4 <fetchstr>:
{
    800026c4:	7179                	addi	sp,sp,-48
    800026c6:	f406                	sd	ra,40(sp)
    800026c8:	f022                	sd	s0,32(sp)
    800026ca:	ec26                	sd	s1,24(sp)
    800026cc:	e84a                	sd	s2,16(sp)
    800026ce:	e44e                	sd	s3,8(sp)
    800026d0:	1800                	addi	s0,sp,48
    800026d2:	892a                	mv	s2,a0
    800026d4:	84ae                	mv	s1,a1
    800026d6:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    800026d8:	980ff0ef          	jal	ra,80001858 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    800026dc:	86ce                	mv	a3,s3
    800026de:	864a                	mv	a2,s2
    800026e0:	85a6                	mv	a1,s1
    800026e2:	6928                	ld	a0,80(a0)
    800026e4:	f67fe0ef          	jal	ra,8000164a <copyinstr>
    800026e8:	00054c63          	bltz	a0,80002700 <fetchstr+0x3c>
  return strlen(buf);
    800026ec:	8526                	mv	a0,s1
    800026ee:	ef8fe0ef          	jal	ra,80000de6 <strlen>
}
    800026f2:	70a2                	ld	ra,40(sp)
    800026f4:	7402                	ld	s0,32(sp)
    800026f6:	64e2                	ld	s1,24(sp)
    800026f8:	6942                	ld	s2,16(sp)
    800026fa:	69a2                	ld	s3,8(sp)
    800026fc:	6145                	addi	sp,sp,48
    800026fe:	8082                	ret
    return -1;
    80002700:	557d                	li	a0,-1
    80002702:	bfc5                	j	800026f2 <fetchstr+0x2e>

0000000080002704 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80002704:	1101                	addi	sp,sp,-32
    80002706:	ec06                	sd	ra,24(sp)
    80002708:	e822                	sd	s0,16(sp)
    8000270a:	e426                	sd	s1,8(sp)
    8000270c:	1000                	addi	s0,sp,32
    8000270e:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002710:	f0bff0ef          	jal	ra,8000261a <argraw>
    80002714:	c088                	sw	a0,0(s1)
}
    80002716:	60e2                	ld	ra,24(sp)
    80002718:	6442                	ld	s0,16(sp)
    8000271a:	64a2                	ld	s1,8(sp)
    8000271c:	6105                	addi	sp,sp,32
    8000271e:	8082                	ret

0000000080002720 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80002720:	1101                	addi	sp,sp,-32
    80002722:	ec06                	sd	ra,24(sp)
    80002724:	e822                	sd	s0,16(sp)
    80002726:	e426                	sd	s1,8(sp)
    80002728:	1000                	addi	s0,sp,32
    8000272a:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000272c:	eefff0ef          	jal	ra,8000261a <argraw>
    80002730:	e088                	sd	a0,0(s1)
}
    80002732:	60e2                	ld	ra,24(sp)
    80002734:	6442                	ld	s0,16(sp)
    80002736:	64a2                	ld	s1,8(sp)
    80002738:	6105                	addi	sp,sp,32
    8000273a:	8082                	ret

000000008000273c <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    8000273c:	7179                	addi	sp,sp,-48
    8000273e:	f406                	sd	ra,40(sp)
    80002740:	f022                	sd	s0,32(sp)
    80002742:	ec26                	sd	s1,24(sp)
    80002744:	e84a                	sd	s2,16(sp)
    80002746:	1800                	addi	s0,sp,48
    80002748:	84ae                	mv	s1,a1
    8000274a:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    8000274c:	fd840593          	addi	a1,s0,-40
    80002750:	fd1ff0ef          	jal	ra,80002720 <argaddr>
  return fetchstr(addr, buf, max);
    80002754:	864a                	mv	a2,s2
    80002756:	85a6                	mv	a1,s1
    80002758:	fd843503          	ld	a0,-40(s0)
    8000275c:	f69ff0ef          	jal	ra,800026c4 <fetchstr>
}
    80002760:	70a2                	ld	ra,40(sp)
    80002762:	7402                	ld	s0,32(sp)
    80002764:	64e2                	ld	s1,24(sp)
    80002766:	6942                	ld	s2,16(sp)
    80002768:	6145                	addi	sp,sp,48
    8000276a:	8082                	ret

000000008000276c <syscall>:
[SYS_printfslab] sys_printfslab,
};

void
syscall(void)
{
    8000276c:	1101                	addi	sp,sp,-32
    8000276e:	ec06                	sd	ra,24(sp)
    80002770:	e822                	sd	s0,16(sp)
    80002772:	e426                	sd	s1,8(sp)
    80002774:	e04a                	sd	s2,0(sp)
    80002776:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002778:	8e0ff0ef          	jal	ra,80001858 <myproc>
    8000277c:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    8000277e:	05853903          	ld	s2,88(a0)
    80002782:	0a893783          	ld	a5,168(s2)
    80002786:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000278a:	37fd                	addiw	a5,a5,-1
    8000278c:	4759                	li	a4,22
    8000278e:	00f76f63          	bltu	a4,a5,800027ac <syscall+0x40>
    80002792:	00369713          	slli	a4,a3,0x3
    80002796:	00005797          	auipc	a5,0x5
    8000279a:	d1278793          	addi	a5,a5,-750 # 800074a8 <syscalls>
    8000279e:	97ba                	add	a5,a5,a4
    800027a0:	639c                	ld	a5,0(a5)
    800027a2:	c789                	beqz	a5,800027ac <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    800027a4:	9782                	jalr	a5
    800027a6:	06a93823          	sd	a0,112(s2)
    800027aa:	a829                	j	800027c4 <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800027ac:	71848613          	addi	a2,s1,1816
    800027b0:	588c                	lw	a1,48(s1)
    800027b2:	00005517          	auipc	a0,0x5
    800027b6:	cbe50513          	addi	a0,a0,-834 # 80007470 <states.0+0x158>
    800027ba:	ce9fd0ef          	jal	ra,800004a2 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800027be:	6cbc                	ld	a5,88(s1)
    800027c0:	577d                	li	a4,-1
    800027c2:	fbb8                	sd	a4,112(a5)
  }
}
    800027c4:	60e2                	ld	ra,24(sp)
    800027c6:	6442                	ld	s0,16(sp)
    800027c8:	64a2                	ld	s1,8(sp)
    800027ca:	6902                	ld	s2,0(sp)
    800027cc:	6105                	addi	sp,sp,32
    800027ce:	8082                	ret

00000000800027d0 <sys_exit>:
#include "proc.h"


uint64
sys_exit(void)
{
    800027d0:	1101                	addi	sp,sp,-32
    800027d2:	ec06                	sd	ra,24(sp)
    800027d4:	e822                	sd	s0,16(sp)
    800027d6:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    800027d8:	fec40593          	addi	a1,s0,-20
    800027dc:	4501                	li	a0,0
    800027de:	f27ff0ef          	jal	ra,80002704 <argint>
  exit(n);
    800027e2:	fec42503          	lw	a0,-20(s0)
    800027e6:	f4aff0ef          	jal	ra,80001f30 <exit>
  return 0;  // not reached
}
    800027ea:	4501                	li	a0,0
    800027ec:	60e2                	ld	ra,24(sp)
    800027ee:	6442                	ld	s0,16(sp)
    800027f0:	6105                	addi	sp,sp,32
    800027f2:	8082                	ret

00000000800027f4 <sys_getpid>:

uint64
sys_getpid(void)
{
    800027f4:	1141                	addi	sp,sp,-16
    800027f6:	e406                	sd	ra,8(sp)
    800027f8:	e022                	sd	s0,0(sp)
    800027fa:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800027fc:	85cff0ef          	jal	ra,80001858 <myproc>
}
    80002800:	5908                	lw	a0,48(a0)
    80002802:	60a2                	ld	ra,8(sp)
    80002804:	6402                	ld	s0,0(sp)
    80002806:	0141                	addi	sp,sp,16
    80002808:	8082                	ret

000000008000280a <sys_fork>:

uint64
sys_fork(void)
{
    8000280a:	1141                	addi	sp,sp,-16
    8000280c:	e406                	sd	ra,8(sp)
    8000280e:	e022                	sd	s0,0(sp)
    80002810:	0800                	addi	s0,sp,16
  return fork();
    80002812:	b6cff0ef          	jal	ra,80001b7e <fork>
}
    80002816:	60a2                	ld	ra,8(sp)
    80002818:	6402                	ld	s0,0(sp)
    8000281a:	0141                	addi	sp,sp,16
    8000281c:	8082                	ret

000000008000281e <sys_wait>:

uint64
sys_wait(void)
{
    8000281e:	1101                	addi	sp,sp,-32
    80002820:	ec06                	sd	ra,24(sp)
    80002822:	e822                	sd	s0,16(sp)
    80002824:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002826:	fe840593          	addi	a1,s0,-24
    8000282a:	4501                	li	a0,0
    8000282c:	ef5ff0ef          	jal	ra,80002720 <argaddr>
  return wait(p);
    80002830:	fe843503          	ld	a0,-24(s0)
    80002834:	853ff0ef          	jal	ra,80002086 <wait>
}
    80002838:	60e2                	ld	ra,24(sp)
    8000283a:	6442                	ld	s0,16(sp)
    8000283c:	6105                	addi	sp,sp,32
    8000283e:	8082                	ret

0000000080002840 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002840:	7179                	addi	sp,sp,-48
    80002842:	f406                	sd	ra,40(sp)
    80002844:	f022                	sd	s0,32(sp)
    80002846:	ec26                	sd	s1,24(sp)
    80002848:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    8000284a:	fdc40593          	addi	a1,s0,-36
    8000284e:	4501                	li	a0,0
    80002850:	eb5ff0ef          	jal	ra,80002704 <argint>
  addr = myproc()->sz;
    80002854:	804ff0ef          	jal	ra,80001858 <myproc>
    80002858:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    8000285a:	fdc42503          	lw	a0,-36(s0)
    8000285e:	ad0ff0ef          	jal	ra,80001b2e <growproc>
    80002862:	00054863          	bltz	a0,80002872 <sys_sbrk+0x32>
    return -1;
  return addr;
}
    80002866:	8526                	mv	a0,s1
    80002868:	70a2                	ld	ra,40(sp)
    8000286a:	7402                	ld	s0,32(sp)
    8000286c:	64e2                	ld	s1,24(sp)
    8000286e:	6145                	addi	sp,sp,48
    80002870:	8082                	ret
    return -1;
    80002872:	54fd                	li	s1,-1
    80002874:	bfcd                	j	80002866 <sys_sbrk+0x26>

0000000080002876 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002876:	7139                	addi	sp,sp,-64
    80002878:	fc06                	sd	ra,56(sp)
    8000287a:	f822                	sd	s0,48(sp)
    8000287c:	f426                	sd	s1,40(sp)
    8000287e:	f04a                	sd	s2,32(sp)
    80002880:	ec4e                	sd	s3,24(sp)
    80002882:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002884:	fcc40593          	addi	a1,s0,-52
    80002888:	4501                	li	a0,0
    8000288a:	e7bff0ef          	jal	ra,80002704 <argint>
  if(n < 0)
    8000288e:	fcc42783          	lw	a5,-52(s0)
    80002892:	0607c563          	bltz	a5,800028fc <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    80002896:	0002a517          	auipc	a0,0x2a
    8000289a:	37a50513          	addi	a0,a0,890 # 8002cc10 <tickslock>
    8000289e:	afcfe0ef          	jal	ra,80000b9a <acquire>
  ticks0 = ticks;
    800028a2:	00005917          	auipc	s2,0x5
    800028a6:	40e92903          	lw	s2,1038(s2) # 80007cb0 <ticks>
  while(ticks - ticks0 < n){
    800028aa:	fcc42783          	lw	a5,-52(s0)
    800028ae:	cb8d                	beqz	a5,800028e0 <sys_sleep+0x6a>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800028b0:	0002a997          	auipc	s3,0x2a
    800028b4:	36098993          	addi	s3,s3,864 # 8002cc10 <tickslock>
    800028b8:	00005497          	auipc	s1,0x5
    800028bc:	3f848493          	addi	s1,s1,1016 # 80007cb0 <ticks>
    if(killed(myproc())){
    800028c0:	f99fe0ef          	jal	ra,80001858 <myproc>
    800028c4:	f98ff0ef          	jal	ra,8000205c <killed>
    800028c8:	ed0d                	bnez	a0,80002902 <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    800028ca:	85ce                	mv	a1,s3
    800028cc:	8526                	mv	a0,s1
    800028ce:	d56ff0ef          	jal	ra,80001e24 <sleep>
  while(ticks - ticks0 < n){
    800028d2:	409c                	lw	a5,0(s1)
    800028d4:	412787bb          	subw	a5,a5,s2
    800028d8:	fcc42703          	lw	a4,-52(s0)
    800028dc:	fee7e2e3          	bltu	a5,a4,800028c0 <sys_sleep+0x4a>
  }
  release(&tickslock);
    800028e0:	0002a517          	auipc	a0,0x2a
    800028e4:	33050513          	addi	a0,a0,816 # 8002cc10 <tickslock>
    800028e8:	b4afe0ef          	jal	ra,80000c32 <release>
  return 0;
    800028ec:	4501                	li	a0,0
}
    800028ee:	70e2                	ld	ra,56(sp)
    800028f0:	7442                	ld	s0,48(sp)
    800028f2:	74a2                	ld	s1,40(sp)
    800028f4:	7902                	ld	s2,32(sp)
    800028f6:	69e2                	ld	s3,24(sp)
    800028f8:	6121                	addi	sp,sp,64
    800028fa:	8082                	ret
    n = 0;
    800028fc:	fc042623          	sw	zero,-52(s0)
    80002900:	bf59                	j	80002896 <sys_sleep+0x20>
      release(&tickslock);
    80002902:	0002a517          	auipc	a0,0x2a
    80002906:	30e50513          	addi	a0,a0,782 # 8002cc10 <tickslock>
    8000290a:	b28fe0ef          	jal	ra,80000c32 <release>
      return -1;
    8000290e:	557d                	li	a0,-1
    80002910:	bff9                	j	800028ee <sys_sleep+0x78>

0000000080002912 <sys_kill>:

uint64
sys_kill(void)
{
    80002912:	1101                	addi	sp,sp,-32
    80002914:	ec06                	sd	ra,24(sp)
    80002916:	e822                	sd	s0,16(sp)
    80002918:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    8000291a:	fec40593          	addi	a1,s0,-20
    8000291e:	4501                	li	a0,0
    80002920:	de5ff0ef          	jal	ra,80002704 <argint>
  return kill(pid);
    80002924:	fec42503          	lw	a0,-20(s0)
    80002928:	eaaff0ef          	jal	ra,80001fd2 <kill>
}
    8000292c:	60e2                	ld	ra,24(sp)
    8000292e:	6442                	ld	s0,16(sp)
    80002930:	6105                	addi	sp,sp,32
    80002932:	8082                	ret

0000000080002934 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002934:	1101                	addi	sp,sp,-32
    80002936:	ec06                	sd	ra,24(sp)
    80002938:	e822                	sd	s0,16(sp)
    8000293a:	e426                	sd	s1,8(sp)
    8000293c:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    8000293e:	0002a517          	auipc	a0,0x2a
    80002942:	2d250513          	addi	a0,a0,722 # 8002cc10 <tickslock>
    80002946:	a54fe0ef          	jal	ra,80000b9a <acquire>
  xticks = ticks;
    8000294a:	00005497          	auipc	s1,0x5
    8000294e:	3664a483          	lw	s1,870(s1) # 80007cb0 <ticks>
  release(&tickslock);
    80002952:	0002a517          	auipc	a0,0x2a
    80002956:	2be50513          	addi	a0,a0,702 # 8002cc10 <tickslock>
    8000295a:	ad8fe0ef          	jal	ra,80000c32 <release>
  return xticks;
}
    8000295e:	02049513          	slli	a0,s1,0x20
    80002962:	9101                	srli	a0,a0,0x20
    80002964:	60e2                	ld	ra,24(sp)
    80002966:	6442                	ld	s0,16(sp)
    80002968:	64a2                	ld	s1,8(sp)
    8000296a:	6105                	addi	sp,sp,32
    8000296c:	8082                	ret

000000008000296e <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000296e:	7179                	addi	sp,sp,-48
    80002970:	f406                	sd	ra,40(sp)
    80002972:	f022                	sd	s0,32(sp)
    80002974:	ec26                	sd	s1,24(sp)
    80002976:	e84a                	sd	s2,16(sp)
    80002978:	e44e                	sd	s3,8(sp)
    8000297a:	e052                	sd	s4,0(sp)
    8000297c:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000297e:	00005597          	auipc	a1,0x5
    80002982:	bea58593          	addi	a1,a1,-1046 # 80007568 <syscalls+0xc0>
    80002986:	0002a517          	auipc	a0,0x2a
    8000298a:	2a250513          	addi	a0,a0,674 # 8002cc28 <bcache>
    8000298e:	98cfe0ef          	jal	ra,80000b1a <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002992:	00032797          	auipc	a5,0x32
    80002996:	29678793          	addi	a5,a5,662 # 80034c28 <bcache+0x8000>
    8000299a:	00032717          	auipc	a4,0x32
    8000299e:	4f670713          	addi	a4,a4,1270 # 80034e90 <bcache+0x8268>
    800029a2:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800029a6:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800029aa:	0002a497          	auipc	s1,0x2a
    800029ae:	29648493          	addi	s1,s1,662 # 8002cc40 <bcache+0x18>
    b->next = bcache.head.next;
    800029b2:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800029b4:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800029b6:	00005a17          	auipc	s4,0x5
    800029ba:	bbaa0a13          	addi	s4,s4,-1094 # 80007570 <syscalls+0xc8>
    b->next = bcache.head.next;
    800029be:	2b893783          	ld	a5,696(s2)
    800029c2:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800029c4:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800029c8:	85d2                	mv	a1,s4
    800029ca:	01048513          	addi	a0,s1,16
    800029ce:	224010ef          	jal	ra,80003bf2 <initsleeplock>
    bcache.head.next->prev = b;
    800029d2:	2b893783          	ld	a5,696(s2)
    800029d6:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800029d8:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800029dc:	45848493          	addi	s1,s1,1112
    800029e0:	fd349fe3          	bne	s1,s3,800029be <binit+0x50>
  }
}
    800029e4:	70a2                	ld	ra,40(sp)
    800029e6:	7402                	ld	s0,32(sp)
    800029e8:	64e2                	ld	s1,24(sp)
    800029ea:	6942                	ld	s2,16(sp)
    800029ec:	69a2                	ld	s3,8(sp)
    800029ee:	6a02                	ld	s4,0(sp)
    800029f0:	6145                	addi	sp,sp,48
    800029f2:	8082                	ret

00000000800029f4 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800029f4:	7179                	addi	sp,sp,-48
    800029f6:	f406                	sd	ra,40(sp)
    800029f8:	f022                	sd	s0,32(sp)
    800029fa:	ec26                	sd	s1,24(sp)
    800029fc:	e84a                	sd	s2,16(sp)
    800029fe:	e44e                	sd	s3,8(sp)
    80002a00:	1800                	addi	s0,sp,48
    80002a02:	892a                	mv	s2,a0
    80002a04:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002a06:	0002a517          	auipc	a0,0x2a
    80002a0a:	22250513          	addi	a0,a0,546 # 8002cc28 <bcache>
    80002a0e:	98cfe0ef          	jal	ra,80000b9a <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002a12:	00032497          	auipc	s1,0x32
    80002a16:	4ce4b483          	ld	s1,1230(s1) # 80034ee0 <bcache+0x82b8>
    80002a1a:	00032797          	auipc	a5,0x32
    80002a1e:	47678793          	addi	a5,a5,1142 # 80034e90 <bcache+0x8268>
    80002a22:	02f48b63          	beq	s1,a5,80002a58 <bread+0x64>
    80002a26:	873e                	mv	a4,a5
    80002a28:	a021                	j	80002a30 <bread+0x3c>
    80002a2a:	68a4                	ld	s1,80(s1)
    80002a2c:	02e48663          	beq	s1,a4,80002a58 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80002a30:	449c                	lw	a5,8(s1)
    80002a32:	ff279ce3          	bne	a5,s2,80002a2a <bread+0x36>
    80002a36:	44dc                	lw	a5,12(s1)
    80002a38:	ff3799e3          	bne	a5,s3,80002a2a <bread+0x36>
      b->refcnt++;
    80002a3c:	40bc                	lw	a5,64(s1)
    80002a3e:	2785                	addiw	a5,a5,1
    80002a40:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002a42:	0002a517          	auipc	a0,0x2a
    80002a46:	1e650513          	addi	a0,a0,486 # 8002cc28 <bcache>
    80002a4a:	9e8fe0ef          	jal	ra,80000c32 <release>
      acquiresleep(&b->lock);
    80002a4e:	01048513          	addi	a0,s1,16
    80002a52:	1d6010ef          	jal	ra,80003c28 <acquiresleep>
      return b;
    80002a56:	a889                	j	80002aa8 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002a58:	00032497          	auipc	s1,0x32
    80002a5c:	4804b483          	ld	s1,1152(s1) # 80034ed8 <bcache+0x82b0>
    80002a60:	00032797          	auipc	a5,0x32
    80002a64:	43078793          	addi	a5,a5,1072 # 80034e90 <bcache+0x8268>
    80002a68:	00f48863          	beq	s1,a5,80002a78 <bread+0x84>
    80002a6c:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002a6e:	40bc                	lw	a5,64(s1)
    80002a70:	cb91                	beqz	a5,80002a84 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002a72:	64a4                	ld	s1,72(s1)
    80002a74:	fee49de3          	bne	s1,a4,80002a6e <bread+0x7a>
  panic("bget: no buffers");
    80002a78:	00005517          	auipc	a0,0x5
    80002a7c:	b0050513          	addi	a0,a0,-1280 # 80007578 <syscalls+0xd0>
    80002a80:	cd7fd0ef          	jal	ra,80000756 <panic>
      b->dev = dev;
    80002a84:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002a88:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002a8c:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002a90:	4785                	li	a5,1
    80002a92:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002a94:	0002a517          	auipc	a0,0x2a
    80002a98:	19450513          	addi	a0,a0,404 # 8002cc28 <bcache>
    80002a9c:	996fe0ef          	jal	ra,80000c32 <release>
      acquiresleep(&b->lock);
    80002aa0:	01048513          	addi	a0,s1,16
    80002aa4:	184010ef          	jal	ra,80003c28 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002aa8:	409c                	lw	a5,0(s1)
    80002aaa:	cb89                	beqz	a5,80002abc <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002aac:	8526                	mv	a0,s1
    80002aae:	70a2                	ld	ra,40(sp)
    80002ab0:	7402                	ld	s0,32(sp)
    80002ab2:	64e2                	ld	s1,24(sp)
    80002ab4:	6942                	ld	s2,16(sp)
    80002ab6:	69a2                	ld	s3,8(sp)
    80002ab8:	6145                	addi	sp,sp,48
    80002aba:	8082                	ret
    virtio_disk_rw(b, 0);
    80002abc:	4581                	li	a1,0
    80002abe:	8526                	mv	a0,s1
    80002ac0:	1ad020ef          	jal	ra,8000546c <virtio_disk_rw>
    b->valid = 1;
    80002ac4:	4785                	li	a5,1
    80002ac6:	c09c                	sw	a5,0(s1)
  return b;
    80002ac8:	b7d5                	j	80002aac <bread+0xb8>

0000000080002aca <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002aca:	1101                	addi	sp,sp,-32
    80002acc:	ec06                	sd	ra,24(sp)
    80002ace:	e822                	sd	s0,16(sp)
    80002ad0:	e426                	sd	s1,8(sp)
    80002ad2:	1000                	addi	s0,sp,32
    80002ad4:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002ad6:	0541                	addi	a0,a0,16
    80002ad8:	1ce010ef          	jal	ra,80003ca6 <holdingsleep>
    80002adc:	c911                	beqz	a0,80002af0 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002ade:	4585                	li	a1,1
    80002ae0:	8526                	mv	a0,s1
    80002ae2:	18b020ef          	jal	ra,8000546c <virtio_disk_rw>
}
    80002ae6:	60e2                	ld	ra,24(sp)
    80002ae8:	6442                	ld	s0,16(sp)
    80002aea:	64a2                	ld	s1,8(sp)
    80002aec:	6105                	addi	sp,sp,32
    80002aee:	8082                	ret
    panic("bwrite");
    80002af0:	00005517          	auipc	a0,0x5
    80002af4:	aa050513          	addi	a0,a0,-1376 # 80007590 <syscalls+0xe8>
    80002af8:	c5ffd0ef          	jal	ra,80000756 <panic>

0000000080002afc <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002afc:	1101                	addi	sp,sp,-32
    80002afe:	ec06                	sd	ra,24(sp)
    80002b00:	e822                	sd	s0,16(sp)
    80002b02:	e426                	sd	s1,8(sp)
    80002b04:	e04a                	sd	s2,0(sp)
    80002b06:	1000                	addi	s0,sp,32
    80002b08:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002b0a:	01050913          	addi	s2,a0,16
    80002b0e:	854a                	mv	a0,s2
    80002b10:	196010ef          	jal	ra,80003ca6 <holdingsleep>
    80002b14:	c13d                	beqz	a0,80002b7a <brelse+0x7e>
    panic("brelse");

  releasesleep(&b->lock);
    80002b16:	854a                	mv	a0,s2
    80002b18:	156010ef          	jal	ra,80003c6e <releasesleep>

  acquire(&bcache.lock);
    80002b1c:	0002a517          	auipc	a0,0x2a
    80002b20:	10c50513          	addi	a0,a0,268 # 8002cc28 <bcache>
    80002b24:	876fe0ef          	jal	ra,80000b9a <acquire>
  b->refcnt--;
    80002b28:	40bc                	lw	a5,64(s1)
    80002b2a:	37fd                	addiw	a5,a5,-1
    80002b2c:	0007871b          	sext.w	a4,a5
    80002b30:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002b32:	eb05                	bnez	a4,80002b62 <brelse+0x66>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002b34:	68bc                	ld	a5,80(s1)
    80002b36:	64b8                	ld	a4,72(s1)
    80002b38:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002b3a:	64bc                	ld	a5,72(s1)
    80002b3c:	68b8                	ld	a4,80(s1)
    80002b3e:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002b40:	00032797          	auipc	a5,0x32
    80002b44:	0e878793          	addi	a5,a5,232 # 80034c28 <bcache+0x8000>
    80002b48:	2b87b703          	ld	a4,696(a5)
    80002b4c:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002b4e:	00032717          	auipc	a4,0x32
    80002b52:	34270713          	addi	a4,a4,834 # 80034e90 <bcache+0x8268>
    80002b56:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002b58:	2b87b703          	ld	a4,696(a5)
    80002b5c:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002b5e:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002b62:	0002a517          	auipc	a0,0x2a
    80002b66:	0c650513          	addi	a0,a0,198 # 8002cc28 <bcache>
    80002b6a:	8c8fe0ef          	jal	ra,80000c32 <release>
}
    80002b6e:	60e2                	ld	ra,24(sp)
    80002b70:	6442                	ld	s0,16(sp)
    80002b72:	64a2                	ld	s1,8(sp)
    80002b74:	6902                	ld	s2,0(sp)
    80002b76:	6105                	addi	sp,sp,32
    80002b78:	8082                	ret
    panic("brelse");
    80002b7a:	00005517          	auipc	a0,0x5
    80002b7e:	a1e50513          	addi	a0,a0,-1506 # 80007598 <syscalls+0xf0>
    80002b82:	bd5fd0ef          	jal	ra,80000756 <panic>

0000000080002b86 <bpin>:

void
bpin(struct buf *b) {
    80002b86:	1101                	addi	sp,sp,-32
    80002b88:	ec06                	sd	ra,24(sp)
    80002b8a:	e822                	sd	s0,16(sp)
    80002b8c:	e426                	sd	s1,8(sp)
    80002b8e:	1000                	addi	s0,sp,32
    80002b90:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002b92:	0002a517          	auipc	a0,0x2a
    80002b96:	09650513          	addi	a0,a0,150 # 8002cc28 <bcache>
    80002b9a:	800fe0ef          	jal	ra,80000b9a <acquire>
  b->refcnt++;
    80002b9e:	40bc                	lw	a5,64(s1)
    80002ba0:	2785                	addiw	a5,a5,1
    80002ba2:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002ba4:	0002a517          	auipc	a0,0x2a
    80002ba8:	08450513          	addi	a0,a0,132 # 8002cc28 <bcache>
    80002bac:	886fe0ef          	jal	ra,80000c32 <release>
}
    80002bb0:	60e2                	ld	ra,24(sp)
    80002bb2:	6442                	ld	s0,16(sp)
    80002bb4:	64a2                	ld	s1,8(sp)
    80002bb6:	6105                	addi	sp,sp,32
    80002bb8:	8082                	ret

0000000080002bba <bunpin>:

void
bunpin(struct buf *b) {
    80002bba:	1101                	addi	sp,sp,-32
    80002bbc:	ec06                	sd	ra,24(sp)
    80002bbe:	e822                	sd	s0,16(sp)
    80002bc0:	e426                	sd	s1,8(sp)
    80002bc2:	1000                	addi	s0,sp,32
    80002bc4:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002bc6:	0002a517          	auipc	a0,0x2a
    80002bca:	06250513          	addi	a0,a0,98 # 8002cc28 <bcache>
    80002bce:	fcdfd0ef          	jal	ra,80000b9a <acquire>
  b->refcnt--;
    80002bd2:	40bc                	lw	a5,64(s1)
    80002bd4:	37fd                	addiw	a5,a5,-1
    80002bd6:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002bd8:	0002a517          	auipc	a0,0x2a
    80002bdc:	05050513          	addi	a0,a0,80 # 8002cc28 <bcache>
    80002be0:	852fe0ef          	jal	ra,80000c32 <release>
}
    80002be4:	60e2                	ld	ra,24(sp)
    80002be6:	6442                	ld	s0,16(sp)
    80002be8:	64a2                	ld	s1,8(sp)
    80002bea:	6105                	addi	sp,sp,32
    80002bec:	8082                	ret

0000000080002bee <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002bee:	1101                	addi	sp,sp,-32
    80002bf0:	ec06                	sd	ra,24(sp)
    80002bf2:	e822                	sd	s0,16(sp)
    80002bf4:	e426                	sd	s1,8(sp)
    80002bf6:	e04a                	sd	s2,0(sp)
    80002bf8:	1000                	addi	s0,sp,32
    80002bfa:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002bfc:	00d5d59b          	srliw	a1,a1,0xd
    80002c00:	00032797          	auipc	a5,0x32
    80002c04:	7047a783          	lw	a5,1796(a5) # 80035304 <sb+0x1c>
    80002c08:	9dbd                	addw	a1,a1,a5
    80002c0a:	debff0ef          	jal	ra,800029f4 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002c0e:	0074f713          	andi	a4,s1,7
    80002c12:	4785                	li	a5,1
    80002c14:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002c18:	14ce                	slli	s1,s1,0x33
    80002c1a:	90d9                	srli	s1,s1,0x36
    80002c1c:	00950733          	add	a4,a0,s1
    80002c20:	05874703          	lbu	a4,88(a4)
    80002c24:	00e7f6b3          	and	a3,a5,a4
    80002c28:	c29d                	beqz	a3,80002c4e <bfree+0x60>
    80002c2a:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002c2c:	94aa                	add	s1,s1,a0
    80002c2e:	fff7c793          	not	a5,a5
    80002c32:	8ff9                	and	a5,a5,a4
    80002c34:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    80002c38:	6e9000ef          	jal	ra,80003b20 <log_write>
  brelse(bp);
    80002c3c:	854a                	mv	a0,s2
    80002c3e:	ebfff0ef          	jal	ra,80002afc <brelse>
}
    80002c42:	60e2                	ld	ra,24(sp)
    80002c44:	6442                	ld	s0,16(sp)
    80002c46:	64a2                	ld	s1,8(sp)
    80002c48:	6902                	ld	s2,0(sp)
    80002c4a:	6105                	addi	sp,sp,32
    80002c4c:	8082                	ret
    panic("freeing free block");
    80002c4e:	00005517          	auipc	a0,0x5
    80002c52:	95250513          	addi	a0,a0,-1710 # 800075a0 <syscalls+0xf8>
    80002c56:	b01fd0ef          	jal	ra,80000756 <panic>

0000000080002c5a <balloc>:
{
    80002c5a:	711d                	addi	sp,sp,-96
    80002c5c:	ec86                	sd	ra,88(sp)
    80002c5e:	e8a2                	sd	s0,80(sp)
    80002c60:	e4a6                	sd	s1,72(sp)
    80002c62:	e0ca                	sd	s2,64(sp)
    80002c64:	fc4e                	sd	s3,56(sp)
    80002c66:	f852                	sd	s4,48(sp)
    80002c68:	f456                	sd	s5,40(sp)
    80002c6a:	f05a                	sd	s6,32(sp)
    80002c6c:	ec5e                	sd	s7,24(sp)
    80002c6e:	e862                	sd	s8,16(sp)
    80002c70:	e466                	sd	s9,8(sp)
    80002c72:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002c74:	00032797          	auipc	a5,0x32
    80002c78:	6787a783          	lw	a5,1656(a5) # 800352ec <sb+0x4>
    80002c7c:	0e078163          	beqz	a5,80002d5e <balloc+0x104>
    80002c80:	8baa                	mv	s7,a0
    80002c82:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002c84:	00032b17          	auipc	s6,0x32
    80002c88:	664b0b13          	addi	s6,s6,1636 # 800352e8 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002c8c:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002c8e:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002c90:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002c92:	6c89                	lui	s9,0x2
    80002c94:	a0b5                	j	80002d00 <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002c96:	974a                	add	a4,a4,s2
    80002c98:	8fd5                	or	a5,a5,a3
    80002c9a:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    80002c9e:	854a                	mv	a0,s2
    80002ca0:	681000ef          	jal	ra,80003b20 <log_write>
        brelse(bp);
    80002ca4:	854a                	mv	a0,s2
    80002ca6:	e57ff0ef          	jal	ra,80002afc <brelse>
  bp = bread(dev, bno);
    80002caa:	85a6                	mv	a1,s1
    80002cac:	855e                	mv	a0,s7
    80002cae:	d47ff0ef          	jal	ra,800029f4 <bread>
    80002cb2:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002cb4:	40000613          	li	a2,1024
    80002cb8:	4581                	li	a1,0
    80002cba:	05850513          	addi	a0,a0,88
    80002cbe:	fb1fd0ef          	jal	ra,80000c6e <memset>
  log_write(bp);
    80002cc2:	854a                	mv	a0,s2
    80002cc4:	65d000ef          	jal	ra,80003b20 <log_write>
  brelse(bp);
    80002cc8:	854a                	mv	a0,s2
    80002cca:	e33ff0ef          	jal	ra,80002afc <brelse>
}
    80002cce:	8526                	mv	a0,s1
    80002cd0:	60e6                	ld	ra,88(sp)
    80002cd2:	6446                	ld	s0,80(sp)
    80002cd4:	64a6                	ld	s1,72(sp)
    80002cd6:	6906                	ld	s2,64(sp)
    80002cd8:	79e2                	ld	s3,56(sp)
    80002cda:	7a42                	ld	s4,48(sp)
    80002cdc:	7aa2                	ld	s5,40(sp)
    80002cde:	7b02                	ld	s6,32(sp)
    80002ce0:	6be2                	ld	s7,24(sp)
    80002ce2:	6c42                	ld	s8,16(sp)
    80002ce4:	6ca2                	ld	s9,8(sp)
    80002ce6:	6125                	addi	sp,sp,96
    80002ce8:	8082                	ret
    brelse(bp);
    80002cea:	854a                	mv	a0,s2
    80002cec:	e11ff0ef          	jal	ra,80002afc <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002cf0:	015c87bb          	addw	a5,s9,s5
    80002cf4:	00078a9b          	sext.w	s5,a5
    80002cf8:	004b2703          	lw	a4,4(s6)
    80002cfc:	06eaf163          	bgeu	s5,a4,80002d5e <balloc+0x104>
    bp = bread(dev, BBLOCK(b, sb));
    80002d00:	41fad79b          	sraiw	a5,s5,0x1f
    80002d04:	0137d79b          	srliw	a5,a5,0x13
    80002d08:	015787bb          	addw	a5,a5,s5
    80002d0c:	40d7d79b          	sraiw	a5,a5,0xd
    80002d10:	01cb2583          	lw	a1,28(s6)
    80002d14:	9dbd                	addw	a1,a1,a5
    80002d16:	855e                	mv	a0,s7
    80002d18:	cddff0ef          	jal	ra,800029f4 <bread>
    80002d1c:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002d1e:	004b2503          	lw	a0,4(s6)
    80002d22:	000a849b          	sext.w	s1,s5
    80002d26:	8662                	mv	a2,s8
    80002d28:	fca4f1e3          	bgeu	s1,a0,80002cea <balloc+0x90>
      m = 1 << (bi % 8);
    80002d2c:	41f6579b          	sraiw	a5,a2,0x1f
    80002d30:	01d7d69b          	srliw	a3,a5,0x1d
    80002d34:	00c6873b          	addw	a4,a3,a2
    80002d38:	00777793          	andi	a5,a4,7
    80002d3c:	9f95                	subw	a5,a5,a3
    80002d3e:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002d42:	4037571b          	sraiw	a4,a4,0x3
    80002d46:	00e906b3          	add	a3,s2,a4
    80002d4a:	0586c683          	lbu	a3,88(a3)
    80002d4e:	00d7f5b3          	and	a1,a5,a3
    80002d52:	d1b1                	beqz	a1,80002c96 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002d54:	2605                	addiw	a2,a2,1
    80002d56:	2485                	addiw	s1,s1,1
    80002d58:	fd4618e3          	bne	a2,s4,80002d28 <balloc+0xce>
    80002d5c:	b779                	j	80002cea <balloc+0x90>
  printf("balloc: out of blocks\n");
    80002d5e:	00005517          	auipc	a0,0x5
    80002d62:	85a50513          	addi	a0,a0,-1958 # 800075b8 <syscalls+0x110>
    80002d66:	f3cfd0ef          	jal	ra,800004a2 <printf>
  return 0;
    80002d6a:	4481                	li	s1,0
    80002d6c:	b78d                	j	80002cce <balloc+0x74>

0000000080002d6e <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002d6e:	7179                	addi	sp,sp,-48
    80002d70:	f406                	sd	ra,40(sp)
    80002d72:	f022                	sd	s0,32(sp)
    80002d74:	ec26                	sd	s1,24(sp)
    80002d76:	e84a                	sd	s2,16(sp)
    80002d78:	e44e                	sd	s3,8(sp)
    80002d7a:	e052                	sd	s4,0(sp)
    80002d7c:	1800                	addi	s0,sp,48
    80002d7e:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002d80:	47ad                	li	a5,11
    80002d82:	02b7e563          	bltu	a5,a1,80002dac <bmap+0x3e>
    if((addr = ip->addrs[bn]) == 0){
    80002d86:	02059493          	slli	s1,a1,0x20
    80002d8a:	9081                	srli	s1,s1,0x20
    80002d8c:	048a                	slli	s1,s1,0x2
    80002d8e:	94aa                	add	s1,s1,a0
    80002d90:	0504a903          	lw	s2,80(s1)
    80002d94:	06091663          	bnez	s2,80002e00 <bmap+0x92>
      addr = balloc(ip->dev);
    80002d98:	4108                	lw	a0,0(a0)
    80002d9a:	ec1ff0ef          	jal	ra,80002c5a <balloc>
    80002d9e:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002da2:	04090f63          	beqz	s2,80002e00 <bmap+0x92>
        return 0;
      ip->addrs[bn] = addr;
    80002da6:	0524a823          	sw	s2,80(s1)
    80002daa:	a899                	j	80002e00 <bmap+0x92>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002dac:	ff45849b          	addiw	s1,a1,-12
    80002db0:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002db4:	0ff00793          	li	a5,255
    80002db8:	06e7eb63          	bltu	a5,a4,80002e2e <bmap+0xc0>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002dbc:	08052903          	lw	s2,128(a0)
    80002dc0:	00091b63          	bnez	s2,80002dd6 <bmap+0x68>
      addr = balloc(ip->dev);
    80002dc4:	4108                	lw	a0,0(a0)
    80002dc6:	e95ff0ef          	jal	ra,80002c5a <balloc>
    80002dca:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002dce:	02090963          	beqz	s2,80002e00 <bmap+0x92>
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002dd2:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    80002dd6:	85ca                	mv	a1,s2
    80002dd8:	0009a503          	lw	a0,0(s3)
    80002ddc:	c19ff0ef          	jal	ra,800029f4 <bread>
    80002de0:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002de2:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002de6:	02049593          	slli	a1,s1,0x20
    80002dea:	9181                	srli	a1,a1,0x20
    80002dec:	058a                	slli	a1,a1,0x2
    80002dee:	00b784b3          	add	s1,a5,a1
    80002df2:	0004a903          	lw	s2,0(s1)
    80002df6:	00090e63          	beqz	s2,80002e12 <bmap+0xa4>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002dfa:	8552                	mv	a0,s4
    80002dfc:	d01ff0ef          	jal	ra,80002afc <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002e00:	854a                	mv	a0,s2
    80002e02:	70a2                	ld	ra,40(sp)
    80002e04:	7402                	ld	s0,32(sp)
    80002e06:	64e2                	ld	s1,24(sp)
    80002e08:	6942                	ld	s2,16(sp)
    80002e0a:	69a2                	ld	s3,8(sp)
    80002e0c:	6a02                	ld	s4,0(sp)
    80002e0e:	6145                	addi	sp,sp,48
    80002e10:	8082                	ret
      addr = balloc(ip->dev);
    80002e12:	0009a503          	lw	a0,0(s3)
    80002e16:	e45ff0ef          	jal	ra,80002c5a <balloc>
    80002e1a:	0005091b          	sext.w	s2,a0
      if(addr){
    80002e1e:	fc090ee3          	beqz	s2,80002dfa <bmap+0x8c>
        a[bn] = addr;
    80002e22:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002e26:	8552                	mv	a0,s4
    80002e28:	4f9000ef          	jal	ra,80003b20 <log_write>
    80002e2c:	b7f9                	j	80002dfa <bmap+0x8c>
  panic("bmap: out of range");
    80002e2e:	00004517          	auipc	a0,0x4
    80002e32:	7a250513          	addi	a0,a0,1954 # 800075d0 <syscalls+0x128>
    80002e36:	921fd0ef          	jal	ra,80000756 <panic>

0000000080002e3a <iget>:
{
    80002e3a:	7179                	addi	sp,sp,-48
    80002e3c:	f406                	sd	ra,40(sp)
    80002e3e:	f022                	sd	s0,32(sp)
    80002e40:	ec26                	sd	s1,24(sp)
    80002e42:	e84a                	sd	s2,16(sp)
    80002e44:	e44e                	sd	s3,8(sp)
    80002e46:	e052                	sd	s4,0(sp)
    80002e48:	1800                	addi	s0,sp,48
    80002e4a:	89aa                	mv	s3,a0
    80002e4c:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002e4e:	00032517          	auipc	a0,0x32
    80002e52:	4ba50513          	addi	a0,a0,1210 # 80035308 <itable>
    80002e56:	d45fd0ef          	jal	ra,80000b9a <acquire>
  empty = 0;
    80002e5a:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002e5c:	00032497          	auipc	s1,0x32
    80002e60:	4c448493          	addi	s1,s1,1220 # 80035320 <itable+0x18>
    80002e64:	00039697          	auipc	a3,0x39
    80002e68:	efc68693          	addi	a3,a3,-260 # 8003bd60 <log>
    80002e6c:	a039                	j	80002e7a <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002e6e:	04090063          	beqz	s2,80002eae <iget+0x74>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002e72:	08848493          	addi	s1,s1,136
    80002e76:	02d48f63          	beq	s1,a3,80002eb4 <iget+0x7a>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002e7a:	449c                	lw	a5,8(s1)
    80002e7c:	fef059e3          	blez	a5,80002e6e <iget+0x34>
    80002e80:	4098                	lw	a4,0(s1)
    80002e82:	ff3716e3          	bne	a4,s3,80002e6e <iget+0x34>
    80002e86:	40d8                	lw	a4,4(s1)
    80002e88:	ff4713e3          	bne	a4,s4,80002e6e <iget+0x34>
      ip->ref++;
    80002e8c:	2785                	addiw	a5,a5,1
    80002e8e:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002e90:	00032517          	auipc	a0,0x32
    80002e94:	47850513          	addi	a0,a0,1144 # 80035308 <itable>
    80002e98:	d9bfd0ef          	jal	ra,80000c32 <release>
}
    80002e9c:	8526                	mv	a0,s1
    80002e9e:	70a2                	ld	ra,40(sp)
    80002ea0:	7402                	ld	s0,32(sp)
    80002ea2:	64e2                	ld	s1,24(sp)
    80002ea4:	6942                	ld	s2,16(sp)
    80002ea6:	69a2                	ld	s3,8(sp)
    80002ea8:	6a02                	ld	s4,0(sp)
    80002eaa:	6145                	addi	sp,sp,48
    80002eac:	8082                	ret
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002eae:	f3f1                	bnez	a5,80002e72 <iget+0x38>
    80002eb0:	8926                	mv	s2,s1
    80002eb2:	b7c1                	j	80002e72 <iget+0x38>
  if(empty == 0)
    80002eb4:	02090363          	beqz	s2,80002eda <iget+0xa0>
  ip->dev = dev;
    80002eb8:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002ebc:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002ec0:	4785                	li	a5,1
    80002ec2:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002ec6:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002eca:	00032517          	auipc	a0,0x32
    80002ece:	43e50513          	addi	a0,a0,1086 # 80035308 <itable>
    80002ed2:	d61fd0ef          	jal	ra,80000c32 <release>
  return ip;
    80002ed6:	84ca                	mv	s1,s2
    80002ed8:	b7d1                	j	80002e9c <iget+0x62>
    panic("iget: no inodes");
    80002eda:	00004517          	auipc	a0,0x4
    80002ede:	70e50513          	addi	a0,a0,1806 # 800075e8 <syscalls+0x140>
    80002ee2:	875fd0ef          	jal	ra,80000756 <panic>

0000000080002ee6 <fsinit>:
fsinit(int dev) {
    80002ee6:	7179                	addi	sp,sp,-48
    80002ee8:	f406                	sd	ra,40(sp)
    80002eea:	f022                	sd	s0,32(sp)
    80002eec:	ec26                	sd	s1,24(sp)
    80002eee:	e84a                	sd	s2,16(sp)
    80002ef0:	e44e                	sd	s3,8(sp)
    80002ef2:	1800                	addi	s0,sp,48
    80002ef4:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002ef6:	4585                	li	a1,1
    80002ef8:	afdff0ef          	jal	ra,800029f4 <bread>
    80002efc:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002efe:	00032997          	auipc	s3,0x32
    80002f02:	3ea98993          	addi	s3,s3,1002 # 800352e8 <sb>
    80002f06:	02000613          	li	a2,32
    80002f0a:	05850593          	addi	a1,a0,88
    80002f0e:	854e                	mv	a0,s3
    80002f10:	dbbfd0ef          	jal	ra,80000cca <memmove>
  brelse(bp);
    80002f14:	8526                	mv	a0,s1
    80002f16:	be7ff0ef          	jal	ra,80002afc <brelse>
  if(sb.magic != FSMAGIC)
    80002f1a:	0009a703          	lw	a4,0(s3)
    80002f1e:	102037b7          	lui	a5,0x10203
    80002f22:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002f26:	02f71063          	bne	a4,a5,80002f46 <fsinit+0x60>
  initlog(dev, &sb);
    80002f2a:	00032597          	auipc	a1,0x32
    80002f2e:	3be58593          	addi	a1,a1,958 # 800352e8 <sb>
    80002f32:	854a                	mv	a0,s2
    80002f34:	1d9000ef          	jal	ra,8000390c <initlog>
}
    80002f38:	70a2                	ld	ra,40(sp)
    80002f3a:	7402                	ld	s0,32(sp)
    80002f3c:	64e2                	ld	s1,24(sp)
    80002f3e:	6942                	ld	s2,16(sp)
    80002f40:	69a2                	ld	s3,8(sp)
    80002f42:	6145                	addi	sp,sp,48
    80002f44:	8082                	ret
    panic("invalid file system");
    80002f46:	00004517          	auipc	a0,0x4
    80002f4a:	6b250513          	addi	a0,a0,1714 # 800075f8 <syscalls+0x150>
    80002f4e:	809fd0ef          	jal	ra,80000756 <panic>

0000000080002f52 <iinit>:
{
    80002f52:	7179                	addi	sp,sp,-48
    80002f54:	f406                	sd	ra,40(sp)
    80002f56:	f022                	sd	s0,32(sp)
    80002f58:	ec26                	sd	s1,24(sp)
    80002f5a:	e84a                	sd	s2,16(sp)
    80002f5c:	e44e                	sd	s3,8(sp)
    80002f5e:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002f60:	00004597          	auipc	a1,0x4
    80002f64:	6b058593          	addi	a1,a1,1712 # 80007610 <syscalls+0x168>
    80002f68:	00032517          	auipc	a0,0x32
    80002f6c:	3a050513          	addi	a0,a0,928 # 80035308 <itable>
    80002f70:	babfd0ef          	jal	ra,80000b1a <initlock>
  for(i = 0; i < NINODE; i++) {
    80002f74:	00032497          	auipc	s1,0x32
    80002f78:	3bc48493          	addi	s1,s1,956 # 80035330 <itable+0x28>
    80002f7c:	00039997          	auipc	s3,0x39
    80002f80:	df498993          	addi	s3,s3,-524 # 8003bd70 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002f84:	00004917          	auipc	s2,0x4
    80002f88:	69490913          	addi	s2,s2,1684 # 80007618 <syscalls+0x170>
    80002f8c:	85ca                	mv	a1,s2
    80002f8e:	8526                	mv	a0,s1
    80002f90:	463000ef          	jal	ra,80003bf2 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002f94:	08848493          	addi	s1,s1,136
    80002f98:	ff349ae3          	bne	s1,s3,80002f8c <iinit+0x3a>
}
    80002f9c:	70a2                	ld	ra,40(sp)
    80002f9e:	7402                	ld	s0,32(sp)
    80002fa0:	64e2                	ld	s1,24(sp)
    80002fa2:	6942                	ld	s2,16(sp)
    80002fa4:	69a2                	ld	s3,8(sp)
    80002fa6:	6145                	addi	sp,sp,48
    80002fa8:	8082                	ret

0000000080002faa <ialloc>:
{
    80002faa:	715d                	addi	sp,sp,-80
    80002fac:	e486                	sd	ra,72(sp)
    80002fae:	e0a2                	sd	s0,64(sp)
    80002fb0:	fc26                	sd	s1,56(sp)
    80002fb2:	f84a                	sd	s2,48(sp)
    80002fb4:	f44e                	sd	s3,40(sp)
    80002fb6:	f052                	sd	s4,32(sp)
    80002fb8:	ec56                	sd	s5,24(sp)
    80002fba:	e85a                	sd	s6,16(sp)
    80002fbc:	e45e                	sd	s7,8(sp)
    80002fbe:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002fc0:	00032717          	auipc	a4,0x32
    80002fc4:	33472703          	lw	a4,820(a4) # 800352f4 <sb+0xc>
    80002fc8:	4785                	li	a5,1
    80002fca:	04e7f663          	bgeu	a5,a4,80003016 <ialloc+0x6c>
    80002fce:	8aaa                	mv	s5,a0
    80002fd0:	8bae                	mv	s7,a1
    80002fd2:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002fd4:	00032a17          	auipc	s4,0x32
    80002fd8:	314a0a13          	addi	s4,s4,788 # 800352e8 <sb>
    80002fdc:	00048b1b          	sext.w	s6,s1
    80002fe0:	0044d793          	srli	a5,s1,0x4
    80002fe4:	018a2583          	lw	a1,24(s4)
    80002fe8:	9dbd                	addw	a1,a1,a5
    80002fea:	8556                	mv	a0,s5
    80002fec:	a09ff0ef          	jal	ra,800029f4 <bread>
    80002ff0:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002ff2:	05850993          	addi	s3,a0,88
    80002ff6:	00f4f793          	andi	a5,s1,15
    80002ffa:	079a                	slli	a5,a5,0x6
    80002ffc:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002ffe:	00099783          	lh	a5,0(s3)
    80003002:	cf85                	beqz	a5,8000303a <ialloc+0x90>
    brelse(bp);
    80003004:	af9ff0ef          	jal	ra,80002afc <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003008:	0485                	addi	s1,s1,1
    8000300a:	00ca2703          	lw	a4,12(s4)
    8000300e:	0004879b          	sext.w	a5,s1
    80003012:	fce7e5e3          	bltu	a5,a4,80002fdc <ialloc+0x32>
  printf("ialloc: no inodes\n");
    80003016:	00004517          	auipc	a0,0x4
    8000301a:	60a50513          	addi	a0,a0,1546 # 80007620 <syscalls+0x178>
    8000301e:	c84fd0ef          	jal	ra,800004a2 <printf>
  return 0;
    80003022:	4501                	li	a0,0
}
    80003024:	60a6                	ld	ra,72(sp)
    80003026:	6406                	ld	s0,64(sp)
    80003028:	74e2                	ld	s1,56(sp)
    8000302a:	7942                	ld	s2,48(sp)
    8000302c:	79a2                	ld	s3,40(sp)
    8000302e:	7a02                	ld	s4,32(sp)
    80003030:	6ae2                	ld	s5,24(sp)
    80003032:	6b42                	ld	s6,16(sp)
    80003034:	6ba2                	ld	s7,8(sp)
    80003036:	6161                	addi	sp,sp,80
    80003038:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    8000303a:	04000613          	li	a2,64
    8000303e:	4581                	li	a1,0
    80003040:	854e                	mv	a0,s3
    80003042:	c2dfd0ef          	jal	ra,80000c6e <memset>
      dip->type = type;
    80003046:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    8000304a:	854a                	mv	a0,s2
    8000304c:	2d5000ef          	jal	ra,80003b20 <log_write>
      brelse(bp);
    80003050:	854a                	mv	a0,s2
    80003052:	aabff0ef          	jal	ra,80002afc <brelse>
      return iget(dev, inum);
    80003056:	85da                	mv	a1,s6
    80003058:	8556                	mv	a0,s5
    8000305a:	de1ff0ef          	jal	ra,80002e3a <iget>
    8000305e:	b7d9                	j	80003024 <ialloc+0x7a>

0000000080003060 <iupdate>:
{
    80003060:	1101                	addi	sp,sp,-32
    80003062:	ec06                	sd	ra,24(sp)
    80003064:	e822                	sd	s0,16(sp)
    80003066:	e426                	sd	s1,8(sp)
    80003068:	e04a                	sd	s2,0(sp)
    8000306a:	1000                	addi	s0,sp,32
    8000306c:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000306e:	415c                	lw	a5,4(a0)
    80003070:	0047d79b          	srliw	a5,a5,0x4
    80003074:	00032597          	auipc	a1,0x32
    80003078:	28c5a583          	lw	a1,652(a1) # 80035300 <sb+0x18>
    8000307c:	9dbd                	addw	a1,a1,a5
    8000307e:	4108                	lw	a0,0(a0)
    80003080:	975ff0ef          	jal	ra,800029f4 <bread>
    80003084:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003086:	05850793          	addi	a5,a0,88
    8000308a:	40c8                	lw	a0,4(s1)
    8000308c:	893d                	andi	a0,a0,15
    8000308e:	051a                	slli	a0,a0,0x6
    80003090:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80003092:	04449703          	lh	a4,68(s1)
    80003096:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    8000309a:	04649703          	lh	a4,70(s1)
    8000309e:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    800030a2:	04849703          	lh	a4,72(s1)
    800030a6:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    800030aa:	04a49703          	lh	a4,74(s1)
    800030ae:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    800030b2:	44f8                	lw	a4,76(s1)
    800030b4:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800030b6:	03400613          	li	a2,52
    800030ba:	05048593          	addi	a1,s1,80
    800030be:	0531                	addi	a0,a0,12
    800030c0:	c0bfd0ef          	jal	ra,80000cca <memmove>
  log_write(bp);
    800030c4:	854a                	mv	a0,s2
    800030c6:	25b000ef          	jal	ra,80003b20 <log_write>
  brelse(bp);
    800030ca:	854a                	mv	a0,s2
    800030cc:	a31ff0ef          	jal	ra,80002afc <brelse>
}
    800030d0:	60e2                	ld	ra,24(sp)
    800030d2:	6442                	ld	s0,16(sp)
    800030d4:	64a2                	ld	s1,8(sp)
    800030d6:	6902                	ld	s2,0(sp)
    800030d8:	6105                	addi	sp,sp,32
    800030da:	8082                	ret

00000000800030dc <idup>:
{
    800030dc:	1101                	addi	sp,sp,-32
    800030de:	ec06                	sd	ra,24(sp)
    800030e0:	e822                	sd	s0,16(sp)
    800030e2:	e426                	sd	s1,8(sp)
    800030e4:	1000                	addi	s0,sp,32
    800030e6:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800030e8:	00032517          	auipc	a0,0x32
    800030ec:	22050513          	addi	a0,a0,544 # 80035308 <itable>
    800030f0:	aabfd0ef          	jal	ra,80000b9a <acquire>
  ip->ref++;
    800030f4:	449c                	lw	a5,8(s1)
    800030f6:	2785                	addiw	a5,a5,1
    800030f8:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800030fa:	00032517          	auipc	a0,0x32
    800030fe:	20e50513          	addi	a0,a0,526 # 80035308 <itable>
    80003102:	b31fd0ef          	jal	ra,80000c32 <release>
}
    80003106:	8526                	mv	a0,s1
    80003108:	60e2                	ld	ra,24(sp)
    8000310a:	6442                	ld	s0,16(sp)
    8000310c:	64a2                	ld	s1,8(sp)
    8000310e:	6105                	addi	sp,sp,32
    80003110:	8082                	ret

0000000080003112 <ilock>:
{
    80003112:	1101                	addi	sp,sp,-32
    80003114:	ec06                	sd	ra,24(sp)
    80003116:	e822                	sd	s0,16(sp)
    80003118:	e426                	sd	s1,8(sp)
    8000311a:	e04a                	sd	s2,0(sp)
    8000311c:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    8000311e:	c105                	beqz	a0,8000313e <ilock+0x2c>
    80003120:	84aa                	mv	s1,a0
    80003122:	451c                	lw	a5,8(a0)
    80003124:	00f05d63          	blez	a5,8000313e <ilock+0x2c>
  acquiresleep(&ip->lock);
    80003128:	0541                	addi	a0,a0,16
    8000312a:	2ff000ef          	jal	ra,80003c28 <acquiresleep>
  if(ip->valid == 0){
    8000312e:	40bc                	lw	a5,64(s1)
    80003130:	cf89                	beqz	a5,8000314a <ilock+0x38>
}
    80003132:	60e2                	ld	ra,24(sp)
    80003134:	6442                	ld	s0,16(sp)
    80003136:	64a2                	ld	s1,8(sp)
    80003138:	6902                	ld	s2,0(sp)
    8000313a:	6105                	addi	sp,sp,32
    8000313c:	8082                	ret
    panic("ilock");
    8000313e:	00004517          	auipc	a0,0x4
    80003142:	4fa50513          	addi	a0,a0,1274 # 80007638 <syscalls+0x190>
    80003146:	e10fd0ef          	jal	ra,80000756 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000314a:	40dc                	lw	a5,4(s1)
    8000314c:	0047d79b          	srliw	a5,a5,0x4
    80003150:	00032597          	auipc	a1,0x32
    80003154:	1b05a583          	lw	a1,432(a1) # 80035300 <sb+0x18>
    80003158:	9dbd                	addw	a1,a1,a5
    8000315a:	4088                	lw	a0,0(s1)
    8000315c:	899ff0ef          	jal	ra,800029f4 <bread>
    80003160:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003162:	05850593          	addi	a1,a0,88
    80003166:	40dc                	lw	a5,4(s1)
    80003168:	8bbd                	andi	a5,a5,15
    8000316a:	079a                	slli	a5,a5,0x6
    8000316c:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    8000316e:	00059783          	lh	a5,0(a1)
    80003172:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003176:	00259783          	lh	a5,2(a1)
    8000317a:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    8000317e:	00459783          	lh	a5,4(a1)
    80003182:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003186:	00659783          	lh	a5,6(a1)
    8000318a:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    8000318e:	459c                	lw	a5,8(a1)
    80003190:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003192:	03400613          	li	a2,52
    80003196:	05b1                	addi	a1,a1,12
    80003198:	05048513          	addi	a0,s1,80
    8000319c:	b2ffd0ef          	jal	ra,80000cca <memmove>
    brelse(bp);
    800031a0:	854a                	mv	a0,s2
    800031a2:	95bff0ef          	jal	ra,80002afc <brelse>
    ip->valid = 1;
    800031a6:	4785                	li	a5,1
    800031a8:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    800031aa:	04449783          	lh	a5,68(s1)
    800031ae:	f3d1                	bnez	a5,80003132 <ilock+0x20>
      panic("ilock: no type");
    800031b0:	00004517          	auipc	a0,0x4
    800031b4:	49050513          	addi	a0,a0,1168 # 80007640 <syscalls+0x198>
    800031b8:	d9efd0ef          	jal	ra,80000756 <panic>

00000000800031bc <iunlock>:
{
    800031bc:	1101                	addi	sp,sp,-32
    800031be:	ec06                	sd	ra,24(sp)
    800031c0:	e822                	sd	s0,16(sp)
    800031c2:	e426                	sd	s1,8(sp)
    800031c4:	e04a                	sd	s2,0(sp)
    800031c6:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800031c8:	c505                	beqz	a0,800031f0 <iunlock+0x34>
    800031ca:	84aa                	mv	s1,a0
    800031cc:	01050913          	addi	s2,a0,16
    800031d0:	854a                	mv	a0,s2
    800031d2:	2d5000ef          	jal	ra,80003ca6 <holdingsleep>
    800031d6:	cd09                	beqz	a0,800031f0 <iunlock+0x34>
    800031d8:	449c                	lw	a5,8(s1)
    800031da:	00f05b63          	blez	a5,800031f0 <iunlock+0x34>
  releasesleep(&ip->lock);
    800031de:	854a                	mv	a0,s2
    800031e0:	28f000ef          	jal	ra,80003c6e <releasesleep>
}
    800031e4:	60e2                	ld	ra,24(sp)
    800031e6:	6442                	ld	s0,16(sp)
    800031e8:	64a2                	ld	s1,8(sp)
    800031ea:	6902                	ld	s2,0(sp)
    800031ec:	6105                	addi	sp,sp,32
    800031ee:	8082                	ret
    panic("iunlock");
    800031f0:	00004517          	auipc	a0,0x4
    800031f4:	46050513          	addi	a0,a0,1120 # 80007650 <syscalls+0x1a8>
    800031f8:	d5efd0ef          	jal	ra,80000756 <panic>

00000000800031fc <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    800031fc:	7179                	addi	sp,sp,-48
    800031fe:	f406                	sd	ra,40(sp)
    80003200:	f022                	sd	s0,32(sp)
    80003202:	ec26                	sd	s1,24(sp)
    80003204:	e84a                	sd	s2,16(sp)
    80003206:	e44e                	sd	s3,8(sp)
    80003208:	e052                	sd	s4,0(sp)
    8000320a:	1800                	addi	s0,sp,48
    8000320c:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    8000320e:	05050493          	addi	s1,a0,80
    80003212:	08050913          	addi	s2,a0,128
    80003216:	a021                	j	8000321e <itrunc+0x22>
    80003218:	0491                	addi	s1,s1,4
    8000321a:	01248b63          	beq	s1,s2,80003230 <itrunc+0x34>
    if(ip->addrs[i]){
    8000321e:	408c                	lw	a1,0(s1)
    80003220:	dde5                	beqz	a1,80003218 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80003222:	0009a503          	lw	a0,0(s3)
    80003226:	9c9ff0ef          	jal	ra,80002bee <bfree>
      ip->addrs[i] = 0;
    8000322a:	0004a023          	sw	zero,0(s1)
    8000322e:	b7ed                	j	80003218 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003230:	0809a583          	lw	a1,128(s3)
    80003234:	ed91                	bnez	a1,80003250 <itrunc+0x54>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003236:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    8000323a:	854e                	mv	a0,s3
    8000323c:	e25ff0ef          	jal	ra,80003060 <iupdate>
}
    80003240:	70a2                	ld	ra,40(sp)
    80003242:	7402                	ld	s0,32(sp)
    80003244:	64e2                	ld	s1,24(sp)
    80003246:	6942                	ld	s2,16(sp)
    80003248:	69a2                	ld	s3,8(sp)
    8000324a:	6a02                	ld	s4,0(sp)
    8000324c:	6145                	addi	sp,sp,48
    8000324e:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003250:	0009a503          	lw	a0,0(s3)
    80003254:	fa0ff0ef          	jal	ra,800029f4 <bread>
    80003258:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    8000325a:	05850493          	addi	s1,a0,88
    8000325e:	45850913          	addi	s2,a0,1112
    80003262:	a021                	j	8000326a <itrunc+0x6e>
    80003264:	0491                	addi	s1,s1,4
    80003266:	01248963          	beq	s1,s2,80003278 <itrunc+0x7c>
      if(a[j])
    8000326a:	408c                	lw	a1,0(s1)
    8000326c:	dde5                	beqz	a1,80003264 <itrunc+0x68>
        bfree(ip->dev, a[j]);
    8000326e:	0009a503          	lw	a0,0(s3)
    80003272:	97dff0ef          	jal	ra,80002bee <bfree>
    80003276:	b7fd                	j	80003264 <itrunc+0x68>
    brelse(bp);
    80003278:	8552                	mv	a0,s4
    8000327a:	883ff0ef          	jal	ra,80002afc <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    8000327e:	0809a583          	lw	a1,128(s3)
    80003282:	0009a503          	lw	a0,0(s3)
    80003286:	969ff0ef          	jal	ra,80002bee <bfree>
    ip->addrs[NDIRECT] = 0;
    8000328a:	0809a023          	sw	zero,128(s3)
    8000328e:	b765                	j	80003236 <itrunc+0x3a>

0000000080003290 <iput>:
{
    80003290:	1101                	addi	sp,sp,-32
    80003292:	ec06                	sd	ra,24(sp)
    80003294:	e822                	sd	s0,16(sp)
    80003296:	e426                	sd	s1,8(sp)
    80003298:	e04a                	sd	s2,0(sp)
    8000329a:	1000                	addi	s0,sp,32
    8000329c:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000329e:	00032517          	auipc	a0,0x32
    800032a2:	06a50513          	addi	a0,a0,106 # 80035308 <itable>
    800032a6:	8f5fd0ef          	jal	ra,80000b9a <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800032aa:	4498                	lw	a4,8(s1)
    800032ac:	4785                	li	a5,1
    800032ae:	02f70163          	beq	a4,a5,800032d0 <iput+0x40>
  ip->ref--;
    800032b2:	449c                	lw	a5,8(s1)
    800032b4:	37fd                	addiw	a5,a5,-1
    800032b6:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800032b8:	00032517          	auipc	a0,0x32
    800032bc:	05050513          	addi	a0,a0,80 # 80035308 <itable>
    800032c0:	973fd0ef          	jal	ra,80000c32 <release>
}
    800032c4:	60e2                	ld	ra,24(sp)
    800032c6:	6442                	ld	s0,16(sp)
    800032c8:	64a2                	ld	s1,8(sp)
    800032ca:	6902                	ld	s2,0(sp)
    800032cc:	6105                	addi	sp,sp,32
    800032ce:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800032d0:	40bc                	lw	a5,64(s1)
    800032d2:	d3e5                	beqz	a5,800032b2 <iput+0x22>
    800032d4:	04a49783          	lh	a5,74(s1)
    800032d8:	ffe9                	bnez	a5,800032b2 <iput+0x22>
    acquiresleep(&ip->lock);
    800032da:	01048913          	addi	s2,s1,16
    800032de:	854a                	mv	a0,s2
    800032e0:	149000ef          	jal	ra,80003c28 <acquiresleep>
    release(&itable.lock);
    800032e4:	00032517          	auipc	a0,0x32
    800032e8:	02450513          	addi	a0,a0,36 # 80035308 <itable>
    800032ec:	947fd0ef          	jal	ra,80000c32 <release>
    itrunc(ip);
    800032f0:	8526                	mv	a0,s1
    800032f2:	f0bff0ef          	jal	ra,800031fc <itrunc>
    ip->type = 0;
    800032f6:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    800032fa:	8526                	mv	a0,s1
    800032fc:	d65ff0ef          	jal	ra,80003060 <iupdate>
    ip->valid = 0;
    80003300:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003304:	854a                	mv	a0,s2
    80003306:	169000ef          	jal	ra,80003c6e <releasesleep>
    acquire(&itable.lock);
    8000330a:	00032517          	auipc	a0,0x32
    8000330e:	ffe50513          	addi	a0,a0,-2 # 80035308 <itable>
    80003312:	889fd0ef          	jal	ra,80000b9a <acquire>
    80003316:	bf71                	j	800032b2 <iput+0x22>

0000000080003318 <iunlockput>:
{
    80003318:	1101                	addi	sp,sp,-32
    8000331a:	ec06                	sd	ra,24(sp)
    8000331c:	e822                	sd	s0,16(sp)
    8000331e:	e426                	sd	s1,8(sp)
    80003320:	1000                	addi	s0,sp,32
    80003322:	84aa                	mv	s1,a0
  iunlock(ip);
    80003324:	e99ff0ef          	jal	ra,800031bc <iunlock>
  iput(ip);
    80003328:	8526                	mv	a0,s1
    8000332a:	f67ff0ef          	jal	ra,80003290 <iput>
}
    8000332e:	60e2                	ld	ra,24(sp)
    80003330:	6442                	ld	s0,16(sp)
    80003332:	64a2                	ld	s1,8(sp)
    80003334:	6105                	addi	sp,sp,32
    80003336:	8082                	ret

0000000080003338 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003338:	1141                	addi	sp,sp,-16
    8000333a:	e422                	sd	s0,8(sp)
    8000333c:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    8000333e:	411c                	lw	a5,0(a0)
    80003340:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003342:	415c                	lw	a5,4(a0)
    80003344:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003346:	04451783          	lh	a5,68(a0)
    8000334a:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    8000334e:	04a51783          	lh	a5,74(a0)
    80003352:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003356:	04c56783          	lwu	a5,76(a0)
    8000335a:	e99c                	sd	a5,16(a1)
}
    8000335c:	6422                	ld	s0,8(sp)
    8000335e:	0141                	addi	sp,sp,16
    80003360:	8082                	ret

0000000080003362 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003362:	457c                	lw	a5,76(a0)
    80003364:	0cd7ef63          	bltu	a5,a3,80003442 <readi+0xe0>
{
    80003368:	7159                	addi	sp,sp,-112
    8000336a:	f486                	sd	ra,104(sp)
    8000336c:	f0a2                	sd	s0,96(sp)
    8000336e:	eca6                	sd	s1,88(sp)
    80003370:	e8ca                	sd	s2,80(sp)
    80003372:	e4ce                	sd	s3,72(sp)
    80003374:	e0d2                	sd	s4,64(sp)
    80003376:	fc56                	sd	s5,56(sp)
    80003378:	f85a                	sd	s6,48(sp)
    8000337a:	f45e                	sd	s7,40(sp)
    8000337c:	f062                	sd	s8,32(sp)
    8000337e:	ec66                	sd	s9,24(sp)
    80003380:	e86a                	sd	s10,16(sp)
    80003382:	e46e                	sd	s11,8(sp)
    80003384:	1880                	addi	s0,sp,112
    80003386:	8b2a                	mv	s6,a0
    80003388:	8bae                	mv	s7,a1
    8000338a:	8a32                	mv	s4,a2
    8000338c:	84b6                	mv	s1,a3
    8000338e:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003390:	9f35                	addw	a4,a4,a3
    return 0;
    80003392:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003394:	08d76663          	bltu	a4,a3,80003420 <readi+0xbe>
  if(off + n > ip->size)
    80003398:	00e7f463          	bgeu	a5,a4,800033a0 <readi+0x3e>
    n = ip->size - off;
    8000339c:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800033a0:	080a8f63          	beqz	s5,8000343e <readi+0xdc>
    800033a4:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800033a6:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800033aa:	5c7d                	li	s8,-1
    800033ac:	a80d                	j	800033de <readi+0x7c>
    800033ae:	020d1d93          	slli	s11,s10,0x20
    800033b2:	020ddd93          	srli	s11,s11,0x20
    800033b6:	05890793          	addi	a5,s2,88
    800033ba:	86ee                	mv	a3,s11
    800033bc:	963e                	add	a2,a2,a5
    800033be:	85d2                	mv	a1,s4
    800033c0:	855e                	mv	a0,s7
    800033c2:	dbffe0ef          	jal	ra,80002180 <either_copyout>
    800033c6:	05850763          	beq	a0,s8,80003414 <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    800033ca:	854a                	mv	a0,s2
    800033cc:	f30ff0ef          	jal	ra,80002afc <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800033d0:	013d09bb          	addw	s3,s10,s3
    800033d4:	009d04bb          	addw	s1,s10,s1
    800033d8:	9a6e                	add	s4,s4,s11
    800033da:	0559f163          	bgeu	s3,s5,8000341c <readi+0xba>
    uint addr = bmap(ip, off/BSIZE);
    800033de:	00a4d59b          	srliw	a1,s1,0xa
    800033e2:	855a                	mv	a0,s6
    800033e4:	98bff0ef          	jal	ra,80002d6e <bmap>
    800033e8:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800033ec:	c985                	beqz	a1,8000341c <readi+0xba>
    bp = bread(ip->dev, addr);
    800033ee:	000b2503          	lw	a0,0(s6)
    800033f2:	e02ff0ef          	jal	ra,800029f4 <bread>
    800033f6:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800033f8:	3ff4f613          	andi	a2,s1,1023
    800033fc:	40cc87bb          	subw	a5,s9,a2
    80003400:	413a873b          	subw	a4,s5,s3
    80003404:	8d3e                	mv	s10,a5
    80003406:	2781                	sext.w	a5,a5
    80003408:	0007069b          	sext.w	a3,a4
    8000340c:	faf6f1e3          	bgeu	a3,a5,800033ae <readi+0x4c>
    80003410:	8d3a                	mv	s10,a4
    80003412:	bf71                	j	800033ae <readi+0x4c>
      brelse(bp);
    80003414:	854a                	mv	a0,s2
    80003416:	ee6ff0ef          	jal	ra,80002afc <brelse>
      tot = -1;
    8000341a:	59fd                	li	s3,-1
  }
  return tot;
    8000341c:	0009851b          	sext.w	a0,s3
}
    80003420:	70a6                	ld	ra,104(sp)
    80003422:	7406                	ld	s0,96(sp)
    80003424:	64e6                	ld	s1,88(sp)
    80003426:	6946                	ld	s2,80(sp)
    80003428:	69a6                	ld	s3,72(sp)
    8000342a:	6a06                	ld	s4,64(sp)
    8000342c:	7ae2                	ld	s5,56(sp)
    8000342e:	7b42                	ld	s6,48(sp)
    80003430:	7ba2                	ld	s7,40(sp)
    80003432:	7c02                	ld	s8,32(sp)
    80003434:	6ce2                	ld	s9,24(sp)
    80003436:	6d42                	ld	s10,16(sp)
    80003438:	6da2                	ld	s11,8(sp)
    8000343a:	6165                	addi	sp,sp,112
    8000343c:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000343e:	89d6                	mv	s3,s5
    80003440:	bff1                	j	8000341c <readi+0xba>
    return 0;
    80003442:	4501                	li	a0,0
}
    80003444:	8082                	ret

0000000080003446 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003446:	457c                	lw	a5,76(a0)
    80003448:	0ed7ea63          	bltu	a5,a3,8000353c <writei+0xf6>
{
    8000344c:	7159                	addi	sp,sp,-112
    8000344e:	f486                	sd	ra,104(sp)
    80003450:	f0a2                	sd	s0,96(sp)
    80003452:	eca6                	sd	s1,88(sp)
    80003454:	e8ca                	sd	s2,80(sp)
    80003456:	e4ce                	sd	s3,72(sp)
    80003458:	e0d2                	sd	s4,64(sp)
    8000345a:	fc56                	sd	s5,56(sp)
    8000345c:	f85a                	sd	s6,48(sp)
    8000345e:	f45e                	sd	s7,40(sp)
    80003460:	f062                	sd	s8,32(sp)
    80003462:	ec66                	sd	s9,24(sp)
    80003464:	e86a                	sd	s10,16(sp)
    80003466:	e46e                	sd	s11,8(sp)
    80003468:	1880                	addi	s0,sp,112
    8000346a:	8aaa                	mv	s5,a0
    8000346c:	8bae                	mv	s7,a1
    8000346e:	8a32                	mv	s4,a2
    80003470:	8936                	mv	s2,a3
    80003472:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003474:	00e687bb          	addw	a5,a3,a4
    80003478:	0cd7e463          	bltu	a5,a3,80003540 <writei+0xfa>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    8000347c:	00043737          	lui	a4,0x43
    80003480:	0cf76263          	bltu	a4,a5,80003544 <writei+0xfe>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003484:	0a0b0a63          	beqz	s6,80003538 <writei+0xf2>
    80003488:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000348a:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    8000348e:	5c7d                	li	s8,-1
    80003490:	a825                	j	800034c8 <writei+0x82>
    80003492:	020d1d93          	slli	s11,s10,0x20
    80003496:	020ddd93          	srli	s11,s11,0x20
    8000349a:	05848793          	addi	a5,s1,88
    8000349e:	86ee                	mv	a3,s11
    800034a0:	8652                	mv	a2,s4
    800034a2:	85de                	mv	a1,s7
    800034a4:	953e                	add	a0,a0,a5
    800034a6:	d25fe0ef          	jal	ra,800021ca <either_copyin>
    800034aa:	05850a63          	beq	a0,s8,800034fe <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    800034ae:	8526                	mv	a0,s1
    800034b0:	670000ef          	jal	ra,80003b20 <log_write>
    brelse(bp);
    800034b4:	8526                	mv	a0,s1
    800034b6:	e46ff0ef          	jal	ra,80002afc <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800034ba:	013d09bb          	addw	s3,s10,s3
    800034be:	012d093b          	addw	s2,s10,s2
    800034c2:	9a6e                	add	s4,s4,s11
    800034c4:	0569f063          	bgeu	s3,s6,80003504 <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    800034c8:	00a9559b          	srliw	a1,s2,0xa
    800034cc:	8556                	mv	a0,s5
    800034ce:	8a1ff0ef          	jal	ra,80002d6e <bmap>
    800034d2:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800034d6:	c59d                	beqz	a1,80003504 <writei+0xbe>
    bp = bread(ip->dev, addr);
    800034d8:	000aa503          	lw	a0,0(s5)
    800034dc:	d18ff0ef          	jal	ra,800029f4 <bread>
    800034e0:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800034e2:	3ff97513          	andi	a0,s2,1023
    800034e6:	40ac87bb          	subw	a5,s9,a0
    800034ea:	413b073b          	subw	a4,s6,s3
    800034ee:	8d3e                	mv	s10,a5
    800034f0:	2781                	sext.w	a5,a5
    800034f2:	0007069b          	sext.w	a3,a4
    800034f6:	f8f6fee3          	bgeu	a3,a5,80003492 <writei+0x4c>
    800034fa:	8d3a                	mv	s10,a4
    800034fc:	bf59                	j	80003492 <writei+0x4c>
      brelse(bp);
    800034fe:	8526                	mv	a0,s1
    80003500:	dfcff0ef          	jal	ra,80002afc <brelse>
  }

  if(off > ip->size)
    80003504:	04caa783          	lw	a5,76(s5)
    80003508:	0127f463          	bgeu	a5,s2,80003510 <writei+0xca>
    ip->size = off;
    8000350c:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003510:	8556                	mv	a0,s5
    80003512:	b4fff0ef          	jal	ra,80003060 <iupdate>

  return tot;
    80003516:	0009851b          	sext.w	a0,s3
}
    8000351a:	70a6                	ld	ra,104(sp)
    8000351c:	7406                	ld	s0,96(sp)
    8000351e:	64e6                	ld	s1,88(sp)
    80003520:	6946                	ld	s2,80(sp)
    80003522:	69a6                	ld	s3,72(sp)
    80003524:	6a06                	ld	s4,64(sp)
    80003526:	7ae2                	ld	s5,56(sp)
    80003528:	7b42                	ld	s6,48(sp)
    8000352a:	7ba2                	ld	s7,40(sp)
    8000352c:	7c02                	ld	s8,32(sp)
    8000352e:	6ce2                	ld	s9,24(sp)
    80003530:	6d42                	ld	s10,16(sp)
    80003532:	6da2                	ld	s11,8(sp)
    80003534:	6165                	addi	sp,sp,112
    80003536:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003538:	89da                	mv	s3,s6
    8000353a:	bfd9                	j	80003510 <writei+0xca>
    return -1;
    8000353c:	557d                	li	a0,-1
}
    8000353e:	8082                	ret
    return -1;
    80003540:	557d                	li	a0,-1
    80003542:	bfe1                	j	8000351a <writei+0xd4>
    return -1;
    80003544:	557d                	li	a0,-1
    80003546:	bfd1                	j	8000351a <writei+0xd4>

0000000080003548 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003548:	1141                	addi	sp,sp,-16
    8000354a:	e406                	sd	ra,8(sp)
    8000354c:	e022                	sd	s0,0(sp)
    8000354e:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003550:	4639                	li	a2,14
    80003552:	fe8fd0ef          	jal	ra,80000d3a <strncmp>
}
    80003556:	60a2                	ld	ra,8(sp)
    80003558:	6402                	ld	s0,0(sp)
    8000355a:	0141                	addi	sp,sp,16
    8000355c:	8082                	ret

000000008000355e <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000355e:	7139                	addi	sp,sp,-64
    80003560:	fc06                	sd	ra,56(sp)
    80003562:	f822                	sd	s0,48(sp)
    80003564:	f426                	sd	s1,40(sp)
    80003566:	f04a                	sd	s2,32(sp)
    80003568:	ec4e                	sd	s3,24(sp)
    8000356a:	e852                	sd	s4,16(sp)
    8000356c:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    8000356e:	04451703          	lh	a4,68(a0)
    80003572:	4785                	li	a5,1
    80003574:	00f71a63          	bne	a4,a5,80003588 <dirlookup+0x2a>
    80003578:	892a                	mv	s2,a0
    8000357a:	89ae                	mv	s3,a1
    8000357c:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    8000357e:	457c                	lw	a5,76(a0)
    80003580:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003582:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003584:	e39d                	bnez	a5,800035aa <dirlookup+0x4c>
    80003586:	a095                	j	800035ea <dirlookup+0x8c>
    panic("dirlookup not DIR");
    80003588:	00004517          	auipc	a0,0x4
    8000358c:	0d050513          	addi	a0,a0,208 # 80007658 <syscalls+0x1b0>
    80003590:	9c6fd0ef          	jal	ra,80000756 <panic>
      panic("dirlookup read");
    80003594:	00004517          	auipc	a0,0x4
    80003598:	0dc50513          	addi	a0,a0,220 # 80007670 <syscalls+0x1c8>
    8000359c:	9bafd0ef          	jal	ra,80000756 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800035a0:	24c1                	addiw	s1,s1,16
    800035a2:	04c92783          	lw	a5,76(s2)
    800035a6:	04f4f163          	bgeu	s1,a5,800035e8 <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800035aa:	4741                	li	a4,16
    800035ac:	86a6                	mv	a3,s1
    800035ae:	fc040613          	addi	a2,s0,-64
    800035b2:	4581                	li	a1,0
    800035b4:	854a                	mv	a0,s2
    800035b6:	dadff0ef          	jal	ra,80003362 <readi>
    800035ba:	47c1                	li	a5,16
    800035bc:	fcf51ce3          	bne	a0,a5,80003594 <dirlookup+0x36>
    if(de.inum == 0)
    800035c0:	fc045783          	lhu	a5,-64(s0)
    800035c4:	dff1                	beqz	a5,800035a0 <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    800035c6:	fc240593          	addi	a1,s0,-62
    800035ca:	854e                	mv	a0,s3
    800035cc:	f7dff0ef          	jal	ra,80003548 <namecmp>
    800035d0:	f961                	bnez	a0,800035a0 <dirlookup+0x42>
      if(poff)
    800035d2:	000a0463          	beqz	s4,800035da <dirlookup+0x7c>
        *poff = off;
    800035d6:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800035da:	fc045583          	lhu	a1,-64(s0)
    800035de:	00092503          	lw	a0,0(s2)
    800035e2:	859ff0ef          	jal	ra,80002e3a <iget>
    800035e6:	a011                	j	800035ea <dirlookup+0x8c>
  return 0;
    800035e8:	4501                	li	a0,0
}
    800035ea:	70e2                	ld	ra,56(sp)
    800035ec:	7442                	ld	s0,48(sp)
    800035ee:	74a2                	ld	s1,40(sp)
    800035f0:	7902                	ld	s2,32(sp)
    800035f2:	69e2                	ld	s3,24(sp)
    800035f4:	6a42                	ld	s4,16(sp)
    800035f6:	6121                	addi	sp,sp,64
    800035f8:	8082                	ret

00000000800035fa <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800035fa:	711d                	addi	sp,sp,-96
    800035fc:	ec86                	sd	ra,88(sp)
    800035fe:	e8a2                	sd	s0,80(sp)
    80003600:	e4a6                	sd	s1,72(sp)
    80003602:	e0ca                	sd	s2,64(sp)
    80003604:	fc4e                	sd	s3,56(sp)
    80003606:	f852                	sd	s4,48(sp)
    80003608:	f456                	sd	s5,40(sp)
    8000360a:	f05a                	sd	s6,32(sp)
    8000360c:	ec5e                	sd	s7,24(sp)
    8000360e:	e862                	sd	s8,16(sp)
    80003610:	e466                	sd	s9,8(sp)
    80003612:	1080                	addi	s0,sp,96
    80003614:	84aa                	mv	s1,a0
    80003616:	8aae                	mv	s5,a1
    80003618:	8a32                	mv	s4,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000361a:	00054703          	lbu	a4,0(a0)
    8000361e:	02f00793          	li	a5,47
    80003622:	00f70f63          	beq	a4,a5,80003640 <namex+0x46>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003626:	a32fe0ef          	jal	ra,80001858 <myproc>
    8000362a:	71053503          	ld	a0,1808(a0)
    8000362e:	aafff0ef          	jal	ra,800030dc <idup>
    80003632:	89aa                	mv	s3,a0
  while(*path == '/')
    80003634:	02f00913          	li	s2,47
  len = path - s;
    80003638:	4b01                	li	s6,0
  if(len >= DIRSIZ)
    8000363a:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000363c:	4b85                	li	s7,1
    8000363e:	a861                	j	800036d6 <namex+0xdc>
    ip = iget(ROOTDEV, ROOTINO);
    80003640:	4585                	li	a1,1
    80003642:	4505                	li	a0,1
    80003644:	ff6ff0ef          	jal	ra,80002e3a <iget>
    80003648:	89aa                	mv	s3,a0
    8000364a:	b7ed                	j	80003634 <namex+0x3a>
      iunlockput(ip);
    8000364c:	854e                	mv	a0,s3
    8000364e:	ccbff0ef          	jal	ra,80003318 <iunlockput>
      return 0;
    80003652:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003654:	854e                	mv	a0,s3
    80003656:	60e6                	ld	ra,88(sp)
    80003658:	6446                	ld	s0,80(sp)
    8000365a:	64a6                	ld	s1,72(sp)
    8000365c:	6906                	ld	s2,64(sp)
    8000365e:	79e2                	ld	s3,56(sp)
    80003660:	7a42                	ld	s4,48(sp)
    80003662:	7aa2                	ld	s5,40(sp)
    80003664:	7b02                	ld	s6,32(sp)
    80003666:	6be2                	ld	s7,24(sp)
    80003668:	6c42                	ld	s8,16(sp)
    8000366a:	6ca2                	ld	s9,8(sp)
    8000366c:	6125                	addi	sp,sp,96
    8000366e:	8082                	ret
      iunlock(ip);
    80003670:	854e                	mv	a0,s3
    80003672:	b4bff0ef          	jal	ra,800031bc <iunlock>
      return ip;
    80003676:	bff9                	j	80003654 <namex+0x5a>
      iunlockput(ip);
    80003678:	854e                	mv	a0,s3
    8000367a:	c9fff0ef          	jal	ra,80003318 <iunlockput>
      return 0;
    8000367e:	89e6                	mv	s3,s9
    80003680:	bfd1                	j	80003654 <namex+0x5a>
  len = path - s;
    80003682:	40b48633          	sub	a2,s1,a1
    80003686:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    8000368a:	079c5c63          	bge	s8,s9,80003702 <namex+0x108>
    memmove(name, s, DIRSIZ);
    8000368e:	4639                	li	a2,14
    80003690:	8552                	mv	a0,s4
    80003692:	e38fd0ef          	jal	ra,80000cca <memmove>
  while(*path == '/')
    80003696:	0004c783          	lbu	a5,0(s1)
    8000369a:	01279763          	bne	a5,s2,800036a8 <namex+0xae>
    path++;
    8000369e:	0485                	addi	s1,s1,1
  while(*path == '/')
    800036a0:	0004c783          	lbu	a5,0(s1)
    800036a4:	ff278de3          	beq	a5,s2,8000369e <namex+0xa4>
    ilock(ip);
    800036a8:	854e                	mv	a0,s3
    800036aa:	a69ff0ef          	jal	ra,80003112 <ilock>
    if(ip->type != T_DIR){
    800036ae:	04499783          	lh	a5,68(s3)
    800036b2:	f9779de3          	bne	a5,s7,8000364c <namex+0x52>
    if(nameiparent && *path == '\0'){
    800036b6:	000a8563          	beqz	s5,800036c0 <namex+0xc6>
    800036ba:	0004c783          	lbu	a5,0(s1)
    800036be:	dbcd                	beqz	a5,80003670 <namex+0x76>
    if((next = dirlookup(ip, name, 0)) == 0){
    800036c0:	865a                	mv	a2,s6
    800036c2:	85d2                	mv	a1,s4
    800036c4:	854e                	mv	a0,s3
    800036c6:	e99ff0ef          	jal	ra,8000355e <dirlookup>
    800036ca:	8caa                	mv	s9,a0
    800036cc:	d555                	beqz	a0,80003678 <namex+0x7e>
    iunlockput(ip);
    800036ce:	854e                	mv	a0,s3
    800036d0:	c49ff0ef          	jal	ra,80003318 <iunlockput>
    ip = next;
    800036d4:	89e6                	mv	s3,s9
  while(*path == '/')
    800036d6:	0004c783          	lbu	a5,0(s1)
    800036da:	05279363          	bne	a5,s2,80003720 <namex+0x126>
    path++;
    800036de:	0485                	addi	s1,s1,1
  while(*path == '/')
    800036e0:	0004c783          	lbu	a5,0(s1)
    800036e4:	ff278de3          	beq	a5,s2,800036de <namex+0xe4>
  if(*path == 0)
    800036e8:	c78d                	beqz	a5,80003712 <namex+0x118>
    path++;
    800036ea:	85a6                	mv	a1,s1
  len = path - s;
    800036ec:	8cda                	mv	s9,s6
    800036ee:	865a                	mv	a2,s6
  while(*path != '/' && *path != 0)
    800036f0:	01278963          	beq	a5,s2,80003702 <namex+0x108>
    800036f4:	d7d9                	beqz	a5,80003682 <namex+0x88>
    path++;
    800036f6:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    800036f8:	0004c783          	lbu	a5,0(s1)
    800036fc:	ff279ce3          	bne	a5,s2,800036f4 <namex+0xfa>
    80003700:	b749                	j	80003682 <namex+0x88>
    memmove(name, s, len);
    80003702:	2601                	sext.w	a2,a2
    80003704:	8552                	mv	a0,s4
    80003706:	dc4fd0ef          	jal	ra,80000cca <memmove>
    name[len] = 0;
    8000370a:	9cd2                	add	s9,s9,s4
    8000370c:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003710:	b759                	j	80003696 <namex+0x9c>
  if(nameiparent){
    80003712:	f40a81e3          	beqz	s5,80003654 <namex+0x5a>
    iput(ip);
    80003716:	854e                	mv	a0,s3
    80003718:	b79ff0ef          	jal	ra,80003290 <iput>
    return 0;
    8000371c:	4981                	li	s3,0
    8000371e:	bf1d                	j	80003654 <namex+0x5a>
  if(*path == 0)
    80003720:	dbed                	beqz	a5,80003712 <namex+0x118>
  while(*path != '/' && *path != 0)
    80003722:	0004c783          	lbu	a5,0(s1)
    80003726:	85a6                	mv	a1,s1
    80003728:	b7f1                	j	800036f4 <namex+0xfa>

000000008000372a <dirlink>:
{
    8000372a:	7139                	addi	sp,sp,-64
    8000372c:	fc06                	sd	ra,56(sp)
    8000372e:	f822                	sd	s0,48(sp)
    80003730:	f426                	sd	s1,40(sp)
    80003732:	f04a                	sd	s2,32(sp)
    80003734:	ec4e                	sd	s3,24(sp)
    80003736:	e852                	sd	s4,16(sp)
    80003738:	0080                	addi	s0,sp,64
    8000373a:	892a                	mv	s2,a0
    8000373c:	8a2e                	mv	s4,a1
    8000373e:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003740:	4601                	li	a2,0
    80003742:	e1dff0ef          	jal	ra,8000355e <dirlookup>
    80003746:	e52d                	bnez	a0,800037b0 <dirlink+0x86>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003748:	04c92483          	lw	s1,76(s2)
    8000374c:	c48d                	beqz	s1,80003776 <dirlink+0x4c>
    8000374e:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003750:	4741                	li	a4,16
    80003752:	86a6                	mv	a3,s1
    80003754:	fc040613          	addi	a2,s0,-64
    80003758:	4581                	li	a1,0
    8000375a:	854a                	mv	a0,s2
    8000375c:	c07ff0ef          	jal	ra,80003362 <readi>
    80003760:	47c1                	li	a5,16
    80003762:	04f51b63          	bne	a0,a5,800037b8 <dirlink+0x8e>
    if(de.inum == 0)
    80003766:	fc045783          	lhu	a5,-64(s0)
    8000376a:	c791                	beqz	a5,80003776 <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000376c:	24c1                	addiw	s1,s1,16
    8000376e:	04c92783          	lw	a5,76(s2)
    80003772:	fcf4efe3          	bltu	s1,a5,80003750 <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    80003776:	4639                	li	a2,14
    80003778:	85d2                	mv	a1,s4
    8000377a:	fc240513          	addi	a0,s0,-62
    8000377e:	df8fd0ef          	jal	ra,80000d76 <strncpy>
  de.inum = inum;
    80003782:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003786:	4741                	li	a4,16
    80003788:	86a6                	mv	a3,s1
    8000378a:	fc040613          	addi	a2,s0,-64
    8000378e:	4581                	li	a1,0
    80003790:	854a                	mv	a0,s2
    80003792:	cb5ff0ef          	jal	ra,80003446 <writei>
    80003796:	1541                	addi	a0,a0,-16
    80003798:	00a03533          	snez	a0,a0
    8000379c:	40a00533          	neg	a0,a0
}
    800037a0:	70e2                	ld	ra,56(sp)
    800037a2:	7442                	ld	s0,48(sp)
    800037a4:	74a2                	ld	s1,40(sp)
    800037a6:	7902                	ld	s2,32(sp)
    800037a8:	69e2                	ld	s3,24(sp)
    800037aa:	6a42                	ld	s4,16(sp)
    800037ac:	6121                	addi	sp,sp,64
    800037ae:	8082                	ret
    iput(ip);
    800037b0:	ae1ff0ef          	jal	ra,80003290 <iput>
    return -1;
    800037b4:	557d                	li	a0,-1
    800037b6:	b7ed                	j	800037a0 <dirlink+0x76>
      panic("dirlink read");
    800037b8:	00004517          	auipc	a0,0x4
    800037bc:	ec850513          	addi	a0,a0,-312 # 80007680 <syscalls+0x1d8>
    800037c0:	f97fc0ef          	jal	ra,80000756 <panic>

00000000800037c4 <namei>:

struct inode*
namei(char *path)
{
    800037c4:	1101                	addi	sp,sp,-32
    800037c6:	ec06                	sd	ra,24(sp)
    800037c8:	e822                	sd	s0,16(sp)
    800037ca:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800037cc:	fe040613          	addi	a2,s0,-32
    800037d0:	4581                	li	a1,0
    800037d2:	e29ff0ef          	jal	ra,800035fa <namex>
}
    800037d6:	60e2                	ld	ra,24(sp)
    800037d8:	6442                	ld	s0,16(sp)
    800037da:	6105                	addi	sp,sp,32
    800037dc:	8082                	ret

00000000800037de <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800037de:	1141                	addi	sp,sp,-16
    800037e0:	e406                	sd	ra,8(sp)
    800037e2:	e022                	sd	s0,0(sp)
    800037e4:	0800                	addi	s0,sp,16
    800037e6:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800037e8:	4585                	li	a1,1
    800037ea:	e11ff0ef          	jal	ra,800035fa <namex>
}
    800037ee:	60a2                	ld	ra,8(sp)
    800037f0:	6402                	ld	s0,0(sp)
    800037f2:	0141                	addi	sp,sp,16
    800037f4:	8082                	ret

00000000800037f6 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800037f6:	1101                	addi	sp,sp,-32
    800037f8:	ec06                	sd	ra,24(sp)
    800037fa:	e822                	sd	s0,16(sp)
    800037fc:	e426                	sd	s1,8(sp)
    800037fe:	e04a                	sd	s2,0(sp)
    80003800:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003802:	00038917          	auipc	s2,0x38
    80003806:	55e90913          	addi	s2,s2,1374 # 8003bd60 <log>
    8000380a:	01892583          	lw	a1,24(s2)
    8000380e:	02892503          	lw	a0,40(s2)
    80003812:	9e2ff0ef          	jal	ra,800029f4 <bread>
    80003816:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003818:	02c92683          	lw	a3,44(s2)
    8000381c:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000381e:	02d05763          	blez	a3,8000384c <write_head+0x56>
    80003822:	00038797          	auipc	a5,0x38
    80003826:	56e78793          	addi	a5,a5,1390 # 8003bd90 <log+0x30>
    8000382a:	05c50713          	addi	a4,a0,92
    8000382e:	36fd                	addiw	a3,a3,-1
    80003830:	1682                	slli	a3,a3,0x20
    80003832:	9281                	srli	a3,a3,0x20
    80003834:	068a                	slli	a3,a3,0x2
    80003836:	00038617          	auipc	a2,0x38
    8000383a:	55e60613          	addi	a2,a2,1374 # 8003bd94 <log+0x34>
    8000383e:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003840:	4390                	lw	a2,0(a5)
    80003842:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003844:	0791                	addi	a5,a5,4
    80003846:	0711                	addi	a4,a4,4
    80003848:	fed79ce3          	bne	a5,a3,80003840 <write_head+0x4a>
  }
  bwrite(buf);
    8000384c:	8526                	mv	a0,s1
    8000384e:	a7cff0ef          	jal	ra,80002aca <bwrite>
  brelse(buf);
    80003852:	8526                	mv	a0,s1
    80003854:	aa8ff0ef          	jal	ra,80002afc <brelse>
}
    80003858:	60e2                	ld	ra,24(sp)
    8000385a:	6442                	ld	s0,16(sp)
    8000385c:	64a2                	ld	s1,8(sp)
    8000385e:	6902                	ld	s2,0(sp)
    80003860:	6105                	addi	sp,sp,32
    80003862:	8082                	ret

0000000080003864 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003864:	00038797          	auipc	a5,0x38
    80003868:	5287a783          	lw	a5,1320(a5) # 8003bd8c <log+0x2c>
    8000386c:	08f05f63          	blez	a5,8000390a <install_trans+0xa6>
{
    80003870:	7139                	addi	sp,sp,-64
    80003872:	fc06                	sd	ra,56(sp)
    80003874:	f822                	sd	s0,48(sp)
    80003876:	f426                	sd	s1,40(sp)
    80003878:	f04a                	sd	s2,32(sp)
    8000387a:	ec4e                	sd	s3,24(sp)
    8000387c:	e852                	sd	s4,16(sp)
    8000387e:	e456                	sd	s5,8(sp)
    80003880:	e05a                	sd	s6,0(sp)
    80003882:	0080                	addi	s0,sp,64
    80003884:	8b2a                	mv	s6,a0
    80003886:	00038a97          	auipc	s5,0x38
    8000388a:	50aa8a93          	addi	s5,s5,1290 # 8003bd90 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000388e:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003890:	00038997          	auipc	s3,0x38
    80003894:	4d098993          	addi	s3,s3,1232 # 8003bd60 <log>
    80003898:	a829                	j	800038b2 <install_trans+0x4e>
    brelse(lbuf);
    8000389a:	854a                	mv	a0,s2
    8000389c:	a60ff0ef          	jal	ra,80002afc <brelse>
    brelse(dbuf);
    800038a0:	8526                	mv	a0,s1
    800038a2:	a5aff0ef          	jal	ra,80002afc <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800038a6:	2a05                	addiw	s4,s4,1
    800038a8:	0a91                	addi	s5,s5,4
    800038aa:	02c9a783          	lw	a5,44(s3)
    800038ae:	04fa5463          	bge	s4,a5,800038f6 <install_trans+0x92>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800038b2:	0189a583          	lw	a1,24(s3)
    800038b6:	014585bb          	addw	a1,a1,s4
    800038ba:	2585                	addiw	a1,a1,1
    800038bc:	0289a503          	lw	a0,40(s3)
    800038c0:	934ff0ef          	jal	ra,800029f4 <bread>
    800038c4:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800038c6:	000aa583          	lw	a1,0(s5)
    800038ca:	0289a503          	lw	a0,40(s3)
    800038ce:	926ff0ef          	jal	ra,800029f4 <bread>
    800038d2:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800038d4:	40000613          	li	a2,1024
    800038d8:	05890593          	addi	a1,s2,88
    800038dc:	05850513          	addi	a0,a0,88
    800038e0:	beafd0ef          	jal	ra,80000cca <memmove>
    bwrite(dbuf);  // write dst to disk
    800038e4:	8526                	mv	a0,s1
    800038e6:	9e4ff0ef          	jal	ra,80002aca <bwrite>
    if(recovering == 0)
    800038ea:	fa0b18e3          	bnez	s6,8000389a <install_trans+0x36>
      bunpin(dbuf);
    800038ee:	8526                	mv	a0,s1
    800038f0:	acaff0ef          	jal	ra,80002bba <bunpin>
    800038f4:	b75d                	j	8000389a <install_trans+0x36>
}
    800038f6:	70e2                	ld	ra,56(sp)
    800038f8:	7442                	ld	s0,48(sp)
    800038fa:	74a2                	ld	s1,40(sp)
    800038fc:	7902                	ld	s2,32(sp)
    800038fe:	69e2                	ld	s3,24(sp)
    80003900:	6a42                	ld	s4,16(sp)
    80003902:	6aa2                	ld	s5,8(sp)
    80003904:	6b02                	ld	s6,0(sp)
    80003906:	6121                	addi	sp,sp,64
    80003908:	8082                	ret
    8000390a:	8082                	ret

000000008000390c <initlog>:
{
    8000390c:	7179                	addi	sp,sp,-48
    8000390e:	f406                	sd	ra,40(sp)
    80003910:	f022                	sd	s0,32(sp)
    80003912:	ec26                	sd	s1,24(sp)
    80003914:	e84a                	sd	s2,16(sp)
    80003916:	e44e                	sd	s3,8(sp)
    80003918:	1800                	addi	s0,sp,48
    8000391a:	892a                	mv	s2,a0
    8000391c:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000391e:	00038497          	auipc	s1,0x38
    80003922:	44248493          	addi	s1,s1,1090 # 8003bd60 <log>
    80003926:	00004597          	auipc	a1,0x4
    8000392a:	d6a58593          	addi	a1,a1,-662 # 80007690 <syscalls+0x1e8>
    8000392e:	8526                	mv	a0,s1
    80003930:	9eafd0ef          	jal	ra,80000b1a <initlock>
  log.start = sb->logstart;
    80003934:	0149a583          	lw	a1,20(s3)
    80003938:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000393a:	0109a783          	lw	a5,16(s3)
    8000393e:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003940:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003944:	854a                	mv	a0,s2
    80003946:	8aeff0ef          	jal	ra,800029f4 <bread>
  log.lh.n = lh->n;
    8000394a:	4d34                	lw	a3,88(a0)
    8000394c:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000394e:	02d05563          	blez	a3,80003978 <initlog+0x6c>
    80003952:	05c50793          	addi	a5,a0,92
    80003956:	00038717          	auipc	a4,0x38
    8000395a:	43a70713          	addi	a4,a4,1082 # 8003bd90 <log+0x30>
    8000395e:	36fd                	addiw	a3,a3,-1
    80003960:	1682                	slli	a3,a3,0x20
    80003962:	9281                	srli	a3,a3,0x20
    80003964:	068a                	slli	a3,a3,0x2
    80003966:	06050613          	addi	a2,a0,96
    8000396a:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    8000396c:	4390                	lw	a2,0(a5)
    8000396e:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003970:	0791                	addi	a5,a5,4
    80003972:	0711                	addi	a4,a4,4
    80003974:	fed79ce3          	bne	a5,a3,8000396c <initlog+0x60>
  brelse(buf);
    80003978:	984ff0ef          	jal	ra,80002afc <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000397c:	4505                	li	a0,1
    8000397e:	ee7ff0ef          	jal	ra,80003864 <install_trans>
  log.lh.n = 0;
    80003982:	00038797          	auipc	a5,0x38
    80003986:	4007a523          	sw	zero,1034(a5) # 8003bd8c <log+0x2c>
  write_head(); // clear the log
    8000398a:	e6dff0ef          	jal	ra,800037f6 <write_head>
}
    8000398e:	70a2                	ld	ra,40(sp)
    80003990:	7402                	ld	s0,32(sp)
    80003992:	64e2                	ld	s1,24(sp)
    80003994:	6942                	ld	s2,16(sp)
    80003996:	69a2                	ld	s3,8(sp)
    80003998:	6145                	addi	sp,sp,48
    8000399a:	8082                	ret

000000008000399c <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000399c:	1101                	addi	sp,sp,-32
    8000399e:	ec06                	sd	ra,24(sp)
    800039a0:	e822                	sd	s0,16(sp)
    800039a2:	e426                	sd	s1,8(sp)
    800039a4:	e04a                	sd	s2,0(sp)
    800039a6:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800039a8:	00038517          	auipc	a0,0x38
    800039ac:	3b850513          	addi	a0,a0,952 # 8003bd60 <log>
    800039b0:	9eafd0ef          	jal	ra,80000b9a <acquire>
  while(1){
    if(log.committing){
    800039b4:	00038497          	auipc	s1,0x38
    800039b8:	3ac48493          	addi	s1,s1,940 # 8003bd60 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800039bc:	4979                	li	s2,30
    800039be:	a029                	j	800039c8 <begin_op+0x2c>
      sleep(&log, &log.lock);
    800039c0:	85a6                	mv	a1,s1
    800039c2:	8526                	mv	a0,s1
    800039c4:	c60fe0ef          	jal	ra,80001e24 <sleep>
    if(log.committing){
    800039c8:	50dc                	lw	a5,36(s1)
    800039ca:	fbfd                	bnez	a5,800039c0 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800039cc:	509c                	lw	a5,32(s1)
    800039ce:	0017871b          	addiw	a4,a5,1
    800039d2:	0007069b          	sext.w	a3,a4
    800039d6:	0027179b          	slliw	a5,a4,0x2
    800039da:	9fb9                	addw	a5,a5,a4
    800039dc:	0017979b          	slliw	a5,a5,0x1
    800039e0:	54d8                	lw	a4,44(s1)
    800039e2:	9fb9                	addw	a5,a5,a4
    800039e4:	00f95763          	bge	s2,a5,800039f2 <begin_op+0x56>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800039e8:	85a6                	mv	a1,s1
    800039ea:	8526                	mv	a0,s1
    800039ec:	c38fe0ef          	jal	ra,80001e24 <sleep>
    800039f0:	bfe1                	j	800039c8 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    800039f2:	00038517          	auipc	a0,0x38
    800039f6:	36e50513          	addi	a0,a0,878 # 8003bd60 <log>
    800039fa:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800039fc:	a36fd0ef          	jal	ra,80000c32 <release>
      break;
    }
  }
}
    80003a00:	60e2                	ld	ra,24(sp)
    80003a02:	6442                	ld	s0,16(sp)
    80003a04:	64a2                	ld	s1,8(sp)
    80003a06:	6902                	ld	s2,0(sp)
    80003a08:	6105                	addi	sp,sp,32
    80003a0a:	8082                	ret

0000000080003a0c <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003a0c:	7139                	addi	sp,sp,-64
    80003a0e:	fc06                	sd	ra,56(sp)
    80003a10:	f822                	sd	s0,48(sp)
    80003a12:	f426                	sd	s1,40(sp)
    80003a14:	f04a                	sd	s2,32(sp)
    80003a16:	ec4e                	sd	s3,24(sp)
    80003a18:	e852                	sd	s4,16(sp)
    80003a1a:	e456                	sd	s5,8(sp)
    80003a1c:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003a1e:	00038497          	auipc	s1,0x38
    80003a22:	34248493          	addi	s1,s1,834 # 8003bd60 <log>
    80003a26:	8526                	mv	a0,s1
    80003a28:	972fd0ef          	jal	ra,80000b9a <acquire>
  log.outstanding -= 1;
    80003a2c:	509c                	lw	a5,32(s1)
    80003a2e:	37fd                	addiw	a5,a5,-1
    80003a30:	0007891b          	sext.w	s2,a5
    80003a34:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003a36:	50dc                	lw	a5,36(s1)
    80003a38:	ef9d                	bnez	a5,80003a76 <end_op+0x6a>
    panic("log.committing");
  if(log.outstanding == 0){
    80003a3a:	04091463          	bnez	s2,80003a82 <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    80003a3e:	00038497          	auipc	s1,0x38
    80003a42:	32248493          	addi	s1,s1,802 # 8003bd60 <log>
    80003a46:	4785                	li	a5,1
    80003a48:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003a4a:	8526                	mv	a0,s1
    80003a4c:	9e6fd0ef          	jal	ra,80000c32 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003a50:	54dc                	lw	a5,44(s1)
    80003a52:	04f04b63          	bgtz	a5,80003aa8 <end_op+0x9c>
    acquire(&log.lock);
    80003a56:	00038497          	auipc	s1,0x38
    80003a5a:	30a48493          	addi	s1,s1,778 # 8003bd60 <log>
    80003a5e:	8526                	mv	a0,s1
    80003a60:	93afd0ef          	jal	ra,80000b9a <acquire>
    log.committing = 0;
    80003a64:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003a68:	8526                	mv	a0,s1
    80003a6a:	c06fe0ef          	jal	ra,80001e70 <wakeup>
    release(&log.lock);
    80003a6e:	8526                	mv	a0,s1
    80003a70:	9c2fd0ef          	jal	ra,80000c32 <release>
}
    80003a74:	a00d                	j	80003a96 <end_op+0x8a>
    panic("log.committing");
    80003a76:	00004517          	auipc	a0,0x4
    80003a7a:	c2250513          	addi	a0,a0,-990 # 80007698 <syscalls+0x1f0>
    80003a7e:	cd9fc0ef          	jal	ra,80000756 <panic>
    wakeup(&log);
    80003a82:	00038497          	auipc	s1,0x38
    80003a86:	2de48493          	addi	s1,s1,734 # 8003bd60 <log>
    80003a8a:	8526                	mv	a0,s1
    80003a8c:	be4fe0ef          	jal	ra,80001e70 <wakeup>
  release(&log.lock);
    80003a90:	8526                	mv	a0,s1
    80003a92:	9a0fd0ef          	jal	ra,80000c32 <release>
}
    80003a96:	70e2                	ld	ra,56(sp)
    80003a98:	7442                	ld	s0,48(sp)
    80003a9a:	74a2                	ld	s1,40(sp)
    80003a9c:	7902                	ld	s2,32(sp)
    80003a9e:	69e2                	ld	s3,24(sp)
    80003aa0:	6a42                	ld	s4,16(sp)
    80003aa2:	6aa2                	ld	s5,8(sp)
    80003aa4:	6121                	addi	sp,sp,64
    80003aa6:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80003aa8:	00038a97          	auipc	s5,0x38
    80003aac:	2e8a8a93          	addi	s5,s5,744 # 8003bd90 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003ab0:	00038a17          	auipc	s4,0x38
    80003ab4:	2b0a0a13          	addi	s4,s4,688 # 8003bd60 <log>
    80003ab8:	018a2583          	lw	a1,24(s4)
    80003abc:	012585bb          	addw	a1,a1,s2
    80003ac0:	2585                	addiw	a1,a1,1
    80003ac2:	028a2503          	lw	a0,40(s4)
    80003ac6:	f2ffe0ef          	jal	ra,800029f4 <bread>
    80003aca:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003acc:	000aa583          	lw	a1,0(s5)
    80003ad0:	028a2503          	lw	a0,40(s4)
    80003ad4:	f21fe0ef          	jal	ra,800029f4 <bread>
    80003ad8:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003ada:	40000613          	li	a2,1024
    80003ade:	05850593          	addi	a1,a0,88
    80003ae2:	05848513          	addi	a0,s1,88
    80003ae6:	9e4fd0ef          	jal	ra,80000cca <memmove>
    bwrite(to);  // write the log
    80003aea:	8526                	mv	a0,s1
    80003aec:	fdffe0ef          	jal	ra,80002aca <bwrite>
    brelse(from);
    80003af0:	854e                	mv	a0,s3
    80003af2:	80aff0ef          	jal	ra,80002afc <brelse>
    brelse(to);
    80003af6:	8526                	mv	a0,s1
    80003af8:	804ff0ef          	jal	ra,80002afc <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003afc:	2905                	addiw	s2,s2,1
    80003afe:	0a91                	addi	s5,s5,4
    80003b00:	02ca2783          	lw	a5,44(s4)
    80003b04:	faf94ae3          	blt	s2,a5,80003ab8 <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003b08:	cefff0ef          	jal	ra,800037f6 <write_head>
    install_trans(0); // Now install writes to home locations
    80003b0c:	4501                	li	a0,0
    80003b0e:	d57ff0ef          	jal	ra,80003864 <install_trans>
    log.lh.n = 0;
    80003b12:	00038797          	auipc	a5,0x38
    80003b16:	2607ad23          	sw	zero,634(a5) # 8003bd8c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003b1a:	cddff0ef          	jal	ra,800037f6 <write_head>
    80003b1e:	bf25                	j	80003a56 <end_op+0x4a>

0000000080003b20 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003b20:	1101                	addi	sp,sp,-32
    80003b22:	ec06                	sd	ra,24(sp)
    80003b24:	e822                	sd	s0,16(sp)
    80003b26:	e426                	sd	s1,8(sp)
    80003b28:	e04a                	sd	s2,0(sp)
    80003b2a:	1000                	addi	s0,sp,32
    80003b2c:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003b2e:	00038917          	auipc	s2,0x38
    80003b32:	23290913          	addi	s2,s2,562 # 8003bd60 <log>
    80003b36:	854a                	mv	a0,s2
    80003b38:	862fd0ef          	jal	ra,80000b9a <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003b3c:	02c92603          	lw	a2,44(s2)
    80003b40:	47f5                	li	a5,29
    80003b42:	06c7c363          	blt	a5,a2,80003ba8 <log_write+0x88>
    80003b46:	00038797          	auipc	a5,0x38
    80003b4a:	2367a783          	lw	a5,566(a5) # 8003bd7c <log+0x1c>
    80003b4e:	37fd                	addiw	a5,a5,-1
    80003b50:	04f65c63          	bge	a2,a5,80003ba8 <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003b54:	00038797          	auipc	a5,0x38
    80003b58:	22c7a783          	lw	a5,556(a5) # 8003bd80 <log+0x20>
    80003b5c:	04f05c63          	blez	a5,80003bb4 <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003b60:	4781                	li	a5,0
    80003b62:	04c05f63          	blez	a2,80003bc0 <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003b66:	44cc                	lw	a1,12(s1)
    80003b68:	00038717          	auipc	a4,0x38
    80003b6c:	22870713          	addi	a4,a4,552 # 8003bd90 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003b70:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003b72:	4314                	lw	a3,0(a4)
    80003b74:	04b68663          	beq	a3,a1,80003bc0 <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    80003b78:	2785                	addiw	a5,a5,1
    80003b7a:	0711                	addi	a4,a4,4
    80003b7c:	fef61be3          	bne	a2,a5,80003b72 <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003b80:	0621                	addi	a2,a2,8
    80003b82:	060a                	slli	a2,a2,0x2
    80003b84:	00038797          	auipc	a5,0x38
    80003b88:	1dc78793          	addi	a5,a5,476 # 8003bd60 <log>
    80003b8c:	963e                	add	a2,a2,a5
    80003b8e:	44dc                	lw	a5,12(s1)
    80003b90:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003b92:	8526                	mv	a0,s1
    80003b94:	ff3fe0ef          	jal	ra,80002b86 <bpin>
    log.lh.n++;
    80003b98:	00038717          	auipc	a4,0x38
    80003b9c:	1c870713          	addi	a4,a4,456 # 8003bd60 <log>
    80003ba0:	575c                	lw	a5,44(a4)
    80003ba2:	2785                	addiw	a5,a5,1
    80003ba4:	d75c                	sw	a5,44(a4)
    80003ba6:	a815                	j	80003bda <log_write+0xba>
    panic("too big a transaction");
    80003ba8:	00004517          	auipc	a0,0x4
    80003bac:	b0050513          	addi	a0,a0,-1280 # 800076a8 <syscalls+0x200>
    80003bb0:	ba7fc0ef          	jal	ra,80000756 <panic>
    panic("log_write outside of trans");
    80003bb4:	00004517          	auipc	a0,0x4
    80003bb8:	b0c50513          	addi	a0,a0,-1268 # 800076c0 <syscalls+0x218>
    80003bbc:	b9bfc0ef          	jal	ra,80000756 <panic>
  log.lh.block[i] = b->blockno;
    80003bc0:	00878713          	addi	a4,a5,8
    80003bc4:	00271693          	slli	a3,a4,0x2
    80003bc8:	00038717          	auipc	a4,0x38
    80003bcc:	19870713          	addi	a4,a4,408 # 8003bd60 <log>
    80003bd0:	9736                	add	a4,a4,a3
    80003bd2:	44d4                	lw	a3,12(s1)
    80003bd4:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003bd6:	faf60ee3          	beq	a2,a5,80003b92 <log_write+0x72>
  }
  release(&log.lock);
    80003bda:	00038517          	auipc	a0,0x38
    80003bde:	18650513          	addi	a0,a0,390 # 8003bd60 <log>
    80003be2:	850fd0ef          	jal	ra,80000c32 <release>
}
    80003be6:	60e2                	ld	ra,24(sp)
    80003be8:	6442                	ld	s0,16(sp)
    80003bea:	64a2                	ld	s1,8(sp)
    80003bec:	6902                	ld	s2,0(sp)
    80003bee:	6105                	addi	sp,sp,32
    80003bf0:	8082                	ret

0000000080003bf2 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003bf2:	1101                	addi	sp,sp,-32
    80003bf4:	ec06                	sd	ra,24(sp)
    80003bf6:	e822                	sd	s0,16(sp)
    80003bf8:	e426                	sd	s1,8(sp)
    80003bfa:	e04a                	sd	s2,0(sp)
    80003bfc:	1000                	addi	s0,sp,32
    80003bfe:	84aa                	mv	s1,a0
    80003c00:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003c02:	00004597          	auipc	a1,0x4
    80003c06:	ade58593          	addi	a1,a1,-1314 # 800076e0 <syscalls+0x238>
    80003c0a:	0521                	addi	a0,a0,8
    80003c0c:	f0ffc0ef          	jal	ra,80000b1a <initlock>
  lk->name = name;
    80003c10:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003c14:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003c18:	0204a423          	sw	zero,40(s1)
}
    80003c1c:	60e2                	ld	ra,24(sp)
    80003c1e:	6442                	ld	s0,16(sp)
    80003c20:	64a2                	ld	s1,8(sp)
    80003c22:	6902                	ld	s2,0(sp)
    80003c24:	6105                	addi	sp,sp,32
    80003c26:	8082                	ret

0000000080003c28 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003c28:	1101                	addi	sp,sp,-32
    80003c2a:	ec06                	sd	ra,24(sp)
    80003c2c:	e822                	sd	s0,16(sp)
    80003c2e:	e426                	sd	s1,8(sp)
    80003c30:	e04a                	sd	s2,0(sp)
    80003c32:	1000                	addi	s0,sp,32
    80003c34:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003c36:	00850913          	addi	s2,a0,8
    80003c3a:	854a                	mv	a0,s2
    80003c3c:	f5ffc0ef          	jal	ra,80000b9a <acquire>
  while (lk->locked) {
    80003c40:	409c                	lw	a5,0(s1)
    80003c42:	c799                	beqz	a5,80003c50 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80003c44:	85ca                	mv	a1,s2
    80003c46:	8526                	mv	a0,s1
    80003c48:	9dcfe0ef          	jal	ra,80001e24 <sleep>
  while (lk->locked) {
    80003c4c:	409c                	lw	a5,0(s1)
    80003c4e:	fbfd                	bnez	a5,80003c44 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80003c50:	4785                	li	a5,1
    80003c52:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003c54:	c05fd0ef          	jal	ra,80001858 <myproc>
    80003c58:	591c                	lw	a5,48(a0)
    80003c5a:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003c5c:	854a                	mv	a0,s2
    80003c5e:	fd5fc0ef          	jal	ra,80000c32 <release>
}
    80003c62:	60e2                	ld	ra,24(sp)
    80003c64:	6442                	ld	s0,16(sp)
    80003c66:	64a2                	ld	s1,8(sp)
    80003c68:	6902                	ld	s2,0(sp)
    80003c6a:	6105                	addi	sp,sp,32
    80003c6c:	8082                	ret

0000000080003c6e <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003c6e:	1101                	addi	sp,sp,-32
    80003c70:	ec06                	sd	ra,24(sp)
    80003c72:	e822                	sd	s0,16(sp)
    80003c74:	e426                	sd	s1,8(sp)
    80003c76:	e04a                	sd	s2,0(sp)
    80003c78:	1000                	addi	s0,sp,32
    80003c7a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003c7c:	00850913          	addi	s2,a0,8
    80003c80:	854a                	mv	a0,s2
    80003c82:	f19fc0ef          	jal	ra,80000b9a <acquire>
  lk->locked = 0;
    80003c86:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003c8a:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003c8e:	8526                	mv	a0,s1
    80003c90:	9e0fe0ef          	jal	ra,80001e70 <wakeup>
  release(&lk->lk);
    80003c94:	854a                	mv	a0,s2
    80003c96:	f9dfc0ef          	jal	ra,80000c32 <release>
}
    80003c9a:	60e2                	ld	ra,24(sp)
    80003c9c:	6442                	ld	s0,16(sp)
    80003c9e:	64a2                	ld	s1,8(sp)
    80003ca0:	6902                	ld	s2,0(sp)
    80003ca2:	6105                	addi	sp,sp,32
    80003ca4:	8082                	ret

0000000080003ca6 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003ca6:	7179                	addi	sp,sp,-48
    80003ca8:	f406                	sd	ra,40(sp)
    80003caa:	f022                	sd	s0,32(sp)
    80003cac:	ec26                	sd	s1,24(sp)
    80003cae:	e84a                	sd	s2,16(sp)
    80003cb0:	e44e                	sd	s3,8(sp)
    80003cb2:	1800                	addi	s0,sp,48
    80003cb4:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003cb6:	00850913          	addi	s2,a0,8
    80003cba:	854a                	mv	a0,s2
    80003cbc:	edffc0ef          	jal	ra,80000b9a <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003cc0:	409c                	lw	a5,0(s1)
    80003cc2:	ef89                	bnez	a5,80003cdc <holdingsleep+0x36>
    80003cc4:	4481                	li	s1,0
  release(&lk->lk);
    80003cc6:	854a                	mv	a0,s2
    80003cc8:	f6bfc0ef          	jal	ra,80000c32 <release>
  return r;
}
    80003ccc:	8526                	mv	a0,s1
    80003cce:	70a2                	ld	ra,40(sp)
    80003cd0:	7402                	ld	s0,32(sp)
    80003cd2:	64e2                	ld	s1,24(sp)
    80003cd4:	6942                	ld	s2,16(sp)
    80003cd6:	69a2                	ld	s3,8(sp)
    80003cd8:	6145                	addi	sp,sp,48
    80003cda:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003cdc:	0284a983          	lw	s3,40(s1)
    80003ce0:	b79fd0ef          	jal	ra,80001858 <myproc>
    80003ce4:	5904                	lw	s1,48(a0)
    80003ce6:	413484b3          	sub	s1,s1,s3
    80003cea:	0014b493          	seqz	s1,s1
    80003cee:	bfe1                	j	80003cc6 <holdingsleep+0x20>

0000000080003cf0 <fileprint_metadata>:
{
  print_kmem_cache(file_cache, fileprint_metadata);
  return 0;
}

void fileprint_metadata(void *f) {
    80003cf0:	7179                	addi	sp,sp,-48
    80003cf2:	f406                	sd	ra,40(sp)
    80003cf4:	f022                	sd	s0,32(sp)
    80003cf6:	ec26                	sd	s1,24(sp)
    80003cf8:	1800                	addi	s0,sp,48
    80003cfa:	84aa                	mv	s1,a0
  struct file *file = (struct file *) f;
  debug("tp: %d, ref: %d, readable: %d, writable: %d, pipe: %p, ip: %p, off: %d, major: %d",
    80003cfc:	261010ef          	jal	ra,8000575c <get_mode>
    80003d00:	2501                	sext.w	a0,a0
    80003d02:	e511                	bnez	a0,80003d0e <fileprint_metadata+0x1e>
        file->type, file->ref, file->readable, file->writable, file->pipe, file->ip, file->off, file->major);
}
    80003d04:	70a2                	ld	ra,40(sp)
    80003d06:	7402                	ld	s0,32(sp)
    80003d08:	64e2                	ld	s1,24(sp)
    80003d0a:	6145                	addi	sp,sp,48
    80003d0c:	8082                	ret
  debug("tp: %d, ref: %d, readable: %d, writable: %d, pipe: %p, ip: %p, off: %d, major: %d",
    80003d0e:	02449783          	lh	a5,36(s1)
    80003d12:	e03e                	sd	a5,0(sp)
    80003d14:	0204a883          	lw	a7,32(s1)
    80003d18:	0184b803          	ld	a6,24(s1)
    80003d1c:	689c                	ld	a5,16(s1)
    80003d1e:	0094c703          	lbu	a4,9(s1)
    80003d22:	0084c683          	lbu	a3,8(s1)
    80003d26:	40d0                	lw	a2,4(s1)
    80003d28:	408c                	lw	a1,0(s1)
    80003d2a:	00004517          	auipc	a0,0x4
    80003d2e:	9c650513          	addi	a0,a0,-1594 # 800076f0 <syscalls+0x248>
    80003d32:	f70fc0ef          	jal	ra,800004a2 <printf>
}
    80003d36:	b7f9                	j	80003d04 <fileprint_metadata+0x14>

0000000080003d38 <sys_printfslab>:
{
    80003d38:	1141                	addi	sp,sp,-16
    80003d3a:	e406                	sd	ra,8(sp)
    80003d3c:	e022                	sd	s0,0(sp)
    80003d3e:	0800                	addi	s0,sp,16
  print_kmem_cache(file_cache, fileprint_metadata);
    80003d40:	00000597          	auipc	a1,0x0
    80003d44:	fb058593          	addi	a1,a1,-80 # 80003cf0 <fileprint_metadata>
    80003d48:	00004517          	auipc	a0,0x4
    80003d4c:	f7053503          	ld	a0,-144(a0) # 80007cb8 <file_cache>
    80003d50:	2af010ef          	jal	ra,800057fe <print_kmem_cache>
}
    80003d54:	4501                	li	a0,0
    80003d56:	60a2                	ld	ra,8(sp)
    80003d58:	6402                	ld	s0,0(sp)
    80003d5a:	0141                	addi	sp,sp,16
    80003d5c:	8082                	ret

0000000080003d5e <fileinit>:

struct kmem_cache *file_cache;

void
fileinit(void)
{
    80003d5e:	1141                	addi	sp,sp,-16
    80003d60:	e406                	sd	ra,8(sp)
    80003d62:	e022                	sd	s0,0(sp)
    80003d64:	0800                	addi	s0,sp,16
  debug("[FILE] fileinit\n"); // example of using debug, you can modify this
    80003d66:	1f7010ef          	jal	ra,8000575c <get_mode>
    80003d6a:	2501                	sext.w	a0,a0
    80003d6c:	e91d                	bnez	a0,80003da2 <fileinit+0x44>
  initlock(&ftable.lock, "ftable");
    80003d6e:	00004597          	auipc	a1,0x4
    80003d72:	9f258593          	addi	a1,a1,-1550 # 80007760 <syscalls+0x2b8>
    80003d76:	00038517          	auipc	a0,0x38
    80003d7a:	09250513          	addi	a0,a0,146 # 8003be08 <ftable>
    80003d7e:	d9dfc0ef          	jal	ra,80000b1a <initlock>
  file_cache = kmem_cache_create("file", sizeof(struct file));
    80003d82:	1f800593          	li	a1,504
    80003d86:	00004517          	auipc	a0,0x4
    80003d8a:	9e250513          	addi	a0,a0,-1566 # 80007768 <syscalls+0x2c0>
    80003d8e:	535010ef          	jal	ra,80005ac2 <kmem_cache_create>
    80003d92:	00004797          	auipc	a5,0x4
    80003d96:	f2a7b323          	sd	a0,-218(a5) # 80007cb8 <file_cache>
}
    80003d9a:	60a2                	ld	ra,8(sp)
    80003d9c:	6402                	ld	s0,0(sp)
    80003d9e:	0141                	addi	sp,sp,16
    80003da0:	8082                	ret
  debug("[FILE] fileinit\n"); // example of using debug, you can modify this
    80003da2:	00004517          	auipc	a0,0x4
    80003da6:	9a650513          	addi	a0,a0,-1626 # 80007748 <syscalls+0x2a0>
    80003daa:	ef8fc0ef          	jal	ra,800004a2 <printf>
    80003dae:	b7c1                	j	80003d6e <fileinit+0x10>

0000000080003db0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003db0:	1101                	addi	sp,sp,-32
    80003db2:	ec06                	sd	ra,24(sp)
    80003db4:	e822                	sd	s0,16(sp)
    80003db6:	e426                	sd	s1,8(sp)
    80003db8:	1000                	addi	s0,sp,32
  debug("[FILE] filealloc\n"); // example of using debug, you can modify this
    80003dba:	1a3010ef          	jal	ra,8000575c <get_mode>
    80003dbe:	2501                	sext.w	a0,a0
    80003dc0:	e131                	bnez	a0,80003e04 <filealloc+0x54>
  //     return f;
  //   }
  // }
  // release(&ftable.lock);
  // return 0;
  acquire(&ftable.lock);
    80003dc2:	00038517          	auipc	a0,0x38
    80003dc6:	04650513          	addi	a0,a0,70 # 8003be08 <ftable>
    80003dca:	dd1fc0ef          	jal	ra,80000b9a <acquire>
  struct file *f = kmem_cache_alloc(file_cache);
    80003dce:	00004517          	auipc	a0,0x4
    80003dd2:	eea53503          	ld	a0,-278(a0) # 80007cb8 <file_cache>
    80003dd6:	67f010ef          	jal	ra,80005c54 <kmem_cache_alloc>
    80003dda:	84aa                	mv	s1,a0
  if (f) {
    80003ddc:	c91d                	beqz	a0,80003e12 <filealloc+0x62>
      memset(f, 0, sizeof(*f));
    80003dde:	1f800613          	li	a2,504
    80003de2:	4581                	li	a1,0
    80003de4:	e8bfc0ef          	jal	ra,80000c6e <memset>
      f->ref = 1;
    80003de8:	4785                	li	a5,1
    80003dea:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003dec:	00038517          	auipc	a0,0x38
    80003df0:	01c50513          	addi	a0,a0,28 # 8003be08 <ftable>
    80003df4:	e3ffc0ef          	jal	ra,80000c32 <release>
      return f;
  }
  release(&ftable.lock);
  return 0;
}
    80003df8:	8526                	mv	a0,s1
    80003dfa:	60e2                	ld	ra,24(sp)
    80003dfc:	6442                	ld	s0,16(sp)
    80003dfe:	64a2                	ld	s1,8(sp)
    80003e00:	6105                	addi	sp,sp,32
    80003e02:	8082                	ret
  debug("[FILE] filealloc\n"); // example of using debug, you can modify this
    80003e04:	00004517          	auipc	a0,0x4
    80003e08:	96c50513          	addi	a0,a0,-1684 # 80007770 <syscalls+0x2c8>
    80003e0c:	e96fc0ef          	jal	ra,800004a2 <printf>
    80003e10:	bf4d                	j	80003dc2 <filealloc+0x12>
  release(&ftable.lock);
    80003e12:	00038517          	auipc	a0,0x38
    80003e16:	ff650513          	addi	a0,a0,-10 # 8003be08 <ftable>
    80003e1a:	e19fc0ef          	jal	ra,80000c32 <release>
  return 0;
    80003e1e:	bfe9                	j	80003df8 <filealloc+0x48>

0000000080003e20 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003e20:	1101                	addi	sp,sp,-32
    80003e22:	ec06                	sd	ra,24(sp)
    80003e24:	e822                	sd	s0,16(sp)
    80003e26:	e426                	sd	s1,8(sp)
    80003e28:	1000                	addi	s0,sp,32
    80003e2a:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003e2c:	00038517          	auipc	a0,0x38
    80003e30:	fdc50513          	addi	a0,a0,-36 # 8003be08 <ftable>
    80003e34:	d67fc0ef          	jal	ra,80000b9a <acquire>
  if(f->ref < 1)
    80003e38:	40dc                	lw	a5,4(s1)
    80003e3a:	02f05063          	blez	a5,80003e5a <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80003e3e:	2785                	addiw	a5,a5,1
    80003e40:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003e42:	00038517          	auipc	a0,0x38
    80003e46:	fc650513          	addi	a0,a0,-58 # 8003be08 <ftable>
    80003e4a:	de9fc0ef          	jal	ra,80000c32 <release>
  return f;

}
    80003e4e:	8526                	mv	a0,s1
    80003e50:	60e2                	ld	ra,24(sp)
    80003e52:	6442                	ld	s0,16(sp)
    80003e54:	64a2                	ld	s1,8(sp)
    80003e56:	6105                	addi	sp,sp,32
    80003e58:	8082                	ret
    panic("filedup");
    80003e5a:	00004517          	auipc	a0,0x4
    80003e5e:	92e50513          	addi	a0,a0,-1746 # 80007788 <syscalls+0x2e0>
    80003e62:	8f5fc0ef          	jal	ra,80000756 <panic>

0000000080003e66 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003e66:	7139                	addi	sp,sp,-64
    80003e68:	fc06                	sd	ra,56(sp)
    80003e6a:	f822                	sd	s0,48(sp)
    80003e6c:	f426                	sd	s1,40(sp)
    80003e6e:	f04a                	sd	s2,32(sp)
    80003e70:	ec4e                	sd	s3,24(sp)
    80003e72:	e852                	sd	s4,16(sp)
    80003e74:	e456                	sd	s5,8(sp)
    80003e76:	0080                	addi	s0,sp,64
    80003e78:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003e7a:	00038517          	auipc	a0,0x38
    80003e7e:	f8e50513          	addi	a0,a0,-114 # 8003be08 <ftable>
    80003e82:	d19fc0ef          	jal	ra,80000b9a <acquire>
  if(f->ref < 1)
    80003e86:	40dc                	lw	a5,4(s1)
    80003e88:	06f05463          	blez	a5,80003ef0 <fileclose+0x8a>
    panic("fileclose");
  if(--f->ref > 0){
    80003e8c:	37fd                	addiw	a5,a5,-1
    80003e8e:	0007871b          	sext.w	a4,a5
    80003e92:	c0dc                	sw	a5,4(s1)
    80003e94:	06e04463          	bgtz	a4,80003efc <fileclose+0x96>
    release(&ftable.lock);
    return;
  }
  debug("[FILE] fileclose\n"); // example of using debug, you can modify this
    80003e98:	0c5010ef          	jal	ra,8000575c <get_mode>
    80003e9c:	2501                	sext.w	a0,a0
    80003e9e:	ed35                	bnez	a0,80003f1a <fileclose+0xb4>
  ff = *f;
    80003ea0:	0004a903          	lw	s2,0(s1)
    80003ea4:	0094ca83          	lbu	s5,9(s1)
    80003ea8:	0104ba03          	ld	s4,16(s1)
    80003eac:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003eb0:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003eb4:	0004a023          	sw	zero,0(s1)
  kmem_cache_free(file_cache, f);
    80003eb8:	85a6                	mv	a1,s1
    80003eba:	00004517          	auipc	a0,0x4
    80003ebe:	dfe53503          	ld	a0,-514(a0) # 80007cb8 <file_cache>
    80003ec2:	749010ef          	jal	ra,80005e0a <kmem_cache_free>
  release(&ftable.lock);
    80003ec6:	00038517          	auipc	a0,0x38
    80003eca:	f4250513          	addi	a0,a0,-190 # 8003be08 <ftable>
    80003ece:	d65fc0ef          	jal	ra,80000c32 <release>

  if(ff.type == FD_PIPE){
    80003ed2:	4785                	li	a5,1
    80003ed4:	04f90a63          	beq	s2,a5,80003f28 <fileclose+0xc2>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003ed8:	3979                	addiw	s2,s2,-2
    80003eda:	4785                	li	a5,1
    80003edc:	0327e663          	bltu	a5,s2,80003f08 <fileclose+0xa2>
    begin_op();
    80003ee0:	abdff0ef          	jal	ra,8000399c <begin_op>
    iput(ff.ip);
    80003ee4:	854e                	mv	a0,s3
    80003ee6:	baaff0ef          	jal	ra,80003290 <iput>
    end_op();
    80003eea:	b23ff0ef          	jal	ra,80003a0c <end_op>
    80003eee:	a829                	j	80003f08 <fileclose+0xa2>
    panic("fileclose");
    80003ef0:	00004517          	auipc	a0,0x4
    80003ef4:	8a050513          	addi	a0,a0,-1888 # 80007790 <syscalls+0x2e8>
    80003ef8:	85ffc0ef          	jal	ra,80000756 <panic>
    release(&ftable.lock);
    80003efc:	00038517          	auipc	a0,0x38
    80003f00:	f0c50513          	addi	a0,a0,-244 # 8003be08 <ftable>
    80003f04:	d2ffc0ef          	jal	ra,80000c32 <release>
  }
}
    80003f08:	70e2                	ld	ra,56(sp)
    80003f0a:	7442                	ld	s0,48(sp)
    80003f0c:	74a2                	ld	s1,40(sp)
    80003f0e:	7902                	ld	s2,32(sp)
    80003f10:	69e2                	ld	s3,24(sp)
    80003f12:	6a42                	ld	s4,16(sp)
    80003f14:	6aa2                	ld	s5,8(sp)
    80003f16:	6121                	addi	sp,sp,64
    80003f18:	8082                	ret
  debug("[FILE] fileclose\n"); // example of using debug, you can modify this
    80003f1a:	00004517          	auipc	a0,0x4
    80003f1e:	88650513          	addi	a0,a0,-1914 # 800077a0 <syscalls+0x2f8>
    80003f22:	d80fc0ef          	jal	ra,800004a2 <printf>
    80003f26:	bfad                	j	80003ea0 <fileclose+0x3a>
    pipeclose(ff.pipe, ff.writable);
    80003f28:	85d6                	mv	a1,s5
    80003f2a:	8552                	mv	a0,s4
    80003f2c:	2ec000ef          	jal	ra,80004218 <pipeclose>
    80003f30:	bfe1                	j	80003f08 <fileclose+0xa2>

0000000080003f32 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003f32:	715d                	addi	sp,sp,-80
    80003f34:	e486                	sd	ra,72(sp)
    80003f36:	e0a2                	sd	s0,64(sp)
    80003f38:	fc26                	sd	s1,56(sp)
    80003f3a:	f84a                	sd	s2,48(sp)
    80003f3c:	f44e                	sd	s3,40(sp)
    80003f3e:	0880                	addi	s0,sp,80
    80003f40:	84aa                	mv	s1,a0
    80003f42:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003f44:	915fd0ef          	jal	ra,80001858 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003f48:	409c                	lw	a5,0(s1)
    80003f4a:	37f9                	addiw	a5,a5,-2
    80003f4c:	4705                	li	a4,1
    80003f4e:	02f76f63          	bltu	a4,a5,80003f8c <filestat+0x5a>
    80003f52:	892a                	mv	s2,a0
    ilock(f->ip);
    80003f54:	6c88                	ld	a0,24(s1)
    80003f56:	9bcff0ef          	jal	ra,80003112 <ilock>
    stati(f->ip, &st);
    80003f5a:	fb840593          	addi	a1,s0,-72
    80003f5e:	6c88                	ld	a0,24(s1)
    80003f60:	bd8ff0ef          	jal	ra,80003338 <stati>
    iunlock(f->ip);
    80003f64:	6c88                	ld	a0,24(s1)
    80003f66:	a56ff0ef          	jal	ra,800031bc <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003f6a:	46e1                	li	a3,24
    80003f6c:	fb840613          	addi	a2,s0,-72
    80003f70:	85ce                	mv	a1,s3
    80003f72:	05093503          	ld	a0,80(s2)
    80003f76:	d96fd0ef          	jal	ra,8000150c <copyout>
    80003f7a:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003f7e:	60a6                	ld	ra,72(sp)
    80003f80:	6406                	ld	s0,64(sp)
    80003f82:	74e2                	ld	s1,56(sp)
    80003f84:	7942                	ld	s2,48(sp)
    80003f86:	79a2                	ld	s3,40(sp)
    80003f88:	6161                	addi	sp,sp,80
    80003f8a:	8082                	ret
  return -1;
    80003f8c:	557d                	li	a0,-1
    80003f8e:	bfc5                	j	80003f7e <filestat+0x4c>

0000000080003f90 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003f90:	7179                	addi	sp,sp,-48
    80003f92:	f406                	sd	ra,40(sp)
    80003f94:	f022                	sd	s0,32(sp)
    80003f96:	ec26                	sd	s1,24(sp)
    80003f98:	e84a                	sd	s2,16(sp)
    80003f9a:	e44e                	sd	s3,8(sp)
    80003f9c:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003f9e:	00854783          	lbu	a5,8(a0)
    80003fa2:	cbc1                	beqz	a5,80004032 <fileread+0xa2>
    80003fa4:	84aa                	mv	s1,a0
    80003fa6:	89ae                	mv	s3,a1
    80003fa8:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003faa:	411c                	lw	a5,0(a0)
    80003fac:	4705                	li	a4,1
    80003fae:	04e78363          	beq	a5,a4,80003ff4 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003fb2:	470d                	li	a4,3
    80003fb4:	04e78563          	beq	a5,a4,80003ffe <fileread+0x6e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003fb8:	4709                	li	a4,2
    80003fba:	06e79663          	bne	a5,a4,80004026 <fileread+0x96>
    ilock(f->ip);
    80003fbe:	6d08                	ld	a0,24(a0)
    80003fc0:	952ff0ef          	jal	ra,80003112 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003fc4:	874a                	mv	a4,s2
    80003fc6:	5094                	lw	a3,32(s1)
    80003fc8:	864e                	mv	a2,s3
    80003fca:	4585                	li	a1,1
    80003fcc:	6c88                	ld	a0,24(s1)
    80003fce:	b94ff0ef          	jal	ra,80003362 <readi>
    80003fd2:	892a                	mv	s2,a0
    80003fd4:	00a05563          	blez	a0,80003fde <fileread+0x4e>
      f->off += r;
    80003fd8:	509c                	lw	a5,32(s1)
    80003fda:	9fa9                	addw	a5,a5,a0
    80003fdc:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003fde:	6c88                	ld	a0,24(s1)
    80003fe0:	9dcff0ef          	jal	ra,800031bc <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003fe4:	854a                	mv	a0,s2
    80003fe6:	70a2                	ld	ra,40(sp)
    80003fe8:	7402                	ld	s0,32(sp)
    80003fea:	64e2                	ld	s1,24(sp)
    80003fec:	6942                	ld	s2,16(sp)
    80003fee:	69a2                	ld	s3,8(sp)
    80003ff0:	6145                	addi	sp,sp,48
    80003ff2:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003ff4:	6908                	ld	a0,16(a0)
    80003ff6:	34e000ef          	jal	ra,80004344 <piperead>
    80003ffa:	892a                	mv	s2,a0
    80003ffc:	b7e5                	j	80003fe4 <fileread+0x54>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003ffe:	02451783          	lh	a5,36(a0)
    80004002:	03079693          	slli	a3,a5,0x30
    80004006:	92c1                	srli	a3,a3,0x30
    80004008:	4725                	li	a4,9
    8000400a:	02d76663          	bltu	a4,a3,80004036 <fileread+0xa6>
    8000400e:	0792                	slli	a5,a5,0x4
    80004010:	00038717          	auipc	a4,0x38
    80004014:	df870713          	addi	a4,a4,-520 # 8003be08 <ftable>
    80004018:	97ba                	add	a5,a5,a4
    8000401a:	6f9c                	ld	a5,24(a5)
    8000401c:	cf99                	beqz	a5,8000403a <fileread+0xaa>
    r = devsw[f->major].read(1, addr, n);
    8000401e:	4505                	li	a0,1
    80004020:	9782                	jalr	a5
    80004022:	892a                	mv	s2,a0
    80004024:	b7c1                	j	80003fe4 <fileread+0x54>
    panic("fileread");
    80004026:	00003517          	auipc	a0,0x3
    8000402a:	79250513          	addi	a0,a0,1938 # 800077b8 <syscalls+0x310>
    8000402e:	f28fc0ef          	jal	ra,80000756 <panic>
    return -1;
    80004032:	597d                	li	s2,-1
    80004034:	bf45                	j	80003fe4 <fileread+0x54>
      return -1;
    80004036:	597d                	li	s2,-1
    80004038:	b775                	j	80003fe4 <fileread+0x54>
    8000403a:	597d                	li	s2,-1
    8000403c:	b765                	j	80003fe4 <fileread+0x54>

000000008000403e <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    8000403e:	715d                	addi	sp,sp,-80
    80004040:	e486                	sd	ra,72(sp)
    80004042:	e0a2                	sd	s0,64(sp)
    80004044:	fc26                	sd	s1,56(sp)
    80004046:	f84a                	sd	s2,48(sp)
    80004048:	f44e                	sd	s3,40(sp)
    8000404a:	f052                	sd	s4,32(sp)
    8000404c:	ec56                	sd	s5,24(sp)
    8000404e:	e85a                	sd	s6,16(sp)
    80004050:	e45e                	sd	s7,8(sp)
    80004052:	e062                	sd	s8,0(sp)
    80004054:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80004056:	00954783          	lbu	a5,9(a0)
    8000405a:	0e078863          	beqz	a5,8000414a <filewrite+0x10c>
    8000405e:	892a                	mv	s2,a0
    80004060:	8aae                	mv	s5,a1
    80004062:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004064:	411c                	lw	a5,0(a0)
    80004066:	4705                	li	a4,1
    80004068:	02e78263          	beq	a5,a4,8000408c <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000406c:	470d                	li	a4,3
    8000406e:	02e78463          	beq	a5,a4,80004096 <filewrite+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004072:	4709                	li	a4,2
    80004074:	0ce79563          	bne	a5,a4,8000413e <filewrite+0x100>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004078:	0ac05163          	blez	a2,8000411a <filewrite+0xdc>
    int i = 0;
    8000407c:	4981                	li	s3,0
    8000407e:	6b05                	lui	s6,0x1
    80004080:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80004084:	6b85                	lui	s7,0x1
    80004086:	c00b8b9b          	addiw	s7,s7,-1024
    8000408a:	a041                	j	8000410a <filewrite+0xcc>
    ret = pipewrite(f->pipe, addr, n);
    8000408c:	6908                	ld	a0,16(a0)
    8000408e:	1e2000ef          	jal	ra,80004270 <pipewrite>
    80004092:	8a2a                	mv	s4,a0
    80004094:	a071                	j	80004120 <filewrite+0xe2>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004096:	02451783          	lh	a5,36(a0)
    8000409a:	03079693          	slli	a3,a5,0x30
    8000409e:	92c1                	srli	a3,a3,0x30
    800040a0:	4725                	li	a4,9
    800040a2:	0ad76663          	bltu	a4,a3,8000414e <filewrite+0x110>
    800040a6:	0792                	slli	a5,a5,0x4
    800040a8:	00038717          	auipc	a4,0x38
    800040ac:	d6070713          	addi	a4,a4,-672 # 8003be08 <ftable>
    800040b0:	97ba                	add	a5,a5,a4
    800040b2:	739c                	ld	a5,32(a5)
    800040b4:	cfd9                	beqz	a5,80004152 <filewrite+0x114>
    ret = devsw[f->major].write(1, addr, n);
    800040b6:	4505                	li	a0,1
    800040b8:	9782                	jalr	a5
    800040ba:	8a2a                	mv	s4,a0
    800040bc:	a095                	j	80004120 <filewrite+0xe2>
    800040be:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    800040c2:	8dbff0ef          	jal	ra,8000399c <begin_op>
      ilock(f->ip);
    800040c6:	01893503          	ld	a0,24(s2)
    800040ca:	848ff0ef          	jal	ra,80003112 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800040ce:	8762                	mv	a4,s8
    800040d0:	02092683          	lw	a3,32(s2)
    800040d4:	01598633          	add	a2,s3,s5
    800040d8:	4585                	li	a1,1
    800040da:	01893503          	ld	a0,24(s2)
    800040de:	b68ff0ef          	jal	ra,80003446 <writei>
    800040e2:	84aa                	mv	s1,a0
    800040e4:	00a05763          	blez	a0,800040f2 <filewrite+0xb4>
        f->off += r;
    800040e8:	02092783          	lw	a5,32(s2)
    800040ec:	9fa9                	addw	a5,a5,a0
    800040ee:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    800040f2:	01893503          	ld	a0,24(s2)
    800040f6:	8c6ff0ef          	jal	ra,800031bc <iunlock>
      end_op();
    800040fa:	913ff0ef          	jal	ra,80003a0c <end_op>

      if(r != n1){
    800040fe:	009c1f63          	bne	s8,s1,8000411c <filewrite+0xde>
        // error from writei
        break;
      }
      i += r;
    80004102:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004106:	0149db63          	bge	s3,s4,8000411c <filewrite+0xde>
      int n1 = n - i;
    8000410a:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    8000410e:	84be                	mv	s1,a5
    80004110:	2781                	sext.w	a5,a5
    80004112:	fafb56e3          	bge	s6,a5,800040be <filewrite+0x80>
    80004116:	84de                	mv	s1,s7
    80004118:	b75d                	j	800040be <filewrite+0x80>
    int i = 0;
    8000411a:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    8000411c:	013a1f63          	bne	s4,s3,8000413a <filewrite+0xfc>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004120:	8552                	mv	a0,s4
    80004122:	60a6                	ld	ra,72(sp)
    80004124:	6406                	ld	s0,64(sp)
    80004126:	74e2                	ld	s1,56(sp)
    80004128:	7942                	ld	s2,48(sp)
    8000412a:	79a2                	ld	s3,40(sp)
    8000412c:	7a02                	ld	s4,32(sp)
    8000412e:	6ae2                	ld	s5,24(sp)
    80004130:	6b42                	ld	s6,16(sp)
    80004132:	6ba2                	ld	s7,8(sp)
    80004134:	6c02                	ld	s8,0(sp)
    80004136:	6161                	addi	sp,sp,80
    80004138:	8082                	ret
    ret = (i == n ? n : -1);
    8000413a:	5a7d                	li	s4,-1
    8000413c:	b7d5                	j	80004120 <filewrite+0xe2>
    panic("filewrite");
    8000413e:	00003517          	auipc	a0,0x3
    80004142:	68a50513          	addi	a0,a0,1674 # 800077c8 <syscalls+0x320>
    80004146:	e10fc0ef          	jal	ra,80000756 <panic>
    return -1;
    8000414a:	5a7d                	li	s4,-1
    8000414c:	bfd1                	j	80004120 <filewrite+0xe2>
      return -1;
    8000414e:	5a7d                	li	s4,-1
    80004150:	bfc1                	j	80004120 <filewrite+0xe2>
    80004152:	5a7d                	li	s4,-1
    80004154:	b7f1                	j	80004120 <filewrite+0xe2>

0000000080004156 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004156:	7179                	addi	sp,sp,-48
    80004158:	f406                	sd	ra,40(sp)
    8000415a:	f022                	sd	s0,32(sp)
    8000415c:	ec26                	sd	s1,24(sp)
    8000415e:	e84a                	sd	s2,16(sp)
    80004160:	e44e                	sd	s3,8(sp)
    80004162:	e052                	sd	s4,0(sp)
    80004164:	1800                	addi	s0,sp,48
    80004166:	84aa                	mv	s1,a0
    80004168:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    8000416a:	0005b023          	sd	zero,0(a1)
    8000416e:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004172:	c3fff0ef          	jal	ra,80003db0 <filealloc>
    80004176:	e088                	sd	a0,0(s1)
    80004178:	cd35                	beqz	a0,800041f4 <pipealloc+0x9e>
    8000417a:	c37ff0ef          	jal	ra,80003db0 <filealloc>
    8000417e:	00aa3023          	sd	a0,0(s4)
    80004182:	c52d                	beqz	a0,800041ec <pipealloc+0x96>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004184:	947fc0ef          	jal	ra,80000aca <kalloc>
    80004188:	892a                	mv	s2,a0
    8000418a:	cd31                	beqz	a0,800041e6 <pipealloc+0x90>
    goto bad;
  pi->readopen = 1;
    8000418c:	4985                	li	s3,1
    8000418e:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004192:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004196:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    8000419a:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    8000419e:	00003597          	auipc	a1,0x3
    800041a2:	63a58593          	addi	a1,a1,1594 # 800077d8 <syscalls+0x330>
    800041a6:	975fc0ef          	jal	ra,80000b1a <initlock>
  (*f0)->type = FD_PIPE;
    800041aa:	609c                	ld	a5,0(s1)
    800041ac:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800041b0:	609c                	ld	a5,0(s1)
    800041b2:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    800041b6:	609c                	ld	a5,0(s1)
    800041b8:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    800041bc:	609c                	ld	a5,0(s1)
    800041be:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    800041c2:	000a3783          	ld	a5,0(s4)
    800041c6:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800041ca:	000a3783          	ld	a5,0(s4)
    800041ce:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800041d2:	000a3783          	ld	a5,0(s4)
    800041d6:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800041da:	000a3783          	ld	a5,0(s4)
    800041de:	0127b823          	sd	s2,16(a5)
  return 0;
    800041e2:	4501                	li	a0,0
    800041e4:	a005                	j	80004204 <pipealloc+0xae>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800041e6:	6088                	ld	a0,0(s1)
    800041e8:	e501                	bnez	a0,800041f0 <pipealloc+0x9a>
    800041ea:	a029                	j	800041f4 <pipealloc+0x9e>
    800041ec:	6088                	ld	a0,0(s1)
    800041ee:	c11d                	beqz	a0,80004214 <pipealloc+0xbe>
    fileclose(*f0);
    800041f0:	c77ff0ef          	jal	ra,80003e66 <fileclose>
  if(*f1)
    800041f4:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800041f8:	557d                	li	a0,-1
  if(*f1)
    800041fa:	c789                	beqz	a5,80004204 <pipealloc+0xae>
    fileclose(*f1);
    800041fc:	853e                	mv	a0,a5
    800041fe:	c69ff0ef          	jal	ra,80003e66 <fileclose>
  return -1;
    80004202:	557d                	li	a0,-1
}
    80004204:	70a2                	ld	ra,40(sp)
    80004206:	7402                	ld	s0,32(sp)
    80004208:	64e2                	ld	s1,24(sp)
    8000420a:	6942                	ld	s2,16(sp)
    8000420c:	69a2                	ld	s3,8(sp)
    8000420e:	6a02                	ld	s4,0(sp)
    80004210:	6145                	addi	sp,sp,48
    80004212:	8082                	ret
  return -1;
    80004214:	557d                	li	a0,-1
    80004216:	b7fd                	j	80004204 <pipealloc+0xae>

0000000080004218 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004218:	1101                	addi	sp,sp,-32
    8000421a:	ec06                	sd	ra,24(sp)
    8000421c:	e822                	sd	s0,16(sp)
    8000421e:	e426                	sd	s1,8(sp)
    80004220:	e04a                	sd	s2,0(sp)
    80004222:	1000                	addi	s0,sp,32
    80004224:	84aa                	mv	s1,a0
    80004226:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004228:	973fc0ef          	jal	ra,80000b9a <acquire>
  if(writable){
    8000422c:	02090763          	beqz	s2,8000425a <pipeclose+0x42>
    pi->writeopen = 0;
    80004230:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004234:	21848513          	addi	a0,s1,536
    80004238:	c39fd0ef          	jal	ra,80001e70 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    8000423c:	2204b783          	ld	a5,544(s1)
    80004240:	e785                	bnez	a5,80004268 <pipeclose+0x50>
    release(&pi->lock);
    80004242:	8526                	mv	a0,s1
    80004244:	9effc0ef          	jal	ra,80000c32 <release>
    kfree((char*)pi);
    80004248:	8526                	mv	a0,s1
    8000424a:	fa0fc0ef          	jal	ra,800009ea <kfree>
  } else
    release(&pi->lock);
}
    8000424e:	60e2                	ld	ra,24(sp)
    80004250:	6442                	ld	s0,16(sp)
    80004252:	64a2                	ld	s1,8(sp)
    80004254:	6902                	ld	s2,0(sp)
    80004256:	6105                	addi	sp,sp,32
    80004258:	8082                	ret
    pi->readopen = 0;
    8000425a:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    8000425e:	21c48513          	addi	a0,s1,540
    80004262:	c0ffd0ef          	jal	ra,80001e70 <wakeup>
    80004266:	bfd9                	j	8000423c <pipeclose+0x24>
    release(&pi->lock);
    80004268:	8526                	mv	a0,s1
    8000426a:	9c9fc0ef          	jal	ra,80000c32 <release>
}
    8000426e:	b7c5                	j	8000424e <pipeclose+0x36>

0000000080004270 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004270:	711d                	addi	sp,sp,-96
    80004272:	ec86                	sd	ra,88(sp)
    80004274:	e8a2                	sd	s0,80(sp)
    80004276:	e4a6                	sd	s1,72(sp)
    80004278:	e0ca                	sd	s2,64(sp)
    8000427a:	fc4e                	sd	s3,56(sp)
    8000427c:	f852                	sd	s4,48(sp)
    8000427e:	f456                	sd	s5,40(sp)
    80004280:	f05a                	sd	s6,32(sp)
    80004282:	ec5e                	sd	s7,24(sp)
    80004284:	e862                	sd	s8,16(sp)
    80004286:	1080                	addi	s0,sp,96
    80004288:	84aa                	mv	s1,a0
    8000428a:	8aae                	mv	s5,a1
    8000428c:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    8000428e:	dcafd0ef          	jal	ra,80001858 <myproc>
    80004292:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004294:	8526                	mv	a0,s1
    80004296:	905fc0ef          	jal	ra,80000b9a <acquire>
  while(i < n){
    8000429a:	09405c63          	blez	s4,80004332 <pipewrite+0xc2>
  int i = 0;
    8000429e:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800042a0:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800042a2:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800042a6:	21c48b93          	addi	s7,s1,540
    800042aa:	a81d                	j	800042e0 <pipewrite+0x70>
      release(&pi->lock);
    800042ac:	8526                	mv	a0,s1
    800042ae:	985fc0ef          	jal	ra,80000c32 <release>
      return -1;
    800042b2:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800042b4:	854a                	mv	a0,s2
    800042b6:	60e6                	ld	ra,88(sp)
    800042b8:	6446                	ld	s0,80(sp)
    800042ba:	64a6                	ld	s1,72(sp)
    800042bc:	6906                	ld	s2,64(sp)
    800042be:	79e2                	ld	s3,56(sp)
    800042c0:	7a42                	ld	s4,48(sp)
    800042c2:	7aa2                	ld	s5,40(sp)
    800042c4:	7b02                	ld	s6,32(sp)
    800042c6:	6be2                	ld	s7,24(sp)
    800042c8:	6c42                	ld	s8,16(sp)
    800042ca:	6125                	addi	sp,sp,96
    800042cc:	8082                	ret
      wakeup(&pi->nread);
    800042ce:	8562                	mv	a0,s8
    800042d0:	ba1fd0ef          	jal	ra,80001e70 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800042d4:	85a6                	mv	a1,s1
    800042d6:	855e                	mv	a0,s7
    800042d8:	b4dfd0ef          	jal	ra,80001e24 <sleep>
  while(i < n){
    800042dc:	05495c63          	bge	s2,s4,80004334 <pipewrite+0xc4>
    if(pi->readopen == 0 || killed(pr)){
    800042e0:	2204a783          	lw	a5,544(s1)
    800042e4:	d7e1                	beqz	a5,800042ac <pipewrite+0x3c>
    800042e6:	854e                	mv	a0,s3
    800042e8:	d75fd0ef          	jal	ra,8000205c <killed>
    800042ec:	f161                	bnez	a0,800042ac <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800042ee:	2184a783          	lw	a5,536(s1)
    800042f2:	21c4a703          	lw	a4,540(s1)
    800042f6:	2007879b          	addiw	a5,a5,512
    800042fa:	fcf70ae3          	beq	a4,a5,800042ce <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800042fe:	4685                	li	a3,1
    80004300:	01590633          	add	a2,s2,s5
    80004304:	faf40593          	addi	a1,s0,-81
    80004308:	0509b503          	ld	a0,80(s3)
    8000430c:	ab8fd0ef          	jal	ra,800015c4 <copyin>
    80004310:	03650263          	beq	a0,s6,80004334 <pipewrite+0xc4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004314:	21c4a783          	lw	a5,540(s1)
    80004318:	0017871b          	addiw	a4,a5,1
    8000431c:	20e4ae23          	sw	a4,540(s1)
    80004320:	1ff7f793          	andi	a5,a5,511
    80004324:	97a6                	add	a5,a5,s1
    80004326:	faf44703          	lbu	a4,-81(s0)
    8000432a:	00e78c23          	sb	a4,24(a5)
      i++;
    8000432e:	2905                	addiw	s2,s2,1
    80004330:	b775                	j	800042dc <pipewrite+0x6c>
  int i = 0;
    80004332:	4901                	li	s2,0
  wakeup(&pi->nread);
    80004334:	21848513          	addi	a0,s1,536
    80004338:	b39fd0ef          	jal	ra,80001e70 <wakeup>
  release(&pi->lock);
    8000433c:	8526                	mv	a0,s1
    8000433e:	8f5fc0ef          	jal	ra,80000c32 <release>
  return i;
    80004342:	bf8d                	j	800042b4 <pipewrite+0x44>

0000000080004344 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004344:	715d                	addi	sp,sp,-80
    80004346:	e486                	sd	ra,72(sp)
    80004348:	e0a2                	sd	s0,64(sp)
    8000434a:	fc26                	sd	s1,56(sp)
    8000434c:	f84a                	sd	s2,48(sp)
    8000434e:	f44e                	sd	s3,40(sp)
    80004350:	f052                	sd	s4,32(sp)
    80004352:	ec56                	sd	s5,24(sp)
    80004354:	e85a                	sd	s6,16(sp)
    80004356:	0880                	addi	s0,sp,80
    80004358:	84aa                	mv	s1,a0
    8000435a:	892e                	mv	s2,a1
    8000435c:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000435e:	cfafd0ef          	jal	ra,80001858 <myproc>
    80004362:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004364:	8526                	mv	a0,s1
    80004366:	835fc0ef          	jal	ra,80000b9a <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000436a:	2184a703          	lw	a4,536(s1)
    8000436e:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004372:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004376:	02f71363          	bne	a4,a5,8000439c <piperead+0x58>
    8000437a:	2244a783          	lw	a5,548(s1)
    8000437e:	cf99                	beqz	a5,8000439c <piperead+0x58>
    if(killed(pr)){
    80004380:	8552                	mv	a0,s4
    80004382:	cdbfd0ef          	jal	ra,8000205c <killed>
    80004386:	e141                	bnez	a0,80004406 <piperead+0xc2>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004388:	85a6                	mv	a1,s1
    8000438a:	854e                	mv	a0,s3
    8000438c:	a99fd0ef          	jal	ra,80001e24 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004390:	2184a703          	lw	a4,536(s1)
    80004394:	21c4a783          	lw	a5,540(s1)
    80004398:	fef701e3          	beq	a4,a5,8000437a <piperead+0x36>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000439c:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000439e:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800043a0:	05505163          	blez	s5,800043e2 <piperead+0x9e>
    if(pi->nread == pi->nwrite)
    800043a4:	2184a783          	lw	a5,536(s1)
    800043a8:	21c4a703          	lw	a4,540(s1)
    800043ac:	02f70b63          	beq	a4,a5,800043e2 <piperead+0x9e>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800043b0:	0017871b          	addiw	a4,a5,1
    800043b4:	20e4ac23          	sw	a4,536(s1)
    800043b8:	1ff7f793          	andi	a5,a5,511
    800043bc:	97a6                	add	a5,a5,s1
    800043be:	0187c783          	lbu	a5,24(a5)
    800043c2:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800043c6:	4685                	li	a3,1
    800043c8:	fbf40613          	addi	a2,s0,-65
    800043cc:	85ca                	mv	a1,s2
    800043ce:	050a3503          	ld	a0,80(s4)
    800043d2:	93afd0ef          	jal	ra,8000150c <copyout>
    800043d6:	01650663          	beq	a0,s6,800043e2 <piperead+0x9e>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800043da:	2985                	addiw	s3,s3,1
    800043dc:	0905                	addi	s2,s2,1
    800043de:	fd3a93e3          	bne	s5,s3,800043a4 <piperead+0x60>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800043e2:	21c48513          	addi	a0,s1,540
    800043e6:	a8bfd0ef          	jal	ra,80001e70 <wakeup>
  release(&pi->lock);
    800043ea:	8526                	mv	a0,s1
    800043ec:	847fc0ef          	jal	ra,80000c32 <release>
  return i;
}
    800043f0:	854e                	mv	a0,s3
    800043f2:	60a6                	ld	ra,72(sp)
    800043f4:	6406                	ld	s0,64(sp)
    800043f6:	74e2                	ld	s1,56(sp)
    800043f8:	7942                	ld	s2,48(sp)
    800043fa:	79a2                	ld	s3,40(sp)
    800043fc:	7a02                	ld	s4,32(sp)
    800043fe:	6ae2                	ld	s5,24(sp)
    80004400:	6b42                	ld	s6,16(sp)
    80004402:	6161                	addi	sp,sp,80
    80004404:	8082                	ret
      release(&pi->lock);
    80004406:	8526                	mv	a0,s1
    80004408:	82bfc0ef          	jal	ra,80000c32 <release>
      return -1;
    8000440c:	59fd                	li	s3,-1
    8000440e:	b7cd                	j	800043f0 <piperead+0xac>

0000000080004410 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004410:	1141                	addi	sp,sp,-16
    80004412:	e422                	sd	s0,8(sp)
    80004414:	0800                	addi	s0,sp,16
    80004416:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004418:	8905                	andi	a0,a0,1
    8000441a:	c111                	beqz	a0,8000441e <flags2perm+0xe>
      perm = PTE_X;
    8000441c:	4521                	li	a0,8
    if(flags & 0x2)
    8000441e:	8b89                	andi	a5,a5,2
    80004420:	c399                	beqz	a5,80004426 <flags2perm+0x16>
      perm |= PTE_W;
    80004422:	00456513          	ori	a0,a0,4
    return perm;
}
    80004426:	6422                	ld	s0,8(sp)
    80004428:	0141                	addi	sp,sp,16
    8000442a:	8082                	ret

000000008000442c <exec>:

int
exec(char *path, char **argv)
{
    8000442c:	de010113          	addi	sp,sp,-544
    80004430:	20113c23          	sd	ra,536(sp)
    80004434:	20813823          	sd	s0,528(sp)
    80004438:	20913423          	sd	s1,520(sp)
    8000443c:	21213023          	sd	s2,512(sp)
    80004440:	ffce                	sd	s3,504(sp)
    80004442:	fbd2                	sd	s4,496(sp)
    80004444:	f7d6                	sd	s5,488(sp)
    80004446:	f3da                	sd	s6,480(sp)
    80004448:	efde                	sd	s7,472(sp)
    8000444a:	ebe2                	sd	s8,464(sp)
    8000444c:	e7e6                	sd	s9,456(sp)
    8000444e:	e3ea                	sd	s10,448(sp)
    80004450:	ff6e                	sd	s11,440(sp)
    80004452:	1400                	addi	s0,sp,544
    80004454:	892a                	mv	s2,a0
    80004456:	dea43423          	sd	a0,-536(s0)
    8000445a:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000445e:	bfafd0ef          	jal	ra,80001858 <myproc>
    80004462:	84aa                	mv	s1,a0

  begin_op();
    80004464:	d38ff0ef          	jal	ra,8000399c <begin_op>

  if((ip = namei(path)) == 0){
    80004468:	854a                	mv	a0,s2
    8000446a:	b5aff0ef          	jal	ra,800037c4 <namei>
    8000446e:	c13d                	beqz	a0,800044d4 <exec+0xa8>
    80004470:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004472:	ca1fe0ef          	jal	ra,80003112 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004476:	04000713          	li	a4,64
    8000447a:	4681                	li	a3,0
    8000447c:	e5040613          	addi	a2,s0,-432
    80004480:	4581                	li	a1,0
    80004482:	8556                	mv	a0,s5
    80004484:	edffe0ef          	jal	ra,80003362 <readi>
    80004488:	04000793          	li	a5,64
    8000448c:	00f51a63          	bne	a0,a5,800044a0 <exec+0x74>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80004490:	e5042703          	lw	a4,-432(s0)
    80004494:	464c47b7          	lui	a5,0x464c4
    80004498:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000449c:	04f70063          	beq	a4,a5,800044dc <exec+0xb0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800044a0:	8556                	mv	a0,s5
    800044a2:	e77fe0ef          	jal	ra,80003318 <iunlockput>
    end_op();
    800044a6:	d66ff0ef          	jal	ra,80003a0c <end_op>
  }
  return -1;
    800044aa:	557d                	li	a0,-1
}
    800044ac:	21813083          	ld	ra,536(sp)
    800044b0:	21013403          	ld	s0,528(sp)
    800044b4:	20813483          	ld	s1,520(sp)
    800044b8:	20013903          	ld	s2,512(sp)
    800044bc:	79fe                	ld	s3,504(sp)
    800044be:	7a5e                	ld	s4,496(sp)
    800044c0:	7abe                	ld	s5,488(sp)
    800044c2:	7b1e                	ld	s6,480(sp)
    800044c4:	6bfe                	ld	s7,472(sp)
    800044c6:	6c5e                	ld	s8,464(sp)
    800044c8:	6cbe                	ld	s9,456(sp)
    800044ca:	6d1e                	ld	s10,448(sp)
    800044cc:	7dfa                	ld	s11,440(sp)
    800044ce:	22010113          	addi	sp,sp,544
    800044d2:	8082                	ret
    end_op();
    800044d4:	d38ff0ef          	jal	ra,80003a0c <end_op>
    return -1;
    800044d8:	557d                	li	a0,-1
    800044da:	bfc9                	j	800044ac <exec+0x80>
  if((pagetable = proc_pagetable(p)) == 0)
    800044dc:	8526                	mv	a0,s1
    800044de:	c22fd0ef          	jal	ra,80001900 <proc_pagetable>
    800044e2:	8b2a                	mv	s6,a0
    800044e4:	dd55                	beqz	a0,800044a0 <exec+0x74>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800044e6:	e7042783          	lw	a5,-400(s0)
    800044ea:	e8845703          	lhu	a4,-376(s0)
    800044ee:	c325                	beqz	a4,8000454e <exec+0x122>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800044f0:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800044f2:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    800044f6:	6a05                	lui	s4,0x1
    800044f8:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    800044fc:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    80004500:	6d85                	lui	s11,0x1
    80004502:	7d7d                	lui	s10,0xfffff
    80004504:	a411                	j	80004708 <exec+0x2dc>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004506:	00003517          	auipc	a0,0x3
    8000450a:	2da50513          	addi	a0,a0,730 # 800077e0 <syscalls+0x338>
    8000450e:	a48fc0ef          	jal	ra,80000756 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004512:	874a                	mv	a4,s2
    80004514:	009c86bb          	addw	a3,s9,s1
    80004518:	4581                	li	a1,0
    8000451a:	8556                	mv	a0,s5
    8000451c:	e47fe0ef          	jal	ra,80003362 <readi>
    80004520:	2501                	sext.w	a0,a0
    80004522:	18a91263          	bne	s2,a0,800046a6 <exec+0x27a>
  for(i = 0; i < sz; i += PGSIZE){
    80004526:	009d84bb          	addw	s1,s11,s1
    8000452a:	013d09bb          	addw	s3,s10,s3
    8000452e:	1b74fd63          	bgeu	s1,s7,800046e8 <exec+0x2bc>
    pa = walkaddr(pagetable, va + i);
    80004532:	02049593          	slli	a1,s1,0x20
    80004536:	9181                	srli	a1,a1,0x20
    80004538:	95e2                	add	a1,a1,s8
    8000453a:	855a                	mv	a0,s6
    8000453c:	a75fc0ef          	jal	ra,80000fb0 <walkaddr>
    80004540:	862a                	mv	a2,a0
    if(pa == 0)
    80004542:	d171                	beqz	a0,80004506 <exec+0xda>
      n = PGSIZE;
    80004544:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    80004546:	fd49f6e3          	bgeu	s3,s4,80004512 <exec+0xe6>
      n = sz - i;
    8000454a:	894e                	mv	s2,s3
    8000454c:	b7d9                	j	80004512 <exec+0xe6>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000454e:	4901                	li	s2,0
  iunlockput(ip);
    80004550:	8556                	mv	a0,s5
    80004552:	dc7fe0ef          	jal	ra,80003318 <iunlockput>
  end_op();
    80004556:	cb6ff0ef          	jal	ra,80003a0c <end_op>
  p = myproc();
    8000455a:	afefd0ef          	jal	ra,80001858 <myproc>
    8000455e:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80004560:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004564:	6785                	lui	a5,0x1
    80004566:	17fd                	addi	a5,a5,-1
    80004568:	993e                	add	s2,s2,a5
    8000456a:	77fd                	lui	a5,0xfffff
    8000456c:	00f977b3          	and	a5,s2,a5
    80004570:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80004574:	4691                	li	a3,4
    80004576:	6609                	lui	a2,0x2
    80004578:	963e                	add	a2,a2,a5
    8000457a:	85be                	mv	a1,a5
    8000457c:	855a                	mv	a0,s6
    8000457e:	d8bfc0ef          	jal	ra,80001308 <uvmalloc>
    80004582:	8c2a                	mv	s8,a0
  ip = 0;
    80004584:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80004586:	12050063          	beqz	a0,800046a6 <exec+0x27a>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    8000458a:	75f9                	lui	a1,0xffffe
    8000458c:	95aa                	add	a1,a1,a0
    8000458e:	855a                	mv	a0,s6
    80004590:	f53fc0ef          	jal	ra,800014e2 <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80004594:	7afd                	lui	s5,0xfffff
    80004596:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    80004598:	df043783          	ld	a5,-528(s0)
    8000459c:	6388                	ld	a0,0(a5)
    8000459e:	c135                	beqz	a0,80004602 <exec+0x1d6>
    800045a0:	e9040993          	addi	s3,s0,-368
    800045a4:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    800045a8:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    800045aa:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800045ac:	83bfc0ef          	jal	ra,80000de6 <strlen>
    800045b0:	0015079b          	addiw	a5,a0,1
    800045b4:	40f90933          	sub	s2,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800045b8:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    800045bc:	11596a63          	bltu	s2,s5,800046d0 <exec+0x2a4>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800045c0:	df043d83          	ld	s11,-528(s0)
    800045c4:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    800045c8:	8552                	mv	a0,s4
    800045ca:	81dfc0ef          	jal	ra,80000de6 <strlen>
    800045ce:	0015069b          	addiw	a3,a0,1
    800045d2:	8652                	mv	a2,s4
    800045d4:	85ca                	mv	a1,s2
    800045d6:	855a                	mv	a0,s6
    800045d8:	f35fc0ef          	jal	ra,8000150c <copyout>
    800045dc:	0e054e63          	bltz	a0,800046d8 <exec+0x2ac>
    ustack[argc] = sp;
    800045e0:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800045e4:	0485                	addi	s1,s1,1
    800045e6:	008d8793          	addi	a5,s11,8
    800045ea:	def43823          	sd	a5,-528(s0)
    800045ee:	008db503          	ld	a0,8(s11)
    800045f2:	c911                	beqz	a0,80004606 <exec+0x1da>
    if(argc >= MAXARG)
    800045f4:	09a1                	addi	s3,s3,8
    800045f6:	fb3c9be3          	bne	s9,s3,800045ac <exec+0x180>
  sz = sz1;
    800045fa:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800045fe:	4a81                	li	s5,0
    80004600:	a05d                	j	800046a6 <exec+0x27a>
  sp = sz;
    80004602:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004604:	4481                	li	s1,0
  ustack[argc] = 0;
    80004606:	00349793          	slli	a5,s1,0x3
    8000460a:	f9040713          	addi	a4,s0,-112
    8000460e:	97ba                	add	a5,a5,a4
    80004610:	f007b023          	sd	zero,-256(a5) # ffffffffffffef00 <end+0xffffffff7ffc2f00>
  sp -= (argc+1) * sizeof(uint64);
    80004614:	00148693          	addi	a3,s1,1
    80004618:	068e                	slli	a3,a3,0x3
    8000461a:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000461e:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004622:	01597663          	bgeu	s2,s5,8000462e <exec+0x202>
  sz = sz1;
    80004626:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000462a:	4a81                	li	s5,0
    8000462c:	a8ad                	j	800046a6 <exec+0x27a>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    8000462e:	e9040613          	addi	a2,s0,-368
    80004632:	85ca                	mv	a1,s2
    80004634:	855a                	mv	a0,s6
    80004636:	ed7fc0ef          	jal	ra,8000150c <copyout>
    8000463a:	0a054363          	bltz	a0,800046e0 <exec+0x2b4>
  p->trapframe->a1 = sp;
    8000463e:	058bb783          	ld	a5,88(s7) # 1058 <_entry-0x7fffefa8>
    80004642:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004646:	de843783          	ld	a5,-536(s0)
    8000464a:	0007c703          	lbu	a4,0(a5)
    8000464e:	cf11                	beqz	a4,8000466a <exec+0x23e>
    80004650:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004652:	02f00693          	li	a3,47
    80004656:	a039                	j	80004664 <exec+0x238>
      last = s+1;
    80004658:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    8000465c:	0785                	addi	a5,a5,1
    8000465e:	fff7c703          	lbu	a4,-1(a5)
    80004662:	c701                	beqz	a4,8000466a <exec+0x23e>
    if(*s == '/')
    80004664:	fed71ce3          	bne	a4,a3,8000465c <exec+0x230>
    80004668:	bfc5                	j	80004658 <exec+0x22c>
  safestrcpy(p->name, last, sizeof(p->name));
    8000466a:	4641                	li	a2,16
    8000466c:	de843583          	ld	a1,-536(s0)
    80004670:	718b8513          	addi	a0,s7,1816
    80004674:	f40fc0ef          	jal	ra,80000db4 <safestrcpy>
  oldpagetable = p->pagetable;
    80004678:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    8000467c:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    80004680:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004684:	058bb783          	ld	a5,88(s7)
    80004688:	e6843703          	ld	a4,-408(s0)
    8000468c:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000468e:	058bb783          	ld	a5,88(s7)
    80004692:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004696:	85ea                	mv	a1,s10
    80004698:	aecfd0ef          	jal	ra,80001984 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000469c:	0004851b          	sext.w	a0,s1
    800046a0:	b531                	j	800044ac <exec+0x80>
    800046a2:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    800046a6:	df843583          	ld	a1,-520(s0)
    800046aa:	855a                	mv	a0,s6
    800046ac:	ad8fd0ef          	jal	ra,80001984 <proc_freepagetable>
  if(ip){
    800046b0:	de0a98e3          	bnez	s5,800044a0 <exec+0x74>
  return -1;
    800046b4:	557d                	li	a0,-1
    800046b6:	bbdd                	j	800044ac <exec+0x80>
    800046b8:	df243c23          	sd	s2,-520(s0)
    800046bc:	b7ed                	j	800046a6 <exec+0x27a>
    800046be:	df243c23          	sd	s2,-520(s0)
    800046c2:	b7d5                	j	800046a6 <exec+0x27a>
    800046c4:	df243c23          	sd	s2,-520(s0)
    800046c8:	bff9                	j	800046a6 <exec+0x27a>
    800046ca:	df243c23          	sd	s2,-520(s0)
    800046ce:	bfe1                	j	800046a6 <exec+0x27a>
  sz = sz1;
    800046d0:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800046d4:	4a81                	li	s5,0
    800046d6:	bfc1                	j	800046a6 <exec+0x27a>
  sz = sz1;
    800046d8:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800046dc:	4a81                	li	s5,0
    800046de:	b7e1                	j	800046a6 <exec+0x27a>
  sz = sz1;
    800046e0:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800046e4:	4a81                	li	s5,0
    800046e6:	b7c1                	j	800046a6 <exec+0x27a>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800046e8:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800046ec:	e0843783          	ld	a5,-504(s0)
    800046f0:	0017869b          	addiw	a3,a5,1
    800046f4:	e0d43423          	sd	a3,-504(s0)
    800046f8:	e0043783          	ld	a5,-512(s0)
    800046fc:	0387879b          	addiw	a5,a5,56
    80004700:	e8845703          	lhu	a4,-376(s0)
    80004704:	e4e6d6e3          	bge	a3,a4,80004550 <exec+0x124>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004708:	2781                	sext.w	a5,a5
    8000470a:	e0f43023          	sd	a5,-512(s0)
    8000470e:	03800713          	li	a4,56
    80004712:	86be                	mv	a3,a5
    80004714:	e1840613          	addi	a2,s0,-488
    80004718:	4581                	li	a1,0
    8000471a:	8556                	mv	a0,s5
    8000471c:	c47fe0ef          	jal	ra,80003362 <readi>
    80004720:	03800793          	li	a5,56
    80004724:	f6f51fe3          	bne	a0,a5,800046a2 <exec+0x276>
    if(ph.type != ELF_PROG_LOAD)
    80004728:	e1842783          	lw	a5,-488(s0)
    8000472c:	4705                	li	a4,1
    8000472e:	fae79fe3          	bne	a5,a4,800046ec <exec+0x2c0>
    if(ph.memsz < ph.filesz)
    80004732:	e4043483          	ld	s1,-448(s0)
    80004736:	e3843783          	ld	a5,-456(s0)
    8000473a:	f6f4efe3          	bltu	s1,a5,800046b8 <exec+0x28c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    8000473e:	e2843783          	ld	a5,-472(s0)
    80004742:	94be                	add	s1,s1,a5
    80004744:	f6f4ede3          	bltu	s1,a5,800046be <exec+0x292>
    if(ph.vaddr % PGSIZE != 0)
    80004748:	de043703          	ld	a4,-544(s0)
    8000474c:	8ff9                	and	a5,a5,a4
    8000474e:	fbbd                	bnez	a5,800046c4 <exec+0x298>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004750:	e1c42503          	lw	a0,-484(s0)
    80004754:	cbdff0ef          	jal	ra,80004410 <flags2perm>
    80004758:	86aa                	mv	a3,a0
    8000475a:	8626                	mv	a2,s1
    8000475c:	85ca                	mv	a1,s2
    8000475e:	855a                	mv	a0,s6
    80004760:	ba9fc0ef          	jal	ra,80001308 <uvmalloc>
    80004764:	dea43c23          	sd	a0,-520(s0)
    80004768:	d12d                	beqz	a0,800046ca <exec+0x29e>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000476a:	e2843c03          	ld	s8,-472(s0)
    8000476e:	e2042c83          	lw	s9,-480(s0)
    80004772:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004776:	f60b89e3          	beqz	s7,800046e8 <exec+0x2bc>
    8000477a:	89de                	mv	s3,s7
    8000477c:	4481                	li	s1,0
    8000477e:	bb55                	j	80004532 <exec+0x106>

0000000080004780 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004780:	7179                	addi	sp,sp,-48
    80004782:	f406                	sd	ra,40(sp)
    80004784:	f022                	sd	s0,32(sp)
    80004786:	ec26                	sd	s1,24(sp)
    80004788:	e84a                	sd	s2,16(sp)
    8000478a:	1800                	addi	s0,sp,48
    8000478c:	892e                	mv	s2,a1
    8000478e:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004790:	fdc40593          	addi	a1,s0,-36
    80004794:	f71fd0ef          	jal	ra,80002704 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004798:	fdc42703          	lw	a4,-36(s0)
    8000479c:	0c700793          	li	a5,199
    800047a0:	02e7e963          	bltu	a5,a4,800047d2 <argfd+0x52>
    800047a4:	8b4fd0ef          	jal	ra,80001858 <myproc>
    800047a8:	fdc42703          	lw	a4,-36(s0)
    800047ac:	01a70793          	addi	a5,a4,26
    800047b0:	078e                	slli	a5,a5,0x3
    800047b2:	953e                	add	a0,a0,a5
    800047b4:	611c                	ld	a5,0(a0)
    800047b6:	c385                	beqz	a5,800047d6 <argfd+0x56>
    return -1;
  if(pfd)
    800047b8:	00090463          	beqz	s2,800047c0 <argfd+0x40>
    *pfd = fd;
    800047bc:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800047c0:	4501                	li	a0,0
  if(pf)
    800047c2:	c091                	beqz	s1,800047c6 <argfd+0x46>
    *pf = f;
    800047c4:	e09c                	sd	a5,0(s1)
}
    800047c6:	70a2                	ld	ra,40(sp)
    800047c8:	7402                	ld	s0,32(sp)
    800047ca:	64e2                	ld	s1,24(sp)
    800047cc:	6942                	ld	s2,16(sp)
    800047ce:	6145                	addi	sp,sp,48
    800047d0:	8082                	ret
    return -1;
    800047d2:	557d                	li	a0,-1
    800047d4:	bfcd                	j	800047c6 <argfd+0x46>
    800047d6:	557d                	li	a0,-1
    800047d8:	b7fd                	j	800047c6 <argfd+0x46>

00000000800047da <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800047da:	1101                	addi	sp,sp,-32
    800047dc:	ec06                	sd	ra,24(sp)
    800047de:	e822                	sd	s0,16(sp)
    800047e0:	e426                	sd	s1,8(sp)
    800047e2:	1000                	addi	s0,sp,32
    800047e4:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800047e6:	872fd0ef          	jal	ra,80001858 <myproc>
    800047ea:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800047ec:	0d050793          	addi	a5,a0,208
    800047f0:	4501                	li	a0,0
    800047f2:	0c800693          	li	a3,200
    if(p->ofile[fd] == 0){
    800047f6:	6398                	ld	a4,0(a5)
    800047f8:	c719                	beqz	a4,80004806 <fdalloc+0x2c>
  for(fd = 0; fd < NOFILE; fd++){
    800047fa:	2505                	addiw	a0,a0,1
    800047fc:	07a1                	addi	a5,a5,8
    800047fe:	fed51ce3          	bne	a0,a3,800047f6 <fdalloc+0x1c>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004802:	557d                	li	a0,-1
    80004804:	a031                	j	80004810 <fdalloc+0x36>
      p->ofile[fd] = f;
    80004806:	01a50793          	addi	a5,a0,26
    8000480a:	078e                	slli	a5,a5,0x3
    8000480c:	963e                	add	a2,a2,a5
    8000480e:	e204                	sd	s1,0(a2)
}
    80004810:	60e2                	ld	ra,24(sp)
    80004812:	6442                	ld	s0,16(sp)
    80004814:	64a2                	ld	s1,8(sp)
    80004816:	6105                	addi	sp,sp,32
    80004818:	8082                	ret

000000008000481a <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    8000481a:	715d                	addi	sp,sp,-80
    8000481c:	e486                	sd	ra,72(sp)
    8000481e:	e0a2                	sd	s0,64(sp)
    80004820:	fc26                	sd	s1,56(sp)
    80004822:	f84a                	sd	s2,48(sp)
    80004824:	f44e                	sd	s3,40(sp)
    80004826:	f052                	sd	s4,32(sp)
    80004828:	ec56                	sd	s5,24(sp)
    8000482a:	e85a                	sd	s6,16(sp)
    8000482c:	0880                	addi	s0,sp,80
    8000482e:	8b2e                	mv	s6,a1
    80004830:	89b2                	mv	s3,a2
    80004832:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004834:	fb040593          	addi	a1,s0,-80
    80004838:	fa7fe0ef          	jal	ra,800037de <nameiparent>
    8000483c:	84aa                	mv	s1,a0
    8000483e:	10050b63          	beqz	a0,80004954 <create+0x13a>
    return 0;

  ilock(dp);
    80004842:	8d1fe0ef          	jal	ra,80003112 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004846:	4601                	li	a2,0
    80004848:	fb040593          	addi	a1,s0,-80
    8000484c:	8526                	mv	a0,s1
    8000484e:	d11fe0ef          	jal	ra,8000355e <dirlookup>
    80004852:	8aaa                	mv	s5,a0
    80004854:	c521                	beqz	a0,8000489c <create+0x82>
    iunlockput(dp);
    80004856:	8526                	mv	a0,s1
    80004858:	ac1fe0ef          	jal	ra,80003318 <iunlockput>
    ilock(ip);
    8000485c:	8556                	mv	a0,s5
    8000485e:	8b5fe0ef          	jal	ra,80003112 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004862:	000b059b          	sext.w	a1,s6
    80004866:	4789                	li	a5,2
    80004868:	02f59563          	bne	a1,a5,80004892 <create+0x78>
    8000486c:	044ad783          	lhu	a5,68(s5) # fffffffffffff044 <end+0xffffffff7ffc3044>
    80004870:	37f9                	addiw	a5,a5,-2
    80004872:	17c2                	slli	a5,a5,0x30
    80004874:	93c1                	srli	a5,a5,0x30
    80004876:	4705                	li	a4,1
    80004878:	00f76d63          	bltu	a4,a5,80004892 <create+0x78>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    8000487c:	8556                	mv	a0,s5
    8000487e:	60a6                	ld	ra,72(sp)
    80004880:	6406                	ld	s0,64(sp)
    80004882:	74e2                	ld	s1,56(sp)
    80004884:	7942                	ld	s2,48(sp)
    80004886:	79a2                	ld	s3,40(sp)
    80004888:	7a02                	ld	s4,32(sp)
    8000488a:	6ae2                	ld	s5,24(sp)
    8000488c:	6b42                	ld	s6,16(sp)
    8000488e:	6161                	addi	sp,sp,80
    80004890:	8082                	ret
    iunlockput(ip);
    80004892:	8556                	mv	a0,s5
    80004894:	a85fe0ef          	jal	ra,80003318 <iunlockput>
    return 0;
    80004898:	4a81                	li	s5,0
    8000489a:	b7cd                	j	8000487c <create+0x62>
  if((ip = ialloc(dp->dev, type)) == 0){
    8000489c:	85da                	mv	a1,s6
    8000489e:	4088                	lw	a0,0(s1)
    800048a0:	f0afe0ef          	jal	ra,80002faa <ialloc>
    800048a4:	8a2a                	mv	s4,a0
    800048a6:	cd1d                	beqz	a0,800048e4 <create+0xca>
  ilock(ip);
    800048a8:	86bfe0ef          	jal	ra,80003112 <ilock>
  ip->major = major;
    800048ac:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    800048b0:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    800048b4:	4905                	li	s2,1
    800048b6:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    800048ba:	8552                	mv	a0,s4
    800048bc:	fa4fe0ef          	jal	ra,80003060 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800048c0:	000b059b          	sext.w	a1,s6
    800048c4:	03258563          	beq	a1,s2,800048ee <create+0xd4>
  if(dirlink(dp, name, ip->inum) < 0)
    800048c8:	004a2603          	lw	a2,4(s4)
    800048cc:	fb040593          	addi	a1,s0,-80
    800048d0:	8526                	mv	a0,s1
    800048d2:	e59fe0ef          	jal	ra,8000372a <dirlink>
    800048d6:	06054363          	bltz	a0,8000493c <create+0x122>
  iunlockput(dp);
    800048da:	8526                	mv	a0,s1
    800048dc:	a3dfe0ef          	jal	ra,80003318 <iunlockput>
  return ip;
    800048e0:	8ad2                	mv	s5,s4
    800048e2:	bf69                	j	8000487c <create+0x62>
    iunlockput(dp);
    800048e4:	8526                	mv	a0,s1
    800048e6:	a33fe0ef          	jal	ra,80003318 <iunlockput>
    return 0;
    800048ea:	8ad2                	mv	s5,s4
    800048ec:	bf41                	j	8000487c <create+0x62>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800048ee:	004a2603          	lw	a2,4(s4)
    800048f2:	00003597          	auipc	a1,0x3
    800048f6:	f0e58593          	addi	a1,a1,-242 # 80007800 <syscalls+0x358>
    800048fa:	8552                	mv	a0,s4
    800048fc:	e2ffe0ef          	jal	ra,8000372a <dirlink>
    80004900:	02054e63          	bltz	a0,8000493c <create+0x122>
    80004904:	40d0                	lw	a2,4(s1)
    80004906:	00003597          	auipc	a1,0x3
    8000490a:	f0258593          	addi	a1,a1,-254 # 80007808 <syscalls+0x360>
    8000490e:	8552                	mv	a0,s4
    80004910:	e1bfe0ef          	jal	ra,8000372a <dirlink>
    80004914:	02054463          	bltz	a0,8000493c <create+0x122>
  if(dirlink(dp, name, ip->inum) < 0)
    80004918:	004a2603          	lw	a2,4(s4)
    8000491c:	fb040593          	addi	a1,s0,-80
    80004920:	8526                	mv	a0,s1
    80004922:	e09fe0ef          	jal	ra,8000372a <dirlink>
    80004926:	00054b63          	bltz	a0,8000493c <create+0x122>
    dp->nlink++;  // for ".."
    8000492a:	04a4d783          	lhu	a5,74(s1)
    8000492e:	2785                	addiw	a5,a5,1
    80004930:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004934:	8526                	mv	a0,s1
    80004936:	f2afe0ef          	jal	ra,80003060 <iupdate>
    8000493a:	b745                	j	800048da <create+0xc0>
  ip->nlink = 0;
    8000493c:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004940:	8552                	mv	a0,s4
    80004942:	f1efe0ef          	jal	ra,80003060 <iupdate>
  iunlockput(ip);
    80004946:	8552                	mv	a0,s4
    80004948:	9d1fe0ef          	jal	ra,80003318 <iunlockput>
  iunlockput(dp);
    8000494c:	8526                	mv	a0,s1
    8000494e:	9cbfe0ef          	jal	ra,80003318 <iunlockput>
  return 0;
    80004952:	b72d                	j	8000487c <create+0x62>
    return 0;
    80004954:	8aaa                	mv	s5,a0
    80004956:	b71d                	j	8000487c <create+0x62>

0000000080004958 <sys_dup>:
{
    80004958:	7179                	addi	sp,sp,-48
    8000495a:	f406                	sd	ra,40(sp)
    8000495c:	f022                	sd	s0,32(sp)
    8000495e:	ec26                	sd	s1,24(sp)
    80004960:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004962:	fd840613          	addi	a2,s0,-40
    80004966:	4581                	li	a1,0
    80004968:	4501                	li	a0,0
    8000496a:	e17ff0ef          	jal	ra,80004780 <argfd>
    return -1;
    8000496e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004970:	00054f63          	bltz	a0,8000498e <sys_dup+0x36>
  if((fd=fdalloc(f)) < 0)
    80004974:	fd843503          	ld	a0,-40(s0)
    80004978:	e63ff0ef          	jal	ra,800047da <fdalloc>
    8000497c:	84aa                	mv	s1,a0
    return -1;
    8000497e:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004980:	00054763          	bltz	a0,8000498e <sys_dup+0x36>
  filedup(f);
    80004984:	fd843503          	ld	a0,-40(s0)
    80004988:	c98ff0ef          	jal	ra,80003e20 <filedup>
  return fd;
    8000498c:	87a6                	mv	a5,s1
}
    8000498e:	853e                	mv	a0,a5
    80004990:	70a2                	ld	ra,40(sp)
    80004992:	7402                	ld	s0,32(sp)
    80004994:	64e2                	ld	s1,24(sp)
    80004996:	6145                	addi	sp,sp,48
    80004998:	8082                	ret

000000008000499a <sys_read>:
{
    8000499a:	7179                	addi	sp,sp,-48
    8000499c:	f406                	sd	ra,40(sp)
    8000499e:	f022                	sd	s0,32(sp)
    800049a0:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800049a2:	fd840593          	addi	a1,s0,-40
    800049a6:	4505                	li	a0,1
    800049a8:	d79fd0ef          	jal	ra,80002720 <argaddr>
  argint(2, &n);
    800049ac:	fe440593          	addi	a1,s0,-28
    800049b0:	4509                	li	a0,2
    800049b2:	d53fd0ef          	jal	ra,80002704 <argint>
  if(argfd(0, 0, &f) < 0)
    800049b6:	fe840613          	addi	a2,s0,-24
    800049ba:	4581                	li	a1,0
    800049bc:	4501                	li	a0,0
    800049be:	dc3ff0ef          	jal	ra,80004780 <argfd>
    800049c2:	87aa                	mv	a5,a0
    return -1;
    800049c4:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800049c6:	0007ca63          	bltz	a5,800049da <sys_read+0x40>
  return fileread(f, p, n);
    800049ca:	fe442603          	lw	a2,-28(s0)
    800049ce:	fd843583          	ld	a1,-40(s0)
    800049d2:	fe843503          	ld	a0,-24(s0)
    800049d6:	dbaff0ef          	jal	ra,80003f90 <fileread>
}
    800049da:	70a2                	ld	ra,40(sp)
    800049dc:	7402                	ld	s0,32(sp)
    800049de:	6145                	addi	sp,sp,48
    800049e0:	8082                	ret

00000000800049e2 <sys_write>:
{
    800049e2:	7179                	addi	sp,sp,-48
    800049e4:	f406                	sd	ra,40(sp)
    800049e6:	f022                	sd	s0,32(sp)
    800049e8:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800049ea:	fd840593          	addi	a1,s0,-40
    800049ee:	4505                	li	a0,1
    800049f0:	d31fd0ef          	jal	ra,80002720 <argaddr>
  argint(2, &n);
    800049f4:	fe440593          	addi	a1,s0,-28
    800049f8:	4509                	li	a0,2
    800049fa:	d0bfd0ef          	jal	ra,80002704 <argint>
  if(argfd(0, 0, &f) < 0)
    800049fe:	fe840613          	addi	a2,s0,-24
    80004a02:	4581                	li	a1,0
    80004a04:	4501                	li	a0,0
    80004a06:	d7bff0ef          	jal	ra,80004780 <argfd>
    80004a0a:	87aa                	mv	a5,a0
    return -1;
    80004a0c:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004a0e:	0007ca63          	bltz	a5,80004a22 <sys_write+0x40>
  return filewrite(f, p, n);
    80004a12:	fe442603          	lw	a2,-28(s0)
    80004a16:	fd843583          	ld	a1,-40(s0)
    80004a1a:	fe843503          	ld	a0,-24(s0)
    80004a1e:	e20ff0ef          	jal	ra,8000403e <filewrite>
}
    80004a22:	70a2                	ld	ra,40(sp)
    80004a24:	7402                	ld	s0,32(sp)
    80004a26:	6145                	addi	sp,sp,48
    80004a28:	8082                	ret

0000000080004a2a <sys_close>:
{
    80004a2a:	1101                	addi	sp,sp,-32
    80004a2c:	ec06                	sd	ra,24(sp)
    80004a2e:	e822                	sd	s0,16(sp)
    80004a30:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004a32:	fe040613          	addi	a2,s0,-32
    80004a36:	fec40593          	addi	a1,s0,-20
    80004a3a:	4501                	li	a0,0
    80004a3c:	d45ff0ef          	jal	ra,80004780 <argfd>
    return -1;
    80004a40:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004a42:	02054063          	bltz	a0,80004a62 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80004a46:	e13fc0ef          	jal	ra,80001858 <myproc>
    80004a4a:	fec42783          	lw	a5,-20(s0)
    80004a4e:	07e9                	addi	a5,a5,26
    80004a50:	078e                	slli	a5,a5,0x3
    80004a52:	97aa                	add	a5,a5,a0
    80004a54:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80004a58:	fe043503          	ld	a0,-32(s0)
    80004a5c:	c0aff0ef          	jal	ra,80003e66 <fileclose>
  return 0;
    80004a60:	4781                	li	a5,0
}
    80004a62:	853e                	mv	a0,a5
    80004a64:	60e2                	ld	ra,24(sp)
    80004a66:	6442                	ld	s0,16(sp)
    80004a68:	6105                	addi	sp,sp,32
    80004a6a:	8082                	ret

0000000080004a6c <sys_fstat>:
{
    80004a6c:	1101                	addi	sp,sp,-32
    80004a6e:	ec06                	sd	ra,24(sp)
    80004a70:	e822                	sd	s0,16(sp)
    80004a72:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004a74:	fe040593          	addi	a1,s0,-32
    80004a78:	4505                	li	a0,1
    80004a7a:	ca7fd0ef          	jal	ra,80002720 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004a7e:	fe840613          	addi	a2,s0,-24
    80004a82:	4581                	li	a1,0
    80004a84:	4501                	li	a0,0
    80004a86:	cfbff0ef          	jal	ra,80004780 <argfd>
    80004a8a:	87aa                	mv	a5,a0
    return -1;
    80004a8c:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004a8e:	0007c863          	bltz	a5,80004a9e <sys_fstat+0x32>
  return filestat(f, st);
    80004a92:	fe043583          	ld	a1,-32(s0)
    80004a96:	fe843503          	ld	a0,-24(s0)
    80004a9a:	c98ff0ef          	jal	ra,80003f32 <filestat>
}
    80004a9e:	60e2                	ld	ra,24(sp)
    80004aa0:	6442                	ld	s0,16(sp)
    80004aa2:	6105                	addi	sp,sp,32
    80004aa4:	8082                	ret

0000000080004aa6 <sys_link>:
{
    80004aa6:	7169                	addi	sp,sp,-304
    80004aa8:	f606                	sd	ra,296(sp)
    80004aaa:	f222                	sd	s0,288(sp)
    80004aac:	ee26                	sd	s1,280(sp)
    80004aae:	ea4a                	sd	s2,272(sp)
    80004ab0:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004ab2:	08000613          	li	a2,128
    80004ab6:	ed040593          	addi	a1,s0,-304
    80004aba:	4501                	li	a0,0
    80004abc:	c81fd0ef          	jal	ra,8000273c <argstr>
    return -1;
    80004ac0:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004ac2:	0c054663          	bltz	a0,80004b8e <sys_link+0xe8>
    80004ac6:	08000613          	li	a2,128
    80004aca:	f5040593          	addi	a1,s0,-176
    80004ace:	4505                	li	a0,1
    80004ad0:	c6dfd0ef          	jal	ra,8000273c <argstr>
    return -1;
    80004ad4:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004ad6:	0a054c63          	bltz	a0,80004b8e <sys_link+0xe8>
  begin_op();
    80004ada:	ec3fe0ef          	jal	ra,8000399c <begin_op>
  if((ip = namei(old)) == 0){
    80004ade:	ed040513          	addi	a0,s0,-304
    80004ae2:	ce3fe0ef          	jal	ra,800037c4 <namei>
    80004ae6:	84aa                	mv	s1,a0
    80004ae8:	c525                	beqz	a0,80004b50 <sys_link+0xaa>
  ilock(ip);
    80004aea:	e28fe0ef          	jal	ra,80003112 <ilock>
  if(ip->type == T_DIR){
    80004aee:	04449703          	lh	a4,68(s1)
    80004af2:	4785                	li	a5,1
    80004af4:	06f70263          	beq	a4,a5,80004b58 <sys_link+0xb2>
  ip->nlink++;
    80004af8:	04a4d783          	lhu	a5,74(s1)
    80004afc:	2785                	addiw	a5,a5,1
    80004afe:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004b02:	8526                	mv	a0,s1
    80004b04:	d5cfe0ef          	jal	ra,80003060 <iupdate>
  iunlock(ip);
    80004b08:	8526                	mv	a0,s1
    80004b0a:	eb2fe0ef          	jal	ra,800031bc <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004b0e:	fd040593          	addi	a1,s0,-48
    80004b12:	f5040513          	addi	a0,s0,-176
    80004b16:	cc9fe0ef          	jal	ra,800037de <nameiparent>
    80004b1a:	892a                	mv	s2,a0
    80004b1c:	c921                	beqz	a0,80004b6c <sys_link+0xc6>
  ilock(dp);
    80004b1e:	df4fe0ef          	jal	ra,80003112 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004b22:	00092703          	lw	a4,0(s2)
    80004b26:	409c                	lw	a5,0(s1)
    80004b28:	02f71f63          	bne	a4,a5,80004b66 <sys_link+0xc0>
    80004b2c:	40d0                	lw	a2,4(s1)
    80004b2e:	fd040593          	addi	a1,s0,-48
    80004b32:	854a                	mv	a0,s2
    80004b34:	bf7fe0ef          	jal	ra,8000372a <dirlink>
    80004b38:	02054763          	bltz	a0,80004b66 <sys_link+0xc0>
  iunlockput(dp);
    80004b3c:	854a                	mv	a0,s2
    80004b3e:	fdafe0ef          	jal	ra,80003318 <iunlockput>
  iput(ip);
    80004b42:	8526                	mv	a0,s1
    80004b44:	f4cfe0ef          	jal	ra,80003290 <iput>
  end_op();
    80004b48:	ec5fe0ef          	jal	ra,80003a0c <end_op>
  return 0;
    80004b4c:	4781                	li	a5,0
    80004b4e:	a081                	j	80004b8e <sys_link+0xe8>
    end_op();
    80004b50:	ebdfe0ef          	jal	ra,80003a0c <end_op>
    return -1;
    80004b54:	57fd                	li	a5,-1
    80004b56:	a825                	j	80004b8e <sys_link+0xe8>
    iunlockput(ip);
    80004b58:	8526                	mv	a0,s1
    80004b5a:	fbefe0ef          	jal	ra,80003318 <iunlockput>
    end_op();
    80004b5e:	eaffe0ef          	jal	ra,80003a0c <end_op>
    return -1;
    80004b62:	57fd                	li	a5,-1
    80004b64:	a02d                	j	80004b8e <sys_link+0xe8>
    iunlockput(dp);
    80004b66:	854a                	mv	a0,s2
    80004b68:	fb0fe0ef          	jal	ra,80003318 <iunlockput>
  ilock(ip);
    80004b6c:	8526                	mv	a0,s1
    80004b6e:	da4fe0ef          	jal	ra,80003112 <ilock>
  ip->nlink--;
    80004b72:	04a4d783          	lhu	a5,74(s1)
    80004b76:	37fd                	addiw	a5,a5,-1
    80004b78:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004b7c:	8526                	mv	a0,s1
    80004b7e:	ce2fe0ef          	jal	ra,80003060 <iupdate>
  iunlockput(ip);
    80004b82:	8526                	mv	a0,s1
    80004b84:	f94fe0ef          	jal	ra,80003318 <iunlockput>
  end_op();
    80004b88:	e85fe0ef          	jal	ra,80003a0c <end_op>
  return -1;
    80004b8c:	57fd                	li	a5,-1
}
    80004b8e:	853e                	mv	a0,a5
    80004b90:	70b2                	ld	ra,296(sp)
    80004b92:	7412                	ld	s0,288(sp)
    80004b94:	64f2                	ld	s1,280(sp)
    80004b96:	6952                	ld	s2,272(sp)
    80004b98:	6155                	addi	sp,sp,304
    80004b9a:	8082                	ret

0000000080004b9c <sys_unlink>:
{
    80004b9c:	7151                	addi	sp,sp,-240
    80004b9e:	f586                	sd	ra,232(sp)
    80004ba0:	f1a2                	sd	s0,224(sp)
    80004ba2:	eda6                	sd	s1,216(sp)
    80004ba4:	e9ca                	sd	s2,208(sp)
    80004ba6:	e5ce                	sd	s3,200(sp)
    80004ba8:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004baa:	08000613          	li	a2,128
    80004bae:	f3040593          	addi	a1,s0,-208
    80004bb2:	4501                	li	a0,0
    80004bb4:	b89fd0ef          	jal	ra,8000273c <argstr>
    80004bb8:	12054b63          	bltz	a0,80004cee <sys_unlink+0x152>
  begin_op();
    80004bbc:	de1fe0ef          	jal	ra,8000399c <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004bc0:	fb040593          	addi	a1,s0,-80
    80004bc4:	f3040513          	addi	a0,s0,-208
    80004bc8:	c17fe0ef          	jal	ra,800037de <nameiparent>
    80004bcc:	84aa                	mv	s1,a0
    80004bce:	c54d                	beqz	a0,80004c78 <sys_unlink+0xdc>
  ilock(dp);
    80004bd0:	d42fe0ef          	jal	ra,80003112 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004bd4:	00003597          	auipc	a1,0x3
    80004bd8:	c2c58593          	addi	a1,a1,-980 # 80007800 <syscalls+0x358>
    80004bdc:	fb040513          	addi	a0,s0,-80
    80004be0:	969fe0ef          	jal	ra,80003548 <namecmp>
    80004be4:	10050a63          	beqz	a0,80004cf8 <sys_unlink+0x15c>
    80004be8:	00003597          	auipc	a1,0x3
    80004bec:	c2058593          	addi	a1,a1,-992 # 80007808 <syscalls+0x360>
    80004bf0:	fb040513          	addi	a0,s0,-80
    80004bf4:	955fe0ef          	jal	ra,80003548 <namecmp>
    80004bf8:	10050063          	beqz	a0,80004cf8 <sys_unlink+0x15c>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004bfc:	f2c40613          	addi	a2,s0,-212
    80004c00:	fb040593          	addi	a1,s0,-80
    80004c04:	8526                	mv	a0,s1
    80004c06:	959fe0ef          	jal	ra,8000355e <dirlookup>
    80004c0a:	892a                	mv	s2,a0
    80004c0c:	0e050663          	beqz	a0,80004cf8 <sys_unlink+0x15c>
  ilock(ip);
    80004c10:	d02fe0ef          	jal	ra,80003112 <ilock>
  if(ip->nlink < 1)
    80004c14:	04a91783          	lh	a5,74(s2)
    80004c18:	06f05463          	blez	a5,80004c80 <sys_unlink+0xe4>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004c1c:	04491703          	lh	a4,68(s2)
    80004c20:	4785                	li	a5,1
    80004c22:	06f70563          	beq	a4,a5,80004c8c <sys_unlink+0xf0>
  memset(&de, 0, sizeof(de));
    80004c26:	4641                	li	a2,16
    80004c28:	4581                	li	a1,0
    80004c2a:	fc040513          	addi	a0,s0,-64
    80004c2e:	840fc0ef          	jal	ra,80000c6e <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c32:	4741                	li	a4,16
    80004c34:	f2c42683          	lw	a3,-212(s0)
    80004c38:	fc040613          	addi	a2,s0,-64
    80004c3c:	4581                	li	a1,0
    80004c3e:	8526                	mv	a0,s1
    80004c40:	807fe0ef          	jal	ra,80003446 <writei>
    80004c44:	47c1                	li	a5,16
    80004c46:	08f51563          	bne	a0,a5,80004cd0 <sys_unlink+0x134>
  if(ip->type == T_DIR){
    80004c4a:	04491703          	lh	a4,68(s2)
    80004c4e:	4785                	li	a5,1
    80004c50:	08f70663          	beq	a4,a5,80004cdc <sys_unlink+0x140>
  iunlockput(dp);
    80004c54:	8526                	mv	a0,s1
    80004c56:	ec2fe0ef          	jal	ra,80003318 <iunlockput>
  ip->nlink--;
    80004c5a:	04a95783          	lhu	a5,74(s2)
    80004c5e:	37fd                	addiw	a5,a5,-1
    80004c60:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004c64:	854a                	mv	a0,s2
    80004c66:	bfafe0ef          	jal	ra,80003060 <iupdate>
  iunlockput(ip);
    80004c6a:	854a                	mv	a0,s2
    80004c6c:	eacfe0ef          	jal	ra,80003318 <iunlockput>
  end_op();
    80004c70:	d9dfe0ef          	jal	ra,80003a0c <end_op>
  return 0;
    80004c74:	4501                	li	a0,0
    80004c76:	a079                	j	80004d04 <sys_unlink+0x168>
    end_op();
    80004c78:	d95fe0ef          	jal	ra,80003a0c <end_op>
    return -1;
    80004c7c:	557d                	li	a0,-1
    80004c7e:	a059                	j	80004d04 <sys_unlink+0x168>
    panic("unlink: nlink < 1");
    80004c80:	00003517          	auipc	a0,0x3
    80004c84:	b9050513          	addi	a0,a0,-1136 # 80007810 <syscalls+0x368>
    80004c88:	acffb0ef          	jal	ra,80000756 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004c8c:	04c92703          	lw	a4,76(s2)
    80004c90:	02000793          	li	a5,32
    80004c94:	f8e7f9e3          	bgeu	a5,a4,80004c26 <sys_unlink+0x8a>
    80004c98:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c9c:	4741                	li	a4,16
    80004c9e:	86ce                	mv	a3,s3
    80004ca0:	f1840613          	addi	a2,s0,-232
    80004ca4:	4581                	li	a1,0
    80004ca6:	854a                	mv	a0,s2
    80004ca8:	ebafe0ef          	jal	ra,80003362 <readi>
    80004cac:	47c1                	li	a5,16
    80004cae:	00f51b63          	bne	a0,a5,80004cc4 <sys_unlink+0x128>
    if(de.inum != 0)
    80004cb2:	f1845783          	lhu	a5,-232(s0)
    80004cb6:	ef95                	bnez	a5,80004cf2 <sys_unlink+0x156>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004cb8:	29c1                	addiw	s3,s3,16
    80004cba:	04c92783          	lw	a5,76(s2)
    80004cbe:	fcf9efe3          	bltu	s3,a5,80004c9c <sys_unlink+0x100>
    80004cc2:	b795                	j	80004c26 <sys_unlink+0x8a>
      panic("isdirempty: readi");
    80004cc4:	00003517          	auipc	a0,0x3
    80004cc8:	b6450513          	addi	a0,a0,-1180 # 80007828 <syscalls+0x380>
    80004ccc:	a8bfb0ef          	jal	ra,80000756 <panic>
    panic("unlink: writei");
    80004cd0:	00003517          	auipc	a0,0x3
    80004cd4:	b7050513          	addi	a0,a0,-1168 # 80007840 <syscalls+0x398>
    80004cd8:	a7ffb0ef          	jal	ra,80000756 <panic>
    dp->nlink--;
    80004cdc:	04a4d783          	lhu	a5,74(s1)
    80004ce0:	37fd                	addiw	a5,a5,-1
    80004ce2:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004ce6:	8526                	mv	a0,s1
    80004ce8:	b78fe0ef          	jal	ra,80003060 <iupdate>
    80004cec:	b7a5                	j	80004c54 <sys_unlink+0xb8>
    return -1;
    80004cee:	557d                	li	a0,-1
    80004cf0:	a811                	j	80004d04 <sys_unlink+0x168>
    iunlockput(ip);
    80004cf2:	854a                	mv	a0,s2
    80004cf4:	e24fe0ef          	jal	ra,80003318 <iunlockput>
  iunlockput(dp);
    80004cf8:	8526                	mv	a0,s1
    80004cfa:	e1efe0ef          	jal	ra,80003318 <iunlockput>
  end_op();
    80004cfe:	d0ffe0ef          	jal	ra,80003a0c <end_op>
  return -1;
    80004d02:	557d                	li	a0,-1
}
    80004d04:	70ae                	ld	ra,232(sp)
    80004d06:	740e                	ld	s0,224(sp)
    80004d08:	64ee                	ld	s1,216(sp)
    80004d0a:	694e                	ld	s2,208(sp)
    80004d0c:	69ae                	ld	s3,200(sp)
    80004d0e:	616d                	addi	sp,sp,240
    80004d10:	8082                	ret

0000000080004d12 <sys_open>:

uint64
sys_open(void)
{
    80004d12:	7131                	addi	sp,sp,-192
    80004d14:	fd06                	sd	ra,184(sp)
    80004d16:	f922                	sd	s0,176(sp)
    80004d18:	f526                	sd	s1,168(sp)
    80004d1a:	f14a                	sd	s2,160(sp)
    80004d1c:	ed4e                	sd	s3,152(sp)
    80004d1e:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004d20:	f4c40593          	addi	a1,s0,-180
    80004d24:	4505                	li	a0,1
    80004d26:	9dffd0ef          	jal	ra,80002704 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004d2a:	08000613          	li	a2,128
    80004d2e:	f5040593          	addi	a1,s0,-176
    80004d32:	4501                	li	a0,0
    80004d34:	a09fd0ef          	jal	ra,8000273c <argstr>
    80004d38:	87aa                	mv	a5,a0
    return -1;
    80004d3a:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004d3c:	0807cd63          	bltz	a5,80004dd6 <sys_open+0xc4>

  begin_op();
    80004d40:	c5dfe0ef          	jal	ra,8000399c <begin_op>

  if(omode & O_CREATE){
    80004d44:	f4c42783          	lw	a5,-180(s0)
    80004d48:	2007f793          	andi	a5,a5,512
    80004d4c:	c3c5                	beqz	a5,80004dec <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    80004d4e:	4681                	li	a3,0
    80004d50:	4601                	li	a2,0
    80004d52:	4589                	li	a1,2
    80004d54:	f5040513          	addi	a0,s0,-176
    80004d58:	ac3ff0ef          	jal	ra,8000481a <create>
    80004d5c:	84aa                	mv	s1,a0
    if(ip == 0){
    80004d5e:	c159                	beqz	a0,80004de4 <sys_open+0xd2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004d60:	04449703          	lh	a4,68(s1)
    80004d64:	478d                	li	a5,3
    80004d66:	00f71763          	bne	a4,a5,80004d74 <sys_open+0x62>
    80004d6a:	0464d703          	lhu	a4,70(s1)
    80004d6e:	47a5                	li	a5,9
    80004d70:	0ae7e963          	bltu	a5,a4,80004e22 <sys_open+0x110>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004d74:	83cff0ef          	jal	ra,80003db0 <filealloc>
    80004d78:	89aa                	mv	s3,a0
    80004d7a:	0c050963          	beqz	a0,80004e4c <sys_open+0x13a>
    80004d7e:	a5dff0ef          	jal	ra,800047da <fdalloc>
    80004d82:	892a                	mv	s2,a0
    80004d84:	0c054163          	bltz	a0,80004e46 <sys_open+0x134>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004d88:	04449703          	lh	a4,68(s1)
    80004d8c:	478d                	li	a5,3
    80004d8e:	0af70163          	beq	a4,a5,80004e30 <sys_open+0x11e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004d92:	4789                	li	a5,2
    80004d94:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004d98:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004d9c:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004da0:	f4c42783          	lw	a5,-180(s0)
    80004da4:	0017c713          	xori	a4,a5,1
    80004da8:	8b05                	andi	a4,a4,1
    80004daa:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004dae:	0037f713          	andi	a4,a5,3
    80004db2:	00e03733          	snez	a4,a4
    80004db6:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004dba:	4007f793          	andi	a5,a5,1024
    80004dbe:	c791                	beqz	a5,80004dca <sys_open+0xb8>
    80004dc0:	04449703          	lh	a4,68(s1)
    80004dc4:	4789                	li	a5,2
    80004dc6:	06f70c63          	beq	a4,a5,80004e3e <sys_open+0x12c>
    itrunc(ip);
  }

  iunlock(ip);
    80004dca:	8526                	mv	a0,s1
    80004dcc:	bf0fe0ef          	jal	ra,800031bc <iunlock>
  end_op();
    80004dd0:	c3dfe0ef          	jal	ra,80003a0c <end_op>

  return fd;
    80004dd4:	854a                	mv	a0,s2
}
    80004dd6:	70ea                	ld	ra,184(sp)
    80004dd8:	744a                	ld	s0,176(sp)
    80004dda:	74aa                	ld	s1,168(sp)
    80004ddc:	790a                	ld	s2,160(sp)
    80004dde:	69ea                	ld	s3,152(sp)
    80004de0:	6129                	addi	sp,sp,192
    80004de2:	8082                	ret
      end_op();
    80004de4:	c29fe0ef          	jal	ra,80003a0c <end_op>
      return -1;
    80004de8:	557d                	li	a0,-1
    80004dea:	b7f5                	j	80004dd6 <sys_open+0xc4>
    if((ip = namei(path)) == 0){
    80004dec:	f5040513          	addi	a0,s0,-176
    80004df0:	9d5fe0ef          	jal	ra,800037c4 <namei>
    80004df4:	84aa                	mv	s1,a0
    80004df6:	c115                	beqz	a0,80004e1a <sys_open+0x108>
    ilock(ip);
    80004df8:	b1afe0ef          	jal	ra,80003112 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004dfc:	04449703          	lh	a4,68(s1)
    80004e00:	4785                	li	a5,1
    80004e02:	f4f71fe3          	bne	a4,a5,80004d60 <sys_open+0x4e>
    80004e06:	f4c42783          	lw	a5,-180(s0)
    80004e0a:	d7ad                	beqz	a5,80004d74 <sys_open+0x62>
      iunlockput(ip);
    80004e0c:	8526                	mv	a0,s1
    80004e0e:	d0afe0ef          	jal	ra,80003318 <iunlockput>
      end_op();
    80004e12:	bfbfe0ef          	jal	ra,80003a0c <end_op>
      return -1;
    80004e16:	557d                	li	a0,-1
    80004e18:	bf7d                	j	80004dd6 <sys_open+0xc4>
      end_op();
    80004e1a:	bf3fe0ef          	jal	ra,80003a0c <end_op>
      return -1;
    80004e1e:	557d                	li	a0,-1
    80004e20:	bf5d                	j	80004dd6 <sys_open+0xc4>
    iunlockput(ip);
    80004e22:	8526                	mv	a0,s1
    80004e24:	cf4fe0ef          	jal	ra,80003318 <iunlockput>
    end_op();
    80004e28:	be5fe0ef          	jal	ra,80003a0c <end_op>
    return -1;
    80004e2c:	557d                	li	a0,-1
    80004e2e:	b765                	j	80004dd6 <sys_open+0xc4>
    f->type = FD_DEVICE;
    80004e30:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004e34:	04649783          	lh	a5,70(s1)
    80004e38:	02f99223          	sh	a5,36(s3)
    80004e3c:	b785                	j	80004d9c <sys_open+0x8a>
    itrunc(ip);
    80004e3e:	8526                	mv	a0,s1
    80004e40:	bbcfe0ef          	jal	ra,800031fc <itrunc>
    80004e44:	b759                	j	80004dca <sys_open+0xb8>
      fileclose(f);
    80004e46:	854e                	mv	a0,s3
    80004e48:	81eff0ef          	jal	ra,80003e66 <fileclose>
    iunlockput(ip);
    80004e4c:	8526                	mv	a0,s1
    80004e4e:	ccafe0ef          	jal	ra,80003318 <iunlockput>
    end_op();
    80004e52:	bbbfe0ef          	jal	ra,80003a0c <end_op>
    return -1;
    80004e56:	557d                	li	a0,-1
    80004e58:	bfbd                	j	80004dd6 <sys_open+0xc4>

0000000080004e5a <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004e5a:	7175                	addi	sp,sp,-144
    80004e5c:	e506                	sd	ra,136(sp)
    80004e5e:	e122                	sd	s0,128(sp)
    80004e60:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004e62:	b3bfe0ef          	jal	ra,8000399c <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004e66:	08000613          	li	a2,128
    80004e6a:	f7040593          	addi	a1,s0,-144
    80004e6e:	4501                	li	a0,0
    80004e70:	8cdfd0ef          	jal	ra,8000273c <argstr>
    80004e74:	02054363          	bltz	a0,80004e9a <sys_mkdir+0x40>
    80004e78:	4681                	li	a3,0
    80004e7a:	4601                	li	a2,0
    80004e7c:	4585                	li	a1,1
    80004e7e:	f7040513          	addi	a0,s0,-144
    80004e82:	999ff0ef          	jal	ra,8000481a <create>
    80004e86:	c911                	beqz	a0,80004e9a <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e88:	c90fe0ef          	jal	ra,80003318 <iunlockput>
  end_op();
    80004e8c:	b81fe0ef          	jal	ra,80003a0c <end_op>
  return 0;
    80004e90:	4501                	li	a0,0
}
    80004e92:	60aa                	ld	ra,136(sp)
    80004e94:	640a                	ld	s0,128(sp)
    80004e96:	6149                	addi	sp,sp,144
    80004e98:	8082                	ret
    end_op();
    80004e9a:	b73fe0ef          	jal	ra,80003a0c <end_op>
    return -1;
    80004e9e:	557d                	li	a0,-1
    80004ea0:	bfcd                	j	80004e92 <sys_mkdir+0x38>

0000000080004ea2 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004ea2:	7135                	addi	sp,sp,-160
    80004ea4:	ed06                	sd	ra,152(sp)
    80004ea6:	e922                	sd	s0,144(sp)
    80004ea8:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004eaa:	af3fe0ef          	jal	ra,8000399c <begin_op>
  argint(1, &major);
    80004eae:	f6c40593          	addi	a1,s0,-148
    80004eb2:	4505                	li	a0,1
    80004eb4:	851fd0ef          	jal	ra,80002704 <argint>
  argint(2, &minor);
    80004eb8:	f6840593          	addi	a1,s0,-152
    80004ebc:	4509                	li	a0,2
    80004ebe:	847fd0ef          	jal	ra,80002704 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004ec2:	08000613          	li	a2,128
    80004ec6:	f7040593          	addi	a1,s0,-144
    80004eca:	4501                	li	a0,0
    80004ecc:	871fd0ef          	jal	ra,8000273c <argstr>
    80004ed0:	02054563          	bltz	a0,80004efa <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004ed4:	f6841683          	lh	a3,-152(s0)
    80004ed8:	f6c41603          	lh	a2,-148(s0)
    80004edc:	458d                	li	a1,3
    80004ede:	f7040513          	addi	a0,s0,-144
    80004ee2:	939ff0ef          	jal	ra,8000481a <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004ee6:	c911                	beqz	a0,80004efa <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004ee8:	c30fe0ef          	jal	ra,80003318 <iunlockput>
  end_op();
    80004eec:	b21fe0ef          	jal	ra,80003a0c <end_op>
  return 0;
    80004ef0:	4501                	li	a0,0
}
    80004ef2:	60ea                	ld	ra,152(sp)
    80004ef4:	644a                	ld	s0,144(sp)
    80004ef6:	610d                	addi	sp,sp,160
    80004ef8:	8082                	ret
    end_op();
    80004efa:	b13fe0ef          	jal	ra,80003a0c <end_op>
    return -1;
    80004efe:	557d                	li	a0,-1
    80004f00:	bfcd                	j	80004ef2 <sys_mknod+0x50>

0000000080004f02 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004f02:	7135                	addi	sp,sp,-160
    80004f04:	ed06                	sd	ra,152(sp)
    80004f06:	e922                	sd	s0,144(sp)
    80004f08:	e526                	sd	s1,136(sp)
    80004f0a:	e14a                	sd	s2,128(sp)
    80004f0c:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004f0e:	94bfc0ef          	jal	ra,80001858 <myproc>
    80004f12:	892a                	mv	s2,a0
  
  begin_op();
    80004f14:	a89fe0ef          	jal	ra,8000399c <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004f18:	08000613          	li	a2,128
    80004f1c:	f6040593          	addi	a1,s0,-160
    80004f20:	4501                	li	a0,0
    80004f22:	81bfd0ef          	jal	ra,8000273c <argstr>
    80004f26:	04054163          	bltz	a0,80004f68 <sys_chdir+0x66>
    80004f2a:	f6040513          	addi	a0,s0,-160
    80004f2e:	897fe0ef          	jal	ra,800037c4 <namei>
    80004f32:	84aa                	mv	s1,a0
    80004f34:	c915                	beqz	a0,80004f68 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80004f36:	9dcfe0ef          	jal	ra,80003112 <ilock>
  if(ip->type != T_DIR){
    80004f3a:	04449703          	lh	a4,68(s1)
    80004f3e:	4785                	li	a5,1
    80004f40:	02f71863          	bne	a4,a5,80004f70 <sys_chdir+0x6e>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004f44:	8526                	mv	a0,s1
    80004f46:	a76fe0ef          	jal	ra,800031bc <iunlock>
  iput(p->cwd);
    80004f4a:	71093503          	ld	a0,1808(s2)
    80004f4e:	b42fe0ef          	jal	ra,80003290 <iput>
  end_op();
    80004f52:	abbfe0ef          	jal	ra,80003a0c <end_op>
  p->cwd = ip;
    80004f56:	70993823          	sd	s1,1808(s2)
  return 0;
    80004f5a:	4501                	li	a0,0
}
    80004f5c:	60ea                	ld	ra,152(sp)
    80004f5e:	644a                	ld	s0,144(sp)
    80004f60:	64aa                	ld	s1,136(sp)
    80004f62:	690a                	ld	s2,128(sp)
    80004f64:	610d                	addi	sp,sp,160
    80004f66:	8082                	ret
    end_op();
    80004f68:	aa5fe0ef          	jal	ra,80003a0c <end_op>
    return -1;
    80004f6c:	557d                	li	a0,-1
    80004f6e:	b7fd                	j	80004f5c <sys_chdir+0x5a>
    iunlockput(ip);
    80004f70:	8526                	mv	a0,s1
    80004f72:	ba6fe0ef          	jal	ra,80003318 <iunlockput>
    end_op();
    80004f76:	a97fe0ef          	jal	ra,80003a0c <end_op>
    return -1;
    80004f7a:	557d                	li	a0,-1
    80004f7c:	b7c5                	j	80004f5c <sys_chdir+0x5a>

0000000080004f7e <sys_exec>:

uint64
sys_exec(void)
{
    80004f7e:	7145                	addi	sp,sp,-464
    80004f80:	e786                	sd	ra,456(sp)
    80004f82:	e3a2                	sd	s0,448(sp)
    80004f84:	ff26                	sd	s1,440(sp)
    80004f86:	fb4a                	sd	s2,432(sp)
    80004f88:	f74e                	sd	s3,424(sp)
    80004f8a:	f352                	sd	s4,416(sp)
    80004f8c:	ef56                	sd	s5,408(sp)
    80004f8e:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004f90:	e3840593          	addi	a1,s0,-456
    80004f94:	4505                	li	a0,1
    80004f96:	f8afd0ef          	jal	ra,80002720 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004f9a:	08000613          	li	a2,128
    80004f9e:	f4040593          	addi	a1,s0,-192
    80004fa2:	4501                	li	a0,0
    80004fa4:	f98fd0ef          	jal	ra,8000273c <argstr>
    80004fa8:	87aa                	mv	a5,a0
    return -1;
    80004faa:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004fac:	0a07c463          	bltz	a5,80005054 <sys_exec+0xd6>
  }
  memset(argv, 0, sizeof(argv));
    80004fb0:	10000613          	li	a2,256
    80004fb4:	4581                	li	a1,0
    80004fb6:	e4040513          	addi	a0,s0,-448
    80004fba:	cb5fb0ef          	jal	ra,80000c6e <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004fbe:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004fc2:	89a6                	mv	s3,s1
    80004fc4:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004fc6:	02000a13          	li	s4,32
    80004fca:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004fce:	00391793          	slli	a5,s2,0x3
    80004fd2:	e3040593          	addi	a1,s0,-464
    80004fd6:	e3843503          	ld	a0,-456(s0)
    80004fda:	953e                	add	a0,a0,a5
    80004fdc:	e9efd0ef          	jal	ra,8000267a <fetchaddr>
    80004fe0:	02054663          	bltz	a0,8000500c <sys_exec+0x8e>
      goto bad;
    }
    if(uarg == 0){
    80004fe4:	e3043783          	ld	a5,-464(s0)
    80004fe8:	cf8d                	beqz	a5,80005022 <sys_exec+0xa4>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004fea:	ae1fb0ef          	jal	ra,80000aca <kalloc>
    80004fee:	85aa                	mv	a1,a0
    80004ff0:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004ff4:	cd01                	beqz	a0,8000500c <sys_exec+0x8e>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004ff6:	6605                	lui	a2,0x1
    80004ff8:	e3043503          	ld	a0,-464(s0)
    80004ffc:	ec8fd0ef          	jal	ra,800026c4 <fetchstr>
    80005000:	00054663          	bltz	a0,8000500c <sys_exec+0x8e>
    if(i >= NELEM(argv)){
    80005004:	0905                	addi	s2,s2,1
    80005006:	09a1                	addi	s3,s3,8
    80005008:	fd4911e3          	bne	s2,s4,80004fca <sys_exec+0x4c>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000500c:	10048913          	addi	s2,s1,256
    80005010:	6088                	ld	a0,0(s1)
    80005012:	c121                	beqz	a0,80005052 <sys_exec+0xd4>
    kfree(argv[i]);
    80005014:	9d7fb0ef          	jal	ra,800009ea <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005018:	04a1                	addi	s1,s1,8
    8000501a:	ff249be3          	bne	s1,s2,80005010 <sys_exec+0x92>
  return -1;
    8000501e:	557d                	li	a0,-1
    80005020:	a815                	j	80005054 <sys_exec+0xd6>
      argv[i] = 0;
    80005022:	0a8e                	slli	s5,s5,0x3
    80005024:	fc040793          	addi	a5,s0,-64
    80005028:	9abe                	add	s5,s5,a5
    8000502a:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    8000502e:	e4040593          	addi	a1,s0,-448
    80005032:	f4040513          	addi	a0,s0,-192
    80005036:	bf6ff0ef          	jal	ra,8000442c <exec>
    8000503a:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000503c:	10048993          	addi	s3,s1,256
    80005040:	6088                	ld	a0,0(s1)
    80005042:	c511                	beqz	a0,8000504e <sys_exec+0xd0>
    kfree(argv[i]);
    80005044:	9a7fb0ef          	jal	ra,800009ea <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005048:	04a1                	addi	s1,s1,8
    8000504a:	ff349be3          	bne	s1,s3,80005040 <sys_exec+0xc2>
  return ret;
    8000504e:	854a                	mv	a0,s2
    80005050:	a011                	j	80005054 <sys_exec+0xd6>
  return -1;
    80005052:	557d                	li	a0,-1
}
    80005054:	60be                	ld	ra,456(sp)
    80005056:	641e                	ld	s0,448(sp)
    80005058:	74fa                	ld	s1,440(sp)
    8000505a:	795a                	ld	s2,432(sp)
    8000505c:	79ba                	ld	s3,424(sp)
    8000505e:	7a1a                	ld	s4,416(sp)
    80005060:	6afa                	ld	s5,408(sp)
    80005062:	6179                	addi	sp,sp,464
    80005064:	8082                	ret

0000000080005066 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005066:	7139                	addi	sp,sp,-64
    80005068:	fc06                	sd	ra,56(sp)
    8000506a:	f822                	sd	s0,48(sp)
    8000506c:	f426                	sd	s1,40(sp)
    8000506e:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005070:	fe8fc0ef          	jal	ra,80001858 <myproc>
    80005074:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80005076:	fd840593          	addi	a1,s0,-40
    8000507a:	4501                	li	a0,0
    8000507c:	ea4fd0ef          	jal	ra,80002720 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80005080:	fc840593          	addi	a1,s0,-56
    80005084:	fd040513          	addi	a0,s0,-48
    80005088:	8ceff0ef          	jal	ra,80004156 <pipealloc>
    return -1;
    8000508c:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    8000508e:	0a054463          	bltz	a0,80005136 <sys_pipe+0xd0>
  fd0 = -1;
    80005092:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005096:	fd043503          	ld	a0,-48(s0)
    8000509a:	f40ff0ef          	jal	ra,800047da <fdalloc>
    8000509e:	fca42223          	sw	a0,-60(s0)
    800050a2:	08054163          	bltz	a0,80005124 <sys_pipe+0xbe>
    800050a6:	fc843503          	ld	a0,-56(s0)
    800050aa:	f30ff0ef          	jal	ra,800047da <fdalloc>
    800050ae:	fca42023          	sw	a0,-64(s0)
    800050b2:	06054063          	bltz	a0,80005112 <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800050b6:	4691                	li	a3,4
    800050b8:	fc440613          	addi	a2,s0,-60
    800050bc:	fd843583          	ld	a1,-40(s0)
    800050c0:	68a8                	ld	a0,80(s1)
    800050c2:	c4afc0ef          	jal	ra,8000150c <copyout>
    800050c6:	00054e63          	bltz	a0,800050e2 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800050ca:	4691                	li	a3,4
    800050cc:	fc040613          	addi	a2,s0,-64
    800050d0:	fd843583          	ld	a1,-40(s0)
    800050d4:	0591                	addi	a1,a1,4
    800050d6:	68a8                	ld	a0,80(s1)
    800050d8:	c34fc0ef          	jal	ra,8000150c <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800050dc:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800050de:	04055c63          	bgez	a0,80005136 <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    800050e2:	fc442783          	lw	a5,-60(s0)
    800050e6:	07e9                	addi	a5,a5,26
    800050e8:	078e                	slli	a5,a5,0x3
    800050ea:	97a6                	add	a5,a5,s1
    800050ec:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800050f0:	fc042503          	lw	a0,-64(s0)
    800050f4:	0569                	addi	a0,a0,26
    800050f6:	050e                	slli	a0,a0,0x3
    800050f8:	94aa                	add	s1,s1,a0
    800050fa:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800050fe:	fd043503          	ld	a0,-48(s0)
    80005102:	d65fe0ef          	jal	ra,80003e66 <fileclose>
    fileclose(wf);
    80005106:	fc843503          	ld	a0,-56(s0)
    8000510a:	d5dfe0ef          	jal	ra,80003e66 <fileclose>
    return -1;
    8000510e:	57fd                	li	a5,-1
    80005110:	a01d                	j	80005136 <sys_pipe+0xd0>
    if(fd0 >= 0)
    80005112:	fc442783          	lw	a5,-60(s0)
    80005116:	0007c763          	bltz	a5,80005124 <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    8000511a:	07e9                	addi	a5,a5,26
    8000511c:	078e                	slli	a5,a5,0x3
    8000511e:	94be                	add	s1,s1,a5
    80005120:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005124:	fd043503          	ld	a0,-48(s0)
    80005128:	d3ffe0ef          	jal	ra,80003e66 <fileclose>
    fileclose(wf);
    8000512c:	fc843503          	ld	a0,-56(s0)
    80005130:	d37fe0ef          	jal	ra,80003e66 <fileclose>
    return -1;
    80005134:	57fd                	li	a5,-1
}
    80005136:	853e                	mv	a0,a5
    80005138:	70e2                	ld	ra,56(sp)
    8000513a:	7442                	ld	s0,48(sp)
    8000513c:	74a2                	ld	s1,40(sp)
    8000513e:	6121                	addi	sp,sp,64
    80005140:	8082                	ret
	...

0000000080005150 <kernelvec>:
    80005150:	7111                	addi	sp,sp,-256
    80005152:	e006                	sd	ra,0(sp)
    80005154:	e40a                	sd	sp,8(sp)
    80005156:	e80e                	sd	gp,16(sp)
    80005158:	ec12                	sd	tp,24(sp)
    8000515a:	f016                	sd	t0,32(sp)
    8000515c:	f41a                	sd	t1,40(sp)
    8000515e:	f81e                	sd	t2,48(sp)
    80005160:	e4aa                	sd	a0,72(sp)
    80005162:	e8ae                	sd	a1,80(sp)
    80005164:	ecb2                	sd	a2,88(sp)
    80005166:	f0b6                	sd	a3,96(sp)
    80005168:	f4ba                	sd	a4,104(sp)
    8000516a:	f8be                	sd	a5,112(sp)
    8000516c:	fcc2                	sd	a6,120(sp)
    8000516e:	e146                	sd	a7,128(sp)
    80005170:	edf2                	sd	t3,216(sp)
    80005172:	f1f6                	sd	t4,224(sp)
    80005174:	f5fa                	sd	t5,232(sp)
    80005176:	f9fe                	sd	t6,240(sp)
    80005178:	c12fd0ef          	jal	ra,8000258a <kerneltrap>
    8000517c:	6082                	ld	ra,0(sp)
    8000517e:	6122                	ld	sp,8(sp)
    80005180:	61c2                	ld	gp,16(sp)
    80005182:	7282                	ld	t0,32(sp)
    80005184:	7322                	ld	t1,40(sp)
    80005186:	73c2                	ld	t2,48(sp)
    80005188:	6526                	ld	a0,72(sp)
    8000518a:	65c6                	ld	a1,80(sp)
    8000518c:	6666                	ld	a2,88(sp)
    8000518e:	7686                	ld	a3,96(sp)
    80005190:	7726                	ld	a4,104(sp)
    80005192:	77c6                	ld	a5,112(sp)
    80005194:	7866                	ld	a6,120(sp)
    80005196:	688a                	ld	a7,128(sp)
    80005198:	6e6e                	ld	t3,216(sp)
    8000519a:	7e8e                	ld	t4,224(sp)
    8000519c:	7f2e                	ld	t5,232(sp)
    8000519e:	7fce                	ld	t6,240(sp)
    800051a0:	6111                	addi	sp,sp,256
    800051a2:	10200073          	sret
	...

00000000800051ae <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800051ae:	1141                	addi	sp,sp,-16
    800051b0:	e422                	sd	s0,8(sp)
    800051b2:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800051b4:	0c0007b7          	lui	a5,0xc000
    800051b8:	4705                	li	a4,1
    800051ba:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800051bc:	c3d8                	sw	a4,4(a5)
}
    800051be:	6422                	ld	s0,8(sp)
    800051c0:	0141                	addi	sp,sp,16
    800051c2:	8082                	ret

00000000800051c4 <plicinithart>:

void
plicinithart(void)
{
    800051c4:	1141                	addi	sp,sp,-16
    800051c6:	e406                	sd	ra,8(sp)
    800051c8:	e022                	sd	s0,0(sp)
    800051ca:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800051cc:	e60fc0ef          	jal	ra,8000182c <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800051d0:	0085171b          	slliw	a4,a0,0x8
    800051d4:	0c0027b7          	lui	a5,0xc002
    800051d8:	97ba                	add	a5,a5,a4
    800051da:	40200713          	li	a4,1026
    800051de:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800051e2:	00d5151b          	slliw	a0,a0,0xd
    800051e6:	0c2017b7          	lui	a5,0xc201
    800051ea:	953e                	add	a0,a0,a5
    800051ec:	00052023          	sw	zero,0(a0)
}
    800051f0:	60a2                	ld	ra,8(sp)
    800051f2:	6402                	ld	s0,0(sp)
    800051f4:	0141                	addi	sp,sp,16
    800051f6:	8082                	ret

00000000800051f8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800051f8:	1141                	addi	sp,sp,-16
    800051fa:	e406                	sd	ra,8(sp)
    800051fc:	e022                	sd	s0,0(sp)
    800051fe:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005200:	e2cfc0ef          	jal	ra,8000182c <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005204:	00d5179b          	slliw	a5,a0,0xd
    80005208:	0c201537          	lui	a0,0xc201
    8000520c:	953e                	add	a0,a0,a5
  return irq;
}
    8000520e:	4148                	lw	a0,4(a0)
    80005210:	60a2                	ld	ra,8(sp)
    80005212:	6402                	ld	s0,0(sp)
    80005214:	0141                	addi	sp,sp,16
    80005216:	8082                	ret

0000000080005218 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005218:	1101                	addi	sp,sp,-32
    8000521a:	ec06                	sd	ra,24(sp)
    8000521c:	e822                	sd	s0,16(sp)
    8000521e:	e426                	sd	s1,8(sp)
    80005220:	1000                	addi	s0,sp,32
    80005222:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005224:	e08fc0ef          	jal	ra,8000182c <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005228:	00d5151b          	slliw	a0,a0,0xd
    8000522c:	0c2017b7          	lui	a5,0xc201
    80005230:	97aa                	add	a5,a5,a0
    80005232:	c3c4                	sw	s1,4(a5)
}
    80005234:	60e2                	ld	ra,24(sp)
    80005236:	6442                	ld	s0,16(sp)
    80005238:	64a2                	ld	s1,8(sp)
    8000523a:	6105                	addi	sp,sp,32
    8000523c:	8082                	ret

000000008000523e <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    8000523e:	1141                	addi	sp,sp,-16
    80005240:	e406                	sd	ra,8(sp)
    80005242:	e022                	sd	s0,0(sp)
    80005244:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80005246:	479d                	li	a5,7
    80005248:	04a7ca63          	blt	a5,a0,8000529c <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    8000524c:	00037797          	auipc	a5,0x37
    80005250:	c7478793          	addi	a5,a5,-908 # 8003bec0 <disk>
    80005254:	97aa                	add	a5,a5,a0
    80005256:	0187c783          	lbu	a5,24(a5)
    8000525a:	e7b9                	bnez	a5,800052a8 <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000525c:	00451613          	slli	a2,a0,0x4
    80005260:	00037797          	auipc	a5,0x37
    80005264:	c6078793          	addi	a5,a5,-928 # 8003bec0 <disk>
    80005268:	6394                	ld	a3,0(a5)
    8000526a:	96b2                	add	a3,a3,a2
    8000526c:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80005270:	6398                	ld	a4,0(a5)
    80005272:	9732                	add	a4,a4,a2
    80005274:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005278:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    8000527c:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005280:	953e                	add	a0,a0,a5
    80005282:	4785                	li	a5,1
    80005284:	00f50c23          	sb	a5,24(a0) # c201018 <_entry-0x73dfefe8>
  wakeup(&disk.free[0]);
    80005288:	00037517          	auipc	a0,0x37
    8000528c:	c5050513          	addi	a0,a0,-944 # 8003bed8 <disk+0x18>
    80005290:	be1fc0ef          	jal	ra,80001e70 <wakeup>
}
    80005294:	60a2                	ld	ra,8(sp)
    80005296:	6402                	ld	s0,0(sp)
    80005298:	0141                	addi	sp,sp,16
    8000529a:	8082                	ret
    panic("free_desc 1");
    8000529c:	00002517          	auipc	a0,0x2
    800052a0:	5b450513          	addi	a0,a0,1460 # 80007850 <syscalls+0x3a8>
    800052a4:	cb2fb0ef          	jal	ra,80000756 <panic>
    panic("free_desc 2");
    800052a8:	00002517          	auipc	a0,0x2
    800052ac:	5b850513          	addi	a0,a0,1464 # 80007860 <syscalls+0x3b8>
    800052b0:	ca6fb0ef          	jal	ra,80000756 <panic>

00000000800052b4 <virtio_disk_init>:
{
    800052b4:	1101                	addi	sp,sp,-32
    800052b6:	ec06                	sd	ra,24(sp)
    800052b8:	e822                	sd	s0,16(sp)
    800052ba:	e426                	sd	s1,8(sp)
    800052bc:	e04a                	sd	s2,0(sp)
    800052be:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800052c0:	00002597          	auipc	a1,0x2
    800052c4:	5b058593          	addi	a1,a1,1456 # 80007870 <syscalls+0x3c8>
    800052c8:	00037517          	auipc	a0,0x37
    800052cc:	d2050513          	addi	a0,a0,-736 # 8003bfe8 <disk+0x128>
    800052d0:	84bfb0ef          	jal	ra,80000b1a <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800052d4:	100017b7          	lui	a5,0x10001
    800052d8:	4398                	lw	a4,0(a5)
    800052da:	2701                	sext.w	a4,a4
    800052dc:	747277b7          	lui	a5,0x74727
    800052e0:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800052e4:	14f71063          	bne	a4,a5,80005424 <virtio_disk_init+0x170>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800052e8:	100017b7          	lui	a5,0x10001
    800052ec:	43dc                	lw	a5,4(a5)
    800052ee:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800052f0:	4709                	li	a4,2
    800052f2:	12e79963          	bne	a5,a4,80005424 <virtio_disk_init+0x170>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052f6:	100017b7          	lui	a5,0x10001
    800052fa:	479c                	lw	a5,8(a5)
    800052fc:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800052fe:	12e79363          	bne	a5,a4,80005424 <virtio_disk_init+0x170>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005302:	100017b7          	lui	a5,0x10001
    80005306:	47d8                	lw	a4,12(a5)
    80005308:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000530a:	554d47b7          	lui	a5,0x554d4
    8000530e:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005312:	10f71963          	bne	a4,a5,80005424 <virtio_disk_init+0x170>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005316:	100017b7          	lui	a5,0x10001
    8000531a:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000531e:	4705                	li	a4,1
    80005320:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005322:	470d                	li	a4,3
    80005324:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005326:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005328:	c7ffe737          	lui	a4,0xc7ffe
    8000532c:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fc275f>
    80005330:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005332:	2701                	sext.w	a4,a4
    80005334:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005336:	472d                	li	a4,11
    80005338:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    8000533a:	5bbc                	lw	a5,112(a5)
    8000533c:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005340:	8ba1                	andi	a5,a5,8
    80005342:	0e078763          	beqz	a5,80005430 <virtio_disk_init+0x17c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005346:	100017b7          	lui	a5,0x10001
    8000534a:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    8000534e:	43fc                	lw	a5,68(a5)
    80005350:	2781                	sext.w	a5,a5
    80005352:	0e079563          	bnez	a5,8000543c <virtio_disk_init+0x188>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005356:	100017b7          	lui	a5,0x10001
    8000535a:	5bdc                	lw	a5,52(a5)
    8000535c:	2781                	sext.w	a5,a5
  if(max == 0)
    8000535e:	0e078563          	beqz	a5,80005448 <virtio_disk_init+0x194>
  if(max < NUM)
    80005362:	471d                	li	a4,7
    80005364:	0ef77863          	bgeu	a4,a5,80005454 <virtio_disk_init+0x1a0>
  disk.desc = kalloc();
    80005368:	f62fb0ef          	jal	ra,80000aca <kalloc>
    8000536c:	00037497          	auipc	s1,0x37
    80005370:	b5448493          	addi	s1,s1,-1196 # 8003bec0 <disk>
    80005374:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005376:	f54fb0ef          	jal	ra,80000aca <kalloc>
    8000537a:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000537c:	f4efb0ef          	jal	ra,80000aca <kalloc>
    80005380:	87aa                	mv	a5,a0
    80005382:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005384:	6088                	ld	a0,0(s1)
    80005386:	cd69                	beqz	a0,80005460 <virtio_disk_init+0x1ac>
    80005388:	00037717          	auipc	a4,0x37
    8000538c:	b4073703          	ld	a4,-1216(a4) # 8003bec8 <disk+0x8>
    80005390:	cb61                	beqz	a4,80005460 <virtio_disk_init+0x1ac>
    80005392:	c7f9                	beqz	a5,80005460 <virtio_disk_init+0x1ac>
  memset(disk.desc, 0, PGSIZE);
    80005394:	6605                	lui	a2,0x1
    80005396:	4581                	li	a1,0
    80005398:	8d7fb0ef          	jal	ra,80000c6e <memset>
  memset(disk.avail, 0, PGSIZE);
    8000539c:	00037497          	auipc	s1,0x37
    800053a0:	b2448493          	addi	s1,s1,-1244 # 8003bec0 <disk>
    800053a4:	6605                	lui	a2,0x1
    800053a6:	4581                	li	a1,0
    800053a8:	6488                	ld	a0,8(s1)
    800053aa:	8c5fb0ef          	jal	ra,80000c6e <memset>
  memset(disk.used, 0, PGSIZE);
    800053ae:	6605                	lui	a2,0x1
    800053b0:	4581                	li	a1,0
    800053b2:	6888                	ld	a0,16(s1)
    800053b4:	8bbfb0ef          	jal	ra,80000c6e <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800053b8:	100017b7          	lui	a5,0x10001
    800053bc:	4721                	li	a4,8
    800053be:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800053c0:	4098                	lw	a4,0(s1)
    800053c2:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800053c6:	40d8                	lw	a4,4(s1)
    800053c8:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800053cc:	6498                	ld	a4,8(s1)
    800053ce:	0007069b          	sext.w	a3,a4
    800053d2:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800053d6:	9701                	srai	a4,a4,0x20
    800053d8:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800053dc:	6898                	ld	a4,16(s1)
    800053de:	0007069b          	sext.w	a3,a4
    800053e2:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800053e6:	9701                	srai	a4,a4,0x20
    800053e8:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800053ec:	4705                	li	a4,1
    800053ee:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    800053f0:	00e48c23          	sb	a4,24(s1)
    800053f4:	00e48ca3          	sb	a4,25(s1)
    800053f8:	00e48d23          	sb	a4,26(s1)
    800053fc:	00e48da3          	sb	a4,27(s1)
    80005400:	00e48e23          	sb	a4,28(s1)
    80005404:	00e48ea3          	sb	a4,29(s1)
    80005408:	00e48f23          	sb	a4,30(s1)
    8000540c:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005410:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005414:	0727a823          	sw	s2,112(a5)
}
    80005418:	60e2                	ld	ra,24(sp)
    8000541a:	6442                	ld	s0,16(sp)
    8000541c:	64a2                	ld	s1,8(sp)
    8000541e:	6902                	ld	s2,0(sp)
    80005420:	6105                	addi	sp,sp,32
    80005422:	8082                	ret
    panic("could not find virtio disk");
    80005424:	00002517          	auipc	a0,0x2
    80005428:	45c50513          	addi	a0,a0,1116 # 80007880 <syscalls+0x3d8>
    8000542c:	b2afb0ef          	jal	ra,80000756 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005430:	00002517          	auipc	a0,0x2
    80005434:	47050513          	addi	a0,a0,1136 # 800078a0 <syscalls+0x3f8>
    80005438:	b1efb0ef          	jal	ra,80000756 <panic>
    panic("virtio disk should not be ready");
    8000543c:	00002517          	auipc	a0,0x2
    80005440:	48450513          	addi	a0,a0,1156 # 800078c0 <syscalls+0x418>
    80005444:	b12fb0ef          	jal	ra,80000756 <panic>
    panic("virtio disk has no queue 0");
    80005448:	00002517          	auipc	a0,0x2
    8000544c:	49850513          	addi	a0,a0,1176 # 800078e0 <syscalls+0x438>
    80005450:	b06fb0ef          	jal	ra,80000756 <panic>
    panic("virtio disk max queue too short");
    80005454:	00002517          	auipc	a0,0x2
    80005458:	4ac50513          	addi	a0,a0,1196 # 80007900 <syscalls+0x458>
    8000545c:	afafb0ef          	jal	ra,80000756 <panic>
    panic("virtio disk kalloc");
    80005460:	00002517          	auipc	a0,0x2
    80005464:	4c050513          	addi	a0,a0,1216 # 80007920 <syscalls+0x478>
    80005468:	aeefb0ef          	jal	ra,80000756 <panic>

000000008000546c <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    8000546c:	7119                	addi	sp,sp,-128
    8000546e:	fc86                	sd	ra,120(sp)
    80005470:	f8a2                	sd	s0,112(sp)
    80005472:	f4a6                	sd	s1,104(sp)
    80005474:	f0ca                	sd	s2,96(sp)
    80005476:	ecce                	sd	s3,88(sp)
    80005478:	e8d2                	sd	s4,80(sp)
    8000547a:	e4d6                	sd	s5,72(sp)
    8000547c:	e0da                	sd	s6,64(sp)
    8000547e:	fc5e                	sd	s7,56(sp)
    80005480:	f862                	sd	s8,48(sp)
    80005482:	f466                	sd	s9,40(sp)
    80005484:	f06a                	sd	s10,32(sp)
    80005486:	ec6e                	sd	s11,24(sp)
    80005488:	0100                	addi	s0,sp,128
    8000548a:	8aaa                	mv	s5,a0
    8000548c:	8c2e                	mv	s8,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    8000548e:	00c52d03          	lw	s10,12(a0)
    80005492:	001d1d1b          	slliw	s10,s10,0x1
    80005496:	1d02                	slli	s10,s10,0x20
    80005498:	020d5d13          	srli	s10,s10,0x20

  acquire(&disk.vdisk_lock);
    8000549c:	00037517          	auipc	a0,0x37
    800054a0:	b4c50513          	addi	a0,a0,-1204 # 8003bfe8 <disk+0x128>
    800054a4:	ef6fb0ef          	jal	ra,80000b9a <acquire>
  for(int i = 0; i < 3; i++){
    800054a8:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800054aa:	44a1                	li	s1,8
      disk.free[i] = 0;
    800054ac:	00037b97          	auipc	s7,0x37
    800054b0:	a14b8b93          	addi	s7,s7,-1516 # 8003bec0 <disk>
  for(int i = 0; i < 3; i++){
    800054b4:	4b0d                	li	s6,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800054b6:	00037c97          	auipc	s9,0x37
    800054ba:	b32c8c93          	addi	s9,s9,-1230 # 8003bfe8 <disk+0x128>
    800054be:	a8a9                	j	80005518 <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    800054c0:	00fb8733          	add	a4,s7,a5
    800054c4:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800054c8:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800054ca:	0207c563          	bltz	a5,800054f4 <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    800054ce:	2905                	addiw	s2,s2,1
    800054d0:	0611                	addi	a2,a2,4
    800054d2:	05690863          	beq	s2,s6,80005522 <virtio_disk_rw+0xb6>
    idx[i] = alloc_desc();
    800054d6:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800054d8:	00037717          	auipc	a4,0x37
    800054dc:	9e870713          	addi	a4,a4,-1560 # 8003bec0 <disk>
    800054e0:	87ce                	mv	a5,s3
    if(disk.free[i]){
    800054e2:	01874683          	lbu	a3,24(a4)
    800054e6:	fee9                	bnez	a3,800054c0 <virtio_disk_rw+0x54>
  for(int i = 0; i < NUM; i++){
    800054e8:	2785                	addiw	a5,a5,1
    800054ea:	0705                	addi	a4,a4,1
    800054ec:	fe979be3          	bne	a5,s1,800054e2 <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    800054f0:	57fd                	li	a5,-1
    800054f2:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    800054f4:	01205b63          	blez	s2,8000550a <virtio_disk_rw+0x9e>
    800054f8:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    800054fa:	000a2503          	lw	a0,0(s4)
    800054fe:	d41ff0ef          	jal	ra,8000523e <free_desc>
      for(int j = 0; j < i; j++)
    80005502:	2d85                	addiw	s11,s11,1
    80005504:	0a11                	addi	s4,s4,4
    80005506:	ffb91ae3          	bne	s2,s11,800054fa <virtio_disk_rw+0x8e>
    sleep(&disk.free[0], &disk.vdisk_lock);
    8000550a:	85e6                	mv	a1,s9
    8000550c:	00037517          	auipc	a0,0x37
    80005510:	9cc50513          	addi	a0,a0,-1588 # 8003bed8 <disk+0x18>
    80005514:	911fc0ef          	jal	ra,80001e24 <sleep>
  for(int i = 0; i < 3; i++){
    80005518:	f8040a13          	addi	s4,s0,-128
{
    8000551c:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    8000551e:	894e                	mv	s2,s3
    80005520:	bf5d                	j	800054d6 <virtio_disk_rw+0x6a>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005522:	f8042583          	lw	a1,-128(s0)
    80005526:	00a58793          	addi	a5,a1,10
    8000552a:	0792                	slli	a5,a5,0x4

  if(write)
    8000552c:	00037617          	auipc	a2,0x37
    80005530:	99460613          	addi	a2,a2,-1644 # 8003bec0 <disk>
    80005534:	00f60733          	add	a4,a2,a5
    80005538:	018036b3          	snez	a3,s8
    8000553c:	c714                	sw	a3,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    8000553e:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80005542:	01a73823          	sd	s10,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005546:	f6078693          	addi	a3,a5,-160
    8000554a:	6218                	ld	a4,0(a2)
    8000554c:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000554e:	00878513          	addi	a0,a5,8
    80005552:	9532                	add	a0,a0,a2
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005554:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005556:	6208                	ld	a0,0(a2)
    80005558:	96aa                	add	a3,a3,a0
    8000555a:	4741                	li	a4,16
    8000555c:	c698                	sw	a4,8(a3)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000555e:	4705                	li	a4,1
    80005560:	00e69623          	sh	a4,12(a3)
  disk.desc[idx[0]].next = idx[1];
    80005564:	f8442703          	lw	a4,-124(s0)
    80005568:	00e69723          	sh	a4,14(a3)

  disk.desc[idx[1]].addr = (uint64) b->data;
    8000556c:	0712                	slli	a4,a4,0x4
    8000556e:	953a                	add	a0,a0,a4
    80005570:	058a8693          	addi	a3,s5,88
    80005574:	e114                	sd	a3,0(a0)
  disk.desc[idx[1]].len = BSIZE;
    80005576:	6208                	ld	a0,0(a2)
    80005578:	972a                	add	a4,a4,a0
    8000557a:	40000693          	li	a3,1024
    8000557e:	c714                	sw	a3,8(a4)
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80005580:	001c3c13          	seqz	s8,s8
    80005584:	0c06                	slli	s8,s8,0x1
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005586:	001c6c13          	ori	s8,s8,1
    8000558a:	01871623          	sh	s8,12(a4)
  disk.desc[idx[1]].next = idx[2];
    8000558e:	f8842603          	lw	a2,-120(s0)
    80005592:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005596:	00037697          	auipc	a3,0x37
    8000559a:	92a68693          	addi	a3,a3,-1750 # 8003bec0 <disk>
    8000559e:	00258713          	addi	a4,a1,2
    800055a2:	0712                	slli	a4,a4,0x4
    800055a4:	9736                	add	a4,a4,a3
    800055a6:	587d                	li	a6,-1
    800055a8:	01070823          	sb	a6,16(a4)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800055ac:	0612                	slli	a2,a2,0x4
    800055ae:	9532                	add	a0,a0,a2
    800055b0:	f9078793          	addi	a5,a5,-112
    800055b4:	97b6                	add	a5,a5,a3
    800055b6:	e11c                	sd	a5,0(a0)
  disk.desc[idx[2]].len = 1;
    800055b8:	629c                	ld	a5,0(a3)
    800055ba:	97b2                	add	a5,a5,a2
    800055bc:	4605                	li	a2,1
    800055be:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800055c0:	4509                	li	a0,2
    800055c2:	00a79623          	sh	a0,12(a5)
  disk.desc[idx[2]].next = 0;
    800055c6:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800055ca:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    800055ce:	01573423          	sd	s5,8(a4)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800055d2:	6698                	ld	a4,8(a3)
    800055d4:	00275783          	lhu	a5,2(a4)
    800055d8:	8b9d                	andi	a5,a5,7
    800055da:	0786                	slli	a5,a5,0x1
    800055dc:	97ba                	add	a5,a5,a4
    800055de:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    800055e2:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800055e6:	6698                	ld	a4,8(a3)
    800055e8:	00275783          	lhu	a5,2(a4)
    800055ec:	2785                	addiw	a5,a5,1
    800055ee:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800055f2:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800055f6:	100017b7          	lui	a5,0x10001
    800055fa:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800055fe:	004aa783          	lw	a5,4(s5)
    80005602:	00c79f63          	bne	a5,a2,80005620 <virtio_disk_rw+0x1b4>
    sleep(b, &disk.vdisk_lock);
    80005606:	00037917          	auipc	s2,0x37
    8000560a:	9e290913          	addi	s2,s2,-1566 # 8003bfe8 <disk+0x128>
  while(b->disk == 1) {
    8000560e:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005610:	85ca                	mv	a1,s2
    80005612:	8556                	mv	a0,s5
    80005614:	811fc0ef          	jal	ra,80001e24 <sleep>
  while(b->disk == 1) {
    80005618:	004aa783          	lw	a5,4(s5)
    8000561c:	fe978ae3          	beq	a5,s1,80005610 <virtio_disk_rw+0x1a4>
  }

  disk.info[idx[0]].b = 0;
    80005620:	f8042903          	lw	s2,-128(s0)
    80005624:	00290793          	addi	a5,s2,2
    80005628:	00479713          	slli	a4,a5,0x4
    8000562c:	00037797          	auipc	a5,0x37
    80005630:	89478793          	addi	a5,a5,-1900 # 8003bec0 <disk>
    80005634:	97ba                	add	a5,a5,a4
    80005636:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    8000563a:	00037997          	auipc	s3,0x37
    8000563e:	88698993          	addi	s3,s3,-1914 # 8003bec0 <disk>
    80005642:	00491713          	slli	a4,s2,0x4
    80005646:	0009b783          	ld	a5,0(s3)
    8000564a:	97ba                	add	a5,a5,a4
    8000564c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005650:	854a                	mv	a0,s2
    80005652:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005656:	be9ff0ef          	jal	ra,8000523e <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000565a:	8885                	andi	s1,s1,1
    8000565c:	f0fd                	bnez	s1,80005642 <virtio_disk_rw+0x1d6>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000565e:	00037517          	auipc	a0,0x37
    80005662:	98a50513          	addi	a0,a0,-1654 # 8003bfe8 <disk+0x128>
    80005666:	dccfb0ef          	jal	ra,80000c32 <release>
}
    8000566a:	70e6                	ld	ra,120(sp)
    8000566c:	7446                	ld	s0,112(sp)
    8000566e:	74a6                	ld	s1,104(sp)
    80005670:	7906                	ld	s2,96(sp)
    80005672:	69e6                	ld	s3,88(sp)
    80005674:	6a46                	ld	s4,80(sp)
    80005676:	6aa6                	ld	s5,72(sp)
    80005678:	6b06                	ld	s6,64(sp)
    8000567a:	7be2                	ld	s7,56(sp)
    8000567c:	7c42                	ld	s8,48(sp)
    8000567e:	7ca2                	ld	s9,40(sp)
    80005680:	7d02                	ld	s10,32(sp)
    80005682:	6de2                	ld	s11,24(sp)
    80005684:	6109                	addi	sp,sp,128
    80005686:	8082                	ret

0000000080005688 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005688:	1101                	addi	sp,sp,-32
    8000568a:	ec06                	sd	ra,24(sp)
    8000568c:	e822                	sd	s0,16(sp)
    8000568e:	e426                	sd	s1,8(sp)
    80005690:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005692:	00037497          	auipc	s1,0x37
    80005696:	82e48493          	addi	s1,s1,-2002 # 8003bec0 <disk>
    8000569a:	00037517          	auipc	a0,0x37
    8000569e:	94e50513          	addi	a0,a0,-1714 # 8003bfe8 <disk+0x128>
    800056a2:	cf8fb0ef          	jal	ra,80000b9a <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800056a6:	10001737          	lui	a4,0x10001
    800056aa:	533c                	lw	a5,96(a4)
    800056ac:	8b8d                	andi	a5,a5,3
    800056ae:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800056b0:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800056b4:	689c                	ld	a5,16(s1)
    800056b6:	0204d703          	lhu	a4,32(s1)
    800056ba:	0027d783          	lhu	a5,2(a5)
    800056be:	04f70663          	beq	a4,a5,8000570a <virtio_disk_intr+0x82>
    __sync_synchronize();
    800056c2:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800056c6:	6898                	ld	a4,16(s1)
    800056c8:	0204d783          	lhu	a5,32(s1)
    800056cc:	8b9d                	andi	a5,a5,7
    800056ce:	078e                	slli	a5,a5,0x3
    800056d0:	97ba                	add	a5,a5,a4
    800056d2:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800056d4:	00278713          	addi	a4,a5,2
    800056d8:	0712                	slli	a4,a4,0x4
    800056da:	9726                	add	a4,a4,s1
    800056dc:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    800056e0:	e321                	bnez	a4,80005720 <virtio_disk_intr+0x98>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800056e2:	0789                	addi	a5,a5,2
    800056e4:	0792                	slli	a5,a5,0x4
    800056e6:	97a6                	add	a5,a5,s1
    800056e8:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    800056ea:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800056ee:	f82fc0ef          	jal	ra,80001e70 <wakeup>

    disk.used_idx += 1;
    800056f2:	0204d783          	lhu	a5,32(s1)
    800056f6:	2785                	addiw	a5,a5,1
    800056f8:	17c2                	slli	a5,a5,0x30
    800056fa:	93c1                	srli	a5,a5,0x30
    800056fc:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005700:	6898                	ld	a4,16(s1)
    80005702:	00275703          	lhu	a4,2(a4)
    80005706:	faf71ee3          	bne	a4,a5,800056c2 <virtio_disk_intr+0x3a>
  }

  release(&disk.vdisk_lock);
    8000570a:	00037517          	auipc	a0,0x37
    8000570e:	8de50513          	addi	a0,a0,-1826 # 8003bfe8 <disk+0x128>
    80005712:	d20fb0ef          	jal	ra,80000c32 <release>
}
    80005716:	60e2                	ld	ra,24(sp)
    80005718:	6442                	ld	s0,16(sp)
    8000571a:	64a2                	ld	s1,8(sp)
    8000571c:	6105                	addi	sp,sp,32
    8000571e:	8082                	ret
      panic("virtio_disk_intr status");
    80005720:	00002517          	auipc	a0,0x2
    80005724:	21850513          	addi	a0,a0,536 # 80007938 <syscalls+0x490>
    80005728:	82efb0ef          	jal	ra,80000756 <panic>

000000008000572c <debugswitch>:
#include "param.h"

static enum debug_mode_t mode = MP2_DEFAULT_DEBUG_MODE;

void debugswitch(void)
{
    8000572c:	1141                	addi	sp,sp,-16
    8000572e:	e406                	sd	ra,8(sp)
    80005730:	e022                	sd	s0,0(sp)
    80005732:	0800                	addi	s0,sp,16
  mode = (enum debug_mode_t) !mode;
    80005734:	00002797          	auipc	a5,0x2
    80005738:	4e478793          	addi	a5,a5,1252 # 80007c18 <mode>
    8000573c:	438c                	lw	a1,0(a5)
    8000573e:	0015b713          	seqz	a4,a1
    80005742:	c398                	sw	a4,0(a5)
  printf("Switch debug mode to %d\n", mode);
    80005744:	0015b593          	seqz	a1,a1
    80005748:	00002517          	auipc	a0,0x2
    8000574c:	20850513          	addi	a0,a0,520 # 80007950 <syscalls+0x4a8>
    80005750:	d53fa0ef          	jal	ra,800004a2 <printf>
}
    80005754:	60a2                	ld	ra,8(sp)
    80005756:	6402                	ld	s0,0(sp)
    80005758:	0141                	addi	sp,sp,16
    8000575a:	8082                	ret

000000008000575c <get_mode>:

enum debug_mode_t get_mode()
{
    8000575c:	1141                	addi	sp,sp,-16
    8000575e:	e422                	sd	s0,8(sp)
    80005760:	0800                	addi	s0,sp,16
  return mode;
}
    80005762:	00002517          	auipc	a0,0x2
    80005766:	4b652503          	lw	a0,1206(a0) # 80007c18 <mode>
    8000576a:	6422                	ld	s0,8(sp)
    8000576c:	0141                	addi	sp,sp,16
    8000576e:	8082                	ret

0000000080005770 <sys_debugswitch>:

uint64
sys_debugswitch(void)
{
    80005770:	1141                	addi	sp,sp,-16
    80005772:	e406                	sd	ra,8(sp)
    80005774:	e022                	sd	s0,0(sp)
    80005776:	0800                	addi	s0,sp,16
  debugswitch();
    80005778:	fb5ff0ef          	jal	ra,8000572c <debugswitch>
  return 0;
}
    8000577c:	4501                	li	a0,0
    8000577e:	60a2                	ld	ra,8(sp)
    80005780:	6402                	ld	s0,0(sp)
    80005782:	0141                	addi	sp,sp,16
    80005784:	8082                	ret

0000000080005786 <create_slab>:
#include "slab.h"
#include "debug.h"
// #include "file.h"


struct slab *create_slab(uint object_size){
    80005786:	1101                	addi	sp,sp,-32
    80005788:	ec06                	sd	ra,24(sp)
    8000578a:	e822                	sd	s0,16(sp)
    8000578c:	e426                	sd	s1,8(sp)
    8000578e:	1000                	addi	s0,sp,32
    80005790:	84aa                	mv	s1,a0
  void *page = kalloc();
    80005792:	b38fb0ef          	jal	ra,80000aca <kalloc>
  struct slab *s = (struct slab *)page;
  void *obj_start = (void *)(s + 1);
    80005796:	01850593          	addi	a1,a0,24
  int space_available = PGSIZE - sizeof(struct slab);
  int num_objects = space_available / object_size;
    8000579a:	6805                	lui	a6,0x1
    8000579c:	3821                	addiw	a6,a6,-24
    8000579e:	0298583b          	divuw	a6,a6,s1
  // s->total_objects = num_objects;
  struct run *curr, *next;

  for(int i = 0; i < num_objects; i++){
    800057a2:	03005a63          	blez	a6,800057d6 <create_slab+0x50>
    800057a6:	4601                	li	a2,0
    800057a8:	4701                	li	a4,0
    curr = (struct run *)((char *)obj_start + i * object_size);
    next = (i < num_objects - 1)
            ? (struct run *)((char *)obj_start + (i + 1) * object_size)
            : NULL;
    800057aa:	fff8031b          	addiw	t1,a6,-1
    800057ae:	4881                	li	a7,0
    800057b0:	a031                	j	800057bc <create_slab+0x36>
    curr->next = next;
    800057b2:	e29c                	sd	a5,0(a3)
  for(int i = 0; i < num_objects; i++){
    800057b4:	2705                	addiw	a4,a4,1
    800057b6:	9e25                	addw	a2,a2,s1
    800057b8:	00e80f63          	beq	a6,a4,800057d6 <create_slab+0x50>
    curr = (struct run *)((char *)obj_start + i * object_size);
    800057bc:	02061693          	slli	a3,a2,0x20
    800057c0:	9281                	srli	a3,a3,0x20
    800057c2:	96ae                	add	a3,a3,a1
            : NULL;
    800057c4:	87c6                	mv	a5,a7
    800057c6:	fe6756e3          	bge	a4,t1,800057b2 <create_slab+0x2c>
            ? (struct run *)((char *)obj_start + (i + 1) * object_size)
    800057ca:	009607bb          	addw	a5,a2,s1
    800057ce:	1782                	slli	a5,a5,0x20
    800057d0:	9381                	srli	a5,a5,0x20
            : NULL;
    800057d2:	97ae                	add	a5,a5,a1
    800057d4:	bff9                	j	800057b2 <create_slab+0x2c>
  }
  s->freelist = (struct run *)obj_start;
    800057d6:	e10c                	sd	a1,0(a0)
  // s->state = SLAB_FREE;
  // s->inuse = 0;
  return s;
}
    800057d8:	60e2                	ld	ra,24(sp)
    800057da:	6442                	ld	s0,16(sp)
    800057dc:	64a2                	ld	s1,8(sp)
    800057de:	6105                	addi	sp,sp,32
    800057e0:	8082                	ret

00000000800057e2 <count_slab_freelist>:

int count_slab_freelist(struct slab *s) {
    800057e2:	1141                	addi	sp,sp,-16
    800057e4:	e422                	sd	s0,8(sp)
    800057e6:	0800                	addi	s0,sp,16
  int count = 0;
  struct run *r = s->freelist;
    800057e8:	611c                	ld	a5,0(a0)
  while (r != NULL) {
    800057ea:	cb81                	beqz	a5,800057fa <count_slab_freelist+0x18>
  int count = 0;
    800057ec:	4501                	li	a0,0
    count++;
    800057ee:	2505                	addiw	a0,a0,1
    r = r->next;
    800057f0:	639c                	ld	a5,0(a5)
  while (r != NULL) {
    800057f2:	fff5                	bnez	a5,800057ee <count_slab_freelist+0xc>
  }
  return count;
}
    800057f4:	6422                	ld	s0,8(sp)
    800057f6:	0141                	addi	sp,sp,16
    800057f8:	8082                	ret
  int count = 0;
    800057fa:	4501                	li	a0,0
    800057fc:	bfe5                	j	800057f4 <count_slab_freelist+0x12>

00000000800057fe <print_kmem_cache>:


void print_kmem_cache(struct kmem_cache *cache, void (*slab_obj_printer)(void *))
{
    800057fe:	7119                	addi	sp,sp,-128
    80005800:	fc86                	sd	ra,120(sp)
    80005802:	f8a2                	sd	s0,112(sp)
    80005804:	f4a6                	sd	s1,104(sp)
    80005806:	f0ca                	sd	s2,96(sp)
    80005808:	ecce                	sd	s3,88(sp)
    8000580a:	e8d2                	sd	s4,80(sp)
    8000580c:	e4d6                	sd	s5,72(sp)
    8000580e:	e0da                	sd	s6,64(sp)
    80005810:	fc5e                	sd	s7,56(sp)
    80005812:	f862                	sd	s8,48(sp)
    80005814:	f466                	sd	s9,40(sp)
    80005816:	f06a                	sd	s10,32(sp)
    80005818:	ec6e                	sd	s11,24(sp)
    8000581a:	0100                	addi	s0,sp,128
    8000581c:	892a                	mv	s2,a0
    8000581e:	8aae                	mv	s5,a1
  // TODO: Implement print_kmem_cache
  // printf("[SLAB] TODO: print_kmem_cache is not yet implemented \n");
  acquire(&cache->lock);
    80005820:	04050793          	addi	a5,a0,64
    80005824:	f8f43023          	sd	a5,-128(s0)
    80005828:	853e                	mv	a0,a5
    8000582a:	b70fb0ef          	jal	ra,80000b9a <acquire>
  debug("[SLAB] kmem_cache { name: %s, object_size: %d, at: %p, in_cache_obj: %d }\n",
    8000582e:	f2fff0ef          	jal	ra,8000575c <get_mode>
    80005832:	0005079b          	sext.w	a5,a0
    80005836:	ebb9                	bnez	a5,8000588c <print_kmem_cache+0x8e>
        cache->name, cache->object_size, cache, cache->incache_num);
  int cache_free_objs = count_slab_freelist(((struct slab *)cache));
    80005838:	854a                	mv	a0,s2
    8000583a:	fa9ff0ef          	jal	ra,800057e2 <count_slab_freelist>
  if(cache_free_objs != cache->incache_num){
    8000583e:	06092703          	lw	a4,96(s2)
    80005842:	0005079b          	sext.w	a5,a0
    80005846:	06f71163          	bne	a4,a5,800058a8 <print_kmem_cache+0xaa>
      debug("} }\n");
    }
  
    kfree(is_free);
  }
  if (!list_empty(&cache->partial)) {
    8000584a:	07890793          	addi	a5,s2,120
    8000584e:	873e                	mv	a4,a5
    80005850:	f8f43423          	sd	a5,-120(s0)
    80005854:	08093783          	ld	a5,128(s2)
    80005858:	00f70863          	beq	a4,a5,80005868 <print_kmem_cache+0x6a>
    debug("[SLAB]  [ partial slabs ]\n");
    8000585c:	f01ff0ef          	jal	ra,8000575c <get_mode>
    80005860:	0005079b          	sext.w	a5,a0
    80005864:	12079d63          	bnez	a5,8000599e <print_kmem_cache+0x1a0>
  }
  struct slab *s;
  list_for_each_entry(s, &cache->partial, list) {
    80005868:	08093783          	ld	a5,128(s2)
    8000586c:	ff878c13          	addi	s8,a5,-8
    80005870:	f8843703          	ld	a4,-120(s0)
    80005874:	20f70863          	beq	a4,a5,80005a84 <print_kmem_cache+0x286>
    void *obj_start = (void *)(s + 1);
    struct run *r = s->freelist;
    for (; r != NULL; r = r->next) {
        int idx = ((char *)r - (char *)obj_start) / cache->object_size;
        if (idx >= 0 && idx < cache->num_objects) {
            is_free[idx] = 1;
    80005878:	4d85                	li	s11,1
    }
  
    for (int i = 0; i < cache->num_objects; i++) {
      void *obj = (char *)obj_start + i * cache->object_size;
      void *as_ptr = *(void **)obj;
      debug("[SLAB]    [ idx %d ] { addr: %p, as_ptr: %p, as_obj: {", i, obj, as_ptr);
    8000587a:	00002d17          	auipc	s10,0x2
    8000587e:	196d0d13          	addi	s10,s10,406 # 80007a10 <syscalls+0x568>
      if (slab_obj_printer)
        slab_obj_printer(obj);  
      debug("} }\n");
    80005882:	00002c97          	auipc	s9,0x2
    80005886:	1c6c8c93          	addi	s9,s9,454 # 80007a48 <syscalls+0x5a0>
    8000588a:	a2e9                	j	80005a54 <print_kmem_cache+0x256>
  debug("[SLAB] kmem_cache { name: %s, object_size: %d, at: %p, in_cache_obj: %d }\n",
    8000588c:	06092703          	lw	a4,96(s2)
    80005890:	86ca                	mv	a3,s2
    80005892:	03892603          	lw	a2,56(s2)
    80005896:	01890593          	addi	a1,s2,24
    8000589a:	00002517          	auipc	a0,0x2
    8000589e:	0d650513          	addi	a0,a0,214 # 80007970 <syscalls+0x4c8>
    800058a2:	c01fa0ef          	jal	ra,800004a2 <printf>
    800058a6:	bf49                	j	80005838 <print_kmem_cache+0x3a>
    debug("[SLAB]  [ cache slabs ]\n");
    800058a8:	eb5ff0ef          	jal	ra,8000575c <get_mode>
    800058ac:	0005079b          	sext.w	a5,a0
    800058b0:	e79d                	bnez	a5,800058de <print_kmem_cache+0xe0>
    debug("[SLAB]   [ slab %p ] { freelist: %p, nxt: %p }\n", cache, cache->slab_base.freelist, NULL);
    800058b2:	eabff0ef          	jal	ra,8000575c <get_mode>
    800058b6:	0005079b          	sext.w	a5,a0
    800058ba:	eb8d                	bnez	a5,800058ec <print_kmem_cache+0xee>
    int *is_free = (int *)kalloc();
    800058bc:	a0efb0ef          	jal	ra,80000aca <kalloc>
    800058c0:	8a2a                	mv	s4,a0
    memset(is_free, 0, sizeof(int) * cache->incache_num);
    800058c2:	06092603          	lw	a2,96(s2)
    800058c6:	0026161b          	slliw	a2,a2,0x2
    800058ca:	4581                	li	a1,0
    800058cc:	ba2fb0ef          	jal	ra,80000c6e <memset>
    void *obj_start = (void *)(cache + 1);
    800058d0:	09890993          	addi	s3,s2,152
    struct run *r = cache->slab_base.freelist;
    800058d4:	00093703          	ld	a4,0(s2)
    for (; r != NULL; r = r->next) {
    800058d8:	cb31                	beqz	a4,8000592c <print_kmem_cache+0x12e>
            is_free[idx] = 1;
    800058da:	4585                	li	a1,1
    800058dc:	a02d                	j	80005906 <print_kmem_cache+0x108>
    debug("[SLAB]  [ cache slabs ]\n");
    800058de:	00002517          	auipc	a0,0x2
    800058e2:	0e250513          	addi	a0,a0,226 # 800079c0 <syscalls+0x518>
    800058e6:	bbdfa0ef          	jal	ra,800004a2 <printf>
    800058ea:	b7e1                	j	800058b2 <print_kmem_cache+0xb4>
    debug("[SLAB]   [ slab %p ] { freelist: %p, nxt: %p }\n", cache, cache->slab_base.freelist, NULL);
    800058ec:	4681                	li	a3,0
    800058ee:	00093603          	ld	a2,0(s2)
    800058f2:	85ca                	mv	a1,s2
    800058f4:	00002517          	auipc	a0,0x2
    800058f8:	0ec50513          	addi	a0,a0,236 # 800079e0 <syscalls+0x538>
    800058fc:	ba7fa0ef          	jal	ra,800004a2 <printf>
    80005900:	bf75                	j	800058bc <print_kmem_cache+0xbe>
    for (; r != NULL; r = r->next) {
    80005902:	6318                	ld	a4,0(a4)
    80005904:	c705                	beqz	a4,8000592c <print_kmem_cache+0x12e>
        int idx = ((char *)r - (char *)obj_start) / cache->object_size;
    80005906:	413707b3          	sub	a5,a4,s3
    8000590a:	03896683          	lwu	a3,56(s2)
    8000590e:	02d7c7b3          	div	a5,a5,a3
    80005912:	0007869b          	sext.w	a3,a5
        if (idx >= 0 && idx < cache->incache_num) {
    80005916:	fe06c6e3          	bltz	a3,80005902 <print_kmem_cache+0x104>
    8000591a:	06092603          	lw	a2,96(s2)
    8000591e:	fec6f2e3          	bgeu	a3,a2,80005902 <print_kmem_cache+0x104>
            is_free[idx] = 1;
    80005922:	00269793          	slli	a5,a3,0x2
    80005926:	97d2                	add	a5,a5,s4
    80005928:	c38c                	sw	a1,0(a5)
    8000592a:	bfe1                	j	80005902 <print_kmem_cache+0x104>
    for (int i = 0; i < cache->incache_num; i++) {
    8000592c:	06092783          	lw	a5,96(s2)
    80005930:	c3bd                	beqz	a5,80005996 <print_kmem_cache+0x198>
    80005932:	4b01                	li	s6,0
      debug("[SLAB]    [ idx %d ] { addr: %p, as_ptr: %p, as_obj: {", i, obj, as_ptr);
    80005934:	00002c17          	auipc	s8,0x2
    80005938:	0dcc0c13          	addi	s8,s8,220 # 80007a10 <syscalls+0x568>
      debug("} }\n");
    8000593c:	00002b97          	auipc	s7,0x2
    80005940:	10cb8b93          	addi	s7,s7,268 # 80007a48 <syscalls+0x5a0>
    80005944:	a005                	j	80005964 <print_kmem_cache+0x166>
      debug("[SLAB]    [ idx %d ] { addr: %p, as_ptr: %p, as_obj: {", i, obj, as_ptr);
    80005946:	86e6                	mv	a3,s9
    80005948:	8626                	mv	a2,s1
    8000594a:	85da                	mv	a1,s6
    8000594c:	8562                	mv	a0,s8
    8000594e:	b55fa0ef          	jal	ra,800004a2 <printf>
    80005952:	a035                	j	8000597e <print_kmem_cache+0x180>
    for (int i = 0; i < cache->incache_num; i++) {
    80005954:	001b079b          	addiw	a5,s6,1
    80005958:	00078b1b          	sext.w	s6,a5
    8000595c:	06092703          	lw	a4,96(s2)
    80005960:	02eb7b63          	bgeu	s6,a4,80005996 <print_kmem_cache+0x198>
      void *obj = (char *)obj_start + i * cache->object_size;
    80005964:	03892483          	lw	s1,56(s2)
    80005968:	036484bb          	mulw	s1,s1,s6
    8000596c:	1482                	slli	s1,s1,0x20
    8000596e:	9081                	srli	s1,s1,0x20
    80005970:	94ce                	add	s1,s1,s3
      void *as_ptr = *(void **)obj;
    80005972:	0004bc83          	ld	s9,0(s1)
      debug("[SLAB]    [ idx %d ] { addr: %p, as_ptr: %p, as_obj: {", i, obj, as_ptr);
    80005976:	de7ff0ef          	jal	ra,8000575c <get_mode>
    8000597a:	2501                	sext.w	a0,a0
    8000597c:	f569                	bnez	a0,80005946 <print_kmem_cache+0x148>
      if (slab_obj_printer)
    8000597e:	000a8463          	beqz	s5,80005986 <print_kmem_cache+0x188>
        slab_obj_printer(obj);  
    80005982:	8526                	mv	a0,s1
    80005984:	9a82                	jalr	s5
      debug("} }\n");
    80005986:	dd7ff0ef          	jal	ra,8000575c <get_mode>
    8000598a:	2501                	sext.w	a0,a0
    8000598c:	d561                	beqz	a0,80005954 <print_kmem_cache+0x156>
    8000598e:	855e                	mv	a0,s7
    80005990:	b13fa0ef          	jal	ra,800004a2 <printf>
    80005994:	b7c1                	j	80005954 <print_kmem_cache+0x156>
    kfree(is_free);
    80005996:	8552                	mv	a0,s4
    80005998:	852fb0ef          	jal	ra,800009ea <kfree>
    8000599c:	b57d                	j	8000584a <print_kmem_cache+0x4c>
    debug("[SLAB]  [ partial slabs ]\n");
    8000599e:	00002517          	auipc	a0,0x2
    800059a2:	0b250513          	addi	a0,a0,178 # 80007a50 <syscalls+0x5a8>
    800059a6:	afdfa0ef          	jal	ra,800004a2 <printf>
    800059aa:	bd7d                	j	80005868 <print_kmem_cache+0x6a>
    debug("[SLAB]   [ slab %p ] { freelist: %p, nxt: %p }\n", s, s->freelist, s->list.next);
    800059ac:	010c3683          	ld	a3,16(s8)
    800059b0:	000c3603          	ld	a2,0(s8)
    800059b4:	85e2                	mv	a1,s8
    800059b6:	00002517          	auipc	a0,0x2
    800059ba:	02a50513          	addi	a0,a0,42 # 800079e0 <syscalls+0x538>
    800059be:	ae5fa0ef          	jal	ra,800004a2 <printf>
    800059c2:	a869                	j	80005a5c <print_kmem_cache+0x25e>
    for (; r != NULL; r = r->next) {
    800059c4:	6318                	ld	a4,0(a4)
    800059c6:	cb55                	beqz	a4,80005a7a <print_kmem_cache+0x27c>
        int idx = ((char *)r - (char *)obj_start) / cache->object_size;
    800059c8:	414707b3          	sub	a5,a4,s4
    800059cc:	03896683          	lwu	a3,56(s2)
    800059d0:	02d7c7b3          	div	a5,a5,a3
    800059d4:	0007869b          	sext.w	a3,a5
        if (idx >= 0 && idx < cache->num_objects) {
    800059d8:	fe06c6e3          	bltz	a3,800059c4 <print_kmem_cache+0x1c6>
    800059dc:	05c92603          	lw	a2,92(s2)
    800059e0:	fec6f2e3          	bgeu	a3,a2,800059c4 <print_kmem_cache+0x1c6>
            is_free[idx] = 1;
    800059e4:	068a                	slli	a3,a3,0x2
    800059e6:	96de                	add	a3,a3,s7
    800059e8:	01b6a023          	sw	s11,0(a3)
    800059ec:	bfe1                	j	800059c4 <print_kmem_cache+0x1c6>
      if (slab_obj_printer)
    800059ee:	000a8463          	beqz	s5,800059f6 <print_kmem_cache+0x1f8>
        slab_obj_printer(obj);  
    800059f2:	8526                	mv	a0,s1
    800059f4:	9a82                	jalr	s5
      debug("} }\n");
    800059f6:	d67ff0ef          	jal	ra,8000575c <get_mode>
    800059fa:	2501                	sext.w	a0,a0
    800059fc:	ed0d                	bnez	a0,80005a36 <print_kmem_cache+0x238>
    for (int i = 0; i < cache->num_objects; i++) {
    800059fe:	0019879b          	addiw	a5,s3,1
    80005a02:	0007899b          	sext.w	s3,a5
    80005a06:	05c92703          	lw	a4,92(s2)
    80005a0a:	02e9fa63          	bgeu	s3,a4,80005a3e <print_kmem_cache+0x240>
      void *obj = (char *)obj_start + i * cache->object_size;
    80005a0e:	03892483          	lw	s1,56(s2)
    80005a12:	033484bb          	mulw	s1,s1,s3
    80005a16:	1482                	slli	s1,s1,0x20
    80005a18:	9081                	srli	s1,s1,0x20
    80005a1a:	94d2                	add	s1,s1,s4
      void *as_ptr = *(void **)obj;
    80005a1c:	0004bb03          	ld	s6,0(s1)
      debug("[SLAB]    [ idx %d ] { addr: %p, as_ptr: %p, as_obj: {", i, obj, as_ptr);
    80005a20:	d3dff0ef          	jal	ra,8000575c <get_mode>
    80005a24:	2501                	sext.w	a0,a0
    80005a26:	d561                	beqz	a0,800059ee <print_kmem_cache+0x1f0>
    80005a28:	86da                	mv	a3,s6
    80005a2a:	8626                	mv	a2,s1
    80005a2c:	85ce                	mv	a1,s3
    80005a2e:	856a                	mv	a0,s10
    80005a30:	a73fa0ef          	jal	ra,800004a2 <printf>
    80005a34:	bf6d                	j	800059ee <print_kmem_cache+0x1f0>
      debug("} }\n");
    80005a36:	8566                	mv	a0,s9
    80005a38:	a6bfa0ef          	jal	ra,800004a2 <printf>
    80005a3c:	b7c9                	j	800059fe <print_kmem_cache+0x200>
    }
  
    kfree(is_free);
    80005a3e:	855e                	mv	a0,s7
    80005a40:	fabfa0ef          	jal	ra,800009ea <kfree>
  list_for_each_entry(s, &cache->partial, list) {
    80005a44:	010c3783          	ld	a5,16(s8)
    80005a48:	ff878c13          	addi	s8,a5,-8
    80005a4c:	f8843703          	ld	a4,-120(s0)
    80005a50:	02f70a63          	beq	a4,a5,80005a84 <print_kmem_cache+0x286>
    debug("[SLAB]   [ slab %p ] { freelist: %p, nxt: %p }\n", s, s->freelist, s->list.next);
    80005a54:	d09ff0ef          	jal	ra,8000575c <get_mode>
    80005a58:	2501                	sext.w	a0,a0
    80005a5a:	f929                	bnez	a0,800059ac <print_kmem_cache+0x1ae>
    int *is_free = (int *)kalloc();
    80005a5c:	86efb0ef          	jal	ra,80000aca <kalloc>
    80005a60:	8baa                	mv	s7,a0
    memset(is_free, 0, sizeof(int) * cache->num_objects);
    80005a62:	05c92603          	lw	a2,92(s2)
    80005a66:	0026161b          	slliw	a2,a2,0x2
    80005a6a:	4581                	li	a1,0
    80005a6c:	a02fb0ef          	jal	ra,80000c6e <memset>
    void *obj_start = (void *)(s + 1);
    80005a70:	018c0a13          	addi	s4,s8,24
    struct run *r = s->freelist;
    80005a74:	000c3703          	ld	a4,0(s8)
    for (; r != NULL; r = r->next) {
    80005a78:	fb21                	bnez	a4,800059c8 <print_kmem_cache+0x1ca>
    for (int i = 0; i < cache->num_objects; i++) {
    80005a7a:	05c92783          	lw	a5,92(s2)
    80005a7e:	d3e1                	beqz	a5,80005a3e <print_kmem_cache+0x240>
    80005a80:	4981                	li	s3,0
    80005a82:	b771                	j	80005a0e <print_kmem_cache+0x210>
  }
  debug("[SLAB] print_kmem_cache end\n");
    80005a84:	cd9ff0ef          	jal	ra,8000575c <get_mode>
    80005a88:	0005079b          	sext.w	a5,a0
    80005a8c:	e785                	bnez	a5,80005ab4 <print_kmem_cache+0x2b6>
  release(&cache->lock);
    80005a8e:	f8043503          	ld	a0,-128(s0)
    80005a92:	9a0fb0ef          	jal	ra,80000c32 <release>
}
    80005a96:	70e6                	ld	ra,120(sp)
    80005a98:	7446                	ld	s0,112(sp)
    80005a9a:	74a6                	ld	s1,104(sp)
    80005a9c:	7906                	ld	s2,96(sp)
    80005a9e:	69e6                	ld	s3,88(sp)
    80005aa0:	6a46                	ld	s4,80(sp)
    80005aa2:	6aa6                	ld	s5,72(sp)
    80005aa4:	6b06                	ld	s6,64(sp)
    80005aa6:	7be2                	ld	s7,56(sp)
    80005aa8:	7c42                	ld	s8,48(sp)
    80005aaa:	7ca2                	ld	s9,40(sp)
    80005aac:	7d02                	ld	s10,32(sp)
    80005aae:	6de2                	ld	s11,24(sp)
    80005ab0:	6109                	addi	sp,sp,128
    80005ab2:	8082                	ret
  debug("[SLAB] print_kmem_cache end\n");
    80005ab4:	00002517          	auipc	a0,0x2
    80005ab8:	fbc50513          	addi	a0,a0,-68 # 80007a70 <syscalls+0x5c8>
    80005abc:	9e7fa0ef          	jal	ra,800004a2 <printf>
    80005ac0:	b7f9                	j	80005a8e <print_kmem_cache+0x290>

0000000080005ac2 <kmem_cache_create>:

struct kmem_cache *kmem_cache_create(char *name, uint object_size)
{
    80005ac2:	7179                	addi	sp,sp,-48
    80005ac4:	f406                	sd	ra,40(sp)
    80005ac6:	f022                	sd	s0,32(sp)
    80005ac8:	ec26                	sd	s1,24(sp)
    80005aca:	e84a                	sd	s2,16(sp)
    80005acc:	e44e                	sd	s3,8(sp)
    80005ace:	e052                	sd	s4,0(sp)
    80005ad0:	1800                	addi	s0,sp,48
    80005ad2:	8a2a                	mv	s4,a0
    80005ad4:	89ae                	mv	s3,a1
  // TODO: Implement kmem_cache_create
  // printf("[SLAB] TODO: kmem_cache_create is not yet implemented \n");
  
  struct kmem_cache *cache = (struct kmem_cache *)kalloc();
    80005ad6:	ff5fa0ef          	jal	ra,80000aca <kalloc>
    80005ada:	84aa                	mv	s1,a0
  int len = strlen(name) + 1;
    80005adc:	8552                	mv	a0,s4
    80005ade:	b08fb0ef          	jal	ra,80000de6 <strlen>
  strncpy(cache->name, name, len);
    80005ae2:	01848913          	addi	s2,s1,24
    80005ae6:	0015061b          	addiw	a2,a0,1
    80005aea:	85d2                	mv	a1,s4
    80005aec:	854a                	mv	a0,s2
    80005aee:	a88fb0ef          	jal	ra,80000d76 <strncpy>
  cache->object_size = object_size;
    80005af2:	0334ac23          	sw	s3,56(s1)
  cache->member_num = 0;
    80005af6:	0404ac23          	sw	zero,88(s1)

  INIT_LIST_HEAD(&cache->full);
    80005afa:	06848793          	addi	a5,s1,104
 * operations to an uninitialized node results in undefined behavior, such as
 * memory corruption or crashes.
 */
static inline void INIT_LIST_HEAD(struct list_head *head)
{
  head->next = head;
    80005afe:	f8bc                	sd	a5,112(s1)
  head->prev = head;
    80005b00:	f4bc                	sd	a5,104(s1)
  INIT_LIST_HEAD(&cache->partial);
    80005b02:	07848793          	addi	a5,s1,120
  head->next = head;
    80005b06:	e0dc                	sd	a5,128(s1)
  head->prev = head;
    80005b08:	fcbc                	sd	a5,120(s1)
  INIT_LIST_HEAD(&cache->free);
    80005b0a:	08848793          	addi	a5,s1,136
  head->next = head;
    80005b0e:	e8dc                	sd	a5,144(s1)
  head->prev = head;
    80005b10:	e4dc                	sd	a5,136(s1)
  initlock(&cache->lock, cache->name);
    80005b12:	85ca                	mv	a1,s2
    80005b14:	04048513          	addi	a0,s1,64
    80005b18:	802fb0ef          	jal	ra,80000b1a <initlock>

  int slab_space_available = PGSIZE - sizeof(struct slab);
  int slab_num_objects = slab_space_available / object_size;
    80005b1c:	6785                	lui	a5,0x1
    80005b1e:	fe87859b          	addiw	a1,a5,-24
    80005b22:	0335d9bb          	divuw	s3,a1,s3
  cache->num_objects = slab_num_objects;
    80005b26:	0534ae23          	sw	s3,92(s1)

  //create in-cache slab
  int space_available = PGSIZE - sizeof(struct kmem_cache);
  int num_objects = space_available / cache->object_size;
    80005b2a:	f687879b          	addiw	a5,a5,-152
    80005b2e:	5c98                	lw	a4,56(s1)
    80005b30:	02e7d7bb          	divuw	a5,a5,a4
    80005b34:	0007881b          	sext.w	a6,a5
  cache->incache_num = num_objects;
    80005b38:	d0bc                	sw	a5,96(s1)
  void *obj_start = (void *)(cache + 1);
    80005b3a:	09848513          	addi	a0,s1,152
  struct run *curr, *next;

  for (int i = 0; i < num_objects; i++) {
    80005b3e:	03005b63          	blez	a6,80005b74 <kmem_cache_create+0xb2>
    80005b42:	4701                	li	a4,0
    curr = (struct run *)((char *)obj_start + i * cache->object_size);
    next = (i < num_objects - 1) ? 
            (struct run *)((char *)obj_start + (i + 1) * cache->object_size) : NULL;
    80005b44:	fff8031b          	addiw	t1,a6,-1
    80005b48:	4881                	li	a7,0
    80005b4a:	a029                	j	80005b54 <kmem_cache_create+0x92>
    curr->next = next;
    80005b4c:	e290                	sd	a2,0(a3)
  for (int i = 0; i < num_objects; i++) {
    80005b4e:	2705                	addiw	a4,a4,1
    80005b50:	02e80263          	beq	a6,a4,80005b74 <kmem_cache_create+0xb2>
    curr = (struct run *)((char *)obj_start + i * cache->object_size);
    80005b54:	5c9c                	lw	a5,56(s1)
    80005b56:	02f705bb          	mulw	a1,a4,a5
    80005b5a:	02059693          	slli	a3,a1,0x20
    80005b5e:	9281                	srli	a3,a3,0x20
    80005b60:	96aa                	add	a3,a3,a0
            (struct run *)((char *)obj_start + (i + 1) * cache->object_size) : NULL;
    80005b62:	8646                	mv	a2,a7
    80005b64:	fe6754e3          	bge	a4,t1,80005b4c <kmem_cache_create+0x8a>
    80005b68:	9fad                	addw	a5,a5,a1
    80005b6a:	1782                	slli	a5,a5,0x20
    80005b6c:	9381                	srli	a5,a5,0x20
    80005b6e:	00f50633          	add	a2,a0,a5
    80005b72:	bfe9                	j	80005b4c <kmem_cache_create+0x8a>
  }

  cache->slab_base.freelist = (struct run *)obj_start;
    80005b74:	e088                	sd	a0,0(s1)

  debug("[SLAB] New kmem_cache (name: %s, object size: %d bytes, at: %p, max objects per slab: %d, support in cache obj: %d) is created\n",
    80005b76:	be7ff0ef          	jal	ra,8000575c <get_mode>
    80005b7a:	2501                	sext.w	a0,a0
    80005b7c:	e911                	bnez	a0,80005b90 <kmem_cache_create+0xce>
        cache->name, cache->object_size, cache, cache->num_objects, cache->incache_num);
  return cache;
}
    80005b7e:	8526                	mv	a0,s1
    80005b80:	70a2                	ld	ra,40(sp)
    80005b82:	7402                	ld	s0,32(sp)
    80005b84:	64e2                	ld	s1,24(sp)
    80005b86:	6942                	ld	s2,16(sp)
    80005b88:	69a2                	ld	s3,8(sp)
    80005b8a:	6a02                	ld	s4,0(sp)
    80005b8c:	6145                	addi	sp,sp,48
    80005b8e:	8082                	ret
  debug("[SLAB] New kmem_cache (name: %s, object size: %d bytes, at: %p, max objects per slab: %d, support in cache obj: %d) is created\n",
    80005b90:	50bc                	lw	a5,96(s1)
    80005b92:	4cf8                	lw	a4,92(s1)
    80005b94:	86a6                	mv	a3,s1
    80005b96:	5c90                	lw	a2,56(s1)
    80005b98:	85ca                	mv	a1,s2
    80005b9a:	00002517          	auipc	a0,0x2
    80005b9e:	ef650513          	addi	a0,a0,-266 # 80007a90 <syscalls+0x5e8>
    80005ba2:	901fa0ef          	jal	ra,800004a2 <printf>
  return cache;
    80005ba6:	bfe1                	j	80005b7e <kmem_cache_create+0xbc>

0000000080005ba8 <kmem_cache_destroy>:

void kmem_cache_destroy(struct kmem_cache *cache)
{
    80005ba8:	7179                	addi	sp,sp,-48
    80005baa:	f406                	sd	ra,40(sp)
    80005bac:	f022                	sd	s0,32(sp)
    80005bae:	ec26                	sd	s1,24(sp)
    80005bb0:	e84a                	sd	s2,16(sp)
    80005bb2:	e44e                	sd	s3,8(sp)
    80005bb4:	1800                	addi	s0,sp,48
    80005bb6:	892a                	mv	s2,a0
  // TODO: Implement kmem_cache_destroy (will not be tested)
  // printf("[SLAB] TODO: kmem_cache_destroy is not yet implemented \n");
  struct slab *s, *tmp;

    // Free all slabs in free list
    list_for_each_entry_safe(s, tmp, &cache->free, list) {
    80005bb8:	695c                	ld	a5,144(a0)
    80005bba:	ff878513          	addi	a0,a5,-8 # ff8 <_entry-0x7ffff008>
    80005bbe:	6784                	ld	s1,8(a5)
    80005bc0:	14e1                	addi	s1,s1,-8
    80005bc2:	08890993          	addi	s3,s2,136
    80005bc6:	00f98f63          	beq	s3,a5,80005be4 <kmem_cache_destroy+0x3c>
 * this operation. To reintegrate @node into a list, it must be reinitialized
 * (e.g., via INIT_LIST_HEAD).
 */
static inline void list_del(struct list_head *node)
{
  struct list_head *next = node->next;
    80005bca:	6918                	ld	a4,16(a0)
  struct list_head *prev = node->prev;
    80005bcc:	651c                	ld	a5,8(a0)

  next->prev = prev;
    80005bce:	e31c                	sd	a5,0(a4)
  prev->next = next;
    80005bd0:	e798                	sd	a4,8(a5)
        list_del(&s->list);
        kfree((void *)s);
    80005bd2:	e19fa0ef          	jal	ra,800009ea <kfree>
    list_for_each_entry_safe(s, tmp, &cache->free, list) {
    80005bd6:	8526                	mv	a0,s1
    80005bd8:	6884                	ld	s1,16(s1)
    80005bda:	14e1                	addi	s1,s1,-8
    80005bdc:	00850793          	addi	a5,a0,8
    80005be0:	ff3795e3          	bne	a5,s3,80005bca <kmem_cache_destroy+0x22>
    }

    // Free all slabs in partial list
    list_for_each_entry_safe(s, tmp, &cache->partial, list) {
    80005be4:	08093783          	ld	a5,128(s2)
    80005be8:	ff878513          	addi	a0,a5,-8
    80005bec:	6784                	ld	s1,8(a5)
    80005bee:	14e1                	addi	s1,s1,-8
    80005bf0:	07890993          	addi	s3,s2,120
    80005bf4:	00f98f63          	beq	s3,a5,80005c12 <kmem_cache_destroy+0x6a>
  struct list_head *next = node->next;
    80005bf8:	6918                	ld	a4,16(a0)
  struct list_head *prev = node->prev;
    80005bfa:	651c                	ld	a5,8(a0)
  next->prev = prev;
    80005bfc:	e31c                	sd	a5,0(a4)
  prev->next = next;
    80005bfe:	e798                	sd	a4,8(a5)
        list_del(&s->list);
        kfree((void *)s);
    80005c00:	debfa0ef          	jal	ra,800009ea <kfree>
    list_for_each_entry_safe(s, tmp, &cache->partial, list) {
    80005c04:	8526                	mv	a0,s1
    80005c06:	6884                	ld	s1,16(s1)
    80005c08:	14e1                	addi	s1,s1,-8
    80005c0a:	00850793          	addi	a5,a0,8
    80005c0e:	ff3795e3          	bne	a5,s3,80005bf8 <kmem_cache_destroy+0x50>
    }

    // Free all slabs in full list
    list_for_each_entry_safe(s, tmp, &cache->full, list) {
    80005c12:	07093783          	ld	a5,112(s2)
    80005c16:	ff878513          	addi	a0,a5,-8
    80005c1a:	6784                	ld	s1,8(a5)
    80005c1c:	14e1                	addi	s1,s1,-8
    80005c1e:	06890993          	addi	s3,s2,104
    80005c22:	00f98f63          	beq	s3,a5,80005c40 <kmem_cache_destroy+0x98>
  struct list_head *next = node->next;
    80005c26:	6918                	ld	a4,16(a0)
  struct list_head *prev = node->prev;
    80005c28:	651c                	ld	a5,8(a0)
  next->prev = prev;
    80005c2a:	e31c                	sd	a5,0(a4)
  prev->next = next;
    80005c2c:	e798                	sd	a4,8(a5)
        list_del(&s->list);
        kfree((void *)s);
    80005c2e:	dbdfa0ef          	jal	ra,800009ea <kfree>
    list_for_each_entry_safe(s, tmp, &cache->full, list) {
    80005c32:	8526                	mv	a0,s1
    80005c34:	6884                	ld	s1,16(s1)
    80005c36:	14e1                	addi	s1,s1,-8
    80005c38:	00850793          	addi	a5,a0,8
    80005c3c:	ff3795e3          	bne	a5,s3,80005c26 <kmem_cache_destroy+0x7e>
    }

    kfree(cache);
    80005c40:	854a                	mv	a0,s2
    80005c42:	da9fa0ef          	jal	ra,800009ea <kfree>
}
    80005c46:	70a2                	ld	ra,40(sp)
    80005c48:	7402                	ld	s0,32(sp)
    80005c4a:	64e2                	ld	s1,24(sp)
    80005c4c:	6942                	ld	s2,16(sp)
    80005c4e:	69a2                	ld	s3,8(sp)
    80005c50:	6145                	addi	sp,sp,48
    80005c52:	8082                	ret

0000000080005c54 <kmem_cache_alloc>:

void *kmem_cache_alloc(struct kmem_cache *cache)
{
    80005c54:	7139                	addi	sp,sp,-64
    80005c56:	fc06                	sd	ra,56(sp)
    80005c58:	f822                	sd	s0,48(sp)
    80005c5a:	f426                	sd	s1,40(sp)
    80005c5c:	f04a                	sd	s2,32(sp)
    80005c5e:	ec4e                	sd	s3,24(sp)
    80005c60:	e852                	sd	s4,16(sp)
    80005c62:	e456                	sd	s5,8(sp)
    80005c64:	0080                	addi	s0,sp,64
    80005c66:	84aa                	mv	s1,a0
  // TODO: Implement kmem_cache_alloc
  // printf("[SLAB] TODO: kmem_cache_alloc is not yet implemented \n");
  acquire(&cache->lock); // acquire the lock before modification
    80005c68:	04050a13          	addi	s4,a0,64
    80005c6c:	8552                	mv	a0,s4
    80005c6e:	f2dfa0ef          	jal	ra,80000b9a <acquire>
  debug("[SLAB] Alloc request on cache %s\n", cache->name);
    80005c72:	aebff0ef          	jal	ra,8000575c <get_mode>
    80005c76:	2501                	sext.w	a0,a0
    80005c78:	ed1d                	bnez	a0,80005cb6 <kmem_cache_alloc+0x62>
 *
 * Returns: 0 if the list has nodes, non-zero if the list is empty.
 */
static inline int list_empty(const struct list_head *head)
{
  return (head->next == head);
    80005c7a:	0804b903          	ld	s2,128(s1)
  if(!list_empty(&cache->partial)){
    80005c7e:	07848793          	addi	a5,s1,120
    80005c82:	08f90463          	beq	s2,a5,80005d0a <kmem_cache_alloc+0xb6>
    struct slab *s = list_first_entry(&cache->partial, struct slab, list);
    void *obj = (void *)s->freelist;
    80005c86:	ff893983          	ld	s3,-8(s2)
    s->freelist = s->freelist->next;
    80005c8a:	0009b783          	ld	a5,0(s3)
    80005c8e:	fef93c23          	sd	a5,-8(s2)
    // s->inuse += 1;
    if(s->freelist == NULL){
    80005c92:	cb9d                	beqz	a5,80005cc8 <kmem_cache_alloc+0x74>
      list_move(&s->list, &cache->full);
      // s->state = SLAB_FULL;
      cache->member_num -= 1;
    }
    // debug("partial\n");
    debug("[SLAB] Object %p in slab %p (%s) is allocated and initialized\n"
    80005c94:	ac9ff0ef          	jal	ra,8000575c <get_mode>
    80005c98:	2501                	sext.w	a0,a0
    80005c9a:	ed21                	bnez	a0,80005cf2 <kmem_cache_alloc+0x9e>
          , obj, s, cache->name);
    release(&cache->lock);
    80005c9c:	8552                	mv	a0,s4
    80005c9e:	f95fa0ef          	jal	ra,80000c32 <release>
    release(&cache->lock);
    return obj;
  }
  release(&cache->lock); // release the lock before return
  return 0;
}
    80005ca2:	854e                	mv	a0,s3
    80005ca4:	70e2                	ld	ra,56(sp)
    80005ca6:	7442                	ld	s0,48(sp)
    80005ca8:	74a2                	ld	s1,40(sp)
    80005caa:	7902                	ld	s2,32(sp)
    80005cac:	69e2                	ld	s3,24(sp)
    80005cae:	6a42                	ld	s4,16(sp)
    80005cb0:	6aa2                	ld	s5,8(sp)
    80005cb2:	6121                	addi	sp,sp,64
    80005cb4:	8082                	ret
  debug("[SLAB] Alloc request on cache %s\n", cache->name);
    80005cb6:	01848593          	addi	a1,s1,24
    80005cba:	00002517          	auipc	a0,0x2
    80005cbe:	e5650513          	addi	a0,a0,-426 # 80007b10 <syscalls+0x668>
    80005cc2:	fe0fa0ef          	jal	ra,800004a2 <printf>
    80005cc6:	bf55                	j	80005c7a <kmem_cache_alloc+0x26>
  struct list_head *next = node->next;
    80005cc8:	00893703          	ld	a4,8(s2)
  struct list_head *prev = node->prev;
    80005ccc:	00093783          	ld	a5,0(s2)
  next->prev = prev;
    80005cd0:	e31c                	sd	a5,0(a4)
  prev->next = next;
    80005cd2:	e798                	sd	a4,8(a5)
  struct list_head *next = head->next;
    80005cd4:	78bc                	ld	a5,112(s1)
  next->prev = node;
    80005cd6:	0127b023          	sd	s2,0(a5)
  node->next = next;
    80005cda:	00f93423          	sd	a5,8(s2)
      list_move(&s->list, &cache->full);
    80005cde:	06848793          	addi	a5,s1,104
  node->prev = head;
    80005ce2:	00f93023          	sd	a5,0(s2)
  head->next = node;
    80005ce6:	0724b823          	sd	s2,112(s1)
      cache->member_num -= 1;
    80005cea:	4cbc                	lw	a5,88(s1)
    80005cec:	37fd                	addiw	a5,a5,-1
    80005cee:	ccbc                	sw	a5,88(s1)
    80005cf0:	b755                	j	80005c94 <kmem_cache_alloc+0x40>
    debug("[SLAB] Object %p in slab %p (%s) is allocated and initialized\n"
    80005cf2:	01848693          	addi	a3,s1,24
    80005cf6:	ff890613          	addi	a2,s2,-8
    80005cfa:	85ce                	mv	a1,s3
    80005cfc:	00002517          	auipc	a0,0x2
    80005d00:	e3c50513          	addi	a0,a0,-452 # 80007b38 <syscalls+0x690>
    80005d04:	f9efa0ef          	jal	ra,800004a2 <printf>
    80005d08:	bf51                	j	80005c9c <kmem_cache_alloc+0x48>
  return (head->next == head);
    80005d0a:	0904ba83          	ld	s5,144(s1)
  }else if(!list_empty(&cache->free)){
    80005d0e:	08848793          	addi	a5,s1,136
    80005d12:	02fa9163          	bne	s5,a5,80005d34 <kmem_cache_alloc+0xe0>
  }else if(cache->slab_base.freelist != NULL){
    80005d16:	0004b983          	ld	s3,0(s1)
    80005d1a:	08098163          	beqz	s3,80005d9c <kmem_cache_alloc+0x148>
    cache->slab_base.freelist = cache->slab_base.freelist->next;
    80005d1e:	0009b783          	ld	a5,0(s3)
    80005d22:	e09c                	sd	a5,0(s1)
    debug("[SLAB] Object %p in slab %p (%s) is allocated and initialized\n", obj, cache, cache->name);
    80005d24:	a39ff0ef          	jal	ra,8000575c <get_mode>
    80005d28:	2501                	sext.w	a0,a0
    80005d2a:	ed31                	bnez	a0,80005d86 <kmem_cache_alloc+0x132>
    release(&cache->lock);
    80005d2c:	8552                	mv	a0,s4
    80005d2e:	f05fa0ef          	jal	ra,80000c32 <release>
    return obj;
    80005d32:	bf85                	j	80005ca2 <kmem_cache_alloc+0x4e>
    void *obj = (void *)s->freelist;
    80005d34:	ff8ab983          	ld	s3,-8(s5)
    s->freelist = s->freelist->next;
    80005d38:	0009b783          	ld	a5,0(s3)
    80005d3c:	fefabc23          	sd	a5,-8(s5)
  struct list_head *next = node->next;
    80005d40:	008ab703          	ld	a4,8(s5)
  struct list_head *prev = node->prev;
    80005d44:	000ab783          	ld	a5,0(s5)
  next->prev = prev;
    80005d48:	e31c                	sd	a5,0(a4)
  prev->next = next;
    80005d4a:	e798                	sd	a4,8(a5)
  struct list_head *next = head->next;
    80005d4c:	60dc                	ld	a5,128(s1)
  next->prev = node;
    80005d4e:	0157b023          	sd	s5,0(a5)
  node->next = next;
    80005d52:	00fab423          	sd	a5,8(s5)
  node->prev = head;
    80005d56:	012ab023          	sd	s2,0(s5)
  head->next = node;
    80005d5a:	0954b023          	sd	s5,128(s1)
    debug("[SLAB] Object %p in slab %p (%s) is allocated and initialized\n"
    80005d5e:	9ffff0ef          	jal	ra,8000575c <get_mode>
    80005d62:	2501                	sext.w	a0,a0
    80005d64:	e509                	bnez	a0,80005d6e <kmem_cache_alloc+0x11a>
    release(&cache->lock);
    80005d66:	8552                	mv	a0,s4
    80005d68:	ecbfa0ef          	jal	ra,80000c32 <release>
    return obj;
    80005d6c:	bf1d                	j	80005ca2 <kmem_cache_alloc+0x4e>
    debug("[SLAB] Object %p in slab %p (%s) is allocated and initialized\n"
    80005d6e:	01848693          	addi	a3,s1,24
    80005d72:	ff8a8613          	addi	a2,s5,-8
    80005d76:	85ce                	mv	a1,s3
    80005d78:	00002517          	auipc	a0,0x2
    80005d7c:	dc050513          	addi	a0,a0,-576 # 80007b38 <syscalls+0x690>
    80005d80:	f22fa0ef          	jal	ra,800004a2 <printf>
    80005d84:	b7cd                	j	80005d66 <kmem_cache_alloc+0x112>
    debug("[SLAB] Object %p in slab %p (%s) is allocated and initialized\n", obj, cache, cache->name);
    80005d86:	01848693          	addi	a3,s1,24
    80005d8a:	8626                	mv	a2,s1
    80005d8c:	85ce                	mv	a1,s3
    80005d8e:	00002517          	auipc	a0,0x2
    80005d92:	daa50513          	addi	a0,a0,-598 # 80007b38 <syscalls+0x690>
    80005d96:	f0cfa0ef          	jal	ra,800004a2 <printf>
    80005d9a:	bf49                	j	80005d2c <kmem_cache_alloc+0xd8>
    struct slab *s = create_slab(cache->object_size);
    80005d9c:	5c88                	lw	a0,56(s1)
    80005d9e:	9e9ff0ef          	jal	ra,80005786 <create_slab>
    80005da2:	8aaa                	mv	s5,a0
    debug("[SLAB] A new slab %p (%s) is allocated\n", s, cache->name);
    80005da4:	9b9ff0ef          	jal	ra,8000575c <get_mode>
    80005da8:	2501                	sext.w	a0,a0
    80005daa:	e91d                	bnez	a0,80005de0 <kmem_cache_alloc+0x18c>
    list_add_tail(&s->list, &cache->partial);
    80005dac:	008a8793          	addi	a5,s5,8
  struct list_head *prev = head->prev;
    80005db0:	7cb8                	ld	a4,120(s1)
  prev->next = node;
    80005db2:	e71c                	sd	a5,8(a4)
  node->next = head;
    80005db4:	012ab823          	sd	s2,16(s5)
  node->prev = prev;
    80005db8:	00eab423          	sd	a4,8(s5)
  head->prev = node;
    80005dbc:	fcbc                	sd	a5,120(s1)
    cache->member_num += 1;
    80005dbe:	4cbc                	lw	a5,88(s1)
    80005dc0:	2785                	addiw	a5,a5,1
    80005dc2:	ccbc                	sw	a5,88(s1)
    void *obj = (void *)s->freelist;
    80005dc4:	000ab983          	ld	s3,0(s5)
    s->freelist = s->freelist->next;
    80005dc8:	0009b783          	ld	a5,0(s3)
    80005dcc:	00fab023          	sd	a5,0(s5)
    debug("[SLAB] Object %p in slab %p (%s) is allocated and initialized\n"
    80005dd0:	98dff0ef          	jal	ra,8000575c <get_mode>
    80005dd4:	2501                	sext.w	a0,a0
    80005dd6:	ed19                	bnez	a0,80005df4 <kmem_cache_alloc+0x1a0>
    release(&cache->lock);
    80005dd8:	8552                	mv	a0,s4
    80005dda:	e59fa0ef          	jal	ra,80000c32 <release>
    return obj;
    80005dde:	b5d1                	j	80005ca2 <kmem_cache_alloc+0x4e>
    debug("[SLAB] A new slab %p (%s) is allocated\n", s, cache->name);
    80005de0:	01848613          	addi	a2,s1,24
    80005de4:	85d6                	mv	a1,s5
    80005de6:	00002517          	auipc	a0,0x2
    80005dea:	d9250513          	addi	a0,a0,-622 # 80007b78 <syscalls+0x6d0>
    80005dee:	eb4fa0ef          	jal	ra,800004a2 <printf>
    80005df2:	bf6d                	j	80005dac <kmem_cache_alloc+0x158>
    debug("[SLAB] Object %p in slab %p (%s) is allocated and initialized\n"
    80005df4:	01848693          	addi	a3,s1,24
    80005df8:	8656                	mv	a2,s5
    80005dfa:	85ce                	mv	a1,s3
    80005dfc:	00002517          	auipc	a0,0x2
    80005e00:	d3c50513          	addi	a0,a0,-708 # 80007b38 <syscalls+0x690>
    80005e04:	e9efa0ef          	jal	ra,800004a2 <printf>
    80005e08:	bfc1                	j	80005dd8 <kmem_cache_alloc+0x184>

0000000080005e0a <kmem_cache_free>:

void kmem_cache_free(struct kmem_cache *cache, void *obj)
{
    80005e0a:	7179                	addi	sp,sp,-48
    80005e0c:	f406                	sd	ra,40(sp)
    80005e0e:	f022                	sd	s0,32(sp)
    80005e10:	ec26                	sd	s1,24(sp)
    80005e12:	e84a                	sd	s2,16(sp)
    80005e14:	e44e                	sd	s3,8(sp)
    80005e16:	e052                	sd	s4,0(sp)
    80005e18:	1800                	addi	s0,sp,48
    80005e1a:	892a                	mv	s2,a0
    80005e1c:	89ae                	mv	s3,a1
  // TODO: Implement kmem_cache_free
  // printf("[SLAB] TODO: kmem_cache_free is not yet implemented \n");
  acquire(&cache->lock); // acquire the lock before modification
    80005e1e:	04050a13          	addi	s4,a0,64
    80005e22:	8552                	mv	a0,s4
    80005e24:	d77fa0ef          	jal	ra,80000b9a <acquire>
  struct slab *s = (struct slab *)((uint64)obj & ~(PGSIZE - 1));
    80005e28:	74fd                	lui	s1,0xfffff
    80005e2a:	0099f4b3          	and	s1,s3,s1
  struct run *r = (struct run *)obj;
  r->next = s->freelist;
    80005e2e:	609c                	ld	a5,0(s1)
    80005e30:	00f9b023          	sd	a5,0(s3)
  s->freelist = r;
    80005e34:	0134b023          	sd	s3,0(s1) # fffffffffffff000 <end+0xffffffff7ffc3000>
  if((void *)s == (void *)cache){ // free the in-cache object and return
    80005e38:	04990163          	beq	s2,s1,80005e7a <kmem_cache_free+0x70>
    debug("[SLAB] End of free\n");
    release(&cache->lock); // release the lock before return
    return;
  }
  // s->inuse -= 1;
  debug("[SLAB] Free %p in slab %p (%s)\n", obj, s, cache->name);
    80005e3c:	921ff0ef          	jal	ra,8000575c <get_mode>
    80005e40:	2501                	sext.w	a0,a0
    80005e42:	e935                	bnez	a0,80005eb6 <kmem_cache_free+0xac>
  int free_objs = count_slab_freelist(s);
    80005e44:	8526                	mv	a0,s1
    80005e46:	99dff0ef          	jal	ra,800057e2 <count_slab_freelist>
  if(free_objs == 1){
    80005e4a:	4785                	li	a5,1
    80005e4c:	08f50063          	beq	a0,a5,80005ecc <kmem_cache_free+0xc2>
    // s->state = SLAB_PARTIAL;
    list_move(&s->list, &cache->partial);
    cache->member_num += 1;
  }
  if(free_objs == cache->num_objects){
    80005e50:	05c92783          	lw	a5,92(s2)
    80005e54:	2501                	sext.w	a0,a0
    80005e56:	0aa78063          	beq	a5,a0,80005ef6 <kmem_cache_free+0xec>
      debug("[SLAB] slab %p (%s) is freed due to save memory\n", s, cache->name);
      list_del(&s->list);
      kfree((void *) s);
    }
  }
  debug("[SLAB] End of free\n");
    80005e5a:	903ff0ef          	jal	ra,8000575c <get_mode>
    80005e5e:	2501                	sext.w	a0,a0
    80005e60:	0e051563          	bnez	a0,80005f4a <kmem_cache_free+0x140>
  release(&cache->lock); // release the lock before return
    80005e64:	8552                	mv	a0,s4
    80005e66:	dcdfa0ef          	jal	ra,80000c32 <release>
}
    80005e6a:	70a2                	ld	ra,40(sp)
    80005e6c:	7402                	ld	s0,32(sp)
    80005e6e:	64e2                	ld	s1,24(sp)
    80005e70:	6942                	ld	s2,16(sp)
    80005e72:	69a2                	ld	s3,8(sp)
    80005e74:	6a02                	ld	s4,0(sp)
    80005e76:	6145                	addi	sp,sp,48
    80005e78:	8082                	ret
    debug("[SLAB] Free %p in slab %p (%s)\n", obj, s, cache->name);
    80005e7a:	8e3ff0ef          	jal	ra,8000575c <get_mode>
    80005e7e:	2501                	sext.w	a0,a0
    80005e80:	e909                	bnez	a0,80005e92 <kmem_cache_free+0x88>
    debug("[SLAB] End of free\n");
    80005e82:	8dbff0ef          	jal	ra,8000575c <get_mode>
    80005e86:	2501                	sext.w	a0,a0
    80005e88:	e105                	bnez	a0,80005ea8 <kmem_cache_free+0x9e>
    release(&cache->lock); // release the lock before return
    80005e8a:	8552                	mv	a0,s4
    80005e8c:	da7fa0ef          	jal	ra,80000c32 <release>
    return;
    80005e90:	bfe9                	j	80005e6a <kmem_cache_free+0x60>
    debug("[SLAB] Free %p in slab %p (%s)\n", obj, s, cache->name);
    80005e92:	01890693          	addi	a3,s2,24
    80005e96:	8626                	mv	a2,s1
    80005e98:	85ce                	mv	a1,s3
    80005e9a:	00002517          	auipc	a0,0x2
    80005e9e:	d0650513          	addi	a0,a0,-762 # 80007ba0 <syscalls+0x6f8>
    80005ea2:	e00fa0ef          	jal	ra,800004a2 <printf>
    80005ea6:	bff1                	j	80005e82 <kmem_cache_free+0x78>
    debug("[SLAB] End of free\n");
    80005ea8:	00002517          	auipc	a0,0x2
    80005eac:	d1850513          	addi	a0,a0,-744 # 80007bc0 <syscalls+0x718>
    80005eb0:	df2fa0ef          	jal	ra,800004a2 <printf>
    80005eb4:	bfd9                	j	80005e8a <kmem_cache_free+0x80>
  debug("[SLAB] Free %p in slab %p (%s)\n", obj, s, cache->name);
    80005eb6:	01890693          	addi	a3,s2,24
    80005eba:	8626                	mv	a2,s1
    80005ebc:	85ce                	mv	a1,s3
    80005ebe:	00002517          	auipc	a0,0x2
    80005ec2:	ce250513          	addi	a0,a0,-798 # 80007ba0 <syscalls+0x6f8>
    80005ec6:	ddcfa0ef          	jal	ra,800004a2 <printf>
    80005eca:	bfad                	j	80005e44 <kmem_cache_free+0x3a>
    list_move(&s->list, &cache->partial);
    80005ecc:	00848793          	addi	a5,s1,8
  struct list_head *next = node->next;
    80005ed0:	6894                	ld	a3,16(s1)
  struct list_head *prev = node->prev;
    80005ed2:	6498                	ld	a4,8(s1)
  next->prev = prev;
    80005ed4:	e298                	sd	a4,0(a3)
  prev->next = next;
    80005ed6:	e714                	sd	a3,8(a4)
  struct list_head *next = head->next;
    80005ed8:	08093703          	ld	a4,128(s2)
  next->prev = node;
    80005edc:	e31c                	sd	a5,0(a4)
  node->next = next;
    80005ede:	e898                	sd	a4,16(s1)
    80005ee0:	07890713          	addi	a4,s2,120
  node->prev = head;
    80005ee4:	e498                	sd	a4,8(s1)
  head->next = node;
    80005ee6:	08f93023          	sd	a5,128(s2)
    cache->member_num += 1;
    80005eea:	05892783          	lw	a5,88(s2)
    80005eee:	2785                	addiw	a5,a5,1
    80005ef0:	04f92c23          	sw	a5,88(s2)
    80005ef4:	bfb1                	j	80005e50 <kmem_cache_free+0x46>
    list_move(&s->list, &cache->free);
    80005ef6:	00848793          	addi	a5,s1,8
  struct list_head *next = node->next;
    80005efa:	6894                	ld	a3,16(s1)
  struct list_head *prev = node->prev;
    80005efc:	6498                	ld	a4,8(s1)
  next->prev = prev;
    80005efe:	e298                	sd	a4,0(a3)
  prev->next = next;
    80005f00:	e714                	sd	a3,8(a4)
  struct list_head *next = head->next;
    80005f02:	09093703          	ld	a4,144(s2)
  next->prev = node;
    80005f06:	e31c                	sd	a5,0(a4)
  node->next = next;
    80005f08:	e898                	sd	a4,16(s1)
    80005f0a:	08890713          	addi	a4,s2,136
  node->prev = head;
    80005f0e:	e498                	sd	a4,8(s1)
  head->next = node;
    80005f10:	08f93823          	sd	a5,144(s2)
    if(cache->member_num > MP2_MIN_AVAIL_SLAB){
    80005f14:	05892703          	lw	a4,88(s2)
    80005f18:	4789                	li	a5,2
    80005f1a:	f4e7f0e3          	bgeu	a5,a4,80005e5a <kmem_cache_free+0x50>
      debug("[SLAB] slab %p (%s) is freed due to save memory\n", s, cache->name);
    80005f1e:	83fff0ef          	jal	ra,8000575c <get_mode>
    80005f22:	2501                	sext.w	a0,a0
    80005f24:	e909                	bnez	a0,80005f36 <kmem_cache_free+0x12c>
  struct list_head *next = node->next;
    80005f26:	6898                	ld	a4,16(s1)
  struct list_head *prev = node->prev;
    80005f28:	649c                	ld	a5,8(s1)
  next->prev = prev;
    80005f2a:	e31c                	sd	a5,0(a4)
  prev->next = next;
    80005f2c:	e798                	sd	a4,8(a5)
      kfree((void *) s);
    80005f2e:	8526                	mv	a0,s1
    80005f30:	abbfa0ef          	jal	ra,800009ea <kfree>
    80005f34:	b71d                	j	80005e5a <kmem_cache_free+0x50>
      debug("[SLAB] slab %p (%s) is freed due to save memory\n", s, cache->name);
    80005f36:	01890613          	addi	a2,s2,24
    80005f3a:	85a6                	mv	a1,s1
    80005f3c:	00002517          	auipc	a0,0x2
    80005f40:	c9c50513          	addi	a0,a0,-868 # 80007bd8 <syscalls+0x730>
    80005f44:	d5efa0ef          	jal	ra,800004a2 <printf>
    80005f48:	bff9                	j	80005f26 <kmem_cache_free+0x11c>
  debug("[SLAB] End of free\n");
    80005f4a:	00002517          	auipc	a0,0x2
    80005f4e:	c7650513          	addi	a0,a0,-906 # 80007bc0 <syscalls+0x718>
    80005f52:	d50fa0ef          	jal	ra,800004a2 <printf>
    80005f56:	b739                	j	80005e64 <kmem_cache_free+0x5a>
	...

0000000080006000 <_trampoline>:
    80006000:	14051073          	csrw	sscratch,a0
    80006004:	02000537          	lui	a0,0x2000
    80006008:	357d                	addiw	a0,a0,-1
    8000600a:	0536                	slli	a0,a0,0xd
    8000600c:	02153423          	sd	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    80006010:	02253823          	sd	sp,48(a0)
    80006014:	02353c23          	sd	gp,56(a0)
    80006018:	04453023          	sd	tp,64(a0)
    8000601c:	04553423          	sd	t0,72(a0)
    80006020:	04653823          	sd	t1,80(a0)
    80006024:	04753c23          	sd	t2,88(a0)
    80006028:	f120                	sd	s0,96(a0)
    8000602a:	f524                	sd	s1,104(a0)
    8000602c:	fd2c                	sd	a1,120(a0)
    8000602e:	e150                	sd	a2,128(a0)
    80006030:	e554                	sd	a3,136(a0)
    80006032:	e958                	sd	a4,144(a0)
    80006034:	ed5c                	sd	a5,152(a0)
    80006036:	0b053023          	sd	a6,160(a0)
    8000603a:	0b153423          	sd	a7,168(a0)
    8000603e:	0b253823          	sd	s2,176(a0)
    80006042:	0b353c23          	sd	s3,184(a0)
    80006046:	0d453023          	sd	s4,192(a0)
    8000604a:	0d553423          	sd	s5,200(a0)
    8000604e:	0d653823          	sd	s6,208(a0)
    80006052:	0d753c23          	sd	s7,216(a0)
    80006056:	0f853023          	sd	s8,224(a0)
    8000605a:	0f953423          	sd	s9,232(a0)
    8000605e:	0fa53823          	sd	s10,240(a0)
    80006062:	0fb53c23          	sd	s11,248(a0)
    80006066:	11c53023          	sd	t3,256(a0)
    8000606a:	11d53423          	sd	t4,264(a0)
    8000606e:	11e53823          	sd	t5,272(a0)
    80006072:	11f53c23          	sd	t6,280(a0)
    80006076:	140022f3          	csrr	t0,sscratch
    8000607a:	06553823          	sd	t0,112(a0)
    8000607e:	00853103          	ld	sp,8(a0)
    80006082:	02053203          	ld	tp,32(a0)
    80006086:	01053283          	ld	t0,16(a0)
    8000608a:	00053303          	ld	t1,0(a0)
    8000608e:	12000073          	sfence.vma
    80006092:	18031073          	csrw	satp,t1
    80006096:	12000073          	sfence.vma
    8000609a:	8282                	jr	t0

000000008000609c <userret>:
    8000609c:	12000073          	sfence.vma
    800060a0:	18051073          	csrw	satp,a0
    800060a4:	12000073          	sfence.vma
    800060a8:	02000537          	lui	a0,0x2000
    800060ac:	357d                	addiw	a0,a0,-1
    800060ae:	0536                	slli	a0,a0,0xd
    800060b0:	02853083          	ld	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    800060b4:	03053103          	ld	sp,48(a0)
    800060b8:	03853183          	ld	gp,56(a0)
    800060bc:	04053203          	ld	tp,64(a0)
    800060c0:	04853283          	ld	t0,72(a0)
    800060c4:	05053303          	ld	t1,80(a0)
    800060c8:	05853383          	ld	t2,88(a0)
    800060cc:	7120                	ld	s0,96(a0)
    800060ce:	7524                	ld	s1,104(a0)
    800060d0:	7d2c                	ld	a1,120(a0)
    800060d2:	6150                	ld	a2,128(a0)
    800060d4:	6554                	ld	a3,136(a0)
    800060d6:	6958                	ld	a4,144(a0)
    800060d8:	6d5c                	ld	a5,152(a0)
    800060da:	0a053803          	ld	a6,160(a0)
    800060de:	0a853883          	ld	a7,168(a0)
    800060e2:	0b053903          	ld	s2,176(a0)
    800060e6:	0b853983          	ld	s3,184(a0)
    800060ea:	0c053a03          	ld	s4,192(a0)
    800060ee:	0c853a83          	ld	s5,200(a0)
    800060f2:	0d053b03          	ld	s6,208(a0)
    800060f6:	0d853b83          	ld	s7,216(a0)
    800060fa:	0e053c03          	ld	s8,224(a0)
    800060fe:	0e853c83          	ld	s9,232(a0)
    80006102:	0f053d03          	ld	s10,240(a0)
    80006106:	0f853d83          	ld	s11,248(a0)
    8000610a:	10053e03          	ld	t3,256(a0)
    8000610e:	10853e83          	ld	t4,264(a0)
    80006112:	11053f03          	ld	t5,272(a0)
    80006116:	11853f83          	ld	t6,280(a0)
    8000611a:	7928                	ld	a0,112(a0)
    8000611c:	10200073          	sret
	...
