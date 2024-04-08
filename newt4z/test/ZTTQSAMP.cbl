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
      * no intercept spy, but with a mismatch handler in the test case *
      * code.                                                          *
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. 'ZTTQSAMP' RECURSIVE.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
      ******************************************************************
      * Copy in our required control blocks from Test4z.               *
      ******************************************************************
       COPY ZTESTWS.

      ******************************************************************
      * Define any working-storage items that we need.                 *
      ******************************************************************
       1 LOAD_InData.
         COPY ZDATA.
       1 QSAM_InData.
         COPY ZQSAM.

       1 LOAD_OutData.
         COPY ZDATA.
       1 QSAM_OutData.
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
      * Provide the call back routine entry point for the QSAM loaded  *
      * data test with data provided by a previous recording in the    *
      * ZLDATA DD partitioned dataset with member ZTPQHELO. We provide *
      * our own mismatch handler for this test.                        *
      ******************************************************************
           entry 'myDataTest'.

      ******************************************************************
      * Create a loaded data object for a QSAM test program. The data  *
      * comes from a previous recording and is stored in a partitioned *
      * dataset member named 'ZTPQHELO'. This recorded data is in JSON *
      * format.                                                        *
      ******************************************************************
           move low-values to I_LoadData
           move 'ZTPQHELO' to memberName in ZWS_LoadData
           call ZTESTUT using ZWS_LoadData, loadObject in LOAD_InData

      ******************************************************************
      * Using the previous loaded data, create a QSAM file object to   *
      * be intercepted when SYSIN1 being accessed by program ZTPQHELO. *
      ******************************************************************
           move low-values to I_MockQSAM
           move 'SYSIN1' to fileName in ZWS_MockQSAM
           set loadObject in ZWS_MockQSAM to loadObject in LOAD_InData
           move 80 to recordSize in ZWS_MockQSAM
           call ZTESTUT using ZWS_MockQSAM, qsamObject in QSAM_InData
      ******************************************************************
      * Using the previous loaded data, create a QSAM file object to   *
      * be intercepted when SYSOUT1 being accessed by program ZTPQHELO.*
      ******************************************************************
           move low-values to I_MockQSAM
           move 'SYSOUT1' to fileName in ZWS_MockQSAM
           set loadObject in ZWS_MockQSAM to loadObject in LOAD_OutData
           move 80 to recordSize in ZWS_MockQSAM
           call ZTESTUT using ZWS_MockQSAM, qsamObject in QSAM_OutData
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
           call ZTESTUT using ZWS_GetFunction, Program_Function

      ******************************************************************
      * Register a mismatch handler to process any recorded data       *
      * mismatch.                                                      *
      ******************************************************************
           move low-values to I_RegisterMismatch
           set handler in ZWS_RegisterMismatch to
               entry 'my_mismatch'
           call ZTESTUT using ZWS_RegisterMismatch

      ******************************************************************
      * Start the ZTPQHELO function                                    *
      ******************************************************************
           call Program_Function

           goback.

      ******************************************************************
      * Provide the call back routine entry point for the mismatch     *
      * handling.                                                      *
      *                                                                *
      * There is a variety of information about the test, the program  *
      * and the call being performed in the 3 control blocks being     *
      * passed to this mismatch handler. Refer to the control blocks   *
      * for more information.                                          *
      ******************************************************************
           entry 'my_mismatch' using ZLS_goBlock, ZLS_itBlock,
                 ZLS_mmBlock.

           display 'Mismatch occurred in argument number '
                argumentNumber in ZLS_mmBlock
                ' at offset '
                mismatchOffset in ZLS_mmBlock
           move low-values to I_Fail in ZWS_Fail
           move 'Mismatch detected' to failMessage in ZWS_Fail
           call ZTESTUT using ZWS_Fail

           goback.
