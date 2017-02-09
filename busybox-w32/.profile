:

# Time-stamp: <2017-01-17 13:14:58 jhayek>

# this ~/.profile is for use with busybox-w32 ash

this_script=.profile

if test -z "$LINENO"
then LINENO=0
fi

: printf 1>&2 ">%s,%d: // %s\n" "$this_script" $LINENO \
  '...'

: printf 1>&2 "=%s,%d: // %s\n" "$this_script" $LINENO \
  '...'

ENV=$HOME/AppData/Roaming/.busybox.d/.shinit; export ENV

printf 1>&2 "=%s,%d: %s=>{%s} // %s\n" "$this_script" $LINENO \
  '$ENV' "$ENV" \
  '...'

: printf 1>&2 "<%s,%d: // %s\n" "$this_script" $LINENO \
  '...'

# Local variables:
# coding: utf-8-unix
# End:
