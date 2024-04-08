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
      * This test example shows how to run a unit test on a program    *
      * that calls another program that is to be stubbed out. Any      *
      * argument data is to be replaced using the previously recorded  *
      * data. This example uses the _RunFunction API to combine the    *
      * _PrepareModule and _GetFunction API calls along with the call  *
      * to start the function.                                         *
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. 'ZTTMOCKX' RECURSIVE.
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
       1 PGRM_Data.
         COPY ZPGRM.

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
           set testFunction in ZWS_Test to entry 'myMockTest'
           move 'Mocked subroutine test' to testName in ZWS_Test
           call ZTESTUT using ZWS_Test

      ******************************************************************
      * Once all of the tests have been registered, return back to     *
      * Test4z to start processing.                                    *
      ******************************************************************
           goback.

      ******************************************************************
      *                                                                *
      *                                                                *
      * Provide the call back routine entry point for the program      *
      * test. This test with execute a user program that calls another *
      * program. This called program is not to be executed but instead *
      * replaced by our previously recorded data. The argument         *
      * comparison will occur when the subprogram is about to be       *
      * called.                                                        *
      *                                                                *
      *                                                                *
      ******************************************************************
           entry 'myMockTest'.

      ******************************************************************
      * Create a loaded data object for a test program. The data comes *
      * from a previous recording and is stored in a partitioned       *
      * dataset member named 'ZTPPROGR'. This recorded data is in JSON *
      * format.                                                        *
      ******************************************************************
           move low-values to I_LoadData
           move 'ZTPPROGR' to memberName in ZWS_LoadData
           call ZTESTUT using ZWS_LoadData, loadObject in LOAD_Data

      ******************************************************************
      * Define that program ZTPCALLD is to be prevented from being     *
      * called in the original load module, but instead to be mocked   *
      * with recorded data.                                            *
      ******************************************************************
           move low-values to I_MockProgram
           move 'ZTPPROGR' to moduleName in ZWS_MockProgram
           move 'ZTPCALLD' to functionName in ZWS_MockProgram
           set loadObject in ZWS_MockProgram to loadObject in LOAD_Data
           call ZTESTUT using ZWS_MockProgram,
                programObject in PGRM_Data

      ******************************************************************
      * Load and prepare the user application program ZTPPROGR, then   *
      * start the subroutine ZTPPROGR directly in one API call.        *
      * Arguments can be passed to the subroutine by setting the       *
      * argumentList pointer, if needed. When program ZTPPROGR calls   *
      * ZTPCALLD, those calls will be mocked, the arguments compared   *
      * and the arguments replaced using recorded data.                *
      ******************************************************************
           move low-values to I_RunFunction
           move 'ZTPPROGR' to moduleName in ZWS_RunFunction
           move 'ZTPPROGR' to functionName in ZWS_RunFunction
           call ZTESTUT using ZWS_RunFunction

           goback.
