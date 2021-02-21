#! /usr/bin/perl -w

{
  my(%line_1of3);
  my($text);

  while(<>)
    {
      # Sophia, [17 Mar 2021 at 00:04:08]:
      # aaa
      # (emtpy)

      if( m/ ^ (?<author>[^,]*) , \s* \[ (?<dd>\d+) \s+ (?<mon>\w+) \s+ (?<YYYY>\d+) \s+ at \s+ (?<HH>\d+) : (?<MM>\d+) : (?<SS>\d+) \]: $ /x )
	{
	  my(%new_date_line) = %+;

	  if(defined($text))
	    {
	      $text =~ s/\s*$//;
	    }
	  else
	    {
	      $text = '';
	    }

	  printf "%02.2d %s %s\n\t%s:%s:%s %s: %s <%s>; %s\n",

	    $date_line{dd},
	    $date_line{mon},
	    $date_line{YYYY},
	    $date_line{HH},
	    $date_line{MM},
	    $date_line{SS},

	    'From',
	    $date_line{author},
	    '@telegram',
	    $text,

	    if exists($date_line{dd});

	  %date_line = %new_date_line;
	  $text = '';
	}
      else
	{
	  if($text eq '')
	    {
	      $text = $_;
	    }
	  else
	    {
	      $text .= "\t\t" . $_;
	    }
	}
    }
}
