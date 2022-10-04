#ifndef ALL_H
#define ALL_H

#include <stdint.h>
#include <stddef.h>
#include <stdarg.h>
#include <stdlib.h>

#define assert(x)
#define assertm(x)

#define EOF ((int)-1)
#define isnan(x) (0)

#define EXIT_FAILURE 1
#define EXIT_SUCCESS 0

#define _S_IFMT 0x0F
#define _S_IFDIR 1

#define S_ISDIR(x) (0)

#define LC_CTYPE 0

#define E2BIG 1
#define EACCES 2
#define EADDRINUSE 3
#define EADDRNOTAVAIL 4
#define EAFNOSUPPORT 5
#define EAGAIN 6
#define EALREADY 7
#define EBADE 8
#define EBADF 9
#define EBADFD 10
#define EBADMSG 11
#define EBADR 12
#define EBADRQC 13
#define EBADSLT 14
#define EBUSY 15
#define ECANCELED 16
#define ECHILD 17
#define ECHRNG 18
#define ECOMM 19
#define ECONNABORTED 20
#define ECONNREFUSED 21
#define ECONNRESET 22
#define EDEADLK 23
#define EDESTADDRREQ 25
#define EDOM 26
#define EDQUOT 27
#define EEXIST 28
#define EFAULT 29
#define EFBIG 30
#define EHOSTDOWN 31
#define EHOSTUNREACH 32
#define EHWPOISON 33
#define EIDRM 34
#define EILSEQ 35
#define EINPROGRESS 36
#define EINTR 37
#define EINVAL 38
#define EIO 39
#define EISCONN 40
#define EISDIR 41
#define EISNAM 42
#define EKEYEXPIRED 43
#define EKEYREJECTED 44
#define EKEYREVOKED 45
#define EL2HLT 46
#define EL2NSYNC 47
#define EL3HLT 48
#define EL3RST 49
#define ELIBACC 50
#define ELIBBAD 51
#define ELIBMAX 52
#define ELIBSCN 53
#define ELIBEXEC 54
#define ELNRANGE 55
#define ELOOP 56
#define EMEDIUMTYPE 57
#define EMFILE 58
#define EMLINK 59
#define EMSGSIZE 60
#define EMULTIHOP 61
#define ENAMETOOLONG 62
#define ENETDOWN 63
#define ENETRESET 64
#define ENETUNREACH 65
#define ENFILE 66
#define ENOANO 67
#define ENOBUFS 68
#define ENODATA 69
#define ENODEV 70
#define ENOENT 71
#define ENOEXEC 72
#define ENOKEY 73
#define ENOLCK 74
#define ENOLINK 75
#define ENOMEDIUM 76
#define ENOMEM 77
#define ENOMSG 78
#define ENONET 79
#define ENOPKG 80
#define ENOPROTOOPT 81
#define ENOSPC 82
#define ENOSR 83
#define ENOSTR 84
#define ENOSYS 85
#define ENOTBLK 86
#define ENOTCONN 87
#define ENOTDIR 88
#define ENOTEMPTY 89
#define ENOTRECOVERABLE 90
#define ENOTSOCK 91
#define ENOTSUP 92
#define ENOTTY 93
#define ENOTUNIQ 94
#define ENXIO 95
#define EOVERFLOW 97
#define EOWNERDEAD 98
#define EPERM 99
#define EPFNOSUPPORT 100
#define EPIPE 101
#define EPROTO 102
#define EPROTONOSUPPORT 103
#define EPROTOTYPE 104
#define ERANGE 105
#define EREMCHG 106
#define EREMOTE 107
#define EREMOTEIO 108
#define ERESTART 109
#define ERFKILL 110
#define EROFS 111
#define ESHUTDOWN 112
#define ESPIPE 113
#define ESOCKTNOSUPPORT 114
#define ESRCH 115
#define ESTALE 116
#define ESTRPIPE 117
#define ETIME 118
#define ETIMEDOUT 119
#define ETOOMANYREFS 120
#define ETXTBSY 121
#define EUCLEAN 122
#define EUNATCH 123
#define EUSERS 124
#define EXDEV 126
#define EXFULL 127

/* Aliases */
#define EDEADLOCK EDEADLK
#define EWOULDBLOCK EBUSY
#define EOPNOTSUPP EOPNOTSUP

extern int errno;

typedef int dev_t;
typedef int ino_t;
typedef int mode_t;
typedef int nlink_t;
typedef int uid_t;
typedef int gid_t;
typedef int dev_t;
typedef int time_t;
typedef int off_t;
typedef int pid_t;
typedef int blksize_t;
typedef int blkcnt_t;

typedef signed long ssize_t;

#define SEEK_SET 0
#define SEEK_CUR 1
#define SEEK_END 2

struct stat
{
    dev_t st_dev;
    ino_t st_ino;
    mode_t st_mode;
    nlink_t st_nlink;
    uid_t st_uid;
    gid_t st_gid;
    dev_t st_rdev;
    off_t st_size;
    time_t st_atime;
    time_t st_mtime;
    time_t st_ctime;
    blksize_t st_blksize;
    blkcnt_t st_blocks;
};

typedef struct FILE
{
    int dummy;
} FILE;

struct tm
{
    int tm_sec;
    int tm_min;
    int tm_hour;
    int tm_mday;
    int tm_mon;
    int tm_year;
    int tm_wday;
    int tm_yday;
    int tm_isdst;
};

typedef void *jmp_buf;

#define O_RDONLY 0
#define O_CREAT 1
#define O_TRUNC 2
#define O_WRONLY 3
#define O_RDWR 4
#define O_APPEND 5

#define RAND_MAX 65535

float fabs(float a);
size_t strlen(const char *s);
char *strchr(const char *s, char c);
int rand(void);
char *strrchr(const char *s, char c);
void *memcpy(void *d, const void *s, size_t n);
void *memset(void *a, int c, size_t n);
int memcmp(const void *s1, const void *s2, size_t n);
int sprintf(char *b, const char *fmt, ...);
int snprintf(char *b, size_t n, const char *fmt, ...);
char *strcpy(char *d, const char *s);
char *strncpy(char *d, const char *s, size_t n);
int strcmp(const char *s1, const char *s2);
char *strstr(const char *haystack, const char *needle);
int toupper(int x);
int tolower(int x);
extern FILE *stderr;
extern FILE *stdout;
extern FILE *stdin;
int access(const char *name, int mode);
long int ftell(FILE *fp);
FILE *fdopen(int fd, const char *modes);
int lseek(int fd, long int off, int whence);
int fstat(int fd, struct stat *st);
int mkdir(const char *name, int mode);
int strcasecmp(const char *s1, const char *s2);
int strncasecmp(const char *s1, const char *s2, size_t n);
int islower(int x);
int isupper(int x);
int isdigit(int x);
int isalpha(int x);
int isalnum(int x);
int isspace(int x);
int ispunct(int x);
int isxdigit(int x);
int isprint(int x);
void srand(unsigned int a);
int strncmp(const char *s1, const char *s2, size_t n);
struct tm *localtime(const time_t *t);
int finite();
time_t time(time_t *t);
int fileno(FILE *f);
int abs(int x);
FILE *fopen(const char *name, const char *mode);
void rewind(FILE *f);
int fclose(FILE *f);
int puts(const char *s);
int chdir(const char *name);
int rename(const char *old, const char *new_name);
int close(int fd);
void exit(int status);
char *strtok(char *restrict t, const char *restrict delim);
char *getlogin(void);
char *strcat(char *restrict s1, const char *restrict s2);
int fseek(FILE *fp, long int offset, int whence);
void longjmp(jmp_buf e, int v);
int setjmp(jmp_buf e);
void qsort(void *base, size_t n, size_t size, int (*cmp)(const void *a, const void *b));
time_t mktime(struct tm *tp);
int system(const char *cmd);
int sleep(int ms);
char *fgets(char *s, int n, FILE *fp);
struct tm *gmtime(const time_t *t);
pid_t getpid(void);
char *itoa(char *str, uint64_t val, uint8_t base);
char *sitoa(char *str, int64_t val, uint8_t base);
int internal_atoi(const char *str, unsigned char base, size_t limit);
int atoi(const char *str);
int vprintf(const char *format, va_list args);
int printf(const char *format, ...);
int vfprintf(FILE *fp, const char *fmt, va_list ap);
int vsprintf(char *buf, const char *fmt, va_list ap);
int vsnprintf(char *buf, size_t n, const char *fmt, va_list ap);
int putchar(int c);
void __isoc99_sscanf(void);
int sscanf(const char *s, const char *fmt, ...);
char *strncat(char *restrict s1, const char *restrict s2, size_t n);
int putenv(char *e);
int fsync(int fd);
char *getcwd(const char *c, size_t n);
int unlink(const char *name);
int open(const char *name, int mode, ...);
int write(int fd, const void *p, size_t n);
int getchar(void);
int rmdir(const char *name);
int stat(const char *filename, struct stat *st);
int getc(FILE *fp);
int read(int fd, void *p, size_t n);
void *memmove(void *dest, const void *src, size_t n);
int fputs(const char *restrict s, FILE *restrict fp);
int fputc(int c, FILE *fp);
int putc(int c, FILE *fp);
size_t fwrite(const void *restrict p, size_t n, size_t size, FILE *fp);
size_t fread(void *restrict p, size_t n, size_t size, FILE *fp);
int fprintf(FILE *fp, const char *fmt, ...);
int fflush(FILE *fp);
char *getenv(const char *env);
void *malloc(size_t size);
void *calloc(size_t n, size_t size);
void *realloc(void *p, size_t size);
void free(void *p);
void __assert_fail();
void abort();
long strtol(char *s, char **endptr, int base);
size_t strftime(char *p, size_t size, const char *fmt, const struct tm *tp);
int ftruncate(int fd, int offset);
const char *strerror(int errno);
char *setlocale(int category, const char *locale);

#endif
