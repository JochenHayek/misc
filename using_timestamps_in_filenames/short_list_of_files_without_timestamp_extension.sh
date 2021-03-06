:
#! /bin/sh

# misc/using_timestamps_in_filenames/short_list_of_files_without_timestamp_extension.sh DIRECTORY

# CAVEAT:
#
# does not work for "DOT files".

################################################################################

##PERL='c:/Program Files/Git/usr/bin/perl.exe'
  PERL=perl

################################################################################

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
"${PERL}" -pe 's/\.\d{14}$//' |
uniq
