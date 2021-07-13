:
#! /bin/sh

# misc/using_timestamps_in_filenames/purge_snapshots.sh

# $ ~/bin/purge_snapshots.sh DIR ...

################################################################################

# a simple shell like the BusyBox ash does not have $LINENO,
# so we want at least to set it to 0:
#
if test -z "$LINENO"
then LINENO=0
fi

################################################################################

if test $# -ge 1
then :
##dir="$1"
else :
  printf 1>&2 "=%s,%d: %s=>{%s} // %s\n" $0 $LINENO \
    '$#' "$#" \
    'should be >= 1, exiting' \
    ;
  exit 1
fi

################################################################################

if test -n "$BASH_VERSINFO"
then shopt -s nullglob
fi

for dir
do :
  printf 1>&2 "\n"
  printf 1>&2 "=%s,%d: %s=>{%s} // %s\n" $0 $LINENO \
    '$dir' "$dir" \
    '...'

  $HOME/bin/short_list_of_files_without_timestamp_extension.sh "$dir" |

  while read f
  do :
    printf 1>&2 "\n"
    printf 1>&2 "=%s,%d: %s=>{%s},%s=>{%s} // %s\n" $0 $LINENO \
      '$dir' "$dir" \
      '$f' "$f" \
      '...'

    old=
    for i in ${f}.[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]
    do :
      printf 1>&2 "=%s,%d: %s=>{%s},%s=>{%s},%s=>{%s} // %s\n" $0 $LINENO \
	'$dir' "$dir" \
	'$f' "$f" \
	'$i' "$i" \
	'...'

      if test -z "$old"
      then
	old="$i"
	continue
      fi

    ##if cmp --silent "$old" "$i"
      if cmp  -s      "$old" "$i"
      then :

	printf 1>&2 "=%s,%d: %s=>{%s} // %s\n" $0 $LINENO \
	  '$i' "$i" \
	  'going to rm'

      ##rm --verbose "$i"
	rm "$i"

      else :
	old="$i"
      fi
    done
  done
done
