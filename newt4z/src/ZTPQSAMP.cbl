       IDENTIFICATION DIVISION.
       PROGRAM-ID. ZTPQSAMP.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT OUTPUT-FILE ASSIGN TESTQSAM
           FILE STATUS IS OUTPUT-STATUS.
       DATA DIVISION.
       FILE SECTION.
       FD  OUTPUT-FILE RECORD CONTAINS 80 CHARACTERS
           RECORDING MODE IS F
           DATA RECORD IS OUTPUT-RECORD.
       01  OUTPUT-RECORD PIC X(80).
       WORKING-STORAGE SECTION.
       01  OUTPUT-STATUS PIC X(2).
       01  MY-WORK-AREA PIC X(30) VALUE SPACES.
       PROCEDURE DIVISION.
           DISPLAY 'GOT TO ZTPQSAMP'
           IF MY-WORK-AREA = SPACES
              MOVE 'THIS IS MY-WORK-AREA' TO MY-WORK-AREA
           END-IF
           OPEN OUTPUT OUTPUT-FILE
           MOVE ALL 'A' TO OUTPUT-RECORD
           WRITE OUTPUT-RECORD
           MOVE ALL 'B' TO OUTPUT-RECORD
           WRITE OUTPUT-RECORD
           MOVE ALL 'C' TO OUTPUT-RECORD
           WRITE OUTPUT-RECORD
           MOVE ALL 'D' TO OUTPUT-RECORD
           WRITE OUTPUT-RECORD
           MOVE ALL 'E' TO OUTPUT-RECORD
           WRITE OUTPUT-RECORD
           MOVE ALL 'F' TO OUTPUT-RECORD
           WRITE OUTPUT-RECORD
           MOVE ALL 'G' TO OUTPUT-RECORD
           WRITE OUTPUT-RECORD
           MOVE ALL 'H' TO OUTPUT-RECORD
           WRITE OUTPUT-RECORD
           MOVE ALL 'I' TO OUTPUT-RECORD
           WRITE OUTPUT-RECORD
           MOVE ALL 'J' TO OUTPUT-RECORD
           WRITE OUTPUT-RECORD
           CLOSE OUTPUT-FILE
           OPEN INPUT OUTPUT-FILE
           READ OUTPUT-FILE
           DISPLAY OUTPUT-RECORD
           READ OUTPUT-FILE
           DISPLAY OUTPUT-RECORD
           READ OUTPUT-FILE
           DISPLAY OUTPUT-RECORD
           READ OUTPUT-FILE
           DISPLAY OUTPUT-RECORD
           READ OUTPUT-FILE
           DISPLAY OUTPUT-RECORD
           READ OUTPUT-FILE
           DISPLAY OUTPUT-RECORD
           READ OUTPUT-FILE
           DISPLAY OUTPUT-RECORD
           READ OUTPUT-FILE
           DISPLAY OUTPUT-RECORD
           READ OUTPUT-FILE
           DISPLAY OUTPUT-RECORD
           READ OUTPUT-FILE
           DISPLAY OUTPUT-RECORD
           READ OUTPUT-FILE
           DISPLAY OUTPUT-RECORD
           CLOSE OUTPUT-FILE
           GOBACK.
       END PROGRAM ZTPQSAMP.
