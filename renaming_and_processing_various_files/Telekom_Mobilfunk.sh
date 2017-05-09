:

set -x

invoice_incl_csv=$(echo Rechnung_*.csv)

invoice_excl_csv=$(basename "${invoice_incl_csv}" .csv)

$HOME/Computers/Programming/Languages/Perl/xml_multi_utility.pl --job_t_mobile_reo --xml_file=$HOME/Business/Telecommunications/Carriers/t-mobile.de/CSV-Rechnung.effective-20130722.pl.xml "${invoice_incl_csv}" > ${invoice_incl_csv}.xml.NEW

xml sel -t -v "rechnung/summenteil/untersumme[@bezeichnung='Zu zahlender Betrag ']/@betrag" -n ${invoice_incl_csv}.xml.NEW > ${invoice_incl_csv}.calc.txt

~/bin/pdf-suggest-rename-versioned.sh "${invoice_excl_csv}.pdf" | fgrep CreationDate | sh -x
