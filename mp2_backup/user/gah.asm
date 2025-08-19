
user/_gah:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <gen_and_hold>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"
#include "user/user.h"

int gen_and_hold(char *filename)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  int fd = open(filename, O_CREATE | O_RDWR);
   8:	20200593          	li	a1,514
   c:	418000ef          	jal	ra,424 <open>
  return fd;
}
  10:	60a2                	ld	ra,8(sp)
  12:	6402                	ld	s0,0(sp)
  14:	0141                	addi	sp,sp,16
  16:	8082                	ret

0000000000000018 <work>:

void work(const char *dir, int gen_cnt)
{
  18:	7159                	addi	sp,sp,-112
  1a:	f486                	sd	ra,104(sp)
  1c:	f0a2                	sd	s0,96(sp)
  1e:	eca6                	sd	s1,88(sp)
  20:	e8ca                	sd	s2,80(sp)
  22:	e4ce                	sd	s3,72(sp)
  24:	e0d2                	sd	s4,64(sp)
  26:	fc56                	sd	s5,56(sp)
  28:	f85a                	sd	s6,48(sp)
  2a:	f45e                	sd	s7,40(sp)
  2c:	1880                	addi	s0,sp,112
  2e:	84aa                	mv	s1,a0
  30:	8b2e                	mv	s6,a1
  char filename[20];
  memset(filename, 20, sizeof(char));
  32:	4605                	li	a2,1
  34:	45d1                	li	a1,20
  36:	f9840513          	addi	a0,s0,-104
  3a:	1c2000ef          	jal	ra,1fc <memset>
  strcpy(filename, dir);
  3e:	85a6                	mv	a1,s1
  40:	f9840513          	addi	a0,s0,-104
  44:	146000ef          	jal	ra,18a <strcpy>
  uint len = strlen(filename);
  48:	f9840513          	addi	a0,s0,-104
  4c:	186000ef          	jal	ra,1d2 <strlen>
  50:	0005099b          	sext.w	s3,a0
  filename[len] = '/';
  54:	1502                	slli	a0,a0,0x20
  56:	9101                	srli	a0,a0,0x20
  58:	fb040793          	addi	a5,s0,-80
  5c:	953e                	add	a0,a0,a5
  5e:	02f00793          	li	a5,47
  62:	fef50423          	sb	a5,-24(a0)

  // printf("[GAH] Gen and hold files\n");
  for (int i = 0; i < gen_cnt; ++i)
  66:	07605463          	blez	s6,ce <work+0xb6>
  6a:	4481                	li	s1,0
  {
    filename[len + 1] = '0' + i / 100;
  6c:	00198a9b          	addiw	s5,s3,1
  70:	1a82                	slli	s5,s5,0x20
  72:	020ada93          	srli	s5,s5,0x20
  76:	fb040793          	addi	a5,s0,-80
  7a:	9abe                	add	s5,s5,a5
  7c:	06400b93          	li	s7,100
    filename[len + 2] = '0' + (i / 10) % 10;
  80:	00298a1b          	addiw	s4,s3,2
  84:	1a02                	slli	s4,s4,0x20
  86:	020a5a13          	srli	s4,s4,0x20
  8a:	9a3e                	add	s4,s4,a5
  8c:	4929                	li	s2,10
    filename[len + 3] = '0' + i % 10;
  8e:	298d                	addiw	s3,s3,3
  90:	1982                	slli	s3,s3,0x20
  92:	0209d993          	srli	s3,s3,0x20
  96:	99be                	add	s3,s3,a5
    filename[len + 1] = '0' + i / 100;
  98:	0374c7bb          	divw	a5,s1,s7
  9c:	0307879b          	addiw	a5,a5,48
  a0:	fefa8423          	sb	a5,-24(s5)
    filename[len + 2] = '0' + (i / 10) % 10;
  a4:	0324c7bb          	divw	a5,s1,s2
  a8:	0327e7bb          	remw	a5,a5,s2
  ac:	0307879b          	addiw	a5,a5,48
  b0:	fefa0423          	sb	a5,-24(s4)
    filename[len + 3] = '0' + i % 10;
  b4:	0324e7bb          	remw	a5,s1,s2
  b8:	0307879b          	addiw	a5,a5,48
  bc:	fef98423          	sb	a5,-24(s3)
    gen_and_hold(filename);
  c0:	f9840513          	addi	a0,s0,-104
  c4:	f3dff0ef          	jal	ra,0 <gen_and_hold>
  for (int i = 0; i < gen_cnt; ++i)
  c8:	2485                	addiw	s1,s1,1
  ca:	fc9b17e3          	bne	s6,s1,98 <work+0x80>
  }
}
  ce:	70a6                	ld	ra,104(sp)
  d0:	7406                	ld	s0,96(sp)
  d2:	64e6                	ld	s1,88(sp)
  d4:	6946                	ld	s2,80(sp)
  d6:	69a6                	ld	s3,72(sp)
  d8:	6a06                	ld	s4,64(sp)
  da:	7ae2                	ld	s5,56(sp)
  dc:	7b42                	ld	s6,48(sp)
  de:	7ba2                	ld	s7,40(sp)
  e0:	6165                	addi	sp,sp,112
  e2:	8082                	ret

00000000000000e4 <main>:

int main(int argc, char *argv[])
{
  e4:	de010113          	addi	sp,sp,-544
  e8:	20113c23          	sd	ra,536(sp)
  ec:	20813823          	sd	s0,528(sp)
  f0:	20913423          	sd	s1,520(sp)
  f4:	21213023          	sd	s2,512(sp)
  f8:	1400                	addi	s0,sp,544
  if (argc != 3)
  fa:	478d                	li	a5,3
  fc:	00f50b63          	beq	a0,a5,112 <main+0x2e>
  {
    printf("gen_and_hold <dir> <num> - generate and hold files\n");
 100:	00001517          	auipc	a0,0x1
 104:	8a050513          	addi	a0,a0,-1888 # 9a0 <malloc+0xe8>
 108:	6f6000ef          	jal	ra,7fe <printf>
    exit(0);
 10c:	4501                	li	a0,0
 10e:	2d6000ef          	jal	ra,3e4 <exit>
 112:	84ae                	mv	s1,a1
  }

  printf("%d", getpid());
 114:	350000ef          	jal	ra,464 <getpid>
 118:	85aa                	mv	a1,a0
 11a:	00001517          	auipc	a0,0x1
 11e:	8be50513          	addi	a0,a0,-1858 # 9d8 <malloc+0x120>
 122:	6dc000ef          	jal	ra,7fe <printf>
  sleep(2);
 126:	4509                	li	a0,2
 128:	34c000ef          	jal	ra,474 <sleep>
  char buf[512];
  int n;

  while ((n = read(0, buf, sizeof(buf))) > 0)
  {
    if (!strcmp(buf, "Ok"))
 12c:	00001917          	auipc	s2,0x1
 130:	8b490913          	addi	s2,s2,-1868 # 9e0 <malloc+0x128>
  while ((n = read(0, buf, sizeof(buf))) > 0)
 134:	20000613          	li	a2,512
 138:	de040593          	addi	a1,s0,-544
 13c:	4501                	li	a0,0
 13e:	2be000ef          	jal	ra,3fc <read>
 142:	00a05863          	blez	a0,152 <main+0x6e>
    if (!strcmp(buf, "Ok"))
 146:	85ca                	mv	a1,s2
 148:	de040513          	addi	a0,s0,-544
 14c:	05a000ef          	jal	ra,1a6 <strcmp>
 150:	f175                	bnez	a0,134 <main+0x50>
    {
      break;
    }
  }

  work(argv[1], atoi(argv[2]));
 152:	0084b903          	ld	s2,8(s1)
 156:	6888                	ld	a0,16(s1)
 158:	194000ef          	jal	ra,2ec <atoi>
 15c:	85aa                	mv	a1,a0
 15e:	854a                	mv	a0,s2
 160:	eb9ff0ef          	jal	ra,18 <work>

  sleep(2);
 164:	4509                	li	a0,2
 166:	30e000ef          	jal	ra,474 <sleep>
  printf("Ok");
 16a:	00001517          	auipc	a0,0x1
 16e:	87650513          	addi	a0,a0,-1930 # 9e0 <malloc+0x128>
 172:	68c000ef          	jal	ra,7fe <printf>

  while (1)
 176:	a001                	j	176 <main+0x92>

0000000000000178 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 178:	1141                	addi	sp,sp,-16
 17a:	e406                	sd	ra,8(sp)
 17c:	e022                	sd	s0,0(sp)
 17e:	0800                	addi	s0,sp,16
  extern int main();
  main();
 180:	f65ff0ef          	jal	ra,e4 <main>
  exit(0);
 184:	4501                	li	a0,0
 186:	25e000ef          	jal	ra,3e4 <exit>

000000000000018a <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 18a:	1141                	addi	sp,sp,-16
 18c:	e422                	sd	s0,8(sp)
 18e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 190:	87aa                	mv	a5,a0
 192:	0585                	addi	a1,a1,1
 194:	0785                	addi	a5,a5,1
 196:	fff5c703          	lbu	a4,-1(a1)
 19a:	fee78fa3          	sb	a4,-1(a5)
 19e:	fb75                	bnez	a4,192 <strcpy+0x8>
    ;
  return os;
}
 1a0:	6422                	ld	s0,8(sp)
 1a2:	0141                	addi	sp,sp,16
 1a4:	8082                	ret

00000000000001a6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1a6:	1141                	addi	sp,sp,-16
 1a8:	e422                	sd	s0,8(sp)
 1aa:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1ac:	00054783          	lbu	a5,0(a0)
 1b0:	cb91                	beqz	a5,1c4 <strcmp+0x1e>
 1b2:	0005c703          	lbu	a4,0(a1)
 1b6:	00f71763          	bne	a4,a5,1c4 <strcmp+0x1e>
    p++, q++;
 1ba:	0505                	addi	a0,a0,1
 1bc:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1be:	00054783          	lbu	a5,0(a0)
 1c2:	fbe5                	bnez	a5,1b2 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1c4:	0005c503          	lbu	a0,0(a1)
}
 1c8:	40a7853b          	subw	a0,a5,a0
 1cc:	6422                	ld	s0,8(sp)
 1ce:	0141                	addi	sp,sp,16
 1d0:	8082                	ret

00000000000001d2 <strlen>:

uint
strlen(const char *s)
{
 1d2:	1141                	addi	sp,sp,-16
 1d4:	e422                	sd	s0,8(sp)
 1d6:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1d8:	00054783          	lbu	a5,0(a0)
 1dc:	cf91                	beqz	a5,1f8 <strlen+0x26>
 1de:	0505                	addi	a0,a0,1
 1e0:	87aa                	mv	a5,a0
 1e2:	4685                	li	a3,1
 1e4:	9e89                	subw	a3,a3,a0
 1e6:	00f6853b          	addw	a0,a3,a5
 1ea:	0785                	addi	a5,a5,1
 1ec:	fff7c703          	lbu	a4,-1(a5)
 1f0:	fb7d                	bnez	a4,1e6 <strlen+0x14>
    ;
  return n;
}
 1f2:	6422                	ld	s0,8(sp)
 1f4:	0141                	addi	sp,sp,16
 1f6:	8082                	ret
  for(n = 0; s[n]; n++)
 1f8:	4501                	li	a0,0
 1fa:	bfe5                	j	1f2 <strlen+0x20>

00000000000001fc <memset>:

void*
memset(void *dst, int c, uint n)
{
 1fc:	1141                	addi	sp,sp,-16
 1fe:	e422                	sd	s0,8(sp)
 200:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 202:	ca19                	beqz	a2,218 <memset+0x1c>
 204:	87aa                	mv	a5,a0
 206:	1602                	slli	a2,a2,0x20
 208:	9201                	srli	a2,a2,0x20
 20a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 20e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 212:	0785                	addi	a5,a5,1
 214:	fee79de3          	bne	a5,a4,20e <memset+0x12>
  }
  return dst;
}
 218:	6422                	ld	s0,8(sp)
 21a:	0141                	addi	sp,sp,16
 21c:	8082                	ret

000000000000021e <strchr>:

char*
strchr(const char *s, char c)
{
 21e:	1141                	addi	sp,sp,-16
 220:	e422                	sd	s0,8(sp)
 222:	0800                	addi	s0,sp,16
  for(; *s; s++)
 224:	00054783          	lbu	a5,0(a0)
 228:	cb99                	beqz	a5,23e <strchr+0x20>
    if(*s == c)
 22a:	00f58763          	beq	a1,a5,238 <strchr+0x1a>
  for(; *s; s++)
 22e:	0505                	addi	a0,a0,1
 230:	00054783          	lbu	a5,0(a0)
 234:	fbfd                	bnez	a5,22a <strchr+0xc>
      return (char*)s;
  return 0;
 236:	4501                	li	a0,0
}
 238:	6422                	ld	s0,8(sp)
 23a:	0141                	addi	sp,sp,16
 23c:	8082                	ret
  return 0;
 23e:	4501                	li	a0,0
 240:	bfe5                	j	238 <strchr+0x1a>

0000000000000242 <gets>:

char*
gets(char *buf, int max)
{
 242:	711d                	addi	sp,sp,-96
 244:	ec86                	sd	ra,88(sp)
 246:	e8a2                	sd	s0,80(sp)
 248:	e4a6                	sd	s1,72(sp)
 24a:	e0ca                	sd	s2,64(sp)
 24c:	fc4e                	sd	s3,56(sp)
 24e:	f852                	sd	s4,48(sp)
 250:	f456                	sd	s5,40(sp)
 252:	f05a                	sd	s6,32(sp)
 254:	ec5e                	sd	s7,24(sp)
 256:	1080                	addi	s0,sp,96
 258:	8baa                	mv	s7,a0
 25a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 25c:	892a                	mv	s2,a0
 25e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 260:	4aa9                	li	s5,10
 262:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 264:	89a6                	mv	s3,s1
 266:	2485                	addiw	s1,s1,1
 268:	0344d663          	bge	s1,s4,294 <gets+0x52>
    cc = read(0, &c, 1);
 26c:	4605                	li	a2,1
 26e:	faf40593          	addi	a1,s0,-81
 272:	4501                	li	a0,0
 274:	188000ef          	jal	ra,3fc <read>
    if(cc < 1)
 278:	00a05e63          	blez	a0,294 <gets+0x52>
    buf[i++] = c;
 27c:	faf44783          	lbu	a5,-81(s0)
 280:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 284:	01578763          	beq	a5,s5,292 <gets+0x50>
 288:	0905                	addi	s2,s2,1
 28a:	fd679de3          	bne	a5,s6,264 <gets+0x22>
  for(i=0; i+1 < max; ){
 28e:	89a6                	mv	s3,s1
 290:	a011                	j	294 <gets+0x52>
 292:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 294:	99de                	add	s3,s3,s7
 296:	00098023          	sb	zero,0(s3)
  return buf;
}
 29a:	855e                	mv	a0,s7
 29c:	60e6                	ld	ra,88(sp)
 29e:	6446                	ld	s0,80(sp)
 2a0:	64a6                	ld	s1,72(sp)
 2a2:	6906                	ld	s2,64(sp)
 2a4:	79e2                	ld	s3,56(sp)
 2a6:	7a42                	ld	s4,48(sp)
 2a8:	7aa2                	ld	s5,40(sp)
 2aa:	7b02                	ld	s6,32(sp)
 2ac:	6be2                	ld	s7,24(sp)
 2ae:	6125                	addi	sp,sp,96
 2b0:	8082                	ret

00000000000002b2 <stat>:

int
stat(const char *n, struct stat *st)
{
 2b2:	1101                	addi	sp,sp,-32
 2b4:	ec06                	sd	ra,24(sp)
 2b6:	e822                	sd	s0,16(sp)
 2b8:	e426                	sd	s1,8(sp)
 2ba:	e04a                	sd	s2,0(sp)
 2bc:	1000                	addi	s0,sp,32
 2be:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2c0:	4581                	li	a1,0
 2c2:	162000ef          	jal	ra,424 <open>
  if(fd < 0)
 2c6:	02054163          	bltz	a0,2e8 <stat+0x36>
 2ca:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2cc:	85ca                	mv	a1,s2
 2ce:	16e000ef          	jal	ra,43c <fstat>
 2d2:	892a                	mv	s2,a0
  close(fd);
 2d4:	8526                	mv	a0,s1
 2d6:	136000ef          	jal	ra,40c <close>
  return r;
}
 2da:	854a                	mv	a0,s2
 2dc:	60e2                	ld	ra,24(sp)
 2de:	6442                	ld	s0,16(sp)
 2e0:	64a2                	ld	s1,8(sp)
 2e2:	6902                	ld	s2,0(sp)
 2e4:	6105                	addi	sp,sp,32
 2e6:	8082                	ret
    return -1;
 2e8:	597d                	li	s2,-1
 2ea:	bfc5                	j	2da <stat+0x28>

00000000000002ec <atoi>:

int
atoi(const char *s)
{
 2ec:	1141                	addi	sp,sp,-16
 2ee:	e422                	sd	s0,8(sp)
 2f0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2f2:	00054603          	lbu	a2,0(a0)
 2f6:	fd06079b          	addiw	a5,a2,-48
 2fa:	0ff7f793          	andi	a5,a5,255
 2fe:	4725                	li	a4,9
 300:	02f76963          	bltu	a4,a5,332 <atoi+0x46>
 304:	86aa                	mv	a3,a0
  n = 0;
 306:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 308:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 30a:	0685                	addi	a3,a3,1
 30c:	0025179b          	slliw	a5,a0,0x2
 310:	9fa9                	addw	a5,a5,a0
 312:	0017979b          	slliw	a5,a5,0x1
 316:	9fb1                	addw	a5,a5,a2
 318:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 31c:	0006c603          	lbu	a2,0(a3)
 320:	fd06071b          	addiw	a4,a2,-48
 324:	0ff77713          	andi	a4,a4,255
 328:	fee5f1e3          	bgeu	a1,a4,30a <atoi+0x1e>
  return n;
}
 32c:	6422                	ld	s0,8(sp)
 32e:	0141                	addi	sp,sp,16
 330:	8082                	ret
  n = 0;
 332:	4501                	li	a0,0
 334:	bfe5                	j	32c <atoi+0x40>

0000000000000336 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 336:	1141                	addi	sp,sp,-16
 338:	e422                	sd	s0,8(sp)
 33a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 33c:	02b57463          	bgeu	a0,a1,364 <memmove+0x2e>
    while(n-- > 0)
 340:	00c05f63          	blez	a2,35e <memmove+0x28>
 344:	1602                	slli	a2,a2,0x20
 346:	9201                	srli	a2,a2,0x20
 348:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 34c:	872a                	mv	a4,a0
      *dst++ = *src++;
 34e:	0585                	addi	a1,a1,1
 350:	0705                	addi	a4,a4,1
 352:	fff5c683          	lbu	a3,-1(a1)
 356:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 35a:	fee79ae3          	bne	a5,a4,34e <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 35e:	6422                	ld	s0,8(sp)
 360:	0141                	addi	sp,sp,16
 362:	8082                	ret
    dst += n;
 364:	00c50733          	add	a4,a0,a2
    src += n;
 368:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 36a:	fec05ae3          	blez	a2,35e <memmove+0x28>
 36e:	fff6079b          	addiw	a5,a2,-1
 372:	1782                	slli	a5,a5,0x20
 374:	9381                	srli	a5,a5,0x20
 376:	fff7c793          	not	a5,a5
 37a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 37c:	15fd                	addi	a1,a1,-1
 37e:	177d                	addi	a4,a4,-1
 380:	0005c683          	lbu	a3,0(a1)
 384:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 388:	fee79ae3          	bne	a5,a4,37c <memmove+0x46>
 38c:	bfc9                	j	35e <memmove+0x28>

000000000000038e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 38e:	1141                	addi	sp,sp,-16
 390:	e422                	sd	s0,8(sp)
 392:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 394:	ca05                	beqz	a2,3c4 <memcmp+0x36>
 396:	fff6069b          	addiw	a3,a2,-1
 39a:	1682                	slli	a3,a3,0x20
 39c:	9281                	srli	a3,a3,0x20
 39e:	0685                	addi	a3,a3,1
 3a0:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3a2:	00054783          	lbu	a5,0(a0)
 3a6:	0005c703          	lbu	a4,0(a1)
 3aa:	00e79863          	bne	a5,a4,3ba <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3ae:	0505                	addi	a0,a0,1
    p2++;
 3b0:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3b2:	fed518e3          	bne	a0,a3,3a2 <memcmp+0x14>
  }
  return 0;
 3b6:	4501                	li	a0,0
 3b8:	a019                	j	3be <memcmp+0x30>
      return *p1 - *p2;
 3ba:	40e7853b          	subw	a0,a5,a4
}
 3be:	6422                	ld	s0,8(sp)
 3c0:	0141                	addi	sp,sp,16
 3c2:	8082                	ret
  return 0;
 3c4:	4501                	li	a0,0
 3c6:	bfe5                	j	3be <memcmp+0x30>

00000000000003c8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3c8:	1141                	addi	sp,sp,-16
 3ca:	e406                	sd	ra,8(sp)
 3cc:	e022                	sd	s0,0(sp)
 3ce:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3d0:	f67ff0ef          	jal	ra,336 <memmove>
}
 3d4:	60a2                	ld	ra,8(sp)
 3d6:	6402                	ld	s0,0(sp)
 3d8:	0141                	addi	sp,sp,16
 3da:	8082                	ret

00000000000003dc <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3dc:	4885                	li	a7,1
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3e4:	4889                	li	a7,2
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <wait>:
.global wait
wait:
 li a7, SYS_wait
 3ec:	488d                	li	a7,3
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3f4:	4891                	li	a7,4
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <read>:
.global read
read:
 li a7, SYS_read
 3fc:	4895                	li	a7,5
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <write>:
.global write
write:
 li a7, SYS_write
 404:	48c1                	li	a7,16
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <close>:
.global close
close:
 li a7, SYS_close
 40c:	48d5                	li	a7,21
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <kill>:
.global kill
kill:
 li a7, SYS_kill
 414:	4899                	li	a7,6
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <exec>:
.global exec
exec:
 li a7, SYS_exec
 41c:	489d                	li	a7,7
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <open>:
.global open
open:
 li a7, SYS_open
 424:	48bd                	li	a7,15
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 42c:	48c5                	li	a7,17
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 434:	48c9                	li	a7,18
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 43c:	48a1                	li	a7,8
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <link>:
.global link
link:
 li a7, SYS_link
 444:	48cd                	li	a7,19
 ecall
 446:	00000073          	ecall
 ret
 44a:	8082                	ret

000000000000044c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 44c:	48d1                	li	a7,20
 ecall
 44e:	00000073          	ecall
 ret
 452:	8082                	ret

0000000000000454 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 454:	48a5                	li	a7,9
 ecall
 456:	00000073          	ecall
 ret
 45a:	8082                	ret

000000000000045c <dup>:
.global dup
dup:
 li a7, SYS_dup
 45c:	48a9                	li	a7,10
 ecall
 45e:	00000073          	ecall
 ret
 462:	8082                	ret

0000000000000464 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 464:	48ad                	li	a7,11
 ecall
 466:	00000073          	ecall
 ret
 46a:	8082                	ret

000000000000046c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 46c:	48b1                	li	a7,12
 ecall
 46e:	00000073          	ecall
 ret
 472:	8082                	ret

0000000000000474 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 474:	48b5                	li	a7,13
 ecall
 476:	00000073          	ecall
 ret
 47a:	8082                	ret

000000000000047c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 47c:	48b9                	li	a7,14
 ecall
 47e:	00000073          	ecall
 ret
 482:	8082                	ret

0000000000000484 <debugswitch>:
.global debugswitch
debugswitch:
 li a7, SYS_debugswitch
 484:	48d9                	li	a7,22
 ecall
 486:	00000073          	ecall
 ret
 48a:	8082                	ret

000000000000048c <printfslab>:
.global printfslab
printfslab:
 li a7, SYS_printfslab
 48c:	48dd                	li	a7,23
 ecall
 48e:	00000073          	ecall
 ret
 492:	8082                	ret

0000000000000494 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 494:	1101                	addi	sp,sp,-32
 496:	ec06                	sd	ra,24(sp)
 498:	e822                	sd	s0,16(sp)
 49a:	1000                	addi	s0,sp,32
 49c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4a0:	4605                	li	a2,1
 4a2:	fef40593          	addi	a1,s0,-17
 4a6:	f5fff0ef          	jal	ra,404 <write>
}
 4aa:	60e2                	ld	ra,24(sp)
 4ac:	6442                	ld	s0,16(sp)
 4ae:	6105                	addi	sp,sp,32
 4b0:	8082                	ret

00000000000004b2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4b2:	7139                	addi	sp,sp,-64
 4b4:	fc06                	sd	ra,56(sp)
 4b6:	f822                	sd	s0,48(sp)
 4b8:	f426                	sd	s1,40(sp)
 4ba:	f04a                	sd	s2,32(sp)
 4bc:	ec4e                	sd	s3,24(sp)
 4be:	0080                	addi	s0,sp,64
 4c0:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4c2:	c299                	beqz	a3,4c8 <printint+0x16>
 4c4:	0805c663          	bltz	a1,550 <printint+0x9e>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4c8:	2581                	sext.w	a1,a1
  neg = 0;
 4ca:	4881                	li	a7,0
 4cc:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 4d0:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4d2:	2601                	sext.w	a2,a2
 4d4:	00000517          	auipc	a0,0x0
 4d8:	51c50513          	addi	a0,a0,1308 # 9f0 <digits>
 4dc:	883a                	mv	a6,a4
 4de:	2705                	addiw	a4,a4,1
 4e0:	02c5f7bb          	remuw	a5,a1,a2
 4e4:	1782                	slli	a5,a5,0x20
 4e6:	9381                	srli	a5,a5,0x20
 4e8:	97aa                	add	a5,a5,a0
 4ea:	0007c783          	lbu	a5,0(a5)
 4ee:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4f2:	0005879b          	sext.w	a5,a1
 4f6:	02c5d5bb          	divuw	a1,a1,a2
 4fa:	0685                	addi	a3,a3,1
 4fc:	fec7f0e3          	bgeu	a5,a2,4dc <printint+0x2a>
  if(neg)
 500:	00088b63          	beqz	a7,516 <printint+0x64>
    buf[i++] = '-';
 504:	fd040793          	addi	a5,s0,-48
 508:	973e                	add	a4,a4,a5
 50a:	02d00793          	li	a5,45
 50e:	fef70823          	sb	a5,-16(a4)
 512:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 516:	02e05663          	blez	a4,542 <printint+0x90>
 51a:	fc040793          	addi	a5,s0,-64
 51e:	00e78933          	add	s2,a5,a4
 522:	fff78993          	addi	s3,a5,-1
 526:	99ba                	add	s3,s3,a4
 528:	377d                	addiw	a4,a4,-1
 52a:	1702                	slli	a4,a4,0x20
 52c:	9301                	srli	a4,a4,0x20
 52e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 532:	fff94583          	lbu	a1,-1(s2)
 536:	8526                	mv	a0,s1
 538:	f5dff0ef          	jal	ra,494 <putc>
  while(--i >= 0)
 53c:	197d                	addi	s2,s2,-1
 53e:	ff391ae3          	bne	s2,s3,532 <printint+0x80>
}
 542:	70e2                	ld	ra,56(sp)
 544:	7442                	ld	s0,48(sp)
 546:	74a2                	ld	s1,40(sp)
 548:	7902                	ld	s2,32(sp)
 54a:	69e2                	ld	s3,24(sp)
 54c:	6121                	addi	sp,sp,64
 54e:	8082                	ret
    x = -xx;
 550:	40b005bb          	negw	a1,a1
    neg = 1;
 554:	4885                	li	a7,1
    x = -xx;
 556:	bf9d                	j	4cc <printint+0x1a>

0000000000000558 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 558:	7119                	addi	sp,sp,-128
 55a:	fc86                	sd	ra,120(sp)
 55c:	f8a2                	sd	s0,112(sp)
 55e:	f4a6                	sd	s1,104(sp)
 560:	f0ca                	sd	s2,96(sp)
 562:	ecce                	sd	s3,88(sp)
 564:	e8d2                	sd	s4,80(sp)
 566:	e4d6                	sd	s5,72(sp)
 568:	e0da                	sd	s6,64(sp)
 56a:	fc5e                	sd	s7,56(sp)
 56c:	f862                	sd	s8,48(sp)
 56e:	f466                	sd	s9,40(sp)
 570:	f06a                	sd	s10,32(sp)
 572:	ec6e                	sd	s11,24(sp)
 574:	0100                	addi	s0,sp,128
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 576:	0005c903          	lbu	s2,0(a1)
 57a:	22090e63          	beqz	s2,7b6 <vprintf+0x25e>
 57e:	8b2a                	mv	s6,a0
 580:	8a2e                	mv	s4,a1
 582:	8bb2                	mv	s7,a2
  state = 0;
 584:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 586:	4481                	li	s1,0
 588:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 58a:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 58e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 592:	06c00d13          	li	s10,108
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 596:	07500d93          	li	s11,117
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 59a:	00000c97          	auipc	s9,0x0
 59e:	456c8c93          	addi	s9,s9,1110 # 9f0 <digits>
 5a2:	a005                	j	5c2 <vprintf+0x6a>
        putc(fd, c0);
 5a4:	85ca                	mv	a1,s2
 5a6:	855a                	mv	a0,s6
 5a8:	eedff0ef          	jal	ra,494 <putc>
 5ac:	a019                	j	5b2 <vprintf+0x5a>
    } else if(state == '%'){
 5ae:	03598263          	beq	s3,s5,5d2 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 5b2:	2485                	addiw	s1,s1,1
 5b4:	8726                	mv	a4,s1
 5b6:	009a07b3          	add	a5,s4,s1
 5ba:	0007c903          	lbu	s2,0(a5)
 5be:	1e090c63          	beqz	s2,7b6 <vprintf+0x25e>
    c0 = fmt[i] & 0xff;
 5c2:	0009079b          	sext.w	a5,s2
    if(state == 0){
 5c6:	fe0994e3          	bnez	s3,5ae <vprintf+0x56>
      if(c0 == '%'){
 5ca:	fd579de3          	bne	a5,s5,5a4 <vprintf+0x4c>
        state = '%';
 5ce:	89be                	mv	s3,a5
 5d0:	b7cd                	j	5b2 <vprintf+0x5a>
      if(c0) c1 = fmt[i+1] & 0xff;
 5d2:	cfa5                	beqz	a5,64a <vprintf+0xf2>
 5d4:	00ea06b3          	add	a3,s4,a4
 5d8:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 5dc:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 5de:	c681                	beqz	a3,5e6 <vprintf+0x8e>
 5e0:	9752                	add	a4,a4,s4
 5e2:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 5e6:	03878a63          	beq	a5,s8,61a <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 5ea:	05a78463          	beq	a5,s10,632 <vprintf+0xda>
      } else if(c0 == 'u'){
 5ee:	0db78763          	beq	a5,s11,6bc <vprintf+0x164>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 5f2:	07800713          	li	a4,120
 5f6:	10e78963          	beq	a5,a4,708 <vprintf+0x1b0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 5fa:	07000713          	li	a4,112
 5fe:	12e78e63          	beq	a5,a4,73a <vprintf+0x1e2>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 602:	07300713          	li	a4,115
 606:	16e78b63          	beq	a5,a4,77c <vprintf+0x224>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 60a:	05579063          	bne	a5,s5,64a <vprintf+0xf2>
        putc(fd, '%');
 60e:	85d6                	mv	a1,s5
 610:	855a                	mv	a0,s6
 612:	e83ff0ef          	jal	ra,494 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 616:	4981                	li	s3,0
 618:	bf69                	j	5b2 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 1);
 61a:	008b8913          	addi	s2,s7,8
 61e:	4685                	li	a3,1
 620:	4629                	li	a2,10
 622:	000ba583          	lw	a1,0(s7)
 626:	855a                	mv	a0,s6
 628:	e8bff0ef          	jal	ra,4b2 <printint>
 62c:	8bca                	mv	s7,s2
      state = 0;
 62e:	4981                	li	s3,0
 630:	b749                	j	5b2 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'd'){
 632:	03868663          	beq	a3,s8,65e <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 636:	05a68163          	beq	a3,s10,678 <vprintf+0x120>
      } else if(c0 == 'l' && c1 == 'u'){
 63a:	09b68d63          	beq	a3,s11,6d4 <vprintf+0x17c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 63e:	03a68f63          	beq	a3,s10,67c <vprintf+0x124>
      } else if(c0 == 'l' && c1 == 'x'){
 642:	07800793          	li	a5,120
 646:	0cf68d63          	beq	a3,a5,720 <vprintf+0x1c8>
        putc(fd, '%');
 64a:	85d6                	mv	a1,s5
 64c:	855a                	mv	a0,s6
 64e:	e47ff0ef          	jal	ra,494 <putc>
        putc(fd, c0);
 652:	85ca                	mv	a1,s2
 654:	855a                	mv	a0,s6
 656:	e3fff0ef          	jal	ra,494 <putc>
      state = 0;
 65a:	4981                	li	s3,0
 65c:	bf99                	j	5b2 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 65e:	008b8913          	addi	s2,s7,8
 662:	4685                	li	a3,1
 664:	4629                	li	a2,10
 666:	000ba583          	lw	a1,0(s7)
 66a:	855a                	mv	a0,s6
 66c:	e47ff0ef          	jal	ra,4b2 <printint>
        i += 1;
 670:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 672:	8bca                	mv	s7,s2
      state = 0;
 674:	4981                	li	s3,0
        i += 1;
 676:	bf35                	j	5b2 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 678:	03860563          	beq	a2,s8,6a2 <vprintf+0x14a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 67c:	07b60963          	beq	a2,s11,6ee <vprintf+0x196>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 680:	07800793          	li	a5,120
 684:	fcf613e3          	bne	a2,a5,64a <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 688:	008b8913          	addi	s2,s7,8
 68c:	4681                	li	a3,0
 68e:	4641                	li	a2,16
 690:	000ba583          	lw	a1,0(s7)
 694:	855a                	mv	a0,s6
 696:	e1dff0ef          	jal	ra,4b2 <printint>
        i += 2;
 69a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 69c:	8bca                	mv	s7,s2
      state = 0;
 69e:	4981                	li	s3,0
        i += 2;
 6a0:	bf09                	j	5b2 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6a2:	008b8913          	addi	s2,s7,8
 6a6:	4685                	li	a3,1
 6a8:	4629                	li	a2,10
 6aa:	000ba583          	lw	a1,0(s7)
 6ae:	855a                	mv	a0,s6
 6b0:	e03ff0ef          	jal	ra,4b2 <printint>
        i += 2;
 6b4:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 6b6:	8bca                	mv	s7,s2
      state = 0;
 6b8:	4981                	li	s3,0
        i += 2;
 6ba:	bde5                	j	5b2 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 0);
 6bc:	008b8913          	addi	s2,s7,8
 6c0:	4681                	li	a3,0
 6c2:	4629                	li	a2,10
 6c4:	000ba583          	lw	a1,0(s7)
 6c8:	855a                	mv	a0,s6
 6ca:	de9ff0ef          	jal	ra,4b2 <printint>
 6ce:	8bca                	mv	s7,s2
      state = 0;
 6d0:	4981                	li	s3,0
 6d2:	b5c5                	j	5b2 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6d4:	008b8913          	addi	s2,s7,8
 6d8:	4681                	li	a3,0
 6da:	4629                	li	a2,10
 6dc:	000ba583          	lw	a1,0(s7)
 6e0:	855a                	mv	a0,s6
 6e2:	dd1ff0ef          	jal	ra,4b2 <printint>
        i += 1;
 6e6:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6e8:	8bca                	mv	s7,s2
      state = 0;
 6ea:	4981                	li	s3,0
        i += 1;
 6ec:	b5d9                	j	5b2 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6ee:	008b8913          	addi	s2,s7,8
 6f2:	4681                	li	a3,0
 6f4:	4629                	li	a2,10
 6f6:	000ba583          	lw	a1,0(s7)
 6fa:	855a                	mv	a0,s6
 6fc:	db7ff0ef          	jal	ra,4b2 <printint>
        i += 2;
 700:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 702:	8bca                	mv	s7,s2
      state = 0;
 704:	4981                	li	s3,0
        i += 2;
 706:	b575                	j	5b2 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 16, 0);
 708:	008b8913          	addi	s2,s7,8
 70c:	4681                	li	a3,0
 70e:	4641                	li	a2,16
 710:	000ba583          	lw	a1,0(s7)
 714:	855a                	mv	a0,s6
 716:	d9dff0ef          	jal	ra,4b2 <printint>
 71a:	8bca                	mv	s7,s2
      state = 0;
 71c:	4981                	li	s3,0
 71e:	bd51                	j	5b2 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 720:	008b8913          	addi	s2,s7,8
 724:	4681                	li	a3,0
 726:	4641                	li	a2,16
 728:	000ba583          	lw	a1,0(s7)
 72c:	855a                	mv	a0,s6
 72e:	d85ff0ef          	jal	ra,4b2 <printint>
        i += 1;
 732:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 734:	8bca                	mv	s7,s2
      state = 0;
 736:	4981                	li	s3,0
        i += 1;
 738:	bdad                	j	5b2 <vprintf+0x5a>
        printptr(fd, va_arg(ap, uint64));
 73a:	008b8793          	addi	a5,s7,8
 73e:	f8f43423          	sd	a5,-120(s0)
 742:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 746:	03000593          	li	a1,48
 74a:	855a                	mv	a0,s6
 74c:	d49ff0ef          	jal	ra,494 <putc>
  putc(fd, 'x');
 750:	07800593          	li	a1,120
 754:	855a                	mv	a0,s6
 756:	d3fff0ef          	jal	ra,494 <putc>
 75a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 75c:	03c9d793          	srli	a5,s3,0x3c
 760:	97e6                	add	a5,a5,s9
 762:	0007c583          	lbu	a1,0(a5)
 766:	855a                	mv	a0,s6
 768:	d2dff0ef          	jal	ra,494 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 76c:	0992                	slli	s3,s3,0x4
 76e:	397d                	addiw	s2,s2,-1
 770:	fe0916e3          	bnez	s2,75c <vprintf+0x204>
        printptr(fd, va_arg(ap, uint64));
 774:	f8843b83          	ld	s7,-120(s0)
      state = 0;
 778:	4981                	li	s3,0
 77a:	bd25                	j	5b2 <vprintf+0x5a>
        if((s = va_arg(ap, char*)) == 0)
 77c:	008b8993          	addi	s3,s7,8
 780:	000bb903          	ld	s2,0(s7)
 784:	00090f63          	beqz	s2,7a2 <vprintf+0x24a>
        for(; *s; s++)
 788:	00094583          	lbu	a1,0(s2)
 78c:	c195                	beqz	a1,7b0 <vprintf+0x258>
          putc(fd, *s);
 78e:	855a                	mv	a0,s6
 790:	d05ff0ef          	jal	ra,494 <putc>
        for(; *s; s++)
 794:	0905                	addi	s2,s2,1
 796:	00094583          	lbu	a1,0(s2)
 79a:	f9f5                	bnez	a1,78e <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 79c:	8bce                	mv	s7,s3
      state = 0;
 79e:	4981                	li	s3,0
 7a0:	bd09                	j	5b2 <vprintf+0x5a>
          s = "(null)";
 7a2:	00000917          	auipc	s2,0x0
 7a6:	24690913          	addi	s2,s2,582 # 9e8 <malloc+0x130>
        for(; *s; s++)
 7aa:	02800593          	li	a1,40
 7ae:	b7c5                	j	78e <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 7b0:	8bce                	mv	s7,s3
      state = 0;
 7b2:	4981                	li	s3,0
 7b4:	bbfd                	j	5b2 <vprintf+0x5a>
    }
  }
}
 7b6:	70e6                	ld	ra,120(sp)
 7b8:	7446                	ld	s0,112(sp)
 7ba:	74a6                	ld	s1,104(sp)
 7bc:	7906                	ld	s2,96(sp)
 7be:	69e6                	ld	s3,88(sp)
 7c0:	6a46                	ld	s4,80(sp)
 7c2:	6aa6                	ld	s5,72(sp)
 7c4:	6b06                	ld	s6,64(sp)
 7c6:	7be2                	ld	s7,56(sp)
 7c8:	7c42                	ld	s8,48(sp)
 7ca:	7ca2                	ld	s9,40(sp)
 7cc:	7d02                	ld	s10,32(sp)
 7ce:	6de2                	ld	s11,24(sp)
 7d0:	6109                	addi	sp,sp,128
 7d2:	8082                	ret

00000000000007d4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7d4:	715d                	addi	sp,sp,-80
 7d6:	ec06                	sd	ra,24(sp)
 7d8:	e822                	sd	s0,16(sp)
 7da:	1000                	addi	s0,sp,32
 7dc:	e010                	sd	a2,0(s0)
 7de:	e414                	sd	a3,8(s0)
 7e0:	e818                	sd	a4,16(s0)
 7e2:	ec1c                	sd	a5,24(s0)
 7e4:	03043023          	sd	a6,32(s0)
 7e8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7ec:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7f0:	8622                	mv	a2,s0
 7f2:	d67ff0ef          	jal	ra,558 <vprintf>
}
 7f6:	60e2                	ld	ra,24(sp)
 7f8:	6442                	ld	s0,16(sp)
 7fa:	6161                	addi	sp,sp,80
 7fc:	8082                	ret

00000000000007fe <printf>:

void
printf(const char *fmt, ...)
{
 7fe:	711d                	addi	sp,sp,-96
 800:	ec06                	sd	ra,24(sp)
 802:	e822                	sd	s0,16(sp)
 804:	1000                	addi	s0,sp,32
 806:	e40c                	sd	a1,8(s0)
 808:	e810                	sd	a2,16(s0)
 80a:	ec14                	sd	a3,24(s0)
 80c:	f018                	sd	a4,32(s0)
 80e:	f41c                	sd	a5,40(s0)
 810:	03043823          	sd	a6,48(s0)
 814:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 818:	00840613          	addi	a2,s0,8
 81c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 820:	85aa                	mv	a1,a0
 822:	4505                	li	a0,1
 824:	d35ff0ef          	jal	ra,558 <vprintf>
}
 828:	60e2                	ld	ra,24(sp)
 82a:	6442                	ld	s0,16(sp)
 82c:	6125                	addi	sp,sp,96
 82e:	8082                	ret

0000000000000830 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 830:	1141                	addi	sp,sp,-16
 832:	e422                	sd	s0,8(sp)
 834:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 836:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 83a:	00000797          	auipc	a5,0x0
 83e:	7c67b783          	ld	a5,1990(a5) # 1000 <freep>
 842:	a805                	j	872 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 844:	4618                	lw	a4,8(a2)
 846:	9db9                	addw	a1,a1,a4
 848:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 84c:	6398                	ld	a4,0(a5)
 84e:	6318                	ld	a4,0(a4)
 850:	fee53823          	sd	a4,-16(a0)
 854:	a091                	j	898 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 856:	ff852703          	lw	a4,-8(a0)
 85a:	9e39                	addw	a2,a2,a4
 85c:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 85e:	ff053703          	ld	a4,-16(a0)
 862:	e398                	sd	a4,0(a5)
 864:	a099                	j	8aa <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 866:	6398                	ld	a4,0(a5)
 868:	00e7e463          	bltu	a5,a4,870 <free+0x40>
 86c:	00e6ea63          	bltu	a3,a4,880 <free+0x50>
{
 870:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 872:	fed7fae3          	bgeu	a5,a3,866 <free+0x36>
 876:	6398                	ld	a4,0(a5)
 878:	00e6e463          	bltu	a3,a4,880 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 87c:	fee7eae3          	bltu	a5,a4,870 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 880:	ff852583          	lw	a1,-8(a0)
 884:	6390                	ld	a2,0(a5)
 886:	02059713          	slli	a4,a1,0x20
 88a:	9301                	srli	a4,a4,0x20
 88c:	0712                	slli	a4,a4,0x4
 88e:	9736                	add	a4,a4,a3
 890:	fae60ae3          	beq	a2,a4,844 <free+0x14>
    bp->s.ptr = p->s.ptr;
 894:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 898:	4790                	lw	a2,8(a5)
 89a:	02061713          	slli	a4,a2,0x20
 89e:	9301                	srli	a4,a4,0x20
 8a0:	0712                	slli	a4,a4,0x4
 8a2:	973e                	add	a4,a4,a5
 8a4:	fae689e3          	beq	a3,a4,856 <free+0x26>
  } else
    p->s.ptr = bp;
 8a8:	e394                	sd	a3,0(a5)
  freep = p;
 8aa:	00000717          	auipc	a4,0x0
 8ae:	74f73b23          	sd	a5,1878(a4) # 1000 <freep>
}
 8b2:	6422                	ld	s0,8(sp)
 8b4:	0141                	addi	sp,sp,16
 8b6:	8082                	ret

00000000000008b8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8b8:	7139                	addi	sp,sp,-64
 8ba:	fc06                	sd	ra,56(sp)
 8bc:	f822                	sd	s0,48(sp)
 8be:	f426                	sd	s1,40(sp)
 8c0:	f04a                	sd	s2,32(sp)
 8c2:	ec4e                	sd	s3,24(sp)
 8c4:	e852                	sd	s4,16(sp)
 8c6:	e456                	sd	s5,8(sp)
 8c8:	e05a                	sd	s6,0(sp)
 8ca:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8cc:	02051493          	slli	s1,a0,0x20
 8d0:	9081                	srli	s1,s1,0x20
 8d2:	04bd                	addi	s1,s1,15
 8d4:	8091                	srli	s1,s1,0x4
 8d6:	0014899b          	addiw	s3,s1,1
 8da:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8dc:	00000517          	auipc	a0,0x0
 8e0:	72453503          	ld	a0,1828(a0) # 1000 <freep>
 8e4:	c515                	beqz	a0,910 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8e6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8e8:	4798                	lw	a4,8(a5)
 8ea:	02977f63          	bgeu	a4,s1,928 <malloc+0x70>
 8ee:	8a4e                	mv	s4,s3
 8f0:	0009871b          	sext.w	a4,s3
 8f4:	6685                	lui	a3,0x1
 8f6:	00d77363          	bgeu	a4,a3,8fc <malloc+0x44>
 8fa:	6a05                	lui	s4,0x1
 8fc:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 900:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 904:	00000917          	auipc	s2,0x0
 908:	6fc90913          	addi	s2,s2,1788 # 1000 <freep>
  if(p == (char*)-1)
 90c:	5afd                	li	s5,-1
 90e:	a0bd                	j	97c <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
 910:	00000797          	auipc	a5,0x0
 914:	70078793          	addi	a5,a5,1792 # 1010 <base>
 918:	00000717          	auipc	a4,0x0
 91c:	6ef73423          	sd	a5,1768(a4) # 1000 <freep>
 920:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 922:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 926:	b7e1                	j	8ee <malloc+0x36>
      if(p->s.size == nunits)
 928:	02e48b63          	beq	s1,a4,95e <malloc+0xa6>
        p->s.size -= nunits;
 92c:	4137073b          	subw	a4,a4,s3
 930:	c798                	sw	a4,8(a5)
        p += p->s.size;
 932:	1702                	slli	a4,a4,0x20
 934:	9301                	srli	a4,a4,0x20
 936:	0712                	slli	a4,a4,0x4
 938:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 93a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 93e:	00000717          	auipc	a4,0x0
 942:	6ca73123          	sd	a0,1730(a4) # 1000 <freep>
      return (void*)(p + 1);
 946:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 94a:	70e2                	ld	ra,56(sp)
 94c:	7442                	ld	s0,48(sp)
 94e:	74a2                	ld	s1,40(sp)
 950:	7902                	ld	s2,32(sp)
 952:	69e2                	ld	s3,24(sp)
 954:	6a42                	ld	s4,16(sp)
 956:	6aa2                	ld	s5,8(sp)
 958:	6b02                	ld	s6,0(sp)
 95a:	6121                	addi	sp,sp,64
 95c:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 95e:	6398                	ld	a4,0(a5)
 960:	e118                	sd	a4,0(a0)
 962:	bff1                	j	93e <malloc+0x86>
  hp->s.size = nu;
 964:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 968:	0541                	addi	a0,a0,16
 96a:	ec7ff0ef          	jal	ra,830 <free>
  return freep;
 96e:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 972:	dd61                	beqz	a0,94a <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 974:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 976:	4798                	lw	a4,8(a5)
 978:	fa9778e3          	bgeu	a4,s1,928 <malloc+0x70>
    if(p == freep)
 97c:	00093703          	ld	a4,0(s2)
 980:	853e                	mv	a0,a5
 982:	fef719e3          	bne	a4,a5,974 <malloc+0xbc>
  p = sbrk(nu * sizeof(Header));
 986:	8552                	mv	a0,s4
 988:	ae5ff0ef          	jal	ra,46c <sbrk>
  if(p == (char*)-1)
 98c:	fd551ce3          	bne	a0,s5,964 <malloc+0xac>
        return 0;
 990:	4501                	li	a0,0
 992:	bf65                	j	94a <malloc+0x92>
