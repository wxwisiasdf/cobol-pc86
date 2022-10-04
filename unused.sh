#!/bin/sh
nm libcob/*.o libc/*.o gmp/*.o gmp/mpn/*.o gmp/mpz/*.o gmp/mpf/*.o | grep "^[0-9a-f]* T " | sed 's/^[0-9a-f]* T //' | sort -u > symbols_in.txt
nm kernel.elf | grep "^[0-9a-f]* T " | sed 's/^[0-9a-f]* T //' | sort -u > symbols_in2.txt
diff symbols_in.txt symbols_in2.txt >symbols.diff
rm symbols_in2.txt symbols_in.txt
