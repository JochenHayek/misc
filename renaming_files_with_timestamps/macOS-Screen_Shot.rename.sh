:

# before:
#
#   Screen Shot 2014-04-15 at 21.45.17pm.png
#   Screenshot_2024-03-20_at_15.47.20.jpeg
#
# after:
#
#   Screen_Shot.20140415214517.png

shopt -s nullglob

set -x

~/bin/rename -v \
  'y/ /_/; s/^ (?<prefix>Screen_Shot|Screenshot|Bildschirmfoto|Photo_on)_ (?<Y>\d{4}) - (?<m>\d{2}) - (?<d>\d{2}) _(at|um)_ (?<H>\d{1,2}) \. (?<M>\d{2}) \. (?<S>\d{2}) (_[ap]m)? \. (?<suffix>\w+) $/$+{prefix}.$+{Y}$+{m}$+{d}$+{H}$+{M}$+{S}--___.$+{suffix}/ix' \
  \
  "$@"

exit 0

################################################################################

  Screen*[Ss]hot*.png \
  Bildschirmfoto*.png \
  ;
