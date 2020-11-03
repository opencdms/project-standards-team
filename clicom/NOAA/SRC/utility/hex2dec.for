$STORAGE:2
C
      SUBROUTINE HEX2DEC(HEXSTR,LNGTH,SETLEN,DECNUM,DECLEN,RTNCODE)
C
C  THIS SUBROUTINE CONVERTS A HEXIDECIMAL CHARACTER STRING TO
C  DECIMAL VALUES.
C
C  PASSED VARIABLES:
C     HEXSTR  = A STRING OF HEXIDECIMAL VALUES PASSED IN
C     DECNUM  = THE DECIMAL NUMBERS RETURNED
C     LNGTH   = THE LENGTH OF THE HEXIDECIMAL STRING
C     SETLEN  = THE LENGTH OF EACH NUMBER GROUP IN HEXSTR
C     RTNCODE = RETURN CODE
C                  0 = SUCCESSFUL CONVERSION
C                  1 = ERROR IN CONVERSION
C                  3 = LNGTH NOT EVENLY DIVISABLE BY SETLEN
C
       CHARACTER*1 HEXSTR(LNGTH)
C
       INTEGER*2 DECNUM(DECLEN), LNGTH, RTNCODE
       INTEGER*2 POWER, SETLEN
C
      RTNCODE = 0
C
C  CHECK FOR HEX STRING LENGTH BEING AN EVEN MULTIPLE OF THE
C  INTERNAL GROUP LENGTH
C
      IF (MOD(LNGTH,SETLEN).NE.0)THEN
         RTNCODE = 3
	 RETURN
      END IF
C
C  BEGIN DECODE
C
      K = 0
      STEPS = LNGTH / SETLEN
      DO 100 I = 1,STEPS
         DECNUM(I) = 0
         DO 110 J = SETLEN,1,-1
	    K = K + 1
            POWER = 16**(J - 1)
            IF (HEXSTR(K).GE.'0'.AND. HEXSTR(K).LE.'9')THEN
               READ(HEXSTR(K),'(I1)')L
	       GO TO 105
       	    ELSE IF (HEXSTR(K).EQ.'A')THEN
               L = 10
	       GO TO 105
	    ELSE IF (HEXSTR(K).EQ.'B')THEN
	       L = 11
	       GO TO 105
	    ELSE IF (HEXSTR(K).EQ.'C')THEN
	       L = 12
	       GO TO 105
	    ELSE IF (HEXSTR(K).EQ.'D')THEN
	       L = 13
	       GO TO 105
	    ELSE IF (HEXSTR(K).EQ.'E')THEN
	       L = 14
	       GO TO 105
	    ELSE IF (HEXSTR(K).EQ.'F')THEN
	       L = 15
	       GO TO 105
	    ELSE IF (HEXSTR(K).EQ.' ')THEN
	       GO TO 100
	    END IF
	    RTNCODE = 1
	    RETURN
  105       DECNUM(I) = DECNUM(I) + L * POWER
  110    CONTINUE
  100 CONTINUE
C
      RETURN
      END
