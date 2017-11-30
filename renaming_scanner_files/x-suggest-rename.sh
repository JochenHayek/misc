:

# -> ~/Computers/Software/Operating_Systems/Unix/Shell/README--rename.txt

################################################################################

# (((this script is good for getting executed locally on /Volumes/homes/johayek/Pictures/QScan/ .)))
#
# it takes files named like x_??_of_??.jpg from the HP MFU (scanner + ...) at K+N
# and renames them to look like 999990-000--20131106153234--___.x_??_of_??.jpg .

#                   ~/Computers/Software/Operating_Systems/Unix/Shell/x-suggest-rename.sh
# /scp:localhost#2222:Computers/Software/Operating_Systems/Unix/Shell/x-suggest-rename.sh
# /scp:localhost#2222:Computers/Software/Operating_Systems/Unix/Shell/

# /scp:localhost#2222:/home/jochen_hayek/Computers/Software/Operating_Systems/Unix/Shell/README--JPEG--oneliners.txt
#
#   FileModifyDate looks useful

shopt -s nullglob

exiftool -s -FileModifyDate   -FileName \
  x_??_of_??.jpg x_??_of_??.pdf |

perl -ne 'm/^FileName\s*:\s+(.*)/ && do { $fn = $1;  print "mv \"$fn\" \"999990-000--${time_stamp}--___.$fn\"\n"; ${time_stamp} = ""; } ; m/^FileModifyDate\s*:\s+(....).(..).(..).(..).(..).(..)/   && do { $time_stamp = "$1$2$3$4$5$6"; };'
