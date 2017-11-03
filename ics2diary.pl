#! /usr/bin/perl -w

# usage:
#
#   ics2diary.pl ics2diary.sample-BAHN_Fahrplan.ics > ics2diary.sample-BAHN_Fahrplan.diary

{
  my($table);

  while(<>)
    {
      chomp;

      # DTEND;TZID=Europe/Berlin:20171103T152600

      if(m/^ (?<name> DTSTART | DTEND ) ; TZID=([^:]*) : (?<timestamp> (?<YYYY>....)(?<mm>..)(?<dd>..)T(?<HH>..)(?<MM>..)(?<SS>..) ) $/x)
	{
	  my(%plus) = %+;

	  $table{ $+{name} } = \%plus;

	  printf "=%s,%03.3d,%03.3d: %s=>{%s} // %s\n",__FILE__,__LINE__,$.,
	    "\$table{ $plus{name} }{timestamp}" => $table{ $plus{name} }{timestamp},
	    '...';
	}
      elsif(m/^ (?<name> SUMMARY | DESCRIPTION ) : (?<value> .*) /x)
	{
	  my(%plus) = %+;

	  $table{ $+{name} } = \%plus;

	  printf "=%s,%03.3d,%03.3d: %s=>{%s} // %s\n",__FILE__,__LINE__,$.,
	    "\$table{ $plus{name} }{value}" => $table{ $plus{name} }{value},
	    '...';

	  if($plus{name} eq 'DESCRIPTION')
	    {
	      printf "%s %s %s\n",
		$table{DTSTART}{dd},
		$table{DTSTART}{mm},
		$table{DTSTART}{YYYY},
		;

	      printf "\t%s:%s:%s .. %s:%s:%s\n",
		$table{DTSTART}{HH},
		$table{DTSTART}{MM},
		$table{DTSTART}{SS},

		$table{DTEND}{HH},
		$table{DTEND}{MM},
		$table{DTEND}{SS},
		;

	      printf "\t\t%s=>{%s}\n",
		'SUMMARY' => $table{SUMMARY}{value},
		;

	      printf "\t\t%s=>{%s}\n",
		'DESCRIPTION' => $table{DESCRIPTION}{value},
		;
	    }
	}

    }
}
