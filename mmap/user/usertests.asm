
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
}

// what if you pass ridiculous string pointers to system calls?
void
copyinstr1(char *s)
{
       0:	1141                	addi	sp,sp,-16
       2:	e406                	sd	ra,8(sp)
       4:	e022                	sd	s0,0(sp)
       6:	0800                	addi	s0,sp,16
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };

  for(int ai = 0; ai < 2; ai++){
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE|O_WRONLY);
       8:	20100593          	li	a1,513
       c:	4505                	li	a0,1
       e:	057e                	slli	a0,a0,0x1f
      10:	00005097          	auipc	ra,0x5
      14:	686080e7          	jalr	1670(ra) # 5696 <open>
    if(fd >= 0){
      18:	02055063          	bgez	a0,38 <copyinstr1+0x38>
    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      1c:	20100593          	li	a1,513
      20:	557d                	li	a0,-1
      22:	00005097          	auipc	ra,0x5
      26:	674080e7          	jalr	1652(ra) # 5696 <open>
    uint64 addr = addrs[ai];
      2a:	55fd                	li	a1,-1
    if(fd >= 0){
      2c:	00055863          	bgez	a0,3c <copyinstr1+0x3c>
      printf("open(%p) returned %d, not -1\n", addr, fd);
      exit(1);
    }
  }
}
      30:	60a2                	ld	ra,8(sp)
      32:	6402                	ld	s0,0(sp)
      34:	0141                	addi	sp,sp,16
      36:	8082                	ret
    uint64 addr = addrs[ai];
      38:	4585                	li	a1,1
      3a:	05fe                	slli	a1,a1,0x1f
      printf("open(%p) returned %d, not -1\n", addr, fd);
      3c:	862a                	mv	a2,a0
      3e:	00006517          	auipc	a0,0x6
      42:	e6250513          	addi	a0,a0,-414 # 5ea0 <malloc+0x404>
      46:	00006097          	auipc	ra,0x6
      4a:	998080e7          	jalr	-1640(ra) # 59de <printf>
      exit(1);
      4e:	4505                	li	a0,1
      50:	00005097          	auipc	ra,0x5
      54:	606080e7          	jalr	1542(ra) # 5656 <exit>

0000000000000058 <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
      58:	00009797          	auipc	a5,0x9
      5c:	3d878793          	addi	a5,a5,984 # 9430 <uninit>
      60:	0000c697          	auipc	a3,0xc
      64:	ae068693          	addi	a3,a3,-1312 # bb40 <buf>
    if(uninit[i] != '\0'){
      68:	0007c703          	lbu	a4,0(a5)
      6c:	e709                	bnez	a4,76 <bsstest+0x1e>
  for(i = 0; i < sizeof(uninit); i++){
      6e:	0785                	addi	a5,a5,1
      70:	fed79ce3          	bne	a5,a3,68 <bsstest+0x10>
      74:	8082                	ret
{
      76:	1141                	addi	sp,sp,-16
      78:	e406                	sd	ra,8(sp)
      7a:	e022                	sd	s0,0(sp)
      7c:	0800                	addi	s0,sp,16
      printf("%s: bss test failed\n", s);
      7e:	85aa                	mv	a1,a0
      80:	00006517          	auipc	a0,0x6
      84:	e4050513          	addi	a0,a0,-448 # 5ec0 <malloc+0x424>
      88:	00006097          	auipc	ra,0x6
      8c:	956080e7          	jalr	-1706(ra) # 59de <printf>
      exit(1);
      90:	4505                	li	a0,1
      92:	00005097          	auipc	ra,0x5
      96:	5c4080e7          	jalr	1476(ra) # 5656 <exit>

000000000000009a <opentest>:
{
      9a:	1101                	addi	sp,sp,-32
      9c:	ec06                	sd	ra,24(sp)
      9e:	e822                	sd	s0,16(sp)
      a0:	e426                	sd	s1,8(sp)
      a2:	1000                	addi	s0,sp,32
      a4:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      a6:	4581                	li	a1,0
      a8:	00006517          	auipc	a0,0x6
      ac:	e3050513          	addi	a0,a0,-464 # 5ed8 <malloc+0x43c>
      b0:	00005097          	auipc	ra,0x5
      b4:	5e6080e7          	jalr	1510(ra) # 5696 <open>
  if(fd < 0){
      b8:	02054663          	bltz	a0,e4 <opentest+0x4a>
  close(fd);
      bc:	00005097          	auipc	ra,0x5
      c0:	5c2080e7          	jalr	1474(ra) # 567e <close>
  fd = open("doesnotexist", 0);
      c4:	4581                	li	a1,0
      c6:	00006517          	auipc	a0,0x6
      ca:	e3250513          	addi	a0,a0,-462 # 5ef8 <malloc+0x45c>
      ce:	00005097          	auipc	ra,0x5
      d2:	5c8080e7          	jalr	1480(ra) # 5696 <open>
  if(fd >= 0){
      d6:	02055563          	bgez	a0,100 <opentest+0x66>
}
      da:	60e2                	ld	ra,24(sp)
      dc:	6442                	ld	s0,16(sp)
      de:	64a2                	ld	s1,8(sp)
      e0:	6105                	addi	sp,sp,32
      e2:	8082                	ret
    printf("%s: open echo failed!\n", s);
      e4:	85a6                	mv	a1,s1
      e6:	00006517          	auipc	a0,0x6
      ea:	dfa50513          	addi	a0,a0,-518 # 5ee0 <malloc+0x444>
      ee:	00006097          	auipc	ra,0x6
      f2:	8f0080e7          	jalr	-1808(ra) # 59de <printf>
    exit(1);
      f6:	4505                	li	a0,1
      f8:	00005097          	auipc	ra,0x5
      fc:	55e080e7          	jalr	1374(ra) # 5656 <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     100:	85a6                	mv	a1,s1
     102:	00006517          	auipc	a0,0x6
     106:	e0650513          	addi	a0,a0,-506 # 5f08 <malloc+0x46c>
     10a:	00006097          	auipc	ra,0x6
     10e:	8d4080e7          	jalr	-1836(ra) # 59de <printf>
    exit(1);
     112:	4505                	li	a0,1
     114:	00005097          	auipc	ra,0x5
     118:	542080e7          	jalr	1346(ra) # 5656 <exit>

000000000000011c <truncate2>:
{
     11c:	7179                	addi	sp,sp,-48
     11e:	f406                	sd	ra,40(sp)
     120:	f022                	sd	s0,32(sp)
     122:	ec26                	sd	s1,24(sp)
     124:	e84a                	sd	s2,16(sp)
     126:	e44e                	sd	s3,8(sp)
     128:	1800                	addi	s0,sp,48
     12a:	89aa                	mv	s3,a0
  unlink("truncfile");
     12c:	00006517          	auipc	a0,0x6
     130:	e0450513          	addi	a0,a0,-508 # 5f30 <malloc+0x494>
     134:	00005097          	auipc	ra,0x5
     138:	572080e7          	jalr	1394(ra) # 56a6 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     13c:	60100593          	li	a1,1537
     140:	00006517          	auipc	a0,0x6
     144:	df050513          	addi	a0,a0,-528 # 5f30 <malloc+0x494>
     148:	00005097          	auipc	ra,0x5
     14c:	54e080e7          	jalr	1358(ra) # 5696 <open>
     150:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     152:	4611                	li	a2,4
     154:	00006597          	auipc	a1,0x6
     158:	dec58593          	addi	a1,a1,-532 # 5f40 <malloc+0x4a4>
     15c:	00005097          	auipc	ra,0x5
     160:	51a080e7          	jalr	1306(ra) # 5676 <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     164:	40100593          	li	a1,1025
     168:	00006517          	auipc	a0,0x6
     16c:	dc850513          	addi	a0,a0,-568 # 5f30 <malloc+0x494>
     170:	00005097          	auipc	ra,0x5
     174:	526080e7          	jalr	1318(ra) # 5696 <open>
     178:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     17a:	4605                	li	a2,1
     17c:	00006597          	auipc	a1,0x6
     180:	dcc58593          	addi	a1,a1,-564 # 5f48 <malloc+0x4ac>
     184:	8526                	mv	a0,s1
     186:	00005097          	auipc	ra,0x5
     18a:	4f0080e7          	jalr	1264(ra) # 5676 <write>
  if(n != -1){
     18e:	57fd                	li	a5,-1
     190:	02f51b63          	bne	a0,a5,1c6 <truncate2+0xaa>
  unlink("truncfile");
     194:	00006517          	auipc	a0,0x6
     198:	d9c50513          	addi	a0,a0,-612 # 5f30 <malloc+0x494>
     19c:	00005097          	auipc	ra,0x5
     1a0:	50a080e7          	jalr	1290(ra) # 56a6 <unlink>
  close(fd1);
     1a4:	8526                	mv	a0,s1
     1a6:	00005097          	auipc	ra,0x5
     1aa:	4d8080e7          	jalr	1240(ra) # 567e <close>
  close(fd2);
     1ae:	854a                	mv	a0,s2
     1b0:	00005097          	auipc	ra,0x5
     1b4:	4ce080e7          	jalr	1230(ra) # 567e <close>
}
     1b8:	70a2                	ld	ra,40(sp)
     1ba:	7402                	ld	s0,32(sp)
     1bc:	64e2                	ld	s1,24(sp)
     1be:	6942                	ld	s2,16(sp)
     1c0:	69a2                	ld	s3,8(sp)
     1c2:	6145                	addi	sp,sp,48
     1c4:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1c6:	862a                	mv	a2,a0
     1c8:	85ce                	mv	a1,s3
     1ca:	00006517          	auipc	a0,0x6
     1ce:	d8650513          	addi	a0,a0,-634 # 5f50 <malloc+0x4b4>
     1d2:	00006097          	auipc	ra,0x6
     1d6:	80c080e7          	jalr	-2036(ra) # 59de <printf>
    exit(1);
     1da:	4505                	li	a0,1
     1dc:	00005097          	auipc	ra,0x5
     1e0:	47a080e7          	jalr	1146(ra) # 5656 <exit>

00000000000001e4 <createtest>:
{
     1e4:	7179                	addi	sp,sp,-48
     1e6:	f406                	sd	ra,40(sp)
     1e8:	f022                	sd	s0,32(sp)
     1ea:	ec26                	sd	s1,24(sp)
     1ec:	e84a                	sd	s2,16(sp)
     1ee:	1800                	addi	s0,sp,48
  name[0] = 'a';
     1f0:	06100793          	li	a5,97
     1f4:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     1f8:	fc040d23          	sb	zero,-38(s0)
     1fc:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     200:	06400913          	li	s2,100
    name[1] = '0' + i;
     204:	fc940ca3          	sb	s1,-39(s0)
    fd = open(name, O_CREATE|O_RDWR);
     208:	20200593          	li	a1,514
     20c:	fd840513          	addi	a0,s0,-40
     210:	00005097          	auipc	ra,0x5
     214:	486080e7          	jalr	1158(ra) # 5696 <open>
    close(fd);
     218:	00005097          	auipc	ra,0x5
     21c:	466080e7          	jalr	1126(ra) # 567e <close>
  for(i = 0; i < N; i++){
     220:	2485                	addiw	s1,s1,1
     222:	0ff4f493          	andi	s1,s1,255
     226:	fd249fe3          	bne	s1,s2,204 <createtest+0x20>
  name[0] = 'a';
     22a:	06100793          	li	a5,97
     22e:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     232:	fc040d23          	sb	zero,-38(s0)
     236:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     23a:	06400913          	li	s2,100
    name[1] = '0' + i;
     23e:	fc940ca3          	sb	s1,-39(s0)
    unlink(name);
     242:	fd840513          	addi	a0,s0,-40
     246:	00005097          	auipc	ra,0x5
     24a:	460080e7          	jalr	1120(ra) # 56a6 <unlink>
  for(i = 0; i < N; i++){
     24e:	2485                	addiw	s1,s1,1
     250:	0ff4f493          	andi	s1,s1,255
     254:	ff2495e3          	bne	s1,s2,23e <createtest+0x5a>
}
     258:	70a2                	ld	ra,40(sp)
     25a:	7402                	ld	s0,32(sp)
     25c:	64e2                	ld	s1,24(sp)
     25e:	6942                	ld	s2,16(sp)
     260:	6145                	addi	sp,sp,48
     262:	8082                	ret

0000000000000264 <bigwrite>:
{
     264:	715d                	addi	sp,sp,-80
     266:	e486                	sd	ra,72(sp)
     268:	e0a2                	sd	s0,64(sp)
     26a:	fc26                	sd	s1,56(sp)
     26c:	f84a                	sd	s2,48(sp)
     26e:	f44e                	sd	s3,40(sp)
     270:	f052                	sd	s4,32(sp)
     272:	ec56                	sd	s5,24(sp)
     274:	e85a                	sd	s6,16(sp)
     276:	e45e                	sd	s7,8(sp)
     278:	0880                	addi	s0,sp,80
     27a:	8baa                	mv	s7,a0
  unlink("bigwrite");
     27c:	00006517          	auipc	a0,0x6
     280:	ad450513          	addi	a0,a0,-1324 # 5d50 <malloc+0x2b4>
     284:	00005097          	auipc	ra,0x5
     288:	422080e7          	jalr	1058(ra) # 56a6 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     28c:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     290:	00006a97          	auipc	s5,0x6
     294:	ac0a8a93          	addi	s5,s5,-1344 # 5d50 <malloc+0x2b4>
      int cc = write(fd, buf, sz);
     298:	0000ca17          	auipc	s4,0xc
     29c:	8a8a0a13          	addi	s4,s4,-1880 # bb40 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2a0:	6b0d                	lui	s6,0x3
     2a2:	1c9b0b13          	addi	s6,s6,457 # 31c9 <subdir+0x171>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2a6:	20200593          	li	a1,514
     2aa:	8556                	mv	a0,s5
     2ac:	00005097          	auipc	ra,0x5
     2b0:	3ea080e7          	jalr	1002(ra) # 5696 <open>
     2b4:	892a                	mv	s2,a0
    if(fd < 0){
     2b6:	04054d63          	bltz	a0,310 <bigwrite+0xac>
      int cc = write(fd, buf, sz);
     2ba:	8626                	mv	a2,s1
     2bc:	85d2                	mv	a1,s4
     2be:	00005097          	auipc	ra,0x5
     2c2:	3b8080e7          	jalr	952(ra) # 5676 <write>
     2c6:	89aa                	mv	s3,a0
      if(cc != sz){
     2c8:	06a49463          	bne	s1,a0,330 <bigwrite+0xcc>
      int cc = write(fd, buf, sz);
     2cc:	8626                	mv	a2,s1
     2ce:	85d2                	mv	a1,s4
     2d0:	854a                	mv	a0,s2
     2d2:	00005097          	auipc	ra,0x5
     2d6:	3a4080e7          	jalr	932(ra) # 5676 <write>
      if(cc != sz){
     2da:	04951963          	bne	a0,s1,32c <bigwrite+0xc8>
    close(fd);
     2de:	854a                	mv	a0,s2
     2e0:	00005097          	auipc	ra,0x5
     2e4:	39e080e7          	jalr	926(ra) # 567e <close>
    unlink("bigwrite");
     2e8:	8556                	mv	a0,s5
     2ea:	00005097          	auipc	ra,0x5
     2ee:	3bc080e7          	jalr	956(ra) # 56a6 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2f2:	1d74849b          	addiw	s1,s1,471
     2f6:	fb6498e3          	bne	s1,s6,2a6 <bigwrite+0x42>
}
     2fa:	60a6                	ld	ra,72(sp)
     2fc:	6406                	ld	s0,64(sp)
     2fe:	74e2                	ld	s1,56(sp)
     300:	7942                	ld	s2,48(sp)
     302:	79a2                	ld	s3,40(sp)
     304:	7a02                	ld	s4,32(sp)
     306:	6ae2                	ld	s5,24(sp)
     308:	6b42                	ld	s6,16(sp)
     30a:	6ba2                	ld	s7,8(sp)
     30c:	6161                	addi	sp,sp,80
     30e:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     310:	85de                	mv	a1,s7
     312:	00006517          	auipc	a0,0x6
     316:	c6650513          	addi	a0,a0,-922 # 5f78 <malloc+0x4dc>
     31a:	00005097          	auipc	ra,0x5
     31e:	6c4080e7          	jalr	1732(ra) # 59de <printf>
      exit(1);
     322:	4505                	li	a0,1
     324:	00005097          	auipc	ra,0x5
     328:	332080e7          	jalr	818(ra) # 5656 <exit>
     32c:	84ce                	mv	s1,s3
      int cc = write(fd, buf, sz);
     32e:	89aa                	mv	s3,a0
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     330:	86ce                	mv	a3,s3
     332:	8626                	mv	a2,s1
     334:	85de                	mv	a1,s7
     336:	00006517          	auipc	a0,0x6
     33a:	c6250513          	addi	a0,a0,-926 # 5f98 <malloc+0x4fc>
     33e:	00005097          	auipc	ra,0x5
     342:	6a0080e7          	jalr	1696(ra) # 59de <printf>
        exit(1);
     346:	4505                	li	a0,1
     348:	00005097          	auipc	ra,0x5
     34c:	30e080e7          	jalr	782(ra) # 5656 <exit>

0000000000000350 <copyin>:
{
     350:	715d                	addi	sp,sp,-80
     352:	e486                	sd	ra,72(sp)
     354:	e0a2                	sd	s0,64(sp)
     356:	fc26                	sd	s1,56(sp)
     358:	f84a                	sd	s2,48(sp)
     35a:	f44e                	sd	s3,40(sp)
     35c:	f052                	sd	s4,32(sp)
     35e:	0880                	addi	s0,sp,80
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     360:	4785                	li	a5,1
     362:	07fe                	slli	a5,a5,0x1f
     364:	fcf43023          	sd	a5,-64(s0)
     368:	57fd                	li	a5,-1
     36a:	fcf43423          	sd	a5,-56(s0)
  for(int ai = 0; ai < 2; ai++){
     36e:	fc040913          	addi	s2,s0,-64
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     372:	00006a17          	auipc	s4,0x6
     376:	c3ea0a13          	addi	s4,s4,-962 # 5fb0 <malloc+0x514>
    uint64 addr = addrs[ai];
     37a:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     37e:	20100593          	li	a1,513
     382:	8552                	mv	a0,s4
     384:	00005097          	auipc	ra,0x5
     388:	312080e7          	jalr	786(ra) # 5696 <open>
     38c:	84aa                	mv	s1,a0
    if(fd < 0){
     38e:	08054863          	bltz	a0,41e <copyin+0xce>
    int n = write(fd, (void*)addr, 8192);
     392:	6609                	lui	a2,0x2
     394:	85ce                	mv	a1,s3
     396:	00005097          	auipc	ra,0x5
     39a:	2e0080e7          	jalr	736(ra) # 5676 <write>
    if(n >= 0){
     39e:	08055d63          	bgez	a0,438 <copyin+0xe8>
    close(fd);
     3a2:	8526                	mv	a0,s1
     3a4:	00005097          	auipc	ra,0x5
     3a8:	2da080e7          	jalr	730(ra) # 567e <close>
    unlink("copyin1");
     3ac:	8552                	mv	a0,s4
     3ae:	00005097          	auipc	ra,0x5
     3b2:	2f8080e7          	jalr	760(ra) # 56a6 <unlink>
    n = write(1, (char*)addr, 8192);
     3b6:	6609                	lui	a2,0x2
     3b8:	85ce                	mv	a1,s3
     3ba:	4505                	li	a0,1
     3bc:	00005097          	auipc	ra,0x5
     3c0:	2ba080e7          	jalr	698(ra) # 5676 <write>
    if(n > 0){
     3c4:	08a04963          	bgtz	a0,456 <copyin+0x106>
    if(pipe(fds) < 0){
     3c8:	fb840513          	addi	a0,s0,-72
     3cc:	00005097          	auipc	ra,0x5
     3d0:	29a080e7          	jalr	666(ra) # 5666 <pipe>
     3d4:	0a054063          	bltz	a0,474 <copyin+0x124>
    n = write(fds[1], (char*)addr, 8192);
     3d8:	6609                	lui	a2,0x2
     3da:	85ce                	mv	a1,s3
     3dc:	fbc42503          	lw	a0,-68(s0)
     3e0:	00005097          	auipc	ra,0x5
     3e4:	296080e7          	jalr	662(ra) # 5676 <write>
    if(n > 0){
     3e8:	0aa04363          	bgtz	a0,48e <copyin+0x13e>
    close(fds[0]);
     3ec:	fb842503          	lw	a0,-72(s0)
     3f0:	00005097          	auipc	ra,0x5
     3f4:	28e080e7          	jalr	654(ra) # 567e <close>
    close(fds[1]);
     3f8:	fbc42503          	lw	a0,-68(s0)
     3fc:	00005097          	auipc	ra,0x5
     400:	282080e7          	jalr	642(ra) # 567e <close>
  for(int ai = 0; ai < 2; ai++){
     404:	0921                	addi	s2,s2,8
     406:	fd040793          	addi	a5,s0,-48
     40a:	f6f918e3          	bne	s2,a5,37a <copyin+0x2a>
}
     40e:	60a6                	ld	ra,72(sp)
     410:	6406                	ld	s0,64(sp)
     412:	74e2                	ld	s1,56(sp)
     414:	7942                	ld	s2,48(sp)
     416:	79a2                	ld	s3,40(sp)
     418:	7a02                	ld	s4,32(sp)
     41a:	6161                	addi	sp,sp,80
     41c:	8082                	ret
      printf("open(copyin1) failed\n");
     41e:	00006517          	auipc	a0,0x6
     422:	b9a50513          	addi	a0,a0,-1126 # 5fb8 <malloc+0x51c>
     426:	00005097          	auipc	ra,0x5
     42a:	5b8080e7          	jalr	1464(ra) # 59de <printf>
      exit(1);
     42e:	4505                	li	a0,1
     430:	00005097          	auipc	ra,0x5
     434:	226080e7          	jalr	550(ra) # 5656 <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", addr, n);
     438:	862a                	mv	a2,a0
     43a:	85ce                	mv	a1,s3
     43c:	00006517          	auipc	a0,0x6
     440:	b9450513          	addi	a0,a0,-1132 # 5fd0 <malloc+0x534>
     444:	00005097          	auipc	ra,0x5
     448:	59a080e7          	jalr	1434(ra) # 59de <printf>
      exit(1);
     44c:	4505                	li	a0,1
     44e:	00005097          	auipc	ra,0x5
     452:	208080e7          	jalr	520(ra) # 5656 <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     456:	862a                	mv	a2,a0
     458:	85ce                	mv	a1,s3
     45a:	00006517          	auipc	a0,0x6
     45e:	ba650513          	addi	a0,a0,-1114 # 6000 <malloc+0x564>
     462:	00005097          	auipc	ra,0x5
     466:	57c080e7          	jalr	1404(ra) # 59de <printf>
      exit(1);
     46a:	4505                	li	a0,1
     46c:	00005097          	auipc	ra,0x5
     470:	1ea080e7          	jalr	490(ra) # 5656 <exit>
      printf("pipe() failed\n");
     474:	00006517          	auipc	a0,0x6
     478:	bbc50513          	addi	a0,a0,-1092 # 6030 <malloc+0x594>
     47c:	00005097          	auipc	ra,0x5
     480:	562080e7          	jalr	1378(ra) # 59de <printf>
      exit(1);
     484:	4505                	li	a0,1
     486:	00005097          	auipc	ra,0x5
     48a:	1d0080e7          	jalr	464(ra) # 5656 <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     48e:	862a                	mv	a2,a0
     490:	85ce                	mv	a1,s3
     492:	00006517          	auipc	a0,0x6
     496:	bae50513          	addi	a0,a0,-1106 # 6040 <malloc+0x5a4>
     49a:	00005097          	auipc	ra,0x5
     49e:	544080e7          	jalr	1348(ra) # 59de <printf>
      exit(1);
     4a2:	4505                	li	a0,1
     4a4:	00005097          	auipc	ra,0x5
     4a8:	1b2080e7          	jalr	434(ra) # 5656 <exit>

00000000000004ac <copyout>:
{
     4ac:	711d                	addi	sp,sp,-96
     4ae:	ec86                	sd	ra,88(sp)
     4b0:	e8a2                	sd	s0,80(sp)
     4b2:	e4a6                	sd	s1,72(sp)
     4b4:	e0ca                	sd	s2,64(sp)
     4b6:	fc4e                	sd	s3,56(sp)
     4b8:	f852                	sd	s4,48(sp)
     4ba:	f456                	sd	s5,40(sp)
     4bc:	1080                	addi	s0,sp,96
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     4be:	4785                	li	a5,1
     4c0:	07fe                	slli	a5,a5,0x1f
     4c2:	faf43823          	sd	a5,-80(s0)
     4c6:	57fd                	li	a5,-1
     4c8:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < 2; ai++){
     4cc:	fb040913          	addi	s2,s0,-80
    int fd = open("README", 0);
     4d0:	00006a17          	auipc	s4,0x6
     4d4:	ba0a0a13          	addi	s4,s4,-1120 # 6070 <malloc+0x5d4>
    n = write(fds[1], "x", 1);
     4d8:	00006a97          	auipc	s5,0x6
     4dc:	a70a8a93          	addi	s5,s5,-1424 # 5f48 <malloc+0x4ac>
    uint64 addr = addrs[ai];
     4e0:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     4e4:	4581                	li	a1,0
     4e6:	8552                	mv	a0,s4
     4e8:	00005097          	auipc	ra,0x5
     4ec:	1ae080e7          	jalr	430(ra) # 5696 <open>
     4f0:	84aa                	mv	s1,a0
    if(fd < 0){
     4f2:	08054663          	bltz	a0,57e <copyout+0xd2>
    int n = read(fd, (void*)addr, 8192);
     4f6:	6609                	lui	a2,0x2
     4f8:	85ce                	mv	a1,s3
     4fa:	00005097          	auipc	ra,0x5
     4fe:	174080e7          	jalr	372(ra) # 566e <read>
    if(n > 0){
     502:	08a04b63          	bgtz	a0,598 <copyout+0xec>
    close(fd);
     506:	8526                	mv	a0,s1
     508:	00005097          	auipc	ra,0x5
     50c:	176080e7          	jalr	374(ra) # 567e <close>
    if(pipe(fds) < 0){
     510:	fa840513          	addi	a0,s0,-88
     514:	00005097          	auipc	ra,0x5
     518:	152080e7          	jalr	338(ra) # 5666 <pipe>
     51c:	08054d63          	bltz	a0,5b6 <copyout+0x10a>
    n = write(fds[1], "x", 1);
     520:	4605                	li	a2,1
     522:	85d6                	mv	a1,s5
     524:	fac42503          	lw	a0,-84(s0)
     528:	00005097          	auipc	ra,0x5
     52c:	14e080e7          	jalr	334(ra) # 5676 <write>
    if(n != 1){
     530:	4785                	li	a5,1
     532:	08f51f63          	bne	a0,a5,5d0 <copyout+0x124>
    n = read(fds[0], (void*)addr, 8192);
     536:	6609                	lui	a2,0x2
     538:	85ce                	mv	a1,s3
     53a:	fa842503          	lw	a0,-88(s0)
     53e:	00005097          	auipc	ra,0x5
     542:	130080e7          	jalr	304(ra) # 566e <read>
    if(n > 0){
     546:	0aa04263          	bgtz	a0,5ea <copyout+0x13e>
    close(fds[0]);
     54a:	fa842503          	lw	a0,-88(s0)
     54e:	00005097          	auipc	ra,0x5
     552:	130080e7          	jalr	304(ra) # 567e <close>
    close(fds[1]);
     556:	fac42503          	lw	a0,-84(s0)
     55a:	00005097          	auipc	ra,0x5
     55e:	124080e7          	jalr	292(ra) # 567e <close>
  for(int ai = 0; ai < 2; ai++){
     562:	0921                	addi	s2,s2,8
     564:	fc040793          	addi	a5,s0,-64
     568:	f6f91ce3          	bne	s2,a5,4e0 <copyout+0x34>
}
     56c:	60e6                	ld	ra,88(sp)
     56e:	6446                	ld	s0,80(sp)
     570:	64a6                	ld	s1,72(sp)
     572:	6906                	ld	s2,64(sp)
     574:	79e2                	ld	s3,56(sp)
     576:	7a42                	ld	s4,48(sp)
     578:	7aa2                	ld	s5,40(sp)
     57a:	6125                	addi	sp,sp,96
     57c:	8082                	ret
      printf("open(README) failed\n");
     57e:	00006517          	auipc	a0,0x6
     582:	afa50513          	addi	a0,a0,-1286 # 6078 <malloc+0x5dc>
     586:	00005097          	auipc	ra,0x5
     58a:	458080e7          	jalr	1112(ra) # 59de <printf>
      exit(1);
     58e:	4505                	li	a0,1
     590:	00005097          	auipc	ra,0x5
     594:	0c6080e7          	jalr	198(ra) # 5656 <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     598:	862a                	mv	a2,a0
     59a:	85ce                	mv	a1,s3
     59c:	00006517          	auipc	a0,0x6
     5a0:	af450513          	addi	a0,a0,-1292 # 6090 <malloc+0x5f4>
     5a4:	00005097          	auipc	ra,0x5
     5a8:	43a080e7          	jalr	1082(ra) # 59de <printf>
      exit(1);
     5ac:	4505                	li	a0,1
     5ae:	00005097          	auipc	ra,0x5
     5b2:	0a8080e7          	jalr	168(ra) # 5656 <exit>
      printf("pipe() failed\n");
     5b6:	00006517          	auipc	a0,0x6
     5ba:	a7a50513          	addi	a0,a0,-1414 # 6030 <malloc+0x594>
     5be:	00005097          	auipc	ra,0x5
     5c2:	420080e7          	jalr	1056(ra) # 59de <printf>
      exit(1);
     5c6:	4505                	li	a0,1
     5c8:	00005097          	auipc	ra,0x5
     5cc:	08e080e7          	jalr	142(ra) # 5656 <exit>
      printf("pipe write failed\n");
     5d0:	00006517          	auipc	a0,0x6
     5d4:	af050513          	addi	a0,a0,-1296 # 60c0 <malloc+0x624>
     5d8:	00005097          	auipc	ra,0x5
     5dc:	406080e7          	jalr	1030(ra) # 59de <printf>
      exit(1);
     5e0:	4505                	li	a0,1
     5e2:	00005097          	auipc	ra,0x5
     5e6:	074080e7          	jalr	116(ra) # 5656 <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     5ea:	862a                	mv	a2,a0
     5ec:	85ce                	mv	a1,s3
     5ee:	00006517          	auipc	a0,0x6
     5f2:	aea50513          	addi	a0,a0,-1302 # 60d8 <malloc+0x63c>
     5f6:	00005097          	auipc	ra,0x5
     5fa:	3e8080e7          	jalr	1000(ra) # 59de <printf>
      exit(1);
     5fe:	4505                	li	a0,1
     600:	00005097          	auipc	ra,0x5
     604:	056080e7          	jalr	86(ra) # 5656 <exit>

0000000000000608 <truncate1>:
{
     608:	711d                	addi	sp,sp,-96
     60a:	ec86                	sd	ra,88(sp)
     60c:	e8a2                	sd	s0,80(sp)
     60e:	e4a6                	sd	s1,72(sp)
     610:	e0ca                	sd	s2,64(sp)
     612:	fc4e                	sd	s3,56(sp)
     614:	f852                	sd	s4,48(sp)
     616:	f456                	sd	s5,40(sp)
     618:	1080                	addi	s0,sp,96
     61a:	8aaa                	mv	s5,a0
  unlink("truncfile");
     61c:	00006517          	auipc	a0,0x6
     620:	91450513          	addi	a0,a0,-1772 # 5f30 <malloc+0x494>
     624:	00005097          	auipc	ra,0x5
     628:	082080e7          	jalr	130(ra) # 56a6 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     62c:	60100593          	li	a1,1537
     630:	00006517          	auipc	a0,0x6
     634:	90050513          	addi	a0,a0,-1792 # 5f30 <malloc+0x494>
     638:	00005097          	auipc	ra,0x5
     63c:	05e080e7          	jalr	94(ra) # 5696 <open>
     640:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     642:	4611                	li	a2,4
     644:	00006597          	auipc	a1,0x6
     648:	8fc58593          	addi	a1,a1,-1796 # 5f40 <malloc+0x4a4>
     64c:	00005097          	auipc	ra,0x5
     650:	02a080e7          	jalr	42(ra) # 5676 <write>
  close(fd1);
     654:	8526                	mv	a0,s1
     656:	00005097          	auipc	ra,0x5
     65a:	028080e7          	jalr	40(ra) # 567e <close>
  int fd2 = open("truncfile", O_RDONLY);
     65e:	4581                	li	a1,0
     660:	00006517          	auipc	a0,0x6
     664:	8d050513          	addi	a0,a0,-1840 # 5f30 <malloc+0x494>
     668:	00005097          	auipc	ra,0x5
     66c:	02e080e7          	jalr	46(ra) # 5696 <open>
     670:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     672:	02000613          	li	a2,32
     676:	fa040593          	addi	a1,s0,-96
     67a:	00005097          	auipc	ra,0x5
     67e:	ff4080e7          	jalr	-12(ra) # 566e <read>
  if(n != 4){
     682:	4791                	li	a5,4
     684:	0cf51e63          	bne	a0,a5,760 <truncate1+0x158>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     688:	40100593          	li	a1,1025
     68c:	00006517          	auipc	a0,0x6
     690:	8a450513          	addi	a0,a0,-1884 # 5f30 <malloc+0x494>
     694:	00005097          	auipc	ra,0x5
     698:	002080e7          	jalr	2(ra) # 5696 <open>
     69c:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     69e:	4581                	li	a1,0
     6a0:	00006517          	auipc	a0,0x6
     6a4:	89050513          	addi	a0,a0,-1904 # 5f30 <malloc+0x494>
     6a8:	00005097          	auipc	ra,0x5
     6ac:	fee080e7          	jalr	-18(ra) # 5696 <open>
     6b0:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     6b2:	02000613          	li	a2,32
     6b6:	fa040593          	addi	a1,s0,-96
     6ba:	00005097          	auipc	ra,0x5
     6be:	fb4080e7          	jalr	-76(ra) # 566e <read>
     6c2:	8a2a                	mv	s4,a0
  if(n != 0){
     6c4:	ed4d                	bnez	a0,77e <truncate1+0x176>
  n = read(fd2, buf, sizeof(buf));
     6c6:	02000613          	li	a2,32
     6ca:	fa040593          	addi	a1,s0,-96
     6ce:	8526                	mv	a0,s1
     6d0:	00005097          	auipc	ra,0x5
     6d4:	f9e080e7          	jalr	-98(ra) # 566e <read>
     6d8:	8a2a                	mv	s4,a0
  if(n != 0){
     6da:	e971                	bnez	a0,7ae <truncate1+0x1a6>
  write(fd1, "abcdef", 6);
     6dc:	4619                	li	a2,6
     6de:	00006597          	auipc	a1,0x6
     6e2:	a8a58593          	addi	a1,a1,-1398 # 6168 <malloc+0x6cc>
     6e6:	854e                	mv	a0,s3
     6e8:	00005097          	auipc	ra,0x5
     6ec:	f8e080e7          	jalr	-114(ra) # 5676 <write>
  n = read(fd3, buf, sizeof(buf));
     6f0:	02000613          	li	a2,32
     6f4:	fa040593          	addi	a1,s0,-96
     6f8:	854a                	mv	a0,s2
     6fa:	00005097          	auipc	ra,0x5
     6fe:	f74080e7          	jalr	-140(ra) # 566e <read>
  if(n != 6){
     702:	4799                	li	a5,6
     704:	0cf51d63          	bne	a0,a5,7de <truncate1+0x1d6>
  n = read(fd2, buf, sizeof(buf));
     708:	02000613          	li	a2,32
     70c:	fa040593          	addi	a1,s0,-96
     710:	8526                	mv	a0,s1
     712:	00005097          	auipc	ra,0x5
     716:	f5c080e7          	jalr	-164(ra) # 566e <read>
  if(n != 2){
     71a:	4789                	li	a5,2
     71c:	0ef51063          	bne	a0,a5,7fc <truncate1+0x1f4>
  unlink("truncfile");
     720:	00006517          	auipc	a0,0x6
     724:	81050513          	addi	a0,a0,-2032 # 5f30 <malloc+0x494>
     728:	00005097          	auipc	ra,0x5
     72c:	f7e080e7          	jalr	-130(ra) # 56a6 <unlink>
  close(fd1);
     730:	854e                	mv	a0,s3
     732:	00005097          	auipc	ra,0x5
     736:	f4c080e7          	jalr	-180(ra) # 567e <close>
  close(fd2);
     73a:	8526                	mv	a0,s1
     73c:	00005097          	auipc	ra,0x5
     740:	f42080e7          	jalr	-190(ra) # 567e <close>
  close(fd3);
     744:	854a                	mv	a0,s2
     746:	00005097          	auipc	ra,0x5
     74a:	f38080e7          	jalr	-200(ra) # 567e <close>
}
     74e:	60e6                	ld	ra,88(sp)
     750:	6446                	ld	s0,80(sp)
     752:	64a6                	ld	s1,72(sp)
     754:	6906                	ld	s2,64(sp)
     756:	79e2                	ld	s3,56(sp)
     758:	7a42                	ld	s4,48(sp)
     75a:	7aa2                	ld	s5,40(sp)
     75c:	6125                	addi	sp,sp,96
     75e:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     760:	862a                	mv	a2,a0
     762:	85d6                	mv	a1,s5
     764:	00006517          	auipc	a0,0x6
     768:	9a450513          	addi	a0,a0,-1628 # 6108 <malloc+0x66c>
     76c:	00005097          	auipc	ra,0x5
     770:	272080e7          	jalr	626(ra) # 59de <printf>
    exit(1);
     774:	4505                	li	a0,1
     776:	00005097          	auipc	ra,0x5
     77a:	ee0080e7          	jalr	-288(ra) # 5656 <exit>
    printf("aaa fd3=%d\n", fd3);
     77e:	85ca                	mv	a1,s2
     780:	00006517          	auipc	a0,0x6
     784:	9a850513          	addi	a0,a0,-1624 # 6128 <malloc+0x68c>
     788:	00005097          	auipc	ra,0x5
     78c:	256080e7          	jalr	598(ra) # 59de <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     790:	8652                	mv	a2,s4
     792:	85d6                	mv	a1,s5
     794:	00006517          	auipc	a0,0x6
     798:	9a450513          	addi	a0,a0,-1628 # 6138 <malloc+0x69c>
     79c:	00005097          	auipc	ra,0x5
     7a0:	242080e7          	jalr	578(ra) # 59de <printf>
    exit(1);
     7a4:	4505                	li	a0,1
     7a6:	00005097          	auipc	ra,0x5
     7aa:	eb0080e7          	jalr	-336(ra) # 5656 <exit>
    printf("bbb fd2=%d\n", fd2);
     7ae:	85a6                	mv	a1,s1
     7b0:	00006517          	auipc	a0,0x6
     7b4:	9a850513          	addi	a0,a0,-1624 # 6158 <malloc+0x6bc>
     7b8:	00005097          	auipc	ra,0x5
     7bc:	226080e7          	jalr	550(ra) # 59de <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     7c0:	8652                	mv	a2,s4
     7c2:	85d6                	mv	a1,s5
     7c4:	00006517          	auipc	a0,0x6
     7c8:	97450513          	addi	a0,a0,-1676 # 6138 <malloc+0x69c>
     7cc:	00005097          	auipc	ra,0x5
     7d0:	212080e7          	jalr	530(ra) # 59de <printf>
    exit(1);
     7d4:	4505                	li	a0,1
     7d6:	00005097          	auipc	ra,0x5
     7da:	e80080e7          	jalr	-384(ra) # 5656 <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     7de:	862a                	mv	a2,a0
     7e0:	85d6                	mv	a1,s5
     7e2:	00006517          	auipc	a0,0x6
     7e6:	98e50513          	addi	a0,a0,-1650 # 6170 <malloc+0x6d4>
     7ea:	00005097          	auipc	ra,0x5
     7ee:	1f4080e7          	jalr	500(ra) # 59de <printf>
    exit(1);
     7f2:	4505                	li	a0,1
     7f4:	00005097          	auipc	ra,0x5
     7f8:	e62080e7          	jalr	-414(ra) # 5656 <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     7fc:	862a                	mv	a2,a0
     7fe:	85d6                	mv	a1,s5
     800:	00006517          	auipc	a0,0x6
     804:	99050513          	addi	a0,a0,-1648 # 6190 <malloc+0x6f4>
     808:	00005097          	auipc	ra,0x5
     80c:	1d6080e7          	jalr	470(ra) # 59de <printf>
    exit(1);
     810:	4505                	li	a0,1
     812:	00005097          	auipc	ra,0x5
     816:	e44080e7          	jalr	-444(ra) # 5656 <exit>

000000000000081a <writetest>:
{
     81a:	7139                	addi	sp,sp,-64
     81c:	fc06                	sd	ra,56(sp)
     81e:	f822                	sd	s0,48(sp)
     820:	f426                	sd	s1,40(sp)
     822:	f04a                	sd	s2,32(sp)
     824:	ec4e                	sd	s3,24(sp)
     826:	e852                	sd	s4,16(sp)
     828:	e456                	sd	s5,8(sp)
     82a:	e05a                	sd	s6,0(sp)
     82c:	0080                	addi	s0,sp,64
     82e:	8b2a                	mv	s6,a0
  fd = open("small", O_CREATE|O_RDWR);
     830:	20200593          	li	a1,514
     834:	00006517          	auipc	a0,0x6
     838:	97c50513          	addi	a0,a0,-1668 # 61b0 <malloc+0x714>
     83c:	00005097          	auipc	ra,0x5
     840:	e5a080e7          	jalr	-422(ra) # 5696 <open>
  if(fd < 0){
     844:	0a054d63          	bltz	a0,8fe <writetest+0xe4>
     848:	892a                	mv	s2,a0
     84a:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     84c:	00006997          	auipc	s3,0x6
     850:	98c98993          	addi	s3,s3,-1652 # 61d8 <malloc+0x73c>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     854:	00006a97          	auipc	s5,0x6
     858:	9bca8a93          	addi	s5,s5,-1604 # 6210 <malloc+0x774>
  for(i = 0; i < N; i++){
     85c:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     860:	4629                	li	a2,10
     862:	85ce                	mv	a1,s3
     864:	854a                	mv	a0,s2
     866:	00005097          	auipc	ra,0x5
     86a:	e10080e7          	jalr	-496(ra) # 5676 <write>
     86e:	47a9                	li	a5,10
     870:	0af51563          	bne	a0,a5,91a <writetest+0x100>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     874:	4629                	li	a2,10
     876:	85d6                	mv	a1,s5
     878:	854a                	mv	a0,s2
     87a:	00005097          	auipc	ra,0x5
     87e:	dfc080e7          	jalr	-516(ra) # 5676 <write>
     882:	47a9                	li	a5,10
     884:	0af51a63          	bne	a0,a5,938 <writetest+0x11e>
  for(i = 0; i < N; i++){
     888:	2485                	addiw	s1,s1,1
     88a:	fd449be3          	bne	s1,s4,860 <writetest+0x46>
  close(fd);
     88e:	854a                	mv	a0,s2
     890:	00005097          	auipc	ra,0x5
     894:	dee080e7          	jalr	-530(ra) # 567e <close>
  fd = open("small", O_RDONLY);
     898:	4581                	li	a1,0
     89a:	00006517          	auipc	a0,0x6
     89e:	91650513          	addi	a0,a0,-1770 # 61b0 <malloc+0x714>
     8a2:	00005097          	auipc	ra,0x5
     8a6:	df4080e7          	jalr	-524(ra) # 5696 <open>
     8aa:	84aa                	mv	s1,a0
  if(fd < 0){
     8ac:	0a054563          	bltz	a0,956 <writetest+0x13c>
  i = read(fd, buf, N*SZ*2);
     8b0:	7d000613          	li	a2,2000
     8b4:	0000b597          	auipc	a1,0xb
     8b8:	28c58593          	addi	a1,a1,652 # bb40 <buf>
     8bc:	00005097          	auipc	ra,0x5
     8c0:	db2080e7          	jalr	-590(ra) # 566e <read>
  if(i != N*SZ*2){
     8c4:	7d000793          	li	a5,2000
     8c8:	0af51563          	bne	a0,a5,972 <writetest+0x158>
  close(fd);
     8cc:	8526                	mv	a0,s1
     8ce:	00005097          	auipc	ra,0x5
     8d2:	db0080e7          	jalr	-592(ra) # 567e <close>
  if(unlink("small") < 0){
     8d6:	00006517          	auipc	a0,0x6
     8da:	8da50513          	addi	a0,a0,-1830 # 61b0 <malloc+0x714>
     8de:	00005097          	auipc	ra,0x5
     8e2:	dc8080e7          	jalr	-568(ra) # 56a6 <unlink>
     8e6:	0a054463          	bltz	a0,98e <writetest+0x174>
}
     8ea:	70e2                	ld	ra,56(sp)
     8ec:	7442                	ld	s0,48(sp)
     8ee:	74a2                	ld	s1,40(sp)
     8f0:	7902                	ld	s2,32(sp)
     8f2:	69e2                	ld	s3,24(sp)
     8f4:	6a42                	ld	s4,16(sp)
     8f6:	6aa2                	ld	s5,8(sp)
     8f8:	6b02                	ld	s6,0(sp)
     8fa:	6121                	addi	sp,sp,64
     8fc:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     8fe:	85da                	mv	a1,s6
     900:	00006517          	auipc	a0,0x6
     904:	8b850513          	addi	a0,a0,-1864 # 61b8 <malloc+0x71c>
     908:	00005097          	auipc	ra,0x5
     90c:	0d6080e7          	jalr	214(ra) # 59de <printf>
    exit(1);
     910:	4505                	li	a0,1
     912:	00005097          	auipc	ra,0x5
     916:	d44080e7          	jalr	-700(ra) # 5656 <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     91a:	8626                	mv	a2,s1
     91c:	85da                	mv	a1,s6
     91e:	00006517          	auipc	a0,0x6
     922:	8ca50513          	addi	a0,a0,-1846 # 61e8 <malloc+0x74c>
     926:	00005097          	auipc	ra,0x5
     92a:	0b8080e7          	jalr	184(ra) # 59de <printf>
      exit(1);
     92e:	4505                	li	a0,1
     930:	00005097          	auipc	ra,0x5
     934:	d26080e7          	jalr	-730(ra) # 5656 <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     938:	8626                	mv	a2,s1
     93a:	85da                	mv	a1,s6
     93c:	00006517          	auipc	a0,0x6
     940:	8e450513          	addi	a0,a0,-1820 # 6220 <malloc+0x784>
     944:	00005097          	auipc	ra,0x5
     948:	09a080e7          	jalr	154(ra) # 59de <printf>
      exit(1);
     94c:	4505                	li	a0,1
     94e:	00005097          	auipc	ra,0x5
     952:	d08080e7          	jalr	-760(ra) # 5656 <exit>
    printf("%s: error: open small failed!\n", s);
     956:	85da                	mv	a1,s6
     958:	00006517          	auipc	a0,0x6
     95c:	8f050513          	addi	a0,a0,-1808 # 6248 <malloc+0x7ac>
     960:	00005097          	auipc	ra,0x5
     964:	07e080e7          	jalr	126(ra) # 59de <printf>
    exit(1);
     968:	4505                	li	a0,1
     96a:	00005097          	auipc	ra,0x5
     96e:	cec080e7          	jalr	-788(ra) # 5656 <exit>
    printf("%s: read failed\n", s);
     972:	85da                	mv	a1,s6
     974:	00006517          	auipc	a0,0x6
     978:	8f450513          	addi	a0,a0,-1804 # 6268 <malloc+0x7cc>
     97c:	00005097          	auipc	ra,0x5
     980:	062080e7          	jalr	98(ra) # 59de <printf>
    exit(1);
     984:	4505                	li	a0,1
     986:	00005097          	auipc	ra,0x5
     98a:	cd0080e7          	jalr	-816(ra) # 5656 <exit>
    printf("%s: unlink small failed\n", s);
     98e:	85da                	mv	a1,s6
     990:	00006517          	auipc	a0,0x6
     994:	8f050513          	addi	a0,a0,-1808 # 6280 <malloc+0x7e4>
     998:	00005097          	auipc	ra,0x5
     99c:	046080e7          	jalr	70(ra) # 59de <printf>
    exit(1);
     9a0:	4505                	li	a0,1
     9a2:	00005097          	auipc	ra,0x5
     9a6:	cb4080e7          	jalr	-844(ra) # 5656 <exit>

00000000000009aa <writebig>:
{
     9aa:	7139                	addi	sp,sp,-64
     9ac:	fc06                	sd	ra,56(sp)
     9ae:	f822                	sd	s0,48(sp)
     9b0:	f426                	sd	s1,40(sp)
     9b2:	f04a                	sd	s2,32(sp)
     9b4:	ec4e                	sd	s3,24(sp)
     9b6:	e852                	sd	s4,16(sp)
     9b8:	e456                	sd	s5,8(sp)
     9ba:	0080                	addi	s0,sp,64
     9bc:	8aaa                	mv	s5,a0
  fd = open("big", O_CREATE|O_RDWR);
     9be:	20200593          	li	a1,514
     9c2:	00006517          	auipc	a0,0x6
     9c6:	8de50513          	addi	a0,a0,-1826 # 62a0 <malloc+0x804>
     9ca:	00005097          	auipc	ra,0x5
     9ce:	ccc080e7          	jalr	-820(ra) # 5696 <open>
     9d2:	89aa                	mv	s3,a0
  for(i = 0; i < MAXFILE; i++){
     9d4:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     9d6:	0000b917          	auipc	s2,0xb
     9da:	16a90913          	addi	s2,s2,362 # bb40 <buf>
  for(i = 0; i < MAXFILE; i++){
     9de:	10c00a13          	li	s4,268
  if(fd < 0){
     9e2:	06054c63          	bltz	a0,a5a <writebig+0xb0>
    ((int*)buf)[0] = i;
     9e6:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
     9ea:	40000613          	li	a2,1024
     9ee:	85ca                	mv	a1,s2
     9f0:	854e                	mv	a0,s3
     9f2:	00005097          	auipc	ra,0x5
     9f6:	c84080e7          	jalr	-892(ra) # 5676 <write>
     9fa:	40000793          	li	a5,1024
     9fe:	06f51c63          	bne	a0,a5,a76 <writebig+0xcc>
  for(i = 0; i < MAXFILE; i++){
     a02:	2485                	addiw	s1,s1,1
     a04:	ff4491e3          	bne	s1,s4,9e6 <writebig+0x3c>
  close(fd);
     a08:	854e                	mv	a0,s3
     a0a:	00005097          	auipc	ra,0x5
     a0e:	c74080e7          	jalr	-908(ra) # 567e <close>
  fd = open("big", O_RDONLY);
     a12:	4581                	li	a1,0
     a14:	00006517          	auipc	a0,0x6
     a18:	88c50513          	addi	a0,a0,-1908 # 62a0 <malloc+0x804>
     a1c:	00005097          	auipc	ra,0x5
     a20:	c7a080e7          	jalr	-902(ra) # 5696 <open>
     a24:	89aa                	mv	s3,a0
  n = 0;
     a26:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     a28:	0000b917          	auipc	s2,0xb
     a2c:	11890913          	addi	s2,s2,280 # bb40 <buf>
  if(fd < 0){
     a30:	06054263          	bltz	a0,a94 <writebig+0xea>
    i = read(fd, buf, BSIZE);
     a34:	40000613          	li	a2,1024
     a38:	85ca                	mv	a1,s2
     a3a:	854e                	mv	a0,s3
     a3c:	00005097          	auipc	ra,0x5
     a40:	c32080e7          	jalr	-974(ra) # 566e <read>
    if(i == 0){
     a44:	c535                	beqz	a0,ab0 <writebig+0x106>
    } else if(i != BSIZE){
     a46:	40000793          	li	a5,1024
     a4a:	0af51f63          	bne	a0,a5,b08 <writebig+0x15e>
    if(((int*)buf)[0] != n){
     a4e:	00092683          	lw	a3,0(s2)
     a52:	0c969a63          	bne	a3,s1,b26 <writebig+0x17c>
    n++;
     a56:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     a58:	bff1                	j	a34 <writebig+0x8a>
    printf("%s: error: creat big failed!\n", s);
     a5a:	85d6                	mv	a1,s5
     a5c:	00006517          	auipc	a0,0x6
     a60:	84c50513          	addi	a0,a0,-1972 # 62a8 <malloc+0x80c>
     a64:	00005097          	auipc	ra,0x5
     a68:	f7a080e7          	jalr	-134(ra) # 59de <printf>
    exit(1);
     a6c:	4505                	li	a0,1
     a6e:	00005097          	auipc	ra,0x5
     a72:	be8080e7          	jalr	-1048(ra) # 5656 <exit>
      printf("%s: error: write big file failed\n", s, i);
     a76:	8626                	mv	a2,s1
     a78:	85d6                	mv	a1,s5
     a7a:	00006517          	auipc	a0,0x6
     a7e:	84e50513          	addi	a0,a0,-1970 # 62c8 <malloc+0x82c>
     a82:	00005097          	auipc	ra,0x5
     a86:	f5c080e7          	jalr	-164(ra) # 59de <printf>
      exit(1);
     a8a:	4505                	li	a0,1
     a8c:	00005097          	auipc	ra,0x5
     a90:	bca080e7          	jalr	-1078(ra) # 5656 <exit>
    printf("%s: error: open big failed!\n", s);
     a94:	85d6                	mv	a1,s5
     a96:	00006517          	auipc	a0,0x6
     a9a:	85a50513          	addi	a0,a0,-1958 # 62f0 <malloc+0x854>
     a9e:	00005097          	auipc	ra,0x5
     aa2:	f40080e7          	jalr	-192(ra) # 59de <printf>
    exit(1);
     aa6:	4505                	li	a0,1
     aa8:	00005097          	auipc	ra,0x5
     aac:	bae080e7          	jalr	-1106(ra) # 5656 <exit>
      if(n == MAXFILE - 1){
     ab0:	10b00793          	li	a5,267
     ab4:	02f48a63          	beq	s1,a5,ae8 <writebig+0x13e>
  close(fd);
     ab8:	854e                	mv	a0,s3
     aba:	00005097          	auipc	ra,0x5
     abe:	bc4080e7          	jalr	-1084(ra) # 567e <close>
  if(unlink("big") < 0){
     ac2:	00005517          	auipc	a0,0x5
     ac6:	7de50513          	addi	a0,a0,2014 # 62a0 <malloc+0x804>
     aca:	00005097          	auipc	ra,0x5
     ace:	bdc080e7          	jalr	-1060(ra) # 56a6 <unlink>
     ad2:	06054963          	bltz	a0,b44 <writebig+0x19a>
}
     ad6:	70e2                	ld	ra,56(sp)
     ad8:	7442                	ld	s0,48(sp)
     ada:	74a2                	ld	s1,40(sp)
     adc:	7902                	ld	s2,32(sp)
     ade:	69e2                	ld	s3,24(sp)
     ae0:	6a42                	ld	s4,16(sp)
     ae2:	6aa2                	ld	s5,8(sp)
     ae4:	6121                	addi	sp,sp,64
     ae6:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     ae8:	10b00613          	li	a2,267
     aec:	85d6                	mv	a1,s5
     aee:	00006517          	auipc	a0,0x6
     af2:	82250513          	addi	a0,a0,-2014 # 6310 <malloc+0x874>
     af6:	00005097          	auipc	ra,0x5
     afa:	ee8080e7          	jalr	-280(ra) # 59de <printf>
        exit(1);
     afe:	4505                	li	a0,1
     b00:	00005097          	auipc	ra,0x5
     b04:	b56080e7          	jalr	-1194(ra) # 5656 <exit>
      printf("%s: read failed %d\n", s, i);
     b08:	862a                	mv	a2,a0
     b0a:	85d6                	mv	a1,s5
     b0c:	00006517          	auipc	a0,0x6
     b10:	82c50513          	addi	a0,a0,-2004 # 6338 <malloc+0x89c>
     b14:	00005097          	auipc	ra,0x5
     b18:	eca080e7          	jalr	-310(ra) # 59de <printf>
      exit(1);
     b1c:	4505                	li	a0,1
     b1e:	00005097          	auipc	ra,0x5
     b22:	b38080e7          	jalr	-1224(ra) # 5656 <exit>
      printf("%s: read content of block %d is %d\n", s,
     b26:	8626                	mv	a2,s1
     b28:	85d6                	mv	a1,s5
     b2a:	00006517          	auipc	a0,0x6
     b2e:	82650513          	addi	a0,a0,-2010 # 6350 <malloc+0x8b4>
     b32:	00005097          	auipc	ra,0x5
     b36:	eac080e7          	jalr	-340(ra) # 59de <printf>
      exit(1);
     b3a:	4505                	li	a0,1
     b3c:	00005097          	auipc	ra,0x5
     b40:	b1a080e7          	jalr	-1254(ra) # 5656 <exit>
    printf("%s: unlink big failed\n", s);
     b44:	85d6                	mv	a1,s5
     b46:	00006517          	auipc	a0,0x6
     b4a:	83250513          	addi	a0,a0,-1998 # 6378 <malloc+0x8dc>
     b4e:	00005097          	auipc	ra,0x5
     b52:	e90080e7          	jalr	-368(ra) # 59de <printf>
    exit(1);
     b56:	4505                	li	a0,1
     b58:	00005097          	auipc	ra,0x5
     b5c:	afe080e7          	jalr	-1282(ra) # 5656 <exit>

0000000000000b60 <unlinkread>:
{
     b60:	7179                	addi	sp,sp,-48
     b62:	f406                	sd	ra,40(sp)
     b64:	f022                	sd	s0,32(sp)
     b66:	ec26                	sd	s1,24(sp)
     b68:	e84a                	sd	s2,16(sp)
     b6a:	e44e                	sd	s3,8(sp)
     b6c:	1800                	addi	s0,sp,48
     b6e:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     b70:	20200593          	li	a1,514
     b74:	00005517          	auipc	a0,0x5
     b78:	16c50513          	addi	a0,a0,364 # 5ce0 <malloc+0x244>
     b7c:	00005097          	auipc	ra,0x5
     b80:	b1a080e7          	jalr	-1254(ra) # 5696 <open>
  if(fd < 0){
     b84:	0e054563          	bltz	a0,c6e <unlinkread+0x10e>
     b88:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     b8a:	4615                	li	a2,5
     b8c:	00006597          	auipc	a1,0x6
     b90:	82458593          	addi	a1,a1,-2012 # 63b0 <malloc+0x914>
     b94:	00005097          	auipc	ra,0x5
     b98:	ae2080e7          	jalr	-1310(ra) # 5676 <write>
  close(fd);
     b9c:	8526                	mv	a0,s1
     b9e:	00005097          	auipc	ra,0x5
     ba2:	ae0080e7          	jalr	-1312(ra) # 567e <close>
  fd = open("unlinkread", O_RDWR);
     ba6:	4589                	li	a1,2
     ba8:	00005517          	auipc	a0,0x5
     bac:	13850513          	addi	a0,a0,312 # 5ce0 <malloc+0x244>
     bb0:	00005097          	auipc	ra,0x5
     bb4:	ae6080e7          	jalr	-1306(ra) # 5696 <open>
     bb8:	84aa                	mv	s1,a0
  if(fd < 0){
     bba:	0c054863          	bltz	a0,c8a <unlinkread+0x12a>
  if(unlink("unlinkread") != 0){
     bbe:	00005517          	auipc	a0,0x5
     bc2:	12250513          	addi	a0,a0,290 # 5ce0 <malloc+0x244>
     bc6:	00005097          	auipc	ra,0x5
     bca:	ae0080e7          	jalr	-1312(ra) # 56a6 <unlink>
     bce:	ed61                	bnez	a0,ca6 <unlinkread+0x146>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     bd0:	20200593          	li	a1,514
     bd4:	00005517          	auipc	a0,0x5
     bd8:	10c50513          	addi	a0,a0,268 # 5ce0 <malloc+0x244>
     bdc:	00005097          	auipc	ra,0x5
     be0:	aba080e7          	jalr	-1350(ra) # 5696 <open>
     be4:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     be6:	460d                	li	a2,3
     be8:	00006597          	auipc	a1,0x6
     bec:	81058593          	addi	a1,a1,-2032 # 63f8 <malloc+0x95c>
     bf0:	00005097          	auipc	ra,0x5
     bf4:	a86080e7          	jalr	-1402(ra) # 5676 <write>
  close(fd1);
     bf8:	854a                	mv	a0,s2
     bfa:	00005097          	auipc	ra,0x5
     bfe:	a84080e7          	jalr	-1404(ra) # 567e <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     c02:	660d                	lui	a2,0x3
     c04:	0000b597          	auipc	a1,0xb
     c08:	f3c58593          	addi	a1,a1,-196 # bb40 <buf>
     c0c:	8526                	mv	a0,s1
     c0e:	00005097          	auipc	ra,0x5
     c12:	a60080e7          	jalr	-1440(ra) # 566e <read>
     c16:	4795                	li	a5,5
     c18:	0af51563          	bne	a0,a5,cc2 <unlinkread+0x162>
  if(buf[0] != 'h'){
     c1c:	0000b717          	auipc	a4,0xb
     c20:	f2474703          	lbu	a4,-220(a4) # bb40 <buf>
     c24:	06800793          	li	a5,104
     c28:	0af71b63          	bne	a4,a5,cde <unlinkread+0x17e>
  if(write(fd, buf, 10) != 10){
     c2c:	4629                	li	a2,10
     c2e:	0000b597          	auipc	a1,0xb
     c32:	f1258593          	addi	a1,a1,-238 # bb40 <buf>
     c36:	8526                	mv	a0,s1
     c38:	00005097          	auipc	ra,0x5
     c3c:	a3e080e7          	jalr	-1474(ra) # 5676 <write>
     c40:	47a9                	li	a5,10
     c42:	0af51c63          	bne	a0,a5,cfa <unlinkread+0x19a>
  close(fd);
     c46:	8526                	mv	a0,s1
     c48:	00005097          	auipc	ra,0x5
     c4c:	a36080e7          	jalr	-1482(ra) # 567e <close>
  unlink("unlinkread");
     c50:	00005517          	auipc	a0,0x5
     c54:	09050513          	addi	a0,a0,144 # 5ce0 <malloc+0x244>
     c58:	00005097          	auipc	ra,0x5
     c5c:	a4e080e7          	jalr	-1458(ra) # 56a6 <unlink>
}
     c60:	70a2                	ld	ra,40(sp)
     c62:	7402                	ld	s0,32(sp)
     c64:	64e2                	ld	s1,24(sp)
     c66:	6942                	ld	s2,16(sp)
     c68:	69a2                	ld	s3,8(sp)
     c6a:	6145                	addi	sp,sp,48
     c6c:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     c6e:	85ce                	mv	a1,s3
     c70:	00005517          	auipc	a0,0x5
     c74:	72050513          	addi	a0,a0,1824 # 6390 <malloc+0x8f4>
     c78:	00005097          	auipc	ra,0x5
     c7c:	d66080e7          	jalr	-666(ra) # 59de <printf>
    exit(1);
     c80:	4505                	li	a0,1
     c82:	00005097          	auipc	ra,0x5
     c86:	9d4080e7          	jalr	-1580(ra) # 5656 <exit>
    printf("%s: open unlinkread failed\n", s);
     c8a:	85ce                	mv	a1,s3
     c8c:	00005517          	auipc	a0,0x5
     c90:	72c50513          	addi	a0,a0,1836 # 63b8 <malloc+0x91c>
     c94:	00005097          	auipc	ra,0x5
     c98:	d4a080e7          	jalr	-694(ra) # 59de <printf>
    exit(1);
     c9c:	4505                	li	a0,1
     c9e:	00005097          	auipc	ra,0x5
     ca2:	9b8080e7          	jalr	-1608(ra) # 5656 <exit>
    printf("%s: unlink unlinkread failed\n", s);
     ca6:	85ce                	mv	a1,s3
     ca8:	00005517          	auipc	a0,0x5
     cac:	73050513          	addi	a0,a0,1840 # 63d8 <malloc+0x93c>
     cb0:	00005097          	auipc	ra,0x5
     cb4:	d2e080e7          	jalr	-722(ra) # 59de <printf>
    exit(1);
     cb8:	4505                	li	a0,1
     cba:	00005097          	auipc	ra,0x5
     cbe:	99c080e7          	jalr	-1636(ra) # 5656 <exit>
    printf("%s: unlinkread read failed", s);
     cc2:	85ce                	mv	a1,s3
     cc4:	00005517          	auipc	a0,0x5
     cc8:	73c50513          	addi	a0,a0,1852 # 6400 <malloc+0x964>
     ccc:	00005097          	auipc	ra,0x5
     cd0:	d12080e7          	jalr	-750(ra) # 59de <printf>
    exit(1);
     cd4:	4505                	li	a0,1
     cd6:	00005097          	auipc	ra,0x5
     cda:	980080e7          	jalr	-1664(ra) # 5656 <exit>
    printf("%s: unlinkread wrong data\n", s);
     cde:	85ce                	mv	a1,s3
     ce0:	00005517          	auipc	a0,0x5
     ce4:	74050513          	addi	a0,a0,1856 # 6420 <malloc+0x984>
     ce8:	00005097          	auipc	ra,0x5
     cec:	cf6080e7          	jalr	-778(ra) # 59de <printf>
    exit(1);
     cf0:	4505                	li	a0,1
     cf2:	00005097          	auipc	ra,0x5
     cf6:	964080e7          	jalr	-1692(ra) # 5656 <exit>
    printf("%s: unlinkread write failed\n", s);
     cfa:	85ce                	mv	a1,s3
     cfc:	00005517          	auipc	a0,0x5
     d00:	74450513          	addi	a0,a0,1860 # 6440 <malloc+0x9a4>
     d04:	00005097          	auipc	ra,0x5
     d08:	cda080e7          	jalr	-806(ra) # 59de <printf>
    exit(1);
     d0c:	4505                	li	a0,1
     d0e:	00005097          	auipc	ra,0x5
     d12:	948080e7          	jalr	-1720(ra) # 5656 <exit>

0000000000000d16 <linktest>:
{
     d16:	1101                	addi	sp,sp,-32
     d18:	ec06                	sd	ra,24(sp)
     d1a:	e822                	sd	s0,16(sp)
     d1c:	e426                	sd	s1,8(sp)
     d1e:	e04a                	sd	s2,0(sp)
     d20:	1000                	addi	s0,sp,32
     d22:	892a                	mv	s2,a0
  unlink("lf1");
     d24:	00005517          	auipc	a0,0x5
     d28:	73c50513          	addi	a0,a0,1852 # 6460 <malloc+0x9c4>
     d2c:	00005097          	auipc	ra,0x5
     d30:	97a080e7          	jalr	-1670(ra) # 56a6 <unlink>
  unlink("lf2");
     d34:	00005517          	auipc	a0,0x5
     d38:	73450513          	addi	a0,a0,1844 # 6468 <malloc+0x9cc>
     d3c:	00005097          	auipc	ra,0x5
     d40:	96a080e7          	jalr	-1686(ra) # 56a6 <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
     d44:	20200593          	li	a1,514
     d48:	00005517          	auipc	a0,0x5
     d4c:	71850513          	addi	a0,a0,1816 # 6460 <malloc+0x9c4>
     d50:	00005097          	auipc	ra,0x5
     d54:	946080e7          	jalr	-1722(ra) # 5696 <open>
  if(fd < 0){
     d58:	10054763          	bltz	a0,e66 <linktest+0x150>
     d5c:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
     d5e:	4615                	li	a2,5
     d60:	00005597          	auipc	a1,0x5
     d64:	65058593          	addi	a1,a1,1616 # 63b0 <malloc+0x914>
     d68:	00005097          	auipc	ra,0x5
     d6c:	90e080e7          	jalr	-1778(ra) # 5676 <write>
     d70:	4795                	li	a5,5
     d72:	10f51863          	bne	a0,a5,e82 <linktest+0x16c>
  close(fd);
     d76:	8526                	mv	a0,s1
     d78:	00005097          	auipc	ra,0x5
     d7c:	906080e7          	jalr	-1786(ra) # 567e <close>
  if(link("lf1", "lf2") < 0){
     d80:	00005597          	auipc	a1,0x5
     d84:	6e858593          	addi	a1,a1,1768 # 6468 <malloc+0x9cc>
     d88:	00005517          	auipc	a0,0x5
     d8c:	6d850513          	addi	a0,a0,1752 # 6460 <malloc+0x9c4>
     d90:	00005097          	auipc	ra,0x5
     d94:	926080e7          	jalr	-1754(ra) # 56b6 <link>
     d98:	10054363          	bltz	a0,e9e <linktest+0x188>
  unlink("lf1");
     d9c:	00005517          	auipc	a0,0x5
     da0:	6c450513          	addi	a0,a0,1732 # 6460 <malloc+0x9c4>
     da4:	00005097          	auipc	ra,0x5
     da8:	902080e7          	jalr	-1790(ra) # 56a6 <unlink>
  if(open("lf1", 0) >= 0){
     dac:	4581                	li	a1,0
     dae:	00005517          	auipc	a0,0x5
     db2:	6b250513          	addi	a0,a0,1714 # 6460 <malloc+0x9c4>
     db6:	00005097          	auipc	ra,0x5
     dba:	8e0080e7          	jalr	-1824(ra) # 5696 <open>
     dbe:	0e055e63          	bgez	a0,eba <linktest+0x1a4>
  fd = open("lf2", 0);
     dc2:	4581                	li	a1,0
     dc4:	00005517          	auipc	a0,0x5
     dc8:	6a450513          	addi	a0,a0,1700 # 6468 <malloc+0x9cc>
     dcc:	00005097          	auipc	ra,0x5
     dd0:	8ca080e7          	jalr	-1846(ra) # 5696 <open>
     dd4:	84aa                	mv	s1,a0
  if(fd < 0){
     dd6:	10054063          	bltz	a0,ed6 <linktest+0x1c0>
  if(read(fd, buf, sizeof(buf)) != SZ){
     dda:	660d                	lui	a2,0x3
     ddc:	0000b597          	auipc	a1,0xb
     de0:	d6458593          	addi	a1,a1,-668 # bb40 <buf>
     de4:	00005097          	auipc	ra,0x5
     de8:	88a080e7          	jalr	-1910(ra) # 566e <read>
     dec:	4795                	li	a5,5
     dee:	10f51263          	bne	a0,a5,ef2 <linktest+0x1dc>
  close(fd);
     df2:	8526                	mv	a0,s1
     df4:	00005097          	auipc	ra,0x5
     df8:	88a080e7          	jalr	-1910(ra) # 567e <close>
  if(link("lf2", "lf2") >= 0){
     dfc:	00005597          	auipc	a1,0x5
     e00:	66c58593          	addi	a1,a1,1644 # 6468 <malloc+0x9cc>
     e04:	852e                	mv	a0,a1
     e06:	00005097          	auipc	ra,0x5
     e0a:	8b0080e7          	jalr	-1872(ra) # 56b6 <link>
     e0e:	10055063          	bgez	a0,f0e <linktest+0x1f8>
  unlink("lf2");
     e12:	00005517          	auipc	a0,0x5
     e16:	65650513          	addi	a0,a0,1622 # 6468 <malloc+0x9cc>
     e1a:	00005097          	auipc	ra,0x5
     e1e:	88c080e7          	jalr	-1908(ra) # 56a6 <unlink>
  if(link("lf2", "lf1") >= 0){
     e22:	00005597          	auipc	a1,0x5
     e26:	63e58593          	addi	a1,a1,1598 # 6460 <malloc+0x9c4>
     e2a:	00005517          	auipc	a0,0x5
     e2e:	63e50513          	addi	a0,a0,1598 # 6468 <malloc+0x9cc>
     e32:	00005097          	auipc	ra,0x5
     e36:	884080e7          	jalr	-1916(ra) # 56b6 <link>
     e3a:	0e055863          	bgez	a0,f2a <linktest+0x214>
  if(link(".", "lf1") >= 0){
     e3e:	00005597          	auipc	a1,0x5
     e42:	62258593          	addi	a1,a1,1570 # 6460 <malloc+0x9c4>
     e46:	00005517          	auipc	a0,0x5
     e4a:	72a50513          	addi	a0,a0,1834 # 6570 <malloc+0xad4>
     e4e:	00005097          	auipc	ra,0x5
     e52:	868080e7          	jalr	-1944(ra) # 56b6 <link>
     e56:	0e055863          	bgez	a0,f46 <linktest+0x230>
}
     e5a:	60e2                	ld	ra,24(sp)
     e5c:	6442                	ld	s0,16(sp)
     e5e:	64a2                	ld	s1,8(sp)
     e60:	6902                	ld	s2,0(sp)
     e62:	6105                	addi	sp,sp,32
     e64:	8082                	ret
    printf("%s: create lf1 failed\n", s);
     e66:	85ca                	mv	a1,s2
     e68:	00005517          	auipc	a0,0x5
     e6c:	60850513          	addi	a0,a0,1544 # 6470 <malloc+0x9d4>
     e70:	00005097          	auipc	ra,0x5
     e74:	b6e080e7          	jalr	-1170(ra) # 59de <printf>
    exit(1);
     e78:	4505                	li	a0,1
     e7a:	00004097          	auipc	ra,0x4
     e7e:	7dc080e7          	jalr	2012(ra) # 5656 <exit>
    printf("%s: write lf1 failed\n", s);
     e82:	85ca                	mv	a1,s2
     e84:	00005517          	auipc	a0,0x5
     e88:	60450513          	addi	a0,a0,1540 # 6488 <malloc+0x9ec>
     e8c:	00005097          	auipc	ra,0x5
     e90:	b52080e7          	jalr	-1198(ra) # 59de <printf>
    exit(1);
     e94:	4505                	li	a0,1
     e96:	00004097          	auipc	ra,0x4
     e9a:	7c0080e7          	jalr	1984(ra) # 5656 <exit>
    printf("%s: link lf1 lf2 failed\n", s);
     e9e:	85ca                	mv	a1,s2
     ea0:	00005517          	auipc	a0,0x5
     ea4:	60050513          	addi	a0,a0,1536 # 64a0 <malloc+0xa04>
     ea8:	00005097          	auipc	ra,0x5
     eac:	b36080e7          	jalr	-1226(ra) # 59de <printf>
    exit(1);
     eb0:	4505                	li	a0,1
     eb2:	00004097          	auipc	ra,0x4
     eb6:	7a4080e7          	jalr	1956(ra) # 5656 <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
     eba:	85ca                	mv	a1,s2
     ebc:	00005517          	auipc	a0,0x5
     ec0:	60450513          	addi	a0,a0,1540 # 64c0 <malloc+0xa24>
     ec4:	00005097          	auipc	ra,0x5
     ec8:	b1a080e7          	jalr	-1254(ra) # 59de <printf>
    exit(1);
     ecc:	4505                	li	a0,1
     ece:	00004097          	auipc	ra,0x4
     ed2:	788080e7          	jalr	1928(ra) # 5656 <exit>
    printf("%s: open lf2 failed\n", s);
     ed6:	85ca                	mv	a1,s2
     ed8:	00005517          	auipc	a0,0x5
     edc:	61850513          	addi	a0,a0,1560 # 64f0 <malloc+0xa54>
     ee0:	00005097          	auipc	ra,0x5
     ee4:	afe080e7          	jalr	-1282(ra) # 59de <printf>
    exit(1);
     ee8:	4505                	li	a0,1
     eea:	00004097          	auipc	ra,0x4
     eee:	76c080e7          	jalr	1900(ra) # 5656 <exit>
    printf("%s: read lf2 failed\n", s);
     ef2:	85ca                	mv	a1,s2
     ef4:	00005517          	auipc	a0,0x5
     ef8:	61450513          	addi	a0,a0,1556 # 6508 <malloc+0xa6c>
     efc:	00005097          	auipc	ra,0x5
     f00:	ae2080e7          	jalr	-1310(ra) # 59de <printf>
    exit(1);
     f04:	4505                	li	a0,1
     f06:	00004097          	auipc	ra,0x4
     f0a:	750080e7          	jalr	1872(ra) # 5656 <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
     f0e:	85ca                	mv	a1,s2
     f10:	00005517          	auipc	a0,0x5
     f14:	61050513          	addi	a0,a0,1552 # 6520 <malloc+0xa84>
     f18:	00005097          	auipc	ra,0x5
     f1c:	ac6080e7          	jalr	-1338(ra) # 59de <printf>
    exit(1);
     f20:	4505                	li	a0,1
     f22:	00004097          	auipc	ra,0x4
     f26:	734080e7          	jalr	1844(ra) # 5656 <exit>
    printf("%s: link non-existant succeeded! oops\n", s);
     f2a:	85ca                	mv	a1,s2
     f2c:	00005517          	auipc	a0,0x5
     f30:	61c50513          	addi	a0,a0,1564 # 6548 <malloc+0xaac>
     f34:	00005097          	auipc	ra,0x5
     f38:	aaa080e7          	jalr	-1366(ra) # 59de <printf>
    exit(1);
     f3c:	4505                	li	a0,1
     f3e:	00004097          	auipc	ra,0x4
     f42:	718080e7          	jalr	1816(ra) # 5656 <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
     f46:	85ca                	mv	a1,s2
     f48:	00005517          	auipc	a0,0x5
     f4c:	63050513          	addi	a0,a0,1584 # 6578 <malloc+0xadc>
     f50:	00005097          	auipc	ra,0x5
     f54:	a8e080e7          	jalr	-1394(ra) # 59de <printf>
    exit(1);
     f58:	4505                	li	a0,1
     f5a:	00004097          	auipc	ra,0x4
     f5e:	6fc080e7          	jalr	1788(ra) # 5656 <exit>

0000000000000f62 <bigdir>:
{
     f62:	715d                	addi	sp,sp,-80
     f64:	e486                	sd	ra,72(sp)
     f66:	e0a2                	sd	s0,64(sp)
     f68:	fc26                	sd	s1,56(sp)
     f6a:	f84a                	sd	s2,48(sp)
     f6c:	f44e                	sd	s3,40(sp)
     f6e:	f052                	sd	s4,32(sp)
     f70:	ec56                	sd	s5,24(sp)
     f72:	e85a                	sd	s6,16(sp)
     f74:	0880                	addi	s0,sp,80
     f76:	89aa                	mv	s3,a0
  unlink("bd");
     f78:	00005517          	auipc	a0,0x5
     f7c:	62050513          	addi	a0,a0,1568 # 6598 <malloc+0xafc>
     f80:	00004097          	auipc	ra,0x4
     f84:	726080e7          	jalr	1830(ra) # 56a6 <unlink>
  fd = open("bd", O_CREATE);
     f88:	20000593          	li	a1,512
     f8c:	00005517          	auipc	a0,0x5
     f90:	60c50513          	addi	a0,a0,1548 # 6598 <malloc+0xafc>
     f94:	00004097          	auipc	ra,0x4
     f98:	702080e7          	jalr	1794(ra) # 5696 <open>
  if(fd < 0){
     f9c:	0c054963          	bltz	a0,106e <bigdir+0x10c>
  close(fd);
     fa0:	00004097          	auipc	ra,0x4
     fa4:	6de080e7          	jalr	1758(ra) # 567e <close>
  for(i = 0; i < N; i++){
     fa8:	4901                	li	s2,0
    name[0] = 'x';
     faa:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
     fae:	00005a17          	auipc	s4,0x5
     fb2:	5eaa0a13          	addi	s4,s4,1514 # 6598 <malloc+0xafc>
  for(i = 0; i < N; i++){
     fb6:	1f400b13          	li	s6,500
    name[0] = 'x';
     fba:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
     fbe:	41f9579b          	sraiw	a5,s2,0x1f
     fc2:	01a7d71b          	srliw	a4,a5,0x1a
     fc6:	012707bb          	addw	a5,a4,s2
     fca:	4067d69b          	sraiw	a3,a5,0x6
     fce:	0306869b          	addiw	a3,a3,48
     fd2:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
     fd6:	03f7f793          	andi	a5,a5,63
     fda:	9f99                	subw	a5,a5,a4
     fdc:	0307879b          	addiw	a5,a5,48
     fe0:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
     fe4:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
     fe8:	fb040593          	addi	a1,s0,-80
     fec:	8552                	mv	a0,s4
     fee:	00004097          	auipc	ra,0x4
     ff2:	6c8080e7          	jalr	1736(ra) # 56b6 <link>
     ff6:	84aa                	mv	s1,a0
     ff8:	e949                	bnez	a0,108a <bigdir+0x128>
  for(i = 0; i < N; i++){
     ffa:	2905                	addiw	s2,s2,1
     ffc:	fb691fe3          	bne	s2,s6,fba <bigdir+0x58>
  unlink("bd");
    1000:	00005517          	auipc	a0,0x5
    1004:	59850513          	addi	a0,a0,1432 # 6598 <malloc+0xafc>
    1008:	00004097          	auipc	ra,0x4
    100c:	69e080e7          	jalr	1694(ra) # 56a6 <unlink>
    name[0] = 'x';
    1010:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
    1014:	1f400a13          	li	s4,500
    name[0] = 'x';
    1018:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
    101c:	41f4d79b          	sraiw	a5,s1,0x1f
    1020:	01a7d71b          	srliw	a4,a5,0x1a
    1024:	009707bb          	addw	a5,a4,s1
    1028:	4067d69b          	sraiw	a3,a5,0x6
    102c:	0306869b          	addiw	a3,a3,48
    1030:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    1034:	03f7f793          	andi	a5,a5,63
    1038:	9f99                	subw	a5,a5,a4
    103a:	0307879b          	addiw	a5,a5,48
    103e:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    1042:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
    1046:	fb040513          	addi	a0,s0,-80
    104a:	00004097          	auipc	ra,0x4
    104e:	65c080e7          	jalr	1628(ra) # 56a6 <unlink>
    1052:	ed21                	bnez	a0,10aa <bigdir+0x148>
  for(i = 0; i < N; i++){
    1054:	2485                	addiw	s1,s1,1
    1056:	fd4491e3          	bne	s1,s4,1018 <bigdir+0xb6>
}
    105a:	60a6                	ld	ra,72(sp)
    105c:	6406                	ld	s0,64(sp)
    105e:	74e2                	ld	s1,56(sp)
    1060:	7942                	ld	s2,48(sp)
    1062:	79a2                	ld	s3,40(sp)
    1064:	7a02                	ld	s4,32(sp)
    1066:	6ae2                	ld	s5,24(sp)
    1068:	6b42                	ld	s6,16(sp)
    106a:	6161                	addi	sp,sp,80
    106c:	8082                	ret
    printf("%s: bigdir create failed\n", s);
    106e:	85ce                	mv	a1,s3
    1070:	00005517          	auipc	a0,0x5
    1074:	53050513          	addi	a0,a0,1328 # 65a0 <malloc+0xb04>
    1078:	00005097          	auipc	ra,0x5
    107c:	966080e7          	jalr	-1690(ra) # 59de <printf>
    exit(1);
    1080:	4505                	li	a0,1
    1082:	00004097          	auipc	ra,0x4
    1086:	5d4080e7          	jalr	1492(ra) # 5656 <exit>
      printf("%s: bigdir link(bd, %s) failed\n", s, name);
    108a:	fb040613          	addi	a2,s0,-80
    108e:	85ce                	mv	a1,s3
    1090:	00005517          	auipc	a0,0x5
    1094:	53050513          	addi	a0,a0,1328 # 65c0 <malloc+0xb24>
    1098:	00005097          	auipc	ra,0x5
    109c:	946080e7          	jalr	-1722(ra) # 59de <printf>
      exit(1);
    10a0:	4505                	li	a0,1
    10a2:	00004097          	auipc	ra,0x4
    10a6:	5b4080e7          	jalr	1460(ra) # 5656 <exit>
      printf("%s: bigdir unlink failed", s);
    10aa:	85ce                	mv	a1,s3
    10ac:	00005517          	auipc	a0,0x5
    10b0:	53450513          	addi	a0,a0,1332 # 65e0 <malloc+0xb44>
    10b4:	00005097          	auipc	ra,0x5
    10b8:	92a080e7          	jalr	-1750(ra) # 59de <printf>
      exit(1);
    10bc:	4505                	li	a0,1
    10be:	00004097          	auipc	ra,0x4
    10c2:	598080e7          	jalr	1432(ra) # 5656 <exit>

00000000000010c6 <validatetest>:
{
    10c6:	7139                	addi	sp,sp,-64
    10c8:	fc06                	sd	ra,56(sp)
    10ca:	f822                	sd	s0,48(sp)
    10cc:	f426                	sd	s1,40(sp)
    10ce:	f04a                	sd	s2,32(sp)
    10d0:	ec4e                	sd	s3,24(sp)
    10d2:	e852                	sd	s4,16(sp)
    10d4:	e456                	sd	s5,8(sp)
    10d6:	e05a                	sd	s6,0(sp)
    10d8:	0080                	addi	s0,sp,64
    10da:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    10dc:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
    10de:	00005997          	auipc	s3,0x5
    10e2:	52298993          	addi	s3,s3,1314 # 6600 <malloc+0xb64>
    10e6:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    10e8:	6a85                	lui	s5,0x1
    10ea:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
    10ee:	85a6                	mv	a1,s1
    10f0:	854e                	mv	a0,s3
    10f2:	00004097          	auipc	ra,0x4
    10f6:	5c4080e7          	jalr	1476(ra) # 56b6 <link>
    10fa:	01251f63          	bne	a0,s2,1118 <validatetest+0x52>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    10fe:	94d6                	add	s1,s1,s5
    1100:	ff4497e3          	bne	s1,s4,10ee <validatetest+0x28>
}
    1104:	70e2                	ld	ra,56(sp)
    1106:	7442                	ld	s0,48(sp)
    1108:	74a2                	ld	s1,40(sp)
    110a:	7902                	ld	s2,32(sp)
    110c:	69e2                	ld	s3,24(sp)
    110e:	6a42                	ld	s4,16(sp)
    1110:	6aa2                	ld	s5,8(sp)
    1112:	6b02                	ld	s6,0(sp)
    1114:	6121                	addi	sp,sp,64
    1116:	8082                	ret
      printf("%s: link should not succeed\n", s);
    1118:	85da                	mv	a1,s6
    111a:	00005517          	auipc	a0,0x5
    111e:	4f650513          	addi	a0,a0,1270 # 6610 <malloc+0xb74>
    1122:	00005097          	auipc	ra,0x5
    1126:	8bc080e7          	jalr	-1860(ra) # 59de <printf>
      exit(1);
    112a:	4505                	li	a0,1
    112c:	00004097          	auipc	ra,0x4
    1130:	52a080e7          	jalr	1322(ra) # 5656 <exit>

0000000000001134 <pgbug>:
// regression test. copyin(), copyout(), and copyinstr() used to cast
// the virtual page address to uint, which (with certain wild system
// call arguments) resulted in a kernel page faults.
void
pgbug(char *s)
{
    1134:	7179                	addi	sp,sp,-48
    1136:	f406                	sd	ra,40(sp)
    1138:	f022                	sd	s0,32(sp)
    113a:	ec26                	sd	s1,24(sp)
    113c:	1800                	addi	s0,sp,48
  char *argv[1];
  argv[0] = 0;
    113e:	fc043c23          	sd	zero,-40(s0)
  exec((char*)0xeaeb0b5b00002f5e, argv);
    1142:	00007497          	auipc	s1,0x7
    1146:	1ce4b483          	ld	s1,462(s1) # 8310 <__SDATA_BEGIN__>
    114a:	fd840593          	addi	a1,s0,-40
    114e:	8526                	mv	a0,s1
    1150:	00004097          	auipc	ra,0x4
    1154:	53e080e7          	jalr	1342(ra) # 568e <exec>

  pipe((int*)0xeaeb0b5b00002f5e);
    1158:	8526                	mv	a0,s1
    115a:	00004097          	auipc	ra,0x4
    115e:	50c080e7          	jalr	1292(ra) # 5666 <pipe>

  exit(0);
    1162:	4501                	li	a0,0
    1164:	00004097          	auipc	ra,0x4
    1168:	4f2080e7          	jalr	1266(ra) # 5656 <exit>

000000000000116c <badarg>:

// regression test. test whether exec() leaks memory if one of the
// arguments is invalid. the test passes if the kernel doesn't panic.
void
badarg(char *s)
{
    116c:	7139                	addi	sp,sp,-64
    116e:	fc06                	sd	ra,56(sp)
    1170:	f822                	sd	s0,48(sp)
    1172:	f426                	sd	s1,40(sp)
    1174:	f04a                	sd	s2,32(sp)
    1176:	ec4e                	sd	s3,24(sp)
    1178:	0080                	addi	s0,sp,64
    117a:	64b1                	lui	s1,0xc
    117c:	35048493          	addi	s1,s1,848 # c350 <buf+0x810>
  for(int i = 0; i < 50000; i++){
    char *argv[2];
    argv[0] = (char*)0xffffffff;
    1180:	597d                	li	s2,-1
    1182:	02095913          	srli	s2,s2,0x20
    argv[1] = 0;
    exec("echo", argv);
    1186:	00005997          	auipc	s3,0x5
    118a:	d5298993          	addi	s3,s3,-686 # 5ed8 <malloc+0x43c>
    argv[0] = (char*)0xffffffff;
    118e:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    1192:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    1196:	fc040593          	addi	a1,s0,-64
    119a:	854e                	mv	a0,s3
    119c:	00004097          	auipc	ra,0x4
    11a0:	4f2080e7          	jalr	1266(ra) # 568e <exec>
  for(int i = 0; i < 50000; i++){
    11a4:	34fd                	addiw	s1,s1,-1
    11a6:	f4e5                	bnez	s1,118e <badarg+0x22>
  }
  
  exit(0);
    11a8:	4501                	li	a0,0
    11aa:	00004097          	auipc	ra,0x4
    11ae:	4ac080e7          	jalr	1196(ra) # 5656 <exit>

00000000000011b2 <copyinstr2>:
{
    11b2:	7155                	addi	sp,sp,-208
    11b4:	e586                	sd	ra,200(sp)
    11b6:	e1a2                	sd	s0,192(sp)
    11b8:	0980                	addi	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    11ba:	f6840793          	addi	a5,s0,-152
    11be:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    11c2:	07800713          	li	a4,120
    11c6:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    11ca:	0785                	addi	a5,a5,1
    11cc:	fed79de3          	bne	a5,a3,11c6 <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    11d0:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    11d4:	f6840513          	addi	a0,s0,-152
    11d8:	00004097          	auipc	ra,0x4
    11dc:	4ce080e7          	jalr	1230(ra) # 56a6 <unlink>
  if(ret != -1){
    11e0:	57fd                	li	a5,-1
    11e2:	0ef51063          	bne	a0,a5,12c2 <copyinstr2+0x110>
  int fd = open(b, O_CREATE | O_WRONLY);
    11e6:	20100593          	li	a1,513
    11ea:	f6840513          	addi	a0,s0,-152
    11ee:	00004097          	auipc	ra,0x4
    11f2:	4a8080e7          	jalr	1192(ra) # 5696 <open>
  if(fd != -1){
    11f6:	57fd                	li	a5,-1
    11f8:	0ef51563          	bne	a0,a5,12e2 <copyinstr2+0x130>
  ret = link(b, b);
    11fc:	f6840593          	addi	a1,s0,-152
    1200:	852e                	mv	a0,a1
    1202:	00004097          	auipc	ra,0x4
    1206:	4b4080e7          	jalr	1204(ra) # 56b6 <link>
  if(ret != -1){
    120a:	57fd                	li	a5,-1
    120c:	0ef51b63          	bne	a0,a5,1302 <copyinstr2+0x150>
  char *args[] = { "xx", 0 };
    1210:	00006797          	auipc	a5,0x6
    1214:	5d078793          	addi	a5,a5,1488 # 77e0 <malloc+0x1d44>
    1218:	f4f43c23          	sd	a5,-168(s0)
    121c:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    1220:	f5840593          	addi	a1,s0,-168
    1224:	f6840513          	addi	a0,s0,-152
    1228:	00004097          	auipc	ra,0x4
    122c:	466080e7          	jalr	1126(ra) # 568e <exec>
  if(ret != -1){
    1230:	57fd                	li	a5,-1
    1232:	0ef51963          	bne	a0,a5,1324 <copyinstr2+0x172>
  int pid = fork();
    1236:	00004097          	auipc	ra,0x4
    123a:	418080e7          	jalr	1048(ra) # 564e <fork>
  if(pid < 0){
    123e:	10054363          	bltz	a0,1344 <copyinstr2+0x192>
  if(pid == 0){
    1242:	12051463          	bnez	a0,136a <copyinstr2+0x1b8>
    1246:	00007797          	auipc	a5,0x7
    124a:	1e278793          	addi	a5,a5,482 # 8428 <big.1274>
    124e:	00008697          	auipc	a3,0x8
    1252:	1da68693          	addi	a3,a3,474 # 9428 <__global_pointer$+0x918>
      big[i] = 'x';
    1256:	07800713          	li	a4,120
    125a:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    125e:	0785                	addi	a5,a5,1
    1260:	fed79de3          	bne	a5,a3,125a <copyinstr2+0xa8>
    big[PGSIZE] = '\0';
    1264:	00008797          	auipc	a5,0x8
    1268:	1c078223          	sb	zero,452(a5) # 9428 <__global_pointer$+0x918>
    char *args2[] = { big, big, big, 0 };
    126c:	00007797          	auipc	a5,0x7
    1270:	cb478793          	addi	a5,a5,-844 # 7f20 <malloc+0x2484>
    1274:	6390                	ld	a2,0(a5)
    1276:	6794                	ld	a3,8(a5)
    1278:	6b98                	ld	a4,16(a5)
    127a:	6f9c                	ld	a5,24(a5)
    127c:	f2c43823          	sd	a2,-208(s0)
    1280:	f2d43c23          	sd	a3,-200(s0)
    1284:	f4e43023          	sd	a4,-192(s0)
    1288:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    128c:	f3040593          	addi	a1,s0,-208
    1290:	00005517          	auipc	a0,0x5
    1294:	c4850513          	addi	a0,a0,-952 # 5ed8 <malloc+0x43c>
    1298:	00004097          	auipc	ra,0x4
    129c:	3f6080e7          	jalr	1014(ra) # 568e <exec>
    if(ret != -1){
    12a0:	57fd                	li	a5,-1
    12a2:	0af50e63          	beq	a0,a5,135e <copyinstr2+0x1ac>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    12a6:	55fd                	li	a1,-1
    12a8:	00005517          	auipc	a0,0x5
    12ac:	41050513          	addi	a0,a0,1040 # 66b8 <malloc+0xc1c>
    12b0:	00004097          	auipc	ra,0x4
    12b4:	72e080e7          	jalr	1838(ra) # 59de <printf>
      exit(1);
    12b8:	4505                	li	a0,1
    12ba:	00004097          	auipc	ra,0x4
    12be:	39c080e7          	jalr	924(ra) # 5656 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    12c2:	862a                	mv	a2,a0
    12c4:	f6840593          	addi	a1,s0,-152
    12c8:	00005517          	auipc	a0,0x5
    12cc:	36850513          	addi	a0,a0,872 # 6630 <malloc+0xb94>
    12d0:	00004097          	auipc	ra,0x4
    12d4:	70e080e7          	jalr	1806(ra) # 59de <printf>
    exit(1);
    12d8:	4505                	li	a0,1
    12da:	00004097          	auipc	ra,0x4
    12de:	37c080e7          	jalr	892(ra) # 5656 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    12e2:	862a                	mv	a2,a0
    12e4:	f6840593          	addi	a1,s0,-152
    12e8:	00005517          	auipc	a0,0x5
    12ec:	36850513          	addi	a0,a0,872 # 6650 <malloc+0xbb4>
    12f0:	00004097          	auipc	ra,0x4
    12f4:	6ee080e7          	jalr	1774(ra) # 59de <printf>
    exit(1);
    12f8:	4505                	li	a0,1
    12fa:	00004097          	auipc	ra,0x4
    12fe:	35c080e7          	jalr	860(ra) # 5656 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    1302:	86aa                	mv	a3,a0
    1304:	f6840613          	addi	a2,s0,-152
    1308:	85b2                	mv	a1,a2
    130a:	00005517          	auipc	a0,0x5
    130e:	36650513          	addi	a0,a0,870 # 6670 <malloc+0xbd4>
    1312:	00004097          	auipc	ra,0x4
    1316:	6cc080e7          	jalr	1740(ra) # 59de <printf>
    exit(1);
    131a:	4505                	li	a0,1
    131c:	00004097          	auipc	ra,0x4
    1320:	33a080e7          	jalr	826(ra) # 5656 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    1324:	567d                	li	a2,-1
    1326:	f6840593          	addi	a1,s0,-152
    132a:	00005517          	auipc	a0,0x5
    132e:	36e50513          	addi	a0,a0,878 # 6698 <malloc+0xbfc>
    1332:	00004097          	auipc	ra,0x4
    1336:	6ac080e7          	jalr	1708(ra) # 59de <printf>
    exit(1);
    133a:	4505                	li	a0,1
    133c:	00004097          	auipc	ra,0x4
    1340:	31a080e7          	jalr	794(ra) # 5656 <exit>
    printf("fork failed\n");
    1344:	00005517          	auipc	a0,0x5
    1348:	7d450513          	addi	a0,a0,2004 # 6b18 <malloc+0x107c>
    134c:	00004097          	auipc	ra,0x4
    1350:	692080e7          	jalr	1682(ra) # 59de <printf>
    exit(1);
    1354:	4505                	li	a0,1
    1356:	00004097          	auipc	ra,0x4
    135a:	300080e7          	jalr	768(ra) # 5656 <exit>
    exit(747); // OK
    135e:	2eb00513          	li	a0,747
    1362:	00004097          	auipc	ra,0x4
    1366:	2f4080e7          	jalr	756(ra) # 5656 <exit>
  int st = 0;
    136a:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    136e:	f5440513          	addi	a0,s0,-172
    1372:	00004097          	auipc	ra,0x4
    1376:	2ec080e7          	jalr	748(ra) # 565e <wait>
  if(st != 747){
    137a:	f5442703          	lw	a4,-172(s0)
    137e:	2eb00793          	li	a5,747
    1382:	00f71663          	bne	a4,a5,138e <copyinstr2+0x1dc>
}
    1386:	60ae                	ld	ra,200(sp)
    1388:	640e                	ld	s0,192(sp)
    138a:	6169                	addi	sp,sp,208
    138c:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    138e:	00005517          	auipc	a0,0x5
    1392:	35250513          	addi	a0,a0,850 # 66e0 <malloc+0xc44>
    1396:	00004097          	auipc	ra,0x4
    139a:	648080e7          	jalr	1608(ra) # 59de <printf>
    exit(1);
    139e:	4505                	li	a0,1
    13a0:	00004097          	auipc	ra,0x4
    13a4:	2b6080e7          	jalr	694(ra) # 5656 <exit>

00000000000013a8 <truncate3>:
{
    13a8:	7159                	addi	sp,sp,-112
    13aa:	f486                	sd	ra,104(sp)
    13ac:	f0a2                	sd	s0,96(sp)
    13ae:	eca6                	sd	s1,88(sp)
    13b0:	e8ca                	sd	s2,80(sp)
    13b2:	e4ce                	sd	s3,72(sp)
    13b4:	e0d2                	sd	s4,64(sp)
    13b6:	fc56                	sd	s5,56(sp)
    13b8:	1880                	addi	s0,sp,112
    13ba:	892a                	mv	s2,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    13bc:	60100593          	li	a1,1537
    13c0:	00005517          	auipc	a0,0x5
    13c4:	b7050513          	addi	a0,a0,-1168 # 5f30 <malloc+0x494>
    13c8:	00004097          	auipc	ra,0x4
    13cc:	2ce080e7          	jalr	718(ra) # 5696 <open>
    13d0:	00004097          	auipc	ra,0x4
    13d4:	2ae080e7          	jalr	686(ra) # 567e <close>
  pid = fork();
    13d8:	00004097          	auipc	ra,0x4
    13dc:	276080e7          	jalr	630(ra) # 564e <fork>
  if(pid < 0){
    13e0:	08054063          	bltz	a0,1460 <truncate3+0xb8>
  if(pid == 0){
    13e4:	e969                	bnez	a0,14b6 <truncate3+0x10e>
    13e6:	06400993          	li	s3,100
      int fd = open("truncfile", O_WRONLY);
    13ea:	00005a17          	auipc	s4,0x5
    13ee:	b46a0a13          	addi	s4,s4,-1210 # 5f30 <malloc+0x494>
      int n = write(fd, "1234567890", 10);
    13f2:	00005a97          	auipc	s5,0x5
    13f6:	34ea8a93          	addi	s5,s5,846 # 6740 <malloc+0xca4>
      int fd = open("truncfile", O_WRONLY);
    13fa:	4585                	li	a1,1
    13fc:	8552                	mv	a0,s4
    13fe:	00004097          	auipc	ra,0x4
    1402:	298080e7          	jalr	664(ra) # 5696 <open>
    1406:	84aa                	mv	s1,a0
      if(fd < 0){
    1408:	06054a63          	bltz	a0,147c <truncate3+0xd4>
      int n = write(fd, "1234567890", 10);
    140c:	4629                	li	a2,10
    140e:	85d6                	mv	a1,s5
    1410:	00004097          	auipc	ra,0x4
    1414:	266080e7          	jalr	614(ra) # 5676 <write>
      if(n != 10){
    1418:	47a9                	li	a5,10
    141a:	06f51f63          	bne	a0,a5,1498 <truncate3+0xf0>
      close(fd);
    141e:	8526                	mv	a0,s1
    1420:	00004097          	auipc	ra,0x4
    1424:	25e080e7          	jalr	606(ra) # 567e <close>
      fd = open("truncfile", O_RDONLY);
    1428:	4581                	li	a1,0
    142a:	8552                	mv	a0,s4
    142c:	00004097          	auipc	ra,0x4
    1430:	26a080e7          	jalr	618(ra) # 5696 <open>
    1434:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    1436:	02000613          	li	a2,32
    143a:	f9840593          	addi	a1,s0,-104
    143e:	00004097          	auipc	ra,0x4
    1442:	230080e7          	jalr	560(ra) # 566e <read>
      close(fd);
    1446:	8526                	mv	a0,s1
    1448:	00004097          	auipc	ra,0x4
    144c:	236080e7          	jalr	566(ra) # 567e <close>
    for(int i = 0; i < 100; i++){
    1450:	39fd                	addiw	s3,s3,-1
    1452:	fa0994e3          	bnez	s3,13fa <truncate3+0x52>
    exit(0);
    1456:	4501                	li	a0,0
    1458:	00004097          	auipc	ra,0x4
    145c:	1fe080e7          	jalr	510(ra) # 5656 <exit>
    printf("%s: fork failed\n", s);
    1460:	85ca                	mv	a1,s2
    1462:	00005517          	auipc	a0,0x5
    1466:	2ae50513          	addi	a0,a0,686 # 6710 <malloc+0xc74>
    146a:	00004097          	auipc	ra,0x4
    146e:	574080e7          	jalr	1396(ra) # 59de <printf>
    exit(1);
    1472:	4505                	li	a0,1
    1474:	00004097          	auipc	ra,0x4
    1478:	1e2080e7          	jalr	482(ra) # 5656 <exit>
        printf("%s: open failed\n", s);
    147c:	85ca                	mv	a1,s2
    147e:	00005517          	auipc	a0,0x5
    1482:	2aa50513          	addi	a0,a0,682 # 6728 <malloc+0xc8c>
    1486:	00004097          	auipc	ra,0x4
    148a:	558080e7          	jalr	1368(ra) # 59de <printf>
        exit(1);
    148e:	4505                	li	a0,1
    1490:	00004097          	auipc	ra,0x4
    1494:	1c6080e7          	jalr	454(ra) # 5656 <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    1498:	862a                	mv	a2,a0
    149a:	85ca                	mv	a1,s2
    149c:	00005517          	auipc	a0,0x5
    14a0:	2b450513          	addi	a0,a0,692 # 6750 <malloc+0xcb4>
    14a4:	00004097          	auipc	ra,0x4
    14a8:	53a080e7          	jalr	1338(ra) # 59de <printf>
        exit(1);
    14ac:	4505                	li	a0,1
    14ae:	00004097          	auipc	ra,0x4
    14b2:	1a8080e7          	jalr	424(ra) # 5656 <exit>
    14b6:	09600993          	li	s3,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    14ba:	00005a17          	auipc	s4,0x5
    14be:	a76a0a13          	addi	s4,s4,-1418 # 5f30 <malloc+0x494>
    int n = write(fd, "xxx", 3);
    14c2:	00005a97          	auipc	s5,0x5
    14c6:	2aea8a93          	addi	s5,s5,686 # 6770 <malloc+0xcd4>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    14ca:	60100593          	li	a1,1537
    14ce:	8552                	mv	a0,s4
    14d0:	00004097          	auipc	ra,0x4
    14d4:	1c6080e7          	jalr	454(ra) # 5696 <open>
    14d8:	84aa                	mv	s1,a0
    if(fd < 0){
    14da:	04054763          	bltz	a0,1528 <truncate3+0x180>
    int n = write(fd, "xxx", 3);
    14de:	460d                	li	a2,3
    14e0:	85d6                	mv	a1,s5
    14e2:	00004097          	auipc	ra,0x4
    14e6:	194080e7          	jalr	404(ra) # 5676 <write>
    if(n != 3){
    14ea:	478d                	li	a5,3
    14ec:	04f51c63          	bne	a0,a5,1544 <truncate3+0x19c>
    close(fd);
    14f0:	8526                	mv	a0,s1
    14f2:	00004097          	auipc	ra,0x4
    14f6:	18c080e7          	jalr	396(ra) # 567e <close>
  for(int i = 0; i < 150; i++){
    14fa:	39fd                	addiw	s3,s3,-1
    14fc:	fc0997e3          	bnez	s3,14ca <truncate3+0x122>
  wait(&xstatus);
    1500:	fbc40513          	addi	a0,s0,-68
    1504:	00004097          	auipc	ra,0x4
    1508:	15a080e7          	jalr	346(ra) # 565e <wait>
  unlink("truncfile");
    150c:	00005517          	auipc	a0,0x5
    1510:	a2450513          	addi	a0,a0,-1500 # 5f30 <malloc+0x494>
    1514:	00004097          	auipc	ra,0x4
    1518:	192080e7          	jalr	402(ra) # 56a6 <unlink>
  exit(xstatus);
    151c:	fbc42503          	lw	a0,-68(s0)
    1520:	00004097          	auipc	ra,0x4
    1524:	136080e7          	jalr	310(ra) # 5656 <exit>
      printf("%s: open failed\n", s);
    1528:	85ca                	mv	a1,s2
    152a:	00005517          	auipc	a0,0x5
    152e:	1fe50513          	addi	a0,a0,510 # 6728 <malloc+0xc8c>
    1532:	00004097          	auipc	ra,0x4
    1536:	4ac080e7          	jalr	1196(ra) # 59de <printf>
      exit(1);
    153a:	4505                	li	a0,1
    153c:	00004097          	auipc	ra,0x4
    1540:	11a080e7          	jalr	282(ra) # 5656 <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    1544:	862a                	mv	a2,a0
    1546:	85ca                	mv	a1,s2
    1548:	00005517          	auipc	a0,0x5
    154c:	23050513          	addi	a0,a0,560 # 6778 <malloc+0xcdc>
    1550:	00004097          	auipc	ra,0x4
    1554:	48e080e7          	jalr	1166(ra) # 59de <printf>
      exit(1);
    1558:	4505                	li	a0,1
    155a:	00004097          	auipc	ra,0x4
    155e:	0fc080e7          	jalr	252(ra) # 5656 <exit>

0000000000001562 <exectest>:
{
    1562:	715d                	addi	sp,sp,-80
    1564:	e486                	sd	ra,72(sp)
    1566:	e0a2                	sd	s0,64(sp)
    1568:	fc26                	sd	s1,56(sp)
    156a:	f84a                	sd	s2,48(sp)
    156c:	0880                	addi	s0,sp,80
    156e:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    1570:	00005797          	auipc	a5,0x5
    1574:	96878793          	addi	a5,a5,-1688 # 5ed8 <malloc+0x43c>
    1578:	fcf43023          	sd	a5,-64(s0)
    157c:	00005797          	auipc	a5,0x5
    1580:	21c78793          	addi	a5,a5,540 # 6798 <malloc+0xcfc>
    1584:	fcf43423          	sd	a5,-56(s0)
    1588:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    158c:	00005517          	auipc	a0,0x5
    1590:	21450513          	addi	a0,a0,532 # 67a0 <malloc+0xd04>
    1594:	00004097          	auipc	ra,0x4
    1598:	112080e7          	jalr	274(ra) # 56a6 <unlink>
  pid = fork();
    159c:	00004097          	auipc	ra,0x4
    15a0:	0b2080e7          	jalr	178(ra) # 564e <fork>
  if(pid < 0) {
    15a4:	04054663          	bltz	a0,15f0 <exectest+0x8e>
    15a8:	84aa                	mv	s1,a0
  if(pid == 0) {
    15aa:	e959                	bnez	a0,1640 <exectest+0xde>
    close(1);
    15ac:	4505                	li	a0,1
    15ae:	00004097          	auipc	ra,0x4
    15b2:	0d0080e7          	jalr	208(ra) # 567e <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    15b6:	20100593          	li	a1,513
    15ba:	00005517          	auipc	a0,0x5
    15be:	1e650513          	addi	a0,a0,486 # 67a0 <malloc+0xd04>
    15c2:	00004097          	auipc	ra,0x4
    15c6:	0d4080e7          	jalr	212(ra) # 5696 <open>
    if(fd < 0) {
    15ca:	04054163          	bltz	a0,160c <exectest+0xaa>
    if(fd != 1) {
    15ce:	4785                	li	a5,1
    15d0:	04f50c63          	beq	a0,a5,1628 <exectest+0xc6>
      printf("%s: wrong fd\n", s);
    15d4:	85ca                	mv	a1,s2
    15d6:	00005517          	auipc	a0,0x5
    15da:	1ea50513          	addi	a0,a0,490 # 67c0 <malloc+0xd24>
    15de:	00004097          	auipc	ra,0x4
    15e2:	400080e7          	jalr	1024(ra) # 59de <printf>
      exit(1);
    15e6:	4505                	li	a0,1
    15e8:	00004097          	auipc	ra,0x4
    15ec:	06e080e7          	jalr	110(ra) # 5656 <exit>
     printf("%s: fork failed\n", s);
    15f0:	85ca                	mv	a1,s2
    15f2:	00005517          	auipc	a0,0x5
    15f6:	11e50513          	addi	a0,a0,286 # 6710 <malloc+0xc74>
    15fa:	00004097          	auipc	ra,0x4
    15fe:	3e4080e7          	jalr	996(ra) # 59de <printf>
     exit(1);
    1602:	4505                	li	a0,1
    1604:	00004097          	auipc	ra,0x4
    1608:	052080e7          	jalr	82(ra) # 5656 <exit>
      printf("%s: create failed\n", s);
    160c:	85ca                	mv	a1,s2
    160e:	00005517          	auipc	a0,0x5
    1612:	19a50513          	addi	a0,a0,410 # 67a8 <malloc+0xd0c>
    1616:	00004097          	auipc	ra,0x4
    161a:	3c8080e7          	jalr	968(ra) # 59de <printf>
      exit(1);
    161e:	4505                	li	a0,1
    1620:	00004097          	auipc	ra,0x4
    1624:	036080e7          	jalr	54(ra) # 5656 <exit>
    if(exec("echo", echoargv) < 0){
    1628:	fc040593          	addi	a1,s0,-64
    162c:	00005517          	auipc	a0,0x5
    1630:	8ac50513          	addi	a0,a0,-1876 # 5ed8 <malloc+0x43c>
    1634:	00004097          	auipc	ra,0x4
    1638:	05a080e7          	jalr	90(ra) # 568e <exec>
    163c:	02054163          	bltz	a0,165e <exectest+0xfc>
  if (wait(&xstatus) != pid) {
    1640:	fdc40513          	addi	a0,s0,-36
    1644:	00004097          	auipc	ra,0x4
    1648:	01a080e7          	jalr	26(ra) # 565e <wait>
    164c:	02951763          	bne	a0,s1,167a <exectest+0x118>
  if(xstatus != 0)
    1650:	fdc42503          	lw	a0,-36(s0)
    1654:	cd0d                	beqz	a0,168e <exectest+0x12c>
    exit(xstatus);
    1656:	00004097          	auipc	ra,0x4
    165a:	000080e7          	jalr	ra # 5656 <exit>
      printf("%s: exec echo failed\n", s);
    165e:	85ca                	mv	a1,s2
    1660:	00005517          	auipc	a0,0x5
    1664:	17050513          	addi	a0,a0,368 # 67d0 <malloc+0xd34>
    1668:	00004097          	auipc	ra,0x4
    166c:	376080e7          	jalr	886(ra) # 59de <printf>
      exit(1);
    1670:	4505                	li	a0,1
    1672:	00004097          	auipc	ra,0x4
    1676:	fe4080e7          	jalr	-28(ra) # 5656 <exit>
    printf("%s: wait failed!\n", s);
    167a:	85ca                	mv	a1,s2
    167c:	00005517          	auipc	a0,0x5
    1680:	16c50513          	addi	a0,a0,364 # 67e8 <malloc+0xd4c>
    1684:	00004097          	auipc	ra,0x4
    1688:	35a080e7          	jalr	858(ra) # 59de <printf>
    168c:	b7d1                	j	1650 <exectest+0xee>
  fd = open("echo-ok", O_RDONLY);
    168e:	4581                	li	a1,0
    1690:	00005517          	auipc	a0,0x5
    1694:	11050513          	addi	a0,a0,272 # 67a0 <malloc+0xd04>
    1698:	00004097          	auipc	ra,0x4
    169c:	ffe080e7          	jalr	-2(ra) # 5696 <open>
  if(fd < 0) {
    16a0:	02054a63          	bltz	a0,16d4 <exectest+0x172>
  if (read(fd, buf, 2) != 2) {
    16a4:	4609                	li	a2,2
    16a6:	fb840593          	addi	a1,s0,-72
    16aa:	00004097          	auipc	ra,0x4
    16ae:	fc4080e7          	jalr	-60(ra) # 566e <read>
    16b2:	4789                	li	a5,2
    16b4:	02f50e63          	beq	a0,a5,16f0 <exectest+0x18e>
    printf("%s: read failed\n", s);
    16b8:	85ca                	mv	a1,s2
    16ba:	00005517          	auipc	a0,0x5
    16be:	bae50513          	addi	a0,a0,-1106 # 6268 <malloc+0x7cc>
    16c2:	00004097          	auipc	ra,0x4
    16c6:	31c080e7          	jalr	796(ra) # 59de <printf>
    exit(1);
    16ca:	4505                	li	a0,1
    16cc:	00004097          	auipc	ra,0x4
    16d0:	f8a080e7          	jalr	-118(ra) # 5656 <exit>
    printf("%s: open failed\n", s);
    16d4:	85ca                	mv	a1,s2
    16d6:	00005517          	auipc	a0,0x5
    16da:	05250513          	addi	a0,a0,82 # 6728 <malloc+0xc8c>
    16de:	00004097          	auipc	ra,0x4
    16e2:	300080e7          	jalr	768(ra) # 59de <printf>
    exit(1);
    16e6:	4505                	li	a0,1
    16e8:	00004097          	auipc	ra,0x4
    16ec:	f6e080e7          	jalr	-146(ra) # 5656 <exit>
  unlink("echo-ok");
    16f0:	00005517          	auipc	a0,0x5
    16f4:	0b050513          	addi	a0,a0,176 # 67a0 <malloc+0xd04>
    16f8:	00004097          	auipc	ra,0x4
    16fc:	fae080e7          	jalr	-82(ra) # 56a6 <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    1700:	fb844703          	lbu	a4,-72(s0)
    1704:	04f00793          	li	a5,79
    1708:	00f71863          	bne	a4,a5,1718 <exectest+0x1b6>
    170c:	fb944703          	lbu	a4,-71(s0)
    1710:	04b00793          	li	a5,75
    1714:	02f70063          	beq	a4,a5,1734 <exectest+0x1d2>
    printf("%s: wrong output\n", s);
    1718:	85ca                	mv	a1,s2
    171a:	00005517          	auipc	a0,0x5
    171e:	0e650513          	addi	a0,a0,230 # 6800 <malloc+0xd64>
    1722:	00004097          	auipc	ra,0x4
    1726:	2bc080e7          	jalr	700(ra) # 59de <printf>
    exit(1);
    172a:	4505                	li	a0,1
    172c:	00004097          	auipc	ra,0x4
    1730:	f2a080e7          	jalr	-214(ra) # 5656 <exit>
    exit(0);
    1734:	4501                	li	a0,0
    1736:	00004097          	auipc	ra,0x4
    173a:	f20080e7          	jalr	-224(ra) # 5656 <exit>

000000000000173e <pipe1>:
{
    173e:	711d                	addi	sp,sp,-96
    1740:	ec86                	sd	ra,88(sp)
    1742:	e8a2                	sd	s0,80(sp)
    1744:	e4a6                	sd	s1,72(sp)
    1746:	e0ca                	sd	s2,64(sp)
    1748:	fc4e                	sd	s3,56(sp)
    174a:	f852                	sd	s4,48(sp)
    174c:	f456                	sd	s5,40(sp)
    174e:	f05a                	sd	s6,32(sp)
    1750:	ec5e                	sd	s7,24(sp)
    1752:	1080                	addi	s0,sp,96
    1754:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
    1756:	fa840513          	addi	a0,s0,-88
    175a:	00004097          	auipc	ra,0x4
    175e:	f0c080e7          	jalr	-244(ra) # 5666 <pipe>
    1762:	ed25                	bnez	a0,17da <pipe1+0x9c>
    1764:	84aa                	mv	s1,a0
  pid = fork();
    1766:	00004097          	auipc	ra,0x4
    176a:	ee8080e7          	jalr	-280(ra) # 564e <fork>
    176e:	8a2a                	mv	s4,a0
  if(pid == 0){
    1770:	c159                	beqz	a0,17f6 <pipe1+0xb8>
  } else if(pid > 0){
    1772:	16a05e63          	blez	a0,18ee <pipe1+0x1b0>
    close(fds[1]);
    1776:	fac42503          	lw	a0,-84(s0)
    177a:	00004097          	auipc	ra,0x4
    177e:	f04080e7          	jalr	-252(ra) # 567e <close>
    total = 0;
    1782:	8a26                	mv	s4,s1
    cc = 1;
    1784:	4985                	li	s3,1
    while((n = read(fds[0], buf, cc)) > 0){
    1786:	0000aa97          	auipc	s5,0xa
    178a:	3baa8a93          	addi	s5,s5,954 # bb40 <buf>
      if(cc > sizeof(buf))
    178e:	6b0d                	lui	s6,0x3
    while((n = read(fds[0], buf, cc)) > 0){
    1790:	864e                	mv	a2,s3
    1792:	85d6                	mv	a1,s5
    1794:	fa842503          	lw	a0,-88(s0)
    1798:	00004097          	auipc	ra,0x4
    179c:	ed6080e7          	jalr	-298(ra) # 566e <read>
    17a0:	10a05263          	blez	a0,18a4 <pipe1+0x166>
      for(i = 0; i < n; i++){
    17a4:	0000a717          	auipc	a4,0xa
    17a8:	39c70713          	addi	a4,a4,924 # bb40 <buf>
    17ac:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    17b0:	00074683          	lbu	a3,0(a4)
    17b4:	0ff4f793          	andi	a5,s1,255
    17b8:	2485                	addiw	s1,s1,1
    17ba:	0cf69163          	bne	a3,a5,187c <pipe1+0x13e>
      for(i = 0; i < n; i++){
    17be:	0705                	addi	a4,a4,1
    17c0:	fec498e3          	bne	s1,a2,17b0 <pipe1+0x72>
      total += n;
    17c4:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    17c8:	0019979b          	slliw	a5,s3,0x1
    17cc:	0007899b          	sext.w	s3,a5
      if(cc > sizeof(buf))
    17d0:	013b7363          	bgeu	s6,s3,17d6 <pipe1+0x98>
        cc = sizeof(buf);
    17d4:	89da                	mv	s3,s6
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    17d6:	84b2                	mv	s1,a2
    17d8:	bf65                	j	1790 <pipe1+0x52>
    printf("%s: pipe() failed\n", s);
    17da:	85ca                	mv	a1,s2
    17dc:	00005517          	auipc	a0,0x5
    17e0:	03c50513          	addi	a0,a0,60 # 6818 <malloc+0xd7c>
    17e4:	00004097          	auipc	ra,0x4
    17e8:	1fa080e7          	jalr	506(ra) # 59de <printf>
    exit(1);
    17ec:	4505                	li	a0,1
    17ee:	00004097          	auipc	ra,0x4
    17f2:	e68080e7          	jalr	-408(ra) # 5656 <exit>
    close(fds[0]);
    17f6:	fa842503          	lw	a0,-88(s0)
    17fa:	00004097          	auipc	ra,0x4
    17fe:	e84080e7          	jalr	-380(ra) # 567e <close>
    for(n = 0; n < N; n++){
    1802:	0000ab17          	auipc	s6,0xa
    1806:	33eb0b13          	addi	s6,s6,830 # bb40 <buf>
    180a:	416004bb          	negw	s1,s6
    180e:	0ff4f493          	andi	s1,s1,255
    1812:	409b0993          	addi	s3,s6,1033
      if(write(fds[1], buf, SZ) != SZ){
    1816:	8bda                	mv	s7,s6
    for(n = 0; n < N; n++){
    1818:	6a85                	lui	s5,0x1
    181a:	42da8a93          	addi	s5,s5,1069 # 142d <truncate3+0x85>
{
    181e:	87da                	mv	a5,s6
        buf[i] = seq++;
    1820:	0097873b          	addw	a4,a5,s1
    1824:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
    1828:	0785                	addi	a5,a5,1
    182a:	fef99be3          	bne	s3,a5,1820 <pipe1+0xe2>
    182e:	409a0a1b          	addiw	s4,s4,1033
      if(write(fds[1], buf, SZ) != SZ){
    1832:	40900613          	li	a2,1033
    1836:	85de                	mv	a1,s7
    1838:	fac42503          	lw	a0,-84(s0)
    183c:	00004097          	auipc	ra,0x4
    1840:	e3a080e7          	jalr	-454(ra) # 5676 <write>
    1844:	40900793          	li	a5,1033
    1848:	00f51c63          	bne	a0,a5,1860 <pipe1+0x122>
    for(n = 0; n < N; n++){
    184c:	24a5                	addiw	s1,s1,9
    184e:	0ff4f493          	andi	s1,s1,255
    1852:	fd5a16e3          	bne	s4,s5,181e <pipe1+0xe0>
    exit(0);
    1856:	4501                	li	a0,0
    1858:	00004097          	auipc	ra,0x4
    185c:	dfe080e7          	jalr	-514(ra) # 5656 <exit>
        printf("%s: pipe1 oops 1\n", s);
    1860:	85ca                	mv	a1,s2
    1862:	00005517          	auipc	a0,0x5
    1866:	fce50513          	addi	a0,a0,-50 # 6830 <malloc+0xd94>
    186a:	00004097          	auipc	ra,0x4
    186e:	174080e7          	jalr	372(ra) # 59de <printf>
        exit(1);
    1872:	4505                	li	a0,1
    1874:	00004097          	auipc	ra,0x4
    1878:	de2080e7          	jalr	-542(ra) # 5656 <exit>
          printf("%s: pipe1 oops 2\n", s);
    187c:	85ca                	mv	a1,s2
    187e:	00005517          	auipc	a0,0x5
    1882:	fca50513          	addi	a0,a0,-54 # 6848 <malloc+0xdac>
    1886:	00004097          	auipc	ra,0x4
    188a:	158080e7          	jalr	344(ra) # 59de <printf>
}
    188e:	60e6                	ld	ra,88(sp)
    1890:	6446                	ld	s0,80(sp)
    1892:	64a6                	ld	s1,72(sp)
    1894:	6906                	ld	s2,64(sp)
    1896:	79e2                	ld	s3,56(sp)
    1898:	7a42                	ld	s4,48(sp)
    189a:	7aa2                	ld	s5,40(sp)
    189c:	7b02                	ld	s6,32(sp)
    189e:	6be2                	ld	s7,24(sp)
    18a0:	6125                	addi	sp,sp,96
    18a2:	8082                	ret
    if(total != N * SZ){
    18a4:	6785                	lui	a5,0x1
    18a6:	42d78793          	addi	a5,a5,1069 # 142d <truncate3+0x85>
    18aa:	02fa0063          	beq	s4,a5,18ca <pipe1+0x18c>
      printf("%s: pipe1 oops 3 total %d\n", total);
    18ae:	85d2                	mv	a1,s4
    18b0:	00005517          	auipc	a0,0x5
    18b4:	fb050513          	addi	a0,a0,-80 # 6860 <malloc+0xdc4>
    18b8:	00004097          	auipc	ra,0x4
    18bc:	126080e7          	jalr	294(ra) # 59de <printf>
      exit(1);
    18c0:	4505                	li	a0,1
    18c2:	00004097          	auipc	ra,0x4
    18c6:	d94080e7          	jalr	-620(ra) # 5656 <exit>
    close(fds[0]);
    18ca:	fa842503          	lw	a0,-88(s0)
    18ce:	00004097          	auipc	ra,0x4
    18d2:	db0080e7          	jalr	-592(ra) # 567e <close>
    wait(&xstatus);
    18d6:	fa440513          	addi	a0,s0,-92
    18da:	00004097          	auipc	ra,0x4
    18de:	d84080e7          	jalr	-636(ra) # 565e <wait>
    exit(xstatus);
    18e2:	fa442503          	lw	a0,-92(s0)
    18e6:	00004097          	auipc	ra,0x4
    18ea:	d70080e7          	jalr	-656(ra) # 5656 <exit>
    printf("%s: fork() failed\n", s);
    18ee:	85ca                	mv	a1,s2
    18f0:	00005517          	auipc	a0,0x5
    18f4:	f9050513          	addi	a0,a0,-112 # 6880 <malloc+0xde4>
    18f8:	00004097          	auipc	ra,0x4
    18fc:	0e6080e7          	jalr	230(ra) # 59de <printf>
    exit(1);
    1900:	4505                	li	a0,1
    1902:	00004097          	auipc	ra,0x4
    1906:	d54080e7          	jalr	-684(ra) # 5656 <exit>

000000000000190a <exitwait>:
{
    190a:	7139                	addi	sp,sp,-64
    190c:	fc06                	sd	ra,56(sp)
    190e:	f822                	sd	s0,48(sp)
    1910:	f426                	sd	s1,40(sp)
    1912:	f04a                	sd	s2,32(sp)
    1914:	ec4e                	sd	s3,24(sp)
    1916:	e852                	sd	s4,16(sp)
    1918:	0080                	addi	s0,sp,64
    191a:	8a2a                	mv	s4,a0
  for(i = 0; i < 100; i++){
    191c:	4901                	li	s2,0
    191e:	06400993          	li	s3,100
    pid = fork();
    1922:	00004097          	auipc	ra,0x4
    1926:	d2c080e7          	jalr	-724(ra) # 564e <fork>
    192a:	84aa                	mv	s1,a0
    if(pid < 0){
    192c:	02054a63          	bltz	a0,1960 <exitwait+0x56>
    if(pid){
    1930:	c151                	beqz	a0,19b4 <exitwait+0xaa>
      if(wait(&xstate) != pid){
    1932:	fcc40513          	addi	a0,s0,-52
    1936:	00004097          	auipc	ra,0x4
    193a:	d28080e7          	jalr	-728(ra) # 565e <wait>
    193e:	02951f63          	bne	a0,s1,197c <exitwait+0x72>
      if(i != xstate) {
    1942:	fcc42783          	lw	a5,-52(s0)
    1946:	05279963          	bne	a5,s2,1998 <exitwait+0x8e>
  for(i = 0; i < 100; i++){
    194a:	2905                	addiw	s2,s2,1
    194c:	fd391be3          	bne	s2,s3,1922 <exitwait+0x18>
}
    1950:	70e2                	ld	ra,56(sp)
    1952:	7442                	ld	s0,48(sp)
    1954:	74a2                	ld	s1,40(sp)
    1956:	7902                	ld	s2,32(sp)
    1958:	69e2                	ld	s3,24(sp)
    195a:	6a42                	ld	s4,16(sp)
    195c:	6121                	addi	sp,sp,64
    195e:	8082                	ret
      printf("%s: fork failed\n", s);
    1960:	85d2                	mv	a1,s4
    1962:	00005517          	auipc	a0,0x5
    1966:	dae50513          	addi	a0,a0,-594 # 6710 <malloc+0xc74>
    196a:	00004097          	auipc	ra,0x4
    196e:	074080e7          	jalr	116(ra) # 59de <printf>
      exit(1);
    1972:	4505                	li	a0,1
    1974:	00004097          	auipc	ra,0x4
    1978:	ce2080e7          	jalr	-798(ra) # 5656 <exit>
        printf("%s: wait wrong pid\n", s);
    197c:	85d2                	mv	a1,s4
    197e:	00005517          	auipc	a0,0x5
    1982:	f1a50513          	addi	a0,a0,-230 # 6898 <malloc+0xdfc>
    1986:	00004097          	auipc	ra,0x4
    198a:	058080e7          	jalr	88(ra) # 59de <printf>
        exit(1);
    198e:	4505                	li	a0,1
    1990:	00004097          	auipc	ra,0x4
    1994:	cc6080e7          	jalr	-826(ra) # 5656 <exit>
        printf("%s: wait wrong exit status\n", s);
    1998:	85d2                	mv	a1,s4
    199a:	00005517          	auipc	a0,0x5
    199e:	f1650513          	addi	a0,a0,-234 # 68b0 <malloc+0xe14>
    19a2:	00004097          	auipc	ra,0x4
    19a6:	03c080e7          	jalr	60(ra) # 59de <printf>
        exit(1);
    19aa:	4505                	li	a0,1
    19ac:	00004097          	auipc	ra,0x4
    19b0:	caa080e7          	jalr	-854(ra) # 5656 <exit>
      exit(i);
    19b4:	854a                	mv	a0,s2
    19b6:	00004097          	auipc	ra,0x4
    19ba:	ca0080e7          	jalr	-864(ra) # 5656 <exit>

00000000000019be <twochildren>:
{
    19be:	1101                	addi	sp,sp,-32
    19c0:	ec06                	sd	ra,24(sp)
    19c2:	e822                	sd	s0,16(sp)
    19c4:	e426                	sd	s1,8(sp)
    19c6:	e04a                	sd	s2,0(sp)
    19c8:	1000                	addi	s0,sp,32
    19ca:	892a                	mv	s2,a0
    19cc:	3e800493          	li	s1,1000
    int pid1 = fork();
    19d0:	00004097          	auipc	ra,0x4
    19d4:	c7e080e7          	jalr	-898(ra) # 564e <fork>
    if(pid1 < 0){
    19d8:	02054c63          	bltz	a0,1a10 <twochildren+0x52>
    if(pid1 == 0){
    19dc:	c921                	beqz	a0,1a2c <twochildren+0x6e>
      int pid2 = fork();
    19de:	00004097          	auipc	ra,0x4
    19e2:	c70080e7          	jalr	-912(ra) # 564e <fork>
      if(pid2 < 0){
    19e6:	04054763          	bltz	a0,1a34 <twochildren+0x76>
      if(pid2 == 0){
    19ea:	c13d                	beqz	a0,1a50 <twochildren+0x92>
        wait(0);
    19ec:	4501                	li	a0,0
    19ee:	00004097          	auipc	ra,0x4
    19f2:	c70080e7          	jalr	-912(ra) # 565e <wait>
        wait(0);
    19f6:	4501                	li	a0,0
    19f8:	00004097          	auipc	ra,0x4
    19fc:	c66080e7          	jalr	-922(ra) # 565e <wait>
  for(int i = 0; i < 1000; i++){
    1a00:	34fd                	addiw	s1,s1,-1
    1a02:	f4f9                	bnez	s1,19d0 <twochildren+0x12>
}
    1a04:	60e2                	ld	ra,24(sp)
    1a06:	6442                	ld	s0,16(sp)
    1a08:	64a2                	ld	s1,8(sp)
    1a0a:	6902                	ld	s2,0(sp)
    1a0c:	6105                	addi	sp,sp,32
    1a0e:	8082                	ret
      printf("%s: fork failed\n", s);
    1a10:	85ca                	mv	a1,s2
    1a12:	00005517          	auipc	a0,0x5
    1a16:	cfe50513          	addi	a0,a0,-770 # 6710 <malloc+0xc74>
    1a1a:	00004097          	auipc	ra,0x4
    1a1e:	fc4080e7          	jalr	-60(ra) # 59de <printf>
      exit(1);
    1a22:	4505                	li	a0,1
    1a24:	00004097          	auipc	ra,0x4
    1a28:	c32080e7          	jalr	-974(ra) # 5656 <exit>
      exit(0);
    1a2c:	00004097          	auipc	ra,0x4
    1a30:	c2a080e7          	jalr	-982(ra) # 5656 <exit>
        printf("%s: fork failed\n", s);
    1a34:	85ca                	mv	a1,s2
    1a36:	00005517          	auipc	a0,0x5
    1a3a:	cda50513          	addi	a0,a0,-806 # 6710 <malloc+0xc74>
    1a3e:	00004097          	auipc	ra,0x4
    1a42:	fa0080e7          	jalr	-96(ra) # 59de <printf>
        exit(1);
    1a46:	4505                	li	a0,1
    1a48:	00004097          	auipc	ra,0x4
    1a4c:	c0e080e7          	jalr	-1010(ra) # 5656 <exit>
        exit(0);
    1a50:	00004097          	auipc	ra,0x4
    1a54:	c06080e7          	jalr	-1018(ra) # 5656 <exit>

0000000000001a58 <forkfork>:
{
    1a58:	7179                	addi	sp,sp,-48
    1a5a:	f406                	sd	ra,40(sp)
    1a5c:	f022                	sd	s0,32(sp)
    1a5e:	ec26                	sd	s1,24(sp)
    1a60:	1800                	addi	s0,sp,48
    1a62:	84aa                	mv	s1,a0
    int pid = fork();
    1a64:	00004097          	auipc	ra,0x4
    1a68:	bea080e7          	jalr	-1046(ra) # 564e <fork>
    if(pid < 0){
    1a6c:	04054163          	bltz	a0,1aae <forkfork+0x56>
    if(pid == 0){
    1a70:	cd29                	beqz	a0,1aca <forkfork+0x72>
    int pid = fork();
    1a72:	00004097          	auipc	ra,0x4
    1a76:	bdc080e7          	jalr	-1060(ra) # 564e <fork>
    if(pid < 0){
    1a7a:	02054a63          	bltz	a0,1aae <forkfork+0x56>
    if(pid == 0){
    1a7e:	c531                	beqz	a0,1aca <forkfork+0x72>
    wait(&xstatus);
    1a80:	fdc40513          	addi	a0,s0,-36
    1a84:	00004097          	auipc	ra,0x4
    1a88:	bda080e7          	jalr	-1062(ra) # 565e <wait>
    if(xstatus != 0) {
    1a8c:	fdc42783          	lw	a5,-36(s0)
    1a90:	ebbd                	bnez	a5,1b06 <forkfork+0xae>
    wait(&xstatus);
    1a92:	fdc40513          	addi	a0,s0,-36
    1a96:	00004097          	auipc	ra,0x4
    1a9a:	bc8080e7          	jalr	-1080(ra) # 565e <wait>
    if(xstatus != 0) {
    1a9e:	fdc42783          	lw	a5,-36(s0)
    1aa2:	e3b5                	bnez	a5,1b06 <forkfork+0xae>
}
    1aa4:	70a2                	ld	ra,40(sp)
    1aa6:	7402                	ld	s0,32(sp)
    1aa8:	64e2                	ld	s1,24(sp)
    1aaa:	6145                	addi	sp,sp,48
    1aac:	8082                	ret
      printf("%s: fork failed", s);
    1aae:	85a6                	mv	a1,s1
    1ab0:	00005517          	auipc	a0,0x5
    1ab4:	e2050513          	addi	a0,a0,-480 # 68d0 <malloc+0xe34>
    1ab8:	00004097          	auipc	ra,0x4
    1abc:	f26080e7          	jalr	-218(ra) # 59de <printf>
      exit(1);
    1ac0:	4505                	li	a0,1
    1ac2:	00004097          	auipc	ra,0x4
    1ac6:	b94080e7          	jalr	-1132(ra) # 5656 <exit>
{
    1aca:	0c800493          	li	s1,200
        int pid1 = fork();
    1ace:	00004097          	auipc	ra,0x4
    1ad2:	b80080e7          	jalr	-1152(ra) # 564e <fork>
        if(pid1 < 0){
    1ad6:	00054f63          	bltz	a0,1af4 <forkfork+0x9c>
        if(pid1 == 0){
    1ada:	c115                	beqz	a0,1afe <forkfork+0xa6>
        wait(0);
    1adc:	4501                	li	a0,0
    1ade:	00004097          	auipc	ra,0x4
    1ae2:	b80080e7          	jalr	-1152(ra) # 565e <wait>
      for(int j = 0; j < 200; j++){
    1ae6:	34fd                	addiw	s1,s1,-1
    1ae8:	f0fd                	bnez	s1,1ace <forkfork+0x76>
      exit(0);
    1aea:	4501                	li	a0,0
    1aec:	00004097          	auipc	ra,0x4
    1af0:	b6a080e7          	jalr	-1174(ra) # 5656 <exit>
          exit(1);
    1af4:	4505                	li	a0,1
    1af6:	00004097          	auipc	ra,0x4
    1afa:	b60080e7          	jalr	-1184(ra) # 5656 <exit>
          exit(0);
    1afe:	00004097          	auipc	ra,0x4
    1b02:	b58080e7          	jalr	-1192(ra) # 5656 <exit>
      printf("%s: fork in child failed", s);
    1b06:	85a6                	mv	a1,s1
    1b08:	00005517          	auipc	a0,0x5
    1b0c:	dd850513          	addi	a0,a0,-552 # 68e0 <malloc+0xe44>
    1b10:	00004097          	auipc	ra,0x4
    1b14:	ece080e7          	jalr	-306(ra) # 59de <printf>
      exit(1);
    1b18:	4505                	li	a0,1
    1b1a:	00004097          	auipc	ra,0x4
    1b1e:	b3c080e7          	jalr	-1220(ra) # 5656 <exit>

0000000000001b22 <reparent2>:
{
    1b22:	1101                	addi	sp,sp,-32
    1b24:	ec06                	sd	ra,24(sp)
    1b26:	e822                	sd	s0,16(sp)
    1b28:	e426                	sd	s1,8(sp)
    1b2a:	1000                	addi	s0,sp,32
    1b2c:	32000493          	li	s1,800
    int pid1 = fork();
    1b30:	00004097          	auipc	ra,0x4
    1b34:	b1e080e7          	jalr	-1250(ra) # 564e <fork>
    if(pid1 < 0){
    1b38:	00054f63          	bltz	a0,1b56 <reparent2+0x34>
    if(pid1 == 0){
    1b3c:	c915                	beqz	a0,1b70 <reparent2+0x4e>
    wait(0);
    1b3e:	4501                	li	a0,0
    1b40:	00004097          	auipc	ra,0x4
    1b44:	b1e080e7          	jalr	-1250(ra) # 565e <wait>
  for(int i = 0; i < 800; i++){
    1b48:	34fd                	addiw	s1,s1,-1
    1b4a:	f0fd                	bnez	s1,1b30 <reparent2+0xe>
  exit(0);
    1b4c:	4501                	li	a0,0
    1b4e:	00004097          	auipc	ra,0x4
    1b52:	b08080e7          	jalr	-1272(ra) # 5656 <exit>
      printf("fork failed\n");
    1b56:	00005517          	auipc	a0,0x5
    1b5a:	fc250513          	addi	a0,a0,-62 # 6b18 <malloc+0x107c>
    1b5e:	00004097          	auipc	ra,0x4
    1b62:	e80080e7          	jalr	-384(ra) # 59de <printf>
      exit(1);
    1b66:	4505                	li	a0,1
    1b68:	00004097          	auipc	ra,0x4
    1b6c:	aee080e7          	jalr	-1298(ra) # 5656 <exit>
      fork();
    1b70:	00004097          	auipc	ra,0x4
    1b74:	ade080e7          	jalr	-1314(ra) # 564e <fork>
      fork();
    1b78:	00004097          	auipc	ra,0x4
    1b7c:	ad6080e7          	jalr	-1322(ra) # 564e <fork>
      exit(0);
    1b80:	4501                	li	a0,0
    1b82:	00004097          	auipc	ra,0x4
    1b86:	ad4080e7          	jalr	-1324(ra) # 5656 <exit>

0000000000001b8a <createdelete>:
{
    1b8a:	7175                	addi	sp,sp,-144
    1b8c:	e506                	sd	ra,136(sp)
    1b8e:	e122                	sd	s0,128(sp)
    1b90:	fca6                	sd	s1,120(sp)
    1b92:	f8ca                	sd	s2,112(sp)
    1b94:	f4ce                	sd	s3,104(sp)
    1b96:	f0d2                	sd	s4,96(sp)
    1b98:	ecd6                	sd	s5,88(sp)
    1b9a:	e8da                	sd	s6,80(sp)
    1b9c:	e4de                	sd	s7,72(sp)
    1b9e:	e0e2                	sd	s8,64(sp)
    1ba0:	fc66                	sd	s9,56(sp)
    1ba2:	0900                	addi	s0,sp,144
    1ba4:	8caa                	mv	s9,a0
  for(pi = 0; pi < NCHILD; pi++){
    1ba6:	4901                	li	s2,0
    1ba8:	4991                	li	s3,4
    pid = fork();
    1baa:	00004097          	auipc	ra,0x4
    1bae:	aa4080e7          	jalr	-1372(ra) # 564e <fork>
    1bb2:	84aa                	mv	s1,a0
    if(pid < 0){
    1bb4:	02054f63          	bltz	a0,1bf2 <createdelete+0x68>
    if(pid == 0){
    1bb8:	c939                	beqz	a0,1c0e <createdelete+0x84>
  for(pi = 0; pi < NCHILD; pi++){
    1bba:	2905                	addiw	s2,s2,1
    1bbc:	ff3917e3          	bne	s2,s3,1baa <createdelete+0x20>
    1bc0:	4491                	li	s1,4
    wait(&xstatus);
    1bc2:	f7c40513          	addi	a0,s0,-132
    1bc6:	00004097          	auipc	ra,0x4
    1bca:	a98080e7          	jalr	-1384(ra) # 565e <wait>
    if(xstatus != 0)
    1bce:	f7c42903          	lw	s2,-132(s0)
    1bd2:	0e091263          	bnez	s2,1cb6 <createdelete+0x12c>
  for(pi = 0; pi < NCHILD; pi++){
    1bd6:	34fd                	addiw	s1,s1,-1
    1bd8:	f4ed                	bnez	s1,1bc2 <createdelete+0x38>
  name[0] = name[1] = name[2] = 0;
    1bda:	f8040123          	sb	zero,-126(s0)
    1bde:	03000993          	li	s3,48
    1be2:	5a7d                	li	s4,-1
    1be4:	07000c13          	li	s8,112
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1be8:	4b21                	li	s6,8
      if((i == 0 || i >= N/2) && fd < 0){
    1bea:	4ba5                	li	s7,9
    for(pi = 0; pi < NCHILD; pi++){
    1bec:	07400a93          	li	s5,116
    1bf0:	a29d                	j	1d56 <createdelete+0x1cc>
      printf("fork failed\n", s);
    1bf2:	85e6                	mv	a1,s9
    1bf4:	00005517          	auipc	a0,0x5
    1bf8:	f2450513          	addi	a0,a0,-220 # 6b18 <malloc+0x107c>
    1bfc:	00004097          	auipc	ra,0x4
    1c00:	de2080e7          	jalr	-542(ra) # 59de <printf>
      exit(1);
    1c04:	4505                	li	a0,1
    1c06:	00004097          	auipc	ra,0x4
    1c0a:	a50080e7          	jalr	-1456(ra) # 5656 <exit>
      name[0] = 'p' + pi;
    1c0e:	0709091b          	addiw	s2,s2,112
    1c12:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    1c16:	f8040123          	sb	zero,-126(s0)
      for(i = 0; i < N; i++){
    1c1a:	4951                	li	s2,20
    1c1c:	a015                	j	1c40 <createdelete+0xb6>
          printf("%s: create failed\n", s);
    1c1e:	85e6                	mv	a1,s9
    1c20:	00005517          	auipc	a0,0x5
    1c24:	b8850513          	addi	a0,a0,-1144 # 67a8 <malloc+0xd0c>
    1c28:	00004097          	auipc	ra,0x4
    1c2c:	db6080e7          	jalr	-586(ra) # 59de <printf>
          exit(1);
    1c30:	4505                	li	a0,1
    1c32:	00004097          	auipc	ra,0x4
    1c36:	a24080e7          	jalr	-1500(ra) # 5656 <exit>
      for(i = 0; i < N; i++){
    1c3a:	2485                	addiw	s1,s1,1
    1c3c:	07248863          	beq	s1,s2,1cac <createdelete+0x122>
        name[1] = '0' + i;
    1c40:	0304879b          	addiw	a5,s1,48
    1c44:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1c48:	20200593          	li	a1,514
    1c4c:	f8040513          	addi	a0,s0,-128
    1c50:	00004097          	auipc	ra,0x4
    1c54:	a46080e7          	jalr	-1466(ra) # 5696 <open>
        if(fd < 0){
    1c58:	fc0543e3          	bltz	a0,1c1e <createdelete+0x94>
        close(fd);
    1c5c:	00004097          	auipc	ra,0x4
    1c60:	a22080e7          	jalr	-1502(ra) # 567e <close>
        if(i > 0 && (i % 2 ) == 0){
    1c64:	fc905be3          	blez	s1,1c3a <createdelete+0xb0>
    1c68:	0014f793          	andi	a5,s1,1
    1c6c:	f7f9                	bnez	a5,1c3a <createdelete+0xb0>
          name[1] = '0' + (i / 2);
    1c6e:	01f4d79b          	srliw	a5,s1,0x1f
    1c72:	9fa5                	addw	a5,a5,s1
    1c74:	4017d79b          	sraiw	a5,a5,0x1
    1c78:	0307879b          	addiw	a5,a5,48
    1c7c:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
    1c80:	f8040513          	addi	a0,s0,-128
    1c84:	00004097          	auipc	ra,0x4
    1c88:	a22080e7          	jalr	-1502(ra) # 56a6 <unlink>
    1c8c:	fa0557e3          	bgez	a0,1c3a <createdelete+0xb0>
            printf("%s: unlink failed\n", s);
    1c90:	85e6                	mv	a1,s9
    1c92:	00005517          	auipc	a0,0x5
    1c96:	c6e50513          	addi	a0,a0,-914 # 6900 <malloc+0xe64>
    1c9a:	00004097          	auipc	ra,0x4
    1c9e:	d44080e7          	jalr	-700(ra) # 59de <printf>
            exit(1);
    1ca2:	4505                	li	a0,1
    1ca4:	00004097          	auipc	ra,0x4
    1ca8:	9b2080e7          	jalr	-1614(ra) # 5656 <exit>
      exit(0);
    1cac:	4501                	li	a0,0
    1cae:	00004097          	auipc	ra,0x4
    1cb2:	9a8080e7          	jalr	-1624(ra) # 5656 <exit>
      exit(1);
    1cb6:	4505                	li	a0,1
    1cb8:	00004097          	auipc	ra,0x4
    1cbc:	99e080e7          	jalr	-1634(ra) # 5656 <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1cc0:	f8040613          	addi	a2,s0,-128
    1cc4:	85e6                	mv	a1,s9
    1cc6:	00005517          	auipc	a0,0x5
    1cca:	c5250513          	addi	a0,a0,-942 # 6918 <malloc+0xe7c>
    1cce:	00004097          	auipc	ra,0x4
    1cd2:	d10080e7          	jalr	-752(ra) # 59de <printf>
        exit(1);
    1cd6:	4505                	li	a0,1
    1cd8:	00004097          	auipc	ra,0x4
    1cdc:	97e080e7          	jalr	-1666(ra) # 5656 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1ce0:	054b7163          	bgeu	s6,s4,1d22 <createdelete+0x198>
      if(fd >= 0)
    1ce4:	02055a63          	bgez	a0,1d18 <createdelete+0x18e>
    for(pi = 0; pi < NCHILD; pi++){
    1ce8:	2485                	addiw	s1,s1,1
    1cea:	0ff4f493          	andi	s1,s1,255
    1cee:	05548c63          	beq	s1,s5,1d46 <createdelete+0x1bc>
      name[0] = 'p' + pi;
    1cf2:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    1cf6:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    1cfa:	4581                	li	a1,0
    1cfc:	f8040513          	addi	a0,s0,-128
    1d00:	00004097          	auipc	ra,0x4
    1d04:	996080e7          	jalr	-1642(ra) # 5696 <open>
      if((i == 0 || i >= N/2) && fd < 0){
    1d08:	00090463          	beqz	s2,1d10 <createdelete+0x186>
    1d0c:	fd2bdae3          	bge	s7,s2,1ce0 <createdelete+0x156>
    1d10:	fa0548e3          	bltz	a0,1cc0 <createdelete+0x136>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1d14:	014b7963          	bgeu	s6,s4,1d26 <createdelete+0x19c>
        close(fd);
    1d18:	00004097          	auipc	ra,0x4
    1d1c:	966080e7          	jalr	-1690(ra) # 567e <close>
    1d20:	b7e1                	j	1ce8 <createdelete+0x15e>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1d22:	fc0543e3          	bltz	a0,1ce8 <createdelete+0x15e>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1d26:	f8040613          	addi	a2,s0,-128
    1d2a:	85e6                	mv	a1,s9
    1d2c:	00005517          	auipc	a0,0x5
    1d30:	c1450513          	addi	a0,a0,-1004 # 6940 <malloc+0xea4>
    1d34:	00004097          	auipc	ra,0x4
    1d38:	caa080e7          	jalr	-854(ra) # 59de <printf>
        exit(1);
    1d3c:	4505                	li	a0,1
    1d3e:	00004097          	auipc	ra,0x4
    1d42:	918080e7          	jalr	-1768(ra) # 5656 <exit>
  for(i = 0; i < N; i++){
    1d46:	2905                	addiw	s2,s2,1
    1d48:	2a05                	addiw	s4,s4,1
    1d4a:	2985                	addiw	s3,s3,1
    1d4c:	0ff9f993          	andi	s3,s3,255
    1d50:	47d1                	li	a5,20
    1d52:	02f90a63          	beq	s2,a5,1d86 <createdelete+0x1fc>
    for(pi = 0; pi < NCHILD; pi++){
    1d56:	84e2                	mv	s1,s8
    1d58:	bf69                	j	1cf2 <createdelete+0x168>
  for(i = 0; i < N; i++){
    1d5a:	2905                	addiw	s2,s2,1
    1d5c:	0ff97913          	andi	s2,s2,255
    1d60:	2985                	addiw	s3,s3,1
    1d62:	0ff9f993          	andi	s3,s3,255
    1d66:	03490863          	beq	s2,s4,1d96 <createdelete+0x20c>
  name[0] = name[1] = name[2] = 0;
    1d6a:	84d6                	mv	s1,s5
      name[0] = 'p' + i;
    1d6c:	f9240023          	sb	s2,-128(s0)
      name[1] = '0' + i;
    1d70:	f93400a3          	sb	s3,-127(s0)
      unlink(name);
    1d74:	f8040513          	addi	a0,s0,-128
    1d78:	00004097          	auipc	ra,0x4
    1d7c:	92e080e7          	jalr	-1746(ra) # 56a6 <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    1d80:	34fd                	addiw	s1,s1,-1
    1d82:	f4ed                	bnez	s1,1d6c <createdelete+0x1e2>
    1d84:	bfd9                	j	1d5a <createdelete+0x1d0>
    1d86:	03000993          	li	s3,48
    1d8a:	07000913          	li	s2,112
  name[0] = name[1] = name[2] = 0;
    1d8e:	4a91                	li	s5,4
  for(i = 0; i < N; i++){
    1d90:	08400a13          	li	s4,132
    1d94:	bfd9                	j	1d6a <createdelete+0x1e0>
}
    1d96:	60aa                	ld	ra,136(sp)
    1d98:	640a                	ld	s0,128(sp)
    1d9a:	74e6                	ld	s1,120(sp)
    1d9c:	7946                	ld	s2,112(sp)
    1d9e:	79a6                	ld	s3,104(sp)
    1da0:	7a06                	ld	s4,96(sp)
    1da2:	6ae6                	ld	s5,88(sp)
    1da4:	6b46                	ld	s6,80(sp)
    1da6:	6ba6                	ld	s7,72(sp)
    1da8:	6c06                	ld	s8,64(sp)
    1daa:	7ce2                	ld	s9,56(sp)
    1dac:	6149                	addi	sp,sp,144
    1dae:	8082                	ret

0000000000001db0 <linkunlink>:
{
    1db0:	711d                	addi	sp,sp,-96
    1db2:	ec86                	sd	ra,88(sp)
    1db4:	e8a2                	sd	s0,80(sp)
    1db6:	e4a6                	sd	s1,72(sp)
    1db8:	e0ca                	sd	s2,64(sp)
    1dba:	fc4e                	sd	s3,56(sp)
    1dbc:	f852                	sd	s4,48(sp)
    1dbe:	f456                	sd	s5,40(sp)
    1dc0:	f05a                	sd	s6,32(sp)
    1dc2:	ec5e                	sd	s7,24(sp)
    1dc4:	e862                	sd	s8,16(sp)
    1dc6:	e466                	sd	s9,8(sp)
    1dc8:	1080                	addi	s0,sp,96
    1dca:	84aa                	mv	s1,a0
  unlink("x");
    1dcc:	00004517          	auipc	a0,0x4
    1dd0:	17c50513          	addi	a0,a0,380 # 5f48 <malloc+0x4ac>
    1dd4:	00004097          	auipc	ra,0x4
    1dd8:	8d2080e7          	jalr	-1838(ra) # 56a6 <unlink>
  pid = fork();
    1ddc:	00004097          	auipc	ra,0x4
    1de0:	872080e7          	jalr	-1934(ra) # 564e <fork>
  if(pid < 0){
    1de4:	02054b63          	bltz	a0,1e1a <linkunlink+0x6a>
    1de8:	8c2a                	mv	s8,a0
  unsigned int x = (pid ? 1 : 97);
    1dea:	4c85                	li	s9,1
    1dec:	e119                	bnez	a0,1df2 <linkunlink+0x42>
    1dee:	06100c93          	li	s9,97
    1df2:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    1df6:	41c659b7          	lui	s3,0x41c65
    1dfa:	e6d9899b          	addiw	s3,s3,-403
    1dfe:	690d                	lui	s2,0x3
    1e00:	0399091b          	addiw	s2,s2,57
    if((x % 3) == 0){
    1e04:	4a0d                	li	s4,3
    } else if((x % 3) == 1){
    1e06:	4b05                	li	s6,1
      unlink("x");
    1e08:	00004a97          	auipc	s5,0x4
    1e0c:	140a8a93          	addi	s5,s5,320 # 5f48 <malloc+0x4ac>
      link("cat", "x");
    1e10:	00005b97          	auipc	s7,0x5
    1e14:	b58b8b93          	addi	s7,s7,-1192 # 6968 <malloc+0xecc>
    1e18:	a091                	j	1e5c <linkunlink+0xac>
    printf("%s: fork failed\n", s);
    1e1a:	85a6                	mv	a1,s1
    1e1c:	00005517          	auipc	a0,0x5
    1e20:	8f450513          	addi	a0,a0,-1804 # 6710 <malloc+0xc74>
    1e24:	00004097          	auipc	ra,0x4
    1e28:	bba080e7          	jalr	-1094(ra) # 59de <printf>
    exit(1);
    1e2c:	4505                	li	a0,1
    1e2e:	00004097          	auipc	ra,0x4
    1e32:	828080e7          	jalr	-2008(ra) # 5656 <exit>
      close(open("x", O_RDWR | O_CREATE));
    1e36:	20200593          	li	a1,514
    1e3a:	8556                	mv	a0,s5
    1e3c:	00004097          	auipc	ra,0x4
    1e40:	85a080e7          	jalr	-1958(ra) # 5696 <open>
    1e44:	00004097          	auipc	ra,0x4
    1e48:	83a080e7          	jalr	-1990(ra) # 567e <close>
    1e4c:	a031                	j	1e58 <linkunlink+0xa8>
      unlink("x");
    1e4e:	8556                	mv	a0,s5
    1e50:	00004097          	auipc	ra,0x4
    1e54:	856080e7          	jalr	-1962(ra) # 56a6 <unlink>
  for(i = 0; i < 100; i++){
    1e58:	34fd                	addiw	s1,s1,-1
    1e5a:	c09d                	beqz	s1,1e80 <linkunlink+0xd0>
    x = x * 1103515245 + 12345;
    1e5c:	033c87bb          	mulw	a5,s9,s3
    1e60:	012787bb          	addw	a5,a5,s2
    1e64:	00078c9b          	sext.w	s9,a5
    if((x % 3) == 0){
    1e68:	0347f7bb          	remuw	a5,a5,s4
    1e6c:	d7e9                	beqz	a5,1e36 <linkunlink+0x86>
    } else if((x % 3) == 1){
    1e6e:	ff6790e3          	bne	a5,s6,1e4e <linkunlink+0x9e>
      link("cat", "x");
    1e72:	85d6                	mv	a1,s5
    1e74:	855e                	mv	a0,s7
    1e76:	00004097          	auipc	ra,0x4
    1e7a:	840080e7          	jalr	-1984(ra) # 56b6 <link>
    1e7e:	bfe9                	j	1e58 <linkunlink+0xa8>
  if(pid)
    1e80:	020c0463          	beqz	s8,1ea8 <linkunlink+0xf8>
    wait(0);
    1e84:	4501                	li	a0,0
    1e86:	00003097          	auipc	ra,0x3
    1e8a:	7d8080e7          	jalr	2008(ra) # 565e <wait>
}
    1e8e:	60e6                	ld	ra,88(sp)
    1e90:	6446                	ld	s0,80(sp)
    1e92:	64a6                	ld	s1,72(sp)
    1e94:	6906                	ld	s2,64(sp)
    1e96:	79e2                	ld	s3,56(sp)
    1e98:	7a42                	ld	s4,48(sp)
    1e9a:	7aa2                	ld	s5,40(sp)
    1e9c:	7b02                	ld	s6,32(sp)
    1e9e:	6be2                	ld	s7,24(sp)
    1ea0:	6c42                	ld	s8,16(sp)
    1ea2:	6ca2                	ld	s9,8(sp)
    1ea4:	6125                	addi	sp,sp,96
    1ea6:	8082                	ret
    exit(0);
    1ea8:	4501                	li	a0,0
    1eaa:	00003097          	auipc	ra,0x3
    1eae:	7ac080e7          	jalr	1964(ra) # 5656 <exit>

0000000000001eb2 <manywrites>:
{
    1eb2:	711d                	addi	sp,sp,-96
    1eb4:	ec86                	sd	ra,88(sp)
    1eb6:	e8a2                	sd	s0,80(sp)
    1eb8:	e4a6                	sd	s1,72(sp)
    1eba:	e0ca                	sd	s2,64(sp)
    1ebc:	fc4e                	sd	s3,56(sp)
    1ebe:	f852                	sd	s4,48(sp)
    1ec0:	f456                	sd	s5,40(sp)
    1ec2:	f05a                	sd	s6,32(sp)
    1ec4:	ec5e                	sd	s7,24(sp)
    1ec6:	1080                	addi	s0,sp,96
    1ec8:	8aaa                	mv	s5,a0
  for(int ci = 0; ci < nchildren; ci++){
    1eca:	4901                	li	s2,0
    1ecc:	4991                	li	s3,4
    int pid = fork();
    1ece:	00003097          	auipc	ra,0x3
    1ed2:	780080e7          	jalr	1920(ra) # 564e <fork>
    1ed6:	84aa                	mv	s1,a0
    if(pid < 0){
    1ed8:	02054963          	bltz	a0,1f0a <manywrites+0x58>
    if(pid == 0){
    1edc:	c521                	beqz	a0,1f24 <manywrites+0x72>
  for(int ci = 0; ci < nchildren; ci++){
    1ede:	2905                	addiw	s2,s2,1
    1ee0:	ff3917e3          	bne	s2,s3,1ece <manywrites+0x1c>
    1ee4:	4491                	li	s1,4
    int st = 0;
    1ee6:	fa042423          	sw	zero,-88(s0)
    wait(&st);
    1eea:	fa840513          	addi	a0,s0,-88
    1eee:	00003097          	auipc	ra,0x3
    1ef2:	770080e7          	jalr	1904(ra) # 565e <wait>
    if(st != 0)
    1ef6:	fa842503          	lw	a0,-88(s0)
    1efa:	ed6d                	bnez	a0,1ff4 <manywrites+0x142>
  for(int ci = 0; ci < nchildren; ci++){
    1efc:	34fd                	addiw	s1,s1,-1
    1efe:	f4e5                	bnez	s1,1ee6 <manywrites+0x34>
  exit(0);
    1f00:	4501                	li	a0,0
    1f02:	00003097          	auipc	ra,0x3
    1f06:	754080e7          	jalr	1876(ra) # 5656 <exit>
      printf("fork failed\n");
    1f0a:	00005517          	auipc	a0,0x5
    1f0e:	c0e50513          	addi	a0,a0,-1010 # 6b18 <malloc+0x107c>
    1f12:	00004097          	auipc	ra,0x4
    1f16:	acc080e7          	jalr	-1332(ra) # 59de <printf>
      exit(1);
    1f1a:	4505                	li	a0,1
    1f1c:	00003097          	auipc	ra,0x3
    1f20:	73a080e7          	jalr	1850(ra) # 5656 <exit>
      name[0] = 'b';
    1f24:	06200793          	li	a5,98
    1f28:	faf40423          	sb	a5,-88(s0)
      name[1] = 'a' + ci;
    1f2c:	0619079b          	addiw	a5,s2,97
    1f30:	faf404a3          	sb	a5,-87(s0)
      name[2] = '\0';
    1f34:	fa040523          	sb	zero,-86(s0)
      unlink(name);
    1f38:	fa840513          	addi	a0,s0,-88
    1f3c:	00003097          	auipc	ra,0x3
    1f40:	76a080e7          	jalr	1898(ra) # 56a6 <unlink>
    1f44:	4b79                	li	s6,30
          int cc = write(fd, buf, sz);
    1f46:	0000ab97          	auipc	s7,0xa
    1f4a:	bfab8b93          	addi	s7,s7,-1030 # bb40 <buf>
        for(int i = 0; i < ci+1; i++){
    1f4e:	8a26                	mv	s4,s1
    1f50:	02094e63          	bltz	s2,1f8c <manywrites+0xda>
          int fd = open(name, O_CREATE | O_RDWR);
    1f54:	20200593          	li	a1,514
    1f58:	fa840513          	addi	a0,s0,-88
    1f5c:	00003097          	auipc	ra,0x3
    1f60:	73a080e7          	jalr	1850(ra) # 5696 <open>
    1f64:	89aa                	mv	s3,a0
          if(fd < 0){
    1f66:	04054763          	bltz	a0,1fb4 <manywrites+0x102>
          int cc = write(fd, buf, sz);
    1f6a:	660d                	lui	a2,0x3
    1f6c:	85de                	mv	a1,s7
    1f6e:	00003097          	auipc	ra,0x3
    1f72:	708080e7          	jalr	1800(ra) # 5676 <write>
          if(cc != sz){
    1f76:	678d                	lui	a5,0x3
    1f78:	04f51e63          	bne	a0,a5,1fd4 <manywrites+0x122>
          close(fd);
    1f7c:	854e                	mv	a0,s3
    1f7e:	00003097          	auipc	ra,0x3
    1f82:	700080e7          	jalr	1792(ra) # 567e <close>
        for(int i = 0; i < ci+1; i++){
    1f86:	2a05                	addiw	s4,s4,1
    1f88:	fd4956e3          	bge	s2,s4,1f54 <manywrites+0xa2>
        unlink(name);
    1f8c:	fa840513          	addi	a0,s0,-88
    1f90:	00003097          	auipc	ra,0x3
    1f94:	716080e7          	jalr	1814(ra) # 56a6 <unlink>
      for(int iters = 0; iters < howmany; iters++){
    1f98:	3b7d                	addiw	s6,s6,-1
    1f9a:	fa0b1ae3          	bnez	s6,1f4e <manywrites+0x9c>
      unlink(name);
    1f9e:	fa840513          	addi	a0,s0,-88
    1fa2:	00003097          	auipc	ra,0x3
    1fa6:	704080e7          	jalr	1796(ra) # 56a6 <unlink>
      exit(0);
    1faa:	4501                	li	a0,0
    1fac:	00003097          	auipc	ra,0x3
    1fb0:	6aa080e7          	jalr	1706(ra) # 5656 <exit>
            printf("%s: cannot create %s\n", s, name);
    1fb4:	fa840613          	addi	a2,s0,-88
    1fb8:	85d6                	mv	a1,s5
    1fba:	00005517          	auipc	a0,0x5
    1fbe:	9b650513          	addi	a0,a0,-1610 # 6970 <malloc+0xed4>
    1fc2:	00004097          	auipc	ra,0x4
    1fc6:	a1c080e7          	jalr	-1508(ra) # 59de <printf>
            exit(1);
    1fca:	4505                	li	a0,1
    1fcc:	00003097          	auipc	ra,0x3
    1fd0:	68a080e7          	jalr	1674(ra) # 5656 <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    1fd4:	86aa                	mv	a3,a0
    1fd6:	660d                	lui	a2,0x3
    1fd8:	85d6                	mv	a1,s5
    1fda:	00004517          	auipc	a0,0x4
    1fde:	fbe50513          	addi	a0,a0,-66 # 5f98 <malloc+0x4fc>
    1fe2:	00004097          	auipc	ra,0x4
    1fe6:	9fc080e7          	jalr	-1540(ra) # 59de <printf>
            exit(1);
    1fea:	4505                	li	a0,1
    1fec:	00003097          	auipc	ra,0x3
    1ff0:	66a080e7          	jalr	1642(ra) # 5656 <exit>
      exit(st);
    1ff4:	00003097          	auipc	ra,0x3
    1ff8:	662080e7          	jalr	1634(ra) # 5656 <exit>

0000000000001ffc <forktest>:
{
    1ffc:	7179                	addi	sp,sp,-48
    1ffe:	f406                	sd	ra,40(sp)
    2000:	f022                	sd	s0,32(sp)
    2002:	ec26                	sd	s1,24(sp)
    2004:	e84a                	sd	s2,16(sp)
    2006:	e44e                	sd	s3,8(sp)
    2008:	1800                	addi	s0,sp,48
    200a:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
    200c:	4481                	li	s1,0
    200e:	3e800913          	li	s2,1000
    pid = fork();
    2012:	00003097          	auipc	ra,0x3
    2016:	63c080e7          	jalr	1596(ra) # 564e <fork>
    if(pid < 0)
    201a:	02054863          	bltz	a0,204a <forktest+0x4e>
    if(pid == 0)
    201e:	c115                	beqz	a0,2042 <forktest+0x46>
  for(n=0; n<N; n++){
    2020:	2485                	addiw	s1,s1,1
    2022:	ff2498e3          	bne	s1,s2,2012 <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    2026:	85ce                	mv	a1,s3
    2028:	00005517          	auipc	a0,0x5
    202c:	97850513          	addi	a0,a0,-1672 # 69a0 <malloc+0xf04>
    2030:	00004097          	auipc	ra,0x4
    2034:	9ae080e7          	jalr	-1618(ra) # 59de <printf>
    exit(1);
    2038:	4505                	li	a0,1
    203a:	00003097          	auipc	ra,0x3
    203e:	61c080e7          	jalr	1564(ra) # 5656 <exit>
      exit(0);
    2042:	00003097          	auipc	ra,0x3
    2046:	614080e7          	jalr	1556(ra) # 5656 <exit>
  if (n == 0) {
    204a:	cc9d                	beqz	s1,2088 <forktest+0x8c>
  if(n == N){
    204c:	3e800793          	li	a5,1000
    2050:	fcf48be3          	beq	s1,a5,2026 <forktest+0x2a>
  for(; n > 0; n--){
    2054:	00905b63          	blez	s1,206a <forktest+0x6e>
    if(wait(0) < 0){
    2058:	4501                	li	a0,0
    205a:	00003097          	auipc	ra,0x3
    205e:	604080e7          	jalr	1540(ra) # 565e <wait>
    2062:	04054163          	bltz	a0,20a4 <forktest+0xa8>
  for(; n > 0; n--){
    2066:	34fd                	addiw	s1,s1,-1
    2068:	f8e5                	bnez	s1,2058 <forktest+0x5c>
  if(wait(0) != -1){
    206a:	4501                	li	a0,0
    206c:	00003097          	auipc	ra,0x3
    2070:	5f2080e7          	jalr	1522(ra) # 565e <wait>
    2074:	57fd                	li	a5,-1
    2076:	04f51563          	bne	a0,a5,20c0 <forktest+0xc4>
}
    207a:	70a2                	ld	ra,40(sp)
    207c:	7402                	ld	s0,32(sp)
    207e:	64e2                	ld	s1,24(sp)
    2080:	6942                	ld	s2,16(sp)
    2082:	69a2                	ld	s3,8(sp)
    2084:	6145                	addi	sp,sp,48
    2086:	8082                	ret
    printf("%s: no fork at all!\n", s);
    2088:	85ce                	mv	a1,s3
    208a:	00005517          	auipc	a0,0x5
    208e:	8fe50513          	addi	a0,a0,-1794 # 6988 <malloc+0xeec>
    2092:	00004097          	auipc	ra,0x4
    2096:	94c080e7          	jalr	-1716(ra) # 59de <printf>
    exit(1);
    209a:	4505                	li	a0,1
    209c:	00003097          	auipc	ra,0x3
    20a0:	5ba080e7          	jalr	1466(ra) # 5656 <exit>
      printf("%s: wait stopped early\n", s);
    20a4:	85ce                	mv	a1,s3
    20a6:	00005517          	auipc	a0,0x5
    20aa:	92250513          	addi	a0,a0,-1758 # 69c8 <malloc+0xf2c>
    20ae:	00004097          	auipc	ra,0x4
    20b2:	930080e7          	jalr	-1744(ra) # 59de <printf>
      exit(1);
    20b6:	4505                	li	a0,1
    20b8:	00003097          	auipc	ra,0x3
    20bc:	59e080e7          	jalr	1438(ra) # 5656 <exit>
    printf("%s: wait got too many\n", s);
    20c0:	85ce                	mv	a1,s3
    20c2:	00005517          	auipc	a0,0x5
    20c6:	91e50513          	addi	a0,a0,-1762 # 69e0 <malloc+0xf44>
    20ca:	00004097          	auipc	ra,0x4
    20ce:	914080e7          	jalr	-1772(ra) # 59de <printf>
    exit(1);
    20d2:	4505                	li	a0,1
    20d4:	00003097          	auipc	ra,0x3
    20d8:	582080e7          	jalr	1410(ra) # 5656 <exit>

00000000000020dc <kernmem>:
{
    20dc:	715d                	addi	sp,sp,-80
    20de:	e486                	sd	ra,72(sp)
    20e0:	e0a2                	sd	s0,64(sp)
    20e2:	fc26                	sd	s1,56(sp)
    20e4:	f84a                	sd	s2,48(sp)
    20e6:	f44e                	sd	s3,40(sp)
    20e8:	f052                	sd	s4,32(sp)
    20ea:	ec56                	sd	s5,24(sp)
    20ec:	0880                	addi	s0,sp,80
    20ee:	8a2a                	mv	s4,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    20f0:	4485                	li	s1,1
    20f2:	04fe                	slli	s1,s1,0x1f
    if(xstatus != -1)  // did kernel kill child?
    20f4:	5afd                	li	s5,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    20f6:	69b1                	lui	s3,0xc
    20f8:	35098993          	addi	s3,s3,848 # c350 <buf+0x810>
    20fc:	1003d937          	lui	s2,0x1003d
    2100:	090e                	slli	s2,s2,0x3
    2102:	48090913          	addi	s2,s2,1152 # 1003d480 <__BSS_END__+0x1002e930>
    pid = fork();
    2106:	00003097          	auipc	ra,0x3
    210a:	548080e7          	jalr	1352(ra) # 564e <fork>
    if(pid < 0){
    210e:	02054963          	bltz	a0,2140 <kernmem+0x64>
    if(pid == 0){
    2112:	c529                	beqz	a0,215c <kernmem+0x80>
    wait(&xstatus);
    2114:	fbc40513          	addi	a0,s0,-68
    2118:	00003097          	auipc	ra,0x3
    211c:	546080e7          	jalr	1350(ra) # 565e <wait>
    if(xstatus != -1)  // did kernel kill child?
    2120:	fbc42783          	lw	a5,-68(s0)
    2124:	05579d63          	bne	a5,s5,217e <kernmem+0xa2>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    2128:	94ce                	add	s1,s1,s3
    212a:	fd249ee3          	bne	s1,s2,2106 <kernmem+0x2a>
}
    212e:	60a6                	ld	ra,72(sp)
    2130:	6406                	ld	s0,64(sp)
    2132:	74e2                	ld	s1,56(sp)
    2134:	7942                	ld	s2,48(sp)
    2136:	79a2                	ld	s3,40(sp)
    2138:	7a02                	ld	s4,32(sp)
    213a:	6ae2                	ld	s5,24(sp)
    213c:	6161                	addi	sp,sp,80
    213e:	8082                	ret
      printf("%s: fork failed\n", s);
    2140:	85d2                	mv	a1,s4
    2142:	00004517          	auipc	a0,0x4
    2146:	5ce50513          	addi	a0,a0,1486 # 6710 <malloc+0xc74>
    214a:	00004097          	auipc	ra,0x4
    214e:	894080e7          	jalr	-1900(ra) # 59de <printf>
      exit(1);
    2152:	4505                	li	a0,1
    2154:	00003097          	auipc	ra,0x3
    2158:	502080e7          	jalr	1282(ra) # 5656 <exit>
      printf("%s: oops could read %x = %x\n", s, a, *a);
    215c:	0004c683          	lbu	a3,0(s1)
    2160:	8626                	mv	a2,s1
    2162:	85d2                	mv	a1,s4
    2164:	00005517          	auipc	a0,0x5
    2168:	89450513          	addi	a0,a0,-1900 # 69f8 <malloc+0xf5c>
    216c:	00004097          	auipc	ra,0x4
    2170:	872080e7          	jalr	-1934(ra) # 59de <printf>
      exit(1);
    2174:	4505                	li	a0,1
    2176:	00003097          	auipc	ra,0x3
    217a:	4e0080e7          	jalr	1248(ra) # 5656 <exit>
      exit(1);
    217e:	4505                	li	a0,1
    2180:	00003097          	auipc	ra,0x3
    2184:	4d6080e7          	jalr	1238(ra) # 5656 <exit>

0000000000002188 <bigargtest>:
{
    2188:	7179                	addi	sp,sp,-48
    218a:	f406                	sd	ra,40(sp)
    218c:	f022                	sd	s0,32(sp)
    218e:	ec26                	sd	s1,24(sp)
    2190:	1800                	addi	s0,sp,48
    2192:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    2194:	00005517          	auipc	a0,0x5
    2198:	88450513          	addi	a0,a0,-1916 # 6a18 <malloc+0xf7c>
    219c:	00003097          	auipc	ra,0x3
    21a0:	50a080e7          	jalr	1290(ra) # 56a6 <unlink>
  pid = fork();
    21a4:	00003097          	auipc	ra,0x3
    21a8:	4aa080e7          	jalr	1194(ra) # 564e <fork>
  if(pid == 0){
    21ac:	c121                	beqz	a0,21ec <bigargtest+0x64>
  } else if(pid < 0){
    21ae:	0a054063          	bltz	a0,224e <bigargtest+0xc6>
  wait(&xstatus);
    21b2:	fdc40513          	addi	a0,s0,-36
    21b6:	00003097          	auipc	ra,0x3
    21ba:	4a8080e7          	jalr	1192(ra) # 565e <wait>
  if(xstatus != 0)
    21be:	fdc42503          	lw	a0,-36(s0)
    21c2:	e545                	bnez	a0,226a <bigargtest+0xe2>
  fd = open("bigarg-ok", 0);
    21c4:	4581                	li	a1,0
    21c6:	00005517          	auipc	a0,0x5
    21ca:	85250513          	addi	a0,a0,-1966 # 6a18 <malloc+0xf7c>
    21ce:	00003097          	auipc	ra,0x3
    21d2:	4c8080e7          	jalr	1224(ra) # 5696 <open>
  if(fd < 0){
    21d6:	08054e63          	bltz	a0,2272 <bigargtest+0xea>
  close(fd);
    21da:	00003097          	auipc	ra,0x3
    21de:	4a4080e7          	jalr	1188(ra) # 567e <close>
}
    21e2:	70a2                	ld	ra,40(sp)
    21e4:	7402                	ld	s0,32(sp)
    21e6:	64e2                	ld	s1,24(sp)
    21e8:	6145                	addi	sp,sp,48
    21ea:	8082                	ret
    21ec:	00006797          	auipc	a5,0x6
    21f0:	13c78793          	addi	a5,a5,316 # 8328 <args.1844>
    21f4:	00006697          	auipc	a3,0x6
    21f8:	22c68693          	addi	a3,a3,556 # 8420 <args.1844+0xf8>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    21fc:	00005717          	auipc	a4,0x5
    2200:	82c70713          	addi	a4,a4,-2004 # 6a28 <malloc+0xf8c>
    2204:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    2206:	07a1                	addi	a5,a5,8
    2208:	fed79ee3          	bne	a5,a3,2204 <bigargtest+0x7c>
    args[MAXARG-1] = 0;
    220c:	00006597          	auipc	a1,0x6
    2210:	11c58593          	addi	a1,a1,284 # 8328 <args.1844>
    2214:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    2218:	00004517          	auipc	a0,0x4
    221c:	cc050513          	addi	a0,a0,-832 # 5ed8 <malloc+0x43c>
    2220:	00003097          	auipc	ra,0x3
    2224:	46e080e7          	jalr	1134(ra) # 568e <exec>
    fd = open("bigarg-ok", O_CREATE);
    2228:	20000593          	li	a1,512
    222c:	00004517          	auipc	a0,0x4
    2230:	7ec50513          	addi	a0,a0,2028 # 6a18 <malloc+0xf7c>
    2234:	00003097          	auipc	ra,0x3
    2238:	462080e7          	jalr	1122(ra) # 5696 <open>
    close(fd);
    223c:	00003097          	auipc	ra,0x3
    2240:	442080e7          	jalr	1090(ra) # 567e <close>
    exit(0);
    2244:	4501                	li	a0,0
    2246:	00003097          	auipc	ra,0x3
    224a:	410080e7          	jalr	1040(ra) # 5656 <exit>
    printf("%s: bigargtest: fork failed\n", s);
    224e:	85a6                	mv	a1,s1
    2250:	00005517          	auipc	a0,0x5
    2254:	8b850513          	addi	a0,a0,-1864 # 6b08 <malloc+0x106c>
    2258:	00003097          	auipc	ra,0x3
    225c:	786080e7          	jalr	1926(ra) # 59de <printf>
    exit(1);
    2260:	4505                	li	a0,1
    2262:	00003097          	auipc	ra,0x3
    2266:	3f4080e7          	jalr	1012(ra) # 5656 <exit>
    exit(xstatus);
    226a:	00003097          	auipc	ra,0x3
    226e:	3ec080e7          	jalr	1004(ra) # 5656 <exit>
    printf("%s: bigarg test failed!\n", s);
    2272:	85a6                	mv	a1,s1
    2274:	00005517          	auipc	a0,0x5
    2278:	8b450513          	addi	a0,a0,-1868 # 6b28 <malloc+0x108c>
    227c:	00003097          	auipc	ra,0x3
    2280:	762080e7          	jalr	1890(ra) # 59de <printf>
    exit(1);
    2284:	4505                	li	a0,1
    2286:	00003097          	auipc	ra,0x3
    228a:	3d0080e7          	jalr	976(ra) # 5656 <exit>

000000000000228e <stacktest>:
{
    228e:	7179                	addi	sp,sp,-48
    2290:	f406                	sd	ra,40(sp)
    2292:	f022                	sd	s0,32(sp)
    2294:	ec26                	sd	s1,24(sp)
    2296:	1800                	addi	s0,sp,48
    2298:	84aa                	mv	s1,a0
  pid = fork();
    229a:	00003097          	auipc	ra,0x3
    229e:	3b4080e7          	jalr	948(ra) # 564e <fork>
  if(pid == 0) {
    22a2:	c115                	beqz	a0,22c6 <stacktest+0x38>
  } else if(pid < 0){
    22a4:	04054463          	bltz	a0,22ec <stacktest+0x5e>
  wait(&xstatus);
    22a8:	fdc40513          	addi	a0,s0,-36
    22ac:	00003097          	auipc	ra,0x3
    22b0:	3b2080e7          	jalr	946(ra) # 565e <wait>
  if(xstatus == -1)  // kernel killed child?
    22b4:	fdc42503          	lw	a0,-36(s0)
    22b8:	57fd                	li	a5,-1
    22ba:	04f50763          	beq	a0,a5,2308 <stacktest+0x7a>
    exit(xstatus);
    22be:	00003097          	auipc	ra,0x3
    22c2:	398080e7          	jalr	920(ra) # 5656 <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    22c6:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %p\n", s, *sp);
    22c8:	77fd                	lui	a5,0xfffff
    22ca:	97ba                	add	a5,a5,a4
    22cc:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <__BSS_END__+0xffffffffffff04b0>
    22d0:	85a6                	mv	a1,s1
    22d2:	00005517          	auipc	a0,0x5
    22d6:	87650513          	addi	a0,a0,-1930 # 6b48 <malloc+0x10ac>
    22da:	00003097          	auipc	ra,0x3
    22de:	704080e7          	jalr	1796(ra) # 59de <printf>
    exit(1);
    22e2:	4505                	li	a0,1
    22e4:	00003097          	auipc	ra,0x3
    22e8:	372080e7          	jalr	882(ra) # 5656 <exit>
    printf("%s: fork failed\n", s);
    22ec:	85a6                	mv	a1,s1
    22ee:	00004517          	auipc	a0,0x4
    22f2:	42250513          	addi	a0,a0,1058 # 6710 <malloc+0xc74>
    22f6:	00003097          	auipc	ra,0x3
    22fa:	6e8080e7          	jalr	1768(ra) # 59de <printf>
    exit(1);
    22fe:	4505                	li	a0,1
    2300:	00003097          	auipc	ra,0x3
    2304:	356080e7          	jalr	854(ra) # 5656 <exit>
    exit(0);
    2308:	4501                	li	a0,0
    230a:	00003097          	auipc	ra,0x3
    230e:	34c080e7          	jalr	844(ra) # 5656 <exit>

0000000000002312 <copyinstr3>:
{
    2312:	7179                	addi	sp,sp,-48
    2314:	f406                	sd	ra,40(sp)
    2316:	f022                	sd	s0,32(sp)
    2318:	ec26                	sd	s1,24(sp)
    231a:	1800                	addi	s0,sp,48
  sbrk(8192);
    231c:	6509                	lui	a0,0x2
    231e:	00003097          	auipc	ra,0x3
    2322:	3c0080e7          	jalr	960(ra) # 56de <sbrk>
  uint64 top = (uint64) sbrk(0);
    2326:	4501                	li	a0,0
    2328:	00003097          	auipc	ra,0x3
    232c:	3b6080e7          	jalr	950(ra) # 56de <sbrk>
  if((top % PGSIZE) != 0){
    2330:	03451793          	slli	a5,a0,0x34
    2334:	e3c9                	bnez	a5,23b6 <copyinstr3+0xa4>
  top = (uint64) sbrk(0);
    2336:	4501                	li	a0,0
    2338:	00003097          	auipc	ra,0x3
    233c:	3a6080e7          	jalr	934(ra) # 56de <sbrk>
  if(top % PGSIZE){
    2340:	03451793          	slli	a5,a0,0x34
    2344:	e3d9                	bnez	a5,23ca <copyinstr3+0xb8>
  char *b = (char *) (top - 1);
    2346:	fff50493          	addi	s1,a0,-1 # 1fff <forktest+0x3>
  *b = 'x';
    234a:	07800793          	li	a5,120
    234e:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    2352:	8526                	mv	a0,s1
    2354:	00003097          	auipc	ra,0x3
    2358:	352080e7          	jalr	850(ra) # 56a6 <unlink>
  if(ret != -1){
    235c:	57fd                	li	a5,-1
    235e:	08f51363          	bne	a0,a5,23e4 <copyinstr3+0xd2>
  int fd = open(b, O_CREATE | O_WRONLY);
    2362:	20100593          	li	a1,513
    2366:	8526                	mv	a0,s1
    2368:	00003097          	auipc	ra,0x3
    236c:	32e080e7          	jalr	814(ra) # 5696 <open>
  if(fd != -1){
    2370:	57fd                	li	a5,-1
    2372:	08f51863          	bne	a0,a5,2402 <copyinstr3+0xf0>
  ret = link(b, b);
    2376:	85a6                	mv	a1,s1
    2378:	8526                	mv	a0,s1
    237a:	00003097          	auipc	ra,0x3
    237e:	33c080e7          	jalr	828(ra) # 56b6 <link>
  if(ret != -1){
    2382:	57fd                	li	a5,-1
    2384:	08f51e63          	bne	a0,a5,2420 <copyinstr3+0x10e>
  char *args[] = { "xx", 0 };
    2388:	00005797          	auipc	a5,0x5
    238c:	45878793          	addi	a5,a5,1112 # 77e0 <malloc+0x1d44>
    2390:	fcf43823          	sd	a5,-48(s0)
    2394:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    2398:	fd040593          	addi	a1,s0,-48
    239c:	8526                	mv	a0,s1
    239e:	00003097          	auipc	ra,0x3
    23a2:	2f0080e7          	jalr	752(ra) # 568e <exec>
  if(ret != -1){
    23a6:	57fd                	li	a5,-1
    23a8:	08f51c63          	bne	a0,a5,2440 <copyinstr3+0x12e>
}
    23ac:	70a2                	ld	ra,40(sp)
    23ae:	7402                	ld	s0,32(sp)
    23b0:	64e2                	ld	s1,24(sp)
    23b2:	6145                	addi	sp,sp,48
    23b4:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    23b6:	0347d513          	srli	a0,a5,0x34
    23ba:	6785                	lui	a5,0x1
    23bc:	40a7853b          	subw	a0,a5,a0
    23c0:	00003097          	auipc	ra,0x3
    23c4:	31e080e7          	jalr	798(ra) # 56de <sbrk>
    23c8:	b7bd                	j	2336 <copyinstr3+0x24>
    printf("oops\n");
    23ca:	00004517          	auipc	a0,0x4
    23ce:	7a650513          	addi	a0,a0,1958 # 6b70 <malloc+0x10d4>
    23d2:	00003097          	auipc	ra,0x3
    23d6:	60c080e7          	jalr	1548(ra) # 59de <printf>
    exit(1);
    23da:	4505                	li	a0,1
    23dc:	00003097          	auipc	ra,0x3
    23e0:	27a080e7          	jalr	634(ra) # 5656 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    23e4:	862a                	mv	a2,a0
    23e6:	85a6                	mv	a1,s1
    23e8:	00004517          	auipc	a0,0x4
    23ec:	24850513          	addi	a0,a0,584 # 6630 <malloc+0xb94>
    23f0:	00003097          	auipc	ra,0x3
    23f4:	5ee080e7          	jalr	1518(ra) # 59de <printf>
    exit(1);
    23f8:	4505                	li	a0,1
    23fa:	00003097          	auipc	ra,0x3
    23fe:	25c080e7          	jalr	604(ra) # 5656 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    2402:	862a                	mv	a2,a0
    2404:	85a6                	mv	a1,s1
    2406:	00004517          	auipc	a0,0x4
    240a:	24a50513          	addi	a0,a0,586 # 6650 <malloc+0xbb4>
    240e:	00003097          	auipc	ra,0x3
    2412:	5d0080e7          	jalr	1488(ra) # 59de <printf>
    exit(1);
    2416:	4505                	li	a0,1
    2418:	00003097          	auipc	ra,0x3
    241c:	23e080e7          	jalr	574(ra) # 5656 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    2420:	86aa                	mv	a3,a0
    2422:	8626                	mv	a2,s1
    2424:	85a6                	mv	a1,s1
    2426:	00004517          	auipc	a0,0x4
    242a:	24a50513          	addi	a0,a0,586 # 6670 <malloc+0xbd4>
    242e:	00003097          	auipc	ra,0x3
    2432:	5b0080e7          	jalr	1456(ra) # 59de <printf>
    exit(1);
    2436:	4505                	li	a0,1
    2438:	00003097          	auipc	ra,0x3
    243c:	21e080e7          	jalr	542(ra) # 5656 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    2440:	567d                	li	a2,-1
    2442:	85a6                	mv	a1,s1
    2444:	00004517          	auipc	a0,0x4
    2448:	25450513          	addi	a0,a0,596 # 6698 <malloc+0xbfc>
    244c:	00003097          	auipc	ra,0x3
    2450:	592080e7          	jalr	1426(ra) # 59de <printf>
    exit(1);
    2454:	4505                	li	a0,1
    2456:	00003097          	auipc	ra,0x3
    245a:	200080e7          	jalr	512(ra) # 5656 <exit>

000000000000245e <rwsbrk>:
{
    245e:	1101                	addi	sp,sp,-32
    2460:	ec06                	sd	ra,24(sp)
    2462:	e822                	sd	s0,16(sp)
    2464:	e426                	sd	s1,8(sp)
    2466:	e04a                	sd	s2,0(sp)
    2468:	1000                	addi	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    246a:	6509                	lui	a0,0x2
    246c:	00003097          	auipc	ra,0x3
    2470:	272080e7          	jalr	626(ra) # 56de <sbrk>
  if(a == 0xffffffffffffffffLL) {
    2474:	57fd                	li	a5,-1
    2476:	06f50363          	beq	a0,a5,24dc <rwsbrk+0x7e>
    247a:	84aa                	mv	s1,a0
  if ((uint64) sbrk(-8192) ==  0xffffffffffffffffLL) {
    247c:	7579                	lui	a0,0xffffe
    247e:	00003097          	auipc	ra,0x3
    2482:	260080e7          	jalr	608(ra) # 56de <sbrk>
    2486:	57fd                	li	a5,-1
    2488:	06f50763          	beq	a0,a5,24f6 <rwsbrk+0x98>
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    248c:	20100593          	li	a1,513
    2490:	00003517          	auipc	a0,0x3
    2494:	76850513          	addi	a0,a0,1896 # 5bf8 <malloc+0x15c>
    2498:	00003097          	auipc	ra,0x3
    249c:	1fe080e7          	jalr	510(ra) # 5696 <open>
    24a0:	892a                	mv	s2,a0
  if(fd < 0){
    24a2:	06054763          	bltz	a0,2510 <rwsbrk+0xb2>
  n = write(fd, (void*)(a+4096), 1024);
    24a6:	6505                	lui	a0,0x1
    24a8:	94aa                	add	s1,s1,a0
    24aa:	40000613          	li	a2,1024
    24ae:	85a6                	mv	a1,s1
    24b0:	854a                	mv	a0,s2
    24b2:	00003097          	auipc	ra,0x3
    24b6:	1c4080e7          	jalr	452(ra) # 5676 <write>
    24ba:	862a                	mv	a2,a0
  if(n >= 0){
    24bc:	06054763          	bltz	a0,252a <rwsbrk+0xcc>
    printf("write(fd, %p, 1024) returned %d, not -1\n", a+4096, n);
    24c0:	85a6                	mv	a1,s1
    24c2:	00004517          	auipc	a0,0x4
    24c6:	70650513          	addi	a0,a0,1798 # 6bc8 <malloc+0x112c>
    24ca:	00003097          	auipc	ra,0x3
    24ce:	514080e7          	jalr	1300(ra) # 59de <printf>
    exit(1);
    24d2:	4505                	li	a0,1
    24d4:	00003097          	auipc	ra,0x3
    24d8:	182080e7          	jalr	386(ra) # 5656 <exit>
    printf("sbrk(rwsbrk) failed\n");
    24dc:	00004517          	auipc	a0,0x4
    24e0:	69c50513          	addi	a0,a0,1692 # 6b78 <malloc+0x10dc>
    24e4:	00003097          	auipc	ra,0x3
    24e8:	4fa080e7          	jalr	1274(ra) # 59de <printf>
    exit(1);
    24ec:	4505                	li	a0,1
    24ee:	00003097          	auipc	ra,0x3
    24f2:	168080e7          	jalr	360(ra) # 5656 <exit>
    printf("sbrk(rwsbrk) shrink failed\n");
    24f6:	00004517          	auipc	a0,0x4
    24fa:	69a50513          	addi	a0,a0,1690 # 6b90 <malloc+0x10f4>
    24fe:	00003097          	auipc	ra,0x3
    2502:	4e0080e7          	jalr	1248(ra) # 59de <printf>
    exit(1);
    2506:	4505                	li	a0,1
    2508:	00003097          	auipc	ra,0x3
    250c:	14e080e7          	jalr	334(ra) # 5656 <exit>
    printf("open(rwsbrk) failed\n");
    2510:	00004517          	auipc	a0,0x4
    2514:	6a050513          	addi	a0,a0,1696 # 6bb0 <malloc+0x1114>
    2518:	00003097          	auipc	ra,0x3
    251c:	4c6080e7          	jalr	1222(ra) # 59de <printf>
    exit(1);
    2520:	4505                	li	a0,1
    2522:	00003097          	auipc	ra,0x3
    2526:	134080e7          	jalr	308(ra) # 5656 <exit>
  close(fd);
    252a:	854a                	mv	a0,s2
    252c:	00003097          	auipc	ra,0x3
    2530:	152080e7          	jalr	338(ra) # 567e <close>
  unlink("rwsbrk");
    2534:	00003517          	auipc	a0,0x3
    2538:	6c450513          	addi	a0,a0,1732 # 5bf8 <malloc+0x15c>
    253c:	00003097          	auipc	ra,0x3
    2540:	16a080e7          	jalr	362(ra) # 56a6 <unlink>
  fd = open("README", O_RDONLY);
    2544:	4581                	li	a1,0
    2546:	00004517          	auipc	a0,0x4
    254a:	b2a50513          	addi	a0,a0,-1238 # 6070 <malloc+0x5d4>
    254e:	00003097          	auipc	ra,0x3
    2552:	148080e7          	jalr	328(ra) # 5696 <open>
    2556:	892a                	mv	s2,a0
  if(fd < 0){
    2558:	02054963          	bltz	a0,258a <rwsbrk+0x12c>
  n = read(fd, (void*)(a+4096), 10);
    255c:	4629                	li	a2,10
    255e:	85a6                	mv	a1,s1
    2560:	00003097          	auipc	ra,0x3
    2564:	10e080e7          	jalr	270(ra) # 566e <read>
    2568:	862a                	mv	a2,a0
  if(n >= 0){
    256a:	02054d63          	bltz	a0,25a4 <rwsbrk+0x146>
    printf("read(fd, %p, 10) returned %d, not -1\n", a+4096, n);
    256e:	85a6                	mv	a1,s1
    2570:	00004517          	auipc	a0,0x4
    2574:	68850513          	addi	a0,a0,1672 # 6bf8 <malloc+0x115c>
    2578:	00003097          	auipc	ra,0x3
    257c:	466080e7          	jalr	1126(ra) # 59de <printf>
    exit(1);
    2580:	4505                	li	a0,1
    2582:	00003097          	auipc	ra,0x3
    2586:	0d4080e7          	jalr	212(ra) # 5656 <exit>
    printf("open(rwsbrk) failed\n");
    258a:	00004517          	auipc	a0,0x4
    258e:	62650513          	addi	a0,a0,1574 # 6bb0 <malloc+0x1114>
    2592:	00003097          	auipc	ra,0x3
    2596:	44c080e7          	jalr	1100(ra) # 59de <printf>
    exit(1);
    259a:	4505                	li	a0,1
    259c:	00003097          	auipc	ra,0x3
    25a0:	0ba080e7          	jalr	186(ra) # 5656 <exit>
  close(fd);
    25a4:	854a                	mv	a0,s2
    25a6:	00003097          	auipc	ra,0x3
    25aa:	0d8080e7          	jalr	216(ra) # 567e <close>
  exit(0);
    25ae:	4501                	li	a0,0
    25b0:	00003097          	auipc	ra,0x3
    25b4:	0a6080e7          	jalr	166(ra) # 5656 <exit>

00000000000025b8 <sbrkbasic>:
{
    25b8:	715d                	addi	sp,sp,-80
    25ba:	e486                	sd	ra,72(sp)
    25bc:	e0a2                	sd	s0,64(sp)
    25be:	fc26                	sd	s1,56(sp)
    25c0:	f84a                	sd	s2,48(sp)
    25c2:	f44e                	sd	s3,40(sp)
    25c4:	f052                	sd	s4,32(sp)
    25c6:	ec56                	sd	s5,24(sp)
    25c8:	0880                	addi	s0,sp,80
    25ca:	8a2a                	mv	s4,a0
  pid = fork();
    25cc:	00003097          	auipc	ra,0x3
    25d0:	082080e7          	jalr	130(ra) # 564e <fork>
  if(pid < 0){
    25d4:	02054c63          	bltz	a0,260c <sbrkbasic+0x54>
  if(pid == 0){
    25d8:	ed21                	bnez	a0,2630 <sbrkbasic+0x78>
    a = sbrk(TOOMUCH);
    25da:	40000537          	lui	a0,0x40000
    25de:	00003097          	auipc	ra,0x3
    25e2:	100080e7          	jalr	256(ra) # 56de <sbrk>
    if(a == (char*)0xffffffffffffffffL){
    25e6:	57fd                	li	a5,-1
    25e8:	02f50f63          	beq	a0,a5,2626 <sbrkbasic+0x6e>
    for(b = a; b < a+TOOMUCH; b += 4096){
    25ec:	400007b7          	lui	a5,0x40000
    25f0:	97aa                	add	a5,a5,a0
      *b = 99;
    25f2:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += 4096){
    25f6:	6705                	lui	a4,0x1
      *b = 99;
    25f8:	00d50023          	sb	a3,0(a0) # 40000000 <__BSS_END__+0x3fff14b0>
    for(b = a; b < a+TOOMUCH; b += 4096){
    25fc:	953a                	add	a0,a0,a4
    25fe:	fef51de3          	bne	a0,a5,25f8 <sbrkbasic+0x40>
    exit(1);
    2602:	4505                	li	a0,1
    2604:	00003097          	auipc	ra,0x3
    2608:	052080e7          	jalr	82(ra) # 5656 <exit>
    printf("fork failed in sbrkbasic\n");
    260c:	00004517          	auipc	a0,0x4
    2610:	61450513          	addi	a0,a0,1556 # 6c20 <malloc+0x1184>
    2614:	00003097          	auipc	ra,0x3
    2618:	3ca080e7          	jalr	970(ra) # 59de <printf>
    exit(1);
    261c:	4505                	li	a0,1
    261e:	00003097          	auipc	ra,0x3
    2622:	038080e7          	jalr	56(ra) # 5656 <exit>
      exit(0);
    2626:	4501                	li	a0,0
    2628:	00003097          	auipc	ra,0x3
    262c:	02e080e7          	jalr	46(ra) # 5656 <exit>
  wait(&xstatus);
    2630:	fbc40513          	addi	a0,s0,-68
    2634:	00003097          	auipc	ra,0x3
    2638:	02a080e7          	jalr	42(ra) # 565e <wait>
  if(xstatus == 1){
    263c:	fbc42703          	lw	a4,-68(s0)
    2640:	4785                	li	a5,1
    2642:	00f70e63          	beq	a4,a5,265e <sbrkbasic+0xa6>
  a = sbrk(0);
    2646:	4501                	li	a0,0
    2648:	00003097          	auipc	ra,0x3
    264c:	096080e7          	jalr	150(ra) # 56de <sbrk>
    2650:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    2652:	4901                	li	s2,0
    *b = 1;
    2654:	4a85                	li	s5,1
  for(i = 0; i < 5000; i++){
    2656:	6985                	lui	s3,0x1
    2658:	38898993          	addi	s3,s3,904 # 1388 <copyinstr2+0x1d6>
    265c:	a005                	j	267c <sbrkbasic+0xc4>
    printf("%s: too much memory allocated!\n", s);
    265e:	85d2                	mv	a1,s4
    2660:	00004517          	auipc	a0,0x4
    2664:	5e050513          	addi	a0,a0,1504 # 6c40 <malloc+0x11a4>
    2668:	00003097          	auipc	ra,0x3
    266c:	376080e7          	jalr	886(ra) # 59de <printf>
    exit(1);
    2670:	4505                	li	a0,1
    2672:	00003097          	auipc	ra,0x3
    2676:	fe4080e7          	jalr	-28(ra) # 5656 <exit>
    a = b + 1;
    267a:	84be                	mv	s1,a5
    b = sbrk(1);
    267c:	4505                	li	a0,1
    267e:	00003097          	auipc	ra,0x3
    2682:	060080e7          	jalr	96(ra) # 56de <sbrk>
    if(b != a){
    2686:	04951b63          	bne	a0,s1,26dc <sbrkbasic+0x124>
    *b = 1;
    268a:	01548023          	sb	s5,0(s1)
    a = b + 1;
    268e:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    2692:	2905                	addiw	s2,s2,1
    2694:	ff3913e3          	bne	s2,s3,267a <sbrkbasic+0xc2>
  pid = fork();
    2698:	00003097          	auipc	ra,0x3
    269c:	fb6080e7          	jalr	-74(ra) # 564e <fork>
    26a0:	892a                	mv	s2,a0
  if(pid < 0){
    26a2:	04054d63          	bltz	a0,26fc <sbrkbasic+0x144>
  c = sbrk(1);
    26a6:	4505                	li	a0,1
    26a8:	00003097          	auipc	ra,0x3
    26ac:	036080e7          	jalr	54(ra) # 56de <sbrk>
  c = sbrk(1);
    26b0:	4505                	li	a0,1
    26b2:	00003097          	auipc	ra,0x3
    26b6:	02c080e7          	jalr	44(ra) # 56de <sbrk>
  if(c != a + 1){
    26ba:	0489                	addi	s1,s1,2
    26bc:	04a48e63          	beq	s1,a0,2718 <sbrkbasic+0x160>
    printf("%s: sbrk test failed post-fork\n", s);
    26c0:	85d2                	mv	a1,s4
    26c2:	00004517          	auipc	a0,0x4
    26c6:	5de50513          	addi	a0,a0,1502 # 6ca0 <malloc+0x1204>
    26ca:	00003097          	auipc	ra,0x3
    26ce:	314080e7          	jalr	788(ra) # 59de <printf>
    exit(1);
    26d2:	4505                	li	a0,1
    26d4:	00003097          	auipc	ra,0x3
    26d8:	f82080e7          	jalr	-126(ra) # 5656 <exit>
      printf("%s: sbrk test failed %d %x %x\n", i, a, b);
    26dc:	86aa                	mv	a3,a0
    26de:	8626                	mv	a2,s1
    26e0:	85ca                	mv	a1,s2
    26e2:	00004517          	auipc	a0,0x4
    26e6:	57e50513          	addi	a0,a0,1406 # 6c60 <malloc+0x11c4>
    26ea:	00003097          	auipc	ra,0x3
    26ee:	2f4080e7          	jalr	756(ra) # 59de <printf>
      exit(1);
    26f2:	4505                	li	a0,1
    26f4:	00003097          	auipc	ra,0x3
    26f8:	f62080e7          	jalr	-158(ra) # 5656 <exit>
    printf("%s: sbrk test fork failed\n", s);
    26fc:	85d2                	mv	a1,s4
    26fe:	00004517          	auipc	a0,0x4
    2702:	58250513          	addi	a0,a0,1410 # 6c80 <malloc+0x11e4>
    2706:	00003097          	auipc	ra,0x3
    270a:	2d8080e7          	jalr	728(ra) # 59de <printf>
    exit(1);
    270e:	4505                	li	a0,1
    2710:	00003097          	auipc	ra,0x3
    2714:	f46080e7          	jalr	-186(ra) # 5656 <exit>
  if(pid == 0)
    2718:	00091763          	bnez	s2,2726 <sbrkbasic+0x16e>
    exit(0);
    271c:	4501                	li	a0,0
    271e:	00003097          	auipc	ra,0x3
    2722:	f38080e7          	jalr	-200(ra) # 5656 <exit>
  wait(&xstatus);
    2726:	fbc40513          	addi	a0,s0,-68
    272a:	00003097          	auipc	ra,0x3
    272e:	f34080e7          	jalr	-204(ra) # 565e <wait>
  exit(xstatus);
    2732:	fbc42503          	lw	a0,-68(s0)
    2736:	00003097          	auipc	ra,0x3
    273a:	f20080e7          	jalr	-224(ra) # 5656 <exit>

000000000000273e <sbrkmuch>:
{
    273e:	7179                	addi	sp,sp,-48
    2740:	f406                	sd	ra,40(sp)
    2742:	f022                	sd	s0,32(sp)
    2744:	ec26                	sd	s1,24(sp)
    2746:	e84a                	sd	s2,16(sp)
    2748:	e44e                	sd	s3,8(sp)
    274a:	e052                	sd	s4,0(sp)
    274c:	1800                	addi	s0,sp,48
    274e:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    2750:	4501                	li	a0,0
    2752:	00003097          	auipc	ra,0x3
    2756:	f8c080e7          	jalr	-116(ra) # 56de <sbrk>
    275a:	892a                	mv	s2,a0
  a = sbrk(0);
    275c:	4501                	li	a0,0
    275e:	00003097          	auipc	ra,0x3
    2762:	f80080e7          	jalr	-128(ra) # 56de <sbrk>
    2766:	84aa                	mv	s1,a0
  p = sbrk(amt);
    2768:	06400537          	lui	a0,0x6400
    276c:	9d05                	subw	a0,a0,s1
    276e:	00003097          	auipc	ra,0x3
    2772:	f70080e7          	jalr	-144(ra) # 56de <sbrk>
  if (p != a) {
    2776:	0ca49863          	bne	s1,a0,2846 <sbrkmuch+0x108>
  char *eee = sbrk(0);
    277a:	4501                	li	a0,0
    277c:	00003097          	auipc	ra,0x3
    2780:	f62080e7          	jalr	-158(ra) # 56de <sbrk>
    2784:	87aa                	mv	a5,a0
  for(char *pp = a; pp < eee; pp += 4096)
    2786:	00a4f963          	bgeu	s1,a0,2798 <sbrkmuch+0x5a>
    *pp = 1;
    278a:	4685                	li	a3,1
  for(char *pp = a; pp < eee; pp += 4096)
    278c:	6705                	lui	a4,0x1
    *pp = 1;
    278e:	00d48023          	sb	a3,0(s1)
  for(char *pp = a; pp < eee; pp += 4096)
    2792:	94ba                	add	s1,s1,a4
    2794:	fef4ede3          	bltu	s1,a5,278e <sbrkmuch+0x50>
  *lastaddr = 99;
    2798:	064007b7          	lui	a5,0x6400
    279c:	06300713          	li	a4,99
    27a0:	fee78fa3          	sb	a4,-1(a5) # 63fffff <__BSS_END__+0x63f14af>
  a = sbrk(0);
    27a4:	4501                	li	a0,0
    27a6:	00003097          	auipc	ra,0x3
    27aa:	f38080e7          	jalr	-200(ra) # 56de <sbrk>
    27ae:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    27b0:	757d                	lui	a0,0xfffff
    27b2:	00003097          	auipc	ra,0x3
    27b6:	f2c080e7          	jalr	-212(ra) # 56de <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    27ba:	57fd                	li	a5,-1
    27bc:	0af50363          	beq	a0,a5,2862 <sbrkmuch+0x124>
  c = sbrk(0);
    27c0:	4501                	li	a0,0
    27c2:	00003097          	auipc	ra,0x3
    27c6:	f1c080e7          	jalr	-228(ra) # 56de <sbrk>
  if(c != a - PGSIZE){
    27ca:	77fd                	lui	a5,0xfffff
    27cc:	97a6                	add	a5,a5,s1
    27ce:	0af51863          	bne	a0,a5,287e <sbrkmuch+0x140>
  a = sbrk(0);
    27d2:	4501                	li	a0,0
    27d4:	00003097          	auipc	ra,0x3
    27d8:	f0a080e7          	jalr	-246(ra) # 56de <sbrk>
    27dc:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    27de:	6505                	lui	a0,0x1
    27e0:	00003097          	auipc	ra,0x3
    27e4:	efe080e7          	jalr	-258(ra) # 56de <sbrk>
    27e8:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    27ea:	0aa49a63          	bne	s1,a0,289e <sbrkmuch+0x160>
    27ee:	4501                	li	a0,0
    27f0:	00003097          	auipc	ra,0x3
    27f4:	eee080e7          	jalr	-274(ra) # 56de <sbrk>
    27f8:	6785                	lui	a5,0x1
    27fa:	97a6                	add	a5,a5,s1
    27fc:	0af51163          	bne	a0,a5,289e <sbrkmuch+0x160>
  if(*lastaddr == 99){
    2800:	064007b7          	lui	a5,0x6400
    2804:	fff7c703          	lbu	a4,-1(a5) # 63fffff <__BSS_END__+0x63f14af>
    2808:	06300793          	li	a5,99
    280c:	0af70963          	beq	a4,a5,28be <sbrkmuch+0x180>
  a = sbrk(0);
    2810:	4501                	li	a0,0
    2812:	00003097          	auipc	ra,0x3
    2816:	ecc080e7          	jalr	-308(ra) # 56de <sbrk>
    281a:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    281c:	4501                	li	a0,0
    281e:	00003097          	auipc	ra,0x3
    2822:	ec0080e7          	jalr	-320(ra) # 56de <sbrk>
    2826:	40a9053b          	subw	a0,s2,a0
    282a:	00003097          	auipc	ra,0x3
    282e:	eb4080e7          	jalr	-332(ra) # 56de <sbrk>
  if(c != a){
    2832:	0aa49463          	bne	s1,a0,28da <sbrkmuch+0x19c>
}
    2836:	70a2                	ld	ra,40(sp)
    2838:	7402                	ld	s0,32(sp)
    283a:	64e2                	ld	s1,24(sp)
    283c:	6942                	ld	s2,16(sp)
    283e:	69a2                	ld	s3,8(sp)
    2840:	6a02                	ld	s4,0(sp)
    2842:	6145                	addi	sp,sp,48
    2844:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    2846:	85ce                	mv	a1,s3
    2848:	00004517          	auipc	a0,0x4
    284c:	47850513          	addi	a0,a0,1144 # 6cc0 <malloc+0x1224>
    2850:	00003097          	auipc	ra,0x3
    2854:	18e080e7          	jalr	398(ra) # 59de <printf>
    exit(1);
    2858:	4505                	li	a0,1
    285a:	00003097          	auipc	ra,0x3
    285e:	dfc080e7          	jalr	-516(ra) # 5656 <exit>
    printf("%s: sbrk could not deallocate\n", s);
    2862:	85ce                	mv	a1,s3
    2864:	00004517          	auipc	a0,0x4
    2868:	4a450513          	addi	a0,a0,1188 # 6d08 <malloc+0x126c>
    286c:	00003097          	auipc	ra,0x3
    2870:	172080e7          	jalr	370(ra) # 59de <printf>
    exit(1);
    2874:	4505                	li	a0,1
    2876:	00003097          	auipc	ra,0x3
    287a:	de0080e7          	jalr	-544(ra) # 5656 <exit>
    printf("%s: sbrk deallocation produced wrong address, a %x c %x\n", s, a, c);
    287e:	86aa                	mv	a3,a0
    2880:	8626                	mv	a2,s1
    2882:	85ce                	mv	a1,s3
    2884:	00004517          	auipc	a0,0x4
    2888:	4a450513          	addi	a0,a0,1188 # 6d28 <malloc+0x128c>
    288c:	00003097          	auipc	ra,0x3
    2890:	152080e7          	jalr	338(ra) # 59de <printf>
    exit(1);
    2894:	4505                	li	a0,1
    2896:	00003097          	auipc	ra,0x3
    289a:	dc0080e7          	jalr	-576(ra) # 5656 <exit>
    printf("%s: sbrk re-allocation failed, a %x c %x\n", s, a, c);
    289e:	86d2                	mv	a3,s4
    28a0:	8626                	mv	a2,s1
    28a2:	85ce                	mv	a1,s3
    28a4:	00004517          	auipc	a0,0x4
    28a8:	4c450513          	addi	a0,a0,1220 # 6d68 <malloc+0x12cc>
    28ac:	00003097          	auipc	ra,0x3
    28b0:	132080e7          	jalr	306(ra) # 59de <printf>
    exit(1);
    28b4:	4505                	li	a0,1
    28b6:	00003097          	auipc	ra,0x3
    28ba:	da0080e7          	jalr	-608(ra) # 5656 <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    28be:	85ce                	mv	a1,s3
    28c0:	00004517          	auipc	a0,0x4
    28c4:	4d850513          	addi	a0,a0,1240 # 6d98 <malloc+0x12fc>
    28c8:	00003097          	auipc	ra,0x3
    28cc:	116080e7          	jalr	278(ra) # 59de <printf>
    exit(1);
    28d0:	4505                	li	a0,1
    28d2:	00003097          	auipc	ra,0x3
    28d6:	d84080e7          	jalr	-636(ra) # 5656 <exit>
    printf("%s: sbrk downsize failed, a %x c %x\n", s, a, c);
    28da:	86aa                	mv	a3,a0
    28dc:	8626                	mv	a2,s1
    28de:	85ce                	mv	a1,s3
    28e0:	00004517          	auipc	a0,0x4
    28e4:	4f050513          	addi	a0,a0,1264 # 6dd0 <malloc+0x1334>
    28e8:	00003097          	auipc	ra,0x3
    28ec:	0f6080e7          	jalr	246(ra) # 59de <printf>
    exit(1);
    28f0:	4505                	li	a0,1
    28f2:	00003097          	auipc	ra,0x3
    28f6:	d64080e7          	jalr	-668(ra) # 5656 <exit>

00000000000028fa <sbrkarg>:
{
    28fa:	7179                	addi	sp,sp,-48
    28fc:	f406                	sd	ra,40(sp)
    28fe:	f022                	sd	s0,32(sp)
    2900:	ec26                	sd	s1,24(sp)
    2902:	e84a                	sd	s2,16(sp)
    2904:	e44e                	sd	s3,8(sp)
    2906:	1800                	addi	s0,sp,48
    2908:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    290a:	6505                	lui	a0,0x1
    290c:	00003097          	auipc	ra,0x3
    2910:	dd2080e7          	jalr	-558(ra) # 56de <sbrk>
    2914:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    2916:	20100593          	li	a1,513
    291a:	00004517          	auipc	a0,0x4
    291e:	4de50513          	addi	a0,a0,1246 # 6df8 <malloc+0x135c>
    2922:	00003097          	auipc	ra,0x3
    2926:	d74080e7          	jalr	-652(ra) # 5696 <open>
    292a:	84aa                	mv	s1,a0
  unlink("sbrk");
    292c:	00004517          	auipc	a0,0x4
    2930:	4cc50513          	addi	a0,a0,1228 # 6df8 <malloc+0x135c>
    2934:	00003097          	auipc	ra,0x3
    2938:	d72080e7          	jalr	-654(ra) # 56a6 <unlink>
  if(fd < 0)  {
    293c:	0404c163          	bltz	s1,297e <sbrkarg+0x84>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    2940:	6605                	lui	a2,0x1
    2942:	85ca                	mv	a1,s2
    2944:	8526                	mv	a0,s1
    2946:	00003097          	auipc	ra,0x3
    294a:	d30080e7          	jalr	-720(ra) # 5676 <write>
    294e:	04054663          	bltz	a0,299a <sbrkarg+0xa0>
  close(fd);
    2952:	8526                	mv	a0,s1
    2954:	00003097          	auipc	ra,0x3
    2958:	d2a080e7          	jalr	-726(ra) # 567e <close>
  a = sbrk(PGSIZE);
    295c:	6505                	lui	a0,0x1
    295e:	00003097          	auipc	ra,0x3
    2962:	d80080e7          	jalr	-640(ra) # 56de <sbrk>
  if(pipe((int *) a) != 0){
    2966:	00003097          	auipc	ra,0x3
    296a:	d00080e7          	jalr	-768(ra) # 5666 <pipe>
    296e:	e521                	bnez	a0,29b6 <sbrkarg+0xbc>
}
    2970:	70a2                	ld	ra,40(sp)
    2972:	7402                	ld	s0,32(sp)
    2974:	64e2                	ld	s1,24(sp)
    2976:	6942                	ld	s2,16(sp)
    2978:	69a2                	ld	s3,8(sp)
    297a:	6145                	addi	sp,sp,48
    297c:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    297e:	85ce                	mv	a1,s3
    2980:	00004517          	auipc	a0,0x4
    2984:	48050513          	addi	a0,a0,1152 # 6e00 <malloc+0x1364>
    2988:	00003097          	auipc	ra,0x3
    298c:	056080e7          	jalr	86(ra) # 59de <printf>
    exit(1);
    2990:	4505                	li	a0,1
    2992:	00003097          	auipc	ra,0x3
    2996:	cc4080e7          	jalr	-828(ra) # 5656 <exit>
    printf("%s: write sbrk failed\n", s);
    299a:	85ce                	mv	a1,s3
    299c:	00004517          	auipc	a0,0x4
    29a0:	47c50513          	addi	a0,a0,1148 # 6e18 <malloc+0x137c>
    29a4:	00003097          	auipc	ra,0x3
    29a8:	03a080e7          	jalr	58(ra) # 59de <printf>
    exit(1);
    29ac:	4505                	li	a0,1
    29ae:	00003097          	auipc	ra,0x3
    29b2:	ca8080e7          	jalr	-856(ra) # 5656 <exit>
    printf("%s: pipe() failed\n", s);
    29b6:	85ce                	mv	a1,s3
    29b8:	00004517          	auipc	a0,0x4
    29bc:	e6050513          	addi	a0,a0,-416 # 6818 <malloc+0xd7c>
    29c0:	00003097          	auipc	ra,0x3
    29c4:	01e080e7          	jalr	30(ra) # 59de <printf>
    exit(1);
    29c8:	4505                	li	a0,1
    29ca:	00003097          	auipc	ra,0x3
    29ce:	c8c080e7          	jalr	-884(ra) # 5656 <exit>

00000000000029d2 <argptest>:
{
    29d2:	1101                	addi	sp,sp,-32
    29d4:	ec06                	sd	ra,24(sp)
    29d6:	e822                	sd	s0,16(sp)
    29d8:	e426                	sd	s1,8(sp)
    29da:	e04a                	sd	s2,0(sp)
    29dc:	1000                	addi	s0,sp,32
    29de:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    29e0:	4581                	li	a1,0
    29e2:	00004517          	auipc	a0,0x4
    29e6:	44e50513          	addi	a0,a0,1102 # 6e30 <malloc+0x1394>
    29ea:	00003097          	auipc	ra,0x3
    29ee:	cac080e7          	jalr	-852(ra) # 5696 <open>
  if (fd < 0) {
    29f2:	02054b63          	bltz	a0,2a28 <argptest+0x56>
    29f6:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    29f8:	4501                	li	a0,0
    29fa:	00003097          	auipc	ra,0x3
    29fe:	ce4080e7          	jalr	-796(ra) # 56de <sbrk>
    2a02:	567d                	li	a2,-1
    2a04:	fff50593          	addi	a1,a0,-1
    2a08:	8526                	mv	a0,s1
    2a0a:	00003097          	auipc	ra,0x3
    2a0e:	c64080e7          	jalr	-924(ra) # 566e <read>
  close(fd);
    2a12:	8526                	mv	a0,s1
    2a14:	00003097          	auipc	ra,0x3
    2a18:	c6a080e7          	jalr	-918(ra) # 567e <close>
}
    2a1c:	60e2                	ld	ra,24(sp)
    2a1e:	6442                	ld	s0,16(sp)
    2a20:	64a2                	ld	s1,8(sp)
    2a22:	6902                	ld	s2,0(sp)
    2a24:	6105                	addi	sp,sp,32
    2a26:	8082                	ret
    printf("%s: open failed\n", s);
    2a28:	85ca                	mv	a1,s2
    2a2a:	00004517          	auipc	a0,0x4
    2a2e:	cfe50513          	addi	a0,a0,-770 # 6728 <malloc+0xc8c>
    2a32:	00003097          	auipc	ra,0x3
    2a36:	fac080e7          	jalr	-84(ra) # 59de <printf>
    exit(1);
    2a3a:	4505                	li	a0,1
    2a3c:	00003097          	auipc	ra,0x3
    2a40:	c1a080e7          	jalr	-998(ra) # 5656 <exit>

0000000000002a44 <sbrkbugs>:
{
    2a44:	1141                	addi	sp,sp,-16
    2a46:	e406                	sd	ra,8(sp)
    2a48:	e022                	sd	s0,0(sp)
    2a4a:	0800                	addi	s0,sp,16
  int pid = fork();
    2a4c:	00003097          	auipc	ra,0x3
    2a50:	c02080e7          	jalr	-1022(ra) # 564e <fork>
  if(pid < 0){
    2a54:	02054263          	bltz	a0,2a78 <sbrkbugs+0x34>
  if(pid == 0){
    2a58:	ed0d                	bnez	a0,2a92 <sbrkbugs+0x4e>
    int sz = (uint64) sbrk(0);
    2a5a:	00003097          	auipc	ra,0x3
    2a5e:	c84080e7          	jalr	-892(ra) # 56de <sbrk>
    sbrk(-sz);
    2a62:	40a0053b          	negw	a0,a0
    2a66:	00003097          	auipc	ra,0x3
    2a6a:	c78080e7          	jalr	-904(ra) # 56de <sbrk>
    exit(0);
    2a6e:	4501                	li	a0,0
    2a70:	00003097          	auipc	ra,0x3
    2a74:	be6080e7          	jalr	-1050(ra) # 5656 <exit>
    printf("fork failed\n");
    2a78:	00004517          	auipc	a0,0x4
    2a7c:	0a050513          	addi	a0,a0,160 # 6b18 <malloc+0x107c>
    2a80:	00003097          	auipc	ra,0x3
    2a84:	f5e080e7          	jalr	-162(ra) # 59de <printf>
    exit(1);
    2a88:	4505                	li	a0,1
    2a8a:	00003097          	auipc	ra,0x3
    2a8e:	bcc080e7          	jalr	-1076(ra) # 5656 <exit>
  wait(0);
    2a92:	4501                	li	a0,0
    2a94:	00003097          	auipc	ra,0x3
    2a98:	bca080e7          	jalr	-1078(ra) # 565e <wait>
  pid = fork();
    2a9c:	00003097          	auipc	ra,0x3
    2aa0:	bb2080e7          	jalr	-1102(ra) # 564e <fork>
  if(pid < 0){
    2aa4:	02054563          	bltz	a0,2ace <sbrkbugs+0x8a>
  if(pid == 0){
    2aa8:	e121                	bnez	a0,2ae8 <sbrkbugs+0xa4>
    int sz = (uint64) sbrk(0);
    2aaa:	00003097          	auipc	ra,0x3
    2aae:	c34080e7          	jalr	-972(ra) # 56de <sbrk>
    sbrk(-(sz - 3500));
    2ab2:	6785                	lui	a5,0x1
    2ab4:	dac7879b          	addiw	a5,a5,-596
    2ab8:	40a7853b          	subw	a0,a5,a0
    2abc:	00003097          	auipc	ra,0x3
    2ac0:	c22080e7          	jalr	-990(ra) # 56de <sbrk>
    exit(0);
    2ac4:	4501                	li	a0,0
    2ac6:	00003097          	auipc	ra,0x3
    2aca:	b90080e7          	jalr	-1136(ra) # 5656 <exit>
    printf("fork failed\n");
    2ace:	00004517          	auipc	a0,0x4
    2ad2:	04a50513          	addi	a0,a0,74 # 6b18 <malloc+0x107c>
    2ad6:	00003097          	auipc	ra,0x3
    2ada:	f08080e7          	jalr	-248(ra) # 59de <printf>
    exit(1);
    2ade:	4505                	li	a0,1
    2ae0:	00003097          	auipc	ra,0x3
    2ae4:	b76080e7          	jalr	-1162(ra) # 5656 <exit>
  wait(0);
    2ae8:	4501                	li	a0,0
    2aea:	00003097          	auipc	ra,0x3
    2aee:	b74080e7          	jalr	-1164(ra) # 565e <wait>
  pid = fork();
    2af2:	00003097          	auipc	ra,0x3
    2af6:	b5c080e7          	jalr	-1188(ra) # 564e <fork>
  if(pid < 0){
    2afa:	02054a63          	bltz	a0,2b2e <sbrkbugs+0xea>
  if(pid == 0){
    2afe:	e529                	bnez	a0,2b48 <sbrkbugs+0x104>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    2b00:	00003097          	auipc	ra,0x3
    2b04:	bde080e7          	jalr	-1058(ra) # 56de <sbrk>
    2b08:	67ad                	lui	a5,0xb
    2b0a:	8007879b          	addiw	a5,a5,-2048
    2b0e:	40a7853b          	subw	a0,a5,a0
    2b12:	00003097          	auipc	ra,0x3
    2b16:	bcc080e7          	jalr	-1076(ra) # 56de <sbrk>
    sbrk(-10);
    2b1a:	5559                	li	a0,-10
    2b1c:	00003097          	auipc	ra,0x3
    2b20:	bc2080e7          	jalr	-1086(ra) # 56de <sbrk>
    exit(0);
    2b24:	4501                	li	a0,0
    2b26:	00003097          	auipc	ra,0x3
    2b2a:	b30080e7          	jalr	-1232(ra) # 5656 <exit>
    printf("fork failed\n");
    2b2e:	00004517          	auipc	a0,0x4
    2b32:	fea50513          	addi	a0,a0,-22 # 6b18 <malloc+0x107c>
    2b36:	00003097          	auipc	ra,0x3
    2b3a:	ea8080e7          	jalr	-344(ra) # 59de <printf>
    exit(1);
    2b3e:	4505                	li	a0,1
    2b40:	00003097          	auipc	ra,0x3
    2b44:	b16080e7          	jalr	-1258(ra) # 5656 <exit>
  wait(0);
    2b48:	4501                	li	a0,0
    2b4a:	00003097          	auipc	ra,0x3
    2b4e:	b14080e7          	jalr	-1260(ra) # 565e <wait>
  exit(0);
    2b52:	4501                	li	a0,0
    2b54:	00003097          	auipc	ra,0x3
    2b58:	b02080e7          	jalr	-1278(ra) # 5656 <exit>

0000000000002b5c <execout>:
// test the exec() code that cleans up if it runs out
// of memory. it's really a test that such a condition
// doesn't cause a panic.
void
execout(char *s)
{
    2b5c:	715d                	addi	sp,sp,-80
    2b5e:	e486                	sd	ra,72(sp)
    2b60:	e0a2                	sd	s0,64(sp)
    2b62:	fc26                	sd	s1,56(sp)
    2b64:	f84a                	sd	s2,48(sp)
    2b66:	f44e                	sd	s3,40(sp)
    2b68:	f052                	sd	s4,32(sp)
    2b6a:	0880                	addi	s0,sp,80
  for(int avail = 0; avail < 15; avail++){
    2b6c:	4901                	li	s2,0
    2b6e:	49bd                	li	s3,15
    int pid = fork();
    2b70:	00003097          	auipc	ra,0x3
    2b74:	ade080e7          	jalr	-1314(ra) # 564e <fork>
    2b78:	84aa                	mv	s1,a0
    if(pid < 0){
    2b7a:	02054063          	bltz	a0,2b9a <execout+0x3e>
      printf("fork failed\n");
      exit(1);
    } else if(pid == 0){
    2b7e:	c91d                	beqz	a0,2bb4 <execout+0x58>
      close(1);
      char *args[] = { "echo", "x", 0 };
      exec("echo", args);
      exit(0);
    } else {
      wait((int*)0);
    2b80:	4501                	li	a0,0
    2b82:	00003097          	auipc	ra,0x3
    2b86:	adc080e7          	jalr	-1316(ra) # 565e <wait>
  for(int avail = 0; avail < 15; avail++){
    2b8a:	2905                	addiw	s2,s2,1
    2b8c:	ff3912e3          	bne	s2,s3,2b70 <execout+0x14>
    }
  }

  exit(0);
    2b90:	4501                	li	a0,0
    2b92:	00003097          	auipc	ra,0x3
    2b96:	ac4080e7          	jalr	-1340(ra) # 5656 <exit>
      printf("fork failed\n");
    2b9a:	00004517          	auipc	a0,0x4
    2b9e:	f7e50513          	addi	a0,a0,-130 # 6b18 <malloc+0x107c>
    2ba2:	00003097          	auipc	ra,0x3
    2ba6:	e3c080e7          	jalr	-452(ra) # 59de <printf>
      exit(1);
    2baa:	4505                	li	a0,1
    2bac:	00003097          	auipc	ra,0x3
    2bb0:	aaa080e7          	jalr	-1366(ra) # 5656 <exit>
        if(a == 0xffffffffffffffffLL)
    2bb4:	59fd                	li	s3,-1
        *(char*)(a + 4096 - 1) = 1;
    2bb6:	4a05                	li	s4,1
        uint64 a = (uint64) sbrk(4096);
    2bb8:	6505                	lui	a0,0x1
    2bba:	00003097          	auipc	ra,0x3
    2bbe:	b24080e7          	jalr	-1244(ra) # 56de <sbrk>
        if(a == 0xffffffffffffffffLL)
    2bc2:	01350763          	beq	a0,s3,2bd0 <execout+0x74>
        *(char*)(a + 4096 - 1) = 1;
    2bc6:	6785                	lui	a5,0x1
    2bc8:	953e                	add	a0,a0,a5
    2bca:	ff450fa3          	sb	s4,-1(a0) # fff <bigdir+0x9d>
      while(1){
    2bce:	b7ed                	j	2bb8 <execout+0x5c>
      for(int i = 0; i < avail; i++)
    2bd0:	01205a63          	blez	s2,2be4 <execout+0x88>
        sbrk(-4096);
    2bd4:	757d                	lui	a0,0xfffff
    2bd6:	00003097          	auipc	ra,0x3
    2bda:	b08080e7          	jalr	-1272(ra) # 56de <sbrk>
      for(int i = 0; i < avail; i++)
    2bde:	2485                	addiw	s1,s1,1
    2be0:	ff249ae3          	bne	s1,s2,2bd4 <execout+0x78>
      close(1);
    2be4:	4505                	li	a0,1
    2be6:	00003097          	auipc	ra,0x3
    2bea:	a98080e7          	jalr	-1384(ra) # 567e <close>
      char *args[] = { "echo", "x", 0 };
    2bee:	00003517          	auipc	a0,0x3
    2bf2:	2ea50513          	addi	a0,a0,746 # 5ed8 <malloc+0x43c>
    2bf6:	faa43c23          	sd	a0,-72(s0)
    2bfa:	00003797          	auipc	a5,0x3
    2bfe:	34e78793          	addi	a5,a5,846 # 5f48 <malloc+0x4ac>
    2c02:	fcf43023          	sd	a5,-64(s0)
    2c06:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    2c0a:	fb840593          	addi	a1,s0,-72
    2c0e:	00003097          	auipc	ra,0x3
    2c12:	a80080e7          	jalr	-1408(ra) # 568e <exec>
      exit(0);
    2c16:	4501                	li	a0,0
    2c18:	00003097          	auipc	ra,0x3
    2c1c:	a3e080e7          	jalr	-1474(ra) # 5656 <exit>

0000000000002c20 <fourteen>:
{
    2c20:	1101                	addi	sp,sp,-32
    2c22:	ec06                	sd	ra,24(sp)
    2c24:	e822                	sd	s0,16(sp)
    2c26:	e426                	sd	s1,8(sp)
    2c28:	1000                	addi	s0,sp,32
    2c2a:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    2c2c:	00004517          	auipc	a0,0x4
    2c30:	3dc50513          	addi	a0,a0,988 # 7008 <malloc+0x156c>
    2c34:	00003097          	auipc	ra,0x3
    2c38:	a8a080e7          	jalr	-1398(ra) # 56be <mkdir>
    2c3c:	e165                	bnez	a0,2d1c <fourteen+0xfc>
  if(mkdir("12345678901234/123456789012345") != 0){
    2c3e:	00004517          	auipc	a0,0x4
    2c42:	22250513          	addi	a0,a0,546 # 6e60 <malloc+0x13c4>
    2c46:	00003097          	auipc	ra,0x3
    2c4a:	a78080e7          	jalr	-1416(ra) # 56be <mkdir>
    2c4e:	e56d                	bnez	a0,2d38 <fourteen+0x118>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    2c50:	20000593          	li	a1,512
    2c54:	00004517          	auipc	a0,0x4
    2c58:	26450513          	addi	a0,a0,612 # 6eb8 <malloc+0x141c>
    2c5c:	00003097          	auipc	ra,0x3
    2c60:	a3a080e7          	jalr	-1478(ra) # 5696 <open>
  if(fd < 0){
    2c64:	0e054863          	bltz	a0,2d54 <fourteen+0x134>
  close(fd);
    2c68:	00003097          	auipc	ra,0x3
    2c6c:	a16080e7          	jalr	-1514(ra) # 567e <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2c70:	4581                	li	a1,0
    2c72:	00004517          	auipc	a0,0x4
    2c76:	2be50513          	addi	a0,a0,702 # 6f30 <malloc+0x1494>
    2c7a:	00003097          	auipc	ra,0x3
    2c7e:	a1c080e7          	jalr	-1508(ra) # 5696 <open>
  if(fd < 0){
    2c82:	0e054763          	bltz	a0,2d70 <fourteen+0x150>
  close(fd);
    2c86:	00003097          	auipc	ra,0x3
    2c8a:	9f8080e7          	jalr	-1544(ra) # 567e <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    2c8e:	00004517          	auipc	a0,0x4
    2c92:	31250513          	addi	a0,a0,786 # 6fa0 <malloc+0x1504>
    2c96:	00003097          	auipc	ra,0x3
    2c9a:	a28080e7          	jalr	-1496(ra) # 56be <mkdir>
    2c9e:	c57d                	beqz	a0,2d8c <fourteen+0x16c>
  if(mkdir("123456789012345/12345678901234") == 0){
    2ca0:	00004517          	auipc	a0,0x4
    2ca4:	35850513          	addi	a0,a0,856 # 6ff8 <malloc+0x155c>
    2ca8:	00003097          	auipc	ra,0x3
    2cac:	a16080e7          	jalr	-1514(ra) # 56be <mkdir>
    2cb0:	cd65                	beqz	a0,2da8 <fourteen+0x188>
  unlink("123456789012345/12345678901234");
    2cb2:	00004517          	auipc	a0,0x4
    2cb6:	34650513          	addi	a0,a0,838 # 6ff8 <malloc+0x155c>
    2cba:	00003097          	auipc	ra,0x3
    2cbe:	9ec080e7          	jalr	-1556(ra) # 56a6 <unlink>
  unlink("12345678901234/12345678901234");
    2cc2:	00004517          	auipc	a0,0x4
    2cc6:	2de50513          	addi	a0,a0,734 # 6fa0 <malloc+0x1504>
    2cca:	00003097          	auipc	ra,0x3
    2cce:	9dc080e7          	jalr	-1572(ra) # 56a6 <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    2cd2:	00004517          	auipc	a0,0x4
    2cd6:	25e50513          	addi	a0,a0,606 # 6f30 <malloc+0x1494>
    2cda:	00003097          	auipc	ra,0x3
    2cde:	9cc080e7          	jalr	-1588(ra) # 56a6 <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    2ce2:	00004517          	auipc	a0,0x4
    2ce6:	1d650513          	addi	a0,a0,470 # 6eb8 <malloc+0x141c>
    2cea:	00003097          	auipc	ra,0x3
    2cee:	9bc080e7          	jalr	-1604(ra) # 56a6 <unlink>
  unlink("12345678901234/123456789012345");
    2cf2:	00004517          	auipc	a0,0x4
    2cf6:	16e50513          	addi	a0,a0,366 # 6e60 <malloc+0x13c4>
    2cfa:	00003097          	auipc	ra,0x3
    2cfe:	9ac080e7          	jalr	-1620(ra) # 56a6 <unlink>
  unlink("12345678901234");
    2d02:	00004517          	auipc	a0,0x4
    2d06:	30650513          	addi	a0,a0,774 # 7008 <malloc+0x156c>
    2d0a:	00003097          	auipc	ra,0x3
    2d0e:	99c080e7          	jalr	-1636(ra) # 56a6 <unlink>
}
    2d12:	60e2                	ld	ra,24(sp)
    2d14:	6442                	ld	s0,16(sp)
    2d16:	64a2                	ld	s1,8(sp)
    2d18:	6105                	addi	sp,sp,32
    2d1a:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    2d1c:	85a6                	mv	a1,s1
    2d1e:	00004517          	auipc	a0,0x4
    2d22:	11a50513          	addi	a0,a0,282 # 6e38 <malloc+0x139c>
    2d26:	00003097          	auipc	ra,0x3
    2d2a:	cb8080e7          	jalr	-840(ra) # 59de <printf>
    exit(1);
    2d2e:	4505                	li	a0,1
    2d30:	00003097          	auipc	ra,0x3
    2d34:	926080e7          	jalr	-1754(ra) # 5656 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    2d38:	85a6                	mv	a1,s1
    2d3a:	00004517          	auipc	a0,0x4
    2d3e:	14650513          	addi	a0,a0,326 # 6e80 <malloc+0x13e4>
    2d42:	00003097          	auipc	ra,0x3
    2d46:	c9c080e7          	jalr	-868(ra) # 59de <printf>
    exit(1);
    2d4a:	4505                	li	a0,1
    2d4c:	00003097          	auipc	ra,0x3
    2d50:	90a080e7          	jalr	-1782(ra) # 5656 <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    2d54:	85a6                	mv	a1,s1
    2d56:	00004517          	auipc	a0,0x4
    2d5a:	19250513          	addi	a0,a0,402 # 6ee8 <malloc+0x144c>
    2d5e:	00003097          	auipc	ra,0x3
    2d62:	c80080e7          	jalr	-896(ra) # 59de <printf>
    exit(1);
    2d66:	4505                	li	a0,1
    2d68:	00003097          	auipc	ra,0x3
    2d6c:	8ee080e7          	jalr	-1810(ra) # 5656 <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    2d70:	85a6                	mv	a1,s1
    2d72:	00004517          	auipc	a0,0x4
    2d76:	1ee50513          	addi	a0,a0,494 # 6f60 <malloc+0x14c4>
    2d7a:	00003097          	auipc	ra,0x3
    2d7e:	c64080e7          	jalr	-924(ra) # 59de <printf>
    exit(1);
    2d82:	4505                	li	a0,1
    2d84:	00003097          	auipc	ra,0x3
    2d88:	8d2080e7          	jalr	-1838(ra) # 5656 <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    2d8c:	85a6                	mv	a1,s1
    2d8e:	00004517          	auipc	a0,0x4
    2d92:	23250513          	addi	a0,a0,562 # 6fc0 <malloc+0x1524>
    2d96:	00003097          	auipc	ra,0x3
    2d9a:	c48080e7          	jalr	-952(ra) # 59de <printf>
    exit(1);
    2d9e:	4505                	li	a0,1
    2da0:	00003097          	auipc	ra,0x3
    2da4:	8b6080e7          	jalr	-1866(ra) # 5656 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    2da8:	85a6                	mv	a1,s1
    2daa:	00004517          	auipc	a0,0x4
    2dae:	26e50513          	addi	a0,a0,622 # 7018 <malloc+0x157c>
    2db2:	00003097          	auipc	ra,0x3
    2db6:	c2c080e7          	jalr	-980(ra) # 59de <printf>
    exit(1);
    2dba:	4505                	li	a0,1
    2dbc:	00003097          	auipc	ra,0x3
    2dc0:	89a080e7          	jalr	-1894(ra) # 5656 <exit>

0000000000002dc4 <iputtest>:
{
    2dc4:	1101                	addi	sp,sp,-32
    2dc6:	ec06                	sd	ra,24(sp)
    2dc8:	e822                	sd	s0,16(sp)
    2dca:	e426                	sd	s1,8(sp)
    2dcc:	1000                	addi	s0,sp,32
    2dce:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    2dd0:	00004517          	auipc	a0,0x4
    2dd4:	28050513          	addi	a0,a0,640 # 7050 <malloc+0x15b4>
    2dd8:	00003097          	auipc	ra,0x3
    2ddc:	8e6080e7          	jalr	-1818(ra) # 56be <mkdir>
    2de0:	04054563          	bltz	a0,2e2a <iputtest+0x66>
  if(chdir("iputdir") < 0){
    2de4:	00004517          	auipc	a0,0x4
    2de8:	26c50513          	addi	a0,a0,620 # 7050 <malloc+0x15b4>
    2dec:	00003097          	auipc	ra,0x3
    2df0:	8da080e7          	jalr	-1830(ra) # 56c6 <chdir>
    2df4:	04054963          	bltz	a0,2e46 <iputtest+0x82>
  if(unlink("../iputdir") < 0){
    2df8:	00004517          	auipc	a0,0x4
    2dfc:	29850513          	addi	a0,a0,664 # 7090 <malloc+0x15f4>
    2e00:	00003097          	auipc	ra,0x3
    2e04:	8a6080e7          	jalr	-1882(ra) # 56a6 <unlink>
    2e08:	04054d63          	bltz	a0,2e62 <iputtest+0x9e>
  if(chdir("/") < 0){
    2e0c:	00004517          	auipc	a0,0x4
    2e10:	2b450513          	addi	a0,a0,692 # 70c0 <malloc+0x1624>
    2e14:	00003097          	auipc	ra,0x3
    2e18:	8b2080e7          	jalr	-1870(ra) # 56c6 <chdir>
    2e1c:	06054163          	bltz	a0,2e7e <iputtest+0xba>
}
    2e20:	60e2                	ld	ra,24(sp)
    2e22:	6442                	ld	s0,16(sp)
    2e24:	64a2                	ld	s1,8(sp)
    2e26:	6105                	addi	sp,sp,32
    2e28:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2e2a:	85a6                	mv	a1,s1
    2e2c:	00004517          	auipc	a0,0x4
    2e30:	22c50513          	addi	a0,a0,556 # 7058 <malloc+0x15bc>
    2e34:	00003097          	auipc	ra,0x3
    2e38:	baa080e7          	jalr	-1110(ra) # 59de <printf>
    exit(1);
    2e3c:	4505                	li	a0,1
    2e3e:	00003097          	auipc	ra,0x3
    2e42:	818080e7          	jalr	-2024(ra) # 5656 <exit>
    printf("%s: chdir iputdir failed\n", s);
    2e46:	85a6                	mv	a1,s1
    2e48:	00004517          	auipc	a0,0x4
    2e4c:	22850513          	addi	a0,a0,552 # 7070 <malloc+0x15d4>
    2e50:	00003097          	auipc	ra,0x3
    2e54:	b8e080e7          	jalr	-1138(ra) # 59de <printf>
    exit(1);
    2e58:	4505                	li	a0,1
    2e5a:	00002097          	auipc	ra,0x2
    2e5e:	7fc080e7          	jalr	2044(ra) # 5656 <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    2e62:	85a6                	mv	a1,s1
    2e64:	00004517          	auipc	a0,0x4
    2e68:	23c50513          	addi	a0,a0,572 # 70a0 <malloc+0x1604>
    2e6c:	00003097          	auipc	ra,0x3
    2e70:	b72080e7          	jalr	-1166(ra) # 59de <printf>
    exit(1);
    2e74:	4505                	li	a0,1
    2e76:	00002097          	auipc	ra,0x2
    2e7a:	7e0080e7          	jalr	2016(ra) # 5656 <exit>
    printf("%s: chdir / failed\n", s);
    2e7e:	85a6                	mv	a1,s1
    2e80:	00004517          	auipc	a0,0x4
    2e84:	24850513          	addi	a0,a0,584 # 70c8 <malloc+0x162c>
    2e88:	00003097          	auipc	ra,0x3
    2e8c:	b56080e7          	jalr	-1194(ra) # 59de <printf>
    exit(1);
    2e90:	4505                	li	a0,1
    2e92:	00002097          	auipc	ra,0x2
    2e96:	7c4080e7          	jalr	1988(ra) # 5656 <exit>

0000000000002e9a <exitiputtest>:
{
    2e9a:	7179                	addi	sp,sp,-48
    2e9c:	f406                	sd	ra,40(sp)
    2e9e:	f022                	sd	s0,32(sp)
    2ea0:	ec26                	sd	s1,24(sp)
    2ea2:	1800                	addi	s0,sp,48
    2ea4:	84aa                	mv	s1,a0
  pid = fork();
    2ea6:	00002097          	auipc	ra,0x2
    2eaa:	7a8080e7          	jalr	1960(ra) # 564e <fork>
  if(pid < 0){
    2eae:	04054663          	bltz	a0,2efa <exitiputtest+0x60>
  if(pid == 0){
    2eb2:	ed45                	bnez	a0,2f6a <exitiputtest+0xd0>
    if(mkdir("iputdir") < 0){
    2eb4:	00004517          	auipc	a0,0x4
    2eb8:	19c50513          	addi	a0,a0,412 # 7050 <malloc+0x15b4>
    2ebc:	00003097          	auipc	ra,0x3
    2ec0:	802080e7          	jalr	-2046(ra) # 56be <mkdir>
    2ec4:	04054963          	bltz	a0,2f16 <exitiputtest+0x7c>
    if(chdir("iputdir") < 0){
    2ec8:	00004517          	auipc	a0,0x4
    2ecc:	18850513          	addi	a0,a0,392 # 7050 <malloc+0x15b4>
    2ed0:	00002097          	auipc	ra,0x2
    2ed4:	7f6080e7          	jalr	2038(ra) # 56c6 <chdir>
    2ed8:	04054d63          	bltz	a0,2f32 <exitiputtest+0x98>
    if(unlink("../iputdir") < 0){
    2edc:	00004517          	auipc	a0,0x4
    2ee0:	1b450513          	addi	a0,a0,436 # 7090 <malloc+0x15f4>
    2ee4:	00002097          	auipc	ra,0x2
    2ee8:	7c2080e7          	jalr	1986(ra) # 56a6 <unlink>
    2eec:	06054163          	bltz	a0,2f4e <exitiputtest+0xb4>
    exit(0);
    2ef0:	4501                	li	a0,0
    2ef2:	00002097          	auipc	ra,0x2
    2ef6:	764080e7          	jalr	1892(ra) # 5656 <exit>
    printf("%s: fork failed\n", s);
    2efa:	85a6                	mv	a1,s1
    2efc:	00004517          	auipc	a0,0x4
    2f00:	81450513          	addi	a0,a0,-2028 # 6710 <malloc+0xc74>
    2f04:	00003097          	auipc	ra,0x3
    2f08:	ada080e7          	jalr	-1318(ra) # 59de <printf>
    exit(1);
    2f0c:	4505                	li	a0,1
    2f0e:	00002097          	auipc	ra,0x2
    2f12:	748080e7          	jalr	1864(ra) # 5656 <exit>
      printf("%s: mkdir failed\n", s);
    2f16:	85a6                	mv	a1,s1
    2f18:	00004517          	auipc	a0,0x4
    2f1c:	14050513          	addi	a0,a0,320 # 7058 <malloc+0x15bc>
    2f20:	00003097          	auipc	ra,0x3
    2f24:	abe080e7          	jalr	-1346(ra) # 59de <printf>
      exit(1);
    2f28:	4505                	li	a0,1
    2f2a:	00002097          	auipc	ra,0x2
    2f2e:	72c080e7          	jalr	1836(ra) # 5656 <exit>
      printf("%s: child chdir failed\n", s);
    2f32:	85a6                	mv	a1,s1
    2f34:	00004517          	auipc	a0,0x4
    2f38:	1ac50513          	addi	a0,a0,428 # 70e0 <malloc+0x1644>
    2f3c:	00003097          	auipc	ra,0x3
    2f40:	aa2080e7          	jalr	-1374(ra) # 59de <printf>
      exit(1);
    2f44:	4505                	li	a0,1
    2f46:	00002097          	auipc	ra,0x2
    2f4a:	710080e7          	jalr	1808(ra) # 5656 <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    2f4e:	85a6                	mv	a1,s1
    2f50:	00004517          	auipc	a0,0x4
    2f54:	15050513          	addi	a0,a0,336 # 70a0 <malloc+0x1604>
    2f58:	00003097          	auipc	ra,0x3
    2f5c:	a86080e7          	jalr	-1402(ra) # 59de <printf>
      exit(1);
    2f60:	4505                	li	a0,1
    2f62:	00002097          	auipc	ra,0x2
    2f66:	6f4080e7          	jalr	1780(ra) # 5656 <exit>
  wait(&xstatus);
    2f6a:	fdc40513          	addi	a0,s0,-36
    2f6e:	00002097          	auipc	ra,0x2
    2f72:	6f0080e7          	jalr	1776(ra) # 565e <wait>
  exit(xstatus);
    2f76:	fdc42503          	lw	a0,-36(s0)
    2f7a:	00002097          	auipc	ra,0x2
    2f7e:	6dc080e7          	jalr	1756(ra) # 5656 <exit>

0000000000002f82 <dirtest>:
{
    2f82:	1101                	addi	sp,sp,-32
    2f84:	ec06                	sd	ra,24(sp)
    2f86:	e822                	sd	s0,16(sp)
    2f88:	e426                	sd	s1,8(sp)
    2f8a:	1000                	addi	s0,sp,32
    2f8c:	84aa                	mv	s1,a0
  if(mkdir("dir0") < 0){
    2f8e:	00004517          	auipc	a0,0x4
    2f92:	16a50513          	addi	a0,a0,362 # 70f8 <malloc+0x165c>
    2f96:	00002097          	auipc	ra,0x2
    2f9a:	728080e7          	jalr	1832(ra) # 56be <mkdir>
    2f9e:	04054563          	bltz	a0,2fe8 <dirtest+0x66>
  if(chdir("dir0") < 0){
    2fa2:	00004517          	auipc	a0,0x4
    2fa6:	15650513          	addi	a0,a0,342 # 70f8 <malloc+0x165c>
    2faa:	00002097          	auipc	ra,0x2
    2fae:	71c080e7          	jalr	1820(ra) # 56c6 <chdir>
    2fb2:	04054963          	bltz	a0,3004 <dirtest+0x82>
  if(chdir("..") < 0){
    2fb6:	00004517          	auipc	a0,0x4
    2fba:	16250513          	addi	a0,a0,354 # 7118 <malloc+0x167c>
    2fbe:	00002097          	auipc	ra,0x2
    2fc2:	708080e7          	jalr	1800(ra) # 56c6 <chdir>
    2fc6:	04054d63          	bltz	a0,3020 <dirtest+0x9e>
  if(unlink("dir0") < 0){
    2fca:	00004517          	auipc	a0,0x4
    2fce:	12e50513          	addi	a0,a0,302 # 70f8 <malloc+0x165c>
    2fd2:	00002097          	auipc	ra,0x2
    2fd6:	6d4080e7          	jalr	1748(ra) # 56a6 <unlink>
    2fda:	06054163          	bltz	a0,303c <dirtest+0xba>
}
    2fde:	60e2                	ld	ra,24(sp)
    2fe0:	6442                	ld	s0,16(sp)
    2fe2:	64a2                	ld	s1,8(sp)
    2fe4:	6105                	addi	sp,sp,32
    2fe6:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2fe8:	85a6                	mv	a1,s1
    2fea:	00004517          	auipc	a0,0x4
    2fee:	06e50513          	addi	a0,a0,110 # 7058 <malloc+0x15bc>
    2ff2:	00003097          	auipc	ra,0x3
    2ff6:	9ec080e7          	jalr	-1556(ra) # 59de <printf>
    exit(1);
    2ffa:	4505                	li	a0,1
    2ffc:	00002097          	auipc	ra,0x2
    3000:	65a080e7          	jalr	1626(ra) # 5656 <exit>
    printf("%s: chdir dir0 failed\n", s);
    3004:	85a6                	mv	a1,s1
    3006:	00004517          	auipc	a0,0x4
    300a:	0fa50513          	addi	a0,a0,250 # 7100 <malloc+0x1664>
    300e:	00003097          	auipc	ra,0x3
    3012:	9d0080e7          	jalr	-1584(ra) # 59de <printf>
    exit(1);
    3016:	4505                	li	a0,1
    3018:	00002097          	auipc	ra,0x2
    301c:	63e080e7          	jalr	1598(ra) # 5656 <exit>
    printf("%s: chdir .. failed\n", s);
    3020:	85a6                	mv	a1,s1
    3022:	00004517          	auipc	a0,0x4
    3026:	0fe50513          	addi	a0,a0,254 # 7120 <malloc+0x1684>
    302a:	00003097          	auipc	ra,0x3
    302e:	9b4080e7          	jalr	-1612(ra) # 59de <printf>
    exit(1);
    3032:	4505                	li	a0,1
    3034:	00002097          	auipc	ra,0x2
    3038:	622080e7          	jalr	1570(ra) # 5656 <exit>
    printf("%s: unlink dir0 failed\n", s);
    303c:	85a6                	mv	a1,s1
    303e:	00004517          	auipc	a0,0x4
    3042:	0fa50513          	addi	a0,a0,250 # 7138 <malloc+0x169c>
    3046:	00003097          	auipc	ra,0x3
    304a:	998080e7          	jalr	-1640(ra) # 59de <printf>
    exit(1);
    304e:	4505                	li	a0,1
    3050:	00002097          	auipc	ra,0x2
    3054:	606080e7          	jalr	1542(ra) # 5656 <exit>

0000000000003058 <subdir>:
{
    3058:	1101                	addi	sp,sp,-32
    305a:	ec06                	sd	ra,24(sp)
    305c:	e822                	sd	s0,16(sp)
    305e:	e426                	sd	s1,8(sp)
    3060:	e04a                	sd	s2,0(sp)
    3062:	1000                	addi	s0,sp,32
    3064:	892a                	mv	s2,a0
  unlink("ff");
    3066:	00004517          	auipc	a0,0x4
    306a:	21a50513          	addi	a0,a0,538 # 7280 <malloc+0x17e4>
    306e:	00002097          	auipc	ra,0x2
    3072:	638080e7          	jalr	1592(ra) # 56a6 <unlink>
  if(mkdir("dd") != 0){
    3076:	00004517          	auipc	a0,0x4
    307a:	0da50513          	addi	a0,a0,218 # 7150 <malloc+0x16b4>
    307e:	00002097          	auipc	ra,0x2
    3082:	640080e7          	jalr	1600(ra) # 56be <mkdir>
    3086:	38051663          	bnez	a0,3412 <subdir+0x3ba>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    308a:	20200593          	li	a1,514
    308e:	00004517          	auipc	a0,0x4
    3092:	0e250513          	addi	a0,a0,226 # 7170 <malloc+0x16d4>
    3096:	00002097          	auipc	ra,0x2
    309a:	600080e7          	jalr	1536(ra) # 5696 <open>
    309e:	84aa                	mv	s1,a0
  if(fd < 0){
    30a0:	38054763          	bltz	a0,342e <subdir+0x3d6>
  write(fd, "ff", 2);
    30a4:	4609                	li	a2,2
    30a6:	00004597          	auipc	a1,0x4
    30aa:	1da58593          	addi	a1,a1,474 # 7280 <malloc+0x17e4>
    30ae:	00002097          	auipc	ra,0x2
    30b2:	5c8080e7          	jalr	1480(ra) # 5676 <write>
  close(fd);
    30b6:	8526                	mv	a0,s1
    30b8:	00002097          	auipc	ra,0x2
    30bc:	5c6080e7          	jalr	1478(ra) # 567e <close>
  if(unlink("dd") >= 0){
    30c0:	00004517          	auipc	a0,0x4
    30c4:	09050513          	addi	a0,a0,144 # 7150 <malloc+0x16b4>
    30c8:	00002097          	auipc	ra,0x2
    30cc:	5de080e7          	jalr	1502(ra) # 56a6 <unlink>
    30d0:	36055d63          	bgez	a0,344a <subdir+0x3f2>
  if(mkdir("/dd/dd") != 0){
    30d4:	00004517          	auipc	a0,0x4
    30d8:	0f450513          	addi	a0,a0,244 # 71c8 <malloc+0x172c>
    30dc:	00002097          	auipc	ra,0x2
    30e0:	5e2080e7          	jalr	1506(ra) # 56be <mkdir>
    30e4:	38051163          	bnez	a0,3466 <subdir+0x40e>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    30e8:	20200593          	li	a1,514
    30ec:	00004517          	auipc	a0,0x4
    30f0:	10450513          	addi	a0,a0,260 # 71f0 <malloc+0x1754>
    30f4:	00002097          	auipc	ra,0x2
    30f8:	5a2080e7          	jalr	1442(ra) # 5696 <open>
    30fc:	84aa                	mv	s1,a0
  if(fd < 0){
    30fe:	38054263          	bltz	a0,3482 <subdir+0x42a>
  write(fd, "FF", 2);
    3102:	4609                	li	a2,2
    3104:	00004597          	auipc	a1,0x4
    3108:	11c58593          	addi	a1,a1,284 # 7220 <malloc+0x1784>
    310c:	00002097          	auipc	ra,0x2
    3110:	56a080e7          	jalr	1386(ra) # 5676 <write>
  close(fd);
    3114:	8526                	mv	a0,s1
    3116:	00002097          	auipc	ra,0x2
    311a:	568080e7          	jalr	1384(ra) # 567e <close>
  fd = open("dd/dd/../ff", 0);
    311e:	4581                	li	a1,0
    3120:	00004517          	auipc	a0,0x4
    3124:	10850513          	addi	a0,a0,264 # 7228 <malloc+0x178c>
    3128:	00002097          	auipc	ra,0x2
    312c:	56e080e7          	jalr	1390(ra) # 5696 <open>
    3130:	84aa                	mv	s1,a0
  if(fd < 0){
    3132:	36054663          	bltz	a0,349e <subdir+0x446>
  cc = read(fd, buf, sizeof(buf));
    3136:	660d                	lui	a2,0x3
    3138:	00009597          	auipc	a1,0x9
    313c:	a0858593          	addi	a1,a1,-1528 # bb40 <buf>
    3140:	00002097          	auipc	ra,0x2
    3144:	52e080e7          	jalr	1326(ra) # 566e <read>
  if(cc != 2 || buf[0] != 'f'){
    3148:	4789                	li	a5,2
    314a:	36f51863          	bne	a0,a5,34ba <subdir+0x462>
    314e:	00009717          	auipc	a4,0x9
    3152:	9f274703          	lbu	a4,-1550(a4) # bb40 <buf>
    3156:	06600793          	li	a5,102
    315a:	36f71063          	bne	a4,a5,34ba <subdir+0x462>
  close(fd);
    315e:	8526                	mv	a0,s1
    3160:	00002097          	auipc	ra,0x2
    3164:	51e080e7          	jalr	1310(ra) # 567e <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    3168:	00004597          	auipc	a1,0x4
    316c:	11058593          	addi	a1,a1,272 # 7278 <malloc+0x17dc>
    3170:	00004517          	auipc	a0,0x4
    3174:	08050513          	addi	a0,a0,128 # 71f0 <malloc+0x1754>
    3178:	00002097          	auipc	ra,0x2
    317c:	53e080e7          	jalr	1342(ra) # 56b6 <link>
    3180:	34051b63          	bnez	a0,34d6 <subdir+0x47e>
  if(unlink("dd/dd/ff") != 0){
    3184:	00004517          	auipc	a0,0x4
    3188:	06c50513          	addi	a0,a0,108 # 71f0 <malloc+0x1754>
    318c:	00002097          	auipc	ra,0x2
    3190:	51a080e7          	jalr	1306(ra) # 56a6 <unlink>
    3194:	34051f63          	bnez	a0,34f2 <subdir+0x49a>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    3198:	4581                	li	a1,0
    319a:	00004517          	auipc	a0,0x4
    319e:	05650513          	addi	a0,a0,86 # 71f0 <malloc+0x1754>
    31a2:	00002097          	auipc	ra,0x2
    31a6:	4f4080e7          	jalr	1268(ra) # 5696 <open>
    31aa:	36055263          	bgez	a0,350e <subdir+0x4b6>
  if(chdir("dd") != 0){
    31ae:	00004517          	auipc	a0,0x4
    31b2:	fa250513          	addi	a0,a0,-94 # 7150 <malloc+0x16b4>
    31b6:	00002097          	auipc	ra,0x2
    31ba:	510080e7          	jalr	1296(ra) # 56c6 <chdir>
    31be:	36051663          	bnez	a0,352a <subdir+0x4d2>
  if(chdir("dd/../../dd") != 0){
    31c2:	00004517          	auipc	a0,0x4
    31c6:	14e50513          	addi	a0,a0,334 # 7310 <malloc+0x1874>
    31ca:	00002097          	auipc	ra,0x2
    31ce:	4fc080e7          	jalr	1276(ra) # 56c6 <chdir>
    31d2:	36051a63          	bnez	a0,3546 <subdir+0x4ee>
  if(chdir("dd/../../../dd") != 0){
    31d6:	00004517          	auipc	a0,0x4
    31da:	16a50513          	addi	a0,a0,362 # 7340 <malloc+0x18a4>
    31de:	00002097          	auipc	ra,0x2
    31e2:	4e8080e7          	jalr	1256(ra) # 56c6 <chdir>
    31e6:	36051e63          	bnez	a0,3562 <subdir+0x50a>
  if(chdir("./..") != 0){
    31ea:	00004517          	auipc	a0,0x4
    31ee:	18650513          	addi	a0,a0,390 # 7370 <malloc+0x18d4>
    31f2:	00002097          	auipc	ra,0x2
    31f6:	4d4080e7          	jalr	1236(ra) # 56c6 <chdir>
    31fa:	38051263          	bnez	a0,357e <subdir+0x526>
  fd = open("dd/dd/ffff", 0);
    31fe:	4581                	li	a1,0
    3200:	00004517          	auipc	a0,0x4
    3204:	07850513          	addi	a0,a0,120 # 7278 <malloc+0x17dc>
    3208:	00002097          	auipc	ra,0x2
    320c:	48e080e7          	jalr	1166(ra) # 5696 <open>
    3210:	84aa                	mv	s1,a0
  if(fd < 0){
    3212:	38054463          	bltz	a0,359a <subdir+0x542>
  if(read(fd, buf, sizeof(buf)) != 2){
    3216:	660d                	lui	a2,0x3
    3218:	00009597          	auipc	a1,0x9
    321c:	92858593          	addi	a1,a1,-1752 # bb40 <buf>
    3220:	00002097          	auipc	ra,0x2
    3224:	44e080e7          	jalr	1102(ra) # 566e <read>
    3228:	4789                	li	a5,2
    322a:	38f51663          	bne	a0,a5,35b6 <subdir+0x55e>
  close(fd);
    322e:	8526                	mv	a0,s1
    3230:	00002097          	auipc	ra,0x2
    3234:	44e080e7          	jalr	1102(ra) # 567e <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    3238:	4581                	li	a1,0
    323a:	00004517          	auipc	a0,0x4
    323e:	fb650513          	addi	a0,a0,-74 # 71f0 <malloc+0x1754>
    3242:	00002097          	auipc	ra,0x2
    3246:	454080e7          	jalr	1108(ra) # 5696 <open>
    324a:	38055463          	bgez	a0,35d2 <subdir+0x57a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    324e:	20200593          	li	a1,514
    3252:	00004517          	auipc	a0,0x4
    3256:	1ae50513          	addi	a0,a0,430 # 7400 <malloc+0x1964>
    325a:	00002097          	auipc	ra,0x2
    325e:	43c080e7          	jalr	1084(ra) # 5696 <open>
    3262:	38055663          	bgez	a0,35ee <subdir+0x596>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    3266:	20200593          	li	a1,514
    326a:	00004517          	auipc	a0,0x4
    326e:	1c650513          	addi	a0,a0,454 # 7430 <malloc+0x1994>
    3272:	00002097          	auipc	ra,0x2
    3276:	424080e7          	jalr	1060(ra) # 5696 <open>
    327a:	38055863          	bgez	a0,360a <subdir+0x5b2>
  if(open("dd", O_CREATE) >= 0){
    327e:	20000593          	li	a1,512
    3282:	00004517          	auipc	a0,0x4
    3286:	ece50513          	addi	a0,a0,-306 # 7150 <malloc+0x16b4>
    328a:	00002097          	auipc	ra,0x2
    328e:	40c080e7          	jalr	1036(ra) # 5696 <open>
    3292:	38055a63          	bgez	a0,3626 <subdir+0x5ce>
  if(open("dd", O_RDWR) >= 0){
    3296:	4589                	li	a1,2
    3298:	00004517          	auipc	a0,0x4
    329c:	eb850513          	addi	a0,a0,-328 # 7150 <malloc+0x16b4>
    32a0:	00002097          	auipc	ra,0x2
    32a4:	3f6080e7          	jalr	1014(ra) # 5696 <open>
    32a8:	38055d63          	bgez	a0,3642 <subdir+0x5ea>
  if(open("dd", O_WRONLY) >= 0){
    32ac:	4585                	li	a1,1
    32ae:	00004517          	auipc	a0,0x4
    32b2:	ea250513          	addi	a0,a0,-350 # 7150 <malloc+0x16b4>
    32b6:	00002097          	auipc	ra,0x2
    32ba:	3e0080e7          	jalr	992(ra) # 5696 <open>
    32be:	3a055063          	bgez	a0,365e <subdir+0x606>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    32c2:	00004597          	auipc	a1,0x4
    32c6:	1fe58593          	addi	a1,a1,510 # 74c0 <malloc+0x1a24>
    32ca:	00004517          	auipc	a0,0x4
    32ce:	13650513          	addi	a0,a0,310 # 7400 <malloc+0x1964>
    32d2:	00002097          	auipc	ra,0x2
    32d6:	3e4080e7          	jalr	996(ra) # 56b6 <link>
    32da:	3a050063          	beqz	a0,367a <subdir+0x622>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    32de:	00004597          	auipc	a1,0x4
    32e2:	1e258593          	addi	a1,a1,482 # 74c0 <malloc+0x1a24>
    32e6:	00004517          	auipc	a0,0x4
    32ea:	14a50513          	addi	a0,a0,330 # 7430 <malloc+0x1994>
    32ee:	00002097          	auipc	ra,0x2
    32f2:	3c8080e7          	jalr	968(ra) # 56b6 <link>
    32f6:	3a050063          	beqz	a0,3696 <subdir+0x63e>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    32fa:	00004597          	auipc	a1,0x4
    32fe:	f7e58593          	addi	a1,a1,-130 # 7278 <malloc+0x17dc>
    3302:	00004517          	auipc	a0,0x4
    3306:	e6e50513          	addi	a0,a0,-402 # 7170 <malloc+0x16d4>
    330a:	00002097          	auipc	ra,0x2
    330e:	3ac080e7          	jalr	940(ra) # 56b6 <link>
    3312:	3a050063          	beqz	a0,36b2 <subdir+0x65a>
  if(mkdir("dd/ff/ff") == 0){
    3316:	00004517          	auipc	a0,0x4
    331a:	0ea50513          	addi	a0,a0,234 # 7400 <malloc+0x1964>
    331e:	00002097          	auipc	ra,0x2
    3322:	3a0080e7          	jalr	928(ra) # 56be <mkdir>
    3326:	3a050463          	beqz	a0,36ce <subdir+0x676>
  if(mkdir("dd/xx/ff") == 0){
    332a:	00004517          	auipc	a0,0x4
    332e:	10650513          	addi	a0,a0,262 # 7430 <malloc+0x1994>
    3332:	00002097          	auipc	ra,0x2
    3336:	38c080e7          	jalr	908(ra) # 56be <mkdir>
    333a:	3a050863          	beqz	a0,36ea <subdir+0x692>
  if(mkdir("dd/dd/ffff") == 0){
    333e:	00004517          	auipc	a0,0x4
    3342:	f3a50513          	addi	a0,a0,-198 # 7278 <malloc+0x17dc>
    3346:	00002097          	auipc	ra,0x2
    334a:	378080e7          	jalr	888(ra) # 56be <mkdir>
    334e:	3a050c63          	beqz	a0,3706 <subdir+0x6ae>
  if(unlink("dd/xx/ff") == 0){
    3352:	00004517          	auipc	a0,0x4
    3356:	0de50513          	addi	a0,a0,222 # 7430 <malloc+0x1994>
    335a:	00002097          	auipc	ra,0x2
    335e:	34c080e7          	jalr	844(ra) # 56a6 <unlink>
    3362:	3c050063          	beqz	a0,3722 <subdir+0x6ca>
  if(unlink("dd/ff/ff") == 0){
    3366:	00004517          	auipc	a0,0x4
    336a:	09a50513          	addi	a0,a0,154 # 7400 <malloc+0x1964>
    336e:	00002097          	auipc	ra,0x2
    3372:	338080e7          	jalr	824(ra) # 56a6 <unlink>
    3376:	3c050463          	beqz	a0,373e <subdir+0x6e6>
  if(chdir("dd/ff") == 0){
    337a:	00004517          	auipc	a0,0x4
    337e:	df650513          	addi	a0,a0,-522 # 7170 <malloc+0x16d4>
    3382:	00002097          	auipc	ra,0x2
    3386:	344080e7          	jalr	836(ra) # 56c6 <chdir>
    338a:	3c050863          	beqz	a0,375a <subdir+0x702>
  if(chdir("dd/xx") == 0){
    338e:	00004517          	auipc	a0,0x4
    3392:	28250513          	addi	a0,a0,642 # 7610 <malloc+0x1b74>
    3396:	00002097          	auipc	ra,0x2
    339a:	330080e7          	jalr	816(ra) # 56c6 <chdir>
    339e:	3c050c63          	beqz	a0,3776 <subdir+0x71e>
  if(unlink("dd/dd/ffff") != 0){
    33a2:	00004517          	auipc	a0,0x4
    33a6:	ed650513          	addi	a0,a0,-298 # 7278 <malloc+0x17dc>
    33aa:	00002097          	auipc	ra,0x2
    33ae:	2fc080e7          	jalr	764(ra) # 56a6 <unlink>
    33b2:	3e051063          	bnez	a0,3792 <subdir+0x73a>
  if(unlink("dd/ff") != 0){
    33b6:	00004517          	auipc	a0,0x4
    33ba:	dba50513          	addi	a0,a0,-582 # 7170 <malloc+0x16d4>
    33be:	00002097          	auipc	ra,0x2
    33c2:	2e8080e7          	jalr	744(ra) # 56a6 <unlink>
    33c6:	3e051463          	bnez	a0,37ae <subdir+0x756>
  if(unlink("dd") == 0){
    33ca:	00004517          	auipc	a0,0x4
    33ce:	d8650513          	addi	a0,a0,-634 # 7150 <malloc+0x16b4>
    33d2:	00002097          	auipc	ra,0x2
    33d6:	2d4080e7          	jalr	724(ra) # 56a6 <unlink>
    33da:	3e050863          	beqz	a0,37ca <subdir+0x772>
  if(unlink("dd/dd") < 0){
    33de:	00004517          	auipc	a0,0x4
    33e2:	2a250513          	addi	a0,a0,674 # 7680 <malloc+0x1be4>
    33e6:	00002097          	auipc	ra,0x2
    33ea:	2c0080e7          	jalr	704(ra) # 56a6 <unlink>
    33ee:	3e054c63          	bltz	a0,37e6 <subdir+0x78e>
  if(unlink("dd") < 0){
    33f2:	00004517          	auipc	a0,0x4
    33f6:	d5e50513          	addi	a0,a0,-674 # 7150 <malloc+0x16b4>
    33fa:	00002097          	auipc	ra,0x2
    33fe:	2ac080e7          	jalr	684(ra) # 56a6 <unlink>
    3402:	40054063          	bltz	a0,3802 <subdir+0x7aa>
}
    3406:	60e2                	ld	ra,24(sp)
    3408:	6442                	ld	s0,16(sp)
    340a:	64a2                	ld	s1,8(sp)
    340c:	6902                	ld	s2,0(sp)
    340e:	6105                	addi	sp,sp,32
    3410:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    3412:	85ca                	mv	a1,s2
    3414:	00004517          	auipc	a0,0x4
    3418:	d4450513          	addi	a0,a0,-700 # 7158 <malloc+0x16bc>
    341c:	00002097          	auipc	ra,0x2
    3420:	5c2080e7          	jalr	1474(ra) # 59de <printf>
    exit(1);
    3424:	4505                	li	a0,1
    3426:	00002097          	auipc	ra,0x2
    342a:	230080e7          	jalr	560(ra) # 5656 <exit>
    printf("%s: create dd/ff failed\n", s);
    342e:	85ca                	mv	a1,s2
    3430:	00004517          	auipc	a0,0x4
    3434:	d4850513          	addi	a0,a0,-696 # 7178 <malloc+0x16dc>
    3438:	00002097          	auipc	ra,0x2
    343c:	5a6080e7          	jalr	1446(ra) # 59de <printf>
    exit(1);
    3440:	4505                	li	a0,1
    3442:	00002097          	auipc	ra,0x2
    3446:	214080e7          	jalr	532(ra) # 5656 <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    344a:	85ca                	mv	a1,s2
    344c:	00004517          	auipc	a0,0x4
    3450:	d4c50513          	addi	a0,a0,-692 # 7198 <malloc+0x16fc>
    3454:	00002097          	auipc	ra,0x2
    3458:	58a080e7          	jalr	1418(ra) # 59de <printf>
    exit(1);
    345c:	4505                	li	a0,1
    345e:	00002097          	auipc	ra,0x2
    3462:	1f8080e7          	jalr	504(ra) # 5656 <exit>
    printf("subdir mkdir dd/dd failed\n", s);
    3466:	85ca                	mv	a1,s2
    3468:	00004517          	auipc	a0,0x4
    346c:	d6850513          	addi	a0,a0,-664 # 71d0 <malloc+0x1734>
    3470:	00002097          	auipc	ra,0x2
    3474:	56e080e7          	jalr	1390(ra) # 59de <printf>
    exit(1);
    3478:	4505                	li	a0,1
    347a:	00002097          	auipc	ra,0x2
    347e:	1dc080e7          	jalr	476(ra) # 5656 <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    3482:	85ca                	mv	a1,s2
    3484:	00004517          	auipc	a0,0x4
    3488:	d7c50513          	addi	a0,a0,-644 # 7200 <malloc+0x1764>
    348c:	00002097          	auipc	ra,0x2
    3490:	552080e7          	jalr	1362(ra) # 59de <printf>
    exit(1);
    3494:	4505                	li	a0,1
    3496:	00002097          	auipc	ra,0x2
    349a:	1c0080e7          	jalr	448(ra) # 5656 <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    349e:	85ca                	mv	a1,s2
    34a0:	00004517          	auipc	a0,0x4
    34a4:	d9850513          	addi	a0,a0,-616 # 7238 <malloc+0x179c>
    34a8:	00002097          	auipc	ra,0x2
    34ac:	536080e7          	jalr	1334(ra) # 59de <printf>
    exit(1);
    34b0:	4505                	li	a0,1
    34b2:	00002097          	auipc	ra,0x2
    34b6:	1a4080e7          	jalr	420(ra) # 5656 <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    34ba:	85ca                	mv	a1,s2
    34bc:	00004517          	auipc	a0,0x4
    34c0:	d9c50513          	addi	a0,a0,-612 # 7258 <malloc+0x17bc>
    34c4:	00002097          	auipc	ra,0x2
    34c8:	51a080e7          	jalr	1306(ra) # 59de <printf>
    exit(1);
    34cc:	4505                	li	a0,1
    34ce:	00002097          	auipc	ra,0x2
    34d2:	188080e7          	jalr	392(ra) # 5656 <exit>
    printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    34d6:	85ca                	mv	a1,s2
    34d8:	00004517          	auipc	a0,0x4
    34dc:	db050513          	addi	a0,a0,-592 # 7288 <malloc+0x17ec>
    34e0:	00002097          	auipc	ra,0x2
    34e4:	4fe080e7          	jalr	1278(ra) # 59de <printf>
    exit(1);
    34e8:	4505                	li	a0,1
    34ea:	00002097          	auipc	ra,0x2
    34ee:	16c080e7          	jalr	364(ra) # 5656 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    34f2:	85ca                	mv	a1,s2
    34f4:	00004517          	auipc	a0,0x4
    34f8:	dbc50513          	addi	a0,a0,-580 # 72b0 <malloc+0x1814>
    34fc:	00002097          	auipc	ra,0x2
    3500:	4e2080e7          	jalr	1250(ra) # 59de <printf>
    exit(1);
    3504:	4505                	li	a0,1
    3506:	00002097          	auipc	ra,0x2
    350a:	150080e7          	jalr	336(ra) # 5656 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    350e:	85ca                	mv	a1,s2
    3510:	00004517          	auipc	a0,0x4
    3514:	dc050513          	addi	a0,a0,-576 # 72d0 <malloc+0x1834>
    3518:	00002097          	auipc	ra,0x2
    351c:	4c6080e7          	jalr	1222(ra) # 59de <printf>
    exit(1);
    3520:	4505                	li	a0,1
    3522:	00002097          	auipc	ra,0x2
    3526:	134080e7          	jalr	308(ra) # 5656 <exit>
    printf("%s: chdir dd failed\n", s);
    352a:	85ca                	mv	a1,s2
    352c:	00004517          	auipc	a0,0x4
    3530:	dcc50513          	addi	a0,a0,-564 # 72f8 <malloc+0x185c>
    3534:	00002097          	auipc	ra,0x2
    3538:	4aa080e7          	jalr	1194(ra) # 59de <printf>
    exit(1);
    353c:	4505                	li	a0,1
    353e:	00002097          	auipc	ra,0x2
    3542:	118080e7          	jalr	280(ra) # 5656 <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    3546:	85ca                	mv	a1,s2
    3548:	00004517          	auipc	a0,0x4
    354c:	dd850513          	addi	a0,a0,-552 # 7320 <malloc+0x1884>
    3550:	00002097          	auipc	ra,0x2
    3554:	48e080e7          	jalr	1166(ra) # 59de <printf>
    exit(1);
    3558:	4505                	li	a0,1
    355a:	00002097          	auipc	ra,0x2
    355e:	0fc080e7          	jalr	252(ra) # 5656 <exit>
    printf("chdir dd/../../dd failed\n", s);
    3562:	85ca                	mv	a1,s2
    3564:	00004517          	auipc	a0,0x4
    3568:	dec50513          	addi	a0,a0,-532 # 7350 <malloc+0x18b4>
    356c:	00002097          	auipc	ra,0x2
    3570:	472080e7          	jalr	1138(ra) # 59de <printf>
    exit(1);
    3574:	4505                	li	a0,1
    3576:	00002097          	auipc	ra,0x2
    357a:	0e0080e7          	jalr	224(ra) # 5656 <exit>
    printf("%s: chdir ./.. failed\n", s);
    357e:	85ca                	mv	a1,s2
    3580:	00004517          	auipc	a0,0x4
    3584:	df850513          	addi	a0,a0,-520 # 7378 <malloc+0x18dc>
    3588:	00002097          	auipc	ra,0x2
    358c:	456080e7          	jalr	1110(ra) # 59de <printf>
    exit(1);
    3590:	4505                	li	a0,1
    3592:	00002097          	auipc	ra,0x2
    3596:	0c4080e7          	jalr	196(ra) # 5656 <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    359a:	85ca                	mv	a1,s2
    359c:	00004517          	auipc	a0,0x4
    35a0:	df450513          	addi	a0,a0,-524 # 7390 <malloc+0x18f4>
    35a4:	00002097          	auipc	ra,0x2
    35a8:	43a080e7          	jalr	1082(ra) # 59de <printf>
    exit(1);
    35ac:	4505                	li	a0,1
    35ae:	00002097          	auipc	ra,0x2
    35b2:	0a8080e7          	jalr	168(ra) # 5656 <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    35b6:	85ca                	mv	a1,s2
    35b8:	00004517          	auipc	a0,0x4
    35bc:	df850513          	addi	a0,a0,-520 # 73b0 <malloc+0x1914>
    35c0:	00002097          	auipc	ra,0x2
    35c4:	41e080e7          	jalr	1054(ra) # 59de <printf>
    exit(1);
    35c8:	4505                	li	a0,1
    35ca:	00002097          	auipc	ra,0x2
    35ce:	08c080e7          	jalr	140(ra) # 5656 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    35d2:	85ca                	mv	a1,s2
    35d4:	00004517          	auipc	a0,0x4
    35d8:	dfc50513          	addi	a0,a0,-516 # 73d0 <malloc+0x1934>
    35dc:	00002097          	auipc	ra,0x2
    35e0:	402080e7          	jalr	1026(ra) # 59de <printf>
    exit(1);
    35e4:	4505                	li	a0,1
    35e6:	00002097          	auipc	ra,0x2
    35ea:	070080e7          	jalr	112(ra) # 5656 <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    35ee:	85ca                	mv	a1,s2
    35f0:	00004517          	auipc	a0,0x4
    35f4:	e2050513          	addi	a0,a0,-480 # 7410 <malloc+0x1974>
    35f8:	00002097          	auipc	ra,0x2
    35fc:	3e6080e7          	jalr	998(ra) # 59de <printf>
    exit(1);
    3600:	4505                	li	a0,1
    3602:	00002097          	auipc	ra,0x2
    3606:	054080e7          	jalr	84(ra) # 5656 <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    360a:	85ca                	mv	a1,s2
    360c:	00004517          	auipc	a0,0x4
    3610:	e3450513          	addi	a0,a0,-460 # 7440 <malloc+0x19a4>
    3614:	00002097          	auipc	ra,0x2
    3618:	3ca080e7          	jalr	970(ra) # 59de <printf>
    exit(1);
    361c:	4505                	li	a0,1
    361e:	00002097          	auipc	ra,0x2
    3622:	038080e7          	jalr	56(ra) # 5656 <exit>
    printf("%s: create dd succeeded!\n", s);
    3626:	85ca                	mv	a1,s2
    3628:	00004517          	auipc	a0,0x4
    362c:	e3850513          	addi	a0,a0,-456 # 7460 <malloc+0x19c4>
    3630:	00002097          	auipc	ra,0x2
    3634:	3ae080e7          	jalr	942(ra) # 59de <printf>
    exit(1);
    3638:	4505                	li	a0,1
    363a:	00002097          	auipc	ra,0x2
    363e:	01c080e7          	jalr	28(ra) # 5656 <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    3642:	85ca                	mv	a1,s2
    3644:	00004517          	auipc	a0,0x4
    3648:	e3c50513          	addi	a0,a0,-452 # 7480 <malloc+0x19e4>
    364c:	00002097          	auipc	ra,0x2
    3650:	392080e7          	jalr	914(ra) # 59de <printf>
    exit(1);
    3654:	4505                	li	a0,1
    3656:	00002097          	auipc	ra,0x2
    365a:	000080e7          	jalr	ra # 5656 <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    365e:	85ca                	mv	a1,s2
    3660:	00004517          	auipc	a0,0x4
    3664:	e4050513          	addi	a0,a0,-448 # 74a0 <malloc+0x1a04>
    3668:	00002097          	auipc	ra,0x2
    366c:	376080e7          	jalr	886(ra) # 59de <printf>
    exit(1);
    3670:	4505                	li	a0,1
    3672:	00002097          	auipc	ra,0x2
    3676:	fe4080e7          	jalr	-28(ra) # 5656 <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    367a:	85ca                	mv	a1,s2
    367c:	00004517          	auipc	a0,0x4
    3680:	e5450513          	addi	a0,a0,-428 # 74d0 <malloc+0x1a34>
    3684:	00002097          	auipc	ra,0x2
    3688:	35a080e7          	jalr	858(ra) # 59de <printf>
    exit(1);
    368c:	4505                	li	a0,1
    368e:	00002097          	auipc	ra,0x2
    3692:	fc8080e7          	jalr	-56(ra) # 5656 <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    3696:	85ca                	mv	a1,s2
    3698:	00004517          	auipc	a0,0x4
    369c:	e6050513          	addi	a0,a0,-416 # 74f8 <malloc+0x1a5c>
    36a0:	00002097          	auipc	ra,0x2
    36a4:	33e080e7          	jalr	830(ra) # 59de <printf>
    exit(1);
    36a8:	4505                	li	a0,1
    36aa:	00002097          	auipc	ra,0x2
    36ae:	fac080e7          	jalr	-84(ra) # 5656 <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    36b2:	85ca                	mv	a1,s2
    36b4:	00004517          	auipc	a0,0x4
    36b8:	e6c50513          	addi	a0,a0,-404 # 7520 <malloc+0x1a84>
    36bc:	00002097          	auipc	ra,0x2
    36c0:	322080e7          	jalr	802(ra) # 59de <printf>
    exit(1);
    36c4:	4505                	li	a0,1
    36c6:	00002097          	auipc	ra,0x2
    36ca:	f90080e7          	jalr	-112(ra) # 5656 <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    36ce:	85ca                	mv	a1,s2
    36d0:	00004517          	auipc	a0,0x4
    36d4:	e7850513          	addi	a0,a0,-392 # 7548 <malloc+0x1aac>
    36d8:	00002097          	auipc	ra,0x2
    36dc:	306080e7          	jalr	774(ra) # 59de <printf>
    exit(1);
    36e0:	4505                	li	a0,1
    36e2:	00002097          	auipc	ra,0x2
    36e6:	f74080e7          	jalr	-140(ra) # 5656 <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    36ea:	85ca                	mv	a1,s2
    36ec:	00004517          	auipc	a0,0x4
    36f0:	e7c50513          	addi	a0,a0,-388 # 7568 <malloc+0x1acc>
    36f4:	00002097          	auipc	ra,0x2
    36f8:	2ea080e7          	jalr	746(ra) # 59de <printf>
    exit(1);
    36fc:	4505                	li	a0,1
    36fe:	00002097          	auipc	ra,0x2
    3702:	f58080e7          	jalr	-168(ra) # 5656 <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    3706:	85ca                	mv	a1,s2
    3708:	00004517          	auipc	a0,0x4
    370c:	e8050513          	addi	a0,a0,-384 # 7588 <malloc+0x1aec>
    3710:	00002097          	auipc	ra,0x2
    3714:	2ce080e7          	jalr	718(ra) # 59de <printf>
    exit(1);
    3718:	4505                	li	a0,1
    371a:	00002097          	auipc	ra,0x2
    371e:	f3c080e7          	jalr	-196(ra) # 5656 <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    3722:	85ca                	mv	a1,s2
    3724:	00004517          	auipc	a0,0x4
    3728:	e8c50513          	addi	a0,a0,-372 # 75b0 <malloc+0x1b14>
    372c:	00002097          	auipc	ra,0x2
    3730:	2b2080e7          	jalr	690(ra) # 59de <printf>
    exit(1);
    3734:	4505                	li	a0,1
    3736:	00002097          	auipc	ra,0x2
    373a:	f20080e7          	jalr	-224(ra) # 5656 <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    373e:	85ca                	mv	a1,s2
    3740:	00004517          	auipc	a0,0x4
    3744:	e9050513          	addi	a0,a0,-368 # 75d0 <malloc+0x1b34>
    3748:	00002097          	auipc	ra,0x2
    374c:	296080e7          	jalr	662(ra) # 59de <printf>
    exit(1);
    3750:	4505                	li	a0,1
    3752:	00002097          	auipc	ra,0x2
    3756:	f04080e7          	jalr	-252(ra) # 5656 <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    375a:	85ca                	mv	a1,s2
    375c:	00004517          	auipc	a0,0x4
    3760:	e9450513          	addi	a0,a0,-364 # 75f0 <malloc+0x1b54>
    3764:	00002097          	auipc	ra,0x2
    3768:	27a080e7          	jalr	634(ra) # 59de <printf>
    exit(1);
    376c:	4505                	li	a0,1
    376e:	00002097          	auipc	ra,0x2
    3772:	ee8080e7          	jalr	-280(ra) # 5656 <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    3776:	85ca                	mv	a1,s2
    3778:	00004517          	auipc	a0,0x4
    377c:	ea050513          	addi	a0,a0,-352 # 7618 <malloc+0x1b7c>
    3780:	00002097          	auipc	ra,0x2
    3784:	25e080e7          	jalr	606(ra) # 59de <printf>
    exit(1);
    3788:	4505                	li	a0,1
    378a:	00002097          	auipc	ra,0x2
    378e:	ecc080e7          	jalr	-308(ra) # 5656 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3792:	85ca                	mv	a1,s2
    3794:	00004517          	auipc	a0,0x4
    3798:	b1c50513          	addi	a0,a0,-1252 # 72b0 <malloc+0x1814>
    379c:	00002097          	auipc	ra,0x2
    37a0:	242080e7          	jalr	578(ra) # 59de <printf>
    exit(1);
    37a4:	4505                	li	a0,1
    37a6:	00002097          	auipc	ra,0x2
    37aa:	eb0080e7          	jalr	-336(ra) # 5656 <exit>
    printf("%s: unlink dd/ff failed\n", s);
    37ae:	85ca                	mv	a1,s2
    37b0:	00004517          	auipc	a0,0x4
    37b4:	e8850513          	addi	a0,a0,-376 # 7638 <malloc+0x1b9c>
    37b8:	00002097          	auipc	ra,0x2
    37bc:	226080e7          	jalr	550(ra) # 59de <printf>
    exit(1);
    37c0:	4505                	li	a0,1
    37c2:	00002097          	auipc	ra,0x2
    37c6:	e94080e7          	jalr	-364(ra) # 5656 <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    37ca:	85ca                	mv	a1,s2
    37cc:	00004517          	auipc	a0,0x4
    37d0:	e8c50513          	addi	a0,a0,-372 # 7658 <malloc+0x1bbc>
    37d4:	00002097          	auipc	ra,0x2
    37d8:	20a080e7          	jalr	522(ra) # 59de <printf>
    exit(1);
    37dc:	4505                	li	a0,1
    37de:	00002097          	auipc	ra,0x2
    37e2:	e78080e7          	jalr	-392(ra) # 5656 <exit>
    printf("%s: unlink dd/dd failed\n", s);
    37e6:	85ca                	mv	a1,s2
    37e8:	00004517          	auipc	a0,0x4
    37ec:	ea050513          	addi	a0,a0,-352 # 7688 <malloc+0x1bec>
    37f0:	00002097          	auipc	ra,0x2
    37f4:	1ee080e7          	jalr	494(ra) # 59de <printf>
    exit(1);
    37f8:	4505                	li	a0,1
    37fa:	00002097          	auipc	ra,0x2
    37fe:	e5c080e7          	jalr	-420(ra) # 5656 <exit>
    printf("%s: unlink dd failed\n", s);
    3802:	85ca                	mv	a1,s2
    3804:	00004517          	auipc	a0,0x4
    3808:	ea450513          	addi	a0,a0,-348 # 76a8 <malloc+0x1c0c>
    380c:	00002097          	auipc	ra,0x2
    3810:	1d2080e7          	jalr	466(ra) # 59de <printf>
    exit(1);
    3814:	4505                	li	a0,1
    3816:	00002097          	auipc	ra,0x2
    381a:	e40080e7          	jalr	-448(ra) # 5656 <exit>

000000000000381e <rmdot>:
{
    381e:	1101                	addi	sp,sp,-32
    3820:	ec06                	sd	ra,24(sp)
    3822:	e822                	sd	s0,16(sp)
    3824:	e426                	sd	s1,8(sp)
    3826:	1000                	addi	s0,sp,32
    3828:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    382a:	00004517          	auipc	a0,0x4
    382e:	e9650513          	addi	a0,a0,-362 # 76c0 <malloc+0x1c24>
    3832:	00002097          	auipc	ra,0x2
    3836:	e8c080e7          	jalr	-372(ra) # 56be <mkdir>
    383a:	e549                	bnez	a0,38c4 <rmdot+0xa6>
  if(chdir("dots") != 0){
    383c:	00004517          	auipc	a0,0x4
    3840:	e8450513          	addi	a0,a0,-380 # 76c0 <malloc+0x1c24>
    3844:	00002097          	auipc	ra,0x2
    3848:	e82080e7          	jalr	-382(ra) # 56c6 <chdir>
    384c:	e951                	bnez	a0,38e0 <rmdot+0xc2>
  if(unlink(".") == 0){
    384e:	00003517          	auipc	a0,0x3
    3852:	d2250513          	addi	a0,a0,-734 # 6570 <malloc+0xad4>
    3856:	00002097          	auipc	ra,0x2
    385a:	e50080e7          	jalr	-432(ra) # 56a6 <unlink>
    385e:	cd59                	beqz	a0,38fc <rmdot+0xde>
  if(unlink("..") == 0){
    3860:	00004517          	auipc	a0,0x4
    3864:	8b850513          	addi	a0,a0,-1864 # 7118 <malloc+0x167c>
    3868:	00002097          	auipc	ra,0x2
    386c:	e3e080e7          	jalr	-450(ra) # 56a6 <unlink>
    3870:	c545                	beqz	a0,3918 <rmdot+0xfa>
  if(chdir("/") != 0){
    3872:	00004517          	auipc	a0,0x4
    3876:	84e50513          	addi	a0,a0,-1970 # 70c0 <malloc+0x1624>
    387a:	00002097          	auipc	ra,0x2
    387e:	e4c080e7          	jalr	-436(ra) # 56c6 <chdir>
    3882:	e94d                	bnez	a0,3934 <rmdot+0x116>
  if(unlink("dots/.") == 0){
    3884:	00004517          	auipc	a0,0x4
    3888:	ea450513          	addi	a0,a0,-348 # 7728 <malloc+0x1c8c>
    388c:	00002097          	auipc	ra,0x2
    3890:	e1a080e7          	jalr	-486(ra) # 56a6 <unlink>
    3894:	cd55                	beqz	a0,3950 <rmdot+0x132>
  if(unlink("dots/..") == 0){
    3896:	00004517          	auipc	a0,0x4
    389a:	eba50513          	addi	a0,a0,-326 # 7750 <malloc+0x1cb4>
    389e:	00002097          	auipc	ra,0x2
    38a2:	e08080e7          	jalr	-504(ra) # 56a6 <unlink>
    38a6:	c179                	beqz	a0,396c <rmdot+0x14e>
  if(unlink("dots") != 0){
    38a8:	00004517          	auipc	a0,0x4
    38ac:	e1850513          	addi	a0,a0,-488 # 76c0 <malloc+0x1c24>
    38b0:	00002097          	auipc	ra,0x2
    38b4:	df6080e7          	jalr	-522(ra) # 56a6 <unlink>
    38b8:	e961                	bnez	a0,3988 <rmdot+0x16a>
}
    38ba:	60e2                	ld	ra,24(sp)
    38bc:	6442                	ld	s0,16(sp)
    38be:	64a2                	ld	s1,8(sp)
    38c0:	6105                	addi	sp,sp,32
    38c2:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    38c4:	85a6                	mv	a1,s1
    38c6:	00004517          	auipc	a0,0x4
    38ca:	e0250513          	addi	a0,a0,-510 # 76c8 <malloc+0x1c2c>
    38ce:	00002097          	auipc	ra,0x2
    38d2:	110080e7          	jalr	272(ra) # 59de <printf>
    exit(1);
    38d6:	4505                	li	a0,1
    38d8:	00002097          	auipc	ra,0x2
    38dc:	d7e080e7          	jalr	-642(ra) # 5656 <exit>
    printf("%s: chdir dots failed\n", s);
    38e0:	85a6                	mv	a1,s1
    38e2:	00004517          	auipc	a0,0x4
    38e6:	dfe50513          	addi	a0,a0,-514 # 76e0 <malloc+0x1c44>
    38ea:	00002097          	auipc	ra,0x2
    38ee:	0f4080e7          	jalr	244(ra) # 59de <printf>
    exit(1);
    38f2:	4505                	li	a0,1
    38f4:	00002097          	auipc	ra,0x2
    38f8:	d62080e7          	jalr	-670(ra) # 5656 <exit>
    printf("%s: rm . worked!\n", s);
    38fc:	85a6                	mv	a1,s1
    38fe:	00004517          	auipc	a0,0x4
    3902:	dfa50513          	addi	a0,a0,-518 # 76f8 <malloc+0x1c5c>
    3906:	00002097          	auipc	ra,0x2
    390a:	0d8080e7          	jalr	216(ra) # 59de <printf>
    exit(1);
    390e:	4505                	li	a0,1
    3910:	00002097          	auipc	ra,0x2
    3914:	d46080e7          	jalr	-698(ra) # 5656 <exit>
    printf("%s: rm .. worked!\n", s);
    3918:	85a6                	mv	a1,s1
    391a:	00004517          	auipc	a0,0x4
    391e:	df650513          	addi	a0,a0,-522 # 7710 <malloc+0x1c74>
    3922:	00002097          	auipc	ra,0x2
    3926:	0bc080e7          	jalr	188(ra) # 59de <printf>
    exit(1);
    392a:	4505                	li	a0,1
    392c:	00002097          	auipc	ra,0x2
    3930:	d2a080e7          	jalr	-726(ra) # 5656 <exit>
    printf("%s: chdir / failed\n", s);
    3934:	85a6                	mv	a1,s1
    3936:	00003517          	auipc	a0,0x3
    393a:	79250513          	addi	a0,a0,1938 # 70c8 <malloc+0x162c>
    393e:	00002097          	auipc	ra,0x2
    3942:	0a0080e7          	jalr	160(ra) # 59de <printf>
    exit(1);
    3946:	4505                	li	a0,1
    3948:	00002097          	auipc	ra,0x2
    394c:	d0e080e7          	jalr	-754(ra) # 5656 <exit>
    printf("%s: unlink dots/. worked!\n", s);
    3950:	85a6                	mv	a1,s1
    3952:	00004517          	auipc	a0,0x4
    3956:	dde50513          	addi	a0,a0,-546 # 7730 <malloc+0x1c94>
    395a:	00002097          	auipc	ra,0x2
    395e:	084080e7          	jalr	132(ra) # 59de <printf>
    exit(1);
    3962:	4505                	li	a0,1
    3964:	00002097          	auipc	ra,0x2
    3968:	cf2080e7          	jalr	-782(ra) # 5656 <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    396c:	85a6                	mv	a1,s1
    396e:	00004517          	auipc	a0,0x4
    3972:	dea50513          	addi	a0,a0,-534 # 7758 <malloc+0x1cbc>
    3976:	00002097          	auipc	ra,0x2
    397a:	068080e7          	jalr	104(ra) # 59de <printf>
    exit(1);
    397e:	4505                	li	a0,1
    3980:	00002097          	auipc	ra,0x2
    3984:	cd6080e7          	jalr	-810(ra) # 5656 <exit>
    printf("%s: unlink dots failed!\n", s);
    3988:	85a6                	mv	a1,s1
    398a:	00004517          	auipc	a0,0x4
    398e:	dee50513          	addi	a0,a0,-530 # 7778 <malloc+0x1cdc>
    3992:	00002097          	auipc	ra,0x2
    3996:	04c080e7          	jalr	76(ra) # 59de <printf>
    exit(1);
    399a:	4505                	li	a0,1
    399c:	00002097          	auipc	ra,0x2
    39a0:	cba080e7          	jalr	-838(ra) # 5656 <exit>

00000000000039a4 <dirfile>:
{
    39a4:	1101                	addi	sp,sp,-32
    39a6:	ec06                	sd	ra,24(sp)
    39a8:	e822                	sd	s0,16(sp)
    39aa:	e426                	sd	s1,8(sp)
    39ac:	e04a                	sd	s2,0(sp)
    39ae:	1000                	addi	s0,sp,32
    39b0:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    39b2:	20000593          	li	a1,512
    39b6:	00002517          	auipc	a0,0x2
    39ba:	4c250513          	addi	a0,a0,1218 # 5e78 <malloc+0x3dc>
    39be:	00002097          	auipc	ra,0x2
    39c2:	cd8080e7          	jalr	-808(ra) # 5696 <open>
  if(fd < 0){
    39c6:	0e054d63          	bltz	a0,3ac0 <dirfile+0x11c>
  close(fd);
    39ca:	00002097          	auipc	ra,0x2
    39ce:	cb4080e7          	jalr	-844(ra) # 567e <close>
  if(chdir("dirfile") == 0){
    39d2:	00002517          	auipc	a0,0x2
    39d6:	4a650513          	addi	a0,a0,1190 # 5e78 <malloc+0x3dc>
    39da:	00002097          	auipc	ra,0x2
    39de:	cec080e7          	jalr	-788(ra) # 56c6 <chdir>
    39e2:	cd6d                	beqz	a0,3adc <dirfile+0x138>
  fd = open("dirfile/xx", 0);
    39e4:	4581                	li	a1,0
    39e6:	00004517          	auipc	a0,0x4
    39ea:	df250513          	addi	a0,a0,-526 # 77d8 <malloc+0x1d3c>
    39ee:	00002097          	auipc	ra,0x2
    39f2:	ca8080e7          	jalr	-856(ra) # 5696 <open>
  if(fd >= 0){
    39f6:	10055163          	bgez	a0,3af8 <dirfile+0x154>
  fd = open("dirfile/xx", O_CREATE);
    39fa:	20000593          	li	a1,512
    39fe:	00004517          	auipc	a0,0x4
    3a02:	dda50513          	addi	a0,a0,-550 # 77d8 <malloc+0x1d3c>
    3a06:	00002097          	auipc	ra,0x2
    3a0a:	c90080e7          	jalr	-880(ra) # 5696 <open>
  if(fd >= 0){
    3a0e:	10055363          	bgez	a0,3b14 <dirfile+0x170>
  if(mkdir("dirfile/xx") == 0){
    3a12:	00004517          	auipc	a0,0x4
    3a16:	dc650513          	addi	a0,a0,-570 # 77d8 <malloc+0x1d3c>
    3a1a:	00002097          	auipc	ra,0x2
    3a1e:	ca4080e7          	jalr	-860(ra) # 56be <mkdir>
    3a22:	10050763          	beqz	a0,3b30 <dirfile+0x18c>
  if(unlink("dirfile/xx") == 0){
    3a26:	00004517          	auipc	a0,0x4
    3a2a:	db250513          	addi	a0,a0,-590 # 77d8 <malloc+0x1d3c>
    3a2e:	00002097          	auipc	ra,0x2
    3a32:	c78080e7          	jalr	-904(ra) # 56a6 <unlink>
    3a36:	10050b63          	beqz	a0,3b4c <dirfile+0x1a8>
  if(link("README", "dirfile/xx") == 0){
    3a3a:	00004597          	auipc	a1,0x4
    3a3e:	d9e58593          	addi	a1,a1,-610 # 77d8 <malloc+0x1d3c>
    3a42:	00002517          	auipc	a0,0x2
    3a46:	62e50513          	addi	a0,a0,1582 # 6070 <malloc+0x5d4>
    3a4a:	00002097          	auipc	ra,0x2
    3a4e:	c6c080e7          	jalr	-916(ra) # 56b6 <link>
    3a52:	10050b63          	beqz	a0,3b68 <dirfile+0x1c4>
  if(unlink("dirfile") != 0){
    3a56:	00002517          	auipc	a0,0x2
    3a5a:	42250513          	addi	a0,a0,1058 # 5e78 <malloc+0x3dc>
    3a5e:	00002097          	auipc	ra,0x2
    3a62:	c48080e7          	jalr	-952(ra) # 56a6 <unlink>
    3a66:	10051f63          	bnez	a0,3b84 <dirfile+0x1e0>
  fd = open(".", O_RDWR);
    3a6a:	4589                	li	a1,2
    3a6c:	00003517          	auipc	a0,0x3
    3a70:	b0450513          	addi	a0,a0,-1276 # 6570 <malloc+0xad4>
    3a74:	00002097          	auipc	ra,0x2
    3a78:	c22080e7          	jalr	-990(ra) # 5696 <open>
  if(fd >= 0){
    3a7c:	12055263          	bgez	a0,3ba0 <dirfile+0x1fc>
  fd = open(".", 0);
    3a80:	4581                	li	a1,0
    3a82:	00003517          	auipc	a0,0x3
    3a86:	aee50513          	addi	a0,a0,-1298 # 6570 <malloc+0xad4>
    3a8a:	00002097          	auipc	ra,0x2
    3a8e:	c0c080e7          	jalr	-1012(ra) # 5696 <open>
    3a92:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    3a94:	4605                	li	a2,1
    3a96:	00002597          	auipc	a1,0x2
    3a9a:	4b258593          	addi	a1,a1,1202 # 5f48 <malloc+0x4ac>
    3a9e:	00002097          	auipc	ra,0x2
    3aa2:	bd8080e7          	jalr	-1064(ra) # 5676 <write>
    3aa6:	10a04b63          	bgtz	a0,3bbc <dirfile+0x218>
  close(fd);
    3aaa:	8526                	mv	a0,s1
    3aac:	00002097          	auipc	ra,0x2
    3ab0:	bd2080e7          	jalr	-1070(ra) # 567e <close>
}
    3ab4:	60e2                	ld	ra,24(sp)
    3ab6:	6442                	ld	s0,16(sp)
    3ab8:	64a2                	ld	s1,8(sp)
    3aba:	6902                	ld	s2,0(sp)
    3abc:	6105                	addi	sp,sp,32
    3abe:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    3ac0:	85ca                	mv	a1,s2
    3ac2:	00004517          	auipc	a0,0x4
    3ac6:	cd650513          	addi	a0,a0,-810 # 7798 <malloc+0x1cfc>
    3aca:	00002097          	auipc	ra,0x2
    3ace:	f14080e7          	jalr	-236(ra) # 59de <printf>
    exit(1);
    3ad2:	4505                	li	a0,1
    3ad4:	00002097          	auipc	ra,0x2
    3ad8:	b82080e7          	jalr	-1150(ra) # 5656 <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    3adc:	85ca                	mv	a1,s2
    3ade:	00004517          	auipc	a0,0x4
    3ae2:	cda50513          	addi	a0,a0,-806 # 77b8 <malloc+0x1d1c>
    3ae6:	00002097          	auipc	ra,0x2
    3aea:	ef8080e7          	jalr	-264(ra) # 59de <printf>
    exit(1);
    3aee:	4505                	li	a0,1
    3af0:	00002097          	auipc	ra,0x2
    3af4:	b66080e7          	jalr	-1178(ra) # 5656 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3af8:	85ca                	mv	a1,s2
    3afa:	00004517          	auipc	a0,0x4
    3afe:	cee50513          	addi	a0,a0,-786 # 77e8 <malloc+0x1d4c>
    3b02:	00002097          	auipc	ra,0x2
    3b06:	edc080e7          	jalr	-292(ra) # 59de <printf>
    exit(1);
    3b0a:	4505                	li	a0,1
    3b0c:	00002097          	auipc	ra,0x2
    3b10:	b4a080e7          	jalr	-1206(ra) # 5656 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3b14:	85ca                	mv	a1,s2
    3b16:	00004517          	auipc	a0,0x4
    3b1a:	cd250513          	addi	a0,a0,-814 # 77e8 <malloc+0x1d4c>
    3b1e:	00002097          	auipc	ra,0x2
    3b22:	ec0080e7          	jalr	-320(ra) # 59de <printf>
    exit(1);
    3b26:	4505                	li	a0,1
    3b28:	00002097          	auipc	ra,0x2
    3b2c:	b2e080e7          	jalr	-1234(ra) # 5656 <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    3b30:	85ca                	mv	a1,s2
    3b32:	00004517          	auipc	a0,0x4
    3b36:	cde50513          	addi	a0,a0,-802 # 7810 <malloc+0x1d74>
    3b3a:	00002097          	auipc	ra,0x2
    3b3e:	ea4080e7          	jalr	-348(ra) # 59de <printf>
    exit(1);
    3b42:	4505                	li	a0,1
    3b44:	00002097          	auipc	ra,0x2
    3b48:	b12080e7          	jalr	-1262(ra) # 5656 <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    3b4c:	85ca                	mv	a1,s2
    3b4e:	00004517          	auipc	a0,0x4
    3b52:	cea50513          	addi	a0,a0,-790 # 7838 <malloc+0x1d9c>
    3b56:	00002097          	auipc	ra,0x2
    3b5a:	e88080e7          	jalr	-376(ra) # 59de <printf>
    exit(1);
    3b5e:	4505                	li	a0,1
    3b60:	00002097          	auipc	ra,0x2
    3b64:	af6080e7          	jalr	-1290(ra) # 5656 <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    3b68:	85ca                	mv	a1,s2
    3b6a:	00004517          	auipc	a0,0x4
    3b6e:	cf650513          	addi	a0,a0,-778 # 7860 <malloc+0x1dc4>
    3b72:	00002097          	auipc	ra,0x2
    3b76:	e6c080e7          	jalr	-404(ra) # 59de <printf>
    exit(1);
    3b7a:	4505                	li	a0,1
    3b7c:	00002097          	auipc	ra,0x2
    3b80:	ada080e7          	jalr	-1318(ra) # 5656 <exit>
    printf("%s: unlink dirfile failed!\n", s);
    3b84:	85ca                	mv	a1,s2
    3b86:	00004517          	auipc	a0,0x4
    3b8a:	d0250513          	addi	a0,a0,-766 # 7888 <malloc+0x1dec>
    3b8e:	00002097          	auipc	ra,0x2
    3b92:	e50080e7          	jalr	-432(ra) # 59de <printf>
    exit(1);
    3b96:	4505                	li	a0,1
    3b98:	00002097          	auipc	ra,0x2
    3b9c:	abe080e7          	jalr	-1346(ra) # 5656 <exit>
    printf("%s: open . for writing succeeded!\n", s);
    3ba0:	85ca                	mv	a1,s2
    3ba2:	00004517          	auipc	a0,0x4
    3ba6:	d0650513          	addi	a0,a0,-762 # 78a8 <malloc+0x1e0c>
    3baa:	00002097          	auipc	ra,0x2
    3bae:	e34080e7          	jalr	-460(ra) # 59de <printf>
    exit(1);
    3bb2:	4505                	li	a0,1
    3bb4:	00002097          	auipc	ra,0x2
    3bb8:	aa2080e7          	jalr	-1374(ra) # 5656 <exit>
    printf("%s: write . succeeded!\n", s);
    3bbc:	85ca                	mv	a1,s2
    3bbe:	00004517          	auipc	a0,0x4
    3bc2:	d1250513          	addi	a0,a0,-750 # 78d0 <malloc+0x1e34>
    3bc6:	00002097          	auipc	ra,0x2
    3bca:	e18080e7          	jalr	-488(ra) # 59de <printf>
    exit(1);
    3bce:	4505                	li	a0,1
    3bd0:	00002097          	auipc	ra,0x2
    3bd4:	a86080e7          	jalr	-1402(ra) # 5656 <exit>

0000000000003bd8 <iref>:
{
    3bd8:	7139                	addi	sp,sp,-64
    3bda:	fc06                	sd	ra,56(sp)
    3bdc:	f822                	sd	s0,48(sp)
    3bde:	f426                	sd	s1,40(sp)
    3be0:	f04a                	sd	s2,32(sp)
    3be2:	ec4e                	sd	s3,24(sp)
    3be4:	e852                	sd	s4,16(sp)
    3be6:	e456                	sd	s5,8(sp)
    3be8:	e05a                	sd	s6,0(sp)
    3bea:	0080                	addi	s0,sp,64
    3bec:	8b2a                	mv	s6,a0
    3bee:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    3bf2:	00004a17          	auipc	s4,0x4
    3bf6:	cf6a0a13          	addi	s4,s4,-778 # 78e8 <malloc+0x1e4c>
    mkdir("");
    3bfa:	00003497          	auipc	s1,0x3
    3bfe:	7fe48493          	addi	s1,s1,2046 # 73f8 <malloc+0x195c>
    link("README", "");
    3c02:	00002a97          	auipc	s5,0x2
    3c06:	46ea8a93          	addi	s5,s5,1134 # 6070 <malloc+0x5d4>
    fd = open("xx", O_CREATE);
    3c0a:	00004997          	auipc	s3,0x4
    3c0e:	bd698993          	addi	s3,s3,-1066 # 77e0 <malloc+0x1d44>
    3c12:	a891                	j	3c66 <iref+0x8e>
      printf("%s: mkdir irefd failed\n", s);
    3c14:	85da                	mv	a1,s6
    3c16:	00004517          	auipc	a0,0x4
    3c1a:	cda50513          	addi	a0,a0,-806 # 78f0 <malloc+0x1e54>
    3c1e:	00002097          	auipc	ra,0x2
    3c22:	dc0080e7          	jalr	-576(ra) # 59de <printf>
      exit(1);
    3c26:	4505                	li	a0,1
    3c28:	00002097          	auipc	ra,0x2
    3c2c:	a2e080e7          	jalr	-1490(ra) # 5656 <exit>
      printf("%s: chdir irefd failed\n", s);
    3c30:	85da                	mv	a1,s6
    3c32:	00004517          	auipc	a0,0x4
    3c36:	cd650513          	addi	a0,a0,-810 # 7908 <malloc+0x1e6c>
    3c3a:	00002097          	auipc	ra,0x2
    3c3e:	da4080e7          	jalr	-604(ra) # 59de <printf>
      exit(1);
    3c42:	4505                	li	a0,1
    3c44:	00002097          	auipc	ra,0x2
    3c48:	a12080e7          	jalr	-1518(ra) # 5656 <exit>
      close(fd);
    3c4c:	00002097          	auipc	ra,0x2
    3c50:	a32080e7          	jalr	-1486(ra) # 567e <close>
    3c54:	a889                	j	3ca6 <iref+0xce>
    unlink("xx");
    3c56:	854e                	mv	a0,s3
    3c58:	00002097          	auipc	ra,0x2
    3c5c:	a4e080e7          	jalr	-1458(ra) # 56a6 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    3c60:	397d                	addiw	s2,s2,-1
    3c62:	06090063          	beqz	s2,3cc2 <iref+0xea>
    if(mkdir("irefd") != 0){
    3c66:	8552                	mv	a0,s4
    3c68:	00002097          	auipc	ra,0x2
    3c6c:	a56080e7          	jalr	-1450(ra) # 56be <mkdir>
    3c70:	f155                	bnez	a0,3c14 <iref+0x3c>
    if(chdir("irefd") != 0){
    3c72:	8552                	mv	a0,s4
    3c74:	00002097          	auipc	ra,0x2
    3c78:	a52080e7          	jalr	-1454(ra) # 56c6 <chdir>
    3c7c:	f955                	bnez	a0,3c30 <iref+0x58>
    mkdir("");
    3c7e:	8526                	mv	a0,s1
    3c80:	00002097          	auipc	ra,0x2
    3c84:	a3e080e7          	jalr	-1474(ra) # 56be <mkdir>
    link("README", "");
    3c88:	85a6                	mv	a1,s1
    3c8a:	8556                	mv	a0,s5
    3c8c:	00002097          	auipc	ra,0x2
    3c90:	a2a080e7          	jalr	-1494(ra) # 56b6 <link>
    fd = open("", O_CREATE);
    3c94:	20000593          	li	a1,512
    3c98:	8526                	mv	a0,s1
    3c9a:	00002097          	auipc	ra,0x2
    3c9e:	9fc080e7          	jalr	-1540(ra) # 5696 <open>
    if(fd >= 0)
    3ca2:	fa0555e3          	bgez	a0,3c4c <iref+0x74>
    fd = open("xx", O_CREATE);
    3ca6:	20000593          	li	a1,512
    3caa:	854e                	mv	a0,s3
    3cac:	00002097          	auipc	ra,0x2
    3cb0:	9ea080e7          	jalr	-1558(ra) # 5696 <open>
    if(fd >= 0)
    3cb4:	fa0541e3          	bltz	a0,3c56 <iref+0x7e>
      close(fd);
    3cb8:	00002097          	auipc	ra,0x2
    3cbc:	9c6080e7          	jalr	-1594(ra) # 567e <close>
    3cc0:	bf59                	j	3c56 <iref+0x7e>
    3cc2:	03300493          	li	s1,51
    chdir("..");
    3cc6:	00003997          	auipc	s3,0x3
    3cca:	45298993          	addi	s3,s3,1106 # 7118 <malloc+0x167c>
    unlink("irefd");
    3cce:	00004917          	auipc	s2,0x4
    3cd2:	c1a90913          	addi	s2,s2,-998 # 78e8 <malloc+0x1e4c>
    chdir("..");
    3cd6:	854e                	mv	a0,s3
    3cd8:	00002097          	auipc	ra,0x2
    3cdc:	9ee080e7          	jalr	-1554(ra) # 56c6 <chdir>
    unlink("irefd");
    3ce0:	854a                	mv	a0,s2
    3ce2:	00002097          	auipc	ra,0x2
    3ce6:	9c4080e7          	jalr	-1596(ra) # 56a6 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    3cea:	34fd                	addiw	s1,s1,-1
    3cec:	f4ed                	bnez	s1,3cd6 <iref+0xfe>
  chdir("/");
    3cee:	00003517          	auipc	a0,0x3
    3cf2:	3d250513          	addi	a0,a0,978 # 70c0 <malloc+0x1624>
    3cf6:	00002097          	auipc	ra,0x2
    3cfa:	9d0080e7          	jalr	-1584(ra) # 56c6 <chdir>
}
    3cfe:	70e2                	ld	ra,56(sp)
    3d00:	7442                	ld	s0,48(sp)
    3d02:	74a2                	ld	s1,40(sp)
    3d04:	7902                	ld	s2,32(sp)
    3d06:	69e2                	ld	s3,24(sp)
    3d08:	6a42                	ld	s4,16(sp)
    3d0a:	6aa2                	ld	s5,8(sp)
    3d0c:	6b02                	ld	s6,0(sp)
    3d0e:	6121                	addi	sp,sp,64
    3d10:	8082                	ret

0000000000003d12 <openiputtest>:
{
    3d12:	7179                	addi	sp,sp,-48
    3d14:	f406                	sd	ra,40(sp)
    3d16:	f022                	sd	s0,32(sp)
    3d18:	ec26                	sd	s1,24(sp)
    3d1a:	1800                	addi	s0,sp,48
    3d1c:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    3d1e:	00004517          	auipc	a0,0x4
    3d22:	c0250513          	addi	a0,a0,-1022 # 7920 <malloc+0x1e84>
    3d26:	00002097          	auipc	ra,0x2
    3d2a:	998080e7          	jalr	-1640(ra) # 56be <mkdir>
    3d2e:	04054263          	bltz	a0,3d72 <openiputtest+0x60>
  pid = fork();
    3d32:	00002097          	auipc	ra,0x2
    3d36:	91c080e7          	jalr	-1764(ra) # 564e <fork>
  if(pid < 0){
    3d3a:	04054a63          	bltz	a0,3d8e <openiputtest+0x7c>
  if(pid == 0){
    3d3e:	e93d                	bnez	a0,3db4 <openiputtest+0xa2>
    int fd = open("oidir", O_RDWR);
    3d40:	4589                	li	a1,2
    3d42:	00004517          	auipc	a0,0x4
    3d46:	bde50513          	addi	a0,a0,-1058 # 7920 <malloc+0x1e84>
    3d4a:	00002097          	auipc	ra,0x2
    3d4e:	94c080e7          	jalr	-1716(ra) # 5696 <open>
    if(fd >= 0){
    3d52:	04054c63          	bltz	a0,3daa <openiputtest+0x98>
      printf("%s: open directory for write succeeded\n", s);
    3d56:	85a6                	mv	a1,s1
    3d58:	00004517          	auipc	a0,0x4
    3d5c:	be850513          	addi	a0,a0,-1048 # 7940 <malloc+0x1ea4>
    3d60:	00002097          	auipc	ra,0x2
    3d64:	c7e080e7          	jalr	-898(ra) # 59de <printf>
      exit(1);
    3d68:	4505                	li	a0,1
    3d6a:	00002097          	auipc	ra,0x2
    3d6e:	8ec080e7          	jalr	-1812(ra) # 5656 <exit>
    printf("%s: mkdir oidir failed\n", s);
    3d72:	85a6                	mv	a1,s1
    3d74:	00004517          	auipc	a0,0x4
    3d78:	bb450513          	addi	a0,a0,-1100 # 7928 <malloc+0x1e8c>
    3d7c:	00002097          	auipc	ra,0x2
    3d80:	c62080e7          	jalr	-926(ra) # 59de <printf>
    exit(1);
    3d84:	4505                	li	a0,1
    3d86:	00002097          	auipc	ra,0x2
    3d8a:	8d0080e7          	jalr	-1840(ra) # 5656 <exit>
    printf("%s: fork failed\n", s);
    3d8e:	85a6                	mv	a1,s1
    3d90:	00003517          	auipc	a0,0x3
    3d94:	98050513          	addi	a0,a0,-1664 # 6710 <malloc+0xc74>
    3d98:	00002097          	auipc	ra,0x2
    3d9c:	c46080e7          	jalr	-954(ra) # 59de <printf>
    exit(1);
    3da0:	4505                	li	a0,1
    3da2:	00002097          	auipc	ra,0x2
    3da6:	8b4080e7          	jalr	-1868(ra) # 5656 <exit>
    exit(0);
    3daa:	4501                	li	a0,0
    3dac:	00002097          	auipc	ra,0x2
    3db0:	8aa080e7          	jalr	-1878(ra) # 5656 <exit>
  sleep(1);
    3db4:	4505                	li	a0,1
    3db6:	00002097          	auipc	ra,0x2
    3dba:	930080e7          	jalr	-1744(ra) # 56e6 <sleep>
  if(unlink("oidir") != 0){
    3dbe:	00004517          	auipc	a0,0x4
    3dc2:	b6250513          	addi	a0,a0,-1182 # 7920 <malloc+0x1e84>
    3dc6:	00002097          	auipc	ra,0x2
    3dca:	8e0080e7          	jalr	-1824(ra) # 56a6 <unlink>
    3dce:	cd19                	beqz	a0,3dec <openiputtest+0xda>
    printf("%s: unlink failed\n", s);
    3dd0:	85a6                	mv	a1,s1
    3dd2:	00003517          	auipc	a0,0x3
    3dd6:	b2e50513          	addi	a0,a0,-1234 # 6900 <malloc+0xe64>
    3dda:	00002097          	auipc	ra,0x2
    3dde:	c04080e7          	jalr	-1020(ra) # 59de <printf>
    exit(1);
    3de2:	4505                	li	a0,1
    3de4:	00002097          	auipc	ra,0x2
    3de8:	872080e7          	jalr	-1934(ra) # 5656 <exit>
  wait(&xstatus);
    3dec:	fdc40513          	addi	a0,s0,-36
    3df0:	00002097          	auipc	ra,0x2
    3df4:	86e080e7          	jalr	-1938(ra) # 565e <wait>
  exit(xstatus);
    3df8:	fdc42503          	lw	a0,-36(s0)
    3dfc:	00002097          	auipc	ra,0x2
    3e00:	85a080e7          	jalr	-1958(ra) # 5656 <exit>

0000000000003e04 <forkforkfork>:
{
    3e04:	1101                	addi	sp,sp,-32
    3e06:	ec06                	sd	ra,24(sp)
    3e08:	e822                	sd	s0,16(sp)
    3e0a:	e426                	sd	s1,8(sp)
    3e0c:	1000                	addi	s0,sp,32
    3e0e:	84aa                	mv	s1,a0
  unlink("stopforking");
    3e10:	00004517          	auipc	a0,0x4
    3e14:	b5850513          	addi	a0,a0,-1192 # 7968 <malloc+0x1ecc>
    3e18:	00002097          	auipc	ra,0x2
    3e1c:	88e080e7          	jalr	-1906(ra) # 56a6 <unlink>
  int pid = fork();
    3e20:	00002097          	auipc	ra,0x2
    3e24:	82e080e7          	jalr	-2002(ra) # 564e <fork>
  if(pid < 0){
    3e28:	04054563          	bltz	a0,3e72 <forkforkfork+0x6e>
  if(pid == 0){
    3e2c:	c12d                	beqz	a0,3e8e <forkforkfork+0x8a>
  sleep(20); // two seconds
    3e2e:	4551                	li	a0,20
    3e30:	00002097          	auipc	ra,0x2
    3e34:	8b6080e7          	jalr	-1866(ra) # 56e6 <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    3e38:	20200593          	li	a1,514
    3e3c:	00004517          	auipc	a0,0x4
    3e40:	b2c50513          	addi	a0,a0,-1236 # 7968 <malloc+0x1ecc>
    3e44:	00002097          	auipc	ra,0x2
    3e48:	852080e7          	jalr	-1966(ra) # 5696 <open>
    3e4c:	00002097          	auipc	ra,0x2
    3e50:	832080e7          	jalr	-1998(ra) # 567e <close>
  wait(0);
    3e54:	4501                	li	a0,0
    3e56:	00002097          	auipc	ra,0x2
    3e5a:	808080e7          	jalr	-2040(ra) # 565e <wait>
  sleep(10); // one second
    3e5e:	4529                	li	a0,10
    3e60:	00002097          	auipc	ra,0x2
    3e64:	886080e7          	jalr	-1914(ra) # 56e6 <sleep>
}
    3e68:	60e2                	ld	ra,24(sp)
    3e6a:	6442                	ld	s0,16(sp)
    3e6c:	64a2                	ld	s1,8(sp)
    3e6e:	6105                	addi	sp,sp,32
    3e70:	8082                	ret
    printf("%s: fork failed", s);
    3e72:	85a6                	mv	a1,s1
    3e74:	00003517          	auipc	a0,0x3
    3e78:	a5c50513          	addi	a0,a0,-1444 # 68d0 <malloc+0xe34>
    3e7c:	00002097          	auipc	ra,0x2
    3e80:	b62080e7          	jalr	-1182(ra) # 59de <printf>
    exit(1);
    3e84:	4505                	li	a0,1
    3e86:	00001097          	auipc	ra,0x1
    3e8a:	7d0080e7          	jalr	2000(ra) # 5656 <exit>
      int fd = open("stopforking", 0);
    3e8e:	00004497          	auipc	s1,0x4
    3e92:	ada48493          	addi	s1,s1,-1318 # 7968 <malloc+0x1ecc>
    3e96:	4581                	li	a1,0
    3e98:	8526                	mv	a0,s1
    3e9a:	00001097          	auipc	ra,0x1
    3e9e:	7fc080e7          	jalr	2044(ra) # 5696 <open>
      if(fd >= 0){
    3ea2:	02055463          	bgez	a0,3eca <forkforkfork+0xc6>
      if(fork() < 0){
    3ea6:	00001097          	auipc	ra,0x1
    3eaa:	7a8080e7          	jalr	1960(ra) # 564e <fork>
    3eae:	fe0554e3          	bgez	a0,3e96 <forkforkfork+0x92>
        close(open("stopforking", O_CREATE|O_RDWR));
    3eb2:	20200593          	li	a1,514
    3eb6:	8526                	mv	a0,s1
    3eb8:	00001097          	auipc	ra,0x1
    3ebc:	7de080e7          	jalr	2014(ra) # 5696 <open>
    3ec0:	00001097          	auipc	ra,0x1
    3ec4:	7be080e7          	jalr	1982(ra) # 567e <close>
    3ec8:	b7f9                	j	3e96 <forkforkfork+0x92>
        exit(0);
    3eca:	4501                	li	a0,0
    3ecc:	00001097          	auipc	ra,0x1
    3ed0:	78a080e7          	jalr	1930(ra) # 5656 <exit>

0000000000003ed4 <preempt>:
{
    3ed4:	7139                	addi	sp,sp,-64
    3ed6:	fc06                	sd	ra,56(sp)
    3ed8:	f822                	sd	s0,48(sp)
    3eda:	f426                	sd	s1,40(sp)
    3edc:	f04a                	sd	s2,32(sp)
    3ede:	ec4e                	sd	s3,24(sp)
    3ee0:	e852                	sd	s4,16(sp)
    3ee2:	0080                	addi	s0,sp,64
    3ee4:	84aa                	mv	s1,a0
  pid1 = fork();
    3ee6:	00001097          	auipc	ra,0x1
    3eea:	768080e7          	jalr	1896(ra) # 564e <fork>
  if(pid1 < 0) {
    3eee:	00054563          	bltz	a0,3ef8 <preempt+0x24>
    3ef2:	8a2a                	mv	s4,a0
  if(pid1 == 0)
    3ef4:	e105                	bnez	a0,3f14 <preempt+0x40>
    for(;;)
    3ef6:	a001                	j	3ef6 <preempt+0x22>
    printf("%s: fork failed", s);
    3ef8:	85a6                	mv	a1,s1
    3efa:	00003517          	auipc	a0,0x3
    3efe:	9d650513          	addi	a0,a0,-1578 # 68d0 <malloc+0xe34>
    3f02:	00002097          	auipc	ra,0x2
    3f06:	adc080e7          	jalr	-1316(ra) # 59de <printf>
    exit(1);
    3f0a:	4505                	li	a0,1
    3f0c:	00001097          	auipc	ra,0x1
    3f10:	74a080e7          	jalr	1866(ra) # 5656 <exit>
  pid2 = fork();
    3f14:	00001097          	auipc	ra,0x1
    3f18:	73a080e7          	jalr	1850(ra) # 564e <fork>
    3f1c:	89aa                	mv	s3,a0
  if(pid2 < 0) {
    3f1e:	00054463          	bltz	a0,3f26 <preempt+0x52>
  if(pid2 == 0)
    3f22:	e105                	bnez	a0,3f42 <preempt+0x6e>
    for(;;)
    3f24:	a001                	j	3f24 <preempt+0x50>
    printf("%s: fork failed\n", s);
    3f26:	85a6                	mv	a1,s1
    3f28:	00002517          	auipc	a0,0x2
    3f2c:	7e850513          	addi	a0,a0,2024 # 6710 <malloc+0xc74>
    3f30:	00002097          	auipc	ra,0x2
    3f34:	aae080e7          	jalr	-1362(ra) # 59de <printf>
    exit(1);
    3f38:	4505                	li	a0,1
    3f3a:	00001097          	auipc	ra,0x1
    3f3e:	71c080e7          	jalr	1820(ra) # 5656 <exit>
  pipe(pfds);
    3f42:	fc840513          	addi	a0,s0,-56
    3f46:	00001097          	auipc	ra,0x1
    3f4a:	720080e7          	jalr	1824(ra) # 5666 <pipe>
  pid3 = fork();
    3f4e:	00001097          	auipc	ra,0x1
    3f52:	700080e7          	jalr	1792(ra) # 564e <fork>
    3f56:	892a                	mv	s2,a0
  if(pid3 < 0) {
    3f58:	02054e63          	bltz	a0,3f94 <preempt+0xc0>
  if(pid3 == 0){
    3f5c:	e525                	bnez	a0,3fc4 <preempt+0xf0>
    close(pfds[0]);
    3f5e:	fc842503          	lw	a0,-56(s0)
    3f62:	00001097          	auipc	ra,0x1
    3f66:	71c080e7          	jalr	1820(ra) # 567e <close>
    if(write(pfds[1], "x", 1) != 1)
    3f6a:	4605                	li	a2,1
    3f6c:	00002597          	auipc	a1,0x2
    3f70:	fdc58593          	addi	a1,a1,-36 # 5f48 <malloc+0x4ac>
    3f74:	fcc42503          	lw	a0,-52(s0)
    3f78:	00001097          	auipc	ra,0x1
    3f7c:	6fe080e7          	jalr	1790(ra) # 5676 <write>
    3f80:	4785                	li	a5,1
    3f82:	02f51763          	bne	a0,a5,3fb0 <preempt+0xdc>
    close(pfds[1]);
    3f86:	fcc42503          	lw	a0,-52(s0)
    3f8a:	00001097          	auipc	ra,0x1
    3f8e:	6f4080e7          	jalr	1780(ra) # 567e <close>
    for(;;)
    3f92:	a001                	j	3f92 <preempt+0xbe>
     printf("%s: fork failed\n", s);
    3f94:	85a6                	mv	a1,s1
    3f96:	00002517          	auipc	a0,0x2
    3f9a:	77a50513          	addi	a0,a0,1914 # 6710 <malloc+0xc74>
    3f9e:	00002097          	auipc	ra,0x2
    3fa2:	a40080e7          	jalr	-1472(ra) # 59de <printf>
     exit(1);
    3fa6:	4505                	li	a0,1
    3fa8:	00001097          	auipc	ra,0x1
    3fac:	6ae080e7          	jalr	1710(ra) # 5656 <exit>
      printf("%s: preempt write error", s);
    3fb0:	85a6                	mv	a1,s1
    3fb2:	00004517          	auipc	a0,0x4
    3fb6:	9c650513          	addi	a0,a0,-1594 # 7978 <malloc+0x1edc>
    3fba:	00002097          	auipc	ra,0x2
    3fbe:	a24080e7          	jalr	-1500(ra) # 59de <printf>
    3fc2:	b7d1                	j	3f86 <preempt+0xb2>
  close(pfds[1]);
    3fc4:	fcc42503          	lw	a0,-52(s0)
    3fc8:	00001097          	auipc	ra,0x1
    3fcc:	6b6080e7          	jalr	1718(ra) # 567e <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    3fd0:	660d                	lui	a2,0x3
    3fd2:	00008597          	auipc	a1,0x8
    3fd6:	b6e58593          	addi	a1,a1,-1170 # bb40 <buf>
    3fda:	fc842503          	lw	a0,-56(s0)
    3fde:	00001097          	auipc	ra,0x1
    3fe2:	690080e7          	jalr	1680(ra) # 566e <read>
    3fe6:	4785                	li	a5,1
    3fe8:	02f50363          	beq	a0,a5,400e <preempt+0x13a>
    printf("%s: preempt read error", s);
    3fec:	85a6                	mv	a1,s1
    3fee:	00004517          	auipc	a0,0x4
    3ff2:	9a250513          	addi	a0,a0,-1630 # 7990 <malloc+0x1ef4>
    3ff6:	00002097          	auipc	ra,0x2
    3ffa:	9e8080e7          	jalr	-1560(ra) # 59de <printf>
}
    3ffe:	70e2                	ld	ra,56(sp)
    4000:	7442                	ld	s0,48(sp)
    4002:	74a2                	ld	s1,40(sp)
    4004:	7902                	ld	s2,32(sp)
    4006:	69e2                	ld	s3,24(sp)
    4008:	6a42                	ld	s4,16(sp)
    400a:	6121                	addi	sp,sp,64
    400c:	8082                	ret
  close(pfds[0]);
    400e:	fc842503          	lw	a0,-56(s0)
    4012:	00001097          	auipc	ra,0x1
    4016:	66c080e7          	jalr	1644(ra) # 567e <close>
  printf("kill... ");
    401a:	00004517          	auipc	a0,0x4
    401e:	98e50513          	addi	a0,a0,-1650 # 79a8 <malloc+0x1f0c>
    4022:	00002097          	auipc	ra,0x2
    4026:	9bc080e7          	jalr	-1604(ra) # 59de <printf>
  kill(pid1);
    402a:	8552                	mv	a0,s4
    402c:	00001097          	auipc	ra,0x1
    4030:	65a080e7          	jalr	1626(ra) # 5686 <kill>
  kill(pid2);
    4034:	854e                	mv	a0,s3
    4036:	00001097          	auipc	ra,0x1
    403a:	650080e7          	jalr	1616(ra) # 5686 <kill>
  kill(pid3);
    403e:	854a                	mv	a0,s2
    4040:	00001097          	auipc	ra,0x1
    4044:	646080e7          	jalr	1606(ra) # 5686 <kill>
  printf("wait... ");
    4048:	00004517          	auipc	a0,0x4
    404c:	97050513          	addi	a0,a0,-1680 # 79b8 <malloc+0x1f1c>
    4050:	00002097          	auipc	ra,0x2
    4054:	98e080e7          	jalr	-1650(ra) # 59de <printf>
  wait(0);
    4058:	4501                	li	a0,0
    405a:	00001097          	auipc	ra,0x1
    405e:	604080e7          	jalr	1540(ra) # 565e <wait>
  wait(0);
    4062:	4501                	li	a0,0
    4064:	00001097          	auipc	ra,0x1
    4068:	5fa080e7          	jalr	1530(ra) # 565e <wait>
  wait(0);
    406c:	4501                	li	a0,0
    406e:	00001097          	auipc	ra,0x1
    4072:	5f0080e7          	jalr	1520(ra) # 565e <wait>
    4076:	b761                	j	3ffe <preempt+0x12a>

0000000000004078 <sbrkfail>:
{
    4078:	7119                	addi	sp,sp,-128
    407a:	fc86                	sd	ra,120(sp)
    407c:	f8a2                	sd	s0,112(sp)
    407e:	f4a6                	sd	s1,104(sp)
    4080:	f0ca                	sd	s2,96(sp)
    4082:	ecce                	sd	s3,88(sp)
    4084:	e8d2                	sd	s4,80(sp)
    4086:	e4d6                	sd	s5,72(sp)
    4088:	0100                	addi	s0,sp,128
    408a:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
    408c:	fb040513          	addi	a0,s0,-80
    4090:	00001097          	auipc	ra,0x1
    4094:	5d6080e7          	jalr	1494(ra) # 5666 <pipe>
    4098:	e901                	bnez	a0,40a8 <sbrkfail+0x30>
    409a:	f8040493          	addi	s1,s0,-128
    409e:	fa840a13          	addi	s4,s0,-88
    40a2:	89a6                	mv	s3,s1
    if(pids[i] != -1)
    40a4:	5afd                	li	s5,-1
    40a6:	a08d                	j	4108 <sbrkfail+0x90>
    printf("%s: pipe() failed\n", s);
    40a8:	85ca                	mv	a1,s2
    40aa:	00002517          	auipc	a0,0x2
    40ae:	76e50513          	addi	a0,a0,1902 # 6818 <malloc+0xd7c>
    40b2:	00002097          	auipc	ra,0x2
    40b6:	92c080e7          	jalr	-1748(ra) # 59de <printf>
    exit(1);
    40ba:	4505                	li	a0,1
    40bc:	00001097          	auipc	ra,0x1
    40c0:	59a080e7          	jalr	1434(ra) # 5656 <exit>
      sbrk(BIG - (uint64)sbrk(0));
    40c4:	4501                	li	a0,0
    40c6:	00001097          	auipc	ra,0x1
    40ca:	618080e7          	jalr	1560(ra) # 56de <sbrk>
    40ce:	064007b7          	lui	a5,0x6400
    40d2:	40a7853b          	subw	a0,a5,a0
    40d6:	00001097          	auipc	ra,0x1
    40da:	608080e7          	jalr	1544(ra) # 56de <sbrk>
      write(fds[1], "x", 1);
    40de:	4605                	li	a2,1
    40e0:	00002597          	auipc	a1,0x2
    40e4:	e6858593          	addi	a1,a1,-408 # 5f48 <malloc+0x4ac>
    40e8:	fb442503          	lw	a0,-76(s0)
    40ec:	00001097          	auipc	ra,0x1
    40f0:	58a080e7          	jalr	1418(ra) # 5676 <write>
      for(;;) sleep(1000);
    40f4:	3e800513          	li	a0,1000
    40f8:	00001097          	auipc	ra,0x1
    40fc:	5ee080e7          	jalr	1518(ra) # 56e6 <sleep>
    4100:	bfd5                	j	40f4 <sbrkfail+0x7c>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    4102:	0991                	addi	s3,s3,4
    4104:	03498563          	beq	s3,s4,412e <sbrkfail+0xb6>
    if((pids[i] = fork()) == 0){
    4108:	00001097          	auipc	ra,0x1
    410c:	546080e7          	jalr	1350(ra) # 564e <fork>
    4110:	00a9a023          	sw	a0,0(s3)
    4114:	d945                	beqz	a0,40c4 <sbrkfail+0x4c>
    if(pids[i] != -1)
    4116:	ff5506e3          	beq	a0,s5,4102 <sbrkfail+0x8a>
      read(fds[0], &scratch, 1);
    411a:	4605                	li	a2,1
    411c:	faf40593          	addi	a1,s0,-81
    4120:	fb042503          	lw	a0,-80(s0)
    4124:	00001097          	auipc	ra,0x1
    4128:	54a080e7          	jalr	1354(ra) # 566e <read>
    412c:	bfd9                	j	4102 <sbrkfail+0x8a>
  printf("allocate ok\n");
    412e:	00004517          	auipc	a0,0x4
    4132:	89a50513          	addi	a0,a0,-1894 # 79c8 <malloc+0x1f2c>
    4136:	00002097          	auipc	ra,0x2
    413a:	8a8080e7          	jalr	-1880(ra) # 59de <printf>
  c = sbrk(PGSIZE);
    413e:	6505                	lui	a0,0x1
    4140:	00001097          	auipc	ra,0x1
    4144:	59e080e7          	jalr	1438(ra) # 56de <sbrk>
    4148:	89aa                	mv	s3,a0
    if(pids[i] == -1)
    414a:	5afd                	li	s5,-1
    414c:	a021                	j	4154 <sbrkfail+0xdc>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    414e:	0491                	addi	s1,s1,4
    4150:	01448f63          	beq	s1,s4,416e <sbrkfail+0xf6>
    if(pids[i] == -1)
    4154:	4088                	lw	a0,0(s1)
    4156:	ff550ce3          	beq	a0,s5,414e <sbrkfail+0xd6>
    kill(pids[i]);
    415a:	00001097          	auipc	ra,0x1
    415e:	52c080e7          	jalr	1324(ra) # 5686 <kill>
    wait(0);
    4162:	4501                	li	a0,0
    4164:	00001097          	auipc	ra,0x1
    4168:	4fa080e7          	jalr	1274(ra) # 565e <wait>
    416c:	b7cd                	j	414e <sbrkfail+0xd6>
  if(c == (char*)0xffffffffffffffffL){
    416e:	57fd                	li	a5,-1
    4170:	04f98963          	beq	s3,a5,41c2 <sbrkfail+0x14a>
    printf("sbrk ok -2 \n"); // new test
    4174:	00004517          	auipc	a0,0x4
    4178:	88450513          	addi	a0,a0,-1916 # 79f8 <malloc+0x1f5c>
    417c:	00002097          	auipc	ra,0x2
    4180:	862080e7          	jalr	-1950(ra) # 59de <printf>
  pid = fork();
    4184:	00001097          	auipc	ra,0x1
    4188:	4ca080e7          	jalr	1226(ra) # 564e <fork>
    418c:	84aa                	mv	s1,a0
  if(pid < 0){
    418e:	04054863          	bltz	a0,41de <sbrkfail+0x166>
  if(pid == 0){
    4192:	c525                	beqz	a0,41fa <sbrkfail+0x182>
  wait(&xstatus);
    4194:	fbc40513          	addi	a0,s0,-68
    4198:	00001097          	auipc	ra,0x1
    419c:	4c6080e7          	jalr	1222(ra) # 565e <wait>
  if(xstatus != -1 && xstatus != 2)
    41a0:	fbc42783          	lw	a5,-68(s0)
    41a4:	577d                	li	a4,-1
    41a6:	00e78563          	beq	a5,a4,41b0 <sbrkfail+0x138>
    41aa:	4709                	li	a4,2
    41ac:	0ae79d63          	bne	a5,a4,4266 <sbrkfail+0x1ee>
}
    41b0:	70e6                	ld	ra,120(sp)
    41b2:	7446                	ld	s0,112(sp)
    41b4:	74a6                	ld	s1,104(sp)
    41b6:	7906                	ld	s2,96(sp)
    41b8:	69e6                	ld	s3,88(sp)
    41ba:	6a46                	ld	s4,80(sp)
    41bc:	6aa6                	ld	s5,72(sp)
    41be:	6109                	addi	sp,sp,128
    41c0:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    41c2:	85ca                	mv	a1,s2
    41c4:	00004517          	auipc	a0,0x4
    41c8:	81450513          	addi	a0,a0,-2028 # 79d8 <malloc+0x1f3c>
    41cc:	00002097          	auipc	ra,0x2
    41d0:	812080e7          	jalr	-2030(ra) # 59de <printf>
    exit(1);
    41d4:	4505                	li	a0,1
    41d6:	00001097          	auipc	ra,0x1
    41da:	480080e7          	jalr	1152(ra) # 5656 <exit>
    printf("%s: fork failed\n", s);
    41de:	85ca                	mv	a1,s2
    41e0:	00002517          	auipc	a0,0x2
    41e4:	53050513          	addi	a0,a0,1328 # 6710 <malloc+0xc74>
    41e8:	00001097          	auipc	ra,0x1
    41ec:	7f6080e7          	jalr	2038(ra) # 59de <printf>
    exit(1);
    41f0:	4505                	li	a0,1
    41f2:	00001097          	auipc	ra,0x1
    41f6:	464080e7          	jalr	1124(ra) # 5656 <exit>
    printf("start to sbrk 0\n");
    41fa:	00004517          	auipc	a0,0x4
    41fe:	80e50513          	addi	a0,a0,-2034 # 7a08 <malloc+0x1f6c>
    4202:	00001097          	auipc	ra,0x1
    4206:	7dc080e7          	jalr	2012(ra) # 59de <printf>
    a = sbrk(0);
    420a:	4501                	li	a0,0
    420c:	00001097          	auipc	ra,0x1
    4210:	4d2080e7          	jalr	1234(ra) # 56de <sbrk>
    4214:	89aa                	mv	s3,a0
    printf("start to sbrk 10*BIG\n");
    4216:	00004517          	auipc	a0,0x4
    421a:	80a50513          	addi	a0,a0,-2038 # 7a20 <malloc+0x1f84>
    421e:	00001097          	auipc	ra,0x1
    4222:	7c0080e7          	jalr	1984(ra) # 59de <printf>
    sbrk(10*BIG);
    4226:	3e800537          	lui	a0,0x3e800
    422a:	00001097          	auipc	ra,0x1
    422e:	4b4080e7          	jalr	1204(ra) # 56de <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    4232:	874e                	mv	a4,s3
    4234:	3e8007b7          	lui	a5,0x3e800
    4238:	97ce                	add	a5,a5,s3
    423a:	6685                	lui	a3,0x1
      n += *(a+i);
    423c:	00074603          	lbu	a2,0(a4)
    4240:	9cb1                	addw	s1,s1,a2
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    4242:	9736                	add	a4,a4,a3
    4244:	fef71ce3          	bne	a4,a5,423c <sbrkfail+0x1c4>
    printf("%s: allocate a lot of memory succeeded %d\n", s, n);
    4248:	8626                	mv	a2,s1
    424a:	85ca                	mv	a1,s2
    424c:	00003517          	auipc	a0,0x3
    4250:	7ec50513          	addi	a0,a0,2028 # 7a38 <malloc+0x1f9c>
    4254:	00001097          	auipc	ra,0x1
    4258:	78a080e7          	jalr	1930(ra) # 59de <printf>
    exit(1);
    425c:	4505                	li	a0,1
    425e:	00001097          	auipc	ra,0x1
    4262:	3f8080e7          	jalr	1016(ra) # 5656 <exit>
    exit(1);
    4266:	4505                	li	a0,1
    4268:	00001097          	auipc	ra,0x1
    426c:	3ee080e7          	jalr	1006(ra) # 5656 <exit>

0000000000004270 <reparent>:
{
    4270:	7179                	addi	sp,sp,-48
    4272:	f406                	sd	ra,40(sp)
    4274:	f022                	sd	s0,32(sp)
    4276:	ec26                	sd	s1,24(sp)
    4278:	e84a                	sd	s2,16(sp)
    427a:	e44e                	sd	s3,8(sp)
    427c:	e052                	sd	s4,0(sp)
    427e:	1800                	addi	s0,sp,48
    4280:	89aa                	mv	s3,a0
  int master_pid = getpid();
    4282:	00001097          	auipc	ra,0x1
    4286:	454080e7          	jalr	1108(ra) # 56d6 <getpid>
    428a:	8a2a                	mv	s4,a0
    428c:	0c800913          	li	s2,200
    int pid = fork();
    4290:	00001097          	auipc	ra,0x1
    4294:	3be080e7          	jalr	958(ra) # 564e <fork>
    4298:	84aa                	mv	s1,a0
    if(pid < 0){
    429a:	02054263          	bltz	a0,42be <reparent+0x4e>
    if(pid){
    429e:	cd21                	beqz	a0,42f6 <reparent+0x86>
      if(wait(0) != pid){
    42a0:	4501                	li	a0,0
    42a2:	00001097          	auipc	ra,0x1
    42a6:	3bc080e7          	jalr	956(ra) # 565e <wait>
    42aa:	02951863          	bne	a0,s1,42da <reparent+0x6a>
  for(int i = 0; i < 200; i++){
    42ae:	397d                	addiw	s2,s2,-1
    42b0:	fe0910e3          	bnez	s2,4290 <reparent+0x20>
  exit(0);
    42b4:	4501                	li	a0,0
    42b6:	00001097          	auipc	ra,0x1
    42ba:	3a0080e7          	jalr	928(ra) # 5656 <exit>
      printf("%s: fork failed\n", s);
    42be:	85ce                	mv	a1,s3
    42c0:	00002517          	auipc	a0,0x2
    42c4:	45050513          	addi	a0,a0,1104 # 6710 <malloc+0xc74>
    42c8:	00001097          	auipc	ra,0x1
    42cc:	716080e7          	jalr	1814(ra) # 59de <printf>
      exit(1);
    42d0:	4505                	li	a0,1
    42d2:	00001097          	auipc	ra,0x1
    42d6:	384080e7          	jalr	900(ra) # 5656 <exit>
        printf("%s: wait wrong pid\n", s);
    42da:	85ce                	mv	a1,s3
    42dc:	00002517          	auipc	a0,0x2
    42e0:	5bc50513          	addi	a0,a0,1468 # 6898 <malloc+0xdfc>
    42e4:	00001097          	auipc	ra,0x1
    42e8:	6fa080e7          	jalr	1786(ra) # 59de <printf>
        exit(1);
    42ec:	4505                	li	a0,1
    42ee:	00001097          	auipc	ra,0x1
    42f2:	368080e7          	jalr	872(ra) # 5656 <exit>
      int pid2 = fork();
    42f6:	00001097          	auipc	ra,0x1
    42fa:	358080e7          	jalr	856(ra) # 564e <fork>
      if(pid2 < 0){
    42fe:	00054763          	bltz	a0,430c <reparent+0x9c>
      exit(0);
    4302:	4501                	li	a0,0
    4304:	00001097          	auipc	ra,0x1
    4308:	352080e7          	jalr	850(ra) # 5656 <exit>
        kill(master_pid);
    430c:	8552                	mv	a0,s4
    430e:	00001097          	auipc	ra,0x1
    4312:	378080e7          	jalr	888(ra) # 5686 <kill>
        exit(1);
    4316:	4505                	li	a0,1
    4318:	00001097          	auipc	ra,0x1
    431c:	33e080e7          	jalr	830(ra) # 5656 <exit>

0000000000004320 <mem>:
{
    4320:	7139                	addi	sp,sp,-64
    4322:	fc06                	sd	ra,56(sp)
    4324:	f822                	sd	s0,48(sp)
    4326:	f426                	sd	s1,40(sp)
    4328:	f04a                	sd	s2,32(sp)
    432a:	ec4e                	sd	s3,24(sp)
    432c:	0080                	addi	s0,sp,64
    432e:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    4330:	00001097          	auipc	ra,0x1
    4334:	31e080e7          	jalr	798(ra) # 564e <fork>
    m1 = 0;
    4338:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    433a:	6909                	lui	s2,0x2
    433c:	71190913          	addi	s2,s2,1809 # 2711 <sbrkbasic+0x159>
  if((pid = fork()) == 0){
    4340:	ed39                	bnez	a0,439e <mem+0x7e>
    while((m2 = malloc(10001)) != 0){
    4342:	854a                	mv	a0,s2
    4344:	00001097          	auipc	ra,0x1
    4348:	758080e7          	jalr	1880(ra) # 5a9c <malloc>
    434c:	c501                	beqz	a0,4354 <mem+0x34>
      *(char**)m2 = m1;
    434e:	e104                	sd	s1,0(a0)
      m1 = m2;
    4350:	84aa                	mv	s1,a0
    4352:	bfc5                	j	4342 <mem+0x22>
    while(m1){
    4354:	c881                	beqz	s1,4364 <mem+0x44>
      m2 = *(char**)m1;
    4356:	8526                	mv	a0,s1
    4358:	6084                	ld	s1,0(s1)
      free(m1);
    435a:	00001097          	auipc	ra,0x1
    435e:	6ba080e7          	jalr	1722(ra) # 5a14 <free>
    while(m1){
    4362:	f8f5                	bnez	s1,4356 <mem+0x36>
    m1 = malloc(1024*20);
    4364:	6515                	lui	a0,0x5
    4366:	00001097          	auipc	ra,0x1
    436a:	736080e7          	jalr	1846(ra) # 5a9c <malloc>
    if(m1 == 0){
    436e:	c911                	beqz	a0,4382 <mem+0x62>
    free(m1);
    4370:	00001097          	auipc	ra,0x1
    4374:	6a4080e7          	jalr	1700(ra) # 5a14 <free>
    exit(0);
    4378:	4501                	li	a0,0
    437a:	00001097          	auipc	ra,0x1
    437e:	2dc080e7          	jalr	732(ra) # 5656 <exit>
      printf("couldn't allocate mem?!!\n", s);
    4382:	85ce                	mv	a1,s3
    4384:	00003517          	auipc	a0,0x3
    4388:	6e450513          	addi	a0,a0,1764 # 7a68 <malloc+0x1fcc>
    438c:	00001097          	auipc	ra,0x1
    4390:	652080e7          	jalr	1618(ra) # 59de <printf>
      exit(1);
    4394:	4505                	li	a0,1
    4396:	00001097          	auipc	ra,0x1
    439a:	2c0080e7          	jalr	704(ra) # 5656 <exit>
    wait(&xstatus);
    439e:	fcc40513          	addi	a0,s0,-52
    43a2:	00001097          	auipc	ra,0x1
    43a6:	2bc080e7          	jalr	700(ra) # 565e <wait>
    if(xstatus == -1){
    43aa:	fcc42503          	lw	a0,-52(s0)
    43ae:	57fd                	li	a5,-1
    43b0:	00f50663          	beq	a0,a5,43bc <mem+0x9c>
    exit(xstatus);
    43b4:	00001097          	auipc	ra,0x1
    43b8:	2a2080e7          	jalr	674(ra) # 5656 <exit>
      exit(0);
    43bc:	4501                	li	a0,0
    43be:	00001097          	auipc	ra,0x1
    43c2:	298080e7          	jalr	664(ra) # 5656 <exit>

00000000000043c6 <sharedfd>:
{
    43c6:	7159                	addi	sp,sp,-112
    43c8:	f486                	sd	ra,104(sp)
    43ca:	f0a2                	sd	s0,96(sp)
    43cc:	eca6                	sd	s1,88(sp)
    43ce:	e8ca                	sd	s2,80(sp)
    43d0:	e4ce                	sd	s3,72(sp)
    43d2:	e0d2                	sd	s4,64(sp)
    43d4:	fc56                	sd	s5,56(sp)
    43d6:	f85a                	sd	s6,48(sp)
    43d8:	f45e                	sd	s7,40(sp)
    43da:	1880                	addi	s0,sp,112
    43dc:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    43de:	00002517          	auipc	a0,0x2
    43e2:	93a50513          	addi	a0,a0,-1734 # 5d18 <malloc+0x27c>
    43e6:	00001097          	auipc	ra,0x1
    43ea:	2c0080e7          	jalr	704(ra) # 56a6 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    43ee:	20200593          	li	a1,514
    43f2:	00002517          	auipc	a0,0x2
    43f6:	92650513          	addi	a0,a0,-1754 # 5d18 <malloc+0x27c>
    43fa:	00001097          	auipc	ra,0x1
    43fe:	29c080e7          	jalr	668(ra) # 5696 <open>
  if(fd < 0){
    4402:	04054a63          	bltz	a0,4456 <sharedfd+0x90>
    4406:	892a                	mv	s2,a0
  pid = fork();
    4408:	00001097          	auipc	ra,0x1
    440c:	246080e7          	jalr	582(ra) # 564e <fork>
    4410:	89aa                	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    4412:	06300593          	li	a1,99
    4416:	c119                	beqz	a0,441c <sharedfd+0x56>
    4418:	07000593          	li	a1,112
    441c:	4629                	li	a2,10
    441e:	fa040513          	addi	a0,s0,-96
    4422:	00001097          	auipc	ra,0x1
    4426:	030080e7          	jalr	48(ra) # 5452 <memset>
    442a:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    442e:	4629                	li	a2,10
    4430:	fa040593          	addi	a1,s0,-96
    4434:	854a                	mv	a0,s2
    4436:	00001097          	auipc	ra,0x1
    443a:	240080e7          	jalr	576(ra) # 5676 <write>
    443e:	47a9                	li	a5,10
    4440:	02f51963          	bne	a0,a5,4472 <sharedfd+0xac>
  for(i = 0; i < N; i++){
    4444:	34fd                	addiw	s1,s1,-1
    4446:	f4e5                	bnez	s1,442e <sharedfd+0x68>
  if(pid == 0) {
    4448:	04099363          	bnez	s3,448e <sharedfd+0xc8>
    exit(0);
    444c:	4501                	li	a0,0
    444e:	00001097          	auipc	ra,0x1
    4452:	208080e7          	jalr	520(ra) # 5656 <exit>
    printf("%s: cannot open sharedfd for writing", s);
    4456:	85d2                	mv	a1,s4
    4458:	00003517          	auipc	a0,0x3
    445c:	63050513          	addi	a0,a0,1584 # 7a88 <malloc+0x1fec>
    4460:	00001097          	auipc	ra,0x1
    4464:	57e080e7          	jalr	1406(ra) # 59de <printf>
    exit(1);
    4468:	4505                	li	a0,1
    446a:	00001097          	auipc	ra,0x1
    446e:	1ec080e7          	jalr	492(ra) # 5656 <exit>
      printf("%s: write sharedfd failed\n", s);
    4472:	85d2                	mv	a1,s4
    4474:	00003517          	auipc	a0,0x3
    4478:	63c50513          	addi	a0,a0,1596 # 7ab0 <malloc+0x2014>
    447c:	00001097          	auipc	ra,0x1
    4480:	562080e7          	jalr	1378(ra) # 59de <printf>
      exit(1);
    4484:	4505                	li	a0,1
    4486:	00001097          	auipc	ra,0x1
    448a:	1d0080e7          	jalr	464(ra) # 5656 <exit>
    wait(&xstatus);
    448e:	f9c40513          	addi	a0,s0,-100
    4492:	00001097          	auipc	ra,0x1
    4496:	1cc080e7          	jalr	460(ra) # 565e <wait>
    if(xstatus != 0)
    449a:	f9c42983          	lw	s3,-100(s0)
    449e:	00098763          	beqz	s3,44ac <sharedfd+0xe6>
      exit(xstatus);
    44a2:	854e                	mv	a0,s3
    44a4:	00001097          	auipc	ra,0x1
    44a8:	1b2080e7          	jalr	434(ra) # 5656 <exit>
  close(fd);
    44ac:	854a                	mv	a0,s2
    44ae:	00001097          	auipc	ra,0x1
    44b2:	1d0080e7          	jalr	464(ra) # 567e <close>
  fd = open("sharedfd", 0);
    44b6:	4581                	li	a1,0
    44b8:	00002517          	auipc	a0,0x2
    44bc:	86050513          	addi	a0,a0,-1952 # 5d18 <malloc+0x27c>
    44c0:	00001097          	auipc	ra,0x1
    44c4:	1d6080e7          	jalr	470(ra) # 5696 <open>
    44c8:	8baa                	mv	s7,a0
  nc = np = 0;
    44ca:	8ace                	mv	s5,s3
  if(fd < 0){
    44cc:	02054563          	bltz	a0,44f6 <sharedfd+0x130>
    44d0:	faa40913          	addi	s2,s0,-86
      if(buf[i] == 'c')
    44d4:	06300493          	li	s1,99
      if(buf[i] == 'p')
    44d8:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    44dc:	4629                	li	a2,10
    44de:	fa040593          	addi	a1,s0,-96
    44e2:	855e                	mv	a0,s7
    44e4:	00001097          	auipc	ra,0x1
    44e8:	18a080e7          	jalr	394(ra) # 566e <read>
    44ec:	02a05f63          	blez	a0,452a <sharedfd+0x164>
    44f0:	fa040793          	addi	a5,s0,-96
    44f4:	a01d                	j	451a <sharedfd+0x154>
    printf("%s: cannot open sharedfd for reading\n", s);
    44f6:	85d2                	mv	a1,s4
    44f8:	00003517          	auipc	a0,0x3
    44fc:	5d850513          	addi	a0,a0,1496 # 7ad0 <malloc+0x2034>
    4500:	00001097          	auipc	ra,0x1
    4504:	4de080e7          	jalr	1246(ra) # 59de <printf>
    exit(1);
    4508:	4505                	li	a0,1
    450a:	00001097          	auipc	ra,0x1
    450e:	14c080e7          	jalr	332(ra) # 5656 <exit>
        nc++;
    4512:	2985                	addiw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    4514:	0785                	addi	a5,a5,1
    4516:	fd2783e3          	beq	a5,s2,44dc <sharedfd+0x116>
      if(buf[i] == 'c')
    451a:	0007c703          	lbu	a4,0(a5) # 3e800000 <__BSS_END__+0x3e7f14b0>
    451e:	fe970ae3          	beq	a4,s1,4512 <sharedfd+0x14c>
      if(buf[i] == 'p')
    4522:	ff6719e3          	bne	a4,s6,4514 <sharedfd+0x14e>
        np++;
    4526:	2a85                	addiw	s5,s5,1
    4528:	b7f5                	j	4514 <sharedfd+0x14e>
  close(fd);
    452a:	855e                	mv	a0,s7
    452c:	00001097          	auipc	ra,0x1
    4530:	152080e7          	jalr	338(ra) # 567e <close>
  unlink("sharedfd");
    4534:	00001517          	auipc	a0,0x1
    4538:	7e450513          	addi	a0,a0,2020 # 5d18 <malloc+0x27c>
    453c:	00001097          	auipc	ra,0x1
    4540:	16a080e7          	jalr	362(ra) # 56a6 <unlink>
  if(nc == N*SZ && np == N*SZ){
    4544:	6789                	lui	a5,0x2
    4546:	71078793          	addi	a5,a5,1808 # 2710 <sbrkbasic+0x158>
    454a:	00f99763          	bne	s3,a5,4558 <sharedfd+0x192>
    454e:	6789                	lui	a5,0x2
    4550:	71078793          	addi	a5,a5,1808 # 2710 <sbrkbasic+0x158>
    4554:	02fa8063          	beq	s5,a5,4574 <sharedfd+0x1ae>
    printf("%s: nc/np test fails\n", s);
    4558:	85d2                	mv	a1,s4
    455a:	00003517          	auipc	a0,0x3
    455e:	59e50513          	addi	a0,a0,1438 # 7af8 <malloc+0x205c>
    4562:	00001097          	auipc	ra,0x1
    4566:	47c080e7          	jalr	1148(ra) # 59de <printf>
    exit(1);
    456a:	4505                	li	a0,1
    456c:	00001097          	auipc	ra,0x1
    4570:	0ea080e7          	jalr	234(ra) # 5656 <exit>
    exit(0);
    4574:	4501                	li	a0,0
    4576:	00001097          	auipc	ra,0x1
    457a:	0e0080e7          	jalr	224(ra) # 5656 <exit>

000000000000457e <fourfiles>:
{
    457e:	7171                	addi	sp,sp,-176
    4580:	f506                	sd	ra,168(sp)
    4582:	f122                	sd	s0,160(sp)
    4584:	ed26                	sd	s1,152(sp)
    4586:	e94a                	sd	s2,144(sp)
    4588:	e54e                	sd	s3,136(sp)
    458a:	e152                	sd	s4,128(sp)
    458c:	fcd6                	sd	s5,120(sp)
    458e:	f8da                	sd	s6,112(sp)
    4590:	f4de                	sd	s7,104(sp)
    4592:	f0e2                	sd	s8,96(sp)
    4594:	ece6                	sd	s9,88(sp)
    4596:	e8ea                	sd	s10,80(sp)
    4598:	e4ee                	sd	s11,72(sp)
    459a:	1900                	addi	s0,sp,176
    459c:	8caa                	mv	s9,a0
  char *names[] = { "f0", "f1", "f2", "f3" };
    459e:	00001797          	auipc	a5,0x1
    45a2:	5e278793          	addi	a5,a5,1506 # 5b80 <malloc+0xe4>
    45a6:	f6f43823          	sd	a5,-144(s0)
    45aa:	00001797          	auipc	a5,0x1
    45ae:	5de78793          	addi	a5,a5,1502 # 5b88 <malloc+0xec>
    45b2:	f6f43c23          	sd	a5,-136(s0)
    45b6:	00001797          	auipc	a5,0x1
    45ba:	5da78793          	addi	a5,a5,1498 # 5b90 <malloc+0xf4>
    45be:	f8f43023          	sd	a5,-128(s0)
    45c2:	00001797          	auipc	a5,0x1
    45c6:	5d678793          	addi	a5,a5,1494 # 5b98 <malloc+0xfc>
    45ca:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    45ce:	f7040b93          	addi	s7,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    45d2:	895e                	mv	s2,s7
  for(pi = 0; pi < NCHILD; pi++){
    45d4:	4481                	li	s1,0
    45d6:	4a11                	li	s4,4
    fname = names[pi];
    45d8:	00093983          	ld	s3,0(s2)
    unlink(fname);
    45dc:	854e                	mv	a0,s3
    45de:	00001097          	auipc	ra,0x1
    45e2:	0c8080e7          	jalr	200(ra) # 56a6 <unlink>
    pid = fork();
    45e6:	00001097          	auipc	ra,0x1
    45ea:	068080e7          	jalr	104(ra) # 564e <fork>
    if(pid < 0){
    45ee:	04054563          	bltz	a0,4638 <fourfiles+0xba>
    if(pid == 0){
    45f2:	c12d                	beqz	a0,4654 <fourfiles+0xd6>
  for(pi = 0; pi < NCHILD; pi++){
    45f4:	2485                	addiw	s1,s1,1
    45f6:	0921                	addi	s2,s2,8
    45f8:	ff4490e3          	bne	s1,s4,45d8 <fourfiles+0x5a>
    45fc:	4491                	li	s1,4
    wait(&xstatus);
    45fe:	f6c40513          	addi	a0,s0,-148
    4602:	00001097          	auipc	ra,0x1
    4606:	05c080e7          	jalr	92(ra) # 565e <wait>
    if(xstatus != 0)
    460a:	f6c42503          	lw	a0,-148(s0)
    460e:	ed69                	bnez	a0,46e8 <fourfiles+0x16a>
  for(pi = 0; pi < NCHILD; pi++){
    4610:	34fd                	addiw	s1,s1,-1
    4612:	f4f5                	bnez	s1,45fe <fourfiles+0x80>
    4614:	03000b13          	li	s6,48
    total = 0;
    4618:	f4a43c23          	sd	a0,-168(s0)
    while((n = read(fd, buf, sizeof(buf))) > 0){
    461c:	00007a17          	auipc	s4,0x7
    4620:	524a0a13          	addi	s4,s4,1316 # bb40 <buf>
    4624:	00007a97          	auipc	s5,0x7
    4628:	51da8a93          	addi	s5,s5,1309 # bb41 <buf+0x1>
    if(total != N*SZ){
    462c:	6d05                	lui	s10,0x1
    462e:	770d0d13          	addi	s10,s10,1904 # 1770 <pipe1+0x32>
  for(i = 0; i < NCHILD; i++){
    4632:	03400d93          	li	s11,52
    4636:	a23d                	j	4764 <fourfiles+0x1e6>
      printf("fork failed\n", s);
    4638:	85e6                	mv	a1,s9
    463a:	00002517          	auipc	a0,0x2
    463e:	4de50513          	addi	a0,a0,1246 # 6b18 <malloc+0x107c>
    4642:	00001097          	auipc	ra,0x1
    4646:	39c080e7          	jalr	924(ra) # 59de <printf>
      exit(1);
    464a:	4505                	li	a0,1
    464c:	00001097          	auipc	ra,0x1
    4650:	00a080e7          	jalr	10(ra) # 5656 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    4654:	20200593          	li	a1,514
    4658:	854e                	mv	a0,s3
    465a:	00001097          	auipc	ra,0x1
    465e:	03c080e7          	jalr	60(ra) # 5696 <open>
    4662:	892a                	mv	s2,a0
      if(fd < 0){
    4664:	04054763          	bltz	a0,46b2 <fourfiles+0x134>
      memset(buf, '0'+pi, SZ);
    4668:	1f400613          	li	a2,500
    466c:	0304859b          	addiw	a1,s1,48
    4670:	00007517          	auipc	a0,0x7
    4674:	4d050513          	addi	a0,a0,1232 # bb40 <buf>
    4678:	00001097          	auipc	ra,0x1
    467c:	dda080e7          	jalr	-550(ra) # 5452 <memset>
    4680:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    4682:	00007997          	auipc	s3,0x7
    4686:	4be98993          	addi	s3,s3,1214 # bb40 <buf>
    468a:	1f400613          	li	a2,500
    468e:	85ce                	mv	a1,s3
    4690:	854a                	mv	a0,s2
    4692:	00001097          	auipc	ra,0x1
    4696:	fe4080e7          	jalr	-28(ra) # 5676 <write>
    469a:	85aa                	mv	a1,a0
    469c:	1f400793          	li	a5,500
    46a0:	02f51763          	bne	a0,a5,46ce <fourfiles+0x150>
      for(i = 0; i < N; i++){
    46a4:	34fd                	addiw	s1,s1,-1
    46a6:	f0f5                	bnez	s1,468a <fourfiles+0x10c>
      exit(0);
    46a8:	4501                	li	a0,0
    46aa:	00001097          	auipc	ra,0x1
    46ae:	fac080e7          	jalr	-84(ra) # 5656 <exit>
        printf("create failed\n", s);
    46b2:	85e6                	mv	a1,s9
    46b4:	00003517          	auipc	a0,0x3
    46b8:	45c50513          	addi	a0,a0,1116 # 7b10 <malloc+0x2074>
    46bc:	00001097          	auipc	ra,0x1
    46c0:	322080e7          	jalr	802(ra) # 59de <printf>
        exit(1);
    46c4:	4505                	li	a0,1
    46c6:	00001097          	auipc	ra,0x1
    46ca:	f90080e7          	jalr	-112(ra) # 5656 <exit>
          printf("write failed %d\n", n);
    46ce:	00003517          	auipc	a0,0x3
    46d2:	45250513          	addi	a0,a0,1106 # 7b20 <malloc+0x2084>
    46d6:	00001097          	auipc	ra,0x1
    46da:	308080e7          	jalr	776(ra) # 59de <printf>
          exit(1);
    46de:	4505                	li	a0,1
    46e0:	00001097          	auipc	ra,0x1
    46e4:	f76080e7          	jalr	-138(ra) # 5656 <exit>
      exit(xstatus);
    46e8:	00001097          	auipc	ra,0x1
    46ec:	f6e080e7          	jalr	-146(ra) # 5656 <exit>
          printf("wrong char\n", s);
    46f0:	85e6                	mv	a1,s9
    46f2:	00003517          	auipc	a0,0x3
    46f6:	44650513          	addi	a0,a0,1094 # 7b38 <malloc+0x209c>
    46fa:	00001097          	auipc	ra,0x1
    46fe:	2e4080e7          	jalr	740(ra) # 59de <printf>
          exit(1);
    4702:	4505                	li	a0,1
    4704:	00001097          	auipc	ra,0x1
    4708:	f52080e7          	jalr	-174(ra) # 5656 <exit>
      total += n;
    470c:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4710:	660d                	lui	a2,0x3
    4712:	85d2                	mv	a1,s4
    4714:	854e                	mv	a0,s3
    4716:	00001097          	auipc	ra,0x1
    471a:	f58080e7          	jalr	-168(ra) # 566e <read>
    471e:	02a05363          	blez	a0,4744 <fourfiles+0x1c6>
    4722:	00007797          	auipc	a5,0x7
    4726:	41e78793          	addi	a5,a5,1054 # bb40 <buf>
    472a:	fff5069b          	addiw	a3,a0,-1
    472e:	1682                	slli	a3,a3,0x20
    4730:	9281                	srli	a3,a3,0x20
    4732:	96d6                	add	a3,a3,s5
        if(buf[j] != '0'+i){
    4734:	0007c703          	lbu	a4,0(a5)
    4738:	fa971ce3          	bne	a4,s1,46f0 <fourfiles+0x172>
      for(j = 0; j < n; j++){
    473c:	0785                	addi	a5,a5,1
    473e:	fed79be3          	bne	a5,a3,4734 <fourfiles+0x1b6>
    4742:	b7e9                	j	470c <fourfiles+0x18e>
    close(fd);
    4744:	854e                	mv	a0,s3
    4746:	00001097          	auipc	ra,0x1
    474a:	f38080e7          	jalr	-200(ra) # 567e <close>
    if(total != N*SZ){
    474e:	03a91963          	bne	s2,s10,4780 <fourfiles+0x202>
    unlink(fname);
    4752:	8562                	mv	a0,s8
    4754:	00001097          	auipc	ra,0x1
    4758:	f52080e7          	jalr	-174(ra) # 56a6 <unlink>
  for(i = 0; i < NCHILD; i++){
    475c:	0ba1                	addi	s7,s7,8
    475e:	2b05                	addiw	s6,s6,1
    4760:	03bb0e63          	beq	s6,s11,479c <fourfiles+0x21e>
    fname = names[i];
    4764:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
    4768:	4581                	li	a1,0
    476a:	8562                	mv	a0,s8
    476c:	00001097          	auipc	ra,0x1
    4770:	f2a080e7          	jalr	-214(ra) # 5696 <open>
    4774:	89aa                	mv	s3,a0
    total = 0;
    4776:	f5843903          	ld	s2,-168(s0)
        if(buf[j] != '0'+i){
    477a:	000b049b          	sext.w	s1,s6
    while((n = read(fd, buf, sizeof(buf))) > 0){
    477e:	bf49                	j	4710 <fourfiles+0x192>
      printf("wrong length %d\n", total);
    4780:	85ca                	mv	a1,s2
    4782:	00003517          	auipc	a0,0x3
    4786:	3c650513          	addi	a0,a0,966 # 7b48 <malloc+0x20ac>
    478a:	00001097          	auipc	ra,0x1
    478e:	254080e7          	jalr	596(ra) # 59de <printf>
      exit(1);
    4792:	4505                	li	a0,1
    4794:	00001097          	auipc	ra,0x1
    4798:	ec2080e7          	jalr	-318(ra) # 5656 <exit>
}
    479c:	70aa                	ld	ra,168(sp)
    479e:	740a                	ld	s0,160(sp)
    47a0:	64ea                	ld	s1,152(sp)
    47a2:	694a                	ld	s2,144(sp)
    47a4:	69aa                	ld	s3,136(sp)
    47a6:	6a0a                	ld	s4,128(sp)
    47a8:	7ae6                	ld	s5,120(sp)
    47aa:	7b46                	ld	s6,112(sp)
    47ac:	7ba6                	ld	s7,104(sp)
    47ae:	7c06                	ld	s8,96(sp)
    47b0:	6ce6                	ld	s9,88(sp)
    47b2:	6d46                	ld	s10,80(sp)
    47b4:	6da6                	ld	s11,72(sp)
    47b6:	614d                	addi	sp,sp,176
    47b8:	8082                	ret

00000000000047ba <concreate>:
{
    47ba:	7135                	addi	sp,sp,-160
    47bc:	ed06                	sd	ra,152(sp)
    47be:	e922                	sd	s0,144(sp)
    47c0:	e526                	sd	s1,136(sp)
    47c2:	e14a                	sd	s2,128(sp)
    47c4:	fcce                	sd	s3,120(sp)
    47c6:	f8d2                	sd	s4,112(sp)
    47c8:	f4d6                	sd	s5,104(sp)
    47ca:	f0da                	sd	s6,96(sp)
    47cc:	ecde                	sd	s7,88(sp)
    47ce:	1100                	addi	s0,sp,160
    47d0:	89aa                	mv	s3,a0
  file[0] = 'C';
    47d2:	04300793          	li	a5,67
    47d6:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    47da:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    47de:	4901                	li	s2,0
    if(pid && (i % 3) == 1){
    47e0:	4b0d                	li	s6,3
    47e2:	4a85                	li	s5,1
      link("C0", file);
    47e4:	00003b97          	auipc	s7,0x3
    47e8:	37cb8b93          	addi	s7,s7,892 # 7b60 <malloc+0x20c4>
  for(i = 0; i < N; i++){
    47ec:	02800a13          	li	s4,40
    47f0:	acc1                	j	4ac0 <concreate+0x306>
      link("C0", file);
    47f2:	fa840593          	addi	a1,s0,-88
    47f6:	855e                	mv	a0,s7
    47f8:	00001097          	auipc	ra,0x1
    47fc:	ebe080e7          	jalr	-322(ra) # 56b6 <link>
    if(pid == 0) {
    4800:	a45d                	j	4aa6 <concreate+0x2ec>
    } else if(pid == 0 && (i % 5) == 1){
    4802:	4795                	li	a5,5
    4804:	02f9693b          	remw	s2,s2,a5
    4808:	4785                	li	a5,1
    480a:	02f90b63          	beq	s2,a5,4840 <concreate+0x86>
      fd = open(file, O_CREATE | O_RDWR);
    480e:	20200593          	li	a1,514
    4812:	fa840513          	addi	a0,s0,-88
    4816:	00001097          	auipc	ra,0x1
    481a:	e80080e7          	jalr	-384(ra) # 5696 <open>
      if(fd < 0){
    481e:	26055b63          	bgez	a0,4a94 <concreate+0x2da>
        printf("concreate create %s failed\n", file);
    4822:	fa840593          	addi	a1,s0,-88
    4826:	00003517          	auipc	a0,0x3
    482a:	34250513          	addi	a0,a0,834 # 7b68 <malloc+0x20cc>
    482e:	00001097          	auipc	ra,0x1
    4832:	1b0080e7          	jalr	432(ra) # 59de <printf>
        exit(1);
    4836:	4505                	li	a0,1
    4838:	00001097          	auipc	ra,0x1
    483c:	e1e080e7          	jalr	-482(ra) # 5656 <exit>
      link("C0", file);
    4840:	fa840593          	addi	a1,s0,-88
    4844:	00003517          	auipc	a0,0x3
    4848:	31c50513          	addi	a0,a0,796 # 7b60 <malloc+0x20c4>
    484c:	00001097          	auipc	ra,0x1
    4850:	e6a080e7          	jalr	-406(ra) # 56b6 <link>
      exit(0);
    4854:	4501                	li	a0,0
    4856:	00001097          	auipc	ra,0x1
    485a:	e00080e7          	jalr	-512(ra) # 5656 <exit>
        exit(1);
    485e:	4505                	li	a0,1
    4860:	00001097          	auipc	ra,0x1
    4864:	df6080e7          	jalr	-522(ra) # 5656 <exit>
  memset(fa, 0, sizeof(fa));
    4868:	02800613          	li	a2,40
    486c:	4581                	li	a1,0
    486e:	f8040513          	addi	a0,s0,-128
    4872:	00001097          	auipc	ra,0x1
    4876:	be0080e7          	jalr	-1056(ra) # 5452 <memset>
  fd = open(".", 0);
    487a:	4581                	li	a1,0
    487c:	00002517          	auipc	a0,0x2
    4880:	cf450513          	addi	a0,a0,-780 # 6570 <malloc+0xad4>
    4884:	00001097          	auipc	ra,0x1
    4888:	e12080e7          	jalr	-494(ra) # 5696 <open>
    488c:	892a                	mv	s2,a0
  n = 0;
    488e:	8aa6                	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4890:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    4894:	02700b13          	li	s6,39
      fa[i] = 1;
    4898:	4b85                	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    489a:	a03d                	j	48c8 <concreate+0x10e>
        printf("%s: concreate weird file %s\n", s, de.name);
    489c:	f7240613          	addi	a2,s0,-142
    48a0:	85ce                	mv	a1,s3
    48a2:	00003517          	auipc	a0,0x3
    48a6:	2e650513          	addi	a0,a0,742 # 7b88 <malloc+0x20ec>
    48aa:	00001097          	auipc	ra,0x1
    48ae:	134080e7          	jalr	308(ra) # 59de <printf>
        exit(1);
    48b2:	4505                	li	a0,1
    48b4:	00001097          	auipc	ra,0x1
    48b8:	da2080e7          	jalr	-606(ra) # 5656 <exit>
      fa[i] = 1;
    48bc:	fb040793          	addi	a5,s0,-80
    48c0:	973e                	add	a4,a4,a5
    48c2:	fd770823          	sb	s7,-48(a4)
      n++;
    48c6:	2a85                	addiw	s5,s5,1
  while(read(fd, &de, sizeof(de)) > 0){
    48c8:	4641                	li	a2,16
    48ca:	f7040593          	addi	a1,s0,-144
    48ce:	854a                	mv	a0,s2
    48d0:	00001097          	auipc	ra,0x1
    48d4:	d9e080e7          	jalr	-610(ra) # 566e <read>
    48d8:	04a05a63          	blez	a0,492c <concreate+0x172>
    if(de.inum == 0)
    48dc:	f7045783          	lhu	a5,-144(s0)
    48e0:	d7e5                	beqz	a5,48c8 <concreate+0x10e>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    48e2:	f7244783          	lbu	a5,-142(s0)
    48e6:	ff4791e3          	bne	a5,s4,48c8 <concreate+0x10e>
    48ea:	f7444783          	lbu	a5,-140(s0)
    48ee:	ffe9                	bnez	a5,48c8 <concreate+0x10e>
      i = de.name[1] - '0';
    48f0:	f7344783          	lbu	a5,-141(s0)
    48f4:	fd07879b          	addiw	a5,a5,-48
    48f8:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    48fc:	faeb60e3          	bltu	s6,a4,489c <concreate+0xe2>
      if(fa[i]){
    4900:	fb040793          	addi	a5,s0,-80
    4904:	97ba                	add	a5,a5,a4
    4906:	fd07c783          	lbu	a5,-48(a5)
    490a:	dbcd                	beqz	a5,48bc <concreate+0x102>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    490c:	f7240613          	addi	a2,s0,-142
    4910:	85ce                	mv	a1,s3
    4912:	00003517          	auipc	a0,0x3
    4916:	29650513          	addi	a0,a0,662 # 7ba8 <malloc+0x210c>
    491a:	00001097          	auipc	ra,0x1
    491e:	0c4080e7          	jalr	196(ra) # 59de <printf>
        exit(1);
    4922:	4505                	li	a0,1
    4924:	00001097          	auipc	ra,0x1
    4928:	d32080e7          	jalr	-718(ra) # 5656 <exit>
  close(fd);
    492c:	854a                	mv	a0,s2
    492e:	00001097          	auipc	ra,0x1
    4932:	d50080e7          	jalr	-688(ra) # 567e <close>
  if(n != N){
    4936:	02800793          	li	a5,40
    493a:	00fa9763          	bne	s5,a5,4948 <concreate+0x18e>
    if(((i % 3) == 0 && pid == 0) ||
    493e:	4a8d                	li	s5,3
    4940:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    4942:	02800a13          	li	s4,40
    4946:	a8c9                	j	4a18 <concreate+0x25e>
    printf("%s: concreate not enough files in directory listing\n", s);
    4948:	85ce                	mv	a1,s3
    494a:	00003517          	auipc	a0,0x3
    494e:	28650513          	addi	a0,a0,646 # 7bd0 <malloc+0x2134>
    4952:	00001097          	auipc	ra,0x1
    4956:	08c080e7          	jalr	140(ra) # 59de <printf>
    exit(1);
    495a:	4505                	li	a0,1
    495c:	00001097          	auipc	ra,0x1
    4960:	cfa080e7          	jalr	-774(ra) # 5656 <exit>
      printf("%s: fork failed\n", s);
    4964:	85ce                	mv	a1,s3
    4966:	00002517          	auipc	a0,0x2
    496a:	daa50513          	addi	a0,a0,-598 # 6710 <malloc+0xc74>
    496e:	00001097          	auipc	ra,0x1
    4972:	070080e7          	jalr	112(ra) # 59de <printf>
      exit(1);
    4976:	4505                	li	a0,1
    4978:	00001097          	auipc	ra,0x1
    497c:	cde080e7          	jalr	-802(ra) # 5656 <exit>
      close(open(file, 0));
    4980:	4581                	li	a1,0
    4982:	fa840513          	addi	a0,s0,-88
    4986:	00001097          	auipc	ra,0x1
    498a:	d10080e7          	jalr	-752(ra) # 5696 <open>
    498e:	00001097          	auipc	ra,0x1
    4992:	cf0080e7          	jalr	-784(ra) # 567e <close>
      close(open(file, 0));
    4996:	4581                	li	a1,0
    4998:	fa840513          	addi	a0,s0,-88
    499c:	00001097          	auipc	ra,0x1
    49a0:	cfa080e7          	jalr	-774(ra) # 5696 <open>
    49a4:	00001097          	auipc	ra,0x1
    49a8:	cda080e7          	jalr	-806(ra) # 567e <close>
      close(open(file, 0));
    49ac:	4581                	li	a1,0
    49ae:	fa840513          	addi	a0,s0,-88
    49b2:	00001097          	auipc	ra,0x1
    49b6:	ce4080e7          	jalr	-796(ra) # 5696 <open>
    49ba:	00001097          	auipc	ra,0x1
    49be:	cc4080e7          	jalr	-828(ra) # 567e <close>
      close(open(file, 0));
    49c2:	4581                	li	a1,0
    49c4:	fa840513          	addi	a0,s0,-88
    49c8:	00001097          	auipc	ra,0x1
    49cc:	cce080e7          	jalr	-818(ra) # 5696 <open>
    49d0:	00001097          	auipc	ra,0x1
    49d4:	cae080e7          	jalr	-850(ra) # 567e <close>
      close(open(file, 0));
    49d8:	4581                	li	a1,0
    49da:	fa840513          	addi	a0,s0,-88
    49de:	00001097          	auipc	ra,0x1
    49e2:	cb8080e7          	jalr	-840(ra) # 5696 <open>
    49e6:	00001097          	auipc	ra,0x1
    49ea:	c98080e7          	jalr	-872(ra) # 567e <close>
      close(open(file, 0));
    49ee:	4581                	li	a1,0
    49f0:	fa840513          	addi	a0,s0,-88
    49f4:	00001097          	auipc	ra,0x1
    49f8:	ca2080e7          	jalr	-862(ra) # 5696 <open>
    49fc:	00001097          	auipc	ra,0x1
    4a00:	c82080e7          	jalr	-894(ra) # 567e <close>
    if(pid == 0)
    4a04:	08090363          	beqz	s2,4a8a <concreate+0x2d0>
      wait(0);
    4a08:	4501                	li	a0,0
    4a0a:	00001097          	auipc	ra,0x1
    4a0e:	c54080e7          	jalr	-940(ra) # 565e <wait>
  for(i = 0; i < N; i++){
    4a12:	2485                	addiw	s1,s1,1
    4a14:	0f448563          	beq	s1,s4,4afe <concreate+0x344>
    file[1] = '0' + i;
    4a18:	0304879b          	addiw	a5,s1,48
    4a1c:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    4a20:	00001097          	auipc	ra,0x1
    4a24:	c2e080e7          	jalr	-978(ra) # 564e <fork>
    4a28:	892a                	mv	s2,a0
    if(pid < 0){
    4a2a:	f2054de3          	bltz	a0,4964 <concreate+0x1aa>
    if(((i % 3) == 0 && pid == 0) ||
    4a2e:	0354e73b          	remw	a4,s1,s5
    4a32:	00a767b3          	or	a5,a4,a0
    4a36:	2781                	sext.w	a5,a5
    4a38:	d7a1                	beqz	a5,4980 <concreate+0x1c6>
    4a3a:	01671363          	bne	a4,s6,4a40 <concreate+0x286>
       ((i % 3) == 1 && pid != 0)){
    4a3e:	f129                	bnez	a0,4980 <concreate+0x1c6>
      unlink(file);
    4a40:	fa840513          	addi	a0,s0,-88
    4a44:	00001097          	auipc	ra,0x1
    4a48:	c62080e7          	jalr	-926(ra) # 56a6 <unlink>
      unlink(file);
    4a4c:	fa840513          	addi	a0,s0,-88
    4a50:	00001097          	auipc	ra,0x1
    4a54:	c56080e7          	jalr	-938(ra) # 56a6 <unlink>
      unlink(file);
    4a58:	fa840513          	addi	a0,s0,-88
    4a5c:	00001097          	auipc	ra,0x1
    4a60:	c4a080e7          	jalr	-950(ra) # 56a6 <unlink>
      unlink(file);
    4a64:	fa840513          	addi	a0,s0,-88
    4a68:	00001097          	auipc	ra,0x1
    4a6c:	c3e080e7          	jalr	-962(ra) # 56a6 <unlink>
      unlink(file);
    4a70:	fa840513          	addi	a0,s0,-88
    4a74:	00001097          	auipc	ra,0x1
    4a78:	c32080e7          	jalr	-974(ra) # 56a6 <unlink>
      unlink(file);
    4a7c:	fa840513          	addi	a0,s0,-88
    4a80:	00001097          	auipc	ra,0x1
    4a84:	c26080e7          	jalr	-986(ra) # 56a6 <unlink>
    4a88:	bfb5                	j	4a04 <concreate+0x24a>
      exit(0);
    4a8a:	4501                	li	a0,0
    4a8c:	00001097          	auipc	ra,0x1
    4a90:	bca080e7          	jalr	-1078(ra) # 5656 <exit>
      close(fd);
    4a94:	00001097          	auipc	ra,0x1
    4a98:	bea080e7          	jalr	-1046(ra) # 567e <close>
    if(pid == 0) {
    4a9c:	bb65                	j	4854 <concreate+0x9a>
      close(fd);
    4a9e:	00001097          	auipc	ra,0x1
    4aa2:	be0080e7          	jalr	-1056(ra) # 567e <close>
      wait(&xstatus);
    4aa6:	f6c40513          	addi	a0,s0,-148
    4aaa:	00001097          	auipc	ra,0x1
    4aae:	bb4080e7          	jalr	-1100(ra) # 565e <wait>
      if(xstatus != 0)
    4ab2:	f6c42483          	lw	s1,-148(s0)
    4ab6:	da0494e3          	bnez	s1,485e <concreate+0xa4>
  for(i = 0; i < N; i++){
    4aba:	2905                	addiw	s2,s2,1
    4abc:	db4906e3          	beq	s2,s4,4868 <concreate+0xae>
    file[1] = '0' + i;
    4ac0:	0309079b          	addiw	a5,s2,48
    4ac4:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    4ac8:	fa840513          	addi	a0,s0,-88
    4acc:	00001097          	auipc	ra,0x1
    4ad0:	bda080e7          	jalr	-1062(ra) # 56a6 <unlink>
    pid = fork();
    4ad4:	00001097          	auipc	ra,0x1
    4ad8:	b7a080e7          	jalr	-1158(ra) # 564e <fork>
    if(pid && (i % 3) == 1){
    4adc:	d20503e3          	beqz	a0,4802 <concreate+0x48>
    4ae0:	036967bb          	remw	a5,s2,s6
    4ae4:	d15787e3          	beq	a5,s5,47f2 <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    4ae8:	20200593          	li	a1,514
    4aec:	fa840513          	addi	a0,s0,-88
    4af0:	00001097          	auipc	ra,0x1
    4af4:	ba6080e7          	jalr	-1114(ra) # 5696 <open>
      if(fd < 0){
    4af8:	fa0553e3          	bgez	a0,4a9e <concreate+0x2e4>
    4afc:	b31d                	j	4822 <concreate+0x68>
}
    4afe:	60ea                	ld	ra,152(sp)
    4b00:	644a                	ld	s0,144(sp)
    4b02:	64aa                	ld	s1,136(sp)
    4b04:	690a                	ld	s2,128(sp)
    4b06:	79e6                	ld	s3,120(sp)
    4b08:	7a46                	ld	s4,112(sp)
    4b0a:	7aa6                	ld	s5,104(sp)
    4b0c:	7b06                	ld	s6,96(sp)
    4b0e:	6be6                	ld	s7,88(sp)
    4b10:	610d                	addi	sp,sp,160
    4b12:	8082                	ret

0000000000004b14 <bigfile>:
{
    4b14:	7139                	addi	sp,sp,-64
    4b16:	fc06                	sd	ra,56(sp)
    4b18:	f822                	sd	s0,48(sp)
    4b1a:	f426                	sd	s1,40(sp)
    4b1c:	f04a                	sd	s2,32(sp)
    4b1e:	ec4e                	sd	s3,24(sp)
    4b20:	e852                	sd	s4,16(sp)
    4b22:	e456                	sd	s5,8(sp)
    4b24:	0080                	addi	s0,sp,64
    4b26:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    4b28:	00003517          	auipc	a0,0x3
    4b2c:	0e050513          	addi	a0,a0,224 # 7c08 <malloc+0x216c>
    4b30:	00001097          	auipc	ra,0x1
    4b34:	b76080e7          	jalr	-1162(ra) # 56a6 <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    4b38:	20200593          	li	a1,514
    4b3c:	00003517          	auipc	a0,0x3
    4b40:	0cc50513          	addi	a0,a0,204 # 7c08 <malloc+0x216c>
    4b44:	00001097          	auipc	ra,0x1
    4b48:	b52080e7          	jalr	-1198(ra) # 5696 <open>
    4b4c:	89aa                	mv	s3,a0
  for(i = 0; i < N; i++){
    4b4e:	4481                	li	s1,0
    memset(buf, i, SZ);
    4b50:	00007917          	auipc	s2,0x7
    4b54:	ff090913          	addi	s2,s2,-16 # bb40 <buf>
  for(i = 0; i < N; i++){
    4b58:	4a51                	li	s4,20
  if(fd < 0){
    4b5a:	0a054063          	bltz	a0,4bfa <bigfile+0xe6>
    memset(buf, i, SZ);
    4b5e:	25800613          	li	a2,600
    4b62:	85a6                	mv	a1,s1
    4b64:	854a                	mv	a0,s2
    4b66:	00001097          	auipc	ra,0x1
    4b6a:	8ec080e7          	jalr	-1812(ra) # 5452 <memset>
    if(write(fd, buf, SZ) != SZ){
    4b6e:	25800613          	li	a2,600
    4b72:	85ca                	mv	a1,s2
    4b74:	854e                	mv	a0,s3
    4b76:	00001097          	auipc	ra,0x1
    4b7a:	b00080e7          	jalr	-1280(ra) # 5676 <write>
    4b7e:	25800793          	li	a5,600
    4b82:	08f51a63          	bne	a0,a5,4c16 <bigfile+0x102>
  for(i = 0; i < N; i++){
    4b86:	2485                	addiw	s1,s1,1
    4b88:	fd449be3          	bne	s1,s4,4b5e <bigfile+0x4a>
  close(fd);
    4b8c:	854e                	mv	a0,s3
    4b8e:	00001097          	auipc	ra,0x1
    4b92:	af0080e7          	jalr	-1296(ra) # 567e <close>
  fd = open("bigfile.dat", 0);
    4b96:	4581                	li	a1,0
    4b98:	00003517          	auipc	a0,0x3
    4b9c:	07050513          	addi	a0,a0,112 # 7c08 <malloc+0x216c>
    4ba0:	00001097          	auipc	ra,0x1
    4ba4:	af6080e7          	jalr	-1290(ra) # 5696 <open>
    4ba8:	8a2a                	mv	s4,a0
  total = 0;
    4baa:	4981                	li	s3,0
  for(i = 0; ; i++){
    4bac:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    4bae:	00007917          	auipc	s2,0x7
    4bb2:	f9290913          	addi	s2,s2,-110 # bb40 <buf>
  if(fd < 0){
    4bb6:	06054e63          	bltz	a0,4c32 <bigfile+0x11e>
    cc = read(fd, buf, SZ/2);
    4bba:	12c00613          	li	a2,300
    4bbe:	85ca                	mv	a1,s2
    4bc0:	8552                	mv	a0,s4
    4bc2:	00001097          	auipc	ra,0x1
    4bc6:	aac080e7          	jalr	-1364(ra) # 566e <read>
    if(cc < 0){
    4bca:	08054263          	bltz	a0,4c4e <bigfile+0x13a>
    if(cc == 0)
    4bce:	c971                	beqz	a0,4ca2 <bigfile+0x18e>
    if(cc != SZ/2){
    4bd0:	12c00793          	li	a5,300
    4bd4:	08f51b63          	bne	a0,a5,4c6a <bigfile+0x156>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    4bd8:	01f4d79b          	srliw	a5,s1,0x1f
    4bdc:	9fa5                	addw	a5,a5,s1
    4bde:	4017d79b          	sraiw	a5,a5,0x1
    4be2:	00094703          	lbu	a4,0(s2)
    4be6:	0af71063          	bne	a4,a5,4c86 <bigfile+0x172>
    4bea:	12b94703          	lbu	a4,299(s2)
    4bee:	08f71c63          	bne	a4,a5,4c86 <bigfile+0x172>
    total += cc;
    4bf2:	12c9899b          	addiw	s3,s3,300
  for(i = 0; ; i++){
    4bf6:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    4bf8:	b7c9                	j	4bba <bigfile+0xa6>
    printf("%s: cannot create bigfile", s);
    4bfa:	85d6                	mv	a1,s5
    4bfc:	00003517          	auipc	a0,0x3
    4c00:	01c50513          	addi	a0,a0,28 # 7c18 <malloc+0x217c>
    4c04:	00001097          	auipc	ra,0x1
    4c08:	dda080e7          	jalr	-550(ra) # 59de <printf>
    exit(1);
    4c0c:	4505                	li	a0,1
    4c0e:	00001097          	auipc	ra,0x1
    4c12:	a48080e7          	jalr	-1464(ra) # 5656 <exit>
      printf("%s: write bigfile failed\n", s);
    4c16:	85d6                	mv	a1,s5
    4c18:	00003517          	auipc	a0,0x3
    4c1c:	02050513          	addi	a0,a0,32 # 7c38 <malloc+0x219c>
    4c20:	00001097          	auipc	ra,0x1
    4c24:	dbe080e7          	jalr	-578(ra) # 59de <printf>
      exit(1);
    4c28:	4505                	li	a0,1
    4c2a:	00001097          	auipc	ra,0x1
    4c2e:	a2c080e7          	jalr	-1492(ra) # 5656 <exit>
    printf("%s: cannot open bigfile\n", s);
    4c32:	85d6                	mv	a1,s5
    4c34:	00003517          	auipc	a0,0x3
    4c38:	02450513          	addi	a0,a0,36 # 7c58 <malloc+0x21bc>
    4c3c:	00001097          	auipc	ra,0x1
    4c40:	da2080e7          	jalr	-606(ra) # 59de <printf>
    exit(1);
    4c44:	4505                	li	a0,1
    4c46:	00001097          	auipc	ra,0x1
    4c4a:	a10080e7          	jalr	-1520(ra) # 5656 <exit>
      printf("%s: read bigfile failed\n", s);
    4c4e:	85d6                	mv	a1,s5
    4c50:	00003517          	auipc	a0,0x3
    4c54:	02850513          	addi	a0,a0,40 # 7c78 <malloc+0x21dc>
    4c58:	00001097          	auipc	ra,0x1
    4c5c:	d86080e7          	jalr	-634(ra) # 59de <printf>
      exit(1);
    4c60:	4505                	li	a0,1
    4c62:	00001097          	auipc	ra,0x1
    4c66:	9f4080e7          	jalr	-1548(ra) # 5656 <exit>
      printf("%s: short read bigfile\n", s);
    4c6a:	85d6                	mv	a1,s5
    4c6c:	00003517          	auipc	a0,0x3
    4c70:	02c50513          	addi	a0,a0,44 # 7c98 <malloc+0x21fc>
    4c74:	00001097          	auipc	ra,0x1
    4c78:	d6a080e7          	jalr	-662(ra) # 59de <printf>
      exit(1);
    4c7c:	4505                	li	a0,1
    4c7e:	00001097          	auipc	ra,0x1
    4c82:	9d8080e7          	jalr	-1576(ra) # 5656 <exit>
      printf("%s: read bigfile wrong data\n", s);
    4c86:	85d6                	mv	a1,s5
    4c88:	00003517          	auipc	a0,0x3
    4c8c:	02850513          	addi	a0,a0,40 # 7cb0 <malloc+0x2214>
    4c90:	00001097          	auipc	ra,0x1
    4c94:	d4e080e7          	jalr	-690(ra) # 59de <printf>
      exit(1);
    4c98:	4505                	li	a0,1
    4c9a:	00001097          	auipc	ra,0x1
    4c9e:	9bc080e7          	jalr	-1604(ra) # 5656 <exit>
  close(fd);
    4ca2:	8552                	mv	a0,s4
    4ca4:	00001097          	auipc	ra,0x1
    4ca8:	9da080e7          	jalr	-1574(ra) # 567e <close>
  if(total != N*SZ){
    4cac:	678d                	lui	a5,0x3
    4cae:	ee078793          	addi	a5,a5,-288 # 2ee0 <exitiputtest+0x46>
    4cb2:	02f99363          	bne	s3,a5,4cd8 <bigfile+0x1c4>
  unlink("bigfile.dat");
    4cb6:	00003517          	auipc	a0,0x3
    4cba:	f5250513          	addi	a0,a0,-174 # 7c08 <malloc+0x216c>
    4cbe:	00001097          	auipc	ra,0x1
    4cc2:	9e8080e7          	jalr	-1560(ra) # 56a6 <unlink>
}
    4cc6:	70e2                	ld	ra,56(sp)
    4cc8:	7442                	ld	s0,48(sp)
    4cca:	74a2                	ld	s1,40(sp)
    4ccc:	7902                	ld	s2,32(sp)
    4cce:	69e2                	ld	s3,24(sp)
    4cd0:	6a42                	ld	s4,16(sp)
    4cd2:	6aa2                	ld	s5,8(sp)
    4cd4:	6121                	addi	sp,sp,64
    4cd6:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    4cd8:	85d6                	mv	a1,s5
    4cda:	00003517          	auipc	a0,0x3
    4cde:	ff650513          	addi	a0,a0,-10 # 7cd0 <malloc+0x2234>
    4ce2:	00001097          	auipc	ra,0x1
    4ce6:	cfc080e7          	jalr	-772(ra) # 59de <printf>
    exit(1);
    4cea:	4505                	li	a0,1
    4cec:	00001097          	auipc	ra,0x1
    4cf0:	96a080e7          	jalr	-1686(ra) # 5656 <exit>

0000000000004cf4 <fsfull>:
{
    4cf4:	7171                	addi	sp,sp,-176
    4cf6:	f506                	sd	ra,168(sp)
    4cf8:	f122                	sd	s0,160(sp)
    4cfa:	ed26                	sd	s1,152(sp)
    4cfc:	e94a                	sd	s2,144(sp)
    4cfe:	e54e                	sd	s3,136(sp)
    4d00:	e152                	sd	s4,128(sp)
    4d02:	fcd6                	sd	s5,120(sp)
    4d04:	f8da                	sd	s6,112(sp)
    4d06:	f4de                	sd	s7,104(sp)
    4d08:	f0e2                	sd	s8,96(sp)
    4d0a:	ece6                	sd	s9,88(sp)
    4d0c:	e8ea                	sd	s10,80(sp)
    4d0e:	e4ee                	sd	s11,72(sp)
    4d10:	1900                	addi	s0,sp,176
  printf("fsfull test\n");
    4d12:	00003517          	auipc	a0,0x3
    4d16:	fde50513          	addi	a0,a0,-34 # 7cf0 <malloc+0x2254>
    4d1a:	00001097          	auipc	ra,0x1
    4d1e:	cc4080e7          	jalr	-828(ra) # 59de <printf>
  for(nfiles = 0; ; nfiles++){
    4d22:	4481                	li	s1,0
    name[0] = 'f';
    4d24:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    4d28:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    4d2c:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    4d30:	4b29                	li	s6,10
    printf("writing %s\n", name);
    4d32:	00003c97          	auipc	s9,0x3
    4d36:	fcec8c93          	addi	s9,s9,-50 # 7d00 <malloc+0x2264>
    int total = 0;
    4d3a:	4d81                	li	s11,0
      int cc = write(fd, buf, BSIZE);
    4d3c:	00007a17          	auipc	s4,0x7
    4d40:	e04a0a13          	addi	s4,s4,-508 # bb40 <buf>
    name[0] = 'f';
    4d44:	f5a40823          	sb	s10,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4d48:	0384c7bb          	divw	a5,s1,s8
    4d4c:	0307879b          	addiw	a5,a5,48
    4d50:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4d54:	0384e7bb          	remw	a5,s1,s8
    4d58:	0377c7bb          	divw	a5,a5,s7
    4d5c:	0307879b          	addiw	a5,a5,48
    4d60:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4d64:	0374e7bb          	remw	a5,s1,s7
    4d68:	0367c7bb          	divw	a5,a5,s6
    4d6c:	0307879b          	addiw	a5,a5,48
    4d70:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    4d74:	0364e7bb          	remw	a5,s1,s6
    4d78:	0307879b          	addiw	a5,a5,48
    4d7c:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4d80:	f4040aa3          	sb	zero,-171(s0)
    printf("writing %s\n", name);
    4d84:	f5040593          	addi	a1,s0,-176
    4d88:	8566                	mv	a0,s9
    4d8a:	00001097          	auipc	ra,0x1
    4d8e:	c54080e7          	jalr	-940(ra) # 59de <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    4d92:	20200593          	li	a1,514
    4d96:	f5040513          	addi	a0,s0,-176
    4d9a:	00001097          	auipc	ra,0x1
    4d9e:	8fc080e7          	jalr	-1796(ra) # 5696 <open>
    4da2:	892a                	mv	s2,a0
    if(fd < 0){
    4da4:	0a055663          	bgez	a0,4e50 <fsfull+0x15c>
      printf("open %s failed\n", name);
    4da8:	f5040593          	addi	a1,s0,-176
    4dac:	00003517          	auipc	a0,0x3
    4db0:	f6450513          	addi	a0,a0,-156 # 7d10 <malloc+0x2274>
    4db4:	00001097          	auipc	ra,0x1
    4db8:	c2a080e7          	jalr	-982(ra) # 59de <printf>
  while(nfiles >= 0){
    4dbc:	0604c363          	bltz	s1,4e22 <fsfull+0x12e>
    name[0] = 'f';
    4dc0:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    4dc4:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    4dc8:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    4dcc:	4929                	li	s2,10
  while(nfiles >= 0){
    4dce:	5afd                	li	s5,-1
    name[0] = 'f';
    4dd0:	f5640823          	sb	s6,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4dd4:	0344c7bb          	divw	a5,s1,s4
    4dd8:	0307879b          	addiw	a5,a5,48
    4ddc:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4de0:	0344e7bb          	remw	a5,s1,s4
    4de4:	0337c7bb          	divw	a5,a5,s3
    4de8:	0307879b          	addiw	a5,a5,48
    4dec:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4df0:	0334e7bb          	remw	a5,s1,s3
    4df4:	0327c7bb          	divw	a5,a5,s2
    4df8:	0307879b          	addiw	a5,a5,48
    4dfc:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    4e00:	0324e7bb          	remw	a5,s1,s2
    4e04:	0307879b          	addiw	a5,a5,48
    4e08:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4e0c:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    4e10:	f5040513          	addi	a0,s0,-176
    4e14:	00001097          	auipc	ra,0x1
    4e18:	892080e7          	jalr	-1902(ra) # 56a6 <unlink>
    nfiles--;
    4e1c:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    4e1e:	fb5499e3          	bne	s1,s5,4dd0 <fsfull+0xdc>
  printf("fsfull test finished\n");
    4e22:	00003517          	auipc	a0,0x3
    4e26:	f0e50513          	addi	a0,a0,-242 # 7d30 <malloc+0x2294>
    4e2a:	00001097          	auipc	ra,0x1
    4e2e:	bb4080e7          	jalr	-1100(ra) # 59de <printf>
}
    4e32:	70aa                	ld	ra,168(sp)
    4e34:	740a                	ld	s0,160(sp)
    4e36:	64ea                	ld	s1,152(sp)
    4e38:	694a                	ld	s2,144(sp)
    4e3a:	69aa                	ld	s3,136(sp)
    4e3c:	6a0a                	ld	s4,128(sp)
    4e3e:	7ae6                	ld	s5,120(sp)
    4e40:	7b46                	ld	s6,112(sp)
    4e42:	7ba6                	ld	s7,104(sp)
    4e44:	7c06                	ld	s8,96(sp)
    4e46:	6ce6                	ld	s9,88(sp)
    4e48:	6d46                	ld	s10,80(sp)
    4e4a:	6da6                	ld	s11,72(sp)
    4e4c:	614d                	addi	sp,sp,176
    4e4e:	8082                	ret
    int total = 0;
    4e50:	89ee                	mv	s3,s11
      if(cc < BSIZE)
    4e52:	3ff00a93          	li	s5,1023
      int cc = write(fd, buf, BSIZE);
    4e56:	40000613          	li	a2,1024
    4e5a:	85d2                	mv	a1,s4
    4e5c:	854a                	mv	a0,s2
    4e5e:	00001097          	auipc	ra,0x1
    4e62:	818080e7          	jalr	-2024(ra) # 5676 <write>
      if(cc < BSIZE)
    4e66:	00aad563          	bge	s5,a0,4e70 <fsfull+0x17c>
      total += cc;
    4e6a:	00a989bb          	addw	s3,s3,a0
    while(1){
    4e6e:	b7e5                	j	4e56 <fsfull+0x162>
    printf("wrote %d bytes\n", total);
    4e70:	85ce                	mv	a1,s3
    4e72:	00003517          	auipc	a0,0x3
    4e76:	eae50513          	addi	a0,a0,-338 # 7d20 <malloc+0x2284>
    4e7a:	00001097          	auipc	ra,0x1
    4e7e:	b64080e7          	jalr	-1180(ra) # 59de <printf>
    close(fd);
    4e82:	854a                	mv	a0,s2
    4e84:	00000097          	auipc	ra,0x0
    4e88:	7fa080e7          	jalr	2042(ra) # 567e <close>
    if(total == 0)
    4e8c:	f20988e3          	beqz	s3,4dbc <fsfull+0xc8>
  for(nfiles = 0; ; nfiles++){
    4e90:	2485                	addiw	s1,s1,1
    4e92:	bd4d                	j	4d44 <fsfull+0x50>

0000000000004e94 <rand>:
{
    4e94:	1141                	addi	sp,sp,-16
    4e96:	e422                	sd	s0,8(sp)
    4e98:	0800                	addi	s0,sp,16
  randstate = randstate * 1664525 + 1013904223;
    4e9a:	00003717          	auipc	a4,0x3
    4e9e:	47e70713          	addi	a4,a4,1150 # 8318 <randstate>
    4ea2:	6308                	ld	a0,0(a4)
    4ea4:	001967b7          	lui	a5,0x196
    4ea8:	60d78793          	addi	a5,a5,1549 # 19660d <__BSS_END__+0x187abd>
    4eac:	02f50533          	mul	a0,a0,a5
    4eb0:	3c6ef7b7          	lui	a5,0x3c6ef
    4eb4:	35f78793          	addi	a5,a5,863 # 3c6ef35f <__BSS_END__+0x3c6e080f>
    4eb8:	953e                	add	a0,a0,a5
    4eba:	e308                	sd	a0,0(a4)
}
    4ebc:	2501                	sext.w	a0,a0
    4ebe:	6422                	ld	s0,8(sp)
    4ec0:	0141                	addi	sp,sp,16
    4ec2:	8082                	ret

0000000000004ec4 <badwrite>:
{
    4ec4:	7179                	addi	sp,sp,-48
    4ec6:	f406                	sd	ra,40(sp)
    4ec8:	f022                	sd	s0,32(sp)
    4eca:	ec26                	sd	s1,24(sp)
    4ecc:	e84a                	sd	s2,16(sp)
    4ece:	e44e                	sd	s3,8(sp)
    4ed0:	e052                	sd	s4,0(sp)
    4ed2:	1800                	addi	s0,sp,48
  unlink("junk");
    4ed4:	00003517          	auipc	a0,0x3
    4ed8:	e7450513          	addi	a0,a0,-396 # 7d48 <malloc+0x22ac>
    4edc:	00000097          	auipc	ra,0x0
    4ee0:	7ca080e7          	jalr	1994(ra) # 56a6 <unlink>
    4ee4:	25800913          	li	s2,600
    int fd = open("junk", O_CREATE|O_WRONLY);
    4ee8:	00003997          	auipc	s3,0x3
    4eec:	e6098993          	addi	s3,s3,-416 # 7d48 <malloc+0x22ac>
    write(fd, (char*)0xffffffffffL, 1);
    4ef0:	5a7d                	li	s4,-1
    4ef2:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
    4ef6:	20100593          	li	a1,513
    4efa:	854e                	mv	a0,s3
    4efc:	00000097          	auipc	ra,0x0
    4f00:	79a080e7          	jalr	1946(ra) # 5696 <open>
    4f04:	84aa                	mv	s1,a0
    if(fd < 0){
    4f06:	06054b63          	bltz	a0,4f7c <badwrite+0xb8>
    write(fd, (char*)0xffffffffffL, 1);
    4f0a:	4605                	li	a2,1
    4f0c:	85d2                	mv	a1,s4
    4f0e:	00000097          	auipc	ra,0x0
    4f12:	768080e7          	jalr	1896(ra) # 5676 <write>
    close(fd);
    4f16:	8526                	mv	a0,s1
    4f18:	00000097          	auipc	ra,0x0
    4f1c:	766080e7          	jalr	1894(ra) # 567e <close>
    unlink("junk");
    4f20:	854e                	mv	a0,s3
    4f22:	00000097          	auipc	ra,0x0
    4f26:	784080e7          	jalr	1924(ra) # 56a6 <unlink>
  for(int i = 0; i < assumed_free; i++){
    4f2a:	397d                	addiw	s2,s2,-1
    4f2c:	fc0915e3          	bnez	s2,4ef6 <badwrite+0x32>
  int fd = open("junk", O_CREATE|O_WRONLY);
    4f30:	20100593          	li	a1,513
    4f34:	00003517          	auipc	a0,0x3
    4f38:	e1450513          	addi	a0,a0,-492 # 7d48 <malloc+0x22ac>
    4f3c:	00000097          	auipc	ra,0x0
    4f40:	75a080e7          	jalr	1882(ra) # 5696 <open>
    4f44:	84aa                	mv	s1,a0
  if(fd < 0){
    4f46:	04054863          	bltz	a0,4f96 <badwrite+0xd2>
  if(write(fd, "x", 1) != 1){
    4f4a:	4605                	li	a2,1
    4f4c:	00001597          	auipc	a1,0x1
    4f50:	ffc58593          	addi	a1,a1,-4 # 5f48 <malloc+0x4ac>
    4f54:	00000097          	auipc	ra,0x0
    4f58:	722080e7          	jalr	1826(ra) # 5676 <write>
    4f5c:	4785                	li	a5,1
    4f5e:	04f50963          	beq	a0,a5,4fb0 <badwrite+0xec>
    printf("write failed\n");
    4f62:	00003517          	auipc	a0,0x3
    4f66:	e0650513          	addi	a0,a0,-506 # 7d68 <malloc+0x22cc>
    4f6a:	00001097          	auipc	ra,0x1
    4f6e:	a74080e7          	jalr	-1420(ra) # 59de <printf>
    exit(1);
    4f72:	4505                	li	a0,1
    4f74:	00000097          	auipc	ra,0x0
    4f78:	6e2080e7          	jalr	1762(ra) # 5656 <exit>
      printf("open junk failed\n");
    4f7c:	00003517          	auipc	a0,0x3
    4f80:	dd450513          	addi	a0,a0,-556 # 7d50 <malloc+0x22b4>
    4f84:	00001097          	auipc	ra,0x1
    4f88:	a5a080e7          	jalr	-1446(ra) # 59de <printf>
      exit(1);
    4f8c:	4505                	li	a0,1
    4f8e:	00000097          	auipc	ra,0x0
    4f92:	6c8080e7          	jalr	1736(ra) # 5656 <exit>
    printf("open junk failed\n");
    4f96:	00003517          	auipc	a0,0x3
    4f9a:	dba50513          	addi	a0,a0,-582 # 7d50 <malloc+0x22b4>
    4f9e:	00001097          	auipc	ra,0x1
    4fa2:	a40080e7          	jalr	-1472(ra) # 59de <printf>
    exit(1);
    4fa6:	4505                	li	a0,1
    4fa8:	00000097          	auipc	ra,0x0
    4fac:	6ae080e7          	jalr	1710(ra) # 5656 <exit>
  close(fd);
    4fb0:	8526                	mv	a0,s1
    4fb2:	00000097          	auipc	ra,0x0
    4fb6:	6cc080e7          	jalr	1740(ra) # 567e <close>
  unlink("junk");
    4fba:	00003517          	auipc	a0,0x3
    4fbe:	d8e50513          	addi	a0,a0,-626 # 7d48 <malloc+0x22ac>
    4fc2:	00000097          	auipc	ra,0x0
    4fc6:	6e4080e7          	jalr	1764(ra) # 56a6 <unlink>
  exit(0);
    4fca:	4501                	li	a0,0
    4fcc:	00000097          	auipc	ra,0x0
    4fd0:	68a080e7          	jalr	1674(ra) # 5656 <exit>

0000000000004fd4 <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    4fd4:	7139                	addi	sp,sp,-64
    4fd6:	fc06                	sd	ra,56(sp)
    4fd8:	f822                	sd	s0,48(sp)
    4fda:	f426                	sd	s1,40(sp)
    4fdc:	f04a                	sd	s2,32(sp)
    4fde:	ec4e                	sd	s3,24(sp)
    4fe0:	0080                	addi	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    4fe2:	fc840513          	addi	a0,s0,-56
    4fe6:	00000097          	auipc	ra,0x0
    4fea:	680080e7          	jalr	1664(ra) # 5666 <pipe>
    4fee:	06054863          	bltz	a0,505e <countfree+0x8a>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }
  
  int pid = fork();
    4ff2:	00000097          	auipc	ra,0x0
    4ff6:	65c080e7          	jalr	1628(ra) # 564e <fork>

  if(pid < 0){
    4ffa:	06054f63          	bltz	a0,5078 <countfree+0xa4>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if(pid == 0){
    4ffe:	ed59                	bnez	a0,509c <countfree+0xc8>
    close(fds[0]);
    5000:	fc842503          	lw	a0,-56(s0)
    5004:	00000097          	auipc	ra,0x0
    5008:	67a080e7          	jalr	1658(ra) # 567e <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
      if(a == 0xffffffffffffffff){
    500c:	54fd                	li	s1,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    500e:	4985                	li	s3,1

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    5010:	00001917          	auipc	s2,0x1
    5014:	f3890913          	addi	s2,s2,-200 # 5f48 <malloc+0x4ac>
      uint64 a = (uint64) sbrk(4096);
    5018:	6505                	lui	a0,0x1
    501a:	00000097          	auipc	ra,0x0
    501e:	6c4080e7          	jalr	1732(ra) # 56de <sbrk>
      if(a == 0xffffffffffffffff){
    5022:	06950863          	beq	a0,s1,5092 <countfree+0xbe>
      *(char *)(a + 4096 - 1) = 1;
    5026:	6785                	lui	a5,0x1
    5028:	953e                	add	a0,a0,a5
    502a:	ff350fa3          	sb	s3,-1(a0) # fff <bigdir+0x9d>
      if(write(fds[1], "x", 1) != 1){
    502e:	4605                	li	a2,1
    5030:	85ca                	mv	a1,s2
    5032:	fcc42503          	lw	a0,-52(s0)
    5036:	00000097          	auipc	ra,0x0
    503a:	640080e7          	jalr	1600(ra) # 5676 <write>
    503e:	4785                	li	a5,1
    5040:	fcf50ce3          	beq	a0,a5,5018 <countfree+0x44>
        printf("write() failed in countfree()\n");
    5044:	00003517          	auipc	a0,0x3
    5048:	d7450513          	addi	a0,a0,-652 # 7db8 <malloc+0x231c>
    504c:	00001097          	auipc	ra,0x1
    5050:	992080e7          	jalr	-1646(ra) # 59de <printf>
        exit(1);
    5054:	4505                	li	a0,1
    5056:	00000097          	auipc	ra,0x0
    505a:	600080e7          	jalr	1536(ra) # 5656 <exit>
    printf("pipe() failed in countfree()\n");
    505e:	00003517          	auipc	a0,0x3
    5062:	d1a50513          	addi	a0,a0,-742 # 7d78 <malloc+0x22dc>
    5066:	00001097          	auipc	ra,0x1
    506a:	978080e7          	jalr	-1672(ra) # 59de <printf>
    exit(1);
    506e:	4505                	li	a0,1
    5070:	00000097          	auipc	ra,0x0
    5074:	5e6080e7          	jalr	1510(ra) # 5656 <exit>
    printf("fork failed in countfree()\n");
    5078:	00003517          	auipc	a0,0x3
    507c:	d2050513          	addi	a0,a0,-736 # 7d98 <malloc+0x22fc>
    5080:	00001097          	auipc	ra,0x1
    5084:	95e080e7          	jalr	-1698(ra) # 59de <printf>
    exit(1);
    5088:	4505                	li	a0,1
    508a:	00000097          	auipc	ra,0x0
    508e:	5cc080e7          	jalr	1484(ra) # 5656 <exit>
      }
    }

    exit(0);
    5092:	4501                	li	a0,0
    5094:	00000097          	auipc	ra,0x0
    5098:	5c2080e7          	jalr	1474(ra) # 5656 <exit>
  }

  close(fds[1]);
    509c:	fcc42503          	lw	a0,-52(s0)
    50a0:	00000097          	auipc	ra,0x0
    50a4:	5de080e7          	jalr	1502(ra) # 567e <close>

  int n = 0;
    50a8:	4481                	li	s1,0
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    50aa:	4605                	li	a2,1
    50ac:	fc740593          	addi	a1,s0,-57
    50b0:	fc842503          	lw	a0,-56(s0)
    50b4:	00000097          	auipc	ra,0x0
    50b8:	5ba080e7          	jalr	1466(ra) # 566e <read>
    if(cc < 0){
    50bc:	00054563          	bltz	a0,50c6 <countfree+0xf2>
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if(cc == 0)
    50c0:	c105                	beqz	a0,50e0 <countfree+0x10c>
      break;
    n += 1;
    50c2:	2485                	addiw	s1,s1,1
  while(1){
    50c4:	b7dd                	j	50aa <countfree+0xd6>
      printf("read() failed in countfree()\n");
    50c6:	00003517          	auipc	a0,0x3
    50ca:	d1250513          	addi	a0,a0,-750 # 7dd8 <malloc+0x233c>
    50ce:	00001097          	auipc	ra,0x1
    50d2:	910080e7          	jalr	-1776(ra) # 59de <printf>
      exit(1);
    50d6:	4505                	li	a0,1
    50d8:	00000097          	auipc	ra,0x0
    50dc:	57e080e7          	jalr	1406(ra) # 5656 <exit>
  }

  close(fds[0]);
    50e0:	fc842503          	lw	a0,-56(s0)
    50e4:	00000097          	auipc	ra,0x0
    50e8:	59a080e7          	jalr	1434(ra) # 567e <close>
  wait((int*)0);
    50ec:	4501                	li	a0,0
    50ee:	00000097          	auipc	ra,0x0
    50f2:	570080e7          	jalr	1392(ra) # 565e <wait>
  
  return n;
}
    50f6:	8526                	mv	a0,s1
    50f8:	70e2                	ld	ra,56(sp)
    50fa:	7442                	ld	s0,48(sp)
    50fc:	74a2                	ld	s1,40(sp)
    50fe:	7902                	ld	s2,32(sp)
    5100:	69e2                	ld	s3,24(sp)
    5102:	6121                	addi	sp,sp,64
    5104:	8082                	ret

0000000000005106 <run>:

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    5106:	7179                	addi	sp,sp,-48
    5108:	f406                	sd	ra,40(sp)
    510a:	f022                	sd	s0,32(sp)
    510c:	ec26                	sd	s1,24(sp)
    510e:	e84a                	sd	s2,16(sp)
    5110:	1800                	addi	s0,sp,48
    5112:	84aa                	mv	s1,a0
    5114:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    5116:	00003517          	auipc	a0,0x3
    511a:	ce250513          	addi	a0,a0,-798 # 7df8 <malloc+0x235c>
    511e:	00001097          	auipc	ra,0x1
    5122:	8c0080e7          	jalr	-1856(ra) # 59de <printf>
  if((pid = fork()) < 0) {
    5126:	00000097          	auipc	ra,0x0
    512a:	528080e7          	jalr	1320(ra) # 564e <fork>
    512e:	02054e63          	bltz	a0,516a <run+0x64>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    5132:	c929                	beqz	a0,5184 <run+0x7e>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    5134:	fdc40513          	addi	a0,s0,-36
    5138:	00000097          	auipc	ra,0x0
    513c:	526080e7          	jalr	1318(ra) # 565e <wait>
    if(xstatus != 0) 
    5140:	fdc42783          	lw	a5,-36(s0)
    5144:	c7b9                	beqz	a5,5192 <run+0x8c>
      printf("FAILED\n");
    5146:	00003517          	auipc	a0,0x3
    514a:	cda50513          	addi	a0,a0,-806 # 7e20 <malloc+0x2384>
    514e:	00001097          	auipc	ra,0x1
    5152:	890080e7          	jalr	-1904(ra) # 59de <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    5156:	fdc42503          	lw	a0,-36(s0)
  }
}
    515a:	00153513          	seqz	a0,a0
    515e:	70a2                	ld	ra,40(sp)
    5160:	7402                	ld	s0,32(sp)
    5162:	64e2                	ld	s1,24(sp)
    5164:	6942                	ld	s2,16(sp)
    5166:	6145                	addi	sp,sp,48
    5168:	8082                	ret
    printf("runtest: fork error\n");
    516a:	00003517          	auipc	a0,0x3
    516e:	c9e50513          	addi	a0,a0,-866 # 7e08 <malloc+0x236c>
    5172:	00001097          	auipc	ra,0x1
    5176:	86c080e7          	jalr	-1940(ra) # 59de <printf>
    exit(1);
    517a:	4505                	li	a0,1
    517c:	00000097          	auipc	ra,0x0
    5180:	4da080e7          	jalr	1242(ra) # 5656 <exit>
    f(s);
    5184:	854a                	mv	a0,s2
    5186:	9482                	jalr	s1
    exit(0);
    5188:	4501                	li	a0,0
    518a:	00000097          	auipc	ra,0x0
    518e:	4cc080e7          	jalr	1228(ra) # 5656 <exit>
      printf("OK\n");
    5192:	00003517          	auipc	a0,0x3
    5196:	c9650513          	addi	a0,a0,-874 # 7e28 <malloc+0x238c>
    519a:	00001097          	auipc	ra,0x1
    519e:	844080e7          	jalr	-1980(ra) # 59de <printf>
    51a2:	bf55                	j	5156 <run+0x50>

00000000000051a4 <main>:

int
main(int argc, char *argv[])
{
    51a4:	c1010113          	addi	sp,sp,-1008
    51a8:	3e113423          	sd	ra,1000(sp)
    51ac:	3e813023          	sd	s0,992(sp)
    51b0:	3c913c23          	sd	s1,984(sp)
    51b4:	3d213823          	sd	s2,976(sp)
    51b8:	3d313423          	sd	s3,968(sp)
    51bc:	3d413023          	sd	s4,960(sp)
    51c0:	3b513c23          	sd	s5,952(sp)
    51c4:	3b613823          	sd	s6,944(sp)
    51c8:	1f80                	addi	s0,sp,1008
    51ca:	89aa                	mv	s3,a0
  int continuous = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-c") == 0){
    51cc:	4789                	li	a5,2
    51ce:	08f50b63          	beq	a0,a5,5264 <main+0xc0>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    51d2:	4785                	li	a5,1
  char *justone = 0;
    51d4:	4901                	li	s2,0
  } else if(argc > 1){
    51d6:	0ca7c563          	blt	a5,a0,52a0 <main+0xfc>
  }
  
  struct test {
    void (*f)(char *);
    char *s;
  } tests[] = {
    51da:	00003797          	auipc	a5,0x3
    51de:	d6678793          	addi	a5,a5,-666 # 7f40 <malloc+0x24a4>
    51e2:	c1040713          	addi	a4,s0,-1008
    51e6:	00003817          	auipc	a6,0x3
    51ea:	0fa80813          	addi	a6,a6,250 # 82e0 <malloc+0x2844>
    51ee:	6388                	ld	a0,0(a5)
    51f0:	678c                	ld	a1,8(a5)
    51f2:	6b90                	ld	a2,16(a5)
    51f4:	6f94                	ld	a3,24(a5)
    51f6:	e308                	sd	a0,0(a4)
    51f8:	e70c                	sd	a1,8(a4)
    51fa:	eb10                	sd	a2,16(a4)
    51fc:	ef14                	sd	a3,24(a4)
    51fe:	02078793          	addi	a5,a5,32
    5202:	02070713          	addi	a4,a4,32
    5206:	ff0794e3          	bne	a5,a6,51ee <main+0x4a>
    520a:	6394                	ld	a3,0(a5)
    520c:	679c                	ld	a5,8(a5)
    520e:	e314                	sd	a3,0(a4)
    5210:	e71c                	sd	a5,8(a4)
          exit(1);
      }
    }
  }

  printf("usertests starting\n");
    5212:	00003517          	auipc	a0,0x3
    5216:	cce50513          	addi	a0,a0,-818 # 7ee0 <malloc+0x2444>
    521a:	00000097          	auipc	ra,0x0
    521e:	7c4080e7          	jalr	1988(ra) # 59de <printf>
  int free0 = countfree();
    5222:	00000097          	auipc	ra,0x0
    5226:	db2080e7          	jalr	-590(ra) # 4fd4 <countfree>
    522a:	8a2a                	mv	s4,a0
  int free1 = 0;
  int fail = 0;
  for (struct test *t = tests; t->s != 0; t++) {
    522c:	c1843503          	ld	a0,-1000(s0)
    5230:	c1040493          	addi	s1,s0,-1008
  int fail = 0;
    5234:	4981                	li	s3,0
    if((justone == 0) || strcmp(t->s, justone) == 0) {
      if(!run(t->f, t->s))
        fail = 1;
    5236:	4a85                	li	s5,1
  for (struct test *t = tests; t->s != 0; t++) {
    5238:	e55d                	bnez	a0,52e6 <main+0x142>
  }

  if(fail){
    printf("SOME TESTS FAILED\n");
    exit(1);
  } else if((free1 = countfree()) < free0){
    523a:	00000097          	auipc	ra,0x0
    523e:	d9a080e7          	jalr	-614(ra) # 4fd4 <countfree>
    5242:	85aa                	mv	a1,a0
    5244:	0f455163          	bge	a0,s4,5326 <main+0x182>
    printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    5248:	8652                	mv	a2,s4
    524a:	00003517          	auipc	a0,0x3
    524e:	c4e50513          	addi	a0,a0,-946 # 7e98 <malloc+0x23fc>
    5252:	00000097          	auipc	ra,0x0
    5256:	78c080e7          	jalr	1932(ra) # 59de <printf>
    exit(1);
    525a:	4505                	li	a0,1
    525c:	00000097          	auipc	ra,0x0
    5260:	3fa080e7          	jalr	1018(ra) # 5656 <exit>
    5264:	84ae                	mv	s1,a1
  if(argc == 2 && strcmp(argv[1], "-c") == 0){
    5266:	00003597          	auipc	a1,0x3
    526a:	bca58593          	addi	a1,a1,-1078 # 7e30 <malloc+0x2394>
    526e:	6488                	ld	a0,8(s1)
    5270:	00000097          	auipc	ra,0x0
    5274:	18c080e7          	jalr	396(ra) # 53fc <strcmp>
    5278:	10050563          	beqz	a0,5382 <main+0x1de>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    527c:	00003597          	auipc	a1,0x3
    5280:	c9c58593          	addi	a1,a1,-868 # 7f18 <malloc+0x247c>
    5284:	6488                	ld	a0,8(s1)
    5286:	00000097          	auipc	ra,0x0
    528a:	176080e7          	jalr	374(ra) # 53fc <strcmp>
    528e:	c97d                	beqz	a0,5384 <main+0x1e0>
  } else if(argc == 2 && argv[1][0] != '-'){
    5290:	0084b903          	ld	s2,8(s1)
    5294:	00094703          	lbu	a4,0(s2)
    5298:	02d00793          	li	a5,45
    529c:	f2f71fe3          	bne	a4,a5,51da <main+0x36>
    printf("Usage: usertests [-c] [testname]\n");
    52a0:	00003517          	auipc	a0,0x3
    52a4:	b9850513          	addi	a0,a0,-1128 # 7e38 <malloc+0x239c>
    52a8:	00000097          	auipc	ra,0x0
    52ac:	736080e7          	jalr	1846(ra) # 59de <printf>
    exit(1);
    52b0:	4505                	li	a0,1
    52b2:	00000097          	auipc	ra,0x0
    52b6:	3a4080e7          	jalr	932(ra) # 5656 <exit>
          exit(1);
    52ba:	4505                	li	a0,1
    52bc:	00000097          	auipc	ra,0x0
    52c0:	39a080e7          	jalr	922(ra) # 5656 <exit>
        printf("FAILED -- lost %d free pages\n", free0 - free1);
    52c4:	40a905bb          	subw	a1,s2,a0
    52c8:	855a                	mv	a0,s6
    52ca:	00000097          	auipc	ra,0x0
    52ce:	714080e7          	jalr	1812(ra) # 59de <printf>
        if(continuous != 2)
    52d2:	09498463          	beq	s3,s4,535a <main+0x1b6>
          exit(1);
    52d6:	4505                	li	a0,1
    52d8:	00000097          	auipc	ra,0x0
    52dc:	37e080e7          	jalr	894(ra) # 5656 <exit>
  for (struct test *t = tests; t->s != 0; t++) {
    52e0:	04c1                	addi	s1,s1,16
    52e2:	6488                	ld	a0,8(s1)
    52e4:	c115                	beqz	a0,5308 <main+0x164>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    52e6:	00090863          	beqz	s2,52f6 <main+0x152>
    52ea:	85ca                	mv	a1,s2
    52ec:	00000097          	auipc	ra,0x0
    52f0:	110080e7          	jalr	272(ra) # 53fc <strcmp>
    52f4:	f575                	bnez	a0,52e0 <main+0x13c>
      if(!run(t->f, t->s))
    52f6:	648c                	ld	a1,8(s1)
    52f8:	6088                	ld	a0,0(s1)
    52fa:	00000097          	auipc	ra,0x0
    52fe:	e0c080e7          	jalr	-500(ra) # 5106 <run>
    5302:	fd79                	bnez	a0,52e0 <main+0x13c>
        fail = 1;
    5304:	89d6                	mv	s3,s5
    5306:	bfe9                	j	52e0 <main+0x13c>
  if(fail){
    5308:	f20989e3          	beqz	s3,523a <main+0x96>
    printf("SOME TESTS FAILED\n");
    530c:	00003517          	auipc	a0,0x3
    5310:	b7450513          	addi	a0,a0,-1164 # 7e80 <malloc+0x23e4>
    5314:	00000097          	auipc	ra,0x0
    5318:	6ca080e7          	jalr	1738(ra) # 59de <printf>
    exit(1);
    531c:	4505                	li	a0,1
    531e:	00000097          	auipc	ra,0x0
    5322:	338080e7          	jalr	824(ra) # 5656 <exit>
  } else {
    printf("ALL TESTS PASSED\n");
    5326:	00003517          	auipc	a0,0x3
    532a:	ba250513          	addi	a0,a0,-1118 # 7ec8 <malloc+0x242c>
    532e:	00000097          	auipc	ra,0x0
    5332:	6b0080e7          	jalr	1712(ra) # 59de <printf>
    exit(0);
    5336:	4501                	li	a0,0
    5338:	00000097          	auipc	ra,0x0
    533c:	31e080e7          	jalr	798(ra) # 5656 <exit>
        printf("SOME TESTS FAILED\n");
    5340:	8556                	mv	a0,s5
    5342:	00000097          	auipc	ra,0x0
    5346:	69c080e7          	jalr	1692(ra) # 59de <printf>
        if(continuous != 2)
    534a:	f74998e3          	bne	s3,s4,52ba <main+0x116>
      int free1 = countfree();
    534e:	00000097          	auipc	ra,0x0
    5352:	c86080e7          	jalr	-890(ra) # 4fd4 <countfree>
      if(free1 < free0){
    5356:	f72547e3          	blt	a0,s2,52c4 <main+0x120>
      int free0 = countfree();
    535a:	00000097          	auipc	ra,0x0
    535e:	c7a080e7          	jalr	-902(ra) # 4fd4 <countfree>
    5362:	892a                	mv	s2,a0
      for (struct test *t = tests; t->s != 0; t++) {
    5364:	c1843583          	ld	a1,-1000(s0)
    5368:	d1fd                	beqz	a1,534e <main+0x1aa>
    536a:	c1040493          	addi	s1,s0,-1008
        if(!run(t->f, t->s)){
    536e:	6088                	ld	a0,0(s1)
    5370:	00000097          	auipc	ra,0x0
    5374:	d96080e7          	jalr	-618(ra) # 5106 <run>
    5378:	d561                	beqz	a0,5340 <main+0x19c>
      for (struct test *t = tests; t->s != 0; t++) {
    537a:	04c1                	addi	s1,s1,16
    537c:	648c                	ld	a1,8(s1)
    537e:	f9e5                	bnez	a1,536e <main+0x1ca>
    5380:	b7f9                	j	534e <main+0x1aa>
    continuous = 1;
    5382:	4985                	li	s3,1
  } tests[] = {
    5384:	00003797          	auipc	a5,0x3
    5388:	bbc78793          	addi	a5,a5,-1092 # 7f40 <malloc+0x24a4>
    538c:	c1040713          	addi	a4,s0,-1008
    5390:	00003817          	auipc	a6,0x3
    5394:	f5080813          	addi	a6,a6,-176 # 82e0 <malloc+0x2844>
    5398:	6388                	ld	a0,0(a5)
    539a:	678c                	ld	a1,8(a5)
    539c:	6b90                	ld	a2,16(a5)
    539e:	6f94                	ld	a3,24(a5)
    53a0:	e308                	sd	a0,0(a4)
    53a2:	e70c                	sd	a1,8(a4)
    53a4:	eb10                	sd	a2,16(a4)
    53a6:	ef14                	sd	a3,24(a4)
    53a8:	02078793          	addi	a5,a5,32
    53ac:	02070713          	addi	a4,a4,32
    53b0:	ff0794e3          	bne	a5,a6,5398 <main+0x1f4>
    53b4:	6394                	ld	a3,0(a5)
    53b6:	679c                	ld	a5,8(a5)
    53b8:	e314                	sd	a3,0(a4)
    53ba:	e71c                	sd	a5,8(a4)
    printf("continuous usertests starting\n");
    53bc:	00003517          	auipc	a0,0x3
    53c0:	b3c50513          	addi	a0,a0,-1220 # 7ef8 <malloc+0x245c>
    53c4:	00000097          	auipc	ra,0x0
    53c8:	61a080e7          	jalr	1562(ra) # 59de <printf>
        printf("SOME TESTS FAILED\n");
    53cc:	00003a97          	auipc	s5,0x3
    53d0:	ab4a8a93          	addi	s5,s5,-1356 # 7e80 <malloc+0x23e4>
        if(continuous != 2)
    53d4:	4a09                	li	s4,2
        printf("FAILED -- lost %d free pages\n", free0 - free1);
    53d6:	00003b17          	auipc	s6,0x3
    53da:	a8ab0b13          	addi	s6,s6,-1398 # 7e60 <malloc+0x23c4>
    53de:	bfb5                	j	535a <main+0x1b6>

00000000000053e0 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
    53e0:	1141                	addi	sp,sp,-16
    53e2:	e422                	sd	s0,8(sp)
    53e4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    53e6:	87aa                	mv	a5,a0
    53e8:	0585                	addi	a1,a1,1
    53ea:	0785                	addi	a5,a5,1
    53ec:	fff5c703          	lbu	a4,-1(a1)
    53f0:	fee78fa3          	sb	a4,-1(a5)
    53f4:	fb75                	bnez	a4,53e8 <strcpy+0x8>
    ;
  return os;
}
    53f6:	6422                	ld	s0,8(sp)
    53f8:	0141                	addi	sp,sp,16
    53fa:	8082                	ret

00000000000053fc <strcmp>:

int
strcmp(const char *p, const char *q)
{
    53fc:	1141                	addi	sp,sp,-16
    53fe:	e422                	sd	s0,8(sp)
    5400:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    5402:	00054783          	lbu	a5,0(a0)
    5406:	cb91                	beqz	a5,541a <strcmp+0x1e>
    5408:	0005c703          	lbu	a4,0(a1)
    540c:	00f71763          	bne	a4,a5,541a <strcmp+0x1e>
    p++, q++;
    5410:	0505                	addi	a0,a0,1
    5412:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    5414:	00054783          	lbu	a5,0(a0)
    5418:	fbe5                	bnez	a5,5408 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    541a:	0005c503          	lbu	a0,0(a1)
}
    541e:	40a7853b          	subw	a0,a5,a0
    5422:	6422                	ld	s0,8(sp)
    5424:	0141                	addi	sp,sp,16
    5426:	8082                	ret

0000000000005428 <strlen>:

uint
strlen(const char *s)
{
    5428:	1141                	addi	sp,sp,-16
    542a:	e422                	sd	s0,8(sp)
    542c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    542e:	00054783          	lbu	a5,0(a0)
    5432:	cf91                	beqz	a5,544e <strlen+0x26>
    5434:	0505                	addi	a0,a0,1
    5436:	87aa                	mv	a5,a0
    5438:	4685                	li	a3,1
    543a:	9e89                	subw	a3,a3,a0
    543c:	00f6853b          	addw	a0,a3,a5
    5440:	0785                	addi	a5,a5,1
    5442:	fff7c703          	lbu	a4,-1(a5)
    5446:	fb7d                	bnez	a4,543c <strlen+0x14>
    ;
  return n;
}
    5448:	6422                	ld	s0,8(sp)
    544a:	0141                	addi	sp,sp,16
    544c:	8082                	ret
  for(n = 0; s[n]; n++)
    544e:	4501                	li	a0,0
    5450:	bfe5                	j	5448 <strlen+0x20>

0000000000005452 <memset>:

void*
memset(void *dst, int c, uint n)
{
    5452:	1141                	addi	sp,sp,-16
    5454:	e422                	sd	s0,8(sp)
    5456:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    5458:	ce09                	beqz	a2,5472 <memset+0x20>
    545a:	87aa                	mv	a5,a0
    545c:	fff6071b          	addiw	a4,a2,-1
    5460:	1702                	slli	a4,a4,0x20
    5462:	9301                	srli	a4,a4,0x20
    5464:	0705                	addi	a4,a4,1
    5466:	972a                	add	a4,a4,a0
    cdst[i] = c;
    5468:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    546c:	0785                	addi	a5,a5,1
    546e:	fee79de3          	bne	a5,a4,5468 <memset+0x16>
  }
  return dst;
}
    5472:	6422                	ld	s0,8(sp)
    5474:	0141                	addi	sp,sp,16
    5476:	8082                	ret

0000000000005478 <strchr>:

char*
strchr(const char *s, char c)
{
    5478:	1141                	addi	sp,sp,-16
    547a:	e422                	sd	s0,8(sp)
    547c:	0800                	addi	s0,sp,16
  for(; *s; s++)
    547e:	00054783          	lbu	a5,0(a0)
    5482:	cb99                	beqz	a5,5498 <strchr+0x20>
    if(*s == c)
    5484:	00f58763          	beq	a1,a5,5492 <strchr+0x1a>
  for(; *s; s++)
    5488:	0505                	addi	a0,a0,1
    548a:	00054783          	lbu	a5,0(a0)
    548e:	fbfd                	bnez	a5,5484 <strchr+0xc>
      return (char*)s;
  return 0;
    5490:	4501                	li	a0,0
}
    5492:	6422                	ld	s0,8(sp)
    5494:	0141                	addi	sp,sp,16
    5496:	8082                	ret
  return 0;
    5498:	4501                	li	a0,0
    549a:	bfe5                	j	5492 <strchr+0x1a>

000000000000549c <gets>:

char*
gets(char *buf, int max)
{
    549c:	711d                	addi	sp,sp,-96
    549e:	ec86                	sd	ra,88(sp)
    54a0:	e8a2                	sd	s0,80(sp)
    54a2:	e4a6                	sd	s1,72(sp)
    54a4:	e0ca                	sd	s2,64(sp)
    54a6:	fc4e                	sd	s3,56(sp)
    54a8:	f852                	sd	s4,48(sp)
    54aa:	f456                	sd	s5,40(sp)
    54ac:	f05a                	sd	s6,32(sp)
    54ae:	ec5e                	sd	s7,24(sp)
    54b0:	1080                	addi	s0,sp,96
    54b2:	8baa                	mv	s7,a0
    54b4:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    54b6:	892a                	mv	s2,a0
    54b8:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    54ba:	4aa9                	li	s5,10
    54bc:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    54be:	89a6                	mv	s3,s1
    54c0:	2485                	addiw	s1,s1,1
    54c2:	0344d863          	bge	s1,s4,54f2 <gets+0x56>
    cc = read(0, &c, 1);
    54c6:	4605                	li	a2,1
    54c8:	faf40593          	addi	a1,s0,-81
    54cc:	4501                	li	a0,0
    54ce:	00000097          	auipc	ra,0x0
    54d2:	1a0080e7          	jalr	416(ra) # 566e <read>
    if(cc < 1)
    54d6:	00a05e63          	blez	a0,54f2 <gets+0x56>
    buf[i++] = c;
    54da:	faf44783          	lbu	a5,-81(s0)
    54de:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    54e2:	01578763          	beq	a5,s5,54f0 <gets+0x54>
    54e6:	0905                	addi	s2,s2,1
    54e8:	fd679be3          	bne	a5,s6,54be <gets+0x22>
  for(i=0; i+1 < max; ){
    54ec:	89a6                	mv	s3,s1
    54ee:	a011                	j	54f2 <gets+0x56>
    54f0:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    54f2:	99de                	add	s3,s3,s7
    54f4:	00098023          	sb	zero,0(s3)
  return buf;
}
    54f8:	855e                	mv	a0,s7
    54fa:	60e6                	ld	ra,88(sp)
    54fc:	6446                	ld	s0,80(sp)
    54fe:	64a6                	ld	s1,72(sp)
    5500:	6906                	ld	s2,64(sp)
    5502:	79e2                	ld	s3,56(sp)
    5504:	7a42                	ld	s4,48(sp)
    5506:	7aa2                	ld	s5,40(sp)
    5508:	7b02                	ld	s6,32(sp)
    550a:	6be2                	ld	s7,24(sp)
    550c:	6125                	addi	sp,sp,96
    550e:	8082                	ret

0000000000005510 <stat>:

int
stat(const char *n, struct stat *st)
{
    5510:	1101                	addi	sp,sp,-32
    5512:	ec06                	sd	ra,24(sp)
    5514:	e822                	sd	s0,16(sp)
    5516:	e426                	sd	s1,8(sp)
    5518:	e04a                	sd	s2,0(sp)
    551a:	1000                	addi	s0,sp,32
    551c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    551e:	4581                	li	a1,0
    5520:	00000097          	auipc	ra,0x0
    5524:	176080e7          	jalr	374(ra) # 5696 <open>
  if(fd < 0)
    5528:	02054563          	bltz	a0,5552 <stat+0x42>
    552c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    552e:	85ca                	mv	a1,s2
    5530:	00000097          	auipc	ra,0x0
    5534:	17e080e7          	jalr	382(ra) # 56ae <fstat>
    5538:	892a                	mv	s2,a0
  close(fd);
    553a:	8526                	mv	a0,s1
    553c:	00000097          	auipc	ra,0x0
    5540:	142080e7          	jalr	322(ra) # 567e <close>
  return r;
}
    5544:	854a                	mv	a0,s2
    5546:	60e2                	ld	ra,24(sp)
    5548:	6442                	ld	s0,16(sp)
    554a:	64a2                	ld	s1,8(sp)
    554c:	6902                	ld	s2,0(sp)
    554e:	6105                	addi	sp,sp,32
    5550:	8082                	ret
    return -1;
    5552:	597d                	li	s2,-1
    5554:	bfc5                	j	5544 <stat+0x34>

0000000000005556 <atoi>:

int
atoi(const char *s)
{
    5556:	1141                	addi	sp,sp,-16
    5558:	e422                	sd	s0,8(sp)
    555a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    555c:	00054603          	lbu	a2,0(a0)
    5560:	fd06079b          	addiw	a5,a2,-48
    5564:	0ff7f793          	andi	a5,a5,255
    5568:	4725                	li	a4,9
    556a:	02f76963          	bltu	a4,a5,559c <atoi+0x46>
    556e:	86aa                	mv	a3,a0
  n = 0;
    5570:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
    5572:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
    5574:	0685                	addi	a3,a3,1
    5576:	0025179b          	slliw	a5,a0,0x2
    557a:	9fa9                	addw	a5,a5,a0
    557c:	0017979b          	slliw	a5,a5,0x1
    5580:	9fb1                	addw	a5,a5,a2
    5582:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    5586:	0006c603          	lbu	a2,0(a3) # 1000 <bigdir+0x9e>
    558a:	fd06071b          	addiw	a4,a2,-48
    558e:	0ff77713          	andi	a4,a4,255
    5592:	fee5f1e3          	bgeu	a1,a4,5574 <atoi+0x1e>
  return n;
}
    5596:	6422                	ld	s0,8(sp)
    5598:	0141                	addi	sp,sp,16
    559a:	8082                	ret
  n = 0;
    559c:	4501                	li	a0,0
    559e:	bfe5                	j	5596 <atoi+0x40>

00000000000055a0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    55a0:	1141                	addi	sp,sp,-16
    55a2:	e422                	sd	s0,8(sp)
    55a4:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    55a6:	02b57663          	bgeu	a0,a1,55d2 <memmove+0x32>
    while(n-- > 0)
    55aa:	02c05163          	blez	a2,55cc <memmove+0x2c>
    55ae:	fff6079b          	addiw	a5,a2,-1
    55b2:	1782                	slli	a5,a5,0x20
    55b4:	9381                	srli	a5,a5,0x20
    55b6:	0785                	addi	a5,a5,1
    55b8:	97aa                	add	a5,a5,a0
  dst = vdst;
    55ba:	872a                	mv	a4,a0
      *dst++ = *src++;
    55bc:	0585                	addi	a1,a1,1
    55be:	0705                	addi	a4,a4,1
    55c0:	fff5c683          	lbu	a3,-1(a1)
    55c4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    55c8:	fee79ae3          	bne	a5,a4,55bc <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    55cc:	6422                	ld	s0,8(sp)
    55ce:	0141                	addi	sp,sp,16
    55d0:	8082                	ret
    dst += n;
    55d2:	00c50733          	add	a4,a0,a2
    src += n;
    55d6:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    55d8:	fec05ae3          	blez	a2,55cc <memmove+0x2c>
    55dc:	fff6079b          	addiw	a5,a2,-1
    55e0:	1782                	slli	a5,a5,0x20
    55e2:	9381                	srli	a5,a5,0x20
    55e4:	fff7c793          	not	a5,a5
    55e8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    55ea:	15fd                	addi	a1,a1,-1
    55ec:	177d                	addi	a4,a4,-1
    55ee:	0005c683          	lbu	a3,0(a1)
    55f2:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    55f6:	fee79ae3          	bne	a5,a4,55ea <memmove+0x4a>
    55fa:	bfc9                	j	55cc <memmove+0x2c>

00000000000055fc <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    55fc:	1141                	addi	sp,sp,-16
    55fe:	e422                	sd	s0,8(sp)
    5600:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    5602:	ca05                	beqz	a2,5632 <memcmp+0x36>
    5604:	fff6069b          	addiw	a3,a2,-1
    5608:	1682                	slli	a3,a3,0x20
    560a:	9281                	srli	a3,a3,0x20
    560c:	0685                	addi	a3,a3,1
    560e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    5610:	00054783          	lbu	a5,0(a0)
    5614:	0005c703          	lbu	a4,0(a1)
    5618:	00e79863          	bne	a5,a4,5628 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    561c:	0505                	addi	a0,a0,1
    p2++;
    561e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    5620:	fed518e3          	bne	a0,a3,5610 <memcmp+0x14>
  }
  return 0;
    5624:	4501                	li	a0,0
    5626:	a019                	j	562c <memcmp+0x30>
      return *p1 - *p2;
    5628:	40e7853b          	subw	a0,a5,a4
}
    562c:	6422                	ld	s0,8(sp)
    562e:	0141                	addi	sp,sp,16
    5630:	8082                	ret
  return 0;
    5632:	4501                	li	a0,0
    5634:	bfe5                	j	562c <memcmp+0x30>

0000000000005636 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    5636:	1141                	addi	sp,sp,-16
    5638:	e406                	sd	ra,8(sp)
    563a:	e022                	sd	s0,0(sp)
    563c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    563e:	00000097          	auipc	ra,0x0
    5642:	f62080e7          	jalr	-158(ra) # 55a0 <memmove>
}
    5646:	60a2                	ld	ra,8(sp)
    5648:	6402                	ld	s0,0(sp)
    564a:	0141                	addi	sp,sp,16
    564c:	8082                	ret

000000000000564e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    564e:	4885                	li	a7,1
 ecall
    5650:	00000073          	ecall
 ret
    5654:	8082                	ret

0000000000005656 <exit>:
.global exit
exit:
 li a7, SYS_exit
    5656:	4889                	li	a7,2
 ecall
    5658:	00000073          	ecall
 ret
    565c:	8082                	ret

000000000000565e <wait>:
.global wait
wait:
 li a7, SYS_wait
    565e:	488d                	li	a7,3
 ecall
    5660:	00000073          	ecall
 ret
    5664:	8082                	ret

0000000000005666 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    5666:	4891                	li	a7,4
 ecall
    5668:	00000073          	ecall
 ret
    566c:	8082                	ret

000000000000566e <read>:
.global read
read:
 li a7, SYS_read
    566e:	4895                	li	a7,5
 ecall
    5670:	00000073          	ecall
 ret
    5674:	8082                	ret

0000000000005676 <write>:
.global write
write:
 li a7, SYS_write
    5676:	48c1                	li	a7,16
 ecall
    5678:	00000073          	ecall
 ret
    567c:	8082                	ret

000000000000567e <close>:
.global close
close:
 li a7, SYS_close
    567e:	48d5                	li	a7,21
 ecall
    5680:	00000073          	ecall
 ret
    5684:	8082                	ret

0000000000005686 <kill>:
.global kill
kill:
 li a7, SYS_kill
    5686:	4899                	li	a7,6
 ecall
    5688:	00000073          	ecall
 ret
    568c:	8082                	ret

000000000000568e <exec>:
.global exec
exec:
 li a7, SYS_exec
    568e:	489d                	li	a7,7
 ecall
    5690:	00000073          	ecall
 ret
    5694:	8082                	ret

0000000000005696 <open>:
.global open
open:
 li a7, SYS_open
    5696:	48bd                	li	a7,15
 ecall
    5698:	00000073          	ecall
 ret
    569c:	8082                	ret

000000000000569e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    569e:	48c5                	li	a7,17
 ecall
    56a0:	00000073          	ecall
 ret
    56a4:	8082                	ret

00000000000056a6 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    56a6:	48c9                	li	a7,18
 ecall
    56a8:	00000073          	ecall
 ret
    56ac:	8082                	ret

00000000000056ae <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    56ae:	48a1                	li	a7,8
 ecall
    56b0:	00000073          	ecall
 ret
    56b4:	8082                	ret

00000000000056b6 <link>:
.global link
link:
 li a7, SYS_link
    56b6:	48cd                	li	a7,19
 ecall
    56b8:	00000073          	ecall
 ret
    56bc:	8082                	ret

00000000000056be <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    56be:	48d1                	li	a7,20
 ecall
    56c0:	00000073          	ecall
 ret
    56c4:	8082                	ret

00000000000056c6 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    56c6:	48a5                	li	a7,9
 ecall
    56c8:	00000073          	ecall
 ret
    56cc:	8082                	ret

00000000000056ce <dup>:
.global dup
dup:
 li a7, SYS_dup
    56ce:	48a9                	li	a7,10
 ecall
    56d0:	00000073          	ecall
 ret
    56d4:	8082                	ret

00000000000056d6 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    56d6:	48ad                	li	a7,11
 ecall
    56d8:	00000073          	ecall
 ret
    56dc:	8082                	ret

00000000000056de <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    56de:	48b1                	li	a7,12
 ecall
    56e0:	00000073          	ecall
 ret
    56e4:	8082                	ret

00000000000056e6 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    56e6:	48b5                	li	a7,13
 ecall
    56e8:	00000073          	ecall
 ret
    56ec:	8082                	ret

00000000000056ee <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    56ee:	48b9                	li	a7,14
 ecall
    56f0:	00000073          	ecall
 ret
    56f4:	8082                	ret

00000000000056f6 <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
    56f6:	48d9                	li	a7,22
 ecall
    56f8:	00000073          	ecall
 ret
    56fc:	8082                	ret

00000000000056fe <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
    56fe:	48dd                	li	a7,23
 ecall
    5700:	00000073          	ecall
 ret
    5704:	8082                	ret

0000000000005706 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    5706:	1101                	addi	sp,sp,-32
    5708:	ec06                	sd	ra,24(sp)
    570a:	e822                	sd	s0,16(sp)
    570c:	1000                	addi	s0,sp,32
    570e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    5712:	4605                	li	a2,1
    5714:	fef40593          	addi	a1,s0,-17
    5718:	00000097          	auipc	ra,0x0
    571c:	f5e080e7          	jalr	-162(ra) # 5676 <write>
}
    5720:	60e2                	ld	ra,24(sp)
    5722:	6442                	ld	s0,16(sp)
    5724:	6105                	addi	sp,sp,32
    5726:	8082                	ret

0000000000005728 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    5728:	7139                	addi	sp,sp,-64
    572a:	fc06                	sd	ra,56(sp)
    572c:	f822                	sd	s0,48(sp)
    572e:	f426                	sd	s1,40(sp)
    5730:	f04a                	sd	s2,32(sp)
    5732:	ec4e                	sd	s3,24(sp)
    5734:	0080                	addi	s0,sp,64
    5736:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    5738:	c299                	beqz	a3,573e <printint+0x16>
    573a:	0805c863          	bltz	a1,57ca <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    573e:	2581                	sext.w	a1,a1
  neg = 0;
    5740:	4881                	li	a7,0
    5742:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    5746:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    5748:	2601                	sext.w	a2,a2
    574a:	00003517          	auipc	a0,0x3
    574e:	bae50513          	addi	a0,a0,-1106 # 82f8 <digits>
    5752:	883a                	mv	a6,a4
    5754:	2705                	addiw	a4,a4,1
    5756:	02c5f7bb          	remuw	a5,a1,a2
    575a:	1782                	slli	a5,a5,0x20
    575c:	9381                	srli	a5,a5,0x20
    575e:	97aa                	add	a5,a5,a0
    5760:	0007c783          	lbu	a5,0(a5)
    5764:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    5768:	0005879b          	sext.w	a5,a1
    576c:	02c5d5bb          	divuw	a1,a1,a2
    5770:	0685                	addi	a3,a3,1
    5772:	fec7f0e3          	bgeu	a5,a2,5752 <printint+0x2a>
  if(neg)
    5776:	00088b63          	beqz	a7,578c <printint+0x64>
    buf[i++] = '-';
    577a:	fd040793          	addi	a5,s0,-48
    577e:	973e                	add	a4,a4,a5
    5780:	02d00793          	li	a5,45
    5784:	fef70823          	sb	a5,-16(a4)
    5788:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    578c:	02e05863          	blez	a4,57bc <printint+0x94>
    5790:	fc040793          	addi	a5,s0,-64
    5794:	00e78933          	add	s2,a5,a4
    5798:	fff78993          	addi	s3,a5,-1
    579c:	99ba                	add	s3,s3,a4
    579e:	377d                	addiw	a4,a4,-1
    57a0:	1702                	slli	a4,a4,0x20
    57a2:	9301                	srli	a4,a4,0x20
    57a4:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    57a8:	fff94583          	lbu	a1,-1(s2)
    57ac:	8526                	mv	a0,s1
    57ae:	00000097          	auipc	ra,0x0
    57b2:	f58080e7          	jalr	-168(ra) # 5706 <putc>
  while(--i >= 0)
    57b6:	197d                	addi	s2,s2,-1
    57b8:	ff3918e3          	bne	s2,s3,57a8 <printint+0x80>
}
    57bc:	70e2                	ld	ra,56(sp)
    57be:	7442                	ld	s0,48(sp)
    57c0:	74a2                	ld	s1,40(sp)
    57c2:	7902                	ld	s2,32(sp)
    57c4:	69e2                	ld	s3,24(sp)
    57c6:	6121                	addi	sp,sp,64
    57c8:	8082                	ret
    x = -xx;
    57ca:	40b005bb          	negw	a1,a1
    neg = 1;
    57ce:	4885                	li	a7,1
    x = -xx;
    57d0:	bf8d                	j	5742 <printint+0x1a>

00000000000057d2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    57d2:	7119                	addi	sp,sp,-128
    57d4:	fc86                	sd	ra,120(sp)
    57d6:	f8a2                	sd	s0,112(sp)
    57d8:	f4a6                	sd	s1,104(sp)
    57da:	f0ca                	sd	s2,96(sp)
    57dc:	ecce                	sd	s3,88(sp)
    57de:	e8d2                	sd	s4,80(sp)
    57e0:	e4d6                	sd	s5,72(sp)
    57e2:	e0da                	sd	s6,64(sp)
    57e4:	fc5e                	sd	s7,56(sp)
    57e6:	f862                	sd	s8,48(sp)
    57e8:	f466                	sd	s9,40(sp)
    57ea:	f06a                	sd	s10,32(sp)
    57ec:	ec6e                	sd	s11,24(sp)
    57ee:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    57f0:	0005c903          	lbu	s2,0(a1)
    57f4:	18090f63          	beqz	s2,5992 <vprintf+0x1c0>
    57f8:	8aaa                	mv	s5,a0
    57fa:	8b32                	mv	s6,a2
    57fc:	00158493          	addi	s1,a1,1
  state = 0;
    5800:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    5802:	02500a13          	li	s4,37
      if(c == 'd'){
    5806:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
    580a:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
    580e:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
    5812:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5816:	00003b97          	auipc	s7,0x3
    581a:	ae2b8b93          	addi	s7,s7,-1310 # 82f8 <digits>
    581e:	a839                	j	583c <vprintf+0x6a>
        putc(fd, c);
    5820:	85ca                	mv	a1,s2
    5822:	8556                	mv	a0,s5
    5824:	00000097          	auipc	ra,0x0
    5828:	ee2080e7          	jalr	-286(ra) # 5706 <putc>
    582c:	a019                	j	5832 <vprintf+0x60>
    } else if(state == '%'){
    582e:	01498f63          	beq	s3,s4,584c <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
    5832:	0485                	addi	s1,s1,1
    5834:	fff4c903          	lbu	s2,-1(s1)
    5838:	14090d63          	beqz	s2,5992 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
    583c:	0009079b          	sext.w	a5,s2
    if(state == 0){
    5840:	fe0997e3          	bnez	s3,582e <vprintf+0x5c>
      if(c == '%'){
    5844:	fd479ee3          	bne	a5,s4,5820 <vprintf+0x4e>
        state = '%';
    5848:	89be                	mv	s3,a5
    584a:	b7e5                	j	5832 <vprintf+0x60>
      if(c == 'd'){
    584c:	05878063          	beq	a5,s8,588c <vprintf+0xba>
      } else if(c == 'l') {
    5850:	05978c63          	beq	a5,s9,58a8 <vprintf+0xd6>
      } else if(c == 'x') {
    5854:	07a78863          	beq	a5,s10,58c4 <vprintf+0xf2>
      } else if(c == 'p') {
    5858:	09b78463          	beq	a5,s11,58e0 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
    585c:	07300713          	li	a4,115
    5860:	0ce78663          	beq	a5,a4,592c <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    5864:	06300713          	li	a4,99
    5868:	0ee78e63          	beq	a5,a4,5964 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
    586c:	11478863          	beq	a5,s4,597c <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    5870:	85d2                	mv	a1,s4
    5872:	8556                	mv	a0,s5
    5874:	00000097          	auipc	ra,0x0
    5878:	e92080e7          	jalr	-366(ra) # 5706 <putc>
        putc(fd, c);
    587c:	85ca                	mv	a1,s2
    587e:	8556                	mv	a0,s5
    5880:	00000097          	auipc	ra,0x0
    5884:	e86080e7          	jalr	-378(ra) # 5706 <putc>
      }
      state = 0;
    5888:	4981                	li	s3,0
    588a:	b765                	j	5832 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
    588c:	008b0913          	addi	s2,s6,8
    5890:	4685                	li	a3,1
    5892:	4629                	li	a2,10
    5894:	000b2583          	lw	a1,0(s6)
    5898:	8556                	mv	a0,s5
    589a:	00000097          	auipc	ra,0x0
    589e:	e8e080e7          	jalr	-370(ra) # 5728 <printint>
    58a2:	8b4a                	mv	s6,s2
      state = 0;
    58a4:	4981                	li	s3,0
    58a6:	b771                	j	5832 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    58a8:	008b0913          	addi	s2,s6,8
    58ac:	4681                	li	a3,0
    58ae:	4629                	li	a2,10
    58b0:	000b2583          	lw	a1,0(s6)
    58b4:	8556                	mv	a0,s5
    58b6:	00000097          	auipc	ra,0x0
    58ba:	e72080e7          	jalr	-398(ra) # 5728 <printint>
    58be:	8b4a                	mv	s6,s2
      state = 0;
    58c0:	4981                	li	s3,0
    58c2:	bf85                	j	5832 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    58c4:	008b0913          	addi	s2,s6,8
    58c8:	4681                	li	a3,0
    58ca:	4641                	li	a2,16
    58cc:	000b2583          	lw	a1,0(s6)
    58d0:	8556                	mv	a0,s5
    58d2:	00000097          	auipc	ra,0x0
    58d6:	e56080e7          	jalr	-426(ra) # 5728 <printint>
    58da:	8b4a                	mv	s6,s2
      state = 0;
    58dc:	4981                	li	s3,0
    58de:	bf91                	j	5832 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    58e0:	008b0793          	addi	a5,s6,8
    58e4:	f8f43423          	sd	a5,-120(s0)
    58e8:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    58ec:	03000593          	li	a1,48
    58f0:	8556                	mv	a0,s5
    58f2:	00000097          	auipc	ra,0x0
    58f6:	e14080e7          	jalr	-492(ra) # 5706 <putc>
  putc(fd, 'x');
    58fa:	85ea                	mv	a1,s10
    58fc:	8556                	mv	a0,s5
    58fe:	00000097          	auipc	ra,0x0
    5902:	e08080e7          	jalr	-504(ra) # 5706 <putc>
    5906:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5908:	03c9d793          	srli	a5,s3,0x3c
    590c:	97de                	add	a5,a5,s7
    590e:	0007c583          	lbu	a1,0(a5)
    5912:	8556                	mv	a0,s5
    5914:	00000097          	auipc	ra,0x0
    5918:	df2080e7          	jalr	-526(ra) # 5706 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    591c:	0992                	slli	s3,s3,0x4
    591e:	397d                	addiw	s2,s2,-1
    5920:	fe0914e3          	bnez	s2,5908 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    5924:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    5928:	4981                	li	s3,0
    592a:	b721                	j	5832 <vprintf+0x60>
        s = va_arg(ap, char*);
    592c:	008b0993          	addi	s3,s6,8
    5930:	000b3903          	ld	s2,0(s6)
        if(s == 0)
    5934:	02090163          	beqz	s2,5956 <vprintf+0x184>
        while(*s != 0){
    5938:	00094583          	lbu	a1,0(s2)
    593c:	c9a1                	beqz	a1,598c <vprintf+0x1ba>
          putc(fd, *s);
    593e:	8556                	mv	a0,s5
    5940:	00000097          	auipc	ra,0x0
    5944:	dc6080e7          	jalr	-570(ra) # 5706 <putc>
          s++;
    5948:	0905                	addi	s2,s2,1
        while(*s != 0){
    594a:	00094583          	lbu	a1,0(s2)
    594e:	f9e5                	bnez	a1,593e <vprintf+0x16c>
        s = va_arg(ap, char*);
    5950:	8b4e                	mv	s6,s3
      state = 0;
    5952:	4981                	li	s3,0
    5954:	bdf9                	j	5832 <vprintf+0x60>
          s = "(null)";
    5956:	00003917          	auipc	s2,0x3
    595a:	99a90913          	addi	s2,s2,-1638 # 82f0 <malloc+0x2854>
        while(*s != 0){
    595e:	02800593          	li	a1,40
    5962:	bff1                	j	593e <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
    5964:	008b0913          	addi	s2,s6,8
    5968:	000b4583          	lbu	a1,0(s6)
    596c:	8556                	mv	a0,s5
    596e:	00000097          	auipc	ra,0x0
    5972:	d98080e7          	jalr	-616(ra) # 5706 <putc>
    5976:	8b4a                	mv	s6,s2
      state = 0;
    5978:	4981                	li	s3,0
    597a:	bd65                	j	5832 <vprintf+0x60>
        putc(fd, c);
    597c:	85d2                	mv	a1,s4
    597e:	8556                	mv	a0,s5
    5980:	00000097          	auipc	ra,0x0
    5984:	d86080e7          	jalr	-634(ra) # 5706 <putc>
      state = 0;
    5988:	4981                	li	s3,0
    598a:	b565                	j	5832 <vprintf+0x60>
        s = va_arg(ap, char*);
    598c:	8b4e                	mv	s6,s3
      state = 0;
    598e:	4981                	li	s3,0
    5990:	b54d                	j	5832 <vprintf+0x60>
    }
  }
}
    5992:	70e6                	ld	ra,120(sp)
    5994:	7446                	ld	s0,112(sp)
    5996:	74a6                	ld	s1,104(sp)
    5998:	7906                	ld	s2,96(sp)
    599a:	69e6                	ld	s3,88(sp)
    599c:	6a46                	ld	s4,80(sp)
    599e:	6aa6                	ld	s5,72(sp)
    59a0:	6b06                	ld	s6,64(sp)
    59a2:	7be2                	ld	s7,56(sp)
    59a4:	7c42                	ld	s8,48(sp)
    59a6:	7ca2                	ld	s9,40(sp)
    59a8:	7d02                	ld	s10,32(sp)
    59aa:	6de2                	ld	s11,24(sp)
    59ac:	6109                	addi	sp,sp,128
    59ae:	8082                	ret

00000000000059b0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    59b0:	715d                	addi	sp,sp,-80
    59b2:	ec06                	sd	ra,24(sp)
    59b4:	e822                	sd	s0,16(sp)
    59b6:	1000                	addi	s0,sp,32
    59b8:	e010                	sd	a2,0(s0)
    59ba:	e414                	sd	a3,8(s0)
    59bc:	e818                	sd	a4,16(s0)
    59be:	ec1c                	sd	a5,24(s0)
    59c0:	03043023          	sd	a6,32(s0)
    59c4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    59c8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    59cc:	8622                	mv	a2,s0
    59ce:	00000097          	auipc	ra,0x0
    59d2:	e04080e7          	jalr	-508(ra) # 57d2 <vprintf>
}
    59d6:	60e2                	ld	ra,24(sp)
    59d8:	6442                	ld	s0,16(sp)
    59da:	6161                	addi	sp,sp,80
    59dc:	8082                	ret

00000000000059de <printf>:

void
printf(const char *fmt, ...)
{
    59de:	711d                	addi	sp,sp,-96
    59e0:	ec06                	sd	ra,24(sp)
    59e2:	e822                	sd	s0,16(sp)
    59e4:	1000                	addi	s0,sp,32
    59e6:	e40c                	sd	a1,8(s0)
    59e8:	e810                	sd	a2,16(s0)
    59ea:	ec14                	sd	a3,24(s0)
    59ec:	f018                	sd	a4,32(s0)
    59ee:	f41c                	sd	a5,40(s0)
    59f0:	03043823          	sd	a6,48(s0)
    59f4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    59f8:	00840613          	addi	a2,s0,8
    59fc:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    5a00:	85aa                	mv	a1,a0
    5a02:	4505                	li	a0,1
    5a04:	00000097          	auipc	ra,0x0
    5a08:	dce080e7          	jalr	-562(ra) # 57d2 <vprintf>
}
    5a0c:	60e2                	ld	ra,24(sp)
    5a0e:	6442                	ld	s0,16(sp)
    5a10:	6125                	addi	sp,sp,96
    5a12:	8082                	ret

0000000000005a14 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    5a14:	1141                	addi	sp,sp,-16
    5a16:	e422                	sd	s0,8(sp)
    5a18:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    5a1a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5a1e:	00003797          	auipc	a5,0x3
    5a22:	9027b783          	ld	a5,-1790(a5) # 8320 <freep>
    5a26:	a805                	j	5a56 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    5a28:	4618                	lw	a4,8(a2)
    5a2a:	9db9                	addw	a1,a1,a4
    5a2c:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    5a30:	6398                	ld	a4,0(a5)
    5a32:	6318                	ld	a4,0(a4)
    5a34:	fee53823          	sd	a4,-16(a0)
    5a38:	a091                	j	5a7c <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    5a3a:	ff852703          	lw	a4,-8(a0)
    5a3e:	9e39                	addw	a2,a2,a4
    5a40:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    5a42:	ff053703          	ld	a4,-16(a0)
    5a46:	e398                	sd	a4,0(a5)
    5a48:	a099                	j	5a8e <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5a4a:	6398                	ld	a4,0(a5)
    5a4c:	00e7e463          	bltu	a5,a4,5a54 <free+0x40>
    5a50:	00e6ea63          	bltu	a3,a4,5a64 <free+0x50>
{
    5a54:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5a56:	fed7fae3          	bgeu	a5,a3,5a4a <free+0x36>
    5a5a:	6398                	ld	a4,0(a5)
    5a5c:	00e6e463          	bltu	a3,a4,5a64 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5a60:	fee7eae3          	bltu	a5,a4,5a54 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    5a64:	ff852583          	lw	a1,-8(a0)
    5a68:	6390                	ld	a2,0(a5)
    5a6a:	02059713          	slli	a4,a1,0x20
    5a6e:	9301                	srli	a4,a4,0x20
    5a70:	0712                	slli	a4,a4,0x4
    5a72:	9736                	add	a4,a4,a3
    5a74:	fae60ae3          	beq	a2,a4,5a28 <free+0x14>
    bp->s.ptr = p->s.ptr;
    5a78:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    5a7c:	4790                	lw	a2,8(a5)
    5a7e:	02061713          	slli	a4,a2,0x20
    5a82:	9301                	srli	a4,a4,0x20
    5a84:	0712                	slli	a4,a4,0x4
    5a86:	973e                	add	a4,a4,a5
    5a88:	fae689e3          	beq	a3,a4,5a3a <free+0x26>
  } else
    p->s.ptr = bp;
    5a8c:	e394                	sd	a3,0(a5)
  freep = p;
    5a8e:	00003717          	auipc	a4,0x3
    5a92:	88f73923          	sd	a5,-1902(a4) # 8320 <freep>
}
    5a96:	6422                	ld	s0,8(sp)
    5a98:	0141                	addi	sp,sp,16
    5a9a:	8082                	ret

0000000000005a9c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    5a9c:	7139                	addi	sp,sp,-64
    5a9e:	fc06                	sd	ra,56(sp)
    5aa0:	f822                	sd	s0,48(sp)
    5aa2:	f426                	sd	s1,40(sp)
    5aa4:	f04a                	sd	s2,32(sp)
    5aa6:	ec4e                	sd	s3,24(sp)
    5aa8:	e852                	sd	s4,16(sp)
    5aaa:	e456                	sd	s5,8(sp)
    5aac:	e05a                	sd	s6,0(sp)
    5aae:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    5ab0:	02051493          	slli	s1,a0,0x20
    5ab4:	9081                	srli	s1,s1,0x20
    5ab6:	04bd                	addi	s1,s1,15
    5ab8:	8091                	srli	s1,s1,0x4
    5aba:	0014899b          	addiw	s3,s1,1
    5abe:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    5ac0:	00003517          	auipc	a0,0x3
    5ac4:	86053503          	ld	a0,-1952(a0) # 8320 <freep>
    5ac8:	c515                	beqz	a0,5af4 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    5aca:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    5acc:	4798                	lw	a4,8(a5)
    5ace:	02977f63          	bgeu	a4,s1,5b0c <malloc+0x70>
    5ad2:	8a4e                	mv	s4,s3
    5ad4:	0009871b          	sext.w	a4,s3
    5ad8:	6685                	lui	a3,0x1
    5ada:	00d77363          	bgeu	a4,a3,5ae0 <malloc+0x44>
    5ade:	6a05                	lui	s4,0x1
    5ae0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    5ae4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    5ae8:	00003917          	auipc	s2,0x3
    5aec:	83890913          	addi	s2,s2,-1992 # 8320 <freep>
  if(p == (char*)-1)
    5af0:	5afd                	li	s5,-1
    5af2:	a88d                	j	5b64 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
    5af4:	00009797          	auipc	a5,0x9
    5af8:	04c78793          	addi	a5,a5,76 # eb40 <base>
    5afc:	00003717          	auipc	a4,0x3
    5b00:	82f73223          	sd	a5,-2012(a4) # 8320 <freep>
    5b04:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    5b06:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    5b0a:	b7e1                	j	5ad2 <malloc+0x36>
      if(p->s.size == nunits)
    5b0c:	02e48b63          	beq	s1,a4,5b42 <malloc+0xa6>
        p->s.size -= nunits;
    5b10:	4137073b          	subw	a4,a4,s3
    5b14:	c798                	sw	a4,8(a5)
        p += p->s.size;
    5b16:	1702                	slli	a4,a4,0x20
    5b18:	9301                	srli	a4,a4,0x20
    5b1a:	0712                	slli	a4,a4,0x4
    5b1c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    5b1e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    5b22:	00002717          	auipc	a4,0x2
    5b26:	7ea73f23          	sd	a0,2046(a4) # 8320 <freep>
      return (void*)(p + 1);
    5b2a:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    5b2e:	70e2                	ld	ra,56(sp)
    5b30:	7442                	ld	s0,48(sp)
    5b32:	74a2                	ld	s1,40(sp)
    5b34:	7902                	ld	s2,32(sp)
    5b36:	69e2                	ld	s3,24(sp)
    5b38:	6a42                	ld	s4,16(sp)
    5b3a:	6aa2                	ld	s5,8(sp)
    5b3c:	6b02                	ld	s6,0(sp)
    5b3e:	6121                	addi	sp,sp,64
    5b40:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    5b42:	6398                	ld	a4,0(a5)
    5b44:	e118                	sd	a4,0(a0)
    5b46:	bff1                	j	5b22 <malloc+0x86>
  hp->s.size = nu;
    5b48:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    5b4c:	0541                	addi	a0,a0,16
    5b4e:	00000097          	auipc	ra,0x0
    5b52:	ec6080e7          	jalr	-314(ra) # 5a14 <free>
  return freep;
    5b56:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    5b5a:	d971                	beqz	a0,5b2e <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    5b5c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    5b5e:	4798                	lw	a4,8(a5)
    5b60:	fa9776e3          	bgeu	a4,s1,5b0c <malloc+0x70>
    if(p == freep)
    5b64:	00093703          	ld	a4,0(s2)
    5b68:	853e                	mv	a0,a5
    5b6a:	fef719e3          	bne	a4,a5,5b5c <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
    5b6e:	8552                	mv	a0,s4
    5b70:	00000097          	auipc	ra,0x0
    5b74:	b6e080e7          	jalr	-1170(ra) # 56de <sbrk>
  if(p == (char*)-1)
    5b78:	fd5518e3          	bne	a0,s5,5b48 <malloc+0xac>
        return 0;
    5b7c:	4501                	li	a0,0
    5b7e:	bf45                	j	5b2e <malloc+0x92>
