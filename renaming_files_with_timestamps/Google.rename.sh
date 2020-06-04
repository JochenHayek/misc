:

# e.g.
#
#   IMG_20191103_125035.jpg
#   VID_20191110_220819.mp4

shopt -s nullglob

set -x

~/bin/rename -v </dev/null \
  \
  's/^ (IMG|VID) _ (?<YYYY>....)(?<mm>..)(?<dd>..) [_] (?<HH>..)(?<MM>..)(?<SS>..)                  \.(?<suffix>jpeg|jpg|mp4) 
     $/999990-000--$+{YYYY}$+{mm}$+{dd}$+{HH}$+{MM}$+{SS}--___.$+{suffix}/x' \
  \
  "$@"

exit 0

################################################################################
  
  photo_*.jpeg \
  photo_*.jpg \
  IMG_*.mp4 \
  ;
