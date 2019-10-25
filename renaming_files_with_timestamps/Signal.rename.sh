:

# e.g. signal-attachment-2019-03-04-120047.jpeg

shopt -s nullglob

set -x

~/bin/rename -v </dev/null \
  \
  's/^ signal-attachment- (?<YYYY>....)-(?<mm>..)-(?<dd>..)-(?<HH>..)(?<MM>..)(?<SS>..)                  \.(?<suffix>jpeg) 
     $/999990-000--$+{YYYY}$+{mm}$+{dd}$+{HH}$+{MM}$+{SS}--___.$+{suffix}/x' \
  \
  signal-attachment-*.jpeg
