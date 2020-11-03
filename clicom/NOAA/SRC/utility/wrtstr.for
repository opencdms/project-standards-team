$STORAGE:2

      SUBROUTINE WRTSTR(FIELD,FLDLEN,FGCOLOR,BGCOLOR)
C
C   ROUTINE TO WRITE A STRING IN ANY FORGROUND OR BACKGROUND COLORS
C
      INTEGER*2 FLDLEN,FGCOLOR,BGCOLOR
      CHARACTER*1 FIELD(FLDLEN)
      LOGICAL FRSTCL
      DATA FRSTCL /.TRUE./
C
C   ON FIRST CALL TO THIS ROUTINE SET TEXT FOR COLOR OR B&W MODE
C
      IF (FRSTCL) THEN
         FRSTCL = .FALSE.
         CALL STATUS(IMODE,ICLTYP,IPAGE)
      END IF
      IFG = FGCOLOR
      IBG = BGCOLOR
      IF (IMODE.NE.3) THEN
         IF (BGCOLOR.EQ.1) THEN
            IFG = 1
            IBG = 0
         ELSE IF (FGCOLOR.EQ.12.OR.BGCOLOR.EQ.4) THEN
            IBG = 7
            IFG = 0
         ELSE IF (FGCOLOR.EQ.14) THEN
            IBG = 0
            IFG = 15
         END IF
      END IF
C
      CALL POSLIN(JROW,JCOL)
      DO 100 I1 = 1,FLDLEN
         CALL CHRWRT(FIELD(I1),IBG,IFG,1)
         IF (JCOL+I1.LE.79) THEN
            CALL LOCATE(JROW,JCOL+I1,IERR)      
         END IF
100   CONTINUE
      RETURN
      END
