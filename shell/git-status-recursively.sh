:

# e.g.:
# $ cd ~/git-servers/
# $ ~/git-servers/github.com/JochenHayek/misc/shell/git-status-recursively.sh

# e.g.:
# $ cd ~/git-servers/github.com/JochenHayek/misc/
# $ ~/git-servers/github.com/JochenHayek/misc/shell/git-status-recursively.sh

################################################################################

find . -type d -name .git |

while read dir_git
do :
  dn=$( dirname "${dir_git}" )

  printf 1>&2 "=%s,%03.3d: %s=>{%s} // %s\n" "$0" $LINENO \
    '${dn}' "${dn}" \
    '...'

  if pushd "${dn}" >/dev/null
  then :
  else :
    printf 1>&2 "=%s,%03.3d: %s=>{%s} // %s\n" "$0" $LINENO \
      '${dn}' "${dn}" \
      'cannot cd'
    exit 1
  fi

  set -x

  printf 1>&2 "=%s,%03.3d: %s=>{%s} // %s\n" "$0" $LINENO \
    '$PWD' "$PWD" \
    ''

  git status

  set +x

  popd >/dev/null
done
