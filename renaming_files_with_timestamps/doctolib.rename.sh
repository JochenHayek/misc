:

# e.g. termin-herr-dr-rainer-lauven-11-11-2019-a-09-40.ics

shopt -s nullglob

set -x

~/bin/rename -v </dev/null \
  \
  's/^ (?<text>.*) - (?<dd>..)-(?<mm>..)-(?<YYYY>....)-a-(?<HH>..)-(?<MM>..) \.(?<suffix>ics) 
     $/$+{YYYY}$+{mm}$+{dd}$+{HH}$+{MM}00--$+{text}.$+{suffix}/x' \
  \
  termin-*.ics
