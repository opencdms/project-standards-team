$STORAGE:2
C
      PROGRAM INVENFIL
C
C     THE PURPOSE OF THIS PROGRAM IS TO PREVENT THE DATA FROM BEING LOADED 
C     INTO DATAEASE IF THE PROGRAM IS NOT RUN.  IT DELETES AN OUTPUT FILE 
C     (Q:INVEN.DAT) OF CLICOM INVENTORY PROGRAM AND REOPENS IT WITH ZERO 
C     LENGTH.  SINCE THE OUTPUT FILE OF INVENTORY PROGRAM HAS THE SAME FILE
C     NAME FOR ALL DATA-TYPE (DLY,HLY,SYN,15M,U-A), THE IMPORT WILL
C     NOT UPDATE THE EXISTING RECORDS.
C
C       ** DELETE THE 'Q:INVEN.DAT' FILE.  SINCE THE INVENTORY DATA FILE HAS 
C          BEEN IMPORTED INTO DATAEASE, THE INVENTORY DATA IS NO LONGER NEEDED.
C
      OPEN(51,FILE='Q:INVEN.DAT',STATUS='UNKNOWN',FORM='FORMATTED')
      CLOSE(51,STATUS='DELETE')
C
C       ** OPEN THE 'Q:INVEN.DAT' FILE AND CREATE THE ZERO LENGTH FILE.  THAT 
C          WAY IT WILL NOT UPDATE INVENTORY WITH WRONG DATA-TYPE IF THE 
C          PROGRAM IS NOT RUN.
C 
      OPEN(51,FILE='Q:INVEN.DAT',STATUS='UNKNOWN',FORM='FORMATTED')
      CLOSE(51)
C      
      STOP ' '
      END
