
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	18010113          	addi	sp,sp,384 # 80009180 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	078000ef          	jal	ra,8000008e <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
// which hart (core) is this?
static inline uint64
r_mhartid()
{
  uint64 x;
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80000022:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80000026:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    8000002a:	0037979b          	slliw	a5,a5,0x3
    8000002e:	02004737          	lui	a4,0x2004
    80000032:	97ba                	add	a5,a5,a4
    80000034:	0200c737          	lui	a4,0x200c
    80000038:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    8000003c:	000f4637          	lui	a2,0xf4
    80000040:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80000044:	95b2                	add	a1,a1,a2
    80000046:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80000048:	00269713          	slli	a4,a3,0x2
    8000004c:	9736                	add	a4,a4,a3
    8000004e:	00371693          	slli	a3,a4,0x3
    80000052:	00009717          	auipc	a4,0x9
    80000056:	fee70713          	addi	a4,a4,-18 # 80009040 <timer_scratch>
    8000005a:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000005c:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000005e:	f310                	sd	a2,32(a4)
}

static inline void 
w_mscratch(uint64 x)
{
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80000060:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80000064:	00006797          	auipc	a5,0x6
    80000068:	f6c78793          	addi	a5,a5,-148 # 80005fd0 <timervec>
    8000006c:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000070:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80000074:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000078:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000007c:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80000080:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80000084:	30479073          	csrw	mie,a5
}
    80000088:	6422                	ld	s0,8(sp)
    8000008a:	0141                	addi	sp,sp,16
    8000008c:	8082                	ret

000000008000008e <start>:
{
    8000008e:	1141                	addi	sp,sp,-16
    80000090:	e406                	sd	ra,8(sp)
    80000092:	e022                	sd	s0,0(sp)
    80000094:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000096:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000009a:	7779                	lui	a4,0xffffe
    8000009c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffc87ff>
    800000a0:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800000a2:	6705                	lui	a4,0x1
    800000a4:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000aa:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000ae:	00001797          	auipc	a5,0x1
    800000b2:	dd678793          	addi	a5,a5,-554 # 80000e84 <main>
    800000b6:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800000ba:	4781                	li	a5,0
    800000bc:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800000c0:	67c1                	lui	a5,0x10
    800000c2:	17fd                	addi	a5,a5,-1
    800000c4:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800000c8:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800000cc:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000d0:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000d4:	10479073          	csrw	sie,a5
  timerinit();
    800000d8:	00000097          	auipc	ra,0x0
    800000dc:	f44080e7          	jalr	-188(ra) # 8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000e0:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000e4:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000e6:	823e                	mv	tp,a5
  asm volatile("mret");
    800000e8:	30200073          	mret
}
    800000ec:	60a2                	ld	ra,8(sp)
    800000ee:	6402                	ld	s0,0(sp)
    800000f0:	0141                	addi	sp,sp,16
    800000f2:	8082                	ret

00000000800000f4 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800000f4:	715d                	addi	sp,sp,-80
    800000f6:	e486                	sd	ra,72(sp)
    800000f8:	e0a2                	sd	s0,64(sp)
    800000fa:	fc26                	sd	s1,56(sp)
    800000fc:	f84a                	sd	s2,48(sp)
    800000fe:	f44e                	sd	s3,40(sp)
    80000100:	f052                	sd	s4,32(sp)
    80000102:	ec56                	sd	s5,24(sp)
    80000104:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80000106:	04c05663          	blez	a2,80000152 <consolewrite+0x5e>
    8000010a:	8a2a                	mv	s4,a0
    8000010c:	84ae                	mv	s1,a1
    8000010e:	89b2                	mv	s3,a2
    80000110:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80000112:	5afd                	li	s5,-1
    80000114:	4685                	li	a3,1
    80000116:	8626                	mv	a2,s1
    80000118:	85d2                	mv	a1,s4
    8000011a:	fbf40513          	addi	a0,s0,-65
    8000011e:	00002097          	auipc	ra,0x2
    80000122:	408080e7          	jalr	1032(ra) # 80002526 <either_copyin>
    80000126:	01550c63          	beq	a0,s5,8000013e <consolewrite+0x4a>
      break;
    uartputc(c);
    8000012a:	fbf44503          	lbu	a0,-65(s0)
    8000012e:	00000097          	auipc	ra,0x0
    80000132:	78e080e7          	jalr	1934(ra) # 800008bc <uartputc>
  for(i = 0; i < n; i++){
    80000136:	2905                	addiw	s2,s2,1
    80000138:	0485                	addi	s1,s1,1
    8000013a:	fd299de3          	bne	s3,s2,80000114 <consolewrite+0x20>
  }

  return i;
}
    8000013e:	854a                	mv	a0,s2
    80000140:	60a6                	ld	ra,72(sp)
    80000142:	6406                	ld	s0,64(sp)
    80000144:	74e2                	ld	s1,56(sp)
    80000146:	7942                	ld	s2,48(sp)
    80000148:	79a2                	ld	s3,40(sp)
    8000014a:	7a02                	ld	s4,32(sp)
    8000014c:	6ae2                	ld	s5,24(sp)
    8000014e:	6161                	addi	sp,sp,80
    80000150:	8082                	ret
  for(i = 0; i < n; i++){
    80000152:	4901                	li	s2,0
    80000154:	b7ed                	j	8000013e <consolewrite+0x4a>

0000000080000156 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000156:	7119                	addi	sp,sp,-128
    80000158:	fc86                	sd	ra,120(sp)
    8000015a:	f8a2                	sd	s0,112(sp)
    8000015c:	f4a6                	sd	s1,104(sp)
    8000015e:	f0ca                	sd	s2,96(sp)
    80000160:	ecce                	sd	s3,88(sp)
    80000162:	e8d2                	sd	s4,80(sp)
    80000164:	e4d6                	sd	s5,72(sp)
    80000166:	e0da                	sd	s6,64(sp)
    80000168:	fc5e                	sd	s7,56(sp)
    8000016a:	f862                	sd	s8,48(sp)
    8000016c:	f466                	sd	s9,40(sp)
    8000016e:	f06a                	sd	s10,32(sp)
    80000170:	ec6e                	sd	s11,24(sp)
    80000172:	0100                	addi	s0,sp,128
    80000174:	8b2a                	mv	s6,a0
    80000176:	8aae                	mv	s5,a1
    80000178:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    8000017a:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    8000017e:	00011517          	auipc	a0,0x11
    80000182:	00250513          	addi	a0,a0,2 # 80011180 <cons>
    80000186:	00001097          	auipc	ra,0x1
    8000018a:	a50080e7          	jalr	-1456(ra) # 80000bd6 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000018e:	00011497          	auipc	s1,0x11
    80000192:	ff248493          	addi	s1,s1,-14 # 80011180 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80000196:	89a6                	mv	s3,s1
    80000198:	00011917          	auipc	s2,0x11
    8000019c:	08090913          	addi	s2,s2,128 # 80011218 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    800001a0:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800001a2:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800001a4:	4da9                	li	s11,10
  while(n > 0){
    800001a6:	07405863          	blez	s4,80000216 <consoleread+0xc0>
    while(cons.r == cons.w){
    800001aa:	0984a783          	lw	a5,152(s1)
    800001ae:	09c4a703          	lw	a4,156(s1)
    800001b2:	02f71463          	bne	a4,a5,800001da <consoleread+0x84>
      if(myproc()->killed){
    800001b6:	00001097          	auipc	ra,0x1
    800001ba:	7f0080e7          	jalr	2032(ra) # 800019a6 <myproc>
    800001be:	591c                	lw	a5,48(a0)
    800001c0:	e7b5                	bnez	a5,8000022c <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    800001c2:	85ce                	mv	a1,s3
    800001c4:	854a                	mv	a0,s2
    800001c6:	00002097          	auipc	ra,0x2
    800001ca:	0a8080e7          	jalr	168(ra) # 8000226e <sleep>
    while(cons.r == cons.w){
    800001ce:	0984a783          	lw	a5,152(s1)
    800001d2:	09c4a703          	lw	a4,156(s1)
    800001d6:	fef700e3          	beq	a4,a5,800001b6 <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    800001da:	0017871b          	addiw	a4,a5,1
    800001de:	08e4ac23          	sw	a4,152(s1)
    800001e2:	07f7f713          	andi	a4,a5,127
    800001e6:	9726                	add	a4,a4,s1
    800001e8:	01874703          	lbu	a4,24(a4)
    800001ec:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    800001f0:	079c0663          	beq	s8,s9,8000025c <consoleread+0x106>
    cbuf = c;
    800001f4:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800001f8:	4685                	li	a3,1
    800001fa:	f8f40613          	addi	a2,s0,-113
    800001fe:	85d6                	mv	a1,s5
    80000200:	855a                	mv	a0,s6
    80000202:	00002097          	auipc	ra,0x2
    80000206:	2ce080e7          	jalr	718(ra) # 800024d0 <either_copyout>
    8000020a:	01a50663          	beq	a0,s10,80000216 <consoleread+0xc0>
    dst++;
    8000020e:	0a85                	addi	s5,s5,1
    --n;
    80000210:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    80000212:	f9bc1ae3          	bne	s8,s11,800001a6 <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80000216:	00011517          	auipc	a0,0x11
    8000021a:	f6a50513          	addi	a0,a0,-150 # 80011180 <cons>
    8000021e:	00001097          	auipc	ra,0x1
    80000222:	a6c080e7          	jalr	-1428(ra) # 80000c8a <release>

  return target - n;
    80000226:	414b853b          	subw	a0,s7,s4
    8000022a:	a811                	j	8000023e <consoleread+0xe8>
        release(&cons.lock);
    8000022c:	00011517          	auipc	a0,0x11
    80000230:	f5450513          	addi	a0,a0,-172 # 80011180 <cons>
    80000234:	00001097          	auipc	ra,0x1
    80000238:	a56080e7          	jalr	-1450(ra) # 80000c8a <release>
        return -1;
    8000023c:	557d                	li	a0,-1
}
    8000023e:	70e6                	ld	ra,120(sp)
    80000240:	7446                	ld	s0,112(sp)
    80000242:	74a6                	ld	s1,104(sp)
    80000244:	7906                	ld	s2,96(sp)
    80000246:	69e6                	ld	s3,88(sp)
    80000248:	6a46                	ld	s4,80(sp)
    8000024a:	6aa6                	ld	s5,72(sp)
    8000024c:	6b06                	ld	s6,64(sp)
    8000024e:	7be2                	ld	s7,56(sp)
    80000250:	7c42                	ld	s8,48(sp)
    80000252:	7ca2                	ld	s9,40(sp)
    80000254:	7d02                	ld	s10,32(sp)
    80000256:	6de2                	ld	s11,24(sp)
    80000258:	6109                	addi	sp,sp,128
    8000025a:	8082                	ret
      if(n < target){
    8000025c:	000a071b          	sext.w	a4,s4
    80000260:	fb777be3          	bgeu	a4,s7,80000216 <consoleread+0xc0>
        cons.r--;
    80000264:	00011717          	auipc	a4,0x11
    80000268:	faf72a23          	sw	a5,-76(a4) # 80011218 <cons+0x98>
    8000026c:	b76d                	j	80000216 <consoleread+0xc0>

000000008000026e <consputc>:
{
    8000026e:	1141                	addi	sp,sp,-16
    80000270:	e406                	sd	ra,8(sp)
    80000272:	e022                	sd	s0,0(sp)
    80000274:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80000276:	10000793          	li	a5,256
    8000027a:	00f50a63          	beq	a0,a5,8000028e <consputc+0x20>
    uartputc_sync(c);
    8000027e:	00000097          	auipc	ra,0x0
    80000282:	564080e7          	jalr	1380(ra) # 800007e2 <uartputc_sync>
}
    80000286:	60a2                	ld	ra,8(sp)
    80000288:	6402                	ld	s0,0(sp)
    8000028a:	0141                	addi	sp,sp,16
    8000028c:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    8000028e:	4521                	li	a0,8
    80000290:	00000097          	auipc	ra,0x0
    80000294:	552080e7          	jalr	1362(ra) # 800007e2 <uartputc_sync>
    80000298:	02000513          	li	a0,32
    8000029c:	00000097          	auipc	ra,0x0
    800002a0:	546080e7          	jalr	1350(ra) # 800007e2 <uartputc_sync>
    800002a4:	4521                	li	a0,8
    800002a6:	00000097          	auipc	ra,0x0
    800002aa:	53c080e7          	jalr	1340(ra) # 800007e2 <uartputc_sync>
    800002ae:	bfe1                	j	80000286 <consputc+0x18>

00000000800002b0 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002b0:	1101                	addi	sp,sp,-32
    800002b2:	ec06                	sd	ra,24(sp)
    800002b4:	e822                	sd	s0,16(sp)
    800002b6:	e426                	sd	s1,8(sp)
    800002b8:	e04a                	sd	s2,0(sp)
    800002ba:	1000                	addi	s0,sp,32
    800002bc:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002be:	00011517          	auipc	a0,0x11
    800002c2:	ec250513          	addi	a0,a0,-318 # 80011180 <cons>
    800002c6:	00001097          	auipc	ra,0x1
    800002ca:	910080e7          	jalr	-1776(ra) # 80000bd6 <acquire>

  switch(c){
    800002ce:	47d5                	li	a5,21
    800002d0:	0af48663          	beq	s1,a5,8000037c <consoleintr+0xcc>
    800002d4:	0297ca63          	blt	a5,s1,80000308 <consoleintr+0x58>
    800002d8:	47a1                	li	a5,8
    800002da:	0ef48763          	beq	s1,a5,800003c8 <consoleintr+0x118>
    800002de:	47c1                	li	a5,16
    800002e0:	10f49a63          	bne	s1,a5,800003f4 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    800002e4:	00002097          	auipc	ra,0x2
    800002e8:	298080e7          	jalr	664(ra) # 8000257c <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002ec:	00011517          	auipc	a0,0x11
    800002f0:	e9450513          	addi	a0,a0,-364 # 80011180 <cons>
    800002f4:	00001097          	auipc	ra,0x1
    800002f8:	996080e7          	jalr	-1642(ra) # 80000c8a <release>
}
    800002fc:	60e2                	ld	ra,24(sp)
    800002fe:	6442                	ld	s0,16(sp)
    80000300:	64a2                	ld	s1,8(sp)
    80000302:	6902                	ld	s2,0(sp)
    80000304:	6105                	addi	sp,sp,32
    80000306:	8082                	ret
  switch(c){
    80000308:	07f00793          	li	a5,127
    8000030c:	0af48e63          	beq	s1,a5,800003c8 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80000310:	00011717          	auipc	a4,0x11
    80000314:	e7070713          	addi	a4,a4,-400 # 80011180 <cons>
    80000318:	0a072783          	lw	a5,160(a4)
    8000031c:	09872703          	lw	a4,152(a4)
    80000320:	9f99                	subw	a5,a5,a4
    80000322:	07f00713          	li	a4,127
    80000326:	fcf763e3          	bltu	a4,a5,800002ec <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    8000032a:	47b5                	li	a5,13
    8000032c:	0cf48763          	beq	s1,a5,800003fa <consoleintr+0x14a>
      consputc(c);
    80000330:	8526                	mv	a0,s1
    80000332:	00000097          	auipc	ra,0x0
    80000336:	f3c080e7          	jalr	-196(ra) # 8000026e <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    8000033a:	00011797          	auipc	a5,0x11
    8000033e:	e4678793          	addi	a5,a5,-442 # 80011180 <cons>
    80000342:	0a07a703          	lw	a4,160(a5)
    80000346:	0017069b          	addiw	a3,a4,1
    8000034a:	0006861b          	sext.w	a2,a3
    8000034e:	0ad7a023          	sw	a3,160(a5)
    80000352:	07f77713          	andi	a4,a4,127
    80000356:	97ba                	add	a5,a5,a4
    80000358:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    8000035c:	47a9                	li	a5,10
    8000035e:	0cf48563          	beq	s1,a5,80000428 <consoleintr+0x178>
    80000362:	4791                	li	a5,4
    80000364:	0cf48263          	beq	s1,a5,80000428 <consoleintr+0x178>
    80000368:	00011797          	auipc	a5,0x11
    8000036c:	eb07a783          	lw	a5,-336(a5) # 80011218 <cons+0x98>
    80000370:	0807879b          	addiw	a5,a5,128
    80000374:	f6f61ce3          	bne	a2,a5,800002ec <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80000378:	863e                	mv	a2,a5
    8000037a:	a07d                	j	80000428 <consoleintr+0x178>
    while(cons.e != cons.w &&
    8000037c:	00011717          	auipc	a4,0x11
    80000380:	e0470713          	addi	a4,a4,-508 # 80011180 <cons>
    80000384:	0a072783          	lw	a5,160(a4)
    80000388:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    8000038c:	00011497          	auipc	s1,0x11
    80000390:	df448493          	addi	s1,s1,-524 # 80011180 <cons>
    while(cons.e != cons.w &&
    80000394:	4929                	li	s2,10
    80000396:	f4f70be3          	beq	a4,a5,800002ec <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    8000039a:	37fd                	addiw	a5,a5,-1
    8000039c:	07f7f713          	andi	a4,a5,127
    800003a0:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800003a2:	01874703          	lbu	a4,24(a4)
    800003a6:	f52703e3          	beq	a4,s2,800002ec <consoleintr+0x3c>
      cons.e--;
    800003aa:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800003ae:	10000513          	li	a0,256
    800003b2:	00000097          	auipc	ra,0x0
    800003b6:	ebc080e7          	jalr	-324(ra) # 8000026e <consputc>
    while(cons.e != cons.w &&
    800003ba:	0a04a783          	lw	a5,160(s1)
    800003be:	09c4a703          	lw	a4,156(s1)
    800003c2:	fcf71ce3          	bne	a4,a5,8000039a <consoleintr+0xea>
    800003c6:	b71d                	j	800002ec <consoleintr+0x3c>
    if(cons.e != cons.w){
    800003c8:	00011717          	auipc	a4,0x11
    800003cc:	db870713          	addi	a4,a4,-584 # 80011180 <cons>
    800003d0:	0a072783          	lw	a5,160(a4)
    800003d4:	09c72703          	lw	a4,156(a4)
    800003d8:	f0f70ae3          	beq	a4,a5,800002ec <consoleintr+0x3c>
      cons.e--;
    800003dc:	37fd                	addiw	a5,a5,-1
    800003de:	00011717          	auipc	a4,0x11
    800003e2:	e4f72123          	sw	a5,-446(a4) # 80011220 <cons+0xa0>
      consputc(BACKSPACE);
    800003e6:	10000513          	li	a0,256
    800003ea:	00000097          	auipc	ra,0x0
    800003ee:	e84080e7          	jalr	-380(ra) # 8000026e <consputc>
    800003f2:	bded                	j	800002ec <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    800003f4:	ee048ce3          	beqz	s1,800002ec <consoleintr+0x3c>
    800003f8:	bf21                	j	80000310 <consoleintr+0x60>
      consputc(c);
    800003fa:	4529                	li	a0,10
    800003fc:	00000097          	auipc	ra,0x0
    80000400:	e72080e7          	jalr	-398(ra) # 8000026e <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80000404:	00011797          	auipc	a5,0x11
    80000408:	d7c78793          	addi	a5,a5,-644 # 80011180 <cons>
    8000040c:	0a07a703          	lw	a4,160(a5)
    80000410:	0017069b          	addiw	a3,a4,1
    80000414:	0006861b          	sext.w	a2,a3
    80000418:	0ad7a023          	sw	a3,160(a5)
    8000041c:	07f77713          	andi	a4,a4,127
    80000420:	97ba                	add	a5,a5,a4
    80000422:	4729                	li	a4,10
    80000424:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80000428:	00011797          	auipc	a5,0x11
    8000042c:	dec7aa23          	sw	a2,-524(a5) # 8001121c <cons+0x9c>
        wakeup(&cons.r);
    80000430:	00011517          	auipc	a0,0x11
    80000434:	de850513          	addi	a0,a0,-536 # 80011218 <cons+0x98>
    80000438:	00002097          	auipc	ra,0x2
    8000043c:	fbc080e7          	jalr	-68(ra) # 800023f4 <wakeup>
    80000440:	b575                	j	800002ec <consoleintr+0x3c>

0000000080000442 <consoleinit>:

void
consoleinit(void)
{
    80000442:	1141                	addi	sp,sp,-16
    80000444:	e406                	sd	ra,8(sp)
    80000446:	e022                	sd	s0,0(sp)
    80000448:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    8000044a:	00008597          	auipc	a1,0x8
    8000044e:	bc658593          	addi	a1,a1,-1082 # 80008010 <etext+0x10>
    80000452:	00011517          	auipc	a0,0x11
    80000456:	d2e50513          	addi	a0,a0,-722 # 80011180 <cons>
    8000045a:	00000097          	auipc	ra,0x0
    8000045e:	6ec080e7          	jalr	1772(ra) # 80000b46 <initlock>

  uartinit();
    80000462:	00000097          	auipc	ra,0x0
    80000466:	330080e7          	jalr	816(ra) # 80000792 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000046a:	00031797          	auipc	a5,0x31
    8000046e:	e9678793          	addi	a5,a5,-362 # 80031300 <devsw>
    80000472:	00000717          	auipc	a4,0x0
    80000476:	ce470713          	addi	a4,a4,-796 # 80000156 <consoleread>
    8000047a:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000047c:	00000717          	auipc	a4,0x0
    80000480:	c7870713          	addi	a4,a4,-904 # 800000f4 <consolewrite>
    80000484:	ef98                	sd	a4,24(a5)
}
    80000486:	60a2                	ld	ra,8(sp)
    80000488:	6402                	ld	s0,0(sp)
    8000048a:	0141                	addi	sp,sp,16
    8000048c:	8082                	ret

000000008000048e <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    8000048e:	7179                	addi	sp,sp,-48
    80000490:	f406                	sd	ra,40(sp)
    80000492:	f022                	sd	s0,32(sp)
    80000494:	ec26                	sd	s1,24(sp)
    80000496:	e84a                	sd	s2,16(sp)
    80000498:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    8000049a:	c219                	beqz	a2,800004a0 <printint+0x12>
    8000049c:	08054663          	bltz	a0,80000528 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    800004a0:	2501                	sext.w	a0,a0
    800004a2:	4881                	li	a7,0
    800004a4:	fd040693          	addi	a3,s0,-48

  i = 0;
    800004a8:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    800004aa:	2581                	sext.w	a1,a1
    800004ac:	00008617          	auipc	a2,0x8
    800004b0:	b9460613          	addi	a2,a2,-1132 # 80008040 <digits>
    800004b4:	883a                	mv	a6,a4
    800004b6:	2705                	addiw	a4,a4,1
    800004b8:	02b577bb          	remuw	a5,a0,a1
    800004bc:	1782                	slli	a5,a5,0x20
    800004be:	9381                	srli	a5,a5,0x20
    800004c0:	97b2                	add	a5,a5,a2
    800004c2:	0007c783          	lbu	a5,0(a5)
    800004c6:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800004ca:	0005079b          	sext.w	a5,a0
    800004ce:	02b5553b          	divuw	a0,a0,a1
    800004d2:	0685                	addi	a3,a3,1
    800004d4:	feb7f0e3          	bgeu	a5,a1,800004b4 <printint+0x26>

  if(sign)
    800004d8:	00088b63          	beqz	a7,800004ee <printint+0x60>
    buf[i++] = '-';
    800004dc:	fe040793          	addi	a5,s0,-32
    800004e0:	973e                	add	a4,a4,a5
    800004e2:	02d00793          	li	a5,45
    800004e6:	fef70823          	sb	a5,-16(a4)
    800004ea:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    800004ee:	02e05763          	blez	a4,8000051c <printint+0x8e>
    800004f2:	fd040793          	addi	a5,s0,-48
    800004f6:	00e784b3          	add	s1,a5,a4
    800004fa:	fff78913          	addi	s2,a5,-1
    800004fe:	993a                	add	s2,s2,a4
    80000500:	377d                	addiw	a4,a4,-1
    80000502:	1702                	slli	a4,a4,0x20
    80000504:	9301                	srli	a4,a4,0x20
    80000506:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    8000050a:	fff4c503          	lbu	a0,-1(s1)
    8000050e:	00000097          	auipc	ra,0x0
    80000512:	d60080e7          	jalr	-672(ra) # 8000026e <consputc>
  while(--i >= 0)
    80000516:	14fd                	addi	s1,s1,-1
    80000518:	ff2499e3          	bne	s1,s2,8000050a <printint+0x7c>
}
    8000051c:	70a2                	ld	ra,40(sp)
    8000051e:	7402                	ld	s0,32(sp)
    80000520:	64e2                	ld	s1,24(sp)
    80000522:	6942                	ld	s2,16(sp)
    80000524:	6145                	addi	sp,sp,48
    80000526:	8082                	ret
    x = -xx;
    80000528:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    8000052c:	4885                	li	a7,1
    x = -xx;
    8000052e:	bf9d                	j	800004a4 <printint+0x16>

0000000080000530 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80000530:	1101                	addi	sp,sp,-32
    80000532:	ec06                	sd	ra,24(sp)
    80000534:	e822                	sd	s0,16(sp)
    80000536:	e426                	sd	s1,8(sp)
    80000538:	1000                	addi	s0,sp,32
    8000053a:	84aa                	mv	s1,a0
  pr.locking = 0;
    8000053c:	00011797          	auipc	a5,0x11
    80000540:	d007a223          	sw	zero,-764(a5) # 80011240 <pr+0x18>
  printf("panic: ");
    80000544:	00008517          	auipc	a0,0x8
    80000548:	ad450513          	addi	a0,a0,-1324 # 80008018 <etext+0x18>
    8000054c:	00000097          	auipc	ra,0x0
    80000550:	02e080e7          	jalr	46(ra) # 8000057a <printf>
  printf(s);
    80000554:	8526                	mv	a0,s1
    80000556:	00000097          	auipc	ra,0x0
    8000055a:	024080e7          	jalr	36(ra) # 8000057a <printf>
  printf("\n");
    8000055e:	00008517          	auipc	a0,0x8
    80000562:	dc250513          	addi	a0,a0,-574 # 80008320 <states.1785+0xb8>
    80000566:	00000097          	auipc	ra,0x0
    8000056a:	014080e7          	jalr	20(ra) # 8000057a <printf>
  panicked = 1; // freeze uart output from other CPUs
    8000056e:	4785                	li	a5,1
    80000570:	00009717          	auipc	a4,0x9
    80000574:	a8f72823          	sw	a5,-1392(a4) # 80009000 <panicked>
  for(;;)
    80000578:	a001                	j	80000578 <panic+0x48>

000000008000057a <printf>:
{
    8000057a:	7131                	addi	sp,sp,-192
    8000057c:	fc86                	sd	ra,120(sp)
    8000057e:	f8a2                	sd	s0,112(sp)
    80000580:	f4a6                	sd	s1,104(sp)
    80000582:	f0ca                	sd	s2,96(sp)
    80000584:	ecce                	sd	s3,88(sp)
    80000586:	e8d2                	sd	s4,80(sp)
    80000588:	e4d6                	sd	s5,72(sp)
    8000058a:	e0da                	sd	s6,64(sp)
    8000058c:	fc5e                	sd	s7,56(sp)
    8000058e:	f862                	sd	s8,48(sp)
    80000590:	f466                	sd	s9,40(sp)
    80000592:	f06a                	sd	s10,32(sp)
    80000594:	ec6e                	sd	s11,24(sp)
    80000596:	0100                	addi	s0,sp,128
    80000598:	8a2a                	mv	s4,a0
    8000059a:	e40c                	sd	a1,8(s0)
    8000059c:	e810                	sd	a2,16(s0)
    8000059e:	ec14                	sd	a3,24(s0)
    800005a0:	f018                	sd	a4,32(s0)
    800005a2:	f41c                	sd	a5,40(s0)
    800005a4:	03043823          	sd	a6,48(s0)
    800005a8:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800005ac:	00011d97          	auipc	s11,0x11
    800005b0:	c94dad83          	lw	s11,-876(s11) # 80011240 <pr+0x18>
  if(locking)
    800005b4:	020d9b63          	bnez	s11,800005ea <printf+0x70>
  if (fmt == 0)
    800005b8:	040a0263          	beqz	s4,800005fc <printf+0x82>
  va_start(ap, fmt);
    800005bc:	00840793          	addi	a5,s0,8
    800005c0:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800005c4:	000a4503          	lbu	a0,0(s4)
    800005c8:	16050263          	beqz	a0,8000072c <printf+0x1b2>
    800005cc:	4481                	li	s1,0
    if(c != '%'){
    800005ce:	02500a93          	li	s5,37
    switch(c){
    800005d2:	07000b13          	li	s6,112
  consputc('x');
    800005d6:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800005d8:	00008b97          	auipc	s7,0x8
    800005dc:	a68b8b93          	addi	s7,s7,-1432 # 80008040 <digits>
    switch(c){
    800005e0:	07300c93          	li	s9,115
    800005e4:	06400c13          	li	s8,100
    800005e8:	a82d                	j	80000622 <printf+0xa8>
    acquire(&pr.lock);
    800005ea:	00011517          	auipc	a0,0x11
    800005ee:	c3e50513          	addi	a0,a0,-962 # 80011228 <pr>
    800005f2:	00000097          	auipc	ra,0x0
    800005f6:	5e4080e7          	jalr	1508(ra) # 80000bd6 <acquire>
    800005fa:	bf7d                	j	800005b8 <printf+0x3e>
    panic("null fmt");
    800005fc:	00008517          	auipc	a0,0x8
    80000600:	a2c50513          	addi	a0,a0,-1492 # 80008028 <etext+0x28>
    80000604:	00000097          	auipc	ra,0x0
    80000608:	f2c080e7          	jalr	-212(ra) # 80000530 <panic>
      consputc(c);
    8000060c:	00000097          	auipc	ra,0x0
    80000610:	c62080e7          	jalr	-926(ra) # 8000026e <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80000614:	2485                	addiw	s1,s1,1
    80000616:	009a07b3          	add	a5,s4,s1
    8000061a:	0007c503          	lbu	a0,0(a5)
    8000061e:	10050763          	beqz	a0,8000072c <printf+0x1b2>
    if(c != '%'){
    80000622:	ff5515e3          	bne	a0,s5,8000060c <printf+0x92>
    c = fmt[++i] & 0xff;
    80000626:	2485                	addiw	s1,s1,1
    80000628:	009a07b3          	add	a5,s4,s1
    8000062c:	0007c783          	lbu	a5,0(a5)
    80000630:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80000634:	cfe5                	beqz	a5,8000072c <printf+0x1b2>
    switch(c){
    80000636:	05678a63          	beq	a5,s6,8000068a <printf+0x110>
    8000063a:	02fb7663          	bgeu	s6,a5,80000666 <printf+0xec>
    8000063e:	09978963          	beq	a5,s9,800006d0 <printf+0x156>
    80000642:	07800713          	li	a4,120
    80000646:	0ce79863          	bne	a5,a4,80000716 <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    8000064a:	f8843783          	ld	a5,-120(s0)
    8000064e:	00878713          	addi	a4,a5,8
    80000652:	f8e43423          	sd	a4,-120(s0)
    80000656:	4605                	li	a2,1
    80000658:	85ea                	mv	a1,s10
    8000065a:	4388                	lw	a0,0(a5)
    8000065c:	00000097          	auipc	ra,0x0
    80000660:	e32080e7          	jalr	-462(ra) # 8000048e <printint>
      break;
    80000664:	bf45                	j	80000614 <printf+0x9a>
    switch(c){
    80000666:	0b578263          	beq	a5,s5,8000070a <printf+0x190>
    8000066a:	0b879663          	bne	a5,s8,80000716 <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    8000066e:	f8843783          	ld	a5,-120(s0)
    80000672:	00878713          	addi	a4,a5,8
    80000676:	f8e43423          	sd	a4,-120(s0)
    8000067a:	4605                	li	a2,1
    8000067c:	45a9                	li	a1,10
    8000067e:	4388                	lw	a0,0(a5)
    80000680:	00000097          	auipc	ra,0x0
    80000684:	e0e080e7          	jalr	-498(ra) # 8000048e <printint>
      break;
    80000688:	b771                	j	80000614 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    8000068a:	f8843783          	ld	a5,-120(s0)
    8000068e:	00878713          	addi	a4,a5,8
    80000692:	f8e43423          	sd	a4,-120(s0)
    80000696:	0007b983          	ld	s3,0(a5)
  consputc('0');
    8000069a:	03000513          	li	a0,48
    8000069e:	00000097          	auipc	ra,0x0
    800006a2:	bd0080e7          	jalr	-1072(ra) # 8000026e <consputc>
  consputc('x');
    800006a6:	07800513          	li	a0,120
    800006aa:	00000097          	auipc	ra,0x0
    800006ae:	bc4080e7          	jalr	-1084(ra) # 8000026e <consputc>
    800006b2:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006b4:	03c9d793          	srli	a5,s3,0x3c
    800006b8:	97de                	add	a5,a5,s7
    800006ba:	0007c503          	lbu	a0,0(a5)
    800006be:	00000097          	auipc	ra,0x0
    800006c2:	bb0080e7          	jalr	-1104(ra) # 8000026e <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800006c6:	0992                	slli	s3,s3,0x4
    800006c8:	397d                	addiw	s2,s2,-1
    800006ca:	fe0915e3          	bnez	s2,800006b4 <printf+0x13a>
    800006ce:	b799                	j	80000614 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    800006d0:	f8843783          	ld	a5,-120(s0)
    800006d4:	00878713          	addi	a4,a5,8
    800006d8:	f8e43423          	sd	a4,-120(s0)
    800006dc:	0007b903          	ld	s2,0(a5)
    800006e0:	00090e63          	beqz	s2,800006fc <printf+0x182>
      for(; *s; s++)
    800006e4:	00094503          	lbu	a0,0(s2)
    800006e8:	d515                	beqz	a0,80000614 <printf+0x9a>
        consputc(*s);
    800006ea:	00000097          	auipc	ra,0x0
    800006ee:	b84080e7          	jalr	-1148(ra) # 8000026e <consputc>
      for(; *s; s++)
    800006f2:	0905                	addi	s2,s2,1
    800006f4:	00094503          	lbu	a0,0(s2)
    800006f8:	f96d                	bnez	a0,800006ea <printf+0x170>
    800006fa:	bf29                	j	80000614 <printf+0x9a>
        s = "(null)";
    800006fc:	00008917          	auipc	s2,0x8
    80000700:	92490913          	addi	s2,s2,-1756 # 80008020 <etext+0x20>
      for(; *s; s++)
    80000704:	02800513          	li	a0,40
    80000708:	b7cd                	j	800006ea <printf+0x170>
      consputc('%');
    8000070a:	8556                	mv	a0,s5
    8000070c:	00000097          	auipc	ra,0x0
    80000710:	b62080e7          	jalr	-1182(ra) # 8000026e <consputc>
      break;
    80000714:	b701                	j	80000614 <printf+0x9a>
      consputc('%');
    80000716:	8556                	mv	a0,s5
    80000718:	00000097          	auipc	ra,0x0
    8000071c:	b56080e7          	jalr	-1194(ra) # 8000026e <consputc>
      consputc(c);
    80000720:	854a                	mv	a0,s2
    80000722:	00000097          	auipc	ra,0x0
    80000726:	b4c080e7          	jalr	-1204(ra) # 8000026e <consputc>
      break;
    8000072a:	b5ed                	j	80000614 <printf+0x9a>
  if(locking)
    8000072c:	020d9163          	bnez	s11,8000074e <printf+0x1d4>
}
    80000730:	70e6                	ld	ra,120(sp)
    80000732:	7446                	ld	s0,112(sp)
    80000734:	74a6                	ld	s1,104(sp)
    80000736:	7906                	ld	s2,96(sp)
    80000738:	69e6                	ld	s3,88(sp)
    8000073a:	6a46                	ld	s4,80(sp)
    8000073c:	6aa6                	ld	s5,72(sp)
    8000073e:	6b06                	ld	s6,64(sp)
    80000740:	7be2                	ld	s7,56(sp)
    80000742:	7c42                	ld	s8,48(sp)
    80000744:	7ca2                	ld	s9,40(sp)
    80000746:	7d02                	ld	s10,32(sp)
    80000748:	6de2                	ld	s11,24(sp)
    8000074a:	6129                	addi	sp,sp,192
    8000074c:	8082                	ret
    release(&pr.lock);
    8000074e:	00011517          	auipc	a0,0x11
    80000752:	ada50513          	addi	a0,a0,-1318 # 80011228 <pr>
    80000756:	00000097          	auipc	ra,0x0
    8000075a:	534080e7          	jalr	1332(ra) # 80000c8a <release>
}
    8000075e:	bfc9                	j	80000730 <printf+0x1b6>

0000000080000760 <printfinit>:
    ;
}

void
printfinit(void)
{
    80000760:	1101                	addi	sp,sp,-32
    80000762:	ec06                	sd	ra,24(sp)
    80000764:	e822                	sd	s0,16(sp)
    80000766:	e426                	sd	s1,8(sp)
    80000768:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    8000076a:	00011497          	auipc	s1,0x11
    8000076e:	abe48493          	addi	s1,s1,-1346 # 80011228 <pr>
    80000772:	00008597          	auipc	a1,0x8
    80000776:	8c658593          	addi	a1,a1,-1850 # 80008038 <etext+0x38>
    8000077a:	8526                	mv	a0,s1
    8000077c:	00000097          	auipc	ra,0x0
    80000780:	3ca080e7          	jalr	970(ra) # 80000b46 <initlock>
  pr.locking = 1;
    80000784:	4785                	li	a5,1
    80000786:	cc9c                	sw	a5,24(s1)
}
    80000788:	60e2                	ld	ra,24(sp)
    8000078a:	6442                	ld	s0,16(sp)
    8000078c:	64a2                	ld	s1,8(sp)
    8000078e:	6105                	addi	sp,sp,32
    80000790:	8082                	ret

0000000080000792 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80000792:	1141                	addi	sp,sp,-16
    80000794:	e406                	sd	ra,8(sp)
    80000796:	e022                	sd	s0,0(sp)
    80000798:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    8000079a:	100007b7          	lui	a5,0x10000
    8000079e:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800007a2:	f8000713          	li	a4,-128
    800007a6:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800007aa:	470d                	li	a4,3
    800007ac:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800007b0:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800007b4:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800007b8:	469d                	li	a3,7
    800007ba:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800007be:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800007c2:	00008597          	auipc	a1,0x8
    800007c6:	89658593          	addi	a1,a1,-1898 # 80008058 <digits+0x18>
    800007ca:	00011517          	auipc	a0,0x11
    800007ce:	a7e50513          	addi	a0,a0,-1410 # 80011248 <uart_tx_lock>
    800007d2:	00000097          	auipc	ra,0x0
    800007d6:	374080e7          	jalr	884(ra) # 80000b46 <initlock>
}
    800007da:	60a2                	ld	ra,8(sp)
    800007dc:	6402                	ld	s0,0(sp)
    800007de:	0141                	addi	sp,sp,16
    800007e0:	8082                	ret

00000000800007e2 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800007e2:	1101                	addi	sp,sp,-32
    800007e4:	ec06                	sd	ra,24(sp)
    800007e6:	e822                	sd	s0,16(sp)
    800007e8:	e426                	sd	s1,8(sp)
    800007ea:	1000                	addi	s0,sp,32
    800007ec:	84aa                	mv	s1,a0
  push_off();
    800007ee:	00000097          	auipc	ra,0x0
    800007f2:	39c080e7          	jalr	924(ra) # 80000b8a <push_off>

  if(panicked){
    800007f6:	00009797          	auipc	a5,0x9
    800007fa:	80a7a783          	lw	a5,-2038(a5) # 80009000 <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800007fe:	10000737          	lui	a4,0x10000
  if(panicked){
    80000802:	c391                	beqz	a5,80000806 <uartputc_sync+0x24>
    for(;;)
    80000804:	a001                	j	80000804 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000806:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    8000080a:	0ff7f793          	andi	a5,a5,255
    8000080e:	0207f793          	andi	a5,a5,32
    80000812:	dbf5                	beqz	a5,80000806 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80000814:	0ff4f793          	andi	a5,s1,255
    80000818:	10000737          	lui	a4,0x10000
    8000081c:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80000820:	00000097          	auipc	ra,0x0
    80000824:	40a080e7          	jalr	1034(ra) # 80000c2a <pop_off>
}
    80000828:	60e2                	ld	ra,24(sp)
    8000082a:	6442                	ld	s0,16(sp)
    8000082c:	64a2                	ld	s1,8(sp)
    8000082e:	6105                	addi	sp,sp,32
    80000830:	8082                	ret

0000000080000832 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80000832:	00008717          	auipc	a4,0x8
    80000836:	7d673703          	ld	a4,2006(a4) # 80009008 <uart_tx_r>
    8000083a:	00008797          	auipc	a5,0x8
    8000083e:	7d67b783          	ld	a5,2006(a5) # 80009010 <uart_tx_w>
    80000842:	06e78c63          	beq	a5,a4,800008ba <uartstart+0x88>
{
    80000846:	7139                	addi	sp,sp,-64
    80000848:	fc06                	sd	ra,56(sp)
    8000084a:	f822                	sd	s0,48(sp)
    8000084c:	f426                	sd	s1,40(sp)
    8000084e:	f04a                	sd	s2,32(sp)
    80000850:	ec4e                	sd	s3,24(sp)
    80000852:	e852                	sd	s4,16(sp)
    80000854:	e456                	sd	s5,8(sp)
    80000856:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000858:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000085c:	00011a17          	auipc	s4,0x11
    80000860:	9eca0a13          	addi	s4,s4,-1556 # 80011248 <uart_tx_lock>
    uart_tx_r += 1;
    80000864:	00008497          	auipc	s1,0x8
    80000868:	7a448493          	addi	s1,s1,1956 # 80009008 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    8000086c:	00008997          	auipc	s3,0x8
    80000870:	7a498993          	addi	s3,s3,1956 # 80009010 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000874:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    80000878:	0ff7f793          	andi	a5,a5,255
    8000087c:	0207f793          	andi	a5,a5,32
    80000880:	c785                	beqz	a5,800008a8 <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80000882:	01f77793          	andi	a5,a4,31
    80000886:	97d2                	add	a5,a5,s4
    80000888:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    8000088c:	0705                	addi	a4,a4,1
    8000088e:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80000890:	8526                	mv	a0,s1
    80000892:	00002097          	auipc	ra,0x2
    80000896:	b62080e7          	jalr	-1182(ra) # 800023f4 <wakeup>
    
    WriteReg(THR, c);
    8000089a:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    8000089e:	6098                	ld	a4,0(s1)
    800008a0:	0009b783          	ld	a5,0(s3)
    800008a4:	fce798e3          	bne	a5,a4,80000874 <uartstart+0x42>
  }
}
    800008a8:	70e2                	ld	ra,56(sp)
    800008aa:	7442                	ld	s0,48(sp)
    800008ac:	74a2                	ld	s1,40(sp)
    800008ae:	7902                	ld	s2,32(sp)
    800008b0:	69e2                	ld	s3,24(sp)
    800008b2:	6a42                	ld	s4,16(sp)
    800008b4:	6aa2                	ld	s5,8(sp)
    800008b6:	6121                	addi	sp,sp,64
    800008b8:	8082                	ret
    800008ba:	8082                	ret

00000000800008bc <uartputc>:
{
    800008bc:	7179                	addi	sp,sp,-48
    800008be:	f406                	sd	ra,40(sp)
    800008c0:	f022                	sd	s0,32(sp)
    800008c2:	ec26                	sd	s1,24(sp)
    800008c4:	e84a                	sd	s2,16(sp)
    800008c6:	e44e                	sd	s3,8(sp)
    800008c8:	e052                	sd	s4,0(sp)
    800008ca:	1800                	addi	s0,sp,48
    800008cc:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    800008ce:	00011517          	auipc	a0,0x11
    800008d2:	97a50513          	addi	a0,a0,-1670 # 80011248 <uart_tx_lock>
    800008d6:	00000097          	auipc	ra,0x0
    800008da:	300080e7          	jalr	768(ra) # 80000bd6 <acquire>
  if(panicked){
    800008de:	00008797          	auipc	a5,0x8
    800008e2:	7227a783          	lw	a5,1826(a5) # 80009000 <panicked>
    800008e6:	c391                	beqz	a5,800008ea <uartputc+0x2e>
    for(;;)
    800008e8:	a001                	j	800008e8 <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800008ea:	00008797          	auipc	a5,0x8
    800008ee:	7267b783          	ld	a5,1830(a5) # 80009010 <uart_tx_w>
    800008f2:	00008717          	auipc	a4,0x8
    800008f6:	71673703          	ld	a4,1814(a4) # 80009008 <uart_tx_r>
    800008fa:	02070713          	addi	a4,a4,32
    800008fe:	02f71b63          	bne	a4,a5,80000934 <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    80000902:	00011a17          	auipc	s4,0x11
    80000906:	946a0a13          	addi	s4,s4,-1722 # 80011248 <uart_tx_lock>
    8000090a:	00008497          	auipc	s1,0x8
    8000090e:	6fe48493          	addi	s1,s1,1790 # 80009008 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000912:	00008917          	auipc	s2,0x8
    80000916:	6fe90913          	addi	s2,s2,1790 # 80009010 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000091a:	85d2                	mv	a1,s4
    8000091c:	8526                	mv	a0,s1
    8000091e:	00002097          	auipc	ra,0x2
    80000922:	950080e7          	jalr	-1712(ra) # 8000226e <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000926:	00093783          	ld	a5,0(s2)
    8000092a:	6098                	ld	a4,0(s1)
    8000092c:	02070713          	addi	a4,a4,32
    80000930:	fef705e3          	beq	a4,a5,8000091a <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80000934:	00011497          	auipc	s1,0x11
    80000938:	91448493          	addi	s1,s1,-1772 # 80011248 <uart_tx_lock>
    8000093c:	01f7f713          	andi	a4,a5,31
    80000940:	9726                	add	a4,a4,s1
    80000942:	01370c23          	sb	s3,24(a4)
      uart_tx_w += 1;
    80000946:	0785                	addi	a5,a5,1
    80000948:	00008717          	auipc	a4,0x8
    8000094c:	6cf73423          	sd	a5,1736(a4) # 80009010 <uart_tx_w>
      uartstart();
    80000950:	00000097          	auipc	ra,0x0
    80000954:	ee2080e7          	jalr	-286(ra) # 80000832 <uartstart>
      release(&uart_tx_lock);
    80000958:	8526                	mv	a0,s1
    8000095a:	00000097          	auipc	ra,0x0
    8000095e:	330080e7          	jalr	816(ra) # 80000c8a <release>
}
    80000962:	70a2                	ld	ra,40(sp)
    80000964:	7402                	ld	s0,32(sp)
    80000966:	64e2                	ld	s1,24(sp)
    80000968:	6942                	ld	s2,16(sp)
    8000096a:	69a2                	ld	s3,8(sp)
    8000096c:	6a02                	ld	s4,0(sp)
    8000096e:	6145                	addi	sp,sp,48
    80000970:	8082                	ret

0000000080000972 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80000972:	1141                	addi	sp,sp,-16
    80000974:	e422                	sd	s0,8(sp)
    80000976:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80000978:	100007b7          	lui	a5,0x10000
    8000097c:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80000980:	8b85                	andi	a5,a5,1
    80000982:	cb91                	beqz	a5,80000996 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80000984:	100007b7          	lui	a5,0x10000
    80000988:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    8000098c:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    80000990:	6422                	ld	s0,8(sp)
    80000992:	0141                	addi	sp,sp,16
    80000994:	8082                	ret
    return -1;
    80000996:	557d                	li	a0,-1
    80000998:	bfe5                	j	80000990 <uartgetc+0x1e>

000000008000099a <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    8000099a:	1101                	addi	sp,sp,-32
    8000099c:	ec06                	sd	ra,24(sp)
    8000099e:	e822                	sd	s0,16(sp)
    800009a0:	e426                	sd	s1,8(sp)
    800009a2:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800009a4:	54fd                	li	s1,-1
    int c = uartgetc();
    800009a6:	00000097          	auipc	ra,0x0
    800009aa:	fcc080e7          	jalr	-52(ra) # 80000972 <uartgetc>
    if(c == -1)
    800009ae:	00950763          	beq	a0,s1,800009bc <uartintr+0x22>
      break;
    consoleintr(c);
    800009b2:	00000097          	auipc	ra,0x0
    800009b6:	8fe080e7          	jalr	-1794(ra) # 800002b0 <consoleintr>
  while(1){
    800009ba:	b7f5                	j	800009a6 <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800009bc:	00011497          	auipc	s1,0x11
    800009c0:	88c48493          	addi	s1,s1,-1908 # 80011248 <uart_tx_lock>
    800009c4:	8526                	mv	a0,s1
    800009c6:	00000097          	auipc	ra,0x0
    800009ca:	210080e7          	jalr	528(ra) # 80000bd6 <acquire>
  uartstart();
    800009ce:	00000097          	auipc	ra,0x0
    800009d2:	e64080e7          	jalr	-412(ra) # 80000832 <uartstart>
  release(&uart_tx_lock);
    800009d6:	8526                	mv	a0,s1
    800009d8:	00000097          	auipc	ra,0x0
    800009dc:	2b2080e7          	jalr	690(ra) # 80000c8a <release>
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
    800009fa:	ebb9                	bnez	a5,80000a50 <kfree+0x66>
    800009fc:	84aa                	mv	s1,a0
    800009fe:	00035797          	auipc	a5,0x35
    80000a02:	60278793          	addi	a5,a5,1538 # 80036000 <end>
    80000a06:	04f56563          	bltu	a0,a5,80000a50 <kfree+0x66>
    80000a0a:	47c5                	li	a5,17
    80000a0c:	07ee                	slli	a5,a5,0x1b
    80000a0e:	04f57163          	bgeu	a0,a5,80000a50 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a12:	6605                	lui	a2,0x1
    80000a14:	4585                	li	a1,1
    80000a16:	00000097          	auipc	ra,0x0
    80000a1a:	2bc080e7          	jalr	700(ra) # 80000cd2 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a1e:	00011917          	auipc	s2,0x11
    80000a22:	86290913          	addi	s2,s2,-1950 # 80011280 <kmem>
    80000a26:	854a                	mv	a0,s2
    80000a28:	00000097          	auipc	ra,0x0
    80000a2c:	1ae080e7          	jalr	430(ra) # 80000bd6 <acquire>
  r->next = kmem.freelist;
    80000a30:	01893783          	ld	a5,24(s2)
    80000a34:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a36:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a3a:	854a                	mv	a0,s2
    80000a3c:	00000097          	auipc	ra,0x0
    80000a40:	24e080e7          	jalr	590(ra) # 80000c8a <release>
}
    80000a44:	60e2                	ld	ra,24(sp)
    80000a46:	6442                	ld	s0,16(sp)
    80000a48:	64a2                	ld	s1,8(sp)
    80000a4a:	6902                	ld	s2,0(sp)
    80000a4c:	6105                	addi	sp,sp,32
    80000a4e:	8082                	ret
    panic("kfree");
    80000a50:	00007517          	auipc	a0,0x7
    80000a54:	61050513          	addi	a0,a0,1552 # 80008060 <digits+0x20>
    80000a58:	00000097          	auipc	ra,0x0
    80000a5c:	ad8080e7          	jalr	-1320(ra) # 80000530 <panic>

0000000080000a60 <freerange>:
{
    80000a60:	7179                	addi	sp,sp,-48
    80000a62:	f406                	sd	ra,40(sp)
    80000a64:	f022                	sd	s0,32(sp)
    80000a66:	ec26                	sd	s1,24(sp)
    80000a68:	e84a                	sd	s2,16(sp)
    80000a6a:	e44e                	sd	s3,8(sp)
    80000a6c:	e052                	sd	s4,0(sp)
    80000a6e:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000a70:	6785                	lui	a5,0x1
    80000a72:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    80000a76:	94aa                	add	s1,s1,a0
    80000a78:	757d                	lui	a0,0xfffff
    80000a7a:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a7c:	94be                	add	s1,s1,a5
    80000a7e:	0095ee63          	bltu	a1,s1,80000a9a <freerange+0x3a>
    80000a82:	892e                	mv	s2,a1
    kfree(p);
    80000a84:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a86:	6985                	lui	s3,0x1
    kfree(p);
    80000a88:	01448533          	add	a0,s1,s4
    80000a8c:	00000097          	auipc	ra,0x0
    80000a90:	f5e080e7          	jalr	-162(ra) # 800009ea <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a94:	94ce                	add	s1,s1,s3
    80000a96:	fe9979e3          	bgeu	s2,s1,80000a88 <freerange+0x28>
}
    80000a9a:	70a2                	ld	ra,40(sp)
    80000a9c:	7402                	ld	s0,32(sp)
    80000a9e:	64e2                	ld	s1,24(sp)
    80000aa0:	6942                	ld	s2,16(sp)
    80000aa2:	69a2                	ld	s3,8(sp)
    80000aa4:	6a02                	ld	s4,0(sp)
    80000aa6:	6145                	addi	sp,sp,48
    80000aa8:	8082                	ret

0000000080000aaa <kinit>:
{
    80000aaa:	1141                	addi	sp,sp,-16
    80000aac:	e406                	sd	ra,8(sp)
    80000aae:	e022                	sd	s0,0(sp)
    80000ab0:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000ab2:	00007597          	auipc	a1,0x7
    80000ab6:	5b658593          	addi	a1,a1,1462 # 80008068 <digits+0x28>
    80000aba:	00010517          	auipc	a0,0x10
    80000abe:	7c650513          	addi	a0,a0,1990 # 80011280 <kmem>
    80000ac2:	00000097          	auipc	ra,0x0
    80000ac6:	084080e7          	jalr	132(ra) # 80000b46 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000aca:	45c5                	li	a1,17
    80000acc:	05ee                	slli	a1,a1,0x1b
    80000ace:	00035517          	auipc	a0,0x35
    80000ad2:	53250513          	addi	a0,a0,1330 # 80036000 <end>
    80000ad6:	00000097          	auipc	ra,0x0
    80000ada:	f8a080e7          	jalr	-118(ra) # 80000a60 <freerange>
}
    80000ade:	60a2                	ld	ra,8(sp)
    80000ae0:	6402                	ld	s0,0(sp)
    80000ae2:	0141                	addi	sp,sp,16
    80000ae4:	8082                	ret

0000000080000ae6 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000ae6:	1101                	addi	sp,sp,-32
    80000ae8:	ec06                	sd	ra,24(sp)
    80000aea:	e822                	sd	s0,16(sp)
    80000aec:	e426                	sd	s1,8(sp)
    80000aee:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000af0:	00010497          	auipc	s1,0x10
    80000af4:	79048493          	addi	s1,s1,1936 # 80011280 <kmem>
    80000af8:	8526                	mv	a0,s1
    80000afa:	00000097          	auipc	ra,0x0
    80000afe:	0dc080e7          	jalr	220(ra) # 80000bd6 <acquire>
  r = kmem.freelist;
    80000b02:	6c84                	ld	s1,24(s1)
  if(r)
    80000b04:	c885                	beqz	s1,80000b34 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000b06:	609c                	ld	a5,0(s1)
    80000b08:	00010517          	auipc	a0,0x10
    80000b0c:	77850513          	addi	a0,a0,1912 # 80011280 <kmem>
    80000b10:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000b12:	00000097          	auipc	ra,0x0
    80000b16:	178080e7          	jalr	376(ra) # 80000c8a <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000b1a:	6605                	lui	a2,0x1
    80000b1c:	4595                	li	a1,5
    80000b1e:	8526                	mv	a0,s1
    80000b20:	00000097          	auipc	ra,0x0
    80000b24:	1b2080e7          	jalr	434(ra) # 80000cd2 <memset>
  return (void*)r;
}
    80000b28:	8526                	mv	a0,s1
    80000b2a:	60e2                	ld	ra,24(sp)
    80000b2c:	6442                	ld	s0,16(sp)
    80000b2e:	64a2                	ld	s1,8(sp)
    80000b30:	6105                	addi	sp,sp,32
    80000b32:	8082                	ret
  release(&kmem.lock);
    80000b34:	00010517          	auipc	a0,0x10
    80000b38:	74c50513          	addi	a0,a0,1868 # 80011280 <kmem>
    80000b3c:	00000097          	auipc	ra,0x0
    80000b40:	14e080e7          	jalr	334(ra) # 80000c8a <release>
  if(r)
    80000b44:	b7d5                	j	80000b28 <kalloc+0x42>

0000000080000b46 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000b46:	1141                	addi	sp,sp,-16
    80000b48:	e422                	sd	s0,8(sp)
    80000b4a:	0800                	addi	s0,sp,16
  lk->name = name;
    80000b4c:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000b4e:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000b52:	00053823          	sd	zero,16(a0)
}
    80000b56:	6422                	ld	s0,8(sp)
    80000b58:	0141                	addi	sp,sp,16
    80000b5a:	8082                	ret

0000000080000b5c <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000b5c:	411c                	lw	a5,0(a0)
    80000b5e:	e399                	bnez	a5,80000b64 <holding+0x8>
    80000b60:	4501                	li	a0,0
  return r;
}
    80000b62:	8082                	ret
{
    80000b64:	1101                	addi	sp,sp,-32
    80000b66:	ec06                	sd	ra,24(sp)
    80000b68:	e822                	sd	s0,16(sp)
    80000b6a:	e426                	sd	s1,8(sp)
    80000b6c:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000b6e:	6904                	ld	s1,16(a0)
    80000b70:	00001097          	auipc	ra,0x1
    80000b74:	e1a080e7          	jalr	-486(ra) # 8000198a <mycpu>
    80000b78:	40a48533          	sub	a0,s1,a0
    80000b7c:	00153513          	seqz	a0,a0
}
    80000b80:	60e2                	ld	ra,24(sp)
    80000b82:	6442                	ld	s0,16(sp)
    80000b84:	64a2                	ld	s1,8(sp)
    80000b86:	6105                	addi	sp,sp,32
    80000b88:	8082                	ret

0000000080000b8a <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000b8a:	1101                	addi	sp,sp,-32
    80000b8c:	ec06                	sd	ra,24(sp)
    80000b8e:	e822                	sd	s0,16(sp)
    80000b90:	e426                	sd	s1,8(sp)
    80000b92:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000b94:	100024f3          	csrr	s1,sstatus
    80000b98:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000b9c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000b9e:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000ba2:	00001097          	auipc	ra,0x1
    80000ba6:	de8080e7          	jalr	-536(ra) # 8000198a <mycpu>
    80000baa:	5d3c                	lw	a5,120(a0)
    80000bac:	cf89                	beqz	a5,80000bc6 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000bae:	00001097          	auipc	ra,0x1
    80000bb2:	ddc080e7          	jalr	-548(ra) # 8000198a <mycpu>
    80000bb6:	5d3c                	lw	a5,120(a0)
    80000bb8:	2785                	addiw	a5,a5,1
    80000bba:	dd3c                	sw	a5,120(a0)
}
    80000bbc:	60e2                	ld	ra,24(sp)
    80000bbe:	6442                	ld	s0,16(sp)
    80000bc0:	64a2                	ld	s1,8(sp)
    80000bc2:	6105                	addi	sp,sp,32
    80000bc4:	8082                	ret
    mycpu()->intena = old;
    80000bc6:	00001097          	auipc	ra,0x1
    80000bca:	dc4080e7          	jalr	-572(ra) # 8000198a <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000bce:	8085                	srli	s1,s1,0x1
    80000bd0:	8885                	andi	s1,s1,1
    80000bd2:	dd64                	sw	s1,124(a0)
    80000bd4:	bfe9                	j	80000bae <push_off+0x24>

0000000080000bd6 <acquire>:
{
    80000bd6:	1101                	addi	sp,sp,-32
    80000bd8:	ec06                	sd	ra,24(sp)
    80000bda:	e822                	sd	s0,16(sp)
    80000bdc:	e426                	sd	s1,8(sp)
    80000bde:	1000                	addi	s0,sp,32
    80000be0:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000be2:	00000097          	auipc	ra,0x0
    80000be6:	fa8080e7          	jalr	-88(ra) # 80000b8a <push_off>
  if(holding(lk))
    80000bea:	8526                	mv	a0,s1
    80000bec:	00000097          	auipc	ra,0x0
    80000bf0:	f70080e7          	jalr	-144(ra) # 80000b5c <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000bf4:	4705                	li	a4,1
  if(holding(lk))
    80000bf6:	e115                	bnez	a0,80000c1a <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000bf8:	87ba                	mv	a5,a4
    80000bfa:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000bfe:	2781                	sext.w	a5,a5
    80000c00:	ffe5                	bnez	a5,80000bf8 <acquire+0x22>
  __sync_synchronize();
    80000c02:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000c06:	00001097          	auipc	ra,0x1
    80000c0a:	d84080e7          	jalr	-636(ra) # 8000198a <mycpu>
    80000c0e:	e888                	sd	a0,16(s1)
}
    80000c10:	60e2                	ld	ra,24(sp)
    80000c12:	6442                	ld	s0,16(sp)
    80000c14:	64a2                	ld	s1,8(sp)
    80000c16:	6105                	addi	sp,sp,32
    80000c18:	8082                	ret
    panic("acquire");
    80000c1a:	00007517          	auipc	a0,0x7
    80000c1e:	45650513          	addi	a0,a0,1110 # 80008070 <digits+0x30>
    80000c22:	00000097          	auipc	ra,0x0
    80000c26:	90e080e7          	jalr	-1778(ra) # 80000530 <panic>

0000000080000c2a <pop_off>:

void
pop_off(void)
{
    80000c2a:	1141                	addi	sp,sp,-16
    80000c2c:	e406                	sd	ra,8(sp)
    80000c2e:	e022                	sd	s0,0(sp)
    80000c30:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000c32:	00001097          	auipc	ra,0x1
    80000c36:	d58080e7          	jalr	-680(ra) # 8000198a <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c3a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000c3e:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000c40:	e78d                	bnez	a5,80000c6a <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000c42:	5d3c                	lw	a5,120(a0)
    80000c44:	02f05b63          	blez	a5,80000c7a <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80000c48:	37fd                	addiw	a5,a5,-1
    80000c4a:	0007871b          	sext.w	a4,a5
    80000c4e:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000c50:	eb09                	bnez	a4,80000c62 <pop_off+0x38>
    80000c52:	5d7c                	lw	a5,124(a0)
    80000c54:	c799                	beqz	a5,80000c62 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c56:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000c5a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c5e:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000c62:	60a2                	ld	ra,8(sp)
    80000c64:	6402                	ld	s0,0(sp)
    80000c66:	0141                	addi	sp,sp,16
    80000c68:	8082                	ret
    panic("pop_off - interruptible");
    80000c6a:	00007517          	auipc	a0,0x7
    80000c6e:	40e50513          	addi	a0,a0,1038 # 80008078 <digits+0x38>
    80000c72:	00000097          	auipc	ra,0x0
    80000c76:	8be080e7          	jalr	-1858(ra) # 80000530 <panic>
    panic("pop_off");
    80000c7a:	00007517          	auipc	a0,0x7
    80000c7e:	41650513          	addi	a0,a0,1046 # 80008090 <digits+0x50>
    80000c82:	00000097          	auipc	ra,0x0
    80000c86:	8ae080e7          	jalr	-1874(ra) # 80000530 <panic>

0000000080000c8a <release>:
{
    80000c8a:	1101                	addi	sp,sp,-32
    80000c8c:	ec06                	sd	ra,24(sp)
    80000c8e:	e822                	sd	s0,16(sp)
    80000c90:	e426                	sd	s1,8(sp)
    80000c92:	1000                	addi	s0,sp,32
    80000c94:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000c96:	00000097          	auipc	ra,0x0
    80000c9a:	ec6080e7          	jalr	-314(ra) # 80000b5c <holding>
    80000c9e:	c115                	beqz	a0,80000cc2 <release+0x38>
  lk->cpu = 0;
    80000ca0:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000ca4:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000ca8:	0f50000f          	fence	iorw,ow
    80000cac:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000cb0:	00000097          	auipc	ra,0x0
    80000cb4:	f7a080e7          	jalr	-134(ra) # 80000c2a <pop_off>
}
    80000cb8:	60e2                	ld	ra,24(sp)
    80000cba:	6442                	ld	s0,16(sp)
    80000cbc:	64a2                	ld	s1,8(sp)
    80000cbe:	6105                	addi	sp,sp,32
    80000cc0:	8082                	ret
    panic("release");
    80000cc2:	00007517          	auipc	a0,0x7
    80000cc6:	3d650513          	addi	a0,a0,982 # 80008098 <digits+0x58>
    80000cca:	00000097          	auipc	ra,0x0
    80000cce:	866080e7          	jalr	-1946(ra) # 80000530 <panic>

0000000080000cd2 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000cd2:	1141                	addi	sp,sp,-16
    80000cd4:	e422                	sd	s0,8(sp)
    80000cd6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000cd8:	ce09                	beqz	a2,80000cf2 <memset+0x20>
    80000cda:	87aa                	mv	a5,a0
    80000cdc:	fff6071b          	addiw	a4,a2,-1
    80000ce0:	1702                	slli	a4,a4,0x20
    80000ce2:	9301                	srli	a4,a4,0x20
    80000ce4:	0705                	addi	a4,a4,1
    80000ce6:	972a                	add	a4,a4,a0
    cdst[i] = c;
    80000ce8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000cec:	0785                	addi	a5,a5,1
    80000cee:	fee79de3          	bne	a5,a4,80000ce8 <memset+0x16>
  }
  return dst;
}
    80000cf2:	6422                	ld	s0,8(sp)
    80000cf4:	0141                	addi	sp,sp,16
    80000cf6:	8082                	ret

0000000080000cf8 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000cf8:	1141                	addi	sp,sp,-16
    80000cfa:	e422                	sd	s0,8(sp)
    80000cfc:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000cfe:	ca05                	beqz	a2,80000d2e <memcmp+0x36>
    80000d00:	fff6069b          	addiw	a3,a2,-1
    80000d04:	1682                	slli	a3,a3,0x20
    80000d06:	9281                	srli	a3,a3,0x20
    80000d08:	0685                	addi	a3,a3,1
    80000d0a:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000d0c:	00054783          	lbu	a5,0(a0)
    80000d10:	0005c703          	lbu	a4,0(a1)
    80000d14:	00e79863          	bne	a5,a4,80000d24 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000d18:	0505                	addi	a0,a0,1
    80000d1a:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000d1c:	fed518e3          	bne	a0,a3,80000d0c <memcmp+0x14>
  }

  return 0;
    80000d20:	4501                	li	a0,0
    80000d22:	a019                	j	80000d28 <memcmp+0x30>
      return *s1 - *s2;
    80000d24:	40e7853b          	subw	a0,a5,a4
}
    80000d28:	6422                	ld	s0,8(sp)
    80000d2a:	0141                	addi	sp,sp,16
    80000d2c:	8082                	ret
  return 0;
    80000d2e:	4501                	li	a0,0
    80000d30:	bfe5                	j	80000d28 <memcmp+0x30>

0000000080000d32 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000d32:	1141                	addi	sp,sp,-16
    80000d34:	e422                	sd	s0,8(sp)
    80000d36:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000d38:	00a5f963          	bgeu	a1,a0,80000d4a <memmove+0x18>
    80000d3c:	02061713          	slli	a4,a2,0x20
    80000d40:	9301                	srli	a4,a4,0x20
    80000d42:	00e587b3          	add	a5,a1,a4
    80000d46:	02f56563          	bltu	a0,a5,80000d70 <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000d4a:	fff6069b          	addiw	a3,a2,-1
    80000d4e:	ce11                	beqz	a2,80000d6a <memmove+0x38>
    80000d50:	1682                	slli	a3,a3,0x20
    80000d52:	9281                	srli	a3,a3,0x20
    80000d54:	0685                	addi	a3,a3,1
    80000d56:	96ae                	add	a3,a3,a1
    80000d58:	87aa                	mv	a5,a0
      *d++ = *s++;
    80000d5a:	0585                	addi	a1,a1,1
    80000d5c:	0785                	addi	a5,a5,1
    80000d5e:	fff5c703          	lbu	a4,-1(a1)
    80000d62:	fee78fa3          	sb	a4,-1(a5)
    while(n-- > 0)
    80000d66:	fed59ae3          	bne	a1,a3,80000d5a <memmove+0x28>

  return dst;
}
    80000d6a:	6422                	ld	s0,8(sp)
    80000d6c:	0141                	addi	sp,sp,16
    80000d6e:	8082                	ret
    d += n;
    80000d70:	972a                	add	a4,a4,a0
    while(n-- > 0)
    80000d72:	fff6069b          	addiw	a3,a2,-1
    80000d76:	da75                	beqz	a2,80000d6a <memmove+0x38>
    80000d78:	02069613          	slli	a2,a3,0x20
    80000d7c:	9201                	srli	a2,a2,0x20
    80000d7e:	fff64613          	not	a2,a2
    80000d82:	963e                	add	a2,a2,a5
      *--d = *--s;
    80000d84:	17fd                	addi	a5,a5,-1
    80000d86:	177d                	addi	a4,a4,-1
    80000d88:	0007c683          	lbu	a3,0(a5)
    80000d8c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    80000d90:	fec79ae3          	bne	a5,a2,80000d84 <memmove+0x52>
    80000d94:	bfd9                	j	80000d6a <memmove+0x38>

0000000080000d96 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000d96:	1141                	addi	sp,sp,-16
    80000d98:	e406                	sd	ra,8(sp)
    80000d9a:	e022                	sd	s0,0(sp)
    80000d9c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000d9e:	00000097          	auipc	ra,0x0
    80000da2:	f94080e7          	jalr	-108(ra) # 80000d32 <memmove>
}
    80000da6:	60a2                	ld	ra,8(sp)
    80000da8:	6402                	ld	s0,0(sp)
    80000daa:	0141                	addi	sp,sp,16
    80000dac:	8082                	ret

0000000080000dae <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000dae:	1141                	addi	sp,sp,-16
    80000db0:	e422                	sd	s0,8(sp)
    80000db2:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000db4:	ce11                	beqz	a2,80000dd0 <strncmp+0x22>
    80000db6:	00054783          	lbu	a5,0(a0)
    80000dba:	cf89                	beqz	a5,80000dd4 <strncmp+0x26>
    80000dbc:	0005c703          	lbu	a4,0(a1)
    80000dc0:	00f71a63          	bne	a4,a5,80000dd4 <strncmp+0x26>
    n--, p++, q++;
    80000dc4:	367d                	addiw	a2,a2,-1
    80000dc6:	0505                	addi	a0,a0,1
    80000dc8:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000dca:	f675                	bnez	a2,80000db6 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000dcc:	4501                	li	a0,0
    80000dce:	a809                	j	80000de0 <strncmp+0x32>
    80000dd0:	4501                	li	a0,0
    80000dd2:	a039                	j	80000de0 <strncmp+0x32>
  if(n == 0)
    80000dd4:	ca09                	beqz	a2,80000de6 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000dd6:	00054503          	lbu	a0,0(a0)
    80000dda:	0005c783          	lbu	a5,0(a1)
    80000dde:	9d1d                	subw	a0,a0,a5
}
    80000de0:	6422                	ld	s0,8(sp)
    80000de2:	0141                	addi	sp,sp,16
    80000de4:	8082                	ret
    return 0;
    80000de6:	4501                	li	a0,0
    80000de8:	bfe5                	j	80000de0 <strncmp+0x32>

0000000080000dea <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000dea:	1141                	addi	sp,sp,-16
    80000dec:	e422                	sd	s0,8(sp)
    80000dee:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000df0:	872a                	mv	a4,a0
    80000df2:	8832                	mv	a6,a2
    80000df4:	367d                	addiw	a2,a2,-1
    80000df6:	01005963          	blez	a6,80000e08 <strncpy+0x1e>
    80000dfa:	0705                	addi	a4,a4,1
    80000dfc:	0005c783          	lbu	a5,0(a1)
    80000e00:	fef70fa3          	sb	a5,-1(a4)
    80000e04:	0585                	addi	a1,a1,1
    80000e06:	f7f5                	bnez	a5,80000df2 <strncpy+0x8>
    ;
  while(n-- > 0)
    80000e08:	00c05d63          	blez	a2,80000e22 <strncpy+0x38>
    80000e0c:	86ba                	mv	a3,a4
    *s++ = 0;
    80000e0e:	0685                	addi	a3,a3,1
    80000e10:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000e14:	fff6c793          	not	a5,a3
    80000e18:	9fb9                	addw	a5,a5,a4
    80000e1a:	010787bb          	addw	a5,a5,a6
    80000e1e:	fef048e3          	bgtz	a5,80000e0e <strncpy+0x24>
  return os;
}
    80000e22:	6422                	ld	s0,8(sp)
    80000e24:	0141                	addi	sp,sp,16
    80000e26:	8082                	ret

0000000080000e28 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000e28:	1141                	addi	sp,sp,-16
    80000e2a:	e422                	sd	s0,8(sp)
    80000e2c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000e2e:	02c05363          	blez	a2,80000e54 <safestrcpy+0x2c>
    80000e32:	fff6069b          	addiw	a3,a2,-1
    80000e36:	1682                	slli	a3,a3,0x20
    80000e38:	9281                	srli	a3,a3,0x20
    80000e3a:	96ae                	add	a3,a3,a1
    80000e3c:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000e3e:	00d58963          	beq	a1,a3,80000e50 <safestrcpy+0x28>
    80000e42:	0585                	addi	a1,a1,1
    80000e44:	0785                	addi	a5,a5,1
    80000e46:	fff5c703          	lbu	a4,-1(a1)
    80000e4a:	fee78fa3          	sb	a4,-1(a5)
    80000e4e:	fb65                	bnez	a4,80000e3e <safestrcpy+0x16>
    ;
  *s = 0;
    80000e50:	00078023          	sb	zero,0(a5)
  return os;
}
    80000e54:	6422                	ld	s0,8(sp)
    80000e56:	0141                	addi	sp,sp,16
    80000e58:	8082                	ret

0000000080000e5a <strlen>:

int
strlen(const char *s)
{
    80000e5a:	1141                	addi	sp,sp,-16
    80000e5c:	e422                	sd	s0,8(sp)
    80000e5e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000e60:	00054783          	lbu	a5,0(a0)
    80000e64:	cf91                	beqz	a5,80000e80 <strlen+0x26>
    80000e66:	0505                	addi	a0,a0,1
    80000e68:	87aa                	mv	a5,a0
    80000e6a:	4685                	li	a3,1
    80000e6c:	9e89                	subw	a3,a3,a0
    80000e6e:	00f6853b          	addw	a0,a3,a5
    80000e72:	0785                	addi	a5,a5,1
    80000e74:	fff7c703          	lbu	a4,-1(a5)
    80000e78:	fb7d                	bnez	a4,80000e6e <strlen+0x14>
    ;
  return n;
}
    80000e7a:	6422                	ld	s0,8(sp)
    80000e7c:	0141                	addi	sp,sp,16
    80000e7e:	8082                	ret
  for(n = 0; s[n]; n++)
    80000e80:	4501                	li	a0,0
    80000e82:	bfe5                	j	80000e7a <strlen+0x20>

0000000080000e84 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000e84:	1141                	addi	sp,sp,-16
    80000e86:	e406                	sd	ra,8(sp)
    80000e88:	e022                	sd	s0,0(sp)
    80000e8a:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000e8c:	00001097          	auipc	ra,0x1
    80000e90:	aee080e7          	jalr	-1298(ra) # 8000197a <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000e94:	00008717          	auipc	a4,0x8
    80000e98:	18470713          	addi	a4,a4,388 # 80009018 <started>
  if(cpuid() == 0){
    80000e9c:	c139                	beqz	a0,80000ee2 <main+0x5e>
    while(started == 0)
    80000e9e:	431c                	lw	a5,0(a4)
    80000ea0:	2781                	sext.w	a5,a5
    80000ea2:	dff5                	beqz	a5,80000e9e <main+0x1a>
      ;
    __sync_synchronize();
    80000ea4:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000ea8:	00001097          	auipc	ra,0x1
    80000eac:	ad2080e7          	jalr	-1326(ra) # 8000197a <cpuid>
    80000eb0:	85aa                	mv	a1,a0
    80000eb2:	00007517          	auipc	a0,0x7
    80000eb6:	20650513          	addi	a0,a0,518 # 800080b8 <digits+0x78>
    80000eba:	fffff097          	auipc	ra,0xfffff
    80000ebe:	6c0080e7          	jalr	1728(ra) # 8000057a <printf>
    kvminithart();    // turn on paging
    80000ec2:	00000097          	auipc	ra,0x0
    80000ec6:	0d8080e7          	jalr	216(ra) # 80000f9a <kvminithart>
    trapinithart();   // install kernel trap vector
    80000eca:	00001097          	auipc	ra,0x1
    80000ece:	7f2080e7          	jalr	2034(ra) # 800026bc <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000ed2:	00005097          	auipc	ra,0x5
    80000ed6:	13e080e7          	jalr	318(ra) # 80006010 <plicinithart>
  }

  scheduler();        
    80000eda:	00001097          	auipc	ra,0x1
    80000ede:	03c080e7          	jalr	60(ra) # 80001f16 <scheduler>
    consoleinit();
    80000ee2:	fffff097          	auipc	ra,0xfffff
    80000ee6:	560080e7          	jalr	1376(ra) # 80000442 <consoleinit>
    printfinit();
    80000eea:	00000097          	auipc	ra,0x0
    80000eee:	876080e7          	jalr	-1930(ra) # 80000760 <printfinit>
    printf("\n");
    80000ef2:	00007517          	auipc	a0,0x7
    80000ef6:	42e50513          	addi	a0,a0,1070 # 80008320 <states.1785+0xb8>
    80000efa:	fffff097          	auipc	ra,0xfffff
    80000efe:	680080e7          	jalr	1664(ra) # 8000057a <printf>
    printf("xv6 kernel is booting\n");
    80000f02:	00007517          	auipc	a0,0x7
    80000f06:	19e50513          	addi	a0,a0,414 # 800080a0 <digits+0x60>
    80000f0a:	fffff097          	auipc	ra,0xfffff
    80000f0e:	670080e7          	jalr	1648(ra) # 8000057a <printf>
    printf("\n");
    80000f12:	00007517          	auipc	a0,0x7
    80000f16:	40e50513          	addi	a0,a0,1038 # 80008320 <states.1785+0xb8>
    80000f1a:	fffff097          	auipc	ra,0xfffff
    80000f1e:	660080e7          	jalr	1632(ra) # 8000057a <printf>
    kinit();         // physical page allocator
    80000f22:	00000097          	auipc	ra,0x0
    80000f26:	b88080e7          	jalr	-1144(ra) # 80000aaa <kinit>
    kvminit();       // create kernel page table
    80000f2a:	00000097          	auipc	ra,0x0
    80000f2e:	310080e7          	jalr	784(ra) # 8000123a <kvminit>
    kvminithart();   // turn on paging
    80000f32:	00000097          	auipc	ra,0x0
    80000f36:	068080e7          	jalr	104(ra) # 80000f9a <kvminithart>
    procinit();      // process table
    80000f3a:	00001097          	auipc	ra,0x1
    80000f3e:	9a8080e7          	jalr	-1624(ra) # 800018e2 <procinit>
    trapinit();      // trap vectors
    80000f42:	00001097          	auipc	ra,0x1
    80000f46:	752080e7          	jalr	1874(ra) # 80002694 <trapinit>
    trapinithart();  // install kernel trap vector
    80000f4a:	00001097          	auipc	ra,0x1
    80000f4e:	772080e7          	jalr	1906(ra) # 800026bc <trapinithart>
    plicinit();      // set up interrupt controller
    80000f52:	00005097          	auipc	ra,0x5
    80000f56:	0a8080e7          	jalr	168(ra) # 80005ffa <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000f5a:	00005097          	auipc	ra,0x5
    80000f5e:	0b6080e7          	jalr	182(ra) # 80006010 <plicinithart>
    binit();         // buffer cache
    80000f62:	00002097          	auipc	ra,0x2
    80000f66:	ffc080e7          	jalr	-4(ra) # 80002f5e <binit>
    iinit();         // inode cache
    80000f6a:	00002097          	auipc	ra,0x2
    80000f6e:	68c080e7          	jalr	1676(ra) # 800035f6 <iinit>
    fileinit();      // file table
    80000f72:	00003097          	auipc	ra,0x3
    80000f76:	63e080e7          	jalr	1598(ra) # 800045b0 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000f7a:	00005097          	auipc	ra,0x5
    80000f7e:	1b8080e7          	jalr	440(ra) # 80006132 <virtio_disk_init>
    userinit();      // first user process
    80000f82:	00001097          	auipc	ra,0x1
    80000f86:	cee080e7          	jalr	-786(ra) # 80001c70 <userinit>
    __sync_synchronize();
    80000f8a:	0ff0000f          	fence
    started = 1;
    80000f8e:	4785                	li	a5,1
    80000f90:	00008717          	auipc	a4,0x8
    80000f94:	08f72423          	sw	a5,136(a4) # 80009018 <started>
    80000f98:	b789                	j	80000eda <main+0x56>

0000000080000f9a <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000f9a:	1141                	addi	sp,sp,-16
    80000f9c:	e422                	sd	s0,8(sp)
    80000f9e:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80000fa0:	00008797          	auipc	a5,0x8
    80000fa4:	0807b783          	ld	a5,128(a5) # 80009020 <kernel_pagetable>
    80000fa8:	83b1                	srli	a5,a5,0xc
    80000faa:	577d                	li	a4,-1
    80000fac:	177e                	slli	a4,a4,0x3f
    80000fae:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000fb0:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000fb4:	12000073          	sfence.vma
  sfence_vma();
}
    80000fb8:	6422                	ld	s0,8(sp)
    80000fba:	0141                	addi	sp,sp,16
    80000fbc:	8082                	ret

0000000080000fbe <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000fbe:	7139                	addi	sp,sp,-64
    80000fc0:	fc06                	sd	ra,56(sp)
    80000fc2:	f822                	sd	s0,48(sp)
    80000fc4:	f426                	sd	s1,40(sp)
    80000fc6:	f04a                	sd	s2,32(sp)
    80000fc8:	ec4e                	sd	s3,24(sp)
    80000fca:	e852                	sd	s4,16(sp)
    80000fcc:	e456                	sd	s5,8(sp)
    80000fce:	e05a                	sd	s6,0(sp)
    80000fd0:	0080                	addi	s0,sp,64
    80000fd2:	84aa                	mv	s1,a0
    80000fd4:	89ae                	mv	s3,a1
    80000fd6:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000fd8:	57fd                	li	a5,-1
    80000fda:	83e9                	srli	a5,a5,0x1a
    80000fdc:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000fde:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000fe0:	04b7f263          	bgeu	a5,a1,80001024 <walk+0x66>
    panic("walk");
    80000fe4:	00007517          	auipc	a0,0x7
    80000fe8:	0ec50513          	addi	a0,a0,236 # 800080d0 <digits+0x90>
    80000fec:	fffff097          	auipc	ra,0xfffff
    80000ff0:	544080e7          	jalr	1348(ra) # 80000530 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000ff4:	060a8663          	beqz	s5,80001060 <walk+0xa2>
    80000ff8:	00000097          	auipc	ra,0x0
    80000ffc:	aee080e7          	jalr	-1298(ra) # 80000ae6 <kalloc>
    80001000:	84aa                	mv	s1,a0
    80001002:	c529                	beqz	a0,8000104c <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80001004:	6605                	lui	a2,0x1
    80001006:	4581                	li	a1,0
    80001008:	00000097          	auipc	ra,0x0
    8000100c:	cca080e7          	jalr	-822(ra) # 80000cd2 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80001010:	00c4d793          	srli	a5,s1,0xc
    80001014:	07aa                	slli	a5,a5,0xa
    80001016:	0017e793          	ori	a5,a5,1
    8000101a:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    8000101e:	3a5d                	addiw	s4,s4,-9
    80001020:	036a0063          	beq	s4,s6,80001040 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80001024:	0149d933          	srl	s2,s3,s4
    80001028:	1ff97913          	andi	s2,s2,511
    8000102c:	090e                	slli	s2,s2,0x3
    8000102e:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80001030:	00093483          	ld	s1,0(s2)
    80001034:	0014f793          	andi	a5,s1,1
    80001038:	dfd5                	beqz	a5,80000ff4 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    8000103a:	80a9                	srli	s1,s1,0xa
    8000103c:	04b2                	slli	s1,s1,0xc
    8000103e:	b7c5                	j	8000101e <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    80001040:	00c9d513          	srli	a0,s3,0xc
    80001044:	1ff57513          	andi	a0,a0,511
    80001048:	050e                	slli	a0,a0,0x3
    8000104a:	9526                	add	a0,a0,s1
}
    8000104c:	70e2                	ld	ra,56(sp)
    8000104e:	7442                	ld	s0,48(sp)
    80001050:	74a2                	ld	s1,40(sp)
    80001052:	7902                	ld	s2,32(sp)
    80001054:	69e2                	ld	s3,24(sp)
    80001056:	6a42                	ld	s4,16(sp)
    80001058:	6aa2                	ld	s5,8(sp)
    8000105a:	6b02                	ld	s6,0(sp)
    8000105c:	6121                	addi	sp,sp,64
    8000105e:	8082                	ret
        return 0;
    80001060:	4501                	li	a0,0
    80001062:	b7ed                	j	8000104c <walk+0x8e>

0000000080001064 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80001064:	57fd                	li	a5,-1
    80001066:	83e9                	srli	a5,a5,0x1a
    80001068:	00b7f463          	bgeu	a5,a1,80001070 <walkaddr+0xc>
    return 0;
    8000106c:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000106e:	8082                	ret
{
    80001070:	1141                	addi	sp,sp,-16
    80001072:	e406                	sd	ra,8(sp)
    80001074:	e022                	sd	s0,0(sp)
    80001076:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80001078:	4601                	li	a2,0
    8000107a:	00000097          	auipc	ra,0x0
    8000107e:	f44080e7          	jalr	-188(ra) # 80000fbe <walk>
  if(pte == 0)
    80001082:	c105                	beqz	a0,800010a2 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80001084:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80001086:	0117f693          	andi	a3,a5,17
    8000108a:	4745                	li	a4,17
    return 0;
    8000108c:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000108e:	00e68663          	beq	a3,a4,8000109a <walkaddr+0x36>
}
    80001092:	60a2                	ld	ra,8(sp)
    80001094:	6402                	ld	s0,0(sp)
    80001096:	0141                	addi	sp,sp,16
    80001098:	8082                	ret
  pa = PTE2PA(*pte);
    8000109a:	00a7d513          	srli	a0,a5,0xa
    8000109e:	0532                	slli	a0,a0,0xc
  return pa;
    800010a0:	bfcd                	j	80001092 <walkaddr+0x2e>
    return 0;
    800010a2:	4501                	li	a0,0
    800010a4:	b7fd                	j	80001092 <walkaddr+0x2e>

00000000800010a6 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800010a6:	715d                	addi	sp,sp,-80
    800010a8:	e486                	sd	ra,72(sp)
    800010aa:	e0a2                	sd	s0,64(sp)
    800010ac:	fc26                	sd	s1,56(sp)
    800010ae:	f84a                	sd	s2,48(sp)
    800010b0:	f44e                	sd	s3,40(sp)
    800010b2:	f052                	sd	s4,32(sp)
    800010b4:	ec56                	sd	s5,24(sp)
    800010b6:	e85a                	sd	s6,16(sp)
    800010b8:	e45e                	sd	s7,8(sp)
    800010ba:	0880                	addi	s0,sp,80
    800010bc:	8aaa                	mv	s5,a0
    800010be:	8b3a                	mv	s6,a4
  uint64 a, last;
  pte_t *pte;

  a = PGROUNDDOWN(va);
    800010c0:	777d                	lui	a4,0xfffff
    800010c2:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    800010c6:	167d                	addi	a2,a2,-1
    800010c8:	00b609b3          	add	s3,a2,a1
    800010cc:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    800010d0:	893e                	mv	s2,a5
    800010d2:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800010d6:	6b85                	lui	s7,0x1
    800010d8:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800010dc:	4605                	li	a2,1
    800010de:	85ca                	mv	a1,s2
    800010e0:	8556                	mv	a0,s5
    800010e2:	00000097          	auipc	ra,0x0
    800010e6:	edc080e7          	jalr	-292(ra) # 80000fbe <walk>
    800010ea:	c51d                	beqz	a0,80001118 <mappages+0x72>
    if(*pte & PTE_V)
    800010ec:	611c                	ld	a5,0(a0)
    800010ee:	8b85                	andi	a5,a5,1
    800010f0:	ef81                	bnez	a5,80001108 <mappages+0x62>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800010f2:	80b1                	srli	s1,s1,0xc
    800010f4:	04aa                	slli	s1,s1,0xa
    800010f6:	0164e4b3          	or	s1,s1,s6
    800010fa:	0014e493          	ori	s1,s1,1
    800010fe:	e104                	sd	s1,0(a0)
    if(a == last)
    80001100:	03390863          	beq	s2,s3,80001130 <mappages+0x8a>
    a += PGSIZE;
    80001104:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    80001106:	bfc9                	j	800010d8 <mappages+0x32>
      panic("remap");
    80001108:	00007517          	auipc	a0,0x7
    8000110c:	fd050513          	addi	a0,a0,-48 # 800080d8 <digits+0x98>
    80001110:	fffff097          	auipc	ra,0xfffff
    80001114:	420080e7          	jalr	1056(ra) # 80000530 <panic>
      return -1;
    80001118:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    8000111a:	60a6                	ld	ra,72(sp)
    8000111c:	6406                	ld	s0,64(sp)
    8000111e:	74e2                	ld	s1,56(sp)
    80001120:	7942                	ld	s2,48(sp)
    80001122:	79a2                	ld	s3,40(sp)
    80001124:	7a02                	ld	s4,32(sp)
    80001126:	6ae2                	ld	s5,24(sp)
    80001128:	6b42                	ld	s6,16(sp)
    8000112a:	6ba2                	ld	s7,8(sp)
    8000112c:	6161                	addi	sp,sp,80
    8000112e:	8082                	ret
  return 0;
    80001130:	4501                	li	a0,0
    80001132:	b7e5                	j	8000111a <mappages+0x74>

0000000080001134 <kvmmap>:
{
    80001134:	1141                	addi	sp,sp,-16
    80001136:	e406                	sd	ra,8(sp)
    80001138:	e022                	sd	s0,0(sp)
    8000113a:	0800                	addi	s0,sp,16
    8000113c:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    8000113e:	86b2                	mv	a3,a2
    80001140:	863e                	mv	a2,a5
    80001142:	00000097          	auipc	ra,0x0
    80001146:	f64080e7          	jalr	-156(ra) # 800010a6 <mappages>
    8000114a:	e509                	bnez	a0,80001154 <kvmmap+0x20>
}
    8000114c:	60a2                	ld	ra,8(sp)
    8000114e:	6402                	ld	s0,0(sp)
    80001150:	0141                	addi	sp,sp,16
    80001152:	8082                	ret
    panic("kvmmap");
    80001154:	00007517          	auipc	a0,0x7
    80001158:	f8c50513          	addi	a0,a0,-116 # 800080e0 <digits+0xa0>
    8000115c:	fffff097          	auipc	ra,0xfffff
    80001160:	3d4080e7          	jalr	980(ra) # 80000530 <panic>

0000000080001164 <kvmmake>:
{
    80001164:	1101                	addi	sp,sp,-32
    80001166:	ec06                	sd	ra,24(sp)
    80001168:	e822                	sd	s0,16(sp)
    8000116a:	e426                	sd	s1,8(sp)
    8000116c:	e04a                	sd	s2,0(sp)
    8000116e:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80001170:	00000097          	auipc	ra,0x0
    80001174:	976080e7          	jalr	-1674(ra) # 80000ae6 <kalloc>
    80001178:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000117a:	6605                	lui	a2,0x1
    8000117c:	4581                	li	a1,0
    8000117e:	00000097          	auipc	ra,0x0
    80001182:	b54080e7          	jalr	-1196(ra) # 80000cd2 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001186:	4719                	li	a4,6
    80001188:	6685                	lui	a3,0x1
    8000118a:	10000637          	lui	a2,0x10000
    8000118e:	100005b7          	lui	a1,0x10000
    80001192:	8526                	mv	a0,s1
    80001194:	00000097          	auipc	ra,0x0
    80001198:	fa0080e7          	jalr	-96(ra) # 80001134 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000119c:	4719                	li	a4,6
    8000119e:	6685                	lui	a3,0x1
    800011a0:	10001637          	lui	a2,0x10001
    800011a4:	100015b7          	lui	a1,0x10001
    800011a8:	8526                	mv	a0,s1
    800011aa:	00000097          	auipc	ra,0x0
    800011ae:	f8a080e7          	jalr	-118(ra) # 80001134 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800011b2:	4719                	li	a4,6
    800011b4:	004006b7          	lui	a3,0x400
    800011b8:	0c000637          	lui	a2,0xc000
    800011bc:	0c0005b7          	lui	a1,0xc000
    800011c0:	8526                	mv	a0,s1
    800011c2:	00000097          	auipc	ra,0x0
    800011c6:	f72080e7          	jalr	-142(ra) # 80001134 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800011ca:	00007917          	auipc	s2,0x7
    800011ce:	e3690913          	addi	s2,s2,-458 # 80008000 <etext>
    800011d2:	4729                	li	a4,10
    800011d4:	80007697          	auipc	a3,0x80007
    800011d8:	e2c68693          	addi	a3,a3,-468 # 8000 <_entry-0x7fff8000>
    800011dc:	4605                	li	a2,1
    800011de:	067e                	slli	a2,a2,0x1f
    800011e0:	85b2                	mv	a1,a2
    800011e2:	8526                	mv	a0,s1
    800011e4:	00000097          	auipc	ra,0x0
    800011e8:	f50080e7          	jalr	-176(ra) # 80001134 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800011ec:	4719                	li	a4,6
    800011ee:	46c5                	li	a3,17
    800011f0:	06ee                	slli	a3,a3,0x1b
    800011f2:	412686b3          	sub	a3,a3,s2
    800011f6:	864a                	mv	a2,s2
    800011f8:	85ca                	mv	a1,s2
    800011fa:	8526                	mv	a0,s1
    800011fc:	00000097          	auipc	ra,0x0
    80001200:	f38080e7          	jalr	-200(ra) # 80001134 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80001204:	4729                	li	a4,10
    80001206:	6685                	lui	a3,0x1
    80001208:	00006617          	auipc	a2,0x6
    8000120c:	df860613          	addi	a2,a2,-520 # 80007000 <_trampoline>
    80001210:	040005b7          	lui	a1,0x4000
    80001214:	15fd                	addi	a1,a1,-1
    80001216:	05b2                	slli	a1,a1,0xc
    80001218:	8526                	mv	a0,s1
    8000121a:	00000097          	auipc	ra,0x0
    8000121e:	f1a080e7          	jalr	-230(ra) # 80001134 <kvmmap>
  proc_mapstacks(kpgtbl);
    80001222:	8526                	mv	a0,s1
    80001224:	00000097          	auipc	ra,0x0
    80001228:	628080e7          	jalr	1576(ra) # 8000184c <proc_mapstacks>
}
    8000122c:	8526                	mv	a0,s1
    8000122e:	60e2                	ld	ra,24(sp)
    80001230:	6442                	ld	s0,16(sp)
    80001232:	64a2                	ld	s1,8(sp)
    80001234:	6902                	ld	s2,0(sp)
    80001236:	6105                	addi	sp,sp,32
    80001238:	8082                	ret

000000008000123a <kvminit>:
{
    8000123a:	1141                	addi	sp,sp,-16
    8000123c:	e406                	sd	ra,8(sp)
    8000123e:	e022                	sd	s0,0(sp)
    80001240:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80001242:	00000097          	auipc	ra,0x0
    80001246:	f22080e7          	jalr	-222(ra) # 80001164 <kvmmake>
    8000124a:	00008797          	auipc	a5,0x8
    8000124e:	dca7bb23          	sd	a0,-554(a5) # 80009020 <kernel_pagetable>
}
    80001252:	60a2                	ld	ra,8(sp)
    80001254:	6402                	ld	s0,0(sp)
    80001256:	0141                	addi	sp,sp,16
    80001258:	8082                	ret

000000008000125a <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000125a:	715d                	addi	sp,sp,-80
    8000125c:	e486                	sd	ra,72(sp)
    8000125e:	e0a2                	sd	s0,64(sp)
    80001260:	fc26                	sd	s1,56(sp)
    80001262:	f84a                	sd	s2,48(sp)
    80001264:	f44e                	sd	s3,40(sp)
    80001266:	f052                	sd	s4,32(sp)
    80001268:	ec56                	sd	s5,24(sp)
    8000126a:	e85a                	sd	s6,16(sp)
    8000126c:	e45e                	sd	s7,8(sp)
    8000126e:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80001270:	03459793          	slli	a5,a1,0x34
    80001274:	e795                	bnez	a5,800012a0 <uvmunmap+0x46>
    80001276:	8a2a                	mv	s4,a0
    80001278:	892e                	mv	s2,a1
    8000127a:	8b36                	mv	s6,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000127c:	0632                	slli	a2,a2,0xc
    8000127e:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      // panic("uvmunmap: not mapped");
      continue;
    if(PTE_FLAGS(*pte) == PTE_V)
    80001282:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001284:	6a85                	lui	s5,0x1
    80001286:	0735e163          	bltu	a1,s3,800012e8 <uvmunmap+0x8e>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    8000128a:	60a6                	ld	ra,72(sp)
    8000128c:	6406                	ld	s0,64(sp)
    8000128e:	74e2                	ld	s1,56(sp)
    80001290:	7942                	ld	s2,48(sp)
    80001292:	79a2                	ld	s3,40(sp)
    80001294:	7a02                	ld	s4,32(sp)
    80001296:	6ae2                	ld	s5,24(sp)
    80001298:	6b42                	ld	s6,16(sp)
    8000129a:	6ba2                	ld	s7,8(sp)
    8000129c:	6161                	addi	sp,sp,80
    8000129e:	8082                	ret
    panic("uvmunmap: not aligned");
    800012a0:	00007517          	auipc	a0,0x7
    800012a4:	e4850513          	addi	a0,a0,-440 # 800080e8 <digits+0xa8>
    800012a8:	fffff097          	auipc	ra,0xfffff
    800012ac:	288080e7          	jalr	648(ra) # 80000530 <panic>
      panic("uvmunmap: walk");
    800012b0:	00007517          	auipc	a0,0x7
    800012b4:	e5050513          	addi	a0,a0,-432 # 80008100 <digits+0xc0>
    800012b8:	fffff097          	auipc	ra,0xfffff
    800012bc:	278080e7          	jalr	632(ra) # 80000530 <panic>
      panic("uvmunmap: not a leaf");
    800012c0:	00007517          	auipc	a0,0x7
    800012c4:	e5050513          	addi	a0,a0,-432 # 80008110 <digits+0xd0>
    800012c8:	fffff097          	auipc	ra,0xfffff
    800012cc:	268080e7          	jalr	616(ra) # 80000530 <panic>
      uint64 pa = PTE2PA(*pte);
    800012d0:	83a9                	srli	a5,a5,0xa
      kfree((void*)pa);
    800012d2:	00c79513          	slli	a0,a5,0xc
    800012d6:	fffff097          	auipc	ra,0xfffff
    800012da:	714080e7          	jalr	1812(ra) # 800009ea <kfree>
    *pte = 0;
    800012de:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800012e2:	9956                	add	s2,s2,s5
    800012e4:	fb3973e3          	bgeu	s2,s3,8000128a <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800012e8:	4601                	li	a2,0
    800012ea:	85ca                	mv	a1,s2
    800012ec:	8552                	mv	a0,s4
    800012ee:	00000097          	auipc	ra,0x0
    800012f2:	cd0080e7          	jalr	-816(ra) # 80000fbe <walk>
    800012f6:	84aa                	mv	s1,a0
    800012f8:	dd45                	beqz	a0,800012b0 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800012fa:	611c                	ld	a5,0(a0)
    800012fc:	0017f713          	andi	a4,a5,1
    80001300:	d36d                	beqz	a4,800012e2 <uvmunmap+0x88>
    if(PTE_FLAGS(*pte) == PTE_V)
    80001302:	3ff7f713          	andi	a4,a5,1023
    80001306:	fb770de3          	beq	a4,s7,800012c0 <uvmunmap+0x66>
    if(do_free){
    8000130a:	fc0b0ae3          	beqz	s6,800012de <uvmunmap+0x84>
    8000130e:	b7c9                	j	800012d0 <uvmunmap+0x76>

0000000080001310 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80001310:	1101                	addi	sp,sp,-32
    80001312:	ec06                	sd	ra,24(sp)
    80001314:	e822                	sd	s0,16(sp)
    80001316:	e426                	sd	s1,8(sp)
    80001318:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    8000131a:	fffff097          	auipc	ra,0xfffff
    8000131e:	7cc080e7          	jalr	1996(ra) # 80000ae6 <kalloc>
    80001322:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001324:	c519                	beqz	a0,80001332 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80001326:	6605                	lui	a2,0x1
    80001328:	4581                	li	a1,0
    8000132a:	00000097          	auipc	ra,0x0
    8000132e:	9a8080e7          	jalr	-1624(ra) # 80000cd2 <memset>
  return pagetable;
}
    80001332:	8526                	mv	a0,s1
    80001334:	60e2                	ld	ra,24(sp)
    80001336:	6442                	ld	s0,16(sp)
    80001338:	64a2                	ld	s1,8(sp)
    8000133a:	6105                	addi	sp,sp,32
    8000133c:	8082                	ret

000000008000133e <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    8000133e:	7179                	addi	sp,sp,-48
    80001340:	f406                	sd	ra,40(sp)
    80001342:	f022                	sd	s0,32(sp)
    80001344:	ec26                	sd	s1,24(sp)
    80001346:	e84a                	sd	s2,16(sp)
    80001348:	e44e                	sd	s3,8(sp)
    8000134a:	e052                	sd	s4,0(sp)
    8000134c:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000134e:	6785                	lui	a5,0x1
    80001350:	04f67863          	bgeu	a2,a5,800013a0 <uvminit+0x62>
    80001354:	8a2a                	mv	s4,a0
    80001356:	89ae                	mv	s3,a1
    80001358:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    8000135a:	fffff097          	auipc	ra,0xfffff
    8000135e:	78c080e7          	jalr	1932(ra) # 80000ae6 <kalloc>
    80001362:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80001364:	6605                	lui	a2,0x1
    80001366:	4581                	li	a1,0
    80001368:	00000097          	auipc	ra,0x0
    8000136c:	96a080e7          	jalr	-1686(ra) # 80000cd2 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80001370:	4779                	li	a4,30
    80001372:	86ca                	mv	a3,s2
    80001374:	6605                	lui	a2,0x1
    80001376:	4581                	li	a1,0
    80001378:	8552                	mv	a0,s4
    8000137a:	00000097          	auipc	ra,0x0
    8000137e:	d2c080e7          	jalr	-724(ra) # 800010a6 <mappages>
  memmove(mem, src, sz);
    80001382:	8626                	mv	a2,s1
    80001384:	85ce                	mv	a1,s3
    80001386:	854a                	mv	a0,s2
    80001388:	00000097          	auipc	ra,0x0
    8000138c:	9aa080e7          	jalr	-1622(ra) # 80000d32 <memmove>
}
    80001390:	70a2                	ld	ra,40(sp)
    80001392:	7402                	ld	s0,32(sp)
    80001394:	64e2                	ld	s1,24(sp)
    80001396:	6942                	ld	s2,16(sp)
    80001398:	69a2                	ld	s3,8(sp)
    8000139a:	6a02                	ld	s4,0(sp)
    8000139c:	6145                	addi	sp,sp,48
    8000139e:	8082                	ret
    panic("inituvm: more than a page");
    800013a0:	00007517          	auipc	a0,0x7
    800013a4:	d8850513          	addi	a0,a0,-632 # 80008128 <digits+0xe8>
    800013a8:	fffff097          	auipc	ra,0xfffff
    800013ac:	188080e7          	jalr	392(ra) # 80000530 <panic>

00000000800013b0 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800013b0:	1101                	addi	sp,sp,-32
    800013b2:	ec06                	sd	ra,24(sp)
    800013b4:	e822                	sd	s0,16(sp)
    800013b6:	e426                	sd	s1,8(sp)
    800013b8:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800013ba:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800013bc:	00b67d63          	bgeu	a2,a1,800013d6 <uvmdealloc+0x26>
    800013c0:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800013c2:	6785                	lui	a5,0x1
    800013c4:	17fd                	addi	a5,a5,-1
    800013c6:	00f60733          	add	a4,a2,a5
    800013ca:	767d                	lui	a2,0xfffff
    800013cc:	8f71                	and	a4,a4,a2
    800013ce:	97ae                	add	a5,a5,a1
    800013d0:	8ff1                	and	a5,a5,a2
    800013d2:	00f76863          	bltu	a4,a5,800013e2 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800013d6:	8526                	mv	a0,s1
    800013d8:	60e2                	ld	ra,24(sp)
    800013da:	6442                	ld	s0,16(sp)
    800013dc:	64a2                	ld	s1,8(sp)
    800013de:	6105                	addi	sp,sp,32
    800013e0:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800013e2:	8f99                	sub	a5,a5,a4
    800013e4:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800013e6:	4685                	li	a3,1
    800013e8:	0007861b          	sext.w	a2,a5
    800013ec:	85ba                	mv	a1,a4
    800013ee:	00000097          	auipc	ra,0x0
    800013f2:	e6c080e7          	jalr	-404(ra) # 8000125a <uvmunmap>
    800013f6:	b7c5                	j	800013d6 <uvmdealloc+0x26>

00000000800013f8 <uvmalloc>:
  if(newsz < oldsz)
    800013f8:	0ab66163          	bltu	a2,a1,8000149a <uvmalloc+0xa2>
{
    800013fc:	7139                	addi	sp,sp,-64
    800013fe:	fc06                	sd	ra,56(sp)
    80001400:	f822                	sd	s0,48(sp)
    80001402:	f426                	sd	s1,40(sp)
    80001404:	f04a                	sd	s2,32(sp)
    80001406:	ec4e                	sd	s3,24(sp)
    80001408:	e852                	sd	s4,16(sp)
    8000140a:	e456                	sd	s5,8(sp)
    8000140c:	0080                	addi	s0,sp,64
    8000140e:	8aaa                	mv	s5,a0
    80001410:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80001412:	6985                	lui	s3,0x1
    80001414:	19fd                	addi	s3,s3,-1
    80001416:	95ce                	add	a1,a1,s3
    80001418:	79fd                	lui	s3,0xfffff
    8000141a:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000141e:	08c9f063          	bgeu	s3,a2,8000149e <uvmalloc+0xa6>
    80001422:	894e                	mv	s2,s3
    mem = kalloc();
    80001424:	fffff097          	auipc	ra,0xfffff
    80001428:	6c2080e7          	jalr	1730(ra) # 80000ae6 <kalloc>
    8000142c:	84aa                	mv	s1,a0
    if(mem == 0){
    8000142e:	c51d                	beqz	a0,8000145c <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    80001430:	6605                	lui	a2,0x1
    80001432:	4581                	li	a1,0
    80001434:	00000097          	auipc	ra,0x0
    80001438:	89e080e7          	jalr	-1890(ra) # 80000cd2 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    8000143c:	4779                	li	a4,30
    8000143e:	86a6                	mv	a3,s1
    80001440:	6605                	lui	a2,0x1
    80001442:	85ca                	mv	a1,s2
    80001444:	8556                	mv	a0,s5
    80001446:	00000097          	auipc	ra,0x0
    8000144a:	c60080e7          	jalr	-928(ra) # 800010a6 <mappages>
    8000144e:	e905                	bnez	a0,8000147e <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001450:	6785                	lui	a5,0x1
    80001452:	993e                	add	s2,s2,a5
    80001454:	fd4968e3          	bltu	s2,s4,80001424 <uvmalloc+0x2c>
  return newsz;
    80001458:	8552                	mv	a0,s4
    8000145a:	a809                	j	8000146c <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    8000145c:	864e                	mv	a2,s3
    8000145e:	85ca                	mv	a1,s2
    80001460:	8556                	mv	a0,s5
    80001462:	00000097          	auipc	ra,0x0
    80001466:	f4e080e7          	jalr	-178(ra) # 800013b0 <uvmdealloc>
      return 0;
    8000146a:	4501                	li	a0,0
}
    8000146c:	70e2                	ld	ra,56(sp)
    8000146e:	7442                	ld	s0,48(sp)
    80001470:	74a2                	ld	s1,40(sp)
    80001472:	7902                	ld	s2,32(sp)
    80001474:	69e2                	ld	s3,24(sp)
    80001476:	6a42                	ld	s4,16(sp)
    80001478:	6aa2                	ld	s5,8(sp)
    8000147a:	6121                	addi	sp,sp,64
    8000147c:	8082                	ret
      kfree(mem);
    8000147e:	8526                	mv	a0,s1
    80001480:	fffff097          	auipc	ra,0xfffff
    80001484:	56a080e7          	jalr	1386(ra) # 800009ea <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80001488:	864e                	mv	a2,s3
    8000148a:	85ca                	mv	a1,s2
    8000148c:	8556                	mv	a0,s5
    8000148e:	00000097          	auipc	ra,0x0
    80001492:	f22080e7          	jalr	-222(ra) # 800013b0 <uvmdealloc>
      return 0;
    80001496:	4501                	li	a0,0
    80001498:	bfd1                	j	8000146c <uvmalloc+0x74>
    return oldsz;
    8000149a:	852e                	mv	a0,a1
}
    8000149c:	8082                	ret
  return newsz;
    8000149e:	8532                	mv	a0,a2
    800014a0:	b7f1                	j	8000146c <uvmalloc+0x74>

00000000800014a2 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800014a2:	7179                	addi	sp,sp,-48
    800014a4:	f406                	sd	ra,40(sp)
    800014a6:	f022                	sd	s0,32(sp)
    800014a8:	ec26                	sd	s1,24(sp)
    800014aa:	e84a                	sd	s2,16(sp)
    800014ac:	e44e                	sd	s3,8(sp)
    800014ae:	e052                	sd	s4,0(sp)
    800014b0:	1800                	addi	s0,sp,48
    800014b2:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800014b4:	84aa                	mv	s1,a0
    800014b6:	6905                	lui	s2,0x1
    800014b8:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800014ba:	4985                	li	s3,1
    800014bc:	a821                	j	800014d4 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800014be:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    800014c0:	0532                	slli	a0,a0,0xc
    800014c2:	00000097          	auipc	ra,0x0
    800014c6:	fe0080e7          	jalr	-32(ra) # 800014a2 <freewalk>
      pagetable[i] = 0;
    800014ca:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800014ce:	04a1                	addi	s1,s1,8
    800014d0:	03248163          	beq	s1,s2,800014f2 <freewalk+0x50>
    pte_t pte = pagetable[i];
    800014d4:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800014d6:	00f57793          	andi	a5,a0,15
    800014da:	ff3782e3          	beq	a5,s3,800014be <freewalk+0x1c>
    } else if(pte & PTE_V){
    800014de:	8905                	andi	a0,a0,1
    800014e0:	d57d                	beqz	a0,800014ce <freewalk+0x2c>
      panic("freewalk: leaf");
    800014e2:	00007517          	auipc	a0,0x7
    800014e6:	c6650513          	addi	a0,a0,-922 # 80008148 <digits+0x108>
    800014ea:	fffff097          	auipc	ra,0xfffff
    800014ee:	046080e7          	jalr	70(ra) # 80000530 <panic>
    }
  }
  kfree((void*)pagetable);
    800014f2:	8552                	mv	a0,s4
    800014f4:	fffff097          	auipc	ra,0xfffff
    800014f8:	4f6080e7          	jalr	1270(ra) # 800009ea <kfree>
}
    800014fc:	70a2                	ld	ra,40(sp)
    800014fe:	7402                	ld	s0,32(sp)
    80001500:	64e2                	ld	s1,24(sp)
    80001502:	6942                	ld	s2,16(sp)
    80001504:	69a2                	ld	s3,8(sp)
    80001506:	6a02                	ld	s4,0(sp)
    80001508:	6145                	addi	sp,sp,48
    8000150a:	8082                	ret

000000008000150c <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    8000150c:	1101                	addi	sp,sp,-32
    8000150e:	ec06                	sd	ra,24(sp)
    80001510:	e822                	sd	s0,16(sp)
    80001512:	e426                	sd	s1,8(sp)
    80001514:	1000                	addi	s0,sp,32
    80001516:	84aa                	mv	s1,a0
  if(sz > 0)
    80001518:	e999                	bnez	a1,8000152e <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    8000151a:	8526                	mv	a0,s1
    8000151c:	00000097          	auipc	ra,0x0
    80001520:	f86080e7          	jalr	-122(ra) # 800014a2 <freewalk>
}
    80001524:	60e2                	ld	ra,24(sp)
    80001526:	6442                	ld	s0,16(sp)
    80001528:	64a2                	ld	s1,8(sp)
    8000152a:	6105                	addi	sp,sp,32
    8000152c:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    8000152e:	6605                	lui	a2,0x1
    80001530:	167d                	addi	a2,a2,-1
    80001532:	962e                	add	a2,a2,a1
    80001534:	4685                	li	a3,1
    80001536:	8231                	srli	a2,a2,0xc
    80001538:	4581                	li	a1,0
    8000153a:	00000097          	auipc	ra,0x0
    8000153e:	d20080e7          	jalr	-736(ra) # 8000125a <uvmunmap>
    80001542:	bfe1                	j	8000151a <uvmfree+0xe>

0000000080001544 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80001544:	c269                	beqz	a2,80001606 <uvmcopy+0xc2>
{
    80001546:	715d                	addi	sp,sp,-80
    80001548:	e486                	sd	ra,72(sp)
    8000154a:	e0a2                	sd	s0,64(sp)
    8000154c:	fc26                	sd	s1,56(sp)
    8000154e:	f84a                	sd	s2,48(sp)
    80001550:	f44e                	sd	s3,40(sp)
    80001552:	f052                	sd	s4,32(sp)
    80001554:	ec56                	sd	s5,24(sp)
    80001556:	e85a                	sd	s6,16(sp)
    80001558:	e45e                	sd	s7,8(sp)
    8000155a:	0880                	addi	s0,sp,80
    8000155c:	8aaa                	mv	s5,a0
    8000155e:	8b2e                	mv	s6,a1
    80001560:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80001562:	4481                	li	s1,0
    80001564:	a829                	j	8000157e <uvmcopy+0x3a>
    if((pte = walk(old, i, 0)) == 0)
      panic("uvmcopy: pte should exist");
    80001566:	00007517          	auipc	a0,0x7
    8000156a:	bf250513          	addi	a0,a0,-1038 # 80008158 <digits+0x118>
    8000156e:	fffff097          	auipc	ra,0xfffff
    80001572:	fc2080e7          	jalr	-62(ra) # 80000530 <panic>
  for(i = 0; i < sz; i += PGSIZE){
    80001576:	6785                	lui	a5,0x1
    80001578:	94be                	add	s1,s1,a5
    8000157a:	0944f463          	bgeu	s1,s4,80001602 <uvmcopy+0xbe>
    if((pte = walk(old, i, 0)) == 0)
    8000157e:	4601                	li	a2,0
    80001580:	85a6                	mv	a1,s1
    80001582:	8556                	mv	a0,s5
    80001584:	00000097          	auipc	ra,0x0
    80001588:	a3a080e7          	jalr	-1478(ra) # 80000fbe <walk>
    8000158c:	dd69                	beqz	a0,80001566 <uvmcopy+0x22>
    if((*pte & PTE_V) == 0)
    8000158e:	6118                	ld	a4,0(a0)
    80001590:	00177793          	andi	a5,a4,1
    80001594:	d3ed                	beqz	a5,80001576 <uvmcopy+0x32>
    // panic("uvmcopy: page not present");
      continue;
    pa = PTE2PA(*pte);
    80001596:	00a75593          	srli	a1,a4,0xa
    8000159a:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    8000159e:	3ff77913          	andi	s2,a4,1023
    if((mem = kalloc()) == 0)
    800015a2:	fffff097          	auipc	ra,0xfffff
    800015a6:	544080e7          	jalr	1348(ra) # 80000ae6 <kalloc>
    800015aa:	89aa                	mv	s3,a0
    800015ac:	c515                	beqz	a0,800015d8 <uvmcopy+0x94>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    800015ae:	6605                	lui	a2,0x1
    800015b0:	85de                	mv	a1,s7
    800015b2:	fffff097          	auipc	ra,0xfffff
    800015b6:	780080e7          	jalr	1920(ra) # 80000d32 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    800015ba:	874a                	mv	a4,s2
    800015bc:	86ce                	mv	a3,s3
    800015be:	6605                	lui	a2,0x1
    800015c0:	85a6                	mv	a1,s1
    800015c2:	855a                	mv	a0,s6
    800015c4:	00000097          	auipc	ra,0x0
    800015c8:	ae2080e7          	jalr	-1310(ra) # 800010a6 <mappages>
    800015cc:	d54d                	beqz	a0,80001576 <uvmcopy+0x32>
      kfree(mem);
    800015ce:	854e                	mv	a0,s3
    800015d0:	fffff097          	auipc	ra,0xfffff
    800015d4:	41a080e7          	jalr	1050(ra) # 800009ea <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800015d8:	4685                	li	a3,1
    800015da:	00c4d613          	srli	a2,s1,0xc
    800015de:	4581                	li	a1,0
    800015e0:	855a                	mv	a0,s6
    800015e2:	00000097          	auipc	ra,0x0
    800015e6:	c78080e7          	jalr	-904(ra) # 8000125a <uvmunmap>
  return -1;
    800015ea:	557d                	li	a0,-1
}
    800015ec:	60a6                	ld	ra,72(sp)
    800015ee:	6406                	ld	s0,64(sp)
    800015f0:	74e2                	ld	s1,56(sp)
    800015f2:	7942                	ld	s2,48(sp)
    800015f4:	79a2                	ld	s3,40(sp)
    800015f6:	7a02                	ld	s4,32(sp)
    800015f8:	6ae2                	ld	s5,24(sp)
    800015fa:	6b42                	ld	s6,16(sp)
    800015fc:	6ba2                	ld	s7,8(sp)
    800015fe:	6161                	addi	sp,sp,80
    80001600:	8082                	ret
  return 0;
    80001602:	4501                	li	a0,0
    80001604:	b7e5                	j	800015ec <uvmcopy+0xa8>
    80001606:	4501                	li	a0,0
}
    80001608:	8082                	ret

000000008000160a <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    8000160a:	1141                	addi	sp,sp,-16
    8000160c:	e406                	sd	ra,8(sp)
    8000160e:	e022                	sd	s0,0(sp)
    80001610:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80001612:	4601                	li	a2,0
    80001614:	00000097          	auipc	ra,0x0
    80001618:	9aa080e7          	jalr	-1622(ra) # 80000fbe <walk>
  if(pte == 0)
    8000161c:	c901                	beqz	a0,8000162c <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    8000161e:	611c                	ld	a5,0(a0)
    80001620:	9bbd                	andi	a5,a5,-17
    80001622:	e11c                	sd	a5,0(a0)
}
    80001624:	60a2                	ld	ra,8(sp)
    80001626:	6402                	ld	s0,0(sp)
    80001628:	0141                	addi	sp,sp,16
    8000162a:	8082                	ret
    panic("uvmclear");
    8000162c:	00007517          	auipc	a0,0x7
    80001630:	b4c50513          	addi	a0,a0,-1204 # 80008178 <digits+0x138>
    80001634:	fffff097          	auipc	ra,0xfffff
    80001638:	efc080e7          	jalr	-260(ra) # 80000530 <panic>

000000008000163c <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    8000163c:	c6bd                	beqz	a3,800016aa <copyout+0x6e>
{
    8000163e:	715d                	addi	sp,sp,-80
    80001640:	e486                	sd	ra,72(sp)
    80001642:	e0a2                	sd	s0,64(sp)
    80001644:	fc26                	sd	s1,56(sp)
    80001646:	f84a                	sd	s2,48(sp)
    80001648:	f44e                	sd	s3,40(sp)
    8000164a:	f052                	sd	s4,32(sp)
    8000164c:	ec56                	sd	s5,24(sp)
    8000164e:	e85a                	sd	s6,16(sp)
    80001650:	e45e                	sd	s7,8(sp)
    80001652:	e062                	sd	s8,0(sp)
    80001654:	0880                	addi	s0,sp,80
    80001656:	8b2a                	mv	s6,a0
    80001658:	8c2e                	mv	s8,a1
    8000165a:	8a32                	mv	s4,a2
    8000165c:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    8000165e:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80001660:	6a85                	lui	s5,0x1
    80001662:	a015                	j	80001686 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001664:	9562                	add	a0,a0,s8
    80001666:	0004861b          	sext.w	a2,s1
    8000166a:	85d2                	mv	a1,s4
    8000166c:	41250533          	sub	a0,a0,s2
    80001670:	fffff097          	auipc	ra,0xfffff
    80001674:	6c2080e7          	jalr	1730(ra) # 80000d32 <memmove>

    len -= n;
    80001678:	409989b3          	sub	s3,s3,s1
    src += n;
    8000167c:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    8000167e:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001682:	02098263          	beqz	s3,800016a6 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80001686:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    8000168a:	85ca                	mv	a1,s2
    8000168c:	855a                	mv	a0,s6
    8000168e:	00000097          	auipc	ra,0x0
    80001692:	9d6080e7          	jalr	-1578(ra) # 80001064 <walkaddr>
    if(pa0 == 0)
    80001696:	cd01                	beqz	a0,800016ae <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80001698:	418904b3          	sub	s1,s2,s8
    8000169c:	94d6                	add	s1,s1,s5
    if(n > len)
    8000169e:	fc99f3e3          	bgeu	s3,s1,80001664 <copyout+0x28>
    800016a2:	84ce                	mv	s1,s3
    800016a4:	b7c1                	j	80001664 <copyout+0x28>
  }
  return 0;
    800016a6:	4501                	li	a0,0
    800016a8:	a021                	j	800016b0 <copyout+0x74>
    800016aa:	4501                	li	a0,0
}
    800016ac:	8082                	ret
      return -1;
    800016ae:	557d                	li	a0,-1
}
    800016b0:	60a6                	ld	ra,72(sp)
    800016b2:	6406                	ld	s0,64(sp)
    800016b4:	74e2                	ld	s1,56(sp)
    800016b6:	7942                	ld	s2,48(sp)
    800016b8:	79a2                	ld	s3,40(sp)
    800016ba:	7a02                	ld	s4,32(sp)
    800016bc:	6ae2                	ld	s5,24(sp)
    800016be:	6b42                	ld	s6,16(sp)
    800016c0:	6ba2                	ld	s7,8(sp)
    800016c2:	6c02                	ld	s8,0(sp)
    800016c4:	6161                	addi	sp,sp,80
    800016c6:	8082                	ret

00000000800016c8 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    800016c8:	c6bd                	beqz	a3,80001736 <copyin+0x6e>
{
    800016ca:	715d                	addi	sp,sp,-80
    800016cc:	e486                	sd	ra,72(sp)
    800016ce:	e0a2                	sd	s0,64(sp)
    800016d0:	fc26                	sd	s1,56(sp)
    800016d2:	f84a                	sd	s2,48(sp)
    800016d4:	f44e                	sd	s3,40(sp)
    800016d6:	f052                	sd	s4,32(sp)
    800016d8:	ec56                	sd	s5,24(sp)
    800016da:	e85a                	sd	s6,16(sp)
    800016dc:	e45e                	sd	s7,8(sp)
    800016de:	e062                	sd	s8,0(sp)
    800016e0:	0880                	addi	s0,sp,80
    800016e2:	8b2a                	mv	s6,a0
    800016e4:	8a2e                	mv	s4,a1
    800016e6:	8c32                	mv	s8,a2
    800016e8:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    800016ea:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800016ec:	6a85                	lui	s5,0x1
    800016ee:	a015                	j	80001712 <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    800016f0:	9562                	add	a0,a0,s8
    800016f2:	0004861b          	sext.w	a2,s1
    800016f6:	412505b3          	sub	a1,a0,s2
    800016fa:	8552                	mv	a0,s4
    800016fc:	fffff097          	auipc	ra,0xfffff
    80001700:	636080e7          	jalr	1590(ra) # 80000d32 <memmove>

    len -= n;
    80001704:	409989b3          	sub	s3,s3,s1
    dst += n;
    80001708:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    8000170a:	01590c33          	add	s8,s2,s5
  while(len > 0){
    8000170e:	02098263          	beqz	s3,80001732 <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80001712:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001716:	85ca                	mv	a1,s2
    80001718:	855a                	mv	a0,s6
    8000171a:	00000097          	auipc	ra,0x0
    8000171e:	94a080e7          	jalr	-1718(ra) # 80001064 <walkaddr>
    if(pa0 == 0)
    80001722:	cd01                	beqz	a0,8000173a <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80001724:	418904b3          	sub	s1,s2,s8
    80001728:	94d6                	add	s1,s1,s5
    if(n > len)
    8000172a:	fc99f3e3          	bgeu	s3,s1,800016f0 <copyin+0x28>
    8000172e:	84ce                	mv	s1,s3
    80001730:	b7c1                	j	800016f0 <copyin+0x28>
  }
  return 0;
    80001732:	4501                	li	a0,0
    80001734:	a021                	j	8000173c <copyin+0x74>
    80001736:	4501                	li	a0,0
}
    80001738:	8082                	ret
      return -1;
    8000173a:	557d                	li	a0,-1
}
    8000173c:	60a6                	ld	ra,72(sp)
    8000173e:	6406                	ld	s0,64(sp)
    80001740:	74e2                	ld	s1,56(sp)
    80001742:	7942                	ld	s2,48(sp)
    80001744:	79a2                	ld	s3,40(sp)
    80001746:	7a02                	ld	s4,32(sp)
    80001748:	6ae2                	ld	s5,24(sp)
    8000174a:	6b42                	ld	s6,16(sp)
    8000174c:	6ba2                	ld	s7,8(sp)
    8000174e:	6c02                	ld	s8,0(sp)
    80001750:	6161                	addi	sp,sp,80
    80001752:	8082                	ret

0000000080001754 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80001754:	c6c5                	beqz	a3,800017fc <copyinstr+0xa8>
{
    80001756:	715d                	addi	sp,sp,-80
    80001758:	e486                	sd	ra,72(sp)
    8000175a:	e0a2                	sd	s0,64(sp)
    8000175c:	fc26                	sd	s1,56(sp)
    8000175e:	f84a                	sd	s2,48(sp)
    80001760:	f44e                	sd	s3,40(sp)
    80001762:	f052                	sd	s4,32(sp)
    80001764:	ec56                	sd	s5,24(sp)
    80001766:	e85a                	sd	s6,16(sp)
    80001768:	e45e                	sd	s7,8(sp)
    8000176a:	0880                	addi	s0,sp,80
    8000176c:	8a2a                	mv	s4,a0
    8000176e:	8b2e                	mv	s6,a1
    80001770:	8bb2                	mv	s7,a2
    80001772:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80001774:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001776:	6985                	lui	s3,0x1
    80001778:	a035                	j	800017a4 <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    8000177a:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    8000177e:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80001780:	0017b793          	seqz	a5,a5
    80001784:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80001788:	60a6                	ld	ra,72(sp)
    8000178a:	6406                	ld	s0,64(sp)
    8000178c:	74e2                	ld	s1,56(sp)
    8000178e:	7942                	ld	s2,48(sp)
    80001790:	79a2                	ld	s3,40(sp)
    80001792:	7a02                	ld	s4,32(sp)
    80001794:	6ae2                	ld	s5,24(sp)
    80001796:	6b42                	ld	s6,16(sp)
    80001798:	6ba2                	ld	s7,8(sp)
    8000179a:	6161                	addi	sp,sp,80
    8000179c:	8082                	ret
    srcva = va0 + PGSIZE;
    8000179e:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    800017a2:	c8a9                	beqz	s1,800017f4 <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    800017a4:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    800017a8:	85ca                	mv	a1,s2
    800017aa:	8552                	mv	a0,s4
    800017ac:	00000097          	auipc	ra,0x0
    800017b0:	8b8080e7          	jalr	-1864(ra) # 80001064 <walkaddr>
    if(pa0 == 0)
    800017b4:	c131                	beqz	a0,800017f8 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    800017b6:	41790833          	sub	a6,s2,s7
    800017ba:	984e                	add	a6,a6,s3
    if(n > max)
    800017bc:	0104f363          	bgeu	s1,a6,800017c2 <copyinstr+0x6e>
    800017c0:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    800017c2:	955e                	add	a0,a0,s7
    800017c4:	41250533          	sub	a0,a0,s2
    while(n > 0){
    800017c8:	fc080be3          	beqz	a6,8000179e <copyinstr+0x4a>
    800017cc:	985a                	add	a6,a6,s6
    800017ce:	87da                	mv	a5,s6
      if(*p == '\0'){
    800017d0:	41650633          	sub	a2,a0,s6
    800017d4:	14fd                	addi	s1,s1,-1
    800017d6:	9b26                	add	s6,s6,s1
    800017d8:	00f60733          	add	a4,a2,a5
    800017dc:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffc9000>
    800017e0:	df49                	beqz	a4,8000177a <copyinstr+0x26>
        *dst = *p;
    800017e2:	00e78023          	sb	a4,0(a5)
      --max;
    800017e6:	40fb04b3          	sub	s1,s6,a5
      dst++;
    800017ea:	0785                	addi	a5,a5,1
    while(n > 0){
    800017ec:	ff0796e3          	bne	a5,a6,800017d8 <copyinstr+0x84>
      dst++;
    800017f0:	8b42                	mv	s6,a6
    800017f2:	b775                	j	8000179e <copyinstr+0x4a>
    800017f4:	4781                	li	a5,0
    800017f6:	b769                	j	80001780 <copyinstr+0x2c>
      return -1;
    800017f8:	557d                	li	a0,-1
    800017fa:	b779                	j	80001788 <copyinstr+0x34>
  int got_null = 0;
    800017fc:	4781                	li	a5,0
  if(got_null){
    800017fe:	0017b793          	seqz	a5,a5
    80001802:	40f00533          	neg	a0,a5
}
    80001806:	8082                	ret

0000000080001808 <wakeup1>:

// Wake up p if it is sleeping in wait(); used by exit().
// Caller must hold p->lock.
static void
wakeup1(struct proc *p)
{
    80001808:	1101                	addi	sp,sp,-32
    8000180a:	ec06                	sd	ra,24(sp)
    8000180c:	e822                	sd	s0,16(sp)
    8000180e:	e426                	sd	s1,8(sp)
    80001810:	1000                	addi	s0,sp,32
    80001812:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001814:	fffff097          	auipc	ra,0xfffff
    80001818:	348080e7          	jalr	840(ra) # 80000b5c <holding>
    8000181c:	c909                	beqz	a0,8000182e <wakeup1+0x26>
    panic("wakeup1");
  if(p->chan == p && p->state == SLEEPING) {
    8000181e:	749c                	ld	a5,40(s1)
    80001820:	00978f63          	beq	a5,s1,8000183e <wakeup1+0x36>
    p->state = RUNNABLE;
  }
}
    80001824:	60e2                	ld	ra,24(sp)
    80001826:	6442                	ld	s0,16(sp)
    80001828:	64a2                	ld	s1,8(sp)
    8000182a:	6105                	addi	sp,sp,32
    8000182c:	8082                	ret
    panic("wakeup1");
    8000182e:	00007517          	auipc	a0,0x7
    80001832:	95a50513          	addi	a0,a0,-1702 # 80008188 <digits+0x148>
    80001836:	fffff097          	auipc	ra,0xfffff
    8000183a:	cfa080e7          	jalr	-774(ra) # 80000530 <panic>
  if(p->chan == p && p->state == SLEEPING) {
    8000183e:	4c98                	lw	a4,24(s1)
    80001840:	4785                	li	a5,1
    80001842:	fef711e3          	bne	a4,a5,80001824 <wakeup1+0x1c>
    p->state = RUNNABLE;
    80001846:	4789                	li	a5,2
    80001848:	cc9c                	sw	a5,24(s1)
}
    8000184a:	bfe9                	j	80001824 <wakeup1+0x1c>

000000008000184c <proc_mapstacks>:
proc_mapstacks(pagetable_t kpgtbl) {
    8000184c:	7139                	addi	sp,sp,-64
    8000184e:	fc06                	sd	ra,56(sp)
    80001850:	f822                	sd	s0,48(sp)
    80001852:	f426                	sd	s1,40(sp)
    80001854:	f04a                	sd	s2,32(sp)
    80001856:	ec4e                	sd	s3,24(sp)
    80001858:	e852                	sd	s4,16(sp)
    8000185a:	e456                	sd	s5,8(sp)
    8000185c:	e05a                	sd	s6,0(sp)
    8000185e:	0080                	addi	s0,sp,64
    80001860:	89aa                	mv	s3,a0
  for(p = proc; p < &proc[NPROC]; p++) {
    80001862:	00010497          	auipc	s1,0x10
    80001866:	e5648493          	addi	s1,s1,-426 # 800116b8 <proc>
    uint64 va = KSTACK((int) (p - proc));
    8000186a:	8b26                	mv	s6,s1
    8000186c:	00006a97          	auipc	s5,0x6
    80001870:	794a8a93          	addi	s5,s5,1940 # 80008000 <etext>
    80001874:	04000937          	lui	s2,0x4000
    80001878:	197d                	addi	s2,s2,-1
    8000187a:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    8000187c:	00026a17          	auipc	s4,0x26
    80001880:	83ca0a13          	addi	s4,s4,-1988 # 800270b8 <tickslock>
    char *pa = kalloc();
    80001884:	fffff097          	auipc	ra,0xfffff
    80001888:	262080e7          	jalr	610(ra) # 80000ae6 <kalloc>
    8000188c:	862a                	mv	a2,a0
    if(pa == 0)
    8000188e:	c131                	beqz	a0,800018d2 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80001890:	416485b3          	sub	a1,s1,s6
    80001894:	858d                	srai	a1,a1,0x3
    80001896:	000ab783          	ld	a5,0(s5)
    8000189a:	02f585b3          	mul	a1,a1,a5
    8000189e:	2585                	addiw	a1,a1,1
    800018a0:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800018a4:	4719                	li	a4,6
    800018a6:	6685                	lui	a3,0x1
    800018a8:	40b905b3          	sub	a1,s2,a1
    800018ac:	854e                	mv	a0,s3
    800018ae:	00000097          	auipc	ra,0x0
    800018b2:	886080e7          	jalr	-1914(ra) # 80001134 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    800018b6:	56848493          	addi	s1,s1,1384
    800018ba:	fd4495e3          	bne	s1,s4,80001884 <proc_mapstacks+0x38>
}
    800018be:	70e2                	ld	ra,56(sp)
    800018c0:	7442                	ld	s0,48(sp)
    800018c2:	74a2                	ld	s1,40(sp)
    800018c4:	7902                	ld	s2,32(sp)
    800018c6:	69e2                	ld	s3,24(sp)
    800018c8:	6a42                	ld	s4,16(sp)
    800018ca:	6aa2                	ld	s5,8(sp)
    800018cc:	6b02                	ld	s6,0(sp)
    800018ce:	6121                	addi	sp,sp,64
    800018d0:	8082                	ret
      panic("kalloc");
    800018d2:	00007517          	auipc	a0,0x7
    800018d6:	8be50513          	addi	a0,a0,-1858 # 80008190 <digits+0x150>
    800018da:	fffff097          	auipc	ra,0xfffff
    800018de:	c56080e7          	jalr	-938(ra) # 80000530 <panic>

00000000800018e2 <procinit>:
{
    800018e2:	7139                	addi	sp,sp,-64
    800018e4:	fc06                	sd	ra,56(sp)
    800018e6:	f822                	sd	s0,48(sp)
    800018e8:	f426                	sd	s1,40(sp)
    800018ea:	f04a                	sd	s2,32(sp)
    800018ec:	ec4e                	sd	s3,24(sp)
    800018ee:	e852                	sd	s4,16(sp)
    800018f0:	e456                	sd	s5,8(sp)
    800018f2:	e05a                	sd	s6,0(sp)
    800018f4:	0080                	addi	s0,sp,64
  initlock(&pid_lock, "nextpid");
    800018f6:	00007597          	auipc	a1,0x7
    800018fa:	8a258593          	addi	a1,a1,-1886 # 80008198 <digits+0x158>
    800018fe:	00010517          	auipc	a0,0x10
    80001902:	9a250513          	addi	a0,a0,-1630 # 800112a0 <pid_lock>
    80001906:	fffff097          	auipc	ra,0xfffff
    8000190a:	240080e7          	jalr	576(ra) # 80000b46 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000190e:	00010497          	auipc	s1,0x10
    80001912:	daa48493          	addi	s1,s1,-598 # 800116b8 <proc>
      initlock(&p->lock, "proc");
    80001916:	00007b17          	auipc	s6,0x7
    8000191a:	88ab0b13          	addi	s6,s6,-1910 # 800081a0 <digits+0x160>
      p->kstack = KSTACK((int) (p - proc));
    8000191e:	8aa6                	mv	s5,s1
    80001920:	00006a17          	auipc	s4,0x6
    80001924:	6e0a0a13          	addi	s4,s4,1760 # 80008000 <etext>
    80001928:	04000937          	lui	s2,0x4000
    8000192c:	197d                	addi	s2,s2,-1
    8000192e:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001930:	00025997          	auipc	s3,0x25
    80001934:	78898993          	addi	s3,s3,1928 # 800270b8 <tickslock>
      initlock(&p->lock, "proc");
    80001938:	85da                	mv	a1,s6
    8000193a:	8526                	mv	a0,s1
    8000193c:	fffff097          	auipc	ra,0xfffff
    80001940:	20a080e7          	jalr	522(ra) # 80000b46 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80001944:	415487b3          	sub	a5,s1,s5
    80001948:	878d                	srai	a5,a5,0x3
    8000194a:	000a3703          	ld	a4,0(s4)
    8000194e:	02e787b3          	mul	a5,a5,a4
    80001952:	2785                	addiw	a5,a5,1
    80001954:	00d7979b          	slliw	a5,a5,0xd
    80001958:	40f907b3          	sub	a5,s2,a5
    8000195c:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    8000195e:	56848493          	addi	s1,s1,1384
    80001962:	fd349be3          	bne	s1,s3,80001938 <procinit+0x56>
}
    80001966:	70e2                	ld	ra,56(sp)
    80001968:	7442                	ld	s0,48(sp)
    8000196a:	74a2                	ld	s1,40(sp)
    8000196c:	7902                	ld	s2,32(sp)
    8000196e:	69e2                	ld	s3,24(sp)
    80001970:	6a42                	ld	s4,16(sp)
    80001972:	6aa2                	ld	s5,8(sp)
    80001974:	6b02                	ld	s6,0(sp)
    80001976:	6121                	addi	sp,sp,64
    80001978:	8082                	ret

000000008000197a <cpuid>:
{
    8000197a:	1141                	addi	sp,sp,-16
    8000197c:	e422                	sd	s0,8(sp)
    8000197e:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001980:	8512                	mv	a0,tp
}
    80001982:	2501                	sext.w	a0,a0
    80001984:	6422                	ld	s0,8(sp)
    80001986:	0141                	addi	sp,sp,16
    80001988:	8082                	ret

000000008000198a <mycpu>:
mycpu(void) {
    8000198a:	1141                	addi	sp,sp,-16
    8000198c:	e422                	sd	s0,8(sp)
    8000198e:	0800                	addi	s0,sp,16
    80001990:	8792                	mv	a5,tp
  struct cpu *c = &cpus[id];
    80001992:	2781                	sext.w	a5,a5
    80001994:	079e                	slli	a5,a5,0x7
}
    80001996:	00010517          	auipc	a0,0x10
    8000199a:	92250513          	addi	a0,a0,-1758 # 800112b8 <cpus>
    8000199e:	953e                	add	a0,a0,a5
    800019a0:	6422                	ld	s0,8(sp)
    800019a2:	0141                	addi	sp,sp,16
    800019a4:	8082                	ret

00000000800019a6 <myproc>:
myproc(void) {
    800019a6:	1101                	addi	sp,sp,-32
    800019a8:	ec06                	sd	ra,24(sp)
    800019aa:	e822                	sd	s0,16(sp)
    800019ac:	e426                	sd	s1,8(sp)
    800019ae:	1000                	addi	s0,sp,32
  push_off();
    800019b0:	fffff097          	auipc	ra,0xfffff
    800019b4:	1da080e7          	jalr	474(ra) # 80000b8a <push_off>
    800019b8:	8792                	mv	a5,tp
  struct proc *p = c->proc;
    800019ba:	2781                	sext.w	a5,a5
    800019bc:	079e                	slli	a5,a5,0x7
    800019be:	00010717          	auipc	a4,0x10
    800019c2:	8e270713          	addi	a4,a4,-1822 # 800112a0 <pid_lock>
    800019c6:	97ba                	add	a5,a5,a4
    800019c8:	6f84                	ld	s1,24(a5)
  pop_off();
    800019ca:	fffff097          	auipc	ra,0xfffff
    800019ce:	260080e7          	jalr	608(ra) # 80000c2a <pop_off>
}
    800019d2:	8526                	mv	a0,s1
    800019d4:	60e2                	ld	ra,24(sp)
    800019d6:	6442                	ld	s0,16(sp)
    800019d8:	64a2                	ld	s1,8(sp)
    800019da:	6105                	addi	sp,sp,32
    800019dc:	8082                	ret

00000000800019de <forkret>:
{
    800019de:	1141                	addi	sp,sp,-16
    800019e0:	e406                	sd	ra,8(sp)
    800019e2:	e022                	sd	s0,0(sp)
    800019e4:	0800                	addi	s0,sp,16
  release(&myproc()->lock);
    800019e6:	00000097          	auipc	ra,0x0
    800019ea:	fc0080e7          	jalr	-64(ra) # 800019a6 <myproc>
    800019ee:	fffff097          	auipc	ra,0xfffff
    800019f2:	29c080e7          	jalr	668(ra) # 80000c8a <release>
  if (first) {
    800019f6:	00007797          	auipc	a5,0x7
    800019fa:	e3a7a783          	lw	a5,-454(a5) # 80008830 <first.1745>
    800019fe:	eb89                	bnez	a5,80001a10 <forkret+0x32>
  usertrapret();
    80001a00:	00001097          	auipc	ra,0x1
    80001a04:	cd4080e7          	jalr	-812(ra) # 800026d4 <usertrapret>
}
    80001a08:	60a2                	ld	ra,8(sp)
    80001a0a:	6402                	ld	s0,0(sp)
    80001a0c:	0141                	addi	sp,sp,16
    80001a0e:	8082                	ret
    first = 0;
    80001a10:	00007797          	auipc	a5,0x7
    80001a14:	e207a023          	sw	zero,-480(a5) # 80008830 <first.1745>
    fsinit(ROOTDEV);
    80001a18:	4505                	li	a0,1
    80001a1a:	00002097          	auipc	ra,0x2
    80001a1e:	b5c080e7          	jalr	-1188(ra) # 80003576 <fsinit>
    80001a22:	bff9                	j	80001a00 <forkret+0x22>

0000000080001a24 <allocpid>:
allocpid() {
    80001a24:	1101                	addi	sp,sp,-32
    80001a26:	ec06                	sd	ra,24(sp)
    80001a28:	e822                	sd	s0,16(sp)
    80001a2a:	e426                	sd	s1,8(sp)
    80001a2c:	e04a                	sd	s2,0(sp)
    80001a2e:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001a30:	00010917          	auipc	s2,0x10
    80001a34:	87090913          	addi	s2,s2,-1936 # 800112a0 <pid_lock>
    80001a38:	854a                	mv	a0,s2
    80001a3a:	fffff097          	auipc	ra,0xfffff
    80001a3e:	19c080e7          	jalr	412(ra) # 80000bd6 <acquire>
  pid = nextpid;
    80001a42:	00007797          	auipc	a5,0x7
    80001a46:	df278793          	addi	a5,a5,-526 # 80008834 <nextpid>
    80001a4a:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001a4c:	0014871b          	addiw	a4,s1,1
    80001a50:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001a52:	854a                	mv	a0,s2
    80001a54:	fffff097          	auipc	ra,0xfffff
    80001a58:	236080e7          	jalr	566(ra) # 80000c8a <release>
}
    80001a5c:	8526                	mv	a0,s1
    80001a5e:	60e2                	ld	ra,24(sp)
    80001a60:	6442                	ld	s0,16(sp)
    80001a62:	64a2                	ld	s1,8(sp)
    80001a64:	6902                	ld	s2,0(sp)
    80001a66:	6105                	addi	sp,sp,32
    80001a68:	8082                	ret

0000000080001a6a <proc_pagetable>:
{
    80001a6a:	1101                	addi	sp,sp,-32
    80001a6c:	ec06                	sd	ra,24(sp)
    80001a6e:	e822                	sd	s0,16(sp)
    80001a70:	e426                	sd	s1,8(sp)
    80001a72:	e04a                	sd	s2,0(sp)
    80001a74:	1000                	addi	s0,sp,32
    80001a76:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001a78:	00000097          	auipc	ra,0x0
    80001a7c:	898080e7          	jalr	-1896(ra) # 80001310 <uvmcreate>
    80001a80:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001a82:	c121                	beqz	a0,80001ac2 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001a84:	4729                	li	a4,10
    80001a86:	00005697          	auipc	a3,0x5
    80001a8a:	57a68693          	addi	a3,a3,1402 # 80007000 <_trampoline>
    80001a8e:	6605                	lui	a2,0x1
    80001a90:	040005b7          	lui	a1,0x4000
    80001a94:	15fd                	addi	a1,a1,-1
    80001a96:	05b2                	slli	a1,a1,0xc
    80001a98:	fffff097          	auipc	ra,0xfffff
    80001a9c:	60e080e7          	jalr	1550(ra) # 800010a6 <mappages>
    80001aa0:	02054863          	bltz	a0,80001ad0 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001aa4:	4719                	li	a4,6
    80001aa6:	05893683          	ld	a3,88(s2)
    80001aaa:	6605                	lui	a2,0x1
    80001aac:	020005b7          	lui	a1,0x2000
    80001ab0:	15fd                	addi	a1,a1,-1
    80001ab2:	05b6                	slli	a1,a1,0xd
    80001ab4:	8526                	mv	a0,s1
    80001ab6:	fffff097          	auipc	ra,0xfffff
    80001aba:	5f0080e7          	jalr	1520(ra) # 800010a6 <mappages>
    80001abe:	02054163          	bltz	a0,80001ae0 <proc_pagetable+0x76>
}
    80001ac2:	8526                	mv	a0,s1
    80001ac4:	60e2                	ld	ra,24(sp)
    80001ac6:	6442                	ld	s0,16(sp)
    80001ac8:	64a2                	ld	s1,8(sp)
    80001aca:	6902                	ld	s2,0(sp)
    80001acc:	6105                	addi	sp,sp,32
    80001ace:	8082                	ret
    uvmfree(pagetable, 0);
    80001ad0:	4581                	li	a1,0
    80001ad2:	8526                	mv	a0,s1
    80001ad4:	00000097          	auipc	ra,0x0
    80001ad8:	a38080e7          	jalr	-1480(ra) # 8000150c <uvmfree>
    return 0;
    80001adc:	4481                	li	s1,0
    80001ade:	b7d5                	j	80001ac2 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001ae0:	4681                	li	a3,0
    80001ae2:	4605                	li	a2,1
    80001ae4:	040005b7          	lui	a1,0x4000
    80001ae8:	15fd                	addi	a1,a1,-1
    80001aea:	05b2                	slli	a1,a1,0xc
    80001aec:	8526                	mv	a0,s1
    80001aee:	fffff097          	auipc	ra,0xfffff
    80001af2:	76c080e7          	jalr	1900(ra) # 8000125a <uvmunmap>
    uvmfree(pagetable, 0);
    80001af6:	4581                	li	a1,0
    80001af8:	8526                	mv	a0,s1
    80001afa:	00000097          	auipc	ra,0x0
    80001afe:	a12080e7          	jalr	-1518(ra) # 8000150c <uvmfree>
    return 0;
    80001b02:	4481                	li	s1,0
    80001b04:	bf7d                	j	80001ac2 <proc_pagetable+0x58>

0000000080001b06 <proc_freepagetable>:
{
    80001b06:	1101                	addi	sp,sp,-32
    80001b08:	ec06                	sd	ra,24(sp)
    80001b0a:	e822                	sd	s0,16(sp)
    80001b0c:	e426                	sd	s1,8(sp)
    80001b0e:	e04a                	sd	s2,0(sp)
    80001b10:	1000                	addi	s0,sp,32
    80001b12:	84aa                	mv	s1,a0
    80001b14:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001b16:	4681                	li	a3,0
    80001b18:	4605                	li	a2,1
    80001b1a:	040005b7          	lui	a1,0x4000
    80001b1e:	15fd                	addi	a1,a1,-1
    80001b20:	05b2                	slli	a1,a1,0xc
    80001b22:	fffff097          	auipc	ra,0xfffff
    80001b26:	738080e7          	jalr	1848(ra) # 8000125a <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001b2a:	4681                	li	a3,0
    80001b2c:	4605                	li	a2,1
    80001b2e:	020005b7          	lui	a1,0x2000
    80001b32:	15fd                	addi	a1,a1,-1
    80001b34:	05b6                	slli	a1,a1,0xd
    80001b36:	8526                	mv	a0,s1
    80001b38:	fffff097          	auipc	ra,0xfffff
    80001b3c:	722080e7          	jalr	1826(ra) # 8000125a <uvmunmap>
  uvmfree(pagetable, sz);
    80001b40:	85ca                	mv	a1,s2
    80001b42:	8526                	mv	a0,s1
    80001b44:	00000097          	auipc	ra,0x0
    80001b48:	9c8080e7          	jalr	-1592(ra) # 8000150c <uvmfree>
}
    80001b4c:	60e2                	ld	ra,24(sp)
    80001b4e:	6442                	ld	s0,16(sp)
    80001b50:	64a2                	ld	s1,8(sp)
    80001b52:	6902                	ld	s2,0(sp)
    80001b54:	6105                	addi	sp,sp,32
    80001b56:	8082                	ret

0000000080001b58 <freeproc>:
{
    80001b58:	1101                	addi	sp,sp,-32
    80001b5a:	ec06                	sd	ra,24(sp)
    80001b5c:	e822                	sd	s0,16(sp)
    80001b5e:	e426                	sd	s1,8(sp)
    80001b60:	1000                	addi	s0,sp,32
    80001b62:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001b64:	6d28                	ld	a0,88(a0)
    80001b66:	c509                	beqz	a0,80001b70 <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001b68:	fffff097          	auipc	ra,0xfffff
    80001b6c:	e82080e7          	jalr	-382(ra) # 800009ea <kfree>
  p->trapframe = 0;
    80001b70:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001b74:	68a8                	ld	a0,80(s1)
    80001b76:	c511                	beqz	a0,80001b82 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001b78:	64ac                	ld	a1,72(s1)
    80001b7a:	00000097          	auipc	ra,0x0
    80001b7e:	f8c080e7          	jalr	-116(ra) # 80001b06 <proc_freepagetable>
  p->pagetable = 0;
    80001b82:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001b86:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001b8a:	0204ac23          	sw	zero,56(s1)
  p->parent = 0;
    80001b8e:	0204b023          	sd	zero,32(s1)
  p->name[0] = 0;
    80001b92:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001b96:	0204b423          	sd	zero,40(s1)
  p->killed = 0;
    80001b9a:	0204a823          	sw	zero,48(s1)
  p->xstate = 0;
    80001b9e:	0204aa23          	sw	zero,52(s1)
  p->state = UNUSED;
    80001ba2:	0004ac23          	sw	zero,24(s1)
}
    80001ba6:	60e2                	ld	ra,24(sp)
    80001ba8:	6442                	ld	s0,16(sp)
    80001baa:	64a2                	ld	s1,8(sp)
    80001bac:	6105                	addi	sp,sp,32
    80001bae:	8082                	ret

0000000080001bb0 <allocproc>:
{
    80001bb0:	1101                	addi	sp,sp,-32
    80001bb2:	ec06                	sd	ra,24(sp)
    80001bb4:	e822                	sd	s0,16(sp)
    80001bb6:	e426                	sd	s1,8(sp)
    80001bb8:	e04a                	sd	s2,0(sp)
    80001bba:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001bbc:	00010497          	auipc	s1,0x10
    80001bc0:	afc48493          	addi	s1,s1,-1284 # 800116b8 <proc>
    80001bc4:	00025917          	auipc	s2,0x25
    80001bc8:	4f490913          	addi	s2,s2,1268 # 800270b8 <tickslock>
    acquire(&p->lock);
    80001bcc:	8526                	mv	a0,s1
    80001bce:	fffff097          	auipc	ra,0xfffff
    80001bd2:	008080e7          	jalr	8(ra) # 80000bd6 <acquire>
    if(p->state == UNUSED) {
    80001bd6:	4c9c                	lw	a5,24(s1)
    80001bd8:	cf81                	beqz	a5,80001bf0 <allocproc+0x40>
      release(&p->lock);
    80001bda:	8526                	mv	a0,s1
    80001bdc:	fffff097          	auipc	ra,0xfffff
    80001be0:	0ae080e7          	jalr	174(ra) # 80000c8a <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001be4:	56848493          	addi	s1,s1,1384
    80001be8:	ff2492e3          	bne	s1,s2,80001bcc <allocproc+0x1c>
  return 0;
    80001bec:	4481                	li	s1,0
    80001bee:	a0b9                	j	80001c3c <allocproc+0x8c>
  p->pid = allocpid();
    80001bf0:	00000097          	auipc	ra,0x0
    80001bf4:	e34080e7          	jalr	-460(ra) # 80001a24 <allocpid>
    80001bf8:	dc88                	sw	a0,56(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001bfa:	fffff097          	auipc	ra,0xfffff
    80001bfe:	eec080e7          	jalr	-276(ra) # 80000ae6 <kalloc>
    80001c02:	892a                	mv	s2,a0
    80001c04:	eca8                	sd	a0,88(s1)
    80001c06:	c131                	beqz	a0,80001c4a <allocproc+0x9a>
  p->pagetable = proc_pagetable(p);
    80001c08:	8526                	mv	a0,s1
    80001c0a:	00000097          	auipc	ra,0x0
    80001c0e:	e60080e7          	jalr	-416(ra) # 80001a6a <proc_pagetable>
    80001c12:	892a                	mv	s2,a0
    80001c14:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001c16:	c129                	beqz	a0,80001c58 <allocproc+0xa8>
  memset(&p->context, 0, sizeof(p->context));
    80001c18:	07000613          	li	a2,112
    80001c1c:	4581                	li	a1,0
    80001c1e:	06048513          	addi	a0,s1,96
    80001c22:	fffff097          	auipc	ra,0xfffff
    80001c26:	0b0080e7          	jalr	176(ra) # 80000cd2 <memset>
  p->context.ra = (uint64)forkret;
    80001c2a:	00000797          	auipc	a5,0x0
    80001c2e:	db478793          	addi	a5,a5,-588 # 800019de <forkret>
    80001c32:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001c34:	60bc                	ld	a5,64(s1)
    80001c36:	6705                	lui	a4,0x1
    80001c38:	97ba                	add	a5,a5,a4
    80001c3a:	f4bc                	sd	a5,104(s1)
}
    80001c3c:	8526                	mv	a0,s1
    80001c3e:	60e2                	ld	ra,24(sp)
    80001c40:	6442                	ld	s0,16(sp)
    80001c42:	64a2                	ld	s1,8(sp)
    80001c44:	6902                	ld	s2,0(sp)
    80001c46:	6105                	addi	sp,sp,32
    80001c48:	8082                	ret
    release(&p->lock);
    80001c4a:	8526                	mv	a0,s1
    80001c4c:	fffff097          	auipc	ra,0xfffff
    80001c50:	03e080e7          	jalr	62(ra) # 80000c8a <release>
    return 0;
    80001c54:	84ca                	mv	s1,s2
    80001c56:	b7dd                	j	80001c3c <allocproc+0x8c>
    freeproc(p);
    80001c58:	8526                	mv	a0,s1
    80001c5a:	00000097          	auipc	ra,0x0
    80001c5e:	efe080e7          	jalr	-258(ra) # 80001b58 <freeproc>
    release(&p->lock);
    80001c62:	8526                	mv	a0,s1
    80001c64:	fffff097          	auipc	ra,0xfffff
    80001c68:	026080e7          	jalr	38(ra) # 80000c8a <release>
    return 0;
    80001c6c:	84ca                	mv	s1,s2
    80001c6e:	b7f9                	j	80001c3c <allocproc+0x8c>

0000000080001c70 <userinit>:
{
    80001c70:	1101                	addi	sp,sp,-32
    80001c72:	ec06                	sd	ra,24(sp)
    80001c74:	e822                	sd	s0,16(sp)
    80001c76:	e426                	sd	s1,8(sp)
    80001c78:	1000                	addi	s0,sp,32
  p = allocproc();
    80001c7a:	00000097          	auipc	ra,0x0
    80001c7e:	f36080e7          	jalr	-202(ra) # 80001bb0 <allocproc>
    80001c82:	84aa                	mv	s1,a0
  initproc = p;
    80001c84:	00007797          	auipc	a5,0x7
    80001c88:	3aa7b223          	sd	a0,932(a5) # 80009028 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001c8c:	03400613          	li	a2,52
    80001c90:	00007597          	auipc	a1,0x7
    80001c94:	bb058593          	addi	a1,a1,-1104 # 80008840 <initcode>
    80001c98:	6928                	ld	a0,80(a0)
    80001c9a:	fffff097          	auipc	ra,0xfffff
    80001c9e:	6a4080e7          	jalr	1700(ra) # 8000133e <uvminit>
  p->sz = PGSIZE;
    80001ca2:	6785                	lui	a5,0x1
    80001ca4:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001ca6:	6cb8                	ld	a4,88(s1)
    80001ca8:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001cac:	6cb8                	ld	a4,88(s1)
    80001cae:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001cb0:	4641                	li	a2,16
    80001cb2:	00006597          	auipc	a1,0x6
    80001cb6:	4f658593          	addi	a1,a1,1270 # 800081a8 <digits+0x168>
    80001cba:	15848513          	addi	a0,s1,344
    80001cbe:	fffff097          	auipc	ra,0xfffff
    80001cc2:	16a080e7          	jalr	362(ra) # 80000e28 <safestrcpy>
  p->cwd = namei("/");
    80001cc6:	00006517          	auipc	a0,0x6
    80001cca:	4f250513          	addi	a0,a0,1266 # 800081b8 <digits+0x178>
    80001cce:	00002097          	auipc	ra,0x2
    80001cd2:	2d6080e7          	jalr	726(ra) # 80003fa4 <namei>
    80001cd6:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001cda:	4789                	li	a5,2
    80001cdc:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001cde:	8526                	mv	a0,s1
    80001ce0:	fffff097          	auipc	ra,0xfffff
    80001ce4:	faa080e7          	jalr	-86(ra) # 80000c8a <release>
}
    80001ce8:	60e2                	ld	ra,24(sp)
    80001cea:	6442                	ld	s0,16(sp)
    80001cec:	64a2                	ld	s1,8(sp)
    80001cee:	6105                	addi	sp,sp,32
    80001cf0:	8082                	ret

0000000080001cf2 <growproc>:
{
    80001cf2:	1101                	addi	sp,sp,-32
    80001cf4:	ec06                	sd	ra,24(sp)
    80001cf6:	e822                	sd	s0,16(sp)
    80001cf8:	e426                	sd	s1,8(sp)
    80001cfa:	e04a                	sd	s2,0(sp)
    80001cfc:	1000                	addi	s0,sp,32
    80001cfe:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001d00:	00000097          	auipc	ra,0x0
    80001d04:	ca6080e7          	jalr	-858(ra) # 800019a6 <myproc>
    80001d08:	892a                	mv	s2,a0
  sz = p->sz;
    80001d0a:	652c                	ld	a1,72(a0)
    80001d0c:	0005861b          	sext.w	a2,a1
  if(n > 0){
    80001d10:	00904f63          	bgtz	s1,80001d2e <growproc+0x3c>
  } else if(n < 0){
    80001d14:	0204cc63          	bltz	s1,80001d4c <growproc+0x5a>
  p->sz = sz;
    80001d18:	1602                	slli	a2,a2,0x20
    80001d1a:	9201                	srli	a2,a2,0x20
    80001d1c:	04c93423          	sd	a2,72(s2)
  return 0;
    80001d20:	4501                	li	a0,0
}
    80001d22:	60e2                	ld	ra,24(sp)
    80001d24:	6442                	ld	s0,16(sp)
    80001d26:	64a2                	ld	s1,8(sp)
    80001d28:	6902                	ld	s2,0(sp)
    80001d2a:	6105                	addi	sp,sp,32
    80001d2c:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001d2e:	9e25                	addw	a2,a2,s1
    80001d30:	1602                	slli	a2,a2,0x20
    80001d32:	9201                	srli	a2,a2,0x20
    80001d34:	1582                	slli	a1,a1,0x20
    80001d36:	9181                	srli	a1,a1,0x20
    80001d38:	6928                	ld	a0,80(a0)
    80001d3a:	fffff097          	auipc	ra,0xfffff
    80001d3e:	6be080e7          	jalr	1726(ra) # 800013f8 <uvmalloc>
    80001d42:	0005061b          	sext.w	a2,a0
    80001d46:	fa69                	bnez	a2,80001d18 <growproc+0x26>
      return -1;
    80001d48:	557d                	li	a0,-1
    80001d4a:	bfe1                	j	80001d22 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001d4c:	9e25                	addw	a2,a2,s1
    80001d4e:	1602                	slli	a2,a2,0x20
    80001d50:	9201                	srli	a2,a2,0x20
    80001d52:	1582                	slli	a1,a1,0x20
    80001d54:	9181                	srli	a1,a1,0x20
    80001d56:	6928                	ld	a0,80(a0)
    80001d58:	fffff097          	auipc	ra,0xfffff
    80001d5c:	658080e7          	jalr	1624(ra) # 800013b0 <uvmdealloc>
    80001d60:	0005061b          	sext.w	a2,a0
    80001d64:	bf55                	j	80001d18 <growproc+0x26>

0000000080001d66 <fork>:
{
    80001d66:	7139                	addi	sp,sp,-64
    80001d68:	fc06                	sd	ra,56(sp)
    80001d6a:	f822                	sd	s0,48(sp)
    80001d6c:	f426                	sd	s1,40(sp)
    80001d6e:	f04a                	sd	s2,32(sp)
    80001d70:	ec4e                	sd	s3,24(sp)
    80001d72:	e852                	sd	s4,16(sp)
    80001d74:	e456                	sd	s5,8(sp)
    80001d76:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001d78:	00000097          	auipc	ra,0x0
    80001d7c:	c2e080e7          	jalr	-978(ra) # 800019a6 <myproc>
    80001d80:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    80001d82:	00000097          	auipc	ra,0x0
    80001d86:	e2e080e7          	jalr	-466(ra) # 80001bb0 <allocproc>
    80001d8a:	12050163          	beqz	a0,80001eac <fork+0x146>
    80001d8e:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001d90:	04893603          	ld	a2,72(s2)
    80001d94:	692c                	ld	a1,80(a0)
    80001d96:	05093503          	ld	a0,80(s2)
    80001d9a:	fffff097          	auipc	ra,0xfffff
    80001d9e:	7aa080e7          	jalr	1962(ra) # 80001544 <uvmcopy>
    80001da2:	04054863          	bltz	a0,80001df2 <fork+0x8c>
  np->sz = p->sz;
    80001da6:	04893783          	ld	a5,72(s2)
    80001daa:	04fa3423          	sd	a5,72(s4)
  np->parent = p;
    80001dae:	032a3023          	sd	s2,32(s4)
  *(np->trapframe) = *(p->trapframe);
    80001db2:	05893683          	ld	a3,88(s2)
    80001db6:	87b6                	mv	a5,a3
    80001db8:	058a3703          	ld	a4,88(s4)
    80001dbc:	12068693          	addi	a3,a3,288
    80001dc0:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001dc4:	6788                	ld	a0,8(a5)
    80001dc6:	6b8c                	ld	a1,16(a5)
    80001dc8:	6f90                	ld	a2,24(a5)
    80001dca:	01073023          	sd	a6,0(a4)
    80001dce:	e708                	sd	a0,8(a4)
    80001dd0:	eb0c                	sd	a1,16(a4)
    80001dd2:	ef10                	sd	a2,24(a4)
    80001dd4:	02078793          	addi	a5,a5,32
    80001dd8:	02070713          	addi	a4,a4,32
    80001ddc:	fed792e3          	bne	a5,a3,80001dc0 <fork+0x5a>
  np->trapframe->a0 = 0;
    80001de0:	058a3783          	ld	a5,88(s4)
    80001de4:	0607b823          	sd	zero,112(a5)
    80001de8:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    80001dec:	15000993          	li	s3,336
    80001df0:	a03d                	j	80001e1e <fork+0xb8>
    freeproc(np);
    80001df2:	8552                	mv	a0,s4
    80001df4:	00000097          	auipc	ra,0x0
    80001df8:	d64080e7          	jalr	-668(ra) # 80001b58 <freeproc>
    release(&np->lock);
    80001dfc:	8552                	mv	a0,s4
    80001dfe:	fffff097          	auipc	ra,0xfffff
    80001e02:	e8c080e7          	jalr	-372(ra) # 80000c8a <release>
    return -1;
    80001e06:	5afd                	li	s5,-1
    80001e08:	a841                	j	80001e98 <fork+0x132>
      np->ofile[i] = filedup(p->ofile[i]);
    80001e0a:	00003097          	auipc	ra,0x3
    80001e0e:	838080e7          	jalr	-1992(ra) # 80004642 <filedup>
    80001e12:	009a07b3          	add	a5,s4,s1
    80001e16:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    80001e18:	04a1                	addi	s1,s1,8
    80001e1a:	01348763          	beq	s1,s3,80001e28 <fork+0xc2>
    if(p->ofile[i])
    80001e1e:	009907b3          	add	a5,s2,s1
    80001e22:	6388                	ld	a0,0(a5)
    80001e24:	f17d                	bnez	a0,80001e0a <fork+0xa4>
    80001e26:	bfcd                	j	80001e18 <fork+0xb2>
  np->cwd = idup(p->cwd);
    80001e28:	15093503          	ld	a0,336(s2)
    80001e2c:	00002097          	auipc	ra,0x2
    80001e30:	984080e7          	jalr	-1660(ra) # 800037b0 <idup>
    80001e34:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001e38:	4641                	li	a2,16
    80001e3a:	15890593          	addi	a1,s2,344
    80001e3e:	158a0513          	addi	a0,s4,344
    80001e42:	fffff097          	auipc	ra,0xfffff
    80001e46:	fe6080e7          	jalr	-26(ra) # 80000e28 <safestrcpy>
  pid = np->pid;
    80001e4a:	038a2a83          	lw	s5,56(s4)
  np->state = RUNNABLE;
    80001e4e:	4789                	li	a5,2
    80001e50:	00fa2c23          	sw	a5,24(s4)
  for(int i = 0; i < 16; i++){
    80001e54:	16890493          	addi	s1,s2,360
    80001e58:	168a0993          	addi	s3,s4,360
    80001e5c:	56890913          	addi	s2,s2,1384
    80001e60:	a025                	j	80001e88 <fork+0x122>
      memmove(&(np->vma[i]), &(p->vma[i]), sizeof(p->vma[i]));
    80001e62:	04000613          	li	a2,64
    80001e66:	85a6                	mv	a1,s1
    80001e68:	854e                	mv	a0,s3
    80001e6a:	fffff097          	auipc	ra,0xfffff
    80001e6e:	ec8080e7          	jalr	-312(ra) # 80000d32 <memmove>
      filedup(p->vma[i].mapfile);
    80001e72:	7888                	ld	a0,48(s1)
    80001e74:	00002097          	auipc	ra,0x2
    80001e78:	7ce080e7          	jalr	1998(ra) # 80004642 <filedup>
  for(int i = 0; i < 16; i++){
    80001e7c:	04048493          	addi	s1,s1,64
    80001e80:	04098993          	addi	s3,s3,64
    80001e84:	01248563          	beq	s1,s2,80001e8e <fork+0x128>
    if(p->vma[i].used){
    80001e88:	409c                	lw	a5,0(s1)
    80001e8a:	dbed                	beqz	a5,80001e7c <fork+0x116>
    80001e8c:	bfd9                	j	80001e62 <fork+0xfc>
  release(&np->lock);
    80001e8e:	8552                	mv	a0,s4
    80001e90:	fffff097          	auipc	ra,0xfffff
    80001e94:	dfa080e7          	jalr	-518(ra) # 80000c8a <release>
}
    80001e98:	8556                	mv	a0,s5
    80001e9a:	70e2                	ld	ra,56(sp)
    80001e9c:	7442                	ld	s0,48(sp)
    80001e9e:	74a2                	ld	s1,40(sp)
    80001ea0:	7902                	ld	s2,32(sp)
    80001ea2:	69e2                	ld	s3,24(sp)
    80001ea4:	6a42                	ld	s4,16(sp)
    80001ea6:	6aa2                	ld	s5,8(sp)
    80001ea8:	6121                	addi	sp,sp,64
    80001eaa:	8082                	ret
    return -1;
    80001eac:	5afd                	li	s5,-1
    80001eae:	b7ed                	j	80001e98 <fork+0x132>

0000000080001eb0 <reparent>:
{
    80001eb0:	7179                	addi	sp,sp,-48
    80001eb2:	f406                	sd	ra,40(sp)
    80001eb4:	f022                	sd	s0,32(sp)
    80001eb6:	ec26                	sd	s1,24(sp)
    80001eb8:	e84a                	sd	s2,16(sp)
    80001eba:	e44e                	sd	s3,8(sp)
    80001ebc:	e052                	sd	s4,0(sp)
    80001ebe:	1800                	addi	s0,sp,48
    80001ec0:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001ec2:	0000f497          	auipc	s1,0xf
    80001ec6:	7f648493          	addi	s1,s1,2038 # 800116b8 <proc>
      pp->parent = initproc;
    80001eca:	00007a17          	auipc	s4,0x7
    80001ece:	15ea0a13          	addi	s4,s4,350 # 80009028 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001ed2:	00025997          	auipc	s3,0x25
    80001ed6:	1e698993          	addi	s3,s3,486 # 800270b8 <tickslock>
    80001eda:	a029                	j	80001ee4 <reparent+0x34>
    80001edc:	56848493          	addi	s1,s1,1384
    80001ee0:	03348363          	beq	s1,s3,80001f06 <reparent+0x56>
    if(pp->parent == p){
    80001ee4:	709c                	ld	a5,32(s1)
    80001ee6:	ff279be3          	bne	a5,s2,80001edc <reparent+0x2c>
      acquire(&pp->lock);
    80001eea:	8526                	mv	a0,s1
    80001eec:	fffff097          	auipc	ra,0xfffff
    80001ef0:	cea080e7          	jalr	-790(ra) # 80000bd6 <acquire>
      pp->parent = initproc;
    80001ef4:	000a3783          	ld	a5,0(s4)
    80001ef8:	f09c                	sd	a5,32(s1)
      release(&pp->lock);
    80001efa:	8526                	mv	a0,s1
    80001efc:	fffff097          	auipc	ra,0xfffff
    80001f00:	d8e080e7          	jalr	-626(ra) # 80000c8a <release>
    80001f04:	bfe1                	j	80001edc <reparent+0x2c>
}
    80001f06:	70a2                	ld	ra,40(sp)
    80001f08:	7402                	ld	s0,32(sp)
    80001f0a:	64e2                	ld	s1,24(sp)
    80001f0c:	6942                	ld	s2,16(sp)
    80001f0e:	69a2                	ld	s3,8(sp)
    80001f10:	6a02                	ld	s4,0(sp)
    80001f12:	6145                	addi	sp,sp,48
    80001f14:	8082                	ret

0000000080001f16 <scheduler>:
{
    80001f16:	711d                	addi	sp,sp,-96
    80001f18:	ec86                	sd	ra,88(sp)
    80001f1a:	e8a2                	sd	s0,80(sp)
    80001f1c:	e4a6                	sd	s1,72(sp)
    80001f1e:	e0ca                	sd	s2,64(sp)
    80001f20:	fc4e                	sd	s3,56(sp)
    80001f22:	f852                	sd	s4,48(sp)
    80001f24:	f456                	sd	s5,40(sp)
    80001f26:	f05a                	sd	s6,32(sp)
    80001f28:	ec5e                	sd	s7,24(sp)
    80001f2a:	e862                	sd	s8,16(sp)
    80001f2c:	e466                	sd	s9,8(sp)
    80001f2e:	1080                	addi	s0,sp,96
    80001f30:	8792                	mv	a5,tp
  int id = r_tp();
    80001f32:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001f34:	00779c13          	slli	s8,a5,0x7
    80001f38:	0000f717          	auipc	a4,0xf
    80001f3c:	36870713          	addi	a4,a4,872 # 800112a0 <pid_lock>
    80001f40:	9762                	add	a4,a4,s8
    80001f42:	00073c23          	sd	zero,24(a4)
        swtch(&c->context, &p->context);
    80001f46:	0000f717          	auipc	a4,0xf
    80001f4a:	37a70713          	addi	a4,a4,890 # 800112c0 <cpus+0x8>
    80001f4e:	9c3a                	add	s8,s8,a4
      if(p->state == RUNNABLE) {
    80001f50:	4a89                	li	s5,2
        c->proc = p;
    80001f52:	079e                	slli	a5,a5,0x7
    80001f54:	0000fb17          	auipc	s6,0xf
    80001f58:	34cb0b13          	addi	s6,s6,844 # 800112a0 <pid_lock>
    80001f5c:	9b3e                	add	s6,s6,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001f5e:	00025a17          	auipc	s4,0x25
    80001f62:	15aa0a13          	addi	s4,s4,346 # 800270b8 <tickslock>
    int nproc = 0;
    80001f66:	4c81                	li	s9,0
    80001f68:	a8a1                	j	80001fc0 <scheduler+0xaa>
        p->state = RUNNING;
    80001f6a:	0174ac23          	sw	s7,24(s1)
        c->proc = p;
    80001f6e:	009b3c23          	sd	s1,24(s6)
        swtch(&c->context, &p->context);
    80001f72:	06048593          	addi	a1,s1,96
    80001f76:	8562                	mv	a0,s8
    80001f78:	00000097          	auipc	ra,0x0
    80001f7c:	6b2080e7          	jalr	1714(ra) # 8000262a <swtch>
        c->proc = 0;
    80001f80:	000b3c23          	sd	zero,24(s6)
      release(&p->lock);
    80001f84:	8526                	mv	a0,s1
    80001f86:	fffff097          	auipc	ra,0xfffff
    80001f8a:	d04080e7          	jalr	-764(ra) # 80000c8a <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001f8e:	56848493          	addi	s1,s1,1384
    80001f92:	01448d63          	beq	s1,s4,80001fac <scheduler+0x96>
      acquire(&p->lock);
    80001f96:	8526                	mv	a0,s1
    80001f98:	fffff097          	auipc	ra,0xfffff
    80001f9c:	c3e080e7          	jalr	-962(ra) # 80000bd6 <acquire>
      if(p->state != UNUSED) {
    80001fa0:	4c9c                	lw	a5,24(s1)
    80001fa2:	d3ed                	beqz	a5,80001f84 <scheduler+0x6e>
        nproc++;
    80001fa4:	2985                	addiw	s3,s3,1
      if(p->state == RUNNABLE) {
    80001fa6:	fd579fe3          	bne	a5,s5,80001f84 <scheduler+0x6e>
    80001faa:	b7c1                	j	80001f6a <scheduler+0x54>
    if(nproc <= 2) {   // only init and sh exist
    80001fac:	013aca63          	blt	s5,s3,80001fc0 <scheduler+0xaa>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001fb0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001fb4:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001fb8:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    80001fbc:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001fc0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001fc4:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001fc8:	10079073          	csrw	sstatus,a5
    int nproc = 0;
    80001fcc:	89e6                	mv	s3,s9
    for(p = proc; p < &proc[NPROC]; p++) {
    80001fce:	0000f497          	auipc	s1,0xf
    80001fd2:	6ea48493          	addi	s1,s1,1770 # 800116b8 <proc>
        p->state = RUNNING;
    80001fd6:	4b8d                	li	s7,3
    80001fd8:	bf7d                	j	80001f96 <scheduler+0x80>

0000000080001fda <sched>:
{
    80001fda:	7179                	addi	sp,sp,-48
    80001fdc:	f406                	sd	ra,40(sp)
    80001fde:	f022                	sd	s0,32(sp)
    80001fe0:	ec26                	sd	s1,24(sp)
    80001fe2:	e84a                	sd	s2,16(sp)
    80001fe4:	e44e                	sd	s3,8(sp)
    80001fe6:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001fe8:	00000097          	auipc	ra,0x0
    80001fec:	9be080e7          	jalr	-1602(ra) # 800019a6 <myproc>
    80001ff0:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001ff2:	fffff097          	auipc	ra,0xfffff
    80001ff6:	b6a080e7          	jalr	-1174(ra) # 80000b5c <holding>
    80001ffa:	c93d                	beqz	a0,80002070 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001ffc:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001ffe:	2781                	sext.w	a5,a5
    80002000:	079e                	slli	a5,a5,0x7
    80002002:	0000f717          	auipc	a4,0xf
    80002006:	29e70713          	addi	a4,a4,670 # 800112a0 <pid_lock>
    8000200a:	97ba                	add	a5,a5,a4
    8000200c:	0907a703          	lw	a4,144(a5)
    80002010:	4785                	li	a5,1
    80002012:	06f71763          	bne	a4,a5,80002080 <sched+0xa6>
  if(p->state == RUNNING)
    80002016:	4c98                	lw	a4,24(s1)
    80002018:	478d                	li	a5,3
    8000201a:	06f70b63          	beq	a4,a5,80002090 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000201e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002022:	8b89                	andi	a5,a5,2
  if(intr_get())
    80002024:	efb5                	bnez	a5,800020a0 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002026:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80002028:	0000f917          	auipc	s2,0xf
    8000202c:	27890913          	addi	s2,s2,632 # 800112a0 <pid_lock>
    80002030:	2781                	sext.w	a5,a5
    80002032:	079e                	slli	a5,a5,0x7
    80002034:	97ca                	add	a5,a5,s2
    80002036:	0947a983          	lw	s3,148(a5)
    8000203a:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000203c:	2781                	sext.w	a5,a5
    8000203e:	079e                	slli	a5,a5,0x7
    80002040:	0000f597          	auipc	a1,0xf
    80002044:	28058593          	addi	a1,a1,640 # 800112c0 <cpus+0x8>
    80002048:	95be                	add	a1,a1,a5
    8000204a:	06048513          	addi	a0,s1,96
    8000204e:	00000097          	auipc	ra,0x0
    80002052:	5dc080e7          	jalr	1500(ra) # 8000262a <swtch>
    80002056:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80002058:	2781                	sext.w	a5,a5
    8000205a:	079e                	slli	a5,a5,0x7
    8000205c:	97ca                	add	a5,a5,s2
    8000205e:	0937aa23          	sw	s3,148(a5)
}
    80002062:	70a2                	ld	ra,40(sp)
    80002064:	7402                	ld	s0,32(sp)
    80002066:	64e2                	ld	s1,24(sp)
    80002068:	6942                	ld	s2,16(sp)
    8000206a:	69a2                	ld	s3,8(sp)
    8000206c:	6145                	addi	sp,sp,48
    8000206e:	8082                	ret
    panic("sched p->lock");
    80002070:	00006517          	auipc	a0,0x6
    80002074:	15050513          	addi	a0,a0,336 # 800081c0 <digits+0x180>
    80002078:	ffffe097          	auipc	ra,0xffffe
    8000207c:	4b8080e7          	jalr	1208(ra) # 80000530 <panic>
    panic("sched locks");
    80002080:	00006517          	auipc	a0,0x6
    80002084:	15050513          	addi	a0,a0,336 # 800081d0 <digits+0x190>
    80002088:	ffffe097          	auipc	ra,0xffffe
    8000208c:	4a8080e7          	jalr	1192(ra) # 80000530 <panic>
    panic("sched running");
    80002090:	00006517          	auipc	a0,0x6
    80002094:	15050513          	addi	a0,a0,336 # 800081e0 <digits+0x1a0>
    80002098:	ffffe097          	auipc	ra,0xffffe
    8000209c:	498080e7          	jalr	1176(ra) # 80000530 <panic>
    panic("sched interruptible");
    800020a0:	00006517          	auipc	a0,0x6
    800020a4:	15050513          	addi	a0,a0,336 # 800081f0 <digits+0x1b0>
    800020a8:	ffffe097          	auipc	ra,0xffffe
    800020ac:	488080e7          	jalr	1160(ra) # 80000530 <panic>

00000000800020b0 <exit>:
{
    800020b0:	7139                	addi	sp,sp,-64
    800020b2:	fc06                	sd	ra,56(sp)
    800020b4:	f822                	sd	s0,48(sp)
    800020b6:	f426                	sd	s1,40(sp)
    800020b8:	f04a                	sd	s2,32(sp)
    800020ba:	ec4e                	sd	s3,24(sp)
    800020bc:	e852                	sd	s4,16(sp)
    800020be:	e456                	sd	s5,8(sp)
    800020c0:	e05a                	sd	s6,0(sp)
    800020c2:	0080                	addi	s0,sp,64
    800020c4:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800020c6:	00000097          	auipc	ra,0x0
    800020ca:	8e0080e7          	jalr	-1824(ra) # 800019a6 <myproc>
    800020ce:	89aa                	mv	s3,a0
  if(p == initproc)
    800020d0:	00007797          	auipc	a5,0x7
    800020d4:	f587b783          	ld	a5,-168(a5) # 80009028 <initproc>
    800020d8:	0d050493          	addi	s1,a0,208
    800020dc:	15050913          	addi	s2,a0,336
    800020e0:	02a79363          	bne	a5,a0,80002106 <exit+0x56>
    panic("init exiting");
    800020e4:	00006517          	auipc	a0,0x6
    800020e8:	12450513          	addi	a0,a0,292 # 80008208 <digits+0x1c8>
    800020ec:	ffffe097          	auipc	ra,0xffffe
    800020f0:	444080e7          	jalr	1092(ra) # 80000530 <panic>
      fileclose(f);
    800020f4:	00002097          	auipc	ra,0x2
    800020f8:	5a0080e7          	jalr	1440(ra) # 80004694 <fileclose>
      p->ofile[fd] = 0;
    800020fc:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80002100:	04a1                	addi	s1,s1,8
    80002102:	01248563          	beq	s1,s2,8000210c <exit+0x5c>
    if(p->ofile[fd]){
    80002106:	6088                	ld	a0,0(s1)
    80002108:	f575                	bnez	a0,800020f4 <exit+0x44>
    8000210a:	bfdd                	j	80002100 <exit+0x50>
    8000210c:	16898493          	addi	s1,s3,360
    80002110:	56898a93          	addi	s5,s3,1384
          filewrite(vma->mapfile, PGROUNDDOWN(vma->addr), vma->length);
    80002114:	7b7d                	lui	s6,0xfffff
    80002116:	a83d                	j	80002154 <exit+0xa4>
        fileclose(vma->mapfile); // ref - 1
    80002118:	03093503          	ld	a0,48(s2)
    8000211c:	00002097          	auipc	ra,0x2
    80002120:	578080e7          	jalr	1400(ra) # 80004694 <fileclose>
        uvmunmap(p->pagetable, vma->addr, vma->length / PGSIZE, 1);
    80002124:	01092783          	lw	a5,16(s2)
    80002128:	41f7d61b          	sraiw	a2,a5,0x1f
    8000212c:	0146561b          	srliw	a2,a2,0x14
    80002130:	9e3d                	addw	a2,a2,a5
    80002132:	4685                	li	a3,1
    80002134:	40c6561b          	sraiw	a2,a2,0xc
    80002138:	00893583          	ld	a1,8(s2)
    8000213c:	0509b503          	ld	a0,80(s3)
    80002140:	fffff097          	auipc	ra,0xfffff
    80002144:	11a080e7          	jalr	282(ra) # 8000125a <uvmunmap>
        vma->used = 0;
    80002148:	00092023          	sw	zero,0(s2)
  for(int i = 0; i < 16; i++){
    8000214c:	04048493          	addi	s1,s1,64
    80002150:	03548863          	beq	s1,s5,80002180 <exit+0xd0>
    if(vma->used){
    80002154:	8926                	mv	s2,s1
    80002156:	409c                	lw	a5,0(s1)
    80002158:	dbf5                	beqz	a5,8000214c <exit+0x9c>
      if((vma->prot & PROT_WRITE) && (vma->mapfile->writable) && (vma->flags & MAP_SHARED)){
    8000215a:	6c9c                	ld	a5,24(s1)
    8000215c:	8b89                	andi	a5,a5,2
    8000215e:	dfcd                	beqz	a5,80002118 <exit+0x68>
    80002160:	7888                	ld	a0,48(s1)
    80002162:	00954783          	lbu	a5,9(a0)
    80002166:	dbcd                	beqz	a5,80002118 <exit+0x68>
    80002168:	709c                	ld	a5,32(s1)
    8000216a:	8b85                	andi	a5,a5,1
    8000216c:	d7d5                	beqz	a5,80002118 <exit+0x68>
          filewrite(vma->mapfile, PGROUNDDOWN(vma->addr), vma->length);
    8000216e:	648c                	ld	a1,8(s1)
    80002170:	4890                	lw	a2,16(s1)
    80002172:	00bb75b3          	and	a1,s6,a1
    80002176:	00002097          	auipc	ra,0x2
    8000217a:	71a080e7          	jalr	1818(ra) # 80004890 <filewrite>
    8000217e:	bf69                	j	80002118 <exit+0x68>
  begin_op();
    80002180:	00002097          	auipc	ra,0x2
    80002184:	040080e7          	jalr	64(ra) # 800041c0 <begin_op>
  iput(p->cwd);
    80002188:	1509b503          	ld	a0,336(s3)
    8000218c:	00002097          	auipc	ra,0x2
    80002190:	81c080e7          	jalr	-2020(ra) # 800039a8 <iput>
  end_op();
    80002194:	00002097          	auipc	ra,0x2
    80002198:	0ac080e7          	jalr	172(ra) # 80004240 <end_op>
  p->cwd = 0;
    8000219c:	1409b823          	sd	zero,336(s3)
  acquire(&initproc->lock);
    800021a0:	00007497          	auipc	s1,0x7
    800021a4:	e8848493          	addi	s1,s1,-376 # 80009028 <initproc>
    800021a8:	6088                	ld	a0,0(s1)
    800021aa:	fffff097          	auipc	ra,0xfffff
    800021ae:	a2c080e7          	jalr	-1492(ra) # 80000bd6 <acquire>
  wakeup1(initproc);
    800021b2:	6088                	ld	a0,0(s1)
    800021b4:	fffff097          	auipc	ra,0xfffff
    800021b8:	654080e7          	jalr	1620(ra) # 80001808 <wakeup1>
  release(&initproc->lock);
    800021bc:	6088                	ld	a0,0(s1)
    800021be:	fffff097          	auipc	ra,0xfffff
    800021c2:	acc080e7          	jalr	-1332(ra) # 80000c8a <release>
  acquire(&p->lock);
    800021c6:	854e                	mv	a0,s3
    800021c8:	fffff097          	auipc	ra,0xfffff
    800021cc:	a0e080e7          	jalr	-1522(ra) # 80000bd6 <acquire>
  struct proc *original_parent = p->parent;
    800021d0:	0209b483          	ld	s1,32(s3)
  release(&p->lock);
    800021d4:	854e                	mv	a0,s3
    800021d6:	fffff097          	auipc	ra,0xfffff
    800021da:	ab4080e7          	jalr	-1356(ra) # 80000c8a <release>
  acquire(&original_parent->lock);
    800021de:	8526                	mv	a0,s1
    800021e0:	fffff097          	auipc	ra,0xfffff
    800021e4:	9f6080e7          	jalr	-1546(ra) # 80000bd6 <acquire>
  acquire(&p->lock);
    800021e8:	854e                	mv	a0,s3
    800021ea:	fffff097          	auipc	ra,0xfffff
    800021ee:	9ec080e7          	jalr	-1556(ra) # 80000bd6 <acquire>
  reparent(p);
    800021f2:	854e                	mv	a0,s3
    800021f4:	00000097          	auipc	ra,0x0
    800021f8:	cbc080e7          	jalr	-836(ra) # 80001eb0 <reparent>
  wakeup1(original_parent);
    800021fc:	8526                	mv	a0,s1
    800021fe:	fffff097          	auipc	ra,0xfffff
    80002202:	60a080e7          	jalr	1546(ra) # 80001808 <wakeup1>
  p->xstate = status;
    80002206:	0349aa23          	sw	s4,52(s3)
  p->state = ZOMBIE;
    8000220a:	4791                	li	a5,4
    8000220c:	00f9ac23          	sw	a5,24(s3)
  release(&original_parent->lock);
    80002210:	8526                	mv	a0,s1
    80002212:	fffff097          	auipc	ra,0xfffff
    80002216:	a78080e7          	jalr	-1416(ra) # 80000c8a <release>
  sched();
    8000221a:	00000097          	auipc	ra,0x0
    8000221e:	dc0080e7          	jalr	-576(ra) # 80001fda <sched>
  panic("zombie exit");
    80002222:	00006517          	auipc	a0,0x6
    80002226:	ff650513          	addi	a0,a0,-10 # 80008218 <digits+0x1d8>
    8000222a:	ffffe097          	auipc	ra,0xffffe
    8000222e:	306080e7          	jalr	774(ra) # 80000530 <panic>

0000000080002232 <yield>:
{
    80002232:	1101                	addi	sp,sp,-32
    80002234:	ec06                	sd	ra,24(sp)
    80002236:	e822                	sd	s0,16(sp)
    80002238:	e426                	sd	s1,8(sp)
    8000223a:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000223c:	fffff097          	auipc	ra,0xfffff
    80002240:	76a080e7          	jalr	1898(ra) # 800019a6 <myproc>
    80002244:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002246:	fffff097          	auipc	ra,0xfffff
    8000224a:	990080e7          	jalr	-1648(ra) # 80000bd6 <acquire>
  p->state = RUNNABLE;
    8000224e:	4789                	li	a5,2
    80002250:	cc9c                	sw	a5,24(s1)
  sched();
    80002252:	00000097          	auipc	ra,0x0
    80002256:	d88080e7          	jalr	-632(ra) # 80001fda <sched>
  release(&p->lock);
    8000225a:	8526                	mv	a0,s1
    8000225c:	fffff097          	auipc	ra,0xfffff
    80002260:	a2e080e7          	jalr	-1490(ra) # 80000c8a <release>
}
    80002264:	60e2                	ld	ra,24(sp)
    80002266:	6442                	ld	s0,16(sp)
    80002268:	64a2                	ld	s1,8(sp)
    8000226a:	6105                	addi	sp,sp,32
    8000226c:	8082                	ret

000000008000226e <sleep>:
{
    8000226e:	7179                	addi	sp,sp,-48
    80002270:	f406                	sd	ra,40(sp)
    80002272:	f022                	sd	s0,32(sp)
    80002274:	ec26                	sd	s1,24(sp)
    80002276:	e84a                	sd	s2,16(sp)
    80002278:	e44e                	sd	s3,8(sp)
    8000227a:	1800                	addi	s0,sp,48
    8000227c:	89aa                	mv	s3,a0
    8000227e:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002280:	fffff097          	auipc	ra,0xfffff
    80002284:	726080e7          	jalr	1830(ra) # 800019a6 <myproc>
    80002288:	84aa                	mv	s1,a0
  if(lk != &p->lock){  //DOC: sleeplock0
    8000228a:	05250663          	beq	a0,s2,800022d6 <sleep+0x68>
    acquire(&p->lock);  //DOC: sleeplock1
    8000228e:	fffff097          	auipc	ra,0xfffff
    80002292:	948080e7          	jalr	-1720(ra) # 80000bd6 <acquire>
    release(lk);
    80002296:	854a                	mv	a0,s2
    80002298:	fffff097          	auipc	ra,0xfffff
    8000229c:	9f2080e7          	jalr	-1550(ra) # 80000c8a <release>
  p->chan = chan;
    800022a0:	0334b423          	sd	s3,40(s1)
  p->state = SLEEPING;
    800022a4:	4785                	li	a5,1
    800022a6:	cc9c                	sw	a5,24(s1)
  sched();
    800022a8:	00000097          	auipc	ra,0x0
    800022ac:	d32080e7          	jalr	-718(ra) # 80001fda <sched>
  p->chan = 0;
    800022b0:	0204b423          	sd	zero,40(s1)
    release(&p->lock);
    800022b4:	8526                	mv	a0,s1
    800022b6:	fffff097          	auipc	ra,0xfffff
    800022ba:	9d4080e7          	jalr	-1580(ra) # 80000c8a <release>
    acquire(lk);
    800022be:	854a                	mv	a0,s2
    800022c0:	fffff097          	auipc	ra,0xfffff
    800022c4:	916080e7          	jalr	-1770(ra) # 80000bd6 <acquire>
}
    800022c8:	70a2                	ld	ra,40(sp)
    800022ca:	7402                	ld	s0,32(sp)
    800022cc:	64e2                	ld	s1,24(sp)
    800022ce:	6942                	ld	s2,16(sp)
    800022d0:	69a2                	ld	s3,8(sp)
    800022d2:	6145                	addi	sp,sp,48
    800022d4:	8082                	ret
  p->chan = chan;
    800022d6:	03353423          	sd	s3,40(a0)
  p->state = SLEEPING;
    800022da:	4785                	li	a5,1
    800022dc:	cd1c                	sw	a5,24(a0)
  sched();
    800022de:	00000097          	auipc	ra,0x0
    800022e2:	cfc080e7          	jalr	-772(ra) # 80001fda <sched>
  p->chan = 0;
    800022e6:	0204b423          	sd	zero,40(s1)
  if(lk != &p->lock){
    800022ea:	bff9                	j	800022c8 <sleep+0x5a>

00000000800022ec <wait>:
{
    800022ec:	715d                	addi	sp,sp,-80
    800022ee:	e486                	sd	ra,72(sp)
    800022f0:	e0a2                	sd	s0,64(sp)
    800022f2:	fc26                	sd	s1,56(sp)
    800022f4:	f84a                	sd	s2,48(sp)
    800022f6:	f44e                	sd	s3,40(sp)
    800022f8:	f052                	sd	s4,32(sp)
    800022fa:	ec56                	sd	s5,24(sp)
    800022fc:	e85a                	sd	s6,16(sp)
    800022fe:	e45e                	sd	s7,8(sp)
    80002300:	e062                	sd	s8,0(sp)
    80002302:	0880                	addi	s0,sp,80
    80002304:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80002306:	fffff097          	auipc	ra,0xfffff
    8000230a:	6a0080e7          	jalr	1696(ra) # 800019a6 <myproc>
    8000230e:	892a                	mv	s2,a0
  acquire(&p->lock);
    80002310:	8c2a                	mv	s8,a0
    80002312:	fffff097          	auipc	ra,0xfffff
    80002316:	8c4080e7          	jalr	-1852(ra) # 80000bd6 <acquire>
    havekids = 0;
    8000231a:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    8000231c:	4a11                	li	s4,4
    for(np = proc; np < &proc[NPROC]; np++){
    8000231e:	00025997          	auipc	s3,0x25
    80002322:	d9a98993          	addi	s3,s3,-614 # 800270b8 <tickslock>
        havekids = 1;
    80002326:	4a85                	li	s5,1
    havekids = 0;
    80002328:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    8000232a:	0000f497          	auipc	s1,0xf
    8000232e:	38e48493          	addi	s1,s1,910 # 800116b8 <proc>
    80002332:	a08d                	j	80002394 <wait+0xa8>
          pid = np->pid;
    80002334:	0384a983          	lw	s3,56(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80002338:	000b0e63          	beqz	s6,80002354 <wait+0x68>
    8000233c:	4691                	li	a3,4
    8000233e:	03448613          	addi	a2,s1,52
    80002342:	85da                	mv	a1,s6
    80002344:	05093503          	ld	a0,80(s2)
    80002348:	fffff097          	auipc	ra,0xfffff
    8000234c:	2f4080e7          	jalr	756(ra) # 8000163c <copyout>
    80002350:	02054263          	bltz	a0,80002374 <wait+0x88>
          freeproc(np);
    80002354:	8526                	mv	a0,s1
    80002356:	00000097          	auipc	ra,0x0
    8000235a:	802080e7          	jalr	-2046(ra) # 80001b58 <freeproc>
          release(&np->lock);
    8000235e:	8526                	mv	a0,s1
    80002360:	fffff097          	auipc	ra,0xfffff
    80002364:	92a080e7          	jalr	-1750(ra) # 80000c8a <release>
          release(&p->lock);
    80002368:	854a                	mv	a0,s2
    8000236a:	fffff097          	auipc	ra,0xfffff
    8000236e:	920080e7          	jalr	-1760(ra) # 80000c8a <release>
          return pid;
    80002372:	a8a9                	j	800023cc <wait+0xe0>
            release(&np->lock);
    80002374:	8526                	mv	a0,s1
    80002376:	fffff097          	auipc	ra,0xfffff
    8000237a:	914080e7          	jalr	-1772(ra) # 80000c8a <release>
            release(&p->lock);
    8000237e:	854a                	mv	a0,s2
    80002380:	fffff097          	auipc	ra,0xfffff
    80002384:	90a080e7          	jalr	-1782(ra) # 80000c8a <release>
            return -1;
    80002388:	59fd                	li	s3,-1
    8000238a:	a089                	j	800023cc <wait+0xe0>
    for(np = proc; np < &proc[NPROC]; np++){
    8000238c:	56848493          	addi	s1,s1,1384
    80002390:	03348463          	beq	s1,s3,800023b8 <wait+0xcc>
      if(np->parent == p){
    80002394:	709c                	ld	a5,32(s1)
    80002396:	ff279be3          	bne	a5,s2,8000238c <wait+0xa0>
        acquire(&np->lock);
    8000239a:	8526                	mv	a0,s1
    8000239c:	fffff097          	auipc	ra,0xfffff
    800023a0:	83a080e7          	jalr	-1990(ra) # 80000bd6 <acquire>
        if(np->state == ZOMBIE){
    800023a4:	4c9c                	lw	a5,24(s1)
    800023a6:	f94787e3          	beq	a5,s4,80002334 <wait+0x48>
        release(&np->lock);
    800023aa:	8526                	mv	a0,s1
    800023ac:	fffff097          	auipc	ra,0xfffff
    800023b0:	8de080e7          	jalr	-1826(ra) # 80000c8a <release>
        havekids = 1;
    800023b4:	8756                	mv	a4,s5
    800023b6:	bfd9                	j	8000238c <wait+0xa0>
    if(!havekids || p->killed){
    800023b8:	c701                	beqz	a4,800023c0 <wait+0xd4>
    800023ba:	03092783          	lw	a5,48(s2)
    800023be:	c785                	beqz	a5,800023e6 <wait+0xfa>
      release(&p->lock);
    800023c0:	854a                	mv	a0,s2
    800023c2:	fffff097          	auipc	ra,0xfffff
    800023c6:	8c8080e7          	jalr	-1848(ra) # 80000c8a <release>
      return -1;
    800023ca:	59fd                	li	s3,-1
}
    800023cc:	854e                	mv	a0,s3
    800023ce:	60a6                	ld	ra,72(sp)
    800023d0:	6406                	ld	s0,64(sp)
    800023d2:	74e2                	ld	s1,56(sp)
    800023d4:	7942                	ld	s2,48(sp)
    800023d6:	79a2                	ld	s3,40(sp)
    800023d8:	7a02                	ld	s4,32(sp)
    800023da:	6ae2                	ld	s5,24(sp)
    800023dc:	6b42                	ld	s6,16(sp)
    800023de:	6ba2                	ld	s7,8(sp)
    800023e0:	6c02                	ld	s8,0(sp)
    800023e2:	6161                	addi	sp,sp,80
    800023e4:	8082                	ret
    sleep(p, &p->lock);  //DOC: wait-sleep
    800023e6:	85e2                	mv	a1,s8
    800023e8:	854a                	mv	a0,s2
    800023ea:	00000097          	auipc	ra,0x0
    800023ee:	e84080e7          	jalr	-380(ra) # 8000226e <sleep>
    havekids = 0;
    800023f2:	bf1d                	j	80002328 <wait+0x3c>

00000000800023f4 <wakeup>:
{
    800023f4:	7139                	addi	sp,sp,-64
    800023f6:	fc06                	sd	ra,56(sp)
    800023f8:	f822                	sd	s0,48(sp)
    800023fa:	f426                	sd	s1,40(sp)
    800023fc:	f04a                	sd	s2,32(sp)
    800023fe:	ec4e                	sd	s3,24(sp)
    80002400:	e852                	sd	s4,16(sp)
    80002402:	e456                	sd	s5,8(sp)
    80002404:	0080                	addi	s0,sp,64
    80002406:	8a2a                	mv	s4,a0
  for(p = proc; p < &proc[NPROC]; p++) {
    80002408:	0000f497          	auipc	s1,0xf
    8000240c:	2b048493          	addi	s1,s1,688 # 800116b8 <proc>
    if(p->state == SLEEPING && p->chan == chan) {
    80002410:	4985                	li	s3,1
      p->state = RUNNABLE;
    80002412:	4a89                	li	s5,2
  for(p = proc; p < &proc[NPROC]; p++) {
    80002414:	00025917          	auipc	s2,0x25
    80002418:	ca490913          	addi	s2,s2,-860 # 800270b8 <tickslock>
    8000241c:	a821                	j	80002434 <wakeup+0x40>
      p->state = RUNNABLE;
    8000241e:	0154ac23          	sw	s5,24(s1)
    release(&p->lock);
    80002422:	8526                	mv	a0,s1
    80002424:	fffff097          	auipc	ra,0xfffff
    80002428:	866080e7          	jalr	-1946(ra) # 80000c8a <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000242c:	56848493          	addi	s1,s1,1384
    80002430:	01248e63          	beq	s1,s2,8000244c <wakeup+0x58>
    acquire(&p->lock);
    80002434:	8526                	mv	a0,s1
    80002436:	ffffe097          	auipc	ra,0xffffe
    8000243a:	7a0080e7          	jalr	1952(ra) # 80000bd6 <acquire>
    if(p->state == SLEEPING && p->chan == chan) {
    8000243e:	4c9c                	lw	a5,24(s1)
    80002440:	ff3791e3          	bne	a5,s3,80002422 <wakeup+0x2e>
    80002444:	749c                	ld	a5,40(s1)
    80002446:	fd479ee3          	bne	a5,s4,80002422 <wakeup+0x2e>
    8000244a:	bfd1                	j	8000241e <wakeup+0x2a>
}
    8000244c:	70e2                	ld	ra,56(sp)
    8000244e:	7442                	ld	s0,48(sp)
    80002450:	74a2                	ld	s1,40(sp)
    80002452:	7902                	ld	s2,32(sp)
    80002454:	69e2                	ld	s3,24(sp)
    80002456:	6a42                	ld	s4,16(sp)
    80002458:	6aa2                	ld	s5,8(sp)
    8000245a:	6121                	addi	sp,sp,64
    8000245c:	8082                	ret

000000008000245e <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    8000245e:	7179                	addi	sp,sp,-48
    80002460:	f406                	sd	ra,40(sp)
    80002462:	f022                	sd	s0,32(sp)
    80002464:	ec26                	sd	s1,24(sp)
    80002466:	e84a                	sd	s2,16(sp)
    80002468:	e44e                	sd	s3,8(sp)
    8000246a:	1800                	addi	s0,sp,48
    8000246c:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000246e:	0000f497          	auipc	s1,0xf
    80002472:	24a48493          	addi	s1,s1,586 # 800116b8 <proc>
    80002476:	00025997          	auipc	s3,0x25
    8000247a:	c4298993          	addi	s3,s3,-958 # 800270b8 <tickslock>
    acquire(&p->lock);
    8000247e:	8526                	mv	a0,s1
    80002480:	ffffe097          	auipc	ra,0xffffe
    80002484:	756080e7          	jalr	1878(ra) # 80000bd6 <acquire>
    if(p->pid == pid){
    80002488:	5c9c                	lw	a5,56(s1)
    8000248a:	01278d63          	beq	a5,s2,800024a4 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000248e:	8526                	mv	a0,s1
    80002490:	ffffe097          	auipc	ra,0xffffe
    80002494:	7fa080e7          	jalr	2042(ra) # 80000c8a <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80002498:	56848493          	addi	s1,s1,1384
    8000249c:	ff3491e3          	bne	s1,s3,8000247e <kill+0x20>
  }
  return -1;
    800024a0:	557d                	li	a0,-1
    800024a2:	a829                	j	800024bc <kill+0x5e>
      p->killed = 1;
    800024a4:	4785                	li	a5,1
    800024a6:	d89c                	sw	a5,48(s1)
      if(p->state == SLEEPING){
    800024a8:	4c98                	lw	a4,24(s1)
    800024aa:	4785                	li	a5,1
    800024ac:	00f70f63          	beq	a4,a5,800024ca <kill+0x6c>
      release(&p->lock);
    800024b0:	8526                	mv	a0,s1
    800024b2:	ffffe097          	auipc	ra,0xffffe
    800024b6:	7d8080e7          	jalr	2008(ra) # 80000c8a <release>
      return 0;
    800024ba:	4501                	li	a0,0
}
    800024bc:	70a2                	ld	ra,40(sp)
    800024be:	7402                	ld	s0,32(sp)
    800024c0:	64e2                	ld	s1,24(sp)
    800024c2:	6942                	ld	s2,16(sp)
    800024c4:	69a2                	ld	s3,8(sp)
    800024c6:	6145                	addi	sp,sp,48
    800024c8:	8082                	ret
        p->state = RUNNABLE;
    800024ca:	4789                	li	a5,2
    800024cc:	cc9c                	sw	a5,24(s1)
    800024ce:	b7cd                	j	800024b0 <kill+0x52>

00000000800024d0 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800024d0:	7179                	addi	sp,sp,-48
    800024d2:	f406                	sd	ra,40(sp)
    800024d4:	f022                	sd	s0,32(sp)
    800024d6:	ec26                	sd	s1,24(sp)
    800024d8:	e84a                	sd	s2,16(sp)
    800024da:	e44e                	sd	s3,8(sp)
    800024dc:	e052                	sd	s4,0(sp)
    800024de:	1800                	addi	s0,sp,48
    800024e0:	84aa                	mv	s1,a0
    800024e2:	892e                	mv	s2,a1
    800024e4:	89b2                	mv	s3,a2
    800024e6:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800024e8:	fffff097          	auipc	ra,0xfffff
    800024ec:	4be080e7          	jalr	1214(ra) # 800019a6 <myproc>
  if(user_dst){
    800024f0:	c08d                	beqz	s1,80002512 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800024f2:	86d2                	mv	a3,s4
    800024f4:	864e                	mv	a2,s3
    800024f6:	85ca                	mv	a1,s2
    800024f8:	6928                	ld	a0,80(a0)
    800024fa:	fffff097          	auipc	ra,0xfffff
    800024fe:	142080e7          	jalr	322(ra) # 8000163c <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80002502:	70a2                	ld	ra,40(sp)
    80002504:	7402                	ld	s0,32(sp)
    80002506:	64e2                	ld	s1,24(sp)
    80002508:	6942                	ld	s2,16(sp)
    8000250a:	69a2                	ld	s3,8(sp)
    8000250c:	6a02                	ld	s4,0(sp)
    8000250e:	6145                	addi	sp,sp,48
    80002510:	8082                	ret
    memmove((char *)dst, src, len);
    80002512:	000a061b          	sext.w	a2,s4
    80002516:	85ce                	mv	a1,s3
    80002518:	854a                	mv	a0,s2
    8000251a:	fffff097          	auipc	ra,0xfffff
    8000251e:	818080e7          	jalr	-2024(ra) # 80000d32 <memmove>
    return 0;
    80002522:	8526                	mv	a0,s1
    80002524:	bff9                	j	80002502 <either_copyout+0x32>

0000000080002526 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80002526:	7179                	addi	sp,sp,-48
    80002528:	f406                	sd	ra,40(sp)
    8000252a:	f022                	sd	s0,32(sp)
    8000252c:	ec26                	sd	s1,24(sp)
    8000252e:	e84a                	sd	s2,16(sp)
    80002530:	e44e                	sd	s3,8(sp)
    80002532:	e052                	sd	s4,0(sp)
    80002534:	1800                	addi	s0,sp,48
    80002536:	892a                	mv	s2,a0
    80002538:	84ae                	mv	s1,a1
    8000253a:	89b2                	mv	s3,a2
    8000253c:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000253e:	fffff097          	auipc	ra,0xfffff
    80002542:	468080e7          	jalr	1128(ra) # 800019a6 <myproc>
  if(user_src){
    80002546:	c08d                	beqz	s1,80002568 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80002548:	86d2                	mv	a3,s4
    8000254a:	864e                	mv	a2,s3
    8000254c:	85ca                	mv	a1,s2
    8000254e:	6928                	ld	a0,80(a0)
    80002550:	fffff097          	auipc	ra,0xfffff
    80002554:	178080e7          	jalr	376(ra) # 800016c8 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80002558:	70a2                	ld	ra,40(sp)
    8000255a:	7402                	ld	s0,32(sp)
    8000255c:	64e2                	ld	s1,24(sp)
    8000255e:	6942                	ld	s2,16(sp)
    80002560:	69a2                	ld	s3,8(sp)
    80002562:	6a02                	ld	s4,0(sp)
    80002564:	6145                	addi	sp,sp,48
    80002566:	8082                	ret
    memmove(dst, (char*)src, len);
    80002568:	000a061b          	sext.w	a2,s4
    8000256c:	85ce                	mv	a1,s3
    8000256e:	854a                	mv	a0,s2
    80002570:	ffffe097          	auipc	ra,0xffffe
    80002574:	7c2080e7          	jalr	1986(ra) # 80000d32 <memmove>
    return 0;
    80002578:	8526                	mv	a0,s1
    8000257a:	bff9                	j	80002558 <either_copyin+0x32>

000000008000257c <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    8000257c:	715d                	addi	sp,sp,-80
    8000257e:	e486                	sd	ra,72(sp)
    80002580:	e0a2                	sd	s0,64(sp)
    80002582:	fc26                	sd	s1,56(sp)
    80002584:	f84a                	sd	s2,48(sp)
    80002586:	f44e                	sd	s3,40(sp)
    80002588:	f052                	sd	s4,32(sp)
    8000258a:	ec56                	sd	s5,24(sp)
    8000258c:	e85a                	sd	s6,16(sp)
    8000258e:	e45e                	sd	s7,8(sp)
    80002590:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80002592:	00006517          	auipc	a0,0x6
    80002596:	d8e50513          	addi	a0,a0,-626 # 80008320 <states.1785+0xb8>
    8000259a:	ffffe097          	auipc	ra,0xffffe
    8000259e:	fe0080e7          	jalr	-32(ra) # 8000057a <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800025a2:	0000f497          	auipc	s1,0xf
    800025a6:	26e48493          	addi	s1,s1,622 # 80011810 <proc+0x158>
    800025aa:	00025917          	auipc	s2,0x25
    800025ae:	c6690913          	addi	s2,s2,-922 # 80027210 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800025b2:	4b11                	li	s6,4
      state = states[p->state];
    else
      state = "???";
    800025b4:	00006997          	auipc	s3,0x6
    800025b8:	c7498993          	addi	s3,s3,-908 # 80008228 <digits+0x1e8>
    printf("%d %s %s", p->pid, state, p->name);
    800025bc:	00006a97          	auipc	s5,0x6
    800025c0:	c74a8a93          	addi	s5,s5,-908 # 80008230 <digits+0x1f0>
    printf("\n");
    800025c4:	00006a17          	auipc	s4,0x6
    800025c8:	d5ca0a13          	addi	s4,s4,-676 # 80008320 <states.1785+0xb8>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800025cc:	00006b97          	auipc	s7,0x6
    800025d0:	c9cb8b93          	addi	s7,s7,-868 # 80008268 <states.1785>
    800025d4:	a00d                	j	800025f6 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    800025d6:	ee06a583          	lw	a1,-288(a3)
    800025da:	8556                	mv	a0,s5
    800025dc:	ffffe097          	auipc	ra,0xffffe
    800025e0:	f9e080e7          	jalr	-98(ra) # 8000057a <printf>
    printf("\n");
    800025e4:	8552                	mv	a0,s4
    800025e6:	ffffe097          	auipc	ra,0xffffe
    800025ea:	f94080e7          	jalr	-108(ra) # 8000057a <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800025ee:	56848493          	addi	s1,s1,1384
    800025f2:	03248163          	beq	s1,s2,80002614 <procdump+0x98>
    if(p->state == UNUSED)
    800025f6:	86a6                	mv	a3,s1
    800025f8:	ec04a783          	lw	a5,-320(s1)
    800025fc:	dbed                	beqz	a5,800025ee <procdump+0x72>
      state = "???";
    800025fe:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002600:	fcfb6be3          	bltu	s6,a5,800025d6 <procdump+0x5a>
    80002604:	1782                	slli	a5,a5,0x20
    80002606:	9381                	srli	a5,a5,0x20
    80002608:	078e                	slli	a5,a5,0x3
    8000260a:	97de                	add	a5,a5,s7
    8000260c:	6390                	ld	a2,0(a5)
    8000260e:	f661                	bnez	a2,800025d6 <procdump+0x5a>
      state = "???";
    80002610:	864e                	mv	a2,s3
    80002612:	b7d1                	j	800025d6 <procdump+0x5a>
  }
}
    80002614:	60a6                	ld	ra,72(sp)
    80002616:	6406                	ld	s0,64(sp)
    80002618:	74e2                	ld	s1,56(sp)
    8000261a:	7942                	ld	s2,48(sp)
    8000261c:	79a2                	ld	s3,40(sp)
    8000261e:	7a02                	ld	s4,32(sp)
    80002620:	6ae2                	ld	s5,24(sp)
    80002622:	6b42                	ld	s6,16(sp)
    80002624:	6ba2                	ld	s7,8(sp)
    80002626:	6161                	addi	sp,sp,80
    80002628:	8082                	ret

000000008000262a <swtch>:
    8000262a:	00153023          	sd	ra,0(a0)
    8000262e:	00253423          	sd	sp,8(a0)
    80002632:	e900                	sd	s0,16(a0)
    80002634:	ed04                	sd	s1,24(a0)
    80002636:	03253023          	sd	s2,32(a0)
    8000263a:	03353423          	sd	s3,40(a0)
    8000263e:	03453823          	sd	s4,48(a0)
    80002642:	03553c23          	sd	s5,56(a0)
    80002646:	05653023          	sd	s6,64(a0)
    8000264a:	05753423          	sd	s7,72(a0)
    8000264e:	05853823          	sd	s8,80(a0)
    80002652:	05953c23          	sd	s9,88(a0)
    80002656:	07a53023          	sd	s10,96(a0)
    8000265a:	07b53423          	sd	s11,104(a0)
    8000265e:	0005b083          	ld	ra,0(a1)
    80002662:	0085b103          	ld	sp,8(a1)
    80002666:	6980                	ld	s0,16(a1)
    80002668:	6d84                	ld	s1,24(a1)
    8000266a:	0205b903          	ld	s2,32(a1)
    8000266e:	0285b983          	ld	s3,40(a1)
    80002672:	0305ba03          	ld	s4,48(a1)
    80002676:	0385ba83          	ld	s5,56(a1)
    8000267a:	0405bb03          	ld	s6,64(a1)
    8000267e:	0485bb83          	ld	s7,72(a1)
    80002682:	0505bc03          	ld	s8,80(a1)
    80002686:	0585bc83          	ld	s9,88(a1)
    8000268a:	0605bd03          	ld	s10,96(a1)
    8000268e:	0685bd83          	ld	s11,104(a1)
    80002692:	8082                	ret

0000000080002694 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002694:	1141                	addi	sp,sp,-16
    80002696:	e406                	sd	ra,8(sp)
    80002698:	e022                	sd	s0,0(sp)
    8000269a:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    8000269c:	00006597          	auipc	a1,0x6
    800026a0:	bf458593          	addi	a1,a1,-1036 # 80008290 <states.1785+0x28>
    800026a4:	00025517          	auipc	a0,0x25
    800026a8:	a1450513          	addi	a0,a0,-1516 # 800270b8 <tickslock>
    800026ac:	ffffe097          	auipc	ra,0xffffe
    800026b0:	49a080e7          	jalr	1178(ra) # 80000b46 <initlock>
}
    800026b4:	60a2                	ld	ra,8(sp)
    800026b6:	6402                	ld	s0,0(sp)
    800026b8:	0141                	addi	sp,sp,16
    800026ba:	8082                	ret

00000000800026bc <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    800026bc:	1141                	addi	sp,sp,-16
    800026be:	e422                	sd	s0,8(sp)
    800026c0:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    800026c2:	00004797          	auipc	a5,0x4
    800026c6:	87e78793          	addi	a5,a5,-1922 # 80005f40 <kernelvec>
    800026ca:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    800026ce:	6422                	ld	s0,8(sp)
    800026d0:	0141                	addi	sp,sp,16
    800026d2:	8082                	ret

00000000800026d4 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    800026d4:	1141                	addi	sp,sp,-16
    800026d6:	e406                	sd	ra,8(sp)
    800026d8:	e022                	sd	s0,0(sp)
    800026da:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    800026dc:	fffff097          	auipc	ra,0xfffff
    800026e0:	2ca080e7          	jalr	714(ra) # 800019a6 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800026e4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800026e8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800026ea:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    800026ee:	00005617          	auipc	a2,0x5
    800026f2:	91260613          	addi	a2,a2,-1774 # 80007000 <_trampoline>
    800026f6:	00005697          	auipc	a3,0x5
    800026fa:	90a68693          	addi	a3,a3,-1782 # 80007000 <_trampoline>
    800026fe:	8e91                	sub	a3,a3,a2
    80002700:	040007b7          	lui	a5,0x4000
    80002704:	17fd                	addi	a5,a5,-1
    80002706:	07b2                	slli	a5,a5,0xc
    80002708:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000270a:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    8000270e:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002710:	180026f3          	csrr	a3,satp
    80002714:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002716:	6d38                	ld	a4,88(a0)
    80002718:	6134                	ld	a3,64(a0)
    8000271a:	6585                	lui	a1,0x1
    8000271c:	96ae                	add	a3,a3,a1
    8000271e:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002720:	6d38                	ld	a4,88(a0)
    80002722:	00000697          	auipc	a3,0x0
    80002726:	13868693          	addi	a3,a3,312 # 8000285a <usertrap>
    8000272a:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    8000272c:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    8000272e:	8692                	mv	a3,tp
    80002730:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002732:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002736:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    8000273a:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000273e:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002742:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002744:	6f18                	ld	a4,24(a4)
    80002746:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    8000274a:	692c                	ld	a1,80(a0)
    8000274c:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    8000274e:	00005717          	auipc	a4,0x5
    80002752:	94270713          	addi	a4,a4,-1726 # 80007090 <userret>
    80002756:	8f11                	sub	a4,a4,a2
    80002758:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    8000275a:	577d                	li	a4,-1
    8000275c:	177e                	slli	a4,a4,0x3f
    8000275e:	8dd9                	or	a1,a1,a4
    80002760:	02000537          	lui	a0,0x2000
    80002764:	157d                	addi	a0,a0,-1
    80002766:	0536                	slli	a0,a0,0xd
    80002768:	9782                	jalr	a5
}
    8000276a:	60a2                	ld	ra,8(sp)
    8000276c:	6402                	ld	s0,0(sp)
    8000276e:	0141                	addi	sp,sp,16
    80002770:	8082                	ret

0000000080002772 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80002772:	1101                	addi	sp,sp,-32
    80002774:	ec06                	sd	ra,24(sp)
    80002776:	e822                	sd	s0,16(sp)
    80002778:	e426                	sd	s1,8(sp)
    8000277a:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    8000277c:	00025497          	auipc	s1,0x25
    80002780:	93c48493          	addi	s1,s1,-1732 # 800270b8 <tickslock>
    80002784:	8526                	mv	a0,s1
    80002786:	ffffe097          	auipc	ra,0xffffe
    8000278a:	450080e7          	jalr	1104(ra) # 80000bd6 <acquire>
  ticks++;
    8000278e:	00007517          	auipc	a0,0x7
    80002792:	8a250513          	addi	a0,a0,-1886 # 80009030 <ticks>
    80002796:	411c                	lw	a5,0(a0)
    80002798:	2785                	addiw	a5,a5,1
    8000279a:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    8000279c:	00000097          	auipc	ra,0x0
    800027a0:	c58080e7          	jalr	-936(ra) # 800023f4 <wakeup>
  release(&tickslock);
    800027a4:	8526                	mv	a0,s1
    800027a6:	ffffe097          	auipc	ra,0xffffe
    800027aa:	4e4080e7          	jalr	1252(ra) # 80000c8a <release>
}
    800027ae:	60e2                	ld	ra,24(sp)
    800027b0:	6442                	ld	s0,16(sp)
    800027b2:	64a2                	ld	s1,8(sp)
    800027b4:	6105                	addi	sp,sp,32
    800027b6:	8082                	ret

00000000800027b8 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    800027b8:	1101                	addi	sp,sp,-32
    800027ba:	ec06                	sd	ra,24(sp)
    800027bc:	e822                	sd	s0,16(sp)
    800027be:	e426                	sd	s1,8(sp)
    800027c0:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    800027c2:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    800027c6:	00074d63          	bltz	a4,800027e0 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    800027ca:	57fd                	li	a5,-1
    800027cc:	17fe                	slli	a5,a5,0x3f
    800027ce:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    800027d0:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    800027d2:	06f70363          	beq	a4,a5,80002838 <devintr+0x80>
  }
}
    800027d6:	60e2                	ld	ra,24(sp)
    800027d8:	6442                	ld	s0,16(sp)
    800027da:	64a2                	ld	s1,8(sp)
    800027dc:	6105                	addi	sp,sp,32
    800027de:	8082                	ret
     (scause & 0xff) == 9){
    800027e0:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    800027e4:	46a5                	li	a3,9
    800027e6:	fed792e3          	bne	a5,a3,800027ca <devintr+0x12>
    int irq = plic_claim();
    800027ea:	00004097          	auipc	ra,0x4
    800027ee:	85e080e7          	jalr	-1954(ra) # 80006048 <plic_claim>
    800027f2:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    800027f4:	47a9                	li	a5,10
    800027f6:	02f50763          	beq	a0,a5,80002824 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    800027fa:	4785                	li	a5,1
    800027fc:	02f50963          	beq	a0,a5,8000282e <devintr+0x76>
    return 1;
    80002800:	4505                	li	a0,1
    } else if(irq){
    80002802:	d8f1                	beqz	s1,800027d6 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80002804:	85a6                	mv	a1,s1
    80002806:	00006517          	auipc	a0,0x6
    8000280a:	a9250513          	addi	a0,a0,-1390 # 80008298 <states.1785+0x30>
    8000280e:	ffffe097          	auipc	ra,0xffffe
    80002812:	d6c080e7          	jalr	-660(ra) # 8000057a <printf>
      plic_complete(irq);
    80002816:	8526                	mv	a0,s1
    80002818:	00004097          	auipc	ra,0x4
    8000281c:	854080e7          	jalr	-1964(ra) # 8000606c <plic_complete>
    return 1;
    80002820:	4505                	li	a0,1
    80002822:	bf55                	j	800027d6 <devintr+0x1e>
      uartintr();
    80002824:	ffffe097          	auipc	ra,0xffffe
    80002828:	176080e7          	jalr	374(ra) # 8000099a <uartintr>
    8000282c:	b7ed                	j	80002816 <devintr+0x5e>
      virtio_disk_intr();
    8000282e:	00004097          	auipc	ra,0x4
    80002832:	d1e080e7          	jalr	-738(ra) # 8000654c <virtio_disk_intr>
    80002836:	b7c5                	j	80002816 <devintr+0x5e>
    if(cpuid() == 0){
    80002838:	fffff097          	auipc	ra,0xfffff
    8000283c:	142080e7          	jalr	322(ra) # 8000197a <cpuid>
    80002840:	c901                	beqz	a0,80002850 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80002842:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80002846:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80002848:	14479073          	csrw	sip,a5
    return 2;
    8000284c:	4509                	li	a0,2
    8000284e:	b761                	j	800027d6 <devintr+0x1e>
      clockintr();
    80002850:	00000097          	auipc	ra,0x0
    80002854:	f22080e7          	jalr	-222(ra) # 80002772 <clockintr>
    80002858:	b7ed                	j	80002842 <devintr+0x8a>

000000008000285a <usertrap>:
{
    8000285a:	7139                	addi	sp,sp,-64
    8000285c:	fc06                	sd	ra,56(sp)
    8000285e:	f822                	sd	s0,48(sp)
    80002860:	f426                	sd	s1,40(sp)
    80002862:	f04a                	sd	s2,32(sp)
    80002864:	ec4e                	sd	s3,24(sp)
    80002866:	e852                	sd	s4,16(sp)
    80002868:	e456                	sd	s5,8(sp)
    8000286a:	0080                	addi	s0,sp,64
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000286c:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002870:	1007f793          	andi	a5,a5,256
    80002874:	e7ad                	bnez	a5,800028de <usertrap+0x84>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002876:	00003797          	auipc	a5,0x3
    8000287a:	6ca78793          	addi	a5,a5,1738 # 80005f40 <kernelvec>
    8000287e:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002882:	fffff097          	auipc	ra,0xfffff
    80002886:	124080e7          	jalr	292(ra) # 800019a6 <myproc>
    8000288a:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    8000288c:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000288e:	14102773          	csrr	a4,sepc
    80002892:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002894:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80002898:	47a1                	li	a5,8
    8000289a:	06f71063          	bne	a4,a5,800028fa <usertrap+0xa0>
    if(p->killed)
    8000289e:	591c                	lw	a5,48(a0)
    800028a0:	e7b9                	bnez	a5,800028ee <usertrap+0x94>
    p->trapframe->epc += 4;
    800028a2:	6cb8                	ld	a4,88(s1)
    800028a4:	6f1c                	ld	a5,24(a4)
    800028a6:	0791                	addi	a5,a5,4
    800028a8:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800028aa:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800028ae:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800028b2:	10079073          	csrw	sstatus,a5
    syscall();
    800028b6:	00000097          	auipc	ra,0x0
    800028ba:	43a080e7          	jalr	1082(ra) # 80002cf0 <syscall>
  if(p->killed)
    800028be:	589c                	lw	a5,48(s1)
    800028c0:	1c079963          	bnez	a5,80002a92 <usertrap+0x238>
  usertrapret();
    800028c4:	00000097          	auipc	ra,0x0
    800028c8:	e10080e7          	jalr	-496(ra) # 800026d4 <usertrapret>
}
    800028cc:	70e2                	ld	ra,56(sp)
    800028ce:	7442                	ld	s0,48(sp)
    800028d0:	74a2                	ld	s1,40(sp)
    800028d2:	7902                	ld	s2,32(sp)
    800028d4:	69e2                	ld	s3,24(sp)
    800028d6:	6a42                	ld	s4,16(sp)
    800028d8:	6aa2                	ld	s5,8(sp)
    800028da:	6121                	addi	sp,sp,64
    800028dc:	8082                	ret
    panic("usertrap: not from user mode");
    800028de:	00006517          	auipc	a0,0x6
    800028e2:	9da50513          	addi	a0,a0,-1574 # 800082b8 <states.1785+0x50>
    800028e6:	ffffe097          	auipc	ra,0xffffe
    800028ea:	c4a080e7          	jalr	-950(ra) # 80000530 <panic>
      exit(-1);
    800028ee:	557d                	li	a0,-1
    800028f0:	fffff097          	auipc	ra,0xfffff
    800028f4:	7c0080e7          	jalr	1984(ra) # 800020b0 <exit>
    800028f8:	b76d                	j	800028a2 <usertrap+0x48>
  } else if((which_dev = devintr()) != 0){
    800028fa:	00000097          	auipc	ra,0x0
    800028fe:	ebe080e7          	jalr	-322(ra) # 800027b8 <devintr>
    80002902:	892a                	mv	s2,a0
    80002904:	18051463          	bnez	a0,80002a8c <usertrap+0x232>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002908:	14202773          	csrr	a4,scause
  else if(r_scause() == 13 || r_scause() == 15 || r_scause()== 12){
    8000290c:	47b5                	li	a5,13
    8000290e:	00f70c63          	beq	a4,a5,80002926 <usertrap+0xcc>
    80002912:	14202773          	csrr	a4,scause
    80002916:	47bd                	li	a5,15
    80002918:	00f70763          	beq	a4,a5,80002926 <usertrap+0xcc>
    8000291c:	14202773          	csrr	a4,scause
    80002920:	47b1                	li	a5,12
    80002922:	12f71b63          	bne	a4,a5,80002a58 <usertrap+0x1fe>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002926:	143029f3          	csrr	s3,stval
    struct proc* p = myproc();
    8000292a:	fffff097          	auipc	ra,0xfffff
    8000292e:	07c080e7          	jalr	124(ra) # 800019a6 <myproc>
    80002932:	8a2a                	mv	s4,a0
    if(va > MAXVA || va > p->sz){
    80002934:	4785                	li	a5,1
    80002936:	179a                	slli	a5,a5,0x26
    80002938:	0137e563          	bltu	a5,s3,80002942 <usertrap+0xe8>
    8000293c:	653c                	ld	a5,72(a0)
    8000293e:	0137fe63          	bgeu	a5,s3,8000295a <usertrap+0x100>
      printf("usertrap: sz over\n");
    80002942:	00006517          	auipc	a0,0x6
    80002946:	99650513          	addi	a0,a0,-1642 # 800082d8 <states.1785+0x70>
    8000294a:	ffffe097          	auipc	ra,0xffffe
    8000294e:	c30080e7          	jalr	-976(ra) # 8000057a <printf>
      p->killed = 1;
    80002952:	4785                	li	a5,1
    80002954:	02fa2823          	sw	a5,48(s4)
    80002958:	b79d                	j	800028be <usertrap+0x64>
    8000295a:	16850793          	addi	a5,a0,360
	if(p->vma[i].used == 1 && p->vma[i].addr <= va &&  va < (p->vma[i].addr + p->vma[i].length)){
    8000295e:	4605                	li	a2,1
      for(int i = 0; i < 16; i++){
    80002960:	45c1                	li	a1,16
    80002962:	a015                	j	80002986 <usertrap+0x12c>
	    printf("mmap:kalloc() failed\n");
    80002964:	00006517          	auipc	a0,0x6
    80002968:	98c50513          	addi	a0,a0,-1652 # 800082f0 <states.1785+0x88>
    8000296c:	ffffe097          	auipc	ra,0xffffe
    80002970:	c0e080e7          	jalr	-1010(ra) # 8000057a <printf>
	    p->killed = 1;
    80002974:	4785                	li	a5,1
    80002976:	02fa2823          	sw	a5,48(s4)
    8000297a:	a80d                	j	800029ac <usertrap+0x152>
      for(int i = 0; i < 16; i++){
    8000297c:	2905                	addiw	s2,s2,1
    8000297e:	04078793          	addi	a5,a5,64
    80002982:	0cb90763          	beq	s2,a1,80002a50 <usertrap+0x1f6>
	if(p->vma[i].used == 1 && p->vma[i].addr <= va &&  va < (p->vma[i].addr + p->vma[i].length)){
    80002986:	4398                	lw	a4,0(a5)
    80002988:	fec71ae3          	bne	a4,a2,8000297c <usertrap+0x122>
    8000298c:	6798                	ld	a4,8(a5)
    8000298e:	fee9e7e3          	bltu	s3,a4,8000297c <usertrap+0x122>
    80002992:	4b94                	lw	a3,16(a5)
    80002994:	9736                	add	a4,a4,a3
    80002996:	fee9f3e3          	bgeu	s3,a4,8000297c <usertrap+0x122>
	  va = PGROUNDDOWN(va);
    8000299a:	7afd                	lui	s5,0xfffff
    8000299c:	0159fab3          	and	s5,s3,s5
	  uint64 mem = (uint64)kalloc();
    800029a0:	ffffe097          	auipc	ra,0xffffe
    800029a4:	146080e7          	jalr	326(ra) # 80000ae6 <kalloc>
    800029a8:	89aa                	mv	s3,a0
	  if(mem == 0){
    800029aa:	dd4d                	beqz	a0,80002964 <usertrap+0x10a>
	   memset((void* )mem, 0, PGSIZE);
    800029ac:	6605                	lui	a2,0x1
    800029ae:	4581                	li	a1,0
    800029b0:	854e                	mv	a0,s3
    800029b2:	ffffe097          	auipc	ra,0xffffe
    800029b6:	320080e7          	jalr	800(ra) # 80000cd2 <memset>
	   ilock(vma->mapfile->ip);
    800029ba:	091a                	slli	s2,s2,0x6
    800029bc:	9952                	add	s2,s2,s4
    800029be:	19893783          	ld	a5,408(s2)
    800029c2:	6f88                	ld	a0,24(a5)
    800029c4:	00001097          	auipc	ra,0x1
    800029c8:	e2a080e7          	jalr	-470(ra) # 800037ee <ilock>
	   readi(vma->mapfile->ip, 0, (uint64)mem, p->vma[i].offset + PGROUNDDOWN(va - p->vma[i].addr), PGSIZE);
    800029cc:	17093783          	ld	a5,368(s2)
    800029d0:	40fa87bb          	subw	a5,s5,a5
    800029d4:	777d                	lui	a4,0xfffff
    800029d6:	8ff9                	and	a5,a5,a4
    800029d8:	1a093683          	ld	a3,416(s2)
    800029dc:	19893503          	ld	a0,408(s2)
    800029e0:	6705                	lui	a4,0x1
    800029e2:	9ebd                	addw	a3,a3,a5
    800029e4:	864e                	mv	a2,s3
    800029e6:	4581                	li	a1,0
    800029e8:	6d08                	ld	a0,24(a0)
    800029ea:	00001097          	auipc	ra,0x1
    800029ee:	0b8080e7          	jalr	184(ra) # 80003aa2 <readi>
	   iunlock(vma->mapfile->ip);
    800029f2:	19893783          	ld	a5,408(s2)
    800029f6:	6f88                	ld	a0,24(a5)
    800029f8:	00001097          	auipc	ra,0x1
    800029fc:	eb8080e7          	jalr	-328(ra) # 800038b0 <iunlock>
	   if(p->vma[i].prot & PROT_READ)
    80002a00:	18093783          	ld	a5,384(s2)
    80002a04:	0017f693          	andi	a3,a5,1
	   int perm = PTE_U;
    80002a08:	4741                	li	a4,16
	   if(p->vma[i].prot & PROT_READ)
    80002a0a:	c291                	beqz	a3,80002a0e <usertrap+0x1b4>
	     perm |= PTE_R;
    80002a0c:	4749                	li	a4,18
	   if(p->vma[i].prot & PROT_WRITE)
    80002a0e:	0027f693          	andi	a3,a5,2
    80002a12:	c299                	beqz	a3,80002a18 <usertrap+0x1be>
	     perm |= PTE_W;
    80002a14:	00476713          	ori	a4,a4,4
	   if(p->vma[i].prot & PROT_EXEC)
    80002a18:	8b91                	andi	a5,a5,4
    80002a1a:	c399                	beqz	a5,80002a20 <usertrap+0x1c6>
	     perm |= PTE_X;
    80002a1c:	00876713          	ori	a4,a4,8
	   if(mappages(p->pagetable, va, PGSIZE, mem, perm) < 0){
    80002a20:	86ce                	mv	a3,s3
    80002a22:	6605                	lui	a2,0x1
    80002a24:	85d6                	mv	a1,s5
    80002a26:	050a3503          	ld	a0,80(s4)
    80002a2a:	ffffe097          	auipc	ra,0xffffe
    80002a2e:	67c080e7          	jalr	1660(ra) # 800010a6 <mappages>
    80002a32:	e80556e3          	bgez	a0,800028be <usertrap+0x64>
	     printf("usertrap:mappages failed\n");
    80002a36:	00006517          	auipc	a0,0x6
    80002a3a:	8d250513          	addi	a0,a0,-1838 # 80008308 <states.1785+0xa0>
    80002a3e:	ffffe097          	auipc	ra,0xffffe
    80002a42:	b3c080e7          	jalr	-1220(ra) # 8000057a <printf>
	     kfree((void* )mem);
    80002a46:	854e                	mv	a0,s3
    80002a48:	ffffe097          	auipc	ra,0xffffe
    80002a4c:	fa2080e7          	jalr	-94(ra) # 800009ea <kfree>
	  p->killed = 1;
    80002a50:	4785                	li	a5,1
    80002a52:	02fa2823          	sw	a5,48(s4)
    80002a56:	b5a5                	j	800028be <usertrap+0x64>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002a58:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80002a5c:	5c90                	lw	a2,56(s1)
    80002a5e:	00006517          	auipc	a0,0x6
    80002a62:	8ca50513          	addi	a0,a0,-1846 # 80008328 <states.1785+0xc0>
    80002a66:	ffffe097          	auipc	ra,0xffffe
    80002a6a:	b14080e7          	jalr	-1260(ra) # 8000057a <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002a6e:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002a72:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002a76:	00006517          	auipc	a0,0x6
    80002a7a:	8e250513          	addi	a0,a0,-1822 # 80008358 <states.1785+0xf0>
    80002a7e:	ffffe097          	auipc	ra,0xffffe
    80002a82:	afc080e7          	jalr	-1284(ra) # 8000057a <printf>
    p->killed = 1;
    80002a86:	4785                	li	a5,1
    80002a88:	d89c                	sw	a5,48(s1)
  if(p->killed)
    80002a8a:	a029                	j	80002a94 <usertrap+0x23a>
    80002a8c:	589c                	lw	a5,48(s1)
    80002a8e:	cb81                	beqz	a5,80002a9e <usertrap+0x244>
    80002a90:	a011                	j	80002a94 <usertrap+0x23a>
    80002a92:	4901                	li	s2,0
    exit(-1);
    80002a94:	557d                	li	a0,-1
    80002a96:	fffff097          	auipc	ra,0xfffff
    80002a9a:	61a080e7          	jalr	1562(ra) # 800020b0 <exit>
  if(which_dev == 2)
    80002a9e:	4789                	li	a5,2
    80002aa0:	e2f912e3          	bne	s2,a5,800028c4 <usertrap+0x6a>
    yield();
    80002aa4:	fffff097          	auipc	ra,0xfffff
    80002aa8:	78e080e7          	jalr	1934(ra) # 80002232 <yield>
    80002aac:	bd21                	j	800028c4 <usertrap+0x6a>

0000000080002aae <kerneltrap>:
{
    80002aae:	7179                	addi	sp,sp,-48
    80002ab0:	f406                	sd	ra,40(sp)
    80002ab2:	f022                	sd	s0,32(sp)
    80002ab4:	ec26                	sd	s1,24(sp)
    80002ab6:	e84a                	sd	s2,16(sp)
    80002ab8:	e44e                	sd	s3,8(sp)
    80002aba:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002abc:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002ac0:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002ac4:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002ac8:	1004f793          	andi	a5,s1,256
    80002acc:	cb85                	beqz	a5,80002afc <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002ace:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002ad2:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002ad4:	ef85                	bnez	a5,80002b0c <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80002ad6:	00000097          	auipc	ra,0x0
    80002ada:	ce2080e7          	jalr	-798(ra) # 800027b8 <devintr>
    80002ade:	cd1d                	beqz	a0,80002b1c <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002ae0:	4789                	li	a5,2
    80002ae2:	06f50a63          	beq	a0,a5,80002b56 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002ae6:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002aea:	10049073          	csrw	sstatus,s1
}
    80002aee:	70a2                	ld	ra,40(sp)
    80002af0:	7402                	ld	s0,32(sp)
    80002af2:	64e2                	ld	s1,24(sp)
    80002af4:	6942                	ld	s2,16(sp)
    80002af6:	69a2                	ld	s3,8(sp)
    80002af8:	6145                	addi	sp,sp,48
    80002afa:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002afc:	00006517          	auipc	a0,0x6
    80002b00:	87c50513          	addi	a0,a0,-1924 # 80008378 <states.1785+0x110>
    80002b04:	ffffe097          	auipc	ra,0xffffe
    80002b08:	a2c080e7          	jalr	-1492(ra) # 80000530 <panic>
    panic("kerneltrap: interrupts enabled");
    80002b0c:	00006517          	auipc	a0,0x6
    80002b10:	89450513          	addi	a0,a0,-1900 # 800083a0 <states.1785+0x138>
    80002b14:	ffffe097          	auipc	ra,0xffffe
    80002b18:	a1c080e7          	jalr	-1508(ra) # 80000530 <panic>
    printf("scause %p\n", scause);
    80002b1c:	85ce                	mv	a1,s3
    80002b1e:	00006517          	auipc	a0,0x6
    80002b22:	8a250513          	addi	a0,a0,-1886 # 800083c0 <states.1785+0x158>
    80002b26:	ffffe097          	auipc	ra,0xffffe
    80002b2a:	a54080e7          	jalr	-1452(ra) # 8000057a <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002b2e:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002b32:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002b36:	00006517          	auipc	a0,0x6
    80002b3a:	89a50513          	addi	a0,a0,-1894 # 800083d0 <states.1785+0x168>
    80002b3e:	ffffe097          	auipc	ra,0xffffe
    80002b42:	a3c080e7          	jalr	-1476(ra) # 8000057a <printf>
    panic("kerneltrap");
    80002b46:	00006517          	auipc	a0,0x6
    80002b4a:	8a250513          	addi	a0,a0,-1886 # 800083e8 <states.1785+0x180>
    80002b4e:	ffffe097          	auipc	ra,0xffffe
    80002b52:	9e2080e7          	jalr	-1566(ra) # 80000530 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002b56:	fffff097          	auipc	ra,0xfffff
    80002b5a:	e50080e7          	jalr	-432(ra) # 800019a6 <myproc>
    80002b5e:	d541                	beqz	a0,80002ae6 <kerneltrap+0x38>
    80002b60:	fffff097          	auipc	ra,0xfffff
    80002b64:	e46080e7          	jalr	-442(ra) # 800019a6 <myproc>
    80002b68:	4d18                	lw	a4,24(a0)
    80002b6a:	478d                	li	a5,3
    80002b6c:	f6f71de3          	bne	a4,a5,80002ae6 <kerneltrap+0x38>
    yield();
    80002b70:	fffff097          	auipc	ra,0xfffff
    80002b74:	6c2080e7          	jalr	1730(ra) # 80002232 <yield>
    80002b78:	b7bd                	j	80002ae6 <kerneltrap+0x38>

0000000080002b7a <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002b7a:	1101                	addi	sp,sp,-32
    80002b7c:	ec06                	sd	ra,24(sp)
    80002b7e:	e822                	sd	s0,16(sp)
    80002b80:	e426                	sd	s1,8(sp)
    80002b82:	1000                	addi	s0,sp,32
    80002b84:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002b86:	fffff097          	auipc	ra,0xfffff
    80002b8a:	e20080e7          	jalr	-480(ra) # 800019a6 <myproc>
  switch (n) {
    80002b8e:	4795                	li	a5,5
    80002b90:	0497e163          	bltu	a5,s1,80002bd2 <argraw+0x58>
    80002b94:	048a                	slli	s1,s1,0x2
    80002b96:	00006717          	auipc	a4,0x6
    80002b9a:	88a70713          	addi	a4,a4,-1910 # 80008420 <states.1785+0x1b8>
    80002b9e:	94ba                	add	s1,s1,a4
    80002ba0:	409c                	lw	a5,0(s1)
    80002ba2:	97ba                	add	a5,a5,a4
    80002ba4:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002ba6:	6d3c                	ld	a5,88(a0)
    80002ba8:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002baa:	60e2                	ld	ra,24(sp)
    80002bac:	6442                	ld	s0,16(sp)
    80002bae:	64a2                	ld	s1,8(sp)
    80002bb0:	6105                	addi	sp,sp,32
    80002bb2:	8082                	ret
    return p->trapframe->a1;
    80002bb4:	6d3c                	ld	a5,88(a0)
    80002bb6:	7fa8                	ld	a0,120(a5)
    80002bb8:	bfcd                	j	80002baa <argraw+0x30>
    return p->trapframe->a2;
    80002bba:	6d3c                	ld	a5,88(a0)
    80002bbc:	63c8                	ld	a0,128(a5)
    80002bbe:	b7f5                	j	80002baa <argraw+0x30>
    return p->trapframe->a3;
    80002bc0:	6d3c                	ld	a5,88(a0)
    80002bc2:	67c8                	ld	a0,136(a5)
    80002bc4:	b7dd                	j	80002baa <argraw+0x30>
    return p->trapframe->a4;
    80002bc6:	6d3c                	ld	a5,88(a0)
    80002bc8:	6bc8                	ld	a0,144(a5)
    80002bca:	b7c5                	j	80002baa <argraw+0x30>
    return p->trapframe->a5;
    80002bcc:	6d3c                	ld	a5,88(a0)
    80002bce:	6fc8                	ld	a0,152(a5)
    80002bd0:	bfe9                	j	80002baa <argraw+0x30>
  panic("argraw");
    80002bd2:	00006517          	auipc	a0,0x6
    80002bd6:	82650513          	addi	a0,a0,-2010 # 800083f8 <states.1785+0x190>
    80002bda:	ffffe097          	auipc	ra,0xffffe
    80002bde:	956080e7          	jalr	-1706(ra) # 80000530 <panic>

0000000080002be2 <fetchaddr>:
{
    80002be2:	1101                	addi	sp,sp,-32
    80002be4:	ec06                	sd	ra,24(sp)
    80002be6:	e822                	sd	s0,16(sp)
    80002be8:	e426                	sd	s1,8(sp)
    80002bea:	e04a                	sd	s2,0(sp)
    80002bec:	1000                	addi	s0,sp,32
    80002bee:	84aa                	mv	s1,a0
    80002bf0:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002bf2:	fffff097          	auipc	ra,0xfffff
    80002bf6:	db4080e7          	jalr	-588(ra) # 800019a6 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80002bfa:	653c                	ld	a5,72(a0)
    80002bfc:	02f4f863          	bgeu	s1,a5,80002c2c <fetchaddr+0x4a>
    80002c00:	00848713          	addi	a4,s1,8
    80002c04:	02e7e663          	bltu	a5,a4,80002c30 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002c08:	46a1                	li	a3,8
    80002c0a:	8626                	mv	a2,s1
    80002c0c:	85ca                	mv	a1,s2
    80002c0e:	6928                	ld	a0,80(a0)
    80002c10:	fffff097          	auipc	ra,0xfffff
    80002c14:	ab8080e7          	jalr	-1352(ra) # 800016c8 <copyin>
    80002c18:	00a03533          	snez	a0,a0
    80002c1c:	40a00533          	neg	a0,a0
}
    80002c20:	60e2                	ld	ra,24(sp)
    80002c22:	6442                	ld	s0,16(sp)
    80002c24:	64a2                	ld	s1,8(sp)
    80002c26:	6902                	ld	s2,0(sp)
    80002c28:	6105                	addi	sp,sp,32
    80002c2a:	8082                	ret
    return -1;
    80002c2c:	557d                	li	a0,-1
    80002c2e:	bfcd                	j	80002c20 <fetchaddr+0x3e>
    80002c30:	557d                	li	a0,-1
    80002c32:	b7fd                	j	80002c20 <fetchaddr+0x3e>

0000000080002c34 <fetchstr>:
{
    80002c34:	7179                	addi	sp,sp,-48
    80002c36:	f406                	sd	ra,40(sp)
    80002c38:	f022                	sd	s0,32(sp)
    80002c3a:	ec26                	sd	s1,24(sp)
    80002c3c:	e84a                	sd	s2,16(sp)
    80002c3e:	e44e                	sd	s3,8(sp)
    80002c40:	1800                	addi	s0,sp,48
    80002c42:	892a                	mv	s2,a0
    80002c44:	84ae                	mv	s1,a1
    80002c46:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002c48:	fffff097          	auipc	ra,0xfffff
    80002c4c:	d5e080e7          	jalr	-674(ra) # 800019a6 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80002c50:	86ce                	mv	a3,s3
    80002c52:	864a                	mv	a2,s2
    80002c54:	85a6                	mv	a1,s1
    80002c56:	6928                	ld	a0,80(a0)
    80002c58:	fffff097          	auipc	ra,0xfffff
    80002c5c:	afc080e7          	jalr	-1284(ra) # 80001754 <copyinstr>
  if(err < 0)
    80002c60:	00054763          	bltz	a0,80002c6e <fetchstr+0x3a>
  return strlen(buf);
    80002c64:	8526                	mv	a0,s1
    80002c66:	ffffe097          	auipc	ra,0xffffe
    80002c6a:	1f4080e7          	jalr	500(ra) # 80000e5a <strlen>
}
    80002c6e:	70a2                	ld	ra,40(sp)
    80002c70:	7402                	ld	s0,32(sp)
    80002c72:	64e2                	ld	s1,24(sp)
    80002c74:	6942                	ld	s2,16(sp)
    80002c76:	69a2                	ld	s3,8(sp)
    80002c78:	6145                	addi	sp,sp,48
    80002c7a:	8082                	ret

0000000080002c7c <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002c7c:	1101                	addi	sp,sp,-32
    80002c7e:	ec06                	sd	ra,24(sp)
    80002c80:	e822                	sd	s0,16(sp)
    80002c82:	e426                	sd	s1,8(sp)
    80002c84:	1000                	addi	s0,sp,32
    80002c86:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002c88:	00000097          	auipc	ra,0x0
    80002c8c:	ef2080e7          	jalr	-270(ra) # 80002b7a <argraw>
    80002c90:	c088                	sw	a0,0(s1)
  return 0;
}
    80002c92:	4501                	li	a0,0
    80002c94:	60e2                	ld	ra,24(sp)
    80002c96:	6442                	ld	s0,16(sp)
    80002c98:	64a2                	ld	s1,8(sp)
    80002c9a:	6105                	addi	sp,sp,32
    80002c9c:	8082                	ret

0000000080002c9e <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80002c9e:	1101                	addi	sp,sp,-32
    80002ca0:	ec06                	sd	ra,24(sp)
    80002ca2:	e822                	sd	s0,16(sp)
    80002ca4:	e426                	sd	s1,8(sp)
    80002ca6:	1000                	addi	s0,sp,32
    80002ca8:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002caa:	00000097          	auipc	ra,0x0
    80002cae:	ed0080e7          	jalr	-304(ra) # 80002b7a <argraw>
    80002cb2:	e088                	sd	a0,0(s1)
  return 0;
}
    80002cb4:	4501                	li	a0,0
    80002cb6:	60e2                	ld	ra,24(sp)
    80002cb8:	6442                	ld	s0,16(sp)
    80002cba:	64a2                	ld	s1,8(sp)
    80002cbc:	6105                	addi	sp,sp,32
    80002cbe:	8082                	ret

0000000080002cc0 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002cc0:	1101                	addi	sp,sp,-32
    80002cc2:	ec06                	sd	ra,24(sp)
    80002cc4:	e822                	sd	s0,16(sp)
    80002cc6:	e426                	sd	s1,8(sp)
    80002cc8:	e04a                	sd	s2,0(sp)
    80002cca:	1000                	addi	s0,sp,32
    80002ccc:	84ae                	mv	s1,a1
    80002cce:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002cd0:	00000097          	auipc	ra,0x0
    80002cd4:	eaa080e7          	jalr	-342(ra) # 80002b7a <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002cd8:	864a                	mv	a2,s2
    80002cda:	85a6                	mv	a1,s1
    80002cdc:	00000097          	auipc	ra,0x0
    80002ce0:	f58080e7          	jalr	-168(ra) # 80002c34 <fetchstr>
}
    80002ce4:	60e2                	ld	ra,24(sp)
    80002ce6:	6442                	ld	s0,16(sp)
    80002ce8:	64a2                	ld	s1,8(sp)
    80002cea:	6902                	ld	s2,0(sp)
    80002cec:	6105                	addi	sp,sp,32
    80002cee:	8082                	ret

0000000080002cf0 <syscall>:
[SYS_munmap]  sys_munmap,
};

void
syscall(void)
{
    80002cf0:	1101                	addi	sp,sp,-32
    80002cf2:	ec06                	sd	ra,24(sp)
    80002cf4:	e822                	sd	s0,16(sp)
    80002cf6:	e426                	sd	s1,8(sp)
    80002cf8:	e04a                	sd	s2,0(sp)
    80002cfa:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002cfc:	fffff097          	auipc	ra,0xfffff
    80002d00:	caa080e7          	jalr	-854(ra) # 800019a6 <myproc>
    80002d04:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002d06:	05853903          	ld	s2,88(a0)
    80002d0a:	0a893783          	ld	a5,168(s2)
    80002d0e:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002d12:	37fd                	addiw	a5,a5,-1
    80002d14:	4759                	li	a4,22
    80002d16:	00f76f63          	bltu	a4,a5,80002d34 <syscall+0x44>
    80002d1a:	00369713          	slli	a4,a3,0x3
    80002d1e:	00005797          	auipc	a5,0x5
    80002d22:	71a78793          	addi	a5,a5,1818 # 80008438 <syscalls>
    80002d26:	97ba                	add	a5,a5,a4
    80002d28:	639c                	ld	a5,0(a5)
    80002d2a:	c789                	beqz	a5,80002d34 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80002d2c:	9782                	jalr	a5
    80002d2e:	06a93823          	sd	a0,112(s2)
    80002d32:	a839                	j	80002d50 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002d34:	15848613          	addi	a2,s1,344
    80002d38:	5c8c                	lw	a1,56(s1)
    80002d3a:	00005517          	auipc	a0,0x5
    80002d3e:	6c650513          	addi	a0,a0,1734 # 80008400 <states.1785+0x198>
    80002d42:	ffffe097          	auipc	ra,0xffffe
    80002d46:	838080e7          	jalr	-1992(ra) # 8000057a <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002d4a:	6cbc                	ld	a5,88(s1)
    80002d4c:	577d                	li	a4,-1
    80002d4e:	fbb8                	sd	a4,112(a5)
  }
}
    80002d50:	60e2                	ld	ra,24(sp)
    80002d52:	6442                	ld	s0,16(sp)
    80002d54:	64a2                	ld	s1,8(sp)
    80002d56:	6902                	ld	s2,0(sp)
    80002d58:	6105                	addi	sp,sp,32
    80002d5a:	8082                	ret

0000000080002d5c <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002d5c:	1101                	addi	sp,sp,-32
    80002d5e:	ec06                	sd	ra,24(sp)
    80002d60:	e822                	sd	s0,16(sp)
    80002d62:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002d64:	fec40593          	addi	a1,s0,-20
    80002d68:	4501                	li	a0,0
    80002d6a:	00000097          	auipc	ra,0x0
    80002d6e:	f12080e7          	jalr	-238(ra) # 80002c7c <argint>
    return -1;
    80002d72:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002d74:	00054963          	bltz	a0,80002d86 <sys_exit+0x2a>
  exit(n);
    80002d78:	fec42503          	lw	a0,-20(s0)
    80002d7c:	fffff097          	auipc	ra,0xfffff
    80002d80:	334080e7          	jalr	820(ra) # 800020b0 <exit>
  return 0;  // not reached
    80002d84:	4781                	li	a5,0
}
    80002d86:	853e                	mv	a0,a5
    80002d88:	60e2                	ld	ra,24(sp)
    80002d8a:	6442                	ld	s0,16(sp)
    80002d8c:	6105                	addi	sp,sp,32
    80002d8e:	8082                	ret

0000000080002d90 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002d90:	1141                	addi	sp,sp,-16
    80002d92:	e406                	sd	ra,8(sp)
    80002d94:	e022                	sd	s0,0(sp)
    80002d96:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002d98:	fffff097          	auipc	ra,0xfffff
    80002d9c:	c0e080e7          	jalr	-1010(ra) # 800019a6 <myproc>
}
    80002da0:	5d08                	lw	a0,56(a0)
    80002da2:	60a2                	ld	ra,8(sp)
    80002da4:	6402                	ld	s0,0(sp)
    80002da6:	0141                	addi	sp,sp,16
    80002da8:	8082                	ret

0000000080002daa <sys_fork>:

uint64
sys_fork(void)
{
    80002daa:	1141                	addi	sp,sp,-16
    80002dac:	e406                	sd	ra,8(sp)
    80002dae:	e022                	sd	s0,0(sp)
    80002db0:	0800                	addi	s0,sp,16
  return fork();
    80002db2:	fffff097          	auipc	ra,0xfffff
    80002db6:	fb4080e7          	jalr	-76(ra) # 80001d66 <fork>
}
    80002dba:	60a2                	ld	ra,8(sp)
    80002dbc:	6402                	ld	s0,0(sp)
    80002dbe:	0141                	addi	sp,sp,16
    80002dc0:	8082                	ret

0000000080002dc2 <sys_wait>:

uint64
sys_wait(void)
{
    80002dc2:	1101                	addi	sp,sp,-32
    80002dc4:	ec06                	sd	ra,24(sp)
    80002dc6:	e822                	sd	s0,16(sp)
    80002dc8:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002dca:	fe840593          	addi	a1,s0,-24
    80002dce:	4501                	li	a0,0
    80002dd0:	00000097          	auipc	ra,0x0
    80002dd4:	ece080e7          	jalr	-306(ra) # 80002c9e <argaddr>
    80002dd8:	87aa                	mv	a5,a0
    return -1;
    80002dda:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002ddc:	0007c863          	bltz	a5,80002dec <sys_wait+0x2a>
  return wait(p);
    80002de0:	fe843503          	ld	a0,-24(s0)
    80002de4:	fffff097          	auipc	ra,0xfffff
    80002de8:	508080e7          	jalr	1288(ra) # 800022ec <wait>
}
    80002dec:	60e2                	ld	ra,24(sp)
    80002dee:	6442                	ld	s0,16(sp)
    80002df0:	6105                	addi	sp,sp,32
    80002df2:	8082                	ret

0000000080002df4 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002df4:	7179                	addi	sp,sp,-48
    80002df6:	f406                	sd	ra,40(sp)
    80002df8:	f022                	sd	s0,32(sp)
    80002dfa:	ec26                	sd	s1,24(sp)
    80002dfc:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002dfe:	fdc40593          	addi	a1,s0,-36
    80002e02:	4501                	li	a0,0
    80002e04:	00000097          	auipc	ra,0x0
    80002e08:	e78080e7          	jalr	-392(ra) # 80002c7c <argint>
    80002e0c:	87aa                	mv	a5,a0
    return -1;
    80002e0e:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    80002e10:	0207c063          	bltz	a5,80002e30 <sys_sbrk+0x3c>
  addr = myproc()->sz;
    80002e14:	fffff097          	auipc	ra,0xfffff
    80002e18:	b92080e7          	jalr	-1134(ra) # 800019a6 <myproc>
    80002e1c:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80002e1e:	fdc42503          	lw	a0,-36(s0)
    80002e22:	fffff097          	auipc	ra,0xfffff
    80002e26:	ed0080e7          	jalr	-304(ra) # 80001cf2 <growproc>
    80002e2a:	00054863          	bltz	a0,80002e3a <sys_sbrk+0x46>
    return -1;
  return addr;
    80002e2e:	8526                	mv	a0,s1
}
    80002e30:	70a2                	ld	ra,40(sp)
    80002e32:	7402                	ld	s0,32(sp)
    80002e34:	64e2                	ld	s1,24(sp)
    80002e36:	6145                	addi	sp,sp,48
    80002e38:	8082                	ret
    return -1;
    80002e3a:	557d                	li	a0,-1
    80002e3c:	bfd5                	j	80002e30 <sys_sbrk+0x3c>

0000000080002e3e <sys_sleep>:

uint64
sys_sleep(void)
{
    80002e3e:	7139                	addi	sp,sp,-64
    80002e40:	fc06                	sd	ra,56(sp)
    80002e42:	f822                	sd	s0,48(sp)
    80002e44:	f426                	sd	s1,40(sp)
    80002e46:	f04a                	sd	s2,32(sp)
    80002e48:	ec4e                	sd	s3,24(sp)
    80002e4a:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80002e4c:	fcc40593          	addi	a1,s0,-52
    80002e50:	4501                	li	a0,0
    80002e52:	00000097          	auipc	ra,0x0
    80002e56:	e2a080e7          	jalr	-470(ra) # 80002c7c <argint>
    return -1;
    80002e5a:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002e5c:	06054563          	bltz	a0,80002ec6 <sys_sleep+0x88>
  acquire(&tickslock);
    80002e60:	00024517          	auipc	a0,0x24
    80002e64:	25850513          	addi	a0,a0,600 # 800270b8 <tickslock>
    80002e68:	ffffe097          	auipc	ra,0xffffe
    80002e6c:	d6e080e7          	jalr	-658(ra) # 80000bd6 <acquire>
  ticks0 = ticks;
    80002e70:	00006917          	auipc	s2,0x6
    80002e74:	1c092903          	lw	s2,448(s2) # 80009030 <ticks>
  while(ticks - ticks0 < n){
    80002e78:	fcc42783          	lw	a5,-52(s0)
    80002e7c:	cf85                	beqz	a5,80002eb4 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002e7e:	00024997          	auipc	s3,0x24
    80002e82:	23a98993          	addi	s3,s3,570 # 800270b8 <tickslock>
    80002e86:	00006497          	auipc	s1,0x6
    80002e8a:	1aa48493          	addi	s1,s1,426 # 80009030 <ticks>
    if(myproc()->killed){
    80002e8e:	fffff097          	auipc	ra,0xfffff
    80002e92:	b18080e7          	jalr	-1256(ra) # 800019a6 <myproc>
    80002e96:	591c                	lw	a5,48(a0)
    80002e98:	ef9d                	bnez	a5,80002ed6 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80002e9a:	85ce                	mv	a1,s3
    80002e9c:	8526                	mv	a0,s1
    80002e9e:	fffff097          	auipc	ra,0xfffff
    80002ea2:	3d0080e7          	jalr	976(ra) # 8000226e <sleep>
  while(ticks - ticks0 < n){
    80002ea6:	409c                	lw	a5,0(s1)
    80002ea8:	412787bb          	subw	a5,a5,s2
    80002eac:	fcc42703          	lw	a4,-52(s0)
    80002eb0:	fce7efe3          	bltu	a5,a4,80002e8e <sys_sleep+0x50>
  }
  release(&tickslock);
    80002eb4:	00024517          	auipc	a0,0x24
    80002eb8:	20450513          	addi	a0,a0,516 # 800270b8 <tickslock>
    80002ebc:	ffffe097          	auipc	ra,0xffffe
    80002ec0:	dce080e7          	jalr	-562(ra) # 80000c8a <release>
  return 0;
    80002ec4:	4781                	li	a5,0
}
    80002ec6:	853e                	mv	a0,a5
    80002ec8:	70e2                	ld	ra,56(sp)
    80002eca:	7442                	ld	s0,48(sp)
    80002ecc:	74a2                	ld	s1,40(sp)
    80002ece:	7902                	ld	s2,32(sp)
    80002ed0:	69e2                	ld	s3,24(sp)
    80002ed2:	6121                	addi	sp,sp,64
    80002ed4:	8082                	ret
      release(&tickslock);
    80002ed6:	00024517          	auipc	a0,0x24
    80002eda:	1e250513          	addi	a0,a0,482 # 800270b8 <tickslock>
    80002ede:	ffffe097          	auipc	ra,0xffffe
    80002ee2:	dac080e7          	jalr	-596(ra) # 80000c8a <release>
      return -1;
    80002ee6:	57fd                	li	a5,-1
    80002ee8:	bff9                	j	80002ec6 <sys_sleep+0x88>

0000000080002eea <sys_kill>:

uint64
sys_kill(void)
{
    80002eea:	1101                	addi	sp,sp,-32
    80002eec:	ec06                	sd	ra,24(sp)
    80002eee:	e822                	sd	s0,16(sp)
    80002ef0:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002ef2:	fec40593          	addi	a1,s0,-20
    80002ef6:	4501                	li	a0,0
    80002ef8:	00000097          	auipc	ra,0x0
    80002efc:	d84080e7          	jalr	-636(ra) # 80002c7c <argint>
    80002f00:	87aa                	mv	a5,a0
    return -1;
    80002f02:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002f04:	0007c863          	bltz	a5,80002f14 <sys_kill+0x2a>
  return kill(pid);
    80002f08:	fec42503          	lw	a0,-20(s0)
    80002f0c:	fffff097          	auipc	ra,0xfffff
    80002f10:	552080e7          	jalr	1362(ra) # 8000245e <kill>
}
    80002f14:	60e2                	ld	ra,24(sp)
    80002f16:	6442                	ld	s0,16(sp)
    80002f18:	6105                	addi	sp,sp,32
    80002f1a:	8082                	ret

0000000080002f1c <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002f1c:	1101                	addi	sp,sp,-32
    80002f1e:	ec06                	sd	ra,24(sp)
    80002f20:	e822                	sd	s0,16(sp)
    80002f22:	e426                	sd	s1,8(sp)
    80002f24:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002f26:	00024517          	auipc	a0,0x24
    80002f2a:	19250513          	addi	a0,a0,402 # 800270b8 <tickslock>
    80002f2e:	ffffe097          	auipc	ra,0xffffe
    80002f32:	ca8080e7          	jalr	-856(ra) # 80000bd6 <acquire>
  xticks = ticks;
    80002f36:	00006497          	auipc	s1,0x6
    80002f3a:	0fa4a483          	lw	s1,250(s1) # 80009030 <ticks>
  release(&tickslock);
    80002f3e:	00024517          	auipc	a0,0x24
    80002f42:	17a50513          	addi	a0,a0,378 # 800270b8 <tickslock>
    80002f46:	ffffe097          	auipc	ra,0xffffe
    80002f4a:	d44080e7          	jalr	-700(ra) # 80000c8a <release>
  return xticks;
}
    80002f4e:	02049513          	slli	a0,s1,0x20
    80002f52:	9101                	srli	a0,a0,0x20
    80002f54:	60e2                	ld	ra,24(sp)
    80002f56:	6442                	ld	s0,16(sp)
    80002f58:	64a2                	ld	s1,8(sp)
    80002f5a:	6105                	addi	sp,sp,32
    80002f5c:	8082                	ret

0000000080002f5e <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002f5e:	7179                	addi	sp,sp,-48
    80002f60:	f406                	sd	ra,40(sp)
    80002f62:	f022                	sd	s0,32(sp)
    80002f64:	ec26                	sd	s1,24(sp)
    80002f66:	e84a                	sd	s2,16(sp)
    80002f68:	e44e                	sd	s3,8(sp)
    80002f6a:	e052                	sd	s4,0(sp)
    80002f6c:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002f6e:	00005597          	auipc	a1,0x5
    80002f72:	58a58593          	addi	a1,a1,1418 # 800084f8 <syscalls+0xc0>
    80002f76:	00024517          	auipc	a0,0x24
    80002f7a:	15a50513          	addi	a0,a0,346 # 800270d0 <bcache>
    80002f7e:	ffffe097          	auipc	ra,0xffffe
    80002f82:	bc8080e7          	jalr	-1080(ra) # 80000b46 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002f86:	0002c797          	auipc	a5,0x2c
    80002f8a:	14a78793          	addi	a5,a5,330 # 8002f0d0 <bcache+0x8000>
    80002f8e:	0002c717          	auipc	a4,0x2c
    80002f92:	3aa70713          	addi	a4,a4,938 # 8002f338 <bcache+0x8268>
    80002f96:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002f9a:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002f9e:	00024497          	auipc	s1,0x24
    80002fa2:	14a48493          	addi	s1,s1,330 # 800270e8 <bcache+0x18>
    b->next = bcache.head.next;
    80002fa6:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002fa8:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002faa:	00005a17          	auipc	s4,0x5
    80002fae:	556a0a13          	addi	s4,s4,1366 # 80008500 <syscalls+0xc8>
    b->next = bcache.head.next;
    80002fb2:	2b893783          	ld	a5,696(s2)
    80002fb6:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002fb8:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002fbc:	85d2                	mv	a1,s4
    80002fbe:	01048513          	addi	a0,s1,16
    80002fc2:	00001097          	auipc	ra,0x1
    80002fc6:	4c4080e7          	jalr	1220(ra) # 80004486 <initsleeplock>
    bcache.head.next->prev = b;
    80002fca:	2b893783          	ld	a5,696(s2)
    80002fce:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002fd0:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002fd4:	45848493          	addi	s1,s1,1112
    80002fd8:	fd349de3          	bne	s1,s3,80002fb2 <binit+0x54>
  }
}
    80002fdc:	70a2                	ld	ra,40(sp)
    80002fde:	7402                	ld	s0,32(sp)
    80002fe0:	64e2                	ld	s1,24(sp)
    80002fe2:	6942                	ld	s2,16(sp)
    80002fe4:	69a2                	ld	s3,8(sp)
    80002fe6:	6a02                	ld	s4,0(sp)
    80002fe8:	6145                	addi	sp,sp,48
    80002fea:	8082                	ret

0000000080002fec <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002fec:	7179                	addi	sp,sp,-48
    80002fee:	f406                	sd	ra,40(sp)
    80002ff0:	f022                	sd	s0,32(sp)
    80002ff2:	ec26                	sd	s1,24(sp)
    80002ff4:	e84a                	sd	s2,16(sp)
    80002ff6:	e44e                	sd	s3,8(sp)
    80002ff8:	1800                	addi	s0,sp,48
    80002ffa:	89aa                	mv	s3,a0
    80002ffc:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    80002ffe:	00024517          	auipc	a0,0x24
    80003002:	0d250513          	addi	a0,a0,210 # 800270d0 <bcache>
    80003006:	ffffe097          	auipc	ra,0xffffe
    8000300a:	bd0080e7          	jalr	-1072(ra) # 80000bd6 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000300e:	0002c497          	auipc	s1,0x2c
    80003012:	37a4b483          	ld	s1,890(s1) # 8002f388 <bcache+0x82b8>
    80003016:	0002c797          	auipc	a5,0x2c
    8000301a:	32278793          	addi	a5,a5,802 # 8002f338 <bcache+0x8268>
    8000301e:	02f48f63          	beq	s1,a5,8000305c <bread+0x70>
    80003022:	873e                	mv	a4,a5
    80003024:	a021                	j	8000302c <bread+0x40>
    80003026:	68a4                	ld	s1,80(s1)
    80003028:	02e48a63          	beq	s1,a4,8000305c <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    8000302c:	449c                	lw	a5,8(s1)
    8000302e:	ff379ce3          	bne	a5,s3,80003026 <bread+0x3a>
    80003032:	44dc                	lw	a5,12(s1)
    80003034:	ff2799e3          	bne	a5,s2,80003026 <bread+0x3a>
      b->refcnt++;
    80003038:	40bc                	lw	a5,64(s1)
    8000303a:	2785                	addiw	a5,a5,1
    8000303c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000303e:	00024517          	auipc	a0,0x24
    80003042:	09250513          	addi	a0,a0,146 # 800270d0 <bcache>
    80003046:	ffffe097          	auipc	ra,0xffffe
    8000304a:	c44080e7          	jalr	-956(ra) # 80000c8a <release>
      acquiresleep(&b->lock);
    8000304e:	01048513          	addi	a0,s1,16
    80003052:	00001097          	auipc	ra,0x1
    80003056:	46e080e7          	jalr	1134(ra) # 800044c0 <acquiresleep>
      return b;
    8000305a:	a8b9                	j	800030b8 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000305c:	0002c497          	auipc	s1,0x2c
    80003060:	3244b483          	ld	s1,804(s1) # 8002f380 <bcache+0x82b0>
    80003064:	0002c797          	auipc	a5,0x2c
    80003068:	2d478793          	addi	a5,a5,724 # 8002f338 <bcache+0x8268>
    8000306c:	00f48863          	beq	s1,a5,8000307c <bread+0x90>
    80003070:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80003072:	40bc                	lw	a5,64(s1)
    80003074:	cf81                	beqz	a5,8000308c <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003076:	64a4                	ld	s1,72(s1)
    80003078:	fee49de3          	bne	s1,a4,80003072 <bread+0x86>
  panic("bget: no buffers");
    8000307c:	00005517          	auipc	a0,0x5
    80003080:	48c50513          	addi	a0,a0,1164 # 80008508 <syscalls+0xd0>
    80003084:	ffffd097          	auipc	ra,0xffffd
    80003088:	4ac080e7          	jalr	1196(ra) # 80000530 <panic>
      b->dev = dev;
    8000308c:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    80003090:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    80003094:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80003098:	4785                	li	a5,1
    8000309a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000309c:	00024517          	auipc	a0,0x24
    800030a0:	03450513          	addi	a0,a0,52 # 800270d0 <bcache>
    800030a4:	ffffe097          	auipc	ra,0xffffe
    800030a8:	be6080e7          	jalr	-1050(ra) # 80000c8a <release>
      acquiresleep(&b->lock);
    800030ac:	01048513          	addi	a0,s1,16
    800030b0:	00001097          	auipc	ra,0x1
    800030b4:	410080e7          	jalr	1040(ra) # 800044c0 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800030b8:	409c                	lw	a5,0(s1)
    800030ba:	cb89                	beqz	a5,800030cc <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800030bc:	8526                	mv	a0,s1
    800030be:	70a2                	ld	ra,40(sp)
    800030c0:	7402                	ld	s0,32(sp)
    800030c2:	64e2                	ld	s1,24(sp)
    800030c4:	6942                	ld	s2,16(sp)
    800030c6:	69a2                	ld	s3,8(sp)
    800030c8:	6145                	addi	sp,sp,48
    800030ca:	8082                	ret
    virtio_disk_rw(b, 0);
    800030cc:	4581                	li	a1,0
    800030ce:	8526                	mv	a0,s1
    800030d0:	00003097          	auipc	ra,0x3
    800030d4:	1a6080e7          	jalr	422(ra) # 80006276 <virtio_disk_rw>
    b->valid = 1;
    800030d8:	4785                	li	a5,1
    800030da:	c09c                	sw	a5,0(s1)
  return b;
    800030dc:	b7c5                	j	800030bc <bread+0xd0>

00000000800030de <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800030de:	1101                	addi	sp,sp,-32
    800030e0:	ec06                	sd	ra,24(sp)
    800030e2:	e822                	sd	s0,16(sp)
    800030e4:	e426                	sd	s1,8(sp)
    800030e6:	1000                	addi	s0,sp,32
    800030e8:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800030ea:	0541                	addi	a0,a0,16
    800030ec:	00001097          	auipc	ra,0x1
    800030f0:	46e080e7          	jalr	1134(ra) # 8000455a <holdingsleep>
    800030f4:	cd01                	beqz	a0,8000310c <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800030f6:	4585                	li	a1,1
    800030f8:	8526                	mv	a0,s1
    800030fa:	00003097          	auipc	ra,0x3
    800030fe:	17c080e7          	jalr	380(ra) # 80006276 <virtio_disk_rw>
}
    80003102:	60e2                	ld	ra,24(sp)
    80003104:	6442                	ld	s0,16(sp)
    80003106:	64a2                	ld	s1,8(sp)
    80003108:	6105                	addi	sp,sp,32
    8000310a:	8082                	ret
    panic("bwrite");
    8000310c:	00005517          	auipc	a0,0x5
    80003110:	41450513          	addi	a0,a0,1044 # 80008520 <syscalls+0xe8>
    80003114:	ffffd097          	auipc	ra,0xffffd
    80003118:	41c080e7          	jalr	1052(ra) # 80000530 <panic>

000000008000311c <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000311c:	1101                	addi	sp,sp,-32
    8000311e:	ec06                	sd	ra,24(sp)
    80003120:	e822                	sd	s0,16(sp)
    80003122:	e426                	sd	s1,8(sp)
    80003124:	e04a                	sd	s2,0(sp)
    80003126:	1000                	addi	s0,sp,32
    80003128:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000312a:	01050913          	addi	s2,a0,16
    8000312e:	854a                	mv	a0,s2
    80003130:	00001097          	auipc	ra,0x1
    80003134:	42a080e7          	jalr	1066(ra) # 8000455a <holdingsleep>
    80003138:	c92d                	beqz	a0,800031aa <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    8000313a:	854a                	mv	a0,s2
    8000313c:	00001097          	auipc	ra,0x1
    80003140:	3da080e7          	jalr	986(ra) # 80004516 <releasesleep>

  acquire(&bcache.lock);
    80003144:	00024517          	auipc	a0,0x24
    80003148:	f8c50513          	addi	a0,a0,-116 # 800270d0 <bcache>
    8000314c:	ffffe097          	auipc	ra,0xffffe
    80003150:	a8a080e7          	jalr	-1398(ra) # 80000bd6 <acquire>
  b->refcnt--;
    80003154:	40bc                	lw	a5,64(s1)
    80003156:	37fd                	addiw	a5,a5,-1
    80003158:	0007871b          	sext.w	a4,a5
    8000315c:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000315e:	eb05                	bnez	a4,8000318e <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80003160:	68bc                	ld	a5,80(s1)
    80003162:	64b8                	ld	a4,72(s1)
    80003164:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80003166:	64bc                	ld	a5,72(s1)
    80003168:	68b8                	ld	a4,80(s1)
    8000316a:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000316c:	0002c797          	auipc	a5,0x2c
    80003170:	f6478793          	addi	a5,a5,-156 # 8002f0d0 <bcache+0x8000>
    80003174:	2b87b703          	ld	a4,696(a5)
    80003178:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000317a:	0002c717          	auipc	a4,0x2c
    8000317e:	1be70713          	addi	a4,a4,446 # 8002f338 <bcache+0x8268>
    80003182:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80003184:	2b87b703          	ld	a4,696(a5)
    80003188:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000318a:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000318e:	00024517          	auipc	a0,0x24
    80003192:	f4250513          	addi	a0,a0,-190 # 800270d0 <bcache>
    80003196:	ffffe097          	auipc	ra,0xffffe
    8000319a:	af4080e7          	jalr	-1292(ra) # 80000c8a <release>
}
    8000319e:	60e2                	ld	ra,24(sp)
    800031a0:	6442                	ld	s0,16(sp)
    800031a2:	64a2                	ld	s1,8(sp)
    800031a4:	6902                	ld	s2,0(sp)
    800031a6:	6105                	addi	sp,sp,32
    800031a8:	8082                	ret
    panic("brelse");
    800031aa:	00005517          	auipc	a0,0x5
    800031ae:	37e50513          	addi	a0,a0,894 # 80008528 <syscalls+0xf0>
    800031b2:	ffffd097          	auipc	ra,0xffffd
    800031b6:	37e080e7          	jalr	894(ra) # 80000530 <panic>

00000000800031ba <bpin>:

void
bpin(struct buf *b) {
    800031ba:	1101                	addi	sp,sp,-32
    800031bc:	ec06                	sd	ra,24(sp)
    800031be:	e822                	sd	s0,16(sp)
    800031c0:	e426                	sd	s1,8(sp)
    800031c2:	1000                	addi	s0,sp,32
    800031c4:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800031c6:	00024517          	auipc	a0,0x24
    800031ca:	f0a50513          	addi	a0,a0,-246 # 800270d0 <bcache>
    800031ce:	ffffe097          	auipc	ra,0xffffe
    800031d2:	a08080e7          	jalr	-1528(ra) # 80000bd6 <acquire>
  b->refcnt++;
    800031d6:	40bc                	lw	a5,64(s1)
    800031d8:	2785                	addiw	a5,a5,1
    800031da:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800031dc:	00024517          	auipc	a0,0x24
    800031e0:	ef450513          	addi	a0,a0,-268 # 800270d0 <bcache>
    800031e4:	ffffe097          	auipc	ra,0xffffe
    800031e8:	aa6080e7          	jalr	-1370(ra) # 80000c8a <release>
}
    800031ec:	60e2                	ld	ra,24(sp)
    800031ee:	6442                	ld	s0,16(sp)
    800031f0:	64a2                	ld	s1,8(sp)
    800031f2:	6105                	addi	sp,sp,32
    800031f4:	8082                	ret

00000000800031f6 <bunpin>:

void
bunpin(struct buf *b) {
    800031f6:	1101                	addi	sp,sp,-32
    800031f8:	ec06                	sd	ra,24(sp)
    800031fa:	e822                	sd	s0,16(sp)
    800031fc:	e426                	sd	s1,8(sp)
    800031fe:	1000                	addi	s0,sp,32
    80003200:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003202:	00024517          	auipc	a0,0x24
    80003206:	ece50513          	addi	a0,a0,-306 # 800270d0 <bcache>
    8000320a:	ffffe097          	auipc	ra,0xffffe
    8000320e:	9cc080e7          	jalr	-1588(ra) # 80000bd6 <acquire>
  b->refcnt--;
    80003212:	40bc                	lw	a5,64(s1)
    80003214:	37fd                	addiw	a5,a5,-1
    80003216:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003218:	00024517          	auipc	a0,0x24
    8000321c:	eb850513          	addi	a0,a0,-328 # 800270d0 <bcache>
    80003220:	ffffe097          	auipc	ra,0xffffe
    80003224:	a6a080e7          	jalr	-1430(ra) # 80000c8a <release>
}
    80003228:	60e2                	ld	ra,24(sp)
    8000322a:	6442                	ld	s0,16(sp)
    8000322c:	64a2                	ld	s1,8(sp)
    8000322e:	6105                	addi	sp,sp,32
    80003230:	8082                	ret

0000000080003232 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80003232:	1101                	addi	sp,sp,-32
    80003234:	ec06                	sd	ra,24(sp)
    80003236:	e822                	sd	s0,16(sp)
    80003238:	e426                	sd	s1,8(sp)
    8000323a:	e04a                	sd	s2,0(sp)
    8000323c:	1000                	addi	s0,sp,32
    8000323e:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80003240:	00d5d59b          	srliw	a1,a1,0xd
    80003244:	0002c797          	auipc	a5,0x2c
    80003248:	5687a783          	lw	a5,1384(a5) # 8002f7ac <sb+0x1c>
    8000324c:	9dbd                	addw	a1,a1,a5
    8000324e:	00000097          	auipc	ra,0x0
    80003252:	d9e080e7          	jalr	-610(ra) # 80002fec <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80003256:	0074f713          	andi	a4,s1,7
    8000325a:	4785                	li	a5,1
    8000325c:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80003260:	14ce                	slli	s1,s1,0x33
    80003262:	90d9                	srli	s1,s1,0x36
    80003264:	00950733          	add	a4,a0,s1
    80003268:	05874703          	lbu	a4,88(a4)
    8000326c:	00e7f6b3          	and	a3,a5,a4
    80003270:	c69d                	beqz	a3,8000329e <bfree+0x6c>
    80003272:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80003274:	94aa                	add	s1,s1,a0
    80003276:	fff7c793          	not	a5,a5
    8000327a:	8ff9                	and	a5,a5,a4
    8000327c:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    80003280:	00001097          	auipc	ra,0x1
    80003284:	118080e7          	jalr	280(ra) # 80004398 <log_write>
  brelse(bp);
    80003288:	854a                	mv	a0,s2
    8000328a:	00000097          	auipc	ra,0x0
    8000328e:	e92080e7          	jalr	-366(ra) # 8000311c <brelse>
}
    80003292:	60e2                	ld	ra,24(sp)
    80003294:	6442                	ld	s0,16(sp)
    80003296:	64a2                	ld	s1,8(sp)
    80003298:	6902                	ld	s2,0(sp)
    8000329a:	6105                	addi	sp,sp,32
    8000329c:	8082                	ret
    panic("freeing free block");
    8000329e:	00005517          	auipc	a0,0x5
    800032a2:	29250513          	addi	a0,a0,658 # 80008530 <syscalls+0xf8>
    800032a6:	ffffd097          	auipc	ra,0xffffd
    800032aa:	28a080e7          	jalr	650(ra) # 80000530 <panic>

00000000800032ae <balloc>:
{
    800032ae:	711d                	addi	sp,sp,-96
    800032b0:	ec86                	sd	ra,88(sp)
    800032b2:	e8a2                	sd	s0,80(sp)
    800032b4:	e4a6                	sd	s1,72(sp)
    800032b6:	e0ca                	sd	s2,64(sp)
    800032b8:	fc4e                	sd	s3,56(sp)
    800032ba:	f852                	sd	s4,48(sp)
    800032bc:	f456                	sd	s5,40(sp)
    800032be:	f05a                	sd	s6,32(sp)
    800032c0:	ec5e                	sd	s7,24(sp)
    800032c2:	e862                	sd	s8,16(sp)
    800032c4:	e466                	sd	s9,8(sp)
    800032c6:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800032c8:	0002c797          	auipc	a5,0x2c
    800032cc:	4cc7a783          	lw	a5,1228(a5) # 8002f794 <sb+0x4>
    800032d0:	cbd1                	beqz	a5,80003364 <balloc+0xb6>
    800032d2:	8baa                	mv	s7,a0
    800032d4:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800032d6:	0002cb17          	auipc	s6,0x2c
    800032da:	4bab0b13          	addi	s6,s6,1210 # 8002f790 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800032de:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800032e0:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800032e2:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800032e4:	6c89                	lui	s9,0x2
    800032e6:	a831                	j	80003302 <balloc+0x54>
    brelse(bp);
    800032e8:	854a                	mv	a0,s2
    800032ea:	00000097          	auipc	ra,0x0
    800032ee:	e32080e7          	jalr	-462(ra) # 8000311c <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800032f2:	015c87bb          	addw	a5,s9,s5
    800032f6:	00078a9b          	sext.w	s5,a5
    800032fa:	004b2703          	lw	a4,4(s6)
    800032fe:	06eaf363          	bgeu	s5,a4,80003364 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    80003302:	41fad79b          	sraiw	a5,s5,0x1f
    80003306:	0137d79b          	srliw	a5,a5,0x13
    8000330a:	015787bb          	addw	a5,a5,s5
    8000330e:	40d7d79b          	sraiw	a5,a5,0xd
    80003312:	01cb2583          	lw	a1,28(s6)
    80003316:	9dbd                	addw	a1,a1,a5
    80003318:	855e                	mv	a0,s7
    8000331a:	00000097          	auipc	ra,0x0
    8000331e:	cd2080e7          	jalr	-814(ra) # 80002fec <bread>
    80003322:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003324:	004b2503          	lw	a0,4(s6)
    80003328:	000a849b          	sext.w	s1,s5
    8000332c:	8662                	mv	a2,s8
    8000332e:	faa4fde3          	bgeu	s1,a0,800032e8 <balloc+0x3a>
      m = 1 << (bi % 8);
    80003332:	41f6579b          	sraiw	a5,a2,0x1f
    80003336:	01d7d69b          	srliw	a3,a5,0x1d
    8000333a:	00c6873b          	addw	a4,a3,a2
    8000333e:	00777793          	andi	a5,a4,7
    80003342:	9f95                	subw	a5,a5,a3
    80003344:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80003348:	4037571b          	sraiw	a4,a4,0x3
    8000334c:	00e906b3          	add	a3,s2,a4
    80003350:	0586c683          	lbu	a3,88(a3)
    80003354:	00d7f5b3          	and	a1,a5,a3
    80003358:	cd91                	beqz	a1,80003374 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000335a:	2605                	addiw	a2,a2,1
    8000335c:	2485                	addiw	s1,s1,1
    8000335e:	fd4618e3          	bne	a2,s4,8000332e <balloc+0x80>
    80003362:	b759                	j	800032e8 <balloc+0x3a>
  panic("balloc: out of blocks");
    80003364:	00005517          	auipc	a0,0x5
    80003368:	1e450513          	addi	a0,a0,484 # 80008548 <syscalls+0x110>
    8000336c:	ffffd097          	auipc	ra,0xffffd
    80003370:	1c4080e7          	jalr	452(ra) # 80000530 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80003374:	974a                	add	a4,a4,s2
    80003376:	8fd5                	or	a5,a5,a3
    80003378:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    8000337c:	854a                	mv	a0,s2
    8000337e:	00001097          	auipc	ra,0x1
    80003382:	01a080e7          	jalr	26(ra) # 80004398 <log_write>
        brelse(bp);
    80003386:	854a                	mv	a0,s2
    80003388:	00000097          	auipc	ra,0x0
    8000338c:	d94080e7          	jalr	-620(ra) # 8000311c <brelse>
  bp = bread(dev, bno);
    80003390:	85a6                	mv	a1,s1
    80003392:	855e                	mv	a0,s7
    80003394:	00000097          	auipc	ra,0x0
    80003398:	c58080e7          	jalr	-936(ra) # 80002fec <bread>
    8000339c:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000339e:	40000613          	li	a2,1024
    800033a2:	4581                	li	a1,0
    800033a4:	05850513          	addi	a0,a0,88
    800033a8:	ffffe097          	auipc	ra,0xffffe
    800033ac:	92a080e7          	jalr	-1750(ra) # 80000cd2 <memset>
  log_write(bp);
    800033b0:	854a                	mv	a0,s2
    800033b2:	00001097          	auipc	ra,0x1
    800033b6:	fe6080e7          	jalr	-26(ra) # 80004398 <log_write>
  brelse(bp);
    800033ba:	854a                	mv	a0,s2
    800033bc:	00000097          	auipc	ra,0x0
    800033c0:	d60080e7          	jalr	-672(ra) # 8000311c <brelse>
}
    800033c4:	8526                	mv	a0,s1
    800033c6:	60e6                	ld	ra,88(sp)
    800033c8:	6446                	ld	s0,80(sp)
    800033ca:	64a6                	ld	s1,72(sp)
    800033cc:	6906                	ld	s2,64(sp)
    800033ce:	79e2                	ld	s3,56(sp)
    800033d0:	7a42                	ld	s4,48(sp)
    800033d2:	7aa2                	ld	s5,40(sp)
    800033d4:	7b02                	ld	s6,32(sp)
    800033d6:	6be2                	ld	s7,24(sp)
    800033d8:	6c42                	ld	s8,16(sp)
    800033da:	6ca2                	ld	s9,8(sp)
    800033dc:	6125                	addi	sp,sp,96
    800033de:	8082                	ret

00000000800033e0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800033e0:	7179                	addi	sp,sp,-48
    800033e2:	f406                	sd	ra,40(sp)
    800033e4:	f022                	sd	s0,32(sp)
    800033e6:	ec26                	sd	s1,24(sp)
    800033e8:	e84a                	sd	s2,16(sp)
    800033ea:	e44e                	sd	s3,8(sp)
    800033ec:	e052                	sd	s4,0(sp)
    800033ee:	1800                	addi	s0,sp,48
    800033f0:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800033f2:	47ad                	li	a5,11
    800033f4:	04b7fe63          	bgeu	a5,a1,80003450 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800033f8:	ff45849b          	addiw	s1,a1,-12
    800033fc:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80003400:	0ff00793          	li	a5,255
    80003404:	0ae7e363          	bltu	a5,a4,800034aa <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80003408:	08052583          	lw	a1,128(a0)
    8000340c:	c5ad                	beqz	a1,80003476 <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    8000340e:	00092503          	lw	a0,0(s2)
    80003412:	00000097          	auipc	ra,0x0
    80003416:	bda080e7          	jalr	-1062(ra) # 80002fec <bread>
    8000341a:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000341c:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80003420:	02049593          	slli	a1,s1,0x20
    80003424:	9181                	srli	a1,a1,0x20
    80003426:	058a                	slli	a1,a1,0x2
    80003428:	00b784b3          	add	s1,a5,a1
    8000342c:	0004a983          	lw	s3,0(s1)
    80003430:	04098d63          	beqz	s3,8000348a <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80003434:	8552                	mv	a0,s4
    80003436:	00000097          	auipc	ra,0x0
    8000343a:	ce6080e7          	jalr	-794(ra) # 8000311c <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    8000343e:	854e                	mv	a0,s3
    80003440:	70a2                	ld	ra,40(sp)
    80003442:	7402                	ld	s0,32(sp)
    80003444:	64e2                	ld	s1,24(sp)
    80003446:	6942                	ld	s2,16(sp)
    80003448:	69a2                	ld	s3,8(sp)
    8000344a:	6a02                	ld	s4,0(sp)
    8000344c:	6145                	addi	sp,sp,48
    8000344e:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80003450:	02059493          	slli	s1,a1,0x20
    80003454:	9081                	srli	s1,s1,0x20
    80003456:	048a                	slli	s1,s1,0x2
    80003458:	94aa                	add	s1,s1,a0
    8000345a:	0504a983          	lw	s3,80(s1)
    8000345e:	fe0990e3          	bnez	s3,8000343e <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80003462:	4108                	lw	a0,0(a0)
    80003464:	00000097          	auipc	ra,0x0
    80003468:	e4a080e7          	jalr	-438(ra) # 800032ae <balloc>
    8000346c:	0005099b          	sext.w	s3,a0
    80003470:	0534a823          	sw	s3,80(s1)
    80003474:	b7e9                	j	8000343e <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80003476:	4108                	lw	a0,0(a0)
    80003478:	00000097          	auipc	ra,0x0
    8000347c:	e36080e7          	jalr	-458(ra) # 800032ae <balloc>
    80003480:	0005059b          	sext.w	a1,a0
    80003484:	08b92023          	sw	a1,128(s2)
    80003488:	b759                	j	8000340e <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    8000348a:	00092503          	lw	a0,0(s2)
    8000348e:	00000097          	auipc	ra,0x0
    80003492:	e20080e7          	jalr	-480(ra) # 800032ae <balloc>
    80003496:	0005099b          	sext.w	s3,a0
    8000349a:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    8000349e:	8552                	mv	a0,s4
    800034a0:	00001097          	auipc	ra,0x1
    800034a4:	ef8080e7          	jalr	-264(ra) # 80004398 <log_write>
    800034a8:	b771                	j	80003434 <bmap+0x54>
  panic("bmap: out of range");
    800034aa:	00005517          	auipc	a0,0x5
    800034ae:	0b650513          	addi	a0,a0,182 # 80008560 <syscalls+0x128>
    800034b2:	ffffd097          	auipc	ra,0xffffd
    800034b6:	07e080e7          	jalr	126(ra) # 80000530 <panic>

00000000800034ba <iget>:
{
    800034ba:	7179                	addi	sp,sp,-48
    800034bc:	f406                	sd	ra,40(sp)
    800034be:	f022                	sd	s0,32(sp)
    800034c0:	ec26                	sd	s1,24(sp)
    800034c2:	e84a                	sd	s2,16(sp)
    800034c4:	e44e                	sd	s3,8(sp)
    800034c6:	e052                	sd	s4,0(sp)
    800034c8:	1800                	addi	s0,sp,48
    800034ca:	89aa                	mv	s3,a0
    800034cc:	8a2e                	mv	s4,a1
  acquire(&icache.lock);
    800034ce:	0002c517          	auipc	a0,0x2c
    800034d2:	2e250513          	addi	a0,a0,738 # 8002f7b0 <icache>
    800034d6:	ffffd097          	auipc	ra,0xffffd
    800034da:	700080e7          	jalr	1792(ra) # 80000bd6 <acquire>
  empty = 0;
    800034de:	4901                	li	s2,0
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    800034e0:	0002c497          	auipc	s1,0x2c
    800034e4:	2e848493          	addi	s1,s1,744 # 8002f7c8 <icache+0x18>
    800034e8:	0002e697          	auipc	a3,0x2e
    800034ec:	d7068693          	addi	a3,a3,-656 # 80031258 <log>
    800034f0:	a039                	j	800034fe <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800034f2:	02090b63          	beqz	s2,80003528 <iget+0x6e>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    800034f6:	08848493          	addi	s1,s1,136
    800034fa:	02d48a63          	beq	s1,a3,8000352e <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800034fe:	449c                	lw	a5,8(s1)
    80003500:	fef059e3          	blez	a5,800034f2 <iget+0x38>
    80003504:	4098                	lw	a4,0(s1)
    80003506:	ff3716e3          	bne	a4,s3,800034f2 <iget+0x38>
    8000350a:	40d8                	lw	a4,4(s1)
    8000350c:	ff4713e3          	bne	a4,s4,800034f2 <iget+0x38>
      ip->ref++;
    80003510:	2785                	addiw	a5,a5,1
    80003512:	c49c                	sw	a5,8(s1)
      release(&icache.lock);
    80003514:	0002c517          	auipc	a0,0x2c
    80003518:	29c50513          	addi	a0,a0,668 # 8002f7b0 <icache>
    8000351c:	ffffd097          	auipc	ra,0xffffd
    80003520:	76e080e7          	jalr	1902(ra) # 80000c8a <release>
      return ip;
    80003524:	8926                	mv	s2,s1
    80003526:	a03d                	j	80003554 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003528:	f7f9                	bnez	a5,800034f6 <iget+0x3c>
    8000352a:	8926                	mv	s2,s1
    8000352c:	b7e9                	j	800034f6 <iget+0x3c>
  if(empty == 0)
    8000352e:	02090c63          	beqz	s2,80003566 <iget+0xac>
  ip->dev = dev;
    80003532:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003536:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    8000353a:	4785                	li	a5,1
    8000353c:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80003540:	04092023          	sw	zero,64(s2)
  release(&icache.lock);
    80003544:	0002c517          	auipc	a0,0x2c
    80003548:	26c50513          	addi	a0,a0,620 # 8002f7b0 <icache>
    8000354c:	ffffd097          	auipc	ra,0xffffd
    80003550:	73e080e7          	jalr	1854(ra) # 80000c8a <release>
}
    80003554:	854a                	mv	a0,s2
    80003556:	70a2                	ld	ra,40(sp)
    80003558:	7402                	ld	s0,32(sp)
    8000355a:	64e2                	ld	s1,24(sp)
    8000355c:	6942                	ld	s2,16(sp)
    8000355e:	69a2                	ld	s3,8(sp)
    80003560:	6a02                	ld	s4,0(sp)
    80003562:	6145                	addi	sp,sp,48
    80003564:	8082                	ret
    panic("iget: no inodes");
    80003566:	00005517          	auipc	a0,0x5
    8000356a:	01250513          	addi	a0,a0,18 # 80008578 <syscalls+0x140>
    8000356e:	ffffd097          	auipc	ra,0xffffd
    80003572:	fc2080e7          	jalr	-62(ra) # 80000530 <panic>

0000000080003576 <fsinit>:
fsinit(int dev) {
    80003576:	7179                	addi	sp,sp,-48
    80003578:	f406                	sd	ra,40(sp)
    8000357a:	f022                	sd	s0,32(sp)
    8000357c:	ec26                	sd	s1,24(sp)
    8000357e:	e84a                	sd	s2,16(sp)
    80003580:	e44e                	sd	s3,8(sp)
    80003582:	1800                	addi	s0,sp,48
    80003584:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003586:	4585                	li	a1,1
    80003588:	00000097          	auipc	ra,0x0
    8000358c:	a64080e7          	jalr	-1436(ra) # 80002fec <bread>
    80003590:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003592:	0002c997          	auipc	s3,0x2c
    80003596:	1fe98993          	addi	s3,s3,510 # 8002f790 <sb>
    8000359a:	02000613          	li	a2,32
    8000359e:	05850593          	addi	a1,a0,88
    800035a2:	854e                	mv	a0,s3
    800035a4:	ffffd097          	auipc	ra,0xffffd
    800035a8:	78e080e7          	jalr	1934(ra) # 80000d32 <memmove>
  brelse(bp);
    800035ac:	8526                	mv	a0,s1
    800035ae:	00000097          	auipc	ra,0x0
    800035b2:	b6e080e7          	jalr	-1170(ra) # 8000311c <brelse>
  if(sb.magic != FSMAGIC)
    800035b6:	0009a703          	lw	a4,0(s3)
    800035ba:	102037b7          	lui	a5,0x10203
    800035be:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800035c2:	02f71263          	bne	a4,a5,800035e6 <fsinit+0x70>
  initlog(dev, &sb);
    800035c6:	0002c597          	auipc	a1,0x2c
    800035ca:	1ca58593          	addi	a1,a1,458 # 8002f790 <sb>
    800035ce:	854a                	mv	a0,s2
    800035d0:	00001097          	auipc	ra,0x1
    800035d4:	b4c080e7          	jalr	-1204(ra) # 8000411c <initlog>
}
    800035d8:	70a2                	ld	ra,40(sp)
    800035da:	7402                	ld	s0,32(sp)
    800035dc:	64e2                	ld	s1,24(sp)
    800035de:	6942                	ld	s2,16(sp)
    800035e0:	69a2                	ld	s3,8(sp)
    800035e2:	6145                	addi	sp,sp,48
    800035e4:	8082                	ret
    panic("invalid file system");
    800035e6:	00005517          	auipc	a0,0x5
    800035ea:	fa250513          	addi	a0,a0,-94 # 80008588 <syscalls+0x150>
    800035ee:	ffffd097          	auipc	ra,0xffffd
    800035f2:	f42080e7          	jalr	-190(ra) # 80000530 <panic>

00000000800035f6 <iinit>:
{
    800035f6:	7179                	addi	sp,sp,-48
    800035f8:	f406                	sd	ra,40(sp)
    800035fa:	f022                	sd	s0,32(sp)
    800035fc:	ec26                	sd	s1,24(sp)
    800035fe:	e84a                	sd	s2,16(sp)
    80003600:	e44e                	sd	s3,8(sp)
    80003602:	1800                	addi	s0,sp,48
  initlock(&icache.lock, "icache");
    80003604:	00005597          	auipc	a1,0x5
    80003608:	f9c58593          	addi	a1,a1,-100 # 800085a0 <syscalls+0x168>
    8000360c:	0002c517          	auipc	a0,0x2c
    80003610:	1a450513          	addi	a0,a0,420 # 8002f7b0 <icache>
    80003614:	ffffd097          	auipc	ra,0xffffd
    80003618:	532080e7          	jalr	1330(ra) # 80000b46 <initlock>
  for(i = 0; i < NINODE; i++) {
    8000361c:	0002c497          	auipc	s1,0x2c
    80003620:	1bc48493          	addi	s1,s1,444 # 8002f7d8 <icache+0x28>
    80003624:	0002e997          	auipc	s3,0x2e
    80003628:	c4498993          	addi	s3,s3,-956 # 80031268 <log+0x10>
    initsleeplock(&icache.inode[i].lock, "inode");
    8000362c:	00005917          	auipc	s2,0x5
    80003630:	f7c90913          	addi	s2,s2,-132 # 800085a8 <syscalls+0x170>
    80003634:	85ca                	mv	a1,s2
    80003636:	8526                	mv	a0,s1
    80003638:	00001097          	auipc	ra,0x1
    8000363c:	e4e080e7          	jalr	-434(ra) # 80004486 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003640:	08848493          	addi	s1,s1,136
    80003644:	ff3498e3          	bne	s1,s3,80003634 <iinit+0x3e>
}
    80003648:	70a2                	ld	ra,40(sp)
    8000364a:	7402                	ld	s0,32(sp)
    8000364c:	64e2                	ld	s1,24(sp)
    8000364e:	6942                	ld	s2,16(sp)
    80003650:	69a2                	ld	s3,8(sp)
    80003652:	6145                	addi	sp,sp,48
    80003654:	8082                	ret

0000000080003656 <ialloc>:
{
    80003656:	715d                	addi	sp,sp,-80
    80003658:	e486                	sd	ra,72(sp)
    8000365a:	e0a2                	sd	s0,64(sp)
    8000365c:	fc26                	sd	s1,56(sp)
    8000365e:	f84a                	sd	s2,48(sp)
    80003660:	f44e                	sd	s3,40(sp)
    80003662:	f052                	sd	s4,32(sp)
    80003664:	ec56                	sd	s5,24(sp)
    80003666:	e85a                	sd	s6,16(sp)
    80003668:	e45e                	sd	s7,8(sp)
    8000366a:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    8000366c:	0002c717          	auipc	a4,0x2c
    80003670:	13072703          	lw	a4,304(a4) # 8002f79c <sb+0xc>
    80003674:	4785                	li	a5,1
    80003676:	04e7fa63          	bgeu	a5,a4,800036ca <ialloc+0x74>
    8000367a:	8aaa                	mv	s5,a0
    8000367c:	8bae                	mv	s7,a1
    8000367e:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80003680:	0002ca17          	auipc	s4,0x2c
    80003684:	110a0a13          	addi	s4,s4,272 # 8002f790 <sb>
    80003688:	00048b1b          	sext.w	s6,s1
    8000368c:	0044d593          	srli	a1,s1,0x4
    80003690:	018a2783          	lw	a5,24(s4)
    80003694:	9dbd                	addw	a1,a1,a5
    80003696:	8556                	mv	a0,s5
    80003698:	00000097          	auipc	ra,0x0
    8000369c:	954080e7          	jalr	-1708(ra) # 80002fec <bread>
    800036a0:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800036a2:	05850993          	addi	s3,a0,88
    800036a6:	00f4f793          	andi	a5,s1,15
    800036aa:	079a                	slli	a5,a5,0x6
    800036ac:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800036ae:	00099783          	lh	a5,0(s3)
    800036b2:	c785                	beqz	a5,800036da <ialloc+0x84>
    brelse(bp);
    800036b4:	00000097          	auipc	ra,0x0
    800036b8:	a68080e7          	jalr	-1432(ra) # 8000311c <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800036bc:	0485                	addi	s1,s1,1
    800036be:	00ca2703          	lw	a4,12(s4)
    800036c2:	0004879b          	sext.w	a5,s1
    800036c6:	fce7e1e3          	bltu	a5,a4,80003688 <ialloc+0x32>
  panic("ialloc: no inodes");
    800036ca:	00005517          	auipc	a0,0x5
    800036ce:	ee650513          	addi	a0,a0,-282 # 800085b0 <syscalls+0x178>
    800036d2:	ffffd097          	auipc	ra,0xffffd
    800036d6:	e5e080e7          	jalr	-418(ra) # 80000530 <panic>
      memset(dip, 0, sizeof(*dip));
    800036da:	04000613          	li	a2,64
    800036de:	4581                	li	a1,0
    800036e0:	854e                	mv	a0,s3
    800036e2:	ffffd097          	auipc	ra,0xffffd
    800036e6:	5f0080e7          	jalr	1520(ra) # 80000cd2 <memset>
      dip->type = type;
    800036ea:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    800036ee:	854a                	mv	a0,s2
    800036f0:	00001097          	auipc	ra,0x1
    800036f4:	ca8080e7          	jalr	-856(ra) # 80004398 <log_write>
      brelse(bp);
    800036f8:	854a                	mv	a0,s2
    800036fa:	00000097          	auipc	ra,0x0
    800036fe:	a22080e7          	jalr	-1502(ra) # 8000311c <brelse>
      return iget(dev, inum);
    80003702:	85da                	mv	a1,s6
    80003704:	8556                	mv	a0,s5
    80003706:	00000097          	auipc	ra,0x0
    8000370a:	db4080e7          	jalr	-588(ra) # 800034ba <iget>
}
    8000370e:	60a6                	ld	ra,72(sp)
    80003710:	6406                	ld	s0,64(sp)
    80003712:	74e2                	ld	s1,56(sp)
    80003714:	7942                	ld	s2,48(sp)
    80003716:	79a2                	ld	s3,40(sp)
    80003718:	7a02                	ld	s4,32(sp)
    8000371a:	6ae2                	ld	s5,24(sp)
    8000371c:	6b42                	ld	s6,16(sp)
    8000371e:	6ba2                	ld	s7,8(sp)
    80003720:	6161                	addi	sp,sp,80
    80003722:	8082                	ret

0000000080003724 <iupdate>:
{
    80003724:	1101                	addi	sp,sp,-32
    80003726:	ec06                	sd	ra,24(sp)
    80003728:	e822                	sd	s0,16(sp)
    8000372a:	e426                	sd	s1,8(sp)
    8000372c:	e04a                	sd	s2,0(sp)
    8000372e:	1000                	addi	s0,sp,32
    80003730:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003732:	415c                	lw	a5,4(a0)
    80003734:	0047d79b          	srliw	a5,a5,0x4
    80003738:	0002c597          	auipc	a1,0x2c
    8000373c:	0705a583          	lw	a1,112(a1) # 8002f7a8 <sb+0x18>
    80003740:	9dbd                	addw	a1,a1,a5
    80003742:	4108                	lw	a0,0(a0)
    80003744:	00000097          	auipc	ra,0x0
    80003748:	8a8080e7          	jalr	-1880(ra) # 80002fec <bread>
    8000374c:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000374e:	05850793          	addi	a5,a0,88
    80003752:	40c8                	lw	a0,4(s1)
    80003754:	893d                	andi	a0,a0,15
    80003756:	051a                	slli	a0,a0,0x6
    80003758:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    8000375a:	04449703          	lh	a4,68(s1)
    8000375e:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80003762:	04649703          	lh	a4,70(s1)
    80003766:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    8000376a:	04849703          	lh	a4,72(s1)
    8000376e:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80003772:	04a49703          	lh	a4,74(s1)
    80003776:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    8000377a:	44f8                	lw	a4,76(s1)
    8000377c:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    8000377e:	03400613          	li	a2,52
    80003782:	05048593          	addi	a1,s1,80
    80003786:	0531                	addi	a0,a0,12
    80003788:	ffffd097          	auipc	ra,0xffffd
    8000378c:	5aa080e7          	jalr	1450(ra) # 80000d32 <memmove>
  log_write(bp);
    80003790:	854a                	mv	a0,s2
    80003792:	00001097          	auipc	ra,0x1
    80003796:	c06080e7          	jalr	-1018(ra) # 80004398 <log_write>
  brelse(bp);
    8000379a:	854a                	mv	a0,s2
    8000379c:	00000097          	auipc	ra,0x0
    800037a0:	980080e7          	jalr	-1664(ra) # 8000311c <brelse>
}
    800037a4:	60e2                	ld	ra,24(sp)
    800037a6:	6442                	ld	s0,16(sp)
    800037a8:	64a2                	ld	s1,8(sp)
    800037aa:	6902                	ld	s2,0(sp)
    800037ac:	6105                	addi	sp,sp,32
    800037ae:	8082                	ret

00000000800037b0 <idup>:
{
    800037b0:	1101                	addi	sp,sp,-32
    800037b2:	ec06                	sd	ra,24(sp)
    800037b4:	e822                	sd	s0,16(sp)
    800037b6:	e426                	sd	s1,8(sp)
    800037b8:	1000                	addi	s0,sp,32
    800037ba:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    800037bc:	0002c517          	auipc	a0,0x2c
    800037c0:	ff450513          	addi	a0,a0,-12 # 8002f7b0 <icache>
    800037c4:	ffffd097          	auipc	ra,0xffffd
    800037c8:	412080e7          	jalr	1042(ra) # 80000bd6 <acquire>
  ip->ref++;
    800037cc:	449c                	lw	a5,8(s1)
    800037ce:	2785                	addiw	a5,a5,1
    800037d0:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    800037d2:	0002c517          	auipc	a0,0x2c
    800037d6:	fde50513          	addi	a0,a0,-34 # 8002f7b0 <icache>
    800037da:	ffffd097          	auipc	ra,0xffffd
    800037de:	4b0080e7          	jalr	1200(ra) # 80000c8a <release>
}
    800037e2:	8526                	mv	a0,s1
    800037e4:	60e2                	ld	ra,24(sp)
    800037e6:	6442                	ld	s0,16(sp)
    800037e8:	64a2                	ld	s1,8(sp)
    800037ea:	6105                	addi	sp,sp,32
    800037ec:	8082                	ret

00000000800037ee <ilock>:
{
    800037ee:	1101                	addi	sp,sp,-32
    800037f0:	ec06                	sd	ra,24(sp)
    800037f2:	e822                	sd	s0,16(sp)
    800037f4:	e426                	sd	s1,8(sp)
    800037f6:	e04a                	sd	s2,0(sp)
    800037f8:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    800037fa:	c115                	beqz	a0,8000381e <ilock+0x30>
    800037fc:	84aa                	mv	s1,a0
    800037fe:	451c                	lw	a5,8(a0)
    80003800:	00f05f63          	blez	a5,8000381e <ilock+0x30>
  acquiresleep(&ip->lock);
    80003804:	0541                	addi	a0,a0,16
    80003806:	00001097          	auipc	ra,0x1
    8000380a:	cba080e7          	jalr	-838(ra) # 800044c0 <acquiresleep>
  if(ip->valid == 0){
    8000380e:	40bc                	lw	a5,64(s1)
    80003810:	cf99                	beqz	a5,8000382e <ilock+0x40>
}
    80003812:	60e2                	ld	ra,24(sp)
    80003814:	6442                	ld	s0,16(sp)
    80003816:	64a2                	ld	s1,8(sp)
    80003818:	6902                	ld	s2,0(sp)
    8000381a:	6105                	addi	sp,sp,32
    8000381c:	8082                	ret
    panic("ilock");
    8000381e:	00005517          	auipc	a0,0x5
    80003822:	daa50513          	addi	a0,a0,-598 # 800085c8 <syscalls+0x190>
    80003826:	ffffd097          	auipc	ra,0xffffd
    8000382a:	d0a080e7          	jalr	-758(ra) # 80000530 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000382e:	40dc                	lw	a5,4(s1)
    80003830:	0047d79b          	srliw	a5,a5,0x4
    80003834:	0002c597          	auipc	a1,0x2c
    80003838:	f745a583          	lw	a1,-140(a1) # 8002f7a8 <sb+0x18>
    8000383c:	9dbd                	addw	a1,a1,a5
    8000383e:	4088                	lw	a0,0(s1)
    80003840:	fffff097          	auipc	ra,0xfffff
    80003844:	7ac080e7          	jalr	1964(ra) # 80002fec <bread>
    80003848:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000384a:	05850593          	addi	a1,a0,88
    8000384e:	40dc                	lw	a5,4(s1)
    80003850:	8bbd                	andi	a5,a5,15
    80003852:	079a                	slli	a5,a5,0x6
    80003854:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003856:	00059783          	lh	a5,0(a1)
    8000385a:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    8000385e:	00259783          	lh	a5,2(a1)
    80003862:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003866:	00459783          	lh	a5,4(a1)
    8000386a:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    8000386e:	00659783          	lh	a5,6(a1)
    80003872:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003876:	459c                	lw	a5,8(a1)
    80003878:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    8000387a:	03400613          	li	a2,52
    8000387e:	05b1                	addi	a1,a1,12
    80003880:	05048513          	addi	a0,s1,80
    80003884:	ffffd097          	auipc	ra,0xffffd
    80003888:	4ae080e7          	jalr	1198(ra) # 80000d32 <memmove>
    brelse(bp);
    8000388c:	854a                	mv	a0,s2
    8000388e:	00000097          	auipc	ra,0x0
    80003892:	88e080e7          	jalr	-1906(ra) # 8000311c <brelse>
    ip->valid = 1;
    80003896:	4785                	li	a5,1
    80003898:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    8000389a:	04449783          	lh	a5,68(s1)
    8000389e:	fbb5                	bnez	a5,80003812 <ilock+0x24>
      panic("ilock: no type");
    800038a0:	00005517          	auipc	a0,0x5
    800038a4:	d3050513          	addi	a0,a0,-720 # 800085d0 <syscalls+0x198>
    800038a8:	ffffd097          	auipc	ra,0xffffd
    800038ac:	c88080e7          	jalr	-888(ra) # 80000530 <panic>

00000000800038b0 <iunlock>:
{
    800038b0:	1101                	addi	sp,sp,-32
    800038b2:	ec06                	sd	ra,24(sp)
    800038b4:	e822                	sd	s0,16(sp)
    800038b6:	e426                	sd	s1,8(sp)
    800038b8:	e04a                	sd	s2,0(sp)
    800038ba:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800038bc:	c905                	beqz	a0,800038ec <iunlock+0x3c>
    800038be:	84aa                	mv	s1,a0
    800038c0:	01050913          	addi	s2,a0,16
    800038c4:	854a                	mv	a0,s2
    800038c6:	00001097          	auipc	ra,0x1
    800038ca:	c94080e7          	jalr	-876(ra) # 8000455a <holdingsleep>
    800038ce:	cd19                	beqz	a0,800038ec <iunlock+0x3c>
    800038d0:	449c                	lw	a5,8(s1)
    800038d2:	00f05d63          	blez	a5,800038ec <iunlock+0x3c>
  releasesleep(&ip->lock);
    800038d6:	854a                	mv	a0,s2
    800038d8:	00001097          	auipc	ra,0x1
    800038dc:	c3e080e7          	jalr	-962(ra) # 80004516 <releasesleep>
}
    800038e0:	60e2                	ld	ra,24(sp)
    800038e2:	6442                	ld	s0,16(sp)
    800038e4:	64a2                	ld	s1,8(sp)
    800038e6:	6902                	ld	s2,0(sp)
    800038e8:	6105                	addi	sp,sp,32
    800038ea:	8082                	ret
    panic("iunlock");
    800038ec:	00005517          	auipc	a0,0x5
    800038f0:	cf450513          	addi	a0,a0,-780 # 800085e0 <syscalls+0x1a8>
    800038f4:	ffffd097          	auipc	ra,0xffffd
    800038f8:	c3c080e7          	jalr	-964(ra) # 80000530 <panic>

00000000800038fc <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    800038fc:	7179                	addi	sp,sp,-48
    800038fe:	f406                	sd	ra,40(sp)
    80003900:	f022                	sd	s0,32(sp)
    80003902:	ec26                	sd	s1,24(sp)
    80003904:	e84a                	sd	s2,16(sp)
    80003906:	e44e                	sd	s3,8(sp)
    80003908:	e052                	sd	s4,0(sp)
    8000390a:	1800                	addi	s0,sp,48
    8000390c:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    8000390e:	05050493          	addi	s1,a0,80
    80003912:	08050913          	addi	s2,a0,128
    80003916:	a021                	j	8000391e <itrunc+0x22>
    80003918:	0491                	addi	s1,s1,4
    8000391a:	01248d63          	beq	s1,s2,80003934 <itrunc+0x38>
    if(ip->addrs[i]){
    8000391e:	408c                	lw	a1,0(s1)
    80003920:	dde5                	beqz	a1,80003918 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80003922:	0009a503          	lw	a0,0(s3)
    80003926:	00000097          	auipc	ra,0x0
    8000392a:	90c080e7          	jalr	-1780(ra) # 80003232 <bfree>
      ip->addrs[i] = 0;
    8000392e:	0004a023          	sw	zero,0(s1)
    80003932:	b7dd                	j	80003918 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003934:	0809a583          	lw	a1,128(s3)
    80003938:	e185                	bnez	a1,80003958 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    8000393a:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    8000393e:	854e                	mv	a0,s3
    80003940:	00000097          	auipc	ra,0x0
    80003944:	de4080e7          	jalr	-540(ra) # 80003724 <iupdate>
}
    80003948:	70a2                	ld	ra,40(sp)
    8000394a:	7402                	ld	s0,32(sp)
    8000394c:	64e2                	ld	s1,24(sp)
    8000394e:	6942                	ld	s2,16(sp)
    80003950:	69a2                	ld	s3,8(sp)
    80003952:	6a02                	ld	s4,0(sp)
    80003954:	6145                	addi	sp,sp,48
    80003956:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003958:	0009a503          	lw	a0,0(s3)
    8000395c:	fffff097          	auipc	ra,0xfffff
    80003960:	690080e7          	jalr	1680(ra) # 80002fec <bread>
    80003964:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003966:	05850493          	addi	s1,a0,88
    8000396a:	45850913          	addi	s2,a0,1112
    8000396e:	a811                	j	80003982 <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80003970:	0009a503          	lw	a0,0(s3)
    80003974:	00000097          	auipc	ra,0x0
    80003978:	8be080e7          	jalr	-1858(ra) # 80003232 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    8000397c:	0491                	addi	s1,s1,4
    8000397e:	01248563          	beq	s1,s2,80003988 <itrunc+0x8c>
      if(a[j])
    80003982:	408c                	lw	a1,0(s1)
    80003984:	dde5                	beqz	a1,8000397c <itrunc+0x80>
    80003986:	b7ed                	j	80003970 <itrunc+0x74>
    brelse(bp);
    80003988:	8552                	mv	a0,s4
    8000398a:	fffff097          	auipc	ra,0xfffff
    8000398e:	792080e7          	jalr	1938(ra) # 8000311c <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003992:	0809a583          	lw	a1,128(s3)
    80003996:	0009a503          	lw	a0,0(s3)
    8000399a:	00000097          	auipc	ra,0x0
    8000399e:	898080e7          	jalr	-1896(ra) # 80003232 <bfree>
    ip->addrs[NDIRECT] = 0;
    800039a2:	0809a023          	sw	zero,128(s3)
    800039a6:	bf51                	j	8000393a <itrunc+0x3e>

00000000800039a8 <iput>:
{
    800039a8:	1101                	addi	sp,sp,-32
    800039aa:	ec06                	sd	ra,24(sp)
    800039ac:	e822                	sd	s0,16(sp)
    800039ae:	e426                	sd	s1,8(sp)
    800039b0:	e04a                	sd	s2,0(sp)
    800039b2:	1000                	addi	s0,sp,32
    800039b4:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    800039b6:	0002c517          	auipc	a0,0x2c
    800039ba:	dfa50513          	addi	a0,a0,-518 # 8002f7b0 <icache>
    800039be:	ffffd097          	auipc	ra,0xffffd
    800039c2:	218080e7          	jalr	536(ra) # 80000bd6 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800039c6:	4498                	lw	a4,8(s1)
    800039c8:	4785                	li	a5,1
    800039ca:	02f70363          	beq	a4,a5,800039f0 <iput+0x48>
  ip->ref--;
    800039ce:	449c                	lw	a5,8(s1)
    800039d0:	37fd                	addiw	a5,a5,-1
    800039d2:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    800039d4:	0002c517          	auipc	a0,0x2c
    800039d8:	ddc50513          	addi	a0,a0,-548 # 8002f7b0 <icache>
    800039dc:	ffffd097          	auipc	ra,0xffffd
    800039e0:	2ae080e7          	jalr	686(ra) # 80000c8a <release>
}
    800039e4:	60e2                	ld	ra,24(sp)
    800039e6:	6442                	ld	s0,16(sp)
    800039e8:	64a2                	ld	s1,8(sp)
    800039ea:	6902                	ld	s2,0(sp)
    800039ec:	6105                	addi	sp,sp,32
    800039ee:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800039f0:	40bc                	lw	a5,64(s1)
    800039f2:	dff1                	beqz	a5,800039ce <iput+0x26>
    800039f4:	04a49783          	lh	a5,74(s1)
    800039f8:	fbf9                	bnez	a5,800039ce <iput+0x26>
    acquiresleep(&ip->lock);
    800039fa:	01048913          	addi	s2,s1,16
    800039fe:	854a                	mv	a0,s2
    80003a00:	00001097          	auipc	ra,0x1
    80003a04:	ac0080e7          	jalr	-1344(ra) # 800044c0 <acquiresleep>
    release(&icache.lock);
    80003a08:	0002c517          	auipc	a0,0x2c
    80003a0c:	da850513          	addi	a0,a0,-600 # 8002f7b0 <icache>
    80003a10:	ffffd097          	auipc	ra,0xffffd
    80003a14:	27a080e7          	jalr	634(ra) # 80000c8a <release>
    itrunc(ip);
    80003a18:	8526                	mv	a0,s1
    80003a1a:	00000097          	auipc	ra,0x0
    80003a1e:	ee2080e7          	jalr	-286(ra) # 800038fc <itrunc>
    ip->type = 0;
    80003a22:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003a26:	8526                	mv	a0,s1
    80003a28:	00000097          	auipc	ra,0x0
    80003a2c:	cfc080e7          	jalr	-772(ra) # 80003724 <iupdate>
    ip->valid = 0;
    80003a30:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003a34:	854a                	mv	a0,s2
    80003a36:	00001097          	auipc	ra,0x1
    80003a3a:	ae0080e7          	jalr	-1312(ra) # 80004516 <releasesleep>
    acquire(&icache.lock);
    80003a3e:	0002c517          	auipc	a0,0x2c
    80003a42:	d7250513          	addi	a0,a0,-654 # 8002f7b0 <icache>
    80003a46:	ffffd097          	auipc	ra,0xffffd
    80003a4a:	190080e7          	jalr	400(ra) # 80000bd6 <acquire>
    80003a4e:	b741                	j	800039ce <iput+0x26>

0000000080003a50 <iunlockput>:
{
    80003a50:	1101                	addi	sp,sp,-32
    80003a52:	ec06                	sd	ra,24(sp)
    80003a54:	e822                	sd	s0,16(sp)
    80003a56:	e426                	sd	s1,8(sp)
    80003a58:	1000                	addi	s0,sp,32
    80003a5a:	84aa                	mv	s1,a0
  iunlock(ip);
    80003a5c:	00000097          	auipc	ra,0x0
    80003a60:	e54080e7          	jalr	-428(ra) # 800038b0 <iunlock>
  iput(ip);
    80003a64:	8526                	mv	a0,s1
    80003a66:	00000097          	auipc	ra,0x0
    80003a6a:	f42080e7          	jalr	-190(ra) # 800039a8 <iput>
}
    80003a6e:	60e2                	ld	ra,24(sp)
    80003a70:	6442                	ld	s0,16(sp)
    80003a72:	64a2                	ld	s1,8(sp)
    80003a74:	6105                	addi	sp,sp,32
    80003a76:	8082                	ret

0000000080003a78 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003a78:	1141                	addi	sp,sp,-16
    80003a7a:	e422                	sd	s0,8(sp)
    80003a7c:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003a7e:	411c                	lw	a5,0(a0)
    80003a80:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003a82:	415c                	lw	a5,4(a0)
    80003a84:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003a86:	04451783          	lh	a5,68(a0)
    80003a8a:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003a8e:	04a51783          	lh	a5,74(a0)
    80003a92:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003a96:	04c56783          	lwu	a5,76(a0)
    80003a9a:	e99c                	sd	a5,16(a1)
}
    80003a9c:	6422                	ld	s0,8(sp)
    80003a9e:	0141                	addi	sp,sp,16
    80003aa0:	8082                	ret

0000000080003aa2 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003aa2:	457c                	lw	a5,76(a0)
    80003aa4:	0ed7e963          	bltu	a5,a3,80003b96 <readi+0xf4>
{
    80003aa8:	7159                	addi	sp,sp,-112
    80003aaa:	f486                	sd	ra,104(sp)
    80003aac:	f0a2                	sd	s0,96(sp)
    80003aae:	eca6                	sd	s1,88(sp)
    80003ab0:	e8ca                	sd	s2,80(sp)
    80003ab2:	e4ce                	sd	s3,72(sp)
    80003ab4:	e0d2                	sd	s4,64(sp)
    80003ab6:	fc56                	sd	s5,56(sp)
    80003ab8:	f85a                	sd	s6,48(sp)
    80003aba:	f45e                	sd	s7,40(sp)
    80003abc:	f062                	sd	s8,32(sp)
    80003abe:	ec66                	sd	s9,24(sp)
    80003ac0:	e86a                	sd	s10,16(sp)
    80003ac2:	e46e                	sd	s11,8(sp)
    80003ac4:	1880                	addi	s0,sp,112
    80003ac6:	8baa                	mv	s7,a0
    80003ac8:	8c2e                	mv	s8,a1
    80003aca:	8ab2                	mv	s5,a2
    80003acc:	84b6                	mv	s1,a3
    80003ace:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003ad0:	9f35                	addw	a4,a4,a3
    return 0;
    80003ad2:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003ad4:	0ad76063          	bltu	a4,a3,80003b74 <readi+0xd2>
  if(off + n > ip->size)
    80003ad8:	00e7f463          	bgeu	a5,a4,80003ae0 <readi+0x3e>
    n = ip->size - off;
    80003adc:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003ae0:	0a0b0963          	beqz	s6,80003b92 <readi+0xf0>
    80003ae4:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003ae6:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003aea:	5cfd                	li	s9,-1
    80003aec:	a82d                	j	80003b26 <readi+0x84>
    80003aee:	020a1d93          	slli	s11,s4,0x20
    80003af2:	020ddd93          	srli	s11,s11,0x20
    80003af6:	05890613          	addi	a2,s2,88
    80003afa:	86ee                	mv	a3,s11
    80003afc:	963a                	add	a2,a2,a4
    80003afe:	85d6                	mv	a1,s5
    80003b00:	8562                	mv	a0,s8
    80003b02:	fffff097          	auipc	ra,0xfffff
    80003b06:	9ce080e7          	jalr	-1586(ra) # 800024d0 <either_copyout>
    80003b0a:	05950d63          	beq	a0,s9,80003b64 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003b0e:	854a                	mv	a0,s2
    80003b10:	fffff097          	auipc	ra,0xfffff
    80003b14:	60c080e7          	jalr	1548(ra) # 8000311c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003b18:	013a09bb          	addw	s3,s4,s3
    80003b1c:	009a04bb          	addw	s1,s4,s1
    80003b20:	9aee                	add	s5,s5,s11
    80003b22:	0569f763          	bgeu	s3,s6,80003b70 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003b26:	000ba903          	lw	s2,0(s7)
    80003b2a:	00a4d59b          	srliw	a1,s1,0xa
    80003b2e:	855e                	mv	a0,s7
    80003b30:	00000097          	auipc	ra,0x0
    80003b34:	8b0080e7          	jalr	-1872(ra) # 800033e0 <bmap>
    80003b38:	0005059b          	sext.w	a1,a0
    80003b3c:	854a                	mv	a0,s2
    80003b3e:	fffff097          	auipc	ra,0xfffff
    80003b42:	4ae080e7          	jalr	1198(ra) # 80002fec <bread>
    80003b46:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003b48:	3ff4f713          	andi	a4,s1,1023
    80003b4c:	40ed07bb          	subw	a5,s10,a4
    80003b50:	413b06bb          	subw	a3,s6,s3
    80003b54:	8a3e                	mv	s4,a5
    80003b56:	2781                	sext.w	a5,a5
    80003b58:	0006861b          	sext.w	a2,a3
    80003b5c:	f8f679e3          	bgeu	a2,a5,80003aee <readi+0x4c>
    80003b60:	8a36                	mv	s4,a3
    80003b62:	b771                	j	80003aee <readi+0x4c>
      brelse(bp);
    80003b64:	854a                	mv	a0,s2
    80003b66:	fffff097          	auipc	ra,0xfffff
    80003b6a:	5b6080e7          	jalr	1462(ra) # 8000311c <brelse>
      tot = -1;
    80003b6e:	59fd                	li	s3,-1
  }
  return tot;
    80003b70:	0009851b          	sext.w	a0,s3
}
    80003b74:	70a6                	ld	ra,104(sp)
    80003b76:	7406                	ld	s0,96(sp)
    80003b78:	64e6                	ld	s1,88(sp)
    80003b7a:	6946                	ld	s2,80(sp)
    80003b7c:	69a6                	ld	s3,72(sp)
    80003b7e:	6a06                	ld	s4,64(sp)
    80003b80:	7ae2                	ld	s5,56(sp)
    80003b82:	7b42                	ld	s6,48(sp)
    80003b84:	7ba2                	ld	s7,40(sp)
    80003b86:	7c02                	ld	s8,32(sp)
    80003b88:	6ce2                	ld	s9,24(sp)
    80003b8a:	6d42                	ld	s10,16(sp)
    80003b8c:	6da2                	ld	s11,8(sp)
    80003b8e:	6165                	addi	sp,sp,112
    80003b90:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003b92:	89da                	mv	s3,s6
    80003b94:	bff1                	j	80003b70 <readi+0xce>
    return 0;
    80003b96:	4501                	li	a0,0
}
    80003b98:	8082                	ret

0000000080003b9a <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003b9a:	457c                	lw	a5,76(a0)
    80003b9c:	10d7e863          	bltu	a5,a3,80003cac <writei+0x112>
{
    80003ba0:	7159                	addi	sp,sp,-112
    80003ba2:	f486                	sd	ra,104(sp)
    80003ba4:	f0a2                	sd	s0,96(sp)
    80003ba6:	eca6                	sd	s1,88(sp)
    80003ba8:	e8ca                	sd	s2,80(sp)
    80003baa:	e4ce                	sd	s3,72(sp)
    80003bac:	e0d2                	sd	s4,64(sp)
    80003bae:	fc56                	sd	s5,56(sp)
    80003bb0:	f85a                	sd	s6,48(sp)
    80003bb2:	f45e                	sd	s7,40(sp)
    80003bb4:	f062                	sd	s8,32(sp)
    80003bb6:	ec66                	sd	s9,24(sp)
    80003bb8:	e86a                	sd	s10,16(sp)
    80003bba:	e46e                	sd	s11,8(sp)
    80003bbc:	1880                	addi	s0,sp,112
    80003bbe:	8b2a                	mv	s6,a0
    80003bc0:	8c2e                	mv	s8,a1
    80003bc2:	8ab2                	mv	s5,a2
    80003bc4:	8936                	mv	s2,a3
    80003bc6:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80003bc8:	00e687bb          	addw	a5,a3,a4
    80003bcc:	0ed7e263          	bltu	a5,a3,80003cb0 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003bd0:	00043737          	lui	a4,0x43
    80003bd4:	0ef76063          	bltu	a4,a5,80003cb4 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003bd8:	0c0b8863          	beqz	s7,80003ca8 <writei+0x10e>
    80003bdc:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003bde:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003be2:	5cfd                	li	s9,-1
    80003be4:	a091                	j	80003c28 <writei+0x8e>
    80003be6:	02099d93          	slli	s11,s3,0x20
    80003bea:	020ddd93          	srli	s11,s11,0x20
    80003bee:	05848513          	addi	a0,s1,88
    80003bf2:	86ee                	mv	a3,s11
    80003bf4:	8656                	mv	a2,s5
    80003bf6:	85e2                	mv	a1,s8
    80003bf8:	953a                	add	a0,a0,a4
    80003bfa:	fffff097          	auipc	ra,0xfffff
    80003bfe:	92c080e7          	jalr	-1748(ra) # 80002526 <either_copyin>
    80003c02:	07950263          	beq	a0,s9,80003c66 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003c06:	8526                	mv	a0,s1
    80003c08:	00000097          	auipc	ra,0x0
    80003c0c:	790080e7          	jalr	1936(ra) # 80004398 <log_write>
    brelse(bp);
    80003c10:	8526                	mv	a0,s1
    80003c12:	fffff097          	auipc	ra,0xfffff
    80003c16:	50a080e7          	jalr	1290(ra) # 8000311c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003c1a:	01498a3b          	addw	s4,s3,s4
    80003c1e:	0129893b          	addw	s2,s3,s2
    80003c22:	9aee                	add	s5,s5,s11
    80003c24:	057a7663          	bgeu	s4,s7,80003c70 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003c28:	000b2483          	lw	s1,0(s6)
    80003c2c:	00a9559b          	srliw	a1,s2,0xa
    80003c30:	855a                	mv	a0,s6
    80003c32:	fffff097          	auipc	ra,0xfffff
    80003c36:	7ae080e7          	jalr	1966(ra) # 800033e0 <bmap>
    80003c3a:	0005059b          	sext.w	a1,a0
    80003c3e:	8526                	mv	a0,s1
    80003c40:	fffff097          	auipc	ra,0xfffff
    80003c44:	3ac080e7          	jalr	940(ra) # 80002fec <bread>
    80003c48:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003c4a:	3ff97713          	andi	a4,s2,1023
    80003c4e:	40ed07bb          	subw	a5,s10,a4
    80003c52:	414b86bb          	subw	a3,s7,s4
    80003c56:	89be                	mv	s3,a5
    80003c58:	2781                	sext.w	a5,a5
    80003c5a:	0006861b          	sext.w	a2,a3
    80003c5e:	f8f674e3          	bgeu	a2,a5,80003be6 <writei+0x4c>
    80003c62:	89b6                	mv	s3,a3
    80003c64:	b749                	j	80003be6 <writei+0x4c>
      brelse(bp);
    80003c66:	8526                	mv	a0,s1
    80003c68:	fffff097          	auipc	ra,0xfffff
    80003c6c:	4b4080e7          	jalr	1204(ra) # 8000311c <brelse>
  }

  if(off > ip->size)
    80003c70:	04cb2783          	lw	a5,76(s6)
    80003c74:	0127f463          	bgeu	a5,s2,80003c7c <writei+0xe2>
    ip->size = off;
    80003c78:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003c7c:	855a                	mv	a0,s6
    80003c7e:	00000097          	auipc	ra,0x0
    80003c82:	aa6080e7          	jalr	-1370(ra) # 80003724 <iupdate>

  return tot;
    80003c86:	000a051b          	sext.w	a0,s4
}
    80003c8a:	70a6                	ld	ra,104(sp)
    80003c8c:	7406                	ld	s0,96(sp)
    80003c8e:	64e6                	ld	s1,88(sp)
    80003c90:	6946                	ld	s2,80(sp)
    80003c92:	69a6                	ld	s3,72(sp)
    80003c94:	6a06                	ld	s4,64(sp)
    80003c96:	7ae2                	ld	s5,56(sp)
    80003c98:	7b42                	ld	s6,48(sp)
    80003c9a:	7ba2                	ld	s7,40(sp)
    80003c9c:	7c02                	ld	s8,32(sp)
    80003c9e:	6ce2                	ld	s9,24(sp)
    80003ca0:	6d42                	ld	s10,16(sp)
    80003ca2:	6da2                	ld	s11,8(sp)
    80003ca4:	6165                	addi	sp,sp,112
    80003ca6:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003ca8:	8a5e                	mv	s4,s7
    80003caa:	bfc9                	j	80003c7c <writei+0xe2>
    return -1;
    80003cac:	557d                	li	a0,-1
}
    80003cae:	8082                	ret
    return -1;
    80003cb0:	557d                	li	a0,-1
    80003cb2:	bfe1                	j	80003c8a <writei+0xf0>
    return -1;
    80003cb4:	557d                	li	a0,-1
    80003cb6:	bfd1                	j	80003c8a <writei+0xf0>

0000000080003cb8 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003cb8:	1141                	addi	sp,sp,-16
    80003cba:	e406                	sd	ra,8(sp)
    80003cbc:	e022                	sd	s0,0(sp)
    80003cbe:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003cc0:	4639                	li	a2,14
    80003cc2:	ffffd097          	auipc	ra,0xffffd
    80003cc6:	0ec080e7          	jalr	236(ra) # 80000dae <strncmp>
}
    80003cca:	60a2                	ld	ra,8(sp)
    80003ccc:	6402                	ld	s0,0(sp)
    80003cce:	0141                	addi	sp,sp,16
    80003cd0:	8082                	ret

0000000080003cd2 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003cd2:	7139                	addi	sp,sp,-64
    80003cd4:	fc06                	sd	ra,56(sp)
    80003cd6:	f822                	sd	s0,48(sp)
    80003cd8:	f426                	sd	s1,40(sp)
    80003cda:	f04a                	sd	s2,32(sp)
    80003cdc:	ec4e                	sd	s3,24(sp)
    80003cde:	e852                	sd	s4,16(sp)
    80003ce0:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003ce2:	04451703          	lh	a4,68(a0)
    80003ce6:	4785                	li	a5,1
    80003ce8:	00f71a63          	bne	a4,a5,80003cfc <dirlookup+0x2a>
    80003cec:	892a                	mv	s2,a0
    80003cee:	89ae                	mv	s3,a1
    80003cf0:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003cf2:	457c                	lw	a5,76(a0)
    80003cf4:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003cf6:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003cf8:	e79d                	bnez	a5,80003d26 <dirlookup+0x54>
    80003cfa:	a8a5                	j	80003d72 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003cfc:	00005517          	auipc	a0,0x5
    80003d00:	8ec50513          	addi	a0,a0,-1812 # 800085e8 <syscalls+0x1b0>
    80003d04:	ffffd097          	auipc	ra,0xffffd
    80003d08:	82c080e7          	jalr	-2004(ra) # 80000530 <panic>
      panic("dirlookup read");
    80003d0c:	00005517          	auipc	a0,0x5
    80003d10:	8f450513          	addi	a0,a0,-1804 # 80008600 <syscalls+0x1c8>
    80003d14:	ffffd097          	auipc	ra,0xffffd
    80003d18:	81c080e7          	jalr	-2020(ra) # 80000530 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003d1c:	24c1                	addiw	s1,s1,16
    80003d1e:	04c92783          	lw	a5,76(s2)
    80003d22:	04f4f763          	bgeu	s1,a5,80003d70 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003d26:	4741                	li	a4,16
    80003d28:	86a6                	mv	a3,s1
    80003d2a:	fc040613          	addi	a2,s0,-64
    80003d2e:	4581                	li	a1,0
    80003d30:	854a                	mv	a0,s2
    80003d32:	00000097          	auipc	ra,0x0
    80003d36:	d70080e7          	jalr	-656(ra) # 80003aa2 <readi>
    80003d3a:	47c1                	li	a5,16
    80003d3c:	fcf518e3          	bne	a0,a5,80003d0c <dirlookup+0x3a>
    if(de.inum == 0)
    80003d40:	fc045783          	lhu	a5,-64(s0)
    80003d44:	dfe1                	beqz	a5,80003d1c <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003d46:	fc240593          	addi	a1,s0,-62
    80003d4a:	854e                	mv	a0,s3
    80003d4c:	00000097          	auipc	ra,0x0
    80003d50:	f6c080e7          	jalr	-148(ra) # 80003cb8 <namecmp>
    80003d54:	f561                	bnez	a0,80003d1c <dirlookup+0x4a>
      if(poff)
    80003d56:	000a0463          	beqz	s4,80003d5e <dirlookup+0x8c>
        *poff = off;
    80003d5a:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003d5e:	fc045583          	lhu	a1,-64(s0)
    80003d62:	00092503          	lw	a0,0(s2)
    80003d66:	fffff097          	auipc	ra,0xfffff
    80003d6a:	754080e7          	jalr	1876(ra) # 800034ba <iget>
    80003d6e:	a011                	j	80003d72 <dirlookup+0xa0>
  return 0;
    80003d70:	4501                	li	a0,0
}
    80003d72:	70e2                	ld	ra,56(sp)
    80003d74:	7442                	ld	s0,48(sp)
    80003d76:	74a2                	ld	s1,40(sp)
    80003d78:	7902                	ld	s2,32(sp)
    80003d7a:	69e2                	ld	s3,24(sp)
    80003d7c:	6a42                	ld	s4,16(sp)
    80003d7e:	6121                	addi	sp,sp,64
    80003d80:	8082                	ret

0000000080003d82 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003d82:	711d                	addi	sp,sp,-96
    80003d84:	ec86                	sd	ra,88(sp)
    80003d86:	e8a2                	sd	s0,80(sp)
    80003d88:	e4a6                	sd	s1,72(sp)
    80003d8a:	e0ca                	sd	s2,64(sp)
    80003d8c:	fc4e                	sd	s3,56(sp)
    80003d8e:	f852                	sd	s4,48(sp)
    80003d90:	f456                	sd	s5,40(sp)
    80003d92:	f05a                	sd	s6,32(sp)
    80003d94:	ec5e                	sd	s7,24(sp)
    80003d96:	e862                	sd	s8,16(sp)
    80003d98:	e466                	sd	s9,8(sp)
    80003d9a:	1080                	addi	s0,sp,96
    80003d9c:	84aa                	mv	s1,a0
    80003d9e:	8b2e                	mv	s6,a1
    80003da0:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003da2:	00054703          	lbu	a4,0(a0)
    80003da6:	02f00793          	li	a5,47
    80003daa:	02f70363          	beq	a4,a5,80003dd0 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003dae:	ffffe097          	auipc	ra,0xffffe
    80003db2:	bf8080e7          	jalr	-1032(ra) # 800019a6 <myproc>
    80003db6:	15053503          	ld	a0,336(a0)
    80003dba:	00000097          	auipc	ra,0x0
    80003dbe:	9f6080e7          	jalr	-1546(ra) # 800037b0 <idup>
    80003dc2:	89aa                	mv	s3,a0
  while(*path == '/')
    80003dc4:	02f00913          	li	s2,47
  len = path - s;
    80003dc8:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    80003dca:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003dcc:	4c05                	li	s8,1
    80003dce:	a865                	j	80003e86 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80003dd0:	4585                	li	a1,1
    80003dd2:	4505                	li	a0,1
    80003dd4:	fffff097          	auipc	ra,0xfffff
    80003dd8:	6e6080e7          	jalr	1766(ra) # 800034ba <iget>
    80003ddc:	89aa                	mv	s3,a0
    80003dde:	b7dd                	j	80003dc4 <namex+0x42>
      iunlockput(ip);
    80003de0:	854e                	mv	a0,s3
    80003de2:	00000097          	auipc	ra,0x0
    80003de6:	c6e080e7          	jalr	-914(ra) # 80003a50 <iunlockput>
      return 0;
    80003dea:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003dec:	854e                	mv	a0,s3
    80003dee:	60e6                	ld	ra,88(sp)
    80003df0:	6446                	ld	s0,80(sp)
    80003df2:	64a6                	ld	s1,72(sp)
    80003df4:	6906                	ld	s2,64(sp)
    80003df6:	79e2                	ld	s3,56(sp)
    80003df8:	7a42                	ld	s4,48(sp)
    80003dfa:	7aa2                	ld	s5,40(sp)
    80003dfc:	7b02                	ld	s6,32(sp)
    80003dfe:	6be2                	ld	s7,24(sp)
    80003e00:	6c42                	ld	s8,16(sp)
    80003e02:	6ca2                	ld	s9,8(sp)
    80003e04:	6125                	addi	sp,sp,96
    80003e06:	8082                	ret
      iunlock(ip);
    80003e08:	854e                	mv	a0,s3
    80003e0a:	00000097          	auipc	ra,0x0
    80003e0e:	aa6080e7          	jalr	-1370(ra) # 800038b0 <iunlock>
      return ip;
    80003e12:	bfe9                	j	80003dec <namex+0x6a>
      iunlockput(ip);
    80003e14:	854e                	mv	a0,s3
    80003e16:	00000097          	auipc	ra,0x0
    80003e1a:	c3a080e7          	jalr	-966(ra) # 80003a50 <iunlockput>
      return 0;
    80003e1e:	89d2                	mv	s3,s4
    80003e20:	b7f1                	j	80003dec <namex+0x6a>
  len = path - s;
    80003e22:	40b48633          	sub	a2,s1,a1
    80003e26:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    80003e2a:	094cd463          	bge	s9,s4,80003eb2 <namex+0x130>
    memmove(name, s, DIRSIZ);
    80003e2e:	4639                	li	a2,14
    80003e30:	8556                	mv	a0,s5
    80003e32:	ffffd097          	auipc	ra,0xffffd
    80003e36:	f00080e7          	jalr	-256(ra) # 80000d32 <memmove>
  while(*path == '/')
    80003e3a:	0004c783          	lbu	a5,0(s1)
    80003e3e:	01279763          	bne	a5,s2,80003e4c <namex+0xca>
    path++;
    80003e42:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003e44:	0004c783          	lbu	a5,0(s1)
    80003e48:	ff278de3          	beq	a5,s2,80003e42 <namex+0xc0>
    ilock(ip);
    80003e4c:	854e                	mv	a0,s3
    80003e4e:	00000097          	auipc	ra,0x0
    80003e52:	9a0080e7          	jalr	-1632(ra) # 800037ee <ilock>
    if(ip->type != T_DIR){
    80003e56:	04499783          	lh	a5,68(s3)
    80003e5a:	f98793e3          	bne	a5,s8,80003de0 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80003e5e:	000b0563          	beqz	s6,80003e68 <namex+0xe6>
    80003e62:	0004c783          	lbu	a5,0(s1)
    80003e66:	d3cd                	beqz	a5,80003e08 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003e68:	865e                	mv	a2,s7
    80003e6a:	85d6                	mv	a1,s5
    80003e6c:	854e                	mv	a0,s3
    80003e6e:	00000097          	auipc	ra,0x0
    80003e72:	e64080e7          	jalr	-412(ra) # 80003cd2 <dirlookup>
    80003e76:	8a2a                	mv	s4,a0
    80003e78:	dd51                	beqz	a0,80003e14 <namex+0x92>
    iunlockput(ip);
    80003e7a:	854e                	mv	a0,s3
    80003e7c:	00000097          	auipc	ra,0x0
    80003e80:	bd4080e7          	jalr	-1068(ra) # 80003a50 <iunlockput>
    ip = next;
    80003e84:	89d2                	mv	s3,s4
  while(*path == '/')
    80003e86:	0004c783          	lbu	a5,0(s1)
    80003e8a:	05279763          	bne	a5,s2,80003ed8 <namex+0x156>
    path++;
    80003e8e:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003e90:	0004c783          	lbu	a5,0(s1)
    80003e94:	ff278de3          	beq	a5,s2,80003e8e <namex+0x10c>
  if(*path == 0)
    80003e98:	c79d                	beqz	a5,80003ec6 <namex+0x144>
    path++;
    80003e9a:	85a6                	mv	a1,s1
  len = path - s;
    80003e9c:	8a5e                	mv	s4,s7
    80003e9e:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80003ea0:	01278963          	beq	a5,s2,80003eb2 <namex+0x130>
    80003ea4:	dfbd                	beqz	a5,80003e22 <namex+0xa0>
    path++;
    80003ea6:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80003ea8:	0004c783          	lbu	a5,0(s1)
    80003eac:	ff279ce3          	bne	a5,s2,80003ea4 <namex+0x122>
    80003eb0:	bf8d                	j	80003e22 <namex+0xa0>
    memmove(name, s, len);
    80003eb2:	2601                	sext.w	a2,a2
    80003eb4:	8556                	mv	a0,s5
    80003eb6:	ffffd097          	auipc	ra,0xffffd
    80003eba:	e7c080e7          	jalr	-388(ra) # 80000d32 <memmove>
    name[len] = 0;
    80003ebe:	9a56                	add	s4,s4,s5
    80003ec0:	000a0023          	sb	zero,0(s4)
    80003ec4:	bf9d                	j	80003e3a <namex+0xb8>
  if(nameiparent){
    80003ec6:	f20b03e3          	beqz	s6,80003dec <namex+0x6a>
    iput(ip);
    80003eca:	854e                	mv	a0,s3
    80003ecc:	00000097          	auipc	ra,0x0
    80003ed0:	adc080e7          	jalr	-1316(ra) # 800039a8 <iput>
    return 0;
    80003ed4:	4981                	li	s3,0
    80003ed6:	bf19                	j	80003dec <namex+0x6a>
  if(*path == 0)
    80003ed8:	d7fd                	beqz	a5,80003ec6 <namex+0x144>
  while(*path != '/' && *path != 0)
    80003eda:	0004c783          	lbu	a5,0(s1)
    80003ede:	85a6                	mv	a1,s1
    80003ee0:	b7d1                	j	80003ea4 <namex+0x122>

0000000080003ee2 <dirlink>:
{
    80003ee2:	7139                	addi	sp,sp,-64
    80003ee4:	fc06                	sd	ra,56(sp)
    80003ee6:	f822                	sd	s0,48(sp)
    80003ee8:	f426                	sd	s1,40(sp)
    80003eea:	f04a                	sd	s2,32(sp)
    80003eec:	ec4e                	sd	s3,24(sp)
    80003eee:	e852                	sd	s4,16(sp)
    80003ef0:	0080                	addi	s0,sp,64
    80003ef2:	892a                	mv	s2,a0
    80003ef4:	8a2e                	mv	s4,a1
    80003ef6:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003ef8:	4601                	li	a2,0
    80003efa:	00000097          	auipc	ra,0x0
    80003efe:	dd8080e7          	jalr	-552(ra) # 80003cd2 <dirlookup>
    80003f02:	e93d                	bnez	a0,80003f78 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003f04:	04c92483          	lw	s1,76(s2)
    80003f08:	c49d                	beqz	s1,80003f36 <dirlink+0x54>
    80003f0a:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003f0c:	4741                	li	a4,16
    80003f0e:	86a6                	mv	a3,s1
    80003f10:	fc040613          	addi	a2,s0,-64
    80003f14:	4581                	li	a1,0
    80003f16:	854a                	mv	a0,s2
    80003f18:	00000097          	auipc	ra,0x0
    80003f1c:	b8a080e7          	jalr	-1142(ra) # 80003aa2 <readi>
    80003f20:	47c1                	li	a5,16
    80003f22:	06f51163          	bne	a0,a5,80003f84 <dirlink+0xa2>
    if(de.inum == 0)
    80003f26:	fc045783          	lhu	a5,-64(s0)
    80003f2a:	c791                	beqz	a5,80003f36 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003f2c:	24c1                	addiw	s1,s1,16
    80003f2e:	04c92783          	lw	a5,76(s2)
    80003f32:	fcf4ede3          	bltu	s1,a5,80003f0c <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003f36:	4639                	li	a2,14
    80003f38:	85d2                	mv	a1,s4
    80003f3a:	fc240513          	addi	a0,s0,-62
    80003f3e:	ffffd097          	auipc	ra,0xffffd
    80003f42:	eac080e7          	jalr	-340(ra) # 80000dea <strncpy>
  de.inum = inum;
    80003f46:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003f4a:	4741                	li	a4,16
    80003f4c:	86a6                	mv	a3,s1
    80003f4e:	fc040613          	addi	a2,s0,-64
    80003f52:	4581                	li	a1,0
    80003f54:	854a                	mv	a0,s2
    80003f56:	00000097          	auipc	ra,0x0
    80003f5a:	c44080e7          	jalr	-956(ra) # 80003b9a <writei>
    80003f5e:	872a                	mv	a4,a0
    80003f60:	47c1                	li	a5,16
  return 0;
    80003f62:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003f64:	02f71863          	bne	a4,a5,80003f94 <dirlink+0xb2>
}
    80003f68:	70e2                	ld	ra,56(sp)
    80003f6a:	7442                	ld	s0,48(sp)
    80003f6c:	74a2                	ld	s1,40(sp)
    80003f6e:	7902                	ld	s2,32(sp)
    80003f70:	69e2                	ld	s3,24(sp)
    80003f72:	6a42                	ld	s4,16(sp)
    80003f74:	6121                	addi	sp,sp,64
    80003f76:	8082                	ret
    iput(ip);
    80003f78:	00000097          	auipc	ra,0x0
    80003f7c:	a30080e7          	jalr	-1488(ra) # 800039a8 <iput>
    return -1;
    80003f80:	557d                	li	a0,-1
    80003f82:	b7dd                	j	80003f68 <dirlink+0x86>
      panic("dirlink read");
    80003f84:	00004517          	auipc	a0,0x4
    80003f88:	68c50513          	addi	a0,a0,1676 # 80008610 <syscalls+0x1d8>
    80003f8c:	ffffc097          	auipc	ra,0xffffc
    80003f90:	5a4080e7          	jalr	1444(ra) # 80000530 <panic>
    panic("dirlink");
    80003f94:	00004517          	auipc	a0,0x4
    80003f98:	78c50513          	addi	a0,a0,1932 # 80008720 <syscalls+0x2e8>
    80003f9c:	ffffc097          	auipc	ra,0xffffc
    80003fa0:	594080e7          	jalr	1428(ra) # 80000530 <panic>

0000000080003fa4 <namei>:

struct inode*
namei(char *path)
{
    80003fa4:	1101                	addi	sp,sp,-32
    80003fa6:	ec06                	sd	ra,24(sp)
    80003fa8:	e822                	sd	s0,16(sp)
    80003faa:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003fac:	fe040613          	addi	a2,s0,-32
    80003fb0:	4581                	li	a1,0
    80003fb2:	00000097          	auipc	ra,0x0
    80003fb6:	dd0080e7          	jalr	-560(ra) # 80003d82 <namex>
}
    80003fba:	60e2                	ld	ra,24(sp)
    80003fbc:	6442                	ld	s0,16(sp)
    80003fbe:	6105                	addi	sp,sp,32
    80003fc0:	8082                	ret

0000000080003fc2 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003fc2:	1141                	addi	sp,sp,-16
    80003fc4:	e406                	sd	ra,8(sp)
    80003fc6:	e022                	sd	s0,0(sp)
    80003fc8:	0800                	addi	s0,sp,16
    80003fca:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003fcc:	4585                	li	a1,1
    80003fce:	00000097          	auipc	ra,0x0
    80003fd2:	db4080e7          	jalr	-588(ra) # 80003d82 <namex>
}
    80003fd6:	60a2                	ld	ra,8(sp)
    80003fd8:	6402                	ld	s0,0(sp)
    80003fda:	0141                	addi	sp,sp,16
    80003fdc:	8082                	ret

0000000080003fde <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003fde:	1101                	addi	sp,sp,-32
    80003fe0:	ec06                	sd	ra,24(sp)
    80003fe2:	e822                	sd	s0,16(sp)
    80003fe4:	e426                	sd	s1,8(sp)
    80003fe6:	e04a                	sd	s2,0(sp)
    80003fe8:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003fea:	0002d917          	auipc	s2,0x2d
    80003fee:	26e90913          	addi	s2,s2,622 # 80031258 <log>
    80003ff2:	01892583          	lw	a1,24(s2)
    80003ff6:	02892503          	lw	a0,40(s2)
    80003ffa:	fffff097          	auipc	ra,0xfffff
    80003ffe:	ff2080e7          	jalr	-14(ra) # 80002fec <bread>
    80004002:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80004004:	02c92683          	lw	a3,44(s2)
    80004008:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000400a:	02d05763          	blez	a3,80004038 <write_head+0x5a>
    8000400e:	0002d797          	auipc	a5,0x2d
    80004012:	27a78793          	addi	a5,a5,634 # 80031288 <log+0x30>
    80004016:	05c50713          	addi	a4,a0,92
    8000401a:	36fd                	addiw	a3,a3,-1
    8000401c:	1682                	slli	a3,a3,0x20
    8000401e:	9281                	srli	a3,a3,0x20
    80004020:	068a                	slli	a3,a3,0x2
    80004022:	0002d617          	auipc	a2,0x2d
    80004026:	26a60613          	addi	a2,a2,618 # 8003128c <log+0x34>
    8000402a:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    8000402c:	4390                	lw	a2,0(a5)
    8000402e:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80004030:	0791                	addi	a5,a5,4
    80004032:	0711                	addi	a4,a4,4
    80004034:	fed79ce3          	bne	a5,a3,8000402c <write_head+0x4e>
  }
  bwrite(buf);
    80004038:	8526                	mv	a0,s1
    8000403a:	fffff097          	auipc	ra,0xfffff
    8000403e:	0a4080e7          	jalr	164(ra) # 800030de <bwrite>
  brelse(buf);
    80004042:	8526                	mv	a0,s1
    80004044:	fffff097          	auipc	ra,0xfffff
    80004048:	0d8080e7          	jalr	216(ra) # 8000311c <brelse>
}
    8000404c:	60e2                	ld	ra,24(sp)
    8000404e:	6442                	ld	s0,16(sp)
    80004050:	64a2                	ld	s1,8(sp)
    80004052:	6902                	ld	s2,0(sp)
    80004054:	6105                	addi	sp,sp,32
    80004056:	8082                	ret

0000000080004058 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80004058:	0002d797          	auipc	a5,0x2d
    8000405c:	22c7a783          	lw	a5,556(a5) # 80031284 <log+0x2c>
    80004060:	0af05d63          	blez	a5,8000411a <install_trans+0xc2>
{
    80004064:	7139                	addi	sp,sp,-64
    80004066:	fc06                	sd	ra,56(sp)
    80004068:	f822                	sd	s0,48(sp)
    8000406a:	f426                	sd	s1,40(sp)
    8000406c:	f04a                	sd	s2,32(sp)
    8000406e:	ec4e                	sd	s3,24(sp)
    80004070:	e852                	sd	s4,16(sp)
    80004072:	e456                	sd	s5,8(sp)
    80004074:	e05a                	sd	s6,0(sp)
    80004076:	0080                	addi	s0,sp,64
    80004078:	8b2a                	mv	s6,a0
    8000407a:	0002da97          	auipc	s5,0x2d
    8000407e:	20ea8a93          	addi	s5,s5,526 # 80031288 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004082:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004084:	0002d997          	auipc	s3,0x2d
    80004088:	1d498993          	addi	s3,s3,468 # 80031258 <log>
    8000408c:	a035                	j	800040b8 <install_trans+0x60>
      bunpin(dbuf);
    8000408e:	8526                	mv	a0,s1
    80004090:	fffff097          	auipc	ra,0xfffff
    80004094:	166080e7          	jalr	358(ra) # 800031f6 <bunpin>
    brelse(lbuf);
    80004098:	854a                	mv	a0,s2
    8000409a:	fffff097          	auipc	ra,0xfffff
    8000409e:	082080e7          	jalr	130(ra) # 8000311c <brelse>
    brelse(dbuf);
    800040a2:	8526                	mv	a0,s1
    800040a4:	fffff097          	auipc	ra,0xfffff
    800040a8:	078080e7          	jalr	120(ra) # 8000311c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800040ac:	2a05                	addiw	s4,s4,1
    800040ae:	0a91                	addi	s5,s5,4
    800040b0:	02c9a783          	lw	a5,44(s3)
    800040b4:	04fa5963          	bge	s4,a5,80004106 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800040b8:	0189a583          	lw	a1,24(s3)
    800040bc:	014585bb          	addw	a1,a1,s4
    800040c0:	2585                	addiw	a1,a1,1
    800040c2:	0289a503          	lw	a0,40(s3)
    800040c6:	fffff097          	auipc	ra,0xfffff
    800040ca:	f26080e7          	jalr	-218(ra) # 80002fec <bread>
    800040ce:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800040d0:	000aa583          	lw	a1,0(s5)
    800040d4:	0289a503          	lw	a0,40(s3)
    800040d8:	fffff097          	auipc	ra,0xfffff
    800040dc:	f14080e7          	jalr	-236(ra) # 80002fec <bread>
    800040e0:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800040e2:	40000613          	li	a2,1024
    800040e6:	05890593          	addi	a1,s2,88
    800040ea:	05850513          	addi	a0,a0,88
    800040ee:	ffffd097          	auipc	ra,0xffffd
    800040f2:	c44080e7          	jalr	-956(ra) # 80000d32 <memmove>
    bwrite(dbuf);  // write dst to disk
    800040f6:	8526                	mv	a0,s1
    800040f8:	fffff097          	auipc	ra,0xfffff
    800040fc:	fe6080e7          	jalr	-26(ra) # 800030de <bwrite>
    if(recovering == 0)
    80004100:	f80b1ce3          	bnez	s6,80004098 <install_trans+0x40>
    80004104:	b769                	j	8000408e <install_trans+0x36>
}
    80004106:	70e2                	ld	ra,56(sp)
    80004108:	7442                	ld	s0,48(sp)
    8000410a:	74a2                	ld	s1,40(sp)
    8000410c:	7902                	ld	s2,32(sp)
    8000410e:	69e2                	ld	s3,24(sp)
    80004110:	6a42                	ld	s4,16(sp)
    80004112:	6aa2                	ld	s5,8(sp)
    80004114:	6b02                	ld	s6,0(sp)
    80004116:	6121                	addi	sp,sp,64
    80004118:	8082                	ret
    8000411a:	8082                	ret

000000008000411c <initlog>:
{
    8000411c:	7179                	addi	sp,sp,-48
    8000411e:	f406                	sd	ra,40(sp)
    80004120:	f022                	sd	s0,32(sp)
    80004122:	ec26                	sd	s1,24(sp)
    80004124:	e84a                	sd	s2,16(sp)
    80004126:	e44e                	sd	s3,8(sp)
    80004128:	1800                	addi	s0,sp,48
    8000412a:	892a                	mv	s2,a0
    8000412c:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000412e:	0002d497          	auipc	s1,0x2d
    80004132:	12a48493          	addi	s1,s1,298 # 80031258 <log>
    80004136:	00004597          	auipc	a1,0x4
    8000413a:	4ea58593          	addi	a1,a1,1258 # 80008620 <syscalls+0x1e8>
    8000413e:	8526                	mv	a0,s1
    80004140:	ffffd097          	auipc	ra,0xffffd
    80004144:	a06080e7          	jalr	-1530(ra) # 80000b46 <initlock>
  log.start = sb->logstart;
    80004148:	0149a583          	lw	a1,20(s3)
    8000414c:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000414e:	0109a783          	lw	a5,16(s3)
    80004152:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80004154:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80004158:	854a                	mv	a0,s2
    8000415a:	fffff097          	auipc	ra,0xfffff
    8000415e:	e92080e7          	jalr	-366(ra) # 80002fec <bread>
  log.lh.n = lh->n;
    80004162:	4d3c                	lw	a5,88(a0)
    80004164:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80004166:	02f05563          	blez	a5,80004190 <initlog+0x74>
    8000416a:	05c50713          	addi	a4,a0,92
    8000416e:	0002d697          	auipc	a3,0x2d
    80004172:	11a68693          	addi	a3,a3,282 # 80031288 <log+0x30>
    80004176:	37fd                	addiw	a5,a5,-1
    80004178:	1782                	slli	a5,a5,0x20
    8000417a:	9381                	srli	a5,a5,0x20
    8000417c:	078a                	slli	a5,a5,0x2
    8000417e:	06050613          	addi	a2,a0,96
    80004182:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    80004184:	4310                	lw	a2,0(a4)
    80004186:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    80004188:	0711                	addi	a4,a4,4
    8000418a:	0691                	addi	a3,a3,4
    8000418c:	fef71ce3          	bne	a4,a5,80004184 <initlog+0x68>
  brelse(buf);
    80004190:	fffff097          	auipc	ra,0xfffff
    80004194:	f8c080e7          	jalr	-116(ra) # 8000311c <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80004198:	4505                	li	a0,1
    8000419a:	00000097          	auipc	ra,0x0
    8000419e:	ebe080e7          	jalr	-322(ra) # 80004058 <install_trans>
  log.lh.n = 0;
    800041a2:	0002d797          	auipc	a5,0x2d
    800041a6:	0e07a123          	sw	zero,226(a5) # 80031284 <log+0x2c>
  write_head(); // clear the log
    800041aa:	00000097          	auipc	ra,0x0
    800041ae:	e34080e7          	jalr	-460(ra) # 80003fde <write_head>
}
    800041b2:	70a2                	ld	ra,40(sp)
    800041b4:	7402                	ld	s0,32(sp)
    800041b6:	64e2                	ld	s1,24(sp)
    800041b8:	6942                	ld	s2,16(sp)
    800041ba:	69a2                	ld	s3,8(sp)
    800041bc:	6145                	addi	sp,sp,48
    800041be:	8082                	ret

00000000800041c0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800041c0:	1101                	addi	sp,sp,-32
    800041c2:	ec06                	sd	ra,24(sp)
    800041c4:	e822                	sd	s0,16(sp)
    800041c6:	e426                	sd	s1,8(sp)
    800041c8:	e04a                	sd	s2,0(sp)
    800041ca:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800041cc:	0002d517          	auipc	a0,0x2d
    800041d0:	08c50513          	addi	a0,a0,140 # 80031258 <log>
    800041d4:	ffffd097          	auipc	ra,0xffffd
    800041d8:	a02080e7          	jalr	-1534(ra) # 80000bd6 <acquire>
  while(1){
    if(log.committing){
    800041dc:	0002d497          	auipc	s1,0x2d
    800041e0:	07c48493          	addi	s1,s1,124 # 80031258 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800041e4:	4979                	li	s2,30
    800041e6:	a039                	j	800041f4 <begin_op+0x34>
      sleep(&log, &log.lock);
    800041e8:	85a6                	mv	a1,s1
    800041ea:	8526                	mv	a0,s1
    800041ec:	ffffe097          	auipc	ra,0xffffe
    800041f0:	082080e7          	jalr	130(ra) # 8000226e <sleep>
    if(log.committing){
    800041f4:	50dc                	lw	a5,36(s1)
    800041f6:	fbed                	bnez	a5,800041e8 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800041f8:	509c                	lw	a5,32(s1)
    800041fa:	0017871b          	addiw	a4,a5,1
    800041fe:	0007069b          	sext.w	a3,a4
    80004202:	0027179b          	slliw	a5,a4,0x2
    80004206:	9fb9                	addw	a5,a5,a4
    80004208:	0017979b          	slliw	a5,a5,0x1
    8000420c:	54d8                	lw	a4,44(s1)
    8000420e:	9fb9                	addw	a5,a5,a4
    80004210:	00f95963          	bge	s2,a5,80004222 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80004214:	85a6                	mv	a1,s1
    80004216:	8526                	mv	a0,s1
    80004218:	ffffe097          	auipc	ra,0xffffe
    8000421c:	056080e7          	jalr	86(ra) # 8000226e <sleep>
    80004220:	bfd1                	j	800041f4 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80004222:	0002d517          	auipc	a0,0x2d
    80004226:	03650513          	addi	a0,a0,54 # 80031258 <log>
    8000422a:	d114                	sw	a3,32(a0)
      release(&log.lock);
    8000422c:	ffffd097          	auipc	ra,0xffffd
    80004230:	a5e080e7          	jalr	-1442(ra) # 80000c8a <release>
      break;
    }
  }
}
    80004234:	60e2                	ld	ra,24(sp)
    80004236:	6442                	ld	s0,16(sp)
    80004238:	64a2                	ld	s1,8(sp)
    8000423a:	6902                	ld	s2,0(sp)
    8000423c:	6105                	addi	sp,sp,32
    8000423e:	8082                	ret

0000000080004240 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80004240:	7139                	addi	sp,sp,-64
    80004242:	fc06                	sd	ra,56(sp)
    80004244:	f822                	sd	s0,48(sp)
    80004246:	f426                	sd	s1,40(sp)
    80004248:	f04a                	sd	s2,32(sp)
    8000424a:	ec4e                	sd	s3,24(sp)
    8000424c:	e852                	sd	s4,16(sp)
    8000424e:	e456                	sd	s5,8(sp)
    80004250:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80004252:	0002d497          	auipc	s1,0x2d
    80004256:	00648493          	addi	s1,s1,6 # 80031258 <log>
    8000425a:	8526                	mv	a0,s1
    8000425c:	ffffd097          	auipc	ra,0xffffd
    80004260:	97a080e7          	jalr	-1670(ra) # 80000bd6 <acquire>
  log.outstanding -= 1;
    80004264:	509c                	lw	a5,32(s1)
    80004266:	37fd                	addiw	a5,a5,-1
    80004268:	0007891b          	sext.w	s2,a5
    8000426c:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000426e:	50dc                	lw	a5,36(s1)
    80004270:	efb9                	bnez	a5,800042ce <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    80004272:	06091663          	bnez	s2,800042de <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    80004276:	0002d497          	auipc	s1,0x2d
    8000427a:	fe248493          	addi	s1,s1,-30 # 80031258 <log>
    8000427e:	4785                	li	a5,1
    80004280:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80004282:	8526                	mv	a0,s1
    80004284:	ffffd097          	auipc	ra,0xffffd
    80004288:	a06080e7          	jalr	-1530(ra) # 80000c8a <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000428c:	54dc                	lw	a5,44(s1)
    8000428e:	06f04763          	bgtz	a5,800042fc <end_op+0xbc>
    acquire(&log.lock);
    80004292:	0002d497          	auipc	s1,0x2d
    80004296:	fc648493          	addi	s1,s1,-58 # 80031258 <log>
    8000429a:	8526                	mv	a0,s1
    8000429c:	ffffd097          	auipc	ra,0xffffd
    800042a0:	93a080e7          	jalr	-1734(ra) # 80000bd6 <acquire>
    log.committing = 0;
    800042a4:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800042a8:	8526                	mv	a0,s1
    800042aa:	ffffe097          	auipc	ra,0xffffe
    800042ae:	14a080e7          	jalr	330(ra) # 800023f4 <wakeup>
    release(&log.lock);
    800042b2:	8526                	mv	a0,s1
    800042b4:	ffffd097          	auipc	ra,0xffffd
    800042b8:	9d6080e7          	jalr	-1578(ra) # 80000c8a <release>
}
    800042bc:	70e2                	ld	ra,56(sp)
    800042be:	7442                	ld	s0,48(sp)
    800042c0:	74a2                	ld	s1,40(sp)
    800042c2:	7902                	ld	s2,32(sp)
    800042c4:	69e2                	ld	s3,24(sp)
    800042c6:	6a42                	ld	s4,16(sp)
    800042c8:	6aa2                	ld	s5,8(sp)
    800042ca:	6121                	addi	sp,sp,64
    800042cc:	8082                	ret
    panic("log.committing");
    800042ce:	00004517          	auipc	a0,0x4
    800042d2:	35a50513          	addi	a0,a0,858 # 80008628 <syscalls+0x1f0>
    800042d6:	ffffc097          	auipc	ra,0xffffc
    800042da:	25a080e7          	jalr	602(ra) # 80000530 <panic>
    wakeup(&log);
    800042de:	0002d497          	auipc	s1,0x2d
    800042e2:	f7a48493          	addi	s1,s1,-134 # 80031258 <log>
    800042e6:	8526                	mv	a0,s1
    800042e8:	ffffe097          	auipc	ra,0xffffe
    800042ec:	10c080e7          	jalr	268(ra) # 800023f4 <wakeup>
  release(&log.lock);
    800042f0:	8526                	mv	a0,s1
    800042f2:	ffffd097          	auipc	ra,0xffffd
    800042f6:	998080e7          	jalr	-1640(ra) # 80000c8a <release>
  if(do_commit){
    800042fa:	b7c9                	j	800042bc <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    800042fc:	0002da97          	auipc	s5,0x2d
    80004300:	f8ca8a93          	addi	s5,s5,-116 # 80031288 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80004304:	0002da17          	auipc	s4,0x2d
    80004308:	f54a0a13          	addi	s4,s4,-172 # 80031258 <log>
    8000430c:	018a2583          	lw	a1,24(s4)
    80004310:	012585bb          	addw	a1,a1,s2
    80004314:	2585                	addiw	a1,a1,1
    80004316:	028a2503          	lw	a0,40(s4)
    8000431a:	fffff097          	auipc	ra,0xfffff
    8000431e:	cd2080e7          	jalr	-814(ra) # 80002fec <bread>
    80004322:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80004324:	000aa583          	lw	a1,0(s5)
    80004328:	028a2503          	lw	a0,40(s4)
    8000432c:	fffff097          	auipc	ra,0xfffff
    80004330:	cc0080e7          	jalr	-832(ra) # 80002fec <bread>
    80004334:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80004336:	40000613          	li	a2,1024
    8000433a:	05850593          	addi	a1,a0,88
    8000433e:	05848513          	addi	a0,s1,88
    80004342:	ffffd097          	auipc	ra,0xffffd
    80004346:	9f0080e7          	jalr	-1552(ra) # 80000d32 <memmove>
    bwrite(to);  // write the log
    8000434a:	8526                	mv	a0,s1
    8000434c:	fffff097          	auipc	ra,0xfffff
    80004350:	d92080e7          	jalr	-622(ra) # 800030de <bwrite>
    brelse(from);
    80004354:	854e                	mv	a0,s3
    80004356:	fffff097          	auipc	ra,0xfffff
    8000435a:	dc6080e7          	jalr	-570(ra) # 8000311c <brelse>
    brelse(to);
    8000435e:	8526                	mv	a0,s1
    80004360:	fffff097          	auipc	ra,0xfffff
    80004364:	dbc080e7          	jalr	-580(ra) # 8000311c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004368:	2905                	addiw	s2,s2,1
    8000436a:	0a91                	addi	s5,s5,4
    8000436c:	02ca2783          	lw	a5,44(s4)
    80004370:	f8f94ee3          	blt	s2,a5,8000430c <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80004374:	00000097          	auipc	ra,0x0
    80004378:	c6a080e7          	jalr	-918(ra) # 80003fde <write_head>
    install_trans(0); // Now install writes to home locations
    8000437c:	4501                	li	a0,0
    8000437e:	00000097          	auipc	ra,0x0
    80004382:	cda080e7          	jalr	-806(ra) # 80004058 <install_trans>
    log.lh.n = 0;
    80004386:	0002d797          	auipc	a5,0x2d
    8000438a:	ee07af23          	sw	zero,-258(a5) # 80031284 <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000438e:	00000097          	auipc	ra,0x0
    80004392:	c50080e7          	jalr	-944(ra) # 80003fde <write_head>
    80004396:	bdf5                	j	80004292 <end_op+0x52>

0000000080004398 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80004398:	1101                	addi	sp,sp,-32
    8000439a:	ec06                	sd	ra,24(sp)
    8000439c:	e822                	sd	s0,16(sp)
    8000439e:	e426                	sd	s1,8(sp)
    800043a0:	e04a                	sd	s2,0(sp)
    800043a2:	1000                	addi	s0,sp,32
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800043a4:	0002d717          	auipc	a4,0x2d
    800043a8:	ee072703          	lw	a4,-288(a4) # 80031284 <log+0x2c>
    800043ac:	47f5                	li	a5,29
    800043ae:	08e7c063          	blt	a5,a4,8000442e <log_write+0x96>
    800043b2:	84aa                	mv	s1,a0
    800043b4:	0002d797          	auipc	a5,0x2d
    800043b8:	ec07a783          	lw	a5,-320(a5) # 80031274 <log+0x1c>
    800043bc:	37fd                	addiw	a5,a5,-1
    800043be:	06f75863          	bge	a4,a5,8000442e <log_write+0x96>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800043c2:	0002d797          	auipc	a5,0x2d
    800043c6:	eb67a783          	lw	a5,-330(a5) # 80031278 <log+0x20>
    800043ca:	06f05a63          	blez	a5,8000443e <log_write+0xa6>
    panic("log_write outside of trans");

  acquire(&log.lock);
    800043ce:	0002d917          	auipc	s2,0x2d
    800043d2:	e8a90913          	addi	s2,s2,-374 # 80031258 <log>
    800043d6:	854a                	mv	a0,s2
    800043d8:	ffffc097          	auipc	ra,0xffffc
    800043dc:	7fe080e7          	jalr	2046(ra) # 80000bd6 <acquire>
  for (i = 0; i < log.lh.n; i++) {
    800043e0:	02c92603          	lw	a2,44(s2)
    800043e4:	06c05563          	blez	a2,8000444e <log_write+0xb6>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    800043e8:	44cc                	lw	a1,12(s1)
    800043ea:	0002d717          	auipc	a4,0x2d
    800043ee:	e9e70713          	addi	a4,a4,-354 # 80031288 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800043f2:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    800043f4:	4314                	lw	a3,0(a4)
    800043f6:	04b68d63          	beq	a3,a1,80004450 <log_write+0xb8>
  for (i = 0; i < log.lh.n; i++) {
    800043fa:	2785                	addiw	a5,a5,1
    800043fc:	0711                	addi	a4,a4,4
    800043fe:	fec79be3          	bne	a5,a2,800043f4 <log_write+0x5c>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004402:	0621                	addi	a2,a2,8
    80004404:	060a                	slli	a2,a2,0x2
    80004406:	0002d797          	auipc	a5,0x2d
    8000440a:	e5278793          	addi	a5,a5,-430 # 80031258 <log>
    8000440e:	963e                	add	a2,a2,a5
    80004410:	44dc                	lw	a5,12(s1)
    80004412:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80004414:	8526                	mv	a0,s1
    80004416:	fffff097          	auipc	ra,0xfffff
    8000441a:	da4080e7          	jalr	-604(ra) # 800031ba <bpin>
    log.lh.n++;
    8000441e:	0002d717          	auipc	a4,0x2d
    80004422:	e3a70713          	addi	a4,a4,-454 # 80031258 <log>
    80004426:	575c                	lw	a5,44(a4)
    80004428:	2785                	addiw	a5,a5,1
    8000442a:	d75c                	sw	a5,44(a4)
    8000442c:	a83d                	j	8000446a <log_write+0xd2>
    panic("too big a transaction");
    8000442e:	00004517          	auipc	a0,0x4
    80004432:	20a50513          	addi	a0,a0,522 # 80008638 <syscalls+0x200>
    80004436:	ffffc097          	auipc	ra,0xffffc
    8000443a:	0fa080e7          	jalr	250(ra) # 80000530 <panic>
    panic("log_write outside of trans");
    8000443e:	00004517          	auipc	a0,0x4
    80004442:	21250513          	addi	a0,a0,530 # 80008650 <syscalls+0x218>
    80004446:	ffffc097          	auipc	ra,0xffffc
    8000444a:	0ea080e7          	jalr	234(ra) # 80000530 <panic>
  for (i = 0; i < log.lh.n; i++) {
    8000444e:	4781                	li	a5,0
  log.lh.block[i] = b->blockno;
    80004450:	00878713          	addi	a4,a5,8
    80004454:	00271693          	slli	a3,a4,0x2
    80004458:	0002d717          	auipc	a4,0x2d
    8000445c:	e0070713          	addi	a4,a4,-512 # 80031258 <log>
    80004460:	9736                	add	a4,a4,a3
    80004462:	44d4                	lw	a3,12(s1)
    80004464:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80004466:	faf607e3          	beq	a2,a5,80004414 <log_write+0x7c>
  }
  release(&log.lock);
    8000446a:	0002d517          	auipc	a0,0x2d
    8000446e:	dee50513          	addi	a0,a0,-530 # 80031258 <log>
    80004472:	ffffd097          	auipc	ra,0xffffd
    80004476:	818080e7          	jalr	-2024(ra) # 80000c8a <release>
}
    8000447a:	60e2                	ld	ra,24(sp)
    8000447c:	6442                	ld	s0,16(sp)
    8000447e:	64a2                	ld	s1,8(sp)
    80004480:	6902                	ld	s2,0(sp)
    80004482:	6105                	addi	sp,sp,32
    80004484:	8082                	ret

0000000080004486 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004486:	1101                	addi	sp,sp,-32
    80004488:	ec06                	sd	ra,24(sp)
    8000448a:	e822                	sd	s0,16(sp)
    8000448c:	e426                	sd	s1,8(sp)
    8000448e:	e04a                	sd	s2,0(sp)
    80004490:	1000                	addi	s0,sp,32
    80004492:	84aa                	mv	s1,a0
    80004494:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004496:	00004597          	auipc	a1,0x4
    8000449a:	1da58593          	addi	a1,a1,474 # 80008670 <syscalls+0x238>
    8000449e:	0521                	addi	a0,a0,8
    800044a0:	ffffc097          	auipc	ra,0xffffc
    800044a4:	6a6080e7          	jalr	1702(ra) # 80000b46 <initlock>
  lk->name = name;
    800044a8:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800044ac:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800044b0:	0204a423          	sw	zero,40(s1)
}
    800044b4:	60e2                	ld	ra,24(sp)
    800044b6:	6442                	ld	s0,16(sp)
    800044b8:	64a2                	ld	s1,8(sp)
    800044ba:	6902                	ld	s2,0(sp)
    800044bc:	6105                	addi	sp,sp,32
    800044be:	8082                	ret

00000000800044c0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800044c0:	1101                	addi	sp,sp,-32
    800044c2:	ec06                	sd	ra,24(sp)
    800044c4:	e822                	sd	s0,16(sp)
    800044c6:	e426                	sd	s1,8(sp)
    800044c8:	e04a                	sd	s2,0(sp)
    800044ca:	1000                	addi	s0,sp,32
    800044cc:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800044ce:	00850913          	addi	s2,a0,8
    800044d2:	854a                	mv	a0,s2
    800044d4:	ffffc097          	auipc	ra,0xffffc
    800044d8:	702080e7          	jalr	1794(ra) # 80000bd6 <acquire>
  while (lk->locked) {
    800044dc:	409c                	lw	a5,0(s1)
    800044de:	cb89                	beqz	a5,800044f0 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800044e0:	85ca                	mv	a1,s2
    800044e2:	8526                	mv	a0,s1
    800044e4:	ffffe097          	auipc	ra,0xffffe
    800044e8:	d8a080e7          	jalr	-630(ra) # 8000226e <sleep>
  while (lk->locked) {
    800044ec:	409c                	lw	a5,0(s1)
    800044ee:	fbed                	bnez	a5,800044e0 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800044f0:	4785                	li	a5,1
    800044f2:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800044f4:	ffffd097          	auipc	ra,0xffffd
    800044f8:	4b2080e7          	jalr	1202(ra) # 800019a6 <myproc>
    800044fc:	5d1c                	lw	a5,56(a0)
    800044fe:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004500:	854a                	mv	a0,s2
    80004502:	ffffc097          	auipc	ra,0xffffc
    80004506:	788080e7          	jalr	1928(ra) # 80000c8a <release>
}
    8000450a:	60e2                	ld	ra,24(sp)
    8000450c:	6442                	ld	s0,16(sp)
    8000450e:	64a2                	ld	s1,8(sp)
    80004510:	6902                	ld	s2,0(sp)
    80004512:	6105                	addi	sp,sp,32
    80004514:	8082                	ret

0000000080004516 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004516:	1101                	addi	sp,sp,-32
    80004518:	ec06                	sd	ra,24(sp)
    8000451a:	e822                	sd	s0,16(sp)
    8000451c:	e426                	sd	s1,8(sp)
    8000451e:	e04a                	sd	s2,0(sp)
    80004520:	1000                	addi	s0,sp,32
    80004522:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004524:	00850913          	addi	s2,a0,8
    80004528:	854a                	mv	a0,s2
    8000452a:	ffffc097          	auipc	ra,0xffffc
    8000452e:	6ac080e7          	jalr	1708(ra) # 80000bd6 <acquire>
  lk->locked = 0;
    80004532:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004536:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    8000453a:	8526                	mv	a0,s1
    8000453c:	ffffe097          	auipc	ra,0xffffe
    80004540:	eb8080e7          	jalr	-328(ra) # 800023f4 <wakeup>
  release(&lk->lk);
    80004544:	854a                	mv	a0,s2
    80004546:	ffffc097          	auipc	ra,0xffffc
    8000454a:	744080e7          	jalr	1860(ra) # 80000c8a <release>
}
    8000454e:	60e2                	ld	ra,24(sp)
    80004550:	6442                	ld	s0,16(sp)
    80004552:	64a2                	ld	s1,8(sp)
    80004554:	6902                	ld	s2,0(sp)
    80004556:	6105                	addi	sp,sp,32
    80004558:	8082                	ret

000000008000455a <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000455a:	7179                	addi	sp,sp,-48
    8000455c:	f406                	sd	ra,40(sp)
    8000455e:	f022                	sd	s0,32(sp)
    80004560:	ec26                	sd	s1,24(sp)
    80004562:	e84a                	sd	s2,16(sp)
    80004564:	e44e                	sd	s3,8(sp)
    80004566:	1800                	addi	s0,sp,48
    80004568:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000456a:	00850913          	addi	s2,a0,8
    8000456e:	854a                	mv	a0,s2
    80004570:	ffffc097          	auipc	ra,0xffffc
    80004574:	666080e7          	jalr	1638(ra) # 80000bd6 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004578:	409c                	lw	a5,0(s1)
    8000457a:	ef99                	bnez	a5,80004598 <holdingsleep+0x3e>
    8000457c:	4481                	li	s1,0
  release(&lk->lk);
    8000457e:	854a                	mv	a0,s2
    80004580:	ffffc097          	auipc	ra,0xffffc
    80004584:	70a080e7          	jalr	1802(ra) # 80000c8a <release>
  return r;
}
    80004588:	8526                	mv	a0,s1
    8000458a:	70a2                	ld	ra,40(sp)
    8000458c:	7402                	ld	s0,32(sp)
    8000458e:	64e2                	ld	s1,24(sp)
    80004590:	6942                	ld	s2,16(sp)
    80004592:	69a2                	ld	s3,8(sp)
    80004594:	6145                	addi	sp,sp,48
    80004596:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80004598:	0284a983          	lw	s3,40(s1)
    8000459c:	ffffd097          	auipc	ra,0xffffd
    800045a0:	40a080e7          	jalr	1034(ra) # 800019a6 <myproc>
    800045a4:	5d04                	lw	s1,56(a0)
    800045a6:	413484b3          	sub	s1,s1,s3
    800045aa:	0014b493          	seqz	s1,s1
    800045ae:	bfc1                	j	8000457e <holdingsleep+0x24>

00000000800045b0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800045b0:	1141                	addi	sp,sp,-16
    800045b2:	e406                	sd	ra,8(sp)
    800045b4:	e022                	sd	s0,0(sp)
    800045b6:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800045b8:	00004597          	auipc	a1,0x4
    800045bc:	0c858593          	addi	a1,a1,200 # 80008680 <syscalls+0x248>
    800045c0:	0002d517          	auipc	a0,0x2d
    800045c4:	de050513          	addi	a0,a0,-544 # 800313a0 <ftable>
    800045c8:	ffffc097          	auipc	ra,0xffffc
    800045cc:	57e080e7          	jalr	1406(ra) # 80000b46 <initlock>
}
    800045d0:	60a2                	ld	ra,8(sp)
    800045d2:	6402                	ld	s0,0(sp)
    800045d4:	0141                	addi	sp,sp,16
    800045d6:	8082                	ret

00000000800045d8 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800045d8:	1101                	addi	sp,sp,-32
    800045da:	ec06                	sd	ra,24(sp)
    800045dc:	e822                	sd	s0,16(sp)
    800045de:	e426                	sd	s1,8(sp)
    800045e0:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800045e2:	0002d517          	auipc	a0,0x2d
    800045e6:	dbe50513          	addi	a0,a0,-578 # 800313a0 <ftable>
    800045ea:	ffffc097          	auipc	ra,0xffffc
    800045ee:	5ec080e7          	jalr	1516(ra) # 80000bd6 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800045f2:	0002d497          	auipc	s1,0x2d
    800045f6:	dc648493          	addi	s1,s1,-570 # 800313b8 <ftable+0x18>
    800045fa:	0002e717          	auipc	a4,0x2e
    800045fe:	d5e70713          	addi	a4,a4,-674 # 80032358 <ftable+0xfb8>
    if(f->ref == 0){
    80004602:	40dc                	lw	a5,4(s1)
    80004604:	cf99                	beqz	a5,80004622 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004606:	02848493          	addi	s1,s1,40
    8000460a:	fee49ce3          	bne	s1,a4,80004602 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    8000460e:	0002d517          	auipc	a0,0x2d
    80004612:	d9250513          	addi	a0,a0,-622 # 800313a0 <ftable>
    80004616:	ffffc097          	auipc	ra,0xffffc
    8000461a:	674080e7          	jalr	1652(ra) # 80000c8a <release>
  return 0;
    8000461e:	4481                	li	s1,0
    80004620:	a819                	j	80004636 <filealloc+0x5e>
      f->ref = 1;
    80004622:	4785                	li	a5,1
    80004624:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004626:	0002d517          	auipc	a0,0x2d
    8000462a:	d7a50513          	addi	a0,a0,-646 # 800313a0 <ftable>
    8000462e:	ffffc097          	auipc	ra,0xffffc
    80004632:	65c080e7          	jalr	1628(ra) # 80000c8a <release>
}
    80004636:	8526                	mv	a0,s1
    80004638:	60e2                	ld	ra,24(sp)
    8000463a:	6442                	ld	s0,16(sp)
    8000463c:	64a2                	ld	s1,8(sp)
    8000463e:	6105                	addi	sp,sp,32
    80004640:	8082                	ret

0000000080004642 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004642:	1101                	addi	sp,sp,-32
    80004644:	ec06                	sd	ra,24(sp)
    80004646:	e822                	sd	s0,16(sp)
    80004648:	e426                	sd	s1,8(sp)
    8000464a:	1000                	addi	s0,sp,32
    8000464c:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    8000464e:	0002d517          	auipc	a0,0x2d
    80004652:	d5250513          	addi	a0,a0,-686 # 800313a0 <ftable>
    80004656:	ffffc097          	auipc	ra,0xffffc
    8000465a:	580080e7          	jalr	1408(ra) # 80000bd6 <acquire>
  if(f->ref < 1)
    8000465e:	40dc                	lw	a5,4(s1)
    80004660:	02f05263          	blez	a5,80004684 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80004664:	2785                	addiw	a5,a5,1
    80004666:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004668:	0002d517          	auipc	a0,0x2d
    8000466c:	d3850513          	addi	a0,a0,-712 # 800313a0 <ftable>
    80004670:	ffffc097          	auipc	ra,0xffffc
    80004674:	61a080e7          	jalr	1562(ra) # 80000c8a <release>
  return f;
}
    80004678:	8526                	mv	a0,s1
    8000467a:	60e2                	ld	ra,24(sp)
    8000467c:	6442                	ld	s0,16(sp)
    8000467e:	64a2                	ld	s1,8(sp)
    80004680:	6105                	addi	sp,sp,32
    80004682:	8082                	ret
    panic("filedup");
    80004684:	00004517          	auipc	a0,0x4
    80004688:	00450513          	addi	a0,a0,4 # 80008688 <syscalls+0x250>
    8000468c:	ffffc097          	auipc	ra,0xffffc
    80004690:	ea4080e7          	jalr	-348(ra) # 80000530 <panic>

0000000080004694 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004694:	7139                	addi	sp,sp,-64
    80004696:	fc06                	sd	ra,56(sp)
    80004698:	f822                	sd	s0,48(sp)
    8000469a:	f426                	sd	s1,40(sp)
    8000469c:	f04a                	sd	s2,32(sp)
    8000469e:	ec4e                	sd	s3,24(sp)
    800046a0:	e852                	sd	s4,16(sp)
    800046a2:	e456                	sd	s5,8(sp)
    800046a4:	0080                	addi	s0,sp,64
    800046a6:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800046a8:	0002d517          	auipc	a0,0x2d
    800046ac:	cf850513          	addi	a0,a0,-776 # 800313a0 <ftable>
    800046b0:	ffffc097          	auipc	ra,0xffffc
    800046b4:	526080e7          	jalr	1318(ra) # 80000bd6 <acquire>
  if(f->ref < 1)
    800046b8:	40dc                	lw	a5,4(s1)
    800046ba:	06f05163          	blez	a5,8000471c <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    800046be:	37fd                	addiw	a5,a5,-1
    800046c0:	0007871b          	sext.w	a4,a5
    800046c4:	c0dc                	sw	a5,4(s1)
    800046c6:	06e04363          	bgtz	a4,8000472c <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800046ca:	0004a903          	lw	s2,0(s1)
    800046ce:	0094ca83          	lbu	s5,9(s1)
    800046d2:	0104ba03          	ld	s4,16(s1)
    800046d6:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    800046da:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800046de:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800046e2:	0002d517          	auipc	a0,0x2d
    800046e6:	cbe50513          	addi	a0,a0,-834 # 800313a0 <ftable>
    800046ea:	ffffc097          	auipc	ra,0xffffc
    800046ee:	5a0080e7          	jalr	1440(ra) # 80000c8a <release>

  if(ff.type == FD_PIPE){
    800046f2:	4785                	li	a5,1
    800046f4:	04f90d63          	beq	s2,a5,8000474e <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800046f8:	3979                	addiw	s2,s2,-2
    800046fa:	4785                	li	a5,1
    800046fc:	0527e063          	bltu	a5,s2,8000473c <fileclose+0xa8>
    begin_op();
    80004700:	00000097          	auipc	ra,0x0
    80004704:	ac0080e7          	jalr	-1344(ra) # 800041c0 <begin_op>
    iput(ff.ip);
    80004708:	854e                	mv	a0,s3
    8000470a:	fffff097          	auipc	ra,0xfffff
    8000470e:	29e080e7          	jalr	670(ra) # 800039a8 <iput>
    end_op();
    80004712:	00000097          	auipc	ra,0x0
    80004716:	b2e080e7          	jalr	-1234(ra) # 80004240 <end_op>
    8000471a:	a00d                	j	8000473c <fileclose+0xa8>
    panic("fileclose");
    8000471c:	00004517          	auipc	a0,0x4
    80004720:	f7450513          	addi	a0,a0,-140 # 80008690 <syscalls+0x258>
    80004724:	ffffc097          	auipc	ra,0xffffc
    80004728:	e0c080e7          	jalr	-500(ra) # 80000530 <panic>
    release(&ftable.lock);
    8000472c:	0002d517          	auipc	a0,0x2d
    80004730:	c7450513          	addi	a0,a0,-908 # 800313a0 <ftable>
    80004734:	ffffc097          	auipc	ra,0xffffc
    80004738:	556080e7          	jalr	1366(ra) # 80000c8a <release>
  }
}
    8000473c:	70e2                	ld	ra,56(sp)
    8000473e:	7442                	ld	s0,48(sp)
    80004740:	74a2                	ld	s1,40(sp)
    80004742:	7902                	ld	s2,32(sp)
    80004744:	69e2                	ld	s3,24(sp)
    80004746:	6a42                	ld	s4,16(sp)
    80004748:	6aa2                	ld	s5,8(sp)
    8000474a:	6121                	addi	sp,sp,64
    8000474c:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    8000474e:	85d6                	mv	a1,s5
    80004750:	8552                	mv	a0,s4
    80004752:	00000097          	auipc	ra,0x0
    80004756:	34c080e7          	jalr	844(ra) # 80004a9e <pipeclose>
    8000475a:	b7cd                	j	8000473c <fileclose+0xa8>

000000008000475c <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    8000475c:	715d                	addi	sp,sp,-80
    8000475e:	e486                	sd	ra,72(sp)
    80004760:	e0a2                	sd	s0,64(sp)
    80004762:	fc26                	sd	s1,56(sp)
    80004764:	f84a                	sd	s2,48(sp)
    80004766:	f44e                	sd	s3,40(sp)
    80004768:	0880                	addi	s0,sp,80
    8000476a:	84aa                	mv	s1,a0
    8000476c:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    8000476e:	ffffd097          	auipc	ra,0xffffd
    80004772:	238080e7          	jalr	568(ra) # 800019a6 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004776:	409c                	lw	a5,0(s1)
    80004778:	37f9                	addiw	a5,a5,-2
    8000477a:	4705                	li	a4,1
    8000477c:	04f76763          	bltu	a4,a5,800047ca <filestat+0x6e>
    80004780:	892a                	mv	s2,a0
    ilock(f->ip);
    80004782:	6c88                	ld	a0,24(s1)
    80004784:	fffff097          	auipc	ra,0xfffff
    80004788:	06a080e7          	jalr	106(ra) # 800037ee <ilock>
    stati(f->ip, &st);
    8000478c:	fb840593          	addi	a1,s0,-72
    80004790:	6c88                	ld	a0,24(s1)
    80004792:	fffff097          	auipc	ra,0xfffff
    80004796:	2e6080e7          	jalr	742(ra) # 80003a78 <stati>
    iunlock(f->ip);
    8000479a:	6c88                	ld	a0,24(s1)
    8000479c:	fffff097          	auipc	ra,0xfffff
    800047a0:	114080e7          	jalr	276(ra) # 800038b0 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800047a4:	46e1                	li	a3,24
    800047a6:	fb840613          	addi	a2,s0,-72
    800047aa:	85ce                	mv	a1,s3
    800047ac:	05093503          	ld	a0,80(s2)
    800047b0:	ffffd097          	auipc	ra,0xffffd
    800047b4:	e8c080e7          	jalr	-372(ra) # 8000163c <copyout>
    800047b8:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    800047bc:	60a6                	ld	ra,72(sp)
    800047be:	6406                	ld	s0,64(sp)
    800047c0:	74e2                	ld	s1,56(sp)
    800047c2:	7942                	ld	s2,48(sp)
    800047c4:	79a2                	ld	s3,40(sp)
    800047c6:	6161                	addi	sp,sp,80
    800047c8:	8082                	ret
  return -1;
    800047ca:	557d                	li	a0,-1
    800047cc:	bfc5                	j	800047bc <filestat+0x60>

00000000800047ce <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800047ce:	7179                	addi	sp,sp,-48
    800047d0:	f406                	sd	ra,40(sp)
    800047d2:	f022                	sd	s0,32(sp)
    800047d4:	ec26                	sd	s1,24(sp)
    800047d6:	e84a                	sd	s2,16(sp)
    800047d8:	e44e                	sd	s3,8(sp)
    800047da:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800047dc:	00854783          	lbu	a5,8(a0)
    800047e0:	c3d5                	beqz	a5,80004884 <fileread+0xb6>
    800047e2:	84aa                	mv	s1,a0
    800047e4:	89ae                	mv	s3,a1
    800047e6:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    800047e8:	411c                	lw	a5,0(a0)
    800047ea:	4705                	li	a4,1
    800047ec:	04e78963          	beq	a5,a4,8000483e <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800047f0:	470d                	li	a4,3
    800047f2:	04e78d63          	beq	a5,a4,8000484c <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    800047f6:	4709                	li	a4,2
    800047f8:	06e79e63          	bne	a5,a4,80004874 <fileread+0xa6>
    ilock(f->ip);
    800047fc:	6d08                	ld	a0,24(a0)
    800047fe:	fffff097          	auipc	ra,0xfffff
    80004802:	ff0080e7          	jalr	-16(ra) # 800037ee <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004806:	874a                	mv	a4,s2
    80004808:	5094                	lw	a3,32(s1)
    8000480a:	864e                	mv	a2,s3
    8000480c:	4585                	li	a1,1
    8000480e:	6c88                	ld	a0,24(s1)
    80004810:	fffff097          	auipc	ra,0xfffff
    80004814:	292080e7          	jalr	658(ra) # 80003aa2 <readi>
    80004818:	892a                	mv	s2,a0
    8000481a:	00a05563          	blez	a0,80004824 <fileread+0x56>
      f->off += r;
    8000481e:	509c                	lw	a5,32(s1)
    80004820:	9fa9                	addw	a5,a5,a0
    80004822:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004824:	6c88                	ld	a0,24(s1)
    80004826:	fffff097          	auipc	ra,0xfffff
    8000482a:	08a080e7          	jalr	138(ra) # 800038b0 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    8000482e:	854a                	mv	a0,s2
    80004830:	70a2                	ld	ra,40(sp)
    80004832:	7402                	ld	s0,32(sp)
    80004834:	64e2                	ld	s1,24(sp)
    80004836:	6942                	ld	s2,16(sp)
    80004838:	69a2                	ld	s3,8(sp)
    8000483a:	6145                	addi	sp,sp,48
    8000483c:	8082                	ret
    r = piperead(f->pipe, addr, n);
    8000483e:	6908                	ld	a0,16(a0)
    80004840:	00000097          	auipc	ra,0x0
    80004844:	3c8080e7          	jalr	968(ra) # 80004c08 <piperead>
    80004848:	892a                	mv	s2,a0
    8000484a:	b7d5                	j	8000482e <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    8000484c:	02451783          	lh	a5,36(a0)
    80004850:	03079693          	slli	a3,a5,0x30
    80004854:	92c1                	srli	a3,a3,0x30
    80004856:	4725                	li	a4,9
    80004858:	02d76863          	bltu	a4,a3,80004888 <fileread+0xba>
    8000485c:	0792                	slli	a5,a5,0x4
    8000485e:	0002d717          	auipc	a4,0x2d
    80004862:	aa270713          	addi	a4,a4,-1374 # 80031300 <devsw>
    80004866:	97ba                	add	a5,a5,a4
    80004868:	639c                	ld	a5,0(a5)
    8000486a:	c38d                	beqz	a5,8000488c <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    8000486c:	4505                	li	a0,1
    8000486e:	9782                	jalr	a5
    80004870:	892a                	mv	s2,a0
    80004872:	bf75                	j	8000482e <fileread+0x60>
    panic("fileread");
    80004874:	00004517          	auipc	a0,0x4
    80004878:	e2c50513          	addi	a0,a0,-468 # 800086a0 <syscalls+0x268>
    8000487c:	ffffc097          	auipc	ra,0xffffc
    80004880:	cb4080e7          	jalr	-844(ra) # 80000530 <panic>
    return -1;
    80004884:	597d                	li	s2,-1
    80004886:	b765                	j	8000482e <fileread+0x60>
      return -1;
    80004888:	597d                	li	s2,-1
    8000488a:	b755                	j	8000482e <fileread+0x60>
    8000488c:	597d                	li	s2,-1
    8000488e:	b745                	j	8000482e <fileread+0x60>

0000000080004890 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80004890:	715d                	addi	sp,sp,-80
    80004892:	e486                	sd	ra,72(sp)
    80004894:	e0a2                	sd	s0,64(sp)
    80004896:	fc26                	sd	s1,56(sp)
    80004898:	f84a                	sd	s2,48(sp)
    8000489a:	f44e                	sd	s3,40(sp)
    8000489c:	f052                	sd	s4,32(sp)
    8000489e:	ec56                	sd	s5,24(sp)
    800048a0:	e85a                	sd	s6,16(sp)
    800048a2:	e45e                	sd	s7,8(sp)
    800048a4:	e062                	sd	s8,0(sp)
    800048a6:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    800048a8:	00954783          	lbu	a5,9(a0)
    800048ac:	10078663          	beqz	a5,800049b8 <filewrite+0x128>
    800048b0:	892a                	mv	s2,a0
    800048b2:	8aae                	mv	s5,a1
    800048b4:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    800048b6:	411c                	lw	a5,0(a0)
    800048b8:	4705                	li	a4,1
    800048ba:	02e78263          	beq	a5,a4,800048de <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800048be:	470d                	li	a4,3
    800048c0:	02e78663          	beq	a5,a4,800048ec <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800048c4:	4709                	li	a4,2
    800048c6:	0ee79163          	bne	a5,a4,800049a8 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800048ca:	0ac05d63          	blez	a2,80004984 <filewrite+0xf4>
    int i = 0;
    800048ce:	4981                	li	s3,0
    800048d0:	6b05                	lui	s6,0x1
    800048d2:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    800048d6:	6b85                	lui	s7,0x1
    800048d8:	c00b8b9b          	addiw	s7,s7,-1024
    800048dc:	a861                	j	80004974 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    800048de:	6908                	ld	a0,16(a0)
    800048e0:	00000097          	auipc	ra,0x0
    800048e4:	22e080e7          	jalr	558(ra) # 80004b0e <pipewrite>
    800048e8:	8a2a                	mv	s4,a0
    800048ea:	a045                	j	8000498a <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800048ec:	02451783          	lh	a5,36(a0)
    800048f0:	03079693          	slli	a3,a5,0x30
    800048f4:	92c1                	srli	a3,a3,0x30
    800048f6:	4725                	li	a4,9
    800048f8:	0cd76263          	bltu	a4,a3,800049bc <filewrite+0x12c>
    800048fc:	0792                	slli	a5,a5,0x4
    800048fe:	0002d717          	auipc	a4,0x2d
    80004902:	a0270713          	addi	a4,a4,-1534 # 80031300 <devsw>
    80004906:	97ba                	add	a5,a5,a4
    80004908:	679c                	ld	a5,8(a5)
    8000490a:	cbdd                	beqz	a5,800049c0 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    8000490c:	4505                	li	a0,1
    8000490e:	9782                	jalr	a5
    80004910:	8a2a                	mv	s4,a0
    80004912:	a8a5                	j	8000498a <filewrite+0xfa>
    80004914:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80004918:	00000097          	auipc	ra,0x0
    8000491c:	8a8080e7          	jalr	-1880(ra) # 800041c0 <begin_op>
      ilock(f->ip);
    80004920:	01893503          	ld	a0,24(s2)
    80004924:	fffff097          	auipc	ra,0xfffff
    80004928:	eca080e7          	jalr	-310(ra) # 800037ee <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    8000492c:	8762                	mv	a4,s8
    8000492e:	02092683          	lw	a3,32(s2)
    80004932:	01598633          	add	a2,s3,s5
    80004936:	4585                	li	a1,1
    80004938:	01893503          	ld	a0,24(s2)
    8000493c:	fffff097          	auipc	ra,0xfffff
    80004940:	25e080e7          	jalr	606(ra) # 80003b9a <writei>
    80004944:	84aa                	mv	s1,a0
    80004946:	00a05763          	blez	a0,80004954 <filewrite+0xc4>
        f->off += r;
    8000494a:	02092783          	lw	a5,32(s2)
    8000494e:	9fa9                	addw	a5,a5,a0
    80004950:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004954:	01893503          	ld	a0,24(s2)
    80004958:	fffff097          	auipc	ra,0xfffff
    8000495c:	f58080e7          	jalr	-168(ra) # 800038b0 <iunlock>
      end_op();
    80004960:	00000097          	auipc	ra,0x0
    80004964:	8e0080e7          	jalr	-1824(ra) # 80004240 <end_op>

      if(r != n1){
    80004968:	009c1f63          	bne	s8,s1,80004986 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    8000496c:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004970:	0149db63          	bge	s3,s4,80004986 <filewrite+0xf6>
      int n1 = n - i;
    80004974:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80004978:	84be                	mv	s1,a5
    8000497a:	2781                	sext.w	a5,a5
    8000497c:	f8fb5ce3          	bge	s6,a5,80004914 <filewrite+0x84>
    80004980:	84de                	mv	s1,s7
    80004982:	bf49                	j	80004914 <filewrite+0x84>
    int i = 0;
    80004984:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80004986:	013a1f63          	bne	s4,s3,800049a4 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    8000498a:	8552                	mv	a0,s4
    8000498c:	60a6                	ld	ra,72(sp)
    8000498e:	6406                	ld	s0,64(sp)
    80004990:	74e2                	ld	s1,56(sp)
    80004992:	7942                	ld	s2,48(sp)
    80004994:	79a2                	ld	s3,40(sp)
    80004996:	7a02                	ld	s4,32(sp)
    80004998:	6ae2                	ld	s5,24(sp)
    8000499a:	6b42                	ld	s6,16(sp)
    8000499c:	6ba2                	ld	s7,8(sp)
    8000499e:	6c02                	ld	s8,0(sp)
    800049a0:	6161                	addi	sp,sp,80
    800049a2:	8082                	ret
    ret = (i == n ? n : -1);
    800049a4:	5a7d                	li	s4,-1
    800049a6:	b7d5                	j	8000498a <filewrite+0xfa>
    panic("filewrite");
    800049a8:	00004517          	auipc	a0,0x4
    800049ac:	d0850513          	addi	a0,a0,-760 # 800086b0 <syscalls+0x278>
    800049b0:	ffffc097          	auipc	ra,0xffffc
    800049b4:	b80080e7          	jalr	-1152(ra) # 80000530 <panic>
    return -1;
    800049b8:	5a7d                	li	s4,-1
    800049ba:	bfc1                	j	8000498a <filewrite+0xfa>
      return -1;
    800049bc:	5a7d                	li	s4,-1
    800049be:	b7f1                	j	8000498a <filewrite+0xfa>
    800049c0:	5a7d                	li	s4,-1
    800049c2:	b7e1                	j	8000498a <filewrite+0xfa>

00000000800049c4 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800049c4:	7179                	addi	sp,sp,-48
    800049c6:	f406                	sd	ra,40(sp)
    800049c8:	f022                	sd	s0,32(sp)
    800049ca:	ec26                	sd	s1,24(sp)
    800049cc:	e84a                	sd	s2,16(sp)
    800049ce:	e44e                	sd	s3,8(sp)
    800049d0:	e052                	sd	s4,0(sp)
    800049d2:	1800                	addi	s0,sp,48
    800049d4:	84aa                	mv	s1,a0
    800049d6:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800049d8:	0005b023          	sd	zero,0(a1)
    800049dc:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800049e0:	00000097          	auipc	ra,0x0
    800049e4:	bf8080e7          	jalr	-1032(ra) # 800045d8 <filealloc>
    800049e8:	e088                	sd	a0,0(s1)
    800049ea:	c551                	beqz	a0,80004a76 <pipealloc+0xb2>
    800049ec:	00000097          	auipc	ra,0x0
    800049f0:	bec080e7          	jalr	-1044(ra) # 800045d8 <filealloc>
    800049f4:	00aa3023          	sd	a0,0(s4)
    800049f8:	c92d                	beqz	a0,80004a6a <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800049fa:	ffffc097          	auipc	ra,0xffffc
    800049fe:	0ec080e7          	jalr	236(ra) # 80000ae6 <kalloc>
    80004a02:	892a                	mv	s2,a0
    80004a04:	c125                	beqz	a0,80004a64 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80004a06:	4985                	li	s3,1
    80004a08:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004a0c:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004a10:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004a14:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004a18:	00004597          	auipc	a1,0x4
    80004a1c:	ca858593          	addi	a1,a1,-856 # 800086c0 <syscalls+0x288>
    80004a20:	ffffc097          	auipc	ra,0xffffc
    80004a24:	126080e7          	jalr	294(ra) # 80000b46 <initlock>
  (*f0)->type = FD_PIPE;
    80004a28:	609c                	ld	a5,0(s1)
    80004a2a:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004a2e:	609c                	ld	a5,0(s1)
    80004a30:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004a34:	609c                	ld	a5,0(s1)
    80004a36:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004a3a:	609c                	ld	a5,0(s1)
    80004a3c:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004a40:	000a3783          	ld	a5,0(s4)
    80004a44:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004a48:	000a3783          	ld	a5,0(s4)
    80004a4c:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004a50:	000a3783          	ld	a5,0(s4)
    80004a54:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004a58:	000a3783          	ld	a5,0(s4)
    80004a5c:	0127b823          	sd	s2,16(a5)
  return 0;
    80004a60:	4501                	li	a0,0
    80004a62:	a025                	j	80004a8a <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004a64:	6088                	ld	a0,0(s1)
    80004a66:	e501                	bnez	a0,80004a6e <pipealloc+0xaa>
    80004a68:	a039                	j	80004a76 <pipealloc+0xb2>
    80004a6a:	6088                	ld	a0,0(s1)
    80004a6c:	c51d                	beqz	a0,80004a9a <pipealloc+0xd6>
    fileclose(*f0);
    80004a6e:	00000097          	auipc	ra,0x0
    80004a72:	c26080e7          	jalr	-986(ra) # 80004694 <fileclose>
  if(*f1)
    80004a76:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004a7a:	557d                	li	a0,-1
  if(*f1)
    80004a7c:	c799                	beqz	a5,80004a8a <pipealloc+0xc6>
    fileclose(*f1);
    80004a7e:	853e                	mv	a0,a5
    80004a80:	00000097          	auipc	ra,0x0
    80004a84:	c14080e7          	jalr	-1004(ra) # 80004694 <fileclose>
  return -1;
    80004a88:	557d                	li	a0,-1
}
    80004a8a:	70a2                	ld	ra,40(sp)
    80004a8c:	7402                	ld	s0,32(sp)
    80004a8e:	64e2                	ld	s1,24(sp)
    80004a90:	6942                	ld	s2,16(sp)
    80004a92:	69a2                	ld	s3,8(sp)
    80004a94:	6a02                	ld	s4,0(sp)
    80004a96:	6145                	addi	sp,sp,48
    80004a98:	8082                	ret
  return -1;
    80004a9a:	557d                	li	a0,-1
    80004a9c:	b7fd                	j	80004a8a <pipealloc+0xc6>

0000000080004a9e <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004a9e:	1101                	addi	sp,sp,-32
    80004aa0:	ec06                	sd	ra,24(sp)
    80004aa2:	e822                	sd	s0,16(sp)
    80004aa4:	e426                	sd	s1,8(sp)
    80004aa6:	e04a                	sd	s2,0(sp)
    80004aa8:	1000                	addi	s0,sp,32
    80004aaa:	84aa                	mv	s1,a0
    80004aac:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004aae:	ffffc097          	auipc	ra,0xffffc
    80004ab2:	128080e7          	jalr	296(ra) # 80000bd6 <acquire>
  if(writable){
    80004ab6:	02090d63          	beqz	s2,80004af0 <pipeclose+0x52>
    pi->writeopen = 0;
    80004aba:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004abe:	21848513          	addi	a0,s1,536
    80004ac2:	ffffe097          	auipc	ra,0xffffe
    80004ac6:	932080e7          	jalr	-1742(ra) # 800023f4 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004aca:	2204b783          	ld	a5,544(s1)
    80004ace:	eb95                	bnez	a5,80004b02 <pipeclose+0x64>
    release(&pi->lock);
    80004ad0:	8526                	mv	a0,s1
    80004ad2:	ffffc097          	auipc	ra,0xffffc
    80004ad6:	1b8080e7          	jalr	440(ra) # 80000c8a <release>
    kfree((char*)pi);
    80004ada:	8526                	mv	a0,s1
    80004adc:	ffffc097          	auipc	ra,0xffffc
    80004ae0:	f0e080e7          	jalr	-242(ra) # 800009ea <kfree>
  } else
    release(&pi->lock);
}
    80004ae4:	60e2                	ld	ra,24(sp)
    80004ae6:	6442                	ld	s0,16(sp)
    80004ae8:	64a2                	ld	s1,8(sp)
    80004aea:	6902                	ld	s2,0(sp)
    80004aec:	6105                	addi	sp,sp,32
    80004aee:	8082                	ret
    pi->readopen = 0;
    80004af0:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004af4:	21c48513          	addi	a0,s1,540
    80004af8:	ffffe097          	auipc	ra,0xffffe
    80004afc:	8fc080e7          	jalr	-1796(ra) # 800023f4 <wakeup>
    80004b00:	b7e9                	j	80004aca <pipeclose+0x2c>
    release(&pi->lock);
    80004b02:	8526                	mv	a0,s1
    80004b04:	ffffc097          	auipc	ra,0xffffc
    80004b08:	186080e7          	jalr	390(ra) # 80000c8a <release>
}
    80004b0c:	bfe1                	j	80004ae4 <pipeclose+0x46>

0000000080004b0e <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004b0e:	7159                	addi	sp,sp,-112
    80004b10:	f486                	sd	ra,104(sp)
    80004b12:	f0a2                	sd	s0,96(sp)
    80004b14:	eca6                	sd	s1,88(sp)
    80004b16:	e8ca                	sd	s2,80(sp)
    80004b18:	e4ce                	sd	s3,72(sp)
    80004b1a:	e0d2                	sd	s4,64(sp)
    80004b1c:	fc56                	sd	s5,56(sp)
    80004b1e:	f85a                	sd	s6,48(sp)
    80004b20:	f45e                	sd	s7,40(sp)
    80004b22:	f062                	sd	s8,32(sp)
    80004b24:	ec66                	sd	s9,24(sp)
    80004b26:	1880                	addi	s0,sp,112
    80004b28:	84aa                	mv	s1,a0
    80004b2a:	8aae                	mv	s5,a1
    80004b2c:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004b2e:	ffffd097          	auipc	ra,0xffffd
    80004b32:	e78080e7          	jalr	-392(ra) # 800019a6 <myproc>
    80004b36:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004b38:	8526                	mv	a0,s1
    80004b3a:	ffffc097          	auipc	ra,0xffffc
    80004b3e:	09c080e7          	jalr	156(ra) # 80000bd6 <acquire>
  while(i < n){
    80004b42:	0d405163          	blez	s4,80004c04 <pipewrite+0xf6>
    80004b46:	8ba6                	mv	s7,s1
  int i = 0;
    80004b48:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004b4a:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004b4c:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004b50:	21c48c13          	addi	s8,s1,540
    80004b54:	a08d                	j	80004bb6 <pipewrite+0xa8>
      release(&pi->lock);
    80004b56:	8526                	mv	a0,s1
    80004b58:	ffffc097          	auipc	ra,0xffffc
    80004b5c:	132080e7          	jalr	306(ra) # 80000c8a <release>
      return -1;
    80004b60:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004b62:	854a                	mv	a0,s2
    80004b64:	70a6                	ld	ra,104(sp)
    80004b66:	7406                	ld	s0,96(sp)
    80004b68:	64e6                	ld	s1,88(sp)
    80004b6a:	6946                	ld	s2,80(sp)
    80004b6c:	69a6                	ld	s3,72(sp)
    80004b6e:	6a06                	ld	s4,64(sp)
    80004b70:	7ae2                	ld	s5,56(sp)
    80004b72:	7b42                	ld	s6,48(sp)
    80004b74:	7ba2                	ld	s7,40(sp)
    80004b76:	7c02                	ld	s8,32(sp)
    80004b78:	6ce2                	ld	s9,24(sp)
    80004b7a:	6165                	addi	sp,sp,112
    80004b7c:	8082                	ret
      wakeup(&pi->nread);
    80004b7e:	8566                	mv	a0,s9
    80004b80:	ffffe097          	auipc	ra,0xffffe
    80004b84:	874080e7          	jalr	-1932(ra) # 800023f4 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004b88:	85de                	mv	a1,s7
    80004b8a:	8562                	mv	a0,s8
    80004b8c:	ffffd097          	auipc	ra,0xffffd
    80004b90:	6e2080e7          	jalr	1762(ra) # 8000226e <sleep>
    80004b94:	a839                	j	80004bb2 <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004b96:	21c4a783          	lw	a5,540(s1)
    80004b9a:	0017871b          	addiw	a4,a5,1
    80004b9e:	20e4ae23          	sw	a4,540(s1)
    80004ba2:	1ff7f793          	andi	a5,a5,511
    80004ba6:	97a6                	add	a5,a5,s1
    80004ba8:	f9f44703          	lbu	a4,-97(s0)
    80004bac:	00e78c23          	sb	a4,24(a5)
      i++;
    80004bb0:	2905                	addiw	s2,s2,1
  while(i < n){
    80004bb2:	03495d63          	bge	s2,s4,80004bec <pipewrite+0xde>
    if(pi->readopen == 0 || pr->killed){
    80004bb6:	2204a783          	lw	a5,544(s1)
    80004bba:	dfd1                	beqz	a5,80004b56 <pipewrite+0x48>
    80004bbc:	0309a783          	lw	a5,48(s3)
    80004bc0:	fbd9                	bnez	a5,80004b56 <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004bc2:	2184a783          	lw	a5,536(s1)
    80004bc6:	21c4a703          	lw	a4,540(s1)
    80004bca:	2007879b          	addiw	a5,a5,512
    80004bce:	faf708e3          	beq	a4,a5,80004b7e <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004bd2:	4685                	li	a3,1
    80004bd4:	01590633          	add	a2,s2,s5
    80004bd8:	f9f40593          	addi	a1,s0,-97
    80004bdc:	0509b503          	ld	a0,80(s3)
    80004be0:	ffffd097          	auipc	ra,0xffffd
    80004be4:	ae8080e7          	jalr	-1304(ra) # 800016c8 <copyin>
    80004be8:	fb6517e3          	bne	a0,s6,80004b96 <pipewrite+0x88>
  wakeup(&pi->nread);
    80004bec:	21848513          	addi	a0,s1,536
    80004bf0:	ffffe097          	auipc	ra,0xffffe
    80004bf4:	804080e7          	jalr	-2044(ra) # 800023f4 <wakeup>
  release(&pi->lock);
    80004bf8:	8526                	mv	a0,s1
    80004bfa:	ffffc097          	auipc	ra,0xffffc
    80004bfe:	090080e7          	jalr	144(ra) # 80000c8a <release>
  return i;
    80004c02:	b785                	j	80004b62 <pipewrite+0x54>
  int i = 0;
    80004c04:	4901                	li	s2,0
    80004c06:	b7dd                	j	80004bec <pipewrite+0xde>

0000000080004c08 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004c08:	715d                	addi	sp,sp,-80
    80004c0a:	e486                	sd	ra,72(sp)
    80004c0c:	e0a2                	sd	s0,64(sp)
    80004c0e:	fc26                	sd	s1,56(sp)
    80004c10:	f84a                	sd	s2,48(sp)
    80004c12:	f44e                	sd	s3,40(sp)
    80004c14:	f052                	sd	s4,32(sp)
    80004c16:	ec56                	sd	s5,24(sp)
    80004c18:	e85a                	sd	s6,16(sp)
    80004c1a:	0880                	addi	s0,sp,80
    80004c1c:	84aa                	mv	s1,a0
    80004c1e:	892e                	mv	s2,a1
    80004c20:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004c22:	ffffd097          	auipc	ra,0xffffd
    80004c26:	d84080e7          	jalr	-636(ra) # 800019a6 <myproc>
    80004c2a:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004c2c:	8b26                	mv	s6,s1
    80004c2e:	8526                	mv	a0,s1
    80004c30:	ffffc097          	auipc	ra,0xffffc
    80004c34:	fa6080e7          	jalr	-90(ra) # 80000bd6 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004c38:	2184a703          	lw	a4,536(s1)
    80004c3c:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004c40:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004c44:	02f71463          	bne	a4,a5,80004c6c <piperead+0x64>
    80004c48:	2244a783          	lw	a5,548(s1)
    80004c4c:	c385                	beqz	a5,80004c6c <piperead+0x64>
    if(pr->killed){
    80004c4e:	030a2783          	lw	a5,48(s4)
    80004c52:	ebc1                	bnez	a5,80004ce2 <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004c54:	85da                	mv	a1,s6
    80004c56:	854e                	mv	a0,s3
    80004c58:	ffffd097          	auipc	ra,0xffffd
    80004c5c:	616080e7          	jalr	1558(ra) # 8000226e <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004c60:	2184a703          	lw	a4,536(s1)
    80004c64:	21c4a783          	lw	a5,540(s1)
    80004c68:	fef700e3          	beq	a4,a5,80004c48 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004c6c:	09505263          	blez	s5,80004cf0 <piperead+0xe8>
    80004c70:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004c72:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    80004c74:	2184a783          	lw	a5,536(s1)
    80004c78:	21c4a703          	lw	a4,540(s1)
    80004c7c:	02f70d63          	beq	a4,a5,80004cb6 <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004c80:	0017871b          	addiw	a4,a5,1
    80004c84:	20e4ac23          	sw	a4,536(s1)
    80004c88:	1ff7f793          	andi	a5,a5,511
    80004c8c:	97a6                	add	a5,a5,s1
    80004c8e:	0187c783          	lbu	a5,24(a5)
    80004c92:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004c96:	4685                	li	a3,1
    80004c98:	fbf40613          	addi	a2,s0,-65
    80004c9c:	85ca                	mv	a1,s2
    80004c9e:	050a3503          	ld	a0,80(s4)
    80004ca2:	ffffd097          	auipc	ra,0xffffd
    80004ca6:	99a080e7          	jalr	-1638(ra) # 8000163c <copyout>
    80004caa:	01650663          	beq	a0,s6,80004cb6 <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004cae:	2985                	addiw	s3,s3,1
    80004cb0:	0905                	addi	s2,s2,1
    80004cb2:	fd3a91e3          	bne	s5,s3,80004c74 <piperead+0x6c>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004cb6:	21c48513          	addi	a0,s1,540
    80004cba:	ffffd097          	auipc	ra,0xffffd
    80004cbe:	73a080e7          	jalr	1850(ra) # 800023f4 <wakeup>
  release(&pi->lock);
    80004cc2:	8526                	mv	a0,s1
    80004cc4:	ffffc097          	auipc	ra,0xffffc
    80004cc8:	fc6080e7          	jalr	-58(ra) # 80000c8a <release>
  return i;
}
    80004ccc:	854e                	mv	a0,s3
    80004cce:	60a6                	ld	ra,72(sp)
    80004cd0:	6406                	ld	s0,64(sp)
    80004cd2:	74e2                	ld	s1,56(sp)
    80004cd4:	7942                	ld	s2,48(sp)
    80004cd6:	79a2                	ld	s3,40(sp)
    80004cd8:	7a02                	ld	s4,32(sp)
    80004cda:	6ae2                	ld	s5,24(sp)
    80004cdc:	6b42                	ld	s6,16(sp)
    80004cde:	6161                	addi	sp,sp,80
    80004ce0:	8082                	ret
      release(&pi->lock);
    80004ce2:	8526                	mv	a0,s1
    80004ce4:	ffffc097          	auipc	ra,0xffffc
    80004ce8:	fa6080e7          	jalr	-90(ra) # 80000c8a <release>
      return -1;
    80004cec:	59fd                	li	s3,-1
    80004cee:	bff9                	j	80004ccc <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004cf0:	4981                	li	s3,0
    80004cf2:	b7d1                	j	80004cb6 <piperead+0xae>

0000000080004cf4 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80004cf4:	df010113          	addi	sp,sp,-528
    80004cf8:	20113423          	sd	ra,520(sp)
    80004cfc:	20813023          	sd	s0,512(sp)
    80004d00:	ffa6                	sd	s1,504(sp)
    80004d02:	fbca                	sd	s2,496(sp)
    80004d04:	f7ce                	sd	s3,488(sp)
    80004d06:	f3d2                	sd	s4,480(sp)
    80004d08:	efd6                	sd	s5,472(sp)
    80004d0a:	ebda                	sd	s6,464(sp)
    80004d0c:	e7de                	sd	s7,456(sp)
    80004d0e:	e3e2                	sd	s8,448(sp)
    80004d10:	ff66                	sd	s9,440(sp)
    80004d12:	fb6a                	sd	s10,432(sp)
    80004d14:	f76e                	sd	s11,424(sp)
    80004d16:	0c00                	addi	s0,sp,528
    80004d18:	84aa                	mv	s1,a0
    80004d1a:	dea43c23          	sd	a0,-520(s0)
    80004d1e:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004d22:	ffffd097          	auipc	ra,0xffffd
    80004d26:	c84080e7          	jalr	-892(ra) # 800019a6 <myproc>
    80004d2a:	892a                	mv	s2,a0

  begin_op();
    80004d2c:	fffff097          	auipc	ra,0xfffff
    80004d30:	494080e7          	jalr	1172(ra) # 800041c0 <begin_op>

  if((ip = namei(path)) == 0){
    80004d34:	8526                	mv	a0,s1
    80004d36:	fffff097          	auipc	ra,0xfffff
    80004d3a:	26e080e7          	jalr	622(ra) # 80003fa4 <namei>
    80004d3e:	c92d                	beqz	a0,80004db0 <exec+0xbc>
    80004d40:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004d42:	fffff097          	auipc	ra,0xfffff
    80004d46:	aac080e7          	jalr	-1364(ra) # 800037ee <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004d4a:	04000713          	li	a4,64
    80004d4e:	4681                	li	a3,0
    80004d50:	e4840613          	addi	a2,s0,-440
    80004d54:	4581                	li	a1,0
    80004d56:	8526                	mv	a0,s1
    80004d58:	fffff097          	auipc	ra,0xfffff
    80004d5c:	d4a080e7          	jalr	-694(ra) # 80003aa2 <readi>
    80004d60:	04000793          	li	a5,64
    80004d64:	00f51a63          	bne	a0,a5,80004d78 <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004d68:	e4842703          	lw	a4,-440(s0)
    80004d6c:	464c47b7          	lui	a5,0x464c4
    80004d70:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004d74:	04f70463          	beq	a4,a5,80004dbc <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004d78:	8526                	mv	a0,s1
    80004d7a:	fffff097          	auipc	ra,0xfffff
    80004d7e:	cd6080e7          	jalr	-810(ra) # 80003a50 <iunlockput>
    end_op();
    80004d82:	fffff097          	auipc	ra,0xfffff
    80004d86:	4be080e7          	jalr	1214(ra) # 80004240 <end_op>
  }
  return -1;
    80004d8a:	557d                	li	a0,-1
}
    80004d8c:	20813083          	ld	ra,520(sp)
    80004d90:	20013403          	ld	s0,512(sp)
    80004d94:	74fe                	ld	s1,504(sp)
    80004d96:	795e                	ld	s2,496(sp)
    80004d98:	79be                	ld	s3,488(sp)
    80004d9a:	7a1e                	ld	s4,480(sp)
    80004d9c:	6afe                	ld	s5,472(sp)
    80004d9e:	6b5e                	ld	s6,464(sp)
    80004da0:	6bbe                	ld	s7,456(sp)
    80004da2:	6c1e                	ld	s8,448(sp)
    80004da4:	7cfa                	ld	s9,440(sp)
    80004da6:	7d5a                	ld	s10,432(sp)
    80004da8:	7dba                	ld	s11,424(sp)
    80004daa:	21010113          	addi	sp,sp,528
    80004dae:	8082                	ret
    end_op();
    80004db0:	fffff097          	auipc	ra,0xfffff
    80004db4:	490080e7          	jalr	1168(ra) # 80004240 <end_op>
    return -1;
    80004db8:	557d                	li	a0,-1
    80004dba:	bfc9                	j	80004d8c <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    80004dbc:	854a                	mv	a0,s2
    80004dbe:	ffffd097          	auipc	ra,0xffffd
    80004dc2:	cac080e7          	jalr	-852(ra) # 80001a6a <proc_pagetable>
    80004dc6:	8baa                	mv	s7,a0
    80004dc8:	d945                	beqz	a0,80004d78 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004dca:	e6842983          	lw	s3,-408(s0)
    80004dce:	e8045783          	lhu	a5,-384(s0)
    80004dd2:	c7ad                	beqz	a5,80004e3c <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
    80004dd4:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004dd6:	4b01                	li	s6,0
    if(ph.vaddr % PGSIZE != 0)
    80004dd8:	6c85                	lui	s9,0x1
    80004dda:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004dde:	def43823          	sd	a5,-528(s0)
    80004de2:	a42d                	j	8000500c <exec+0x318>
    panic("loadseg: va must be page aligned");

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004de4:	00004517          	auipc	a0,0x4
    80004de8:	8e450513          	addi	a0,a0,-1820 # 800086c8 <syscalls+0x290>
    80004dec:	ffffb097          	auipc	ra,0xffffb
    80004df0:	744080e7          	jalr	1860(ra) # 80000530 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004df4:	8756                	mv	a4,s5
    80004df6:	012d86bb          	addw	a3,s11,s2
    80004dfa:	4581                	li	a1,0
    80004dfc:	8526                	mv	a0,s1
    80004dfe:	fffff097          	auipc	ra,0xfffff
    80004e02:	ca4080e7          	jalr	-860(ra) # 80003aa2 <readi>
    80004e06:	2501                	sext.w	a0,a0
    80004e08:	1aaa9963          	bne	s5,a0,80004fba <exec+0x2c6>
  for(i = 0; i < sz; i += PGSIZE){
    80004e0c:	6785                	lui	a5,0x1
    80004e0e:	0127893b          	addw	s2,a5,s2
    80004e12:	77fd                	lui	a5,0xfffff
    80004e14:	01478a3b          	addw	s4,a5,s4
    80004e18:	1f897163          	bgeu	s2,s8,80004ffa <exec+0x306>
    pa = walkaddr(pagetable, va + i);
    80004e1c:	02091593          	slli	a1,s2,0x20
    80004e20:	9181                	srli	a1,a1,0x20
    80004e22:	95ea                	add	a1,a1,s10
    80004e24:	855e                	mv	a0,s7
    80004e26:	ffffc097          	auipc	ra,0xffffc
    80004e2a:	23e080e7          	jalr	574(ra) # 80001064 <walkaddr>
    80004e2e:	862a                	mv	a2,a0
    if(pa == 0)
    80004e30:	d955                	beqz	a0,80004de4 <exec+0xf0>
      n = PGSIZE;
    80004e32:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    80004e34:	fd9a70e3          	bgeu	s4,s9,80004df4 <exec+0x100>
      n = sz - i;
    80004e38:	8ad2                	mv	s5,s4
    80004e3a:	bf6d                	j	80004df4 <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
    80004e3c:	4901                	li	s2,0
  iunlockput(ip);
    80004e3e:	8526                	mv	a0,s1
    80004e40:	fffff097          	auipc	ra,0xfffff
    80004e44:	c10080e7          	jalr	-1008(ra) # 80003a50 <iunlockput>
  end_op();
    80004e48:	fffff097          	auipc	ra,0xfffff
    80004e4c:	3f8080e7          	jalr	1016(ra) # 80004240 <end_op>
  p = myproc();
    80004e50:	ffffd097          	auipc	ra,0xffffd
    80004e54:	b56080e7          	jalr	-1194(ra) # 800019a6 <myproc>
    80004e58:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004e5a:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004e5e:	6785                	lui	a5,0x1
    80004e60:	17fd                	addi	a5,a5,-1
    80004e62:	993e                	add	s2,s2,a5
    80004e64:	757d                	lui	a0,0xfffff
    80004e66:	00a977b3          	and	a5,s2,a0
    80004e6a:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004e6e:	6609                	lui	a2,0x2
    80004e70:	963e                	add	a2,a2,a5
    80004e72:	85be                	mv	a1,a5
    80004e74:	855e                	mv	a0,s7
    80004e76:	ffffc097          	auipc	ra,0xffffc
    80004e7a:	582080e7          	jalr	1410(ra) # 800013f8 <uvmalloc>
    80004e7e:	8b2a                	mv	s6,a0
  ip = 0;
    80004e80:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004e82:	12050c63          	beqz	a0,80004fba <exec+0x2c6>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004e86:	75f9                	lui	a1,0xffffe
    80004e88:	95aa                	add	a1,a1,a0
    80004e8a:	855e                	mv	a0,s7
    80004e8c:	ffffc097          	auipc	ra,0xffffc
    80004e90:	77e080e7          	jalr	1918(ra) # 8000160a <uvmclear>
  stackbase = sp - PGSIZE;
    80004e94:	7c7d                	lui	s8,0xfffff
    80004e96:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    80004e98:	e0043783          	ld	a5,-512(s0)
    80004e9c:	6388                	ld	a0,0(a5)
    80004e9e:	c535                	beqz	a0,80004f0a <exec+0x216>
    80004ea0:	e8840993          	addi	s3,s0,-376
    80004ea4:	f8840c93          	addi	s9,s0,-120
  sp = sz;
    80004ea8:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    80004eaa:	ffffc097          	auipc	ra,0xffffc
    80004eae:	fb0080e7          	jalr	-80(ra) # 80000e5a <strlen>
    80004eb2:	2505                	addiw	a0,a0,1
    80004eb4:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004eb8:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80004ebc:	13896363          	bltu	s2,s8,80004fe2 <exec+0x2ee>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004ec0:	e0043d83          	ld	s11,-512(s0)
    80004ec4:	000dba03          	ld	s4,0(s11)
    80004ec8:	8552                	mv	a0,s4
    80004eca:	ffffc097          	auipc	ra,0xffffc
    80004ece:	f90080e7          	jalr	-112(ra) # 80000e5a <strlen>
    80004ed2:	0015069b          	addiw	a3,a0,1
    80004ed6:	8652                	mv	a2,s4
    80004ed8:	85ca                	mv	a1,s2
    80004eda:	855e                	mv	a0,s7
    80004edc:	ffffc097          	auipc	ra,0xffffc
    80004ee0:	760080e7          	jalr	1888(ra) # 8000163c <copyout>
    80004ee4:	10054363          	bltz	a0,80004fea <exec+0x2f6>
    ustack[argc] = sp;
    80004ee8:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004eec:	0485                	addi	s1,s1,1
    80004eee:	008d8793          	addi	a5,s11,8
    80004ef2:	e0f43023          	sd	a5,-512(s0)
    80004ef6:	008db503          	ld	a0,8(s11)
    80004efa:	c911                	beqz	a0,80004f0e <exec+0x21a>
    if(argc >= MAXARG)
    80004efc:	09a1                	addi	s3,s3,8
    80004efe:	fb3c96e3          	bne	s9,s3,80004eaa <exec+0x1b6>
  sz = sz1;
    80004f02:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004f06:	4481                	li	s1,0
    80004f08:	a84d                	j	80004fba <exec+0x2c6>
  sp = sz;
    80004f0a:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    80004f0c:	4481                	li	s1,0
  ustack[argc] = 0;
    80004f0e:	00349793          	slli	a5,s1,0x3
    80004f12:	f9040713          	addi	a4,s0,-112
    80004f16:	97ba                	add	a5,a5,a4
    80004f18:	ee07bc23          	sd	zero,-264(a5) # ef8 <_entry-0x7ffff108>
  sp -= (argc+1) * sizeof(uint64);
    80004f1c:	00148693          	addi	a3,s1,1
    80004f20:	068e                	slli	a3,a3,0x3
    80004f22:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004f26:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004f2a:	01897663          	bgeu	s2,s8,80004f36 <exec+0x242>
  sz = sz1;
    80004f2e:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004f32:	4481                	li	s1,0
    80004f34:	a059                	j	80004fba <exec+0x2c6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004f36:	e8840613          	addi	a2,s0,-376
    80004f3a:	85ca                	mv	a1,s2
    80004f3c:	855e                	mv	a0,s7
    80004f3e:	ffffc097          	auipc	ra,0xffffc
    80004f42:	6fe080e7          	jalr	1790(ra) # 8000163c <copyout>
    80004f46:	0a054663          	bltz	a0,80004ff2 <exec+0x2fe>
  p->trapframe->a1 = sp;
    80004f4a:	058ab783          	ld	a5,88(s5)
    80004f4e:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004f52:	df843783          	ld	a5,-520(s0)
    80004f56:	0007c703          	lbu	a4,0(a5)
    80004f5a:	cf11                	beqz	a4,80004f76 <exec+0x282>
    80004f5c:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004f5e:	02f00693          	li	a3,47
    80004f62:	a029                	j	80004f6c <exec+0x278>
  for(last=s=path; *s; s++)
    80004f64:	0785                	addi	a5,a5,1
    80004f66:	fff7c703          	lbu	a4,-1(a5)
    80004f6a:	c711                	beqz	a4,80004f76 <exec+0x282>
    if(*s == '/')
    80004f6c:	fed71ce3          	bne	a4,a3,80004f64 <exec+0x270>
      last = s+1;
    80004f70:	def43c23          	sd	a5,-520(s0)
    80004f74:	bfc5                	j	80004f64 <exec+0x270>
  safestrcpy(p->name, last, sizeof(p->name));
    80004f76:	4641                	li	a2,16
    80004f78:	df843583          	ld	a1,-520(s0)
    80004f7c:	158a8513          	addi	a0,s5,344
    80004f80:	ffffc097          	auipc	ra,0xffffc
    80004f84:	ea8080e7          	jalr	-344(ra) # 80000e28 <safestrcpy>
  oldpagetable = p->pagetable;
    80004f88:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004f8c:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    80004f90:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004f94:	058ab783          	ld	a5,88(s5)
    80004f98:	e6043703          	ld	a4,-416(s0)
    80004f9c:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004f9e:	058ab783          	ld	a5,88(s5)
    80004fa2:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004fa6:	85ea                	mv	a1,s10
    80004fa8:	ffffd097          	auipc	ra,0xffffd
    80004fac:	b5e080e7          	jalr	-1186(ra) # 80001b06 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004fb0:	0004851b          	sext.w	a0,s1
    80004fb4:	bbe1                	j	80004d8c <exec+0x98>
    80004fb6:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    80004fba:	e0843583          	ld	a1,-504(s0)
    80004fbe:	855e                	mv	a0,s7
    80004fc0:	ffffd097          	auipc	ra,0xffffd
    80004fc4:	b46080e7          	jalr	-1210(ra) # 80001b06 <proc_freepagetable>
  if(ip){
    80004fc8:	da0498e3          	bnez	s1,80004d78 <exec+0x84>
  return -1;
    80004fcc:	557d                	li	a0,-1
    80004fce:	bb7d                	j	80004d8c <exec+0x98>
    80004fd0:	e1243423          	sd	s2,-504(s0)
    80004fd4:	b7dd                	j	80004fba <exec+0x2c6>
    80004fd6:	e1243423          	sd	s2,-504(s0)
    80004fda:	b7c5                	j	80004fba <exec+0x2c6>
    80004fdc:	e1243423          	sd	s2,-504(s0)
    80004fe0:	bfe9                	j	80004fba <exec+0x2c6>
  sz = sz1;
    80004fe2:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004fe6:	4481                	li	s1,0
    80004fe8:	bfc9                	j	80004fba <exec+0x2c6>
  sz = sz1;
    80004fea:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004fee:	4481                	li	s1,0
    80004ff0:	b7e9                	j	80004fba <exec+0x2c6>
  sz = sz1;
    80004ff2:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004ff6:	4481                	li	s1,0
    80004ff8:	b7c9                	j	80004fba <exec+0x2c6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004ffa:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004ffe:	2b05                	addiw	s6,s6,1
    80005000:	0389899b          	addiw	s3,s3,56
    80005004:	e8045783          	lhu	a5,-384(s0)
    80005008:	e2fb5be3          	bge	s6,a5,80004e3e <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000500c:	2981                	sext.w	s3,s3
    8000500e:	03800713          	li	a4,56
    80005012:	86ce                	mv	a3,s3
    80005014:	e1040613          	addi	a2,s0,-496
    80005018:	4581                	li	a1,0
    8000501a:	8526                	mv	a0,s1
    8000501c:	fffff097          	auipc	ra,0xfffff
    80005020:	a86080e7          	jalr	-1402(ra) # 80003aa2 <readi>
    80005024:	03800793          	li	a5,56
    80005028:	f8f517e3          	bne	a0,a5,80004fb6 <exec+0x2c2>
    if(ph.type != ELF_PROG_LOAD)
    8000502c:	e1042783          	lw	a5,-496(s0)
    80005030:	4705                	li	a4,1
    80005032:	fce796e3          	bne	a5,a4,80004ffe <exec+0x30a>
    if(ph.memsz < ph.filesz)
    80005036:	e3843603          	ld	a2,-456(s0)
    8000503a:	e3043783          	ld	a5,-464(s0)
    8000503e:	f8f669e3          	bltu	a2,a5,80004fd0 <exec+0x2dc>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80005042:	e2043783          	ld	a5,-480(s0)
    80005046:	963e                	add	a2,a2,a5
    80005048:	f8f667e3          	bltu	a2,a5,80004fd6 <exec+0x2e2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000504c:	85ca                	mv	a1,s2
    8000504e:	855e                	mv	a0,s7
    80005050:	ffffc097          	auipc	ra,0xffffc
    80005054:	3a8080e7          	jalr	936(ra) # 800013f8 <uvmalloc>
    80005058:	e0a43423          	sd	a0,-504(s0)
    8000505c:	d141                	beqz	a0,80004fdc <exec+0x2e8>
    if(ph.vaddr % PGSIZE != 0)
    8000505e:	e2043d03          	ld	s10,-480(s0)
    80005062:	df043783          	ld	a5,-528(s0)
    80005066:	00fd77b3          	and	a5,s10,a5
    8000506a:	fba1                	bnez	a5,80004fba <exec+0x2c6>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000506c:	e1842d83          	lw	s11,-488(s0)
    80005070:	e3042c03          	lw	s8,-464(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80005074:	f80c03e3          	beqz	s8,80004ffa <exec+0x306>
    80005078:	8a62                	mv	s4,s8
    8000507a:	4901                	li	s2,0
    8000507c:	b345                	j	80004e1c <exec+0x128>

000000008000507e <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000507e:	7179                	addi	sp,sp,-48
    80005080:	f406                	sd	ra,40(sp)
    80005082:	f022                	sd	s0,32(sp)
    80005084:	ec26                	sd	s1,24(sp)
    80005086:	e84a                	sd	s2,16(sp)
    80005088:	1800                	addi	s0,sp,48
    8000508a:	892e                	mv	s2,a1
    8000508c:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    8000508e:	fdc40593          	addi	a1,s0,-36
    80005092:	ffffe097          	auipc	ra,0xffffe
    80005096:	bea080e7          	jalr	-1046(ra) # 80002c7c <argint>
    8000509a:	04054063          	bltz	a0,800050da <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000509e:	fdc42703          	lw	a4,-36(s0)
    800050a2:	47bd                	li	a5,15
    800050a4:	02e7ed63          	bltu	a5,a4,800050de <argfd+0x60>
    800050a8:	ffffd097          	auipc	ra,0xffffd
    800050ac:	8fe080e7          	jalr	-1794(ra) # 800019a6 <myproc>
    800050b0:	fdc42703          	lw	a4,-36(s0)
    800050b4:	01a70793          	addi	a5,a4,26
    800050b8:	078e                	slli	a5,a5,0x3
    800050ba:	953e                	add	a0,a0,a5
    800050bc:	611c                	ld	a5,0(a0)
    800050be:	c395                	beqz	a5,800050e2 <argfd+0x64>
    return -1;
  if(pfd)
    800050c0:	00090463          	beqz	s2,800050c8 <argfd+0x4a>
    *pfd = fd;
    800050c4:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800050c8:	4501                	li	a0,0
  if(pf)
    800050ca:	c091                	beqz	s1,800050ce <argfd+0x50>
    *pf = f;
    800050cc:	e09c                	sd	a5,0(s1)
}
    800050ce:	70a2                	ld	ra,40(sp)
    800050d0:	7402                	ld	s0,32(sp)
    800050d2:	64e2                	ld	s1,24(sp)
    800050d4:	6942                	ld	s2,16(sp)
    800050d6:	6145                	addi	sp,sp,48
    800050d8:	8082                	ret
    return -1;
    800050da:	557d                	li	a0,-1
    800050dc:	bfcd                	j	800050ce <argfd+0x50>
    return -1;
    800050de:	557d                	li	a0,-1
    800050e0:	b7fd                	j	800050ce <argfd+0x50>
    800050e2:	557d                	li	a0,-1
    800050e4:	b7ed                	j	800050ce <argfd+0x50>

00000000800050e6 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800050e6:	1101                	addi	sp,sp,-32
    800050e8:	ec06                	sd	ra,24(sp)
    800050ea:	e822                	sd	s0,16(sp)
    800050ec:	e426                	sd	s1,8(sp)
    800050ee:	1000                	addi	s0,sp,32
    800050f0:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800050f2:	ffffd097          	auipc	ra,0xffffd
    800050f6:	8b4080e7          	jalr	-1868(ra) # 800019a6 <myproc>
    800050fa:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800050fc:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7ffc90d0>
    80005100:	4501                	li	a0,0
    80005102:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80005104:	6398                	ld	a4,0(a5)
    80005106:	cb19                	beqz	a4,8000511c <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80005108:	2505                	addiw	a0,a0,1
    8000510a:	07a1                	addi	a5,a5,8
    8000510c:	fed51ce3          	bne	a0,a3,80005104 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80005110:	557d                	li	a0,-1
}
    80005112:	60e2                	ld	ra,24(sp)
    80005114:	6442                	ld	s0,16(sp)
    80005116:	64a2                	ld	s1,8(sp)
    80005118:	6105                	addi	sp,sp,32
    8000511a:	8082                	ret
      p->ofile[fd] = f;
    8000511c:	01a50793          	addi	a5,a0,26
    80005120:	078e                	slli	a5,a5,0x3
    80005122:	963e                	add	a2,a2,a5
    80005124:	e204                	sd	s1,0(a2)
      return fd;
    80005126:	b7f5                	j	80005112 <fdalloc+0x2c>

0000000080005128 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80005128:	715d                	addi	sp,sp,-80
    8000512a:	e486                	sd	ra,72(sp)
    8000512c:	e0a2                	sd	s0,64(sp)
    8000512e:	fc26                	sd	s1,56(sp)
    80005130:	f84a                	sd	s2,48(sp)
    80005132:	f44e                	sd	s3,40(sp)
    80005134:	f052                	sd	s4,32(sp)
    80005136:	ec56                	sd	s5,24(sp)
    80005138:	0880                	addi	s0,sp,80
    8000513a:	89ae                	mv	s3,a1
    8000513c:	8ab2                	mv	s5,a2
    8000513e:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80005140:	fb040593          	addi	a1,s0,-80
    80005144:	fffff097          	auipc	ra,0xfffff
    80005148:	e7e080e7          	jalr	-386(ra) # 80003fc2 <nameiparent>
    8000514c:	892a                	mv	s2,a0
    8000514e:	12050f63          	beqz	a0,8000528c <create+0x164>
    return 0;

  ilock(dp);
    80005152:	ffffe097          	auipc	ra,0xffffe
    80005156:	69c080e7          	jalr	1692(ra) # 800037ee <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000515a:	4601                	li	a2,0
    8000515c:	fb040593          	addi	a1,s0,-80
    80005160:	854a                	mv	a0,s2
    80005162:	fffff097          	auipc	ra,0xfffff
    80005166:	b70080e7          	jalr	-1168(ra) # 80003cd2 <dirlookup>
    8000516a:	84aa                	mv	s1,a0
    8000516c:	c921                	beqz	a0,800051bc <create+0x94>
    iunlockput(dp);
    8000516e:	854a                	mv	a0,s2
    80005170:	fffff097          	auipc	ra,0xfffff
    80005174:	8e0080e7          	jalr	-1824(ra) # 80003a50 <iunlockput>
    ilock(ip);
    80005178:	8526                	mv	a0,s1
    8000517a:	ffffe097          	auipc	ra,0xffffe
    8000517e:	674080e7          	jalr	1652(ra) # 800037ee <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80005182:	2981                	sext.w	s3,s3
    80005184:	4789                	li	a5,2
    80005186:	02f99463          	bne	s3,a5,800051ae <create+0x86>
    8000518a:	0444d783          	lhu	a5,68(s1)
    8000518e:	37f9                	addiw	a5,a5,-2
    80005190:	17c2                	slli	a5,a5,0x30
    80005192:	93c1                	srli	a5,a5,0x30
    80005194:	4705                	li	a4,1
    80005196:	00f76c63          	bltu	a4,a5,800051ae <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    8000519a:	8526                	mv	a0,s1
    8000519c:	60a6                	ld	ra,72(sp)
    8000519e:	6406                	ld	s0,64(sp)
    800051a0:	74e2                	ld	s1,56(sp)
    800051a2:	7942                	ld	s2,48(sp)
    800051a4:	79a2                	ld	s3,40(sp)
    800051a6:	7a02                	ld	s4,32(sp)
    800051a8:	6ae2                	ld	s5,24(sp)
    800051aa:	6161                	addi	sp,sp,80
    800051ac:	8082                	ret
    iunlockput(ip);
    800051ae:	8526                	mv	a0,s1
    800051b0:	fffff097          	auipc	ra,0xfffff
    800051b4:	8a0080e7          	jalr	-1888(ra) # 80003a50 <iunlockput>
    return 0;
    800051b8:	4481                	li	s1,0
    800051ba:	b7c5                	j	8000519a <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    800051bc:	85ce                	mv	a1,s3
    800051be:	00092503          	lw	a0,0(s2)
    800051c2:	ffffe097          	auipc	ra,0xffffe
    800051c6:	494080e7          	jalr	1172(ra) # 80003656 <ialloc>
    800051ca:	84aa                	mv	s1,a0
    800051cc:	c529                	beqz	a0,80005216 <create+0xee>
  ilock(ip);
    800051ce:	ffffe097          	auipc	ra,0xffffe
    800051d2:	620080e7          	jalr	1568(ra) # 800037ee <ilock>
  ip->major = major;
    800051d6:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    800051da:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    800051de:	4785                	li	a5,1
    800051e0:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800051e4:	8526                	mv	a0,s1
    800051e6:	ffffe097          	auipc	ra,0xffffe
    800051ea:	53e080e7          	jalr	1342(ra) # 80003724 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800051ee:	2981                	sext.w	s3,s3
    800051f0:	4785                	li	a5,1
    800051f2:	02f98a63          	beq	s3,a5,80005226 <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    800051f6:	40d0                	lw	a2,4(s1)
    800051f8:	fb040593          	addi	a1,s0,-80
    800051fc:	854a                	mv	a0,s2
    800051fe:	fffff097          	auipc	ra,0xfffff
    80005202:	ce4080e7          	jalr	-796(ra) # 80003ee2 <dirlink>
    80005206:	06054b63          	bltz	a0,8000527c <create+0x154>
  iunlockput(dp);
    8000520a:	854a                	mv	a0,s2
    8000520c:	fffff097          	auipc	ra,0xfffff
    80005210:	844080e7          	jalr	-1980(ra) # 80003a50 <iunlockput>
  return ip;
    80005214:	b759                	j	8000519a <create+0x72>
    panic("create: ialloc");
    80005216:	00003517          	auipc	a0,0x3
    8000521a:	4d250513          	addi	a0,a0,1234 # 800086e8 <syscalls+0x2b0>
    8000521e:	ffffb097          	auipc	ra,0xffffb
    80005222:	312080e7          	jalr	786(ra) # 80000530 <panic>
    dp->nlink++;  // for ".."
    80005226:	04a95783          	lhu	a5,74(s2)
    8000522a:	2785                	addiw	a5,a5,1
    8000522c:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80005230:	854a                	mv	a0,s2
    80005232:	ffffe097          	auipc	ra,0xffffe
    80005236:	4f2080e7          	jalr	1266(ra) # 80003724 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000523a:	40d0                	lw	a2,4(s1)
    8000523c:	00003597          	auipc	a1,0x3
    80005240:	4bc58593          	addi	a1,a1,1212 # 800086f8 <syscalls+0x2c0>
    80005244:	8526                	mv	a0,s1
    80005246:	fffff097          	auipc	ra,0xfffff
    8000524a:	c9c080e7          	jalr	-868(ra) # 80003ee2 <dirlink>
    8000524e:	00054f63          	bltz	a0,8000526c <create+0x144>
    80005252:	00492603          	lw	a2,4(s2)
    80005256:	00003597          	auipc	a1,0x3
    8000525a:	4aa58593          	addi	a1,a1,1194 # 80008700 <syscalls+0x2c8>
    8000525e:	8526                	mv	a0,s1
    80005260:	fffff097          	auipc	ra,0xfffff
    80005264:	c82080e7          	jalr	-894(ra) # 80003ee2 <dirlink>
    80005268:	f80557e3          	bgez	a0,800051f6 <create+0xce>
      panic("create dots");
    8000526c:	00003517          	auipc	a0,0x3
    80005270:	49c50513          	addi	a0,a0,1180 # 80008708 <syscalls+0x2d0>
    80005274:	ffffb097          	auipc	ra,0xffffb
    80005278:	2bc080e7          	jalr	700(ra) # 80000530 <panic>
    panic("create: dirlink");
    8000527c:	00003517          	auipc	a0,0x3
    80005280:	49c50513          	addi	a0,a0,1180 # 80008718 <syscalls+0x2e0>
    80005284:	ffffb097          	auipc	ra,0xffffb
    80005288:	2ac080e7          	jalr	684(ra) # 80000530 <panic>
    return 0;
    8000528c:	84aa                	mv	s1,a0
    8000528e:	b731                	j	8000519a <create+0x72>

0000000080005290 <sys_dup>:
{
    80005290:	7179                	addi	sp,sp,-48
    80005292:	f406                	sd	ra,40(sp)
    80005294:	f022                	sd	s0,32(sp)
    80005296:	ec26                	sd	s1,24(sp)
    80005298:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000529a:	fd840613          	addi	a2,s0,-40
    8000529e:	4581                	li	a1,0
    800052a0:	4501                	li	a0,0
    800052a2:	00000097          	auipc	ra,0x0
    800052a6:	ddc080e7          	jalr	-548(ra) # 8000507e <argfd>
    return -1;
    800052aa:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800052ac:	02054363          	bltz	a0,800052d2 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    800052b0:	fd843503          	ld	a0,-40(s0)
    800052b4:	00000097          	auipc	ra,0x0
    800052b8:	e32080e7          	jalr	-462(ra) # 800050e6 <fdalloc>
    800052bc:	84aa                	mv	s1,a0
    return -1;
    800052be:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800052c0:	00054963          	bltz	a0,800052d2 <sys_dup+0x42>
  filedup(f);
    800052c4:	fd843503          	ld	a0,-40(s0)
    800052c8:	fffff097          	auipc	ra,0xfffff
    800052cc:	37a080e7          	jalr	890(ra) # 80004642 <filedup>
  return fd;
    800052d0:	87a6                	mv	a5,s1
}
    800052d2:	853e                	mv	a0,a5
    800052d4:	70a2                	ld	ra,40(sp)
    800052d6:	7402                	ld	s0,32(sp)
    800052d8:	64e2                	ld	s1,24(sp)
    800052da:	6145                	addi	sp,sp,48
    800052dc:	8082                	ret

00000000800052de <sys_read>:
{
    800052de:	7179                	addi	sp,sp,-48
    800052e0:	f406                	sd	ra,40(sp)
    800052e2:	f022                	sd	s0,32(sp)
    800052e4:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800052e6:	fe840613          	addi	a2,s0,-24
    800052ea:	4581                	li	a1,0
    800052ec:	4501                	li	a0,0
    800052ee:	00000097          	auipc	ra,0x0
    800052f2:	d90080e7          	jalr	-624(ra) # 8000507e <argfd>
    return -1;
    800052f6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800052f8:	04054163          	bltz	a0,8000533a <sys_read+0x5c>
    800052fc:	fe440593          	addi	a1,s0,-28
    80005300:	4509                	li	a0,2
    80005302:	ffffe097          	auipc	ra,0xffffe
    80005306:	97a080e7          	jalr	-1670(ra) # 80002c7c <argint>
    return -1;
    8000530a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000530c:	02054763          	bltz	a0,8000533a <sys_read+0x5c>
    80005310:	fd840593          	addi	a1,s0,-40
    80005314:	4505                	li	a0,1
    80005316:	ffffe097          	auipc	ra,0xffffe
    8000531a:	988080e7          	jalr	-1656(ra) # 80002c9e <argaddr>
    return -1;
    8000531e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005320:	00054d63          	bltz	a0,8000533a <sys_read+0x5c>
  return fileread(f, p, n);
    80005324:	fe442603          	lw	a2,-28(s0)
    80005328:	fd843583          	ld	a1,-40(s0)
    8000532c:	fe843503          	ld	a0,-24(s0)
    80005330:	fffff097          	auipc	ra,0xfffff
    80005334:	49e080e7          	jalr	1182(ra) # 800047ce <fileread>
    80005338:	87aa                	mv	a5,a0
}
    8000533a:	853e                	mv	a0,a5
    8000533c:	70a2                	ld	ra,40(sp)
    8000533e:	7402                	ld	s0,32(sp)
    80005340:	6145                	addi	sp,sp,48
    80005342:	8082                	ret

0000000080005344 <sys_write>:
{
    80005344:	7179                	addi	sp,sp,-48
    80005346:	f406                	sd	ra,40(sp)
    80005348:	f022                	sd	s0,32(sp)
    8000534a:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000534c:	fe840613          	addi	a2,s0,-24
    80005350:	4581                	li	a1,0
    80005352:	4501                	li	a0,0
    80005354:	00000097          	auipc	ra,0x0
    80005358:	d2a080e7          	jalr	-726(ra) # 8000507e <argfd>
    return -1;
    8000535c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000535e:	04054163          	bltz	a0,800053a0 <sys_write+0x5c>
    80005362:	fe440593          	addi	a1,s0,-28
    80005366:	4509                	li	a0,2
    80005368:	ffffe097          	auipc	ra,0xffffe
    8000536c:	914080e7          	jalr	-1772(ra) # 80002c7c <argint>
    return -1;
    80005370:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005372:	02054763          	bltz	a0,800053a0 <sys_write+0x5c>
    80005376:	fd840593          	addi	a1,s0,-40
    8000537a:	4505                	li	a0,1
    8000537c:	ffffe097          	auipc	ra,0xffffe
    80005380:	922080e7          	jalr	-1758(ra) # 80002c9e <argaddr>
    return -1;
    80005384:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005386:	00054d63          	bltz	a0,800053a0 <sys_write+0x5c>
  return filewrite(f, p, n);
    8000538a:	fe442603          	lw	a2,-28(s0)
    8000538e:	fd843583          	ld	a1,-40(s0)
    80005392:	fe843503          	ld	a0,-24(s0)
    80005396:	fffff097          	auipc	ra,0xfffff
    8000539a:	4fa080e7          	jalr	1274(ra) # 80004890 <filewrite>
    8000539e:	87aa                	mv	a5,a0
}
    800053a0:	853e                	mv	a0,a5
    800053a2:	70a2                	ld	ra,40(sp)
    800053a4:	7402                	ld	s0,32(sp)
    800053a6:	6145                	addi	sp,sp,48
    800053a8:	8082                	ret

00000000800053aa <sys_close>:
{
    800053aa:	1101                	addi	sp,sp,-32
    800053ac:	ec06                	sd	ra,24(sp)
    800053ae:	e822                	sd	s0,16(sp)
    800053b0:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800053b2:	fe040613          	addi	a2,s0,-32
    800053b6:	fec40593          	addi	a1,s0,-20
    800053ba:	4501                	li	a0,0
    800053bc:	00000097          	auipc	ra,0x0
    800053c0:	cc2080e7          	jalr	-830(ra) # 8000507e <argfd>
    return -1;
    800053c4:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800053c6:	02054463          	bltz	a0,800053ee <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800053ca:	ffffc097          	auipc	ra,0xffffc
    800053ce:	5dc080e7          	jalr	1500(ra) # 800019a6 <myproc>
    800053d2:	fec42783          	lw	a5,-20(s0)
    800053d6:	07e9                	addi	a5,a5,26
    800053d8:	078e                	slli	a5,a5,0x3
    800053da:	97aa                	add	a5,a5,a0
    800053dc:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    800053e0:	fe043503          	ld	a0,-32(s0)
    800053e4:	fffff097          	auipc	ra,0xfffff
    800053e8:	2b0080e7          	jalr	688(ra) # 80004694 <fileclose>
  return 0;
    800053ec:	4781                	li	a5,0
}
    800053ee:	853e                	mv	a0,a5
    800053f0:	60e2                	ld	ra,24(sp)
    800053f2:	6442                	ld	s0,16(sp)
    800053f4:	6105                	addi	sp,sp,32
    800053f6:	8082                	ret

00000000800053f8 <sys_fstat>:
{
    800053f8:	1101                	addi	sp,sp,-32
    800053fa:	ec06                	sd	ra,24(sp)
    800053fc:	e822                	sd	s0,16(sp)
    800053fe:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005400:	fe840613          	addi	a2,s0,-24
    80005404:	4581                	li	a1,0
    80005406:	4501                	li	a0,0
    80005408:	00000097          	auipc	ra,0x0
    8000540c:	c76080e7          	jalr	-906(ra) # 8000507e <argfd>
    return -1;
    80005410:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005412:	02054563          	bltz	a0,8000543c <sys_fstat+0x44>
    80005416:	fe040593          	addi	a1,s0,-32
    8000541a:	4505                	li	a0,1
    8000541c:	ffffe097          	auipc	ra,0xffffe
    80005420:	882080e7          	jalr	-1918(ra) # 80002c9e <argaddr>
    return -1;
    80005424:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005426:	00054b63          	bltz	a0,8000543c <sys_fstat+0x44>
  return filestat(f, st);
    8000542a:	fe043583          	ld	a1,-32(s0)
    8000542e:	fe843503          	ld	a0,-24(s0)
    80005432:	fffff097          	auipc	ra,0xfffff
    80005436:	32a080e7          	jalr	810(ra) # 8000475c <filestat>
    8000543a:	87aa                	mv	a5,a0
}
    8000543c:	853e                	mv	a0,a5
    8000543e:	60e2                	ld	ra,24(sp)
    80005440:	6442                	ld	s0,16(sp)
    80005442:	6105                	addi	sp,sp,32
    80005444:	8082                	ret

0000000080005446 <sys_link>:
{
    80005446:	7169                	addi	sp,sp,-304
    80005448:	f606                	sd	ra,296(sp)
    8000544a:	f222                	sd	s0,288(sp)
    8000544c:	ee26                	sd	s1,280(sp)
    8000544e:	ea4a                	sd	s2,272(sp)
    80005450:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005452:	08000613          	li	a2,128
    80005456:	ed040593          	addi	a1,s0,-304
    8000545a:	4501                	li	a0,0
    8000545c:	ffffe097          	auipc	ra,0xffffe
    80005460:	864080e7          	jalr	-1948(ra) # 80002cc0 <argstr>
    return -1;
    80005464:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005466:	10054e63          	bltz	a0,80005582 <sys_link+0x13c>
    8000546a:	08000613          	li	a2,128
    8000546e:	f5040593          	addi	a1,s0,-176
    80005472:	4505                	li	a0,1
    80005474:	ffffe097          	auipc	ra,0xffffe
    80005478:	84c080e7          	jalr	-1972(ra) # 80002cc0 <argstr>
    return -1;
    8000547c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000547e:	10054263          	bltz	a0,80005582 <sys_link+0x13c>
  begin_op();
    80005482:	fffff097          	auipc	ra,0xfffff
    80005486:	d3e080e7          	jalr	-706(ra) # 800041c0 <begin_op>
  if((ip = namei(old)) == 0){
    8000548a:	ed040513          	addi	a0,s0,-304
    8000548e:	fffff097          	auipc	ra,0xfffff
    80005492:	b16080e7          	jalr	-1258(ra) # 80003fa4 <namei>
    80005496:	84aa                	mv	s1,a0
    80005498:	c551                	beqz	a0,80005524 <sys_link+0xde>
  ilock(ip);
    8000549a:	ffffe097          	auipc	ra,0xffffe
    8000549e:	354080e7          	jalr	852(ra) # 800037ee <ilock>
  if(ip->type == T_DIR){
    800054a2:	04449703          	lh	a4,68(s1)
    800054a6:	4785                	li	a5,1
    800054a8:	08f70463          	beq	a4,a5,80005530 <sys_link+0xea>
  ip->nlink++;
    800054ac:	04a4d783          	lhu	a5,74(s1)
    800054b0:	2785                	addiw	a5,a5,1
    800054b2:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800054b6:	8526                	mv	a0,s1
    800054b8:	ffffe097          	auipc	ra,0xffffe
    800054bc:	26c080e7          	jalr	620(ra) # 80003724 <iupdate>
  iunlock(ip);
    800054c0:	8526                	mv	a0,s1
    800054c2:	ffffe097          	auipc	ra,0xffffe
    800054c6:	3ee080e7          	jalr	1006(ra) # 800038b0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800054ca:	fd040593          	addi	a1,s0,-48
    800054ce:	f5040513          	addi	a0,s0,-176
    800054d2:	fffff097          	auipc	ra,0xfffff
    800054d6:	af0080e7          	jalr	-1296(ra) # 80003fc2 <nameiparent>
    800054da:	892a                	mv	s2,a0
    800054dc:	c935                	beqz	a0,80005550 <sys_link+0x10a>
  ilock(dp);
    800054de:	ffffe097          	auipc	ra,0xffffe
    800054e2:	310080e7          	jalr	784(ra) # 800037ee <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800054e6:	00092703          	lw	a4,0(s2)
    800054ea:	409c                	lw	a5,0(s1)
    800054ec:	04f71d63          	bne	a4,a5,80005546 <sys_link+0x100>
    800054f0:	40d0                	lw	a2,4(s1)
    800054f2:	fd040593          	addi	a1,s0,-48
    800054f6:	854a                	mv	a0,s2
    800054f8:	fffff097          	auipc	ra,0xfffff
    800054fc:	9ea080e7          	jalr	-1558(ra) # 80003ee2 <dirlink>
    80005500:	04054363          	bltz	a0,80005546 <sys_link+0x100>
  iunlockput(dp);
    80005504:	854a                	mv	a0,s2
    80005506:	ffffe097          	auipc	ra,0xffffe
    8000550a:	54a080e7          	jalr	1354(ra) # 80003a50 <iunlockput>
  iput(ip);
    8000550e:	8526                	mv	a0,s1
    80005510:	ffffe097          	auipc	ra,0xffffe
    80005514:	498080e7          	jalr	1176(ra) # 800039a8 <iput>
  end_op();
    80005518:	fffff097          	auipc	ra,0xfffff
    8000551c:	d28080e7          	jalr	-728(ra) # 80004240 <end_op>
  return 0;
    80005520:	4781                	li	a5,0
    80005522:	a085                	j	80005582 <sys_link+0x13c>
    end_op();
    80005524:	fffff097          	auipc	ra,0xfffff
    80005528:	d1c080e7          	jalr	-740(ra) # 80004240 <end_op>
    return -1;
    8000552c:	57fd                	li	a5,-1
    8000552e:	a891                	j	80005582 <sys_link+0x13c>
    iunlockput(ip);
    80005530:	8526                	mv	a0,s1
    80005532:	ffffe097          	auipc	ra,0xffffe
    80005536:	51e080e7          	jalr	1310(ra) # 80003a50 <iunlockput>
    end_op();
    8000553a:	fffff097          	auipc	ra,0xfffff
    8000553e:	d06080e7          	jalr	-762(ra) # 80004240 <end_op>
    return -1;
    80005542:	57fd                	li	a5,-1
    80005544:	a83d                	j	80005582 <sys_link+0x13c>
    iunlockput(dp);
    80005546:	854a                	mv	a0,s2
    80005548:	ffffe097          	auipc	ra,0xffffe
    8000554c:	508080e7          	jalr	1288(ra) # 80003a50 <iunlockput>
  ilock(ip);
    80005550:	8526                	mv	a0,s1
    80005552:	ffffe097          	auipc	ra,0xffffe
    80005556:	29c080e7          	jalr	668(ra) # 800037ee <ilock>
  ip->nlink--;
    8000555a:	04a4d783          	lhu	a5,74(s1)
    8000555e:	37fd                	addiw	a5,a5,-1
    80005560:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005564:	8526                	mv	a0,s1
    80005566:	ffffe097          	auipc	ra,0xffffe
    8000556a:	1be080e7          	jalr	446(ra) # 80003724 <iupdate>
  iunlockput(ip);
    8000556e:	8526                	mv	a0,s1
    80005570:	ffffe097          	auipc	ra,0xffffe
    80005574:	4e0080e7          	jalr	1248(ra) # 80003a50 <iunlockput>
  end_op();
    80005578:	fffff097          	auipc	ra,0xfffff
    8000557c:	cc8080e7          	jalr	-824(ra) # 80004240 <end_op>
  return -1;
    80005580:	57fd                	li	a5,-1
}
    80005582:	853e                	mv	a0,a5
    80005584:	70b2                	ld	ra,296(sp)
    80005586:	7412                	ld	s0,288(sp)
    80005588:	64f2                	ld	s1,280(sp)
    8000558a:	6952                	ld	s2,272(sp)
    8000558c:	6155                	addi	sp,sp,304
    8000558e:	8082                	ret

0000000080005590 <sys_unlink>:
{
    80005590:	7151                	addi	sp,sp,-240
    80005592:	f586                	sd	ra,232(sp)
    80005594:	f1a2                	sd	s0,224(sp)
    80005596:	eda6                	sd	s1,216(sp)
    80005598:	e9ca                	sd	s2,208(sp)
    8000559a:	e5ce                	sd	s3,200(sp)
    8000559c:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    8000559e:	08000613          	li	a2,128
    800055a2:	f3040593          	addi	a1,s0,-208
    800055a6:	4501                	li	a0,0
    800055a8:	ffffd097          	auipc	ra,0xffffd
    800055ac:	718080e7          	jalr	1816(ra) # 80002cc0 <argstr>
    800055b0:	18054163          	bltz	a0,80005732 <sys_unlink+0x1a2>
  begin_op();
    800055b4:	fffff097          	auipc	ra,0xfffff
    800055b8:	c0c080e7          	jalr	-1012(ra) # 800041c0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800055bc:	fb040593          	addi	a1,s0,-80
    800055c0:	f3040513          	addi	a0,s0,-208
    800055c4:	fffff097          	auipc	ra,0xfffff
    800055c8:	9fe080e7          	jalr	-1538(ra) # 80003fc2 <nameiparent>
    800055cc:	84aa                	mv	s1,a0
    800055ce:	c979                	beqz	a0,800056a4 <sys_unlink+0x114>
  ilock(dp);
    800055d0:	ffffe097          	auipc	ra,0xffffe
    800055d4:	21e080e7          	jalr	542(ra) # 800037ee <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800055d8:	00003597          	auipc	a1,0x3
    800055dc:	12058593          	addi	a1,a1,288 # 800086f8 <syscalls+0x2c0>
    800055e0:	fb040513          	addi	a0,s0,-80
    800055e4:	ffffe097          	auipc	ra,0xffffe
    800055e8:	6d4080e7          	jalr	1748(ra) # 80003cb8 <namecmp>
    800055ec:	14050a63          	beqz	a0,80005740 <sys_unlink+0x1b0>
    800055f0:	00003597          	auipc	a1,0x3
    800055f4:	11058593          	addi	a1,a1,272 # 80008700 <syscalls+0x2c8>
    800055f8:	fb040513          	addi	a0,s0,-80
    800055fc:	ffffe097          	auipc	ra,0xffffe
    80005600:	6bc080e7          	jalr	1724(ra) # 80003cb8 <namecmp>
    80005604:	12050e63          	beqz	a0,80005740 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005608:	f2c40613          	addi	a2,s0,-212
    8000560c:	fb040593          	addi	a1,s0,-80
    80005610:	8526                	mv	a0,s1
    80005612:	ffffe097          	auipc	ra,0xffffe
    80005616:	6c0080e7          	jalr	1728(ra) # 80003cd2 <dirlookup>
    8000561a:	892a                	mv	s2,a0
    8000561c:	12050263          	beqz	a0,80005740 <sys_unlink+0x1b0>
  ilock(ip);
    80005620:	ffffe097          	auipc	ra,0xffffe
    80005624:	1ce080e7          	jalr	462(ra) # 800037ee <ilock>
  if(ip->nlink < 1)
    80005628:	04a91783          	lh	a5,74(s2)
    8000562c:	08f05263          	blez	a5,800056b0 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80005630:	04491703          	lh	a4,68(s2)
    80005634:	4785                	li	a5,1
    80005636:	08f70563          	beq	a4,a5,800056c0 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    8000563a:	4641                	li	a2,16
    8000563c:	4581                	li	a1,0
    8000563e:	fc040513          	addi	a0,s0,-64
    80005642:	ffffb097          	auipc	ra,0xffffb
    80005646:	690080e7          	jalr	1680(ra) # 80000cd2 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000564a:	4741                	li	a4,16
    8000564c:	f2c42683          	lw	a3,-212(s0)
    80005650:	fc040613          	addi	a2,s0,-64
    80005654:	4581                	li	a1,0
    80005656:	8526                	mv	a0,s1
    80005658:	ffffe097          	auipc	ra,0xffffe
    8000565c:	542080e7          	jalr	1346(ra) # 80003b9a <writei>
    80005660:	47c1                	li	a5,16
    80005662:	0af51563          	bne	a0,a5,8000570c <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80005666:	04491703          	lh	a4,68(s2)
    8000566a:	4785                	li	a5,1
    8000566c:	0af70863          	beq	a4,a5,8000571c <sys_unlink+0x18c>
  iunlockput(dp);
    80005670:	8526                	mv	a0,s1
    80005672:	ffffe097          	auipc	ra,0xffffe
    80005676:	3de080e7          	jalr	990(ra) # 80003a50 <iunlockput>
  ip->nlink--;
    8000567a:	04a95783          	lhu	a5,74(s2)
    8000567e:	37fd                	addiw	a5,a5,-1
    80005680:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005684:	854a                	mv	a0,s2
    80005686:	ffffe097          	auipc	ra,0xffffe
    8000568a:	09e080e7          	jalr	158(ra) # 80003724 <iupdate>
  iunlockput(ip);
    8000568e:	854a                	mv	a0,s2
    80005690:	ffffe097          	auipc	ra,0xffffe
    80005694:	3c0080e7          	jalr	960(ra) # 80003a50 <iunlockput>
  end_op();
    80005698:	fffff097          	auipc	ra,0xfffff
    8000569c:	ba8080e7          	jalr	-1112(ra) # 80004240 <end_op>
  return 0;
    800056a0:	4501                	li	a0,0
    800056a2:	a84d                	j	80005754 <sys_unlink+0x1c4>
    end_op();
    800056a4:	fffff097          	auipc	ra,0xfffff
    800056a8:	b9c080e7          	jalr	-1124(ra) # 80004240 <end_op>
    return -1;
    800056ac:	557d                	li	a0,-1
    800056ae:	a05d                	j	80005754 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    800056b0:	00003517          	auipc	a0,0x3
    800056b4:	07850513          	addi	a0,a0,120 # 80008728 <syscalls+0x2f0>
    800056b8:	ffffb097          	auipc	ra,0xffffb
    800056bc:	e78080e7          	jalr	-392(ra) # 80000530 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800056c0:	04c92703          	lw	a4,76(s2)
    800056c4:	02000793          	li	a5,32
    800056c8:	f6e7f9e3          	bgeu	a5,a4,8000563a <sys_unlink+0xaa>
    800056cc:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800056d0:	4741                	li	a4,16
    800056d2:	86ce                	mv	a3,s3
    800056d4:	f1840613          	addi	a2,s0,-232
    800056d8:	4581                	li	a1,0
    800056da:	854a                	mv	a0,s2
    800056dc:	ffffe097          	auipc	ra,0xffffe
    800056e0:	3c6080e7          	jalr	966(ra) # 80003aa2 <readi>
    800056e4:	47c1                	li	a5,16
    800056e6:	00f51b63          	bne	a0,a5,800056fc <sys_unlink+0x16c>
    if(de.inum != 0)
    800056ea:	f1845783          	lhu	a5,-232(s0)
    800056ee:	e7a1                	bnez	a5,80005736 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800056f0:	29c1                	addiw	s3,s3,16
    800056f2:	04c92783          	lw	a5,76(s2)
    800056f6:	fcf9ede3          	bltu	s3,a5,800056d0 <sys_unlink+0x140>
    800056fa:	b781                	j	8000563a <sys_unlink+0xaa>
      panic("isdirempty: readi");
    800056fc:	00003517          	auipc	a0,0x3
    80005700:	04450513          	addi	a0,a0,68 # 80008740 <syscalls+0x308>
    80005704:	ffffb097          	auipc	ra,0xffffb
    80005708:	e2c080e7          	jalr	-468(ra) # 80000530 <panic>
    panic("unlink: writei");
    8000570c:	00003517          	auipc	a0,0x3
    80005710:	04c50513          	addi	a0,a0,76 # 80008758 <syscalls+0x320>
    80005714:	ffffb097          	auipc	ra,0xffffb
    80005718:	e1c080e7          	jalr	-484(ra) # 80000530 <panic>
    dp->nlink--;
    8000571c:	04a4d783          	lhu	a5,74(s1)
    80005720:	37fd                	addiw	a5,a5,-1
    80005722:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005726:	8526                	mv	a0,s1
    80005728:	ffffe097          	auipc	ra,0xffffe
    8000572c:	ffc080e7          	jalr	-4(ra) # 80003724 <iupdate>
    80005730:	b781                	j	80005670 <sys_unlink+0xe0>
    return -1;
    80005732:	557d                	li	a0,-1
    80005734:	a005                	j	80005754 <sys_unlink+0x1c4>
    iunlockput(ip);
    80005736:	854a                	mv	a0,s2
    80005738:	ffffe097          	auipc	ra,0xffffe
    8000573c:	318080e7          	jalr	792(ra) # 80003a50 <iunlockput>
  iunlockput(dp);
    80005740:	8526                	mv	a0,s1
    80005742:	ffffe097          	auipc	ra,0xffffe
    80005746:	30e080e7          	jalr	782(ra) # 80003a50 <iunlockput>
  end_op();
    8000574a:	fffff097          	auipc	ra,0xfffff
    8000574e:	af6080e7          	jalr	-1290(ra) # 80004240 <end_op>
  return -1;
    80005752:	557d                	li	a0,-1
}
    80005754:	70ae                	ld	ra,232(sp)
    80005756:	740e                	ld	s0,224(sp)
    80005758:	64ee                	ld	s1,216(sp)
    8000575a:	694e                	ld	s2,208(sp)
    8000575c:	69ae                	ld	s3,200(sp)
    8000575e:	616d                	addi	sp,sp,240
    80005760:	8082                	ret

0000000080005762 <sys_open>:

uint64
sys_open(void)
{
    80005762:	7131                	addi	sp,sp,-192
    80005764:	fd06                	sd	ra,184(sp)
    80005766:	f922                	sd	s0,176(sp)
    80005768:	f526                	sd	s1,168(sp)
    8000576a:	f14a                	sd	s2,160(sp)
    8000576c:	ed4e                	sd	s3,152(sp)
    8000576e:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80005770:	08000613          	li	a2,128
    80005774:	f5040593          	addi	a1,s0,-176
    80005778:	4501                	li	a0,0
    8000577a:	ffffd097          	auipc	ra,0xffffd
    8000577e:	546080e7          	jalr	1350(ra) # 80002cc0 <argstr>
    return -1;
    80005782:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80005784:	0c054163          	bltz	a0,80005846 <sys_open+0xe4>
    80005788:	f4c40593          	addi	a1,s0,-180
    8000578c:	4505                	li	a0,1
    8000578e:	ffffd097          	auipc	ra,0xffffd
    80005792:	4ee080e7          	jalr	1262(ra) # 80002c7c <argint>
    80005796:	0a054863          	bltz	a0,80005846 <sys_open+0xe4>

  begin_op();
    8000579a:	fffff097          	auipc	ra,0xfffff
    8000579e:	a26080e7          	jalr	-1498(ra) # 800041c0 <begin_op>

  if(omode & O_CREATE){
    800057a2:	f4c42783          	lw	a5,-180(s0)
    800057a6:	2007f793          	andi	a5,a5,512
    800057aa:	cbdd                	beqz	a5,80005860 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    800057ac:	4681                	li	a3,0
    800057ae:	4601                	li	a2,0
    800057b0:	4589                	li	a1,2
    800057b2:	f5040513          	addi	a0,s0,-176
    800057b6:	00000097          	auipc	ra,0x0
    800057ba:	972080e7          	jalr	-1678(ra) # 80005128 <create>
    800057be:	892a                	mv	s2,a0
    if(ip == 0){
    800057c0:	c959                	beqz	a0,80005856 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    800057c2:	04491703          	lh	a4,68(s2)
    800057c6:	478d                	li	a5,3
    800057c8:	00f71763          	bne	a4,a5,800057d6 <sys_open+0x74>
    800057cc:	04695703          	lhu	a4,70(s2)
    800057d0:	47a5                	li	a5,9
    800057d2:	0ce7ec63          	bltu	a5,a4,800058aa <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    800057d6:	fffff097          	auipc	ra,0xfffff
    800057da:	e02080e7          	jalr	-510(ra) # 800045d8 <filealloc>
    800057de:	89aa                	mv	s3,a0
    800057e0:	10050263          	beqz	a0,800058e4 <sys_open+0x182>
    800057e4:	00000097          	auipc	ra,0x0
    800057e8:	902080e7          	jalr	-1790(ra) # 800050e6 <fdalloc>
    800057ec:	84aa                	mv	s1,a0
    800057ee:	0e054663          	bltz	a0,800058da <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    800057f2:	04491703          	lh	a4,68(s2)
    800057f6:	478d                	li	a5,3
    800057f8:	0cf70463          	beq	a4,a5,800058c0 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    800057fc:	4789                	li	a5,2
    800057fe:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80005802:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80005806:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    8000580a:	f4c42783          	lw	a5,-180(s0)
    8000580e:	0017c713          	xori	a4,a5,1
    80005812:	8b05                	andi	a4,a4,1
    80005814:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005818:	0037f713          	andi	a4,a5,3
    8000581c:	00e03733          	snez	a4,a4
    80005820:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005824:	4007f793          	andi	a5,a5,1024
    80005828:	c791                	beqz	a5,80005834 <sys_open+0xd2>
    8000582a:	04491703          	lh	a4,68(s2)
    8000582e:	4789                	li	a5,2
    80005830:	08f70f63          	beq	a4,a5,800058ce <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80005834:	854a                	mv	a0,s2
    80005836:	ffffe097          	auipc	ra,0xffffe
    8000583a:	07a080e7          	jalr	122(ra) # 800038b0 <iunlock>
  end_op();
    8000583e:	fffff097          	auipc	ra,0xfffff
    80005842:	a02080e7          	jalr	-1534(ra) # 80004240 <end_op>

  return fd;
}
    80005846:	8526                	mv	a0,s1
    80005848:	70ea                	ld	ra,184(sp)
    8000584a:	744a                	ld	s0,176(sp)
    8000584c:	74aa                	ld	s1,168(sp)
    8000584e:	790a                	ld	s2,160(sp)
    80005850:	69ea                	ld	s3,152(sp)
    80005852:	6129                	addi	sp,sp,192
    80005854:	8082                	ret
      end_op();
    80005856:	fffff097          	auipc	ra,0xfffff
    8000585a:	9ea080e7          	jalr	-1558(ra) # 80004240 <end_op>
      return -1;
    8000585e:	b7e5                	j	80005846 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80005860:	f5040513          	addi	a0,s0,-176
    80005864:	ffffe097          	auipc	ra,0xffffe
    80005868:	740080e7          	jalr	1856(ra) # 80003fa4 <namei>
    8000586c:	892a                	mv	s2,a0
    8000586e:	c905                	beqz	a0,8000589e <sys_open+0x13c>
    ilock(ip);
    80005870:	ffffe097          	auipc	ra,0xffffe
    80005874:	f7e080e7          	jalr	-130(ra) # 800037ee <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005878:	04491703          	lh	a4,68(s2)
    8000587c:	4785                	li	a5,1
    8000587e:	f4f712e3          	bne	a4,a5,800057c2 <sys_open+0x60>
    80005882:	f4c42783          	lw	a5,-180(s0)
    80005886:	dba1                	beqz	a5,800057d6 <sys_open+0x74>
      iunlockput(ip);
    80005888:	854a                	mv	a0,s2
    8000588a:	ffffe097          	auipc	ra,0xffffe
    8000588e:	1c6080e7          	jalr	454(ra) # 80003a50 <iunlockput>
      end_op();
    80005892:	fffff097          	auipc	ra,0xfffff
    80005896:	9ae080e7          	jalr	-1618(ra) # 80004240 <end_op>
      return -1;
    8000589a:	54fd                	li	s1,-1
    8000589c:	b76d                	j	80005846 <sys_open+0xe4>
      end_op();
    8000589e:	fffff097          	auipc	ra,0xfffff
    800058a2:	9a2080e7          	jalr	-1630(ra) # 80004240 <end_op>
      return -1;
    800058a6:	54fd                	li	s1,-1
    800058a8:	bf79                	j	80005846 <sys_open+0xe4>
    iunlockput(ip);
    800058aa:	854a                	mv	a0,s2
    800058ac:	ffffe097          	auipc	ra,0xffffe
    800058b0:	1a4080e7          	jalr	420(ra) # 80003a50 <iunlockput>
    end_op();
    800058b4:	fffff097          	auipc	ra,0xfffff
    800058b8:	98c080e7          	jalr	-1652(ra) # 80004240 <end_op>
    return -1;
    800058bc:	54fd                	li	s1,-1
    800058be:	b761                	j	80005846 <sys_open+0xe4>
    f->type = FD_DEVICE;
    800058c0:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    800058c4:	04691783          	lh	a5,70(s2)
    800058c8:	02f99223          	sh	a5,36(s3)
    800058cc:	bf2d                	j	80005806 <sys_open+0xa4>
    itrunc(ip);
    800058ce:	854a                	mv	a0,s2
    800058d0:	ffffe097          	auipc	ra,0xffffe
    800058d4:	02c080e7          	jalr	44(ra) # 800038fc <itrunc>
    800058d8:	bfb1                	j	80005834 <sys_open+0xd2>
      fileclose(f);
    800058da:	854e                	mv	a0,s3
    800058dc:	fffff097          	auipc	ra,0xfffff
    800058e0:	db8080e7          	jalr	-584(ra) # 80004694 <fileclose>
    iunlockput(ip);
    800058e4:	854a                	mv	a0,s2
    800058e6:	ffffe097          	auipc	ra,0xffffe
    800058ea:	16a080e7          	jalr	362(ra) # 80003a50 <iunlockput>
    end_op();
    800058ee:	fffff097          	auipc	ra,0xfffff
    800058f2:	952080e7          	jalr	-1710(ra) # 80004240 <end_op>
    return -1;
    800058f6:	54fd                	li	s1,-1
    800058f8:	b7b9                	j	80005846 <sys_open+0xe4>

00000000800058fa <sys_mkdir>:

uint64
sys_mkdir(void)
{
    800058fa:	7175                	addi	sp,sp,-144
    800058fc:	e506                	sd	ra,136(sp)
    800058fe:	e122                	sd	s0,128(sp)
    80005900:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005902:	fffff097          	auipc	ra,0xfffff
    80005906:	8be080e7          	jalr	-1858(ra) # 800041c0 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    8000590a:	08000613          	li	a2,128
    8000590e:	f7040593          	addi	a1,s0,-144
    80005912:	4501                	li	a0,0
    80005914:	ffffd097          	auipc	ra,0xffffd
    80005918:	3ac080e7          	jalr	940(ra) # 80002cc0 <argstr>
    8000591c:	02054963          	bltz	a0,8000594e <sys_mkdir+0x54>
    80005920:	4681                	li	a3,0
    80005922:	4601                	li	a2,0
    80005924:	4585                	li	a1,1
    80005926:	f7040513          	addi	a0,s0,-144
    8000592a:	fffff097          	auipc	ra,0xfffff
    8000592e:	7fe080e7          	jalr	2046(ra) # 80005128 <create>
    80005932:	cd11                	beqz	a0,8000594e <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005934:	ffffe097          	auipc	ra,0xffffe
    80005938:	11c080e7          	jalr	284(ra) # 80003a50 <iunlockput>
  end_op();
    8000593c:	fffff097          	auipc	ra,0xfffff
    80005940:	904080e7          	jalr	-1788(ra) # 80004240 <end_op>
  return 0;
    80005944:	4501                	li	a0,0
}
    80005946:	60aa                	ld	ra,136(sp)
    80005948:	640a                	ld	s0,128(sp)
    8000594a:	6149                	addi	sp,sp,144
    8000594c:	8082                	ret
    end_op();
    8000594e:	fffff097          	auipc	ra,0xfffff
    80005952:	8f2080e7          	jalr	-1806(ra) # 80004240 <end_op>
    return -1;
    80005956:	557d                	li	a0,-1
    80005958:	b7fd                	j	80005946 <sys_mkdir+0x4c>

000000008000595a <sys_mknod>:

uint64
sys_mknod(void)
{
    8000595a:	7135                	addi	sp,sp,-160
    8000595c:	ed06                	sd	ra,152(sp)
    8000595e:	e922                	sd	s0,144(sp)
    80005960:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005962:	fffff097          	auipc	ra,0xfffff
    80005966:	85e080e7          	jalr	-1954(ra) # 800041c0 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000596a:	08000613          	li	a2,128
    8000596e:	f7040593          	addi	a1,s0,-144
    80005972:	4501                	li	a0,0
    80005974:	ffffd097          	auipc	ra,0xffffd
    80005978:	34c080e7          	jalr	844(ra) # 80002cc0 <argstr>
    8000597c:	04054a63          	bltz	a0,800059d0 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80005980:	f6c40593          	addi	a1,s0,-148
    80005984:	4505                	li	a0,1
    80005986:	ffffd097          	auipc	ra,0xffffd
    8000598a:	2f6080e7          	jalr	758(ra) # 80002c7c <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000598e:	04054163          	bltz	a0,800059d0 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80005992:	f6840593          	addi	a1,s0,-152
    80005996:	4509                	li	a0,2
    80005998:	ffffd097          	auipc	ra,0xffffd
    8000599c:	2e4080e7          	jalr	740(ra) # 80002c7c <argint>
     argint(1, &major) < 0 ||
    800059a0:	02054863          	bltz	a0,800059d0 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800059a4:	f6841683          	lh	a3,-152(s0)
    800059a8:	f6c41603          	lh	a2,-148(s0)
    800059ac:	458d                	li	a1,3
    800059ae:	f7040513          	addi	a0,s0,-144
    800059b2:	fffff097          	auipc	ra,0xfffff
    800059b6:	776080e7          	jalr	1910(ra) # 80005128 <create>
     argint(2, &minor) < 0 ||
    800059ba:	c919                	beqz	a0,800059d0 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800059bc:	ffffe097          	auipc	ra,0xffffe
    800059c0:	094080e7          	jalr	148(ra) # 80003a50 <iunlockput>
  end_op();
    800059c4:	fffff097          	auipc	ra,0xfffff
    800059c8:	87c080e7          	jalr	-1924(ra) # 80004240 <end_op>
  return 0;
    800059cc:	4501                	li	a0,0
    800059ce:	a031                	j	800059da <sys_mknod+0x80>
    end_op();
    800059d0:	fffff097          	auipc	ra,0xfffff
    800059d4:	870080e7          	jalr	-1936(ra) # 80004240 <end_op>
    return -1;
    800059d8:	557d                	li	a0,-1
}
    800059da:	60ea                	ld	ra,152(sp)
    800059dc:	644a                	ld	s0,144(sp)
    800059de:	610d                	addi	sp,sp,160
    800059e0:	8082                	ret

00000000800059e2 <sys_chdir>:

uint64
sys_chdir(void)
{
    800059e2:	7135                	addi	sp,sp,-160
    800059e4:	ed06                	sd	ra,152(sp)
    800059e6:	e922                	sd	s0,144(sp)
    800059e8:	e526                	sd	s1,136(sp)
    800059ea:	e14a                	sd	s2,128(sp)
    800059ec:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800059ee:	ffffc097          	auipc	ra,0xffffc
    800059f2:	fb8080e7          	jalr	-72(ra) # 800019a6 <myproc>
    800059f6:	892a                	mv	s2,a0
  
  begin_op();
    800059f8:	ffffe097          	auipc	ra,0xffffe
    800059fc:	7c8080e7          	jalr	1992(ra) # 800041c0 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005a00:	08000613          	li	a2,128
    80005a04:	f6040593          	addi	a1,s0,-160
    80005a08:	4501                	li	a0,0
    80005a0a:	ffffd097          	auipc	ra,0xffffd
    80005a0e:	2b6080e7          	jalr	694(ra) # 80002cc0 <argstr>
    80005a12:	04054b63          	bltz	a0,80005a68 <sys_chdir+0x86>
    80005a16:	f6040513          	addi	a0,s0,-160
    80005a1a:	ffffe097          	auipc	ra,0xffffe
    80005a1e:	58a080e7          	jalr	1418(ra) # 80003fa4 <namei>
    80005a22:	84aa                	mv	s1,a0
    80005a24:	c131                	beqz	a0,80005a68 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005a26:	ffffe097          	auipc	ra,0xffffe
    80005a2a:	dc8080e7          	jalr	-568(ra) # 800037ee <ilock>
  if(ip->type != T_DIR){
    80005a2e:	04449703          	lh	a4,68(s1)
    80005a32:	4785                	li	a5,1
    80005a34:	04f71063          	bne	a4,a5,80005a74 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005a38:	8526                	mv	a0,s1
    80005a3a:	ffffe097          	auipc	ra,0xffffe
    80005a3e:	e76080e7          	jalr	-394(ra) # 800038b0 <iunlock>
  iput(p->cwd);
    80005a42:	15093503          	ld	a0,336(s2)
    80005a46:	ffffe097          	auipc	ra,0xffffe
    80005a4a:	f62080e7          	jalr	-158(ra) # 800039a8 <iput>
  end_op();
    80005a4e:	ffffe097          	auipc	ra,0xffffe
    80005a52:	7f2080e7          	jalr	2034(ra) # 80004240 <end_op>
  p->cwd = ip;
    80005a56:	14993823          	sd	s1,336(s2)
  return 0;
    80005a5a:	4501                	li	a0,0
}
    80005a5c:	60ea                	ld	ra,152(sp)
    80005a5e:	644a                	ld	s0,144(sp)
    80005a60:	64aa                	ld	s1,136(sp)
    80005a62:	690a                	ld	s2,128(sp)
    80005a64:	610d                	addi	sp,sp,160
    80005a66:	8082                	ret
    end_op();
    80005a68:	ffffe097          	auipc	ra,0xffffe
    80005a6c:	7d8080e7          	jalr	2008(ra) # 80004240 <end_op>
    return -1;
    80005a70:	557d                	li	a0,-1
    80005a72:	b7ed                	j	80005a5c <sys_chdir+0x7a>
    iunlockput(ip);
    80005a74:	8526                	mv	a0,s1
    80005a76:	ffffe097          	auipc	ra,0xffffe
    80005a7a:	fda080e7          	jalr	-38(ra) # 80003a50 <iunlockput>
    end_op();
    80005a7e:	ffffe097          	auipc	ra,0xffffe
    80005a82:	7c2080e7          	jalr	1986(ra) # 80004240 <end_op>
    return -1;
    80005a86:	557d                	li	a0,-1
    80005a88:	bfd1                	j	80005a5c <sys_chdir+0x7a>

0000000080005a8a <sys_exec>:

uint64
sys_exec(void)
{
    80005a8a:	7145                	addi	sp,sp,-464
    80005a8c:	e786                	sd	ra,456(sp)
    80005a8e:	e3a2                	sd	s0,448(sp)
    80005a90:	ff26                	sd	s1,440(sp)
    80005a92:	fb4a                	sd	s2,432(sp)
    80005a94:	f74e                	sd	s3,424(sp)
    80005a96:	f352                	sd	s4,416(sp)
    80005a98:	ef56                	sd	s5,408(sp)
    80005a9a:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005a9c:	08000613          	li	a2,128
    80005aa0:	f4040593          	addi	a1,s0,-192
    80005aa4:	4501                	li	a0,0
    80005aa6:	ffffd097          	auipc	ra,0xffffd
    80005aaa:	21a080e7          	jalr	538(ra) # 80002cc0 <argstr>
    return -1;
    80005aae:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005ab0:	0c054a63          	bltz	a0,80005b84 <sys_exec+0xfa>
    80005ab4:	e3840593          	addi	a1,s0,-456
    80005ab8:	4505                	li	a0,1
    80005aba:	ffffd097          	auipc	ra,0xffffd
    80005abe:	1e4080e7          	jalr	484(ra) # 80002c9e <argaddr>
    80005ac2:	0c054163          	bltz	a0,80005b84 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80005ac6:	10000613          	li	a2,256
    80005aca:	4581                	li	a1,0
    80005acc:	e4040513          	addi	a0,s0,-448
    80005ad0:	ffffb097          	auipc	ra,0xffffb
    80005ad4:	202080e7          	jalr	514(ra) # 80000cd2 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005ad8:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80005adc:	89a6                	mv	s3,s1
    80005ade:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005ae0:	02000a13          	li	s4,32
    80005ae4:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005ae8:	00391513          	slli	a0,s2,0x3
    80005aec:	e3040593          	addi	a1,s0,-464
    80005af0:	e3843783          	ld	a5,-456(s0)
    80005af4:	953e                	add	a0,a0,a5
    80005af6:	ffffd097          	auipc	ra,0xffffd
    80005afa:	0ec080e7          	jalr	236(ra) # 80002be2 <fetchaddr>
    80005afe:	02054a63          	bltz	a0,80005b32 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80005b02:	e3043783          	ld	a5,-464(s0)
    80005b06:	c3b9                	beqz	a5,80005b4c <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005b08:	ffffb097          	auipc	ra,0xffffb
    80005b0c:	fde080e7          	jalr	-34(ra) # 80000ae6 <kalloc>
    80005b10:	85aa                	mv	a1,a0
    80005b12:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005b16:	cd11                	beqz	a0,80005b32 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005b18:	6605                	lui	a2,0x1
    80005b1a:	e3043503          	ld	a0,-464(s0)
    80005b1e:	ffffd097          	auipc	ra,0xffffd
    80005b22:	116080e7          	jalr	278(ra) # 80002c34 <fetchstr>
    80005b26:	00054663          	bltz	a0,80005b32 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80005b2a:	0905                	addi	s2,s2,1
    80005b2c:	09a1                	addi	s3,s3,8
    80005b2e:	fb491be3          	bne	s2,s4,80005ae4 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005b32:	10048913          	addi	s2,s1,256
    80005b36:	6088                	ld	a0,0(s1)
    80005b38:	c529                	beqz	a0,80005b82 <sys_exec+0xf8>
    kfree(argv[i]);
    80005b3a:	ffffb097          	auipc	ra,0xffffb
    80005b3e:	eb0080e7          	jalr	-336(ra) # 800009ea <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005b42:	04a1                	addi	s1,s1,8
    80005b44:	ff2499e3          	bne	s1,s2,80005b36 <sys_exec+0xac>
  return -1;
    80005b48:	597d                	li	s2,-1
    80005b4a:	a82d                	j	80005b84 <sys_exec+0xfa>
      argv[i] = 0;
    80005b4c:	0a8e                	slli	s5,s5,0x3
    80005b4e:	fc040793          	addi	a5,s0,-64
    80005b52:	9abe                	add	s5,s5,a5
    80005b54:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80005b58:	e4040593          	addi	a1,s0,-448
    80005b5c:	f4040513          	addi	a0,s0,-192
    80005b60:	fffff097          	auipc	ra,0xfffff
    80005b64:	194080e7          	jalr	404(ra) # 80004cf4 <exec>
    80005b68:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005b6a:	10048993          	addi	s3,s1,256
    80005b6e:	6088                	ld	a0,0(s1)
    80005b70:	c911                	beqz	a0,80005b84 <sys_exec+0xfa>
    kfree(argv[i]);
    80005b72:	ffffb097          	auipc	ra,0xffffb
    80005b76:	e78080e7          	jalr	-392(ra) # 800009ea <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005b7a:	04a1                	addi	s1,s1,8
    80005b7c:	ff3499e3          	bne	s1,s3,80005b6e <sys_exec+0xe4>
    80005b80:	a011                	j	80005b84 <sys_exec+0xfa>
  return -1;
    80005b82:	597d                	li	s2,-1
}
    80005b84:	854a                	mv	a0,s2
    80005b86:	60be                	ld	ra,456(sp)
    80005b88:	641e                	ld	s0,448(sp)
    80005b8a:	74fa                	ld	s1,440(sp)
    80005b8c:	795a                	ld	s2,432(sp)
    80005b8e:	79ba                	ld	s3,424(sp)
    80005b90:	7a1a                	ld	s4,416(sp)
    80005b92:	6afa                	ld	s5,408(sp)
    80005b94:	6179                	addi	sp,sp,464
    80005b96:	8082                	ret

0000000080005b98 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005b98:	7139                	addi	sp,sp,-64
    80005b9a:	fc06                	sd	ra,56(sp)
    80005b9c:	f822                	sd	s0,48(sp)
    80005b9e:	f426                	sd	s1,40(sp)
    80005ba0:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005ba2:	ffffc097          	auipc	ra,0xffffc
    80005ba6:	e04080e7          	jalr	-508(ra) # 800019a6 <myproc>
    80005baa:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80005bac:	fd840593          	addi	a1,s0,-40
    80005bb0:	4501                	li	a0,0
    80005bb2:	ffffd097          	auipc	ra,0xffffd
    80005bb6:	0ec080e7          	jalr	236(ra) # 80002c9e <argaddr>
    return -1;
    80005bba:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80005bbc:	0e054063          	bltz	a0,80005c9c <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80005bc0:	fc840593          	addi	a1,s0,-56
    80005bc4:	fd040513          	addi	a0,s0,-48
    80005bc8:	fffff097          	auipc	ra,0xfffff
    80005bcc:	dfc080e7          	jalr	-516(ra) # 800049c4 <pipealloc>
    return -1;
    80005bd0:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005bd2:	0c054563          	bltz	a0,80005c9c <sys_pipe+0x104>
  fd0 = -1;
    80005bd6:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005bda:	fd043503          	ld	a0,-48(s0)
    80005bde:	fffff097          	auipc	ra,0xfffff
    80005be2:	508080e7          	jalr	1288(ra) # 800050e6 <fdalloc>
    80005be6:	fca42223          	sw	a0,-60(s0)
    80005bea:	08054c63          	bltz	a0,80005c82 <sys_pipe+0xea>
    80005bee:	fc843503          	ld	a0,-56(s0)
    80005bf2:	fffff097          	auipc	ra,0xfffff
    80005bf6:	4f4080e7          	jalr	1268(ra) # 800050e6 <fdalloc>
    80005bfa:	fca42023          	sw	a0,-64(s0)
    80005bfe:	06054863          	bltz	a0,80005c6e <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005c02:	4691                	li	a3,4
    80005c04:	fc440613          	addi	a2,s0,-60
    80005c08:	fd843583          	ld	a1,-40(s0)
    80005c0c:	68a8                	ld	a0,80(s1)
    80005c0e:	ffffc097          	auipc	ra,0xffffc
    80005c12:	a2e080e7          	jalr	-1490(ra) # 8000163c <copyout>
    80005c16:	02054063          	bltz	a0,80005c36 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005c1a:	4691                	li	a3,4
    80005c1c:	fc040613          	addi	a2,s0,-64
    80005c20:	fd843583          	ld	a1,-40(s0)
    80005c24:	0591                	addi	a1,a1,4
    80005c26:	68a8                	ld	a0,80(s1)
    80005c28:	ffffc097          	auipc	ra,0xffffc
    80005c2c:	a14080e7          	jalr	-1516(ra) # 8000163c <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005c30:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005c32:	06055563          	bgez	a0,80005c9c <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005c36:	fc442783          	lw	a5,-60(s0)
    80005c3a:	07e9                	addi	a5,a5,26
    80005c3c:	078e                	slli	a5,a5,0x3
    80005c3e:	97a6                	add	a5,a5,s1
    80005c40:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005c44:	fc042503          	lw	a0,-64(s0)
    80005c48:	0569                	addi	a0,a0,26
    80005c4a:	050e                	slli	a0,a0,0x3
    80005c4c:	9526                	add	a0,a0,s1
    80005c4e:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005c52:	fd043503          	ld	a0,-48(s0)
    80005c56:	fffff097          	auipc	ra,0xfffff
    80005c5a:	a3e080e7          	jalr	-1474(ra) # 80004694 <fileclose>
    fileclose(wf);
    80005c5e:	fc843503          	ld	a0,-56(s0)
    80005c62:	fffff097          	auipc	ra,0xfffff
    80005c66:	a32080e7          	jalr	-1486(ra) # 80004694 <fileclose>
    return -1;
    80005c6a:	57fd                	li	a5,-1
    80005c6c:	a805                	j	80005c9c <sys_pipe+0x104>
    if(fd0 >= 0)
    80005c6e:	fc442783          	lw	a5,-60(s0)
    80005c72:	0007c863          	bltz	a5,80005c82 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005c76:	01a78513          	addi	a0,a5,26
    80005c7a:	050e                	slli	a0,a0,0x3
    80005c7c:	9526                	add	a0,a0,s1
    80005c7e:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005c82:	fd043503          	ld	a0,-48(s0)
    80005c86:	fffff097          	auipc	ra,0xfffff
    80005c8a:	a0e080e7          	jalr	-1522(ra) # 80004694 <fileclose>
    fileclose(wf);
    80005c8e:	fc843503          	ld	a0,-56(s0)
    80005c92:	fffff097          	auipc	ra,0xfffff
    80005c96:	a02080e7          	jalr	-1534(ra) # 80004694 <fileclose>
    return -1;
    80005c9a:	57fd                	li	a5,-1
}
    80005c9c:	853e                	mv	a0,a5
    80005c9e:	70e2                	ld	ra,56(sp)
    80005ca0:	7442                	ld	s0,48(sp)
    80005ca2:	74a2                	ld	s1,40(sp)
    80005ca4:	6121                	addi	sp,sp,64
    80005ca6:	8082                	ret

0000000080005ca8 <sys_mmap>:

uint64 sys_mmap(void){
    80005ca8:	715d                	addi	sp,sp,-80
    80005caa:	e486                	sd	ra,72(sp)
    80005cac:	e0a2                	sd	s0,64(sp)
    80005cae:	fc26                	sd	s1,56(sp)
    80005cb0:	0880                	addi	s0,sp,80
  uint64 addr, prot, flags, offset;
  int length, fd;
  struct file* f;
  if(argaddr(0, &addr) < 0 || argint(1, &length) < 0 || argaddr(2, &prot) < 0 || argaddr(3, &flags) < 0 || argfd(4, &fd, &f) < 0 ||  argaddr(5, &offset) < 0 )
    80005cb2:	fd840593          	addi	a1,s0,-40
    80005cb6:	4501                	li	a0,0
    80005cb8:	ffffd097          	auipc	ra,0xffffd
    80005cbc:	fe6080e7          	jalr	-26(ra) # 80002c9e <argaddr>
    return -1;
    80005cc0:	57fd                	li	a5,-1
  if(argaddr(0, &addr) < 0 || argint(1, &length) < 0 || argaddr(2, &prot) < 0 || argaddr(3, &flags) < 0 || argfd(4, &fd, &f) < 0 ||  argaddr(5, &offset) < 0 )
    80005cc2:	0a054c63          	bltz	a0,80005d7a <sys_mmap+0xd2>
    80005cc6:	fbc40593          	addi	a1,s0,-68
    80005cca:	4505                	li	a0,1
    80005ccc:	ffffd097          	auipc	ra,0xffffd
    80005cd0:	fb0080e7          	jalr	-80(ra) # 80002c7c <argint>
    return -1;
    80005cd4:	57fd                	li	a5,-1
  if(argaddr(0, &addr) < 0 || argint(1, &length) < 0 || argaddr(2, &prot) < 0 || argaddr(3, &flags) < 0 || argfd(4, &fd, &f) < 0 ||  argaddr(5, &offset) < 0 )
    80005cd6:	0a054263          	bltz	a0,80005d7a <sys_mmap+0xd2>
    80005cda:	fd040593          	addi	a1,s0,-48
    80005cde:	4509                	li	a0,2
    80005ce0:	ffffd097          	auipc	ra,0xffffd
    80005ce4:	fbe080e7          	jalr	-66(ra) # 80002c9e <argaddr>
    return -1;
    80005ce8:	57fd                	li	a5,-1
  if(argaddr(0, &addr) < 0 || argint(1, &length) < 0 || argaddr(2, &prot) < 0 || argaddr(3, &flags) < 0 || argfd(4, &fd, &f) < 0 ||  argaddr(5, &offset) < 0 )
    80005cea:	08054863          	bltz	a0,80005d7a <sys_mmap+0xd2>
    80005cee:	fc840593          	addi	a1,s0,-56
    80005cf2:	450d                	li	a0,3
    80005cf4:	ffffd097          	auipc	ra,0xffffd
    80005cf8:	faa080e7          	jalr	-86(ra) # 80002c9e <argaddr>
    return -1;
    80005cfc:	57fd                	li	a5,-1
  if(argaddr(0, &addr) < 0 || argint(1, &length) < 0 || argaddr(2, &prot) < 0 || argaddr(3, &flags) < 0 || argfd(4, &fd, &f) < 0 ||  argaddr(5, &offset) < 0 )
    80005cfe:	06054e63          	bltz	a0,80005d7a <sys_mmap+0xd2>
    80005d02:	fb040613          	addi	a2,s0,-80
    80005d06:	fb840593          	addi	a1,s0,-72
    80005d0a:	4511                	li	a0,4
    80005d0c:	fffff097          	auipc	ra,0xfffff
    80005d10:	372080e7          	jalr	882(ra) # 8000507e <argfd>
    return -1;
    80005d14:	57fd                	li	a5,-1
  if(argaddr(0, &addr) < 0 || argint(1, &length) < 0 || argaddr(2, &prot) < 0 || argaddr(3, &flags) < 0 || argfd(4, &fd, &f) < 0 ||  argaddr(5, &offset) < 0 )
    80005d16:	06054263          	bltz	a0,80005d7a <sys_mmap+0xd2>
    80005d1a:	fc040593          	addi	a1,s0,-64
    80005d1e:	4515                	li	a0,5
    80005d20:	ffffd097          	auipc	ra,0xffffd
    80005d24:	f7e080e7          	jalr	-130(ra) # 80002c9e <argaddr>
    80005d28:	0a054963          	bltz	a0,80005dda <sys_mmap+0x132>
    
  if((!f->readable && (prot & (PROT_READ))) || (!f->writable && ((prot & PROT_WRITE) && !(flags & MAP_PRIVATE))))
    80005d2c:	fb043703          	ld	a4,-80(s0)
    80005d30:	00874783          	lbu	a5,8(a4)
    80005d34:	e791                	bnez	a5,80005d40 <sys_mmap+0x98>
    80005d36:	fd043683          	ld	a3,-48(s0)
    80005d3a:	8a85                	andi	a3,a3,1
    return -1;
    80005d3c:	57fd                	li	a5,-1
  if((!f->readable && (prot & (PROT_READ))) || (!f->writable && ((prot & PROT_WRITE) && !(flags & MAP_PRIVATE))))
    80005d3e:	ee95                	bnez	a3,80005d7a <sys_mmap+0xd2>
    80005d40:	00974783          	lbu	a5,9(a4)
    80005d44:	eb91                	bnez	a5,80005d58 <sys_mmap+0xb0>
    80005d46:	fd043783          	ld	a5,-48(s0)
    80005d4a:	8b89                	andi	a5,a5,2
    80005d4c:	c791                	beqz	a5,80005d58 <sys_mmap+0xb0>
    80005d4e:	fc843703          	ld	a4,-56(s0)
    80005d52:	8b09                	andi	a4,a4,2
    return -1;
    80005d54:	57fd                	li	a5,-1
  if((!f->readable && (prot & (PROT_READ))) || (!f->writable && ((prot & PROT_WRITE) && !(flags & MAP_PRIVATE))))
    80005d56:	c315                	beqz	a4,80005d7a <sys_mmap+0xd2>
  // find an unused region in the process's address space in which to map the file, 
  // and add a VMA to the process's table of mapped regions.
  // length = PGROUNDUP(length);
  struct proc* p = myproc();
    80005d58:	ffffc097          	auipc	ra,0xffffc
    80005d5c:	c4e080e7          	jalr	-946(ra) # 800019a6 <myproc>
    80005d60:	85aa                	mv	a1,a0
  /*if(p->sz > MAXVA - length)
    return -1;*/
  
  //uint64 vaend = MMAPEND;
  for(int i = 0; i < 16; i++){
    80005d62:	16850713          	addi	a4,a0,360
    80005d66:	4781                	li	a5,0
    80005d68:	4641                	li	a2,16
    if(p->vma[i].used == 0){
    80005d6a:	4314                	lw	a3,0(a4)
    80005d6c:	ce89                	beqz	a3,80005d86 <sys_mmap+0xde>
  for(int i = 0; i < 16; i++){
    80005d6e:	2785                	addiw	a5,a5,1
    80005d70:	04070713          	addi	a4,a4,64
    80005d74:	fec79be3          	bne	a5,a2,80005d6a <sys_mmap+0xc2>
     // error: here
      vaend = PGROUNDDOWN(p->vma[i].addr); // 计算vma用到的最低的虚拟地址，作为新ma的结尾地址
    }*/
  }
  
  return 0xffffffffffffffff;
    80005d78:	57fd                	li	a5,-1
}
    80005d7a:	853e                	mv	a0,a5
    80005d7c:	60a6                	ld	ra,72(sp)
    80005d7e:	6406                	ld	s0,64(sp)
    80005d80:	74e2                	ld	s1,56(sp)
    80005d82:	6161                	addi	sp,sp,80
    80005d84:	8082                	ret
      p->vma[i].used = 1;
    80005d86:	079a                	slli	a5,a5,0x6
    80005d88:	00f584b3          	add	s1,a1,a5
    80005d8c:	4785                	li	a5,1
    80005d8e:	16f4a423          	sw	a5,360(s1)
      p->vma[i].addr = p->sz;
    80005d92:	65b8                	ld	a4,72(a1)
    80005d94:	16e4b823          	sd	a4,368(s1)
      p->vma[i].length = length;
    80005d98:	fbc42783          	lw	a5,-68(s0)
    80005d9c:	16f4ac23          	sw	a5,376(s1)
      p->vma[i].prot = prot;
    80005da0:	fd043683          	ld	a3,-48(s0)
    80005da4:	18d4b023          	sd	a3,384(s1)
      p->vma[i].flags = flags;
    80005da8:	fc843683          	ld	a3,-56(s0)
    80005dac:	18d4b423          	sd	a3,392(s1)
      p->vma[i].fd = fd;
    80005db0:	fb842683          	lw	a3,-72(s0)
    80005db4:	18d4a823          	sw	a3,400(s1)
      p->vma[i].offset = offset;
    80005db8:	fc043683          	ld	a3,-64(s0)
    80005dbc:	1ad4b023          	sd	a3,416(s1)
      p->vma[i].mapfile = f;
    80005dc0:	fb043503          	ld	a0,-80(s0)
    80005dc4:	18a4bc23          	sd	a0,408(s1)
      p->sz += length;
    80005dc8:	97ba                	add	a5,a5,a4
    80005dca:	e5bc                	sd	a5,72(a1)
      filedup(f); // increase the file's reference count
    80005dcc:	fffff097          	auipc	ra,0xfffff
    80005dd0:	876080e7          	jalr	-1930(ra) # 80004642 <filedup>
      return p->vma[i].addr;
    80005dd4:	1704b783          	ld	a5,368(s1)
    80005dd8:	b74d                	j	80005d7a <sys_mmap+0xd2>
    return -1;
    80005dda:	57fd                	li	a5,-1
    80005ddc:	bf79                	j	80005d7a <sys_mmap+0xd2>

0000000080005dde <sys_munmap>:

uint64 sys_munmap(void){ 
    80005dde:	711d                	addi	sp,sp,-96
    80005de0:	ec86                	sd	ra,88(sp)
    80005de2:	e8a2                	sd	s0,80(sp)
    80005de4:	e4a6                	sd	s1,72(sp)
    80005de6:	e0ca                	sd	s2,64(sp)
    80005de8:	fc4e                	sd	s3,56(sp)
    80005dea:	f852                	sd	s4,48(sp)
    80005dec:	f456                	sd	s5,40(sp)
    80005dee:	f05a                	sd	s6,32(sp)
    80005df0:	ec5e                	sd	s7,24(sp)
    80005df2:	e862                	sd	s8,16(sp)
    80005df4:	1080                	addi	s0,sp,96
  // int munmap(void addr[.length], size_t length);
   uint64 addr;
   int length;
   if(argaddr(0, &addr) < 0 || argint(1, &length) < 0)
    80005df6:	fa840593          	addi	a1,s0,-88
    80005dfa:	4501                	li	a0,0
    80005dfc:	ffffd097          	auipc	ra,0xffffd
    80005e00:	ea2080e7          	jalr	-350(ra) # 80002c9e <argaddr>
     return -1;
    80005e04:	57fd                	li	a5,-1
   if(argaddr(0, &addr) < 0 || argint(1, &length) < 0)
    80005e06:	10054c63          	bltz	a0,80005f1e <sys_munmap+0x140>
    80005e0a:	fa440593          	addi	a1,s0,-92
    80005e0e:	4505                	li	a0,1
    80005e10:	ffffd097          	auipc	ra,0xffffd
    80005e14:	e6c080e7          	jalr	-404(ra) # 80002c7c <argint>
     return -1;
    80005e18:	57fd                	li	a5,-1
   if(argaddr(0, &addr) < 0 || argint(1, &length) < 0)
    80005e1a:	10054263          	bltz	a0,80005f1e <sys_munmap+0x140>
  // 将一个vma分配的所有页释放
  struct proc* p = myproc();
    80005e1e:	ffffc097          	auipc	ra,0xffffc
    80005e22:	b88080e7          	jalr	-1144(ra) # 800019a6 <myproc>
    80005e26:	8aaa                	mv	s5,a0
  for(int i = 0; i < 16; i++){
    80005e28:	16850493          	addi	s1,a0,360
    80005e2c:	56850a13          	addi	s4,a0,1384
    struct vm_area* vma = &p->vma[i];
    if(vma->used == 1 && vma->addr <= addr && addr < (vma->addr + vma->length)){
    80005e30:	4985                	li	s3,1
        if((vma->prot & PROT_WRITE) && (vma->mapfile->writable) && (vma->flags & MAP_SHARED)){
          // 直接调用函数就可以了
          filewrite(vma->mapfile, PGROUNDDOWN(addr), PGROUNDUP(length));
        }
        // unmapped--addr not vma->addr
        uvmunmap(p->pagetable, PGROUNDDOWN(addr), PGROUNDUP(length) / PGSIZE, 1);
    80005e32:	6b05                	lui	s6,0x1
    80005e34:	3b7d                	addiw	s6,s6,-1
    80005e36:	7bfd                	lui	s7,0xfffff
          filewrite(vma->mapfile, PGROUNDDOWN(addr), PGROUNDUP(length));
    80005e38:	7c7d                	lui	s8,0xfffff
    80005e3a:	a0b9                	j	80005e88 <sys_munmap+0xaa>
        uvmunmap(p->pagetable, PGROUNDDOWN(addr), PGROUNDUP(length) / PGSIZE, 1);
    80005e3c:	fa442603          	lw	a2,-92(s0)
    80005e40:	0166063b          	addw	a2,a2,s6
    80005e44:	86ce                	mv	a3,s3
    80005e46:	40c6561b          	sraiw	a2,a2,0xc
    80005e4a:	fa843583          	ld	a1,-88(s0)
    80005e4e:	00bbf5b3          	and	a1,s7,a1
    80005e52:	050ab503          	ld	a0,80(s5)
    80005e56:	ffffb097          	auipc	ra,0xffffb
    80005e5a:	404080e7          	jalr	1028(ra) # 8000125a <uvmunmap>
        // ！判断length，看是否需要把页面全部释放
        if(addr == vma->addr && length == vma->length){
    80005e5e:	00893783          	ld	a5,8(s2)
    80005e62:	fa843703          	ld	a4,-88(s0)
    80005e66:	06e78663          	beq	a5,a4,80005ed2 <sys_munmap+0xf4>
          // length在vma范围内，释放了[addr, length]
          vma->addr += length;
	  vma->length -= length;
    	  vma->offset += length;
    	}
    	else if((addr + length) == (vma->addr + vma->length)) {
    80005e6a:	fa442603          	lw	a2,-92(s0)
    80005e6e:	01092683          	lw	a3,16(s2)
    80005e72:	9732                	add	a4,a4,a2
    80005e74:	97b6                	add	a5,a5,a3
    80005e76:	08f71963          	bne	a4,a5,80005f08 <sys_munmap+0x12a>
    	  // release[length, vma->addr + vma->length];
    	  vma->length -= length;
    80005e7a:	9e91                	subw	a3,a3,a2
    80005e7c:	00d92823          	sw	a3,16(s2)
  for(int i = 0; i < 16; i++){
    80005e80:	04048493          	addi	s1,s1,64
    80005e84:	09448c63          	beq	s1,s4,80005f1c <sys_munmap+0x13e>
    if(vma->used == 1 && vma->addr <= addr && addr < (vma->addr + vma->length)){
    80005e88:	8926                	mv	s2,s1
    80005e8a:	409c                	lw	a5,0(s1)
    80005e8c:	ff379ae3          	bne	a5,s3,80005e80 <sys_munmap+0xa2>
    80005e90:	649c                	ld	a5,8(s1)
    80005e92:	fa843583          	ld	a1,-88(s0)
    80005e96:	fef5e5e3          	bltu	a1,a5,80005e80 <sys_munmap+0xa2>
    80005e9a:	4898                	lw	a4,16(s1)
    80005e9c:	97ba                	add	a5,a5,a4
    80005e9e:	fef5f1e3          	bgeu	a1,a5,80005e80 <sys_munmap+0xa2>
        if((vma->prot & PROT_WRITE) && (vma->mapfile->writable) && (vma->flags & MAP_SHARED)){
    80005ea2:	6c9c                	ld	a5,24(s1)
    80005ea4:	8b89                	andi	a5,a5,2
    80005ea6:	dbd9                	beqz	a5,80005e3c <sys_munmap+0x5e>
    80005ea8:	7888                	ld	a0,48(s1)
    80005eaa:	00954783          	lbu	a5,9(a0)
    80005eae:	d7d9                	beqz	a5,80005e3c <sys_munmap+0x5e>
    80005eb0:	709c                	ld	a5,32(s1)
    80005eb2:	8b85                	andi	a5,a5,1
    80005eb4:	d7c1                	beqz	a5,80005e3c <sys_munmap+0x5e>
          filewrite(vma->mapfile, PGROUNDDOWN(addr), PGROUNDUP(length));
    80005eb6:	fa442603          	lw	a2,-92(s0)
    80005eba:	0166063b          	addw	a2,a2,s6
    80005ebe:	01867633          	and	a2,a2,s8
    80005ec2:	2601                	sext.w	a2,a2
    80005ec4:	0175f5b3          	and	a1,a1,s7
    80005ec8:	fffff097          	auipc	ra,0xfffff
    80005ecc:	9c8080e7          	jalr	-1592(ra) # 80004890 <filewrite>
    80005ed0:	b7b5                	j	80005e3c <sys_munmap+0x5e>
        if(addr == vma->addr && length == vma->length){
    80005ed2:	01092683          	lw	a3,16(s2)
    80005ed6:	fa442703          	lw	a4,-92(s0)
    80005eda:	00e68e63          	beq	a3,a4,80005ef6 <sys_munmap+0x118>
          vma->addr += length;
    80005ede:	97ba                	add	a5,a5,a4
    80005ee0:	00f93423          	sd	a5,8(s2)
	  vma->length -= length;
    80005ee4:	9e99                	subw	a3,a3,a4
    80005ee6:	00d92823          	sw	a3,16(s2)
    	  vma->offset += length;
    80005eea:	03893783          	ld	a5,56(s2)
    80005eee:	973e                	add	a4,a4,a5
    80005ef0:	02e93c23          	sd	a4,56(s2)
    80005ef4:	b771                	j	80005e80 <sys_munmap+0xa2>
          fileclose(vma->mapfile); // ref - 1
    80005ef6:	03093503          	ld	a0,48(s2)
    80005efa:	ffffe097          	auipc	ra,0xffffe
    80005efe:	79a080e7          	jalr	1946(ra) # 80004694 <fileclose>
          vma->used = 0;
    80005f02:	00092023          	sw	zero,0(s2)
    80005f06:	bfad                	j	80005e80 <sys_munmap+0xa2>
    	}
    	else{
    	  printf("munmap: release failed\n");
    80005f08:	00003517          	auipc	a0,0x3
    80005f0c:	86050513          	addi	a0,a0,-1952 # 80008768 <syscalls+0x330>
    80005f10:	ffffa097          	auipc	ra,0xffffa
    80005f14:	66a080e7          	jalr	1642(ra) # 8000057a <printf>
    	  return 1;
    80005f18:	4785                	li	a5,1
    80005f1a:	a011                	j	80005f1e <sys_munmap+0x140>
    	}
      }
    }
  return 0;
    80005f1c:	4781                	li	a5,0
}
    80005f1e:	853e                	mv	a0,a5
    80005f20:	60e6                	ld	ra,88(sp)
    80005f22:	6446                	ld	s0,80(sp)
    80005f24:	64a6                	ld	s1,72(sp)
    80005f26:	6906                	ld	s2,64(sp)
    80005f28:	79e2                	ld	s3,56(sp)
    80005f2a:	7a42                	ld	s4,48(sp)
    80005f2c:	7aa2                	ld	s5,40(sp)
    80005f2e:	7b02                	ld	s6,32(sp)
    80005f30:	6be2                	ld	s7,24(sp)
    80005f32:	6c42                	ld	s8,16(sp)
    80005f34:	6125                	addi	sp,sp,96
    80005f36:	8082                	ret
	...

0000000080005f40 <kernelvec>:
    80005f40:	7111                	addi	sp,sp,-256
    80005f42:	e006                	sd	ra,0(sp)
    80005f44:	e40a                	sd	sp,8(sp)
    80005f46:	e80e                	sd	gp,16(sp)
    80005f48:	ec12                	sd	tp,24(sp)
    80005f4a:	f016                	sd	t0,32(sp)
    80005f4c:	f41a                	sd	t1,40(sp)
    80005f4e:	f81e                	sd	t2,48(sp)
    80005f50:	fc22                	sd	s0,56(sp)
    80005f52:	e0a6                	sd	s1,64(sp)
    80005f54:	e4aa                	sd	a0,72(sp)
    80005f56:	e8ae                	sd	a1,80(sp)
    80005f58:	ecb2                	sd	a2,88(sp)
    80005f5a:	f0b6                	sd	a3,96(sp)
    80005f5c:	f4ba                	sd	a4,104(sp)
    80005f5e:	f8be                	sd	a5,112(sp)
    80005f60:	fcc2                	sd	a6,120(sp)
    80005f62:	e146                	sd	a7,128(sp)
    80005f64:	e54a                	sd	s2,136(sp)
    80005f66:	e94e                	sd	s3,144(sp)
    80005f68:	ed52                	sd	s4,152(sp)
    80005f6a:	f156                	sd	s5,160(sp)
    80005f6c:	f55a                	sd	s6,168(sp)
    80005f6e:	f95e                	sd	s7,176(sp)
    80005f70:	fd62                	sd	s8,184(sp)
    80005f72:	e1e6                	sd	s9,192(sp)
    80005f74:	e5ea                	sd	s10,200(sp)
    80005f76:	e9ee                	sd	s11,208(sp)
    80005f78:	edf2                	sd	t3,216(sp)
    80005f7a:	f1f6                	sd	t4,224(sp)
    80005f7c:	f5fa                	sd	t5,232(sp)
    80005f7e:	f9fe                	sd	t6,240(sp)
    80005f80:	b2ffc0ef          	jal	ra,80002aae <kerneltrap>
    80005f84:	6082                	ld	ra,0(sp)
    80005f86:	6122                	ld	sp,8(sp)
    80005f88:	61c2                	ld	gp,16(sp)
    80005f8a:	7282                	ld	t0,32(sp)
    80005f8c:	7322                	ld	t1,40(sp)
    80005f8e:	73c2                	ld	t2,48(sp)
    80005f90:	7462                	ld	s0,56(sp)
    80005f92:	6486                	ld	s1,64(sp)
    80005f94:	6526                	ld	a0,72(sp)
    80005f96:	65c6                	ld	a1,80(sp)
    80005f98:	6666                	ld	a2,88(sp)
    80005f9a:	7686                	ld	a3,96(sp)
    80005f9c:	7726                	ld	a4,104(sp)
    80005f9e:	77c6                	ld	a5,112(sp)
    80005fa0:	7866                	ld	a6,120(sp)
    80005fa2:	688a                	ld	a7,128(sp)
    80005fa4:	692a                	ld	s2,136(sp)
    80005fa6:	69ca                	ld	s3,144(sp)
    80005fa8:	6a6a                	ld	s4,152(sp)
    80005faa:	7a8a                	ld	s5,160(sp)
    80005fac:	7b2a                	ld	s6,168(sp)
    80005fae:	7bca                	ld	s7,176(sp)
    80005fb0:	7c6a                	ld	s8,184(sp)
    80005fb2:	6c8e                	ld	s9,192(sp)
    80005fb4:	6d2e                	ld	s10,200(sp)
    80005fb6:	6dce                	ld	s11,208(sp)
    80005fb8:	6e6e                	ld	t3,216(sp)
    80005fba:	7e8e                	ld	t4,224(sp)
    80005fbc:	7f2e                	ld	t5,232(sp)
    80005fbe:	7fce                	ld	t6,240(sp)
    80005fc0:	6111                	addi	sp,sp,256
    80005fc2:	10200073          	sret
    80005fc6:	00000013          	nop
    80005fca:	00000013          	nop
    80005fce:	0001                	nop

0000000080005fd0 <timervec>:
    80005fd0:	34051573          	csrrw	a0,mscratch,a0
    80005fd4:	e10c                	sd	a1,0(a0)
    80005fd6:	e510                	sd	a2,8(a0)
    80005fd8:	e914                	sd	a3,16(a0)
    80005fda:	6d0c                	ld	a1,24(a0)
    80005fdc:	7110                	ld	a2,32(a0)
    80005fde:	6194                	ld	a3,0(a1)
    80005fe0:	96b2                	add	a3,a3,a2
    80005fe2:	e194                	sd	a3,0(a1)
    80005fe4:	4589                	li	a1,2
    80005fe6:	14459073          	csrw	sip,a1
    80005fea:	6914                	ld	a3,16(a0)
    80005fec:	6510                	ld	a2,8(a0)
    80005fee:	610c                	ld	a1,0(a0)
    80005ff0:	34051573          	csrrw	a0,mscratch,a0
    80005ff4:	30200073          	mret
	...

0000000080005ffa <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80005ffa:	1141                	addi	sp,sp,-16
    80005ffc:	e422                	sd	s0,8(sp)
    80005ffe:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80006000:	0c0007b7          	lui	a5,0xc000
    80006004:	4705                	li	a4,1
    80006006:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80006008:	c3d8                	sw	a4,4(a5)
}
    8000600a:	6422                	ld	s0,8(sp)
    8000600c:	0141                	addi	sp,sp,16
    8000600e:	8082                	ret

0000000080006010 <plicinithart>:

void
plicinithart(void)
{
    80006010:	1141                	addi	sp,sp,-16
    80006012:	e406                	sd	ra,8(sp)
    80006014:	e022                	sd	s0,0(sp)
    80006016:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006018:	ffffc097          	auipc	ra,0xffffc
    8000601c:	962080e7          	jalr	-1694(ra) # 8000197a <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80006020:	0085171b          	slliw	a4,a0,0x8
    80006024:	0c0027b7          	lui	a5,0xc002
    80006028:	97ba                	add	a5,a5,a4
    8000602a:	40200713          	li	a4,1026
    8000602e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80006032:	00d5151b          	slliw	a0,a0,0xd
    80006036:	0c2017b7          	lui	a5,0xc201
    8000603a:	953e                	add	a0,a0,a5
    8000603c:	00052023          	sw	zero,0(a0)
}
    80006040:	60a2                	ld	ra,8(sp)
    80006042:	6402                	ld	s0,0(sp)
    80006044:	0141                	addi	sp,sp,16
    80006046:	8082                	ret

0000000080006048 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80006048:	1141                	addi	sp,sp,-16
    8000604a:	e406                	sd	ra,8(sp)
    8000604c:	e022                	sd	s0,0(sp)
    8000604e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006050:	ffffc097          	auipc	ra,0xffffc
    80006054:	92a080e7          	jalr	-1750(ra) # 8000197a <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80006058:	00d5179b          	slliw	a5,a0,0xd
    8000605c:	0c201537          	lui	a0,0xc201
    80006060:	953e                	add	a0,a0,a5
  return irq;
}
    80006062:	4148                	lw	a0,4(a0)
    80006064:	60a2                	ld	ra,8(sp)
    80006066:	6402                	ld	s0,0(sp)
    80006068:	0141                	addi	sp,sp,16
    8000606a:	8082                	ret

000000008000606c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000606c:	1101                	addi	sp,sp,-32
    8000606e:	ec06                	sd	ra,24(sp)
    80006070:	e822                	sd	s0,16(sp)
    80006072:	e426                	sd	s1,8(sp)
    80006074:	1000                	addi	s0,sp,32
    80006076:	84aa                	mv	s1,a0
  int hart = cpuid();
    80006078:	ffffc097          	auipc	ra,0xffffc
    8000607c:	902080e7          	jalr	-1790(ra) # 8000197a <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80006080:	00d5151b          	slliw	a0,a0,0xd
    80006084:	0c2017b7          	lui	a5,0xc201
    80006088:	97aa                	add	a5,a5,a0
    8000608a:	c3c4                	sw	s1,4(a5)
}
    8000608c:	60e2                	ld	ra,24(sp)
    8000608e:	6442                	ld	s0,16(sp)
    80006090:	64a2                	ld	s1,8(sp)
    80006092:	6105                	addi	sp,sp,32
    80006094:	8082                	ret

0000000080006096 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80006096:	1141                	addi	sp,sp,-16
    80006098:	e406                	sd	ra,8(sp)
    8000609a:	e022                	sd	s0,0(sp)
    8000609c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000609e:	479d                	li	a5,7
    800060a0:	06a7c963          	blt	a5,a0,80006112 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    800060a4:	0002d797          	auipc	a5,0x2d
    800060a8:	f5c78793          	addi	a5,a5,-164 # 80033000 <disk>
    800060ac:	00a78733          	add	a4,a5,a0
    800060b0:	6789                	lui	a5,0x2
    800060b2:	97ba                	add	a5,a5,a4
    800060b4:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    800060b8:	e7ad                	bnez	a5,80006122 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800060ba:	00451793          	slli	a5,a0,0x4
    800060be:	0002f717          	auipc	a4,0x2f
    800060c2:	f4270713          	addi	a4,a4,-190 # 80035000 <disk+0x2000>
    800060c6:	6314                	ld	a3,0(a4)
    800060c8:	96be                	add	a3,a3,a5
    800060ca:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800060ce:	6314                	ld	a3,0(a4)
    800060d0:	96be                	add	a3,a3,a5
    800060d2:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    800060d6:	6314                	ld	a3,0(a4)
    800060d8:	96be                	add	a3,a3,a5
    800060da:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    800060de:	6318                	ld	a4,0(a4)
    800060e0:	97ba                	add	a5,a5,a4
    800060e2:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    800060e6:	0002d797          	auipc	a5,0x2d
    800060ea:	f1a78793          	addi	a5,a5,-230 # 80033000 <disk>
    800060ee:	97aa                	add	a5,a5,a0
    800060f0:	6509                	lui	a0,0x2
    800060f2:	953e                	add	a0,a0,a5
    800060f4:	4785                	li	a5,1
    800060f6:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    800060fa:	0002f517          	auipc	a0,0x2f
    800060fe:	f1e50513          	addi	a0,a0,-226 # 80035018 <disk+0x2018>
    80006102:	ffffc097          	auipc	ra,0xffffc
    80006106:	2f2080e7          	jalr	754(ra) # 800023f4 <wakeup>
}
    8000610a:	60a2                	ld	ra,8(sp)
    8000610c:	6402                	ld	s0,0(sp)
    8000610e:	0141                	addi	sp,sp,16
    80006110:	8082                	ret
    panic("free_desc 1");
    80006112:	00002517          	auipc	a0,0x2
    80006116:	66e50513          	addi	a0,a0,1646 # 80008780 <syscalls+0x348>
    8000611a:	ffffa097          	auipc	ra,0xffffa
    8000611e:	416080e7          	jalr	1046(ra) # 80000530 <panic>
    panic("free_desc 2");
    80006122:	00002517          	auipc	a0,0x2
    80006126:	66e50513          	addi	a0,a0,1646 # 80008790 <syscalls+0x358>
    8000612a:	ffffa097          	auipc	ra,0xffffa
    8000612e:	406080e7          	jalr	1030(ra) # 80000530 <panic>

0000000080006132 <virtio_disk_init>:
{
    80006132:	1101                	addi	sp,sp,-32
    80006134:	ec06                	sd	ra,24(sp)
    80006136:	e822                	sd	s0,16(sp)
    80006138:	e426                	sd	s1,8(sp)
    8000613a:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000613c:	00002597          	auipc	a1,0x2
    80006140:	66458593          	addi	a1,a1,1636 # 800087a0 <syscalls+0x368>
    80006144:	0002f517          	auipc	a0,0x2f
    80006148:	fe450513          	addi	a0,a0,-28 # 80035128 <disk+0x2128>
    8000614c:	ffffb097          	auipc	ra,0xffffb
    80006150:	9fa080e7          	jalr	-1542(ra) # 80000b46 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006154:	100017b7          	lui	a5,0x10001
    80006158:	4398                	lw	a4,0(a5)
    8000615a:	2701                	sext.w	a4,a4
    8000615c:	747277b7          	lui	a5,0x74727
    80006160:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80006164:	0ef71163          	bne	a4,a5,80006246 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80006168:	100017b7          	lui	a5,0x10001
    8000616c:	43dc                	lw	a5,4(a5)
    8000616e:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006170:	4705                	li	a4,1
    80006172:	0ce79a63          	bne	a5,a4,80006246 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80006176:	100017b7          	lui	a5,0x10001
    8000617a:	479c                	lw	a5,8(a5)
    8000617c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    8000617e:	4709                	li	a4,2
    80006180:	0ce79363          	bne	a5,a4,80006246 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80006184:	100017b7          	lui	a5,0x10001
    80006188:	47d8                	lw	a4,12(a5)
    8000618a:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000618c:	554d47b7          	lui	a5,0x554d4
    80006190:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80006194:	0af71963          	bne	a4,a5,80006246 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    80006198:	100017b7          	lui	a5,0x10001
    8000619c:	4705                	li	a4,1
    8000619e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800061a0:	470d                	li	a4,3
    800061a2:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800061a4:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800061a6:	c7ffe737          	lui	a4,0xc7ffe
    800061aa:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fc875f>
    800061ae:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800061b0:	2701                	sext.w	a4,a4
    800061b2:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800061b4:	472d                	li	a4,11
    800061b6:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800061b8:	473d                	li	a4,15
    800061ba:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    800061bc:	6705                	lui	a4,0x1
    800061be:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800061c0:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800061c4:	5bdc                	lw	a5,52(a5)
    800061c6:	2781                	sext.w	a5,a5
  if(max == 0)
    800061c8:	c7d9                	beqz	a5,80006256 <virtio_disk_init+0x124>
  if(max < NUM)
    800061ca:	471d                	li	a4,7
    800061cc:	08f77d63          	bgeu	a4,a5,80006266 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800061d0:	100014b7          	lui	s1,0x10001
    800061d4:	47a1                	li	a5,8
    800061d6:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    800061d8:	6609                	lui	a2,0x2
    800061da:	4581                	li	a1,0
    800061dc:	0002d517          	auipc	a0,0x2d
    800061e0:	e2450513          	addi	a0,a0,-476 # 80033000 <disk>
    800061e4:	ffffb097          	auipc	ra,0xffffb
    800061e8:	aee080e7          	jalr	-1298(ra) # 80000cd2 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    800061ec:	0002d717          	auipc	a4,0x2d
    800061f0:	e1470713          	addi	a4,a4,-492 # 80033000 <disk>
    800061f4:	00c75793          	srli	a5,a4,0xc
    800061f8:	2781                	sext.w	a5,a5
    800061fa:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    800061fc:	0002f797          	auipc	a5,0x2f
    80006200:	e0478793          	addi	a5,a5,-508 # 80035000 <disk+0x2000>
    80006204:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80006206:	0002d717          	auipc	a4,0x2d
    8000620a:	e7a70713          	addi	a4,a4,-390 # 80033080 <disk+0x80>
    8000620e:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80006210:	0002e717          	auipc	a4,0x2e
    80006214:	df070713          	addi	a4,a4,-528 # 80034000 <disk+0x1000>
    80006218:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    8000621a:	4705                	li	a4,1
    8000621c:	00e78c23          	sb	a4,24(a5)
    80006220:	00e78ca3          	sb	a4,25(a5)
    80006224:	00e78d23          	sb	a4,26(a5)
    80006228:	00e78da3          	sb	a4,27(a5)
    8000622c:	00e78e23          	sb	a4,28(a5)
    80006230:	00e78ea3          	sb	a4,29(a5)
    80006234:	00e78f23          	sb	a4,30(a5)
    80006238:	00e78fa3          	sb	a4,31(a5)
}
    8000623c:	60e2                	ld	ra,24(sp)
    8000623e:	6442                	ld	s0,16(sp)
    80006240:	64a2                	ld	s1,8(sp)
    80006242:	6105                	addi	sp,sp,32
    80006244:	8082                	ret
    panic("could not find virtio disk");
    80006246:	00002517          	auipc	a0,0x2
    8000624a:	56a50513          	addi	a0,a0,1386 # 800087b0 <syscalls+0x378>
    8000624e:	ffffa097          	auipc	ra,0xffffa
    80006252:	2e2080e7          	jalr	738(ra) # 80000530 <panic>
    panic("virtio disk has no queue 0");
    80006256:	00002517          	auipc	a0,0x2
    8000625a:	57a50513          	addi	a0,a0,1402 # 800087d0 <syscalls+0x398>
    8000625e:	ffffa097          	auipc	ra,0xffffa
    80006262:	2d2080e7          	jalr	722(ra) # 80000530 <panic>
    panic("virtio disk max queue too short");
    80006266:	00002517          	auipc	a0,0x2
    8000626a:	58a50513          	addi	a0,a0,1418 # 800087f0 <syscalls+0x3b8>
    8000626e:	ffffa097          	auipc	ra,0xffffa
    80006272:	2c2080e7          	jalr	706(ra) # 80000530 <panic>

0000000080006276 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80006276:	7159                	addi	sp,sp,-112
    80006278:	f486                	sd	ra,104(sp)
    8000627a:	f0a2                	sd	s0,96(sp)
    8000627c:	eca6                	sd	s1,88(sp)
    8000627e:	e8ca                	sd	s2,80(sp)
    80006280:	e4ce                	sd	s3,72(sp)
    80006282:	e0d2                	sd	s4,64(sp)
    80006284:	fc56                	sd	s5,56(sp)
    80006286:	f85a                	sd	s6,48(sp)
    80006288:	f45e                	sd	s7,40(sp)
    8000628a:	f062                	sd	s8,32(sp)
    8000628c:	ec66                	sd	s9,24(sp)
    8000628e:	e86a                	sd	s10,16(sp)
    80006290:	1880                	addi	s0,sp,112
    80006292:	892a                	mv	s2,a0
    80006294:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80006296:	00c52c83          	lw	s9,12(a0)
    8000629a:	001c9c9b          	slliw	s9,s9,0x1
    8000629e:	1c82                	slli	s9,s9,0x20
    800062a0:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800062a4:	0002f517          	auipc	a0,0x2f
    800062a8:	e8450513          	addi	a0,a0,-380 # 80035128 <disk+0x2128>
    800062ac:	ffffb097          	auipc	ra,0xffffb
    800062b0:	92a080e7          	jalr	-1750(ra) # 80000bd6 <acquire>
  for(int i = 0; i < 3; i++){
    800062b4:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800062b6:	4c21                	li	s8,8
      disk.free[i] = 0;
    800062b8:	0002db97          	auipc	s7,0x2d
    800062bc:	d48b8b93          	addi	s7,s7,-696 # 80033000 <disk>
    800062c0:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    800062c2:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    800062c4:	8a4e                	mv	s4,s3
    800062c6:	a051                	j	8000634a <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    800062c8:	00fb86b3          	add	a3,s7,a5
    800062cc:	96da                	add	a3,a3,s6
    800062ce:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    800062d2:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    800062d4:	0207c563          	bltz	a5,800062fe <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    800062d8:	2485                	addiw	s1,s1,1
    800062da:	0711                	addi	a4,a4,4
    800062dc:	25548063          	beq	s1,s5,8000651c <virtio_disk_rw+0x2a6>
    idx[i] = alloc_desc();
    800062e0:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    800062e2:	0002f697          	auipc	a3,0x2f
    800062e6:	d3668693          	addi	a3,a3,-714 # 80035018 <disk+0x2018>
    800062ea:	87d2                	mv	a5,s4
    if(disk.free[i]){
    800062ec:	0006c583          	lbu	a1,0(a3)
    800062f0:	fde1                	bnez	a1,800062c8 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    800062f2:	2785                	addiw	a5,a5,1
    800062f4:	0685                	addi	a3,a3,1
    800062f6:	ff879be3          	bne	a5,s8,800062ec <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    800062fa:	57fd                	li	a5,-1
    800062fc:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    800062fe:	02905a63          	blez	s1,80006332 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80006302:	f9042503          	lw	a0,-112(s0)
    80006306:	00000097          	auipc	ra,0x0
    8000630a:	d90080e7          	jalr	-624(ra) # 80006096 <free_desc>
      for(int j = 0; j < i; j++)
    8000630e:	4785                	li	a5,1
    80006310:	0297d163          	bge	a5,s1,80006332 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80006314:	f9442503          	lw	a0,-108(s0)
    80006318:	00000097          	auipc	ra,0x0
    8000631c:	d7e080e7          	jalr	-642(ra) # 80006096 <free_desc>
      for(int j = 0; j < i; j++)
    80006320:	4789                	li	a5,2
    80006322:	0097d863          	bge	a5,s1,80006332 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80006326:	f9842503          	lw	a0,-104(s0)
    8000632a:	00000097          	auipc	ra,0x0
    8000632e:	d6c080e7          	jalr	-660(ra) # 80006096 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006332:	0002f597          	auipc	a1,0x2f
    80006336:	df658593          	addi	a1,a1,-522 # 80035128 <disk+0x2128>
    8000633a:	0002f517          	auipc	a0,0x2f
    8000633e:	cde50513          	addi	a0,a0,-802 # 80035018 <disk+0x2018>
    80006342:	ffffc097          	auipc	ra,0xffffc
    80006346:	f2c080e7          	jalr	-212(ra) # 8000226e <sleep>
  for(int i = 0; i < 3; i++){
    8000634a:	f9040713          	addi	a4,s0,-112
    8000634e:	84ce                	mv	s1,s3
    80006350:	bf41                	j	800062e0 <virtio_disk_rw+0x6a>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    80006352:	20058713          	addi	a4,a1,512
    80006356:	00471693          	slli	a3,a4,0x4
    8000635a:	0002d717          	auipc	a4,0x2d
    8000635e:	ca670713          	addi	a4,a4,-858 # 80033000 <disk>
    80006362:	9736                	add	a4,a4,a3
    80006364:	4685                	li	a3,1
    80006366:	0ad72423          	sw	a3,168(a4)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    8000636a:	20058713          	addi	a4,a1,512
    8000636e:	00471693          	slli	a3,a4,0x4
    80006372:	0002d717          	auipc	a4,0x2d
    80006376:	c8e70713          	addi	a4,a4,-882 # 80033000 <disk>
    8000637a:	9736                	add	a4,a4,a3
    8000637c:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80006380:	0b973823          	sd	s9,176(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80006384:	7679                	lui	a2,0xffffe
    80006386:	963e                	add	a2,a2,a5
    80006388:	0002f697          	auipc	a3,0x2f
    8000638c:	c7868693          	addi	a3,a3,-904 # 80035000 <disk+0x2000>
    80006390:	6298                	ld	a4,0(a3)
    80006392:	9732                	add	a4,a4,a2
    80006394:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80006396:	6298                	ld	a4,0(a3)
    80006398:	9732                	add	a4,a4,a2
    8000639a:	4541                	li	a0,16
    8000639c:	c708                	sw	a0,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000639e:	6298                	ld	a4,0(a3)
    800063a0:	9732                	add	a4,a4,a2
    800063a2:	4505                	li	a0,1
    800063a4:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[0]].next = idx[1];
    800063a8:	f9442703          	lw	a4,-108(s0)
    800063ac:	6288                	ld	a0,0(a3)
    800063ae:	962a                	add	a2,a2,a0
    800063b0:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffc800e>

  disk.desc[idx[1]].addr = (uint64) b->data;
    800063b4:	0712                	slli	a4,a4,0x4
    800063b6:	6290                	ld	a2,0(a3)
    800063b8:	963a                	add	a2,a2,a4
    800063ba:	05890513          	addi	a0,s2,88
    800063be:	e208                	sd	a0,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800063c0:	6294                	ld	a3,0(a3)
    800063c2:	96ba                	add	a3,a3,a4
    800063c4:	40000613          	li	a2,1024
    800063c8:	c690                	sw	a2,8(a3)
  if(write)
    800063ca:	140d0063          	beqz	s10,8000650a <virtio_disk_rw+0x294>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800063ce:	0002f697          	auipc	a3,0x2f
    800063d2:	c326b683          	ld	a3,-974(a3) # 80035000 <disk+0x2000>
    800063d6:	96ba                	add	a3,a3,a4
    800063d8:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800063dc:	0002d817          	auipc	a6,0x2d
    800063e0:	c2480813          	addi	a6,a6,-988 # 80033000 <disk>
    800063e4:	0002f517          	auipc	a0,0x2f
    800063e8:	c1c50513          	addi	a0,a0,-996 # 80035000 <disk+0x2000>
    800063ec:	6114                	ld	a3,0(a0)
    800063ee:	96ba                	add	a3,a3,a4
    800063f0:	00c6d603          	lhu	a2,12(a3)
    800063f4:	00166613          	ori	a2,a2,1
    800063f8:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    800063fc:	f9842683          	lw	a3,-104(s0)
    80006400:	6110                	ld	a2,0(a0)
    80006402:	9732                	add	a4,a4,a2
    80006404:	00d71723          	sh	a3,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80006408:	20058613          	addi	a2,a1,512
    8000640c:	0612                	slli	a2,a2,0x4
    8000640e:	9642                	add	a2,a2,a6
    80006410:	577d                	li	a4,-1
    80006412:	02e60823          	sb	a4,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80006416:	00469713          	slli	a4,a3,0x4
    8000641a:	6114                	ld	a3,0(a0)
    8000641c:	96ba                	add	a3,a3,a4
    8000641e:	03078793          	addi	a5,a5,48
    80006422:	97c2                	add	a5,a5,a6
    80006424:	e29c                	sd	a5,0(a3)
  disk.desc[idx[2]].len = 1;
    80006426:	611c                	ld	a5,0(a0)
    80006428:	97ba                	add	a5,a5,a4
    8000642a:	4685                	li	a3,1
    8000642c:	c794                	sw	a3,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000642e:	611c                	ld	a5,0(a0)
    80006430:	97ba                	add	a5,a5,a4
    80006432:	4809                	li	a6,2
    80006434:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80006438:	611c                	ld	a5,0(a0)
    8000643a:	973e                	add	a4,a4,a5
    8000643c:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80006440:	00d92223          	sw	a3,4(s2)
  disk.info[idx[0]].b = b;
    80006444:	03263423          	sd	s2,40(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80006448:	6518                	ld	a4,8(a0)
    8000644a:	00275783          	lhu	a5,2(a4)
    8000644e:	8b9d                	andi	a5,a5,7
    80006450:	0786                	slli	a5,a5,0x1
    80006452:	97ba                	add	a5,a5,a4
    80006454:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    80006458:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000645c:	6518                	ld	a4,8(a0)
    8000645e:	00275783          	lhu	a5,2(a4)
    80006462:	2785                	addiw	a5,a5,1
    80006464:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80006468:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000646c:	100017b7          	lui	a5,0x10001
    80006470:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80006474:	00492703          	lw	a4,4(s2)
    80006478:	4785                	li	a5,1
    8000647a:	02f71163          	bne	a4,a5,8000649c <virtio_disk_rw+0x226>
    sleep(b, &disk.vdisk_lock);
    8000647e:	0002f997          	auipc	s3,0x2f
    80006482:	caa98993          	addi	s3,s3,-854 # 80035128 <disk+0x2128>
  while(b->disk == 1) {
    80006486:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80006488:	85ce                	mv	a1,s3
    8000648a:	854a                	mv	a0,s2
    8000648c:	ffffc097          	auipc	ra,0xffffc
    80006490:	de2080e7          	jalr	-542(ra) # 8000226e <sleep>
  while(b->disk == 1) {
    80006494:	00492783          	lw	a5,4(s2)
    80006498:	fe9788e3          	beq	a5,s1,80006488 <virtio_disk_rw+0x212>
  }

  disk.info[idx[0]].b = 0;
    8000649c:	f9042903          	lw	s2,-112(s0)
    800064a0:	20090793          	addi	a5,s2,512
    800064a4:	00479713          	slli	a4,a5,0x4
    800064a8:	0002d797          	auipc	a5,0x2d
    800064ac:	b5878793          	addi	a5,a5,-1192 # 80033000 <disk>
    800064b0:	97ba                	add	a5,a5,a4
    800064b2:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    800064b6:	0002f997          	auipc	s3,0x2f
    800064ba:	b4a98993          	addi	s3,s3,-1206 # 80035000 <disk+0x2000>
    800064be:	00491713          	slli	a4,s2,0x4
    800064c2:	0009b783          	ld	a5,0(s3)
    800064c6:	97ba                	add	a5,a5,a4
    800064c8:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800064cc:	854a                	mv	a0,s2
    800064ce:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800064d2:	00000097          	auipc	ra,0x0
    800064d6:	bc4080e7          	jalr	-1084(ra) # 80006096 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800064da:	8885                	andi	s1,s1,1
    800064dc:	f0ed                	bnez	s1,800064be <virtio_disk_rw+0x248>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800064de:	0002f517          	auipc	a0,0x2f
    800064e2:	c4a50513          	addi	a0,a0,-950 # 80035128 <disk+0x2128>
    800064e6:	ffffa097          	auipc	ra,0xffffa
    800064ea:	7a4080e7          	jalr	1956(ra) # 80000c8a <release>
}
    800064ee:	70a6                	ld	ra,104(sp)
    800064f0:	7406                	ld	s0,96(sp)
    800064f2:	64e6                	ld	s1,88(sp)
    800064f4:	6946                	ld	s2,80(sp)
    800064f6:	69a6                	ld	s3,72(sp)
    800064f8:	6a06                	ld	s4,64(sp)
    800064fa:	7ae2                	ld	s5,56(sp)
    800064fc:	7b42                	ld	s6,48(sp)
    800064fe:	7ba2                	ld	s7,40(sp)
    80006500:	7c02                	ld	s8,32(sp)
    80006502:	6ce2                	ld	s9,24(sp)
    80006504:	6d42                	ld	s10,16(sp)
    80006506:	6165                	addi	sp,sp,112
    80006508:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000650a:	0002f697          	auipc	a3,0x2f
    8000650e:	af66b683          	ld	a3,-1290(a3) # 80035000 <disk+0x2000>
    80006512:	96ba                	add	a3,a3,a4
    80006514:	4609                	li	a2,2
    80006516:	00c69623          	sh	a2,12(a3)
    8000651a:	b5c9                	j	800063dc <virtio_disk_rw+0x166>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000651c:	f9042583          	lw	a1,-112(s0)
    80006520:	20058793          	addi	a5,a1,512
    80006524:	0792                	slli	a5,a5,0x4
    80006526:	0002d517          	auipc	a0,0x2d
    8000652a:	b8250513          	addi	a0,a0,-1150 # 800330a8 <disk+0xa8>
    8000652e:	953e                	add	a0,a0,a5
  if(write)
    80006530:	e20d11e3          	bnez	s10,80006352 <virtio_disk_rw+0xdc>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    80006534:	20058713          	addi	a4,a1,512
    80006538:	00471693          	slli	a3,a4,0x4
    8000653c:	0002d717          	auipc	a4,0x2d
    80006540:	ac470713          	addi	a4,a4,-1340 # 80033000 <disk>
    80006544:	9736                	add	a4,a4,a3
    80006546:	0a072423          	sw	zero,168(a4)
    8000654a:	b505                	j	8000636a <virtio_disk_rw+0xf4>

000000008000654c <virtio_disk_intr>:

void
virtio_disk_intr()
{
    8000654c:	1101                	addi	sp,sp,-32
    8000654e:	ec06                	sd	ra,24(sp)
    80006550:	e822                	sd	s0,16(sp)
    80006552:	e426                	sd	s1,8(sp)
    80006554:	e04a                	sd	s2,0(sp)
    80006556:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80006558:	0002f517          	auipc	a0,0x2f
    8000655c:	bd050513          	addi	a0,a0,-1072 # 80035128 <disk+0x2128>
    80006560:	ffffa097          	auipc	ra,0xffffa
    80006564:	676080e7          	jalr	1654(ra) # 80000bd6 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80006568:	10001737          	lui	a4,0x10001
    8000656c:	533c                	lw	a5,96(a4)
    8000656e:	8b8d                	andi	a5,a5,3
    80006570:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80006572:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80006576:	0002f797          	auipc	a5,0x2f
    8000657a:	a8a78793          	addi	a5,a5,-1398 # 80035000 <disk+0x2000>
    8000657e:	6b94                	ld	a3,16(a5)
    80006580:	0207d703          	lhu	a4,32(a5)
    80006584:	0026d783          	lhu	a5,2(a3)
    80006588:	06f70163          	beq	a4,a5,800065ea <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000658c:	0002d917          	auipc	s2,0x2d
    80006590:	a7490913          	addi	s2,s2,-1420 # 80033000 <disk>
    80006594:	0002f497          	auipc	s1,0x2f
    80006598:	a6c48493          	addi	s1,s1,-1428 # 80035000 <disk+0x2000>
    __sync_synchronize();
    8000659c:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800065a0:	6898                	ld	a4,16(s1)
    800065a2:	0204d783          	lhu	a5,32(s1)
    800065a6:	8b9d                	andi	a5,a5,7
    800065a8:	078e                	slli	a5,a5,0x3
    800065aa:	97ba                	add	a5,a5,a4
    800065ac:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800065ae:	20078713          	addi	a4,a5,512
    800065b2:	0712                	slli	a4,a4,0x4
    800065b4:	974a                	add	a4,a4,s2
    800065b6:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    800065ba:	e731                	bnez	a4,80006606 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800065bc:	20078793          	addi	a5,a5,512
    800065c0:	0792                	slli	a5,a5,0x4
    800065c2:	97ca                	add	a5,a5,s2
    800065c4:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    800065c6:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800065ca:	ffffc097          	auipc	ra,0xffffc
    800065ce:	e2a080e7          	jalr	-470(ra) # 800023f4 <wakeup>

    disk.used_idx += 1;
    800065d2:	0204d783          	lhu	a5,32(s1)
    800065d6:	2785                	addiw	a5,a5,1
    800065d8:	17c2                	slli	a5,a5,0x30
    800065da:	93c1                	srli	a5,a5,0x30
    800065dc:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800065e0:	6898                	ld	a4,16(s1)
    800065e2:	00275703          	lhu	a4,2(a4)
    800065e6:	faf71be3          	bne	a4,a5,8000659c <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    800065ea:	0002f517          	auipc	a0,0x2f
    800065ee:	b3e50513          	addi	a0,a0,-1218 # 80035128 <disk+0x2128>
    800065f2:	ffffa097          	auipc	ra,0xffffa
    800065f6:	698080e7          	jalr	1688(ra) # 80000c8a <release>
}
    800065fa:	60e2                	ld	ra,24(sp)
    800065fc:	6442                	ld	s0,16(sp)
    800065fe:	64a2                	ld	s1,8(sp)
    80006600:	6902                	ld	s2,0(sp)
    80006602:	6105                	addi	sp,sp,32
    80006604:	8082                	ret
      panic("virtio_disk_intr status");
    80006606:	00002517          	auipc	a0,0x2
    8000660a:	20a50513          	addi	a0,a0,522 # 80008810 <syscalls+0x3d8>
    8000660e:	ffffa097          	auipc	ra,0xffffa
    80006612:	f22080e7          	jalr	-222(ra) # 80000530 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051573          	csrrw	a0,sscratch,a0
    80007004:	02153423          	sd	ra,40(a0)
    80007008:	02253823          	sd	sp,48(a0)
    8000700c:	02353c23          	sd	gp,56(a0)
    80007010:	04453023          	sd	tp,64(a0)
    80007014:	04553423          	sd	t0,72(a0)
    80007018:	04653823          	sd	t1,80(a0)
    8000701c:	04753c23          	sd	t2,88(a0)
    80007020:	f120                	sd	s0,96(a0)
    80007022:	f524                	sd	s1,104(a0)
    80007024:	fd2c                	sd	a1,120(a0)
    80007026:	e150                	sd	a2,128(a0)
    80007028:	e554                	sd	a3,136(a0)
    8000702a:	e958                	sd	a4,144(a0)
    8000702c:	ed5c                	sd	a5,152(a0)
    8000702e:	0b053023          	sd	a6,160(a0)
    80007032:	0b153423          	sd	a7,168(a0)
    80007036:	0b253823          	sd	s2,176(a0)
    8000703a:	0b353c23          	sd	s3,184(a0)
    8000703e:	0d453023          	sd	s4,192(a0)
    80007042:	0d553423          	sd	s5,200(a0)
    80007046:	0d653823          	sd	s6,208(a0)
    8000704a:	0d753c23          	sd	s7,216(a0)
    8000704e:	0f853023          	sd	s8,224(a0)
    80007052:	0f953423          	sd	s9,232(a0)
    80007056:	0fa53823          	sd	s10,240(a0)
    8000705a:	0fb53c23          	sd	s11,248(a0)
    8000705e:	11c53023          	sd	t3,256(a0)
    80007062:	11d53423          	sd	t4,264(a0)
    80007066:	11e53823          	sd	t5,272(a0)
    8000706a:	11f53c23          	sd	t6,280(a0)
    8000706e:	140022f3          	csrr	t0,sscratch
    80007072:	06553823          	sd	t0,112(a0)
    80007076:	00853103          	ld	sp,8(a0)
    8000707a:	02053203          	ld	tp,32(a0)
    8000707e:	01053283          	ld	t0,16(a0)
    80007082:	00053303          	ld	t1,0(a0)
    80007086:	18031073          	csrw	satp,t1
    8000708a:	12000073          	sfence.vma
    8000708e:	8282                	jr	t0

0000000080007090 <userret>:
    80007090:	18059073          	csrw	satp,a1
    80007094:	12000073          	sfence.vma
    80007098:	07053283          	ld	t0,112(a0)
    8000709c:	14029073          	csrw	sscratch,t0
    800070a0:	02853083          	ld	ra,40(a0)
    800070a4:	03053103          	ld	sp,48(a0)
    800070a8:	03853183          	ld	gp,56(a0)
    800070ac:	04053203          	ld	tp,64(a0)
    800070b0:	04853283          	ld	t0,72(a0)
    800070b4:	05053303          	ld	t1,80(a0)
    800070b8:	05853383          	ld	t2,88(a0)
    800070bc:	7120                	ld	s0,96(a0)
    800070be:	7524                	ld	s1,104(a0)
    800070c0:	7d2c                	ld	a1,120(a0)
    800070c2:	6150                	ld	a2,128(a0)
    800070c4:	6554                	ld	a3,136(a0)
    800070c6:	6958                	ld	a4,144(a0)
    800070c8:	6d5c                	ld	a5,152(a0)
    800070ca:	0a053803          	ld	a6,160(a0)
    800070ce:	0a853883          	ld	a7,168(a0)
    800070d2:	0b053903          	ld	s2,176(a0)
    800070d6:	0b853983          	ld	s3,184(a0)
    800070da:	0c053a03          	ld	s4,192(a0)
    800070de:	0c853a83          	ld	s5,200(a0)
    800070e2:	0d053b03          	ld	s6,208(a0)
    800070e6:	0d853b83          	ld	s7,216(a0)
    800070ea:	0e053c03          	ld	s8,224(a0)
    800070ee:	0e853c83          	ld	s9,232(a0)
    800070f2:	0f053d03          	ld	s10,240(a0)
    800070f6:	0f853d83          	ld	s11,248(a0)
    800070fa:	10053e03          	ld	t3,256(a0)
    800070fe:	10853e83          	ld	t4,264(a0)
    80007102:	11053f03          	ld	t5,272(a0)
    80007106:	11853f83          	ld	t6,280(a0)
    8000710a:	14051573          	csrrw	a0,sscratch,a0
    8000710e:	10200073          	sret
	...
