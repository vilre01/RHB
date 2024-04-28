       PROCESS PGMN(LM),NODYNAM
      ******************************************************************
      * The above process option is required for long entry point      *
      * names and locating the entry points. These options should not  *
      * be changed.                                                    *
      ******************************************************************
      ******************************************************************
      * For detailed information on all of the API calls, refer to the *
      * file README for general information and ZTESTWS1 for API       *
      * information.                                                   *
      ******************************************************************
      ******************************************************************
      * This test example shows how to set up a test. The first test   *
      * will mock a fixed-length QSAM file with the test case          *
      * providing the data. The data comes from the test case itself.  *
      * The test cases compares the output data of the program under   *
      * test with the expected output.                                 *
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. 'ZTTQSAMH' RECURSIVE.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
      ******************************************************************
      * Copy in our required control blocks from Test4z.               *
      ******************************************************************
       COPY ZTESTWS.

      ******************************************************************
      * Define any working-storage items that we need.                 *
      ******************************************************************
       1 FILE_FIXEDDATA.
         COPY ZFILE.

       1 QSAM_FIXEDDATA.
         COPY ZQSAM.
          3 MY_DATA.
             5                      PIC X(80) VALUE 'Azat'.
             5                      PIC X(80) VALUE 'Eleni'.
             5                      PIC X(80) VALUE 'Jeff'.
             5                      PIC X(80) VALUE 'Joe'.
             5                      PIC X(80) VALUE 'Meo'.
             5                      PIC X(80) VALUE 'Mike'.
             5                      PIC X(80) VALUE 'Petr P.'.
             5                      PIC X(80) VALUE 'Petr V.'.
             5                      PIC X(80) VALUE 'Swathi'.
             5                      PIC X(80) VALUE 'Tim'.

       1 FILE_OUTPUTDATA.
         COPY ZFILE.

       1 QSAM_OUTPUTDATA.
         COPY ZQSAM.
         COPY ZSPQSAM.
          3 MY_DATA.
             5                      PIC X(80).

       1 QSAM_FUNCTION USAGE FUNCTION-POINTER.


       1 EXPECTEDDATA.
          3                         PIC X(80) VALUE 'Yello, Azat!'.
          3                         PIC X(80) VALUE 'Hello, Eleni!'.
          3                         PIC X(80) VALUE 'Hello, Jeff!'.
          3                         PIC X(80) VALUE 'Hello, Joe!'.
          3                         PIC X(80) VALUE 'Hello, Meo!'.
          3                         PIC X(80) VALUE 'Hello, Mike!'.
          3                         PIC X(80) VALUE 'Hello, Petr P.!'.
          3                         PIC X(80) VALUE 'Hello, Petr V.!'.
          3                         PIC X(80) VALUE 'Hello, Swathi!'.
          3                         PIC X(80) VALUE 'Hello, Tim!'.
          3                         PIC X(80) VALUE 
                                                  '*** END OF FILE ***'.

       1 CURRENTEXPECTEDDATAINDEX   PIC S9(9) COMP-5
                                              VALUE 1.

       LINKAGE SECTION.
      ******************************************************************
      * Copy in our required control blocks from Test4z.               *
      ******************************************************************
       COPY ZTESTLS.

      ******************************************************************
      * Define any linkage section items that we need.                 *
      ******************************************************************
       1 MY_QSAM_SPY.
         COPY ZSPQSAM.

       1 MY_QSAMDATA                PIC X(80).

       PROCEDURE DIVISION.
      ******************************************************************
      * Register a set of tests to be run.                             *
      ******************************************************************
           MOVE LOW-VALUES TO I_TEST
           SET TESTFUNCTION IN ZWS_TEST TO ENTRY 'helloWorldTest'
           MOVE 'Hello World QSAM test' TO TESTNAME IN ZWS_TEST
           CALL ZTESTUT USING ZWS_TEST

      ******************************************************************
      * Once all of the tests have been registered, return back to     *
      * Test4z to start processing.                                    *
      ******************************************************************
           GOBACK.

      ******************************************************************
      *                                                                *
      *                                                                *
      * Provide the call back routine entry point for the fixed-length *
      * QSAM test with data provided by the test case.                 *
      *                                                                *
      *                                                                *
      ******************************************************************
           ENTRY 'helloWorldTest'.

      ******************************************************************
      * Create a base file object for QSAM file SYSIN1 with data       *
      * provided. The data for a fixed-length file is a set of records *
      * of the same length as the record size of the file.             *
      ******************************************************************
           MOVE LOW-VALUES TO I_FILE
           SET RECORDADDRESS IN ZWS_FILE TO
              ADDRESS OF MY_DATA IN QSAM_FIXEDDATA
           MOVE 10 TO RECORDCOUNT IN ZWS_FILE
           MOVE 80 TO RECORDSIZE IN ZWS_FILE
           CALL ZTESTUT USING ZWS_FILE, FILEOBJECT IN FILE_FIXEDDATA

      ******************************************************************
      * Using the previous base object pointer, create a QSAM file     *
      * object to be intercepted when being accessed by program        *
      * ZTPQHELO.                                                      *
      ******************************************************************
           MOVE LOW-VALUES TO I_MOCKQSAM
           MOVE 'SYSIN1' TO FILENAME IN ZWS_MOCKQSAM
           SET FILEOBJECT IN ZWS_MOCKQSAM TO
              ADDRESS OF FILEOBJECT IN FILE_FIXEDDATA
           CALL ZTESTUT USING ZWS_MOCKQSAM,
                              QSAMOBJECT IN QSAM_FIXEDDATA

      ******************************************************************
      * Create a base file object for QSAM file SYSOUT1.               *
      * The data for a fixed-length file is a set of records of the    *
      * same length as the record size of the file.                    *
      ******************************************************************
           MOVE LOW-VALUES TO I_FILE
           SET RECORDADDRESS IN ZWS_FILE TO
              ADDRESS OF MY_DATA IN QSAM_OUTPUTDATA
           MOVE 0 TO RECORDCOUNT IN ZWS_FILE
           MOVE 80 TO RECORDSIZE IN ZWS_FILE
           CALL ZTESTUT USING ZWS_FILE, FILEOBJECT IN FILE_OUTPUTDATA

      ******************************************************************
      * Using the previous base object pointer, create a QSAM file     *
      * object to be intercepted when being written to by program      *
      * ZTPQHELO.                                                      *
      ******************************************************************
           MOVE LOW-VALUES TO I_MOCKQSAM
           MOVE 'SYSOUT1' TO FILENAME IN ZWS_MOCKQSAM
           SET FILEOBJECT IN ZWS_MOCKQSAM TO
              ADDRESS OF FILEOBJECT IN FILE_OUTPUTDATA
           CALL ZTESTUT USING ZWS_MOCKQSAM,
                              QSAMOBJECT IN QSAM_OUTPUTDATA

      ******************************************************************
      * Spy on the QSAM output file.                                   *
      ******************************************************************
           MOVE LOW-VALUES TO I_SPYQSAM
           MOVE 'SYSOUT1' TO FILENAME IN ZWS_SPYQSAM
           SET SIDEEFFECT IN ZWS_SPYQSAM TO ENTRY 'TESTHELO_assert'
           CALL ZTESTUT USING ZWS_SPYQSAM,
                              QSAMSPYOBJECT IN QSAM_OUTPUTDATA

      ******************************************************************
      * Load and prepare the user application program ZTPQHELO for use *
      ******************************************************************
           MOVE LOW-VALUES TO I_PREPAREMODULE
           MOVE 'ZTPQHELO' TO MODULENAME IN ZWS_PREPAREMODULE
           CALL ZTESTUT USING ZWS_PREPAREMODULE

      ******************************************************************
      * Get the entry point of the ZTPQHELO routine in load module     *
      * ZTPQHELO.                                                      *
      ******************************************************************
           MOVE LOW-VALUES TO I_GETFUNCTION
           MOVE 'ZTPQHELO' TO MODULENAME IN ZWS_GETFUNCTION
           MOVE 'ZTPQHELO' TO FUNCTIONNAME IN ZWS_GETFUNCTION
           CALL ZTESTUT USING ZWS_GETFUNCTION, QSAM_FUNCTION

      ******************************************************************
      * Start the ZTPQHELO function and receive callbacks in           *
      * TESTHELO_assert.                                               *
      ******************************************************************
           CALL QSAM_FUNCTION

           GOBACK.

      ******************************************************************
      *                                                                *
      *                                                                *
      * Provide the side effect routine entry point for the QSAM       *
      * access.                                                        *
      *                                                                *
      *                                                                *
      ******************************************************************
           ENTRY 'TESTHELO_assert' USING MY_QSAM_SPY.

      ******************************************************************
      * Display the formatted last record.                             *
      ******************************************************************
           MOVE LOW-VALUES TO I_DISPLAYQSAM
           SET LASTCALL IN ZWS_DISPLAYQSAM TO LASTCALL IN MY_QSAM_SPY
           CALL ZTESTUT USING ZWS_DISPLAYQSAM

      ******************************************************************
      * Map the linkage section to the address of the last record.     *
      ******************************************************************
           SET ADDRESS OF ZLS_QSAM_RECORD TO LASTCALL IN MY_QSAM_SPY

      ******************************************************************
      * Check each written record when intercepted.                    *
      ******************************************************************
           IF COMMAND IN ZLS_QSAM_RECORD = 'WRITE' AND
              STATUSCODE IN ZLS_QSAM_RECORD = '00'
              SET ADDRESS OF MY_QSAMDATA TO
                 PTR IN RECORD_ IN ZLS_QSAM_RECORD
              DISPLAY 'Written: ('
                      SIZ IN RECORD_ IN ZLS_QSAM_RECORD
                      ') '
                      MY_QSAMDATA(1:SIZ IN RECORD_ IN ZLS_QSAM_RECORD)
              IF MY_QSAMDATA(1:SIZ IN RECORD_ IN ZLS_QSAM_RECORD) =
                 EXPECTEDDATA(CURRENTEXPECTEDDATAINDEX:
                 SIZ IN RECORD_ IN ZLS_QSAM_RECORD)
                 ADD SIZ IN RECORD_ IN ZLS_QSAM_RECORD TO
                    CURRENTEXPECTEDDATAINDEX
              ELSE
                 MOVE LOW-VALUES TO I_FAIL IN ZWS_FAIL
                 STRING 'Expected: '
                        EXPECTEDDATA(CURRENTEXPECTEDDATAINDEX:
                    SIZ IN RECORD_ IN ZLS_QSAM_RECORD)
                    DELIMITED BY SIZE INTO FAILMESSAGE IN ZWS_FAIL
                 CALL ZTESTUT USING ZWS_FAIL
              END-IF
           END-IF

           GOBACK.