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
      * This test example shows how to run a unit test using           *
      * previously recorded data for a batch program using QSAM with   *
      * no intercept spy.                                              *
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. 'ZTTQSAMN' RECURSIVE.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
      ******************************************************************
      * Copy in our required control blocks from Test4z.               *
      ******************************************************************
       COPY ZTESTWS.

      ******************************************************************
      * Define any working-storage items that we need.                 *
      ******************************************************************
       1 LOAD_Data.
         COPY ZDATA.
       1 QSAM_Data.
         COPY ZQSAM.

       1 Program_Function USAGE FUNCTION-POINTER.

       LINKAGE SECTION.
      ******************************************************************
      * Copy in our required control blocks from Test4z.               *
      ******************************************************************
       COPY ZTESTLS.

      ******************************************************************
      * Define any linkage section items that we need.                 *
      ******************************************************************

       PROCEDURE DIVISION.
      ******************************************************************
      * Register a set of tests to be run.                             *
      ******************************************************************
           move low-values to I_Test
           set testFunction in ZWS_Test to entry 'myDataTest'
           move 'Recorded QSAM data test' to testName in ZWS_Test
           call ZTESTUT using ZWS_Test

      ******************************************************************
      * Once all of the tests have been registered, return back to     *
      * Test4z to start processing.                                    *
      ******************************************************************
           goback.

      ******************************************************************
      *                                                                *
      *                                                                *
      * Provide the call back routine entry point for the QSAM loaded  *
      * data test with data provided by a previous recording in the    *
      * ZLDATA DD partitioned dataset with member ZTPQSAMP.            *
      *                                                                *
      *                                                                *
      ******************************************************************
           entry 'myDataTest'.

      ******************************************************************
      * Create a loaded data object for a QSAM test program. The data  *
      * comes from a previous recording and is stored in a partitioned *
      * dataset member named 'ZTPQSAMP'. This recorded data is in JSON *
      * format.                                                        *
      ******************************************************************
           move low-values to I_LoadData
           move 'ZTPQSAMP' to memberName in ZWS_LoadData
           call ZTESTUT using ZWS_LoadData, loadObject in LOAD_Data

      ******************************************************************
      * Using the previous loaded data, create a QSAM file object to   *
      * be intercepted when being accessed by program ZTPQSAMP.        *
      ******************************************************************
           move low-values to I_MockQSAM
           move 'TESTQSAM' to fileName in ZWS_MockQSAM
           set loadObject in ZWS_MockQSAM to loadObject in LOAD_Data
           move 80 to recordSize in ZWS_MockQSAM
           call ZTESTUT using ZWS_MockQSAM, qsamObject in QSAM_Data

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
           call ZTESTUT using ZWS_GetFunction, Program_Function

      ******************************************************************
      * Start the ZTPQSAMP function                                    *
      ******************************************************************
           call Program_Function

           goback.
