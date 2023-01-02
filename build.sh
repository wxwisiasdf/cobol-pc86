#!/bin/sh

CC="i686-elf-gcc"
CFLAGS="-ffreestanding -m32 -march=i386 -m80387 -mno-sse -mno-sse2 -fno-stack-protector -static"
COBFLAGS="-Wall -Wextra -C -fstatic-call -fixed -std=mvs -DCOB_SOURCE"

rm kernel.c krnlsupa.c krnlps2c.c krnlhwio.c
rm *.c.h *.c.l.h
rm kernel.elf

cobc $COBFLAGS kernel.cbl -o kernel.c || exit
cobc $COBFLAGS krnlsupa.cbl -o krnlsupa.c || exit
cobc $COBFLAGS krnlps2c.cbl -o krnlps2c.c || exit
cobc $COBFLAGS krnlhwio.cbl -o krnlhwio.c || exit
cobc $COBFLAGS krnlpres.cbl -o krnlpres.c || exit
cobc $COBFLAGS krnlshel.cbl -o krnlshel.c || exit
cobc $COBFLAGS krnlstub.cbl -o krnlstub.c || exit
cobc $COBFLAGS krnlcurs.cbl -o krnlcurs.c || exit
cobc $COBFLAGS krnlgetx.cbl -o krnlgetx.c || exit
cobc $COBFLAGS krnlltdl.cbl -o krnlltdl.c || exit

$CC $CFLAGS -static-libgcc -nostdlib -I libcob -I gmp -I . -I libc -L libc -L gmp/.libs -L libcob \
    -T linker.ld \
    -o kernel.elf \
    kernel.c \
    krnlsupa.c \
    krnlps2c.c \
    krnlhwio.c \
    krnlpres.c \
    krnlshel.c \
    krnlstub.c \
    krnlcurs.c \
    krnlgetx.c \
    krnlltdl.c \
    main.c \
    -lc \
    -lcob \
    -lgmp \
    -lgcc || exit

rm lmvxsaos.iso
rm -r isodir/

mkdir -p isodir/boot/grub/ || exit
cp kernel.elf isodir/boot/ || exit
cp grub.cfg isodir/boot/grub/ || exit
grub-mkrescue -o lmvxsaos.iso isodir || exit

qemu-system-i386 -s -cdrom lmvxsaos.iso
