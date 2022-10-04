#!/bin/sh

CC="i686-elf-gcc"
CFLAGS="-ffreestanding -m32 -march=i386 -m80387 -mno-sse -mno-sse2 -fno-stack-protector -static"

rm kernel.c
rm kernel.c.h
rm kernel.c.l.h
rm kernel.elf

cobc kernel.cbl -Wall -Wextra -C -fstatic-call -fixed -std=mvs -o kernel.c
$CC $CFLAGS -static-libgcc -nostdlib -I libcob -I gmp -I . -I libc -L libc -L gmp/.libs -L libcob \
    -T linker.ld \
    -o kernel.elf \
    kernel.c \
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
