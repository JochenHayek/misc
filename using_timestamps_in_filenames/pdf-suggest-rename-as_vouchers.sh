:

# -> README--rename.txt

# https://github.com/JochenHayek/misc/

################################################################################

if true
then :
  pdfinfo -rawdates 1> /dev/null 2> /dev/null
  if test $? -eq 99		# if the option is available, 99 gets returned as exit code -- yes, 99 truely means, this option *is* available
  then :
    pdfinfo_options='-meta -rawdates' # the option is available, so let's use it!
  else :
    pdfinfo_options='-meta'
  fi
elif true
then :
  pdfinfo_version=$(pdfinfo -v 2>&1)

  case "$pdfinfo_version" in
    'pdfinfo version 3.0'*)	# on a Synology Diskstation -- there it lives in the package "xpdf"
      pdfinfo_options='-meta'
      ;;
    'pdfinfo version 0.2'?.*)	# on my other Linuxes etc. (wherever applicable)
      pdfinfo_options='-meta -rawdates'
    ##pdfinfo_options='-meta'
      ;;
    *)
      printf 1>&2 "*** %s,%d: %s=>{%s} // %s\n" "$0" "$LINENO" \
	"\$pdfinfo_version" "$pdfinfo_version" \
	'unexpected'
      exit 1
      ;;
  esac
fi

##for filename in "${@}"
for filename
do
  test -f "${filename}" || continue

  echo "*** ${filename}:"

##pdfinfo -meta -rawdates "${filename}" |
##pdfinfo -meta 	  "${filename}" |

  pdfinfo ${pdfinfo_options} "${filename}" |

##perl -MFile::Basename -s -ne ' ${basename} = basename(${filename},".pdf"); chomp; m/ ^ (?<n>.*Date): \s* D: (?<v>\d+) (-.*|Z)? $ /x && printf                "# %20s=>{%s} // %s\n"					 ,$+{n},$+{v},${filename};' -- "-filename=${filename}"

  perl -MFile::Basename \
    -s \
    -ne '

       use warnings FATAL => 'all';
       use strict;

       my(%month_name2no) = ("Jan"=>"01","Feb"=>"02","Mar"=>"03","Apr"=>"04","May"=>"05","Jun"=>"06","Jul"=>"07","Aug"=>"08","Sep"=>"09","Oct"=>"10","Nov"=>"11","Dec"=>"12");

       our($filename);

       my($basename) = basename($filename,".pdf");
       my($dirname)  = dirname($filename);
       chomp;

       my($YYYY,$mm,$dd,$HH,$MM,$SS);

       # "pdfinfo" delivers this:
       #
       # CreationDate:   15.03.05,10:29:14+01'00'

       if( m/ ^ (?<n>.*Date): \s+ (?<v>  (?<YY>\w+) \. (?<mm>\w+) \. (?<dd>\w+) ,  (?<HH>\d\d) : (?<MM>\d\d) : (?<SS>\d\d) ) .* $ /x )
	 {
	   $YYYY = '20' . $+{YY};
	   $mm   = $+{mm};
	   $dd   = $+{dd};
	   $HH   = $+{HH};
	   $MM   = $+{MM};
	   $SS   = $+{SS};

	   printf "mv \"%s\" \"%s/%s--%s--%s.%s\" # %20s=>{%s} // %s\n",
	     $filename,
	     $dirname,"999990-000",$YYYY.$mm.$dd.$HH.$MM.$SS,$basename,"pdf",
	     $+{n},$+{v},
	     $filename,
	     ;
	 }

       # CreationDate:   21/12/2004 16:24:57

       if( m/ ^ (?<n>.*Date): \s+ (?<v> (?<dd>\w+) \/ (?<mm>\w+) \/ (?<YYYY>\w+) \s+  (?<HH>\d\d) : (?<MM>\d\d) : (?<SS>\d\d) ) $ /x )
	 {
	   $YYYY = $+{YYYY};
	   $mm   = $+{mm};
	   $dd   = $+{dd};
	   $HH   = $+{HH};
	   $MM   = $+{MM};
	   $SS   = $+{SS};

	   printf "mv \"%s\" \"%s/%s--%s--%s.%s\" # %20s=>{%s} // %s\n",
	     $filename,
	     $dirname,"999990-000",$YYYY.$mm.$dd.$HH.$MM.$SS,$basename,"pdf",
	     $+{n},$+{v},
	     $filename,
	     ;
	 }

       # "pdfinfo -meta" (w/o -rawdates) delivers this:
       #
       # CreationDate:   Thu Dec 18 09:10:04 2014

       if( m/ ^ (?<n>.*Date): \s+ (?<v> (?<weekday>\w+) \s+ (?<monthname>\w+) \s+ (?<day_of_month>\w+) \s+  (?<HH>\d\d) : (?<MM>\d\d) : (?<SS>\d\d) \s+ (?<YYYY>\w+) ) $ /x )
	 {
	   $YYYY = $+{YYYY};
	   $mm   = $month_name2no{ $+{monthname} };
	   $dd   = sprintf "%02.2d",$+{day_of_month};
	   $HH   = $+{HH};
	   $MM   = $+{MM};
	   $SS   = $+{SS};

	   printf "mv \"%s\" \"%s/%s--%s--%s.%s\" # %20s=>{%s} // %s\n",
	     $filename,
	     $dirname,"999990-000",$YYYY.$mm.$dd.$HH.$MM.$SS,$basename,"pdf",
	     $+{n},$+{v},
	     $filename,
	     ;
	 }

       # "pdfinfo -meta -rawdates" delivers this:
       #
       # CreationDate:   D:20141218091004+01'00'

       if( m/ ^ (?<n>.*Date): \s* D: (?<v>\d+) (.*) $ /x )
	 {
	   printf "mv \"%s\" \"%s/%s--%s--%s.%s\" # %20s=>{%s} // %s\n",
	     $filename,
	     $dirname,"999990-000",$+{v},$basename,"pdf",
	     $+{n},$+{v},
	     $filename,
	     ;
	 }

       # <xmp:MetadataDate>2014-07-01T16:45:02+02:00</xmp:MetadataDate>
       # <xmp:CreateDate>2014-07-01T16:45:02+02:00</xmp:CreateDate>
       # <xmp:ModifyDate>2014-07-01T16:45:02+02:00</xmp:ModifyDate></rdf:Description>

       # <dc:date>2014-07-01T16:45:02+02:00</dc:date>

     ##if(m/ ^ \s* <xmp:CreateDate> /ix)
     ##  {
     ##    print "***{",$_,"}***\n";
     ##  }
     ##else
     ##  {
     ##    print "???{",$_,"}???\n";
     ##  }

       if( m/ ^ \s* < (?<n0> \w+ :\w* Date) > (?<v>.*) <\/ (?<n1> \w+ : \w* Date) > /ix )
	 {
	   $YYYY = substr($+{v}, 0,4);
	   $mm   = substr($+{v}, 5,2);
	   $dd   = substr($+{v}, 8,2);
	   $HH   = substr($+{v},11,2);
	   $MM   = substr($+{v},14,2);
	   $SS   = substr($+{v},17,2);

	   printf "mv \"%s\" \"%s/%s--%s--%s.%s\" # %20s=>{%s} // %s\n",
	     $filename,
	     $dirname,"999990-000",$YYYY.$mm.$dd.$HH.$MM.$SS,$basename,"pdf",
	     $+{n0},$+{v},
	     $filename,
	     ;
	 }

    ' \
    -- "-filename=${filename}"
done
