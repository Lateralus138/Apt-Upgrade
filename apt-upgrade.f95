program main
    use foul
    implicit none
	CHARACTER(LEN=27) :: REDFRMT = 'background_white red bright'
	CHARACTER(LEN=28) :: BLUEFRMT = 'background_white blue bright'
	CHARACTER(LEN=29) :: GREENFRMT = 'background_white green bright'
	CHARACTER(LEN=29) :: BLACKFRMT = 'background_white black bright'
	CHARACTER(LEN=32) :: MAGFRMT = 'background_white magenta bright'
	CHARACTER(LEN=1) :: CHOICE
	CHARACTER(LEN=9) :: ARG
	CHARACTER(LEN=:), ALLOCATABLE :: SILENTEXTRA
	INTEGER :: COMSTAT,ARGCOUNT,INDEX,APTSTAT
	LOGICAL :: SILENT = .false.
	CALL EXECUTE_COMMAND_LINE('which apt>/dev/null',exitstat=APTSTAT)
	IF (APTSTAT .gt. 0) CALL EXIT(1)
	ARGCOUNT = COMMAND_ARGUMENT_COUNT()
	IF (ARGCOUNT .gt. 0) THEN
		DO INDEX=1,ARGCOUNT
			CALL GET_COMMAND_ARGUMENT(INDEX,ARG)
			ARG = TRIM(ARG)
			IF (ARG .eq. '-h' .or. ARG .eq. '--help') THEN
				CALL write_formatted('                                                  ',BLACKFRMT)
				CALL write_formatted(' Usage: apt-upgrade [OPTION]...                   ',BLACKFRMT)
				CALL write_formatted(' Run "apt update" and "apt upgrade -y"            ',BLACKFRMT)
				CALL write_formatted('                                                  ',BLACKFRMT)
				CALL write_formatted(' Options:                                         ',BLACKFRMT)
				CALL write_formatted('     -h, --help       this help screen.           ',BLACKFRMT)
				CALL write_formatted('     -s, --silent     run silently when possible. ',BLACKFRMT)
				CALL write_formatted('                                                  ',BLACKFRMT)
				CALL write_formatted(' Exit Codes:                                      ',BLACKFRMT)
				CALL write_formatted('     0                no error.                   ',BLACKFRMT)
				CALL write_formatted('     1                APT not found.              ',BLACKFRMT)
				CALL write_formatted('     2                error in "apt update"       ',BLACKFRMT)
				CALL write_formatted('     3                error in "apt upgrade -y"   ',BLACKFRMT)
				CALL write_formatted('                                                  ',BLACKFRMT)
				CALL EXIT(0)				
			END IF
			IF (ARG .eq. '-s' .or. ARG .eq. '--silent') THEN
				SILENT = .true.
				ALLOCATE(CHARACTER(LEN=16) :: SILENTEXTRA)
				SILENTEXTRA = ' 2>&1 >/dev/null'
			END IF
		END DO
	END IF
	IF (.not.(ALLOCATED(SILENTEXTRA))) THEN
		ALLOCATE(CHARACTER(LEN=1) :: SILENTEXTRA)
		SILENTEXTRA = ' '		
	END IF
	IF (SILENT .eqv. .false.) THEN
		CALL write_formatted('                                                  ',BLACKFRMT)
		CALL write_formatted('             Running "apt update"...              ',BLUEFRMT)
		CALL write_formatted('                                                  ',BLACKFRMT)
	END IF
	CALL EXECUTE_COMMAND_LINE('apt update'//SILENTEXTRA,exitstat=COMSTAT)
	IF (COMSTAT .gt. 0) THEN
		IF (SILENT .eqv. .false.) THEN
			CALL write_formatted('                                                  ',BLACKFRMT)
			CALL write_formatted('          Error running "apt update"...           ',REDFRMT)
			CALL write_formatted('                                                  ',BLACKFRMT)
		END IF
		CALL EXIT(2)
	ELSE
		IF (SILENT .eqv. .false.) THEN
			CALL write_formatted('                                                  ',BLACKFRMT)
			CALL write_formatted('            "apt update" completed...             ',GREENFRMT)
			CALL write_formatted('                                                  ',BLACKFRMT)
		END IF
	END IF
	IF (SILENT .eqv. .false.) THEN
		CALL write_formatted('                                                  ',BLACKFRMT)
		CALL write_formatted('           Running "apt upgrade -y"...            ',BLUEFRMT)
		CALL write_formatted('                                                  ',BLACKFRMT)
	END IF
	CALL EXECUTE_COMMAND_LINE('apt upgrade -y'//SILENTEXTRA,exitstat=COMSTAT)
	IF (COMSTAT .gt. 0) THEN
		IF (SILENT .eqv. .false.) THEN
			CALL write_formatted('                                                  ',BLACKFRMT)
			CALL write_formatted('        Error running "apt upgrade -y"...         ',REDFRMT)
			CALL write_formatted('                                                  ',BLACKFRMT)
		END IF
		CALL EXIT(3)
	ELSE
		IF (SILENT .eqv. .false.) THEN
			CALL write_formatted('                                                  ',BLACKFRMT)
			CALL write_formatted('          "apt upgrade -y" completed...           ',GREENFRMT)
			CALL write_formatted('                                                  ',BLACKFRMT)
		END IF
	END IF
end program main
