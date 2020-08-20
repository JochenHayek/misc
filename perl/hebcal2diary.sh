:

if cd ~/Computers/Programming/Languages/Perl/hebcal2diary.t
then :
else :
  printf 1>&2 "=%03.3d: // %s\n" $LINENO \
    'cannot chdir' \
    ;
  exit 1
fi

for f in *.csv
##for f in hebcal--torah-readings-diaspora.csv
##for f in hebcal_20*.csv
do :
  false &&
  printf 1>&2 "=%03.3d: %s=>{%s} // %s\n" $LINENO \
    '$f' "${f}" \
    '...' \
    ;

  case "${f}" in
    hebcal_20*.csv )
      date_format='day-month-year'
      ;;
    hebcal--torah-readings-diaspora.csv )
      date_format='month-day-year'
      ;;
  esac

  printf 1>&2 "=%03.3d: %s=>{%s},%s=>{%s} // %s\n" $LINENO \
    '$f' "${f}" \
    '$date_format' "${date_format}" \
    '...' \
    ;

  if $HOME/git-servers/github.com/JochenHayek/misc/perl/hebcal2diary.pl -date_format="${date_format}" "${f}" > $(basename "${f}" .csv).diary
  then :
  else :
    printf 1>&2 "=%03.3d: %s=>{%d} // %s\n" $LINENO \
      '$?' $? \
      'cannot ...' \
      ;
    exit 1
  fi
done
