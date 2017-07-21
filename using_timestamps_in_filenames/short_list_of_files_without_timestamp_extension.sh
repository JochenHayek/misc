:
#! /bin/sh

# misc/using_timestamps_in_filenames/short_list_of_files_without_timestamp_extension.sh

if test $# -eq 1
then :
  dir="$1"
else :
##echo "*** $0 : \$#=>$#,\$1=>{$1}"
  echo "*** $0 : \$#=>$# // exiting"
  exit 1
fi

##/usr/bin/ls -1d                        ${dir}/*.[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9] |
##         ls -1d --indicator-style=none ${dir}/*.[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9] |
  command  ls -1d                        ${dir}/*.[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9] |
perl -pe 's/\.\d{14}$//' |
uniq
