:

# $Id: group_by_content.sh 1.5 2017/10/17 12:35:13 johayek Exp $

# usage:
#
#    md5sum * | ~/bin/group_by_content.sh
#       sum * | ~/bin/group_by_content.sh
# sha512sum * | ~/bin/group_by_content.sh
#
# instead of md5sum you may want to use "sum" or any of the "sha*sum"

# quite similar to /Volumes/home/books-Linux/by-publisher/oreilly.com/by-isbn/oreilly--Classic_Shell_Scripting.20050611/sh/show-identical-files.sh

sort |

perl -ane '

  if($F[0] eq $old_F0)
    {
      print $i;
    }
  else
    {
      $old_F0 = $F[0];
      print "\n",++$i;
    }

  print "\t$_"


'
