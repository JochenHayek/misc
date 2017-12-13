#! /usr/bin/perl -w

# usage:
#
#   ics2diary.pl ics2diary.sample-BAHN_Fahrplan.ics > ics2diary.sample-BAHN_Fahrplan.diary
#
# to be called within emacs dired-mode like this
#
#   ~/git-servers/github.com/JochenHayek/misc/ics2diary.pl ? > $(echo ? ).diary

{
  my(%table);

  while(<>)
    {
      chomp;

      # DTEND;TZID=Europe/Berlin:20171103T152600

      if(0)
	{
	}
      elsif(m/^ (?<name> BEGIN | END ) : VEVENT $/x)
	{
	  my(%plus) = %+;

	##$table{ $+{name} } = \%plus;

	  if   ($plus{name} eq 'BEGIN')
	    {
	      %table = ();
	    }
	  elsif($plus{name} eq 'END')
	    {
	      printf "%s %s %s\n",
		$table{DTSTART}{dd},
		$table{DTSTART}{mm},
		$table{DTSTART}{YYYY},
		;

	      printf "\t%s:%s:%s .. %s:%s:%s",
		$table{DTSTART}{HH},
		$table{DTSTART}{MM},
		$table{DTSTART}{SS},

		$table{DTEND}{HH},
		$table{DTEND}{MM},
		$table{DTEND}{SS},
		;

	      printf " %s=>{%s}\n",
		'SUMMARY' => $table{SUMMARY}{value},
		if exists($table{SUMMARY});

	      printf "\n";

	      printf "\t\t%s=>{%s}\n",
		'DESCRIPTION' => $table{DESCRIPTION}{value},
		if 0 && exists($table{DESCRIPTION});

	      if(exists($table{DESCRIPTION}))
		{
		  printf "\t\t%s=>{\n\n",
		    'DESCRIPTION';

		  my(@DESCRIPTION) = split(/\\n/,$table{DESCRIPTION}{value});

		  printf "=%s,%03.3d,%03.3d: %s=>{%s} // %s\n",__FILE__,__LINE__,$.,
		    '$#DESCRIPTION' => $#DESCRIPTION,
		    '...'
		    if 0;

		  foreach my $d (@DESCRIPTION)
		    {
		      printf "\t\t\t{%s}\n",$d;
		    }

		  printf "\n\t\t}\n\n",
		    ;

		  my(%current_slot);

		  foreach my $d (@DESCRIPTION)
		    {
		      printf "\t\t\t{%s}\n",$d
			if 0;

		      if($d =~ m/^ (?<name> ab | an ) \s+ (?<HH_MM>\d\d:\d\d) \s+ (?<value>.*?) ( \s+ \( (?<train>[^(]*) \) )? $/x)
		    ##if($d =~ m/^ (?<name> ab | an ) \s+ (?<HH_MM>\d\d:\d\d) \s+ (?<value>.*?)			               $/x)
			{
			  my(%plus) = %+;

			  $current_slot{ $plus{name} } = \%plus;

			  printf "=%s,%03.3d,%03.3d: %s=>{%s} // %s\n",__FILE__,__LINE__,$.,
			    "\$current_slot{ $plus{name} }{HH_MM}" => $current_slot{ $plus{name} }{HH_MM},
			    '...'
			    if 0;

			  if   ($plus{name} eq 'ab')
			    {
			    }
			  elsif($plus{name} eq 'an')
			    {
			      if(exists($current_slot{ab}{HH_MM}))
				{
				  printf "\t%s .. %s [%s,%s] %s -> %s\n",
				    $current_slot{ab}{HH_MM},
				    $current_slot{an}{HH_MM},

				    'biz,travel,train,Auftrag=______',

				    $current_slot{ab}{train},

				    $current_slot{ab}{value},
				    $current_slot{an}{value},
				    ;
				}
			    }
			}
		    }
		}
	    }
	}
      elsif(m/^ (?<name> DTSTART | DTEND ) ; TZID=([^:]*) : (?<timestamp> (?<YYYY>....)(?<mm>..)(?<dd>..)T(?<HH>..)(?<MM>..)(?<SS>..) ) $/x)
	{
	  my(%plus) = %+;

	  $table{ $+{name} } = \%plus;

	  printf "=%s,%03.3d,%03.3d: %s=>{%s} // %s\n",__FILE__,__LINE__,$.,
	    "\$table{ $plus{name} }{timestamp}" => $table{ $plus{name} }{timestamp},
	    '...'
	    if 0;
	}
      elsif(m/^ (?<name> SUMMARY | DESCRIPTION ) : (?<value> .*) /x)
	{
	  my(%plus) = %+;

	  $table{ $+{name} } = \%plus;

	  printf "=%s,%03.3d,%03.3d: %s=>{%s} // %s\n",__FILE__,__LINE__,$.,
	    "\$table{ $plus{name} }{value}" => $table{ $plus{name} }{value},
	    '...'
	    if 0;
	}

    }
}
