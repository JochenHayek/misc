#! /bin/bash

# usage:
#
# ~/git-servers/github.com/JochenHayek/snapshots2git/snapshots2git.sh .bashrc.20*

for i
do :
  false &&
  printf 1>&2 "=%s,%03.3d: %s=>{%s} // %s\n" "$0" $LINENO \
    'i' "${i}" \
    '...'

  name=$( echo "${i}" | perl -ne 'm/ ^ (?<name>.*) \. (?<date>\d{14}) $ /x && print $+{name},"\n"' )
  date=$( echo "${i}" | perl -ne 'm/ ^ (?<name>.*) \. (?<date>\d{14}) $ /x && print $+{date},"\n"' )

  git_date=$( echo "${i}" |
              perl -ne 'm/ ^ (?<name>.*) \. (?<date_YYYY>\d\d\d\d) (?<date_mm>\d\d) (?<date_dd>\d\d) (?<date_HH>\d\d) (?<date_MM>\d\d) (?<date_SS>\d\d) $ /x && 
                        print "$+{date_YYYY}-$+{date_mm}-$+{date_dd}T$+{date_HH}:$+{date_MM}:$+{date_SS}\n"' 
            )

  # git date: e.g. 2005-04-07T22:13:13

  printf 1>&2 "=%s,%03.3d: %s=>{%s},%s=>{%s},%s=>{%s},%s=>{%s} // %s\n" "$0" $LINENO \
    'i' "${i}" \
    'name' "${name}" \
    'date' "${date}" \
    'git_date' "${git_date}" \
    '...'

  echo

  echo 1>&2 '+' mv --verbose "$i" "${name}"
                mv --verbose "$i" "${name}" ||
                exit 1

  echo 1>&2 '+' git add "${name}"
                git add "${name}" ||
                exit 1


  echo 1>&2 '+' git commit --allow-empty-message --allow-empty --message= "--date=${git_date}" "${name}"
                git commit --allow-empty-message --allow-empty --message= "--date=${git_date}" "${name}" ||
                exit 1

  echo

done
