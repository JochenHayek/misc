#! /usr/bin/perl -w

# usage:
#
#   ~/git-servers/github.com/JochenHayek/misc/ics2diary.pl ics2diary.sample-BAHN_Fahrplan.ics > ics2diary.sample-BAHN_Fahrplan.diary
#
# to be called within emacs dired-mode like this
#
#   ~/git-servers/github.com/JochenHayek/misc/ics2diary.pl ? > $(echo ? ).diary

# in which contexts to use:
#
# * Google calendar exports
# * "Deutsche Bahn" traveling schedules
# * …

# wishlist:
# * remove some runtime warnings ("uninitialized …")
#   * those warnings occur in the context of samples not really on my main focus
# * …

{
  my(%table);

  my(@short_month_names) =
    ( 'Jan','Feb','Mar','Apr','May','Jun'
     ,'Jul','Aug','Sep','Oct','Nov','Dec'
     );
  unshift(@short_month_names,''); # in order to have an easier mapping `number : name`

  my($last_label_encountered);

  while(<>)
    {
      chomp if 0;
      s/\s*$//;

      # DTEND;TZID=Europe/Berlin:20171103T152600

      if(0)
	{
	}
      elsif(m/^ \x20 (?<rem> .*)  $/x)
	{
	  my(%plus) = %+;

	  printf "=%s,%03.3d,%03.3d: %s=>{%s} // %s\n",__FILE__,__LINE__,$.,
	    '$plus{rem}' => $plus{rem},
	    '...'
	    if 0;

	  $table{ $last_label_encountered }{value} .= $plus{rem};
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

		$short_month_names[ $table{DTSTART}{mm} ],

		$table{DTSTART}{YYYY},
		;

	      printf "\t%s:%s:%s %s .. %s:%s:%s %s",
		$table{DTSTART}{HH},
		$table{DTSTART}{MM},
		$table{DTSTART}{SS},
		$table{DTSTART}{Z},

		$table{DTEND}{HH},
		$table{DTEND}{MM},
		$table{DTEND}{SS},
		$table{DTEND}{Z},
		;

	      delete($table{DTSTART});
	      delete($table{DTEND});

	      foreach my $i ('SUMMARY' , 'LOCATION' , 'URL')
		{
		  if(exists($table{ $i }))
		    {
		      printf " %s=>{%s}",
			$i => $table{ $i }{value},
			;

		      delete($table{ $i });
		    }
		}

	      printf "\n\n";

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

		  delete($table{DESCRIPTION});
		}

	      foreach my $k (sort keys %table)
		{
		  printf STDERR "=%s,%03.3d,%03.3d: %s=>{%s} // %s\n",__FILE__,__LINE__,$.,
		    '$k' => $k,
		    'not made use of'
		    if 0;

		  if($table{ $k }{attributes})
		    {
		      printf "\t\t%s=>{%s} – attributes: {%s} // %s\n",
			$k => $table{ $k }{value},
			$table{ $k }{attributes},
			'not properly made use of',
			;
		    }
		  else
		    {
		      printf "\t\t%s=>{%s} // %s\n",
			$k => $table{ $k }{value},
			'not properly made use of',
			;
		    }
		}

	      %table = ();
	    }
	}
      elsif(m/^ (?<name> DTSTART | DTEND ) ( ; TZID=([^:]*) )? : (?<timestamp> (?<YYYY>....)(?<mm>..)(?<dd>..)T(?<HH>..)(?<MM>..)(?<SS>..) (?<Z> Z? ) ) $/x)
	{
	  my(%plus) = %+;

	  $last_label_encountered = $plus{name};

	  $table{ $plus{name} } = \%plus;

	  printf "=%s,%03.3d,%03.3d: %s=>{%s} // %s\n",__FILE__,__LINE__,$.,
	    "\$table{ $plus{name} }{timestamp}" => $table{ $plus{name} }{timestamp},
	    '...'
	    if 0;
	}
    ##elsif(m/^ (?<name> SUMMARY | DESCRIPTION | LOCATION | URL ) (?<attributes> ; [^=]+ = [^:]* )? : (?<value> .*) /x)
      elsif(m/^ (?<name> [^;:]+ ) (?<attributes> ; [^=]+ = [^:]* )? : (?<value> .*) /x)
	{
	  my(%plus) = %+;

	  # CAVEAT: I should do something with the "attributes".

	  $last_label_encountered = $plus{name};

	  $table{ $plus{name} } = \%plus;

	  printf "=%s,%03.3d,%03.3d: %s=>{%s} // %s\n",__FILE__,__LINE__,$.,
	    "\$table{ $plus{name} }{value}" => $table{ $plus{name} }{value},
	    '...'
	    if 0;
	}

    }
}
