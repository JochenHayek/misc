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
# * …

{
  %::table = ();
  $::within_VEVENT = 0;

  my(@short_month_names) =
    ( 'Jan','Feb','Mar','Apr','May','Jun'
     ,'Jul','Aug','Sep','Oct','Nov','Dec'
     );
  unshift(@short_month_names,''); # in order to have an easier mapping `number : name`

  $::current_line = '';

  while(<>)
    {
      chomp if 0;
      s/\s*$//;

      # DTEND;TZID=Europe/Berlin:20171103T152600

      if(0)
	{
	}
      elsif(m/^ \x20 (?<continuation_line> .*)  $/x)
	{
	  my(%plus) = %+;

	  printf "=%s,%03.3d,%03.3d: %s=>{%s} // %s\n",__FILE__,__LINE__,$.,
	    '$plus{continuation_line}' => $plus{continuation_line},
	    '...'
	    if 0;

	  $::current_line .= $plus{continuation_line};
	}
      elsif(m/^ (?<name> BEGIN ) : VEVENT $/x)
	{
	  $::within_VEVENT = 1;
	  %::table = ();
	  $::current_line = '';
	}
      elsif(m/^ (?<name> END ) : VEVENT $/x)
	{
	  my(%plus) = %+;

	  &proc_last_line;
	  $::within_VEVENT = 0;

	  printf "%s %s %s\n",
	    $::table{DTSTART}{dd},

	    $short_month_names[ $::table{DTSTART}{mm} ],

	    $::table{DTSTART}{YYYY},
	    ;

	  printf "\t%s:%s:%s %s .. %s:%s:%s %s",
	    $::table{DTSTART}{HH},
	    $::table{DTSTART}{MM},
	    $::table{DTSTART}{SS},
	    $::table{DTSTART}{Z},

	    $::table{DTEND}{HH},
	    $::table{DTEND}{MM},
	    $::table{DTEND}{SS},
	    $::table{DTEND}{Z},
	    ;

	  delete($::table{DTSTART});
	  delete($::table{DTEND});

	  foreach my $i ('SUMMARY' , 'LOCATION' , 'URL')
	    {
	      foreach my $a (@{ $::table{ $i } })
		{
		  printf " %s=>{%s}",
		    $i => $a->{value},
		    ;
		}

	      if(exists($::table{ $i }))
		{
		  delete($::table{ $i });
		}
	    }

	  printf "\n\n";

	  foreach my $i ('ORGANIZER' , 'ATTENDEE')
	    {
	      foreach my $a (@{ $::table{ $i } })
		{
		  if(defined($a->{attributes}))
		    {
		      printf "\t\t%s=>{%s} – attributes: {%s}\n",
			$i => $a->{value},
			$a->{attributes}
			;
		    }
		  else
		    {
		      printf "\t\t%s=>{%s}\n",
			$i => $a->{value},
			;
		    }
		}

	      delete($::table{ $i });
	    }

	  printf "\n";

	  foreach my $i ('DESCRIPTION')
	    {
	      foreach my $a (@{ $::table{ $i } })
		{
		  printf "\t\t%s=>{\n\n",
		    $i;

		  my(@list) = split(/\\n/,$a->{value});

		  printf "=%s,%03.3d,%03.3d: %s=>{%s} // %s\n",__FILE__,__LINE__,$.,
		    '$#list' => $#list,
		    '...'
		    if 0;

		  foreach my $d (@list)
		    {
		      printf "\t\t\t{%s}\n",$d;
		    }

		  printf "\n\t\t}\n\n",
		    ;

		  my(%current_slot);

		  foreach my $d (@list)
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

	      if(exists($::table{ $i }))
		{
		  delete($::table{ $i });
		}
	    }

	  foreach my $k (sort keys %::table)
	    {
	      foreach my $a (@{ $::table{ $k } })
		{
		  if(defined($a->{attributes}))
		    {
		      printf "\t\t%s=>{%s} – attributes: {%s}\n",
			$k => $a->{value},
			$a->{attributes}
			;
		    }
		  else
		    {
		      printf "\t\t%s=>{%s}\n",
			$k => $a->{value},
			;
		    }
		}

	      delete($::table{ $k });
	    }

	  %::table = ();
	}
      else
	{
	  &proc_last_line;
	  $::current_line = $_;
	}
    }
}
#
sub proc_last_line
{
  my($package,$filename,$line,$proc_name) = caller(0);

  my(%param) = @_;

  $return_value = 0;

  printf STDERR ">%s,%d,%s\n",__FILE__,__LINE__,$proc_name
    if 0 && $main::options{debug};

  if( $::within_VEVENT )
    {
      if(0)
	{
	}
      elsif($::current_line =~ m/^ (?<name> DTSTART | DTEND ) ( ; TZID=([^:]*) )? : (?<timestamp> (?<YYYY>....)(?<mm>..)(?<dd>..)T(?<HH>..)(?<MM>..)(?<SS>..) (?<Z> Z? ) ) $/x)
	{
	  my(%plus) = %+;

	  $::table{ $plus{name} } = \%plus;

	  printf "=%s,%03.3d,%03.3d: %s=>{%s} // %s\n",__FILE__,__LINE__,$.,
	    "\$::table{ $plus{name} }{timestamp}" => $::table{ $plus{name} }{timestamp},
	    '...'
	    if 0;
	}
      elsif($::current_line =~ m/^ (?<name> [^;:]+ ) (?<attributes> ; [^=]+ = [^:]* )? : (?<value> .*) /x)
	{
	  my(%plus) = %+;

	  if(defined($plus{attributes}))
	    {
	      $plus{attributes} =~ s/^;//;
	    }

	  printf "=%s,%03.3d,%03.3d: %s=>{%s} // %s\n",__FILE__,__LINE__,$.,
	    "\$::table{ $plus{name} }{value}" => $::table{ $plus{name} }{value},
	    '...'
	    if 0;

	  push( @{ $::table{ $plus{name} } } , \%plus );
	}

      $::current_line = '';
    }

  printf STDERR "<%s,%d,%s: %s=>%d\n",__FILE__,__LINE__,$proc_name
    ,'$return_value',$return_value
    if 0 && $main::options{debug};

  return $return_value;
}
