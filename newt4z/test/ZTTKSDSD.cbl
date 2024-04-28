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
      * This test example shows how to set up 2 tests. The first test  *
      * will mock a fixed-length KSDS file with the test case          *
      * providing the data. The second test will mock a                *
      * variable-length KSDS file with the test case providing the     *
      * data.                                                          *
      *                                                                *
      * In both of these tests, the data comes from the test case      *
      * itself.                                                        *
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. 'ZTTKSDSD' RECURSIVE.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
      ******************************************************************
      * Copy in our required control blocks from Test4z.               *
      ******************************************************************
       COPY ZTESTWS.

      ******************************************************************
      * Define any working-storage items that we need.                 *
      ******************************************************************
       1 FILE_FIXEDDATA.
         COPY ZFILE.

       1 KSDS_FIXEDDATA.
         COPY ZKSDS.
         COPY ZSPKSDS.
          3 MY_DATA.
             5               PIC X(250) VALUE '00000001This is record 1'
                                                                      .
             5               PIC X(250) VALUE '00000002This is record 2'
                                                                      .
             5               PIC X(250) VALUE '00000003This is record 3'
                                                                      .
             5               PIC X(250) VALUE '00000004This is record 4'
                                                                      .
             5               PIC X(250) VALUE '00000005This is record 5'
                                                                      .
             5               PIC X(250) VALUE '00000006This is record 6'
                                                                      .
             5               PIC X(250) VALUE '00000007This is record 7'
                                                                      .
             5               PIC X(250) VALUE '00000008This is record 8'
                                                                      .
             5               PIC X(250) VALUE '00000009This is record 9'
                                                                      .
             5               PIC X(250) VALUE 
                                            '00000010This is record 10'.

       1 FILE_VARIABLEDATA.
         COPY ZFILE.

       1 KSDS_VARIABLEDATA.
         COPY ZKSDS.
         COPY ZSPKSDS.
          3 MY_DATA.
             5               PIC 9(4) COMP-5
                                        VALUE 27.
             5               PIC X(27)  VALUE 
                                          '00000001This is record 1  a'.
             5               PIC 9(4) COMP-5
                                        VALUE 28.
             5               PIC X(28)  VALUE 
                                         '00000002This is record 2  ab'.
             5               PIC 9(4) COMP-5
                                        VALUE 29.
             5               PIC X(29)  VALUE 
                                        '00000003This is record 3  abc'.
             5               PIC 9(4) COMP-5
                                        VALUE 30.
             5               PIC X(30)  VALUE 
                                       '00000004This is record 4  abcd'.
             5               PIC 9(4) COMP-5
                                        VALUE 31.
             5               PIC X(31)  VALUE 
                                      '00000005This is record 5  abcde'.
             5               PIC 9(4) COMP-5
                                        VALUE 32.
             5               PIC X(32)  VALUE 
                                     '00000006This is record 6  abcdef'.
             5               PIC 9(4) COMP-5
                                        VALUE 33.
             5               PIC X(33)  VALUE 
                                    '00000007This is record 7  abcdefg'.
             5               PIC 9(4) COMP-5
                                        VALUE 34.
             5               PIC X(34)  VALUE 
                                   '00000008This is record 8  abcdefgh'.
             5               PIC 9(4) COMP-5
                                        VALUE 35.
             5               PIC X(35)  VALUE 
                                  '00000009This is record 9  abcdefghi'.
             5               PIC 9(4) COMP-5
                                        VALUE 36.
             5               PIC X(36)  VALUE 
                                 '00000010This is record 10 abcdefghij'.

       1 KSDS_FUNCTION USAGE FUNCTION-POINTER.

       LINKAGE SECTION.
      ******************************************************************
      * Copy in our required control blocks from Test4z.               *
      ******************************************************************
       COPY ZTESTLS.

      ******************************************************************
      * Define any linkage section items that we need.                 *
      ******************************************************************
       1 MY_KSDS_SPY.
         COPY ZSPKSDS.

       1 MY_KSDSDATA         PIC X(250).

       PROCEDURE DIVISION.
      ******************************************************************
      * Register a set of tests to be run.                             *
      ******************************************************************
           MOVE LOW-VALUES TO I_TEST
           SET TESTFUNCTION IN ZWS_TEST TO ENTRY 'mytestFixed'
           MOVE 'Fixed KSDS test' TO TESTNAME IN ZWS_TEST
           CALL ZTESTUT USING ZWS_TEST

           MOVE LOW-VALUES TO I_TEST
           SET TESTFUNCTION IN ZWS_TEST TO ENTRY 'mytestVariable'
           MOVE 'Variable KSDS test' TO TESTNAME IN ZWS_TEST
           CALL ZTESTUT USING ZWS_TEST

      ******************************************************************
      * Once all of the tests have been registered, return back to     *
      * Test4z to start processing.                                    *
      ******************************************************************
           GOBACK.

      ******************************************************************
      *                                                                *
      *                                                                *
      * Provide the call back routine entry point for the fixed-length *
      * KSDS test with data provided by the test case.                 *
      *                                                                *
      *                                                                *
      ******************************************************************
           ENTRY 'mytestFixed'.

      ******************************************************************
      * Create a base file object for KSDS file TESTKSDS with data     *
      * provided. The data for a fixed-length file is a set of records *
      * of the same length as the record size of the file.             *
      ******************************************************************
           MOVE LOW-VALUES TO I_FILE
           SET RECORDADDRESS IN ZWS_FILE TO
              ADDRESS OF MY_DATA IN KSDS_FIXEDDATA
           MOVE 10 TO RECORDCOUNT IN ZWS_FILE
           MOVE 250 TO RECORDSIZE IN ZWS_FILE
           CALL ZTESTUT USING ZWS_FILE, FILEOBJECT IN FILE_FIXEDDATA

      ******************************************************************
      * Using the previous base object pointer, create a KSDS file     *
      * object to be intercepted when being accessed by program        *
      * ZTPKSDST.                                                      *
      ******************************************************************
           MOVE LOW-VALUES TO I_MOCKKSDS
           MOVE 'TESTKSDS' TO FILENAME IN ZWS_MOCKKSDS
           SET FILEOBJECT IN ZWS_MOCKKSDS TO
              ADDRESS OF FILEOBJECT IN FILE_FIXEDDATA
           MOVE 1 TO KEYOFFSET IN ZWS_MOCKKSDS
           MOVE 8 TO KEYLENGTH IN ZWS_MOCKKSDS
           CALL ZTESTUT USING ZWS_MOCKKSDS,
                              KSDSOBJECT IN KSDS_FIXEDDATA

      ******************************************************************
      * Spy on the KSDS file.                                          *
      ******************************************************************
           MOVE LOW-VALUES TO I_SPYKSDS
           MOVE 'TESTKSDS' TO FILENAME IN ZWS_SPYKSDS
           SET SIDEEFFECT IN ZWS_SPYKSDS TO ENTRY 'TESTKSDS_fixedAccess'
           CALL ZTESTUT USING ZWS_SPYKSDS,
                              KSDSSPYOBJECT IN KSDS_FIXEDDATA

      ******************************************************************
      * Load and prepare the user application program ZTPKSDST for     *
      * use. Get the function address and call the function. This can  *
      * be done all in 1 call to RunFunction or as individual calls    *
      * to PrepareModule, GetFunction and then call the function.      *
      ******************************************************************
           MOVE LOW-VALUES TO I_RUNFUNCTION
           MOVE 'ZTPKSDST' TO MODULENAME IN ZWS_RUNFUNCTION
           MOVE 'ZTPKSDST' TO FUNCTIONNAME IN ZWS_RUNFUNCTION
           CALL ZTESTUT USING ZWS_RUNFUNCTION

           GOBACK.

      ******************************************************************
      *                                                                *
      *                                                                *
      * Provide the side effect routine entry point for the KSDS       *
      * access.                                                        *
      *                                                                *
      *                                                                *
      ******************************************************************
           ENTRY 'TESTKSDS_fixedAccess' USING MY_KSDS_SPY.

      ******************************************************************
      * Map the linkage section to the address of the last record.     *
      ******************************************************************
           SET ADDRESS OF ZLS_KSDS_RECORD TO LASTCALL IN MY_KSDS_SPY

      ******************************************************************
      * Display each written record when intercepted.                  *
      ******************************************************************
           IF COMMAND IN ZLS_KSDS_RECORD = 'WRITE' AND
              STATUSCODE1 IN ZLS_KSDS_RECORD = '00'
              SET ADDRESS OF MY_KSDSDATA TO
                 PTR IN RECORD_ IN ZLS_KSDS_RECORD
              DISPLAY 'WRITE='
                      SIZ IN RECORD_ IN ZLS_KSDS_RECORD
                      ' '
                      MY_KSDSDATA(1:SIZ IN RECORD_ IN ZLS_KSDS_RECORD)
           END-IF

      ******************************************************************
      * Display each read record when intercepted.                     *
      ******************************************************************
           IF COMMAND IN ZLS_KSDS_RECORD = 'READ' AND
              STATUSCODE1 IN ZLS_KSDS_RECORD = '00'
              SET ADDRESS OF MY_KSDSDATA TO
                 PTR IN RECORD_ IN ZLS_KSDS_RECORD
              DISPLAY 'READ='
                      SIZ IN RECORD_ IN ZLS_KSDS_RECORD
                      ' '
                      MY_KSDSDATA(1:SIZ IN RECORD_ IN ZLS_KSDS_RECORD)
           END-IF

           GOBACK.

      ******************************************************************
      *                                                                *
      *                                                                *
      * Provide the call back routine entry point for the              *
      * variable-length KSDS test with data provided by the test case. *
      *                                                                *
      *                                                                *
      ******************************************************************
           ENTRY 'mytestVariable'.

      ******************************************************************
      * Create a base file object for KSDS file TESTKSDS with data     *
      * provided. The data for a variable-length file is a set of      *
      * records with for each record a halfword (PIC 9(4) COMP-5)      *
      * length of the data that follows for that specific record.      *
      * A variable-length KSDS file object must have a minimum record  *
      * length specified that is greater than 0, otherwise the file    *
      * object is treated as fixed-length.                             *
      ******************************************************************
           MOVE LOW-VALUES TO I_FILE
           SET RECORDADDRESS IN ZWS_FILE TO
              ADDRESS OF MY_DATA IN KSDS_VARIABLEDATA
           MOVE 10 TO RECORDCOUNT IN ZWS_FILE
           MOVE 8 TO RECORDMINIMUMSIZE IN ZWS_FILE
           MOVE 250 TO RECORDSIZE IN ZWS_FILE
           CALL ZTESTUT USING ZWS_FILE, FILEOBJECT IN FILE_VARIABLEDATA

      ******************************************************************
      * Using the previous base object pointer, create a KSDS file     *
      * object to be intercepted when being accessed by program        *
      * ZTPKSDST.                                                      *
      ******************************************************************
           MOVE LOW-VALUES TO I_MOCKKSDS
           MOVE 'TESTKSDS' TO FILENAME IN ZWS_MOCKKSDS
           SET FILEOBJECT IN ZWS_MOCKKSDS TO
              ADDRESS OF FILEOBJECT IN FILE_VARIABLEDATA
           MOVE 1 TO KEYOFFSET IN ZWS_MOCKKSDS
           MOVE 8 TO KEYLENGTH IN ZWS_MOCKKSDS
           CALL ZTESTUT USING ZWS_MOCKKSDS,
                              KSDSOBJECT IN KSDS_VARIABLEDATA

      ******************************************************************
      * Spy on the KSDS file.                                          *
      ******************************************************************
           MOVE LOW-VALUES TO I_SPYKSDS
           MOVE 'TESTKSDS' TO FILENAME IN ZWS_SPYKSDS
           SET SIDEEFFECT IN ZWS_SPYKSDS TO
              ENTRY 'TESTKSDS_variableAccess'
           CALL ZTESTUT USING ZWS_SPYKSDS,
                              KSDSSPYOBJECT IN KSDS_VARIABLEDATA

      ******************************************************************
      * Load and prepare the user application program ZTPKSDST for use *
      ******************************************************************
           MOVE LOW-VALUES TO I_PREPAREMODULE
           MOVE 'ZTPKSDST' TO MODULENAME IN ZWS_PREPAREMODULE
           CALL ZTESTUT USING ZWS_PREPAREMODULE

      ******************************************************************
      * Get the entry point of the ZTPKSDST routine in load module     *
      * ZTPKSDST.                                                      *
      ******************************************************************
           MOVE LOW-VALUES TO I_GETFUNCTION
           MOVE 'ZTPKSDST' TO MODULENAME IN ZWS_GETFUNCTION
           MOVE 'ZTPKSDST' TO FUNCTIONNAME IN ZWS_GETFUNCTION
           CALL ZTESTUT USING ZWS_GETFUNCTION, KSDS_FUNCTION

      ******************************************************************
      * Start the ZTPKSDST function and receive call backs in          *
      * TESTKSDS_variableAccess.                                       *
      ******************************************************************
           CALL KSDS_FUNCTION

           GOBACK.

      ******************************************************************
      *                                                                *
      *                                                                *
      * Provide the side effect routine entry point for the KSDS       *
      * access.                                                        *
      *                                                                *
      *                                                                *
      ******************************************************************
           ENTRY 'TESTKSDS_variableAccess' USING MY_KSDS_SPY.

      ******************************************************************
      * Map the linkage section to the address of the last record.     *
      ******************************************************************
           SET ADDRESS OF ZLS_KSDS_RECORD TO LASTCALL IN MY_KSDS_SPY

      ******************************************************************
      * Display each written record when intercepted.                  *
      ******************************************************************
           IF COMMAND IN ZLS_KSDS_RECORD = 'WRITE' AND
              STATUSCODE1 IN ZLS_KSDS_RECORD = '00'
              SET ADDRESS OF MY_KSDSDATA TO
                 PTR IN RECORD_ IN ZLS_KSDS_RECORD
              DISPLAY 'WRITE='
                      SIZ IN RECORD_ IN ZLS_KSDS_RECORD
                      ' '
                      MY_KSDSDATA(1:SIZ IN RECORD_ IN ZLS_KSDS_RECORD)
           END-IF

      ******************************************************************
      * Display each read record when intercepted.                     *
      ******************************************************************
           IF COMMAND IN ZLS_KSDS_RECORD = 'READ' AND
              STATUSCODE1 IN ZLS_KSDS_RECORD = '00'
              SET ADDRESS OF MY_KSDSDATA TO
                 PTR IN RECORD_ IN ZLS_KSDS_RECORD
              DISPLAY 'READ='
                      SIZ IN RECORD_ IN ZLS_KSDS_RECORD
                      ' '
                      MY_KSDSDATA(1:SIZ IN RECORD_ IN ZLS_KSDS_RECORD)
           END-IF

           GOBACK.