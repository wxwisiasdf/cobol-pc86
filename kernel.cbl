      ******************************************************************
      *
      * Main kernel code
      *
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. KERNEL.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
           CRT STATUS IS WS-EXCEPTION-STATUS.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-END                                          PIC A(1).
       01  WS-EXCEPTION-STATUS                             PIC X(4).
       01  WS-RESIDUE                                      PIC 9(8).
       01  WS-DIVRES                                       PIC 9(8).
       01  WS-MULBY                                        PIC 9(8).
       01  WS-MULRES                                       PIC 9(8).
       01  WS-AND1                                         PIC 9(8).
       01  WS-ANDBY                                        PIC 9(8).
       01  WS-ANDRES                                       PIC 9(8).
       01  WS-OR1                                          PIC 9(8).
       01  WS-ORBY                                         PIC 9(8).
       01  WS-ORRES                                        PIC 9(8).
       01  WS-LOOP                                         PIC 9(8).
       01  WS-TMP                                          PIC 9(8).
       01  WS-TMP2                                         PIC 9(8).
       01  WS-DEBUG                                        PIC A.
       01  WS-PTR                                          USAGE IS
           POINTER.
       01  I                                               PIC S9(8)
           COMP.
       01  J                                               PIC S9(8)
           COMP.
       01  K                                               PIC S9(8)
           COMP.
       01  WS-HEXCHMAP                                     PIC X(16)
           VALUE "0123456789ABCDEF".
       01  WS-CHAR                                         PIC X.
       01  WS-INSTR                                        PIC X(8).
       01  WS-OUTSTR                                       PIC X(16).
       01  WS-REPLY                                        PIC X.
       01  WS-TIMEOUT                                      PIC 9(4).
       01  IO-PORT                                         USAGE IS
           BINARY-SHORT UNSIGNED.
       01  IO-DATA                                         USAGE IS
           BINARY-LONG UNSIGNED.
      ******************************************************************
       01  SHELL-DATA.
      ******************************************************************
           02 SHELL-OPNAME                                 PIC A(20).
      ******************************************************************
       01  DEMO-DATA.
      ******************************************************************
           02 DEMO-REPLY                                   PIC X
           VALUE SPACE.
      ******************************************************************
       01  UART-DATA.
      ******************************************************************
           02 UART-PORT                                    PIC 9(4).
      ******************************************************************
       01  SB16-DATA.
      ******************************************************************
           02 SB16-BASE                                    PIC 9(4).
           02 SB16-DSP-VER                                 PIC 9(8).
      ******************************************************************
       01  PCIE-DATA.
      ******************************************************************
           02 PCI-BUS                                      PIC 9(8).
           02 PCI-SLOT                                     PIC 9(8).
           02 PCI-FUNC                                     PIC 9(8).
           02 PCI-OFFSET                                   PIC 9(8).
           02 PCI-ADDRESS                                  PIC 9(16).
           02 PCI-DATA                                     PIC 9(8).
      ******************************************************************
       01  FLOPPY-DATA.
      ******************************************************************
           02 FLOPPY-DRIVE1                                PIC 9(2).
           02 FLOPPY-DRIVE2                                PIC 9(2).
      ******************************************************************
       01  ATAPI-DATA.
      ******************************************************************
           02 ATAPI-BUS                                    PIC 9(4).
           02 ATAPI-DRIVE                                  PIC 9(4).
           02 ATAPI-SIZE                                   PIC 9(4).
           02 ATAPI-STATUS                                 PIC 9(8).
           02 ATAPI-LBA                                    PIC 9(8).
           02 ATAPI-CMD-SIZE                               PIC 9(8).
           02 ATAPI-CMD                                    PIC X(32).
           02 ATAPI-BUF                                    PIC X(2048).
           02 ATAPI-FIRST-BUS                              PIC 9(4)
           VALUE H'1F0'.
           02 ATAPI-SECOND-BUS                             PIC 9(4)
           VALUE H'170'.
           02 ATAPI-DRIVE-MASTER                           PIC 9(4)
           VALUE H'A0'.
      ******************************************************************
       01  FILE-DATA.
      ******************************************************************
           02 FILE-NAME                                    PIC X(24).
           02 FILE-EXT                                     PIC X(3).
           02 FILE-CYL                                     PIC 9(4).
           02 FILE-SECT                                    PIC 9(4).
           02 FILE-RECORD                                  PIC 9(4).
           02 FILE-CREAT-TIME.
               05 FILE-CREAT-TIME-HOUR                     PIC 9(2).
               05 FILE-CREAT-TIME-SECOND                   PIC 9(2).
               05 FILE-CREAT-TIME-MINUTE                   PIC 9(2).
               05 FILE-CREAT-TIME-DAY                      PIC 9(2).
               05 FILE-CREAT-TIME-MONTH                    PIC 9(2).
               05 FILE-CREAT-TIME-YEAR                     PIC 9(4).
           02 FILE-RECLEN                                  PIC 9(4).
           02 FILE-NUMRECS                                 PIC 9(4).
      ******************************************************************
       01  MEM-DATA.
      ******************************************************************
           02 MEM-FREE-BYTES                               PIC 9(4).
       SCREEN SECTION.
       01  STATUS-SCREEN.
           02 VALUE "KINNOWOS (C) 2022-2023" BLANK SCREEN LINE 1 COL 1.
      * The best ASCII art you'll see ever :3
           02 VALUE "K    K                                           "
           LINE 5 COL 10.
           02 VALUE "K   K                                            "
           LINE 6 COL 10.
           02 VALUE "K  K   I NN   N NN   N  OOOO  W    W  OOO   SSSSS"
           LINE 7 COL 10.
           02 VALUE "KKK      N N  N N N  N O    O W    W O   O S     "
           LINE 8 COL 10.
           02 VALUE "K  K   I N  N N N  N N O    O W WW W O   O  SSSS "
           LINE 9 COL 10.
           02 VALUE "K   K  I N   NN N   NN O    O WW  WW O   O      S"
           LINE 10 COL 10.
           02 VALUE "K    K I N    N N    N  OOOO  W    W  OOO  SSSSS "
           LINE 11 COL 10.
           02 VALUE "[I]ntroduction" LINE 13 COL 10.
           02 VALUE "Kernal [S]hell" LINE 14 COL 10.
           02 VALUE "****" LINE 15 COL 10.
           02 VALUE "E[X]it" LINE 16 COL 10.
           02 VALUE "Option?" LINE 17 COL 10.
           02 VALUE "Hello :)" LINE 25 COL 1 BLANK LINE
           BACKGROUND-COLOR 4.
           02 KD-OPTINPUT LINE 17 COL 20 PIC X
           USING WS-REPLY.
       PROCEDURE DIVISION.
      ******************************************************************
      *
      * Kernel main procedure
      *
      ******************************************************************
       KERNEL.
      * Configure as you wish
           MOVE 'Y' TO WS-DEBUG.
           MOVE H'3F8' TO UART-PORT.
           MOVE ATAPI-FIRST-BUS TO ATAPI-BUS.
           MOVE ATAPI-DRIVE-MASTER TO ATAPI-DRIVE.
      * Perform sanity checks
           IF WS-DEBUG = 'Y'
               MOVE H'7F' TO WS-AND1
               MOVE H'0F' TO WS-ANDBY
               PERFORM BITWISE-AND
               IF WS-ANDRES NOT = H'0F'
                   DISPLAY "Bitwise and 7F & 0F gave incorrect result "
                   WS-ANDRES END-DISPLAY
                   PERFORM DEBUG-HANG
               END-IF
           END-IF.
      * Initialize main drivers
           PERFORM ATAPI-READ.
           PERFORM DEBUG-HANG.
           PERFORM UART-INIT.
           CALL "KRNLPS2C" END-CALL.
      * Display main menu
       KDEMO-MAIN-MENU.
           MOVE SPACE TO WS-REPLY.
           PERFORM UNTIL WS-REPLY = 'X'
                ACCEPT STATUS-SCREEN END-ACCEPT
                EVALUATE WS-REPLY
                    WHEN 'I' CALL "KRNLPRES" END-CALL
                    WHEN 'S' CALL "KRNLSHEL" END-CALL
                    WHEN 'X' PERFORM KDEMO-EXIT
                END-EVALUATE
           END-PERFORM.
           STOP RUN.
       KDEMO-ERROR.
           ACCEPT WS-EXCEPTION-STATUS FROM EXCEPTION STATUS END-ACCEPT.
           DISPLAY "." BLANK LINE AT LINE 25 COL 1
           WITH BACKGROUND-COLOR 4 END-DISPLAY.
           DISPLAY WS-EXCEPTION-STATUS AT LINE 25 COL 1
           WITH BACKGROUND-COLOR 4 END-DISPLAY.
           IF WS-EXCEPTION-STATUS NOT EQUAL "1000" THEN
               DISPLAY "Press any key to continue" AT LINE 25 COL 30
               WITH BACKGROUND-COLOR 4 END-DISPLAY
               ACCEPT WS-REPLY END-ACCEPT
               STOP RUN
           END-IF.
       KDEMO-EXIT.
      * Hacky VM shutdown, for VMware, qemu and bochs
           MOVE H'2000' TO IO-DATA.
           MOVE H'B004' TO IO-PORT.
           PERFORM IO-OUT-16.
           MOVE H'2000' TO IO-DATA.
           MOVE H'0604' TO IO-PORT.
           PERFORM IO-OUT-16.
           MOVE H'3400' TO IO-DATA.
           MOVE H'4004' TO IO-PORT.
           PERFORM IO-OUT-16.
           STOP RUN.
      ******************************************************************
      *
      * File management services driver
      *
      ******************************************************************
       FILE-CREATE.
           MULTIPLY FILE-RECLEN BY FILE-NUMRECS GIVING WS-MULRES
           END-MULTIPLY.
           ALLOCATE WS-MULRES CHARACTERS INITIALIZED RETURNING WS-PTR.
      ******************************************************************
      *
      * ATAPI Driver
      *
      ******************************************************************
       ATAPI-SECTION SECTION.
       ATAPI-INIT.
      * Reads a part of the disk onto ATAPI-BUFFER, set ATAPI-SIZE
      * previously ;)
       ATAPI-READ.
           PERFORM ATAPI-DRIVESEL.
      * Clear the command buffer first
           MOVE ZEROES TO ATAPI-CMD.
           MOVE 12 TO ATAPI-CMD-SIZE.
           MOVE H'A8' TO ATAPI-CMD(1:1).
           MOVE 1 TO ATAPI-CMD(10:1).
      * Low byte
           MOVE ATAPI-LBA TO ATAPI-CMD(6:1).
      * Second byte, shift by 8 bits
           MOVE ATAPI-LBA TO WS-TMP.
           DIVIDE WS-TMP BY H'100' GIVING WS-TMP END-DIVIDE.
           MOVE WS-TMP TO ATAPI-CMD(5:1).
      * Third byte, shift by 16 bits
           MOVE ATAPI-LBA TO WS-TMP.
           DIVIDE WS-TMP BY H'10000' GIVING WS-TMP END-DIVIDE.
           MOVE WS-TMP TO ATAPI-CMD(4:1).
      * Last byte, shift by 24 bits
           MOVE ATAPI-LBA TO WS-TMP.
           DIVIDE WS-TMP BY H'1000000' GIVING WS-TMP END-DIVIDE.
           MOVE WS-TMP TO ATAPI-CMD(3:1).
           PERFORM ATAPI-SEND-COMMAND.
      * Obtain the size of the read (high byte first)
           COMPUTE IO-PORT = ATAPI-BUS + 5 END-COMPUTE.
           PERFORM IO-IN-8.
           COMPUTE WS-TMP = IO-DATA * H'100' END-COMPUTE.
           COMPUTE IO-PORT = ATAPI-BUS + 4 END-COMPUTE.
           PERFORM IO-IN-8.
           COMPUTE WS-TMP = WS-TMP + IO-DATA END-COMPUTE.
           DISPLAY "Read size is " WS-TMP END-DISPLAY.
           DISPLAY "TODO: Read" END-DISPLAY.
       ATAPI-DRIVESEL.
           IF WS-DEBUG = 'Y'
               IF ATAPI-DRIVE NOT = ATAPI-DRIVE-MASTER
                   DISPLAY "Invalid ATA drive " ATAPI-DRIVE END-DISPLAY
                   PERFORM DEBUG-HANG
               END-IF
               IF ATAPI-BUS NOT = ATAPI-FIRST-BUS AND
               ATAPI-BUS NOT = ATAPI-SECOND-BUS
                   DISPLAY "Invalid ATA bus " ATAPI-BUS END-DISPLAY
                   PERFORM DEBUG-HANG
               END-IF
           END-IF.
           COMPUTE IO-PORT = ATAPI-BUS + 7 END-COMPUTE.
           PERFORM IO-IN-8.
           IF IO-DATA = H'FF'
               DISPLAY "Warning: Drive on bus " ATAPI-BUS " not present"
               END-DISPLAY
           END-IF.
           COMPUTE IO-PORT = ATAPI-BUS + 6 END-COMPUTE.
           MOVE ATAPI-DRIVE TO IO-DATA.
           PERFORM IO-OUT-8.
      * 4ns wait
           COMPUTE IO-PORT = ATAPI-BUS + H'206' END-COMPUTE.
           PERFORM IO-IN-8.
           PERFORM IO-IN-8.
           PERFORM IO-IN-8.
           PERFORM IO-IN-8.
       ATAPI-SEND-COMMAND.
      * Perform operation via PIO
           COMPUTE IO-PORT = ATAPI-BUS + 1 END-COMPUTE.
           MOVE 0 TO IO-DATA.
           PERFORM IO-OUT-8.
      * Tell the controller the size of our read, first send the low
      * part of the integer
           MOVE ATAPI-SIZE TO WS-AND1.
           MOVE H'FF' TO WS-ANDBY.
           PERFORM BITWISE-AND.
           MOVE WS-ANDRES TO IO-DATA.
           COMPUTE IO-PORT = ATAPI-BUS + 4 END-COMPUTE.
           PERFORM IO-OUT-8.
      * Now send the high part
           DIVIDE ATAPI-SIZE BY 256 GIVING WS-DIVRES END-DIVIDE.
           MOVE WS-DIVRES TO IO-DATA.
           COMPUTE IO-PORT = ATAPI-BUS + 5 END-COMPUTE.
           PERFORM IO-OUT-8.
      * Tell it's an ATA PACKET command
           COMPUTE IO-PORT = ATAPI-BUS + 7 END-COMPUTE.
           MOVE H'A0' TO IO-DATA.
           PERFORM IO-OUT-8.
           PERFORM ATAPI-WAIT-1.
           PERFORM ATAPI-WAIT-2.
      * Check bit 1 is not set
           MOVE ATAPI-STATUS TO WS-AND1.
           MOVE H'01' TO WS-ANDBY.
           PERFORM BITWISE-AND.
           IF WS-ANDRES NOT = 0
               DISPLAY "ATAPI bit 1 not clear" END-DISPLAY
           END-IF.
      * Send the command to the ATAPI controller, notice how it's being
      * outputted in chunks of 16-bits
           MOVE ATAPI-CMD-SIZE TO WS-LOOP.
           MOVE ATAPI-BUS TO IO-PORT.
           PERFORM UNTIL WS-LOOP = 0
               MOVE ATAPI-CMD(WS-LOOP:1) TO IO-DATA
               PERFORM IO-OUT-16
               SUBTRACT 1 FROM WS-LOOP END-SUBTRACT
           END-PERFORM.
       ATAPI-WAIT-1.
           MOVE 5 TO WS-TIMEOUT.
           MOVE 0 TO ATAPI-STATUS.
           COMPUTE IO-PORT = ATAPI-BUS + 7 END-COMPUTE.
           PERFORM UNTIL ATAPI-STATUS NOT = 0 OR WS-TIMEOUT = 0
               PERFORM IO-IN-8
               MOVE IO-DATA TO WS-AND1
               MOVE H'80' TO WS-ANDBY
               PERFORM BITWISE-AND
               MOVE WS-ANDRES TO ATAPI-STATUS
               SUBTRACT 1 FROM WS-TIMEOUT END-SUBTRACT
           END-PERFORM.
       ATAPI-WAIT-2.
           MOVE 5 TO WS-TIMEOUT.
           MOVE 0 TO ATAPI-STATUS.
           COMPUTE IO-PORT = ATAPI-BUS + 7 END-COMPUTE.
           PERFORM UNTIL ATAPI-STATUS = 0 OR WS-TIMEOUT = 0
               PERFORM IO-IN-8
      * Bit 3 has to be clear
               MOVE IO-DATA TO WS-AND1
               MOVE H'08' TO WS-ANDBY
               PERFORM BITWISE-AND
               MOVE WS-ANDRES TO ATAPI-STATUS
      * Bit 0 also has to be clear
               MOVE IO-DATA TO WS-AND1
               MOVE H'01' TO WS-ANDBY
               PERFORM BITWISE-AND
               ADD WS-ANDRES TO ATAPI-STATUS END-ADD
               SUBTRACT 1 FROM WS-TIMEOUT END-SUBTRACT
           END-PERFORM.
      ******************************************************************
      *
      * UART driver
      *
      ******************************************************************
       UART-SECTION SECTION.
       UART-INIT.
      * Disable interrupts
           COMPUTE IO-PORT = UART-PORT + 1 END-COMPUTE.
           MOVE H'00' TO IO-DATA.
           PERFORM IO-OUT-8.
      * Enable DLAB
           COMPUTE IO-PORT = UART-PORT + 3 END-COMPUTE.
           MOVE H'80' TO IO-DATA.
           PERFORM IO-OUT-8.
      * Set divisor to 3
           COMPUTE IO-PORT = UART-PORT + 0 END-COMPUTE.
           MOVE H'03' TO IO-DATA.
           PERFORM IO-OUT-8.
           COMPUTE IO-PORT = UART-PORT + 1 END-COMPUTE.
           MOVE H'00' TO IO-DATA.
           PERFORM IO-OUT-8.
      * 8 bits and no parity with one stop bit
           COMPUTE IO-PORT = UART-PORT + 3 END-COMPUTE.
           MOVE H'03' TO IO-DATA.
           PERFORM IO-OUT-8.
      * Enable FIFO, clear and with a 14-byte threshold
           COMPUTE IO-PORT = UART-PORT + 2 END-COMPUTE.
           MOVE H'C7' TO IO-DATA.
           PERFORM IO-OUT-8.
      * Enable IRQs back, set RTS and DSR, the Data (???) Register
      * and the RTS register (no shit)
           COMPUTE IO-PORT = UART-PORT + 4 END-COMPUTE.
           MOVE H'0B' TO IO-DATA.
           PERFORM IO-OUT-8.
      * Set in loopback mode and test the serial chip in loopback
      * a good serial port should return (loop) what we send over
           MOVE H'1E' TO IO-DATA.
           PERFORM IO-OUT-8.
           MOVE UART-PORT TO IO-PORT.
           PERFORM UART-TEST.
      * Set on normal operation mode, that is a non-loopback mode with
      * IRQs enabeld and OUT#1 and OUT#2 bits enabled :)
           COMPUTE IO-PORT = UART-PORT + 4 END-COMPUTE.
           MOVE H'0F' TO IO-DATA.
           PERFORM IO-OUT-8.
           DISPLAY "UART initialized" END-DISPLAY.
       UART-TEST.
      * Test the serial chip (sending a dummy byte and checking if it
      * returns the same byte)
           MOVE H'AE' TO IO-DATA.
           PERFORM IO-OUT-8.
           IF WS-DEBUG = 'Y' DISPLAY ">" IO-DATA END-DISPLAY END-IF.
           PERFORM IO-IN-8.
           IF WS-DEBUG = 'Y' DISPLAY ">" IO-DATA END-DISPLAY END-IF.
           IF IO-DATA NOT = H'AE'
               DISPLAY "UART test failure" END-DISPLAY
           END-IF.
      ******************************************************************
      *
      * Floppy disk driver
      *
      ******************************************************************
       FLOPPY-SECTION SECTION.
       INIT-FLOPPY.
           MOVE H'70' TO IO-PORT.
           MOVE H'10' TO IO-DATA.
           PERFORM IO-OUT-8.
      * Obtain the result of the query from the CMOS, remember the uwu
      * actual floppy data is split between the 2 nibbles of the byte
           MOVE H'71' TO IO-PORT.
           PERFORM IO-IN-8.
           MOVE IO-DATA TO FLOPPY-DRIVE1.
           DIVIDE FLOPPY-DRIVE1 BY H'0F' GIVING WS-DIVRES END-DIVIDE.
           MOVE WS-DIVRES TO FLOPPY-DRIVE1.
           MOVE IO-DATA TO FLOPPY-DRIVE2.
           DIVIDE FLOPPY-DRIVE2 BY H'0F' GIVING WS-DIVRES
           REMAINDER WS-RESIDUE END-DIVIDE.
           DISPLAY "Floppy drives initialized " FLOPPY-DRIVE1
           FLOPPY-DRIVE2 END-DISPLAY.
      ******************************************************************
      *
      * Soundblaster driver
      *
      ******************************************************************
       SB16-SECTION SECTION.
       INIT-SB16.
      * Send the first DSP
           COMPUTE IO-PORT = SB16-BASE + H'0206' END-COMPUTE.
           MOVE H'0206' TO IO-PORT.
           MOVE H'01' TO IO-DATA.
           PERFORM IO-OUT-8.
      * TODO: Wait for 3ms
      * Do a final DSP reset
           MOVE H'00' TO IO-DATA.
           PERFORM IO-OUT-8.
           COMPUTE IO-PORT = SB16-BASE + H'020A' END-COMPUTE.
           PERFORM IO-IN-8.
           IF IO-DATA = H'AA'
               MOVE 'N' TO WS-END
               PERFORM UNTIL WS-END = 'Y'
                   PERFORM IO-IN-8
      * Check that the given bit is set
                   DIVIDE IO-DATA BY H'80' GIVING WS-DIVRES
                   REMAINDER WS-RESIDUE END-DIVIDE
                   IF WS-RESIDUE = '0'
                       MOVE 'Y' TO WS-END
                   END-IF
               END-PERFORM
               COMPUTE IO-PORT = SB16-BASE + H'020C' END-COMPUTE
               MOVE H'E1' TO IO-DATA
               PERFORM IO-OUT-8
      * Obtain the DSP version (hi first, low second)
               COMPUTE IO-PORT = SB16-BASE + H'020A' END-COMPUTE
               PERFORM IO-IN-8
               MOVE IO-DATA TO SB16-DSP-VER
               MOVE H'10000' TO WS-MULBY
               MULTIPLY SB16-DSP-VER BY WS-MULBY GIVING SB16-DSP-VER
               END-MULTIPLY
               PERFORM IO-IN-8
               ADD IO-DATA TO SB16-DSP-VER END-ADD
      * TODO: Set IRQ to send data to
               COMPUTE IO-PORT = SB16-BASE + H'0204' END-COMPUTE
               MOVE H'80' TO IO-DATA
               PERFORM IO-OUT-8
      * Serve IRQ 5
               COMPUTE IO-PORT = SB16-BASE + H'0205' END-COMPUTE
               MOVE H'02' TO IO-DATA
               PERFORM IO-OUT-8
           ELSE
               DISPLAY "Unable to initialize soundblaster" END-DISPLAY
           END-IF.
      ******************************************************************
      *
      * PCI Driver
      *
      ******************************************************************
       PCI-SECTION SECTION.
       PCI-INIT.
           DISPLAY "PCI driver not implemented properly" END-DISPLAY.
      * Computes the address of the PCI given an OFFSET
      * an SLOT and a FUNC
       PCI-COMPUTE-ADDR.
           MOVE H'80000000' TO PCI-ADDRESS.
           MOVE PCI-OFFSET TO WS-AND1.
           MOVE H'FC' TO WS-ANDBY.
           PERFORM BITWISE-AND.
           ADD WS-ANDRES TO PCI-ADDRESS END-ADD.
      * Shift func by 8
           MOVE H'100' TO WS-MULBY.
           MULTIPLY PCI-FUNC BY WS-MULBY GIVING WS-MULRES END-MULTIPLY.
           ADD WS-MULRES TO PCI-ADDRESS END-ADD.
      * Shift slot by 11
           MOVE H'800' TO WS-MULBY.
           MULTIPLY PCI-SLOT BY WS-MULBY GIVING WS-MULRES END-MULTIPLY.
           ADD WS-MULRES TO PCI-ADDRESS END-ADD.
      * Shift bus by 16
           MOVE H'10000' TO WS-MULBY.
           MULTIPLY PCI-BUS BY WS-MULBY GIVING WS-MULRES END-MULTIPLY.
           ADD WS-MULRES TO PCI-ADDRESS END-ADD.
      * Reads a 32-bit value from the PCI subsystem root complex
      * management thing
      * Use PCI-ADDRESS, PCI-OFFSET, PCI-SLOT and PCI-FUNC accordingly
      * and thou shall receive your data in PCI-DATA <3
       PCI-READ-32.
           PERFORM PCI-COMPUTE-ADDR.
           MOVE H'0CF8' TO IO-PORT.
           MOVE PCI-ADDRESS TO IO-DATA.
           PERFORM IO-OUT-32.
           MOVE H'0CFC' TO IO-PORT.
           PERFORM IO-IN-32.
           MOVE IO-DATA TO PCI-DATA.
      * Use PCI-DATA for sending the value <3
       PCI-WRITE-32.
           PERFORM PCI-COMPUTE-ADDR.
           MOVE H'0CF8' TO IO-PORT.
           MOVE PCI-ADDRESS TO IO-DATA.
           PERFORM IO-OUT-32.
           MOVE H'0CFC' TO IO-PORT.
           MOVE PCI-DATA TO IO-DATA.
           PERFORM IO-OUT-32.
      ******************************************************************
      *
      * I/O procedures
      *
      ******************************************************************
       IO-SECTION SECTION.
       IO-OUT-8.
           CALL STATIC "IO_OUT"
           USING BY VALUE UNSIGNED SIZE IS 2 IO-PORT
           BY VALUE UNSIGNED SIZE IS 4 IO-DATA
           BY CONTENT 'C'
           END-CALL.
           PERFORM DEBUG-PRINT-OUT.
       IO-OUT-16.
           CALL STATIC "IO_OUT"
           USING BY VALUE UNSIGNED SIZE IS 2 IO-PORT
           BY VALUE UNSIGNED SIZE IS 4 IO-DATA
           BY CONTENT 'H'
           END-CALL.
           PERFORM DEBUG-PRINT-OUT.
       IO-OUT-32.
           CALL STATIC "IO_OUT"
           USING BY VALUE UNSIGNED SIZE IS 2 IO-PORT
           BY VALUE UNSIGNED SIZE IS 4 IO-DATA
           BY CONTENT 'S'
           END-CALL.
           PERFORM DEBUG-PRINT-OUT.
       IO-IN-8.
           CALL STATIC "IO_IN"
           USING BY VALUE UNSIGNED SIZE IS 2 IO-PORT
           BY CONTENT 'C'
           BY REFERENCE IO-DATA
           END-CALL.
           PERFORM DEBUG-PRINT-IN.
       IO-IN-16.
           CALL STATIC "IO_IN"
           USING BY VALUE UNSIGNED SIZE IS 2 IO-PORT
           BY CONTENT 'S'
           BY REFERENCE IO-DATA
           END-CALL.
           PERFORM DEBUG-PRINT-IN.
       IO-IN-32.
           CALL STATIC "IO_IN"
           USING BY VALUE UNSIGNED SIZE IS 2 IO-PORT
           BY CONTENT 'H'
           BY REFERENCE IO-DATA
           END-CALL.
           PERFORM DEBUG-PRINT-IN.
       DEBUG-PRINT-OUT.
           IF WS-DEBUG = 'Y'
               DISPLAY "OUT: " IO-PORT " <- " IO-DATA "; " NO ADVANCING
               END-DISPLAY
           END-IF.
       DEBUG-PRINT-IN.
           IF WS-DEBUG = 'Y'
               DISPLAY "IN: " IO-PORT " -> " IO-DATA "; " NO ADVANCING
               END-DISPLAY
           END-IF.
      ******************************************************************
      *
      * Low-level bit manipulation
      *
      ******************************************************************
       ARITH-SECTION SECTION.
      * Perform a bitwise AND operation
      * given WS-AND1 and WS-ANDBY perform (WS-AND1 & WS-ANDBY)
      * to give WS-ANDRES
       BITWISE-AND.
           MOVE 0 TO WS-ANDRES.
           MOVE 1 TO I.
           PERFORM UNTIL WS-AND1 = 0 OR WS-ANDBY = 0
               DIVIDE WS-AND1 BY 2 GIVING WS-AND1 REMAINDER WS-TMP
               END-DIVIDE
               DIVIDE WS-ANDBY BY 2 GIVING WS-ANDBY REMAINDER WS-TMP2
               END-DIVIDE
               IF WS-TMP = 1 AND WS-TMP2 = 1
                   ADD I TO WS-ANDRES END-ADD
               END-IF
               MOVE 2 TO WS-MULBY
               MULTIPLY I BY WS-MULBY GIVING I END-MULTIPLY
           END-PERFORM.
       BITWISE-OR.
           MOVE 0 TO WS-ORRES.
           MOVE 1 TO I.
           PERFORM UNTIL WS-OR1 = 0 OR WS-ORBY = 0
               DIVIDE WS-OR1 BY 2 GIVING WS-OR1 REMAINDER WS-TMP
               END-DIVIDE
               DIVIDE WS-ORBY BY 2 GIVING WS-ORBY REMAINDER WS-TMP2
               END-DIVIDE
               IF WS-TMP = 1 OR WS-TMP2 = 1
                   ADD I TO WS-ORRES END-ADD
               END-IF
               MOVE 2 TO WS-MULBY
               MULTIPLY I BY WS-MULBY GIVING I END-MULTIPLY
           END-PERFORM.
      ******************************************************************
      *
      * Miscellaneous utilities
      *
      ******************************************************************
       UTIL-SECTION SECTION.
      * Hang forever (for debug purpouses)
       DEBUG-HANG.
           IF WS-DEBUG = 'A'
               MOVE SPACE TO WS-REPLY
               PERFORM UNTIL WS-REPLY = 'X'
                   MOVE WS-REPLY TO WS-REPLY
               END-PERFORM
           END-IF.
      * A dummy exit to catch paragraphs going out of bounds
       DUMMY-EXIT.
           DISPLAY "Using a dummy exit ^^" END-DISPLAY.
