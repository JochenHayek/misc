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

cmd10=
stderr10=

stderr20="${filename}.form-fields.stderr.txt"                                                                                                                          

################################################################################

file10=

# pnggray : Grayscale PNG
# png16   : 16-Color  	     ( 4-bit) PNG
# png256  : 256-Color 	     ( 8-bit) PNG
# png16m  : 16-Million Color (14-bit) PNG

# [2011-03-04 14:14:59] johayek@HayekU $ file gav_gw_100011.pdf.001.png*
# gav_gw_100011.pdf.001.png16m-r300.png:  PNG image data, 2479 x 3508, 8-bit/color RGB, non-interlaced
# gav_gw_100011.pdf.001.png16m.png:       PNG image data, 595 x 842, 8-bit/color RGB, non-interlaced
# gav_gw_100011.pdf.001.pnggray-r300.png: PNG image data, 2479 x 3508, 8-bit grayscale, non-interlaced
# gav_gw_100011.pdf.001.pnggray.png:      PNG image data, 595 x 842, 8-bit grayscale, non-interlaced


  cmd20="gs -dSAFER -dBATCH -dNOPAUSE -sDEVICE=png16m"
  file20="${filename}.%03d.png16m.png"

  cmd20="gs -dSAFER -dBATCH -dNOPAUSE -sDEVICE=png16m  -r300"
  file20="${filename}.%03d.png16m-r300.png"

  cmd20="gs -dSAFER -dBATCH -dNOPAUSE -sDEVICE=pnggray"
  file20="${filename}.%03d.pnggray.png"

  cmd20="gs -dSAFER -dBATCH -dNOPAUSE -sDEVICE=pnggray -r300"
  file20="${filename}.%03d.pnggray-r300.png"



  cmd20="gs -dSAFER -dBATCH -dNOPAUSE -sDEVICE=png16m -r300"
  file20="${filename}.%03d.png16m-r300.png"

file20_etc="-sOutputFile=${file20}"

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
