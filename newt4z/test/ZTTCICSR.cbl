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
      * previously recorded data for a program using CICS with no      *
      * intercept spy.                                                 *
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. 'ZTTCICSR' RECURSIVE.
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

       1 CICS_Data.
         COPY ZCICS.

      ******************************************************************
      * Define the area that the CICS EIB and optional commarea will   *
      * use.                                                           *
      ******************************************************************
       COPY DFHEIBLK.
       1 COMMAREA PIC X(1).

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
           move 'Recorded CICS data test' to testName in ZWS_Test
           call ZTESTUT using ZWS_Test

      ******************************************************************
      * Once all of the tests have been registered, return back to     *
      * Test4z to start processing.                                    *
      ******************************************************************
           goback.

      ******************************************************************
      *                                                                *
      *                                                                *
      * Provide the call back routine entry point for the CICS loaded  *
      * data test with data provided by a previous recording in the    *
      * ZLDATA DD partitioned dataset with member CICSTEST.            *
      *                                                                *
      *                                                                *
      ******************************************************************
           entry 'myDataTest'.

      ******************************************************************
      * Create a loaded data object for a CICS test program. The data  *
      * comes from a previous recording and is stored in a partitioned *
      * dataset member named 'CICSTEST'. This recorded data is in JSON *
      * format.                                                        *
      ******************************************************************
           move low-values to I_LoadData
           move 'CICSTEST' to memberName in ZWS_LoadData
           call ZTESTUT using ZWS_LoadData, loadObject in LOAD_Data

      ******************************************************************
      * Create a CICS object to be intercepted when being accessed by  *
      * program CICSTEST.                                              *
      ******************************************************************
           move low-values to I_MockCICS
           move 'CICSTEST' to moduleName in ZWS_MockCICS
           set loadObject in ZWS_MockCICS to loadObject in LOAD_Data
           call ZTESTUT using ZWS_MockCICS, cicsObject in CICS_Data

      ******************************************************************
      * Load and prepare the user application program CICSTEST for use *
      ******************************************************************
           move low-values to I_PrepareModule
           move 'CICSTEST' to moduleName in ZWS_PrepareModule
           call ZTESTUT using ZWS_PrepareModule

      ******************************************************************
      * Get the entry point of the CICSTEST routine in load module     *
      * CICSTEST.                                                      *
      ******************************************************************
           move low-values to I_GetFunction
           move 'CICSTEST' to moduleName in ZWS_GetFunction
           move 'CICSTEST' to functionName in ZWS_GetFunction
           call ZTESTUT using ZWS_GetFunction, Program_Function

      ******************************************************************
      * Start the CICSTEST function. For CICS applications, we need to *
      * pass in the initial area for the CICS EIB and any commarea if  *
      * needed. This is manditory as the EIB is a required data area.  *
      ******************************************************************
           move low-values to EIBLK
           call Program_Function using EIBLK, COMMAREA

           goback.
