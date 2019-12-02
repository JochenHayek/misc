:

# e.g. img20191021_15442715.pdf

# for use with dentist Zimmermann bills etc

shopt -s nullglob

set -x

~/bin/rename -v </dev/null \
  \
  's/^ img (?<YYYY>....) (?<mm>..) (?<dd>..) _ (?<HH>..) (?<MM>..)(?<SS>..)(?<XX>..)                  \.(?<suffix>pdf) 
     $/999990-000--$+{YYYY}$+{mm}$+{dd}$+{HH}$+{MM}$+{SS}--$+{XX}--___.$+{suffix}/x' \
  \
  "$@"
