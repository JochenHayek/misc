:

# before:
#
#   Scan.png
#   Scan.jpeg
#   Scan 1.png
#   Scan 10.png
#
# after:
#
#   010.png

shopt -s nullglob

set -x

~/bin/rename -v \
  '
    if    (m/^ (?<prefix>Scan \s+ ) (?<no>\d+) \.(?<suffix>jpeg|png) $/ix)
      {
        $no = sprintf "%03.3d",$+{no}; 
        s/^    (?<prefix>Scan \s+ ) (?<no>\d+) \.(?<suffix>jpeg|png) $/${no}.$+{suffix}/ix;
      } 
    elsif (m/^           Scan                  \.(?<suffix>jpeg|png) $/ix)
      {
        s/^              Scan                  \.(?<suffix>jpeg|png) $/000.$+{suffix}/ix;
      }
  ' \
  \
  "$@"

exit 0
