# …

for i in \
  git-servers/github.com/JochenHayek/misc \
  git-servers/github.com/JochenHayek/rcs2git \
  git-servers/ber.jochen.hayek.name/johayek/CV.xmlresume \
  git-servers/ber.jochen.hayek.name/johayek/banks \
  git-servers/ber.jochen.hayek.name/johayek/check_lists \
  git-servers/ber.jochen.hayek.name/johayek/client-eexDOTcom \
  git-servers/ber.jochen.hayek.name/johayek/jira2diary \
  git-servers/ber.jochen.hayek.name/johayek/misc \
  git-servers/ber.jochen.hayek.name/johayek/passwords \
  git-servers/ber.jochen.hayek.name/johayek/procmailrc \
  git-servers/ber.jochen.hayek.name/johayek/qif2skr03 \
  git-servers/ber.jochen.hayek.name/johayek/renaming_and_processing_various_files \
  ;
do :
  echo -e "\n*** $i :\n"

  if cd "$HOME/$i"
  then :
  else
    echo -e "\n*** $i : we don't have this here, skipping ...\n"
    continue
  fi

  git status
done
