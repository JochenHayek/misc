#! /usr/bin/perl -w

{
  my(@short_month_names) =
    ( 'Jan','Feb','Mar','Apr','May','Jun'
     ,'Jul','Aug','Sep','Oct','Nov','Dec'
     );
  unshift(@short_month_names,''); # in order to have an easier mapping `number : name`

  while(<>)
    {
      ## 2021-12-dd .. :

      # [2023-12-11, 11:50:00] Walter Homolka: ...

      if( m/ ^ \[ (?<YYYY>\d+) - (?<mm>\d+) - (?<dd>\d+) , \s+ (?<HH>\d+) : (?<MM>\d+) : (?<SS>\d+) \] \s* (?<author>[^:]*) : \s* (?<text>.*?) \s*$ /x )

	{ my(%plus) = %+;

	  printf "%02.2d %s %s\n\t%02.2d:%s:%s [_,%s] %s: %s <%s>; %s\n",

	    $plus{dd},
	    $short_month_names[ $plus{mm} ],

	    $plus{YYYY},

	    # https://de.wikipedia.org/wiki/2-mal-12-Stunden-Zählung
	    # https://en.wikipedia.org/wiki/12-hour_clock

	    $plus{HH},
	    $plus{MM},
	    $plus{SS},

	    'WhatsApp',

	    'From',
	    $plus{author},
	    '@WhatsApp',

	    $plus{text},
	    ;
	}

      # [2:05 pm, 08/10/2021] Jochen Hayek: ach... - danke!

      elsif( m/ ^ \[ (?<HH>\d+) : (?<MM>\d+) \s+ (?<ampm> am|pm ) , \s* (?<dd>\d+) \/ (?<mm>\d+) \/ (?<YYYY>\d+) \] \s* (?<author>[^:]*) : \s* (?<text>.*) /x )

	{ my(%plus) = %+;

	  printf "%02.2d %s %s\n\t%02.2d:%s [_,%s] %s: %s <%s>; %s\n",

	    $plus{dd},
	    $short_month_names[ $plus{mm} ],

	    $plus{YYYY},

	    # https://de.wikipedia.org/wiki/2-mal-12-Stunden-Zählung
	    # https://en.wikipedia.org/wiki/12-hour_clock
	    #
	    # actually 00:00 am is 12:00 and not 00:00, but I will only implement / fix this here "a little later".

	    ($plus{ampm} eq 'pm') ? ($plus{HH} + 12) : $plus{HH},
	    $plus{MM},
	    ##$plus{ampm},

	    'WhatsApp',

	    'From',
	    $plus{author},
	    '@WhatsApp',

	    $plus{text},
	    ;
	}

      # [15:25, 17/09/2021] Jochen Hayek: Hi, Gabriel,
      #         [    15      :    25      ,        17       /    09       /    2021       ]        Jochen Hayek  :        Hi

      elsif( m/ ^ \[ (?<HH>\d+) : (?<MM>\d+) , \s* (?<dd>\d+) \/ (?<mm>\d+) \/ (?<YYYY>\d+) \] \s* (?<author>[^:]*) : \s* (?<text>.*) /x )

      ## .. 2021-09-17 :

      # [20:06, 3/31/2020] Antje S.: ... Schokolade ...
      #         [    20      :    06      ,         3       /    31       /    2020       ]        Antje S.      :        ... Schokolade ...

    ##if( m/ ^ \[ (?<HH>\d+) : (?<MM>\d+) , \s* (?<mm>\d+) \/ (?<dd>\d+) \/ (?<YYYY>\d+) \] \s* (?<author>[^:]*) : \s* (?<text>.*) /x )

	{
	  my(%plus) = %+;

	  printf "%02.2d %s %s\n\t%02.2d:%s [_,%s] %s: %s <%s>; %s\n",

	    $plus{dd},
	    $short_month_names[ $plus{mm} ],

	    $plus{YYYY},

	    $plus{HH},
	    $plus{MM},

	    'WhatsApp',

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
