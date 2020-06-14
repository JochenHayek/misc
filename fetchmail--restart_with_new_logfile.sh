:

# git-servers/github.com/JochenHayek/misc/fetchmail--restart_with_new_logfile.sh

# * supposed to be run on jhk00-domains@jhk00.hostsharing.net
                                                        log_dir=$HOME/var/log
# * log files  "live"  on jhk00-domains@jhk00.hostsharing.net :
                                                  fetchmail_log=${log_dir}/fetchmail.log
# * old log files to be archived           :
                                                    archive_dir=/scp:ber.jochen.hayek.name:ARCHIVE/hostsharing-longterm/var/log/


################################################################################

set -x

fetchmail --quit

~/bin/create_snapshot.sh      "${fetchmail_log}"
rm                            "${fetchmail_log}"
xz -9v                        "${fetchmail_log}".*[0-9][0-9]	# everything but fetchmail.log.*.bz2

ls --format=long --no-group --time-style="+%F %T" --human-readable "${log_dir}"

echo "*** maybe you want to archive these log files here occasionally: ${archive_dir}"

touch 			      "${fetchmail_log}"
fetchmail --verbose --logfile "${fetchmail_log}"		# backgrounding by itself
