#!/usr/bin/awk -f

BEGIN{
	FS = "[][() ]+"
	if(FILE == "") FILE="FILE0000.TXT"
	if(CHUNKSIZE == "") CHUNKSIZE=4096
	if(FILESIZE == "") FILESIZE=1048576

	print FILE ": " "chunksize=" CHUNKSIZE
	print "------------------------------"
}

{
	if( $1 == "openat" ) {
		str = "\"" FILE "\"" ","
		print "  open:  "$3" compared to" str
		if( $3 == str ) 
			OFLAGS = 1
	}

	if( OFLAGS == 1 && $1 == "write")
		if( $4 == CHUNKSIZE ) {
			WFLAGS = 1
		} else if(WARN != 1) {
			print $0
			print "  write: "$4" is not expected." "(" CHUNKSIZE ")"
			WARN = 1
		}
	if( OFLAGS == 1 && $1 == "read")
		if( $4 == CHUNKSIZE ) {
			RFLAGS = 1
		} else if(WARN != 1) {
			print $0
			print "  read:  "$4" is not expected." "(" CHUNKSIZE ")"
			WARN = 1
		}
}

END{
	print "------------------------------"
	if(WFLAGS != 1 || RFLAGS != 1) {
		print "write/read chunksize is invalid."
		exit 1
	}

	exit 0
}
