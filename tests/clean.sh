#!/bin/bash

set -eu -o pipefail
trap 'echo "ERROR: l.$LINENO, exit status = $?" >&2; exit 1' ERR

TARGET=test.img
FSTYPE=vfat

### main function
sudo umount mnt
rmdir mnt
rm -f ${TARGET}
