:

# -> README--extracting_timestamps.txt

# misc/using_timestamps_in_filenames/pdf-suggest-*.sh
# misc/using_timestamps_in_filenames/pdf-suggest-rename-as_vouchers.sh
# misc/using_timestamps_in_filenames/pdf-suggest-rename-versioned.sh
# misc/using_timestamps_in_filenames/pdf-suggest-touch.sh

################################################################################

# $ env pdfinfo_options=' -rawdates'       ~/bin/pdf-suggest-___.sh *.pdf
# $ env pdfinfo_options=' -meta -rawdates' ~/bin/pdf-suggest-___.sh *.pdf
#
# for finding out, how to call pdfinfo:
#
# $ for i in *.pdf; do echo -e "\n*** $i;\n"; pdfinfo -rawdates $i; done

################################################################################

##pdfinfo 2>/dev/null
##if test $? -ne 127		# the shell cannot find the utility
##then             PDFINFO=pdfinfo
if false
then :
elif test -e  /usr/local/xpdf-tools/bin/pdfinfo
then  PDFINFO=/usr/local/xpdf-tools/bin/pdfinfo
elif test -e                /opt/sw/bin/pdfinfo
then                PDFINFO=/opt/sw/bin/pdfinfo
elif test -e                    /sw/bin/pdfinfo
then                    PDFINFO=/sw/bin/pdfinfo
elif test -e                   /opt/bin/pdfinfo
then                   PDFINFO=/opt/bin/pdfinfo
elif test -e                  $HOME/bin/pdfinfo
then                  PDFINFO=$HOME/bin/pdfinfo
else
  echo 1>&2 "*** $0: cannot find pdfinfo on the PATH or at ... or at /opt/sw/bin or /sw/bin or /opt/bin or $HOME/bin"
  exit 1
fi

case $("${PDFINFO}" -help 2>&1) in

  *http://poppler.freedesktop.org* )
  ##echo 1>&2 "*** $0: poppler"
  ##pdfinfo_options=' -meta -rawdates'
  ##pdfinfo_options=''
    ;;

  * )
  ##echo 1>&2 "*** $0: *"
  ##pdfinfo_options=' -meta -rawdates'
    pdfinfo_options=''
    ;;

esac

################################################################################

if test -z "${pdfinfo_options}"
then :

  ##pdfinfo_options=''

  "${PDFINFO}" -meta 1> /dev/null 2> /dev/null
  if test $? -eq 99		# if the option is available, 99 gets returned as exit code -- yes, 99 truely means, this option *is* available
  then :
    pdfinfo_options="${pdfinfo_options} -meta"
  fi

  "${PDFINFO}" -rawdates 1> /dev/null 2> /dev/null
  if test $? -eq 99		# if the option is available, 99 gets returned as exit code -- yes, 99 truely means, this option *is* available
  then :
    pdfinfo_options="${pdfinfo_options} -rawdates"
  fi
  #
  # CreationDate:   D:20121116141348+01'00'

  # this script does not yet deal with "-isodates"

  ##"${PDFINFO}" -isodates 1> /dev/null 2> /dev/null
  ##if test $? -eq 99		# if the option is available, 99 gets returned as exit code -- yes, 99 truely means, this option *is* available
  ##then :
  ##  pdfinfo_options="${pdfinfo_options} -isodates"
  ##fi
  #
  # CreationDate:   2012-11-16T14:13:48+01

fi

################################################################################

if test -n "$BASH_VERSINFO"
then shopt -s nullglob
fi

##for filename in "${@}"
for filename
do

  test -f "${filename}" || continue

  echo "*** ${filename}:"

##"${PDFINFO}" -meta -rawdates    "${filename}" |
##"${PDFINFO}" -meta 	          "${filename}" |
  "${PDFINFO}" ${pdfinfo_options} "${filename}" |

##tee bla |

  perl -MFile::Basename \
    -s \
    -ne '

       use warnings FATAL => "all";
       use strict;

       use v5.16; # if this requirement makes this script fail, get rid of the old perl (again!!!) in favour of a newer perl on your PATH!

       my($display_case_p) = 0;

       my(%month_name2no) = ("Jan"=>"01","Feb"=>"02","Mar"=>"03","Apr"=>"04","May"=>"05","Jun"=>"06","Jul"=>"07","Aug"=>"08","Sep"=>"09","Oct"=>"10","Nov"=>"11","Dec"=>"12");

       our($filename);

       my($basename) = basename($filename,".pdf");
       my($dirname)  = dirname($filename);
       chomp;

       # "pdfinfo -rawdates" delivers this:
       #
       # CreationDate:   2021-02-18T11:23:42+01:00

       if( m/ ^ (?<n>.*Date): \s+ (?<v> (?<YYYY>\w+) - (?<mm>\w+) - (?<dd>\w+) T  (?<HH>\d\d) : (?<MM>\d\d) : (?<SS>\d\d) (\+.*)? ) /x )
	 {
           my(%plus) = %+;

           printf STDERR "# %d: %s=>{%s},%s=>{%s} // %s\n",__LINE__,
             "\$plus{n}" => $plus{n},
             "\$plus{v}" => $plus{v},
             "..."
             if $display_case_p;

	   my($ts_YmdHMS)  = "$plus{YYYY}$plus{mm}$plus{dd}$plus{HH}$plus{MM}$plus{SS}";
	   my($ts_YmdHM_S) = "$plus{YYYY}$plus{mm}$plus{dd}$plus{HH}$plus{MM}.$plus{SS}";

	   func(
	       dirname    => $dirname , 
	       filename   => $filename ,
	       basename   => $basename ,
	       ts_YmdHMS  => $ts_YmdHMS ,
	       ts_YmdHM_S => $ts_YmdHM_S ,
	       n 	  => $plus{n} ,
	       v 	  => $plus{v} ,
	     );
	 }

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

	   my($ts_YmdHMS)  = "$plus{YYYY}$plus{mm}$plus{dd}$plus{HH}$plus{MM}$plus{SS}";
	   my($ts_YmdHM_S) = "$plus{YYYY}$plus{mm}$plus{dd}$plus{HH}$plus{MM}.$plus{SS}";

	   func(
	       dirname    => $dirname , 
	       filename   => $filename ,
	       basename   => $basename ,
	       ts_YmdHMS  => $ts_YmdHMS ,
	       ts_YmdHM_S => $ts_YmdHM_S ,
	       n 	  => $plus{n} ,
	       v 	  => $plus{v} ,
	     );
	 }

       # "pdfinfo" delivers this:
       #
       # CreationDate:   21/12/2004 16:24:57

       if( m/ ^ (?<n>.*Date): \s+ (?<v> (?<dd>\w+) \/ (?<mm>\w+) \/ (?<YYYY>\w+) \s+  (?<HH>\d\d) : (?<MM>\d\d) : (?<SS>\d\d) ) $ /x )
	 {
           my(%plus) = %+;

           printf STDERR "# %d: %s=>{%s},%s=>{%s} // %s\n",__LINE__,
             "\$plus{n}" => $plus{n},
             "\$plus{v}" => $plus{v},
             "..."
             if $display_case_p;

	   my($ts_YmdHMS)  = "$plus{YYYY}$plus{mm}$plus{dd}$plus{HH}$plus{MM}$plus{SS}";
	   my($ts_YmdHM_S) = "$plus{YYYY}$plus{mm}$plus{dd}$plus{HH}$plus{MM}.$plus{SS}";

	   func(
	       dirname    => $dirname , 
	       filename   => $filename ,
	       basename   => $basename ,
	       ts_YmdHMS  => $ts_YmdHMS ,
	       ts_YmdHM_S => $ts_YmdHM_S ,
	       n 	  => $plus{n} ,
	       v 	  => $plus{v} ,
	     );
	 }

       # "pdfinfo -meta" (w/o -rawdates) delivers this:
       #
       # CreationDate:   Thu Dec 18 09:10:04 2014
       # CreationDate:   Mon Jun  3 07:04:56 2019

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

	   my($ts_YmdHMS)  = "$plus{YYYY}$plus{mm}$plus{dd}$plus{HH}$plus{MM}$plus{SS}";
	   my($ts_YmdHM_S) = "$plus{YYYY}$plus{mm}$plus{dd}$plus{HH}$plus{MM}.$plus{SS}";

	   func(
	       dirname    => $dirname , 
	       filename   => $filename ,
	       basename   => $basename ,
	       ts_YmdHMS  => $ts_YmdHMS ,
	       ts_YmdHM_S => $ts_YmdHM_S ,
	       n 	  => $plus{n} ,
	       v 	  => $plus{v} ,
	     );
	 }

       # "pdfinfo -meta -rawdates" delivers this:
       #
       # CAVEAT: using single quote within a single-quoted shell string.
       #
       # CreationDate:   D:20141218091004+01'00'
       # CreationDate:     20190603070456+02'00'	# -rawdates w/o initial "D:"

     ##if( m/ ^ (?<n>.*Date): \s* (?<D> D: )? (?<v>                            \d{14}                 (.*) ) $ /x )
       if( m/ ^ (?<n>.*Date): \s* (?<D> D: )? (?<v_entire> (?<v> (?<v_less_SS> \d{12}) (?<SS> \d\d) ) (.*) ) $ /x )
	 {
           my(%plus) = %+;

           printf STDERR "# %d: %s=>{%s},%s=>{%s} // %s\n",__LINE__,
             "\$plus{n}" => $plus{n},
             "\$plus{v}" => $plus{v},
             "..."
             if $display_case_p;

	   my($ts_YmdHMS)  =  $plus{v};
	   my($ts_YmdHM_S) = "$plus{v_less_SS}.$plus{SS}";

	   func(
	       dirname    => $dirname , 
	       filename   => $filename ,
	       basename   => $basename ,
	       ts_YmdHMS  => $ts_YmdHMS ,
	       ts_YmdHM_S => $ts_YmdHM_S ,
	       n 	  => $plus{n} ,
	       v 	  => $plus{v} ,
	     );
	 }

       # <xmp:MetadataDate>2014-07-01T16:45:02+02:00</xmp:MetadataDate>
       # <xmp:CreateDate>2014-07-01T16:45:02+02:00</xmp:CreateDate>
       # <xmp:ModifyDate>2014-07-01T16:45:02+02:00</xmp:ModifyDate></rdf:Description>

       # <dc:date>2014-07-01T16:45:02+02:00</dc:date>

       # CAVEAT: occurences on the same line are not properly dealt with (we should deal with them in a loop instead of 3 one by one) , e.g.:
       #   <xmp:CreateDate>2021-02-18T11:23:42+01:00</xmp:CreateDate><xmp:ModifyDate>2021-02-18T11:23:42+01:00</xmp:ModifyDate>

       if(   m/ < (?<n>xmp:CreateDate) > (?<v>[^<]*) <\/ (?<n1> \w+ : \w* Date) > /ix 
	 )
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

	   my($ts_YmdHMS)  = "$plus{YYYY}$plus{mm}$plus{dd}$plus{HH}$plus{MM}$plus{SS}";
	   my($ts_YmdHM_S) = "$plus{YYYY}$plus{mm}$plus{dd}$plus{HH}$plus{MM}.$plus{SS}";

	   func(
	       dirname    => $dirname , 
	       filename   => $filename ,
	       basename   => $basename ,
	       ts_YmdHMS  => $ts_YmdHMS ,
	       ts_YmdHM_S => $ts_YmdHM_S ,
	       n 	  => $plus{n} ,
	       v 	  => $plus{v} ,
	     );
	 }
       if(   m/ < (?<n>xmp:ModifyDate) > (?<v>[^<]*) <\/ (?<n1> \w+ : \w* Date) > /ix 
	 )
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

	   my($ts_YmdHMS)  = "$plus{YYYY}$plus{mm}$plus{dd}$plus{HH}$plus{MM}$plus{SS}";
	   my($ts_YmdHM_S) = "$plus{YYYY}$plus{mm}$plus{dd}$plus{HH}$plus{MM}.$plus{SS}";

	   func(
	       dirname    => $dirname , 
	       filename   => $filename ,
	       basename   => $basename ,
	       ts_YmdHMS  => $ts_YmdHMS ,
	       ts_YmdHM_S => $ts_YmdHM_S ,
	       n 	  => $plus{n} ,
	       v 	  => $plus{v} ,
	     );
	 }
       if(   m/ < (?<n> \w+ :\w* Date) > (?<v>[^<]*) <\/ (?<n1> \w+ : \w* Date) > /ix 

          && ($+{n} ne "xmp:CreateDate")
          && ($+{n} ne "xmp:ModifyDate")

          && ($+{n} ne "pfDocArc:ARCHIVE_DATE")		# <pfDocArc:ARCHIVE_DATE>20200217</pfDocArc:ARCHIVE_DATE>
          && ($+{n} ne "pfDocArc:ARCHIVE_DEL_DATE")	# <pfDocArc:ARCHIVE_DEL_DATE>20350213</pfDocArc:ARCHIVE_DEL_DATE>
	 )
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

	   my($ts_YmdHMS)  = "$plus{YYYY}$plus{mm}$plus{dd}$plus{HH}$plus{MM}$plus{SS}";
	   my($ts_YmdHM_S) = "$plus{YYYY}$plus{mm}$plus{dd}$plus{HH}$plus{MM}.$plus{SS}";

	   func(
	       dirname    => $dirname , 
	       filename   => $filename ,
	       basename   => $basename ,
	       ts_YmdHMS  => $ts_YmdHMS ,
	       ts_YmdHM_S => $ts_YmdHM_S ,
	       n 	  => $plus{n} ,
	       v 	  => $plus{v} ,
	     );
	 }

       # xmp:MetadataDate="2014-07-01T16:45:02+02:00"
       #   xmp:CreateDate="2014-07-01T16:45:02+02:00"
       #   xmp:ModifyDate="2014-07-01T16:45:02+02:00"

       #   xmp:CreateDate="2018-01-02T12:26:41Z"

       if( m/ \s+ (?<n> \w+ :\w* Date) =" (?<v>.*?) " /ix )
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

	   my($ts_YmdHMS)  = "$plus{YYYY}$plus{mm}$plus{dd}$plus{HH}$plus{MM}$plus{SS}";
	   my($ts_YmdHM_S) = "$plus{YYYY}$plus{mm}$plus{dd}$plus{HH}$plus{MM}.$plus{SS}";

	   func(
	       dirname    => $dirname , 
	       filename   => $filename ,
	       basename   => $basename ,
	       ts_YmdHMS  => $ts_YmdHMS ,
	       ts_YmdHM_S => $ts_YmdHM_S ,
	       n 	  => $plus{n} ,
	       v 	  => $plus{v} ,
	     );
	 }

     ##sub create_command_line_rename_as_vouchers
       sub func
       {
	 my($package,$filename,$line,$proc_name) = caller(0);

	 my(%param) = @_;

	 my($return_value) = 0;

	 # ----------

	 printf "mv \"%s\" \"%s/%s--%s--%s.%s\" # %20s=>{%s} // %s\n",
	   $param{filename},
	   $param{dirname} , "999990-000" , $param{ts_YmdHMS} , $param{basename} , "pdf" ,
	   $param{n} => $param{v},
	   $param{filename},
	   ;

	 # ----------

	 return $return_value;
       }

       sub create_command_line_rename_versioned
     ##sub func
       {
	 my($package,$filename,$line,$proc_name) = caller(0);

	 my(%param) = @_;

	 my($return_value) = 0;

	 # ----------

	 printf "mv \"%s\" \"%s/%s.%s.%s\" # %20s=>{%s} // %s\n",
	   $param{filename},
	   $param{dirname} , $param{basename} , $param{ts_YmdHMS} , "pdf" ,
	   $param{n} => $param{v},
	   $param{filename},
	   ;

	 # ----------

	 return $return_value;
       }

       sub create_command_line_touch
     ##sub func
       {
	 my($package,$filename,$line,$proc_name) = caller(0);

	 my(%param) = @_;

	 my($return_value) = 0;

	 # ----------

	 printf "touch -t \"%s\" \"%s\" # %20s=>{%s}\n",
	   $param{ts_YmdHM_S} ,
	   $param{filename} ,
	   $param{n} => $param{v},
	   ;

	 # ----------

	 return $return_value;
       }

    ' \
    -- "-filename=${filename}" |

    sort

done
