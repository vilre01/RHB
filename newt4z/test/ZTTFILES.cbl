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
      * will intercept QSAM file calls and then display the records.   *
      * The second test will intercept VSAM/KSDS file calls and then   *
      * display the records.                                           *
      *                                                                *
      * In both of these tests, the data comes from the original       *
      * dataset records. There is no data provided by the test case in *
      * this example. For data-provided examples, see ZTTKSDSD and     *
      * ZTTQSAMD.                                                      *
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. 'ZTTFILES' RECURSIVE.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
      ******************************************************************
      * Copy in our required control blocks from Test4z.               *
      ******************************************************************
       COPY ZTESTWS.

      ******************************************************************
      * Define any working-storage items that we need.                 *
      ******************************************************************
       1 QSAM_Data.
         COPY ZQSAM.
         COPY ZSPQSAM.
       1 QSAM_Function USAGE FUNCTION-POINTER.

       1 KSDS_Data.
         COPY ZKSDS.
         COPY ZSPKSDS.
       1 KSDS_Function USAGE FUNCTION-POINTER.

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
       1 MY_KSDS_SPY.
         COPY ZSPKSDS.

       1 MY_QSAMData PIC X(80).
       1 MY_KSDSData PIC X(250).

       PROCEDURE DIVISION.
      ******************************************************************
      * Register a set of tests to be run.                             *
      ******************************************************************
           move low-values to I_Test
           set testFunction in ZWS_Test to entry 'mytest1'
           move 'QSAM test' to testName in ZWS_Test
           call ZTESTUT using ZWS_Test

           move low-values to I_Test
           set testFunction in ZWS_Test to entry 'mytest2'
           move 'KSDS test' to testName in ZWS_Test
           call ZTESTUT using ZWS_Test

      ******************************************************************
      * Once all of the tests have been registered, return back to     *
      * Test4z to start processing.                                    *
      ******************************************************************
           goback.

      ******************************************************************
      *                                                                *
      *                                                                *
      * Provide the call back routine entry point for the QSAM test.   *
      *                                                                *
      *                                                                *
      ******************************************************************
           entry 'mytest1'.

      ******************************************************************
      * Create a QSAM file object to be intercepted when being         *
      * accessed by program ZTPQSAMP. As there is no data being        *
      * provided by this test case we do not set the address of any    *
      * file object. Instead we set the record size in the mocking     *
      * object.                                                        *
      ******************************************************************
           move low-values to I_MockQSAM
           move 'TESTQSAM' to fileName in ZWS_MockQSAM
           move 80 to recordSize in ZWS_MockQSAM
           call ZTESTUT using ZWS_MockQSAM, qsamObject in QSAM_Data

      ******************************************************************
      * Spy on the QSAM file.                                          *
      ******************************************************************
           move low-values to I_SpyQSAM
           move 'TESTQSAM' to fileName in ZWS_SpyQSAM
           set sideEffect in ZWS_SpyQSAM to entry 'TESTQSAM_access'
           call ZTESTUT using ZWS_SpyQSAM, qsamSpyObject in QSAM_Data

      ******************************************************************
      * Load and prepare the user application program ZTPQSAMP for use *
      ******************************************************************
           move low-values to I_PrepareModule
           move 'ZTPQSAMP' to moduleName in ZWS_PrepareModule
           call ZTESTUT using ZWS_PrepareModule

      ******************************************************************
      * Get the entry point of the ZTPQSAMP routine in load module     *
      * ZTPQSAMP.                                                      *
      ******************************************************************
           move low-values to I_GetFunction
           move 'ZTPQSAMP' to moduleName in ZWS_GetFunction
           move 'ZTPQSAMP' to functionName in ZWS_GetFunction
           call ZTESTUT using ZWS_GetFunction, QSAM_Function

      ******************************************************************
      * Start the ZTPQSAMP function and receive call backs in          *
      * TESTQSAM_access.                                               *
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
           entry 'TESTQSAM_access' using MY_QSAM_SPY.

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
      * Provide the call back routine entry point for the KSDS test.   *
      *                                                                *
      *                                                                *
      ******************************************************************
           entry 'mytest2'.

      ******************************************************************
      * Create a KSDS file object to be intercepted when being         *
      * accessed by program ZTPKSDSP. As there is no data being        *
      * provided by this test case we do not set the address of any    *
      * file object. Instead we set the record size in the mocking     *
      * object.                                                        *
      ******************************************************************
           move low-values to I_MockKSDS
           move 'TESTKSDS' to fileName in ZWS_MockKSDS
           move 1 to keyOffset in ZWS_MockKSDS
           move 8 to keyLength in ZWS_MockKSDS
           move 250 to recordSize in ZWS_MockKSDS
           call ZTESTUT using ZWS_MockKSDS, ksdsObject in KSDS_Data

      ******************************************************************
      * Spy on the KSDS file.                                          *
      ******************************************************************
           move low-values to I_SpyKSDS
           move 'TESTKSDS' to fileName in ZWS_SpyKSDS
           set sideEffect in ZWS_SpyKSDS to entry 'TESTKSDS_access'
           call ZTESTUT using ZWS_SpyKSDS, ksdsSpyObject in KSDS_Data

      ******************************************************************
      * Load and prepare the user application program ZTPKSDSP for use *
      ******************************************************************
           move low-values to I_PrepareModule
           move 'ZTPKSDSP' to moduleName in ZWS_PrepareModule
           call ZTESTUT using ZWS_PrepareModule

      ******************************************************************
      * Get the entry point of the ZTPKSDSP routine in load module     *
      * ZTPKSDSP.                                                      *
      ******************************************************************
           move low-values to I_GetFunction
           move 'ZTPKSDSP' to moduleName in ZWS_GetFunction
           move 'ZTPKSDSP' to functionName in ZWS_GetFunction
           call ZTESTUT using ZWS_GetFunction, KSDS_Function

      ******************************************************************
      * Start the ZTPKSDSP function and receive call backs in          *
      * TESTKSDS_access.                                               *
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
           entry 'TESTKSDS_access' using MY_KSDS_SPY.

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
