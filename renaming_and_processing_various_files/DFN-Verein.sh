:

: set -x

echo "=$0: …"

~/bin/rename 's/^ (?<core>.+) \.(?<suffix>...) $/DFN-Verein--period-201799--invoice-$+{core}.$+{suffix}/x' W??-*.???

echo "=$0: pdf-suggest-rename-as_vouchers.sh …"

~/bin/pdf-suggest-rename-as_vouchers.sh DFN-Verein--period-*--invoice-*.pdf |
fgrep CreationDate |
sh -x

################################################################################

shopt -s nullglob

for f in *--DFN-Verein--*.pdf
do :

  bn=$(basename "${f}" .pdf )

  mv DFN-Verein--period-*--invoice-*[0-9].txt "${bn}.txt"

  ~/bin/touch_with_filename.sh "${bn}.pdf" "${bn}.txt"

done
