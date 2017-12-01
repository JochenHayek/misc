:

set -x

# incoming file name looks like this:
#
#   "Amazon.de - Bestellung *.pdf"
#
# 1st I call it like this:
#
#   amazon--order-ORDER_NO.pdf
#
# then I call it like this:
#
#   999990-000--20999999999999--amazon--order-___.pdf

~/bin/rename   's/^Amazon\.de - Bestellung /amazon--order-/' Amazon.de*.pdf

~/bin/pdf-suggest-rename-as_vouchers.sh     amazon--order-*.pdf | fgrep CreationDate | sh -x

~/bin/touch_with_filename.sh 999990-000--*--amazon--order-*.pdf
