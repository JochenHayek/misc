:

# e.g. photo_2019-02-24 17.59.02.jpeg

shopt -s nullglob

set -x

~/bin/rename -v </dev/null \
  \
  's/^ (photo)_ (?<YYYY>....)-(?<mm>..)-(?<dd>..) \s+ (?<HH>..)\.(?<MM>..)\.(?<SS>..)                  \.(?<suffix>jpeg|mp4) 
     $/$+{YYYY}$+{mm}$+{dd}$+{HH}$+{MM}$+{SS}--___.$+{suffix}/x' \
  \
  photo_*.jpeg
