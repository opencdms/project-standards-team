$STORAGE:2
      SUBROUTINE GTRECNBR(RTNCODE)
C      
      CHARACTER*24 STNABRV,LSTABRV
      CHARACTER*20 COUNTRY
      CHARACTER*8  STNID,LSTID
      CHARACTER*8 INLON
      CHARACTER*7 INLAT
      CHARACTER*1 RTNCODE
      INTEGER*4 BDATE,EDATE,NRECG
      LOGICAL RDLST,RDGEOG,FOUND
C
      RTNCODE='0'        
C
C  OPEN THE STNGEOG.INF FILE AND INITIALIZE
C
20    OPEN (35,FILE='P:\DATA\STNGEOG.INF',STATUS='OLD',
     +      ACCESS='DIRECT',RECL=80,SHARE='DENYWR',MODE='READ'
     +      ,IOSTAT=IOCHK)
      IF (IOCHK.NE.0) THEN
         CALL OPENMSG('P:\DATA\STNGEOG.INF   ','GRAFINIT    ',IOCHK)
         GO TO 20
      END IF
      READ(35,REC=1) NRECG
C
      READ(51,REC=1) NRECL      
C
      RDLST  = .TRUE.
      RDGEOG = .TRUE.
      FOUND  = .FALSE.
      IGREC  = 1
      LRECOUT= 1
C
      DO 100 LRECIN=2,NRECL+1
         READ(51,REC=LRECIN) IDUM,LSTID,LSTABRV
         RDLST=.FALSE.
   30    CONTINUE
         IF (RDGEOG) THEN
            IGREC=IGREC+1
            IF (IGREC.GT.NRECG) THEN
               CALL WRTMSG(3,382,12,0,0,'  STNGEOG.INF',13)
               CALL WRTMSG(2,550,12,1,1,LSTID,8)
               RTNCODE='1'
               GO TO 102
            ENDIF
            READ(35,REC=IGREC) STNID,BDATE,EDATE,STNABRV,
     +                           COUNTRY,INLAT,INLON
            RDGEOG=.FALSE.
         ENDIF   
         IF (STNID.LT.LSTID) THEN
            RDGEOG=.TRUE.
         ELSE IF (STNID.EQ.LSTID) THEN
            FOUND = .TRUE.
            RDGEOG=.TRUE.
            LSTABRV = STNABRV
            IGRECSV = IGREC
         ELSE 
C             .. STATION ID IN STNGEOG.INF IS GREATER THAN STATION ID IN LIST
            IF (FOUND) THEN
               LRECOUT=LRECOUT+1
               WRITE(51,REC=LRECOUT) IGRECSV,LSTID,LSTABRV
               FOUND = .FALSE.
            ELSE   
               CALL WRTMSG(2,588,12,1,1,LSTID,8)
               RTNCODE='1'
            ENDIF   
            RDLST=.TRUE.
         ENDIF
         IF (.NOT.RDLST) GO TO 30      
  100 CONTINUE
  102 CONTINUE
      IF (FOUND) THEN
         LRECOUT=LRECOUT+1
         WRITE(51,REC=LRECOUT) IGRECSV,LSTID,LSTABRV
      ENDIF   
      WRITE(51,REC=1) LRECOUT-1
      CLOSE(35)
      RETURN
      END         