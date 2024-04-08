//ZTEALLOC JOB ACCT#,ZLDLINK,NOTIFY=&SYSUID,MSGLEVEL=(1,1)
//*-------------------------------------------------------------------*
//*
//*          Copyright (c) 2023 Broadcom. All Rights Reserved.
//* The term Broadcom refers to Broadcom Inc. and/or its subsidiaries.
//*
//*-------------------------------------------------------------------*
//*
//* THIS JCL WILL ALLOCATE THE TEST4Z INFRASTRUCTURE DATASETS
//*
//* STEPS TO PERFORM:
//*
//* 1. EDIT THE ABOVE JOBCARD ACCORDINGLY.
//*
//* 2. REPLACE $$HLQU WITH THE DESIRED USER DATASET PREFIX
//*    EXAMPLE: c $$HLQU MYPRFX ALL
//*
//* 3. REPLACE $$STOCL WITH THE CHOSEN STORAGE CLASS
//*    EXAMPLE: c $$STOCL TSO ALL
//*
//*-------------------------------------------------------------------*
//* THIS STEP DELETES THE DATASETS IF THEY ALREADY EXIST
//*-------------------------------------------------------------------*
//CRDEL    EXEC PGM=IDCAMS,REGION=0M
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
     DELETE $$HLQU.T4Z.TEST.LOAD
     DELETE $$HLQU.T4Z.ZLCOVER
     DELETE $$HLQU.T4Z.ZLDATA
     SET MAXCC=0
/*
//*-------------------------------------------------------------------*
//* THIS STEP ALLOCATES THE TEST.LOAD DATASET USED TO STORE UNIT TESTS
//*-------------------------------------------------------------------*
//CRUTEST  EXEC PGM=IEFBR14,REGION=0M
//SYSPRINT DD SYSOUT=*
//ZLUTEST  DD DSN=$$HLQU.T4Z.TEST.LOAD,DISP=(,CATLG,DELETE),
//            SPACE=(CYL,(10,5,50)),
//            DCB=(RECFM=U),
//            DSNTYPE=PDS,STORCLAS=$$STOCL
//*-------------------------------------------------------------------*
//* THIS STEP ALLOCATES THE CODE COVERAGE DATASET
//*-------------------------------------------------------------------*
//CRCOVER  EXEC PGM=IEFBR14,REGION=0M
//SYSPRINT DD SYSOUT=*
//ZLCOVER  DD DSN=$$HLQU.T4Z.ZLCOVER,DISP=(,CATLG,DELETE),
//            SPACE=(CYL,(10,5,10)),
//            DCB=(RECFM=FB,LRECL=120,BLKSIZE=32760),
//            DSNTYPE=PDS,STORCLAS=$$STOCL
//*-------------------------------------------------------------------*
//* THIS STEP ALLOCATES THE RECORDED DATA DATASET
//*-------------------------------------------------------------------*
//CREADSN  EXEC PGM=IEFBR14,REGION=0M
//SYSPRINT DD SYSOUT=*
//DATASET  DD DSN=$$HLQU.T4Z.ZLDATA,DISP=(,CATLG,DELETE),
//            SPACE=(CYL,(50,10,10)),
//            DCB=(RECFM=VB,LRECL=32756,BLKSIZE=32760),
//            DSNTYPE=PDS,STORCLAS=$$STOCL
