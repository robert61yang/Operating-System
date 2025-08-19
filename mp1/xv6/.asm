
user/_mp1-part3-2:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <func1>:
	thread_yield();
	// 6-3
	thread_exit();
}

void func1(void *arg){
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
	// 1-2
	thread_yield();
   8:	00001097          	auipc	ra,0x1
   c:	d0a080e7          	jalr	-758(ra) # d12 <thread_yield>
	// 2-2
	thread_yield();
  10:	00001097          	auipc	ra,0x1
  14:	d02080e7          	jalr	-766(ra) # d12 <thread_yield>
	// 3-2 (exit due to signal)
}
  18:	60a2                	ld	ra,8(sp)
  1a:	6402                	ld	s0,0(sp)
  1c:	0141                	addi	sp,sp,16
  1e:	8082                	ret

0000000000000020 <func3_sighand>:

void func3_sighand(int signo){
  20:	1141                	addi	sp,sp,-16
  22:	e406                	sd	ra,8(sp)
  24:	e022                	sd	s0,0(sp)
  26:	0800                	addi	s0,sp,16
	// 2-3
	char offset[64];
	void *bp;
	offset[0] = '\0';
	__asm__("mv %0, s0" : "=r" (bp));
  28:	85a2                	mv	a1,s0
    printf("The w_thread signal handler's base pointer: %p\n", bp);	
  2a:	00001517          	auipc	a0,0x1
  2e:	dde50513          	addi	a0,a0,-546 # e08 <thread_resume+0x10>
  32:	00001097          	auipc	ra,0x1
  36:	818080e7          	jalr	-2024(ra) # 84a <printf>
	thread_yield();
  3a:	00001097          	auipc	ra,0x1
  3e:	cd8080e7          	jalr	-808(ra) # d12 <thread_yield>
	// 3-3
	thread_yield();
  42:	00001097          	auipc	ra,0x1
  46:	cd0080e7          	jalr	-816(ra) # d12 <thread_yield>
	// 4-2
	thread_yield();
  4a:	00001097          	auipc	ra,0x1
  4e:	cc8080e7          	jalr	-824(ra) # d12 <thread_yield>
	// 5-2
	thread_yield();
  52:	00001097          	auipc	ra,0x1
  56:	cc0080e7          	jalr	-832(ra) # d12 <thread_yield>
	// 6-2
	// It is expected that you'll get an error here
}
  5a:	60a2                	ld	ra,8(sp)
  5c:	6402                	ld	s0,0(sp)
  5e:	0141                	addi	sp,sp,16
  60:	8082                	ret

0000000000000062 <func3>:

void func3(void *arg){
  62:	1141                	addi	sp,sp,-16
  64:	e406                	sd	ra,8(sp)
  66:	e022                	sd	s0,0(sp)
  68:	0800                	addi	s0,sp,16
	// 1-3
	thread_register_handler(0, func3_sighand);
  6a:	00000597          	auipc	a1,0x0
  6e:	fb658593          	addi	a1,a1,-74 # 20 <func3_sighand>
  72:	4501                	li	a0,0
  74:	00001097          	auipc	ra,0x1
  78:	d2c080e7          	jalr	-724(ra) # da0 <thread_register_handler>
	thread_yield();
  7c:	00001097          	auipc	ra,0x1
  80:	c96080e7          	jalr	-874(ra) # d12 <thread_yield>

	// 6-2 (return from signal)
	printf("I'm still alive\n");
  84:	00001517          	auipc	a0,0x1
  88:	db450513          	addi	a0,a0,-588 # e38 <thread_resume+0x40>
  8c:	00000097          	auipc	ra,0x0
  90:	7be080e7          	jalr	1982(ra) # 84a <printf>
	thread_exit();
  94:	00001097          	auipc	ra,0x1
  98:	ad6080e7          	jalr	-1322(ra) # b6a <thread_exit>

	return;
}
  9c:	60a2                	ld	ra,8(sp)
  9e:	6402                	ld	s0,0(sp)
  a0:	0141                	addi	sp,sp,16
  a2:	8082                	ret

00000000000000a4 <manager_func>:

void manager_func(void *arg){
  a4:	1101                	addi	sp,sp,-32
  a6:	ec06                	sd	ra,24(sp)
  a8:	e822                	sd	s0,16(sp)
  aa:	e426                	sd	s1,8(sp)
  ac:	e04a                	sd	s2,0(sp)
  ae:	1000                	addi	s0,sp,32
	struct thread *t_thread, *w_thread;
	
	// setup
	w_thread = thread_create(func3, NULL);
  b0:	4581                	li	a1,0
  b2:	00000517          	auipc	a0,0x0
  b6:	fb050513          	addi	a0,a0,-80 # 62 <func3>
  ba:	00001097          	auipc	ra,0x1
  be:	9bc080e7          	jalr	-1604(ra) # a76 <thread_create>
  c2:	892a                	mv	s2,a0
	t_thread = thread_create(func1, NULL);	
  c4:	4581                	li	a1,0
  c6:	00000517          	auipc	a0,0x0
  ca:	f3a50513          	addi	a0,a0,-198 # 0 <func1>
  ce:	00001097          	auipc	ra,0x1
  d2:	9a8080e7          	jalr	-1624(ra) # a76 <thread_create>
  d6:	84aa                	mv	s1,a0
	printf("1st t_thead stack: %p\n", t_thread->stack);
  d8:	690c                	ld	a1,16(a0)
  da:	00001517          	auipc	a0,0x1
  de:	d7650513          	addi	a0,a0,-650 # e50 <thread_resume+0x58>
  e2:	00000097          	auipc	ra,0x0
  e6:	768080e7          	jalr	1896(ra) # 84a <printf>

	// 1-1
	thread_add_runqueue(t_thread);
  ea:	8526                	mv	a0,s1
  ec:	00001097          	auipc	ra,0x1
  f0:	a18080e7          	jalr	-1512(ra) # b04 <thread_add_runqueue>
	thread_add_runqueue(w_thread);	
  f4:	854a                	mv	a0,s2
  f6:	00001097          	auipc	ra,0x1
  fa:	a0e080e7          	jalr	-1522(ra) # b04 <thread_add_runqueue>
	thread_yield();
  fe:	00001097          	auipc	ra,0x1
 102:	c14080e7          	jalr	-1004(ra) # d12 <thread_yield>
	// 2-1
	thread_kill(w_thread, 0);
 106:	4581                	li	a1,0
 108:	854a                	mv	a0,s2
 10a:	00001097          	auipc	ra,0x1
 10e:	cb2080e7          	jalr	-846(ra) # dbc <thread_kill>
	thread_yield();
 112:	00001097          	auipc	ra,0x1
 116:	c00080e7          	jalr	-1024(ra) # d12 <thread_yield>
	// 3-1
	thread_kill(t_thread, 0);
 11a:	4581                	li	a1,0
 11c:	8526                	mv	a0,s1
 11e:	00001097          	auipc	ra,0x1
 122:	c9e080e7          	jalr	-866(ra) # dbc <thread_kill>
	thread_yield();
 126:	00001097          	auipc	ra,0x1
 12a:	bec080e7          	jalr	-1044(ra) # d12 <thread_yield>
	// 4-1
	t_thread = thread_create(func2, NULL);
 12e:	4581                	li	a1,0
 130:	00000517          	auipc	a0,0x0
 134:	09250513          	addi	a0,a0,146 # 1c2 <func2>
 138:	00001097          	auipc	ra,0x1
 13c:	93e080e7          	jalr	-1730(ra) # a76 <thread_create>
 140:	84aa                	mv	s1,a0
	printf("2nd t_thread stack: %p\n", t_thread->stack);
 142:	690c                	ld	a1,16(a0)
 144:	00001517          	auipc	a0,0x1
 148:	d2450513          	addi	a0,a0,-732 # e68 <thread_resume+0x70>
 14c:	00000097          	auipc	ra,0x0
 150:	6fe080e7          	jalr	1790(ra) # 84a <printf>
	thread_add_runqueue(t_thread);
 154:	8526                	mv	a0,s1
 156:	00001097          	auipc	ra,0x1
 15a:	9ae080e7          	jalr	-1618(ra) # b04 <thread_add_runqueue>
	thread_yield();
 15e:	00001097          	auipc	ra,0x1
 162:	bb4080e7          	jalr	-1100(ra) # d12 <thread_yield>
	// 5-1
	thread_yield();
 166:	00001097          	auipc	ra,0x1
 16a:	bac080e7          	jalr	-1108(ra) # d12 <thread_yield>
	// 6-1
	thread_yield();
 16e:	00001097          	auipc	ra,0x1
 172:	ba4080e7          	jalr	-1116(ra) # d12 <thread_yield>
	// End
	thread_exit();
 176:	00001097          	auipc	ra,0x1
 17a:	9f4080e7          	jalr	-1548(ra) # b6a <thread_exit>
}
 17e:	60e2                	ld	ra,24(sp)
 180:	6442                	ld	s0,16(sp)
 182:	64a2                	ld	s1,8(sp)
 184:	6902                	ld	s2,0(sp)
 186:	6105                	addi	sp,sp,32
 188:	8082                	ret

000000000000018a <corrupt>:
void corrupt(int layer){
 18a:	1141                	addi	sp,sp,-16
 18c:	e406                	sd	ra,8(sp)
 18e:	e022                	sd	s0,0(sp)
 190:	0800                	addi	s0,sp,16
	if (layer == 0){
 192:	c911                	beqz	a0,1a6 <corrupt+0x1c>
	corrupt(layer - 1);
 194:	357d                	addiw	a0,a0,-1
 196:	00000097          	auipc	ra,0x0
 19a:	ff4080e7          	jalr	-12(ra) # 18a <corrupt>
}
 19e:	60a2                	ld	ra,8(sp)
 1a0:	6402                	ld	s0,0(sp)
 1a2:	0141                	addi	sp,sp,16
 1a4:	8082                	ret
		__asm__("mv %0, s0" : "=r" (bp_after_corrupt));
 1a6:	85a2                	mv	a1,s0
 1a8:	00001797          	auipc	a5,0x1
 1ac:	d4b7b823          	sd	a1,-688(a5) # ef8 <bp_after_corrupt>
   		printf(" <-> %p is used by corrupt function \n", bp_after_corrupt);
 1b0:	00001517          	auipc	a0,0x1
 1b4:	cd050513          	addi	a0,a0,-816 # e80 <thread_resume+0x88>
 1b8:	00000097          	auipc	ra,0x0
 1bc:	692080e7          	jalr	1682(ra) # 84a <printf>
		return;
 1c0:	bff9                	j	19e <corrupt+0x14>

00000000000001c2 <func2>:
void func2(void *arg){
 1c2:	1141                	addi	sp,sp,-16
 1c4:	e406                	sd	ra,8(sp)
 1c6:	e022                	sd	s0,0(sp)
 1c8:	0800                	addi	s0,sp,16
	thread_yield();
 1ca:	00001097          	auipc	ra,0x1
 1ce:	b48080e7          	jalr	-1208(ra) # d12 <thread_yield>
	__asm__("mv %0, sp" : "=r" (f2sp));
 1d2:	858a                	mv	a1,sp
    printf("The memory %p", f2sp);	
 1d4:	00001517          	auipc	a0,0x1
 1d8:	cd450513          	addi	a0,a0,-812 # ea8 <thread_resume+0xb0>
 1dc:	00000097          	auipc	ra,0x0
 1e0:	66e080e7          	jalr	1646(ra) # 84a <printf>
	corrupt(100);
 1e4:	06400513          	li	a0,100
 1e8:	00000097          	auipc	ra,0x0
 1ec:	fa2080e7          	jalr	-94(ra) # 18a <corrupt>
	thread_yield();
 1f0:	00001097          	auipc	ra,0x1
 1f4:	b22080e7          	jalr	-1246(ra) # d12 <thread_yield>
	thread_exit();
 1f8:	00001097          	auipc	ra,0x1
 1fc:	972080e7          	jalr	-1678(ra) # b6a <thread_exit>
}
 200:	60a2                	ld	ra,8(sp)
 202:	6402                	ld	s0,0(sp)
 204:	0141                	addi	sp,sp,16
 206:	8082                	ret

0000000000000208 <main>:

int main(int argc, char** argv){
 208:	1141                	addi	sp,sp,-16
 20a:	e406                	sd	ra,8(sp)
 20c:	e022                	sd	s0,0(sp)
 20e:	0800                	addi	s0,sp,16
	printf("mp1-part3-2\n");
 210:	00001517          	auipc	a0,0x1
 214:	ca850513          	addi	a0,a0,-856 # eb8 <thread_resume+0xc0>
 218:	00000097          	auipc	ra,0x0
 21c:	632080e7          	jalr	1586(ra) # 84a <printf>
	struct thread *manager;
	manager = thread_create(manager_func, NULL);
 220:	4581                	li	a1,0
 222:	00000517          	auipc	a0,0x0
 226:	e8250513          	addi	a0,a0,-382 # a4 <manager_func>
 22a:	00001097          	auipc	ra,0x1
 22e:	84c080e7          	jalr	-1972(ra) # a76 <thread_create>
	thread_add_runqueue(manager);
 232:	00001097          	auipc	ra,0x1
 236:	8d2080e7          	jalr	-1838(ra) # b04 <thread_add_runqueue>
	thread_start_threading();
 23a:	00001097          	auipc	ra,0x1
 23e:	b3a080e7          	jalr	-1222(ra) # d74 <thread_start_threading>
	printf("\nexited\n");
 242:	00001517          	auipc	a0,0x1
 246:	c8650513          	addi	a0,a0,-890 # ec8 <thread_resume+0xd0>
 24a:	00000097          	auipc	ra,0x0
 24e:	600080e7          	jalr	1536(ra) # 84a <printf>
	exit(0);
 252:	4501                	li	a0,0
 254:	00000097          	auipc	ra,0x0
 258:	27e080e7          	jalr	638(ra) # 4d2 <exit>

000000000000025c <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 25c:	1141                	addi	sp,sp,-16
 25e:	e422                	sd	s0,8(sp)
 260:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 262:	87aa                	mv	a5,a0
 264:	0585                	addi	a1,a1,1
 266:	0785                	addi	a5,a5,1
 268:	fff5c703          	lbu	a4,-1(a1)
 26c:	fee78fa3          	sb	a4,-1(a5)
 270:	fb75                	bnez	a4,264 <strcpy+0x8>
    ;
  return os;
}
 272:	6422                	ld	s0,8(sp)
 274:	0141                	addi	sp,sp,16
 276:	8082                	ret

0000000000000278 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 278:	1141                	addi	sp,sp,-16
 27a:	e422                	sd	s0,8(sp)
 27c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 27e:	00054783          	lbu	a5,0(a0)
 282:	cb91                	beqz	a5,296 <strcmp+0x1e>
 284:	0005c703          	lbu	a4,0(a1)
 288:	00f71763          	bne	a4,a5,296 <strcmp+0x1e>
    p++, q++;
 28c:	0505                	addi	a0,a0,1
 28e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 290:	00054783          	lbu	a5,0(a0)
 294:	fbe5                	bnez	a5,284 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 296:	0005c503          	lbu	a0,0(a1)
}
 29a:	40a7853b          	subw	a0,a5,a0
 29e:	6422                	ld	s0,8(sp)
 2a0:	0141                	addi	sp,sp,16
 2a2:	8082                	ret

00000000000002a4 <strlen>:

uint
strlen(const char *s)
{
 2a4:	1141                	addi	sp,sp,-16
 2a6:	e422                	sd	s0,8(sp)
 2a8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2aa:	00054783          	lbu	a5,0(a0)
 2ae:	cf91                	beqz	a5,2ca <strlen+0x26>
 2b0:	0505                	addi	a0,a0,1
 2b2:	87aa                	mv	a5,a0
 2b4:	4685                	li	a3,1
 2b6:	9e89                	subw	a3,a3,a0
 2b8:	00f6853b          	addw	a0,a3,a5
 2bc:	0785                	addi	a5,a5,1
 2be:	fff7c703          	lbu	a4,-1(a5)
 2c2:	fb7d                	bnez	a4,2b8 <strlen+0x14>
    ;
  return n;
}
 2c4:	6422                	ld	s0,8(sp)
 2c6:	0141                	addi	sp,sp,16
 2c8:	8082                	ret
  for(n = 0; s[n]; n++)
 2ca:	4501                	li	a0,0
 2cc:	bfe5                	j	2c4 <strlen+0x20>

00000000000002ce <memset>:

void*
memset(void *dst, int c, uint n)
{
 2ce:	1141                	addi	sp,sp,-16
 2d0:	e422                	sd	s0,8(sp)
 2d2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2d4:	ce09                	beqz	a2,2ee <memset+0x20>
 2d6:	87aa                	mv	a5,a0
 2d8:	fff6071b          	addiw	a4,a2,-1
 2dc:	1702                	slli	a4,a4,0x20
 2de:	9301                	srli	a4,a4,0x20
 2e0:	0705                	addi	a4,a4,1
 2e2:	972a                	add	a4,a4,a0
    cdst[i] = c;
 2e4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 2e8:	0785                	addi	a5,a5,1
 2ea:	fee79de3          	bne	a5,a4,2e4 <memset+0x16>
  }
  return dst;
}
 2ee:	6422                	ld	s0,8(sp)
 2f0:	0141                	addi	sp,sp,16
 2f2:	8082                	ret

00000000000002f4 <strchr>:

char*
strchr(const char *s, char c)
{
 2f4:	1141                	addi	sp,sp,-16
 2f6:	e422                	sd	s0,8(sp)
 2f8:	0800                	addi	s0,sp,16
  for(; *s; s++)
 2fa:	00054783          	lbu	a5,0(a0)
 2fe:	cb99                	beqz	a5,314 <strchr+0x20>
    if(*s == c)
 300:	00f58763          	beq	a1,a5,30e <strchr+0x1a>
  for(; *s; s++)
 304:	0505                	addi	a0,a0,1
 306:	00054783          	lbu	a5,0(a0)
 30a:	fbfd                	bnez	a5,300 <strchr+0xc>
      return (char*)s;
  return 0;
 30c:	4501                	li	a0,0
}
 30e:	6422                	ld	s0,8(sp)
 310:	0141                	addi	sp,sp,16
 312:	8082                	ret
  return 0;
 314:	4501                	li	a0,0
 316:	bfe5                	j	30e <strchr+0x1a>

0000000000000318 <gets>:

char*
gets(char *buf, int max)
{
 318:	711d                	addi	sp,sp,-96
 31a:	ec86                	sd	ra,88(sp)
 31c:	e8a2                	sd	s0,80(sp)
 31e:	e4a6                	sd	s1,72(sp)
 320:	e0ca                	sd	s2,64(sp)
 322:	fc4e                	sd	s3,56(sp)
 324:	f852                	sd	s4,48(sp)
 326:	f456                	sd	s5,40(sp)
 328:	f05a                	sd	s6,32(sp)
 32a:	ec5e                	sd	s7,24(sp)
 32c:	1080                	addi	s0,sp,96
 32e:	8baa                	mv	s7,a0
 330:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 332:	892a                	mv	s2,a0
 334:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 336:	4aa9                	li	s5,10
 338:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 33a:	89a6                	mv	s3,s1
 33c:	2485                	addiw	s1,s1,1
 33e:	0344d863          	bge	s1,s4,36e <gets+0x56>
    cc = read(0, &c, 1);
 342:	4605                	li	a2,1
 344:	faf40593          	addi	a1,s0,-81
 348:	4501                	li	a0,0
 34a:	00000097          	auipc	ra,0x0
 34e:	1a0080e7          	jalr	416(ra) # 4ea <read>
    if(cc < 1)
 352:	00a05e63          	blez	a0,36e <gets+0x56>
    buf[i++] = c;
 356:	faf44783          	lbu	a5,-81(s0)
 35a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 35e:	01578763          	beq	a5,s5,36c <gets+0x54>
 362:	0905                	addi	s2,s2,1
 364:	fd679be3          	bne	a5,s6,33a <gets+0x22>
  for(i=0; i+1 < max; ){
 368:	89a6                	mv	s3,s1
 36a:	a011                	j	36e <gets+0x56>
 36c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 36e:	99de                	add	s3,s3,s7
 370:	00098023          	sb	zero,0(s3)
  return buf;
}
 374:	855e                	mv	a0,s7
 376:	60e6                	ld	ra,88(sp)
 378:	6446                	ld	s0,80(sp)
 37a:	64a6                	ld	s1,72(sp)
 37c:	6906                	ld	s2,64(sp)
 37e:	79e2                	ld	s3,56(sp)
 380:	7a42                	ld	s4,48(sp)
 382:	7aa2                	ld	s5,40(sp)
 384:	7b02                	ld	s6,32(sp)
 386:	6be2                	ld	s7,24(sp)
 388:	6125                	addi	sp,sp,96
 38a:	8082                	ret

000000000000038c <stat>:

int
stat(const char *n, struct stat *st)
{
 38c:	1101                	addi	sp,sp,-32
 38e:	ec06                	sd	ra,24(sp)
 390:	e822                	sd	s0,16(sp)
 392:	e426                	sd	s1,8(sp)
 394:	e04a                	sd	s2,0(sp)
 396:	1000                	addi	s0,sp,32
 398:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 39a:	4581                	li	a1,0
 39c:	00000097          	auipc	ra,0x0
 3a0:	176080e7          	jalr	374(ra) # 512 <open>
  if(fd < 0)
 3a4:	02054563          	bltz	a0,3ce <stat+0x42>
 3a8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3aa:	85ca                	mv	a1,s2
 3ac:	00000097          	auipc	ra,0x0
 3b0:	17e080e7          	jalr	382(ra) # 52a <fstat>
 3b4:	892a                	mv	s2,a0
  close(fd);
 3b6:	8526                	mv	a0,s1
 3b8:	00000097          	auipc	ra,0x0
 3bc:	142080e7          	jalr	322(ra) # 4fa <close>
  return r;
}
 3c0:	854a                	mv	a0,s2
 3c2:	60e2                	ld	ra,24(sp)
 3c4:	6442                	ld	s0,16(sp)
 3c6:	64a2                	ld	s1,8(sp)
 3c8:	6902                	ld	s2,0(sp)
 3ca:	6105                	addi	sp,sp,32
 3cc:	8082                	ret
    return -1;
 3ce:	597d                	li	s2,-1
 3d0:	bfc5                	j	3c0 <stat+0x34>

00000000000003d2 <atoi>:

int
atoi(const char *s)
{
 3d2:	1141                	addi	sp,sp,-16
 3d4:	e422                	sd	s0,8(sp)
 3d6:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3d8:	00054603          	lbu	a2,0(a0)
 3dc:	fd06079b          	addiw	a5,a2,-48
 3e0:	0ff7f793          	andi	a5,a5,255
 3e4:	4725                	li	a4,9
 3e6:	02f76963          	bltu	a4,a5,418 <atoi+0x46>
 3ea:	86aa                	mv	a3,a0
  n = 0;
 3ec:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 3ee:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 3f0:	0685                	addi	a3,a3,1
 3f2:	0025179b          	slliw	a5,a0,0x2
 3f6:	9fa9                	addw	a5,a5,a0
 3f8:	0017979b          	slliw	a5,a5,0x1
 3fc:	9fb1                	addw	a5,a5,a2
 3fe:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 402:	0006c603          	lbu	a2,0(a3)
 406:	fd06071b          	addiw	a4,a2,-48
 40a:	0ff77713          	andi	a4,a4,255
 40e:	fee5f1e3          	bgeu	a1,a4,3f0 <atoi+0x1e>
  return n;
}
 412:	6422                	ld	s0,8(sp)
 414:	0141                	addi	sp,sp,16
 416:	8082                	ret
  n = 0;
 418:	4501                	li	a0,0
 41a:	bfe5                	j	412 <atoi+0x40>

000000000000041c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 41c:	1141                	addi	sp,sp,-16
 41e:	e422                	sd	s0,8(sp)
 420:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 422:	02b57663          	bgeu	a0,a1,44e <memmove+0x32>
    while(n-- > 0)
 426:	02c05163          	blez	a2,448 <memmove+0x2c>
 42a:	fff6079b          	addiw	a5,a2,-1
 42e:	1782                	slli	a5,a5,0x20
 430:	9381                	srli	a5,a5,0x20
 432:	0785                	addi	a5,a5,1
 434:	97aa                	add	a5,a5,a0
  dst = vdst;
 436:	872a                	mv	a4,a0
      *dst++ = *src++;
 438:	0585                	addi	a1,a1,1
 43a:	0705                	addi	a4,a4,1
 43c:	fff5c683          	lbu	a3,-1(a1)
 440:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 444:	fee79ae3          	bne	a5,a4,438 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 448:	6422                	ld	s0,8(sp)
 44a:	0141                	addi	sp,sp,16
 44c:	8082                	ret
    dst += n;
 44e:	00c50733          	add	a4,a0,a2
    src += n;
 452:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 454:	fec05ae3          	blez	a2,448 <memmove+0x2c>
 458:	fff6079b          	addiw	a5,a2,-1
 45c:	1782                	slli	a5,a5,0x20
 45e:	9381                	srli	a5,a5,0x20
 460:	fff7c793          	not	a5,a5
 464:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 466:	15fd                	addi	a1,a1,-1
 468:	177d                	addi	a4,a4,-1
 46a:	0005c683          	lbu	a3,0(a1)
 46e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 472:	fee79ae3          	bne	a5,a4,466 <memmove+0x4a>
 476:	bfc9                	j	448 <memmove+0x2c>

0000000000000478 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 478:	1141                	addi	sp,sp,-16
 47a:	e422                	sd	s0,8(sp)
 47c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 47e:	ca05                	beqz	a2,4ae <memcmp+0x36>
 480:	fff6069b          	addiw	a3,a2,-1
 484:	1682                	slli	a3,a3,0x20
 486:	9281                	srli	a3,a3,0x20
 488:	0685                	addi	a3,a3,1
 48a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 48c:	00054783          	lbu	a5,0(a0)
 490:	0005c703          	lbu	a4,0(a1)
 494:	00e79863          	bne	a5,a4,4a4 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 498:	0505                	addi	a0,a0,1
    p2++;
 49a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 49c:	fed518e3          	bne	a0,a3,48c <memcmp+0x14>
  }
  return 0;
 4a0:	4501                	li	a0,0
 4a2:	a019                	j	4a8 <memcmp+0x30>
      return *p1 - *p2;
 4a4:	40e7853b          	subw	a0,a5,a4
}
 4a8:	6422                	ld	s0,8(sp)
 4aa:	0141                	addi	sp,sp,16
 4ac:	8082                	ret
  return 0;
 4ae:	4501                	li	a0,0
 4b0:	bfe5                	j	4a8 <memcmp+0x30>

00000000000004b2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4b2:	1141                	addi	sp,sp,-16
 4b4:	e406                	sd	ra,8(sp)
 4b6:	e022                	sd	s0,0(sp)
 4b8:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4ba:	00000097          	auipc	ra,0x0
 4be:	f62080e7          	jalr	-158(ra) # 41c <memmove>
}
 4c2:	60a2                	ld	ra,8(sp)
 4c4:	6402                	ld	s0,0(sp)
 4c6:	0141                	addi	sp,sp,16
 4c8:	8082                	ret

00000000000004ca <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4ca:	4885                	li	a7,1
 ecall
 4cc:	00000073          	ecall
 ret
 4d0:	8082                	ret

00000000000004d2 <exit>:
.global exit
exit:
 li a7, SYS_exit
 4d2:	4889                	li	a7,2
 ecall
 4d4:	00000073          	ecall
 ret
 4d8:	8082                	ret

00000000000004da <wait>:
.global wait
wait:
 li a7, SYS_wait
 4da:	488d                	li	a7,3
 ecall
 4dc:	00000073          	ecall
 ret
 4e0:	8082                	ret

00000000000004e2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4e2:	4891                	li	a7,4
 ecall
 4e4:	00000073          	ecall
 ret
 4e8:	8082                	ret

00000000000004ea <read>:
.global read
read:
 li a7, SYS_read
 4ea:	4895                	li	a7,5
 ecall
 4ec:	00000073          	ecall
 ret
 4f0:	8082                	ret

00000000000004f2 <write>:
.global write
write:
 li a7, SYS_write
 4f2:	48c1                	li	a7,16
 ecall
 4f4:	00000073          	ecall
 ret
 4f8:	8082                	ret

00000000000004fa <close>:
.global close
close:
 li a7, SYS_close
 4fa:	48d5                	li	a7,21
 ecall
 4fc:	00000073          	ecall
 ret
 500:	8082                	ret

0000000000000502 <kill>:
.global kill
kill:
 li a7, SYS_kill
 502:	4899                	li	a7,6
 ecall
 504:	00000073          	ecall
 ret
 508:	8082                	ret

000000000000050a <exec>:
.global exec
exec:
 li a7, SYS_exec
 50a:	489d                	li	a7,7
 ecall
 50c:	00000073          	ecall
 ret
 510:	8082                	ret

0000000000000512 <open>:
.global open
open:
 li a7, SYS_open
 512:	48bd                	li	a7,15
 ecall
 514:	00000073          	ecall
 ret
 518:	8082                	ret

000000000000051a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 51a:	48c5                	li	a7,17
 ecall
 51c:	00000073          	ecall
 ret
 520:	8082                	ret

0000000000000522 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 522:	48c9                	li	a7,18
 ecall
 524:	00000073          	ecall
 ret
 528:	8082                	ret

000000000000052a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 52a:	48a1                	li	a7,8
 ecall
 52c:	00000073          	ecall
 ret
 530:	8082                	ret

0000000000000532 <link>:
.global link
link:
 li a7, SYS_link
 532:	48cd                	li	a7,19
 ecall
 534:	00000073          	ecall
 ret
 538:	8082                	ret

000000000000053a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 53a:	48d1                	li	a7,20
 ecall
 53c:	00000073          	ecall
 ret
 540:	8082                	ret

0000000000000542 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 542:	48a5                	li	a7,9
 ecall
 544:	00000073          	ecall
 ret
 548:	8082                	ret

000000000000054a <dup>:
.global dup
dup:
 li a7, SYS_dup
 54a:	48a9                	li	a7,10
 ecall
 54c:	00000073          	ecall
 ret
 550:	8082                	ret

0000000000000552 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 552:	48ad                	li	a7,11
 ecall
 554:	00000073          	ecall
 ret
 558:	8082                	ret

000000000000055a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 55a:	48b1                	li	a7,12
 ecall
 55c:	00000073          	ecall
 ret
 560:	8082                	ret

0000000000000562 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 562:	48b5                	li	a7,13
 ecall
 564:	00000073          	ecall
 ret
 568:	8082                	ret

000000000000056a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 56a:	48b9                	li	a7,14
 ecall
 56c:	00000073          	ecall
 ret
 570:	8082                	ret

0000000000000572 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 572:	1101                	addi	sp,sp,-32
 574:	ec06                	sd	ra,24(sp)
 576:	e822                	sd	s0,16(sp)
 578:	1000                	addi	s0,sp,32
 57a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 57e:	4605                	li	a2,1
 580:	fef40593          	addi	a1,s0,-17
 584:	00000097          	auipc	ra,0x0
 588:	f6e080e7          	jalr	-146(ra) # 4f2 <write>
}
 58c:	60e2                	ld	ra,24(sp)
 58e:	6442                	ld	s0,16(sp)
 590:	6105                	addi	sp,sp,32
 592:	8082                	ret

0000000000000594 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 594:	7139                	addi	sp,sp,-64
 596:	fc06                	sd	ra,56(sp)
 598:	f822                	sd	s0,48(sp)
 59a:	f426                	sd	s1,40(sp)
 59c:	f04a                	sd	s2,32(sp)
 59e:	ec4e                	sd	s3,24(sp)
 5a0:	0080                	addi	s0,sp,64
 5a2:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5a4:	c299                	beqz	a3,5aa <printint+0x16>
 5a6:	0805c863          	bltz	a1,636 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5aa:	2581                	sext.w	a1,a1
  neg = 0;
 5ac:	4881                	li	a7,0
 5ae:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 5b2:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5b4:	2601                	sext.w	a2,a2
 5b6:	00001517          	auipc	a0,0x1
 5ba:	92a50513          	addi	a0,a0,-1750 # ee0 <digits>
 5be:	883a                	mv	a6,a4
 5c0:	2705                	addiw	a4,a4,1
 5c2:	02c5f7bb          	remuw	a5,a1,a2
 5c6:	1782                	slli	a5,a5,0x20
 5c8:	9381                	srli	a5,a5,0x20
 5ca:	97aa                	add	a5,a5,a0
 5cc:	0007c783          	lbu	a5,0(a5)
 5d0:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5d4:	0005879b          	sext.w	a5,a1
 5d8:	02c5d5bb          	divuw	a1,a1,a2
 5dc:	0685                	addi	a3,a3,1
 5de:	fec7f0e3          	bgeu	a5,a2,5be <printint+0x2a>
  if(neg)
 5e2:	00088b63          	beqz	a7,5f8 <printint+0x64>
    buf[i++] = '-';
 5e6:	fd040793          	addi	a5,s0,-48
 5ea:	973e                	add	a4,a4,a5
 5ec:	02d00793          	li	a5,45
 5f0:	fef70823          	sb	a5,-16(a4)
 5f4:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5f8:	02e05863          	blez	a4,628 <printint+0x94>
 5fc:	fc040793          	addi	a5,s0,-64
 600:	00e78933          	add	s2,a5,a4
 604:	fff78993          	addi	s3,a5,-1
 608:	99ba                	add	s3,s3,a4
 60a:	377d                	addiw	a4,a4,-1
 60c:	1702                	slli	a4,a4,0x20
 60e:	9301                	srli	a4,a4,0x20
 610:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 614:	fff94583          	lbu	a1,-1(s2)
 618:	8526                	mv	a0,s1
 61a:	00000097          	auipc	ra,0x0
 61e:	f58080e7          	jalr	-168(ra) # 572 <putc>
  while(--i >= 0)
 622:	197d                	addi	s2,s2,-1
 624:	ff3918e3          	bne	s2,s3,614 <printint+0x80>
}
 628:	70e2                	ld	ra,56(sp)
 62a:	7442                	ld	s0,48(sp)
 62c:	74a2                	ld	s1,40(sp)
 62e:	7902                	ld	s2,32(sp)
 630:	69e2                	ld	s3,24(sp)
 632:	6121                	addi	sp,sp,64
 634:	8082                	ret
    x = -xx;
 636:	40b005bb          	negw	a1,a1
    neg = 1;
 63a:	4885                	li	a7,1
    x = -xx;
 63c:	bf8d                	j	5ae <printint+0x1a>

000000000000063e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 63e:	7119                	addi	sp,sp,-128
 640:	fc86                	sd	ra,120(sp)
 642:	f8a2                	sd	s0,112(sp)
 644:	f4a6                	sd	s1,104(sp)
 646:	f0ca                	sd	s2,96(sp)
 648:	ecce                	sd	s3,88(sp)
 64a:	e8d2                	sd	s4,80(sp)
 64c:	e4d6                	sd	s5,72(sp)
 64e:	e0da                	sd	s6,64(sp)
 650:	fc5e                	sd	s7,56(sp)
 652:	f862                	sd	s8,48(sp)
 654:	f466                	sd	s9,40(sp)
 656:	f06a                	sd	s10,32(sp)
 658:	ec6e                	sd	s11,24(sp)
 65a:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 65c:	0005c903          	lbu	s2,0(a1)
 660:	18090f63          	beqz	s2,7fe <vprintf+0x1c0>
 664:	8aaa                	mv	s5,a0
 666:	8b32                	mv	s6,a2
 668:	00158493          	addi	s1,a1,1
  state = 0;
 66c:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 66e:	02500a13          	li	s4,37
      if(c == 'd'){
 672:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 676:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 67a:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 67e:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 682:	00001b97          	auipc	s7,0x1
 686:	85eb8b93          	addi	s7,s7,-1954 # ee0 <digits>
 68a:	a839                	j	6a8 <vprintf+0x6a>
        putc(fd, c);
 68c:	85ca                	mv	a1,s2
 68e:	8556                	mv	a0,s5
 690:	00000097          	auipc	ra,0x0
 694:	ee2080e7          	jalr	-286(ra) # 572 <putc>
 698:	a019                	j	69e <vprintf+0x60>
    } else if(state == '%'){
 69a:	01498f63          	beq	s3,s4,6b8 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 69e:	0485                	addi	s1,s1,1
 6a0:	fff4c903          	lbu	s2,-1(s1)
 6a4:	14090d63          	beqz	s2,7fe <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 6a8:	0009079b          	sext.w	a5,s2
    if(state == 0){
 6ac:	fe0997e3          	bnez	s3,69a <vprintf+0x5c>
      if(c == '%'){
 6b0:	fd479ee3          	bne	a5,s4,68c <vprintf+0x4e>
        state = '%';
 6b4:	89be                	mv	s3,a5
 6b6:	b7e5                	j	69e <vprintf+0x60>
      if(c == 'd'){
 6b8:	05878063          	beq	a5,s8,6f8 <vprintf+0xba>
      } else if(c == 'l') {
 6bc:	05978c63          	beq	a5,s9,714 <vprintf+0xd6>
      } else if(c == 'x') {
 6c0:	07a78863          	beq	a5,s10,730 <vprintf+0xf2>
      } else if(c == 'p') {
 6c4:	09b78463          	beq	a5,s11,74c <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 6c8:	07300713          	li	a4,115
 6cc:	0ce78663          	beq	a5,a4,798 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6d0:	06300713          	li	a4,99
 6d4:	0ee78e63          	beq	a5,a4,7d0 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 6d8:	11478863          	beq	a5,s4,7e8 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6dc:	85d2                	mv	a1,s4
 6de:	8556                	mv	a0,s5
 6e0:	00000097          	auipc	ra,0x0
 6e4:	e92080e7          	jalr	-366(ra) # 572 <putc>
        putc(fd, c);
 6e8:	85ca                	mv	a1,s2
 6ea:	8556                	mv	a0,s5
 6ec:	00000097          	auipc	ra,0x0
 6f0:	e86080e7          	jalr	-378(ra) # 572 <putc>
      }
      state = 0;
 6f4:	4981                	li	s3,0
 6f6:	b765                	j	69e <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 6f8:	008b0913          	addi	s2,s6,8
 6fc:	4685                	li	a3,1
 6fe:	4629                	li	a2,10
 700:	000b2583          	lw	a1,0(s6)
 704:	8556                	mv	a0,s5
 706:	00000097          	auipc	ra,0x0
 70a:	e8e080e7          	jalr	-370(ra) # 594 <printint>
 70e:	8b4a                	mv	s6,s2
      state = 0;
 710:	4981                	li	s3,0
 712:	b771                	j	69e <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 714:	008b0913          	addi	s2,s6,8
 718:	4681                	li	a3,0
 71a:	4629                	li	a2,10
 71c:	000b2583          	lw	a1,0(s6)
 720:	8556                	mv	a0,s5
 722:	00000097          	auipc	ra,0x0
 726:	e72080e7          	jalr	-398(ra) # 594 <printint>
 72a:	8b4a                	mv	s6,s2
      state = 0;
 72c:	4981                	li	s3,0
 72e:	bf85                	j	69e <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 730:	008b0913          	addi	s2,s6,8
 734:	4681                	li	a3,0
 736:	4641                	li	a2,16
 738:	000b2583          	lw	a1,0(s6)
 73c:	8556                	mv	a0,s5
 73e:	00000097          	auipc	ra,0x0
 742:	e56080e7          	jalr	-426(ra) # 594 <printint>
 746:	8b4a                	mv	s6,s2
      state = 0;
 748:	4981                	li	s3,0
 74a:	bf91                	j	69e <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 74c:	008b0793          	addi	a5,s6,8
 750:	f8f43423          	sd	a5,-120(s0)
 754:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 758:	03000593          	li	a1,48
 75c:	8556                	mv	a0,s5
 75e:	00000097          	auipc	ra,0x0
 762:	e14080e7          	jalr	-492(ra) # 572 <putc>
  putc(fd, 'x');
 766:	85ea                	mv	a1,s10
 768:	8556                	mv	a0,s5
 76a:	00000097          	auipc	ra,0x0
 76e:	e08080e7          	jalr	-504(ra) # 572 <putc>
 772:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 774:	03c9d793          	srli	a5,s3,0x3c
 778:	97de                	add	a5,a5,s7
 77a:	0007c583          	lbu	a1,0(a5)
 77e:	8556                	mv	a0,s5
 780:	00000097          	auipc	ra,0x0
 784:	df2080e7          	jalr	-526(ra) # 572 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 788:	0992                	slli	s3,s3,0x4
 78a:	397d                	addiw	s2,s2,-1
 78c:	fe0914e3          	bnez	s2,774 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 790:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 794:	4981                	li	s3,0
 796:	b721                	j	69e <vprintf+0x60>
        s = va_arg(ap, char*);
 798:	008b0993          	addi	s3,s6,8
 79c:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 7a0:	02090163          	beqz	s2,7c2 <vprintf+0x184>
        while(*s != 0){
 7a4:	00094583          	lbu	a1,0(s2)
 7a8:	c9a1                	beqz	a1,7f8 <vprintf+0x1ba>
          putc(fd, *s);
 7aa:	8556                	mv	a0,s5
 7ac:	00000097          	auipc	ra,0x0
 7b0:	dc6080e7          	jalr	-570(ra) # 572 <putc>
          s++;
 7b4:	0905                	addi	s2,s2,1
        while(*s != 0){
 7b6:	00094583          	lbu	a1,0(s2)
 7ba:	f9e5                	bnez	a1,7aa <vprintf+0x16c>
        s = va_arg(ap, char*);
 7bc:	8b4e                	mv	s6,s3
      state = 0;
 7be:	4981                	li	s3,0
 7c0:	bdf9                	j	69e <vprintf+0x60>
          s = "(null)";
 7c2:	00000917          	auipc	s2,0x0
 7c6:	71690913          	addi	s2,s2,1814 # ed8 <thread_resume+0xe0>
        while(*s != 0){
 7ca:	02800593          	li	a1,40
 7ce:	bff1                	j	7aa <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 7d0:	008b0913          	addi	s2,s6,8
 7d4:	000b4583          	lbu	a1,0(s6)
 7d8:	8556                	mv	a0,s5
 7da:	00000097          	auipc	ra,0x0
 7de:	d98080e7          	jalr	-616(ra) # 572 <putc>
 7e2:	8b4a                	mv	s6,s2
      state = 0;
 7e4:	4981                	li	s3,0
 7e6:	bd65                	j	69e <vprintf+0x60>
        putc(fd, c);
 7e8:	85d2                	mv	a1,s4
 7ea:	8556                	mv	a0,s5
 7ec:	00000097          	auipc	ra,0x0
 7f0:	d86080e7          	jalr	-634(ra) # 572 <putc>
      state = 0;
 7f4:	4981                	li	s3,0
 7f6:	b565                	j	69e <vprintf+0x60>
        s = va_arg(ap, char*);
 7f8:	8b4e                	mv	s6,s3
      state = 0;
 7fa:	4981                	li	s3,0
 7fc:	b54d                	j	69e <vprintf+0x60>
    }
  }
}
 7fe:	70e6                	ld	ra,120(sp)
 800:	7446                	ld	s0,112(sp)
 802:	74a6                	ld	s1,104(sp)
 804:	7906                	ld	s2,96(sp)
 806:	69e6                	ld	s3,88(sp)
 808:	6a46                	ld	s4,80(sp)
 80a:	6aa6                	ld	s5,72(sp)
 80c:	6b06                	ld	s6,64(sp)
 80e:	7be2                	ld	s7,56(sp)
 810:	7c42                	ld	s8,48(sp)
 812:	7ca2                	ld	s9,40(sp)
 814:	7d02                	ld	s10,32(sp)
 816:	6de2                	ld	s11,24(sp)
 818:	6109                	addi	sp,sp,128
 81a:	8082                	ret

000000000000081c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 81c:	715d                	addi	sp,sp,-80
 81e:	ec06                	sd	ra,24(sp)
 820:	e822                	sd	s0,16(sp)
 822:	1000                	addi	s0,sp,32
 824:	e010                	sd	a2,0(s0)
 826:	e414                	sd	a3,8(s0)
 828:	e818                	sd	a4,16(s0)
 82a:	ec1c                	sd	a5,24(s0)
 82c:	03043023          	sd	a6,32(s0)
 830:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 834:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 838:	8622                	mv	a2,s0
 83a:	00000097          	auipc	ra,0x0
 83e:	e04080e7          	jalr	-508(ra) # 63e <vprintf>
}
 842:	60e2                	ld	ra,24(sp)
 844:	6442                	ld	s0,16(sp)
 846:	6161                	addi	sp,sp,80
 848:	8082                	ret

000000000000084a <printf>:

void
printf(const char *fmt, ...)
{
 84a:	711d                	addi	sp,sp,-96
 84c:	ec06                	sd	ra,24(sp)
 84e:	e822                	sd	s0,16(sp)
 850:	1000                	addi	s0,sp,32
 852:	e40c                	sd	a1,8(s0)
 854:	e810                	sd	a2,16(s0)
 856:	ec14                	sd	a3,24(s0)
 858:	f018                	sd	a4,32(s0)
 85a:	f41c                	sd	a5,40(s0)
 85c:	03043823          	sd	a6,48(s0)
 860:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 864:	00840613          	addi	a2,s0,8
 868:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 86c:	85aa                	mv	a1,a0
 86e:	4505                	li	a0,1
 870:	00000097          	auipc	ra,0x0
 874:	dce080e7          	jalr	-562(ra) # 63e <vprintf>
}
 878:	60e2                	ld	ra,24(sp)
 87a:	6442                	ld	s0,16(sp)
 87c:	6125                	addi	sp,sp,96
 87e:	8082                	ret

0000000000000880 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 880:	1141                	addi	sp,sp,-16
 882:	e422                	sd	s0,8(sp)
 884:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 886:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 88a:	00000797          	auipc	a5,0x0
 88e:	6767b783          	ld	a5,1654(a5) # f00 <freep>
 892:	a805                	j	8c2 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 894:	4618                	lw	a4,8(a2)
 896:	9db9                	addw	a1,a1,a4
 898:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 89c:	6398                	ld	a4,0(a5)
 89e:	6318                	ld	a4,0(a4)
 8a0:	fee53823          	sd	a4,-16(a0)
 8a4:	a091                	j	8e8 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8a6:	ff852703          	lw	a4,-8(a0)
 8aa:	9e39                	addw	a2,a2,a4
 8ac:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 8ae:	ff053703          	ld	a4,-16(a0)
 8b2:	e398                	sd	a4,0(a5)
 8b4:	a099                	j	8fa <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8b6:	6398                	ld	a4,0(a5)
 8b8:	00e7e463          	bltu	a5,a4,8c0 <free+0x40>
 8bc:	00e6ea63          	bltu	a3,a4,8d0 <free+0x50>
{
 8c0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8c2:	fed7fae3          	bgeu	a5,a3,8b6 <free+0x36>
 8c6:	6398                	ld	a4,0(a5)
 8c8:	00e6e463          	bltu	a3,a4,8d0 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8cc:	fee7eae3          	bltu	a5,a4,8c0 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 8d0:	ff852583          	lw	a1,-8(a0)
 8d4:	6390                	ld	a2,0(a5)
 8d6:	02059713          	slli	a4,a1,0x20
 8da:	9301                	srli	a4,a4,0x20
 8dc:	0712                	slli	a4,a4,0x4
 8de:	9736                	add	a4,a4,a3
 8e0:	fae60ae3          	beq	a2,a4,894 <free+0x14>
    bp->s.ptr = p->s.ptr;
 8e4:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8e8:	4790                	lw	a2,8(a5)
 8ea:	02061713          	slli	a4,a2,0x20
 8ee:	9301                	srli	a4,a4,0x20
 8f0:	0712                	slli	a4,a4,0x4
 8f2:	973e                	add	a4,a4,a5
 8f4:	fae689e3          	beq	a3,a4,8a6 <free+0x26>
  } else
    p->s.ptr = bp;
 8f8:	e394                	sd	a3,0(a5)
  freep = p;
 8fa:	00000717          	auipc	a4,0x0
 8fe:	60f73323          	sd	a5,1542(a4) # f00 <freep>
}
 902:	6422                	ld	s0,8(sp)
 904:	0141                	addi	sp,sp,16
 906:	8082                	ret

0000000000000908 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 908:	7139                	addi	sp,sp,-64
 90a:	fc06                	sd	ra,56(sp)
 90c:	f822                	sd	s0,48(sp)
 90e:	f426                	sd	s1,40(sp)
 910:	f04a                	sd	s2,32(sp)
 912:	ec4e                	sd	s3,24(sp)
 914:	e852                	sd	s4,16(sp)
 916:	e456                	sd	s5,8(sp)
 918:	e05a                	sd	s6,0(sp)
 91a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 91c:	02051493          	slli	s1,a0,0x20
 920:	9081                	srli	s1,s1,0x20
 922:	04bd                	addi	s1,s1,15
 924:	8091                	srli	s1,s1,0x4
 926:	0014899b          	addiw	s3,s1,1
 92a:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 92c:	00000517          	auipc	a0,0x0
 930:	5d453503          	ld	a0,1492(a0) # f00 <freep>
 934:	c515                	beqz	a0,960 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 936:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 938:	4798                	lw	a4,8(a5)
 93a:	02977f63          	bgeu	a4,s1,978 <malloc+0x70>
 93e:	8a4e                	mv	s4,s3
 940:	0009871b          	sext.w	a4,s3
 944:	6685                	lui	a3,0x1
 946:	00d77363          	bgeu	a4,a3,94c <malloc+0x44>
 94a:	6a05                	lui	s4,0x1
 94c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 950:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 954:	00000917          	auipc	s2,0x0
 958:	5ac90913          	addi	s2,s2,1452 # f00 <freep>
  if(p == (char*)-1)
 95c:	5afd                	li	s5,-1
 95e:	a88d                	j	9d0 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 960:	00000797          	auipc	a5,0x0
 964:	5b078793          	addi	a5,a5,1456 # f10 <base>
 968:	00000717          	auipc	a4,0x0
 96c:	58f73c23          	sd	a5,1432(a4) # f00 <freep>
 970:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 972:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 976:	b7e1                	j	93e <malloc+0x36>
      if(p->s.size == nunits)
 978:	02e48b63          	beq	s1,a4,9ae <malloc+0xa6>
        p->s.size -= nunits;
 97c:	4137073b          	subw	a4,a4,s3
 980:	c798                	sw	a4,8(a5)
        p += p->s.size;
 982:	1702                	slli	a4,a4,0x20
 984:	9301                	srli	a4,a4,0x20
 986:	0712                	slli	a4,a4,0x4
 988:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 98a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 98e:	00000717          	auipc	a4,0x0
 992:	56a73923          	sd	a0,1394(a4) # f00 <freep>
      return (void*)(p + 1);
 996:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 99a:	70e2                	ld	ra,56(sp)
 99c:	7442                	ld	s0,48(sp)
 99e:	74a2                	ld	s1,40(sp)
 9a0:	7902                	ld	s2,32(sp)
 9a2:	69e2                	ld	s3,24(sp)
 9a4:	6a42                	ld	s4,16(sp)
 9a6:	6aa2                	ld	s5,8(sp)
 9a8:	6b02                	ld	s6,0(sp)
 9aa:	6121                	addi	sp,sp,64
 9ac:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 9ae:	6398                	ld	a4,0(a5)
 9b0:	e118                	sd	a4,0(a0)
 9b2:	bff1                	j	98e <malloc+0x86>
  hp->s.size = nu;
 9b4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9b8:	0541                	addi	a0,a0,16
 9ba:	00000097          	auipc	ra,0x0
 9be:	ec6080e7          	jalr	-314(ra) # 880 <free>
  return freep;
 9c2:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9c6:	d971                	beqz	a0,99a <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9c8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9ca:	4798                	lw	a4,8(a5)
 9cc:	fa9776e3          	bgeu	a4,s1,978 <malloc+0x70>
    if(p == freep)
 9d0:	00093703          	ld	a4,0(s2)
 9d4:	853e                	mv	a0,a5
 9d6:	fef719e3          	bne	a4,a5,9c8 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 9da:	8552                	mv	a0,s4
 9dc:	00000097          	auipc	ra,0x0
 9e0:	b7e080e7          	jalr	-1154(ra) # 55a <sbrk>
  if(p == (char*)-1)
 9e4:	fd5518e3          	bne	a0,s5,9b4 <malloc+0xac>
        return 0;
 9e8:	4501                	li	a0,0
 9ea:	bf45                	j	99a <malloc+0x92>

00000000000009ec <setjmp>:
 9ec:	e100                	sd	s0,0(a0)
 9ee:	e504                	sd	s1,8(a0)
 9f0:	01253823          	sd	s2,16(a0)
 9f4:	01353c23          	sd	s3,24(a0)
 9f8:	03453023          	sd	s4,32(a0)
 9fc:	03553423          	sd	s5,40(a0)
 a00:	03653823          	sd	s6,48(a0)
 a04:	03753c23          	sd	s7,56(a0)
 a08:	05853023          	sd	s8,64(a0)
 a0c:	05953423          	sd	s9,72(a0)
 a10:	05a53823          	sd	s10,80(a0)
 a14:	05b53c23          	sd	s11,88(a0)
 a18:	06153023          	sd	ra,96(a0)
 a1c:	06253423          	sd	sp,104(a0)
 a20:	4501                	li	a0,0
 a22:	8082                	ret

0000000000000a24 <longjmp>:
 a24:	6100                	ld	s0,0(a0)
 a26:	6504                	ld	s1,8(a0)
 a28:	01053903          	ld	s2,16(a0)
 a2c:	01853983          	ld	s3,24(a0)
 a30:	02053a03          	ld	s4,32(a0)
 a34:	02853a83          	ld	s5,40(a0)
 a38:	03053b03          	ld	s6,48(a0)
 a3c:	03853b83          	ld	s7,56(a0)
 a40:	04053c03          	ld	s8,64(a0)
 a44:	04853c83          	ld	s9,72(a0)
 a48:	05053d03          	ld	s10,80(a0)
 a4c:	05853d83          	ld	s11,88(a0)
 a50:	06053083          	ld	ra,96(a0)
 a54:	06853103          	ld	sp,104(a0)
 a58:	c199                	beqz	a1,a5e <longjmp_1>
 a5a:	852e                	mv	a0,a1
 a5c:	8082                	ret

0000000000000a5e <longjmp_1>:
 a5e:	4505                	li	a0,1
 a60:	8082                	ret

0000000000000a62 <get_current_thread>:

//the below 2 jmp buffer will be used for main function and thread context switching
static jmp_buf env_st; 
static jmp_buf env_tmp;  

struct thread *get_current_thread() {
 a62:	1141                	addi	sp,sp,-16
 a64:	e422                	sd	s0,8(sp)
 a66:	0800                	addi	s0,sp,16
    return current_thread;
}
 a68:	00000517          	auipc	a0,0x0
 a6c:	4a053503          	ld	a0,1184(a0) # f08 <current_thread>
 a70:	6422                	ld	s0,8(sp)
 a72:	0141                	addi	sp,sp,16
 a74:	8082                	ret

0000000000000a76 <thread_create>:

struct thread *thread_create(void (*f)(void *), void *arg){
 a76:	7179                	addi	sp,sp,-48
 a78:	f406                	sd	ra,40(sp)
 a7a:	f022                	sd	s0,32(sp)
 a7c:	ec26                	sd	s1,24(sp)
 a7e:	e84a                	sd	s2,16(sp)
 a80:	e44e                	sd	s3,8(sp)
 a82:	e052                	sd	s4,0(sp)
 a84:	1800                	addi	s0,sp,48
 a86:	89aa                	mv	s3,a0
 a88:	892e                	mv	s2,a1
    struct thread *t = (struct thread*) malloc(sizeof(struct thread));
 a8a:	15000513          	li	a0,336
 a8e:	00000097          	auipc	ra,0x0
 a92:	e7a080e7          	jalr	-390(ra) # 908 <malloc>
 a96:	84aa                	mv	s1,a0
    unsigned long new_stack_p;
    unsigned long new_stack;
    new_stack = (unsigned long) malloc(sizeof(unsigned long)*0x100);
 a98:	6a05                	lui	s4,0x1
 a9a:	800a0513          	addi	a0,s4,-2048 # 800 <vprintf+0x1c2>
 a9e:	00000097          	auipc	ra,0x0
 aa2:	e6a080e7          	jalr	-406(ra) # 908 <malloc>
    new_stack_p = new_stack +0x100*8-0x2*8;
    t->fp = f; 
 aa6:	0134b023          	sd	s3,0(s1)
    t->arg = arg;
 aaa:	0124b423          	sd	s2,8(s1)
    t->ID  = id;
 aae:	00000717          	auipc	a4,0x0
 ab2:	44670713          	addi	a4,a4,1094 # ef4 <id>
 ab6:	431c                	lw	a5,0(a4)
 ab8:	08f4aa23          	sw	a5,148(s1)
    t->buf_set = 0;
 abc:	0804a823          	sw	zero,144(s1)
    t->stack = (void*) new_stack; //points to the beginning of allocated stack memory for the thread.
 ac0:	e888                	sd	a0,16(s1)
    new_stack_p = new_stack +0x100*8-0x2*8;
 ac2:	7f050513          	addi	a0,a0,2032
    t->stack_p = (void*) new_stack_p; //points to the current execution part of the thread.
 ac6:	ec88                	sd	a0,24(s1)
    id++;
 ac8:	2785                	addiw	a5,a5,1
 aca:	c31c                	sw	a5,0(a4)

    // part 2
    unsigned long new_handler_stack_p;
    unsigned long new_handler_stack;
    new_handler_stack = (unsigned long) malloc(sizeof(unsigned long)*0x100);
 acc:	800a0513          	addi	a0,s4,-2048
 ad0:	00000097          	auipc	ra,0x0
 ad4:	e38080e7          	jalr	-456(ra) # 908 <malloc>
    new_handler_stack_p = new_handler_stack +0x100*8-0x2*8;
    t->suspended = 0;
 ad8:	0a04ac23          	sw	zero,184(s1)
    t->sig_handler[0] = NULL_FUNC;
 adc:	57fd                	li	a5,-1
 ade:	e0fc                	sd	a5,192(s1)
    t->sig_handler[1] = NULL_FUNC;
 ae0:	e4fc                	sd	a5,200(s1)
    t->signo = -1;
 ae2:	0cf4a823          	sw	a5,208(s1)
    t->handler_buf_set = 0;
 ae6:	1404a423          	sw	zero,328(s1)
    t->handler_stack = new_handler_stack;
 aea:	f4c8                	sd	a0,168(s1)
    new_handler_stack_p = new_handler_stack +0x100*8-0x2*8;
 aec:	7f050513          	addi	a0,a0,2032
    t->handler_stack_p = new_handler_stack_p;
 af0:	f8c8                	sd	a0,176(s1)
    return t;
}
 af2:	8526                	mv	a0,s1
 af4:	70a2                	ld	ra,40(sp)
 af6:	7402                	ld	s0,32(sp)
 af8:	64e2                	ld	s1,24(sp)
 afa:	6942                	ld	s2,16(sp)
 afc:	69a2                	ld	s3,8(sp)
 afe:	6a02                	ld	s4,0(sp)
 b00:	6145                	addi	sp,sp,48
 b02:	8082                	ret

0000000000000b04 <thread_add_runqueue>:


void thread_add_runqueue(struct thread *t){
 b04:	1141                	addi	sp,sp,-16
 b06:	e422                	sd	s0,8(sp)
 b08:	0800                	addi	s0,sp,16
    if(current_thread == NULL){
 b0a:	00000797          	auipc	a5,0x0
 b0e:	3fe7b783          	ld	a5,1022(a5) # f08 <current_thread>
 b12:	cf89                	beqz	a5,b2c <thread_add_runqueue+0x28>
        current_thread = t;
        current_thread->next = current_thread;
        current_thread->previous = current_thread;
    }else{
        //TO DO
        struct thread* last_t = current_thread->previous;
 b14:	6fd8                	ld	a4,152(a5)
        last_t->next = t;
 b16:	f348                	sd	a0,160(a4)
        t->previous = last_t;
 b18:	ed58                	sd	a4,152(a0)
        t->next = current_thread;
 b1a:	f15c                	sd	a5,160(a0)
        current_thread->previous = t;
 b1c:	efc8                	sd	a0,152(a5)
        // inherit the signal from current thread
        t->sig_handler[0] = current_thread->sig_handler[0];
 b1e:	63f8                	ld	a4,192(a5)
 b20:	e178                	sd	a4,192(a0)
        t->sig_handler[1] = current_thread->sig_handler[1];
 b22:	67fc                	ld	a5,200(a5)
 b24:	e57c                	sd	a5,200(a0)
    }
}
 b26:	6422                	ld	s0,8(sp)
 b28:	0141                	addi	sp,sp,16
 b2a:	8082                	ret
        current_thread = t;
 b2c:	00000797          	auipc	a5,0x0
 b30:	3ca7be23          	sd	a0,988(a5) # f08 <current_thread>
        current_thread->next = current_thread;
 b34:	f148                	sd	a0,160(a0)
        current_thread->previous = current_thread;
 b36:	ed48                	sd	a0,152(a0)
 b38:	b7fd                	j	b26 <thread_add_runqueue+0x22>

0000000000000b3a <schedule>:
    }
   
}

//schedule will follow the rule of FIFO
void schedule(void){
 b3a:	1141                	addi	sp,sp,-16
 b3c:	e422                	sd	s0,8(sp)
 b3e:	0800                	addi	s0,sp,16
    current_thread = current_thread->next;
 b40:	00000717          	auipc	a4,0x0
 b44:	3c870713          	addi	a4,a4,968 # f08 <current_thread>
 b48:	631c                	ld	a5,0(a4)
 b4a:	73dc                	ld	a5,160(a5)
 b4c:	e31c                	sd	a5,0(a4)
    
    //Part 2: TO DO
    while(current_thread->suspended) {
 b4e:	0b87a703          	lw	a4,184(a5)
 b52:	cb09                	beqz	a4,b64 <schedule+0x2a>
        current_thread = current_thread->next;
 b54:	73dc                	ld	a5,160(a5)
    while(current_thread->suspended) {
 b56:	0b87a703          	lw	a4,184(a5)
 b5a:	ff6d                	bnez	a4,b54 <schedule+0x1a>
 b5c:	00000717          	auipc	a4,0x0
 b60:	3af73623          	sd	a5,940(a4) # f08 <current_thread>
    };
    
}
 b64:	6422                	ld	s0,8(sp)
 b66:	0141                	addi	sp,sp,16
 b68:	8082                	ret

0000000000000b6a <thread_exit>:

void thread_exit(void){
 b6a:	1101                	addi	sp,sp,-32
 b6c:	ec06                	sd	ra,24(sp)
 b6e:	e822                	sd	s0,16(sp)
 b70:	e426                	sd	s1,8(sp)
 b72:	1000                	addi	s0,sp,32
    if(current_thread->next != current_thread){
 b74:	00000497          	auipc	s1,0x0
 b78:	3944b483          	ld	s1,916(s1) # f08 <current_thread>
 b7c:	70dc                	ld	a5,160(s1)
 b7e:	04f48163          	beq	s1,a5,bc0 <thread_exit+0x56>
        //TO DO
        struct thread *del_thread = current_thread;
        struct thread *prev = current_thread->previous;
 b82:	6cd8                	ld	a4,152(s1)
        current_thread = current_thread->next;
 b84:	00000697          	auipc	a3,0x0
 b88:	38f6b223          	sd	a5,900(a3) # f08 <current_thread>
        prev->next = current_thread;
 b8c:	f35c                	sd	a5,160(a4)
        current_thread->previous = prev;
 b8e:	efd8                	sd	a4,152(a5)
        free(del_thread->stack);
 b90:	6888                	ld	a0,16(s1)
 b92:	00000097          	auipc	ra,0x0
 b96:	cee080e7          	jalr	-786(ra) # 880 <free>
        free(del_thread->handler_stack);
 b9a:	74c8                	ld	a0,168(s1)
 b9c:	00000097          	auipc	ra,0x0
 ba0:	ce4080e7          	jalr	-796(ra) # 880 <free>
        free(del_thread);
 ba4:	8526                	mv	a0,s1
 ba6:	00000097          	auipc	ra,0x0
 baa:	cda080e7          	jalr	-806(ra) # 880 <free>
        dispatch(); 
 bae:	00000097          	auipc	ra,0x0
 bb2:	040080e7          	jalr	64(ra) # bee <dispatch>
    else{
        free(current_thread->stack);
        free(current_thread);
        longjmp(env_st, 1);
    }
}
 bb6:	60e2                	ld	ra,24(sp)
 bb8:	6442                	ld	s0,16(sp)
 bba:	64a2                	ld	s1,8(sp)
 bbc:	6105                	addi	sp,sp,32
 bbe:	8082                	ret
        free(current_thread->stack);
 bc0:	6888                	ld	a0,16(s1)
 bc2:	00000097          	auipc	ra,0x0
 bc6:	cbe080e7          	jalr	-834(ra) # 880 <free>
        free(current_thread);
 bca:	00000517          	auipc	a0,0x0
 bce:	33e53503          	ld	a0,830(a0) # f08 <current_thread>
 bd2:	00000097          	auipc	ra,0x0
 bd6:	cae080e7          	jalr	-850(ra) # 880 <free>
        longjmp(env_st, 1);
 bda:	4585                	li	a1,1
 bdc:	00000517          	auipc	a0,0x0
 be0:	34450513          	addi	a0,a0,836 # f20 <env_st>
 be4:	00000097          	auipc	ra,0x0
 be8:	e40080e7          	jalr	-448(ra) # a24 <longjmp>
}
 bec:	b7e9                	j	bb6 <thread_exit+0x4c>

0000000000000bee <dispatch>:
void dispatch(void){
 bee:	1101                	addi	sp,sp,-32
 bf0:	ec06                	sd	ra,24(sp)
 bf2:	e822                	sd	s0,16(sp)
 bf4:	e426                	sd	s1,8(sp)
 bf6:	1000                	addi	s0,sp,32
    if(current_thread->suspended){ //?
 bf8:	00000797          	auipc	a5,0x0
 bfc:	3107b783          	ld	a5,784(a5) # f08 <current_thread>
 c00:	0b87a783          	lw	a5,184(a5)
 c04:	e3c5                	bnez	a5,ca4 <dispatch+0xb6>
    if(current_thread->signo != -1){
 c06:	00000517          	auipc	a0,0x0
 c0a:	30253503          	ld	a0,770(a0) # f08 <current_thread>
 c0e:	0d052783          	lw	a5,208(a0)
 c12:	577d                	li	a4,-1
 c14:	04e78763          	beq	a5,a4,c62 <dispatch+0x74>
        if(current_thread->sig_handler[current_thread->signo] == NULL_FUNC){ // not registered
 c18:	07e1                	addi	a5,a5,24
 c1a:	078e                	slli	a5,a5,0x3
 c1c:	97aa                	add	a5,a5,a0
 c1e:	6398                	ld	a4,0(a5)
 c20:	57fd                	li	a5,-1
 c22:	08f70663          	beq	a4,a5,cae <dispatch+0xc0>
            if(current_thread->handler_buf_set == 0){
 c26:	14852783          	lw	a5,328(a0)
 c2a:	e7d5                	bnez	a5,cd6 <dispatch+0xe8>
                current_thread->handler_buf_set = 1;
 c2c:	4785                	li	a5,1
 c2e:	14f52423          	sw	a5,328(a0)
                int val = setjmp(current_thread->handler_env);
 c32:	0d850513          	addi	a0,a0,216
 c36:	00000097          	auipc	ra,0x0
 c3a:	db6080e7          	jalr	-586(ra) # 9ec <setjmp>
                if(val == 0){
 c3e:	cd2d                	beqz	a0,cb8 <dispatch+0xca>
                current_thread->sig_handler[current_thread->signo](current_thread->signo);
 c40:	00000497          	auipc	s1,0x0
 c44:	2c848493          	addi	s1,s1,712 # f08 <current_thread>
 c48:	609c                	ld	a5,0(s1)
 c4a:	0d07a503          	lw	a0,208(a5)
 c4e:	01850713          	addi	a4,a0,24
 c52:	070e                	slli	a4,a4,0x3
 c54:	97ba                	add	a5,a5,a4
 c56:	639c                	ld	a5,0(a5)
 c58:	9782                	jalr	a5
                current_thread->signo = -1;
 c5a:	609c                	ld	a5,0(s1)
 c5c:	577d                	li	a4,-1
 c5e:	0ce7a823          	sw	a4,208(a5)
    if(current_thread->buf_set == 0){
 c62:	00000517          	auipc	a0,0x0
 c66:	2a653503          	ld	a0,678(a0) # f08 <current_thread>
 c6a:	09052783          	lw	a5,144(a0)
 c6e:	ebd1                	bnez	a5,d02 <dispatch+0x114>
        current_thread->buf_set = 1; 
 c70:	4785                	li	a5,1
 c72:	08f52823          	sw	a5,144(a0)
        int val = setjmp(current_thread->env);
 c76:	02050513          	addi	a0,a0,32
 c7a:	00000097          	auipc	ra,0x0
 c7e:	d72080e7          	jalr	-654(ra) # 9ec <setjmp>
        if(val == 0){
 c82:	c135                	beqz	a0,ce6 <dispatch+0xf8>
        current_thread->fp(current_thread->arg);
 c84:	00000797          	auipc	a5,0x0
 c88:	2847b783          	ld	a5,644(a5) # f08 <current_thread>
 c8c:	6398                	ld	a4,0(a5)
 c8e:	6788                	ld	a0,8(a5)
 c90:	9702                	jalr	a4
        thread_exit();
 c92:	00000097          	auipc	ra,0x0
 c96:	ed8080e7          	jalr	-296(ra) # b6a <thread_exit>
}
 c9a:	60e2                	ld	ra,24(sp)
 c9c:	6442                	ld	s0,16(sp)
 c9e:	64a2                	ld	s1,8(sp)
 ca0:	6105                	addi	sp,sp,32
 ca2:	8082                	ret
        schedule();
 ca4:	00000097          	auipc	ra,0x0
 ca8:	e96080e7          	jalr	-362(ra) # b3a <schedule>
 cac:	bfa9                	j	c06 <dispatch+0x18>
            thread_exit();
 cae:	00000097          	auipc	ra,0x0
 cb2:	ebc080e7          	jalr	-324(ra) # b6a <thread_exit>
 cb6:	b775                	j	c62 <dispatch+0x74>
                    current_thread->handler_env[0].sp = current_thread->handler_stack_p;
 cb8:	00000517          	auipc	a0,0x0
 cbc:	25053503          	ld	a0,592(a0) # f08 <current_thread>
 cc0:	795c                	ld	a5,176(a0)
 cc2:	14f53023          	sd	a5,320(a0)
                    longjmp(current_thread->handler_env, 1);
 cc6:	4585                	li	a1,1
 cc8:	0d850513          	addi	a0,a0,216
 ccc:	00000097          	auipc	ra,0x0
 cd0:	d58080e7          	jalr	-680(ra) # a24 <longjmp>
 cd4:	b7b5                	j	c40 <dispatch+0x52>
                longjmp(current_thread->handler_env, 1);
 cd6:	4585                	li	a1,1
 cd8:	0d850513          	addi	a0,a0,216
 cdc:	00000097          	auipc	ra,0x0
 ce0:	d48080e7          	jalr	-696(ra) # a24 <longjmp>
 ce4:	bfbd                	j	c62 <dispatch+0x74>
            current_thread->env[0].sp = current_thread->stack_p;
 ce6:	00000517          	auipc	a0,0x0
 cea:	22253503          	ld	a0,546(a0) # f08 <current_thread>
 cee:	6d1c                	ld	a5,24(a0)
 cf0:	e55c                	sd	a5,136(a0)
            longjmp(current_thread->env, 1);
 cf2:	4585                	li	a1,1
 cf4:	02050513          	addi	a0,a0,32
 cf8:	00000097          	auipc	ra,0x0
 cfc:	d2c080e7          	jalr	-724(ra) # a24 <longjmp>
 d00:	b751                	j	c84 <dispatch+0x96>
        longjmp(current_thread->env, 1);
 d02:	4585                	li	a1,1
 d04:	02050513          	addi	a0,a0,32
 d08:	00000097          	auipc	ra,0x0
 d0c:	d1c080e7          	jalr	-740(ra) # a24 <longjmp>
}
 d10:	b769                	j	c9a <dispatch+0xac>

0000000000000d12 <thread_yield>:
void thread_yield(void){
 d12:	1141                	addi	sp,sp,-16
 d14:	e406                	sd	ra,8(sp)
 d16:	e022                	sd	s0,0(sp)
 d18:	0800                	addi	s0,sp,16
    if(current_thread->signo != -1){
 d1a:	00000517          	auipc	a0,0x0
 d1e:	1ee53503          	ld	a0,494(a0) # f08 <current_thread>
 d22:	0d052703          	lw	a4,208(a0)
 d26:	57fd                	li	a5,-1
 d28:	02f70663          	beq	a4,a5,d54 <thread_yield+0x42>
        int val = setjmp(current_thread->handler_env);
 d2c:	0d850513          	addi	a0,a0,216
 d30:	00000097          	auipc	ra,0x0
 d34:	cbc080e7          	jalr	-836(ra) # 9ec <setjmp>
        if(val == 0){
 d38:	c509                	beqz	a0,d42 <thread_yield+0x30>
}
 d3a:	60a2                	ld	ra,8(sp)
 d3c:	6402                	ld	s0,0(sp)
 d3e:	0141                	addi	sp,sp,16
 d40:	8082                	ret
            schedule();
 d42:	00000097          	auipc	ra,0x0
 d46:	df8080e7          	jalr	-520(ra) # b3a <schedule>
            dispatch();
 d4a:	00000097          	auipc	ra,0x0
 d4e:	ea4080e7          	jalr	-348(ra) # bee <dispatch>
 d52:	b7e5                	j	d3a <thread_yield+0x28>
        if (setjmp(current_thread->env) == 0) { 
 d54:	02050513          	addi	a0,a0,32
 d58:	00000097          	auipc	ra,0x0
 d5c:	c94080e7          	jalr	-876(ra) # 9ec <setjmp>
 d60:	fd69                	bnez	a0,d3a <thread_yield+0x28>
            schedule();  
 d62:	00000097          	auipc	ra,0x0
 d66:	dd8080e7          	jalr	-552(ra) # b3a <schedule>
            dispatch();  
 d6a:	00000097          	auipc	ra,0x0
 d6e:	e84080e7          	jalr	-380(ra) # bee <dispatch>
}
 d72:	b7e1                	j	d3a <thread_yield+0x28>

0000000000000d74 <thread_start_threading>:

void thread_start_threading(void){
 d74:	1141                	addi	sp,sp,-16
 d76:	e406                	sd	ra,8(sp)
 d78:	e022                	sd	s0,0(sp)
 d7a:	0800                	addi	s0,sp,16
    //TO DO
    int val = setjmp(env_st);
 d7c:	00000517          	auipc	a0,0x0
 d80:	1a450513          	addi	a0,a0,420 # f20 <env_st>
 d84:	00000097          	auipc	ra,0x0
 d88:	c68080e7          	jalr	-920(ra) # 9ec <setjmp>
    if(val == 0){
 d8c:	c509                	beqz	a0,d96 <thread_start_threading+0x22>
        dispatch();
    }
}
 d8e:	60a2                	ld	ra,8(sp)
 d90:	6402                	ld	s0,0(sp)
 d92:	0141                	addi	sp,sp,16
 d94:	8082                	ret
        dispatch();
 d96:	00000097          	auipc	ra,0x0
 d9a:	e58080e7          	jalr	-424(ra) # bee <dispatch>
}
 d9e:	bfc5                	j	d8e <thread_start_threading+0x1a>

0000000000000da0 <thread_register_handler>:

//PART 2
void thread_register_handler(int signo, void (*handler)(int)){
 da0:	1141                	addi	sp,sp,-16
 da2:	e422                	sd	s0,8(sp)
 da4:	0800                	addi	s0,sp,16
    current_thread->sig_handler[signo] = handler;
 da6:	0561                	addi	a0,a0,24
 da8:	050e                	slli	a0,a0,0x3
 daa:	00000797          	auipc	a5,0x0
 dae:	15e7b783          	ld	a5,350(a5) # f08 <current_thread>
 db2:	953e                	add	a0,a0,a5
 db4:	e10c                	sd	a1,0(a0)
}
 db6:	6422                	ld	s0,8(sp)
 db8:	0141                	addi	sp,sp,16
 dba:	8082                	ret

0000000000000dbc <thread_kill>:

void thread_kill(struct thread *t, int signo){
 dbc:	1141                	addi	sp,sp,-16
 dbe:	e422                	sd	s0,8(sp)
 dc0:	0800                	addi	s0,sp,16
    //TO DO
    t->signo = signo;
 dc2:	0cb52823          	sw	a1,208(a0)
}
 dc6:	6422                	ld	s0,8(sp)
 dc8:	0141                	addi	sp,sp,16
 dca:	8082                	ret

0000000000000dcc <thread_suspend>:

void thread_suspend(struct thread *t) {
    //TO DO
    t->suspended = 1;
 dcc:	4785                	li	a5,1
 dce:	0af52c23          	sw	a5,184(a0)
    if(current_thread == t){
 dd2:	00000797          	auipc	a5,0x0
 dd6:	1367b783          	ld	a5,310(a5) # f08 <current_thread>
 dda:	00a78363          	beq	a5,a0,de0 <thread_suspend+0x14>
 dde:	8082                	ret
void thread_suspend(struct thread *t) {
 de0:	1141                	addi	sp,sp,-16
 de2:	e406                	sd	ra,8(sp)
 de4:	e022                	sd	s0,0(sp)
 de6:	0800                	addi	s0,sp,16
        thread_yield();
 de8:	00000097          	auipc	ra,0x0
 dec:	f2a080e7          	jalr	-214(ra) # d12 <thread_yield>
    }
   
}
 df0:	60a2                	ld	ra,8(sp)
 df2:	6402                	ld	s0,0(sp)
 df4:	0141                	addi	sp,sp,16
 df6:	8082                	ret

0000000000000df8 <thread_resume>:

void thread_resume(struct thread *t) {
 df8:	1141                	addi	sp,sp,-16
 dfa:	e422                	sd	s0,8(sp)
 dfc:	0800                	addi	s0,sp,16
    //TO DO
    t->suspended = 0;
 dfe:	0a052c23          	sw	zero,184(a0)
}
 e02:	6422                	ld	s0,8(sp)
 e04:	0141                	addi	sp,sp,16
 e06:	8082                	ret
