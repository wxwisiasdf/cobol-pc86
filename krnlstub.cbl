      ******************************************************************
      * KRNLSTUB - Multiple stubs for libc function
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. fopen2.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       LINKAGE SECTION.
       01  L-NAME PIC X(20).
       01  L-MODE PIC X(20).
       01  L-FILE.
           05 L-INDEX PIC 9(4).
       PROCEDURE DIVISION USING BY REFERENCE L-NAME,
           BY REFERENCE L-MODE RETURNING L-FILE.
           IF L-NAME IS = "./runtime.cfg" THEN
               GOBACK
           END-IF.
           GOBACK.
       END PROGRAM fopen2.
      *-----------------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. strncmp.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  I PIC 9(4) COMP.
       LINKAGE SECTION.
       01  L-S1 PIC X(20).
       01  L-S2 PIC X(20).
       01  L-LEN USAGE IS BINARY-LONG UNSIGNED.
       PROCEDURE DIVISION USING BY REFERENCE L-S1,
           BY REFERENCE L-S2.
           MOVE 0 TO RETURN-CODE.
           PERFORM VARYING I FROM 1 BY 1 UNTIL I > L-LEN
               IF L-S1(I:1) IS NOT = L-S2(I:1) THEN
                   MOVE 1 TO RETURN-CODE
                   GOBACK
               END-IF
           END-PERFORM.
           GOBACK.
       END PROGRAM strncmp.
      *-----------------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. srand.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       LINKAGE SECTION.
       01  L-SEED USAGE IS BINARY-LONG UNSIGNED.
       PROCEDURE DIVISION USING BY VALUE L-SEED.
           MOVE 0 TO RETURN-CODE.
           GOBACK.
       END PROGRAM srand.
      *-----------------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. islower.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  I PIC 9(4) COMP.
       01  WS-CMP PIC X(27) VALUE "qwertyuiopasdfghjklzxcvbnm".
       LINKAGE SECTION.
       01  L-CHAR USAGE IS BINARY-LONG.
       PROCEDURE DIVISION USING BY VALUE L-CHAR.
           MOVE 0 TO RETURN-CODE.
           PERFORM VARYING I FROM 1 BY 1 UNTIL I > LENGTH OF WS-CMP
               IF L-CHAR IS = WS-CMP(I:1) THEN
                   MOVE 1 TO RETURN-CODE
                   GOBACK
               END-IF
           END-PERFORM.
           GOBACK.
       END PROGRAM islower.
      *-----------------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. isupper.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  I PIC 9(4) COMP.
       01  WS-CMP PIC X(27) VALUE "QWERTYUIOPASDFGHJKLZXCVBNM".
       LINKAGE SECTION.
       01  L-CHAR USAGE IS BINARY-LONG.
       PROCEDURE DIVISION USING BY VALUE L-CHAR.
           MOVE 0 TO RETURN-CODE.
           PERFORM VARYING I FROM 1 BY 1 UNTIL I > LENGTH OF WS-CMP
               IF L-CHAR IS = WS-CMP(I:1) THEN
                   MOVE 1 TO RETURN-CODE
                   GOBACK
               END-IF
           END-PERFORM.
           GOBACK.
       END PROGRAM isupper.
      *-----------------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. isdigit.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  I PIC 9(4) COMP.
       01  WS-CMP PIC X(10) VALUE "1234567890".
       LINKAGE SECTION.
       01  L-CHAR USAGE IS BINARY-LONG.
       PROCEDURE DIVISION USING BY VALUE L-CHAR.
           MOVE 0 TO RETURN-CODE.
           PERFORM VARYING I FROM 1 BY 1 UNTIL I > LENGTH OF WS-CMP
               IF L-CHAR IS = WS-CMP(I:1) THEN
                   MOVE 1 TO RETURN-CODE
                   GOBACK
               END-IF
           END-PERFORM.
           GOBACK.
       END PROGRAM isdigit.
      *-----------------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. isalpha.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  I PIC 9(4) COMP.
       01  WS-CMP1 PIC X(27) VALUE "QWERTYUIOPASDFGHJKLZXCVBNM".
       01  WS-CMP2 PIC X(27) VALUE "qwertyuiopasdfghjklzxcvbnm".
       LINKAGE SECTION.
       01  L-CHAR USAGE IS BINARY-LONG.
       PROCEDURE DIVISION USING BY VALUE L-CHAR.
           MOVE 0 TO RETURN-CODE.
           PERFORM VARYING I FROM 1 BY 1 UNTIL I > LENGTH OF WS-CMP1
               IF L-CHAR IS = WS-CMP1(I:1) THEN
                   MOVE 1 TO RETURN-CODE
                   GOBACK
               END-IF
               IF L-CHAR IS = WS-CMP2(I:1) THEN
                   MOVE 1 TO RETURN-CODE
                   GOBACK
               END-IF
           END-PERFORM.
           GOBACK.
       END PROGRAM isalpha.
      *-----------------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. isalnum.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  I PIC 9(4) COMP.
       01  WS-CMP1 PIC X(27) VALUE "QWERTYUIOPASDFGHJKLZXCVBNM".
       01  WS-CMP2 PIC X(27) VALUE "qwertyuiopasdfghjklzxcvbnm".
       01  WS-CMP3 PIC X(10) VALUE "1234567890".
       LINKAGE SECTION.
       01  L-CHAR USAGE IS BINARY-LONG.
       PROCEDURE DIVISION USING BY VALUE L-CHAR.
           MOVE 0 TO RETURN-CODE.
           PERFORM VARYING I FROM 1 BY 1 UNTIL I > LENGTH OF WS-CMP1
               IF L-CHAR IS = WS-CMP1(I:1) THEN
                   MOVE 1 TO RETURN-CODE
                   GOBACK
               END-IF
               IF L-CHAR IS = WS-CMP2(I:1) THEN
                   MOVE 1 TO RETURN-CODE
                   GOBACK
               END-IF
           END-PERFORM.
           PERFORM VARYING I FROM 1 BY 1 UNTIL I > LENGTH OF WS-CMP3
               IF L-CHAR IS = WS-CMP3(I:1) THEN
                   MOVE 1 TO RETURN-CODE
                   GOBACK
               END-IF
           END-PERFORM.
           GOBACK.
       END PROGRAM isalnum.
      *-----------------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. isspace.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  I PIC 9(4) COMP.
       01  WS-CMP PIC X(1) VALUE " ".
       LINKAGE SECTION.
       01  L-CHAR USAGE IS BINARY-LONG.
       PROCEDURE DIVISION USING BY VALUE L-CHAR.
           MOVE 0 TO RETURN-CODE.
           PERFORM VARYING I FROM 1 BY 1 UNTIL I > LENGTH OF WS-CMP
               IF L-CHAR IS = WS-CMP(I:1) THEN
                   MOVE 1 TO RETURN-CODE
                   GOBACK
               END-IF
           END-PERFORM.
           GOBACK.
       END PROGRAM isspace.
      *-----------------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. ispunct.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  I PIC 9(4) COMP.
       01  WS-CMP PIC X(4) VALUE ".,;:".
       LINKAGE SECTION.
       01  L-CHAR USAGE IS BINARY-LONG.
       PROCEDURE DIVISION USING BY VALUE L-CHAR.
           MOVE 0 TO RETURN-CODE.
           PERFORM VARYING I FROM 1 BY 1 UNTIL I > LENGTH OF WS-CMP
               IF L-CHAR IS = WS-CMP(I:1) THEN
                   MOVE 1 TO RETURN-CODE
                   GOBACK
               END-IF
           END-PERFORM.
           GOBACK.
       END PROGRAM ispunct.
      *-----------------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. isxdigit.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  I PIC 9(4) COMP.
       01  WS-CMP PIC X(24) VALUE "1234567890abcdefABCDEF".
       LINKAGE SECTION.
       01  L-CHAR USAGE IS BINARY-LONG.
       PROCEDURE DIVISION USING BY VALUE L-CHAR.
           MOVE 0 TO RETURN-CODE.
           PERFORM VARYING I FROM 1 BY 1 UNTIL I > LENGTH OF WS-CMP
               IF L-CHAR IS = WS-CMP(I:1) THEN
                   MOVE 1 TO RETURN-CODE
                   GOBACK
               END-IF
           END-PERFORM.
           GOBACK.
       END PROGRAM isxdigit.
      *-----------------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. isprint.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  I PIC 9(4) COMP.
       01  WS-CMP1 PIC X(27) VALUE "qwertyuiopadfghjklzxcvbnm".
       01  WS-CMP2 PIC X(27) VALUE "QWERTYUIOPADFGHJKLZXCVBNM".
       01  WS-CMP3 PIC X(27) VALUE "123456890[]<>;{}()!@#$%^&*_+=.,;".
       LINKAGE SECTION.
       01  L-CHAR USAGE IS BINARY-LONG.
       PROCEDURE DIVISION USING BY VALUE L-CHAR.
           MOVE 0 TO RETURN-CODE.
           PERFORM VARYING I FROM 1 BY 1 UNTIL I > LENGTH OF WS-CMP1
               IF L-CHAR IS = WS-CMP1(I:1) THEN
                   MOVE 1 TO RETURN-CODE
                   GOBACK
               END-IF
               IF L-CHAR IS = WS-CMP2(I:1) THEN
                   MOVE 1 TO RETURN-CODE
                   GOBACK
               END-IF
           END-PERFORM.
           PERFORM VARYING I FROM 1 BY 1 UNTIL I > LENGTH OF WS-CMP3
               IF L-CHAR IS = WS-CMP3(I:1) THEN
                   MOVE 1 TO RETURN-CODE
                   GOBACK
               END-IF
           END-PERFORM.
           GOBACK.
       END PROGRAM isprint.
      *-----------------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. mkdir.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       LINKAGE SECTION.
       01  L-NAME PIC X(20).
       01  L-MODE USAGE IS BINARY-LONG.
       PROCEDURE DIVISION USING BY REFERENCE L-NAME, BY VALUE L-MODE.
           MOVE -1 TO RETURN-CODE.
           GOBACK.
       END PROGRAM mkdir.
      *-----------------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. access.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       LINKAGE SECTION.
       01  L-NAME PIC X(20).
       01  L-MODE USAGE IS BINARY-LONG.
       PROCEDURE DIVISION USING BY REFERENCE L-NAME, BY VALUE L-MODE.
           MOVE -1 TO RETURN-CODE.
           GOBACK.
       END PROGRAM access.
      *-----------------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. abs.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       LINKAGE SECTION.
       01  L-NUMBER USAGE IS BINARY-LONG.
       PROCEDURE DIVISION USING BY VALUE L-NUMBER.
           IF L-NUMBER < 0 THEN
               COMPUTE RETURN-CODE = 0 - L-NUMBER END-COMPUTE
               GOBACK
           END-IF.
           MOVE L-NUMBER TO RETURN-CODE.
           GOBACK.
       END PROGRAM abs.
      *-----------------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. chdir.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       LINKAGE SECTION.
       01  L-NAME PIC X(20).
       PROCEDURE DIVISION USING BY REFERENCE L-NAME.
           MOVE -1 TO RETURN-CODE.
           GOBACK.
       END PROGRAM chdir.
      *-----------------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. rename.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       LINKAGE SECTION.
       01  L-OLD-NAME PIC X(20).
       01  L-NEW-NAME PIC X(20).
       PROCEDURE DIVISION USING BY REFERENCE L-OLD-NAME,
           BY REFERENCE L-NEW-NAME.
           MOVE -1 TO RETURN-CODE.
           GOBACK.
       END PROGRAM rename.
      *-----------------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. close.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       LINKAGE SECTION.
       01  L-FD USAGE IS BINARY-LONG.
       PROCEDURE DIVISION USING BY VALUE L-FD.
           MOVE -1 TO RETURN-CODE.
           GOBACK.
       END PROGRAM close.
      *-----------------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. system.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       LINKAGE SECTION.
       01  L-COMMAND PIC X(20).
       PROCEDURE DIVISION USING BY REFERENCE L-COMMAND.
           MOVE -1 TO RETURN-CODE.
           GOBACK.
       END PROGRAM system.
      *-----------------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. sleep.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       LINKAGE SECTION.
       01  L-MICROSECS USAGE IS BINARY-LONG.
       PROCEDURE DIVISION USING BY VALUE L-MICROSECS.
           MOVE -1 TO RETURN-CODE.
           GOBACK.
       END PROGRAM sleep.
      *-----------------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. putenv.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       LINKAGE SECTION.
       01  L-ENVVAR PIC X(20).
       PROCEDURE DIVISION USING BY REFERENCE L-ENVVAR.
           MOVE -1 TO RETURN-CODE.
           GOBACK.
       END PROGRAM putenv.
      *-----------------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. fsync.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       LINKAGE SECTION.
       01  L-FD USAGE IS BINARY-LONG.
       PROCEDURE DIVISION USING BY VALUE L-FD.
           MOVE -1 TO RETURN-CODE.
           GOBACK.
       END PROGRAM fsync.
      *-----------------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. unlink.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       LINKAGE SECTION.
       01  L-FILENAME PIC X(20).
       PROCEDURE DIVISION USING BY REFERENCE L-FILENAME.
           MOVE -1 TO RETURN-CODE.
           GOBACK.
       END PROGRAM unlink.
      *-----------------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. rmdir.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       LINKAGE SECTION.
       01  L-FILENAME PIC X(20).
       PROCEDURE DIVISION USING BY REFERENCE L-FILENAME.
           MOVE -1 TO RETURN-CODE.
           GOBACK.
       END PROGRAM rmdir.
      *-----------------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. getenv.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       LINKAGE SECTION.
       01  L-ENVVAR PIC X(20).
       PROCEDURE DIVISION USING BY REFERENCE L-ENVVAR.
           MOVE -1 TO RETURN-CODE.
           GOBACK.
       END PROGRAM getenv.
      *-----------------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. ftruncate.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       LINKAGE SECTION.
       01  L-FD USAGE IS BINARY-LONG.
       01  L-OFFSET USAGE IS BINARY-LONG.
       PROCEDURE DIVISION USING BY VALUE L-FD, BY VALUE L-OFFSET.
           MOVE -1 TO RETURN-CODE.
           GOBACK.
       END PROGRAM ftruncate.
      *-----------------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. getchar.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       LINKAGE SECTION.
       PROCEDURE DIVISION.
           MOVE -1 TO RETURN-CODE.
           GOBACK.
       END PROGRAM getchar.
      *-----------------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. rand.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       LINKAGE SECTION.
       PROCEDURE DIVISION.
           MOVE 0 TO RETURN-CODE.
           GOBACK.
       END PROGRAM rand.
