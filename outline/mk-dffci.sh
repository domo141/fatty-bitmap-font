#!/bin/sh
#
# mk-dffci.sh -- make debian 12 fontforge container image
#
# Author: Tomi Ollila -- too ät iki piste fi
#
#	Copyright (c) 2023 Tomi Ollila
#	    All rights reserved
#
# Created: Tue 04 Jul 2023 23:09:17 EEST too
# Last modified: Thu 03 Aug 2023 17:52:59 +0300 too

# SPDX-License-Identifier: BSD Zero Clause License (0BSD)

case ${BASH_VERSION-} in *.*) set -o posix; shopt -s xpg_echo; esac
case ${ZSH_VERSION-} in *.*) emulate ksh; esac

set -euf  # hint: (z|ba|da|'')sh -x thisfile [args] to trace execution

die () { printf '%s\n' '' "$@" ''; exit 1; } >&2

x () { printf '+ %s\n' "$*" >&2; "$@"; }
x_exec () { printf '+ %s\n' "$*" >&2; exec "$@"; die "exec '$*' failed"; }

if test "${1-}" = --in-container--
then
	#env; exit 0
	if test -e /.rerun
	then
		echo previous run failed - executing shell
		x_exec /bin/bash -il
		exit not reached
	fi
	:> /.rerun
	set -x
	: executing in container :
	export DEBIAN_FRONTEND=noninteractive
	apt-get update
	apt-get install -y -q --no-install-recommends fontforge less
	apt-get -y autoremove
	apt-get -y clean
	rm -rf /var/lib/apt/lists/
	rm /.rerun
	: done :
	{ exit; } 2>/dev/null
fi

# host part, check, run container and finally commit the build container

command -v podman >/dev/null || die "'podman': command not found"

tag=$(date +%Y%m%d)
target_image=debian-12-fontforge:$tag
from_image=debian:12

if podman inspect -t image --format='{{.RepoTags}} {{.Created}}' \
	"$target_image" 2>/dev/null
then
	die	"Target image '$target_image' exists." \
		"Rename, remove, or wait until tomorrow, to create."
	exit not reached
fi

# note: path below could be get here -- now we just know debian:12 has that...

podman inspect -t image --format='{{.Config.Env}}' "$from_image" || {
	exec >&2
	printf '\n"From" image missing;'
	echo " podman pull the image ($from_image) before continuing."
	echo
	exit 1
}

if test "${1-}" != '!'
then
	echo Already-made images '(if any)':
	podman images "${target_image%:*}"
	echo
	echo "Add '!' to the command line to create $target_image"
	echo
	exit
fi

case $(podman --version)
	in *' '[4-9]* | *' '[1-9][0-9]*)
		__unsetenv_all=--unsetenv-all
	;; *)	__unsetenv_all=
esac

case $0 in */*) dn0=${0%/*} ;; *) dn0=./$0 ;; esac

# the tmpfs mounts are so that the changes applied to those directories
# do not appear in the final file system layer

x podman run --pull=never -it --privileged -v "$dn0:/mnt:ro" \
	--tmpfs /tmp:rw,size=65536k,mode=1777 \
	--tmpfs /run:rw,size=999999,mode=1777 \
	--tmpfs /root:rw,size=99999,mode=1777 \
	-e PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
	$__unsetenv_all --name "${target_image%:*}-wip" "$from_image" \
	/bin/sh /mnt/"${0##*/}" --in-container-- ||
	die "Building '$target_image' failed..." '' Execute: \
	    "  podman start -ia ${target_image%:*}-wip ;: or" \
	    "  podman logs ${target_image%:*}-wip      ;: to investigate."

x podman commit --change 'CMD=["/bin/bash"]' \
	"${target_image%:*}-wip" "$target_image"
podman rm "${target_image%:*}-wip"

echo
echo all done
echo


# Local variables:
# mode: shell-script
# sh-basic-offset: 8
# tab-width: 8
# End:
# vi: set sw=8 ts=8
