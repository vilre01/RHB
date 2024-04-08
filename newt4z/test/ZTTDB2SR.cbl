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
      * previously recorded data for a program using Db2 with no       *
      * intercept spy.                                                 *
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. 'ZTTDB2SR' RECURSIVE.
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
       1 Program_Function USAGE FUNCTION-POINTER.

       1 DB2_Data.
         COPY ZDB2.

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
           move 'Recorded Db2 data test' to testName in ZWS_Test
           call ZTESTUT using ZWS_Test

      ******************************************************************
      * Once all of the tests have been registered, return back to     *
      * Test4z to start processing.                                    *
      ******************************************************************
           goback.

      ******************************************************************
      *                                                                *
      *                                                                *
      * Provide the call back routine entry point for the Db2 loaded   *
      * data test with data provided by a previous recording in the    *
      * ZLDATA DD partitioned dataset with member ZTDB2TE1.            *
      *                                                                *
      *                                                                *
      ******************************************************************
           entry 'myDataTest'.

      ******************************************************************
      * Create a loaded data object for a Db2 test program. The data   *
      * comes from a previous recording and is stored in a partitioned *
      * dataset member named 'ZTDB2TE1'. This recorded data is in JSON *
      * format.                                                        *
      ******************************************************************
           move low-values to I_LoadData
           move 'ZTDB2TE1' to memberName in ZWS_LoadData
           call ZTESTUT using ZWS_LoadData, loadObject in LOAD_Data

      ******************************************************************
      * Create a Db2 object to be intercepted when being accessed by   *
      * program ZTDB2TE1.                                              *
      ******************************************************************
           move low-values to I_MockDB2
           move 'ZTDB2TE1' to moduleName in ZWS_MockDB2
           set loadObject in ZWS_MockDB2 to loadObject in LOAD_Data
           call ZTESTUT using ZWS_MockDB2, db2Object in DB2_Data

      ******************************************************************
      * Load and prepare the user application program ZTDB2TE1 for use *
      ******************************************************************
           move low-values to I_PrepareModule
           move 'ZTDB2TE1' to moduleName in ZWS_PrepareModule
           call ZTESTUT using ZWS_PrepareModule

      ******************************************************************
      * Get the entry point of the ZTDB2TE1 routine in load module     *
      * ZTDB2TE1.                                                      *
      ******************************************************************
           move low-values to I_GetFunction
           move 'ZTDB2TE1' to moduleName in ZWS_GetFunction
           move 'ZTDB2TE1' to functionName in ZWS_GetFunction
           call ZTESTUT using ZWS_GetFunction, Program_Function

      ******************************************************************
      * Start the ZTDB2TE1 function.                                   *
      ******************************************************************
           call Program_Function

           goback.
