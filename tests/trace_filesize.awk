#!/usr/bin/awk -f

BEGIN{
	FS = "[][() ]+"
	if(FILE == "") FILE="FILE0000.TXT"
	if(CHUNKSIZE == "") CHUNKSIZE=4096
	if(FILESIZE == "") FILESIZE=1048576

	print FILE ": " "filesize=" FILESIZE
}

{
	if($9 == FILE) {
		if($5 == FILESIZE) {
			FLAGS = 1
		}
	}
}

END{
	if(FLAGS != 1) {
		print "write/read filesize is invalid."
		exit 1
	}

	exit 0
}

