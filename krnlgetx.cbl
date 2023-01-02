      ******************************************************************
      * KRNLGETX - Gettext stubs
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. gettext.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       LINKAGE SECTION.
       01  L-STRING PIC X(80).
       01  L-OUTSTRING PIC X(80).
       PROCEDURE DIVISION USING BY REFERENCE L-STRING
           RETURNING L-OUTSTRING.
           MOVE 0 TO RETURN-CODE.
           GOBACK.
       END PROGRAM gettext.
      *-----------------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. gettext_noop.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       LINKAGE SECTION.
       01  L-STRING PIC X(80).
       01  L-OUTSTRING PIC X(80).
       PROCEDURE DIVISION USING BY REFERENCE L-STRING
           RETURNING L-OUTSTRING.
           MOVE 0 TO RETURN-CODE.
           GOBACK.
       END PROGRAM gettext_noop.
      *-----------------------------------------------------------------
