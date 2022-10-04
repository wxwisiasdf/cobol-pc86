#ifndef NCURSES_H
#define NCURSES_H 1

/* Hardware text mode color constants. */
enum vga_color
{
    COLOR_BLACK = 0,
    COLOR_BLUE = 1,
    COLOR_GREEN = 2,
    COLOR_CYAN = 3,
    COLOR_RED = 4,
    COLOR_MAGENTA = 5,
    COLOR_BROWN = 6,
    COLOR_LIGHT_GREY = 7,
    COLOR_DARK_GREY = 8,
    COLOR_LIGHT_BLUE = 9,
    COLOR_LIGHT_GREEN = 10,
    COLOR_LIGHT_CYAN = 11,
    COLOR_LIGHT_RED = 12,
    COLOR_LIGHT_MAGENTA = 13,
    COLOR_YELLOW = 14,
    COLOR_WHITE = 15,
};
#define COLOR_PAIRS 255

typedef int chtype;
#define WITH_CURSES "freestanding"
int initscr(void);
void endwin(void);
const char *longname(void);
int flash(void);
int beep(void);
int move(int x, int y);
void pair_content(int num, short *fg, short *bg);
void init_pair(short num, short fg, short bg);
int has_colors(void);
void start_color(void);
#define A_NORMAL 0x00
#define A_REVERSE 0x100
#define A_BOLD 0x100
#define A_DIM 0x100
#define A_BLINK 0x200
#define A_UNDERLINE 0x400
#define COLOR_PAIR(x) (x)
int attrset(int attr);
void attron(chtype attr);

extern int _row;
extern int _col;
#define getyx(s, y, x) (y = _row, x = _col)
void clrtoeol(void);
void clear(void);
void cbreak(void);
void nonl(void);
void noecho(void);

#define KEY_SCROLLOCK (char)(0xEE)
#define KEY_NUMLOCK (char)(0xEF)
#define KEY_F1 (char)(0xF0)
#define KEY_F2 (char)(0xF1)
#define KEY_F3 (char)(0xF2)
#define KEY_F4 (char)(0xF3)
#define KEY_F5 (char)(0xF4)
#define KEY_F6 (char)(0xF5)
#define KEY_F7 (char)(0xF6)
#define KEY_F8 (char)(0xF7)
#define KEY_F9 (char)(0xF8)
#define KEY_F10 (char)(0xF9)
#define KEY_F11 (char)(0xFA)
#define KEY_F12 (char)(0xFB)
#define KEY_CTRL_LEFT (char)(0xFC)
#define KEY_SHIFT_LEFT (char)(0xFD)
#define KEY_SHIFT_RIGHT (char)(0xFE)
#define KEY_ALT_LEFT (char)(0xFF)
#define KEY_CAPSLOCK (char)(0x3A)
#define KEY_KEYPAD(x) \
    (char)(0x80 | (((x) >= '0' && (x) <= '9') ? ((x) - '0') : ((x)-0x20)))

#define KEY_BACKSPACE '\b'
#define KEY_ALEFT KEY_ALT_LEFT
#define KEY_ENTER '\n'
#define KEY_STAB '\t'

#define KEY_BTAB 0xC0
#define KEY_SDC 0xC1
#define KEY_PREVIOUS 0xC2
#define KEY_EOL 0xC3
#define KEY_CLOSE 0xC4
#define KEY_SLEFT 0xC5
#define KEY_PPAGE 0xC6
#define KEY_NPAGE 0xC7
#define KEY_PRINT 0xC8
#define KEY_UP 0xC9
#define KEY_DOWN 0xCA
#define KEY_HOME 0xCB
#define KEY_RIGHT 0xCC
#define KEY_IC 0xCD
#define KEY_DC 0xCE
#define KEY_LEFT 0xCF
#define KEY_END 0xD0

void addnstr(const char *s, size_t size);
void addch(int ch);
void refresh(void);
int getch(void);
int flushinp(void);
int scrollok(void *w, int a);
void def_prog_mode(void);
void reset_prog_mode(void);
void delwin(void *p);
int curs_set(int s);
void timeout(int ms);
void ungetch(int ch);
void scrl(int s);
void bkgdset(chtype col);
void clrtobot(void);
void keypad(void *p, int a);

#define KEY_F0 0
#define KEY_F(x) (KEY_F1 + x)

#define ERR -1

#define COLS 80
#define LINES 25

#define getmaxyx(a, y, x) (y = LINES - 1, x = COLS - 1)

#define stdscr stdout

#endif
