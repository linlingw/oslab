
bin/kernel_nopage：     文件格式 elf32-i386


Disassembly of section .text:

00100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
  100000:	b8 00 a0 11 40       	mov    $0x4011a000,%eax
    movl %eax, %cr3
  100005:	0f 22 d8             	mov    %eax,%cr3

    # enable paging
    movl %cr0, %eax
  100008:	0f 20 c0             	mov    %cr0,%eax
    orl $(CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP), %eax
  10000b:	0d 2f 00 05 80       	or     $0x8005002f,%eax
    andl $~(CR0_TS | CR0_EM), %eax
  100010:	83 e0 f3             	and    $0xfffffff3,%eax
    movl %eax, %cr0
  100013:	0f 22 c0             	mov    %eax,%cr0

    # update eip
    # now, eip = 0x1.....
    leal next, %eax
  100016:	8d 05 1e 00 10 00    	lea    0x10001e,%eax
    # set eip = KERNBASE + 0x1.....
    jmp *%eax
  10001c:	ff e0                	jmp    *%eax

0010001e <next>:
next:

    # unmap va 0 ~ 4M, it's temporary mapping
    xorl %eax, %eax
  10001e:	31 c0                	xor    %eax,%eax
    movl %eax, __boot_pgdir
  100020:	a3 00 a0 11 00       	mov    %eax,0x11a000

    # set ebp, esp
    movl $0x0, %ebp
  100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
  10002a:	bc 00 90 11 00       	mov    $0x119000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
  10002f:	e8 02 00 00 00       	call   100036 <kern_init>

00100034 <spin>:

# should never get here
spin:
    jmp spin
  100034:	eb fe                	jmp    100034 <spin>

00100036 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  100036:	55                   	push   %ebp
  100037:	89 e5                	mov    %esp,%ebp
  100039:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  10003c:	b8 2c cf 11 00       	mov    $0x11cf2c,%eax
  100041:	2d 36 9a 11 00       	sub    $0x119a36,%eax
  100046:	89 44 24 08          	mov    %eax,0x8(%esp)
  10004a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100051:	00 
  100052:	c7 04 24 36 9a 11 00 	movl   $0x119a36,(%esp)
  100059:	e8 2f 5f 00 00       	call   105f8d <memset>

    cons_init();                // init the console
  10005e:	e8 ea 15 00 00       	call   10164d <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100063:	c7 45 f4 20 61 10 00 	movl   $0x106120,-0xc(%ebp)
    cprintf("%s\n\n", message);
  10006a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10006d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100071:	c7 04 24 3c 61 10 00 	movl   $0x10613c,(%esp)
  100078:	e8 d9 02 00 00       	call   100356 <cprintf>

    print_kerninfo();
  10007d:	e8 f7 07 00 00       	call   100879 <print_kerninfo>

    grade_backtrace();
  100082:	e8 90 00 00 00       	call   100117 <grade_backtrace>

    pmm_init();                 // init physical memory management
  100087:	e8 78 44 00 00       	call   104504 <pmm_init>

    pic_init();                 // init interrupt controller
  10008c:	e8 3d 17 00 00       	call   1017ce <pic_init>
    idt_init();                 // init interrupt descriptor table
  100091:	e8 c4 18 00 00       	call   10195a <idt_init>

    clock_init();               // init clock interrupt
  100096:	e8 11 0d 00 00       	call   100dac <clock_init>
    intr_enable();              // enable irq interrupt
  10009b:	e8 8c 16 00 00       	call   10172c <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  1000a0:	eb fe                	jmp    1000a0 <kern_init+0x6a>

001000a2 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  1000a2:	55                   	push   %ebp
  1000a3:	89 e5                	mov    %esp,%ebp
  1000a5:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  1000a8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1000af:	00 
  1000b0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1000b7:	00 
  1000b8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000bf:	e8 03 0c 00 00       	call   100cc7 <mon_backtrace>
}
  1000c4:	90                   	nop
  1000c5:	89 ec                	mov    %ebp,%esp
  1000c7:	5d                   	pop    %ebp
  1000c8:	c3                   	ret    

001000c9 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  1000c9:	55                   	push   %ebp
  1000ca:	89 e5                	mov    %esp,%ebp
  1000cc:	83 ec 18             	sub    $0x18,%esp
  1000cf:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000d2:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  1000d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  1000d8:	8d 5d 08             	lea    0x8(%ebp),%ebx
  1000db:	8b 45 08             	mov    0x8(%ebp),%eax
  1000de:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  1000e2:	89 54 24 08          	mov    %edx,0x8(%esp)
  1000e6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1000ea:	89 04 24             	mov    %eax,(%esp)
  1000ed:	e8 b0 ff ff ff       	call   1000a2 <grade_backtrace2>
}
  1000f2:	90                   	nop
  1000f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1000f6:	89 ec                	mov    %ebp,%esp
  1000f8:	5d                   	pop    %ebp
  1000f9:	c3                   	ret    

001000fa <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000fa:	55                   	push   %ebp
  1000fb:	89 e5                	mov    %esp,%ebp
  1000fd:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  100100:	8b 45 10             	mov    0x10(%ebp),%eax
  100103:	89 44 24 04          	mov    %eax,0x4(%esp)
  100107:	8b 45 08             	mov    0x8(%ebp),%eax
  10010a:	89 04 24             	mov    %eax,(%esp)
  10010d:	e8 b7 ff ff ff       	call   1000c9 <grade_backtrace1>
}
  100112:	90                   	nop
  100113:	89 ec                	mov    %ebp,%esp
  100115:	5d                   	pop    %ebp
  100116:	c3                   	ret    

00100117 <grade_backtrace>:

void
grade_backtrace(void) {
  100117:	55                   	push   %ebp
  100118:	89 e5                	mov    %esp,%ebp
  10011a:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  10011d:	b8 36 00 10 00       	mov    $0x100036,%eax
  100122:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  100129:	ff 
  10012a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10012e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100135:	e8 c0 ff ff ff       	call   1000fa <grade_backtrace0>
}
  10013a:	90                   	nop
  10013b:	89 ec                	mov    %ebp,%esp
  10013d:	5d                   	pop    %ebp
  10013e:	c3                   	ret    

0010013f <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  10013f:	55                   	push   %ebp
  100140:	89 e5                	mov    %esp,%ebp
  100142:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100145:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100148:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  10014b:	8c 45 f2             	mov    %es,-0xe(%ebp)
  10014e:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100151:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100155:	83 e0 03             	and    $0x3,%eax
  100158:	89 c2                	mov    %eax,%edx
  10015a:	a1 00 c0 11 00       	mov    0x11c000,%eax
  10015f:	89 54 24 08          	mov    %edx,0x8(%esp)
  100163:	89 44 24 04          	mov    %eax,0x4(%esp)
  100167:	c7 04 24 41 61 10 00 	movl   $0x106141,(%esp)
  10016e:	e8 e3 01 00 00       	call   100356 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100173:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100177:	89 c2                	mov    %eax,%edx
  100179:	a1 00 c0 11 00       	mov    0x11c000,%eax
  10017e:	89 54 24 08          	mov    %edx,0x8(%esp)
  100182:	89 44 24 04          	mov    %eax,0x4(%esp)
  100186:	c7 04 24 4f 61 10 00 	movl   $0x10614f,(%esp)
  10018d:	e8 c4 01 00 00       	call   100356 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100192:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100196:	89 c2                	mov    %eax,%edx
  100198:	a1 00 c0 11 00       	mov    0x11c000,%eax
  10019d:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001a1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001a5:	c7 04 24 5d 61 10 00 	movl   $0x10615d,(%esp)
  1001ac:	e8 a5 01 00 00       	call   100356 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  1001b1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001b5:	89 c2                	mov    %eax,%edx
  1001b7:	a1 00 c0 11 00       	mov    0x11c000,%eax
  1001bc:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001c4:	c7 04 24 6b 61 10 00 	movl   $0x10616b,(%esp)
  1001cb:	e8 86 01 00 00       	call   100356 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001d0:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001d4:	89 c2                	mov    %eax,%edx
  1001d6:	a1 00 c0 11 00       	mov    0x11c000,%eax
  1001db:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001df:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001e3:	c7 04 24 79 61 10 00 	movl   $0x106179,(%esp)
  1001ea:	e8 67 01 00 00       	call   100356 <cprintf>
    round ++;
  1001ef:	a1 00 c0 11 00       	mov    0x11c000,%eax
  1001f4:	40                   	inc    %eax
  1001f5:	a3 00 c0 11 00       	mov    %eax,0x11c000
}
  1001fa:	90                   	nop
  1001fb:	89 ec                	mov    %ebp,%esp
  1001fd:	5d                   	pop    %ebp
  1001fe:	c3                   	ret    

001001ff <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001ff:	55                   	push   %ebp
  100200:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  100202:	90                   	nop
  100203:	5d                   	pop    %ebp
  100204:	c3                   	ret    

00100205 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  100205:	55                   	push   %ebp
  100206:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  100208:	90                   	nop
  100209:	5d                   	pop    %ebp
  10020a:	c3                   	ret    

0010020b <lab1_switch_test>:

static void
lab1_switch_test(void) {
  10020b:	55                   	push   %ebp
  10020c:	89 e5                	mov    %esp,%ebp
  10020e:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  100211:	e8 29 ff ff ff       	call   10013f <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  100216:	c7 04 24 88 61 10 00 	movl   $0x106188,(%esp)
  10021d:	e8 34 01 00 00       	call   100356 <cprintf>
    lab1_switch_to_user();
  100222:	e8 d8 ff ff ff       	call   1001ff <lab1_switch_to_user>
    lab1_print_cur_status();
  100227:	e8 13 ff ff ff       	call   10013f <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  10022c:	c7 04 24 a8 61 10 00 	movl   $0x1061a8,(%esp)
  100233:	e8 1e 01 00 00       	call   100356 <cprintf>
    lab1_switch_to_kernel();
  100238:	e8 c8 ff ff ff       	call   100205 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  10023d:	e8 fd fe ff ff       	call   10013f <lab1_print_cur_status>
}
  100242:	90                   	nop
  100243:	89 ec                	mov    %ebp,%esp
  100245:	5d                   	pop    %ebp
  100246:	c3                   	ret    

00100247 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100247:	55                   	push   %ebp
  100248:	89 e5                	mov    %esp,%ebp
  10024a:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  10024d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100251:	74 13                	je     100266 <readline+0x1f>
        cprintf("%s", prompt);
  100253:	8b 45 08             	mov    0x8(%ebp),%eax
  100256:	89 44 24 04          	mov    %eax,0x4(%esp)
  10025a:	c7 04 24 c7 61 10 00 	movl   $0x1061c7,(%esp)
  100261:	e8 f0 00 00 00       	call   100356 <cprintf>
    }
    int i = 0, c;
  100266:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  10026d:	e8 73 01 00 00       	call   1003e5 <getchar>
  100272:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100275:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100279:	79 07                	jns    100282 <readline+0x3b>
            return NULL;
  10027b:	b8 00 00 00 00       	mov    $0x0,%eax
  100280:	eb 78                	jmp    1002fa <readline+0xb3>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100282:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100286:	7e 28                	jle    1002b0 <readline+0x69>
  100288:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  10028f:	7f 1f                	jg     1002b0 <readline+0x69>
            cputchar(c);
  100291:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100294:	89 04 24             	mov    %eax,(%esp)
  100297:	e8 e2 00 00 00       	call   10037e <cputchar>
            buf[i ++] = c;
  10029c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10029f:	8d 50 01             	lea    0x1(%eax),%edx
  1002a2:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1002a5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1002a8:	88 90 20 c0 11 00    	mov    %dl,0x11c020(%eax)
  1002ae:	eb 45                	jmp    1002f5 <readline+0xae>
        }
        else if (c == '\b' && i > 0) {
  1002b0:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  1002b4:	75 16                	jne    1002cc <readline+0x85>
  1002b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1002ba:	7e 10                	jle    1002cc <readline+0x85>
            cputchar(c);
  1002bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002bf:	89 04 24             	mov    %eax,(%esp)
  1002c2:	e8 b7 00 00 00       	call   10037e <cputchar>
            i --;
  1002c7:	ff 4d f4             	decl   -0xc(%ebp)
  1002ca:	eb 29                	jmp    1002f5 <readline+0xae>
        }
        else if (c == '\n' || c == '\r') {
  1002cc:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1002d0:	74 06                	je     1002d8 <readline+0x91>
  1002d2:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1002d6:	75 95                	jne    10026d <readline+0x26>
            cputchar(c);
  1002d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002db:	89 04 24             	mov    %eax,(%esp)
  1002de:	e8 9b 00 00 00       	call   10037e <cputchar>
            buf[i] = '\0';
  1002e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002e6:	05 20 c0 11 00       	add    $0x11c020,%eax
  1002eb:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002ee:	b8 20 c0 11 00       	mov    $0x11c020,%eax
  1002f3:	eb 05                	jmp    1002fa <readline+0xb3>
        c = getchar();
  1002f5:	e9 73 ff ff ff       	jmp    10026d <readline+0x26>
        }
    }
}
  1002fa:	89 ec                	mov    %ebp,%esp
  1002fc:	5d                   	pop    %ebp
  1002fd:	c3                   	ret    

001002fe <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002fe:	55                   	push   %ebp
  1002ff:	89 e5                	mov    %esp,%ebp
  100301:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100304:	8b 45 08             	mov    0x8(%ebp),%eax
  100307:	89 04 24             	mov    %eax,(%esp)
  10030a:	e8 6d 13 00 00       	call   10167c <cons_putc>
    (*cnt) ++;
  10030f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100312:	8b 00                	mov    (%eax),%eax
  100314:	8d 50 01             	lea    0x1(%eax),%edx
  100317:	8b 45 0c             	mov    0xc(%ebp),%eax
  10031a:	89 10                	mov    %edx,(%eax)
}
  10031c:	90                   	nop
  10031d:	89 ec                	mov    %ebp,%esp
  10031f:	5d                   	pop    %ebp
  100320:	c3                   	ret    

00100321 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100321:	55                   	push   %ebp
  100322:	89 e5                	mov    %esp,%ebp
  100324:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100327:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  10032e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100331:	89 44 24 0c          	mov    %eax,0xc(%esp)
  100335:	8b 45 08             	mov    0x8(%ebp),%eax
  100338:	89 44 24 08          	mov    %eax,0x8(%esp)
  10033c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10033f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100343:	c7 04 24 fe 02 10 00 	movl   $0x1002fe,(%esp)
  10034a:	e8 69 54 00 00       	call   1057b8 <vprintfmt>
    return cnt;
  10034f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100352:	89 ec                	mov    %ebp,%esp
  100354:	5d                   	pop    %ebp
  100355:	c3                   	ret    

00100356 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  100356:	55                   	push   %ebp
  100357:	89 e5                	mov    %esp,%ebp
  100359:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  10035c:	8d 45 0c             	lea    0xc(%ebp),%eax
  10035f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100362:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100365:	89 44 24 04          	mov    %eax,0x4(%esp)
  100369:	8b 45 08             	mov    0x8(%ebp),%eax
  10036c:	89 04 24             	mov    %eax,(%esp)
  10036f:	e8 ad ff ff ff       	call   100321 <vcprintf>
  100374:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  100377:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10037a:	89 ec                	mov    %ebp,%esp
  10037c:	5d                   	pop    %ebp
  10037d:	c3                   	ret    

0010037e <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  10037e:	55                   	push   %ebp
  10037f:	89 e5                	mov    %esp,%ebp
  100381:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100384:	8b 45 08             	mov    0x8(%ebp),%eax
  100387:	89 04 24             	mov    %eax,(%esp)
  10038a:	e8 ed 12 00 00       	call   10167c <cons_putc>
}
  10038f:	90                   	nop
  100390:	89 ec                	mov    %ebp,%esp
  100392:	5d                   	pop    %ebp
  100393:	c3                   	ret    

00100394 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  100394:	55                   	push   %ebp
  100395:	89 e5                	mov    %esp,%ebp
  100397:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10039a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  1003a1:	eb 13                	jmp    1003b6 <cputs+0x22>
        cputch(c, &cnt);
  1003a3:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  1003a7:	8d 55 f0             	lea    -0x10(%ebp),%edx
  1003aa:	89 54 24 04          	mov    %edx,0x4(%esp)
  1003ae:	89 04 24             	mov    %eax,(%esp)
  1003b1:	e8 48 ff ff ff       	call   1002fe <cputch>
    while ((c = *str ++) != '\0') {
  1003b6:	8b 45 08             	mov    0x8(%ebp),%eax
  1003b9:	8d 50 01             	lea    0x1(%eax),%edx
  1003bc:	89 55 08             	mov    %edx,0x8(%ebp)
  1003bf:	0f b6 00             	movzbl (%eax),%eax
  1003c2:	88 45 f7             	mov    %al,-0x9(%ebp)
  1003c5:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1003c9:	75 d8                	jne    1003a3 <cputs+0xf>
    }
    cputch('\n', &cnt);
  1003cb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1003ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  1003d2:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  1003d9:	e8 20 ff ff ff       	call   1002fe <cputch>
    return cnt;
  1003de:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1003e1:	89 ec                	mov    %ebp,%esp
  1003e3:	5d                   	pop    %ebp
  1003e4:	c3                   	ret    

001003e5 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1003e5:	55                   	push   %ebp
  1003e6:	89 e5                	mov    %esp,%ebp
  1003e8:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1003eb:	90                   	nop
  1003ec:	e8 ca 12 00 00       	call   1016bb <cons_getc>
  1003f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003f8:	74 f2                	je     1003ec <getchar+0x7>
        /* do nothing */;
    return c;
  1003fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003fd:	89 ec                	mov    %ebp,%esp
  1003ff:	5d                   	pop    %ebp
  100400:	c3                   	ret    

00100401 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  100401:	55                   	push   %ebp
  100402:	89 e5                	mov    %esp,%ebp
  100404:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  100407:	8b 45 0c             	mov    0xc(%ebp),%eax
  10040a:	8b 00                	mov    (%eax),%eax
  10040c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10040f:	8b 45 10             	mov    0x10(%ebp),%eax
  100412:	8b 00                	mov    (%eax),%eax
  100414:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100417:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  10041e:	e9 ca 00 00 00       	jmp    1004ed <stab_binsearch+0xec>
        int true_m = (l + r) / 2, m = true_m;
  100423:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100426:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100429:	01 d0                	add    %edx,%eax
  10042b:	89 c2                	mov    %eax,%edx
  10042d:	c1 ea 1f             	shr    $0x1f,%edx
  100430:	01 d0                	add    %edx,%eax
  100432:	d1 f8                	sar    %eax
  100434:	89 45 ec             	mov    %eax,-0x14(%ebp)
  100437:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10043a:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  10043d:	eb 03                	jmp    100442 <stab_binsearch+0x41>
            m --;
  10043f:	ff 4d f0             	decl   -0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
  100442:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100445:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100448:	7c 1f                	jl     100469 <stab_binsearch+0x68>
  10044a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10044d:	89 d0                	mov    %edx,%eax
  10044f:	01 c0                	add    %eax,%eax
  100451:	01 d0                	add    %edx,%eax
  100453:	c1 e0 02             	shl    $0x2,%eax
  100456:	89 c2                	mov    %eax,%edx
  100458:	8b 45 08             	mov    0x8(%ebp),%eax
  10045b:	01 d0                	add    %edx,%eax
  10045d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100461:	0f b6 c0             	movzbl %al,%eax
  100464:	39 45 14             	cmp    %eax,0x14(%ebp)
  100467:	75 d6                	jne    10043f <stab_binsearch+0x3e>
        }
        if (m < l) {    // no match in [l, m]
  100469:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10046c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10046f:	7d 09                	jge    10047a <stab_binsearch+0x79>
            l = true_m + 1;
  100471:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100474:	40                   	inc    %eax
  100475:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100478:	eb 73                	jmp    1004ed <stab_binsearch+0xec>
        }

        // actual binary search
        any_matches = 1;
  10047a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100481:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100484:	89 d0                	mov    %edx,%eax
  100486:	01 c0                	add    %eax,%eax
  100488:	01 d0                	add    %edx,%eax
  10048a:	c1 e0 02             	shl    $0x2,%eax
  10048d:	89 c2                	mov    %eax,%edx
  10048f:	8b 45 08             	mov    0x8(%ebp),%eax
  100492:	01 d0                	add    %edx,%eax
  100494:	8b 40 08             	mov    0x8(%eax),%eax
  100497:	39 45 18             	cmp    %eax,0x18(%ebp)
  10049a:	76 11                	jbe    1004ad <stab_binsearch+0xac>
            *region_left = m;
  10049c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10049f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004a2:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  1004a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1004a7:	40                   	inc    %eax
  1004a8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1004ab:	eb 40                	jmp    1004ed <stab_binsearch+0xec>
        } else if (stabs[m].n_value > addr) {
  1004ad:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004b0:	89 d0                	mov    %edx,%eax
  1004b2:	01 c0                	add    %eax,%eax
  1004b4:	01 d0                	add    %edx,%eax
  1004b6:	c1 e0 02             	shl    $0x2,%eax
  1004b9:	89 c2                	mov    %eax,%edx
  1004bb:	8b 45 08             	mov    0x8(%ebp),%eax
  1004be:	01 d0                	add    %edx,%eax
  1004c0:	8b 40 08             	mov    0x8(%eax),%eax
  1004c3:	39 45 18             	cmp    %eax,0x18(%ebp)
  1004c6:	73 14                	jae    1004dc <stab_binsearch+0xdb>
            *region_right = m - 1;
  1004c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004cb:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004ce:	8b 45 10             	mov    0x10(%ebp),%eax
  1004d1:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  1004d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004d6:	48                   	dec    %eax
  1004d7:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004da:	eb 11                	jmp    1004ed <stab_binsearch+0xec>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1004dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004df:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004e2:	89 10                	mov    %edx,(%eax)
            l = m;
  1004e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1004ea:	ff 45 18             	incl   0x18(%ebp)
    while (l <= r) {
  1004ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004f0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1004f3:	0f 8e 2a ff ff ff    	jle    100423 <stab_binsearch+0x22>
        }
    }

    if (!any_matches) {
  1004f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004fd:	75 0f                	jne    10050e <stab_binsearch+0x10d>
        *region_right = *region_left - 1;
  1004ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  100502:	8b 00                	mov    (%eax),%eax
  100504:	8d 50 ff             	lea    -0x1(%eax),%edx
  100507:	8b 45 10             	mov    0x10(%ebp),%eax
  10050a:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  10050c:	eb 3e                	jmp    10054c <stab_binsearch+0x14b>
        l = *region_right;
  10050e:	8b 45 10             	mov    0x10(%ebp),%eax
  100511:	8b 00                	mov    (%eax),%eax
  100513:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  100516:	eb 03                	jmp    10051b <stab_binsearch+0x11a>
  100518:	ff 4d fc             	decl   -0x4(%ebp)
  10051b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10051e:	8b 00                	mov    (%eax),%eax
  100520:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  100523:	7e 1f                	jle    100544 <stab_binsearch+0x143>
  100525:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100528:	89 d0                	mov    %edx,%eax
  10052a:	01 c0                	add    %eax,%eax
  10052c:	01 d0                	add    %edx,%eax
  10052e:	c1 e0 02             	shl    $0x2,%eax
  100531:	89 c2                	mov    %eax,%edx
  100533:	8b 45 08             	mov    0x8(%ebp),%eax
  100536:	01 d0                	add    %edx,%eax
  100538:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10053c:	0f b6 c0             	movzbl %al,%eax
  10053f:	39 45 14             	cmp    %eax,0x14(%ebp)
  100542:	75 d4                	jne    100518 <stab_binsearch+0x117>
        *region_left = l;
  100544:	8b 45 0c             	mov    0xc(%ebp),%eax
  100547:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10054a:	89 10                	mov    %edx,(%eax)
}
  10054c:	90                   	nop
  10054d:	89 ec                	mov    %ebp,%esp
  10054f:	5d                   	pop    %ebp
  100550:	c3                   	ret    

00100551 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  100551:	55                   	push   %ebp
  100552:	89 e5                	mov    %esp,%ebp
  100554:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100557:	8b 45 0c             	mov    0xc(%ebp),%eax
  10055a:	c7 00 cc 61 10 00    	movl   $0x1061cc,(%eax)
    info->eip_line = 0;
  100560:	8b 45 0c             	mov    0xc(%ebp),%eax
  100563:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  10056a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10056d:	c7 40 08 cc 61 10 00 	movl   $0x1061cc,0x8(%eax)
    info->eip_fn_namelen = 9;
  100574:	8b 45 0c             	mov    0xc(%ebp),%eax
  100577:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  10057e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100581:	8b 55 08             	mov    0x8(%ebp),%edx
  100584:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100587:	8b 45 0c             	mov    0xc(%ebp),%eax
  10058a:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100591:	c7 45 f4 90 74 10 00 	movl   $0x107490,-0xc(%ebp)
    stab_end = __STAB_END__;
  100598:	c7 45 f0 bc 2c 11 00 	movl   $0x112cbc,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  10059f:	c7 45 ec bd 2c 11 00 	movl   $0x112cbd,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  1005a6:	c7 45 e8 55 62 11 00 	movl   $0x116255,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  1005ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1005b0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1005b3:	76 0b                	jbe    1005c0 <debuginfo_eip+0x6f>
  1005b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1005b8:	48                   	dec    %eax
  1005b9:	0f b6 00             	movzbl (%eax),%eax
  1005bc:	84 c0                	test   %al,%al
  1005be:	74 0a                	je     1005ca <debuginfo_eip+0x79>
        return -1;
  1005c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005c5:	e9 ab 02 00 00       	jmp    100875 <debuginfo_eip+0x324>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  1005ca:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1005d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005d4:	2b 45 f4             	sub    -0xc(%ebp),%eax
  1005d7:	c1 f8 02             	sar    $0x2,%eax
  1005da:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1005e0:	48                   	dec    %eax
  1005e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1005e4:	8b 45 08             	mov    0x8(%ebp),%eax
  1005e7:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005eb:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1005f2:	00 
  1005f3:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1005f6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005fa:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1005fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  100601:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100604:	89 04 24             	mov    %eax,(%esp)
  100607:	e8 f5 fd ff ff       	call   100401 <stab_binsearch>
    if (lfile == 0)
  10060c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10060f:	85 c0                	test   %eax,%eax
  100611:	75 0a                	jne    10061d <debuginfo_eip+0xcc>
        return -1;
  100613:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100618:	e9 58 02 00 00       	jmp    100875 <debuginfo_eip+0x324>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  10061d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100620:	89 45 dc             	mov    %eax,-0x24(%ebp)
  100623:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100626:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  100629:	8b 45 08             	mov    0x8(%ebp),%eax
  10062c:	89 44 24 10          	mov    %eax,0x10(%esp)
  100630:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  100637:	00 
  100638:	8d 45 d8             	lea    -0x28(%ebp),%eax
  10063b:	89 44 24 08          	mov    %eax,0x8(%esp)
  10063f:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100642:	89 44 24 04          	mov    %eax,0x4(%esp)
  100646:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100649:	89 04 24             	mov    %eax,(%esp)
  10064c:	e8 b0 fd ff ff       	call   100401 <stab_binsearch>

    if (lfun <= rfun) {
  100651:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100654:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100657:	39 c2                	cmp    %eax,%edx
  100659:	7f 78                	jg     1006d3 <debuginfo_eip+0x182>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  10065b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10065e:	89 c2                	mov    %eax,%edx
  100660:	89 d0                	mov    %edx,%eax
  100662:	01 c0                	add    %eax,%eax
  100664:	01 d0                	add    %edx,%eax
  100666:	c1 e0 02             	shl    $0x2,%eax
  100669:	89 c2                	mov    %eax,%edx
  10066b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10066e:	01 d0                	add    %edx,%eax
  100670:	8b 10                	mov    (%eax),%edx
  100672:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100675:	2b 45 ec             	sub    -0x14(%ebp),%eax
  100678:	39 c2                	cmp    %eax,%edx
  10067a:	73 22                	jae    10069e <debuginfo_eip+0x14d>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  10067c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10067f:	89 c2                	mov    %eax,%edx
  100681:	89 d0                	mov    %edx,%eax
  100683:	01 c0                	add    %eax,%eax
  100685:	01 d0                	add    %edx,%eax
  100687:	c1 e0 02             	shl    $0x2,%eax
  10068a:	89 c2                	mov    %eax,%edx
  10068c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10068f:	01 d0                	add    %edx,%eax
  100691:	8b 10                	mov    (%eax),%edx
  100693:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100696:	01 c2                	add    %eax,%edx
  100698:	8b 45 0c             	mov    0xc(%ebp),%eax
  10069b:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  10069e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006a1:	89 c2                	mov    %eax,%edx
  1006a3:	89 d0                	mov    %edx,%eax
  1006a5:	01 c0                	add    %eax,%eax
  1006a7:	01 d0                	add    %edx,%eax
  1006a9:	c1 e0 02             	shl    $0x2,%eax
  1006ac:	89 c2                	mov    %eax,%edx
  1006ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006b1:	01 d0                	add    %edx,%eax
  1006b3:	8b 50 08             	mov    0x8(%eax),%edx
  1006b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006b9:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  1006bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006bf:	8b 40 10             	mov    0x10(%eax),%eax
  1006c2:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  1006c5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006c8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  1006cb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006ce:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1006d1:	eb 15                	jmp    1006e8 <debuginfo_eip+0x197>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1006d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006d6:	8b 55 08             	mov    0x8(%ebp),%edx
  1006d9:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1006dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006df:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1006e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006e5:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1006e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006eb:	8b 40 08             	mov    0x8(%eax),%eax
  1006ee:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1006f5:	00 
  1006f6:	89 04 24             	mov    %eax,(%esp)
  1006f9:	e8 07 57 00 00       	call   105e05 <strfind>
  1006fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  100701:	8b 4a 08             	mov    0x8(%edx),%ecx
  100704:	29 c8                	sub    %ecx,%eax
  100706:	89 c2                	mov    %eax,%edx
  100708:	8b 45 0c             	mov    0xc(%ebp),%eax
  10070b:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  10070e:	8b 45 08             	mov    0x8(%ebp),%eax
  100711:	89 44 24 10          	mov    %eax,0x10(%esp)
  100715:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  10071c:	00 
  10071d:	8d 45 d0             	lea    -0x30(%ebp),%eax
  100720:	89 44 24 08          	mov    %eax,0x8(%esp)
  100724:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  100727:	89 44 24 04          	mov    %eax,0x4(%esp)
  10072b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10072e:	89 04 24             	mov    %eax,(%esp)
  100731:	e8 cb fc ff ff       	call   100401 <stab_binsearch>
    if (lline <= rline) {
  100736:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100739:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10073c:	39 c2                	cmp    %eax,%edx
  10073e:	7f 23                	jg     100763 <debuginfo_eip+0x212>
        info->eip_line = stabs[rline].n_desc;
  100740:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100743:	89 c2                	mov    %eax,%edx
  100745:	89 d0                	mov    %edx,%eax
  100747:	01 c0                	add    %eax,%eax
  100749:	01 d0                	add    %edx,%eax
  10074b:	c1 e0 02             	shl    $0x2,%eax
  10074e:	89 c2                	mov    %eax,%edx
  100750:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100753:	01 d0                	add    %edx,%eax
  100755:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  100759:	89 c2                	mov    %eax,%edx
  10075b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10075e:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100761:	eb 11                	jmp    100774 <debuginfo_eip+0x223>
        return -1;
  100763:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100768:	e9 08 01 00 00       	jmp    100875 <debuginfo_eip+0x324>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  10076d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100770:	48                   	dec    %eax
  100771:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
  100774:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100777:	8b 45 e4             	mov    -0x1c(%ebp),%eax
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  10077a:	39 c2                	cmp    %eax,%edx
  10077c:	7c 56                	jl     1007d4 <debuginfo_eip+0x283>
           && stabs[lline].n_type != N_SOL
  10077e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100781:	89 c2                	mov    %eax,%edx
  100783:	89 d0                	mov    %edx,%eax
  100785:	01 c0                	add    %eax,%eax
  100787:	01 d0                	add    %edx,%eax
  100789:	c1 e0 02             	shl    $0x2,%eax
  10078c:	89 c2                	mov    %eax,%edx
  10078e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100791:	01 d0                	add    %edx,%eax
  100793:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100797:	3c 84                	cmp    $0x84,%al
  100799:	74 39                	je     1007d4 <debuginfo_eip+0x283>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  10079b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10079e:	89 c2                	mov    %eax,%edx
  1007a0:	89 d0                	mov    %edx,%eax
  1007a2:	01 c0                	add    %eax,%eax
  1007a4:	01 d0                	add    %edx,%eax
  1007a6:	c1 e0 02             	shl    $0x2,%eax
  1007a9:	89 c2                	mov    %eax,%edx
  1007ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007ae:	01 d0                	add    %edx,%eax
  1007b0:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1007b4:	3c 64                	cmp    $0x64,%al
  1007b6:	75 b5                	jne    10076d <debuginfo_eip+0x21c>
  1007b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007bb:	89 c2                	mov    %eax,%edx
  1007bd:	89 d0                	mov    %edx,%eax
  1007bf:	01 c0                	add    %eax,%eax
  1007c1:	01 d0                	add    %edx,%eax
  1007c3:	c1 e0 02             	shl    $0x2,%eax
  1007c6:	89 c2                	mov    %eax,%edx
  1007c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007cb:	01 d0                	add    %edx,%eax
  1007cd:	8b 40 08             	mov    0x8(%eax),%eax
  1007d0:	85 c0                	test   %eax,%eax
  1007d2:	74 99                	je     10076d <debuginfo_eip+0x21c>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1007d4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007da:	39 c2                	cmp    %eax,%edx
  1007dc:	7c 42                	jl     100820 <debuginfo_eip+0x2cf>
  1007de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007e1:	89 c2                	mov    %eax,%edx
  1007e3:	89 d0                	mov    %edx,%eax
  1007e5:	01 c0                	add    %eax,%eax
  1007e7:	01 d0                	add    %edx,%eax
  1007e9:	c1 e0 02             	shl    $0x2,%eax
  1007ec:	89 c2                	mov    %eax,%edx
  1007ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007f1:	01 d0                	add    %edx,%eax
  1007f3:	8b 10                	mov    (%eax),%edx
  1007f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1007f8:	2b 45 ec             	sub    -0x14(%ebp),%eax
  1007fb:	39 c2                	cmp    %eax,%edx
  1007fd:	73 21                	jae    100820 <debuginfo_eip+0x2cf>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1007ff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100802:	89 c2                	mov    %eax,%edx
  100804:	89 d0                	mov    %edx,%eax
  100806:	01 c0                	add    %eax,%eax
  100808:	01 d0                	add    %edx,%eax
  10080a:	c1 e0 02             	shl    $0x2,%eax
  10080d:	89 c2                	mov    %eax,%edx
  10080f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100812:	01 d0                	add    %edx,%eax
  100814:	8b 10                	mov    (%eax),%edx
  100816:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100819:	01 c2                	add    %eax,%edx
  10081b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10081e:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  100820:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100823:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100826:	39 c2                	cmp    %eax,%edx
  100828:	7d 46                	jge    100870 <debuginfo_eip+0x31f>
        for (lline = lfun + 1;
  10082a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10082d:	40                   	inc    %eax
  10082e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  100831:	eb 16                	jmp    100849 <debuginfo_eip+0x2f8>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  100833:	8b 45 0c             	mov    0xc(%ebp),%eax
  100836:	8b 40 14             	mov    0x14(%eax),%eax
  100839:	8d 50 01             	lea    0x1(%eax),%edx
  10083c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10083f:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
  100842:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100845:	40                   	inc    %eax
  100846:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100849:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10084c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10084f:	39 c2                	cmp    %eax,%edx
  100851:	7d 1d                	jge    100870 <debuginfo_eip+0x31f>
  100853:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100856:	89 c2                	mov    %eax,%edx
  100858:	89 d0                	mov    %edx,%eax
  10085a:	01 c0                	add    %eax,%eax
  10085c:	01 d0                	add    %edx,%eax
  10085e:	c1 e0 02             	shl    $0x2,%eax
  100861:	89 c2                	mov    %eax,%edx
  100863:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100866:	01 d0                	add    %edx,%eax
  100868:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10086c:	3c a0                	cmp    $0xa0,%al
  10086e:	74 c3                	je     100833 <debuginfo_eip+0x2e2>
        }
    }
    return 0;
  100870:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100875:	89 ec                	mov    %ebp,%esp
  100877:	5d                   	pop    %ebp
  100878:	c3                   	ret    

00100879 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100879:	55                   	push   %ebp
  10087a:	89 e5                	mov    %esp,%ebp
  10087c:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  10087f:	c7 04 24 d6 61 10 00 	movl   $0x1061d6,(%esp)
  100886:	e8 cb fa ff ff       	call   100356 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  10088b:	c7 44 24 04 36 00 10 	movl   $0x100036,0x4(%esp)
  100892:	00 
  100893:	c7 04 24 ef 61 10 00 	movl   $0x1061ef,(%esp)
  10089a:	e8 b7 fa ff ff       	call   100356 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  10089f:	c7 44 24 04 19 61 10 	movl   $0x106119,0x4(%esp)
  1008a6:	00 
  1008a7:	c7 04 24 07 62 10 00 	movl   $0x106207,(%esp)
  1008ae:	e8 a3 fa ff ff       	call   100356 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  1008b3:	c7 44 24 04 36 9a 11 	movl   $0x119a36,0x4(%esp)
  1008ba:	00 
  1008bb:	c7 04 24 1f 62 10 00 	movl   $0x10621f,(%esp)
  1008c2:	e8 8f fa ff ff       	call   100356 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1008c7:	c7 44 24 04 2c cf 11 	movl   $0x11cf2c,0x4(%esp)
  1008ce:	00 
  1008cf:	c7 04 24 37 62 10 00 	movl   $0x106237,(%esp)
  1008d6:	e8 7b fa ff ff       	call   100356 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1008db:	b8 2c cf 11 00       	mov    $0x11cf2c,%eax
  1008e0:	2d 36 00 10 00       	sub    $0x100036,%eax
  1008e5:	05 ff 03 00 00       	add    $0x3ff,%eax
  1008ea:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008f0:	85 c0                	test   %eax,%eax
  1008f2:	0f 48 c2             	cmovs  %edx,%eax
  1008f5:	c1 f8 0a             	sar    $0xa,%eax
  1008f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008fc:	c7 04 24 50 62 10 00 	movl   $0x106250,(%esp)
  100903:	e8 4e fa ff ff       	call   100356 <cprintf>
}
  100908:	90                   	nop
  100909:	89 ec                	mov    %ebp,%esp
  10090b:	5d                   	pop    %ebp
  10090c:	c3                   	ret    

0010090d <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  10090d:	55                   	push   %ebp
  10090e:	89 e5                	mov    %esp,%ebp
  100910:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  100916:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100919:	89 44 24 04          	mov    %eax,0x4(%esp)
  10091d:	8b 45 08             	mov    0x8(%ebp),%eax
  100920:	89 04 24             	mov    %eax,(%esp)
  100923:	e8 29 fc ff ff       	call   100551 <debuginfo_eip>
  100928:	85 c0                	test   %eax,%eax
  10092a:	74 15                	je     100941 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  10092c:	8b 45 08             	mov    0x8(%ebp),%eax
  10092f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100933:	c7 04 24 7a 62 10 00 	movl   $0x10627a,(%esp)
  10093a:	e8 17 fa ff ff       	call   100356 <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  10093f:	eb 6c                	jmp    1009ad <print_debuginfo+0xa0>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100941:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100948:	eb 1b                	jmp    100965 <print_debuginfo+0x58>
            fnname[j] = info.eip_fn_name[j];
  10094a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10094d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100950:	01 d0                	add    %edx,%eax
  100952:	0f b6 10             	movzbl (%eax),%edx
  100955:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  10095b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10095e:	01 c8                	add    %ecx,%eax
  100960:	88 10                	mov    %dl,(%eax)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100962:	ff 45 f4             	incl   -0xc(%ebp)
  100965:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100968:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  10096b:	7c dd                	jl     10094a <print_debuginfo+0x3d>
        fnname[j] = '\0';
  10096d:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100973:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100976:	01 d0                	add    %edx,%eax
  100978:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
  10097b:	8b 55 ec             	mov    -0x14(%ebp),%edx
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  10097e:	8b 45 08             	mov    0x8(%ebp),%eax
  100981:	29 d0                	sub    %edx,%eax
  100983:	89 c1                	mov    %eax,%ecx
  100985:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100988:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10098b:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  10098f:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100995:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100999:	89 54 24 08          	mov    %edx,0x8(%esp)
  10099d:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009a1:	c7 04 24 96 62 10 00 	movl   $0x106296,(%esp)
  1009a8:	e8 a9 f9 ff ff       	call   100356 <cprintf>
}
  1009ad:	90                   	nop
  1009ae:	89 ec                	mov    %ebp,%esp
  1009b0:	5d                   	pop    %ebp
  1009b1:	c3                   	ret    

001009b2 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  1009b2:	55                   	push   %ebp
  1009b3:	89 e5                	mov    %esp,%ebp
  1009b5:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  1009b8:	8b 45 04             	mov    0x4(%ebp),%eax
  1009bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  1009be:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1009c1:	89 ec                	mov    %ebp,%esp
  1009c3:	5d                   	pop    %ebp
  1009c4:	c3                   	ret    

001009c5 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  1009c5:	55                   	push   %ebp
  1009c6:	89 e5                	mov    %esp,%ebp
  1009c8:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  1009cb:	89 e8                	mov    %ebp,%eax
  1009cd:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  1009d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
     /* LAB1 YOUR CODE : STEP 1 */
     uint32_t ebp = read_ebp();// (1) call read_ebp() to get the value of ebp. the type is (uint32_t);
  1009d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
     uint32_t eip = read_eip();// (2) call read_eip() to get the value of eip. the type is (uint32_t);
  1009d6:	e8 d7 ff ff ff       	call   1009b2 <read_eip>
  1009db:	89 45 f0             	mov    %eax,-0x10(%ebp)

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) 
  1009de:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1009e5:	e9 84 00 00 00       	jmp    100a6e <print_stackframe+0xa9>
    {// (3) from 0 .. STACKFRAME_DEPTH
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);//    (3.1) printf value of ebp, eip
  1009ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1009ed:	89 44 24 08          	mov    %eax,0x8(%esp)
  1009f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009f8:	c7 04 24 a8 62 10 00 	movl   $0x1062a8,(%esp)
  1009ff:	e8 52 f9 ff ff       	call   100356 <cprintf>
        uint32_t *args = (uint32_t *)ebp + 2;
  100a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a07:	83 c0 08             	add    $0x8,%eax
  100a0a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (j = 0; j < 4; j ++) 
  100a0d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100a14:	eb 24                	jmp    100a3a <print_stackframe+0x75>
        {
            cprintf("0x%08x ", args[j]);
  100a16:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a19:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100a20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100a23:	01 d0                	add    %edx,%eax
  100a25:	8b 00                	mov    (%eax),%eax
  100a27:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a2b:	c7 04 24 c4 62 10 00 	movl   $0x1062c4,(%esp)
  100a32:	e8 1f f9 ff ff       	call   100356 <cprintf>
        for (j = 0; j < 4; j ++) 
  100a37:	ff 45 e8             	incl   -0x18(%ebp)
  100a3a:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100a3e:	7e d6                	jle    100a16 <print_stackframe+0x51>
        }//    (3.2) (uint32_t)calling arguments [0..4] = the contents in address (uint32_t)ebp +2 [0..4]
        cprintf("\n");//    (3.3) cprintf("\n");
  100a40:	c7 04 24 cc 62 10 00 	movl   $0x1062cc,(%esp)
  100a47:	e8 0a f9 ff ff       	call   100356 <cprintf>
        print_debuginfo(eip - 1);//    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
  100a4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a4f:	48                   	dec    %eax
  100a50:	89 04 24             	mov    %eax,(%esp)
  100a53:	e8 b5 fe ff ff       	call   10090d <print_debuginfo>
        eip = ((uint32_t *)ebp)[1];
  100a58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a5b:	83 c0 04             	add    $0x4,%eax
  100a5e:	8b 00                	mov    (%eax),%eax
  100a60:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];//	(3.5) popup a calling stackframe
  100a63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a66:	8b 00                	mov    (%eax),%eax
  100a68:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) 
  100a6b:	ff 45 ec             	incl   -0x14(%ebp)
  100a6e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100a72:	74 0a                	je     100a7e <print_stackframe+0xb9>
  100a74:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100a78:	0f 8e 6c ff ff ff    	jle    1009ea <print_stackframe+0x25>
      	//	NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      	//	the calling funciton's ebp = ss:[ebp]
    }
}
  100a7e:	90                   	nop
  100a7f:	89 ec                	mov    %ebp,%esp
  100a81:	5d                   	pop    %ebp
  100a82:	c3                   	ret    

00100a83 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a83:	55                   	push   %ebp
  100a84:	89 e5                	mov    %esp,%ebp
  100a86:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100a89:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a90:	eb 0c                	jmp    100a9e <parse+0x1b>
            *buf ++ = '\0';
  100a92:	8b 45 08             	mov    0x8(%ebp),%eax
  100a95:	8d 50 01             	lea    0x1(%eax),%edx
  100a98:	89 55 08             	mov    %edx,0x8(%ebp)
  100a9b:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  100aa1:	0f b6 00             	movzbl (%eax),%eax
  100aa4:	84 c0                	test   %al,%al
  100aa6:	74 1d                	je     100ac5 <parse+0x42>
  100aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  100aab:	0f b6 00             	movzbl (%eax),%eax
  100aae:	0f be c0             	movsbl %al,%eax
  100ab1:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ab5:	c7 04 24 50 63 10 00 	movl   $0x106350,(%esp)
  100abc:	e8 10 53 00 00       	call   105dd1 <strchr>
  100ac1:	85 c0                	test   %eax,%eax
  100ac3:	75 cd                	jne    100a92 <parse+0xf>
        }
        if (*buf == '\0') {
  100ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  100ac8:	0f b6 00             	movzbl (%eax),%eax
  100acb:	84 c0                	test   %al,%al
  100acd:	74 65                	je     100b34 <parse+0xb1>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100acf:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100ad3:	75 14                	jne    100ae9 <parse+0x66>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100ad5:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100adc:	00 
  100add:	c7 04 24 55 63 10 00 	movl   $0x106355,(%esp)
  100ae4:	e8 6d f8 ff ff       	call   100356 <cprintf>
        }
        argv[argc ++] = buf;
  100ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100aec:	8d 50 01             	lea    0x1(%eax),%edx
  100aef:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100af2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100af9:	8b 45 0c             	mov    0xc(%ebp),%eax
  100afc:	01 c2                	add    %eax,%edx
  100afe:	8b 45 08             	mov    0x8(%ebp),%eax
  100b01:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b03:	eb 03                	jmp    100b08 <parse+0x85>
            buf ++;
  100b05:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b08:	8b 45 08             	mov    0x8(%ebp),%eax
  100b0b:	0f b6 00             	movzbl (%eax),%eax
  100b0e:	84 c0                	test   %al,%al
  100b10:	74 8c                	je     100a9e <parse+0x1b>
  100b12:	8b 45 08             	mov    0x8(%ebp),%eax
  100b15:	0f b6 00             	movzbl (%eax),%eax
  100b18:	0f be c0             	movsbl %al,%eax
  100b1b:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b1f:	c7 04 24 50 63 10 00 	movl   $0x106350,(%esp)
  100b26:	e8 a6 52 00 00       	call   105dd1 <strchr>
  100b2b:	85 c0                	test   %eax,%eax
  100b2d:	74 d6                	je     100b05 <parse+0x82>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b2f:	e9 6a ff ff ff       	jmp    100a9e <parse+0x1b>
            break;
  100b34:	90                   	nop
        }
    }
    return argc;
  100b35:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100b38:	89 ec                	mov    %ebp,%esp
  100b3a:	5d                   	pop    %ebp
  100b3b:	c3                   	ret    

00100b3c <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100b3c:	55                   	push   %ebp
  100b3d:	89 e5                	mov    %esp,%ebp
  100b3f:	83 ec 68             	sub    $0x68,%esp
  100b42:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100b45:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b48:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  100b4f:	89 04 24             	mov    %eax,(%esp)
  100b52:	e8 2c ff ff ff       	call   100a83 <parse>
  100b57:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100b5a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b5e:	75 0a                	jne    100b6a <runcmd+0x2e>
        return 0;
  100b60:	b8 00 00 00 00       	mov    $0x0,%eax
  100b65:	e9 83 00 00 00       	jmp    100bed <runcmd+0xb1>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b6a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b71:	eb 5a                	jmp    100bcd <runcmd+0x91>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b73:	8b 55 b0             	mov    -0x50(%ebp),%edx
  100b76:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  100b79:	89 c8                	mov    %ecx,%eax
  100b7b:	01 c0                	add    %eax,%eax
  100b7d:	01 c8                	add    %ecx,%eax
  100b7f:	c1 e0 02             	shl    $0x2,%eax
  100b82:	05 00 90 11 00       	add    $0x119000,%eax
  100b87:	8b 00                	mov    (%eax),%eax
  100b89:	89 54 24 04          	mov    %edx,0x4(%esp)
  100b8d:	89 04 24             	mov    %eax,(%esp)
  100b90:	e8 a0 51 00 00       	call   105d35 <strcmp>
  100b95:	85 c0                	test   %eax,%eax
  100b97:	75 31                	jne    100bca <runcmd+0x8e>
            return commands[i].func(argc - 1, argv + 1, tf);
  100b99:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b9c:	89 d0                	mov    %edx,%eax
  100b9e:	01 c0                	add    %eax,%eax
  100ba0:	01 d0                	add    %edx,%eax
  100ba2:	c1 e0 02             	shl    $0x2,%eax
  100ba5:	05 08 90 11 00       	add    $0x119008,%eax
  100baa:	8b 10                	mov    (%eax),%edx
  100bac:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100baf:	83 c0 04             	add    $0x4,%eax
  100bb2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100bb5:	8d 59 ff             	lea    -0x1(%ecx),%ebx
  100bb8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  100bbb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100bbf:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bc3:	89 1c 24             	mov    %ebx,(%esp)
  100bc6:	ff d2                	call   *%edx
  100bc8:	eb 23                	jmp    100bed <runcmd+0xb1>
    for (i = 0; i < NCOMMANDS; i ++) {
  100bca:	ff 45 f4             	incl   -0xc(%ebp)
  100bcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bd0:	83 f8 02             	cmp    $0x2,%eax
  100bd3:	76 9e                	jbe    100b73 <runcmd+0x37>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100bd5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100bd8:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bdc:	c7 04 24 73 63 10 00 	movl   $0x106373,(%esp)
  100be3:	e8 6e f7 ff ff       	call   100356 <cprintf>
    return 0;
  100be8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100bed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100bf0:	89 ec                	mov    %ebp,%esp
  100bf2:	5d                   	pop    %ebp
  100bf3:	c3                   	ret    

00100bf4 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100bf4:	55                   	push   %ebp
  100bf5:	89 e5                	mov    %esp,%ebp
  100bf7:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100bfa:	c7 04 24 8c 63 10 00 	movl   $0x10638c,(%esp)
  100c01:	e8 50 f7 ff ff       	call   100356 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100c06:	c7 04 24 b4 63 10 00 	movl   $0x1063b4,(%esp)
  100c0d:	e8 44 f7 ff ff       	call   100356 <cprintf>

    if (tf != NULL) {
  100c12:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100c16:	74 0b                	je     100c23 <kmonitor+0x2f>
        print_trapframe(tf);
  100c18:	8b 45 08             	mov    0x8(%ebp),%eax
  100c1b:	89 04 24             	mov    %eax,(%esp)
  100c1e:	e8 f2 0e 00 00       	call   101b15 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100c23:	c7 04 24 d9 63 10 00 	movl   $0x1063d9,(%esp)
  100c2a:	e8 18 f6 ff ff       	call   100247 <readline>
  100c2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100c32:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100c36:	74 eb                	je     100c23 <kmonitor+0x2f>
            if (runcmd(buf, tf) < 0) {
  100c38:	8b 45 08             	mov    0x8(%ebp),%eax
  100c3b:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c42:	89 04 24             	mov    %eax,(%esp)
  100c45:	e8 f2 fe ff ff       	call   100b3c <runcmd>
  100c4a:	85 c0                	test   %eax,%eax
  100c4c:	78 02                	js     100c50 <kmonitor+0x5c>
        if ((buf = readline("K> ")) != NULL) {
  100c4e:	eb d3                	jmp    100c23 <kmonitor+0x2f>
                break;
  100c50:	90                   	nop
            }
        }
    }
}
  100c51:	90                   	nop
  100c52:	89 ec                	mov    %ebp,%esp
  100c54:	5d                   	pop    %ebp
  100c55:	c3                   	ret    

00100c56 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100c56:	55                   	push   %ebp
  100c57:	89 e5                	mov    %esp,%ebp
  100c59:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c5c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c63:	eb 3d                	jmp    100ca2 <mon_help+0x4c>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c65:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c68:	89 d0                	mov    %edx,%eax
  100c6a:	01 c0                	add    %eax,%eax
  100c6c:	01 d0                	add    %edx,%eax
  100c6e:	c1 e0 02             	shl    $0x2,%eax
  100c71:	05 04 90 11 00       	add    $0x119004,%eax
  100c76:	8b 10                	mov    (%eax),%edx
  100c78:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  100c7b:	89 c8                	mov    %ecx,%eax
  100c7d:	01 c0                	add    %eax,%eax
  100c7f:	01 c8                	add    %ecx,%eax
  100c81:	c1 e0 02             	shl    $0x2,%eax
  100c84:	05 00 90 11 00       	add    $0x119000,%eax
  100c89:	8b 00                	mov    (%eax),%eax
  100c8b:	89 54 24 08          	mov    %edx,0x8(%esp)
  100c8f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c93:	c7 04 24 dd 63 10 00 	movl   $0x1063dd,(%esp)
  100c9a:	e8 b7 f6 ff ff       	call   100356 <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
  100c9f:	ff 45 f4             	incl   -0xc(%ebp)
  100ca2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ca5:	83 f8 02             	cmp    $0x2,%eax
  100ca8:	76 bb                	jbe    100c65 <mon_help+0xf>
    }
    return 0;
  100caa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100caf:	89 ec                	mov    %ebp,%esp
  100cb1:	5d                   	pop    %ebp
  100cb2:	c3                   	ret    

00100cb3 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100cb3:	55                   	push   %ebp
  100cb4:	89 e5                	mov    %esp,%ebp
  100cb6:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100cb9:	e8 bb fb ff ff       	call   100879 <print_kerninfo>
    return 0;
  100cbe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cc3:	89 ec                	mov    %ebp,%esp
  100cc5:	5d                   	pop    %ebp
  100cc6:	c3                   	ret    

00100cc7 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100cc7:	55                   	push   %ebp
  100cc8:	89 e5                	mov    %esp,%ebp
  100cca:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100ccd:	e8 f3 fc ff ff       	call   1009c5 <print_stackframe>
    return 0;
  100cd2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cd7:	89 ec                	mov    %ebp,%esp
  100cd9:	5d                   	pop    %ebp
  100cda:	c3                   	ret    

00100cdb <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100cdb:	55                   	push   %ebp
  100cdc:	89 e5                	mov    %esp,%ebp
  100cde:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100ce1:	a1 20 c4 11 00       	mov    0x11c420,%eax
  100ce6:	85 c0                	test   %eax,%eax
  100ce8:	75 5b                	jne    100d45 <__panic+0x6a>
        goto panic_dead;
    }
    is_panic = 1;
  100cea:	c7 05 20 c4 11 00 01 	movl   $0x1,0x11c420
  100cf1:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100cf4:	8d 45 14             	lea    0x14(%ebp),%eax
  100cf7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100cfa:	8b 45 0c             	mov    0xc(%ebp),%eax
  100cfd:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d01:	8b 45 08             	mov    0x8(%ebp),%eax
  100d04:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d08:	c7 04 24 e6 63 10 00 	movl   $0x1063e6,(%esp)
  100d0f:	e8 42 f6 ff ff       	call   100356 <cprintf>
    vcprintf(fmt, ap);
  100d14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d17:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d1b:	8b 45 10             	mov    0x10(%ebp),%eax
  100d1e:	89 04 24             	mov    %eax,(%esp)
  100d21:	e8 fb f5 ff ff       	call   100321 <vcprintf>
    cprintf("\n");
  100d26:	c7 04 24 02 64 10 00 	movl   $0x106402,(%esp)
  100d2d:	e8 24 f6 ff ff       	call   100356 <cprintf>
    
    cprintf("stack trackback:\n");
  100d32:	c7 04 24 04 64 10 00 	movl   $0x106404,(%esp)
  100d39:	e8 18 f6 ff ff       	call   100356 <cprintf>
    print_stackframe();
  100d3e:	e8 82 fc ff ff       	call   1009c5 <print_stackframe>
  100d43:	eb 01                	jmp    100d46 <__panic+0x6b>
        goto panic_dead;
  100d45:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
  100d46:	e8 e9 09 00 00       	call   101734 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100d4b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d52:	e8 9d fe ff ff       	call   100bf4 <kmonitor>
  100d57:	eb f2                	jmp    100d4b <__panic+0x70>

00100d59 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100d59:	55                   	push   %ebp
  100d5a:	89 e5                	mov    %esp,%ebp
  100d5c:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100d5f:	8d 45 14             	lea    0x14(%ebp),%eax
  100d62:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100d65:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d68:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  100d6f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d73:	c7 04 24 16 64 10 00 	movl   $0x106416,(%esp)
  100d7a:	e8 d7 f5 ff ff       	call   100356 <cprintf>
    vcprintf(fmt, ap);
  100d7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d82:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d86:	8b 45 10             	mov    0x10(%ebp),%eax
  100d89:	89 04 24             	mov    %eax,(%esp)
  100d8c:	e8 90 f5 ff ff       	call   100321 <vcprintf>
    cprintf("\n");
  100d91:	c7 04 24 02 64 10 00 	movl   $0x106402,(%esp)
  100d98:	e8 b9 f5 ff ff       	call   100356 <cprintf>
    va_end(ap);
}
  100d9d:	90                   	nop
  100d9e:	89 ec                	mov    %ebp,%esp
  100da0:	5d                   	pop    %ebp
  100da1:	c3                   	ret    

00100da2 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100da2:	55                   	push   %ebp
  100da3:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100da5:	a1 20 c4 11 00       	mov    0x11c420,%eax
}
  100daa:	5d                   	pop    %ebp
  100dab:	c3                   	ret    

00100dac <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100dac:	55                   	push   %ebp
  100dad:	89 e5                	mov    %esp,%ebp
  100daf:	83 ec 28             	sub    $0x28,%esp
  100db2:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
  100db8:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100dbc:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100dc0:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100dc4:	ee                   	out    %al,(%dx)
}
  100dc5:	90                   	nop
  100dc6:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100dcc:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100dd0:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100dd4:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100dd8:	ee                   	out    %al,(%dx)
}
  100dd9:	90                   	nop
  100dda:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
  100de0:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100de4:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100de8:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100dec:	ee                   	out    %al,(%dx)
}
  100ded:	90                   	nop
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100dee:	c7 05 24 c4 11 00 00 	movl   $0x0,0x11c424
  100df5:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100df8:	c7 04 24 34 64 10 00 	movl   $0x106434,(%esp)
  100dff:	e8 52 f5 ff ff       	call   100356 <cprintf>
    pic_enable(IRQ_TIMER);
  100e04:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100e0b:	e8 89 09 00 00       	call   101799 <pic_enable>
}
  100e10:	90                   	nop
  100e11:	89 ec                	mov    %ebp,%esp
  100e13:	5d                   	pop    %ebp
  100e14:	c3                   	ret    

00100e15 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  100e15:	55                   	push   %ebp
  100e16:	89 e5                	mov    %esp,%ebp
  100e18:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  100e1b:	9c                   	pushf  
  100e1c:	58                   	pop    %eax
  100e1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  100e20:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  100e23:	25 00 02 00 00       	and    $0x200,%eax
  100e28:	85 c0                	test   %eax,%eax
  100e2a:	74 0c                	je     100e38 <__intr_save+0x23>
        intr_disable();
  100e2c:	e8 03 09 00 00       	call   101734 <intr_disable>
        return 1;
  100e31:	b8 01 00 00 00       	mov    $0x1,%eax
  100e36:	eb 05                	jmp    100e3d <__intr_save+0x28>
    }
    return 0;
  100e38:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100e3d:	89 ec                	mov    %ebp,%esp
  100e3f:	5d                   	pop    %ebp
  100e40:	c3                   	ret    

00100e41 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  100e41:	55                   	push   %ebp
  100e42:	89 e5                	mov    %esp,%ebp
  100e44:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  100e47:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100e4b:	74 05                	je     100e52 <__intr_restore+0x11>
        intr_enable();
  100e4d:	e8 da 08 00 00       	call   10172c <intr_enable>
    }
}
  100e52:	90                   	nop
  100e53:	89 ec                	mov    %ebp,%esp
  100e55:	5d                   	pop    %ebp
  100e56:	c3                   	ret    

00100e57 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100e57:	55                   	push   %ebp
  100e58:	89 e5                	mov    %esp,%ebp
  100e5a:	83 ec 10             	sub    $0x10,%esp
  100e5d:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100e63:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e67:	89 c2                	mov    %eax,%edx
  100e69:	ec                   	in     (%dx),%al
  100e6a:	88 45 f1             	mov    %al,-0xf(%ebp)
  100e6d:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100e73:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e77:	89 c2                	mov    %eax,%edx
  100e79:	ec                   	in     (%dx),%al
  100e7a:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e7d:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e83:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e87:	89 c2                	mov    %eax,%edx
  100e89:	ec                   	in     (%dx),%al
  100e8a:	88 45 f9             	mov    %al,-0x7(%ebp)
  100e8d:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
  100e93:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100e97:	89 c2                	mov    %eax,%edx
  100e99:	ec                   	in     (%dx),%al
  100e9a:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e9d:	90                   	nop
  100e9e:	89 ec                	mov    %ebp,%esp
  100ea0:	5d                   	pop    %ebp
  100ea1:	c3                   	ret    

00100ea2 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100ea2:	55                   	push   %ebp
  100ea3:	89 e5                	mov    %esp,%ebp
  100ea5:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
  100ea8:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
  100eaf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100eb2:	0f b7 00             	movzwl (%eax),%eax
  100eb5:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100eb9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ebc:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100ec1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ec4:	0f b7 00             	movzwl (%eax),%eax
  100ec7:	0f b7 c0             	movzwl %ax,%eax
  100eca:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
  100ecf:	74 12                	je     100ee3 <cga_init+0x41>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
  100ed1:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100ed8:	66 c7 05 46 c4 11 00 	movw   $0x3b4,0x11c446
  100edf:	b4 03 
  100ee1:	eb 13                	jmp    100ef6 <cga_init+0x54>
    } else {
        *cp = was;
  100ee3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ee6:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100eea:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100eed:	66 c7 05 46 c4 11 00 	movw   $0x3d4,0x11c446
  100ef4:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100ef6:	0f b7 05 46 c4 11 00 	movzwl 0x11c446,%eax
  100efd:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  100f01:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f05:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f09:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100f0d:	ee                   	out    %al,(%dx)
}
  100f0e:	90                   	nop
    pos = inb(addr_6845 + 1) << 8;
  100f0f:	0f b7 05 46 c4 11 00 	movzwl 0x11c446,%eax
  100f16:	40                   	inc    %eax
  100f17:	0f b7 c0             	movzwl %ax,%eax
  100f1a:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f1e:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
  100f22:	89 c2                	mov    %eax,%edx
  100f24:	ec                   	in     (%dx),%al
  100f25:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
  100f28:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f2c:	0f b6 c0             	movzbl %al,%eax
  100f2f:	c1 e0 08             	shl    $0x8,%eax
  100f32:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100f35:	0f b7 05 46 c4 11 00 	movzwl 0x11c446,%eax
  100f3c:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  100f40:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f44:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f48:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f4c:	ee                   	out    %al,(%dx)
}
  100f4d:	90                   	nop
    pos |= inb(addr_6845 + 1);
  100f4e:	0f b7 05 46 c4 11 00 	movzwl 0x11c446,%eax
  100f55:	40                   	inc    %eax
  100f56:	0f b7 c0             	movzwl %ax,%eax
  100f59:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f5d:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100f61:	89 c2                	mov    %eax,%edx
  100f63:	ec                   	in     (%dx),%al
  100f64:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
  100f67:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f6b:	0f b6 c0             	movzbl %al,%eax
  100f6e:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100f71:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f74:	a3 40 c4 11 00       	mov    %eax,0x11c440
    crt_pos = pos;
  100f79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f7c:	0f b7 c0             	movzwl %ax,%eax
  100f7f:	66 a3 44 c4 11 00    	mov    %ax,0x11c444
}
  100f85:	90                   	nop
  100f86:	89 ec                	mov    %ebp,%esp
  100f88:	5d                   	pop    %ebp
  100f89:	c3                   	ret    

00100f8a <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f8a:	55                   	push   %ebp
  100f8b:	89 e5                	mov    %esp,%ebp
  100f8d:	83 ec 48             	sub    $0x48,%esp
  100f90:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
  100f96:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f9a:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  100f9e:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  100fa2:	ee                   	out    %al,(%dx)
}
  100fa3:	90                   	nop
  100fa4:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
  100faa:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100fae:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  100fb2:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  100fb6:	ee                   	out    %al,(%dx)
}
  100fb7:	90                   	nop
  100fb8:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
  100fbe:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100fc2:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  100fc6:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  100fca:	ee                   	out    %al,(%dx)
}
  100fcb:	90                   	nop
  100fcc:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100fd2:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100fd6:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100fda:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100fde:	ee                   	out    %al,(%dx)
}
  100fdf:	90                   	nop
  100fe0:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
  100fe6:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100fea:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100fee:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100ff2:	ee                   	out    %al,(%dx)
}
  100ff3:	90                   	nop
  100ff4:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
  100ffa:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100ffe:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101002:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101006:	ee                   	out    %al,(%dx)
}
  101007:	90                   	nop
  101008:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  10100e:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101012:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101016:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10101a:	ee                   	out    %al,(%dx)
}
  10101b:	90                   	nop
  10101c:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101022:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  101026:	89 c2                	mov    %eax,%edx
  101028:	ec                   	in     (%dx),%al
  101029:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  10102c:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  101030:	3c ff                	cmp    $0xff,%al
  101032:	0f 95 c0             	setne  %al
  101035:	0f b6 c0             	movzbl %al,%eax
  101038:	a3 48 c4 11 00       	mov    %eax,0x11c448
  10103d:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101043:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  101047:	89 c2                	mov    %eax,%edx
  101049:	ec                   	in     (%dx),%al
  10104a:	88 45 f1             	mov    %al,-0xf(%ebp)
  10104d:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101053:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  101057:	89 c2                	mov    %eax,%edx
  101059:	ec                   	in     (%dx),%al
  10105a:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  10105d:	a1 48 c4 11 00       	mov    0x11c448,%eax
  101062:	85 c0                	test   %eax,%eax
  101064:	74 0c                	je     101072 <serial_init+0xe8>
        pic_enable(IRQ_COM1);
  101066:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  10106d:	e8 27 07 00 00       	call   101799 <pic_enable>
    }
}
  101072:	90                   	nop
  101073:	89 ec                	mov    %ebp,%esp
  101075:	5d                   	pop    %ebp
  101076:	c3                   	ret    

00101077 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  101077:	55                   	push   %ebp
  101078:	89 e5                	mov    %esp,%ebp
  10107a:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  10107d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101084:	eb 08                	jmp    10108e <lpt_putc_sub+0x17>
        delay();
  101086:	e8 cc fd ff ff       	call   100e57 <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  10108b:	ff 45 fc             	incl   -0x4(%ebp)
  10108e:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  101094:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101098:	89 c2                	mov    %eax,%edx
  10109a:	ec                   	in     (%dx),%al
  10109b:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10109e:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1010a2:	84 c0                	test   %al,%al
  1010a4:	78 09                	js     1010af <lpt_putc_sub+0x38>
  1010a6:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1010ad:	7e d7                	jle    101086 <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
  1010af:	8b 45 08             	mov    0x8(%ebp),%eax
  1010b2:	0f b6 c0             	movzbl %al,%eax
  1010b5:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
  1010bb:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1010be:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1010c2:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1010c6:	ee                   	out    %al,(%dx)
}
  1010c7:	90                   	nop
  1010c8:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  1010ce:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1010d2:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1010d6:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1010da:	ee                   	out    %al,(%dx)
}
  1010db:	90                   	nop
  1010dc:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  1010e2:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1010e6:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1010ea:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1010ee:	ee                   	out    %al,(%dx)
}
  1010ef:	90                   	nop
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  1010f0:	90                   	nop
  1010f1:	89 ec                	mov    %ebp,%esp
  1010f3:	5d                   	pop    %ebp
  1010f4:	c3                   	ret    

001010f5 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  1010f5:	55                   	push   %ebp
  1010f6:	89 e5                	mov    %esp,%ebp
  1010f8:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1010fb:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1010ff:	74 0d                	je     10110e <lpt_putc+0x19>
        lpt_putc_sub(c);
  101101:	8b 45 08             	mov    0x8(%ebp),%eax
  101104:	89 04 24             	mov    %eax,(%esp)
  101107:	e8 6b ff ff ff       	call   101077 <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  10110c:	eb 24                	jmp    101132 <lpt_putc+0x3d>
        lpt_putc_sub('\b');
  10110e:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101115:	e8 5d ff ff ff       	call   101077 <lpt_putc_sub>
        lpt_putc_sub(' ');
  10111a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101121:	e8 51 ff ff ff       	call   101077 <lpt_putc_sub>
        lpt_putc_sub('\b');
  101126:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10112d:	e8 45 ff ff ff       	call   101077 <lpt_putc_sub>
}
  101132:	90                   	nop
  101133:	89 ec                	mov    %ebp,%esp
  101135:	5d                   	pop    %ebp
  101136:	c3                   	ret    

00101137 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  101137:	55                   	push   %ebp
  101138:	89 e5                	mov    %esp,%ebp
  10113a:	83 ec 38             	sub    $0x38,%esp
  10113d:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    // set black on white
    if (!(c & ~0xFF)) {
  101140:	8b 45 08             	mov    0x8(%ebp),%eax
  101143:	25 00 ff ff ff       	and    $0xffffff00,%eax
  101148:	85 c0                	test   %eax,%eax
  10114a:	75 07                	jne    101153 <cga_putc+0x1c>
        c |= 0x0700;
  10114c:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  101153:	8b 45 08             	mov    0x8(%ebp),%eax
  101156:	0f b6 c0             	movzbl %al,%eax
  101159:	83 f8 0d             	cmp    $0xd,%eax
  10115c:	74 72                	je     1011d0 <cga_putc+0x99>
  10115e:	83 f8 0d             	cmp    $0xd,%eax
  101161:	0f 8f a3 00 00 00    	jg     10120a <cga_putc+0xd3>
  101167:	83 f8 08             	cmp    $0x8,%eax
  10116a:	74 0a                	je     101176 <cga_putc+0x3f>
  10116c:	83 f8 0a             	cmp    $0xa,%eax
  10116f:	74 4c                	je     1011bd <cga_putc+0x86>
  101171:	e9 94 00 00 00       	jmp    10120a <cga_putc+0xd3>
    case '\b':
        if (crt_pos > 0) {
  101176:	0f b7 05 44 c4 11 00 	movzwl 0x11c444,%eax
  10117d:	85 c0                	test   %eax,%eax
  10117f:	0f 84 af 00 00 00    	je     101234 <cga_putc+0xfd>
            crt_pos --;
  101185:	0f b7 05 44 c4 11 00 	movzwl 0x11c444,%eax
  10118c:	48                   	dec    %eax
  10118d:	0f b7 c0             	movzwl %ax,%eax
  101190:	66 a3 44 c4 11 00    	mov    %ax,0x11c444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  101196:	8b 45 08             	mov    0x8(%ebp),%eax
  101199:	98                   	cwtl   
  10119a:	25 00 ff ff ff       	and    $0xffffff00,%eax
  10119f:	98                   	cwtl   
  1011a0:	83 c8 20             	or     $0x20,%eax
  1011a3:	98                   	cwtl   
  1011a4:	8b 0d 40 c4 11 00    	mov    0x11c440,%ecx
  1011aa:	0f b7 15 44 c4 11 00 	movzwl 0x11c444,%edx
  1011b1:	01 d2                	add    %edx,%edx
  1011b3:	01 ca                	add    %ecx,%edx
  1011b5:	0f b7 c0             	movzwl %ax,%eax
  1011b8:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  1011bb:	eb 77                	jmp    101234 <cga_putc+0xfd>
    case '\n':
        crt_pos += CRT_COLS;
  1011bd:	0f b7 05 44 c4 11 00 	movzwl 0x11c444,%eax
  1011c4:	83 c0 50             	add    $0x50,%eax
  1011c7:	0f b7 c0             	movzwl %ax,%eax
  1011ca:	66 a3 44 c4 11 00    	mov    %ax,0x11c444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  1011d0:	0f b7 1d 44 c4 11 00 	movzwl 0x11c444,%ebx
  1011d7:	0f b7 0d 44 c4 11 00 	movzwl 0x11c444,%ecx
  1011de:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
  1011e3:	89 c8                	mov    %ecx,%eax
  1011e5:	f7 e2                	mul    %edx
  1011e7:	c1 ea 06             	shr    $0x6,%edx
  1011ea:	89 d0                	mov    %edx,%eax
  1011ec:	c1 e0 02             	shl    $0x2,%eax
  1011ef:	01 d0                	add    %edx,%eax
  1011f1:	c1 e0 04             	shl    $0x4,%eax
  1011f4:	29 c1                	sub    %eax,%ecx
  1011f6:	89 ca                	mov    %ecx,%edx
  1011f8:	0f b7 d2             	movzwl %dx,%edx
  1011fb:	89 d8                	mov    %ebx,%eax
  1011fd:	29 d0                	sub    %edx,%eax
  1011ff:	0f b7 c0             	movzwl %ax,%eax
  101202:	66 a3 44 c4 11 00    	mov    %ax,0x11c444
        break;
  101208:	eb 2b                	jmp    101235 <cga_putc+0xfe>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  10120a:	8b 0d 40 c4 11 00    	mov    0x11c440,%ecx
  101210:	0f b7 05 44 c4 11 00 	movzwl 0x11c444,%eax
  101217:	8d 50 01             	lea    0x1(%eax),%edx
  10121a:	0f b7 d2             	movzwl %dx,%edx
  10121d:	66 89 15 44 c4 11 00 	mov    %dx,0x11c444
  101224:	01 c0                	add    %eax,%eax
  101226:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  101229:	8b 45 08             	mov    0x8(%ebp),%eax
  10122c:	0f b7 c0             	movzwl %ax,%eax
  10122f:	66 89 02             	mov    %ax,(%edx)
        break;
  101232:	eb 01                	jmp    101235 <cga_putc+0xfe>
        break;
  101234:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  101235:	0f b7 05 44 c4 11 00 	movzwl 0x11c444,%eax
  10123c:	3d cf 07 00 00       	cmp    $0x7cf,%eax
  101241:	76 5e                	jbe    1012a1 <cga_putc+0x16a>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  101243:	a1 40 c4 11 00       	mov    0x11c440,%eax
  101248:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  10124e:	a1 40 c4 11 00       	mov    0x11c440,%eax
  101253:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  10125a:	00 
  10125b:	89 54 24 04          	mov    %edx,0x4(%esp)
  10125f:	89 04 24             	mov    %eax,(%esp)
  101262:	e8 68 4d 00 00       	call   105fcf <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101267:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  10126e:	eb 15                	jmp    101285 <cga_putc+0x14e>
            crt_buf[i] = 0x0700 | ' ';
  101270:	8b 15 40 c4 11 00    	mov    0x11c440,%edx
  101276:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101279:	01 c0                	add    %eax,%eax
  10127b:	01 d0                	add    %edx,%eax
  10127d:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101282:	ff 45 f4             	incl   -0xc(%ebp)
  101285:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  10128c:	7e e2                	jle    101270 <cga_putc+0x139>
        }
        crt_pos -= CRT_COLS;
  10128e:	0f b7 05 44 c4 11 00 	movzwl 0x11c444,%eax
  101295:	83 e8 50             	sub    $0x50,%eax
  101298:	0f b7 c0             	movzwl %ax,%eax
  10129b:	66 a3 44 c4 11 00    	mov    %ax,0x11c444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1012a1:	0f b7 05 46 c4 11 00 	movzwl 0x11c446,%eax
  1012a8:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  1012ac:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1012b0:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1012b4:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1012b8:	ee                   	out    %al,(%dx)
}
  1012b9:	90                   	nop
    outb(addr_6845 + 1, crt_pos >> 8);
  1012ba:	0f b7 05 44 c4 11 00 	movzwl 0x11c444,%eax
  1012c1:	c1 e8 08             	shr    $0x8,%eax
  1012c4:	0f b7 c0             	movzwl %ax,%eax
  1012c7:	0f b6 c0             	movzbl %al,%eax
  1012ca:	0f b7 15 46 c4 11 00 	movzwl 0x11c446,%edx
  1012d1:	42                   	inc    %edx
  1012d2:	0f b7 d2             	movzwl %dx,%edx
  1012d5:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  1012d9:	88 45 e9             	mov    %al,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1012dc:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1012e0:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1012e4:	ee                   	out    %al,(%dx)
}
  1012e5:	90                   	nop
    outb(addr_6845, 15);
  1012e6:	0f b7 05 46 c4 11 00 	movzwl 0x11c446,%eax
  1012ed:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  1012f1:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1012f5:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1012f9:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1012fd:	ee                   	out    %al,(%dx)
}
  1012fe:	90                   	nop
    outb(addr_6845 + 1, crt_pos);
  1012ff:	0f b7 05 44 c4 11 00 	movzwl 0x11c444,%eax
  101306:	0f b6 c0             	movzbl %al,%eax
  101309:	0f b7 15 46 c4 11 00 	movzwl 0x11c446,%edx
  101310:	42                   	inc    %edx
  101311:	0f b7 d2             	movzwl %dx,%edx
  101314:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  101318:	88 45 f1             	mov    %al,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10131b:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10131f:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101323:	ee                   	out    %al,(%dx)
}
  101324:	90                   	nop
}
  101325:	90                   	nop
  101326:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  101329:	89 ec                	mov    %ebp,%esp
  10132b:	5d                   	pop    %ebp
  10132c:	c3                   	ret    

0010132d <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  10132d:	55                   	push   %ebp
  10132e:	89 e5                	mov    %esp,%ebp
  101330:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101333:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10133a:	eb 08                	jmp    101344 <serial_putc_sub+0x17>
        delay();
  10133c:	e8 16 fb ff ff       	call   100e57 <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101341:	ff 45 fc             	incl   -0x4(%ebp)
  101344:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10134a:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10134e:	89 c2                	mov    %eax,%edx
  101350:	ec                   	in     (%dx),%al
  101351:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101354:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101358:	0f b6 c0             	movzbl %al,%eax
  10135b:	83 e0 20             	and    $0x20,%eax
  10135e:	85 c0                	test   %eax,%eax
  101360:	75 09                	jne    10136b <serial_putc_sub+0x3e>
  101362:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101369:	7e d1                	jle    10133c <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
  10136b:	8b 45 08             	mov    0x8(%ebp),%eax
  10136e:	0f b6 c0             	movzbl %al,%eax
  101371:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101377:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10137a:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10137e:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101382:	ee                   	out    %al,(%dx)
}
  101383:	90                   	nop
}
  101384:	90                   	nop
  101385:	89 ec                	mov    %ebp,%esp
  101387:	5d                   	pop    %ebp
  101388:	c3                   	ret    

00101389 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  101389:	55                   	push   %ebp
  10138a:	89 e5                	mov    %esp,%ebp
  10138c:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  10138f:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101393:	74 0d                	je     1013a2 <serial_putc+0x19>
        serial_putc_sub(c);
  101395:	8b 45 08             	mov    0x8(%ebp),%eax
  101398:	89 04 24             	mov    %eax,(%esp)
  10139b:	e8 8d ff ff ff       	call   10132d <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  1013a0:	eb 24                	jmp    1013c6 <serial_putc+0x3d>
        serial_putc_sub('\b');
  1013a2:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1013a9:	e8 7f ff ff ff       	call   10132d <serial_putc_sub>
        serial_putc_sub(' ');
  1013ae:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1013b5:	e8 73 ff ff ff       	call   10132d <serial_putc_sub>
        serial_putc_sub('\b');
  1013ba:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1013c1:	e8 67 ff ff ff       	call   10132d <serial_putc_sub>
}
  1013c6:	90                   	nop
  1013c7:	89 ec                	mov    %ebp,%esp
  1013c9:	5d                   	pop    %ebp
  1013ca:	c3                   	ret    

001013cb <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  1013cb:	55                   	push   %ebp
  1013cc:	89 e5                	mov    %esp,%ebp
  1013ce:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  1013d1:	eb 33                	jmp    101406 <cons_intr+0x3b>
        if (c != 0) {
  1013d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1013d7:	74 2d                	je     101406 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  1013d9:	a1 64 c6 11 00       	mov    0x11c664,%eax
  1013de:	8d 50 01             	lea    0x1(%eax),%edx
  1013e1:	89 15 64 c6 11 00    	mov    %edx,0x11c664
  1013e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1013ea:	88 90 60 c4 11 00    	mov    %dl,0x11c460(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  1013f0:	a1 64 c6 11 00       	mov    0x11c664,%eax
  1013f5:	3d 00 02 00 00       	cmp    $0x200,%eax
  1013fa:	75 0a                	jne    101406 <cons_intr+0x3b>
                cons.wpos = 0;
  1013fc:	c7 05 64 c6 11 00 00 	movl   $0x0,0x11c664
  101403:	00 00 00 
    while ((c = (*proc)()) != -1) {
  101406:	8b 45 08             	mov    0x8(%ebp),%eax
  101409:	ff d0                	call   *%eax
  10140b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10140e:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  101412:	75 bf                	jne    1013d3 <cons_intr+0x8>
            }
        }
    }
}
  101414:	90                   	nop
  101415:	90                   	nop
  101416:	89 ec                	mov    %ebp,%esp
  101418:	5d                   	pop    %ebp
  101419:	c3                   	ret    

0010141a <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  10141a:	55                   	push   %ebp
  10141b:	89 e5                	mov    %esp,%ebp
  10141d:	83 ec 10             	sub    $0x10,%esp
  101420:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101426:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10142a:	89 c2                	mov    %eax,%edx
  10142c:	ec                   	in     (%dx),%al
  10142d:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101430:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  101434:	0f b6 c0             	movzbl %al,%eax
  101437:	83 e0 01             	and    $0x1,%eax
  10143a:	85 c0                	test   %eax,%eax
  10143c:	75 07                	jne    101445 <serial_proc_data+0x2b>
        return -1;
  10143e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101443:	eb 2a                	jmp    10146f <serial_proc_data+0x55>
  101445:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10144b:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10144f:	89 c2                	mov    %eax,%edx
  101451:	ec                   	in     (%dx),%al
  101452:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  101455:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  101459:	0f b6 c0             	movzbl %al,%eax
  10145c:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  10145f:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  101463:	75 07                	jne    10146c <serial_proc_data+0x52>
        c = '\b';
  101465:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  10146c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10146f:	89 ec                	mov    %ebp,%esp
  101471:	5d                   	pop    %ebp
  101472:	c3                   	ret    

00101473 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  101473:	55                   	push   %ebp
  101474:	89 e5                	mov    %esp,%ebp
  101476:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  101479:	a1 48 c4 11 00       	mov    0x11c448,%eax
  10147e:	85 c0                	test   %eax,%eax
  101480:	74 0c                	je     10148e <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  101482:	c7 04 24 1a 14 10 00 	movl   $0x10141a,(%esp)
  101489:	e8 3d ff ff ff       	call   1013cb <cons_intr>
    }
}
  10148e:	90                   	nop
  10148f:	89 ec                	mov    %ebp,%esp
  101491:	5d                   	pop    %ebp
  101492:	c3                   	ret    

00101493 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  101493:	55                   	push   %ebp
  101494:	89 e5                	mov    %esp,%ebp
  101496:	83 ec 38             	sub    $0x38,%esp
  101499:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10149f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1014a2:	89 c2                	mov    %eax,%edx
  1014a4:	ec                   	in     (%dx),%al
  1014a5:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  1014a8:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  1014ac:	0f b6 c0             	movzbl %al,%eax
  1014af:	83 e0 01             	and    $0x1,%eax
  1014b2:	85 c0                	test   %eax,%eax
  1014b4:	75 0a                	jne    1014c0 <kbd_proc_data+0x2d>
        return -1;
  1014b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1014bb:	e9 56 01 00 00       	jmp    101616 <kbd_proc_data+0x183>
  1014c0:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1014c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1014c9:	89 c2                	mov    %eax,%edx
  1014cb:	ec                   	in     (%dx),%al
  1014cc:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  1014cf:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  1014d3:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  1014d6:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  1014da:	75 17                	jne    1014f3 <kbd_proc_data+0x60>
        // E0 escape character
        shift |= E0ESC;
  1014dc:	a1 68 c6 11 00       	mov    0x11c668,%eax
  1014e1:	83 c8 40             	or     $0x40,%eax
  1014e4:	a3 68 c6 11 00       	mov    %eax,0x11c668
        return 0;
  1014e9:	b8 00 00 00 00       	mov    $0x0,%eax
  1014ee:	e9 23 01 00 00       	jmp    101616 <kbd_proc_data+0x183>
    } else if (data & 0x80) {
  1014f3:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014f7:	84 c0                	test   %al,%al
  1014f9:	79 45                	jns    101540 <kbd_proc_data+0xad>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  1014fb:	a1 68 c6 11 00       	mov    0x11c668,%eax
  101500:	83 e0 40             	and    $0x40,%eax
  101503:	85 c0                	test   %eax,%eax
  101505:	75 08                	jne    10150f <kbd_proc_data+0x7c>
  101507:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10150b:	24 7f                	and    $0x7f,%al
  10150d:	eb 04                	jmp    101513 <kbd_proc_data+0x80>
  10150f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101513:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  101516:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10151a:	0f b6 80 40 90 11 00 	movzbl 0x119040(%eax),%eax
  101521:	0c 40                	or     $0x40,%al
  101523:	0f b6 c0             	movzbl %al,%eax
  101526:	f7 d0                	not    %eax
  101528:	89 c2                	mov    %eax,%edx
  10152a:	a1 68 c6 11 00       	mov    0x11c668,%eax
  10152f:	21 d0                	and    %edx,%eax
  101531:	a3 68 c6 11 00       	mov    %eax,0x11c668
        return 0;
  101536:	b8 00 00 00 00       	mov    $0x0,%eax
  10153b:	e9 d6 00 00 00       	jmp    101616 <kbd_proc_data+0x183>
    } else if (shift & E0ESC) {
  101540:	a1 68 c6 11 00       	mov    0x11c668,%eax
  101545:	83 e0 40             	and    $0x40,%eax
  101548:	85 c0                	test   %eax,%eax
  10154a:	74 11                	je     10155d <kbd_proc_data+0xca>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  10154c:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  101550:	a1 68 c6 11 00       	mov    0x11c668,%eax
  101555:	83 e0 bf             	and    $0xffffffbf,%eax
  101558:	a3 68 c6 11 00       	mov    %eax,0x11c668
    }

    shift |= shiftcode[data];
  10155d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101561:	0f b6 80 40 90 11 00 	movzbl 0x119040(%eax),%eax
  101568:	0f b6 d0             	movzbl %al,%edx
  10156b:	a1 68 c6 11 00       	mov    0x11c668,%eax
  101570:	09 d0                	or     %edx,%eax
  101572:	a3 68 c6 11 00       	mov    %eax,0x11c668
    shift ^= togglecode[data];
  101577:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10157b:	0f b6 80 40 91 11 00 	movzbl 0x119140(%eax),%eax
  101582:	0f b6 d0             	movzbl %al,%edx
  101585:	a1 68 c6 11 00       	mov    0x11c668,%eax
  10158a:	31 d0                	xor    %edx,%eax
  10158c:	a3 68 c6 11 00       	mov    %eax,0x11c668

    c = charcode[shift & (CTL | SHIFT)][data];
  101591:	a1 68 c6 11 00       	mov    0x11c668,%eax
  101596:	83 e0 03             	and    $0x3,%eax
  101599:	8b 14 85 40 95 11 00 	mov    0x119540(,%eax,4),%edx
  1015a0:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1015a4:	01 d0                	add    %edx,%eax
  1015a6:	0f b6 00             	movzbl (%eax),%eax
  1015a9:	0f b6 c0             	movzbl %al,%eax
  1015ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  1015af:	a1 68 c6 11 00       	mov    0x11c668,%eax
  1015b4:	83 e0 08             	and    $0x8,%eax
  1015b7:	85 c0                	test   %eax,%eax
  1015b9:	74 22                	je     1015dd <kbd_proc_data+0x14a>
        if ('a' <= c && c <= 'z')
  1015bb:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  1015bf:	7e 0c                	jle    1015cd <kbd_proc_data+0x13a>
  1015c1:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  1015c5:	7f 06                	jg     1015cd <kbd_proc_data+0x13a>
            c += 'A' - 'a';
  1015c7:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  1015cb:	eb 10                	jmp    1015dd <kbd_proc_data+0x14a>
        else if ('A' <= c && c <= 'Z')
  1015cd:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  1015d1:	7e 0a                	jle    1015dd <kbd_proc_data+0x14a>
  1015d3:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  1015d7:	7f 04                	jg     1015dd <kbd_proc_data+0x14a>
            c += 'a' - 'A';
  1015d9:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  1015dd:	a1 68 c6 11 00       	mov    0x11c668,%eax
  1015e2:	f7 d0                	not    %eax
  1015e4:	83 e0 06             	and    $0x6,%eax
  1015e7:	85 c0                	test   %eax,%eax
  1015e9:	75 28                	jne    101613 <kbd_proc_data+0x180>
  1015eb:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  1015f2:	75 1f                	jne    101613 <kbd_proc_data+0x180>
        cprintf("Rebooting!\n");
  1015f4:	c7 04 24 4f 64 10 00 	movl   $0x10644f,(%esp)
  1015fb:	e8 56 ed ff ff       	call   100356 <cprintf>
  101600:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  101606:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10160a:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  10160e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  101611:	ee                   	out    %al,(%dx)
}
  101612:	90                   	nop
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  101613:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101616:	89 ec                	mov    %ebp,%esp
  101618:	5d                   	pop    %ebp
  101619:	c3                   	ret    

0010161a <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  10161a:	55                   	push   %ebp
  10161b:	89 e5                	mov    %esp,%ebp
  10161d:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  101620:	c7 04 24 93 14 10 00 	movl   $0x101493,(%esp)
  101627:	e8 9f fd ff ff       	call   1013cb <cons_intr>
}
  10162c:	90                   	nop
  10162d:	89 ec                	mov    %ebp,%esp
  10162f:	5d                   	pop    %ebp
  101630:	c3                   	ret    

00101631 <kbd_init>:

static void
kbd_init(void) {
  101631:	55                   	push   %ebp
  101632:	89 e5                	mov    %esp,%ebp
  101634:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  101637:	e8 de ff ff ff       	call   10161a <kbd_intr>
    pic_enable(IRQ_KBD);
  10163c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  101643:	e8 51 01 00 00       	call   101799 <pic_enable>
}
  101648:	90                   	nop
  101649:	89 ec                	mov    %ebp,%esp
  10164b:	5d                   	pop    %ebp
  10164c:	c3                   	ret    

0010164d <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  10164d:	55                   	push   %ebp
  10164e:	89 e5                	mov    %esp,%ebp
  101650:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  101653:	e8 4a f8 ff ff       	call   100ea2 <cga_init>
    serial_init();
  101658:	e8 2d f9 ff ff       	call   100f8a <serial_init>
    kbd_init();
  10165d:	e8 cf ff ff ff       	call   101631 <kbd_init>
    if (!serial_exists) {
  101662:	a1 48 c4 11 00       	mov    0x11c448,%eax
  101667:	85 c0                	test   %eax,%eax
  101669:	75 0c                	jne    101677 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  10166b:	c7 04 24 5b 64 10 00 	movl   $0x10645b,(%esp)
  101672:	e8 df ec ff ff       	call   100356 <cprintf>
    }
}
  101677:	90                   	nop
  101678:	89 ec                	mov    %ebp,%esp
  10167a:	5d                   	pop    %ebp
  10167b:	c3                   	ret    

0010167c <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  10167c:	55                   	push   %ebp
  10167d:	89 e5                	mov    %esp,%ebp
  10167f:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  101682:	e8 8e f7 ff ff       	call   100e15 <__intr_save>
  101687:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
  10168a:	8b 45 08             	mov    0x8(%ebp),%eax
  10168d:	89 04 24             	mov    %eax,(%esp)
  101690:	e8 60 fa ff ff       	call   1010f5 <lpt_putc>
        cga_putc(c);
  101695:	8b 45 08             	mov    0x8(%ebp),%eax
  101698:	89 04 24             	mov    %eax,(%esp)
  10169b:	e8 97 fa ff ff       	call   101137 <cga_putc>
        serial_putc(c);
  1016a0:	8b 45 08             	mov    0x8(%ebp),%eax
  1016a3:	89 04 24             	mov    %eax,(%esp)
  1016a6:	e8 de fc ff ff       	call   101389 <serial_putc>
    }
    local_intr_restore(intr_flag);
  1016ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1016ae:	89 04 24             	mov    %eax,(%esp)
  1016b1:	e8 8b f7 ff ff       	call   100e41 <__intr_restore>
}
  1016b6:	90                   	nop
  1016b7:	89 ec                	mov    %ebp,%esp
  1016b9:	5d                   	pop    %ebp
  1016ba:	c3                   	ret    

001016bb <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  1016bb:	55                   	push   %ebp
  1016bc:	89 e5                	mov    %esp,%ebp
  1016be:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
  1016c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  1016c8:	e8 48 f7 ff ff       	call   100e15 <__intr_save>
  1016cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
  1016d0:	e8 9e fd ff ff       	call   101473 <serial_intr>
        kbd_intr();
  1016d5:	e8 40 ff ff ff       	call   10161a <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
  1016da:	8b 15 60 c6 11 00    	mov    0x11c660,%edx
  1016e0:	a1 64 c6 11 00       	mov    0x11c664,%eax
  1016e5:	39 c2                	cmp    %eax,%edx
  1016e7:	74 31                	je     10171a <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
  1016e9:	a1 60 c6 11 00       	mov    0x11c660,%eax
  1016ee:	8d 50 01             	lea    0x1(%eax),%edx
  1016f1:	89 15 60 c6 11 00    	mov    %edx,0x11c660
  1016f7:	0f b6 80 60 c4 11 00 	movzbl 0x11c460(%eax),%eax
  1016fe:	0f b6 c0             	movzbl %al,%eax
  101701:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
  101704:	a1 60 c6 11 00       	mov    0x11c660,%eax
  101709:	3d 00 02 00 00       	cmp    $0x200,%eax
  10170e:	75 0a                	jne    10171a <cons_getc+0x5f>
                cons.rpos = 0;
  101710:	c7 05 60 c6 11 00 00 	movl   $0x0,0x11c660
  101717:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
  10171a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10171d:	89 04 24             	mov    %eax,(%esp)
  101720:	e8 1c f7 ff ff       	call   100e41 <__intr_restore>
    return c;
  101725:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101728:	89 ec                	mov    %ebp,%esp
  10172a:	5d                   	pop    %ebp
  10172b:	c3                   	ret    

0010172c <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  10172c:	55                   	push   %ebp
  10172d:	89 e5                	mov    %esp,%ebp
    asm volatile ("sti");
  10172f:	fb                   	sti    
}
  101730:	90                   	nop
    sti();
}
  101731:	90                   	nop
  101732:	5d                   	pop    %ebp
  101733:	c3                   	ret    

00101734 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  101734:	55                   	push   %ebp
  101735:	89 e5                	mov    %esp,%ebp
    asm volatile ("cli" ::: "memory");
  101737:	fa                   	cli    
}
  101738:	90                   	nop
    cli();
}
  101739:	90                   	nop
  10173a:	5d                   	pop    %ebp
  10173b:	c3                   	ret    

0010173c <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  10173c:	55                   	push   %ebp
  10173d:	89 e5                	mov    %esp,%ebp
  10173f:	83 ec 14             	sub    $0x14,%esp
  101742:	8b 45 08             	mov    0x8(%ebp),%eax
  101745:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  101749:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10174c:	66 a3 50 95 11 00    	mov    %ax,0x119550
    if (did_init) {
  101752:	a1 6c c6 11 00       	mov    0x11c66c,%eax
  101757:	85 c0                	test   %eax,%eax
  101759:	74 39                	je     101794 <pic_setmask+0x58>
        outb(IO_PIC1 + 1, mask);
  10175b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10175e:	0f b6 c0             	movzbl %al,%eax
  101761:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
  101767:	88 45 f9             	mov    %al,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10176a:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10176e:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101772:	ee                   	out    %al,(%dx)
}
  101773:	90                   	nop
        outb(IO_PIC2 + 1, mask >> 8);
  101774:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101778:	c1 e8 08             	shr    $0x8,%eax
  10177b:	0f b7 c0             	movzwl %ax,%eax
  10177e:	0f b6 c0             	movzbl %al,%eax
  101781:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
  101787:	88 45 fd             	mov    %al,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10178a:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  10178e:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101792:	ee                   	out    %al,(%dx)
}
  101793:	90                   	nop
    }
}
  101794:	90                   	nop
  101795:	89 ec                	mov    %ebp,%esp
  101797:	5d                   	pop    %ebp
  101798:	c3                   	ret    

00101799 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101799:	55                   	push   %ebp
  10179a:	89 e5                	mov    %esp,%ebp
  10179c:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  10179f:	8b 45 08             	mov    0x8(%ebp),%eax
  1017a2:	ba 01 00 00 00       	mov    $0x1,%edx
  1017a7:	88 c1                	mov    %al,%cl
  1017a9:	d3 e2                	shl    %cl,%edx
  1017ab:	89 d0                	mov    %edx,%eax
  1017ad:	98                   	cwtl   
  1017ae:	f7 d0                	not    %eax
  1017b0:	0f bf d0             	movswl %ax,%edx
  1017b3:	0f b7 05 50 95 11 00 	movzwl 0x119550,%eax
  1017ba:	98                   	cwtl   
  1017bb:	21 d0                	and    %edx,%eax
  1017bd:	98                   	cwtl   
  1017be:	0f b7 c0             	movzwl %ax,%eax
  1017c1:	89 04 24             	mov    %eax,(%esp)
  1017c4:	e8 73 ff ff ff       	call   10173c <pic_setmask>
}
  1017c9:	90                   	nop
  1017ca:	89 ec                	mov    %ebp,%esp
  1017cc:	5d                   	pop    %ebp
  1017cd:	c3                   	ret    

001017ce <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  1017ce:	55                   	push   %ebp
  1017cf:	89 e5                	mov    %esp,%ebp
  1017d1:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  1017d4:	c7 05 6c c6 11 00 01 	movl   $0x1,0x11c66c
  1017db:	00 00 00 
  1017de:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
  1017e4:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1017e8:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  1017ec:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  1017f0:	ee                   	out    %al,(%dx)
}
  1017f1:	90                   	nop
  1017f2:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
  1017f8:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1017fc:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  101800:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  101804:	ee                   	out    %al,(%dx)
}
  101805:	90                   	nop
  101806:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  10180c:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101810:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  101814:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  101818:	ee                   	out    %al,(%dx)
}
  101819:	90                   	nop
  10181a:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
  101820:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101824:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  101828:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  10182c:	ee                   	out    %al,(%dx)
}
  10182d:	90                   	nop
  10182e:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
  101834:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101838:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  10183c:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101840:	ee                   	out    %al,(%dx)
}
  101841:	90                   	nop
  101842:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
  101848:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10184c:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101850:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101854:	ee                   	out    %al,(%dx)
}
  101855:	90                   	nop
  101856:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
  10185c:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101860:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101864:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  101868:	ee                   	out    %al,(%dx)
}
  101869:	90                   	nop
  10186a:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
  101870:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101874:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101878:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  10187c:	ee                   	out    %al,(%dx)
}
  10187d:	90                   	nop
  10187e:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
  101884:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101888:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10188c:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101890:	ee                   	out    %al,(%dx)
}
  101891:	90                   	nop
  101892:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  101898:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10189c:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1018a0:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1018a4:	ee                   	out    %al,(%dx)
}
  1018a5:	90                   	nop
  1018a6:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
  1018ac:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1018b0:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1018b4:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1018b8:	ee                   	out    %al,(%dx)
}
  1018b9:	90                   	nop
  1018ba:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  1018c0:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1018c4:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1018c8:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1018cc:	ee                   	out    %al,(%dx)
}
  1018cd:	90                   	nop
  1018ce:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
  1018d4:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1018d8:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1018dc:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1018e0:	ee                   	out    %al,(%dx)
}
  1018e1:	90                   	nop
  1018e2:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
  1018e8:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1018ec:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1018f0:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1018f4:	ee                   	out    %al,(%dx)
}
  1018f5:	90                   	nop
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  1018f6:	0f b7 05 50 95 11 00 	movzwl 0x119550,%eax
  1018fd:	3d ff ff 00 00       	cmp    $0xffff,%eax
  101902:	74 0f                	je     101913 <pic_init+0x145>
        pic_setmask(irq_mask);
  101904:	0f b7 05 50 95 11 00 	movzwl 0x119550,%eax
  10190b:	89 04 24             	mov    %eax,(%esp)
  10190e:	e8 29 fe ff ff       	call   10173c <pic_setmask>
    }
}
  101913:	90                   	nop
  101914:	89 ec                	mov    %ebp,%esp
  101916:	5d                   	pop    %ebp
  101917:	c3                   	ret    

00101918 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  101918:	55                   	push   %ebp
  101919:	89 e5                	mov    %esp,%ebp
  10191b:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  10191e:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  101925:	00 
  101926:	c7 04 24 80 64 10 00 	movl   $0x106480,(%esp)
  10192d:	e8 24 ea ff ff       	call   100356 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  101932:	c7 04 24 8a 64 10 00 	movl   $0x10648a,(%esp)
  101939:	e8 18 ea ff ff       	call   100356 <cprintf>
    panic("EOT: kernel seems ok.");
  10193e:	c7 44 24 08 98 64 10 	movl   $0x106498,0x8(%esp)
  101945:	00 
  101946:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  10194d:	00 
  10194e:	c7 04 24 ae 64 10 00 	movl   $0x1064ae,(%esp)
  101955:	e8 81 f3 ff ff       	call   100cdb <__panic>

0010195a <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  10195a:	55                   	push   %ebp
  10195b:	89 e5                	mov    %esp,%ebp
  10195d:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
     extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) 
  101960:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101967:	e9 c4 00 00 00       	jmp    101a30 <idt_init+0xd6>
    {
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  10196c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10196f:	8b 04 85 e0 95 11 00 	mov    0x1195e0(,%eax,4),%eax
  101976:	0f b7 d0             	movzwl %ax,%edx
  101979:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10197c:	66 89 14 c5 80 c6 11 	mov    %dx,0x11c680(,%eax,8)
  101983:	00 
  101984:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101987:	66 c7 04 c5 82 c6 11 	movw   $0x8,0x11c682(,%eax,8)
  10198e:	00 08 00 
  101991:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101994:	0f b6 14 c5 84 c6 11 	movzbl 0x11c684(,%eax,8),%edx
  10199b:	00 
  10199c:	80 e2 e0             	and    $0xe0,%dl
  10199f:	88 14 c5 84 c6 11 00 	mov    %dl,0x11c684(,%eax,8)
  1019a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019a9:	0f b6 14 c5 84 c6 11 	movzbl 0x11c684(,%eax,8),%edx
  1019b0:	00 
  1019b1:	80 e2 1f             	and    $0x1f,%dl
  1019b4:	88 14 c5 84 c6 11 00 	mov    %dl,0x11c684(,%eax,8)
  1019bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019be:	0f b6 14 c5 85 c6 11 	movzbl 0x11c685(,%eax,8),%edx
  1019c5:	00 
  1019c6:	80 e2 f0             	and    $0xf0,%dl
  1019c9:	80 ca 0e             	or     $0xe,%dl
  1019cc:	88 14 c5 85 c6 11 00 	mov    %dl,0x11c685(,%eax,8)
  1019d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019d6:	0f b6 14 c5 85 c6 11 	movzbl 0x11c685(,%eax,8),%edx
  1019dd:	00 
  1019de:	80 e2 ef             	and    $0xef,%dl
  1019e1:	88 14 c5 85 c6 11 00 	mov    %dl,0x11c685(,%eax,8)
  1019e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019eb:	0f b6 14 c5 85 c6 11 	movzbl 0x11c685(,%eax,8),%edx
  1019f2:	00 
  1019f3:	80 e2 9f             	and    $0x9f,%dl
  1019f6:	88 14 c5 85 c6 11 00 	mov    %dl,0x11c685(,%eax,8)
  1019fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a00:	0f b6 14 c5 85 c6 11 	movzbl 0x11c685(,%eax,8),%edx
  101a07:	00 
  101a08:	80 ca 80             	or     $0x80,%dl
  101a0b:	88 14 c5 85 c6 11 00 	mov    %dl,0x11c685(,%eax,8)
  101a12:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a15:	8b 04 85 e0 95 11 00 	mov    0x1195e0(,%eax,4),%eax
  101a1c:	c1 e8 10             	shr    $0x10,%eax
  101a1f:	0f b7 d0             	movzwl %ax,%edx
  101a22:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a25:	66 89 14 c5 86 c6 11 	mov    %dx,0x11c686(,%eax,8)
  101a2c:	00 
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) 
  101a2d:	ff 45 fc             	incl   -0x4(%ebp)
  101a30:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a33:	3d ff 00 00 00       	cmp    $0xff,%eax
  101a38:	0f 86 2e ff ff ff    	jbe    10196c <idt_init+0x12>
    }
    // set for switch from user to kernel
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
  101a3e:	a1 c4 97 11 00       	mov    0x1197c4,%eax
  101a43:	0f b7 c0             	movzwl %ax,%eax
  101a46:	66 a3 48 ca 11 00    	mov    %ax,0x11ca48
  101a4c:	66 c7 05 4a ca 11 00 	movw   $0x8,0x11ca4a
  101a53:	08 00 
  101a55:	0f b6 05 4c ca 11 00 	movzbl 0x11ca4c,%eax
  101a5c:	24 e0                	and    $0xe0,%al
  101a5e:	a2 4c ca 11 00       	mov    %al,0x11ca4c
  101a63:	0f b6 05 4c ca 11 00 	movzbl 0x11ca4c,%eax
  101a6a:	24 1f                	and    $0x1f,%al
  101a6c:	a2 4c ca 11 00       	mov    %al,0x11ca4c
  101a71:	0f b6 05 4d ca 11 00 	movzbl 0x11ca4d,%eax
  101a78:	24 f0                	and    $0xf0,%al
  101a7a:	0c 0e                	or     $0xe,%al
  101a7c:	a2 4d ca 11 00       	mov    %al,0x11ca4d
  101a81:	0f b6 05 4d ca 11 00 	movzbl 0x11ca4d,%eax
  101a88:	24 ef                	and    $0xef,%al
  101a8a:	a2 4d ca 11 00       	mov    %al,0x11ca4d
  101a8f:	0f b6 05 4d ca 11 00 	movzbl 0x11ca4d,%eax
  101a96:	0c 60                	or     $0x60,%al
  101a98:	a2 4d ca 11 00       	mov    %al,0x11ca4d
  101a9d:	0f b6 05 4d ca 11 00 	movzbl 0x11ca4d,%eax
  101aa4:	0c 80                	or     $0x80,%al
  101aa6:	a2 4d ca 11 00       	mov    %al,0x11ca4d
  101aab:	a1 c4 97 11 00       	mov    0x1197c4,%eax
  101ab0:	c1 e8 10             	shr    $0x10,%eax
  101ab3:	0f b7 c0             	movzwl %ax,%eax
  101ab6:	66 a3 4e ca 11 00    	mov    %ax,0x11ca4e
  101abc:	c7 45 f8 60 95 11 00 	movl   $0x119560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
  101ac3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101ac6:	0f 01 18             	lidtl  (%eax)
}
  101ac9:	90                   	nop
    // load the IDT
    lidt(&idt_pd);
}
  101aca:	90                   	nop
  101acb:	89 ec                	mov    %ebp,%esp
  101acd:	5d                   	pop    %ebp
  101ace:	c3                   	ret    

00101acf <trapname>:

static const char *
trapname(int trapno) {
  101acf:	55                   	push   %ebp
  101ad0:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  101ad5:	83 f8 13             	cmp    $0x13,%eax
  101ad8:	77 0c                	ja     101ae6 <trapname+0x17>
        return excnames[trapno];
  101ada:	8b 45 08             	mov    0x8(%ebp),%eax
  101add:	8b 04 85 00 68 10 00 	mov    0x106800(,%eax,4),%eax
  101ae4:	eb 18                	jmp    101afe <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101ae6:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101aea:	7e 0d                	jle    101af9 <trapname+0x2a>
  101aec:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101af0:	7f 07                	jg     101af9 <trapname+0x2a>
        return "Hardware Interrupt";
  101af2:	b8 bf 64 10 00       	mov    $0x1064bf,%eax
  101af7:	eb 05                	jmp    101afe <trapname+0x2f>
    }
    return "(unknown trap)";
  101af9:	b8 d2 64 10 00       	mov    $0x1064d2,%eax
}
  101afe:	5d                   	pop    %ebp
  101aff:	c3                   	ret    

00101b00 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101b00:	55                   	push   %ebp
  101b01:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101b03:	8b 45 08             	mov    0x8(%ebp),%eax
  101b06:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b0a:	83 f8 08             	cmp    $0x8,%eax
  101b0d:	0f 94 c0             	sete   %al
  101b10:	0f b6 c0             	movzbl %al,%eax
}
  101b13:	5d                   	pop    %ebp
  101b14:	c3                   	ret    

00101b15 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101b15:	55                   	push   %ebp
  101b16:	89 e5                	mov    %esp,%ebp
  101b18:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  101b1e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b22:	c7 04 24 13 65 10 00 	movl   $0x106513,(%esp)
  101b29:	e8 28 e8 ff ff       	call   100356 <cprintf>
    print_regs(&tf->tf_regs);
  101b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  101b31:	89 04 24             	mov    %eax,(%esp)
  101b34:	e8 8f 01 00 00       	call   101cc8 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101b39:	8b 45 08             	mov    0x8(%ebp),%eax
  101b3c:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101b40:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b44:	c7 04 24 24 65 10 00 	movl   $0x106524,(%esp)
  101b4b:	e8 06 e8 ff ff       	call   100356 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101b50:	8b 45 08             	mov    0x8(%ebp),%eax
  101b53:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101b57:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b5b:	c7 04 24 37 65 10 00 	movl   $0x106537,(%esp)
  101b62:	e8 ef e7 ff ff       	call   100356 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101b67:	8b 45 08             	mov    0x8(%ebp),%eax
  101b6a:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101b6e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b72:	c7 04 24 4a 65 10 00 	movl   $0x10654a,(%esp)
  101b79:	e8 d8 e7 ff ff       	call   100356 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  101b81:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101b85:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b89:	c7 04 24 5d 65 10 00 	movl   $0x10655d,(%esp)
  101b90:	e8 c1 e7 ff ff       	call   100356 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101b95:	8b 45 08             	mov    0x8(%ebp),%eax
  101b98:	8b 40 30             	mov    0x30(%eax),%eax
  101b9b:	89 04 24             	mov    %eax,(%esp)
  101b9e:	e8 2c ff ff ff       	call   101acf <trapname>
  101ba3:	8b 55 08             	mov    0x8(%ebp),%edx
  101ba6:	8b 52 30             	mov    0x30(%edx),%edx
  101ba9:	89 44 24 08          	mov    %eax,0x8(%esp)
  101bad:	89 54 24 04          	mov    %edx,0x4(%esp)
  101bb1:	c7 04 24 70 65 10 00 	movl   $0x106570,(%esp)
  101bb8:	e8 99 e7 ff ff       	call   100356 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101bbd:	8b 45 08             	mov    0x8(%ebp),%eax
  101bc0:	8b 40 34             	mov    0x34(%eax),%eax
  101bc3:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bc7:	c7 04 24 82 65 10 00 	movl   $0x106582,(%esp)
  101bce:	e8 83 e7 ff ff       	call   100356 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  101bd6:	8b 40 38             	mov    0x38(%eax),%eax
  101bd9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bdd:	c7 04 24 91 65 10 00 	movl   $0x106591,(%esp)
  101be4:	e8 6d e7 ff ff       	call   100356 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101be9:	8b 45 08             	mov    0x8(%ebp),%eax
  101bec:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101bf0:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bf4:	c7 04 24 a0 65 10 00 	movl   $0x1065a0,(%esp)
  101bfb:	e8 56 e7 ff ff       	call   100356 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101c00:	8b 45 08             	mov    0x8(%ebp),%eax
  101c03:	8b 40 40             	mov    0x40(%eax),%eax
  101c06:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c0a:	c7 04 24 b3 65 10 00 	movl   $0x1065b3,(%esp)
  101c11:	e8 40 e7 ff ff       	call   100356 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101c16:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101c1d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101c24:	eb 3d                	jmp    101c63 <print_trapframe+0x14e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101c26:	8b 45 08             	mov    0x8(%ebp),%eax
  101c29:	8b 50 40             	mov    0x40(%eax),%edx
  101c2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101c2f:	21 d0                	and    %edx,%eax
  101c31:	85 c0                	test   %eax,%eax
  101c33:	74 28                	je     101c5d <print_trapframe+0x148>
  101c35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c38:	8b 04 85 80 95 11 00 	mov    0x119580(,%eax,4),%eax
  101c3f:	85 c0                	test   %eax,%eax
  101c41:	74 1a                	je     101c5d <print_trapframe+0x148>
            cprintf("%s,", IA32flags[i]);
  101c43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c46:	8b 04 85 80 95 11 00 	mov    0x119580(,%eax,4),%eax
  101c4d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c51:	c7 04 24 c2 65 10 00 	movl   $0x1065c2,(%esp)
  101c58:	e8 f9 e6 ff ff       	call   100356 <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101c5d:	ff 45 f4             	incl   -0xc(%ebp)
  101c60:	d1 65 f0             	shll   -0x10(%ebp)
  101c63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c66:	83 f8 17             	cmp    $0x17,%eax
  101c69:	76 bb                	jbe    101c26 <print_trapframe+0x111>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  101c6e:	8b 40 40             	mov    0x40(%eax),%eax
  101c71:	c1 e8 0c             	shr    $0xc,%eax
  101c74:	83 e0 03             	and    $0x3,%eax
  101c77:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c7b:	c7 04 24 c6 65 10 00 	movl   $0x1065c6,(%esp)
  101c82:	e8 cf e6 ff ff       	call   100356 <cprintf>

    if (!trap_in_kernel(tf)) {
  101c87:	8b 45 08             	mov    0x8(%ebp),%eax
  101c8a:	89 04 24             	mov    %eax,(%esp)
  101c8d:	e8 6e fe ff ff       	call   101b00 <trap_in_kernel>
  101c92:	85 c0                	test   %eax,%eax
  101c94:	75 2d                	jne    101cc3 <print_trapframe+0x1ae>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101c96:	8b 45 08             	mov    0x8(%ebp),%eax
  101c99:	8b 40 44             	mov    0x44(%eax),%eax
  101c9c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ca0:	c7 04 24 cf 65 10 00 	movl   $0x1065cf,(%esp)
  101ca7:	e8 aa e6 ff ff       	call   100356 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101cac:	8b 45 08             	mov    0x8(%ebp),%eax
  101caf:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101cb3:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cb7:	c7 04 24 de 65 10 00 	movl   $0x1065de,(%esp)
  101cbe:	e8 93 e6 ff ff       	call   100356 <cprintf>
    }
}
  101cc3:	90                   	nop
  101cc4:	89 ec                	mov    %ebp,%esp
  101cc6:	5d                   	pop    %ebp
  101cc7:	c3                   	ret    

00101cc8 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101cc8:	55                   	push   %ebp
  101cc9:	89 e5                	mov    %esp,%ebp
  101ccb:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101cce:	8b 45 08             	mov    0x8(%ebp),%eax
  101cd1:	8b 00                	mov    (%eax),%eax
  101cd3:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cd7:	c7 04 24 f1 65 10 00 	movl   $0x1065f1,(%esp)
  101cde:	e8 73 e6 ff ff       	call   100356 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  101ce6:	8b 40 04             	mov    0x4(%eax),%eax
  101ce9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ced:	c7 04 24 00 66 10 00 	movl   $0x106600,(%esp)
  101cf4:	e8 5d e6 ff ff       	call   100356 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  101cfc:	8b 40 08             	mov    0x8(%eax),%eax
  101cff:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d03:	c7 04 24 0f 66 10 00 	movl   $0x10660f,(%esp)
  101d0a:	e8 47 e6 ff ff       	call   100356 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  101d12:	8b 40 0c             	mov    0xc(%eax),%eax
  101d15:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d19:	c7 04 24 1e 66 10 00 	movl   $0x10661e,(%esp)
  101d20:	e8 31 e6 ff ff       	call   100356 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101d25:	8b 45 08             	mov    0x8(%ebp),%eax
  101d28:	8b 40 10             	mov    0x10(%eax),%eax
  101d2b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d2f:	c7 04 24 2d 66 10 00 	movl   $0x10662d,(%esp)
  101d36:	e8 1b e6 ff ff       	call   100356 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  101d3e:	8b 40 14             	mov    0x14(%eax),%eax
  101d41:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d45:	c7 04 24 3c 66 10 00 	movl   $0x10663c,(%esp)
  101d4c:	e8 05 e6 ff ff       	call   100356 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101d51:	8b 45 08             	mov    0x8(%ebp),%eax
  101d54:	8b 40 18             	mov    0x18(%eax),%eax
  101d57:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d5b:	c7 04 24 4b 66 10 00 	movl   $0x10664b,(%esp)
  101d62:	e8 ef e5 ff ff       	call   100356 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101d67:	8b 45 08             	mov    0x8(%ebp),%eax
  101d6a:	8b 40 1c             	mov    0x1c(%eax),%eax
  101d6d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d71:	c7 04 24 5a 66 10 00 	movl   $0x10665a,(%esp)
  101d78:	e8 d9 e5 ff ff       	call   100356 <cprintf>
}
  101d7d:	90                   	nop
  101d7e:	89 ec                	mov    %ebp,%esp
  101d80:	5d                   	pop    %ebp
  101d81:	c3                   	ret    

00101d82 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101d82:	55                   	push   %ebp
  101d83:	89 e5                	mov    %esp,%ebp
  101d85:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101d88:	8b 45 08             	mov    0x8(%ebp),%eax
  101d8b:	8b 40 30             	mov    0x30(%eax),%eax
  101d8e:	83 f8 79             	cmp    $0x79,%eax
  101d91:	0f 87 e6 00 00 00    	ja     101e7d <trap_dispatch+0xfb>
  101d97:	83 f8 78             	cmp    $0x78,%eax
  101d9a:	0f 83 c1 00 00 00    	jae    101e61 <trap_dispatch+0xdf>
  101da0:	83 f8 2f             	cmp    $0x2f,%eax
  101da3:	0f 87 d4 00 00 00    	ja     101e7d <trap_dispatch+0xfb>
  101da9:	83 f8 2e             	cmp    $0x2e,%eax
  101dac:	0f 83 00 01 00 00    	jae    101eb2 <trap_dispatch+0x130>
  101db2:	83 f8 24             	cmp    $0x24,%eax
  101db5:	74 5e                	je     101e15 <trap_dispatch+0x93>
  101db7:	83 f8 24             	cmp    $0x24,%eax
  101dba:	0f 87 bd 00 00 00    	ja     101e7d <trap_dispatch+0xfb>
  101dc0:	83 f8 20             	cmp    $0x20,%eax
  101dc3:	74 0a                	je     101dcf <trap_dispatch+0x4d>
  101dc5:	83 f8 21             	cmp    $0x21,%eax
  101dc8:	74 71                	je     101e3b <trap_dispatch+0xb9>
  101dca:	e9 ae 00 00 00       	jmp    101e7d <trap_dispatch+0xfb>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
  101dcf:	a1 24 c4 11 00       	mov    0x11c424,%eax
  101dd4:	40                   	inc    %eax
  101dd5:	a3 24 c4 11 00       	mov    %eax,0x11c424
        if (ticks % TICK_NUM == 0) {
  101dda:	8b 0d 24 c4 11 00    	mov    0x11c424,%ecx
  101de0:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101de5:	89 c8                	mov    %ecx,%eax
  101de7:	f7 e2                	mul    %edx
  101de9:	c1 ea 05             	shr    $0x5,%edx
  101dec:	89 d0                	mov    %edx,%eax
  101dee:	c1 e0 02             	shl    $0x2,%eax
  101df1:	01 d0                	add    %edx,%eax
  101df3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  101dfa:	01 d0                	add    %edx,%eax
  101dfc:	c1 e0 02             	shl    $0x2,%eax
  101dff:	29 c1                	sub    %eax,%ecx
  101e01:	89 ca                	mov    %ecx,%edx
  101e03:	85 d2                	test   %edx,%edx
  101e05:	0f 85 aa 00 00 00    	jne    101eb5 <trap_dispatch+0x133>
            print_ticks();
  101e0b:	e8 08 fb ff ff       	call   101918 <print_ticks>
        }
        break;
  101e10:	e9 a0 00 00 00       	jmp    101eb5 <trap_dispatch+0x133>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101e15:	e8 a1 f8 ff ff       	call   1016bb <cons_getc>
  101e1a:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101e1d:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101e21:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101e25:	89 54 24 08          	mov    %edx,0x8(%esp)
  101e29:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e2d:	c7 04 24 69 66 10 00 	movl   $0x106669,(%esp)
  101e34:	e8 1d e5 ff ff       	call   100356 <cprintf>
        break;
  101e39:	eb 7b                	jmp    101eb6 <trap_dispatch+0x134>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101e3b:	e8 7b f8 ff ff       	call   1016bb <cons_getc>
  101e40:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101e43:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101e47:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101e4b:	89 54 24 08          	mov    %edx,0x8(%esp)
  101e4f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e53:	c7 04 24 7b 66 10 00 	movl   $0x10667b,(%esp)
  101e5a:	e8 f7 e4 ff ff       	call   100356 <cprintf>
        break;
  101e5f:	eb 55                	jmp    101eb6 <trap_dispatch+0x134>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101e61:	c7 44 24 08 8a 66 10 	movl   $0x10668a,0x8(%esp)
  101e68:	00 
  101e69:	c7 44 24 04 b0 00 00 	movl   $0xb0,0x4(%esp)
  101e70:	00 
  101e71:	c7 04 24 ae 64 10 00 	movl   $0x1064ae,(%esp)
  101e78:	e8 5e ee ff ff       	call   100cdb <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  101e80:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101e84:	83 e0 03             	and    $0x3,%eax
  101e87:	85 c0                	test   %eax,%eax
  101e89:	75 2b                	jne    101eb6 <trap_dispatch+0x134>
            print_trapframe(tf);
  101e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  101e8e:	89 04 24             	mov    %eax,(%esp)
  101e91:	e8 7f fc ff ff       	call   101b15 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101e96:	c7 44 24 08 9a 66 10 	movl   $0x10669a,0x8(%esp)
  101e9d:	00 
  101e9e:	c7 44 24 04 ba 00 00 	movl   $0xba,0x4(%esp)
  101ea5:	00 
  101ea6:	c7 04 24 ae 64 10 00 	movl   $0x1064ae,(%esp)
  101ead:	e8 29 ee ff ff       	call   100cdb <__panic>
        break;
  101eb2:	90                   	nop
  101eb3:	eb 01                	jmp    101eb6 <trap_dispatch+0x134>
        break;
  101eb5:	90                   	nop
        }
    }
}
  101eb6:	90                   	nop
  101eb7:	89 ec                	mov    %ebp,%esp
  101eb9:	5d                   	pop    %ebp
  101eba:	c3                   	ret    

00101ebb <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101ebb:	55                   	push   %ebp
  101ebc:	89 e5                	mov    %esp,%ebp
  101ebe:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101ec1:	8b 45 08             	mov    0x8(%ebp),%eax
  101ec4:	89 04 24             	mov    %eax,(%esp)
  101ec7:	e8 b6 fe ff ff       	call   101d82 <trap_dispatch>
}
  101ecc:	90                   	nop
  101ecd:	89 ec                	mov    %ebp,%esp
  101ecf:	5d                   	pop    %ebp
  101ed0:	c3                   	ret    

00101ed1 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101ed1:	1e                   	push   %ds
    pushl %es
  101ed2:	06                   	push   %es
    pushl %fs
  101ed3:	0f a0                	push   %fs
    pushl %gs
  101ed5:	0f a8                	push   %gs
    pushal
  101ed7:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101ed8:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101edd:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101edf:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101ee1:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101ee2:	e8 d4 ff ff ff       	call   101ebb <trap>

    # pop the pushed stack pointer
    popl %esp
  101ee7:	5c                   	pop    %esp

00101ee8 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101ee8:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101ee9:	0f a9                	pop    %gs
    popl %fs
  101eeb:	0f a1                	pop    %fs
    popl %es
  101eed:	07                   	pop    %es
    popl %ds
  101eee:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101eef:	83 c4 08             	add    $0x8,%esp
    iret
  101ef2:	cf                   	iret   

00101ef3 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101ef3:	6a 00                	push   $0x0
  pushl $0
  101ef5:	6a 00                	push   $0x0
  jmp __alltraps
  101ef7:	e9 d5 ff ff ff       	jmp    101ed1 <__alltraps>

00101efc <vector1>:
.globl vector1
vector1:
  pushl $0
  101efc:	6a 00                	push   $0x0
  pushl $1
  101efe:	6a 01                	push   $0x1
  jmp __alltraps
  101f00:	e9 cc ff ff ff       	jmp    101ed1 <__alltraps>

00101f05 <vector2>:
.globl vector2
vector2:
  pushl $0
  101f05:	6a 00                	push   $0x0
  pushl $2
  101f07:	6a 02                	push   $0x2
  jmp __alltraps
  101f09:	e9 c3 ff ff ff       	jmp    101ed1 <__alltraps>

00101f0e <vector3>:
.globl vector3
vector3:
  pushl $0
  101f0e:	6a 00                	push   $0x0
  pushl $3
  101f10:	6a 03                	push   $0x3
  jmp __alltraps
  101f12:	e9 ba ff ff ff       	jmp    101ed1 <__alltraps>

00101f17 <vector4>:
.globl vector4
vector4:
  pushl $0
  101f17:	6a 00                	push   $0x0
  pushl $4
  101f19:	6a 04                	push   $0x4
  jmp __alltraps
  101f1b:	e9 b1 ff ff ff       	jmp    101ed1 <__alltraps>

00101f20 <vector5>:
.globl vector5
vector5:
  pushl $0
  101f20:	6a 00                	push   $0x0
  pushl $5
  101f22:	6a 05                	push   $0x5
  jmp __alltraps
  101f24:	e9 a8 ff ff ff       	jmp    101ed1 <__alltraps>

00101f29 <vector6>:
.globl vector6
vector6:
  pushl $0
  101f29:	6a 00                	push   $0x0
  pushl $6
  101f2b:	6a 06                	push   $0x6
  jmp __alltraps
  101f2d:	e9 9f ff ff ff       	jmp    101ed1 <__alltraps>

00101f32 <vector7>:
.globl vector7
vector7:
  pushl $0
  101f32:	6a 00                	push   $0x0
  pushl $7
  101f34:	6a 07                	push   $0x7
  jmp __alltraps
  101f36:	e9 96 ff ff ff       	jmp    101ed1 <__alltraps>

00101f3b <vector8>:
.globl vector8
vector8:
  pushl $8
  101f3b:	6a 08                	push   $0x8
  jmp __alltraps
  101f3d:	e9 8f ff ff ff       	jmp    101ed1 <__alltraps>

00101f42 <vector9>:
.globl vector9
vector9:
  pushl $0
  101f42:	6a 00                	push   $0x0
  pushl $9
  101f44:	6a 09                	push   $0x9
  jmp __alltraps
  101f46:	e9 86 ff ff ff       	jmp    101ed1 <__alltraps>

00101f4b <vector10>:
.globl vector10
vector10:
  pushl $10
  101f4b:	6a 0a                	push   $0xa
  jmp __alltraps
  101f4d:	e9 7f ff ff ff       	jmp    101ed1 <__alltraps>

00101f52 <vector11>:
.globl vector11
vector11:
  pushl $11
  101f52:	6a 0b                	push   $0xb
  jmp __alltraps
  101f54:	e9 78 ff ff ff       	jmp    101ed1 <__alltraps>

00101f59 <vector12>:
.globl vector12
vector12:
  pushl $12
  101f59:	6a 0c                	push   $0xc
  jmp __alltraps
  101f5b:	e9 71 ff ff ff       	jmp    101ed1 <__alltraps>

00101f60 <vector13>:
.globl vector13
vector13:
  pushl $13
  101f60:	6a 0d                	push   $0xd
  jmp __alltraps
  101f62:	e9 6a ff ff ff       	jmp    101ed1 <__alltraps>

00101f67 <vector14>:
.globl vector14
vector14:
  pushl $14
  101f67:	6a 0e                	push   $0xe
  jmp __alltraps
  101f69:	e9 63 ff ff ff       	jmp    101ed1 <__alltraps>

00101f6e <vector15>:
.globl vector15
vector15:
  pushl $0
  101f6e:	6a 00                	push   $0x0
  pushl $15
  101f70:	6a 0f                	push   $0xf
  jmp __alltraps
  101f72:	e9 5a ff ff ff       	jmp    101ed1 <__alltraps>

00101f77 <vector16>:
.globl vector16
vector16:
  pushl $0
  101f77:	6a 00                	push   $0x0
  pushl $16
  101f79:	6a 10                	push   $0x10
  jmp __alltraps
  101f7b:	e9 51 ff ff ff       	jmp    101ed1 <__alltraps>

00101f80 <vector17>:
.globl vector17
vector17:
  pushl $17
  101f80:	6a 11                	push   $0x11
  jmp __alltraps
  101f82:	e9 4a ff ff ff       	jmp    101ed1 <__alltraps>

00101f87 <vector18>:
.globl vector18
vector18:
  pushl $0
  101f87:	6a 00                	push   $0x0
  pushl $18
  101f89:	6a 12                	push   $0x12
  jmp __alltraps
  101f8b:	e9 41 ff ff ff       	jmp    101ed1 <__alltraps>

00101f90 <vector19>:
.globl vector19
vector19:
  pushl $0
  101f90:	6a 00                	push   $0x0
  pushl $19
  101f92:	6a 13                	push   $0x13
  jmp __alltraps
  101f94:	e9 38 ff ff ff       	jmp    101ed1 <__alltraps>

00101f99 <vector20>:
.globl vector20
vector20:
  pushl $0
  101f99:	6a 00                	push   $0x0
  pushl $20
  101f9b:	6a 14                	push   $0x14
  jmp __alltraps
  101f9d:	e9 2f ff ff ff       	jmp    101ed1 <__alltraps>

00101fa2 <vector21>:
.globl vector21
vector21:
  pushl $0
  101fa2:	6a 00                	push   $0x0
  pushl $21
  101fa4:	6a 15                	push   $0x15
  jmp __alltraps
  101fa6:	e9 26 ff ff ff       	jmp    101ed1 <__alltraps>

00101fab <vector22>:
.globl vector22
vector22:
  pushl $0
  101fab:	6a 00                	push   $0x0
  pushl $22
  101fad:	6a 16                	push   $0x16
  jmp __alltraps
  101faf:	e9 1d ff ff ff       	jmp    101ed1 <__alltraps>

00101fb4 <vector23>:
.globl vector23
vector23:
  pushl $0
  101fb4:	6a 00                	push   $0x0
  pushl $23
  101fb6:	6a 17                	push   $0x17
  jmp __alltraps
  101fb8:	e9 14 ff ff ff       	jmp    101ed1 <__alltraps>

00101fbd <vector24>:
.globl vector24
vector24:
  pushl $0
  101fbd:	6a 00                	push   $0x0
  pushl $24
  101fbf:	6a 18                	push   $0x18
  jmp __alltraps
  101fc1:	e9 0b ff ff ff       	jmp    101ed1 <__alltraps>

00101fc6 <vector25>:
.globl vector25
vector25:
  pushl $0
  101fc6:	6a 00                	push   $0x0
  pushl $25
  101fc8:	6a 19                	push   $0x19
  jmp __alltraps
  101fca:	e9 02 ff ff ff       	jmp    101ed1 <__alltraps>

00101fcf <vector26>:
.globl vector26
vector26:
  pushl $0
  101fcf:	6a 00                	push   $0x0
  pushl $26
  101fd1:	6a 1a                	push   $0x1a
  jmp __alltraps
  101fd3:	e9 f9 fe ff ff       	jmp    101ed1 <__alltraps>

00101fd8 <vector27>:
.globl vector27
vector27:
  pushl $0
  101fd8:	6a 00                	push   $0x0
  pushl $27
  101fda:	6a 1b                	push   $0x1b
  jmp __alltraps
  101fdc:	e9 f0 fe ff ff       	jmp    101ed1 <__alltraps>

00101fe1 <vector28>:
.globl vector28
vector28:
  pushl $0
  101fe1:	6a 00                	push   $0x0
  pushl $28
  101fe3:	6a 1c                	push   $0x1c
  jmp __alltraps
  101fe5:	e9 e7 fe ff ff       	jmp    101ed1 <__alltraps>

00101fea <vector29>:
.globl vector29
vector29:
  pushl $0
  101fea:	6a 00                	push   $0x0
  pushl $29
  101fec:	6a 1d                	push   $0x1d
  jmp __alltraps
  101fee:	e9 de fe ff ff       	jmp    101ed1 <__alltraps>

00101ff3 <vector30>:
.globl vector30
vector30:
  pushl $0
  101ff3:	6a 00                	push   $0x0
  pushl $30
  101ff5:	6a 1e                	push   $0x1e
  jmp __alltraps
  101ff7:	e9 d5 fe ff ff       	jmp    101ed1 <__alltraps>

00101ffc <vector31>:
.globl vector31
vector31:
  pushl $0
  101ffc:	6a 00                	push   $0x0
  pushl $31
  101ffe:	6a 1f                	push   $0x1f
  jmp __alltraps
  102000:	e9 cc fe ff ff       	jmp    101ed1 <__alltraps>

00102005 <vector32>:
.globl vector32
vector32:
  pushl $0
  102005:	6a 00                	push   $0x0
  pushl $32
  102007:	6a 20                	push   $0x20
  jmp __alltraps
  102009:	e9 c3 fe ff ff       	jmp    101ed1 <__alltraps>

0010200e <vector33>:
.globl vector33
vector33:
  pushl $0
  10200e:	6a 00                	push   $0x0
  pushl $33
  102010:	6a 21                	push   $0x21
  jmp __alltraps
  102012:	e9 ba fe ff ff       	jmp    101ed1 <__alltraps>

00102017 <vector34>:
.globl vector34
vector34:
  pushl $0
  102017:	6a 00                	push   $0x0
  pushl $34
  102019:	6a 22                	push   $0x22
  jmp __alltraps
  10201b:	e9 b1 fe ff ff       	jmp    101ed1 <__alltraps>

00102020 <vector35>:
.globl vector35
vector35:
  pushl $0
  102020:	6a 00                	push   $0x0
  pushl $35
  102022:	6a 23                	push   $0x23
  jmp __alltraps
  102024:	e9 a8 fe ff ff       	jmp    101ed1 <__alltraps>

00102029 <vector36>:
.globl vector36
vector36:
  pushl $0
  102029:	6a 00                	push   $0x0
  pushl $36
  10202b:	6a 24                	push   $0x24
  jmp __alltraps
  10202d:	e9 9f fe ff ff       	jmp    101ed1 <__alltraps>

00102032 <vector37>:
.globl vector37
vector37:
  pushl $0
  102032:	6a 00                	push   $0x0
  pushl $37
  102034:	6a 25                	push   $0x25
  jmp __alltraps
  102036:	e9 96 fe ff ff       	jmp    101ed1 <__alltraps>

0010203b <vector38>:
.globl vector38
vector38:
  pushl $0
  10203b:	6a 00                	push   $0x0
  pushl $38
  10203d:	6a 26                	push   $0x26
  jmp __alltraps
  10203f:	e9 8d fe ff ff       	jmp    101ed1 <__alltraps>

00102044 <vector39>:
.globl vector39
vector39:
  pushl $0
  102044:	6a 00                	push   $0x0
  pushl $39
  102046:	6a 27                	push   $0x27
  jmp __alltraps
  102048:	e9 84 fe ff ff       	jmp    101ed1 <__alltraps>

0010204d <vector40>:
.globl vector40
vector40:
  pushl $0
  10204d:	6a 00                	push   $0x0
  pushl $40
  10204f:	6a 28                	push   $0x28
  jmp __alltraps
  102051:	e9 7b fe ff ff       	jmp    101ed1 <__alltraps>

00102056 <vector41>:
.globl vector41
vector41:
  pushl $0
  102056:	6a 00                	push   $0x0
  pushl $41
  102058:	6a 29                	push   $0x29
  jmp __alltraps
  10205a:	e9 72 fe ff ff       	jmp    101ed1 <__alltraps>

0010205f <vector42>:
.globl vector42
vector42:
  pushl $0
  10205f:	6a 00                	push   $0x0
  pushl $42
  102061:	6a 2a                	push   $0x2a
  jmp __alltraps
  102063:	e9 69 fe ff ff       	jmp    101ed1 <__alltraps>

00102068 <vector43>:
.globl vector43
vector43:
  pushl $0
  102068:	6a 00                	push   $0x0
  pushl $43
  10206a:	6a 2b                	push   $0x2b
  jmp __alltraps
  10206c:	e9 60 fe ff ff       	jmp    101ed1 <__alltraps>

00102071 <vector44>:
.globl vector44
vector44:
  pushl $0
  102071:	6a 00                	push   $0x0
  pushl $44
  102073:	6a 2c                	push   $0x2c
  jmp __alltraps
  102075:	e9 57 fe ff ff       	jmp    101ed1 <__alltraps>

0010207a <vector45>:
.globl vector45
vector45:
  pushl $0
  10207a:	6a 00                	push   $0x0
  pushl $45
  10207c:	6a 2d                	push   $0x2d
  jmp __alltraps
  10207e:	e9 4e fe ff ff       	jmp    101ed1 <__alltraps>

00102083 <vector46>:
.globl vector46
vector46:
  pushl $0
  102083:	6a 00                	push   $0x0
  pushl $46
  102085:	6a 2e                	push   $0x2e
  jmp __alltraps
  102087:	e9 45 fe ff ff       	jmp    101ed1 <__alltraps>

0010208c <vector47>:
.globl vector47
vector47:
  pushl $0
  10208c:	6a 00                	push   $0x0
  pushl $47
  10208e:	6a 2f                	push   $0x2f
  jmp __alltraps
  102090:	e9 3c fe ff ff       	jmp    101ed1 <__alltraps>

00102095 <vector48>:
.globl vector48
vector48:
  pushl $0
  102095:	6a 00                	push   $0x0
  pushl $48
  102097:	6a 30                	push   $0x30
  jmp __alltraps
  102099:	e9 33 fe ff ff       	jmp    101ed1 <__alltraps>

0010209e <vector49>:
.globl vector49
vector49:
  pushl $0
  10209e:	6a 00                	push   $0x0
  pushl $49
  1020a0:	6a 31                	push   $0x31
  jmp __alltraps
  1020a2:	e9 2a fe ff ff       	jmp    101ed1 <__alltraps>

001020a7 <vector50>:
.globl vector50
vector50:
  pushl $0
  1020a7:	6a 00                	push   $0x0
  pushl $50
  1020a9:	6a 32                	push   $0x32
  jmp __alltraps
  1020ab:	e9 21 fe ff ff       	jmp    101ed1 <__alltraps>

001020b0 <vector51>:
.globl vector51
vector51:
  pushl $0
  1020b0:	6a 00                	push   $0x0
  pushl $51
  1020b2:	6a 33                	push   $0x33
  jmp __alltraps
  1020b4:	e9 18 fe ff ff       	jmp    101ed1 <__alltraps>

001020b9 <vector52>:
.globl vector52
vector52:
  pushl $0
  1020b9:	6a 00                	push   $0x0
  pushl $52
  1020bb:	6a 34                	push   $0x34
  jmp __alltraps
  1020bd:	e9 0f fe ff ff       	jmp    101ed1 <__alltraps>

001020c2 <vector53>:
.globl vector53
vector53:
  pushl $0
  1020c2:	6a 00                	push   $0x0
  pushl $53
  1020c4:	6a 35                	push   $0x35
  jmp __alltraps
  1020c6:	e9 06 fe ff ff       	jmp    101ed1 <__alltraps>

001020cb <vector54>:
.globl vector54
vector54:
  pushl $0
  1020cb:	6a 00                	push   $0x0
  pushl $54
  1020cd:	6a 36                	push   $0x36
  jmp __alltraps
  1020cf:	e9 fd fd ff ff       	jmp    101ed1 <__alltraps>

001020d4 <vector55>:
.globl vector55
vector55:
  pushl $0
  1020d4:	6a 00                	push   $0x0
  pushl $55
  1020d6:	6a 37                	push   $0x37
  jmp __alltraps
  1020d8:	e9 f4 fd ff ff       	jmp    101ed1 <__alltraps>

001020dd <vector56>:
.globl vector56
vector56:
  pushl $0
  1020dd:	6a 00                	push   $0x0
  pushl $56
  1020df:	6a 38                	push   $0x38
  jmp __alltraps
  1020e1:	e9 eb fd ff ff       	jmp    101ed1 <__alltraps>

001020e6 <vector57>:
.globl vector57
vector57:
  pushl $0
  1020e6:	6a 00                	push   $0x0
  pushl $57
  1020e8:	6a 39                	push   $0x39
  jmp __alltraps
  1020ea:	e9 e2 fd ff ff       	jmp    101ed1 <__alltraps>

001020ef <vector58>:
.globl vector58
vector58:
  pushl $0
  1020ef:	6a 00                	push   $0x0
  pushl $58
  1020f1:	6a 3a                	push   $0x3a
  jmp __alltraps
  1020f3:	e9 d9 fd ff ff       	jmp    101ed1 <__alltraps>

001020f8 <vector59>:
.globl vector59
vector59:
  pushl $0
  1020f8:	6a 00                	push   $0x0
  pushl $59
  1020fa:	6a 3b                	push   $0x3b
  jmp __alltraps
  1020fc:	e9 d0 fd ff ff       	jmp    101ed1 <__alltraps>

00102101 <vector60>:
.globl vector60
vector60:
  pushl $0
  102101:	6a 00                	push   $0x0
  pushl $60
  102103:	6a 3c                	push   $0x3c
  jmp __alltraps
  102105:	e9 c7 fd ff ff       	jmp    101ed1 <__alltraps>

0010210a <vector61>:
.globl vector61
vector61:
  pushl $0
  10210a:	6a 00                	push   $0x0
  pushl $61
  10210c:	6a 3d                	push   $0x3d
  jmp __alltraps
  10210e:	e9 be fd ff ff       	jmp    101ed1 <__alltraps>

00102113 <vector62>:
.globl vector62
vector62:
  pushl $0
  102113:	6a 00                	push   $0x0
  pushl $62
  102115:	6a 3e                	push   $0x3e
  jmp __alltraps
  102117:	e9 b5 fd ff ff       	jmp    101ed1 <__alltraps>

0010211c <vector63>:
.globl vector63
vector63:
  pushl $0
  10211c:	6a 00                	push   $0x0
  pushl $63
  10211e:	6a 3f                	push   $0x3f
  jmp __alltraps
  102120:	e9 ac fd ff ff       	jmp    101ed1 <__alltraps>

00102125 <vector64>:
.globl vector64
vector64:
  pushl $0
  102125:	6a 00                	push   $0x0
  pushl $64
  102127:	6a 40                	push   $0x40
  jmp __alltraps
  102129:	e9 a3 fd ff ff       	jmp    101ed1 <__alltraps>

0010212e <vector65>:
.globl vector65
vector65:
  pushl $0
  10212e:	6a 00                	push   $0x0
  pushl $65
  102130:	6a 41                	push   $0x41
  jmp __alltraps
  102132:	e9 9a fd ff ff       	jmp    101ed1 <__alltraps>

00102137 <vector66>:
.globl vector66
vector66:
  pushl $0
  102137:	6a 00                	push   $0x0
  pushl $66
  102139:	6a 42                	push   $0x42
  jmp __alltraps
  10213b:	e9 91 fd ff ff       	jmp    101ed1 <__alltraps>

00102140 <vector67>:
.globl vector67
vector67:
  pushl $0
  102140:	6a 00                	push   $0x0
  pushl $67
  102142:	6a 43                	push   $0x43
  jmp __alltraps
  102144:	e9 88 fd ff ff       	jmp    101ed1 <__alltraps>

00102149 <vector68>:
.globl vector68
vector68:
  pushl $0
  102149:	6a 00                	push   $0x0
  pushl $68
  10214b:	6a 44                	push   $0x44
  jmp __alltraps
  10214d:	e9 7f fd ff ff       	jmp    101ed1 <__alltraps>

00102152 <vector69>:
.globl vector69
vector69:
  pushl $0
  102152:	6a 00                	push   $0x0
  pushl $69
  102154:	6a 45                	push   $0x45
  jmp __alltraps
  102156:	e9 76 fd ff ff       	jmp    101ed1 <__alltraps>

0010215b <vector70>:
.globl vector70
vector70:
  pushl $0
  10215b:	6a 00                	push   $0x0
  pushl $70
  10215d:	6a 46                	push   $0x46
  jmp __alltraps
  10215f:	e9 6d fd ff ff       	jmp    101ed1 <__alltraps>

00102164 <vector71>:
.globl vector71
vector71:
  pushl $0
  102164:	6a 00                	push   $0x0
  pushl $71
  102166:	6a 47                	push   $0x47
  jmp __alltraps
  102168:	e9 64 fd ff ff       	jmp    101ed1 <__alltraps>

0010216d <vector72>:
.globl vector72
vector72:
  pushl $0
  10216d:	6a 00                	push   $0x0
  pushl $72
  10216f:	6a 48                	push   $0x48
  jmp __alltraps
  102171:	e9 5b fd ff ff       	jmp    101ed1 <__alltraps>

00102176 <vector73>:
.globl vector73
vector73:
  pushl $0
  102176:	6a 00                	push   $0x0
  pushl $73
  102178:	6a 49                	push   $0x49
  jmp __alltraps
  10217a:	e9 52 fd ff ff       	jmp    101ed1 <__alltraps>

0010217f <vector74>:
.globl vector74
vector74:
  pushl $0
  10217f:	6a 00                	push   $0x0
  pushl $74
  102181:	6a 4a                	push   $0x4a
  jmp __alltraps
  102183:	e9 49 fd ff ff       	jmp    101ed1 <__alltraps>

00102188 <vector75>:
.globl vector75
vector75:
  pushl $0
  102188:	6a 00                	push   $0x0
  pushl $75
  10218a:	6a 4b                	push   $0x4b
  jmp __alltraps
  10218c:	e9 40 fd ff ff       	jmp    101ed1 <__alltraps>

00102191 <vector76>:
.globl vector76
vector76:
  pushl $0
  102191:	6a 00                	push   $0x0
  pushl $76
  102193:	6a 4c                	push   $0x4c
  jmp __alltraps
  102195:	e9 37 fd ff ff       	jmp    101ed1 <__alltraps>

0010219a <vector77>:
.globl vector77
vector77:
  pushl $0
  10219a:	6a 00                	push   $0x0
  pushl $77
  10219c:	6a 4d                	push   $0x4d
  jmp __alltraps
  10219e:	e9 2e fd ff ff       	jmp    101ed1 <__alltraps>

001021a3 <vector78>:
.globl vector78
vector78:
  pushl $0
  1021a3:	6a 00                	push   $0x0
  pushl $78
  1021a5:	6a 4e                	push   $0x4e
  jmp __alltraps
  1021a7:	e9 25 fd ff ff       	jmp    101ed1 <__alltraps>

001021ac <vector79>:
.globl vector79
vector79:
  pushl $0
  1021ac:	6a 00                	push   $0x0
  pushl $79
  1021ae:	6a 4f                	push   $0x4f
  jmp __alltraps
  1021b0:	e9 1c fd ff ff       	jmp    101ed1 <__alltraps>

001021b5 <vector80>:
.globl vector80
vector80:
  pushl $0
  1021b5:	6a 00                	push   $0x0
  pushl $80
  1021b7:	6a 50                	push   $0x50
  jmp __alltraps
  1021b9:	e9 13 fd ff ff       	jmp    101ed1 <__alltraps>

001021be <vector81>:
.globl vector81
vector81:
  pushl $0
  1021be:	6a 00                	push   $0x0
  pushl $81
  1021c0:	6a 51                	push   $0x51
  jmp __alltraps
  1021c2:	e9 0a fd ff ff       	jmp    101ed1 <__alltraps>

001021c7 <vector82>:
.globl vector82
vector82:
  pushl $0
  1021c7:	6a 00                	push   $0x0
  pushl $82
  1021c9:	6a 52                	push   $0x52
  jmp __alltraps
  1021cb:	e9 01 fd ff ff       	jmp    101ed1 <__alltraps>

001021d0 <vector83>:
.globl vector83
vector83:
  pushl $0
  1021d0:	6a 00                	push   $0x0
  pushl $83
  1021d2:	6a 53                	push   $0x53
  jmp __alltraps
  1021d4:	e9 f8 fc ff ff       	jmp    101ed1 <__alltraps>

001021d9 <vector84>:
.globl vector84
vector84:
  pushl $0
  1021d9:	6a 00                	push   $0x0
  pushl $84
  1021db:	6a 54                	push   $0x54
  jmp __alltraps
  1021dd:	e9 ef fc ff ff       	jmp    101ed1 <__alltraps>

001021e2 <vector85>:
.globl vector85
vector85:
  pushl $0
  1021e2:	6a 00                	push   $0x0
  pushl $85
  1021e4:	6a 55                	push   $0x55
  jmp __alltraps
  1021e6:	e9 e6 fc ff ff       	jmp    101ed1 <__alltraps>

001021eb <vector86>:
.globl vector86
vector86:
  pushl $0
  1021eb:	6a 00                	push   $0x0
  pushl $86
  1021ed:	6a 56                	push   $0x56
  jmp __alltraps
  1021ef:	e9 dd fc ff ff       	jmp    101ed1 <__alltraps>

001021f4 <vector87>:
.globl vector87
vector87:
  pushl $0
  1021f4:	6a 00                	push   $0x0
  pushl $87
  1021f6:	6a 57                	push   $0x57
  jmp __alltraps
  1021f8:	e9 d4 fc ff ff       	jmp    101ed1 <__alltraps>

001021fd <vector88>:
.globl vector88
vector88:
  pushl $0
  1021fd:	6a 00                	push   $0x0
  pushl $88
  1021ff:	6a 58                	push   $0x58
  jmp __alltraps
  102201:	e9 cb fc ff ff       	jmp    101ed1 <__alltraps>

00102206 <vector89>:
.globl vector89
vector89:
  pushl $0
  102206:	6a 00                	push   $0x0
  pushl $89
  102208:	6a 59                	push   $0x59
  jmp __alltraps
  10220a:	e9 c2 fc ff ff       	jmp    101ed1 <__alltraps>

0010220f <vector90>:
.globl vector90
vector90:
  pushl $0
  10220f:	6a 00                	push   $0x0
  pushl $90
  102211:	6a 5a                	push   $0x5a
  jmp __alltraps
  102213:	e9 b9 fc ff ff       	jmp    101ed1 <__alltraps>

00102218 <vector91>:
.globl vector91
vector91:
  pushl $0
  102218:	6a 00                	push   $0x0
  pushl $91
  10221a:	6a 5b                	push   $0x5b
  jmp __alltraps
  10221c:	e9 b0 fc ff ff       	jmp    101ed1 <__alltraps>

00102221 <vector92>:
.globl vector92
vector92:
  pushl $0
  102221:	6a 00                	push   $0x0
  pushl $92
  102223:	6a 5c                	push   $0x5c
  jmp __alltraps
  102225:	e9 a7 fc ff ff       	jmp    101ed1 <__alltraps>

0010222a <vector93>:
.globl vector93
vector93:
  pushl $0
  10222a:	6a 00                	push   $0x0
  pushl $93
  10222c:	6a 5d                	push   $0x5d
  jmp __alltraps
  10222e:	e9 9e fc ff ff       	jmp    101ed1 <__alltraps>

00102233 <vector94>:
.globl vector94
vector94:
  pushl $0
  102233:	6a 00                	push   $0x0
  pushl $94
  102235:	6a 5e                	push   $0x5e
  jmp __alltraps
  102237:	e9 95 fc ff ff       	jmp    101ed1 <__alltraps>

0010223c <vector95>:
.globl vector95
vector95:
  pushl $0
  10223c:	6a 00                	push   $0x0
  pushl $95
  10223e:	6a 5f                	push   $0x5f
  jmp __alltraps
  102240:	e9 8c fc ff ff       	jmp    101ed1 <__alltraps>

00102245 <vector96>:
.globl vector96
vector96:
  pushl $0
  102245:	6a 00                	push   $0x0
  pushl $96
  102247:	6a 60                	push   $0x60
  jmp __alltraps
  102249:	e9 83 fc ff ff       	jmp    101ed1 <__alltraps>

0010224e <vector97>:
.globl vector97
vector97:
  pushl $0
  10224e:	6a 00                	push   $0x0
  pushl $97
  102250:	6a 61                	push   $0x61
  jmp __alltraps
  102252:	e9 7a fc ff ff       	jmp    101ed1 <__alltraps>

00102257 <vector98>:
.globl vector98
vector98:
  pushl $0
  102257:	6a 00                	push   $0x0
  pushl $98
  102259:	6a 62                	push   $0x62
  jmp __alltraps
  10225b:	e9 71 fc ff ff       	jmp    101ed1 <__alltraps>

00102260 <vector99>:
.globl vector99
vector99:
  pushl $0
  102260:	6a 00                	push   $0x0
  pushl $99
  102262:	6a 63                	push   $0x63
  jmp __alltraps
  102264:	e9 68 fc ff ff       	jmp    101ed1 <__alltraps>

00102269 <vector100>:
.globl vector100
vector100:
  pushl $0
  102269:	6a 00                	push   $0x0
  pushl $100
  10226b:	6a 64                	push   $0x64
  jmp __alltraps
  10226d:	e9 5f fc ff ff       	jmp    101ed1 <__alltraps>

00102272 <vector101>:
.globl vector101
vector101:
  pushl $0
  102272:	6a 00                	push   $0x0
  pushl $101
  102274:	6a 65                	push   $0x65
  jmp __alltraps
  102276:	e9 56 fc ff ff       	jmp    101ed1 <__alltraps>

0010227b <vector102>:
.globl vector102
vector102:
  pushl $0
  10227b:	6a 00                	push   $0x0
  pushl $102
  10227d:	6a 66                	push   $0x66
  jmp __alltraps
  10227f:	e9 4d fc ff ff       	jmp    101ed1 <__alltraps>

00102284 <vector103>:
.globl vector103
vector103:
  pushl $0
  102284:	6a 00                	push   $0x0
  pushl $103
  102286:	6a 67                	push   $0x67
  jmp __alltraps
  102288:	e9 44 fc ff ff       	jmp    101ed1 <__alltraps>

0010228d <vector104>:
.globl vector104
vector104:
  pushl $0
  10228d:	6a 00                	push   $0x0
  pushl $104
  10228f:	6a 68                	push   $0x68
  jmp __alltraps
  102291:	e9 3b fc ff ff       	jmp    101ed1 <__alltraps>

00102296 <vector105>:
.globl vector105
vector105:
  pushl $0
  102296:	6a 00                	push   $0x0
  pushl $105
  102298:	6a 69                	push   $0x69
  jmp __alltraps
  10229a:	e9 32 fc ff ff       	jmp    101ed1 <__alltraps>

0010229f <vector106>:
.globl vector106
vector106:
  pushl $0
  10229f:	6a 00                	push   $0x0
  pushl $106
  1022a1:	6a 6a                	push   $0x6a
  jmp __alltraps
  1022a3:	e9 29 fc ff ff       	jmp    101ed1 <__alltraps>

001022a8 <vector107>:
.globl vector107
vector107:
  pushl $0
  1022a8:	6a 00                	push   $0x0
  pushl $107
  1022aa:	6a 6b                	push   $0x6b
  jmp __alltraps
  1022ac:	e9 20 fc ff ff       	jmp    101ed1 <__alltraps>

001022b1 <vector108>:
.globl vector108
vector108:
  pushl $0
  1022b1:	6a 00                	push   $0x0
  pushl $108
  1022b3:	6a 6c                	push   $0x6c
  jmp __alltraps
  1022b5:	e9 17 fc ff ff       	jmp    101ed1 <__alltraps>

001022ba <vector109>:
.globl vector109
vector109:
  pushl $0
  1022ba:	6a 00                	push   $0x0
  pushl $109
  1022bc:	6a 6d                	push   $0x6d
  jmp __alltraps
  1022be:	e9 0e fc ff ff       	jmp    101ed1 <__alltraps>

001022c3 <vector110>:
.globl vector110
vector110:
  pushl $0
  1022c3:	6a 00                	push   $0x0
  pushl $110
  1022c5:	6a 6e                	push   $0x6e
  jmp __alltraps
  1022c7:	e9 05 fc ff ff       	jmp    101ed1 <__alltraps>

001022cc <vector111>:
.globl vector111
vector111:
  pushl $0
  1022cc:	6a 00                	push   $0x0
  pushl $111
  1022ce:	6a 6f                	push   $0x6f
  jmp __alltraps
  1022d0:	e9 fc fb ff ff       	jmp    101ed1 <__alltraps>

001022d5 <vector112>:
.globl vector112
vector112:
  pushl $0
  1022d5:	6a 00                	push   $0x0
  pushl $112
  1022d7:	6a 70                	push   $0x70
  jmp __alltraps
  1022d9:	e9 f3 fb ff ff       	jmp    101ed1 <__alltraps>

001022de <vector113>:
.globl vector113
vector113:
  pushl $0
  1022de:	6a 00                	push   $0x0
  pushl $113
  1022e0:	6a 71                	push   $0x71
  jmp __alltraps
  1022e2:	e9 ea fb ff ff       	jmp    101ed1 <__alltraps>

001022e7 <vector114>:
.globl vector114
vector114:
  pushl $0
  1022e7:	6a 00                	push   $0x0
  pushl $114
  1022e9:	6a 72                	push   $0x72
  jmp __alltraps
  1022eb:	e9 e1 fb ff ff       	jmp    101ed1 <__alltraps>

001022f0 <vector115>:
.globl vector115
vector115:
  pushl $0
  1022f0:	6a 00                	push   $0x0
  pushl $115
  1022f2:	6a 73                	push   $0x73
  jmp __alltraps
  1022f4:	e9 d8 fb ff ff       	jmp    101ed1 <__alltraps>

001022f9 <vector116>:
.globl vector116
vector116:
  pushl $0
  1022f9:	6a 00                	push   $0x0
  pushl $116
  1022fb:	6a 74                	push   $0x74
  jmp __alltraps
  1022fd:	e9 cf fb ff ff       	jmp    101ed1 <__alltraps>

00102302 <vector117>:
.globl vector117
vector117:
  pushl $0
  102302:	6a 00                	push   $0x0
  pushl $117
  102304:	6a 75                	push   $0x75
  jmp __alltraps
  102306:	e9 c6 fb ff ff       	jmp    101ed1 <__alltraps>

0010230b <vector118>:
.globl vector118
vector118:
  pushl $0
  10230b:	6a 00                	push   $0x0
  pushl $118
  10230d:	6a 76                	push   $0x76
  jmp __alltraps
  10230f:	e9 bd fb ff ff       	jmp    101ed1 <__alltraps>

00102314 <vector119>:
.globl vector119
vector119:
  pushl $0
  102314:	6a 00                	push   $0x0
  pushl $119
  102316:	6a 77                	push   $0x77
  jmp __alltraps
  102318:	e9 b4 fb ff ff       	jmp    101ed1 <__alltraps>

0010231d <vector120>:
.globl vector120
vector120:
  pushl $0
  10231d:	6a 00                	push   $0x0
  pushl $120
  10231f:	6a 78                	push   $0x78
  jmp __alltraps
  102321:	e9 ab fb ff ff       	jmp    101ed1 <__alltraps>

00102326 <vector121>:
.globl vector121
vector121:
  pushl $0
  102326:	6a 00                	push   $0x0
  pushl $121
  102328:	6a 79                	push   $0x79
  jmp __alltraps
  10232a:	e9 a2 fb ff ff       	jmp    101ed1 <__alltraps>

0010232f <vector122>:
.globl vector122
vector122:
  pushl $0
  10232f:	6a 00                	push   $0x0
  pushl $122
  102331:	6a 7a                	push   $0x7a
  jmp __alltraps
  102333:	e9 99 fb ff ff       	jmp    101ed1 <__alltraps>

00102338 <vector123>:
.globl vector123
vector123:
  pushl $0
  102338:	6a 00                	push   $0x0
  pushl $123
  10233a:	6a 7b                	push   $0x7b
  jmp __alltraps
  10233c:	e9 90 fb ff ff       	jmp    101ed1 <__alltraps>

00102341 <vector124>:
.globl vector124
vector124:
  pushl $0
  102341:	6a 00                	push   $0x0
  pushl $124
  102343:	6a 7c                	push   $0x7c
  jmp __alltraps
  102345:	e9 87 fb ff ff       	jmp    101ed1 <__alltraps>

0010234a <vector125>:
.globl vector125
vector125:
  pushl $0
  10234a:	6a 00                	push   $0x0
  pushl $125
  10234c:	6a 7d                	push   $0x7d
  jmp __alltraps
  10234e:	e9 7e fb ff ff       	jmp    101ed1 <__alltraps>

00102353 <vector126>:
.globl vector126
vector126:
  pushl $0
  102353:	6a 00                	push   $0x0
  pushl $126
  102355:	6a 7e                	push   $0x7e
  jmp __alltraps
  102357:	e9 75 fb ff ff       	jmp    101ed1 <__alltraps>

0010235c <vector127>:
.globl vector127
vector127:
  pushl $0
  10235c:	6a 00                	push   $0x0
  pushl $127
  10235e:	6a 7f                	push   $0x7f
  jmp __alltraps
  102360:	e9 6c fb ff ff       	jmp    101ed1 <__alltraps>

00102365 <vector128>:
.globl vector128
vector128:
  pushl $0
  102365:	6a 00                	push   $0x0
  pushl $128
  102367:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  10236c:	e9 60 fb ff ff       	jmp    101ed1 <__alltraps>

00102371 <vector129>:
.globl vector129
vector129:
  pushl $0
  102371:	6a 00                	push   $0x0
  pushl $129
  102373:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  102378:	e9 54 fb ff ff       	jmp    101ed1 <__alltraps>

0010237d <vector130>:
.globl vector130
vector130:
  pushl $0
  10237d:	6a 00                	push   $0x0
  pushl $130
  10237f:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  102384:	e9 48 fb ff ff       	jmp    101ed1 <__alltraps>

00102389 <vector131>:
.globl vector131
vector131:
  pushl $0
  102389:	6a 00                	push   $0x0
  pushl $131
  10238b:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  102390:	e9 3c fb ff ff       	jmp    101ed1 <__alltraps>

00102395 <vector132>:
.globl vector132
vector132:
  pushl $0
  102395:	6a 00                	push   $0x0
  pushl $132
  102397:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  10239c:	e9 30 fb ff ff       	jmp    101ed1 <__alltraps>

001023a1 <vector133>:
.globl vector133
vector133:
  pushl $0
  1023a1:	6a 00                	push   $0x0
  pushl $133
  1023a3:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  1023a8:	e9 24 fb ff ff       	jmp    101ed1 <__alltraps>

001023ad <vector134>:
.globl vector134
vector134:
  pushl $0
  1023ad:	6a 00                	push   $0x0
  pushl $134
  1023af:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  1023b4:	e9 18 fb ff ff       	jmp    101ed1 <__alltraps>

001023b9 <vector135>:
.globl vector135
vector135:
  pushl $0
  1023b9:	6a 00                	push   $0x0
  pushl $135
  1023bb:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  1023c0:	e9 0c fb ff ff       	jmp    101ed1 <__alltraps>

001023c5 <vector136>:
.globl vector136
vector136:
  pushl $0
  1023c5:	6a 00                	push   $0x0
  pushl $136
  1023c7:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  1023cc:	e9 00 fb ff ff       	jmp    101ed1 <__alltraps>

001023d1 <vector137>:
.globl vector137
vector137:
  pushl $0
  1023d1:	6a 00                	push   $0x0
  pushl $137
  1023d3:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  1023d8:	e9 f4 fa ff ff       	jmp    101ed1 <__alltraps>

001023dd <vector138>:
.globl vector138
vector138:
  pushl $0
  1023dd:	6a 00                	push   $0x0
  pushl $138
  1023df:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  1023e4:	e9 e8 fa ff ff       	jmp    101ed1 <__alltraps>

001023e9 <vector139>:
.globl vector139
vector139:
  pushl $0
  1023e9:	6a 00                	push   $0x0
  pushl $139
  1023eb:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  1023f0:	e9 dc fa ff ff       	jmp    101ed1 <__alltraps>

001023f5 <vector140>:
.globl vector140
vector140:
  pushl $0
  1023f5:	6a 00                	push   $0x0
  pushl $140
  1023f7:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  1023fc:	e9 d0 fa ff ff       	jmp    101ed1 <__alltraps>

00102401 <vector141>:
.globl vector141
vector141:
  pushl $0
  102401:	6a 00                	push   $0x0
  pushl $141
  102403:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  102408:	e9 c4 fa ff ff       	jmp    101ed1 <__alltraps>

0010240d <vector142>:
.globl vector142
vector142:
  pushl $0
  10240d:	6a 00                	push   $0x0
  pushl $142
  10240f:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  102414:	e9 b8 fa ff ff       	jmp    101ed1 <__alltraps>

00102419 <vector143>:
.globl vector143
vector143:
  pushl $0
  102419:	6a 00                	push   $0x0
  pushl $143
  10241b:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  102420:	e9 ac fa ff ff       	jmp    101ed1 <__alltraps>

00102425 <vector144>:
.globl vector144
vector144:
  pushl $0
  102425:	6a 00                	push   $0x0
  pushl $144
  102427:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  10242c:	e9 a0 fa ff ff       	jmp    101ed1 <__alltraps>

00102431 <vector145>:
.globl vector145
vector145:
  pushl $0
  102431:	6a 00                	push   $0x0
  pushl $145
  102433:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  102438:	e9 94 fa ff ff       	jmp    101ed1 <__alltraps>

0010243d <vector146>:
.globl vector146
vector146:
  pushl $0
  10243d:	6a 00                	push   $0x0
  pushl $146
  10243f:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  102444:	e9 88 fa ff ff       	jmp    101ed1 <__alltraps>

00102449 <vector147>:
.globl vector147
vector147:
  pushl $0
  102449:	6a 00                	push   $0x0
  pushl $147
  10244b:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  102450:	e9 7c fa ff ff       	jmp    101ed1 <__alltraps>

00102455 <vector148>:
.globl vector148
vector148:
  pushl $0
  102455:	6a 00                	push   $0x0
  pushl $148
  102457:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  10245c:	e9 70 fa ff ff       	jmp    101ed1 <__alltraps>

00102461 <vector149>:
.globl vector149
vector149:
  pushl $0
  102461:	6a 00                	push   $0x0
  pushl $149
  102463:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  102468:	e9 64 fa ff ff       	jmp    101ed1 <__alltraps>

0010246d <vector150>:
.globl vector150
vector150:
  pushl $0
  10246d:	6a 00                	push   $0x0
  pushl $150
  10246f:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  102474:	e9 58 fa ff ff       	jmp    101ed1 <__alltraps>

00102479 <vector151>:
.globl vector151
vector151:
  pushl $0
  102479:	6a 00                	push   $0x0
  pushl $151
  10247b:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  102480:	e9 4c fa ff ff       	jmp    101ed1 <__alltraps>

00102485 <vector152>:
.globl vector152
vector152:
  pushl $0
  102485:	6a 00                	push   $0x0
  pushl $152
  102487:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  10248c:	e9 40 fa ff ff       	jmp    101ed1 <__alltraps>

00102491 <vector153>:
.globl vector153
vector153:
  pushl $0
  102491:	6a 00                	push   $0x0
  pushl $153
  102493:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102498:	e9 34 fa ff ff       	jmp    101ed1 <__alltraps>

0010249d <vector154>:
.globl vector154
vector154:
  pushl $0
  10249d:	6a 00                	push   $0x0
  pushl $154
  10249f:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  1024a4:	e9 28 fa ff ff       	jmp    101ed1 <__alltraps>

001024a9 <vector155>:
.globl vector155
vector155:
  pushl $0
  1024a9:	6a 00                	push   $0x0
  pushl $155
  1024ab:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  1024b0:	e9 1c fa ff ff       	jmp    101ed1 <__alltraps>

001024b5 <vector156>:
.globl vector156
vector156:
  pushl $0
  1024b5:	6a 00                	push   $0x0
  pushl $156
  1024b7:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  1024bc:	e9 10 fa ff ff       	jmp    101ed1 <__alltraps>

001024c1 <vector157>:
.globl vector157
vector157:
  pushl $0
  1024c1:	6a 00                	push   $0x0
  pushl $157
  1024c3:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  1024c8:	e9 04 fa ff ff       	jmp    101ed1 <__alltraps>

001024cd <vector158>:
.globl vector158
vector158:
  pushl $0
  1024cd:	6a 00                	push   $0x0
  pushl $158
  1024cf:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  1024d4:	e9 f8 f9 ff ff       	jmp    101ed1 <__alltraps>

001024d9 <vector159>:
.globl vector159
vector159:
  pushl $0
  1024d9:	6a 00                	push   $0x0
  pushl $159
  1024db:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  1024e0:	e9 ec f9 ff ff       	jmp    101ed1 <__alltraps>

001024e5 <vector160>:
.globl vector160
vector160:
  pushl $0
  1024e5:	6a 00                	push   $0x0
  pushl $160
  1024e7:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  1024ec:	e9 e0 f9 ff ff       	jmp    101ed1 <__alltraps>

001024f1 <vector161>:
.globl vector161
vector161:
  pushl $0
  1024f1:	6a 00                	push   $0x0
  pushl $161
  1024f3:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  1024f8:	e9 d4 f9 ff ff       	jmp    101ed1 <__alltraps>

001024fd <vector162>:
.globl vector162
vector162:
  pushl $0
  1024fd:	6a 00                	push   $0x0
  pushl $162
  1024ff:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  102504:	e9 c8 f9 ff ff       	jmp    101ed1 <__alltraps>

00102509 <vector163>:
.globl vector163
vector163:
  pushl $0
  102509:	6a 00                	push   $0x0
  pushl $163
  10250b:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  102510:	e9 bc f9 ff ff       	jmp    101ed1 <__alltraps>

00102515 <vector164>:
.globl vector164
vector164:
  pushl $0
  102515:	6a 00                	push   $0x0
  pushl $164
  102517:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  10251c:	e9 b0 f9 ff ff       	jmp    101ed1 <__alltraps>

00102521 <vector165>:
.globl vector165
vector165:
  pushl $0
  102521:	6a 00                	push   $0x0
  pushl $165
  102523:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  102528:	e9 a4 f9 ff ff       	jmp    101ed1 <__alltraps>

0010252d <vector166>:
.globl vector166
vector166:
  pushl $0
  10252d:	6a 00                	push   $0x0
  pushl $166
  10252f:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  102534:	e9 98 f9 ff ff       	jmp    101ed1 <__alltraps>

00102539 <vector167>:
.globl vector167
vector167:
  pushl $0
  102539:	6a 00                	push   $0x0
  pushl $167
  10253b:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  102540:	e9 8c f9 ff ff       	jmp    101ed1 <__alltraps>

00102545 <vector168>:
.globl vector168
vector168:
  pushl $0
  102545:	6a 00                	push   $0x0
  pushl $168
  102547:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  10254c:	e9 80 f9 ff ff       	jmp    101ed1 <__alltraps>

00102551 <vector169>:
.globl vector169
vector169:
  pushl $0
  102551:	6a 00                	push   $0x0
  pushl $169
  102553:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102558:	e9 74 f9 ff ff       	jmp    101ed1 <__alltraps>

0010255d <vector170>:
.globl vector170
vector170:
  pushl $0
  10255d:	6a 00                	push   $0x0
  pushl $170
  10255f:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  102564:	e9 68 f9 ff ff       	jmp    101ed1 <__alltraps>

00102569 <vector171>:
.globl vector171
vector171:
  pushl $0
  102569:	6a 00                	push   $0x0
  pushl $171
  10256b:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  102570:	e9 5c f9 ff ff       	jmp    101ed1 <__alltraps>

00102575 <vector172>:
.globl vector172
vector172:
  pushl $0
  102575:	6a 00                	push   $0x0
  pushl $172
  102577:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  10257c:	e9 50 f9 ff ff       	jmp    101ed1 <__alltraps>

00102581 <vector173>:
.globl vector173
vector173:
  pushl $0
  102581:	6a 00                	push   $0x0
  pushl $173
  102583:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102588:	e9 44 f9 ff ff       	jmp    101ed1 <__alltraps>

0010258d <vector174>:
.globl vector174
vector174:
  pushl $0
  10258d:	6a 00                	push   $0x0
  pushl $174
  10258f:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  102594:	e9 38 f9 ff ff       	jmp    101ed1 <__alltraps>

00102599 <vector175>:
.globl vector175
vector175:
  pushl $0
  102599:	6a 00                	push   $0x0
  pushl $175
  10259b:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  1025a0:	e9 2c f9 ff ff       	jmp    101ed1 <__alltraps>

001025a5 <vector176>:
.globl vector176
vector176:
  pushl $0
  1025a5:	6a 00                	push   $0x0
  pushl $176
  1025a7:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  1025ac:	e9 20 f9 ff ff       	jmp    101ed1 <__alltraps>

001025b1 <vector177>:
.globl vector177
vector177:
  pushl $0
  1025b1:	6a 00                	push   $0x0
  pushl $177
  1025b3:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  1025b8:	e9 14 f9 ff ff       	jmp    101ed1 <__alltraps>

001025bd <vector178>:
.globl vector178
vector178:
  pushl $0
  1025bd:	6a 00                	push   $0x0
  pushl $178
  1025bf:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  1025c4:	e9 08 f9 ff ff       	jmp    101ed1 <__alltraps>

001025c9 <vector179>:
.globl vector179
vector179:
  pushl $0
  1025c9:	6a 00                	push   $0x0
  pushl $179
  1025cb:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  1025d0:	e9 fc f8 ff ff       	jmp    101ed1 <__alltraps>

001025d5 <vector180>:
.globl vector180
vector180:
  pushl $0
  1025d5:	6a 00                	push   $0x0
  pushl $180
  1025d7:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  1025dc:	e9 f0 f8 ff ff       	jmp    101ed1 <__alltraps>

001025e1 <vector181>:
.globl vector181
vector181:
  pushl $0
  1025e1:	6a 00                	push   $0x0
  pushl $181
  1025e3:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  1025e8:	e9 e4 f8 ff ff       	jmp    101ed1 <__alltraps>

001025ed <vector182>:
.globl vector182
vector182:
  pushl $0
  1025ed:	6a 00                	push   $0x0
  pushl $182
  1025ef:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  1025f4:	e9 d8 f8 ff ff       	jmp    101ed1 <__alltraps>

001025f9 <vector183>:
.globl vector183
vector183:
  pushl $0
  1025f9:	6a 00                	push   $0x0
  pushl $183
  1025fb:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  102600:	e9 cc f8 ff ff       	jmp    101ed1 <__alltraps>

00102605 <vector184>:
.globl vector184
vector184:
  pushl $0
  102605:	6a 00                	push   $0x0
  pushl $184
  102607:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  10260c:	e9 c0 f8 ff ff       	jmp    101ed1 <__alltraps>

00102611 <vector185>:
.globl vector185
vector185:
  pushl $0
  102611:	6a 00                	push   $0x0
  pushl $185
  102613:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  102618:	e9 b4 f8 ff ff       	jmp    101ed1 <__alltraps>

0010261d <vector186>:
.globl vector186
vector186:
  pushl $0
  10261d:	6a 00                	push   $0x0
  pushl $186
  10261f:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  102624:	e9 a8 f8 ff ff       	jmp    101ed1 <__alltraps>

00102629 <vector187>:
.globl vector187
vector187:
  pushl $0
  102629:	6a 00                	push   $0x0
  pushl $187
  10262b:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  102630:	e9 9c f8 ff ff       	jmp    101ed1 <__alltraps>

00102635 <vector188>:
.globl vector188
vector188:
  pushl $0
  102635:	6a 00                	push   $0x0
  pushl $188
  102637:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  10263c:	e9 90 f8 ff ff       	jmp    101ed1 <__alltraps>

00102641 <vector189>:
.globl vector189
vector189:
  pushl $0
  102641:	6a 00                	push   $0x0
  pushl $189
  102643:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102648:	e9 84 f8 ff ff       	jmp    101ed1 <__alltraps>

0010264d <vector190>:
.globl vector190
vector190:
  pushl $0
  10264d:	6a 00                	push   $0x0
  pushl $190
  10264f:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  102654:	e9 78 f8 ff ff       	jmp    101ed1 <__alltraps>

00102659 <vector191>:
.globl vector191
vector191:
  pushl $0
  102659:	6a 00                	push   $0x0
  pushl $191
  10265b:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  102660:	e9 6c f8 ff ff       	jmp    101ed1 <__alltraps>

00102665 <vector192>:
.globl vector192
vector192:
  pushl $0
  102665:	6a 00                	push   $0x0
  pushl $192
  102667:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  10266c:	e9 60 f8 ff ff       	jmp    101ed1 <__alltraps>

00102671 <vector193>:
.globl vector193
vector193:
  pushl $0
  102671:	6a 00                	push   $0x0
  pushl $193
  102673:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102678:	e9 54 f8 ff ff       	jmp    101ed1 <__alltraps>

0010267d <vector194>:
.globl vector194
vector194:
  pushl $0
  10267d:	6a 00                	push   $0x0
  pushl $194
  10267f:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  102684:	e9 48 f8 ff ff       	jmp    101ed1 <__alltraps>

00102689 <vector195>:
.globl vector195
vector195:
  pushl $0
  102689:	6a 00                	push   $0x0
  pushl $195
  10268b:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  102690:	e9 3c f8 ff ff       	jmp    101ed1 <__alltraps>

00102695 <vector196>:
.globl vector196
vector196:
  pushl $0
  102695:	6a 00                	push   $0x0
  pushl $196
  102697:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  10269c:	e9 30 f8 ff ff       	jmp    101ed1 <__alltraps>

001026a1 <vector197>:
.globl vector197
vector197:
  pushl $0
  1026a1:	6a 00                	push   $0x0
  pushl $197
  1026a3:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  1026a8:	e9 24 f8 ff ff       	jmp    101ed1 <__alltraps>

001026ad <vector198>:
.globl vector198
vector198:
  pushl $0
  1026ad:	6a 00                	push   $0x0
  pushl $198
  1026af:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  1026b4:	e9 18 f8 ff ff       	jmp    101ed1 <__alltraps>

001026b9 <vector199>:
.globl vector199
vector199:
  pushl $0
  1026b9:	6a 00                	push   $0x0
  pushl $199
  1026bb:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  1026c0:	e9 0c f8 ff ff       	jmp    101ed1 <__alltraps>

001026c5 <vector200>:
.globl vector200
vector200:
  pushl $0
  1026c5:	6a 00                	push   $0x0
  pushl $200
  1026c7:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  1026cc:	e9 00 f8 ff ff       	jmp    101ed1 <__alltraps>

001026d1 <vector201>:
.globl vector201
vector201:
  pushl $0
  1026d1:	6a 00                	push   $0x0
  pushl $201
  1026d3:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  1026d8:	e9 f4 f7 ff ff       	jmp    101ed1 <__alltraps>

001026dd <vector202>:
.globl vector202
vector202:
  pushl $0
  1026dd:	6a 00                	push   $0x0
  pushl $202
  1026df:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  1026e4:	e9 e8 f7 ff ff       	jmp    101ed1 <__alltraps>

001026e9 <vector203>:
.globl vector203
vector203:
  pushl $0
  1026e9:	6a 00                	push   $0x0
  pushl $203
  1026eb:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  1026f0:	e9 dc f7 ff ff       	jmp    101ed1 <__alltraps>

001026f5 <vector204>:
.globl vector204
vector204:
  pushl $0
  1026f5:	6a 00                	push   $0x0
  pushl $204
  1026f7:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  1026fc:	e9 d0 f7 ff ff       	jmp    101ed1 <__alltraps>

00102701 <vector205>:
.globl vector205
vector205:
  pushl $0
  102701:	6a 00                	push   $0x0
  pushl $205
  102703:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  102708:	e9 c4 f7 ff ff       	jmp    101ed1 <__alltraps>

0010270d <vector206>:
.globl vector206
vector206:
  pushl $0
  10270d:	6a 00                	push   $0x0
  pushl $206
  10270f:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  102714:	e9 b8 f7 ff ff       	jmp    101ed1 <__alltraps>

00102719 <vector207>:
.globl vector207
vector207:
  pushl $0
  102719:	6a 00                	push   $0x0
  pushl $207
  10271b:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  102720:	e9 ac f7 ff ff       	jmp    101ed1 <__alltraps>

00102725 <vector208>:
.globl vector208
vector208:
  pushl $0
  102725:	6a 00                	push   $0x0
  pushl $208
  102727:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  10272c:	e9 a0 f7 ff ff       	jmp    101ed1 <__alltraps>

00102731 <vector209>:
.globl vector209
vector209:
  pushl $0
  102731:	6a 00                	push   $0x0
  pushl $209
  102733:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102738:	e9 94 f7 ff ff       	jmp    101ed1 <__alltraps>

0010273d <vector210>:
.globl vector210
vector210:
  pushl $0
  10273d:	6a 00                	push   $0x0
  pushl $210
  10273f:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  102744:	e9 88 f7 ff ff       	jmp    101ed1 <__alltraps>

00102749 <vector211>:
.globl vector211
vector211:
  pushl $0
  102749:	6a 00                	push   $0x0
  pushl $211
  10274b:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  102750:	e9 7c f7 ff ff       	jmp    101ed1 <__alltraps>

00102755 <vector212>:
.globl vector212
vector212:
  pushl $0
  102755:	6a 00                	push   $0x0
  pushl $212
  102757:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  10275c:	e9 70 f7 ff ff       	jmp    101ed1 <__alltraps>

00102761 <vector213>:
.globl vector213
vector213:
  pushl $0
  102761:	6a 00                	push   $0x0
  pushl $213
  102763:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102768:	e9 64 f7 ff ff       	jmp    101ed1 <__alltraps>

0010276d <vector214>:
.globl vector214
vector214:
  pushl $0
  10276d:	6a 00                	push   $0x0
  pushl $214
  10276f:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  102774:	e9 58 f7 ff ff       	jmp    101ed1 <__alltraps>

00102779 <vector215>:
.globl vector215
vector215:
  pushl $0
  102779:	6a 00                	push   $0x0
  pushl $215
  10277b:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102780:	e9 4c f7 ff ff       	jmp    101ed1 <__alltraps>

00102785 <vector216>:
.globl vector216
vector216:
  pushl $0
  102785:	6a 00                	push   $0x0
  pushl $216
  102787:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  10278c:	e9 40 f7 ff ff       	jmp    101ed1 <__alltraps>

00102791 <vector217>:
.globl vector217
vector217:
  pushl $0
  102791:	6a 00                	push   $0x0
  pushl $217
  102793:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102798:	e9 34 f7 ff ff       	jmp    101ed1 <__alltraps>

0010279d <vector218>:
.globl vector218
vector218:
  pushl $0
  10279d:	6a 00                	push   $0x0
  pushl $218
  10279f:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  1027a4:	e9 28 f7 ff ff       	jmp    101ed1 <__alltraps>

001027a9 <vector219>:
.globl vector219
vector219:
  pushl $0
  1027a9:	6a 00                	push   $0x0
  pushl $219
  1027ab:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  1027b0:	e9 1c f7 ff ff       	jmp    101ed1 <__alltraps>

001027b5 <vector220>:
.globl vector220
vector220:
  pushl $0
  1027b5:	6a 00                	push   $0x0
  pushl $220
  1027b7:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  1027bc:	e9 10 f7 ff ff       	jmp    101ed1 <__alltraps>

001027c1 <vector221>:
.globl vector221
vector221:
  pushl $0
  1027c1:	6a 00                	push   $0x0
  pushl $221
  1027c3:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  1027c8:	e9 04 f7 ff ff       	jmp    101ed1 <__alltraps>

001027cd <vector222>:
.globl vector222
vector222:
  pushl $0
  1027cd:	6a 00                	push   $0x0
  pushl $222
  1027cf:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  1027d4:	e9 f8 f6 ff ff       	jmp    101ed1 <__alltraps>

001027d9 <vector223>:
.globl vector223
vector223:
  pushl $0
  1027d9:	6a 00                	push   $0x0
  pushl $223
  1027db:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  1027e0:	e9 ec f6 ff ff       	jmp    101ed1 <__alltraps>

001027e5 <vector224>:
.globl vector224
vector224:
  pushl $0
  1027e5:	6a 00                	push   $0x0
  pushl $224
  1027e7:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  1027ec:	e9 e0 f6 ff ff       	jmp    101ed1 <__alltraps>

001027f1 <vector225>:
.globl vector225
vector225:
  pushl $0
  1027f1:	6a 00                	push   $0x0
  pushl $225
  1027f3:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  1027f8:	e9 d4 f6 ff ff       	jmp    101ed1 <__alltraps>

001027fd <vector226>:
.globl vector226
vector226:
  pushl $0
  1027fd:	6a 00                	push   $0x0
  pushl $226
  1027ff:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  102804:	e9 c8 f6 ff ff       	jmp    101ed1 <__alltraps>

00102809 <vector227>:
.globl vector227
vector227:
  pushl $0
  102809:	6a 00                	push   $0x0
  pushl $227
  10280b:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  102810:	e9 bc f6 ff ff       	jmp    101ed1 <__alltraps>

00102815 <vector228>:
.globl vector228
vector228:
  pushl $0
  102815:	6a 00                	push   $0x0
  pushl $228
  102817:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  10281c:	e9 b0 f6 ff ff       	jmp    101ed1 <__alltraps>

00102821 <vector229>:
.globl vector229
vector229:
  pushl $0
  102821:	6a 00                	push   $0x0
  pushl $229
  102823:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  102828:	e9 a4 f6 ff ff       	jmp    101ed1 <__alltraps>

0010282d <vector230>:
.globl vector230
vector230:
  pushl $0
  10282d:	6a 00                	push   $0x0
  pushl $230
  10282f:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  102834:	e9 98 f6 ff ff       	jmp    101ed1 <__alltraps>

00102839 <vector231>:
.globl vector231
vector231:
  pushl $0
  102839:	6a 00                	push   $0x0
  pushl $231
  10283b:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  102840:	e9 8c f6 ff ff       	jmp    101ed1 <__alltraps>

00102845 <vector232>:
.globl vector232
vector232:
  pushl $0
  102845:	6a 00                	push   $0x0
  pushl $232
  102847:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  10284c:	e9 80 f6 ff ff       	jmp    101ed1 <__alltraps>

00102851 <vector233>:
.globl vector233
vector233:
  pushl $0
  102851:	6a 00                	push   $0x0
  pushl $233
  102853:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102858:	e9 74 f6 ff ff       	jmp    101ed1 <__alltraps>

0010285d <vector234>:
.globl vector234
vector234:
  pushl $0
  10285d:	6a 00                	push   $0x0
  pushl $234
  10285f:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  102864:	e9 68 f6 ff ff       	jmp    101ed1 <__alltraps>

00102869 <vector235>:
.globl vector235
vector235:
  pushl $0
  102869:	6a 00                	push   $0x0
  pushl $235
  10286b:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102870:	e9 5c f6 ff ff       	jmp    101ed1 <__alltraps>

00102875 <vector236>:
.globl vector236
vector236:
  pushl $0
  102875:	6a 00                	push   $0x0
  pushl $236
  102877:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  10287c:	e9 50 f6 ff ff       	jmp    101ed1 <__alltraps>

00102881 <vector237>:
.globl vector237
vector237:
  pushl $0
  102881:	6a 00                	push   $0x0
  pushl $237
  102883:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102888:	e9 44 f6 ff ff       	jmp    101ed1 <__alltraps>

0010288d <vector238>:
.globl vector238
vector238:
  pushl $0
  10288d:	6a 00                	push   $0x0
  pushl $238
  10288f:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102894:	e9 38 f6 ff ff       	jmp    101ed1 <__alltraps>

00102899 <vector239>:
.globl vector239
vector239:
  pushl $0
  102899:	6a 00                	push   $0x0
  pushl $239
  10289b:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  1028a0:	e9 2c f6 ff ff       	jmp    101ed1 <__alltraps>

001028a5 <vector240>:
.globl vector240
vector240:
  pushl $0
  1028a5:	6a 00                	push   $0x0
  pushl $240
  1028a7:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  1028ac:	e9 20 f6 ff ff       	jmp    101ed1 <__alltraps>

001028b1 <vector241>:
.globl vector241
vector241:
  pushl $0
  1028b1:	6a 00                	push   $0x0
  pushl $241
  1028b3:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  1028b8:	e9 14 f6 ff ff       	jmp    101ed1 <__alltraps>

001028bd <vector242>:
.globl vector242
vector242:
  pushl $0
  1028bd:	6a 00                	push   $0x0
  pushl $242
  1028bf:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  1028c4:	e9 08 f6 ff ff       	jmp    101ed1 <__alltraps>

001028c9 <vector243>:
.globl vector243
vector243:
  pushl $0
  1028c9:	6a 00                	push   $0x0
  pushl $243
  1028cb:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  1028d0:	e9 fc f5 ff ff       	jmp    101ed1 <__alltraps>

001028d5 <vector244>:
.globl vector244
vector244:
  pushl $0
  1028d5:	6a 00                	push   $0x0
  pushl $244
  1028d7:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  1028dc:	e9 f0 f5 ff ff       	jmp    101ed1 <__alltraps>

001028e1 <vector245>:
.globl vector245
vector245:
  pushl $0
  1028e1:	6a 00                	push   $0x0
  pushl $245
  1028e3:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  1028e8:	e9 e4 f5 ff ff       	jmp    101ed1 <__alltraps>

001028ed <vector246>:
.globl vector246
vector246:
  pushl $0
  1028ed:	6a 00                	push   $0x0
  pushl $246
  1028ef:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  1028f4:	e9 d8 f5 ff ff       	jmp    101ed1 <__alltraps>

001028f9 <vector247>:
.globl vector247
vector247:
  pushl $0
  1028f9:	6a 00                	push   $0x0
  pushl $247
  1028fb:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102900:	e9 cc f5 ff ff       	jmp    101ed1 <__alltraps>

00102905 <vector248>:
.globl vector248
vector248:
  pushl $0
  102905:	6a 00                	push   $0x0
  pushl $248
  102907:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  10290c:	e9 c0 f5 ff ff       	jmp    101ed1 <__alltraps>

00102911 <vector249>:
.globl vector249
vector249:
  pushl $0
  102911:	6a 00                	push   $0x0
  pushl $249
  102913:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102918:	e9 b4 f5 ff ff       	jmp    101ed1 <__alltraps>

0010291d <vector250>:
.globl vector250
vector250:
  pushl $0
  10291d:	6a 00                	push   $0x0
  pushl $250
  10291f:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102924:	e9 a8 f5 ff ff       	jmp    101ed1 <__alltraps>

00102929 <vector251>:
.globl vector251
vector251:
  pushl $0
  102929:	6a 00                	push   $0x0
  pushl $251
  10292b:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102930:	e9 9c f5 ff ff       	jmp    101ed1 <__alltraps>

00102935 <vector252>:
.globl vector252
vector252:
  pushl $0
  102935:	6a 00                	push   $0x0
  pushl $252
  102937:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  10293c:	e9 90 f5 ff ff       	jmp    101ed1 <__alltraps>

00102941 <vector253>:
.globl vector253
vector253:
  pushl $0
  102941:	6a 00                	push   $0x0
  pushl $253
  102943:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102948:	e9 84 f5 ff ff       	jmp    101ed1 <__alltraps>

0010294d <vector254>:
.globl vector254
vector254:
  pushl $0
  10294d:	6a 00                	push   $0x0
  pushl $254
  10294f:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102954:	e9 78 f5 ff ff       	jmp    101ed1 <__alltraps>

00102959 <vector255>:
.globl vector255
vector255:
  pushl $0
  102959:	6a 00                	push   $0x0
  pushl $255
  10295b:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102960:	e9 6c f5 ff ff       	jmp    101ed1 <__alltraps>

00102965 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  102965:	55                   	push   %ebp
  102966:	89 e5                	mov    %esp,%ebp
    return page - pages;
  102968:	8b 15 a0 ce 11 00    	mov    0x11cea0,%edx
  10296e:	8b 45 08             	mov    0x8(%ebp),%eax
  102971:	29 d0                	sub    %edx,%eax
  102973:	c1 f8 02             	sar    $0x2,%eax
  102976:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  10297c:	5d                   	pop    %ebp
  10297d:	c3                   	ret    

0010297e <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  10297e:	55                   	push   %ebp
  10297f:	89 e5                	mov    %esp,%ebp
  102981:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  102984:	8b 45 08             	mov    0x8(%ebp),%eax
  102987:	89 04 24             	mov    %eax,(%esp)
  10298a:	e8 d6 ff ff ff       	call   102965 <page2ppn>
  10298f:	c1 e0 0c             	shl    $0xc,%eax
}
  102992:	89 ec                	mov    %ebp,%esp
  102994:	5d                   	pop    %ebp
  102995:	c3                   	ret    

00102996 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  102996:	55                   	push   %ebp
  102997:	89 e5                	mov    %esp,%ebp
    return page->ref;
  102999:	8b 45 08             	mov    0x8(%ebp),%eax
  10299c:	8b 00                	mov    (%eax),%eax
}
  10299e:	5d                   	pop    %ebp
  10299f:	c3                   	ret    

001029a0 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  1029a0:	55                   	push   %ebp
  1029a1:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  1029a3:	8b 45 08             	mov    0x8(%ebp),%eax
  1029a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  1029a9:	89 10                	mov    %edx,(%eax)
}
  1029ab:	90                   	nop
  1029ac:	5d                   	pop    %ebp
  1029ad:	c3                   	ret    

001029ae <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
  1029ae:	55                   	push   %ebp
  1029af:	89 e5                	mov    %esp,%ebp
  1029b1:	83 ec 10             	sub    $0x10,%esp
  1029b4:	c7 45 fc 80 ce 11 00 	movl   $0x11ce80,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  1029bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1029be:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1029c1:	89 50 04             	mov    %edx,0x4(%eax)
  1029c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1029c7:	8b 50 04             	mov    0x4(%eax),%edx
  1029ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1029cd:	89 10                	mov    %edx,(%eax)
}
  1029cf:	90                   	nop
    list_init(&free_list);
    nr_free = 0;
  1029d0:	c7 05 88 ce 11 00 00 	movl   $0x0,0x11ce88
  1029d7:	00 00 00 
}
  1029da:	90                   	nop
  1029db:	89 ec                	mov    %ebp,%esp
  1029dd:	5d                   	pop    %ebp
  1029de:	c3                   	ret    

001029df <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
  1029df:	55                   	push   %ebp
  1029e0:	89 e5                	mov    %esp,%ebp
  1029e2:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
  1029e5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1029e9:	75 24                	jne    102a0f <default_init_memmap+0x30>
  1029eb:	c7 44 24 0c 50 68 10 	movl   $0x106850,0xc(%esp)
  1029f2:	00 
  1029f3:	c7 44 24 08 56 68 10 	movl   $0x106856,0x8(%esp)
  1029fa:	00 
  1029fb:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  102a02:	00 
  102a03:	c7 04 24 6b 68 10 00 	movl   $0x10686b,(%esp)
  102a0a:	e8 cc e2 ff ff       	call   100cdb <__panic>
    struct Page *p = base;
  102a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  102a12:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  102a15:	e9 97 00 00 00       	jmp    102ab1 <default_init_memmap+0xd2>
        assert(PageReserved(p));
  102a1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a1d:	83 c0 04             	add    $0x4,%eax
  102a20:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  102a27:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102a2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102a2d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102a30:	0f a3 10             	bt     %edx,(%eax)
  102a33:	19 c0                	sbb    %eax,%eax
  102a35:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
  102a38:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102a3c:	0f 95 c0             	setne  %al
  102a3f:	0f b6 c0             	movzbl %al,%eax
  102a42:	85 c0                	test   %eax,%eax
  102a44:	75 24                	jne    102a6a <default_init_memmap+0x8b>
  102a46:	c7 44 24 0c 81 68 10 	movl   $0x106881,0xc(%esp)
  102a4d:	00 
  102a4e:	c7 44 24 08 56 68 10 	movl   $0x106856,0x8(%esp)
  102a55:	00 
  102a56:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
  102a5d:	00 
  102a5e:	c7 04 24 6b 68 10 00 	movl   $0x10686b,(%esp)
  102a65:	e8 71 e2 ff ff       	call   100cdb <__panic>
        p->flags = p->property = 0;
  102a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a6d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  102a74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a77:	8b 50 08             	mov    0x8(%eax),%edx
  102a7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a7d:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
  102a80:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102a87:	00 
  102a88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a8b:	89 04 24             	mov    %eax,(%esp)
  102a8e:	e8 0d ff ff ff       	call   1029a0 <set_page_ref>
        SetPageProperty(p);
  102a93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a96:	83 c0 04             	add    $0x4,%eax
  102a99:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  102aa0:	89 45 e0             	mov    %eax,-0x20(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102aa3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102aa6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102aa9:	0f ab 10             	bts    %edx,(%eax)
}
  102aac:	90                   	nop
    for (; p != base + n; p ++) {
  102aad:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  102ab1:	8b 55 0c             	mov    0xc(%ebp),%edx
  102ab4:	89 d0                	mov    %edx,%eax
  102ab6:	c1 e0 02             	shl    $0x2,%eax
  102ab9:	01 d0                	add    %edx,%eax
  102abb:	c1 e0 02             	shl    $0x2,%eax
  102abe:	89 c2                	mov    %eax,%edx
  102ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  102ac3:	01 d0                	add    %edx,%eax
  102ac5:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  102ac8:	0f 85 4c ff ff ff    	jne    102a1a <default_init_memmap+0x3b>
    }
    base->property = n;
  102ace:	8b 45 08             	mov    0x8(%ebp),%eax
  102ad1:	8b 55 0c             	mov    0xc(%ebp),%edx
  102ad4:	89 50 08             	mov    %edx,0x8(%eax)
    //SetPageProperty(base);
    nr_free += n;
  102ad7:	8b 15 88 ce 11 00    	mov    0x11ce88,%edx
  102add:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ae0:	01 d0                	add    %edx,%eax
  102ae2:	a3 88 ce 11 00       	mov    %eax,0x11ce88
    list_add(&free_list, &(base->page_link));
  102ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  102aea:	83 c0 0c             	add    $0xc,%eax
  102aed:	c7 45 dc 80 ce 11 00 	movl   $0x11ce80,-0x24(%ebp)
  102af4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  102af7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102afa:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  102afd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102b00:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  102b03:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102b06:	8b 40 04             	mov    0x4(%eax),%eax
  102b09:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102b0c:	89 55 cc             	mov    %edx,-0x34(%ebp)
  102b0f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102b12:	89 55 c8             	mov    %edx,-0x38(%ebp)
  102b15:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102b18:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102b1b:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102b1e:	89 10                	mov    %edx,(%eax)
  102b20:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102b23:	8b 10                	mov    (%eax),%edx
  102b25:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102b28:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102b2b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102b2e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102b31:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102b34:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102b37:	8b 55 c8             	mov    -0x38(%ebp),%edx
  102b3a:	89 10                	mov    %edx,(%eax)
}
  102b3c:	90                   	nop
}
  102b3d:	90                   	nop
}
  102b3e:	90                   	nop
}
  102b3f:	90                   	nop
  102b40:	89 ec                	mov    %ebp,%esp
  102b42:	5d                   	pop    %ebp
  102b43:	c3                   	ret    

00102b44 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
  102b44:	55                   	push   %ebp
  102b45:	89 e5                	mov    %esp,%ebp
  102b47:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
  102b4a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102b4e:	75 24                	jne    102b74 <default_alloc_pages+0x30>
  102b50:	c7 44 24 0c 50 68 10 	movl   $0x106850,0xc(%esp)
  102b57:	00 
  102b58:	c7 44 24 08 56 68 10 	movl   $0x106856,0x8(%esp)
  102b5f:	00 
  102b60:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  102b67:	00 
  102b68:	c7 04 24 6b 68 10 00 	movl   $0x10686b,(%esp)
  102b6f:	e8 67 e1 ff ff       	call   100cdb <__panic>
    if (n > nr_free) {
  102b74:	a1 88 ce 11 00       	mov    0x11ce88,%eax
  102b79:	39 45 08             	cmp    %eax,0x8(%ebp)
  102b7c:	76 0a                	jbe    102b88 <default_alloc_pages+0x44>
        return NULL;
  102b7e:	b8 00 00 00 00       	mov    $0x0,%eax
  102b83:	e9 5b 01 00 00       	jmp    102ce3 <default_alloc_pages+0x19f>
    }
    struct Page *page = NULL;
  102b88:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
  102b8f:	c7 45 f0 80 ce 11 00 	movl   $0x11ce80,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
  102b96:	eb 1c                	jmp    102bb4 <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
  102b98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b9b:	83 e8 0c             	sub    $0xc,%eax
  102b9e:	89 45 e8             	mov    %eax,-0x18(%ebp)
        if (p->property >= n) {
  102ba1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102ba4:	8b 40 08             	mov    0x8(%eax),%eax
  102ba7:	39 45 08             	cmp    %eax,0x8(%ebp)
  102baa:	77 08                	ja     102bb4 <default_alloc_pages+0x70>
            page = p;
  102bac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102baf:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  102bb2:	eb 18                	jmp    102bcc <default_alloc_pages+0x88>
  102bb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102bb7:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return listelm->next;
  102bba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102bbd:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  102bc0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102bc3:	81 7d f0 80 ce 11 00 	cmpl   $0x11ce80,-0x10(%ebp)
  102bca:	75 cc                	jne    102b98 <default_alloc_pages+0x54>
        }
    }
    if (page != NULL) { // 如果寻找到了满足条件的空闲内存块
  102bcc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  102bd0:	0f 84 0a 01 00 00    	je     102ce0 <default_alloc_pages+0x19c>
            p->property = page->property - n;
            list_add(&free_list, &(p->page_link));
    }
        nr_free -= n;
        ClearPageProperty(page);*/
        for (struct Page *p = page; p != (page + n); ++p) 
  102bd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102bd9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102bdc:	eb 1e                	jmp    102bfc <default_alloc_pages+0xb8>
        {
            ClearPageProperty(p); // 将分配出去的内存页标记为非空闲
  102bde:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102be1:	83 c0 04             	add    $0x4,%eax
  102be4:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
  102beb:	89 45 d8             	mov    %eax,-0x28(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102bee:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102bf1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102bf4:	0f b3 10             	btr    %edx,(%eax)
}
  102bf7:	90                   	nop
        for (struct Page *p = page; p != (page + n); ++p) 
  102bf8:	83 45 ec 14          	addl   $0x14,-0x14(%ebp)
  102bfc:	8b 55 08             	mov    0x8(%ebp),%edx
  102bff:	89 d0                	mov    %edx,%eax
  102c01:	c1 e0 02             	shl    $0x2,%eax
  102c04:	01 d0                	add    %edx,%eax
  102c06:	c1 e0 02             	shl    $0x2,%eax
  102c09:	89 c2                	mov    %eax,%edx
  102c0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c0e:	01 d0                	add    %edx,%eax
  102c10:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  102c13:	75 c9                	jne    102bde <default_alloc_pages+0x9a>
        }
        if (page->property > n) { // 如果原先找到的空闲块大小大于需要的分配内存大小，进行分裂
  102c15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c18:	8b 40 08             	mov    0x8(%eax),%eax
  102c1b:	39 45 08             	cmp    %eax,0x8(%ebp)
  102c1e:	0f 83 82 00 00 00    	jae    102ca6 <default_alloc_pages+0x162>
            struct Page *p = page + n; // 获得分裂出来的新的小空闲块的第一个页的描述信息
  102c24:	8b 55 08             	mov    0x8(%ebp),%edx
  102c27:	89 d0                	mov    %edx,%eax
  102c29:	c1 e0 02             	shl    $0x2,%eax
  102c2c:	01 d0                	add    %edx,%eax
  102c2e:	c1 e0 02             	shl    $0x2,%eax
  102c31:	89 c2                	mov    %eax,%edx
  102c33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c36:	01 d0                	add    %edx,%eax
  102c38:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            p->property = page->property - n; // 更新新的空闲块的大小信息
  102c3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c3e:	8b 40 08             	mov    0x8(%eax),%eax
  102c41:	2b 45 08             	sub    0x8(%ebp),%eax
  102c44:	89 c2                	mov    %eax,%edx
  102c46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102c49:	89 50 08             	mov    %edx,0x8(%eax)
            list_add(&(page->page_link), &(p->page_link)); // 将新空闲块插入空闲块列表中
  102c4c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102c4f:	83 c0 0c             	add    $0xc,%eax
  102c52:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102c55:	83 c2 0c             	add    $0xc,%edx
  102c58:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102c5b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102c5e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102c61:	89 45 cc             	mov    %eax,-0x34(%ebp)
  102c64:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102c67:	89 45 c8             	mov    %eax,-0x38(%ebp)
    __list_add(elm, listelm, listelm->next);
  102c6a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102c6d:	8b 40 04             	mov    0x4(%eax),%eax
  102c70:	8b 55 c8             	mov    -0x38(%ebp),%edx
  102c73:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  102c76:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102c79:	89 55 c0             	mov    %edx,-0x40(%ebp)
  102c7c:	89 45 bc             	mov    %eax,-0x44(%ebp)
    prev->next = next->prev = elm;
  102c7f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102c82:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102c85:	89 10                	mov    %edx,(%eax)
  102c87:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102c8a:	8b 10                	mov    (%eax),%edx
  102c8c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102c8f:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102c92:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102c95:	8b 55 bc             	mov    -0x44(%ebp),%edx
  102c98:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102c9b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102c9e:	8b 55 c0             	mov    -0x40(%ebp),%edx
  102ca1:	89 10                	mov    %edx,(%eax)
}
  102ca3:	90                   	nop
}
  102ca4:	90                   	nop
}
  102ca5:	90                   	nop
        }
        list_del(&(page->page_link)); // 删除空闲链表中的原先的空闲块
  102ca6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ca9:	83 c0 0c             	add    $0xc,%eax
  102cac:	89 45 b8             	mov    %eax,-0x48(%ebp)
    __list_del(listelm->prev, listelm->next);
  102caf:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102cb2:	8b 40 04             	mov    0x4(%eax),%eax
  102cb5:	8b 55 b8             	mov    -0x48(%ebp),%edx
  102cb8:	8b 12                	mov    (%edx),%edx
  102cba:	89 55 b4             	mov    %edx,-0x4c(%ebp)
  102cbd:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  102cc0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102cc3:	8b 55 b0             	mov    -0x50(%ebp),%edx
  102cc6:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102cc9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  102ccc:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  102ccf:	89 10                	mov    %edx,(%eax)
}
  102cd1:	90                   	nop
}
  102cd2:	90                   	nop
        nr_free -= n; // 更新总空闲物理页的数量
  102cd3:	a1 88 ce 11 00       	mov    0x11ce88,%eax
  102cd8:	2b 45 08             	sub    0x8(%ebp),%eax
  102cdb:	a3 88 ce 11 00       	mov    %eax,0x11ce88
    }
    return page;
  102ce0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102ce3:	89 ec                	mov    %ebp,%esp
  102ce5:	5d                   	pop    %ebp
  102ce6:	c3                   	ret    

00102ce7 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
  102ce7:	55                   	push   %ebp
  102ce8:	89 e5                	mov    %esp,%ebp
  102cea:	81 ec 98 00 00 00    	sub    $0x98,%esp
    assert(n > 0);
  102cf0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102cf4:	75 24                	jne    102d1a <default_free_pages+0x33>
  102cf6:	c7 44 24 0c 50 68 10 	movl   $0x106850,0xc(%esp)
  102cfd:	00 
  102cfe:	c7 44 24 08 56 68 10 	movl   $0x106856,0x8(%esp)
  102d05:	00 
  102d06:	c7 44 24 04 a4 00 00 	movl   $0xa4,0x4(%esp)
  102d0d:	00 
  102d0e:	c7 04 24 6b 68 10 00 	movl   $0x10686b,(%esp)
  102d15:	e8 c1 df ff ff       	call   100cdb <__panic>
    struct Page *p = base;
  102d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  102d1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  102d20:	e9 ad 00 00 00       	jmp    102dd2 <default_free_pages+0xeb>
        assert(!PageReserved(p) && !PageProperty(p));
  102d25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d28:	83 c0 04             	add    $0x4,%eax
  102d2b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  102d32:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102d35:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102d38:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102d3b:	0f a3 10             	bt     %edx,(%eax)
  102d3e:	19 c0                	sbb    %eax,%eax
  102d40:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
  102d43:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102d47:	0f 95 c0             	setne  %al
  102d4a:	0f b6 c0             	movzbl %al,%eax
  102d4d:	85 c0                	test   %eax,%eax
  102d4f:	75 2c                	jne    102d7d <default_free_pages+0x96>
  102d51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d54:	83 c0 04             	add    $0x4,%eax
  102d57:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  102d5e:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102d61:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102d64:	8b 55 e0             	mov    -0x20(%ebp),%edx
  102d67:	0f a3 10             	bt     %edx,(%eax)
  102d6a:	19 c0                	sbb    %eax,%eax
  102d6c:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
  102d6f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  102d73:	0f 95 c0             	setne  %al
  102d76:	0f b6 c0             	movzbl %al,%eax
  102d79:	85 c0                	test   %eax,%eax
  102d7b:	74 24                	je     102da1 <default_free_pages+0xba>
  102d7d:	c7 44 24 0c 94 68 10 	movl   $0x106894,0xc(%esp)
  102d84:	00 
  102d85:	c7 44 24 08 56 68 10 	movl   $0x106856,0x8(%esp)
  102d8c:	00 
  102d8d:	c7 44 24 04 a7 00 00 	movl   $0xa7,0x4(%esp)
  102d94:	00 
  102d95:	c7 04 24 6b 68 10 00 	movl   $0x10686b,(%esp)
  102d9c:	e8 3a df ff ff       	call   100cdb <__panic>
        //p->flags = 0;
        SetPageProperty(p);
  102da1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102da4:	83 c0 04             	add    $0x4,%eax
  102da7:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  102dae:	89 45 d0             	mov    %eax,-0x30(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102db1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102db4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102db7:	0f ab 10             	bts    %edx,(%eax)
}
  102dba:	90                   	nop
        set_page_ref(p, 0);
  102dbb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102dc2:	00 
  102dc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102dc6:	89 04 24             	mov    %eax,(%esp)
  102dc9:	e8 d2 fb ff ff       	call   1029a0 <set_page_ref>
    for (; p != base + n; p ++) {
  102dce:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  102dd2:	8b 55 0c             	mov    0xc(%ebp),%edx
  102dd5:	89 d0                	mov    %edx,%eax
  102dd7:	c1 e0 02             	shl    $0x2,%eax
  102dda:	01 d0                	add    %edx,%eax
  102ddc:	c1 e0 02             	shl    $0x2,%eax
  102ddf:	89 c2                	mov    %eax,%edx
  102de1:	8b 45 08             	mov    0x8(%ebp),%eax
  102de4:	01 d0                	add    %edx,%eax
  102de6:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  102de9:	0f 85 36 ff ff ff    	jne    102d25 <default_free_pages+0x3e>
    }
    base->property = n;
  102def:	8b 45 08             	mov    0x8(%ebp),%eax
  102df2:	8b 55 0c             	mov    0xc(%ebp),%edx
  102df5:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  102df8:	8b 45 08             	mov    0x8(%ebp),%eax
  102dfb:	83 c0 04             	add    $0x4,%eax
  102dfe:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  102e05:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102e08:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102e0b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  102e0e:	0f ab 10             	bts    %edx,(%eax)
}
  102e11:	90                   	nop
  102e12:	c7 45 cc 80 ce 11 00 	movl   $0x11ce80,-0x34(%ebp)
    return listelm->next;
  102e19:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102e1c:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
  102e1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
  102e22:	e9 0e 01 00 00       	jmp    102f35 <default_free_pages+0x24e>
        p = le2page(le, page_link);
  102e27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e2a:	83 e8 0c             	sub    $0xc,%eax
  102e2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102e30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e33:	89 45 c0             	mov    %eax,-0x40(%ebp)
  102e36:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102e39:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
  102e3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (base + base->property == p) {
  102e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  102e42:	8b 50 08             	mov    0x8(%eax),%edx
  102e45:	89 d0                	mov    %edx,%eax
  102e47:	c1 e0 02             	shl    $0x2,%eax
  102e4a:	01 d0                	add    %edx,%eax
  102e4c:	c1 e0 02             	shl    $0x2,%eax
  102e4f:	89 c2                	mov    %eax,%edx
  102e51:	8b 45 08             	mov    0x8(%ebp),%eax
  102e54:	01 d0                	add    %edx,%eax
  102e56:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  102e59:	75 5d                	jne    102eb8 <default_free_pages+0x1d1>
            base->property += p->property;
  102e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  102e5e:	8b 50 08             	mov    0x8(%eax),%edx
  102e61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e64:	8b 40 08             	mov    0x8(%eax),%eax
  102e67:	01 c2                	add    %eax,%edx
  102e69:	8b 45 08             	mov    0x8(%ebp),%eax
  102e6c:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
  102e6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e72:	83 c0 04             	add    $0x4,%eax
  102e75:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
  102e7c:	89 45 ac             	mov    %eax,-0x54(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102e7f:	8b 45 ac             	mov    -0x54(%ebp),%eax
  102e82:	8b 55 b0             	mov    -0x50(%ebp),%edx
  102e85:	0f b3 10             	btr    %edx,(%eax)
}
  102e88:	90                   	nop
            list_del(&(p->page_link));
  102e89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e8c:	83 c0 0c             	add    $0xc,%eax
  102e8f:	89 45 bc             	mov    %eax,-0x44(%ebp)
    __list_del(listelm->prev, listelm->next);
  102e92:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102e95:	8b 40 04             	mov    0x4(%eax),%eax
  102e98:	8b 55 bc             	mov    -0x44(%ebp),%edx
  102e9b:	8b 12                	mov    (%edx),%edx
  102e9d:	89 55 b8             	mov    %edx,-0x48(%ebp)
  102ea0:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    prev->next = next;
  102ea3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102ea6:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  102ea9:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102eac:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102eaf:	8b 55 b8             	mov    -0x48(%ebp),%edx
  102eb2:	89 10                	mov    %edx,(%eax)
}
  102eb4:	90                   	nop
}
  102eb5:	90                   	nop
  102eb6:	eb 7d                	jmp    102f35 <default_free_pages+0x24e>
        }
        else if (p + p->property == base) {
  102eb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ebb:	8b 50 08             	mov    0x8(%eax),%edx
  102ebe:	89 d0                	mov    %edx,%eax
  102ec0:	c1 e0 02             	shl    $0x2,%eax
  102ec3:	01 d0                	add    %edx,%eax
  102ec5:	c1 e0 02             	shl    $0x2,%eax
  102ec8:	89 c2                	mov    %eax,%edx
  102eca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ecd:	01 d0                	add    %edx,%eax
  102ecf:	39 45 08             	cmp    %eax,0x8(%ebp)
  102ed2:	75 61                	jne    102f35 <default_free_pages+0x24e>
            p->property += base->property;
  102ed4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ed7:	8b 50 08             	mov    0x8(%eax),%edx
  102eda:	8b 45 08             	mov    0x8(%ebp),%eax
  102edd:	8b 40 08             	mov    0x8(%eax),%eax
  102ee0:	01 c2                	add    %eax,%edx
  102ee2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ee5:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
  102ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  102eeb:	83 c0 04             	add    $0x4,%eax
  102eee:	c7 45 9c 01 00 00 00 	movl   $0x1,-0x64(%ebp)
  102ef5:	89 45 98             	mov    %eax,-0x68(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102ef8:	8b 45 98             	mov    -0x68(%ebp),%eax
  102efb:	8b 55 9c             	mov    -0x64(%ebp),%edx
  102efe:	0f b3 10             	btr    %edx,(%eax)
}
  102f01:	90                   	nop
            base = p;
  102f02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f05:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
  102f08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f0b:	83 c0 0c             	add    $0xc,%eax
  102f0e:	89 45 a8             	mov    %eax,-0x58(%ebp)
    __list_del(listelm->prev, listelm->next);
  102f11:	8b 45 a8             	mov    -0x58(%ebp),%eax
  102f14:	8b 40 04             	mov    0x4(%eax),%eax
  102f17:	8b 55 a8             	mov    -0x58(%ebp),%edx
  102f1a:	8b 12                	mov    (%edx),%edx
  102f1c:	89 55 a4             	mov    %edx,-0x5c(%ebp)
  102f1f:	89 45 a0             	mov    %eax,-0x60(%ebp)
    prev->next = next;
  102f22:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  102f25:	8b 55 a0             	mov    -0x60(%ebp),%edx
  102f28:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102f2b:	8b 45 a0             	mov    -0x60(%ebp),%eax
  102f2e:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  102f31:	89 10                	mov    %edx,(%eax)
}
  102f33:	90                   	nop
}
  102f34:	90                   	nop
    while (le != &free_list) {
  102f35:	81 7d f0 80 ce 11 00 	cmpl   $0x11ce80,-0x10(%ebp)
  102f3c:	0f 85 e5 fe ff ff    	jne    102e27 <default_free_pages+0x140>
        }
    }
    nr_free += n;
  102f42:	8b 15 88 ce 11 00    	mov    0x11ce88,%edx
  102f48:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f4b:	01 d0                	add    %edx,%eax
  102f4d:	a3 88 ce 11 00       	mov    %eax,0x11ce88
  102f52:	c7 45 94 80 ce 11 00 	movl   $0x11ce80,-0x6c(%ebp)
    return listelm->next;
  102f59:	8b 45 94             	mov    -0x6c(%ebp),%eax
  102f5c:	8b 40 04             	mov    0x4(%eax),%eax
    le = list_next(&free_list);
  102f5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    // 迭代空闲链表中的每一个节点
    while (le != &free_list) {
  102f62:	eb 74                	jmp    102fd8 <default_free_pages+0x2f1>
        // 转为Page结构
        p = le2page(le, page_link);
  102f64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f67:	83 e8 0c             	sub    $0xc,%eax
  102f6a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (base + base->property <= p) {
  102f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  102f70:	8b 50 08             	mov    0x8(%eax),%edx
  102f73:	89 d0                	mov    %edx,%eax
  102f75:	c1 e0 02             	shl    $0x2,%eax
  102f78:	01 d0                	add    %edx,%eax
  102f7a:	c1 e0 02             	shl    $0x2,%eax
  102f7d:	89 c2                	mov    %eax,%edx
  102f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  102f82:	01 d0                	add    %edx,%eax
  102f84:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  102f87:	72 40                	jb     102fc9 <default_free_pages+0x2e2>
            // 进行空闲链表结构的校验，不能存在交叉覆盖的地方
            assert(base + base->property != p);
  102f89:	8b 45 08             	mov    0x8(%ebp),%eax
  102f8c:	8b 50 08             	mov    0x8(%eax),%edx
  102f8f:	89 d0                	mov    %edx,%eax
  102f91:	c1 e0 02             	shl    $0x2,%eax
  102f94:	01 d0                	add    %edx,%eax
  102f96:	c1 e0 02             	shl    $0x2,%eax
  102f99:	89 c2                	mov    %eax,%edx
  102f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  102f9e:	01 d0                	add    %edx,%eax
  102fa0:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  102fa3:	75 3e                	jne    102fe3 <default_free_pages+0x2fc>
  102fa5:	c7 44 24 0c b9 68 10 	movl   $0x1068b9,0xc(%esp)
  102fac:	00 
  102fad:	c7 44 24 08 56 68 10 	movl   $0x106856,0x8(%esp)
  102fb4:	00 
  102fb5:	c7 44 24 04 c6 00 00 	movl   $0xc6,0x4(%esp)
  102fbc:	00 
  102fbd:	c7 04 24 6b 68 10 00 	movl   $0x10686b,(%esp)
  102fc4:	e8 12 dd ff ff       	call   100cdb <__panic>
  102fc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102fcc:	89 45 90             	mov    %eax,-0x70(%ebp)
  102fcf:	8b 45 90             	mov    -0x70(%ebp),%eax
  102fd2:	8b 40 04             	mov    0x4(%eax),%eax
            break;
        }
        le = list_next(le);
  102fd5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
  102fd8:	81 7d f0 80 ce 11 00 	cmpl   $0x11ce80,-0x10(%ebp)
  102fdf:	75 83                	jne    102f64 <default_free_pages+0x27d>
  102fe1:	eb 01                	jmp    102fe4 <default_free_pages+0x2fd>
            break;
  102fe3:	90                   	nop
    }
    // 将base加入到空闲链表之中
    list_add_before(le, &(base->page_link));
  102fe4:	8b 45 08             	mov    0x8(%ebp),%eax
  102fe7:	8d 50 0c             	lea    0xc(%eax),%edx
  102fea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102fed:	89 45 8c             	mov    %eax,-0x74(%ebp)
  102ff0:	89 55 88             	mov    %edx,-0x78(%ebp)
    __list_add(elm, listelm->prev, listelm);
  102ff3:	8b 45 8c             	mov    -0x74(%ebp),%eax
  102ff6:	8b 00                	mov    (%eax),%eax
  102ff8:	8b 55 88             	mov    -0x78(%ebp),%edx
  102ffb:	89 55 84             	mov    %edx,-0x7c(%ebp)
  102ffe:	89 45 80             	mov    %eax,-0x80(%ebp)
  103001:	8b 45 8c             	mov    -0x74(%ebp),%eax
  103004:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
    prev->next = next->prev = elm;
  10300a:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  103010:	8b 55 84             	mov    -0x7c(%ebp),%edx
  103013:	89 10                	mov    %edx,(%eax)
  103015:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  10301b:	8b 10                	mov    (%eax),%edx
  10301d:	8b 45 80             	mov    -0x80(%ebp),%eax
  103020:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  103023:	8b 45 84             	mov    -0x7c(%ebp),%eax
  103026:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
  10302c:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  10302f:	8b 45 84             	mov    -0x7c(%ebp),%eax
  103032:	8b 55 80             	mov    -0x80(%ebp),%edx
  103035:	89 10                	mov    %edx,(%eax)
}
  103037:	90                   	nop
}
  103038:	90                   	nop
}
  103039:	90                   	nop
  10303a:	89 ec                	mov    %ebp,%esp
  10303c:	5d                   	pop    %ebp
  10303d:	c3                   	ret    

0010303e <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
  10303e:	55                   	push   %ebp
  10303f:	89 e5                	mov    %esp,%ebp
    return nr_free;
  103041:	a1 88 ce 11 00       	mov    0x11ce88,%eax
}
  103046:	5d                   	pop    %ebp
  103047:	c3                   	ret    

00103048 <basic_check>:

static void
basic_check(void) {
  103048:	55                   	push   %ebp
  103049:	89 e5                	mov    %esp,%ebp
  10304b:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  10304e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103058:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10305b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10305e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  103061:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103068:	e8 ed 0e 00 00       	call   103f5a <alloc_pages>
  10306d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103070:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  103074:	75 24                	jne    10309a <basic_check+0x52>
  103076:	c7 44 24 0c d4 68 10 	movl   $0x1068d4,0xc(%esp)
  10307d:	00 
  10307e:	c7 44 24 08 56 68 10 	movl   $0x106856,0x8(%esp)
  103085:	00 
  103086:	c7 44 24 04 d8 00 00 	movl   $0xd8,0x4(%esp)
  10308d:	00 
  10308e:	c7 04 24 6b 68 10 00 	movl   $0x10686b,(%esp)
  103095:	e8 41 dc ff ff       	call   100cdb <__panic>
    assert((p1 = alloc_page()) != NULL);
  10309a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1030a1:	e8 b4 0e 00 00       	call   103f5a <alloc_pages>
  1030a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1030a9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1030ad:	75 24                	jne    1030d3 <basic_check+0x8b>
  1030af:	c7 44 24 0c f0 68 10 	movl   $0x1068f0,0xc(%esp)
  1030b6:	00 
  1030b7:	c7 44 24 08 56 68 10 	movl   $0x106856,0x8(%esp)
  1030be:	00 
  1030bf:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
  1030c6:	00 
  1030c7:	c7 04 24 6b 68 10 00 	movl   $0x10686b,(%esp)
  1030ce:	e8 08 dc ff ff       	call   100cdb <__panic>
    assert((p2 = alloc_page()) != NULL);
  1030d3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1030da:	e8 7b 0e 00 00       	call   103f5a <alloc_pages>
  1030df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1030e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1030e6:	75 24                	jne    10310c <basic_check+0xc4>
  1030e8:	c7 44 24 0c 0c 69 10 	movl   $0x10690c,0xc(%esp)
  1030ef:	00 
  1030f0:	c7 44 24 08 56 68 10 	movl   $0x106856,0x8(%esp)
  1030f7:	00 
  1030f8:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
  1030ff:	00 
  103100:	c7 04 24 6b 68 10 00 	movl   $0x10686b,(%esp)
  103107:	e8 cf db ff ff       	call   100cdb <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  10310c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10310f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  103112:	74 10                	je     103124 <basic_check+0xdc>
  103114:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103117:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  10311a:	74 08                	je     103124 <basic_check+0xdc>
  10311c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10311f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  103122:	75 24                	jne    103148 <basic_check+0x100>
  103124:	c7 44 24 0c 28 69 10 	movl   $0x106928,0xc(%esp)
  10312b:	00 
  10312c:	c7 44 24 08 56 68 10 	movl   $0x106856,0x8(%esp)
  103133:	00 
  103134:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
  10313b:	00 
  10313c:	c7 04 24 6b 68 10 00 	movl   $0x10686b,(%esp)
  103143:	e8 93 db ff ff       	call   100cdb <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  103148:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10314b:	89 04 24             	mov    %eax,(%esp)
  10314e:	e8 43 f8 ff ff       	call   102996 <page_ref>
  103153:	85 c0                	test   %eax,%eax
  103155:	75 1e                	jne    103175 <basic_check+0x12d>
  103157:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10315a:	89 04 24             	mov    %eax,(%esp)
  10315d:	e8 34 f8 ff ff       	call   102996 <page_ref>
  103162:	85 c0                	test   %eax,%eax
  103164:	75 0f                	jne    103175 <basic_check+0x12d>
  103166:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103169:	89 04 24             	mov    %eax,(%esp)
  10316c:	e8 25 f8 ff ff       	call   102996 <page_ref>
  103171:	85 c0                	test   %eax,%eax
  103173:	74 24                	je     103199 <basic_check+0x151>
  103175:	c7 44 24 0c 4c 69 10 	movl   $0x10694c,0xc(%esp)
  10317c:	00 
  10317d:	c7 44 24 08 56 68 10 	movl   $0x106856,0x8(%esp)
  103184:	00 
  103185:	c7 44 24 04 dd 00 00 	movl   $0xdd,0x4(%esp)
  10318c:	00 
  10318d:	c7 04 24 6b 68 10 00 	movl   $0x10686b,(%esp)
  103194:	e8 42 db ff ff       	call   100cdb <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  103199:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10319c:	89 04 24             	mov    %eax,(%esp)
  10319f:	e8 da f7 ff ff       	call   10297e <page2pa>
  1031a4:	8b 15 a4 ce 11 00    	mov    0x11cea4,%edx
  1031aa:	c1 e2 0c             	shl    $0xc,%edx
  1031ad:	39 d0                	cmp    %edx,%eax
  1031af:	72 24                	jb     1031d5 <basic_check+0x18d>
  1031b1:	c7 44 24 0c 88 69 10 	movl   $0x106988,0xc(%esp)
  1031b8:	00 
  1031b9:	c7 44 24 08 56 68 10 	movl   $0x106856,0x8(%esp)
  1031c0:	00 
  1031c1:	c7 44 24 04 df 00 00 	movl   $0xdf,0x4(%esp)
  1031c8:	00 
  1031c9:	c7 04 24 6b 68 10 00 	movl   $0x10686b,(%esp)
  1031d0:	e8 06 db ff ff       	call   100cdb <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  1031d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1031d8:	89 04 24             	mov    %eax,(%esp)
  1031db:	e8 9e f7 ff ff       	call   10297e <page2pa>
  1031e0:	8b 15 a4 ce 11 00    	mov    0x11cea4,%edx
  1031e6:	c1 e2 0c             	shl    $0xc,%edx
  1031e9:	39 d0                	cmp    %edx,%eax
  1031eb:	72 24                	jb     103211 <basic_check+0x1c9>
  1031ed:	c7 44 24 0c a5 69 10 	movl   $0x1069a5,0xc(%esp)
  1031f4:	00 
  1031f5:	c7 44 24 08 56 68 10 	movl   $0x106856,0x8(%esp)
  1031fc:	00 
  1031fd:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
  103204:	00 
  103205:	c7 04 24 6b 68 10 00 	movl   $0x10686b,(%esp)
  10320c:	e8 ca da ff ff       	call   100cdb <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  103211:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103214:	89 04 24             	mov    %eax,(%esp)
  103217:	e8 62 f7 ff ff       	call   10297e <page2pa>
  10321c:	8b 15 a4 ce 11 00    	mov    0x11cea4,%edx
  103222:	c1 e2 0c             	shl    $0xc,%edx
  103225:	39 d0                	cmp    %edx,%eax
  103227:	72 24                	jb     10324d <basic_check+0x205>
  103229:	c7 44 24 0c c2 69 10 	movl   $0x1069c2,0xc(%esp)
  103230:	00 
  103231:	c7 44 24 08 56 68 10 	movl   $0x106856,0x8(%esp)
  103238:	00 
  103239:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
  103240:	00 
  103241:	c7 04 24 6b 68 10 00 	movl   $0x10686b,(%esp)
  103248:	e8 8e da ff ff       	call   100cdb <__panic>

    list_entry_t free_list_store = free_list;
  10324d:	a1 80 ce 11 00       	mov    0x11ce80,%eax
  103252:	8b 15 84 ce 11 00    	mov    0x11ce84,%edx
  103258:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10325b:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  10325e:	c7 45 dc 80 ce 11 00 	movl   $0x11ce80,-0x24(%ebp)
    elm->prev = elm->next = elm;
  103265:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103268:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10326b:	89 50 04             	mov    %edx,0x4(%eax)
  10326e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103271:	8b 50 04             	mov    0x4(%eax),%edx
  103274:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103277:	89 10                	mov    %edx,(%eax)
}
  103279:	90                   	nop
  10327a:	c7 45 e0 80 ce 11 00 	movl   $0x11ce80,-0x20(%ebp)
    return list->next == list;
  103281:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103284:	8b 40 04             	mov    0x4(%eax),%eax
  103287:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  10328a:	0f 94 c0             	sete   %al
  10328d:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  103290:	85 c0                	test   %eax,%eax
  103292:	75 24                	jne    1032b8 <basic_check+0x270>
  103294:	c7 44 24 0c df 69 10 	movl   $0x1069df,0xc(%esp)
  10329b:	00 
  10329c:	c7 44 24 08 56 68 10 	movl   $0x106856,0x8(%esp)
  1032a3:	00 
  1032a4:	c7 44 24 04 e5 00 00 	movl   $0xe5,0x4(%esp)
  1032ab:	00 
  1032ac:	c7 04 24 6b 68 10 00 	movl   $0x10686b,(%esp)
  1032b3:	e8 23 da ff ff       	call   100cdb <__panic>

    unsigned int nr_free_store = nr_free;
  1032b8:	a1 88 ce 11 00       	mov    0x11ce88,%eax
  1032bd:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
  1032c0:	c7 05 88 ce 11 00 00 	movl   $0x0,0x11ce88
  1032c7:	00 00 00 

    assert(alloc_page() == NULL);
  1032ca:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1032d1:	e8 84 0c 00 00       	call   103f5a <alloc_pages>
  1032d6:	85 c0                	test   %eax,%eax
  1032d8:	74 24                	je     1032fe <basic_check+0x2b6>
  1032da:	c7 44 24 0c f6 69 10 	movl   $0x1069f6,0xc(%esp)
  1032e1:	00 
  1032e2:	c7 44 24 08 56 68 10 	movl   $0x106856,0x8(%esp)
  1032e9:	00 
  1032ea:	c7 44 24 04 ea 00 00 	movl   $0xea,0x4(%esp)
  1032f1:	00 
  1032f2:	c7 04 24 6b 68 10 00 	movl   $0x10686b,(%esp)
  1032f9:	e8 dd d9 ff ff       	call   100cdb <__panic>

    free_page(p0);
  1032fe:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103305:	00 
  103306:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103309:	89 04 24             	mov    %eax,(%esp)
  10330c:	e8 83 0c 00 00       	call   103f94 <free_pages>
    free_page(p1);
  103311:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103318:	00 
  103319:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10331c:	89 04 24             	mov    %eax,(%esp)
  10331f:	e8 70 0c 00 00       	call   103f94 <free_pages>
    free_page(p2);
  103324:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10332b:	00 
  10332c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10332f:	89 04 24             	mov    %eax,(%esp)
  103332:	e8 5d 0c 00 00       	call   103f94 <free_pages>
    assert(nr_free == 3);
  103337:	a1 88 ce 11 00       	mov    0x11ce88,%eax
  10333c:	83 f8 03             	cmp    $0x3,%eax
  10333f:	74 24                	je     103365 <basic_check+0x31d>
  103341:	c7 44 24 0c 0b 6a 10 	movl   $0x106a0b,0xc(%esp)
  103348:	00 
  103349:	c7 44 24 08 56 68 10 	movl   $0x106856,0x8(%esp)
  103350:	00 
  103351:	c7 44 24 04 ef 00 00 	movl   $0xef,0x4(%esp)
  103358:	00 
  103359:	c7 04 24 6b 68 10 00 	movl   $0x10686b,(%esp)
  103360:	e8 76 d9 ff ff       	call   100cdb <__panic>

    assert((p0 = alloc_page()) != NULL);
  103365:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10336c:	e8 e9 0b 00 00       	call   103f5a <alloc_pages>
  103371:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103374:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  103378:	75 24                	jne    10339e <basic_check+0x356>
  10337a:	c7 44 24 0c d4 68 10 	movl   $0x1068d4,0xc(%esp)
  103381:	00 
  103382:	c7 44 24 08 56 68 10 	movl   $0x106856,0x8(%esp)
  103389:	00 
  10338a:	c7 44 24 04 f1 00 00 	movl   $0xf1,0x4(%esp)
  103391:	00 
  103392:	c7 04 24 6b 68 10 00 	movl   $0x10686b,(%esp)
  103399:	e8 3d d9 ff ff       	call   100cdb <__panic>
    assert((p1 = alloc_page()) != NULL);
  10339e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1033a5:	e8 b0 0b 00 00       	call   103f5a <alloc_pages>
  1033aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1033ad:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1033b1:	75 24                	jne    1033d7 <basic_check+0x38f>
  1033b3:	c7 44 24 0c f0 68 10 	movl   $0x1068f0,0xc(%esp)
  1033ba:	00 
  1033bb:	c7 44 24 08 56 68 10 	movl   $0x106856,0x8(%esp)
  1033c2:	00 
  1033c3:	c7 44 24 04 f2 00 00 	movl   $0xf2,0x4(%esp)
  1033ca:	00 
  1033cb:	c7 04 24 6b 68 10 00 	movl   $0x10686b,(%esp)
  1033d2:	e8 04 d9 ff ff       	call   100cdb <__panic>
    assert((p2 = alloc_page()) != NULL);
  1033d7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1033de:	e8 77 0b 00 00       	call   103f5a <alloc_pages>
  1033e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1033e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1033ea:	75 24                	jne    103410 <basic_check+0x3c8>
  1033ec:	c7 44 24 0c 0c 69 10 	movl   $0x10690c,0xc(%esp)
  1033f3:	00 
  1033f4:	c7 44 24 08 56 68 10 	movl   $0x106856,0x8(%esp)
  1033fb:	00 
  1033fc:	c7 44 24 04 f3 00 00 	movl   $0xf3,0x4(%esp)
  103403:	00 
  103404:	c7 04 24 6b 68 10 00 	movl   $0x10686b,(%esp)
  10340b:	e8 cb d8 ff ff       	call   100cdb <__panic>

    assert(alloc_page() == NULL);
  103410:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103417:	e8 3e 0b 00 00       	call   103f5a <alloc_pages>
  10341c:	85 c0                	test   %eax,%eax
  10341e:	74 24                	je     103444 <basic_check+0x3fc>
  103420:	c7 44 24 0c f6 69 10 	movl   $0x1069f6,0xc(%esp)
  103427:	00 
  103428:	c7 44 24 08 56 68 10 	movl   $0x106856,0x8(%esp)
  10342f:	00 
  103430:	c7 44 24 04 f5 00 00 	movl   $0xf5,0x4(%esp)
  103437:	00 
  103438:	c7 04 24 6b 68 10 00 	movl   $0x10686b,(%esp)
  10343f:	e8 97 d8 ff ff       	call   100cdb <__panic>

    free_page(p0);
  103444:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10344b:	00 
  10344c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10344f:	89 04 24             	mov    %eax,(%esp)
  103452:	e8 3d 0b 00 00       	call   103f94 <free_pages>
  103457:	c7 45 d8 80 ce 11 00 	movl   $0x11ce80,-0x28(%ebp)
  10345e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103461:	8b 40 04             	mov    0x4(%eax),%eax
  103464:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  103467:	0f 94 c0             	sete   %al
  10346a:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  10346d:	85 c0                	test   %eax,%eax
  10346f:	74 24                	je     103495 <basic_check+0x44d>
  103471:	c7 44 24 0c 18 6a 10 	movl   $0x106a18,0xc(%esp)
  103478:	00 
  103479:	c7 44 24 08 56 68 10 	movl   $0x106856,0x8(%esp)
  103480:	00 
  103481:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
  103488:	00 
  103489:	c7 04 24 6b 68 10 00 	movl   $0x10686b,(%esp)
  103490:	e8 46 d8 ff ff       	call   100cdb <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  103495:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10349c:	e8 b9 0a 00 00       	call   103f5a <alloc_pages>
  1034a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1034a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1034a7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1034aa:	74 24                	je     1034d0 <basic_check+0x488>
  1034ac:	c7 44 24 0c 30 6a 10 	movl   $0x106a30,0xc(%esp)
  1034b3:	00 
  1034b4:	c7 44 24 08 56 68 10 	movl   $0x106856,0x8(%esp)
  1034bb:	00 
  1034bc:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
  1034c3:	00 
  1034c4:	c7 04 24 6b 68 10 00 	movl   $0x10686b,(%esp)
  1034cb:	e8 0b d8 ff ff       	call   100cdb <__panic>
    assert(alloc_page() == NULL);
  1034d0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1034d7:	e8 7e 0a 00 00       	call   103f5a <alloc_pages>
  1034dc:	85 c0                	test   %eax,%eax
  1034de:	74 24                	je     103504 <basic_check+0x4bc>
  1034e0:	c7 44 24 0c f6 69 10 	movl   $0x1069f6,0xc(%esp)
  1034e7:	00 
  1034e8:	c7 44 24 08 56 68 10 	movl   $0x106856,0x8(%esp)
  1034ef:	00 
  1034f0:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
  1034f7:	00 
  1034f8:	c7 04 24 6b 68 10 00 	movl   $0x10686b,(%esp)
  1034ff:	e8 d7 d7 ff ff       	call   100cdb <__panic>

    assert(nr_free == 0);
  103504:	a1 88 ce 11 00       	mov    0x11ce88,%eax
  103509:	85 c0                	test   %eax,%eax
  10350b:	74 24                	je     103531 <basic_check+0x4e9>
  10350d:	c7 44 24 0c 49 6a 10 	movl   $0x106a49,0xc(%esp)
  103514:	00 
  103515:	c7 44 24 08 56 68 10 	movl   $0x106856,0x8(%esp)
  10351c:	00 
  10351d:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
  103524:	00 
  103525:	c7 04 24 6b 68 10 00 	movl   $0x10686b,(%esp)
  10352c:	e8 aa d7 ff ff       	call   100cdb <__panic>
    free_list = free_list_store;
  103531:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103534:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103537:	a3 80 ce 11 00       	mov    %eax,0x11ce80
  10353c:	89 15 84 ce 11 00    	mov    %edx,0x11ce84
    nr_free = nr_free_store;
  103542:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103545:	a3 88 ce 11 00       	mov    %eax,0x11ce88

    free_page(p);
  10354a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103551:	00 
  103552:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103555:	89 04 24             	mov    %eax,(%esp)
  103558:	e8 37 0a 00 00       	call   103f94 <free_pages>
    free_page(p1);
  10355d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103564:	00 
  103565:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103568:	89 04 24             	mov    %eax,(%esp)
  10356b:	e8 24 0a 00 00       	call   103f94 <free_pages>
    free_page(p2);
  103570:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103577:	00 
  103578:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10357b:	89 04 24             	mov    %eax,(%esp)
  10357e:	e8 11 0a 00 00       	call   103f94 <free_pages>
}
  103583:	90                   	nop
  103584:	89 ec                	mov    %ebp,%esp
  103586:	5d                   	pop    %ebp
  103587:	c3                   	ret    

00103588 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
  103588:	55                   	push   %ebp
  103589:	89 e5                	mov    %esp,%ebp
  10358b:	81 ec 98 00 00 00    	sub    $0x98,%esp
    int count = 0, total = 0;
  103591:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103598:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  10359f:	c7 45 ec 80 ce 11 00 	movl   $0x11ce80,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  1035a6:	eb 6a                	jmp    103612 <default_check+0x8a>
        struct Page *p = le2page(le, page_link);
  1035a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1035ab:	83 e8 0c             	sub    $0xc,%eax
  1035ae:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(PageProperty(p));
  1035b1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1035b4:	83 c0 04             	add    $0x4,%eax
  1035b7:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  1035be:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1035c1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1035c4:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1035c7:	0f a3 10             	bt     %edx,(%eax)
  1035ca:	19 c0                	sbb    %eax,%eax
  1035cc:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  1035cf:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  1035d3:	0f 95 c0             	setne  %al
  1035d6:	0f b6 c0             	movzbl %al,%eax
  1035d9:	85 c0                	test   %eax,%eax
  1035db:	75 24                	jne    103601 <default_check+0x79>
  1035dd:	c7 44 24 0c 56 6a 10 	movl   $0x106a56,0xc(%esp)
  1035e4:	00 
  1035e5:	c7 44 24 08 56 68 10 	movl   $0x106856,0x8(%esp)
  1035ec:	00 
  1035ed:	c7 44 24 04 0f 01 00 	movl   $0x10f,0x4(%esp)
  1035f4:	00 
  1035f5:	c7 04 24 6b 68 10 00 	movl   $0x10686b,(%esp)
  1035fc:	e8 da d6 ff ff       	call   100cdb <__panic>
        count ++, total += p->property;
  103601:	ff 45 f4             	incl   -0xc(%ebp)
  103604:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  103607:	8b 50 08             	mov    0x8(%eax),%edx
  10360a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10360d:	01 d0                	add    %edx,%eax
  10360f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103612:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103615:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
  103618:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  10361b:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  10361e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103621:	81 7d ec 80 ce 11 00 	cmpl   $0x11ce80,-0x14(%ebp)
  103628:	0f 85 7a ff ff ff    	jne    1035a8 <default_check+0x20>
    }
    assert(total == nr_free_pages());
  10362e:	e8 96 09 00 00       	call   103fc9 <nr_free_pages>
  103633:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103636:	39 d0                	cmp    %edx,%eax
  103638:	74 24                	je     10365e <default_check+0xd6>
  10363a:	c7 44 24 0c 66 6a 10 	movl   $0x106a66,0xc(%esp)
  103641:	00 
  103642:	c7 44 24 08 56 68 10 	movl   $0x106856,0x8(%esp)
  103649:	00 
  10364a:	c7 44 24 04 12 01 00 	movl   $0x112,0x4(%esp)
  103651:	00 
  103652:	c7 04 24 6b 68 10 00 	movl   $0x10686b,(%esp)
  103659:	e8 7d d6 ff ff       	call   100cdb <__panic>

    basic_check();
  10365e:	e8 e5 f9 ff ff       	call   103048 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  103663:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  10366a:	e8 eb 08 00 00       	call   103f5a <alloc_pages>
  10366f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(p0 != NULL);
  103672:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103676:	75 24                	jne    10369c <default_check+0x114>
  103678:	c7 44 24 0c 7f 6a 10 	movl   $0x106a7f,0xc(%esp)
  10367f:	00 
  103680:	c7 44 24 08 56 68 10 	movl   $0x106856,0x8(%esp)
  103687:	00 
  103688:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
  10368f:	00 
  103690:	c7 04 24 6b 68 10 00 	movl   $0x10686b,(%esp)
  103697:	e8 3f d6 ff ff       	call   100cdb <__panic>
    assert(!PageProperty(p0));
  10369c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10369f:	83 c0 04             	add    $0x4,%eax
  1036a2:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  1036a9:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1036ac:	8b 45 bc             	mov    -0x44(%ebp),%eax
  1036af:	8b 55 c0             	mov    -0x40(%ebp),%edx
  1036b2:	0f a3 10             	bt     %edx,(%eax)
  1036b5:	19 c0                	sbb    %eax,%eax
  1036b7:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  1036ba:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  1036be:	0f 95 c0             	setne  %al
  1036c1:	0f b6 c0             	movzbl %al,%eax
  1036c4:	85 c0                	test   %eax,%eax
  1036c6:	74 24                	je     1036ec <default_check+0x164>
  1036c8:	c7 44 24 0c 8a 6a 10 	movl   $0x106a8a,0xc(%esp)
  1036cf:	00 
  1036d0:	c7 44 24 08 56 68 10 	movl   $0x106856,0x8(%esp)
  1036d7:	00 
  1036d8:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
  1036df:	00 
  1036e0:	c7 04 24 6b 68 10 00 	movl   $0x10686b,(%esp)
  1036e7:	e8 ef d5 ff ff       	call   100cdb <__panic>

    list_entry_t free_list_store = free_list;
  1036ec:	a1 80 ce 11 00       	mov    0x11ce80,%eax
  1036f1:	8b 15 84 ce 11 00    	mov    0x11ce84,%edx
  1036f7:	89 45 80             	mov    %eax,-0x80(%ebp)
  1036fa:	89 55 84             	mov    %edx,-0x7c(%ebp)
  1036fd:	c7 45 b0 80 ce 11 00 	movl   $0x11ce80,-0x50(%ebp)
    elm->prev = elm->next = elm;
  103704:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103707:	8b 55 b0             	mov    -0x50(%ebp),%edx
  10370a:	89 50 04             	mov    %edx,0x4(%eax)
  10370d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103710:	8b 50 04             	mov    0x4(%eax),%edx
  103713:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103716:	89 10                	mov    %edx,(%eax)
}
  103718:	90                   	nop
  103719:	c7 45 b4 80 ce 11 00 	movl   $0x11ce80,-0x4c(%ebp)
    return list->next == list;
  103720:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103723:	8b 40 04             	mov    0x4(%eax),%eax
  103726:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
  103729:	0f 94 c0             	sete   %al
  10372c:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  10372f:	85 c0                	test   %eax,%eax
  103731:	75 24                	jne    103757 <default_check+0x1cf>
  103733:	c7 44 24 0c df 69 10 	movl   $0x1069df,0xc(%esp)
  10373a:	00 
  10373b:	c7 44 24 08 56 68 10 	movl   $0x106856,0x8(%esp)
  103742:	00 
  103743:	c7 44 24 04 1c 01 00 	movl   $0x11c,0x4(%esp)
  10374a:	00 
  10374b:	c7 04 24 6b 68 10 00 	movl   $0x10686b,(%esp)
  103752:	e8 84 d5 ff ff       	call   100cdb <__panic>
    assert(alloc_page() == NULL);
  103757:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10375e:	e8 f7 07 00 00       	call   103f5a <alloc_pages>
  103763:	85 c0                	test   %eax,%eax
  103765:	74 24                	je     10378b <default_check+0x203>
  103767:	c7 44 24 0c f6 69 10 	movl   $0x1069f6,0xc(%esp)
  10376e:	00 
  10376f:	c7 44 24 08 56 68 10 	movl   $0x106856,0x8(%esp)
  103776:	00 
  103777:	c7 44 24 04 1d 01 00 	movl   $0x11d,0x4(%esp)
  10377e:	00 
  10377f:	c7 04 24 6b 68 10 00 	movl   $0x10686b,(%esp)
  103786:	e8 50 d5 ff ff       	call   100cdb <__panic>

    unsigned int nr_free_store = nr_free;
  10378b:	a1 88 ce 11 00       	mov    0x11ce88,%eax
  103790:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nr_free = 0;
  103793:	c7 05 88 ce 11 00 00 	movl   $0x0,0x11ce88
  10379a:	00 00 00 

    free_pages(p0 + 2, 3);
  10379d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1037a0:	83 c0 28             	add    $0x28,%eax
  1037a3:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  1037aa:	00 
  1037ab:	89 04 24             	mov    %eax,(%esp)
  1037ae:	e8 e1 07 00 00       	call   103f94 <free_pages>
    assert(alloc_pages(4) == NULL);
  1037b3:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  1037ba:	e8 9b 07 00 00       	call   103f5a <alloc_pages>
  1037bf:	85 c0                	test   %eax,%eax
  1037c1:	74 24                	je     1037e7 <default_check+0x25f>
  1037c3:	c7 44 24 0c 9c 6a 10 	movl   $0x106a9c,0xc(%esp)
  1037ca:	00 
  1037cb:	c7 44 24 08 56 68 10 	movl   $0x106856,0x8(%esp)
  1037d2:	00 
  1037d3:	c7 44 24 04 23 01 00 	movl   $0x123,0x4(%esp)
  1037da:	00 
  1037db:	c7 04 24 6b 68 10 00 	movl   $0x10686b,(%esp)
  1037e2:	e8 f4 d4 ff ff       	call   100cdb <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  1037e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1037ea:	83 c0 28             	add    $0x28,%eax
  1037ed:	83 c0 04             	add    $0x4,%eax
  1037f0:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  1037f7:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1037fa:	8b 45 a8             	mov    -0x58(%ebp),%eax
  1037fd:	8b 55 ac             	mov    -0x54(%ebp),%edx
  103800:	0f a3 10             	bt     %edx,(%eax)
  103803:	19 c0                	sbb    %eax,%eax
  103805:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
  103808:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  10380c:	0f 95 c0             	setne  %al
  10380f:	0f b6 c0             	movzbl %al,%eax
  103812:	85 c0                	test   %eax,%eax
  103814:	74 0e                	je     103824 <default_check+0x29c>
  103816:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103819:	83 c0 28             	add    $0x28,%eax
  10381c:	8b 40 08             	mov    0x8(%eax),%eax
  10381f:	83 f8 03             	cmp    $0x3,%eax
  103822:	74 24                	je     103848 <default_check+0x2c0>
  103824:	c7 44 24 0c b4 6a 10 	movl   $0x106ab4,0xc(%esp)
  10382b:	00 
  10382c:	c7 44 24 08 56 68 10 	movl   $0x106856,0x8(%esp)
  103833:	00 
  103834:	c7 44 24 04 24 01 00 	movl   $0x124,0x4(%esp)
  10383b:	00 
  10383c:	c7 04 24 6b 68 10 00 	movl   $0x10686b,(%esp)
  103843:	e8 93 d4 ff ff       	call   100cdb <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  103848:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  10384f:	e8 06 07 00 00       	call   103f5a <alloc_pages>
  103854:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103857:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  10385b:	75 24                	jne    103881 <default_check+0x2f9>
  10385d:	c7 44 24 0c e0 6a 10 	movl   $0x106ae0,0xc(%esp)
  103864:	00 
  103865:	c7 44 24 08 56 68 10 	movl   $0x106856,0x8(%esp)
  10386c:	00 
  10386d:	c7 44 24 04 25 01 00 	movl   $0x125,0x4(%esp)
  103874:	00 
  103875:	c7 04 24 6b 68 10 00 	movl   $0x10686b,(%esp)
  10387c:	e8 5a d4 ff ff       	call   100cdb <__panic>
    assert(alloc_page() == NULL);
  103881:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103888:	e8 cd 06 00 00       	call   103f5a <alloc_pages>
  10388d:	85 c0                	test   %eax,%eax
  10388f:	74 24                	je     1038b5 <default_check+0x32d>
  103891:	c7 44 24 0c f6 69 10 	movl   $0x1069f6,0xc(%esp)
  103898:	00 
  103899:	c7 44 24 08 56 68 10 	movl   $0x106856,0x8(%esp)
  1038a0:	00 
  1038a1:	c7 44 24 04 26 01 00 	movl   $0x126,0x4(%esp)
  1038a8:	00 
  1038a9:	c7 04 24 6b 68 10 00 	movl   $0x10686b,(%esp)
  1038b0:	e8 26 d4 ff ff       	call   100cdb <__panic>
    assert(p0 + 2 == p1);
  1038b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1038b8:	83 c0 28             	add    $0x28,%eax
  1038bb:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  1038be:	74 24                	je     1038e4 <default_check+0x35c>
  1038c0:	c7 44 24 0c fe 6a 10 	movl   $0x106afe,0xc(%esp)
  1038c7:	00 
  1038c8:	c7 44 24 08 56 68 10 	movl   $0x106856,0x8(%esp)
  1038cf:	00 
  1038d0:	c7 44 24 04 27 01 00 	movl   $0x127,0x4(%esp)
  1038d7:	00 
  1038d8:	c7 04 24 6b 68 10 00 	movl   $0x10686b,(%esp)
  1038df:	e8 f7 d3 ff ff       	call   100cdb <__panic>

    p2 = p0 + 1;
  1038e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1038e7:	83 c0 14             	add    $0x14,%eax
  1038ea:	89 45 dc             	mov    %eax,-0x24(%ebp)
    free_page(p0);
  1038ed:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1038f4:	00 
  1038f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1038f8:	89 04 24             	mov    %eax,(%esp)
  1038fb:	e8 94 06 00 00       	call   103f94 <free_pages>
    free_pages(p1, 3);
  103900:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  103907:	00 
  103908:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10390b:	89 04 24             	mov    %eax,(%esp)
  10390e:	e8 81 06 00 00       	call   103f94 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
  103913:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103916:	83 c0 04             	add    $0x4,%eax
  103919:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  103920:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103923:	8b 45 9c             	mov    -0x64(%ebp),%eax
  103926:	8b 55 a0             	mov    -0x60(%ebp),%edx
  103929:	0f a3 10             	bt     %edx,(%eax)
  10392c:	19 c0                	sbb    %eax,%eax
  10392e:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  103931:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  103935:	0f 95 c0             	setne  %al
  103938:	0f b6 c0             	movzbl %al,%eax
  10393b:	85 c0                	test   %eax,%eax
  10393d:	74 0b                	je     10394a <default_check+0x3c2>
  10393f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103942:	8b 40 08             	mov    0x8(%eax),%eax
  103945:	83 f8 01             	cmp    $0x1,%eax
  103948:	74 24                	je     10396e <default_check+0x3e6>
  10394a:	c7 44 24 0c 0c 6b 10 	movl   $0x106b0c,0xc(%esp)
  103951:	00 
  103952:	c7 44 24 08 56 68 10 	movl   $0x106856,0x8(%esp)
  103959:	00 
  10395a:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
  103961:	00 
  103962:	c7 04 24 6b 68 10 00 	movl   $0x10686b,(%esp)
  103969:	e8 6d d3 ff ff       	call   100cdb <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  10396e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103971:	83 c0 04             	add    $0x4,%eax
  103974:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  10397b:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10397e:	8b 45 90             	mov    -0x70(%ebp),%eax
  103981:	8b 55 94             	mov    -0x6c(%ebp),%edx
  103984:	0f a3 10             	bt     %edx,(%eax)
  103987:	19 c0                	sbb    %eax,%eax
  103989:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
  10398c:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  103990:	0f 95 c0             	setne  %al
  103993:	0f b6 c0             	movzbl %al,%eax
  103996:	85 c0                	test   %eax,%eax
  103998:	74 0b                	je     1039a5 <default_check+0x41d>
  10399a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10399d:	8b 40 08             	mov    0x8(%eax),%eax
  1039a0:	83 f8 03             	cmp    $0x3,%eax
  1039a3:	74 24                	je     1039c9 <default_check+0x441>
  1039a5:	c7 44 24 0c 34 6b 10 	movl   $0x106b34,0xc(%esp)
  1039ac:	00 
  1039ad:	c7 44 24 08 56 68 10 	movl   $0x106856,0x8(%esp)
  1039b4:	00 
  1039b5:	c7 44 24 04 2d 01 00 	movl   $0x12d,0x4(%esp)
  1039bc:	00 
  1039bd:	c7 04 24 6b 68 10 00 	movl   $0x10686b,(%esp)
  1039c4:	e8 12 d3 ff ff       	call   100cdb <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  1039c9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1039d0:	e8 85 05 00 00       	call   103f5a <alloc_pages>
  1039d5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1039d8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1039db:	83 e8 14             	sub    $0x14,%eax
  1039de:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  1039e1:	74 24                	je     103a07 <default_check+0x47f>
  1039e3:	c7 44 24 0c 5a 6b 10 	movl   $0x106b5a,0xc(%esp)
  1039ea:	00 
  1039eb:	c7 44 24 08 56 68 10 	movl   $0x106856,0x8(%esp)
  1039f2:	00 
  1039f3:	c7 44 24 04 2f 01 00 	movl   $0x12f,0x4(%esp)
  1039fa:	00 
  1039fb:	c7 04 24 6b 68 10 00 	movl   $0x10686b,(%esp)
  103a02:	e8 d4 d2 ff ff       	call   100cdb <__panic>
    free_page(p0);
  103a07:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103a0e:	00 
  103a0f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103a12:	89 04 24             	mov    %eax,(%esp)
  103a15:	e8 7a 05 00 00       	call   103f94 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
  103a1a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  103a21:	e8 34 05 00 00       	call   103f5a <alloc_pages>
  103a26:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103a29:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103a2c:	83 c0 14             	add    $0x14,%eax
  103a2f:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  103a32:	74 24                	je     103a58 <default_check+0x4d0>
  103a34:	c7 44 24 0c 78 6b 10 	movl   $0x106b78,0xc(%esp)
  103a3b:	00 
  103a3c:	c7 44 24 08 56 68 10 	movl   $0x106856,0x8(%esp)
  103a43:	00 
  103a44:	c7 44 24 04 31 01 00 	movl   $0x131,0x4(%esp)
  103a4b:	00 
  103a4c:	c7 04 24 6b 68 10 00 	movl   $0x10686b,(%esp)
  103a53:	e8 83 d2 ff ff       	call   100cdb <__panic>

    free_pages(p0, 2);
  103a58:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  103a5f:	00 
  103a60:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103a63:	89 04 24             	mov    %eax,(%esp)
  103a66:	e8 29 05 00 00       	call   103f94 <free_pages>
    free_page(p2);
  103a6b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103a72:	00 
  103a73:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103a76:	89 04 24             	mov    %eax,(%esp)
  103a79:	e8 16 05 00 00       	call   103f94 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
  103a7e:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  103a85:	e8 d0 04 00 00       	call   103f5a <alloc_pages>
  103a8a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103a8d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103a91:	75 24                	jne    103ab7 <default_check+0x52f>
  103a93:	c7 44 24 0c 98 6b 10 	movl   $0x106b98,0xc(%esp)
  103a9a:	00 
  103a9b:	c7 44 24 08 56 68 10 	movl   $0x106856,0x8(%esp)
  103aa2:	00 
  103aa3:	c7 44 24 04 36 01 00 	movl   $0x136,0x4(%esp)
  103aaa:	00 
  103aab:	c7 04 24 6b 68 10 00 	movl   $0x10686b,(%esp)
  103ab2:	e8 24 d2 ff ff       	call   100cdb <__panic>
    assert(alloc_page() == NULL);
  103ab7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103abe:	e8 97 04 00 00       	call   103f5a <alloc_pages>
  103ac3:	85 c0                	test   %eax,%eax
  103ac5:	74 24                	je     103aeb <default_check+0x563>
  103ac7:	c7 44 24 0c f6 69 10 	movl   $0x1069f6,0xc(%esp)
  103ace:	00 
  103acf:	c7 44 24 08 56 68 10 	movl   $0x106856,0x8(%esp)
  103ad6:	00 
  103ad7:	c7 44 24 04 37 01 00 	movl   $0x137,0x4(%esp)
  103ade:	00 
  103adf:	c7 04 24 6b 68 10 00 	movl   $0x10686b,(%esp)
  103ae6:	e8 f0 d1 ff ff       	call   100cdb <__panic>

    assert(nr_free == 0);
  103aeb:	a1 88 ce 11 00       	mov    0x11ce88,%eax
  103af0:	85 c0                	test   %eax,%eax
  103af2:	74 24                	je     103b18 <default_check+0x590>
  103af4:	c7 44 24 0c 49 6a 10 	movl   $0x106a49,0xc(%esp)
  103afb:	00 
  103afc:	c7 44 24 08 56 68 10 	movl   $0x106856,0x8(%esp)
  103b03:	00 
  103b04:	c7 44 24 04 39 01 00 	movl   $0x139,0x4(%esp)
  103b0b:	00 
  103b0c:	c7 04 24 6b 68 10 00 	movl   $0x10686b,(%esp)
  103b13:	e8 c3 d1 ff ff       	call   100cdb <__panic>
    nr_free = nr_free_store;
  103b18:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103b1b:	a3 88 ce 11 00       	mov    %eax,0x11ce88

    free_list = free_list_store;
  103b20:	8b 45 80             	mov    -0x80(%ebp),%eax
  103b23:	8b 55 84             	mov    -0x7c(%ebp),%edx
  103b26:	a3 80 ce 11 00       	mov    %eax,0x11ce80
  103b2b:	89 15 84 ce 11 00    	mov    %edx,0x11ce84
    free_pages(p0, 5);
  103b31:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  103b38:	00 
  103b39:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103b3c:	89 04 24             	mov    %eax,(%esp)
  103b3f:	e8 50 04 00 00       	call   103f94 <free_pages>

    le = &free_list;
  103b44:	c7 45 ec 80 ce 11 00 	movl   $0x11ce80,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  103b4b:	eb 5a                	jmp    103ba7 <default_check+0x61f>
        assert(le->next->prev == le && le->prev->next == le);
  103b4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103b50:	8b 40 04             	mov    0x4(%eax),%eax
  103b53:	8b 00                	mov    (%eax),%eax
  103b55:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  103b58:	75 0d                	jne    103b67 <default_check+0x5df>
  103b5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103b5d:	8b 00                	mov    (%eax),%eax
  103b5f:	8b 40 04             	mov    0x4(%eax),%eax
  103b62:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  103b65:	74 24                	je     103b8b <default_check+0x603>
  103b67:	c7 44 24 0c b8 6b 10 	movl   $0x106bb8,0xc(%esp)
  103b6e:	00 
  103b6f:	c7 44 24 08 56 68 10 	movl   $0x106856,0x8(%esp)
  103b76:	00 
  103b77:	c7 44 24 04 41 01 00 	movl   $0x141,0x4(%esp)
  103b7e:	00 
  103b7f:	c7 04 24 6b 68 10 00 	movl   $0x10686b,(%esp)
  103b86:	e8 50 d1 ff ff       	call   100cdb <__panic>
        struct Page *p = le2page(le, page_link);
  103b8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103b8e:	83 e8 0c             	sub    $0xc,%eax
  103b91:	89 45 d8             	mov    %eax,-0x28(%ebp)
        count --, total -= p->property;
  103b94:	ff 4d f4             	decl   -0xc(%ebp)
  103b97:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103b9a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103b9d:	8b 48 08             	mov    0x8(%eax),%ecx
  103ba0:	89 d0                	mov    %edx,%eax
  103ba2:	29 c8                	sub    %ecx,%eax
  103ba4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103ba7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103baa:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
  103bad:	8b 45 88             	mov    -0x78(%ebp),%eax
  103bb0:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  103bb3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103bb6:	81 7d ec 80 ce 11 00 	cmpl   $0x11ce80,-0x14(%ebp)
  103bbd:	75 8e                	jne    103b4d <default_check+0x5c5>
    }
    assert(count == 0);
  103bbf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103bc3:	74 24                	je     103be9 <default_check+0x661>
  103bc5:	c7 44 24 0c e5 6b 10 	movl   $0x106be5,0xc(%esp)
  103bcc:	00 
  103bcd:	c7 44 24 08 56 68 10 	movl   $0x106856,0x8(%esp)
  103bd4:	00 
  103bd5:	c7 44 24 04 45 01 00 	movl   $0x145,0x4(%esp)
  103bdc:	00 
  103bdd:	c7 04 24 6b 68 10 00 	movl   $0x10686b,(%esp)
  103be4:	e8 f2 d0 ff ff       	call   100cdb <__panic>
    assert(total == 0);
  103be9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103bed:	74 24                	je     103c13 <default_check+0x68b>
  103bef:	c7 44 24 0c f0 6b 10 	movl   $0x106bf0,0xc(%esp)
  103bf6:	00 
  103bf7:	c7 44 24 08 56 68 10 	movl   $0x106856,0x8(%esp)
  103bfe:	00 
  103bff:	c7 44 24 04 46 01 00 	movl   $0x146,0x4(%esp)
  103c06:	00 
  103c07:	c7 04 24 6b 68 10 00 	movl   $0x10686b,(%esp)
  103c0e:	e8 c8 d0 ff ff       	call   100cdb <__panic>
}
  103c13:	90                   	nop
  103c14:	89 ec                	mov    %ebp,%esp
  103c16:	5d                   	pop    %ebp
  103c17:	c3                   	ret    

00103c18 <page2ppn>:
page2ppn(struct Page *page) {
  103c18:	55                   	push   %ebp
  103c19:	89 e5                	mov    %esp,%ebp
    return page - pages;
  103c1b:	8b 15 a0 ce 11 00    	mov    0x11cea0,%edx
  103c21:	8b 45 08             	mov    0x8(%ebp),%eax
  103c24:	29 d0                	sub    %edx,%eax
  103c26:	c1 f8 02             	sar    $0x2,%eax
  103c29:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  103c2f:	5d                   	pop    %ebp
  103c30:	c3                   	ret    

00103c31 <page2pa>:
page2pa(struct Page *page) {
  103c31:	55                   	push   %ebp
  103c32:	89 e5                	mov    %esp,%ebp
  103c34:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  103c37:	8b 45 08             	mov    0x8(%ebp),%eax
  103c3a:	89 04 24             	mov    %eax,(%esp)
  103c3d:	e8 d6 ff ff ff       	call   103c18 <page2ppn>
  103c42:	c1 e0 0c             	shl    $0xc,%eax
}
  103c45:	89 ec                	mov    %ebp,%esp
  103c47:	5d                   	pop    %ebp
  103c48:	c3                   	ret    

00103c49 <pa2page>:
pa2page(uintptr_t pa) {
  103c49:	55                   	push   %ebp
  103c4a:	89 e5                	mov    %esp,%ebp
  103c4c:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
  103c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  103c52:	c1 e8 0c             	shr    $0xc,%eax
  103c55:	89 c2                	mov    %eax,%edx
  103c57:	a1 a4 ce 11 00       	mov    0x11cea4,%eax
  103c5c:	39 c2                	cmp    %eax,%edx
  103c5e:	72 1c                	jb     103c7c <pa2page+0x33>
        panic("pa2page called with invalid pa");
  103c60:	c7 44 24 08 2c 6c 10 	movl   $0x106c2c,0x8(%esp)
  103c67:	00 
  103c68:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  103c6f:	00 
  103c70:	c7 04 24 4b 6c 10 00 	movl   $0x106c4b,(%esp)
  103c77:	e8 5f d0 ff ff       	call   100cdb <__panic>
    return &pages[PPN(pa)];
  103c7c:	8b 0d a0 ce 11 00    	mov    0x11cea0,%ecx
  103c82:	8b 45 08             	mov    0x8(%ebp),%eax
  103c85:	c1 e8 0c             	shr    $0xc,%eax
  103c88:	89 c2                	mov    %eax,%edx
  103c8a:	89 d0                	mov    %edx,%eax
  103c8c:	c1 e0 02             	shl    $0x2,%eax
  103c8f:	01 d0                	add    %edx,%eax
  103c91:	c1 e0 02             	shl    $0x2,%eax
  103c94:	01 c8                	add    %ecx,%eax
}
  103c96:	89 ec                	mov    %ebp,%esp
  103c98:	5d                   	pop    %ebp
  103c99:	c3                   	ret    

00103c9a <page2kva>:
page2kva(struct Page *page) {
  103c9a:	55                   	push   %ebp
  103c9b:	89 e5                	mov    %esp,%ebp
  103c9d:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
  103ca0:	8b 45 08             	mov    0x8(%ebp),%eax
  103ca3:	89 04 24             	mov    %eax,(%esp)
  103ca6:	e8 86 ff ff ff       	call   103c31 <page2pa>
  103cab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103cae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103cb1:	c1 e8 0c             	shr    $0xc,%eax
  103cb4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103cb7:	a1 a4 ce 11 00       	mov    0x11cea4,%eax
  103cbc:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  103cbf:	72 23                	jb     103ce4 <page2kva+0x4a>
  103cc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103cc4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103cc8:	c7 44 24 08 5c 6c 10 	movl   $0x106c5c,0x8(%esp)
  103ccf:	00 
  103cd0:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  103cd7:	00 
  103cd8:	c7 04 24 4b 6c 10 00 	movl   $0x106c4b,(%esp)
  103cdf:	e8 f7 cf ff ff       	call   100cdb <__panic>
  103ce4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103ce7:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  103cec:	89 ec                	mov    %ebp,%esp
  103cee:	5d                   	pop    %ebp
  103cef:	c3                   	ret    

00103cf0 <pte2page>:
pte2page(pte_t pte) {
  103cf0:	55                   	push   %ebp
  103cf1:	89 e5                	mov    %esp,%ebp
  103cf3:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
  103cf6:	8b 45 08             	mov    0x8(%ebp),%eax
  103cf9:	83 e0 01             	and    $0x1,%eax
  103cfc:	85 c0                	test   %eax,%eax
  103cfe:	75 1c                	jne    103d1c <pte2page+0x2c>
        panic("pte2page called with invalid pte");
  103d00:	c7 44 24 08 80 6c 10 	movl   $0x106c80,0x8(%esp)
  103d07:	00 
  103d08:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  103d0f:	00 
  103d10:	c7 04 24 4b 6c 10 00 	movl   $0x106c4b,(%esp)
  103d17:	e8 bf cf ff ff       	call   100cdb <__panic>
    return pa2page(PTE_ADDR(pte));
  103d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  103d1f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103d24:	89 04 24             	mov    %eax,(%esp)
  103d27:	e8 1d ff ff ff       	call   103c49 <pa2page>
}
  103d2c:	89 ec                	mov    %ebp,%esp
  103d2e:	5d                   	pop    %ebp
  103d2f:	c3                   	ret    

00103d30 <pde2page>:
pde2page(pde_t pde) {
  103d30:	55                   	push   %ebp
  103d31:	89 e5                	mov    %esp,%ebp
  103d33:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
  103d36:	8b 45 08             	mov    0x8(%ebp),%eax
  103d39:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103d3e:	89 04 24             	mov    %eax,(%esp)
  103d41:	e8 03 ff ff ff       	call   103c49 <pa2page>
}
  103d46:	89 ec                	mov    %ebp,%esp
  103d48:	5d                   	pop    %ebp
  103d49:	c3                   	ret    

00103d4a <page_ref>:
page_ref(struct Page *page) {
  103d4a:	55                   	push   %ebp
  103d4b:	89 e5                	mov    %esp,%ebp
    return page->ref;
  103d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  103d50:	8b 00                	mov    (%eax),%eax
}
  103d52:	5d                   	pop    %ebp
  103d53:	c3                   	ret    

00103d54 <set_page_ref>:
set_page_ref(struct Page *page, int val) {
  103d54:	55                   	push   %ebp
  103d55:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  103d57:	8b 45 08             	mov    0x8(%ebp),%eax
  103d5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  103d5d:	89 10                	mov    %edx,(%eax)
}
  103d5f:	90                   	nop
  103d60:	5d                   	pop    %ebp
  103d61:	c3                   	ret    

00103d62 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
  103d62:	55                   	push   %ebp
  103d63:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  103d65:	8b 45 08             	mov    0x8(%ebp),%eax
  103d68:	8b 00                	mov    (%eax),%eax
  103d6a:	8d 50 01             	lea    0x1(%eax),%edx
  103d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  103d70:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103d72:	8b 45 08             	mov    0x8(%ebp),%eax
  103d75:	8b 00                	mov    (%eax),%eax
}
  103d77:	5d                   	pop    %ebp
  103d78:	c3                   	ret    

00103d79 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  103d79:	55                   	push   %ebp
  103d7a:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  103d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  103d7f:	8b 00                	mov    (%eax),%eax
  103d81:	8d 50 ff             	lea    -0x1(%eax),%edx
  103d84:	8b 45 08             	mov    0x8(%ebp),%eax
  103d87:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103d89:	8b 45 08             	mov    0x8(%ebp),%eax
  103d8c:	8b 00                	mov    (%eax),%eax
}
  103d8e:	5d                   	pop    %ebp
  103d8f:	c3                   	ret    

00103d90 <__intr_save>:
__intr_save(void) {
  103d90:	55                   	push   %ebp
  103d91:	89 e5                	mov    %esp,%ebp
  103d93:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  103d96:	9c                   	pushf  
  103d97:	58                   	pop    %eax
  103d98:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  103d9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  103d9e:	25 00 02 00 00       	and    $0x200,%eax
  103da3:	85 c0                	test   %eax,%eax
  103da5:	74 0c                	je     103db3 <__intr_save+0x23>
        intr_disable();
  103da7:	e8 88 d9 ff ff       	call   101734 <intr_disable>
        return 1;
  103dac:	b8 01 00 00 00       	mov    $0x1,%eax
  103db1:	eb 05                	jmp    103db8 <__intr_save+0x28>
    return 0;
  103db3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103db8:	89 ec                	mov    %ebp,%esp
  103dba:	5d                   	pop    %ebp
  103dbb:	c3                   	ret    

00103dbc <__intr_restore>:
__intr_restore(bool flag) {
  103dbc:	55                   	push   %ebp
  103dbd:	89 e5                	mov    %esp,%ebp
  103dbf:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  103dc2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103dc6:	74 05                	je     103dcd <__intr_restore+0x11>
        intr_enable();
  103dc8:	e8 5f d9 ff ff       	call   10172c <intr_enable>
}
  103dcd:	90                   	nop
  103dce:	89 ec                	mov    %ebp,%esp
  103dd0:	5d                   	pop    %ebp
  103dd1:	c3                   	ret    

00103dd2 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  103dd2:	55                   	push   %ebp
  103dd3:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  103dd5:	8b 45 08             	mov    0x8(%ebp),%eax
  103dd8:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  103ddb:	b8 23 00 00 00       	mov    $0x23,%eax
  103de0:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  103de2:	b8 23 00 00 00       	mov    $0x23,%eax
  103de7:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  103de9:	b8 10 00 00 00       	mov    $0x10,%eax
  103dee:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  103df0:	b8 10 00 00 00       	mov    $0x10,%eax
  103df5:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  103df7:	b8 10 00 00 00       	mov    $0x10,%eax
  103dfc:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  103dfe:	ea 05 3e 10 00 08 00 	ljmp   $0x8,$0x103e05
}
  103e05:	90                   	nop
  103e06:	5d                   	pop    %ebp
  103e07:	c3                   	ret    

00103e08 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  103e08:	55                   	push   %ebp
  103e09:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  103e0b:	8b 45 08             	mov    0x8(%ebp),%eax
  103e0e:	a3 c4 ce 11 00       	mov    %eax,0x11cec4
}
  103e13:	90                   	nop
  103e14:	5d                   	pop    %ebp
  103e15:	c3                   	ret    

00103e16 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  103e16:	55                   	push   %ebp
  103e17:	89 e5                	mov    %esp,%ebp
  103e19:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  103e1c:	b8 00 90 11 00       	mov    $0x119000,%eax
  103e21:	89 04 24             	mov    %eax,(%esp)
  103e24:	e8 df ff ff ff       	call   103e08 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
  103e29:	66 c7 05 c8 ce 11 00 	movw   $0x10,0x11cec8
  103e30:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  103e32:	66 c7 05 28 9a 11 00 	movw   $0x68,0x119a28
  103e39:	68 00 
  103e3b:	b8 c0 ce 11 00       	mov    $0x11cec0,%eax
  103e40:	0f b7 c0             	movzwl %ax,%eax
  103e43:	66 a3 2a 9a 11 00    	mov    %ax,0x119a2a
  103e49:	b8 c0 ce 11 00       	mov    $0x11cec0,%eax
  103e4e:	c1 e8 10             	shr    $0x10,%eax
  103e51:	a2 2c 9a 11 00       	mov    %al,0x119a2c
  103e56:	0f b6 05 2d 9a 11 00 	movzbl 0x119a2d,%eax
  103e5d:	24 f0                	and    $0xf0,%al
  103e5f:	0c 09                	or     $0x9,%al
  103e61:	a2 2d 9a 11 00       	mov    %al,0x119a2d
  103e66:	0f b6 05 2d 9a 11 00 	movzbl 0x119a2d,%eax
  103e6d:	24 ef                	and    $0xef,%al
  103e6f:	a2 2d 9a 11 00       	mov    %al,0x119a2d
  103e74:	0f b6 05 2d 9a 11 00 	movzbl 0x119a2d,%eax
  103e7b:	24 9f                	and    $0x9f,%al
  103e7d:	a2 2d 9a 11 00       	mov    %al,0x119a2d
  103e82:	0f b6 05 2d 9a 11 00 	movzbl 0x119a2d,%eax
  103e89:	0c 80                	or     $0x80,%al
  103e8b:	a2 2d 9a 11 00       	mov    %al,0x119a2d
  103e90:	0f b6 05 2e 9a 11 00 	movzbl 0x119a2e,%eax
  103e97:	24 f0                	and    $0xf0,%al
  103e99:	a2 2e 9a 11 00       	mov    %al,0x119a2e
  103e9e:	0f b6 05 2e 9a 11 00 	movzbl 0x119a2e,%eax
  103ea5:	24 ef                	and    $0xef,%al
  103ea7:	a2 2e 9a 11 00       	mov    %al,0x119a2e
  103eac:	0f b6 05 2e 9a 11 00 	movzbl 0x119a2e,%eax
  103eb3:	24 df                	and    $0xdf,%al
  103eb5:	a2 2e 9a 11 00       	mov    %al,0x119a2e
  103eba:	0f b6 05 2e 9a 11 00 	movzbl 0x119a2e,%eax
  103ec1:	0c 40                	or     $0x40,%al
  103ec3:	a2 2e 9a 11 00       	mov    %al,0x119a2e
  103ec8:	0f b6 05 2e 9a 11 00 	movzbl 0x119a2e,%eax
  103ecf:	24 7f                	and    $0x7f,%al
  103ed1:	a2 2e 9a 11 00       	mov    %al,0x119a2e
  103ed6:	b8 c0 ce 11 00       	mov    $0x11cec0,%eax
  103edb:	c1 e8 18             	shr    $0x18,%eax
  103ede:	a2 2f 9a 11 00       	mov    %al,0x119a2f

    // reload all segment registers
    lgdt(&gdt_pd);
  103ee3:	c7 04 24 30 9a 11 00 	movl   $0x119a30,(%esp)
  103eea:	e8 e3 fe ff ff       	call   103dd2 <lgdt>
  103eef:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  103ef5:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  103ef9:	0f 00 d8             	ltr    %ax
}
  103efc:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
  103efd:	90                   	nop
  103efe:	89 ec                	mov    %ebp,%esp
  103f00:	5d                   	pop    %ebp
  103f01:	c3                   	ret    

00103f02 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  103f02:	55                   	push   %ebp
  103f03:	89 e5                	mov    %esp,%ebp
  103f05:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
  103f08:	c7 05 ac ce 11 00 10 	movl   $0x106c10,0x11ceac
  103f0f:	6c 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  103f12:	a1 ac ce 11 00       	mov    0x11ceac,%eax
  103f17:	8b 00                	mov    (%eax),%eax
  103f19:	89 44 24 04          	mov    %eax,0x4(%esp)
  103f1d:	c7 04 24 ac 6c 10 00 	movl   $0x106cac,(%esp)
  103f24:	e8 2d c4 ff ff       	call   100356 <cprintf>
    pmm_manager->init();
  103f29:	a1 ac ce 11 00       	mov    0x11ceac,%eax
  103f2e:	8b 40 04             	mov    0x4(%eax),%eax
  103f31:	ff d0                	call   *%eax
}
  103f33:	90                   	nop
  103f34:	89 ec                	mov    %ebp,%esp
  103f36:	5d                   	pop    %ebp
  103f37:	c3                   	ret    

00103f38 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  103f38:	55                   	push   %ebp
  103f39:	89 e5                	mov    %esp,%ebp
  103f3b:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
  103f3e:	a1 ac ce 11 00       	mov    0x11ceac,%eax
  103f43:	8b 40 08             	mov    0x8(%eax),%eax
  103f46:	8b 55 0c             	mov    0xc(%ebp),%edx
  103f49:	89 54 24 04          	mov    %edx,0x4(%esp)
  103f4d:	8b 55 08             	mov    0x8(%ebp),%edx
  103f50:	89 14 24             	mov    %edx,(%esp)
  103f53:	ff d0                	call   *%eax
}
  103f55:	90                   	nop
  103f56:	89 ec                	mov    %ebp,%esp
  103f58:	5d                   	pop    %ebp
  103f59:	c3                   	ret    

00103f5a <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  103f5a:	55                   	push   %ebp
  103f5b:	89 e5                	mov    %esp,%ebp
  103f5d:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
  103f60:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  103f67:	e8 24 fe ff ff       	call   103d90 <__intr_save>
  103f6c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  103f6f:	a1 ac ce 11 00       	mov    0x11ceac,%eax
  103f74:	8b 40 0c             	mov    0xc(%eax),%eax
  103f77:	8b 55 08             	mov    0x8(%ebp),%edx
  103f7a:	89 14 24             	mov    %edx,(%esp)
  103f7d:	ff d0                	call   *%eax
  103f7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  103f82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103f85:	89 04 24             	mov    %eax,(%esp)
  103f88:	e8 2f fe ff ff       	call   103dbc <__intr_restore>
    return page;
  103f8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103f90:	89 ec                	mov    %ebp,%esp
  103f92:	5d                   	pop    %ebp
  103f93:	c3                   	ret    

00103f94 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  103f94:	55                   	push   %ebp
  103f95:	89 e5                	mov    %esp,%ebp
  103f97:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  103f9a:	e8 f1 fd ff ff       	call   103d90 <__intr_save>
  103f9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  103fa2:	a1 ac ce 11 00       	mov    0x11ceac,%eax
  103fa7:	8b 40 10             	mov    0x10(%eax),%eax
  103faa:	8b 55 0c             	mov    0xc(%ebp),%edx
  103fad:	89 54 24 04          	mov    %edx,0x4(%esp)
  103fb1:	8b 55 08             	mov    0x8(%ebp),%edx
  103fb4:	89 14 24             	mov    %edx,(%esp)
  103fb7:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
  103fb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103fbc:	89 04 24             	mov    %eax,(%esp)
  103fbf:	e8 f8 fd ff ff       	call   103dbc <__intr_restore>
}
  103fc4:	90                   	nop
  103fc5:	89 ec                	mov    %ebp,%esp
  103fc7:	5d                   	pop    %ebp
  103fc8:	c3                   	ret    

00103fc9 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  103fc9:	55                   	push   %ebp
  103fca:	89 e5                	mov    %esp,%ebp
  103fcc:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  103fcf:	e8 bc fd ff ff       	call   103d90 <__intr_save>
  103fd4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  103fd7:	a1 ac ce 11 00       	mov    0x11ceac,%eax
  103fdc:	8b 40 14             	mov    0x14(%eax),%eax
  103fdf:	ff d0                	call   *%eax
  103fe1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  103fe4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103fe7:	89 04 24             	mov    %eax,(%esp)
  103fea:	e8 cd fd ff ff       	call   103dbc <__intr_restore>
    return ret;
  103fef:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  103ff2:	89 ec                	mov    %ebp,%esp
  103ff4:	5d                   	pop    %ebp
  103ff5:	c3                   	ret    

00103ff6 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  103ff6:	55                   	push   %ebp
  103ff7:	89 e5                	mov    %esp,%ebp
  103ff9:	57                   	push   %edi
  103ffa:	56                   	push   %esi
  103ffb:	53                   	push   %ebx
  103ffc:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  104002:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  104009:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  104010:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  104017:	c7 04 24 c3 6c 10 00 	movl   $0x106cc3,(%esp)
  10401e:	e8 33 c3 ff ff       	call   100356 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  104023:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  10402a:	e9 0c 01 00 00       	jmp    10413b <page_init+0x145>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  10402f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104032:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104035:	89 d0                	mov    %edx,%eax
  104037:	c1 e0 02             	shl    $0x2,%eax
  10403a:	01 d0                	add    %edx,%eax
  10403c:	c1 e0 02             	shl    $0x2,%eax
  10403f:	01 c8                	add    %ecx,%eax
  104041:	8b 50 08             	mov    0x8(%eax),%edx
  104044:	8b 40 04             	mov    0x4(%eax),%eax
  104047:	89 45 a0             	mov    %eax,-0x60(%ebp)
  10404a:	89 55 a4             	mov    %edx,-0x5c(%ebp)
  10404d:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104050:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104053:	89 d0                	mov    %edx,%eax
  104055:	c1 e0 02             	shl    $0x2,%eax
  104058:	01 d0                	add    %edx,%eax
  10405a:	c1 e0 02             	shl    $0x2,%eax
  10405d:	01 c8                	add    %ecx,%eax
  10405f:	8b 48 0c             	mov    0xc(%eax),%ecx
  104062:	8b 58 10             	mov    0x10(%eax),%ebx
  104065:	8b 45 a0             	mov    -0x60(%ebp),%eax
  104068:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  10406b:	01 c8                	add    %ecx,%eax
  10406d:	11 da                	adc    %ebx,%edx
  10406f:	89 45 98             	mov    %eax,-0x68(%ebp)
  104072:	89 55 9c             	mov    %edx,-0x64(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  104075:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104078:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10407b:	89 d0                	mov    %edx,%eax
  10407d:	c1 e0 02             	shl    $0x2,%eax
  104080:	01 d0                	add    %edx,%eax
  104082:	c1 e0 02             	shl    $0x2,%eax
  104085:	01 c8                	add    %ecx,%eax
  104087:	83 c0 14             	add    $0x14,%eax
  10408a:	8b 00                	mov    (%eax),%eax
  10408c:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  104092:	8b 45 98             	mov    -0x68(%ebp),%eax
  104095:	8b 55 9c             	mov    -0x64(%ebp),%edx
  104098:	83 c0 ff             	add    $0xffffffff,%eax
  10409b:	83 d2 ff             	adc    $0xffffffff,%edx
  10409e:	89 c6                	mov    %eax,%esi
  1040a0:	89 d7                	mov    %edx,%edi
  1040a2:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  1040a5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1040a8:	89 d0                	mov    %edx,%eax
  1040aa:	c1 e0 02             	shl    $0x2,%eax
  1040ad:	01 d0                	add    %edx,%eax
  1040af:	c1 e0 02             	shl    $0x2,%eax
  1040b2:	01 c8                	add    %ecx,%eax
  1040b4:	8b 48 0c             	mov    0xc(%eax),%ecx
  1040b7:	8b 58 10             	mov    0x10(%eax),%ebx
  1040ba:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  1040c0:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  1040c4:	89 74 24 14          	mov    %esi,0x14(%esp)
  1040c8:	89 7c 24 18          	mov    %edi,0x18(%esp)
  1040cc:	8b 45 a0             	mov    -0x60(%ebp),%eax
  1040cf:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  1040d2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1040d6:	89 54 24 10          	mov    %edx,0x10(%esp)
  1040da:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  1040de:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  1040e2:	c7 04 24 d0 6c 10 00 	movl   $0x106cd0,(%esp)
  1040e9:	e8 68 c2 ff ff       	call   100356 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  1040ee:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  1040f1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1040f4:	89 d0                	mov    %edx,%eax
  1040f6:	c1 e0 02             	shl    $0x2,%eax
  1040f9:	01 d0                	add    %edx,%eax
  1040fb:	c1 e0 02             	shl    $0x2,%eax
  1040fe:	01 c8                	add    %ecx,%eax
  104100:	83 c0 14             	add    $0x14,%eax
  104103:	8b 00                	mov    (%eax),%eax
  104105:	83 f8 01             	cmp    $0x1,%eax
  104108:	75 2e                	jne    104138 <page_init+0x142>
            if (maxpa < end && begin < KMEMSIZE) {
  10410a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10410d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104110:	3b 45 98             	cmp    -0x68(%ebp),%eax
  104113:	89 d0                	mov    %edx,%eax
  104115:	1b 45 9c             	sbb    -0x64(%ebp),%eax
  104118:	73 1e                	jae    104138 <page_init+0x142>
  10411a:	ba ff ff ff 37       	mov    $0x37ffffff,%edx
  10411f:	b8 00 00 00 00       	mov    $0x0,%eax
  104124:	3b 55 a0             	cmp    -0x60(%ebp),%edx
  104127:	1b 45 a4             	sbb    -0x5c(%ebp),%eax
  10412a:	72 0c                	jb     104138 <page_init+0x142>
                maxpa = end;
  10412c:	8b 45 98             	mov    -0x68(%ebp),%eax
  10412f:	8b 55 9c             	mov    -0x64(%ebp),%edx
  104132:	89 45 e0             	mov    %eax,-0x20(%ebp)
  104135:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i ++) {
  104138:	ff 45 dc             	incl   -0x24(%ebp)
  10413b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  10413e:	8b 00                	mov    (%eax),%eax
  104140:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  104143:	0f 8c e6 fe ff ff    	jl     10402f <page_init+0x39>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  104149:	ba 00 00 00 38       	mov    $0x38000000,%edx
  10414e:	b8 00 00 00 00       	mov    $0x0,%eax
  104153:	3b 55 e0             	cmp    -0x20(%ebp),%edx
  104156:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
  104159:	73 0e                	jae    104169 <page_init+0x173>
        maxpa = KMEMSIZE;
  10415b:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  104162:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
  104169:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10416c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10416f:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  104173:	c1 ea 0c             	shr    $0xc,%edx
  104176:	a3 a4 ce 11 00       	mov    %eax,0x11cea4
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  10417b:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  104182:	b8 2c cf 11 00       	mov    $0x11cf2c,%eax
  104187:	8d 50 ff             	lea    -0x1(%eax),%edx
  10418a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  10418d:	01 d0                	add    %edx,%eax
  10418f:	89 45 bc             	mov    %eax,-0x44(%ebp)
  104192:	8b 45 bc             	mov    -0x44(%ebp),%eax
  104195:	ba 00 00 00 00       	mov    $0x0,%edx
  10419a:	f7 75 c0             	divl   -0x40(%ebp)
  10419d:	8b 45 bc             	mov    -0x44(%ebp),%eax
  1041a0:	29 d0                	sub    %edx,%eax
  1041a2:	a3 a0 ce 11 00       	mov    %eax,0x11cea0

    for (i = 0; i < npage; i ++) {
  1041a7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  1041ae:	eb 2f                	jmp    1041df <page_init+0x1e9>
        SetPageReserved(pages + i);
  1041b0:	8b 0d a0 ce 11 00    	mov    0x11cea0,%ecx
  1041b6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1041b9:	89 d0                	mov    %edx,%eax
  1041bb:	c1 e0 02             	shl    $0x2,%eax
  1041be:	01 d0                	add    %edx,%eax
  1041c0:	c1 e0 02             	shl    $0x2,%eax
  1041c3:	01 c8                	add    %ecx,%eax
  1041c5:	83 c0 04             	add    $0x4,%eax
  1041c8:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
  1041cf:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  1041d2:	8b 45 90             	mov    -0x70(%ebp),%eax
  1041d5:	8b 55 94             	mov    -0x6c(%ebp),%edx
  1041d8:	0f ab 10             	bts    %edx,(%eax)
}
  1041db:	90                   	nop
    for (i = 0; i < npage; i ++) {
  1041dc:	ff 45 dc             	incl   -0x24(%ebp)
  1041df:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1041e2:	a1 a4 ce 11 00       	mov    0x11cea4,%eax
  1041e7:	39 c2                	cmp    %eax,%edx
  1041e9:	72 c5                	jb     1041b0 <page_init+0x1ba>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  1041eb:	8b 15 a4 ce 11 00    	mov    0x11cea4,%edx
  1041f1:	89 d0                	mov    %edx,%eax
  1041f3:	c1 e0 02             	shl    $0x2,%eax
  1041f6:	01 d0                	add    %edx,%eax
  1041f8:	c1 e0 02             	shl    $0x2,%eax
  1041fb:	89 c2                	mov    %eax,%edx
  1041fd:	a1 a0 ce 11 00       	mov    0x11cea0,%eax
  104202:	01 d0                	add    %edx,%eax
  104204:	89 45 b8             	mov    %eax,-0x48(%ebp)
  104207:	81 7d b8 ff ff ff bf 	cmpl   $0xbfffffff,-0x48(%ebp)
  10420e:	77 23                	ja     104233 <page_init+0x23d>
  104210:	8b 45 b8             	mov    -0x48(%ebp),%eax
  104213:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104217:	c7 44 24 08 00 6d 10 	movl   $0x106d00,0x8(%esp)
  10421e:	00 
  10421f:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
  104226:	00 
  104227:	c7 04 24 24 6d 10 00 	movl   $0x106d24,(%esp)
  10422e:	e8 a8 ca ff ff       	call   100cdb <__panic>
  104233:	8b 45 b8             	mov    -0x48(%ebp),%eax
  104236:	05 00 00 00 40       	add    $0x40000000,%eax
  10423b:	89 45 b4             	mov    %eax,-0x4c(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
  10423e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  104245:	e9 53 01 00 00       	jmp    10439d <page_init+0x3a7>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  10424a:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  10424d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104250:	89 d0                	mov    %edx,%eax
  104252:	c1 e0 02             	shl    $0x2,%eax
  104255:	01 d0                	add    %edx,%eax
  104257:	c1 e0 02             	shl    $0x2,%eax
  10425a:	01 c8                	add    %ecx,%eax
  10425c:	8b 50 08             	mov    0x8(%eax),%edx
  10425f:	8b 40 04             	mov    0x4(%eax),%eax
  104262:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104265:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  104268:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  10426b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10426e:	89 d0                	mov    %edx,%eax
  104270:	c1 e0 02             	shl    $0x2,%eax
  104273:	01 d0                	add    %edx,%eax
  104275:	c1 e0 02             	shl    $0x2,%eax
  104278:	01 c8                	add    %ecx,%eax
  10427a:	8b 48 0c             	mov    0xc(%eax),%ecx
  10427d:	8b 58 10             	mov    0x10(%eax),%ebx
  104280:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104283:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104286:	01 c8                	add    %ecx,%eax
  104288:	11 da                	adc    %ebx,%edx
  10428a:	89 45 c8             	mov    %eax,-0x38(%ebp)
  10428d:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  104290:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104293:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104296:	89 d0                	mov    %edx,%eax
  104298:	c1 e0 02             	shl    $0x2,%eax
  10429b:	01 d0                	add    %edx,%eax
  10429d:	c1 e0 02             	shl    $0x2,%eax
  1042a0:	01 c8                	add    %ecx,%eax
  1042a2:	83 c0 14             	add    $0x14,%eax
  1042a5:	8b 00                	mov    (%eax),%eax
  1042a7:	83 f8 01             	cmp    $0x1,%eax
  1042aa:	0f 85 ea 00 00 00    	jne    10439a <page_init+0x3a4>
            if (begin < freemem) {
  1042b0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1042b3:	ba 00 00 00 00       	mov    $0x0,%edx
  1042b8:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  1042bb:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  1042be:	19 d1                	sbb    %edx,%ecx
  1042c0:	73 0d                	jae    1042cf <page_init+0x2d9>
                begin = freemem;
  1042c2:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1042c5:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1042c8:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
  1042cf:	ba 00 00 00 38       	mov    $0x38000000,%edx
  1042d4:	b8 00 00 00 00       	mov    $0x0,%eax
  1042d9:	3b 55 c8             	cmp    -0x38(%ebp),%edx
  1042dc:	1b 45 cc             	sbb    -0x34(%ebp),%eax
  1042df:	73 0e                	jae    1042ef <page_init+0x2f9>
                end = KMEMSIZE;
  1042e1:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  1042e8:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
  1042ef:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1042f2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1042f5:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  1042f8:	89 d0                	mov    %edx,%eax
  1042fa:	1b 45 cc             	sbb    -0x34(%ebp),%eax
  1042fd:	0f 83 97 00 00 00    	jae    10439a <page_init+0x3a4>
                begin = ROUNDUP(begin, PGSIZE);
  104303:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  10430a:	8b 55 d0             	mov    -0x30(%ebp),%edx
  10430d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  104310:	01 d0                	add    %edx,%eax
  104312:	48                   	dec    %eax
  104313:	89 45 ac             	mov    %eax,-0x54(%ebp)
  104316:	8b 45 ac             	mov    -0x54(%ebp),%eax
  104319:	ba 00 00 00 00       	mov    $0x0,%edx
  10431e:	f7 75 b0             	divl   -0x50(%ebp)
  104321:	8b 45 ac             	mov    -0x54(%ebp),%eax
  104324:	29 d0                	sub    %edx,%eax
  104326:	ba 00 00 00 00       	mov    $0x0,%edx
  10432b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10432e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  104331:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104334:	89 45 a8             	mov    %eax,-0x58(%ebp)
  104337:	8b 45 a8             	mov    -0x58(%ebp),%eax
  10433a:	ba 00 00 00 00       	mov    $0x0,%edx
  10433f:	89 c7                	mov    %eax,%edi
  104341:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  104347:	89 7d 80             	mov    %edi,-0x80(%ebp)
  10434a:	89 d0                	mov    %edx,%eax
  10434c:	83 e0 00             	and    $0x0,%eax
  10434f:	89 45 84             	mov    %eax,-0x7c(%ebp)
  104352:	8b 45 80             	mov    -0x80(%ebp),%eax
  104355:	8b 55 84             	mov    -0x7c(%ebp),%edx
  104358:	89 45 c8             	mov    %eax,-0x38(%ebp)
  10435b:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
  10435e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104361:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104364:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  104367:	89 d0                	mov    %edx,%eax
  104369:	1b 45 cc             	sbb    -0x34(%ebp),%eax
  10436c:	73 2c                	jae    10439a <page_init+0x3a4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  10436e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104371:	8b 55 cc             	mov    -0x34(%ebp),%edx
  104374:	2b 45 d0             	sub    -0x30(%ebp),%eax
  104377:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
  10437a:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  10437e:	c1 ea 0c             	shr    $0xc,%edx
  104381:	89 c3                	mov    %eax,%ebx
  104383:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104386:	89 04 24             	mov    %eax,(%esp)
  104389:	e8 bb f8 ff ff       	call   103c49 <pa2page>
  10438e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  104392:	89 04 24             	mov    %eax,(%esp)
  104395:	e8 9e fb ff ff       	call   103f38 <init_memmap>
    for (i = 0; i < memmap->nr_map; i ++) {
  10439a:	ff 45 dc             	incl   -0x24(%ebp)
  10439d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1043a0:	8b 00                	mov    (%eax),%eax
  1043a2:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  1043a5:	0f 8c 9f fe ff ff    	jl     10424a <page_init+0x254>
                }
            }
        }
    }
}
  1043ab:	90                   	nop
  1043ac:	90                   	nop
  1043ad:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  1043b3:	5b                   	pop    %ebx
  1043b4:	5e                   	pop    %esi
  1043b5:	5f                   	pop    %edi
  1043b6:	5d                   	pop    %ebp
  1043b7:	c3                   	ret    

001043b8 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  1043b8:	55                   	push   %ebp
  1043b9:	89 e5                	mov    %esp,%ebp
  1043bb:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
  1043be:	8b 45 0c             	mov    0xc(%ebp),%eax
  1043c1:	33 45 14             	xor    0x14(%ebp),%eax
  1043c4:	25 ff 0f 00 00       	and    $0xfff,%eax
  1043c9:	85 c0                	test   %eax,%eax
  1043cb:	74 24                	je     1043f1 <boot_map_segment+0x39>
  1043cd:	c7 44 24 0c 32 6d 10 	movl   $0x106d32,0xc(%esp)
  1043d4:	00 
  1043d5:	c7 44 24 08 49 6d 10 	movl   $0x106d49,0x8(%esp)
  1043dc:	00 
  1043dd:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
  1043e4:	00 
  1043e5:	c7 04 24 24 6d 10 00 	movl   $0x106d24,(%esp)
  1043ec:	e8 ea c8 ff ff       	call   100cdb <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  1043f1:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  1043f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1043fb:	25 ff 0f 00 00       	and    $0xfff,%eax
  104400:	89 c2                	mov    %eax,%edx
  104402:	8b 45 10             	mov    0x10(%ebp),%eax
  104405:	01 c2                	add    %eax,%edx
  104407:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10440a:	01 d0                	add    %edx,%eax
  10440c:	48                   	dec    %eax
  10440d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104410:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104413:	ba 00 00 00 00       	mov    $0x0,%edx
  104418:	f7 75 f0             	divl   -0x10(%ebp)
  10441b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10441e:	29 d0                	sub    %edx,%eax
  104420:	c1 e8 0c             	shr    $0xc,%eax
  104423:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  104426:	8b 45 0c             	mov    0xc(%ebp),%eax
  104429:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10442c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10442f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104434:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  104437:	8b 45 14             	mov    0x14(%ebp),%eax
  10443a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10443d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104440:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104445:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  104448:	eb 68                	jmp    1044b2 <boot_map_segment+0xfa>
        pte_t *ptep = get_pte(pgdir, la, 1);
  10444a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  104451:	00 
  104452:	8b 45 0c             	mov    0xc(%ebp),%eax
  104455:	89 44 24 04          	mov    %eax,0x4(%esp)
  104459:	8b 45 08             	mov    0x8(%ebp),%eax
  10445c:	89 04 24             	mov    %eax,(%esp)
  10445f:	e8 88 01 00 00       	call   1045ec <get_pte>
  104464:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  104467:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  10446b:	75 24                	jne    104491 <boot_map_segment+0xd9>
  10446d:	c7 44 24 0c 5e 6d 10 	movl   $0x106d5e,0xc(%esp)
  104474:	00 
  104475:	c7 44 24 08 49 6d 10 	movl   $0x106d49,0x8(%esp)
  10447c:	00 
  10447d:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
  104484:	00 
  104485:	c7 04 24 24 6d 10 00 	movl   $0x106d24,(%esp)
  10448c:	e8 4a c8 ff ff       	call   100cdb <__panic>
        *ptep = pa | PTE_P | perm;
  104491:	8b 45 14             	mov    0x14(%ebp),%eax
  104494:	0b 45 18             	or     0x18(%ebp),%eax
  104497:	83 c8 01             	or     $0x1,%eax
  10449a:	89 c2                	mov    %eax,%edx
  10449c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10449f:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  1044a1:	ff 4d f4             	decl   -0xc(%ebp)
  1044a4:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  1044ab:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  1044b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1044b6:	75 92                	jne    10444a <boot_map_segment+0x92>
    }
}
  1044b8:	90                   	nop
  1044b9:	90                   	nop
  1044ba:	89 ec                	mov    %ebp,%esp
  1044bc:	5d                   	pop    %ebp
  1044bd:	c3                   	ret    

001044be <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  1044be:	55                   	push   %ebp
  1044bf:	89 e5                	mov    %esp,%ebp
  1044c1:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
  1044c4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1044cb:	e8 8a fa ff ff       	call   103f5a <alloc_pages>
  1044d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  1044d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1044d7:	75 1c                	jne    1044f5 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
  1044d9:	c7 44 24 08 6b 6d 10 	movl   $0x106d6b,0x8(%esp)
  1044e0:	00 
  1044e1:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
  1044e8:	00 
  1044e9:	c7 04 24 24 6d 10 00 	movl   $0x106d24,(%esp)
  1044f0:	e8 e6 c7 ff ff       	call   100cdb <__panic>
    }
    return page2kva(p);
  1044f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1044f8:	89 04 24             	mov    %eax,(%esp)
  1044fb:	e8 9a f7 ff ff       	call   103c9a <page2kva>
}
  104500:	89 ec                	mov    %ebp,%esp
  104502:	5d                   	pop    %ebp
  104503:	c3                   	ret    

00104504 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  104504:	55                   	push   %ebp
  104505:	89 e5                	mov    %esp,%ebp
  104507:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
  10450a:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  10450f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104512:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  104519:	77 23                	ja     10453e <pmm_init+0x3a>
  10451b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10451e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104522:	c7 44 24 08 00 6d 10 	movl   $0x106d00,0x8(%esp)
  104529:	00 
  10452a:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  104531:	00 
  104532:	c7 04 24 24 6d 10 00 	movl   $0x106d24,(%esp)
  104539:	e8 9d c7 ff ff       	call   100cdb <__panic>
  10453e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104541:	05 00 00 00 40       	add    $0x40000000,%eax
  104546:	a3 a8 ce 11 00       	mov    %eax,0x11cea8
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  10454b:	e8 b2 f9 ff ff       	call   103f02 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  104550:	e8 a1 fa ff ff       	call   103ff6 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  104555:	e8 ed 03 00 00       	call   104947 <check_alloc_page>

    check_pgdir();
  10455a:	e8 09 04 00 00       	call   104968 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  10455f:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  104564:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104567:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  10456e:	77 23                	ja     104593 <pmm_init+0x8f>
  104570:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104573:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104577:	c7 44 24 08 00 6d 10 	movl   $0x106d00,0x8(%esp)
  10457e:	00 
  10457f:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
  104586:	00 
  104587:	c7 04 24 24 6d 10 00 	movl   $0x106d24,(%esp)
  10458e:	e8 48 c7 ff ff       	call   100cdb <__panic>
  104593:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104596:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
  10459c:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  1045a1:	05 ac 0f 00 00       	add    $0xfac,%eax
  1045a6:	83 ca 03             	or     $0x3,%edx
  1045a9:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  1045ab:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  1045b0:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
  1045b7:	00 
  1045b8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  1045bf:	00 
  1045c0:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
  1045c7:	38 
  1045c8:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
  1045cf:	c0 
  1045d0:	89 04 24             	mov    %eax,(%esp)
  1045d3:	e8 e0 fd ff ff       	call   1043b8 <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  1045d8:	e8 39 f8 ff ff       	call   103e16 <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  1045dd:	e8 24 0a 00 00       	call   105006 <check_boot_pgdir>

    print_pgdir();
  1045e2:	e8 a1 0e 00 00       	call   105488 <print_pgdir>

}
  1045e7:	90                   	nop
  1045e8:	89 ec                	mov    %ebp,%esp
  1045ea:	5d                   	pop    %ebp
  1045eb:	c3                   	ret    

001045ec <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  1045ec:	55                   	push   %ebp
  1045ed:	89 e5                	mov    %esp,%ebp
  1045ef:	83 ec 38             	sub    $0x38,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t *pdep = &pgdir[PDX(la)];
  1045f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1045f5:	c1 e8 16             	shr    $0x16,%eax
  1045f8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1045ff:	8b 45 08             	mov    0x8(%ebp),%eax
  104602:	01 d0                	add    %edx,%eax
  104604:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (!(*pdep & PTE_P)) {
  104607:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10460a:	8b 00                	mov    (%eax),%eax
  10460c:	83 e0 01             	and    $0x1,%eax
  10460f:	85 c0                	test   %eax,%eax
  104611:	0f 85 af 00 00 00    	jne    1046c6 <get_pte+0xda>
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL) {
  104617:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10461b:	74 15                	je     104632 <get_pte+0x46>
  10461d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104624:	e8 31 f9 ff ff       	call   103f5a <alloc_pages>
  104629:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10462c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104630:	75 0a                	jne    10463c <get_pte+0x50>
            return NULL;
  104632:	b8 00 00 00 00       	mov    $0x0,%eax
  104637:	e9 e7 00 00 00       	jmp    104723 <get_pte+0x137>
        }
        set_page_ref(page, 1);
  10463c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104643:	00 
  104644:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104647:	89 04 24             	mov    %eax,(%esp)
  10464a:	e8 05 f7 ff ff       	call   103d54 <set_page_ref>
        uintptr_t pa = page2pa(page);
  10464f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104652:	89 04 24             	mov    %eax,(%esp)
  104655:	e8 d7 f5 ff ff       	call   103c31 <page2pa>
  10465a:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa), 0, PGSIZE);
  10465d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104660:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104663:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104666:	c1 e8 0c             	shr    $0xc,%eax
  104669:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10466c:	a1 a4 ce 11 00       	mov    0x11cea4,%eax
  104671:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  104674:	72 23                	jb     104699 <get_pte+0xad>
  104676:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104679:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10467d:	c7 44 24 08 5c 6c 10 	movl   $0x106c5c,0x8(%esp)
  104684:	00 
  104685:	c7 44 24 04 72 01 00 	movl   $0x172,0x4(%esp)
  10468c:	00 
  10468d:	c7 04 24 24 6d 10 00 	movl   $0x106d24,(%esp)
  104694:	e8 42 c6 ff ff       	call   100cdb <__panic>
  104699:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10469c:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1046a1:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  1046a8:	00 
  1046a9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1046b0:	00 
  1046b1:	89 04 24             	mov    %eax,(%esp)
  1046b4:	e8 d4 18 00 00       	call   105f8d <memset>
        *pdep = pa | PTE_U | PTE_W | PTE_P;
  1046b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1046bc:	83 c8 07             	or     $0x7,%eax
  1046bf:	89 c2                	mov    %eax,%edx
  1046c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046c4:	89 10                	mov    %edx,(%eax)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
  1046c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046c9:	8b 00                	mov    (%eax),%eax
  1046cb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1046d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1046d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1046d6:	c1 e8 0c             	shr    $0xc,%eax
  1046d9:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1046dc:	a1 a4 ce 11 00       	mov    0x11cea4,%eax
  1046e1:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  1046e4:	72 23                	jb     104709 <get_pte+0x11d>
  1046e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1046e9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1046ed:	c7 44 24 08 5c 6c 10 	movl   $0x106c5c,0x8(%esp)
  1046f4:	00 
  1046f5:	c7 44 24 04 75 01 00 	movl   $0x175,0x4(%esp)
  1046fc:	00 
  1046fd:	c7 04 24 24 6d 10 00 	movl   $0x106d24,(%esp)
  104704:	e8 d2 c5 ff ff       	call   100cdb <__panic>
  104709:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10470c:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104711:	89 c2                	mov    %eax,%edx
  104713:	8b 45 0c             	mov    0xc(%ebp),%eax
  104716:	c1 e8 0c             	shr    $0xc,%eax
  104719:	25 ff 03 00 00       	and    $0x3ff,%eax
  10471e:	c1 e0 02             	shl    $0x2,%eax
  104721:	01 d0                	add    %edx,%eax
}
  104723:	89 ec                	mov    %ebp,%esp
  104725:	5d                   	pop    %ebp
  104726:	c3                   	ret    

00104727 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  104727:	55                   	push   %ebp
  104728:	89 e5                	mov    %esp,%ebp
  10472a:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  10472d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104734:	00 
  104735:	8b 45 0c             	mov    0xc(%ebp),%eax
  104738:	89 44 24 04          	mov    %eax,0x4(%esp)
  10473c:	8b 45 08             	mov    0x8(%ebp),%eax
  10473f:	89 04 24             	mov    %eax,(%esp)
  104742:	e8 a5 fe ff ff       	call   1045ec <get_pte>
  104747:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  10474a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10474e:	74 08                	je     104758 <get_page+0x31>
        *ptep_store = ptep;
  104750:	8b 45 10             	mov    0x10(%ebp),%eax
  104753:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104756:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  104758:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10475c:	74 1b                	je     104779 <get_page+0x52>
  10475e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104761:	8b 00                	mov    (%eax),%eax
  104763:	83 e0 01             	and    $0x1,%eax
  104766:	85 c0                	test   %eax,%eax
  104768:	74 0f                	je     104779 <get_page+0x52>
        return pte2page(*ptep);
  10476a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10476d:	8b 00                	mov    (%eax),%eax
  10476f:	89 04 24             	mov    %eax,(%esp)
  104772:	e8 79 f5 ff ff       	call   103cf0 <pte2page>
  104777:	eb 05                	jmp    10477e <get_page+0x57>
    }
    return NULL;
  104779:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10477e:	89 ec                	mov    %ebp,%esp
  104780:	5d                   	pop    %ebp
  104781:	c3                   	ret    

00104782 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  104782:	55                   	push   %ebp
  104783:	89 e5                	mov    %esp,%ebp
  104785:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    if (*ptep & PTE_P) {
  104788:	8b 45 10             	mov    0x10(%ebp),%eax
  10478b:	8b 00                	mov    (%eax),%eax
  10478d:	83 e0 01             	and    $0x1,%eax
  104790:	85 c0                	test   %eax,%eax
  104792:	74 4d                	je     1047e1 <page_remove_pte+0x5f>
        struct Page *page = pte2page(*ptep);
  104794:	8b 45 10             	mov    0x10(%ebp),%eax
  104797:	8b 00                	mov    (%eax),%eax
  104799:	89 04 24             	mov    %eax,(%esp)
  10479c:	e8 4f f5 ff ff       	call   103cf0 <pte2page>
  1047a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (page_ref_dec(page) == 0) {
  1047a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1047a7:	89 04 24             	mov    %eax,(%esp)
  1047aa:	e8 ca f5 ff ff       	call   103d79 <page_ref_dec>
  1047af:	85 c0                	test   %eax,%eax
  1047b1:	75 13                	jne    1047c6 <page_remove_pte+0x44>
            free_page(page);
  1047b3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1047ba:	00 
  1047bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1047be:	89 04 24             	mov    %eax,(%esp)
  1047c1:	e8 ce f7 ff ff       	call   103f94 <free_pages>
        }
        *ptep = 0;
  1047c6:	8b 45 10             	mov    0x10(%ebp),%eax
  1047c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la);
  1047cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1047d2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1047d6:	8b 45 08             	mov    0x8(%ebp),%eax
  1047d9:	89 04 24             	mov    %eax,(%esp)
  1047dc:	e8 07 01 00 00       	call   1048e8 <tlb_invalidate>
    }
}
  1047e1:	90                   	nop
  1047e2:	89 ec                	mov    %ebp,%esp
  1047e4:	5d                   	pop    %ebp
  1047e5:	c3                   	ret    

001047e6 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  1047e6:	55                   	push   %ebp
  1047e7:	89 e5                	mov    %esp,%ebp
  1047e9:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  1047ec:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1047f3:	00 
  1047f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1047f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1047fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1047fe:	89 04 24             	mov    %eax,(%esp)
  104801:	e8 e6 fd ff ff       	call   1045ec <get_pte>
  104806:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
  104809:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10480d:	74 19                	je     104828 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
  10480f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104812:	89 44 24 08          	mov    %eax,0x8(%esp)
  104816:	8b 45 0c             	mov    0xc(%ebp),%eax
  104819:	89 44 24 04          	mov    %eax,0x4(%esp)
  10481d:	8b 45 08             	mov    0x8(%ebp),%eax
  104820:	89 04 24             	mov    %eax,(%esp)
  104823:	e8 5a ff ff ff       	call   104782 <page_remove_pte>
    }
}
  104828:	90                   	nop
  104829:	89 ec                	mov    %ebp,%esp
  10482b:	5d                   	pop    %ebp
  10482c:	c3                   	ret    

0010482d <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  10482d:	55                   	push   %ebp
  10482e:	89 e5                	mov    %esp,%ebp
  104830:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  104833:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  10483a:	00 
  10483b:	8b 45 10             	mov    0x10(%ebp),%eax
  10483e:	89 44 24 04          	mov    %eax,0x4(%esp)
  104842:	8b 45 08             	mov    0x8(%ebp),%eax
  104845:	89 04 24             	mov    %eax,(%esp)
  104848:	e8 9f fd ff ff       	call   1045ec <get_pte>
  10484d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  104850:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104854:	75 0a                	jne    104860 <page_insert+0x33>
        return -E_NO_MEM;
  104856:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  10485b:	e9 84 00 00 00       	jmp    1048e4 <page_insert+0xb7>
    }
    page_ref_inc(page);
  104860:	8b 45 0c             	mov    0xc(%ebp),%eax
  104863:	89 04 24             	mov    %eax,(%esp)
  104866:	e8 f7 f4 ff ff       	call   103d62 <page_ref_inc>
    if (*ptep & PTE_P) {
  10486b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10486e:	8b 00                	mov    (%eax),%eax
  104870:	83 e0 01             	and    $0x1,%eax
  104873:	85 c0                	test   %eax,%eax
  104875:	74 3e                	je     1048b5 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
  104877:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10487a:	8b 00                	mov    (%eax),%eax
  10487c:	89 04 24             	mov    %eax,(%esp)
  10487f:	e8 6c f4 ff ff       	call   103cf0 <pte2page>
  104884:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  104887:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10488a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10488d:	75 0d                	jne    10489c <page_insert+0x6f>
            page_ref_dec(page);
  10488f:	8b 45 0c             	mov    0xc(%ebp),%eax
  104892:	89 04 24             	mov    %eax,(%esp)
  104895:	e8 df f4 ff ff       	call   103d79 <page_ref_dec>
  10489a:	eb 19                	jmp    1048b5 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  10489c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10489f:	89 44 24 08          	mov    %eax,0x8(%esp)
  1048a3:	8b 45 10             	mov    0x10(%ebp),%eax
  1048a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1048aa:	8b 45 08             	mov    0x8(%ebp),%eax
  1048ad:	89 04 24             	mov    %eax,(%esp)
  1048b0:	e8 cd fe ff ff       	call   104782 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  1048b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1048b8:	89 04 24             	mov    %eax,(%esp)
  1048bb:	e8 71 f3 ff ff       	call   103c31 <page2pa>
  1048c0:	0b 45 14             	or     0x14(%ebp),%eax
  1048c3:	83 c8 01             	or     $0x1,%eax
  1048c6:	89 c2                	mov    %eax,%edx
  1048c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1048cb:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  1048cd:	8b 45 10             	mov    0x10(%ebp),%eax
  1048d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1048d4:	8b 45 08             	mov    0x8(%ebp),%eax
  1048d7:	89 04 24             	mov    %eax,(%esp)
  1048da:	e8 09 00 00 00       	call   1048e8 <tlb_invalidate>
    return 0;
  1048df:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1048e4:	89 ec                	mov    %ebp,%esp
  1048e6:	5d                   	pop    %ebp
  1048e7:	c3                   	ret    

001048e8 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  1048e8:	55                   	push   %ebp
  1048e9:	89 e5                	mov    %esp,%ebp
  1048eb:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  1048ee:	0f 20 d8             	mov    %cr3,%eax
  1048f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
  1048f4:	8b 55 f0             	mov    -0x10(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
  1048f7:	8b 45 08             	mov    0x8(%ebp),%eax
  1048fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1048fd:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  104904:	77 23                	ja     104929 <tlb_invalidate+0x41>
  104906:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104909:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10490d:	c7 44 24 08 00 6d 10 	movl   $0x106d00,0x8(%esp)
  104914:	00 
  104915:	c7 44 24 04 d7 01 00 	movl   $0x1d7,0x4(%esp)
  10491c:	00 
  10491d:	c7 04 24 24 6d 10 00 	movl   $0x106d24,(%esp)
  104924:	e8 b2 c3 ff ff       	call   100cdb <__panic>
  104929:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10492c:	05 00 00 00 40       	add    $0x40000000,%eax
  104931:	39 d0                	cmp    %edx,%eax
  104933:	75 0d                	jne    104942 <tlb_invalidate+0x5a>
        invlpg((void *)la);
  104935:	8b 45 0c             	mov    0xc(%ebp),%eax
  104938:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  10493b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10493e:	0f 01 38             	invlpg (%eax)
}
  104941:	90                   	nop
    }
}
  104942:	90                   	nop
  104943:	89 ec                	mov    %ebp,%esp
  104945:	5d                   	pop    %ebp
  104946:	c3                   	ret    

00104947 <check_alloc_page>:

static void
check_alloc_page(void) {
  104947:	55                   	push   %ebp
  104948:	89 e5                	mov    %esp,%ebp
  10494a:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
  10494d:	a1 ac ce 11 00       	mov    0x11ceac,%eax
  104952:	8b 40 18             	mov    0x18(%eax),%eax
  104955:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  104957:	c7 04 24 84 6d 10 00 	movl   $0x106d84,(%esp)
  10495e:	e8 f3 b9 ff ff       	call   100356 <cprintf>
}
  104963:	90                   	nop
  104964:	89 ec                	mov    %ebp,%esp
  104966:	5d                   	pop    %ebp
  104967:	c3                   	ret    

00104968 <check_pgdir>:

static void
check_pgdir(void) {
  104968:	55                   	push   %ebp
  104969:	89 e5                	mov    %esp,%ebp
  10496b:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  10496e:	a1 a4 ce 11 00       	mov    0x11cea4,%eax
  104973:	3d 00 80 03 00       	cmp    $0x38000,%eax
  104978:	76 24                	jbe    10499e <check_pgdir+0x36>
  10497a:	c7 44 24 0c a3 6d 10 	movl   $0x106da3,0xc(%esp)
  104981:	00 
  104982:	c7 44 24 08 49 6d 10 	movl   $0x106d49,0x8(%esp)
  104989:	00 
  10498a:	c7 44 24 04 e4 01 00 	movl   $0x1e4,0x4(%esp)
  104991:	00 
  104992:	c7 04 24 24 6d 10 00 	movl   $0x106d24,(%esp)
  104999:	e8 3d c3 ff ff       	call   100cdb <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  10499e:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  1049a3:	85 c0                	test   %eax,%eax
  1049a5:	74 0e                	je     1049b5 <check_pgdir+0x4d>
  1049a7:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  1049ac:	25 ff 0f 00 00       	and    $0xfff,%eax
  1049b1:	85 c0                	test   %eax,%eax
  1049b3:	74 24                	je     1049d9 <check_pgdir+0x71>
  1049b5:	c7 44 24 0c c0 6d 10 	movl   $0x106dc0,0xc(%esp)
  1049bc:	00 
  1049bd:	c7 44 24 08 49 6d 10 	movl   $0x106d49,0x8(%esp)
  1049c4:	00 
  1049c5:	c7 44 24 04 e5 01 00 	movl   $0x1e5,0x4(%esp)
  1049cc:	00 
  1049cd:	c7 04 24 24 6d 10 00 	movl   $0x106d24,(%esp)
  1049d4:	e8 02 c3 ff ff       	call   100cdb <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  1049d9:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  1049de:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1049e5:	00 
  1049e6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1049ed:	00 
  1049ee:	89 04 24             	mov    %eax,(%esp)
  1049f1:	e8 31 fd ff ff       	call   104727 <get_page>
  1049f6:	85 c0                	test   %eax,%eax
  1049f8:	74 24                	je     104a1e <check_pgdir+0xb6>
  1049fa:	c7 44 24 0c f8 6d 10 	movl   $0x106df8,0xc(%esp)
  104a01:	00 
  104a02:	c7 44 24 08 49 6d 10 	movl   $0x106d49,0x8(%esp)
  104a09:	00 
  104a0a:	c7 44 24 04 e6 01 00 	movl   $0x1e6,0x4(%esp)
  104a11:	00 
  104a12:	c7 04 24 24 6d 10 00 	movl   $0x106d24,(%esp)
  104a19:	e8 bd c2 ff ff       	call   100cdb <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  104a1e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104a25:	e8 30 f5 ff ff       	call   103f5a <alloc_pages>
  104a2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  104a2d:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  104a32:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104a39:	00 
  104a3a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104a41:	00 
  104a42:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104a45:	89 54 24 04          	mov    %edx,0x4(%esp)
  104a49:	89 04 24             	mov    %eax,(%esp)
  104a4c:	e8 dc fd ff ff       	call   10482d <page_insert>
  104a51:	85 c0                	test   %eax,%eax
  104a53:	74 24                	je     104a79 <check_pgdir+0x111>
  104a55:	c7 44 24 0c 20 6e 10 	movl   $0x106e20,0xc(%esp)
  104a5c:	00 
  104a5d:	c7 44 24 08 49 6d 10 	movl   $0x106d49,0x8(%esp)
  104a64:	00 
  104a65:	c7 44 24 04 ea 01 00 	movl   $0x1ea,0x4(%esp)
  104a6c:	00 
  104a6d:	c7 04 24 24 6d 10 00 	movl   $0x106d24,(%esp)
  104a74:	e8 62 c2 ff ff       	call   100cdb <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  104a79:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  104a7e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104a85:	00 
  104a86:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104a8d:	00 
  104a8e:	89 04 24             	mov    %eax,(%esp)
  104a91:	e8 56 fb ff ff       	call   1045ec <get_pte>
  104a96:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104a99:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104a9d:	75 24                	jne    104ac3 <check_pgdir+0x15b>
  104a9f:	c7 44 24 0c 4c 6e 10 	movl   $0x106e4c,0xc(%esp)
  104aa6:	00 
  104aa7:	c7 44 24 08 49 6d 10 	movl   $0x106d49,0x8(%esp)
  104aae:	00 
  104aaf:	c7 44 24 04 ed 01 00 	movl   $0x1ed,0x4(%esp)
  104ab6:	00 
  104ab7:	c7 04 24 24 6d 10 00 	movl   $0x106d24,(%esp)
  104abe:	e8 18 c2 ff ff       	call   100cdb <__panic>
    assert(pte2page(*ptep) == p1);
  104ac3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104ac6:	8b 00                	mov    (%eax),%eax
  104ac8:	89 04 24             	mov    %eax,(%esp)
  104acb:	e8 20 f2 ff ff       	call   103cf0 <pte2page>
  104ad0:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  104ad3:	74 24                	je     104af9 <check_pgdir+0x191>
  104ad5:	c7 44 24 0c 79 6e 10 	movl   $0x106e79,0xc(%esp)
  104adc:	00 
  104add:	c7 44 24 08 49 6d 10 	movl   $0x106d49,0x8(%esp)
  104ae4:	00 
  104ae5:	c7 44 24 04 ee 01 00 	movl   $0x1ee,0x4(%esp)
  104aec:	00 
  104aed:	c7 04 24 24 6d 10 00 	movl   $0x106d24,(%esp)
  104af4:	e8 e2 c1 ff ff       	call   100cdb <__panic>
    assert(page_ref(p1) == 1);
  104af9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104afc:	89 04 24             	mov    %eax,(%esp)
  104aff:	e8 46 f2 ff ff       	call   103d4a <page_ref>
  104b04:	83 f8 01             	cmp    $0x1,%eax
  104b07:	74 24                	je     104b2d <check_pgdir+0x1c5>
  104b09:	c7 44 24 0c 8f 6e 10 	movl   $0x106e8f,0xc(%esp)
  104b10:	00 
  104b11:	c7 44 24 08 49 6d 10 	movl   $0x106d49,0x8(%esp)
  104b18:	00 
  104b19:	c7 44 24 04 ef 01 00 	movl   $0x1ef,0x4(%esp)
  104b20:	00 
  104b21:	c7 04 24 24 6d 10 00 	movl   $0x106d24,(%esp)
  104b28:	e8 ae c1 ff ff       	call   100cdb <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  104b2d:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  104b32:	8b 00                	mov    (%eax),%eax
  104b34:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104b39:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104b3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104b3f:	c1 e8 0c             	shr    $0xc,%eax
  104b42:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104b45:	a1 a4 ce 11 00       	mov    0x11cea4,%eax
  104b4a:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  104b4d:	72 23                	jb     104b72 <check_pgdir+0x20a>
  104b4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104b52:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104b56:	c7 44 24 08 5c 6c 10 	movl   $0x106c5c,0x8(%esp)
  104b5d:	00 
  104b5e:	c7 44 24 04 f1 01 00 	movl   $0x1f1,0x4(%esp)
  104b65:	00 
  104b66:	c7 04 24 24 6d 10 00 	movl   $0x106d24,(%esp)
  104b6d:	e8 69 c1 ff ff       	call   100cdb <__panic>
  104b72:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104b75:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104b7a:	83 c0 04             	add    $0x4,%eax
  104b7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  104b80:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  104b85:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104b8c:	00 
  104b8d:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104b94:	00 
  104b95:	89 04 24             	mov    %eax,(%esp)
  104b98:	e8 4f fa ff ff       	call   1045ec <get_pte>
  104b9d:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  104ba0:	74 24                	je     104bc6 <check_pgdir+0x25e>
  104ba2:	c7 44 24 0c a4 6e 10 	movl   $0x106ea4,0xc(%esp)
  104ba9:	00 
  104baa:	c7 44 24 08 49 6d 10 	movl   $0x106d49,0x8(%esp)
  104bb1:	00 
  104bb2:	c7 44 24 04 f2 01 00 	movl   $0x1f2,0x4(%esp)
  104bb9:	00 
  104bba:	c7 04 24 24 6d 10 00 	movl   $0x106d24,(%esp)
  104bc1:	e8 15 c1 ff ff       	call   100cdb <__panic>

    p2 = alloc_page();
  104bc6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104bcd:	e8 88 f3 ff ff       	call   103f5a <alloc_pages>
  104bd2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  104bd5:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  104bda:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  104be1:	00 
  104be2:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104be9:	00 
  104bea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104bed:	89 54 24 04          	mov    %edx,0x4(%esp)
  104bf1:	89 04 24             	mov    %eax,(%esp)
  104bf4:	e8 34 fc ff ff       	call   10482d <page_insert>
  104bf9:	85 c0                	test   %eax,%eax
  104bfb:	74 24                	je     104c21 <check_pgdir+0x2b9>
  104bfd:	c7 44 24 0c cc 6e 10 	movl   $0x106ecc,0xc(%esp)
  104c04:	00 
  104c05:	c7 44 24 08 49 6d 10 	movl   $0x106d49,0x8(%esp)
  104c0c:	00 
  104c0d:	c7 44 24 04 f5 01 00 	movl   $0x1f5,0x4(%esp)
  104c14:	00 
  104c15:	c7 04 24 24 6d 10 00 	movl   $0x106d24,(%esp)
  104c1c:	e8 ba c0 ff ff       	call   100cdb <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104c21:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  104c26:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104c2d:	00 
  104c2e:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104c35:	00 
  104c36:	89 04 24             	mov    %eax,(%esp)
  104c39:	e8 ae f9 ff ff       	call   1045ec <get_pte>
  104c3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104c41:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104c45:	75 24                	jne    104c6b <check_pgdir+0x303>
  104c47:	c7 44 24 0c 04 6f 10 	movl   $0x106f04,0xc(%esp)
  104c4e:	00 
  104c4f:	c7 44 24 08 49 6d 10 	movl   $0x106d49,0x8(%esp)
  104c56:	00 
  104c57:	c7 44 24 04 f6 01 00 	movl   $0x1f6,0x4(%esp)
  104c5e:	00 
  104c5f:	c7 04 24 24 6d 10 00 	movl   $0x106d24,(%esp)
  104c66:	e8 70 c0 ff ff       	call   100cdb <__panic>
    assert(*ptep & PTE_U);
  104c6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104c6e:	8b 00                	mov    (%eax),%eax
  104c70:	83 e0 04             	and    $0x4,%eax
  104c73:	85 c0                	test   %eax,%eax
  104c75:	75 24                	jne    104c9b <check_pgdir+0x333>
  104c77:	c7 44 24 0c 34 6f 10 	movl   $0x106f34,0xc(%esp)
  104c7e:	00 
  104c7f:	c7 44 24 08 49 6d 10 	movl   $0x106d49,0x8(%esp)
  104c86:	00 
  104c87:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
  104c8e:	00 
  104c8f:	c7 04 24 24 6d 10 00 	movl   $0x106d24,(%esp)
  104c96:	e8 40 c0 ff ff       	call   100cdb <__panic>
    assert(*ptep & PTE_W);
  104c9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104c9e:	8b 00                	mov    (%eax),%eax
  104ca0:	83 e0 02             	and    $0x2,%eax
  104ca3:	85 c0                	test   %eax,%eax
  104ca5:	75 24                	jne    104ccb <check_pgdir+0x363>
  104ca7:	c7 44 24 0c 42 6f 10 	movl   $0x106f42,0xc(%esp)
  104cae:	00 
  104caf:	c7 44 24 08 49 6d 10 	movl   $0x106d49,0x8(%esp)
  104cb6:	00 
  104cb7:	c7 44 24 04 f8 01 00 	movl   $0x1f8,0x4(%esp)
  104cbe:	00 
  104cbf:	c7 04 24 24 6d 10 00 	movl   $0x106d24,(%esp)
  104cc6:	e8 10 c0 ff ff       	call   100cdb <__panic>
    assert(boot_pgdir[0] & PTE_U);
  104ccb:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  104cd0:	8b 00                	mov    (%eax),%eax
  104cd2:	83 e0 04             	and    $0x4,%eax
  104cd5:	85 c0                	test   %eax,%eax
  104cd7:	75 24                	jne    104cfd <check_pgdir+0x395>
  104cd9:	c7 44 24 0c 50 6f 10 	movl   $0x106f50,0xc(%esp)
  104ce0:	00 
  104ce1:	c7 44 24 08 49 6d 10 	movl   $0x106d49,0x8(%esp)
  104ce8:	00 
  104ce9:	c7 44 24 04 f9 01 00 	movl   $0x1f9,0x4(%esp)
  104cf0:	00 
  104cf1:	c7 04 24 24 6d 10 00 	movl   $0x106d24,(%esp)
  104cf8:	e8 de bf ff ff       	call   100cdb <__panic>
    assert(page_ref(p2) == 1);
  104cfd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104d00:	89 04 24             	mov    %eax,(%esp)
  104d03:	e8 42 f0 ff ff       	call   103d4a <page_ref>
  104d08:	83 f8 01             	cmp    $0x1,%eax
  104d0b:	74 24                	je     104d31 <check_pgdir+0x3c9>
  104d0d:	c7 44 24 0c 66 6f 10 	movl   $0x106f66,0xc(%esp)
  104d14:	00 
  104d15:	c7 44 24 08 49 6d 10 	movl   $0x106d49,0x8(%esp)
  104d1c:	00 
  104d1d:	c7 44 24 04 fa 01 00 	movl   $0x1fa,0x4(%esp)
  104d24:	00 
  104d25:	c7 04 24 24 6d 10 00 	movl   $0x106d24,(%esp)
  104d2c:	e8 aa bf ff ff       	call   100cdb <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  104d31:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  104d36:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104d3d:	00 
  104d3e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104d45:	00 
  104d46:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104d49:	89 54 24 04          	mov    %edx,0x4(%esp)
  104d4d:	89 04 24             	mov    %eax,(%esp)
  104d50:	e8 d8 fa ff ff       	call   10482d <page_insert>
  104d55:	85 c0                	test   %eax,%eax
  104d57:	74 24                	je     104d7d <check_pgdir+0x415>
  104d59:	c7 44 24 0c 78 6f 10 	movl   $0x106f78,0xc(%esp)
  104d60:	00 
  104d61:	c7 44 24 08 49 6d 10 	movl   $0x106d49,0x8(%esp)
  104d68:	00 
  104d69:	c7 44 24 04 fc 01 00 	movl   $0x1fc,0x4(%esp)
  104d70:	00 
  104d71:	c7 04 24 24 6d 10 00 	movl   $0x106d24,(%esp)
  104d78:	e8 5e bf ff ff       	call   100cdb <__panic>
    assert(page_ref(p1) == 2);
  104d7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104d80:	89 04 24             	mov    %eax,(%esp)
  104d83:	e8 c2 ef ff ff       	call   103d4a <page_ref>
  104d88:	83 f8 02             	cmp    $0x2,%eax
  104d8b:	74 24                	je     104db1 <check_pgdir+0x449>
  104d8d:	c7 44 24 0c a4 6f 10 	movl   $0x106fa4,0xc(%esp)
  104d94:	00 
  104d95:	c7 44 24 08 49 6d 10 	movl   $0x106d49,0x8(%esp)
  104d9c:	00 
  104d9d:	c7 44 24 04 fd 01 00 	movl   $0x1fd,0x4(%esp)
  104da4:	00 
  104da5:	c7 04 24 24 6d 10 00 	movl   $0x106d24,(%esp)
  104dac:	e8 2a bf ff ff       	call   100cdb <__panic>
    assert(page_ref(p2) == 0);
  104db1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104db4:	89 04 24             	mov    %eax,(%esp)
  104db7:	e8 8e ef ff ff       	call   103d4a <page_ref>
  104dbc:	85 c0                	test   %eax,%eax
  104dbe:	74 24                	je     104de4 <check_pgdir+0x47c>
  104dc0:	c7 44 24 0c b6 6f 10 	movl   $0x106fb6,0xc(%esp)
  104dc7:	00 
  104dc8:	c7 44 24 08 49 6d 10 	movl   $0x106d49,0x8(%esp)
  104dcf:	00 
  104dd0:	c7 44 24 04 fe 01 00 	movl   $0x1fe,0x4(%esp)
  104dd7:	00 
  104dd8:	c7 04 24 24 6d 10 00 	movl   $0x106d24,(%esp)
  104ddf:	e8 f7 be ff ff       	call   100cdb <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104de4:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  104de9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104df0:	00 
  104df1:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104df8:	00 
  104df9:	89 04 24             	mov    %eax,(%esp)
  104dfc:	e8 eb f7 ff ff       	call   1045ec <get_pte>
  104e01:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104e04:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104e08:	75 24                	jne    104e2e <check_pgdir+0x4c6>
  104e0a:	c7 44 24 0c 04 6f 10 	movl   $0x106f04,0xc(%esp)
  104e11:	00 
  104e12:	c7 44 24 08 49 6d 10 	movl   $0x106d49,0x8(%esp)
  104e19:	00 
  104e1a:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
  104e21:	00 
  104e22:	c7 04 24 24 6d 10 00 	movl   $0x106d24,(%esp)
  104e29:	e8 ad be ff ff       	call   100cdb <__panic>
    assert(pte2page(*ptep) == p1);
  104e2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104e31:	8b 00                	mov    (%eax),%eax
  104e33:	89 04 24             	mov    %eax,(%esp)
  104e36:	e8 b5 ee ff ff       	call   103cf0 <pte2page>
  104e3b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  104e3e:	74 24                	je     104e64 <check_pgdir+0x4fc>
  104e40:	c7 44 24 0c 79 6e 10 	movl   $0x106e79,0xc(%esp)
  104e47:	00 
  104e48:	c7 44 24 08 49 6d 10 	movl   $0x106d49,0x8(%esp)
  104e4f:	00 
  104e50:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
  104e57:	00 
  104e58:	c7 04 24 24 6d 10 00 	movl   $0x106d24,(%esp)
  104e5f:	e8 77 be ff ff       	call   100cdb <__panic>
    assert((*ptep & PTE_U) == 0);
  104e64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104e67:	8b 00                	mov    (%eax),%eax
  104e69:	83 e0 04             	and    $0x4,%eax
  104e6c:	85 c0                	test   %eax,%eax
  104e6e:	74 24                	je     104e94 <check_pgdir+0x52c>
  104e70:	c7 44 24 0c c8 6f 10 	movl   $0x106fc8,0xc(%esp)
  104e77:	00 
  104e78:	c7 44 24 08 49 6d 10 	movl   $0x106d49,0x8(%esp)
  104e7f:	00 
  104e80:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
  104e87:	00 
  104e88:	c7 04 24 24 6d 10 00 	movl   $0x106d24,(%esp)
  104e8f:	e8 47 be ff ff       	call   100cdb <__panic>

    page_remove(boot_pgdir, 0x0);
  104e94:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  104e99:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104ea0:	00 
  104ea1:	89 04 24             	mov    %eax,(%esp)
  104ea4:	e8 3d f9 ff ff       	call   1047e6 <page_remove>
    assert(page_ref(p1) == 1);
  104ea9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104eac:	89 04 24             	mov    %eax,(%esp)
  104eaf:	e8 96 ee ff ff       	call   103d4a <page_ref>
  104eb4:	83 f8 01             	cmp    $0x1,%eax
  104eb7:	74 24                	je     104edd <check_pgdir+0x575>
  104eb9:	c7 44 24 0c 8f 6e 10 	movl   $0x106e8f,0xc(%esp)
  104ec0:	00 
  104ec1:	c7 44 24 08 49 6d 10 	movl   $0x106d49,0x8(%esp)
  104ec8:	00 
  104ec9:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
  104ed0:	00 
  104ed1:	c7 04 24 24 6d 10 00 	movl   $0x106d24,(%esp)
  104ed8:	e8 fe bd ff ff       	call   100cdb <__panic>
    assert(page_ref(p2) == 0);
  104edd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104ee0:	89 04 24             	mov    %eax,(%esp)
  104ee3:	e8 62 ee ff ff       	call   103d4a <page_ref>
  104ee8:	85 c0                	test   %eax,%eax
  104eea:	74 24                	je     104f10 <check_pgdir+0x5a8>
  104eec:	c7 44 24 0c b6 6f 10 	movl   $0x106fb6,0xc(%esp)
  104ef3:	00 
  104ef4:	c7 44 24 08 49 6d 10 	movl   $0x106d49,0x8(%esp)
  104efb:	00 
  104efc:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
  104f03:	00 
  104f04:	c7 04 24 24 6d 10 00 	movl   $0x106d24,(%esp)
  104f0b:	e8 cb bd ff ff       	call   100cdb <__panic>

    page_remove(boot_pgdir, PGSIZE);
  104f10:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  104f15:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104f1c:	00 
  104f1d:	89 04 24             	mov    %eax,(%esp)
  104f20:	e8 c1 f8 ff ff       	call   1047e6 <page_remove>
    assert(page_ref(p1) == 0);
  104f25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104f28:	89 04 24             	mov    %eax,(%esp)
  104f2b:	e8 1a ee ff ff       	call   103d4a <page_ref>
  104f30:	85 c0                	test   %eax,%eax
  104f32:	74 24                	je     104f58 <check_pgdir+0x5f0>
  104f34:	c7 44 24 0c dd 6f 10 	movl   $0x106fdd,0xc(%esp)
  104f3b:	00 
  104f3c:	c7 44 24 08 49 6d 10 	movl   $0x106d49,0x8(%esp)
  104f43:	00 
  104f44:	c7 44 24 04 08 02 00 	movl   $0x208,0x4(%esp)
  104f4b:	00 
  104f4c:	c7 04 24 24 6d 10 00 	movl   $0x106d24,(%esp)
  104f53:	e8 83 bd ff ff       	call   100cdb <__panic>
    assert(page_ref(p2) == 0);
  104f58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104f5b:	89 04 24             	mov    %eax,(%esp)
  104f5e:	e8 e7 ed ff ff       	call   103d4a <page_ref>
  104f63:	85 c0                	test   %eax,%eax
  104f65:	74 24                	je     104f8b <check_pgdir+0x623>
  104f67:	c7 44 24 0c b6 6f 10 	movl   $0x106fb6,0xc(%esp)
  104f6e:	00 
  104f6f:	c7 44 24 08 49 6d 10 	movl   $0x106d49,0x8(%esp)
  104f76:	00 
  104f77:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
  104f7e:	00 
  104f7f:	c7 04 24 24 6d 10 00 	movl   $0x106d24,(%esp)
  104f86:	e8 50 bd ff ff       	call   100cdb <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
  104f8b:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  104f90:	8b 00                	mov    (%eax),%eax
  104f92:	89 04 24             	mov    %eax,(%esp)
  104f95:	e8 96 ed ff ff       	call   103d30 <pde2page>
  104f9a:	89 04 24             	mov    %eax,(%esp)
  104f9d:	e8 a8 ed ff ff       	call   103d4a <page_ref>
  104fa2:	83 f8 01             	cmp    $0x1,%eax
  104fa5:	74 24                	je     104fcb <check_pgdir+0x663>
  104fa7:	c7 44 24 0c f0 6f 10 	movl   $0x106ff0,0xc(%esp)
  104fae:	00 
  104faf:	c7 44 24 08 49 6d 10 	movl   $0x106d49,0x8(%esp)
  104fb6:	00 
  104fb7:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
  104fbe:	00 
  104fbf:	c7 04 24 24 6d 10 00 	movl   $0x106d24,(%esp)
  104fc6:	e8 10 bd ff ff       	call   100cdb <__panic>
    free_page(pde2page(boot_pgdir[0]));
  104fcb:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  104fd0:	8b 00                	mov    (%eax),%eax
  104fd2:	89 04 24             	mov    %eax,(%esp)
  104fd5:	e8 56 ed ff ff       	call   103d30 <pde2page>
  104fda:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104fe1:	00 
  104fe2:	89 04 24             	mov    %eax,(%esp)
  104fe5:	e8 aa ef ff ff       	call   103f94 <free_pages>
    boot_pgdir[0] = 0;
  104fea:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  104fef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  104ff5:	c7 04 24 17 70 10 00 	movl   $0x107017,(%esp)
  104ffc:	e8 55 b3 ff ff       	call   100356 <cprintf>
}
  105001:	90                   	nop
  105002:	89 ec                	mov    %ebp,%esp
  105004:	5d                   	pop    %ebp
  105005:	c3                   	ret    

00105006 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  105006:	55                   	push   %ebp
  105007:	89 e5                	mov    %esp,%ebp
  105009:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  10500c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  105013:	e9 ca 00 00 00       	jmp    1050e2 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  105018:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10501b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10501e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105021:	c1 e8 0c             	shr    $0xc,%eax
  105024:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105027:	a1 a4 ce 11 00       	mov    0x11cea4,%eax
  10502c:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  10502f:	72 23                	jb     105054 <check_boot_pgdir+0x4e>
  105031:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105034:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105038:	c7 44 24 08 5c 6c 10 	movl   $0x106c5c,0x8(%esp)
  10503f:	00 
  105040:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
  105047:	00 
  105048:	c7 04 24 24 6d 10 00 	movl   $0x106d24,(%esp)
  10504f:	e8 87 bc ff ff       	call   100cdb <__panic>
  105054:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105057:	2d 00 00 00 40       	sub    $0x40000000,%eax
  10505c:	89 c2                	mov    %eax,%edx
  10505e:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  105063:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10506a:	00 
  10506b:	89 54 24 04          	mov    %edx,0x4(%esp)
  10506f:	89 04 24             	mov    %eax,(%esp)
  105072:	e8 75 f5 ff ff       	call   1045ec <get_pte>
  105077:	89 45 dc             	mov    %eax,-0x24(%ebp)
  10507a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  10507e:	75 24                	jne    1050a4 <check_boot_pgdir+0x9e>
  105080:	c7 44 24 0c 34 70 10 	movl   $0x107034,0xc(%esp)
  105087:	00 
  105088:	c7 44 24 08 49 6d 10 	movl   $0x106d49,0x8(%esp)
  10508f:	00 
  105090:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
  105097:	00 
  105098:	c7 04 24 24 6d 10 00 	movl   $0x106d24,(%esp)
  10509f:	e8 37 bc ff ff       	call   100cdb <__panic>
        assert(PTE_ADDR(*ptep) == i);
  1050a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1050a7:	8b 00                	mov    (%eax),%eax
  1050a9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1050ae:	89 c2                	mov    %eax,%edx
  1050b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1050b3:	39 c2                	cmp    %eax,%edx
  1050b5:	74 24                	je     1050db <check_boot_pgdir+0xd5>
  1050b7:	c7 44 24 0c 71 70 10 	movl   $0x107071,0xc(%esp)
  1050be:	00 
  1050bf:	c7 44 24 08 49 6d 10 	movl   $0x106d49,0x8(%esp)
  1050c6:	00 
  1050c7:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
  1050ce:	00 
  1050cf:	c7 04 24 24 6d 10 00 	movl   $0x106d24,(%esp)
  1050d6:	e8 00 bc ff ff       	call   100cdb <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
  1050db:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  1050e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1050e5:	a1 a4 ce 11 00       	mov    0x11cea4,%eax
  1050ea:	39 c2                	cmp    %eax,%edx
  1050ec:	0f 82 26 ff ff ff    	jb     105018 <check_boot_pgdir+0x12>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  1050f2:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  1050f7:	05 ac 0f 00 00       	add    $0xfac,%eax
  1050fc:	8b 00                	mov    (%eax),%eax
  1050fe:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  105103:	89 c2                	mov    %eax,%edx
  105105:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  10510a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10510d:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  105114:	77 23                	ja     105139 <check_boot_pgdir+0x133>
  105116:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105119:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10511d:	c7 44 24 08 00 6d 10 	movl   $0x106d00,0x8(%esp)
  105124:	00 
  105125:	c7 44 24 04 1b 02 00 	movl   $0x21b,0x4(%esp)
  10512c:	00 
  10512d:	c7 04 24 24 6d 10 00 	movl   $0x106d24,(%esp)
  105134:	e8 a2 bb ff ff       	call   100cdb <__panic>
  105139:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10513c:	05 00 00 00 40       	add    $0x40000000,%eax
  105141:	39 d0                	cmp    %edx,%eax
  105143:	74 24                	je     105169 <check_boot_pgdir+0x163>
  105145:	c7 44 24 0c 88 70 10 	movl   $0x107088,0xc(%esp)
  10514c:	00 
  10514d:	c7 44 24 08 49 6d 10 	movl   $0x106d49,0x8(%esp)
  105154:	00 
  105155:	c7 44 24 04 1b 02 00 	movl   $0x21b,0x4(%esp)
  10515c:	00 
  10515d:	c7 04 24 24 6d 10 00 	movl   $0x106d24,(%esp)
  105164:	e8 72 bb ff ff       	call   100cdb <__panic>

    assert(boot_pgdir[0] == 0);
  105169:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  10516e:	8b 00                	mov    (%eax),%eax
  105170:	85 c0                	test   %eax,%eax
  105172:	74 24                	je     105198 <check_boot_pgdir+0x192>
  105174:	c7 44 24 0c bc 70 10 	movl   $0x1070bc,0xc(%esp)
  10517b:	00 
  10517c:	c7 44 24 08 49 6d 10 	movl   $0x106d49,0x8(%esp)
  105183:	00 
  105184:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
  10518b:	00 
  10518c:	c7 04 24 24 6d 10 00 	movl   $0x106d24,(%esp)
  105193:	e8 43 bb ff ff       	call   100cdb <__panic>

    struct Page *p;
    p = alloc_page();
  105198:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10519f:	e8 b6 ed ff ff       	call   103f5a <alloc_pages>
  1051a4:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  1051a7:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  1051ac:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  1051b3:	00 
  1051b4:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  1051bb:	00 
  1051bc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1051bf:	89 54 24 04          	mov    %edx,0x4(%esp)
  1051c3:	89 04 24             	mov    %eax,(%esp)
  1051c6:	e8 62 f6 ff ff       	call   10482d <page_insert>
  1051cb:	85 c0                	test   %eax,%eax
  1051cd:	74 24                	je     1051f3 <check_boot_pgdir+0x1ed>
  1051cf:	c7 44 24 0c d0 70 10 	movl   $0x1070d0,0xc(%esp)
  1051d6:	00 
  1051d7:	c7 44 24 08 49 6d 10 	movl   $0x106d49,0x8(%esp)
  1051de:	00 
  1051df:	c7 44 24 04 21 02 00 	movl   $0x221,0x4(%esp)
  1051e6:	00 
  1051e7:	c7 04 24 24 6d 10 00 	movl   $0x106d24,(%esp)
  1051ee:	e8 e8 ba ff ff       	call   100cdb <__panic>
    assert(page_ref(p) == 1);
  1051f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1051f6:	89 04 24             	mov    %eax,(%esp)
  1051f9:	e8 4c eb ff ff       	call   103d4a <page_ref>
  1051fe:	83 f8 01             	cmp    $0x1,%eax
  105201:	74 24                	je     105227 <check_boot_pgdir+0x221>
  105203:	c7 44 24 0c fe 70 10 	movl   $0x1070fe,0xc(%esp)
  10520a:	00 
  10520b:	c7 44 24 08 49 6d 10 	movl   $0x106d49,0x8(%esp)
  105212:	00 
  105213:	c7 44 24 04 22 02 00 	movl   $0x222,0x4(%esp)
  10521a:	00 
  10521b:	c7 04 24 24 6d 10 00 	movl   $0x106d24,(%esp)
  105222:	e8 b4 ba ff ff       	call   100cdb <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  105227:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  10522c:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  105233:	00 
  105234:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
  10523b:	00 
  10523c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10523f:	89 54 24 04          	mov    %edx,0x4(%esp)
  105243:	89 04 24             	mov    %eax,(%esp)
  105246:	e8 e2 f5 ff ff       	call   10482d <page_insert>
  10524b:	85 c0                	test   %eax,%eax
  10524d:	74 24                	je     105273 <check_boot_pgdir+0x26d>
  10524f:	c7 44 24 0c 10 71 10 	movl   $0x107110,0xc(%esp)
  105256:	00 
  105257:	c7 44 24 08 49 6d 10 	movl   $0x106d49,0x8(%esp)
  10525e:	00 
  10525f:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
  105266:	00 
  105267:	c7 04 24 24 6d 10 00 	movl   $0x106d24,(%esp)
  10526e:	e8 68 ba ff ff       	call   100cdb <__panic>
    assert(page_ref(p) == 2);
  105273:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105276:	89 04 24             	mov    %eax,(%esp)
  105279:	e8 cc ea ff ff       	call   103d4a <page_ref>
  10527e:	83 f8 02             	cmp    $0x2,%eax
  105281:	74 24                	je     1052a7 <check_boot_pgdir+0x2a1>
  105283:	c7 44 24 0c 47 71 10 	movl   $0x107147,0xc(%esp)
  10528a:	00 
  10528b:	c7 44 24 08 49 6d 10 	movl   $0x106d49,0x8(%esp)
  105292:	00 
  105293:	c7 44 24 04 24 02 00 	movl   $0x224,0x4(%esp)
  10529a:	00 
  10529b:	c7 04 24 24 6d 10 00 	movl   $0x106d24,(%esp)
  1052a2:	e8 34 ba ff ff       	call   100cdb <__panic>

    const char *str = "ucore: Hello world!!";
  1052a7:	c7 45 e8 58 71 10 00 	movl   $0x107158,-0x18(%ebp)
    strcpy((void *)0x100, str);
  1052ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1052b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1052b5:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  1052bc:	e8 fc 09 00 00       	call   105cbd <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  1052c1:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
  1052c8:	00 
  1052c9:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  1052d0:	e8 60 0a 00 00       	call   105d35 <strcmp>
  1052d5:	85 c0                	test   %eax,%eax
  1052d7:	74 24                	je     1052fd <check_boot_pgdir+0x2f7>
  1052d9:	c7 44 24 0c 70 71 10 	movl   $0x107170,0xc(%esp)
  1052e0:	00 
  1052e1:	c7 44 24 08 49 6d 10 	movl   $0x106d49,0x8(%esp)
  1052e8:	00 
  1052e9:	c7 44 24 04 28 02 00 	movl   $0x228,0x4(%esp)
  1052f0:	00 
  1052f1:	c7 04 24 24 6d 10 00 	movl   $0x106d24,(%esp)
  1052f8:	e8 de b9 ff ff       	call   100cdb <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  1052fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105300:	89 04 24             	mov    %eax,(%esp)
  105303:	e8 92 e9 ff ff       	call   103c9a <page2kva>
  105308:	05 00 01 00 00       	add    $0x100,%eax
  10530d:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  105310:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  105317:	e8 47 09 00 00       	call   105c63 <strlen>
  10531c:	85 c0                	test   %eax,%eax
  10531e:	74 24                	je     105344 <check_boot_pgdir+0x33e>
  105320:	c7 44 24 0c a8 71 10 	movl   $0x1071a8,0xc(%esp)
  105327:	00 
  105328:	c7 44 24 08 49 6d 10 	movl   $0x106d49,0x8(%esp)
  10532f:	00 
  105330:	c7 44 24 04 2b 02 00 	movl   $0x22b,0x4(%esp)
  105337:	00 
  105338:	c7 04 24 24 6d 10 00 	movl   $0x106d24,(%esp)
  10533f:	e8 97 b9 ff ff       	call   100cdb <__panic>

    free_page(p);
  105344:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10534b:	00 
  10534c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10534f:	89 04 24             	mov    %eax,(%esp)
  105352:	e8 3d ec ff ff       	call   103f94 <free_pages>
    free_page(pde2page(boot_pgdir[0]));
  105357:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  10535c:	8b 00                	mov    (%eax),%eax
  10535e:	89 04 24             	mov    %eax,(%esp)
  105361:	e8 ca e9 ff ff       	call   103d30 <pde2page>
  105366:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10536d:	00 
  10536e:	89 04 24             	mov    %eax,(%esp)
  105371:	e8 1e ec ff ff       	call   103f94 <free_pages>
    boot_pgdir[0] = 0;
  105376:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  10537b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  105381:	c7 04 24 cc 71 10 00 	movl   $0x1071cc,(%esp)
  105388:	e8 c9 af ff ff       	call   100356 <cprintf>
}
  10538d:	90                   	nop
  10538e:	89 ec                	mov    %ebp,%esp
  105390:	5d                   	pop    %ebp
  105391:	c3                   	ret    

00105392 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  105392:	55                   	push   %ebp
  105393:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  105395:	8b 45 08             	mov    0x8(%ebp),%eax
  105398:	83 e0 04             	and    $0x4,%eax
  10539b:	85 c0                	test   %eax,%eax
  10539d:	74 04                	je     1053a3 <perm2str+0x11>
  10539f:	b0 75                	mov    $0x75,%al
  1053a1:	eb 02                	jmp    1053a5 <perm2str+0x13>
  1053a3:	b0 2d                	mov    $0x2d,%al
  1053a5:	a2 28 cf 11 00       	mov    %al,0x11cf28
    str[1] = 'r';
  1053aa:	c6 05 29 cf 11 00 72 	movb   $0x72,0x11cf29
    str[2] = (perm & PTE_W) ? 'w' : '-';
  1053b1:	8b 45 08             	mov    0x8(%ebp),%eax
  1053b4:	83 e0 02             	and    $0x2,%eax
  1053b7:	85 c0                	test   %eax,%eax
  1053b9:	74 04                	je     1053bf <perm2str+0x2d>
  1053bb:	b0 77                	mov    $0x77,%al
  1053bd:	eb 02                	jmp    1053c1 <perm2str+0x2f>
  1053bf:	b0 2d                	mov    $0x2d,%al
  1053c1:	a2 2a cf 11 00       	mov    %al,0x11cf2a
    str[3] = '\0';
  1053c6:	c6 05 2b cf 11 00 00 	movb   $0x0,0x11cf2b
    return str;
  1053cd:	b8 28 cf 11 00       	mov    $0x11cf28,%eax
}
  1053d2:	5d                   	pop    %ebp
  1053d3:	c3                   	ret    

001053d4 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  1053d4:	55                   	push   %ebp
  1053d5:	89 e5                	mov    %esp,%ebp
  1053d7:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  1053da:	8b 45 10             	mov    0x10(%ebp),%eax
  1053dd:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1053e0:	72 0d                	jb     1053ef <get_pgtable_items+0x1b>
        return 0;
  1053e2:	b8 00 00 00 00       	mov    $0x0,%eax
  1053e7:	e9 98 00 00 00       	jmp    105484 <get_pgtable_items+0xb0>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
  1053ec:	ff 45 10             	incl   0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
  1053ef:	8b 45 10             	mov    0x10(%ebp),%eax
  1053f2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1053f5:	73 18                	jae    10540f <get_pgtable_items+0x3b>
  1053f7:	8b 45 10             	mov    0x10(%ebp),%eax
  1053fa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  105401:	8b 45 14             	mov    0x14(%ebp),%eax
  105404:	01 d0                	add    %edx,%eax
  105406:	8b 00                	mov    (%eax),%eax
  105408:	83 e0 01             	and    $0x1,%eax
  10540b:	85 c0                	test   %eax,%eax
  10540d:	74 dd                	je     1053ec <get_pgtable_items+0x18>
    }
    if (start < right) {
  10540f:	8b 45 10             	mov    0x10(%ebp),%eax
  105412:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105415:	73 68                	jae    10547f <get_pgtable_items+0xab>
        if (left_store != NULL) {
  105417:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  10541b:	74 08                	je     105425 <get_pgtable_items+0x51>
            *left_store = start;
  10541d:	8b 45 18             	mov    0x18(%ebp),%eax
  105420:	8b 55 10             	mov    0x10(%ebp),%edx
  105423:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  105425:	8b 45 10             	mov    0x10(%ebp),%eax
  105428:	8d 50 01             	lea    0x1(%eax),%edx
  10542b:	89 55 10             	mov    %edx,0x10(%ebp)
  10542e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  105435:	8b 45 14             	mov    0x14(%ebp),%eax
  105438:	01 d0                	add    %edx,%eax
  10543a:	8b 00                	mov    (%eax),%eax
  10543c:	83 e0 07             	and    $0x7,%eax
  10543f:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  105442:	eb 03                	jmp    105447 <get_pgtable_items+0x73>
            start ++;
  105444:	ff 45 10             	incl   0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  105447:	8b 45 10             	mov    0x10(%ebp),%eax
  10544a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10544d:	73 1d                	jae    10546c <get_pgtable_items+0x98>
  10544f:	8b 45 10             	mov    0x10(%ebp),%eax
  105452:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  105459:	8b 45 14             	mov    0x14(%ebp),%eax
  10545c:	01 d0                	add    %edx,%eax
  10545e:	8b 00                	mov    (%eax),%eax
  105460:	83 e0 07             	and    $0x7,%eax
  105463:	89 c2                	mov    %eax,%edx
  105465:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105468:	39 c2                	cmp    %eax,%edx
  10546a:	74 d8                	je     105444 <get_pgtable_items+0x70>
        }
        if (right_store != NULL) {
  10546c:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  105470:	74 08                	je     10547a <get_pgtable_items+0xa6>
            *right_store = start;
  105472:	8b 45 1c             	mov    0x1c(%ebp),%eax
  105475:	8b 55 10             	mov    0x10(%ebp),%edx
  105478:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  10547a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10547d:	eb 05                	jmp    105484 <get_pgtable_items+0xb0>
    }
    return 0;
  10547f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105484:	89 ec                	mov    %ebp,%esp
  105486:	5d                   	pop    %ebp
  105487:	c3                   	ret    

00105488 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  105488:	55                   	push   %ebp
  105489:	89 e5                	mov    %esp,%ebp
  10548b:	57                   	push   %edi
  10548c:	56                   	push   %esi
  10548d:	53                   	push   %ebx
  10548e:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  105491:	c7 04 24 ec 71 10 00 	movl   $0x1071ec,(%esp)
  105498:	e8 b9 ae ff ff       	call   100356 <cprintf>
    size_t left, right = 0, perm;
  10549d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  1054a4:	e9 f2 00 00 00       	jmp    10559b <print_pgdir+0x113>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  1054a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1054ac:	89 04 24             	mov    %eax,(%esp)
  1054af:	e8 de fe ff ff       	call   105392 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  1054b4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1054b7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  1054ba:	29 ca                	sub    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  1054bc:	89 d6                	mov    %edx,%esi
  1054be:	c1 e6 16             	shl    $0x16,%esi
  1054c1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1054c4:	89 d3                	mov    %edx,%ebx
  1054c6:	c1 e3 16             	shl    $0x16,%ebx
  1054c9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1054cc:	89 d1                	mov    %edx,%ecx
  1054ce:	c1 e1 16             	shl    $0x16,%ecx
  1054d1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1054d4:	8b 7d e0             	mov    -0x20(%ebp),%edi
  1054d7:	29 fa                	sub    %edi,%edx
  1054d9:	89 44 24 14          	mov    %eax,0x14(%esp)
  1054dd:	89 74 24 10          	mov    %esi,0x10(%esp)
  1054e1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1054e5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1054e9:	89 54 24 04          	mov    %edx,0x4(%esp)
  1054ed:	c7 04 24 1d 72 10 00 	movl   $0x10721d,(%esp)
  1054f4:	e8 5d ae ff ff       	call   100356 <cprintf>
        size_t l, r = left * NPTEENTRY;
  1054f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1054fc:	c1 e0 0a             	shl    $0xa,%eax
  1054ff:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  105502:	eb 50                	jmp    105554 <print_pgdir+0xcc>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  105504:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105507:	89 04 24             	mov    %eax,(%esp)
  10550a:	e8 83 fe ff ff       	call   105392 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  10550f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  105512:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  105515:	29 ca                	sub    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  105517:	89 d6                	mov    %edx,%esi
  105519:	c1 e6 0c             	shl    $0xc,%esi
  10551c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10551f:	89 d3                	mov    %edx,%ebx
  105521:	c1 e3 0c             	shl    $0xc,%ebx
  105524:	8b 55 d8             	mov    -0x28(%ebp),%edx
  105527:	89 d1                	mov    %edx,%ecx
  105529:	c1 e1 0c             	shl    $0xc,%ecx
  10552c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10552f:	8b 7d d8             	mov    -0x28(%ebp),%edi
  105532:	29 fa                	sub    %edi,%edx
  105534:	89 44 24 14          	mov    %eax,0x14(%esp)
  105538:	89 74 24 10          	mov    %esi,0x10(%esp)
  10553c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105540:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  105544:	89 54 24 04          	mov    %edx,0x4(%esp)
  105548:	c7 04 24 3c 72 10 00 	movl   $0x10723c,(%esp)
  10554f:	e8 02 ae ff ff       	call   100356 <cprintf>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  105554:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
  105559:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10555c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10555f:	89 d3                	mov    %edx,%ebx
  105561:	c1 e3 0a             	shl    $0xa,%ebx
  105564:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105567:	89 d1                	mov    %edx,%ecx
  105569:	c1 e1 0a             	shl    $0xa,%ecx
  10556c:	8d 55 d4             	lea    -0x2c(%ebp),%edx
  10556f:	89 54 24 14          	mov    %edx,0x14(%esp)
  105573:	8d 55 d8             	lea    -0x28(%ebp),%edx
  105576:	89 54 24 10          	mov    %edx,0x10(%esp)
  10557a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  10557e:	89 44 24 08          	mov    %eax,0x8(%esp)
  105582:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  105586:	89 0c 24             	mov    %ecx,(%esp)
  105589:	e8 46 fe ff ff       	call   1053d4 <get_pgtable_items>
  10558e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105591:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105595:	0f 85 69 ff ff ff    	jne    105504 <print_pgdir+0x7c>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  10559b:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
  1055a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1055a3:	8d 55 dc             	lea    -0x24(%ebp),%edx
  1055a6:	89 54 24 14          	mov    %edx,0x14(%esp)
  1055aa:	8d 55 e0             	lea    -0x20(%ebp),%edx
  1055ad:	89 54 24 10          	mov    %edx,0x10(%esp)
  1055b1:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  1055b5:	89 44 24 08          	mov    %eax,0x8(%esp)
  1055b9:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  1055c0:	00 
  1055c1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1055c8:	e8 07 fe ff ff       	call   1053d4 <get_pgtable_items>
  1055cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1055d0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1055d4:	0f 85 cf fe ff ff    	jne    1054a9 <print_pgdir+0x21>
        }
    }
    cprintf("--------------------- END ---------------------\n");
  1055da:	c7 04 24 60 72 10 00 	movl   $0x107260,(%esp)
  1055e1:	e8 70 ad ff ff       	call   100356 <cprintf>
}
  1055e6:	90                   	nop
  1055e7:	83 c4 4c             	add    $0x4c,%esp
  1055ea:	5b                   	pop    %ebx
  1055eb:	5e                   	pop    %esi
  1055ec:	5f                   	pop    %edi
  1055ed:	5d                   	pop    %ebp
  1055ee:	c3                   	ret    

001055ef <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  1055ef:	55                   	push   %ebp
  1055f0:	89 e5                	mov    %esp,%ebp
  1055f2:	83 ec 58             	sub    $0x58,%esp
  1055f5:	8b 45 10             	mov    0x10(%ebp),%eax
  1055f8:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1055fb:	8b 45 14             	mov    0x14(%ebp),%eax
  1055fe:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  105601:	8b 45 d0             	mov    -0x30(%ebp),%eax
  105604:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  105607:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10560a:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  10560d:	8b 45 18             	mov    0x18(%ebp),%eax
  105610:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105613:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105616:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105619:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10561c:	89 55 f0             	mov    %edx,-0x10(%ebp)
  10561f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105622:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105625:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  105629:	74 1c                	je     105647 <printnum+0x58>
  10562b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10562e:	ba 00 00 00 00       	mov    $0x0,%edx
  105633:	f7 75 e4             	divl   -0x1c(%ebp)
  105636:	89 55 f4             	mov    %edx,-0xc(%ebp)
  105639:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10563c:	ba 00 00 00 00       	mov    $0x0,%edx
  105641:	f7 75 e4             	divl   -0x1c(%ebp)
  105644:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105647:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10564a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10564d:	f7 75 e4             	divl   -0x1c(%ebp)
  105650:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105653:	89 55 dc             	mov    %edx,-0x24(%ebp)
  105656:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105659:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10565c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10565f:	89 55 ec             	mov    %edx,-0x14(%ebp)
  105662:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105665:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  105668:	8b 45 18             	mov    0x18(%ebp),%eax
  10566b:	ba 00 00 00 00       	mov    $0x0,%edx
  105670:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  105673:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  105676:	19 d1                	sbb    %edx,%ecx
  105678:	72 4c                	jb     1056c6 <printnum+0xd7>
        printnum(putch, putdat, result, base, width - 1, padc);
  10567a:	8b 45 1c             	mov    0x1c(%ebp),%eax
  10567d:	8d 50 ff             	lea    -0x1(%eax),%edx
  105680:	8b 45 20             	mov    0x20(%ebp),%eax
  105683:	89 44 24 18          	mov    %eax,0x18(%esp)
  105687:	89 54 24 14          	mov    %edx,0x14(%esp)
  10568b:	8b 45 18             	mov    0x18(%ebp),%eax
  10568e:	89 44 24 10          	mov    %eax,0x10(%esp)
  105692:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105695:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105698:	89 44 24 08          	mov    %eax,0x8(%esp)
  10569c:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1056a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1056a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1056a7:	8b 45 08             	mov    0x8(%ebp),%eax
  1056aa:	89 04 24             	mov    %eax,(%esp)
  1056ad:	e8 3d ff ff ff       	call   1055ef <printnum>
  1056b2:	eb 1b                	jmp    1056cf <printnum+0xe0>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  1056b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1056b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1056bb:	8b 45 20             	mov    0x20(%ebp),%eax
  1056be:	89 04 24             	mov    %eax,(%esp)
  1056c1:	8b 45 08             	mov    0x8(%ebp),%eax
  1056c4:	ff d0                	call   *%eax
        while (-- width > 0)
  1056c6:	ff 4d 1c             	decl   0x1c(%ebp)
  1056c9:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  1056cd:	7f e5                	jg     1056b4 <printnum+0xc5>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  1056cf:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1056d2:	05 14 73 10 00       	add    $0x107314,%eax
  1056d7:	0f b6 00             	movzbl (%eax),%eax
  1056da:	0f be c0             	movsbl %al,%eax
  1056dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  1056e0:	89 54 24 04          	mov    %edx,0x4(%esp)
  1056e4:	89 04 24             	mov    %eax,(%esp)
  1056e7:	8b 45 08             	mov    0x8(%ebp),%eax
  1056ea:	ff d0                	call   *%eax
}
  1056ec:	90                   	nop
  1056ed:	89 ec                	mov    %ebp,%esp
  1056ef:	5d                   	pop    %ebp
  1056f0:	c3                   	ret    

001056f1 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  1056f1:	55                   	push   %ebp
  1056f2:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  1056f4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1056f8:	7e 14                	jle    10570e <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  1056fa:	8b 45 08             	mov    0x8(%ebp),%eax
  1056fd:	8b 00                	mov    (%eax),%eax
  1056ff:	8d 48 08             	lea    0x8(%eax),%ecx
  105702:	8b 55 08             	mov    0x8(%ebp),%edx
  105705:	89 0a                	mov    %ecx,(%edx)
  105707:	8b 50 04             	mov    0x4(%eax),%edx
  10570a:	8b 00                	mov    (%eax),%eax
  10570c:	eb 30                	jmp    10573e <getuint+0x4d>
    }
    else if (lflag) {
  10570e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105712:	74 16                	je     10572a <getuint+0x39>
        return va_arg(*ap, unsigned long);
  105714:	8b 45 08             	mov    0x8(%ebp),%eax
  105717:	8b 00                	mov    (%eax),%eax
  105719:	8d 48 04             	lea    0x4(%eax),%ecx
  10571c:	8b 55 08             	mov    0x8(%ebp),%edx
  10571f:	89 0a                	mov    %ecx,(%edx)
  105721:	8b 00                	mov    (%eax),%eax
  105723:	ba 00 00 00 00       	mov    $0x0,%edx
  105728:	eb 14                	jmp    10573e <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  10572a:	8b 45 08             	mov    0x8(%ebp),%eax
  10572d:	8b 00                	mov    (%eax),%eax
  10572f:	8d 48 04             	lea    0x4(%eax),%ecx
  105732:	8b 55 08             	mov    0x8(%ebp),%edx
  105735:	89 0a                	mov    %ecx,(%edx)
  105737:	8b 00                	mov    (%eax),%eax
  105739:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  10573e:	5d                   	pop    %ebp
  10573f:	c3                   	ret    

00105740 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  105740:	55                   	push   %ebp
  105741:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  105743:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  105747:	7e 14                	jle    10575d <getint+0x1d>
        return va_arg(*ap, long long);
  105749:	8b 45 08             	mov    0x8(%ebp),%eax
  10574c:	8b 00                	mov    (%eax),%eax
  10574e:	8d 48 08             	lea    0x8(%eax),%ecx
  105751:	8b 55 08             	mov    0x8(%ebp),%edx
  105754:	89 0a                	mov    %ecx,(%edx)
  105756:	8b 50 04             	mov    0x4(%eax),%edx
  105759:	8b 00                	mov    (%eax),%eax
  10575b:	eb 28                	jmp    105785 <getint+0x45>
    }
    else if (lflag) {
  10575d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105761:	74 12                	je     105775 <getint+0x35>
        return va_arg(*ap, long);
  105763:	8b 45 08             	mov    0x8(%ebp),%eax
  105766:	8b 00                	mov    (%eax),%eax
  105768:	8d 48 04             	lea    0x4(%eax),%ecx
  10576b:	8b 55 08             	mov    0x8(%ebp),%edx
  10576e:	89 0a                	mov    %ecx,(%edx)
  105770:	8b 00                	mov    (%eax),%eax
  105772:	99                   	cltd   
  105773:	eb 10                	jmp    105785 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  105775:	8b 45 08             	mov    0x8(%ebp),%eax
  105778:	8b 00                	mov    (%eax),%eax
  10577a:	8d 48 04             	lea    0x4(%eax),%ecx
  10577d:	8b 55 08             	mov    0x8(%ebp),%edx
  105780:	89 0a                	mov    %ecx,(%edx)
  105782:	8b 00                	mov    (%eax),%eax
  105784:	99                   	cltd   
    }
}
  105785:	5d                   	pop    %ebp
  105786:	c3                   	ret    

00105787 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  105787:	55                   	push   %ebp
  105788:	89 e5                	mov    %esp,%ebp
  10578a:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  10578d:	8d 45 14             	lea    0x14(%ebp),%eax
  105790:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  105793:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105796:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10579a:	8b 45 10             	mov    0x10(%ebp),%eax
  10579d:	89 44 24 08          	mov    %eax,0x8(%esp)
  1057a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1057a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057a8:	8b 45 08             	mov    0x8(%ebp),%eax
  1057ab:	89 04 24             	mov    %eax,(%esp)
  1057ae:	e8 05 00 00 00       	call   1057b8 <vprintfmt>
    va_end(ap);
}
  1057b3:	90                   	nop
  1057b4:	89 ec                	mov    %ebp,%esp
  1057b6:	5d                   	pop    %ebp
  1057b7:	c3                   	ret    

001057b8 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  1057b8:	55                   	push   %ebp
  1057b9:	89 e5                	mov    %esp,%ebp
  1057bb:	56                   	push   %esi
  1057bc:	53                   	push   %ebx
  1057bd:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1057c0:	eb 17                	jmp    1057d9 <vprintfmt+0x21>
            if (ch == '\0') {
  1057c2:	85 db                	test   %ebx,%ebx
  1057c4:	0f 84 bf 03 00 00    	je     105b89 <vprintfmt+0x3d1>
                return;
            }
            putch(ch, putdat);
  1057ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  1057cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057d1:	89 1c 24             	mov    %ebx,(%esp)
  1057d4:	8b 45 08             	mov    0x8(%ebp),%eax
  1057d7:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1057d9:	8b 45 10             	mov    0x10(%ebp),%eax
  1057dc:	8d 50 01             	lea    0x1(%eax),%edx
  1057df:	89 55 10             	mov    %edx,0x10(%ebp)
  1057e2:	0f b6 00             	movzbl (%eax),%eax
  1057e5:	0f b6 d8             	movzbl %al,%ebx
  1057e8:	83 fb 25             	cmp    $0x25,%ebx
  1057eb:	75 d5                	jne    1057c2 <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
  1057ed:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  1057f1:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  1057f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1057fb:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  1057fe:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  105805:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105808:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  10580b:	8b 45 10             	mov    0x10(%ebp),%eax
  10580e:	8d 50 01             	lea    0x1(%eax),%edx
  105811:	89 55 10             	mov    %edx,0x10(%ebp)
  105814:	0f b6 00             	movzbl (%eax),%eax
  105817:	0f b6 d8             	movzbl %al,%ebx
  10581a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  10581d:	83 f8 55             	cmp    $0x55,%eax
  105820:	0f 87 37 03 00 00    	ja     105b5d <vprintfmt+0x3a5>
  105826:	8b 04 85 38 73 10 00 	mov    0x107338(,%eax,4),%eax
  10582d:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  10582f:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  105833:	eb d6                	jmp    10580b <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  105835:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  105839:	eb d0                	jmp    10580b <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  10583b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  105842:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105845:	89 d0                	mov    %edx,%eax
  105847:	c1 e0 02             	shl    $0x2,%eax
  10584a:	01 d0                	add    %edx,%eax
  10584c:	01 c0                	add    %eax,%eax
  10584e:	01 d8                	add    %ebx,%eax
  105850:	83 e8 30             	sub    $0x30,%eax
  105853:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  105856:	8b 45 10             	mov    0x10(%ebp),%eax
  105859:	0f b6 00             	movzbl (%eax),%eax
  10585c:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  10585f:	83 fb 2f             	cmp    $0x2f,%ebx
  105862:	7e 38                	jle    10589c <vprintfmt+0xe4>
  105864:	83 fb 39             	cmp    $0x39,%ebx
  105867:	7f 33                	jg     10589c <vprintfmt+0xe4>
            for (precision = 0; ; ++ fmt) {
  105869:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
  10586c:	eb d4                	jmp    105842 <vprintfmt+0x8a>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  10586e:	8b 45 14             	mov    0x14(%ebp),%eax
  105871:	8d 50 04             	lea    0x4(%eax),%edx
  105874:	89 55 14             	mov    %edx,0x14(%ebp)
  105877:	8b 00                	mov    (%eax),%eax
  105879:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  10587c:	eb 1f                	jmp    10589d <vprintfmt+0xe5>

        case '.':
            if (width < 0)
  10587e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105882:	79 87                	jns    10580b <vprintfmt+0x53>
                width = 0;
  105884:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  10588b:	e9 7b ff ff ff       	jmp    10580b <vprintfmt+0x53>

        case '#':
            altflag = 1;
  105890:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  105897:	e9 6f ff ff ff       	jmp    10580b <vprintfmt+0x53>
            goto process_precision;
  10589c:	90                   	nop

        process_precision:
            if (width < 0)
  10589d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1058a1:	0f 89 64 ff ff ff    	jns    10580b <vprintfmt+0x53>
                width = precision, precision = -1;
  1058a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1058aa:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1058ad:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  1058b4:	e9 52 ff ff ff       	jmp    10580b <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  1058b9:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
  1058bc:	e9 4a ff ff ff       	jmp    10580b <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  1058c1:	8b 45 14             	mov    0x14(%ebp),%eax
  1058c4:	8d 50 04             	lea    0x4(%eax),%edx
  1058c7:	89 55 14             	mov    %edx,0x14(%ebp)
  1058ca:	8b 00                	mov    (%eax),%eax
  1058cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  1058cf:	89 54 24 04          	mov    %edx,0x4(%esp)
  1058d3:	89 04 24             	mov    %eax,(%esp)
  1058d6:	8b 45 08             	mov    0x8(%ebp),%eax
  1058d9:	ff d0                	call   *%eax
            break;
  1058db:	e9 a4 02 00 00       	jmp    105b84 <vprintfmt+0x3cc>

        // error message
        case 'e':
            err = va_arg(ap, int);
  1058e0:	8b 45 14             	mov    0x14(%ebp),%eax
  1058e3:	8d 50 04             	lea    0x4(%eax),%edx
  1058e6:	89 55 14             	mov    %edx,0x14(%ebp)
  1058e9:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  1058eb:	85 db                	test   %ebx,%ebx
  1058ed:	79 02                	jns    1058f1 <vprintfmt+0x139>
                err = -err;
  1058ef:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  1058f1:	83 fb 06             	cmp    $0x6,%ebx
  1058f4:	7f 0b                	jg     105901 <vprintfmt+0x149>
  1058f6:	8b 34 9d f8 72 10 00 	mov    0x1072f8(,%ebx,4),%esi
  1058fd:	85 f6                	test   %esi,%esi
  1058ff:	75 23                	jne    105924 <vprintfmt+0x16c>
                printfmt(putch, putdat, "error %d", err);
  105901:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105905:	c7 44 24 08 25 73 10 	movl   $0x107325,0x8(%esp)
  10590c:	00 
  10590d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105910:	89 44 24 04          	mov    %eax,0x4(%esp)
  105914:	8b 45 08             	mov    0x8(%ebp),%eax
  105917:	89 04 24             	mov    %eax,(%esp)
  10591a:	e8 68 fe ff ff       	call   105787 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  10591f:	e9 60 02 00 00       	jmp    105b84 <vprintfmt+0x3cc>
                printfmt(putch, putdat, "%s", p);
  105924:	89 74 24 0c          	mov    %esi,0xc(%esp)
  105928:	c7 44 24 08 2e 73 10 	movl   $0x10732e,0x8(%esp)
  10592f:	00 
  105930:	8b 45 0c             	mov    0xc(%ebp),%eax
  105933:	89 44 24 04          	mov    %eax,0x4(%esp)
  105937:	8b 45 08             	mov    0x8(%ebp),%eax
  10593a:	89 04 24             	mov    %eax,(%esp)
  10593d:	e8 45 fe ff ff       	call   105787 <printfmt>
            break;
  105942:	e9 3d 02 00 00       	jmp    105b84 <vprintfmt+0x3cc>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  105947:	8b 45 14             	mov    0x14(%ebp),%eax
  10594a:	8d 50 04             	lea    0x4(%eax),%edx
  10594d:	89 55 14             	mov    %edx,0x14(%ebp)
  105950:	8b 30                	mov    (%eax),%esi
  105952:	85 f6                	test   %esi,%esi
  105954:	75 05                	jne    10595b <vprintfmt+0x1a3>
                p = "(null)";
  105956:	be 31 73 10 00       	mov    $0x107331,%esi
            }
            if (width > 0 && padc != '-') {
  10595b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10595f:	7e 76                	jle    1059d7 <vprintfmt+0x21f>
  105961:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  105965:	74 70                	je     1059d7 <vprintfmt+0x21f>
                for (width -= strnlen(p, precision); width > 0; width --) {
  105967:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10596a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10596e:	89 34 24             	mov    %esi,(%esp)
  105971:	e8 16 03 00 00       	call   105c8c <strnlen>
  105976:	89 c2                	mov    %eax,%edx
  105978:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10597b:	29 d0                	sub    %edx,%eax
  10597d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105980:	eb 16                	jmp    105998 <vprintfmt+0x1e0>
                    putch(padc, putdat);
  105982:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  105986:	8b 55 0c             	mov    0xc(%ebp),%edx
  105989:	89 54 24 04          	mov    %edx,0x4(%esp)
  10598d:	89 04 24             	mov    %eax,(%esp)
  105990:	8b 45 08             	mov    0x8(%ebp),%eax
  105993:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
  105995:	ff 4d e8             	decl   -0x18(%ebp)
  105998:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10599c:	7f e4                	jg     105982 <vprintfmt+0x1ca>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  10599e:	eb 37                	jmp    1059d7 <vprintfmt+0x21f>
                if (altflag && (ch < ' ' || ch > '~')) {
  1059a0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  1059a4:	74 1f                	je     1059c5 <vprintfmt+0x20d>
  1059a6:	83 fb 1f             	cmp    $0x1f,%ebx
  1059a9:	7e 05                	jle    1059b0 <vprintfmt+0x1f8>
  1059ab:	83 fb 7e             	cmp    $0x7e,%ebx
  1059ae:	7e 15                	jle    1059c5 <vprintfmt+0x20d>
                    putch('?', putdat);
  1059b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059b7:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  1059be:	8b 45 08             	mov    0x8(%ebp),%eax
  1059c1:	ff d0                	call   *%eax
  1059c3:	eb 0f                	jmp    1059d4 <vprintfmt+0x21c>
                }
                else {
                    putch(ch, putdat);
  1059c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059cc:	89 1c 24             	mov    %ebx,(%esp)
  1059cf:	8b 45 08             	mov    0x8(%ebp),%eax
  1059d2:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  1059d4:	ff 4d e8             	decl   -0x18(%ebp)
  1059d7:	89 f0                	mov    %esi,%eax
  1059d9:	8d 70 01             	lea    0x1(%eax),%esi
  1059dc:	0f b6 00             	movzbl (%eax),%eax
  1059df:	0f be d8             	movsbl %al,%ebx
  1059e2:	85 db                	test   %ebx,%ebx
  1059e4:	74 27                	je     105a0d <vprintfmt+0x255>
  1059e6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1059ea:	78 b4                	js     1059a0 <vprintfmt+0x1e8>
  1059ec:	ff 4d e4             	decl   -0x1c(%ebp)
  1059ef:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1059f3:	79 ab                	jns    1059a0 <vprintfmt+0x1e8>
                }
            }
            for (; width > 0; width --) {
  1059f5:	eb 16                	jmp    105a0d <vprintfmt+0x255>
                putch(' ', putdat);
  1059f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059fa:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059fe:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  105a05:	8b 45 08             	mov    0x8(%ebp),%eax
  105a08:	ff d0                	call   *%eax
            for (; width > 0; width --) {
  105a0a:	ff 4d e8             	decl   -0x18(%ebp)
  105a0d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105a11:	7f e4                	jg     1059f7 <vprintfmt+0x23f>
            }
            break;
  105a13:	e9 6c 01 00 00       	jmp    105b84 <vprintfmt+0x3cc>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  105a18:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105a1b:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a1f:	8d 45 14             	lea    0x14(%ebp),%eax
  105a22:	89 04 24             	mov    %eax,(%esp)
  105a25:	e8 16 fd ff ff       	call   105740 <getint>
  105a2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105a2d:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  105a30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105a33:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105a36:	85 d2                	test   %edx,%edx
  105a38:	79 26                	jns    105a60 <vprintfmt+0x2a8>
                putch('-', putdat);
  105a3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a3d:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a41:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  105a48:	8b 45 08             	mov    0x8(%ebp),%eax
  105a4b:	ff d0                	call   *%eax
                num = -(long long)num;
  105a4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105a50:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105a53:	f7 d8                	neg    %eax
  105a55:	83 d2 00             	adc    $0x0,%edx
  105a58:	f7 da                	neg    %edx
  105a5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105a5d:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  105a60:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105a67:	e9 a8 00 00 00       	jmp    105b14 <vprintfmt+0x35c>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  105a6c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105a6f:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a73:	8d 45 14             	lea    0x14(%ebp),%eax
  105a76:	89 04 24             	mov    %eax,(%esp)
  105a79:	e8 73 fc ff ff       	call   1056f1 <getuint>
  105a7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105a81:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  105a84:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105a8b:	e9 84 00 00 00       	jmp    105b14 <vprintfmt+0x35c>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  105a90:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105a93:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a97:	8d 45 14             	lea    0x14(%ebp),%eax
  105a9a:	89 04 24             	mov    %eax,(%esp)
  105a9d:	e8 4f fc ff ff       	call   1056f1 <getuint>
  105aa2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105aa5:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  105aa8:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  105aaf:	eb 63                	jmp    105b14 <vprintfmt+0x35c>

        // pointer
        case 'p':
            putch('0', putdat);
  105ab1:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ab4:	89 44 24 04          	mov    %eax,0x4(%esp)
  105ab8:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  105abf:	8b 45 08             	mov    0x8(%ebp),%eax
  105ac2:	ff d0                	call   *%eax
            putch('x', putdat);
  105ac4:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ac7:	89 44 24 04          	mov    %eax,0x4(%esp)
  105acb:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  105ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  105ad5:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  105ad7:	8b 45 14             	mov    0x14(%ebp),%eax
  105ada:	8d 50 04             	lea    0x4(%eax),%edx
  105add:	89 55 14             	mov    %edx,0x14(%ebp)
  105ae0:	8b 00                	mov    (%eax),%eax
  105ae2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105ae5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  105aec:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  105af3:	eb 1f                	jmp    105b14 <vprintfmt+0x35c>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  105af5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105af8:	89 44 24 04          	mov    %eax,0x4(%esp)
  105afc:	8d 45 14             	lea    0x14(%ebp),%eax
  105aff:	89 04 24             	mov    %eax,(%esp)
  105b02:	e8 ea fb ff ff       	call   1056f1 <getuint>
  105b07:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105b0a:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  105b0d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  105b14:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  105b18:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105b1b:	89 54 24 18          	mov    %edx,0x18(%esp)
  105b1f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  105b22:	89 54 24 14          	mov    %edx,0x14(%esp)
  105b26:	89 44 24 10          	mov    %eax,0x10(%esp)
  105b2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105b2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105b30:	89 44 24 08          	mov    %eax,0x8(%esp)
  105b34:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105b38:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b3b:	89 44 24 04          	mov    %eax,0x4(%esp)
  105b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  105b42:	89 04 24             	mov    %eax,(%esp)
  105b45:	e8 a5 fa ff ff       	call   1055ef <printnum>
            break;
  105b4a:	eb 38                	jmp    105b84 <vprintfmt+0x3cc>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  105b4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b4f:	89 44 24 04          	mov    %eax,0x4(%esp)
  105b53:	89 1c 24             	mov    %ebx,(%esp)
  105b56:	8b 45 08             	mov    0x8(%ebp),%eax
  105b59:	ff d0                	call   *%eax
            break;
  105b5b:	eb 27                	jmp    105b84 <vprintfmt+0x3cc>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  105b5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b60:	89 44 24 04          	mov    %eax,0x4(%esp)
  105b64:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  105b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  105b6e:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  105b70:	ff 4d 10             	decl   0x10(%ebp)
  105b73:	eb 03                	jmp    105b78 <vprintfmt+0x3c0>
  105b75:	ff 4d 10             	decl   0x10(%ebp)
  105b78:	8b 45 10             	mov    0x10(%ebp),%eax
  105b7b:	48                   	dec    %eax
  105b7c:	0f b6 00             	movzbl (%eax),%eax
  105b7f:	3c 25                	cmp    $0x25,%al
  105b81:	75 f2                	jne    105b75 <vprintfmt+0x3bd>
                /* do nothing */;
            break;
  105b83:	90                   	nop
    while (1) {
  105b84:	e9 37 fc ff ff       	jmp    1057c0 <vprintfmt+0x8>
                return;
  105b89:	90                   	nop
        }
    }
}
  105b8a:	83 c4 40             	add    $0x40,%esp
  105b8d:	5b                   	pop    %ebx
  105b8e:	5e                   	pop    %esi
  105b8f:	5d                   	pop    %ebp
  105b90:	c3                   	ret    

00105b91 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  105b91:	55                   	push   %ebp
  105b92:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  105b94:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b97:	8b 40 08             	mov    0x8(%eax),%eax
  105b9a:	8d 50 01             	lea    0x1(%eax),%edx
  105b9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ba0:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  105ba3:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ba6:	8b 10                	mov    (%eax),%edx
  105ba8:	8b 45 0c             	mov    0xc(%ebp),%eax
  105bab:	8b 40 04             	mov    0x4(%eax),%eax
  105bae:	39 c2                	cmp    %eax,%edx
  105bb0:	73 12                	jae    105bc4 <sprintputch+0x33>
        *b->buf ++ = ch;
  105bb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  105bb5:	8b 00                	mov    (%eax),%eax
  105bb7:	8d 48 01             	lea    0x1(%eax),%ecx
  105bba:	8b 55 0c             	mov    0xc(%ebp),%edx
  105bbd:	89 0a                	mov    %ecx,(%edx)
  105bbf:	8b 55 08             	mov    0x8(%ebp),%edx
  105bc2:	88 10                	mov    %dl,(%eax)
    }
}
  105bc4:	90                   	nop
  105bc5:	5d                   	pop    %ebp
  105bc6:	c3                   	ret    

00105bc7 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  105bc7:	55                   	push   %ebp
  105bc8:	89 e5                	mov    %esp,%ebp
  105bca:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  105bcd:	8d 45 14             	lea    0x14(%ebp),%eax
  105bd0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  105bd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105bd6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105bda:	8b 45 10             	mov    0x10(%ebp),%eax
  105bdd:	89 44 24 08          	mov    %eax,0x8(%esp)
  105be1:	8b 45 0c             	mov    0xc(%ebp),%eax
  105be4:	89 44 24 04          	mov    %eax,0x4(%esp)
  105be8:	8b 45 08             	mov    0x8(%ebp),%eax
  105beb:	89 04 24             	mov    %eax,(%esp)
  105bee:	e8 0a 00 00 00       	call   105bfd <vsnprintf>
  105bf3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  105bf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105bf9:	89 ec                	mov    %ebp,%esp
  105bfb:	5d                   	pop    %ebp
  105bfc:	c3                   	ret    

00105bfd <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  105bfd:	55                   	push   %ebp
  105bfe:	89 e5                	mov    %esp,%ebp
  105c00:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  105c03:	8b 45 08             	mov    0x8(%ebp),%eax
  105c06:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105c09:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c0c:	8d 50 ff             	lea    -0x1(%eax),%edx
  105c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  105c12:	01 d0                	add    %edx,%eax
  105c14:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105c17:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  105c1e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  105c22:	74 0a                	je     105c2e <vsnprintf+0x31>
  105c24:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105c27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105c2a:	39 c2                	cmp    %eax,%edx
  105c2c:	76 07                	jbe    105c35 <vsnprintf+0x38>
        return -E_INVAL;
  105c2e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  105c33:	eb 2a                	jmp    105c5f <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  105c35:	8b 45 14             	mov    0x14(%ebp),%eax
  105c38:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105c3c:	8b 45 10             	mov    0x10(%ebp),%eax
  105c3f:	89 44 24 08          	mov    %eax,0x8(%esp)
  105c43:	8d 45 ec             	lea    -0x14(%ebp),%eax
  105c46:	89 44 24 04          	mov    %eax,0x4(%esp)
  105c4a:	c7 04 24 91 5b 10 00 	movl   $0x105b91,(%esp)
  105c51:	e8 62 fb ff ff       	call   1057b8 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  105c56:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105c59:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  105c5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105c5f:	89 ec                	mov    %ebp,%esp
  105c61:	5d                   	pop    %ebp
  105c62:	c3                   	ret    

00105c63 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  105c63:	55                   	push   %ebp
  105c64:	89 e5                	mov    %esp,%ebp
  105c66:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105c69:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  105c70:	eb 03                	jmp    105c75 <strlen+0x12>
        cnt ++;
  105c72:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
  105c75:	8b 45 08             	mov    0x8(%ebp),%eax
  105c78:	8d 50 01             	lea    0x1(%eax),%edx
  105c7b:	89 55 08             	mov    %edx,0x8(%ebp)
  105c7e:	0f b6 00             	movzbl (%eax),%eax
  105c81:	84 c0                	test   %al,%al
  105c83:	75 ed                	jne    105c72 <strlen+0xf>
    }
    return cnt;
  105c85:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105c88:	89 ec                	mov    %ebp,%esp
  105c8a:	5d                   	pop    %ebp
  105c8b:	c3                   	ret    

00105c8c <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  105c8c:	55                   	push   %ebp
  105c8d:	89 e5                	mov    %esp,%ebp
  105c8f:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105c92:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  105c99:	eb 03                	jmp    105c9e <strnlen+0x12>
        cnt ++;
  105c9b:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  105c9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105ca1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105ca4:	73 10                	jae    105cb6 <strnlen+0x2a>
  105ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  105ca9:	8d 50 01             	lea    0x1(%eax),%edx
  105cac:	89 55 08             	mov    %edx,0x8(%ebp)
  105caf:	0f b6 00             	movzbl (%eax),%eax
  105cb2:	84 c0                	test   %al,%al
  105cb4:	75 e5                	jne    105c9b <strnlen+0xf>
    }
    return cnt;
  105cb6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105cb9:	89 ec                	mov    %ebp,%esp
  105cbb:	5d                   	pop    %ebp
  105cbc:	c3                   	ret    

00105cbd <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  105cbd:	55                   	push   %ebp
  105cbe:	89 e5                	mov    %esp,%ebp
  105cc0:	57                   	push   %edi
  105cc1:	56                   	push   %esi
  105cc2:	83 ec 20             	sub    $0x20,%esp
  105cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  105cc8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105ccb:	8b 45 0c             	mov    0xc(%ebp),%eax
  105cce:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  105cd1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105cd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105cd7:	89 d1                	mov    %edx,%ecx
  105cd9:	89 c2                	mov    %eax,%edx
  105cdb:	89 ce                	mov    %ecx,%esi
  105cdd:	89 d7                	mov    %edx,%edi
  105cdf:	ac                   	lods   %ds:(%esi),%al
  105ce0:	aa                   	stos   %al,%es:(%edi)
  105ce1:	84 c0                	test   %al,%al
  105ce3:	75 fa                	jne    105cdf <strcpy+0x22>
  105ce5:	89 fa                	mov    %edi,%edx
  105ce7:	89 f1                	mov    %esi,%ecx
  105ce9:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105cec:	89 55 e8             	mov    %edx,-0x18(%ebp)
  105cef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  105cf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  105cf5:	83 c4 20             	add    $0x20,%esp
  105cf8:	5e                   	pop    %esi
  105cf9:	5f                   	pop    %edi
  105cfa:	5d                   	pop    %ebp
  105cfb:	c3                   	ret    

00105cfc <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  105cfc:	55                   	push   %ebp
  105cfd:	89 e5                	mov    %esp,%ebp
  105cff:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  105d02:	8b 45 08             	mov    0x8(%ebp),%eax
  105d05:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  105d08:	eb 1e                	jmp    105d28 <strncpy+0x2c>
        if ((*p = *src) != '\0') {
  105d0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d0d:	0f b6 10             	movzbl (%eax),%edx
  105d10:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105d13:	88 10                	mov    %dl,(%eax)
  105d15:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105d18:	0f b6 00             	movzbl (%eax),%eax
  105d1b:	84 c0                	test   %al,%al
  105d1d:	74 03                	je     105d22 <strncpy+0x26>
            src ++;
  105d1f:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
  105d22:	ff 45 fc             	incl   -0x4(%ebp)
  105d25:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
  105d28:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105d2c:	75 dc                	jne    105d0a <strncpy+0xe>
    }
    return dst;
  105d2e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105d31:	89 ec                	mov    %ebp,%esp
  105d33:	5d                   	pop    %ebp
  105d34:	c3                   	ret    

00105d35 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  105d35:	55                   	push   %ebp
  105d36:	89 e5                	mov    %esp,%ebp
  105d38:	57                   	push   %edi
  105d39:	56                   	push   %esi
  105d3a:	83 ec 20             	sub    $0x20,%esp
  105d3d:	8b 45 08             	mov    0x8(%ebp),%eax
  105d40:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105d43:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d46:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  105d49:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105d4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105d4f:	89 d1                	mov    %edx,%ecx
  105d51:	89 c2                	mov    %eax,%edx
  105d53:	89 ce                	mov    %ecx,%esi
  105d55:	89 d7                	mov    %edx,%edi
  105d57:	ac                   	lods   %ds:(%esi),%al
  105d58:	ae                   	scas   %es:(%edi),%al
  105d59:	75 08                	jne    105d63 <strcmp+0x2e>
  105d5b:	84 c0                	test   %al,%al
  105d5d:	75 f8                	jne    105d57 <strcmp+0x22>
  105d5f:	31 c0                	xor    %eax,%eax
  105d61:	eb 04                	jmp    105d67 <strcmp+0x32>
  105d63:	19 c0                	sbb    %eax,%eax
  105d65:	0c 01                	or     $0x1,%al
  105d67:	89 fa                	mov    %edi,%edx
  105d69:	89 f1                	mov    %esi,%ecx
  105d6b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105d6e:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105d71:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  105d74:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  105d77:	83 c4 20             	add    $0x20,%esp
  105d7a:	5e                   	pop    %esi
  105d7b:	5f                   	pop    %edi
  105d7c:	5d                   	pop    %ebp
  105d7d:	c3                   	ret    

00105d7e <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  105d7e:	55                   	push   %ebp
  105d7f:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105d81:	eb 09                	jmp    105d8c <strncmp+0xe>
        n --, s1 ++, s2 ++;
  105d83:	ff 4d 10             	decl   0x10(%ebp)
  105d86:	ff 45 08             	incl   0x8(%ebp)
  105d89:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105d8c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105d90:	74 1a                	je     105dac <strncmp+0x2e>
  105d92:	8b 45 08             	mov    0x8(%ebp),%eax
  105d95:	0f b6 00             	movzbl (%eax),%eax
  105d98:	84 c0                	test   %al,%al
  105d9a:	74 10                	je     105dac <strncmp+0x2e>
  105d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  105d9f:	0f b6 10             	movzbl (%eax),%edx
  105da2:	8b 45 0c             	mov    0xc(%ebp),%eax
  105da5:	0f b6 00             	movzbl (%eax),%eax
  105da8:	38 c2                	cmp    %al,%dl
  105daa:	74 d7                	je     105d83 <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  105dac:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105db0:	74 18                	je     105dca <strncmp+0x4c>
  105db2:	8b 45 08             	mov    0x8(%ebp),%eax
  105db5:	0f b6 00             	movzbl (%eax),%eax
  105db8:	0f b6 d0             	movzbl %al,%edx
  105dbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  105dbe:	0f b6 00             	movzbl (%eax),%eax
  105dc1:	0f b6 c8             	movzbl %al,%ecx
  105dc4:	89 d0                	mov    %edx,%eax
  105dc6:	29 c8                	sub    %ecx,%eax
  105dc8:	eb 05                	jmp    105dcf <strncmp+0x51>
  105dca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105dcf:	5d                   	pop    %ebp
  105dd0:	c3                   	ret    

00105dd1 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  105dd1:	55                   	push   %ebp
  105dd2:	89 e5                	mov    %esp,%ebp
  105dd4:	83 ec 04             	sub    $0x4,%esp
  105dd7:	8b 45 0c             	mov    0xc(%ebp),%eax
  105dda:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105ddd:	eb 13                	jmp    105df2 <strchr+0x21>
        if (*s == c) {
  105ddf:	8b 45 08             	mov    0x8(%ebp),%eax
  105de2:	0f b6 00             	movzbl (%eax),%eax
  105de5:	38 45 fc             	cmp    %al,-0x4(%ebp)
  105de8:	75 05                	jne    105def <strchr+0x1e>
            return (char *)s;
  105dea:	8b 45 08             	mov    0x8(%ebp),%eax
  105ded:	eb 12                	jmp    105e01 <strchr+0x30>
        }
        s ++;
  105def:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  105df2:	8b 45 08             	mov    0x8(%ebp),%eax
  105df5:	0f b6 00             	movzbl (%eax),%eax
  105df8:	84 c0                	test   %al,%al
  105dfa:	75 e3                	jne    105ddf <strchr+0xe>
    }
    return NULL;
  105dfc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105e01:	89 ec                	mov    %ebp,%esp
  105e03:	5d                   	pop    %ebp
  105e04:	c3                   	ret    

00105e05 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  105e05:	55                   	push   %ebp
  105e06:	89 e5                	mov    %esp,%ebp
  105e08:	83 ec 04             	sub    $0x4,%esp
  105e0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e0e:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105e11:	eb 0e                	jmp    105e21 <strfind+0x1c>
        if (*s == c) {
  105e13:	8b 45 08             	mov    0x8(%ebp),%eax
  105e16:	0f b6 00             	movzbl (%eax),%eax
  105e19:	38 45 fc             	cmp    %al,-0x4(%ebp)
  105e1c:	74 0f                	je     105e2d <strfind+0x28>
            break;
        }
        s ++;
  105e1e:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  105e21:	8b 45 08             	mov    0x8(%ebp),%eax
  105e24:	0f b6 00             	movzbl (%eax),%eax
  105e27:	84 c0                	test   %al,%al
  105e29:	75 e8                	jne    105e13 <strfind+0xe>
  105e2b:	eb 01                	jmp    105e2e <strfind+0x29>
            break;
  105e2d:	90                   	nop
    }
    return (char *)s;
  105e2e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105e31:	89 ec                	mov    %ebp,%esp
  105e33:	5d                   	pop    %ebp
  105e34:	c3                   	ret    

00105e35 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  105e35:	55                   	push   %ebp
  105e36:	89 e5                	mov    %esp,%ebp
  105e38:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  105e3b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  105e42:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105e49:	eb 03                	jmp    105e4e <strtol+0x19>
        s ++;
  105e4b:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  105e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  105e51:	0f b6 00             	movzbl (%eax),%eax
  105e54:	3c 20                	cmp    $0x20,%al
  105e56:	74 f3                	je     105e4b <strtol+0x16>
  105e58:	8b 45 08             	mov    0x8(%ebp),%eax
  105e5b:	0f b6 00             	movzbl (%eax),%eax
  105e5e:	3c 09                	cmp    $0x9,%al
  105e60:	74 e9                	je     105e4b <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
  105e62:	8b 45 08             	mov    0x8(%ebp),%eax
  105e65:	0f b6 00             	movzbl (%eax),%eax
  105e68:	3c 2b                	cmp    $0x2b,%al
  105e6a:	75 05                	jne    105e71 <strtol+0x3c>
        s ++;
  105e6c:	ff 45 08             	incl   0x8(%ebp)
  105e6f:	eb 14                	jmp    105e85 <strtol+0x50>
    }
    else if (*s == '-') {
  105e71:	8b 45 08             	mov    0x8(%ebp),%eax
  105e74:	0f b6 00             	movzbl (%eax),%eax
  105e77:	3c 2d                	cmp    $0x2d,%al
  105e79:	75 0a                	jne    105e85 <strtol+0x50>
        s ++, neg = 1;
  105e7b:	ff 45 08             	incl   0x8(%ebp)
  105e7e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  105e85:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105e89:	74 06                	je     105e91 <strtol+0x5c>
  105e8b:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  105e8f:	75 22                	jne    105eb3 <strtol+0x7e>
  105e91:	8b 45 08             	mov    0x8(%ebp),%eax
  105e94:	0f b6 00             	movzbl (%eax),%eax
  105e97:	3c 30                	cmp    $0x30,%al
  105e99:	75 18                	jne    105eb3 <strtol+0x7e>
  105e9b:	8b 45 08             	mov    0x8(%ebp),%eax
  105e9e:	40                   	inc    %eax
  105e9f:	0f b6 00             	movzbl (%eax),%eax
  105ea2:	3c 78                	cmp    $0x78,%al
  105ea4:	75 0d                	jne    105eb3 <strtol+0x7e>
        s += 2, base = 16;
  105ea6:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  105eaa:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  105eb1:	eb 29                	jmp    105edc <strtol+0xa7>
    }
    else if (base == 0 && s[0] == '0') {
  105eb3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105eb7:	75 16                	jne    105ecf <strtol+0x9a>
  105eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  105ebc:	0f b6 00             	movzbl (%eax),%eax
  105ebf:	3c 30                	cmp    $0x30,%al
  105ec1:	75 0c                	jne    105ecf <strtol+0x9a>
        s ++, base = 8;
  105ec3:	ff 45 08             	incl   0x8(%ebp)
  105ec6:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  105ecd:	eb 0d                	jmp    105edc <strtol+0xa7>
    }
    else if (base == 0) {
  105ecf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105ed3:	75 07                	jne    105edc <strtol+0xa7>
        base = 10;
  105ed5:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  105edc:	8b 45 08             	mov    0x8(%ebp),%eax
  105edf:	0f b6 00             	movzbl (%eax),%eax
  105ee2:	3c 2f                	cmp    $0x2f,%al
  105ee4:	7e 1b                	jle    105f01 <strtol+0xcc>
  105ee6:	8b 45 08             	mov    0x8(%ebp),%eax
  105ee9:	0f b6 00             	movzbl (%eax),%eax
  105eec:	3c 39                	cmp    $0x39,%al
  105eee:	7f 11                	jg     105f01 <strtol+0xcc>
            dig = *s - '0';
  105ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  105ef3:	0f b6 00             	movzbl (%eax),%eax
  105ef6:	0f be c0             	movsbl %al,%eax
  105ef9:	83 e8 30             	sub    $0x30,%eax
  105efc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105eff:	eb 48                	jmp    105f49 <strtol+0x114>
        }
        else if (*s >= 'a' && *s <= 'z') {
  105f01:	8b 45 08             	mov    0x8(%ebp),%eax
  105f04:	0f b6 00             	movzbl (%eax),%eax
  105f07:	3c 60                	cmp    $0x60,%al
  105f09:	7e 1b                	jle    105f26 <strtol+0xf1>
  105f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  105f0e:	0f b6 00             	movzbl (%eax),%eax
  105f11:	3c 7a                	cmp    $0x7a,%al
  105f13:	7f 11                	jg     105f26 <strtol+0xf1>
            dig = *s - 'a' + 10;
  105f15:	8b 45 08             	mov    0x8(%ebp),%eax
  105f18:	0f b6 00             	movzbl (%eax),%eax
  105f1b:	0f be c0             	movsbl %al,%eax
  105f1e:	83 e8 57             	sub    $0x57,%eax
  105f21:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105f24:	eb 23                	jmp    105f49 <strtol+0x114>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  105f26:	8b 45 08             	mov    0x8(%ebp),%eax
  105f29:	0f b6 00             	movzbl (%eax),%eax
  105f2c:	3c 40                	cmp    $0x40,%al
  105f2e:	7e 3b                	jle    105f6b <strtol+0x136>
  105f30:	8b 45 08             	mov    0x8(%ebp),%eax
  105f33:	0f b6 00             	movzbl (%eax),%eax
  105f36:	3c 5a                	cmp    $0x5a,%al
  105f38:	7f 31                	jg     105f6b <strtol+0x136>
            dig = *s - 'A' + 10;
  105f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  105f3d:	0f b6 00             	movzbl (%eax),%eax
  105f40:	0f be c0             	movsbl %al,%eax
  105f43:	83 e8 37             	sub    $0x37,%eax
  105f46:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  105f49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105f4c:	3b 45 10             	cmp    0x10(%ebp),%eax
  105f4f:	7d 19                	jge    105f6a <strtol+0x135>
            break;
        }
        s ++, val = (val * base) + dig;
  105f51:	ff 45 08             	incl   0x8(%ebp)
  105f54:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105f57:	0f af 45 10          	imul   0x10(%ebp),%eax
  105f5b:	89 c2                	mov    %eax,%edx
  105f5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105f60:	01 d0                	add    %edx,%eax
  105f62:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
  105f65:	e9 72 ff ff ff       	jmp    105edc <strtol+0xa7>
            break;
  105f6a:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
  105f6b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105f6f:	74 08                	je     105f79 <strtol+0x144>
        *endptr = (char *) s;
  105f71:	8b 45 0c             	mov    0xc(%ebp),%eax
  105f74:	8b 55 08             	mov    0x8(%ebp),%edx
  105f77:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  105f79:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  105f7d:	74 07                	je     105f86 <strtol+0x151>
  105f7f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105f82:	f7 d8                	neg    %eax
  105f84:	eb 03                	jmp    105f89 <strtol+0x154>
  105f86:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  105f89:	89 ec                	mov    %ebp,%esp
  105f8b:	5d                   	pop    %ebp
  105f8c:	c3                   	ret    

00105f8d <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  105f8d:	55                   	push   %ebp
  105f8e:	89 e5                	mov    %esp,%ebp
  105f90:	83 ec 28             	sub    $0x28,%esp
  105f93:	89 7d fc             	mov    %edi,-0x4(%ebp)
  105f96:	8b 45 0c             	mov    0xc(%ebp),%eax
  105f99:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  105f9c:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  105fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  105fa3:	89 45 f8             	mov    %eax,-0x8(%ebp)
  105fa6:	88 55 f7             	mov    %dl,-0x9(%ebp)
  105fa9:	8b 45 10             	mov    0x10(%ebp),%eax
  105fac:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  105faf:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  105fb2:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  105fb6:	8b 55 f8             	mov    -0x8(%ebp),%edx
  105fb9:	89 d7                	mov    %edx,%edi
  105fbb:	f3 aa                	rep stos %al,%es:(%edi)
  105fbd:	89 fa                	mov    %edi,%edx
  105fbf:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105fc2:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  105fc5:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  105fc8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  105fcb:	89 ec                	mov    %ebp,%esp
  105fcd:	5d                   	pop    %ebp
  105fce:	c3                   	ret    

00105fcf <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  105fcf:	55                   	push   %ebp
  105fd0:	89 e5                	mov    %esp,%ebp
  105fd2:	57                   	push   %edi
  105fd3:	56                   	push   %esi
  105fd4:	53                   	push   %ebx
  105fd5:	83 ec 30             	sub    $0x30,%esp
  105fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  105fdb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105fde:	8b 45 0c             	mov    0xc(%ebp),%eax
  105fe1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105fe4:	8b 45 10             	mov    0x10(%ebp),%eax
  105fe7:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  105fea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105fed:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  105ff0:	73 42                	jae    106034 <memmove+0x65>
  105ff2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105ff5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105ff8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105ffb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105ffe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  106001:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  106004:	8b 45 dc             	mov    -0x24(%ebp),%eax
  106007:	c1 e8 02             	shr    $0x2,%eax
  10600a:	89 c1                	mov    %eax,%ecx
    asm volatile (
  10600c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10600f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  106012:	89 d7                	mov    %edx,%edi
  106014:	89 c6                	mov    %eax,%esi
  106016:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  106018:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  10601b:	83 e1 03             	and    $0x3,%ecx
  10601e:	74 02                	je     106022 <memmove+0x53>
  106020:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  106022:	89 f0                	mov    %esi,%eax
  106024:	89 fa                	mov    %edi,%edx
  106026:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  106029:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  10602c:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
  10602f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
  106032:	eb 36                	jmp    10606a <memmove+0x9b>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  106034:	8b 45 e8             	mov    -0x18(%ebp),%eax
  106037:	8d 50 ff             	lea    -0x1(%eax),%edx
  10603a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10603d:	01 c2                	add    %eax,%edx
  10603f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  106042:	8d 48 ff             	lea    -0x1(%eax),%ecx
  106045:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106048:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  10604b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10604e:	89 c1                	mov    %eax,%ecx
  106050:	89 d8                	mov    %ebx,%eax
  106052:	89 d6                	mov    %edx,%esi
  106054:	89 c7                	mov    %eax,%edi
  106056:	fd                   	std    
  106057:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  106059:	fc                   	cld    
  10605a:	89 f8                	mov    %edi,%eax
  10605c:	89 f2                	mov    %esi,%edx
  10605e:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  106061:	89 55 c8             	mov    %edx,-0x38(%ebp)
  106064:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  106067:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  10606a:	83 c4 30             	add    $0x30,%esp
  10606d:	5b                   	pop    %ebx
  10606e:	5e                   	pop    %esi
  10606f:	5f                   	pop    %edi
  106070:	5d                   	pop    %ebp
  106071:	c3                   	ret    

00106072 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  106072:	55                   	push   %ebp
  106073:	89 e5                	mov    %esp,%ebp
  106075:	57                   	push   %edi
  106076:	56                   	push   %esi
  106077:	83 ec 20             	sub    $0x20,%esp
  10607a:	8b 45 08             	mov    0x8(%ebp),%eax
  10607d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  106080:	8b 45 0c             	mov    0xc(%ebp),%eax
  106083:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106086:	8b 45 10             	mov    0x10(%ebp),%eax
  106089:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  10608c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10608f:	c1 e8 02             	shr    $0x2,%eax
  106092:	89 c1                	mov    %eax,%ecx
    asm volatile (
  106094:	8b 55 f4             	mov    -0xc(%ebp),%edx
  106097:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10609a:	89 d7                	mov    %edx,%edi
  10609c:	89 c6                	mov    %eax,%esi
  10609e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1060a0:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  1060a3:	83 e1 03             	and    $0x3,%ecx
  1060a6:	74 02                	je     1060aa <memcpy+0x38>
  1060a8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1060aa:	89 f0                	mov    %esi,%eax
  1060ac:	89 fa                	mov    %edi,%edx
  1060ae:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1060b1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  1060b4:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  1060b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  1060ba:	83 c4 20             	add    $0x20,%esp
  1060bd:	5e                   	pop    %esi
  1060be:	5f                   	pop    %edi
  1060bf:	5d                   	pop    %ebp
  1060c0:	c3                   	ret    

001060c1 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  1060c1:	55                   	push   %ebp
  1060c2:	89 e5                	mov    %esp,%ebp
  1060c4:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  1060c7:	8b 45 08             	mov    0x8(%ebp),%eax
  1060ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  1060cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1060d0:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  1060d3:	eb 2e                	jmp    106103 <memcmp+0x42>
        if (*s1 != *s2) {
  1060d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1060d8:	0f b6 10             	movzbl (%eax),%edx
  1060db:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1060de:	0f b6 00             	movzbl (%eax),%eax
  1060e1:	38 c2                	cmp    %al,%dl
  1060e3:	74 18                	je     1060fd <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  1060e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1060e8:	0f b6 00             	movzbl (%eax),%eax
  1060eb:	0f b6 d0             	movzbl %al,%edx
  1060ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1060f1:	0f b6 00             	movzbl (%eax),%eax
  1060f4:	0f b6 c8             	movzbl %al,%ecx
  1060f7:	89 d0                	mov    %edx,%eax
  1060f9:	29 c8                	sub    %ecx,%eax
  1060fb:	eb 18                	jmp    106115 <memcmp+0x54>
        }
        s1 ++, s2 ++;
  1060fd:	ff 45 fc             	incl   -0x4(%ebp)
  106100:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
  106103:	8b 45 10             	mov    0x10(%ebp),%eax
  106106:	8d 50 ff             	lea    -0x1(%eax),%edx
  106109:	89 55 10             	mov    %edx,0x10(%ebp)
  10610c:	85 c0                	test   %eax,%eax
  10610e:	75 c5                	jne    1060d5 <memcmp+0x14>
    }
    return 0;
  106110:	b8 00 00 00 00       	mov    $0x0,%eax
}
  106115:	89 ec                	mov    %ebp,%esp
  106117:	5d                   	pop    %ebp
  106118:	c3                   	ret    
