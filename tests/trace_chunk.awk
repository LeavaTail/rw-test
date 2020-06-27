#!/usr/bin/awk -f

BEGIN{
	FS = "[][() ]+"
	if(FILE == "") FILE="FILE0000.TXT"
	if(CHUNKSIZE == "") CHUNKSIZE=4096
	if(FILESIZE == "") FILESIZE=1048576

	print FILE ": " "chunksize=" CHUNKSIZE
}

{
	if( $1 == "openat" ) {
		str = "\"" FILE "\"" ","
		if( $3 == str ) 
			OFLAGS = 1
	}

	if( OFLAGS == 1 && $1 == "write")
		if( $4 == CHUNKSIZE )
			WFLAGS = 1
	if( OFLAGS == 1 && $1 == "read")
		if( $4 == CHUNKSIZE )
			RFLAGS = 1
}

END{
	if(WFLAGS != 1 || RFLAGS != 1) {
		print "write/read chunksize is invalid."
		exit 1
	}

	exit 0
}
