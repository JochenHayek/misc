:

# -> http://avm.de/nc/service/zack-der-speedtest-fuer-ihre-breitbandverbindung/

# e.g.
#
#   zack2g-speedtest-14-12-2020-194534.csv
#   zack2g-speedtest-9-1-2021-152949.csv

################################################################################

# afterwards we use csvlook for tabular presentation.
#
# "csvlook -L de" reformats the IP address (because it considers it a dotted number), but we certainly don't want that.
#
# $ csvlook -d ';' -L de ...
#
# $ csvlook -d ';'       ...

################################################################################

shopt -s nullglob

set -x

~/bin/rename -v </dev/null \
  \
  '

    if(/^ (?<prefix>zack2g-speedtest) - (?<dd>.+)-(?<mm>.+)-(?<YYYY>....) - (?<HH>..)(?<MM>..)(?<SS>..)                  \.(?<suffix>csv) $/x)
      {
        my(%plus) = %+;
        my($mm) = sprintf "%02.2d",$plus{mm};
        my($dd) = sprintf "%02.2d",$plus{dd};

	s/^ (?<prefix>zack2g-speedtest) - (?<dd>.+)-(?<mm>.+)-(?<YYYY>....) - (?<HH>..)(?<MM>..)(?<SS>..)                  \.(?<suffix>csv) 
	  $/$+{prefix}.$+{YYYY}${mm}${dd}$+{HH}$+{MM}$+{SS}.$+{suffix}/x
      }   

  ' \
  "$@"
