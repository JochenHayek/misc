#!/usr/bin/perl

# $Id: JHgen_diary_frame.pl 1.4 1995/11/16 16:32:12 jh Exp $
# $Source: /Users/johayek/git-servers/github.com/JochenHayek/misc/diary/RCS/JHgen_diary_frame.pl $

{
  $debug = 0;
  @month_names = ('Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec');
  @week_day_names = ('Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday');

  for ($i=0,$cal_week=0,$old_year=-1; $i < 946857600 ; $i += 24*60*60 )
    {
      ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = gmtime($i);

      printf STDERR "=%d: %04.4d-%02.2d-%02.2d: %s=>%02.2d,%s=>%d\n",__LINE__
	, 1900 + $year
	, 1 + $mon
	, $mday
	,'$cal_week',$cal_week
	,'$i',$i
	if $debug;

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
	  printf "\f\n%02.2d %s %d %s\n"
	    , $mday
	    , $month_names[$mon]
	    , 1900 + $year
	    , $week_day_names[$wday]
	    unless $debug;
	  printf "\t00:00 [biz] week# %02.2d\n"
	    , $cal_week
	    unless $debug;
	}
      elsif ($wday == 4)
	{
	  printf "%02.2d %s %d %s\n"
	    , $mday
	    , $month_names[$mon]
	    , 1900 + $year
	    , $week_day_names[$wday]
	    unless $debug;
	}
      else
	{
	  printf "%02.2d %s %d %s\n"
	    , $mday
	    , $month_names[$mon]
	    , 1900 + $year
	    , $week_day_names[$wday]
	    unless $debug;
	}
    }
}
