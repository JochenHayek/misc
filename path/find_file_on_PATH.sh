#! /usr/bin/ksh

# Q: looking for xpdf or anything simlar
# A: $ ~/Computers/Software/Operating_Systems/Unix/Shell/find_file_on_PATH.ksh '*pdf*'
# -> .../epdfview

# Q: looking for GNU find
# A: $ env PATH=$PATH:/usr/local/bin:/usr/local/sbin:/usr/linux/bin:/opt/pware/bin:/opt/pware/sbin /home/extjh/bin/find_file_on_PATH.ksh '*find*'
# there is no GNU find (on a separate directory tree) on this AIX system

# Q: looking for EDI*STAR '*maint' utilities
# A: $ env PATH=$PATH:/usr/local/bin:/usr/local/sbin:/usr/linux/bin:/opt/pware/bin:/opt/pware/sbin /home/extjh/bin/find_file_on_PATH.ksh '*maint'

# quite similar to /Volumes/home/books-Linux/by-publisher/oreilly.com/by-isbn/oreilly--Classic_Shell_Scripting.20050611/sh/pathfind.sh

if test $# -eq 1
then :
else :
    printf "=%s: %s=>{%s} // %s\n" $0 \
	'$#' $# \
	'...'
    exit 1
fi

echo $PATH | tr : '\n' |
while read d
do :
  ##echo "\n\n\t$0: $d :\n"
  ls -1d $d/$1 2>/dev/null
done
