$STORAGE:2
C      PROGRAM CHKRONLY
C
C     THE PURPOSE OF THIS PROGRAM CHECKS THE USER'S CONFIG.SYS AND AUTOEXEC.BAT
C     FILES.  THE FILES HAVE TO BE IN THE ROOT DIRECTORY OF HARD DISK.  THE
C     PROGRAM READS COMMAND LINE PARAMTERS AND CHECK THE FILE IS READ-ONLY OR
C     NOT.  IF THE FILE IS A READ-ONLY FILE,IT SETS ERRORLEVEL TO 7.  IF THE
C     FILE IS NOT FOUND,IT SETS ERRORLEVEL TO 8.  IF THE FILE IS READ ERROR,IT
C     SETS ERRORLEVEL TO 9.  OTHERWISE, IT SETS ERRORLEVEL TO 0.
C
C     THIS PROGRAM MUST BE PASSED ONLY THE FILE NAME ON THE COMMAND LINE
C     EXAMPLE: "CHKRONLY CONFIG.SYS"
C
C
      INTERFACE TO SUBROUTINE CMDLIN2(ADDRES,LENGTH,RESULT)
      INTEGER*4   ADDRES[VALUE],LENGTH[VALUE]
      CHARACTER*1 RESULT
      END
C
C
      PROGRAM CHKRONLY
C
      CHARACTER*40 FILENAME,FILEIN
      CHARACTER*64 RESULT
      INTEGER*4    PSP, PSPNCHR, OFFSET
C
C     *** LOCATE SEGMENTED ADDRESS OF THE BEGINNING OF THIS PROGRAM
C
      OFFSET = #00100000
      PSP = LOCFAR(CHKRONLY)
C
C     *** COMPUTE THE BEGINNING OF THE PROGRAM SEGMENT PREFIX (PSP)
C
      PSP = (PSP - MOD(PSP,#1000)) - OFFSET
C
C     *** LOCATE THE POSITION OF COMMAND PARAMETERS WITHIN PSP
C
      PSPNCHR = PSP + #80
      PSP = PSP + #81
C
C     *** PASS THE ADDRESS OF THE COMMAND PARAMETERS TO CMDLIN2 WHICH DECODES
C         THE COMMAND AND RETURNS IT AS RESULT.
C
      RESULT = ' '
      CALL CMDLIN2(PSP,PSPNCHR,RESULT)
C
C     *** PULL THE COMMANDS OUT OF THE RESULT
C
      DO 20 L=1,40
         IF (RESULT(L:L) .NE. ' ') THEN
            FILENAME = RESULT(L:40)
            GO TO 30
         ENDIF
  20  CONTINUE
C
  30  CONTINUE
      NLNG = LNG(FILENAME)
      FILEIN = 'C:\'//FILENAME(1:NLNG)
      OPEN (75,FILE=FILEIN,STATUS='OLD',FORM='FORMATTED',MODE='WRITE'
     +      ,IOSTAT=IOCHK)
      IF (IOCHK.EQ.6414) THEN
         CLOSE(75)
         STOP 7
      ELSE IF (IOCHK.EQ.6416) THEN
         STOP 8
      ELSE IF (IOCHK.NE.0) THEN
         STOP 9
      END IF
C      
      STOP ' '
      END
