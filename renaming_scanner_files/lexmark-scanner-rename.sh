:

# -> README--rename.txt

################################################################################

##RENAME=c:/Users/jochen.hayek/opt/cygwin64/home/jochen.hayek/bin/rename--Tussle
  RENAME=$HOME/bin/rename

shopt -s nullglob

set -x

for i in *.jpg *.png *.pdf
do :
  case "$i" in

    image????-??-??-??????.[jp]?? )
      "${RENAME}" 's/^ (?<p>image) (?<YYYY>20\d\d) - (?<mm>\d\d) - (?<dd>\d\d) - (?<HHMMSS>\d{6}) 		  \. (?<extension>.*) $ /999990-000--$+{YYYY}$+{mm}$+{dd}$+{HHMMSS}--___.$+{extension}/x'             "$i"
      ;;

    image????-??-??-??????-?.[jp]?? )
      "${RENAME}" 's/^ (?<p>image) (?<YYYY>20\d\d) - (?<mm>\d\d) - (?<dd>\d\d) - (?<HHMMSS>\d{6}) - (?<no>\d+)  \. (?<extension>.*) $ /999990-000--$+{YYYY}$+{mm}$+{dd}$+{HHMMSS}--___.0$+{no}of99.$+{extension}/x' "$i"
      ;;

    image????-??-??-??????-??.[jp]?? )
      "${RENAME}" 's/^ (?<p>image) (?<YYYY>20\d\d) - (?<mm>\d\d) - (?<dd>\d\d) - (?<HHMMSS>\d{6}) - (?<no>\d+)  \. (?<extension>.*) $ /999990-000--$+{YYYY}$+{mm}$+{dd}$+{HHMMSS}--___.$+{no}of99.$+{extension}/x' "$i"
      ;;

  esac
done
