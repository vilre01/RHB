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
       1 FILE_FixedData.
         COPY ZFILE.

       1 QSAM_FixedData.
         COPY ZQSAM.
         3 MY_Data.
           5 PIC X(80) VALUE 'Azat'.
           5 PIC X(80) VALUE 'Eleni'.
           5 PIC X(80) VALUE 'Jeff'.
           5 PIC X(80) VALUE 'Joe'.
           5 PIC X(80) VALUE 'Meo'.
           5 PIC X(80) VALUE 'Mike'.
           5 PIC X(80) VALUE 'Petr P.'.
           5 PIC X(80) VALUE 'Petr V.'.
           5 PIC X(80) VALUE 'Swathi'.
           5 PIC X(80) VALUE 'Tim'.

       1 FILE_OutputData.
         COPY ZFILE.

       1 QSAM_OutputData.
         COPY ZQSAM.
         COPY ZSPQSAM.
         3 MY_Data.
           5 PIC X(80).

       1 QSAM_Function USAGE FUNCTION-POINTER.


       1 ExpectedData.
         3 PIC X(80) VALUE 'Hello, Azat!'.
         3 PIC X(80) VALUE 'Hello, Eleni!'.
         3 PIC X(80) VALUE 'Hello, Jeff!'.
         3 PIC X(80) VALUE 'Hello, Joe!'.
         3 PIC X(80) VALUE 'Hello, Meo!'.
         3 PIC X(80) VALUE 'Hello, Mike!'.
         3 PIC X(80) VALUE 'Hello, Petr P.!'.
         3 PIC X(80) VALUE 'Hello, Petr V.!'.
         3 PIC X(80) VALUE 'Hello, Swathi!'.
         3 PIC X(80) VALUE 'Hello, Tim!'.
         3 PIC X(80) VALUE '*** END OF FILE ***'.

       1 CurrentExpectedDataIndex PIC S9(9) COMP-5 VALUE 1.

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

       1 MY_QSAMData PIC X(80).

       PROCEDURE DIVISION.
      ******************************************************************
      * Register a set of tests to be run.                             *
      ******************************************************************
           move low-values to I_Test
           set testFunction in ZWS_Test to entry 'helloWorldTest'
           move 'Hello World QSAM test' to testName in ZWS_Test
           call ZTESTUT using ZWS_Test

      ******************************************************************
      * Once all of the tests have been registered, return back to     *
      * Test4z to start processing.                                    *
      ******************************************************************
           goback.

      ******************************************************************
      *                                                                *
      *                                                                *
      * Provide the call back routine entry point for the fixed-length *
      * QSAM test with data provided by the test case.                 *
      *                                                                *
      *                                                                *
      ******************************************************************
           entry 'helloWorldTest'.

      ******************************************************************
      * Create a base file object for QSAM file SYSIN1 with data       *
      * provided. The data for a fixed-length file is a set of records *
      * of the same length as the record size of the file.             *
      ******************************************************************
           move low-values to I_File
           set recordAddress in ZWS_File to
               address of MY_Data in QSAM_FixedData
           move 10 to recordCount in ZWS_File
           move 80 to recordSize in ZWS_File
           call ZTESTUT using ZWS_File, fileObject in FILE_FixedData

      ******************************************************************
      * Using the previous base object pointer, create a QSAM file     *
      * object to be intercepted when being accessed by program        *
      * ZTPQHELO.                                                      *
      ******************************************************************
           move low-values to I_MockQSAM
           move 'SYSIN1' to fileName in ZWS_MockQSAM
           set fileObject in ZWS_MockQSAM to
               address of fileObject in FILE_FixedData
           call ZTESTUT using ZWS_MockQSAM,
                qsamObject in QSAM_FixedData

      ******************************************************************
      * Create a base file object for QSAM file SYSOUT1.               *
      * The data for a fixed-length file is a set of records of the    *
      * same length as the record size of the file.                    *
      ******************************************************************
           move low-values to I_File
           set recordAddress in ZWS_File to
             address of MY_Data in QSAM_OutputData
           move 0 to recordCount in ZWS_File
           move 80 to recordSize in ZWS_File
           call ZTESTUT using ZWS_File, fileObject in FILE_OutputData

      ******************************************************************
      * Using the previous base object pointer, create a QSAM file     *
      * object to be intercepted when being written to by program      *
      * ZTPQHELO.                                                      *
      ******************************************************************
           move low-values to I_MockQSAM
           move 'SYSOUT1' to fileName in ZWS_MockQSAM
           set fileObject in ZWS_MockQSAM to
             address of fileObject in FILE_OutputData
           call ZTESTUT using ZWS_MockQSAM,
             qsamObject in QSAM_OutputData

      ******************************************************************
      * Spy on the QSAM output file.                                   *
      ******************************************************************
           move low-values to I_SpyQSAM
           move 'SYSOUT1' to fileName in ZWS_SpyQSAM
           set sideEffect in ZWS_SpyQSAM to entry 'TESTHELO_assert'
           call ZTESTUT using ZWS_SpyQSAM,
                qsamSpyObject in QSAM_OutputData

      ******************************************************************
      * Load and prepare the user application program ZTPQHELO for use *
      ******************************************************************
           move low-values to I_PrepareModule
           move 'ZTPQHELO' to moduleName in ZWS_PrepareModule
           call ZTESTUT using ZWS_PrepareModule

      ******************************************************************
      * Get the entry point of the ZTPQHELO routine in load module     *
      * ZTPQHELO.                                                      *
      ******************************************************************
           move low-values to I_GetFunction
           move 'ZTPQHELO' to moduleName in ZWS_GetFunction
           move 'ZTPQHELO' to functionName in ZWS_GetFunction
           call ZTESTUT using ZWS_GetFunction, QSAM_Function

      ******************************************************************
      * Start the ZTPQHELO function and receive callbacks in           *
      * TESTHELO_assert.                                               *
      ******************************************************************
           call QSAM_Function

           goback.

      ******************************************************************
      *                                                                *
      *                                                                *
      * Provide the side effect routine entry point for the QSAM       *
      * access.                                                        *
      *                                                                *
      *                                                                *
      ******************************************************************
           entry 'TESTHELO_assert' using MY_QSAM_SPY.

      ******************************************************************
      * Display the formatted last record.                             *
      ******************************************************************
           move low-values to I_DisplayQSAM
           set lastCall in ZWS_DisplayQSAM to lastCall in MY_QSAM_SPY
           call ZTESTUT using ZWS_DisplayQSAM

      ******************************************************************
      * Map the linkage section to the address of the last record.     *
      ******************************************************************
           set address of ZLS_QSAM_Record to lastCall in MY_QSAM_SPY

      ******************************************************************
      * Check each written record when intercepted.                    *
      ******************************************************************
           if command in ZLS_QSAM_Record = 'WRITE' and
              statusCode in ZLS_QSAM_Record = '00'
              set address of MY_QSAMData to
                  ptr in record_ in ZLS_QSAM_Record
               display 'Written: ('
                   siz in record_ in ZLS_QSAM_Record ') '
                     MY_QSAMData (1: siz in record_ in ZLS_QSAM_Record)
               if MY_QSAMData (1: siz in record_ in ZLS_QSAM_Record) =
                 ExpectedData (CurrentExpectedDataIndex:
                    siz in record_ in ZLS_QSAM_Record)
                 add siz in record_ in ZLS_QSAM_Record to
                     CurrentExpectedDataIndex
               else
                 move low-values to I_Fail in ZWS_Fail
                 string 'Expected: '
                   ExpectedData (CurrentExpectedDataIndex:
                       siz in record_ in ZLS_QSAM_Record)
                   delimited by size into failMessage in ZWS_Fail
                 call ZTESTUT using ZWS_Fail
               end-if
           end-if

           goback.
