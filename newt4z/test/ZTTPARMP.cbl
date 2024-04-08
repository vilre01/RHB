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
      * This test example shows how to get the user-defined parameter  *
      * located in the ZLOPTS file. These parameters can be defined    *
      * and used by the user in any way that is appropriate. One       *
      * suggestion might be to control the selection of tests to       *
      * register.                                                      *
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. 'ZTTPARMP' RECURSIVE.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
      ******************************************************************
      * Copy in our required control blocks from Test4z.               *
      ******************************************************************
       COPY ZTESTWS.

      ******************************************************************
      * Define any working-storage items that we need.                 *
      ******************************************************************
       1 MY_ParmData.
         COPY ZPARM.

       LINKAGE SECTION.
      ******************************************************************
      * Copy in our required control blocks from Test4z.               *
      ******************************************************************
       COPY ZTESTLS.

      ******************************************************************
      * Define any linkage section items that we need.                 *
      ******************************************************************
       1 MYPARMDATA PIC X(100).

       PROCEDURE DIVISION.
      ******************************************************************
      * Get the passed parameter data.                                 *
      ******************************************************************
           move low-values to I_GetParm in ZWS_GetParm
           call ZTESTUT using ZWS_GetParm, MY_ParmData
           set address of MYPARMDATA to ptr in MY_ParmData

      ******************************************************************
      * Register a set of tests to be run based on the passed parm     *
      * data.                                                          *
      ******************************************************************
           if siz in MY_ParmData > 2 and
              MYPARMDATA (1: 3) = 'RUN'
              move low-values to I_Test
              set testFunction in ZWS_Test to entry 'myNothingTest'
              move 'Passed parameter data test' to testName in ZWS_Test
              call ZTESTUT using ZWS_Test
           end-if

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
      * replaced by our stubbed program logic.                         *
      *                                                                *
      *                                                                *
      ******************************************************************
           entry 'myNothingTest'.

           goback.
