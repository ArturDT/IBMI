000100160728      *********************************************************************************************
000200161028      *? APXSZABLON Us³uga szablonowa dla powerExt                                               ?*
000300160804      * ?Autor   : Artur Dobrzanski                                                              ?*
000400161028      * ?Data    : 2016.10.28                                                                    ?*
000500161028      * ?Projekt : NPXXXX                                                                        ?*
000600160728      *--------------------- CHANGE LOG ----------------------------------------------------------*
000700160728      *? Project ID  Pgmr    Date     Project Description                                        ?*
000800160728      *??XXXXXXXXXX  XXX  XXXXXXXXXX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                   ?*
000900160728      *********************************************************************************************
001700160728     H DEBUG(*YES) OPTION(*NODEBUGIO)
001800160728     H DATEDIT(*YMD)
001900160728     H COPYRIGHT('Copyright BZWBK')
002000160728
002100160728   ?  **********************************************************************
002200160728   ?  * copybooks                                                          *
002300160728   ?  **********************************************************************
002400160728      *?powerEXT API Connectors
002500160728       /copy apxsorc,pxapihdr        General H-Spec's
002600160728       /copy apxsorc,pxapicgicn      Basic HTTP connecter & Basic Services
002700160728      *?Prototypy funkcji dodatkowych:
002800160728       /copy APSSORC,APS0549P
002900160728     ?**********************************************************************
003000160728     ?* Deklaracje plików                                                  *
003100160728     ?**********************************************************************
003200161028?    FNAZWAPLIK IF   E           K DISK    USROPN
003300160728     ?**********************************************************************
003400160728     ?* Deklaracje zmiennych i struktur                                    *
003500160728     ?**********************************************************************
003800160728      *?struktury:
003801160728     ?**********************************************************************
003901161028    ?D BufIn         E DS                  extname(APXBXXX01) qualified         TODO - wskazac pliki
004000161028    ?D BufOut        E DS                  extname(APXBXXX02) qualified         ze strukturami I/O
004001161028     D                                     Dim(cArrLen)
004200161028     D BufErr        E DS                  extname(ANFB00102) qualified
004300161028      *?zmienne globalne:
004400160728     D ilZwRek         S              4S 0                                      il zwróconych rekord
004500160802      *?stale:
004600161028    ?D cArrLen         C                   const(99)                            Max ilosc zwracanych
004601161028  ?  D nazwaProg       C                   const('APXSZABLON')                  Nazwa programu
004700160728
004704161107      *?Definicje struktur dla logowania
004705161028      /COPY APXSORC,APXL001P
004713160804
004800160728     ?**********************************************************************
004900160804     ?* Procedura glówna                                                   *
005000160728     ?**********************************************************************
005100160728      /free
005200161028         if Inicjalizuj();     //?Inicjalizacja + otwarcie plików - w przypadku bledu zwraca *off
005300160728           getInData();          //?pobranie danych xml
005400160728           xmlToBufIn();         //?mapowanie z xml do struktury BufIn
005500161028           if chkBufIn();        //?sprawdzanie poprawnoøci danych wejøciowych - gdy blad to *off
005600160728             biznesLogic();        //?logika biznesowa (na podstawie BufIn generuje Bufout)
005700160728             BufOutToXml();        //?mapowanie ze struktury BufOut do xml
005800160728           else;
005900161028             ErrorToXml();         //?zwróæ komunikat bledu
006000160728           endif;
006100160728         else;
006200160728           ErrorToXml();
006300160728         endif;
006400160728         return;
006500160728
006600160728     ?* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
006700160728     ?*?  FUNKCJA    -   biznesLogic                                                          ?   *
006800161028     ?*?  OPIS       -   Logika biznesowa uslugi - wypelnienie struktury BufOut (dane wyjsciowe) ?*
006900160728     ?* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
007000160728     P biznesLogic     B
007100160728
007101161028?    D indeks          S              4S 0
007300160728      *--------------------------------------------------------------------------------------------
007400160728      /FREE
007403161028?       indeks = 1;                       //?Wypelnianie struktury BufOut za pomoca petli
007407161028?       DoW indeks < cArrLen+1;             //?Wypelnianie moze odbywac sie w sposob dowolny -
007408161028?         // odczyt                           //?zaleznie od preferencji programisty
007409161028?         indeks += 1;
007425161028?       EndDo;
007426161028?       Log.stage = 'zakonczono odczyt';  //?logowanie
007427161028?       logger(Log);                      //?logowanie
008400161028?       ilZwRek = indeks - 1;             //?ile rekordow usluga ma do zwrocenia?
008500160728      /END-FREE
008600160728      *--------------------------------------------------------------------------------------------
008700160728     P                 E
008800160728
008900160728     ?* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
009000160728     ?*?  FUNKCJA    -   Inicjalizuj                                                          ?   *
009100160728     ?*?  OPIS       -   Inicjalizacja - czyli czyszczenie zmiennych oraz otwarcie plików     ?   *
009200160728      *?                 W przypadku wystØpienia b²ùdu zwraca *Off                               ?*
009300160728     ?* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
009400160728     P Inicjalizuj     B
009500160728     D                 PI              N
009600160728
009700160728      *--------------------------------------------------------------------------------------------
009800160728      /FREE
009801161028         clear Log;
009802161028         Log.pgmName = nazwaProg;                            //?wiecej o logowaniu na orsite:
009803161028         Log.jobId = uniqueKey();                            //?PowerExt - logowanie
009805161028         Log.loglvl = #info;
009806161110         Log.stage = 'start uslugi';
009807161028         logger(Log);
009808160804
009900160728         clear BufIn;
010000160728         clear BufOut;
010100160728         clear BufErr;
010200160728
010400161028?        if not %open(NAZWAPLIK);                            //?warunek if-endif powielamy dla
010500161028?          open(e) NAZWAPLIK;                                //?kazdego pliku, z ktorego usluga
010600161028           If %error();  //?Blad otwarcia NAZWAPLIK          //?korzysta. Nalezy zmienic NAZWAPLIK
010601161028?            Log.stage = 'b³¹d otwarcia pliku NAZWAPLIK';    //?na wlasciwa nazwe pliku
010602161028             Log.loglvl = #warn;
010603161028             logger(Log);
010700161028?            BufErr.ANFERID = 'numerBledu';                  //?ID komunikatu bledu
010800161028?            BufErr.ANFERDS = 'NAZWAPLIK';                   //?Komunikat bledu
010900161028             return *Off;
011000160728           EndIf;
011100160728         endif;
011101161028
011200161028         Log.stage = 'otwarto poprawnie pliki';              //?wiecej o logowaniu na orsite:
011301161028         logger(Log);                                        //?PowerExt - logowanie
011400160728         return *On;
011500160728      /END-FREE
011600160728      *--------------------------------------------------------------------------------------------
011700160728     P                 E
011800160728
011900160728     ?* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
012000160728     ?*?  FUNKCJA    -   chkBufIn                                                             ?   *
012100161028     ?*?  OPIS       -   Weryfikacja poprawnosci danych wejeciowych oraz przypisanie domyslnych  ?*
012200161028      *?                 W przypadku wystapienia bledu zwraca *Off                              ? *
012300160728     ?* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
012400160728     P chkBufIn        B
012500160728     D                 PI              N
012700160728
012800160728      *--------------------------------------------------------------------------------------------
012900160728      /FREE
012926161028  ?     // TODO  - walidacje pol wejsciowych
014600160728        return *On;
014700160728      /END-FREE
014800160728      *--------------------------------------------------------------------------------------------
014900160728     P                 E
015000160728     ?* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
015100160728     ?*?  FUNKCJA    -   xmlToBufIn                                                           ?   *
015200160728     ?*?  OPIS       -   Pobieranie parametrów wejøciowych us²ugi i zapis do struktury BufIn  ?   *
015300160728     ?* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
015400160728     P xmlToBufIn      B
015500160728
015600160728      *--------------------------------------------------------------------------------------------
015700160728      /FREE
015800161028          //?czytaj zawartosc XML tak dlugo az nie osiagniesz konca
015801161028        Log.stage = 'rozpoczynam odczytawanie bufora wejsciowego';
015802161028        logger(Log);
015900161104        DoW xmlReader() = 0;
016000161104         If xmlGetNodeType()='D' and %subst(xmlGetNode():1:1) <> '%';
016542161028           Select;
016543161104?            When %scan('objectSourceSystem':xmlGetNode()) > 0;    //?pobranie pola numerycznego
016544161104 ?             BufIn.OBJSRCSYS  = xmlGetDataNum();
016545161104 ?           When %scan('objectNumber':xmlGetNode()) > 0;          //?pobranie poal tekstowego
016546161104 ?             BufIn.OBJNUMER   = xmlGetData();
016547161104 ?           When %scan('kolejnePole':xmlGetNode()) > 0;  //?Dla kazdego pola wejsciowego
016548161104 ?             BufIn.pole       = xmlGetData();           //?nalezy dodac odpowiedni 'WHEN'
016549161028           EndSl;
017000160728         EndIf;
017100160728        EndDo;
017101161028        Log.stage = 'zakonczono odczytawanie bufora wejsciowego';
017102161028        logger(Log);
017200160728      /END-FREE
017300160728      *--------------------------------------------------------------------------------------------
017400160728     P                 E
017500160728
017600160728     ?* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
017700160728     ?*?  FUNKCJA    -   BufOutToXml                                                          ?   *
017800160728     ?*?  OPIS       -   Zapis struktury BufOut do xml                                        ?   *
017900160728     ?* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
018000160728     P BufOutToXml     B
018100160728
018200160728     D acctInd         S              4S 0                                      aktualny indeks
018300160728      *--------------------------------------------------------------------------------------------
018400160728      /FREE
018401161028        Log.stage = 'rozpoczynam tworzenie dokumentu xml - wyjsciowego';
018402161028        logger(Log);
018500160728        setContent('text/xml');
018600160728        xmlNode('response');
018700160728        //?mapuj dane ze struktury bufOut do XML:
018800161028        if ilZwRek = 0;     //?zwracanie 'pustego' elementu w przypadku braku danych do zwrocenia
018900161028          xmlNode('listElement');
019100161028          xmlEndNode('listElement');
019101161028          xmlNode('licznik':'':'1');
019200160728        else;
019300161028          xmlNode('licznik':'':%CHAR(ilZwRek));  //?zwracamy licznik
019400160728          acctInd = 1;
019500160728          DoW acctInd <= ilZwRek;
019700161028 ?          xmlNode('Encja_X');                                //?<Encja_X>
019701161028 ?            xmlNode('Obiekt_X':'':BufOut(acctInd).POLE);     //?  <Obiekt_X> dana </Obiekt_X>
020700161028 ?          xmlEndNode('Encja_X');                             //?</Encja_X>
020900160728            acctInd += 1;
021000160728          EndDo;
021100160728        endif;
021200160728
021300160728        xmlEndNode('response');
021301161028        Log.stage = 'zakonczono tworzenie dokumentu xml - wyjsciowego';
021302161028        logger(Log);
021400161028        //?zakonczenie programu:
021500160728        echoToClient();
021600160728      /END-FREE
021700160728      *--------------------------------------------------------------------------------------------
021800160728     P                 E
021900160728
022000160802?     *====================================================================================
022100160802?     *?Procedury PowerExt - takie same dla wszystkich us²ug PowerExt: ?                 ?*
022200160802?     *====================================================================================
022300160804      /copy APXSORC,APXPROCED
