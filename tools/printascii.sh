#!/bin/sh

set -euf

LANG=C LC_ALL=C; export LANG LC_ALL; unset LANGUAGE
PATH='/sbin:/usr/sbin:/bin:/usr/bin'; export PATH

chars=1234567890.
chars=$chars''abcdefghijklmnoprstuvwxyz:
chars=$chars''ABCDEFGHIJKLMNOPRSTUVWXYZ/
chars=$chars'!"#$%&'\''()*+,-@=?'

#echo ${#chars}

printf '%s\n' "$chars"
printf '\033[3m%s\n' "$chars" # italics
printf '\033[0m' # reset to normal
printf '\033[1m%s\n' "$chars" # bold
printf '\033[3m%s\n' "$chars" # bold italics (add italics to bold)
printf '\033[0m' # reset to normal
