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
      *                                                                *
      *          L O W - L E V E L   A P I   E X A M P L E             *
      *                                                                *
      ******************************************************************
      * This test example shows how to set up 2 tests. The first test  *
      * will mock a fixed-length QSAM file with the test case          *
      * providing the data. The second test will mock a                *
      * variable-length QSAM file with the test case providing the     *
      * data.                                                          *
      *                                                                *
      * In both of these tests, the data comes from the test case      *
      * itself.                                                        *
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. 'ZTTQSAML' RECURSIVE.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
      ******************************************************************
      * Copy in our required control blocks from Test4z.               *
      ******************************************************************
       COPY ZTESTWS.

      ******************************************************************
      * Define any working-storage items that we need.                 *
      ******************************************************************
       1 QSAM_FixedData.
         COPY ZLLFILE.
         COPY ZLLQSAM.
         3 MY_Data.
           5 PIC X(80) VALUE 'This is record 1'.
           5 PIC X(80) VALUE 'This is record 2'.
           5 PIC X(80) VALUE 'This is record 3'.
           5 PIC X(80) VALUE 'This is record 4'.
           5 PIC X(80) VALUE 'This is record 5'.
           5 PIC X(80) VALUE 'This is record 6'.
           5 PIC X(80) VALUE 'This is record 7'.
           5 PIC X(80) VALUE 'This is record 8'.
           5 PIC X(80) VALUE 'This is record 9'.
           5 PIC X(80) VALUE 'This is record 10'.

       1 QSAM_VariableData.
         COPY ZLLFILE.
         COPY ZLLQSAM.
         3 MY_Data.
           5 PIC 9(4) comp-5 VALUE 20.
           5 PIC X(20) VALUE 'This is record 1  ab'.
           5 PIC 9(4) comp-5 VALUE 22.
           5 PIC X(22) VALUE 'This is record 2  abcd'.
           5 PIC 9(4) comp-5 VALUE 24.
           5 PIC X(24) VALUE 'This is record 3  abcdef'.
           5 PIC 9(4) comp-5 VALUE 26.
           5 PIC X(26) VALUE 'This is record 4  abcdefgh'.
           5 PIC 9(4) comp-5 VALUE 28.
           5 PIC X(28) VALUE 'This is record 5  abcdefghij'.
           5 PIC 9(4) comp-5 VALUE 30.
           5 PIC X(30) VALUE 'This is record 6  abcdefghijkl'.
           5 PIC 9(4) comp-5 VALUE 32.
           5 PIC X(32) VALUE 'This is record 7  abcdefghijklmn'.
           5 PIC 9(4) comp-5 VALUE 34.
           5 PIC X(34) VALUE 'This is record 8  abcdefghijklmnop'.
           5 PIC 9(4) comp-5 VALUE 36.
           5 PIC X(36) VALUE 'This is record 9  abcdefghijklmnopqr'.
           5 PIC 9(4) comp-5 VALUE 38.
           5 PIC X(38) VALUE 'This is record 10 abcdefghijklmnopqrst'.

       1 QSAM_Function USAGE FUNCTION-POINTER.

       LINKAGE SECTION.
      ******************************************************************
      * Copy in our required control blocks from Test4z.               *
      ******************************************************************
       COPY ZTESTLS.

      ******************************************************************
      * Define any linkage section items that we need.                 *
      ******************************************************************
       1 MY_CondCode PIC X.
       1 MY_Length PIC S9(9) COMP-5.
       1 MY_QSAMData PIC X(80).

       PROCEDURE DIVISION.
      ******************************************************************
      * Register a set of tests to be run.                             *
      ******************************************************************
           move low-values to I_Test
           set testFunction in ZWS_Test to entry 'mytestFixed'
           move 'Fixed QSAM test' to testName in ZWS_Test
           call ZTESTUT using ZWS_Test

           move low-values to I_Test
           set testFunction in ZWS_Test to entry 'mytestVariable'
           move 'Variable QSAM test' to testName in ZWS_Test
           call ZTESTUT using ZWS_Test

      ******************************************************************
      * Once all of the tests have been registered, return back to     *
      * Test4z to start processing.                                    *
      ******************************************************************
           goback.

      ******************************************************************
      *                                                                *
      *                                                                *
      * Provide the call back routine entry point for the fixed-length *
      * QSAM test with data provided by the test case.                 *
      *                                                                *
      *                                                                *
      ******************************************************************
           entry 'mytestFixed'.

      ******************************************************************
      * Create a base file object for QSAM file TESTQSAM with data     *
      * provided. The data for a fixed-length file is a set of records *
      * of the same length as the record size of the file.             *
      ******************************************************************
           move low-values to I_LLFile
           set recordAddress in ZWS_LLFile to
               address of MY_Data in QSAM_FixedData
           move 10 to recordCount in ZWS_LLFile
           move 80 to recordSize in ZWS_LLFile
           call ZTESTUT using ZWS_LLFile,
                fileLLObject in QSAM_FixedData

      ******************************************************************
      * Using the previous base object pointer, create a QSAM file     *
      * object to be intercepted when being accessed by program        *
      * ZTPQSAMT.                                                      *
      ******************************************************************
           move low-values to I_LLMockQSAM
           set callback in ZWS_LLMockQSAM to
               entry 'TESTQSAM_fixedAccess'
           move 'ZTPQSAMT' to moduleName in ZWS_LLMockQSAM
           move 'TESTQSAM' to fileName in ZWS_LLMockQSAM
           set fileLLObject in ZWS_LLMockQSAM to
               address of fileLLObject in QSAM_FixedData
           call ZTESTUT using ZWS_LLMockQSAM,
                qsamLLObject in QSAM_FixedData

      ******************************************************************
      * Load and prepare the user application program ZTPQSAMT for use *
      ******************************************************************
           move low-values to I_PrepareModule
           move 'ZTPQSAMT' to moduleName in ZWS_PrepareModule
           call ZTESTUT using ZWS_PrepareModule

      ******************************************************************
      * Get the entry point of the ZTPQSAMT routine in load module     *
      * ZTPQSAMT.                                                      *
      ******************************************************************
           move low-values to I_GetFunction
           move 'ZTPQSAMT' to moduleName in ZWS_GetFunction
           move 'ZTPQSAMT' to functionName in ZWS_GetFunction
           call ZTESTUT using ZWS_GetFunction, QSAM_Function

      ******************************************************************
      * Start the ZTPQSAMT function and receive call backs in          *
      * TESTQSAM_fixedAccess.                                          *
      ******************************************************************
           call QSAM_Function

           goback.

      ******************************************************************
      *                                                                *
      *                                                                *
      * Provide the call back routine entry point for the QSAM fixed   *
      * access.                                                        *
      *                                                                *
      *                                                                *
      ******************************************************************
           entry 'TESTQSAM_fixedAccess' using ZLS_goBlock,
                 ZLS_Q_itBlock, ZLS_Q_ifBlock.

      ******************************************************************
      * Display each written record when intercepted. Before-side      *
      * intercepts are for commands and arguments that are being sent  *
      * to the middleware.                                             *
      ******************************************************************
           if WHEN_BEFORE in ZLS_Q_itBlock
              set address of MY_Condcode to condCode in ZLS_Q_ifBlock
              if MY_Condcode = X'00' and
                 commandName in ZLS_Q_itBlock = 'WRITE'
                 set address of MY_QSAMData to
                     recordData in ZLS_Q_ifBlock
                 set address of MY_Length to
                     recordLength in ZLS_Q_ifBlock
                 display 'WRITE=' MY_Length ' '
                     MY_QSAMData (1: MY_Length)
              end-if
           end-if

      ******************************************************************
      * Display each read record when intercepted. After-side          *
      * intercepts are for commands and arguments that are being       *
      * received from the middleware.                                  *
      ******************************************************************
           if WHEN_AFTER in ZLS_Q_itBlock
              set address of MY_Condcode to condCode in ZLS_Q_ifBlock
              if MY_Condcode = X'00' and
                 commandName in ZLS_Q_itBlock = 'READ'
                 set address of MY_QSAMData to
                     recordData in ZLS_Q_ifBlock
                 set address of MY_Length to
                     recordLength in ZLS_Q_ifBlock
                 display 'READ=' MY_Length ' '
                     MY_QSAMData (1: MY_Length)
              end-if
           end-if

           goback.

      ******************************************************************
      *                                                                *
      *                                                                *
      * Provide the call back routine entry point for the              *
      * variable-length QSAM test with data provided by the test case. *
      *                                                                *
      *                                                                *
      ******************************************************************
           entry 'mytestVariable'.

      ******************************************************************
      * Create a base file object for QSAM file TESTQSAM with data     *
      * provided. The data for a variable-length file is a set of      *
      * records with for each record a halfword (PIC 9(4) COMP-5)      *
      * length of the data that follows for that specific record.      *
      * A variable-length QSAM file object must have a minimum record  *
      * length specified that is greater than 0, otherwise the file    *
      * object is treated as fixed-length.                             *
      ******************************************************************
           move low-values to I_LLFile
           set recordAddress in ZWS_LLFile to
               address of MY_Data in QSAM_VariableData
           move 10 to recordCount in ZWS_LLFile
           move 1 to recordMinimumSize in ZWS_LLFile
           move 80 to recordSize in ZWS_LLFile
           call ZTESTUT using ZWS_LLFile,
                fileLLObject in QSAM_VariableData

      ******************************************************************
      * Using the previous base object pointer, create a QSAM file     *
      * object to be intercepted when being accessed by program        *
      * ZTPQSAMV.                                                      *
      ******************************************************************
           move low-values to I_LLMockQSAM
           set callback in ZWS_LLMockQSAM to
               entry 'TESTQSAM_variableAccess'
           move 'ZTPQSAMV' to moduleName in ZWS_LLMockQSAM
           move 'TESTQSAM' to fileName in ZWS_LLMockQSAM
           set fileLLObject in ZWS_LLMockQSAM to
               address of fileLLObject in QSAM_VariableData
           call ZTESTUT using ZWS_LLMockQSAM,
                qsamLLObject in QSAM_VariableData

      ******************************************************************
      * Load and prepare the user application program ZTPQSAMV for use *
      ******************************************************************
           move low-values to I_PrepareModule
           move 'ZTPQSAMV' to moduleName in ZWS_PrepareModule
           call ZTESTUT using ZWS_PrepareModule

      ******************************************************************
      * Get the entry point of the ZTPQSAMV routine in load module     *
      * ZTPQSAMV.                                                      *
      ******************************************************************
           move low-values to I_GetFunction
           move 'ZTPQSAMV' to moduleName in ZWS_GetFunction
           move 'ZTPQSAMV' to functionName in ZWS_GetFunction
           call ZTESTUT using ZWS_GetFunction, QSAM_Function

      ******************************************************************
      * Start the ZTPQSAMV function and receive call backs in          *
      * TESTQSAM_variableAccess.                                       *
      ******************************************************************
           call QSAM_Function

           goback.

      ******************************************************************
      *                                                                *
      *                                                                *
      * Provide the call back routine entry point for the QSAM         *
      * variable access.                                               *
      *                                                                *
      *                                                                *
      ******************************************************************
           entry 'TESTQSAM_variableAccess' using ZLS_goBlock,
                 ZLS_Q_itBlock, ZLS_Q_ifBlock.

      ******************************************************************
      * Display each written record when intercepted. Before-side      *
      * intercepts are for commands and arguments that are being sent  *
      * to the middleware.                                             *
      ******************************************************************
           if WHEN_BEFORE in ZLS_Q_itBlock
              set address of MY_Condcode to condCode in ZLS_Q_ifBlock
              if MY_Condcode = X'00' and
                 commandName in ZLS_Q_itBlock = 'WRITE'
                 set address of MY_QSAMData to
                     recordData in ZLS_Q_ifBlock
                 set address of MY_Length to
                     recordLength in ZLS_Q_ifBlock
                 display 'WRITE=' MY_Length ' '
                     MY_QSAMData (1: MY_Length)
              end-if
           end-if

      ******************************************************************
      * Display each read record when intercepted. After-side          *
      * intercepts are for commands and arguments that are being       *
      * received from the middleware.                                  *
      ******************************************************************
           if WHEN_AFTER in ZLS_Q_itBlock
              set address of MY_Condcode to condCode in ZLS_Q_ifBlock
              if MY_Condcode = X'00' and
                 commandName in ZLS_Q_itBlock = 'READ'
                 set address of MY_QSAMData to
                     recordData in ZLS_Q_ifBlock
                 set address of MY_Length to
                     recordLength in ZLS_Q_ifBlock
                 display 'READ=' MY_Length ' '
                     MY_QSAMData (1: MY_Length)
              end-if
           end-if

           goback.
