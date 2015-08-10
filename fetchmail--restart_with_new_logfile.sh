:

# Time-stamp: <2015-08-10 13:44:50 johayek>
# $Id: fetchmail--restart_with_new_logfile.sh 1.3 2015/08/10 11:45:17 johayek Exp $
# $Source: /Users/johayek/git-servers/github.com/JochenHayek/misc/RCS/fetchmail--restart_with_new_logfile.sh $

# * supposed to be run on www.B.shuttle.de
# * script "lives"     on www.B.shuttle.de : $HOME/Computers/Software/Operating_Systems/Unix/Shell/
                                     log_dir=$HOME/var/log
# * log files  "live"  on www.B.shuttle.de :
                               fetchmail_log=${log_dir}/fetchmail.log
# * version controlled on           HayekY : $HOME/Computers/Software/Operating_Systems/Unix/Shell/
# * old log files to be archived           :
                                 archive_dir=/media/NAS/johayek/ARCHIVE/www.b.shuttle.de-non-dated/var/log

################################################################################

set -x

fetchmail --quit

~/bin/create_snapshot.sh      "${fetchmail_log}"
rm                            "${fetchmail_log}"
bzip2 -9v                     "${fetchmail_log}".*[0-9][0-9]	# everything but fetchmail.log.*.bz2

ll                            "${log_dir}"

echo "*** maybe you want to archive these log files here occasionally: ${archive_dir}"

fetchmail --verbose --logfile "${fetchmail_log}"		# backgrounding by itself
