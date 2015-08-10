:

# Time-stamp: <2015-08-10 13:25:12 johayek>
# $Id: fetchmail--restart_with_new_logfile.sh 1.1 2015/08/10 11:26:51 johayek Exp $
# $Source: /Users/johayek/git-servers/github.com/JochenHayek/misc/RCS/fetchmail--restart_with_new_logfile.sh $

# this script is supposed to be run on www.B.shuttle.de

# old log files are supposed to be archived at /media/NAS/johayek/ARCHIVE/www.b.shuttle.de-non-dated/var/log

################################################################################

fetchmail_log=$HOME/var/log/fetchmail.log

set -x

fetchmail --quit

~/bin/create_snapshot.sh      "${fetchmail_log}"
rm                            "${fetchmail_log}"
bzip2 -9v                     "${fetchmail_log}".*[0-9][0-9]	# everything but fetchmail.log.*.bz2

fetchmail --verbose --logfile "${fetchmail_log}"		# backgrounding by itself
