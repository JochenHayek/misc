:

# before:
#
#   Scan.png
#   Scan 1.png
#   Scan 10.png
#
# after:
#
#   010.png

shopt -s nullglob

set -x

~/bin/rename -v \
  'if (m/^ (?<prefix>Scan \s+ ) (?<no>\d+) \.png$/ix) { $no = sprintf "%03.3d",$+{no} ; s/^ (?<prefix>Scan \s+ ) (?<no>\d+) \.png$/${no}.png/ix; } elsif (m/^ Scan\.png $/ix) { s/^ Scan\.png $/000.png/ix }' \
  \
  "$@"

exit 0
