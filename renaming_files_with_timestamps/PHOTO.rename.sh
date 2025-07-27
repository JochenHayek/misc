:

# e.g.
#
#   PHOTO-2020-03-22-15-24-43.jpg
#   PHOTO-2025-07-26-23-38-43 2.jpg

# Apple AirDrop uses this naming scheme.

shopt -s nullglob

: set -x

for i
do :

	test -f "${i}" &&
	~/bin/rename -v </dev/null \
	  \
	  's/^ (PHOTO)- (?<YYYY>....)-(?<mm>..)-(?<dd>..)-(?<HH>..)-(?<MM>..)-(?<SS>..)                  \.(?<suffix>jpeg|jpg|mp4) 
	     $/999990-000--$+{YYYY}$+{mm}$+{dd}$+{HH}$+{MM}$+{SS}--___.$+{suffix}/x' \
	  \
	  "${i}"

	test -f "${i}" &&
	~/bin/rename -v </dev/null \
	  \
	  's/^ (PHOTO)- (?<YYYY>....)-(?<mm>..)-(?<dd>..)-(?<HH>..)-(?<MM>..)-(?<SS>..)                  \s+ (?<no>\d+) \.(?<suffix>jpeg|jpg|mp4) 
	     $/999990-000--$+{YYYY}$+{mm}$+{dd}$+{HH}$+{MM}$+{SS}--___.$+{no}.$+{suffix}/x' \
	  \
	  "${i}"

done

exit 0
