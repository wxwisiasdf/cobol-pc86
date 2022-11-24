#include <all.h>
#include <alloc.h>
extern struct mem_master master;

void cob_init(const int argc, char **argv);

#include <multiboot2.h>
#include <ncurses.h>
#include "libcob.h"

extern int KERNEL();
void main(unsigned long magic, uint8_t *addr)
{
    if (magic != MULTIBOOT2_BOOTLOADER_MAGIC)
        return;

    mem_init_master(&master);
    mem_new_region(&master, (void *)0x10000, (65536 * 128));

    initscr();
    printf("Hello from C\n");
    cob_init(0, NULL);
    KERNEL();

    (void)cob_tidy();
    while (1)
        ;
}

#define COBOL_9_TO_C(buf, v, r, s, b) \
    memcpy(buf, v, s);                \
    buf[s] = '\0';                    \
    r = internal_atoi(buf, b, v);

int IO_OUT(cob_u16_t port, cob_u32_t data, cob_u8_t *mode)
{
    switch (mode[0])
    {
    case 'C':
        asm volatile("outb %0, %1"
                     :
                     : "a"((uint8_t)data), "Nd"(port));
        break;
    case 'H':
        asm volatile("outw %0, %1"
                     :
                     : "a"((uint16_t)data), "Nd"(port));
        break;
    case 'S':
        asm volatile("outl %0, %1"
                     :
                     : "a"((uint32_t)data), "Nd"(port));
        break;
    default:
        break;
    }
    return 0;
}

int IO_IN(cob_u16_t port, cob_u8_t *mode, cob_u32_t *d_data)
{
    *d_data = 0;
    switch (mode[0])
    {
    case 'C':
    {
        uint8_t data = 0;
        asm volatile("inb %1, %0"
                     : "=a"(data)
                     : "Nd"(port));
        *d_data = data;
    }
    case 'H':
    {
        uint16_t data = 0;
        asm volatile("inw %1, %0"
                     : "=a"(data)
                     : "Nd"(port));
        *d_data = data;
    }
    case 'S':
    {
        uint32_t data = 0;
        asm volatile("inl %1, %0"
                     : "=a"(data)
                     : "Nd"(port));
        *d_data = data;
    }
    default:
        break;
    }
    return 0;
}
