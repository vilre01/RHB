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
      * will mock a fixed-length KSDS file with the test case          *
      * providing the data. The second test will mock a                *
      * variable-length KSDS file with the test case providing the     *
      * data.                                                          *
      *                                                                *
      * In both of these tests, the data comes from the test case      *
      * itself.                                                        *
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. 'ZTTKSDSD' RECURSIVE.
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

       1 KSDS_FixedData.
         COPY ZKSDS.
         COPY ZSPKSDS.
         3 MY_Data.
           5 PIC X(250) VALUE '00000001This is record 1'.
           5 PIC X(250) VALUE '00000002This is record 2'.
           5 PIC X(250) VALUE '00000003This is record 3'.
           5 PIC X(250) VALUE '00000004This is record 4'.
           5 PIC X(250) VALUE '00000005This is record 5'.
           5 PIC X(250) VALUE '00000006This is record 6'.
           5 PIC X(250) VALUE '00000007This is record 7'.
           5 PIC X(250) VALUE '00000008This is record 8'.
           5 PIC X(250) VALUE '00000009This is record 9'.
           5 PIC X(250) VALUE '00000010This is record 10'.

       1 FILE_VariableData.
         COPY ZFILE.

       1 KSDS_VariableData.
         COPY ZKSDS.
         COPY ZSPKSDS.
         3 MY_Data.
           5 PIC 9(4) comp-5 VALUE 27.
           5 PIC X(27) VALUE '00000001This is record 1  a'.
           5 PIC 9(4) comp-5 VALUE 28.
           5 PIC X(28) VALUE '00000002This is record 2  ab'.
           5 PIC 9(4) comp-5 VALUE 29.
           5 PIC X(29) VALUE '00000003This is record 3  abc'.
           5 PIC 9(4) comp-5 VALUE 30.
           5 PIC X(30) VALUE '00000004This is record 4  abcd'.
           5 PIC 9(4) comp-5 VALUE 31.
           5 PIC X(31) VALUE '00000005This is record 5  abcde'.
           5 PIC 9(4) comp-5 VALUE 32.
           5 PIC X(32) VALUE '00000006This is record 6  abcdef'.
           5 PIC 9(4) comp-5 VALUE 33.
           5 PIC X(33) VALUE '00000007This is record 7  abcdefg'.
           5 PIC 9(4) comp-5 VALUE 34.
           5 PIC X(34) VALUE '00000008This is record 8  abcdefgh'.
           5 PIC 9(4) comp-5 VALUE 35.
           5 PIC X(35) VALUE '00000009This is record 9  abcdefghi'.
           5 PIC 9(4) comp-5 VALUE 36.
           5 PIC X(36) VALUE '00000010This is record 10 abcdefghij'.

       1 KSDS_Function USAGE FUNCTION-POINTER.

       LINKAGE SECTION.
      ******************************************************************
      * Copy in our required control blocks from Test4z.               *
      ******************************************************************
       COPY ZTESTLS.

      ******************************************************************
      * Define any linkage section items that we need.                 *
      ******************************************************************
       1 MY_KSDS_SPY.
         COPY ZSPKSDS.

       1 MY_KSDSData PIC X(250).

       PROCEDURE DIVISION.
      ******************************************************************
      * Register a set of tests to be run.                             *
      ******************************************************************
           move low-values to I_Test
           set testFunction in ZWS_Test to entry 'mytestFixed'
           move 'Fixed KSDS test' to testName in ZWS_Test
           call ZTESTUT using ZWS_Test

           move low-values to I_Test
           set testFunction in ZWS_Test to entry 'mytestVariable'
           move 'Variable KSDS test' to testName in ZWS_Test
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
      * KSDS test with data provided by the test case.                 *
      *                                                                *
      *                                                                *
      ******************************************************************
           entry 'mytestFixed'.

      ******************************************************************
      * Create a base file object for KSDS file TESTKSDS with data     *
      * provided. The data for a fixed-length file is a set of records *
      * of the same length as the record size of the file.             *
      ******************************************************************
           move low-values to I_File
           set recordAddress in ZWS_File to
               address of MY_Data in KSDS_FixedData
           move 10 to recordCount in ZWS_File
           move 250 to recordSize in ZWS_File
           call ZTESTUT using ZWS_File, fileObject in FILE_FixedData

      ******************************************************************
      * Using the previous base object pointer, create a KSDS file     *
      * object to be intercepted when being accessed by program        *
      * ZTPKSDST.                                                      *
      ******************************************************************
           move low-values to I_MockKSDS
           move 'TESTKSDS' to fileName in ZWS_MockKSDS
           set fileObject in ZWS_MockKSDS to
               address of fileObject in FILE_FixedData
           move 1 to keyOffset in ZWS_MockKSDS
           move 8 to keyLength in ZWS_MockKSDS
           call ZTESTUT using ZWS_MockKSDS,
                KSDSObject in KSDS_FixedData

      ******************************************************************
      * Spy on the KSDS file.                                          *
      ******************************************************************
           move low-values to I_SpyKSDS
           move 'TESTKSDS' to fileName in ZWS_SpyKSDS
           set sideEffect in ZWS_SpyKSDS to entry 'TESTKSDS_fixedAccess'
           call ZTESTUT using ZWS_SpyKSDS,
                ksdsSpyObject in KSDS_FixedData

      ******************************************************************
      * Load and prepare the user application program ZTPKSDST for     *
      * use. Get the function address and call the function. This can  *
      * be done all in 1 call to RunFunction or as individual calls    *
      * to PrepareModule, GetFunction and then call the function.      *
      ******************************************************************
           move low-values to I_RunFunction
           move 'ZTPKSDST' to moduleName in ZWS_RunFunction
           move 'ZTPKSDST' to functionName in ZWS_RunFunction
           call ZTESTUT using ZWS_RunFunction

           goback.

      ******************************************************************
      *                                                                *
      *                                                                *
      * Provide the side effect routine entry point for the KSDS       *
      * access.                                                        *
      *                                                                *
      *                                                                *
      ******************************************************************
           entry 'TESTKSDS_fixedAccess' using MY_KSDS_SPY.

      ******************************************************************
      * Map the linkage section to the address of the last record.     *
      ******************************************************************
           set address of ZLS_KSDS_Record to lastCall in MY_KSDS_SPY

      ******************************************************************
      * Display each written record when intercepted.                  *
      ******************************************************************
           if command in ZLS_KSDS_Record = 'WRITE' and
              statusCode1 in ZLS_KSDS_Record = '00'
              set address of MY_KSDSData to
                  ptr in record_ in ZLS_KSDS_Record
              display 'WRITE=' siz in record_ in ZLS_KSDS_Record  ' '
                     MY_KSDSData (1: siz in record_ in ZLS_KSDS_Record)
           end-if

      ******************************************************************
      * Display each read record when intercepted.                     *
      ******************************************************************
           if command in ZLS_KSDS_Record = 'READ' and
              statusCode1 in ZLS_KSDS_Record = '00'
              set address of MY_KSDSData to
                  ptr in record_ in ZLS_KSDS_Record
              display 'READ=' siz in record_ in ZLS_KSDS_Record  ' '
                     MY_KSDSData (1: siz in record_ in ZLS_KSDS_Record)
           end-if

           goback.

      ******************************************************************
      *                                                                *
      *                                                                *
      * Provide the call back routine entry point for the              *
      * variable-length KSDS test with data provided by the test case. *
      *                                                                *
      *                                                                *
      ******************************************************************
           entry 'mytestVariable'.

      ******************************************************************
      * Create a base file object for KSDS file TESTKSDS with data     *
      * provided. The data for a variable-length file is a set of      *
      * records with for each record a halfword (PIC 9(4) COMP-5)      *
      * length of the data that follows for that specific record.      *
      * A variable-length KSDS file object must have a minimum record  *
      * length specified that is greater than 0, otherwise the file    *
      * object is treated as fixed-length.                             *
      ******************************************************************
           move low-values to I_File
           set recordAddress in ZWS_File to
               address of MY_Data in KSDS_VariableData
           move 10 to recordCount in ZWS_File
           move 8 to recordMinimumSize in ZWS_File
           move 250 to recordSize in ZWS_File
           call ZTESTUT using ZWS_File, fileObject in FILE_VariableData

      ******************************************************************
      * Using the previous base object pointer, create a KSDS file     *
      * object to be intercepted when being accessed by program        *
      * ZTPKSDST.                                                      *
      ******************************************************************
           move low-values to I_MockKSDS
           move 'TESTKSDS' to fileName in ZWS_MockKSDS
           set fileObject in ZWS_MockKSDS to
               address of fileObject in FILE_VariableData
           move 1 to keyOffset in ZWS_MockKSDS
           move 8 to keyLength in ZWS_MockKSDS
           call ZTESTUT using ZWS_MockKSDS,
                KSDSObject in KSDS_VariableData

      ******************************************************************
      * Spy on the KSDS file.                                          *
      ******************************************************************
           move low-values to I_SpyKSDS
           move 'TESTKSDS' to fileName in ZWS_SpyKSDS
           set sideEffect in ZWS_SpyKSDS to
               entry 'TESTKSDS_variableAccess'
           call ZTESTUT using ZWS_SpyKSDS,
                ksdsSpyObject in KSDS_VariableData

      ******************************************************************
      * Load and prepare the user application program ZTPKSDST for use *
      ******************************************************************
           move low-values to I_PrepareModule
           move 'ZTPKSDST' to moduleName in ZWS_PrepareModule
           call ZTESTUT using ZWS_PrepareModule

      ******************************************************************
      * Get the entry point of the ZTPKSDST routine in load module     *
      * ZTPKSDST.                                                      *
      ******************************************************************
           move low-values to I_GetFunction
           move 'ZTPKSDST' to moduleName in ZWS_GetFunction
           move 'ZTPKSDST' to functionName in ZWS_GetFunction
           call ZTESTUT using ZWS_GetFunction, KSDS_Function

      ******************************************************************
      * Start the ZTPKSDST function and receive call backs in          *
      * TESTKSDS_variableAccess.                                       *
      ******************************************************************
           call KSDS_Function

           goback.

      ******************************************************************
      *                                                                *
      *                                                                *
      * Provide the side effect routine entry point for the KSDS       *
      * access.                                                        *
      *                                                                *
      *                                                                *
      ******************************************************************
           entry 'TESTKSDS_variableAccess' using MY_KSDS_SPY.

      ******************************************************************
      * Map the linkage section to the address of the last record.     *
      ******************************************************************
           set address of ZLS_KSDS_Record to lastCall in MY_KSDS_SPY

      ******************************************************************
      * Display each written record when intercepted.                  *
      ******************************************************************
           if command in ZLS_KSDS_Record = 'WRITE' and
              statusCode1 in ZLS_KSDS_Record = '00'
              set address of MY_KSDSData to
                  ptr in record_ in ZLS_KSDS_Record
              display 'WRITE=' siz in record_ in ZLS_KSDS_Record  ' '
                     MY_KSDSData (1: siz in record_ in ZLS_KSDS_Record)
           end-if

      ******************************************************************
      * Display each read record when intercepted.                     *
      ******************************************************************
           if command in ZLS_KSDS_Record = 'READ' and
              statusCode1 in ZLS_KSDS_Record = '00'
              set address of MY_KSDSData to
                  ptr in record_ in ZLS_KSDS_Record
              display 'READ=' siz in record_ in ZLS_KSDS_Record  ' '
                     MY_KSDSData (1: siz in record_ in ZLS_KSDS_Record)
           end-if

           goback.
