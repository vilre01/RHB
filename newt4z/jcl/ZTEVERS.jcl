//ZTEVERS JOB ACCT#,ZLDLINK,NOTIFY=&SYSUID,MSGLEVEL=(1,1)
//*-------------------------------------------------------------------*
//*
//*          Copyright (c) 2023 Broadcom. All Rights Reserved.
//* The term Broadcom refers to Broadcom Inc. and/or its subsidiaries.
//*
//*-------------------------------------------------------------------*
//*
//* This JCL is printing the version of Test4z runtime.
//*
//*-------------------------------------------------------------------*
//*
//* Steps to perform:
//*
//* 1. Edit the above jobcard accordingly.
//*
//* 2. Replace $$T4Z with high level qualifier for Test4z installation.
//*    Example: C $$T4Z TEST4Z.HLQ ALL
//*
//*-------------------------------------------------------------------*
//         EXEC PGM=ZTESTVI
//STEPLIB  DD DISP=SHR,DSN=$$T4Z.CT4ZLOAD
//SYSOUT   DD SYSOUT=*
