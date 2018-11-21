#! /bin/bash

# usage:
#
#   $ .../renumber_duplex_scanned_files.sh new_name old_names
#
# e.g.:
#
#   $ .../renumber_duplex_scanned_files.sh new. ...
#
#     -> new.01of04.png new.02of04.png new.03of04.png new.04of04.png

################################################################################

# for testing purposes:
#
# $ mkdir renumber_duplex_scanned_files.dir && cd renumber_duplex_scanned_files.dir && touch {a,b,c,d,e,f}.png
# $ ../renumber_duplex_scanned_files.sh x. [a-f].png

################################################################################

new_name="$1"

max=$(( $# - 1 ))
half_max=$(( max / 2  ))
rem_max=$(( max % 2  ))

half_max_plus_1=$(( max / 2 + 1 ))

max_formatted=$( printf "%02.2d" "$max" )

if true
then :

  echo   1>&2
  printf 1>&2 "=%s,%02.2d: %s=>{%s} // %s\n" "$0" $LINENO \
    '$new_name' "$new_name" \
    '?!?!?!?!?!?'
  echo   1>&2

  printf 1>&2 "=%s,%02.2d: %s=>{%s},%s=>{%s},%s=>{%s} // %s\n" "$0" $LINENO \
    '$max' "$max" \
    '$half_max' "$half_max" \
    '$rem_max' "$rem_max" \
    '...'
fi

if test "$rem_max" -eq 0
then :
else :
  printf 1>&2 "=%s,%02.2d: %s=>{%s},%s=>{%s},%s=>{%s},%s=>{%s} // %s\n" "$0" $LINENO \
    '$new_name' "$new_name" \
    '$max' "$max" \
    '$half_max' "$half_max" \
    '$rem_max' "$rem_max" \
    '$max is not an even number'

  echo   1>&2
  printf 1>&2 "=%s,%02.2d: %s=>{%s} // %s\n" "$0" $LINENO \
    '$new_name' "$new_name" \
    '?!?!?!?!?!?'
 exit 1
fi

for i in $(seq --format="%02.f" 1 2 "$max")
do :
  : echo $i

  false &&
  printf 1>&2 "=%s,%02.2d: %s=>{%s},%s=>{%s} // %s\n" "$0" $LINENO \
    '$new_name' "$new_name" \
    '$i' "$i" \
    '...'

  shift
  current_file="$1"
  extension_of_current_file=${current_file##*.}
##echo mv "$current_file" "${new_name}${i}of${max_formatted}.${extension_of_current_file}"
  mv      "$current_file" "${new_name}${i}of${max_formatted}.${extension_of_current_file}"
done

for i in $(seq --format="%02.f" "$max" -2 1)
do :
  : echo $i

  false &&
  printf 1>&2 "=%s,%02.2d: %s=>{%s},%s=>{%s} // %s\n" "$0" $LINENO \
    '$new_name' "$new_name" \
    '$i' "$i" \
    '...'

  shift
  current_file="$1"
##echo mv "$current_file" "${new_name}${i}of${max_formatted}.${extension_of_current_file}"
  mv      "$current_file" "${new_name}${i}of${max_formatted}.${extension_of_current_file}"
done

################################################################################

exit 0

################################################################################

o-1 => n-1
o-2 => n-3
o-3 => n-5
o-4 => n-6
o-5 => n-4
o-6 => n-2
