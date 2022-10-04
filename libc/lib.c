#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include <stdarg.h>
#include <stdio.h>
#include <time.h>
#include <ltdl.h>
#include <ncurses.h>

static char _last_saved_ch = 0;
static bool lies = true;

size_t strlen(const char *s)
{
    size_t i = 0;
    while (s[i++])
        ;
    return i - 1;
}

char *strchr(const char *s, char c)
{
    while (*s && *s != c)
        s++;
    if (*s != c)
        return NULL;
    return (char *)s;
}

int rand(void)
{
    return 0;
}

char *strrchr(const char *s, char c)
{
    char *l = NULL;
    while (*s)
    {
        if (*s == c)
            l = (char *)s;
        s++;
    }
    return l;
}

void *memcpy(void *d, const void *s, size_t n)
{
    while (n--)
        *((char *)d++) = *((const char *)s++);
    return d;
}

void *memset(void *a, int c, size_t n)
{
    while (n--)
        *((char *)a++) = c;
    return a;
}

int memcmp(const void *s1, const void *s2, size_t n)
{
    const char *_s1 = (const char *)s1;
    const char *_s2 = (const char *)s2;
    while (n--)
    {
        if (*_s1 != *_s2)
            return -1;
        _s1++;
        _s2++;
    }
    return 0;
}

char *strcpy(char *d, const char *s)
{
    while (*s)
    {
        *d++ = *s++;
    }
    return d;
}

char *strncpy(char *d, const char *s, size_t n)
{
    while (n--)
    {
        if (!*s)
            break;
        *d++ = *s++;
    }
    return d;
}

int strcmp(const char *s1, const char *s2)
{
    while (*s1 && *s2)
    {
        if (*s1 != *s2)
            return -1;
        s1++;
        s2++;
    }
    return 0;
}

#include "ncurses.h"

static inline uint8_t vga_entry_color(enum vga_color fg, enum vga_color bg)
{
    return fg | bg << 4;
}

static inline uint16_t vga_entry(unsigned char uc, uint8_t color)
{
    return (uint16_t)uc | (uint16_t)color << 8;
}

int _row = 0;
int _col = 0;
static uint8_t _color;
static volatile uint16_t *_buffer = (volatile uint16_t *)0xB8000;

void terminal_setcolor(uint8_t color)
{
    _color = color;
}

void terminal_writestring(const char *data)
{
    addnstr(data, strlen(data));
}

void clrtoeol(void)
{
    for (size_t x = _col; x < COLS; x++)
        _buffer[_row * COLS + x] = vga_entry(' ', _color);
}

void cbreak(void)
{
}

void nonl(void)
{
}

void noecho(void)
{
}

static uint8_t inb(uint16_t port)
{
    uint8_t ret = 0;
    asm volatile("inb %1, %0"
                 : "=a"(ret)
                 : "Nd"(port));
    return ret;
}


static void outb(uint16_t port, uint8_t data)
{
    asm volatile("outb %0, %1"
                 :
                 : "a"((uint8_t)'\n'), "Nd"(0x3F8));
}


void clear(void)
{
    for (size_t y = 0; y < LINES; y++)
        for (size_t x = 0; x < COLS; x++)
            _buffer[y * COLS + x] = vga_entry(' ', _color);
    
    if (lies)
    {
        lies = false;
    }
}

void enable_cursor(uint8_t cursor_start, uint8_t cursor_end)
{
    outb(0x3D4, 0x0A);
    outb(0x3D5, (inb(0x3D5) & 0xC0) | cursor_start);
    outb(0x3D4, 0x0B);
    outb(0x3D5, (inb(0x3D5) & 0xE0) | cursor_end);
}

int initscr(void)
{
    _color = vga_entry_color(COLOR_LIGHT_GREY, COLOR_BLACK);
    clear();
    enable_cursor(0, 15);
    lies = true;
    return 1;
}

void endwin(void)
{
    return;
}

const char *longname(void)
{
    return "a long name";
}

int flash(void)
{
    return 0;
}

int beep(void)
{
    return 0;
}

int move(int y, int x)
{
    if (x < 0 || y < 0 || x >= COLS || y >= LINES)
        return ERR;

    _col = x;
    _row = y;
    return 0;
}

void pair_content(int num, short *fg, short *bg)
{
    *fg = num & 0x0F;
    *bg = (num >> 4) & 0x0F;
}

void init_pair(short num, short fg, short bg)
{
    /* ??? */
    return;
}

int has_colors(void)
{
    return 1;
}

void start_color(void)
{
}

void addnstr(const char *s, size_t size)
{
    for (size_t i = 0; i < size; i++)
        addch(s[i]);
}

void addch(int c)
{
    if (c == '\n' || c == '\r')
    {
        _col = 0;
        if (c == '\n')
            _row++;

        asm volatile("outb %0, %1"
                     :
                     : "a"((uint8_t)'\n'), "Nd"(0x3F8));
        asm volatile("outb %0, %1"
                     :
                     : "a"((uint8_t)'\r'), "Nd"(0x3F8));
        
        if(lies)
        {
            // do not lie
        }
    }
    else if(c == '\b')
    {
        _col--;
    }
    else if(c == '\v')
    {
        _row++;
    }
    else if(c == '\t')
    {
        _col += 4 - (_col % 4);
    }
    else
    {
        size_t index = _row * COLS + _col;
        _buffer[index] = vga_entry(c, _color);
        asm volatile("outb %0, %1"
                     :
                     : "a"((uint8_t)c), "Nd"(0x3F8));
        _col++;
    }

    if (_col >= COLS)
    {
        _col = 0;
        _row++;
    }

    if (_row >= LINES)
    {
        _row = LINES - 1;
        scrl(1);
    }
}

#define STUB_FUNC                              \
    printf("stub! %s\n", __PRETTY_FUNCTION__); \
    abort();

#define STUBBED(refresh, ret, ...)                 \
    ret fn(__VA_ARG__)                             \
    {                                              \
        printf("stub! %s\n", __PRETTY_FUNCTION__); \
        abort();                                   \
    }

void refresh(void)
{
}

uint8_t _geT_ps2_input(void)
{
    uint8_t _ch8 = 0;
    for (size_t i = 0; i < 4096; i++)
    {
        asm volatile("outb %0, %1"
                     :
                     : "a"((uint8_t)0x80), "Nd"(0x00));
    }

    while (!_ch8)
    {
        asm volatile("inb %1, %0"
                     : "=a"(_ch8)
                     : "Nd"(0x60));
    }
    return _ch8;
}

static bool _kb_shift = false;
static bool is_press[256] = {0};

int getch(void)
{
    uint16_t pos = _row * COLS + _col;
    outb(0x3D4, 0x0F);
    outb(0x3D5, (uint8_t)(pos & 0xFF));
    outb(0x3D4, 0x0E);
    outb(0x3D5, (uint8_t)((pos >> 8) & 0xFF));

    if (_last_saved_ch)
    {
        int ch = _last_saved_ch;
        _last_saved_ch = 0;
        return ch;
    }

    static char ps2_set1[] = {
        0,
        0x1B,
        '1',
        '2',
        '3',
        '4',
        '5',
        '6',
        '7',
        '8',
        '9',
        '0',
        '-',
        '=',
        '\b',
        '\t',
        'Q',
        'W',
        'E',
        'R',
        'T',
        'Y',
        'U',
        'I',
        'O',
        'P',
        '[',
        ']',
        '\n',
        KEY_CTRL_LEFT,
        'A',
        'S',
        'D',
        'F',
        'G',
        'H',
        'J',
        'K',
        'L',
        ';',
        '\'',
        '`',
        KEY_SHIFT_LEFT,
        '\\',
        'Z',
        'X',
        'C',
        'V',
        'B',
        'N',
        'M',
        ',',
        '.',
        '/',
        KEY_SHIFT_RIGHT,
        KEY_KEYPAD('*'),
        KEY_ALT_LEFT,
        ' ',
        KEY_CAPSLOCK,
        KEY_F1,
        KEY_F2,
        KEY_F3,
        KEY_F4,
        KEY_F5,
        KEY_F6,
        KEY_F7,
        KEY_F8,
        KEY_F9,
        KEY_F10,
        KEY_NUMLOCK,
        KEY_SCROLLOCK,
        KEY_KEYPAD('7'),
        KEY_UP, //KEY_KEYPAD('8'),
        KEY_KEYPAD('9'),
        KEY_KEYPAD('-'),
        KEY_LEFT, // KEY_KEYPAD('4'),
        KEY_KEYPAD('5'),
        KEY_RIGHT, // KEY_KEYPAD('6'),
        KEY_KEYPAD('+'),
        KEY_KEYPAD('1'),
        KEY_DOWN, //KEY_KEYPAD('2'),
        KEY_KEYPAD('3'),
        KEY_KEYPAD('0'),
        KEY_KEYPAD('.'),
        0,
        0,
        0,
        KEY_F11,
        KEY_F12,
    };

    while (1)
    {
        unsigned int ch = _geT_ps2_input();
        if (ch >= 0xE0)
        {
            if (ch == 0xE0)
            {
                ch = _geT_ps2_input();
                if (ch == 0x53)
                    return KEY_DC;
                else if (ch == 0x52)
                    return KEY_IC;
            }
        }
        else
        {
            bool released = (ch & 0x80) != 0;
            ch &= ~0x80;
            ch = ps2_set1[ch % sizeof(ps2_set1)];
            if (released != is_press[ch])
            {
                is_press[ch] = released;
                if (released)
                {
                    if (ch == (unsigned int)KEY_SHIFT_LEFT || ch == (unsigned int)KEY_SHIFT_RIGHT || ch == (unsigned int)KEY_CAPSLOCK)
                    {
                        _kb_shift = !_kb_shift;
                        continue;
                    }

                    if (ch == '\n' || ch == '\r')
                    {
                        return KEY_ENTER;
                    }

                    if (_kb_shift)
                    {
                        return tolower((int)ch);
                    }
                    return (int)ch;
                }
            }
        }
    }
}

int flushinp(void)
{
    uint8_t u_data;
    asm volatile("inb %1, %0"
                 : "=a"(u_data)
                 : "Nd"(0x60));
    return 0;
}

int attrset(int attr)
{
    if (attr == A_NORMAL)
    {
        _color = vga_entry_color(COLOR_LIGHT_GREY, COLOR_BLACK);
    }
    else
    {
        _color = attr & 0xFF;
    }
    return 0;
}

int scrollok(void *w, int a)
{
    return 0;
}

void def_prog_mode(void)
{
    return;
}

void reset_prog_mode(void)
{
    return;
}

void delwin(void *p)
{
    return;
}

int curs_set(int s)
{
    return 0;
}

void timeout(int ms)
{
    return;
}

void ungetch(int ch)
{
    _last_saved_ch = ch;
    return;
}

void attron(chtype attr)
{
    return;
}

void scrl(int s)
{
    while (s--)
    {
        memmove((void *)&_buffer[0], (const void *)&_buffer[COLS], COLS * (LINES - 1) * sizeof(_buffer[0]));
        for (size_t x = 0; x < COLS; x++)
            _buffer[(LINES - 1) * COLS + x] = vga_entry(' ', _color);
    }
    return;
}

void bkgdset(chtype col)
{
    return;
}

void clrtobot(void)
{
    clrtoeol();
    for (size_t y = _row + 1; y < LINES; y++)
        for (size_t x = 0; x < COLS; x++)
            _buffer[y * COLS + x] = vga_entry(' ', _color);
}

void keypad(void *p, int a)
{
    return;
}

#include "alloc.h"
#include "alloc.c"

void _putchar(char c)
{
    addch(c);
}

int putchar(int c)
{
    _putchar(c);
    return 0;
}

#include "printf.c"
struct mem_master master = {0};

int toupper(int x)
{
    return (x) == 'a' ? 'A' : (x) == 'g' ? 'G'
                          : (x) == 'm'   ? 'M'
                          : (x) == 's'   ? 'S'
                          : (x) == 'b'   ? 'B'
                          : (x) == 'h'   ? 'H'
                          : (x) == 'n'   ? 'N'
                          : (x) == 't'   ? 'T'
                          : (x) == 'c'   ? 'C'
                          : (x) == 'i'   ? 'I'
                          : (x) == 'o'   ? 'O'
                          : (x) == 'u'   ? 'U'
                          : (x) == 'd'   ? 'D'
                          : (x) == 'j'   ? 'J'
                          : (x) == 'p'   ? 'P'
                          : (x) == 'v'   ? 'V'
                          : (x) == 'e'   ? 'E'
                          : (x) == 'k'   ? 'K'
                          : (x) == 'q'   ? 'Q'
                          : (x) == 'w'   ? 'W'
                          : (x) == 'f'   ? 'F'
                          : (x) == 'l'   ? 'L'
                          : (x) == 'r'   ? 'R'
                          : (x) == 'x'   ? 'X'
                          : (x) == 'y'   ? 'Y'
                          : (x) == 'z'   ? 'Z'
                                         : (x);
}

int tolower(int x)
{
    return (x) == 'A' ? 'a' : (x) == 'G' ? 'g'
                          : (x) == 'M'   ? 'm'
                          : (x) == 'S'   ? 's'
                          : (x) == 'B'   ? 'b'
                          : (x) == 'H'   ? 'h'
                          : (x) == 'N'   ? 'n'
                          : (x) == 'T'   ? 't'
                          : (x) == 'C'   ? 'c'
                          : (x) == 'I'   ? 'i'
                          : (x) == 'O'   ? 'o'
                          : (x) == 'U'   ? 'u'
                          : (x) == 'D'   ? 'd'
                          : (x) == 'J'   ? 'j'
                          : (x) == 'P'   ? 'p'
                          : (x) == 'V'   ? 'v'
                          : (x) == 'E'   ? 'e'
                          : (x) == 'K'   ? 'k'
                          : (x) == 'Q'   ? 'q'
                          : (x) == 'W'   ? 'w'
                          : (x) == 'F'   ? 'f'
                          : (x) == 'L'   ? 'l'
                          : (x) == 'R'   ? 'r'
                          : (x) == 'X'   ? 'x'
                          : (x) == 'Y'   ? 'y'
                          : (x) == 'Z'   ? 'z'
                                         : (x);
}

void *lt_dlsym()
{
    STUB_FUNC;
    return NULL;
}

lt_dlhandle lt_dlopen(const char *x)
{
    printf("lt_dlopen\n");
    return NULL;
}

void lt_dlclose()
{
    STUB_FUNC;
    return;
}

void lt_dlinit(void)
{
    printf("lt_dlinit\n");
    return;
}

void lt_dlexit()
{
    return;
}

float fabs(float a)
{
    return a < 0.f ? -a : a;
}

const char *gettext(const char *s)
{
    return s;
}

const char *gettext_noop(const char *s)
{
    return s;
}

FILE *stderr = NULL;
FILE *stdout = NULL;
FILE *stdin = NULL;

int access(const char *name, int mode)
{
    STUB_FUNC;
    return -1;
}

long int ftell(FILE *fp)
{
    STUB_FUNC;
    return -1;
}

FILE *fdopen(int fd, const char *modes)
{
    STUB_FUNC;
    return NULL;
}

int lseek(int fd, long int off, int whence)
{
    STUB_FUNC;
    return -1;
}

int fstat(int fd, struct stat *st)
{
    STUB_FUNC;
    return -1;
}

int errno = 0;
int mkdir(const char *name, int mode)
{
    STUB_FUNC;
    return -1;
}

int strcasecmp(const char *s1, const char *s2)
{
    while (*s1 && *s2)
    {
        if (tolower(*s1) != tolower(*s2))
            return -1;
        s1++;
        s2++;
    }
    return 0;
}

int strncasecmp(const char *s1, const char *s2, size_t n)
{
    while (n--)
    {
        if (tolower(*s1) != tolower(*s2))
            return -1;
        s1++;
        s2++;
    }
    return 0;
}

int islower(int x)
{
    return ((x) == 'a' || (x) == 'b' || (x) == 'c' || (x) == 'd' || (x) == 'e' || (x) == 'f' || (x) == 'g' || (x) == 'h' || (x) == 'i' || (x) == 'j' || (x) == 'k' || (x) == 'l' || (x) == 'm' || (x) == 'n' || (x) == 'o' || (x) == 'p' || (x) == 'q' || (x) == 'r' || (x) == 's' || (x) == 't' || (x) == 'u' || (x) == 'v' || (x) == 'w' || (x) == 'x' || (x) == 'y' || (x) == 'z') ? 1 : 0;
}

int isupper(int x)
{
    return ((x) == 'A' || (x) == 'B' || (x) == 'C' || (x) == 'D' || (x) == 'E' || (x) == 'F' || (x) == 'G' || (x) == 'H' || (x) == 'I' || (x) == 'J' || (x) == 'K' || (x) == 'L' || (x) == 'M' || (x) == 'N' || (x) == 'O' || (x) == 'P' || (x) == 'Q' || (x) == 'R' || (x) == 'S' || (x) == 'T' || (x) == 'U' || (x) == 'V' || (x) == 'W' || (x) == 'X' || (x) == 'Y' || (x) == 'Z') ? 1 : 0;
}

int isdigit(int x)
{
    return ((x) == '0' || (x) == '1' || (x) == '2' || (x) == '3' || (x) == '4' || (x) == '5' || (x) == '6' || (x) == '7' || (x) == '8' || (x) == '9');
}

int isalpha(int x)
{
    return islower(x) || isupper(x) ? 1 : 0;
}

int isalnum(int x)
{
    return isalpha(x) || isdigit(x) ? 1 : 0;
}

int isspace(int x)
{
    return x == ' ' || x == '\t' || x == '\v' || x == '\r' || x == '\n' || x == '\f' ? 1 : 0;
}

int ispunct(int x)
{
    return x == '.' || x == ',' || x == ';' || x == ':' ? 1 : 0;
}

int isxdigit(int x)
{
    x = tolower(x);
    if (isdigit(x) || x == 'A' || x == 'B' || x == 'C' || x == 'D' || x == 'E' || x == 'F')
        return 1;
    return 0;
}

int isprint(int x)
{
    return isalnum(x) || ispunct(x) ? 1 : 0;
}

void srand(unsigned int a)
{
    return;
}

int strncmp(const char *s1, const char *s2, size_t n)
{
    while (n--)
    {
        if (*s1 != *s2)
            return -1;
        s1++;
        s2++;
    }
    return 0;
}

struct tm *localtime(const time_t *t)
{
    static struct tm tm = {0};
    return &tm;
}

int finite()
{
    STUB_FUNC;
    return 0;
}

time_t time(time_t *t)
{
    return (time_t)-1;
}

int fileno(FILE *f)
{
    STUB_FUNC;
    return -1;
}

int abs(int x)
{
    return x < 0 ? -x : x;
}

FILE *fopen(const char *name, const char *mode)
{
    if (!strcmp("./runtime.cfg", name))
    {
        return NULL;
    }
    printf("open=%s,mode=%s\n", name, mode);
    STUB_FUNC;
    return NULL;
}

void rewind(FILE *f)
{
    STUB_FUNC;
    return;
}

int fclose(FILE *f)
{
    STUB_FUNC;
    return 0;
}

int puts(const char *s)
{
    while (*s)
        putchar(*s--);
    return 0;
}

int chdir(const char *name)
{
    STUB_FUNC;
    return -1;
}

int rename(const char *old, const char *new)
{
    STUB_FUNC;
    return -1;
}

int close(int fd)
{
    STUB_FUNC;
    return -1;
}

void exit(int status)
{
    clear();
    move(0, 0);
    printf("COBOL runtime finished with CODE %i.\n", status);
    while (1)
        ;
}

static char *_tok_g = NULL;
bool _is_delim(char c, const char *delim)
{
    while (*delim != c)
        delim++;
    if (*delim == c)
        return true;
    return false;
}

char *strtok(char *restrict t, const char *restrict delim)
{
    if (t == NULL)
    {
        while (!_is_delim(*t, delim) && *t)
            t++;

        if (_is_delim(*t, delim))
        {
            *t = '\0';
            _tok_g = t;
            while (!_is_delim(*t, delim) && *t)
                t++;
            if (_is_delim(*t, delim))
                *t = '\0';
            return t;
        }
        else
        {
            return NULL;
        }
    }
    _tok_g = t;
    return _tok_g;
}

char *getlogin(void)
{
    return "LMVX-USER";
}

char *strcat(char *restrict s1, const char *restrict s2)
{
    while (*s1 != '\0')
        ++s1;
    while (*s2 != '\0')
        *(s1++) = *(s2++);
    *(s1++) = '\0';
    return s1;
}

int fseek(FILE *fp, long int offset, int whence)
{
    STUB_FUNC;
    return -1;
}

char *strstr(const char *haystack, const char *needle)
{
    STUB_FUNC;
    return NULL;
}

#include <setjmp.h>
void longjmp(jmp_buf e, int v)
{
    STUB_FUNC;
    while (1)
        ;
}

int setjmp(jmp_buf e)
{
    STUB_FUNC;
    return 0;
}

void qsort(void *base, size_t n, size_t size, int (*cmp)(const void *a, const void *b))
{
    void *tmp = malloc(size);

    for (size_t i = 0; i < n - 1; i++)
    {
        for (size_t j = 0; j < n - 1; j++)
        {
            void *rbase = (j * size);
            if (cmp(rbase, rbase + size) > 0)
            {
                memcpy(tmp, rbase, size);
                memcpy(rbase + size, rbase, rbase);
                memcpy(rbase, tmp, size);
            }
        }
    }

    free(tmp);
    return;
}

time_t mktime(struct tm *tp)
{
    STUB_FUNC;
    return (time_t)-1;
}

int system(const char *cmd)
{
    STUB_FUNC;
    return -1;
}

int sleep(int ms)
{
    STUB_FUNC;
    return -1;
}

char *fgets(char *s, int n, FILE *fp)
{
    STUB_FUNC;
    return NULL;
}

struct tm *gmtime(const time_t *t)
{
    STUB_FUNC;
    return NULL;
}

pid_t getpid(void)
{
    STUB_FUNC;
    return (pid_t)-1;
}

char *itoa(char *str, uint64_t val, uint8_t base)
{
    unsigned rem = 0;
    unsigned i, j, k;
    char _buffer[32];
    char *buffer = (char *)&_buffer;

    i = 0;
    if (val == 0)
    {
        str[i++] = '0';
        str[i] = '\0';
        return str;
    }
    while (val != 0)
    {
        rem = (val % base);
        str[i++] = (rem > 9) ? (rem - 10) + 'A' : rem + '0';
        val /= base;
    }

    k = i;
    j = k;
    for (i = 0; i < k; i++)
    {
        buffer[i] = str[j - 1];
        j--;
    }
    for (i = 0; i < k; i++)
    {
        str[i] = buffer[i];
    }
    str[i] = '\0';
    return str;
}

char *sitoa(char *str, int64_t val, uint8_t base)
{
    if (val < 0)
    {
        (*str) = '-';
        str++;
    }

    /* Clear last bit */
    val = (val << 1) >> 1;
    itoa(str, val, base);
    return str;
}

int internal_atoi(const char *str, unsigned char base, size_t limit)
{
    signed int i = 0;
    int num = 0;

    /* Do this simple recursive formula */
    if (base > 10)
    {
        while ((str[i] >= '0' && str[i] <= '9') || (str[i] >= 'A' && str[i] <= 'A' + (base - 10)))
        {
            num *= base;
            num += (str[i] >= 'A') ? (str[i] - 'A' + 10) : (str[i] - '0');
            i++;
            if (limit && i >= limit)
                return num;
        }
    }
    else
    {
        while (str[i] >= '0' && str[i] <= '9')
        {
            num *= base;
            num += str[i] - '0';
            i++;
            if (limit && i >= limit)
                return num;
        }
    }
    return num;
}

int atoi(const char *str)
{
    return internal_atoi(str, 10, 0);
}

void __isoc99_sscanf(void)
{
    return;
}

int sscanf(const char *s, const char *fmt, ...)
{
    printf("scanf %s\n", fmt);
    return -1;
}

char *strncat(char *restrict s1, const char *restrict s2, size_t n)
{
    while (*s1 != '\0')
        ++s1;

    while (*s2 != '\0' && n)
    {
        *(s1++) = *(s2++);
        --n;
    }
    *(s1++) = '\0';
    return s1;
}

int putenv(char *e)
{
    STUB_FUNC;
    return -1;
}

int fsync(int fd)
{
    STUB_FUNC;
    return -1;
}

char *getcwd(const char *c, size_t n)
{
    STUB_FUNC;
    return "/";
}

int unlink(const char *name)
{
    STUB_FUNC;
    return -1;
}

int open(const char *name, int mode, ...)
{
    STUB_FUNC;
    return -1;
}

int write(int fd, const void *p, size_t n)
{
    STUB_FUNC;
    return -1;
}

int getchar(void)
{
    STUB_FUNC;
    return EOF;
}

int rmdir(const char *name)
{
    STUB_FUNC;
    return -1;
}

int stat(const char *filename, struct stat *st)
{
    if (!strcmp(filename, "."))
    {
        memset(st, 0, sizeof(*st));
        st->st_mode = 0;
        return 0;
    }
    STUB_FUNC;
    return -1;
}

int getc(FILE *fp)
{
    STUB_FUNC;
    return EOF;
}

int read(int fd, void *p, size_t n)
{
    STUB_FUNC;
    return -1;
}

int kill(pid_t p, int signal)
{
    STUB_FUNC;
    return -1;
}

void *memmove(void *dest, const void *src, size_t n)
{
    const char *c_src = (const char *)src;
    char *c_dest = (char *)dest;
    if ((uintptr_t)c_dest < (uintptr_t)c_src)
    {
        while (n)
        {
            *(c_dest++) = *(c_src++);
            --n;
        }
    }
    else
    {
        c_dest += n;
        c_src += n;
        while (n)
        {
            *(c_dest--) = *(c_src--);
            --n;
        }
    }
    return c_dest;
}

int fputs(const char *restrict s, FILE *restrict fp)
{
    puts(s);
    return 0;
}

int fputc(int c, FILE *fp)
{
    putchar(c);
    return 0;
}

int putc(int c, FILE *fp)
{
    putchar(c);
    return 0;
}

size_t fwrite(const void *restrict p, size_t n, size_t size, FILE *fp)
{
    STUB_FUNC;
    return 0;
}

size_t fread(void *restrict p, size_t n, size_t size, FILE *fp)
{
    STUB_FUNC;
    return 0;
}

int fprintf(FILE *fp, const char *fmt, ...)
{
    va_list ap;
    va_start(ap, fmt);
    vprintf(fmt, ap);
    va_end(ap);
    return -1;
}

int vfprintf(FILE *fp, const char *fmt, va_list ap)
{
    vprintf(fmt, ap);
    return -1;
}

int fflush(FILE *fp)
{
    return 0;
}

char *getenv(const char *env)
{
    return "";
}

void *malloc(size_t size)
{
    void *p = mem_alloc(&master, size);
    if (p == NULL)
    {
        printf("Requested object %zu, but we have %zu?\n", size, mem_total_free(&master));
        mem_print(&master);
        STUB_FUNC;
    }
    return p;
}

void *calloc(size_t n, size_t size)
{
    void *p = malloc(n * size);
    memset(p, 0, n * size);
    return p;
}

void *realloc(void *p, size_t size)
{
    return mem_realloc(&master, p, size);
}

void free(void *p)
{
    mem_free(&master, p);
}

void __assert_fail()
{
    while (1)
        ;
}

void abort()
{
    while (1)
        ;
}

long strtol(char *s, char **endptr, int base)
{
    STUB_FUNC;
    return 0;
}

size_t strftime(char *p, size_t size, const char *fmt, const struct tm *tp)
{
    STUB_FUNC;
    return 0;
}

int ftruncate(int fd, int offset)
{
    STUB_FUNC;
    return 0;
}

const char *strerror(int errno)
{
    return "NO STRERRROR";
}

char *setlocale(int category, const char *locale)
{
    return NULL;
}
