#!/bin/sh
#
# PROVIDE: overseerr
# REQUIRE: networking
# KEYWORD:

. /etc/rc.subr

name="overseerr"
desc="Overseerr daemon"
rcvar="overseerr_enable"

overseerr_chdir="/usr/local/share/overseerr"
overseerr_user="overseerr"
overseerr_command="/usr/local/bin/yarn"
overseerr_args="--cwd ${overseerr_chdir} start"

pidfile="/var/run/${name}.pid"
command="/usr/sbin/daemon"
command_args="-P ${pidfile} -R 10 ${overseerr_command} ${overseerr_args}"

load_rc_config $name
: ${overseerr_enable:=no}

run_rc_command "$1"