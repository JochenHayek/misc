# ...

# busybox-w32 dash
# tinyperl

# for use with my Screenshot image files created by the Windows screenshot utility

# e.g. Screenshot 2024-10-18 115250.png

##shopt -s nullglob

set -x

c:/opt/tinyperl/tinyperl.exe h:/bin/rename -v </dev/null \
  \
  's/^ Screenshot \s+ (....) - (..) - (..) \s+  (..) (..)(..)                 \.(png) 
     $/999990-000--${1}${2}${3}${4}${5}${6}--___.${7}/x' \
  \
  "$@"

exit 0

~/bin/rename -v </dev/null \
  \
  's/^ Screenshot \s+ (?<YYYY>....) - (?<mm>..) - (?<dd>..) \s+  (?<HH>..) (?<MM>..)(?<SS>..)                 \.(?<suffix>png) 
     $/999990-000--${1}${2}${3}${4}${5}${6}--___.${7}/x' \
  \
  "$@"

~/bin/rename -v </dev/null \
  \
  's/^ Screenshot \s+ (?<YYYY>....) - (?<mm>..) - (?<dd>..) \s+  (?<HH>..) (?<MM>..)(?<SS>..)                 \.(?<suffix>png) 
     $/999990-000--$+{YYYY}$+{mm}$+{dd}$+{HH}$+{MM}$+{SS}--___.$+{suffix}/x' \
  \
  "$@"
