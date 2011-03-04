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

JR_HOME=/usr/local/jasperreports-3.7.1
alias a_java_TextApp="java -classpath $HOME/usr/JasperReports-TextAppX-3/lib:$JR_HOME/build/classes:$JR_HOME/demo/fonts:/usr/local/commons-cli-1.2/commons-cli-1.2.jar:$JR_HOME/lib/* TextApp"
java_TextApp="java -classpath $HOME/usr/JasperReports-TextAppX-3/lib:$JR_HOME/build/classes:$JR_HOME/demo/fonts:/usr/local/commons-cli-1.2/commons-cli-1.2.jar:$JR_HOME/lib/* TextApp"

################################################################################

dirname=$(  dirname  "${param_filename}" )

case "${param_filename}" in
  *.pdf )
    basename=$( basename "${param_filename}" .pdf )
    start_version=pdf

    # leave all files, also the intermediate ones:

    file11_is_to_be_removed=false

    file20_is_to_be_removed=false
    file21_is_to_be_removed=false

    file30_is_to_be_removed=false

    file40_is_to_be_removed=false
    file41_is_to_be_removed=false

    file50_is_to_be_removed=false
    file51_is_to_be_removed=false

    file611_is_to_be_removed=false
    file61_is_to_be_removed=false

    ################################################################################

    file11_is_to_be_removed=false
    file11_is_to_be_removed=true

    file20_is_to_be_removed=false
    file21_is_to_be_removed=false
    file20_is_to_be_removed=true
    file21_is_to_be_removed=true

    file30_is_to_be_removed=false

    file40_is_to_be_removed=true
    file41_is_to_be_removed=true
    file40_is_to_be_removed=false
    file41_is_to_be_removed=false

    file50_is_to_be_removed=false
    file51_is_to_be_removed=true

    file611_is_to_be_removed=true
    file61_is_to_be_removed=false

    ################################################################################

    dirname_basename_minus_extension="${dirname}/${basename}"

    if false
    then :
      filename="${dirname_basename_minus_extension}"

      file00="${filename}.pdf"
    else :
      filename="${param_filename}"

      file00="${filename}"
    fi
    ;;
  *.form.xml )
    basename=$( basename "${param_filename}" .pdf.form.xml )
    start_version=form.xml

    file30_is_to_be_removed=false

    file40_is_to_be_removed=true
    file41_is_to_be_removed=true
    file40_is_to_be_removed=false
    file41_is_to_be_removed=false

    file50_is_to_be_removed=false
    file51_is_to_be_removed=true

    file611_is_to_be_removed=true
    file61_is_to_be_removed=false

    ################################################################################

    dirname_basename_minus_extension="${dirname}/${basename}"

    if true
    then :
      filename="${dirname_basename_minus_extension}.pdf"

      file00="${filename}.pdf"
    elif false
    then :
      filename="${dirname_basename_minus_extension}"

      file00="${filename}.pdf"
    else :
      filename="${param_filename}"

      file00="${filename}"
    fi
    ;;
esac

################################################################################

case "${start_version}" in
  pdf )
    ;;
  form.xml )
    ;;
esac

################################################################################

file10=
file20="${filename}.form-fields.xml"

file11="${filename}.pdftohtml_xml.xml"
file21="${filename}.form-strings.xml"

file30="${filename}.form.xml"

file40="${filename}.jrxml"
file41="${filename}.P.jrxml"

file50="${filename}.jasper"
file51="${filename}.P.jasper"

file611="${filename}.P-sample.jrprint"
file61="${filename}.P-sample.pdf"

################################################################################

# once I filled out gav_gw_100011.pdf

# using "-nodrm" with "pdftohtml -xml -stdout", because of this (occasional) warning: "Document has copy-protection bit set."

cmd10=
stderr10=
cmd20="$HOME/Computers/Programming/Languages/Perl/listpdffields-JH.pl --xml --sort_by_geometry --page_height=1263 --page_width=892 --geometry_origin=upper_left --y_offset=343 --x_offset=31"
cmd20="$HOME/Computers/Programming/Languages/Perl/listpdffields-JH.pl --xml --sort_by_geometry --page_height=842  --page_width=595 --geometry_origin=upper_left --y_offset=0   --x_offset=0"
stderr20="${filename}.form-fields.stderr.txt"                                                                                                                          
												                                          
# HtmlOutputDev.h : virtual GBool upsideDown() { return gFalse; }				                                          
if false											                                          
then :												                                          
  cmd11="/usr/local/src/tmp/pdftohtml-0.40a/src/pdftohtml -xml -stdout"                                                                                                                           
  stderr11="${filename}.pdftohtml_xml.stderr.txt"                                                                                                                      
  cmd21="$HOME/Computers/Programming/Languages/Perl/pdftohtml-xml_2_form.pl                    --page_height=1263 --page_width=892 --geometry_origin=upper_left"
  stderr21="${filename}.form-strings.stderr.txt"					                                          
fi											                                          
											                                          
cmd11="pdftohtml -xml -stdout -nodrm"                                                                                                                          
stderr11="${filename}.pdftohtml_xml.stderr.txt"                                                                                                                
cmd21="$HOME/Computers/Programming/Languages/Perl/pdftohtml-xml_2_form.pl                      --page_height=842  --page_width=595 --geometry_origin=upper_left"
stderr21="${filename}.form-strings.stderr.txt"                                                                                                     

cmd30="$HOME/Computers/Programming/Languages/Perl/form_cat.pl"                                                                                     
stderr30="${filename}.form.stderr.txt"                                                                                                             

# alternatively: --form_fields_op=REPORT_PARAMETERS_MAP
# alternatively: --form_fields_op=simply_P
# alternatively: --form_fields_op=field_name_only

################################################################################

cmd40="$HOME/Computers/Programming/Languages/Perl/form2jrxml.pl 			       --page_height=842  --page_width=595 --form_fields_op=REPORT_PARAMETERS_MAP --font_name=Arial_Unicode_MS --vertical_alignment=Middle"
stderr40="${filename}.form2jrxml.stderr.txt"											                                         
																                                         
cmd41="$HOME/Computers/Programming/Languages/Perl/form2jrxml.pl 			       --page_height=842  --page_width=595 --form_fields_op=simply_P              --font_name=DejaVu_Sans      --vertical_alignment=Middle"
stderr41="${filename}.form2jrxml.stderr.txt"

################################################################################

cmd50_task="-DtaskName=compile_extended"
cmd50="$java_TextApp $cmd50_task"
cmd50_short="TextApp $cmd50_task"
stderr50="${filename}.TextAppX-jasper.stderr.txt"

##cmd51_task="-DtaskName=compile_extended"
##cmd51="$java_TextApp $cmd51_task"
##cmd51_short="TextApp $cmd51_task"
stderr51="${filename}.TextAppX-jasper.P.stderr.txt"

################################################################################

##cmd61_task="-DtaskName=fill_n_pdf"
cmd61_task="-DtaskName=compile_n_fill_n_pdf"
cmd61="$java_TextApp $cmd61_task"
cmd61_short="TextApp $cmd61_task"
stderr61="${filename}.TextAppX-pdf.stderr.txt"

################################################################################


case "${start_version}" in
  form.xml )
    ;;
  * )
    if test -e "${file30}"
    then :
      printf 1>&2 "=%03.3d: %s=>{%s} // %s\n" $LINENO \
	'$file30' "$file30" \
	'file already exists' \
	;
      exit 1
    fi
    ;;
esac

if test -e "${file40}"
then :
  printf 1>&2 "=%03.3d: %s=>{%s} // %s\n" $LINENO \
    '$file40' "$file40" \
    'file already exists' \
    ;
  exit 1
fi

################################################################################

case "${start_version}" in
  pdf )

    printf 1>&2 "\n%s: executing:\n\n\t%s\t\t\t%s\n" "${script}" "${cmd11}" "${file00}"

    : set -x

    if ${cmd11} "${file00}" > "${file11}" 2> "${stderr11}"
    then :
    else :
      : set +x
      printf 1>&2 "=%03.3d: %s=>{%s},%s=>{%s},%s=>{%s} // %s\n" $LINENO \
	'file00' "${file00}" \
	'stderr11' "${stderr11}" \
	'$?' "$?" \
	'"'"${cmd11} ${file00}"'" has non-zero exit code' \
	;

      echo 1>&2 '================================================================================'
      cat  1>&2 "${stderr11}"
      echo 1>&2 '================================================================================'

      : rm      "${stderr11}"
      test      "${file11_is_to_be_removed}" = true &&
      rm        "${file11}"

      exit 1
    fi

    : set +x

    if   echo 'Document has copy-protection bit set.' | diff --brief "${stderr11}" - 1>/dev/null 2>/dev/null # I don't really mind this
    then rm     "${stderr11}"
    elif diff --brief "${stderr11}" /dev/null 1>/dev/null 2>/dev/null
    then rm     "${stderr11}"
    else :
      : set +x
      printf 1>&2 "=%03.3d: %s=>{%s},%s=>{%s} // %s\n" $LINENO \
	'file00' "${file00}" \
	'stderr11' "${stderr11}" \
	'"'"${cmd11} ${file00}"'" has non-empty stderr' \
	;

      echo 1>&2 '================================================================================'
      cat  1>&2 "${stderr11}"
      echo 1>&2 '================================================================================'

      : rm      "${stderr11}"
      test      "${file11_is_to_be_removed}" = true &&
      rm        "${file11}"

      exit 1
    fi

    ;;
esac

################################################################################

case "${start_version}" in
  pdf )

    printf 1>&2 "\n%s: executing:\n\n\t%s\t\t\t%s %s %s %s %s\n" "${script}" "${cmd21}" "${file11}" '>' "${file21}" '2>' "${stderr21}"

    : set -x

    if ${cmd21} "${file11}" > "${file21}" 2> "${stderr21}"
    then :
    else :
      : set +x
      printf 1>&2 "=%03.3d: %s=>{%s},%s=>{%s},%s=>{%s} // %s\n" $LINENO \
	'filename' "${filename}" \
	'stderr21' "${stderr21}" \
	'$?' "$?" \
	'"'"${cmd21} ${file11}"'" has non-zero exit code' \
	;

      echo 1>&2 '================================================================================'
      cat  1>&2 "${stderr21}"
      echo 1>&2 '================================================================================'

      : rm      "${stderr21}"
      rm        "${file21}"
      test      "${file11_is_to_be_removed}" = true &&
      rm        "${file11}"

      exit 1
    fi

    : set +x

    if diff --brief "${stderr21}" /dev/null 1>/dev/null 2>/dev/null
    then rm     "${stderr21}"
      test      "${file11_is_to_be_removed}" = true &&
      rm        "${file11}"
    else :
      : set +x
      printf 1>&2 "=%03.3d: %s=>{%s},%s=>{%s} // %s\n" $LINENO \
	'filename' "${filename}" \
	'stderr21' "${stderr21}" \
	'"'"${cmd21} ${file11}"'" has non-empty stderr' \
	;

      echo 1>&2 '================================================================================'
      cat  1>&2 "${stderr21}"
      echo 1>&2 '================================================================================'

      : rm      "${stderr21}"
      rm        "${file21}"
      test      "${file11_is_to_be_removed}" = true &&
      rm        "${file11}"

      exit 1
    fi

    ;;
esac

################################################################################

case "${start_version}" in
  pdf )

    printf 1>&2 "\n%s: executing:\n\n\t%s\t\t\t%s %s %s %s %s\n" "${script}" "${cmd20}" "${file00}" '>' "${file20}" '2>' "${stderr20}"

    : set -x

    if ${cmd20} "${file00}" > "${file20}" 2> "${stderr20}"
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

    ;;
esac

################################################################################

case "${start_version}" in
  pdf )

    printf 1>&2 "\n%s: executing:\n\n\t%s\t\t\t%s %s %s %s %s %s\n" "${script}" "${cmd30}" "${file20}" "${file21}" '>' "${file30}" '2>' "${stderr30}"

    : set -x

    if ${cmd30} "${file20}" "${file21}" > "${file30}" 2> "${stderr30}"
    then :
    else :
      : set +x
      printf 1>&2 "=%03.3d: %s=>{%s},%s=>{%s},%s=>{%s} // %s\n" $LINENO \
	'filename' "${filename}" \
	'stderr30' "${stderr30}" \
	'$?' "$?" \
	'"'"${cmd30} ${file20} ${file21}"'" has non-zero exit code' \
	;

      echo 1>&2 '================================================================================'
      cat  1>&2 "${stderr30}"
      echo 1>&2 '================================================================================'

      : rm      "${stderr30}"
      rm        "${file30}"  "${file21}"
      test      "${file20_is_to_be_removed}" = true &&
      rm        "${file20}"

      exit 1
    fi

    : set +x

    if diff --brief "${stderr30}" /dev/null 1>/dev/null 2>/dev/null
    then rm     "${stderr30}"
      test "${file20_is_to_be_removed}" = true &&
      rm   "${file20}"
      test "${file21_is_to_be_removed}" = true &&
      rm   "${file21}"
    else :
      : set +x
      printf 1>&2 "=%03.3d: %s=>{%s},%s=>{%s} // %s\n" $LINENO \
	'filename' "${filename}" \
	'stderr30' "${stderr30}" \
	'"'"${cmd30} ${file20} ${file21}"'" has non-empty stderr' \
	;

      echo 1>&2 '================================================================================'
      cat  1>&2 "${stderr30}"
      echo 1>&2 '================================================================================'

      : rm      "${stderr30}"
      rm        "${file30}"  "${file21}"
      test      "${file20_is_to_be_removed}" = true &&
      rm        "${file20}"

      exit 1
    fi

    ;;
esac

################################################################################

printf 1>&2 "\n%s: executing:\n\n\t%s\t\t\t%s %s %s %s %s\n" "${script}" "${cmd40}" "${file30}" '>' "${file40}" '2>' "${stderr40}"

: set -x

if ${cmd40} "${file30}" > "${file40}" 2> "${stderr40}"
then :
else :
  : set +x
  printf 1>&2 "=%03.3d: %s=>{%s},%s=>{%s},%s=>{%s} // %s\n" $LINENO \
    'filename' "${filename}" \
    'stderr40' "${stderr40}" \
    '$?' "$?" \
    '"'"${cmd40} ${file30}"'" has non-zero exit code' \
    ;

  echo 1>&2 '================================================================================'
  cat  1>&2 "${stderr40}"
  echo 1>&2 '================================================================================'

  : rm      "${stderr40}"

  test 	    "${file40_is_to_be_removed}" = true &&
  rm   	    "${file40}"

  false &&
  rm        "${file30}"

  exit 1
fi

: set +x

if diff --brief "${stderr40}" /dev/null 1>/dev/null 2>/dev/null
then rm     "${stderr40}"
  test "${file30_is_to_be_removed}" = true &&
  rm   "${file30}"
else :
  : set +x
  printf 1>&2 "=%03.3d: %s=>{%s},%s=>{%s} // %s\n" $LINENO \
    'filename' "${filename}" \
    'stderr40' "${stderr40}" \
    '"'"${cmd40} ${file30}"'" has non-empty stderr' \
    ;

  echo 1>&2 '================================================================================'
  cat  1>&2 "${stderr40}"
  echo 1>&2 '================================================================================'

  : rm      "${stderr40}"

  test 	    "${file40_is_to_be_removed}" = true &&
  rm   	    "${file40}"

  false &&
  rm        "${file30}"

  : exit 1
fi

################################################################################

printf 1>&2 "\n%s: executing:\n\n\t%s\t\t\t%s %s %s %s\n" "${script}" "${cmd50_short}" "-DjrxmlFileName=${file40}" "-DjasperFileName=${file50}" '2>' "${stderr50}"

: set -x

if ${cmd50} "-DjrxmlFileName=${file40}" "-DjasperFileName=${file50}" 2> "${stderr50}"
then :
else :
  : set +x
  printf 1>&2 "=%03.3d: %s=>{%s},%s=>{%s},%s=>{%s} // %s\n" $LINENO \
    'filename' "${filename}" \
    'stderr50' "${stderr50}" \
    '$?' "$?" \
    '"'"${cmd50_short} ${file40}"'" has non-zero exit code' \
    ;

  echo 1>&2 '================================================================================'
  cat  1>&2 "${stderr50}"
  echo 1>&2 '================================================================================'

  : rm      "${stderr50}"

  test 	    "${file50_is_to_be_removed}" = true &&
  rm   	    "${file50}"

  false &&
  rm        "${file40}"

  exit 1
fi

: set +x

if diff --brief "${stderr50}" /dev/null 1>/dev/null 2>/dev/null
then rm     "${stderr50}"
  test "${file40_is_to_be_removed}" = true &&
  rm   "${file40}"
else :
  : set +x
  printf 1>&2 "=%03.3d: %s=>{%s},%s=>{%s} // %s\n" $LINENO \
    'filename' "${filename}" \
    'stderr50' "${stderr50}" \
    '"'"${cmd50_short} ${file40} ${file50}"'" has non-empty stderr' \
    ;

  echo 1>&2 '================================================================================'
  cat  1>&2 "${stderr50}"
  echo 1>&2 '================================================================================'

  : rm      "${stderr50}"

  test 	    "${file50_is_to_be_removed}" = true &&
  rm   	    "${file50}"

  false &&
  rm        "${file40}"

  exit 1
fi

################################################################################

printf 1>&2 "\n%s: executing:\n\n\t%s\t\t\t%s %s %s %s %s\n" "${script}" "${cmd41}" "${file30}" '>' "${file41}" '2>' "${stderr41}"

: set -x

if ${cmd41} "${file30}" > "${file41}" 2> "${stderr41}"
then :
else :
  : set +x
  printf 1>&2 "=%03.3d: %s=>{%s},%s=>{%s},%s=>{%s} // %s\n" $LINENO \
    'filename' "${filename}" \
    'stderr41' "${stderr41}" \
    '$?' "$?" \
    '"'"${cmd41} ${file30}"'" has non-zero exit code' \
    ;

  echo 1>&2 '================================================================================'
  cat  1>&2 "${stderr41}"
  echo 1>&2 '================================================================================'

  : rm      "${stderr41}"

  test 	    "${file41_is_to_be_removed}" = true &&
  rm   	    "${file41}"

  false &&
  rm        "${file30}"

  exit 1
fi

: set +x

if diff --brief "${stderr41}" /dev/null 1>/dev/null 2>/dev/null
then rm     "${stderr41}"
  test "${file30_is_to_be_removed}" = true &&
  rm   "${file30}"
else :
  : set +x
  printf 1>&2 "=%03.3d: %s=>{%s},%s=>{%s} // %s\n" $LINENO \
    'filename' "${filename}" \
    'stderr41' "${stderr41}" \
    '"'"${cmd41} ${file30}"'" has non-empty stderr' \
    ;

  echo 1>&2 '================================================================================'
  cat  1>&2 "${stderr41}"
  echo 1>&2 '================================================================================'

  : rm      "${stderr41}"

  test 	    "${file41_is_to_be_removed}" = true &&
  rm   	    "${file41}"

  false &&
  rm        "${file30}"

  : exit 1
fi

################################################################################

if false
then :

  printf 1>&2 "\n%s: executing:\n\n\t%s\t\t\t%s %s %s %s\n" "${script}" "${cmd50_short}" "-DjrxmlFileName=${file41}" "-DjasperFileName=${file51}" '2>' "${stderr51}"

  : set -x

  if ${cmd50} "-DjrxmlFileName=${file41}" "-DjasperFileName=${file51}" 2> "${stderr51}"
  then :
  else :
    : set +x
    printf 1>&2 "=%03.3d: %s=>{%s},%s=>{%s},%s=>{%s} // %s\n" $LINENO \
      'filename' "${filename}" \
      'stderr51' "${stderr51}" \
      '$?' "$?" \
      '"'"${cmd50_short} ${file41}"'" has non-zero exit code' \
      ;

    echo 1>&2 '================================================================================'
    cat  1>&2 "${stderr51}"
    echo 1>&2 '================================================================================'

    : rm      "${stderr51}"

    test 	    "${file51_is_to_be_removed}" = true &&
    rm   	    "${file51}"

    false &&
    rm        "${file41}"

    exit 1
  fi

  : set +x

  if diff --brief "${stderr51}" /dev/null 1>/dev/null 2>/dev/null
  then rm     "${stderr51}"
    test "${file41_is_to_be_removed}" = true &&
    rm   "${file41}"
  else :
    : set +x
    printf 1>&2 "=%03.3d: %s=>{%s},%s=>{%s} // %s\n" $LINENO \
      'filename' "${filename}" \
      'stderr51' "${stderr51}" \
      '"'"${cmd50_short} ${file41} ${file51}"'" has non-empty stderr' \
      ;

    echo 1>&2 '================================================================================'
    cat  1>&2 "${stderr51}"
    echo 1>&2 '================================================================================'

    : rm      "${stderr51}"

    test 	    "${file51_is_to_be_removed}" = true &&
    rm   	    "${file51}"

    false &&
    rm        "${file41}"

    exit 1
fi

fi

################################################################################

: exit 0

################################################################################

printf 1>&2 "\n%s: executing:\n\n\t%s\t\t\t%s %s %s %s %s %s\n" "${script}" "${cmd61_short}" "-DjrxmlFileName=${file41}" "-DjasperFileName=${file51}" "-DjrprintFileName=${file611}" "-DpdfFileName=${file61}" '2>' "${stderr61}"

: set -x

if ${cmd61} "-DjrxmlFileName=${file41}" "-DjasperFileName=${file51}" "-DjrprintFileName=${file611}" "-DpdfFileName=${file61}" 2> "${stderr61}" \
  ;
then :
  test 	    "${file611_is_to_be_removed}" = true &&
  rm   	    "${file611}"
else :
  : set +x
  printf 1>&2 "=%03.3d: %s=>{%s},%s=>{%s},%s=>{%s} // %s\n" $LINENO \
    'filename' "${filename}" \
    'stderr61' "${stderr61}" \
    '$?' "$?" \
    '"'"${cmd61_short} ${file51}"'" has non-zero exit code' \
    ;

  echo 1>&2 '================================================================================'
  cat  1>&2 "${stderr61}"
  echo 1>&2 '================================================================================'

  : rm      "${stderr61}"

  test 	    "${file611_is_to_be_removed}" = true &&
  rm   	    "${file611}"

  test 	    "${file61_is_to_be_removed}" = true &&
  rm   	    "${file61}"

  false &&
  rm        "${file51}"

  exit 1
fi

: set +x

if diff --brief "${stderr61}" /dev/null 1>/dev/null 2>/dev/null
then rm     "${stderr61}"
  test "${file51_is_to_be_removed}" = true &&
  rm   "${file51}"
else :
  : set +x
  printf 1>&2 "=%03.3d: %s=>{%s},%s=>{%s} // %s\n" $LINENO \
    'filename' "${filename}" \
    'stderr61' "${stderr61}" \
    '"'"${cmd61_short} ${file51} ${file61}"'" has non-empty stderr' \
    ;

  echo 1>&2 '================================================================================'
  cat  1>&2 "${stderr61}"
  echo 1>&2 '================================================================================'

  : rm      "${stderr61}"

  test 	    "${file611_is_to_be_removed}" = true &&
  rm   	    "${file611}"

  test 	    "${file61_is_to_be_removed}" = true &&
  rm   	    "${file61}"

  false &&
  rm        "${file51}"

  exit 1
fi

################################################################################

exit 0

################################################################################

a_java_TextApp -DtaskName=compile_extended  -DjrxmlFileName=gav_gw_100011.pdf.jrxml   -DjasperFileName=gav_gw_100011.pdf.jasper

a_java_TextApp -DtaskName=fill_n_pdf       -DjasperFileName=gav_gw_100011.pdf.jasper -DjrprintFileName=gav_gw_100011.pdf.jrprint -DpdfFileName=gav_gw_100011.pdf.pdf

a_java_TextApp -DtaskName=fill_extended    -DjasperFileName=gav_gw_100011.pdf.jasper -DjrprintFileName=gav_gw_100011.pdf.jrprint "-Ddriver=org.hsqldb.jdbcDriver" "-DconnectString=jdbc:hsqldb:hsql://localhost" "-Duser=sa" "-Dpassword=" \
  -Pwatermark=watermark \
  -Pdisclaimer=disclaimer \
  -PFD1=FD1 \
  -PFD2=FD2 \
  -PFD3=FD3 \
  -PFD4=FD4 \
  -PFD5=FD5 \
  -PFD6=FD6 \
  -PFD7=FD7 \
  -PFD8=FD8 \
  -PFL1=FL1 \
  -PFL2=FL2 \
  -PFL3=FL3 \
  -PFL4=FL4 \
  -PFL5=FL5 \
  -PFL6=FL6 \
  -PFL7=FL7 \
  -PFL8=FL8 \
  -PGD1=GD1 \
  -PGD1=GD1 \
  -PGD2=GD2 \
  -PGD2=GD2 \
  -PGD3=GD3 \
  -PGD4=GD4 \
  -PGD5=GD5 \
  -PGD6=GD6 \
  -PGD7=GD7 \
  -PGD8=GD8 \
  -PGL1=GL1 \
  -PGL2=GL2 \
  -PGL3=GL3 \
  -PGL4=GL4 \
  -PGL5=GL5 \
  -PGL6=GL6 \
  -PGL7=GL7 \
  -PGL8=GL8 \
  -PGP=GP \
  -PHD1=HD1 \
  -PHD2=HD2 \
  -PHD3=HD3 \
  -PHD4=HD4 \
  -PHD5=HD5 \
  -PHD6=HD6 \
  -PHD7=HD7 \
  -PHD8=HD8 \
  -PHL6=HL6 \
  -PHL7=HL7 \
  -PHL8=HL8 \
  -PKD1=KD1 \
  -PKD2=KD2 \
  -PKD3=KD3 \
  -PKD4=KD4 \
  -PKD5=KD5 \
  -PSBTXT=SBTXT \
  ;

################################################################################

$java_TextApp -DtaskName=xml        -DjrprintFileName=gav_gw_100011.pdf.jrprint

################################################################################


