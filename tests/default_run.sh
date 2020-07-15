#!/bin/bash

set -eu -o pipefail
trap 'echo "ERROR: l.$LINENO, exit status = $?" >&2; exit 1' ERR

TARGETDIR="./"
TARGETFILE="RW_[0-9].*.TXT"
CHUNKSIZE=4096
FILESIZE=1048576

### main function
strace ./rwtest -q |& ./tests/trace_chunk.awk -v FILE=${TARGETFILE} -v CHUNKSIZE=${CHUNKSIZE} -v FILESIZE=${FILESIZE}
ls -l | egrep ${TARGETFILE} |& ./tests/trace_filesize.awk -v FILE=${TARGETFILE} -v CHUNKSIZE=${CHUNKSIZE} -v FILESIZE=${FILESIZE}

echo "---------------OK---------------"
