:

# $ ~/bin/purge_snapshots.sh DIR

if test $# -eq 1
then :
  dir="$1"
else :
##echo "*** $0 : \$#=>$#,\$1=>{$1}"
  echo "*** $0 : \$#=>$# // exiting"
  exit 1
fi

$HOME/bin/short_list_of_files_without_timestamp_extension.sh "$dir" |

while read f
do :
  echo "*** $0 : \$f=>{$f}"

  old=
  for i in ${f}.[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]
  do :
    echo "*** $0 : \$i=>{$i}"

    if test -z "$old"
    then
      old="$i"
      continue
    fi

    if cmp --silent "$old" "$i"
    then :
    ##echo "*** $0 : going to rm {$i}"
      rm --verbose "$i"
    else :
      old="$i"
    fi
  done
done
