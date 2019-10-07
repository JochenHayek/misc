#! /bin/sh
#! /bin/bash
#! /bin/ksh
#! /usr/bin/ksh

# misc/using_timestamps_in_filenames/create_snapshot_from_OOXML.sh

################################################################################

# wishlist:
# * accept files from STDIN, if none are on the command list

# related tools:
# -> ~/Computers/Software/Operating_Systems/Unix/Shell/README--diff_and_snapshot.txt

################################################################################

##PERL='c:/Program Files/Git/usr/bin/perl.exe'
  PERL=perl

##xmlstarlet=~jhayek/opt/xmlstarlet-1.6.1/xml
##xmlstarlet=$USERPROFILE/opt/xmlstarlet-1.6.1/xml
##xmlstarlet=/sw/bin/xml

xmlstarlet 2>/dev/null
if test $? -eq 2
then xmlstarlet=xmlstarlet
else xmlstarlet=xml
fi

##CP=/cygdrive/c/cygwin64/bin/cp
  CP=cp
##MV=/cygdrive/c/cygwin64/bin/mv
  MV=mv

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

  # use the OS mtime AKA "modification time" (stamp):

  # you may want to use either of them:
  # * gmtime
  # * localtime

##date=$( "${PERL}" -MFile::stat -MPOSIX -e 'printf "%s\n",( strftime "%Y%m%d%H%M%S",localtime(stat($ARGV[0])->mtime) )' "$i" )

  ################################################################################

  # https://en.wikipedia.org/wiki/Office_Open_XML_file_formats – "OOXML" – used by Microsoft Office (.xslx, .docx, .vsdx, …)

  # use an OOXML file's "modified" timestamp:

  if unzip -p "$i" docProps/core.xml 2> /dev/null > /dev/null
  then :
  else :
    printf 1>&2 "=%s,%d: %s=>{%s} // %s\n" $0 $LINENO \
      '$i' "$i" \
      'trouble: non-existent docProps/core.xml – no modification timestamp'
    exit 1
  fi

  date_modified=$( unzip -p "$i" docProps/core.xml | "${xmlstarlet}" sel --template --value-of cp:coreProperties/dcterms:modified | tr -d ':TZ-' )
   date_created=$( unzip -p "$i" docProps/core.xml | "${xmlstarlet}" sel --template --value-of cp:coreProperties/dcterms:created  | tr -d ':TZ-' )

  if   test -n "$date_modified"
  then    date="$date_modified"
  elif test -n "$date_created"
  then    date="$date_created"
  else    date="___"
  fi

  ################################################################################

  # https://en.wikipedia.org/wiki/OpenDocument – "ODF" – used by OpenOffice (.odt, .ods, …)

  # use an ODF file's "modified" timestamp:

##date=$( unzip -p "$i" meta.xml | "${xmlstarlet}" sel --template --value-of office:document-meta/office:meta/dc:date | tr -d ':TZ-' | "${PERL}" -pe 's/^(.*)\..*$/$1/' )

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
