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
      * that calls another program that is to be stubbed out and       *
      * replaced by the logic from this unit test.                     *
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. 'ZTTSTUBP' RECURSIVE.
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

       LINKAGE SECTION.
      ******************************************************************
      * Copy in our required control blocks from Test4z.               *
      ******************************************************************
       COPY ZTESTLS.

      ******************************************************************
      * Define any linkage section items that we need.                 *
      ******************************************************************
       1 MY_LSAREA1 PIC X(1).
       1 MY_LSAREA2 PIC X(10).

       PROCEDURE DIVISION.
      ******************************************************************
      * Register a set of tests to be run.                             *
      ******************************************************************
           move low-values to I_Test
           set testFunction in ZWS_Test to entry 'myStubTest'
           move 'Stubbed subroutine test' to testName in ZWS_Test
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
      * replaced by our stubbed program logic.                         *
      *                                                                *
      *                                                                *
      ******************************************************************
           entry 'myStubTest'.

      ******************************************************************
      * Define that program ZTPCALLD is to be prevented from being     *
      * called in the original load module, but instead to be          *
      * redirected to our stub routine located in this test.           *
      ******************************************************************
           move low-values to I_StubProgram
           move 'ZTPPROGR' to moduleName in ZWS_StubProgram
           move 'ZTPCALLD' to functionName in ZWS_StubProgram
           set stubRoutine in ZWS_StubProgram to entry 'ZTPCALLD_Stub'
           call ZTESTUT using ZWS_StubProgram

      ******************************************************************
      * Load and prepare the user application program ZTPPROGR for use *
      ******************************************************************
           move low-values to I_PrepareModule
           move 'ZTPPROGR' to moduleName in ZWS_PrepareModule
           call ZTESTUT using ZWS_PrepareModule

      ******************************************************************
      * Get the entry point of the ZTPPROGR routine in load module     *
      * ZTPPROGR.                                                      *
      ******************************************************************
           move low-values to I_GetFunction
           move 'ZTPPROGR' to moduleName in ZWS_GetFunction
           move 'ZTPPROGR' to functionName in ZWS_GetFunction
           call ZTESTUT using ZWS_GetFunction, Program_Function

      ******************************************************************
      * Start the ZTPPROGR function. When it calls ZTPCALLD, those     *
      * calls will be diverted to the ZTPCALLD_Stub entry point        *
      * located below.                                                 *
      ******************************************************************
           call Program_Function

           goback.

      ******************************************************************
      *                                                                *
      *                                                                *
      * Provide the call back routine entry point for the stubbed      *
      * subroutine originally called ZTPCALLD in the user program, but *
      * diverted to our entry point ZTPCALLD_Stub below. The ZTPCALLD  *
      * program receives 2 arguments and therefore so will our stub.   *
      * In the original ZTPCALLD program the returned animal name was  *
      * all uppercase. In our stub replacement we return the same      *
      * animal in mixed case. The ZTPPROGR program displays what was   *
      * returned to it.                                                *
      *                                                                *
      *                                                                *
      ******************************************************************
           entry 'ZTPCALLD_Stub' using MY_LSAREA1, MY_LSAREA2.

           if MY_LSAREA1 = 'A' move 'Aardvark  ' to MY_LSAREA2 end-if
           if MY_LSAREA1 = 'B' move 'Baboon    ' to MY_LSAREA2 end-if
           if MY_LSAREA1 = 'C' move 'Camel     ' to MY_LSAREA2 end-if
           if MY_LSAREA1 = 'D' move 'Deer      ' to MY_LSAREA2 end-if
           if MY_LSAREA1 = 'E' move 'Eagle     ' to MY_LSAREA2 end-if
           if MY_LSAREA1 = 'F' move 'Falcon    ' to MY_LSAREA2 end-if
           if MY_LSAREA1 = 'G' move 'Gazelle   ' to MY_LSAREA2 end-if
           if MY_LSAREA1 = 'H' move 'Hamster   ' to MY_LSAREA2 end-if
           if MY_LSAREA1 = 'I' move 'Iguana    ' to MY_LSAREA2 end-if
           if MY_LSAREA1 = 'J' move 'Jackal    ' to MY_LSAREA2 end-if
           if MY_LSAREA1 = 'K' move 'Kangaroo  ' to MY_LSAREA2 end-if
           if MY_LSAREA1 = 'L' move 'Lemur     ' to MY_LSAREA2 end-if
           if MY_LSAREA1 = 'M' move 'Macaw     ' to MY_LSAREA2 end-if
           if MY_LSAREA1 = 'N' move 'Newt      ' to MY_LSAREA2 end-if
           if MY_LSAREA1 = 'O' move 'Octopus   ' to MY_LSAREA2 end-if
           if MY_LSAREA1 = 'P' move 'Panther   ' to MY_LSAREA2 end-if
           if MY_LSAREA1 = 'Q' move 'Quail     ' to MY_LSAREA2 end-if
           if MY_LSAREA1 = 'R' move 'Rabbit    ' to MY_LSAREA2 end-if
           if MY_LSAREA1 = 'S' move 'Scorpion  ' to MY_LSAREA2 end-if
           if MY_LSAREA1 = 'T' move 'Tiger     ' to MY_LSAREA2 end-if
           if MY_LSAREA1 = 'U' move 'Urchin    ' to MY_LSAREA2 end-if
           if MY_LSAREA1 = 'V' move 'Vole      ' to MY_LSAREA2 end-if
           if MY_LSAREA1 = 'W' move 'Walrus    ' to MY_LSAREA2 end-if
           if MY_LSAREA1 = 'X' move 'Xerus     ' to MY_LSAREA2 end-if
           if MY_LSAREA1 = 'Y' move 'Yak       ' to MY_LSAREA2 end-if
           if MY_LSAREA1 = 'Z' move 'Zebra     ' to MY_LSAREA2 end-if

      ******************************************************************
      * Send a message to the results log                              *
      ******************************************************************
           move low-values to I_Message
           move spaces to messageText in ZWS_Message
           string 'The returned value from the stub is '
                  delimited by size
                  MY_LSAREA2 delimited by size
                  into messageText in ZWS_Message
           call ZTESTUT using ZWS_Message

           goback.
