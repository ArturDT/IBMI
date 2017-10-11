000100170929     H/title TEST
000101170929     H**************************************************************************
000102170929     H*  TEST1     funkcje test
000103170929     H**************************************************************************
000104170929     H*  ************************* Change Log **********************************
000105170929     H*  Project ID   Pgmr   Date        Project Description
000106170929     H*  -----------  ----  ----------   ---------------------------------------
000107171005     H*  TEST         ADO   2017/09/29   Create member
000108170929     H*  -----------  ----  ----------   ---------------------------------------
000109170929     H**************************************************************************
000110171002       ctl-opt option(*srcstmt:*nodebugio) debug(*yes)
000111171002        bnddir('TESTBIND') ;
000114170929
000115170929      /DEFINE TEST1_TMP
000116170929      /DEFINE TEST1_FUN
000118170929      /COPY TESTSOURCE,TEST1P
000119171006      /DEFINE PGM_STATUS
000120171006      /DEFINE ERROR_TMP
000121171006      /COPY TESTSOURCE,ERRORP
000122171006
000123170929
000124170929       // data structures declaration:
000125170929       dcl-s outData like(test_p) ;
000126170929
000127170929       // variables declaration:
000128170929       dcl-s x int(5);
000129170929       dcl-s charIN char(26);
000130170929
000131171005       Monitor;
000132171005        IF TEST_FUNCTION(charIN:outData);
000133171005          //Do some
000134171005        ENDIF;
000135171005       On-Error;
000136171006        SAVE_ERROR(pgmstatus);
000137171005        Select;
000138171005         when errmsgID = '';
000139171005           //Do some
000140171005         Other;
000141171005           //Do some
000142171005        ENDSL;
000143171005       EndMon;
000144171005
000145170929
000146170929       return;
