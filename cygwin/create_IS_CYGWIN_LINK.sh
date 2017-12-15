:

# non-cygwin emacs cannot read cygwin symlinks,
# so it's nice to see these 2
# (cygwin symlink and descriptive file)
# aside (e.g.):
#
#   git-servers
#   git-servers.IS_CYGWIN_LINK

# special treatment of a couple of directories:
#
#   $USERPROFILE/git-servers/

##set -x

find . -maxdepth 1 -type l |

while read l
do :

  echo 1>&2 "*** $0: {${l}}"

  readlink "${l}" |

  perl -ne > "${l}.IS_CYGWIN_LINK" '

  if(m/^ (?<rhs>.*)  $/x)
    {
      my(%plus) = %+;

      if($plus{rhs} =~ s,^ (\.\./)* git-servers /,\$USERPROFILE/git-servers/,x)
        {
        }

      print $plus{rhs},"\n";
    }

'

  if touch --reference="${l}" "${l}.IS_CYGWIN_LINK"
  then :
  else :
    echo 1>&2 "*** $0: {${l}} : touch : \$?=>$?"
    rm --verbose "${l}" "${l}.IS_CYGWIN_LINK"
  fi

done

exit 0

################################################################################


find . -maxdepth 1 -type l |

while read l
do :

  echo 1>&2 "*** $0: {${l}}"

  file "${l}" |

  perl -ne > "${l}.IS_CYGWIN_LINK" '

  if(m/^ \.\/(?<lhs>.*?) : \s* symbolic \s+ link \s+ to \s+ (?<rhs>.*)  $/x)
    {
      my(%plus) = %+;

      # CAVEAT / TBD: should this not be right-anchored?!!

      if($plus{rhs} =~ s,^ (\.\./)* git-servers ,\$USERPROFILE/git-servers,x)
        {
        }

      print $plus{rhs},"\n";
    }

'

  if touch --reference="${l}" "${l}.IS_CYGWIN_LINK"
  then :
  else :
    echo 1>&2 "*** $0: {${l}} : touch : \$?=>$?"
    rm --verbose "${l}" "${l}.IS_CYGWIN_LINK"
  fi

done
