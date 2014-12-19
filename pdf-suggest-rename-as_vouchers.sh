:

################################################################################

pdfinfo_version=$(pdfinfo -v 2>&1)

case "$pdfinfo_version" in
  'pdfinfo version 3.02'*)	# on a Synology Diskstation -- there it lives in the package "xpdf"
    pdfinfo_options='-meta'		# 
    ;;
  'pdfinfo version 0.24.3'*)	# on my other Linuxes etc. (wherever applicable)
    pdfinfo_options='-meta -rawdates'
  ##pdfinfo_options='-meta'		# 
    ;;
esac

##filename=Being_Geek.pdf

##for filename in "${@}"
for filename
do

  echo "*** ${filename}:"

##pdfinfo -meta -rawdates "${filename}" |
##pdfinfo -meta 	  "${filename}" |

  pdfinfo ${pdfinfo_options} "${filename}" |

##perl -MFile::Basename -s -ne ' ${basename} = basename(${filename},".pdf"); chomp; m/ ^ (?<n>.*Date): \s* D: (?<v>\d+) (-.*|Z)? $ /x && printf                "# %20s=>{%s} // %s\n"					 ,$+{n},$+{v},${filename};' -- -filename=${filename}

  perl -MFile::Basename \
    -s \
    -ne '

       %month_name2no = ('Jan'=> 1,'Feb'=> 2,'Mar'=> 3,'Apr'=> 4,'May'=> 5,'Jun'=> 6,'Jul'=> 7,'Aug'=> 8,'Sep'=> 9,'Oct'=>10,'Nov'=>11,'Dec'=>12);

       ${basename} = basename(${filename},".pdf");
       ${dirname}  = dirname(${filename});
       chomp;

       # "pdfinfo -meta" (w/o -rawdates) delivers this:
       #
       # CreationDate:   Thu Dec 18 09:10:04 2014

       m/ ^ (?<n>.*Date): \s+ (?<v> (?<weekday>\w+) \s+ (?<monthname>\w+) \s+ (?<day_of_month>\w+) \s+  (?<HH>\d\d) : (?<MM>\d\d) : (?<SS>\d\d) \s+ (?<YYYY>\w+) ) $ /x &&
       do {
        $YYYY = $+{YYYY};
        $mm   = $month_name2no{ $+{monthname} };
        $dd   = sprintf "%02.2d",$+{day_of_month};
        $HH   = $+{HH};
        $MM   = $+{MM};
        $SS   = $+{SS};
        1; } &&
       printf "mv %s %s/%s--%s--%s.%s # %20s=>{%s} // %s\n",
         ${filename},
         ${dirname},"999990-000",$YYYY.$mm.$dd.$HH.$MM.$SS,${basename},"pdf",
         $+{n},$+{v},
         ${filename},
         ;

       # "pdfinfo -meta -rawdates" delivers this:
       #
       # CreationDate:   D:20141218091004+01'00'

       m/ ^ (?<n>.*Date): \s* D: (?<v>\d+) (.*) $ /x &&
       printf "mv %s %s/%s--%s--%s.%s # %20s=>{%s} // %s\n",
         ${filename},
         ${dirname},"999990-000",$+{v},${basename},"pdf",
         $+{n},$+{v},
         ${filename},
         ;

       # <xmp:MetadataDate>2014-07-01T16:45:02+02:00</xmp:MetadataDate>
       # <xmp:CreateDate>2014-07-01T16:45:02+02:00</xmp:CreateDate>
       # <xmp:ModifyDate>2014-07-01T16:45:02+02:00</xmp:ModifyDate></rdf:Description>

       # <dc:date>2014-07-01T16:45:02+02:00</dc:date>

       m/ ^ < (?<n0> \w+ :\w* Date) > (?<v>.*) <\/ (?<n1> \w+ : \w* Date) > /ix &&
       do {
        $YYYY = substr($+{v}, 0,4);
        $mm   = substr($+{v}, 5,2);
        $dd   = substr($+{v}, 8,2);
        $HH   = substr($+{v},11,2);
        $MM   = substr($+{v},14,2);
        $SS   = substr($+{v},17,2);
        1; } &&
       printf "mv %s %s/%s--%s--%s.%s # %20s=>{%s} // %s\n",
         ${filename},
         ${dirname},"999990-000",$YYYY.$mm.$dd.$HH.$MM.$SS,${basename},"pdf",
         $+{n0},$+{v},
         ${filename},
         ;

    ' \
    -- -filename=${filename}
done
