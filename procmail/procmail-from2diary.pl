#! /usr/bin/perl -w

# read a procmail log file -> LOGFILE
# create diary entries

{
  my(%from_captures,%subject_captures,%folder_captures);

  while(<>)
    {
      if(m/^From \s+ (?<from>\S+) \s+ (?<wday>\w+) \s+ (?<month>\w+) \s+ (?<mday>\w+) \s+ (?<time>[\d:]+) \s+ (?<year>\d+)$/x)
	{
	  printf STDERR "=%03.3d,%05.5d: {%s}=>{%s},{%s}=>{%s},{%s}=>{%s},{%s}=>{%s},{%s}=>{%s},{%s}=>{%s} // %s\n",__LINE__,$.
	    ,'$+{from}',$+{from}
	    ,'$+{wday}',$+{wday}
	    ,'$+{month}',$+{month}
	    ,'$+{mday}',$+{mday}
	    ,'$+{time}',$+{time}
	    ,'$+{year}',$+{year}
	    ,'...' if 0;

	  %from_captures = %+;
	}
      elsif(m/^ \s+ Subject: \s+ (?<subject>.*) $/x)
	{
	  printf STDERR "=%03.3d,%05.5d: {%s}=>{%s},{%s}=>{%s} // %s\n",__LINE__,$.
	    ,'$+{subject}',$+{subject}
	    ,'$from_captures{from}',$from_captures{from}
	    ,'...' if 0;

	  %subject_captures = %+;

	  printf "%s %s %s\n\t%s %s: %s; %s: %s\n"
	    ,$from_captures{mday}
	    ,$from_captures{month}
	    ,$from_captures{year}
	    ,$from_captures{time}
	    ,'From',$from_captures{from}
	    ,'Subject',$subject_captures{subject}
	    if 0;
	}
      elsif(m/^ \s+ Folder: \s+ (?<folder>\S+) \s+ (?<size>\d+) $/x)
	{
	  printf STDERR "=%03.3d,%05.5d: {%s}=>{%s},{%s}=>{%s} // %s\n",__LINE__,$.
	    ,'$+{folder}',$+{folder}
	    ,'$+{size}',$+{size}
	    ,'...' if 0;

	  %folder_captures = %+;

	  if(exists($from_captures{from}))
	    {
	      printf "%s %s %s\n\t%s %s: %s; %s: %s; %s: %s\n"
		,$from_captures{mday}
		,$from_captures{month}
		,$from_captures{year}
		,$from_captures{time}
		,'From',$from_captures{from}
		,'Subject',$subject_captures{subject}
		,'Folder',$folder_captures{folder}
		;
	    }
	}
    }
}
