
user/_tee:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/fcntl.h"

#define BUF_SIZE 512

int main(int argc, char *argv[])
{
   0:	de010113          	addi	sp,sp,-544
   4:	20113c23          	sd	ra,536(sp)
   8:	20813823          	sd	s0,528(sp)
   c:	20913423          	sd	s1,520(sp)
  10:	21213023          	sd	s2,512(sp)
  14:	1400                	addi	s0,sp,544
  if (argc < 2)
  16:	4785                	li	a5,1
  18:	02a7d663          	bge	a5,a0,44 <main+0x44>
  1c:	84ae                	mv	s1,a1
  {
    fprintf(2, "Usage: tee <file>\n");
    exit(1);
  }

  int fd = open(argv[1], O_CREATE | O_WRONLY);
  1e:	20100593          	li	a1,513
  22:	6488                	ld	a0,8(s1)
  24:	32c000ef          	jal	ra,350 <open>
  28:	892a                	mv	s2,a0
  if (fd < 0)
  2a:	04055363          	bgez	a0,70 <main+0x70>
  {
    fprintf(2, "tee: cannot open %s\n", argv[1]);
  2e:	6490                	ld	a2,8(s1)
  30:	00001597          	auipc	a1,0x1
  34:	8a858593          	addi	a1,a1,-1880 # 8d8 <malloc+0xf4>
  38:	4509                	li	a0,2
  3a:	6c6000ef          	jal	ra,700 <fprintf>
    exit(1);
  3e:	4505                	li	a0,1
  40:	2d0000ef          	jal	ra,310 <exit>
    fprintf(2, "Usage: tee <file>\n");
  44:	00001597          	auipc	a1,0x1
  48:	87c58593          	addi	a1,a1,-1924 # 8c0 <malloc+0xdc>
  4c:	4509                	li	a0,2
  4e:	6b2000ef          	jal	ra,700 <fprintf>
    exit(1);
  52:	4505                	li	a0,1
  54:	2bc000ef          	jal	ra,310 <exit>
  char buf[BUF_SIZE];
  int n;
  while ((n = read(0, buf, sizeof(buf))) > 0)
  {
    // write stdout
    write(1, buf, n);
  58:	8626                	mv	a2,s1
  5a:	de040593          	addi	a1,s0,-544
  5e:	4505                	li	a0,1
  60:	2d0000ef          	jal	ra,330 <write>
    // write file
    write(fd, buf, n);
  64:	8626                	mv	a2,s1
  66:	de040593          	addi	a1,s0,-544
  6a:	854a                	mv	a0,s2
  6c:	2c4000ef          	jal	ra,330 <write>
  while ((n = read(0, buf, sizeof(buf))) > 0)
  70:	20000613          	li	a2,512
  74:	de040593          	addi	a1,s0,-544
  78:	4501                	li	a0,0
  7a:	2ae000ef          	jal	ra,328 <read>
  7e:	84aa                	mv	s1,a0
  80:	fca04ce3          	bgtz	a0,58 <main+0x58>
  }

  if (n < 0)
  84:	00054863          	bltz	a0,94 <main+0x94>
  {
    fprintf(2, "tee: read error\n");
  }

  close(fd);
  88:	854a                	mv	a0,s2
  8a:	2ae000ef          	jal	ra,338 <close>
  exit(0);
  8e:	4501                	li	a0,0
  90:	280000ef          	jal	ra,310 <exit>
    fprintf(2, "tee: read error\n");
  94:	00001597          	auipc	a1,0x1
  98:	85c58593          	addi	a1,a1,-1956 # 8f0 <malloc+0x10c>
  9c:	4509                	li	a0,2
  9e:	662000ef          	jal	ra,700 <fprintf>
  a2:	b7dd                	j	88 <main+0x88>

00000000000000a4 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  a4:	1141                	addi	sp,sp,-16
  a6:	e406                	sd	ra,8(sp)
  a8:	e022                	sd	s0,0(sp)
  aa:	0800                	addi	s0,sp,16
  extern int main();
  main();
  ac:	f55ff0ef          	jal	ra,0 <main>
  exit(0);
  b0:	4501                	li	a0,0
  b2:	25e000ef          	jal	ra,310 <exit>

00000000000000b6 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  b6:	1141                	addi	sp,sp,-16
  b8:	e422                	sd	s0,8(sp)
  ba:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  bc:	87aa                	mv	a5,a0
  be:	0585                	addi	a1,a1,1
  c0:	0785                	addi	a5,a5,1
  c2:	fff5c703          	lbu	a4,-1(a1)
  c6:	fee78fa3          	sb	a4,-1(a5)
  ca:	fb75                	bnez	a4,be <strcpy+0x8>
    ;
  return os;
}
  cc:	6422                	ld	s0,8(sp)
  ce:	0141                	addi	sp,sp,16
  d0:	8082                	ret

00000000000000d2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  d2:	1141                	addi	sp,sp,-16
  d4:	e422                	sd	s0,8(sp)
  d6:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  d8:	00054783          	lbu	a5,0(a0)
  dc:	cb91                	beqz	a5,f0 <strcmp+0x1e>
  de:	0005c703          	lbu	a4,0(a1)
  e2:	00f71763          	bne	a4,a5,f0 <strcmp+0x1e>
    p++, q++;
  e6:	0505                	addi	a0,a0,1
  e8:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  ea:	00054783          	lbu	a5,0(a0)
  ee:	fbe5                	bnez	a5,de <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  f0:	0005c503          	lbu	a0,0(a1)
}
  f4:	40a7853b          	subw	a0,a5,a0
  f8:	6422                	ld	s0,8(sp)
  fa:	0141                	addi	sp,sp,16
  fc:	8082                	ret

00000000000000fe <strlen>:

uint
strlen(const char *s)
{
  fe:	1141                	addi	sp,sp,-16
 100:	e422                	sd	s0,8(sp)
 102:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 104:	00054783          	lbu	a5,0(a0)
 108:	cf91                	beqz	a5,124 <strlen+0x26>
 10a:	0505                	addi	a0,a0,1
 10c:	87aa                	mv	a5,a0
 10e:	4685                	li	a3,1
 110:	9e89                	subw	a3,a3,a0
 112:	00f6853b          	addw	a0,a3,a5
 116:	0785                	addi	a5,a5,1
 118:	fff7c703          	lbu	a4,-1(a5)
 11c:	fb7d                	bnez	a4,112 <strlen+0x14>
    ;
  return n;
}
 11e:	6422                	ld	s0,8(sp)
 120:	0141                	addi	sp,sp,16
 122:	8082                	ret
  for(n = 0; s[n]; n++)
 124:	4501                	li	a0,0
 126:	bfe5                	j	11e <strlen+0x20>

0000000000000128 <memset>:

void*
memset(void *dst, int c, uint n)
{
 128:	1141                	addi	sp,sp,-16
 12a:	e422                	sd	s0,8(sp)
 12c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 12e:	ca19                	beqz	a2,144 <memset+0x1c>
 130:	87aa                	mv	a5,a0
 132:	1602                	slli	a2,a2,0x20
 134:	9201                	srli	a2,a2,0x20
 136:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 13a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 13e:	0785                	addi	a5,a5,1
 140:	fee79de3          	bne	a5,a4,13a <memset+0x12>
  }
  return dst;
}
 144:	6422                	ld	s0,8(sp)
 146:	0141                	addi	sp,sp,16
 148:	8082                	ret

000000000000014a <strchr>:

char*
strchr(const char *s, char c)
{
 14a:	1141                	addi	sp,sp,-16
 14c:	e422                	sd	s0,8(sp)
 14e:	0800                	addi	s0,sp,16
  for(; *s; s++)
 150:	00054783          	lbu	a5,0(a0)
 154:	cb99                	beqz	a5,16a <strchr+0x20>
    if(*s == c)
 156:	00f58763          	beq	a1,a5,164 <strchr+0x1a>
  for(; *s; s++)
 15a:	0505                	addi	a0,a0,1
 15c:	00054783          	lbu	a5,0(a0)
 160:	fbfd                	bnez	a5,156 <strchr+0xc>
      return (char*)s;
  return 0;
 162:	4501                	li	a0,0
}
 164:	6422                	ld	s0,8(sp)
 166:	0141                	addi	sp,sp,16
 168:	8082                	ret
  return 0;
 16a:	4501                	li	a0,0
 16c:	bfe5                	j	164 <strchr+0x1a>

000000000000016e <gets>:

char*
gets(char *buf, int max)
{
 16e:	711d                	addi	sp,sp,-96
 170:	ec86                	sd	ra,88(sp)
 172:	e8a2                	sd	s0,80(sp)
 174:	e4a6                	sd	s1,72(sp)
 176:	e0ca                	sd	s2,64(sp)
 178:	fc4e                	sd	s3,56(sp)
 17a:	f852                	sd	s4,48(sp)
 17c:	f456                	sd	s5,40(sp)
 17e:	f05a                	sd	s6,32(sp)
 180:	ec5e                	sd	s7,24(sp)
 182:	1080                	addi	s0,sp,96
 184:	8baa                	mv	s7,a0
 186:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 188:	892a                	mv	s2,a0
 18a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 18c:	4aa9                	li	s5,10
 18e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 190:	89a6                	mv	s3,s1
 192:	2485                	addiw	s1,s1,1
 194:	0344d663          	bge	s1,s4,1c0 <gets+0x52>
    cc = read(0, &c, 1);
 198:	4605                	li	a2,1
 19a:	faf40593          	addi	a1,s0,-81
 19e:	4501                	li	a0,0
 1a0:	188000ef          	jal	ra,328 <read>
    if(cc < 1)
 1a4:	00a05e63          	blez	a0,1c0 <gets+0x52>
    buf[i++] = c;
 1a8:	faf44783          	lbu	a5,-81(s0)
 1ac:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1b0:	01578763          	beq	a5,s5,1be <gets+0x50>
 1b4:	0905                	addi	s2,s2,1
 1b6:	fd679de3          	bne	a5,s6,190 <gets+0x22>
  for(i=0; i+1 < max; ){
 1ba:	89a6                	mv	s3,s1
 1bc:	a011                	j	1c0 <gets+0x52>
 1be:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1c0:	99de                	add	s3,s3,s7
 1c2:	00098023          	sb	zero,0(s3)
  return buf;
}
 1c6:	855e                	mv	a0,s7
 1c8:	60e6                	ld	ra,88(sp)
 1ca:	6446                	ld	s0,80(sp)
 1cc:	64a6                	ld	s1,72(sp)
 1ce:	6906                	ld	s2,64(sp)
 1d0:	79e2                	ld	s3,56(sp)
 1d2:	7a42                	ld	s4,48(sp)
 1d4:	7aa2                	ld	s5,40(sp)
 1d6:	7b02                	ld	s6,32(sp)
 1d8:	6be2                	ld	s7,24(sp)
 1da:	6125                	addi	sp,sp,96
 1dc:	8082                	ret

00000000000001de <stat>:

int
stat(const char *n, struct stat *st)
{
 1de:	1101                	addi	sp,sp,-32
 1e0:	ec06                	sd	ra,24(sp)
 1e2:	e822                	sd	s0,16(sp)
 1e4:	e426                	sd	s1,8(sp)
 1e6:	e04a                	sd	s2,0(sp)
 1e8:	1000                	addi	s0,sp,32
 1ea:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1ec:	4581                	li	a1,0
 1ee:	162000ef          	jal	ra,350 <open>
  if(fd < 0)
 1f2:	02054163          	bltz	a0,214 <stat+0x36>
 1f6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1f8:	85ca                	mv	a1,s2
 1fa:	16e000ef          	jal	ra,368 <fstat>
 1fe:	892a                	mv	s2,a0
  close(fd);
 200:	8526                	mv	a0,s1
 202:	136000ef          	jal	ra,338 <close>
  return r;
}
 206:	854a                	mv	a0,s2
 208:	60e2                	ld	ra,24(sp)
 20a:	6442                	ld	s0,16(sp)
 20c:	64a2                	ld	s1,8(sp)
 20e:	6902                	ld	s2,0(sp)
 210:	6105                	addi	sp,sp,32
 212:	8082                	ret
    return -1;
 214:	597d                	li	s2,-1
 216:	bfc5                	j	206 <stat+0x28>

0000000000000218 <atoi>:

int
atoi(const char *s)
{
 218:	1141                	addi	sp,sp,-16
 21a:	e422                	sd	s0,8(sp)
 21c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 21e:	00054603          	lbu	a2,0(a0)
 222:	fd06079b          	addiw	a5,a2,-48
 226:	0ff7f793          	andi	a5,a5,255
 22a:	4725                	li	a4,9
 22c:	02f76963          	bltu	a4,a5,25e <atoi+0x46>
 230:	86aa                	mv	a3,a0
  n = 0;
 232:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 234:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 236:	0685                	addi	a3,a3,1
 238:	0025179b          	slliw	a5,a0,0x2
 23c:	9fa9                	addw	a5,a5,a0
 23e:	0017979b          	slliw	a5,a5,0x1
 242:	9fb1                	addw	a5,a5,a2
 244:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 248:	0006c603          	lbu	a2,0(a3)
 24c:	fd06071b          	addiw	a4,a2,-48
 250:	0ff77713          	andi	a4,a4,255
 254:	fee5f1e3          	bgeu	a1,a4,236 <atoi+0x1e>
  return n;
}
 258:	6422                	ld	s0,8(sp)
 25a:	0141                	addi	sp,sp,16
 25c:	8082                	ret
  n = 0;
 25e:	4501                	li	a0,0
 260:	bfe5                	j	258 <atoi+0x40>

0000000000000262 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 262:	1141                	addi	sp,sp,-16
 264:	e422                	sd	s0,8(sp)
 266:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 268:	02b57463          	bgeu	a0,a1,290 <memmove+0x2e>
    while(n-- > 0)
 26c:	00c05f63          	blez	a2,28a <memmove+0x28>
 270:	1602                	slli	a2,a2,0x20
 272:	9201                	srli	a2,a2,0x20
 274:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 278:	872a                	mv	a4,a0
      *dst++ = *src++;
 27a:	0585                	addi	a1,a1,1
 27c:	0705                	addi	a4,a4,1
 27e:	fff5c683          	lbu	a3,-1(a1)
 282:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 286:	fee79ae3          	bne	a5,a4,27a <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 28a:	6422                	ld	s0,8(sp)
 28c:	0141                	addi	sp,sp,16
 28e:	8082                	ret
    dst += n;
 290:	00c50733          	add	a4,a0,a2
    src += n;
 294:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 296:	fec05ae3          	blez	a2,28a <memmove+0x28>
 29a:	fff6079b          	addiw	a5,a2,-1
 29e:	1782                	slli	a5,a5,0x20
 2a0:	9381                	srli	a5,a5,0x20
 2a2:	fff7c793          	not	a5,a5
 2a6:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2a8:	15fd                	addi	a1,a1,-1
 2aa:	177d                	addi	a4,a4,-1
 2ac:	0005c683          	lbu	a3,0(a1)
 2b0:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2b4:	fee79ae3          	bne	a5,a4,2a8 <memmove+0x46>
 2b8:	bfc9                	j	28a <memmove+0x28>

00000000000002ba <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2ba:	1141                	addi	sp,sp,-16
 2bc:	e422                	sd	s0,8(sp)
 2be:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2c0:	ca05                	beqz	a2,2f0 <memcmp+0x36>
 2c2:	fff6069b          	addiw	a3,a2,-1
 2c6:	1682                	slli	a3,a3,0x20
 2c8:	9281                	srli	a3,a3,0x20
 2ca:	0685                	addi	a3,a3,1
 2cc:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2ce:	00054783          	lbu	a5,0(a0)
 2d2:	0005c703          	lbu	a4,0(a1)
 2d6:	00e79863          	bne	a5,a4,2e6 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2da:	0505                	addi	a0,a0,1
    p2++;
 2dc:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2de:	fed518e3          	bne	a0,a3,2ce <memcmp+0x14>
  }
  return 0;
 2e2:	4501                	li	a0,0
 2e4:	a019                	j	2ea <memcmp+0x30>
      return *p1 - *p2;
 2e6:	40e7853b          	subw	a0,a5,a4
}
 2ea:	6422                	ld	s0,8(sp)
 2ec:	0141                	addi	sp,sp,16
 2ee:	8082                	ret
  return 0;
 2f0:	4501                	li	a0,0
 2f2:	bfe5                	j	2ea <memcmp+0x30>

00000000000002f4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2f4:	1141                	addi	sp,sp,-16
 2f6:	e406                	sd	ra,8(sp)
 2f8:	e022                	sd	s0,0(sp)
 2fa:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2fc:	f67ff0ef          	jal	ra,262 <memmove>
}
 300:	60a2                	ld	ra,8(sp)
 302:	6402                	ld	s0,0(sp)
 304:	0141                	addi	sp,sp,16
 306:	8082                	ret

0000000000000308 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 308:	4885                	li	a7,1
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <exit>:
.global exit
exit:
 li a7, SYS_exit
 310:	4889                	li	a7,2
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <wait>:
.global wait
wait:
 li a7, SYS_wait
 318:	488d                	li	a7,3
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 320:	4891                	li	a7,4
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <read>:
.global read
read:
 li a7, SYS_read
 328:	4895                	li	a7,5
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <write>:
.global write
write:
 li a7, SYS_write
 330:	48c1                	li	a7,16
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <close>:
.global close
close:
 li a7, SYS_close
 338:	48d5                	li	a7,21
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <kill>:
.global kill
kill:
 li a7, SYS_kill
 340:	4899                	li	a7,6
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <exec>:
.global exec
exec:
 li a7, SYS_exec
 348:	489d                	li	a7,7
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <open>:
.global open
open:
 li a7, SYS_open
 350:	48bd                	li	a7,15
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 358:	48c5                	li	a7,17
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 360:	48c9                	li	a7,18
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 368:	48a1                	li	a7,8
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <link>:
.global link
link:
 li a7, SYS_link
 370:	48cd                	li	a7,19
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 378:	48d1                	li	a7,20
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 380:	48a5                	li	a7,9
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <dup>:
.global dup
dup:
 li a7, SYS_dup
 388:	48a9                	li	a7,10
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 390:	48ad                	li	a7,11
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 398:	48b1                	li	a7,12
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3a0:	48b5                	li	a7,13
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3a8:	48b9                	li	a7,14
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <debugswitch>:
.global debugswitch
debugswitch:
 li a7, SYS_debugswitch
 3b0:	48d9                	li	a7,22
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <printfslab>:
.global printfslab
printfslab:
 li a7, SYS_printfslab
 3b8:	48dd                	li	a7,23
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3c0:	1101                	addi	sp,sp,-32
 3c2:	ec06                	sd	ra,24(sp)
 3c4:	e822                	sd	s0,16(sp)
 3c6:	1000                	addi	s0,sp,32
 3c8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3cc:	4605                	li	a2,1
 3ce:	fef40593          	addi	a1,s0,-17
 3d2:	f5fff0ef          	jal	ra,330 <write>
}
 3d6:	60e2                	ld	ra,24(sp)
 3d8:	6442                	ld	s0,16(sp)
 3da:	6105                	addi	sp,sp,32
 3dc:	8082                	ret

00000000000003de <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3de:	7139                	addi	sp,sp,-64
 3e0:	fc06                	sd	ra,56(sp)
 3e2:	f822                	sd	s0,48(sp)
 3e4:	f426                	sd	s1,40(sp)
 3e6:	f04a                	sd	s2,32(sp)
 3e8:	ec4e                	sd	s3,24(sp)
 3ea:	0080                	addi	s0,sp,64
 3ec:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3ee:	c299                	beqz	a3,3f4 <printint+0x16>
 3f0:	0805c663          	bltz	a1,47c <printint+0x9e>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3f4:	2581                	sext.w	a1,a1
  neg = 0;
 3f6:	4881                	li	a7,0
 3f8:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3fc:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3fe:	2601                	sext.w	a2,a2
 400:	00000517          	auipc	a0,0x0
 404:	51050513          	addi	a0,a0,1296 # 910 <digits>
 408:	883a                	mv	a6,a4
 40a:	2705                	addiw	a4,a4,1
 40c:	02c5f7bb          	remuw	a5,a1,a2
 410:	1782                	slli	a5,a5,0x20
 412:	9381                	srli	a5,a5,0x20
 414:	97aa                	add	a5,a5,a0
 416:	0007c783          	lbu	a5,0(a5)
 41a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 41e:	0005879b          	sext.w	a5,a1
 422:	02c5d5bb          	divuw	a1,a1,a2
 426:	0685                	addi	a3,a3,1
 428:	fec7f0e3          	bgeu	a5,a2,408 <printint+0x2a>
  if(neg)
 42c:	00088b63          	beqz	a7,442 <printint+0x64>
    buf[i++] = '-';
 430:	fd040793          	addi	a5,s0,-48
 434:	973e                	add	a4,a4,a5
 436:	02d00793          	li	a5,45
 43a:	fef70823          	sb	a5,-16(a4)
 43e:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 442:	02e05663          	blez	a4,46e <printint+0x90>
 446:	fc040793          	addi	a5,s0,-64
 44a:	00e78933          	add	s2,a5,a4
 44e:	fff78993          	addi	s3,a5,-1
 452:	99ba                	add	s3,s3,a4
 454:	377d                	addiw	a4,a4,-1
 456:	1702                	slli	a4,a4,0x20
 458:	9301                	srli	a4,a4,0x20
 45a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 45e:	fff94583          	lbu	a1,-1(s2)
 462:	8526                	mv	a0,s1
 464:	f5dff0ef          	jal	ra,3c0 <putc>
  while(--i >= 0)
 468:	197d                	addi	s2,s2,-1
 46a:	ff391ae3          	bne	s2,s3,45e <printint+0x80>
}
 46e:	70e2                	ld	ra,56(sp)
 470:	7442                	ld	s0,48(sp)
 472:	74a2                	ld	s1,40(sp)
 474:	7902                	ld	s2,32(sp)
 476:	69e2                	ld	s3,24(sp)
 478:	6121                	addi	sp,sp,64
 47a:	8082                	ret
    x = -xx;
 47c:	40b005bb          	negw	a1,a1
    neg = 1;
 480:	4885                	li	a7,1
    x = -xx;
 482:	bf9d                	j	3f8 <printint+0x1a>

0000000000000484 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 484:	7119                	addi	sp,sp,-128
 486:	fc86                	sd	ra,120(sp)
 488:	f8a2                	sd	s0,112(sp)
 48a:	f4a6                	sd	s1,104(sp)
 48c:	f0ca                	sd	s2,96(sp)
 48e:	ecce                	sd	s3,88(sp)
 490:	e8d2                	sd	s4,80(sp)
 492:	e4d6                	sd	s5,72(sp)
 494:	e0da                	sd	s6,64(sp)
 496:	fc5e                	sd	s7,56(sp)
 498:	f862                	sd	s8,48(sp)
 49a:	f466                	sd	s9,40(sp)
 49c:	f06a                	sd	s10,32(sp)
 49e:	ec6e                	sd	s11,24(sp)
 4a0:	0100                	addi	s0,sp,128
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4a2:	0005c903          	lbu	s2,0(a1)
 4a6:	22090e63          	beqz	s2,6e2 <vprintf+0x25e>
 4aa:	8b2a                	mv	s6,a0
 4ac:	8a2e                	mv	s4,a1
 4ae:	8bb2                	mv	s7,a2
  state = 0;
 4b0:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4b2:	4481                	li	s1,0
 4b4:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4b6:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4ba:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4be:	06c00d13          	li	s10,108
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 4c2:	07500d93          	li	s11,117
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4c6:	00000c97          	auipc	s9,0x0
 4ca:	44ac8c93          	addi	s9,s9,1098 # 910 <digits>
 4ce:	a005                	j	4ee <vprintf+0x6a>
        putc(fd, c0);
 4d0:	85ca                	mv	a1,s2
 4d2:	855a                	mv	a0,s6
 4d4:	eedff0ef          	jal	ra,3c0 <putc>
 4d8:	a019                	j	4de <vprintf+0x5a>
    } else if(state == '%'){
 4da:	03598263          	beq	s3,s5,4fe <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 4de:	2485                	addiw	s1,s1,1
 4e0:	8726                	mv	a4,s1
 4e2:	009a07b3          	add	a5,s4,s1
 4e6:	0007c903          	lbu	s2,0(a5)
 4ea:	1e090c63          	beqz	s2,6e2 <vprintf+0x25e>
    c0 = fmt[i] & 0xff;
 4ee:	0009079b          	sext.w	a5,s2
    if(state == 0){
 4f2:	fe0994e3          	bnez	s3,4da <vprintf+0x56>
      if(c0 == '%'){
 4f6:	fd579de3          	bne	a5,s5,4d0 <vprintf+0x4c>
        state = '%';
 4fa:	89be                	mv	s3,a5
 4fc:	b7cd                	j	4de <vprintf+0x5a>
      if(c0) c1 = fmt[i+1] & 0xff;
 4fe:	cfa5                	beqz	a5,576 <vprintf+0xf2>
 500:	00ea06b3          	add	a3,s4,a4
 504:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 508:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 50a:	c681                	beqz	a3,512 <vprintf+0x8e>
 50c:	9752                	add	a4,a4,s4
 50e:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 512:	03878a63          	beq	a5,s8,546 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 516:	05a78463          	beq	a5,s10,55e <vprintf+0xda>
      } else if(c0 == 'u'){
 51a:	0db78763          	beq	a5,s11,5e8 <vprintf+0x164>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 51e:	07800713          	li	a4,120
 522:	10e78963          	beq	a5,a4,634 <vprintf+0x1b0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 526:	07000713          	li	a4,112
 52a:	12e78e63          	beq	a5,a4,666 <vprintf+0x1e2>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 52e:	07300713          	li	a4,115
 532:	16e78b63          	beq	a5,a4,6a8 <vprintf+0x224>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 536:	05579063          	bne	a5,s5,576 <vprintf+0xf2>
        putc(fd, '%');
 53a:	85d6                	mv	a1,s5
 53c:	855a                	mv	a0,s6
 53e:	e83ff0ef          	jal	ra,3c0 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 542:	4981                	li	s3,0
 544:	bf69                	j	4de <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 1);
 546:	008b8913          	addi	s2,s7,8
 54a:	4685                	li	a3,1
 54c:	4629                	li	a2,10
 54e:	000ba583          	lw	a1,0(s7)
 552:	855a                	mv	a0,s6
 554:	e8bff0ef          	jal	ra,3de <printint>
 558:	8bca                	mv	s7,s2
      state = 0;
 55a:	4981                	li	s3,0
 55c:	b749                	j	4de <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'd'){
 55e:	03868663          	beq	a3,s8,58a <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 562:	05a68163          	beq	a3,s10,5a4 <vprintf+0x120>
      } else if(c0 == 'l' && c1 == 'u'){
 566:	09b68d63          	beq	a3,s11,600 <vprintf+0x17c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 56a:	03a68f63          	beq	a3,s10,5a8 <vprintf+0x124>
      } else if(c0 == 'l' && c1 == 'x'){
 56e:	07800793          	li	a5,120
 572:	0cf68d63          	beq	a3,a5,64c <vprintf+0x1c8>
        putc(fd, '%');
 576:	85d6                	mv	a1,s5
 578:	855a                	mv	a0,s6
 57a:	e47ff0ef          	jal	ra,3c0 <putc>
        putc(fd, c0);
 57e:	85ca                	mv	a1,s2
 580:	855a                	mv	a0,s6
 582:	e3fff0ef          	jal	ra,3c0 <putc>
      state = 0;
 586:	4981                	li	s3,0
 588:	bf99                	j	4de <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 58a:	008b8913          	addi	s2,s7,8
 58e:	4685                	li	a3,1
 590:	4629                	li	a2,10
 592:	000ba583          	lw	a1,0(s7)
 596:	855a                	mv	a0,s6
 598:	e47ff0ef          	jal	ra,3de <printint>
        i += 1;
 59c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 59e:	8bca                	mv	s7,s2
      state = 0;
 5a0:	4981                	li	s3,0
        i += 1;
 5a2:	bf35                	j	4de <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5a4:	03860563          	beq	a2,s8,5ce <vprintf+0x14a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 5a8:	07b60963          	beq	a2,s11,61a <vprintf+0x196>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 5ac:	07800793          	li	a5,120
 5b0:	fcf613e3          	bne	a2,a5,576 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5b4:	008b8913          	addi	s2,s7,8
 5b8:	4681                	li	a3,0
 5ba:	4641                	li	a2,16
 5bc:	000ba583          	lw	a1,0(s7)
 5c0:	855a                	mv	a0,s6
 5c2:	e1dff0ef          	jal	ra,3de <printint>
        i += 2;
 5c6:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5c8:	8bca                	mv	s7,s2
      state = 0;
 5ca:	4981                	li	s3,0
        i += 2;
 5cc:	bf09                	j	4de <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5ce:	008b8913          	addi	s2,s7,8
 5d2:	4685                	li	a3,1
 5d4:	4629                	li	a2,10
 5d6:	000ba583          	lw	a1,0(s7)
 5da:	855a                	mv	a0,s6
 5dc:	e03ff0ef          	jal	ra,3de <printint>
        i += 2;
 5e0:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5e2:	8bca                	mv	s7,s2
      state = 0;
 5e4:	4981                	li	s3,0
        i += 2;
 5e6:	bde5                	j	4de <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 0);
 5e8:	008b8913          	addi	s2,s7,8
 5ec:	4681                	li	a3,0
 5ee:	4629                	li	a2,10
 5f0:	000ba583          	lw	a1,0(s7)
 5f4:	855a                	mv	a0,s6
 5f6:	de9ff0ef          	jal	ra,3de <printint>
 5fa:	8bca                	mv	s7,s2
      state = 0;
 5fc:	4981                	li	s3,0
 5fe:	b5c5                	j	4de <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 600:	008b8913          	addi	s2,s7,8
 604:	4681                	li	a3,0
 606:	4629                	li	a2,10
 608:	000ba583          	lw	a1,0(s7)
 60c:	855a                	mv	a0,s6
 60e:	dd1ff0ef          	jal	ra,3de <printint>
        i += 1;
 612:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 614:	8bca                	mv	s7,s2
      state = 0;
 616:	4981                	li	s3,0
        i += 1;
 618:	b5d9                	j	4de <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 61a:	008b8913          	addi	s2,s7,8
 61e:	4681                	li	a3,0
 620:	4629                	li	a2,10
 622:	000ba583          	lw	a1,0(s7)
 626:	855a                	mv	a0,s6
 628:	db7ff0ef          	jal	ra,3de <printint>
        i += 2;
 62c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 62e:	8bca                	mv	s7,s2
      state = 0;
 630:	4981                	li	s3,0
        i += 2;
 632:	b575                	j	4de <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 16, 0);
 634:	008b8913          	addi	s2,s7,8
 638:	4681                	li	a3,0
 63a:	4641                	li	a2,16
 63c:	000ba583          	lw	a1,0(s7)
 640:	855a                	mv	a0,s6
 642:	d9dff0ef          	jal	ra,3de <printint>
 646:	8bca                	mv	s7,s2
      state = 0;
 648:	4981                	li	s3,0
 64a:	bd51                	j	4de <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 64c:	008b8913          	addi	s2,s7,8
 650:	4681                	li	a3,0
 652:	4641                	li	a2,16
 654:	000ba583          	lw	a1,0(s7)
 658:	855a                	mv	a0,s6
 65a:	d85ff0ef          	jal	ra,3de <printint>
        i += 1;
 65e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 660:	8bca                	mv	s7,s2
      state = 0;
 662:	4981                	li	s3,0
        i += 1;
 664:	bdad                	j	4de <vprintf+0x5a>
        printptr(fd, va_arg(ap, uint64));
 666:	008b8793          	addi	a5,s7,8
 66a:	f8f43423          	sd	a5,-120(s0)
 66e:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 672:	03000593          	li	a1,48
 676:	855a                	mv	a0,s6
 678:	d49ff0ef          	jal	ra,3c0 <putc>
  putc(fd, 'x');
 67c:	07800593          	li	a1,120
 680:	855a                	mv	a0,s6
 682:	d3fff0ef          	jal	ra,3c0 <putc>
 686:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 688:	03c9d793          	srli	a5,s3,0x3c
 68c:	97e6                	add	a5,a5,s9
 68e:	0007c583          	lbu	a1,0(a5)
 692:	855a                	mv	a0,s6
 694:	d2dff0ef          	jal	ra,3c0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 698:	0992                	slli	s3,s3,0x4
 69a:	397d                	addiw	s2,s2,-1
 69c:	fe0916e3          	bnez	s2,688 <vprintf+0x204>
        printptr(fd, va_arg(ap, uint64));
 6a0:	f8843b83          	ld	s7,-120(s0)
      state = 0;
 6a4:	4981                	li	s3,0
 6a6:	bd25                	j	4de <vprintf+0x5a>
        if((s = va_arg(ap, char*)) == 0)
 6a8:	008b8993          	addi	s3,s7,8
 6ac:	000bb903          	ld	s2,0(s7)
 6b0:	00090f63          	beqz	s2,6ce <vprintf+0x24a>
        for(; *s; s++)
 6b4:	00094583          	lbu	a1,0(s2)
 6b8:	c195                	beqz	a1,6dc <vprintf+0x258>
          putc(fd, *s);
 6ba:	855a                	mv	a0,s6
 6bc:	d05ff0ef          	jal	ra,3c0 <putc>
        for(; *s; s++)
 6c0:	0905                	addi	s2,s2,1
 6c2:	00094583          	lbu	a1,0(s2)
 6c6:	f9f5                	bnez	a1,6ba <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 6c8:	8bce                	mv	s7,s3
      state = 0;
 6ca:	4981                	li	s3,0
 6cc:	bd09                	j	4de <vprintf+0x5a>
          s = "(null)";
 6ce:	00000917          	auipc	s2,0x0
 6d2:	23a90913          	addi	s2,s2,570 # 908 <malloc+0x124>
        for(; *s; s++)
 6d6:	02800593          	li	a1,40
 6da:	b7c5                	j	6ba <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 6dc:	8bce                	mv	s7,s3
      state = 0;
 6de:	4981                	li	s3,0
 6e0:	bbfd                	j	4de <vprintf+0x5a>
    }
  }
}
 6e2:	70e6                	ld	ra,120(sp)
 6e4:	7446                	ld	s0,112(sp)
 6e6:	74a6                	ld	s1,104(sp)
 6e8:	7906                	ld	s2,96(sp)
 6ea:	69e6                	ld	s3,88(sp)
 6ec:	6a46                	ld	s4,80(sp)
 6ee:	6aa6                	ld	s5,72(sp)
 6f0:	6b06                	ld	s6,64(sp)
 6f2:	7be2                	ld	s7,56(sp)
 6f4:	7c42                	ld	s8,48(sp)
 6f6:	7ca2                	ld	s9,40(sp)
 6f8:	7d02                	ld	s10,32(sp)
 6fa:	6de2                	ld	s11,24(sp)
 6fc:	6109                	addi	sp,sp,128
 6fe:	8082                	ret

0000000000000700 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 700:	715d                	addi	sp,sp,-80
 702:	ec06                	sd	ra,24(sp)
 704:	e822                	sd	s0,16(sp)
 706:	1000                	addi	s0,sp,32
 708:	e010                	sd	a2,0(s0)
 70a:	e414                	sd	a3,8(s0)
 70c:	e818                	sd	a4,16(s0)
 70e:	ec1c                	sd	a5,24(s0)
 710:	03043023          	sd	a6,32(s0)
 714:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 718:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 71c:	8622                	mv	a2,s0
 71e:	d67ff0ef          	jal	ra,484 <vprintf>
}
 722:	60e2                	ld	ra,24(sp)
 724:	6442                	ld	s0,16(sp)
 726:	6161                	addi	sp,sp,80
 728:	8082                	ret

000000000000072a <printf>:

void
printf(const char *fmt, ...)
{
 72a:	711d                	addi	sp,sp,-96
 72c:	ec06                	sd	ra,24(sp)
 72e:	e822                	sd	s0,16(sp)
 730:	1000                	addi	s0,sp,32
 732:	e40c                	sd	a1,8(s0)
 734:	e810                	sd	a2,16(s0)
 736:	ec14                	sd	a3,24(s0)
 738:	f018                	sd	a4,32(s0)
 73a:	f41c                	sd	a5,40(s0)
 73c:	03043823          	sd	a6,48(s0)
 740:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 744:	00840613          	addi	a2,s0,8
 748:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 74c:	85aa                	mv	a1,a0
 74e:	4505                	li	a0,1
 750:	d35ff0ef          	jal	ra,484 <vprintf>
}
 754:	60e2                	ld	ra,24(sp)
 756:	6442                	ld	s0,16(sp)
 758:	6125                	addi	sp,sp,96
 75a:	8082                	ret

000000000000075c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 75c:	1141                	addi	sp,sp,-16
 75e:	e422                	sd	s0,8(sp)
 760:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 762:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 766:	00001797          	auipc	a5,0x1
 76a:	89a7b783          	ld	a5,-1894(a5) # 1000 <freep>
 76e:	a805                	j	79e <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 770:	4618                	lw	a4,8(a2)
 772:	9db9                	addw	a1,a1,a4
 774:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 778:	6398                	ld	a4,0(a5)
 77a:	6318                	ld	a4,0(a4)
 77c:	fee53823          	sd	a4,-16(a0)
 780:	a091                	j	7c4 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 782:	ff852703          	lw	a4,-8(a0)
 786:	9e39                	addw	a2,a2,a4
 788:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 78a:	ff053703          	ld	a4,-16(a0)
 78e:	e398                	sd	a4,0(a5)
 790:	a099                	j	7d6 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 792:	6398                	ld	a4,0(a5)
 794:	00e7e463          	bltu	a5,a4,79c <free+0x40>
 798:	00e6ea63          	bltu	a3,a4,7ac <free+0x50>
{
 79c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 79e:	fed7fae3          	bgeu	a5,a3,792 <free+0x36>
 7a2:	6398                	ld	a4,0(a5)
 7a4:	00e6e463          	bltu	a3,a4,7ac <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7a8:	fee7eae3          	bltu	a5,a4,79c <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 7ac:	ff852583          	lw	a1,-8(a0)
 7b0:	6390                	ld	a2,0(a5)
 7b2:	02059713          	slli	a4,a1,0x20
 7b6:	9301                	srli	a4,a4,0x20
 7b8:	0712                	slli	a4,a4,0x4
 7ba:	9736                	add	a4,a4,a3
 7bc:	fae60ae3          	beq	a2,a4,770 <free+0x14>
    bp->s.ptr = p->s.ptr;
 7c0:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7c4:	4790                	lw	a2,8(a5)
 7c6:	02061713          	slli	a4,a2,0x20
 7ca:	9301                	srli	a4,a4,0x20
 7cc:	0712                	slli	a4,a4,0x4
 7ce:	973e                	add	a4,a4,a5
 7d0:	fae689e3          	beq	a3,a4,782 <free+0x26>
  } else
    p->s.ptr = bp;
 7d4:	e394                	sd	a3,0(a5)
  freep = p;
 7d6:	00001717          	auipc	a4,0x1
 7da:	82f73523          	sd	a5,-2006(a4) # 1000 <freep>
}
 7de:	6422                	ld	s0,8(sp)
 7e0:	0141                	addi	sp,sp,16
 7e2:	8082                	ret

00000000000007e4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7e4:	7139                	addi	sp,sp,-64
 7e6:	fc06                	sd	ra,56(sp)
 7e8:	f822                	sd	s0,48(sp)
 7ea:	f426                	sd	s1,40(sp)
 7ec:	f04a                	sd	s2,32(sp)
 7ee:	ec4e                	sd	s3,24(sp)
 7f0:	e852                	sd	s4,16(sp)
 7f2:	e456                	sd	s5,8(sp)
 7f4:	e05a                	sd	s6,0(sp)
 7f6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7f8:	02051493          	slli	s1,a0,0x20
 7fc:	9081                	srli	s1,s1,0x20
 7fe:	04bd                	addi	s1,s1,15
 800:	8091                	srli	s1,s1,0x4
 802:	0014899b          	addiw	s3,s1,1
 806:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 808:	00000517          	auipc	a0,0x0
 80c:	7f853503          	ld	a0,2040(a0) # 1000 <freep>
 810:	c515                	beqz	a0,83c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 812:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 814:	4798                	lw	a4,8(a5)
 816:	02977f63          	bgeu	a4,s1,854 <malloc+0x70>
 81a:	8a4e                	mv	s4,s3
 81c:	0009871b          	sext.w	a4,s3
 820:	6685                	lui	a3,0x1
 822:	00d77363          	bgeu	a4,a3,828 <malloc+0x44>
 826:	6a05                	lui	s4,0x1
 828:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 82c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 830:	00000917          	auipc	s2,0x0
 834:	7d090913          	addi	s2,s2,2000 # 1000 <freep>
  if(p == (char*)-1)
 838:	5afd                	li	s5,-1
 83a:	a0bd                	j	8a8 <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
 83c:	00000797          	auipc	a5,0x0
 840:	7d478793          	addi	a5,a5,2004 # 1010 <base>
 844:	00000717          	auipc	a4,0x0
 848:	7af73e23          	sd	a5,1980(a4) # 1000 <freep>
 84c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 84e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 852:	b7e1                	j	81a <malloc+0x36>
      if(p->s.size == nunits)
 854:	02e48b63          	beq	s1,a4,88a <malloc+0xa6>
        p->s.size -= nunits;
 858:	4137073b          	subw	a4,a4,s3
 85c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 85e:	1702                	slli	a4,a4,0x20
 860:	9301                	srli	a4,a4,0x20
 862:	0712                	slli	a4,a4,0x4
 864:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 866:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 86a:	00000717          	auipc	a4,0x0
 86e:	78a73b23          	sd	a0,1942(a4) # 1000 <freep>
      return (void*)(p + 1);
 872:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 876:	70e2                	ld	ra,56(sp)
 878:	7442                	ld	s0,48(sp)
 87a:	74a2                	ld	s1,40(sp)
 87c:	7902                	ld	s2,32(sp)
 87e:	69e2                	ld	s3,24(sp)
 880:	6a42                	ld	s4,16(sp)
 882:	6aa2                	ld	s5,8(sp)
 884:	6b02                	ld	s6,0(sp)
 886:	6121                	addi	sp,sp,64
 888:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 88a:	6398                	ld	a4,0(a5)
 88c:	e118                	sd	a4,0(a0)
 88e:	bff1                	j	86a <malloc+0x86>
  hp->s.size = nu;
 890:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 894:	0541                	addi	a0,a0,16
 896:	ec7ff0ef          	jal	ra,75c <free>
  return freep;
 89a:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 89e:	dd61                	beqz	a0,876 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8a0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8a2:	4798                	lw	a4,8(a5)
 8a4:	fa9778e3          	bgeu	a4,s1,854 <malloc+0x70>
    if(p == freep)
 8a8:	00093703          	ld	a4,0(s2)
 8ac:	853e                	mv	a0,a5
 8ae:	fef719e3          	bne	a4,a5,8a0 <malloc+0xbc>
  p = sbrk(nu * sizeof(Header));
 8b2:	8552                	mv	a0,s4
 8b4:	ae5ff0ef          	jal	ra,398 <sbrk>
  if(p == (char*)-1)
 8b8:	fd551ce3          	bne	a0,s5,890 <malloc+0xac>
        return 0;
 8bc:	4501                	li	a0,0
 8be:	bf65                	j	876 <malloc+0x92>
