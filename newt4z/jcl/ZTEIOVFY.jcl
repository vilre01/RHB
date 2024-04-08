//ZTEIOVFY JOB ACCT#,ZLDLINK,NOTIFY=&SYSUID,MSGLEVEL=(1,1)
//*-------------------------------------------------------------------*
//*
//*          Copyright (c) 2023 Broadcom. All Rights Reserved.
//* The term Broadcom refers to Broadcom Inc. and/or its subsidiaries.
//*
//* THIS JCL WILL RUN A VERIFY ON A SAMPLE PROGRAM THAT USES FILE I/O.
//*
//*-------------------------------------------------------------------*
//*
//* STEPS TO PERFORM:
//*
//* 1. EDIT THE ABOVE JOBCARD ACCORDINGLY.
//*
//* 2. REPLACE $$HLQI WITH HIGH LEVEL QUALIFIER FOR TEST4Z INSTALLATION
//*    EXAMPLE: c $$HLQI T4Z.HLQ ALL
//*
//* 3. REPLACE $$HLQU WITH HIGH LEVEL QUALIFIER FOR TEST4Z USER DATASETS
//*    EXAMPLE: c $$HLQU MYPRFX all
//*
//* 4. REPLACE $$MYLL WITH NAME OF LOAD LIBRARY CONTAINING USER MODULES
//*    EXAMPLE: c $$MYLL MYPRFX.MY.LOADLIB all
//*
//* 5. REPLACE $$PGM WITH THE NAME OF THE DESIRED COBOL PROGRAM.
//*    EXAMPLE: c $$PGM MYPROGRM ALL
//*
//*-------------------------------------------------------------------*
//         EXEC PGM=ZTESTEXE,REGION=0M
//STEPLIB  DD DISP=SHR,DSN=$$HLQI.CT4ZLOAD
//         DD DISP=SHR,DSN=$$MYLL
//ZLDATA   DD DISP=SHR,DSN=$$HLQU.T4Z.ZLDATA
//ZLCOVER  DD DISP=SHR,DSN=$$HLQU.T4Z.ZLCOVER
//ZLMSG    DD SYSOUT=*
//SYSOUT   DD SYSOUT=*
//*-------------------------------------------------------------------*
//* DEFINE ANY FILES USED BY THE USER APPLICATION PROGRAM
//*-------------------------------------------------------------------*
//*MYFILE  DD DISP=SHR,DSN=$$HLQU.TEST4Z.QSAM
//*
//ZLOPTS   DD *
RUN($$PGM),VERIFY
COVERAGE
/*
//CEEOPTS  DD *
TRAP(ON,NOSPIE)
/*
