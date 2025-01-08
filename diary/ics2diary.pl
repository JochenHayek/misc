#! /usr/bin/perl -w

# usage:
#
#   ~/git-servers/github.com/JochenHayek/misc/ics2diary.pl ics2diary.sample-BAHN_Fahrplan.ics > ics2diary.sample-BAHN_Fahrplan.diary
#
# to be called within emacs dired-mode like this
#
#   ~/git-servers/github.com/JochenHayek/misc/diary/ics2diary.pl ? > `?`.diary

################################################################################

# these ones are also quite handy:

# ???
#
#   perl -i~ -pe   's/URL:([^?]*)\?.*$/URL:$1/x' *.ics
#   perl     -pe   's/URL:([^?]*)\?.*$/URL:$1/x'

# remove URL=>{…} around here:

#   perl -i~ -pe  's/URL=>{(.*?)}/$1/x' *.ics
#   perl     -pe  's/URL=>{(.*?)}/$1/x'

# remove the curly braces around here:
#   {https://www.berlinale.de/de/programm/programm/detail.html?film_id=202004528}
#
#   perl -i~ -pe 's,^ (\s*) { (https?://.*) } $,$1$2,x' *.ics
#   perl -i~ -pe 's,^ (\s*) { (https?://.*) } $,$1$2,x'
#   perl     -pe 's,^ (\s*) { (https?://.*) } $,$1$2,x'

# ??? are the URL-s alright ???

# =======================

# [_,UEFA_EURO_2024,Fussball-EM] :
#
#	/scp:ber.jochen.hayek.name:events/000Fussball-EM/000Fussball-EM.README.txt
#
#	using the utility in a pipeline with a few "fgrep -v '...'" in before.

# =======================

# Berlinale:

#   renaming "blabla (99).ics" to blabla.99.ics :

#     $ ~/bin/rename 's/ \((\d+)\)/.$1/' *.ics

# replace "___" with "Berlinale--Ticketcode-______--___--___"

#   … Berlinale--Ticketcode-______--Brasilien …

# putting the Ticketcode into the file name:

#     $ fgrep Ticket *code-___*.ics.diary
#     ...

#     cat *.ics.diary > diary

#   with emacs:
#
#     perl -pe 's/URL=>{(.*\?film_id=\d+)}/$1/x'
#
#   manually remove duplicate dates!

#   … merge … into ~/diary :

#     ~/git-servers/github.com/JochenHayek/misc/diary/JHdiary-utils2 --job_merge --left ~/diary --right diary > diary-merged
#
#   is it alright?

#     $ diff -c ~/diary diary-merged

#     $ mv diary-merged ~/diary

# =======================

# UdK:

### perl -i~ -pe 's/URL=>{([^?]*)\?.*}/$1/x' *.ics.diary
#   perl -i~ -pe 's/URL=>{([^?]*)}/$1/x' *.ics.diary

#   perl -i~ -pe 's/, ACHTUNG, nicht barrierefrei, /, / ' *.ics

#   perl -i~ -pe 's/(LOCATION):(Kammersaal, Fasanenstr. 1 B, 10623, Berlin)/$1:UdK, $2/' *.ics
#   perl -i~ -pe 's/(LOCATION):(Carl-Flesch-Saal, Bundesallee 1-12, 10719, Berlin)/$1:UdK, $2/' *.ics
#   perl -i~ -pe 's/(LOCATION):(Joseph-Joachim-Konzertsaal, Bundesallee 1-12, 10719, Berlin)/$1:UdK, $2/' *.ics


#   perl -i~ -pe 's/(LOCATION):(Kleiner Vortragssaal, Bundesallee 1-12, 10719, Berlin)/$1:UdK, $2/' *.ics
#   perl -i~ -pe 's/(LOCATION):(Kammermusiksaal Friedenau, Isoldestr. 9, 12159, Berlin)/$1:UdK, $2/' *.ics
#???perl -i~ -pe 's/(LOCATION):(Geb.ude Bundesallee, Bundesallee 1-12, 10719, Berlin)/$1:UdK, $2/' *.ics
#.. perl -i~ -pe 's/(LOCATION):()/$1:UdK, $2/' *.ics

#   for i in *.ics; do ~/bin/ics2diary.pl "$i" >/dev/null; done 2>&1 | sh -x

#   perl -i~ -pe 's/(CLASS|TZID)=>\{[^}]*\}//x ' *.ics.diary

#   cat *.ics.diary > diary

### some clean up within diary:
### * remove DESCRIPTION
### * remove duplicate date lines
### * ...

#	    … merge … into ~/diary :
#		~/git-servers/github.com/JochenHayek/misc/diary/JHdiary-utils2 --job_merge --left ~/diary --right diary > ~/transfer/000diary/diary
#
#               # manually remove duplicate dates!
#
#	    is it alright?
#		diff -c ~/diary ~/transfer/000diary/diary

#           within emacs:
#
#???
#               https:// → ^J^J^Ihttps://
#
#	    then replace ...
#		mv --verbose ~/transfer/000diary/diary ~/diary

# lots of unsuccessful attempts to get rid of empty DESCRIPTION:
#
#   perl -i~ -pe 's/(CLASS|TZID|DESCRIPTIONl)=>\{[^}]*\}//sx ' 20191222100000--event.ics.diary

################################################################################

# in which contexts to use:
#
# * Google calendar exports
# * "Deutsche Bahn" traveling schedules
# * "Navigator" auf iOS
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
  %main::options = ();
  $main::options{debug} = 1;

  my($proc_name) = '(main)';
  my(%plus_train_target);

  %::table = ();
  $::within_VEVENT = 0;

  my(@short_month_names) =
    ( 'Jan','Feb','Mar','Apr','May','Jun'
     ,'Jul','Aug','Sep','Oct','Nov','Dec'
     );
  unshift(@short_month_names,''); # in order to have an easier mapping `number : name`

  $::current_line = '';

##use English;
##$INPUT_RECORD_SEPARATOR = "\r\n";	# .ics files do not have this strict linefeed convention

  # I would prefer this within the loop, but something screws up:

##my($current_arg) = $_;
  my($current_arg) = $ARGV[0];
  while(<>)
    {
      printf STDERR "=%s,%d,%s: %s=>%d,%s=>{%s} // %s\n",__FILE__,__LINE__,$proc_name
	,'$#ARGV',$#ARGV
	,'$ARGV[0]',$ARGV[0]
	,'$#ARGV >= 1 ?!?'
	if 0 && $main::options{debug};

      ##chomp if 0;
      ##chomp;
      ##s/\s*$//;
      s/\r?\n//;		# some .ics files have "\r\n" linefeeds, some have "\n"

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

	  printf STDERR "=%s,%d,%s: %s=>%d // %s\n",__FILE__,__LINE__,$proc_name
	    ,'defined($current_arg)', defined($current_arg) ? 1 : 0
	    ,'...'
	    if 0 && $main::options{debug};

	  printf STDERR "mv %s %s%s%s%s%s%s--___.%s\n",

	    ################################################################################

	  ##defined($current_arg) ? $current_arg : '___',	# outside emacs
	  ##'*',						# within  emacs

	    '*',						# within  emacs

	    ################################################################################

	    exists( $::table{DTSTART}{YYYY} ) ? $::table{DTSTART}{YYYY} : 'YYYY' ,
	    exists( $::table{DTSTART}{mm}   ) ? $::table{DTSTART}{mm}   : 'mm',
	    exists( $::table{DTSTART}{dd}   ) ? $::table{DTSTART}{dd}   : 'dd' ,

	    exists( $::table{DTSTART}{HH}   ) ? $::table{DTSTART}{HH} 	: '__' ,
	    exists( $::table{DTSTART}{MM}   ) ? $::table{DTSTART}{MM} 	: '__' ,
	    exists( $::table{DTSTART}{SS}   ) ? $::table{DTSTART}{SS} 	: '__' ,

	    defined($current_arg) ? $current_arg : '___',

	    # if the utility gets called with with an argument,
	    # then there is something to rename. // $ mv * 20240116072100--___.x.ics // "x.ics" is from the original file name
	    # else there is nothing   to rename. // -

	    # context: UEFA_EURO_2024 and Fussball-EM – events/000Fussball-EM/000Fussball-EM.README.txt

	    if defined($current_arg);

	  delete($::table{DTSTART});
	  delete($::table{DTEND});

	  foreach my $i ('SUMMARY' , 'LOCATION' , 'URL')
	    {
	      foreach my $a (@{ $::table{ $i } })
		{
		  $a->{value} =~ s/\\,/,/g;

		  printf " %s=>{%s}",
		    $i => $a->{value},
		    ;
		}

	      if(($i ne 'LOCATION') && exists($::table{ $i })) # skip this for LOCATION, because I am going to use it for "ÖPNV Navigator" and its source of initial footpath
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

		  # ÖPNV Navigator: // start
		  my($footpath_source) = $::table{ LOCATION }[0]{value};

		  # ÖPNV Navigator: // end

		  my(%current_slot);

		  foreach my $d (@list)
		    {
		      printf "\t\t\t{%s}\n",$d
			if 0;

		      if   (0)
			{
			}

		      # ÖPNV Navigator: e.g. {7 minutes (336 m) footpath to U Birkenstr.}

		      elsif($d =~ m/^ (?<footpath_minutes> .*) \s+ minutes \s+ \( (?<footpath_meters>\d*) \s+ m \) \s+ footpath \s+ to \s+ (?<footpath_target>.*) $/x) # ÖPNV Navigator
			{
			  %plus_train_target = %+;

			  printf "=%s,%03.3d,%03.3d: %s=>{%s},%s=>{%s},%s=>{%s} // %s\n",__FILE__,__LINE__,$.,
			    "\$plus_train_target{footpath_minutes}" => $plus_train_target{footpath_minutes},
			    "\$plus_train_target{footpath_meters}"  => $plus_train_target{footpath_meters},
			    "\$plus_train_target{footpath_target}"  => $plus_train_target{footpath_target},
			    '...'
			    if 0;

			  $plus_train_target{footpath_target} =~ s/\\,/,/g;

			  printf "\t%s .. %s (%d minutes) [%s,%s] %s -> %s\n",
			    'HH:MM',
			    'HH:MM',
			    $plus_train_target{footpath_minutes},

			    'travel',
			    'footpath',
			    
			    ##'…',							# start of footpath
			    $footpath_source,						# start of footpath

			    $plus_train_target{footpath_target};			# end of footpath
			}

		      # ÖPNV Navigator: {U9 → Osloer Str.}

		      elsif($d =~ m/^ (?<train> .*) \s+ → \s+ (?<target>.*) $/x) # ÖPNV Navigator
			{
			  %plus_train_target = %+;

			  printf "=%s,%03.3d,%03.3d: %s=>{%s},%s=>{%s} // %s\n",__FILE__,__LINE__,$.,
			    "\$plus_train_target{train}"  => $plus_train_target{train},
			    "\$plus_train_target{target}" => $plus_train_target{target},
			    '...'
			    if 0;
			}

		      elsif($d =~ m/^ (?<name> departure | arrival ) \s+ (?<dd>\d\d)\/(?<mm>\d\d)\/(?<YYYY>\d\d\d\d)\\, \s+ (?<HH>\d+):(?<MM>\d\d) \s+ (?<value>.*) $/x) # ÖPNV Navigator
			{
			  my(%plus) = %+;

			  printf "=%s,%03.3d,%03.3d: %s=>{%s},%s=>{%s},%s=>{%s},%s=>{%s},%s=>{%s},%s=>{%s} // %s\n",__FILE__,__LINE__,$.,
			    "\$plus{YYYY}" => $plus{YYYY},
			    "\$plus{mm}" => $plus{mm},
			    "\$plus{dd}" => $plus{dd_mm},
			    "\$plus{HH}" => $plus{HH},
			    "\$plus{MM}" => $plus{MM},
			    "\$plus{value}" => $plus{value},
			    '...'
			    if 0;

			  if(0)
			    {
			    }
			  elsif(0)
			    {
			      ##$plus{time} = "$plus{YYYY}-$plus{mm}-$plus{dd} $plus{HH}:$plus{MM}";
			      $plus{time} = sprintf "%s-%s-%s %02.2d:%s",
				$plus{YYYY},
				$plus{mm},
				$plus{dd},
				$plus{HH},
				$plus{MM};
			    }
			  elsif(1)
			    {
			      ##$plus{time} = "$plus{YYYY}-$plus{mm}-$plus{dd} $plus{HH}:$plus{MM}";
			      $plus{time} = sprintf "%02.2d:%s",
				$plus{HH},
				$plus{MM};
			    }

			  $current_slot{ $plus{name} } = \%plus;

			  printf "=%s,%03.3d,%03.3d: %s=>{%s} // %s\n",__FILE__,__LINE__,$.,
			    "\$current_slot{ $plus{name} }{time}" => $current_slot{ $plus{name} }{time},
			    '...'
			    if 0;

			  if   ($plus{name} eq 'departure')
			    {
			    }
			  elsif($plus{name} eq 'arrival')
			    {
			      if(exists($current_slot{departure}{time}))
				{
				  $footpath_source = $current_slot{arrival}{value};
				  
				  printf "\t%s .. %s [%s,%s (→ %s)] %s -> %s\n",
				    $current_slot{departure}{time},
				    $current_slot{arrival}{time},

				    'travel',
				    $plus_train_target{train},
				    $plus_train_target{target},

				    ##$current_slot{departure}{train},

				    $current_slot{departure}{value},
				    $current_slot{arrival}{value},
				    ;
				}
			      %plus_train_target = ();
			    }
			}

		      # Deutsche Bahn 2024 … – sample:
		      # 
		      # {Köln Hbf ➞ Dortmund Hbf}
		      # {ICE 516 (3320)}
		      # {● ab 18:11 Köln Hbf ▷ Gleis 4}
		      # {○ an 19:21 Dortmund Hbf ▷ Gleis 10}

		      elsif($d =~ m/^ (?<from> .* ) \s+ ➞ \s+ (?<to> .* ) $/x) # Deutsche Bahn 2024 …
			{
			  my(%plus) = %+;

			  $current_slot{ from_to } = \%plus;

			  printf "=%s,%03.3d,%03.3d: %s=>{%s},%s=>{%s} // %s\n",__FILE__,__LINE__,$.,
			    "\$current_slot{ from_to }{from}" => $current_slot{ from_to }{from},
			    "\$current_slot{ from_to }{to}" => $current_slot{ from_to }{to},
			    '...'
			    if 0;
			}

		      # Deutsche Bahn 2024 … – sample:
		      # 
		      # {ICE 516 (3320)}

		      elsif($d =~ m/^ (?<train_kind> \w+ ) \s+ (?<train_line> \w+ ) \s+ \( (?<train_no> \w+ ) \) /x) # Deutsche Bahn 2024 …
			{
			  my(%plus) = %+;

			  $current_slot{ train } = \%plus;

			  printf "=%s,%03.3d,%03.3d: %s=>{%s},%s=>{%s},%s=>{%s} // %s\n",__FILE__,__LINE__,$.,
			    "\$current_slot{ train }{train_kind}" => $current_slot{ train }{train_kind},
			    "\$current_slot{ train }{train_line}" => $current_slot{ train }{train_line},
			    "\$current_slot{ train }{train_no}" => $current_slot{ train }{train_no},
			    '...'
			    if 0;
			}

		      # Deutsche Bahn 2024 … – sample:
		      # 
		      # {● ab 18:11 Köln Hbf ▷ Gleis 4}
		      # {○ an 19:21 Dortmund Hbf ▷ Gleis 10}

		      elsif($d =~ m/^ .+ \s (?<name> ab | an ) \s+ (?<HH_MM>\d\d:\d\d) \s+ (?<location>.*) \s ▷ \s (?<platform> Gleis \s \d+ ) $/x) # Deutsche Bahn 2024 …
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
				  printf "\t%s .. %s [%s,%s %s (%s)] %s (%s) -> %s (%s)\n",
				    $current_slot{ab}{HH_MM},
				    $current_slot{an}{HH_MM},

				    'biz,travel,train,Auftrag=______',

				    $current_slot{train}{train_kind},
				    $current_slot{train}{train_line},
				    $current_slot{train}{train_no},

				    $current_slot{ab}{location},
				    $current_slot{ab}{platform},

				    $current_slot{an}{location},
				    $current_slot{an}{platform},
				    ;
				}
			    }
			}

		      # Deutsche Bahn < 2024 – sample:
		      #
		      # {ab 07:30 Berlin Hbf (tief) - Gleis 2 (ICE 1005)}
		      # {an 08:39 Halle(Saale)Hbf }

		      elsif($d =~ m/^ (?<name> ab | an ) \s+ (?<HH_MM>\d\d:\d\d) \s+ (?<value>.*?) ( \s+ \( (?<train>[^(]*) \) )? $/x) # Deutsche Bahn < 2024
			{
			  my(%plus) = %+;

			  $current_slot{ $plus{name} } = \%plus;

			  printf "=%s,%03.3d,%03.3d: %s=>{%s} // %s\n",__FILE__,__LINE__,$.,
			    "\$current_slot{ $plus{name} }{HH_MM}" => $current_slot{ $plus{name} }{HH_MM},
			    '...'
			    if 1;

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
