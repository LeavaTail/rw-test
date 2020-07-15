#!/bin/bash
set -x

strace ./rwtest -qa || exit 0

echo "---------------NG---------------"
exit 1
