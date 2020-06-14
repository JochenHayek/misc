:

# Time-stamp: <2020-06-14 18:15:34 johayek>
# $Id: fetchmail--restart_with_new_logfile.sh 1.5 2020/06/14 16:27:41 johayek Exp $
# $Source: /Users/johayek/git-servers/github.com/JochenHayek/misc/RCS/fetchmail--restart_with_new_logfile.sh $

# * supposed to be run on jhk00-domains@jhk00.hostsharing.net
# * script "lives"     on jhk00-domains@jhk00.hostsharing.net : $HOME/Computers/Software/Operating_Systems/Unix/Shell/
                                                        log_dir=$HOME/var/log
# * log files  "live"  on jhk00-domains@jhk00.hostsharing.net :
                                                  fetchmail_log=${log_dir}/fetchmail.log
# * version controlled on                              HayekY : $HOME/Computers/Software/Operating_Systems/Unix/Shell/
# * old log files to be archived           :
                                                    archive_dir=/media/NAS/johayek/ARCHIVE/www.b.shuttle.de-non-dated/var/log

################################################################################

set -x

fetchmail --quit

~/bin/create_snapshot.sh      "${fetchmail_log}"
rm                            "${fetchmail_log}"
xz -9v                        "${fetchmail_log}".*[0-9][0-9]	# everything but fetchmail.log.*.bz2

ls --format=long --no-group --time-style="+%F %T" --human-readable "${log_dir}"

echo "*** maybe you want to archive these log files here occasionally: ${archive_dir}"

fetchmail --verbose --logfile "${fetchmail_log}"		# backgrounding by itself
