#!/usr/bin/perl

# $Id: JHgen_diary_frame.pl 1.8 1999/06/03 09:59:34 johayek Exp $
# $Source: /Users/johayek/git-servers/github.com/JochenHayek/misc/diary/RCS/JHgen_diary_frame.pl $

{
  $debug = 0;
  @month_names = ('Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec');
  @week_day_names =
    ( '   Sunday'
     ,'   Monday'
     ,'  Tuesday'
     ,'Wednesday'
     ,' Thursday'
     ,'   Friday'
     ,' Saturday'
     );

  for ($i=0,$cal_week=1,$old_year=-1; $i < 946857600 ; $i += 24*60*60 )
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
	      $cal_week++;	# this is actually wrong for the last week of the year ... (really???)
	    }
	  else
	    {
	      $cal_week = 1;
	      $old_year = $year;
	    }
	  if($debug)
	    {}
	  else
	    {
	      printf "%02.2d %s %d %s"
		, $mday
		, $month_names[$mon]
		, 1900 + $year
		, $week_day_names[$wday]
		;
	      printf " (week# %02.2d)"
		, $cal_week
		;
	      print "\n";
	    }
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
