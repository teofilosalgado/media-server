#!/bin/sh
#
# PROVIDE: overseerr
# REQUIRE: networking
# KEYWORD:

. /etc/rc.subr

name="overseerr"
desc="Overseerr daemon"
rcvar="overseerr_enable"

overseerr_chdir="/usr/local/${name}"
overseerr_user="${name}"
overseerr_command="/usr/local/bin/yarn"
overseerr_args="--cwd ${overseerr_chdir} start"

pidprefix="/var/run/${name}"
pidfile="${pidprefix}/${name}.pid"
command="/usr/sbin/daemon"
command_args="-P ${pidfile} -R 10 -f -u ${overseerr_user} ${overseerr_command} ${overseerr_args}"

mkdir -m 777 -p $pidprefix

load_rc_config $name
: ${overseerr_enable:=no}

run_rc_command "$1"