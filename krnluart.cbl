      ******************************************************************
      * KRNLUART - UART driver for kernel
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. KRNLUART.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       COPY "krnlhwio.cpy" REPLACING ==:PREF:== BY WS.
       LINKAGE SECTION.
       PROCEDURE DIVISION.
      * Disable interrupts
           COMPUTE WS-HWIO-PORT = UART-PORT + 1 END-COMPUTE.
           MOVE H'00' TO WS-HWIO-DATA.
           SET WS-HWIO-SIZE-8 TO TRUE.
           SET WS-HWIO-MODE-OUT TO TRUE.
           CALL "KRNLHWIO" USING WS-HWIO END-CALL.
      * Enable DLAB
           COMPUTE WS-HWIO-PORT = UART-PORT + 3 END-COMPUTE.
           MOVE H'80' TO WS-HWIO-DATA.
           SET WS-HWIO-SIZE-8 TO TRUE.
           SET WS-HWIO-MODE-OUT TO TRUE.
           CALL "KRNLHWIO" USING WS-HWIO END-CALL.
      * Set divisor to 3
           COMPUTE WS-HWIO-PORT = UART-PORT + 0 END-COMPUTE.
           MOVE H'03' TO WS-HWIO-DATA.
           SET WS-HWIO-SIZE-8 TO TRUE.
           SET WS-HWIO-MODE-OUT TO TRUE.
           CALL "KRNLHWIO" USING WS-HWIO END-CALL.
           COMPUTE WS-HWIO-PORT = UART-PORT + 1 END-COMPUTE.
           MOVE H'00' TO WS-HWIO-DATA.
           SET WS-HWIO-SIZE-8 TO TRUE.
           SET WS-HWIO-MODE-OUT TO TRUE.
           CALL "KRNLHWIO" USING WS-HWIO END-CALL.
      * 8 bits and no parity with one stop bit
           COMPUTE WS-HWIO-PORT = UART-PORT + 3 END-COMPUTE.
           MOVE H'03' TO WS-HWIO-DATA.
           SET WS-HWIO-SIZE-8 TO TRUE.
           SET WS-HWIO-MODE-OUT TO TRUE.
           CALL "KRNLHWIO" USING WS-HWIO END-CALL.
      * Enable FIFO, clear and with a 14-byte threshold
           COMPUTE WS-HWIO-PORT = UART-PORT + 2 END-COMPUTE.
           MOVE H'C7' TO WS-HWIO-DATA.
           SET WS-HWIO-SIZE-8 TO TRUE.
           SET WS-HWIO-MODE-OUT TO TRUE.
           CALL "KRNLHWIO" USING WS-HWIO END-CALL.
      * Enable IRQs back, set RTS and DSR, the Data (???) Register
      * and the RTS register (no shit)
           COMPUTE WS-HWIO-PORT = UART-PORT + 4 END-COMPUTE.
           MOVE H'0B' TO WS-HWIO-DATA.
           SET WS-HWIO-SIZE-8 TO TRUE.
           SET WS-HWIO-MODE-OUT TO TRUE.
           CALL "KRNLHWIO" USING WS-HWIO END-CALL.
      * Set in loopback mode and test the serial chip in loopback
      * a good serial port should return (loop) what we send over
           MOVE H'1E' TO WS-HWIO-DATA.
           SET WS-HWIO-SIZE-8 TO TRUE.
           SET WS-HWIO-MODE-OUT TO TRUE.
           CALL "KRNLHWIO" USING WS-HWIO END-CALL.
           MOVE UART-PORT TO WS-HWIO-PORT.
           PERFORM UART-TEST.
      * Set on normal operation mode, that is a non-loopback mode with
      * IRQs enabeld and OUT#1 and OUT#2 bits enabled :)
           COMPUTE WS-HWIO-PORT = UART-PORT + 4 END-COMPUTE.
           MOVE H'0F' TO WS-HWIO-DATA.
           SET WS-HWIO-SIZE-8 TO TRUE.
           SET WS-HWIO-MODE-OUT TO TRUE.
           CALL "KRNLHWIO" USING WS-HWIO END-CALL.
           DISPLAY "UART initialized" END-DISPLAY.
      * Test the serial chip (sending a dummy byte and checking if it
      * returns the same byte)
           MOVE H'AE' TO WS-HWIO-DATA.
           SET WS-HWIO-SIZE-8 TO TRUE.
           SET WS-HWIO-MODE-OUT TO TRUE.
           CALL "KRNLHWIO" USING WS-HWIO END-CALL.
           IF WS-DEBUG IS = 'Y' THEN
               DISPLAY ">" WS-HWIO-DATA END-DISPLAY
           END-IF.
           SET WS-HWIO-SIZE-8 TO TRUE.
           SET WS-HWIO-MODE-IN TO TRUE.
           CALL "KRNLHWIO" USING WS-HWIO END-CALL.
           IF WS-DEBUG IS = 'Y' THEN
               DISPLAY ">" WS-HWIO-DATA END-DISPLAY
           END-IF.
           IF WS-HWIO-DATA NOT = H'AE' THEN
               DISPLAY "UART test failure" END-DISPLAY
           END-IF.
           GOBACK.
       END PROGRAM KRNLUART.
