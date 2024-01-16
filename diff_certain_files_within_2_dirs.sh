:

# initial use described here:
#
# -> /media/_ARCHIVE/home/Aleph_Soft_GmbH-FROZEN-STUFF/Buchhaltung/SKR03-1200/Belege/999999-000--2008mmdd______--Lohn--Steuer_etc--period-2008mm.PLACEHOLDER.dir/README--compare_old_to_new.txt

# it's a little like "diff -r",
# but more restricted.

left_dir=$1
shift
right_dir=$1
shift

printf "*** %s,%d: %s=>{%s},%s=>{%s} // %s\n" "$(basename -- $0)" "$LINENO" \
  '$left_dir' "$left_dir" \
  '$right_dir' "$right_dir" \
  '...'

for i
do :

  printf "*** %s,%d: %s=>{%s} // %s\n" "$(basename -- $0)" "$LINENO" \
    '$i' "$i" \
    '...'

  diff $left_dir/$i $right_dir/$i

done
