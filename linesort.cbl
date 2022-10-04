000100******************************************************************        
000200*                                                                         
000300* Prints a file with AREA A filled with resequenced line numbers          
000400*                                                                         
000500******************************************************************        
000600 IDENTIFICATION DIVISION.                                                 
000700 PROGRAM-ID. LINESORT.                                                    
000800 ENVIRONMENT DIVISION.                                                    
000900 INPUT-OUTPUT SECTION.                                                    
001000 FILE-CONTROL.                                                            
001100     SELECT FS-FILE ASSIGN TO DISK                                        
001200     ORGANIZATION IS LINE SEQUENTIAL                                      
001300     FILE STATUS IS WS-STATUS.                                            
001400 DATA DIVISION.                                                           
001500 FILE SECTION.                                                            
001600 FD  FS-FILE LABEL RECORDS ARE STANDARD                                   
001700     VALUE OF FILE-ID IS WS-FILENAME.                                     
001800 01  FS-REC.                                                              
001900     10 FS-LINE-NO       PIC 9(6).                                        
002000     10 FS-FILLER        PIC X(74).                                       
002100 WORKING-STORAGE SECTION.                                                 
002200 01  WS-FILENAME         PIC A(80) VALUE SPACES.                          
002300 01  WS-STATUS           PIC XX VALUE ZERO.                               
002400 01  WS-COUNT            PIC 9(6) VALUE ZERO.                             
002500 01  WS-EOF              PIC A VALUE 'N'.                                 
002600 PROCEDURE DIVISION.                                                      
002700     DISPLAY "File to sort?" END-DISPLAY.                                 
002800     ACCEPT WS-FILENAME.                                                  
002900     OPEN INPUT FS-FILE.                                                  
003000     PERFORM UNTIL WS-EOF = 'Y'                                           
003100        READ FS-FILE NEXT RECORD INTO FS-REC                              
003200            AT END MOVE 'Y' TO WS-EOF                                     
003300            NOT AT END PERFORM PRINT-OUT                                  
003400        END-READ                                                          
003500     END-PERFORM.                                                         
003600     CLOSE FS-FILE.                                                       
003700     STOP RUN.                                                            
003800 PRINT-OUT.                                                               
003900     ADD 100 TO WS-COUNT END-ADD.                                         
004000     MOVE WS-COUNT TO FS-LINE-NO.                                         
004100     DISPLAY FS-REC END-DISPLAY.