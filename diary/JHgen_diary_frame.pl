#!/usr/bin/perl

# $Id: JHgen_diary_frame.pl 1.1 1994/07/27 07:01:56 jh Exp $
# $Source: /Users/johayek/git-servers/github.com/JochenHayek/misc/diary/RCS/JHgen_diary_frame.pl $

for ($i=0; ; $i += 24*60*60 )
{
  ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = $i;
  printf STDERR "=%d: %04.4d-%02.2d-%02.2d\n",__LINE__
    ,$year
    ,$mon
    ,$wday
    ;
}
