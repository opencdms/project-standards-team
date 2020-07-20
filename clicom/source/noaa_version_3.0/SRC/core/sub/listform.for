$STORAGE:2
C
      INTERFACE TO INTEGER*2 FUNCTION SYSTEM [C]
     +      (STRING [REFERENCE])
      CHARACTER*1 STRING
      END
C-----------------------------------------------------------------
C
      SUBROUTINE LISTFORM
C
C   ROUTINE TO LIST DATA ENTRY FORM DEFINITIONS IN ALPABETICAL ORDER
C   THE ROUTINE ASKS FOR VERIFICATION BEFORE IT BEGINS
C
      CHARACTER*78 COMMAND
      CHARACTER*22 TMPFIL
      CHARACTER*22 FILENAME
      CHARACTER*16 DDISK
      CHARACTER*8 FRMNAM
      CHARACTER*2 RDISK
      CHARACTER*1 REPLY,RTNCODE
      INTEGER*2 FRMWID,FRMHT,SYSTEM
      INTEGER*2 NCHAR(80,23),FGCOLOR(80,23),BGCOLOR(80,23)
      LOGICAL BORDER
C
$INCLUDE: 'FRMFLD.INC'
C
C   ASK FOR VERIFICATION BEFORE CONTINUING
C
      CALL WRTMSG(3,301,12,1,0,' ',0)
      CALL CLRMSG(2)
      CALL LOCATE(23,1,IERR)
      CALL OKREPLY(REPLY,RTNCODE)        
      CALL CLRMSG(3)
      CALL CLRMSG(2)        
      IF (REPLY.EQ.'N'.OR.RTNCODE.EQ.'1') THEN
         RETURN
      END IF
C
C    FIND AND SORT THE CURRENT FORM NAMES AND SAVE RESULTS ON DISK
C
         LEND = 2
         CALL GETDSC(RDISK,DDISK,LEND)
C          .. NOTE: A 'C' STRING IS PUT INTO VARIABLE COMMAND.  IN A 'C'
C             STRING A SLASH(\) IS REPRESENTED BY \\.  THEREFORE IN THE
C             STRING BELOW THE \\ ONLY TAKE UP ONE CHARACTER POSITION.      
         COMMAND = 'DIR P:\\FORM\\*.FRM |SORT >   \\DATA\\TEMP.DAT'C
         COMMAND(27:28) = RDISK
         I = SYSTEM (COMMAND)
C
C   OPEN THE SORTED FORM NAMES AND THE PRINTER OUTPUT FILE
C
      TMPFIL = '  \DATA\TEMP.DAT'
      TMPFIL(1:2) = RDISK
      OPEN(50,FILE='PRN',STATUS='UNKNOWN',FORM='FORMATTED')
  50  CONTINUE
      OPEN(60,FILE=TMPFIL,STATUS='OLD',FORM='FORMATTED'
     +   ,IOSTAT=IOCHK)
      IF(IOCHK.NE.0) THEN
         CALL OPENMSG(TMPFIL,'LISTFORM    ',IOCHK)
         GO TO 50
      END IF   
C
C     ** GET VERSION OF DOS ( DETERMINE THE NUMBER OF LINES NEED TO SKIP
C        BEFORE READ THE FORM NAME IN THE SORTED FILE 'P:\DATA\TEMP.DAT' )
C
      CALL DOSVER(MAJVER,MINVER)
      IF (MAJVER.GE.4) THEN
         NUMLINE = 6
      ELSE
         NUMLINE = 5
      END IF
      DO 80 I = 1,NUMLINE
         READ(60,120,END=900)
   80 CONTINUE
C
C   LIST THE FORMS IN ALPHABETICAL ORDER
C
      WRITE(*,*) '  ** Printing CLICOM FORTRAN Forms **  '
      WRITE(50,118)
  118 FORMAT(1H1,31X,'CLICOM FORTRAN Forms',/,1X,80('�'),/)            
      ILINE = 4
      IPAGE = 1
C
      DO 500 K = 1,999
C
C   READ THE FORM NAME FROM THE SORTED FILES AND USE IT TO GET
C   AND READ THE FORM DEFINITION FILE
C
         READ(60,120,END=600) FRMNAM
  120    FORMAT(A8)
         FILENAME = 'P:\FORM\AAAAAAAA.FRM'
         FILENAME(9:16) = FRMNAM
  125    CONTINUE
         OPEN(15,FILE=FILENAME,STATUS='OLD',FORM='UNFORMATTED'
     +      ,IOSTAT=IOCHK)
         IF(IOCHK.NE.0) THEN
            CALL OPENMSG(FILENAME,'LISTFORM    ',IOCHK)
            GO TO 125
         END IF   
         DO 130 I1 = 8,1,-1
            IF (FRMNAM(I1:I1).NE.'A') THEN
               GO TO 140
            ELSE
               FRMNAM(I1:I1) = ' '
            END IF
  130    CONTINUE
  140    CONTINUE
         WRITE(*,*) 'Printing - ',FRMNAM
         READ(15) FRMHT,FRMWID,BORDER
         READ(15) ((NCHAR(I,J),BGCOLOR(I,J),FGCOLOR(I,J),J=1,FRMHT),
     +            I=1,FRMWID)
$INCLUDE: 'RDFLDS.INC'
         CLOSE(15)
         CALL PRTFRM(FRMNAM,FRMHT,FRMWID,NCHAR,ILINE,IPAGE)
C
  500 CONTINUE
  600 CONTINUE
      CLOSE(50)
      CLOSE(60,STATUS='DELETE')
      RETURN
C
C       ** ERROR -- REACH THIS POINT IF THE INPUT FILE IS EMPTY
C 
  900 CALL WRTMSG(3,198,12,1,1,'TEMP.DAT',8)
C
      CLOSE(50)
      CLOSE(60,STATUS='DELETE')
      RETURN
      END
