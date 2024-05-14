#! /bin/bash
#! /bin/sh
#! /bin/ksh
#! /usr/bin/ksh

# git-servers/github.com/JochenHayek/misc/using_timestamps_in_filenames/create_snapshot.sh

################################################################################

# preferred scenarios:
#
# * within emacs's dired:
#
#   ! ~/bin/create_snapshot.sh 
#
# * within emacs's dired on Windows with busybox-w...:
#
#   ! c:/opt/busybox/busybox64 bash $APPDATA/bin/create_snapshot.sh 

################################################################################

# wishlist:
# * accept files from STDIN, if none are on the command list

# related tools:
# -> git-servers/github.com/JochenHayek/misc/using_timestamps_in_filenames/README--diff_and_snapshot.txt

################################################################################

CP=cp
MV=mv
LS=ls

################################################################################

# use the OS mtime AKA "modification time" (stamp):

# you may want to use either of them:
# * gmtime
# * localtime

# "ls --full-time" is available in a BusyBox shell.
# even in a BusyBox environnment, we may have a tinyperl.
#
# in case we will be in a BusyBox w/o tinyperl,
# we will have to replace the perl command line with some "sed" or "awk".
#
# if "ls --full-time" is not available,
# let's hope, we have some perl with File::stat and POSIX etc.

if test -f 'c:/opt/tinyperl/tinyperl.exe'
then :
  PERL='c:/opt/tinyperl/tinyperl.exe'
elif test -f 'c:/Program Files/Git/usr/bin/perl.exe'
then :
  PERL='c:/Program Files/Git/usr/bin/perl.exe'
else :
  PERL=perl
##PERL=/bin/perl
##PERL=/usr/bin/perl
fi

if "${LS}" --full-time /dev/null 2>/dev/null 1>/dev/null
then :
  extract_date()
  {
    # -rw-r--r--. 1 foobar foobar 18 2022-06-20 13:31:04.000000000 +0200 .bash_logout
    # -rw-r--r--. 1 foobar foobar 18 2022-06-20 13:31:04.000000000 +0200 .bash_logout

    # group with space characters ... – use 4-digit-year-number as safe part to recognise!
    #
    # -rw-------. 1 foobar@bla domain users@bla 18 2024-05-14 09:43:20.435726504 +0200 .bash_logout

  ##"${LS}" -l --time-style=+%Y%m%d%H%M%S "$i" | "${PERL}" -ne 'm/^.......... \s+ (\d+) \s+ (\w+) \s+ (\w+) \s+ (\d+) \s+ (\d+)/x && print "$5\n"'
    "${LS}" -l --full-time "$i" | "${PERL}" -ne 'm/^\S+ \s+ (\d+) \s+ (.+) \s+ (\d+) \s+ (\d\d\d\d)-(\d+)-(\d+) \s+ (\d+):(\d+):(\d+)/x && print "${4}${5}${6}${7}${8}${9}\n"';
  }
else :
  extract_date()
  {
    "${PERL}" -MFile::stat -MPOSIX -e 'printf "%s\n",( strftime "%Y%m%d%H%M%S",localtime(stat($ARGV[0])->mtime) )' "$i"
  }
fi

################################################################################

# CAVEAT: which shell is it?

# Bash:
#
if test -n "$BASH_VERSINFO"
then shopt -s extglob nullglob
fi

# a simple shell like the BusyBox ash does not have $LINENO,
# so we want at least to set it to 0:
#
if test -z "$LINENO"
then LINENO=0
fi

################################################################################

: printf 1>&2 "=%s,%d: %s=>{%s} // %s\n" $0 $LINENO \
  '$#' "$#" \
  '...'

for i
do :
  if   test -h "$i"
  then continue
  elif test -f "$i"
  then :
  else :
    : printf 1>&2 "=%s,%d: %s=>{%s} // %s\n" $0 $LINENO \
      '$i' "$i" \
      'does not exist, ignored'
    continue
  fi

  : printf 1>&2 "=%s,%d: %s=>{%s} // %s\n" $0 $LINENO \
    '$i' "$i" \
    '...'

  date=$( extract_date "$i"; )

  ################################################################################
  ################################################################################

  case "$i" in

# w/o "shopt -s extglob", e.g. for the BusyBox shell:

  ##      *.~[0-9]~  |       *.~[0-9][0-9]~  |       *.~[0-9][0-9][0-9]~  | \
  ##*.~[0-9].[0-9]~  | *[0-9]..~[0-9][0-9]~  | *[0-9]..~[0-9][0-9][0-9]~  | \
  ##*.~[0-9].[0-9].~ | *[0-9]..~[0-9][0-9].~ | *[0-9]..~[0-9][0-9][0-9].~ )

####*.~+([0-9])~ | *.~+([0-9]).+([0-9])~ | *.~+([0-9]).+([0-9]).~ )
    *.~+([[:digit:]])~ | *.~+([[:digit:]]).+([[:digit:]])~ | *.~+([[:digit:]]).+([[:digit:]]).~ )

      dn=$( dirname  "$i" )
      bn=$( basename "$i" | "${PERL}" -ne 's/^(.*)(\.~[\.\d]+\.?~)$/$1/ && print $1,"\n"' )
      if test -e "$dn/$bn.$date"
      then :
	: printf 1>&2 "=%s,%d: %s=>{%s},%s=>{%s} // %s\n" $0 $LINENO \
	  '$i' "$i" \
	  '$dn/$bn.$date' "$dn/$bn.$date" \
	  'snapshot already exists, removing ...'
	rm -f "$i"
      else :
	printf 1>&2 "=%s,%d: %s=>{%s},%s=>{%s} // %s\n" $0 $LINENO \
	  '$i' "$i" \
	  '$dn/$bn.$date' "$dn/$bn.$date" \
	  'renaming from ... to ...'
        "${MV}" -v "$i" "$dn/$bn.$date" ||
	printf 1>&2 "=%s,%d: %s=>{%s},%s=>{%s},%s=>{%s} // %s\n" $0 $LINENO \
	  '$i' "$i" \
	  '$dn/$bn.$date' "$dn/$bn.$date" \
	  '$?' "$?" \
	  '...'
      fi
      ;;
    *~ | *.old | *.bak )
      dn=$( dirname  "$i" )
      case "$i" in
	*~    ) bn=$( basename "$i" '~'    ) ;;
	*.old ) bn=$( basename "$i" '.old' ) ;;
	*.bak ) bn=$( basename "$i" '.bak' ) ;;
      esac
      if test -e "$dn/$bn.$date"
      then :
	: printf 1>&2 "=%s,%d: %s=>{%s},%s=>{%s} // %s\n" $0 $LINENO \
	  '$i' "$i" \
	  '$dn/$bn.$date' "$dn/$bn.$date" \
	  'snapshot already exists, removing ...'
	rm -f "$i"
      else :
	printf 1>&2 "=%s,%d: %s=>{%s},%s=>{%s} // %s\n" $0 $LINENO \
	  '$i' "$i" \
	  '$dn/$bn.$date' "$dn/$bn.$date" \
	  'renaming from ... to ...'
        "${MV}" -v "$i" "$dn/$bn.$date" ||
	printf 1>&2 "=%s,%d: %s=>{%s},%s=>{%s},%s=>{%s} // %s\n" $0 $LINENO \
	  '$i' "$i" \
	  '$dn/$bn.$date' "$dn/$bn.$date" \
	  '$?' "$?" \
	  '...'
      fi
      ;;
    *)
      if test -e "$i.$date"
      then :
	: printf 1>&2 "=%s,%d: %s=>{%s},%s=>{%s} // %s\n" $0 $LINENO \
	  '$i' "$i" \
	  '$i.$date' "$i.$date" \
	  'snapshot already exists'
      else :
	printf 1>&2 "=%s,%d: %s=>{%s},%s=>{%s} // %s\n" $0 $LINENO \
	  '$i' "$i" \
	  '$i.$date' "$i.$date" \
	  'copying from ... to ...'
      ##cp -p         		   		"$i" $i.$date
      ##cp --preserve 		   		"$i" $i.$date
      ##cp --preserve=mode,ownership,timestamps "$i" $i.$date
      ##cp --preserve=ownership,timestamps      "$i" $i.$date	# in the cygwin world this works best, otherwise: cp: preserving permissions for '...': Permission denied
      	"${CP}" -p -v "$i" "$i.$date" ||
	printf 1>&2 "=%s,%d: %s=>{%s},%s=>{%s},%s=>{%s} // %s\n" $0 $LINENO \
	  '$i' "$i" \
	  '$i.$date' "$i.$date" \
	  '$?' "$?" \
	  '...'
      fi
      ;;
  esac
done

# Local variables:
# coding: utf-8-unix
# End:
