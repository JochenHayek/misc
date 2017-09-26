:

# -> ~/Computers/Software/Operating_Systems/Unix/Shell/README--rename.txt

################################################################################

#                   ~/Computers/Software/Operating_Systems/Unix/Shell/QScan-rename.sh
# /scp:localhost#2222:Computers/Software/Operating_Systems/Unix/Shell/QScan-rename.sh
# /scp:localhost#2222:Computers/Software/Operating_Systems/Unix/Shell/

################################################################################

shopt -s nullglob

set -x

for i in *.jpg *.png *.pdf
do :
  case "$i" in

    image????-??-??-??????.[jp]?? )
      c:/cygwin/home/jochen.hayek/bin/rename--Tussle 's/^ (?<p>image) (?<YYYY>20\d\d) - (?<mm>\d\d) - (?<dd>\d\d) - (?<HHMMSS>\d{6}) 		  \. (?<extension>.*) $ /999990-000--$+{YYYY}$+{mm}$+{dd}$+{HHMMSS}--___.$+{extension}/x'             "$i"
      ;;

    image????-??-??-??????-?.[jp]?? )
      c:/cygwin/home/jochen.hayek/bin/rename--Tussle 's/^ (?<p>image) (?<YYYY>20\d\d) - (?<mm>\d\d) - (?<dd>\d\d) - (?<HHMMSS>\d{6}) - (?<no>\d+)  \. (?<extension>.*) $ /999990-000--$+{YYYY}$+{mm}$+{dd}$+{HHMMSS}--___.0$+{no}of99.$+{extension}/x' "$i"
      ;;

    image????-??-??-??????-??.[jp]?? )
      c:/cygwin/home/jochen.hayek/bin/rename--Tussle 's/^ (?<p>image) (?<YYYY>20\d\d) - (?<mm>\d\d) - (?<dd>\d\d) - (?<HHMMSS>\d{6}) - (?<no>\d+)  \. (?<extension>.*) $ /999990-000--$+{YYYY}$+{mm}$+{dd}$+{HHMMSS}--___.$+{no}of99.$+{extension}/x' "$i"
      ;;

    ################################################################################

    QScan????????_??????.[jp]?? )
      ~/Computers/Programming/Languages/Perl/rename 's/^ (?<p>QScan) (?<mm>\d\d) (?<dd>\d\d) (?<YYYY>20\d\d) _ (?<HHMMSS>\d{6})               \. (?<extension>.*) $ /999990-000--$+{YYYY}$+{mm}$+{dd}$+{HHMMSS}--___.raw.$+{extension}/x'             "$i"
      ;;

    QScan????????_??????-?.[jp]?? )
      ~/Computers/Programming/Languages/Perl/rename 's/^ (?<p>QScan) (?<mm>\d\d) (?<dd>\d\d) (?<YYYY>20\d\d) _ (?<HHMMSS>\d{6}) - (?<no>\d)   \. (?<extension>.*) $ /999990-000--$+{YYYY}$+{mm}$+{dd}$+{HHMMSS}--___.0$+{no}of99.raw.$+{extension}/x' "$i"
      ;;

    QScan????????_??????-??.[jp]?? )
      ~/Computers/Programming/Languages/Perl/rename 's/^ (?<p>QScan) (?<mm>\d\d) (?<dd>\d\d) (?<YYYY>20\d\d) _ (?<HHMMSS>\d{6}) - (?<no>\d\d) \. (?<extension>.*) $ /999990-000--$+{YYYY}$+{mm}$+{dd}$+{HHMMSS}--___.$+{no}of99.raw.$+{extension}/x'  "$i"
      ;;

  esac
done
