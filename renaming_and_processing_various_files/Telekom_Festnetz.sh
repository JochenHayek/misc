:

#            ~/git-servers/github.com/JochenHayek/misc/renaming_and_processing_various_files/Telekom_Festnetz.sh

this_dir=$HOME/git-servers/github.com/JochenHayek/misc/renaming_and_processing_various_files

################################################################################

shopt -s nullglob

script=$(basename "$0")

xmlstarlet=xml

for pdf in *.pdf
do :

  printf 1>&2 "=%s,%d: %s=>{%s} // %s\n" "$script" $LINENO \
    'pdf' "${pdf}" \
    '...'

##~/bin/pdf-suggest-rename-versioned.sh "${pdf}" | fgrep ModDate | sh -x
##env pdfinfo_options='-meta -rawdates' ~/bin/pdf-suggest-rename-versioned.sh "${pdf}" | fgrep ModDate | sh -x
  env pdfinfo_options='-rawdates'       ~/bin/pdf-suggest-rename-versioned.sh "${pdf}" | fgrep ModDate | sh -x

done

~/bin/touch_with_filename.sh *.pdf

for invoice in *_[Rr]echnung_*[0-9].csv
do :

  printf 1>&2 "=%s,%d: %s=>{%s} // %s\n" "$script" $LINENO \
    'invoice' "${invoice}" \
    '...'

  invoice_bn=$(basename "${invoice}" .csv)

  printf 1>&2 "=%s,%d: %s=>{%s} // %s\n" "$script" $LINENO \
    'invoice_bn' "${invoice_bn}" \
    '...'

  invoice_xml="${invoice}.xml.NEW"
##invoice_xml="${invoice_bn}.xml.NEW"

  printf 1>&2 "=%s,%d: %s=>{%s} // %s\n" "$script" $LINENO \
    'invoice_xml' "${invoice_xml}" \
    '...'

  ~/git-servers/github.com/JochenHayek/misc/xml/xml_multi_utility.pl \
    --job_telekom_reo \
    --xml_file=${this_dir}/Telekom_Festnetz.CSV-Rechnung.20090827.pl.xml \
      "${invoice}" \
    > "${invoice_xml}"

  "${xmlstarlet}" sel --template \
    --value-of 'sum(/telekom_rechnung/positionsteil/position/@nettogesamtbetrag) * 1.19' \
    --nl \
      "${invoice_xml}" \
    > "${invoice_bn}.calc.txt"

  printf 1>&2 "=%s,%d: %s=>{%s} // %s\n" "$script" $LINENO \
    "\$( cat  ${invoice_bn}.calc.txt  )" \
      $( cat "${invoice_bn}.calc.txt" ) \
    '...'

done
