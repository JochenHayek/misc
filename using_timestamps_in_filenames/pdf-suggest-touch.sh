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

  perl -MFile::Basename \
    -s \
    -ne '

       use warnings FATAL => "all";
       use strict;

       use v5.16; # if this requirement makes this script fail, get rid of the old perl (again!!!) in favour of a newer perl on your PATH!

       my($display_case_p) = 0;

       my(%month_name2no) = ("Jan"=>"01","Feb"=>"02","Mar"=>"03","Apr"=>"04","May"=>"05","Jun"=>"06","Jul"=>"07","Aug"=>"08","Sep"=>"09","Oct"=>"10","Nov"=>"11","Dec"=>"12");

       our($filename);

       my($basename) = basename(${filename},".pdf");
       my($dirname)  = dirname(${filename});
       chomp;

       # "pdfinfo" delivers this:
       #
       # CreationDate:   15.03.05,10:29:14+01'00'

       if( m/ ^ (?<n>.*Date): \s+ (?<v>  (?<YY>\w+) \. (?<mm>\w+) \. (?<dd>\w+) ,  (?<HH>\d\d) : (?<MM>\d\d) : (?<SS>\d\d) ) .* $ /x )
	 {
           my(%plus) = %+;

           printf STDERR "# %d: %s=>{%s},%s=>{%s} // %s\n",__LINE__,
             "\$plus{n}" => $plus{n},
             "\$plus{v}" => $plus{v},
             "..."
             if $display_case_p;

	   $plus{YYYY} = "20" . $plus{YY};

	   my($ts_traditional) = "$plus{YYYY}$plus{mm}$plus{dd}$plus{HH}$plus{MM}.$plus{SS}";

	   printf "touch -t \"%s\" \"%s\" # %20s=>{%s}\n",
	     $ts_traditional,
	     $filename,
	     $plus{n} => $plus{v},
	     ;
	 }

       # CreationDate:   21/12/2004 16:24:57

       if( m/ ^ (?<n>.*Date): \s+ (?<v> (?<dd>\w+) \/ (?<mm>\w+) \/ (?<YYYY>\w+) \s+  (?<HH>\d\d) : (?<MM>\d\d) : (?<SS>\d\d) ) $ /x )
	 {
           my(%plus) = %+;

           printf STDERR "# %d: %s=>{%s},%s=>{%s} // %s\n",__LINE__,
             "\$plus{n}" => $plus{n},
             "\$plus{v}" => $plus{v},
             "..."
             if $display_case_p;

	   my($ts_traditional) = "$plus{YYYY}$plus{mm}$plus{dd}$plus{HH}$plus{MM}.$plus{SS}";

	   printf "touch -t \"%s\" \"%s\" # %20s=>{%s}\n",
	     $ts_traditional,
	     $filename,
	     $plus{n} => $plus{v},
	     ;
	 }

       # "pdfinfo -meta" (w/o -rawdates) delivers this:
       #
       # CreationDate:   Thu Dec 18 09:10:04 2014

       if( m/ ^ (?<n>.*Date): \s+ (?<v> (?<weekday>\w+) \s+ (?<monthname>\w+) \s+ (?<day_of_month>\w+) \s+  (?<HH>\d\d) : (?<MM>\d\d) : (?<SS>\d\d) \s+ (?<YYYY>\w+) ) $ /x )
	 {
           my(%plus) = %+;

           printf STDERR "# %d: %s=>{%s},%s=>{%s} // %s\n",__LINE__,
             "\$plus{n}" => $plus{n},
             "\$plus{v}" => $plus{v},
             "..."
             if $display_case_p;

	   $plus{mm}   = $month_name2no{  $plus{monthname} };
	   $plus{dd}   = sprintf "%02.2d",$plus{day_of_month};

	   my($ts_traditional) = "$plus{YYYY}$plus{mm}$plus{dd}$plus{HH}$plus{MM}.$plus{SS}";

	   printf "touch -t \"%s\" \"%s\" # %20s=>{%s}\n",
	     $ts_traditional,
	     $filename,
	     $plus{n} => $plus{v},
	     ;
	 }

       # "pdfinfo -meta -rawdates" delivers this:
       #
       # CreationDate:   D:20141218091004+01'00'

       if( m/ ^ (?<n>.*Date): \s* D: (?<v> ( (?<v_less_SS> \d+) (?<SS> \d\d) ) ) (.*) $ /x )
	 {
           my(%plus) = %+;

           printf STDERR "# %d: %s=>{%s},%s=>{%s} // %s\n",__LINE__,
             "\$plus{n}" => $plus{n},
             "\$plus{v}" => $plus{v},
             "..."
             if $display_case_p;

	   my($ts_traditional) = "$plus{v_less_SS}.$plus{SS}";

	   printf "touch -t \"%s\" \"%s\" # %20s=>{%s}\n",
	     $ts_traditional,
	     $filename,
	     $plus{n} => $plus{v},
	     ;
	 }

       # <xmp:MetadataDate>2014-07-01T16:45:02+02:00</xmp:MetadataDate>
       # <xmp:CreateDate>2014-07-01T16:45:02+02:00</xmp:CreateDate>
       # <xmp:ModifyDate>2014-07-01T16:45:02+02:00</xmp:ModifyDate></rdf:Description>

       # <dc:date>2014-07-01T16:45:02+02:00</dc:date>

       if( m/ ^ \s* < (?<n> \w+ :\w* Date) > (?<v>.*) <\/ (?<n1> \w+ : \w* Date) > /ix )
	 {
           my(%plus) = %+;

           printf STDERR "# %d: %s=>{%s},%s=>{%s} // %s\n",__LINE__,
             "\$plus{n}" => $plus{n},
             "\$plus{v}" => $plus{v},
             "..."
             if $display_case_p;

	   $plus{YYYY} = substr($plus{v}, 0,4);
	   $plus{mm}   = substr($plus{v}, 5,2);
	   $plus{dd}   = substr($plus{v}, 8,2);
	   $plus{HH}   = substr($plus{v},11,2);
	   $plus{MM}   = substr($plus{v},14,2);
	   $plus{SS}   = substr($plus{v},17,2);

	   my($ts_traditional) = "$plus{YYYY}$plus{mm}$plus{dd}$plus{HH}$plus{MM}.$plus{SS}";

	   printf "touch -t \"%s\" \"%s\" # %20s=>{%s}\n",
	     $ts_traditional,
	     $filename,
	     $plus{n} => $plus{v},
	     ;
	 }

    ' \
    -- "-filename=${filename}"
done