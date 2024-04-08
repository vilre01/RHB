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
      * This test example shows how to run a unit test on a section in *
      * the COBOL application program. This will isolate the section   *
      * from the rest of the user program and only execute it. It also *
      * shows how to get the address of user variables in user program *
      * and display them.                                              *
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. 'ZTTSECTN' RECURSIVE.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
      ******************************************************************
      * Copy in our required control blocks from Test4z.               *
      ******************************************************************
       COPY ZTESTWS.

      ******************************************************************
      * Define any working-storage items that we need.                 *
      ******************************************************************
       1 Program_Function USAGE FUNCTION-POINTER.
       1 Variable_Address USAGE POINTER.

       1 Section_Data.
         COPY ZSPSECT.

       LINKAGE SECTION.
      ******************************************************************
      * Copy in our required control blocks from Test4z.               *
      ******************************************************************
       COPY ZTESTLS.

      ******************************************************************
      * Define any linkage section items that we need.                 *
      ******************************************************************
       1 MY_WSAREA1 PIC X(20).

       PROCEDURE DIVISION.
      ******************************************************************
      * Register a set of tests to be run.                             *
      ******************************************************************
           move low-values to I_Test
           set testFunction in ZWS_Test to entry 'mySectionTest'
           move 'Section test' to testName in ZWS_Test
           call ZTESTUT using ZWS_Test

      ******************************************************************
      * Once all of the tests have been registered, return back to     *
      * Test4z to start processing.                                    *
      ******************************************************************
           goback.

      ******************************************************************
      *                                                                *
      *                                                                *
      * Provide the call back routine entry point for the section      *
      * test. This test with only execute a specific section in the    *
      * user COBOL program. It will get the address of user variables  *
      * and display them.                                              *
      *                                                                *
      *                                                                *
      ******************************************************************
           entry 'mySectionTest'.

      ******************************************************************
      * Load and prepare the user application program ZTPPARAT for use *
      ******************************************************************
           move low-values to I_PrepareModule
           move 'ZTPPARAT' to moduleName in ZWS_PrepareModule
           call ZTESTUT using ZWS_PrepareModule

      ******************************************************************
      * Prepare the section 003-SECTION in ZTPPARAT for execution.     *
      ******************************************************************
           move low-values to I_PrepareSection
           move 'ZTPPARAT' to moduleName in ZWS_PrepareSection
           move 'ZTPPARAT' to functionName in ZWS_PrepareSection
           move '003-SECTION' to sectionName in ZWS_PrepareSection
           call ZTESTUT using ZWS_PrepareSection, Program_Function

      ******************************************************************
      * Spy on the COBOL section in the user program.                  *
      ******************************************************************
           move low-values to I_SpySection
           move 'ZTPPARAT' to moduleName in ZWS_SpySection
           move 'ZTPPARAT' to functionName in ZWS_SpySection
           move '003-SECTION' to sectionName in ZWS_SpySection
           set sideEffect in ZWS_SpySection to entry 'my_section'
           call ZTESTUT using ZWS_SpySection,
                sectionSpyObject in Section_Data

      ******************************************************************
      * Start the ZTPPARAT function                                    *
      ******************************************************************
           call Program_Function

      ******************************************************************
      * Assert that the section was actually called.                   *
      ******************************************************************
           move low-values to I_AssertCalledSection
           set spyObject in ZWS_AssertCalledSection to
               address of sectionSpyObject in Section_Data
           call ZTESTUT using ZWS_AssertCalledSection

           goback.

      ******************************************************************
      *                                                                *
      *                                                                *
      * Provide the side effect routine entry point for the COBOL      *
      * section.                                                       *
      *                                                                *
      * Obtain the address of variables in the user program and        *
      * display them.                                                  *
      *                                                                *
      *                                                                *
      ******************************************************************
           entry 'my_section'.

           move low-values to I_GetVariable
           move 'WSAREA1' to variableName in ZWS_GetVariable
           call ZTESTUT using ZWS_GetVariable, Variable_Address
           set address of MY_WSAREA1 to Variable_Address
           display 'Spied variable WSAREA1 value is ' MY_WSAREA1

           goback.
