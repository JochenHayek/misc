:

for i in *.pdf
do :
   echo 1>&2 "*** \$i=>{$i}"
   bn=$( basename "$i" .pdf )

   ../pdftohtml_tritom2diary.pl "${bn}.pdftohtml.xml" > "${bn}.diary"

   if diff --brief "${bn}.diary.REF" "${bn}.diary"
   then rm --verbose "${bn}.diary"
   fi
done
