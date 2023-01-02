      ******************************************************************
      * KRNLLTDL - Kernel linker dynamic library stubs
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. lt_dlclose.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       LINKAGE SECTION.
       PROCEDURE DIVISION.
           MOVE 0 TO RETURN-CODE.
           GOBACK.
       END PROGRAM lt_dlclose.
      *-----------------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. lt_dlinit.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       LINKAGE SECTION.
       PROCEDURE DIVISION.
           MOVE 0 TO RETURN-CODE.
           GOBACK.
       END PROGRAM lt_dlinit.
      *-----------------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. lt_dlexit.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       LINKAGE SECTION.
       PROCEDURE DIVISION.
           MOVE 0 TO RETURN-CODE.
           GOBACK.
       END PROGRAM lt_dlexit.
      *-----------------------------------------------------------------
