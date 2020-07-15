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
		if( $3 == "/etc/ld.so.cache") { 
			print "ld.so.cache is opened"
			OFLAGS = 0
		} else if ($3 == "/lib/x86_64-linux-gnu/libc.so.6") {
			print "libv.so.6 is opened"
			OFLAGS = 0
		} else {
			print $3" is opened"
			OFLAGS = 1
		}
	}

	if( OFLAGS == 1 && $1 == "write") {
		if( $4 == CHUNKSIZE ) {
			WFLAGS = 1
		} else if(WARN != 1) {
			print $0
			print "  write: "$4" is not expected." "(" CHUNKSIZE ")"
			WARN = 1
		}
	}
	if( OFLAGS == 1 && $1 == "read") {
		if( $4 == CHUNKSIZE ) {
			RFLAGS = 1
		} else if(WARN != 1) {
			print $0
			print "  read:  "$4" is not expected." "(" CHUNKSIZE ")"
			WARN = 1
		}
	}
}

END{
	print "------------------------------"
	if(WFLAGS != 1 || RFLAGS != 1) {
		print "write/read chunksize is invalid."
		exit 1
	}

	print "trace_chunk: success"
	exit 0
}
