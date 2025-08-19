
user/_printfslab:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "user/user.h"

int main(int argc, char *argv[]) {
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  printfslab(); 
   8:	31e000ef          	jal	ra,326 <printfslab>
  exit(0);
   c:	4501                	li	a0,0
   e:	270000ef          	jal	ra,27e <exit>

0000000000000012 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  12:	1141                	addi	sp,sp,-16
  14:	e406                	sd	ra,8(sp)
  16:	e022                	sd	s0,0(sp)
  18:	0800                	addi	s0,sp,16
  extern int main();
  main();
  1a:	fe7ff0ef          	jal	ra,0 <main>
  exit(0);
  1e:	4501                	li	a0,0
  20:	25e000ef          	jal	ra,27e <exit>

0000000000000024 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  24:	1141                	addi	sp,sp,-16
  26:	e422                	sd	s0,8(sp)
  28:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  2a:	87aa                	mv	a5,a0
  2c:	0585                	addi	a1,a1,1
  2e:	0785                	addi	a5,a5,1
  30:	fff5c703          	lbu	a4,-1(a1)
  34:	fee78fa3          	sb	a4,-1(a5)
  38:	fb75                	bnez	a4,2c <strcpy+0x8>
    ;
  return os;
}
  3a:	6422                	ld	s0,8(sp)
  3c:	0141                	addi	sp,sp,16
  3e:	8082                	ret

0000000000000040 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  40:	1141                	addi	sp,sp,-16
  42:	e422                	sd	s0,8(sp)
  44:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  46:	00054783          	lbu	a5,0(a0)
  4a:	cb91                	beqz	a5,5e <strcmp+0x1e>
  4c:	0005c703          	lbu	a4,0(a1)
  50:	00f71763          	bne	a4,a5,5e <strcmp+0x1e>
    p++, q++;
  54:	0505                	addi	a0,a0,1
  56:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  58:	00054783          	lbu	a5,0(a0)
  5c:	fbe5                	bnez	a5,4c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  5e:	0005c503          	lbu	a0,0(a1)
}
  62:	40a7853b          	subw	a0,a5,a0
  66:	6422                	ld	s0,8(sp)
  68:	0141                	addi	sp,sp,16
  6a:	8082                	ret

000000000000006c <strlen>:

uint
strlen(const char *s)
{
  6c:	1141                	addi	sp,sp,-16
  6e:	e422                	sd	s0,8(sp)
  70:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  72:	00054783          	lbu	a5,0(a0)
  76:	cf91                	beqz	a5,92 <strlen+0x26>
  78:	0505                	addi	a0,a0,1
  7a:	87aa                	mv	a5,a0
  7c:	4685                	li	a3,1
  7e:	9e89                	subw	a3,a3,a0
  80:	00f6853b          	addw	a0,a3,a5
  84:	0785                	addi	a5,a5,1
  86:	fff7c703          	lbu	a4,-1(a5)
  8a:	fb7d                	bnez	a4,80 <strlen+0x14>
    ;
  return n;
}
  8c:	6422                	ld	s0,8(sp)
  8e:	0141                	addi	sp,sp,16
  90:	8082                	ret
  for(n = 0; s[n]; n++)
  92:	4501                	li	a0,0
  94:	bfe5                	j	8c <strlen+0x20>

0000000000000096 <memset>:

void*
memset(void *dst, int c, uint n)
{
  96:	1141                	addi	sp,sp,-16
  98:	e422                	sd	s0,8(sp)
  9a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  9c:	ca19                	beqz	a2,b2 <memset+0x1c>
  9e:	87aa                	mv	a5,a0
  a0:	1602                	slli	a2,a2,0x20
  a2:	9201                	srli	a2,a2,0x20
  a4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  a8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  ac:	0785                	addi	a5,a5,1
  ae:	fee79de3          	bne	a5,a4,a8 <memset+0x12>
  }
  return dst;
}
  b2:	6422                	ld	s0,8(sp)
  b4:	0141                	addi	sp,sp,16
  b6:	8082                	ret

00000000000000b8 <strchr>:

char*
strchr(const char *s, char c)
{
  b8:	1141                	addi	sp,sp,-16
  ba:	e422                	sd	s0,8(sp)
  bc:	0800                	addi	s0,sp,16
  for(; *s; s++)
  be:	00054783          	lbu	a5,0(a0)
  c2:	cb99                	beqz	a5,d8 <strchr+0x20>
    if(*s == c)
  c4:	00f58763          	beq	a1,a5,d2 <strchr+0x1a>
  for(; *s; s++)
  c8:	0505                	addi	a0,a0,1
  ca:	00054783          	lbu	a5,0(a0)
  ce:	fbfd                	bnez	a5,c4 <strchr+0xc>
      return (char*)s;
  return 0;
  d0:	4501                	li	a0,0
}
  d2:	6422                	ld	s0,8(sp)
  d4:	0141                	addi	sp,sp,16
  d6:	8082                	ret
  return 0;
  d8:	4501                	li	a0,0
  da:	bfe5                	j	d2 <strchr+0x1a>

00000000000000dc <gets>:

char*
gets(char *buf, int max)
{
  dc:	711d                	addi	sp,sp,-96
  de:	ec86                	sd	ra,88(sp)
  e0:	e8a2                	sd	s0,80(sp)
  e2:	e4a6                	sd	s1,72(sp)
  e4:	e0ca                	sd	s2,64(sp)
  e6:	fc4e                	sd	s3,56(sp)
  e8:	f852                	sd	s4,48(sp)
  ea:	f456                	sd	s5,40(sp)
  ec:	f05a                	sd	s6,32(sp)
  ee:	ec5e                	sd	s7,24(sp)
  f0:	1080                	addi	s0,sp,96
  f2:	8baa                	mv	s7,a0
  f4:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  f6:	892a                	mv	s2,a0
  f8:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
  fa:	4aa9                	li	s5,10
  fc:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
  fe:	89a6                	mv	s3,s1
 100:	2485                	addiw	s1,s1,1
 102:	0344d663          	bge	s1,s4,12e <gets+0x52>
    cc = read(0, &c, 1);
 106:	4605                	li	a2,1
 108:	faf40593          	addi	a1,s0,-81
 10c:	4501                	li	a0,0
 10e:	188000ef          	jal	ra,296 <read>
    if(cc < 1)
 112:	00a05e63          	blez	a0,12e <gets+0x52>
    buf[i++] = c;
 116:	faf44783          	lbu	a5,-81(s0)
 11a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 11e:	01578763          	beq	a5,s5,12c <gets+0x50>
 122:	0905                	addi	s2,s2,1
 124:	fd679de3          	bne	a5,s6,fe <gets+0x22>
  for(i=0; i+1 < max; ){
 128:	89a6                	mv	s3,s1
 12a:	a011                	j	12e <gets+0x52>
 12c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 12e:	99de                	add	s3,s3,s7
 130:	00098023          	sb	zero,0(s3)
  return buf;
}
 134:	855e                	mv	a0,s7
 136:	60e6                	ld	ra,88(sp)
 138:	6446                	ld	s0,80(sp)
 13a:	64a6                	ld	s1,72(sp)
 13c:	6906                	ld	s2,64(sp)
 13e:	79e2                	ld	s3,56(sp)
 140:	7a42                	ld	s4,48(sp)
 142:	7aa2                	ld	s5,40(sp)
 144:	7b02                	ld	s6,32(sp)
 146:	6be2                	ld	s7,24(sp)
 148:	6125                	addi	sp,sp,96
 14a:	8082                	ret

000000000000014c <stat>:

int
stat(const char *n, struct stat *st)
{
 14c:	1101                	addi	sp,sp,-32
 14e:	ec06                	sd	ra,24(sp)
 150:	e822                	sd	s0,16(sp)
 152:	e426                	sd	s1,8(sp)
 154:	e04a                	sd	s2,0(sp)
 156:	1000                	addi	s0,sp,32
 158:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 15a:	4581                	li	a1,0
 15c:	162000ef          	jal	ra,2be <open>
  if(fd < 0)
 160:	02054163          	bltz	a0,182 <stat+0x36>
 164:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 166:	85ca                	mv	a1,s2
 168:	16e000ef          	jal	ra,2d6 <fstat>
 16c:	892a                	mv	s2,a0
  close(fd);
 16e:	8526                	mv	a0,s1
 170:	136000ef          	jal	ra,2a6 <close>
  return r;
}
 174:	854a                	mv	a0,s2
 176:	60e2                	ld	ra,24(sp)
 178:	6442                	ld	s0,16(sp)
 17a:	64a2                	ld	s1,8(sp)
 17c:	6902                	ld	s2,0(sp)
 17e:	6105                	addi	sp,sp,32
 180:	8082                	ret
    return -1;
 182:	597d                	li	s2,-1
 184:	bfc5                	j	174 <stat+0x28>

0000000000000186 <atoi>:

int
atoi(const char *s)
{
 186:	1141                	addi	sp,sp,-16
 188:	e422                	sd	s0,8(sp)
 18a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 18c:	00054603          	lbu	a2,0(a0)
 190:	fd06079b          	addiw	a5,a2,-48
 194:	0ff7f793          	andi	a5,a5,255
 198:	4725                	li	a4,9
 19a:	02f76963          	bltu	a4,a5,1cc <atoi+0x46>
 19e:	86aa                	mv	a3,a0
  n = 0;
 1a0:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 1a2:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 1a4:	0685                	addi	a3,a3,1
 1a6:	0025179b          	slliw	a5,a0,0x2
 1aa:	9fa9                	addw	a5,a5,a0
 1ac:	0017979b          	slliw	a5,a5,0x1
 1b0:	9fb1                	addw	a5,a5,a2
 1b2:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1b6:	0006c603          	lbu	a2,0(a3)
 1ba:	fd06071b          	addiw	a4,a2,-48
 1be:	0ff77713          	andi	a4,a4,255
 1c2:	fee5f1e3          	bgeu	a1,a4,1a4 <atoi+0x1e>
  return n;
}
 1c6:	6422                	ld	s0,8(sp)
 1c8:	0141                	addi	sp,sp,16
 1ca:	8082                	ret
  n = 0;
 1cc:	4501                	li	a0,0
 1ce:	bfe5                	j	1c6 <atoi+0x40>

00000000000001d0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1d0:	1141                	addi	sp,sp,-16
 1d2:	e422                	sd	s0,8(sp)
 1d4:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 1d6:	02b57463          	bgeu	a0,a1,1fe <memmove+0x2e>
    while(n-- > 0)
 1da:	00c05f63          	blez	a2,1f8 <memmove+0x28>
 1de:	1602                	slli	a2,a2,0x20
 1e0:	9201                	srli	a2,a2,0x20
 1e2:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 1e6:	872a                	mv	a4,a0
      *dst++ = *src++;
 1e8:	0585                	addi	a1,a1,1
 1ea:	0705                	addi	a4,a4,1
 1ec:	fff5c683          	lbu	a3,-1(a1)
 1f0:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 1f4:	fee79ae3          	bne	a5,a4,1e8 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 1f8:	6422                	ld	s0,8(sp)
 1fa:	0141                	addi	sp,sp,16
 1fc:	8082                	ret
    dst += n;
 1fe:	00c50733          	add	a4,a0,a2
    src += n;
 202:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 204:	fec05ae3          	blez	a2,1f8 <memmove+0x28>
 208:	fff6079b          	addiw	a5,a2,-1
 20c:	1782                	slli	a5,a5,0x20
 20e:	9381                	srli	a5,a5,0x20
 210:	fff7c793          	not	a5,a5
 214:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 216:	15fd                	addi	a1,a1,-1
 218:	177d                	addi	a4,a4,-1
 21a:	0005c683          	lbu	a3,0(a1)
 21e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 222:	fee79ae3          	bne	a5,a4,216 <memmove+0x46>
 226:	bfc9                	j	1f8 <memmove+0x28>

0000000000000228 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 228:	1141                	addi	sp,sp,-16
 22a:	e422                	sd	s0,8(sp)
 22c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 22e:	ca05                	beqz	a2,25e <memcmp+0x36>
 230:	fff6069b          	addiw	a3,a2,-1
 234:	1682                	slli	a3,a3,0x20
 236:	9281                	srli	a3,a3,0x20
 238:	0685                	addi	a3,a3,1
 23a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 23c:	00054783          	lbu	a5,0(a0)
 240:	0005c703          	lbu	a4,0(a1)
 244:	00e79863          	bne	a5,a4,254 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 248:	0505                	addi	a0,a0,1
    p2++;
 24a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 24c:	fed518e3          	bne	a0,a3,23c <memcmp+0x14>
  }
  return 0;
 250:	4501                	li	a0,0
 252:	a019                	j	258 <memcmp+0x30>
      return *p1 - *p2;
 254:	40e7853b          	subw	a0,a5,a4
}
 258:	6422                	ld	s0,8(sp)
 25a:	0141                	addi	sp,sp,16
 25c:	8082                	ret
  return 0;
 25e:	4501                	li	a0,0
 260:	bfe5                	j	258 <memcmp+0x30>

0000000000000262 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 262:	1141                	addi	sp,sp,-16
 264:	e406                	sd	ra,8(sp)
 266:	e022                	sd	s0,0(sp)
 268:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 26a:	f67ff0ef          	jal	ra,1d0 <memmove>
}
 26e:	60a2                	ld	ra,8(sp)
 270:	6402                	ld	s0,0(sp)
 272:	0141                	addi	sp,sp,16
 274:	8082                	ret

0000000000000276 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 276:	4885                	li	a7,1
 ecall
 278:	00000073          	ecall
 ret
 27c:	8082                	ret

000000000000027e <exit>:
.global exit
exit:
 li a7, SYS_exit
 27e:	4889                	li	a7,2
 ecall
 280:	00000073          	ecall
 ret
 284:	8082                	ret

0000000000000286 <wait>:
.global wait
wait:
 li a7, SYS_wait
 286:	488d                	li	a7,3
 ecall
 288:	00000073          	ecall
 ret
 28c:	8082                	ret

000000000000028e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 28e:	4891                	li	a7,4
 ecall
 290:	00000073          	ecall
 ret
 294:	8082                	ret

0000000000000296 <read>:
.global read
read:
 li a7, SYS_read
 296:	4895                	li	a7,5
 ecall
 298:	00000073          	ecall
 ret
 29c:	8082                	ret

000000000000029e <write>:
.global write
write:
 li a7, SYS_write
 29e:	48c1                	li	a7,16
 ecall
 2a0:	00000073          	ecall
 ret
 2a4:	8082                	ret

00000000000002a6 <close>:
.global close
close:
 li a7, SYS_close
 2a6:	48d5                	li	a7,21
 ecall
 2a8:	00000073          	ecall
 ret
 2ac:	8082                	ret

00000000000002ae <kill>:
.global kill
kill:
 li a7, SYS_kill
 2ae:	4899                	li	a7,6
 ecall
 2b0:	00000073          	ecall
 ret
 2b4:	8082                	ret

00000000000002b6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 2b6:	489d                	li	a7,7
 ecall
 2b8:	00000073          	ecall
 ret
 2bc:	8082                	ret

00000000000002be <open>:
.global open
open:
 li a7, SYS_open
 2be:	48bd                	li	a7,15
 ecall
 2c0:	00000073          	ecall
 ret
 2c4:	8082                	ret

00000000000002c6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 2c6:	48c5                	li	a7,17
 ecall
 2c8:	00000073          	ecall
 ret
 2cc:	8082                	ret

00000000000002ce <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 2ce:	48c9                	li	a7,18
 ecall
 2d0:	00000073          	ecall
 ret
 2d4:	8082                	ret

00000000000002d6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 2d6:	48a1                	li	a7,8
 ecall
 2d8:	00000073          	ecall
 ret
 2dc:	8082                	ret

00000000000002de <link>:
.global link
link:
 li a7, SYS_link
 2de:	48cd                	li	a7,19
 ecall
 2e0:	00000073          	ecall
 ret
 2e4:	8082                	ret

00000000000002e6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 2e6:	48d1                	li	a7,20
 ecall
 2e8:	00000073          	ecall
 ret
 2ec:	8082                	ret

00000000000002ee <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 2ee:	48a5                	li	a7,9
 ecall
 2f0:	00000073          	ecall
 ret
 2f4:	8082                	ret

00000000000002f6 <dup>:
.global dup
dup:
 li a7, SYS_dup
 2f6:	48a9                	li	a7,10
 ecall
 2f8:	00000073          	ecall
 ret
 2fc:	8082                	ret

00000000000002fe <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 2fe:	48ad                	li	a7,11
 ecall
 300:	00000073          	ecall
 ret
 304:	8082                	ret

0000000000000306 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 306:	48b1                	li	a7,12
 ecall
 308:	00000073          	ecall
 ret
 30c:	8082                	ret

000000000000030e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 30e:	48b5                	li	a7,13
 ecall
 310:	00000073          	ecall
 ret
 314:	8082                	ret

0000000000000316 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 316:	48b9                	li	a7,14
 ecall
 318:	00000073          	ecall
 ret
 31c:	8082                	ret

000000000000031e <debugswitch>:
.global debugswitch
debugswitch:
 li a7, SYS_debugswitch
 31e:	48d9                	li	a7,22
 ecall
 320:	00000073          	ecall
 ret
 324:	8082                	ret

0000000000000326 <printfslab>:
.global printfslab
printfslab:
 li a7, SYS_printfslab
 326:	48dd                	li	a7,23
 ecall
 328:	00000073          	ecall
 ret
 32c:	8082                	ret

000000000000032e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 32e:	1101                	addi	sp,sp,-32
 330:	ec06                	sd	ra,24(sp)
 332:	e822                	sd	s0,16(sp)
 334:	1000                	addi	s0,sp,32
 336:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 33a:	4605                	li	a2,1
 33c:	fef40593          	addi	a1,s0,-17
 340:	f5fff0ef          	jal	ra,29e <write>
}
 344:	60e2                	ld	ra,24(sp)
 346:	6442                	ld	s0,16(sp)
 348:	6105                	addi	sp,sp,32
 34a:	8082                	ret

000000000000034c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 34c:	7139                	addi	sp,sp,-64
 34e:	fc06                	sd	ra,56(sp)
 350:	f822                	sd	s0,48(sp)
 352:	f426                	sd	s1,40(sp)
 354:	f04a                	sd	s2,32(sp)
 356:	ec4e                	sd	s3,24(sp)
 358:	0080                	addi	s0,sp,64
 35a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 35c:	c299                	beqz	a3,362 <printint+0x16>
 35e:	0805c663          	bltz	a1,3ea <printint+0x9e>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 362:	2581                	sext.w	a1,a1
  neg = 0;
 364:	4881                	li	a7,0
 366:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 36a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 36c:	2601                	sext.w	a2,a2
 36e:	00000517          	auipc	a0,0x0
 372:	4ca50513          	addi	a0,a0,1226 # 838 <digits>
 376:	883a                	mv	a6,a4
 378:	2705                	addiw	a4,a4,1
 37a:	02c5f7bb          	remuw	a5,a1,a2
 37e:	1782                	slli	a5,a5,0x20
 380:	9381                	srli	a5,a5,0x20
 382:	97aa                	add	a5,a5,a0
 384:	0007c783          	lbu	a5,0(a5)
 388:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 38c:	0005879b          	sext.w	a5,a1
 390:	02c5d5bb          	divuw	a1,a1,a2
 394:	0685                	addi	a3,a3,1
 396:	fec7f0e3          	bgeu	a5,a2,376 <printint+0x2a>
  if(neg)
 39a:	00088b63          	beqz	a7,3b0 <printint+0x64>
    buf[i++] = '-';
 39e:	fd040793          	addi	a5,s0,-48
 3a2:	973e                	add	a4,a4,a5
 3a4:	02d00793          	li	a5,45
 3a8:	fef70823          	sb	a5,-16(a4)
 3ac:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3b0:	02e05663          	blez	a4,3dc <printint+0x90>
 3b4:	fc040793          	addi	a5,s0,-64
 3b8:	00e78933          	add	s2,a5,a4
 3bc:	fff78993          	addi	s3,a5,-1
 3c0:	99ba                	add	s3,s3,a4
 3c2:	377d                	addiw	a4,a4,-1
 3c4:	1702                	slli	a4,a4,0x20
 3c6:	9301                	srli	a4,a4,0x20
 3c8:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 3cc:	fff94583          	lbu	a1,-1(s2)
 3d0:	8526                	mv	a0,s1
 3d2:	f5dff0ef          	jal	ra,32e <putc>
  while(--i >= 0)
 3d6:	197d                	addi	s2,s2,-1
 3d8:	ff391ae3          	bne	s2,s3,3cc <printint+0x80>
}
 3dc:	70e2                	ld	ra,56(sp)
 3de:	7442                	ld	s0,48(sp)
 3e0:	74a2                	ld	s1,40(sp)
 3e2:	7902                	ld	s2,32(sp)
 3e4:	69e2                	ld	s3,24(sp)
 3e6:	6121                	addi	sp,sp,64
 3e8:	8082                	ret
    x = -xx;
 3ea:	40b005bb          	negw	a1,a1
    neg = 1;
 3ee:	4885                	li	a7,1
    x = -xx;
 3f0:	bf9d                	j	366 <printint+0x1a>

00000000000003f2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 3f2:	7119                	addi	sp,sp,-128
 3f4:	fc86                	sd	ra,120(sp)
 3f6:	f8a2                	sd	s0,112(sp)
 3f8:	f4a6                	sd	s1,104(sp)
 3fa:	f0ca                	sd	s2,96(sp)
 3fc:	ecce                	sd	s3,88(sp)
 3fe:	e8d2                	sd	s4,80(sp)
 400:	e4d6                	sd	s5,72(sp)
 402:	e0da                	sd	s6,64(sp)
 404:	fc5e                	sd	s7,56(sp)
 406:	f862                	sd	s8,48(sp)
 408:	f466                	sd	s9,40(sp)
 40a:	f06a                	sd	s10,32(sp)
 40c:	ec6e                	sd	s11,24(sp)
 40e:	0100                	addi	s0,sp,128
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 410:	0005c903          	lbu	s2,0(a1)
 414:	22090e63          	beqz	s2,650 <vprintf+0x25e>
 418:	8b2a                	mv	s6,a0
 41a:	8a2e                	mv	s4,a1
 41c:	8bb2                	mv	s7,a2
  state = 0;
 41e:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 420:	4481                	li	s1,0
 422:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 424:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 428:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 42c:	06c00d13          	li	s10,108
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 430:	07500d93          	li	s11,117
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 434:	00000c97          	auipc	s9,0x0
 438:	404c8c93          	addi	s9,s9,1028 # 838 <digits>
 43c:	a005                	j	45c <vprintf+0x6a>
        putc(fd, c0);
 43e:	85ca                	mv	a1,s2
 440:	855a                	mv	a0,s6
 442:	eedff0ef          	jal	ra,32e <putc>
 446:	a019                	j	44c <vprintf+0x5a>
    } else if(state == '%'){
 448:	03598263          	beq	s3,s5,46c <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 44c:	2485                	addiw	s1,s1,1
 44e:	8726                	mv	a4,s1
 450:	009a07b3          	add	a5,s4,s1
 454:	0007c903          	lbu	s2,0(a5)
 458:	1e090c63          	beqz	s2,650 <vprintf+0x25e>
    c0 = fmt[i] & 0xff;
 45c:	0009079b          	sext.w	a5,s2
    if(state == 0){
 460:	fe0994e3          	bnez	s3,448 <vprintf+0x56>
      if(c0 == '%'){
 464:	fd579de3          	bne	a5,s5,43e <vprintf+0x4c>
        state = '%';
 468:	89be                	mv	s3,a5
 46a:	b7cd                	j	44c <vprintf+0x5a>
      if(c0) c1 = fmt[i+1] & 0xff;
 46c:	cfa5                	beqz	a5,4e4 <vprintf+0xf2>
 46e:	00ea06b3          	add	a3,s4,a4
 472:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 476:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 478:	c681                	beqz	a3,480 <vprintf+0x8e>
 47a:	9752                	add	a4,a4,s4
 47c:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 480:	03878a63          	beq	a5,s8,4b4 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 484:	05a78463          	beq	a5,s10,4cc <vprintf+0xda>
      } else if(c0 == 'u'){
 488:	0db78763          	beq	a5,s11,556 <vprintf+0x164>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 48c:	07800713          	li	a4,120
 490:	10e78963          	beq	a5,a4,5a2 <vprintf+0x1b0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 494:	07000713          	li	a4,112
 498:	12e78e63          	beq	a5,a4,5d4 <vprintf+0x1e2>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 49c:	07300713          	li	a4,115
 4a0:	16e78b63          	beq	a5,a4,616 <vprintf+0x224>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 4a4:	05579063          	bne	a5,s5,4e4 <vprintf+0xf2>
        putc(fd, '%');
 4a8:	85d6                	mv	a1,s5
 4aa:	855a                	mv	a0,s6
 4ac:	e83ff0ef          	jal	ra,32e <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 4b0:	4981                	li	s3,0
 4b2:	bf69                	j	44c <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 1);
 4b4:	008b8913          	addi	s2,s7,8
 4b8:	4685                	li	a3,1
 4ba:	4629                	li	a2,10
 4bc:	000ba583          	lw	a1,0(s7)
 4c0:	855a                	mv	a0,s6
 4c2:	e8bff0ef          	jal	ra,34c <printint>
 4c6:	8bca                	mv	s7,s2
      state = 0;
 4c8:	4981                	li	s3,0
 4ca:	b749                	j	44c <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'd'){
 4cc:	03868663          	beq	a3,s8,4f8 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 4d0:	05a68163          	beq	a3,s10,512 <vprintf+0x120>
      } else if(c0 == 'l' && c1 == 'u'){
 4d4:	09b68d63          	beq	a3,s11,56e <vprintf+0x17c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 4d8:	03a68f63          	beq	a3,s10,516 <vprintf+0x124>
      } else if(c0 == 'l' && c1 == 'x'){
 4dc:	07800793          	li	a5,120
 4e0:	0cf68d63          	beq	a3,a5,5ba <vprintf+0x1c8>
        putc(fd, '%');
 4e4:	85d6                	mv	a1,s5
 4e6:	855a                	mv	a0,s6
 4e8:	e47ff0ef          	jal	ra,32e <putc>
        putc(fd, c0);
 4ec:	85ca                	mv	a1,s2
 4ee:	855a                	mv	a0,s6
 4f0:	e3fff0ef          	jal	ra,32e <putc>
      state = 0;
 4f4:	4981                	li	s3,0
 4f6:	bf99                	j	44c <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 4f8:	008b8913          	addi	s2,s7,8
 4fc:	4685                	li	a3,1
 4fe:	4629                	li	a2,10
 500:	000ba583          	lw	a1,0(s7)
 504:	855a                	mv	a0,s6
 506:	e47ff0ef          	jal	ra,34c <printint>
        i += 1;
 50a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 50c:	8bca                	mv	s7,s2
      state = 0;
 50e:	4981                	li	s3,0
        i += 1;
 510:	bf35                	j	44c <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 512:	03860563          	beq	a2,s8,53c <vprintf+0x14a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 516:	07b60963          	beq	a2,s11,588 <vprintf+0x196>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 51a:	07800793          	li	a5,120
 51e:	fcf613e3          	bne	a2,a5,4e4 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 522:	008b8913          	addi	s2,s7,8
 526:	4681                	li	a3,0
 528:	4641                	li	a2,16
 52a:	000ba583          	lw	a1,0(s7)
 52e:	855a                	mv	a0,s6
 530:	e1dff0ef          	jal	ra,34c <printint>
        i += 2;
 534:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 536:	8bca                	mv	s7,s2
      state = 0;
 538:	4981                	li	s3,0
        i += 2;
 53a:	bf09                	j	44c <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 53c:	008b8913          	addi	s2,s7,8
 540:	4685                	li	a3,1
 542:	4629                	li	a2,10
 544:	000ba583          	lw	a1,0(s7)
 548:	855a                	mv	a0,s6
 54a:	e03ff0ef          	jal	ra,34c <printint>
        i += 2;
 54e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 550:	8bca                	mv	s7,s2
      state = 0;
 552:	4981                	li	s3,0
        i += 2;
 554:	bde5                	j	44c <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 0);
 556:	008b8913          	addi	s2,s7,8
 55a:	4681                	li	a3,0
 55c:	4629                	li	a2,10
 55e:	000ba583          	lw	a1,0(s7)
 562:	855a                	mv	a0,s6
 564:	de9ff0ef          	jal	ra,34c <printint>
 568:	8bca                	mv	s7,s2
      state = 0;
 56a:	4981                	li	s3,0
 56c:	b5c5                	j	44c <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 56e:	008b8913          	addi	s2,s7,8
 572:	4681                	li	a3,0
 574:	4629                	li	a2,10
 576:	000ba583          	lw	a1,0(s7)
 57a:	855a                	mv	a0,s6
 57c:	dd1ff0ef          	jal	ra,34c <printint>
        i += 1;
 580:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 582:	8bca                	mv	s7,s2
      state = 0;
 584:	4981                	li	s3,0
        i += 1;
 586:	b5d9                	j	44c <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 588:	008b8913          	addi	s2,s7,8
 58c:	4681                	li	a3,0
 58e:	4629                	li	a2,10
 590:	000ba583          	lw	a1,0(s7)
 594:	855a                	mv	a0,s6
 596:	db7ff0ef          	jal	ra,34c <printint>
        i += 2;
 59a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 59c:	8bca                	mv	s7,s2
      state = 0;
 59e:	4981                	li	s3,0
        i += 2;
 5a0:	b575                	j	44c <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 16, 0);
 5a2:	008b8913          	addi	s2,s7,8
 5a6:	4681                	li	a3,0
 5a8:	4641                	li	a2,16
 5aa:	000ba583          	lw	a1,0(s7)
 5ae:	855a                	mv	a0,s6
 5b0:	d9dff0ef          	jal	ra,34c <printint>
 5b4:	8bca                	mv	s7,s2
      state = 0;
 5b6:	4981                	li	s3,0
 5b8:	bd51                	j	44c <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5ba:	008b8913          	addi	s2,s7,8
 5be:	4681                	li	a3,0
 5c0:	4641                	li	a2,16
 5c2:	000ba583          	lw	a1,0(s7)
 5c6:	855a                	mv	a0,s6
 5c8:	d85ff0ef          	jal	ra,34c <printint>
        i += 1;
 5cc:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 5ce:	8bca                	mv	s7,s2
      state = 0;
 5d0:	4981                	li	s3,0
        i += 1;
 5d2:	bdad                	j	44c <vprintf+0x5a>
        printptr(fd, va_arg(ap, uint64));
 5d4:	008b8793          	addi	a5,s7,8
 5d8:	f8f43423          	sd	a5,-120(s0)
 5dc:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5e0:	03000593          	li	a1,48
 5e4:	855a                	mv	a0,s6
 5e6:	d49ff0ef          	jal	ra,32e <putc>
  putc(fd, 'x');
 5ea:	07800593          	li	a1,120
 5ee:	855a                	mv	a0,s6
 5f0:	d3fff0ef          	jal	ra,32e <putc>
 5f4:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5f6:	03c9d793          	srli	a5,s3,0x3c
 5fa:	97e6                	add	a5,a5,s9
 5fc:	0007c583          	lbu	a1,0(a5)
 600:	855a                	mv	a0,s6
 602:	d2dff0ef          	jal	ra,32e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 606:	0992                	slli	s3,s3,0x4
 608:	397d                	addiw	s2,s2,-1
 60a:	fe0916e3          	bnez	s2,5f6 <vprintf+0x204>
        printptr(fd, va_arg(ap, uint64));
 60e:	f8843b83          	ld	s7,-120(s0)
      state = 0;
 612:	4981                	li	s3,0
 614:	bd25                	j	44c <vprintf+0x5a>
        if((s = va_arg(ap, char*)) == 0)
 616:	008b8993          	addi	s3,s7,8
 61a:	000bb903          	ld	s2,0(s7)
 61e:	00090f63          	beqz	s2,63c <vprintf+0x24a>
        for(; *s; s++)
 622:	00094583          	lbu	a1,0(s2)
 626:	c195                	beqz	a1,64a <vprintf+0x258>
          putc(fd, *s);
 628:	855a                	mv	a0,s6
 62a:	d05ff0ef          	jal	ra,32e <putc>
        for(; *s; s++)
 62e:	0905                	addi	s2,s2,1
 630:	00094583          	lbu	a1,0(s2)
 634:	f9f5                	bnez	a1,628 <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 636:	8bce                	mv	s7,s3
      state = 0;
 638:	4981                	li	s3,0
 63a:	bd09                	j	44c <vprintf+0x5a>
          s = "(null)";
 63c:	00000917          	auipc	s2,0x0
 640:	1f490913          	addi	s2,s2,500 # 830 <malloc+0xde>
        for(; *s; s++)
 644:	02800593          	li	a1,40
 648:	b7c5                	j	628 <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 64a:	8bce                	mv	s7,s3
      state = 0;
 64c:	4981                	li	s3,0
 64e:	bbfd                	j	44c <vprintf+0x5a>
    }
  }
}
 650:	70e6                	ld	ra,120(sp)
 652:	7446                	ld	s0,112(sp)
 654:	74a6                	ld	s1,104(sp)
 656:	7906                	ld	s2,96(sp)
 658:	69e6                	ld	s3,88(sp)
 65a:	6a46                	ld	s4,80(sp)
 65c:	6aa6                	ld	s5,72(sp)
 65e:	6b06                	ld	s6,64(sp)
 660:	7be2                	ld	s7,56(sp)
 662:	7c42                	ld	s8,48(sp)
 664:	7ca2                	ld	s9,40(sp)
 666:	7d02                	ld	s10,32(sp)
 668:	6de2                	ld	s11,24(sp)
 66a:	6109                	addi	sp,sp,128
 66c:	8082                	ret

000000000000066e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 66e:	715d                	addi	sp,sp,-80
 670:	ec06                	sd	ra,24(sp)
 672:	e822                	sd	s0,16(sp)
 674:	1000                	addi	s0,sp,32
 676:	e010                	sd	a2,0(s0)
 678:	e414                	sd	a3,8(s0)
 67a:	e818                	sd	a4,16(s0)
 67c:	ec1c                	sd	a5,24(s0)
 67e:	03043023          	sd	a6,32(s0)
 682:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 686:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 68a:	8622                	mv	a2,s0
 68c:	d67ff0ef          	jal	ra,3f2 <vprintf>
}
 690:	60e2                	ld	ra,24(sp)
 692:	6442                	ld	s0,16(sp)
 694:	6161                	addi	sp,sp,80
 696:	8082                	ret

0000000000000698 <printf>:

void
printf(const char *fmt, ...)
{
 698:	711d                	addi	sp,sp,-96
 69a:	ec06                	sd	ra,24(sp)
 69c:	e822                	sd	s0,16(sp)
 69e:	1000                	addi	s0,sp,32
 6a0:	e40c                	sd	a1,8(s0)
 6a2:	e810                	sd	a2,16(s0)
 6a4:	ec14                	sd	a3,24(s0)
 6a6:	f018                	sd	a4,32(s0)
 6a8:	f41c                	sd	a5,40(s0)
 6aa:	03043823          	sd	a6,48(s0)
 6ae:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6b2:	00840613          	addi	a2,s0,8
 6b6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6ba:	85aa                	mv	a1,a0
 6bc:	4505                	li	a0,1
 6be:	d35ff0ef          	jal	ra,3f2 <vprintf>
}
 6c2:	60e2                	ld	ra,24(sp)
 6c4:	6442                	ld	s0,16(sp)
 6c6:	6125                	addi	sp,sp,96
 6c8:	8082                	ret

00000000000006ca <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6ca:	1141                	addi	sp,sp,-16
 6cc:	e422                	sd	s0,8(sp)
 6ce:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6d0:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6d4:	00001797          	auipc	a5,0x1
 6d8:	92c7b783          	ld	a5,-1748(a5) # 1000 <freep>
 6dc:	a805                	j	70c <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6de:	4618                	lw	a4,8(a2)
 6e0:	9db9                	addw	a1,a1,a4
 6e2:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6e6:	6398                	ld	a4,0(a5)
 6e8:	6318                	ld	a4,0(a4)
 6ea:	fee53823          	sd	a4,-16(a0)
 6ee:	a091                	j	732 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6f0:	ff852703          	lw	a4,-8(a0)
 6f4:	9e39                	addw	a2,a2,a4
 6f6:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 6f8:	ff053703          	ld	a4,-16(a0)
 6fc:	e398                	sd	a4,0(a5)
 6fe:	a099                	j	744 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 700:	6398                	ld	a4,0(a5)
 702:	00e7e463          	bltu	a5,a4,70a <free+0x40>
 706:	00e6ea63          	bltu	a3,a4,71a <free+0x50>
{
 70a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 70c:	fed7fae3          	bgeu	a5,a3,700 <free+0x36>
 710:	6398                	ld	a4,0(a5)
 712:	00e6e463          	bltu	a3,a4,71a <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 716:	fee7eae3          	bltu	a5,a4,70a <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 71a:	ff852583          	lw	a1,-8(a0)
 71e:	6390                	ld	a2,0(a5)
 720:	02059713          	slli	a4,a1,0x20
 724:	9301                	srli	a4,a4,0x20
 726:	0712                	slli	a4,a4,0x4
 728:	9736                	add	a4,a4,a3
 72a:	fae60ae3          	beq	a2,a4,6de <free+0x14>
    bp->s.ptr = p->s.ptr;
 72e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 732:	4790                	lw	a2,8(a5)
 734:	02061713          	slli	a4,a2,0x20
 738:	9301                	srli	a4,a4,0x20
 73a:	0712                	slli	a4,a4,0x4
 73c:	973e                	add	a4,a4,a5
 73e:	fae689e3          	beq	a3,a4,6f0 <free+0x26>
  } else
    p->s.ptr = bp;
 742:	e394                	sd	a3,0(a5)
  freep = p;
 744:	00001717          	auipc	a4,0x1
 748:	8af73e23          	sd	a5,-1860(a4) # 1000 <freep>
}
 74c:	6422                	ld	s0,8(sp)
 74e:	0141                	addi	sp,sp,16
 750:	8082                	ret

0000000000000752 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 752:	7139                	addi	sp,sp,-64
 754:	fc06                	sd	ra,56(sp)
 756:	f822                	sd	s0,48(sp)
 758:	f426                	sd	s1,40(sp)
 75a:	f04a                	sd	s2,32(sp)
 75c:	ec4e                	sd	s3,24(sp)
 75e:	e852                	sd	s4,16(sp)
 760:	e456                	sd	s5,8(sp)
 762:	e05a                	sd	s6,0(sp)
 764:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 766:	02051493          	slli	s1,a0,0x20
 76a:	9081                	srli	s1,s1,0x20
 76c:	04bd                	addi	s1,s1,15
 76e:	8091                	srli	s1,s1,0x4
 770:	0014899b          	addiw	s3,s1,1
 774:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 776:	00001517          	auipc	a0,0x1
 77a:	88a53503          	ld	a0,-1910(a0) # 1000 <freep>
 77e:	c515                	beqz	a0,7aa <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 780:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 782:	4798                	lw	a4,8(a5)
 784:	02977f63          	bgeu	a4,s1,7c2 <malloc+0x70>
 788:	8a4e                	mv	s4,s3
 78a:	0009871b          	sext.w	a4,s3
 78e:	6685                	lui	a3,0x1
 790:	00d77363          	bgeu	a4,a3,796 <malloc+0x44>
 794:	6a05                	lui	s4,0x1
 796:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 79a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 79e:	00001917          	auipc	s2,0x1
 7a2:	86290913          	addi	s2,s2,-1950 # 1000 <freep>
  if(p == (char*)-1)
 7a6:	5afd                	li	s5,-1
 7a8:	a0bd                	j	816 <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
 7aa:	00001797          	auipc	a5,0x1
 7ae:	86678793          	addi	a5,a5,-1946 # 1010 <base>
 7b2:	00001717          	auipc	a4,0x1
 7b6:	84f73723          	sd	a5,-1970(a4) # 1000 <freep>
 7ba:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7bc:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7c0:	b7e1                	j	788 <malloc+0x36>
      if(p->s.size == nunits)
 7c2:	02e48b63          	beq	s1,a4,7f8 <malloc+0xa6>
        p->s.size -= nunits;
 7c6:	4137073b          	subw	a4,a4,s3
 7ca:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7cc:	1702                	slli	a4,a4,0x20
 7ce:	9301                	srli	a4,a4,0x20
 7d0:	0712                	slli	a4,a4,0x4
 7d2:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7d4:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7d8:	00001717          	auipc	a4,0x1
 7dc:	82a73423          	sd	a0,-2008(a4) # 1000 <freep>
      return (void*)(p + 1);
 7e0:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7e4:	70e2                	ld	ra,56(sp)
 7e6:	7442                	ld	s0,48(sp)
 7e8:	74a2                	ld	s1,40(sp)
 7ea:	7902                	ld	s2,32(sp)
 7ec:	69e2                	ld	s3,24(sp)
 7ee:	6a42                	ld	s4,16(sp)
 7f0:	6aa2                	ld	s5,8(sp)
 7f2:	6b02                	ld	s6,0(sp)
 7f4:	6121                	addi	sp,sp,64
 7f6:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 7f8:	6398                	ld	a4,0(a5)
 7fa:	e118                	sd	a4,0(a0)
 7fc:	bff1                	j	7d8 <malloc+0x86>
  hp->s.size = nu;
 7fe:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 802:	0541                	addi	a0,a0,16
 804:	ec7ff0ef          	jal	ra,6ca <free>
  return freep;
 808:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 80c:	dd61                	beqz	a0,7e4 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 80e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 810:	4798                	lw	a4,8(a5)
 812:	fa9778e3          	bgeu	a4,s1,7c2 <malloc+0x70>
    if(p == freep)
 816:	00093703          	ld	a4,0(s2)
 81a:	853e                	mv	a0,a5
 81c:	fef719e3          	bne	a4,a5,80e <malloc+0xbc>
  p = sbrk(nu * sizeof(Header));
 820:	8552                	mv	a0,s4
 822:	ae5ff0ef          	jal	ra,306 <sbrk>
  if(p == (char*)-1)
 826:	fd551ce3          	bne	a0,s5,7fe <malloc+0xac>
        return 0;
 82a:	4501                	li	a0,0
 82c:	bf65                	j	7e4 <malloc+0x92>
