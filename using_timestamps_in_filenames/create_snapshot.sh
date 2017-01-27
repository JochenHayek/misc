#! /bin/bash
#! /bin/ksh
#! /usr/bin/ksh

# Time-stamp: <2017-01-27 10:24:16 jhayek>

# $Id: create_snapshot.sh 1.31 2017/01/16 20:47:08 johayek Exp johayek $

# $HOME/Computers/Software/Operating_Systems/Unix/Shell/create_snapshot.sh

################################################################################

# wishlist:
# * accept files from STDIN, if none are on the command list

# related tools:
# -> ~/Computers/Software/Operating_Systems/Unix/Shell/README--diff_and_snapshot.txt

################################################################################

# CAVEAT: which shell is it?

# Bash:
#
if test -n "$BASH_VERSINFO"
then shopt -s extglob
fi

# a simple shell like the BusyBox ash does not have $LINENO,
# so we want at least to set it to 0:
#
if test -z "$LINENO"
then LINENO=0
fi

################################################################################

false &&
printf 1>&2 "=%s,%d: %s=>{%s} // %s\n" $0 $LINENO \
  '$#' "$#" \
  '...' \
  ;

for i
do :
  if   test -h "$i"
  then continue
  elif test -f "$i"
  then :
  else :
    false &&
    printf 1>&2 "=%s,%d: %s=>{%s} // %s\n" $0 $LINENO \
      '$i' "$i" \
      'does not exist, ignored' \
      ;
    continue
  fi

  false &&
  printf 1>&2 "=%s,%d: %s=>{%s} // %s\n" $0 $LINENO \
    '$i' "$i" \
    '...' \
    ;

  ################################################################################

  # use the OS mtime AKA "modification time" (stamp):

  # you may want to use either of them:
  # * gmtime
  # * localtime

  date=$( perl -MFile::stat -MPOSIX -e 'printf "%s\n",( strftime "%Y%m%d%H%M%S",localtime(stat($ARGV[0])->mtime) )' "$i" )

  # use a Microsoft .xslx or .docx or ... file's "modified" timestamp:

##date=$( unzip -p "$i" docProps/core.xml | "$xmlstarlet" sel --template --value-of cp:coreProperties/dcterms:modified | tr -d ':TZ-' )

  ################################################################################

  case "$i" in

# w/o "shopt -s extglob", e.g. for the busybox shell:

          *.~[0-9]~  |       *.~[0-9][0-9]~  |       *.~[0-9][0-9][0-9]~  | \
    *.~[0-9].[0-9]~  | *[0-9]..~[0-9][0-9]~  | *[0-9]..~[0-9][0-9][0-9]~  | \
    *.~[0-9].[0-9].~ | *[0-9]..~[0-9][0-9].~ | *[0-9]..~[0-9][0-9][0-9].~ )

####*.~+([0-9])~ | *.~+([0-9]).+([0-9])~ | *.~+([0-9]).+([0-9]).~ )
  ##*.~+([[:digit:]])~ | *.~+([[:digit:]]).+([[:digit:]])~ | *.~+([[:digit:]]).+([[:digit:]]).~ )

      dn=$( dirname  "$i" )
      bn=$( basename "$i" | perl -ne 's/^(.*)(\.~[\.\d]+\.?~)$/$1/ && print $1,"\n"' )
      if test -e "$dn/$bn.$date"
      then :
	false &&
	printf 1>&2 "=%s,%d: %s=>{%s},%s=>{%s} // %s\n" $0 $LINENO \
	  '$i' "$i" \
	  '$dn/$bn.$date' "$dn/$bn.$date" \
	  'snapshot already exists, removing ...' \
	  ;
	rm -f "$i"
      else :
	printf 1>&2 "=%s,%d: %s=>{%s},%s=>{%s} // %s\n" $0 $LINENO \
	  '$i' "$i" \
	  '$dn/$bn.$date' "$dn/$bn.$date" \
	  'renaming from ... to ...' \
	  ;
	mv "$i" $dn/$bn.$date
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
	false &&
	printf 1>&2 "=%s,%d: %s=>{%s},%s=>{%s} // %s\n" $0 $LINENO \
	  '$i' "$i" \
	  '$dn/$bn.$date' "$dn/$bn.$date" \
	  'snapshot already exists, removing ...' \
	  ;
	rm -f "$i"
      else :
	printf 1>&2 "=%s,%d: %s=>{%s},%s=>{%s} // %s\n" $0 $LINENO \
	  '$i' "$i" \
	  '$dn/$bn.$date' "$dn/$bn.$date" \
	  'renaming from ... to ...' \
	  ;
	mv "$i" "$dn/$bn.$date"
      fi
      ;;
    *)
      if test -e "$i.$date"
      then :
	false &&
	printf 1>&2 "=%s,%d: %s=>{%s},%s=>{%s} // %s\n" $0 $LINENO \
	  '$i' "$i" \
	  '$i.$date' "$i.$date" \
	  'snapshot already exists' \
	  ;
      else :
	printf 1>&2 "=%s,%d: %s=>{%s},%s=>{%s} // %s\n" $0 $LINENO \
	  '$i' "$i" \
	  '$i.$date' "$i.$date" \
	  'copying from ... to ...' \
	  ;
      ##cp -p         		   		"$i" $i.$date
      ##cp --preserve 		   		"$i" $i.$date
      ##cp --preserve=mode,ownership,timestamps "$i" $i.$date
      ##cp --preserve=ownership,timestamps      "$i" $i.$date	# in the cygwin world this works best, otherwise: cp: preserving permissions for '...': Permission denied
      	cp -p "$i" "$i.$date"
      fi
      ;;
  esac
done

# Local variables:
# coding: utf-8-unix
# End:
