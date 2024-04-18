#! /bin/sh
#! /bin/bash
#! /bin/ksh
#! /usr/bin/ksh

# misc/using_timestamps_in_filenames/create_snapshot_from_zip_using_7z.sh

################################################################################

# preferred scenarios:
#
# * within emacs's dired:
#
#   ! ~/bin/create_snapshot_from_zip_using_7z.sh
#
# * within emacs's dired on Windows with busybox-w...:
#
#   ! c:/opt/busybox/busybox64 bash $APPDATA/bin/create_snapshot_from_zip_using_7z.sh 

################################################################################

################################################################################

# wishlist:
# * accept files from STDIN, if none are on the command list

# related tools:
# -> git-servers/github.com/JochenHayek/misc/using_timestamps_in_filenames/README--diff_and_snapshot.txt

################################################################################
#
# sample output (the end only):

#    Date      Time    Attr         Size   Compressed  Name
# ------------------- ----- ------------ ------------  ------------------------
# 2024-04-18 09:07:40 .....        20375         3911  tasks-jira-tickets--sprint.diary
# 2024-04-18 09:07:40 .....       183565        29643  diary
# ------------------- ----- ------------ ------------  ------------------------
# 2024-04-18 09:07:40             203940        33554  2 files

################################################################################

##SEVENz=/usr/local/bin/7z
  SEVENz=7z

if test -f 'c:/opt/tinyperl/tinyperl.exe'
then :
  PERL='c:/opt/tinyperl/tinyperl.exe'
if test -f 'c:/Program Files/Git/usr/bin/perl.exe'
then :
  PERL='c:/Program Files/Git/usr/bin/perl.exe'
else :
  PERL=perl
##PERL=/bin/perl
##PERL=/usr/bin/perl
fi

CP=cp
MV=mv

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

  ################################################################################
  ################################################################################

  # use ...  timestamp:

  # 2024-04-18 09:07:40             203940        33554  2 files

  date=$( "${SEVENz}" l "$i" | tail -1 | "${PERL}" -ne 'm/^(?<YYYY>\d\d\d\d)-(?<mm>\d\d)-(?<dd>\d\d)\s(?<HH>\d\d):(?<MM>\d\d):(?<SS>\d\d)/ && print "$+{YYYY}$+{mm}$+{dd}$+{HH}$+{MM}$+{SS}\n"' )

  : printf 1>&2 "=%s,%d: %s=>{%s},%s=>{%s} // %s\n" $0 $LINENO \
    '$i' "$i" \
    '$date' "$date" \
    '...'

  ################################################################################
  ################################################################################

  case "$i" in

# w/o "shopt -s extglob", e.g. for the busybox shell:

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
        "${MV}" --verbose "$i" "$dn/$bn.$date" ||
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
        "${MV}" --verbose "$i" "$dn/$bn.$date" ||
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
      	"${CP}" -p --verbose -p "$i" "$i.$date" ||
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
