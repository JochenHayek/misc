:

# e.g.
#
#   PHOTO-2020-03-22-15-24-43.jpg

shopt -s nullglob

set -x

~/bin/rename -v </dev/null \
  \
  's/^ (PHOTO)- (?<YYYY>....)-(?<mm>..)-(?<dd>..)-(?<HH>..)-(?<MM>..)-(?<SS>..)                  \.(?<suffix>jpeg|jpg|mp4) 
     $/999990-000--$+{YYYY}$+{mm}$+{dd}$+{HH}$+{MM}$+{SS}--___.$+{suffix}/x' \
  \
  "$@"

exit 0
