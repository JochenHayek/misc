:

# $ ~/Computers/Programming/Languages/Perl/table_pdf2csv.sh ...

# find samples at ~/Computers/Programming/Languages/Perl/table_pdf2csv.dir/

# $ ~/Computers/Programming/Languages/Perl/table_pdf2csv.sh List_of_Disciplinary_Actions.pdf

# derived from lohnabrechnung_pdf2xml.sh on 2012-01-07

################################################################################

script=$( basename "$0" )

perl_script=$( dirname "$0" )/$(basename "$0" .sh ).pl

# on OS X use our self-compiled pdftohtml-0.40a at 

##pdftohtml=$HOME/usr/local/bin/pdftohtml
  pdftohtml=pdftohtml

################################################################################

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
    ;;
  * )
    printf 1>&2 "=%03.3d: %s=>{%s} // %s\n" $LINENO \
      '$param_filename' "$param_filename" \
      'unexpected extension' \
      ;
    exit 1
    ;;
esac

true &&
printf 1>&2 "=%03.3d: %s=>{%s} // %s\n" $LINENO \
  '$param_filename' "$param_filename" \
  '...' \
  ;

################################################################################

tmp_dir=$( mktemp --directory /tmp/XXXXXXX )

tmp_pdftohtml_xml_fn_without_extension="${tmp_dir}/pdftohtml-xml"

true &&
printf 1>&2 "=%03.3d: %s=>{%s},%s=>{%s} // %s\n" $LINENO \
  '$tmp_dir' "$tmp_dir" \
  '$tmp_pdftohtml_xml_fn_without_extension' "$tmp_pdftohtml_xml_fn_without_extension" \
  '...' \
  ;

################################################################################

printf 1>&2 "\n%s: executing:\n\n\t%s\t\t\t%s %s %s %s\n" "${script}" pdftohtml  -xml "${param_filename}" "${tmp_pdftohtml_xml_fn_without_extension}"

if                                                                  "$pdftohtml" -xml "${param_filename}" "${tmp_pdftohtml_xml_fn_without_extension}"
then :
else :
  : set +x
  printf 1>&2 "=%03.3d: %s=>{%s} // %s\n" $LINENO \
    '$?' "$?" \
    'pdftohtml -xml has non-zero exit code' \
    ;
  exit 1
fi

################################################################################

if false
then :
  printf 1>&2 "\n%s: removing b and i formatting from text\n" "${script}"

  perl -i~ -pe 's(</?[bi]>)()g' "${tmp_pdftohtml_xml_fn_without_extension}.xml"
fi

################################################################################

# TBD:
# "${dirname_basename_minus_extension}.pdf.xml" -- is this the right file name here???

# /media/_ARCHIVE/home/jochen_hayek-FROZEN-STUFF/edu/staats-und-domchor-berlin.de/20120916______--Probenplan--PP_Dominis_3_2012-09.pdf
#  page 1
#   --left={0,149,253,349,402}
#  page 2 / upper part
#   --left={0,242,329,426,563}
#  page 2 / middle part
#   --left={0,111,164,203,293,381,460}

# /media/_ARCHIVE/home/jochen_hayek-FROZEN-STUFF/edu/Werbellinsee-Grundschule/*--Klassenliste.pdf
# --left={0,278,553}

# ~/Business/Telecommunications/Carriers/t-mobile.de/CSV-Rechnung.20130318.pdf
#  pages 1..2 - Kopfteil
#   --left={0,172,451,607,672}
#  pages 2..3 - Positionsteil
#   --left={0,172,466,626,683}
#  pages 3..4 - Summenteil // maybe we can use this for the all 3 sorts of tables
#   --left={0,172,345,529,598}

# ~/Business/Telecommunications/Carriers/t-mobile.de/CSV-Rechnung.20110220.pdf
#  pages 1..2 - Kopfteil
#   --left={0,115,301,404,448}
#  pages 2..3 - Positionsteil
#   --left={0,115,301,404,448}
#  pages 3..4 - Summenteil // maybe we can use this for the all 3 sorts of tables
#   --left={0,115,230,352,398}

# List_of_Disciplinary_Actions.pdf
# --left={0,315,363,682}

# PB_Umsatzauskunft_KtoNr0202589705_19-01-2012_0001.pdf
# --left={060,108,166,248,441,501}
#
#         Datum
#             Wertstellung
#                 Art
#                     Buchungshinweis
#                         Betrag €
#                             Saldo €
#         060,108,166,248,441,501
#
#         Download am 19. Januar 2012 um 00:02 Uhr
#         059

printf 1>&2 "\n%s: executing:\n\n\t%s\t\t\t%s %s %s %s %s\n" "${script}" \
   "${perl_script} --debug --pdftohtml_xml_file=${tmp_pdftohtml_xml_fn_without_extension}.xml --orig_file=${param_filename}" '>' "${param_filename}.csv" '2>' "${param_filename}.log.txt"

# 1) you will start your research without "--left=..."!

# 2) find the column headers

# 3) find the column positions for each column, always use the minimum! create the "--left=..." line(s) above from your findings!

# 4) insert the "--left=..." after "--debug" on a separate line:

####  --left={0,172,466,626,683}
"${perl_script}" --debug \
  --pdftohtml_xml_file="${tmp_pdftohtml_xml_fn_without_extension}.xml" \
  --orig_file="${param_filename}" \
  1> "${param_filename}.csv" \
  2> "${param_filename}.log.txt"
exit_code=$?

if test "$exit_code" -eq 0
then :
else :
  printf 1>&2 "=%03.3d: %s=>{%s} // %s\n" $LINENO \
    '$exit_code' "$exit_code" \
    'perl_script has non-zero exit code' \
    ;
  exit 1
fi

################################################################################

if true
then :
  printf 1>&2 "=%03.3d: %s=>{%s} // %s\n" $LINENO \
    '$tmp_dir' "$tmp_dir" \
    'going to remove ...' \
    ;
  rm --verbose -r "${tmp_dir}"
else :
  printf 1>&2 "=%03.3d: %s=>{%s} // %s\n" $LINENO \
    '$tmp_dir' "$tmp_dir" \
    'should remove ...' \
    ;
fi
