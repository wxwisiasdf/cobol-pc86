      ******************************************************************
      * KRNLPS2C - Kernel PS2 controller driver
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. KRNLPS2C.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-TMP PIC 9(8).
       01  PS2-DATA.
           02 PS2-NUM-DEVICES PIC 9(1).
           02 PS2-CONFIG PIC 9(8).
           02 PS2-DEVSEL PIC 9(1).
       COPY "krnlhwio.cpy" REPLACING ==:PREF:== BY WS.
       01  WS-BITAND.
           05 WS-BITAND-1 PIC 9(8).
           05 WS-BITAND-BY PIC 9(8).
           05 WS-BITAND-RES PIC 9(8).
       LINKAGE SECTION.
       PROCEDURE DIVISION.
           PERFORM PS2-INIT.
           PERFORM PS2-INIT-KEYBOARD.
           GOBACK.
       PS2-INIT.
      * Disable both devices
           MOVE H'AD' TO WS-HWIO-DATA.
           MOVE H'64' TO WS-HWIO-PORT.
           SET WS-HWIO-SIZE-8 TO TRUE.
           SET WS-HWIO-MODE-OUT TO TRUE.
           CALL "KRNLHWIO" USING WS-HWIO END-CALL.
           MOVE H'A7' TO WS-HWIO-DATA.
           MOVE H'64' TO WS-HWIO-PORT.
           SET WS-HWIO-SIZE-8 TO TRUE.
           SET WS-HWIO-MODE-OUT TO TRUE.
           CALL "KRNLHWIO" USING WS-HWIO END-CALL.
      * Flush buffers
           MOVE H'60' TO WS-HWIO-PORT.
           SET WS-HWIO-SIZE-8 TO TRUE.
           SET WS-HWIO-MODE-IN TO TRUE.
           CALL "KRNLHWIO" USING WS-HWIO END-CALL.
      * Read configuration and disable IRQs
           MOVE H'20' TO WS-HWIO-DATA.
           MOVE H'64' TO WS-HWIO-PORT.
           SET WS-HWIO-SIZE-8 TO TRUE.
           SET WS-HWIO-MODE-OUT TO TRUE.
           CALL "KRNLHWIO" USING WS-HWIO END-CALL.
           PERFORM PS2-WAIT-INPUT.
           MOVE H'60' TO WS-HWIO-PORT.
           SET WS-HWIO-SIZE-8 TO TRUE.
           SET WS-HWIO-MODE-IN TO TRUE.
           CALL "KRNLHWIO" USING WS-HWIO END-CALL.
           MOVE WS-HWIO-DATA TO PS2-CONFIG.
      * Clear bits 0, 1 and 6
           MOVE PS2-CONFIG TO WS-BITAND-1.
           MOVE 240 TO WS-BITAND-BY.
           CALL "SUBITAND" USING WS-BITAND END-CALL.
           MOVE WS-BITAND-RES TO PS2-CONFIG.
           MOVE 1 TO PS2-NUM-DEVICES.
      * Check if it's dual
           MOVE PS2-CONFIG TO WS-BITAND-1.
           MOVE H'20' TO WS-BITAND-BY.
           CALL "SUBITAND" USING WS-BITAND END-CALL.
           IF WS-BITAND-RES NOT = 0 THEN
               MOVE 2 TO PS2-NUM-DEVICES
           END-IF.
      * Write new configuration value
           MOVE H'60' TO WS-HWIO-DATA.
           MOVE H'64' TO WS-HWIO-PORT.
           SET WS-HWIO-SIZE-8 TO TRUE.
           SET WS-HWIO-MODE-OUT TO TRUE.
           CALL "KRNLHWIO" USING WS-HWIO END-CALL.
           MOVE H'60' TO WS-HWIO-PORT.
           MOVE PS2-CONFIG TO WS-HWIO-DATA.
           SET WS-HWIO-SIZE-8 TO TRUE.
           SET WS-HWIO-MODE-OUT TO TRUE.
           CALL "KRNLHWIO" USING WS-HWIO END-CALL.
      * Test PS2 controller
           MOVE H'AA' TO WS-HWIO-DATA.
           MOVE H'64' TO WS-HWIO-PORT.
           SET WS-HWIO-SIZE-8 TO TRUE.
           SET WS-HWIO-MODE-OUT TO TRUE.
           CALL "KRNLHWIO" USING WS-HWIO END-CALL.
           PERFORM PS2-WAIT-INPUT.
           MOVE H'60' TO WS-HWIO-PORT.
           SET WS-HWIO-SIZE-8 TO TRUE.
           SET WS-HWIO-MODE-IN TO TRUE.
           CALL "KRNLHWIO" USING WS-HWIO END-CALL.
           IF WS-HWIO-DATA NOT = H'55' THEN
               DISPLAY "Failed PS2 controller test " WS-HWIO-DATA
               END-DISPLAY
      *        GO TO PS2-INIT-END
           END-IF.
      * Reset configure byte to old value
      * NOTE: We're putting the same configure byte again as above :/
           MOVE H'60' TO WS-HWIO-DATA.
           MOVE H'64' TO WS-HWIO-PORT.
           SET WS-HWIO-SIZE-8 TO TRUE.
           SET WS-HWIO-MODE-OUT TO TRUE.
           CALL "KRNLHWIO" USING WS-HWIO END-CALL.
           MOVE H'60' TO WS-HWIO-PORT.
           MOVE PS2-CONFIG TO WS-HWIO-DATA.
           SET WS-HWIO-SIZE-8 TO TRUE.
           SET WS-HWIO-MODE-OUT TO TRUE.
           CALL "KRNLHWIO" USING WS-HWIO END-CALL.
           DISPLAY "Succeed PS2 controller test" END-DISPLAY.
           IF PS2-NUM-DEVICES = 2
      * Enable back the second channel device temporarily to check
      * for any errors
               MOVE H'64' TO WS-HWIO-PORT
               MOVE H'A8' TO WS-HWIO-DATA
               SET WS-HWIO-SIZE-8 TO TRUE
               SET WS-HWIO-MODE-OUT TO TRUE
               CALL "KRNLHWIO" USING WS-HWIO END-CALL
               MOVE H'64' TO WS-HWIO-PORT
               MOVE H'20' TO WS-HWIO-DATA
               SET WS-HWIO-SIZE-8 TO TRUE
               SET WS-HWIO-MODE-OUT TO TRUE
               CALL "KRNLHWIO" USING WS-HWIO END-CALL
               PERFORM PS2-WAIT-INPUT
      * Read back configuration status byte
               MOVE H'60' TO WS-HWIO-PORT
               SET WS-HWIO-SIZE-8 TO TRUE
               SET WS-HWIO-MODE-IN TO TRUE
               CALL "KRNLHWIO" USING WS-HWIO END-CALL
               MOVE WS-HWIO-DATA TO PS2-CONFIG
      * Bit 5 must be clear ^^
               MOVE PS2-CONFIG TO WS-BITAND-1
               MOVE H'20' TO WS-BITAND-BY
               CALL "SUBITAND" USING WS-BITAND END-CALL
               IF WS-BITAND-RES NOT = 0
                   MOVE 1 TO PS2-NUM-DEVICES
               END-IF
               IF PS2-NUM-DEVICES = 2
      * Disable the second channel device
                   MOVE H'64' TO WS-HWIO-PORT
                   MOVE H'A7' TO WS-HWIO-DATA
                   SET WS-HWIO-SIZE-8 TO TRUE
                   SET WS-HWIO-MODE-OUT TO TRUE
                   CALL "KRNLHWIO" USING WS-HWIO END-CALL
               END-IF
               DISPLAY PS2-NUM-DEVICES " PS2 devices" END-DISPLAY
           END-IF.
      * TODO: Save which port is working and which is not since
      * we can use either port in the case of a failure
           DISPLAY "Perform PS2 tests" END-DISPLAY.
           PERFORM PS2-WAIT-OUTPUT.
      * Perform a test on the first controller
           MOVE H'AB' TO WS-HWIO-DATA.
           MOVE H'64' TO WS-HWIO-PORT.
           SET WS-HWIO-SIZE-8 TO TRUE.
           SET WS-HWIO-MODE-OUT TO TRUE.
           CALL "KRNLHWIO" USING WS-HWIO END-CALL.
           MOVE H'60' TO WS-HWIO-PORT.
           SET WS-HWIO-SIZE-8 TO TRUE.
           SET WS-HWIO-MODE-IN TO TRUE.
           CALL "KRNLHWIO" USING WS-HWIO END-CALL.
           IF WS-HWIO-DATA NOT = 0
               DISPLAY "First port test failed" END-DISPLAY
      *        GO TO PS2-INIT-END
           END-IF.
           IF PS2-NUM-DEVICES = 2
               PERFORM PS2-WAIT-OUTPUT
      * Perform a test on the second port
               MOVE H'64' TO WS-HWIO-PORT
               MOVE H'A9' TO WS-HWIO-DATA
               SET WS-HWIO-SIZE-8 TO TRUE
               SET WS-HWIO-MODE-OUT TO TRUE
               CALL "KRNLHWIO" USING WS-HWIO END-CALL
               MOVE H'60' TO WS-HWIO-PORT
               SET WS-HWIO-SIZE-8 TO TRUE
               SET WS-HWIO-MODE-IN TO TRUE
               CALL "KRNLHWIO" USING WS-HWIO END-CALL
               IF WS-HWIO-DATA NOT = 0
                   MOVE 1 TO PS2-NUM-DEVICES
                   DISPLAY "Second port test failed" END-DISPLAY
               END-IF
           END-IF.
      * Enable the first PS2 port
           PERFORM PS2-WAIT-OUTPUT.
           MOVE H'64' TO WS-HWIO-PORT.
           MOVE H'AE' TO WS-HWIO-DATA.
           SET WS-HWIO-SIZE-8 TO TRUE.
           SET WS-HWIO-MODE-OUT TO TRUE.
           CALL "KRNLHWIO" USING WS-HWIO END-CALL.
           IF PS2-NUM-DEVICES = 2
      * Enable second PS2 port
               PERFORM PS2-WAIT-OUTPUT
               MOVE H'64' TO WS-HWIO-PORT
               MOVE H'A8' TO WS-HWIO-DATA
               SET WS-HWIO-SIZE-8 TO TRUE
               SET WS-HWIO-MODE-OUT TO TRUE
               CALL "KRNLHWIO" USING WS-HWIO END-CALL
           END-IF.
       PS2-INIT-END.
           DISPLAY "Finished PS2 initialize" END-DISPLAY.
      * Write to the first port
       PS2-WRITE-FIRST.
           MOVE WS-HWIO-DATA TO WS-TMP.
           PERFORM PS2-WAIT-INPUT.
           MOVE H'60' TO WS-HWIO-PORT.
           MOVE WS-TMP TO WS-HWIO-DATA.
           SET WS-HWIO-SIZE-8 TO TRUE.
           SET WS-HWIO-MODE-OUT TO TRUE.
           CALL "KRNLHWIO" USING WS-HWIO END-CALL.
      * Write to the second port
       PS2-WRITE-SECOND.
           MOVE WS-HWIO-DATA TO WS-TMP.
           PERFORM PS2-WAIT-INPUT.
           MOVE H'64' TO WS-HWIO-PORT.
           MOVE 212 TO WS-HWIO-DATA.
           SET WS-HWIO-SIZE-8 TO TRUE.
           SET WS-HWIO-MODE-OUT TO TRUE.
           CALL "KRNLHWIO" USING WS-HWIO END-CALL.
           PERFORM PS2-WAIT-INPUT.
           MOVE H'60' TO WS-HWIO-PORT.
           MOVE WS-TMP TO WS-HWIO-DATA.
           SET WS-HWIO-SIZE-8 TO TRUE.
           SET WS-HWIO-MODE-OUT TO TRUE.
           CALL "KRNLHWIO" USING WS-HWIO END-CALL.
       PS2-WAIT-INPUT.
           MOVE H'64' TO WS-HWIO-PORT.
           SET WS-HWIO-SIZE-8 TO TRUE.
           SET WS-HWIO-MODE-IN TO TRUE.
           CALL "KRNLHWIO" USING WS-HWIO END-CALL.
      * TODO: Wait for input
       PS2-WAIT-OUTPUT.
           MOVE H'64' TO WS-HWIO-PORT.
           SET WS-HWIO-SIZE-8 TO TRUE.
           SET WS-HWIO-MODE-IN TO TRUE.
           CALL "KRNLHWIO" USING WS-HWIO END-CALL.
      * TODO: Wait for output
       PS2-POLL-READ.
           PERFORM PS2-WAIT-OUTPUT.
           MOVE H'60' TO WS-HWIO-PORT.
           SET WS-HWIO-SIZE-8 TO TRUE.
           SET WS-HWIO-MODE-IN TO TRUE.
           CALL "KRNLHWIO" USING WS-HWIO END-CALL.
      * Initialize the keyboard make sure to set PS2-DEVSEL properly
      * before performing this paragraph
       PS2-INIT-KEYBOARD.
           MOVE H'FF' TO WS-HWIO-DATA.
           IF PS2-DEVSEL = 0
               PERFORM PS2-WRITE-FIRST
           ELSE
               PERFORM PS2-WRITE-SECOND
           END-IF.
           PERFORM PS2-POLL-READ.
      * Reset default parameters
           MOVE H'F6' TO WS-HWIO-DATA.
           IF PS2-DEVSEL = 0
               PERFORM PS2-WRITE-FIRST
           ELSE
               PERFORM PS2-WRITE-SECOND
           END-IF.
           PERFORM PS2-POLL-READ.
      * Set a 1000ms typematic delay
           MOVE H'F3' TO WS-HWIO-DATA.
           IF PS2-DEVSEL = 0
               PERFORM PS2-WRITE-FIRST
           ELSE
               PERFORM PS2-WRITE-SECOND
           END-IF.
           MOVE H'7F' TO WS-HWIO-DATA.
           IF PS2-DEVSEL = 0
               PERFORM PS2-WRITE-FIRST
           ELSE
               PERFORM PS2-WRITE-SECOND
           END-IF.
           PERFORM PS2-POLL-READ.
           IF WS-HWIO-DATA = H'FE'
               DISPLAY "Set keyboard typematic rate" END-DISPLAY
           END-IF.
      * Enable scanning
           MOVE H'F4' TO WS-HWIO-DATA.
           IF PS2-DEVSEL = 0
               PERFORM PS2-WRITE-FIRST
           ELSE
               PERFORM PS2-WRITE-SECOND
           END-IF.
           PERFORM PS2-POLL-READ.
           IF WS-HWIO-DATA = H'FE'
               DISPLAY "Enabled scanning" END-DISPLAY
           END-IF.
      * Enable IRQs
           DISPLAY "Enabling keyboard IRQs" END-DISPLAY.
           MOVE H'64' TO WS-HWIO-PORT.
           MOVE H'20' TO WS-HWIO-DATA.
           SET WS-HWIO-SIZE-8 TO TRUE.
           SET WS-HWIO-MODE-OUT TO TRUE.
           CALL "KRNLHWIO" USING WS-HWIO END-CALL.
           PERFORM PS2-WAIT-INPUT.
           MOVE H'60' TO WS-HWIO-PORT.
           SET WS-HWIO-SIZE-8 TO TRUE.
           SET WS-HWIO-MODE-IN TO TRUE.
           CALL "KRNLHWIO" USING WS-HWIO END-CALL.
           MOVE WS-HWIO-DATA TO PS2-CONFIG.
      * TODO: OR mask with bit 1
           MOVE H'64' TO WS-HWIO-PORT.
           MOVE H'60' TO WS-HWIO-DATA.
           SET WS-HWIO-SIZE-8 TO TRUE.
           SET WS-HWIO-MODE-OUT TO TRUE.
           CALL "KRNLHWIO" USING WS-HWIO END-CALL.
           PERFORM PS2-WAIT-OUTPUT.
           MOVE H'60' TO WS-HWIO-PORT.
           MOVE PS2-CONFIG TO WS-HWIO-DATA.
           SET WS-HWIO-SIZE-8 TO TRUE.
           SET WS-HWIO-MODE-OUT TO TRUE.
           CALL "KRNLHWIO" USING WS-HWIO END-CALL.
           PERFORM PS2-SET-SCANCODE.
           DISPLAY "Initialized PS2 keyboard" END-DISPLAY.
      * TODO: Have a PIC subsystem and tell it to enable IRQ 1
       PS2-SET-SCANCODE.
           MOVE H'F0' TO WS-HWIO-DATA.
           IF PS2-DEVSEL = 0
               PERFORM PS2-WRITE-FIRST
           ELSE
               PERFORM PS2-WRITE-SECOND
           END-IF.
           MOVE H'01' TO WS-HWIO-DATA.
           IF PS2-DEVSEL = 0
               PERFORM PS2-WRITE-FIRST
           ELSE
               PERFORM PS2-WRITE-SECOND
           END-IF.
       END PROGRAM KRNLPS2C.
