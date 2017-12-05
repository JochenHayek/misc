:

# non-cygwin emacs cannot read cygwin symlinks,
# so it's nice to see these 2
# (cygwin symlink and descriptive file)
# aside (e.g.):
#
#   git-servers
#   git-servers.IS_CYGWIN_LINK

##set -x

find . -maxdepth 1 -type l |

while read l
do :

  echo 1>&2 "*** $0: {${l}}"

  file "${l}" |

  perl -ne > "${l}.IS_CYGWIN_LINK" '

  if(m/^ \.\/(?<lhs>.*?) : \s* symbolic \s+ link \s+ to \s+ (?<rhs>.*)  $/x)
    {
      print $+{rhs},"\n";
    }

'

done
