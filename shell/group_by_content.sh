:

# $Id: group_by_content.sh 1.3 2013/07/08 12:02:14 johayek Exp $

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
