:
#! /bin/sh

# git-servers/github.com/JochenHayek/misc/shell/purge_args.sh

# $ ~/bin/purge_args.sh DIR ...

# actually this utility should not live in .../using_timestamps_in_filenames/ ,
# as it does not deal with timestamps.

################################################################################

if test $# -ge 1
then :
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

old=
for i
do :
  printf 1>&2 "=%s,%d: %s=>{%s} // %s\n" $0 $LINENO \
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
