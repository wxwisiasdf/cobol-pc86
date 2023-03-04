      ******************************************************************
      * KRNLPRES - Kernel presentation and demostrations
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. KRNLPRES.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-REPLY PIC X.
       LINKAGE SECTION.
       SCREEN SECTION.
       01  INTRO-SCREEN-1.
           02 VALUE "KINNOWOS (C) 2022-2023" BLANK SCREEN LINE 1 COL 1.
           02 VALUE "Why COBOL?" LINE 5 COL 10.
           02 VALUE "Why NOT COBOL? It's a great language!"
           LINE 7 COL 10.
           02 VALUE "* It's sophisticated" LINE 8 COL 10.
           02 VALUE "* It's verbose" LINE 9 COL 10.
           02 VALUE "* Dynamically typed" LINE 10 COL 10.
           02 VALUE "* It looks cool with syntax highlight" LINE 11
           COL 10.
       01  INTRO-SCREEN-2.
           02 VALUE "KINNOWOS (C) 2022-2023" BLANK SCREEN LINE 1 COL 1.
           02 VALUE "B-b-but COBOL is outdated!" LINE 5 COL 10.
           02 VALUE "Lies, COBOL just had a revision ongoing this year!"
           LINE 7 COL 10.
           02 VALUE "* The COBOL 2023 standard" LINE 8 COL 10.
           02 VALUE "* GnuCCOBOL is being actively developed in 2023"
           LINE 9 COL 10.
           02 VALUE "  and said compiler is one of the best I've used"
           LINE 10 COL 10.
           02 VALUE "* C is from 1970, yet people still use it"
           LINE 11 COL 10.
           02 VALUE "* and C++ is from the 80's! Being old doesn't "
           LINE 12 COL 10.
           02 VALUE " mean that it is inherently bad!" LINE 13 COL 10.
       01  INTRO-SCREEN-3.
           02 VALUE "KINNOWOS (C) 2022-2023" BLANK SCREEN LINE 1 COL 1.
           02 VALUE "Goals and vision" LINE 5 COL 10.
           02 VALUE "* Monolthic kernel" LINE 7 COL 10.
           02 VALUE "* All system utilities written on COBOL"
           LINE 8 COL 10.
           02 VALUE "* Remove as much C code from the kernel"
           LINE 9 COL 10.
       01  INTRO-SCREEN-4.
           02 VALUE "KINNOWOS (C) 2022-2023" BLANK SCREEN LINE 1 COL 1.
           02 VALUE "The end" LINE 5 COL 10.
           02 VALUE "That was a quick slideshow wasn't it?"
           LINE 7 COL 10.
           02 VALUE "I would've added more slides but I think"
           LINE 8 COL 10.
           02 VALUE "it's better that the OS speaks by itself"
           LINE 9 COL 10.
           02 VALUE "so why not try out the kernel shell?"
           LINE 10 COL 10.
       01  INTRO-SCREEN-INPUT.
           02 VALUE "(press B for going back or P/N for slide control)"
           LINE 20 COL 10.
           02 KD-OPTINPUT LINE 20 COL 70 PIC X
           USING WS-REPLY.
       PROCEDURE DIVISION.
       KDEMO-INTRO-1.
           DISPLAY INTRO-SCREEN-1 END-DISPLAY.
           MOVE SPACE TO WS-REPLY.
           PERFORM UNTIL WS-REPLY = 'B'
               ACCEPT INTRO-SCREEN-INPUT END-ACCEPT
               EVALUATE WS-REPLY
                   WHEN 'N' PERFORM KDEMO-INTRO-2
                   WHEN 'P' EXIT PERFORM
               END-EVALUATE
           END-PERFORM.
           MOVE SPACE TO WS-REPLY.
           GOBACK.
       KDEMO-INTRO-2.
           DISPLAY INTRO-SCREEN-2 END-DISPLAY.
           MOVE SPACE TO WS-REPLY.
           PERFORM UNTIL WS-REPLY = 'B'
               ACCEPT INTRO-SCREEN-INPUT END-ACCEPT
               EVALUATE WS-REPLY
                   WHEN 'N' PERFORM KDEMO-INTRO-3
                   WHEN 'P' PERFORM KDEMO-INTRO-1
               END-EVALUATE
           END-PERFORM.
           MOVE SPACE TO WS-REPLY.
           GOBACK.
       KDEMO-INTRO-3.
           DISPLAY INTRO-SCREEN-3 END-DISPLAY.
           MOVE SPACE TO WS-REPLY.
           PERFORM UNTIL WS-REPLY = 'B'
               ACCEPT INTRO-SCREEN-INPUT END-ACCEPT
               EVALUATE WS-REPLY
                   WHEN 'N' PERFORM KDEMO-INTRO-4
                   WHEN 'P' PERFORM KDEMO-INTRO-2
               END-EVALUATE
           END-PERFORM.
           MOVE SPACE TO WS-REPLY.
           GOBACK.
       KDEMO-INTRO-4.
           DISPLAY INTRO-SCREEN-4 END-DISPLAY.
           MOVE SPACE TO WS-REPLY.
           PERFORM UNTIL WS-REPLY = 'B'
               ACCEPT INTRO-SCREEN-INPUT END-ACCEPT
               EVALUATE WS-REPLY
                   WHEN 'N' EXIT PERFORM
                   WHEN 'P' PERFORM KDEMO-INTRO-3
               END-EVALUATE
           END-PERFORM.
           MOVE SPACE TO WS-REPLY.
           GOBACK.
       END PROGRAM KRNLPRES.
