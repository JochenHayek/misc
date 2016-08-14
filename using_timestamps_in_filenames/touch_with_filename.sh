:

bn0=$(basename "$0")

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

       # perl-5.10 was not able to parenthesize the all parts and use a named capture for it

       ts=$(echo ${i_bn} |
	    perl -ne '

              if(m/^ (?<YYYY>\d\d\d\d) (?<mm>\d\d) (?<dd>\d\d) (?<HH>..) (?<MM>..) (?<SS>..) -- (.*) $/x)
                {
                  my(%plus) = %+;
                  $plus{HH} = "00" if $plus{HH} =~ m/^(99|__)$/;
                  $plus{MM} = "00" if $plus{MM} =~ m/^(99|__)$/;
                  $plus{SS} = "00" if $plus{SS} =~ m/^(99|__)$/;
                  print "$plus{YYYY}-$plus{mm}-$plus{dd} $plus{HH}:$plus{MM}:$plus{SS}\n"
                }

            ')

       if test -n "${ts}"
       then 
	 touch "--date=${ts}" "${i}"
       else
	 echo 1>&2 "*** ${bn0},${LINENO}: \${i}=>{${i}},\${ts}=>{${ts}} // leading timestamp -- ???"
       fi
       ;;

     ################################################################################

     [0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9]--[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][_0-9][_0-9][_0-9][_0-9][_0-9][_0-9]--* )

       echo 1>&2 "*** ${bn0},${LINENO}: \${i}=>{${i}} // leading booking# + timestamp"

       # perl-5.10 was not able to parenthesize the all parts and use a named capture for it

       ts=$(echo ${i_bn} |
	    perl -ne '

              if(m/^ (?<book_no>\d{6}) - (?<sub_book_no>\d{3}) -- (?<YYYY>\d\d\d\d) (?<mm>\d\d) (?<dd>\d\d) (?<HH>..) (?<MM>..) (?<SS>..) -- (.*) $/x)
                {
                  my(%plus) = %+;
                  $plus{HH} = "00" if $plus{HH} =~ m/^(99|__)$/;
                  $plus{MM} = "00" if $plus{MM} =~ m/^(99|__)$/;
                  $plus{SS} = "00" if $plus{SS} =~ m/^(99|__)$/;
                  print "$plus{YYYY}-$plus{mm}-$plus{dd} $plus{HH}:$plus{MM}:$plus{SS}\n"
                }

            ')

       if test -n "${ts}"
       then 
	 touch "--date=${ts}" "${i}"
       else
	 echo 1>&2 "*** ${bn0},${LINENO}: \${i}=>{${i}},\${ts}=>{${ts}} // leading booking# + timestamp -- ???"
       fi
       ;;

     ################################################################################

     *.[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9] )

       echo 1>&2 "*** ${bn0},${LINENO}: \${i}=>{${i}} // trailing timestamp"

       # perl-5.10 was not able to parenthesize the all parts and use a named capture for it

       ts=$(echo ${i_bn} |
	    perl -ne '

              if(m/^ (.*) \. (?<YYYY>\d\d\d\d) (?<mm>\d\d) (?<dd>\d\d) (?<HH>..) (?<MM>..) (?<SS>..) $/x)
                {
                  my(%plus) = %+;
                  print "$plus{YYYY}-$plus{mm}-$plus{dd} $plus{HH}:$plus{MM}:$plus{SS}\n"
                }

            ')

       if test -n "${ts}"
       then 
	 touch "--date=${ts}" "${i}"
       else
	 echo 1>&2 "*** ${bn0},${LINENO}: \${i}=>{${i}},\${ts}=>{${ts}} // trailing timestamp -- ???"
       fi
       ;;

     ################################################################################

     *.[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9].??   | \
     *.[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9].???  | \
     *.[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9].???? )

       echo 1>&2 "*** ${bn0},${LINENO}: \${i}=>{${i}} // trailing timestamp + 2-/3-/4-letter extension"

       # perl-5.10 was not able to parenthesize all the parts and use a named capture for it

       ts=$(echo ${i_bn} |
	    perl -ne '

              if(m/^ (.*) \. (?<YYYY>\d\d\d\d) (?<mm>\d\d) (?<dd>\d\d) (?<HH>..) (?<MM>..) (?<SS>..) \. (?<extension>.{3,4}) $/x)
                {
                  my(%plus) = %+;
                  print "$plus{YYYY}-$plus{mm}-$plus{dd} $plus{HH}:$plus{MM}:$plus{SS}\n"
                }

            ')

       if test -n "${ts}"
       then 
	 touch "--date=${ts}" "${i}"
       else
	 echo 1>&2 "*** ${bn0},${LINENO}: \${i}=>{${i}},\${ts}=>{${ts}} // trailing timestamp + 2-/3-/4-letter extension -- ???"
       fi
       ;;

     ################################################################################

     *)
       echo 1>&2 "*** ${bn0},${LINENO}: \${i}=>{${i}} // ???"
       ;;

   esac

done
