:

# ~/git-servers/github.com/JochenHayek/misc/renaming_and_processing_various_files/Telekom_Mobilfunk.sh

################################################################################

xmlstarlet=xml

set -x

################################################################################

# we expect there is exactly one matching

for invoice_csv in Rechnung_*.csv
do :

  invoice_basename=$(basename "${invoice_csv}" .csv)

  $HOME/Computers/Programming/Languages/Perl/xml_multi_utility.pl --job_t_mobile_reo --xml_file=$HOME/Business/Telecommunications/Carriers/t-mobile.de/CSV-Rechnung.effective-20130722.pl.xml "${invoice_csv}" > ${invoice_csv}.xml.NEW

  "${xmlstarlet}" sel -t -v "rechnung/summenteil/untersumme[@bezeichnung='Zu zahlender Betrag ']/@betrag" -n ${invoice_csv}.xml.NEW > ${invoice_csv}.calc.txt

done

################################################################################

# we expect there is exactly one matching

for invoice_pdf_orig in Rechnung_*.pdf
do :

  case "${invoice_pdf_orig}" in

    # ... but we want to exclude this case

    Rechnung_*.*.pdf )
      echo 1>&2 "*** $0: {${invoice_pdf_orig}} // do not rename a file, that is already versioned"
      ;;

    * )
      # problems with "-meta" (pdfinfo / version ...) , so leave it out
      env pdfinfo_options=-rawdates \
	~/bin/pdf-suggest-rename-versioned.sh "${invoice_pdf_orig}" | fgrep CreationDate | sh -x
      ;;

  esac

done

################################################################################

# we expect there is exactly one matching

for invoice_pdf_versioned in Rechnung_*.*.pdf
do :


  ~/bin/touch_with_filename.sh          "${invoice_pdf_versioned}"

  touch                              -r "${invoice_pdf_versioned}" GesamtEVN_*.csv Rechnung_*.csv* Signatur_*.ads

done
