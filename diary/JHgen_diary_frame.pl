#!/usr/bin/perl

# $Id: JHgen_diary_frame.pl 1.2 1994/07/27 07:35:43 jh Exp $
# $Source: /Users/johayek/git-servers/github.com/JochenHayek/misc/diary/RCS/JHgen_diary_frame.pl $

$debug = 0;

for ($i=0,$cal_week=0,$old_year=-1; $i < 946857600 ; $i += 24*60*60 )
{
  ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = gmtime($i);

  if ($wday == 1)
    {
      if ($old_year eq $year)
	{
	  $cal_week++;
	}
      else
	{
	  $cal_week = 1;
	  $old_year = $year;
	}

      printf STDERR "=%d: %04.4d-%02.2d-%02.2d: %s=>%02.2d,%s=>%d\n",__LINE__
	, 1900 + $year
	  , 1 + $mon
	    , $mday
	      ,'$cal_week',$cal_week
		,'$i',$i
		if $debug;
      printf "%02.2d %s %d KW%02.2d\n"
	, $mday
	, ('Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec')[$mon]
	, 1900 + $year
	,$cal_week
	unless $debug;
    }
}
