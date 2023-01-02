      ******************************************************************
      * KRNLHWIO - Hardware I/O program
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. KRNLHWIO.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-DEBUG PIC X VALUE 'Y'.
       01  WS-IO-PORT USAGE IS BINARY-SHORT UNSIGNED.
       01  WS-IO-DATA USAGE IS BINARY-LONG UNSIGNED.
       LINKAGE SECTION.
       COPY "krnlhwio.cpy" REPLACING ==:PREF:== BY L.
       PROCEDURE DIVISION.
           EVALUATE TRUE
               WHEN L-HWIO-MODE-IN PERFORM IO-IN
               WHEN L-HWIO-MODE-OUT PERFORM IO-OUT
           END-EVALUATE.
           GOBACK.
      *
       IO-OUT.
           EVALUATE TRUE
               WHEN L-HWIO-SIZE-8 PERFORM IO-OUT-8
               WHEN L-HWIO-SIZE-16 PERFORM IO-OUT-16
               WHEN L-HWIO-SIZE-32 PERFORM IO-OUT-32
      *        WHEN L-HWIO-SIZE-64 PERFORM IO-OUT-64
           END-EVALUATE.
       IO-OUT-8.
           CALL STATIC "IO_OUT"
           USING BY VALUE UNSIGNED SIZE IS 2 WS-IO-PORT
           BY VALUE UNSIGNED SIZE IS 4 WS-IO-DATA
           BY CONTENT 'C'
           END-CALL.
           PERFORM DEBUG-PRINT-OUT.
       IO-OUT-16.
           CALL STATIC "IO_OUT"
           USING BY VALUE UNSIGNED SIZE IS 2 WS-IO-PORT
           BY VALUE UNSIGNED SIZE IS 4 WS-IO-DATA
           BY CONTENT 'H'
           END-CALL.
           PERFORM DEBUG-PRINT-OUT.
       IO-OUT-32.
           CALL STATIC "IO_OUT"
           USING BY VALUE UNSIGNED SIZE IS 2 WS-IO-PORT
           BY VALUE UNSIGNED SIZE IS 4 WS-IO-DATA
           BY CONTENT 'S'
           END-CALL.
           PERFORM DEBUG-PRINT-OUT.
      *
       IO-IN.
           EVALUATE TRUE
               WHEN L-HWIO-SIZE-8 PERFORM IO-IN-8
               WHEN L-HWIO-SIZE-16 PERFORM IO-IN-16
               WHEN L-HWIO-SIZE-32 PERFORM IO-IN-32
      *        WHEN L-HWIO-SIZE-64 PERFORM IO-IN-64
           END-EVALUATE.
       IO-IN-8.
           CALL STATIC "IO_IN"
           USING BY VALUE UNSIGNED SIZE IS 2 WS-IO-PORT
           BY CONTENT 'C'
           BY REFERENCE WS-IO-DATA
           END-CALL.
           PERFORM DEBUG-PRINT-IN.
       IO-IN-16.
           CALL STATIC "IO_IN"
           USING BY VALUE UNSIGNED SIZE IS 2 WS-IO-PORT
           BY CONTENT 'S'
           BY REFERENCE WS-IO-DATA
           END-CALL.
           PERFORM DEBUG-PRINT-IN.
       IO-IN-32.
           CALL STATIC "IO_IN"
           USING BY VALUE UNSIGNED SIZE IS 2 WS-IO-PORT
           BY CONTENT 'H'
           BY REFERENCE WS-IO-DATA
           END-CALL.
           PERFORM DEBUG-PRINT-IN.
       DEBUG-PRINT-OUT.
           IF WS-DEBUG = 'Y'
               DISPLAY "OUT: " WS-IO-PORT " <- " WS-IO-DATA "; "
               NO ADVANCING END-DISPLAY
           END-IF.
       DEBUG-PRINT-IN.
           IF WS-DEBUG = 'Y'
               DISPLAY "IN: " WS-IO-PORT " -> " WS-IO-DATA "; "
               NO ADVANCING END-DISPLAY
           END-IF.
       END PROGRAM KRNLHWIO.
