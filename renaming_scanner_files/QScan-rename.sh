:

# -> ~/Computers/Software/Operating_Systems/Unix/Shell/README--rename.txt

################################################################################

#                   ~/Computers/Software/Operating_Systems/Unix/Shell/QScan-rename.sh
# /scp:localhost#2222:Computers/Software/Operating_Systems/Unix/Shell/QScan-rename.sh
# /scp:localhost#2222:Computers/Software/Operating_Systems/Unix/Shell/

################################################################################

shopt -s nullglob

set -x

for i in *.png *.pdf
do :
  case "$i" in

    QScan????????_??????.p?? )
      ~/Computers/Programming/Languages/Perl/rename 's/^ (?<p>QScan) (?<mm>\d\d) (?<dd>\d\d) (?<YYYY>20\d\d) _ (?<HHMMSS>\d{6})               \. (?<extension>.*) $ /999990-000--$+{YYYY}$+{mm}$+{dd}$+{HHMMSS}--___.raw.$+{extension}/x'             "$i"
      ;;

    QScan????????_??????-?.p?? )
      ~/Computers/Programming/Languages/Perl/rename 's/^ (?<p>QScan) (?<mm>\d\d) (?<dd>\d\d) (?<YYYY>20\d\d) _ (?<HHMMSS>\d{6}) - (?<no>\d)   \. (?<extension>.*) $ /999990-000--$+{YYYY}$+{mm}$+{dd}$+{HHMMSS}--___.0$+{no}of99.raw.$+{extension}/x' "$i"
      ;;

    QScan????????_??????-??.p?? )
      ~/Computers/Programming/Languages/Perl/rename 's/^ (?<p>QScan) (?<mm>\d\d) (?<dd>\d\d) (?<YYYY>20\d\d) _ (?<HHMMSS>\d{6}) - (?<no>\d\d) \. (?<extension>.*) $ /999990-000--$+{YYYY}$+{mm}$+{dd}$+{HHMMSS}--___.$+{no}of99.raw.$+{extension}/x'  "$i"
      ;;

  esac
done

exit

[[ -s QScan????????_??????.png   ]] &&
~/Computers/Programming/Languages/Perl/rename 's/^ (?<p>QScan) (?<mm>\d\d) (?<dd>\d\d) (?<YYYY>20\d\d) _ (?<HHMMSS>\d{6})               \. (?<extension>.*) $ /999990-000--$+{YYYY}$+{mm}$+{dd}$+{HHMMSS}--___.$+{extension}/x'             QScan????????_??????.png

[[ -s QScan????????_??????-?.png ]] &&
~/Computers/Programming/Languages/Perl/rename 's/^ (?<p>QScan) (?<mm>\d\d) (?<dd>\d\d) (?<YYYY>20\d\d) _ (?<HHMMSS>\d{6}) - (?<no>\d)   \. (?<extension>.*) $ /999990-000--$+{YYYY}$+{mm}$+{dd}$+{HHMMSS}--___.0$+{no}of99.$+{extension}/x' QScan????????_??????-?.png

[[ -s QScan????????_??????-??.png ]] &&
~/Computers/Programming/Languages/Perl/rename 's/^ (?<p>QScan) (?<mm>\d\d) (?<dd>\d\d) (?<YYYY>20\d\d) _ (?<HHMMSS>\d{6}) - (?<no>\d\d) \. (?<extension>.*) $ /999990-000--$+{YYYY}$+{mm}$+{dd}$+{HHMMSS}--___.$+{no}of99.$+{extension}/x'  QScan????????_??????-??.png

exit

~/Computers/Programming/Languages/Perl/rename 's/^ (?<p>QScan) (?<mm>\d\d) (?<dd>\d\d) (?<YYYY>20\d\d) _ (?<HHMMSS>\d{6})               /999990-000--$+{YYYY}$+{mm}$+{dd}$+{HHMMSS}--___/x'             QScan????????_??????.png

~/Computers/Programming/Languages/Perl/rename 's/^ (?<p>QScan) (?<mm>\d\d) (?<dd>\d\d) (?<YYYY>20\d\d) _ (?<HHMMSS>\d{6}) - (?<no>\d)   /999990-000--$+{YYYY}$+{mm}$+{dd}$+{HHMMSS}--___.0$+{no}of99/x' QScan????????_??????-?.png

~/Computers/Programming/Languages/Perl/rename 's/^ (?<p>QScan) (?<mm>\d\d) (?<dd>\d\d) (?<YYYY>20\d\d) _ (?<HHMMSS>\d{6}) - (?<no>\d\d) /999990-000--$+{YYYY}$+{mm}$+{dd}$+{HHMMSS}--___.$+{no}of99/x'  QScan????????_??????-??.png

exit
