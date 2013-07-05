:

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
