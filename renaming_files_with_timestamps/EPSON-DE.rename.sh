:

# e.g. Epson_30102023164546.pdf

# for use with my Epson MFP

shopt -s nullglob

: set -x

for i
do :

	test -f "${i}" &&
	~/bin/rename -v </dev/null \
		\
		's/^ Epson_ (?<dd>..) (?<mm>..) (?<YYYY>....) (?<HH>..) (?<MM>..)(?<SS>..)                 \.(?<suffix>jpg|pdf) 
		   $/999990-000--$+{YYYY}$+{mm}$+{dd}$+{HH}$+{MM}$+{SS}--___.$+{suffix}/x' \
		\
		"${i}"

	test -f "${i}" &&
	~/bin/rename -v </dev/null \
		\
		's/^ Epson_ (?<dd>..) (?<mm>..) (?<YYYY>....) (?<HH>..) (?<MM>..)(?<SS>..) \((?<no>\d+)\)                \.(?<suffix>jpg|pdf) 
		   $/999990-000--$+{YYYY}$+{mm}$+{dd}$+{HH}$+{MM}$+{SS}--___.$+{no}.$+{suffix}/x' \
		\
		"${i}"

done
