:

script=$( basename "$0" )

false &&
printf 1>&2 "=%03.3d: %s=>{%s} // %s\n" $LINENO \
  '$#' "$#" \
  '...' \
  ;

if test $# -eq 1
then :
else :
  printf 1>&2 "=%03.3d: %s=>{%s} // %s\n" $LINENO \
    '$#' "$#" \
    'expected 1' \
    ;
  exit 1
fi

param_filename="$1"

if test -f "${param_filename}"
then :
else :
  printf 1>&2 "=%03.3d: %s=>{%s} // %s\n" $LINENO \
    '$param_filename' "$param_filename" \
    'file does not exist' \
    ;
  exit 1
fi

################################################################################

dirname=$(  dirname  "${param_filename}" )

case "${param_filename}" in
  *.pdf )
    basename=$( basename "${param_filename}" .pdf )
    dirname_basename_minus_extension="${dirname}/${basename}"
    filename="${param_filename}"
    file00="${filename}"
    ;;
esac

################################################################################

file10=
file20="${filename}.%03d.300.png"
file20_etc="-sOutputFile=${file20}"

################################################################################

cmd10=
stderr10=
cmd20="gs -dSAFER -dBATCH -dNOPAUSE -sDEVICE=png16m -r300"
stderr20="${filename}.form-fields.stderr.txt"                                                                                                                          

################################################################################

printf 1>&2 "\n%s: executing:\n\n\t%s\t\t\t%s %s %s %s %s\n" "${script}" "${cmd20}" "${file20_etc}" "${file00}" '2>' "${stderr20}"

: set -x

if ${cmd20} "${file20_etc}" "${file00}" 2> "${stderr20}"
then :
else :
  : set +x
  printf 1>&2 "=%03.3d: %s=>{%s},%s=>{%s},%s=>{%s} // %s\n" $LINENO \
    'filename' "${filename}" \
    'stderr20' "${stderr20}" \
    '$?' "$?" \
    '"'"${cmd20} ${file00}"'" has non-zero exit code' \
    ;

  echo 1>&2 '================================================================================'
  cat  1>&2 "${stderr20}"
  echo 1>&2 '================================================================================'

  : rm      "${stderr20}"
  test      "${file20_is_to_be_removed}" = true &&
  rm        "${file20}"

  exit 1
fi

: set +x

if diff --brief "${stderr20}" /dev/null 1>/dev/null 2>/dev/null
then rm     "${stderr20}"
else :
  : set +x
  printf 1>&2 "=%03.3d: %s=>{%s},%s=>{%s} // %s\n" $LINENO \
    'filename' "${filename}" \
    'stderr20' "${stderr20}" \
    '"'"${cmd20} ${file00}"'" has non-empty stderr' \
    ;

  echo 1>&2 '================================================================================'
  cat  1>&2 "${stderr20}"
  echo 1>&2 '================================================================================'

  : rm      "${stderr20}"
  test      "${file20_is_to_be_removed}" = true &&
  rm        "${file20}"

  exit 1
fi
