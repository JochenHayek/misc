:

# $ .../diff_last_2.sh Rakefile.20*
#
#   supposing there are some Rakefile.20*

# CAVEAT:
#
# differring parameter usages:
# * "Rakefile"
# * "Rakefile.20*"

# group of utilities:
# * .../list_snapshot_diffs.sh
# * .../diff_last_2.sh
# * ...

################################################################################

bn0=$(basename "$0")

if test "$#" -ge 2
then :
  false &&
  printf 1>&2 "=%s,%03.3d: %s=>{%s} // %s\n" "${bn0}" $LINENO \
    '$#' "$#" \
    '...'
else
  printf 1>&2 "=%s,%03.3d: %s=>{%s} // %s\n" "${bn0}" $LINENO \
    '$#' "$#" \
    'expecting $# >= 2'
  exit 1
fi

# this is the old fashinioned variant -- w/o bash arrays

while test "$#" -gt 0
do :
  false &&
  printf 1>&2 "=%s,%03.3d: %s=>{%s},%s=>{%s} // %s\n" "${bn0}" $LINENO \
    '$#' "$#" \
    '$1' "$1" \
    '...'

  last_but_one_param="$last_param"
  last_param="$1"
  shift

  if false
  then :
    printf 1>&2 "=%s,%03.3d: %s=>{%s} // %s\n" "${bn0}" $LINENO \
      '${last_but_one_param}' "${last_but_one_param}" \
      '...'
    printf 1>&2 "=%s,%03.3d: %s=>{%s} // %s\n" "${bn0}" $LINENO \
      '${last_param}' "${last_param}" \
      '...'
  fi
done

if false
then :
  printf 1>&2 "=%s,%03.3d: %s=>{%s} // %s\n" "${bn0}" $LINENO \
    '${last_but_one_param}' "${last_but_one_param}" \
    '...'
  printf 1>&2 "=%s,%03.3d: %s=>{%s} // %s\n" "${bn0}" $LINENO \
    '${last_param}' "${last_param}" \
    '...'
fi

set -x

##exec diff "${params[$n_min_2]}" "${params[$n_min_1]}"
exec   diff "${last_but_one_param}" "${last_param}"

exit 9

################################################################################

declare -a params=( "$@" )

n="${#params[@]}"

n_min_1=$(( n - 1))
n_min_2=$(( n - 2))

if false
then :
  printf 1>&2 "=%s,%03.3d: %s=>{%s} // %s\n" "${bn0}" $LINENO \
    '${n_min_2}' "${n_min_2}" \
    '...'
  printf 1>&2 "=%s,%03.3d: %s=>{%s} // %s\n" "${bn0}" $LINENO \
    '${n_min_1}' "${n_min_1}" \
    '...'
  printf 1>&2 "=%s,%03.3d: %s=>{%s} // %s\n" "${bn0}" $LINENO \
    '${n}' "${n}" \
    '...'

  printf 1>&2 "=%s,%03.3d: %s=>{%s} // %s\n" "${bn0}" $LINENO \
    "\${params[$n_min_2]}" "${params[$n_min_2]}" \
    '...'
  printf 1>&2 "=%s,%03.3d: %s=>{%s} // %s\n" "${bn0}" $LINENO \
    "\${params[$n_min_2]}" "${params[$n_min_2]}" \
    '...'
fi

set -x

exec diff "${params[$n_min_2]}" "${params[$n_min_1]}"
