      ******************************************************************
      * TEMPLATE - Quick template for new programs
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. KRNLSHEL.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       COPY "krnlhwio.cpy" REPLACING ==:PREF:== BY WS.
       01  WS-REPLY PIC X.
       01  WS-TMP PIC 9(8).
       01  SHELL-DATA.
           02 SHELL-OPNAME PIC A(20).
       LINKAGE SECTION.
       SCREEN SECTION.
       01  SHELL-PROMPT.
           02 VALUE "KINNOWOS (C) 2022-2023" BLANK SCREEN LINE 1 COL 1.
           02 VALUE "(Use TAB to switch between fields)" LINE 2 COL 1.
           02 VALUE "Operation:" LINE 3 COL 1.
           02 SH-OPNAME LINE 3 COL 15 PIC A(20)
           USING SHELL-OPNAME.
           02 VALUE "IO-PORT:" LINE 4 COL 1.
           02 SH-T1 LINE 4 COL 15 PIC 9(8)
           USING WS-HWIO-PORT.
           02 VALUE "IO-DATA:" LINE 5 COL 1.
           02 SH-T2 LINE 5 COL 15 PIC 9(8)
           USING WS-HWIO-DATA.
           02 VALUE "WS-TMP:" LINE 6 COL 1.
           02 SH-T3 LINE 6 COL 15 PIC 9(8)
           USING WS-TMP.
           02 VALUE "UART-PORT:" LINE 7 COL 1.
           02 SH-T2 LINE 7 COL 15 PIC 9(4)
           USING WS-HWIO-PORT.
           02 VALUE "OUT8 = Perform an IO operation" LINE 20 COL 1.
           02 VALUE "OUT16, OUT32, IN8, IN16, IN32" LINE 21 COL 1.
       PROCEDURE DIVISION.
           MOVE SPACE TO WS-REPLY.
           PERFORM UNTIL WS-REPLY = 'X'
               ACCEPT SHELL-PROMPT END-ACCEPT
               EVALUATE SHELL-OPNAME
                   WHEN "EXIT" MOVE 'X' TO WS-REPLY
               END-EVALUATE
               MOVE SPACES TO SHELL-OPNAME
           END-PERFORM.
           MOVE SPACE TO WS-REPLY.
           GOBACK.
       END PROGRAM KRNLSHEL.
