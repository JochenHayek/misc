:

: set -x

echo "=$0: …"

~/bin/rename 's/^ rechnung_ (\w+) \.pdf $/united-domains--invoice-${1}--domain-___.pdf/x' rechnung_*.pdf

echo "=$0: pdf-suggest-rename-as_vouchers.sh …"

~/bin/pdf-suggest-rename-as_vouchers.sh united-domains--*.pdf |
fgrep CreationDate |
sh -x

bn=$(basename *--united-domains--*.pdf .pdf )

echo "=$0: pdftohtml -xml …"

/Applications/calibre.app/Contents/Frameworks/pdftohtml -xml -i -nomerge -hidden *--united-domains--*.pdf "${bn}.xml"

##echo "=$0: removing picture files …"

~/bin/pdftohtml__postprocess.pl "${bn}.xml" >  "${bn}.pdftohtml.xml"

##echo "=$0: cleaning up …"
##
##rm --verbose "${bn}.xml" *.jpg *.png

echo "=$0: touch_with_filename …"

~/bin/touch_with_filename.sh "${bn}.pdf" "${bn}.pdftohtml.xml"
