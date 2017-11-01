head	1.1;
access;
symbols;
locks
	johayek:1.1; strict;
comment	@# @;


1.1
date	2016.06.06.14.08.59;	author johayek;	state Exp;
branches;
next	;


desc
@@


1.1
log
@Initial revision
@
text
@:

for i in *--*.eml
do
  echo "*** $i:"
  ~/Computers/Programming/Languages/Perl/message-rewrite-return-path.pl "${i}" | cat -nev | head -3
done
@
