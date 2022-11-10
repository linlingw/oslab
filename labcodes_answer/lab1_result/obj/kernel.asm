
bin/kernel：     文件格式 elf32-i386


Disassembly of section .text:

00100000 <kern_init>:
void kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

void
kern_init(void){
  100000:	55                   	push   %ebp
  100001:	89 e5                	mov    %esp,%ebp
  100003:	83 ec 18             	sub    $0x18,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100006:	b8 68 0d 11 00       	mov    $0x110d68,%eax
  10000b:	2d 16 fa 10 00       	sub    $0x10fa16,%eax
  100010:	83 ec 04             	sub    $0x4,%esp
  100013:	50                   	push   %eax
  100014:	6a 00                	push   $0x0
  100016:	68 16 fa 10 00       	push   $0x10fa16
  10001b:	e8 b5 33 00 00       	call   1033d5 <memset>
  100020:	83 c4 10             	add    $0x10,%esp

    cons_init();                // init the console
  100023:	e8 55 15 00 00       	call   10157d <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100028:	c7 45 f4 60 35 10 00 	movl   $0x103560,-0xc(%ebp)
    cprintf("%s\n\n", message);
  10002f:	83 ec 08             	sub    $0x8,%esp
  100032:	ff 75 f4             	push   -0xc(%ebp)
  100035:	68 7c 35 10 00       	push   $0x10357c
  10003a:	e8 cc 02 00 00       	call   10030b <cprintf>
  10003f:	83 c4 10             	add    $0x10,%esp

    print_kerninfo();
  100042:	e8 c2 07 00 00       	call   100809 <print_kerninfo>

    grade_backtrace();
  100047:	e8 79 00 00 00       	call   1000c5 <grade_backtrace>

    pmm_init();                 // init physical memory management
  10004c:	e8 43 2a 00 00       	call   102a94 <pmm_init>

    pic_init();                 // init interrupt controller
  100051:	e8 7c 16 00 00       	call   1016d2 <pic_init>
    idt_init();                 // init interrupt descriptor table
  100056:	e8 dd 17 00 00       	call   101838 <idt_init>

    clock_init();               // init clock interrupt
  10005b:	e8 de 0c 00 00       	call   100d3e <clock_init>
    intr_enable();              // enable irq interrupt
  100060:	e8 d5 15 00 00       	call   10163a <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    lab1_switch_test();
  100065:	e8 50 01 00 00       	call   1001ba <lab1_switch_test>

    /* do nothing */
    while (1);
  10006a:	eb fe                	jmp    10006a <kern_init+0x6a>

0010006c <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  10006c:	55                   	push   %ebp
  10006d:	89 e5                	mov    %esp,%ebp
  10006f:	83 ec 08             	sub    $0x8,%esp
    mon_backtrace(0, NULL, NULL);
  100072:	83 ec 04             	sub    $0x4,%esp
  100075:	6a 00                	push   $0x0
  100077:	6a 00                	push   $0x0
  100079:	6a 00                	push   $0x0
  10007b:	e8 d8 0b 00 00       	call   100c58 <mon_backtrace>
  100080:	83 c4 10             	add    $0x10,%esp
}
  100083:	90                   	nop
  100084:	c9                   	leave  
  100085:	c3                   	ret    

00100086 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  100086:	55                   	push   %ebp
  100087:	89 e5                	mov    %esp,%ebp
  100089:	53                   	push   %ebx
  10008a:	83 ec 04             	sub    $0x4,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  10008d:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  100090:	8b 55 0c             	mov    0xc(%ebp),%edx
  100093:	8d 5d 08             	lea    0x8(%ebp),%ebx
  100096:	8b 45 08             	mov    0x8(%ebp),%eax
  100099:	51                   	push   %ecx
  10009a:	52                   	push   %edx
  10009b:	53                   	push   %ebx
  10009c:	50                   	push   %eax
  10009d:	e8 ca ff ff ff       	call   10006c <grade_backtrace2>
  1000a2:	83 c4 10             	add    $0x10,%esp
}
  1000a5:	90                   	nop
  1000a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1000a9:	c9                   	leave  
  1000aa:	c3                   	ret    

001000ab <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000ab:	55                   	push   %ebp
  1000ac:	89 e5                	mov    %esp,%ebp
  1000ae:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace1(arg0, arg2);
  1000b1:	83 ec 08             	sub    $0x8,%esp
  1000b4:	ff 75 10             	push   0x10(%ebp)
  1000b7:	ff 75 08             	push   0x8(%ebp)
  1000ba:	e8 c7 ff ff ff       	call   100086 <grade_backtrace1>
  1000bf:	83 c4 10             	add    $0x10,%esp
}
  1000c2:	90                   	nop
  1000c3:	c9                   	leave  
  1000c4:	c3                   	ret    

001000c5 <grade_backtrace>:

void
grade_backtrace(void) {
  1000c5:	55                   	push   %ebp
  1000c6:	89 e5                	mov    %esp,%ebp
  1000c8:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000cb:	b8 00 00 10 00       	mov    $0x100000,%eax
  1000d0:	83 ec 04             	sub    $0x4,%esp
  1000d3:	68 00 00 ff ff       	push   $0xffff0000
  1000d8:	50                   	push   %eax
  1000d9:	6a 00                	push   $0x0
  1000db:	e8 cb ff ff ff       	call   1000ab <grade_backtrace0>
  1000e0:	83 c4 10             	add    $0x10,%esp
}
  1000e3:	90                   	nop
  1000e4:	c9                   	leave  
  1000e5:	c3                   	ret    

001000e6 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  1000e6:	55                   	push   %ebp
  1000e7:	89 e5                	mov    %esp,%ebp
  1000e9:	83 ec 18             	sub    $0x18,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  1000ec:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  1000ef:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  1000f2:	8c 45 f2             	mov    %es,-0xe(%ebp)
  1000f5:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  1000f8:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1000fc:	0f b7 c0             	movzwl %ax,%eax
  1000ff:	83 e0 03             	and    $0x3,%eax
  100102:	89 c2                	mov    %eax,%edx
  100104:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  100109:	83 ec 04             	sub    $0x4,%esp
  10010c:	52                   	push   %edx
  10010d:	50                   	push   %eax
  10010e:	68 81 35 10 00       	push   $0x103581
  100113:	e8 f3 01 00 00       	call   10030b <cprintf>
  100118:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  cs = %x\n", round, reg1);
  10011b:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10011f:	0f b7 d0             	movzwl %ax,%edx
  100122:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  100127:	83 ec 04             	sub    $0x4,%esp
  10012a:	52                   	push   %edx
  10012b:	50                   	push   %eax
  10012c:	68 8f 35 10 00       	push   $0x10358f
  100131:	e8 d5 01 00 00       	call   10030b <cprintf>
  100136:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ds = %x\n", round, reg2);
  100139:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  10013d:	0f b7 d0             	movzwl %ax,%edx
  100140:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  100145:	83 ec 04             	sub    $0x4,%esp
  100148:	52                   	push   %edx
  100149:	50                   	push   %eax
  10014a:	68 9d 35 10 00       	push   $0x10359d
  10014f:	e8 b7 01 00 00       	call   10030b <cprintf>
  100154:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  es = %x\n", round, reg3);
  100157:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10015b:	0f b7 d0             	movzwl %ax,%edx
  10015e:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  100163:	83 ec 04             	sub    $0x4,%esp
  100166:	52                   	push   %edx
  100167:	50                   	push   %eax
  100168:	68 ab 35 10 00       	push   $0x1035ab
  10016d:	e8 99 01 00 00       	call   10030b <cprintf>
  100172:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ss = %x\n", round, reg4);
  100175:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  100179:	0f b7 d0             	movzwl %ax,%edx
  10017c:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  100181:	83 ec 04             	sub    $0x4,%esp
  100184:	52                   	push   %edx
  100185:	50                   	push   %eax
  100186:	68 b9 35 10 00       	push   $0x1035b9
  10018b:	e8 7b 01 00 00       	call   10030b <cprintf>
  100190:	83 c4 10             	add    $0x10,%esp
    round ++;
  100193:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  100198:	83 c0 01             	add    $0x1,%eax
  10019b:	a3 20 fa 10 00       	mov    %eax,0x10fa20
}
  1001a0:	90                   	nop
  1001a1:	c9                   	leave  
  1001a2:	c3                   	ret    

001001a3 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001a3:	55                   	push   %ebp
  1001a4:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
	asm volatile (
  1001a6:	83 ec 08             	sub    $0x8,%esp
  1001a9:	cd 78                	int    $0x78
  1001ab:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp"
	    : 
	    : "i"(T_SWITCH_TOU)
	);
}
  1001ad:	90                   	nop
  1001ae:	5d                   	pop    %ebp
  1001af:	c3                   	ret    

001001b0 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001b0:	55                   	push   %ebp
  1001b1:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
	asm volatile (
  1001b3:	cd 79                	int    $0x79
  1001b5:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp \n"
	    : 
	    : "i"(T_SWITCH_TOK)
	);
}
  1001b7:	90                   	nop
  1001b8:	5d                   	pop    %ebp
  1001b9:	c3                   	ret    

001001ba <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001ba:	55                   	push   %ebp
  1001bb:	89 e5                	mov    %esp,%ebp
  1001bd:	83 ec 08             	sub    $0x8,%esp
    lab1_print_cur_status();
  1001c0:	e8 21 ff ff ff       	call   1000e6 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  1001c5:	83 ec 0c             	sub    $0xc,%esp
  1001c8:	68 c8 35 10 00       	push   $0x1035c8
  1001cd:	e8 39 01 00 00       	call   10030b <cprintf>
  1001d2:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_user();
  1001d5:	e8 c9 ff ff ff       	call   1001a3 <lab1_switch_to_user>
    lab1_print_cur_status();
  1001da:	e8 07 ff ff ff       	call   1000e6 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  1001df:	83 ec 0c             	sub    $0xc,%esp
  1001e2:	68 e8 35 10 00       	push   $0x1035e8
  1001e7:	e8 1f 01 00 00       	call   10030b <cprintf>
  1001ec:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_kernel();
  1001ef:	e8 bc ff ff ff       	call   1001b0 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  1001f4:	e8 ed fe ff ff       	call   1000e6 <lab1_print_cur_status>
}
  1001f9:	90                   	nop
  1001fa:	c9                   	leave  
  1001fb:	c3                   	ret    

001001fc <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  1001fc:	55                   	push   %ebp
  1001fd:	89 e5                	mov    %esp,%ebp
  1001ff:	83 ec 18             	sub    $0x18,%esp
    if (prompt != NULL) {
  100202:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100206:	74 13                	je     10021b <readline+0x1f>
        cprintf("%s", prompt);
  100208:	83 ec 08             	sub    $0x8,%esp
  10020b:	ff 75 08             	push   0x8(%ebp)
  10020e:	68 07 36 10 00       	push   $0x103607
  100213:	e8 f3 00 00 00       	call   10030b <cprintf>
  100218:	83 c4 10             	add    $0x10,%esp
    }
    int i = 0, c;
  10021b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100222:	e8 6f 01 00 00       	call   100396 <getchar>
  100227:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  10022a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10022e:	79 0a                	jns    10023a <readline+0x3e>
            return NULL;
  100230:	b8 00 00 00 00       	mov    $0x0,%eax
  100235:	e9 82 00 00 00       	jmp    1002bc <readline+0xc0>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  10023a:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  10023e:	7e 2b                	jle    10026b <readline+0x6f>
  100240:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100247:	7f 22                	jg     10026b <readline+0x6f>
            cputchar(c);
  100249:	83 ec 0c             	sub    $0xc,%esp
  10024c:	ff 75 f0             	push   -0x10(%ebp)
  10024f:	e8 dd 00 00 00       	call   100331 <cputchar>
  100254:	83 c4 10             	add    $0x10,%esp
            buf[i ++] = c;
  100257:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10025a:	8d 50 01             	lea    0x1(%eax),%edx
  10025d:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100260:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100263:	88 90 40 fa 10 00    	mov    %dl,0x10fa40(%eax)
  100269:	eb 4c                	jmp    1002b7 <readline+0xbb>
        }
        else if (c == '\b' && i > 0) {
  10026b:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  10026f:	75 1a                	jne    10028b <readline+0x8f>
  100271:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100275:	7e 14                	jle    10028b <readline+0x8f>
            cputchar(c);
  100277:	83 ec 0c             	sub    $0xc,%esp
  10027a:	ff 75 f0             	push   -0x10(%ebp)
  10027d:	e8 af 00 00 00       	call   100331 <cputchar>
  100282:	83 c4 10             	add    $0x10,%esp
            i --;
  100285:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  100289:	eb 2c                	jmp    1002b7 <readline+0xbb>
        }
        else if (c == '\n' || c == '\r') {
  10028b:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  10028f:	74 06                	je     100297 <readline+0x9b>
  100291:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  100295:	75 8b                	jne    100222 <readline+0x26>
            cputchar(c);
  100297:	83 ec 0c             	sub    $0xc,%esp
  10029a:	ff 75 f0             	push   -0x10(%ebp)
  10029d:	e8 8f 00 00 00       	call   100331 <cputchar>
  1002a2:	83 c4 10             	add    $0x10,%esp
            buf[i] = '\0';
  1002a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002a8:	05 40 fa 10 00       	add    $0x10fa40,%eax
  1002ad:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002b0:	b8 40 fa 10 00       	mov    $0x10fa40,%eax
  1002b5:	eb 05                	jmp    1002bc <readline+0xc0>
        c = getchar();
  1002b7:	e9 66 ff ff ff       	jmp    100222 <readline+0x26>
        }
    }
}
  1002bc:	c9                   	leave  
  1002bd:	c3                   	ret    

001002be <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002be:	55                   	push   %ebp
  1002bf:	89 e5                	mov    %esp,%ebp
  1002c1:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
  1002c4:	83 ec 0c             	sub    $0xc,%esp
  1002c7:	ff 75 08             	push   0x8(%ebp)
  1002ca:	e8 df 12 00 00       	call   1015ae <cons_putc>
  1002cf:	83 c4 10             	add    $0x10,%esp
    (*cnt) ++;
  1002d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002d5:	8b 00                	mov    (%eax),%eax
  1002d7:	8d 50 01             	lea    0x1(%eax),%edx
  1002da:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002dd:	89 10                	mov    %edx,(%eax)
}
  1002df:	90                   	nop
  1002e0:	c9                   	leave  
  1002e1:	c3                   	ret    

001002e2 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  1002e2:	55                   	push   %ebp
  1002e3:	89 e5                	mov    %esp,%ebp
  1002e5:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
  1002e8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  1002ef:	ff 75 0c             	push   0xc(%ebp)
  1002f2:	ff 75 08             	push   0x8(%ebp)
  1002f5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1002f8:	50                   	push   %eax
  1002f9:	68 be 02 10 00       	push   $0x1002be
  1002fe:	e8 42 29 00 00       	call   102c45 <vprintfmt>
  100303:	83 c4 10             	add    $0x10,%esp
    return cnt;
  100306:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100309:	c9                   	leave  
  10030a:	c3                   	ret    

0010030b <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  10030b:	55                   	push   %ebp
  10030c:	89 e5                	mov    %esp,%ebp
  10030e:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100311:	8d 45 0c             	lea    0xc(%ebp),%eax
  100314:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100317:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10031a:	83 ec 08             	sub    $0x8,%esp
  10031d:	50                   	push   %eax
  10031e:	ff 75 08             	push   0x8(%ebp)
  100321:	e8 bc ff ff ff       	call   1002e2 <vcprintf>
  100326:	83 c4 10             	add    $0x10,%esp
  100329:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10032c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10032f:	c9                   	leave  
  100330:	c3                   	ret    

00100331 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100331:	55                   	push   %ebp
  100332:	89 e5                	mov    %esp,%ebp
  100334:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
  100337:	83 ec 0c             	sub    $0xc,%esp
  10033a:	ff 75 08             	push   0x8(%ebp)
  10033d:	e8 6c 12 00 00       	call   1015ae <cons_putc>
  100342:	83 c4 10             	add    $0x10,%esp
}
  100345:	90                   	nop
  100346:	c9                   	leave  
  100347:	c3                   	ret    

00100348 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  100348:	55                   	push   %ebp
  100349:	89 e5                	mov    %esp,%ebp
  10034b:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
  10034e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  100355:	eb 14                	jmp    10036b <cputs+0x23>
        cputch(c, &cnt);
  100357:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  10035b:	83 ec 08             	sub    $0x8,%esp
  10035e:	8d 55 f0             	lea    -0x10(%ebp),%edx
  100361:	52                   	push   %edx
  100362:	50                   	push   %eax
  100363:	e8 56 ff ff ff       	call   1002be <cputch>
  100368:	83 c4 10             	add    $0x10,%esp
    while ((c = *str ++) != '\0') {
  10036b:	8b 45 08             	mov    0x8(%ebp),%eax
  10036e:	8d 50 01             	lea    0x1(%eax),%edx
  100371:	89 55 08             	mov    %edx,0x8(%ebp)
  100374:	0f b6 00             	movzbl (%eax),%eax
  100377:	88 45 f7             	mov    %al,-0x9(%ebp)
  10037a:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  10037e:	75 d7                	jne    100357 <cputs+0xf>
    }
    cputch('\n', &cnt);
  100380:	83 ec 08             	sub    $0x8,%esp
  100383:	8d 45 f0             	lea    -0x10(%ebp),%eax
  100386:	50                   	push   %eax
  100387:	6a 0a                	push   $0xa
  100389:	e8 30 ff ff ff       	call   1002be <cputch>
  10038e:	83 c4 10             	add    $0x10,%esp
    return cnt;
  100391:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  100394:	c9                   	leave  
  100395:	c3                   	ret    

00100396 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  100396:	55                   	push   %ebp
  100397:	89 e5                	mov    %esp,%ebp
  100399:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  10039c:	90                   	nop
  10039d:	e8 3c 12 00 00       	call   1015de <cons_getc>
  1003a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003a9:	74 f2                	je     10039d <getchar+0x7>
        /* do nothing */;
    return c;
  1003ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003ae:	c9                   	leave  
  1003af:	c3                   	ret    

001003b0 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1003b0:	55                   	push   %ebp
  1003b1:	89 e5                	mov    %esp,%ebp
  1003b3:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1003b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003b9:	8b 00                	mov    (%eax),%eax
  1003bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1003be:	8b 45 10             	mov    0x10(%ebp),%eax
  1003c1:	8b 00                	mov    (%eax),%eax
  1003c3:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1003c6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1003cd:	e9 d2 00 00 00       	jmp    1004a4 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  1003d2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1003d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1003d8:	01 d0                	add    %edx,%eax
  1003da:	89 c2                	mov    %eax,%edx
  1003dc:	c1 ea 1f             	shr    $0x1f,%edx
  1003df:	01 d0                	add    %edx,%eax
  1003e1:	d1 f8                	sar    %eax
  1003e3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1003e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1003e9:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1003ec:	eb 04                	jmp    1003f2 <stab_binsearch+0x42>
            m --;
  1003ee:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
  1003f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003f5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1003f8:	7c 1f                	jl     100419 <stab_binsearch+0x69>
  1003fa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1003fd:	89 d0                	mov    %edx,%eax
  1003ff:	01 c0                	add    %eax,%eax
  100401:	01 d0                	add    %edx,%eax
  100403:	c1 e0 02             	shl    $0x2,%eax
  100406:	89 c2                	mov    %eax,%edx
  100408:	8b 45 08             	mov    0x8(%ebp),%eax
  10040b:	01 d0                	add    %edx,%eax
  10040d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100411:	0f b6 c0             	movzbl %al,%eax
  100414:	39 45 14             	cmp    %eax,0x14(%ebp)
  100417:	75 d5                	jne    1003ee <stab_binsearch+0x3e>
        }
        if (m < l) {    // no match in [l, m]
  100419:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10041c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10041f:	7d 0b                	jge    10042c <stab_binsearch+0x7c>
            l = true_m + 1;
  100421:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100424:	83 c0 01             	add    $0x1,%eax
  100427:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  10042a:	eb 78                	jmp    1004a4 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  10042c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100433:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100436:	89 d0                	mov    %edx,%eax
  100438:	01 c0                	add    %eax,%eax
  10043a:	01 d0                	add    %edx,%eax
  10043c:	c1 e0 02             	shl    $0x2,%eax
  10043f:	89 c2                	mov    %eax,%edx
  100441:	8b 45 08             	mov    0x8(%ebp),%eax
  100444:	01 d0                	add    %edx,%eax
  100446:	8b 40 08             	mov    0x8(%eax),%eax
  100449:	39 45 18             	cmp    %eax,0x18(%ebp)
  10044c:	76 13                	jbe    100461 <stab_binsearch+0xb1>
            *region_left = m;
  10044e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100451:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100454:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100456:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100459:	83 c0 01             	add    $0x1,%eax
  10045c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10045f:	eb 43                	jmp    1004a4 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  100461:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100464:	89 d0                	mov    %edx,%eax
  100466:	01 c0                	add    %eax,%eax
  100468:	01 d0                	add    %edx,%eax
  10046a:	c1 e0 02             	shl    $0x2,%eax
  10046d:	89 c2                	mov    %eax,%edx
  10046f:	8b 45 08             	mov    0x8(%ebp),%eax
  100472:	01 d0                	add    %edx,%eax
  100474:	8b 40 08             	mov    0x8(%eax),%eax
  100477:	39 45 18             	cmp    %eax,0x18(%ebp)
  10047a:	73 16                	jae    100492 <stab_binsearch+0xe2>
            *region_right = m - 1;
  10047c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10047f:	8d 50 ff             	lea    -0x1(%eax),%edx
  100482:	8b 45 10             	mov    0x10(%ebp),%eax
  100485:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  100487:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10048a:	83 e8 01             	sub    $0x1,%eax
  10048d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100490:	eb 12                	jmp    1004a4 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  100492:	8b 45 0c             	mov    0xc(%ebp),%eax
  100495:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100498:	89 10                	mov    %edx,(%eax)
            l = m;
  10049a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10049d:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1004a0:	83 45 18 01          	addl   $0x1,0x18(%ebp)
    while (l <= r) {
  1004a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004a7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1004aa:	0f 8e 22 ff ff ff    	jle    1003d2 <stab_binsearch+0x22>
        }
    }

    if (!any_matches) {
  1004b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004b4:	75 0f                	jne    1004c5 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  1004b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004b9:	8b 00                	mov    (%eax),%eax
  1004bb:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004be:	8b 45 10             	mov    0x10(%ebp),%eax
  1004c1:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  1004c3:	eb 3f                	jmp    100504 <stab_binsearch+0x154>
        l = *region_right;
  1004c5:	8b 45 10             	mov    0x10(%ebp),%eax
  1004c8:	8b 00                	mov    (%eax),%eax
  1004ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1004cd:	eb 04                	jmp    1004d3 <stab_binsearch+0x123>
  1004cf:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  1004d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004d6:	8b 00                	mov    (%eax),%eax
  1004d8:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  1004db:	7e 1f                	jle    1004fc <stab_binsearch+0x14c>
  1004dd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004e0:	89 d0                	mov    %edx,%eax
  1004e2:	01 c0                	add    %eax,%eax
  1004e4:	01 d0                	add    %edx,%eax
  1004e6:	c1 e0 02             	shl    $0x2,%eax
  1004e9:	89 c2                	mov    %eax,%edx
  1004eb:	8b 45 08             	mov    0x8(%ebp),%eax
  1004ee:	01 d0                	add    %edx,%eax
  1004f0:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1004f4:	0f b6 c0             	movzbl %al,%eax
  1004f7:	39 45 14             	cmp    %eax,0x14(%ebp)
  1004fa:	75 d3                	jne    1004cf <stab_binsearch+0x11f>
        *region_left = l;
  1004fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004ff:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100502:	89 10                	mov    %edx,(%eax)
}
  100504:	90                   	nop
  100505:	c9                   	leave  
  100506:	c3                   	ret    

00100507 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  100507:	55                   	push   %ebp
  100508:	89 e5                	mov    %esp,%ebp
  10050a:	83 ec 38             	sub    $0x38,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  10050d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100510:	c7 00 0c 36 10 00    	movl   $0x10360c,(%eax)
    info->eip_line = 0;
  100516:	8b 45 0c             	mov    0xc(%ebp),%eax
  100519:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100520:	8b 45 0c             	mov    0xc(%ebp),%eax
  100523:	c7 40 08 0c 36 10 00 	movl   $0x10360c,0x8(%eax)
    info->eip_fn_namelen = 9;
  10052a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10052d:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100534:	8b 45 0c             	mov    0xc(%ebp),%eax
  100537:	8b 55 08             	mov    0x8(%ebp),%edx
  10053a:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  10053d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100540:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100547:	c7 45 f4 6c 3e 10 00 	movl   $0x103e6c,-0xc(%ebp)
    stab_end = __STAB_END__;
  10054e:	c7 45 f0 50 bd 10 00 	movl   $0x10bd50,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100555:	c7 45 ec 51 bd 10 00 	movl   $0x10bd51,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  10055c:	c7 45 e8 dc e6 10 00 	movl   $0x10e6dc,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  100563:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100566:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100569:	76 0d                	jbe    100578 <debuginfo_eip+0x71>
  10056b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10056e:	83 e8 01             	sub    $0x1,%eax
  100571:	0f b6 00             	movzbl (%eax),%eax
  100574:	84 c0                	test   %al,%al
  100576:	74 0a                	je     100582 <debuginfo_eip+0x7b>
        return -1;
  100578:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10057d:	e9 85 02 00 00       	jmp    100807 <debuginfo_eip+0x300>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  100582:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  100589:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10058c:	2b 45 f4             	sub    -0xc(%ebp),%eax
  10058f:	c1 f8 02             	sar    $0x2,%eax
  100592:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  100598:	83 e8 01             	sub    $0x1,%eax
  10059b:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  10059e:	ff 75 08             	push   0x8(%ebp)
  1005a1:	6a 64                	push   $0x64
  1005a3:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1005a6:	50                   	push   %eax
  1005a7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1005aa:	50                   	push   %eax
  1005ab:	ff 75 f4             	push   -0xc(%ebp)
  1005ae:	e8 fd fd ff ff       	call   1003b0 <stab_binsearch>
  1005b3:	83 c4 14             	add    $0x14,%esp
    if (lfile == 0)
  1005b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005b9:	85 c0                	test   %eax,%eax
  1005bb:	75 0a                	jne    1005c7 <debuginfo_eip+0xc0>
        return -1;
  1005bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005c2:	e9 40 02 00 00       	jmp    100807 <debuginfo_eip+0x300>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1005c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005ca:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1005cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1005d0:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  1005d3:	ff 75 08             	push   0x8(%ebp)
  1005d6:	6a 24                	push   $0x24
  1005d8:	8d 45 d8             	lea    -0x28(%ebp),%eax
  1005db:	50                   	push   %eax
  1005dc:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1005df:	50                   	push   %eax
  1005e0:	ff 75 f4             	push   -0xc(%ebp)
  1005e3:	e8 c8 fd ff ff       	call   1003b0 <stab_binsearch>
  1005e8:	83 c4 14             	add    $0x14,%esp

    if (lfun <= rfun) {
  1005eb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1005ee:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1005f1:	39 c2                	cmp    %eax,%edx
  1005f3:	7f 78                	jg     10066d <debuginfo_eip+0x166>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  1005f5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1005f8:	89 c2                	mov    %eax,%edx
  1005fa:	89 d0                	mov    %edx,%eax
  1005fc:	01 c0                	add    %eax,%eax
  1005fe:	01 d0                	add    %edx,%eax
  100600:	c1 e0 02             	shl    $0x2,%eax
  100603:	89 c2                	mov    %eax,%edx
  100605:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100608:	01 d0                	add    %edx,%eax
  10060a:	8b 10                	mov    (%eax),%edx
  10060c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10060f:	2b 45 ec             	sub    -0x14(%ebp),%eax
  100612:	39 c2                	cmp    %eax,%edx
  100614:	73 22                	jae    100638 <debuginfo_eip+0x131>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  100616:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100619:	89 c2                	mov    %eax,%edx
  10061b:	89 d0                	mov    %edx,%eax
  10061d:	01 c0                	add    %eax,%eax
  10061f:	01 d0                	add    %edx,%eax
  100621:	c1 e0 02             	shl    $0x2,%eax
  100624:	89 c2                	mov    %eax,%edx
  100626:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100629:	01 d0                	add    %edx,%eax
  10062b:	8b 10                	mov    (%eax),%edx
  10062d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100630:	01 c2                	add    %eax,%edx
  100632:	8b 45 0c             	mov    0xc(%ebp),%eax
  100635:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  100638:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10063b:	89 c2                	mov    %eax,%edx
  10063d:	89 d0                	mov    %edx,%eax
  10063f:	01 c0                	add    %eax,%eax
  100641:	01 d0                	add    %edx,%eax
  100643:	c1 e0 02             	shl    $0x2,%eax
  100646:	89 c2                	mov    %eax,%edx
  100648:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10064b:	01 d0                	add    %edx,%eax
  10064d:	8b 50 08             	mov    0x8(%eax),%edx
  100650:	8b 45 0c             	mov    0xc(%ebp),%eax
  100653:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  100656:	8b 45 0c             	mov    0xc(%ebp),%eax
  100659:	8b 40 10             	mov    0x10(%eax),%eax
  10065c:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  10065f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100662:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  100665:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100668:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10066b:	eb 15                	jmp    100682 <debuginfo_eip+0x17b>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  10066d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100670:	8b 55 08             	mov    0x8(%ebp),%edx
  100673:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  100676:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100679:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  10067c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10067f:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  100682:	8b 45 0c             	mov    0xc(%ebp),%eax
  100685:	8b 40 08             	mov    0x8(%eax),%eax
  100688:	83 ec 08             	sub    $0x8,%esp
  10068b:	6a 3a                	push   $0x3a
  10068d:	50                   	push   %eax
  10068e:	e8 b6 2b 00 00       	call   103249 <strfind>
  100693:	83 c4 10             	add    $0x10,%esp
  100696:	8b 55 0c             	mov    0xc(%ebp),%edx
  100699:	8b 4a 08             	mov    0x8(%edx),%ecx
  10069c:	29 c8                	sub    %ecx,%eax
  10069e:	89 c2                	mov    %eax,%edx
  1006a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006a3:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1006a6:	83 ec 0c             	sub    $0xc,%esp
  1006a9:	ff 75 08             	push   0x8(%ebp)
  1006ac:	6a 44                	push   $0x44
  1006ae:	8d 45 d0             	lea    -0x30(%ebp),%eax
  1006b1:	50                   	push   %eax
  1006b2:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  1006b5:	50                   	push   %eax
  1006b6:	ff 75 f4             	push   -0xc(%ebp)
  1006b9:	e8 f2 fc ff ff       	call   1003b0 <stab_binsearch>
  1006be:	83 c4 20             	add    $0x20,%esp
    if (lline <= rline) {
  1006c1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1006c4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1006c7:	39 c2                	cmp    %eax,%edx
  1006c9:	7f 24                	jg     1006ef <debuginfo_eip+0x1e8>
        info->eip_line = stabs[rline].n_desc;
  1006cb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1006ce:	89 c2                	mov    %eax,%edx
  1006d0:	89 d0                	mov    %edx,%eax
  1006d2:	01 c0                	add    %eax,%eax
  1006d4:	01 d0                	add    %edx,%eax
  1006d6:	c1 e0 02             	shl    $0x2,%eax
  1006d9:	89 c2                	mov    %eax,%edx
  1006db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006de:	01 d0                	add    %edx,%eax
  1006e0:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  1006e4:	0f b7 d0             	movzwl %ax,%edx
  1006e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006ea:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  1006ed:	eb 13                	jmp    100702 <debuginfo_eip+0x1fb>
        return -1;
  1006ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1006f4:	e9 0e 01 00 00       	jmp    100807 <debuginfo_eip+0x300>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  1006f9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1006fc:	83 e8 01             	sub    $0x1,%eax
  1006ff:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
  100702:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100705:	8b 45 e4             	mov    -0x1c(%ebp),%eax
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100708:	39 c2                	cmp    %eax,%edx
  10070a:	7c 56                	jl     100762 <debuginfo_eip+0x25b>
           && stabs[lline].n_type != N_SOL
  10070c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10070f:	89 c2                	mov    %eax,%edx
  100711:	89 d0                	mov    %edx,%eax
  100713:	01 c0                	add    %eax,%eax
  100715:	01 d0                	add    %edx,%eax
  100717:	c1 e0 02             	shl    $0x2,%eax
  10071a:	89 c2                	mov    %eax,%edx
  10071c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10071f:	01 d0                	add    %edx,%eax
  100721:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100725:	3c 84                	cmp    $0x84,%al
  100727:	74 39                	je     100762 <debuginfo_eip+0x25b>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100729:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10072c:	89 c2                	mov    %eax,%edx
  10072e:	89 d0                	mov    %edx,%eax
  100730:	01 c0                	add    %eax,%eax
  100732:	01 d0                	add    %edx,%eax
  100734:	c1 e0 02             	shl    $0x2,%eax
  100737:	89 c2                	mov    %eax,%edx
  100739:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10073c:	01 d0                	add    %edx,%eax
  10073e:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100742:	3c 64                	cmp    $0x64,%al
  100744:	75 b3                	jne    1006f9 <debuginfo_eip+0x1f2>
  100746:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100749:	89 c2                	mov    %eax,%edx
  10074b:	89 d0                	mov    %edx,%eax
  10074d:	01 c0                	add    %eax,%eax
  10074f:	01 d0                	add    %edx,%eax
  100751:	c1 e0 02             	shl    $0x2,%eax
  100754:	89 c2                	mov    %eax,%edx
  100756:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100759:	01 d0                	add    %edx,%eax
  10075b:	8b 40 08             	mov    0x8(%eax),%eax
  10075e:	85 c0                	test   %eax,%eax
  100760:	74 97                	je     1006f9 <debuginfo_eip+0x1f2>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  100762:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100765:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100768:	39 c2                	cmp    %eax,%edx
  10076a:	7c 42                	jl     1007ae <debuginfo_eip+0x2a7>
  10076c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10076f:	89 c2                	mov    %eax,%edx
  100771:	89 d0                	mov    %edx,%eax
  100773:	01 c0                	add    %eax,%eax
  100775:	01 d0                	add    %edx,%eax
  100777:	c1 e0 02             	shl    $0x2,%eax
  10077a:	89 c2                	mov    %eax,%edx
  10077c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10077f:	01 d0                	add    %edx,%eax
  100781:	8b 10                	mov    (%eax),%edx
  100783:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100786:	2b 45 ec             	sub    -0x14(%ebp),%eax
  100789:	39 c2                	cmp    %eax,%edx
  10078b:	73 21                	jae    1007ae <debuginfo_eip+0x2a7>
        info->eip_file = stabstr + stabs[lline].n_strx;
  10078d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100790:	89 c2                	mov    %eax,%edx
  100792:	89 d0                	mov    %edx,%eax
  100794:	01 c0                	add    %eax,%eax
  100796:	01 d0                	add    %edx,%eax
  100798:	c1 e0 02             	shl    $0x2,%eax
  10079b:	89 c2                	mov    %eax,%edx
  10079d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007a0:	01 d0                	add    %edx,%eax
  1007a2:	8b 10                	mov    (%eax),%edx
  1007a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007a7:	01 c2                	add    %eax,%edx
  1007a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007ac:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  1007ae:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1007b1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1007b4:	39 c2                	cmp    %eax,%edx
  1007b6:	7d 4a                	jge    100802 <debuginfo_eip+0x2fb>
        for (lline = lfun + 1;
  1007b8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1007bb:	83 c0 01             	add    $0x1,%eax
  1007be:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1007c1:	eb 18                	jmp    1007db <debuginfo_eip+0x2d4>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  1007c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007c6:	8b 40 14             	mov    0x14(%eax),%eax
  1007c9:	8d 50 01             	lea    0x1(%eax),%edx
  1007cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007cf:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
  1007d2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007d5:	83 c0 01             	add    $0x1,%eax
  1007d8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1007db:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007de:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1007e1:	39 c2                	cmp    %eax,%edx
  1007e3:	7d 1d                	jge    100802 <debuginfo_eip+0x2fb>
  1007e5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007e8:	89 c2                	mov    %eax,%edx
  1007ea:	89 d0                	mov    %edx,%eax
  1007ec:	01 c0                	add    %eax,%eax
  1007ee:	01 d0                	add    %edx,%eax
  1007f0:	c1 e0 02             	shl    $0x2,%eax
  1007f3:	89 c2                	mov    %eax,%edx
  1007f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007f8:	01 d0                	add    %edx,%eax
  1007fa:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1007fe:	3c a0                	cmp    $0xa0,%al
  100800:	74 c1                	je     1007c3 <debuginfo_eip+0x2bc>
        }
    }
    return 0;
  100802:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100807:	c9                   	leave  
  100808:	c3                   	ret    

00100809 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100809:	55                   	push   %ebp
  10080a:	89 e5                	mov    %esp,%ebp
  10080c:	83 ec 08             	sub    $0x8,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  10080f:	83 ec 0c             	sub    $0xc,%esp
  100812:	68 16 36 10 00       	push   $0x103616
  100817:	e8 ef fa ff ff       	call   10030b <cprintf>
  10081c:	83 c4 10             	add    $0x10,%esp
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  10081f:	83 ec 08             	sub    $0x8,%esp
  100822:	68 00 00 10 00       	push   $0x100000
  100827:	68 2f 36 10 00       	push   $0x10362f
  10082c:	e8 da fa ff ff       	call   10030b <cprintf>
  100831:	83 c4 10             	add    $0x10,%esp
    cprintf("  etext  0x%08x (phys)\n", etext);
  100834:	83 ec 08             	sub    $0x8,%esp
  100837:	68 5d 35 10 00       	push   $0x10355d
  10083c:	68 47 36 10 00       	push   $0x103647
  100841:	e8 c5 fa ff ff       	call   10030b <cprintf>
  100846:	83 c4 10             	add    $0x10,%esp
    cprintf("  edata  0x%08x (phys)\n", edata);
  100849:	83 ec 08             	sub    $0x8,%esp
  10084c:	68 16 fa 10 00       	push   $0x10fa16
  100851:	68 5f 36 10 00       	push   $0x10365f
  100856:	e8 b0 fa ff ff       	call   10030b <cprintf>
  10085b:	83 c4 10             	add    $0x10,%esp
    cprintf("  end    0x%08x (phys)\n", end);
  10085e:	83 ec 08             	sub    $0x8,%esp
  100861:	68 68 0d 11 00       	push   $0x110d68
  100866:	68 77 36 10 00       	push   $0x103677
  10086b:	e8 9b fa ff ff       	call   10030b <cprintf>
  100870:	83 c4 10             	add    $0x10,%esp
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  100873:	b8 68 0d 11 00       	mov    $0x110d68,%eax
  100878:	2d 00 00 10 00       	sub    $0x100000,%eax
  10087d:	05 ff 03 00 00       	add    $0x3ff,%eax
  100882:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  100888:	85 c0                	test   %eax,%eax
  10088a:	0f 48 c2             	cmovs  %edx,%eax
  10088d:	c1 f8 0a             	sar    $0xa,%eax
  100890:	83 ec 08             	sub    $0x8,%esp
  100893:	50                   	push   %eax
  100894:	68 90 36 10 00       	push   $0x103690
  100899:	e8 6d fa ff ff       	call   10030b <cprintf>
  10089e:	83 c4 10             	add    $0x10,%esp
}
  1008a1:	90                   	nop
  1008a2:	c9                   	leave  
  1008a3:	c3                   	ret    

001008a4 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  1008a4:	55                   	push   %ebp
  1008a5:	89 e5                	mov    %esp,%ebp
  1008a7:	81 ec 28 01 00 00    	sub    $0x128,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  1008ad:	83 ec 08             	sub    $0x8,%esp
  1008b0:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1008b3:	50                   	push   %eax
  1008b4:	ff 75 08             	push   0x8(%ebp)
  1008b7:	e8 4b fc ff ff       	call   100507 <debuginfo_eip>
  1008bc:	83 c4 10             	add    $0x10,%esp
  1008bf:	85 c0                	test   %eax,%eax
  1008c1:	74 15                	je     1008d8 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  1008c3:	83 ec 08             	sub    $0x8,%esp
  1008c6:	ff 75 08             	push   0x8(%ebp)
  1008c9:	68 ba 36 10 00       	push   $0x1036ba
  1008ce:	e8 38 fa ff ff       	call   10030b <cprintf>
  1008d3:	83 c4 10             	add    $0x10,%esp
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  1008d6:	eb 65                	jmp    10093d <print_debuginfo+0x99>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1008d8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1008df:	eb 1c                	jmp    1008fd <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  1008e1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1008e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008e7:	01 d0                	add    %edx,%eax
  1008e9:	0f b6 00             	movzbl (%eax),%eax
  1008ec:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  1008f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1008f5:	01 ca                	add    %ecx,%edx
  1008f7:	88 02                	mov    %al,(%edx)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1008f9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1008fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100900:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  100903:	7c dc                	jl     1008e1 <print_debuginfo+0x3d>
        fnname[j] = '\0';
  100905:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  10090b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10090e:	01 d0                	add    %edx,%eax
  100910:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
  100913:	8b 55 ec             	mov    -0x14(%ebp),%edx
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100916:	8b 45 08             	mov    0x8(%ebp),%eax
  100919:	29 d0                	sub    %edx,%eax
  10091b:	89 c1                	mov    %eax,%ecx
  10091d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100920:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100923:	83 ec 0c             	sub    $0xc,%esp
  100926:	51                   	push   %ecx
  100927:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  10092d:	51                   	push   %ecx
  10092e:	52                   	push   %edx
  10092f:	50                   	push   %eax
  100930:	68 d6 36 10 00       	push   $0x1036d6
  100935:	e8 d1 f9 ff ff       	call   10030b <cprintf>
  10093a:	83 c4 20             	add    $0x20,%esp
}
  10093d:	90                   	nop
  10093e:	c9                   	leave  
  10093f:	c3                   	ret    

00100940 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100940:	55                   	push   %ebp
  100941:	89 e5                	mov    %esp,%ebp
  100943:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100946:	8b 45 04             	mov    0x4(%ebp),%eax
  100949:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  10094c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10094f:	c9                   	leave  
  100950:	c3                   	ret    

00100951 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100951:	55                   	push   %ebp
  100952:	89 e5                	mov    %esp,%ebp
  100954:	83 ec 28             	sub    $0x28,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100957:	89 e8                	mov    %ebp,%eax
  100959:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  10095c:	8b 45 e0             	mov    -0x20(%ebp),%eax
     /* LAB1 YOUR CODE : STEP 1 */
     uint32_t ebp = read_ebp();// (1) call read_ebp() to get the value of ebp. the type is (uint32_t);
  10095f:	89 45 f4             	mov    %eax,-0xc(%ebp)
     uint32_t eip = read_eip();// (2) call read_eip() to get the value of eip. the type is (uint32_t);
  100962:	e8 d9 ff ff ff       	call   100940 <read_eip>
  100967:	89 45 f0             	mov    %eax,-0x10(%ebp)

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {// (3) from 0 .. STACKFRAME_DEPTH
  10096a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  100971:	e9 8d 00 00 00       	jmp    100a03 <print_stackframe+0xb2>
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);//    (3.1) printf value of ebp, eip
  100976:	83 ec 04             	sub    $0x4,%esp
  100979:	ff 75 f0             	push   -0x10(%ebp)
  10097c:	ff 75 f4             	push   -0xc(%ebp)
  10097f:	68 e8 36 10 00       	push   $0x1036e8
  100984:	e8 82 f9 ff ff       	call   10030b <cprintf>
  100989:	83 c4 10             	add    $0x10,%esp
        uint32_t *args = (uint32_t *)ebp + 2;
  10098c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10098f:	83 c0 08             	add    $0x8,%eax
  100992:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (j = 0; j < 4; j ++) {
  100995:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  10099c:	eb 26                	jmp    1009c4 <print_stackframe+0x73>
            cprintf("0x%08x ", args[j]);
  10099e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1009a1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1009a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1009ab:	01 d0                	add    %edx,%eax
  1009ad:	8b 00                	mov    (%eax),%eax
  1009af:	83 ec 08             	sub    $0x8,%esp
  1009b2:	50                   	push   %eax
  1009b3:	68 04 37 10 00       	push   $0x103704
  1009b8:	e8 4e f9 ff ff       	call   10030b <cprintf>
  1009bd:	83 c4 10             	add    $0x10,%esp
        for (j = 0; j < 4; j ++) {
  1009c0:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  1009c4:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  1009c8:	7e d4                	jle    10099e <print_stackframe+0x4d>
        }//    (3.2) (uint32_t)calling arguments [0..4] = the contents in address (uint32_t)ebp +2 [0..4]
        cprintf("\n");//    (3.3) cprintf("\n");
  1009ca:	83 ec 0c             	sub    $0xc,%esp
  1009cd:	68 0c 37 10 00       	push   $0x10370c
  1009d2:	e8 34 f9 ff ff       	call   10030b <cprintf>
  1009d7:	83 c4 10             	add    $0x10,%esp
        print_debuginfo(eip - 1);//    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
  1009da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1009dd:	83 e8 01             	sub    $0x1,%eax
  1009e0:	83 ec 0c             	sub    $0xc,%esp
  1009e3:	50                   	push   %eax
  1009e4:	e8 bb fe ff ff       	call   1008a4 <print_debuginfo>
  1009e9:	83 c4 10             	add    $0x10,%esp
        eip = ((uint32_t *)ebp)[1];
  1009ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009ef:	83 c0 04             	add    $0x4,%eax
  1009f2:	8b 00                	mov    (%eax),%eax
  1009f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];//	(3.5) popup a calling stackframe
  1009f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009fa:	8b 00                	mov    (%eax),%eax
  1009fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {// (3) from 0 .. STACKFRAME_DEPTH
  1009ff:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100a03:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100a07:	74 0a                	je     100a13 <print_stackframe+0xc2>
  100a09:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100a0d:	0f 8e 63 ff ff ff    	jle    100976 <print_stackframe+0x25>
      	//	NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      	//	the calling funciton's ebp = ss:[ebp]
    }
}
  100a13:	90                   	nop
  100a14:	c9                   	leave  
  100a15:	c3                   	ret    

00100a16 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a16:	55                   	push   %ebp
  100a17:	89 e5                	mov    %esp,%ebp
  100a19:	83 ec 18             	sub    $0x18,%esp
    int argc = 0;
  100a1c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a23:	eb 0c                	jmp    100a31 <parse+0x1b>
            *buf ++ = '\0';
  100a25:	8b 45 08             	mov    0x8(%ebp),%eax
  100a28:	8d 50 01             	lea    0x1(%eax),%edx
  100a2b:	89 55 08             	mov    %edx,0x8(%ebp)
  100a2e:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a31:	8b 45 08             	mov    0x8(%ebp),%eax
  100a34:	0f b6 00             	movzbl (%eax),%eax
  100a37:	84 c0                	test   %al,%al
  100a39:	74 1e                	je     100a59 <parse+0x43>
  100a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  100a3e:	0f b6 00             	movzbl (%eax),%eax
  100a41:	0f be c0             	movsbl %al,%eax
  100a44:	83 ec 08             	sub    $0x8,%esp
  100a47:	50                   	push   %eax
  100a48:	68 90 37 10 00       	push   $0x103790
  100a4d:	e8 c4 27 00 00       	call   103216 <strchr>
  100a52:	83 c4 10             	add    $0x10,%esp
  100a55:	85 c0                	test   %eax,%eax
  100a57:	75 cc                	jne    100a25 <parse+0xf>
        }
        if (*buf == '\0') {
  100a59:	8b 45 08             	mov    0x8(%ebp),%eax
  100a5c:	0f b6 00             	movzbl (%eax),%eax
  100a5f:	84 c0                	test   %al,%al
  100a61:	74 65                	je     100ac8 <parse+0xb2>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100a63:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100a67:	75 12                	jne    100a7b <parse+0x65>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100a69:	83 ec 08             	sub    $0x8,%esp
  100a6c:	6a 10                	push   $0x10
  100a6e:	68 95 37 10 00       	push   $0x103795
  100a73:	e8 93 f8 ff ff       	call   10030b <cprintf>
  100a78:	83 c4 10             	add    $0x10,%esp
        }
        argv[argc ++] = buf;
  100a7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a7e:	8d 50 01             	lea    0x1(%eax),%edx
  100a81:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100a84:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100a8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  100a8e:	01 c2                	add    %eax,%edx
  100a90:	8b 45 08             	mov    0x8(%ebp),%eax
  100a93:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100a95:	eb 04                	jmp    100a9b <parse+0x85>
            buf ++;
  100a97:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  100a9e:	0f b6 00             	movzbl (%eax),%eax
  100aa1:	84 c0                	test   %al,%al
  100aa3:	74 8c                	je     100a31 <parse+0x1b>
  100aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  100aa8:	0f b6 00             	movzbl (%eax),%eax
  100aab:	0f be c0             	movsbl %al,%eax
  100aae:	83 ec 08             	sub    $0x8,%esp
  100ab1:	50                   	push   %eax
  100ab2:	68 90 37 10 00       	push   $0x103790
  100ab7:	e8 5a 27 00 00       	call   103216 <strchr>
  100abc:	83 c4 10             	add    $0x10,%esp
  100abf:	85 c0                	test   %eax,%eax
  100ac1:	74 d4                	je     100a97 <parse+0x81>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100ac3:	e9 69 ff ff ff       	jmp    100a31 <parse+0x1b>
            break;
  100ac8:	90                   	nop
        }
    }
    return argc;
  100ac9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100acc:	c9                   	leave  
  100acd:	c3                   	ret    

00100ace <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100ace:	55                   	push   %ebp
  100acf:	89 e5                	mov    %esp,%ebp
  100ad1:	83 ec 58             	sub    $0x58,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100ad4:	83 ec 08             	sub    $0x8,%esp
  100ad7:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100ada:	50                   	push   %eax
  100adb:	ff 75 08             	push   0x8(%ebp)
  100ade:	e8 33 ff ff ff       	call   100a16 <parse>
  100ae3:	83 c4 10             	add    $0x10,%esp
  100ae6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100ae9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100aed:	75 0a                	jne    100af9 <runcmd+0x2b>
        return 0;
  100aef:	b8 00 00 00 00       	mov    $0x0,%eax
  100af4:	e9 83 00 00 00       	jmp    100b7c <runcmd+0xae>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100af9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b00:	eb 59                	jmp    100b5b <runcmd+0x8d>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b02:	8b 55 b0             	mov    -0x50(%ebp),%edx
  100b05:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  100b08:	89 c8                	mov    %ecx,%eax
  100b0a:	01 c0                	add    %eax,%eax
  100b0c:	01 c8                	add    %ecx,%eax
  100b0e:	c1 e0 02             	shl    $0x2,%eax
  100b11:	05 00 f0 10 00       	add    $0x10f000,%eax
  100b16:	8b 00                	mov    (%eax),%eax
  100b18:	83 ec 08             	sub    $0x8,%esp
  100b1b:	52                   	push   %edx
  100b1c:	50                   	push   %eax
  100b1d:	e8 55 26 00 00       	call   103177 <strcmp>
  100b22:	83 c4 10             	add    $0x10,%esp
  100b25:	85 c0                	test   %eax,%eax
  100b27:	75 2e                	jne    100b57 <runcmd+0x89>
            return commands[i].func(argc - 1, argv + 1, tf);
  100b29:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b2c:	89 d0                	mov    %edx,%eax
  100b2e:	01 c0                	add    %eax,%eax
  100b30:	01 d0                	add    %edx,%eax
  100b32:	c1 e0 02             	shl    $0x2,%eax
  100b35:	05 08 f0 10 00       	add    $0x10f008,%eax
  100b3a:	8b 10                	mov    (%eax),%edx
  100b3c:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b3f:	83 c0 04             	add    $0x4,%eax
  100b42:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100b45:	83 e9 01             	sub    $0x1,%ecx
  100b48:	83 ec 04             	sub    $0x4,%esp
  100b4b:	ff 75 0c             	push   0xc(%ebp)
  100b4e:	50                   	push   %eax
  100b4f:	51                   	push   %ecx
  100b50:	ff d2                	call   *%edx
  100b52:	83 c4 10             	add    $0x10,%esp
  100b55:	eb 25                	jmp    100b7c <runcmd+0xae>
    for (i = 0; i < NCOMMANDS; i ++) {
  100b57:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100b5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b5e:	83 f8 02             	cmp    $0x2,%eax
  100b61:	76 9f                	jbe    100b02 <runcmd+0x34>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100b63:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100b66:	83 ec 08             	sub    $0x8,%esp
  100b69:	50                   	push   %eax
  100b6a:	68 b3 37 10 00       	push   $0x1037b3
  100b6f:	e8 97 f7 ff ff       	call   10030b <cprintf>
  100b74:	83 c4 10             	add    $0x10,%esp
    return 0;
  100b77:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100b7c:	c9                   	leave  
  100b7d:	c3                   	ret    

00100b7e <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100b7e:	55                   	push   %ebp
  100b7f:	89 e5                	mov    %esp,%ebp
  100b81:	83 ec 18             	sub    $0x18,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100b84:	83 ec 0c             	sub    $0xc,%esp
  100b87:	68 cc 37 10 00       	push   $0x1037cc
  100b8c:	e8 7a f7 ff ff       	call   10030b <cprintf>
  100b91:	83 c4 10             	add    $0x10,%esp
    cprintf("Type 'help' for a list of commands.\n");
  100b94:	83 ec 0c             	sub    $0xc,%esp
  100b97:	68 f4 37 10 00       	push   $0x1037f4
  100b9c:	e8 6a f7 ff ff       	call   10030b <cprintf>
  100ba1:	83 c4 10             	add    $0x10,%esp

    if (tf != NULL) {
  100ba4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100ba8:	74 0e                	je     100bb8 <kmonitor+0x3a>
        print_trapframe(tf);
  100baa:	83 ec 0c             	sub    $0xc,%esp
  100bad:	ff 75 08             	push   0x8(%ebp)
  100bb0:	e8 3d 0e 00 00       	call   1019f2 <print_trapframe>
  100bb5:	83 c4 10             	add    $0x10,%esp
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100bb8:	83 ec 0c             	sub    $0xc,%esp
  100bbb:	68 19 38 10 00       	push   $0x103819
  100bc0:	e8 37 f6 ff ff       	call   1001fc <readline>
  100bc5:	83 c4 10             	add    $0x10,%esp
  100bc8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100bcb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100bcf:	74 e7                	je     100bb8 <kmonitor+0x3a>
            if (runcmd(buf, tf) < 0) {
  100bd1:	83 ec 08             	sub    $0x8,%esp
  100bd4:	ff 75 08             	push   0x8(%ebp)
  100bd7:	ff 75 f4             	push   -0xc(%ebp)
  100bda:	e8 ef fe ff ff       	call   100ace <runcmd>
  100bdf:	83 c4 10             	add    $0x10,%esp
  100be2:	85 c0                	test   %eax,%eax
  100be4:	78 02                	js     100be8 <kmonitor+0x6a>
        if ((buf = readline("K> ")) != NULL) {
  100be6:	eb d0                	jmp    100bb8 <kmonitor+0x3a>
                break;
  100be8:	90                   	nop
            }
        }
    }
}
  100be9:	90                   	nop
  100bea:	c9                   	leave  
  100beb:	c3                   	ret    

00100bec <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100bec:	55                   	push   %ebp
  100bed:	89 e5                	mov    %esp,%ebp
  100bef:	83 ec 18             	sub    $0x18,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100bf2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100bf9:	eb 3c                	jmp    100c37 <mon_help+0x4b>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100bfb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100bfe:	89 d0                	mov    %edx,%eax
  100c00:	01 c0                	add    %eax,%eax
  100c02:	01 d0                	add    %edx,%eax
  100c04:	c1 e0 02             	shl    $0x2,%eax
  100c07:	05 04 f0 10 00       	add    $0x10f004,%eax
  100c0c:	8b 10                	mov    (%eax),%edx
  100c0e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  100c11:	89 c8                	mov    %ecx,%eax
  100c13:	01 c0                	add    %eax,%eax
  100c15:	01 c8                	add    %ecx,%eax
  100c17:	c1 e0 02             	shl    $0x2,%eax
  100c1a:	05 00 f0 10 00       	add    $0x10f000,%eax
  100c1f:	8b 00                	mov    (%eax),%eax
  100c21:	83 ec 04             	sub    $0x4,%esp
  100c24:	52                   	push   %edx
  100c25:	50                   	push   %eax
  100c26:	68 1d 38 10 00       	push   $0x10381d
  100c2b:	e8 db f6 ff ff       	call   10030b <cprintf>
  100c30:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < NCOMMANDS; i ++) {
  100c33:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c3a:	83 f8 02             	cmp    $0x2,%eax
  100c3d:	76 bc                	jbe    100bfb <mon_help+0xf>
    }
    return 0;
  100c3f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c44:	c9                   	leave  
  100c45:	c3                   	ret    

00100c46 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100c46:	55                   	push   %ebp
  100c47:	89 e5                	mov    %esp,%ebp
  100c49:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100c4c:	e8 b8 fb ff ff       	call   100809 <print_kerninfo>
    return 0;
  100c51:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c56:	c9                   	leave  
  100c57:	c3                   	ret    

00100c58 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100c58:	55                   	push   %ebp
  100c59:	89 e5                	mov    %esp,%ebp
  100c5b:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100c5e:	e8 ee fc ff ff       	call   100951 <print_stackframe>
    return 0;
  100c63:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c68:	c9                   	leave  
  100c69:	c3                   	ret    

00100c6a <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100c6a:	55                   	push   %ebp
  100c6b:	89 e5                	mov    %esp,%ebp
  100c6d:	83 ec 18             	sub    $0x18,%esp
    if (is_panic) {
  100c70:	a1 40 fe 10 00       	mov    0x10fe40,%eax
  100c75:	85 c0                	test   %eax,%eax
  100c77:	75 5f                	jne    100cd8 <__panic+0x6e>
        goto panic_dead;
    }
    is_panic = 1;
  100c79:	c7 05 40 fe 10 00 01 	movl   $0x1,0x10fe40
  100c80:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100c83:	8d 45 14             	lea    0x14(%ebp),%eax
  100c86:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100c89:	83 ec 04             	sub    $0x4,%esp
  100c8c:	ff 75 0c             	push   0xc(%ebp)
  100c8f:	ff 75 08             	push   0x8(%ebp)
  100c92:	68 26 38 10 00       	push   $0x103826
  100c97:	e8 6f f6 ff ff       	call   10030b <cprintf>
  100c9c:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
  100c9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ca2:	83 ec 08             	sub    $0x8,%esp
  100ca5:	50                   	push   %eax
  100ca6:	ff 75 10             	push   0x10(%ebp)
  100ca9:	e8 34 f6 ff ff       	call   1002e2 <vcprintf>
  100cae:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
  100cb1:	83 ec 0c             	sub    $0xc,%esp
  100cb4:	68 42 38 10 00       	push   $0x103842
  100cb9:	e8 4d f6 ff ff       	call   10030b <cprintf>
  100cbe:	83 c4 10             	add    $0x10,%esp
    
    cprintf("stack trackback:\n");
  100cc1:	83 ec 0c             	sub    $0xc,%esp
  100cc4:	68 44 38 10 00       	push   $0x103844
  100cc9:	e8 3d f6 ff ff       	call   10030b <cprintf>
  100cce:	83 c4 10             	add    $0x10,%esp
    print_stackframe();
  100cd1:	e8 7b fc ff ff       	call   100951 <print_stackframe>
  100cd6:	eb 01                	jmp    100cd9 <__panic+0x6f>
        goto panic_dead;
  100cd8:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
  100cd9:	e8 64 09 00 00       	call   101642 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100cde:	83 ec 0c             	sub    $0xc,%esp
  100ce1:	6a 00                	push   $0x0
  100ce3:	e8 96 fe ff ff       	call   100b7e <kmonitor>
  100ce8:	83 c4 10             	add    $0x10,%esp
  100ceb:	eb f1                	jmp    100cde <__panic+0x74>

00100ced <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100ced:	55                   	push   %ebp
  100cee:	89 e5                	mov    %esp,%ebp
  100cf0:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    va_start(ap, fmt);
  100cf3:	8d 45 14             	lea    0x14(%ebp),%eax
  100cf6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100cf9:	83 ec 04             	sub    $0x4,%esp
  100cfc:	ff 75 0c             	push   0xc(%ebp)
  100cff:	ff 75 08             	push   0x8(%ebp)
  100d02:	68 56 38 10 00       	push   $0x103856
  100d07:	e8 ff f5 ff ff       	call   10030b <cprintf>
  100d0c:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
  100d0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d12:	83 ec 08             	sub    $0x8,%esp
  100d15:	50                   	push   %eax
  100d16:	ff 75 10             	push   0x10(%ebp)
  100d19:	e8 c4 f5 ff ff       	call   1002e2 <vcprintf>
  100d1e:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
  100d21:	83 ec 0c             	sub    $0xc,%esp
  100d24:	68 42 38 10 00       	push   $0x103842
  100d29:	e8 dd f5 ff ff       	call   10030b <cprintf>
  100d2e:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
  100d31:	90                   	nop
  100d32:	c9                   	leave  
  100d33:	c3                   	ret    

00100d34 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100d34:	55                   	push   %ebp
  100d35:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100d37:	a1 40 fe 10 00       	mov    0x10fe40,%eax
}
  100d3c:	5d                   	pop    %ebp
  100d3d:	c3                   	ret    

00100d3e <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d3e:	55                   	push   %ebp
  100d3f:	89 e5                	mov    %esp,%ebp
  100d41:	83 ec 18             	sub    $0x18,%esp
  100d44:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
  100d4a:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100d4e:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100d52:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100d56:	ee                   	out    %al,(%dx)
}
  100d57:	90                   	nop
  100d58:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100d5e:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100d62:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100d66:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100d6a:	ee                   	out    %al,(%dx)
}
  100d6b:	90                   	nop
  100d6c:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
  100d72:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100d76:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100d7a:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100d7e:	ee                   	out    %al,(%dx)
}
  100d7f:	90                   	nop
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100d80:	c7 05 44 fe 10 00 00 	movl   $0x0,0x10fe44
  100d87:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100d8a:	83 ec 0c             	sub    $0xc,%esp
  100d8d:	68 74 38 10 00       	push   $0x103874
  100d92:	e8 74 f5 ff ff       	call   10030b <cprintf>
  100d97:	83 c4 10             	add    $0x10,%esp
    pic_enable(IRQ_TIMER);
  100d9a:	83 ec 0c             	sub    $0xc,%esp
  100d9d:	6a 00                	push   $0x0
  100d9f:	e8 01 09 00 00       	call   1016a5 <pic_enable>
  100da4:	83 c4 10             	add    $0x10,%esp
}
  100da7:	90                   	nop
  100da8:	c9                   	leave  
  100da9:	c3                   	ret    

00100daa <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100daa:	55                   	push   %ebp
  100dab:	89 e5                	mov    %esp,%ebp
  100dad:	83 ec 10             	sub    $0x10,%esp
  100db0:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100db6:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100dba:	89 c2                	mov    %eax,%edx
  100dbc:	ec                   	in     (%dx),%al
  100dbd:	88 45 f1             	mov    %al,-0xf(%ebp)
  100dc0:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100dc6:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100dca:	89 c2                	mov    %eax,%edx
  100dcc:	ec                   	in     (%dx),%al
  100dcd:	88 45 f5             	mov    %al,-0xb(%ebp)
  100dd0:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100dd6:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100dda:	89 c2                	mov    %eax,%edx
  100ddc:	ec                   	in     (%dx),%al
  100ddd:	88 45 f9             	mov    %al,-0x7(%ebp)
  100de0:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
  100de6:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100dea:	89 c2                	mov    %eax,%edx
  100dec:	ec                   	in     (%dx),%al
  100ded:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100df0:	90                   	nop
  100df1:	c9                   	leave  
  100df2:	c3                   	ret    

00100df3 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100df3:	55                   	push   %ebp
  100df4:	89 e5                	mov    %esp,%ebp
  100df6:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;
  100df9:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;
  100e00:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e03:	0f b7 00             	movzwl (%eax),%eax
  100e06:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100e0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e0d:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100e12:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e15:	0f b7 00             	movzwl (%eax),%eax
  100e18:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e1c:	74 12                	je     100e30 <cga_init+0x3d>
        cp = (uint16_t*)MONO_BUF;
  100e1e:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100e25:	66 c7 05 66 fe 10 00 	movw   $0x3b4,0x10fe66
  100e2c:	b4 03 
  100e2e:	eb 13                	jmp    100e43 <cga_init+0x50>
    } else {
        *cp = was;
  100e30:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e33:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100e37:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100e3a:	66 c7 05 66 fe 10 00 	movw   $0x3d4,0x10fe66
  100e41:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100e43:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  100e4a:	0f b7 c0             	movzwl %ax,%eax
  100e4d:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  100e51:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e55:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100e59:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100e5d:	ee                   	out    %al,(%dx)
}
  100e5e:	90                   	nop
    pos = inb(addr_6845 + 1) << 8;
  100e5f:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  100e66:	83 c0 01             	add    $0x1,%eax
  100e69:	0f b7 c0             	movzwl %ax,%eax
  100e6c:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e70:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
  100e74:	89 c2                	mov    %eax,%edx
  100e76:	ec                   	in     (%dx),%al
  100e77:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
  100e7a:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100e7e:	0f b6 c0             	movzbl %al,%eax
  100e81:	c1 e0 08             	shl    $0x8,%eax
  100e84:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100e87:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  100e8e:	0f b7 c0             	movzwl %ax,%eax
  100e91:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  100e95:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e99:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100e9d:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100ea1:	ee                   	out    %al,(%dx)
}
  100ea2:	90                   	nop
    pos |= inb(addr_6845 + 1);
  100ea3:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  100eaa:	83 c0 01             	add    $0x1,%eax
  100ead:	0f b7 c0             	movzwl %ax,%eax
  100eb0:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100eb4:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100eb8:	89 c2                	mov    %eax,%edx
  100eba:	ec                   	in     (%dx),%al
  100ebb:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
  100ebe:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100ec2:	0f b6 c0             	movzbl %al,%eax
  100ec5:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100ec8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ecb:	a3 60 fe 10 00       	mov    %eax,0x10fe60
    crt_pos = pos;
  100ed0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ed3:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
}
  100ed9:	90                   	nop
  100eda:	c9                   	leave  
  100edb:	c3                   	ret    

00100edc <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100edc:	55                   	push   %ebp
  100edd:	89 e5                	mov    %esp,%ebp
  100edf:	83 ec 38             	sub    $0x38,%esp
  100ee2:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
  100ee8:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100eec:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  100ef0:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  100ef4:	ee                   	out    %al,(%dx)
}
  100ef5:	90                   	nop
  100ef6:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
  100efc:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f00:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  100f04:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  100f08:	ee                   	out    %al,(%dx)
}
  100f09:	90                   	nop
  100f0a:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
  100f10:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f14:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  100f18:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  100f1c:	ee                   	out    %al,(%dx)
}
  100f1d:	90                   	nop
  100f1e:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100f24:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f28:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100f2c:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100f30:	ee                   	out    %al,(%dx)
}
  100f31:	90                   	nop
  100f32:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
  100f38:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f3c:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100f40:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100f44:	ee                   	out    %al,(%dx)
}
  100f45:	90                   	nop
  100f46:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
  100f4c:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f50:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f54:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100f58:	ee                   	out    %al,(%dx)
}
  100f59:	90                   	nop
  100f5a:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f60:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f64:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f68:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f6c:	ee                   	out    %al,(%dx)
}
  100f6d:	90                   	nop
  100f6e:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f74:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100f78:	89 c2                	mov    %eax,%edx
  100f7a:	ec                   	in     (%dx),%al
  100f7b:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100f7e:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100f82:	3c ff                	cmp    $0xff,%al
  100f84:	0f 95 c0             	setne  %al
  100f87:	0f b6 c0             	movzbl %al,%eax
  100f8a:	a3 68 fe 10 00       	mov    %eax,0x10fe68
  100f8f:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f95:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100f99:	89 c2                	mov    %eax,%edx
  100f9b:	ec                   	in     (%dx),%al
  100f9c:	88 45 f1             	mov    %al,-0xf(%ebp)
  100f9f:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  100fa5:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100fa9:	89 c2                	mov    %eax,%edx
  100fab:	ec                   	in     (%dx),%al
  100fac:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100faf:	a1 68 fe 10 00       	mov    0x10fe68,%eax
  100fb4:	85 c0                	test   %eax,%eax
  100fb6:	74 0d                	je     100fc5 <serial_init+0xe9>
        pic_enable(IRQ_COM1);
  100fb8:	83 ec 0c             	sub    $0xc,%esp
  100fbb:	6a 04                	push   $0x4
  100fbd:	e8 e3 06 00 00       	call   1016a5 <pic_enable>
  100fc2:	83 c4 10             	add    $0x10,%esp
    }
}
  100fc5:	90                   	nop
  100fc6:	c9                   	leave  
  100fc7:	c3                   	ret    

00100fc8 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  100fc8:	55                   	push   %ebp
  100fc9:	89 e5                	mov    %esp,%ebp
  100fcb:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100fd5:	eb 09                	jmp    100fe0 <lpt_putc_sub+0x18>
        delay();
  100fd7:	e8 ce fd ff ff       	call   100daa <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fdc:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  100fe0:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  100fe6:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100fea:	89 c2                	mov    %eax,%edx
  100fec:	ec                   	in     (%dx),%al
  100fed:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  100ff0:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  100ff4:	84 c0                	test   %al,%al
  100ff6:	78 09                	js     101001 <lpt_putc_sub+0x39>
  100ff8:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  100fff:	7e d6                	jle    100fd7 <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
  101001:	8b 45 08             	mov    0x8(%ebp),%eax
  101004:	0f b6 c0             	movzbl %al,%eax
  101007:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
  10100d:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101010:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101014:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101018:	ee                   	out    %al,(%dx)
}
  101019:	90                   	nop
  10101a:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  101020:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101024:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101028:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10102c:	ee                   	out    %al,(%dx)
}
  10102d:	90                   	nop
  10102e:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  101034:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101038:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10103c:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101040:	ee                   	out    %al,(%dx)
}
  101041:	90                   	nop
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  101042:	90                   	nop
  101043:	c9                   	leave  
  101044:	c3                   	ret    

00101045 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  101045:	55                   	push   %ebp
  101046:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
  101048:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  10104c:	74 0d                	je     10105b <lpt_putc+0x16>
        lpt_putc_sub(c);
  10104e:	ff 75 08             	push   0x8(%ebp)
  101051:	e8 72 ff ff ff       	call   100fc8 <lpt_putc_sub>
  101056:	83 c4 04             	add    $0x4,%esp
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  101059:	eb 1e                	jmp    101079 <lpt_putc+0x34>
        lpt_putc_sub('\b');
  10105b:	6a 08                	push   $0x8
  10105d:	e8 66 ff ff ff       	call   100fc8 <lpt_putc_sub>
  101062:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub(' ');
  101065:	6a 20                	push   $0x20
  101067:	e8 5c ff ff ff       	call   100fc8 <lpt_putc_sub>
  10106c:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub('\b');
  10106f:	6a 08                	push   $0x8
  101071:	e8 52 ff ff ff       	call   100fc8 <lpt_putc_sub>
  101076:	83 c4 04             	add    $0x4,%esp
}
  101079:	90                   	nop
  10107a:	c9                   	leave  
  10107b:	c3                   	ret    

0010107c <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  10107c:	55                   	push   %ebp
  10107d:	89 e5                	mov    %esp,%ebp
  10107f:	53                   	push   %ebx
  101080:	83 ec 24             	sub    $0x24,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  101083:	8b 45 08             	mov    0x8(%ebp),%eax
  101086:	b0 00                	mov    $0x0,%al
  101088:	85 c0                	test   %eax,%eax
  10108a:	75 07                	jne    101093 <cga_putc+0x17>
        c |= 0x0700;
  10108c:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  101093:	8b 45 08             	mov    0x8(%ebp),%eax
  101096:	0f b6 c0             	movzbl %al,%eax
  101099:	83 f8 0d             	cmp    $0xd,%eax
  10109c:	74 6b                	je     101109 <cga_putc+0x8d>
  10109e:	83 f8 0d             	cmp    $0xd,%eax
  1010a1:	0f 8f 9c 00 00 00    	jg     101143 <cga_putc+0xc7>
  1010a7:	83 f8 08             	cmp    $0x8,%eax
  1010aa:	74 0a                	je     1010b6 <cga_putc+0x3a>
  1010ac:	83 f8 0a             	cmp    $0xa,%eax
  1010af:	74 48                	je     1010f9 <cga_putc+0x7d>
  1010b1:	e9 8d 00 00 00       	jmp    101143 <cga_putc+0xc7>
    case '\b':
        if (crt_pos > 0) {
  1010b6:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  1010bd:	66 85 c0             	test   %ax,%ax
  1010c0:	0f 84 a3 00 00 00    	je     101169 <cga_putc+0xed>
            crt_pos --;
  1010c6:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  1010cd:	83 e8 01             	sub    $0x1,%eax
  1010d0:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  1010d6:	8b 45 08             	mov    0x8(%ebp),%eax
  1010d9:	b0 00                	mov    $0x0,%al
  1010db:	83 c8 20             	or     $0x20,%eax
  1010de:	89 c2                	mov    %eax,%edx
  1010e0:	8b 0d 60 fe 10 00    	mov    0x10fe60,%ecx
  1010e6:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  1010ed:	0f b7 c0             	movzwl %ax,%eax
  1010f0:	01 c0                	add    %eax,%eax
  1010f2:	01 c8                	add    %ecx,%eax
  1010f4:	66 89 10             	mov    %dx,(%eax)
        }
        break;
  1010f7:	eb 70                	jmp    101169 <cga_putc+0xed>
    case '\n':
        crt_pos += CRT_COLS;
  1010f9:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  101100:	83 c0 50             	add    $0x50,%eax
  101103:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  101109:	0f b7 1d 64 fe 10 00 	movzwl 0x10fe64,%ebx
  101110:	0f b7 0d 64 fe 10 00 	movzwl 0x10fe64,%ecx
  101117:	0f b7 c1             	movzwl %cx,%eax
  10111a:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  101120:	c1 e8 10             	shr    $0x10,%eax
  101123:	89 c2                	mov    %eax,%edx
  101125:	66 c1 ea 06          	shr    $0x6,%dx
  101129:	89 d0                	mov    %edx,%eax
  10112b:	c1 e0 02             	shl    $0x2,%eax
  10112e:	01 d0                	add    %edx,%eax
  101130:	c1 e0 04             	shl    $0x4,%eax
  101133:	29 c1                	sub    %eax,%ecx
  101135:	89 ca                	mov    %ecx,%edx
  101137:	89 d8                	mov    %ebx,%eax
  101139:	29 d0                	sub    %edx,%eax
  10113b:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
        break;
  101141:	eb 27                	jmp    10116a <cga_putc+0xee>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  101143:	8b 0d 60 fe 10 00    	mov    0x10fe60,%ecx
  101149:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  101150:	8d 50 01             	lea    0x1(%eax),%edx
  101153:	66 89 15 64 fe 10 00 	mov    %dx,0x10fe64
  10115a:	0f b7 c0             	movzwl %ax,%eax
  10115d:	01 c0                	add    %eax,%eax
  10115f:	01 c8                	add    %ecx,%eax
  101161:	8b 55 08             	mov    0x8(%ebp),%edx
  101164:	66 89 10             	mov    %dx,(%eax)
        break;
  101167:	eb 01                	jmp    10116a <cga_putc+0xee>
        break;
  101169:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  10116a:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  101171:	66 3d cf 07          	cmp    $0x7cf,%ax
  101175:	76 5a                	jbe    1011d1 <cga_putc+0x155>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  101177:	a1 60 fe 10 00       	mov    0x10fe60,%eax
  10117c:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  101182:	a1 60 fe 10 00       	mov    0x10fe60,%eax
  101187:	83 ec 04             	sub    $0x4,%esp
  10118a:	68 00 0f 00 00       	push   $0xf00
  10118f:	52                   	push   %edx
  101190:	50                   	push   %eax
  101191:	e8 7d 22 00 00       	call   103413 <memmove>
  101196:	83 c4 10             	add    $0x10,%esp
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101199:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  1011a0:	eb 16                	jmp    1011b8 <cga_putc+0x13c>
            crt_buf[i] = 0x0700 | ' ';
  1011a2:	8b 15 60 fe 10 00    	mov    0x10fe60,%edx
  1011a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1011ab:	01 c0                	add    %eax,%eax
  1011ad:	01 d0                	add    %edx,%eax
  1011af:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011b4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1011b8:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  1011bf:	7e e1                	jle    1011a2 <cga_putc+0x126>
        }
        crt_pos -= CRT_COLS;
  1011c1:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  1011c8:	83 e8 50             	sub    $0x50,%eax
  1011cb:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1011d1:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  1011d8:	0f b7 c0             	movzwl %ax,%eax
  1011db:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  1011df:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1011e3:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1011e7:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1011eb:	ee                   	out    %al,(%dx)
}
  1011ec:	90                   	nop
    outb(addr_6845 + 1, crt_pos >> 8);
  1011ed:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  1011f4:	66 c1 e8 08          	shr    $0x8,%ax
  1011f8:	0f b6 c0             	movzbl %al,%eax
  1011fb:	0f b7 15 66 fe 10 00 	movzwl 0x10fe66,%edx
  101202:	83 c2 01             	add    $0x1,%edx
  101205:	0f b7 d2             	movzwl %dx,%edx
  101208:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  10120c:	88 45 e9             	mov    %al,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10120f:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101213:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101217:	ee                   	out    %al,(%dx)
}
  101218:	90                   	nop
    outb(addr_6845, 15);
  101219:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  101220:	0f b7 c0             	movzwl %ax,%eax
  101223:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  101227:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10122b:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10122f:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101233:	ee                   	out    %al,(%dx)
}
  101234:	90                   	nop
    outb(addr_6845 + 1, crt_pos);
  101235:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  10123c:	0f b6 c0             	movzbl %al,%eax
  10123f:	0f b7 15 66 fe 10 00 	movzwl 0x10fe66,%edx
  101246:	83 c2 01             	add    $0x1,%edx
  101249:	0f b7 d2             	movzwl %dx,%edx
  10124c:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  101250:	88 45 f1             	mov    %al,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101253:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101257:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10125b:	ee                   	out    %al,(%dx)
}
  10125c:	90                   	nop
}
  10125d:	90                   	nop
  10125e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  101261:	c9                   	leave  
  101262:	c3                   	ret    

00101263 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  101263:	55                   	push   %ebp
  101264:	89 e5                	mov    %esp,%ebp
  101266:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101269:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101270:	eb 09                	jmp    10127b <serial_putc_sub+0x18>
        delay();
  101272:	e8 33 fb ff ff       	call   100daa <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101277:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10127b:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101281:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101285:	89 c2                	mov    %eax,%edx
  101287:	ec                   	in     (%dx),%al
  101288:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10128b:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10128f:	0f b6 c0             	movzbl %al,%eax
  101292:	83 e0 20             	and    $0x20,%eax
  101295:	85 c0                	test   %eax,%eax
  101297:	75 09                	jne    1012a2 <serial_putc_sub+0x3f>
  101299:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1012a0:	7e d0                	jle    101272 <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
  1012a2:	8b 45 08             	mov    0x8(%ebp),%eax
  1012a5:	0f b6 c0             	movzbl %al,%eax
  1012a8:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  1012ae:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1012b1:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1012b5:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1012b9:	ee                   	out    %al,(%dx)
}
  1012ba:	90                   	nop
}
  1012bb:	90                   	nop
  1012bc:	c9                   	leave  
  1012bd:	c3                   	ret    

001012be <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  1012be:	55                   	push   %ebp
  1012bf:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
  1012c1:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1012c5:	74 0d                	je     1012d4 <serial_putc+0x16>
        serial_putc_sub(c);
  1012c7:	ff 75 08             	push   0x8(%ebp)
  1012ca:	e8 94 ff ff ff       	call   101263 <serial_putc_sub>
  1012cf:	83 c4 04             	add    $0x4,%esp
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  1012d2:	eb 1e                	jmp    1012f2 <serial_putc+0x34>
        serial_putc_sub('\b');
  1012d4:	6a 08                	push   $0x8
  1012d6:	e8 88 ff ff ff       	call   101263 <serial_putc_sub>
  1012db:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub(' ');
  1012de:	6a 20                	push   $0x20
  1012e0:	e8 7e ff ff ff       	call   101263 <serial_putc_sub>
  1012e5:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub('\b');
  1012e8:	6a 08                	push   $0x8
  1012ea:	e8 74 ff ff ff       	call   101263 <serial_putc_sub>
  1012ef:	83 c4 04             	add    $0x4,%esp
}
  1012f2:	90                   	nop
  1012f3:	c9                   	leave  
  1012f4:	c3                   	ret    

001012f5 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  1012f5:	55                   	push   %ebp
  1012f6:	89 e5                	mov    %esp,%ebp
  1012f8:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  1012fb:	eb 33                	jmp    101330 <cons_intr+0x3b>
        if (c != 0) {
  1012fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  101301:	74 2d                	je     101330 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  101303:	a1 84 00 11 00       	mov    0x110084,%eax
  101308:	8d 50 01             	lea    0x1(%eax),%edx
  10130b:	89 15 84 00 11 00    	mov    %edx,0x110084
  101311:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101314:	88 90 80 fe 10 00    	mov    %dl,0x10fe80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  10131a:	a1 84 00 11 00       	mov    0x110084,%eax
  10131f:	3d 00 02 00 00       	cmp    $0x200,%eax
  101324:	75 0a                	jne    101330 <cons_intr+0x3b>
                cons.wpos = 0;
  101326:	c7 05 84 00 11 00 00 	movl   $0x0,0x110084
  10132d:	00 00 00 
    while ((c = (*proc)()) != -1) {
  101330:	8b 45 08             	mov    0x8(%ebp),%eax
  101333:	ff d0                	call   *%eax
  101335:	89 45 f4             	mov    %eax,-0xc(%ebp)
  101338:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  10133c:	75 bf                	jne    1012fd <cons_intr+0x8>
            }
        }
    }
}
  10133e:	90                   	nop
  10133f:	90                   	nop
  101340:	c9                   	leave  
  101341:	c3                   	ret    

00101342 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  101342:	55                   	push   %ebp
  101343:	89 e5                	mov    %esp,%ebp
  101345:	83 ec 10             	sub    $0x10,%esp
  101348:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10134e:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101352:	89 c2                	mov    %eax,%edx
  101354:	ec                   	in     (%dx),%al
  101355:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101358:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  10135c:	0f b6 c0             	movzbl %al,%eax
  10135f:	83 e0 01             	and    $0x1,%eax
  101362:	85 c0                	test   %eax,%eax
  101364:	75 07                	jne    10136d <serial_proc_data+0x2b>
        return -1;
  101366:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10136b:	eb 2a                	jmp    101397 <serial_proc_data+0x55>
  10136d:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101373:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  101377:	89 c2                	mov    %eax,%edx
  101379:	ec                   	in     (%dx),%al
  10137a:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  10137d:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  101381:	0f b6 c0             	movzbl %al,%eax
  101384:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  101387:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  10138b:	75 07                	jne    101394 <serial_proc_data+0x52>
        c = '\b';
  10138d:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  101394:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  101397:	c9                   	leave  
  101398:	c3                   	ret    

00101399 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  101399:	55                   	push   %ebp
  10139a:	89 e5                	mov    %esp,%ebp
  10139c:	83 ec 08             	sub    $0x8,%esp
    if (serial_exists) {
  10139f:	a1 68 fe 10 00       	mov    0x10fe68,%eax
  1013a4:	85 c0                	test   %eax,%eax
  1013a6:	74 10                	je     1013b8 <serial_intr+0x1f>
        cons_intr(serial_proc_data);
  1013a8:	83 ec 0c             	sub    $0xc,%esp
  1013ab:	68 42 13 10 00       	push   $0x101342
  1013b0:	e8 40 ff ff ff       	call   1012f5 <cons_intr>
  1013b5:	83 c4 10             	add    $0x10,%esp
    }
}
  1013b8:	90                   	nop
  1013b9:	c9                   	leave  
  1013ba:	c3                   	ret    

001013bb <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  1013bb:	55                   	push   %ebp
  1013bc:	89 e5                	mov    %esp,%ebp
  1013be:	83 ec 28             	sub    $0x28,%esp
  1013c1:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013c7:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1013cb:	89 c2                	mov    %eax,%edx
  1013cd:	ec                   	in     (%dx),%al
  1013ce:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  1013d1:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  1013d5:	0f b6 c0             	movzbl %al,%eax
  1013d8:	83 e0 01             	and    $0x1,%eax
  1013db:	85 c0                	test   %eax,%eax
  1013dd:	75 0a                	jne    1013e9 <kbd_proc_data+0x2e>
        return -1;
  1013df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013e4:	e9 5e 01 00 00       	jmp    101547 <kbd_proc_data+0x18c>
  1013e9:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013ef:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1013f3:	89 c2                	mov    %eax,%edx
  1013f5:	ec                   	in     (%dx),%al
  1013f6:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  1013f9:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  1013fd:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  101400:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  101404:	75 17                	jne    10141d <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  101406:	a1 88 00 11 00       	mov    0x110088,%eax
  10140b:	83 c8 40             	or     $0x40,%eax
  10140e:	a3 88 00 11 00       	mov    %eax,0x110088
        return 0;
  101413:	b8 00 00 00 00       	mov    $0x0,%eax
  101418:	e9 2a 01 00 00       	jmp    101547 <kbd_proc_data+0x18c>
    } else if (data & 0x80) {
  10141d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101421:	84 c0                	test   %al,%al
  101423:	79 47                	jns    10146c <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101425:	a1 88 00 11 00       	mov    0x110088,%eax
  10142a:	83 e0 40             	and    $0x40,%eax
  10142d:	85 c0                	test   %eax,%eax
  10142f:	75 09                	jne    10143a <kbd_proc_data+0x7f>
  101431:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101435:	83 e0 7f             	and    $0x7f,%eax
  101438:	eb 04                	jmp    10143e <kbd_proc_data+0x83>
  10143a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10143e:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  101441:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101445:	0f b6 80 40 f0 10 00 	movzbl 0x10f040(%eax),%eax
  10144c:	83 c8 40             	or     $0x40,%eax
  10144f:	0f b6 c0             	movzbl %al,%eax
  101452:	f7 d0                	not    %eax
  101454:	89 c2                	mov    %eax,%edx
  101456:	a1 88 00 11 00       	mov    0x110088,%eax
  10145b:	21 d0                	and    %edx,%eax
  10145d:	a3 88 00 11 00       	mov    %eax,0x110088
        return 0;
  101462:	b8 00 00 00 00       	mov    $0x0,%eax
  101467:	e9 db 00 00 00       	jmp    101547 <kbd_proc_data+0x18c>
    } else if (shift & E0ESC) {
  10146c:	a1 88 00 11 00       	mov    0x110088,%eax
  101471:	83 e0 40             	and    $0x40,%eax
  101474:	85 c0                	test   %eax,%eax
  101476:	74 11                	je     101489 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  101478:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  10147c:	a1 88 00 11 00       	mov    0x110088,%eax
  101481:	83 e0 bf             	and    $0xffffffbf,%eax
  101484:	a3 88 00 11 00       	mov    %eax,0x110088
    }

    shift |= shiftcode[data];
  101489:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10148d:	0f b6 80 40 f0 10 00 	movzbl 0x10f040(%eax),%eax
  101494:	0f b6 d0             	movzbl %al,%edx
  101497:	a1 88 00 11 00       	mov    0x110088,%eax
  10149c:	09 d0                	or     %edx,%eax
  10149e:	a3 88 00 11 00       	mov    %eax,0x110088
    shift ^= togglecode[data];
  1014a3:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014a7:	0f b6 80 40 f1 10 00 	movzbl 0x10f140(%eax),%eax
  1014ae:	0f b6 d0             	movzbl %al,%edx
  1014b1:	a1 88 00 11 00       	mov    0x110088,%eax
  1014b6:	31 d0                	xor    %edx,%eax
  1014b8:	a3 88 00 11 00       	mov    %eax,0x110088

    c = charcode[shift & (CTL | SHIFT)][data];
  1014bd:	a1 88 00 11 00       	mov    0x110088,%eax
  1014c2:	83 e0 03             	and    $0x3,%eax
  1014c5:	8b 14 85 40 f5 10 00 	mov    0x10f540(,%eax,4),%edx
  1014cc:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014d0:	01 d0                	add    %edx,%eax
  1014d2:	0f b6 00             	movzbl (%eax),%eax
  1014d5:	0f b6 c0             	movzbl %al,%eax
  1014d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  1014db:	a1 88 00 11 00       	mov    0x110088,%eax
  1014e0:	83 e0 08             	and    $0x8,%eax
  1014e3:	85 c0                	test   %eax,%eax
  1014e5:	74 22                	je     101509 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  1014e7:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  1014eb:	7e 0c                	jle    1014f9 <kbd_proc_data+0x13e>
  1014ed:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  1014f1:	7f 06                	jg     1014f9 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  1014f3:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  1014f7:	eb 10                	jmp    101509 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  1014f9:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  1014fd:	7e 0a                	jle    101509 <kbd_proc_data+0x14e>
  1014ff:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  101503:	7f 04                	jg     101509 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  101505:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  101509:	a1 88 00 11 00       	mov    0x110088,%eax
  10150e:	f7 d0                	not    %eax
  101510:	83 e0 06             	and    $0x6,%eax
  101513:	85 c0                	test   %eax,%eax
  101515:	75 2d                	jne    101544 <kbd_proc_data+0x189>
  101517:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  10151e:	75 24                	jne    101544 <kbd_proc_data+0x189>
        cprintf("Rebooting!\n");
  101520:	83 ec 0c             	sub    $0xc,%esp
  101523:	68 8f 38 10 00       	push   $0x10388f
  101528:	e8 de ed ff ff       	call   10030b <cprintf>
  10152d:	83 c4 10             	add    $0x10,%esp
  101530:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  101536:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10153a:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  10153e:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  101542:	ee                   	out    %al,(%dx)
}
  101543:	90                   	nop
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  101544:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101547:	c9                   	leave  
  101548:	c3                   	ret    

00101549 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  101549:	55                   	push   %ebp
  10154a:	89 e5                	mov    %esp,%ebp
  10154c:	83 ec 08             	sub    $0x8,%esp
    cons_intr(kbd_proc_data);
  10154f:	83 ec 0c             	sub    $0xc,%esp
  101552:	68 bb 13 10 00       	push   $0x1013bb
  101557:	e8 99 fd ff ff       	call   1012f5 <cons_intr>
  10155c:	83 c4 10             	add    $0x10,%esp
}
  10155f:	90                   	nop
  101560:	c9                   	leave  
  101561:	c3                   	ret    

00101562 <kbd_init>:

static void
kbd_init(void) {
  101562:	55                   	push   %ebp
  101563:	89 e5                	mov    %esp,%ebp
  101565:	83 ec 08             	sub    $0x8,%esp
    // drain the kbd buffer
    kbd_intr();
  101568:	e8 dc ff ff ff       	call   101549 <kbd_intr>
    pic_enable(IRQ_KBD);
  10156d:	83 ec 0c             	sub    $0xc,%esp
  101570:	6a 01                	push   $0x1
  101572:	e8 2e 01 00 00       	call   1016a5 <pic_enable>
  101577:	83 c4 10             	add    $0x10,%esp
}
  10157a:	90                   	nop
  10157b:	c9                   	leave  
  10157c:	c3                   	ret    

0010157d <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  10157d:	55                   	push   %ebp
  10157e:	89 e5                	mov    %esp,%ebp
  101580:	83 ec 08             	sub    $0x8,%esp
    cga_init();
  101583:	e8 6b f8 ff ff       	call   100df3 <cga_init>
    serial_init();
  101588:	e8 4f f9 ff ff       	call   100edc <serial_init>
    kbd_init();
  10158d:	e8 d0 ff ff ff       	call   101562 <kbd_init>
    if (!serial_exists) {
  101592:	a1 68 fe 10 00       	mov    0x10fe68,%eax
  101597:	85 c0                	test   %eax,%eax
  101599:	75 10                	jne    1015ab <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
  10159b:	83 ec 0c             	sub    $0xc,%esp
  10159e:	68 9b 38 10 00       	push   $0x10389b
  1015a3:	e8 63 ed ff ff       	call   10030b <cprintf>
  1015a8:	83 c4 10             	add    $0x10,%esp
    }
}
  1015ab:	90                   	nop
  1015ac:	c9                   	leave  
  1015ad:	c3                   	ret    

001015ae <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  1015ae:	55                   	push   %ebp
  1015af:	89 e5                	mov    %esp,%ebp
  1015b1:	83 ec 08             	sub    $0x8,%esp
    lpt_putc(c);
  1015b4:	ff 75 08             	push   0x8(%ebp)
  1015b7:	e8 89 fa ff ff       	call   101045 <lpt_putc>
  1015bc:	83 c4 04             	add    $0x4,%esp
    cga_putc(c);
  1015bf:	83 ec 0c             	sub    $0xc,%esp
  1015c2:	ff 75 08             	push   0x8(%ebp)
  1015c5:	e8 b2 fa ff ff       	call   10107c <cga_putc>
  1015ca:	83 c4 10             	add    $0x10,%esp
    serial_putc(c);
  1015cd:	83 ec 0c             	sub    $0xc,%esp
  1015d0:	ff 75 08             	push   0x8(%ebp)
  1015d3:	e8 e6 fc ff ff       	call   1012be <serial_putc>
  1015d8:	83 c4 10             	add    $0x10,%esp
}
  1015db:	90                   	nop
  1015dc:	c9                   	leave  
  1015dd:	c3                   	ret    

001015de <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  1015de:	55                   	push   %ebp
  1015df:	89 e5                	mov    %esp,%ebp
  1015e1:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  1015e4:	e8 b0 fd ff ff       	call   101399 <serial_intr>
    kbd_intr();
  1015e9:	e8 5b ff ff ff       	call   101549 <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  1015ee:	8b 15 80 00 11 00    	mov    0x110080,%edx
  1015f4:	a1 84 00 11 00       	mov    0x110084,%eax
  1015f9:	39 c2                	cmp    %eax,%edx
  1015fb:	74 36                	je     101633 <cons_getc+0x55>
        c = cons.buf[cons.rpos ++];
  1015fd:	a1 80 00 11 00       	mov    0x110080,%eax
  101602:	8d 50 01             	lea    0x1(%eax),%edx
  101605:	89 15 80 00 11 00    	mov    %edx,0x110080
  10160b:	0f b6 80 80 fe 10 00 	movzbl 0x10fe80(%eax),%eax
  101612:	0f b6 c0             	movzbl %al,%eax
  101615:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  101618:	a1 80 00 11 00       	mov    0x110080,%eax
  10161d:	3d 00 02 00 00       	cmp    $0x200,%eax
  101622:	75 0a                	jne    10162e <cons_getc+0x50>
            cons.rpos = 0;
  101624:	c7 05 80 00 11 00 00 	movl   $0x0,0x110080
  10162b:	00 00 00 
        }
        return c;
  10162e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101631:	eb 05                	jmp    101638 <cons_getc+0x5a>
    }
    return 0;
  101633:	b8 00 00 00 00       	mov    $0x0,%eax
}
  101638:	c9                   	leave  
  101639:	c3                   	ret    

0010163a <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  10163a:	55                   	push   %ebp
  10163b:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  10163d:	fb                   	sti    
}
  10163e:	90                   	nop
    sti();
}
  10163f:	90                   	nop
  101640:	5d                   	pop    %ebp
  101641:	c3                   	ret    

00101642 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  101642:	55                   	push   %ebp
  101643:	89 e5                	mov    %esp,%ebp

static inline void
cli(void) {
    asm volatile ("cli");
  101645:	fa                   	cli    
}
  101646:	90                   	nop
    cli();
}
  101647:	90                   	nop
  101648:	5d                   	pop    %ebp
  101649:	c3                   	ret    

0010164a <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  10164a:	55                   	push   %ebp
  10164b:	89 e5                	mov    %esp,%ebp
  10164d:	83 ec 14             	sub    $0x14,%esp
  101650:	8b 45 08             	mov    0x8(%ebp),%eax
  101653:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  101657:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10165b:	66 a3 50 f5 10 00    	mov    %ax,0x10f550
    if (did_init) {
  101661:	a1 8c 00 11 00       	mov    0x11008c,%eax
  101666:	85 c0                	test   %eax,%eax
  101668:	74 38                	je     1016a2 <pic_setmask+0x58>
        outb(IO_PIC1 + 1, mask);
  10166a:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10166e:	0f b6 c0             	movzbl %al,%eax
  101671:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
  101677:	88 45 f9             	mov    %al,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10167a:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10167e:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101682:	ee                   	out    %al,(%dx)
}
  101683:	90                   	nop
        outb(IO_PIC2 + 1, mask >> 8);
  101684:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101688:	66 c1 e8 08          	shr    $0x8,%ax
  10168c:	0f b6 c0             	movzbl %al,%eax
  10168f:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
  101695:	88 45 fd             	mov    %al,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101698:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  10169c:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016a0:	ee                   	out    %al,(%dx)
}
  1016a1:	90                   	nop
    }
}
  1016a2:	90                   	nop
  1016a3:	c9                   	leave  
  1016a4:	c3                   	ret    

001016a5 <pic_enable>:

void
pic_enable(unsigned int irq) {
  1016a5:	55                   	push   %ebp
  1016a6:	89 e5                	mov    %esp,%ebp
    pic_setmask(irq_mask & ~(1 << irq));
  1016a8:	8b 45 08             	mov    0x8(%ebp),%eax
  1016ab:	ba 01 00 00 00       	mov    $0x1,%edx
  1016b0:	89 c1                	mov    %eax,%ecx
  1016b2:	d3 e2                	shl    %cl,%edx
  1016b4:	89 d0                	mov    %edx,%eax
  1016b6:	f7 d0                	not    %eax
  1016b8:	89 c2                	mov    %eax,%edx
  1016ba:	0f b7 05 50 f5 10 00 	movzwl 0x10f550,%eax
  1016c1:	21 d0                	and    %edx,%eax
  1016c3:	0f b7 c0             	movzwl %ax,%eax
  1016c6:	50                   	push   %eax
  1016c7:	e8 7e ff ff ff       	call   10164a <pic_setmask>
  1016cc:	83 c4 04             	add    $0x4,%esp
}
  1016cf:	90                   	nop
  1016d0:	c9                   	leave  
  1016d1:	c3                   	ret    

001016d2 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  1016d2:	55                   	push   %ebp
  1016d3:	89 e5                	mov    %esp,%ebp
  1016d5:	83 ec 40             	sub    $0x40,%esp
    did_init = 1;
  1016d8:	c7 05 8c 00 11 00 01 	movl   $0x1,0x11008c
  1016df:	00 00 00 
  1016e2:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
  1016e8:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1016ec:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  1016f0:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  1016f4:	ee                   	out    %al,(%dx)
}
  1016f5:	90                   	nop
  1016f6:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
  1016fc:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101700:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  101704:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  101708:	ee                   	out    %al,(%dx)
}
  101709:	90                   	nop
  10170a:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  101710:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101714:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  101718:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  10171c:	ee                   	out    %al,(%dx)
}
  10171d:	90                   	nop
  10171e:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
  101724:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101728:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  10172c:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  101730:	ee                   	out    %al,(%dx)
}
  101731:	90                   	nop
  101732:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
  101738:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10173c:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101740:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101744:	ee                   	out    %al,(%dx)
}
  101745:	90                   	nop
  101746:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
  10174c:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101750:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101754:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101758:	ee                   	out    %al,(%dx)
}
  101759:	90                   	nop
  10175a:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
  101760:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101764:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101768:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  10176c:	ee                   	out    %al,(%dx)
}
  10176d:	90                   	nop
  10176e:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
  101774:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101778:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10177c:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101780:	ee                   	out    %al,(%dx)
}
  101781:	90                   	nop
  101782:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
  101788:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10178c:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101790:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101794:	ee                   	out    %al,(%dx)
}
  101795:	90                   	nop
  101796:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  10179c:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017a0:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1017a4:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1017a8:	ee                   	out    %al,(%dx)
}
  1017a9:	90                   	nop
  1017aa:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
  1017b0:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017b4:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1017b8:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1017bc:	ee                   	out    %al,(%dx)
}
  1017bd:	90                   	nop
  1017be:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  1017c4:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017c8:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1017cc:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1017d0:	ee                   	out    %al,(%dx)
}
  1017d1:	90                   	nop
  1017d2:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
  1017d8:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017dc:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1017e0:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1017e4:	ee                   	out    %al,(%dx)
}
  1017e5:	90                   	nop
  1017e6:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
  1017ec:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017f0:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1017f4:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1017f8:	ee                   	out    %al,(%dx)
}
  1017f9:	90                   	nop
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  1017fa:	0f b7 05 50 f5 10 00 	movzwl 0x10f550,%eax
  101801:	66 83 f8 ff          	cmp    $0xffff,%ax
  101805:	74 13                	je     10181a <pic_init+0x148>
        pic_setmask(irq_mask);
  101807:	0f b7 05 50 f5 10 00 	movzwl 0x10f550,%eax
  10180e:	0f b7 c0             	movzwl %ax,%eax
  101811:	50                   	push   %eax
  101812:	e8 33 fe ff ff       	call   10164a <pic_setmask>
  101817:	83 c4 04             	add    $0x4,%esp
    }
}
  10181a:	90                   	nop
  10181b:	c9                   	leave  
  10181c:	c3                   	ret    

0010181d <print_ticks>:
#include <console.h>
#include <kdebug.h>
#include <string.h>
#define TICK_NUM 100

static void print_ticks() {
  10181d:	55                   	push   %ebp
  10181e:	89 e5                	mov    %esp,%ebp
  101820:	83 ec 08             	sub    $0x8,%esp
    cprintf("%d ticks\n",TICK_NUM);
  101823:	83 ec 08             	sub    $0x8,%esp
  101826:	6a 64                	push   $0x64
  101828:	68 c0 38 10 00       	push   $0x1038c0
  10182d:	e8 d9 ea ff ff       	call   10030b <cprintf>
  101832:	83 c4 10             	add    $0x10,%esp
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  101835:	90                   	nop
  101836:	c9                   	leave  
  101837:	c3                   	ret    

00101838 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  101838:	55                   	push   %ebp
  101839:	89 e5                	mov    %esp,%ebp
  10183b:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  10183e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101845:	e9 c3 00 00 00       	jmp    10190d <idt_init+0xd5>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  10184a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10184d:	8b 04 85 e0 f5 10 00 	mov    0x10f5e0(,%eax,4),%eax
  101854:	89 c2                	mov    %eax,%edx
  101856:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101859:	66 89 14 c5 00 01 11 	mov    %dx,0x110100(,%eax,8)
  101860:	00 
  101861:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101864:	66 c7 04 c5 02 01 11 	movw   $0x8,0x110102(,%eax,8)
  10186b:	00 08 00 
  10186e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101871:	0f b6 14 c5 04 01 11 	movzbl 0x110104(,%eax,8),%edx
  101878:	00 
  101879:	83 e2 e0             	and    $0xffffffe0,%edx
  10187c:	88 14 c5 04 01 11 00 	mov    %dl,0x110104(,%eax,8)
  101883:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101886:	0f b6 14 c5 04 01 11 	movzbl 0x110104(,%eax,8),%edx
  10188d:	00 
  10188e:	83 e2 1f             	and    $0x1f,%edx
  101891:	88 14 c5 04 01 11 00 	mov    %dl,0x110104(,%eax,8)
  101898:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10189b:	0f b6 14 c5 05 01 11 	movzbl 0x110105(,%eax,8),%edx
  1018a2:	00 
  1018a3:	83 e2 f0             	and    $0xfffffff0,%edx
  1018a6:	83 ca 0e             	or     $0xe,%edx
  1018a9:	88 14 c5 05 01 11 00 	mov    %dl,0x110105(,%eax,8)
  1018b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018b3:	0f b6 14 c5 05 01 11 	movzbl 0x110105(,%eax,8),%edx
  1018ba:	00 
  1018bb:	83 e2 ef             	and    $0xffffffef,%edx
  1018be:	88 14 c5 05 01 11 00 	mov    %dl,0x110105(,%eax,8)
  1018c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018c8:	0f b6 14 c5 05 01 11 	movzbl 0x110105(,%eax,8),%edx
  1018cf:	00 
  1018d0:	83 e2 9f             	and    $0xffffff9f,%edx
  1018d3:	88 14 c5 05 01 11 00 	mov    %dl,0x110105(,%eax,8)
  1018da:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018dd:	0f b6 14 c5 05 01 11 	movzbl 0x110105(,%eax,8),%edx
  1018e4:	00 
  1018e5:	83 ca 80             	or     $0xffffff80,%edx
  1018e8:	88 14 c5 05 01 11 00 	mov    %dl,0x110105(,%eax,8)
  1018ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018f2:	8b 04 85 e0 f5 10 00 	mov    0x10f5e0(,%eax,4),%eax
  1018f9:	c1 e8 10             	shr    $0x10,%eax
  1018fc:	89 c2                	mov    %eax,%edx
  1018fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101901:	66 89 14 c5 06 01 11 	mov    %dx,0x110106(,%eax,8)
  101908:	00 
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  101909:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10190d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101910:	3d ff 00 00 00       	cmp    $0xff,%eax
  101915:	0f 86 2f ff ff ff    	jbe    10184a <idt_init+0x12>
    }
	// set for switch from user to kernel
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
  10191b:	a1 c4 f7 10 00       	mov    0x10f7c4,%eax
  101920:	66 a3 c8 04 11 00    	mov    %ax,0x1104c8
  101926:	66 c7 05 ca 04 11 00 	movw   $0x8,0x1104ca
  10192d:	08 00 
  10192f:	0f b6 05 cc 04 11 00 	movzbl 0x1104cc,%eax
  101936:	83 e0 e0             	and    $0xffffffe0,%eax
  101939:	a2 cc 04 11 00       	mov    %al,0x1104cc
  10193e:	0f b6 05 cc 04 11 00 	movzbl 0x1104cc,%eax
  101945:	83 e0 1f             	and    $0x1f,%eax
  101948:	a2 cc 04 11 00       	mov    %al,0x1104cc
  10194d:	0f b6 05 cd 04 11 00 	movzbl 0x1104cd,%eax
  101954:	83 e0 f0             	and    $0xfffffff0,%eax
  101957:	83 c8 0e             	or     $0xe,%eax
  10195a:	a2 cd 04 11 00       	mov    %al,0x1104cd
  10195f:	0f b6 05 cd 04 11 00 	movzbl 0x1104cd,%eax
  101966:	83 e0 ef             	and    $0xffffffef,%eax
  101969:	a2 cd 04 11 00       	mov    %al,0x1104cd
  10196e:	0f b6 05 cd 04 11 00 	movzbl 0x1104cd,%eax
  101975:	83 c8 60             	or     $0x60,%eax
  101978:	a2 cd 04 11 00       	mov    %al,0x1104cd
  10197d:	0f b6 05 cd 04 11 00 	movzbl 0x1104cd,%eax
  101984:	83 c8 80             	or     $0xffffff80,%eax
  101987:	a2 cd 04 11 00       	mov    %al,0x1104cd
  10198c:	a1 c4 f7 10 00       	mov    0x10f7c4,%eax
  101991:	c1 e8 10             	shr    $0x10,%eax
  101994:	66 a3 ce 04 11 00    	mov    %ax,0x1104ce
  10199a:	c7 45 f8 60 f5 10 00 	movl   $0x10f560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd));
  1019a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1019a4:	0f 01 18             	lidtl  (%eax)
}
  1019a7:	90                   	nop
	// load the IDT
    lidt(&idt_pd);
}
  1019a8:	90                   	nop
  1019a9:	c9                   	leave  
  1019aa:	c3                   	ret    

001019ab <trapname>:

static const char *
trapname(int trapno) {
  1019ab:	55                   	push   %ebp
  1019ac:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  1019ae:	8b 45 08             	mov    0x8(%ebp),%eax
  1019b1:	83 f8 13             	cmp    $0x13,%eax
  1019b4:	77 0c                	ja     1019c2 <trapname+0x17>
        return excnames[trapno];
  1019b6:	8b 45 08             	mov    0x8(%ebp),%eax
  1019b9:	8b 04 85 20 3c 10 00 	mov    0x103c20(,%eax,4),%eax
  1019c0:	eb 18                	jmp    1019da <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  1019c2:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  1019c6:	7e 0d                	jle    1019d5 <trapname+0x2a>
  1019c8:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  1019cc:	7f 07                	jg     1019d5 <trapname+0x2a>
        return "Hardware Interrupt";
  1019ce:	b8 ca 38 10 00       	mov    $0x1038ca,%eax
  1019d3:	eb 05                	jmp    1019da <trapname+0x2f>
    }
    return "(unknown trap)";
  1019d5:	b8 dd 38 10 00       	mov    $0x1038dd,%eax
}
  1019da:	5d                   	pop    %ebp
  1019db:	c3                   	ret    

001019dc <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  1019dc:	55                   	push   %ebp
  1019dd:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  1019df:	8b 45 08             	mov    0x8(%ebp),%eax
  1019e2:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  1019e6:	66 83 f8 08          	cmp    $0x8,%ax
  1019ea:	0f 94 c0             	sete   %al
  1019ed:	0f b6 c0             	movzbl %al,%eax
}
  1019f0:	5d                   	pop    %ebp
  1019f1:	c3                   	ret    

001019f2 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  1019f2:	55                   	push   %ebp
  1019f3:	89 e5                	mov    %esp,%ebp
  1019f5:	83 ec 18             	sub    $0x18,%esp
    cprintf("trapframe at %p\n", tf);
  1019f8:	83 ec 08             	sub    $0x8,%esp
  1019fb:	ff 75 08             	push   0x8(%ebp)
  1019fe:	68 1e 39 10 00       	push   $0x10391e
  101a03:	e8 03 e9 ff ff       	call   10030b <cprintf>
  101a08:	83 c4 10             	add    $0x10,%esp
    print_regs(&tf->tf_regs);
  101a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  101a0e:	83 ec 0c             	sub    $0xc,%esp
  101a11:	50                   	push   %eax
  101a12:	e8 b4 01 00 00       	call   101bcb <print_regs>
  101a17:	83 c4 10             	add    $0x10,%esp
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  101a1d:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101a21:	0f b7 c0             	movzwl %ax,%eax
  101a24:	83 ec 08             	sub    $0x8,%esp
  101a27:	50                   	push   %eax
  101a28:	68 2f 39 10 00       	push   $0x10392f
  101a2d:	e8 d9 e8 ff ff       	call   10030b <cprintf>
  101a32:	83 c4 10             	add    $0x10,%esp
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101a35:	8b 45 08             	mov    0x8(%ebp),%eax
  101a38:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101a3c:	0f b7 c0             	movzwl %ax,%eax
  101a3f:	83 ec 08             	sub    $0x8,%esp
  101a42:	50                   	push   %eax
  101a43:	68 42 39 10 00       	push   $0x103942
  101a48:	e8 be e8 ff ff       	call   10030b <cprintf>
  101a4d:	83 c4 10             	add    $0x10,%esp
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101a50:	8b 45 08             	mov    0x8(%ebp),%eax
  101a53:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101a57:	0f b7 c0             	movzwl %ax,%eax
  101a5a:	83 ec 08             	sub    $0x8,%esp
  101a5d:	50                   	push   %eax
  101a5e:	68 55 39 10 00       	push   $0x103955
  101a63:	e8 a3 e8 ff ff       	call   10030b <cprintf>
  101a68:	83 c4 10             	add    $0x10,%esp
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  101a6e:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101a72:	0f b7 c0             	movzwl %ax,%eax
  101a75:	83 ec 08             	sub    $0x8,%esp
  101a78:	50                   	push   %eax
  101a79:	68 68 39 10 00       	push   $0x103968
  101a7e:	e8 88 e8 ff ff       	call   10030b <cprintf>
  101a83:	83 c4 10             	add    $0x10,%esp
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101a86:	8b 45 08             	mov    0x8(%ebp),%eax
  101a89:	8b 40 30             	mov    0x30(%eax),%eax
  101a8c:	83 ec 0c             	sub    $0xc,%esp
  101a8f:	50                   	push   %eax
  101a90:	e8 16 ff ff ff       	call   1019ab <trapname>
  101a95:	83 c4 10             	add    $0x10,%esp
  101a98:	8b 55 08             	mov    0x8(%ebp),%edx
  101a9b:	8b 52 30             	mov    0x30(%edx),%edx
  101a9e:	83 ec 04             	sub    $0x4,%esp
  101aa1:	50                   	push   %eax
  101aa2:	52                   	push   %edx
  101aa3:	68 7b 39 10 00       	push   $0x10397b
  101aa8:	e8 5e e8 ff ff       	call   10030b <cprintf>
  101aad:	83 c4 10             	add    $0x10,%esp
    cprintf("  err  0x%08x\n", tf->tf_err);
  101ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  101ab3:	8b 40 34             	mov    0x34(%eax),%eax
  101ab6:	83 ec 08             	sub    $0x8,%esp
  101ab9:	50                   	push   %eax
  101aba:	68 8d 39 10 00       	push   $0x10398d
  101abf:	e8 47 e8 ff ff       	call   10030b <cprintf>
  101ac4:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  101aca:	8b 40 38             	mov    0x38(%eax),%eax
  101acd:	83 ec 08             	sub    $0x8,%esp
  101ad0:	50                   	push   %eax
  101ad1:	68 9c 39 10 00       	push   $0x10399c
  101ad6:	e8 30 e8 ff ff       	call   10030b <cprintf>
  101adb:	83 c4 10             	add    $0x10,%esp
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101ade:	8b 45 08             	mov    0x8(%ebp),%eax
  101ae1:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101ae5:	0f b7 c0             	movzwl %ax,%eax
  101ae8:	83 ec 08             	sub    $0x8,%esp
  101aeb:	50                   	push   %eax
  101aec:	68 ab 39 10 00       	push   $0x1039ab
  101af1:	e8 15 e8 ff ff       	call   10030b <cprintf>
  101af6:	83 c4 10             	add    $0x10,%esp
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101af9:	8b 45 08             	mov    0x8(%ebp),%eax
  101afc:	8b 40 40             	mov    0x40(%eax),%eax
  101aff:	83 ec 08             	sub    $0x8,%esp
  101b02:	50                   	push   %eax
  101b03:	68 be 39 10 00       	push   $0x1039be
  101b08:	e8 fe e7 ff ff       	call   10030b <cprintf>
  101b0d:	83 c4 10             	add    $0x10,%esp

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b10:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101b17:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101b1e:	eb 3f                	jmp    101b5f <print_trapframe+0x16d>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101b20:	8b 45 08             	mov    0x8(%ebp),%eax
  101b23:	8b 50 40             	mov    0x40(%eax),%edx
  101b26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101b29:	21 d0                	and    %edx,%eax
  101b2b:	85 c0                	test   %eax,%eax
  101b2d:	74 29                	je     101b58 <print_trapframe+0x166>
  101b2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b32:	8b 04 85 80 f5 10 00 	mov    0x10f580(,%eax,4),%eax
  101b39:	85 c0                	test   %eax,%eax
  101b3b:	74 1b                	je     101b58 <print_trapframe+0x166>
            cprintf("%s,", IA32flags[i]);
  101b3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b40:	8b 04 85 80 f5 10 00 	mov    0x10f580(,%eax,4),%eax
  101b47:	83 ec 08             	sub    $0x8,%esp
  101b4a:	50                   	push   %eax
  101b4b:	68 cd 39 10 00       	push   $0x1039cd
  101b50:	e8 b6 e7 ff ff       	call   10030b <cprintf>
  101b55:	83 c4 10             	add    $0x10,%esp
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b58:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101b5c:	d1 65 f0             	shll   -0x10(%ebp)
  101b5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b62:	83 f8 17             	cmp    $0x17,%eax
  101b65:	76 b9                	jbe    101b20 <print_trapframe+0x12e>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101b67:	8b 45 08             	mov    0x8(%ebp),%eax
  101b6a:	8b 40 40             	mov    0x40(%eax),%eax
  101b6d:	c1 e8 0c             	shr    $0xc,%eax
  101b70:	83 e0 03             	and    $0x3,%eax
  101b73:	83 ec 08             	sub    $0x8,%esp
  101b76:	50                   	push   %eax
  101b77:	68 d1 39 10 00       	push   $0x1039d1
  101b7c:	e8 8a e7 ff ff       	call   10030b <cprintf>
  101b81:	83 c4 10             	add    $0x10,%esp

    if (!trap_in_kernel(tf)) {
  101b84:	83 ec 0c             	sub    $0xc,%esp
  101b87:	ff 75 08             	push   0x8(%ebp)
  101b8a:	e8 4d fe ff ff       	call   1019dc <trap_in_kernel>
  101b8f:	83 c4 10             	add    $0x10,%esp
  101b92:	85 c0                	test   %eax,%eax
  101b94:	75 32                	jne    101bc8 <print_trapframe+0x1d6>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101b96:	8b 45 08             	mov    0x8(%ebp),%eax
  101b99:	8b 40 44             	mov    0x44(%eax),%eax
  101b9c:	83 ec 08             	sub    $0x8,%esp
  101b9f:	50                   	push   %eax
  101ba0:	68 da 39 10 00       	push   $0x1039da
  101ba5:	e8 61 e7 ff ff       	call   10030b <cprintf>
  101baa:	83 c4 10             	add    $0x10,%esp
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101bad:	8b 45 08             	mov    0x8(%ebp),%eax
  101bb0:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101bb4:	0f b7 c0             	movzwl %ax,%eax
  101bb7:	83 ec 08             	sub    $0x8,%esp
  101bba:	50                   	push   %eax
  101bbb:	68 e9 39 10 00       	push   $0x1039e9
  101bc0:	e8 46 e7 ff ff       	call   10030b <cprintf>
  101bc5:	83 c4 10             	add    $0x10,%esp
    }
}
  101bc8:	90                   	nop
  101bc9:	c9                   	leave  
  101bca:	c3                   	ret    

00101bcb <print_regs>:

void
print_regs(struct pushregs *regs) {
  101bcb:	55                   	push   %ebp
  101bcc:	89 e5                	mov    %esp,%ebp
  101bce:	83 ec 08             	sub    $0x8,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  101bd4:	8b 00                	mov    (%eax),%eax
  101bd6:	83 ec 08             	sub    $0x8,%esp
  101bd9:	50                   	push   %eax
  101bda:	68 fc 39 10 00       	push   $0x1039fc
  101bdf:	e8 27 e7 ff ff       	call   10030b <cprintf>
  101be4:	83 c4 10             	add    $0x10,%esp
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101be7:	8b 45 08             	mov    0x8(%ebp),%eax
  101bea:	8b 40 04             	mov    0x4(%eax),%eax
  101bed:	83 ec 08             	sub    $0x8,%esp
  101bf0:	50                   	push   %eax
  101bf1:	68 0b 3a 10 00       	push   $0x103a0b
  101bf6:	e8 10 e7 ff ff       	call   10030b <cprintf>
  101bfb:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  101c01:	8b 40 08             	mov    0x8(%eax),%eax
  101c04:	83 ec 08             	sub    $0x8,%esp
  101c07:	50                   	push   %eax
  101c08:	68 1a 3a 10 00       	push   $0x103a1a
  101c0d:	e8 f9 e6 ff ff       	call   10030b <cprintf>
  101c12:	83 c4 10             	add    $0x10,%esp
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101c15:	8b 45 08             	mov    0x8(%ebp),%eax
  101c18:	8b 40 0c             	mov    0xc(%eax),%eax
  101c1b:	83 ec 08             	sub    $0x8,%esp
  101c1e:	50                   	push   %eax
  101c1f:	68 29 3a 10 00       	push   $0x103a29
  101c24:	e8 e2 e6 ff ff       	call   10030b <cprintf>
  101c29:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  101c2f:	8b 40 10             	mov    0x10(%eax),%eax
  101c32:	83 ec 08             	sub    $0x8,%esp
  101c35:	50                   	push   %eax
  101c36:	68 38 3a 10 00       	push   $0x103a38
  101c3b:	e8 cb e6 ff ff       	call   10030b <cprintf>
  101c40:	83 c4 10             	add    $0x10,%esp
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101c43:	8b 45 08             	mov    0x8(%ebp),%eax
  101c46:	8b 40 14             	mov    0x14(%eax),%eax
  101c49:	83 ec 08             	sub    $0x8,%esp
  101c4c:	50                   	push   %eax
  101c4d:	68 47 3a 10 00       	push   $0x103a47
  101c52:	e8 b4 e6 ff ff       	call   10030b <cprintf>
  101c57:	83 c4 10             	add    $0x10,%esp
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  101c5d:	8b 40 18             	mov    0x18(%eax),%eax
  101c60:	83 ec 08             	sub    $0x8,%esp
  101c63:	50                   	push   %eax
  101c64:	68 56 3a 10 00       	push   $0x103a56
  101c69:	e8 9d e6 ff ff       	call   10030b <cprintf>
  101c6e:	83 c4 10             	add    $0x10,%esp
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101c71:	8b 45 08             	mov    0x8(%ebp),%eax
  101c74:	8b 40 1c             	mov    0x1c(%eax),%eax
  101c77:	83 ec 08             	sub    $0x8,%esp
  101c7a:	50                   	push   %eax
  101c7b:	68 65 3a 10 00       	push   $0x103a65
  101c80:	e8 86 e6 ff ff       	call   10030b <cprintf>
  101c85:	83 c4 10             	add    $0x10,%esp
}
  101c88:	90                   	nop
  101c89:	c9                   	leave  
  101c8a:	c3                   	ret    

00101c8b <trap_dispatch>:
/* temporary trapframe or pointer to trapframe */
struct trapframe switchk2u, *switchu2k;

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101c8b:	55                   	push   %ebp
  101c8c:	89 e5                	mov    %esp,%ebp
  101c8e:	57                   	push   %edi
  101c8f:	56                   	push   %esi
  101c90:	53                   	push   %ebx
  101c91:	83 ec 1c             	sub    $0x1c,%esp
    char c;

    switch (tf->tf_trapno) {
  101c94:	8b 45 08             	mov    0x8(%ebp),%eax
  101c97:	8b 40 30             	mov    0x30(%eax),%eax
  101c9a:	83 f8 79             	cmp    $0x79,%eax
  101c9d:	0f 84 50 01 00 00    	je     101df3 <trap_dispatch+0x168>
  101ca3:	83 f8 79             	cmp    $0x79,%eax
  101ca6:	0f 87 bd 01 00 00    	ja     101e69 <trap_dispatch+0x1de>
  101cac:	83 f8 78             	cmp    $0x78,%eax
  101caf:	0f 84 c0 00 00 00    	je     101d75 <trap_dispatch+0xea>
  101cb5:	83 f8 78             	cmp    $0x78,%eax
  101cb8:	0f 87 ab 01 00 00    	ja     101e69 <trap_dispatch+0x1de>
  101cbe:	83 f8 2f             	cmp    $0x2f,%eax
  101cc1:	0f 87 a2 01 00 00    	ja     101e69 <trap_dispatch+0x1de>
  101cc7:	83 f8 2e             	cmp    $0x2e,%eax
  101cca:	0f 83 cf 01 00 00    	jae    101e9f <trap_dispatch+0x214>
  101cd0:	83 f8 24             	cmp    $0x24,%eax
  101cd3:	74 52                	je     101d27 <trap_dispatch+0x9c>
  101cd5:	83 f8 24             	cmp    $0x24,%eax
  101cd8:	0f 87 8b 01 00 00    	ja     101e69 <trap_dispatch+0x1de>
  101cde:	83 f8 20             	cmp    $0x20,%eax
  101ce1:	74 0a                	je     101ced <trap_dispatch+0x62>
  101ce3:	83 f8 21             	cmp    $0x21,%eax
  101ce6:	74 66                	je     101d4e <trap_dispatch+0xc3>
  101ce8:	e9 7c 01 00 00       	jmp    101e69 <trap_dispatch+0x1de>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
  101ced:	a1 44 fe 10 00       	mov    0x10fe44,%eax
  101cf2:	83 c0 01             	add    $0x1,%eax
  101cf5:	a3 44 fe 10 00       	mov    %eax,0x10fe44
        if (ticks % TICK_NUM == 0) {
  101cfa:	8b 0d 44 fe 10 00    	mov    0x10fe44,%ecx
  101d00:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101d05:	89 c8                	mov    %ecx,%eax
  101d07:	f7 e2                	mul    %edx
  101d09:	89 d0                	mov    %edx,%eax
  101d0b:	c1 e8 05             	shr    $0x5,%eax
  101d0e:	6b d0 64             	imul   $0x64,%eax,%edx
  101d11:	89 c8                	mov    %ecx,%eax
  101d13:	29 d0                	sub    %edx,%eax
  101d15:	85 c0                	test   %eax,%eax
  101d17:	0f 85 85 01 00 00    	jne    101ea2 <trap_dispatch+0x217>
            print_ticks();
  101d1d:	e8 fb fa ff ff       	call   10181d <print_ticks>
        }
        break;
  101d22:	e9 7b 01 00 00       	jmp    101ea2 <trap_dispatch+0x217>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101d27:	e8 b2 f8 ff ff       	call   1015de <cons_getc>
  101d2c:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101d2f:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101d33:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101d37:	83 ec 04             	sub    $0x4,%esp
  101d3a:	52                   	push   %edx
  101d3b:	50                   	push   %eax
  101d3c:	68 74 3a 10 00       	push   $0x103a74
  101d41:	e8 c5 e5 ff ff       	call   10030b <cprintf>
  101d46:	83 c4 10             	add    $0x10,%esp
        break;
  101d49:	e9 5b 01 00 00       	jmp    101ea9 <trap_dispatch+0x21e>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101d4e:	e8 8b f8 ff ff       	call   1015de <cons_getc>
  101d53:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101d56:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101d5a:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101d5e:	83 ec 04             	sub    $0x4,%esp
  101d61:	52                   	push   %edx
  101d62:	50                   	push   %eax
  101d63:	68 86 3a 10 00       	push   $0x103a86
  101d68:	e8 9e e5 ff ff       	call   10030b <cprintf>
  101d6d:	83 c4 10             	add    $0x10,%esp
        break;
  101d70:	e9 34 01 00 00       	jmp    101ea9 <trap_dispatch+0x21e>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
        if (tf->tf_cs != USER_CS) {
  101d75:	8b 45 08             	mov    0x8(%ebp),%eax
  101d78:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101d7c:	66 83 f8 1b          	cmp    $0x1b,%ax
  101d80:	0f 84 1f 01 00 00    	je     101ea5 <trap_dispatch+0x21a>
            switchk2u = *tf;
  101d86:	8b 45 08             	mov    0x8(%ebp),%eax
  101d89:	ba a0 00 11 00       	mov    $0x1100a0,%edx
  101d8e:	89 c3                	mov    %eax,%ebx
  101d90:	b8 13 00 00 00       	mov    $0x13,%eax
  101d95:	89 d7                	mov    %edx,%edi
  101d97:	89 de                	mov    %ebx,%esi
  101d99:	89 c1                	mov    %eax,%ecx
  101d9b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
            switchk2u.tf_cs = USER_CS;
  101d9d:	66 c7 05 dc 00 11 00 	movw   $0x1b,0x1100dc
  101da4:	1b 00 
            switchk2u.tf_ds = switchk2u.tf_es = switchk2u.tf_ss = USER_DS;
  101da6:	66 c7 05 e8 00 11 00 	movw   $0x23,0x1100e8
  101dad:	23 00 
  101daf:	0f b7 05 e8 00 11 00 	movzwl 0x1100e8,%eax
  101db6:	66 a3 c8 00 11 00    	mov    %ax,0x1100c8
  101dbc:	0f b7 05 c8 00 11 00 	movzwl 0x1100c8,%eax
  101dc3:	66 a3 cc 00 11 00    	mov    %ax,0x1100cc
            switchk2u.tf_esp = (uint32_t)tf + sizeof(struct trapframe) - 8;
  101dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  101dcc:	83 c0 44             	add    $0x44,%eax
  101dcf:	a3 e4 00 11 00       	mov    %eax,0x1100e4
		
            // set eflags, make sure ucore can use io under user mode.
            // if CPL > IOPL, then cpu will generate a general protection.
            switchk2u.tf_eflags |= FL_IOPL_MASK;
  101dd4:	a1 e0 00 11 00       	mov    0x1100e0,%eax
  101dd9:	80 cc 30             	or     $0x30,%ah
  101ddc:	a3 e0 00 11 00       	mov    %eax,0x1100e0
		
            // set temporary stack
            // then iret will jump to the right stack
            *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
  101de1:	8b 45 08             	mov    0x8(%ebp),%eax
  101de4:	83 e8 04             	sub    $0x4,%eax
  101de7:	ba a0 00 11 00       	mov    $0x1100a0,%edx
  101dec:	89 10                	mov    %edx,(%eax)
        }
        break;
  101dee:	e9 b2 00 00 00       	jmp    101ea5 <trap_dispatch+0x21a>
    case T_SWITCH_TOK:
        if (tf->tf_cs != KERNEL_CS) {
  101df3:	8b 45 08             	mov    0x8(%ebp),%eax
  101df6:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101dfa:	66 83 f8 08          	cmp    $0x8,%ax
  101dfe:	0f 84 a4 00 00 00    	je     101ea8 <trap_dispatch+0x21d>
            tf->tf_cs = KERNEL_CS;
  101e04:	8b 45 08             	mov    0x8(%ebp),%eax
  101e07:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            tf->tf_ds = tf->tf_es = KERNEL_DS;
  101e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  101e10:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
  101e16:	8b 45 08             	mov    0x8(%ebp),%eax
  101e19:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  101e20:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            tf->tf_eflags &= ~FL_IOPL_MASK;
  101e24:	8b 45 08             	mov    0x8(%ebp),%eax
  101e27:	8b 40 40             	mov    0x40(%eax),%eax
  101e2a:	80 e4 cf             	and    $0xcf,%ah
  101e2d:	89 c2                	mov    %eax,%edx
  101e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  101e32:	89 50 40             	mov    %edx,0x40(%eax)
            switchu2k = (struct trapframe *)(tf->tf_esp - (sizeof(struct trapframe) - 8));
  101e35:	8b 45 08             	mov    0x8(%ebp),%eax
  101e38:	8b 40 44             	mov    0x44(%eax),%eax
  101e3b:	83 e8 44             	sub    $0x44,%eax
  101e3e:	a3 ec 00 11 00       	mov    %eax,0x1100ec
            memmove(switchu2k, tf, sizeof(struct trapframe) - 8);
  101e43:	a1 ec 00 11 00       	mov    0x1100ec,%eax
  101e48:	83 ec 04             	sub    $0x4,%esp
  101e4b:	6a 44                	push   $0x44
  101e4d:	ff 75 08             	push   0x8(%ebp)
  101e50:	50                   	push   %eax
  101e51:	e8 bd 15 00 00       	call   103413 <memmove>
  101e56:	83 c4 10             	add    $0x10,%esp
            *((uint32_t *)tf - 1) = (uint32_t)switchu2k;
  101e59:	8b 15 ec 00 11 00    	mov    0x1100ec,%edx
  101e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  101e62:	83 e8 04             	sub    $0x4,%eax
  101e65:	89 10                	mov    %edx,(%eax)
        }
        break;
  101e67:	eb 3f                	jmp    101ea8 <trap_dispatch+0x21d>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101e69:	8b 45 08             	mov    0x8(%ebp),%eax
  101e6c:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101e70:	0f b7 c0             	movzwl %ax,%eax
  101e73:	83 e0 03             	and    $0x3,%eax
  101e76:	85 c0                	test   %eax,%eax
  101e78:	75 2f                	jne    101ea9 <trap_dispatch+0x21e>
            print_trapframe(tf);
  101e7a:	83 ec 0c             	sub    $0xc,%esp
  101e7d:	ff 75 08             	push   0x8(%ebp)
  101e80:	e8 6d fb ff ff       	call   1019f2 <print_trapframe>
  101e85:	83 c4 10             	add    $0x10,%esp
            panic("unexpected trap in kernel.\n");
  101e88:	83 ec 04             	sub    $0x4,%esp
  101e8b:	68 95 3a 10 00       	push   $0x103a95
  101e90:	68 d2 00 00 00       	push   $0xd2
  101e95:	68 b1 3a 10 00       	push   $0x103ab1
  101e9a:	e8 cb ed ff ff       	call   100c6a <__panic>
        break;
  101e9f:	90                   	nop
  101ea0:	eb 07                	jmp    101ea9 <trap_dispatch+0x21e>
        break;
  101ea2:	90                   	nop
  101ea3:	eb 04                	jmp    101ea9 <trap_dispatch+0x21e>
        break;
  101ea5:	90                   	nop
  101ea6:	eb 01                	jmp    101ea9 <trap_dispatch+0x21e>
        break;
  101ea8:	90                   	nop
        }
    }
}
  101ea9:	90                   	nop
  101eaa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  101ead:	5b                   	pop    %ebx
  101eae:	5e                   	pop    %esi
  101eaf:	5f                   	pop    %edi
  101eb0:	5d                   	pop    %ebp
  101eb1:	c3                   	ret    

00101eb2 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101eb2:	55                   	push   %ebp
  101eb3:	89 e5                	mov    %esp,%ebp
  101eb5:	83 ec 08             	sub    $0x8,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101eb8:	83 ec 0c             	sub    $0xc,%esp
  101ebb:	ff 75 08             	push   0x8(%ebp)
  101ebe:	e8 c8 fd ff ff       	call   101c8b <trap_dispatch>
  101ec3:	83 c4 10             	add    $0x10,%esp
}
  101ec6:	90                   	nop
  101ec7:	c9                   	leave  
  101ec8:	c3                   	ret    

00101ec9 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101ec9:	1e                   	push   %ds
    pushl %es
  101eca:	06                   	push   %es
    pushl %fs
  101ecb:	0f a0                	push   %fs
    pushl %gs
  101ecd:	0f a8                	push   %gs
    pushal
  101ecf:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101ed0:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101ed5:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101ed7:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101ed9:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101eda:	e8 d3 ff ff ff       	call   101eb2 <trap>

    # pop the pushed stack pointer
    popl %esp
  101edf:	5c                   	pop    %esp

00101ee0 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101ee0:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101ee1:	0f a9                	pop    %gs
    popl %fs
  101ee3:	0f a1                	pop    %fs
    popl %es
  101ee5:	07                   	pop    %es
    popl %ds
  101ee6:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101ee7:	83 c4 08             	add    $0x8,%esp
    iret
  101eea:	cf                   	iret   

00101eeb <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101eeb:	6a 00                	push   $0x0
  pushl $0
  101eed:	6a 00                	push   $0x0
  jmp __alltraps
  101eef:	e9 d5 ff ff ff       	jmp    101ec9 <__alltraps>

00101ef4 <vector1>:
.globl vector1
vector1:
  pushl $0
  101ef4:	6a 00                	push   $0x0
  pushl $1
  101ef6:	6a 01                	push   $0x1
  jmp __alltraps
  101ef8:	e9 cc ff ff ff       	jmp    101ec9 <__alltraps>

00101efd <vector2>:
.globl vector2
vector2:
  pushl $0
  101efd:	6a 00                	push   $0x0
  pushl $2
  101eff:	6a 02                	push   $0x2
  jmp __alltraps
  101f01:	e9 c3 ff ff ff       	jmp    101ec9 <__alltraps>

00101f06 <vector3>:
.globl vector3
vector3:
  pushl $0
  101f06:	6a 00                	push   $0x0
  pushl $3
  101f08:	6a 03                	push   $0x3
  jmp __alltraps
  101f0a:	e9 ba ff ff ff       	jmp    101ec9 <__alltraps>

00101f0f <vector4>:
.globl vector4
vector4:
  pushl $0
  101f0f:	6a 00                	push   $0x0
  pushl $4
  101f11:	6a 04                	push   $0x4
  jmp __alltraps
  101f13:	e9 b1 ff ff ff       	jmp    101ec9 <__alltraps>

00101f18 <vector5>:
.globl vector5
vector5:
  pushl $0
  101f18:	6a 00                	push   $0x0
  pushl $5
  101f1a:	6a 05                	push   $0x5
  jmp __alltraps
  101f1c:	e9 a8 ff ff ff       	jmp    101ec9 <__alltraps>

00101f21 <vector6>:
.globl vector6
vector6:
  pushl $0
  101f21:	6a 00                	push   $0x0
  pushl $6
  101f23:	6a 06                	push   $0x6
  jmp __alltraps
  101f25:	e9 9f ff ff ff       	jmp    101ec9 <__alltraps>

00101f2a <vector7>:
.globl vector7
vector7:
  pushl $0
  101f2a:	6a 00                	push   $0x0
  pushl $7
  101f2c:	6a 07                	push   $0x7
  jmp __alltraps
  101f2e:	e9 96 ff ff ff       	jmp    101ec9 <__alltraps>

00101f33 <vector8>:
.globl vector8
vector8:
  pushl $8
  101f33:	6a 08                	push   $0x8
  jmp __alltraps
  101f35:	e9 8f ff ff ff       	jmp    101ec9 <__alltraps>

00101f3a <vector9>:
.globl vector9
vector9:
  pushl $9
  101f3a:	6a 09                	push   $0x9
  jmp __alltraps
  101f3c:	e9 88 ff ff ff       	jmp    101ec9 <__alltraps>

00101f41 <vector10>:
.globl vector10
vector10:
  pushl $10
  101f41:	6a 0a                	push   $0xa
  jmp __alltraps
  101f43:	e9 81 ff ff ff       	jmp    101ec9 <__alltraps>

00101f48 <vector11>:
.globl vector11
vector11:
  pushl $11
  101f48:	6a 0b                	push   $0xb
  jmp __alltraps
  101f4a:	e9 7a ff ff ff       	jmp    101ec9 <__alltraps>

00101f4f <vector12>:
.globl vector12
vector12:
  pushl $12
  101f4f:	6a 0c                	push   $0xc
  jmp __alltraps
  101f51:	e9 73 ff ff ff       	jmp    101ec9 <__alltraps>

00101f56 <vector13>:
.globl vector13
vector13:
  pushl $13
  101f56:	6a 0d                	push   $0xd
  jmp __alltraps
  101f58:	e9 6c ff ff ff       	jmp    101ec9 <__alltraps>

00101f5d <vector14>:
.globl vector14
vector14:
  pushl $14
  101f5d:	6a 0e                	push   $0xe
  jmp __alltraps
  101f5f:	e9 65 ff ff ff       	jmp    101ec9 <__alltraps>

00101f64 <vector15>:
.globl vector15
vector15:
  pushl $0
  101f64:	6a 00                	push   $0x0
  pushl $15
  101f66:	6a 0f                	push   $0xf
  jmp __alltraps
  101f68:	e9 5c ff ff ff       	jmp    101ec9 <__alltraps>

00101f6d <vector16>:
.globl vector16
vector16:
  pushl $0
  101f6d:	6a 00                	push   $0x0
  pushl $16
  101f6f:	6a 10                	push   $0x10
  jmp __alltraps
  101f71:	e9 53 ff ff ff       	jmp    101ec9 <__alltraps>

00101f76 <vector17>:
.globl vector17
vector17:
  pushl $17
  101f76:	6a 11                	push   $0x11
  jmp __alltraps
  101f78:	e9 4c ff ff ff       	jmp    101ec9 <__alltraps>

00101f7d <vector18>:
.globl vector18
vector18:
  pushl $0
  101f7d:	6a 00                	push   $0x0
  pushl $18
  101f7f:	6a 12                	push   $0x12
  jmp __alltraps
  101f81:	e9 43 ff ff ff       	jmp    101ec9 <__alltraps>

00101f86 <vector19>:
.globl vector19
vector19:
  pushl $0
  101f86:	6a 00                	push   $0x0
  pushl $19
  101f88:	6a 13                	push   $0x13
  jmp __alltraps
  101f8a:	e9 3a ff ff ff       	jmp    101ec9 <__alltraps>

00101f8f <vector20>:
.globl vector20
vector20:
  pushl $0
  101f8f:	6a 00                	push   $0x0
  pushl $20
  101f91:	6a 14                	push   $0x14
  jmp __alltraps
  101f93:	e9 31 ff ff ff       	jmp    101ec9 <__alltraps>

00101f98 <vector21>:
.globl vector21
vector21:
  pushl $0
  101f98:	6a 00                	push   $0x0
  pushl $21
  101f9a:	6a 15                	push   $0x15
  jmp __alltraps
  101f9c:	e9 28 ff ff ff       	jmp    101ec9 <__alltraps>

00101fa1 <vector22>:
.globl vector22
vector22:
  pushl $0
  101fa1:	6a 00                	push   $0x0
  pushl $22
  101fa3:	6a 16                	push   $0x16
  jmp __alltraps
  101fa5:	e9 1f ff ff ff       	jmp    101ec9 <__alltraps>

00101faa <vector23>:
.globl vector23
vector23:
  pushl $0
  101faa:	6a 00                	push   $0x0
  pushl $23
  101fac:	6a 17                	push   $0x17
  jmp __alltraps
  101fae:	e9 16 ff ff ff       	jmp    101ec9 <__alltraps>

00101fb3 <vector24>:
.globl vector24
vector24:
  pushl $0
  101fb3:	6a 00                	push   $0x0
  pushl $24
  101fb5:	6a 18                	push   $0x18
  jmp __alltraps
  101fb7:	e9 0d ff ff ff       	jmp    101ec9 <__alltraps>

00101fbc <vector25>:
.globl vector25
vector25:
  pushl $0
  101fbc:	6a 00                	push   $0x0
  pushl $25
  101fbe:	6a 19                	push   $0x19
  jmp __alltraps
  101fc0:	e9 04 ff ff ff       	jmp    101ec9 <__alltraps>

00101fc5 <vector26>:
.globl vector26
vector26:
  pushl $0
  101fc5:	6a 00                	push   $0x0
  pushl $26
  101fc7:	6a 1a                	push   $0x1a
  jmp __alltraps
  101fc9:	e9 fb fe ff ff       	jmp    101ec9 <__alltraps>

00101fce <vector27>:
.globl vector27
vector27:
  pushl $0
  101fce:	6a 00                	push   $0x0
  pushl $27
  101fd0:	6a 1b                	push   $0x1b
  jmp __alltraps
  101fd2:	e9 f2 fe ff ff       	jmp    101ec9 <__alltraps>

00101fd7 <vector28>:
.globl vector28
vector28:
  pushl $0
  101fd7:	6a 00                	push   $0x0
  pushl $28
  101fd9:	6a 1c                	push   $0x1c
  jmp __alltraps
  101fdb:	e9 e9 fe ff ff       	jmp    101ec9 <__alltraps>

00101fe0 <vector29>:
.globl vector29
vector29:
  pushl $0
  101fe0:	6a 00                	push   $0x0
  pushl $29
  101fe2:	6a 1d                	push   $0x1d
  jmp __alltraps
  101fe4:	e9 e0 fe ff ff       	jmp    101ec9 <__alltraps>

00101fe9 <vector30>:
.globl vector30
vector30:
  pushl $0
  101fe9:	6a 00                	push   $0x0
  pushl $30
  101feb:	6a 1e                	push   $0x1e
  jmp __alltraps
  101fed:	e9 d7 fe ff ff       	jmp    101ec9 <__alltraps>

00101ff2 <vector31>:
.globl vector31
vector31:
  pushl $0
  101ff2:	6a 00                	push   $0x0
  pushl $31
  101ff4:	6a 1f                	push   $0x1f
  jmp __alltraps
  101ff6:	e9 ce fe ff ff       	jmp    101ec9 <__alltraps>

00101ffb <vector32>:
.globl vector32
vector32:
  pushl $0
  101ffb:	6a 00                	push   $0x0
  pushl $32
  101ffd:	6a 20                	push   $0x20
  jmp __alltraps
  101fff:	e9 c5 fe ff ff       	jmp    101ec9 <__alltraps>

00102004 <vector33>:
.globl vector33
vector33:
  pushl $0
  102004:	6a 00                	push   $0x0
  pushl $33
  102006:	6a 21                	push   $0x21
  jmp __alltraps
  102008:	e9 bc fe ff ff       	jmp    101ec9 <__alltraps>

0010200d <vector34>:
.globl vector34
vector34:
  pushl $0
  10200d:	6a 00                	push   $0x0
  pushl $34
  10200f:	6a 22                	push   $0x22
  jmp __alltraps
  102011:	e9 b3 fe ff ff       	jmp    101ec9 <__alltraps>

00102016 <vector35>:
.globl vector35
vector35:
  pushl $0
  102016:	6a 00                	push   $0x0
  pushl $35
  102018:	6a 23                	push   $0x23
  jmp __alltraps
  10201a:	e9 aa fe ff ff       	jmp    101ec9 <__alltraps>

0010201f <vector36>:
.globl vector36
vector36:
  pushl $0
  10201f:	6a 00                	push   $0x0
  pushl $36
  102021:	6a 24                	push   $0x24
  jmp __alltraps
  102023:	e9 a1 fe ff ff       	jmp    101ec9 <__alltraps>

00102028 <vector37>:
.globl vector37
vector37:
  pushl $0
  102028:	6a 00                	push   $0x0
  pushl $37
  10202a:	6a 25                	push   $0x25
  jmp __alltraps
  10202c:	e9 98 fe ff ff       	jmp    101ec9 <__alltraps>

00102031 <vector38>:
.globl vector38
vector38:
  pushl $0
  102031:	6a 00                	push   $0x0
  pushl $38
  102033:	6a 26                	push   $0x26
  jmp __alltraps
  102035:	e9 8f fe ff ff       	jmp    101ec9 <__alltraps>

0010203a <vector39>:
.globl vector39
vector39:
  pushl $0
  10203a:	6a 00                	push   $0x0
  pushl $39
  10203c:	6a 27                	push   $0x27
  jmp __alltraps
  10203e:	e9 86 fe ff ff       	jmp    101ec9 <__alltraps>

00102043 <vector40>:
.globl vector40
vector40:
  pushl $0
  102043:	6a 00                	push   $0x0
  pushl $40
  102045:	6a 28                	push   $0x28
  jmp __alltraps
  102047:	e9 7d fe ff ff       	jmp    101ec9 <__alltraps>

0010204c <vector41>:
.globl vector41
vector41:
  pushl $0
  10204c:	6a 00                	push   $0x0
  pushl $41
  10204e:	6a 29                	push   $0x29
  jmp __alltraps
  102050:	e9 74 fe ff ff       	jmp    101ec9 <__alltraps>

00102055 <vector42>:
.globl vector42
vector42:
  pushl $0
  102055:	6a 00                	push   $0x0
  pushl $42
  102057:	6a 2a                	push   $0x2a
  jmp __alltraps
  102059:	e9 6b fe ff ff       	jmp    101ec9 <__alltraps>

0010205e <vector43>:
.globl vector43
vector43:
  pushl $0
  10205e:	6a 00                	push   $0x0
  pushl $43
  102060:	6a 2b                	push   $0x2b
  jmp __alltraps
  102062:	e9 62 fe ff ff       	jmp    101ec9 <__alltraps>

00102067 <vector44>:
.globl vector44
vector44:
  pushl $0
  102067:	6a 00                	push   $0x0
  pushl $44
  102069:	6a 2c                	push   $0x2c
  jmp __alltraps
  10206b:	e9 59 fe ff ff       	jmp    101ec9 <__alltraps>

00102070 <vector45>:
.globl vector45
vector45:
  pushl $0
  102070:	6a 00                	push   $0x0
  pushl $45
  102072:	6a 2d                	push   $0x2d
  jmp __alltraps
  102074:	e9 50 fe ff ff       	jmp    101ec9 <__alltraps>

00102079 <vector46>:
.globl vector46
vector46:
  pushl $0
  102079:	6a 00                	push   $0x0
  pushl $46
  10207b:	6a 2e                	push   $0x2e
  jmp __alltraps
  10207d:	e9 47 fe ff ff       	jmp    101ec9 <__alltraps>

00102082 <vector47>:
.globl vector47
vector47:
  pushl $0
  102082:	6a 00                	push   $0x0
  pushl $47
  102084:	6a 2f                	push   $0x2f
  jmp __alltraps
  102086:	e9 3e fe ff ff       	jmp    101ec9 <__alltraps>

0010208b <vector48>:
.globl vector48
vector48:
  pushl $0
  10208b:	6a 00                	push   $0x0
  pushl $48
  10208d:	6a 30                	push   $0x30
  jmp __alltraps
  10208f:	e9 35 fe ff ff       	jmp    101ec9 <__alltraps>

00102094 <vector49>:
.globl vector49
vector49:
  pushl $0
  102094:	6a 00                	push   $0x0
  pushl $49
  102096:	6a 31                	push   $0x31
  jmp __alltraps
  102098:	e9 2c fe ff ff       	jmp    101ec9 <__alltraps>

0010209d <vector50>:
.globl vector50
vector50:
  pushl $0
  10209d:	6a 00                	push   $0x0
  pushl $50
  10209f:	6a 32                	push   $0x32
  jmp __alltraps
  1020a1:	e9 23 fe ff ff       	jmp    101ec9 <__alltraps>

001020a6 <vector51>:
.globl vector51
vector51:
  pushl $0
  1020a6:	6a 00                	push   $0x0
  pushl $51
  1020a8:	6a 33                	push   $0x33
  jmp __alltraps
  1020aa:	e9 1a fe ff ff       	jmp    101ec9 <__alltraps>

001020af <vector52>:
.globl vector52
vector52:
  pushl $0
  1020af:	6a 00                	push   $0x0
  pushl $52
  1020b1:	6a 34                	push   $0x34
  jmp __alltraps
  1020b3:	e9 11 fe ff ff       	jmp    101ec9 <__alltraps>

001020b8 <vector53>:
.globl vector53
vector53:
  pushl $0
  1020b8:	6a 00                	push   $0x0
  pushl $53
  1020ba:	6a 35                	push   $0x35
  jmp __alltraps
  1020bc:	e9 08 fe ff ff       	jmp    101ec9 <__alltraps>

001020c1 <vector54>:
.globl vector54
vector54:
  pushl $0
  1020c1:	6a 00                	push   $0x0
  pushl $54
  1020c3:	6a 36                	push   $0x36
  jmp __alltraps
  1020c5:	e9 ff fd ff ff       	jmp    101ec9 <__alltraps>

001020ca <vector55>:
.globl vector55
vector55:
  pushl $0
  1020ca:	6a 00                	push   $0x0
  pushl $55
  1020cc:	6a 37                	push   $0x37
  jmp __alltraps
  1020ce:	e9 f6 fd ff ff       	jmp    101ec9 <__alltraps>

001020d3 <vector56>:
.globl vector56
vector56:
  pushl $0
  1020d3:	6a 00                	push   $0x0
  pushl $56
  1020d5:	6a 38                	push   $0x38
  jmp __alltraps
  1020d7:	e9 ed fd ff ff       	jmp    101ec9 <__alltraps>

001020dc <vector57>:
.globl vector57
vector57:
  pushl $0
  1020dc:	6a 00                	push   $0x0
  pushl $57
  1020de:	6a 39                	push   $0x39
  jmp __alltraps
  1020e0:	e9 e4 fd ff ff       	jmp    101ec9 <__alltraps>

001020e5 <vector58>:
.globl vector58
vector58:
  pushl $0
  1020e5:	6a 00                	push   $0x0
  pushl $58
  1020e7:	6a 3a                	push   $0x3a
  jmp __alltraps
  1020e9:	e9 db fd ff ff       	jmp    101ec9 <__alltraps>

001020ee <vector59>:
.globl vector59
vector59:
  pushl $0
  1020ee:	6a 00                	push   $0x0
  pushl $59
  1020f0:	6a 3b                	push   $0x3b
  jmp __alltraps
  1020f2:	e9 d2 fd ff ff       	jmp    101ec9 <__alltraps>

001020f7 <vector60>:
.globl vector60
vector60:
  pushl $0
  1020f7:	6a 00                	push   $0x0
  pushl $60
  1020f9:	6a 3c                	push   $0x3c
  jmp __alltraps
  1020fb:	e9 c9 fd ff ff       	jmp    101ec9 <__alltraps>

00102100 <vector61>:
.globl vector61
vector61:
  pushl $0
  102100:	6a 00                	push   $0x0
  pushl $61
  102102:	6a 3d                	push   $0x3d
  jmp __alltraps
  102104:	e9 c0 fd ff ff       	jmp    101ec9 <__alltraps>

00102109 <vector62>:
.globl vector62
vector62:
  pushl $0
  102109:	6a 00                	push   $0x0
  pushl $62
  10210b:	6a 3e                	push   $0x3e
  jmp __alltraps
  10210d:	e9 b7 fd ff ff       	jmp    101ec9 <__alltraps>

00102112 <vector63>:
.globl vector63
vector63:
  pushl $0
  102112:	6a 00                	push   $0x0
  pushl $63
  102114:	6a 3f                	push   $0x3f
  jmp __alltraps
  102116:	e9 ae fd ff ff       	jmp    101ec9 <__alltraps>

0010211b <vector64>:
.globl vector64
vector64:
  pushl $0
  10211b:	6a 00                	push   $0x0
  pushl $64
  10211d:	6a 40                	push   $0x40
  jmp __alltraps
  10211f:	e9 a5 fd ff ff       	jmp    101ec9 <__alltraps>

00102124 <vector65>:
.globl vector65
vector65:
  pushl $0
  102124:	6a 00                	push   $0x0
  pushl $65
  102126:	6a 41                	push   $0x41
  jmp __alltraps
  102128:	e9 9c fd ff ff       	jmp    101ec9 <__alltraps>

0010212d <vector66>:
.globl vector66
vector66:
  pushl $0
  10212d:	6a 00                	push   $0x0
  pushl $66
  10212f:	6a 42                	push   $0x42
  jmp __alltraps
  102131:	e9 93 fd ff ff       	jmp    101ec9 <__alltraps>

00102136 <vector67>:
.globl vector67
vector67:
  pushl $0
  102136:	6a 00                	push   $0x0
  pushl $67
  102138:	6a 43                	push   $0x43
  jmp __alltraps
  10213a:	e9 8a fd ff ff       	jmp    101ec9 <__alltraps>

0010213f <vector68>:
.globl vector68
vector68:
  pushl $0
  10213f:	6a 00                	push   $0x0
  pushl $68
  102141:	6a 44                	push   $0x44
  jmp __alltraps
  102143:	e9 81 fd ff ff       	jmp    101ec9 <__alltraps>

00102148 <vector69>:
.globl vector69
vector69:
  pushl $0
  102148:	6a 00                	push   $0x0
  pushl $69
  10214a:	6a 45                	push   $0x45
  jmp __alltraps
  10214c:	e9 78 fd ff ff       	jmp    101ec9 <__alltraps>

00102151 <vector70>:
.globl vector70
vector70:
  pushl $0
  102151:	6a 00                	push   $0x0
  pushl $70
  102153:	6a 46                	push   $0x46
  jmp __alltraps
  102155:	e9 6f fd ff ff       	jmp    101ec9 <__alltraps>

0010215a <vector71>:
.globl vector71
vector71:
  pushl $0
  10215a:	6a 00                	push   $0x0
  pushl $71
  10215c:	6a 47                	push   $0x47
  jmp __alltraps
  10215e:	e9 66 fd ff ff       	jmp    101ec9 <__alltraps>

00102163 <vector72>:
.globl vector72
vector72:
  pushl $0
  102163:	6a 00                	push   $0x0
  pushl $72
  102165:	6a 48                	push   $0x48
  jmp __alltraps
  102167:	e9 5d fd ff ff       	jmp    101ec9 <__alltraps>

0010216c <vector73>:
.globl vector73
vector73:
  pushl $0
  10216c:	6a 00                	push   $0x0
  pushl $73
  10216e:	6a 49                	push   $0x49
  jmp __alltraps
  102170:	e9 54 fd ff ff       	jmp    101ec9 <__alltraps>

00102175 <vector74>:
.globl vector74
vector74:
  pushl $0
  102175:	6a 00                	push   $0x0
  pushl $74
  102177:	6a 4a                	push   $0x4a
  jmp __alltraps
  102179:	e9 4b fd ff ff       	jmp    101ec9 <__alltraps>

0010217e <vector75>:
.globl vector75
vector75:
  pushl $0
  10217e:	6a 00                	push   $0x0
  pushl $75
  102180:	6a 4b                	push   $0x4b
  jmp __alltraps
  102182:	e9 42 fd ff ff       	jmp    101ec9 <__alltraps>

00102187 <vector76>:
.globl vector76
vector76:
  pushl $0
  102187:	6a 00                	push   $0x0
  pushl $76
  102189:	6a 4c                	push   $0x4c
  jmp __alltraps
  10218b:	e9 39 fd ff ff       	jmp    101ec9 <__alltraps>

00102190 <vector77>:
.globl vector77
vector77:
  pushl $0
  102190:	6a 00                	push   $0x0
  pushl $77
  102192:	6a 4d                	push   $0x4d
  jmp __alltraps
  102194:	e9 30 fd ff ff       	jmp    101ec9 <__alltraps>

00102199 <vector78>:
.globl vector78
vector78:
  pushl $0
  102199:	6a 00                	push   $0x0
  pushl $78
  10219b:	6a 4e                	push   $0x4e
  jmp __alltraps
  10219d:	e9 27 fd ff ff       	jmp    101ec9 <__alltraps>

001021a2 <vector79>:
.globl vector79
vector79:
  pushl $0
  1021a2:	6a 00                	push   $0x0
  pushl $79
  1021a4:	6a 4f                	push   $0x4f
  jmp __alltraps
  1021a6:	e9 1e fd ff ff       	jmp    101ec9 <__alltraps>

001021ab <vector80>:
.globl vector80
vector80:
  pushl $0
  1021ab:	6a 00                	push   $0x0
  pushl $80
  1021ad:	6a 50                	push   $0x50
  jmp __alltraps
  1021af:	e9 15 fd ff ff       	jmp    101ec9 <__alltraps>

001021b4 <vector81>:
.globl vector81
vector81:
  pushl $0
  1021b4:	6a 00                	push   $0x0
  pushl $81
  1021b6:	6a 51                	push   $0x51
  jmp __alltraps
  1021b8:	e9 0c fd ff ff       	jmp    101ec9 <__alltraps>

001021bd <vector82>:
.globl vector82
vector82:
  pushl $0
  1021bd:	6a 00                	push   $0x0
  pushl $82
  1021bf:	6a 52                	push   $0x52
  jmp __alltraps
  1021c1:	e9 03 fd ff ff       	jmp    101ec9 <__alltraps>

001021c6 <vector83>:
.globl vector83
vector83:
  pushl $0
  1021c6:	6a 00                	push   $0x0
  pushl $83
  1021c8:	6a 53                	push   $0x53
  jmp __alltraps
  1021ca:	e9 fa fc ff ff       	jmp    101ec9 <__alltraps>

001021cf <vector84>:
.globl vector84
vector84:
  pushl $0
  1021cf:	6a 00                	push   $0x0
  pushl $84
  1021d1:	6a 54                	push   $0x54
  jmp __alltraps
  1021d3:	e9 f1 fc ff ff       	jmp    101ec9 <__alltraps>

001021d8 <vector85>:
.globl vector85
vector85:
  pushl $0
  1021d8:	6a 00                	push   $0x0
  pushl $85
  1021da:	6a 55                	push   $0x55
  jmp __alltraps
  1021dc:	e9 e8 fc ff ff       	jmp    101ec9 <__alltraps>

001021e1 <vector86>:
.globl vector86
vector86:
  pushl $0
  1021e1:	6a 00                	push   $0x0
  pushl $86
  1021e3:	6a 56                	push   $0x56
  jmp __alltraps
  1021e5:	e9 df fc ff ff       	jmp    101ec9 <__alltraps>

001021ea <vector87>:
.globl vector87
vector87:
  pushl $0
  1021ea:	6a 00                	push   $0x0
  pushl $87
  1021ec:	6a 57                	push   $0x57
  jmp __alltraps
  1021ee:	e9 d6 fc ff ff       	jmp    101ec9 <__alltraps>

001021f3 <vector88>:
.globl vector88
vector88:
  pushl $0
  1021f3:	6a 00                	push   $0x0
  pushl $88
  1021f5:	6a 58                	push   $0x58
  jmp __alltraps
  1021f7:	e9 cd fc ff ff       	jmp    101ec9 <__alltraps>

001021fc <vector89>:
.globl vector89
vector89:
  pushl $0
  1021fc:	6a 00                	push   $0x0
  pushl $89
  1021fe:	6a 59                	push   $0x59
  jmp __alltraps
  102200:	e9 c4 fc ff ff       	jmp    101ec9 <__alltraps>

00102205 <vector90>:
.globl vector90
vector90:
  pushl $0
  102205:	6a 00                	push   $0x0
  pushl $90
  102207:	6a 5a                	push   $0x5a
  jmp __alltraps
  102209:	e9 bb fc ff ff       	jmp    101ec9 <__alltraps>

0010220e <vector91>:
.globl vector91
vector91:
  pushl $0
  10220e:	6a 00                	push   $0x0
  pushl $91
  102210:	6a 5b                	push   $0x5b
  jmp __alltraps
  102212:	e9 b2 fc ff ff       	jmp    101ec9 <__alltraps>

00102217 <vector92>:
.globl vector92
vector92:
  pushl $0
  102217:	6a 00                	push   $0x0
  pushl $92
  102219:	6a 5c                	push   $0x5c
  jmp __alltraps
  10221b:	e9 a9 fc ff ff       	jmp    101ec9 <__alltraps>

00102220 <vector93>:
.globl vector93
vector93:
  pushl $0
  102220:	6a 00                	push   $0x0
  pushl $93
  102222:	6a 5d                	push   $0x5d
  jmp __alltraps
  102224:	e9 a0 fc ff ff       	jmp    101ec9 <__alltraps>

00102229 <vector94>:
.globl vector94
vector94:
  pushl $0
  102229:	6a 00                	push   $0x0
  pushl $94
  10222b:	6a 5e                	push   $0x5e
  jmp __alltraps
  10222d:	e9 97 fc ff ff       	jmp    101ec9 <__alltraps>

00102232 <vector95>:
.globl vector95
vector95:
  pushl $0
  102232:	6a 00                	push   $0x0
  pushl $95
  102234:	6a 5f                	push   $0x5f
  jmp __alltraps
  102236:	e9 8e fc ff ff       	jmp    101ec9 <__alltraps>

0010223b <vector96>:
.globl vector96
vector96:
  pushl $0
  10223b:	6a 00                	push   $0x0
  pushl $96
  10223d:	6a 60                	push   $0x60
  jmp __alltraps
  10223f:	e9 85 fc ff ff       	jmp    101ec9 <__alltraps>

00102244 <vector97>:
.globl vector97
vector97:
  pushl $0
  102244:	6a 00                	push   $0x0
  pushl $97
  102246:	6a 61                	push   $0x61
  jmp __alltraps
  102248:	e9 7c fc ff ff       	jmp    101ec9 <__alltraps>

0010224d <vector98>:
.globl vector98
vector98:
  pushl $0
  10224d:	6a 00                	push   $0x0
  pushl $98
  10224f:	6a 62                	push   $0x62
  jmp __alltraps
  102251:	e9 73 fc ff ff       	jmp    101ec9 <__alltraps>

00102256 <vector99>:
.globl vector99
vector99:
  pushl $0
  102256:	6a 00                	push   $0x0
  pushl $99
  102258:	6a 63                	push   $0x63
  jmp __alltraps
  10225a:	e9 6a fc ff ff       	jmp    101ec9 <__alltraps>

0010225f <vector100>:
.globl vector100
vector100:
  pushl $0
  10225f:	6a 00                	push   $0x0
  pushl $100
  102261:	6a 64                	push   $0x64
  jmp __alltraps
  102263:	e9 61 fc ff ff       	jmp    101ec9 <__alltraps>

00102268 <vector101>:
.globl vector101
vector101:
  pushl $0
  102268:	6a 00                	push   $0x0
  pushl $101
  10226a:	6a 65                	push   $0x65
  jmp __alltraps
  10226c:	e9 58 fc ff ff       	jmp    101ec9 <__alltraps>

00102271 <vector102>:
.globl vector102
vector102:
  pushl $0
  102271:	6a 00                	push   $0x0
  pushl $102
  102273:	6a 66                	push   $0x66
  jmp __alltraps
  102275:	e9 4f fc ff ff       	jmp    101ec9 <__alltraps>

0010227a <vector103>:
.globl vector103
vector103:
  pushl $0
  10227a:	6a 00                	push   $0x0
  pushl $103
  10227c:	6a 67                	push   $0x67
  jmp __alltraps
  10227e:	e9 46 fc ff ff       	jmp    101ec9 <__alltraps>

00102283 <vector104>:
.globl vector104
vector104:
  pushl $0
  102283:	6a 00                	push   $0x0
  pushl $104
  102285:	6a 68                	push   $0x68
  jmp __alltraps
  102287:	e9 3d fc ff ff       	jmp    101ec9 <__alltraps>

0010228c <vector105>:
.globl vector105
vector105:
  pushl $0
  10228c:	6a 00                	push   $0x0
  pushl $105
  10228e:	6a 69                	push   $0x69
  jmp __alltraps
  102290:	e9 34 fc ff ff       	jmp    101ec9 <__alltraps>

00102295 <vector106>:
.globl vector106
vector106:
  pushl $0
  102295:	6a 00                	push   $0x0
  pushl $106
  102297:	6a 6a                	push   $0x6a
  jmp __alltraps
  102299:	e9 2b fc ff ff       	jmp    101ec9 <__alltraps>

0010229e <vector107>:
.globl vector107
vector107:
  pushl $0
  10229e:	6a 00                	push   $0x0
  pushl $107
  1022a0:	6a 6b                	push   $0x6b
  jmp __alltraps
  1022a2:	e9 22 fc ff ff       	jmp    101ec9 <__alltraps>

001022a7 <vector108>:
.globl vector108
vector108:
  pushl $0
  1022a7:	6a 00                	push   $0x0
  pushl $108
  1022a9:	6a 6c                	push   $0x6c
  jmp __alltraps
  1022ab:	e9 19 fc ff ff       	jmp    101ec9 <__alltraps>

001022b0 <vector109>:
.globl vector109
vector109:
  pushl $0
  1022b0:	6a 00                	push   $0x0
  pushl $109
  1022b2:	6a 6d                	push   $0x6d
  jmp __alltraps
  1022b4:	e9 10 fc ff ff       	jmp    101ec9 <__alltraps>

001022b9 <vector110>:
.globl vector110
vector110:
  pushl $0
  1022b9:	6a 00                	push   $0x0
  pushl $110
  1022bb:	6a 6e                	push   $0x6e
  jmp __alltraps
  1022bd:	e9 07 fc ff ff       	jmp    101ec9 <__alltraps>

001022c2 <vector111>:
.globl vector111
vector111:
  pushl $0
  1022c2:	6a 00                	push   $0x0
  pushl $111
  1022c4:	6a 6f                	push   $0x6f
  jmp __alltraps
  1022c6:	e9 fe fb ff ff       	jmp    101ec9 <__alltraps>

001022cb <vector112>:
.globl vector112
vector112:
  pushl $0
  1022cb:	6a 00                	push   $0x0
  pushl $112
  1022cd:	6a 70                	push   $0x70
  jmp __alltraps
  1022cf:	e9 f5 fb ff ff       	jmp    101ec9 <__alltraps>

001022d4 <vector113>:
.globl vector113
vector113:
  pushl $0
  1022d4:	6a 00                	push   $0x0
  pushl $113
  1022d6:	6a 71                	push   $0x71
  jmp __alltraps
  1022d8:	e9 ec fb ff ff       	jmp    101ec9 <__alltraps>

001022dd <vector114>:
.globl vector114
vector114:
  pushl $0
  1022dd:	6a 00                	push   $0x0
  pushl $114
  1022df:	6a 72                	push   $0x72
  jmp __alltraps
  1022e1:	e9 e3 fb ff ff       	jmp    101ec9 <__alltraps>

001022e6 <vector115>:
.globl vector115
vector115:
  pushl $0
  1022e6:	6a 00                	push   $0x0
  pushl $115
  1022e8:	6a 73                	push   $0x73
  jmp __alltraps
  1022ea:	e9 da fb ff ff       	jmp    101ec9 <__alltraps>

001022ef <vector116>:
.globl vector116
vector116:
  pushl $0
  1022ef:	6a 00                	push   $0x0
  pushl $116
  1022f1:	6a 74                	push   $0x74
  jmp __alltraps
  1022f3:	e9 d1 fb ff ff       	jmp    101ec9 <__alltraps>

001022f8 <vector117>:
.globl vector117
vector117:
  pushl $0
  1022f8:	6a 00                	push   $0x0
  pushl $117
  1022fa:	6a 75                	push   $0x75
  jmp __alltraps
  1022fc:	e9 c8 fb ff ff       	jmp    101ec9 <__alltraps>

00102301 <vector118>:
.globl vector118
vector118:
  pushl $0
  102301:	6a 00                	push   $0x0
  pushl $118
  102303:	6a 76                	push   $0x76
  jmp __alltraps
  102305:	e9 bf fb ff ff       	jmp    101ec9 <__alltraps>

0010230a <vector119>:
.globl vector119
vector119:
  pushl $0
  10230a:	6a 00                	push   $0x0
  pushl $119
  10230c:	6a 77                	push   $0x77
  jmp __alltraps
  10230e:	e9 b6 fb ff ff       	jmp    101ec9 <__alltraps>

00102313 <vector120>:
.globl vector120
vector120:
  pushl $0
  102313:	6a 00                	push   $0x0
  pushl $120
  102315:	6a 78                	push   $0x78
  jmp __alltraps
  102317:	e9 ad fb ff ff       	jmp    101ec9 <__alltraps>

0010231c <vector121>:
.globl vector121
vector121:
  pushl $0
  10231c:	6a 00                	push   $0x0
  pushl $121
  10231e:	6a 79                	push   $0x79
  jmp __alltraps
  102320:	e9 a4 fb ff ff       	jmp    101ec9 <__alltraps>

00102325 <vector122>:
.globl vector122
vector122:
  pushl $0
  102325:	6a 00                	push   $0x0
  pushl $122
  102327:	6a 7a                	push   $0x7a
  jmp __alltraps
  102329:	e9 9b fb ff ff       	jmp    101ec9 <__alltraps>

0010232e <vector123>:
.globl vector123
vector123:
  pushl $0
  10232e:	6a 00                	push   $0x0
  pushl $123
  102330:	6a 7b                	push   $0x7b
  jmp __alltraps
  102332:	e9 92 fb ff ff       	jmp    101ec9 <__alltraps>

00102337 <vector124>:
.globl vector124
vector124:
  pushl $0
  102337:	6a 00                	push   $0x0
  pushl $124
  102339:	6a 7c                	push   $0x7c
  jmp __alltraps
  10233b:	e9 89 fb ff ff       	jmp    101ec9 <__alltraps>

00102340 <vector125>:
.globl vector125
vector125:
  pushl $0
  102340:	6a 00                	push   $0x0
  pushl $125
  102342:	6a 7d                	push   $0x7d
  jmp __alltraps
  102344:	e9 80 fb ff ff       	jmp    101ec9 <__alltraps>

00102349 <vector126>:
.globl vector126
vector126:
  pushl $0
  102349:	6a 00                	push   $0x0
  pushl $126
  10234b:	6a 7e                	push   $0x7e
  jmp __alltraps
  10234d:	e9 77 fb ff ff       	jmp    101ec9 <__alltraps>

00102352 <vector127>:
.globl vector127
vector127:
  pushl $0
  102352:	6a 00                	push   $0x0
  pushl $127
  102354:	6a 7f                	push   $0x7f
  jmp __alltraps
  102356:	e9 6e fb ff ff       	jmp    101ec9 <__alltraps>

0010235b <vector128>:
.globl vector128
vector128:
  pushl $0
  10235b:	6a 00                	push   $0x0
  pushl $128
  10235d:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  102362:	e9 62 fb ff ff       	jmp    101ec9 <__alltraps>

00102367 <vector129>:
.globl vector129
vector129:
  pushl $0
  102367:	6a 00                	push   $0x0
  pushl $129
  102369:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  10236e:	e9 56 fb ff ff       	jmp    101ec9 <__alltraps>

00102373 <vector130>:
.globl vector130
vector130:
  pushl $0
  102373:	6a 00                	push   $0x0
  pushl $130
  102375:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  10237a:	e9 4a fb ff ff       	jmp    101ec9 <__alltraps>

0010237f <vector131>:
.globl vector131
vector131:
  pushl $0
  10237f:	6a 00                	push   $0x0
  pushl $131
  102381:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  102386:	e9 3e fb ff ff       	jmp    101ec9 <__alltraps>

0010238b <vector132>:
.globl vector132
vector132:
  pushl $0
  10238b:	6a 00                	push   $0x0
  pushl $132
  10238d:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  102392:	e9 32 fb ff ff       	jmp    101ec9 <__alltraps>

00102397 <vector133>:
.globl vector133
vector133:
  pushl $0
  102397:	6a 00                	push   $0x0
  pushl $133
  102399:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  10239e:	e9 26 fb ff ff       	jmp    101ec9 <__alltraps>

001023a3 <vector134>:
.globl vector134
vector134:
  pushl $0
  1023a3:	6a 00                	push   $0x0
  pushl $134
  1023a5:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  1023aa:	e9 1a fb ff ff       	jmp    101ec9 <__alltraps>

001023af <vector135>:
.globl vector135
vector135:
  pushl $0
  1023af:	6a 00                	push   $0x0
  pushl $135
  1023b1:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  1023b6:	e9 0e fb ff ff       	jmp    101ec9 <__alltraps>

001023bb <vector136>:
.globl vector136
vector136:
  pushl $0
  1023bb:	6a 00                	push   $0x0
  pushl $136
  1023bd:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  1023c2:	e9 02 fb ff ff       	jmp    101ec9 <__alltraps>

001023c7 <vector137>:
.globl vector137
vector137:
  pushl $0
  1023c7:	6a 00                	push   $0x0
  pushl $137
  1023c9:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  1023ce:	e9 f6 fa ff ff       	jmp    101ec9 <__alltraps>

001023d3 <vector138>:
.globl vector138
vector138:
  pushl $0
  1023d3:	6a 00                	push   $0x0
  pushl $138
  1023d5:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  1023da:	e9 ea fa ff ff       	jmp    101ec9 <__alltraps>

001023df <vector139>:
.globl vector139
vector139:
  pushl $0
  1023df:	6a 00                	push   $0x0
  pushl $139
  1023e1:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  1023e6:	e9 de fa ff ff       	jmp    101ec9 <__alltraps>

001023eb <vector140>:
.globl vector140
vector140:
  pushl $0
  1023eb:	6a 00                	push   $0x0
  pushl $140
  1023ed:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  1023f2:	e9 d2 fa ff ff       	jmp    101ec9 <__alltraps>

001023f7 <vector141>:
.globl vector141
vector141:
  pushl $0
  1023f7:	6a 00                	push   $0x0
  pushl $141
  1023f9:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  1023fe:	e9 c6 fa ff ff       	jmp    101ec9 <__alltraps>

00102403 <vector142>:
.globl vector142
vector142:
  pushl $0
  102403:	6a 00                	push   $0x0
  pushl $142
  102405:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  10240a:	e9 ba fa ff ff       	jmp    101ec9 <__alltraps>

0010240f <vector143>:
.globl vector143
vector143:
  pushl $0
  10240f:	6a 00                	push   $0x0
  pushl $143
  102411:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  102416:	e9 ae fa ff ff       	jmp    101ec9 <__alltraps>

0010241b <vector144>:
.globl vector144
vector144:
  pushl $0
  10241b:	6a 00                	push   $0x0
  pushl $144
  10241d:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  102422:	e9 a2 fa ff ff       	jmp    101ec9 <__alltraps>

00102427 <vector145>:
.globl vector145
vector145:
  pushl $0
  102427:	6a 00                	push   $0x0
  pushl $145
  102429:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  10242e:	e9 96 fa ff ff       	jmp    101ec9 <__alltraps>

00102433 <vector146>:
.globl vector146
vector146:
  pushl $0
  102433:	6a 00                	push   $0x0
  pushl $146
  102435:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  10243a:	e9 8a fa ff ff       	jmp    101ec9 <__alltraps>

0010243f <vector147>:
.globl vector147
vector147:
  pushl $0
  10243f:	6a 00                	push   $0x0
  pushl $147
  102441:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  102446:	e9 7e fa ff ff       	jmp    101ec9 <__alltraps>

0010244b <vector148>:
.globl vector148
vector148:
  pushl $0
  10244b:	6a 00                	push   $0x0
  pushl $148
  10244d:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  102452:	e9 72 fa ff ff       	jmp    101ec9 <__alltraps>

00102457 <vector149>:
.globl vector149
vector149:
  pushl $0
  102457:	6a 00                	push   $0x0
  pushl $149
  102459:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  10245e:	e9 66 fa ff ff       	jmp    101ec9 <__alltraps>

00102463 <vector150>:
.globl vector150
vector150:
  pushl $0
  102463:	6a 00                	push   $0x0
  pushl $150
  102465:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  10246a:	e9 5a fa ff ff       	jmp    101ec9 <__alltraps>

0010246f <vector151>:
.globl vector151
vector151:
  pushl $0
  10246f:	6a 00                	push   $0x0
  pushl $151
  102471:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  102476:	e9 4e fa ff ff       	jmp    101ec9 <__alltraps>

0010247b <vector152>:
.globl vector152
vector152:
  pushl $0
  10247b:	6a 00                	push   $0x0
  pushl $152
  10247d:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  102482:	e9 42 fa ff ff       	jmp    101ec9 <__alltraps>

00102487 <vector153>:
.globl vector153
vector153:
  pushl $0
  102487:	6a 00                	push   $0x0
  pushl $153
  102489:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  10248e:	e9 36 fa ff ff       	jmp    101ec9 <__alltraps>

00102493 <vector154>:
.globl vector154
vector154:
  pushl $0
  102493:	6a 00                	push   $0x0
  pushl $154
  102495:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  10249a:	e9 2a fa ff ff       	jmp    101ec9 <__alltraps>

0010249f <vector155>:
.globl vector155
vector155:
  pushl $0
  10249f:	6a 00                	push   $0x0
  pushl $155
  1024a1:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  1024a6:	e9 1e fa ff ff       	jmp    101ec9 <__alltraps>

001024ab <vector156>:
.globl vector156
vector156:
  pushl $0
  1024ab:	6a 00                	push   $0x0
  pushl $156
  1024ad:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  1024b2:	e9 12 fa ff ff       	jmp    101ec9 <__alltraps>

001024b7 <vector157>:
.globl vector157
vector157:
  pushl $0
  1024b7:	6a 00                	push   $0x0
  pushl $157
  1024b9:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  1024be:	e9 06 fa ff ff       	jmp    101ec9 <__alltraps>

001024c3 <vector158>:
.globl vector158
vector158:
  pushl $0
  1024c3:	6a 00                	push   $0x0
  pushl $158
  1024c5:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  1024ca:	e9 fa f9 ff ff       	jmp    101ec9 <__alltraps>

001024cf <vector159>:
.globl vector159
vector159:
  pushl $0
  1024cf:	6a 00                	push   $0x0
  pushl $159
  1024d1:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  1024d6:	e9 ee f9 ff ff       	jmp    101ec9 <__alltraps>

001024db <vector160>:
.globl vector160
vector160:
  pushl $0
  1024db:	6a 00                	push   $0x0
  pushl $160
  1024dd:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  1024e2:	e9 e2 f9 ff ff       	jmp    101ec9 <__alltraps>

001024e7 <vector161>:
.globl vector161
vector161:
  pushl $0
  1024e7:	6a 00                	push   $0x0
  pushl $161
  1024e9:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  1024ee:	e9 d6 f9 ff ff       	jmp    101ec9 <__alltraps>

001024f3 <vector162>:
.globl vector162
vector162:
  pushl $0
  1024f3:	6a 00                	push   $0x0
  pushl $162
  1024f5:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  1024fa:	e9 ca f9 ff ff       	jmp    101ec9 <__alltraps>

001024ff <vector163>:
.globl vector163
vector163:
  pushl $0
  1024ff:	6a 00                	push   $0x0
  pushl $163
  102501:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  102506:	e9 be f9 ff ff       	jmp    101ec9 <__alltraps>

0010250b <vector164>:
.globl vector164
vector164:
  pushl $0
  10250b:	6a 00                	push   $0x0
  pushl $164
  10250d:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  102512:	e9 b2 f9 ff ff       	jmp    101ec9 <__alltraps>

00102517 <vector165>:
.globl vector165
vector165:
  pushl $0
  102517:	6a 00                	push   $0x0
  pushl $165
  102519:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  10251e:	e9 a6 f9 ff ff       	jmp    101ec9 <__alltraps>

00102523 <vector166>:
.globl vector166
vector166:
  pushl $0
  102523:	6a 00                	push   $0x0
  pushl $166
  102525:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  10252a:	e9 9a f9 ff ff       	jmp    101ec9 <__alltraps>

0010252f <vector167>:
.globl vector167
vector167:
  pushl $0
  10252f:	6a 00                	push   $0x0
  pushl $167
  102531:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  102536:	e9 8e f9 ff ff       	jmp    101ec9 <__alltraps>

0010253b <vector168>:
.globl vector168
vector168:
  pushl $0
  10253b:	6a 00                	push   $0x0
  pushl $168
  10253d:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  102542:	e9 82 f9 ff ff       	jmp    101ec9 <__alltraps>

00102547 <vector169>:
.globl vector169
vector169:
  pushl $0
  102547:	6a 00                	push   $0x0
  pushl $169
  102549:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  10254e:	e9 76 f9 ff ff       	jmp    101ec9 <__alltraps>

00102553 <vector170>:
.globl vector170
vector170:
  pushl $0
  102553:	6a 00                	push   $0x0
  pushl $170
  102555:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  10255a:	e9 6a f9 ff ff       	jmp    101ec9 <__alltraps>

0010255f <vector171>:
.globl vector171
vector171:
  pushl $0
  10255f:	6a 00                	push   $0x0
  pushl $171
  102561:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  102566:	e9 5e f9 ff ff       	jmp    101ec9 <__alltraps>

0010256b <vector172>:
.globl vector172
vector172:
  pushl $0
  10256b:	6a 00                	push   $0x0
  pushl $172
  10256d:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  102572:	e9 52 f9 ff ff       	jmp    101ec9 <__alltraps>

00102577 <vector173>:
.globl vector173
vector173:
  pushl $0
  102577:	6a 00                	push   $0x0
  pushl $173
  102579:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  10257e:	e9 46 f9 ff ff       	jmp    101ec9 <__alltraps>

00102583 <vector174>:
.globl vector174
vector174:
  pushl $0
  102583:	6a 00                	push   $0x0
  pushl $174
  102585:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  10258a:	e9 3a f9 ff ff       	jmp    101ec9 <__alltraps>

0010258f <vector175>:
.globl vector175
vector175:
  pushl $0
  10258f:	6a 00                	push   $0x0
  pushl $175
  102591:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  102596:	e9 2e f9 ff ff       	jmp    101ec9 <__alltraps>

0010259b <vector176>:
.globl vector176
vector176:
  pushl $0
  10259b:	6a 00                	push   $0x0
  pushl $176
  10259d:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  1025a2:	e9 22 f9 ff ff       	jmp    101ec9 <__alltraps>

001025a7 <vector177>:
.globl vector177
vector177:
  pushl $0
  1025a7:	6a 00                	push   $0x0
  pushl $177
  1025a9:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  1025ae:	e9 16 f9 ff ff       	jmp    101ec9 <__alltraps>

001025b3 <vector178>:
.globl vector178
vector178:
  pushl $0
  1025b3:	6a 00                	push   $0x0
  pushl $178
  1025b5:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  1025ba:	e9 0a f9 ff ff       	jmp    101ec9 <__alltraps>

001025bf <vector179>:
.globl vector179
vector179:
  pushl $0
  1025bf:	6a 00                	push   $0x0
  pushl $179
  1025c1:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  1025c6:	e9 fe f8 ff ff       	jmp    101ec9 <__alltraps>

001025cb <vector180>:
.globl vector180
vector180:
  pushl $0
  1025cb:	6a 00                	push   $0x0
  pushl $180
  1025cd:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  1025d2:	e9 f2 f8 ff ff       	jmp    101ec9 <__alltraps>

001025d7 <vector181>:
.globl vector181
vector181:
  pushl $0
  1025d7:	6a 00                	push   $0x0
  pushl $181
  1025d9:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  1025de:	e9 e6 f8 ff ff       	jmp    101ec9 <__alltraps>

001025e3 <vector182>:
.globl vector182
vector182:
  pushl $0
  1025e3:	6a 00                	push   $0x0
  pushl $182
  1025e5:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  1025ea:	e9 da f8 ff ff       	jmp    101ec9 <__alltraps>

001025ef <vector183>:
.globl vector183
vector183:
  pushl $0
  1025ef:	6a 00                	push   $0x0
  pushl $183
  1025f1:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  1025f6:	e9 ce f8 ff ff       	jmp    101ec9 <__alltraps>

001025fb <vector184>:
.globl vector184
vector184:
  pushl $0
  1025fb:	6a 00                	push   $0x0
  pushl $184
  1025fd:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  102602:	e9 c2 f8 ff ff       	jmp    101ec9 <__alltraps>

00102607 <vector185>:
.globl vector185
vector185:
  pushl $0
  102607:	6a 00                	push   $0x0
  pushl $185
  102609:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  10260e:	e9 b6 f8 ff ff       	jmp    101ec9 <__alltraps>

00102613 <vector186>:
.globl vector186
vector186:
  pushl $0
  102613:	6a 00                	push   $0x0
  pushl $186
  102615:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  10261a:	e9 aa f8 ff ff       	jmp    101ec9 <__alltraps>

0010261f <vector187>:
.globl vector187
vector187:
  pushl $0
  10261f:	6a 00                	push   $0x0
  pushl $187
  102621:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  102626:	e9 9e f8 ff ff       	jmp    101ec9 <__alltraps>

0010262b <vector188>:
.globl vector188
vector188:
  pushl $0
  10262b:	6a 00                	push   $0x0
  pushl $188
  10262d:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  102632:	e9 92 f8 ff ff       	jmp    101ec9 <__alltraps>

00102637 <vector189>:
.globl vector189
vector189:
  pushl $0
  102637:	6a 00                	push   $0x0
  pushl $189
  102639:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  10263e:	e9 86 f8 ff ff       	jmp    101ec9 <__alltraps>

00102643 <vector190>:
.globl vector190
vector190:
  pushl $0
  102643:	6a 00                	push   $0x0
  pushl $190
  102645:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  10264a:	e9 7a f8 ff ff       	jmp    101ec9 <__alltraps>

0010264f <vector191>:
.globl vector191
vector191:
  pushl $0
  10264f:	6a 00                	push   $0x0
  pushl $191
  102651:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  102656:	e9 6e f8 ff ff       	jmp    101ec9 <__alltraps>

0010265b <vector192>:
.globl vector192
vector192:
  pushl $0
  10265b:	6a 00                	push   $0x0
  pushl $192
  10265d:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  102662:	e9 62 f8 ff ff       	jmp    101ec9 <__alltraps>

00102667 <vector193>:
.globl vector193
vector193:
  pushl $0
  102667:	6a 00                	push   $0x0
  pushl $193
  102669:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  10266e:	e9 56 f8 ff ff       	jmp    101ec9 <__alltraps>

00102673 <vector194>:
.globl vector194
vector194:
  pushl $0
  102673:	6a 00                	push   $0x0
  pushl $194
  102675:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  10267a:	e9 4a f8 ff ff       	jmp    101ec9 <__alltraps>

0010267f <vector195>:
.globl vector195
vector195:
  pushl $0
  10267f:	6a 00                	push   $0x0
  pushl $195
  102681:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  102686:	e9 3e f8 ff ff       	jmp    101ec9 <__alltraps>

0010268b <vector196>:
.globl vector196
vector196:
  pushl $0
  10268b:	6a 00                	push   $0x0
  pushl $196
  10268d:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102692:	e9 32 f8 ff ff       	jmp    101ec9 <__alltraps>

00102697 <vector197>:
.globl vector197
vector197:
  pushl $0
  102697:	6a 00                	push   $0x0
  pushl $197
  102699:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  10269e:	e9 26 f8 ff ff       	jmp    101ec9 <__alltraps>

001026a3 <vector198>:
.globl vector198
vector198:
  pushl $0
  1026a3:	6a 00                	push   $0x0
  pushl $198
  1026a5:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  1026aa:	e9 1a f8 ff ff       	jmp    101ec9 <__alltraps>

001026af <vector199>:
.globl vector199
vector199:
  pushl $0
  1026af:	6a 00                	push   $0x0
  pushl $199
  1026b1:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  1026b6:	e9 0e f8 ff ff       	jmp    101ec9 <__alltraps>

001026bb <vector200>:
.globl vector200
vector200:
  pushl $0
  1026bb:	6a 00                	push   $0x0
  pushl $200
  1026bd:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  1026c2:	e9 02 f8 ff ff       	jmp    101ec9 <__alltraps>

001026c7 <vector201>:
.globl vector201
vector201:
  pushl $0
  1026c7:	6a 00                	push   $0x0
  pushl $201
  1026c9:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  1026ce:	e9 f6 f7 ff ff       	jmp    101ec9 <__alltraps>

001026d3 <vector202>:
.globl vector202
vector202:
  pushl $0
  1026d3:	6a 00                	push   $0x0
  pushl $202
  1026d5:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  1026da:	e9 ea f7 ff ff       	jmp    101ec9 <__alltraps>

001026df <vector203>:
.globl vector203
vector203:
  pushl $0
  1026df:	6a 00                	push   $0x0
  pushl $203
  1026e1:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  1026e6:	e9 de f7 ff ff       	jmp    101ec9 <__alltraps>

001026eb <vector204>:
.globl vector204
vector204:
  pushl $0
  1026eb:	6a 00                	push   $0x0
  pushl $204
  1026ed:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  1026f2:	e9 d2 f7 ff ff       	jmp    101ec9 <__alltraps>

001026f7 <vector205>:
.globl vector205
vector205:
  pushl $0
  1026f7:	6a 00                	push   $0x0
  pushl $205
  1026f9:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  1026fe:	e9 c6 f7 ff ff       	jmp    101ec9 <__alltraps>

00102703 <vector206>:
.globl vector206
vector206:
  pushl $0
  102703:	6a 00                	push   $0x0
  pushl $206
  102705:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  10270a:	e9 ba f7 ff ff       	jmp    101ec9 <__alltraps>

0010270f <vector207>:
.globl vector207
vector207:
  pushl $0
  10270f:	6a 00                	push   $0x0
  pushl $207
  102711:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  102716:	e9 ae f7 ff ff       	jmp    101ec9 <__alltraps>

0010271b <vector208>:
.globl vector208
vector208:
  pushl $0
  10271b:	6a 00                	push   $0x0
  pushl $208
  10271d:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  102722:	e9 a2 f7 ff ff       	jmp    101ec9 <__alltraps>

00102727 <vector209>:
.globl vector209
vector209:
  pushl $0
  102727:	6a 00                	push   $0x0
  pushl $209
  102729:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  10272e:	e9 96 f7 ff ff       	jmp    101ec9 <__alltraps>

00102733 <vector210>:
.globl vector210
vector210:
  pushl $0
  102733:	6a 00                	push   $0x0
  pushl $210
  102735:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  10273a:	e9 8a f7 ff ff       	jmp    101ec9 <__alltraps>

0010273f <vector211>:
.globl vector211
vector211:
  pushl $0
  10273f:	6a 00                	push   $0x0
  pushl $211
  102741:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  102746:	e9 7e f7 ff ff       	jmp    101ec9 <__alltraps>

0010274b <vector212>:
.globl vector212
vector212:
  pushl $0
  10274b:	6a 00                	push   $0x0
  pushl $212
  10274d:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102752:	e9 72 f7 ff ff       	jmp    101ec9 <__alltraps>

00102757 <vector213>:
.globl vector213
vector213:
  pushl $0
  102757:	6a 00                	push   $0x0
  pushl $213
  102759:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  10275e:	e9 66 f7 ff ff       	jmp    101ec9 <__alltraps>

00102763 <vector214>:
.globl vector214
vector214:
  pushl $0
  102763:	6a 00                	push   $0x0
  pushl $214
  102765:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  10276a:	e9 5a f7 ff ff       	jmp    101ec9 <__alltraps>

0010276f <vector215>:
.globl vector215
vector215:
  pushl $0
  10276f:	6a 00                	push   $0x0
  pushl $215
  102771:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102776:	e9 4e f7 ff ff       	jmp    101ec9 <__alltraps>

0010277b <vector216>:
.globl vector216
vector216:
  pushl $0
  10277b:	6a 00                	push   $0x0
  pushl $216
  10277d:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102782:	e9 42 f7 ff ff       	jmp    101ec9 <__alltraps>

00102787 <vector217>:
.globl vector217
vector217:
  pushl $0
  102787:	6a 00                	push   $0x0
  pushl $217
  102789:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  10278e:	e9 36 f7 ff ff       	jmp    101ec9 <__alltraps>

00102793 <vector218>:
.globl vector218
vector218:
  pushl $0
  102793:	6a 00                	push   $0x0
  pushl $218
  102795:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  10279a:	e9 2a f7 ff ff       	jmp    101ec9 <__alltraps>

0010279f <vector219>:
.globl vector219
vector219:
  pushl $0
  10279f:	6a 00                	push   $0x0
  pushl $219
  1027a1:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  1027a6:	e9 1e f7 ff ff       	jmp    101ec9 <__alltraps>

001027ab <vector220>:
.globl vector220
vector220:
  pushl $0
  1027ab:	6a 00                	push   $0x0
  pushl $220
  1027ad:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  1027b2:	e9 12 f7 ff ff       	jmp    101ec9 <__alltraps>

001027b7 <vector221>:
.globl vector221
vector221:
  pushl $0
  1027b7:	6a 00                	push   $0x0
  pushl $221
  1027b9:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  1027be:	e9 06 f7 ff ff       	jmp    101ec9 <__alltraps>

001027c3 <vector222>:
.globl vector222
vector222:
  pushl $0
  1027c3:	6a 00                	push   $0x0
  pushl $222
  1027c5:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  1027ca:	e9 fa f6 ff ff       	jmp    101ec9 <__alltraps>

001027cf <vector223>:
.globl vector223
vector223:
  pushl $0
  1027cf:	6a 00                	push   $0x0
  pushl $223
  1027d1:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  1027d6:	e9 ee f6 ff ff       	jmp    101ec9 <__alltraps>

001027db <vector224>:
.globl vector224
vector224:
  pushl $0
  1027db:	6a 00                	push   $0x0
  pushl $224
  1027dd:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  1027e2:	e9 e2 f6 ff ff       	jmp    101ec9 <__alltraps>

001027e7 <vector225>:
.globl vector225
vector225:
  pushl $0
  1027e7:	6a 00                	push   $0x0
  pushl $225
  1027e9:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  1027ee:	e9 d6 f6 ff ff       	jmp    101ec9 <__alltraps>

001027f3 <vector226>:
.globl vector226
vector226:
  pushl $0
  1027f3:	6a 00                	push   $0x0
  pushl $226
  1027f5:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  1027fa:	e9 ca f6 ff ff       	jmp    101ec9 <__alltraps>

001027ff <vector227>:
.globl vector227
vector227:
  pushl $0
  1027ff:	6a 00                	push   $0x0
  pushl $227
  102801:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  102806:	e9 be f6 ff ff       	jmp    101ec9 <__alltraps>

0010280b <vector228>:
.globl vector228
vector228:
  pushl $0
  10280b:	6a 00                	push   $0x0
  pushl $228
  10280d:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  102812:	e9 b2 f6 ff ff       	jmp    101ec9 <__alltraps>

00102817 <vector229>:
.globl vector229
vector229:
  pushl $0
  102817:	6a 00                	push   $0x0
  pushl $229
  102819:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  10281e:	e9 a6 f6 ff ff       	jmp    101ec9 <__alltraps>

00102823 <vector230>:
.globl vector230
vector230:
  pushl $0
  102823:	6a 00                	push   $0x0
  pushl $230
  102825:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  10282a:	e9 9a f6 ff ff       	jmp    101ec9 <__alltraps>

0010282f <vector231>:
.globl vector231
vector231:
  pushl $0
  10282f:	6a 00                	push   $0x0
  pushl $231
  102831:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  102836:	e9 8e f6 ff ff       	jmp    101ec9 <__alltraps>

0010283b <vector232>:
.globl vector232
vector232:
  pushl $0
  10283b:	6a 00                	push   $0x0
  pushl $232
  10283d:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102842:	e9 82 f6 ff ff       	jmp    101ec9 <__alltraps>

00102847 <vector233>:
.globl vector233
vector233:
  pushl $0
  102847:	6a 00                	push   $0x0
  pushl $233
  102849:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  10284e:	e9 76 f6 ff ff       	jmp    101ec9 <__alltraps>

00102853 <vector234>:
.globl vector234
vector234:
  pushl $0
  102853:	6a 00                	push   $0x0
  pushl $234
  102855:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  10285a:	e9 6a f6 ff ff       	jmp    101ec9 <__alltraps>

0010285f <vector235>:
.globl vector235
vector235:
  pushl $0
  10285f:	6a 00                	push   $0x0
  pushl $235
  102861:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102866:	e9 5e f6 ff ff       	jmp    101ec9 <__alltraps>

0010286b <vector236>:
.globl vector236
vector236:
  pushl $0
  10286b:	6a 00                	push   $0x0
  pushl $236
  10286d:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102872:	e9 52 f6 ff ff       	jmp    101ec9 <__alltraps>

00102877 <vector237>:
.globl vector237
vector237:
  pushl $0
  102877:	6a 00                	push   $0x0
  pushl $237
  102879:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  10287e:	e9 46 f6 ff ff       	jmp    101ec9 <__alltraps>

00102883 <vector238>:
.globl vector238
vector238:
  pushl $0
  102883:	6a 00                	push   $0x0
  pushl $238
  102885:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  10288a:	e9 3a f6 ff ff       	jmp    101ec9 <__alltraps>

0010288f <vector239>:
.globl vector239
vector239:
  pushl $0
  10288f:	6a 00                	push   $0x0
  pushl $239
  102891:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102896:	e9 2e f6 ff ff       	jmp    101ec9 <__alltraps>

0010289b <vector240>:
.globl vector240
vector240:
  pushl $0
  10289b:	6a 00                	push   $0x0
  pushl $240
  10289d:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  1028a2:	e9 22 f6 ff ff       	jmp    101ec9 <__alltraps>

001028a7 <vector241>:
.globl vector241
vector241:
  pushl $0
  1028a7:	6a 00                	push   $0x0
  pushl $241
  1028a9:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  1028ae:	e9 16 f6 ff ff       	jmp    101ec9 <__alltraps>

001028b3 <vector242>:
.globl vector242
vector242:
  pushl $0
  1028b3:	6a 00                	push   $0x0
  pushl $242
  1028b5:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  1028ba:	e9 0a f6 ff ff       	jmp    101ec9 <__alltraps>

001028bf <vector243>:
.globl vector243
vector243:
  pushl $0
  1028bf:	6a 00                	push   $0x0
  pushl $243
  1028c1:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  1028c6:	e9 fe f5 ff ff       	jmp    101ec9 <__alltraps>

001028cb <vector244>:
.globl vector244
vector244:
  pushl $0
  1028cb:	6a 00                	push   $0x0
  pushl $244
  1028cd:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  1028d2:	e9 f2 f5 ff ff       	jmp    101ec9 <__alltraps>

001028d7 <vector245>:
.globl vector245
vector245:
  pushl $0
  1028d7:	6a 00                	push   $0x0
  pushl $245
  1028d9:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  1028de:	e9 e6 f5 ff ff       	jmp    101ec9 <__alltraps>

001028e3 <vector246>:
.globl vector246
vector246:
  pushl $0
  1028e3:	6a 00                	push   $0x0
  pushl $246
  1028e5:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  1028ea:	e9 da f5 ff ff       	jmp    101ec9 <__alltraps>

001028ef <vector247>:
.globl vector247
vector247:
  pushl $0
  1028ef:	6a 00                	push   $0x0
  pushl $247
  1028f1:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  1028f6:	e9 ce f5 ff ff       	jmp    101ec9 <__alltraps>

001028fb <vector248>:
.globl vector248
vector248:
  pushl $0
  1028fb:	6a 00                	push   $0x0
  pushl $248
  1028fd:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  102902:	e9 c2 f5 ff ff       	jmp    101ec9 <__alltraps>

00102907 <vector249>:
.globl vector249
vector249:
  pushl $0
  102907:	6a 00                	push   $0x0
  pushl $249
  102909:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  10290e:	e9 b6 f5 ff ff       	jmp    101ec9 <__alltraps>

00102913 <vector250>:
.globl vector250
vector250:
  pushl $0
  102913:	6a 00                	push   $0x0
  pushl $250
  102915:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  10291a:	e9 aa f5 ff ff       	jmp    101ec9 <__alltraps>

0010291f <vector251>:
.globl vector251
vector251:
  pushl $0
  10291f:	6a 00                	push   $0x0
  pushl $251
  102921:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102926:	e9 9e f5 ff ff       	jmp    101ec9 <__alltraps>

0010292b <vector252>:
.globl vector252
vector252:
  pushl $0
  10292b:	6a 00                	push   $0x0
  pushl $252
  10292d:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102932:	e9 92 f5 ff ff       	jmp    101ec9 <__alltraps>

00102937 <vector253>:
.globl vector253
vector253:
  pushl $0
  102937:	6a 00                	push   $0x0
  pushl $253
  102939:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  10293e:	e9 86 f5 ff ff       	jmp    101ec9 <__alltraps>

00102943 <vector254>:
.globl vector254
vector254:
  pushl $0
  102943:	6a 00                	push   $0x0
  pushl $254
  102945:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  10294a:	e9 7a f5 ff ff       	jmp    101ec9 <__alltraps>

0010294f <vector255>:
.globl vector255
vector255:
  pushl $0
  10294f:	6a 00                	push   $0x0
  pushl $255
  102951:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102956:	e9 6e f5 ff ff       	jmp    101ec9 <__alltraps>

0010295b <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  10295b:	55                   	push   %ebp
  10295c:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  10295e:	8b 45 08             	mov    0x8(%ebp),%eax
  102961:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102964:	b8 23 00 00 00       	mov    $0x23,%eax
  102969:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  10296b:	b8 23 00 00 00       	mov    $0x23,%eax
  102970:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102972:	b8 10 00 00 00       	mov    $0x10,%eax
  102977:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102979:	b8 10 00 00 00       	mov    $0x10,%eax
  10297e:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102980:	b8 10 00 00 00       	mov    $0x10,%eax
  102985:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102987:	ea 8e 29 10 00 08 00 	ljmp   $0x8,$0x10298e
}
  10298e:	90                   	nop
  10298f:	5d                   	pop    %ebp
  102990:	c3                   	ret    

00102991 <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102991:	55                   	push   %ebp
  102992:	89 e5                	mov    %esp,%ebp
  102994:	83 ec 10             	sub    $0x10,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  102997:	b8 00 09 11 00       	mov    $0x110900,%eax
  10299c:	05 00 04 00 00       	add    $0x400,%eax
  1029a1:	a3 04 0d 11 00       	mov    %eax,0x110d04
    ts.ts_ss0 = KERNEL_DS;
  1029a6:	66 c7 05 08 0d 11 00 	movw   $0x10,0x110d08
  1029ad:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  1029af:	66 c7 05 08 fa 10 00 	movw   $0x68,0x10fa08
  1029b6:	68 00 
  1029b8:	b8 00 0d 11 00       	mov    $0x110d00,%eax
  1029bd:	66 a3 0a fa 10 00    	mov    %ax,0x10fa0a
  1029c3:	b8 00 0d 11 00       	mov    $0x110d00,%eax
  1029c8:	c1 e8 10             	shr    $0x10,%eax
  1029cb:	a2 0c fa 10 00       	mov    %al,0x10fa0c
  1029d0:	0f b6 05 0d fa 10 00 	movzbl 0x10fa0d,%eax
  1029d7:	83 e0 f0             	and    $0xfffffff0,%eax
  1029da:	83 c8 09             	or     $0x9,%eax
  1029dd:	a2 0d fa 10 00       	mov    %al,0x10fa0d
  1029e2:	0f b6 05 0d fa 10 00 	movzbl 0x10fa0d,%eax
  1029e9:	83 c8 10             	or     $0x10,%eax
  1029ec:	a2 0d fa 10 00       	mov    %al,0x10fa0d
  1029f1:	0f b6 05 0d fa 10 00 	movzbl 0x10fa0d,%eax
  1029f8:	83 e0 9f             	and    $0xffffff9f,%eax
  1029fb:	a2 0d fa 10 00       	mov    %al,0x10fa0d
  102a00:	0f b6 05 0d fa 10 00 	movzbl 0x10fa0d,%eax
  102a07:	83 c8 80             	or     $0xffffff80,%eax
  102a0a:	a2 0d fa 10 00       	mov    %al,0x10fa0d
  102a0f:	0f b6 05 0e fa 10 00 	movzbl 0x10fa0e,%eax
  102a16:	83 e0 f0             	and    $0xfffffff0,%eax
  102a19:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102a1e:	0f b6 05 0e fa 10 00 	movzbl 0x10fa0e,%eax
  102a25:	83 e0 ef             	and    $0xffffffef,%eax
  102a28:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102a2d:	0f b6 05 0e fa 10 00 	movzbl 0x10fa0e,%eax
  102a34:	83 e0 df             	and    $0xffffffdf,%eax
  102a37:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102a3c:	0f b6 05 0e fa 10 00 	movzbl 0x10fa0e,%eax
  102a43:	83 c8 40             	or     $0x40,%eax
  102a46:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102a4b:	0f b6 05 0e fa 10 00 	movzbl 0x10fa0e,%eax
  102a52:	83 e0 7f             	and    $0x7f,%eax
  102a55:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102a5a:	b8 00 0d 11 00       	mov    $0x110d00,%eax
  102a5f:	c1 e8 18             	shr    $0x18,%eax
  102a62:	a2 0f fa 10 00       	mov    %al,0x10fa0f
    gdt[SEG_TSS].sd_s = 0;
  102a67:	0f b6 05 0d fa 10 00 	movzbl 0x10fa0d,%eax
  102a6e:	83 e0 ef             	and    $0xffffffef,%eax
  102a71:	a2 0d fa 10 00       	mov    %al,0x10fa0d

    // reload all segment registers
    lgdt(&gdt_pd);
  102a76:	68 10 fa 10 00       	push   $0x10fa10
  102a7b:	e8 db fe ff ff       	call   10295b <lgdt>
  102a80:	83 c4 04             	add    $0x4,%esp
  102a83:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  102a89:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102a8d:	0f 00 d8             	ltr    %ax
}
  102a90:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
  102a91:	90                   	nop
  102a92:	c9                   	leave  
  102a93:	c3                   	ret    

00102a94 <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  102a94:	55                   	push   %ebp
  102a95:	89 e5                	mov    %esp,%ebp
    gdt_init();
  102a97:	e8 f5 fe ff ff       	call   102991 <gdt_init>
}
  102a9c:	90                   	nop
  102a9d:	5d                   	pop    %ebp
  102a9e:	c3                   	ret    

00102a9f <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  102a9f:	55                   	push   %ebp
  102aa0:	89 e5                	mov    %esp,%ebp
  102aa2:	83 ec 38             	sub    $0x38,%esp
  102aa5:	8b 45 10             	mov    0x10(%ebp),%eax
  102aa8:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102aab:	8b 45 14             	mov    0x14(%ebp),%eax
  102aae:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  102ab1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102ab4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102ab7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102aba:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  102abd:	8b 45 18             	mov    0x18(%ebp),%eax
  102ac0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102ac3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102ac6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102ac9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102acc:	89 55 f0             	mov    %edx,-0x10(%ebp)
  102acf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ad2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102ad5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102ad9:	74 1c                	je     102af7 <printnum+0x58>
  102adb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ade:	ba 00 00 00 00       	mov    $0x0,%edx
  102ae3:	f7 75 e4             	divl   -0x1c(%ebp)
  102ae6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  102ae9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102aec:	ba 00 00 00 00       	mov    $0x0,%edx
  102af1:	f7 75 e4             	divl   -0x1c(%ebp)
  102af4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102af7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102afa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102afd:	f7 75 e4             	divl   -0x1c(%ebp)
  102b00:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102b03:	89 55 dc             	mov    %edx,-0x24(%ebp)
  102b06:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102b09:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102b0c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102b0f:	89 55 ec             	mov    %edx,-0x14(%ebp)
  102b12:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102b15:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  102b18:	8b 45 18             	mov    0x18(%ebp),%eax
  102b1b:	ba 00 00 00 00       	mov    $0x0,%edx
  102b20:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  102b23:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  102b26:	19 d1                	sbb    %edx,%ecx
  102b28:	72 37                	jb     102b61 <printnum+0xc2>
        printnum(putch, putdat, result, base, width - 1, padc);
  102b2a:	8b 45 1c             	mov    0x1c(%ebp),%eax
  102b2d:	83 e8 01             	sub    $0x1,%eax
  102b30:	83 ec 04             	sub    $0x4,%esp
  102b33:	ff 75 20             	push   0x20(%ebp)
  102b36:	50                   	push   %eax
  102b37:	ff 75 18             	push   0x18(%ebp)
  102b3a:	ff 75 ec             	push   -0x14(%ebp)
  102b3d:	ff 75 e8             	push   -0x18(%ebp)
  102b40:	ff 75 0c             	push   0xc(%ebp)
  102b43:	ff 75 08             	push   0x8(%ebp)
  102b46:	e8 54 ff ff ff       	call   102a9f <printnum>
  102b4b:	83 c4 20             	add    $0x20,%esp
  102b4e:	eb 1b                	jmp    102b6b <printnum+0xcc>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  102b50:	83 ec 08             	sub    $0x8,%esp
  102b53:	ff 75 0c             	push   0xc(%ebp)
  102b56:	ff 75 20             	push   0x20(%ebp)
  102b59:	8b 45 08             	mov    0x8(%ebp),%eax
  102b5c:	ff d0                	call   *%eax
  102b5e:	83 c4 10             	add    $0x10,%esp
        while (-- width > 0)
  102b61:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  102b65:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  102b69:	7f e5                	jg     102b50 <printnum+0xb1>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  102b6b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102b6e:	05 f0 3c 10 00       	add    $0x103cf0,%eax
  102b73:	0f b6 00             	movzbl (%eax),%eax
  102b76:	0f be c0             	movsbl %al,%eax
  102b79:	83 ec 08             	sub    $0x8,%esp
  102b7c:	ff 75 0c             	push   0xc(%ebp)
  102b7f:	50                   	push   %eax
  102b80:	8b 45 08             	mov    0x8(%ebp),%eax
  102b83:	ff d0                	call   *%eax
  102b85:	83 c4 10             	add    $0x10,%esp
}
  102b88:	90                   	nop
  102b89:	c9                   	leave  
  102b8a:	c3                   	ret    

00102b8b <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  102b8b:	55                   	push   %ebp
  102b8c:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102b8e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102b92:	7e 14                	jle    102ba8 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  102b94:	8b 45 08             	mov    0x8(%ebp),%eax
  102b97:	8b 00                	mov    (%eax),%eax
  102b99:	8d 48 08             	lea    0x8(%eax),%ecx
  102b9c:	8b 55 08             	mov    0x8(%ebp),%edx
  102b9f:	89 0a                	mov    %ecx,(%edx)
  102ba1:	8b 50 04             	mov    0x4(%eax),%edx
  102ba4:	8b 00                	mov    (%eax),%eax
  102ba6:	eb 30                	jmp    102bd8 <getuint+0x4d>
    }
    else if (lflag) {
  102ba8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102bac:	74 16                	je     102bc4 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  102bae:	8b 45 08             	mov    0x8(%ebp),%eax
  102bb1:	8b 00                	mov    (%eax),%eax
  102bb3:	8d 48 04             	lea    0x4(%eax),%ecx
  102bb6:	8b 55 08             	mov    0x8(%ebp),%edx
  102bb9:	89 0a                	mov    %ecx,(%edx)
  102bbb:	8b 00                	mov    (%eax),%eax
  102bbd:	ba 00 00 00 00       	mov    $0x0,%edx
  102bc2:	eb 14                	jmp    102bd8 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  102bc4:	8b 45 08             	mov    0x8(%ebp),%eax
  102bc7:	8b 00                	mov    (%eax),%eax
  102bc9:	8d 48 04             	lea    0x4(%eax),%ecx
  102bcc:	8b 55 08             	mov    0x8(%ebp),%edx
  102bcf:	89 0a                	mov    %ecx,(%edx)
  102bd1:	8b 00                	mov    (%eax),%eax
  102bd3:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  102bd8:	5d                   	pop    %ebp
  102bd9:	c3                   	ret    

00102bda <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  102bda:	55                   	push   %ebp
  102bdb:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102bdd:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102be1:	7e 14                	jle    102bf7 <getint+0x1d>
        return va_arg(*ap, long long);
  102be3:	8b 45 08             	mov    0x8(%ebp),%eax
  102be6:	8b 00                	mov    (%eax),%eax
  102be8:	8d 48 08             	lea    0x8(%eax),%ecx
  102beb:	8b 55 08             	mov    0x8(%ebp),%edx
  102bee:	89 0a                	mov    %ecx,(%edx)
  102bf0:	8b 50 04             	mov    0x4(%eax),%edx
  102bf3:	8b 00                	mov    (%eax),%eax
  102bf5:	eb 28                	jmp    102c1f <getint+0x45>
    }
    else if (lflag) {
  102bf7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102bfb:	74 12                	je     102c0f <getint+0x35>
        return va_arg(*ap, long);
  102bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  102c00:	8b 00                	mov    (%eax),%eax
  102c02:	8d 48 04             	lea    0x4(%eax),%ecx
  102c05:	8b 55 08             	mov    0x8(%ebp),%edx
  102c08:	89 0a                	mov    %ecx,(%edx)
  102c0a:	8b 00                	mov    (%eax),%eax
  102c0c:	99                   	cltd   
  102c0d:	eb 10                	jmp    102c1f <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  102c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  102c12:	8b 00                	mov    (%eax),%eax
  102c14:	8d 48 04             	lea    0x4(%eax),%ecx
  102c17:	8b 55 08             	mov    0x8(%ebp),%edx
  102c1a:	89 0a                	mov    %ecx,(%edx)
  102c1c:	8b 00                	mov    (%eax),%eax
  102c1e:	99                   	cltd   
    }
}
  102c1f:	5d                   	pop    %ebp
  102c20:	c3                   	ret    

00102c21 <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  102c21:	55                   	push   %ebp
  102c22:	89 e5                	mov    %esp,%ebp
  102c24:	83 ec 18             	sub    $0x18,%esp
    va_list ap;

    va_start(ap, fmt);
  102c27:	8d 45 14             	lea    0x14(%ebp),%eax
  102c2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  102c2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c30:	50                   	push   %eax
  102c31:	ff 75 10             	push   0x10(%ebp)
  102c34:	ff 75 0c             	push   0xc(%ebp)
  102c37:	ff 75 08             	push   0x8(%ebp)
  102c3a:	e8 06 00 00 00       	call   102c45 <vprintfmt>
  102c3f:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
  102c42:	90                   	nop
  102c43:	c9                   	leave  
  102c44:	c3                   	ret    

00102c45 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  102c45:	55                   	push   %ebp
  102c46:	89 e5                	mov    %esp,%ebp
  102c48:	56                   	push   %esi
  102c49:	53                   	push   %ebx
  102c4a:	83 ec 20             	sub    $0x20,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102c4d:	eb 17                	jmp    102c66 <vprintfmt+0x21>
            if (ch == '\0') {
  102c4f:	85 db                	test   %ebx,%ebx
  102c51:	0f 84 8e 03 00 00    	je     102fe5 <vprintfmt+0x3a0>
                return;
            }
            putch(ch, putdat);
  102c57:	83 ec 08             	sub    $0x8,%esp
  102c5a:	ff 75 0c             	push   0xc(%ebp)
  102c5d:	53                   	push   %ebx
  102c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  102c61:	ff d0                	call   *%eax
  102c63:	83 c4 10             	add    $0x10,%esp
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102c66:	8b 45 10             	mov    0x10(%ebp),%eax
  102c69:	8d 50 01             	lea    0x1(%eax),%edx
  102c6c:	89 55 10             	mov    %edx,0x10(%ebp)
  102c6f:	0f b6 00             	movzbl (%eax),%eax
  102c72:	0f b6 d8             	movzbl %al,%ebx
  102c75:	83 fb 25             	cmp    $0x25,%ebx
  102c78:	75 d5                	jne    102c4f <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
  102c7a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  102c7e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  102c85:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102c88:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  102c8b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102c92:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102c95:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  102c98:	8b 45 10             	mov    0x10(%ebp),%eax
  102c9b:	8d 50 01             	lea    0x1(%eax),%edx
  102c9e:	89 55 10             	mov    %edx,0x10(%ebp)
  102ca1:	0f b6 00             	movzbl (%eax),%eax
  102ca4:	0f b6 d8             	movzbl %al,%ebx
  102ca7:	8d 43 dd             	lea    -0x23(%ebx),%eax
  102caa:	83 f8 55             	cmp    $0x55,%eax
  102cad:	0f 87 05 03 00 00    	ja     102fb8 <vprintfmt+0x373>
  102cb3:	8b 04 85 14 3d 10 00 	mov    0x103d14(,%eax,4),%eax
  102cba:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  102cbc:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  102cc0:	eb d6                	jmp    102c98 <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  102cc2:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  102cc6:	eb d0                	jmp    102c98 <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102cc8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  102ccf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102cd2:	89 d0                	mov    %edx,%eax
  102cd4:	c1 e0 02             	shl    $0x2,%eax
  102cd7:	01 d0                	add    %edx,%eax
  102cd9:	01 c0                	add    %eax,%eax
  102cdb:	01 d8                	add    %ebx,%eax
  102cdd:	83 e8 30             	sub    $0x30,%eax
  102ce0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  102ce3:	8b 45 10             	mov    0x10(%ebp),%eax
  102ce6:	0f b6 00             	movzbl (%eax),%eax
  102ce9:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  102cec:	83 fb 2f             	cmp    $0x2f,%ebx
  102cef:	7e 39                	jle    102d2a <vprintfmt+0xe5>
  102cf1:	83 fb 39             	cmp    $0x39,%ebx
  102cf4:	7f 34                	jg     102d2a <vprintfmt+0xe5>
            for (precision = 0; ; ++ fmt) {
  102cf6:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
  102cfa:	eb d3                	jmp    102ccf <vprintfmt+0x8a>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  102cfc:	8b 45 14             	mov    0x14(%ebp),%eax
  102cff:	8d 50 04             	lea    0x4(%eax),%edx
  102d02:	89 55 14             	mov    %edx,0x14(%ebp)
  102d05:	8b 00                	mov    (%eax),%eax
  102d07:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  102d0a:	eb 1f                	jmp    102d2b <vprintfmt+0xe6>

        case '.':
            if (width < 0)
  102d0c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102d10:	79 86                	jns    102c98 <vprintfmt+0x53>
                width = 0;
  102d12:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  102d19:	e9 7a ff ff ff       	jmp    102c98 <vprintfmt+0x53>

        case '#':
            altflag = 1;
  102d1e:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  102d25:	e9 6e ff ff ff       	jmp    102c98 <vprintfmt+0x53>
            goto process_precision;
  102d2a:	90                   	nop

        process_precision:
            if (width < 0)
  102d2b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102d2f:	0f 89 63 ff ff ff    	jns    102c98 <vprintfmt+0x53>
                width = precision, precision = -1;
  102d35:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102d38:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102d3b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  102d42:	e9 51 ff ff ff       	jmp    102c98 <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  102d47:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  102d4b:	e9 48 ff ff ff       	jmp    102c98 <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  102d50:	8b 45 14             	mov    0x14(%ebp),%eax
  102d53:	8d 50 04             	lea    0x4(%eax),%edx
  102d56:	89 55 14             	mov    %edx,0x14(%ebp)
  102d59:	8b 00                	mov    (%eax),%eax
  102d5b:	83 ec 08             	sub    $0x8,%esp
  102d5e:	ff 75 0c             	push   0xc(%ebp)
  102d61:	50                   	push   %eax
  102d62:	8b 45 08             	mov    0x8(%ebp),%eax
  102d65:	ff d0                	call   *%eax
  102d67:	83 c4 10             	add    $0x10,%esp
            break;
  102d6a:	e9 71 02 00 00       	jmp    102fe0 <vprintfmt+0x39b>

        // error message
        case 'e':
            err = va_arg(ap, int);
  102d6f:	8b 45 14             	mov    0x14(%ebp),%eax
  102d72:	8d 50 04             	lea    0x4(%eax),%edx
  102d75:	89 55 14             	mov    %edx,0x14(%ebp)
  102d78:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  102d7a:	85 db                	test   %ebx,%ebx
  102d7c:	79 02                	jns    102d80 <vprintfmt+0x13b>
                err = -err;
  102d7e:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  102d80:	83 fb 06             	cmp    $0x6,%ebx
  102d83:	7f 0b                	jg     102d90 <vprintfmt+0x14b>
  102d85:	8b 34 9d d4 3c 10 00 	mov    0x103cd4(,%ebx,4),%esi
  102d8c:	85 f6                	test   %esi,%esi
  102d8e:	75 19                	jne    102da9 <vprintfmt+0x164>
                printfmt(putch, putdat, "error %d", err);
  102d90:	53                   	push   %ebx
  102d91:	68 01 3d 10 00       	push   $0x103d01
  102d96:	ff 75 0c             	push   0xc(%ebp)
  102d99:	ff 75 08             	push   0x8(%ebp)
  102d9c:	e8 80 fe ff ff       	call   102c21 <printfmt>
  102da1:	83 c4 10             	add    $0x10,%esp
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  102da4:	e9 37 02 00 00       	jmp    102fe0 <vprintfmt+0x39b>
                printfmt(putch, putdat, "%s", p);
  102da9:	56                   	push   %esi
  102daa:	68 0a 3d 10 00       	push   $0x103d0a
  102daf:	ff 75 0c             	push   0xc(%ebp)
  102db2:	ff 75 08             	push   0x8(%ebp)
  102db5:	e8 67 fe ff ff       	call   102c21 <printfmt>
  102dba:	83 c4 10             	add    $0x10,%esp
            break;
  102dbd:	e9 1e 02 00 00       	jmp    102fe0 <vprintfmt+0x39b>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  102dc2:	8b 45 14             	mov    0x14(%ebp),%eax
  102dc5:	8d 50 04             	lea    0x4(%eax),%edx
  102dc8:	89 55 14             	mov    %edx,0x14(%ebp)
  102dcb:	8b 30                	mov    (%eax),%esi
  102dcd:	85 f6                	test   %esi,%esi
  102dcf:	75 05                	jne    102dd6 <vprintfmt+0x191>
                p = "(null)";
  102dd1:	be 0d 3d 10 00       	mov    $0x103d0d,%esi
            }
            if (width > 0 && padc != '-') {
  102dd6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102dda:	7e 76                	jle    102e52 <vprintfmt+0x20d>
  102ddc:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  102de0:	74 70                	je     102e52 <vprintfmt+0x20d>
                for (width -= strnlen(p, precision); width > 0; width --) {
  102de2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102de5:	83 ec 08             	sub    $0x8,%esp
  102de8:	50                   	push   %eax
  102de9:	56                   	push   %esi
  102dea:	e8 df 02 00 00       	call   1030ce <strnlen>
  102def:	83 c4 10             	add    $0x10,%esp
  102df2:	89 c2                	mov    %eax,%edx
  102df4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102df7:	29 d0                	sub    %edx,%eax
  102df9:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102dfc:	eb 17                	jmp    102e15 <vprintfmt+0x1d0>
                    putch(padc, putdat);
  102dfe:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  102e02:	83 ec 08             	sub    $0x8,%esp
  102e05:	ff 75 0c             	push   0xc(%ebp)
  102e08:	50                   	push   %eax
  102e09:	8b 45 08             	mov    0x8(%ebp),%eax
  102e0c:	ff d0                	call   *%eax
  102e0e:	83 c4 10             	add    $0x10,%esp
                for (width -= strnlen(p, precision); width > 0; width --) {
  102e11:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102e15:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102e19:	7f e3                	jg     102dfe <vprintfmt+0x1b9>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102e1b:	eb 35                	jmp    102e52 <vprintfmt+0x20d>
                if (altflag && (ch < ' ' || ch > '~')) {
  102e1d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  102e21:	74 1c                	je     102e3f <vprintfmt+0x1fa>
  102e23:	83 fb 1f             	cmp    $0x1f,%ebx
  102e26:	7e 05                	jle    102e2d <vprintfmt+0x1e8>
  102e28:	83 fb 7e             	cmp    $0x7e,%ebx
  102e2b:	7e 12                	jle    102e3f <vprintfmt+0x1fa>
                    putch('?', putdat);
  102e2d:	83 ec 08             	sub    $0x8,%esp
  102e30:	ff 75 0c             	push   0xc(%ebp)
  102e33:	6a 3f                	push   $0x3f
  102e35:	8b 45 08             	mov    0x8(%ebp),%eax
  102e38:	ff d0                	call   *%eax
  102e3a:	83 c4 10             	add    $0x10,%esp
  102e3d:	eb 0f                	jmp    102e4e <vprintfmt+0x209>
                }
                else {
                    putch(ch, putdat);
  102e3f:	83 ec 08             	sub    $0x8,%esp
  102e42:	ff 75 0c             	push   0xc(%ebp)
  102e45:	53                   	push   %ebx
  102e46:	8b 45 08             	mov    0x8(%ebp),%eax
  102e49:	ff d0                	call   *%eax
  102e4b:	83 c4 10             	add    $0x10,%esp
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102e4e:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102e52:	89 f0                	mov    %esi,%eax
  102e54:	8d 70 01             	lea    0x1(%eax),%esi
  102e57:	0f b6 00             	movzbl (%eax),%eax
  102e5a:	0f be d8             	movsbl %al,%ebx
  102e5d:	85 db                	test   %ebx,%ebx
  102e5f:	74 26                	je     102e87 <vprintfmt+0x242>
  102e61:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102e65:	78 b6                	js     102e1d <vprintfmt+0x1d8>
  102e67:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  102e6b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102e6f:	79 ac                	jns    102e1d <vprintfmt+0x1d8>
                }
            }
            for (; width > 0; width --) {
  102e71:	eb 14                	jmp    102e87 <vprintfmt+0x242>
                putch(' ', putdat);
  102e73:	83 ec 08             	sub    $0x8,%esp
  102e76:	ff 75 0c             	push   0xc(%ebp)
  102e79:	6a 20                	push   $0x20
  102e7b:	8b 45 08             	mov    0x8(%ebp),%eax
  102e7e:	ff d0                	call   *%eax
  102e80:	83 c4 10             	add    $0x10,%esp
            for (; width > 0; width --) {
  102e83:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102e87:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102e8b:	7f e6                	jg     102e73 <vprintfmt+0x22e>
            }
            break;
  102e8d:	e9 4e 01 00 00       	jmp    102fe0 <vprintfmt+0x39b>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  102e92:	83 ec 08             	sub    $0x8,%esp
  102e95:	ff 75 e0             	push   -0x20(%ebp)
  102e98:	8d 45 14             	lea    0x14(%ebp),%eax
  102e9b:	50                   	push   %eax
  102e9c:	e8 39 fd ff ff       	call   102bda <getint>
  102ea1:	83 c4 10             	add    $0x10,%esp
  102ea4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102ea7:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  102eaa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ead:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102eb0:	85 d2                	test   %edx,%edx
  102eb2:	79 23                	jns    102ed7 <vprintfmt+0x292>
                putch('-', putdat);
  102eb4:	83 ec 08             	sub    $0x8,%esp
  102eb7:	ff 75 0c             	push   0xc(%ebp)
  102eba:	6a 2d                	push   $0x2d
  102ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  102ebf:	ff d0                	call   *%eax
  102ec1:	83 c4 10             	add    $0x10,%esp
                num = -(long long)num;
  102ec4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ec7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102eca:	f7 d8                	neg    %eax
  102ecc:	83 d2 00             	adc    $0x0,%edx
  102ecf:	f7 da                	neg    %edx
  102ed1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102ed4:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  102ed7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102ede:	e9 9f 00 00 00       	jmp    102f82 <vprintfmt+0x33d>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  102ee3:	83 ec 08             	sub    $0x8,%esp
  102ee6:	ff 75 e0             	push   -0x20(%ebp)
  102ee9:	8d 45 14             	lea    0x14(%ebp),%eax
  102eec:	50                   	push   %eax
  102eed:	e8 99 fc ff ff       	call   102b8b <getuint>
  102ef2:	83 c4 10             	add    $0x10,%esp
  102ef5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102ef8:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  102efb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102f02:	eb 7e                	jmp    102f82 <vprintfmt+0x33d>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  102f04:	83 ec 08             	sub    $0x8,%esp
  102f07:	ff 75 e0             	push   -0x20(%ebp)
  102f0a:	8d 45 14             	lea    0x14(%ebp),%eax
  102f0d:	50                   	push   %eax
  102f0e:	e8 78 fc ff ff       	call   102b8b <getuint>
  102f13:	83 c4 10             	add    $0x10,%esp
  102f16:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f19:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  102f1c:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  102f23:	eb 5d                	jmp    102f82 <vprintfmt+0x33d>

        // pointer
        case 'p':
            putch('0', putdat);
  102f25:	83 ec 08             	sub    $0x8,%esp
  102f28:	ff 75 0c             	push   0xc(%ebp)
  102f2b:	6a 30                	push   $0x30
  102f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  102f30:	ff d0                	call   *%eax
  102f32:	83 c4 10             	add    $0x10,%esp
            putch('x', putdat);
  102f35:	83 ec 08             	sub    $0x8,%esp
  102f38:	ff 75 0c             	push   0xc(%ebp)
  102f3b:	6a 78                	push   $0x78
  102f3d:	8b 45 08             	mov    0x8(%ebp),%eax
  102f40:	ff d0                	call   *%eax
  102f42:	83 c4 10             	add    $0x10,%esp
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  102f45:	8b 45 14             	mov    0x14(%ebp),%eax
  102f48:	8d 50 04             	lea    0x4(%eax),%edx
  102f4b:	89 55 14             	mov    %edx,0x14(%ebp)
  102f4e:	8b 00                	mov    (%eax),%eax
  102f50:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f53:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  102f5a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  102f61:	eb 1f                	jmp    102f82 <vprintfmt+0x33d>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  102f63:	83 ec 08             	sub    $0x8,%esp
  102f66:	ff 75 e0             	push   -0x20(%ebp)
  102f69:	8d 45 14             	lea    0x14(%ebp),%eax
  102f6c:	50                   	push   %eax
  102f6d:	e8 19 fc ff ff       	call   102b8b <getuint>
  102f72:	83 c4 10             	add    $0x10,%esp
  102f75:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f78:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  102f7b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  102f82:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  102f86:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f89:	83 ec 04             	sub    $0x4,%esp
  102f8c:	52                   	push   %edx
  102f8d:	ff 75 e8             	push   -0x18(%ebp)
  102f90:	50                   	push   %eax
  102f91:	ff 75 f4             	push   -0xc(%ebp)
  102f94:	ff 75 f0             	push   -0x10(%ebp)
  102f97:	ff 75 0c             	push   0xc(%ebp)
  102f9a:	ff 75 08             	push   0x8(%ebp)
  102f9d:	e8 fd fa ff ff       	call   102a9f <printnum>
  102fa2:	83 c4 20             	add    $0x20,%esp
            break;
  102fa5:	eb 39                	jmp    102fe0 <vprintfmt+0x39b>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  102fa7:	83 ec 08             	sub    $0x8,%esp
  102faa:	ff 75 0c             	push   0xc(%ebp)
  102fad:	53                   	push   %ebx
  102fae:	8b 45 08             	mov    0x8(%ebp),%eax
  102fb1:	ff d0                	call   *%eax
  102fb3:	83 c4 10             	add    $0x10,%esp
            break;
  102fb6:	eb 28                	jmp    102fe0 <vprintfmt+0x39b>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  102fb8:	83 ec 08             	sub    $0x8,%esp
  102fbb:	ff 75 0c             	push   0xc(%ebp)
  102fbe:	6a 25                	push   $0x25
  102fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  102fc3:	ff d0                	call   *%eax
  102fc5:	83 c4 10             	add    $0x10,%esp
            for (fmt --; fmt[-1] != '%'; fmt --)
  102fc8:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  102fcc:	eb 04                	jmp    102fd2 <vprintfmt+0x38d>
  102fce:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  102fd2:	8b 45 10             	mov    0x10(%ebp),%eax
  102fd5:	83 e8 01             	sub    $0x1,%eax
  102fd8:	0f b6 00             	movzbl (%eax),%eax
  102fdb:	3c 25                	cmp    $0x25,%al
  102fdd:	75 ef                	jne    102fce <vprintfmt+0x389>
                /* do nothing */;
            break;
  102fdf:	90                   	nop
    while (1) {
  102fe0:	e9 68 fc ff ff       	jmp    102c4d <vprintfmt+0x8>
                return;
  102fe5:	90                   	nop
        }
    }
}
  102fe6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  102fe9:	5b                   	pop    %ebx
  102fea:	5e                   	pop    %esi
  102feb:	5d                   	pop    %ebp
  102fec:	c3                   	ret    

00102fed <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  102fed:	55                   	push   %ebp
  102fee:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  102ff0:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ff3:	8b 40 08             	mov    0x8(%eax),%eax
  102ff6:	8d 50 01             	lea    0x1(%eax),%edx
  102ff9:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ffc:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  102fff:	8b 45 0c             	mov    0xc(%ebp),%eax
  103002:	8b 10                	mov    (%eax),%edx
  103004:	8b 45 0c             	mov    0xc(%ebp),%eax
  103007:	8b 40 04             	mov    0x4(%eax),%eax
  10300a:	39 c2                	cmp    %eax,%edx
  10300c:	73 12                	jae    103020 <sprintputch+0x33>
        *b->buf ++ = ch;
  10300e:	8b 45 0c             	mov    0xc(%ebp),%eax
  103011:	8b 00                	mov    (%eax),%eax
  103013:	8d 48 01             	lea    0x1(%eax),%ecx
  103016:	8b 55 0c             	mov    0xc(%ebp),%edx
  103019:	89 0a                	mov    %ecx,(%edx)
  10301b:	8b 55 08             	mov    0x8(%ebp),%edx
  10301e:	88 10                	mov    %dl,(%eax)
    }
}
  103020:	90                   	nop
  103021:	5d                   	pop    %ebp
  103022:	c3                   	ret    

00103023 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  103023:	55                   	push   %ebp
  103024:	89 e5                	mov    %esp,%ebp
  103026:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  103029:	8d 45 14             	lea    0x14(%ebp),%eax
  10302c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  10302f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103032:	50                   	push   %eax
  103033:	ff 75 10             	push   0x10(%ebp)
  103036:	ff 75 0c             	push   0xc(%ebp)
  103039:	ff 75 08             	push   0x8(%ebp)
  10303c:	e8 0b 00 00 00       	call   10304c <vsnprintf>
  103041:	83 c4 10             	add    $0x10,%esp
  103044:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  103047:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10304a:	c9                   	leave  
  10304b:	c3                   	ret    

0010304c <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  10304c:	55                   	push   %ebp
  10304d:	89 e5                	mov    %esp,%ebp
  10304f:	83 ec 18             	sub    $0x18,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  103052:	8b 45 08             	mov    0x8(%ebp),%eax
  103055:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103058:	8b 45 0c             	mov    0xc(%ebp),%eax
  10305b:	8d 50 ff             	lea    -0x1(%eax),%edx
  10305e:	8b 45 08             	mov    0x8(%ebp),%eax
  103061:	01 d0                	add    %edx,%eax
  103063:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103066:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  10306d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103071:	74 0a                	je     10307d <vsnprintf+0x31>
  103073:	8b 55 ec             	mov    -0x14(%ebp),%edx
  103076:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103079:	39 c2                	cmp    %eax,%edx
  10307b:	76 07                	jbe    103084 <vsnprintf+0x38>
        return -E_INVAL;
  10307d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  103082:	eb 20                	jmp    1030a4 <vsnprintf+0x58>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  103084:	ff 75 14             	push   0x14(%ebp)
  103087:	ff 75 10             	push   0x10(%ebp)
  10308a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  10308d:	50                   	push   %eax
  10308e:	68 ed 2f 10 00       	push   $0x102fed
  103093:	e8 ad fb ff ff       	call   102c45 <vprintfmt>
  103098:	83 c4 10             	add    $0x10,%esp
    // null terminate the buffer
    *b.buf = '\0';
  10309b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10309e:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  1030a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1030a4:	c9                   	leave  
  1030a5:	c3                   	ret    

001030a6 <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  1030a6:	55                   	push   %ebp
  1030a7:	89 e5                	mov    %esp,%ebp
  1030a9:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  1030ac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  1030b3:	eb 04                	jmp    1030b9 <strlen+0x13>
        cnt ++;
  1030b5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (*s ++ != '\0') {
  1030b9:	8b 45 08             	mov    0x8(%ebp),%eax
  1030bc:	8d 50 01             	lea    0x1(%eax),%edx
  1030bf:	89 55 08             	mov    %edx,0x8(%ebp)
  1030c2:	0f b6 00             	movzbl (%eax),%eax
  1030c5:	84 c0                	test   %al,%al
  1030c7:	75 ec                	jne    1030b5 <strlen+0xf>
    }
    return cnt;
  1030c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1030cc:	c9                   	leave  
  1030cd:	c3                   	ret    

001030ce <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  1030ce:	55                   	push   %ebp
  1030cf:	89 e5                	mov    %esp,%ebp
  1030d1:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  1030d4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  1030db:	eb 04                	jmp    1030e1 <strnlen+0x13>
        cnt ++;
  1030dd:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  1030e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1030e4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1030e7:	73 10                	jae    1030f9 <strnlen+0x2b>
  1030e9:	8b 45 08             	mov    0x8(%ebp),%eax
  1030ec:	8d 50 01             	lea    0x1(%eax),%edx
  1030ef:	89 55 08             	mov    %edx,0x8(%ebp)
  1030f2:	0f b6 00             	movzbl (%eax),%eax
  1030f5:	84 c0                	test   %al,%al
  1030f7:	75 e4                	jne    1030dd <strnlen+0xf>
    }
    return cnt;
  1030f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1030fc:	c9                   	leave  
  1030fd:	c3                   	ret    

001030fe <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  1030fe:	55                   	push   %ebp
  1030ff:	89 e5                	mov    %esp,%ebp
  103101:	57                   	push   %edi
  103102:	56                   	push   %esi
  103103:	83 ec 20             	sub    $0x20,%esp
  103106:	8b 45 08             	mov    0x8(%ebp),%eax
  103109:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10310c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10310f:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  103112:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103115:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103118:	89 d1                	mov    %edx,%ecx
  10311a:	89 c2                	mov    %eax,%edx
  10311c:	89 ce                	mov    %ecx,%esi
  10311e:	89 d7                	mov    %edx,%edi
  103120:	ac                   	lods   %ds:(%esi),%al
  103121:	aa                   	stos   %al,%es:(%edi)
  103122:	84 c0                	test   %al,%al
  103124:	75 fa                	jne    103120 <strcpy+0x22>
  103126:	89 fa                	mov    %edi,%edx
  103128:	89 f1                	mov    %esi,%ecx
  10312a:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  10312d:	89 55 e8             	mov    %edx,-0x18(%ebp)
  103130:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  103133:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  103136:	83 c4 20             	add    $0x20,%esp
  103139:	5e                   	pop    %esi
  10313a:	5f                   	pop    %edi
  10313b:	5d                   	pop    %ebp
  10313c:	c3                   	ret    

0010313d <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  10313d:	55                   	push   %ebp
  10313e:	89 e5                	mov    %esp,%ebp
  103140:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  103143:	8b 45 08             	mov    0x8(%ebp),%eax
  103146:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  103149:	eb 21                	jmp    10316c <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  10314b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10314e:	0f b6 10             	movzbl (%eax),%edx
  103151:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103154:	88 10                	mov    %dl,(%eax)
  103156:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103159:	0f b6 00             	movzbl (%eax),%eax
  10315c:	84 c0                	test   %al,%al
  10315e:	74 04                	je     103164 <strncpy+0x27>
            src ++;
  103160:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  103164:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  103168:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    while (len > 0) {
  10316c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103170:	75 d9                	jne    10314b <strncpy+0xe>
    }
    return dst;
  103172:	8b 45 08             	mov    0x8(%ebp),%eax
}
  103175:	c9                   	leave  
  103176:	c3                   	ret    

00103177 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  103177:	55                   	push   %ebp
  103178:	89 e5                	mov    %esp,%ebp
  10317a:	57                   	push   %edi
  10317b:	56                   	push   %esi
  10317c:	83 ec 20             	sub    $0x20,%esp
  10317f:	8b 45 08             	mov    0x8(%ebp),%eax
  103182:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103185:	8b 45 0c             	mov    0xc(%ebp),%eax
  103188:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  10318b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10318e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103191:	89 d1                	mov    %edx,%ecx
  103193:	89 c2                	mov    %eax,%edx
  103195:	89 ce                	mov    %ecx,%esi
  103197:	89 d7                	mov    %edx,%edi
  103199:	ac                   	lods   %ds:(%esi),%al
  10319a:	ae                   	scas   %es:(%edi),%al
  10319b:	75 08                	jne    1031a5 <strcmp+0x2e>
  10319d:	84 c0                	test   %al,%al
  10319f:	75 f8                	jne    103199 <strcmp+0x22>
  1031a1:	31 c0                	xor    %eax,%eax
  1031a3:	eb 04                	jmp    1031a9 <strcmp+0x32>
  1031a5:	19 c0                	sbb    %eax,%eax
  1031a7:	0c 01                	or     $0x1,%al
  1031a9:	89 fa                	mov    %edi,%edx
  1031ab:	89 f1                	mov    %esi,%ecx
  1031ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1031b0:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1031b3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  1031b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  1031b9:	83 c4 20             	add    $0x20,%esp
  1031bc:	5e                   	pop    %esi
  1031bd:	5f                   	pop    %edi
  1031be:	5d                   	pop    %ebp
  1031bf:	c3                   	ret    

001031c0 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  1031c0:	55                   	push   %ebp
  1031c1:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1031c3:	eb 0c                	jmp    1031d1 <strncmp+0x11>
        n --, s1 ++, s2 ++;
  1031c5:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1031c9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1031cd:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1031d1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1031d5:	74 1a                	je     1031f1 <strncmp+0x31>
  1031d7:	8b 45 08             	mov    0x8(%ebp),%eax
  1031da:	0f b6 00             	movzbl (%eax),%eax
  1031dd:	84 c0                	test   %al,%al
  1031df:	74 10                	je     1031f1 <strncmp+0x31>
  1031e1:	8b 45 08             	mov    0x8(%ebp),%eax
  1031e4:	0f b6 10             	movzbl (%eax),%edx
  1031e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031ea:	0f b6 00             	movzbl (%eax),%eax
  1031ed:	38 c2                	cmp    %al,%dl
  1031ef:	74 d4                	je     1031c5 <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  1031f1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1031f5:	74 18                	je     10320f <strncmp+0x4f>
  1031f7:	8b 45 08             	mov    0x8(%ebp),%eax
  1031fa:	0f b6 00             	movzbl (%eax),%eax
  1031fd:	0f b6 d0             	movzbl %al,%edx
  103200:	8b 45 0c             	mov    0xc(%ebp),%eax
  103203:	0f b6 00             	movzbl (%eax),%eax
  103206:	0f b6 c8             	movzbl %al,%ecx
  103209:	89 d0                	mov    %edx,%eax
  10320b:	29 c8                	sub    %ecx,%eax
  10320d:	eb 05                	jmp    103214 <strncmp+0x54>
  10320f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103214:	5d                   	pop    %ebp
  103215:	c3                   	ret    

00103216 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  103216:	55                   	push   %ebp
  103217:	89 e5                	mov    %esp,%ebp
  103219:	83 ec 04             	sub    $0x4,%esp
  10321c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10321f:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  103222:	eb 14                	jmp    103238 <strchr+0x22>
        if (*s == c) {
  103224:	8b 45 08             	mov    0x8(%ebp),%eax
  103227:	0f b6 00             	movzbl (%eax),%eax
  10322a:	38 45 fc             	cmp    %al,-0x4(%ebp)
  10322d:	75 05                	jne    103234 <strchr+0x1e>
            return (char *)s;
  10322f:	8b 45 08             	mov    0x8(%ebp),%eax
  103232:	eb 13                	jmp    103247 <strchr+0x31>
        }
        s ++;
  103234:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
  103238:	8b 45 08             	mov    0x8(%ebp),%eax
  10323b:	0f b6 00             	movzbl (%eax),%eax
  10323e:	84 c0                	test   %al,%al
  103240:	75 e2                	jne    103224 <strchr+0xe>
    }
    return NULL;
  103242:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103247:	c9                   	leave  
  103248:	c3                   	ret    

00103249 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  103249:	55                   	push   %ebp
  10324a:	89 e5                	mov    %esp,%ebp
  10324c:	83 ec 04             	sub    $0x4,%esp
  10324f:	8b 45 0c             	mov    0xc(%ebp),%eax
  103252:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  103255:	eb 0f                	jmp    103266 <strfind+0x1d>
        if (*s == c) {
  103257:	8b 45 08             	mov    0x8(%ebp),%eax
  10325a:	0f b6 00             	movzbl (%eax),%eax
  10325d:	38 45 fc             	cmp    %al,-0x4(%ebp)
  103260:	74 10                	je     103272 <strfind+0x29>
            break;
        }
        s ++;
  103262:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
  103266:	8b 45 08             	mov    0x8(%ebp),%eax
  103269:	0f b6 00             	movzbl (%eax),%eax
  10326c:	84 c0                	test   %al,%al
  10326e:	75 e7                	jne    103257 <strfind+0xe>
  103270:	eb 01                	jmp    103273 <strfind+0x2a>
            break;
  103272:	90                   	nop
    }
    return (char *)s;
  103273:	8b 45 08             	mov    0x8(%ebp),%eax
}
  103276:	c9                   	leave  
  103277:	c3                   	ret    

00103278 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  103278:	55                   	push   %ebp
  103279:	89 e5                	mov    %esp,%ebp
  10327b:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  10327e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  103285:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  10328c:	eb 04                	jmp    103292 <strtol+0x1a>
        s ++;
  10328e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  103292:	8b 45 08             	mov    0x8(%ebp),%eax
  103295:	0f b6 00             	movzbl (%eax),%eax
  103298:	3c 20                	cmp    $0x20,%al
  10329a:	74 f2                	je     10328e <strtol+0x16>
  10329c:	8b 45 08             	mov    0x8(%ebp),%eax
  10329f:	0f b6 00             	movzbl (%eax),%eax
  1032a2:	3c 09                	cmp    $0x9,%al
  1032a4:	74 e8                	je     10328e <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
  1032a6:	8b 45 08             	mov    0x8(%ebp),%eax
  1032a9:	0f b6 00             	movzbl (%eax),%eax
  1032ac:	3c 2b                	cmp    $0x2b,%al
  1032ae:	75 06                	jne    1032b6 <strtol+0x3e>
        s ++;
  1032b0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1032b4:	eb 15                	jmp    1032cb <strtol+0x53>
    }
    else if (*s == '-') {
  1032b6:	8b 45 08             	mov    0x8(%ebp),%eax
  1032b9:	0f b6 00             	movzbl (%eax),%eax
  1032bc:	3c 2d                	cmp    $0x2d,%al
  1032be:	75 0b                	jne    1032cb <strtol+0x53>
        s ++, neg = 1;
  1032c0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1032c4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  1032cb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1032cf:	74 06                	je     1032d7 <strtol+0x5f>
  1032d1:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  1032d5:	75 24                	jne    1032fb <strtol+0x83>
  1032d7:	8b 45 08             	mov    0x8(%ebp),%eax
  1032da:	0f b6 00             	movzbl (%eax),%eax
  1032dd:	3c 30                	cmp    $0x30,%al
  1032df:	75 1a                	jne    1032fb <strtol+0x83>
  1032e1:	8b 45 08             	mov    0x8(%ebp),%eax
  1032e4:	83 c0 01             	add    $0x1,%eax
  1032e7:	0f b6 00             	movzbl (%eax),%eax
  1032ea:	3c 78                	cmp    $0x78,%al
  1032ec:	75 0d                	jne    1032fb <strtol+0x83>
        s += 2, base = 16;
  1032ee:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  1032f2:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  1032f9:	eb 2a                	jmp    103325 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  1032fb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1032ff:	75 17                	jne    103318 <strtol+0xa0>
  103301:	8b 45 08             	mov    0x8(%ebp),%eax
  103304:	0f b6 00             	movzbl (%eax),%eax
  103307:	3c 30                	cmp    $0x30,%al
  103309:	75 0d                	jne    103318 <strtol+0xa0>
        s ++, base = 8;
  10330b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  10330f:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  103316:	eb 0d                	jmp    103325 <strtol+0xad>
    }
    else if (base == 0) {
  103318:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10331c:	75 07                	jne    103325 <strtol+0xad>
        base = 10;
  10331e:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  103325:	8b 45 08             	mov    0x8(%ebp),%eax
  103328:	0f b6 00             	movzbl (%eax),%eax
  10332b:	3c 2f                	cmp    $0x2f,%al
  10332d:	7e 1b                	jle    10334a <strtol+0xd2>
  10332f:	8b 45 08             	mov    0x8(%ebp),%eax
  103332:	0f b6 00             	movzbl (%eax),%eax
  103335:	3c 39                	cmp    $0x39,%al
  103337:	7f 11                	jg     10334a <strtol+0xd2>
            dig = *s - '0';
  103339:	8b 45 08             	mov    0x8(%ebp),%eax
  10333c:	0f b6 00             	movzbl (%eax),%eax
  10333f:	0f be c0             	movsbl %al,%eax
  103342:	83 e8 30             	sub    $0x30,%eax
  103345:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103348:	eb 48                	jmp    103392 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  10334a:	8b 45 08             	mov    0x8(%ebp),%eax
  10334d:	0f b6 00             	movzbl (%eax),%eax
  103350:	3c 60                	cmp    $0x60,%al
  103352:	7e 1b                	jle    10336f <strtol+0xf7>
  103354:	8b 45 08             	mov    0x8(%ebp),%eax
  103357:	0f b6 00             	movzbl (%eax),%eax
  10335a:	3c 7a                	cmp    $0x7a,%al
  10335c:	7f 11                	jg     10336f <strtol+0xf7>
            dig = *s - 'a' + 10;
  10335e:	8b 45 08             	mov    0x8(%ebp),%eax
  103361:	0f b6 00             	movzbl (%eax),%eax
  103364:	0f be c0             	movsbl %al,%eax
  103367:	83 e8 57             	sub    $0x57,%eax
  10336a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10336d:	eb 23                	jmp    103392 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  10336f:	8b 45 08             	mov    0x8(%ebp),%eax
  103372:	0f b6 00             	movzbl (%eax),%eax
  103375:	3c 40                	cmp    $0x40,%al
  103377:	7e 3c                	jle    1033b5 <strtol+0x13d>
  103379:	8b 45 08             	mov    0x8(%ebp),%eax
  10337c:	0f b6 00             	movzbl (%eax),%eax
  10337f:	3c 5a                	cmp    $0x5a,%al
  103381:	7f 32                	jg     1033b5 <strtol+0x13d>
            dig = *s - 'A' + 10;
  103383:	8b 45 08             	mov    0x8(%ebp),%eax
  103386:	0f b6 00             	movzbl (%eax),%eax
  103389:	0f be c0             	movsbl %al,%eax
  10338c:	83 e8 37             	sub    $0x37,%eax
  10338f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  103392:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103395:	3b 45 10             	cmp    0x10(%ebp),%eax
  103398:	7d 1a                	jge    1033b4 <strtol+0x13c>
            break;
        }
        s ++, val = (val * base) + dig;
  10339a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  10339e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1033a1:	0f af 45 10          	imul   0x10(%ebp),%eax
  1033a5:	89 c2                	mov    %eax,%edx
  1033a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1033aa:	01 d0                	add    %edx,%eax
  1033ac:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
  1033af:	e9 71 ff ff ff       	jmp    103325 <strtol+0xad>
            break;
  1033b4:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
  1033b5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1033b9:	74 08                	je     1033c3 <strtol+0x14b>
        *endptr = (char *) s;
  1033bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1033be:	8b 55 08             	mov    0x8(%ebp),%edx
  1033c1:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  1033c3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  1033c7:	74 07                	je     1033d0 <strtol+0x158>
  1033c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1033cc:	f7 d8                	neg    %eax
  1033ce:	eb 03                	jmp    1033d3 <strtol+0x15b>
  1033d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  1033d3:	c9                   	leave  
  1033d4:	c3                   	ret    

001033d5 <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  1033d5:	55                   	push   %ebp
  1033d6:	89 e5                	mov    %esp,%ebp
  1033d8:	57                   	push   %edi
  1033d9:	83 ec 24             	sub    $0x24,%esp
  1033dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1033df:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  1033e2:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  1033e6:	8b 55 08             	mov    0x8(%ebp),%edx
  1033e9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  1033ec:	88 45 f7             	mov    %al,-0x9(%ebp)
  1033ef:	8b 45 10             	mov    0x10(%ebp),%eax
  1033f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  1033f5:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  1033f8:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  1033fc:	8b 55 f8             	mov    -0x8(%ebp),%edx
  1033ff:	89 d7                	mov    %edx,%edi
  103401:	f3 aa                	rep stos %al,%es:(%edi)
  103403:	89 fa                	mov    %edi,%edx
  103405:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  103408:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  10340b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  10340e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  103411:	c9                   	leave  
  103412:	c3                   	ret    

00103413 <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  103413:	55                   	push   %ebp
  103414:	89 e5                	mov    %esp,%ebp
  103416:	57                   	push   %edi
  103417:	56                   	push   %esi
  103418:	53                   	push   %ebx
  103419:	83 ec 30             	sub    $0x30,%esp
  10341c:	8b 45 08             	mov    0x8(%ebp),%eax
  10341f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103422:	8b 45 0c             	mov    0xc(%ebp),%eax
  103425:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103428:	8b 45 10             	mov    0x10(%ebp),%eax
  10342b:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  10342e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103431:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  103434:	73 42                	jae    103478 <memmove+0x65>
  103436:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103439:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10343c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10343f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103442:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103445:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  103448:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10344b:	c1 e8 02             	shr    $0x2,%eax
  10344e:	89 c1                	mov    %eax,%ecx
    asm volatile (
  103450:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103453:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103456:	89 d7                	mov    %edx,%edi
  103458:	89 c6                	mov    %eax,%esi
  10345a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  10345c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  10345f:	83 e1 03             	and    $0x3,%ecx
  103462:	74 02                	je     103466 <memmove+0x53>
  103464:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  103466:	89 f0                	mov    %esi,%eax
  103468:	89 fa                	mov    %edi,%edx
  10346a:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  10346d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  103470:	89 45 d0             	mov    %eax,-0x30(%ebp)
            : "memory");
    return dst;
  103473:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
  103476:	eb 36                	jmp    1034ae <memmove+0x9b>
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  103478:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10347b:	8d 50 ff             	lea    -0x1(%eax),%edx
  10347e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103481:	01 c2                	add    %eax,%edx
  103483:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103486:	8d 48 ff             	lea    -0x1(%eax),%ecx
  103489:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10348c:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  10348f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103492:	89 c1                	mov    %eax,%ecx
  103494:	89 d8                	mov    %ebx,%eax
  103496:	89 d6                	mov    %edx,%esi
  103498:	89 c7                	mov    %eax,%edi
  10349a:	fd                   	std    
  10349b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  10349d:	fc                   	cld    
  10349e:	89 f8                	mov    %edi,%eax
  1034a0:	89 f2                	mov    %esi,%edx
  1034a2:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  1034a5:	89 55 c8             	mov    %edx,-0x38(%ebp)
  1034a8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  1034ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  1034ae:	83 c4 30             	add    $0x30,%esp
  1034b1:	5b                   	pop    %ebx
  1034b2:	5e                   	pop    %esi
  1034b3:	5f                   	pop    %edi
  1034b4:	5d                   	pop    %ebp
  1034b5:	c3                   	ret    

001034b6 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  1034b6:	55                   	push   %ebp
  1034b7:	89 e5                	mov    %esp,%ebp
  1034b9:	57                   	push   %edi
  1034ba:	56                   	push   %esi
  1034bb:	83 ec 20             	sub    $0x20,%esp
  1034be:	8b 45 08             	mov    0x8(%ebp),%eax
  1034c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1034c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1034ca:	8b 45 10             	mov    0x10(%ebp),%eax
  1034cd:	89 45 ec             	mov    %eax,-0x14(%ebp)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  1034d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1034d3:	c1 e8 02             	shr    $0x2,%eax
  1034d6:	89 c1                	mov    %eax,%ecx
    asm volatile (
  1034d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1034db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1034de:	89 d7                	mov    %edx,%edi
  1034e0:	89 c6                	mov    %eax,%esi
  1034e2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1034e4:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  1034e7:	83 e1 03             	and    $0x3,%ecx
  1034ea:	74 02                	je     1034ee <memcpy+0x38>
  1034ec:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1034ee:	89 f0                	mov    %esi,%eax
  1034f0:	89 fa                	mov    %edi,%edx
  1034f2:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1034f5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  1034f8:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  1034fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  1034fe:	83 c4 20             	add    $0x20,%esp
  103501:	5e                   	pop    %esi
  103502:	5f                   	pop    %edi
  103503:	5d                   	pop    %ebp
  103504:	c3                   	ret    

00103505 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  103505:	55                   	push   %ebp
  103506:	89 e5                	mov    %esp,%ebp
  103508:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  10350b:	8b 45 08             	mov    0x8(%ebp),%eax
  10350e:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  103511:	8b 45 0c             	mov    0xc(%ebp),%eax
  103514:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  103517:	eb 30                	jmp    103549 <memcmp+0x44>
        if (*s1 != *s2) {
  103519:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10351c:	0f b6 10             	movzbl (%eax),%edx
  10351f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103522:	0f b6 00             	movzbl (%eax),%eax
  103525:	38 c2                	cmp    %al,%dl
  103527:	74 18                	je     103541 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  103529:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10352c:	0f b6 00             	movzbl (%eax),%eax
  10352f:	0f b6 d0             	movzbl %al,%edx
  103532:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103535:	0f b6 00             	movzbl (%eax),%eax
  103538:	0f b6 c8             	movzbl %al,%ecx
  10353b:	89 d0                	mov    %edx,%eax
  10353d:	29 c8                	sub    %ecx,%eax
  10353f:	eb 1a                	jmp    10355b <memcmp+0x56>
        }
        s1 ++, s2 ++;
  103541:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  103545:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
    while (n -- > 0) {
  103549:	8b 45 10             	mov    0x10(%ebp),%eax
  10354c:	8d 50 ff             	lea    -0x1(%eax),%edx
  10354f:	89 55 10             	mov    %edx,0x10(%ebp)
  103552:	85 c0                	test   %eax,%eax
  103554:	75 c3                	jne    103519 <memcmp+0x14>
    }
    return 0;
  103556:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10355b:	c9                   	leave  
  10355c:	c3                   	ret    
