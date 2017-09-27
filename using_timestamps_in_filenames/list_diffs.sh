:

# misc/using_timestamps_in_filenames/list_diffs.sh

old=
for i
do :
##echo "*** $0 : \$i=>{$i}"

  if test -z "$old"
  then
    old="$i"
    continue
  fi

  echo diff "$old" "$i"

  old="$i"
done

# set-buffer-file-coding-system
#   iso-latin-1-unix
