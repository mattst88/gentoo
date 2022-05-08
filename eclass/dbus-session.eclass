# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: dbus-session.eclass
# @MAINTAINER:
# mattst88@gentoo.org
# @AUTHOR:
# Original author: Matt Turner <mattst88@gentoo.org>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: This eclass can be used for packages that need a dbus-session.

case ${EAPI} in
	7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} is not supported." ;;
esac

if [[ ! ${_DBUS_SESSION_ECLASS} ]]; then
_DBUS_SESSION_ECLASS=1

# @ECLASS_VARIABLE: DBUS_SESSION_REQUIRED
# @PRE_INHERIT
# @DESCRIPTION:
# Variable specifying the dependency on dbus.
# Possible special values are "always" and "manual", which specify
# the dependency to be set unconditionaly or not at all.
# Any other value is taken as useflag desired to be in control of
# the dependency (eg. DBUS_SESSION_REQUIRED="kde" will add the dependency
# into "kde? ( )" and add kde into IUSE.
: ${DBUS_SESSION_REQUIRED:=test}

# @ECLASS_VARIABLE: DBUS_SESSION_DEPEND
# @OUTPUT_VARIABLE
# @DESCRIPTION:
# Standard dependencies string that is automatically added to BDEPEND
# unless DBUS_SESSION_REQUIRED is set to "manual".
DBUS_SESSION_DEPEND="
	sys-apps/dbus
"
readonly DBUS_SESSION_DEPEND

case ${DBUS_SESSION_REQUIRED} in
	manual)
		;;
	always)
		BDEPEND="${DBUS_SESSION_DEPEND}"
		;;
	*)
		BDEPEND="${DBUS_SESSION_REQUIRED}? ( ${DBUS_SESSION_DEPEND} )"
		IUSE="${DBUS_SESSION_REQUIRED}"
		if [[ ${DBUS_SESSION_REQUIRED} == test ]]; then
			RESTRICT+=" !test? ( test )"
		fi
		;;
esac

# @FUNCTION: dbus-session
# @USAGE: <command> [command arguments]
# @DESCRIPTION:
# Start new dbus session and run commands in it.
#
dbus-session() {
	debug-print-function ${FUNCNAME} "$@"

	[[ $# -lt 1 ]] && die "${FUNCNAME} needs at least one argument"

	debug-print "${FUNCNAME}: $@"

	(
		# start isolated dbus session bus
		dbus_data=$(dbus-launch --sh-syntax) || exit
		eval "${dbus_data}"

		nonfatal "${@}"
		ret=${?}

		kill "${DBUS_SESSION_BUS_PID}"
		exit "${ret}"
	) || die
}

fi
