:

# misc/using_timestamps_in_filenames/touch_with_filename.sh

################################################################################

##PERL='c:/Program Files/Git/usr/bin/perl.exe'
  PERL=perl

################################################################################

bn0=$(basename "$0")

# on OS X 
# emacs does not get called with the environment set up by ~/.profile,
# so for some partial similarity at least:
#
# M-x setenv
#   PATH
#   ...

use_traditional_time_string_p=false
use_traditional_time_string_p=true

for i
do :
   false && echo 1>&2 "*** ${bn0},${LINENO}: \${i}=>{${i}}"

   # if it's not just a local filename,
   # but one with a leading directory name,
   # we want to strip the leading directory name and proceed with just the basename:

   i_bn=$( basename "${i}" )

   case "${i_bn}" in

     ################################################################################

     [0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][_0-9][_0-9][_0-9][_0-9][_0-9][_0-9]--* )

       echo 1>&2 "*** ${bn0},${LINENO}: \${i}=>{${i}} // leading timestamp"

       ts_modern=$(echo ${i_bn} |
	    "${PERL}" -ne '

              if(m/^ (?<YYYY>\d\d\d\d) (?<mm>\d\d) (?<dd>\d\d) (?<HH>..) (?<MM>..) (?<SS>..) -- (.*) $/x)
                {
                  my(%plus) = %+;
                  $plus{HH} = "00" if $plus{HH} =~ m/^(99|__)$/;
                  $plus{MM} = "00" if $plus{MM} =~ m/^(99|__)$/;
                  $plus{SS} = "00" if $plus{SS} =~ m/^(99|__)$/;
                  print "$plus{YYYY}-$plus{mm}-$plus{dd} $plus{HH}:$plus{MM}:$plus{SS}\n"
                }

            ')

       ts_traditional=$(echo ${i_bn} |
	    "${PERL}" -ne '

              if(m/^ (?<YYYY>\d\d\d\d) (?<mm>\d\d) (?<dd>\d\d) (?<HH>..) (?<MM>..) (?<SS>..) -- (.*) $/x)
                {
                  my(%plus) = %+;
                  $plus{HH} = "00" if $plus{HH} =~ m/^(99|__)$/;
                  $plus{MM} = "00" if $plus{MM} =~ m/^(99|__)$/;
                  $plus{SS} = "00" if $plus{SS} =~ m/^(99|__)$/;
                  print "$plus{YYYY}$plus{mm}$plus{dd}$plus{HH}$plus{MM}.$plus{SS}\n"
                }

            ')

       if test -z "${ts_modern}"

       then echo 1>&2 "*** ${bn0},${LINENO}: \${i}=>{${i}},\${ts_modern}=>{${ts_modern}} // leading timestamp -- ???"

       elif test "${use_traditional_time_string_p}" = true

       then touch -t "${ts_traditional}" "${i}"

       else touch "--date=${ts_modern}"  "${i}"

       fi
       ;;

     ################################################################################

     [0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9]--[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][_0-9][_0-9][_0-9][_0-9][_0-9][_0-9]--* )

       echo 1>&2 "*** ${bn0},${LINENO}: \${i}=>{${i}} // leading booking# + timestamp"

       ts_modern=$(echo ${i_bn} |
	    "${PERL}" -ne '

              if(m/^ (?<book_no>\d{6}) - (?<sub_book_no>\d{3}) -- (?<YYYY>\d\d\d\d) (?<mm>\d\d) (?<dd>\d\d) (?<HH>..) (?<MM>..) (?<SS>..) -- (.*) $/x)
                {
                  my(%plus) = %+;
                  $plus{HH} = "00" if $plus{HH} =~ m/^(99|__)$/;
                  $plus{MM} = "00" if $plus{MM} =~ m/^(99|__)$/;
                  $plus{SS} = "00" if $plus{SS} =~ m/^(99|__)$/;
                  print "$plus{YYYY}-$plus{mm}-$plus{dd} $plus{HH}:$plus{MM}:$plus{SS}\n"
                }

            ')

       ts_traditional=$(echo ${i_bn} |
	    "${PERL}" -ne '

              if(m/^ (?<book_no>\d{6}) - (?<sub_book_no>\d{3}) -- (?<YYYY>\d\d\d\d) (?<mm>\d\d) (?<dd>\d\d) (?<HH>..) (?<MM>..) (?<SS>..) -- (.*) $/x)
                {
                  my(%plus) = %+;
                  $plus{HH} = "00" if $plus{HH} =~ m/^(99|__)$/;
                  $plus{MM} = "00" if $plus{MM} =~ m/^(99|__)$/;
                  $plus{SS} = "00" if $plus{SS} =~ m/^(99|__)$/;
                  print "$plus{YYYY}$plus{mm}$plus{dd}$plus{HH}$plus{MM}.$plus{SS}\n"
                }

            ')

       if test -z "${ts_modern}"

       then echo 1>&2 "*** ${bn0},${LINENO}: \${i}=>{${i}},\${ts_modern}=>{${ts_modern}} // leading booking# + timestamp -- ???"

       elif test "${use_traditional_time_string_p}" = true

       then touch -t "${ts_traditional}" "${i}"

       else touch "--date=${ts_modern}" "${i}"
       fi
       ;;

     ################################################################################

     *.[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9] )

       echo 1>&2 "*** ${bn0},${LINENO}: \${i}=>{${i}} // trailing timestamp"

       ts_modern=$(echo ${i_bn} |
	    "${PERL}" -ne '

              if(m/^ (.*) \. (?<YYYY>\d\d\d\d) (?<mm>\d\d) (?<dd>\d\d) (?<HH>..) (?<MM>..) (?<SS>..) $/x)
                {
                  my(%plus) = %+;
                  print "$plus{YYYY}-$plus{mm}-$plus{dd} $plus{HH}:$plus{MM}:$plus{SS}\n"
                }

            ')

       ts_traditional=$(echo ${i_bn} |
	    "${PERL}" -ne '

              if(m/^ (.*) \. (?<YYYY>\d\d\d\d) (?<mm>\d\d) (?<dd>\d\d) (?<HH>..) (?<MM>..) (?<SS>..) $/x)
                {
                  my(%plus) = %+;
                  print "$plus{YYYY}$plus{mm}$plus{dd}$plus{HH}$plus{MM}.$plus{SS}\n"
                }

            ')

       if test -z "${ts_modern}"

       then echo 1>&2 "*** ${bn0},${LINENO}: \${i}=>{${i}},\${ts_modern}=>{${ts_modern}} // trailing timestamp -- ???"

       elif test "${use_traditional_time_string_p}" = true

       then touch -t "${ts_traditional}" "${i}"

       else touch "--date=${ts_modern}" "${i}"

       fi
       ;;

     ################################################################################

     *.[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9].* )

       echo 1>&2 "*** ${bn0},${LINENO}: \${i}=>{${i}} // trailing timestamp + multi-letter single-word extension"

       ts_modern=$(echo ${i_bn} |
	    "${PERL}" -ne '

              if(m/^ (.*) \. (?<YYYY>\d\d\d\d) (?<mm>\d\d) (?<dd>\d\d) (?<HH>..) (?<MM>..) (?<SS>..) \. (?<extension>\w+) $/x)
                {
                  my(%plus) = %+;
                  print "$plus{YYYY}-$plus{mm}-$plus{dd} $plus{HH}:$plus{MM}:$plus{SS}\n"
                }

            ')

       ts_traditional=$(echo ${i_bn} |
	    "${PERL}" -ne '

              if(m/^ (.*) \. (?<YYYY>\d\d\d\d) (?<mm>\d\d) (?<dd>\d\d) (?<HH>..) (?<MM>..) (?<SS>..) \. (?<extension>\w+) $/x)
                {
                  my(%plus) = %+;
                  print "$plus{YYYY}$plus{mm}$plus{dd}$plus{HH}$plus{MM}.$plus{SS}\n"
                }

            ')

       if test -z "${ts_modern}"

       then echo 1>&2 "*** ${bn0},${LINENO}: \${i}=>{${i}},\${ts_modern}=>{${ts_modern}} // trailing timestamp + multi-letter single-word extension -- ???"

       elif test "${use_traditional_time_string_p}" = true

       then touch -t "${ts_traditional}" "${i}"

       else touch "--date=${ts_modern}" "${i}"

       fi
       ;;

     ################################################################################

     [0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9].* )

       echo 1>&2 "*** ${bn0},${LINENO}: \${i}=>{${i}} // timestamp + multi-letter single-word extension"

       ts_modern=$(echo ${i_bn} |
	    "${PERL}" -ne '

              if(m/^ (?<YYYY>\d\d\d\d) (?<mm>\d\d) (?<dd>\d\d) (?<HH>..) (?<MM>..) (?<SS>..) \. (?<extension>\w+) $/x)
                {
                  my(%plus) = %+;
                  print "$plus{YYYY}-$plus{mm}-$plus{dd} $plus{HH}:$plus{MM}:$plus{SS}\n"
                }

            ')

       ts_traditional=$(echo ${i_bn} |
	    "${PERL}" -ne '

              if(m/^ (?<YYYY>\d\d\d\d) (?<mm>\d\d) (?<dd>\d\d) (?<HH>..) (?<MM>..) (?<SS>..) \. (?<extension>\w+) $/x)
                {
                  my(%plus) = %+;
                  print "$plus{YYYY}$plus{mm}$plus{dd}$plus{HH}$plus{MM}.$plus{SS}\n"
                }

            ')

       if test -z "${ts_modern}"

       then echo 1>&2 "*** ${bn0},${LINENO}: \${i}=>{${i}},\${ts_modern}=>{${ts_modern}} // trailing timestamp + multi-letter single-word extension -- ???"

       elif test "${use_traditional_time_string_p}" = true

       then touch -t "${ts_traditional}" "${i}"

       else touch "--date=${ts_modern}" "${i}"

       fi
       ;;

     ################################################################################

     *)
       echo 1>&2 "*** ${bn0},${LINENO}: \${i}=>{${i}} // ???"
       ;;

   esac

done
