# …

for i in \
  git-servers/github.com/JochenHayek/misc \
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

  cd "$HOME/$i" || exit 9

  git status
done
