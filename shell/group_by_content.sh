:

# $Id: group_by_content.sh 1.6 2017/11/14 11:45:58 johayek Exp $

# usage:
#
#    md5sum * | ~/bin/group_by_content.sh
#       sum * | ~/bin/group_by_content.sh
# sha512sum * | ~/bin/group_by_content.sh
#
# instead of md5sum you may want to use "sum" or any of the "sha*sum"

# quite similar to a utility at "Classic_Shell_Scripting":
#   ~/git-servers/resources.oreilly.com/examples/9780596005955/sh/show-identical-files.sh

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
