:

# $ .../list_snapshot_diffs.sh Rakefile
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

if test $# -eq 1
then :
  f="$1"
else :
##echo "*** $0 : \$#=>$#,\$1=>{$1}"
  echo "*** $0 : \$#=>$# // exiting"
  exit 1
fi

old=
for i in ${f}.[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]
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
