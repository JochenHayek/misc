#!/usr/bin/perl

# $Id: JHgen_diary_frame.pl 1.17 2008/05/13 10:45:06 johayek Exp $
# $Source: /Users/johayek/git-servers/github.com/JochenHayek/misc/diary/RCS/JHgen_diary_frame.pl $

# Q: until what year do we run here?
# A: search for "last year"!

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

  # I could generate a correct 1999 calendar using $cal_week this way,
  # but I'm still not sure, whether the overall usage of $cal_week is correct this way;
  my($cal_week);

  for ( $i=0
      , $cal_week=1
      , $old_year=-1
      ; ## $i < 978393600
      ; $i += 24*60*60
      )
    {
      ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = gmtime($i);

      printf STDERR "=%d: %04.4d-%02.2d-%02.2d: %s=>%02.2d,%s=>%d\n",__LINE__
	, 1900 + $year
	, 1 + $mon
	, $mday
	,'$cal_week',$cal_week
	,'$i',$i
	if $debug;

      ##last if($i >= 978393600);

      my($date__YYYY_MM_DD) =
	sprintf "%04.4d-%02.2d-%02.2d"
	  , (1900 + $year)
	  , ($mon + 1)
	  , $mday
	  ;

      last if($date__YYYY_MM_DD gt '2009-99-99'); # "last year"

      print
      ##$i,' ',
        $date__YYYY_MM_DD,' '
	if 0;

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
      else
	{
	  if (($mon==0) && ($mday==1))
	    {
	      $cal_week = 1;
	      $old_year = $year;
	      printf "%02.2d %s %d %s"
		, $mday
		, $month_names[$mon]
		, 1900 + $year
		, $week_day_names[$wday]
		;
	      printf " (week# %02.2d) // correct previous week no.!!!"
		, $cal_week
		;
	      print "\n";
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
}
