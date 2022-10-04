/*  boot.S - bootstrap the kernel */
/*  Copyright (C) 1999, 2001, 2010  Free Software Foundation, Inc.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#define ASM_FILE    1
#include "multiboot2.h"

#define GRUB_MULTIBOOT_ARCHITECTURE_I386 0

.section .multiboot
.globl  start, _start
start:
_start:
    jmp     multiboot_entry
    /*  Multiboot header. */
    .align MULTIBOOT_HEADER_ALIGN
multiboot_header:
    /*  magic */
    .long   MULTIBOOT2_HEADER_MAGIC
    /*  ISA: i386 */
    .long   GRUB_MULTIBOOT_ARCHITECTURE_I386
    /*  Header length. */
    .long   multiboot_header_end - multiboot_header
    /*  checksum */
    .long   -(MULTIBOOT2_HEADER_MAGIC + GRUB_MULTIBOOT_ARCHITECTURE_I386 + (multiboot_header_end - multiboot_header))
#ifndef __ELF__
address_tag_start:
    .short MULTIBOOT_HEADER_TAG_ADDRESS
    .short MULTIBOOT_HEADER_TAG_OPTIONAL
    .long address_tag_end - address_tag_start
    /*  header_addr */
    .long   multiboot_header
    /*  load_addr */
    .long   _start
    /*  load_end_addr */
    .long   _edata
    /*  bss_end_addr */
    .long   _end
address_tag_end:
entry_address_tag_start:
    .short MULTIBOOT_HEADER_TAG_ENTRY_ADDRESS
    .short MULTIBOOT_HEADER_TAG_OPTIONAL
    .long entry_address_tag_end - entry_address_tag_start
    /*  entry_addr */
    .long multiboot_entry
entry_address_tag_end:
#endif /*  __ELF__ */
/*
framebuffer_tag_start:
    .short MULTIBOOT_HEADER_TAG_FRAMEBUFFER
    .short MULTIBOOT_HEADER_TAG_OPTIONAL
    .long framebuffer_tag_end - framebuffer_tag_start
    .long 640
    .long 400
    .long 32
framebuffer_tag_end:
*/
    .short MULTIBOOT_HEADER_TAG_END
    .short 0
    .long 0
multiboot_header_end:

.section .multiboot.text
multiboot_entry:
    movl $stack_top, %esp # Initialize the stack pointer
    pushl $0 # Reset EFLAGS
    popf
    pushl %ebx # Push the pointer to the Multiboot information structure
    pushl %eax # Push the magic value

    # Enable FPU
    movl %cr0, %eax
    xorl %eax, (2 << 1)
    movl %eax, %cr0

    # Enable SSE
    movl %cr4, %eax
    orl %eax, (9 << 1)
    movl %eax, %cr4

    call main # Now enter the C main function...
loop:
    hlt
    jmp loop

.section .bss
.align 16
stack_bottom:
.skip 16384 # 16 KiB
stack_top:
