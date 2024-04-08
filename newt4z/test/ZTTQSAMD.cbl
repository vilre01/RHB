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
      * This test example shows how to set up 2 tests. The first test  *
      * will mock a fixed-length QSAM file with the test case          *
      * providing the data. The second test will mock a                *
      * variable-length QSAM file with the test case providing the     *
      * data.                                                          *
      *                                                                *
      * In both of these tests, the data comes from the test case      *
      * itself.                                                        *
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. 'ZTTQSAMD' RECURSIVE.
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
         COPY ZSPQSAM.
         3 MY_Data.
           5 PIC X(80) VALUE 'This is record 1'.
           5 PIC X(80) VALUE 'This is record 2'.
           5 PIC X(80) VALUE 'This is record 3'.
           5 PIC X(80) VALUE 'This is record 4'.
           5 PIC X(80) VALUE 'This is record 5'.
           5 PIC X(80) VALUE 'This is record 6'.
           5 PIC X(80) VALUE 'This is record 7'.
           5 PIC X(80) VALUE 'This is record 8'.
           5 PIC X(80) VALUE 'This is record 9'.
           5 PIC X(80) VALUE 'This is record 10'.

       1 FILE_VariableData.
         COPY ZFILE.

       1 QSAM_VariableData.
         COPY ZQSAM.
         COPY ZSPQSAM.
         3 MY_Data.
           5 PIC 9(4) comp-5 VALUE 20.
           5 PIC X(20) VALUE 'This is record 1  ab'.
           5 PIC 9(4) comp-5 VALUE 22.
           5 PIC X(22) VALUE 'This is record 2  abcd'.
           5 PIC 9(4) comp-5 VALUE 24.
           5 PIC X(24) VALUE 'This is record 3  abcdef'.
           5 PIC 9(4) comp-5 VALUE 26.
           5 PIC X(26) VALUE 'This is record 4  abcdefgh'.
           5 PIC 9(4) comp-5 VALUE 28.
           5 PIC X(28) VALUE 'This is record 5  abcdefghij'.
           5 PIC 9(4) comp-5 VALUE 30.
           5 PIC X(30) VALUE 'This is record 6  abcdefghijkl'.
           5 PIC 9(4) comp-5 VALUE 32.
           5 PIC X(32) VALUE 'This is record 7  abcdefghijklmn'.
           5 PIC 9(4) comp-5 VALUE 34.
           5 PIC X(34) VALUE 'This is record 8  abcdefghijklmnop'.
           5 PIC 9(4) comp-5 VALUE 36.
           5 PIC X(36) VALUE 'This is record 9  abcdefghijklmnopqr'.
           5 PIC 9(4) comp-5 VALUE 38.
           5 PIC X(38) VALUE 'This is record 10 abcdefghijklmnopqrst'.

       1 QSAM_Function USAGE FUNCTION-POINTER.

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
           set testFunction in ZWS_Test to entry 'mytestFixed'
           move 'Fixed QSAM test' to testName in ZWS_Test
           call ZTESTUT using ZWS_Test

           move low-values to I_Test
           set testFunction in ZWS_Test to entry 'mytestVariable'
           move 'Variable QSAM test' to testName in ZWS_Test
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
           entry 'mytestFixed'.

      ******************************************************************
      * Create a base file object for QSAM file TESTQSAM with data     *
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
      * ZTPQSAMT.                                                      *
      ******************************************************************
           move low-values to I_MockQSAM
           move 'TESTQSAM' to fileName in ZWS_MockQSAM
           set fileObject in ZWS_MockQSAM to
               address of fileObject in FILE_FixedData
           call ZTESTUT using ZWS_MockQSAM,
                qsamObject in QSAM_FixedData

      ******************************************************************
      * Spy on the QSAM file.                                          *
      ******************************************************************
           move low-values to I_SpyQSAM
           move 'TESTQSAM' to fileName in ZWS_SpyQSAM
           set sideEffect in ZWS_SpyQSAM to
               entry 'TESTQSAM_fixedAccess'
           call ZTESTUT using ZWS_SpyQSAM,
                qsamSpyObject in QSAM_FixedData

      ******************************************************************
      * Load and prepare the user application program ZTPQSAMT for     *
      * use. Get the function address and call the function. This can  *
      * be done all in 1 call to RunFunction or as individual calls    *
      * to PrepareModule, GetFunction and then call the function.      *
      ******************************************************************
           move low-values to I_RunFunction
           move 'ZTPQSAMT' to moduleName in ZWS_RunFunction
           move 'ZTPQSAMT' to functionName in ZWS_RunFunction
           call ZTESTUT using ZWS_RunFunction

           goback.

      ******************************************************************
      *                                                                *
      *                                                                *
      * Provide the side effect routine entry point for the QSAM       *
      * access.                                                        *
      *                                                                *
      *                                                                *
      ******************************************************************
           entry 'TESTQSAM_fixedAccess' using MY_QSAM_SPY.

      ******************************************************************
      * Map the linkage section to the address of the last record.     *
      ******************************************************************
           set address of ZLS_QSAM_Record to lastCall in MY_QSAM_SPY

      ******************************************************************
      * Display each written record when intercepted.                  *
      ******************************************************************
           if command in ZLS_QSAM_Record = 'WRITE' and
              statusCode in ZLS_QSAM_Record = '00'
              set address of MY_QSAMData to
                  ptr in record_ in ZLS_QSAM_Record
              display 'WRITE=' siz in record_ in ZLS_QSAM_Record  ' '
                     MY_QSAMData (1: siz in record_ in ZLS_QSAM_Record)
           end-if

      ******************************************************************
      * Display each read record when intercepted.                     *
      ******************************************************************
           if command in ZLS_QSAM_Record = 'READ' and
              statusCode in ZLS_QSAM_Record = '00'
              set address of MY_QSAMData to
                  ptr in record_ in ZLS_QSAM_Record
              display 'READ=' siz in record_ in ZLS_QSAM_Record  ' '
                     MY_QSAMData (1: siz in record_ in ZLS_QSAM_Record)
           end-if

           goback.

      ******************************************************************
      *                                                                *
      *                                                                *
      * Provide the call back routine entry point for the              *
      * variable-length QSAM test with data provided by the test case. *
      *                                                                *
      *                                                                *
      ******************************************************************
           entry 'mytestVariable'.

      ******************************************************************
      * Create a base file object for QSAM file TESTQSAM with data     *
      * provided. The data for a variable-length file is a set of      *
      * records with for each record a halfword (PIC 9(4) COMP-5)      *
      * length of the data that follows for that specific record.      *
      * A variable-length QSAM file object must have a minimum record  *
      * length specified that is greater than 0, otherwise the file    *
      * object is treated as fixed-length.                             *
      ******************************************************************
           move low-values to I_File
           set recordAddress in ZWS_File to
               address of MY_Data in QSAM_VariableData
           move 10 to recordCount in ZWS_File
           move 1 to recordMinimumSize in ZWS_File
           move 80 to recordSize in ZWS_File
           call ZTESTUT using ZWS_File, fileObject in FILE_VariableData

      ******************************************************************
      * Using the previous base object pointer, create a QSAM file     *
      * object to be intercepted when being accessed by program        *
      * ZTPQSAMV.                                                      *
      ******************************************************************
           move low-values to I_MockQSAM
           move 'TESTQSAM' to fileName in ZWS_MockQSAM
           set fileObject in ZWS_MockQSAM to
               address of fileObject in FILE_VariableData
           call ZTESTUT using ZWS_MockQSAM,
                qsamObject in QSAM_VariableData

      ******************************************************************
      * Spy on the QSAM file.                                          *
      ******************************************************************
           move low-values to I_SpyQSAM
           move 'TESTQSAM' to fileName in ZWS_SpyQSAM
           set sideEffect in ZWS_SpyQSAM to
               entry 'TESTQSAM_variableAccess'
           call ZTESTUT using ZWS_SpyQSAM,
                qsamSpyObject in QSAM_VariableData

      ******************************************************************
      * Load and prepare the user application program ZTPQSAMV for use *
      ******************************************************************
           move low-values to I_PrepareModule
           move 'ZTPQSAMV' to moduleName in ZWS_PrepareModule
           call ZTESTUT using ZWS_PrepareModule

      ******************************************************************
      * Get the entry point of the ZTPQSAMV routine in load module     *
      * ZTPQSAMV.                                                      *
      ******************************************************************
           move low-values to I_GetFunction
           move 'ZTPQSAMV' to moduleName in ZWS_GetFunction
           move 'ZTPQSAMV' to functionName in ZWS_GetFunction
           call ZTESTUT using ZWS_GetFunction, QSAM_Function

      ******************************************************************
      * Start the ZTPQSAMV function and receive call backs in          *
      * TESTQSAM_variableAccess.                                       *
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
           entry 'TESTQSAM_variableAccess' using MY_QSAM_SPY.

      ******************************************************************
      * Map the linkage section to the address of the last record.     *
      ******************************************************************
           set address of ZLS_QSAM_Record to lastCall in MY_QSAM_SPY

      ******************************************************************
      * Display each written record when intercepted.                  *
      ******************************************************************
           if command in ZLS_QSAM_Record = 'WRITE' and
              statusCode in ZLS_QSAM_Record = '00'
              set address of MY_QSAMData to
                  ptr in record_ in ZLS_QSAM_Record
              display 'WRITE=' siz in record_ in ZLS_QSAM_Record  ' '
                     MY_QSAMData (1: siz in record_ in ZLS_QSAM_Record)
           end-if

      ******************************************************************
      * Display each read record when intercepted.                     *
      ******************************************************************
           if command in ZLS_QSAM_Record = 'READ' and
              statusCode in ZLS_QSAM_Record = '00'
              set address of MY_QSAMData to
                  ptr in record_ in ZLS_QSAM_Record
              display 'READ=' siz in record_ in ZLS_QSAM_Record  ' '
                     MY_QSAMData (1: siz in record_ in ZLS_QSAM_Record)
           end-if

           goback.
