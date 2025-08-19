
user/_sh:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <getcmd>:
  exit(0);
}

int
getcmd(char *buf, int nbuf)
{
       0:	1101                	addi	sp,sp,-32
       2:	ec06                	sd	ra,24(sp)
       4:	e822                	sd	s0,16(sp)
       6:	e426                	sd	s1,8(sp)
       8:	e04a                	sd	s2,0(sp)
       a:	1000                	addi	s0,sp,32
       c:	84aa                	mv	s1,a0
       e:	892e                	mv	s2,a1
  write(2, "$ ", 2);
      10:	4609                	li	a2,2
      12:	00001597          	auipc	a1,0x1
      16:	18e58593          	addi	a1,a1,398 # 11a0 <malloc+0xe0>
      1a:	4509                	li	a0,2
      1c:	3f1000ef          	jal	ra,c0c <write>
  memset(buf, 0, nbuf);
      20:	864a                	mv	a2,s2
      22:	4581                	li	a1,0
      24:	8526                	mv	a0,s1
      26:	1df000ef          	jal	ra,a04 <memset>
  gets(buf, nbuf);
      2a:	85ca                	mv	a1,s2
      2c:	8526                	mv	a0,s1
      2e:	21d000ef          	jal	ra,a4a <gets>
  if(buf[0] == 0) // EOF
      32:	0004c503          	lbu	a0,0(s1)
      36:	00153513          	seqz	a0,a0
    return -1;
  return 0;
}
      3a:	40a00533          	neg	a0,a0
      3e:	60e2                	ld	ra,24(sp)
      40:	6442                	ld	s0,16(sp)
      42:	64a2                	ld	s1,8(sp)
      44:	6902                	ld	s2,0(sp)
      46:	6105                	addi	sp,sp,32
      48:	8082                	ret

000000000000004a <panic>:
  exit(0);
}

void
panic(char *s)
{
      4a:	1141                	addi	sp,sp,-16
      4c:	e406                	sd	ra,8(sp)
      4e:	e022                	sd	s0,0(sp)
      50:	0800                	addi	s0,sp,16
      52:	862a                	mv	a2,a0
  fprintf(2, "%s\n", s);
      54:	00001597          	auipc	a1,0x1
      58:	15458593          	addi	a1,a1,340 # 11a8 <malloc+0xe8>
      5c:	4509                	li	a0,2
      5e:	77f000ef          	jal	ra,fdc <fprintf>
  exit(1);
      62:	4505                	li	a0,1
      64:	389000ef          	jal	ra,bec <exit>

0000000000000068 <fork1>:
}

int
fork1(void)
{
      68:	1141                	addi	sp,sp,-16
      6a:	e406                	sd	ra,8(sp)
      6c:	e022                	sd	s0,0(sp)
      6e:	0800                	addi	s0,sp,16
  int pid;

  pid = fork();
      70:	375000ef          	jal	ra,be4 <fork>
  if(pid == -1)
      74:	57fd                	li	a5,-1
      76:	00f50663          	beq	a0,a5,82 <fork1+0x1a>
    panic("fork");
  return pid;
}
      7a:	60a2                	ld	ra,8(sp)
      7c:	6402                	ld	s0,0(sp)
      7e:	0141                	addi	sp,sp,16
      80:	8082                	ret
    panic("fork");
      82:	00001517          	auipc	a0,0x1
      86:	12e50513          	addi	a0,a0,302 # 11b0 <malloc+0xf0>
      8a:	fc1ff0ef          	jal	ra,4a <panic>

000000000000008e <runcmd>:
{
      8e:	7179                	addi	sp,sp,-48
      90:	f406                	sd	ra,40(sp)
      92:	f022                	sd	s0,32(sp)
      94:	ec26                	sd	s1,24(sp)
      96:	1800                	addi	s0,sp,48
  if(cmd == 0)
      98:	c10d                	beqz	a0,ba <runcmd+0x2c>
      9a:	84aa                	mv	s1,a0
  switch(cmd->type){
      9c:	4118                	lw	a4,0(a0)
      9e:	4795                	li	a5,5
      a0:	02e7e063          	bltu	a5,a4,c0 <runcmd+0x32>
      a4:	00056783          	lwu	a5,0(a0)
      a8:	078a                	slli	a5,a5,0x2
      aa:	00001717          	auipc	a4,0x1
      ae:	20670713          	addi	a4,a4,518 # 12b0 <malloc+0x1f0>
      b2:	97ba                	add	a5,a5,a4
      b4:	439c                	lw	a5,0(a5)
      b6:	97ba                	add	a5,a5,a4
      b8:	8782                	jr	a5
    exit(1);
      ba:	4505                	li	a0,1
      bc:	331000ef          	jal	ra,bec <exit>
    panic("runcmd");
      c0:	00001517          	auipc	a0,0x1
      c4:	0f850513          	addi	a0,a0,248 # 11b8 <malloc+0xf8>
      c8:	f83ff0ef          	jal	ra,4a <panic>
    if(ecmd->argv[0] == 0)
      cc:	6508                	ld	a0,8(a0)
      ce:	c105                	beqz	a0,ee <runcmd+0x60>
    exec(ecmd->argv[0], ecmd->argv);
      d0:	00848593          	addi	a1,s1,8
      d4:	351000ef          	jal	ra,c24 <exec>
    fprintf(2, "exec %s failed\n", ecmd->argv[0]);
      d8:	6490                	ld	a2,8(s1)
      da:	00001597          	auipc	a1,0x1
      de:	0e658593          	addi	a1,a1,230 # 11c0 <malloc+0x100>
      e2:	4509                	li	a0,2
      e4:	6f9000ef          	jal	ra,fdc <fprintf>
  exit(0);
      e8:	4501                	li	a0,0
      ea:	303000ef          	jal	ra,bec <exit>
      exit(1);
      ee:	4505                	li	a0,1
      f0:	2fd000ef          	jal	ra,bec <exit>
    close(rcmd->fd);
      f4:	5148                	lw	a0,36(a0)
      f6:	31f000ef          	jal	ra,c14 <close>
    if(open(rcmd->file, rcmd->mode) < 0){
      fa:	508c                	lw	a1,32(s1)
      fc:	6888                	ld	a0,16(s1)
      fe:	32f000ef          	jal	ra,c2c <open>
     102:	00054563          	bltz	a0,10c <runcmd+0x7e>
    runcmd(rcmd->cmd);
     106:	6488                	ld	a0,8(s1)
     108:	f87ff0ef          	jal	ra,8e <runcmd>
      fprintf(2, "open %s failed\n", rcmd->file);
     10c:	6890                	ld	a2,16(s1)
     10e:	00001597          	auipc	a1,0x1
     112:	0c258593          	addi	a1,a1,194 # 11d0 <malloc+0x110>
     116:	4509                	li	a0,2
     118:	6c5000ef          	jal	ra,fdc <fprintf>
      exit(1);
     11c:	4505                	li	a0,1
     11e:	2cf000ef          	jal	ra,bec <exit>
    if(fork1() == 0)
     122:	f47ff0ef          	jal	ra,68 <fork1>
     126:	e501                	bnez	a0,12e <runcmd+0xa0>
      runcmd(lcmd->left);
     128:	6488                	ld	a0,8(s1)
     12a:	f65ff0ef          	jal	ra,8e <runcmd>
    wait(0);
     12e:	4501                	li	a0,0
     130:	2c5000ef          	jal	ra,bf4 <wait>
    runcmd(lcmd->right);
     134:	6888                	ld	a0,16(s1)
     136:	f59ff0ef          	jal	ra,8e <runcmd>
    if(pipe(p) < 0)
     13a:	fd840513          	addi	a0,s0,-40
     13e:	2bf000ef          	jal	ra,bfc <pipe>
     142:	02054763          	bltz	a0,170 <runcmd+0xe2>
    if(fork1() == 0){
     146:	f23ff0ef          	jal	ra,68 <fork1>
     14a:	e90d                	bnez	a0,17c <runcmd+0xee>
      close(1);
     14c:	4505                	li	a0,1
     14e:	2c7000ef          	jal	ra,c14 <close>
      dup(p[1]);
     152:	fdc42503          	lw	a0,-36(s0)
     156:	30f000ef          	jal	ra,c64 <dup>
      close(p[0]);
     15a:	fd842503          	lw	a0,-40(s0)
     15e:	2b7000ef          	jal	ra,c14 <close>
      close(p[1]);
     162:	fdc42503          	lw	a0,-36(s0)
     166:	2af000ef          	jal	ra,c14 <close>
      runcmd(pcmd->left);
     16a:	6488                	ld	a0,8(s1)
     16c:	f23ff0ef          	jal	ra,8e <runcmd>
      panic("pipe");
     170:	00001517          	auipc	a0,0x1
     174:	07050513          	addi	a0,a0,112 # 11e0 <malloc+0x120>
     178:	ed3ff0ef          	jal	ra,4a <panic>
    if(fork1() == 0){
     17c:	eedff0ef          	jal	ra,68 <fork1>
     180:	e115                	bnez	a0,1a4 <runcmd+0x116>
      close(0);
     182:	293000ef          	jal	ra,c14 <close>
      dup(p[0]);
     186:	fd842503          	lw	a0,-40(s0)
     18a:	2db000ef          	jal	ra,c64 <dup>
      close(p[0]);
     18e:	fd842503          	lw	a0,-40(s0)
     192:	283000ef          	jal	ra,c14 <close>
      close(p[1]);
     196:	fdc42503          	lw	a0,-36(s0)
     19a:	27b000ef          	jal	ra,c14 <close>
      runcmd(pcmd->right);
     19e:	6888                	ld	a0,16(s1)
     1a0:	eefff0ef          	jal	ra,8e <runcmd>
    close(p[0]);
     1a4:	fd842503          	lw	a0,-40(s0)
     1a8:	26d000ef          	jal	ra,c14 <close>
    close(p[1]);
     1ac:	fdc42503          	lw	a0,-36(s0)
     1b0:	265000ef          	jal	ra,c14 <close>
    wait(0);
     1b4:	4501                	li	a0,0
     1b6:	23f000ef          	jal	ra,bf4 <wait>
    wait(0);
     1ba:	4501                	li	a0,0
     1bc:	239000ef          	jal	ra,bf4 <wait>
    break;
     1c0:	b725                	j	e8 <runcmd+0x5a>
    if(fork1() == 0)
     1c2:	ea7ff0ef          	jal	ra,68 <fork1>
     1c6:	f20511e3          	bnez	a0,e8 <runcmd+0x5a>
      runcmd(bcmd->cmd);
     1ca:	6488                	ld	a0,8(s1)
     1cc:	ec3ff0ef          	jal	ra,8e <runcmd>

00000000000001d0 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     1d0:	1101                	addi	sp,sp,-32
     1d2:	ec06                	sd	ra,24(sp)
     1d4:	e822                	sd	s0,16(sp)
     1d6:	e426                	sd	s1,8(sp)
     1d8:	1000                	addi	s0,sp,32
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     1da:	0a800513          	li	a0,168
     1de:	6e3000ef          	jal	ra,10c0 <malloc>
     1e2:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     1e4:	0a800613          	li	a2,168
     1e8:	4581                	li	a1,0
     1ea:	01b000ef          	jal	ra,a04 <memset>
  cmd->type = EXEC;
     1ee:	4785                	li	a5,1
     1f0:	c09c                	sw	a5,0(s1)
  return (struct cmd*)cmd;
}
     1f2:	8526                	mv	a0,s1
     1f4:	60e2                	ld	ra,24(sp)
     1f6:	6442                	ld	s0,16(sp)
     1f8:	64a2                	ld	s1,8(sp)
     1fa:	6105                	addi	sp,sp,32
     1fc:	8082                	ret

00000000000001fe <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     1fe:	7139                	addi	sp,sp,-64
     200:	fc06                	sd	ra,56(sp)
     202:	f822                	sd	s0,48(sp)
     204:	f426                	sd	s1,40(sp)
     206:	f04a                	sd	s2,32(sp)
     208:	ec4e                	sd	s3,24(sp)
     20a:	e852                	sd	s4,16(sp)
     20c:	e456                	sd	s5,8(sp)
     20e:	e05a                	sd	s6,0(sp)
     210:	0080                	addi	s0,sp,64
     212:	8b2a                	mv	s6,a0
     214:	8aae                	mv	s5,a1
     216:	8a32                	mv	s4,a2
     218:	89b6                	mv	s3,a3
     21a:	893a                	mv	s2,a4
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     21c:	02800513          	li	a0,40
     220:	6a1000ef          	jal	ra,10c0 <malloc>
     224:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     226:	02800613          	li	a2,40
     22a:	4581                	li	a1,0
     22c:	7d8000ef          	jal	ra,a04 <memset>
  cmd->type = REDIR;
     230:	4789                	li	a5,2
     232:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     234:	0164b423          	sd	s6,8(s1)
  cmd->file = file;
     238:	0154b823          	sd	s5,16(s1)
  cmd->efile = efile;
     23c:	0144bc23          	sd	s4,24(s1)
  cmd->mode = mode;
     240:	0334a023          	sw	s3,32(s1)
  cmd->fd = fd;
     244:	0324a223          	sw	s2,36(s1)
  return (struct cmd*)cmd;
}
     248:	8526                	mv	a0,s1
     24a:	70e2                	ld	ra,56(sp)
     24c:	7442                	ld	s0,48(sp)
     24e:	74a2                	ld	s1,40(sp)
     250:	7902                	ld	s2,32(sp)
     252:	69e2                	ld	s3,24(sp)
     254:	6a42                	ld	s4,16(sp)
     256:	6aa2                	ld	s5,8(sp)
     258:	6b02                	ld	s6,0(sp)
     25a:	6121                	addi	sp,sp,64
     25c:	8082                	ret

000000000000025e <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     25e:	7179                	addi	sp,sp,-48
     260:	f406                	sd	ra,40(sp)
     262:	f022                	sd	s0,32(sp)
     264:	ec26                	sd	s1,24(sp)
     266:	e84a                	sd	s2,16(sp)
     268:	e44e                	sd	s3,8(sp)
     26a:	1800                	addi	s0,sp,48
     26c:	89aa                	mv	s3,a0
     26e:	892e                	mv	s2,a1
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     270:	4561                	li	a0,24
     272:	64f000ef          	jal	ra,10c0 <malloc>
     276:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     278:	4661                	li	a2,24
     27a:	4581                	li	a1,0
     27c:	788000ef          	jal	ra,a04 <memset>
  cmd->type = PIPE;
     280:	478d                	li	a5,3
     282:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     284:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     288:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
     28c:	8526                	mv	a0,s1
     28e:	70a2                	ld	ra,40(sp)
     290:	7402                	ld	s0,32(sp)
     292:	64e2                	ld	s1,24(sp)
     294:	6942                	ld	s2,16(sp)
     296:	69a2                	ld	s3,8(sp)
     298:	6145                	addi	sp,sp,48
     29a:	8082                	ret

000000000000029c <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     29c:	7179                	addi	sp,sp,-48
     29e:	f406                	sd	ra,40(sp)
     2a0:	f022                	sd	s0,32(sp)
     2a2:	ec26                	sd	s1,24(sp)
     2a4:	e84a                	sd	s2,16(sp)
     2a6:	e44e                	sd	s3,8(sp)
     2a8:	1800                	addi	s0,sp,48
     2aa:	89aa                	mv	s3,a0
     2ac:	892e                	mv	s2,a1
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2ae:	4561                	li	a0,24
     2b0:	611000ef          	jal	ra,10c0 <malloc>
     2b4:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     2b6:	4661                	li	a2,24
     2b8:	4581                	li	a1,0
     2ba:	74a000ef          	jal	ra,a04 <memset>
  cmd->type = LIST;
     2be:	4791                	li	a5,4
     2c0:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     2c2:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     2c6:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
     2ca:	8526                	mv	a0,s1
     2cc:	70a2                	ld	ra,40(sp)
     2ce:	7402                	ld	s0,32(sp)
     2d0:	64e2                	ld	s1,24(sp)
     2d2:	6942                	ld	s2,16(sp)
     2d4:	69a2                	ld	s3,8(sp)
     2d6:	6145                	addi	sp,sp,48
     2d8:	8082                	ret

00000000000002da <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     2da:	1101                	addi	sp,sp,-32
     2dc:	ec06                	sd	ra,24(sp)
     2de:	e822                	sd	s0,16(sp)
     2e0:	e426                	sd	s1,8(sp)
     2e2:	e04a                	sd	s2,0(sp)
     2e4:	1000                	addi	s0,sp,32
     2e6:	892a                	mv	s2,a0
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2e8:	4541                	li	a0,16
     2ea:	5d7000ef          	jal	ra,10c0 <malloc>
     2ee:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     2f0:	4641                	li	a2,16
     2f2:	4581                	li	a1,0
     2f4:	710000ef          	jal	ra,a04 <memset>
  cmd->type = BACK;
     2f8:	4795                	li	a5,5
     2fa:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     2fc:	0124b423          	sd	s2,8(s1)
  return (struct cmd*)cmd;
}
     300:	8526                	mv	a0,s1
     302:	60e2                	ld	ra,24(sp)
     304:	6442                	ld	s0,16(sp)
     306:	64a2                	ld	s1,8(sp)
     308:	6902                	ld	s2,0(sp)
     30a:	6105                	addi	sp,sp,32
     30c:	8082                	ret

000000000000030e <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     30e:	7139                	addi	sp,sp,-64
     310:	fc06                	sd	ra,56(sp)
     312:	f822                	sd	s0,48(sp)
     314:	f426                	sd	s1,40(sp)
     316:	f04a                	sd	s2,32(sp)
     318:	ec4e                	sd	s3,24(sp)
     31a:	e852                	sd	s4,16(sp)
     31c:	e456                	sd	s5,8(sp)
     31e:	e05a                	sd	s6,0(sp)
     320:	0080                	addi	s0,sp,64
     322:	8a2a                	mv	s4,a0
     324:	892e                	mv	s2,a1
     326:	8ab2                	mv	s5,a2
     328:	8b36                	mv	s6,a3
  char *s;
  int ret;

  s = *ps;
     32a:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     32c:	00002997          	auipc	s3,0x2
     330:	cdc98993          	addi	s3,s3,-804 # 2008 <whitespace>
     334:	00b4fb63          	bgeu	s1,a1,34a <gettoken+0x3c>
     338:	0004c583          	lbu	a1,0(s1)
     33c:	854e                	mv	a0,s3
     33e:	6e8000ef          	jal	ra,a26 <strchr>
     342:	c501                	beqz	a0,34a <gettoken+0x3c>
    s++;
     344:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     346:	fe9919e3          	bne	s2,s1,338 <gettoken+0x2a>
  if(q)
     34a:	000a8463          	beqz	s5,352 <gettoken+0x44>
    *q = s;
     34e:	009ab023          	sd	s1,0(s5)
  ret = *s;
     352:	0004c783          	lbu	a5,0(s1)
     356:	00078a9b          	sext.w	s5,a5
  switch(*s){
     35a:	03c00713          	li	a4,60
     35e:	06f76363          	bltu	a4,a5,3c4 <gettoken+0xb6>
     362:	03a00713          	li	a4,58
     366:	00f76e63          	bltu	a4,a5,382 <gettoken+0x74>
     36a:	cf89                	beqz	a5,384 <gettoken+0x76>
     36c:	02600713          	li	a4,38
     370:	00e78963          	beq	a5,a4,382 <gettoken+0x74>
     374:	fd87879b          	addiw	a5,a5,-40
     378:	0ff7f793          	andi	a5,a5,255
     37c:	4705                	li	a4,1
     37e:	06f76a63          	bltu	a4,a5,3f2 <gettoken+0xe4>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     382:	0485                	addi	s1,s1,1
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     384:	000b0463          	beqz	s6,38c <gettoken+0x7e>
    *eq = s;
     388:	009b3023          	sd	s1,0(s6)

  while(s < es && strchr(whitespace, *s))
     38c:	00002997          	auipc	s3,0x2
     390:	c7c98993          	addi	s3,s3,-900 # 2008 <whitespace>
     394:	0124fb63          	bgeu	s1,s2,3aa <gettoken+0x9c>
     398:	0004c583          	lbu	a1,0(s1)
     39c:	854e                	mv	a0,s3
     39e:	688000ef          	jal	ra,a26 <strchr>
     3a2:	c501                	beqz	a0,3aa <gettoken+0x9c>
    s++;
     3a4:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     3a6:	fe9919e3          	bne	s2,s1,398 <gettoken+0x8a>
  *ps = s;
     3aa:	009a3023          	sd	s1,0(s4)
  return ret;
}
     3ae:	8556                	mv	a0,s5
     3b0:	70e2                	ld	ra,56(sp)
     3b2:	7442                	ld	s0,48(sp)
     3b4:	74a2                	ld	s1,40(sp)
     3b6:	7902                	ld	s2,32(sp)
     3b8:	69e2                	ld	s3,24(sp)
     3ba:	6a42                	ld	s4,16(sp)
     3bc:	6aa2                	ld	s5,8(sp)
     3be:	6b02                	ld	s6,0(sp)
     3c0:	6121                	addi	sp,sp,64
     3c2:	8082                	ret
  switch(*s){
     3c4:	03e00713          	li	a4,62
     3c8:	02e79163          	bne	a5,a4,3ea <gettoken+0xdc>
    s++;
     3cc:	00148693          	addi	a3,s1,1
    if(*s == '>'){
     3d0:	0014c703          	lbu	a4,1(s1)
     3d4:	03e00793          	li	a5,62
      s++;
     3d8:	0489                	addi	s1,s1,2
      ret = '+';
     3da:	02b00a93          	li	s5,43
    if(*s == '>'){
     3de:	faf703e3          	beq	a4,a5,384 <gettoken+0x76>
    s++;
     3e2:	84b6                	mv	s1,a3
  ret = *s;
     3e4:	03e00a93          	li	s5,62
     3e8:	bf71                	j	384 <gettoken+0x76>
  switch(*s){
     3ea:	07c00713          	li	a4,124
     3ee:	f8e78ae3          	beq	a5,a4,382 <gettoken+0x74>
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     3f2:	00002997          	auipc	s3,0x2
     3f6:	c1698993          	addi	s3,s3,-1002 # 2008 <whitespace>
     3fa:	00002a97          	auipc	s5,0x2
     3fe:	c06a8a93          	addi	s5,s5,-1018 # 2000 <symbols>
     402:	0324f163          	bgeu	s1,s2,424 <gettoken+0x116>
     406:	0004c583          	lbu	a1,0(s1)
     40a:	854e                	mv	a0,s3
     40c:	61a000ef          	jal	ra,a26 <strchr>
     410:	e115                	bnez	a0,434 <gettoken+0x126>
     412:	0004c583          	lbu	a1,0(s1)
     416:	8556                	mv	a0,s5
     418:	60e000ef          	jal	ra,a26 <strchr>
     41c:	e909                	bnez	a0,42e <gettoken+0x120>
      s++;
     41e:	0485                	addi	s1,s1,1
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     420:	fe9913e3          	bne	s2,s1,406 <gettoken+0xf8>
  if(eq)
     424:	06100a93          	li	s5,97
     428:	f60b10e3          	bnez	s6,388 <gettoken+0x7a>
     42c:	bfbd                	j	3aa <gettoken+0x9c>
    ret = 'a';
     42e:	06100a93          	li	s5,97
     432:	bf89                	j	384 <gettoken+0x76>
     434:	06100a93          	li	s5,97
     438:	b7b1                	j	384 <gettoken+0x76>

000000000000043a <peek>:

int
peek(char **ps, char *es, char *toks)
{
     43a:	7139                	addi	sp,sp,-64
     43c:	fc06                	sd	ra,56(sp)
     43e:	f822                	sd	s0,48(sp)
     440:	f426                	sd	s1,40(sp)
     442:	f04a                	sd	s2,32(sp)
     444:	ec4e                	sd	s3,24(sp)
     446:	e852                	sd	s4,16(sp)
     448:	e456                	sd	s5,8(sp)
     44a:	0080                	addi	s0,sp,64
     44c:	8a2a                	mv	s4,a0
     44e:	892e                	mv	s2,a1
     450:	8ab2                	mv	s5,a2
  char *s;

  s = *ps;
     452:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     454:	00002997          	auipc	s3,0x2
     458:	bb498993          	addi	s3,s3,-1100 # 2008 <whitespace>
     45c:	00b4fb63          	bgeu	s1,a1,472 <peek+0x38>
     460:	0004c583          	lbu	a1,0(s1)
     464:	854e                	mv	a0,s3
     466:	5c0000ef          	jal	ra,a26 <strchr>
     46a:	c501                	beqz	a0,472 <peek+0x38>
    s++;
     46c:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     46e:	fe9919e3          	bne	s2,s1,460 <peek+0x26>
  *ps = s;
     472:	009a3023          	sd	s1,0(s4)
  return *s && strchr(toks, *s);
     476:	0004c583          	lbu	a1,0(s1)
     47a:	4501                	li	a0,0
     47c:	e991                	bnez	a1,490 <peek+0x56>
}
     47e:	70e2                	ld	ra,56(sp)
     480:	7442                	ld	s0,48(sp)
     482:	74a2                	ld	s1,40(sp)
     484:	7902                	ld	s2,32(sp)
     486:	69e2                	ld	s3,24(sp)
     488:	6a42                	ld	s4,16(sp)
     48a:	6aa2                	ld	s5,8(sp)
     48c:	6121                	addi	sp,sp,64
     48e:	8082                	ret
  return *s && strchr(toks, *s);
     490:	8556                	mv	a0,s5
     492:	594000ef          	jal	ra,a26 <strchr>
     496:	00a03533          	snez	a0,a0
     49a:	b7d5                	j	47e <peek+0x44>

000000000000049c <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     49c:	7159                	addi	sp,sp,-112
     49e:	f486                	sd	ra,104(sp)
     4a0:	f0a2                	sd	s0,96(sp)
     4a2:	eca6                	sd	s1,88(sp)
     4a4:	e8ca                	sd	s2,80(sp)
     4a6:	e4ce                	sd	s3,72(sp)
     4a8:	e0d2                	sd	s4,64(sp)
     4aa:	fc56                	sd	s5,56(sp)
     4ac:	f85a                	sd	s6,48(sp)
     4ae:	f45e                	sd	s7,40(sp)
     4b0:	f062                	sd	s8,32(sp)
     4b2:	ec66                	sd	s9,24(sp)
     4b4:	1880                	addi	s0,sp,112
     4b6:	8a2a                	mv	s4,a0
     4b8:	89ae                	mv	s3,a1
     4ba:	8932                	mv	s2,a2
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     4bc:	00001b97          	auipc	s7,0x1
     4c0:	d4cb8b93          	addi	s7,s7,-692 # 1208 <malloc+0x148>
    tok = gettoken(ps, es, 0, 0);
    if(gettoken(ps, es, &q, &eq) != 'a')
     4c4:	06100c13          	li	s8,97
      panic("missing file for redirection");
    switch(tok){
     4c8:	03c00c93          	li	s9,60
  while(peek(ps, es, "<>")){
     4cc:	a00d                	j	4ee <parseredirs+0x52>
      panic("missing file for redirection");
     4ce:	00001517          	auipc	a0,0x1
     4d2:	d1a50513          	addi	a0,a0,-742 # 11e8 <malloc+0x128>
     4d6:	b75ff0ef          	jal	ra,4a <panic>
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     4da:	4701                	li	a4,0
     4dc:	4681                	li	a3,0
     4de:	f9043603          	ld	a2,-112(s0)
     4e2:	f9843583          	ld	a1,-104(s0)
     4e6:	8552                	mv	a0,s4
     4e8:	d17ff0ef          	jal	ra,1fe <redircmd>
     4ec:	8a2a                	mv	s4,a0
    switch(tok){
     4ee:	03e00b13          	li	s6,62
     4f2:	02b00a93          	li	s5,43
  while(peek(ps, es, "<>")){
     4f6:	865e                	mv	a2,s7
     4f8:	85ca                	mv	a1,s2
     4fa:	854e                	mv	a0,s3
     4fc:	f3fff0ef          	jal	ra,43a <peek>
     500:	c125                	beqz	a0,560 <parseredirs+0xc4>
    tok = gettoken(ps, es, 0, 0);
     502:	4681                	li	a3,0
     504:	4601                	li	a2,0
     506:	85ca                	mv	a1,s2
     508:	854e                	mv	a0,s3
     50a:	e05ff0ef          	jal	ra,30e <gettoken>
     50e:	84aa                	mv	s1,a0
    if(gettoken(ps, es, &q, &eq) != 'a')
     510:	f9040693          	addi	a3,s0,-112
     514:	f9840613          	addi	a2,s0,-104
     518:	85ca                	mv	a1,s2
     51a:	854e                	mv	a0,s3
     51c:	df3ff0ef          	jal	ra,30e <gettoken>
     520:	fb8517e3          	bne	a0,s8,4ce <parseredirs+0x32>
    switch(tok){
     524:	fb948be3          	beq	s1,s9,4da <parseredirs+0x3e>
     528:	03648063          	beq	s1,s6,548 <parseredirs+0xac>
     52c:	fd5495e3          	bne	s1,s5,4f6 <parseredirs+0x5a>
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     530:	4705                	li	a4,1
     532:	20100693          	li	a3,513
     536:	f9043603          	ld	a2,-112(s0)
     53a:	f9843583          	ld	a1,-104(s0)
     53e:	8552                	mv	a0,s4
     540:	cbfff0ef          	jal	ra,1fe <redircmd>
     544:	8a2a                	mv	s4,a0
      break;
     546:	b765                	j	4ee <parseredirs+0x52>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
     548:	4705                	li	a4,1
     54a:	60100693          	li	a3,1537
     54e:	f9043603          	ld	a2,-112(s0)
     552:	f9843583          	ld	a1,-104(s0)
     556:	8552                	mv	a0,s4
     558:	ca7ff0ef          	jal	ra,1fe <redircmd>
     55c:	8a2a                	mv	s4,a0
      break;
     55e:	bf41                	j	4ee <parseredirs+0x52>
    }
  }
  return cmd;
}
     560:	8552                	mv	a0,s4
     562:	70a6                	ld	ra,104(sp)
     564:	7406                	ld	s0,96(sp)
     566:	64e6                	ld	s1,88(sp)
     568:	6946                	ld	s2,80(sp)
     56a:	69a6                	ld	s3,72(sp)
     56c:	6a06                	ld	s4,64(sp)
     56e:	7ae2                	ld	s5,56(sp)
     570:	7b42                	ld	s6,48(sp)
     572:	7ba2                	ld	s7,40(sp)
     574:	7c02                	ld	s8,32(sp)
     576:	6ce2                	ld	s9,24(sp)
     578:	6165                	addi	sp,sp,112
     57a:	8082                	ret

000000000000057c <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
     57c:	7159                	addi	sp,sp,-112
     57e:	f486                	sd	ra,104(sp)
     580:	f0a2                	sd	s0,96(sp)
     582:	eca6                	sd	s1,88(sp)
     584:	e8ca                	sd	s2,80(sp)
     586:	e4ce                	sd	s3,72(sp)
     588:	e0d2                	sd	s4,64(sp)
     58a:	fc56                	sd	s5,56(sp)
     58c:	f85a                	sd	s6,48(sp)
     58e:	f45e                	sd	s7,40(sp)
     590:	f062                	sd	s8,32(sp)
     592:	ec66                	sd	s9,24(sp)
     594:	1880                	addi	s0,sp,112
     596:	8a2a                	mv	s4,a0
     598:	8aae                	mv	s5,a1
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
     59a:	00001617          	auipc	a2,0x1
     59e:	c7660613          	addi	a2,a2,-906 # 1210 <malloc+0x150>
     5a2:	e99ff0ef          	jal	ra,43a <peek>
     5a6:	e505                	bnez	a0,5ce <parseexec+0x52>
     5a8:	89aa                	mv	s3,a0
    return parseblock(ps, es);

  ret = execcmd();
     5aa:	c27ff0ef          	jal	ra,1d0 <execcmd>
     5ae:	8c2a                	mv	s8,a0
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     5b0:	8656                	mv	a2,s5
     5b2:	85d2                	mv	a1,s4
     5b4:	ee9ff0ef          	jal	ra,49c <parseredirs>
     5b8:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     5ba:	008c0913          	addi	s2,s8,8
     5be:	00001b17          	auipc	s6,0x1
     5c2:	c72b0b13          	addi	s6,s6,-910 # 1230 <malloc+0x170>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
      break;
    if(tok != 'a')
     5c6:	06100c93          	li	s9,97
      panic("syntax");
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if(argc >= MAXARGS)
     5ca:	4ba9                	li	s7,10
  while(!peek(ps, es, "|)&;")){
     5cc:	a081                	j	60c <parseexec+0x90>
    return parseblock(ps, es);
     5ce:	85d6                	mv	a1,s5
     5d0:	8552                	mv	a0,s4
     5d2:	170000ef          	jal	ra,742 <parseblock>
     5d6:	84aa                	mv	s1,a0
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
     5d8:	8526                	mv	a0,s1
     5da:	70a6                	ld	ra,104(sp)
     5dc:	7406                	ld	s0,96(sp)
     5de:	64e6                	ld	s1,88(sp)
     5e0:	6946                	ld	s2,80(sp)
     5e2:	69a6                	ld	s3,72(sp)
     5e4:	6a06                	ld	s4,64(sp)
     5e6:	7ae2                	ld	s5,56(sp)
     5e8:	7b42                	ld	s6,48(sp)
     5ea:	7ba2                	ld	s7,40(sp)
     5ec:	7c02                	ld	s8,32(sp)
     5ee:	6ce2                	ld	s9,24(sp)
     5f0:	6165                	addi	sp,sp,112
     5f2:	8082                	ret
      panic("syntax");
     5f4:	00001517          	auipc	a0,0x1
     5f8:	c2450513          	addi	a0,a0,-988 # 1218 <malloc+0x158>
     5fc:	a4fff0ef          	jal	ra,4a <panic>
    ret = parseredirs(ret, ps, es);
     600:	8656                	mv	a2,s5
     602:	85d2                	mv	a1,s4
     604:	8526                	mv	a0,s1
     606:	e97ff0ef          	jal	ra,49c <parseredirs>
     60a:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     60c:	865a                	mv	a2,s6
     60e:	85d6                	mv	a1,s5
     610:	8552                	mv	a0,s4
     612:	e29ff0ef          	jal	ra,43a <peek>
     616:	ed15                	bnez	a0,652 <parseexec+0xd6>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     618:	f9040693          	addi	a3,s0,-112
     61c:	f9840613          	addi	a2,s0,-104
     620:	85d6                	mv	a1,s5
     622:	8552                	mv	a0,s4
     624:	cebff0ef          	jal	ra,30e <gettoken>
     628:	c50d                	beqz	a0,652 <parseexec+0xd6>
    if(tok != 'a')
     62a:	fd9515e3          	bne	a0,s9,5f4 <parseexec+0x78>
    cmd->argv[argc] = q;
     62e:	f9843783          	ld	a5,-104(s0)
     632:	00f93023          	sd	a5,0(s2)
    cmd->eargv[argc] = eq;
     636:	f9043783          	ld	a5,-112(s0)
     63a:	04f93823          	sd	a5,80(s2)
    argc++;
     63e:	2985                	addiw	s3,s3,1
    if(argc >= MAXARGS)
     640:	0921                	addi	s2,s2,8
     642:	fb799fe3          	bne	s3,s7,600 <parseexec+0x84>
      panic("too many args");
     646:	00001517          	auipc	a0,0x1
     64a:	bda50513          	addi	a0,a0,-1062 # 1220 <malloc+0x160>
     64e:	9fdff0ef          	jal	ra,4a <panic>
  cmd->argv[argc] = 0;
     652:	098e                	slli	s3,s3,0x3
     654:	99e2                	add	s3,s3,s8
     656:	0009b423          	sd	zero,8(s3)
  cmd->eargv[argc] = 0;
     65a:	0409bc23          	sd	zero,88(s3)
  return ret;
     65e:	bfad                	j	5d8 <parseexec+0x5c>

0000000000000660 <parsepipe>:
{
     660:	7179                	addi	sp,sp,-48
     662:	f406                	sd	ra,40(sp)
     664:	f022                	sd	s0,32(sp)
     666:	ec26                	sd	s1,24(sp)
     668:	e84a                	sd	s2,16(sp)
     66a:	e44e                	sd	s3,8(sp)
     66c:	1800                	addi	s0,sp,48
     66e:	892a                	mv	s2,a0
     670:	89ae                	mv	s3,a1
  cmd = parseexec(ps, es);
     672:	f0bff0ef          	jal	ra,57c <parseexec>
     676:	84aa                	mv	s1,a0
  if(peek(ps, es, "|")){
     678:	00001617          	auipc	a2,0x1
     67c:	bc060613          	addi	a2,a2,-1088 # 1238 <malloc+0x178>
     680:	85ce                	mv	a1,s3
     682:	854a                	mv	a0,s2
     684:	db7ff0ef          	jal	ra,43a <peek>
     688:	e909                	bnez	a0,69a <parsepipe+0x3a>
}
     68a:	8526                	mv	a0,s1
     68c:	70a2                	ld	ra,40(sp)
     68e:	7402                	ld	s0,32(sp)
     690:	64e2                	ld	s1,24(sp)
     692:	6942                	ld	s2,16(sp)
     694:	69a2                	ld	s3,8(sp)
     696:	6145                	addi	sp,sp,48
     698:	8082                	ret
    gettoken(ps, es, 0, 0);
     69a:	4681                	li	a3,0
     69c:	4601                	li	a2,0
     69e:	85ce                	mv	a1,s3
     6a0:	854a                	mv	a0,s2
     6a2:	c6dff0ef          	jal	ra,30e <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     6a6:	85ce                	mv	a1,s3
     6a8:	854a                	mv	a0,s2
     6aa:	fb7ff0ef          	jal	ra,660 <parsepipe>
     6ae:	85aa                	mv	a1,a0
     6b0:	8526                	mv	a0,s1
     6b2:	badff0ef          	jal	ra,25e <pipecmd>
     6b6:	84aa                	mv	s1,a0
  return cmd;
     6b8:	bfc9                	j	68a <parsepipe+0x2a>

00000000000006ba <parseline>:
{
     6ba:	7179                	addi	sp,sp,-48
     6bc:	f406                	sd	ra,40(sp)
     6be:	f022                	sd	s0,32(sp)
     6c0:	ec26                	sd	s1,24(sp)
     6c2:	e84a                	sd	s2,16(sp)
     6c4:	e44e                	sd	s3,8(sp)
     6c6:	e052                	sd	s4,0(sp)
     6c8:	1800                	addi	s0,sp,48
     6ca:	892a                	mv	s2,a0
     6cc:	89ae                	mv	s3,a1
  cmd = parsepipe(ps, es);
     6ce:	f93ff0ef          	jal	ra,660 <parsepipe>
     6d2:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
     6d4:	00001a17          	auipc	s4,0x1
     6d8:	b6ca0a13          	addi	s4,s4,-1172 # 1240 <malloc+0x180>
     6dc:	a819                	j	6f2 <parseline+0x38>
    gettoken(ps, es, 0, 0);
     6de:	4681                	li	a3,0
     6e0:	4601                	li	a2,0
     6e2:	85ce                	mv	a1,s3
     6e4:	854a                	mv	a0,s2
     6e6:	c29ff0ef          	jal	ra,30e <gettoken>
    cmd = backcmd(cmd);
     6ea:	8526                	mv	a0,s1
     6ec:	befff0ef          	jal	ra,2da <backcmd>
     6f0:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
     6f2:	8652                	mv	a2,s4
     6f4:	85ce                	mv	a1,s3
     6f6:	854a                	mv	a0,s2
     6f8:	d43ff0ef          	jal	ra,43a <peek>
     6fc:	f16d                	bnez	a0,6de <parseline+0x24>
  if(peek(ps, es, ";")){
     6fe:	00001617          	auipc	a2,0x1
     702:	b4a60613          	addi	a2,a2,-1206 # 1248 <malloc+0x188>
     706:	85ce                	mv	a1,s3
     708:	854a                	mv	a0,s2
     70a:	d31ff0ef          	jal	ra,43a <peek>
     70e:	e911                	bnez	a0,722 <parseline+0x68>
}
     710:	8526                	mv	a0,s1
     712:	70a2                	ld	ra,40(sp)
     714:	7402                	ld	s0,32(sp)
     716:	64e2                	ld	s1,24(sp)
     718:	6942                	ld	s2,16(sp)
     71a:	69a2                	ld	s3,8(sp)
     71c:	6a02                	ld	s4,0(sp)
     71e:	6145                	addi	sp,sp,48
     720:	8082                	ret
    gettoken(ps, es, 0, 0);
     722:	4681                	li	a3,0
     724:	4601                	li	a2,0
     726:	85ce                	mv	a1,s3
     728:	854a                	mv	a0,s2
     72a:	be5ff0ef          	jal	ra,30e <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     72e:	85ce                	mv	a1,s3
     730:	854a                	mv	a0,s2
     732:	f89ff0ef          	jal	ra,6ba <parseline>
     736:	85aa                	mv	a1,a0
     738:	8526                	mv	a0,s1
     73a:	b63ff0ef          	jal	ra,29c <listcmd>
     73e:	84aa                	mv	s1,a0
  return cmd;
     740:	bfc1                	j	710 <parseline+0x56>

0000000000000742 <parseblock>:
{
     742:	7179                	addi	sp,sp,-48
     744:	f406                	sd	ra,40(sp)
     746:	f022                	sd	s0,32(sp)
     748:	ec26                	sd	s1,24(sp)
     74a:	e84a                	sd	s2,16(sp)
     74c:	e44e                	sd	s3,8(sp)
     74e:	1800                	addi	s0,sp,48
     750:	84aa                	mv	s1,a0
     752:	892e                	mv	s2,a1
  if(!peek(ps, es, "("))
     754:	00001617          	auipc	a2,0x1
     758:	abc60613          	addi	a2,a2,-1348 # 1210 <malloc+0x150>
     75c:	cdfff0ef          	jal	ra,43a <peek>
     760:	c539                	beqz	a0,7ae <parseblock+0x6c>
  gettoken(ps, es, 0, 0);
     762:	4681                	li	a3,0
     764:	4601                	li	a2,0
     766:	85ca                	mv	a1,s2
     768:	8526                	mv	a0,s1
     76a:	ba5ff0ef          	jal	ra,30e <gettoken>
  cmd = parseline(ps, es);
     76e:	85ca                	mv	a1,s2
     770:	8526                	mv	a0,s1
     772:	f49ff0ef          	jal	ra,6ba <parseline>
     776:	89aa                	mv	s3,a0
  if(!peek(ps, es, ")"))
     778:	00001617          	auipc	a2,0x1
     77c:	ae860613          	addi	a2,a2,-1304 # 1260 <malloc+0x1a0>
     780:	85ca                	mv	a1,s2
     782:	8526                	mv	a0,s1
     784:	cb7ff0ef          	jal	ra,43a <peek>
     788:	c90d                	beqz	a0,7ba <parseblock+0x78>
  gettoken(ps, es, 0, 0);
     78a:	4681                	li	a3,0
     78c:	4601                	li	a2,0
     78e:	85ca                	mv	a1,s2
     790:	8526                	mv	a0,s1
     792:	b7dff0ef          	jal	ra,30e <gettoken>
  cmd = parseredirs(cmd, ps, es);
     796:	864a                	mv	a2,s2
     798:	85a6                	mv	a1,s1
     79a:	854e                	mv	a0,s3
     79c:	d01ff0ef          	jal	ra,49c <parseredirs>
}
     7a0:	70a2                	ld	ra,40(sp)
     7a2:	7402                	ld	s0,32(sp)
     7a4:	64e2                	ld	s1,24(sp)
     7a6:	6942                	ld	s2,16(sp)
     7a8:	69a2                	ld	s3,8(sp)
     7aa:	6145                	addi	sp,sp,48
     7ac:	8082                	ret
    panic("parseblock");
     7ae:	00001517          	auipc	a0,0x1
     7b2:	aa250513          	addi	a0,a0,-1374 # 1250 <malloc+0x190>
     7b6:	895ff0ef          	jal	ra,4a <panic>
    panic("syntax - missing )");
     7ba:	00001517          	auipc	a0,0x1
     7be:	aae50513          	addi	a0,a0,-1362 # 1268 <malloc+0x1a8>
     7c2:	889ff0ef          	jal	ra,4a <panic>

00000000000007c6 <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     7c6:	1101                	addi	sp,sp,-32
     7c8:	ec06                	sd	ra,24(sp)
     7ca:	e822                	sd	s0,16(sp)
     7cc:	e426                	sd	s1,8(sp)
     7ce:	1000                	addi	s0,sp,32
     7d0:	84aa                	mv	s1,a0
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     7d2:	c131                	beqz	a0,816 <nulterminate+0x50>
    return 0;

  switch(cmd->type){
     7d4:	4118                	lw	a4,0(a0)
     7d6:	4795                	li	a5,5
     7d8:	02e7ef63          	bltu	a5,a4,816 <nulterminate+0x50>
     7dc:	00056783          	lwu	a5,0(a0)
     7e0:	078a                	slli	a5,a5,0x2
     7e2:	00001717          	auipc	a4,0x1
     7e6:	ae670713          	addi	a4,a4,-1306 # 12c8 <malloc+0x208>
     7ea:	97ba                	add	a5,a5,a4
     7ec:	439c                	lw	a5,0(a5)
     7ee:	97ba                	add	a5,a5,a4
     7f0:	8782                	jr	a5
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
     7f2:	651c                	ld	a5,8(a0)
     7f4:	c38d                	beqz	a5,816 <nulterminate+0x50>
     7f6:	01050793          	addi	a5,a0,16
      *ecmd->eargv[i] = 0;
     7fa:	67b8                	ld	a4,72(a5)
     7fc:	00070023          	sb	zero,0(a4)
    for(i=0; ecmd->argv[i]; i++)
     800:	07a1                	addi	a5,a5,8
     802:	ff87b703          	ld	a4,-8(a5)
     806:	fb75                	bnez	a4,7fa <nulterminate+0x34>
     808:	a039                	j	816 <nulterminate+0x50>
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    nulterminate(rcmd->cmd);
     80a:	6508                	ld	a0,8(a0)
     80c:	fbbff0ef          	jal	ra,7c6 <nulterminate>
    *rcmd->efile = 0;
     810:	6c9c                	ld	a5,24(s1)
     812:	00078023          	sb	zero,0(a5)
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
     816:	8526                	mv	a0,s1
     818:	60e2                	ld	ra,24(sp)
     81a:	6442                	ld	s0,16(sp)
     81c:	64a2                	ld	s1,8(sp)
     81e:	6105                	addi	sp,sp,32
     820:	8082                	ret
    nulterminate(pcmd->left);
     822:	6508                	ld	a0,8(a0)
     824:	fa3ff0ef          	jal	ra,7c6 <nulterminate>
    nulterminate(pcmd->right);
     828:	6888                	ld	a0,16(s1)
     82a:	f9dff0ef          	jal	ra,7c6 <nulterminate>
    break;
     82e:	b7e5                	j	816 <nulterminate+0x50>
    nulterminate(lcmd->left);
     830:	6508                	ld	a0,8(a0)
     832:	f95ff0ef          	jal	ra,7c6 <nulterminate>
    nulterminate(lcmd->right);
     836:	6888                	ld	a0,16(s1)
     838:	f8fff0ef          	jal	ra,7c6 <nulterminate>
    break;
     83c:	bfe9                	j	816 <nulterminate+0x50>
    nulterminate(bcmd->cmd);
     83e:	6508                	ld	a0,8(a0)
     840:	f87ff0ef          	jal	ra,7c6 <nulterminate>
    break;
     844:	bfc9                	j	816 <nulterminate+0x50>

0000000000000846 <parsecmd>:
{
     846:	7179                	addi	sp,sp,-48
     848:	f406                	sd	ra,40(sp)
     84a:	f022                	sd	s0,32(sp)
     84c:	ec26                	sd	s1,24(sp)
     84e:	e84a                	sd	s2,16(sp)
     850:	1800                	addi	s0,sp,48
     852:	fca43c23          	sd	a0,-40(s0)
  es = s + strlen(s);
     856:	84aa                	mv	s1,a0
     858:	182000ef          	jal	ra,9da <strlen>
     85c:	1502                	slli	a0,a0,0x20
     85e:	9101                	srli	a0,a0,0x20
     860:	94aa                	add	s1,s1,a0
  cmd = parseline(&s, es);
     862:	85a6                	mv	a1,s1
     864:	fd840513          	addi	a0,s0,-40
     868:	e53ff0ef          	jal	ra,6ba <parseline>
     86c:	892a                	mv	s2,a0
  peek(&s, es, "");
     86e:	00001617          	auipc	a2,0x1
     872:	a1260613          	addi	a2,a2,-1518 # 1280 <malloc+0x1c0>
     876:	85a6                	mv	a1,s1
     878:	fd840513          	addi	a0,s0,-40
     87c:	bbfff0ef          	jal	ra,43a <peek>
  if(s != es){
     880:	fd843603          	ld	a2,-40(s0)
     884:	00961c63          	bne	a2,s1,89c <parsecmd+0x56>
  nulterminate(cmd);
     888:	854a                	mv	a0,s2
     88a:	f3dff0ef          	jal	ra,7c6 <nulterminate>
}
     88e:	854a                	mv	a0,s2
     890:	70a2                	ld	ra,40(sp)
     892:	7402                	ld	s0,32(sp)
     894:	64e2                	ld	s1,24(sp)
     896:	6942                	ld	s2,16(sp)
     898:	6145                	addi	sp,sp,48
     89a:	8082                	ret
    fprintf(2, "leftovers: %s\n", s);
     89c:	00001597          	auipc	a1,0x1
     8a0:	9ec58593          	addi	a1,a1,-1556 # 1288 <malloc+0x1c8>
     8a4:	4509                	li	a0,2
     8a6:	736000ef          	jal	ra,fdc <fprintf>
    panic("syntax");
     8aa:	00001517          	auipc	a0,0x1
     8ae:	96e50513          	addi	a0,a0,-1682 # 1218 <malloc+0x158>
     8b2:	f98ff0ef          	jal	ra,4a <panic>

00000000000008b6 <main>:
{
     8b6:	7139                	addi	sp,sp,-64
     8b8:	fc06                	sd	ra,56(sp)
     8ba:	f822                	sd	s0,48(sp)
     8bc:	f426                	sd	s1,40(sp)
     8be:	f04a                	sd	s2,32(sp)
     8c0:	ec4e                	sd	s3,24(sp)
     8c2:	e852                	sd	s4,16(sp)
     8c4:	e456                	sd	s5,8(sp)
     8c6:	e05a                	sd	s6,0(sp)
     8c8:	0080                	addi	s0,sp,64
  while((fd = open("console", O_RDWR)) >= 0){
     8ca:	00001497          	auipc	s1,0x1
     8ce:	9ce48493          	addi	s1,s1,-1586 # 1298 <malloc+0x1d8>
     8d2:	4589                	li	a1,2
     8d4:	8526                	mv	a0,s1
     8d6:	356000ef          	jal	ra,c2c <open>
     8da:	00054763          	bltz	a0,8e8 <main+0x32>
    if(fd >= 3){
     8de:	4789                	li	a5,2
     8e0:	fea7d9e3          	bge	a5,a0,8d2 <main+0x1c>
      close(fd);
     8e4:	330000ef          	jal	ra,c14 <close>
  while(getcmd(buf, sizeof(buf)) >= 0){
     8e8:	00001497          	auipc	s1,0x1
     8ec:	73848493          	addi	s1,s1,1848 # 2020 <buf.0>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     8f0:	06300913          	li	s2,99
     8f4:	06400993          	li	s3,100
     8f8:	02000a13          	li	s4,32
      if(chdir(buf+3) < 0)
     8fc:	00001a97          	auipc	s5,0x1
     900:	727a8a93          	addi	s5,s5,1831 # 2023 <buf.0+0x3>
        fprintf(2, "cannot cd %s\n", buf+3);
     904:	00001b17          	auipc	s6,0x1
     908:	99cb0b13          	addi	s6,s6,-1636 # 12a0 <malloc+0x1e0>
     90c:	a039                	j	91a <main+0x64>
    if(fork1() == 0)
     90e:	f5aff0ef          	jal	ra,68 <fork1>
     912:	cd21                	beqz	a0,96a <main+0xb4>
    wait(0);
     914:	4501                	li	a0,0
     916:	2de000ef          	jal	ra,bf4 <wait>
  while(getcmd(buf, sizeof(buf)) >= 0){
     91a:	7d000593          	li	a1,2000
     91e:	8526                	mv	a0,s1
     920:	ee0ff0ef          	jal	ra,0 <getcmd>
     924:	04054b63          	bltz	a0,97a <main+0xc4>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     928:	0004c783          	lbu	a5,0(s1)
     92c:	ff2791e3          	bne	a5,s2,90e <main+0x58>
     930:	0014c783          	lbu	a5,1(s1)
     934:	fd379de3          	bne	a5,s3,90e <main+0x58>
     938:	0024c783          	lbu	a5,2(s1)
     93c:	fd4799e3          	bne	a5,s4,90e <main+0x58>
      buf[strlen(buf)-1] = 0;  // chop \n
     940:	8526                	mv	a0,s1
     942:	098000ef          	jal	ra,9da <strlen>
     946:	fff5079b          	addiw	a5,a0,-1
     94a:	1782                	slli	a5,a5,0x20
     94c:	9381                	srli	a5,a5,0x20
     94e:	97a6                	add	a5,a5,s1
     950:	00078023          	sb	zero,0(a5)
      if(chdir(buf+3) < 0)
     954:	8556                	mv	a0,s5
     956:	306000ef          	jal	ra,c5c <chdir>
     95a:	fc0550e3          	bgez	a0,91a <main+0x64>
        fprintf(2, "cannot cd %s\n", buf+3);
     95e:	8656                	mv	a2,s5
     960:	85da                	mv	a1,s6
     962:	4509                	li	a0,2
     964:	678000ef          	jal	ra,fdc <fprintf>
     968:	bf4d                	j	91a <main+0x64>
      runcmd(parsecmd(buf));
     96a:	00001517          	auipc	a0,0x1
     96e:	6b650513          	addi	a0,a0,1718 # 2020 <buf.0>
     972:	ed5ff0ef          	jal	ra,846 <parsecmd>
     976:	f18ff0ef          	jal	ra,8e <runcmd>
  exit(0);
     97a:	4501                	li	a0,0
     97c:	270000ef          	jal	ra,bec <exit>

0000000000000980 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
     980:	1141                	addi	sp,sp,-16
     982:	e406                	sd	ra,8(sp)
     984:	e022                	sd	s0,0(sp)
     986:	0800                	addi	s0,sp,16
  extern int main();
  main();
     988:	f2fff0ef          	jal	ra,8b6 <main>
  exit(0);
     98c:	4501                	li	a0,0
     98e:	25e000ef          	jal	ra,bec <exit>

0000000000000992 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     992:	1141                	addi	sp,sp,-16
     994:	e422                	sd	s0,8(sp)
     996:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     998:	87aa                	mv	a5,a0
     99a:	0585                	addi	a1,a1,1
     99c:	0785                	addi	a5,a5,1
     99e:	fff5c703          	lbu	a4,-1(a1)
     9a2:	fee78fa3          	sb	a4,-1(a5)
     9a6:	fb75                	bnez	a4,99a <strcpy+0x8>
    ;
  return os;
}
     9a8:	6422                	ld	s0,8(sp)
     9aa:	0141                	addi	sp,sp,16
     9ac:	8082                	ret

00000000000009ae <strcmp>:

int
strcmp(const char *p, const char *q)
{
     9ae:	1141                	addi	sp,sp,-16
     9b0:	e422                	sd	s0,8(sp)
     9b2:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     9b4:	00054783          	lbu	a5,0(a0)
     9b8:	cb91                	beqz	a5,9cc <strcmp+0x1e>
     9ba:	0005c703          	lbu	a4,0(a1)
     9be:	00f71763          	bne	a4,a5,9cc <strcmp+0x1e>
    p++, q++;
     9c2:	0505                	addi	a0,a0,1
     9c4:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     9c6:	00054783          	lbu	a5,0(a0)
     9ca:	fbe5                	bnez	a5,9ba <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     9cc:	0005c503          	lbu	a0,0(a1)
}
     9d0:	40a7853b          	subw	a0,a5,a0
     9d4:	6422                	ld	s0,8(sp)
     9d6:	0141                	addi	sp,sp,16
     9d8:	8082                	ret

00000000000009da <strlen>:

uint
strlen(const char *s)
{
     9da:	1141                	addi	sp,sp,-16
     9dc:	e422                	sd	s0,8(sp)
     9de:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     9e0:	00054783          	lbu	a5,0(a0)
     9e4:	cf91                	beqz	a5,a00 <strlen+0x26>
     9e6:	0505                	addi	a0,a0,1
     9e8:	87aa                	mv	a5,a0
     9ea:	4685                	li	a3,1
     9ec:	9e89                	subw	a3,a3,a0
     9ee:	00f6853b          	addw	a0,a3,a5
     9f2:	0785                	addi	a5,a5,1
     9f4:	fff7c703          	lbu	a4,-1(a5)
     9f8:	fb7d                	bnez	a4,9ee <strlen+0x14>
    ;
  return n;
}
     9fa:	6422                	ld	s0,8(sp)
     9fc:	0141                	addi	sp,sp,16
     9fe:	8082                	ret
  for(n = 0; s[n]; n++)
     a00:	4501                	li	a0,0
     a02:	bfe5                	j	9fa <strlen+0x20>

0000000000000a04 <memset>:

void*
memset(void *dst, int c, uint n)
{
     a04:	1141                	addi	sp,sp,-16
     a06:	e422                	sd	s0,8(sp)
     a08:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     a0a:	ca19                	beqz	a2,a20 <memset+0x1c>
     a0c:	87aa                	mv	a5,a0
     a0e:	1602                	slli	a2,a2,0x20
     a10:	9201                	srli	a2,a2,0x20
     a12:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     a16:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     a1a:	0785                	addi	a5,a5,1
     a1c:	fee79de3          	bne	a5,a4,a16 <memset+0x12>
  }
  return dst;
}
     a20:	6422                	ld	s0,8(sp)
     a22:	0141                	addi	sp,sp,16
     a24:	8082                	ret

0000000000000a26 <strchr>:

char*
strchr(const char *s, char c)
{
     a26:	1141                	addi	sp,sp,-16
     a28:	e422                	sd	s0,8(sp)
     a2a:	0800                	addi	s0,sp,16
  for(; *s; s++)
     a2c:	00054783          	lbu	a5,0(a0)
     a30:	cb99                	beqz	a5,a46 <strchr+0x20>
    if(*s == c)
     a32:	00f58763          	beq	a1,a5,a40 <strchr+0x1a>
  for(; *s; s++)
     a36:	0505                	addi	a0,a0,1
     a38:	00054783          	lbu	a5,0(a0)
     a3c:	fbfd                	bnez	a5,a32 <strchr+0xc>
      return (char*)s;
  return 0;
     a3e:	4501                	li	a0,0
}
     a40:	6422                	ld	s0,8(sp)
     a42:	0141                	addi	sp,sp,16
     a44:	8082                	ret
  return 0;
     a46:	4501                	li	a0,0
     a48:	bfe5                	j	a40 <strchr+0x1a>

0000000000000a4a <gets>:

char*
gets(char *buf, int max)
{
     a4a:	711d                	addi	sp,sp,-96
     a4c:	ec86                	sd	ra,88(sp)
     a4e:	e8a2                	sd	s0,80(sp)
     a50:	e4a6                	sd	s1,72(sp)
     a52:	e0ca                	sd	s2,64(sp)
     a54:	fc4e                	sd	s3,56(sp)
     a56:	f852                	sd	s4,48(sp)
     a58:	f456                	sd	s5,40(sp)
     a5a:	f05a                	sd	s6,32(sp)
     a5c:	ec5e                	sd	s7,24(sp)
     a5e:	1080                	addi	s0,sp,96
     a60:	8baa                	mv	s7,a0
     a62:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     a64:	892a                	mv	s2,a0
     a66:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     a68:	4aa9                	li	s5,10
     a6a:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     a6c:	89a6                	mv	s3,s1
     a6e:	2485                	addiw	s1,s1,1
     a70:	0344d663          	bge	s1,s4,a9c <gets+0x52>
    cc = read(0, &c, 1);
     a74:	4605                	li	a2,1
     a76:	faf40593          	addi	a1,s0,-81
     a7a:	4501                	li	a0,0
     a7c:	188000ef          	jal	ra,c04 <read>
    if(cc < 1)
     a80:	00a05e63          	blez	a0,a9c <gets+0x52>
    buf[i++] = c;
     a84:	faf44783          	lbu	a5,-81(s0)
     a88:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     a8c:	01578763          	beq	a5,s5,a9a <gets+0x50>
     a90:	0905                	addi	s2,s2,1
     a92:	fd679de3          	bne	a5,s6,a6c <gets+0x22>
  for(i=0; i+1 < max; ){
     a96:	89a6                	mv	s3,s1
     a98:	a011                	j	a9c <gets+0x52>
     a9a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     a9c:	99de                	add	s3,s3,s7
     a9e:	00098023          	sb	zero,0(s3)
  return buf;
}
     aa2:	855e                	mv	a0,s7
     aa4:	60e6                	ld	ra,88(sp)
     aa6:	6446                	ld	s0,80(sp)
     aa8:	64a6                	ld	s1,72(sp)
     aaa:	6906                	ld	s2,64(sp)
     aac:	79e2                	ld	s3,56(sp)
     aae:	7a42                	ld	s4,48(sp)
     ab0:	7aa2                	ld	s5,40(sp)
     ab2:	7b02                	ld	s6,32(sp)
     ab4:	6be2                	ld	s7,24(sp)
     ab6:	6125                	addi	sp,sp,96
     ab8:	8082                	ret

0000000000000aba <stat>:

int
stat(const char *n, struct stat *st)
{
     aba:	1101                	addi	sp,sp,-32
     abc:	ec06                	sd	ra,24(sp)
     abe:	e822                	sd	s0,16(sp)
     ac0:	e426                	sd	s1,8(sp)
     ac2:	e04a                	sd	s2,0(sp)
     ac4:	1000                	addi	s0,sp,32
     ac6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     ac8:	4581                	li	a1,0
     aca:	162000ef          	jal	ra,c2c <open>
  if(fd < 0)
     ace:	02054163          	bltz	a0,af0 <stat+0x36>
     ad2:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     ad4:	85ca                	mv	a1,s2
     ad6:	16e000ef          	jal	ra,c44 <fstat>
     ada:	892a                	mv	s2,a0
  close(fd);
     adc:	8526                	mv	a0,s1
     ade:	136000ef          	jal	ra,c14 <close>
  return r;
}
     ae2:	854a                	mv	a0,s2
     ae4:	60e2                	ld	ra,24(sp)
     ae6:	6442                	ld	s0,16(sp)
     ae8:	64a2                	ld	s1,8(sp)
     aea:	6902                	ld	s2,0(sp)
     aec:	6105                	addi	sp,sp,32
     aee:	8082                	ret
    return -1;
     af0:	597d                	li	s2,-1
     af2:	bfc5                	j	ae2 <stat+0x28>

0000000000000af4 <atoi>:

int
atoi(const char *s)
{
     af4:	1141                	addi	sp,sp,-16
     af6:	e422                	sd	s0,8(sp)
     af8:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     afa:	00054603          	lbu	a2,0(a0)
     afe:	fd06079b          	addiw	a5,a2,-48
     b02:	0ff7f793          	andi	a5,a5,255
     b06:	4725                	li	a4,9
     b08:	02f76963          	bltu	a4,a5,b3a <atoi+0x46>
     b0c:	86aa                	mv	a3,a0
  n = 0;
     b0e:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
     b10:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
     b12:	0685                	addi	a3,a3,1
     b14:	0025179b          	slliw	a5,a0,0x2
     b18:	9fa9                	addw	a5,a5,a0
     b1a:	0017979b          	slliw	a5,a5,0x1
     b1e:	9fb1                	addw	a5,a5,a2
     b20:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     b24:	0006c603          	lbu	a2,0(a3)
     b28:	fd06071b          	addiw	a4,a2,-48
     b2c:	0ff77713          	andi	a4,a4,255
     b30:	fee5f1e3          	bgeu	a1,a4,b12 <atoi+0x1e>
  return n;
}
     b34:	6422                	ld	s0,8(sp)
     b36:	0141                	addi	sp,sp,16
     b38:	8082                	ret
  n = 0;
     b3a:	4501                	li	a0,0
     b3c:	bfe5                	j	b34 <atoi+0x40>

0000000000000b3e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     b3e:	1141                	addi	sp,sp,-16
     b40:	e422                	sd	s0,8(sp)
     b42:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     b44:	02b57463          	bgeu	a0,a1,b6c <memmove+0x2e>
    while(n-- > 0)
     b48:	00c05f63          	blez	a2,b66 <memmove+0x28>
     b4c:	1602                	slli	a2,a2,0x20
     b4e:	9201                	srli	a2,a2,0x20
     b50:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     b54:	872a                	mv	a4,a0
      *dst++ = *src++;
     b56:	0585                	addi	a1,a1,1
     b58:	0705                	addi	a4,a4,1
     b5a:	fff5c683          	lbu	a3,-1(a1)
     b5e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     b62:	fee79ae3          	bne	a5,a4,b56 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     b66:	6422                	ld	s0,8(sp)
     b68:	0141                	addi	sp,sp,16
     b6a:	8082                	ret
    dst += n;
     b6c:	00c50733          	add	a4,a0,a2
    src += n;
     b70:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     b72:	fec05ae3          	blez	a2,b66 <memmove+0x28>
     b76:	fff6079b          	addiw	a5,a2,-1
     b7a:	1782                	slli	a5,a5,0x20
     b7c:	9381                	srli	a5,a5,0x20
     b7e:	fff7c793          	not	a5,a5
     b82:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     b84:	15fd                	addi	a1,a1,-1
     b86:	177d                	addi	a4,a4,-1
     b88:	0005c683          	lbu	a3,0(a1)
     b8c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     b90:	fee79ae3          	bne	a5,a4,b84 <memmove+0x46>
     b94:	bfc9                	j	b66 <memmove+0x28>

0000000000000b96 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     b96:	1141                	addi	sp,sp,-16
     b98:	e422                	sd	s0,8(sp)
     b9a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     b9c:	ca05                	beqz	a2,bcc <memcmp+0x36>
     b9e:	fff6069b          	addiw	a3,a2,-1
     ba2:	1682                	slli	a3,a3,0x20
     ba4:	9281                	srli	a3,a3,0x20
     ba6:	0685                	addi	a3,a3,1
     ba8:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     baa:	00054783          	lbu	a5,0(a0)
     bae:	0005c703          	lbu	a4,0(a1)
     bb2:	00e79863          	bne	a5,a4,bc2 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     bb6:	0505                	addi	a0,a0,1
    p2++;
     bb8:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     bba:	fed518e3          	bne	a0,a3,baa <memcmp+0x14>
  }
  return 0;
     bbe:	4501                	li	a0,0
     bc0:	a019                	j	bc6 <memcmp+0x30>
      return *p1 - *p2;
     bc2:	40e7853b          	subw	a0,a5,a4
}
     bc6:	6422                	ld	s0,8(sp)
     bc8:	0141                	addi	sp,sp,16
     bca:	8082                	ret
  return 0;
     bcc:	4501                	li	a0,0
     bce:	bfe5                	j	bc6 <memcmp+0x30>

0000000000000bd0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     bd0:	1141                	addi	sp,sp,-16
     bd2:	e406                	sd	ra,8(sp)
     bd4:	e022                	sd	s0,0(sp)
     bd6:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     bd8:	f67ff0ef          	jal	ra,b3e <memmove>
}
     bdc:	60a2                	ld	ra,8(sp)
     bde:	6402                	ld	s0,0(sp)
     be0:	0141                	addi	sp,sp,16
     be2:	8082                	ret

0000000000000be4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     be4:	4885                	li	a7,1
 ecall
     be6:	00000073          	ecall
 ret
     bea:	8082                	ret

0000000000000bec <exit>:
.global exit
exit:
 li a7, SYS_exit
     bec:	4889                	li	a7,2
 ecall
     bee:	00000073          	ecall
 ret
     bf2:	8082                	ret

0000000000000bf4 <wait>:
.global wait
wait:
 li a7, SYS_wait
     bf4:	488d                	li	a7,3
 ecall
     bf6:	00000073          	ecall
 ret
     bfa:	8082                	ret

0000000000000bfc <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     bfc:	4891                	li	a7,4
 ecall
     bfe:	00000073          	ecall
 ret
     c02:	8082                	ret

0000000000000c04 <read>:
.global read
read:
 li a7, SYS_read
     c04:	4895                	li	a7,5
 ecall
     c06:	00000073          	ecall
 ret
     c0a:	8082                	ret

0000000000000c0c <write>:
.global write
write:
 li a7, SYS_write
     c0c:	48c1                	li	a7,16
 ecall
     c0e:	00000073          	ecall
 ret
     c12:	8082                	ret

0000000000000c14 <close>:
.global close
close:
 li a7, SYS_close
     c14:	48d5                	li	a7,21
 ecall
     c16:	00000073          	ecall
 ret
     c1a:	8082                	ret

0000000000000c1c <kill>:
.global kill
kill:
 li a7, SYS_kill
     c1c:	4899                	li	a7,6
 ecall
     c1e:	00000073          	ecall
 ret
     c22:	8082                	ret

0000000000000c24 <exec>:
.global exec
exec:
 li a7, SYS_exec
     c24:	489d                	li	a7,7
 ecall
     c26:	00000073          	ecall
 ret
     c2a:	8082                	ret

0000000000000c2c <open>:
.global open
open:
 li a7, SYS_open
     c2c:	48bd                	li	a7,15
 ecall
     c2e:	00000073          	ecall
 ret
     c32:	8082                	ret

0000000000000c34 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     c34:	48c5                	li	a7,17
 ecall
     c36:	00000073          	ecall
 ret
     c3a:	8082                	ret

0000000000000c3c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     c3c:	48c9                	li	a7,18
 ecall
     c3e:	00000073          	ecall
 ret
     c42:	8082                	ret

0000000000000c44 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     c44:	48a1                	li	a7,8
 ecall
     c46:	00000073          	ecall
 ret
     c4a:	8082                	ret

0000000000000c4c <link>:
.global link
link:
 li a7, SYS_link
     c4c:	48cd                	li	a7,19
 ecall
     c4e:	00000073          	ecall
 ret
     c52:	8082                	ret

0000000000000c54 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     c54:	48d1                	li	a7,20
 ecall
     c56:	00000073          	ecall
 ret
     c5a:	8082                	ret

0000000000000c5c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     c5c:	48a5                	li	a7,9
 ecall
     c5e:	00000073          	ecall
 ret
     c62:	8082                	ret

0000000000000c64 <dup>:
.global dup
dup:
 li a7, SYS_dup
     c64:	48a9                	li	a7,10
 ecall
     c66:	00000073          	ecall
 ret
     c6a:	8082                	ret

0000000000000c6c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     c6c:	48ad                	li	a7,11
 ecall
     c6e:	00000073          	ecall
 ret
     c72:	8082                	ret

0000000000000c74 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     c74:	48b1                	li	a7,12
 ecall
     c76:	00000073          	ecall
 ret
     c7a:	8082                	ret

0000000000000c7c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     c7c:	48b5                	li	a7,13
 ecall
     c7e:	00000073          	ecall
 ret
     c82:	8082                	ret

0000000000000c84 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     c84:	48b9                	li	a7,14
 ecall
     c86:	00000073          	ecall
 ret
     c8a:	8082                	ret

0000000000000c8c <debugswitch>:
.global debugswitch
debugswitch:
 li a7, SYS_debugswitch
     c8c:	48d9                	li	a7,22
 ecall
     c8e:	00000073          	ecall
 ret
     c92:	8082                	ret

0000000000000c94 <printfslab>:
.global printfslab
printfslab:
 li a7, SYS_printfslab
     c94:	48dd                	li	a7,23
 ecall
     c96:	00000073          	ecall
 ret
     c9a:	8082                	ret

0000000000000c9c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     c9c:	1101                	addi	sp,sp,-32
     c9e:	ec06                	sd	ra,24(sp)
     ca0:	e822                	sd	s0,16(sp)
     ca2:	1000                	addi	s0,sp,32
     ca4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     ca8:	4605                	li	a2,1
     caa:	fef40593          	addi	a1,s0,-17
     cae:	f5fff0ef          	jal	ra,c0c <write>
}
     cb2:	60e2                	ld	ra,24(sp)
     cb4:	6442                	ld	s0,16(sp)
     cb6:	6105                	addi	sp,sp,32
     cb8:	8082                	ret

0000000000000cba <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     cba:	7139                	addi	sp,sp,-64
     cbc:	fc06                	sd	ra,56(sp)
     cbe:	f822                	sd	s0,48(sp)
     cc0:	f426                	sd	s1,40(sp)
     cc2:	f04a                	sd	s2,32(sp)
     cc4:	ec4e                	sd	s3,24(sp)
     cc6:	0080                	addi	s0,sp,64
     cc8:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     cca:	c299                	beqz	a3,cd0 <printint+0x16>
     ccc:	0805c663          	bltz	a1,d58 <printint+0x9e>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     cd0:	2581                	sext.w	a1,a1
  neg = 0;
     cd2:	4881                	li	a7,0
     cd4:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
     cd8:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     cda:	2601                	sext.w	a2,a2
     cdc:	00000517          	auipc	a0,0x0
     ce0:	60c50513          	addi	a0,a0,1548 # 12e8 <digits>
     ce4:	883a                	mv	a6,a4
     ce6:	2705                	addiw	a4,a4,1
     ce8:	02c5f7bb          	remuw	a5,a1,a2
     cec:	1782                	slli	a5,a5,0x20
     cee:	9381                	srli	a5,a5,0x20
     cf0:	97aa                	add	a5,a5,a0
     cf2:	0007c783          	lbu	a5,0(a5)
     cf6:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     cfa:	0005879b          	sext.w	a5,a1
     cfe:	02c5d5bb          	divuw	a1,a1,a2
     d02:	0685                	addi	a3,a3,1
     d04:	fec7f0e3          	bgeu	a5,a2,ce4 <printint+0x2a>
  if(neg)
     d08:	00088b63          	beqz	a7,d1e <printint+0x64>
    buf[i++] = '-';
     d0c:	fd040793          	addi	a5,s0,-48
     d10:	973e                	add	a4,a4,a5
     d12:	02d00793          	li	a5,45
     d16:	fef70823          	sb	a5,-16(a4)
     d1a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
     d1e:	02e05663          	blez	a4,d4a <printint+0x90>
     d22:	fc040793          	addi	a5,s0,-64
     d26:	00e78933          	add	s2,a5,a4
     d2a:	fff78993          	addi	s3,a5,-1
     d2e:	99ba                	add	s3,s3,a4
     d30:	377d                	addiw	a4,a4,-1
     d32:	1702                	slli	a4,a4,0x20
     d34:	9301                	srli	a4,a4,0x20
     d36:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     d3a:	fff94583          	lbu	a1,-1(s2)
     d3e:	8526                	mv	a0,s1
     d40:	f5dff0ef          	jal	ra,c9c <putc>
  while(--i >= 0)
     d44:	197d                	addi	s2,s2,-1
     d46:	ff391ae3          	bne	s2,s3,d3a <printint+0x80>
}
     d4a:	70e2                	ld	ra,56(sp)
     d4c:	7442                	ld	s0,48(sp)
     d4e:	74a2                	ld	s1,40(sp)
     d50:	7902                	ld	s2,32(sp)
     d52:	69e2                	ld	s3,24(sp)
     d54:	6121                	addi	sp,sp,64
     d56:	8082                	ret
    x = -xx;
     d58:	40b005bb          	negw	a1,a1
    neg = 1;
     d5c:	4885                	li	a7,1
    x = -xx;
     d5e:	bf9d                	j	cd4 <printint+0x1a>

0000000000000d60 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     d60:	7119                	addi	sp,sp,-128
     d62:	fc86                	sd	ra,120(sp)
     d64:	f8a2                	sd	s0,112(sp)
     d66:	f4a6                	sd	s1,104(sp)
     d68:	f0ca                	sd	s2,96(sp)
     d6a:	ecce                	sd	s3,88(sp)
     d6c:	e8d2                	sd	s4,80(sp)
     d6e:	e4d6                	sd	s5,72(sp)
     d70:	e0da                	sd	s6,64(sp)
     d72:	fc5e                	sd	s7,56(sp)
     d74:	f862                	sd	s8,48(sp)
     d76:	f466                	sd	s9,40(sp)
     d78:	f06a                	sd	s10,32(sp)
     d7a:	ec6e                	sd	s11,24(sp)
     d7c:	0100                	addi	s0,sp,128
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     d7e:	0005c903          	lbu	s2,0(a1)
     d82:	22090e63          	beqz	s2,fbe <vprintf+0x25e>
     d86:	8b2a                	mv	s6,a0
     d88:	8a2e                	mv	s4,a1
     d8a:	8bb2                	mv	s7,a2
  state = 0;
     d8c:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
     d8e:	4481                	li	s1,0
     d90:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
     d92:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
     d96:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
     d9a:	06c00d13          	li	s10,108
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
     d9e:	07500d93          	li	s11,117
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     da2:	00000c97          	auipc	s9,0x0
     da6:	546c8c93          	addi	s9,s9,1350 # 12e8 <digits>
     daa:	a005                	j	dca <vprintf+0x6a>
        putc(fd, c0);
     dac:	85ca                	mv	a1,s2
     dae:	855a                	mv	a0,s6
     db0:	eedff0ef          	jal	ra,c9c <putc>
     db4:	a019                	j	dba <vprintf+0x5a>
    } else if(state == '%'){
     db6:	03598263          	beq	s3,s5,dda <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
     dba:	2485                	addiw	s1,s1,1
     dbc:	8726                	mv	a4,s1
     dbe:	009a07b3          	add	a5,s4,s1
     dc2:	0007c903          	lbu	s2,0(a5)
     dc6:	1e090c63          	beqz	s2,fbe <vprintf+0x25e>
    c0 = fmt[i] & 0xff;
     dca:	0009079b          	sext.w	a5,s2
    if(state == 0){
     dce:	fe0994e3          	bnez	s3,db6 <vprintf+0x56>
      if(c0 == '%'){
     dd2:	fd579de3          	bne	a5,s5,dac <vprintf+0x4c>
        state = '%';
     dd6:	89be                	mv	s3,a5
     dd8:	b7cd                	j	dba <vprintf+0x5a>
      if(c0) c1 = fmt[i+1] & 0xff;
     dda:	cfa5                	beqz	a5,e52 <vprintf+0xf2>
     ddc:	00ea06b3          	add	a3,s4,a4
     de0:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
     de4:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
     de6:	c681                	beqz	a3,dee <vprintf+0x8e>
     de8:	9752                	add	a4,a4,s4
     dea:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
     dee:	03878a63          	beq	a5,s8,e22 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
     df2:	05a78463          	beq	a5,s10,e3a <vprintf+0xda>
      } else if(c0 == 'u'){
     df6:	0db78763          	beq	a5,s11,ec4 <vprintf+0x164>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
     dfa:	07800713          	li	a4,120
     dfe:	10e78963          	beq	a5,a4,f10 <vprintf+0x1b0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
     e02:	07000713          	li	a4,112
     e06:	12e78e63          	beq	a5,a4,f42 <vprintf+0x1e2>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
     e0a:	07300713          	li	a4,115
     e0e:	16e78b63          	beq	a5,a4,f84 <vprintf+0x224>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
     e12:	05579063          	bne	a5,s5,e52 <vprintf+0xf2>
        putc(fd, '%');
     e16:	85d6                	mv	a1,s5
     e18:	855a                	mv	a0,s6
     e1a:	e83ff0ef          	jal	ra,c9c <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
     e1e:	4981                	li	s3,0
     e20:	bf69                	j	dba <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 1);
     e22:	008b8913          	addi	s2,s7,8
     e26:	4685                	li	a3,1
     e28:	4629                	li	a2,10
     e2a:	000ba583          	lw	a1,0(s7)
     e2e:	855a                	mv	a0,s6
     e30:	e8bff0ef          	jal	ra,cba <printint>
     e34:	8bca                	mv	s7,s2
      state = 0;
     e36:	4981                	li	s3,0
     e38:	b749                	j	dba <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'd'){
     e3a:	03868663          	beq	a3,s8,e66 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     e3e:	05a68163          	beq	a3,s10,e80 <vprintf+0x120>
      } else if(c0 == 'l' && c1 == 'u'){
     e42:	09b68d63          	beq	a3,s11,edc <vprintf+0x17c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
     e46:	03a68f63          	beq	a3,s10,e84 <vprintf+0x124>
      } else if(c0 == 'l' && c1 == 'x'){
     e4a:	07800793          	li	a5,120
     e4e:	0cf68d63          	beq	a3,a5,f28 <vprintf+0x1c8>
        putc(fd, '%');
     e52:	85d6                	mv	a1,s5
     e54:	855a                	mv	a0,s6
     e56:	e47ff0ef          	jal	ra,c9c <putc>
        putc(fd, c0);
     e5a:	85ca                	mv	a1,s2
     e5c:	855a                	mv	a0,s6
     e5e:	e3fff0ef          	jal	ra,c9c <putc>
      state = 0;
     e62:	4981                	li	s3,0
     e64:	bf99                	j	dba <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
     e66:	008b8913          	addi	s2,s7,8
     e6a:	4685                	li	a3,1
     e6c:	4629                	li	a2,10
     e6e:	000ba583          	lw	a1,0(s7)
     e72:	855a                	mv	a0,s6
     e74:	e47ff0ef          	jal	ra,cba <printint>
        i += 1;
     e78:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
     e7a:	8bca                	mv	s7,s2
      state = 0;
     e7c:	4981                	li	s3,0
        i += 1;
     e7e:	bf35                	j	dba <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     e80:	03860563          	beq	a2,s8,eaa <vprintf+0x14a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
     e84:	07b60963          	beq	a2,s11,ef6 <vprintf+0x196>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
     e88:	07800793          	li	a5,120
     e8c:	fcf613e3          	bne	a2,a5,e52 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
     e90:	008b8913          	addi	s2,s7,8
     e94:	4681                	li	a3,0
     e96:	4641                	li	a2,16
     e98:	000ba583          	lw	a1,0(s7)
     e9c:	855a                	mv	a0,s6
     e9e:	e1dff0ef          	jal	ra,cba <printint>
        i += 2;
     ea2:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
     ea4:	8bca                	mv	s7,s2
      state = 0;
     ea6:	4981                	li	s3,0
        i += 2;
     ea8:	bf09                	j	dba <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
     eaa:	008b8913          	addi	s2,s7,8
     eae:	4685                	li	a3,1
     eb0:	4629                	li	a2,10
     eb2:	000ba583          	lw	a1,0(s7)
     eb6:	855a                	mv	a0,s6
     eb8:	e03ff0ef          	jal	ra,cba <printint>
        i += 2;
     ebc:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
     ebe:	8bca                	mv	s7,s2
      state = 0;
     ec0:	4981                	li	s3,0
        i += 2;
     ec2:	bde5                	j	dba <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 0);
     ec4:	008b8913          	addi	s2,s7,8
     ec8:	4681                	li	a3,0
     eca:	4629                	li	a2,10
     ecc:	000ba583          	lw	a1,0(s7)
     ed0:	855a                	mv	a0,s6
     ed2:	de9ff0ef          	jal	ra,cba <printint>
     ed6:	8bca                	mv	s7,s2
      state = 0;
     ed8:	4981                	li	s3,0
     eda:	b5c5                	j	dba <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
     edc:	008b8913          	addi	s2,s7,8
     ee0:	4681                	li	a3,0
     ee2:	4629                	li	a2,10
     ee4:	000ba583          	lw	a1,0(s7)
     ee8:	855a                	mv	a0,s6
     eea:	dd1ff0ef          	jal	ra,cba <printint>
        i += 1;
     eee:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
     ef0:	8bca                	mv	s7,s2
      state = 0;
     ef2:	4981                	li	s3,0
        i += 1;
     ef4:	b5d9                	j	dba <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
     ef6:	008b8913          	addi	s2,s7,8
     efa:	4681                	li	a3,0
     efc:	4629                	li	a2,10
     efe:	000ba583          	lw	a1,0(s7)
     f02:	855a                	mv	a0,s6
     f04:	db7ff0ef          	jal	ra,cba <printint>
        i += 2;
     f08:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
     f0a:	8bca                	mv	s7,s2
      state = 0;
     f0c:	4981                	li	s3,0
        i += 2;
     f0e:	b575                	j	dba <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 16, 0);
     f10:	008b8913          	addi	s2,s7,8
     f14:	4681                	li	a3,0
     f16:	4641                	li	a2,16
     f18:	000ba583          	lw	a1,0(s7)
     f1c:	855a                	mv	a0,s6
     f1e:	d9dff0ef          	jal	ra,cba <printint>
     f22:	8bca                	mv	s7,s2
      state = 0;
     f24:	4981                	li	s3,0
     f26:	bd51                	j	dba <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 16, 0);
     f28:	008b8913          	addi	s2,s7,8
     f2c:	4681                	li	a3,0
     f2e:	4641                	li	a2,16
     f30:	000ba583          	lw	a1,0(s7)
     f34:	855a                	mv	a0,s6
     f36:	d85ff0ef          	jal	ra,cba <printint>
        i += 1;
     f3a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
     f3c:	8bca                	mv	s7,s2
      state = 0;
     f3e:	4981                	li	s3,0
        i += 1;
     f40:	bdad                	j	dba <vprintf+0x5a>
        printptr(fd, va_arg(ap, uint64));
     f42:	008b8793          	addi	a5,s7,8
     f46:	f8f43423          	sd	a5,-120(s0)
     f4a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
     f4e:	03000593          	li	a1,48
     f52:	855a                	mv	a0,s6
     f54:	d49ff0ef          	jal	ra,c9c <putc>
  putc(fd, 'x');
     f58:	07800593          	li	a1,120
     f5c:	855a                	mv	a0,s6
     f5e:	d3fff0ef          	jal	ra,c9c <putc>
     f62:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     f64:	03c9d793          	srli	a5,s3,0x3c
     f68:	97e6                	add	a5,a5,s9
     f6a:	0007c583          	lbu	a1,0(a5)
     f6e:	855a                	mv	a0,s6
     f70:	d2dff0ef          	jal	ra,c9c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     f74:	0992                	slli	s3,s3,0x4
     f76:	397d                	addiw	s2,s2,-1
     f78:	fe0916e3          	bnez	s2,f64 <vprintf+0x204>
        printptr(fd, va_arg(ap, uint64));
     f7c:	f8843b83          	ld	s7,-120(s0)
      state = 0;
     f80:	4981                	li	s3,0
     f82:	bd25                	j	dba <vprintf+0x5a>
        if((s = va_arg(ap, char*)) == 0)
     f84:	008b8993          	addi	s3,s7,8
     f88:	000bb903          	ld	s2,0(s7)
     f8c:	00090f63          	beqz	s2,faa <vprintf+0x24a>
        for(; *s; s++)
     f90:	00094583          	lbu	a1,0(s2)
     f94:	c195                	beqz	a1,fb8 <vprintf+0x258>
          putc(fd, *s);
     f96:	855a                	mv	a0,s6
     f98:	d05ff0ef          	jal	ra,c9c <putc>
        for(; *s; s++)
     f9c:	0905                	addi	s2,s2,1
     f9e:	00094583          	lbu	a1,0(s2)
     fa2:	f9f5                	bnez	a1,f96 <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
     fa4:	8bce                	mv	s7,s3
      state = 0;
     fa6:	4981                	li	s3,0
     fa8:	bd09                	j	dba <vprintf+0x5a>
          s = "(null)";
     faa:	00000917          	auipc	s2,0x0
     fae:	33690913          	addi	s2,s2,822 # 12e0 <malloc+0x220>
        for(; *s; s++)
     fb2:	02800593          	li	a1,40
     fb6:	b7c5                	j	f96 <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
     fb8:	8bce                	mv	s7,s3
      state = 0;
     fba:	4981                	li	s3,0
     fbc:	bbfd                	j	dba <vprintf+0x5a>
    }
  }
}
     fbe:	70e6                	ld	ra,120(sp)
     fc0:	7446                	ld	s0,112(sp)
     fc2:	74a6                	ld	s1,104(sp)
     fc4:	7906                	ld	s2,96(sp)
     fc6:	69e6                	ld	s3,88(sp)
     fc8:	6a46                	ld	s4,80(sp)
     fca:	6aa6                	ld	s5,72(sp)
     fcc:	6b06                	ld	s6,64(sp)
     fce:	7be2                	ld	s7,56(sp)
     fd0:	7c42                	ld	s8,48(sp)
     fd2:	7ca2                	ld	s9,40(sp)
     fd4:	7d02                	ld	s10,32(sp)
     fd6:	6de2                	ld	s11,24(sp)
     fd8:	6109                	addi	sp,sp,128
     fda:	8082                	ret

0000000000000fdc <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
     fdc:	715d                	addi	sp,sp,-80
     fde:	ec06                	sd	ra,24(sp)
     fe0:	e822                	sd	s0,16(sp)
     fe2:	1000                	addi	s0,sp,32
     fe4:	e010                	sd	a2,0(s0)
     fe6:	e414                	sd	a3,8(s0)
     fe8:	e818                	sd	a4,16(s0)
     fea:	ec1c                	sd	a5,24(s0)
     fec:	03043023          	sd	a6,32(s0)
     ff0:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
     ff4:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
     ff8:	8622                	mv	a2,s0
     ffa:	d67ff0ef          	jal	ra,d60 <vprintf>
}
     ffe:	60e2                	ld	ra,24(sp)
    1000:	6442                	ld	s0,16(sp)
    1002:	6161                	addi	sp,sp,80
    1004:	8082                	ret

0000000000001006 <printf>:

void
printf(const char *fmt, ...)
{
    1006:	711d                	addi	sp,sp,-96
    1008:	ec06                	sd	ra,24(sp)
    100a:	e822                	sd	s0,16(sp)
    100c:	1000                	addi	s0,sp,32
    100e:	e40c                	sd	a1,8(s0)
    1010:	e810                	sd	a2,16(s0)
    1012:	ec14                	sd	a3,24(s0)
    1014:	f018                	sd	a4,32(s0)
    1016:	f41c                	sd	a5,40(s0)
    1018:	03043823          	sd	a6,48(s0)
    101c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    1020:	00840613          	addi	a2,s0,8
    1024:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    1028:	85aa                	mv	a1,a0
    102a:	4505                	li	a0,1
    102c:	d35ff0ef          	jal	ra,d60 <vprintf>
}
    1030:	60e2                	ld	ra,24(sp)
    1032:	6442                	ld	s0,16(sp)
    1034:	6125                	addi	sp,sp,96
    1036:	8082                	ret

0000000000001038 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1038:	1141                	addi	sp,sp,-16
    103a:	e422                	sd	s0,8(sp)
    103c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    103e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1042:	00001797          	auipc	a5,0x1
    1046:	fce7b783          	ld	a5,-50(a5) # 2010 <freep>
    104a:	a805                	j	107a <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    104c:	4618                	lw	a4,8(a2)
    104e:	9db9                	addw	a1,a1,a4
    1050:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    1054:	6398                	ld	a4,0(a5)
    1056:	6318                	ld	a4,0(a4)
    1058:	fee53823          	sd	a4,-16(a0)
    105c:	a091                	j	10a0 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    105e:	ff852703          	lw	a4,-8(a0)
    1062:	9e39                	addw	a2,a2,a4
    1064:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    1066:	ff053703          	ld	a4,-16(a0)
    106a:	e398                	sd	a4,0(a5)
    106c:	a099                	j	10b2 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    106e:	6398                	ld	a4,0(a5)
    1070:	00e7e463          	bltu	a5,a4,1078 <free+0x40>
    1074:	00e6ea63          	bltu	a3,a4,1088 <free+0x50>
{
    1078:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    107a:	fed7fae3          	bgeu	a5,a3,106e <free+0x36>
    107e:	6398                	ld	a4,0(a5)
    1080:	00e6e463          	bltu	a3,a4,1088 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1084:	fee7eae3          	bltu	a5,a4,1078 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    1088:	ff852583          	lw	a1,-8(a0)
    108c:	6390                	ld	a2,0(a5)
    108e:	02059713          	slli	a4,a1,0x20
    1092:	9301                	srli	a4,a4,0x20
    1094:	0712                	slli	a4,a4,0x4
    1096:	9736                	add	a4,a4,a3
    1098:	fae60ae3          	beq	a2,a4,104c <free+0x14>
    bp->s.ptr = p->s.ptr;
    109c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    10a0:	4790                	lw	a2,8(a5)
    10a2:	02061713          	slli	a4,a2,0x20
    10a6:	9301                	srli	a4,a4,0x20
    10a8:	0712                	slli	a4,a4,0x4
    10aa:	973e                	add	a4,a4,a5
    10ac:	fae689e3          	beq	a3,a4,105e <free+0x26>
  } else
    p->s.ptr = bp;
    10b0:	e394                	sd	a3,0(a5)
  freep = p;
    10b2:	00001717          	auipc	a4,0x1
    10b6:	f4f73f23          	sd	a5,-162(a4) # 2010 <freep>
}
    10ba:	6422                	ld	s0,8(sp)
    10bc:	0141                	addi	sp,sp,16
    10be:	8082                	ret

00000000000010c0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    10c0:	7139                	addi	sp,sp,-64
    10c2:	fc06                	sd	ra,56(sp)
    10c4:	f822                	sd	s0,48(sp)
    10c6:	f426                	sd	s1,40(sp)
    10c8:	f04a                	sd	s2,32(sp)
    10ca:	ec4e                	sd	s3,24(sp)
    10cc:	e852                	sd	s4,16(sp)
    10ce:	e456                	sd	s5,8(sp)
    10d0:	e05a                	sd	s6,0(sp)
    10d2:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    10d4:	02051493          	slli	s1,a0,0x20
    10d8:	9081                	srli	s1,s1,0x20
    10da:	04bd                	addi	s1,s1,15
    10dc:	8091                	srli	s1,s1,0x4
    10de:	0014899b          	addiw	s3,s1,1
    10e2:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    10e4:	00001517          	auipc	a0,0x1
    10e8:	f2c53503          	ld	a0,-212(a0) # 2010 <freep>
    10ec:	c515                	beqz	a0,1118 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    10ee:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    10f0:	4798                	lw	a4,8(a5)
    10f2:	02977f63          	bgeu	a4,s1,1130 <malloc+0x70>
    10f6:	8a4e                	mv	s4,s3
    10f8:	0009871b          	sext.w	a4,s3
    10fc:	6685                	lui	a3,0x1
    10fe:	00d77363          	bgeu	a4,a3,1104 <malloc+0x44>
    1102:	6a05                	lui	s4,0x1
    1104:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    1108:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    110c:	00001917          	auipc	s2,0x1
    1110:	f0490913          	addi	s2,s2,-252 # 2010 <freep>
  if(p == (char*)-1)
    1114:	5afd                	li	s5,-1
    1116:	a0bd                	j	1184 <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
    1118:	00001797          	auipc	a5,0x1
    111c:	6d878793          	addi	a5,a5,1752 # 27f0 <base>
    1120:	00001717          	auipc	a4,0x1
    1124:	eef73823          	sd	a5,-272(a4) # 2010 <freep>
    1128:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    112a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    112e:	b7e1                	j	10f6 <malloc+0x36>
      if(p->s.size == nunits)
    1130:	02e48b63          	beq	s1,a4,1166 <malloc+0xa6>
        p->s.size -= nunits;
    1134:	4137073b          	subw	a4,a4,s3
    1138:	c798                	sw	a4,8(a5)
        p += p->s.size;
    113a:	1702                	slli	a4,a4,0x20
    113c:	9301                	srli	a4,a4,0x20
    113e:	0712                	slli	a4,a4,0x4
    1140:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    1142:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1146:	00001717          	auipc	a4,0x1
    114a:	eca73523          	sd	a0,-310(a4) # 2010 <freep>
      return (void*)(p + 1);
    114e:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    1152:	70e2                	ld	ra,56(sp)
    1154:	7442                	ld	s0,48(sp)
    1156:	74a2                	ld	s1,40(sp)
    1158:	7902                	ld	s2,32(sp)
    115a:	69e2                	ld	s3,24(sp)
    115c:	6a42                	ld	s4,16(sp)
    115e:	6aa2                	ld	s5,8(sp)
    1160:	6b02                	ld	s6,0(sp)
    1162:	6121                	addi	sp,sp,64
    1164:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    1166:	6398                	ld	a4,0(a5)
    1168:	e118                	sd	a4,0(a0)
    116a:	bff1                	j	1146 <malloc+0x86>
  hp->s.size = nu;
    116c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    1170:	0541                	addi	a0,a0,16
    1172:	ec7ff0ef          	jal	ra,1038 <free>
  return freep;
    1176:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    117a:	dd61                	beqz	a0,1152 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    117c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    117e:	4798                	lw	a4,8(a5)
    1180:	fa9778e3          	bgeu	a4,s1,1130 <malloc+0x70>
    if(p == freep)
    1184:	00093703          	ld	a4,0(s2)
    1188:	853e                	mv	a0,a5
    118a:	fef719e3          	bne	a4,a5,117c <malloc+0xbc>
  p = sbrk(nu * sizeof(Header));
    118e:	8552                	mv	a0,s4
    1190:	ae5ff0ef          	jal	ra,c74 <sbrk>
  if(p == (char*)-1)
    1194:	fd551ce3          	bne	a0,s5,116c <malloc+0xac>
        return 0;
    1198:	4501                	li	a0,0
    119a:	bf65                	j	1152 <malloc+0x92>
