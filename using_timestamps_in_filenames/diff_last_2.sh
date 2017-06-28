:

# 

bn0=$(basename "$0")

false && echo 1>&2 "*** ${bn0},${LINENO}: \$#=>{$#}"

declare -a params=( "$@" )

n="${#params[@]}"

n_min_1=$(( n - 1))
n_min_2=$(( n - 2))

if false
then :
  echo 1>&2 "*** ${bn0},${LINENO}: \$n_min_2=>{$n_min_2}"
  echo 1>&2 "*** ${bn0},${LINENO}: \$n_min_1=>{$n_min_1}"
  echo 1>&2 "*** ${bn0},${LINENO}: \$n=>{$n}"

  echo 1>&2 "*** ${bn0},${LINENO}: \${params[$n_min_2]}=>{${params[$n_min_2]}}"
  echo 1>&2 "*** ${bn0},${LINENO}: \${params[$n_min_1]}=>{${params[$n_min_1]}}"
fi

exec diff "${params[$n_min_2]}" "${params[$n_min_1]}"
