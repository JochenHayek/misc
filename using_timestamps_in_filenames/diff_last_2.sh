:

# .../diff_last_2.sh Rakefile.20*

bn0=$(basename "$0")

if test $# -ge 2
then :
  false &&
  printf 1>&2 "=%s,%03.3d: %s=>{%s} // %s\n" "${bn0}" $LINENO \
    '$#' $# \
    '...'
else
  printf 1>&2 "=%s,%03.3d: %s=>{%s} // %s\n" "${bn0}" $LINENO \
    '$#' $# \
    'expecting $# >= 2'
  exit 1
fi

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
