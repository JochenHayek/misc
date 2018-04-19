:

# -> https://gist.github.com/omkz/712c810a1e9bc9eaf14254cfe68f1abe

git branch -r |

cut '--delimiter=/' --fields=2 |

while read branch
do

  # 'HEAD -> origin'

##if [[ "${branch}" == *" -> "* ]]

  if [[ "${branch}" =~ .*" -> ".* ]]

  then :

    false &&
    printf 1>&2 "\n=%03.3d: %s=>{%s} // %s\n" $LINENO \
		'branch' "${branch}" \
		'matching the arrow'

    continue
  fi

  printf 1>&2 "\n=%03.3d: %s=>{%s} // %s\n" $LINENO \
	      'branch' "${branch}" \
	      '...'

##continue

  printf 1>&2 "=%03.3d: %s=>{%s} // %s\n" $LINENO \
	      'branch' "${branch}" \
	      'git checkout ...'

  if git checkout "${branch}"
  then :

    printf 1>&2 "=%03.3d: %s=>{%s} // %s\n" $LINENO \
		'branch' "${branch}" \
		'git pull origin ...'
       
     git pull origin "${branch}"
  fi

done
