:

# similar files:
#
#   ~/git-servers/ber.jochen.hayek.name/johayek/banks/utilities/rest-hibiscus-konto-id-json2csv.t/run.sh
#   ~/git-servers/github.com/JochenHayek/misc/diary/ics2diary.t/run.sh

################################################################################

case "$HOSTNAME" in
  DiskStation*)
    R=$HOME/transient--9--ultra-short-term
    PERL=/opt/bin/perl
    XARGS=/usr/bin/xargs
    ;;
  Hayek001* | Hayek001.fritz.box | Hayek003* | Hayek003.fritz.box )
    R=$HOME
    PERL=/usr/bin/perl
    XARGS=/usr/bin/xargs
    ;;
  *)
    R=$HOME
    PERL=/usr/local/perlbrew/perls/stable/bin/perl
    XARGS=xargs
    ;;
esac

##DIFF='diff -c'
DIFF='diff --context=2'
##DIFF=diff

utility=$R/git-servers/github.com/JochenHayek/misc/diary/ics2diary.pl

if "$PERL" -c "$utility"
then :
else
  echo "*** $0: exiting"
  exit 1
fi

if false
then :

  # previously also: *.json.location_no2name__dump.txt *.json.options

  /bin/ls -1d *-statement.{csv,{creditors,locations}.{xml,options}} 2>/dev/null |

  ##"$XARGS" --no-run-if-empty rm --verbose # -r = --no-run-if-empty
  "$XARGS"   		     rm --verbose

fi

suffix_in=.ics
suffix_out=.ics.diary

for i_source in *.ics
do
  : echo "*** ${i_source} ***"
  : echo "*** $0: ${i_source}"
  i=$(basename ${i_source} ${suffix_in})
  echo "*** $0: $i"

  "$PERL" "$utility" "${i_source}" > "${i}${suffix_out}" &&

  if test -f "${i}${suffix_out}.REF"
  then :

    if ${DIFF} ${i}${suffix_out}.REF "${i}${suffix_out}"
    then
      rm                             "${i}${suffix_out}"
    else :
      echo "*** $0: ${i} // ${DIFF} ${i}${suffix_out}.REF '${i}${suffix_out}'"
    fi

  else :
    echo "*** $0: ${i} // ${i}${suffix_out}.REF does not exist"
  fi

done

exit 0
