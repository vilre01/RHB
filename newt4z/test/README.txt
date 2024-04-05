      ******************************************************************
      * Copyright (c) 2023 Broadcom. All Rights Reserved.              *
      * The term "Broadcom" refers to Broadcom Inc. and/or its         *
      * subsidiaries.                                                  *
      ******************************************************************
      ******************************************************************
      * All test cases that use this COBOL API must use these COBOL    *
      * compiler options. Failure to use these will cause attempts to  *
      * dynamically load modules that are the same name as the entry   *
      * points the user defined, resulting in failure.                 *
      *                                                                *
      * PROCESS PGMN(LM),NODYNAM                                       *
      ******************************************************************

      ******************************************************************
      * This is the list of sample programs provided in the sample     *
      * library.                                                       *
      *----------------------------------------------------------------*
      *                                                                *
      * ZTTCICSR                                                       *
      * This test example shows how to run a unit test using           *
      * previously recorded data for a program using CICS with no      *
      * intercept spy.                                                 *
      *                                                                *
      * ZTTDB2SR                                                       *
      * This test example shows how to run a unit test using           *
      * previously recorded data for a program using Db2 with no       *
      * intercept spy.                                                 *
      *                                                                *
      * ZTTDOGOS                                                       *
      * This test suite contains a set of tests meant to show how the  *
      * Test4z API can be used. It is not meant to be exhaustive       *
      * but instead show patterns of usage and code organization.      *
      *                                                                *
      * ZTTFILES                                                       *
      * This test example shows how to set up 2 tests. The first test  *
      * will intercept QSAM file calls and then display the records.   *
      * The second test will intercept VSAM/KSDS file calls and then   *
      * display the records. In both of these tests, the data comes    *
      * from the original dataset records. There is no data provided   *
      * by the test case in this example. For data-provided examples,  *
      * see ZTTKSDSD and ZTTQSAMD.                                     *
      *                                                                *
      * ZTTKSDSD                                                       *
      * This test example shows how to set up 2 tests. The first test  *
      * will mock a fixed-length KSDS file with the test case          *
      * providing the data. The second test will mock a                *
      * variable-length KSDS file with the test case providing the     *
      * data. In both of these tests, the data comes from the test     *
      * case itself.                                                   *
      *                                                                *
      * ZTTMOCKD                                                       *
      * This test example shows how to set up a Db2 test with the test *
      * case providing the data.                                       *
      *                                                                *
      * ZTTMOCKP                                                       *
      * This test example shows how to run a unit test on a program    *
      * that calls another program that is to be stubbed out. Any      *
      * argument data is to be replaced using the previously recorded  *
      * data.                                                          *
      *                                                                *
      * ZTTMOCKX                                                       *
      * This test example shows how to run a unit test on a program    *
      * that calls another program that is to be stubbed out. Any      *
      * argument data is to be replaced using the previously recorded  *
      * data. This example uses the _RunFunction API to combine the    *
      * _PrepareModule and _GetFunction API calls along with the call  *
      * to start the function.                                         *
      *                                                                *
      * ZTTPARMP                                                       *
      * This test example shows how to access parameters defined in    *
      * the ZLOPTS file from within a test case. This technique can be *
      * used to help direct the flow of tests or provide information   *
      * to them.                                                       *
      *                                                                *
      * ZTTQSAMD                                                       *
      * This test example shows how to set up 2 tests. The first test  *
      * will mock a fixed-length QSAM file with the test case          *
      * providing the data. The second test will mock a                *
      * variable-length QSAM file with the test case providing the     *
      * data. In both of these tests, the data comes from the test     *
      * case itself.                                                   *
      *                                                                *
      * ZTTQSAMH                                                       *
      * This test example shows how to set up a test. The first test   *
      * will mock a fixed-length QSAM file with the test case          *
      * providing the data. The data comes from the test case itself.  *
      * The test case compares the output data of the program under    *
      * test with the expected output.                                 *
      *                                                                *
      * ZTTQSAMP and ZTTQSAMR                                          *
      * These test examples shows how to run a unit test using         *
      * previously recorded data for a batch program using QSAM with   *
      * no intercept spy, but with a mismatch handler in the test case *
      * code.                                                          *
      *                                                                *
      * ZTTQSAMN                                                       *
      * This test example shows how to run a unit test using           *
      * previously recorded data for a batch program using QSAM with   *
      * no intercept spy.                                              *
      *                                                                *
      * ZTTSECTN                                                       *
      * This test example shows how to run a unit test on a section in *
      * the COBOL application program. This will isolate the section   *
      * from the rest of the user program and only execute it. It also *
      * shows how to get the address of user variables in user program *
      * and display them.                                              *
      *                                                                *
      * ZTTSTUBP                                                       *
      * This test example shows how to run a unit test on a program    *
      * that calls another program that is to be stubbed out and       *
      * replaced by the logic from this unit test.                     *
      *                                                                *
      ******************************************************************
      *                      L O W - L E V E L   A P I                 *
      *                                                                *
      * These are the low-level API examples that allow more granular  *
      * control.                                                       *
      *                                                                *
      * ZTTKSDSL                                                       *
      * This test example shows how to set up 2 tests.                 *
      * The first test will mock a fixed-length KSDS file with the     *
      * test case providing the data.                                  *
      * The second test will mock a variable-length KSDS file with the *
      * test case providing the data.                                  *
      * In both of these tests, the data comes from the test case      *
      * itself.                                                        *
      *                                                                *
      * ZTTQSAML                                                       *
      * This test example shows how to set up 2 tests.                 *
      * The first test will mock a fixed-length QSAM file with the     *
      * test case providing the data.                                  *
      * The second test will mock a variable-length QSAM file with the *
      * test case providing the data.                                  *
      * In both of these tests, the data comes from the test case      *
      * itself.                                                        *
      *                                                                *
      ******************************************************************

      ******************************************************************
      * All API calls take the same form when calling them. First you  *
      * move low-values to the I_ variable (input variable) for the    *
      * API. The I_ variable is always I_ followed by the name of the  *
      * API. Then you call ZTESTUT passing the name of the entire      *
      * working-storage area for the API data followed by any          *
      * additional required output variables. The working-storage API  *
      * name is a concatenation of ZWS_ followed by the name of the    *
      * API. For example, to use the Test API call you would code:     *
      *      move low-values to I_Test                                 *
      *      call ZTESTUT using ZWS_Test                               *
      *                                                                *
      *----------------------------------------------------------------*
      * This is the list of available APIs to perform unit testing.    *
      * The details for each specific API call can be found in the     *
      * most recent ZTESTWS.cpy file. To locate the most recent        *
      * version, refer to the name of the member being copied in by    *
      * the ZTESTWS.cpy itself. Usually the ZTESTWS.cpy member name    *
      * will have the highest numerical suffix.                        *
      *----------------------------------------------------------------*
      *                                                                *
      * :TAG:_Fail                                                     *
      *      - This API will cause a test case failure to happen,      *
      *        unconditionally.                                        *
      *                                                                *
      * :TAG:_Assert                                                   *
      *      - This API will cause an assert to happen based on the    *
      *        value of the conditionCode variable. When using COBOL   *
      *        there is no automatic way to check the condition code   *
      *        value without coding your own IF statement. For this    *
      *        reason it is easier to use the _Fail API instead.       *
      *                                                                *
      * :TAG:_Message                                                  *
      *      - This API will write a message to the results log        *
      *        without altering the condition code of the test.        *
      *                                                                *
      * :TAG:_GetParm                                                  *
      *      - This API will return the address and length of any      *
      *        Test4z parameter data defined in the ZLOPTS option      *
      *        PARM(xxx) for the execution of the test. The PARM(xxx)  *
      *        option allows a user to pass data from the ZLOPTS file  *
      *        to the running test.                                    *
      *                                                                *
      * :TAG:_Test                                                     *
      *      - This API will register a test to be included in the     *
      *        suite of tests about to be started.                     *
      *                                                                *
      * :TAG:_RegisterMismatch                                         *
      *      - This API will register the existence of a mismatch      *
      *        handler to be called during a unit test.                *
      *                                                                *
      * :TAG:_RegisterNoRecord                                         *
      *      - This API will register the existence of a no record     *
      *        found handler to be called during a unit test.          *
      *                                                                *
      * :TAG:_RegisterUnused                                           *
      *      - This API will register the existence of an unused       *
      *        record found handler to be called during a unit test.   *
      *                                                                *
      * :TAG:_RegisterCoverage                                         *
      *      - This API will register the existence of a code coverage *
      *        handler to be called at the end of the unit test.       *
      *                                                                *
      * :TAG:_RegisterPattern                                          *
      *      - This API will register the existence of a pattern match *
      *        table to be used for matching data in the effort to     *
      *        identify mismatches.                                    *
      *                                                                *
      * :TAG:_PrepareModule                                            *
      *      - This API will load and prepare a user module to be run  *
      *        as a unit test.                                         *
      *        The _RunFunction combines the _PrepareModule and        *
      *        _GetFunction APIs and additionally calls the function   *
      *        to begin execution. The _RunFunction API reduces the    *
      *        coding for the test case and is the preferred method of *
      *        starting the test case.                                 *
      *                                                                *
      * :TAG:_GetFunction                                              *
      *      - This API will request the address of a program within   *
      *        the prepared module.                                    *
      *        The _RunFunction combines the _PrepareModule and        *
      *        _GetFunction APIs and additionally calls the function   *
      *        to begin execution. The _RunFunction API reduces the    *
      *        coding for the test case and is the preferred method of *
      *        starting the test case.                                 *
      *                                                                *
      * :TAG:_RunFunction                                              *
      *      - This API will combine both the prepare module and get   *
      *        function API calls and execute the program directly.    *
      *        This function reduces the coding for the test case and  *
      *        is the preferred method of starting the test case.      *
      *                                                                *
      * :TAG:_PrepareSection                                           *
      *      - This API will prepare a section/paragraph within a      *
      *        program within the prepared module and return the       *
      *        starting address.                                       *
      *                                                                *
      * :TAG:_GetVariable                                              *
      *      - This API will request the address of a variable located *
      *        within the prepared module and selected function.       *
      *                                                                *
      * :TAG:_SetBreakpoint                                            *
      *      - This API will set a break point at the start of section *
      *        (or paragraph) of a COBOL user application program.     *
      *                                                                *
      * :TAG:_SetTestpoint                                             *
      *      - This API will set a callback address to your test case  *
      *        logic that is to be executed when a test point call has *
      *        been added to a user program.                           *
      *                                                                *
      * :TAG:_LoadData                                                 *
      *      - This API will load recorded data created by previous    *
      *        record & replay processing to be used by any mocking by *
      *        a unit test.                                            *
      *                                                                *
      * :TAG:_File                                                     *
      *      - This API will create a file object block to be used by  *
      *        the unit test. The QSAM and VSAM control blocks may     *
      *        refer to this file object block and it must be created  *
      *        prior to the QSAM or VSAM mocking calls if the test     *
      *        case is to contain data provided data.                  *
      *        Initial data can be provided to this API to load        *
      *        records that are to be used for the unit test.          *
      *        Additionally or alternatively, the _LoadData API can be *
      *        used to load records for the unit test.                 *
      *        If both methods are used, then both sets of data are    *
      *        available in the test.                                  *
      *                                                                *
      * :TAG:_PrintFile                                                *
      *      - This API will display some or all of the records        *
      *        owned by a file object.                                 *
      *                                                                *
      * :TAG:_MockQSAM                                                 *
      *      - This API will create a QSAM (sequential file) mocking   *
      *        object that may refer to a previously created file      *
      *        object that provides user-supplied data or a previously *
      *        created load object to allow the Zest framework logic   *
      *        to be used to respond to calls logically.               *
      *                                                                *
      * :TAG:_MockKSDS                                                 *
      *      - This API will create a VSAM/KSDS (keyed access) mocking *
      *        object that may refer to a previously created file      *
      *        object that provides user-supplied data or a previously *
      *        created load object to allow the Zest framework logic   *
      *        to be used to respond to calls logically.               *
      *                                                                *
      * :TAG:_MockESDS                                                 *
      *      - This API will create a VSAM/ESDS (entry sequence        *
      *        access) mocking object that may refer to a previously   *
      *        created file object that provides user-supplied data or *
      *        a previously created load object to allow the Zest      *
      *        framework logic to be used to respond to calls          *
      *        logically.                                              *
      *                                                                *
      * :TAG:_MockRRDS                                                 *
      *      - This API will create a VSAM/RRDS (relative record       *
      *        access) mocking object that may refer to a previously   *
      *        created file object that provides user-supplied data or *
      *        a previously created load object to allow the Zest      *
      *        framework logic to be used to respond to calls          *
      *        logically.                                              *
      *                                                                *
      * :TAG:_MockCICS                                                 *
      *      - This API will create a CICS mocking object that may     *
      *        refer to a previously created load object to allow the  *
      *        Zest framework logic to be used to respond to calls     *
      *        logically.                                              *
      *                                                                *
      * :TAG:_MockDB2                                                  *
      *      - This API will create a Db2 mocking object that may      *
      *        refer to a previously created load object to allow the  *
      *        Zest framework logic to be used to respond to calls     *
      *        logically.                                              *
      *        Additionally, CAF calls are handled by this API.        *
      *                                                                *
      * :TAG:_Rowset                                                   *
      *      - This API will create a Db2 rowset required for a Db2    *
      *        mocking object.                                         *
      *                                                                *
      * :TAG:_MockIMS                                                  *
      *      - This API will create a IMS mocking object that may      *
      *        refer to a previously created load object to allow the  *
      *        Zest framework logic to be used to respond to calls     *
      *        logically.                                              *
      *                                                                *
      * :TAG:_MockAIB                                                  *
      *      - This API will create an IMS/AIB mocking object that may *
      *        refer to a previously created load object to allow the  *
      *        Zest framework logic to be used to respond to calls     *
      *        logically.                                              *
      *                                                                *
      * :TAG:_MockMQ                                                   *
      *      - This API will create an MQ mocking object that may      *
      *        refer to a previously created load object to allow the  *
      *        Zest framework logic to be used to respond to calls     *
      *        logically.                                              *
      *                                                                *
      * :TAG:_MockProgram                                              *
      *      - This API will create a program mocking object to be     *
      *        used with previously recorded data. This API will       *
      *        prevent the called program from being executed. Instead *
      *        it will match arguments being passed to the called      *
      *        program and use recorded data to replace arguments on   *
      *        return. This API may refer to a previously created load *
      *        object to allow the Zest framework logic to be used to  *
      *        respond to calls logically.                             *
      *                                                                *
      * :TAG:_StubProgram                                              *
      *      - This API will define a subroutine within a load module  *
      *        to be stubbed out and replaced by the routine defined   *
      *        in the test. No recorded program data nor argument      *
      *        matching will be performed.                             *
      *                                                                *
      ******************************************************************
      * For each of these spy API calls there are additional routines  *
      * that can  be used to determine what the spy detected during    *
      * its processing. These additional routines are as follows and   *
      * their description are found further in this copy file:         *
      *                                                                *
      *   _AssertNoErrors                                              *
      *   _AssertCalled                                                *
      *   _AssertCalledOnce                                            *
      *   _AssertCalledWith                                            *
      *   _AssertCalledOnceWith                                        *
      *   _Display                                                     *
      *                                                                *
      * You must use the correct type of the above API calls depending *
      * upon what type of spy routine is being performed. For example, *
      * for QSAM you would used _AssertNoErrorsQSAM.                   *
      ******************************************************************
      *                                                                *
      * :TAG:_SpyQSAM                                                  *
      *      - This API will create a built-in spy routine on a QSAM   *
      *        (sequential file) file. Once created, other spy API     *
      *        routines can be used with the spy object to test        *
      *        situations.                                             *
      *                                                                *
      * :TAG:_SpyKSDS                                                  *
      *      - This API will create a built-in spy routine on a        *
      *        VSAM/KSDS (keyed file) file. Once created, other spy    *
      *        API routines can be used with the spy object to test    *
      *        situations.                                             *
      *                                                                *
      * :TAG:_SpyESDS                                                  *
      *      - This API will create a built-in spy routine on a        *
      *        VSAM/ESDS (entry sequence) file. Once created, other    *
      *        spy API routines can be used with the spy object to     *
      *        test situations.                                        *
      *                                                                *
      * :TAG:_SpyRRDS                                                  *
      *      - This API will create a built-in spy routine on a        *
      *        VSAM/RRDS (relative record) file. Once created, other   *
      *        spy API routines can be used with the spy object to     *
      *        test situations.                                        *
      *                                                                *
      * :TAG:_SpyCICS                                                  *
      *      - This API will create a built-in spy routine on CICS     *
      *        calls. Once created, other spy API routines can be used *
      *        with the spy object to test situations.                 *
      *                                                                *
      * :TAG:_SpyDB2                                                   *
      *      - This API will create a built-in spy routine on Db2      *
      *        calls. Once created, other spy API routines can be used *
      *        with the spy object to test situations.                 *
      *                                                                *
      * :TAG:_SpyIMS                                                   *
      *      - This API will create a built-in spy routine on IMS      *
      *        calls. Once created, other spy API routines can be used *
      *        with the spy object to test situations.                 *
      *                                                                *
      * :TAG:_SpyAIB                                                   *
      *      - This API will create a built-in spy routine on IMS/AIB  *
      *        calls. Once created, other spy API routines can be used *
      *        with the spy object to test situations.                 *
      *                                                                *
      * :TAG:_SpyMQ                                                    *
      *      - This API will create a built-in spy routine on MQ       *
      *        calls. Once created, other spy API routines can be used *
      *        with the spy object to test situations.                 *
      *                                                                *
      * :TAG:_SpyProgram                                               *
      *      - This API will create a built-in spy routine on program  *
      *        calls. Once created, other spy API routines can be used *
      *        with the spy object to test situations.                 *
      *                                                                *
      * :TAG:_SpySection                                               *
      *      - This API will create a built-in spy routine on section  *
      *        calls. Once created, other spy API routines can be used *
      *        with the spy object to test situations.                 *
      *                                                                *
      ******************************************************************
      *                      L O W - L E V E L   A P I                 *
      *                                                                *
      * These are the low-level APIs that allow a more granular        *
      * control over the processing. Usually these API calls are only  *
      * if a callback is preferred over the built-in spying logic. All *
      * low-level API calls start with :TAG:_LL.                       *
      *                                                                *
      ******************************************************************
      * :TAG:_LLRegisterSpy                                            *
      *      - This API will register the existence of a low-level spy *
      *        handler to be called during the interactions between    *
      *        the user program and any middleware or other user       *
      *        programs during a unit test. The recommended API calls  *
      *        for spy processing are the APIs that start with         *
      *        :TAG:_Spy_ and have the type as the suffix. These       *
      *        recommended spy routines provide built-in capabilities  *
      *        whereas the low-level spy routines leave all processing *
      *        up to the user.                                         *
      *                                                                *
      * :TAG:_LLDeregisterSpy                                          *
      *      - This API will de-register any previously registered     *
      *        low-level spy handler with the same function address.   *
      *                                                                *
      * :TAG:_LLFile                                                   *
      *      - This API will create a low-level file object block to   *
      *        be used by the unit test. The QSAM and VSAM control     *
      *        blocks may refer to this low-level file object block    *
      *        and it must be created prior to the low-level QSAM or   *
      *        VSAM mocking calls if the test case is to contain data  *
      *        provided data. Initial data can be provided to this API *
      *        to load records that are to be used for the unit test.  *
      *        Additionally or alternatively, the _LoadData API can be *
      *        used to load records for the unit test. If both methods *
      *        are used, then both sets of data are available in the   *
      *        test.                                                   *
      *                                                                *
      * :TAG:_LLMockQSAM                                               *
      *      - This API will create a QSAM (sequential file) low-level *
      *        mocking object that may refer to a previously created   *
      *        low-level file object.                                  *
      *                                                                *
      * :TAG:_LLMockKSDS                                               *
      *      - This API will create a VSAM/KSDS (keyed access)         *
      *        low-level mocking object that may refer to a previously *
      *        created low-level file object.                          *
      *                                                                *
      * :TAG:_LLMockESDS                                               *
      *      - This API will create a VSAM/ESDS (entry sequence        *
      *        access) low-level mocking object that may refer to a    *
      *        previously created low-level file object.               *
      *                                                                *
      * :TAG:_LLMockRRDS                                               *
      *      - This API will create a VSAM/RRDS (relative record       *
      *        access) low-level mocking object that may refer to a    *
      *        previously created low-level file object.               *
      *                                                                *
      * :TAG:_LLMockCICS                                               *
      *      - This API will create a CICS low-level mocking object.   *
      *                                                                *
      * :TAG:_LLMockDB2                                                *
      *      - This API will create a Db2 low-level mocking object.    *
      *        CAF calls are handled as well.                          *
      *                                                                *
      * :TAG:_LLMockIMS                                               *
      *      - This API will create an IMS low-level mocking object.   *
      *                                                                *
      * :TAG:_LLMockAIB                                                *
      *      - This API will create an IMS/AIB low-level mocking       *
      *        object.                                                 *
      *                                                                *
      * :TAG:_LLMockMQ                                                 *
      *      - This API will create an MQ low-level mocking object.    *
      *                                                                *
      ******************************************************************
