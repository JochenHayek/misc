:

# usage:
#
#    md5sum * | ~/bin/group_by_content.sh
#       sum * | ~/bin/group_by_content.sh
# sha512sum * | ~/bin/group_by_content.sh
#
# instead of md5sum you may want to use "sum" or any of the "sha*sum"

# quite similar to a utility at "Classic_Shell_Scripting":
# 
#       https://resources.oreilly.com/examples/9780596005955/blob/master/sh/show-identical-files.sh
#                                                            sh/show-identical-files.sh
# ~/git-servers/resources.oreilly.com/examples/9780596005955/sh/show-identical-files.sh
#
#       https://github.com/JochenHayek/misc/blob/master/shell/group_by_content.sh
#                                           shell/group_by_content.sh
# ~/git-servers/github.com/JochenHayek/misc/shell/group_by_content.sh

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
