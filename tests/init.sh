#!/bin/bash

set -eu -o pipefail
trap 'echo "ERROR: l.$LINENO, exit status = $?" >&2; exit 1' ERR

TARGET=test.img
FSTYPE=vfat

### main function
mkdir mnt
dd if=/dev/zero bs=1024 count=128K of=${TARGET}
mkfs.${FSTYPE} ${TARGET}
sudo mount -t ${FSTYPE} -o loop ${TARGET} mnt
