:

for i in *--*.eml
do
  echo "*** $i:"
  ~/Computers/Programming/Languages/Perl/message-rewrite-return-path.pl "${i}" | cat -nev | head -3
done
