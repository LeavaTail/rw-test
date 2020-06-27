#!/bin/bash

set -eu -o pipefail
trap 'echo "ERROR: l.$LINENO, exit status = $?" >&2; exit 1' ERR

TARGETDIR="./"
TARGETFILE="FILE0000.TXT"
CHUNKSIZE=4096
FILESIZE=1048576

### main function
strace -o trace.log ./rwtest
./tests/trace_chunk.awk -v FILE=${TARGETFILE} -v CHUNKSIZE=${CHUNKSIZE} -v FILESIZE=${FILESIZE} trace.log || cat trace.log

ls -l ${TARGETDIR} > trace2.log
./tests/trace_filesize.awk -v FILE=${TARGETFILE} -v CHUNKSIZE=${CHUNKSIZE} -v FILESIZE=${FILESIZE} trace2.log || cat trace2.log
