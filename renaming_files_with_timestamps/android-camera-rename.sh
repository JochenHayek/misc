f:

# -> README--rename.txt

################################################################################

shopt -s nullglob

set -x

~/bin/rename -v 's/^ (?<prefix>IMG|VID) _ (?<YYYYmmdd>\d{8}) _ (?<HHMMSS>\d{6})/999990-000--$+{YYYYmmdd}$+{HHMMSS}--___/x' \
  \
  "$@"

exit 0

################################################################################

  *.jpg *.mp4

################################################################################

exit 0

##for i in *.jpg *.png *.pdf
  for i
do :
  case "$i" in

    QScan????????_??????.[jp]?? )
      ~/bin/rename 's/^ (?<p>QScan) (?<mm>\d\d) (?<dd>\d\d) (?<YYYY>20\d\d) _ (?<HHMMSS>\d{6})               \. (?<extension>.*) $ /999990-000--$+{YYYY}$+{mm}$+{dd}$+{HHMMSS}--___.raw.$+{extension}/x'             "$i"
      ;;

    QScan????????_??????-?.[jp]?? )
      ~/bin/rename 's/^ (?<p>QScan) (?<mm>\d\d) (?<dd>\d\d) (?<YYYY>20\d\d) _ (?<HHMMSS>\d{6}) - (?<no>\d)   \. (?<extension>.*) $ /999990-000--$+{YYYY}$+{mm}$+{dd}$+{HHMMSS}--___.0$+{no}of99.raw.$+{extension}/x' "$i"
      ;;

    QScan????????_??????-??.[jp]?? )
      ~/bin/rename 's/^ (?<p>QScan) (?<mm>\d\d) (?<dd>\d\d) (?<YYYY>20\d\d) _ (?<HHMMSS>\d{6}) - (?<no>\d\d) \. (?<extension>.*) $ /999990-000--$+{YYYY}$+{mm}$+{dd}$+{HHMMSS}--___.$+{no}of99.raw.$+{extension}/x'  "$i"
      ;;

  esac
done
