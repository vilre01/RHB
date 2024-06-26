       IDENTIFICATION DIVISION.
       PROGRAM-ID. ZTPQHELO.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT INPUT-FILE ASSIGN SYSIN1
           FILE STATUS IS INPUT-STATUS.
           SELECT OUTPUT-FILE ASSIGN SYSOUT1.
       DATA DIVISION.
       FILE SECTION.
       FD  INPUT-FILE RECORD CONTAINS 80 CHARACTERS
           RECORDING MODE IS F.
       01  INPUT-RECORD PIC X(80).
       FD  OUTPUT-FILE RECORD CONTAINS 80 CHARACTERS
           RECORDING MODE IS F.
       01  OUTPUT-RECORD PIC X(80).
       WORKING-STORAGE SECTION.
       01  INPUT-STATUS PIC X(2).
       PROCEDURE DIVISION.
           OPEN INPUT INPUT-FILE
           OPEN OUTPUT OUTPUT-FILE
           READ INPUT-FILE
           PERFORM UNTIL INPUT-STATUS > '04'
               MOVE SPACES TO OUTPUT-RECORD
               STRING 'Hello, '
                   FUNCTION TRIM(INPUT-RECORD)
                   '!'
                   DELIMITED BY SIZE INTO OUTPUT-RECORD
               WRITE OUTPUT-RECORD
               READ INPUT-FILE
           END-PERFORM
           CLOSE INPUT-FILE
           CLOSE OUTPUT-FILE
           GOBACK.
