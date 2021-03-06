:

################################################################################
################################################################################
################################################################################

# how to lock/unlock:
#
# $ module_lock_setup
#
# $ lock_acquire .../${FOO}.lockdir
#
# $ lock_release .../${FOO}.lockdir

################################################################################

# theory:

# topic "Correct locking in shell scripts"
# https://unix.stackexchange.com/questions/22044/correct-locking-in-shell-scripts

# topic "How can I ensure that only one instance of a script is running at a time (mutual exclusion, locking)?"
# http://mywiki.wooledge.org/BashFAQ/045

################################################################################

# this is the lock itself (a directory):
#
#   .../${foo}.lockdir
#
# this is what we store within the lock (PID, /proc/.../cmdline, ...):
#
#   .../${foo}.lockdir/pid
#
#   .../${foo}.lockdir/cmdline	// from /proc/$PID/cmdline

################################################################################

# https://en.wikipedia.org/wiki/Log4j
#
# https://en.wikipedia.org/wiki/Log4j#TTCC
#
#   our output does *not* follow TTCC ("Time Thread Category Component").
#
#   our "__style_TC" variants look like "Time Category ...".
#
#   our "__style_JH" variants look like ... .

function _lock_log1()
{
  local                   _D0="$1"
  local                   _LN="$2"

  local                 level="$3"
  local                  lock="$4"

  local                   msg="$5"

  printf 1>&2 "*** ,%s,%s,%s: %s=>{%s},%s=>{%s}\t// %s\n" "$(date '+%FT%T')" "${_D0}" "${_LN}" \
      '$level' "$level" \
      '$lock' "$lock" \
      "$msg"

  case "$level" in
    INFO | WARN | ERROR | FATAL )
      : add_entry_to_log_table "$level" "$msg (lock=>$lock)"
      ;;
  esac
}

function _lock_log2()
{
  local                   _D0="$1"
  local                   _LN="$2"

  local                 level="$3"
  local                  lock="$4"
  local                   pid="$5"

  local                   msg="$6"

  printf 1>&2 "*** ,%s,%s,%s: %s=>{%s},%s=>{%s},%s=>{%s}\t// %s\n" "$(date '+%FT%T')" "${_D0}" "${_LN}" \
      '$level' "$level" \
      '$lock' "$lock" \
      '$pid' "$pid" \
      "$msg"

  case "$level" in
    INFO | WARN | ERROR | FATAL )
      : add_entry_to_log_table "$level" "$msg (lock=>$lock,pid=>$pid)"
      ;;
  esac
}

function _lock_log1__style_TC()
{
  local                   _D0="$1"
  local                   _LN="$2"

  local                 level="$3"
  local                  lock="$4"

  local                   msg="$5"

  printf 1>&2 "%s %s %s=>{%s}\t// %s\n" "$(date '+%FT%T')" \
      "$level" \
      '$lock' "$lock" \
      "$msg"
}

function _lock_log2__style_TC()
{
  local                   _D0="$1"
  local                   _LN="$2"

  local                 level="$3"
  local                  lock="$4"
  local                   pid="$5"

  local                   msg="$6"

  printf 1>&2 "%s %s %s=>{%s},%s=>{%s}\t// %s\n" "$(date '+%FT%T')" \
      "$level" \
      '$lock' "$lock" \
      '$pid' "$pid" \
      "$msg"
}

function _lock_log1__style_JH()
{
  local                   _D0="$1"
  local                   _LN="$2"

  local                 level="$3"
  local                  lock="$4"

  local                   msg="$5"

  printf 1>&2 "*** ,%s,%s,%s: %s=>{%s},%s=>{%s}\t// %s\n" "$(date '+%FT%T')" "${_D0}" "${_LN}" \
      '$level' "$level" \
      '$lock' "$lock" \
      "$msg"
}

function _lock_log2__style_JH()
{
  local                   _D0="$1"
  local                   _LN="$2"

  local                 level="$3"
  local                  lock="$4"
  local                   pid="$5"

  local                   msg="$6"

  printf 1>&2 "*** ,%s,%s,%s: %s=>{%s},%s=>{%s},%s=>{%s}\t// %s\n" "$(date '+%FT%T')" "${_D0}" "${_LN}" \
      '$level' "$level" \
      '$lock' "$lock" \
      '$pid' "$pid" \
      "$msg"
}

################################################################################

function _lock_remove()
{
  local                 lock="$1"

  rm --force --recursive "$lock"
  : _lock_log1 "${FUNCNAME[0]}" "${LINENO}" TRACE "$lock" 'removed a lock'
}

################################################################################

function _lock_store_attributes()
{
  local                 lock="$1"

  echo $$                       > "$lock/pid"

  if test $(uname -s) = Darwin	# no procfs
  then ps -o command= $$             > "$lock/cmdline"
  else cp --archive /proc/$$/cmdline   "$lock/cmdline"
  fi

  ##_lock_log2 "${FUNCNAME[0]}" "${LINENO}" INFO "$lock" "$$" 'going to show source and target ...'
  ##echo
  ##echo '***0***'
  ##echo
  ##head -999    /proc/$$/cmdline "$lock/cmdline" | cat -A
  ##echo
  ##echo '***1***'
  ##echo
}

function _lock_compare_cmdline()
{
  local                 left="$1"
  local                right="$2"

  # this one works:

  diff 2>/dev/null         --text "$left" "$right"

  # there are problems with these ones:

##diff 2>/dev/null --brief --text "$left" "$right"
##cmp --silent                    "$left" "$right"
}

################################################################################

function module_lock_setup()
{
  # check availability of environment variables
  # as needed by:
  # * add_entry_to_log_table
  # * ...
  #
  # #todo
  :
}

function lock_acquire()
{
  local                 lock="$1"

  : _lock_log1 "${FUNCNAME[0]}" "${LINENO}" TRACE "$lock" '...'

  if mkdir 2>/dev/null "$lock"
  then

    : _lock_log1 "${FUNCNAME[0]}" "${LINENO}" TRACE "$lock" 'successful mkdir (on 1st attempt) -- it is *our* lock now'

    trap 'status=$?; rm --force --recursive "'"$lock"'"; exit "$status"' INT TERM EXIT

    _lock_store_attributes "$lock"

  else		# if mkdir 2>/dev/null "$lock"

    : _lock_log1 "${FUNCNAME[0]}" "${LINENO}" TRACE "$lock" 'mkdir failed -- why?'

    if test -d "$lock" && test -f "$lock/pid"
    then

      # https://stackoverflow.com/questions/7427262/how-to-read-a-file-into-a-variable-in-shell#10771857
      #
      local PID=$( < "$lock/pid" )

      if test ! -d "/proc/$PID"
      then :

	_lock_log2 "${FUNCNAME[0]}" "${LINENO}" INFO "$lock" "$PID" 'lock exists, owned by ... (dead) -- trying to acquire it again ...'

	_lock_remove "$lock"

	if mkdir 2>/dev/null   "$lock"
	then

	  : _lock_log1 "${FUNCNAME[0]}" "${LINENO}" TRACE "$lock" 'successful mkdir (after removing a lock owned by a dead process) -- it is *our* lock now'

	  trap 'status=$?; rm --force --recursive "'"$lock"'"; exit "$status"' INT TERM EXIT

	  _lock_store_attributes "$lock"

	else	# if mkdir 2>/dev/null "$lock"

	  _lock_log2 "${FUNCNAME[0]}" "${LINENO}" FATAL "$lock" "$PID" 'lock exists, owned by ... (dead) -- tried to acquire it again, but failed'

	  exit 2

	fi	# if mkdir 2>/dev/null "$lock"

      elif diff 2>/dev/null --text /proc/$PID/cmdline "$lock/cmdline"
      then

	_lock_log2 "${FUNCNAME[0]}" "${LINENO}" INFO "$lock" "$PID" 'lock exists, owned by ... (*alive*) -- *same* cmdline -- we are out -- good bye!'

	exit 1

      else	# if diff 2>/dev/null --text /proc/$PID/cmdline "$lock/cmdline"

	_lock_log2 "${FUNCNAME[0]}" "${LINENO}" INFO "$lock" "$PID" 'lock exists, owned by ... (*alive*) -- *different* cmdline (*strange*) , trying to acquire it again ...'
	  
        _lock_remove "$lock"

	if mkdir 2>/dev/null   "$lock"
	then

	  : _lock_log1 "${FUNCNAME[0]}" "${LINENO}" TRACE "$lock" 'successful mkdir (after removing a weird lock) -- it is *our* lock now'

	  trap 'status=$?; rm --force --recursive "'"$lock"'"; exit "$status"' INT TERM EXIT

	  _lock_store_attributes "$lock"

	else	# if mkdir 2>/dev/null "$lock"

	  _lock_log2 "${FUNCNAME[0]}" "${LINENO}" FATAL "$lock" "$PID" 'lock exists, owned by ... (*alive*) -- *different* cmdline, tried to acquire it again, but failed'

	  exit 2

	fi	# if mkdir 2>/dev/null "$lock"
      fi	# if diff 2>/dev/null --text /proc/$PID/cmdline "$lock/cmdline"

    else	# if test -d "$lock" && test -f "$lock/pid"

      _lock_log1 "${FUNCNAME[0]}" "${LINENO}" INFO "$lock" 'lock exists, but not created by us (before) -- trying to acquire it ...'

      _lock_remove "$lock"

      if mkdir 2>/dev/null   "$lock"
      then

	: _lock_log1 "${FUNCNAME[0]}" "${LINENO}" TRACE "$lock" 'successful mkdir (after removing a lock) -- it is *our* lock now'

	trap 'status=$?; rm --force --recursive "'"$lock"'"; exit "$status"' INT TERM EXIT

	_lock_store_attributes "$lock"

      else	# if mkdir 2>/dev/null "$lock"

	_lock_log2 "${FUNCNAME[0]}" "${LINENO}" FATAL "$lock" "$PID" 'lock exists, owned by ... (*alive*) -- *different* cmdline (o, o!) -- tried to acquire it again, but failed -- we are out -- good bye!'

	exit 1

      fi	# if mkdir 2>/dev/null "$lock"
    fi		# if test -d "$lock" && test -f "$lock/pid"
  fi		# if mkdir 2>/dev/null "$lock"
}

function lock_release()
{
  local                 lock="$1"

  : _lock_log1 "${FUNCNAME[0]}" "${LINENO}" TRACE "$lock" '...'

  _lock_remove "$lock"

  trap - INT TERM EXIT
}
