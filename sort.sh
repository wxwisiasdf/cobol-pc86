#!/bin/sh
[ -f linesort ] ||cobc -x linesort.cbl -o linesort || exit
./linesort >kernel.cbl.1
