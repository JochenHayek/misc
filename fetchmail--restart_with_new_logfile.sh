:

# git-servers/github.com/JochenHayek/misc/fetchmail--restart_with_new_logfile.sh

################################################################################
#
# how to be run:
#
# in the IMAP folder topics-computers/admin-hostsharing/
# from the cron mail message matching "extract_fingerprints.pl"
# get the new fingerprint for the mail host!
#
# update ~/git-servers/ber.jochen.hayek.name/johayek/misc/DOTfiles-hostsharing/.fetchmailrc
# with the new fingerprint
#
# $ ssh -A jhk00@jhk00.hostsharing.net
# $ cd ~/git-servers/ber.jochen.hayek.name/johayek/misc/DOTfiles-hostsharing/
# $ git pull
#
# $ ssh -A jhk00-domains@jhk00.hostsharing.net var/log/fetchmail--restart_with_new_logfile.sh
#
################################################################################

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

if cmp --quiet $HOME/.fetchmailrc- $HOME/.fetchmailrc
then :
     touch 			      "${fetchmail_log}"
     fetchmail --verbose --logfile "${fetchmail_log}"		# backgrounding by itself
else :
     set -x
     diff $HOME/.fetchmailrc- $HOME/.fetchmailrc
     echo '***' cp --arch $HOME/git-servers/ber.jochen.hayek.name/johayek/misc/DOTfiles-hostsharing/.fetchmailrc $HOME/.fetchmailrc
     echo '***' chmod go-rwx $HOME/.fetchmailrc
fi
