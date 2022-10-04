#!/bin/sh

CC="i686-elf-gcc"
CFLAGS="-ffreestanding -m32 -march=i386 -m80387 -mno-sse -mno-sse2 -fno-stack-protector -static"

echo 'LIBC ********************************************************************'
cd libc
rm *.o *.a
$CC $CFLAGS -Wall -Wextra -I . \
    crt0.S \
    lib.c \
    -c || exit

ar rcs libc.a \
    crt0.o \
    lib.o \
    || exit
cd ..

echo 'libcob ******************************************************************'
cd libcob
rm *.o *.a
$CC $CFLAGS -I .. -I . -I ../libc -I ../gmp \
    call.c \
    cobgetopt.c \
    cobcapi.c \
    fbdb.c \
    fextfh.c \
    fileio.c \
    fisam.c \
    focextfh.c \
    foci.c \
    fsqlxfd.c \
    libcobci.c \
    libcobvb.c \
    libcobvc.c \
    flmdb.c \
    fodbc.c \
    intrinsic.c \
    mlio.c \
    libcobdi.c \
    move.c \
    numeric.c \
    reportio.c \
    screenio.c \
    strings.c \
    termio.c \
    common.c \
    -c || exit

ar rcs libcob.a \
    call.o \
    cobgetopt.o \
    cobcapi.o \
    fbdb.o \
    fextfh.o \
    fileio.o \
    fisam.o \
    focextfh.o \
    foci.o \
    fsqlxfd.o \
    libcobci.o \
    libcobvb.o \
    libcobvc.o \
    flmdb.o \
    fodbc.o \
    intrinsic.o \
    mlio.o \
    libcobdi.o \
    move.o \
    numeric.o \
    reportio.o \
    screenio.o \
    strings.o \
    termio.o \
    common.o \
    || exit
cd ..
