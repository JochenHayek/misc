# …

# outdated:
#
#   git-servers/ber.jochen.hayek.name/johayek/client-eexDOTcom

for i in \
  \
  git-servers/github.com/JochenHayek/misc \
  git-servers/github.com/JochenHayek/rcs2git \
  \
  git-servers/ber.jochen.hayek.name/johayek/CV.xmlresume \
  git-servers/ber.jochen.hayek.name/johayek/banks \
  git-servers/ber.jochen.hayek.name/johayek/check_lists \
  git-servers/ber.jochen.hayek.name/johayek/jira2diary \
  git-servers/ber.jochen.hayek.name/johayek/misc \
  git-servers/ber.jochen.hayek.name/johayek/online-dating \
  git-servers/ber.jochen.hayek.name/johayek/passwords \
  git-servers/ber.jochen.hayek.name/johayek/procmailrc \
  git-servers/ber.jochen.hayek.name/johayek/qif2skr03 \
  git-servers/ber.jochen.hayek.name/johayek/renaming_and_processing_various_files \
  ;
do :
  if test -d "$HOME/$i"
  then :
    echo -e "\n*** $i :\n"
  else
    echo -e "\n\n*** $i : we don't have this here, skipping ...\n\n"
    continue
  fi

  cd "$HOME/$i"
  git status
done
