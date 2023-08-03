#!/bin/sh
#
# $ podman-run.sh $
#

# SPDX-License-Identifier: BSD Zero Clause License (0BSD)

case ${BASH_VERSION-} in *.*) set -o posix; shopt -s xpg_echo; esac
case ${ZSH_VERSION-} in *.*) emulate ksh; esac

set -euf  # hint: (z|ba|da|'')sh -x thisfile [args] to trace execution

test $# = 0 && {
	podman images debian-12-fontforge
	echo
	echo "Usage: $0 [options] image [command [arg ...]]"
	echo
	exit 1
}

case $1 in *:*) ;; *)
	exec >&2; echo
	echo "'$1' does not contain ':'s (probably not container image name)"
	echo
	exit 1
esac

wo="-v /etc/localtime:/etc/localtime:ro --device /dev/dri"
test "${DISPLAY-}" && {
	wo="$wo -v /tmp/.X11-unix:/tmp/.X11-unix"
	wo="$wo -e DISPLAY=$DISPLAY"
}
test "${WAYLAND_DISPLAY-}" && {
	uid=${UID:-`id -u`}
	wo="$wo -v /run/user/$uid/bus:/tmp/bus"
	wo="$wo -e DBUS_SESSION_BUS_ADDRESS=unix:path=/tmp/bus"
	wo="$wo -e XDG_RUNTIME_DIR=/tmp"
	wo="$wo -v $XDG_RUNTIME_DIR/$WAYLAND_DISPLAY:/tmp/wayland-0"
	wo="$wo -e WAYLAND_DISPLAY=/tmp/wayland-0"
	unset uid
}
wo="$wo --security-opt label=type:container_runtime_t"

# Some systems fail to run ./script, so add indirection
ci=$1
shift
test $# -gt 0 && set -- sh -c 'exec "$0" "$@"' "$@"

x_exec () { printf '+ %s\n' "$*" >&2; exec "$@"; }

x_exec \
podman run --pull=never --rm -it --privileged $wo \
	--tmpfs /tmp --tmpfs /run -v "$HOME:$HOME" -w "$PWD" $ci "$@"

# Local variables:
# mode: shell-script
# sh-basic-offset: 8
# tab-width: 8
# End:
# vi: set sw=8 ts=8
