      ******************************************************************
      * KRNLCURS - Curses implementations and stubs
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. scrollok.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       LINKAGE SECTION.
       01  L-WINDOW USAGE POINTER.
       01  L-APOS USAGE BINARY-LONG.
       PROCEDURE DIVISION USING BY VALUE L-WINDOW, BY VALUE L-APOS.
           MOVE 0 TO RETURN-CODE.
           GOBACK.
       END PROGRAM scrollok.
      *-----------------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. keypad.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       LINKAGE SECTION.
       01  L-WINDOW USAGE POINTER.
       01  L-APOS USAGE BINARY-LONG.
       PROCEDURE DIVISION USING BY VALUE L-WINDOW, BY VALUE L-APOS.
           MOVE 0 TO RETURN-CODE.
           GOBACK.
       END PROGRAM keypad.
      *-----------------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. attron.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       LINKAGE SECTION.
       01  L-ATTR USAGE BINARY-LONG.
       PROCEDURE DIVISION USING BY VALUE L-ATTR.
           MOVE 0 TO RETURN-CODE.
           GOBACK.
       END PROGRAM attron.
      *-----------------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. bkgdset.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       LINKAGE SECTION.
       01  L-ATTR USAGE BINARY-LONG.
       PROCEDURE DIVISION USING BY VALUE L-ATTR.
           MOVE 0 TO RETURN-CODE.
           GOBACK.
       END PROGRAM bkgdset.
      *-----------------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. delwin.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       LINKAGE SECTION.
       01  L-WINDOW USAGE POINTER.
       PROCEDURE DIVISION USING BY VALUE L-WINDOW.
           MOVE 0 TO RETURN-CODE.
           GOBACK.
       END PROGRAM delwin.
      *-----------------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. cbreak.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       LINKAGE SECTION.
       PROCEDURE DIVISION.
           MOVE 0 TO RETURN-CODE.
           GOBACK.
       END PROGRAM cbreak.
      *-----------------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. nonl.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       LINKAGE SECTION.
       PROCEDURE DIVISION.
           MOVE 0 TO RETURN-CODE.
           GOBACK.
       END PROGRAM nonl.
      *-----------------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. noecho.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       LINKAGE SECTION.
       PROCEDURE DIVISION.
           MOVE 0 TO RETURN-CODE.
           GOBACK.
       END PROGRAM noecho.
      *-----------------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. endwin.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       LINKAGE SECTION.
       PROCEDURE DIVISION.
           MOVE 0 TO RETURN-CODE.
           GOBACK.
       END PROGRAM endwin.
      *-----------------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. flash.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       LINKAGE SECTION.
       PROCEDURE DIVISION.
           MOVE 0 TO RETURN-CODE.
           GOBACK.
       END PROGRAM flash.
      *-----------------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. beep.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       LINKAGE SECTION.
       PROCEDURE DIVISION.
           MOVE 0 TO RETURN-CODE.
           GOBACK.
       END PROGRAM beep.
      *-----------------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. has_colors.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       LINKAGE SECTION.
       PROCEDURE DIVISION.
           MOVE 1 TO RETURN-CODE.
           GOBACK.
       END PROGRAM has_colors.
      *-----------------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. start_color.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       LINKAGE SECTION.
       PROCEDURE DIVISION.
           MOVE 0 TO RETURN-CODE.
           GOBACK.
       END PROGRAM start_color.
      *-----------------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. refresh.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       LINKAGE SECTION.
       PROCEDURE DIVISION.
           MOVE 0 TO RETURN-CODE.
           GOBACK.
       END PROGRAM refresh.
      *-----------------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. def_prog_mode.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       LINKAGE SECTION.
       PROCEDURE DIVISION.
           MOVE 0 TO RETURN-CODE.
           GOBACK.
       END PROGRAM def_prog_mode.
      *-----------------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. reset_prog_mode.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       LINKAGE SECTION.
       PROCEDURE DIVISION.
           MOVE 0 TO RETURN-CODE.
           GOBACK.
       END PROGRAM reset_prog_mode.
      *-----------------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. curs_set.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       LINKAGE SECTION.
       01  L-CURSOR USAGE IS BINARY-LONG.
       PROCEDURE DIVISION USING BY VALUE L-CURSOR.
           MOVE 0 TO RETURN-CODE.
           GOBACK.
       END PROGRAM curs_set.
      *-----------------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. timeout.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       LINKAGE SECTION.
       01  L-TIMEOUT USAGE IS BINARY-LONG.
       PROCEDURE DIVISION USING BY VALUE L-TIMEOUT.
           MOVE 0 TO RETURN-CODE.
           GOBACK.
       END PROGRAM timeout.
      *-----------------------------------------------------------------
