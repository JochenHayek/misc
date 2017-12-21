:

set -x

bn=$(basename *--united-domains--*.pdf .pdf )

# add ' <!-- for account transfer -->' to essential lines in the .xml file before this!

fgrep 'for account transfer' "${bn}.pdftohtml.xml" > "${bn}.9--invoice-details.txt"

##~/bin/touch_with_filename.sh "${bn}.pdf" "${bn}.pdftohtml.xml" "${bn}.txt"
