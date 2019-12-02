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

# common rewrites:
#
#   URL=>{\(.*\)}
#
#   \1
#
# UdK-Berlin.de rewrites:
#
#   URL=>{\(.*\)?\(.*\)}
#
#   \1

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

##my($current_arg) = $_;
  my($current_arg) = $ARGV[0];
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

	##if   ( ! exists( $::table{DTSTART}{dd} ) )
	  if   ( ! defined( $::table{DTSTART} ) )
	    {
	      $::table{DTSTART}{dd}   = 'dd';
	      $::table{DTSTART}{mm}   = 'mm';
	      $::table{DTSTART}{YYYY} = 'YYYY';
	    }
	##elsif( ! exists( $::table{DTSTART}{dd} ) )
	  elsif( defined( $::table{DTSTART} ) && ! defined( $::table{DTSTART}{dd} ) )
	    {
	      $::table{DTSTART}{dd}   = 'dd';
	      $::table{DTSTART}{mm}   = 'mm';
	      $::table{DTSTART}{YYYY} = 'YYYY';
	    }

	  printf "%s %s %s\n",
	    exists( $::table{DTSTART}{dd} 	) ?                     $::table{DTSTART}{dd} : 'dd' ,

	    exists( $::table{DTSTART}{mm} 	) ? $short_month_names[ $::table{DTSTART}{mm} ] : 'mm',

	    exists( $::table{DTSTART}{YYYY} ) ?                     $::table{DTSTART}{YYYY} : 'YYYY' ,
	    ;

	  printf "\t%s:%s:%s %s .. %s:%s:%s %s",

	    exists($::table{DTSTART}{HH}) ? $::table{DTSTART}{HH} : 'HH??' ,
	    exists($::table{DTSTART}{MM}) ? $::table{DTSTART}{MM} : 'MM??' ,
	    exists($::table{DTSTART}{SS}) ? $::table{DTSTART}{SS} : 'SS??' ,
	    exists($::table{DTSTART}{Z} ) ? $::table{DTSTART}{Z}  : ''     ,

	    exists($::table{DTEND}{HH})   ? $::table{DTEND}{HH}   : 'HH'   ,
	    exists($::table{DTEND}{MM})   ? $::table{DTEND}{MM}   : 'MM'   ,
	    exists($::table{DTEND}{SS})   ? $::table{DTEND}{SS}   : 'SS'   ,
	    exists($::table{DTEND}{Z} )   ? $::table{DTEND}{Z}    : ''     ,
	    ;

	  printf STDERR "%s%s%s%s%s%s--%s.%s\n",

	    exists( $::table{DTSTART}{YYYY} ) ? $::table{DTSTART}{YYYY} : 'YYYY' ,
	    exists( $::table{DTSTART}{mm}   ) ? $::table{DTSTART}{mm}   : 'mm',
	    exists( $::table{DTSTART}{dd}   ) ? $::table{DTSTART}{dd}   : 'dd' ,

	    exists( $::table{DTSTART}{HH}   ) ? $::table{DTSTART}{HH} 	: '__' ,
	    exists( $::table{DTSTART}{MM}   ) ? $::table{DTSTART}{MM} 	: '__' ,
	    exists( $::table{DTSTART}{SS}   ) ? $::table{DTSTART}{SS} 	: '__' ,

	    defined($current_arg) ? $current_arg : '___',

	    'diary',

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

      # DTSTART;VALUE=DATE:20190718

      elsif($::current_line =~ m/^ (?<name> DTSTART | DTEND ) ( ; TZID=([^:]*) )? ( ; VALUE=DATE )? : (?<timestamp> (?<YYYY>....)(?<mm>..)(?<dd>..) ( T(?<HH>..)(?<MM>..)(?<SS>..) )? (?<Z> Z? ) ) $/x)
	{
	  my(%plus) = %+;

	  if(!exists($plus{HH}))
	    {
	      $plus{HH} = 'HH';
	      $plus{MM} = 'MM';
	      $plus{SS} = 'SS';
	    }

	  $::table{ $plus{name} } = \%plus;

	  printf "=%s,%03.3d,%03.3d: %s=>{%s} // %s\n",__FILE__,__LINE__,$.,
	    "\$::table{ $plus{name} }{timestamp}" => $::table{ $plus{name} }{timestamp},
	    '...'
	    if 0;
	}

      # DTSTART;VALUE=DATE-TIME:20190824T180000

      elsif($::current_line =~ m/^ (?<name> DTSTART | DTEND ) ( ; TZID=([^:]*) )? ( ; VALUE=DATE-TIME )? : (?<timestamp> (?<YYYY>....)(?<mm>..)(?<dd>..) ( T(?<HH>..)(?<MM>..)(?<SS>..) )? (?<Z> Z? ) ) $/x)
	{
	  my(%plus) = %+;

	  if(!exists($plus{HH}))
	    {
	      $plus{HH} = 'HH';
	      $plus{MM} = 'MM';
	      $plus{SS} = 'SS';
	    }

	  $::table{ $plus{name} } = \%plus;

	  printf "=%s,%03.3d,%03.3d: %s=>{%s} // %s\n",__FILE__,__LINE__,$.,
	    "\$::table{ $plus{name} }{timestamp}" => $::table{ $plus{name} }{timestamp},
	    '...'
	    if 0;
	}

      elsif($::current_line =~ m/^ (?<name> DTSTART | DTEND ) /x)
	{
	  my(%plus) = %+;

	  $plus{dd}   = 'dd?';
	  $plus{mm}   = '01';
	  $plus{YYYY} = 'YYYY?';
	  $plus{HH}   = 'HH?';
	  $plus{MM}   = 'MM?';
	  $plus{SS}   = 'SS?';

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
