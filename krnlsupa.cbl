      ******************************************************************
      * KRNLSUPA - Kernel support code
      ******************************************************************
      ******************************************************************
      * HTOPRINT - Hexadecimal character to printable character
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. HTOPRINT.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-RESIDUE PIC 9(8).
       01  WS-DIVRES PIC 9(8).
       01  I PIC S9(8) COMP.
       01  J PIC S9(8) COMP.
       01  WS-HEXCHMAP PIC X(16) VALUE "0123456789ABCDEF".
       01  WS-CHAR PIC X.
       01  WS-INSTR PIC X(8).
       01  WS-OUTSTR PIC X(16).
       PROCEDURE DIVISION.
       HEX-TO-PRINTABLE.
           MOVE SPACES TO WS-OUTSTR.
           PERFORM VARYING I FROM 1 BY 1 UNTIL I > LENGTH OF WS-INSTR
      * Reminder: Every byte is equal to 2 characters as each character
      * is representative of a nibble, and a byte is two nibbles
               COMPUTE J = (I * 2) - 1 END-COMPUTE
      * Calculate low nibble first
               MOVE WS-INSTR(I:1) TO WS-CHAR
               PERFORM HCHAR-TO-PRINTABLE
               MOVE WS-CHAR TO WS-OUTSTR(J:1)
      * Then calculate the high nibble
               MOVE WS-INSTR(I:1) TO WS-CHAR
               DIVIDE WS-CHAR BY 16 GIVING WS-DIVRES REMAINDER
               WS-RESIDUE END-DIVIDE
               MOVE WS-DIVRES TO WS-CHAR
               PERFORM HCHAR-TO-PRINTABLE
               ADD 1 TO J END-ADD
               MOVE WS-CHAR TO WS-OUTSTR(J:1)
           END-PERFORM.
           GOBACK.
       HCHAR-TO-PRINTABLE.
      * Convert WS-CHAR to a printable character
           DIVIDE WS-CHAR BY 16 GIVING WS-DIVRES REMAINDER WS-RESIDUE
           END-DIVIDE.
           ADD 1 TO WS-RESIDUE END-ADD.
           MOVE WS-HEXCHMAP(WS-RESIDUE:1) TO WS-CHAR.
       END PROGRAM HTOPRINT.
      ******************************************************************
      * SUBITAND - Obtain bitwise AND of two numbers
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. SUBITAND.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  I PIC S9(8) COMP.
       01  WS-MULBY PIC 9(8).
       01  WS-MULRES PIC 9(8).
       01  WS-TMP PIC 9(8).
       01  WS-TMP2 PIC 9(8).
       LINKAGE SECTION.
       01  L-ARGS.
           05 L-AND1 PIC 9(8).
           05 L-ANDBY PIC 9(8).
           05 L-ANDRES PIC 9(8).
       PROCEDURE DIVISION.
      * Perform a bitwise AND operation
      * given L-AND1 and L-ANDBY perform (L-AND1 & L-ANDBY)
      * to give L-ANDRES
       BITWISE-AND.
           MOVE 0 TO L-ANDRES.
           MOVE 1 TO I.
           PERFORM UNTIL L-AND1 = 0 OR L-ANDBY = 0
               DIVIDE L-AND1 BY 2 GIVING L-AND1 REMAINDER WS-TMP
               END-DIVIDE
               DIVIDE L-ANDBY BY 2 GIVING L-ANDBY REMAINDER WS-TMP2
               END-DIVIDE
               IF WS-TMP = 1 AND WS-TMP2 = 1
                   ADD I TO L-ANDRES END-ADD
               END-IF
               MOVE 2 TO WS-MULBY
               MULTIPLY I BY WS-MULBY GIVING I END-MULTIPLY
           END-PERFORM.
       END PROGRAM SUBITAND.
