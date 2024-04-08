//ZTEDLVFY JOB ACCT#,ZLDLINK,NOTIFY=&SYSUID,MSGLEVEL=(1,1)
//*-------------------------------------------------------------------*
//*
//*          Copyright (c) 2023 Broadcom. All Rights Reserved.
//* The term Broadcom refers to Broadcom Inc. and/or its subsidiaries.
//*
//*-------------------------------------------------------------------*
//*
//* THIS JCL WILL RUN A VERIFY ON A SAMPLE PROGRAM THAT USES IMS.
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
//* 5. REPLACE $$IMS WITH THE PREFIX OF YOUR IMS INSTALLATION
//*    EXAMPLE: c $$IMS IMSSYS15 ALL
//*
//* 6. REPLACE $$PGM WITH THE NAME OF THE DESIRED COBOL PROGRAM.
//*    EXAMPLE: c $$PGM MYPROGRM ALL
//*
//* 7. REPLACE $$PSB WITH THE NAME OF THE PSB TO USE
//*    EXAMPLE: c $$PSB MYPSB ALL
//*
//*-------------------------------------------------------------------*
//RUN      EXEC PGM=DFSRRC00,PARM='DLI,ZTESTEXE,$$PSB',REGION=0M
//STEPLIB  DD DISP=SHR,DSN=$$HLQI.CT4ZLOAD
//         DD DISP=SHR,DSN=$$MYLL
//         DD DISP=SHR,DSN=$$IMS.SDFSRESL
//ZLDATA   DD DISP=SHR,DSN=$$HLQU.T4Z.ZLDATA
//ZLCOVER  DD DISP=SHR,DSN=$$HLQU.T4Z.ZLCOVER
//DFSRESLB DD DISP=SHR,DSN=$$IMS.SDFSRESL
//DFSPRINT DD SYSOUT=*,DCB=(BLKSIZE=605,LRECL=121,RECFM=FBA)
//IMS      DD DISP=SHR,DSN=$$HLQI.CT4ZLOAD
//         DD DISP=SHR,DSN=$$MYLL
//*-------------------------------------------------------------------*
//* DEFINE ANY REQUIRED DATASET DD STATEMENTS
//*-------------------------------------------------------------------*
//*MYDB    DD DISP=SHR,DSN=$$HLQU.TEST4Z.LIBDB
//*
//IEFRDER  DD DSNAME=&&RDER,DISP=(,KEEP),
//            UNIT=SYSDA,SPACE=(CYL,(2,2))
//ZLMSG    DD SYSOUT=*
//SYSOUT   DD SYSOUT=*
//DFSVSAMP DD *
POOLID=DFLT
VSRBF=512,4
VSRBF=2048,5
VSRBF=4096,12
/*
//ZLOPTS   DD *
RUN($$PGM),VERIFY
COVERAGE
/*
//CEEOPTS  DD *
TRAP(ON,NOSPIE)
/*
