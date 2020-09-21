:

# e.g.
# signal-2020-06-16-221716.jpeg
# signal-2019-12-28-010316_001.mp4
# signal-attachment-2019-03-04-120047.jpeg
# signal-attachment-2019-12-28-010316_001.mp4

shopt -s nullglob

set -x

~/bin/rename -v </dev/null \
  \
  's/^ signal - (attachment-)? (?<YYYY>....)-(?<mm>..)-(?<dd>..)-(?<HH>..)(?<MM>..)(?<SS>..)                  \.(?<suffix>jpeg|mp4) 
     $/999990-000--$+{YYYY}$+{mm}$+{dd}$+{HH}$+{MM}$+{SS}--___.$+{suffix}/x' \
  \
  "$@"

~/bin/rename -v </dev/null \
  \
  's/^ signal - (attachment-)? (?<YYYY>....)-(?<mm>..)-(?<dd>..)-(?<HH>..)(?<MM>..)(?<SS>..) ( _ (?<no>\d+) )?                 \.(?<suffix>jpeg|mp4) 
     $/999990-000--$+{YYYY}$+{mm}$+{dd}$+{HH}$+{MM}$+{SS}--___.$+{no}.$+{suffix}/x' \
  \
  "$@"

exit 0

################################################################################

  signal-attachment-*.jpeg
