#! /usr/bin/perl -w

{
  my(@short_month_names) =
    ( 'Jan','Feb','Mar','Apr','May','Jun'
     ,'Jul','Aug','Sep','Oct','Nov','Dec'
     );
  unshift(@short_month_names,''); # in order to have an easier mapping `number : name`

  while(<>)
    {
      ## 2021-09-17 .. :

      # [2:05 pm, 08/10/2021] Jochen Hayek: ach... - danke!

      # …

      # [15:25, 17/09/2021] Jochen Hayek: Hi, Gabriel,
      #         [    15      :    25      ,        17       /    09       /    2021       ]        Jochen Hayek  :        Hi

      if( m/ ^ \[ (?<HH>\d+) : (?<MM>\d+) , \s* (?<dd>\d+) \/ (?<mm>\d+) \/ (?<YYYY>\d+) \] \s* (?<author>[^:]*) : \s* (?<text>.*) /x )

      ## .. 2021-09-17 :

      # [20:06, 3/31/2020] Antje S.: ... Schokolade ...
      #         [    20      :    06      ,         3       /    31       /    2020       ]        Antje S.      :        ... Schokolade ...

    ##if( m/ ^ \[ (?<HH>\d+) : (?<MM>\d+) , \s* (?<mm>\d+) \/ (?<dd>\d+) \/ (?<YYYY>\d+) \] \s* (?<author>[^:]*) : \s* (?<text>.*) /x )

	{
	  my(%plus) = %+;

	  printf "%02.2d %s %s\n\t%s:%s %s: %s <%s>; %s\n",

	    $plus{dd},
	    $short_month_names[ $plus{mm} ],

	    $plus{YYYY},
	    $plus{HH},
	    $plus{MM},

	    'From',
	    $plus{author},
	    '@WhatsApp',

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
