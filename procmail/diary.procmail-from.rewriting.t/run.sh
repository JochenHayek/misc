:

for i in [0-9]*.txt
do :
  echo
  echo "*** $i:"
  echo
  ../diary.procmail-from.rewriting.pl "$i"
done
