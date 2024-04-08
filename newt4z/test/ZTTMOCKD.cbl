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
      * This test example shows how to set up a Db2 test with the test *
      * case providing the data.                                       *
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. 'ZTTMOCKD' RECURSIVE.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
      ******************************************************************
      * Copy in our required control blocks from Test4z.               *
      ******************************************************************
       COPY ZTESTWS.

      ******************************************************************
      * Define any working-storage items that we need.                 *
      ******************************************************************
       1 DB2_Data.
         COPY ZDB2.
       1 DB2_Function USAGE FUNCTION-POINTER.

      ******************************************************************
      * Define the rowset block. This could be an array of contiguous  *
      * rowsets if needed, but for this sample program we are          *
      * providing 1.                                                   *
      ******************************************************************
       1 MY_ROWSET_OBJECTS.
         2 MY_ROWSET_OBJECT OCCURS 1.
           COPY ZROWSET.

       1 MY_key PIC X(20) VALUE 'Pedro Gonzales'.

       1 MY_ROWS.
         2 MY_ROW1.
           3 PIC X(20) VALUE 'Pedro Gonzales'.
           3 PIC X(20) VALUE '1234 Main Street'.
         2 MY_ROW2.
           3 PIC X(20) VALUE 'Pedro Gonzales'.
           3 PIC X(20) VALUE '5678 Second Street'.

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
           set testFunction in ZWS_Test to entry 'mytestDb2'
           move 'Db2 provided data test' to testName in ZWS_Test
           call ZTESTUT using ZWS_Test

      ******************************************************************
      * Once all of the tests have been registered, return back to     *
      * Test4z to start processing.                                    *
      ******************************************************************
           goback.

      ******************************************************************
      *                                                                *
      *                                                                *
      * Provide the call back routine entry point for the Db2 test     *
      * with data provided by the test case.                           *
      *                                                                *
      *                                                                *
      ******************************************************************
           entry 'mytestDb2'.

      ******************************************************************
      * Create a Db2 rowset object to be used by the Db2 mocking       *
      * object.                                                        *
      ******************************************************************
           move low-values to I_Rowset
           move 1 to cursorId in ZWS_Rowset
           set keyAddress in ZWS_Rowset to address of MY_KEY
           move length of MY_KEY to key_size in ZWS_Rowset
           set rowAddress in ZWS_Rowset to address of MY_ROWS
           move 2 to rowset_size in ZWS_Rowset
           move 40 to row_size in ZWS_Rowset
           call ZTESTUT using ZWS_Rowset, MY_ROWSET_OBJECT (1)

      ******************************************************************
      * Create a Db2 object to be intercepted when being accessed by   *
      * program ZTDB2TE4.                                              *
      ******************************************************************
           move low-values to I_MockDB2
           move 'ZTDB2TE4' to moduleName in ZWS_MockDB2
           move 'ZTDB2TE4' to functionName in ZWS_MockDB2
           set ptr in dataAddress in ZWS_MockDB2 to
               address of MY_ROWSET_OBJECTS
           move 1 to siz in dataAddress in ZWS_MockDB2
           set cursorLogical in ZWS_MockDB2 to true
           call ZTESTUT using ZWS_MockDB2, db2Object in DB2_Data

      ******************************************************************
      * Load and prepare the user application program ZTDB2TE4 for use *
      ******************************************************************
           move low-values to I_PrepareModule
           move 'ZTDB2TE4' to moduleName in ZWS_PrepareModule
           call ZTESTUT using ZWS_PrepareModule

      ******************************************************************
      * Get the entry point of the ZTDB2TE4 routine in load module     *
      * ZTDB2TE4.                                                      *
      ******************************************************************
           move low-values to I_GetFunction
           move 'ZTDB2TE4' to moduleName in ZWS_GetFunction
           move 'ZTDB2TE4' to functionName in ZWS_GetFunction
           call ZTESTUT using ZWS_GetFunction, DB2_Function

      ******************************************************************
      * Start the ZTDB2TE4 function.                                   *
      * The passing of MY_key as an argument to the ZTDB2TE4 program   *
      * is only here because our example program uses it. This is not  *
      * typical for user programs.                                     *
      ******************************************************************
           call DB2_Function using MY_key

           goback.
