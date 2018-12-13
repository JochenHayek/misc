#! /usr/bin/ksh

# sample usage:
#
#   Q: looking for xpdf or anything simlar
#   A: $ ~/git-servers/github.com/JochenHayek/misc/path/find_file_on_PATH.sh '*pdf*'
#   -> .../epdfview
#
#   Q: looking for GNU find
#   A: $ env PATH=$PATH:/usr/local/bin:/usr/local/sbin:/usr/linux/bin:/opt/pware/bin:/opt/pware/sbin ~/git-servers/github.com/JochenHayek/misc/path/find_file_on_PATH.sh '*find*'
#   there is no GNU find (on a separate directory tree) on this AIX system
#
#   Q: looking for EDI*STAR '*maint' utilities
#   A: $ env PATH=$PATH:/usr/local/bin:/usr/local/sbin:/usr/linux/bin:/opt/pware/bin:/opt/pware/sbin ~/git-servers/github.com/JochenHayek/misc/path/find_file_on_PATH.sh '*maint'
#
# quite similar to
#
#   git-servers/resources.oreilly.com/examples/9780596005955/sh/pathfind.sh
#
#     Classic Shell Scripting, by Arnold Robbins
#
################################################################################

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
