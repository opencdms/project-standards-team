$STORAGE:2
      SUBROUTINE ESCQUIT(*)
C
C       ** OBJECTIVE:  TRANSFER CONTROL TO SPECIFIED ALTERNATE RETURN
C                      STATEMENT IF ESCAPE OR F4 KEY IS ENTERED
C       
C       ** INPUT:
C             *.....STATEMENT NUMBER FOR ALTERNATE RETURN
C
      CHARACTER *2 INCHAR
C
C       ** DETERMINE IF A KEY HAS BEEN PRESSED
C
      CALL KEYCHK(KEYHIT)
      IF (KEYHIT.EQ.1) THEN
C
C          ** TRANSFER CONTROL TO ALTERNATE RETURN IF KEY IS ESC OR F4       
C
         CALL GETCHAR(1,INCHAR)
         IF (INCHAR.EQ.'4F') RETURN 1
      ENDIF
C
      RETURN
      END         