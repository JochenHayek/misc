:

# e.g.
# signal-2021-10-20-210143.png
# signal-2020-06-16-221716.jpeg
# signal-2019-12-28-010316_001.mp4
# signal-attachment-2019-03-04-120047.jpeg
# signal-attachment-2019-12-28-010316_001.mp4

shopt -s nullglob

set -x

~/bin/rename -v </dev/null \
  \
  's/^ signal - (attachment-)? (?<YYYY>....)-(?<mm>..)-(?<dd>..)-(?<HH>..)(?<MM>..)(?<SS>..)                  \.(?<suffix>png|jpeg|mp4) 
     $/999990-000--$+{YYYY}$+{mm}$+{dd}$+{HH}$+{MM}$+{SS}--___.$+{suffix}/x' \
  \
  "$@"

~/bin/rename -v </dev/null \
  \
  's/^ signal - (attachment-)? (?<YYYY>....)-(?<mm>..)-(?<dd>..)-(?<HH>..)(?<MM>..)(?<SS>..) ( _ (?<no>\d+) )?                 \.(?<suffix>png|jpeg|mp4) 
     $/999990-000--$+{YYYY}$+{mm}$+{dd}$+{HH}$+{MM}$+{SS}--___.$+{no}.$+{suffix}/x' \
  \
  "$@"

exit 0

################################################################################

  signal-attachment-*.jpeg
