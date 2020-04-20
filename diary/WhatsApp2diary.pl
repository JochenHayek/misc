#! /usr/bin/perl -w

{
  my(@short_month_names) =
    ( 'Jan','Feb','Mar','Apr','May','Jun'
     ,'Jul','Aug','Sep','Oct','Nov','Dec'
     );
  unshift(@short_month_names,''); # in order to have an easier mapping `number : name`

  while(<>)
    {
      # [20:06, 3/31/2020] Antje S.: ... Schokolade ...
      #         [    20      :    06      ,         3       /    31       /    2020       ]        Antje S.      :        ... Schokolade ...

      if( m/ ^ \[ (?<HH>\d+) : (?<MM>\d+) , \s* (?<mm>\d+) \/ (?<dd>\d+) \/ (?<YYYY>\d+) \] \s* (?<author>[^:]*) : \s* (?<text>.*) /x )
	{
	  my(%plus) = %+;

	  printf "%s %s %s\n\t%s:%s %s (%s): %s\n",
	    $plus{dd},
	    $short_month_names[ $plus{mm} ],
	    $plus{YYYY},
	    $plus{HH},
	    $plus{MM},
	    $plus{author},
	    '(via WhatsApp)',
	    $plus{text},
	    ;
	}
      elsif (m/^ \s* $/x)
	{
	  print "\n";
	}
      else
	{
	  printf "\t\t%s",$_;
	}
    }
}
