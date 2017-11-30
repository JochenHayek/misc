:

# -> README--rename.txt

################################################################################

shopt -s nullglob

set -x

for i in *.jpg *.png *.pdf
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
