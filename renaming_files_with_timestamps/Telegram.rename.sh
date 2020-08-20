:

# e.g.
#
#   photo_2019-02-24 17.59.02.jpeg
#   photo_2019-04-01_00-12-48.jpg

shopt -s nullglob

set -x

~/bin/rename -v </dev/null \
  \
  's/^ (photo|IMG)_ (?<YYYY>....)-(?<mm>..)-(?<dd>..) [ _] (?<HH>..)[\.-](?<MM>..)[\.-](?<SS>..)                  \.(?<suffix>jpeg|jpg|mp4) 
     $/999990-000--$+{YYYY}$+{mm}$+{dd}$+{HH}$+{MM}$+{SS}--___.$+{suffix}/x' \
  \
  "$@"

exit 0

################################################################################
  
  photo_*.jpeg \
  photo_*.jpg \
  IMG_*.mp4 \
  ;
