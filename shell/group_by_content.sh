:

# $Id: group_by_content.sh 1.4 2013/09/13 14:03:08 johayek Exp $

# usage:
#
# md5sum * | ~/bin/group_by_content.sh

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
