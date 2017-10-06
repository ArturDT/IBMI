000100171006      *^   TEST1P - (Prototypes for TEST1M)
000101171006      *^
000102171006      *^  ************************** Change Log ***************************
000103171006      *^  Project ID  Pgmr   Date       Project Description
000104171006      *^   TEST       ADO    06/10/17   Create object
000105171006      *^  ************************** Change Log ***************************
000106171006
000107171006         // *****************************************************************
000108171006         // Structure templates:
000109171006         // *****************************************************************
000110171006          /IF Defined (PGM_STATUS)
000111171006           dcl-ds pgmstatus PSDS;
000112171006             progname  CHAR(10)   POS(1);
000113171006             parms     zoned(3:0) POS(37);
000114171006             errmsgID  CHAR(6)    POS(40);
000115171006             errmsg    CHAR(80)   POS(91);
000116171006             library   CHAR(10)   POS(81);
000117171006             jobname   CHAR(10)   POS(244);
000118171006             userid    CHAR(10)   POS(254);
000119171006             jobnumber zoned(6:0) POS(264);
000120171006           end-ds;
000121171006         /ENDIF
000122171006
000123171006         /If Defined (ERROR_TMP)
000127171006           dcl-ds ERROR_DS extname('ERRORLOG') qualified template end-ds;
000130171006
000131171006         // *****************************************************************
000132171006         // Function prototypes:
000133171006         // *****************************************************************
000134171006
000136171006           dcl-pr SAVE_ERROR ind;
000137171006              *n likeds(pgmstatus) const;
000139171006           end-pr;
000140171006         /ENDIF
