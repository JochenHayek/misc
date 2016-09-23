:

bn0=$(basename "$0")

# M-x setenv
#   PATH
#   …

for i
do :
   false && echo 1>&2 "*** ${bn0},${LINENO}: \${i}=>{${i}}"

   # if it's not just a local filename,
   # but one with a leading directory name,
   # we want to strip the leading directory name and proceed with just the basename:

   i_bn=$( basename "${i}" )

   case "${i_bn}" in

     ################################################################################

     *--travel_date-[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]* )

       echo 1>&2 "*** ${bn0},${LINENO}: \${i}=>{${i}} // matching travel_date-..."

       ts=$(echo ${i_bn} |
	    perl -ne '

              if(m/^ .*--travel_date- (?<YYYY>\d\d\d\d) (?<mm>\d\d) (?<dd>\d\d) (.*) $/x)
                {
                  my(%plus) = %+;
                  $plus{HH} = "00";
                  $plus{MM} = "00";
                  $plus{SS} = "00";
                  print "$plus{YYYY}-$plus{mm}-$plus{dd} $plus{HH}:$plus{MM}:$plus{SS}\n"
                }

            ')

       if test -n "${ts}"
       then 
       ##echo 1>&2 "*** ${bn0},${LINENO}: \${i}=>{${i}},\${ts}=>{${ts}} // matching travel_date-..."
	 touch "--date=${ts}" "${i}"
       else
	 echo 1>&2 "*** ${bn0},${LINENO}: \${i}=>{${i}},\${ts}=>{${ts}} // matching travel_date-..."
       fi
       ;;

     ################################################################################

     *)
       echo 1>&2 "*** ${bn0},${LINENO}: \${i}=>{${i}} // ???"
       ;;

   esac

done
