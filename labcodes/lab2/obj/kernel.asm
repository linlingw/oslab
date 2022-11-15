
bin/kernel：     文件格式 elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
c0100000:	b8 00 a0 11 00       	mov    $0x11a000,%eax
    movl %eax, %cr3
c0100005:	0f 22 d8             	mov    %eax,%cr3

    # enable paging
    movl %cr0, %eax
c0100008:	0f 20 c0             	mov    %cr0,%eax
    orl $(CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP), %eax
c010000b:	0d 2f 00 05 80       	or     $0x8005002f,%eax
    andl $~(CR0_TS | CR0_EM), %eax
c0100010:	83 e0 f3             	and    $0xfffffff3,%eax
    movl %eax, %cr0
c0100013:	0f 22 c0             	mov    %eax,%cr0

    # update eip
    # now, eip = 0x1.....
    leal next, %eax
c0100016:	8d 05 1e 00 10 c0    	lea    0xc010001e,%eax
    # set eip = KERNBASE + 0x1.....
    jmp *%eax
c010001c:	ff e0                	jmp    *%eax

c010001e <next>:
next:

    # unmap va 0 ~ 4M, it's temporary mapping
    xorl %eax, %eax
c010001e:	31 c0                	xor    %eax,%eax
    movl %eax, __boot_pgdir
c0100020:	a3 00 a0 11 c0       	mov    %eax,0xc011a000

    # set ebp, esp
    movl $0x0, %ebp
c0100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010002a:	bc 00 90 11 c0       	mov    $0xc0119000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c010002f:	e8 02 00 00 00       	call   c0100036 <kern_init>

c0100034 <spin>:

# should never get here
spin:
    jmp spin
c0100034:	eb fe                	jmp    c0100034 <spin>

c0100036 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
c0100036:	55                   	push   %ebp
c0100037:	89 e5                	mov    %esp,%ebp
c0100039:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c010003c:	b8 2c cf 11 c0       	mov    $0xc011cf2c,%eax
c0100041:	2d 00 c0 11 c0       	sub    $0xc011c000,%eax
c0100046:	89 44 24 08          	mov    %eax,0x8(%esp)
c010004a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100051:	00 
c0100052:	c7 04 24 00 c0 11 c0 	movl   $0xc011c000,(%esp)
c0100059:	e8 2f 5f 00 00       	call   c0105f8d <memset>

    cons_init();                // init the console
c010005e:	e8 ea 15 00 00       	call   c010164d <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c0100063:	c7 45 f4 20 61 10 c0 	movl   $0xc0106120,-0xc(%ebp)
    cprintf("%s\n\n", message);
c010006a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010006d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100071:	c7 04 24 3c 61 10 c0 	movl   $0xc010613c,(%esp)
c0100078:	e8 d9 02 00 00       	call   c0100356 <cprintf>

    print_kerninfo();
c010007d:	e8 f7 07 00 00       	call   c0100879 <print_kerninfo>

    grade_backtrace();
c0100082:	e8 90 00 00 00       	call   c0100117 <grade_backtrace>

    pmm_init();                 // init physical memory management
c0100087:	e8 78 44 00 00       	call   c0104504 <pmm_init>

    pic_init();                 // init interrupt controller
c010008c:	e8 3d 17 00 00       	call   c01017ce <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100091:	e8 c4 18 00 00       	call   c010195a <idt_init>

    clock_init();               // init clock interrupt
c0100096:	e8 11 0d 00 00       	call   c0100dac <clock_init>
    intr_enable();              // enable irq interrupt
c010009b:	e8 8c 16 00 00       	call   c010172c <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c01000a0:	eb fe                	jmp    c01000a0 <kern_init+0x6a>

c01000a2 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c01000a2:	55                   	push   %ebp
c01000a3:	89 e5                	mov    %esp,%ebp
c01000a5:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000a8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000af:	00 
c01000b0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000b7:	00 
c01000b8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000bf:	e8 03 0c 00 00       	call   c0100cc7 <mon_backtrace>
}
c01000c4:	90                   	nop
c01000c5:	89 ec                	mov    %ebp,%esp
c01000c7:	5d                   	pop    %ebp
c01000c8:	c3                   	ret    

c01000c9 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000c9:	55                   	push   %ebp
c01000ca:	89 e5                	mov    %esp,%ebp
c01000cc:	83 ec 18             	sub    $0x18,%esp
c01000cf:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000d2:	8d 4d 0c             	lea    0xc(%ebp),%ecx
c01000d5:	8b 55 0c             	mov    0xc(%ebp),%edx
c01000d8:	8d 5d 08             	lea    0x8(%ebp),%ebx
c01000db:	8b 45 08             	mov    0x8(%ebp),%eax
c01000de:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01000e2:	89 54 24 08          	mov    %edx,0x8(%esp)
c01000e6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01000ea:	89 04 24             	mov    %eax,(%esp)
c01000ed:	e8 b0 ff ff ff       	call   c01000a2 <grade_backtrace2>
}
c01000f2:	90                   	nop
c01000f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01000f6:	89 ec                	mov    %ebp,%esp
c01000f8:	5d                   	pop    %ebp
c01000f9:	c3                   	ret    

c01000fa <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000fa:	55                   	push   %ebp
c01000fb:	89 e5                	mov    %esp,%ebp
c01000fd:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c0100100:	8b 45 10             	mov    0x10(%ebp),%eax
c0100103:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100107:	8b 45 08             	mov    0x8(%ebp),%eax
c010010a:	89 04 24             	mov    %eax,(%esp)
c010010d:	e8 b7 ff ff ff       	call   c01000c9 <grade_backtrace1>
}
c0100112:	90                   	nop
c0100113:	89 ec                	mov    %ebp,%esp
c0100115:	5d                   	pop    %ebp
c0100116:	c3                   	ret    

c0100117 <grade_backtrace>:

void
grade_backtrace(void) {
c0100117:	55                   	push   %ebp
c0100118:	89 e5                	mov    %esp,%ebp
c010011a:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c010011d:	b8 36 00 10 c0       	mov    $0xc0100036,%eax
c0100122:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c0100129:	ff 
c010012a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010012e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100135:	e8 c0 ff ff ff       	call   c01000fa <grade_backtrace0>
}
c010013a:	90                   	nop
c010013b:	89 ec                	mov    %ebp,%esp
c010013d:	5d                   	pop    %ebp
c010013e:	c3                   	ret    

c010013f <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c010013f:	55                   	push   %ebp
c0100140:	89 e5                	mov    %esp,%ebp
c0100142:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c0100145:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c0100148:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c010014b:	8c 45 f2             	mov    %es,-0xe(%ebp)
c010014e:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c0100151:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100155:	83 e0 03             	and    $0x3,%eax
c0100158:	89 c2                	mov    %eax,%edx
c010015a:	a1 00 c0 11 c0       	mov    0xc011c000,%eax
c010015f:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100163:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100167:	c7 04 24 41 61 10 c0 	movl   $0xc0106141,(%esp)
c010016e:	e8 e3 01 00 00       	call   c0100356 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100173:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100177:	89 c2                	mov    %eax,%edx
c0100179:	a1 00 c0 11 c0       	mov    0xc011c000,%eax
c010017e:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100182:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100186:	c7 04 24 4f 61 10 c0 	movl   $0xc010614f,(%esp)
c010018d:	e8 c4 01 00 00       	call   c0100356 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c0100192:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100196:	89 c2                	mov    %eax,%edx
c0100198:	a1 00 c0 11 c0       	mov    0xc011c000,%eax
c010019d:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001a1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001a5:	c7 04 24 5d 61 10 c0 	movl   $0xc010615d,(%esp)
c01001ac:	e8 a5 01 00 00       	call   c0100356 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001b1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001b5:	89 c2                	mov    %eax,%edx
c01001b7:	a1 00 c0 11 c0       	mov    0xc011c000,%eax
c01001bc:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001c0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001c4:	c7 04 24 6b 61 10 c0 	movl   $0xc010616b,(%esp)
c01001cb:	e8 86 01 00 00       	call   c0100356 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001d0:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001d4:	89 c2                	mov    %eax,%edx
c01001d6:	a1 00 c0 11 c0       	mov    0xc011c000,%eax
c01001db:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001df:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001e3:	c7 04 24 79 61 10 c0 	movl   $0xc0106179,(%esp)
c01001ea:	e8 67 01 00 00       	call   c0100356 <cprintf>
    round ++;
c01001ef:	a1 00 c0 11 c0       	mov    0xc011c000,%eax
c01001f4:	40                   	inc    %eax
c01001f5:	a3 00 c0 11 c0       	mov    %eax,0xc011c000
}
c01001fa:	90                   	nop
c01001fb:	89 ec                	mov    %ebp,%esp
c01001fd:	5d                   	pop    %ebp
c01001fe:	c3                   	ret    

c01001ff <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001ff:	55                   	push   %ebp
c0100200:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c0100202:	90                   	nop
c0100203:	5d                   	pop    %ebp
c0100204:	c3                   	ret    

c0100205 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c0100205:	55                   	push   %ebp
c0100206:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c0100208:	90                   	nop
c0100209:	5d                   	pop    %ebp
c010020a:	c3                   	ret    

c010020b <lab1_switch_test>:

static void
lab1_switch_test(void) {
c010020b:	55                   	push   %ebp
c010020c:	89 e5                	mov    %esp,%ebp
c010020e:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c0100211:	e8 29 ff ff ff       	call   c010013f <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c0100216:	c7 04 24 88 61 10 c0 	movl   $0xc0106188,(%esp)
c010021d:	e8 34 01 00 00       	call   c0100356 <cprintf>
    lab1_switch_to_user();
c0100222:	e8 d8 ff ff ff       	call   c01001ff <lab1_switch_to_user>
    lab1_print_cur_status();
c0100227:	e8 13 ff ff ff       	call   c010013f <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c010022c:	c7 04 24 a8 61 10 c0 	movl   $0xc01061a8,(%esp)
c0100233:	e8 1e 01 00 00       	call   c0100356 <cprintf>
    lab1_switch_to_kernel();
c0100238:	e8 c8 ff ff ff       	call   c0100205 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c010023d:	e8 fd fe ff ff       	call   c010013f <lab1_print_cur_status>
}
c0100242:	90                   	nop
c0100243:	89 ec                	mov    %ebp,%esp
c0100245:	5d                   	pop    %ebp
c0100246:	c3                   	ret    

c0100247 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c0100247:	55                   	push   %ebp
c0100248:	89 e5                	mov    %esp,%ebp
c010024a:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c010024d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100251:	74 13                	je     c0100266 <readline+0x1f>
        cprintf("%s", prompt);
c0100253:	8b 45 08             	mov    0x8(%ebp),%eax
c0100256:	89 44 24 04          	mov    %eax,0x4(%esp)
c010025a:	c7 04 24 c7 61 10 c0 	movl   $0xc01061c7,(%esp)
c0100261:	e8 f0 00 00 00       	call   c0100356 <cprintf>
    }
    int i = 0, c;
c0100266:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c010026d:	e8 73 01 00 00       	call   c01003e5 <getchar>
c0100272:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100275:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100279:	79 07                	jns    c0100282 <readline+0x3b>
            return NULL;
c010027b:	b8 00 00 00 00       	mov    $0x0,%eax
c0100280:	eb 78                	jmp    c01002fa <readline+0xb3>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c0100282:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c0100286:	7e 28                	jle    c01002b0 <readline+0x69>
c0100288:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c010028f:	7f 1f                	jg     c01002b0 <readline+0x69>
            cputchar(c);
c0100291:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100294:	89 04 24             	mov    %eax,(%esp)
c0100297:	e8 e2 00 00 00       	call   c010037e <cputchar>
            buf[i ++] = c;
c010029c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010029f:	8d 50 01             	lea    0x1(%eax),%edx
c01002a2:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01002a5:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01002a8:	88 90 20 c0 11 c0    	mov    %dl,-0x3fee3fe0(%eax)
c01002ae:	eb 45                	jmp    c01002f5 <readline+0xae>
        }
        else if (c == '\b' && i > 0) {
c01002b0:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01002b4:	75 16                	jne    c01002cc <readline+0x85>
c01002b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01002ba:	7e 10                	jle    c01002cc <readline+0x85>
            cputchar(c);
c01002bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002bf:	89 04 24             	mov    %eax,(%esp)
c01002c2:	e8 b7 00 00 00       	call   c010037e <cputchar>
            i --;
c01002c7:	ff 4d f4             	decl   -0xc(%ebp)
c01002ca:	eb 29                	jmp    c01002f5 <readline+0xae>
        }
        else if (c == '\n' || c == '\r') {
c01002cc:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01002d0:	74 06                	je     c01002d8 <readline+0x91>
c01002d2:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01002d6:	75 95                	jne    c010026d <readline+0x26>
            cputchar(c);
c01002d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002db:	89 04 24             	mov    %eax,(%esp)
c01002de:	e8 9b 00 00 00       	call   c010037e <cputchar>
            buf[i] = '\0';
c01002e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002e6:	05 20 c0 11 c0       	add    $0xc011c020,%eax
c01002eb:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002ee:	b8 20 c0 11 c0       	mov    $0xc011c020,%eax
c01002f3:	eb 05                	jmp    c01002fa <readline+0xb3>
        c = getchar();
c01002f5:	e9 73 ff ff ff       	jmp    c010026d <readline+0x26>
        }
    }
}
c01002fa:	89 ec                	mov    %ebp,%esp
c01002fc:	5d                   	pop    %ebp
c01002fd:	c3                   	ret    

c01002fe <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c01002fe:	55                   	push   %ebp
c01002ff:	89 e5                	mov    %esp,%ebp
c0100301:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100304:	8b 45 08             	mov    0x8(%ebp),%eax
c0100307:	89 04 24             	mov    %eax,(%esp)
c010030a:	e8 6d 13 00 00       	call   c010167c <cons_putc>
    (*cnt) ++;
c010030f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100312:	8b 00                	mov    (%eax),%eax
c0100314:	8d 50 01             	lea    0x1(%eax),%edx
c0100317:	8b 45 0c             	mov    0xc(%ebp),%eax
c010031a:	89 10                	mov    %edx,(%eax)
}
c010031c:	90                   	nop
c010031d:	89 ec                	mov    %ebp,%esp
c010031f:	5d                   	pop    %ebp
c0100320:	c3                   	ret    

c0100321 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100321:	55                   	push   %ebp
c0100322:	89 e5                	mov    %esp,%ebp
c0100324:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c0100327:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c010032e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100331:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0100335:	8b 45 08             	mov    0x8(%ebp),%eax
c0100338:	89 44 24 08          	mov    %eax,0x8(%esp)
c010033c:	8d 45 f4             	lea    -0xc(%ebp),%eax
c010033f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100343:	c7 04 24 fe 02 10 c0 	movl   $0xc01002fe,(%esp)
c010034a:	e8 69 54 00 00       	call   c01057b8 <vprintfmt>
    return cnt;
c010034f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100352:	89 ec                	mov    %ebp,%esp
c0100354:	5d                   	pop    %ebp
c0100355:	c3                   	ret    

c0100356 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c0100356:	55                   	push   %ebp
c0100357:	89 e5                	mov    %esp,%ebp
c0100359:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c010035c:	8d 45 0c             	lea    0xc(%ebp),%eax
c010035f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c0100362:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100365:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100369:	8b 45 08             	mov    0x8(%ebp),%eax
c010036c:	89 04 24             	mov    %eax,(%esp)
c010036f:	e8 ad ff ff ff       	call   c0100321 <vcprintf>
c0100374:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0100377:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010037a:	89 ec                	mov    %ebp,%esp
c010037c:	5d                   	pop    %ebp
c010037d:	c3                   	ret    

c010037e <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c010037e:	55                   	push   %ebp
c010037f:	89 e5                	mov    %esp,%ebp
c0100381:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100384:	8b 45 08             	mov    0x8(%ebp),%eax
c0100387:	89 04 24             	mov    %eax,(%esp)
c010038a:	e8 ed 12 00 00       	call   c010167c <cons_putc>
}
c010038f:	90                   	nop
c0100390:	89 ec                	mov    %ebp,%esp
c0100392:	5d                   	pop    %ebp
c0100393:	c3                   	ret    

c0100394 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c0100394:	55                   	push   %ebp
c0100395:	89 e5                	mov    %esp,%ebp
c0100397:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010039a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c01003a1:	eb 13                	jmp    c01003b6 <cputs+0x22>
        cputch(c, &cnt);
c01003a3:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c01003a7:	8d 55 f0             	lea    -0x10(%ebp),%edx
c01003aa:	89 54 24 04          	mov    %edx,0x4(%esp)
c01003ae:	89 04 24             	mov    %eax,(%esp)
c01003b1:	e8 48 ff ff ff       	call   c01002fe <cputch>
    while ((c = *str ++) != '\0') {
c01003b6:	8b 45 08             	mov    0x8(%ebp),%eax
c01003b9:	8d 50 01             	lea    0x1(%eax),%edx
c01003bc:	89 55 08             	mov    %edx,0x8(%ebp)
c01003bf:	0f b6 00             	movzbl (%eax),%eax
c01003c2:	88 45 f7             	mov    %al,-0x9(%ebp)
c01003c5:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01003c9:	75 d8                	jne    c01003a3 <cputs+0xf>
    }
    cputch('\n', &cnt);
c01003cb:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01003ce:	89 44 24 04          	mov    %eax,0x4(%esp)
c01003d2:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c01003d9:	e8 20 ff ff ff       	call   c01002fe <cputch>
    return cnt;
c01003de:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01003e1:	89 ec                	mov    %ebp,%esp
c01003e3:	5d                   	pop    %ebp
c01003e4:	c3                   	ret    

c01003e5 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01003e5:	55                   	push   %ebp
c01003e6:	89 e5                	mov    %esp,%ebp
c01003e8:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c01003eb:	90                   	nop
c01003ec:	e8 ca 12 00 00       	call   c01016bb <cons_getc>
c01003f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01003f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003f8:	74 f2                	je     c01003ec <getchar+0x7>
        /* do nothing */;
    return c;
c01003fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01003fd:	89 ec                	mov    %ebp,%esp
c01003ff:	5d                   	pop    %ebp
c0100400:	c3                   	ret    

c0100401 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c0100401:	55                   	push   %ebp
c0100402:	89 e5                	mov    %esp,%ebp
c0100404:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c0100407:	8b 45 0c             	mov    0xc(%ebp),%eax
c010040a:	8b 00                	mov    (%eax),%eax
c010040c:	89 45 fc             	mov    %eax,-0x4(%ebp)
c010040f:	8b 45 10             	mov    0x10(%ebp),%eax
c0100412:	8b 00                	mov    (%eax),%eax
c0100414:	89 45 f8             	mov    %eax,-0x8(%ebp)
c0100417:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c010041e:	e9 ca 00 00 00       	jmp    c01004ed <stab_binsearch+0xec>
        int true_m = (l + r) / 2, m = true_m;
c0100423:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100426:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100429:	01 d0                	add    %edx,%eax
c010042b:	89 c2                	mov    %eax,%edx
c010042d:	c1 ea 1f             	shr    $0x1f,%edx
c0100430:	01 d0                	add    %edx,%eax
c0100432:	d1 f8                	sar    %eax
c0100434:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0100437:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010043a:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c010043d:	eb 03                	jmp    c0100442 <stab_binsearch+0x41>
            m --;
c010043f:	ff 4d f0             	decl   -0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
c0100442:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100445:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100448:	7c 1f                	jl     c0100469 <stab_binsearch+0x68>
c010044a:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010044d:	89 d0                	mov    %edx,%eax
c010044f:	01 c0                	add    %eax,%eax
c0100451:	01 d0                	add    %edx,%eax
c0100453:	c1 e0 02             	shl    $0x2,%eax
c0100456:	89 c2                	mov    %eax,%edx
c0100458:	8b 45 08             	mov    0x8(%ebp),%eax
c010045b:	01 d0                	add    %edx,%eax
c010045d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100461:	0f b6 c0             	movzbl %al,%eax
c0100464:	39 45 14             	cmp    %eax,0x14(%ebp)
c0100467:	75 d6                	jne    c010043f <stab_binsearch+0x3e>
        }
        if (m < l) {    // no match in [l, m]
c0100469:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010046c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010046f:	7d 09                	jge    c010047a <stab_binsearch+0x79>
            l = true_m + 1;
c0100471:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100474:	40                   	inc    %eax
c0100475:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100478:	eb 73                	jmp    c01004ed <stab_binsearch+0xec>
        }

        // actual binary search
        any_matches = 1;
c010047a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c0100481:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100484:	89 d0                	mov    %edx,%eax
c0100486:	01 c0                	add    %eax,%eax
c0100488:	01 d0                	add    %edx,%eax
c010048a:	c1 e0 02             	shl    $0x2,%eax
c010048d:	89 c2                	mov    %eax,%edx
c010048f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100492:	01 d0                	add    %edx,%eax
c0100494:	8b 40 08             	mov    0x8(%eax),%eax
c0100497:	39 45 18             	cmp    %eax,0x18(%ebp)
c010049a:	76 11                	jbe    c01004ad <stab_binsearch+0xac>
            *region_left = m;
c010049c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010049f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004a2:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c01004a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01004a7:	40                   	inc    %eax
c01004a8:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01004ab:	eb 40                	jmp    c01004ed <stab_binsearch+0xec>
        } else if (stabs[m].n_value > addr) {
c01004ad:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004b0:	89 d0                	mov    %edx,%eax
c01004b2:	01 c0                	add    %eax,%eax
c01004b4:	01 d0                	add    %edx,%eax
c01004b6:	c1 e0 02             	shl    $0x2,%eax
c01004b9:	89 c2                	mov    %eax,%edx
c01004bb:	8b 45 08             	mov    0x8(%ebp),%eax
c01004be:	01 d0                	add    %edx,%eax
c01004c0:	8b 40 08             	mov    0x8(%eax),%eax
c01004c3:	39 45 18             	cmp    %eax,0x18(%ebp)
c01004c6:	73 14                	jae    c01004dc <stab_binsearch+0xdb>
            *region_right = m - 1;
c01004c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004cb:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004ce:	8b 45 10             	mov    0x10(%ebp),%eax
c01004d1:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01004d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004d6:	48                   	dec    %eax
c01004d7:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004da:	eb 11                	jmp    c01004ed <stab_binsearch+0xec>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01004dc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004df:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004e2:	89 10                	mov    %edx,(%eax)
            l = m;
c01004e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01004ea:	ff 45 18             	incl   0x18(%ebp)
    while (l <= r) {
c01004ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01004f0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01004f3:	0f 8e 2a ff ff ff    	jle    c0100423 <stab_binsearch+0x22>
        }
    }

    if (!any_matches) {
c01004f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01004fd:	75 0f                	jne    c010050e <stab_binsearch+0x10d>
        *region_right = *region_left - 1;
c01004ff:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100502:	8b 00                	mov    (%eax),%eax
c0100504:	8d 50 ff             	lea    -0x1(%eax),%edx
c0100507:	8b 45 10             	mov    0x10(%ebp),%eax
c010050a:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
c010050c:	eb 3e                	jmp    c010054c <stab_binsearch+0x14b>
        l = *region_right;
c010050e:	8b 45 10             	mov    0x10(%ebp),%eax
c0100511:	8b 00                	mov    (%eax),%eax
c0100513:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c0100516:	eb 03                	jmp    c010051b <stab_binsearch+0x11a>
c0100518:	ff 4d fc             	decl   -0x4(%ebp)
c010051b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010051e:	8b 00                	mov    (%eax),%eax
c0100520:	39 45 fc             	cmp    %eax,-0x4(%ebp)
c0100523:	7e 1f                	jle    c0100544 <stab_binsearch+0x143>
c0100525:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100528:	89 d0                	mov    %edx,%eax
c010052a:	01 c0                	add    %eax,%eax
c010052c:	01 d0                	add    %edx,%eax
c010052e:	c1 e0 02             	shl    $0x2,%eax
c0100531:	89 c2                	mov    %eax,%edx
c0100533:	8b 45 08             	mov    0x8(%ebp),%eax
c0100536:	01 d0                	add    %edx,%eax
c0100538:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010053c:	0f b6 c0             	movzbl %al,%eax
c010053f:	39 45 14             	cmp    %eax,0x14(%ebp)
c0100542:	75 d4                	jne    c0100518 <stab_binsearch+0x117>
        *region_left = l;
c0100544:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100547:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010054a:	89 10                	mov    %edx,(%eax)
}
c010054c:	90                   	nop
c010054d:	89 ec                	mov    %ebp,%esp
c010054f:	5d                   	pop    %ebp
c0100550:	c3                   	ret    

c0100551 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c0100551:	55                   	push   %ebp
c0100552:	89 e5                	mov    %esp,%ebp
c0100554:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100557:	8b 45 0c             	mov    0xc(%ebp),%eax
c010055a:	c7 00 cc 61 10 c0    	movl   $0xc01061cc,(%eax)
    info->eip_line = 0;
c0100560:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100563:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c010056a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010056d:	c7 40 08 cc 61 10 c0 	movl   $0xc01061cc,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100574:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100577:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c010057e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100581:	8b 55 08             	mov    0x8(%ebp),%edx
c0100584:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100587:	8b 45 0c             	mov    0xc(%ebp),%eax
c010058a:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c0100591:	c7 45 f4 90 74 10 c0 	movl   $0xc0107490,-0xc(%ebp)
    stab_end = __STAB_END__;
c0100598:	c7 45 f0 bc 2c 11 c0 	movl   $0xc0112cbc,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c010059f:	c7 45 ec bd 2c 11 c0 	movl   $0xc0112cbd,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c01005a6:	c7 45 e8 55 62 11 c0 	movl   $0xc0116255,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c01005ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01005b0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01005b3:	76 0b                	jbe    c01005c0 <debuginfo_eip+0x6f>
c01005b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01005b8:	48                   	dec    %eax
c01005b9:	0f b6 00             	movzbl (%eax),%eax
c01005bc:	84 c0                	test   %al,%al
c01005be:	74 0a                	je     c01005ca <debuginfo_eip+0x79>
        return -1;
c01005c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01005c5:	e9 ab 02 00 00       	jmp    c0100875 <debuginfo_eip+0x324>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01005ca:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01005d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01005d4:	2b 45 f4             	sub    -0xc(%ebp),%eax
c01005d7:	c1 f8 02             	sar    $0x2,%eax
c01005da:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01005e0:	48                   	dec    %eax
c01005e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01005e4:	8b 45 08             	mov    0x8(%ebp),%eax
c01005e7:	89 44 24 10          	mov    %eax,0x10(%esp)
c01005eb:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01005f2:	00 
c01005f3:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01005f6:	89 44 24 08          	mov    %eax,0x8(%esp)
c01005fa:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01005fd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100601:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100604:	89 04 24             	mov    %eax,(%esp)
c0100607:	e8 f5 fd ff ff       	call   c0100401 <stab_binsearch>
    if (lfile == 0)
c010060c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010060f:	85 c0                	test   %eax,%eax
c0100611:	75 0a                	jne    c010061d <debuginfo_eip+0xcc>
        return -1;
c0100613:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100618:	e9 58 02 00 00       	jmp    c0100875 <debuginfo_eip+0x324>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c010061d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100620:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0100623:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100626:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c0100629:	8b 45 08             	mov    0x8(%ebp),%eax
c010062c:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100630:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c0100637:	00 
c0100638:	8d 45 d8             	lea    -0x28(%ebp),%eax
c010063b:	89 44 24 08          	mov    %eax,0x8(%esp)
c010063f:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100642:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100646:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100649:	89 04 24             	mov    %eax,(%esp)
c010064c:	e8 b0 fd ff ff       	call   c0100401 <stab_binsearch>

    if (lfun <= rfun) {
c0100651:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100654:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100657:	39 c2                	cmp    %eax,%edx
c0100659:	7f 78                	jg     c01006d3 <debuginfo_eip+0x182>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c010065b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010065e:	89 c2                	mov    %eax,%edx
c0100660:	89 d0                	mov    %edx,%eax
c0100662:	01 c0                	add    %eax,%eax
c0100664:	01 d0                	add    %edx,%eax
c0100666:	c1 e0 02             	shl    $0x2,%eax
c0100669:	89 c2                	mov    %eax,%edx
c010066b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010066e:	01 d0                	add    %edx,%eax
c0100670:	8b 10                	mov    (%eax),%edx
c0100672:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100675:	2b 45 ec             	sub    -0x14(%ebp),%eax
c0100678:	39 c2                	cmp    %eax,%edx
c010067a:	73 22                	jae    c010069e <debuginfo_eip+0x14d>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c010067c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010067f:	89 c2                	mov    %eax,%edx
c0100681:	89 d0                	mov    %edx,%eax
c0100683:	01 c0                	add    %eax,%eax
c0100685:	01 d0                	add    %edx,%eax
c0100687:	c1 e0 02             	shl    $0x2,%eax
c010068a:	89 c2                	mov    %eax,%edx
c010068c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010068f:	01 d0                	add    %edx,%eax
c0100691:	8b 10                	mov    (%eax),%edx
c0100693:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100696:	01 c2                	add    %eax,%edx
c0100698:	8b 45 0c             	mov    0xc(%ebp),%eax
c010069b:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c010069e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006a1:	89 c2                	mov    %eax,%edx
c01006a3:	89 d0                	mov    %edx,%eax
c01006a5:	01 c0                	add    %eax,%eax
c01006a7:	01 d0                	add    %edx,%eax
c01006a9:	c1 e0 02             	shl    $0x2,%eax
c01006ac:	89 c2                	mov    %eax,%edx
c01006ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006b1:	01 d0                	add    %edx,%eax
c01006b3:	8b 50 08             	mov    0x8(%eax),%edx
c01006b6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006b9:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01006bc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006bf:	8b 40 10             	mov    0x10(%eax),%eax
c01006c2:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01006c5:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006c8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01006cb:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01006ce:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01006d1:	eb 15                	jmp    c01006e8 <debuginfo_eip+0x197>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01006d3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006d6:	8b 55 08             	mov    0x8(%ebp),%edx
c01006d9:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01006dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006df:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01006e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006e5:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01006e8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006eb:	8b 40 08             	mov    0x8(%eax),%eax
c01006ee:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01006f5:	00 
c01006f6:	89 04 24             	mov    %eax,(%esp)
c01006f9:	e8 07 57 00 00       	call   c0105e05 <strfind>
c01006fe:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100701:	8b 4a 08             	mov    0x8(%edx),%ecx
c0100704:	29 c8                	sub    %ecx,%eax
c0100706:	89 c2                	mov    %eax,%edx
c0100708:	8b 45 0c             	mov    0xc(%ebp),%eax
c010070b:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c010070e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100711:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100715:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c010071c:	00 
c010071d:	8d 45 d0             	lea    -0x30(%ebp),%eax
c0100720:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100724:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c0100727:	89 44 24 04          	mov    %eax,0x4(%esp)
c010072b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010072e:	89 04 24             	mov    %eax,(%esp)
c0100731:	e8 cb fc ff ff       	call   c0100401 <stab_binsearch>
    if (lline <= rline) {
c0100736:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100739:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010073c:	39 c2                	cmp    %eax,%edx
c010073e:	7f 23                	jg     c0100763 <debuginfo_eip+0x212>
        info->eip_line = stabs[rline].n_desc;
c0100740:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100743:	89 c2                	mov    %eax,%edx
c0100745:	89 d0                	mov    %edx,%eax
c0100747:	01 c0                	add    %eax,%eax
c0100749:	01 d0                	add    %edx,%eax
c010074b:	c1 e0 02             	shl    $0x2,%eax
c010074e:	89 c2                	mov    %eax,%edx
c0100750:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100753:	01 d0                	add    %edx,%eax
c0100755:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c0100759:	89 c2                	mov    %eax,%edx
c010075b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010075e:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100761:	eb 11                	jmp    c0100774 <debuginfo_eip+0x223>
        return -1;
c0100763:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100768:	e9 08 01 00 00       	jmp    c0100875 <debuginfo_eip+0x324>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c010076d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100770:	48                   	dec    %eax
c0100771:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
c0100774:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100777:	8b 45 e4             	mov    -0x1c(%ebp),%eax
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c010077a:	39 c2                	cmp    %eax,%edx
c010077c:	7c 56                	jl     c01007d4 <debuginfo_eip+0x283>
           && stabs[lline].n_type != N_SOL
c010077e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100781:	89 c2                	mov    %eax,%edx
c0100783:	89 d0                	mov    %edx,%eax
c0100785:	01 c0                	add    %eax,%eax
c0100787:	01 d0                	add    %edx,%eax
c0100789:	c1 e0 02             	shl    $0x2,%eax
c010078c:	89 c2                	mov    %eax,%edx
c010078e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100791:	01 d0                	add    %edx,%eax
c0100793:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100797:	3c 84                	cmp    $0x84,%al
c0100799:	74 39                	je     c01007d4 <debuginfo_eip+0x283>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c010079b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010079e:	89 c2                	mov    %eax,%edx
c01007a0:	89 d0                	mov    %edx,%eax
c01007a2:	01 c0                	add    %eax,%eax
c01007a4:	01 d0                	add    %edx,%eax
c01007a6:	c1 e0 02             	shl    $0x2,%eax
c01007a9:	89 c2                	mov    %eax,%edx
c01007ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007ae:	01 d0                	add    %edx,%eax
c01007b0:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01007b4:	3c 64                	cmp    $0x64,%al
c01007b6:	75 b5                	jne    c010076d <debuginfo_eip+0x21c>
c01007b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007bb:	89 c2                	mov    %eax,%edx
c01007bd:	89 d0                	mov    %edx,%eax
c01007bf:	01 c0                	add    %eax,%eax
c01007c1:	01 d0                	add    %edx,%eax
c01007c3:	c1 e0 02             	shl    $0x2,%eax
c01007c6:	89 c2                	mov    %eax,%edx
c01007c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007cb:	01 d0                	add    %edx,%eax
c01007cd:	8b 40 08             	mov    0x8(%eax),%eax
c01007d0:	85 c0                	test   %eax,%eax
c01007d2:	74 99                	je     c010076d <debuginfo_eip+0x21c>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01007d4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007da:	39 c2                	cmp    %eax,%edx
c01007dc:	7c 42                	jl     c0100820 <debuginfo_eip+0x2cf>
c01007de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007e1:	89 c2                	mov    %eax,%edx
c01007e3:	89 d0                	mov    %edx,%eax
c01007e5:	01 c0                	add    %eax,%eax
c01007e7:	01 d0                	add    %edx,%eax
c01007e9:	c1 e0 02             	shl    $0x2,%eax
c01007ec:	89 c2                	mov    %eax,%edx
c01007ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007f1:	01 d0                	add    %edx,%eax
c01007f3:	8b 10                	mov    (%eax),%edx
c01007f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01007f8:	2b 45 ec             	sub    -0x14(%ebp),%eax
c01007fb:	39 c2                	cmp    %eax,%edx
c01007fd:	73 21                	jae    c0100820 <debuginfo_eip+0x2cf>
        info->eip_file = stabstr + stabs[lline].n_strx;
c01007ff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100802:	89 c2                	mov    %eax,%edx
c0100804:	89 d0                	mov    %edx,%eax
c0100806:	01 c0                	add    %eax,%eax
c0100808:	01 d0                	add    %edx,%eax
c010080a:	c1 e0 02             	shl    $0x2,%eax
c010080d:	89 c2                	mov    %eax,%edx
c010080f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100812:	01 d0                	add    %edx,%eax
c0100814:	8b 10                	mov    (%eax),%edx
c0100816:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100819:	01 c2                	add    %eax,%edx
c010081b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010081e:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c0100820:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100823:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100826:	39 c2                	cmp    %eax,%edx
c0100828:	7d 46                	jge    c0100870 <debuginfo_eip+0x31f>
        for (lline = lfun + 1;
c010082a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010082d:	40                   	inc    %eax
c010082e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0100831:	eb 16                	jmp    c0100849 <debuginfo_eip+0x2f8>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c0100833:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100836:	8b 40 14             	mov    0x14(%eax),%eax
c0100839:	8d 50 01             	lea    0x1(%eax),%edx
c010083c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010083f:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
c0100842:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100845:	40                   	inc    %eax
c0100846:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100849:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010084c:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010084f:	39 c2                	cmp    %eax,%edx
c0100851:	7d 1d                	jge    c0100870 <debuginfo_eip+0x31f>
c0100853:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100856:	89 c2                	mov    %eax,%edx
c0100858:	89 d0                	mov    %edx,%eax
c010085a:	01 c0                	add    %eax,%eax
c010085c:	01 d0                	add    %edx,%eax
c010085e:	c1 e0 02             	shl    $0x2,%eax
c0100861:	89 c2                	mov    %eax,%edx
c0100863:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100866:	01 d0                	add    %edx,%eax
c0100868:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010086c:	3c a0                	cmp    $0xa0,%al
c010086e:	74 c3                	je     c0100833 <debuginfo_eip+0x2e2>
        }
    }
    return 0;
c0100870:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100875:	89 ec                	mov    %ebp,%esp
c0100877:	5d                   	pop    %ebp
c0100878:	c3                   	ret    

c0100879 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c0100879:	55                   	push   %ebp
c010087a:	89 e5                	mov    %esp,%ebp
c010087c:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c010087f:	c7 04 24 d6 61 10 c0 	movl   $0xc01061d6,(%esp)
c0100886:	e8 cb fa ff ff       	call   c0100356 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c010088b:	c7 44 24 04 36 00 10 	movl   $0xc0100036,0x4(%esp)
c0100892:	c0 
c0100893:	c7 04 24 ef 61 10 c0 	movl   $0xc01061ef,(%esp)
c010089a:	e8 b7 fa ff ff       	call   c0100356 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c010089f:	c7 44 24 04 19 61 10 	movl   $0xc0106119,0x4(%esp)
c01008a6:	c0 
c01008a7:	c7 04 24 07 62 10 c0 	movl   $0xc0106207,(%esp)
c01008ae:	e8 a3 fa ff ff       	call   c0100356 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01008b3:	c7 44 24 04 00 c0 11 	movl   $0xc011c000,0x4(%esp)
c01008ba:	c0 
c01008bb:	c7 04 24 1f 62 10 c0 	movl   $0xc010621f,(%esp)
c01008c2:	e8 8f fa ff ff       	call   c0100356 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01008c7:	c7 44 24 04 2c cf 11 	movl   $0xc011cf2c,0x4(%esp)
c01008ce:	c0 
c01008cf:	c7 04 24 37 62 10 c0 	movl   $0xc0106237,(%esp)
c01008d6:	e8 7b fa ff ff       	call   c0100356 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01008db:	b8 2c cf 11 c0       	mov    $0xc011cf2c,%eax
c01008e0:	2d 36 00 10 c0       	sub    $0xc0100036,%eax
c01008e5:	05 ff 03 00 00       	add    $0x3ff,%eax
c01008ea:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008f0:	85 c0                	test   %eax,%eax
c01008f2:	0f 48 c2             	cmovs  %edx,%eax
c01008f5:	c1 f8 0a             	sar    $0xa,%eax
c01008f8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01008fc:	c7 04 24 50 62 10 c0 	movl   $0xc0106250,(%esp)
c0100903:	e8 4e fa ff ff       	call   c0100356 <cprintf>
}
c0100908:	90                   	nop
c0100909:	89 ec                	mov    %ebp,%esp
c010090b:	5d                   	pop    %ebp
c010090c:	c3                   	ret    

c010090d <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c010090d:	55                   	push   %ebp
c010090e:	89 e5                	mov    %esp,%ebp
c0100910:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c0100916:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100919:	89 44 24 04          	mov    %eax,0x4(%esp)
c010091d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100920:	89 04 24             	mov    %eax,(%esp)
c0100923:	e8 29 fc ff ff       	call   c0100551 <debuginfo_eip>
c0100928:	85 c0                	test   %eax,%eax
c010092a:	74 15                	je     c0100941 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c010092c:	8b 45 08             	mov    0x8(%ebp),%eax
c010092f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100933:	c7 04 24 7a 62 10 c0 	movl   $0xc010627a,(%esp)
c010093a:	e8 17 fa ff ff       	call   c0100356 <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
c010093f:	eb 6c                	jmp    c01009ad <print_debuginfo+0xa0>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100941:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100948:	eb 1b                	jmp    c0100965 <print_debuginfo+0x58>
            fnname[j] = info.eip_fn_name[j];
c010094a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010094d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100950:	01 d0                	add    %edx,%eax
c0100952:	0f b6 10             	movzbl (%eax),%edx
c0100955:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c010095b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010095e:	01 c8                	add    %ecx,%eax
c0100960:	88 10                	mov    %dl,(%eax)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100962:	ff 45 f4             	incl   -0xc(%ebp)
c0100965:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100968:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c010096b:	7c dd                	jl     c010094a <print_debuginfo+0x3d>
        fnname[j] = '\0';
c010096d:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c0100973:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100976:	01 d0                	add    %edx,%eax
c0100978:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
c010097b:	8b 55 ec             	mov    -0x14(%ebp),%edx
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c010097e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100981:	29 d0                	sub    %edx,%eax
c0100983:	89 c1                	mov    %eax,%ecx
c0100985:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100988:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010098b:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c010098f:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100995:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0100999:	89 54 24 08          	mov    %edx,0x8(%esp)
c010099d:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009a1:	c7 04 24 96 62 10 c0 	movl   $0xc0106296,(%esp)
c01009a8:	e8 a9 f9 ff ff       	call   c0100356 <cprintf>
}
c01009ad:	90                   	nop
c01009ae:	89 ec                	mov    %ebp,%esp
c01009b0:	5d                   	pop    %ebp
c01009b1:	c3                   	ret    

c01009b2 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c01009b2:	55                   	push   %ebp
c01009b3:	89 e5                	mov    %esp,%ebp
c01009b5:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c01009b8:	8b 45 04             	mov    0x4(%ebp),%eax
c01009bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c01009be:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01009c1:	89 ec                	mov    %ebp,%esp
c01009c3:	5d                   	pop    %ebp
c01009c4:	c3                   	ret    

c01009c5 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c01009c5:	55                   	push   %ebp
c01009c6:	89 e5                	mov    %esp,%ebp
c01009c8:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c01009cb:	89 e8                	mov    %ebp,%eax
c01009cd:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
c01009d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
     /* LAB1 YOUR CODE : STEP 1 */
     uint32_t ebp = read_ebp();// (1) call read_ebp() to get the value of ebp. the type is (uint32_t);
c01009d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
     uint32_t eip = read_eip();// (2) call read_eip() to get the value of eip. the type is (uint32_t);
c01009d6:	e8 d7 ff ff ff       	call   c01009b2 <read_eip>
c01009db:	89 45 f0             	mov    %eax,-0x10(%ebp)

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) 
c01009de:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01009e5:	e9 84 00 00 00       	jmp    c0100a6e <print_stackframe+0xa9>
    {// (3) from 0 .. STACKFRAME_DEPTH
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);//    (3.1) printf value of ebp, eip
c01009ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01009ed:	89 44 24 08          	mov    %eax,0x8(%esp)
c01009f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009f8:	c7 04 24 a8 62 10 c0 	movl   $0xc01062a8,(%esp)
c01009ff:	e8 52 f9 ff ff       	call   c0100356 <cprintf>
        uint32_t *args = (uint32_t *)ebp + 2;
c0100a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a07:	83 c0 08             	add    $0x8,%eax
c0100a0a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (j = 0; j < 4; j ++) 
c0100a0d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100a14:	eb 24                	jmp    c0100a3a <print_stackframe+0x75>
        {
            cprintf("0x%08x ", args[j]);
c0100a16:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a19:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100a20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100a23:	01 d0                	add    %edx,%eax
c0100a25:	8b 00                	mov    (%eax),%eax
c0100a27:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a2b:	c7 04 24 c4 62 10 c0 	movl   $0xc01062c4,(%esp)
c0100a32:	e8 1f f9 ff ff       	call   c0100356 <cprintf>
        for (j = 0; j < 4; j ++) 
c0100a37:	ff 45 e8             	incl   -0x18(%ebp)
c0100a3a:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100a3e:	7e d6                	jle    c0100a16 <print_stackframe+0x51>
        }//    (3.2) (uint32_t)calling arguments [0..4] = the contents in address (uint32_t)ebp +2 [0..4]
        cprintf("\n");//    (3.3) cprintf("\n");
c0100a40:	c7 04 24 cc 62 10 c0 	movl   $0xc01062cc,(%esp)
c0100a47:	e8 0a f9 ff ff       	call   c0100356 <cprintf>
        print_debuginfo(eip - 1);//    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
c0100a4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100a4f:	48                   	dec    %eax
c0100a50:	89 04 24             	mov    %eax,(%esp)
c0100a53:	e8 b5 fe ff ff       	call   c010090d <print_debuginfo>
        eip = ((uint32_t *)ebp)[1];
c0100a58:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a5b:	83 c0 04             	add    $0x4,%eax
c0100a5e:	8b 00                	mov    (%eax),%eax
c0100a60:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];//	(3.5) popup a calling stackframe
c0100a63:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a66:	8b 00                	mov    (%eax),%eax
c0100a68:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) 
c0100a6b:	ff 45 ec             	incl   -0x14(%ebp)
c0100a6e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100a72:	74 0a                	je     c0100a7e <print_stackframe+0xb9>
c0100a74:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100a78:	0f 8e 6c ff ff ff    	jle    c01009ea <print_stackframe+0x25>
      	//	NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      	//	the calling funciton's ebp = ss:[ebp]
    }
}
c0100a7e:	90                   	nop
c0100a7f:	89 ec                	mov    %ebp,%esp
c0100a81:	5d                   	pop    %ebp
c0100a82:	c3                   	ret    

c0100a83 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100a83:	55                   	push   %ebp
c0100a84:	89 e5                	mov    %esp,%ebp
c0100a86:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100a89:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a90:	eb 0c                	jmp    c0100a9e <parse+0x1b>
            *buf ++ = '\0';
c0100a92:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a95:	8d 50 01             	lea    0x1(%eax),%edx
c0100a98:	89 55 08             	mov    %edx,0x8(%ebp)
c0100a9b:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a9e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aa1:	0f b6 00             	movzbl (%eax),%eax
c0100aa4:	84 c0                	test   %al,%al
c0100aa6:	74 1d                	je     c0100ac5 <parse+0x42>
c0100aa8:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aab:	0f b6 00             	movzbl (%eax),%eax
c0100aae:	0f be c0             	movsbl %al,%eax
c0100ab1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ab5:	c7 04 24 50 63 10 c0 	movl   $0xc0106350,(%esp)
c0100abc:	e8 10 53 00 00       	call   c0105dd1 <strchr>
c0100ac1:	85 c0                	test   %eax,%eax
c0100ac3:	75 cd                	jne    c0100a92 <parse+0xf>
        }
        if (*buf == '\0') {
c0100ac5:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ac8:	0f b6 00             	movzbl (%eax),%eax
c0100acb:	84 c0                	test   %al,%al
c0100acd:	74 65                	je     c0100b34 <parse+0xb1>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100acf:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100ad3:	75 14                	jne    c0100ae9 <parse+0x66>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100ad5:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100adc:	00 
c0100add:	c7 04 24 55 63 10 c0 	movl   $0xc0106355,(%esp)
c0100ae4:	e8 6d f8 ff ff       	call   c0100356 <cprintf>
        }
        argv[argc ++] = buf;
c0100ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100aec:	8d 50 01             	lea    0x1(%eax),%edx
c0100aef:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100af2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100af9:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100afc:	01 c2                	add    %eax,%edx
c0100afe:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b01:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b03:	eb 03                	jmp    c0100b08 <parse+0x85>
            buf ++;
c0100b05:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b08:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b0b:	0f b6 00             	movzbl (%eax),%eax
c0100b0e:	84 c0                	test   %al,%al
c0100b10:	74 8c                	je     c0100a9e <parse+0x1b>
c0100b12:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b15:	0f b6 00             	movzbl (%eax),%eax
c0100b18:	0f be c0             	movsbl %al,%eax
c0100b1b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b1f:	c7 04 24 50 63 10 c0 	movl   $0xc0106350,(%esp)
c0100b26:	e8 a6 52 00 00       	call   c0105dd1 <strchr>
c0100b2b:	85 c0                	test   %eax,%eax
c0100b2d:	74 d6                	je     c0100b05 <parse+0x82>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b2f:	e9 6a ff ff ff       	jmp    c0100a9e <parse+0x1b>
            break;
c0100b34:	90                   	nop
        }
    }
    return argc;
c0100b35:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100b38:	89 ec                	mov    %ebp,%esp
c0100b3a:	5d                   	pop    %ebp
c0100b3b:	c3                   	ret    

c0100b3c <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100b3c:	55                   	push   %ebp
c0100b3d:	89 e5                	mov    %esp,%ebp
c0100b3f:	83 ec 68             	sub    $0x68,%esp
c0100b42:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100b45:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100b48:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b4c:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b4f:	89 04 24             	mov    %eax,(%esp)
c0100b52:	e8 2c ff ff ff       	call   c0100a83 <parse>
c0100b57:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100b5a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100b5e:	75 0a                	jne    c0100b6a <runcmd+0x2e>
        return 0;
c0100b60:	b8 00 00 00 00       	mov    $0x0,%eax
c0100b65:	e9 83 00 00 00       	jmp    c0100bed <runcmd+0xb1>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b6a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100b71:	eb 5a                	jmp    c0100bcd <runcmd+0x91>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100b73:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0100b76:	8b 4d f4             	mov    -0xc(%ebp),%ecx
c0100b79:	89 c8                	mov    %ecx,%eax
c0100b7b:	01 c0                	add    %eax,%eax
c0100b7d:	01 c8                	add    %ecx,%eax
c0100b7f:	c1 e0 02             	shl    $0x2,%eax
c0100b82:	05 00 90 11 c0       	add    $0xc0119000,%eax
c0100b87:	8b 00                	mov    (%eax),%eax
c0100b89:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100b8d:	89 04 24             	mov    %eax,(%esp)
c0100b90:	e8 a0 51 00 00       	call   c0105d35 <strcmp>
c0100b95:	85 c0                	test   %eax,%eax
c0100b97:	75 31                	jne    c0100bca <runcmd+0x8e>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100b99:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b9c:	89 d0                	mov    %edx,%eax
c0100b9e:	01 c0                	add    %eax,%eax
c0100ba0:	01 d0                	add    %edx,%eax
c0100ba2:	c1 e0 02             	shl    $0x2,%eax
c0100ba5:	05 08 90 11 c0       	add    $0xc0119008,%eax
c0100baa:	8b 10                	mov    (%eax),%edx
c0100bac:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100baf:	83 c0 04             	add    $0x4,%eax
c0100bb2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0100bb5:	8d 59 ff             	lea    -0x1(%ecx),%ebx
c0100bb8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c0100bbb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100bbf:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bc3:	89 1c 24             	mov    %ebx,(%esp)
c0100bc6:	ff d2                	call   *%edx
c0100bc8:	eb 23                	jmp    c0100bed <runcmd+0xb1>
    for (i = 0; i < NCOMMANDS; i ++) {
c0100bca:	ff 45 f4             	incl   -0xc(%ebp)
c0100bcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bd0:	83 f8 02             	cmp    $0x2,%eax
c0100bd3:	76 9e                	jbe    c0100b73 <runcmd+0x37>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100bd5:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100bd8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bdc:	c7 04 24 73 63 10 c0 	movl   $0xc0106373,(%esp)
c0100be3:	e8 6e f7 ff ff       	call   c0100356 <cprintf>
    return 0;
c0100be8:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100bed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0100bf0:	89 ec                	mov    %ebp,%esp
c0100bf2:	5d                   	pop    %ebp
c0100bf3:	c3                   	ret    

c0100bf4 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100bf4:	55                   	push   %ebp
c0100bf5:	89 e5                	mov    %esp,%ebp
c0100bf7:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100bfa:	c7 04 24 8c 63 10 c0 	movl   $0xc010638c,(%esp)
c0100c01:	e8 50 f7 ff ff       	call   c0100356 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100c06:	c7 04 24 b4 63 10 c0 	movl   $0xc01063b4,(%esp)
c0100c0d:	e8 44 f7 ff ff       	call   c0100356 <cprintf>

    if (tf != NULL) {
c0100c12:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100c16:	74 0b                	je     c0100c23 <kmonitor+0x2f>
        print_trapframe(tf);
c0100c18:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c1b:	89 04 24             	mov    %eax,(%esp)
c0100c1e:	e8 f2 0e 00 00       	call   c0101b15 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100c23:	c7 04 24 d9 63 10 c0 	movl   $0xc01063d9,(%esp)
c0100c2a:	e8 18 f6 ff ff       	call   c0100247 <readline>
c0100c2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100c32:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100c36:	74 eb                	je     c0100c23 <kmonitor+0x2f>
            if (runcmd(buf, tf) < 0) {
c0100c38:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c3b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c42:	89 04 24             	mov    %eax,(%esp)
c0100c45:	e8 f2 fe ff ff       	call   c0100b3c <runcmd>
c0100c4a:	85 c0                	test   %eax,%eax
c0100c4c:	78 02                	js     c0100c50 <kmonitor+0x5c>
        if ((buf = readline("K> ")) != NULL) {
c0100c4e:	eb d3                	jmp    c0100c23 <kmonitor+0x2f>
                break;
c0100c50:	90                   	nop
            }
        }
    }
}
c0100c51:	90                   	nop
c0100c52:	89 ec                	mov    %ebp,%esp
c0100c54:	5d                   	pop    %ebp
c0100c55:	c3                   	ret    

c0100c56 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100c56:	55                   	push   %ebp
c0100c57:	89 e5                	mov    %esp,%ebp
c0100c59:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c5c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c63:	eb 3d                	jmp    c0100ca2 <mon_help+0x4c>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100c65:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c68:	89 d0                	mov    %edx,%eax
c0100c6a:	01 c0                	add    %eax,%eax
c0100c6c:	01 d0                	add    %edx,%eax
c0100c6e:	c1 e0 02             	shl    $0x2,%eax
c0100c71:	05 04 90 11 c0       	add    $0xc0119004,%eax
c0100c76:	8b 10                	mov    (%eax),%edx
c0100c78:	8b 4d f4             	mov    -0xc(%ebp),%ecx
c0100c7b:	89 c8                	mov    %ecx,%eax
c0100c7d:	01 c0                	add    %eax,%eax
c0100c7f:	01 c8                	add    %ecx,%eax
c0100c81:	c1 e0 02             	shl    $0x2,%eax
c0100c84:	05 00 90 11 c0       	add    $0xc0119000,%eax
c0100c89:	8b 00                	mov    (%eax),%eax
c0100c8b:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100c8f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c93:	c7 04 24 dd 63 10 c0 	movl   $0xc01063dd,(%esp)
c0100c9a:	e8 b7 f6 ff ff       	call   c0100356 <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c9f:	ff 45 f4             	incl   -0xc(%ebp)
c0100ca2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ca5:	83 f8 02             	cmp    $0x2,%eax
c0100ca8:	76 bb                	jbe    c0100c65 <mon_help+0xf>
    }
    return 0;
c0100caa:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100caf:	89 ec                	mov    %ebp,%esp
c0100cb1:	5d                   	pop    %ebp
c0100cb2:	c3                   	ret    

c0100cb3 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100cb3:	55                   	push   %ebp
c0100cb4:	89 e5                	mov    %esp,%ebp
c0100cb6:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100cb9:	e8 bb fb ff ff       	call   c0100879 <print_kerninfo>
    return 0;
c0100cbe:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cc3:	89 ec                	mov    %ebp,%esp
c0100cc5:	5d                   	pop    %ebp
c0100cc6:	c3                   	ret    

c0100cc7 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100cc7:	55                   	push   %ebp
c0100cc8:	89 e5                	mov    %esp,%ebp
c0100cca:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100ccd:	e8 f3 fc ff ff       	call   c01009c5 <print_stackframe>
    return 0;
c0100cd2:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cd7:	89 ec                	mov    %ebp,%esp
c0100cd9:	5d                   	pop    %ebp
c0100cda:	c3                   	ret    

c0100cdb <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100cdb:	55                   	push   %ebp
c0100cdc:	89 e5                	mov    %esp,%ebp
c0100cde:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100ce1:	a1 20 c4 11 c0       	mov    0xc011c420,%eax
c0100ce6:	85 c0                	test   %eax,%eax
c0100ce8:	75 5b                	jne    c0100d45 <__panic+0x6a>
        goto panic_dead;
    }
    is_panic = 1;
c0100cea:	c7 05 20 c4 11 c0 01 	movl   $0x1,0xc011c420
c0100cf1:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100cf4:	8d 45 14             	lea    0x14(%ebp),%eax
c0100cf7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100cfa:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100cfd:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d01:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d04:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d08:	c7 04 24 e6 63 10 c0 	movl   $0xc01063e6,(%esp)
c0100d0f:	e8 42 f6 ff ff       	call   c0100356 <cprintf>
    vcprintf(fmt, ap);
c0100d14:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d17:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d1b:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d1e:	89 04 24             	mov    %eax,(%esp)
c0100d21:	e8 fb f5 ff ff       	call   c0100321 <vcprintf>
    cprintf("\n");
c0100d26:	c7 04 24 02 64 10 c0 	movl   $0xc0106402,(%esp)
c0100d2d:	e8 24 f6 ff ff       	call   c0100356 <cprintf>
    
    cprintf("stack trackback:\n");
c0100d32:	c7 04 24 04 64 10 c0 	movl   $0xc0106404,(%esp)
c0100d39:	e8 18 f6 ff ff       	call   c0100356 <cprintf>
    print_stackframe();
c0100d3e:	e8 82 fc ff ff       	call   c01009c5 <print_stackframe>
c0100d43:	eb 01                	jmp    c0100d46 <__panic+0x6b>
        goto panic_dead;
c0100d45:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
c0100d46:	e8 e9 09 00 00       	call   c0101734 <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100d4b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100d52:	e8 9d fe ff ff       	call   c0100bf4 <kmonitor>
c0100d57:	eb f2                	jmp    c0100d4b <__panic+0x70>

c0100d59 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100d59:	55                   	push   %ebp
c0100d5a:	89 e5                	mov    %esp,%ebp
c0100d5c:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100d5f:	8d 45 14             	lea    0x14(%ebp),%eax
c0100d62:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100d65:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d68:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d6c:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d6f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d73:	c7 04 24 16 64 10 c0 	movl   $0xc0106416,(%esp)
c0100d7a:	e8 d7 f5 ff ff       	call   c0100356 <cprintf>
    vcprintf(fmt, ap);
c0100d7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d82:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d86:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d89:	89 04 24             	mov    %eax,(%esp)
c0100d8c:	e8 90 f5 ff ff       	call   c0100321 <vcprintf>
    cprintf("\n");
c0100d91:	c7 04 24 02 64 10 c0 	movl   $0xc0106402,(%esp)
c0100d98:	e8 b9 f5 ff ff       	call   c0100356 <cprintf>
    va_end(ap);
}
c0100d9d:	90                   	nop
c0100d9e:	89 ec                	mov    %ebp,%esp
c0100da0:	5d                   	pop    %ebp
c0100da1:	c3                   	ret    

c0100da2 <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100da2:	55                   	push   %ebp
c0100da3:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100da5:	a1 20 c4 11 c0       	mov    0xc011c420,%eax
}
c0100daa:	5d                   	pop    %ebp
c0100dab:	c3                   	ret    

c0100dac <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100dac:	55                   	push   %ebp
c0100dad:	89 e5                	mov    %esp,%ebp
c0100daf:	83 ec 28             	sub    $0x28,%esp
c0100db2:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
c0100db8:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100dbc:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100dc0:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100dc4:	ee                   	out    %al,(%dx)
}
c0100dc5:	90                   	nop
c0100dc6:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100dcc:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100dd0:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100dd4:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100dd8:	ee                   	out    %al,(%dx)
}
c0100dd9:	90                   	nop
c0100dda:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
c0100de0:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100de4:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100de8:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100dec:	ee                   	out    %al,(%dx)
}
c0100ded:	90                   	nop
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100dee:	c7 05 24 c4 11 c0 00 	movl   $0x0,0xc011c424
c0100df5:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100df8:	c7 04 24 34 64 10 c0 	movl   $0xc0106434,(%esp)
c0100dff:	e8 52 f5 ff ff       	call   c0100356 <cprintf>
    pic_enable(IRQ_TIMER);
c0100e04:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100e0b:	e8 89 09 00 00       	call   c0101799 <pic_enable>
}
c0100e10:	90                   	nop
c0100e11:	89 ec                	mov    %ebp,%esp
c0100e13:	5d                   	pop    %ebp
c0100e14:	c3                   	ret    

c0100e15 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100e15:	55                   	push   %ebp
c0100e16:	89 e5                	mov    %esp,%ebp
c0100e18:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100e1b:	9c                   	pushf  
c0100e1c:	58                   	pop    %eax
c0100e1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100e20:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100e23:	25 00 02 00 00       	and    $0x200,%eax
c0100e28:	85 c0                	test   %eax,%eax
c0100e2a:	74 0c                	je     c0100e38 <__intr_save+0x23>
        intr_disable();
c0100e2c:	e8 03 09 00 00       	call   c0101734 <intr_disable>
        return 1;
c0100e31:	b8 01 00 00 00       	mov    $0x1,%eax
c0100e36:	eb 05                	jmp    c0100e3d <__intr_save+0x28>
    }
    return 0;
c0100e38:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e3d:	89 ec                	mov    %ebp,%esp
c0100e3f:	5d                   	pop    %ebp
c0100e40:	c3                   	ret    

c0100e41 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100e41:	55                   	push   %ebp
c0100e42:	89 e5                	mov    %esp,%ebp
c0100e44:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e47:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e4b:	74 05                	je     c0100e52 <__intr_restore+0x11>
        intr_enable();
c0100e4d:	e8 da 08 00 00       	call   c010172c <intr_enable>
    }
}
c0100e52:	90                   	nop
c0100e53:	89 ec                	mov    %ebp,%esp
c0100e55:	5d                   	pop    %ebp
c0100e56:	c3                   	ret    

c0100e57 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e57:	55                   	push   %ebp
c0100e58:	89 e5                	mov    %esp,%ebp
c0100e5a:	83 ec 10             	sub    $0x10,%esp
c0100e5d:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e63:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100e67:	89 c2                	mov    %eax,%edx
c0100e69:	ec                   	in     (%dx),%al
c0100e6a:	88 45 f1             	mov    %al,-0xf(%ebp)
c0100e6d:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100e73:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e77:	89 c2                	mov    %eax,%edx
c0100e79:	ec                   	in     (%dx),%al
c0100e7a:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100e7d:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100e83:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100e87:	89 c2                	mov    %eax,%edx
c0100e89:	ec                   	in     (%dx),%al
c0100e8a:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100e8d:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
c0100e93:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100e97:	89 c2                	mov    %eax,%edx
c0100e99:	ec                   	in     (%dx),%al
c0100e9a:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100e9d:	90                   	nop
c0100e9e:	89 ec                	mov    %ebp,%esp
c0100ea0:	5d                   	pop    %ebp
c0100ea1:	c3                   	ret    

c0100ea2 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100ea2:	55                   	push   %ebp
c0100ea3:	89 e5                	mov    %esp,%ebp
c0100ea5:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100ea8:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100eaf:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100eb2:	0f b7 00             	movzwl (%eax),%eax
c0100eb5:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100eb9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ebc:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100ec1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ec4:	0f b7 00             	movzwl (%eax),%eax
c0100ec7:	0f b7 c0             	movzwl %ax,%eax
c0100eca:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
c0100ecf:	74 12                	je     c0100ee3 <cga_init+0x41>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100ed1:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100ed8:	66 c7 05 46 c4 11 c0 	movw   $0x3b4,0xc011c446
c0100edf:	b4 03 
c0100ee1:	eb 13                	jmp    c0100ef6 <cga_init+0x54>
    } else {
        *cp = was;
c0100ee3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ee6:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100eea:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100eed:	66 c7 05 46 c4 11 c0 	movw   $0x3d4,0xc011c446
c0100ef4:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100ef6:	0f b7 05 46 c4 11 c0 	movzwl 0xc011c446,%eax
c0100efd:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c0100f01:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f05:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f09:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100f0d:	ee                   	out    %al,(%dx)
}
c0100f0e:	90                   	nop
    pos = inb(addr_6845 + 1) << 8;
c0100f0f:	0f b7 05 46 c4 11 c0 	movzwl 0xc011c446,%eax
c0100f16:	40                   	inc    %eax
c0100f17:	0f b7 c0             	movzwl %ax,%eax
c0100f1a:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f1e:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100f22:	89 c2                	mov    %eax,%edx
c0100f24:	ec                   	in     (%dx),%al
c0100f25:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
c0100f28:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f2c:	0f b6 c0             	movzbl %al,%eax
c0100f2f:	c1 e0 08             	shl    $0x8,%eax
c0100f32:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100f35:	0f b7 05 46 c4 11 c0 	movzwl 0xc011c446,%eax
c0100f3c:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0100f40:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f44:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f48:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100f4c:	ee                   	out    %al,(%dx)
}
c0100f4d:	90                   	nop
    pos |= inb(addr_6845 + 1);
c0100f4e:	0f b7 05 46 c4 11 c0 	movzwl 0xc011c446,%eax
c0100f55:	40                   	inc    %eax
c0100f56:	0f b7 c0             	movzwl %ax,%eax
c0100f59:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f5d:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100f61:	89 c2                	mov    %eax,%edx
c0100f63:	ec                   	in     (%dx),%al
c0100f64:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
c0100f67:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100f6b:	0f b6 c0             	movzbl %al,%eax
c0100f6e:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f71:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f74:	a3 40 c4 11 c0       	mov    %eax,0xc011c440
    crt_pos = pos;
c0100f79:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f7c:	0f b7 c0             	movzwl %ax,%eax
c0100f7f:	66 a3 44 c4 11 c0    	mov    %ax,0xc011c444
}
c0100f85:	90                   	nop
c0100f86:	89 ec                	mov    %ebp,%esp
c0100f88:	5d                   	pop    %ebp
c0100f89:	c3                   	ret    

c0100f8a <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f8a:	55                   	push   %ebp
c0100f8b:	89 e5                	mov    %esp,%ebp
c0100f8d:	83 ec 48             	sub    $0x48,%esp
c0100f90:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
c0100f96:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f9a:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0100f9e:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0100fa2:	ee                   	out    %al,(%dx)
}
c0100fa3:	90                   	nop
c0100fa4:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
c0100faa:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100fae:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0100fb2:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0100fb6:	ee                   	out    %al,(%dx)
}
c0100fb7:	90                   	nop
c0100fb8:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
c0100fbe:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100fc2:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0100fc6:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0100fca:	ee                   	out    %al,(%dx)
}
c0100fcb:	90                   	nop
c0100fcc:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100fd2:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100fd6:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100fda:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0100fde:	ee                   	out    %al,(%dx)
}
c0100fdf:	90                   	nop
c0100fe0:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
c0100fe6:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100fea:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100fee:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100ff2:	ee                   	out    %al,(%dx)
}
c0100ff3:	90                   	nop
c0100ff4:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
c0100ffa:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ffe:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101002:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101006:	ee                   	out    %al,(%dx)
}
c0101007:	90                   	nop
c0101008:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c010100e:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101012:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101016:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c010101a:	ee                   	out    %al,(%dx)
}
c010101b:	90                   	nop
c010101c:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101022:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0101026:	89 c2                	mov    %eax,%edx
c0101028:	ec                   	in     (%dx),%al
c0101029:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c010102c:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0101030:	3c ff                	cmp    $0xff,%al
c0101032:	0f 95 c0             	setne  %al
c0101035:	0f b6 c0             	movzbl %al,%eax
c0101038:	a3 48 c4 11 c0       	mov    %eax,0xc011c448
c010103d:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101043:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101047:	89 c2                	mov    %eax,%edx
c0101049:	ec                   	in     (%dx),%al
c010104a:	88 45 f1             	mov    %al,-0xf(%ebp)
c010104d:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101053:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101057:	89 c2                	mov    %eax,%edx
c0101059:	ec                   	in     (%dx),%al
c010105a:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c010105d:	a1 48 c4 11 c0       	mov    0xc011c448,%eax
c0101062:	85 c0                	test   %eax,%eax
c0101064:	74 0c                	je     c0101072 <serial_init+0xe8>
        pic_enable(IRQ_COM1);
c0101066:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c010106d:	e8 27 07 00 00       	call   c0101799 <pic_enable>
    }
}
c0101072:	90                   	nop
c0101073:	89 ec                	mov    %ebp,%esp
c0101075:	5d                   	pop    %ebp
c0101076:	c3                   	ret    

c0101077 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c0101077:	55                   	push   %ebp
c0101078:	89 e5                	mov    %esp,%ebp
c010107a:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c010107d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101084:	eb 08                	jmp    c010108e <lpt_putc_sub+0x17>
        delay();
c0101086:	e8 cc fd ff ff       	call   c0100e57 <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c010108b:	ff 45 fc             	incl   -0x4(%ebp)
c010108e:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c0101094:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101098:	89 c2                	mov    %eax,%edx
c010109a:	ec                   	in     (%dx),%al
c010109b:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c010109e:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01010a2:	84 c0                	test   %al,%al
c01010a4:	78 09                	js     c01010af <lpt_putc_sub+0x38>
c01010a6:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c01010ad:	7e d7                	jle    c0101086 <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
c01010af:	8b 45 08             	mov    0x8(%ebp),%eax
c01010b2:	0f b6 c0             	movzbl %al,%eax
c01010b5:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
c01010bb:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01010be:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01010c2:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01010c6:	ee                   	out    %al,(%dx)
}
c01010c7:	90                   	nop
c01010c8:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c01010ce:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01010d2:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01010d6:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01010da:	ee                   	out    %al,(%dx)
}
c01010db:	90                   	nop
c01010dc:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
c01010e2:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01010e6:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c01010ea:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c01010ee:	ee                   	out    %al,(%dx)
}
c01010ef:	90                   	nop
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c01010f0:	90                   	nop
c01010f1:	89 ec                	mov    %ebp,%esp
c01010f3:	5d                   	pop    %ebp
c01010f4:	c3                   	ret    

c01010f5 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c01010f5:	55                   	push   %ebp
c01010f6:	89 e5                	mov    %esp,%ebp
c01010f8:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c01010fb:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01010ff:	74 0d                	je     c010110e <lpt_putc+0x19>
        lpt_putc_sub(c);
c0101101:	8b 45 08             	mov    0x8(%ebp),%eax
c0101104:	89 04 24             	mov    %eax,(%esp)
c0101107:	e8 6b ff ff ff       	call   c0101077 <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
c010110c:	eb 24                	jmp    c0101132 <lpt_putc+0x3d>
        lpt_putc_sub('\b');
c010110e:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101115:	e8 5d ff ff ff       	call   c0101077 <lpt_putc_sub>
        lpt_putc_sub(' ');
c010111a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101121:	e8 51 ff ff ff       	call   c0101077 <lpt_putc_sub>
        lpt_putc_sub('\b');
c0101126:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010112d:	e8 45 ff ff ff       	call   c0101077 <lpt_putc_sub>
}
c0101132:	90                   	nop
c0101133:	89 ec                	mov    %ebp,%esp
c0101135:	5d                   	pop    %ebp
c0101136:	c3                   	ret    

c0101137 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c0101137:	55                   	push   %ebp
c0101138:	89 e5                	mov    %esp,%ebp
c010113a:	83 ec 38             	sub    $0x38,%esp
c010113d:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    // set black on white
    if (!(c & ~0xFF)) {
c0101140:	8b 45 08             	mov    0x8(%ebp),%eax
c0101143:	25 00 ff ff ff       	and    $0xffffff00,%eax
c0101148:	85 c0                	test   %eax,%eax
c010114a:	75 07                	jne    c0101153 <cga_putc+0x1c>
        c |= 0x0700;
c010114c:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c0101153:	8b 45 08             	mov    0x8(%ebp),%eax
c0101156:	0f b6 c0             	movzbl %al,%eax
c0101159:	83 f8 0d             	cmp    $0xd,%eax
c010115c:	74 72                	je     c01011d0 <cga_putc+0x99>
c010115e:	83 f8 0d             	cmp    $0xd,%eax
c0101161:	0f 8f a3 00 00 00    	jg     c010120a <cga_putc+0xd3>
c0101167:	83 f8 08             	cmp    $0x8,%eax
c010116a:	74 0a                	je     c0101176 <cga_putc+0x3f>
c010116c:	83 f8 0a             	cmp    $0xa,%eax
c010116f:	74 4c                	je     c01011bd <cga_putc+0x86>
c0101171:	e9 94 00 00 00       	jmp    c010120a <cga_putc+0xd3>
    case '\b':
        if (crt_pos > 0) {
c0101176:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c010117d:	85 c0                	test   %eax,%eax
c010117f:	0f 84 af 00 00 00    	je     c0101234 <cga_putc+0xfd>
            crt_pos --;
c0101185:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c010118c:	48                   	dec    %eax
c010118d:	0f b7 c0             	movzwl %ax,%eax
c0101190:	66 a3 44 c4 11 c0    	mov    %ax,0xc011c444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c0101196:	8b 45 08             	mov    0x8(%ebp),%eax
c0101199:	98                   	cwtl   
c010119a:	25 00 ff ff ff       	and    $0xffffff00,%eax
c010119f:	98                   	cwtl   
c01011a0:	83 c8 20             	or     $0x20,%eax
c01011a3:	98                   	cwtl   
c01011a4:	8b 0d 40 c4 11 c0    	mov    0xc011c440,%ecx
c01011aa:	0f b7 15 44 c4 11 c0 	movzwl 0xc011c444,%edx
c01011b1:	01 d2                	add    %edx,%edx
c01011b3:	01 ca                	add    %ecx,%edx
c01011b5:	0f b7 c0             	movzwl %ax,%eax
c01011b8:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c01011bb:	eb 77                	jmp    c0101234 <cga_putc+0xfd>
    case '\n':
        crt_pos += CRT_COLS;
c01011bd:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c01011c4:	83 c0 50             	add    $0x50,%eax
c01011c7:	0f b7 c0             	movzwl %ax,%eax
c01011ca:	66 a3 44 c4 11 c0    	mov    %ax,0xc011c444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c01011d0:	0f b7 1d 44 c4 11 c0 	movzwl 0xc011c444,%ebx
c01011d7:	0f b7 0d 44 c4 11 c0 	movzwl 0xc011c444,%ecx
c01011de:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
c01011e3:	89 c8                	mov    %ecx,%eax
c01011e5:	f7 e2                	mul    %edx
c01011e7:	c1 ea 06             	shr    $0x6,%edx
c01011ea:	89 d0                	mov    %edx,%eax
c01011ec:	c1 e0 02             	shl    $0x2,%eax
c01011ef:	01 d0                	add    %edx,%eax
c01011f1:	c1 e0 04             	shl    $0x4,%eax
c01011f4:	29 c1                	sub    %eax,%ecx
c01011f6:	89 ca                	mov    %ecx,%edx
c01011f8:	0f b7 d2             	movzwl %dx,%edx
c01011fb:	89 d8                	mov    %ebx,%eax
c01011fd:	29 d0                	sub    %edx,%eax
c01011ff:	0f b7 c0             	movzwl %ax,%eax
c0101202:	66 a3 44 c4 11 c0    	mov    %ax,0xc011c444
        break;
c0101208:	eb 2b                	jmp    c0101235 <cga_putc+0xfe>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c010120a:	8b 0d 40 c4 11 c0    	mov    0xc011c440,%ecx
c0101210:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c0101217:	8d 50 01             	lea    0x1(%eax),%edx
c010121a:	0f b7 d2             	movzwl %dx,%edx
c010121d:	66 89 15 44 c4 11 c0 	mov    %dx,0xc011c444
c0101224:	01 c0                	add    %eax,%eax
c0101226:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c0101229:	8b 45 08             	mov    0x8(%ebp),%eax
c010122c:	0f b7 c0             	movzwl %ax,%eax
c010122f:	66 89 02             	mov    %ax,(%edx)
        break;
c0101232:	eb 01                	jmp    c0101235 <cga_putc+0xfe>
        break;
c0101234:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c0101235:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c010123c:	3d cf 07 00 00       	cmp    $0x7cf,%eax
c0101241:	76 5e                	jbe    c01012a1 <cga_putc+0x16a>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c0101243:	a1 40 c4 11 c0       	mov    0xc011c440,%eax
c0101248:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c010124e:	a1 40 c4 11 c0       	mov    0xc011c440,%eax
c0101253:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c010125a:	00 
c010125b:	89 54 24 04          	mov    %edx,0x4(%esp)
c010125f:	89 04 24             	mov    %eax,(%esp)
c0101262:	e8 68 4d 00 00       	call   c0105fcf <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101267:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c010126e:	eb 15                	jmp    c0101285 <cga_putc+0x14e>
            crt_buf[i] = 0x0700 | ' ';
c0101270:	8b 15 40 c4 11 c0    	mov    0xc011c440,%edx
c0101276:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101279:	01 c0                	add    %eax,%eax
c010127b:	01 d0                	add    %edx,%eax
c010127d:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101282:	ff 45 f4             	incl   -0xc(%ebp)
c0101285:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c010128c:	7e e2                	jle    c0101270 <cga_putc+0x139>
        }
        crt_pos -= CRT_COLS;
c010128e:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c0101295:	83 e8 50             	sub    $0x50,%eax
c0101298:	0f b7 c0             	movzwl %ax,%eax
c010129b:	66 a3 44 c4 11 c0    	mov    %ax,0xc011c444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c01012a1:	0f b7 05 46 c4 11 c0 	movzwl 0xc011c446,%eax
c01012a8:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c01012ac:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01012b0:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01012b4:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01012b8:	ee                   	out    %al,(%dx)
}
c01012b9:	90                   	nop
    outb(addr_6845 + 1, crt_pos >> 8);
c01012ba:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c01012c1:	c1 e8 08             	shr    $0x8,%eax
c01012c4:	0f b7 c0             	movzwl %ax,%eax
c01012c7:	0f b6 c0             	movzbl %al,%eax
c01012ca:	0f b7 15 46 c4 11 c0 	movzwl 0xc011c446,%edx
c01012d1:	42                   	inc    %edx
c01012d2:	0f b7 d2             	movzwl %dx,%edx
c01012d5:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c01012d9:	88 45 e9             	mov    %al,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01012dc:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01012e0:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01012e4:	ee                   	out    %al,(%dx)
}
c01012e5:	90                   	nop
    outb(addr_6845, 15);
c01012e6:	0f b7 05 46 c4 11 c0 	movzwl 0xc011c446,%eax
c01012ed:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c01012f1:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01012f5:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01012f9:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01012fd:	ee                   	out    %al,(%dx)
}
c01012fe:	90                   	nop
    outb(addr_6845 + 1, crt_pos);
c01012ff:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c0101306:	0f b6 c0             	movzbl %al,%eax
c0101309:	0f b7 15 46 c4 11 c0 	movzwl 0xc011c446,%edx
c0101310:	42                   	inc    %edx
c0101311:	0f b7 d2             	movzwl %dx,%edx
c0101314:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
c0101318:	88 45 f1             	mov    %al,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010131b:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010131f:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101323:	ee                   	out    %al,(%dx)
}
c0101324:	90                   	nop
}
c0101325:	90                   	nop
c0101326:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0101329:	89 ec                	mov    %ebp,%esp
c010132b:	5d                   	pop    %ebp
c010132c:	c3                   	ret    

c010132d <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c010132d:	55                   	push   %ebp
c010132e:	89 e5                	mov    %esp,%ebp
c0101330:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c0101333:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010133a:	eb 08                	jmp    c0101344 <serial_putc_sub+0x17>
        delay();
c010133c:	e8 16 fb ff ff       	call   c0100e57 <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c0101341:	ff 45 fc             	incl   -0x4(%ebp)
c0101344:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010134a:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c010134e:	89 c2                	mov    %eax,%edx
c0101350:	ec                   	in     (%dx),%al
c0101351:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101354:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101358:	0f b6 c0             	movzbl %al,%eax
c010135b:	83 e0 20             	and    $0x20,%eax
c010135e:	85 c0                	test   %eax,%eax
c0101360:	75 09                	jne    c010136b <serial_putc_sub+0x3e>
c0101362:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101369:	7e d1                	jle    c010133c <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
c010136b:	8b 45 08             	mov    0x8(%ebp),%eax
c010136e:	0f b6 c0             	movzbl %al,%eax
c0101371:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101377:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010137a:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010137e:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101382:	ee                   	out    %al,(%dx)
}
c0101383:	90                   	nop
}
c0101384:	90                   	nop
c0101385:	89 ec                	mov    %ebp,%esp
c0101387:	5d                   	pop    %ebp
c0101388:	c3                   	ret    

c0101389 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c0101389:	55                   	push   %ebp
c010138a:	89 e5                	mov    %esp,%ebp
c010138c:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c010138f:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101393:	74 0d                	je     c01013a2 <serial_putc+0x19>
        serial_putc_sub(c);
c0101395:	8b 45 08             	mov    0x8(%ebp),%eax
c0101398:	89 04 24             	mov    %eax,(%esp)
c010139b:	e8 8d ff ff ff       	call   c010132d <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
c01013a0:	eb 24                	jmp    c01013c6 <serial_putc+0x3d>
        serial_putc_sub('\b');
c01013a2:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01013a9:	e8 7f ff ff ff       	call   c010132d <serial_putc_sub>
        serial_putc_sub(' ');
c01013ae:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01013b5:	e8 73 ff ff ff       	call   c010132d <serial_putc_sub>
        serial_putc_sub('\b');
c01013ba:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01013c1:	e8 67 ff ff ff       	call   c010132d <serial_putc_sub>
}
c01013c6:	90                   	nop
c01013c7:	89 ec                	mov    %ebp,%esp
c01013c9:	5d                   	pop    %ebp
c01013ca:	c3                   	ret    

c01013cb <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c01013cb:	55                   	push   %ebp
c01013cc:	89 e5                	mov    %esp,%ebp
c01013ce:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c01013d1:	eb 33                	jmp    c0101406 <cons_intr+0x3b>
        if (c != 0) {
c01013d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01013d7:	74 2d                	je     c0101406 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c01013d9:	a1 64 c6 11 c0       	mov    0xc011c664,%eax
c01013de:	8d 50 01             	lea    0x1(%eax),%edx
c01013e1:	89 15 64 c6 11 c0    	mov    %edx,0xc011c664
c01013e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01013ea:	88 90 60 c4 11 c0    	mov    %dl,-0x3fee3ba0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c01013f0:	a1 64 c6 11 c0       	mov    0xc011c664,%eax
c01013f5:	3d 00 02 00 00       	cmp    $0x200,%eax
c01013fa:	75 0a                	jne    c0101406 <cons_intr+0x3b>
                cons.wpos = 0;
c01013fc:	c7 05 64 c6 11 c0 00 	movl   $0x0,0xc011c664
c0101403:	00 00 00 
    while ((c = (*proc)()) != -1) {
c0101406:	8b 45 08             	mov    0x8(%ebp),%eax
c0101409:	ff d0                	call   *%eax
c010140b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010140e:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c0101412:	75 bf                	jne    c01013d3 <cons_intr+0x8>
            }
        }
    }
}
c0101414:	90                   	nop
c0101415:	90                   	nop
c0101416:	89 ec                	mov    %ebp,%esp
c0101418:	5d                   	pop    %ebp
c0101419:	c3                   	ret    

c010141a <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c010141a:	55                   	push   %ebp
c010141b:	89 e5                	mov    %esp,%ebp
c010141d:	83 ec 10             	sub    $0x10,%esp
c0101420:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101426:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c010142a:	89 c2                	mov    %eax,%edx
c010142c:	ec                   	in     (%dx),%al
c010142d:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101430:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c0101434:	0f b6 c0             	movzbl %al,%eax
c0101437:	83 e0 01             	and    $0x1,%eax
c010143a:	85 c0                	test   %eax,%eax
c010143c:	75 07                	jne    c0101445 <serial_proc_data+0x2b>
        return -1;
c010143e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101443:	eb 2a                	jmp    c010146f <serial_proc_data+0x55>
c0101445:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010144b:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010144f:	89 c2                	mov    %eax,%edx
c0101451:	ec                   	in     (%dx),%al
c0101452:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c0101455:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c0101459:	0f b6 c0             	movzbl %al,%eax
c010145c:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c010145f:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c0101463:	75 07                	jne    c010146c <serial_proc_data+0x52>
        c = '\b';
c0101465:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c010146c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010146f:	89 ec                	mov    %ebp,%esp
c0101471:	5d                   	pop    %ebp
c0101472:	c3                   	ret    

c0101473 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c0101473:	55                   	push   %ebp
c0101474:	89 e5                	mov    %esp,%ebp
c0101476:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c0101479:	a1 48 c4 11 c0       	mov    0xc011c448,%eax
c010147e:	85 c0                	test   %eax,%eax
c0101480:	74 0c                	je     c010148e <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c0101482:	c7 04 24 1a 14 10 c0 	movl   $0xc010141a,(%esp)
c0101489:	e8 3d ff ff ff       	call   c01013cb <cons_intr>
    }
}
c010148e:	90                   	nop
c010148f:	89 ec                	mov    %ebp,%esp
c0101491:	5d                   	pop    %ebp
c0101492:	c3                   	ret    

c0101493 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c0101493:	55                   	push   %ebp
c0101494:	89 e5                	mov    %esp,%ebp
c0101496:	83 ec 38             	sub    $0x38,%esp
c0101499:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010149f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01014a2:	89 c2                	mov    %eax,%edx
c01014a4:	ec                   	in     (%dx),%al
c01014a5:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c01014a8:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c01014ac:	0f b6 c0             	movzbl %al,%eax
c01014af:	83 e0 01             	and    $0x1,%eax
c01014b2:	85 c0                	test   %eax,%eax
c01014b4:	75 0a                	jne    c01014c0 <kbd_proc_data+0x2d>
        return -1;
c01014b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01014bb:	e9 56 01 00 00       	jmp    c0101616 <kbd_proc_data+0x183>
c01014c0:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01014c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01014c9:	89 c2                	mov    %eax,%edx
c01014cb:	ec                   	in     (%dx),%al
c01014cc:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c01014cf:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c01014d3:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c01014d6:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c01014da:	75 17                	jne    c01014f3 <kbd_proc_data+0x60>
        // E0 escape character
        shift |= E0ESC;
c01014dc:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c01014e1:	83 c8 40             	or     $0x40,%eax
c01014e4:	a3 68 c6 11 c0       	mov    %eax,0xc011c668
        return 0;
c01014e9:	b8 00 00 00 00       	mov    $0x0,%eax
c01014ee:	e9 23 01 00 00       	jmp    c0101616 <kbd_proc_data+0x183>
    } else if (data & 0x80) {
c01014f3:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014f7:	84 c0                	test   %al,%al
c01014f9:	79 45                	jns    c0101540 <kbd_proc_data+0xad>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c01014fb:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c0101500:	83 e0 40             	and    $0x40,%eax
c0101503:	85 c0                	test   %eax,%eax
c0101505:	75 08                	jne    c010150f <kbd_proc_data+0x7c>
c0101507:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010150b:	24 7f                	and    $0x7f,%al
c010150d:	eb 04                	jmp    c0101513 <kbd_proc_data+0x80>
c010150f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101513:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c0101516:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010151a:	0f b6 80 40 90 11 c0 	movzbl -0x3fee6fc0(%eax),%eax
c0101521:	0c 40                	or     $0x40,%al
c0101523:	0f b6 c0             	movzbl %al,%eax
c0101526:	f7 d0                	not    %eax
c0101528:	89 c2                	mov    %eax,%edx
c010152a:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c010152f:	21 d0                	and    %edx,%eax
c0101531:	a3 68 c6 11 c0       	mov    %eax,0xc011c668
        return 0;
c0101536:	b8 00 00 00 00       	mov    $0x0,%eax
c010153b:	e9 d6 00 00 00       	jmp    c0101616 <kbd_proc_data+0x183>
    } else if (shift & E0ESC) {
c0101540:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c0101545:	83 e0 40             	and    $0x40,%eax
c0101548:	85 c0                	test   %eax,%eax
c010154a:	74 11                	je     c010155d <kbd_proc_data+0xca>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c010154c:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c0101550:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c0101555:	83 e0 bf             	and    $0xffffffbf,%eax
c0101558:	a3 68 c6 11 c0       	mov    %eax,0xc011c668
    }

    shift |= shiftcode[data];
c010155d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101561:	0f b6 80 40 90 11 c0 	movzbl -0x3fee6fc0(%eax),%eax
c0101568:	0f b6 d0             	movzbl %al,%edx
c010156b:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c0101570:	09 d0                	or     %edx,%eax
c0101572:	a3 68 c6 11 c0       	mov    %eax,0xc011c668
    shift ^= togglecode[data];
c0101577:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010157b:	0f b6 80 40 91 11 c0 	movzbl -0x3fee6ec0(%eax),%eax
c0101582:	0f b6 d0             	movzbl %al,%edx
c0101585:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c010158a:	31 d0                	xor    %edx,%eax
c010158c:	a3 68 c6 11 c0       	mov    %eax,0xc011c668

    c = charcode[shift & (CTL | SHIFT)][data];
c0101591:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c0101596:	83 e0 03             	and    $0x3,%eax
c0101599:	8b 14 85 40 95 11 c0 	mov    -0x3fee6ac0(,%eax,4),%edx
c01015a0:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01015a4:	01 d0                	add    %edx,%eax
c01015a6:	0f b6 00             	movzbl (%eax),%eax
c01015a9:	0f b6 c0             	movzbl %al,%eax
c01015ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c01015af:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c01015b4:	83 e0 08             	and    $0x8,%eax
c01015b7:	85 c0                	test   %eax,%eax
c01015b9:	74 22                	je     c01015dd <kbd_proc_data+0x14a>
        if ('a' <= c && c <= 'z')
c01015bb:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c01015bf:	7e 0c                	jle    c01015cd <kbd_proc_data+0x13a>
c01015c1:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c01015c5:	7f 06                	jg     c01015cd <kbd_proc_data+0x13a>
            c += 'A' - 'a';
c01015c7:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c01015cb:	eb 10                	jmp    c01015dd <kbd_proc_data+0x14a>
        else if ('A' <= c && c <= 'Z')
c01015cd:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c01015d1:	7e 0a                	jle    c01015dd <kbd_proc_data+0x14a>
c01015d3:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c01015d7:	7f 04                	jg     c01015dd <kbd_proc_data+0x14a>
            c += 'a' - 'A';
c01015d9:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c01015dd:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c01015e2:	f7 d0                	not    %eax
c01015e4:	83 e0 06             	and    $0x6,%eax
c01015e7:	85 c0                	test   %eax,%eax
c01015e9:	75 28                	jne    c0101613 <kbd_proc_data+0x180>
c01015eb:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c01015f2:	75 1f                	jne    c0101613 <kbd_proc_data+0x180>
        cprintf("Rebooting!\n");
c01015f4:	c7 04 24 4f 64 10 c0 	movl   $0xc010644f,(%esp)
c01015fb:	e8 56 ed ff ff       	call   c0100356 <cprintf>
c0101600:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c0101606:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010160a:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c010160e:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0101611:	ee                   	out    %al,(%dx)
}
c0101612:	90                   	nop
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c0101613:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101616:	89 ec                	mov    %ebp,%esp
c0101618:	5d                   	pop    %ebp
c0101619:	c3                   	ret    

c010161a <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c010161a:	55                   	push   %ebp
c010161b:	89 e5                	mov    %esp,%ebp
c010161d:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c0101620:	c7 04 24 93 14 10 c0 	movl   $0xc0101493,(%esp)
c0101627:	e8 9f fd ff ff       	call   c01013cb <cons_intr>
}
c010162c:	90                   	nop
c010162d:	89 ec                	mov    %ebp,%esp
c010162f:	5d                   	pop    %ebp
c0101630:	c3                   	ret    

c0101631 <kbd_init>:

static void
kbd_init(void) {
c0101631:	55                   	push   %ebp
c0101632:	89 e5                	mov    %esp,%ebp
c0101634:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c0101637:	e8 de ff ff ff       	call   c010161a <kbd_intr>
    pic_enable(IRQ_KBD);
c010163c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0101643:	e8 51 01 00 00       	call   c0101799 <pic_enable>
}
c0101648:	90                   	nop
c0101649:	89 ec                	mov    %ebp,%esp
c010164b:	5d                   	pop    %ebp
c010164c:	c3                   	ret    

c010164d <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c010164d:	55                   	push   %ebp
c010164e:	89 e5                	mov    %esp,%ebp
c0101650:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c0101653:	e8 4a f8 ff ff       	call   c0100ea2 <cga_init>
    serial_init();
c0101658:	e8 2d f9 ff ff       	call   c0100f8a <serial_init>
    kbd_init();
c010165d:	e8 cf ff ff ff       	call   c0101631 <kbd_init>
    if (!serial_exists) {
c0101662:	a1 48 c4 11 c0       	mov    0xc011c448,%eax
c0101667:	85 c0                	test   %eax,%eax
c0101669:	75 0c                	jne    c0101677 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c010166b:	c7 04 24 5b 64 10 c0 	movl   $0xc010645b,(%esp)
c0101672:	e8 df ec ff ff       	call   c0100356 <cprintf>
    }
}
c0101677:	90                   	nop
c0101678:	89 ec                	mov    %ebp,%esp
c010167a:	5d                   	pop    %ebp
c010167b:	c3                   	ret    

c010167c <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c010167c:	55                   	push   %ebp
c010167d:	89 e5                	mov    %esp,%ebp
c010167f:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0101682:	e8 8e f7 ff ff       	call   c0100e15 <__intr_save>
c0101687:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c010168a:	8b 45 08             	mov    0x8(%ebp),%eax
c010168d:	89 04 24             	mov    %eax,(%esp)
c0101690:	e8 60 fa ff ff       	call   c01010f5 <lpt_putc>
        cga_putc(c);
c0101695:	8b 45 08             	mov    0x8(%ebp),%eax
c0101698:	89 04 24             	mov    %eax,(%esp)
c010169b:	e8 97 fa ff ff       	call   c0101137 <cga_putc>
        serial_putc(c);
c01016a0:	8b 45 08             	mov    0x8(%ebp),%eax
c01016a3:	89 04 24             	mov    %eax,(%esp)
c01016a6:	e8 de fc ff ff       	call   c0101389 <serial_putc>
    }
    local_intr_restore(intr_flag);
c01016ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01016ae:	89 04 24             	mov    %eax,(%esp)
c01016b1:	e8 8b f7 ff ff       	call   c0100e41 <__intr_restore>
}
c01016b6:	90                   	nop
c01016b7:	89 ec                	mov    %ebp,%esp
c01016b9:	5d                   	pop    %ebp
c01016ba:	c3                   	ret    

c01016bb <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c01016bb:	55                   	push   %ebp
c01016bc:	89 e5                	mov    %esp,%ebp
c01016be:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c01016c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c01016c8:	e8 48 f7 ff ff       	call   c0100e15 <__intr_save>
c01016cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c01016d0:	e8 9e fd ff ff       	call   c0101473 <serial_intr>
        kbd_intr();
c01016d5:	e8 40 ff ff ff       	call   c010161a <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c01016da:	8b 15 60 c6 11 c0    	mov    0xc011c660,%edx
c01016e0:	a1 64 c6 11 c0       	mov    0xc011c664,%eax
c01016e5:	39 c2                	cmp    %eax,%edx
c01016e7:	74 31                	je     c010171a <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c01016e9:	a1 60 c6 11 c0       	mov    0xc011c660,%eax
c01016ee:	8d 50 01             	lea    0x1(%eax),%edx
c01016f1:	89 15 60 c6 11 c0    	mov    %edx,0xc011c660
c01016f7:	0f b6 80 60 c4 11 c0 	movzbl -0x3fee3ba0(%eax),%eax
c01016fe:	0f b6 c0             	movzbl %al,%eax
c0101701:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c0101704:	a1 60 c6 11 c0       	mov    0xc011c660,%eax
c0101709:	3d 00 02 00 00       	cmp    $0x200,%eax
c010170e:	75 0a                	jne    c010171a <cons_getc+0x5f>
                cons.rpos = 0;
c0101710:	c7 05 60 c6 11 c0 00 	movl   $0x0,0xc011c660
c0101717:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c010171a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010171d:	89 04 24             	mov    %eax,(%esp)
c0101720:	e8 1c f7 ff ff       	call   c0100e41 <__intr_restore>
    return c;
c0101725:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101728:	89 ec                	mov    %ebp,%esp
c010172a:	5d                   	pop    %ebp
c010172b:	c3                   	ret    

c010172c <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c010172c:	55                   	push   %ebp
c010172d:	89 e5                	mov    %esp,%ebp
    asm volatile ("sti");
c010172f:	fb                   	sti    
}
c0101730:	90                   	nop
    sti();
}
c0101731:	90                   	nop
c0101732:	5d                   	pop    %ebp
c0101733:	c3                   	ret    

c0101734 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c0101734:	55                   	push   %ebp
c0101735:	89 e5                	mov    %esp,%ebp
    asm volatile ("cli" ::: "memory");
c0101737:	fa                   	cli    
}
c0101738:	90                   	nop
    cli();
}
c0101739:	90                   	nop
c010173a:	5d                   	pop    %ebp
c010173b:	c3                   	ret    

c010173c <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c010173c:	55                   	push   %ebp
c010173d:	89 e5                	mov    %esp,%ebp
c010173f:	83 ec 14             	sub    $0x14,%esp
c0101742:	8b 45 08             	mov    0x8(%ebp),%eax
c0101745:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c0101749:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010174c:	66 a3 50 95 11 c0    	mov    %ax,0xc0119550
    if (did_init) {
c0101752:	a1 6c c6 11 c0       	mov    0xc011c66c,%eax
c0101757:	85 c0                	test   %eax,%eax
c0101759:	74 39                	je     c0101794 <pic_setmask+0x58>
        outb(IO_PIC1 + 1, mask);
c010175b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010175e:	0f b6 c0             	movzbl %al,%eax
c0101761:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
c0101767:	88 45 f9             	mov    %al,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010176a:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010176e:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101772:	ee                   	out    %al,(%dx)
}
c0101773:	90                   	nop
        outb(IO_PIC2 + 1, mask >> 8);
c0101774:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101778:	c1 e8 08             	shr    $0x8,%eax
c010177b:	0f b7 c0             	movzwl %ax,%eax
c010177e:	0f b6 c0             	movzbl %al,%eax
c0101781:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
c0101787:	88 45 fd             	mov    %al,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010178a:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c010178e:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101792:	ee                   	out    %al,(%dx)
}
c0101793:	90                   	nop
    }
}
c0101794:	90                   	nop
c0101795:	89 ec                	mov    %ebp,%esp
c0101797:	5d                   	pop    %ebp
c0101798:	c3                   	ret    

c0101799 <pic_enable>:

void
pic_enable(unsigned int irq) {
c0101799:	55                   	push   %ebp
c010179a:	89 e5                	mov    %esp,%ebp
c010179c:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c010179f:	8b 45 08             	mov    0x8(%ebp),%eax
c01017a2:	ba 01 00 00 00       	mov    $0x1,%edx
c01017a7:	88 c1                	mov    %al,%cl
c01017a9:	d3 e2                	shl    %cl,%edx
c01017ab:	89 d0                	mov    %edx,%eax
c01017ad:	98                   	cwtl   
c01017ae:	f7 d0                	not    %eax
c01017b0:	0f bf d0             	movswl %ax,%edx
c01017b3:	0f b7 05 50 95 11 c0 	movzwl 0xc0119550,%eax
c01017ba:	98                   	cwtl   
c01017bb:	21 d0                	and    %edx,%eax
c01017bd:	98                   	cwtl   
c01017be:	0f b7 c0             	movzwl %ax,%eax
c01017c1:	89 04 24             	mov    %eax,(%esp)
c01017c4:	e8 73 ff ff ff       	call   c010173c <pic_setmask>
}
c01017c9:	90                   	nop
c01017ca:	89 ec                	mov    %ebp,%esp
c01017cc:	5d                   	pop    %ebp
c01017cd:	c3                   	ret    

c01017ce <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c01017ce:	55                   	push   %ebp
c01017cf:	89 e5                	mov    %esp,%ebp
c01017d1:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c01017d4:	c7 05 6c c6 11 c0 01 	movl   $0x1,0xc011c66c
c01017db:	00 00 00 
c01017de:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
c01017e4:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01017e8:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c01017ec:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c01017f0:	ee                   	out    %al,(%dx)
}
c01017f1:	90                   	nop
c01017f2:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
c01017f8:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01017fc:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c0101800:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c0101804:	ee                   	out    %al,(%dx)
}
c0101805:	90                   	nop
c0101806:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c010180c:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101810:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0101814:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0101818:	ee                   	out    %al,(%dx)
}
c0101819:	90                   	nop
c010181a:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
c0101820:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101824:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101828:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c010182c:	ee                   	out    %al,(%dx)
}
c010182d:	90                   	nop
c010182e:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
c0101834:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101838:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c010183c:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101840:	ee                   	out    %al,(%dx)
}
c0101841:	90                   	nop
c0101842:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
c0101848:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010184c:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101850:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101854:	ee                   	out    %al,(%dx)
}
c0101855:	90                   	nop
c0101856:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
c010185c:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101860:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101864:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101868:	ee                   	out    %al,(%dx)
}
c0101869:	90                   	nop
c010186a:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
c0101870:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101874:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101878:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c010187c:	ee                   	out    %al,(%dx)
}
c010187d:	90                   	nop
c010187e:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
c0101884:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101888:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c010188c:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101890:	ee                   	out    %al,(%dx)
}
c0101891:	90                   	nop
c0101892:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
c0101898:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010189c:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01018a0:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01018a4:	ee                   	out    %al,(%dx)
}
c01018a5:	90                   	nop
c01018a6:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
c01018ac:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018b0:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01018b4:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01018b8:	ee                   	out    %al,(%dx)
}
c01018b9:	90                   	nop
c01018ba:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c01018c0:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018c4:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c01018c8:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c01018cc:	ee                   	out    %al,(%dx)
}
c01018cd:	90                   	nop
c01018ce:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
c01018d4:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018d8:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01018dc:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c01018e0:	ee                   	out    %al,(%dx)
}
c01018e1:	90                   	nop
c01018e2:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
c01018e8:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018ec:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c01018f0:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c01018f4:	ee                   	out    %al,(%dx)
}
c01018f5:	90                   	nop
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c01018f6:	0f b7 05 50 95 11 c0 	movzwl 0xc0119550,%eax
c01018fd:	3d ff ff 00 00       	cmp    $0xffff,%eax
c0101902:	74 0f                	je     c0101913 <pic_init+0x145>
        pic_setmask(irq_mask);
c0101904:	0f b7 05 50 95 11 c0 	movzwl 0xc0119550,%eax
c010190b:	89 04 24             	mov    %eax,(%esp)
c010190e:	e8 29 fe ff ff       	call   c010173c <pic_setmask>
    }
}
c0101913:	90                   	nop
c0101914:	89 ec                	mov    %ebp,%esp
c0101916:	5d                   	pop    %ebp
c0101917:	c3                   	ret    

c0101918 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c0101918:	55                   	push   %ebp
c0101919:	89 e5                	mov    %esp,%ebp
c010191b:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c010191e:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c0101925:	00 
c0101926:	c7 04 24 80 64 10 c0 	movl   $0xc0106480,(%esp)
c010192d:	e8 24 ea ff ff       	call   c0100356 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
c0101932:	c7 04 24 8a 64 10 c0 	movl   $0xc010648a,(%esp)
c0101939:	e8 18 ea ff ff       	call   c0100356 <cprintf>
    panic("EOT: kernel seems ok.");
c010193e:	c7 44 24 08 98 64 10 	movl   $0xc0106498,0x8(%esp)
c0101945:	c0 
c0101946:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
c010194d:	00 
c010194e:	c7 04 24 ae 64 10 c0 	movl   $0xc01064ae,(%esp)
c0101955:	e8 81 f3 ff ff       	call   c0100cdb <__panic>

c010195a <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c010195a:	55                   	push   %ebp
c010195b:	89 e5                	mov    %esp,%ebp
c010195d:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
     extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) 
c0101960:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101967:	e9 c4 00 00 00       	jmp    c0101a30 <idt_init+0xd6>
    {
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c010196c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010196f:	8b 04 85 e0 95 11 c0 	mov    -0x3fee6a20(,%eax,4),%eax
c0101976:	0f b7 d0             	movzwl %ax,%edx
c0101979:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010197c:	66 89 14 c5 80 c6 11 	mov    %dx,-0x3fee3980(,%eax,8)
c0101983:	c0 
c0101984:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101987:	66 c7 04 c5 82 c6 11 	movw   $0x8,-0x3fee397e(,%eax,8)
c010198e:	c0 08 00 
c0101991:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101994:	0f b6 14 c5 84 c6 11 	movzbl -0x3fee397c(,%eax,8),%edx
c010199b:	c0 
c010199c:	80 e2 e0             	and    $0xe0,%dl
c010199f:	88 14 c5 84 c6 11 c0 	mov    %dl,-0x3fee397c(,%eax,8)
c01019a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019a9:	0f b6 14 c5 84 c6 11 	movzbl -0x3fee397c(,%eax,8),%edx
c01019b0:	c0 
c01019b1:	80 e2 1f             	and    $0x1f,%dl
c01019b4:	88 14 c5 84 c6 11 c0 	mov    %dl,-0x3fee397c(,%eax,8)
c01019bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019be:	0f b6 14 c5 85 c6 11 	movzbl -0x3fee397b(,%eax,8),%edx
c01019c5:	c0 
c01019c6:	80 e2 f0             	and    $0xf0,%dl
c01019c9:	80 ca 0e             	or     $0xe,%dl
c01019cc:	88 14 c5 85 c6 11 c0 	mov    %dl,-0x3fee397b(,%eax,8)
c01019d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019d6:	0f b6 14 c5 85 c6 11 	movzbl -0x3fee397b(,%eax,8),%edx
c01019dd:	c0 
c01019de:	80 e2 ef             	and    $0xef,%dl
c01019e1:	88 14 c5 85 c6 11 c0 	mov    %dl,-0x3fee397b(,%eax,8)
c01019e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019eb:	0f b6 14 c5 85 c6 11 	movzbl -0x3fee397b(,%eax,8),%edx
c01019f2:	c0 
c01019f3:	80 e2 9f             	and    $0x9f,%dl
c01019f6:	88 14 c5 85 c6 11 c0 	mov    %dl,-0x3fee397b(,%eax,8)
c01019fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a00:	0f b6 14 c5 85 c6 11 	movzbl -0x3fee397b(,%eax,8),%edx
c0101a07:	c0 
c0101a08:	80 ca 80             	or     $0x80,%dl
c0101a0b:	88 14 c5 85 c6 11 c0 	mov    %dl,-0x3fee397b(,%eax,8)
c0101a12:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a15:	8b 04 85 e0 95 11 c0 	mov    -0x3fee6a20(,%eax,4),%eax
c0101a1c:	c1 e8 10             	shr    $0x10,%eax
c0101a1f:	0f b7 d0             	movzwl %ax,%edx
c0101a22:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a25:	66 89 14 c5 86 c6 11 	mov    %dx,-0x3fee397a(,%eax,8)
c0101a2c:	c0 
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) 
c0101a2d:	ff 45 fc             	incl   -0x4(%ebp)
c0101a30:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a33:	3d ff 00 00 00       	cmp    $0xff,%eax
c0101a38:	0f 86 2e ff ff ff    	jbe    c010196c <idt_init+0x12>
    }
    // set for switch from user to kernel
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
c0101a3e:	a1 c4 97 11 c0       	mov    0xc01197c4,%eax
c0101a43:	0f b7 c0             	movzwl %ax,%eax
c0101a46:	66 a3 48 ca 11 c0    	mov    %ax,0xc011ca48
c0101a4c:	66 c7 05 4a ca 11 c0 	movw   $0x8,0xc011ca4a
c0101a53:	08 00 
c0101a55:	0f b6 05 4c ca 11 c0 	movzbl 0xc011ca4c,%eax
c0101a5c:	24 e0                	and    $0xe0,%al
c0101a5e:	a2 4c ca 11 c0       	mov    %al,0xc011ca4c
c0101a63:	0f b6 05 4c ca 11 c0 	movzbl 0xc011ca4c,%eax
c0101a6a:	24 1f                	and    $0x1f,%al
c0101a6c:	a2 4c ca 11 c0       	mov    %al,0xc011ca4c
c0101a71:	0f b6 05 4d ca 11 c0 	movzbl 0xc011ca4d,%eax
c0101a78:	24 f0                	and    $0xf0,%al
c0101a7a:	0c 0e                	or     $0xe,%al
c0101a7c:	a2 4d ca 11 c0       	mov    %al,0xc011ca4d
c0101a81:	0f b6 05 4d ca 11 c0 	movzbl 0xc011ca4d,%eax
c0101a88:	24 ef                	and    $0xef,%al
c0101a8a:	a2 4d ca 11 c0       	mov    %al,0xc011ca4d
c0101a8f:	0f b6 05 4d ca 11 c0 	movzbl 0xc011ca4d,%eax
c0101a96:	0c 60                	or     $0x60,%al
c0101a98:	a2 4d ca 11 c0       	mov    %al,0xc011ca4d
c0101a9d:	0f b6 05 4d ca 11 c0 	movzbl 0xc011ca4d,%eax
c0101aa4:	0c 80                	or     $0x80,%al
c0101aa6:	a2 4d ca 11 c0       	mov    %al,0xc011ca4d
c0101aab:	a1 c4 97 11 c0       	mov    0xc01197c4,%eax
c0101ab0:	c1 e8 10             	shr    $0x10,%eax
c0101ab3:	0f b7 c0             	movzwl %ax,%eax
c0101ab6:	66 a3 4e ca 11 c0    	mov    %ax,0xc011ca4e
c0101abc:	c7 45 f8 60 95 11 c0 	movl   $0xc0119560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c0101ac3:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101ac6:	0f 01 18             	lidtl  (%eax)
}
c0101ac9:	90                   	nop
    // load the IDT
    lidt(&idt_pd);
}
c0101aca:	90                   	nop
c0101acb:	89 ec                	mov    %ebp,%esp
c0101acd:	5d                   	pop    %ebp
c0101ace:	c3                   	ret    

c0101acf <trapname>:

static const char *
trapname(int trapno) {
c0101acf:	55                   	push   %ebp
c0101ad0:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0101ad2:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ad5:	83 f8 13             	cmp    $0x13,%eax
c0101ad8:	77 0c                	ja     c0101ae6 <trapname+0x17>
        return excnames[trapno];
c0101ada:	8b 45 08             	mov    0x8(%ebp),%eax
c0101add:	8b 04 85 00 68 10 c0 	mov    -0x3fef9800(,%eax,4),%eax
c0101ae4:	eb 18                	jmp    c0101afe <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0101ae6:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0101aea:	7e 0d                	jle    c0101af9 <trapname+0x2a>
c0101aec:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0101af0:	7f 07                	jg     c0101af9 <trapname+0x2a>
        return "Hardware Interrupt";
c0101af2:	b8 bf 64 10 c0       	mov    $0xc01064bf,%eax
c0101af7:	eb 05                	jmp    c0101afe <trapname+0x2f>
    }
    return "(unknown trap)";
c0101af9:	b8 d2 64 10 c0       	mov    $0xc01064d2,%eax
}
c0101afe:	5d                   	pop    %ebp
c0101aff:	c3                   	ret    

c0101b00 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0101b00:	55                   	push   %ebp
c0101b01:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0101b03:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b06:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101b0a:	83 f8 08             	cmp    $0x8,%eax
c0101b0d:	0f 94 c0             	sete   %al
c0101b10:	0f b6 c0             	movzbl %al,%eax
}
c0101b13:	5d                   	pop    %ebp
c0101b14:	c3                   	ret    

c0101b15 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0101b15:	55                   	push   %ebp
c0101b16:	89 e5                	mov    %esp,%ebp
c0101b18:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c0101b1b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b1e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b22:	c7 04 24 13 65 10 c0 	movl   $0xc0106513,(%esp)
c0101b29:	e8 28 e8 ff ff       	call   c0100356 <cprintf>
    print_regs(&tf->tf_regs);
c0101b2e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b31:	89 04 24             	mov    %eax,(%esp)
c0101b34:	e8 8f 01 00 00       	call   c0101cc8 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101b39:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b3c:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101b40:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b44:	c7 04 24 24 65 10 c0 	movl   $0xc0106524,(%esp)
c0101b4b:	e8 06 e8 ff ff       	call   c0100356 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101b50:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b53:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101b57:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b5b:	c7 04 24 37 65 10 c0 	movl   $0xc0106537,(%esp)
c0101b62:	e8 ef e7 ff ff       	call   c0100356 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101b67:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b6a:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101b6e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b72:	c7 04 24 4a 65 10 c0 	movl   $0xc010654a,(%esp)
c0101b79:	e8 d8 e7 ff ff       	call   c0100356 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101b7e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b81:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101b85:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b89:	c7 04 24 5d 65 10 c0 	movl   $0xc010655d,(%esp)
c0101b90:	e8 c1 e7 ff ff       	call   c0100356 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101b95:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b98:	8b 40 30             	mov    0x30(%eax),%eax
c0101b9b:	89 04 24             	mov    %eax,(%esp)
c0101b9e:	e8 2c ff ff ff       	call   c0101acf <trapname>
c0101ba3:	8b 55 08             	mov    0x8(%ebp),%edx
c0101ba6:	8b 52 30             	mov    0x30(%edx),%edx
c0101ba9:	89 44 24 08          	mov    %eax,0x8(%esp)
c0101bad:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101bb1:	c7 04 24 70 65 10 c0 	movl   $0xc0106570,(%esp)
c0101bb8:	e8 99 e7 ff ff       	call   c0100356 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101bbd:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bc0:	8b 40 34             	mov    0x34(%eax),%eax
c0101bc3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bc7:	c7 04 24 82 65 10 c0 	movl   $0xc0106582,(%esp)
c0101bce:	e8 83 e7 ff ff       	call   c0100356 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101bd3:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bd6:	8b 40 38             	mov    0x38(%eax),%eax
c0101bd9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bdd:	c7 04 24 91 65 10 c0 	movl   $0xc0106591,(%esp)
c0101be4:	e8 6d e7 ff ff       	call   c0100356 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101be9:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bec:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101bf0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bf4:	c7 04 24 a0 65 10 c0 	movl   $0xc01065a0,(%esp)
c0101bfb:	e8 56 e7 ff ff       	call   c0100356 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101c00:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c03:	8b 40 40             	mov    0x40(%eax),%eax
c0101c06:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c0a:	c7 04 24 b3 65 10 c0 	movl   $0xc01065b3,(%esp)
c0101c11:	e8 40 e7 ff ff       	call   c0100356 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101c16:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101c1d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101c24:	eb 3d                	jmp    c0101c63 <print_trapframe+0x14e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101c26:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c29:	8b 50 40             	mov    0x40(%eax),%edx
c0101c2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101c2f:	21 d0                	and    %edx,%eax
c0101c31:	85 c0                	test   %eax,%eax
c0101c33:	74 28                	je     c0101c5d <print_trapframe+0x148>
c0101c35:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c38:	8b 04 85 80 95 11 c0 	mov    -0x3fee6a80(,%eax,4),%eax
c0101c3f:	85 c0                	test   %eax,%eax
c0101c41:	74 1a                	je     c0101c5d <print_trapframe+0x148>
            cprintf("%s,", IA32flags[i]);
c0101c43:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c46:	8b 04 85 80 95 11 c0 	mov    -0x3fee6a80(,%eax,4),%eax
c0101c4d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c51:	c7 04 24 c2 65 10 c0 	movl   $0xc01065c2,(%esp)
c0101c58:	e8 f9 e6 ff ff       	call   c0100356 <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101c5d:	ff 45 f4             	incl   -0xc(%ebp)
c0101c60:	d1 65 f0             	shll   -0x10(%ebp)
c0101c63:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c66:	83 f8 17             	cmp    $0x17,%eax
c0101c69:	76 bb                	jbe    c0101c26 <print_trapframe+0x111>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101c6b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c6e:	8b 40 40             	mov    0x40(%eax),%eax
c0101c71:	c1 e8 0c             	shr    $0xc,%eax
c0101c74:	83 e0 03             	and    $0x3,%eax
c0101c77:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c7b:	c7 04 24 c6 65 10 c0 	movl   $0xc01065c6,(%esp)
c0101c82:	e8 cf e6 ff ff       	call   c0100356 <cprintf>

    if (!trap_in_kernel(tf)) {
c0101c87:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c8a:	89 04 24             	mov    %eax,(%esp)
c0101c8d:	e8 6e fe ff ff       	call   c0101b00 <trap_in_kernel>
c0101c92:	85 c0                	test   %eax,%eax
c0101c94:	75 2d                	jne    c0101cc3 <print_trapframe+0x1ae>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101c96:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c99:	8b 40 44             	mov    0x44(%eax),%eax
c0101c9c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ca0:	c7 04 24 cf 65 10 c0 	movl   $0xc01065cf,(%esp)
c0101ca7:	e8 aa e6 ff ff       	call   c0100356 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101cac:	8b 45 08             	mov    0x8(%ebp),%eax
c0101caf:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101cb3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cb7:	c7 04 24 de 65 10 c0 	movl   $0xc01065de,(%esp)
c0101cbe:	e8 93 e6 ff ff       	call   c0100356 <cprintf>
    }
}
c0101cc3:	90                   	nop
c0101cc4:	89 ec                	mov    %ebp,%esp
c0101cc6:	5d                   	pop    %ebp
c0101cc7:	c3                   	ret    

c0101cc8 <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101cc8:	55                   	push   %ebp
c0101cc9:	89 e5                	mov    %esp,%ebp
c0101ccb:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101cce:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cd1:	8b 00                	mov    (%eax),%eax
c0101cd3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cd7:	c7 04 24 f1 65 10 c0 	movl   $0xc01065f1,(%esp)
c0101cde:	e8 73 e6 ff ff       	call   c0100356 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101ce3:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ce6:	8b 40 04             	mov    0x4(%eax),%eax
c0101ce9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ced:	c7 04 24 00 66 10 c0 	movl   $0xc0106600,(%esp)
c0101cf4:	e8 5d e6 ff ff       	call   c0100356 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101cf9:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cfc:	8b 40 08             	mov    0x8(%eax),%eax
c0101cff:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d03:	c7 04 24 0f 66 10 c0 	movl   $0xc010660f,(%esp)
c0101d0a:	e8 47 e6 ff ff       	call   c0100356 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101d0f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d12:	8b 40 0c             	mov    0xc(%eax),%eax
c0101d15:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d19:	c7 04 24 1e 66 10 c0 	movl   $0xc010661e,(%esp)
c0101d20:	e8 31 e6 ff ff       	call   c0100356 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101d25:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d28:	8b 40 10             	mov    0x10(%eax),%eax
c0101d2b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d2f:	c7 04 24 2d 66 10 c0 	movl   $0xc010662d,(%esp)
c0101d36:	e8 1b e6 ff ff       	call   c0100356 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101d3b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d3e:	8b 40 14             	mov    0x14(%eax),%eax
c0101d41:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d45:	c7 04 24 3c 66 10 c0 	movl   $0xc010663c,(%esp)
c0101d4c:	e8 05 e6 ff ff       	call   c0100356 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101d51:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d54:	8b 40 18             	mov    0x18(%eax),%eax
c0101d57:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d5b:	c7 04 24 4b 66 10 c0 	movl   $0xc010664b,(%esp)
c0101d62:	e8 ef e5 ff ff       	call   c0100356 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101d67:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d6a:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101d6d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d71:	c7 04 24 5a 66 10 c0 	movl   $0xc010665a,(%esp)
c0101d78:	e8 d9 e5 ff ff       	call   c0100356 <cprintf>
}
c0101d7d:	90                   	nop
c0101d7e:	89 ec                	mov    %ebp,%esp
c0101d80:	5d                   	pop    %ebp
c0101d81:	c3                   	ret    

c0101d82 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101d82:	55                   	push   %ebp
c0101d83:	89 e5                	mov    %esp,%ebp
c0101d85:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
c0101d88:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d8b:	8b 40 30             	mov    0x30(%eax),%eax
c0101d8e:	83 f8 79             	cmp    $0x79,%eax
c0101d91:	0f 87 e6 00 00 00    	ja     c0101e7d <trap_dispatch+0xfb>
c0101d97:	83 f8 78             	cmp    $0x78,%eax
c0101d9a:	0f 83 c1 00 00 00    	jae    c0101e61 <trap_dispatch+0xdf>
c0101da0:	83 f8 2f             	cmp    $0x2f,%eax
c0101da3:	0f 87 d4 00 00 00    	ja     c0101e7d <trap_dispatch+0xfb>
c0101da9:	83 f8 2e             	cmp    $0x2e,%eax
c0101dac:	0f 83 00 01 00 00    	jae    c0101eb2 <trap_dispatch+0x130>
c0101db2:	83 f8 24             	cmp    $0x24,%eax
c0101db5:	74 5e                	je     c0101e15 <trap_dispatch+0x93>
c0101db7:	83 f8 24             	cmp    $0x24,%eax
c0101dba:	0f 87 bd 00 00 00    	ja     c0101e7d <trap_dispatch+0xfb>
c0101dc0:	83 f8 20             	cmp    $0x20,%eax
c0101dc3:	74 0a                	je     c0101dcf <trap_dispatch+0x4d>
c0101dc5:	83 f8 21             	cmp    $0x21,%eax
c0101dc8:	74 71                	je     c0101e3b <trap_dispatch+0xb9>
c0101dca:	e9 ae 00 00 00       	jmp    c0101e7d <trap_dispatch+0xfb>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
c0101dcf:	a1 24 c4 11 c0       	mov    0xc011c424,%eax
c0101dd4:	40                   	inc    %eax
c0101dd5:	a3 24 c4 11 c0       	mov    %eax,0xc011c424
        if (ticks % TICK_NUM == 0) {
c0101dda:	8b 0d 24 c4 11 c0    	mov    0xc011c424,%ecx
c0101de0:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c0101de5:	89 c8                	mov    %ecx,%eax
c0101de7:	f7 e2                	mul    %edx
c0101de9:	c1 ea 05             	shr    $0x5,%edx
c0101dec:	89 d0                	mov    %edx,%eax
c0101dee:	c1 e0 02             	shl    $0x2,%eax
c0101df1:	01 d0                	add    %edx,%eax
c0101df3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0101dfa:	01 d0                	add    %edx,%eax
c0101dfc:	c1 e0 02             	shl    $0x2,%eax
c0101dff:	29 c1                	sub    %eax,%ecx
c0101e01:	89 ca                	mov    %ecx,%edx
c0101e03:	85 d2                	test   %edx,%edx
c0101e05:	0f 85 aa 00 00 00    	jne    c0101eb5 <trap_dispatch+0x133>
            print_ticks();
c0101e0b:	e8 08 fb ff ff       	call   c0101918 <print_ticks>
        }
        break;
c0101e10:	e9 a0 00 00 00       	jmp    c0101eb5 <trap_dispatch+0x133>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101e15:	e8 a1 f8 ff ff       	call   c01016bb <cons_getc>
c0101e1a:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101e1d:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101e21:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101e25:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101e29:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101e2d:	c7 04 24 69 66 10 c0 	movl   $0xc0106669,(%esp)
c0101e34:	e8 1d e5 ff ff       	call   c0100356 <cprintf>
        break;
c0101e39:	eb 7b                	jmp    c0101eb6 <trap_dispatch+0x134>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101e3b:	e8 7b f8 ff ff       	call   c01016bb <cons_getc>
c0101e40:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101e43:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101e47:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101e4b:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101e4f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101e53:	c7 04 24 7b 66 10 c0 	movl   $0xc010667b,(%esp)
c0101e5a:	e8 f7 e4 ff ff       	call   c0100356 <cprintf>
        break;
c0101e5f:	eb 55                	jmp    c0101eb6 <trap_dispatch+0x134>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c0101e61:	c7 44 24 08 8a 66 10 	movl   $0xc010668a,0x8(%esp)
c0101e68:	c0 
c0101e69:	c7 44 24 04 b0 00 00 	movl   $0xb0,0x4(%esp)
c0101e70:	00 
c0101e71:	c7 04 24 ae 64 10 c0 	movl   $0xc01064ae,(%esp)
c0101e78:	e8 5e ee ff ff       	call   c0100cdb <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0101e7d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e80:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101e84:	83 e0 03             	and    $0x3,%eax
c0101e87:	85 c0                	test   %eax,%eax
c0101e89:	75 2b                	jne    c0101eb6 <trap_dispatch+0x134>
            print_trapframe(tf);
c0101e8b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e8e:	89 04 24             	mov    %eax,(%esp)
c0101e91:	e8 7f fc ff ff       	call   c0101b15 <print_trapframe>
            panic("unexpected trap in kernel.\n");
c0101e96:	c7 44 24 08 9a 66 10 	movl   $0xc010669a,0x8(%esp)
c0101e9d:	c0 
c0101e9e:	c7 44 24 04 ba 00 00 	movl   $0xba,0x4(%esp)
c0101ea5:	00 
c0101ea6:	c7 04 24 ae 64 10 c0 	movl   $0xc01064ae,(%esp)
c0101ead:	e8 29 ee ff ff       	call   c0100cdb <__panic>
        break;
c0101eb2:	90                   	nop
c0101eb3:	eb 01                	jmp    c0101eb6 <trap_dispatch+0x134>
        break;
c0101eb5:	90                   	nop
        }
    }
}
c0101eb6:	90                   	nop
c0101eb7:	89 ec                	mov    %ebp,%esp
c0101eb9:	5d                   	pop    %ebp
c0101eba:	c3                   	ret    

c0101ebb <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0101ebb:	55                   	push   %ebp
c0101ebc:	89 e5                	mov    %esp,%ebp
c0101ebe:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0101ec1:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ec4:	89 04 24             	mov    %eax,(%esp)
c0101ec7:	e8 b6 fe ff ff       	call   c0101d82 <trap_dispatch>
}
c0101ecc:	90                   	nop
c0101ecd:	89 ec                	mov    %ebp,%esp
c0101ecf:	5d                   	pop    %ebp
c0101ed0:	c3                   	ret    

c0101ed1 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0101ed1:	1e                   	push   %ds
    pushl %es
c0101ed2:	06                   	push   %es
    pushl %fs
c0101ed3:	0f a0                	push   %fs
    pushl %gs
c0101ed5:	0f a8                	push   %gs
    pushal
c0101ed7:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0101ed8:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0101edd:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0101edf:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0101ee1:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0101ee2:	e8 d4 ff ff ff       	call   c0101ebb <trap>

    # pop the pushed stack pointer
    popl %esp
c0101ee7:	5c                   	pop    %esp

c0101ee8 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0101ee8:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0101ee9:	0f a9                	pop    %gs
    popl %fs
c0101eeb:	0f a1                	pop    %fs
    popl %es
c0101eed:	07                   	pop    %es
    popl %ds
c0101eee:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0101eef:	83 c4 08             	add    $0x8,%esp
    iret
c0101ef2:	cf                   	iret   

c0101ef3 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0101ef3:	6a 00                	push   $0x0
  pushl $0
c0101ef5:	6a 00                	push   $0x0
  jmp __alltraps
c0101ef7:	e9 d5 ff ff ff       	jmp    c0101ed1 <__alltraps>

c0101efc <vector1>:
.globl vector1
vector1:
  pushl $0
c0101efc:	6a 00                	push   $0x0
  pushl $1
c0101efe:	6a 01                	push   $0x1
  jmp __alltraps
c0101f00:	e9 cc ff ff ff       	jmp    c0101ed1 <__alltraps>

c0101f05 <vector2>:
.globl vector2
vector2:
  pushl $0
c0101f05:	6a 00                	push   $0x0
  pushl $2
c0101f07:	6a 02                	push   $0x2
  jmp __alltraps
c0101f09:	e9 c3 ff ff ff       	jmp    c0101ed1 <__alltraps>

c0101f0e <vector3>:
.globl vector3
vector3:
  pushl $0
c0101f0e:	6a 00                	push   $0x0
  pushl $3
c0101f10:	6a 03                	push   $0x3
  jmp __alltraps
c0101f12:	e9 ba ff ff ff       	jmp    c0101ed1 <__alltraps>

c0101f17 <vector4>:
.globl vector4
vector4:
  pushl $0
c0101f17:	6a 00                	push   $0x0
  pushl $4
c0101f19:	6a 04                	push   $0x4
  jmp __alltraps
c0101f1b:	e9 b1 ff ff ff       	jmp    c0101ed1 <__alltraps>

c0101f20 <vector5>:
.globl vector5
vector5:
  pushl $0
c0101f20:	6a 00                	push   $0x0
  pushl $5
c0101f22:	6a 05                	push   $0x5
  jmp __alltraps
c0101f24:	e9 a8 ff ff ff       	jmp    c0101ed1 <__alltraps>

c0101f29 <vector6>:
.globl vector6
vector6:
  pushl $0
c0101f29:	6a 00                	push   $0x0
  pushl $6
c0101f2b:	6a 06                	push   $0x6
  jmp __alltraps
c0101f2d:	e9 9f ff ff ff       	jmp    c0101ed1 <__alltraps>

c0101f32 <vector7>:
.globl vector7
vector7:
  pushl $0
c0101f32:	6a 00                	push   $0x0
  pushl $7
c0101f34:	6a 07                	push   $0x7
  jmp __alltraps
c0101f36:	e9 96 ff ff ff       	jmp    c0101ed1 <__alltraps>

c0101f3b <vector8>:
.globl vector8
vector8:
  pushl $8
c0101f3b:	6a 08                	push   $0x8
  jmp __alltraps
c0101f3d:	e9 8f ff ff ff       	jmp    c0101ed1 <__alltraps>

c0101f42 <vector9>:
.globl vector9
vector9:
  pushl $0
c0101f42:	6a 00                	push   $0x0
  pushl $9
c0101f44:	6a 09                	push   $0x9
  jmp __alltraps
c0101f46:	e9 86 ff ff ff       	jmp    c0101ed1 <__alltraps>

c0101f4b <vector10>:
.globl vector10
vector10:
  pushl $10
c0101f4b:	6a 0a                	push   $0xa
  jmp __alltraps
c0101f4d:	e9 7f ff ff ff       	jmp    c0101ed1 <__alltraps>

c0101f52 <vector11>:
.globl vector11
vector11:
  pushl $11
c0101f52:	6a 0b                	push   $0xb
  jmp __alltraps
c0101f54:	e9 78 ff ff ff       	jmp    c0101ed1 <__alltraps>

c0101f59 <vector12>:
.globl vector12
vector12:
  pushl $12
c0101f59:	6a 0c                	push   $0xc
  jmp __alltraps
c0101f5b:	e9 71 ff ff ff       	jmp    c0101ed1 <__alltraps>

c0101f60 <vector13>:
.globl vector13
vector13:
  pushl $13
c0101f60:	6a 0d                	push   $0xd
  jmp __alltraps
c0101f62:	e9 6a ff ff ff       	jmp    c0101ed1 <__alltraps>

c0101f67 <vector14>:
.globl vector14
vector14:
  pushl $14
c0101f67:	6a 0e                	push   $0xe
  jmp __alltraps
c0101f69:	e9 63 ff ff ff       	jmp    c0101ed1 <__alltraps>

c0101f6e <vector15>:
.globl vector15
vector15:
  pushl $0
c0101f6e:	6a 00                	push   $0x0
  pushl $15
c0101f70:	6a 0f                	push   $0xf
  jmp __alltraps
c0101f72:	e9 5a ff ff ff       	jmp    c0101ed1 <__alltraps>

c0101f77 <vector16>:
.globl vector16
vector16:
  pushl $0
c0101f77:	6a 00                	push   $0x0
  pushl $16
c0101f79:	6a 10                	push   $0x10
  jmp __alltraps
c0101f7b:	e9 51 ff ff ff       	jmp    c0101ed1 <__alltraps>

c0101f80 <vector17>:
.globl vector17
vector17:
  pushl $17
c0101f80:	6a 11                	push   $0x11
  jmp __alltraps
c0101f82:	e9 4a ff ff ff       	jmp    c0101ed1 <__alltraps>

c0101f87 <vector18>:
.globl vector18
vector18:
  pushl $0
c0101f87:	6a 00                	push   $0x0
  pushl $18
c0101f89:	6a 12                	push   $0x12
  jmp __alltraps
c0101f8b:	e9 41 ff ff ff       	jmp    c0101ed1 <__alltraps>

c0101f90 <vector19>:
.globl vector19
vector19:
  pushl $0
c0101f90:	6a 00                	push   $0x0
  pushl $19
c0101f92:	6a 13                	push   $0x13
  jmp __alltraps
c0101f94:	e9 38 ff ff ff       	jmp    c0101ed1 <__alltraps>

c0101f99 <vector20>:
.globl vector20
vector20:
  pushl $0
c0101f99:	6a 00                	push   $0x0
  pushl $20
c0101f9b:	6a 14                	push   $0x14
  jmp __alltraps
c0101f9d:	e9 2f ff ff ff       	jmp    c0101ed1 <__alltraps>

c0101fa2 <vector21>:
.globl vector21
vector21:
  pushl $0
c0101fa2:	6a 00                	push   $0x0
  pushl $21
c0101fa4:	6a 15                	push   $0x15
  jmp __alltraps
c0101fa6:	e9 26 ff ff ff       	jmp    c0101ed1 <__alltraps>

c0101fab <vector22>:
.globl vector22
vector22:
  pushl $0
c0101fab:	6a 00                	push   $0x0
  pushl $22
c0101fad:	6a 16                	push   $0x16
  jmp __alltraps
c0101faf:	e9 1d ff ff ff       	jmp    c0101ed1 <__alltraps>

c0101fb4 <vector23>:
.globl vector23
vector23:
  pushl $0
c0101fb4:	6a 00                	push   $0x0
  pushl $23
c0101fb6:	6a 17                	push   $0x17
  jmp __alltraps
c0101fb8:	e9 14 ff ff ff       	jmp    c0101ed1 <__alltraps>

c0101fbd <vector24>:
.globl vector24
vector24:
  pushl $0
c0101fbd:	6a 00                	push   $0x0
  pushl $24
c0101fbf:	6a 18                	push   $0x18
  jmp __alltraps
c0101fc1:	e9 0b ff ff ff       	jmp    c0101ed1 <__alltraps>

c0101fc6 <vector25>:
.globl vector25
vector25:
  pushl $0
c0101fc6:	6a 00                	push   $0x0
  pushl $25
c0101fc8:	6a 19                	push   $0x19
  jmp __alltraps
c0101fca:	e9 02 ff ff ff       	jmp    c0101ed1 <__alltraps>

c0101fcf <vector26>:
.globl vector26
vector26:
  pushl $0
c0101fcf:	6a 00                	push   $0x0
  pushl $26
c0101fd1:	6a 1a                	push   $0x1a
  jmp __alltraps
c0101fd3:	e9 f9 fe ff ff       	jmp    c0101ed1 <__alltraps>

c0101fd8 <vector27>:
.globl vector27
vector27:
  pushl $0
c0101fd8:	6a 00                	push   $0x0
  pushl $27
c0101fda:	6a 1b                	push   $0x1b
  jmp __alltraps
c0101fdc:	e9 f0 fe ff ff       	jmp    c0101ed1 <__alltraps>

c0101fe1 <vector28>:
.globl vector28
vector28:
  pushl $0
c0101fe1:	6a 00                	push   $0x0
  pushl $28
c0101fe3:	6a 1c                	push   $0x1c
  jmp __alltraps
c0101fe5:	e9 e7 fe ff ff       	jmp    c0101ed1 <__alltraps>

c0101fea <vector29>:
.globl vector29
vector29:
  pushl $0
c0101fea:	6a 00                	push   $0x0
  pushl $29
c0101fec:	6a 1d                	push   $0x1d
  jmp __alltraps
c0101fee:	e9 de fe ff ff       	jmp    c0101ed1 <__alltraps>

c0101ff3 <vector30>:
.globl vector30
vector30:
  pushl $0
c0101ff3:	6a 00                	push   $0x0
  pushl $30
c0101ff5:	6a 1e                	push   $0x1e
  jmp __alltraps
c0101ff7:	e9 d5 fe ff ff       	jmp    c0101ed1 <__alltraps>

c0101ffc <vector31>:
.globl vector31
vector31:
  pushl $0
c0101ffc:	6a 00                	push   $0x0
  pushl $31
c0101ffe:	6a 1f                	push   $0x1f
  jmp __alltraps
c0102000:	e9 cc fe ff ff       	jmp    c0101ed1 <__alltraps>

c0102005 <vector32>:
.globl vector32
vector32:
  pushl $0
c0102005:	6a 00                	push   $0x0
  pushl $32
c0102007:	6a 20                	push   $0x20
  jmp __alltraps
c0102009:	e9 c3 fe ff ff       	jmp    c0101ed1 <__alltraps>

c010200e <vector33>:
.globl vector33
vector33:
  pushl $0
c010200e:	6a 00                	push   $0x0
  pushl $33
c0102010:	6a 21                	push   $0x21
  jmp __alltraps
c0102012:	e9 ba fe ff ff       	jmp    c0101ed1 <__alltraps>

c0102017 <vector34>:
.globl vector34
vector34:
  pushl $0
c0102017:	6a 00                	push   $0x0
  pushl $34
c0102019:	6a 22                	push   $0x22
  jmp __alltraps
c010201b:	e9 b1 fe ff ff       	jmp    c0101ed1 <__alltraps>

c0102020 <vector35>:
.globl vector35
vector35:
  pushl $0
c0102020:	6a 00                	push   $0x0
  pushl $35
c0102022:	6a 23                	push   $0x23
  jmp __alltraps
c0102024:	e9 a8 fe ff ff       	jmp    c0101ed1 <__alltraps>

c0102029 <vector36>:
.globl vector36
vector36:
  pushl $0
c0102029:	6a 00                	push   $0x0
  pushl $36
c010202b:	6a 24                	push   $0x24
  jmp __alltraps
c010202d:	e9 9f fe ff ff       	jmp    c0101ed1 <__alltraps>

c0102032 <vector37>:
.globl vector37
vector37:
  pushl $0
c0102032:	6a 00                	push   $0x0
  pushl $37
c0102034:	6a 25                	push   $0x25
  jmp __alltraps
c0102036:	e9 96 fe ff ff       	jmp    c0101ed1 <__alltraps>

c010203b <vector38>:
.globl vector38
vector38:
  pushl $0
c010203b:	6a 00                	push   $0x0
  pushl $38
c010203d:	6a 26                	push   $0x26
  jmp __alltraps
c010203f:	e9 8d fe ff ff       	jmp    c0101ed1 <__alltraps>

c0102044 <vector39>:
.globl vector39
vector39:
  pushl $0
c0102044:	6a 00                	push   $0x0
  pushl $39
c0102046:	6a 27                	push   $0x27
  jmp __alltraps
c0102048:	e9 84 fe ff ff       	jmp    c0101ed1 <__alltraps>

c010204d <vector40>:
.globl vector40
vector40:
  pushl $0
c010204d:	6a 00                	push   $0x0
  pushl $40
c010204f:	6a 28                	push   $0x28
  jmp __alltraps
c0102051:	e9 7b fe ff ff       	jmp    c0101ed1 <__alltraps>

c0102056 <vector41>:
.globl vector41
vector41:
  pushl $0
c0102056:	6a 00                	push   $0x0
  pushl $41
c0102058:	6a 29                	push   $0x29
  jmp __alltraps
c010205a:	e9 72 fe ff ff       	jmp    c0101ed1 <__alltraps>

c010205f <vector42>:
.globl vector42
vector42:
  pushl $0
c010205f:	6a 00                	push   $0x0
  pushl $42
c0102061:	6a 2a                	push   $0x2a
  jmp __alltraps
c0102063:	e9 69 fe ff ff       	jmp    c0101ed1 <__alltraps>

c0102068 <vector43>:
.globl vector43
vector43:
  pushl $0
c0102068:	6a 00                	push   $0x0
  pushl $43
c010206a:	6a 2b                	push   $0x2b
  jmp __alltraps
c010206c:	e9 60 fe ff ff       	jmp    c0101ed1 <__alltraps>

c0102071 <vector44>:
.globl vector44
vector44:
  pushl $0
c0102071:	6a 00                	push   $0x0
  pushl $44
c0102073:	6a 2c                	push   $0x2c
  jmp __alltraps
c0102075:	e9 57 fe ff ff       	jmp    c0101ed1 <__alltraps>

c010207a <vector45>:
.globl vector45
vector45:
  pushl $0
c010207a:	6a 00                	push   $0x0
  pushl $45
c010207c:	6a 2d                	push   $0x2d
  jmp __alltraps
c010207e:	e9 4e fe ff ff       	jmp    c0101ed1 <__alltraps>

c0102083 <vector46>:
.globl vector46
vector46:
  pushl $0
c0102083:	6a 00                	push   $0x0
  pushl $46
c0102085:	6a 2e                	push   $0x2e
  jmp __alltraps
c0102087:	e9 45 fe ff ff       	jmp    c0101ed1 <__alltraps>

c010208c <vector47>:
.globl vector47
vector47:
  pushl $0
c010208c:	6a 00                	push   $0x0
  pushl $47
c010208e:	6a 2f                	push   $0x2f
  jmp __alltraps
c0102090:	e9 3c fe ff ff       	jmp    c0101ed1 <__alltraps>

c0102095 <vector48>:
.globl vector48
vector48:
  pushl $0
c0102095:	6a 00                	push   $0x0
  pushl $48
c0102097:	6a 30                	push   $0x30
  jmp __alltraps
c0102099:	e9 33 fe ff ff       	jmp    c0101ed1 <__alltraps>

c010209e <vector49>:
.globl vector49
vector49:
  pushl $0
c010209e:	6a 00                	push   $0x0
  pushl $49
c01020a0:	6a 31                	push   $0x31
  jmp __alltraps
c01020a2:	e9 2a fe ff ff       	jmp    c0101ed1 <__alltraps>

c01020a7 <vector50>:
.globl vector50
vector50:
  pushl $0
c01020a7:	6a 00                	push   $0x0
  pushl $50
c01020a9:	6a 32                	push   $0x32
  jmp __alltraps
c01020ab:	e9 21 fe ff ff       	jmp    c0101ed1 <__alltraps>

c01020b0 <vector51>:
.globl vector51
vector51:
  pushl $0
c01020b0:	6a 00                	push   $0x0
  pushl $51
c01020b2:	6a 33                	push   $0x33
  jmp __alltraps
c01020b4:	e9 18 fe ff ff       	jmp    c0101ed1 <__alltraps>

c01020b9 <vector52>:
.globl vector52
vector52:
  pushl $0
c01020b9:	6a 00                	push   $0x0
  pushl $52
c01020bb:	6a 34                	push   $0x34
  jmp __alltraps
c01020bd:	e9 0f fe ff ff       	jmp    c0101ed1 <__alltraps>

c01020c2 <vector53>:
.globl vector53
vector53:
  pushl $0
c01020c2:	6a 00                	push   $0x0
  pushl $53
c01020c4:	6a 35                	push   $0x35
  jmp __alltraps
c01020c6:	e9 06 fe ff ff       	jmp    c0101ed1 <__alltraps>

c01020cb <vector54>:
.globl vector54
vector54:
  pushl $0
c01020cb:	6a 00                	push   $0x0
  pushl $54
c01020cd:	6a 36                	push   $0x36
  jmp __alltraps
c01020cf:	e9 fd fd ff ff       	jmp    c0101ed1 <__alltraps>

c01020d4 <vector55>:
.globl vector55
vector55:
  pushl $0
c01020d4:	6a 00                	push   $0x0
  pushl $55
c01020d6:	6a 37                	push   $0x37
  jmp __alltraps
c01020d8:	e9 f4 fd ff ff       	jmp    c0101ed1 <__alltraps>

c01020dd <vector56>:
.globl vector56
vector56:
  pushl $0
c01020dd:	6a 00                	push   $0x0
  pushl $56
c01020df:	6a 38                	push   $0x38
  jmp __alltraps
c01020e1:	e9 eb fd ff ff       	jmp    c0101ed1 <__alltraps>

c01020e6 <vector57>:
.globl vector57
vector57:
  pushl $0
c01020e6:	6a 00                	push   $0x0
  pushl $57
c01020e8:	6a 39                	push   $0x39
  jmp __alltraps
c01020ea:	e9 e2 fd ff ff       	jmp    c0101ed1 <__alltraps>

c01020ef <vector58>:
.globl vector58
vector58:
  pushl $0
c01020ef:	6a 00                	push   $0x0
  pushl $58
c01020f1:	6a 3a                	push   $0x3a
  jmp __alltraps
c01020f3:	e9 d9 fd ff ff       	jmp    c0101ed1 <__alltraps>

c01020f8 <vector59>:
.globl vector59
vector59:
  pushl $0
c01020f8:	6a 00                	push   $0x0
  pushl $59
c01020fa:	6a 3b                	push   $0x3b
  jmp __alltraps
c01020fc:	e9 d0 fd ff ff       	jmp    c0101ed1 <__alltraps>

c0102101 <vector60>:
.globl vector60
vector60:
  pushl $0
c0102101:	6a 00                	push   $0x0
  pushl $60
c0102103:	6a 3c                	push   $0x3c
  jmp __alltraps
c0102105:	e9 c7 fd ff ff       	jmp    c0101ed1 <__alltraps>

c010210a <vector61>:
.globl vector61
vector61:
  pushl $0
c010210a:	6a 00                	push   $0x0
  pushl $61
c010210c:	6a 3d                	push   $0x3d
  jmp __alltraps
c010210e:	e9 be fd ff ff       	jmp    c0101ed1 <__alltraps>

c0102113 <vector62>:
.globl vector62
vector62:
  pushl $0
c0102113:	6a 00                	push   $0x0
  pushl $62
c0102115:	6a 3e                	push   $0x3e
  jmp __alltraps
c0102117:	e9 b5 fd ff ff       	jmp    c0101ed1 <__alltraps>

c010211c <vector63>:
.globl vector63
vector63:
  pushl $0
c010211c:	6a 00                	push   $0x0
  pushl $63
c010211e:	6a 3f                	push   $0x3f
  jmp __alltraps
c0102120:	e9 ac fd ff ff       	jmp    c0101ed1 <__alltraps>

c0102125 <vector64>:
.globl vector64
vector64:
  pushl $0
c0102125:	6a 00                	push   $0x0
  pushl $64
c0102127:	6a 40                	push   $0x40
  jmp __alltraps
c0102129:	e9 a3 fd ff ff       	jmp    c0101ed1 <__alltraps>

c010212e <vector65>:
.globl vector65
vector65:
  pushl $0
c010212e:	6a 00                	push   $0x0
  pushl $65
c0102130:	6a 41                	push   $0x41
  jmp __alltraps
c0102132:	e9 9a fd ff ff       	jmp    c0101ed1 <__alltraps>

c0102137 <vector66>:
.globl vector66
vector66:
  pushl $0
c0102137:	6a 00                	push   $0x0
  pushl $66
c0102139:	6a 42                	push   $0x42
  jmp __alltraps
c010213b:	e9 91 fd ff ff       	jmp    c0101ed1 <__alltraps>

c0102140 <vector67>:
.globl vector67
vector67:
  pushl $0
c0102140:	6a 00                	push   $0x0
  pushl $67
c0102142:	6a 43                	push   $0x43
  jmp __alltraps
c0102144:	e9 88 fd ff ff       	jmp    c0101ed1 <__alltraps>

c0102149 <vector68>:
.globl vector68
vector68:
  pushl $0
c0102149:	6a 00                	push   $0x0
  pushl $68
c010214b:	6a 44                	push   $0x44
  jmp __alltraps
c010214d:	e9 7f fd ff ff       	jmp    c0101ed1 <__alltraps>

c0102152 <vector69>:
.globl vector69
vector69:
  pushl $0
c0102152:	6a 00                	push   $0x0
  pushl $69
c0102154:	6a 45                	push   $0x45
  jmp __alltraps
c0102156:	e9 76 fd ff ff       	jmp    c0101ed1 <__alltraps>

c010215b <vector70>:
.globl vector70
vector70:
  pushl $0
c010215b:	6a 00                	push   $0x0
  pushl $70
c010215d:	6a 46                	push   $0x46
  jmp __alltraps
c010215f:	e9 6d fd ff ff       	jmp    c0101ed1 <__alltraps>

c0102164 <vector71>:
.globl vector71
vector71:
  pushl $0
c0102164:	6a 00                	push   $0x0
  pushl $71
c0102166:	6a 47                	push   $0x47
  jmp __alltraps
c0102168:	e9 64 fd ff ff       	jmp    c0101ed1 <__alltraps>

c010216d <vector72>:
.globl vector72
vector72:
  pushl $0
c010216d:	6a 00                	push   $0x0
  pushl $72
c010216f:	6a 48                	push   $0x48
  jmp __alltraps
c0102171:	e9 5b fd ff ff       	jmp    c0101ed1 <__alltraps>

c0102176 <vector73>:
.globl vector73
vector73:
  pushl $0
c0102176:	6a 00                	push   $0x0
  pushl $73
c0102178:	6a 49                	push   $0x49
  jmp __alltraps
c010217a:	e9 52 fd ff ff       	jmp    c0101ed1 <__alltraps>

c010217f <vector74>:
.globl vector74
vector74:
  pushl $0
c010217f:	6a 00                	push   $0x0
  pushl $74
c0102181:	6a 4a                	push   $0x4a
  jmp __alltraps
c0102183:	e9 49 fd ff ff       	jmp    c0101ed1 <__alltraps>

c0102188 <vector75>:
.globl vector75
vector75:
  pushl $0
c0102188:	6a 00                	push   $0x0
  pushl $75
c010218a:	6a 4b                	push   $0x4b
  jmp __alltraps
c010218c:	e9 40 fd ff ff       	jmp    c0101ed1 <__alltraps>

c0102191 <vector76>:
.globl vector76
vector76:
  pushl $0
c0102191:	6a 00                	push   $0x0
  pushl $76
c0102193:	6a 4c                	push   $0x4c
  jmp __alltraps
c0102195:	e9 37 fd ff ff       	jmp    c0101ed1 <__alltraps>

c010219a <vector77>:
.globl vector77
vector77:
  pushl $0
c010219a:	6a 00                	push   $0x0
  pushl $77
c010219c:	6a 4d                	push   $0x4d
  jmp __alltraps
c010219e:	e9 2e fd ff ff       	jmp    c0101ed1 <__alltraps>

c01021a3 <vector78>:
.globl vector78
vector78:
  pushl $0
c01021a3:	6a 00                	push   $0x0
  pushl $78
c01021a5:	6a 4e                	push   $0x4e
  jmp __alltraps
c01021a7:	e9 25 fd ff ff       	jmp    c0101ed1 <__alltraps>

c01021ac <vector79>:
.globl vector79
vector79:
  pushl $0
c01021ac:	6a 00                	push   $0x0
  pushl $79
c01021ae:	6a 4f                	push   $0x4f
  jmp __alltraps
c01021b0:	e9 1c fd ff ff       	jmp    c0101ed1 <__alltraps>

c01021b5 <vector80>:
.globl vector80
vector80:
  pushl $0
c01021b5:	6a 00                	push   $0x0
  pushl $80
c01021b7:	6a 50                	push   $0x50
  jmp __alltraps
c01021b9:	e9 13 fd ff ff       	jmp    c0101ed1 <__alltraps>

c01021be <vector81>:
.globl vector81
vector81:
  pushl $0
c01021be:	6a 00                	push   $0x0
  pushl $81
c01021c0:	6a 51                	push   $0x51
  jmp __alltraps
c01021c2:	e9 0a fd ff ff       	jmp    c0101ed1 <__alltraps>

c01021c7 <vector82>:
.globl vector82
vector82:
  pushl $0
c01021c7:	6a 00                	push   $0x0
  pushl $82
c01021c9:	6a 52                	push   $0x52
  jmp __alltraps
c01021cb:	e9 01 fd ff ff       	jmp    c0101ed1 <__alltraps>

c01021d0 <vector83>:
.globl vector83
vector83:
  pushl $0
c01021d0:	6a 00                	push   $0x0
  pushl $83
c01021d2:	6a 53                	push   $0x53
  jmp __alltraps
c01021d4:	e9 f8 fc ff ff       	jmp    c0101ed1 <__alltraps>

c01021d9 <vector84>:
.globl vector84
vector84:
  pushl $0
c01021d9:	6a 00                	push   $0x0
  pushl $84
c01021db:	6a 54                	push   $0x54
  jmp __alltraps
c01021dd:	e9 ef fc ff ff       	jmp    c0101ed1 <__alltraps>

c01021e2 <vector85>:
.globl vector85
vector85:
  pushl $0
c01021e2:	6a 00                	push   $0x0
  pushl $85
c01021e4:	6a 55                	push   $0x55
  jmp __alltraps
c01021e6:	e9 e6 fc ff ff       	jmp    c0101ed1 <__alltraps>

c01021eb <vector86>:
.globl vector86
vector86:
  pushl $0
c01021eb:	6a 00                	push   $0x0
  pushl $86
c01021ed:	6a 56                	push   $0x56
  jmp __alltraps
c01021ef:	e9 dd fc ff ff       	jmp    c0101ed1 <__alltraps>

c01021f4 <vector87>:
.globl vector87
vector87:
  pushl $0
c01021f4:	6a 00                	push   $0x0
  pushl $87
c01021f6:	6a 57                	push   $0x57
  jmp __alltraps
c01021f8:	e9 d4 fc ff ff       	jmp    c0101ed1 <__alltraps>

c01021fd <vector88>:
.globl vector88
vector88:
  pushl $0
c01021fd:	6a 00                	push   $0x0
  pushl $88
c01021ff:	6a 58                	push   $0x58
  jmp __alltraps
c0102201:	e9 cb fc ff ff       	jmp    c0101ed1 <__alltraps>

c0102206 <vector89>:
.globl vector89
vector89:
  pushl $0
c0102206:	6a 00                	push   $0x0
  pushl $89
c0102208:	6a 59                	push   $0x59
  jmp __alltraps
c010220a:	e9 c2 fc ff ff       	jmp    c0101ed1 <__alltraps>

c010220f <vector90>:
.globl vector90
vector90:
  pushl $0
c010220f:	6a 00                	push   $0x0
  pushl $90
c0102211:	6a 5a                	push   $0x5a
  jmp __alltraps
c0102213:	e9 b9 fc ff ff       	jmp    c0101ed1 <__alltraps>

c0102218 <vector91>:
.globl vector91
vector91:
  pushl $0
c0102218:	6a 00                	push   $0x0
  pushl $91
c010221a:	6a 5b                	push   $0x5b
  jmp __alltraps
c010221c:	e9 b0 fc ff ff       	jmp    c0101ed1 <__alltraps>

c0102221 <vector92>:
.globl vector92
vector92:
  pushl $0
c0102221:	6a 00                	push   $0x0
  pushl $92
c0102223:	6a 5c                	push   $0x5c
  jmp __alltraps
c0102225:	e9 a7 fc ff ff       	jmp    c0101ed1 <__alltraps>

c010222a <vector93>:
.globl vector93
vector93:
  pushl $0
c010222a:	6a 00                	push   $0x0
  pushl $93
c010222c:	6a 5d                	push   $0x5d
  jmp __alltraps
c010222e:	e9 9e fc ff ff       	jmp    c0101ed1 <__alltraps>

c0102233 <vector94>:
.globl vector94
vector94:
  pushl $0
c0102233:	6a 00                	push   $0x0
  pushl $94
c0102235:	6a 5e                	push   $0x5e
  jmp __alltraps
c0102237:	e9 95 fc ff ff       	jmp    c0101ed1 <__alltraps>

c010223c <vector95>:
.globl vector95
vector95:
  pushl $0
c010223c:	6a 00                	push   $0x0
  pushl $95
c010223e:	6a 5f                	push   $0x5f
  jmp __alltraps
c0102240:	e9 8c fc ff ff       	jmp    c0101ed1 <__alltraps>

c0102245 <vector96>:
.globl vector96
vector96:
  pushl $0
c0102245:	6a 00                	push   $0x0
  pushl $96
c0102247:	6a 60                	push   $0x60
  jmp __alltraps
c0102249:	e9 83 fc ff ff       	jmp    c0101ed1 <__alltraps>

c010224e <vector97>:
.globl vector97
vector97:
  pushl $0
c010224e:	6a 00                	push   $0x0
  pushl $97
c0102250:	6a 61                	push   $0x61
  jmp __alltraps
c0102252:	e9 7a fc ff ff       	jmp    c0101ed1 <__alltraps>

c0102257 <vector98>:
.globl vector98
vector98:
  pushl $0
c0102257:	6a 00                	push   $0x0
  pushl $98
c0102259:	6a 62                	push   $0x62
  jmp __alltraps
c010225b:	e9 71 fc ff ff       	jmp    c0101ed1 <__alltraps>

c0102260 <vector99>:
.globl vector99
vector99:
  pushl $0
c0102260:	6a 00                	push   $0x0
  pushl $99
c0102262:	6a 63                	push   $0x63
  jmp __alltraps
c0102264:	e9 68 fc ff ff       	jmp    c0101ed1 <__alltraps>

c0102269 <vector100>:
.globl vector100
vector100:
  pushl $0
c0102269:	6a 00                	push   $0x0
  pushl $100
c010226b:	6a 64                	push   $0x64
  jmp __alltraps
c010226d:	e9 5f fc ff ff       	jmp    c0101ed1 <__alltraps>

c0102272 <vector101>:
.globl vector101
vector101:
  pushl $0
c0102272:	6a 00                	push   $0x0
  pushl $101
c0102274:	6a 65                	push   $0x65
  jmp __alltraps
c0102276:	e9 56 fc ff ff       	jmp    c0101ed1 <__alltraps>

c010227b <vector102>:
.globl vector102
vector102:
  pushl $0
c010227b:	6a 00                	push   $0x0
  pushl $102
c010227d:	6a 66                	push   $0x66
  jmp __alltraps
c010227f:	e9 4d fc ff ff       	jmp    c0101ed1 <__alltraps>

c0102284 <vector103>:
.globl vector103
vector103:
  pushl $0
c0102284:	6a 00                	push   $0x0
  pushl $103
c0102286:	6a 67                	push   $0x67
  jmp __alltraps
c0102288:	e9 44 fc ff ff       	jmp    c0101ed1 <__alltraps>

c010228d <vector104>:
.globl vector104
vector104:
  pushl $0
c010228d:	6a 00                	push   $0x0
  pushl $104
c010228f:	6a 68                	push   $0x68
  jmp __alltraps
c0102291:	e9 3b fc ff ff       	jmp    c0101ed1 <__alltraps>

c0102296 <vector105>:
.globl vector105
vector105:
  pushl $0
c0102296:	6a 00                	push   $0x0
  pushl $105
c0102298:	6a 69                	push   $0x69
  jmp __alltraps
c010229a:	e9 32 fc ff ff       	jmp    c0101ed1 <__alltraps>

c010229f <vector106>:
.globl vector106
vector106:
  pushl $0
c010229f:	6a 00                	push   $0x0
  pushl $106
c01022a1:	6a 6a                	push   $0x6a
  jmp __alltraps
c01022a3:	e9 29 fc ff ff       	jmp    c0101ed1 <__alltraps>

c01022a8 <vector107>:
.globl vector107
vector107:
  pushl $0
c01022a8:	6a 00                	push   $0x0
  pushl $107
c01022aa:	6a 6b                	push   $0x6b
  jmp __alltraps
c01022ac:	e9 20 fc ff ff       	jmp    c0101ed1 <__alltraps>

c01022b1 <vector108>:
.globl vector108
vector108:
  pushl $0
c01022b1:	6a 00                	push   $0x0
  pushl $108
c01022b3:	6a 6c                	push   $0x6c
  jmp __alltraps
c01022b5:	e9 17 fc ff ff       	jmp    c0101ed1 <__alltraps>

c01022ba <vector109>:
.globl vector109
vector109:
  pushl $0
c01022ba:	6a 00                	push   $0x0
  pushl $109
c01022bc:	6a 6d                	push   $0x6d
  jmp __alltraps
c01022be:	e9 0e fc ff ff       	jmp    c0101ed1 <__alltraps>

c01022c3 <vector110>:
.globl vector110
vector110:
  pushl $0
c01022c3:	6a 00                	push   $0x0
  pushl $110
c01022c5:	6a 6e                	push   $0x6e
  jmp __alltraps
c01022c7:	e9 05 fc ff ff       	jmp    c0101ed1 <__alltraps>

c01022cc <vector111>:
.globl vector111
vector111:
  pushl $0
c01022cc:	6a 00                	push   $0x0
  pushl $111
c01022ce:	6a 6f                	push   $0x6f
  jmp __alltraps
c01022d0:	e9 fc fb ff ff       	jmp    c0101ed1 <__alltraps>

c01022d5 <vector112>:
.globl vector112
vector112:
  pushl $0
c01022d5:	6a 00                	push   $0x0
  pushl $112
c01022d7:	6a 70                	push   $0x70
  jmp __alltraps
c01022d9:	e9 f3 fb ff ff       	jmp    c0101ed1 <__alltraps>

c01022de <vector113>:
.globl vector113
vector113:
  pushl $0
c01022de:	6a 00                	push   $0x0
  pushl $113
c01022e0:	6a 71                	push   $0x71
  jmp __alltraps
c01022e2:	e9 ea fb ff ff       	jmp    c0101ed1 <__alltraps>

c01022e7 <vector114>:
.globl vector114
vector114:
  pushl $0
c01022e7:	6a 00                	push   $0x0
  pushl $114
c01022e9:	6a 72                	push   $0x72
  jmp __alltraps
c01022eb:	e9 e1 fb ff ff       	jmp    c0101ed1 <__alltraps>

c01022f0 <vector115>:
.globl vector115
vector115:
  pushl $0
c01022f0:	6a 00                	push   $0x0
  pushl $115
c01022f2:	6a 73                	push   $0x73
  jmp __alltraps
c01022f4:	e9 d8 fb ff ff       	jmp    c0101ed1 <__alltraps>

c01022f9 <vector116>:
.globl vector116
vector116:
  pushl $0
c01022f9:	6a 00                	push   $0x0
  pushl $116
c01022fb:	6a 74                	push   $0x74
  jmp __alltraps
c01022fd:	e9 cf fb ff ff       	jmp    c0101ed1 <__alltraps>

c0102302 <vector117>:
.globl vector117
vector117:
  pushl $0
c0102302:	6a 00                	push   $0x0
  pushl $117
c0102304:	6a 75                	push   $0x75
  jmp __alltraps
c0102306:	e9 c6 fb ff ff       	jmp    c0101ed1 <__alltraps>

c010230b <vector118>:
.globl vector118
vector118:
  pushl $0
c010230b:	6a 00                	push   $0x0
  pushl $118
c010230d:	6a 76                	push   $0x76
  jmp __alltraps
c010230f:	e9 bd fb ff ff       	jmp    c0101ed1 <__alltraps>

c0102314 <vector119>:
.globl vector119
vector119:
  pushl $0
c0102314:	6a 00                	push   $0x0
  pushl $119
c0102316:	6a 77                	push   $0x77
  jmp __alltraps
c0102318:	e9 b4 fb ff ff       	jmp    c0101ed1 <__alltraps>

c010231d <vector120>:
.globl vector120
vector120:
  pushl $0
c010231d:	6a 00                	push   $0x0
  pushl $120
c010231f:	6a 78                	push   $0x78
  jmp __alltraps
c0102321:	e9 ab fb ff ff       	jmp    c0101ed1 <__alltraps>

c0102326 <vector121>:
.globl vector121
vector121:
  pushl $0
c0102326:	6a 00                	push   $0x0
  pushl $121
c0102328:	6a 79                	push   $0x79
  jmp __alltraps
c010232a:	e9 a2 fb ff ff       	jmp    c0101ed1 <__alltraps>

c010232f <vector122>:
.globl vector122
vector122:
  pushl $0
c010232f:	6a 00                	push   $0x0
  pushl $122
c0102331:	6a 7a                	push   $0x7a
  jmp __alltraps
c0102333:	e9 99 fb ff ff       	jmp    c0101ed1 <__alltraps>

c0102338 <vector123>:
.globl vector123
vector123:
  pushl $0
c0102338:	6a 00                	push   $0x0
  pushl $123
c010233a:	6a 7b                	push   $0x7b
  jmp __alltraps
c010233c:	e9 90 fb ff ff       	jmp    c0101ed1 <__alltraps>

c0102341 <vector124>:
.globl vector124
vector124:
  pushl $0
c0102341:	6a 00                	push   $0x0
  pushl $124
c0102343:	6a 7c                	push   $0x7c
  jmp __alltraps
c0102345:	e9 87 fb ff ff       	jmp    c0101ed1 <__alltraps>

c010234a <vector125>:
.globl vector125
vector125:
  pushl $0
c010234a:	6a 00                	push   $0x0
  pushl $125
c010234c:	6a 7d                	push   $0x7d
  jmp __alltraps
c010234e:	e9 7e fb ff ff       	jmp    c0101ed1 <__alltraps>

c0102353 <vector126>:
.globl vector126
vector126:
  pushl $0
c0102353:	6a 00                	push   $0x0
  pushl $126
c0102355:	6a 7e                	push   $0x7e
  jmp __alltraps
c0102357:	e9 75 fb ff ff       	jmp    c0101ed1 <__alltraps>

c010235c <vector127>:
.globl vector127
vector127:
  pushl $0
c010235c:	6a 00                	push   $0x0
  pushl $127
c010235e:	6a 7f                	push   $0x7f
  jmp __alltraps
c0102360:	e9 6c fb ff ff       	jmp    c0101ed1 <__alltraps>

c0102365 <vector128>:
.globl vector128
vector128:
  pushl $0
c0102365:	6a 00                	push   $0x0
  pushl $128
c0102367:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c010236c:	e9 60 fb ff ff       	jmp    c0101ed1 <__alltraps>

c0102371 <vector129>:
.globl vector129
vector129:
  pushl $0
c0102371:	6a 00                	push   $0x0
  pushl $129
c0102373:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102378:	e9 54 fb ff ff       	jmp    c0101ed1 <__alltraps>

c010237d <vector130>:
.globl vector130
vector130:
  pushl $0
c010237d:	6a 00                	push   $0x0
  pushl $130
c010237f:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c0102384:	e9 48 fb ff ff       	jmp    c0101ed1 <__alltraps>

c0102389 <vector131>:
.globl vector131
vector131:
  pushl $0
c0102389:	6a 00                	push   $0x0
  pushl $131
c010238b:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c0102390:	e9 3c fb ff ff       	jmp    c0101ed1 <__alltraps>

c0102395 <vector132>:
.globl vector132
vector132:
  pushl $0
c0102395:	6a 00                	push   $0x0
  pushl $132
c0102397:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c010239c:	e9 30 fb ff ff       	jmp    c0101ed1 <__alltraps>

c01023a1 <vector133>:
.globl vector133
vector133:
  pushl $0
c01023a1:	6a 00                	push   $0x0
  pushl $133
c01023a3:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c01023a8:	e9 24 fb ff ff       	jmp    c0101ed1 <__alltraps>

c01023ad <vector134>:
.globl vector134
vector134:
  pushl $0
c01023ad:	6a 00                	push   $0x0
  pushl $134
c01023af:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c01023b4:	e9 18 fb ff ff       	jmp    c0101ed1 <__alltraps>

c01023b9 <vector135>:
.globl vector135
vector135:
  pushl $0
c01023b9:	6a 00                	push   $0x0
  pushl $135
c01023bb:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c01023c0:	e9 0c fb ff ff       	jmp    c0101ed1 <__alltraps>

c01023c5 <vector136>:
.globl vector136
vector136:
  pushl $0
c01023c5:	6a 00                	push   $0x0
  pushl $136
c01023c7:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c01023cc:	e9 00 fb ff ff       	jmp    c0101ed1 <__alltraps>

c01023d1 <vector137>:
.globl vector137
vector137:
  pushl $0
c01023d1:	6a 00                	push   $0x0
  pushl $137
c01023d3:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c01023d8:	e9 f4 fa ff ff       	jmp    c0101ed1 <__alltraps>

c01023dd <vector138>:
.globl vector138
vector138:
  pushl $0
c01023dd:	6a 00                	push   $0x0
  pushl $138
c01023df:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c01023e4:	e9 e8 fa ff ff       	jmp    c0101ed1 <__alltraps>

c01023e9 <vector139>:
.globl vector139
vector139:
  pushl $0
c01023e9:	6a 00                	push   $0x0
  pushl $139
c01023eb:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c01023f0:	e9 dc fa ff ff       	jmp    c0101ed1 <__alltraps>

c01023f5 <vector140>:
.globl vector140
vector140:
  pushl $0
c01023f5:	6a 00                	push   $0x0
  pushl $140
c01023f7:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c01023fc:	e9 d0 fa ff ff       	jmp    c0101ed1 <__alltraps>

c0102401 <vector141>:
.globl vector141
vector141:
  pushl $0
c0102401:	6a 00                	push   $0x0
  pushl $141
c0102403:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c0102408:	e9 c4 fa ff ff       	jmp    c0101ed1 <__alltraps>

c010240d <vector142>:
.globl vector142
vector142:
  pushl $0
c010240d:	6a 00                	push   $0x0
  pushl $142
c010240f:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c0102414:	e9 b8 fa ff ff       	jmp    c0101ed1 <__alltraps>

c0102419 <vector143>:
.globl vector143
vector143:
  pushl $0
c0102419:	6a 00                	push   $0x0
  pushl $143
c010241b:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c0102420:	e9 ac fa ff ff       	jmp    c0101ed1 <__alltraps>

c0102425 <vector144>:
.globl vector144
vector144:
  pushl $0
c0102425:	6a 00                	push   $0x0
  pushl $144
c0102427:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c010242c:	e9 a0 fa ff ff       	jmp    c0101ed1 <__alltraps>

c0102431 <vector145>:
.globl vector145
vector145:
  pushl $0
c0102431:	6a 00                	push   $0x0
  pushl $145
c0102433:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c0102438:	e9 94 fa ff ff       	jmp    c0101ed1 <__alltraps>

c010243d <vector146>:
.globl vector146
vector146:
  pushl $0
c010243d:	6a 00                	push   $0x0
  pushl $146
c010243f:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c0102444:	e9 88 fa ff ff       	jmp    c0101ed1 <__alltraps>

c0102449 <vector147>:
.globl vector147
vector147:
  pushl $0
c0102449:	6a 00                	push   $0x0
  pushl $147
c010244b:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c0102450:	e9 7c fa ff ff       	jmp    c0101ed1 <__alltraps>

c0102455 <vector148>:
.globl vector148
vector148:
  pushl $0
c0102455:	6a 00                	push   $0x0
  pushl $148
c0102457:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c010245c:	e9 70 fa ff ff       	jmp    c0101ed1 <__alltraps>

c0102461 <vector149>:
.globl vector149
vector149:
  pushl $0
c0102461:	6a 00                	push   $0x0
  pushl $149
c0102463:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c0102468:	e9 64 fa ff ff       	jmp    c0101ed1 <__alltraps>

c010246d <vector150>:
.globl vector150
vector150:
  pushl $0
c010246d:	6a 00                	push   $0x0
  pushl $150
c010246f:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0102474:	e9 58 fa ff ff       	jmp    c0101ed1 <__alltraps>

c0102479 <vector151>:
.globl vector151
vector151:
  pushl $0
c0102479:	6a 00                	push   $0x0
  pushl $151
c010247b:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c0102480:	e9 4c fa ff ff       	jmp    c0101ed1 <__alltraps>

c0102485 <vector152>:
.globl vector152
vector152:
  pushl $0
c0102485:	6a 00                	push   $0x0
  pushl $152
c0102487:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c010248c:	e9 40 fa ff ff       	jmp    c0101ed1 <__alltraps>

c0102491 <vector153>:
.globl vector153
vector153:
  pushl $0
c0102491:	6a 00                	push   $0x0
  pushl $153
c0102493:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102498:	e9 34 fa ff ff       	jmp    c0101ed1 <__alltraps>

c010249d <vector154>:
.globl vector154
vector154:
  pushl $0
c010249d:	6a 00                	push   $0x0
  pushl $154
c010249f:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c01024a4:	e9 28 fa ff ff       	jmp    c0101ed1 <__alltraps>

c01024a9 <vector155>:
.globl vector155
vector155:
  pushl $0
c01024a9:	6a 00                	push   $0x0
  pushl $155
c01024ab:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c01024b0:	e9 1c fa ff ff       	jmp    c0101ed1 <__alltraps>

c01024b5 <vector156>:
.globl vector156
vector156:
  pushl $0
c01024b5:	6a 00                	push   $0x0
  pushl $156
c01024b7:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c01024bc:	e9 10 fa ff ff       	jmp    c0101ed1 <__alltraps>

c01024c1 <vector157>:
.globl vector157
vector157:
  pushl $0
c01024c1:	6a 00                	push   $0x0
  pushl $157
c01024c3:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c01024c8:	e9 04 fa ff ff       	jmp    c0101ed1 <__alltraps>

c01024cd <vector158>:
.globl vector158
vector158:
  pushl $0
c01024cd:	6a 00                	push   $0x0
  pushl $158
c01024cf:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c01024d4:	e9 f8 f9 ff ff       	jmp    c0101ed1 <__alltraps>

c01024d9 <vector159>:
.globl vector159
vector159:
  pushl $0
c01024d9:	6a 00                	push   $0x0
  pushl $159
c01024db:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c01024e0:	e9 ec f9 ff ff       	jmp    c0101ed1 <__alltraps>

c01024e5 <vector160>:
.globl vector160
vector160:
  pushl $0
c01024e5:	6a 00                	push   $0x0
  pushl $160
c01024e7:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c01024ec:	e9 e0 f9 ff ff       	jmp    c0101ed1 <__alltraps>

c01024f1 <vector161>:
.globl vector161
vector161:
  pushl $0
c01024f1:	6a 00                	push   $0x0
  pushl $161
c01024f3:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c01024f8:	e9 d4 f9 ff ff       	jmp    c0101ed1 <__alltraps>

c01024fd <vector162>:
.globl vector162
vector162:
  pushl $0
c01024fd:	6a 00                	push   $0x0
  pushl $162
c01024ff:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c0102504:	e9 c8 f9 ff ff       	jmp    c0101ed1 <__alltraps>

c0102509 <vector163>:
.globl vector163
vector163:
  pushl $0
c0102509:	6a 00                	push   $0x0
  pushl $163
c010250b:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c0102510:	e9 bc f9 ff ff       	jmp    c0101ed1 <__alltraps>

c0102515 <vector164>:
.globl vector164
vector164:
  pushl $0
c0102515:	6a 00                	push   $0x0
  pushl $164
c0102517:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c010251c:	e9 b0 f9 ff ff       	jmp    c0101ed1 <__alltraps>

c0102521 <vector165>:
.globl vector165
vector165:
  pushl $0
c0102521:	6a 00                	push   $0x0
  pushl $165
c0102523:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c0102528:	e9 a4 f9 ff ff       	jmp    c0101ed1 <__alltraps>

c010252d <vector166>:
.globl vector166
vector166:
  pushl $0
c010252d:	6a 00                	push   $0x0
  pushl $166
c010252f:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c0102534:	e9 98 f9 ff ff       	jmp    c0101ed1 <__alltraps>

c0102539 <vector167>:
.globl vector167
vector167:
  pushl $0
c0102539:	6a 00                	push   $0x0
  pushl $167
c010253b:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c0102540:	e9 8c f9 ff ff       	jmp    c0101ed1 <__alltraps>

c0102545 <vector168>:
.globl vector168
vector168:
  pushl $0
c0102545:	6a 00                	push   $0x0
  pushl $168
c0102547:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c010254c:	e9 80 f9 ff ff       	jmp    c0101ed1 <__alltraps>

c0102551 <vector169>:
.globl vector169
vector169:
  pushl $0
c0102551:	6a 00                	push   $0x0
  pushl $169
c0102553:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c0102558:	e9 74 f9 ff ff       	jmp    c0101ed1 <__alltraps>

c010255d <vector170>:
.globl vector170
vector170:
  pushl $0
c010255d:	6a 00                	push   $0x0
  pushl $170
c010255f:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c0102564:	e9 68 f9 ff ff       	jmp    c0101ed1 <__alltraps>

c0102569 <vector171>:
.globl vector171
vector171:
  pushl $0
c0102569:	6a 00                	push   $0x0
  pushl $171
c010256b:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c0102570:	e9 5c f9 ff ff       	jmp    c0101ed1 <__alltraps>

c0102575 <vector172>:
.globl vector172
vector172:
  pushl $0
c0102575:	6a 00                	push   $0x0
  pushl $172
c0102577:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c010257c:	e9 50 f9 ff ff       	jmp    c0101ed1 <__alltraps>

c0102581 <vector173>:
.globl vector173
vector173:
  pushl $0
c0102581:	6a 00                	push   $0x0
  pushl $173
c0102583:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c0102588:	e9 44 f9 ff ff       	jmp    c0101ed1 <__alltraps>

c010258d <vector174>:
.globl vector174
vector174:
  pushl $0
c010258d:	6a 00                	push   $0x0
  pushl $174
c010258f:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c0102594:	e9 38 f9 ff ff       	jmp    c0101ed1 <__alltraps>

c0102599 <vector175>:
.globl vector175
vector175:
  pushl $0
c0102599:	6a 00                	push   $0x0
  pushl $175
c010259b:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c01025a0:	e9 2c f9 ff ff       	jmp    c0101ed1 <__alltraps>

c01025a5 <vector176>:
.globl vector176
vector176:
  pushl $0
c01025a5:	6a 00                	push   $0x0
  pushl $176
c01025a7:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c01025ac:	e9 20 f9 ff ff       	jmp    c0101ed1 <__alltraps>

c01025b1 <vector177>:
.globl vector177
vector177:
  pushl $0
c01025b1:	6a 00                	push   $0x0
  pushl $177
c01025b3:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c01025b8:	e9 14 f9 ff ff       	jmp    c0101ed1 <__alltraps>

c01025bd <vector178>:
.globl vector178
vector178:
  pushl $0
c01025bd:	6a 00                	push   $0x0
  pushl $178
c01025bf:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c01025c4:	e9 08 f9 ff ff       	jmp    c0101ed1 <__alltraps>

c01025c9 <vector179>:
.globl vector179
vector179:
  pushl $0
c01025c9:	6a 00                	push   $0x0
  pushl $179
c01025cb:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c01025d0:	e9 fc f8 ff ff       	jmp    c0101ed1 <__alltraps>

c01025d5 <vector180>:
.globl vector180
vector180:
  pushl $0
c01025d5:	6a 00                	push   $0x0
  pushl $180
c01025d7:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c01025dc:	e9 f0 f8 ff ff       	jmp    c0101ed1 <__alltraps>

c01025e1 <vector181>:
.globl vector181
vector181:
  pushl $0
c01025e1:	6a 00                	push   $0x0
  pushl $181
c01025e3:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c01025e8:	e9 e4 f8 ff ff       	jmp    c0101ed1 <__alltraps>

c01025ed <vector182>:
.globl vector182
vector182:
  pushl $0
c01025ed:	6a 00                	push   $0x0
  pushl $182
c01025ef:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c01025f4:	e9 d8 f8 ff ff       	jmp    c0101ed1 <__alltraps>

c01025f9 <vector183>:
.globl vector183
vector183:
  pushl $0
c01025f9:	6a 00                	push   $0x0
  pushl $183
c01025fb:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c0102600:	e9 cc f8 ff ff       	jmp    c0101ed1 <__alltraps>

c0102605 <vector184>:
.globl vector184
vector184:
  pushl $0
c0102605:	6a 00                	push   $0x0
  pushl $184
c0102607:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c010260c:	e9 c0 f8 ff ff       	jmp    c0101ed1 <__alltraps>

c0102611 <vector185>:
.globl vector185
vector185:
  pushl $0
c0102611:	6a 00                	push   $0x0
  pushl $185
c0102613:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c0102618:	e9 b4 f8 ff ff       	jmp    c0101ed1 <__alltraps>

c010261d <vector186>:
.globl vector186
vector186:
  pushl $0
c010261d:	6a 00                	push   $0x0
  pushl $186
c010261f:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c0102624:	e9 a8 f8 ff ff       	jmp    c0101ed1 <__alltraps>

c0102629 <vector187>:
.globl vector187
vector187:
  pushl $0
c0102629:	6a 00                	push   $0x0
  pushl $187
c010262b:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c0102630:	e9 9c f8 ff ff       	jmp    c0101ed1 <__alltraps>

c0102635 <vector188>:
.globl vector188
vector188:
  pushl $0
c0102635:	6a 00                	push   $0x0
  pushl $188
c0102637:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c010263c:	e9 90 f8 ff ff       	jmp    c0101ed1 <__alltraps>

c0102641 <vector189>:
.globl vector189
vector189:
  pushl $0
c0102641:	6a 00                	push   $0x0
  pushl $189
c0102643:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c0102648:	e9 84 f8 ff ff       	jmp    c0101ed1 <__alltraps>

c010264d <vector190>:
.globl vector190
vector190:
  pushl $0
c010264d:	6a 00                	push   $0x0
  pushl $190
c010264f:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c0102654:	e9 78 f8 ff ff       	jmp    c0101ed1 <__alltraps>

c0102659 <vector191>:
.globl vector191
vector191:
  pushl $0
c0102659:	6a 00                	push   $0x0
  pushl $191
c010265b:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c0102660:	e9 6c f8 ff ff       	jmp    c0101ed1 <__alltraps>

c0102665 <vector192>:
.globl vector192
vector192:
  pushl $0
c0102665:	6a 00                	push   $0x0
  pushl $192
c0102667:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c010266c:	e9 60 f8 ff ff       	jmp    c0101ed1 <__alltraps>

c0102671 <vector193>:
.globl vector193
vector193:
  pushl $0
c0102671:	6a 00                	push   $0x0
  pushl $193
c0102673:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c0102678:	e9 54 f8 ff ff       	jmp    c0101ed1 <__alltraps>

c010267d <vector194>:
.globl vector194
vector194:
  pushl $0
c010267d:	6a 00                	push   $0x0
  pushl $194
c010267f:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c0102684:	e9 48 f8 ff ff       	jmp    c0101ed1 <__alltraps>

c0102689 <vector195>:
.globl vector195
vector195:
  pushl $0
c0102689:	6a 00                	push   $0x0
  pushl $195
c010268b:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c0102690:	e9 3c f8 ff ff       	jmp    c0101ed1 <__alltraps>

c0102695 <vector196>:
.globl vector196
vector196:
  pushl $0
c0102695:	6a 00                	push   $0x0
  pushl $196
c0102697:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c010269c:	e9 30 f8 ff ff       	jmp    c0101ed1 <__alltraps>

c01026a1 <vector197>:
.globl vector197
vector197:
  pushl $0
c01026a1:	6a 00                	push   $0x0
  pushl $197
c01026a3:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c01026a8:	e9 24 f8 ff ff       	jmp    c0101ed1 <__alltraps>

c01026ad <vector198>:
.globl vector198
vector198:
  pushl $0
c01026ad:	6a 00                	push   $0x0
  pushl $198
c01026af:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c01026b4:	e9 18 f8 ff ff       	jmp    c0101ed1 <__alltraps>

c01026b9 <vector199>:
.globl vector199
vector199:
  pushl $0
c01026b9:	6a 00                	push   $0x0
  pushl $199
c01026bb:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c01026c0:	e9 0c f8 ff ff       	jmp    c0101ed1 <__alltraps>

c01026c5 <vector200>:
.globl vector200
vector200:
  pushl $0
c01026c5:	6a 00                	push   $0x0
  pushl $200
c01026c7:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c01026cc:	e9 00 f8 ff ff       	jmp    c0101ed1 <__alltraps>

c01026d1 <vector201>:
.globl vector201
vector201:
  pushl $0
c01026d1:	6a 00                	push   $0x0
  pushl $201
c01026d3:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c01026d8:	e9 f4 f7 ff ff       	jmp    c0101ed1 <__alltraps>

c01026dd <vector202>:
.globl vector202
vector202:
  pushl $0
c01026dd:	6a 00                	push   $0x0
  pushl $202
c01026df:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c01026e4:	e9 e8 f7 ff ff       	jmp    c0101ed1 <__alltraps>

c01026e9 <vector203>:
.globl vector203
vector203:
  pushl $0
c01026e9:	6a 00                	push   $0x0
  pushl $203
c01026eb:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c01026f0:	e9 dc f7 ff ff       	jmp    c0101ed1 <__alltraps>

c01026f5 <vector204>:
.globl vector204
vector204:
  pushl $0
c01026f5:	6a 00                	push   $0x0
  pushl $204
c01026f7:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c01026fc:	e9 d0 f7 ff ff       	jmp    c0101ed1 <__alltraps>

c0102701 <vector205>:
.globl vector205
vector205:
  pushl $0
c0102701:	6a 00                	push   $0x0
  pushl $205
c0102703:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c0102708:	e9 c4 f7 ff ff       	jmp    c0101ed1 <__alltraps>

c010270d <vector206>:
.globl vector206
vector206:
  pushl $0
c010270d:	6a 00                	push   $0x0
  pushl $206
c010270f:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c0102714:	e9 b8 f7 ff ff       	jmp    c0101ed1 <__alltraps>

c0102719 <vector207>:
.globl vector207
vector207:
  pushl $0
c0102719:	6a 00                	push   $0x0
  pushl $207
c010271b:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c0102720:	e9 ac f7 ff ff       	jmp    c0101ed1 <__alltraps>

c0102725 <vector208>:
.globl vector208
vector208:
  pushl $0
c0102725:	6a 00                	push   $0x0
  pushl $208
c0102727:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c010272c:	e9 a0 f7 ff ff       	jmp    c0101ed1 <__alltraps>

c0102731 <vector209>:
.globl vector209
vector209:
  pushl $0
c0102731:	6a 00                	push   $0x0
  pushl $209
c0102733:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c0102738:	e9 94 f7 ff ff       	jmp    c0101ed1 <__alltraps>

c010273d <vector210>:
.globl vector210
vector210:
  pushl $0
c010273d:	6a 00                	push   $0x0
  pushl $210
c010273f:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c0102744:	e9 88 f7 ff ff       	jmp    c0101ed1 <__alltraps>

c0102749 <vector211>:
.globl vector211
vector211:
  pushl $0
c0102749:	6a 00                	push   $0x0
  pushl $211
c010274b:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c0102750:	e9 7c f7 ff ff       	jmp    c0101ed1 <__alltraps>

c0102755 <vector212>:
.globl vector212
vector212:
  pushl $0
c0102755:	6a 00                	push   $0x0
  pushl $212
c0102757:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c010275c:	e9 70 f7 ff ff       	jmp    c0101ed1 <__alltraps>

c0102761 <vector213>:
.globl vector213
vector213:
  pushl $0
c0102761:	6a 00                	push   $0x0
  pushl $213
c0102763:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c0102768:	e9 64 f7 ff ff       	jmp    c0101ed1 <__alltraps>

c010276d <vector214>:
.globl vector214
vector214:
  pushl $0
c010276d:	6a 00                	push   $0x0
  pushl $214
c010276f:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c0102774:	e9 58 f7 ff ff       	jmp    c0101ed1 <__alltraps>

c0102779 <vector215>:
.globl vector215
vector215:
  pushl $0
c0102779:	6a 00                	push   $0x0
  pushl $215
c010277b:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c0102780:	e9 4c f7 ff ff       	jmp    c0101ed1 <__alltraps>

c0102785 <vector216>:
.globl vector216
vector216:
  pushl $0
c0102785:	6a 00                	push   $0x0
  pushl $216
c0102787:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c010278c:	e9 40 f7 ff ff       	jmp    c0101ed1 <__alltraps>

c0102791 <vector217>:
.globl vector217
vector217:
  pushl $0
c0102791:	6a 00                	push   $0x0
  pushl $217
c0102793:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c0102798:	e9 34 f7 ff ff       	jmp    c0101ed1 <__alltraps>

c010279d <vector218>:
.globl vector218
vector218:
  pushl $0
c010279d:	6a 00                	push   $0x0
  pushl $218
c010279f:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c01027a4:	e9 28 f7 ff ff       	jmp    c0101ed1 <__alltraps>

c01027a9 <vector219>:
.globl vector219
vector219:
  pushl $0
c01027a9:	6a 00                	push   $0x0
  pushl $219
c01027ab:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c01027b0:	e9 1c f7 ff ff       	jmp    c0101ed1 <__alltraps>

c01027b5 <vector220>:
.globl vector220
vector220:
  pushl $0
c01027b5:	6a 00                	push   $0x0
  pushl $220
c01027b7:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c01027bc:	e9 10 f7 ff ff       	jmp    c0101ed1 <__alltraps>

c01027c1 <vector221>:
.globl vector221
vector221:
  pushl $0
c01027c1:	6a 00                	push   $0x0
  pushl $221
c01027c3:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c01027c8:	e9 04 f7 ff ff       	jmp    c0101ed1 <__alltraps>

c01027cd <vector222>:
.globl vector222
vector222:
  pushl $0
c01027cd:	6a 00                	push   $0x0
  pushl $222
c01027cf:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c01027d4:	e9 f8 f6 ff ff       	jmp    c0101ed1 <__alltraps>

c01027d9 <vector223>:
.globl vector223
vector223:
  pushl $0
c01027d9:	6a 00                	push   $0x0
  pushl $223
c01027db:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c01027e0:	e9 ec f6 ff ff       	jmp    c0101ed1 <__alltraps>

c01027e5 <vector224>:
.globl vector224
vector224:
  pushl $0
c01027e5:	6a 00                	push   $0x0
  pushl $224
c01027e7:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c01027ec:	e9 e0 f6 ff ff       	jmp    c0101ed1 <__alltraps>

c01027f1 <vector225>:
.globl vector225
vector225:
  pushl $0
c01027f1:	6a 00                	push   $0x0
  pushl $225
c01027f3:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c01027f8:	e9 d4 f6 ff ff       	jmp    c0101ed1 <__alltraps>

c01027fd <vector226>:
.globl vector226
vector226:
  pushl $0
c01027fd:	6a 00                	push   $0x0
  pushl $226
c01027ff:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c0102804:	e9 c8 f6 ff ff       	jmp    c0101ed1 <__alltraps>

c0102809 <vector227>:
.globl vector227
vector227:
  pushl $0
c0102809:	6a 00                	push   $0x0
  pushl $227
c010280b:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c0102810:	e9 bc f6 ff ff       	jmp    c0101ed1 <__alltraps>

c0102815 <vector228>:
.globl vector228
vector228:
  pushl $0
c0102815:	6a 00                	push   $0x0
  pushl $228
c0102817:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c010281c:	e9 b0 f6 ff ff       	jmp    c0101ed1 <__alltraps>

c0102821 <vector229>:
.globl vector229
vector229:
  pushl $0
c0102821:	6a 00                	push   $0x0
  pushl $229
c0102823:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c0102828:	e9 a4 f6 ff ff       	jmp    c0101ed1 <__alltraps>

c010282d <vector230>:
.globl vector230
vector230:
  pushl $0
c010282d:	6a 00                	push   $0x0
  pushl $230
c010282f:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c0102834:	e9 98 f6 ff ff       	jmp    c0101ed1 <__alltraps>

c0102839 <vector231>:
.globl vector231
vector231:
  pushl $0
c0102839:	6a 00                	push   $0x0
  pushl $231
c010283b:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c0102840:	e9 8c f6 ff ff       	jmp    c0101ed1 <__alltraps>

c0102845 <vector232>:
.globl vector232
vector232:
  pushl $0
c0102845:	6a 00                	push   $0x0
  pushl $232
c0102847:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c010284c:	e9 80 f6 ff ff       	jmp    c0101ed1 <__alltraps>

c0102851 <vector233>:
.globl vector233
vector233:
  pushl $0
c0102851:	6a 00                	push   $0x0
  pushl $233
c0102853:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c0102858:	e9 74 f6 ff ff       	jmp    c0101ed1 <__alltraps>

c010285d <vector234>:
.globl vector234
vector234:
  pushl $0
c010285d:	6a 00                	push   $0x0
  pushl $234
c010285f:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c0102864:	e9 68 f6 ff ff       	jmp    c0101ed1 <__alltraps>

c0102869 <vector235>:
.globl vector235
vector235:
  pushl $0
c0102869:	6a 00                	push   $0x0
  pushl $235
c010286b:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c0102870:	e9 5c f6 ff ff       	jmp    c0101ed1 <__alltraps>

c0102875 <vector236>:
.globl vector236
vector236:
  pushl $0
c0102875:	6a 00                	push   $0x0
  pushl $236
c0102877:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c010287c:	e9 50 f6 ff ff       	jmp    c0101ed1 <__alltraps>

c0102881 <vector237>:
.globl vector237
vector237:
  pushl $0
c0102881:	6a 00                	push   $0x0
  pushl $237
c0102883:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c0102888:	e9 44 f6 ff ff       	jmp    c0101ed1 <__alltraps>

c010288d <vector238>:
.globl vector238
vector238:
  pushl $0
c010288d:	6a 00                	push   $0x0
  pushl $238
c010288f:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c0102894:	e9 38 f6 ff ff       	jmp    c0101ed1 <__alltraps>

c0102899 <vector239>:
.globl vector239
vector239:
  pushl $0
c0102899:	6a 00                	push   $0x0
  pushl $239
c010289b:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c01028a0:	e9 2c f6 ff ff       	jmp    c0101ed1 <__alltraps>

c01028a5 <vector240>:
.globl vector240
vector240:
  pushl $0
c01028a5:	6a 00                	push   $0x0
  pushl $240
c01028a7:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c01028ac:	e9 20 f6 ff ff       	jmp    c0101ed1 <__alltraps>

c01028b1 <vector241>:
.globl vector241
vector241:
  pushl $0
c01028b1:	6a 00                	push   $0x0
  pushl $241
c01028b3:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c01028b8:	e9 14 f6 ff ff       	jmp    c0101ed1 <__alltraps>

c01028bd <vector242>:
.globl vector242
vector242:
  pushl $0
c01028bd:	6a 00                	push   $0x0
  pushl $242
c01028bf:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c01028c4:	e9 08 f6 ff ff       	jmp    c0101ed1 <__alltraps>

c01028c9 <vector243>:
.globl vector243
vector243:
  pushl $0
c01028c9:	6a 00                	push   $0x0
  pushl $243
c01028cb:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c01028d0:	e9 fc f5 ff ff       	jmp    c0101ed1 <__alltraps>

c01028d5 <vector244>:
.globl vector244
vector244:
  pushl $0
c01028d5:	6a 00                	push   $0x0
  pushl $244
c01028d7:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c01028dc:	e9 f0 f5 ff ff       	jmp    c0101ed1 <__alltraps>

c01028e1 <vector245>:
.globl vector245
vector245:
  pushl $0
c01028e1:	6a 00                	push   $0x0
  pushl $245
c01028e3:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c01028e8:	e9 e4 f5 ff ff       	jmp    c0101ed1 <__alltraps>

c01028ed <vector246>:
.globl vector246
vector246:
  pushl $0
c01028ed:	6a 00                	push   $0x0
  pushl $246
c01028ef:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c01028f4:	e9 d8 f5 ff ff       	jmp    c0101ed1 <__alltraps>

c01028f9 <vector247>:
.globl vector247
vector247:
  pushl $0
c01028f9:	6a 00                	push   $0x0
  pushl $247
c01028fb:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c0102900:	e9 cc f5 ff ff       	jmp    c0101ed1 <__alltraps>

c0102905 <vector248>:
.globl vector248
vector248:
  pushl $0
c0102905:	6a 00                	push   $0x0
  pushl $248
c0102907:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c010290c:	e9 c0 f5 ff ff       	jmp    c0101ed1 <__alltraps>

c0102911 <vector249>:
.globl vector249
vector249:
  pushl $0
c0102911:	6a 00                	push   $0x0
  pushl $249
c0102913:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c0102918:	e9 b4 f5 ff ff       	jmp    c0101ed1 <__alltraps>

c010291d <vector250>:
.globl vector250
vector250:
  pushl $0
c010291d:	6a 00                	push   $0x0
  pushl $250
c010291f:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c0102924:	e9 a8 f5 ff ff       	jmp    c0101ed1 <__alltraps>

c0102929 <vector251>:
.globl vector251
vector251:
  pushl $0
c0102929:	6a 00                	push   $0x0
  pushl $251
c010292b:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c0102930:	e9 9c f5 ff ff       	jmp    c0101ed1 <__alltraps>

c0102935 <vector252>:
.globl vector252
vector252:
  pushl $0
c0102935:	6a 00                	push   $0x0
  pushl $252
c0102937:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c010293c:	e9 90 f5 ff ff       	jmp    c0101ed1 <__alltraps>

c0102941 <vector253>:
.globl vector253
vector253:
  pushl $0
c0102941:	6a 00                	push   $0x0
  pushl $253
c0102943:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c0102948:	e9 84 f5 ff ff       	jmp    c0101ed1 <__alltraps>

c010294d <vector254>:
.globl vector254
vector254:
  pushl $0
c010294d:	6a 00                	push   $0x0
  pushl $254
c010294f:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c0102954:	e9 78 f5 ff ff       	jmp    c0101ed1 <__alltraps>

c0102959 <vector255>:
.globl vector255
vector255:
  pushl $0
c0102959:	6a 00                	push   $0x0
  pushl $255
c010295b:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c0102960:	e9 6c f5 ff ff       	jmp    c0101ed1 <__alltraps>

c0102965 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0102965:	55                   	push   %ebp
c0102966:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0102968:	8b 15 a0 ce 11 c0    	mov    0xc011cea0,%edx
c010296e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102971:	29 d0                	sub    %edx,%eax
c0102973:	c1 f8 02             	sar    $0x2,%eax
c0102976:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c010297c:	5d                   	pop    %ebp
c010297d:	c3                   	ret    

c010297e <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c010297e:	55                   	push   %ebp
c010297f:	89 e5                	mov    %esp,%ebp
c0102981:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0102984:	8b 45 08             	mov    0x8(%ebp),%eax
c0102987:	89 04 24             	mov    %eax,(%esp)
c010298a:	e8 d6 ff ff ff       	call   c0102965 <page2ppn>
c010298f:	c1 e0 0c             	shl    $0xc,%eax
}
c0102992:	89 ec                	mov    %ebp,%esp
c0102994:	5d                   	pop    %ebp
c0102995:	c3                   	ret    

c0102996 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0102996:	55                   	push   %ebp
c0102997:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0102999:	8b 45 08             	mov    0x8(%ebp),%eax
c010299c:	8b 00                	mov    (%eax),%eax
}
c010299e:	5d                   	pop    %ebp
c010299f:	c3                   	ret    

c01029a0 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c01029a0:	55                   	push   %ebp
c01029a1:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c01029a3:	8b 45 08             	mov    0x8(%ebp),%eax
c01029a6:	8b 55 0c             	mov    0xc(%ebp),%edx
c01029a9:	89 10                	mov    %edx,(%eax)
}
c01029ab:	90                   	nop
c01029ac:	5d                   	pop    %ebp
c01029ad:	c3                   	ret    

c01029ae <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c01029ae:	55                   	push   %ebp
c01029af:	89 e5                	mov    %esp,%ebp
c01029b1:	83 ec 10             	sub    $0x10,%esp
c01029b4:	c7 45 fc 80 ce 11 c0 	movl   $0xc011ce80,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01029bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01029be:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01029c1:	89 50 04             	mov    %edx,0x4(%eax)
c01029c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01029c7:	8b 50 04             	mov    0x4(%eax),%edx
c01029ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01029cd:	89 10                	mov    %edx,(%eax)
}
c01029cf:	90                   	nop
    list_init(&free_list);
    nr_free = 0;
c01029d0:	c7 05 88 ce 11 c0 00 	movl   $0x0,0xc011ce88
c01029d7:	00 00 00 
}
c01029da:	90                   	nop
c01029db:	89 ec                	mov    %ebp,%esp
c01029dd:	5d                   	pop    %ebp
c01029de:	c3                   	ret    

c01029df <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c01029df:	55                   	push   %ebp
c01029e0:	89 e5                	mov    %esp,%ebp
c01029e2:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
c01029e5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01029e9:	75 24                	jne    c0102a0f <default_init_memmap+0x30>
c01029eb:	c7 44 24 0c 50 68 10 	movl   $0xc0106850,0xc(%esp)
c01029f2:	c0 
c01029f3:	c7 44 24 08 56 68 10 	movl   $0xc0106856,0x8(%esp)
c01029fa:	c0 
c01029fb:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c0102a02:	00 
c0102a03:	c7 04 24 6b 68 10 c0 	movl   $0xc010686b,(%esp)
c0102a0a:	e8 cc e2 ff ff       	call   c0100cdb <__panic>
    struct Page *p = base;
c0102a0f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a12:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0102a15:	e9 97 00 00 00       	jmp    c0102ab1 <default_init_memmap+0xd2>
        assert(PageReserved(p));
c0102a1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a1d:	83 c0 04             	add    $0x4,%eax
c0102a20:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0102a27:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102a2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102a2d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0102a30:	0f a3 10             	bt     %edx,(%eax)
c0102a33:	19 c0                	sbb    %eax,%eax
c0102a35:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c0102a38:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0102a3c:	0f 95 c0             	setne  %al
c0102a3f:	0f b6 c0             	movzbl %al,%eax
c0102a42:	85 c0                	test   %eax,%eax
c0102a44:	75 24                	jne    c0102a6a <default_init_memmap+0x8b>
c0102a46:	c7 44 24 0c 81 68 10 	movl   $0xc0106881,0xc(%esp)
c0102a4d:	c0 
c0102a4e:	c7 44 24 08 56 68 10 	movl   $0xc0106856,0x8(%esp)
c0102a55:	c0 
c0102a56:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c0102a5d:	00 
c0102a5e:	c7 04 24 6b 68 10 c0 	movl   $0xc010686b,(%esp)
c0102a65:	e8 71 e2 ff ff       	call   c0100cdb <__panic>
        p->flags = p->property = 0;
c0102a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a6d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c0102a74:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a77:	8b 50 08             	mov    0x8(%eax),%edx
c0102a7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a7d:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
c0102a80:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102a87:	00 
c0102a88:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a8b:	89 04 24             	mov    %eax,(%esp)
c0102a8e:	e8 0d ff ff ff       	call   c01029a0 <set_page_ref>
        SetPageProperty(p);
c0102a93:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a96:	83 c0 04             	add    $0x4,%eax
c0102a99:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c0102aa0:	89 45 e0             	mov    %eax,-0x20(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102aa3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102aa6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102aa9:	0f ab 10             	bts    %edx,(%eax)
}
c0102aac:	90                   	nop
    for (; p != base + n; p ++) {
c0102aad:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0102ab1:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102ab4:	89 d0                	mov    %edx,%eax
c0102ab6:	c1 e0 02             	shl    $0x2,%eax
c0102ab9:	01 d0                	add    %edx,%eax
c0102abb:	c1 e0 02             	shl    $0x2,%eax
c0102abe:	89 c2                	mov    %eax,%edx
c0102ac0:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ac3:	01 d0                	add    %edx,%eax
c0102ac5:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0102ac8:	0f 85 4c ff ff ff    	jne    c0102a1a <default_init_memmap+0x3b>
    }
    base->property = n;
c0102ace:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ad1:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102ad4:	89 50 08             	mov    %edx,0x8(%eax)
    //SetPageProperty(base);
    nr_free += n;
c0102ad7:	8b 15 88 ce 11 c0    	mov    0xc011ce88,%edx
c0102add:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102ae0:	01 d0                	add    %edx,%eax
c0102ae2:	a3 88 ce 11 c0       	mov    %eax,0xc011ce88
    list_add(&free_list, &(base->page_link));
c0102ae7:	8b 45 08             	mov    0x8(%ebp),%eax
c0102aea:	83 c0 0c             	add    $0xc,%eax
c0102aed:	c7 45 dc 80 ce 11 c0 	movl   $0xc011ce80,-0x24(%ebp)
c0102af4:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0102af7:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102afa:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0102afd:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102b00:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0102b03:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102b06:	8b 40 04             	mov    0x4(%eax),%eax
c0102b09:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102b0c:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0102b0f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102b12:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0102b15:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102b18:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102b1b:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102b1e:	89 10                	mov    %edx,(%eax)
c0102b20:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102b23:	8b 10                	mov    (%eax),%edx
c0102b25:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102b28:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102b2b:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102b2e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102b31:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102b34:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102b37:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0102b3a:	89 10                	mov    %edx,(%eax)
}
c0102b3c:	90                   	nop
}
c0102b3d:	90                   	nop
}
c0102b3e:	90                   	nop
}
c0102b3f:	90                   	nop
c0102b40:	89 ec                	mov    %ebp,%esp
c0102b42:	5d                   	pop    %ebp
c0102b43:	c3                   	ret    

c0102b44 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c0102b44:	55                   	push   %ebp
c0102b45:	89 e5                	mov    %esp,%ebp
c0102b47:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c0102b4a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102b4e:	75 24                	jne    c0102b74 <default_alloc_pages+0x30>
c0102b50:	c7 44 24 0c 50 68 10 	movl   $0xc0106850,0xc(%esp)
c0102b57:	c0 
c0102b58:	c7 44 24 08 56 68 10 	movl   $0xc0106856,0x8(%esp)
c0102b5f:	c0 
c0102b60:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
c0102b67:	00 
c0102b68:	c7 04 24 6b 68 10 c0 	movl   $0xc010686b,(%esp)
c0102b6f:	e8 67 e1 ff ff       	call   c0100cdb <__panic>
    if (n > nr_free) {
c0102b74:	a1 88 ce 11 c0       	mov    0xc011ce88,%eax
c0102b79:	39 45 08             	cmp    %eax,0x8(%ebp)
c0102b7c:	76 0a                	jbe    c0102b88 <default_alloc_pages+0x44>
        return NULL;
c0102b7e:	b8 00 00 00 00       	mov    $0x0,%eax
c0102b83:	e9 5b 01 00 00       	jmp    c0102ce3 <default_alloc_pages+0x19f>
    }
    struct Page *page = NULL;
c0102b88:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c0102b8f:	c7 45 f0 80 ce 11 c0 	movl   $0xc011ce80,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0102b96:	eb 1c                	jmp    c0102bb4 <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
c0102b98:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102b9b:	83 e8 0c             	sub    $0xc,%eax
c0102b9e:	89 45 e8             	mov    %eax,-0x18(%ebp)
        if (p->property >= n) {
c0102ba1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102ba4:	8b 40 08             	mov    0x8(%eax),%eax
c0102ba7:	39 45 08             	cmp    %eax,0x8(%ebp)
c0102baa:	77 08                	ja     c0102bb4 <default_alloc_pages+0x70>
            page = p;
c0102bac:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102baf:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c0102bb2:	eb 18                	jmp    c0102bcc <default_alloc_pages+0x88>
c0102bb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102bb7:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return listelm->next;
c0102bba:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102bbd:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c0102bc0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102bc3:	81 7d f0 80 ce 11 c0 	cmpl   $0xc011ce80,-0x10(%ebp)
c0102bca:	75 cc                	jne    c0102b98 <default_alloc_pages+0x54>
        }
    }
    if (page != NULL) { // 如果寻找到了满足条件的空闲内存块
c0102bcc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102bd0:	0f 84 0a 01 00 00    	je     c0102ce0 <default_alloc_pages+0x19c>
            p->property = page->property - n;
            list_add(&free_list, &(p->page_link));
    }
        nr_free -= n;
        ClearPageProperty(page);*/
        for (struct Page *p = page; p != (page + n); ++p) 
c0102bd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102bd9:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0102bdc:	eb 1e                	jmp    c0102bfc <default_alloc_pages+0xb8>
        {
            ClearPageProperty(p); // 将分配出去的内存页标记为非空闲
c0102bde:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102be1:	83 c0 04             	add    $0x4,%eax
c0102be4:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
c0102beb:	89 45 d8             	mov    %eax,-0x28(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102bee:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102bf1:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102bf4:	0f b3 10             	btr    %edx,(%eax)
}
c0102bf7:	90                   	nop
        for (struct Page *p = page; p != (page + n); ++p) 
c0102bf8:	83 45 ec 14          	addl   $0x14,-0x14(%ebp)
c0102bfc:	8b 55 08             	mov    0x8(%ebp),%edx
c0102bff:	89 d0                	mov    %edx,%eax
c0102c01:	c1 e0 02             	shl    $0x2,%eax
c0102c04:	01 d0                	add    %edx,%eax
c0102c06:	c1 e0 02             	shl    $0x2,%eax
c0102c09:	89 c2                	mov    %eax,%edx
c0102c0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c0e:	01 d0                	add    %edx,%eax
c0102c10:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0102c13:	75 c9                	jne    c0102bde <default_alloc_pages+0x9a>
        }
        if (page->property > n) { // 如果原先找到的空闲块大小大于需要的分配内存大小，进行分裂
c0102c15:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c18:	8b 40 08             	mov    0x8(%eax),%eax
c0102c1b:	39 45 08             	cmp    %eax,0x8(%ebp)
c0102c1e:	0f 83 82 00 00 00    	jae    c0102ca6 <default_alloc_pages+0x162>
            struct Page *p = page + n; // 获得分裂出来的新的小空闲块的第一个页的描述信息
c0102c24:	8b 55 08             	mov    0x8(%ebp),%edx
c0102c27:	89 d0                	mov    %edx,%eax
c0102c29:	c1 e0 02             	shl    $0x2,%eax
c0102c2c:	01 d0                	add    %edx,%eax
c0102c2e:	c1 e0 02             	shl    $0x2,%eax
c0102c31:	89 c2                	mov    %eax,%edx
c0102c33:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c36:	01 d0                	add    %edx,%eax
c0102c38:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            p->property = page->property - n; // 更新新的空闲块的大小信息
c0102c3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c3e:	8b 40 08             	mov    0x8(%eax),%eax
c0102c41:	2b 45 08             	sub    0x8(%ebp),%eax
c0102c44:	89 c2                	mov    %eax,%edx
c0102c46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102c49:	89 50 08             	mov    %edx,0x8(%eax)
            list_add(&(page->page_link), &(p->page_link)); // 将新空闲块插入空闲块列表中
c0102c4c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102c4f:	83 c0 0c             	add    $0xc,%eax
c0102c52:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0102c55:	83 c2 0c             	add    $0xc,%edx
c0102c58:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0102c5b:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102c5e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102c61:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0102c64:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102c67:	89 45 c8             	mov    %eax,-0x38(%ebp)
    __list_add(elm, listelm, listelm->next);
c0102c6a:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102c6d:	8b 40 04             	mov    0x4(%eax),%eax
c0102c70:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0102c73:	89 55 c4             	mov    %edx,-0x3c(%ebp)
c0102c76:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102c79:	89 55 c0             	mov    %edx,-0x40(%ebp)
c0102c7c:	89 45 bc             	mov    %eax,-0x44(%ebp)
    prev->next = next->prev = elm;
c0102c7f:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102c82:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102c85:	89 10                	mov    %edx,(%eax)
c0102c87:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102c8a:	8b 10                	mov    (%eax),%edx
c0102c8c:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102c8f:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102c92:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102c95:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102c98:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102c9b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102c9e:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0102ca1:	89 10                	mov    %edx,(%eax)
}
c0102ca3:	90                   	nop
}
c0102ca4:	90                   	nop
}
c0102ca5:	90                   	nop
        }
        list_del(&(page->page_link)); // 删除空闲链表中的原先的空闲块
c0102ca6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ca9:	83 c0 0c             	add    $0xc,%eax
c0102cac:	89 45 b8             	mov    %eax,-0x48(%ebp)
    __list_del(listelm->prev, listelm->next);
c0102caf:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102cb2:	8b 40 04             	mov    0x4(%eax),%eax
c0102cb5:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0102cb8:	8b 12                	mov    (%edx),%edx
c0102cba:	89 55 b4             	mov    %edx,-0x4c(%ebp)
c0102cbd:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102cc0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102cc3:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0102cc6:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102cc9:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102ccc:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0102ccf:	89 10                	mov    %edx,(%eax)
}
c0102cd1:	90                   	nop
}
c0102cd2:	90                   	nop
        nr_free -= n; // 更新总空闲物理页的数量
c0102cd3:	a1 88 ce 11 c0       	mov    0xc011ce88,%eax
c0102cd8:	2b 45 08             	sub    0x8(%ebp),%eax
c0102cdb:	a3 88 ce 11 c0       	mov    %eax,0xc011ce88
    }
    return page;
c0102ce0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0102ce3:	89 ec                	mov    %ebp,%esp
c0102ce5:	5d                   	pop    %ebp
c0102ce6:	c3                   	ret    

c0102ce7 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0102ce7:	55                   	push   %ebp
c0102ce8:	89 e5                	mov    %esp,%ebp
c0102cea:	81 ec 98 00 00 00    	sub    $0x98,%esp
    assert(n > 0);
c0102cf0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102cf4:	75 24                	jne    c0102d1a <default_free_pages+0x33>
c0102cf6:	c7 44 24 0c 50 68 10 	movl   $0xc0106850,0xc(%esp)
c0102cfd:	c0 
c0102cfe:	c7 44 24 08 56 68 10 	movl   $0xc0106856,0x8(%esp)
c0102d05:	c0 
c0102d06:	c7 44 24 04 a4 00 00 	movl   $0xa4,0x4(%esp)
c0102d0d:	00 
c0102d0e:	c7 04 24 6b 68 10 c0 	movl   $0xc010686b,(%esp)
c0102d15:	e8 c1 df ff ff       	call   c0100cdb <__panic>
    struct Page *p = base;
c0102d1a:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0102d20:	e9 ad 00 00 00       	jmp    c0102dd2 <default_free_pages+0xeb>
        assert(!PageReserved(p) && !PageProperty(p));
c0102d25:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d28:	83 c0 04             	add    $0x4,%eax
c0102d2b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0102d32:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102d35:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102d38:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0102d3b:	0f a3 10             	bt     %edx,(%eax)
c0102d3e:	19 c0                	sbb    %eax,%eax
c0102d40:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c0102d43:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0102d47:	0f 95 c0             	setne  %al
c0102d4a:	0f b6 c0             	movzbl %al,%eax
c0102d4d:	85 c0                	test   %eax,%eax
c0102d4f:	75 2c                	jne    c0102d7d <default_free_pages+0x96>
c0102d51:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d54:	83 c0 04             	add    $0x4,%eax
c0102d57:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c0102d5e:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102d61:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102d64:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0102d67:	0f a3 10             	bt     %edx,(%eax)
c0102d6a:	19 c0                	sbb    %eax,%eax
c0102d6c:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
c0102d6f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0102d73:	0f 95 c0             	setne  %al
c0102d76:	0f b6 c0             	movzbl %al,%eax
c0102d79:	85 c0                	test   %eax,%eax
c0102d7b:	74 24                	je     c0102da1 <default_free_pages+0xba>
c0102d7d:	c7 44 24 0c 94 68 10 	movl   $0xc0106894,0xc(%esp)
c0102d84:	c0 
c0102d85:	c7 44 24 08 56 68 10 	movl   $0xc0106856,0x8(%esp)
c0102d8c:	c0 
c0102d8d:	c7 44 24 04 a7 00 00 	movl   $0xa7,0x4(%esp)
c0102d94:	00 
c0102d95:	c7 04 24 6b 68 10 c0 	movl   $0xc010686b,(%esp)
c0102d9c:	e8 3a df ff ff       	call   c0100cdb <__panic>
        //p->flags = 0;
        SetPageProperty(p);
c0102da1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102da4:	83 c0 04             	add    $0x4,%eax
c0102da7:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c0102dae:	89 45 d0             	mov    %eax,-0x30(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102db1:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102db4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102db7:	0f ab 10             	bts    %edx,(%eax)
}
c0102dba:	90                   	nop
        set_page_ref(p, 0);
c0102dbb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102dc2:	00 
c0102dc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102dc6:	89 04 24             	mov    %eax,(%esp)
c0102dc9:	e8 d2 fb ff ff       	call   c01029a0 <set_page_ref>
    for (; p != base + n; p ++) {
c0102dce:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0102dd2:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102dd5:	89 d0                	mov    %edx,%eax
c0102dd7:	c1 e0 02             	shl    $0x2,%eax
c0102dda:	01 d0                	add    %edx,%eax
c0102ddc:	c1 e0 02             	shl    $0x2,%eax
c0102ddf:	89 c2                	mov    %eax,%edx
c0102de1:	8b 45 08             	mov    0x8(%ebp),%eax
c0102de4:	01 d0                	add    %edx,%eax
c0102de6:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0102de9:	0f 85 36 ff ff ff    	jne    c0102d25 <default_free_pages+0x3e>
    }
    base->property = n;
c0102def:	8b 45 08             	mov    0x8(%ebp),%eax
c0102df2:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102df5:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0102df8:	8b 45 08             	mov    0x8(%ebp),%eax
c0102dfb:	83 c0 04             	add    $0x4,%eax
c0102dfe:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
c0102e05:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102e08:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102e0b:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0102e0e:	0f ab 10             	bts    %edx,(%eax)
}
c0102e11:	90                   	nop
c0102e12:	c7 45 cc 80 ce 11 c0 	movl   $0xc011ce80,-0x34(%ebp)
    return listelm->next;
c0102e19:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102e1c:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
c0102e1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0102e22:	e9 0e 01 00 00       	jmp    c0102f35 <default_free_pages+0x24e>
        p = le2page(le, page_link);
c0102e27:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102e2a:	83 e8 0c             	sub    $0xc,%eax
c0102e2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102e30:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102e33:	89 45 c0             	mov    %eax,-0x40(%ebp)
c0102e36:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102e39:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c0102e3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (base + base->property == p) {
c0102e3f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e42:	8b 50 08             	mov    0x8(%eax),%edx
c0102e45:	89 d0                	mov    %edx,%eax
c0102e47:	c1 e0 02             	shl    $0x2,%eax
c0102e4a:	01 d0                	add    %edx,%eax
c0102e4c:	c1 e0 02             	shl    $0x2,%eax
c0102e4f:	89 c2                	mov    %eax,%edx
c0102e51:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e54:	01 d0                	add    %edx,%eax
c0102e56:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0102e59:	75 5d                	jne    c0102eb8 <default_free_pages+0x1d1>
            base->property += p->property;
c0102e5b:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e5e:	8b 50 08             	mov    0x8(%eax),%edx
c0102e61:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e64:	8b 40 08             	mov    0x8(%eax),%eax
c0102e67:	01 c2                	add    %eax,%edx
c0102e69:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e6c:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
c0102e6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e72:	83 c0 04             	add    $0x4,%eax
c0102e75:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
c0102e7c:	89 45 ac             	mov    %eax,-0x54(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102e7f:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0102e82:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0102e85:	0f b3 10             	btr    %edx,(%eax)
}
c0102e88:	90                   	nop
            list_del(&(p->page_link));
c0102e89:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e8c:	83 c0 0c             	add    $0xc,%eax
c0102e8f:	89 45 bc             	mov    %eax,-0x44(%ebp)
    __list_del(listelm->prev, listelm->next);
c0102e92:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102e95:	8b 40 04             	mov    0x4(%eax),%eax
c0102e98:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102e9b:	8b 12                	mov    (%edx),%edx
c0102e9d:	89 55 b8             	mov    %edx,-0x48(%ebp)
c0102ea0:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    prev->next = next;
c0102ea3:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102ea6:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0102ea9:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102eac:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102eaf:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0102eb2:	89 10                	mov    %edx,(%eax)
}
c0102eb4:	90                   	nop
}
c0102eb5:	90                   	nop
c0102eb6:	eb 7d                	jmp    c0102f35 <default_free_pages+0x24e>
        }
        else if (p + p->property == base) {
c0102eb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ebb:	8b 50 08             	mov    0x8(%eax),%edx
c0102ebe:	89 d0                	mov    %edx,%eax
c0102ec0:	c1 e0 02             	shl    $0x2,%eax
c0102ec3:	01 d0                	add    %edx,%eax
c0102ec5:	c1 e0 02             	shl    $0x2,%eax
c0102ec8:	89 c2                	mov    %eax,%edx
c0102eca:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ecd:	01 d0                	add    %edx,%eax
c0102ecf:	39 45 08             	cmp    %eax,0x8(%ebp)
c0102ed2:	75 61                	jne    c0102f35 <default_free_pages+0x24e>
            p->property += base->property;
c0102ed4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ed7:	8b 50 08             	mov    0x8(%eax),%edx
c0102eda:	8b 45 08             	mov    0x8(%ebp),%eax
c0102edd:	8b 40 08             	mov    0x8(%eax),%eax
c0102ee0:	01 c2                	add    %eax,%edx
c0102ee2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ee5:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
c0102ee8:	8b 45 08             	mov    0x8(%ebp),%eax
c0102eeb:	83 c0 04             	add    $0x4,%eax
c0102eee:	c7 45 9c 01 00 00 00 	movl   $0x1,-0x64(%ebp)
c0102ef5:	89 45 98             	mov    %eax,-0x68(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102ef8:	8b 45 98             	mov    -0x68(%ebp),%eax
c0102efb:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0102efe:	0f b3 10             	btr    %edx,(%eax)
}
c0102f01:	90                   	nop
            base = p;
c0102f02:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f05:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
c0102f08:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f0b:	83 c0 0c             	add    $0xc,%eax
c0102f0e:	89 45 a8             	mov    %eax,-0x58(%ebp)
    __list_del(listelm->prev, listelm->next);
c0102f11:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0102f14:	8b 40 04             	mov    0x4(%eax),%eax
c0102f17:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0102f1a:	8b 12                	mov    (%edx),%edx
c0102f1c:	89 55 a4             	mov    %edx,-0x5c(%ebp)
c0102f1f:	89 45 a0             	mov    %eax,-0x60(%ebp)
    prev->next = next;
c0102f22:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0102f25:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0102f28:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102f2b:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0102f2e:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0102f31:	89 10                	mov    %edx,(%eax)
}
c0102f33:	90                   	nop
}
c0102f34:	90                   	nop
    while (le != &free_list) {
c0102f35:	81 7d f0 80 ce 11 c0 	cmpl   $0xc011ce80,-0x10(%ebp)
c0102f3c:	0f 85 e5 fe ff ff    	jne    c0102e27 <default_free_pages+0x140>
        }
    }
    nr_free += n;
c0102f42:	8b 15 88 ce 11 c0    	mov    0xc011ce88,%edx
c0102f48:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102f4b:	01 d0                	add    %edx,%eax
c0102f4d:	a3 88 ce 11 c0       	mov    %eax,0xc011ce88
c0102f52:	c7 45 94 80 ce 11 c0 	movl   $0xc011ce80,-0x6c(%ebp)
    return listelm->next;
c0102f59:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0102f5c:	8b 40 04             	mov    0x4(%eax),%eax
    le = list_next(&free_list);
c0102f5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    // 迭代空闲链表中的每一个节点
    while (le != &free_list) {
c0102f62:	eb 74                	jmp    c0102fd8 <default_free_pages+0x2f1>
        // 转为Page结构
        p = le2page(le, page_link);
c0102f64:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102f67:	83 e8 0c             	sub    $0xc,%eax
c0102f6a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (base + base->property <= p) {
c0102f6d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f70:	8b 50 08             	mov    0x8(%eax),%edx
c0102f73:	89 d0                	mov    %edx,%eax
c0102f75:	c1 e0 02             	shl    $0x2,%eax
c0102f78:	01 d0                	add    %edx,%eax
c0102f7a:	c1 e0 02             	shl    $0x2,%eax
c0102f7d:	89 c2                	mov    %eax,%edx
c0102f7f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f82:	01 d0                	add    %edx,%eax
c0102f84:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0102f87:	72 40                	jb     c0102fc9 <default_free_pages+0x2e2>
            // 进行空闲链表结构的校验，不能存在交叉覆盖的地方
            assert(base + base->property != p);
c0102f89:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f8c:	8b 50 08             	mov    0x8(%eax),%edx
c0102f8f:	89 d0                	mov    %edx,%eax
c0102f91:	c1 e0 02             	shl    $0x2,%eax
c0102f94:	01 d0                	add    %edx,%eax
c0102f96:	c1 e0 02             	shl    $0x2,%eax
c0102f99:	89 c2                	mov    %eax,%edx
c0102f9b:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f9e:	01 d0                	add    %edx,%eax
c0102fa0:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0102fa3:	75 3e                	jne    c0102fe3 <default_free_pages+0x2fc>
c0102fa5:	c7 44 24 0c b9 68 10 	movl   $0xc01068b9,0xc(%esp)
c0102fac:	c0 
c0102fad:	c7 44 24 08 56 68 10 	movl   $0xc0106856,0x8(%esp)
c0102fb4:	c0 
c0102fb5:	c7 44 24 04 c6 00 00 	movl   $0xc6,0x4(%esp)
c0102fbc:	00 
c0102fbd:	c7 04 24 6b 68 10 c0 	movl   $0xc010686b,(%esp)
c0102fc4:	e8 12 dd ff ff       	call   c0100cdb <__panic>
c0102fc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102fcc:	89 45 90             	mov    %eax,-0x70(%ebp)
c0102fcf:	8b 45 90             	mov    -0x70(%ebp),%eax
c0102fd2:	8b 40 04             	mov    0x4(%eax),%eax
            break;
        }
        le = list_next(le);
c0102fd5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0102fd8:	81 7d f0 80 ce 11 c0 	cmpl   $0xc011ce80,-0x10(%ebp)
c0102fdf:	75 83                	jne    c0102f64 <default_free_pages+0x27d>
c0102fe1:	eb 01                	jmp    c0102fe4 <default_free_pages+0x2fd>
            break;
c0102fe3:	90                   	nop
    }
    // 将base加入到空闲链表之中
    list_add_before(le, &(base->page_link));
c0102fe4:	8b 45 08             	mov    0x8(%ebp),%eax
c0102fe7:	8d 50 0c             	lea    0xc(%eax),%edx
c0102fea:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102fed:	89 45 8c             	mov    %eax,-0x74(%ebp)
c0102ff0:	89 55 88             	mov    %edx,-0x78(%ebp)
    __list_add(elm, listelm->prev, listelm);
c0102ff3:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0102ff6:	8b 00                	mov    (%eax),%eax
c0102ff8:	8b 55 88             	mov    -0x78(%ebp),%edx
c0102ffb:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0102ffe:	89 45 80             	mov    %eax,-0x80(%ebp)
c0103001:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0103004:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
    prev->next = next->prev = elm;
c010300a:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0103010:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0103013:	89 10                	mov    %edx,(%eax)
c0103015:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c010301b:	8b 10                	mov    (%eax),%edx
c010301d:	8b 45 80             	mov    -0x80(%ebp),%eax
c0103020:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0103023:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0103026:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
c010302c:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c010302f:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0103032:	8b 55 80             	mov    -0x80(%ebp),%edx
c0103035:	89 10                	mov    %edx,(%eax)
}
c0103037:	90                   	nop
}
c0103038:	90                   	nop
}
c0103039:	90                   	nop
c010303a:	89 ec                	mov    %ebp,%esp
c010303c:	5d                   	pop    %ebp
c010303d:	c3                   	ret    

c010303e <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c010303e:	55                   	push   %ebp
c010303f:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0103041:	a1 88 ce 11 c0       	mov    0xc011ce88,%eax
}
c0103046:	5d                   	pop    %ebp
c0103047:	c3                   	ret    

c0103048 <basic_check>:

static void
basic_check(void) {
c0103048:	55                   	push   %ebp
c0103049:	89 e5                	mov    %esp,%ebp
c010304b:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c010304e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103055:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103058:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010305b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010305e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0103061:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103068:	e8 ed 0e 00 00       	call   c0103f5a <alloc_pages>
c010306d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103070:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103074:	75 24                	jne    c010309a <basic_check+0x52>
c0103076:	c7 44 24 0c d4 68 10 	movl   $0xc01068d4,0xc(%esp)
c010307d:	c0 
c010307e:	c7 44 24 08 56 68 10 	movl   $0xc0106856,0x8(%esp)
c0103085:	c0 
c0103086:	c7 44 24 04 d8 00 00 	movl   $0xd8,0x4(%esp)
c010308d:	00 
c010308e:	c7 04 24 6b 68 10 c0 	movl   $0xc010686b,(%esp)
c0103095:	e8 41 dc ff ff       	call   c0100cdb <__panic>
    assert((p1 = alloc_page()) != NULL);
c010309a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01030a1:	e8 b4 0e 00 00       	call   c0103f5a <alloc_pages>
c01030a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01030a9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01030ad:	75 24                	jne    c01030d3 <basic_check+0x8b>
c01030af:	c7 44 24 0c f0 68 10 	movl   $0xc01068f0,0xc(%esp)
c01030b6:	c0 
c01030b7:	c7 44 24 08 56 68 10 	movl   $0xc0106856,0x8(%esp)
c01030be:	c0 
c01030bf:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
c01030c6:	00 
c01030c7:	c7 04 24 6b 68 10 c0 	movl   $0xc010686b,(%esp)
c01030ce:	e8 08 dc ff ff       	call   c0100cdb <__panic>
    assert((p2 = alloc_page()) != NULL);
c01030d3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01030da:	e8 7b 0e 00 00       	call   c0103f5a <alloc_pages>
c01030df:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01030e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01030e6:	75 24                	jne    c010310c <basic_check+0xc4>
c01030e8:	c7 44 24 0c 0c 69 10 	movl   $0xc010690c,0xc(%esp)
c01030ef:	c0 
c01030f0:	c7 44 24 08 56 68 10 	movl   $0xc0106856,0x8(%esp)
c01030f7:	c0 
c01030f8:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
c01030ff:	00 
c0103100:	c7 04 24 6b 68 10 c0 	movl   $0xc010686b,(%esp)
c0103107:	e8 cf db ff ff       	call   c0100cdb <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c010310c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010310f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0103112:	74 10                	je     c0103124 <basic_check+0xdc>
c0103114:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103117:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010311a:	74 08                	je     c0103124 <basic_check+0xdc>
c010311c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010311f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103122:	75 24                	jne    c0103148 <basic_check+0x100>
c0103124:	c7 44 24 0c 28 69 10 	movl   $0xc0106928,0xc(%esp)
c010312b:	c0 
c010312c:	c7 44 24 08 56 68 10 	movl   $0xc0106856,0x8(%esp)
c0103133:	c0 
c0103134:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c010313b:	00 
c010313c:	c7 04 24 6b 68 10 c0 	movl   $0xc010686b,(%esp)
c0103143:	e8 93 db ff ff       	call   c0100cdb <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0103148:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010314b:	89 04 24             	mov    %eax,(%esp)
c010314e:	e8 43 f8 ff ff       	call   c0102996 <page_ref>
c0103153:	85 c0                	test   %eax,%eax
c0103155:	75 1e                	jne    c0103175 <basic_check+0x12d>
c0103157:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010315a:	89 04 24             	mov    %eax,(%esp)
c010315d:	e8 34 f8 ff ff       	call   c0102996 <page_ref>
c0103162:	85 c0                	test   %eax,%eax
c0103164:	75 0f                	jne    c0103175 <basic_check+0x12d>
c0103166:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103169:	89 04 24             	mov    %eax,(%esp)
c010316c:	e8 25 f8 ff ff       	call   c0102996 <page_ref>
c0103171:	85 c0                	test   %eax,%eax
c0103173:	74 24                	je     c0103199 <basic_check+0x151>
c0103175:	c7 44 24 0c 4c 69 10 	movl   $0xc010694c,0xc(%esp)
c010317c:	c0 
c010317d:	c7 44 24 08 56 68 10 	movl   $0xc0106856,0x8(%esp)
c0103184:	c0 
c0103185:	c7 44 24 04 dd 00 00 	movl   $0xdd,0x4(%esp)
c010318c:	00 
c010318d:	c7 04 24 6b 68 10 c0 	movl   $0xc010686b,(%esp)
c0103194:	e8 42 db ff ff       	call   c0100cdb <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0103199:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010319c:	89 04 24             	mov    %eax,(%esp)
c010319f:	e8 da f7 ff ff       	call   c010297e <page2pa>
c01031a4:	8b 15 a4 ce 11 c0    	mov    0xc011cea4,%edx
c01031aa:	c1 e2 0c             	shl    $0xc,%edx
c01031ad:	39 d0                	cmp    %edx,%eax
c01031af:	72 24                	jb     c01031d5 <basic_check+0x18d>
c01031b1:	c7 44 24 0c 88 69 10 	movl   $0xc0106988,0xc(%esp)
c01031b8:	c0 
c01031b9:	c7 44 24 08 56 68 10 	movl   $0xc0106856,0x8(%esp)
c01031c0:	c0 
c01031c1:	c7 44 24 04 df 00 00 	movl   $0xdf,0x4(%esp)
c01031c8:	00 
c01031c9:	c7 04 24 6b 68 10 c0 	movl   $0xc010686b,(%esp)
c01031d0:	e8 06 db ff ff       	call   c0100cdb <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c01031d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01031d8:	89 04 24             	mov    %eax,(%esp)
c01031db:	e8 9e f7 ff ff       	call   c010297e <page2pa>
c01031e0:	8b 15 a4 ce 11 c0    	mov    0xc011cea4,%edx
c01031e6:	c1 e2 0c             	shl    $0xc,%edx
c01031e9:	39 d0                	cmp    %edx,%eax
c01031eb:	72 24                	jb     c0103211 <basic_check+0x1c9>
c01031ed:	c7 44 24 0c a5 69 10 	movl   $0xc01069a5,0xc(%esp)
c01031f4:	c0 
c01031f5:	c7 44 24 08 56 68 10 	movl   $0xc0106856,0x8(%esp)
c01031fc:	c0 
c01031fd:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
c0103204:	00 
c0103205:	c7 04 24 6b 68 10 c0 	movl   $0xc010686b,(%esp)
c010320c:	e8 ca da ff ff       	call   c0100cdb <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0103211:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103214:	89 04 24             	mov    %eax,(%esp)
c0103217:	e8 62 f7 ff ff       	call   c010297e <page2pa>
c010321c:	8b 15 a4 ce 11 c0    	mov    0xc011cea4,%edx
c0103222:	c1 e2 0c             	shl    $0xc,%edx
c0103225:	39 d0                	cmp    %edx,%eax
c0103227:	72 24                	jb     c010324d <basic_check+0x205>
c0103229:	c7 44 24 0c c2 69 10 	movl   $0xc01069c2,0xc(%esp)
c0103230:	c0 
c0103231:	c7 44 24 08 56 68 10 	movl   $0xc0106856,0x8(%esp)
c0103238:	c0 
c0103239:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
c0103240:	00 
c0103241:	c7 04 24 6b 68 10 c0 	movl   $0xc010686b,(%esp)
c0103248:	e8 8e da ff ff       	call   c0100cdb <__panic>

    list_entry_t free_list_store = free_list;
c010324d:	a1 80 ce 11 c0       	mov    0xc011ce80,%eax
c0103252:	8b 15 84 ce 11 c0    	mov    0xc011ce84,%edx
c0103258:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010325b:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010325e:	c7 45 dc 80 ce 11 c0 	movl   $0xc011ce80,-0x24(%ebp)
    elm->prev = elm->next = elm;
c0103265:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103268:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010326b:	89 50 04             	mov    %edx,0x4(%eax)
c010326e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103271:	8b 50 04             	mov    0x4(%eax),%edx
c0103274:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103277:	89 10                	mov    %edx,(%eax)
}
c0103279:	90                   	nop
c010327a:	c7 45 e0 80 ce 11 c0 	movl   $0xc011ce80,-0x20(%ebp)
    return list->next == list;
c0103281:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103284:	8b 40 04             	mov    0x4(%eax),%eax
c0103287:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c010328a:	0f 94 c0             	sete   %al
c010328d:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103290:	85 c0                	test   %eax,%eax
c0103292:	75 24                	jne    c01032b8 <basic_check+0x270>
c0103294:	c7 44 24 0c df 69 10 	movl   $0xc01069df,0xc(%esp)
c010329b:	c0 
c010329c:	c7 44 24 08 56 68 10 	movl   $0xc0106856,0x8(%esp)
c01032a3:	c0 
c01032a4:	c7 44 24 04 e5 00 00 	movl   $0xe5,0x4(%esp)
c01032ab:	00 
c01032ac:	c7 04 24 6b 68 10 c0 	movl   $0xc010686b,(%esp)
c01032b3:	e8 23 da ff ff       	call   c0100cdb <__panic>

    unsigned int nr_free_store = nr_free;
c01032b8:	a1 88 ce 11 c0       	mov    0xc011ce88,%eax
c01032bd:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c01032c0:	c7 05 88 ce 11 c0 00 	movl   $0x0,0xc011ce88
c01032c7:	00 00 00 

    assert(alloc_page() == NULL);
c01032ca:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01032d1:	e8 84 0c 00 00       	call   c0103f5a <alloc_pages>
c01032d6:	85 c0                	test   %eax,%eax
c01032d8:	74 24                	je     c01032fe <basic_check+0x2b6>
c01032da:	c7 44 24 0c f6 69 10 	movl   $0xc01069f6,0xc(%esp)
c01032e1:	c0 
c01032e2:	c7 44 24 08 56 68 10 	movl   $0xc0106856,0x8(%esp)
c01032e9:	c0 
c01032ea:	c7 44 24 04 ea 00 00 	movl   $0xea,0x4(%esp)
c01032f1:	00 
c01032f2:	c7 04 24 6b 68 10 c0 	movl   $0xc010686b,(%esp)
c01032f9:	e8 dd d9 ff ff       	call   c0100cdb <__panic>

    free_page(p0);
c01032fe:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103305:	00 
c0103306:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103309:	89 04 24             	mov    %eax,(%esp)
c010330c:	e8 83 0c 00 00       	call   c0103f94 <free_pages>
    free_page(p1);
c0103311:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103318:	00 
c0103319:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010331c:	89 04 24             	mov    %eax,(%esp)
c010331f:	e8 70 0c 00 00       	call   c0103f94 <free_pages>
    free_page(p2);
c0103324:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010332b:	00 
c010332c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010332f:	89 04 24             	mov    %eax,(%esp)
c0103332:	e8 5d 0c 00 00       	call   c0103f94 <free_pages>
    assert(nr_free == 3);
c0103337:	a1 88 ce 11 c0       	mov    0xc011ce88,%eax
c010333c:	83 f8 03             	cmp    $0x3,%eax
c010333f:	74 24                	je     c0103365 <basic_check+0x31d>
c0103341:	c7 44 24 0c 0b 6a 10 	movl   $0xc0106a0b,0xc(%esp)
c0103348:	c0 
c0103349:	c7 44 24 08 56 68 10 	movl   $0xc0106856,0x8(%esp)
c0103350:	c0 
c0103351:	c7 44 24 04 ef 00 00 	movl   $0xef,0x4(%esp)
c0103358:	00 
c0103359:	c7 04 24 6b 68 10 c0 	movl   $0xc010686b,(%esp)
c0103360:	e8 76 d9 ff ff       	call   c0100cdb <__panic>

    assert((p0 = alloc_page()) != NULL);
c0103365:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010336c:	e8 e9 0b 00 00       	call   c0103f5a <alloc_pages>
c0103371:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103374:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103378:	75 24                	jne    c010339e <basic_check+0x356>
c010337a:	c7 44 24 0c d4 68 10 	movl   $0xc01068d4,0xc(%esp)
c0103381:	c0 
c0103382:	c7 44 24 08 56 68 10 	movl   $0xc0106856,0x8(%esp)
c0103389:	c0 
c010338a:	c7 44 24 04 f1 00 00 	movl   $0xf1,0x4(%esp)
c0103391:	00 
c0103392:	c7 04 24 6b 68 10 c0 	movl   $0xc010686b,(%esp)
c0103399:	e8 3d d9 ff ff       	call   c0100cdb <__panic>
    assert((p1 = alloc_page()) != NULL);
c010339e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01033a5:	e8 b0 0b 00 00       	call   c0103f5a <alloc_pages>
c01033aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01033ad:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01033b1:	75 24                	jne    c01033d7 <basic_check+0x38f>
c01033b3:	c7 44 24 0c f0 68 10 	movl   $0xc01068f0,0xc(%esp)
c01033ba:	c0 
c01033bb:	c7 44 24 08 56 68 10 	movl   $0xc0106856,0x8(%esp)
c01033c2:	c0 
c01033c3:	c7 44 24 04 f2 00 00 	movl   $0xf2,0x4(%esp)
c01033ca:	00 
c01033cb:	c7 04 24 6b 68 10 c0 	movl   $0xc010686b,(%esp)
c01033d2:	e8 04 d9 ff ff       	call   c0100cdb <__panic>
    assert((p2 = alloc_page()) != NULL);
c01033d7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01033de:	e8 77 0b 00 00       	call   c0103f5a <alloc_pages>
c01033e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01033e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01033ea:	75 24                	jne    c0103410 <basic_check+0x3c8>
c01033ec:	c7 44 24 0c 0c 69 10 	movl   $0xc010690c,0xc(%esp)
c01033f3:	c0 
c01033f4:	c7 44 24 08 56 68 10 	movl   $0xc0106856,0x8(%esp)
c01033fb:	c0 
c01033fc:	c7 44 24 04 f3 00 00 	movl   $0xf3,0x4(%esp)
c0103403:	00 
c0103404:	c7 04 24 6b 68 10 c0 	movl   $0xc010686b,(%esp)
c010340b:	e8 cb d8 ff ff       	call   c0100cdb <__panic>

    assert(alloc_page() == NULL);
c0103410:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103417:	e8 3e 0b 00 00       	call   c0103f5a <alloc_pages>
c010341c:	85 c0                	test   %eax,%eax
c010341e:	74 24                	je     c0103444 <basic_check+0x3fc>
c0103420:	c7 44 24 0c f6 69 10 	movl   $0xc01069f6,0xc(%esp)
c0103427:	c0 
c0103428:	c7 44 24 08 56 68 10 	movl   $0xc0106856,0x8(%esp)
c010342f:	c0 
c0103430:	c7 44 24 04 f5 00 00 	movl   $0xf5,0x4(%esp)
c0103437:	00 
c0103438:	c7 04 24 6b 68 10 c0 	movl   $0xc010686b,(%esp)
c010343f:	e8 97 d8 ff ff       	call   c0100cdb <__panic>

    free_page(p0);
c0103444:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010344b:	00 
c010344c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010344f:	89 04 24             	mov    %eax,(%esp)
c0103452:	e8 3d 0b 00 00       	call   c0103f94 <free_pages>
c0103457:	c7 45 d8 80 ce 11 c0 	movl   $0xc011ce80,-0x28(%ebp)
c010345e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103461:	8b 40 04             	mov    0x4(%eax),%eax
c0103464:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0103467:	0f 94 c0             	sete   %al
c010346a:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c010346d:	85 c0                	test   %eax,%eax
c010346f:	74 24                	je     c0103495 <basic_check+0x44d>
c0103471:	c7 44 24 0c 18 6a 10 	movl   $0xc0106a18,0xc(%esp)
c0103478:	c0 
c0103479:	c7 44 24 08 56 68 10 	movl   $0xc0106856,0x8(%esp)
c0103480:	c0 
c0103481:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c0103488:	00 
c0103489:	c7 04 24 6b 68 10 c0 	movl   $0xc010686b,(%esp)
c0103490:	e8 46 d8 ff ff       	call   c0100cdb <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c0103495:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010349c:	e8 b9 0a 00 00       	call   c0103f5a <alloc_pages>
c01034a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01034a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01034a7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01034aa:	74 24                	je     c01034d0 <basic_check+0x488>
c01034ac:	c7 44 24 0c 30 6a 10 	movl   $0xc0106a30,0xc(%esp)
c01034b3:	c0 
c01034b4:	c7 44 24 08 56 68 10 	movl   $0xc0106856,0x8(%esp)
c01034bb:	c0 
c01034bc:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c01034c3:	00 
c01034c4:	c7 04 24 6b 68 10 c0 	movl   $0xc010686b,(%esp)
c01034cb:	e8 0b d8 ff ff       	call   c0100cdb <__panic>
    assert(alloc_page() == NULL);
c01034d0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01034d7:	e8 7e 0a 00 00       	call   c0103f5a <alloc_pages>
c01034dc:	85 c0                	test   %eax,%eax
c01034de:	74 24                	je     c0103504 <basic_check+0x4bc>
c01034e0:	c7 44 24 0c f6 69 10 	movl   $0xc01069f6,0xc(%esp)
c01034e7:	c0 
c01034e8:	c7 44 24 08 56 68 10 	movl   $0xc0106856,0x8(%esp)
c01034ef:	c0 
c01034f0:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
c01034f7:	00 
c01034f8:	c7 04 24 6b 68 10 c0 	movl   $0xc010686b,(%esp)
c01034ff:	e8 d7 d7 ff ff       	call   c0100cdb <__panic>

    assert(nr_free == 0);
c0103504:	a1 88 ce 11 c0       	mov    0xc011ce88,%eax
c0103509:	85 c0                	test   %eax,%eax
c010350b:	74 24                	je     c0103531 <basic_check+0x4e9>
c010350d:	c7 44 24 0c 49 6a 10 	movl   $0xc0106a49,0xc(%esp)
c0103514:	c0 
c0103515:	c7 44 24 08 56 68 10 	movl   $0xc0106856,0x8(%esp)
c010351c:	c0 
c010351d:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
c0103524:	00 
c0103525:	c7 04 24 6b 68 10 c0 	movl   $0xc010686b,(%esp)
c010352c:	e8 aa d7 ff ff       	call   c0100cdb <__panic>
    free_list = free_list_store;
c0103531:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103534:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103537:	a3 80 ce 11 c0       	mov    %eax,0xc011ce80
c010353c:	89 15 84 ce 11 c0    	mov    %edx,0xc011ce84
    nr_free = nr_free_store;
c0103542:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103545:	a3 88 ce 11 c0       	mov    %eax,0xc011ce88

    free_page(p);
c010354a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103551:	00 
c0103552:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103555:	89 04 24             	mov    %eax,(%esp)
c0103558:	e8 37 0a 00 00       	call   c0103f94 <free_pages>
    free_page(p1);
c010355d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103564:	00 
c0103565:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103568:	89 04 24             	mov    %eax,(%esp)
c010356b:	e8 24 0a 00 00       	call   c0103f94 <free_pages>
    free_page(p2);
c0103570:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103577:	00 
c0103578:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010357b:	89 04 24             	mov    %eax,(%esp)
c010357e:	e8 11 0a 00 00       	call   c0103f94 <free_pages>
}
c0103583:	90                   	nop
c0103584:	89 ec                	mov    %ebp,%esp
c0103586:	5d                   	pop    %ebp
c0103587:	c3                   	ret    

c0103588 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0103588:	55                   	push   %ebp
c0103589:	89 e5                	mov    %esp,%ebp
c010358b:	81 ec 98 00 00 00    	sub    $0x98,%esp
    int count = 0, total = 0;
c0103591:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103598:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c010359f:	c7 45 ec 80 ce 11 c0 	movl   $0xc011ce80,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01035a6:	eb 6a                	jmp    c0103612 <default_check+0x8a>
        struct Page *p = le2page(le, page_link);
c01035a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01035ab:	83 e8 0c             	sub    $0xc,%eax
c01035ae:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(PageProperty(p));
c01035b1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01035b4:	83 c0 04             	add    $0x4,%eax
c01035b7:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c01035be:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01035c1:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01035c4:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01035c7:	0f a3 10             	bt     %edx,(%eax)
c01035ca:	19 c0                	sbb    %eax,%eax
c01035cc:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c01035cf:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c01035d3:	0f 95 c0             	setne  %al
c01035d6:	0f b6 c0             	movzbl %al,%eax
c01035d9:	85 c0                	test   %eax,%eax
c01035db:	75 24                	jne    c0103601 <default_check+0x79>
c01035dd:	c7 44 24 0c 56 6a 10 	movl   $0xc0106a56,0xc(%esp)
c01035e4:	c0 
c01035e5:	c7 44 24 08 56 68 10 	movl   $0xc0106856,0x8(%esp)
c01035ec:	c0 
c01035ed:	c7 44 24 04 0f 01 00 	movl   $0x10f,0x4(%esp)
c01035f4:	00 
c01035f5:	c7 04 24 6b 68 10 c0 	movl   $0xc010686b,(%esp)
c01035fc:	e8 da d6 ff ff       	call   c0100cdb <__panic>
        count ++, total += p->property;
c0103601:	ff 45 f4             	incl   -0xc(%ebp)
c0103604:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103607:	8b 50 08             	mov    0x8(%eax),%edx
c010360a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010360d:	01 d0                	add    %edx,%eax
c010360f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103612:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103615:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
c0103618:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010361b:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c010361e:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103621:	81 7d ec 80 ce 11 c0 	cmpl   $0xc011ce80,-0x14(%ebp)
c0103628:	0f 85 7a ff ff ff    	jne    c01035a8 <default_check+0x20>
    }
    assert(total == nr_free_pages());
c010362e:	e8 96 09 00 00       	call   c0103fc9 <nr_free_pages>
c0103633:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0103636:	39 d0                	cmp    %edx,%eax
c0103638:	74 24                	je     c010365e <default_check+0xd6>
c010363a:	c7 44 24 0c 66 6a 10 	movl   $0xc0106a66,0xc(%esp)
c0103641:	c0 
c0103642:	c7 44 24 08 56 68 10 	movl   $0xc0106856,0x8(%esp)
c0103649:	c0 
c010364a:	c7 44 24 04 12 01 00 	movl   $0x112,0x4(%esp)
c0103651:	00 
c0103652:	c7 04 24 6b 68 10 c0 	movl   $0xc010686b,(%esp)
c0103659:	e8 7d d6 ff ff       	call   c0100cdb <__panic>

    basic_check();
c010365e:	e8 e5 f9 ff ff       	call   c0103048 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0103663:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c010366a:	e8 eb 08 00 00       	call   c0103f5a <alloc_pages>
c010366f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(p0 != NULL);
c0103672:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0103676:	75 24                	jne    c010369c <default_check+0x114>
c0103678:	c7 44 24 0c 7f 6a 10 	movl   $0xc0106a7f,0xc(%esp)
c010367f:	c0 
c0103680:	c7 44 24 08 56 68 10 	movl   $0xc0106856,0x8(%esp)
c0103687:	c0 
c0103688:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
c010368f:	00 
c0103690:	c7 04 24 6b 68 10 c0 	movl   $0xc010686b,(%esp)
c0103697:	e8 3f d6 ff ff       	call   c0100cdb <__panic>
    assert(!PageProperty(p0));
c010369c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010369f:	83 c0 04             	add    $0x4,%eax
c01036a2:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c01036a9:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01036ac:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01036af:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01036b2:	0f a3 10             	bt     %edx,(%eax)
c01036b5:	19 c0                	sbb    %eax,%eax
c01036b7:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c01036ba:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c01036be:	0f 95 c0             	setne  %al
c01036c1:	0f b6 c0             	movzbl %al,%eax
c01036c4:	85 c0                	test   %eax,%eax
c01036c6:	74 24                	je     c01036ec <default_check+0x164>
c01036c8:	c7 44 24 0c 8a 6a 10 	movl   $0xc0106a8a,0xc(%esp)
c01036cf:	c0 
c01036d0:	c7 44 24 08 56 68 10 	movl   $0xc0106856,0x8(%esp)
c01036d7:	c0 
c01036d8:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
c01036df:	00 
c01036e0:	c7 04 24 6b 68 10 c0 	movl   $0xc010686b,(%esp)
c01036e7:	e8 ef d5 ff ff       	call   c0100cdb <__panic>

    list_entry_t free_list_store = free_list;
c01036ec:	a1 80 ce 11 c0       	mov    0xc011ce80,%eax
c01036f1:	8b 15 84 ce 11 c0    	mov    0xc011ce84,%edx
c01036f7:	89 45 80             	mov    %eax,-0x80(%ebp)
c01036fa:	89 55 84             	mov    %edx,-0x7c(%ebp)
c01036fd:	c7 45 b0 80 ce 11 c0 	movl   $0xc011ce80,-0x50(%ebp)
    elm->prev = elm->next = elm;
c0103704:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103707:	8b 55 b0             	mov    -0x50(%ebp),%edx
c010370a:	89 50 04             	mov    %edx,0x4(%eax)
c010370d:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103710:	8b 50 04             	mov    0x4(%eax),%edx
c0103713:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103716:	89 10                	mov    %edx,(%eax)
}
c0103718:	90                   	nop
c0103719:	c7 45 b4 80 ce 11 c0 	movl   $0xc011ce80,-0x4c(%ebp)
    return list->next == list;
c0103720:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103723:	8b 40 04             	mov    0x4(%eax),%eax
c0103726:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
c0103729:	0f 94 c0             	sete   %al
c010372c:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c010372f:	85 c0                	test   %eax,%eax
c0103731:	75 24                	jne    c0103757 <default_check+0x1cf>
c0103733:	c7 44 24 0c df 69 10 	movl   $0xc01069df,0xc(%esp)
c010373a:	c0 
c010373b:	c7 44 24 08 56 68 10 	movl   $0xc0106856,0x8(%esp)
c0103742:	c0 
c0103743:	c7 44 24 04 1c 01 00 	movl   $0x11c,0x4(%esp)
c010374a:	00 
c010374b:	c7 04 24 6b 68 10 c0 	movl   $0xc010686b,(%esp)
c0103752:	e8 84 d5 ff ff       	call   c0100cdb <__panic>
    assert(alloc_page() == NULL);
c0103757:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010375e:	e8 f7 07 00 00       	call   c0103f5a <alloc_pages>
c0103763:	85 c0                	test   %eax,%eax
c0103765:	74 24                	je     c010378b <default_check+0x203>
c0103767:	c7 44 24 0c f6 69 10 	movl   $0xc01069f6,0xc(%esp)
c010376e:	c0 
c010376f:	c7 44 24 08 56 68 10 	movl   $0xc0106856,0x8(%esp)
c0103776:	c0 
c0103777:	c7 44 24 04 1d 01 00 	movl   $0x11d,0x4(%esp)
c010377e:	00 
c010377f:	c7 04 24 6b 68 10 c0 	movl   $0xc010686b,(%esp)
c0103786:	e8 50 d5 ff ff       	call   c0100cdb <__panic>

    unsigned int nr_free_store = nr_free;
c010378b:	a1 88 ce 11 c0       	mov    0xc011ce88,%eax
c0103790:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nr_free = 0;
c0103793:	c7 05 88 ce 11 c0 00 	movl   $0x0,0xc011ce88
c010379a:	00 00 00 

    free_pages(p0 + 2, 3);
c010379d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01037a0:	83 c0 28             	add    $0x28,%eax
c01037a3:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c01037aa:	00 
c01037ab:	89 04 24             	mov    %eax,(%esp)
c01037ae:	e8 e1 07 00 00       	call   c0103f94 <free_pages>
    assert(alloc_pages(4) == NULL);
c01037b3:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c01037ba:	e8 9b 07 00 00       	call   c0103f5a <alloc_pages>
c01037bf:	85 c0                	test   %eax,%eax
c01037c1:	74 24                	je     c01037e7 <default_check+0x25f>
c01037c3:	c7 44 24 0c 9c 6a 10 	movl   $0xc0106a9c,0xc(%esp)
c01037ca:	c0 
c01037cb:	c7 44 24 08 56 68 10 	movl   $0xc0106856,0x8(%esp)
c01037d2:	c0 
c01037d3:	c7 44 24 04 23 01 00 	movl   $0x123,0x4(%esp)
c01037da:	00 
c01037db:	c7 04 24 6b 68 10 c0 	movl   $0xc010686b,(%esp)
c01037e2:	e8 f4 d4 ff ff       	call   c0100cdb <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c01037e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01037ea:	83 c0 28             	add    $0x28,%eax
c01037ed:	83 c0 04             	add    $0x4,%eax
c01037f0:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c01037f7:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01037fa:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01037fd:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0103800:	0f a3 10             	bt     %edx,(%eax)
c0103803:	19 c0                	sbb    %eax,%eax
c0103805:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c0103808:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c010380c:	0f 95 c0             	setne  %al
c010380f:	0f b6 c0             	movzbl %al,%eax
c0103812:	85 c0                	test   %eax,%eax
c0103814:	74 0e                	je     c0103824 <default_check+0x29c>
c0103816:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103819:	83 c0 28             	add    $0x28,%eax
c010381c:	8b 40 08             	mov    0x8(%eax),%eax
c010381f:	83 f8 03             	cmp    $0x3,%eax
c0103822:	74 24                	je     c0103848 <default_check+0x2c0>
c0103824:	c7 44 24 0c b4 6a 10 	movl   $0xc0106ab4,0xc(%esp)
c010382b:	c0 
c010382c:	c7 44 24 08 56 68 10 	movl   $0xc0106856,0x8(%esp)
c0103833:	c0 
c0103834:	c7 44 24 04 24 01 00 	movl   $0x124,0x4(%esp)
c010383b:	00 
c010383c:	c7 04 24 6b 68 10 c0 	movl   $0xc010686b,(%esp)
c0103843:	e8 93 d4 ff ff       	call   c0100cdb <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0103848:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c010384f:	e8 06 07 00 00       	call   c0103f5a <alloc_pages>
c0103854:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103857:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c010385b:	75 24                	jne    c0103881 <default_check+0x2f9>
c010385d:	c7 44 24 0c e0 6a 10 	movl   $0xc0106ae0,0xc(%esp)
c0103864:	c0 
c0103865:	c7 44 24 08 56 68 10 	movl   $0xc0106856,0x8(%esp)
c010386c:	c0 
c010386d:	c7 44 24 04 25 01 00 	movl   $0x125,0x4(%esp)
c0103874:	00 
c0103875:	c7 04 24 6b 68 10 c0 	movl   $0xc010686b,(%esp)
c010387c:	e8 5a d4 ff ff       	call   c0100cdb <__panic>
    assert(alloc_page() == NULL);
c0103881:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103888:	e8 cd 06 00 00       	call   c0103f5a <alloc_pages>
c010388d:	85 c0                	test   %eax,%eax
c010388f:	74 24                	je     c01038b5 <default_check+0x32d>
c0103891:	c7 44 24 0c f6 69 10 	movl   $0xc01069f6,0xc(%esp)
c0103898:	c0 
c0103899:	c7 44 24 08 56 68 10 	movl   $0xc0106856,0x8(%esp)
c01038a0:	c0 
c01038a1:	c7 44 24 04 26 01 00 	movl   $0x126,0x4(%esp)
c01038a8:	00 
c01038a9:	c7 04 24 6b 68 10 c0 	movl   $0xc010686b,(%esp)
c01038b0:	e8 26 d4 ff ff       	call   c0100cdb <__panic>
    assert(p0 + 2 == p1);
c01038b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01038b8:	83 c0 28             	add    $0x28,%eax
c01038bb:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c01038be:	74 24                	je     c01038e4 <default_check+0x35c>
c01038c0:	c7 44 24 0c fe 6a 10 	movl   $0xc0106afe,0xc(%esp)
c01038c7:	c0 
c01038c8:	c7 44 24 08 56 68 10 	movl   $0xc0106856,0x8(%esp)
c01038cf:	c0 
c01038d0:	c7 44 24 04 27 01 00 	movl   $0x127,0x4(%esp)
c01038d7:	00 
c01038d8:	c7 04 24 6b 68 10 c0 	movl   $0xc010686b,(%esp)
c01038df:	e8 f7 d3 ff ff       	call   c0100cdb <__panic>

    p2 = p0 + 1;
c01038e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01038e7:	83 c0 14             	add    $0x14,%eax
c01038ea:	89 45 dc             	mov    %eax,-0x24(%ebp)
    free_page(p0);
c01038ed:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01038f4:	00 
c01038f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01038f8:	89 04 24             	mov    %eax,(%esp)
c01038fb:	e8 94 06 00 00       	call   c0103f94 <free_pages>
    free_pages(p1, 3);
c0103900:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0103907:	00 
c0103908:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010390b:	89 04 24             	mov    %eax,(%esp)
c010390e:	e8 81 06 00 00       	call   c0103f94 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c0103913:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103916:	83 c0 04             	add    $0x4,%eax
c0103919:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c0103920:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103923:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0103926:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0103929:	0f a3 10             	bt     %edx,(%eax)
c010392c:	19 c0                	sbb    %eax,%eax
c010392e:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c0103931:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0103935:	0f 95 c0             	setne  %al
c0103938:	0f b6 c0             	movzbl %al,%eax
c010393b:	85 c0                	test   %eax,%eax
c010393d:	74 0b                	je     c010394a <default_check+0x3c2>
c010393f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103942:	8b 40 08             	mov    0x8(%eax),%eax
c0103945:	83 f8 01             	cmp    $0x1,%eax
c0103948:	74 24                	je     c010396e <default_check+0x3e6>
c010394a:	c7 44 24 0c 0c 6b 10 	movl   $0xc0106b0c,0xc(%esp)
c0103951:	c0 
c0103952:	c7 44 24 08 56 68 10 	movl   $0xc0106856,0x8(%esp)
c0103959:	c0 
c010395a:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
c0103961:	00 
c0103962:	c7 04 24 6b 68 10 c0 	movl   $0xc010686b,(%esp)
c0103969:	e8 6d d3 ff ff       	call   c0100cdb <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c010396e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103971:	83 c0 04             	add    $0x4,%eax
c0103974:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c010397b:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010397e:	8b 45 90             	mov    -0x70(%ebp),%eax
c0103981:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0103984:	0f a3 10             	bt     %edx,(%eax)
c0103987:	19 c0                	sbb    %eax,%eax
c0103989:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c010398c:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c0103990:	0f 95 c0             	setne  %al
c0103993:	0f b6 c0             	movzbl %al,%eax
c0103996:	85 c0                	test   %eax,%eax
c0103998:	74 0b                	je     c01039a5 <default_check+0x41d>
c010399a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010399d:	8b 40 08             	mov    0x8(%eax),%eax
c01039a0:	83 f8 03             	cmp    $0x3,%eax
c01039a3:	74 24                	je     c01039c9 <default_check+0x441>
c01039a5:	c7 44 24 0c 34 6b 10 	movl   $0xc0106b34,0xc(%esp)
c01039ac:	c0 
c01039ad:	c7 44 24 08 56 68 10 	movl   $0xc0106856,0x8(%esp)
c01039b4:	c0 
c01039b5:	c7 44 24 04 2d 01 00 	movl   $0x12d,0x4(%esp)
c01039bc:	00 
c01039bd:	c7 04 24 6b 68 10 c0 	movl   $0xc010686b,(%esp)
c01039c4:	e8 12 d3 ff ff       	call   c0100cdb <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c01039c9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01039d0:	e8 85 05 00 00       	call   c0103f5a <alloc_pages>
c01039d5:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01039d8:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01039db:	83 e8 14             	sub    $0x14,%eax
c01039de:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01039e1:	74 24                	je     c0103a07 <default_check+0x47f>
c01039e3:	c7 44 24 0c 5a 6b 10 	movl   $0xc0106b5a,0xc(%esp)
c01039ea:	c0 
c01039eb:	c7 44 24 08 56 68 10 	movl   $0xc0106856,0x8(%esp)
c01039f2:	c0 
c01039f3:	c7 44 24 04 2f 01 00 	movl   $0x12f,0x4(%esp)
c01039fa:	00 
c01039fb:	c7 04 24 6b 68 10 c0 	movl   $0xc010686b,(%esp)
c0103a02:	e8 d4 d2 ff ff       	call   c0100cdb <__panic>
    free_page(p0);
c0103a07:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103a0e:	00 
c0103a0f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103a12:	89 04 24             	mov    %eax,(%esp)
c0103a15:	e8 7a 05 00 00       	call   c0103f94 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c0103a1a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c0103a21:	e8 34 05 00 00       	call   c0103f5a <alloc_pages>
c0103a26:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103a29:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103a2c:	83 c0 14             	add    $0x14,%eax
c0103a2f:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0103a32:	74 24                	je     c0103a58 <default_check+0x4d0>
c0103a34:	c7 44 24 0c 78 6b 10 	movl   $0xc0106b78,0xc(%esp)
c0103a3b:	c0 
c0103a3c:	c7 44 24 08 56 68 10 	movl   $0xc0106856,0x8(%esp)
c0103a43:	c0 
c0103a44:	c7 44 24 04 31 01 00 	movl   $0x131,0x4(%esp)
c0103a4b:	00 
c0103a4c:	c7 04 24 6b 68 10 c0 	movl   $0xc010686b,(%esp)
c0103a53:	e8 83 d2 ff ff       	call   c0100cdb <__panic>

    free_pages(p0, 2);
c0103a58:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c0103a5f:	00 
c0103a60:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103a63:	89 04 24             	mov    %eax,(%esp)
c0103a66:	e8 29 05 00 00       	call   c0103f94 <free_pages>
    free_page(p2);
c0103a6b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103a72:	00 
c0103a73:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103a76:	89 04 24             	mov    %eax,(%esp)
c0103a79:	e8 16 05 00 00       	call   c0103f94 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c0103a7e:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0103a85:	e8 d0 04 00 00       	call   c0103f5a <alloc_pages>
c0103a8a:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103a8d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0103a91:	75 24                	jne    c0103ab7 <default_check+0x52f>
c0103a93:	c7 44 24 0c 98 6b 10 	movl   $0xc0106b98,0xc(%esp)
c0103a9a:	c0 
c0103a9b:	c7 44 24 08 56 68 10 	movl   $0xc0106856,0x8(%esp)
c0103aa2:	c0 
c0103aa3:	c7 44 24 04 36 01 00 	movl   $0x136,0x4(%esp)
c0103aaa:	00 
c0103aab:	c7 04 24 6b 68 10 c0 	movl   $0xc010686b,(%esp)
c0103ab2:	e8 24 d2 ff ff       	call   c0100cdb <__panic>
    assert(alloc_page() == NULL);
c0103ab7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103abe:	e8 97 04 00 00       	call   c0103f5a <alloc_pages>
c0103ac3:	85 c0                	test   %eax,%eax
c0103ac5:	74 24                	je     c0103aeb <default_check+0x563>
c0103ac7:	c7 44 24 0c f6 69 10 	movl   $0xc01069f6,0xc(%esp)
c0103ace:	c0 
c0103acf:	c7 44 24 08 56 68 10 	movl   $0xc0106856,0x8(%esp)
c0103ad6:	c0 
c0103ad7:	c7 44 24 04 37 01 00 	movl   $0x137,0x4(%esp)
c0103ade:	00 
c0103adf:	c7 04 24 6b 68 10 c0 	movl   $0xc010686b,(%esp)
c0103ae6:	e8 f0 d1 ff ff       	call   c0100cdb <__panic>

    assert(nr_free == 0);
c0103aeb:	a1 88 ce 11 c0       	mov    0xc011ce88,%eax
c0103af0:	85 c0                	test   %eax,%eax
c0103af2:	74 24                	je     c0103b18 <default_check+0x590>
c0103af4:	c7 44 24 0c 49 6a 10 	movl   $0xc0106a49,0xc(%esp)
c0103afb:	c0 
c0103afc:	c7 44 24 08 56 68 10 	movl   $0xc0106856,0x8(%esp)
c0103b03:	c0 
c0103b04:	c7 44 24 04 39 01 00 	movl   $0x139,0x4(%esp)
c0103b0b:	00 
c0103b0c:	c7 04 24 6b 68 10 c0 	movl   $0xc010686b,(%esp)
c0103b13:	e8 c3 d1 ff ff       	call   c0100cdb <__panic>
    nr_free = nr_free_store;
c0103b18:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103b1b:	a3 88 ce 11 c0       	mov    %eax,0xc011ce88

    free_list = free_list_store;
c0103b20:	8b 45 80             	mov    -0x80(%ebp),%eax
c0103b23:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0103b26:	a3 80 ce 11 c0       	mov    %eax,0xc011ce80
c0103b2b:	89 15 84 ce 11 c0    	mov    %edx,0xc011ce84
    free_pages(p0, 5);
c0103b31:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c0103b38:	00 
c0103b39:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103b3c:	89 04 24             	mov    %eax,(%esp)
c0103b3f:	e8 50 04 00 00       	call   c0103f94 <free_pages>

    le = &free_list;
c0103b44:	c7 45 ec 80 ce 11 c0 	movl   $0xc011ce80,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103b4b:	eb 5a                	jmp    c0103ba7 <default_check+0x61f>
        assert(le->next->prev == le && le->prev->next == le);
c0103b4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103b50:	8b 40 04             	mov    0x4(%eax),%eax
c0103b53:	8b 00                	mov    (%eax),%eax
c0103b55:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0103b58:	75 0d                	jne    c0103b67 <default_check+0x5df>
c0103b5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103b5d:	8b 00                	mov    (%eax),%eax
c0103b5f:	8b 40 04             	mov    0x4(%eax),%eax
c0103b62:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0103b65:	74 24                	je     c0103b8b <default_check+0x603>
c0103b67:	c7 44 24 0c b8 6b 10 	movl   $0xc0106bb8,0xc(%esp)
c0103b6e:	c0 
c0103b6f:	c7 44 24 08 56 68 10 	movl   $0xc0106856,0x8(%esp)
c0103b76:	c0 
c0103b77:	c7 44 24 04 41 01 00 	movl   $0x141,0x4(%esp)
c0103b7e:	00 
c0103b7f:	c7 04 24 6b 68 10 c0 	movl   $0xc010686b,(%esp)
c0103b86:	e8 50 d1 ff ff       	call   c0100cdb <__panic>
        struct Page *p = le2page(le, page_link);
c0103b8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103b8e:	83 e8 0c             	sub    $0xc,%eax
c0103b91:	89 45 d8             	mov    %eax,-0x28(%ebp)
        count --, total -= p->property;
c0103b94:	ff 4d f4             	decl   -0xc(%ebp)
c0103b97:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0103b9a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103b9d:	8b 48 08             	mov    0x8(%eax),%ecx
c0103ba0:	89 d0                	mov    %edx,%eax
c0103ba2:	29 c8                	sub    %ecx,%eax
c0103ba4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103ba7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103baa:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
c0103bad:	8b 45 88             	mov    -0x78(%ebp),%eax
c0103bb0:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c0103bb3:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103bb6:	81 7d ec 80 ce 11 c0 	cmpl   $0xc011ce80,-0x14(%ebp)
c0103bbd:	75 8e                	jne    c0103b4d <default_check+0x5c5>
    }
    assert(count == 0);
c0103bbf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103bc3:	74 24                	je     c0103be9 <default_check+0x661>
c0103bc5:	c7 44 24 0c e5 6b 10 	movl   $0xc0106be5,0xc(%esp)
c0103bcc:	c0 
c0103bcd:	c7 44 24 08 56 68 10 	movl   $0xc0106856,0x8(%esp)
c0103bd4:	c0 
c0103bd5:	c7 44 24 04 45 01 00 	movl   $0x145,0x4(%esp)
c0103bdc:	00 
c0103bdd:	c7 04 24 6b 68 10 c0 	movl   $0xc010686b,(%esp)
c0103be4:	e8 f2 d0 ff ff       	call   c0100cdb <__panic>
    assert(total == 0);
c0103be9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103bed:	74 24                	je     c0103c13 <default_check+0x68b>
c0103bef:	c7 44 24 0c f0 6b 10 	movl   $0xc0106bf0,0xc(%esp)
c0103bf6:	c0 
c0103bf7:	c7 44 24 08 56 68 10 	movl   $0xc0106856,0x8(%esp)
c0103bfe:	c0 
c0103bff:	c7 44 24 04 46 01 00 	movl   $0x146,0x4(%esp)
c0103c06:	00 
c0103c07:	c7 04 24 6b 68 10 c0 	movl   $0xc010686b,(%esp)
c0103c0e:	e8 c8 d0 ff ff       	call   c0100cdb <__panic>
}
c0103c13:	90                   	nop
c0103c14:	89 ec                	mov    %ebp,%esp
c0103c16:	5d                   	pop    %ebp
c0103c17:	c3                   	ret    

c0103c18 <page2ppn>:
page2ppn(struct Page *page) {
c0103c18:	55                   	push   %ebp
c0103c19:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0103c1b:	8b 15 a0 ce 11 c0    	mov    0xc011cea0,%edx
c0103c21:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c24:	29 d0                	sub    %edx,%eax
c0103c26:	c1 f8 02             	sar    $0x2,%eax
c0103c29:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0103c2f:	5d                   	pop    %ebp
c0103c30:	c3                   	ret    

c0103c31 <page2pa>:
page2pa(struct Page *page) {
c0103c31:	55                   	push   %ebp
c0103c32:	89 e5                	mov    %esp,%ebp
c0103c34:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0103c37:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c3a:	89 04 24             	mov    %eax,(%esp)
c0103c3d:	e8 d6 ff ff ff       	call   c0103c18 <page2ppn>
c0103c42:	c1 e0 0c             	shl    $0xc,%eax
}
c0103c45:	89 ec                	mov    %ebp,%esp
c0103c47:	5d                   	pop    %ebp
c0103c48:	c3                   	ret    

c0103c49 <pa2page>:
pa2page(uintptr_t pa) {
c0103c49:	55                   	push   %ebp
c0103c4a:	89 e5                	mov    %esp,%ebp
c0103c4c:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0103c4f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c52:	c1 e8 0c             	shr    $0xc,%eax
c0103c55:	89 c2                	mov    %eax,%edx
c0103c57:	a1 a4 ce 11 c0       	mov    0xc011cea4,%eax
c0103c5c:	39 c2                	cmp    %eax,%edx
c0103c5e:	72 1c                	jb     c0103c7c <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0103c60:	c7 44 24 08 2c 6c 10 	movl   $0xc0106c2c,0x8(%esp)
c0103c67:	c0 
c0103c68:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c0103c6f:	00 
c0103c70:	c7 04 24 4b 6c 10 c0 	movl   $0xc0106c4b,(%esp)
c0103c77:	e8 5f d0 ff ff       	call   c0100cdb <__panic>
    return &pages[PPN(pa)];
c0103c7c:	8b 0d a0 ce 11 c0    	mov    0xc011cea0,%ecx
c0103c82:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c85:	c1 e8 0c             	shr    $0xc,%eax
c0103c88:	89 c2                	mov    %eax,%edx
c0103c8a:	89 d0                	mov    %edx,%eax
c0103c8c:	c1 e0 02             	shl    $0x2,%eax
c0103c8f:	01 d0                	add    %edx,%eax
c0103c91:	c1 e0 02             	shl    $0x2,%eax
c0103c94:	01 c8                	add    %ecx,%eax
}
c0103c96:	89 ec                	mov    %ebp,%esp
c0103c98:	5d                   	pop    %ebp
c0103c99:	c3                   	ret    

c0103c9a <page2kva>:
page2kva(struct Page *page) {
c0103c9a:	55                   	push   %ebp
c0103c9b:	89 e5                	mov    %esp,%ebp
c0103c9d:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0103ca0:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ca3:	89 04 24             	mov    %eax,(%esp)
c0103ca6:	e8 86 ff ff ff       	call   c0103c31 <page2pa>
c0103cab:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103cae:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103cb1:	c1 e8 0c             	shr    $0xc,%eax
c0103cb4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103cb7:	a1 a4 ce 11 c0       	mov    0xc011cea4,%eax
c0103cbc:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0103cbf:	72 23                	jb     c0103ce4 <page2kva+0x4a>
c0103cc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103cc4:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103cc8:	c7 44 24 08 5c 6c 10 	movl   $0xc0106c5c,0x8(%esp)
c0103ccf:	c0 
c0103cd0:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0103cd7:	00 
c0103cd8:	c7 04 24 4b 6c 10 c0 	movl   $0xc0106c4b,(%esp)
c0103cdf:	e8 f7 cf ff ff       	call   c0100cdb <__panic>
c0103ce4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ce7:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0103cec:	89 ec                	mov    %ebp,%esp
c0103cee:	5d                   	pop    %ebp
c0103cef:	c3                   	ret    

c0103cf0 <pte2page>:
pte2page(pte_t pte) {
c0103cf0:	55                   	push   %ebp
c0103cf1:	89 e5                	mov    %esp,%ebp
c0103cf3:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0103cf6:	8b 45 08             	mov    0x8(%ebp),%eax
c0103cf9:	83 e0 01             	and    $0x1,%eax
c0103cfc:	85 c0                	test   %eax,%eax
c0103cfe:	75 1c                	jne    c0103d1c <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0103d00:	c7 44 24 08 80 6c 10 	movl   $0xc0106c80,0x8(%esp)
c0103d07:	c0 
c0103d08:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0103d0f:	00 
c0103d10:	c7 04 24 4b 6c 10 c0 	movl   $0xc0106c4b,(%esp)
c0103d17:	e8 bf cf ff ff       	call   c0100cdb <__panic>
    return pa2page(PTE_ADDR(pte));
c0103d1c:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d1f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103d24:	89 04 24             	mov    %eax,(%esp)
c0103d27:	e8 1d ff ff ff       	call   c0103c49 <pa2page>
}
c0103d2c:	89 ec                	mov    %ebp,%esp
c0103d2e:	5d                   	pop    %ebp
c0103d2f:	c3                   	ret    

c0103d30 <pde2page>:
pde2page(pde_t pde) {
c0103d30:	55                   	push   %ebp
c0103d31:	89 e5                	mov    %esp,%ebp
c0103d33:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c0103d36:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d39:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103d3e:	89 04 24             	mov    %eax,(%esp)
c0103d41:	e8 03 ff ff ff       	call   c0103c49 <pa2page>
}
c0103d46:	89 ec                	mov    %ebp,%esp
c0103d48:	5d                   	pop    %ebp
c0103d49:	c3                   	ret    

c0103d4a <page_ref>:
page_ref(struct Page *page) {
c0103d4a:	55                   	push   %ebp
c0103d4b:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0103d4d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d50:	8b 00                	mov    (%eax),%eax
}
c0103d52:	5d                   	pop    %ebp
c0103d53:	c3                   	ret    

c0103d54 <set_page_ref>:
set_page_ref(struct Page *page, int val) {
c0103d54:	55                   	push   %ebp
c0103d55:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0103d57:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d5a:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103d5d:	89 10                	mov    %edx,(%eax)
}
c0103d5f:	90                   	nop
c0103d60:	5d                   	pop    %ebp
c0103d61:	c3                   	ret    

c0103d62 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0103d62:	55                   	push   %ebp
c0103d63:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0103d65:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d68:	8b 00                	mov    (%eax),%eax
c0103d6a:	8d 50 01             	lea    0x1(%eax),%edx
c0103d6d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d70:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103d72:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d75:	8b 00                	mov    (%eax),%eax
}
c0103d77:	5d                   	pop    %ebp
c0103d78:	c3                   	ret    

c0103d79 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0103d79:	55                   	push   %ebp
c0103d7a:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0103d7c:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d7f:	8b 00                	mov    (%eax),%eax
c0103d81:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103d84:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d87:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103d89:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d8c:	8b 00                	mov    (%eax),%eax
}
c0103d8e:	5d                   	pop    %ebp
c0103d8f:	c3                   	ret    

c0103d90 <__intr_save>:
__intr_save(void) {
c0103d90:	55                   	push   %ebp
c0103d91:	89 e5                	mov    %esp,%ebp
c0103d93:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0103d96:	9c                   	pushf  
c0103d97:	58                   	pop    %eax
c0103d98:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0103d9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0103d9e:	25 00 02 00 00       	and    $0x200,%eax
c0103da3:	85 c0                	test   %eax,%eax
c0103da5:	74 0c                	je     c0103db3 <__intr_save+0x23>
        intr_disable();
c0103da7:	e8 88 d9 ff ff       	call   c0101734 <intr_disable>
        return 1;
c0103dac:	b8 01 00 00 00       	mov    $0x1,%eax
c0103db1:	eb 05                	jmp    c0103db8 <__intr_save+0x28>
    return 0;
c0103db3:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103db8:	89 ec                	mov    %ebp,%esp
c0103dba:	5d                   	pop    %ebp
c0103dbb:	c3                   	ret    

c0103dbc <__intr_restore>:
__intr_restore(bool flag) {
c0103dbc:	55                   	push   %ebp
c0103dbd:	89 e5                	mov    %esp,%ebp
c0103dbf:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0103dc2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103dc6:	74 05                	je     c0103dcd <__intr_restore+0x11>
        intr_enable();
c0103dc8:	e8 5f d9 ff ff       	call   c010172c <intr_enable>
}
c0103dcd:	90                   	nop
c0103dce:	89 ec                	mov    %ebp,%esp
c0103dd0:	5d                   	pop    %ebp
c0103dd1:	c3                   	ret    

c0103dd2 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0103dd2:	55                   	push   %ebp
c0103dd3:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0103dd5:	8b 45 08             	mov    0x8(%ebp),%eax
c0103dd8:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0103ddb:	b8 23 00 00 00       	mov    $0x23,%eax
c0103de0:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0103de2:	b8 23 00 00 00       	mov    $0x23,%eax
c0103de7:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0103de9:	b8 10 00 00 00       	mov    $0x10,%eax
c0103dee:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0103df0:	b8 10 00 00 00       	mov    $0x10,%eax
c0103df5:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0103df7:	b8 10 00 00 00       	mov    $0x10,%eax
c0103dfc:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0103dfe:	ea 05 3e 10 c0 08 00 	ljmp   $0x8,$0xc0103e05
}
c0103e05:	90                   	nop
c0103e06:	5d                   	pop    %ebp
c0103e07:	c3                   	ret    

c0103e08 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0103e08:	55                   	push   %ebp
c0103e09:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0103e0b:	8b 45 08             	mov    0x8(%ebp),%eax
c0103e0e:	a3 c4 ce 11 c0       	mov    %eax,0xc011cec4
}
c0103e13:	90                   	nop
c0103e14:	5d                   	pop    %ebp
c0103e15:	c3                   	ret    

c0103e16 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0103e16:	55                   	push   %ebp
c0103e17:	89 e5                	mov    %esp,%ebp
c0103e19:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0103e1c:	b8 00 90 11 c0       	mov    $0xc0119000,%eax
c0103e21:	89 04 24             	mov    %eax,(%esp)
c0103e24:	e8 df ff ff ff       	call   c0103e08 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0103e29:	66 c7 05 c8 ce 11 c0 	movw   $0x10,0xc011cec8
c0103e30:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0103e32:	66 c7 05 28 9a 11 c0 	movw   $0x68,0xc0119a28
c0103e39:	68 00 
c0103e3b:	b8 c0 ce 11 c0       	mov    $0xc011cec0,%eax
c0103e40:	0f b7 c0             	movzwl %ax,%eax
c0103e43:	66 a3 2a 9a 11 c0    	mov    %ax,0xc0119a2a
c0103e49:	b8 c0 ce 11 c0       	mov    $0xc011cec0,%eax
c0103e4e:	c1 e8 10             	shr    $0x10,%eax
c0103e51:	a2 2c 9a 11 c0       	mov    %al,0xc0119a2c
c0103e56:	0f b6 05 2d 9a 11 c0 	movzbl 0xc0119a2d,%eax
c0103e5d:	24 f0                	and    $0xf0,%al
c0103e5f:	0c 09                	or     $0x9,%al
c0103e61:	a2 2d 9a 11 c0       	mov    %al,0xc0119a2d
c0103e66:	0f b6 05 2d 9a 11 c0 	movzbl 0xc0119a2d,%eax
c0103e6d:	24 ef                	and    $0xef,%al
c0103e6f:	a2 2d 9a 11 c0       	mov    %al,0xc0119a2d
c0103e74:	0f b6 05 2d 9a 11 c0 	movzbl 0xc0119a2d,%eax
c0103e7b:	24 9f                	and    $0x9f,%al
c0103e7d:	a2 2d 9a 11 c0       	mov    %al,0xc0119a2d
c0103e82:	0f b6 05 2d 9a 11 c0 	movzbl 0xc0119a2d,%eax
c0103e89:	0c 80                	or     $0x80,%al
c0103e8b:	a2 2d 9a 11 c0       	mov    %al,0xc0119a2d
c0103e90:	0f b6 05 2e 9a 11 c0 	movzbl 0xc0119a2e,%eax
c0103e97:	24 f0                	and    $0xf0,%al
c0103e99:	a2 2e 9a 11 c0       	mov    %al,0xc0119a2e
c0103e9e:	0f b6 05 2e 9a 11 c0 	movzbl 0xc0119a2e,%eax
c0103ea5:	24 ef                	and    $0xef,%al
c0103ea7:	a2 2e 9a 11 c0       	mov    %al,0xc0119a2e
c0103eac:	0f b6 05 2e 9a 11 c0 	movzbl 0xc0119a2e,%eax
c0103eb3:	24 df                	and    $0xdf,%al
c0103eb5:	a2 2e 9a 11 c0       	mov    %al,0xc0119a2e
c0103eba:	0f b6 05 2e 9a 11 c0 	movzbl 0xc0119a2e,%eax
c0103ec1:	0c 40                	or     $0x40,%al
c0103ec3:	a2 2e 9a 11 c0       	mov    %al,0xc0119a2e
c0103ec8:	0f b6 05 2e 9a 11 c0 	movzbl 0xc0119a2e,%eax
c0103ecf:	24 7f                	and    $0x7f,%al
c0103ed1:	a2 2e 9a 11 c0       	mov    %al,0xc0119a2e
c0103ed6:	b8 c0 ce 11 c0       	mov    $0xc011cec0,%eax
c0103edb:	c1 e8 18             	shr    $0x18,%eax
c0103ede:	a2 2f 9a 11 c0       	mov    %al,0xc0119a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0103ee3:	c7 04 24 30 9a 11 c0 	movl   $0xc0119a30,(%esp)
c0103eea:	e8 e3 fe ff ff       	call   c0103dd2 <lgdt>
c0103eef:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0103ef5:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0103ef9:	0f 00 d8             	ltr    %ax
}
c0103efc:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
c0103efd:	90                   	nop
c0103efe:	89 ec                	mov    %ebp,%esp
c0103f00:	5d                   	pop    %ebp
c0103f01:	c3                   	ret    

c0103f02 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0103f02:	55                   	push   %ebp
c0103f03:	89 e5                	mov    %esp,%ebp
c0103f05:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0103f08:	c7 05 ac ce 11 c0 10 	movl   $0xc0106c10,0xc011ceac
c0103f0f:	6c 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0103f12:	a1 ac ce 11 c0       	mov    0xc011ceac,%eax
c0103f17:	8b 00                	mov    (%eax),%eax
c0103f19:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103f1d:	c7 04 24 ac 6c 10 c0 	movl   $0xc0106cac,(%esp)
c0103f24:	e8 2d c4 ff ff       	call   c0100356 <cprintf>
    pmm_manager->init();
c0103f29:	a1 ac ce 11 c0       	mov    0xc011ceac,%eax
c0103f2e:	8b 40 04             	mov    0x4(%eax),%eax
c0103f31:	ff d0                	call   *%eax
}
c0103f33:	90                   	nop
c0103f34:	89 ec                	mov    %ebp,%esp
c0103f36:	5d                   	pop    %ebp
c0103f37:	c3                   	ret    

c0103f38 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0103f38:	55                   	push   %ebp
c0103f39:	89 e5                	mov    %esp,%ebp
c0103f3b:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0103f3e:	a1 ac ce 11 c0       	mov    0xc011ceac,%eax
c0103f43:	8b 40 08             	mov    0x8(%eax),%eax
c0103f46:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103f49:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103f4d:	8b 55 08             	mov    0x8(%ebp),%edx
c0103f50:	89 14 24             	mov    %edx,(%esp)
c0103f53:	ff d0                	call   *%eax
}
c0103f55:	90                   	nop
c0103f56:	89 ec                	mov    %ebp,%esp
c0103f58:	5d                   	pop    %ebp
c0103f59:	c3                   	ret    

c0103f5a <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0103f5a:	55                   	push   %ebp
c0103f5b:	89 e5                	mov    %esp,%ebp
c0103f5d:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0103f60:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0103f67:	e8 24 fe ff ff       	call   c0103d90 <__intr_save>
c0103f6c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0103f6f:	a1 ac ce 11 c0       	mov    0xc011ceac,%eax
c0103f74:	8b 40 0c             	mov    0xc(%eax),%eax
c0103f77:	8b 55 08             	mov    0x8(%ebp),%edx
c0103f7a:	89 14 24             	mov    %edx,(%esp)
c0103f7d:	ff d0                	call   *%eax
c0103f7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0103f82:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103f85:	89 04 24             	mov    %eax,(%esp)
c0103f88:	e8 2f fe ff ff       	call   c0103dbc <__intr_restore>
    return page;
c0103f8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103f90:	89 ec                	mov    %ebp,%esp
c0103f92:	5d                   	pop    %ebp
c0103f93:	c3                   	ret    

c0103f94 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0103f94:	55                   	push   %ebp
c0103f95:	89 e5                	mov    %esp,%ebp
c0103f97:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0103f9a:	e8 f1 fd ff ff       	call   c0103d90 <__intr_save>
c0103f9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0103fa2:	a1 ac ce 11 c0       	mov    0xc011ceac,%eax
c0103fa7:	8b 40 10             	mov    0x10(%eax),%eax
c0103faa:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103fad:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103fb1:	8b 55 08             	mov    0x8(%ebp),%edx
c0103fb4:	89 14 24             	mov    %edx,(%esp)
c0103fb7:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0103fb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103fbc:	89 04 24             	mov    %eax,(%esp)
c0103fbf:	e8 f8 fd ff ff       	call   c0103dbc <__intr_restore>
}
c0103fc4:	90                   	nop
c0103fc5:	89 ec                	mov    %ebp,%esp
c0103fc7:	5d                   	pop    %ebp
c0103fc8:	c3                   	ret    

c0103fc9 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0103fc9:	55                   	push   %ebp
c0103fca:	89 e5                	mov    %esp,%ebp
c0103fcc:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0103fcf:	e8 bc fd ff ff       	call   c0103d90 <__intr_save>
c0103fd4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0103fd7:	a1 ac ce 11 c0       	mov    0xc011ceac,%eax
c0103fdc:	8b 40 14             	mov    0x14(%eax),%eax
c0103fdf:	ff d0                	call   *%eax
c0103fe1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0103fe4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103fe7:	89 04 24             	mov    %eax,(%esp)
c0103fea:	e8 cd fd ff ff       	call   c0103dbc <__intr_restore>
    return ret;
c0103fef:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0103ff2:	89 ec                	mov    %ebp,%esp
c0103ff4:	5d                   	pop    %ebp
c0103ff5:	c3                   	ret    

c0103ff6 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0103ff6:	55                   	push   %ebp
c0103ff7:	89 e5                	mov    %esp,%ebp
c0103ff9:	57                   	push   %edi
c0103ffa:	56                   	push   %esi
c0103ffb:	53                   	push   %ebx
c0103ffc:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0104002:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0104009:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0104010:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0104017:	c7 04 24 c3 6c 10 c0 	movl   $0xc0106cc3,(%esp)
c010401e:	e8 33 c3 ff ff       	call   c0100356 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0104023:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010402a:	e9 0c 01 00 00       	jmp    c010413b <page_init+0x145>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c010402f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104032:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104035:	89 d0                	mov    %edx,%eax
c0104037:	c1 e0 02             	shl    $0x2,%eax
c010403a:	01 d0                	add    %edx,%eax
c010403c:	c1 e0 02             	shl    $0x2,%eax
c010403f:	01 c8                	add    %ecx,%eax
c0104041:	8b 50 08             	mov    0x8(%eax),%edx
c0104044:	8b 40 04             	mov    0x4(%eax),%eax
c0104047:	89 45 a0             	mov    %eax,-0x60(%ebp)
c010404a:	89 55 a4             	mov    %edx,-0x5c(%ebp)
c010404d:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104050:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104053:	89 d0                	mov    %edx,%eax
c0104055:	c1 e0 02             	shl    $0x2,%eax
c0104058:	01 d0                	add    %edx,%eax
c010405a:	c1 e0 02             	shl    $0x2,%eax
c010405d:	01 c8                	add    %ecx,%eax
c010405f:	8b 48 0c             	mov    0xc(%eax),%ecx
c0104062:	8b 58 10             	mov    0x10(%eax),%ebx
c0104065:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104068:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c010406b:	01 c8                	add    %ecx,%eax
c010406d:	11 da                	adc    %ebx,%edx
c010406f:	89 45 98             	mov    %eax,-0x68(%ebp)
c0104072:	89 55 9c             	mov    %edx,-0x64(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0104075:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104078:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010407b:	89 d0                	mov    %edx,%eax
c010407d:	c1 e0 02             	shl    $0x2,%eax
c0104080:	01 d0                	add    %edx,%eax
c0104082:	c1 e0 02             	shl    $0x2,%eax
c0104085:	01 c8                	add    %ecx,%eax
c0104087:	83 c0 14             	add    $0x14,%eax
c010408a:	8b 00                	mov    (%eax),%eax
c010408c:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c0104092:	8b 45 98             	mov    -0x68(%ebp),%eax
c0104095:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0104098:	83 c0 ff             	add    $0xffffffff,%eax
c010409b:	83 d2 ff             	adc    $0xffffffff,%edx
c010409e:	89 c6                	mov    %eax,%esi
c01040a0:	89 d7                	mov    %edx,%edi
c01040a2:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01040a5:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01040a8:	89 d0                	mov    %edx,%eax
c01040aa:	c1 e0 02             	shl    $0x2,%eax
c01040ad:	01 d0                	add    %edx,%eax
c01040af:	c1 e0 02             	shl    $0x2,%eax
c01040b2:	01 c8                	add    %ecx,%eax
c01040b4:	8b 48 0c             	mov    0xc(%eax),%ecx
c01040b7:	8b 58 10             	mov    0x10(%eax),%ebx
c01040ba:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c01040c0:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c01040c4:	89 74 24 14          	mov    %esi,0x14(%esp)
c01040c8:	89 7c 24 18          	mov    %edi,0x18(%esp)
c01040cc:	8b 45 a0             	mov    -0x60(%ebp),%eax
c01040cf:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c01040d2:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01040d6:	89 54 24 10          	mov    %edx,0x10(%esp)
c01040da:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c01040de:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c01040e2:	c7 04 24 d0 6c 10 c0 	movl   $0xc0106cd0,(%esp)
c01040e9:	e8 68 c2 ff ff       	call   c0100356 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c01040ee:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01040f1:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01040f4:	89 d0                	mov    %edx,%eax
c01040f6:	c1 e0 02             	shl    $0x2,%eax
c01040f9:	01 d0                	add    %edx,%eax
c01040fb:	c1 e0 02             	shl    $0x2,%eax
c01040fe:	01 c8                	add    %ecx,%eax
c0104100:	83 c0 14             	add    $0x14,%eax
c0104103:	8b 00                	mov    (%eax),%eax
c0104105:	83 f8 01             	cmp    $0x1,%eax
c0104108:	75 2e                	jne    c0104138 <page_init+0x142>
            if (maxpa < end && begin < KMEMSIZE) {
c010410a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010410d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104110:	3b 45 98             	cmp    -0x68(%ebp),%eax
c0104113:	89 d0                	mov    %edx,%eax
c0104115:	1b 45 9c             	sbb    -0x64(%ebp),%eax
c0104118:	73 1e                	jae    c0104138 <page_init+0x142>
c010411a:	ba ff ff ff 37       	mov    $0x37ffffff,%edx
c010411f:	b8 00 00 00 00       	mov    $0x0,%eax
c0104124:	3b 55 a0             	cmp    -0x60(%ebp),%edx
c0104127:	1b 45 a4             	sbb    -0x5c(%ebp),%eax
c010412a:	72 0c                	jb     c0104138 <page_init+0x142>
                maxpa = end;
c010412c:	8b 45 98             	mov    -0x68(%ebp),%eax
c010412f:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0104132:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0104135:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i ++) {
c0104138:	ff 45 dc             	incl   -0x24(%ebp)
c010413b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010413e:	8b 00                	mov    (%eax),%eax
c0104140:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0104143:	0f 8c e6 fe ff ff    	jl     c010402f <page_init+0x39>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0104149:	ba 00 00 00 38       	mov    $0x38000000,%edx
c010414e:	b8 00 00 00 00       	mov    $0x0,%eax
c0104153:	3b 55 e0             	cmp    -0x20(%ebp),%edx
c0104156:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
c0104159:	73 0e                	jae    c0104169 <page_init+0x173>
        maxpa = KMEMSIZE;
c010415b:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0104162:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0104169:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010416c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010416f:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0104173:	c1 ea 0c             	shr    $0xc,%edx
c0104176:	a3 a4 ce 11 c0       	mov    %eax,0xc011cea4
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c010417b:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
c0104182:	b8 2c cf 11 c0       	mov    $0xc011cf2c,%eax
c0104187:	8d 50 ff             	lea    -0x1(%eax),%edx
c010418a:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010418d:	01 d0                	add    %edx,%eax
c010418f:	89 45 bc             	mov    %eax,-0x44(%ebp)
c0104192:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0104195:	ba 00 00 00 00       	mov    $0x0,%edx
c010419a:	f7 75 c0             	divl   -0x40(%ebp)
c010419d:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01041a0:	29 d0                	sub    %edx,%eax
c01041a2:	a3 a0 ce 11 c0       	mov    %eax,0xc011cea0

    for (i = 0; i < npage; i ++) {
c01041a7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01041ae:	eb 2f                	jmp    c01041df <page_init+0x1e9>
        SetPageReserved(pages + i);
c01041b0:	8b 0d a0 ce 11 c0    	mov    0xc011cea0,%ecx
c01041b6:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01041b9:	89 d0                	mov    %edx,%eax
c01041bb:	c1 e0 02             	shl    $0x2,%eax
c01041be:	01 d0                	add    %edx,%eax
c01041c0:	c1 e0 02             	shl    $0x2,%eax
c01041c3:	01 c8                	add    %ecx,%eax
c01041c5:	83 c0 04             	add    $0x4,%eax
c01041c8:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
c01041cf:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01041d2:	8b 45 90             	mov    -0x70(%ebp),%eax
c01041d5:	8b 55 94             	mov    -0x6c(%ebp),%edx
c01041d8:	0f ab 10             	bts    %edx,(%eax)
}
c01041db:	90                   	nop
    for (i = 0; i < npage; i ++) {
c01041dc:	ff 45 dc             	incl   -0x24(%ebp)
c01041df:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01041e2:	a1 a4 ce 11 c0       	mov    0xc011cea4,%eax
c01041e7:	39 c2                	cmp    %eax,%edx
c01041e9:	72 c5                	jb     c01041b0 <page_init+0x1ba>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c01041eb:	8b 15 a4 ce 11 c0    	mov    0xc011cea4,%edx
c01041f1:	89 d0                	mov    %edx,%eax
c01041f3:	c1 e0 02             	shl    $0x2,%eax
c01041f6:	01 d0                	add    %edx,%eax
c01041f8:	c1 e0 02             	shl    $0x2,%eax
c01041fb:	89 c2                	mov    %eax,%edx
c01041fd:	a1 a0 ce 11 c0       	mov    0xc011cea0,%eax
c0104202:	01 d0                	add    %edx,%eax
c0104204:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0104207:	81 7d b8 ff ff ff bf 	cmpl   $0xbfffffff,-0x48(%ebp)
c010420e:	77 23                	ja     c0104233 <page_init+0x23d>
c0104210:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104213:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104217:	c7 44 24 08 00 6d 10 	movl   $0xc0106d00,0x8(%esp)
c010421e:	c0 
c010421f:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c0104226:	00 
c0104227:	c7 04 24 24 6d 10 c0 	movl   $0xc0106d24,(%esp)
c010422e:	e8 a8 ca ff ff       	call   c0100cdb <__panic>
c0104233:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104236:	05 00 00 00 40       	add    $0x40000000,%eax
c010423b:	89 45 b4             	mov    %eax,-0x4c(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c010423e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104245:	e9 53 01 00 00       	jmp    c010439d <page_init+0x3a7>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c010424a:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010424d:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104250:	89 d0                	mov    %edx,%eax
c0104252:	c1 e0 02             	shl    $0x2,%eax
c0104255:	01 d0                	add    %edx,%eax
c0104257:	c1 e0 02             	shl    $0x2,%eax
c010425a:	01 c8                	add    %ecx,%eax
c010425c:	8b 50 08             	mov    0x8(%eax),%edx
c010425f:	8b 40 04             	mov    0x4(%eax),%eax
c0104262:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104265:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0104268:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010426b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010426e:	89 d0                	mov    %edx,%eax
c0104270:	c1 e0 02             	shl    $0x2,%eax
c0104273:	01 d0                	add    %edx,%eax
c0104275:	c1 e0 02             	shl    $0x2,%eax
c0104278:	01 c8                	add    %ecx,%eax
c010427a:	8b 48 0c             	mov    0xc(%eax),%ecx
c010427d:	8b 58 10             	mov    0x10(%eax),%ebx
c0104280:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104283:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104286:	01 c8                	add    %ecx,%eax
c0104288:	11 da                	adc    %ebx,%edx
c010428a:	89 45 c8             	mov    %eax,-0x38(%ebp)
c010428d:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0104290:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104293:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104296:	89 d0                	mov    %edx,%eax
c0104298:	c1 e0 02             	shl    $0x2,%eax
c010429b:	01 d0                	add    %edx,%eax
c010429d:	c1 e0 02             	shl    $0x2,%eax
c01042a0:	01 c8                	add    %ecx,%eax
c01042a2:	83 c0 14             	add    $0x14,%eax
c01042a5:	8b 00                	mov    (%eax),%eax
c01042a7:	83 f8 01             	cmp    $0x1,%eax
c01042aa:	0f 85 ea 00 00 00    	jne    c010439a <page_init+0x3a4>
            if (begin < freemem) {
c01042b0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01042b3:	ba 00 00 00 00       	mov    $0x0,%edx
c01042b8:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c01042bb:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c01042be:	19 d1                	sbb    %edx,%ecx
c01042c0:	73 0d                	jae    c01042cf <page_init+0x2d9>
                begin = freemem;
c01042c2:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01042c5:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01042c8:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c01042cf:	ba 00 00 00 38       	mov    $0x38000000,%edx
c01042d4:	b8 00 00 00 00       	mov    $0x0,%eax
c01042d9:	3b 55 c8             	cmp    -0x38(%ebp),%edx
c01042dc:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c01042df:	73 0e                	jae    c01042ef <page_init+0x2f9>
                end = KMEMSIZE;
c01042e1:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c01042e8:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c01042ef:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01042f2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01042f5:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c01042f8:	89 d0                	mov    %edx,%eax
c01042fa:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c01042fd:	0f 83 97 00 00 00    	jae    c010439a <page_init+0x3a4>
                begin = ROUNDUP(begin, PGSIZE);
c0104303:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
c010430a:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010430d:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104310:	01 d0                	add    %edx,%eax
c0104312:	48                   	dec    %eax
c0104313:	89 45 ac             	mov    %eax,-0x54(%ebp)
c0104316:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0104319:	ba 00 00 00 00       	mov    $0x0,%edx
c010431e:	f7 75 b0             	divl   -0x50(%ebp)
c0104321:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0104324:	29 d0                	sub    %edx,%eax
c0104326:	ba 00 00 00 00       	mov    $0x0,%edx
c010432b:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010432e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0104331:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104334:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0104337:	8b 45 a8             	mov    -0x58(%ebp),%eax
c010433a:	ba 00 00 00 00       	mov    $0x0,%edx
c010433f:	89 c7                	mov    %eax,%edi
c0104341:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c0104347:	89 7d 80             	mov    %edi,-0x80(%ebp)
c010434a:	89 d0                	mov    %edx,%eax
c010434c:	83 e0 00             	and    $0x0,%eax
c010434f:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0104352:	8b 45 80             	mov    -0x80(%ebp),%eax
c0104355:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0104358:	89 45 c8             	mov    %eax,-0x38(%ebp)
c010435b:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c010435e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104361:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104364:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0104367:	89 d0                	mov    %edx,%eax
c0104369:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c010436c:	73 2c                	jae    c010439a <page_init+0x3a4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c010436e:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104371:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104374:	2b 45 d0             	sub    -0x30(%ebp),%eax
c0104377:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
c010437a:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c010437e:	c1 ea 0c             	shr    $0xc,%edx
c0104381:	89 c3                	mov    %eax,%ebx
c0104383:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104386:	89 04 24             	mov    %eax,(%esp)
c0104389:	e8 bb f8 ff ff       	call   c0103c49 <pa2page>
c010438e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0104392:	89 04 24             	mov    %eax,(%esp)
c0104395:	e8 9e fb ff ff       	call   c0103f38 <init_memmap>
    for (i = 0; i < memmap->nr_map; i ++) {
c010439a:	ff 45 dc             	incl   -0x24(%ebp)
c010439d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01043a0:	8b 00                	mov    (%eax),%eax
c01043a2:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01043a5:	0f 8c 9f fe ff ff    	jl     c010424a <page_init+0x254>
                }
            }
        }
    }
}
c01043ab:	90                   	nop
c01043ac:	90                   	nop
c01043ad:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c01043b3:	5b                   	pop    %ebx
c01043b4:	5e                   	pop    %esi
c01043b5:	5f                   	pop    %edi
c01043b6:	5d                   	pop    %ebp
c01043b7:	c3                   	ret    

c01043b8 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c01043b8:	55                   	push   %ebp
c01043b9:	89 e5                	mov    %esp,%ebp
c01043bb:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c01043be:	8b 45 0c             	mov    0xc(%ebp),%eax
c01043c1:	33 45 14             	xor    0x14(%ebp),%eax
c01043c4:	25 ff 0f 00 00       	and    $0xfff,%eax
c01043c9:	85 c0                	test   %eax,%eax
c01043cb:	74 24                	je     c01043f1 <boot_map_segment+0x39>
c01043cd:	c7 44 24 0c 32 6d 10 	movl   $0xc0106d32,0xc(%esp)
c01043d4:	c0 
c01043d5:	c7 44 24 08 49 6d 10 	movl   $0xc0106d49,0x8(%esp)
c01043dc:	c0 
c01043dd:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c01043e4:	00 
c01043e5:	c7 04 24 24 6d 10 c0 	movl   $0xc0106d24,(%esp)
c01043ec:	e8 ea c8 ff ff       	call   c0100cdb <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c01043f1:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c01043f8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01043fb:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104400:	89 c2                	mov    %eax,%edx
c0104402:	8b 45 10             	mov    0x10(%ebp),%eax
c0104405:	01 c2                	add    %eax,%edx
c0104407:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010440a:	01 d0                	add    %edx,%eax
c010440c:	48                   	dec    %eax
c010440d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104410:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104413:	ba 00 00 00 00       	mov    $0x0,%edx
c0104418:	f7 75 f0             	divl   -0x10(%ebp)
c010441b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010441e:	29 d0                	sub    %edx,%eax
c0104420:	c1 e8 0c             	shr    $0xc,%eax
c0104423:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c0104426:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104429:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010442c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010442f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104434:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c0104437:	8b 45 14             	mov    0x14(%ebp),%eax
c010443a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010443d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104440:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104445:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0104448:	eb 68                	jmp    c01044b2 <boot_map_segment+0xfa>
        pte_t *ptep = get_pte(pgdir, la, 1);
c010444a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0104451:	00 
c0104452:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104455:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104459:	8b 45 08             	mov    0x8(%ebp),%eax
c010445c:	89 04 24             	mov    %eax,(%esp)
c010445f:	e8 88 01 00 00       	call   c01045ec <get_pte>
c0104464:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c0104467:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c010446b:	75 24                	jne    c0104491 <boot_map_segment+0xd9>
c010446d:	c7 44 24 0c 5e 6d 10 	movl   $0xc0106d5e,0xc(%esp)
c0104474:	c0 
c0104475:	c7 44 24 08 49 6d 10 	movl   $0xc0106d49,0x8(%esp)
c010447c:	c0 
c010447d:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
c0104484:	00 
c0104485:	c7 04 24 24 6d 10 c0 	movl   $0xc0106d24,(%esp)
c010448c:	e8 4a c8 ff ff       	call   c0100cdb <__panic>
        *ptep = pa | PTE_P | perm;
c0104491:	8b 45 14             	mov    0x14(%ebp),%eax
c0104494:	0b 45 18             	or     0x18(%ebp),%eax
c0104497:	83 c8 01             	or     $0x1,%eax
c010449a:	89 c2                	mov    %eax,%edx
c010449c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010449f:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01044a1:	ff 4d f4             	decl   -0xc(%ebp)
c01044a4:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c01044ab:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c01044b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01044b6:	75 92                	jne    c010444a <boot_map_segment+0x92>
    }
}
c01044b8:	90                   	nop
c01044b9:	90                   	nop
c01044ba:	89 ec                	mov    %ebp,%esp
c01044bc:	5d                   	pop    %ebp
c01044bd:	c3                   	ret    

c01044be <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c01044be:	55                   	push   %ebp
c01044bf:	89 e5                	mov    %esp,%ebp
c01044c1:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c01044c4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01044cb:	e8 8a fa ff ff       	call   c0103f5a <alloc_pages>
c01044d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c01044d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01044d7:	75 1c                	jne    c01044f5 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c01044d9:	c7 44 24 08 6b 6d 10 	movl   $0xc0106d6b,0x8(%esp)
c01044e0:	c0 
c01044e1:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
c01044e8:	00 
c01044e9:	c7 04 24 24 6d 10 c0 	movl   $0xc0106d24,(%esp)
c01044f0:	e8 e6 c7 ff ff       	call   c0100cdb <__panic>
    }
    return page2kva(p);
c01044f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044f8:	89 04 24             	mov    %eax,(%esp)
c01044fb:	e8 9a f7 ff ff       	call   c0103c9a <page2kva>
}
c0104500:	89 ec                	mov    %ebp,%esp
c0104502:	5d                   	pop    %ebp
c0104503:	c3                   	ret    

c0104504 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c0104504:	55                   	push   %ebp
c0104505:	89 e5                	mov    %esp,%ebp
c0104507:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
c010450a:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c010450f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104512:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0104519:	77 23                	ja     c010453e <pmm_init+0x3a>
c010451b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010451e:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104522:	c7 44 24 08 00 6d 10 	movl   $0xc0106d00,0x8(%esp)
c0104529:	c0 
c010452a:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c0104531:	00 
c0104532:	c7 04 24 24 6d 10 c0 	movl   $0xc0106d24,(%esp)
c0104539:	e8 9d c7 ff ff       	call   c0100cdb <__panic>
c010453e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104541:	05 00 00 00 40       	add    $0x40000000,%eax
c0104546:	a3 a8 ce 11 c0       	mov    %eax,0xc011cea8
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c010454b:	e8 b2 f9 ff ff       	call   c0103f02 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c0104550:	e8 a1 fa ff ff       	call   c0103ff6 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c0104555:	e8 ed 03 00 00       	call   c0104947 <check_alloc_page>

    check_pgdir();
c010455a:	e8 09 04 00 00       	call   c0104968 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c010455f:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104564:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104567:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c010456e:	77 23                	ja     c0104593 <pmm_init+0x8f>
c0104570:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104573:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104577:	c7 44 24 08 00 6d 10 	movl   $0xc0106d00,0x8(%esp)
c010457e:	c0 
c010457f:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
c0104586:	00 
c0104587:	c7 04 24 24 6d 10 c0 	movl   $0xc0106d24,(%esp)
c010458e:	e8 48 c7 ff ff       	call   c0100cdb <__panic>
c0104593:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104596:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
c010459c:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c01045a1:	05 ac 0f 00 00       	add    $0xfac,%eax
c01045a6:	83 ca 03             	or     $0x3,%edx
c01045a9:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c01045ab:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c01045b0:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c01045b7:	00 
c01045b8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01045bf:	00 
c01045c0:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c01045c7:	38 
c01045c8:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c01045cf:	c0 
c01045d0:	89 04 24             	mov    %eax,(%esp)
c01045d3:	e8 e0 fd ff ff       	call   c01043b8 <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c01045d8:	e8 39 f8 ff ff       	call   c0103e16 <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c01045dd:	e8 24 0a 00 00       	call   c0105006 <check_boot_pgdir>

    print_pgdir();
c01045e2:	e8 a1 0e 00 00       	call   c0105488 <print_pgdir>

}
c01045e7:	90                   	nop
c01045e8:	89 ec                	mov    %ebp,%esp
c01045ea:	5d                   	pop    %ebp
c01045eb:	c3                   	ret    

c01045ec <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c01045ec:	55                   	push   %ebp
c01045ed:	89 e5                	mov    %esp,%ebp
c01045ef:	83 ec 38             	sub    $0x38,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t *pdep = &pgdir[PDX(la)];
c01045f2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01045f5:	c1 e8 16             	shr    $0x16,%eax
c01045f8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01045ff:	8b 45 08             	mov    0x8(%ebp),%eax
c0104602:	01 d0                	add    %edx,%eax
c0104604:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (!(*pdep & PTE_P)) {
c0104607:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010460a:	8b 00                	mov    (%eax),%eax
c010460c:	83 e0 01             	and    $0x1,%eax
c010460f:	85 c0                	test   %eax,%eax
c0104611:	0f 85 af 00 00 00    	jne    c01046c6 <get_pte+0xda>
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL) {
c0104617:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010461b:	74 15                	je     c0104632 <get_pte+0x46>
c010461d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104624:	e8 31 f9 ff ff       	call   c0103f5a <alloc_pages>
c0104629:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010462c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104630:	75 0a                	jne    c010463c <get_pte+0x50>
            return NULL;
c0104632:	b8 00 00 00 00       	mov    $0x0,%eax
c0104637:	e9 e7 00 00 00       	jmp    c0104723 <get_pte+0x137>
        }
        set_page_ref(page, 1);
c010463c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104643:	00 
c0104644:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104647:	89 04 24             	mov    %eax,(%esp)
c010464a:	e8 05 f7 ff ff       	call   c0103d54 <set_page_ref>
        uintptr_t pa = page2pa(page);
c010464f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104652:	89 04 24             	mov    %eax,(%esp)
c0104655:	e8 d7 f5 ff ff       	call   c0103c31 <page2pa>
c010465a:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa), 0, PGSIZE);
c010465d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104660:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104663:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104666:	c1 e8 0c             	shr    $0xc,%eax
c0104669:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010466c:	a1 a4 ce 11 c0       	mov    0xc011cea4,%eax
c0104671:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0104674:	72 23                	jb     c0104699 <get_pte+0xad>
c0104676:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104679:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010467d:	c7 44 24 08 5c 6c 10 	movl   $0xc0106c5c,0x8(%esp)
c0104684:	c0 
c0104685:	c7 44 24 04 72 01 00 	movl   $0x172,0x4(%esp)
c010468c:	00 
c010468d:	c7 04 24 24 6d 10 c0 	movl   $0xc0106d24,(%esp)
c0104694:	e8 42 c6 ff ff       	call   c0100cdb <__panic>
c0104699:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010469c:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01046a1:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01046a8:	00 
c01046a9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01046b0:	00 
c01046b1:	89 04 24             	mov    %eax,(%esp)
c01046b4:	e8 d4 18 00 00       	call   c0105f8d <memset>
        *pdep = pa | PTE_U | PTE_W | PTE_P;
c01046b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01046bc:	83 c8 07             	or     $0x7,%eax
c01046bf:	89 c2                	mov    %eax,%edx
c01046c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046c4:	89 10                	mov    %edx,(%eax)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
c01046c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046c9:	8b 00                	mov    (%eax),%eax
c01046cb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01046d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01046d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01046d6:	c1 e8 0c             	shr    $0xc,%eax
c01046d9:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01046dc:	a1 a4 ce 11 c0       	mov    0xc011cea4,%eax
c01046e1:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01046e4:	72 23                	jb     c0104709 <get_pte+0x11d>
c01046e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01046e9:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01046ed:	c7 44 24 08 5c 6c 10 	movl   $0xc0106c5c,0x8(%esp)
c01046f4:	c0 
c01046f5:	c7 44 24 04 75 01 00 	movl   $0x175,0x4(%esp)
c01046fc:	00 
c01046fd:	c7 04 24 24 6d 10 c0 	movl   $0xc0106d24,(%esp)
c0104704:	e8 d2 c5 ff ff       	call   c0100cdb <__panic>
c0104709:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010470c:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104711:	89 c2                	mov    %eax,%edx
c0104713:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104716:	c1 e8 0c             	shr    $0xc,%eax
c0104719:	25 ff 03 00 00       	and    $0x3ff,%eax
c010471e:	c1 e0 02             	shl    $0x2,%eax
c0104721:	01 d0                	add    %edx,%eax
}
c0104723:	89 ec                	mov    %ebp,%esp
c0104725:	5d                   	pop    %ebp
c0104726:	c3                   	ret    

c0104727 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c0104727:	55                   	push   %ebp
c0104728:	89 e5                	mov    %esp,%ebp
c010472a:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c010472d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104734:	00 
c0104735:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104738:	89 44 24 04          	mov    %eax,0x4(%esp)
c010473c:	8b 45 08             	mov    0x8(%ebp),%eax
c010473f:	89 04 24             	mov    %eax,(%esp)
c0104742:	e8 a5 fe ff ff       	call   c01045ec <get_pte>
c0104747:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c010474a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010474e:	74 08                	je     c0104758 <get_page+0x31>
        *ptep_store = ptep;
c0104750:	8b 45 10             	mov    0x10(%ebp),%eax
c0104753:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104756:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c0104758:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010475c:	74 1b                	je     c0104779 <get_page+0x52>
c010475e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104761:	8b 00                	mov    (%eax),%eax
c0104763:	83 e0 01             	and    $0x1,%eax
c0104766:	85 c0                	test   %eax,%eax
c0104768:	74 0f                	je     c0104779 <get_page+0x52>
        return pte2page(*ptep);
c010476a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010476d:	8b 00                	mov    (%eax),%eax
c010476f:	89 04 24             	mov    %eax,(%esp)
c0104772:	e8 79 f5 ff ff       	call   c0103cf0 <pte2page>
c0104777:	eb 05                	jmp    c010477e <get_page+0x57>
    }
    return NULL;
c0104779:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010477e:	89 ec                	mov    %ebp,%esp
c0104780:	5d                   	pop    %ebp
c0104781:	c3                   	ret    

c0104782 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c0104782:	55                   	push   %ebp
c0104783:	89 e5                	mov    %esp,%ebp
c0104785:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    if (*ptep & PTE_P) {
c0104788:	8b 45 10             	mov    0x10(%ebp),%eax
c010478b:	8b 00                	mov    (%eax),%eax
c010478d:	83 e0 01             	and    $0x1,%eax
c0104790:	85 c0                	test   %eax,%eax
c0104792:	74 4d                	je     c01047e1 <page_remove_pte+0x5f>
        struct Page *page = pte2page(*ptep);
c0104794:	8b 45 10             	mov    0x10(%ebp),%eax
c0104797:	8b 00                	mov    (%eax),%eax
c0104799:	89 04 24             	mov    %eax,(%esp)
c010479c:	e8 4f f5 ff ff       	call   c0103cf0 <pte2page>
c01047a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (page_ref_dec(page) == 0) {
c01047a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047a7:	89 04 24             	mov    %eax,(%esp)
c01047aa:	e8 ca f5 ff ff       	call   c0103d79 <page_ref_dec>
c01047af:	85 c0                	test   %eax,%eax
c01047b1:	75 13                	jne    c01047c6 <page_remove_pte+0x44>
            free_page(page);
c01047b3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01047ba:	00 
c01047bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047be:	89 04 24             	mov    %eax,(%esp)
c01047c1:	e8 ce f7 ff ff       	call   c0103f94 <free_pages>
        }
        *ptep = 0;
c01047c6:	8b 45 10             	mov    0x10(%ebp),%eax
c01047c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la);
c01047cf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01047d2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01047d6:	8b 45 08             	mov    0x8(%ebp),%eax
c01047d9:	89 04 24             	mov    %eax,(%esp)
c01047dc:	e8 07 01 00 00       	call   c01048e8 <tlb_invalidate>
    }
}
c01047e1:	90                   	nop
c01047e2:	89 ec                	mov    %ebp,%esp
c01047e4:	5d                   	pop    %ebp
c01047e5:	c3                   	ret    

c01047e6 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c01047e6:	55                   	push   %ebp
c01047e7:	89 e5                	mov    %esp,%ebp
c01047e9:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01047ec:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01047f3:	00 
c01047f4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01047f7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01047fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01047fe:	89 04 24             	mov    %eax,(%esp)
c0104801:	e8 e6 fd ff ff       	call   c01045ec <get_pte>
c0104806:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c0104809:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010480d:	74 19                	je     c0104828 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c010480f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104812:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104816:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104819:	89 44 24 04          	mov    %eax,0x4(%esp)
c010481d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104820:	89 04 24             	mov    %eax,(%esp)
c0104823:	e8 5a ff ff ff       	call   c0104782 <page_remove_pte>
    }
}
c0104828:	90                   	nop
c0104829:	89 ec                	mov    %ebp,%esp
c010482b:	5d                   	pop    %ebp
c010482c:	c3                   	ret    

c010482d <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c010482d:	55                   	push   %ebp
c010482e:	89 e5                	mov    %esp,%ebp
c0104830:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c0104833:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c010483a:	00 
c010483b:	8b 45 10             	mov    0x10(%ebp),%eax
c010483e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104842:	8b 45 08             	mov    0x8(%ebp),%eax
c0104845:	89 04 24             	mov    %eax,(%esp)
c0104848:	e8 9f fd ff ff       	call   c01045ec <get_pte>
c010484d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c0104850:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104854:	75 0a                	jne    c0104860 <page_insert+0x33>
        return -E_NO_MEM;
c0104856:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c010485b:	e9 84 00 00 00       	jmp    c01048e4 <page_insert+0xb7>
    }
    page_ref_inc(page);
c0104860:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104863:	89 04 24             	mov    %eax,(%esp)
c0104866:	e8 f7 f4 ff ff       	call   c0103d62 <page_ref_inc>
    if (*ptep & PTE_P) {
c010486b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010486e:	8b 00                	mov    (%eax),%eax
c0104870:	83 e0 01             	and    $0x1,%eax
c0104873:	85 c0                	test   %eax,%eax
c0104875:	74 3e                	je     c01048b5 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c0104877:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010487a:	8b 00                	mov    (%eax),%eax
c010487c:	89 04 24             	mov    %eax,(%esp)
c010487f:	e8 6c f4 ff ff       	call   c0103cf0 <pte2page>
c0104884:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c0104887:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010488a:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010488d:	75 0d                	jne    c010489c <page_insert+0x6f>
            page_ref_dec(page);
c010488f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104892:	89 04 24             	mov    %eax,(%esp)
c0104895:	e8 df f4 ff ff       	call   c0103d79 <page_ref_dec>
c010489a:	eb 19                	jmp    c01048b5 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c010489c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010489f:	89 44 24 08          	mov    %eax,0x8(%esp)
c01048a3:	8b 45 10             	mov    0x10(%ebp),%eax
c01048a6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01048aa:	8b 45 08             	mov    0x8(%ebp),%eax
c01048ad:	89 04 24             	mov    %eax,(%esp)
c01048b0:	e8 cd fe ff ff       	call   c0104782 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c01048b5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01048b8:	89 04 24             	mov    %eax,(%esp)
c01048bb:	e8 71 f3 ff ff       	call   c0103c31 <page2pa>
c01048c0:	0b 45 14             	or     0x14(%ebp),%eax
c01048c3:	83 c8 01             	or     $0x1,%eax
c01048c6:	89 c2                	mov    %eax,%edx
c01048c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048cb:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c01048cd:	8b 45 10             	mov    0x10(%ebp),%eax
c01048d0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01048d4:	8b 45 08             	mov    0x8(%ebp),%eax
c01048d7:	89 04 24             	mov    %eax,(%esp)
c01048da:	e8 09 00 00 00       	call   c01048e8 <tlb_invalidate>
    return 0;
c01048df:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01048e4:	89 ec                	mov    %ebp,%esp
c01048e6:	5d                   	pop    %ebp
c01048e7:	c3                   	ret    

c01048e8 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c01048e8:	55                   	push   %ebp
c01048e9:	89 e5                	mov    %esp,%ebp
c01048eb:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c01048ee:	0f 20 d8             	mov    %cr3,%eax
c01048f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c01048f4:	8b 55 f0             	mov    -0x10(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
c01048f7:	8b 45 08             	mov    0x8(%ebp),%eax
c01048fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01048fd:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0104904:	77 23                	ja     c0104929 <tlb_invalidate+0x41>
c0104906:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104909:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010490d:	c7 44 24 08 00 6d 10 	movl   $0xc0106d00,0x8(%esp)
c0104914:	c0 
c0104915:	c7 44 24 04 d7 01 00 	movl   $0x1d7,0x4(%esp)
c010491c:	00 
c010491d:	c7 04 24 24 6d 10 c0 	movl   $0xc0106d24,(%esp)
c0104924:	e8 b2 c3 ff ff       	call   c0100cdb <__panic>
c0104929:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010492c:	05 00 00 00 40       	add    $0x40000000,%eax
c0104931:	39 d0                	cmp    %edx,%eax
c0104933:	75 0d                	jne    c0104942 <tlb_invalidate+0x5a>
        invlpg((void *)la);
c0104935:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104938:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c010493b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010493e:	0f 01 38             	invlpg (%eax)
}
c0104941:	90                   	nop
    }
}
c0104942:	90                   	nop
c0104943:	89 ec                	mov    %ebp,%esp
c0104945:	5d                   	pop    %ebp
c0104946:	c3                   	ret    

c0104947 <check_alloc_page>:

static void
check_alloc_page(void) {
c0104947:	55                   	push   %ebp
c0104948:	89 e5                	mov    %esp,%ebp
c010494a:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c010494d:	a1 ac ce 11 c0       	mov    0xc011ceac,%eax
c0104952:	8b 40 18             	mov    0x18(%eax),%eax
c0104955:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c0104957:	c7 04 24 84 6d 10 c0 	movl   $0xc0106d84,(%esp)
c010495e:	e8 f3 b9 ff ff       	call   c0100356 <cprintf>
}
c0104963:	90                   	nop
c0104964:	89 ec                	mov    %ebp,%esp
c0104966:	5d                   	pop    %ebp
c0104967:	c3                   	ret    

c0104968 <check_pgdir>:

static void
check_pgdir(void) {
c0104968:	55                   	push   %ebp
c0104969:	89 e5                	mov    %esp,%ebp
c010496b:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c010496e:	a1 a4 ce 11 c0       	mov    0xc011cea4,%eax
c0104973:	3d 00 80 03 00       	cmp    $0x38000,%eax
c0104978:	76 24                	jbe    c010499e <check_pgdir+0x36>
c010497a:	c7 44 24 0c a3 6d 10 	movl   $0xc0106da3,0xc(%esp)
c0104981:	c0 
c0104982:	c7 44 24 08 49 6d 10 	movl   $0xc0106d49,0x8(%esp)
c0104989:	c0 
c010498a:	c7 44 24 04 e4 01 00 	movl   $0x1e4,0x4(%esp)
c0104991:	00 
c0104992:	c7 04 24 24 6d 10 c0 	movl   $0xc0106d24,(%esp)
c0104999:	e8 3d c3 ff ff       	call   c0100cdb <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c010499e:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c01049a3:	85 c0                	test   %eax,%eax
c01049a5:	74 0e                	je     c01049b5 <check_pgdir+0x4d>
c01049a7:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c01049ac:	25 ff 0f 00 00       	and    $0xfff,%eax
c01049b1:	85 c0                	test   %eax,%eax
c01049b3:	74 24                	je     c01049d9 <check_pgdir+0x71>
c01049b5:	c7 44 24 0c c0 6d 10 	movl   $0xc0106dc0,0xc(%esp)
c01049bc:	c0 
c01049bd:	c7 44 24 08 49 6d 10 	movl   $0xc0106d49,0x8(%esp)
c01049c4:	c0 
c01049c5:	c7 44 24 04 e5 01 00 	movl   $0x1e5,0x4(%esp)
c01049cc:	00 
c01049cd:	c7 04 24 24 6d 10 c0 	movl   $0xc0106d24,(%esp)
c01049d4:	e8 02 c3 ff ff       	call   c0100cdb <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c01049d9:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c01049de:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01049e5:	00 
c01049e6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01049ed:	00 
c01049ee:	89 04 24             	mov    %eax,(%esp)
c01049f1:	e8 31 fd ff ff       	call   c0104727 <get_page>
c01049f6:	85 c0                	test   %eax,%eax
c01049f8:	74 24                	je     c0104a1e <check_pgdir+0xb6>
c01049fa:	c7 44 24 0c f8 6d 10 	movl   $0xc0106df8,0xc(%esp)
c0104a01:	c0 
c0104a02:	c7 44 24 08 49 6d 10 	movl   $0xc0106d49,0x8(%esp)
c0104a09:	c0 
c0104a0a:	c7 44 24 04 e6 01 00 	movl   $0x1e6,0x4(%esp)
c0104a11:	00 
c0104a12:	c7 04 24 24 6d 10 c0 	movl   $0xc0106d24,(%esp)
c0104a19:	e8 bd c2 ff ff       	call   c0100cdb <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c0104a1e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104a25:	e8 30 f5 ff ff       	call   c0103f5a <alloc_pages>
c0104a2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c0104a2d:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104a32:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104a39:	00 
c0104a3a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104a41:	00 
c0104a42:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104a45:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104a49:	89 04 24             	mov    %eax,(%esp)
c0104a4c:	e8 dc fd ff ff       	call   c010482d <page_insert>
c0104a51:	85 c0                	test   %eax,%eax
c0104a53:	74 24                	je     c0104a79 <check_pgdir+0x111>
c0104a55:	c7 44 24 0c 20 6e 10 	movl   $0xc0106e20,0xc(%esp)
c0104a5c:	c0 
c0104a5d:	c7 44 24 08 49 6d 10 	movl   $0xc0106d49,0x8(%esp)
c0104a64:	c0 
c0104a65:	c7 44 24 04 ea 01 00 	movl   $0x1ea,0x4(%esp)
c0104a6c:	00 
c0104a6d:	c7 04 24 24 6d 10 c0 	movl   $0xc0106d24,(%esp)
c0104a74:	e8 62 c2 ff ff       	call   c0100cdb <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c0104a79:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104a7e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104a85:	00 
c0104a86:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104a8d:	00 
c0104a8e:	89 04 24             	mov    %eax,(%esp)
c0104a91:	e8 56 fb ff ff       	call   c01045ec <get_pte>
c0104a96:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104a99:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104a9d:	75 24                	jne    c0104ac3 <check_pgdir+0x15b>
c0104a9f:	c7 44 24 0c 4c 6e 10 	movl   $0xc0106e4c,0xc(%esp)
c0104aa6:	c0 
c0104aa7:	c7 44 24 08 49 6d 10 	movl   $0xc0106d49,0x8(%esp)
c0104aae:	c0 
c0104aaf:	c7 44 24 04 ed 01 00 	movl   $0x1ed,0x4(%esp)
c0104ab6:	00 
c0104ab7:	c7 04 24 24 6d 10 c0 	movl   $0xc0106d24,(%esp)
c0104abe:	e8 18 c2 ff ff       	call   c0100cdb <__panic>
    assert(pte2page(*ptep) == p1);
c0104ac3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ac6:	8b 00                	mov    (%eax),%eax
c0104ac8:	89 04 24             	mov    %eax,(%esp)
c0104acb:	e8 20 f2 ff ff       	call   c0103cf0 <pte2page>
c0104ad0:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0104ad3:	74 24                	je     c0104af9 <check_pgdir+0x191>
c0104ad5:	c7 44 24 0c 79 6e 10 	movl   $0xc0106e79,0xc(%esp)
c0104adc:	c0 
c0104add:	c7 44 24 08 49 6d 10 	movl   $0xc0106d49,0x8(%esp)
c0104ae4:	c0 
c0104ae5:	c7 44 24 04 ee 01 00 	movl   $0x1ee,0x4(%esp)
c0104aec:	00 
c0104aed:	c7 04 24 24 6d 10 c0 	movl   $0xc0106d24,(%esp)
c0104af4:	e8 e2 c1 ff ff       	call   c0100cdb <__panic>
    assert(page_ref(p1) == 1);
c0104af9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104afc:	89 04 24             	mov    %eax,(%esp)
c0104aff:	e8 46 f2 ff ff       	call   c0103d4a <page_ref>
c0104b04:	83 f8 01             	cmp    $0x1,%eax
c0104b07:	74 24                	je     c0104b2d <check_pgdir+0x1c5>
c0104b09:	c7 44 24 0c 8f 6e 10 	movl   $0xc0106e8f,0xc(%esp)
c0104b10:	c0 
c0104b11:	c7 44 24 08 49 6d 10 	movl   $0xc0106d49,0x8(%esp)
c0104b18:	c0 
c0104b19:	c7 44 24 04 ef 01 00 	movl   $0x1ef,0x4(%esp)
c0104b20:	00 
c0104b21:	c7 04 24 24 6d 10 c0 	movl   $0xc0106d24,(%esp)
c0104b28:	e8 ae c1 ff ff       	call   c0100cdb <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0104b2d:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104b32:	8b 00                	mov    (%eax),%eax
c0104b34:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104b39:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104b3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104b3f:	c1 e8 0c             	shr    $0xc,%eax
c0104b42:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104b45:	a1 a4 ce 11 c0       	mov    0xc011cea4,%eax
c0104b4a:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0104b4d:	72 23                	jb     c0104b72 <check_pgdir+0x20a>
c0104b4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104b52:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104b56:	c7 44 24 08 5c 6c 10 	movl   $0xc0106c5c,0x8(%esp)
c0104b5d:	c0 
c0104b5e:	c7 44 24 04 f1 01 00 	movl   $0x1f1,0x4(%esp)
c0104b65:	00 
c0104b66:	c7 04 24 24 6d 10 c0 	movl   $0xc0106d24,(%esp)
c0104b6d:	e8 69 c1 ff ff       	call   c0100cdb <__panic>
c0104b72:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104b75:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104b7a:	83 c0 04             	add    $0x4,%eax
c0104b7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c0104b80:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104b85:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104b8c:	00 
c0104b8d:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104b94:	00 
c0104b95:	89 04 24             	mov    %eax,(%esp)
c0104b98:	e8 4f fa ff ff       	call   c01045ec <get_pte>
c0104b9d:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0104ba0:	74 24                	je     c0104bc6 <check_pgdir+0x25e>
c0104ba2:	c7 44 24 0c a4 6e 10 	movl   $0xc0106ea4,0xc(%esp)
c0104ba9:	c0 
c0104baa:	c7 44 24 08 49 6d 10 	movl   $0xc0106d49,0x8(%esp)
c0104bb1:	c0 
c0104bb2:	c7 44 24 04 f2 01 00 	movl   $0x1f2,0x4(%esp)
c0104bb9:	00 
c0104bba:	c7 04 24 24 6d 10 c0 	movl   $0xc0106d24,(%esp)
c0104bc1:	e8 15 c1 ff ff       	call   c0100cdb <__panic>

    p2 = alloc_page();
c0104bc6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104bcd:	e8 88 f3 ff ff       	call   c0103f5a <alloc_pages>
c0104bd2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0104bd5:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104bda:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c0104be1:	00 
c0104be2:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104be9:	00 
c0104bea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104bed:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104bf1:	89 04 24             	mov    %eax,(%esp)
c0104bf4:	e8 34 fc ff ff       	call   c010482d <page_insert>
c0104bf9:	85 c0                	test   %eax,%eax
c0104bfb:	74 24                	je     c0104c21 <check_pgdir+0x2b9>
c0104bfd:	c7 44 24 0c cc 6e 10 	movl   $0xc0106ecc,0xc(%esp)
c0104c04:	c0 
c0104c05:	c7 44 24 08 49 6d 10 	movl   $0xc0106d49,0x8(%esp)
c0104c0c:	c0 
c0104c0d:	c7 44 24 04 f5 01 00 	movl   $0x1f5,0x4(%esp)
c0104c14:	00 
c0104c15:	c7 04 24 24 6d 10 c0 	movl   $0xc0106d24,(%esp)
c0104c1c:	e8 ba c0 ff ff       	call   c0100cdb <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104c21:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104c26:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104c2d:	00 
c0104c2e:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104c35:	00 
c0104c36:	89 04 24             	mov    %eax,(%esp)
c0104c39:	e8 ae f9 ff ff       	call   c01045ec <get_pte>
c0104c3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104c41:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104c45:	75 24                	jne    c0104c6b <check_pgdir+0x303>
c0104c47:	c7 44 24 0c 04 6f 10 	movl   $0xc0106f04,0xc(%esp)
c0104c4e:	c0 
c0104c4f:	c7 44 24 08 49 6d 10 	movl   $0xc0106d49,0x8(%esp)
c0104c56:	c0 
c0104c57:	c7 44 24 04 f6 01 00 	movl   $0x1f6,0x4(%esp)
c0104c5e:	00 
c0104c5f:	c7 04 24 24 6d 10 c0 	movl   $0xc0106d24,(%esp)
c0104c66:	e8 70 c0 ff ff       	call   c0100cdb <__panic>
    assert(*ptep & PTE_U);
c0104c6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c6e:	8b 00                	mov    (%eax),%eax
c0104c70:	83 e0 04             	and    $0x4,%eax
c0104c73:	85 c0                	test   %eax,%eax
c0104c75:	75 24                	jne    c0104c9b <check_pgdir+0x333>
c0104c77:	c7 44 24 0c 34 6f 10 	movl   $0xc0106f34,0xc(%esp)
c0104c7e:	c0 
c0104c7f:	c7 44 24 08 49 6d 10 	movl   $0xc0106d49,0x8(%esp)
c0104c86:	c0 
c0104c87:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
c0104c8e:	00 
c0104c8f:	c7 04 24 24 6d 10 c0 	movl   $0xc0106d24,(%esp)
c0104c96:	e8 40 c0 ff ff       	call   c0100cdb <__panic>
    assert(*ptep & PTE_W);
c0104c9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c9e:	8b 00                	mov    (%eax),%eax
c0104ca0:	83 e0 02             	and    $0x2,%eax
c0104ca3:	85 c0                	test   %eax,%eax
c0104ca5:	75 24                	jne    c0104ccb <check_pgdir+0x363>
c0104ca7:	c7 44 24 0c 42 6f 10 	movl   $0xc0106f42,0xc(%esp)
c0104cae:	c0 
c0104caf:	c7 44 24 08 49 6d 10 	movl   $0xc0106d49,0x8(%esp)
c0104cb6:	c0 
c0104cb7:	c7 44 24 04 f8 01 00 	movl   $0x1f8,0x4(%esp)
c0104cbe:	00 
c0104cbf:	c7 04 24 24 6d 10 c0 	movl   $0xc0106d24,(%esp)
c0104cc6:	e8 10 c0 ff ff       	call   c0100cdb <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0104ccb:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104cd0:	8b 00                	mov    (%eax),%eax
c0104cd2:	83 e0 04             	and    $0x4,%eax
c0104cd5:	85 c0                	test   %eax,%eax
c0104cd7:	75 24                	jne    c0104cfd <check_pgdir+0x395>
c0104cd9:	c7 44 24 0c 50 6f 10 	movl   $0xc0106f50,0xc(%esp)
c0104ce0:	c0 
c0104ce1:	c7 44 24 08 49 6d 10 	movl   $0xc0106d49,0x8(%esp)
c0104ce8:	c0 
c0104ce9:	c7 44 24 04 f9 01 00 	movl   $0x1f9,0x4(%esp)
c0104cf0:	00 
c0104cf1:	c7 04 24 24 6d 10 c0 	movl   $0xc0106d24,(%esp)
c0104cf8:	e8 de bf ff ff       	call   c0100cdb <__panic>
    assert(page_ref(p2) == 1);
c0104cfd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104d00:	89 04 24             	mov    %eax,(%esp)
c0104d03:	e8 42 f0 ff ff       	call   c0103d4a <page_ref>
c0104d08:	83 f8 01             	cmp    $0x1,%eax
c0104d0b:	74 24                	je     c0104d31 <check_pgdir+0x3c9>
c0104d0d:	c7 44 24 0c 66 6f 10 	movl   $0xc0106f66,0xc(%esp)
c0104d14:	c0 
c0104d15:	c7 44 24 08 49 6d 10 	movl   $0xc0106d49,0x8(%esp)
c0104d1c:	c0 
c0104d1d:	c7 44 24 04 fa 01 00 	movl   $0x1fa,0x4(%esp)
c0104d24:	00 
c0104d25:	c7 04 24 24 6d 10 c0 	movl   $0xc0106d24,(%esp)
c0104d2c:	e8 aa bf ff ff       	call   c0100cdb <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0104d31:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104d36:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104d3d:	00 
c0104d3e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104d45:	00 
c0104d46:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104d49:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104d4d:	89 04 24             	mov    %eax,(%esp)
c0104d50:	e8 d8 fa ff ff       	call   c010482d <page_insert>
c0104d55:	85 c0                	test   %eax,%eax
c0104d57:	74 24                	je     c0104d7d <check_pgdir+0x415>
c0104d59:	c7 44 24 0c 78 6f 10 	movl   $0xc0106f78,0xc(%esp)
c0104d60:	c0 
c0104d61:	c7 44 24 08 49 6d 10 	movl   $0xc0106d49,0x8(%esp)
c0104d68:	c0 
c0104d69:	c7 44 24 04 fc 01 00 	movl   $0x1fc,0x4(%esp)
c0104d70:	00 
c0104d71:	c7 04 24 24 6d 10 c0 	movl   $0xc0106d24,(%esp)
c0104d78:	e8 5e bf ff ff       	call   c0100cdb <__panic>
    assert(page_ref(p1) == 2);
c0104d7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d80:	89 04 24             	mov    %eax,(%esp)
c0104d83:	e8 c2 ef ff ff       	call   c0103d4a <page_ref>
c0104d88:	83 f8 02             	cmp    $0x2,%eax
c0104d8b:	74 24                	je     c0104db1 <check_pgdir+0x449>
c0104d8d:	c7 44 24 0c a4 6f 10 	movl   $0xc0106fa4,0xc(%esp)
c0104d94:	c0 
c0104d95:	c7 44 24 08 49 6d 10 	movl   $0xc0106d49,0x8(%esp)
c0104d9c:	c0 
c0104d9d:	c7 44 24 04 fd 01 00 	movl   $0x1fd,0x4(%esp)
c0104da4:	00 
c0104da5:	c7 04 24 24 6d 10 c0 	movl   $0xc0106d24,(%esp)
c0104dac:	e8 2a bf ff ff       	call   c0100cdb <__panic>
    assert(page_ref(p2) == 0);
c0104db1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104db4:	89 04 24             	mov    %eax,(%esp)
c0104db7:	e8 8e ef ff ff       	call   c0103d4a <page_ref>
c0104dbc:	85 c0                	test   %eax,%eax
c0104dbe:	74 24                	je     c0104de4 <check_pgdir+0x47c>
c0104dc0:	c7 44 24 0c b6 6f 10 	movl   $0xc0106fb6,0xc(%esp)
c0104dc7:	c0 
c0104dc8:	c7 44 24 08 49 6d 10 	movl   $0xc0106d49,0x8(%esp)
c0104dcf:	c0 
c0104dd0:	c7 44 24 04 fe 01 00 	movl   $0x1fe,0x4(%esp)
c0104dd7:	00 
c0104dd8:	c7 04 24 24 6d 10 c0 	movl   $0xc0106d24,(%esp)
c0104ddf:	e8 f7 be ff ff       	call   c0100cdb <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104de4:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104de9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104df0:	00 
c0104df1:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104df8:	00 
c0104df9:	89 04 24             	mov    %eax,(%esp)
c0104dfc:	e8 eb f7 ff ff       	call   c01045ec <get_pte>
c0104e01:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104e04:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104e08:	75 24                	jne    c0104e2e <check_pgdir+0x4c6>
c0104e0a:	c7 44 24 0c 04 6f 10 	movl   $0xc0106f04,0xc(%esp)
c0104e11:	c0 
c0104e12:	c7 44 24 08 49 6d 10 	movl   $0xc0106d49,0x8(%esp)
c0104e19:	c0 
c0104e1a:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
c0104e21:	00 
c0104e22:	c7 04 24 24 6d 10 c0 	movl   $0xc0106d24,(%esp)
c0104e29:	e8 ad be ff ff       	call   c0100cdb <__panic>
    assert(pte2page(*ptep) == p1);
c0104e2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e31:	8b 00                	mov    (%eax),%eax
c0104e33:	89 04 24             	mov    %eax,(%esp)
c0104e36:	e8 b5 ee ff ff       	call   c0103cf0 <pte2page>
c0104e3b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0104e3e:	74 24                	je     c0104e64 <check_pgdir+0x4fc>
c0104e40:	c7 44 24 0c 79 6e 10 	movl   $0xc0106e79,0xc(%esp)
c0104e47:	c0 
c0104e48:	c7 44 24 08 49 6d 10 	movl   $0xc0106d49,0x8(%esp)
c0104e4f:	c0 
c0104e50:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
c0104e57:	00 
c0104e58:	c7 04 24 24 6d 10 c0 	movl   $0xc0106d24,(%esp)
c0104e5f:	e8 77 be ff ff       	call   c0100cdb <__panic>
    assert((*ptep & PTE_U) == 0);
c0104e64:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e67:	8b 00                	mov    (%eax),%eax
c0104e69:	83 e0 04             	and    $0x4,%eax
c0104e6c:	85 c0                	test   %eax,%eax
c0104e6e:	74 24                	je     c0104e94 <check_pgdir+0x52c>
c0104e70:	c7 44 24 0c c8 6f 10 	movl   $0xc0106fc8,0xc(%esp)
c0104e77:	c0 
c0104e78:	c7 44 24 08 49 6d 10 	movl   $0xc0106d49,0x8(%esp)
c0104e7f:	c0 
c0104e80:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
c0104e87:	00 
c0104e88:	c7 04 24 24 6d 10 c0 	movl   $0xc0106d24,(%esp)
c0104e8f:	e8 47 be ff ff       	call   c0100cdb <__panic>

    page_remove(boot_pgdir, 0x0);
c0104e94:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104e99:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104ea0:	00 
c0104ea1:	89 04 24             	mov    %eax,(%esp)
c0104ea4:	e8 3d f9 ff ff       	call   c01047e6 <page_remove>
    assert(page_ref(p1) == 1);
c0104ea9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104eac:	89 04 24             	mov    %eax,(%esp)
c0104eaf:	e8 96 ee ff ff       	call   c0103d4a <page_ref>
c0104eb4:	83 f8 01             	cmp    $0x1,%eax
c0104eb7:	74 24                	je     c0104edd <check_pgdir+0x575>
c0104eb9:	c7 44 24 0c 8f 6e 10 	movl   $0xc0106e8f,0xc(%esp)
c0104ec0:	c0 
c0104ec1:	c7 44 24 08 49 6d 10 	movl   $0xc0106d49,0x8(%esp)
c0104ec8:	c0 
c0104ec9:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
c0104ed0:	00 
c0104ed1:	c7 04 24 24 6d 10 c0 	movl   $0xc0106d24,(%esp)
c0104ed8:	e8 fe bd ff ff       	call   c0100cdb <__panic>
    assert(page_ref(p2) == 0);
c0104edd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104ee0:	89 04 24             	mov    %eax,(%esp)
c0104ee3:	e8 62 ee ff ff       	call   c0103d4a <page_ref>
c0104ee8:	85 c0                	test   %eax,%eax
c0104eea:	74 24                	je     c0104f10 <check_pgdir+0x5a8>
c0104eec:	c7 44 24 0c b6 6f 10 	movl   $0xc0106fb6,0xc(%esp)
c0104ef3:	c0 
c0104ef4:	c7 44 24 08 49 6d 10 	movl   $0xc0106d49,0x8(%esp)
c0104efb:	c0 
c0104efc:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
c0104f03:	00 
c0104f04:	c7 04 24 24 6d 10 c0 	movl   $0xc0106d24,(%esp)
c0104f0b:	e8 cb bd ff ff       	call   c0100cdb <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0104f10:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104f15:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104f1c:	00 
c0104f1d:	89 04 24             	mov    %eax,(%esp)
c0104f20:	e8 c1 f8 ff ff       	call   c01047e6 <page_remove>
    assert(page_ref(p1) == 0);
c0104f25:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f28:	89 04 24             	mov    %eax,(%esp)
c0104f2b:	e8 1a ee ff ff       	call   c0103d4a <page_ref>
c0104f30:	85 c0                	test   %eax,%eax
c0104f32:	74 24                	je     c0104f58 <check_pgdir+0x5f0>
c0104f34:	c7 44 24 0c dd 6f 10 	movl   $0xc0106fdd,0xc(%esp)
c0104f3b:	c0 
c0104f3c:	c7 44 24 08 49 6d 10 	movl   $0xc0106d49,0x8(%esp)
c0104f43:	c0 
c0104f44:	c7 44 24 04 08 02 00 	movl   $0x208,0x4(%esp)
c0104f4b:	00 
c0104f4c:	c7 04 24 24 6d 10 c0 	movl   $0xc0106d24,(%esp)
c0104f53:	e8 83 bd ff ff       	call   c0100cdb <__panic>
    assert(page_ref(p2) == 0);
c0104f58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104f5b:	89 04 24             	mov    %eax,(%esp)
c0104f5e:	e8 e7 ed ff ff       	call   c0103d4a <page_ref>
c0104f63:	85 c0                	test   %eax,%eax
c0104f65:	74 24                	je     c0104f8b <check_pgdir+0x623>
c0104f67:	c7 44 24 0c b6 6f 10 	movl   $0xc0106fb6,0xc(%esp)
c0104f6e:	c0 
c0104f6f:	c7 44 24 08 49 6d 10 	movl   $0xc0106d49,0x8(%esp)
c0104f76:	c0 
c0104f77:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
c0104f7e:	00 
c0104f7f:	c7 04 24 24 6d 10 c0 	movl   $0xc0106d24,(%esp)
c0104f86:	e8 50 bd ff ff       	call   c0100cdb <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c0104f8b:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104f90:	8b 00                	mov    (%eax),%eax
c0104f92:	89 04 24             	mov    %eax,(%esp)
c0104f95:	e8 96 ed ff ff       	call   c0103d30 <pde2page>
c0104f9a:	89 04 24             	mov    %eax,(%esp)
c0104f9d:	e8 a8 ed ff ff       	call   c0103d4a <page_ref>
c0104fa2:	83 f8 01             	cmp    $0x1,%eax
c0104fa5:	74 24                	je     c0104fcb <check_pgdir+0x663>
c0104fa7:	c7 44 24 0c f0 6f 10 	movl   $0xc0106ff0,0xc(%esp)
c0104fae:	c0 
c0104faf:	c7 44 24 08 49 6d 10 	movl   $0xc0106d49,0x8(%esp)
c0104fb6:	c0 
c0104fb7:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
c0104fbe:	00 
c0104fbf:	c7 04 24 24 6d 10 c0 	movl   $0xc0106d24,(%esp)
c0104fc6:	e8 10 bd ff ff       	call   c0100cdb <__panic>
    free_page(pde2page(boot_pgdir[0]));
c0104fcb:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104fd0:	8b 00                	mov    (%eax),%eax
c0104fd2:	89 04 24             	mov    %eax,(%esp)
c0104fd5:	e8 56 ed ff ff       	call   c0103d30 <pde2page>
c0104fda:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104fe1:	00 
c0104fe2:	89 04 24             	mov    %eax,(%esp)
c0104fe5:	e8 aa ef ff ff       	call   c0103f94 <free_pages>
    boot_pgdir[0] = 0;
c0104fea:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104fef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0104ff5:	c7 04 24 17 70 10 c0 	movl   $0xc0107017,(%esp)
c0104ffc:	e8 55 b3 ff ff       	call   c0100356 <cprintf>
}
c0105001:	90                   	nop
c0105002:	89 ec                	mov    %ebp,%esp
c0105004:	5d                   	pop    %ebp
c0105005:	c3                   	ret    

c0105006 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0105006:	55                   	push   %ebp
c0105007:	89 e5                	mov    %esp,%ebp
c0105009:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c010500c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0105013:	e9 ca 00 00 00       	jmp    c01050e2 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0105018:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010501b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010501e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105021:	c1 e8 0c             	shr    $0xc,%eax
c0105024:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105027:	a1 a4 ce 11 c0       	mov    0xc011cea4,%eax
c010502c:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c010502f:	72 23                	jb     c0105054 <check_boot_pgdir+0x4e>
c0105031:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105034:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105038:	c7 44 24 08 5c 6c 10 	movl   $0xc0106c5c,0x8(%esp)
c010503f:	c0 
c0105040:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
c0105047:	00 
c0105048:	c7 04 24 24 6d 10 c0 	movl   $0xc0106d24,(%esp)
c010504f:	e8 87 bc ff ff       	call   c0100cdb <__panic>
c0105054:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105057:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010505c:	89 c2                	mov    %eax,%edx
c010505e:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0105063:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010506a:	00 
c010506b:	89 54 24 04          	mov    %edx,0x4(%esp)
c010506f:	89 04 24             	mov    %eax,(%esp)
c0105072:	e8 75 f5 ff ff       	call   c01045ec <get_pte>
c0105077:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010507a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c010507e:	75 24                	jne    c01050a4 <check_boot_pgdir+0x9e>
c0105080:	c7 44 24 0c 34 70 10 	movl   $0xc0107034,0xc(%esp)
c0105087:	c0 
c0105088:	c7 44 24 08 49 6d 10 	movl   $0xc0106d49,0x8(%esp)
c010508f:	c0 
c0105090:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
c0105097:	00 
c0105098:	c7 04 24 24 6d 10 c0 	movl   $0xc0106d24,(%esp)
c010509f:	e8 37 bc ff ff       	call   c0100cdb <__panic>
        assert(PTE_ADDR(*ptep) == i);
c01050a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01050a7:	8b 00                	mov    (%eax),%eax
c01050a9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01050ae:	89 c2                	mov    %eax,%edx
c01050b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01050b3:	39 c2                	cmp    %eax,%edx
c01050b5:	74 24                	je     c01050db <check_boot_pgdir+0xd5>
c01050b7:	c7 44 24 0c 71 70 10 	movl   $0xc0107071,0xc(%esp)
c01050be:	c0 
c01050bf:	c7 44 24 08 49 6d 10 	movl   $0xc0106d49,0x8(%esp)
c01050c6:	c0 
c01050c7:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
c01050ce:	00 
c01050cf:	c7 04 24 24 6d 10 c0 	movl   $0xc0106d24,(%esp)
c01050d6:	e8 00 bc ff ff       	call   c0100cdb <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
c01050db:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c01050e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01050e5:	a1 a4 ce 11 c0       	mov    0xc011cea4,%eax
c01050ea:	39 c2                	cmp    %eax,%edx
c01050ec:	0f 82 26 ff ff ff    	jb     c0105018 <check_boot_pgdir+0x12>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c01050f2:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c01050f7:	05 ac 0f 00 00       	add    $0xfac,%eax
c01050fc:	8b 00                	mov    (%eax),%eax
c01050fe:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105103:	89 c2                	mov    %eax,%edx
c0105105:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c010510a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010510d:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0105114:	77 23                	ja     c0105139 <check_boot_pgdir+0x133>
c0105116:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105119:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010511d:	c7 44 24 08 00 6d 10 	movl   $0xc0106d00,0x8(%esp)
c0105124:	c0 
c0105125:	c7 44 24 04 1b 02 00 	movl   $0x21b,0x4(%esp)
c010512c:	00 
c010512d:	c7 04 24 24 6d 10 c0 	movl   $0xc0106d24,(%esp)
c0105134:	e8 a2 bb ff ff       	call   c0100cdb <__panic>
c0105139:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010513c:	05 00 00 00 40       	add    $0x40000000,%eax
c0105141:	39 d0                	cmp    %edx,%eax
c0105143:	74 24                	je     c0105169 <check_boot_pgdir+0x163>
c0105145:	c7 44 24 0c 88 70 10 	movl   $0xc0107088,0xc(%esp)
c010514c:	c0 
c010514d:	c7 44 24 08 49 6d 10 	movl   $0xc0106d49,0x8(%esp)
c0105154:	c0 
c0105155:	c7 44 24 04 1b 02 00 	movl   $0x21b,0x4(%esp)
c010515c:	00 
c010515d:	c7 04 24 24 6d 10 c0 	movl   $0xc0106d24,(%esp)
c0105164:	e8 72 bb ff ff       	call   c0100cdb <__panic>

    assert(boot_pgdir[0] == 0);
c0105169:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c010516e:	8b 00                	mov    (%eax),%eax
c0105170:	85 c0                	test   %eax,%eax
c0105172:	74 24                	je     c0105198 <check_boot_pgdir+0x192>
c0105174:	c7 44 24 0c bc 70 10 	movl   $0xc01070bc,0xc(%esp)
c010517b:	c0 
c010517c:	c7 44 24 08 49 6d 10 	movl   $0xc0106d49,0x8(%esp)
c0105183:	c0 
c0105184:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
c010518b:	00 
c010518c:	c7 04 24 24 6d 10 c0 	movl   $0xc0106d24,(%esp)
c0105193:	e8 43 bb ff ff       	call   c0100cdb <__panic>

    struct Page *p;
    p = alloc_page();
c0105198:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010519f:	e8 b6 ed ff ff       	call   c0103f5a <alloc_pages>
c01051a4:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c01051a7:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c01051ac:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c01051b3:	00 
c01051b4:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c01051bb:	00 
c01051bc:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01051bf:	89 54 24 04          	mov    %edx,0x4(%esp)
c01051c3:	89 04 24             	mov    %eax,(%esp)
c01051c6:	e8 62 f6 ff ff       	call   c010482d <page_insert>
c01051cb:	85 c0                	test   %eax,%eax
c01051cd:	74 24                	je     c01051f3 <check_boot_pgdir+0x1ed>
c01051cf:	c7 44 24 0c d0 70 10 	movl   $0xc01070d0,0xc(%esp)
c01051d6:	c0 
c01051d7:	c7 44 24 08 49 6d 10 	movl   $0xc0106d49,0x8(%esp)
c01051de:	c0 
c01051df:	c7 44 24 04 21 02 00 	movl   $0x221,0x4(%esp)
c01051e6:	00 
c01051e7:	c7 04 24 24 6d 10 c0 	movl   $0xc0106d24,(%esp)
c01051ee:	e8 e8 ba ff ff       	call   c0100cdb <__panic>
    assert(page_ref(p) == 1);
c01051f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01051f6:	89 04 24             	mov    %eax,(%esp)
c01051f9:	e8 4c eb ff ff       	call   c0103d4a <page_ref>
c01051fe:	83 f8 01             	cmp    $0x1,%eax
c0105201:	74 24                	je     c0105227 <check_boot_pgdir+0x221>
c0105203:	c7 44 24 0c fe 70 10 	movl   $0xc01070fe,0xc(%esp)
c010520a:	c0 
c010520b:	c7 44 24 08 49 6d 10 	movl   $0xc0106d49,0x8(%esp)
c0105212:	c0 
c0105213:	c7 44 24 04 22 02 00 	movl   $0x222,0x4(%esp)
c010521a:	00 
c010521b:	c7 04 24 24 6d 10 c0 	movl   $0xc0106d24,(%esp)
c0105222:	e8 b4 ba ff ff       	call   c0100cdb <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0105227:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c010522c:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0105233:	00 
c0105234:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c010523b:	00 
c010523c:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010523f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105243:	89 04 24             	mov    %eax,(%esp)
c0105246:	e8 e2 f5 ff ff       	call   c010482d <page_insert>
c010524b:	85 c0                	test   %eax,%eax
c010524d:	74 24                	je     c0105273 <check_boot_pgdir+0x26d>
c010524f:	c7 44 24 0c 10 71 10 	movl   $0xc0107110,0xc(%esp)
c0105256:	c0 
c0105257:	c7 44 24 08 49 6d 10 	movl   $0xc0106d49,0x8(%esp)
c010525e:	c0 
c010525f:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
c0105266:	00 
c0105267:	c7 04 24 24 6d 10 c0 	movl   $0xc0106d24,(%esp)
c010526e:	e8 68 ba ff ff       	call   c0100cdb <__panic>
    assert(page_ref(p) == 2);
c0105273:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105276:	89 04 24             	mov    %eax,(%esp)
c0105279:	e8 cc ea ff ff       	call   c0103d4a <page_ref>
c010527e:	83 f8 02             	cmp    $0x2,%eax
c0105281:	74 24                	je     c01052a7 <check_boot_pgdir+0x2a1>
c0105283:	c7 44 24 0c 47 71 10 	movl   $0xc0107147,0xc(%esp)
c010528a:	c0 
c010528b:	c7 44 24 08 49 6d 10 	movl   $0xc0106d49,0x8(%esp)
c0105292:	c0 
c0105293:	c7 44 24 04 24 02 00 	movl   $0x224,0x4(%esp)
c010529a:	00 
c010529b:	c7 04 24 24 6d 10 c0 	movl   $0xc0106d24,(%esp)
c01052a2:	e8 34 ba ff ff       	call   c0100cdb <__panic>

    const char *str = "ucore: Hello world!!";
c01052a7:	c7 45 e8 58 71 10 c0 	movl   $0xc0107158,-0x18(%ebp)
    strcpy((void *)0x100, str);
c01052ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01052b1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01052b5:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01052bc:	e8 fc 09 00 00       	call   c0105cbd <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c01052c1:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c01052c8:	00 
c01052c9:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01052d0:	e8 60 0a 00 00       	call   c0105d35 <strcmp>
c01052d5:	85 c0                	test   %eax,%eax
c01052d7:	74 24                	je     c01052fd <check_boot_pgdir+0x2f7>
c01052d9:	c7 44 24 0c 70 71 10 	movl   $0xc0107170,0xc(%esp)
c01052e0:	c0 
c01052e1:	c7 44 24 08 49 6d 10 	movl   $0xc0106d49,0x8(%esp)
c01052e8:	c0 
c01052e9:	c7 44 24 04 28 02 00 	movl   $0x228,0x4(%esp)
c01052f0:	00 
c01052f1:	c7 04 24 24 6d 10 c0 	movl   $0xc0106d24,(%esp)
c01052f8:	e8 de b9 ff ff       	call   c0100cdb <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c01052fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105300:	89 04 24             	mov    %eax,(%esp)
c0105303:	e8 92 e9 ff ff       	call   c0103c9a <page2kva>
c0105308:	05 00 01 00 00       	add    $0x100,%eax
c010530d:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0105310:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105317:	e8 47 09 00 00       	call   c0105c63 <strlen>
c010531c:	85 c0                	test   %eax,%eax
c010531e:	74 24                	je     c0105344 <check_boot_pgdir+0x33e>
c0105320:	c7 44 24 0c a8 71 10 	movl   $0xc01071a8,0xc(%esp)
c0105327:	c0 
c0105328:	c7 44 24 08 49 6d 10 	movl   $0xc0106d49,0x8(%esp)
c010532f:	c0 
c0105330:	c7 44 24 04 2b 02 00 	movl   $0x22b,0x4(%esp)
c0105337:	00 
c0105338:	c7 04 24 24 6d 10 c0 	movl   $0xc0106d24,(%esp)
c010533f:	e8 97 b9 ff ff       	call   c0100cdb <__panic>

    free_page(p);
c0105344:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010534b:	00 
c010534c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010534f:	89 04 24             	mov    %eax,(%esp)
c0105352:	e8 3d ec ff ff       	call   c0103f94 <free_pages>
    free_page(pde2page(boot_pgdir[0]));
c0105357:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c010535c:	8b 00                	mov    (%eax),%eax
c010535e:	89 04 24             	mov    %eax,(%esp)
c0105361:	e8 ca e9 ff ff       	call   c0103d30 <pde2page>
c0105366:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010536d:	00 
c010536e:	89 04 24             	mov    %eax,(%esp)
c0105371:	e8 1e ec ff ff       	call   c0103f94 <free_pages>
    boot_pgdir[0] = 0;
c0105376:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c010537b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0105381:	c7 04 24 cc 71 10 c0 	movl   $0xc01071cc,(%esp)
c0105388:	e8 c9 af ff ff       	call   c0100356 <cprintf>
}
c010538d:	90                   	nop
c010538e:	89 ec                	mov    %ebp,%esp
c0105390:	5d                   	pop    %ebp
c0105391:	c3                   	ret    

c0105392 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0105392:	55                   	push   %ebp
c0105393:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0105395:	8b 45 08             	mov    0x8(%ebp),%eax
c0105398:	83 e0 04             	and    $0x4,%eax
c010539b:	85 c0                	test   %eax,%eax
c010539d:	74 04                	je     c01053a3 <perm2str+0x11>
c010539f:	b0 75                	mov    $0x75,%al
c01053a1:	eb 02                	jmp    c01053a5 <perm2str+0x13>
c01053a3:	b0 2d                	mov    $0x2d,%al
c01053a5:	a2 28 cf 11 c0       	mov    %al,0xc011cf28
    str[1] = 'r';
c01053aa:	c6 05 29 cf 11 c0 72 	movb   $0x72,0xc011cf29
    str[2] = (perm & PTE_W) ? 'w' : '-';
c01053b1:	8b 45 08             	mov    0x8(%ebp),%eax
c01053b4:	83 e0 02             	and    $0x2,%eax
c01053b7:	85 c0                	test   %eax,%eax
c01053b9:	74 04                	je     c01053bf <perm2str+0x2d>
c01053bb:	b0 77                	mov    $0x77,%al
c01053bd:	eb 02                	jmp    c01053c1 <perm2str+0x2f>
c01053bf:	b0 2d                	mov    $0x2d,%al
c01053c1:	a2 2a cf 11 c0       	mov    %al,0xc011cf2a
    str[3] = '\0';
c01053c6:	c6 05 2b cf 11 c0 00 	movb   $0x0,0xc011cf2b
    return str;
c01053cd:	b8 28 cf 11 c0       	mov    $0xc011cf28,%eax
}
c01053d2:	5d                   	pop    %ebp
c01053d3:	c3                   	ret    

c01053d4 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c01053d4:	55                   	push   %ebp
c01053d5:	89 e5                	mov    %esp,%ebp
c01053d7:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c01053da:	8b 45 10             	mov    0x10(%ebp),%eax
c01053dd:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01053e0:	72 0d                	jb     c01053ef <get_pgtable_items+0x1b>
        return 0;
c01053e2:	b8 00 00 00 00       	mov    $0x0,%eax
c01053e7:	e9 98 00 00 00       	jmp    c0105484 <get_pgtable_items+0xb0>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
c01053ec:	ff 45 10             	incl   0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
c01053ef:	8b 45 10             	mov    0x10(%ebp),%eax
c01053f2:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01053f5:	73 18                	jae    c010540f <get_pgtable_items+0x3b>
c01053f7:	8b 45 10             	mov    0x10(%ebp),%eax
c01053fa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105401:	8b 45 14             	mov    0x14(%ebp),%eax
c0105404:	01 d0                	add    %edx,%eax
c0105406:	8b 00                	mov    (%eax),%eax
c0105408:	83 e0 01             	and    $0x1,%eax
c010540b:	85 c0                	test   %eax,%eax
c010540d:	74 dd                	je     c01053ec <get_pgtable_items+0x18>
    }
    if (start < right) {
c010540f:	8b 45 10             	mov    0x10(%ebp),%eax
c0105412:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105415:	73 68                	jae    c010547f <get_pgtable_items+0xab>
        if (left_store != NULL) {
c0105417:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c010541b:	74 08                	je     c0105425 <get_pgtable_items+0x51>
            *left_store = start;
c010541d:	8b 45 18             	mov    0x18(%ebp),%eax
c0105420:	8b 55 10             	mov    0x10(%ebp),%edx
c0105423:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0105425:	8b 45 10             	mov    0x10(%ebp),%eax
c0105428:	8d 50 01             	lea    0x1(%eax),%edx
c010542b:	89 55 10             	mov    %edx,0x10(%ebp)
c010542e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105435:	8b 45 14             	mov    0x14(%ebp),%eax
c0105438:	01 d0                	add    %edx,%eax
c010543a:	8b 00                	mov    (%eax),%eax
c010543c:	83 e0 07             	and    $0x7,%eax
c010543f:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0105442:	eb 03                	jmp    c0105447 <get_pgtable_items+0x73>
            start ++;
c0105444:	ff 45 10             	incl   0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0105447:	8b 45 10             	mov    0x10(%ebp),%eax
c010544a:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010544d:	73 1d                	jae    c010546c <get_pgtable_items+0x98>
c010544f:	8b 45 10             	mov    0x10(%ebp),%eax
c0105452:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105459:	8b 45 14             	mov    0x14(%ebp),%eax
c010545c:	01 d0                	add    %edx,%eax
c010545e:	8b 00                	mov    (%eax),%eax
c0105460:	83 e0 07             	and    $0x7,%eax
c0105463:	89 c2                	mov    %eax,%edx
c0105465:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105468:	39 c2                	cmp    %eax,%edx
c010546a:	74 d8                	je     c0105444 <get_pgtable_items+0x70>
        }
        if (right_store != NULL) {
c010546c:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0105470:	74 08                	je     c010547a <get_pgtable_items+0xa6>
            *right_store = start;
c0105472:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0105475:	8b 55 10             	mov    0x10(%ebp),%edx
c0105478:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c010547a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010547d:	eb 05                	jmp    c0105484 <get_pgtable_items+0xb0>
    }
    return 0;
c010547f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105484:	89 ec                	mov    %ebp,%esp
c0105486:	5d                   	pop    %ebp
c0105487:	c3                   	ret    

c0105488 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0105488:	55                   	push   %ebp
c0105489:	89 e5                	mov    %esp,%ebp
c010548b:	57                   	push   %edi
c010548c:	56                   	push   %esi
c010548d:	53                   	push   %ebx
c010548e:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c0105491:	c7 04 24 ec 71 10 c0 	movl   $0xc01071ec,(%esp)
c0105498:	e8 b9 ae ff ff       	call   c0100356 <cprintf>
    size_t left, right = 0, perm;
c010549d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c01054a4:	e9 f2 00 00 00       	jmp    c010559b <print_pgdir+0x113>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c01054a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01054ac:	89 04 24             	mov    %eax,(%esp)
c01054af:	e8 de fe ff ff       	call   c0105392 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c01054b4:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01054b7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c01054ba:	29 ca                	sub    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c01054bc:	89 d6                	mov    %edx,%esi
c01054be:	c1 e6 16             	shl    $0x16,%esi
c01054c1:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01054c4:	89 d3                	mov    %edx,%ebx
c01054c6:	c1 e3 16             	shl    $0x16,%ebx
c01054c9:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01054cc:	89 d1                	mov    %edx,%ecx
c01054ce:	c1 e1 16             	shl    $0x16,%ecx
c01054d1:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01054d4:	8b 7d e0             	mov    -0x20(%ebp),%edi
c01054d7:	29 fa                	sub    %edi,%edx
c01054d9:	89 44 24 14          	mov    %eax,0x14(%esp)
c01054dd:	89 74 24 10          	mov    %esi,0x10(%esp)
c01054e1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01054e5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01054e9:	89 54 24 04          	mov    %edx,0x4(%esp)
c01054ed:	c7 04 24 1d 72 10 c0 	movl   $0xc010721d,(%esp)
c01054f4:	e8 5d ae ff ff       	call   c0100356 <cprintf>
        size_t l, r = left * NPTEENTRY;
c01054f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01054fc:	c1 e0 0a             	shl    $0xa,%eax
c01054ff:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0105502:	eb 50                	jmp    c0105554 <print_pgdir+0xcc>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0105504:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105507:	89 04 24             	mov    %eax,(%esp)
c010550a:	e8 83 fe ff ff       	call   c0105392 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c010550f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105512:	8b 4d d8             	mov    -0x28(%ebp),%ecx
c0105515:	29 ca                	sub    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0105517:	89 d6                	mov    %edx,%esi
c0105519:	c1 e6 0c             	shl    $0xc,%esi
c010551c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010551f:	89 d3                	mov    %edx,%ebx
c0105521:	c1 e3 0c             	shl    $0xc,%ebx
c0105524:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105527:	89 d1                	mov    %edx,%ecx
c0105529:	c1 e1 0c             	shl    $0xc,%ecx
c010552c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010552f:	8b 7d d8             	mov    -0x28(%ebp),%edi
c0105532:	29 fa                	sub    %edi,%edx
c0105534:	89 44 24 14          	mov    %eax,0x14(%esp)
c0105538:	89 74 24 10          	mov    %esi,0x10(%esp)
c010553c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105540:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0105544:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105548:	c7 04 24 3c 72 10 c0 	movl   $0xc010723c,(%esp)
c010554f:	e8 02 ae ff ff       	call   c0100356 <cprintf>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0105554:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
c0105559:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010555c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010555f:	89 d3                	mov    %edx,%ebx
c0105561:	c1 e3 0a             	shl    $0xa,%ebx
c0105564:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105567:	89 d1                	mov    %edx,%ecx
c0105569:	c1 e1 0a             	shl    $0xa,%ecx
c010556c:	8d 55 d4             	lea    -0x2c(%ebp),%edx
c010556f:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105573:	8d 55 d8             	lea    -0x28(%ebp),%edx
c0105576:	89 54 24 10          	mov    %edx,0x10(%esp)
c010557a:	89 74 24 0c          	mov    %esi,0xc(%esp)
c010557e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105582:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0105586:	89 0c 24             	mov    %ecx,(%esp)
c0105589:	e8 46 fe ff ff       	call   c01053d4 <get_pgtable_items>
c010558e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105591:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105595:	0f 85 69 ff ff ff    	jne    c0105504 <print_pgdir+0x7c>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c010559b:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
c01055a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01055a3:	8d 55 dc             	lea    -0x24(%ebp),%edx
c01055a6:	89 54 24 14          	mov    %edx,0x14(%esp)
c01055aa:	8d 55 e0             	lea    -0x20(%ebp),%edx
c01055ad:	89 54 24 10          	mov    %edx,0x10(%esp)
c01055b1:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01055b5:	89 44 24 08          	mov    %eax,0x8(%esp)
c01055b9:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c01055c0:	00 
c01055c1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01055c8:	e8 07 fe ff ff       	call   c01053d4 <get_pgtable_items>
c01055cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01055d0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01055d4:	0f 85 cf fe ff ff    	jne    c01054a9 <print_pgdir+0x21>
        }
    }
    cprintf("--------------------- END ---------------------\n");
c01055da:	c7 04 24 60 72 10 c0 	movl   $0xc0107260,(%esp)
c01055e1:	e8 70 ad ff ff       	call   c0100356 <cprintf>
}
c01055e6:	90                   	nop
c01055e7:	83 c4 4c             	add    $0x4c,%esp
c01055ea:	5b                   	pop    %ebx
c01055eb:	5e                   	pop    %esi
c01055ec:	5f                   	pop    %edi
c01055ed:	5d                   	pop    %ebp
c01055ee:	c3                   	ret    

c01055ef <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c01055ef:	55                   	push   %ebp
c01055f0:	89 e5                	mov    %esp,%ebp
c01055f2:	83 ec 58             	sub    $0x58,%esp
c01055f5:	8b 45 10             	mov    0x10(%ebp),%eax
c01055f8:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01055fb:	8b 45 14             	mov    0x14(%ebp),%eax
c01055fe:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c0105601:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105604:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105607:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010560a:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c010560d:	8b 45 18             	mov    0x18(%ebp),%eax
c0105610:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105613:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105616:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105619:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010561c:	89 55 f0             	mov    %edx,-0x10(%ebp)
c010561f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105622:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105625:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105629:	74 1c                	je     c0105647 <printnum+0x58>
c010562b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010562e:	ba 00 00 00 00       	mov    $0x0,%edx
c0105633:	f7 75 e4             	divl   -0x1c(%ebp)
c0105636:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0105639:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010563c:	ba 00 00 00 00       	mov    $0x0,%edx
c0105641:	f7 75 e4             	divl   -0x1c(%ebp)
c0105644:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105647:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010564a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010564d:	f7 75 e4             	divl   -0x1c(%ebp)
c0105650:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105653:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0105656:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105659:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010565c:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010565f:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0105662:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105665:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c0105668:	8b 45 18             	mov    0x18(%ebp),%eax
c010566b:	ba 00 00 00 00       	mov    $0x0,%edx
c0105670:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0105673:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c0105676:	19 d1                	sbb    %edx,%ecx
c0105678:	72 4c                	jb     c01056c6 <printnum+0xd7>
        printnum(putch, putdat, result, base, width - 1, padc);
c010567a:	8b 45 1c             	mov    0x1c(%ebp),%eax
c010567d:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105680:	8b 45 20             	mov    0x20(%ebp),%eax
c0105683:	89 44 24 18          	mov    %eax,0x18(%esp)
c0105687:	89 54 24 14          	mov    %edx,0x14(%esp)
c010568b:	8b 45 18             	mov    0x18(%ebp),%eax
c010568e:	89 44 24 10          	mov    %eax,0x10(%esp)
c0105692:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105695:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105698:	89 44 24 08          	mov    %eax,0x8(%esp)
c010569c:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01056a0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01056a3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01056a7:	8b 45 08             	mov    0x8(%ebp),%eax
c01056aa:	89 04 24             	mov    %eax,(%esp)
c01056ad:	e8 3d ff ff ff       	call   c01055ef <printnum>
c01056b2:	eb 1b                	jmp    c01056cf <printnum+0xe0>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c01056b4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01056b7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01056bb:	8b 45 20             	mov    0x20(%ebp),%eax
c01056be:	89 04 24             	mov    %eax,(%esp)
c01056c1:	8b 45 08             	mov    0x8(%ebp),%eax
c01056c4:	ff d0                	call   *%eax
        while (-- width > 0)
c01056c6:	ff 4d 1c             	decl   0x1c(%ebp)
c01056c9:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01056cd:	7f e5                	jg     c01056b4 <printnum+0xc5>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c01056cf:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01056d2:	05 14 73 10 c0       	add    $0xc0107314,%eax
c01056d7:	0f b6 00             	movzbl (%eax),%eax
c01056da:	0f be c0             	movsbl %al,%eax
c01056dd:	8b 55 0c             	mov    0xc(%ebp),%edx
c01056e0:	89 54 24 04          	mov    %edx,0x4(%esp)
c01056e4:	89 04 24             	mov    %eax,(%esp)
c01056e7:	8b 45 08             	mov    0x8(%ebp),%eax
c01056ea:	ff d0                	call   *%eax
}
c01056ec:	90                   	nop
c01056ed:	89 ec                	mov    %ebp,%esp
c01056ef:	5d                   	pop    %ebp
c01056f0:	c3                   	ret    

c01056f1 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c01056f1:	55                   	push   %ebp
c01056f2:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c01056f4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01056f8:	7e 14                	jle    c010570e <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c01056fa:	8b 45 08             	mov    0x8(%ebp),%eax
c01056fd:	8b 00                	mov    (%eax),%eax
c01056ff:	8d 48 08             	lea    0x8(%eax),%ecx
c0105702:	8b 55 08             	mov    0x8(%ebp),%edx
c0105705:	89 0a                	mov    %ecx,(%edx)
c0105707:	8b 50 04             	mov    0x4(%eax),%edx
c010570a:	8b 00                	mov    (%eax),%eax
c010570c:	eb 30                	jmp    c010573e <getuint+0x4d>
    }
    else if (lflag) {
c010570e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105712:	74 16                	je     c010572a <getuint+0x39>
        return va_arg(*ap, unsigned long);
c0105714:	8b 45 08             	mov    0x8(%ebp),%eax
c0105717:	8b 00                	mov    (%eax),%eax
c0105719:	8d 48 04             	lea    0x4(%eax),%ecx
c010571c:	8b 55 08             	mov    0x8(%ebp),%edx
c010571f:	89 0a                	mov    %ecx,(%edx)
c0105721:	8b 00                	mov    (%eax),%eax
c0105723:	ba 00 00 00 00       	mov    $0x0,%edx
c0105728:	eb 14                	jmp    c010573e <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c010572a:	8b 45 08             	mov    0x8(%ebp),%eax
c010572d:	8b 00                	mov    (%eax),%eax
c010572f:	8d 48 04             	lea    0x4(%eax),%ecx
c0105732:	8b 55 08             	mov    0x8(%ebp),%edx
c0105735:	89 0a                	mov    %ecx,(%edx)
c0105737:	8b 00                	mov    (%eax),%eax
c0105739:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c010573e:	5d                   	pop    %ebp
c010573f:	c3                   	ret    

c0105740 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c0105740:	55                   	push   %ebp
c0105741:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0105743:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105747:	7e 14                	jle    c010575d <getint+0x1d>
        return va_arg(*ap, long long);
c0105749:	8b 45 08             	mov    0x8(%ebp),%eax
c010574c:	8b 00                	mov    (%eax),%eax
c010574e:	8d 48 08             	lea    0x8(%eax),%ecx
c0105751:	8b 55 08             	mov    0x8(%ebp),%edx
c0105754:	89 0a                	mov    %ecx,(%edx)
c0105756:	8b 50 04             	mov    0x4(%eax),%edx
c0105759:	8b 00                	mov    (%eax),%eax
c010575b:	eb 28                	jmp    c0105785 <getint+0x45>
    }
    else if (lflag) {
c010575d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105761:	74 12                	je     c0105775 <getint+0x35>
        return va_arg(*ap, long);
c0105763:	8b 45 08             	mov    0x8(%ebp),%eax
c0105766:	8b 00                	mov    (%eax),%eax
c0105768:	8d 48 04             	lea    0x4(%eax),%ecx
c010576b:	8b 55 08             	mov    0x8(%ebp),%edx
c010576e:	89 0a                	mov    %ecx,(%edx)
c0105770:	8b 00                	mov    (%eax),%eax
c0105772:	99                   	cltd   
c0105773:	eb 10                	jmp    c0105785 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c0105775:	8b 45 08             	mov    0x8(%ebp),%eax
c0105778:	8b 00                	mov    (%eax),%eax
c010577a:	8d 48 04             	lea    0x4(%eax),%ecx
c010577d:	8b 55 08             	mov    0x8(%ebp),%edx
c0105780:	89 0a                	mov    %ecx,(%edx)
c0105782:	8b 00                	mov    (%eax),%eax
c0105784:	99                   	cltd   
    }
}
c0105785:	5d                   	pop    %ebp
c0105786:	c3                   	ret    

c0105787 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c0105787:	55                   	push   %ebp
c0105788:	89 e5                	mov    %esp,%ebp
c010578a:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c010578d:	8d 45 14             	lea    0x14(%ebp),%eax
c0105790:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c0105793:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105796:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010579a:	8b 45 10             	mov    0x10(%ebp),%eax
c010579d:	89 44 24 08          	mov    %eax,0x8(%esp)
c01057a1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057a4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057a8:	8b 45 08             	mov    0x8(%ebp),%eax
c01057ab:	89 04 24             	mov    %eax,(%esp)
c01057ae:	e8 05 00 00 00       	call   c01057b8 <vprintfmt>
    va_end(ap);
}
c01057b3:	90                   	nop
c01057b4:	89 ec                	mov    %ebp,%esp
c01057b6:	5d                   	pop    %ebp
c01057b7:	c3                   	ret    

c01057b8 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c01057b8:	55                   	push   %ebp
c01057b9:	89 e5                	mov    %esp,%ebp
c01057bb:	56                   	push   %esi
c01057bc:	53                   	push   %ebx
c01057bd:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01057c0:	eb 17                	jmp    c01057d9 <vprintfmt+0x21>
            if (ch == '\0') {
c01057c2:	85 db                	test   %ebx,%ebx
c01057c4:	0f 84 bf 03 00 00    	je     c0105b89 <vprintfmt+0x3d1>
                return;
            }
            putch(ch, putdat);
c01057ca:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057cd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057d1:	89 1c 24             	mov    %ebx,(%esp)
c01057d4:	8b 45 08             	mov    0x8(%ebp),%eax
c01057d7:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01057d9:	8b 45 10             	mov    0x10(%ebp),%eax
c01057dc:	8d 50 01             	lea    0x1(%eax),%edx
c01057df:	89 55 10             	mov    %edx,0x10(%ebp)
c01057e2:	0f b6 00             	movzbl (%eax),%eax
c01057e5:	0f b6 d8             	movzbl %al,%ebx
c01057e8:	83 fb 25             	cmp    $0x25,%ebx
c01057eb:	75 d5                	jne    c01057c2 <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
c01057ed:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c01057f1:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c01057f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01057fb:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c01057fe:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0105805:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105808:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c010580b:	8b 45 10             	mov    0x10(%ebp),%eax
c010580e:	8d 50 01             	lea    0x1(%eax),%edx
c0105811:	89 55 10             	mov    %edx,0x10(%ebp)
c0105814:	0f b6 00             	movzbl (%eax),%eax
c0105817:	0f b6 d8             	movzbl %al,%ebx
c010581a:	8d 43 dd             	lea    -0x23(%ebx),%eax
c010581d:	83 f8 55             	cmp    $0x55,%eax
c0105820:	0f 87 37 03 00 00    	ja     c0105b5d <vprintfmt+0x3a5>
c0105826:	8b 04 85 38 73 10 c0 	mov    -0x3fef8cc8(,%eax,4),%eax
c010582d:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c010582f:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c0105833:	eb d6                	jmp    c010580b <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c0105835:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c0105839:	eb d0                	jmp    c010580b <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c010583b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c0105842:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105845:	89 d0                	mov    %edx,%eax
c0105847:	c1 e0 02             	shl    $0x2,%eax
c010584a:	01 d0                	add    %edx,%eax
c010584c:	01 c0                	add    %eax,%eax
c010584e:	01 d8                	add    %ebx,%eax
c0105850:	83 e8 30             	sub    $0x30,%eax
c0105853:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c0105856:	8b 45 10             	mov    0x10(%ebp),%eax
c0105859:	0f b6 00             	movzbl (%eax),%eax
c010585c:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c010585f:	83 fb 2f             	cmp    $0x2f,%ebx
c0105862:	7e 38                	jle    c010589c <vprintfmt+0xe4>
c0105864:	83 fb 39             	cmp    $0x39,%ebx
c0105867:	7f 33                	jg     c010589c <vprintfmt+0xe4>
            for (precision = 0; ; ++ fmt) {
c0105869:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
c010586c:	eb d4                	jmp    c0105842 <vprintfmt+0x8a>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
c010586e:	8b 45 14             	mov    0x14(%ebp),%eax
c0105871:	8d 50 04             	lea    0x4(%eax),%edx
c0105874:	89 55 14             	mov    %edx,0x14(%ebp)
c0105877:	8b 00                	mov    (%eax),%eax
c0105879:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c010587c:	eb 1f                	jmp    c010589d <vprintfmt+0xe5>

        case '.':
            if (width < 0)
c010587e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105882:	79 87                	jns    c010580b <vprintfmt+0x53>
                width = 0;
c0105884:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c010588b:	e9 7b ff ff ff       	jmp    c010580b <vprintfmt+0x53>

        case '#':
            altflag = 1;
c0105890:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c0105897:	e9 6f ff ff ff       	jmp    c010580b <vprintfmt+0x53>
            goto process_precision;
c010589c:	90                   	nop

        process_precision:
            if (width < 0)
c010589d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01058a1:	0f 89 64 ff ff ff    	jns    c010580b <vprintfmt+0x53>
                width = precision, precision = -1;
c01058a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01058aa:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01058ad:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c01058b4:	e9 52 ff ff ff       	jmp    c010580b <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c01058b9:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
c01058bc:	e9 4a ff ff ff       	jmp    c010580b <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c01058c1:	8b 45 14             	mov    0x14(%ebp),%eax
c01058c4:	8d 50 04             	lea    0x4(%eax),%edx
c01058c7:	89 55 14             	mov    %edx,0x14(%ebp)
c01058ca:	8b 00                	mov    (%eax),%eax
c01058cc:	8b 55 0c             	mov    0xc(%ebp),%edx
c01058cf:	89 54 24 04          	mov    %edx,0x4(%esp)
c01058d3:	89 04 24             	mov    %eax,(%esp)
c01058d6:	8b 45 08             	mov    0x8(%ebp),%eax
c01058d9:	ff d0                	call   *%eax
            break;
c01058db:	e9 a4 02 00 00       	jmp    c0105b84 <vprintfmt+0x3cc>

        // error message
        case 'e':
            err = va_arg(ap, int);
c01058e0:	8b 45 14             	mov    0x14(%ebp),%eax
c01058e3:	8d 50 04             	lea    0x4(%eax),%edx
c01058e6:	89 55 14             	mov    %edx,0x14(%ebp)
c01058e9:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c01058eb:	85 db                	test   %ebx,%ebx
c01058ed:	79 02                	jns    c01058f1 <vprintfmt+0x139>
                err = -err;
c01058ef:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c01058f1:	83 fb 06             	cmp    $0x6,%ebx
c01058f4:	7f 0b                	jg     c0105901 <vprintfmt+0x149>
c01058f6:	8b 34 9d f8 72 10 c0 	mov    -0x3fef8d08(,%ebx,4),%esi
c01058fd:	85 f6                	test   %esi,%esi
c01058ff:	75 23                	jne    c0105924 <vprintfmt+0x16c>
                printfmt(putch, putdat, "error %d", err);
c0105901:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105905:	c7 44 24 08 25 73 10 	movl   $0xc0107325,0x8(%esp)
c010590c:	c0 
c010590d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105910:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105914:	8b 45 08             	mov    0x8(%ebp),%eax
c0105917:	89 04 24             	mov    %eax,(%esp)
c010591a:	e8 68 fe ff ff       	call   c0105787 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c010591f:	e9 60 02 00 00       	jmp    c0105b84 <vprintfmt+0x3cc>
                printfmt(putch, putdat, "%s", p);
c0105924:	89 74 24 0c          	mov    %esi,0xc(%esp)
c0105928:	c7 44 24 08 2e 73 10 	movl   $0xc010732e,0x8(%esp)
c010592f:	c0 
c0105930:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105933:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105937:	8b 45 08             	mov    0x8(%ebp),%eax
c010593a:	89 04 24             	mov    %eax,(%esp)
c010593d:	e8 45 fe ff ff       	call   c0105787 <printfmt>
            break;
c0105942:	e9 3d 02 00 00       	jmp    c0105b84 <vprintfmt+0x3cc>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c0105947:	8b 45 14             	mov    0x14(%ebp),%eax
c010594a:	8d 50 04             	lea    0x4(%eax),%edx
c010594d:	89 55 14             	mov    %edx,0x14(%ebp)
c0105950:	8b 30                	mov    (%eax),%esi
c0105952:	85 f6                	test   %esi,%esi
c0105954:	75 05                	jne    c010595b <vprintfmt+0x1a3>
                p = "(null)";
c0105956:	be 31 73 10 c0       	mov    $0xc0107331,%esi
            }
            if (width > 0 && padc != '-') {
c010595b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010595f:	7e 76                	jle    c01059d7 <vprintfmt+0x21f>
c0105961:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c0105965:	74 70                	je     c01059d7 <vprintfmt+0x21f>
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105967:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010596a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010596e:	89 34 24             	mov    %esi,(%esp)
c0105971:	e8 16 03 00 00       	call   c0105c8c <strnlen>
c0105976:	89 c2                	mov    %eax,%edx
c0105978:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010597b:	29 d0                	sub    %edx,%eax
c010597d:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105980:	eb 16                	jmp    c0105998 <vprintfmt+0x1e0>
                    putch(padc, putdat);
c0105982:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c0105986:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105989:	89 54 24 04          	mov    %edx,0x4(%esp)
c010598d:	89 04 24             	mov    %eax,(%esp)
c0105990:	8b 45 08             	mov    0x8(%ebp),%eax
c0105993:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105995:	ff 4d e8             	decl   -0x18(%ebp)
c0105998:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010599c:	7f e4                	jg     c0105982 <vprintfmt+0x1ca>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c010599e:	eb 37                	jmp    c01059d7 <vprintfmt+0x21f>
                if (altflag && (ch < ' ' || ch > '~')) {
c01059a0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01059a4:	74 1f                	je     c01059c5 <vprintfmt+0x20d>
c01059a6:	83 fb 1f             	cmp    $0x1f,%ebx
c01059a9:	7e 05                	jle    c01059b0 <vprintfmt+0x1f8>
c01059ab:	83 fb 7e             	cmp    $0x7e,%ebx
c01059ae:	7e 15                	jle    c01059c5 <vprintfmt+0x20d>
                    putch('?', putdat);
c01059b0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059b3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059b7:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c01059be:	8b 45 08             	mov    0x8(%ebp),%eax
c01059c1:	ff d0                	call   *%eax
c01059c3:	eb 0f                	jmp    c01059d4 <vprintfmt+0x21c>
                }
                else {
                    putch(ch, putdat);
c01059c5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059c8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059cc:	89 1c 24             	mov    %ebx,(%esp)
c01059cf:	8b 45 08             	mov    0x8(%ebp),%eax
c01059d2:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c01059d4:	ff 4d e8             	decl   -0x18(%ebp)
c01059d7:	89 f0                	mov    %esi,%eax
c01059d9:	8d 70 01             	lea    0x1(%eax),%esi
c01059dc:	0f b6 00             	movzbl (%eax),%eax
c01059df:	0f be d8             	movsbl %al,%ebx
c01059e2:	85 db                	test   %ebx,%ebx
c01059e4:	74 27                	je     c0105a0d <vprintfmt+0x255>
c01059e6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01059ea:	78 b4                	js     c01059a0 <vprintfmt+0x1e8>
c01059ec:	ff 4d e4             	decl   -0x1c(%ebp)
c01059ef:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01059f3:	79 ab                	jns    c01059a0 <vprintfmt+0x1e8>
                }
            }
            for (; width > 0; width --) {
c01059f5:	eb 16                	jmp    c0105a0d <vprintfmt+0x255>
                putch(' ', putdat);
c01059f7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059fa:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059fe:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0105a05:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a08:	ff d0                	call   *%eax
            for (; width > 0; width --) {
c0105a0a:	ff 4d e8             	decl   -0x18(%ebp)
c0105a0d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105a11:	7f e4                	jg     c01059f7 <vprintfmt+0x23f>
            }
            break;
c0105a13:	e9 6c 01 00 00       	jmp    c0105b84 <vprintfmt+0x3cc>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c0105a18:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105a1b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a1f:	8d 45 14             	lea    0x14(%ebp),%eax
c0105a22:	89 04 24             	mov    %eax,(%esp)
c0105a25:	e8 16 fd ff ff       	call   c0105740 <getint>
c0105a2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a2d:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c0105a30:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a33:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105a36:	85 d2                	test   %edx,%edx
c0105a38:	79 26                	jns    c0105a60 <vprintfmt+0x2a8>
                putch('-', putdat);
c0105a3a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a3d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a41:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c0105a48:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a4b:	ff d0                	call   *%eax
                num = -(long long)num;
c0105a4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a50:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105a53:	f7 d8                	neg    %eax
c0105a55:	83 d2 00             	adc    $0x0,%edx
c0105a58:	f7 da                	neg    %edx
c0105a5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a5d:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c0105a60:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105a67:	e9 a8 00 00 00       	jmp    c0105b14 <vprintfmt+0x35c>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c0105a6c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105a6f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a73:	8d 45 14             	lea    0x14(%ebp),%eax
c0105a76:	89 04 24             	mov    %eax,(%esp)
c0105a79:	e8 73 fc ff ff       	call   c01056f1 <getuint>
c0105a7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a81:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c0105a84:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105a8b:	e9 84 00 00 00       	jmp    c0105b14 <vprintfmt+0x35c>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c0105a90:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105a93:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a97:	8d 45 14             	lea    0x14(%ebp),%eax
c0105a9a:	89 04 24             	mov    %eax,(%esp)
c0105a9d:	e8 4f fc ff ff       	call   c01056f1 <getuint>
c0105aa2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105aa5:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c0105aa8:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0105aaf:	eb 63                	jmp    c0105b14 <vprintfmt+0x35c>

        // pointer
        case 'p':
            putch('0', putdat);
c0105ab1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ab4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105ab8:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c0105abf:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ac2:	ff d0                	call   *%eax
            putch('x', putdat);
c0105ac4:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ac7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105acb:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c0105ad2:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ad5:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0105ad7:	8b 45 14             	mov    0x14(%ebp),%eax
c0105ada:	8d 50 04             	lea    0x4(%eax),%edx
c0105add:	89 55 14             	mov    %edx,0x14(%ebp)
c0105ae0:	8b 00                	mov    (%eax),%eax
c0105ae2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105ae5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0105aec:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0105af3:	eb 1f                	jmp    c0105b14 <vprintfmt+0x35c>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0105af5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105af8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105afc:	8d 45 14             	lea    0x14(%ebp),%eax
c0105aff:	89 04 24             	mov    %eax,(%esp)
c0105b02:	e8 ea fb ff ff       	call   c01056f1 <getuint>
c0105b07:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105b0a:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c0105b0d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0105b14:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c0105b18:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105b1b:	89 54 24 18          	mov    %edx,0x18(%esp)
c0105b1f:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0105b22:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105b26:	89 44 24 10          	mov    %eax,0x10(%esp)
c0105b2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105b2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105b30:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105b34:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105b38:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b3b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105b3f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b42:	89 04 24             	mov    %eax,(%esp)
c0105b45:	e8 a5 fa ff ff       	call   c01055ef <printnum>
            break;
c0105b4a:	eb 38                	jmp    c0105b84 <vprintfmt+0x3cc>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c0105b4c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b4f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105b53:	89 1c 24             	mov    %ebx,(%esp)
c0105b56:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b59:	ff d0                	call   *%eax
            break;
c0105b5b:	eb 27                	jmp    c0105b84 <vprintfmt+0x3cc>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0105b5d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b60:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105b64:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c0105b6b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b6e:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c0105b70:	ff 4d 10             	decl   0x10(%ebp)
c0105b73:	eb 03                	jmp    c0105b78 <vprintfmt+0x3c0>
c0105b75:	ff 4d 10             	decl   0x10(%ebp)
c0105b78:	8b 45 10             	mov    0x10(%ebp),%eax
c0105b7b:	48                   	dec    %eax
c0105b7c:	0f b6 00             	movzbl (%eax),%eax
c0105b7f:	3c 25                	cmp    $0x25,%al
c0105b81:	75 f2                	jne    c0105b75 <vprintfmt+0x3bd>
                /* do nothing */;
            break;
c0105b83:	90                   	nop
    while (1) {
c0105b84:	e9 37 fc ff ff       	jmp    c01057c0 <vprintfmt+0x8>
                return;
c0105b89:	90                   	nop
        }
    }
}
c0105b8a:	83 c4 40             	add    $0x40,%esp
c0105b8d:	5b                   	pop    %ebx
c0105b8e:	5e                   	pop    %esi
c0105b8f:	5d                   	pop    %ebp
c0105b90:	c3                   	ret    

c0105b91 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0105b91:	55                   	push   %ebp
c0105b92:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0105b94:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b97:	8b 40 08             	mov    0x8(%eax),%eax
c0105b9a:	8d 50 01             	lea    0x1(%eax),%edx
c0105b9d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ba0:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0105ba3:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ba6:	8b 10                	mov    (%eax),%edx
c0105ba8:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bab:	8b 40 04             	mov    0x4(%eax),%eax
c0105bae:	39 c2                	cmp    %eax,%edx
c0105bb0:	73 12                	jae    c0105bc4 <sprintputch+0x33>
        *b->buf ++ = ch;
c0105bb2:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bb5:	8b 00                	mov    (%eax),%eax
c0105bb7:	8d 48 01             	lea    0x1(%eax),%ecx
c0105bba:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105bbd:	89 0a                	mov    %ecx,(%edx)
c0105bbf:	8b 55 08             	mov    0x8(%ebp),%edx
c0105bc2:	88 10                	mov    %dl,(%eax)
    }
}
c0105bc4:	90                   	nop
c0105bc5:	5d                   	pop    %ebp
c0105bc6:	c3                   	ret    

c0105bc7 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0105bc7:	55                   	push   %ebp
c0105bc8:	89 e5                	mov    %esp,%ebp
c0105bca:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0105bcd:	8d 45 14             	lea    0x14(%ebp),%eax
c0105bd0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0105bd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105bd6:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105bda:	8b 45 10             	mov    0x10(%ebp),%eax
c0105bdd:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105be1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105be4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105be8:	8b 45 08             	mov    0x8(%ebp),%eax
c0105beb:	89 04 24             	mov    %eax,(%esp)
c0105bee:	e8 0a 00 00 00       	call   c0105bfd <vsnprintf>
c0105bf3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0105bf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105bf9:	89 ec                	mov    %ebp,%esp
c0105bfb:	5d                   	pop    %ebp
c0105bfc:	c3                   	ret    

c0105bfd <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0105bfd:	55                   	push   %ebp
c0105bfe:	89 e5                	mov    %esp,%ebp
c0105c00:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0105c03:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c06:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105c09:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c0c:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105c0f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c12:	01 d0                	add    %edx,%eax
c0105c14:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105c17:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0105c1e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105c22:	74 0a                	je     c0105c2e <vsnprintf+0x31>
c0105c24:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105c27:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105c2a:	39 c2                	cmp    %eax,%edx
c0105c2c:	76 07                	jbe    c0105c35 <vsnprintf+0x38>
        return -E_INVAL;
c0105c2e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0105c33:	eb 2a                	jmp    c0105c5f <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0105c35:	8b 45 14             	mov    0x14(%ebp),%eax
c0105c38:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105c3c:	8b 45 10             	mov    0x10(%ebp),%eax
c0105c3f:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105c43:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0105c46:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105c4a:	c7 04 24 91 5b 10 c0 	movl   $0xc0105b91,(%esp)
c0105c51:	e8 62 fb ff ff       	call   c01057b8 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c0105c56:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105c59:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0105c5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105c5f:	89 ec                	mov    %ebp,%esp
c0105c61:	5d                   	pop    %ebp
c0105c62:	c3                   	ret    

c0105c63 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0105c63:	55                   	push   %ebp
c0105c64:	89 e5                	mov    %esp,%ebp
c0105c66:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105c69:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0105c70:	eb 03                	jmp    c0105c75 <strlen+0x12>
        cnt ++;
c0105c72:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
c0105c75:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c78:	8d 50 01             	lea    0x1(%eax),%edx
c0105c7b:	89 55 08             	mov    %edx,0x8(%ebp)
c0105c7e:	0f b6 00             	movzbl (%eax),%eax
c0105c81:	84 c0                	test   %al,%al
c0105c83:	75 ed                	jne    c0105c72 <strlen+0xf>
    }
    return cnt;
c0105c85:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105c88:	89 ec                	mov    %ebp,%esp
c0105c8a:	5d                   	pop    %ebp
c0105c8b:	c3                   	ret    

c0105c8c <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0105c8c:	55                   	push   %ebp
c0105c8d:	89 e5                	mov    %esp,%ebp
c0105c8f:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105c92:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105c99:	eb 03                	jmp    c0105c9e <strnlen+0x12>
        cnt ++;
c0105c9b:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105c9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105ca1:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105ca4:	73 10                	jae    c0105cb6 <strnlen+0x2a>
c0105ca6:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ca9:	8d 50 01             	lea    0x1(%eax),%edx
c0105cac:	89 55 08             	mov    %edx,0x8(%ebp)
c0105caf:	0f b6 00             	movzbl (%eax),%eax
c0105cb2:	84 c0                	test   %al,%al
c0105cb4:	75 e5                	jne    c0105c9b <strnlen+0xf>
    }
    return cnt;
c0105cb6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105cb9:	89 ec                	mov    %ebp,%esp
c0105cbb:	5d                   	pop    %ebp
c0105cbc:	c3                   	ret    

c0105cbd <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0105cbd:	55                   	push   %ebp
c0105cbe:	89 e5                	mov    %esp,%ebp
c0105cc0:	57                   	push   %edi
c0105cc1:	56                   	push   %esi
c0105cc2:	83 ec 20             	sub    $0x20,%esp
c0105cc5:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cc8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105ccb:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105cce:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0105cd1:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105cd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105cd7:	89 d1                	mov    %edx,%ecx
c0105cd9:	89 c2                	mov    %eax,%edx
c0105cdb:	89 ce                	mov    %ecx,%esi
c0105cdd:	89 d7                	mov    %edx,%edi
c0105cdf:	ac                   	lods   %ds:(%esi),%al
c0105ce0:	aa                   	stos   %al,%es:(%edi)
c0105ce1:	84 c0                	test   %al,%al
c0105ce3:	75 fa                	jne    c0105cdf <strcpy+0x22>
c0105ce5:	89 fa                	mov    %edi,%edx
c0105ce7:	89 f1                	mov    %esi,%ecx
c0105ce9:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105cec:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0105cef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0105cf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0105cf5:	83 c4 20             	add    $0x20,%esp
c0105cf8:	5e                   	pop    %esi
c0105cf9:	5f                   	pop    %edi
c0105cfa:	5d                   	pop    %ebp
c0105cfb:	c3                   	ret    

c0105cfc <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0105cfc:	55                   	push   %ebp
c0105cfd:	89 e5                	mov    %esp,%ebp
c0105cff:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0105d02:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d05:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0105d08:	eb 1e                	jmp    c0105d28 <strncpy+0x2c>
        if ((*p = *src) != '\0') {
c0105d0a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d0d:	0f b6 10             	movzbl (%eax),%edx
c0105d10:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105d13:	88 10                	mov    %dl,(%eax)
c0105d15:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105d18:	0f b6 00             	movzbl (%eax),%eax
c0105d1b:	84 c0                	test   %al,%al
c0105d1d:	74 03                	je     c0105d22 <strncpy+0x26>
            src ++;
c0105d1f:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
c0105d22:	ff 45 fc             	incl   -0x4(%ebp)
c0105d25:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
c0105d28:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105d2c:	75 dc                	jne    c0105d0a <strncpy+0xe>
    }
    return dst;
c0105d2e:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105d31:	89 ec                	mov    %ebp,%esp
c0105d33:	5d                   	pop    %ebp
c0105d34:	c3                   	ret    

c0105d35 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0105d35:	55                   	push   %ebp
c0105d36:	89 e5                	mov    %esp,%ebp
c0105d38:	57                   	push   %edi
c0105d39:	56                   	push   %esi
c0105d3a:	83 ec 20             	sub    $0x20,%esp
c0105d3d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d40:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105d43:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d46:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
c0105d49:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105d4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105d4f:	89 d1                	mov    %edx,%ecx
c0105d51:	89 c2                	mov    %eax,%edx
c0105d53:	89 ce                	mov    %ecx,%esi
c0105d55:	89 d7                	mov    %edx,%edi
c0105d57:	ac                   	lods   %ds:(%esi),%al
c0105d58:	ae                   	scas   %es:(%edi),%al
c0105d59:	75 08                	jne    c0105d63 <strcmp+0x2e>
c0105d5b:	84 c0                	test   %al,%al
c0105d5d:	75 f8                	jne    c0105d57 <strcmp+0x22>
c0105d5f:	31 c0                	xor    %eax,%eax
c0105d61:	eb 04                	jmp    c0105d67 <strcmp+0x32>
c0105d63:	19 c0                	sbb    %eax,%eax
c0105d65:	0c 01                	or     $0x1,%al
c0105d67:	89 fa                	mov    %edi,%edx
c0105d69:	89 f1                	mov    %esi,%ecx
c0105d6b:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105d6e:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105d71:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
c0105d74:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0105d77:	83 c4 20             	add    $0x20,%esp
c0105d7a:	5e                   	pop    %esi
c0105d7b:	5f                   	pop    %edi
c0105d7c:	5d                   	pop    %ebp
c0105d7d:	c3                   	ret    

c0105d7e <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0105d7e:	55                   	push   %ebp
c0105d7f:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105d81:	eb 09                	jmp    c0105d8c <strncmp+0xe>
        n --, s1 ++, s2 ++;
c0105d83:	ff 4d 10             	decl   0x10(%ebp)
c0105d86:	ff 45 08             	incl   0x8(%ebp)
c0105d89:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105d8c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105d90:	74 1a                	je     c0105dac <strncmp+0x2e>
c0105d92:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d95:	0f b6 00             	movzbl (%eax),%eax
c0105d98:	84 c0                	test   %al,%al
c0105d9a:	74 10                	je     c0105dac <strncmp+0x2e>
c0105d9c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d9f:	0f b6 10             	movzbl (%eax),%edx
c0105da2:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105da5:	0f b6 00             	movzbl (%eax),%eax
c0105da8:	38 c2                	cmp    %al,%dl
c0105daa:	74 d7                	je     c0105d83 <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105dac:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105db0:	74 18                	je     c0105dca <strncmp+0x4c>
c0105db2:	8b 45 08             	mov    0x8(%ebp),%eax
c0105db5:	0f b6 00             	movzbl (%eax),%eax
c0105db8:	0f b6 d0             	movzbl %al,%edx
c0105dbb:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105dbe:	0f b6 00             	movzbl (%eax),%eax
c0105dc1:	0f b6 c8             	movzbl %al,%ecx
c0105dc4:	89 d0                	mov    %edx,%eax
c0105dc6:	29 c8                	sub    %ecx,%eax
c0105dc8:	eb 05                	jmp    c0105dcf <strncmp+0x51>
c0105dca:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105dcf:	5d                   	pop    %ebp
c0105dd0:	c3                   	ret    

c0105dd1 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0105dd1:	55                   	push   %ebp
c0105dd2:	89 e5                	mov    %esp,%ebp
c0105dd4:	83 ec 04             	sub    $0x4,%esp
c0105dd7:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105dda:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105ddd:	eb 13                	jmp    c0105df2 <strchr+0x21>
        if (*s == c) {
c0105ddf:	8b 45 08             	mov    0x8(%ebp),%eax
c0105de2:	0f b6 00             	movzbl (%eax),%eax
c0105de5:	38 45 fc             	cmp    %al,-0x4(%ebp)
c0105de8:	75 05                	jne    c0105def <strchr+0x1e>
            return (char *)s;
c0105dea:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ded:	eb 12                	jmp    c0105e01 <strchr+0x30>
        }
        s ++;
c0105def:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
c0105df2:	8b 45 08             	mov    0x8(%ebp),%eax
c0105df5:	0f b6 00             	movzbl (%eax),%eax
c0105df8:	84 c0                	test   %al,%al
c0105dfa:	75 e3                	jne    c0105ddf <strchr+0xe>
    }
    return NULL;
c0105dfc:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105e01:	89 ec                	mov    %ebp,%esp
c0105e03:	5d                   	pop    %ebp
c0105e04:	c3                   	ret    

c0105e05 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0105e05:	55                   	push   %ebp
c0105e06:	89 e5                	mov    %esp,%ebp
c0105e08:	83 ec 04             	sub    $0x4,%esp
c0105e0b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e0e:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105e11:	eb 0e                	jmp    c0105e21 <strfind+0x1c>
        if (*s == c) {
c0105e13:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e16:	0f b6 00             	movzbl (%eax),%eax
c0105e19:	38 45 fc             	cmp    %al,-0x4(%ebp)
c0105e1c:	74 0f                	je     c0105e2d <strfind+0x28>
            break;
        }
        s ++;
c0105e1e:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
c0105e21:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e24:	0f b6 00             	movzbl (%eax),%eax
c0105e27:	84 c0                	test   %al,%al
c0105e29:	75 e8                	jne    c0105e13 <strfind+0xe>
c0105e2b:	eb 01                	jmp    c0105e2e <strfind+0x29>
            break;
c0105e2d:	90                   	nop
    }
    return (char *)s;
c0105e2e:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105e31:	89 ec                	mov    %ebp,%esp
c0105e33:	5d                   	pop    %ebp
c0105e34:	c3                   	ret    

c0105e35 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0105e35:	55                   	push   %ebp
c0105e36:	89 e5                	mov    %esp,%ebp
c0105e38:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0105e3b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0105e42:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105e49:	eb 03                	jmp    c0105e4e <strtol+0x19>
        s ++;
c0105e4b:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
c0105e4e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e51:	0f b6 00             	movzbl (%eax),%eax
c0105e54:	3c 20                	cmp    $0x20,%al
c0105e56:	74 f3                	je     c0105e4b <strtol+0x16>
c0105e58:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e5b:	0f b6 00             	movzbl (%eax),%eax
c0105e5e:	3c 09                	cmp    $0x9,%al
c0105e60:	74 e9                	je     c0105e4b <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
c0105e62:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e65:	0f b6 00             	movzbl (%eax),%eax
c0105e68:	3c 2b                	cmp    $0x2b,%al
c0105e6a:	75 05                	jne    c0105e71 <strtol+0x3c>
        s ++;
c0105e6c:	ff 45 08             	incl   0x8(%ebp)
c0105e6f:	eb 14                	jmp    c0105e85 <strtol+0x50>
    }
    else if (*s == '-') {
c0105e71:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e74:	0f b6 00             	movzbl (%eax),%eax
c0105e77:	3c 2d                	cmp    $0x2d,%al
c0105e79:	75 0a                	jne    c0105e85 <strtol+0x50>
        s ++, neg = 1;
c0105e7b:	ff 45 08             	incl   0x8(%ebp)
c0105e7e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0105e85:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105e89:	74 06                	je     c0105e91 <strtol+0x5c>
c0105e8b:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0105e8f:	75 22                	jne    c0105eb3 <strtol+0x7e>
c0105e91:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e94:	0f b6 00             	movzbl (%eax),%eax
c0105e97:	3c 30                	cmp    $0x30,%al
c0105e99:	75 18                	jne    c0105eb3 <strtol+0x7e>
c0105e9b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e9e:	40                   	inc    %eax
c0105e9f:	0f b6 00             	movzbl (%eax),%eax
c0105ea2:	3c 78                	cmp    $0x78,%al
c0105ea4:	75 0d                	jne    c0105eb3 <strtol+0x7e>
        s += 2, base = 16;
c0105ea6:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0105eaa:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0105eb1:	eb 29                	jmp    c0105edc <strtol+0xa7>
    }
    else if (base == 0 && s[0] == '0') {
c0105eb3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105eb7:	75 16                	jne    c0105ecf <strtol+0x9a>
c0105eb9:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ebc:	0f b6 00             	movzbl (%eax),%eax
c0105ebf:	3c 30                	cmp    $0x30,%al
c0105ec1:	75 0c                	jne    c0105ecf <strtol+0x9a>
        s ++, base = 8;
c0105ec3:	ff 45 08             	incl   0x8(%ebp)
c0105ec6:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0105ecd:	eb 0d                	jmp    c0105edc <strtol+0xa7>
    }
    else if (base == 0) {
c0105ecf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105ed3:	75 07                	jne    c0105edc <strtol+0xa7>
        base = 10;
c0105ed5:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0105edc:	8b 45 08             	mov    0x8(%ebp),%eax
c0105edf:	0f b6 00             	movzbl (%eax),%eax
c0105ee2:	3c 2f                	cmp    $0x2f,%al
c0105ee4:	7e 1b                	jle    c0105f01 <strtol+0xcc>
c0105ee6:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ee9:	0f b6 00             	movzbl (%eax),%eax
c0105eec:	3c 39                	cmp    $0x39,%al
c0105eee:	7f 11                	jg     c0105f01 <strtol+0xcc>
            dig = *s - '0';
c0105ef0:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ef3:	0f b6 00             	movzbl (%eax),%eax
c0105ef6:	0f be c0             	movsbl %al,%eax
c0105ef9:	83 e8 30             	sub    $0x30,%eax
c0105efc:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105eff:	eb 48                	jmp    c0105f49 <strtol+0x114>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0105f01:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f04:	0f b6 00             	movzbl (%eax),%eax
c0105f07:	3c 60                	cmp    $0x60,%al
c0105f09:	7e 1b                	jle    c0105f26 <strtol+0xf1>
c0105f0b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f0e:	0f b6 00             	movzbl (%eax),%eax
c0105f11:	3c 7a                	cmp    $0x7a,%al
c0105f13:	7f 11                	jg     c0105f26 <strtol+0xf1>
            dig = *s - 'a' + 10;
c0105f15:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f18:	0f b6 00             	movzbl (%eax),%eax
c0105f1b:	0f be c0             	movsbl %al,%eax
c0105f1e:	83 e8 57             	sub    $0x57,%eax
c0105f21:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105f24:	eb 23                	jmp    c0105f49 <strtol+0x114>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0105f26:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f29:	0f b6 00             	movzbl (%eax),%eax
c0105f2c:	3c 40                	cmp    $0x40,%al
c0105f2e:	7e 3b                	jle    c0105f6b <strtol+0x136>
c0105f30:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f33:	0f b6 00             	movzbl (%eax),%eax
c0105f36:	3c 5a                	cmp    $0x5a,%al
c0105f38:	7f 31                	jg     c0105f6b <strtol+0x136>
            dig = *s - 'A' + 10;
c0105f3a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f3d:	0f b6 00             	movzbl (%eax),%eax
c0105f40:	0f be c0             	movsbl %al,%eax
c0105f43:	83 e8 37             	sub    $0x37,%eax
c0105f46:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0105f49:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105f4c:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105f4f:	7d 19                	jge    c0105f6a <strtol+0x135>
            break;
        }
        s ++, val = (val * base) + dig;
c0105f51:	ff 45 08             	incl   0x8(%ebp)
c0105f54:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105f57:	0f af 45 10          	imul   0x10(%ebp),%eax
c0105f5b:	89 c2                	mov    %eax,%edx
c0105f5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105f60:	01 d0                	add    %edx,%eax
c0105f62:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
c0105f65:	e9 72 ff ff ff       	jmp    c0105edc <strtol+0xa7>
            break;
c0105f6a:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
c0105f6b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105f6f:	74 08                	je     c0105f79 <strtol+0x144>
        *endptr = (char *) s;
c0105f71:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105f74:	8b 55 08             	mov    0x8(%ebp),%edx
c0105f77:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0105f79:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0105f7d:	74 07                	je     c0105f86 <strtol+0x151>
c0105f7f:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105f82:	f7 d8                	neg    %eax
c0105f84:	eb 03                	jmp    c0105f89 <strtol+0x154>
c0105f86:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0105f89:	89 ec                	mov    %ebp,%esp
c0105f8b:	5d                   	pop    %ebp
c0105f8c:	c3                   	ret    

c0105f8d <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0105f8d:	55                   	push   %ebp
c0105f8e:	89 e5                	mov    %esp,%ebp
c0105f90:	83 ec 28             	sub    $0x28,%esp
c0105f93:	89 7d fc             	mov    %edi,-0x4(%ebp)
c0105f96:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105f99:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0105f9c:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
c0105fa0:	8b 45 08             	mov    0x8(%ebp),%eax
c0105fa3:	89 45 f8             	mov    %eax,-0x8(%ebp)
c0105fa6:	88 55 f7             	mov    %dl,-0x9(%ebp)
c0105fa9:	8b 45 10             	mov    0x10(%ebp),%eax
c0105fac:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0105faf:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0105fb2:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0105fb6:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0105fb9:	89 d7                	mov    %edx,%edi
c0105fbb:	f3 aa                	rep stos %al,%es:(%edi)
c0105fbd:	89 fa                	mov    %edi,%edx
c0105fbf:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105fc2:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0105fc5:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0105fc8:	8b 7d fc             	mov    -0x4(%ebp),%edi
c0105fcb:	89 ec                	mov    %ebp,%esp
c0105fcd:	5d                   	pop    %ebp
c0105fce:	c3                   	ret    

c0105fcf <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0105fcf:	55                   	push   %ebp
c0105fd0:	89 e5                	mov    %esp,%ebp
c0105fd2:	57                   	push   %edi
c0105fd3:	56                   	push   %esi
c0105fd4:	53                   	push   %ebx
c0105fd5:	83 ec 30             	sub    $0x30,%esp
c0105fd8:	8b 45 08             	mov    0x8(%ebp),%eax
c0105fdb:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105fde:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105fe1:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105fe4:	8b 45 10             	mov    0x10(%ebp),%eax
c0105fe7:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0105fea:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105fed:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0105ff0:	73 42                	jae    c0106034 <memmove+0x65>
c0105ff2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105ff5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105ff8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105ffb:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105ffe:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106001:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0106004:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106007:	c1 e8 02             	shr    $0x2,%eax
c010600a:	89 c1                	mov    %eax,%ecx
    asm volatile (
c010600c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010600f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106012:	89 d7                	mov    %edx,%edi
c0106014:	89 c6                	mov    %eax,%esi
c0106016:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0106018:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c010601b:	83 e1 03             	and    $0x3,%ecx
c010601e:	74 02                	je     c0106022 <memmove+0x53>
c0106020:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0106022:	89 f0                	mov    %esi,%eax
c0106024:	89 fa                	mov    %edi,%edx
c0106026:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0106029:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010602c:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
c010602f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
c0106032:	eb 36                	jmp    c010606a <memmove+0x9b>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0106034:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106037:	8d 50 ff             	lea    -0x1(%eax),%edx
c010603a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010603d:	01 c2                	add    %eax,%edx
c010603f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106042:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0106045:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106048:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
c010604b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010604e:	89 c1                	mov    %eax,%ecx
c0106050:	89 d8                	mov    %ebx,%eax
c0106052:	89 d6                	mov    %edx,%esi
c0106054:	89 c7                	mov    %eax,%edi
c0106056:	fd                   	std    
c0106057:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0106059:	fc                   	cld    
c010605a:	89 f8                	mov    %edi,%eax
c010605c:	89 f2                	mov    %esi,%edx
c010605e:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0106061:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0106064:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
c0106067:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c010606a:	83 c4 30             	add    $0x30,%esp
c010606d:	5b                   	pop    %ebx
c010606e:	5e                   	pop    %esi
c010606f:	5f                   	pop    %edi
c0106070:	5d                   	pop    %ebp
c0106071:	c3                   	ret    

c0106072 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0106072:	55                   	push   %ebp
c0106073:	89 e5                	mov    %esp,%ebp
c0106075:	57                   	push   %edi
c0106076:	56                   	push   %esi
c0106077:	83 ec 20             	sub    $0x20,%esp
c010607a:	8b 45 08             	mov    0x8(%ebp),%eax
c010607d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0106080:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106083:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106086:	8b 45 10             	mov    0x10(%ebp),%eax
c0106089:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c010608c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010608f:	c1 e8 02             	shr    $0x2,%eax
c0106092:	89 c1                	mov    %eax,%ecx
    asm volatile (
c0106094:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106097:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010609a:	89 d7                	mov    %edx,%edi
c010609c:	89 c6                	mov    %eax,%esi
c010609e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c01060a0:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c01060a3:	83 e1 03             	and    $0x3,%ecx
c01060a6:	74 02                	je     c01060aa <memcpy+0x38>
c01060a8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c01060aa:	89 f0                	mov    %esi,%eax
c01060ac:	89 fa                	mov    %edi,%edx
c01060ae:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c01060b1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c01060b4:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
c01060b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c01060ba:	83 c4 20             	add    $0x20,%esp
c01060bd:	5e                   	pop    %esi
c01060be:	5f                   	pop    %edi
c01060bf:	5d                   	pop    %ebp
c01060c0:	c3                   	ret    

c01060c1 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c01060c1:	55                   	push   %ebp
c01060c2:	89 e5                	mov    %esp,%ebp
c01060c4:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c01060c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01060ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c01060cd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01060d0:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c01060d3:	eb 2e                	jmp    c0106103 <memcmp+0x42>
        if (*s1 != *s2) {
c01060d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01060d8:	0f b6 10             	movzbl (%eax),%edx
c01060db:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01060de:	0f b6 00             	movzbl (%eax),%eax
c01060e1:	38 c2                	cmp    %al,%dl
c01060e3:	74 18                	je     c01060fd <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c01060e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01060e8:	0f b6 00             	movzbl (%eax),%eax
c01060eb:	0f b6 d0             	movzbl %al,%edx
c01060ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01060f1:	0f b6 00             	movzbl (%eax),%eax
c01060f4:	0f b6 c8             	movzbl %al,%ecx
c01060f7:	89 d0                	mov    %edx,%eax
c01060f9:	29 c8                	sub    %ecx,%eax
c01060fb:	eb 18                	jmp    c0106115 <memcmp+0x54>
        }
        s1 ++, s2 ++;
c01060fd:	ff 45 fc             	incl   -0x4(%ebp)
c0106100:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
c0106103:	8b 45 10             	mov    0x10(%ebp),%eax
c0106106:	8d 50 ff             	lea    -0x1(%eax),%edx
c0106109:	89 55 10             	mov    %edx,0x10(%ebp)
c010610c:	85 c0                	test   %eax,%eax
c010610e:	75 c5                	jne    c01060d5 <memcmp+0x14>
    }
    return 0;
c0106110:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106115:	89 ec                	mov    %ebp,%esp
c0106117:	5d                   	pop    %ebp
c0106118:	c3                   	ret    
