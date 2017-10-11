000100171005      /title TEST ERROR MODULE
000101171005      //************************************************************************
000102171005      // TEST1     funkcje test
000103171005      //************************************************************************
000104171005      // ************************* Change Log **********************************
000105171005      // Project ID   Pgmr   Date        Project Description
000106171005      // -----------  ----  ----------   ---------------------------------------
000107171005      // TEST         ADO   2017/10/05   Create member
000108171005      // -----------  ----  ----------   ---------------------------------------
000109171005      //************************************************************************
000110171006       ctl-opt nomain debug(*yes);
000111171006      /DEFINE PGM_STATUS
000112171006      /DEFINE ERROR_TMP
000113171006      /COPY TESTSOURCE,ERRORP 
000116171005
000117171006       dcl-pr getID zoned(10:0) end-pr;
000120171006
000123171006       dcl-proc SAVE_ERROR export;
000124171006         dcl-pi *n ind;
000125171006          error_in likeDS(pgmstatus) const;
000126171006         end-pi;
000127171006         dcl-f ERRORLOG DISK usage(*output) usrOpn keyed;
000128171006         dcl-ds error_rec likerec(ERROR: *output);
000130171006
000131171006         error_rec.ID_ERROR = getID();
000132171006         error_rec.time = %timestamp();
000133171006         error_rec.ERROR_PGM  = error_in.progname;
000134171006         error_rec.ERROR_TYPE = error_in.errmsgID;
000135171006         error_rec.ERROR_INFO = 'parms: ' + %CHAR(error_in.parms) +
000136171006                                ' errmsg: ' + error_in.errmsg +
000137171006                                ' jobnumber: ' + %char(error_in.jobnumber);
000138171006         if error_rec.ID_ERROR > 0;
000139171006           if not %open(ERRORLOG);
000140171006             open(e) ERRORLOG;
000141171006             if %error;
000142171006               return *off;
000143171006             endif;
000144171006           endif;
000145171006           write(e) ERROR error_rec;
000146171006           if %error;
000147171006             return *off;
000148171006           else;
000149171006             return *on;
000150171006           endif;
000151171006         else;
000152171006           return *off;
000153171006         endif;
000154171006
000155171006       end-proc;
000156171006
000157171006       dcl-proc getID;
000158171006         dcl-pi *n zoned(10:0) end-pi;
000159171006          dcl-f ERRORLOG DISK usage(*input) usrOpn keyed static;
000160171006          dcl-ds ErrorDS likerec(ERROR: *input) ;
000161171006          if not %open(ERRORLOG) ;
000162171006            open(e) ERRORLOG ;
000163171006            if %error;
000164171006              return 0;
000165171006            endif;
000166171006          endif;
000167171006          setgt(e) *HIVAL ERRORLOG;
000168171006          readp(e) ERRORLOG ErrorDS;
000169171006          if %error or %eof(ERRORLOG);
000170171006            return 1;
000171171006          else;
000172171006            return (ErrorDS.ID_ERROR + 1);
000175171006          endif;
000176171006       end-proc;
000177171005
000178171005
