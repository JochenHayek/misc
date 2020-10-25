#! /usr/bin/perl -w

# one step after the other:

# $ fgrep -v 'empty {Date:} header field, so we are going to use From_captures to extract date+time'
# $ fgrep -v ' // *** WILL BE REMOVED, BECAUSE'
# $ env 'current_local_DST_shift=1' ~/git-servers/github.com/JochenHayek/misc/procmail/diary.procmail-from.rewriting.pl

################################################################################

# all steps at once:

# $ fgrep -v 'empty {Date:} header field, so we are going to use From_captures to extract date+time' | fgrep -v ' // *** WILL BE REMOVED, BECAUSE' | env 'current_local_DST_shift=1' ~/git-servers/github.com/JochenHayek/misc/procmail/diary.procmail-from.rewriting.pl

################################################################################

# restriction:
#
#   current_local_DST_shift can only be a positive 1- or 2-decimal-digits number of hours.
#   avoid leading "0", as this might make Perl consider it an octal number instead of a decimal number.
#
#   of course … leading "0" can / will be removed at one stage in order to remove this restriction.

################################################################################

{
  my($rec) = '';

  our(%gigaset_elements_homes) =
  ##( 'Jochens Home'     =>  'Jochen_s_Home' ,
    ( 'Jochens Home'     =>  'Gigaset_elements_Jochen_s_Home' ,
      'Gigaset elements' =>  'Gigaset_elements_Jochen_s_Home' ,
      'motion'           =>  'Gigaset_elements_Jochen_s_Home_motion' ,
      'Front door 1'     =>  'Gigaset_elements_Jochen_s_Home_front_door' ,
    );

  our(%fritz_box_messages) =
    ( 'Anruf' => 'phone_call' ,
      'Call'  => 'phone_call' ,
      'Nachricht' => 'phone_message' ,
      'Fax' => 'fax' ,
    );

  while(<>)
    {
      if(m/^ (?<prefix>.*) \s From: \s+ (?<addr>.*) ; $/x)
	{
	  my(%plus) = %+;

	  my($new_addr) = &SPF_bullshit__rewrite_addr('addr' => $plus{addr});

	  $_ = "$plus{prefix} From: $new_addr;\n";
	}

      ################################################################################

      if(m/^(\S)(.*)/)
	{
	  &func('rec' => $rec);

	  $rec = $_;
	}
      else
	{
	  $rec .= $_;
	}
    }

  &func('rec' => $rec);

  exit 0;
}

sub func
{
  my(%param) = @_;

  ################################################################################

  # 05 Sep 2020
  # 	10:48:15 -0700 [_,not_SPF_mangled,paypal] From: service@paypal.de;
  # 		FROM: "service@paypal.de" <service@paypal.de>;
  # 		TO: Jochen Hayek <Jochen+paypal@Hayek.name>;
  # 		SUBJECT: Your payment to PRIMARK BERLIN ZOOM for 17,55 EUR;
  # 		Folder: .topics-finance.paypal/new/1599328100.9506_1.h20;
  #
  # ->
  #
  # 05 Sep 2020
  #     19:48:15 (10:48:15 -0700) [_,not_SPF_mangled,paypal] From: service@paypal.de;
  # 		FROM: "service@paypal.de" <service@paypal.de>;
  # 		TO: Jochen Hayek <Jochen+paypal@Hayek.name>;
  # 		SUBJECT: Your payment to PRIMARK BERLIN ZOOM for 17,55 EUR;
  # 		Folder: .topics-finance.paypal/new/1599328100.9506_1.h20;
  #

  if( $param{rec} =~ m{

		     (?<d>\d\d) \s (?<b>[A-Za-z][a-z][a-z]) \s (?<Y>\d\d\d\d) (?<between_date_and_time>\s+)
		     (?<H>\d\d):(?<M>\d\d):(?<S>\d\d) \s 
		     (?<DST> (?<DST_sign>[+-]) (?<DST_HH>\d\d) (?<DST_MM>\d0) ) 
		     ( \s+ (?<DST_zone_name> \( [a-z][a-z][a-z] \) ) )? 
		     \s \[

	}gix
    )
  {
    my(%plus) = %+;

    # dealing with timezone (difference).

    # wishlist:
    # * either handle this "automatically" (= with enough programmatical intelligence – i.e. by enquiring current difference between the local time zone and UTC)
    # * or pass this in as a command line argument (or so).

    my($current_local_DST_shift) = $ENV{current_local_DST_shift}; # restriction: right now this can only be a positive 1- or 2-decimal-digits number of hours
  ##my($current_local_DST_shift) = '1';	# winter time in +49 AKA Germany
  ##my($current_local_DST_shift) = '2';	# summer time in +49 AKA Germany

  ##my($formatted_DST_shift) =       sprintf("+0%02.2d00",$current_local_DST_shift);
    my($formatted_DST_shift) = '+' . sprintf(  "%02.2d"  ,$current_local_DST_shift) . '00'; # e.g. '1' -> '+0100'

    if($plus{DST} eq ${formatted_DST_shift}) # e.g. '+0100'
      {}
    else
      {
	# most simple (resp. far too simple) way of adding timezone difference.
	# TBD: there should be a subroutine dedicated to this.

	my($new_H) = sprintf "%02.2d", $plus{H} + $current_local_DST_shift - "$plus{DST_sign}$plus{DST_HH}";

	my($extended_orig_DST_zone_name) = defined($plus{DST_zone_name}) ? " $plus{DST_zone_name}" : '';

	# temporarily prepend this to the time string during development, if needed:
	#
	#   ((($plus{DST_sign}$plus{DST_HH}:$plus{DST_sign}$plus{DST_HH}$plus{DST_MM}:$new_H)))
	#
	#   "04:28:57 +0000" -> "06:28:57 (04:28:57 +0000)"

	$param{rec} =~ s{

		       (?<d>\d\d) \s (?<b>[A-Za-z][a-z][a-z]) \s (?<Y>\d\d\d\d) (?<between_date_and_time>\s+)
		       (?<H>\d\d):(?<M>\d\d):(?<S>\d\d) \s 
		       (?<DST_sign>[+-])(?<DST_HH>\d\d)(?<DST_MM>\d0) 
		       ( \s+ (?<DST_zone_name> \( [a-z][a-z][a-z] \) ) )? 
		       \s \[

	  }{$+{d} $+{b} $+{Y}$+{between_date_and_time}${new_H}:$+{M}:$+{S} ($+{H}:$+{M}:$+{S} $+{DST_sign}$+{DST_HH}$+{DST_MM}${extended_orig_DST_zone_name}) [}gix if 1;
      }
  }

  ################################################################################

  # de.wikipedia.org

  # sample:
  #
  #   SUBJECT: Wikipedia-Seite Morris Wintschewski wurde von Nutzloses Wissen geändert;

  #   30 Dec 2019
  #   	18:22:56 +0100 [_,not_SPF_mangled] From: ych2277a+caf_=jochen+ych2277a=hayek.name@gmail.com;
  #   		 FROM: "Wikipedia" <wiki@wikimedia.org>;
  #   		 TO: "YCH2277" <ych2277a@gmail.com>;
  #   		 SUBJECT: Wikipedia-Seite Dietmar Till wurde von Tammany2012 geändert;
  #   		 Folder: .topics.social_networking/new/1577726579.17503_1.h20

  $param{rec} =~ s{

                 \] \s+
            	 From	  : \s+ (?<From>.*); \s*
                 FROM	  : \s+ (?<FROM>[^<]* .* ); \s+
                 TO       : \s* "? (?<TO_name> [^<]*? ) "? \s* < (?<TO_address>   .* ) >; \s+
		 SUBJECT:   \s+ (?<SUBJECT>Wikipedia-Seite \s+ (?<article>.*) \s+ wurde \s+ von \s+ (?<author>.*) \s+ ge.*ndert); \s+
		 Folder : \s+ (?<Folder>[^/]*\/\S*)

    }{,de.wikipedia.org,change] // wikipedia_account=>{$+{TO_name}},author=>{$+{author}},article=>{https://de.wikipedia.org/wiki/$+{article}};}gix;

  ################################################################################

  # en.wikipedia.org

  # sample:
  #
  #   SUBJECT: Wikipedia page Make (software) has been changed by Bollapragada raju;

  $param{rec} =~ s{

                 \] \s+
            	 From	  : \s+ (?<From>.*); \s+
                 FROM	  : \s+ (?<FROM>[^<]* .* ); \s+
                 TO       : \s* "? (?<TO_name> [^<]*? ) "? \s* < (?<TO_address>   .* ) >; \s+
		 SUBJECT:   \s+ (?<SUBJECT>Wikipedia \s+ page \s+ (?<article>.*?) \s+ has \s+ been \s+ changed \s+ by \s+ (?<author>.*)); \s+
		 Folder : \s+ (?<Folder>[^/]*\/\S*)

    }{,en.wikipedia.org,change] // wikipedia_account=>{$+{TO_name}},author=>{$+{author}},article=>{https://en.wikipedia.org/wiki/$+{article}};}gix;

  ################################################################################

  # jewiki.net
  
  # sample:
  #
  #   09 Apr 2019
  #           00:20:02 +0200 [_,not_SPF_mangled,judaism] From: MKuehntopf@gmx.ch;
  #                   FROM: Jewiki <MKuehntopf@gmx.ch>
  #                   TO: Johayek <JochenPLUSjewiki@Hayek.name>;
  #                   SUBJECT: Jewiki-Seite Tuvia Hod wurde von Michael Kühntopf geändert;
  #                   Folder: .topics.judaism/new/1554762004.17624_1.h20;

  # https://www.jewiki.net/wiki/El_male_rachamim

  $param{rec} =~ s{

                 \] \s+
            	 From	  : \s+ (?<From>.*); \s+
                 FROM	  : \s+ (?<FROM>.*); \s+
                 TO       : \s* "? (?<TO_name> [^<]*? ) "? \s* < (?<TO_address>   .* ) >; \s+
		 SUBJECT:   \s+ (?<SUBJECT>Jewiki-Seite \s+ (?<article>.*) \s+ wurde \s+ von \s+ (?<author>.*) \s+ ge.*ndert); \s+
		 Folder : \s+ (?<Folder>[^/]*\/\S*)

    }{,jewiki.net,change] // wikipedia_account=>{$+{TO_name}},author=>{$+{author}},article=>{https://www.jewiki.net/wiki/$+{article}};}gix;

  ################################################################################

  # fritz.box / Anruf von …

  # fritz.box / Anruf von …
  #
  #   Subject: Anruf von Per,Flor (01628977808);

# 11 Dec 2019
# 	12:26:26 +0100 [_,not_SPF_mangled] From: Jochen+FRITZ-Box@Hayek.name;
# 		 FROM: "Jochen Hayek's FRITZ!Box 7590 @BER" <Jochen+FRITZ-Box@Hayek.name>;
# 		 TO: <Jochen+FRITZ-Box-Anrufe-4916090104554@Hayek.name>,;
# 		 SUBJECT: Anruf von BZzG (03049300160);
# 		 Folder: .topics-computers.admin/new/1576063587.15668_1.h20
#
# 24 Dec 2019
# 	14:15:59 +0100 [_,not_SPF_mangled] From: Jochen+FRITZ-Box@Hayek.name;
# 		 FROM: "Jochen Hayek's FRITZ!Box 7590 @BER" <Jochen+FRITZ-Box@Hayek.name>;
# 		 TO: <Jochen+FRITZ-Box-Anrufe-4916090104554@Hayek.name>,;
# 		 SUBJECT: Anruf von Briz,Cris (03023639377);
# 		 Folder: .topics-computers.admin/new/1577193359.20291_1.h20
#
# 27 Apr 2020
# 	14:26:27 +0200 [_,not_SPF_mangled] From: Jochen+FRITZ-Box@Hayek.name;
# 		 FROM: "Jochen Hayek's FRITZ!Box 7590 @BER" <Jochen+FRITZ-Box@Hayek.name>;
# 		 TO: <Jochen+FRITZ-Box-Anrufe-4916090105555@Hayek.name>,;
# 		 SUBJECT: Call from 017639957540;
# 		 Folder: .topics-computers.admin/new/1587990387.30031_1.h20
#
# 19 Jul 2020
#         18:03:35 +0200 [_,not_SPF_mangled] From: Jochen+FRITZ-Box@Hayek.name;
#                  FROM: "Jochen Hayek's FRITZ!Box 7590 @BER" <Jochen+FRITZ-Box@Hayek.name>;
#                  TO: <Jochen+FB-Faxfunktion@Hayek.name>,;
#                  SUBJECT: Fax from 035323685979;
#                  Folder: .topics-computers.admin-avm/new/1595174616.30889_1.h20


  #- : \[?<tags>[^\]]*?\] \s+
  #? : \[(?<tags>[^\]]*?)\] \s+
  #+ : [^\]]*?
  #+ : \[_.SPF_mangled] \s+

  # sample:
  # TO ... // phone_number included
  # SUBJECT: Anruf von BZfG (03049300150);

  if( $param{rec} =~ m,

	         \[(?<tags>[^\]]*?)] \s+
		 From	: \s+ ([^;]+); \s+
		 FROM	: \s+ (?<callee_0>"[^"]*") \s+ <[^>]+>; \s+
		 TO  	: \s+ < (?<callee_1> Jochen \+ (FRITZ-Box-Anrufe|FRITZ-Box-Anrufbeantworter|FRITZ-Box-Faxfunktion|FB-Faxfunktion) - (?<phone_number>.*) \@Hayek\.name ) >\,; \s+
		 SUBJECT: \s+ (?<what>Call|Anruf|Fax|Nachricht) \s+ (from|von) \s+ (?<caller>[^;]+?) ( \s+ \( (?<caller_number>\d+) \) ) ; \s+
		 Folder : \s+ (?<Folder>\..*\/\S*)

    ,gix)
    {
      $param{rec} =~ s,

	         \[(?<tags>[^\]]*?)] \s+
		 From	: \s+ Jochen \+ FRITZ-Box.*\@Hayek\.name; \s+
		 FROM	: \s+ (?<callee_0>"[^"]*") \s+ <Jochen \+ FRITZ-Box.*\@Hayek\.name>; \s+
		 TO  	: \s+ < (?<callee_1> Jochen \+ (FRITZ-Box-Anrufe|FRITZ-Box-Anrufbeantworter|FRITZ-Box-Faxfunktion|FB-Faxfunktion) - (?<phone_number>.*)\@Hayek\.name ) >\,; \s+
		 SUBJECT: \s+ (?<what>Call|Anruf|Fax|Nachricht) \s+ (from|von) \s+ (?<caller>[^;]*?) ( \s+ \( (?<caller_number>\d+) \) )? ; \s+
		 Folder : \s+ (?<Folder>\..*\/\S*)

	,[$+{tags}\,telecom\,$fritz_box_messages{$+{what}}] From: "$+{caller}" <$+{caller_number}\@fon>; To: +$+{phone_number}; SUBJECT: Telefon-$+{what} …,gix;
    }

  # sample:
  # TO ... // phone_number included
  # SUBJECT: Call from 017634457540;

  elsif( $param{rec} =~ m,

	         \[(?<tags>[^\]]*?)] \s+
		 From	: \s+ ([^;]+); \s+
		 FROM	: \s+ (?<callee_0>"[^"]*") \s+ <[^>]+>; \s+
		 TO  	: \s+ < (?<callee_1> Jochen \+ (FRITZ-Box-Anrufe|FRITZ-Box-Anrufbeantworter|FRITZ-Box-Faxfunktion|FB-Faxfunktion) - (?<phone_number>.*) \@Hayek\.name ) >\,; \s+
		 SUBJECT: \s+ (?<what>Call|Anruf|Fax|Nachricht) \s+ (from|von) \s+ (?<caller_number>\d+) ; \s+
		 Folder : \s+ (?<Folder>\..*\/\S*)

    ,gix)
    {
      $param{rec} =~ s,

	         \[(?<tags>[^\]]*?)] \s+
		 From	: \s+ Jochen \+ FRITZ-Box.*\@Hayek\.name; \s+
		 FROM	: \s+ (?<callee_0>"[^"]*") \s+ <Jochen \+ FRITZ-Box.*\@Hayek\.name>; \s+
		 TO  	: \s+ < (?<callee_1> Jochen \+ (FRITZ-Box-Anrufe|FRITZ-Box-Anrufbeantworter|FRITZ-Box-Faxfunktion|FB-Faxfunktion) - (?<phone_number>.*)\@Hayek\.name ) >\,; \s+
		 SUBJECT: \s+ (?<what>Call|Anruf|Fax|Nachricht) \s+ (from|von) \s+ (?<caller_number>\d+) ; \s+
		 Folder : \s+ (?<Folder>\..*\/\S*)

	,[$+{tags}\,telecom\,$fritz_box_messages{$+{what}}] From: "___" <$+{caller_number}\@fon>; To: +$+{phone_number}; SUBJECT: Telefon-$+{what} …,gix;
    }

  # sample:
  # TO ... // phone_number *not* included
  # SUBJECT: Anruf von BZfG (03049300150);

  elsif( $param{rec} =~ m,

	         \[(?<tags>[^\]]*?)] \s+
		 From	: \s+ ([^;]+); \s+
		 FROM	: \s+ (?<callee_0>"[^"]*") \s+ <[^>]+>; \s+
		 TO  	: \s+ < (?<callee_1> Jochen \+ (FRITZ-Box-Anrufe|FRITZ-Box-Anrufbeantworter|FRITZ-Box-Faxfunktion|FB-Faxfunktion) (?<ignored_part>.*) \@Hayek\.name ) >\,; \s+
		 SUBJECT: \s+ (?<what>Call|Anruf|Fax|Nachricht) \s+ (from|von) \s+ (?<caller>[^;]+?) ( \s+ \( (?<caller_number>\d+) \) ) ; \s+
		 Folder : \s+ (?<Folder>\..*\/\S*)

    ,gix)
    {
      $param{rec} =~ s,

	         \[(?<tags>[^\]]*?)] \s+
		 From	: \s+ Jochen \+ FRITZ-Box.*\@Hayek\.name; \s+
		 FROM	: \s+ (?<callee_0>"[^"]*") \s+ <Jochen \+ FRITZ-Box.*\@Hayek\.name>; \s+
		 TO  	: \s+ < (?<callee_1> Jochen \+ (FRITZ-Box-Anrufe|FRITZ-Box-Anrufbeantworter|FRITZ-Box-Faxfunktion|FB-Faxfunktion) (?<ignored_part>.*) \@Hayek\.name ) >\,; \s+
		 SUBJECT: \s+ (?<what>Call|Anruf|Fax|Nachricht) \s+ (from|von) \s+ (?<caller>[^;]*?) ( \s+ \( (?<caller_number>\d+) \) )? ; \s+
		 Folder : \s+ (?<Folder>\..*\/\S*)

	,[$+{tags}\,telecom\,$fritz_box_messages{$+{what}}] From: "$+{caller}" <$+{caller_number}\@fon>; To: $+{callee_0} / $+{callee_1} / "$+{ignored_part}"; SUBJECT: Telefon-$+{what} …,gix;
    }

  # sample:
  # TO ... // phone_number *not* included
  # SUBJECT: Call from 017634457540;
  # SUBJECT: Call from Unknown;

  elsif( $param{rec} =~ m,

	         \[(?<tags>[^\]]*?)] \s+
		 From	: \s+ ([^;]+); \s+
		 FROM	: \s+ (?<callee_0>"[^"]*") \s+ <[^>]+>; \s+
		 TO  	: \s+ < (?<callee_1> Jochen \+ (FRITZ-Box-Anrufe|FRITZ-Box-Anrufbeantworter|FRITZ-Box-Faxfunktion|FB-Faxfunktion) (?<ignored_part>.*) \@Hayek\.name ) >\,; \s+
		 SUBJECT: \s+ (?<what>Call|Anruf|Fax|Nachricht) \s+ (from|von) \s+ (?<caller_number>\w+) ; \s+
		 Folder : \s+ (?<Folder>\..*\/\S*)

    ,gix)
    {
      $param{rec} =~ s,

	         \[(?<tags>[^\]]*?)] \s+
		 From	: \s+ Jochen \+ FRITZ-Box.*\@Hayek\.name; \s+
		 FROM	: \s+ (?<callee_0>"[^"]*") \s+ <Jochen \+ FRITZ-Box.*\@Hayek\.name>; \s+
		 TO  	: \s+ < (?<callee_1> Jochen \+ (FRITZ-Box-Anrufe|FRITZ-Box-Anrufbeantworter|FRITZ-Box-Faxfunktion|FB-Faxfunktion) (?<ignored_part>.*) \@Hayek\.name ) >\,; \s+
		 SUBJECT: \s+ (?<what>Call|Anruf|Fax|Nachricht) \s+ (from|von) \s+ (?<caller_number>\w+) ; \s+
		 Folder : \s+ (?<Folder>\..*\/\S*)

	,[$+{tags}\,telecom\,$fritz_box_messages{$+{what}}] From: "___" <$+{caller_number}\@fon>; To: $+{callee_0} / $+{callee_1} / "$+{ignored_part}"; SUBJECT: Telefon-$+{what} …,gix;
    }

  ################################################################################

#	09:43:26 +0100 [_,SPF_mangled,admin] From: Jochen+FRITZ-Box@Hayek.name;
#		FROM: "Jochen Hayek's FRITZ!Box 7590 @BER" <Jochen+FRITZ-Box@Hayek.name>
#		TO: <Jochen+FRITZ-Box-200-coffee@Hayek.name>,;
#		SUBJECT: 200/coffee wurde angeschaltet;
#		Folder: .topics.admin/new/1541493809.5328_1.mspool3;

  if( $param{rec} =~ m,

	         \[(?<tags>[^\]]*?)] \s+
		 From	: \s+ Jochen\+FRITZ-Box.*\@Hayek\.name; \s+
		 FROM	: \s+ (?<callee_0>"[^"]*") \s+ <Jochen\+FRITZ-Box.*\@Hayek\.name>; \s+
		 TO  	: \s+ < (?<callee_1> Jochen\+ (FRITZ-Box) - (?<device_no>.*) \@Hayek\.name ) >\,; \s+
		 SUBJECT: \s+ (?<what>[^;]*) ; \s+
		 Folder : \s+ (?<Folder>\.folder.*\/\S*)

    ,gix)
    {
      printf "// %s=>{%s}\n",
	'$+{what}' => $+{what} ,
	if 0;

      $param{rec} =~ s,

	         \[(?<tags>[^\]]*?)] \s+
		 From	: \s+ Jochen\+FRITZ-Box.*\@Hayek\.name; \s+
		 FROM	: \s+ (?<callee_0>"[^"]*") \s+ <Jochen\+FRITZ-Box.*\@Hayek\.name>; \s+
		 TO  	: \s+ < (?<callee_1> Jochen\+ (FRITZ-Box) - (?<device_no>.*) \@Hayek\.name ) >\,; \s+
		 SUBJECT: \s+ (?<what>[^;]*) ; \s+
		 Folder : \s+ (?<Folder>\.folder.*\/\S*)

	,[$+{tags}\,household] SUBJECT: $+{what},gix;
    }

  ################################################################################

  # SUBJECT: Synology DSM Alert: IP address [79.137.80.222] of DiskStation003 has been blocked by SSH;
  # SUBJECT: Synology DSM Alert: IP address [174.63.79.159] of DiskStation003 has been blocked by SSH;
  # SUBJECT: Synology DSM Alert: DSM update is ready to be installed on DiskStation003;

  if(
    $param{rec} =~ m{

                 \[(?<tags>[^\]]*?)] \s+
                 From   : \s+     (?<From> jochen\.hayek\@hayek\.b\.shuttle\.de )  ; \s+
                 FROM   : [^<]* < (?<FROM> jochen\.hayek\@hayek\.b\.shuttle\.de ) >; \s+
                 TO     : [^<]* < (?<TO>   jochen\.hayek\@hayek\.b\.shuttle\.de ) >; \s+
		 SUBJECT: \s*     (?<SUBJECT> Synology \s+ DSM \s+ Alert: \s+ [^;]* ); \s+
		 Folder: \s+ (?<Folder>\. (topics|topics-computers|topics-finance|.*) \.(?<subtopic>admin|.*)\/\S*)

      }gix
    ) 
    {
      warn "I am here"
	if 0;

      my(%plus) = %+;

      $param{rec} =~ s{

                 \[(?<tags>[^\]]*?)] \s+
                 From   : \s+     (?<From> jochen\.hayek\@hayek\.b\.shuttle\.de )  ; \s+
                 FROM   : [^<]* < (?<FROM> jochen\.hayek\@hayek\.b\.shuttle\.de ) >; \s+
                 TO     : [^<]* < (?<TO>   jochen\.hayek\@hayek\.b\.shuttle\.de ) >; \s+
		 SUBJECT: \s*     (?<SUBJECT> Synology \s+ DSM \s+ Alert: \s+ [^;]* ); \s+
		 Folder: \s+ (?<Folder>\. (topics|topics-computers|topics-finance|.*) \.(?<subtopic>admin|.*)\/\S*)

	}{[$plus{tags},Synology_DSM_Alert] $plus{SUBJECT}}gix;
    }

  if(
    $param{rec} =~ m{

                 \[(?<tags>[^\]]*?)] \s+
                 From   : \s+     (?<From> noreply\@synologynotification\.com                 )  ; \s+
                 FROM   : [^<]* < (?<FROM> noreply\@synologynotification\.com                 ) >; \s+
                 TO     : [^<]* < (?<TO>   jochen\+diskstation\d{3}-push-service\@hayek\.name ) >; \s+
                 SUBJECT: \s*     (?<SUBJECT> [^;]* ); \s+
		 Folder: \s+ (?<Folder>\. (topics|topics-computers|topics-finance|.*) \.(?<subtopic>admin|.*)\/\S*)

      }gix
    ) 
##		 SUBJECT: \s*     (?<SUBJECT> Synology \s+ DSM \s+ Alert: \s+ [^;]* ); \s+
    {
      warn "I am here"
	if 0;

      my(%plus) = %+;

      $param{rec} =~ s{

                 \[(?<tags>[^\]]*?)] \s+
                 From   : \s+     (?<From> noreply\@synologynotification\.com                 )  ; \s+
                 FROM   : [^<]* < (?<FROM> noreply\@synologynotification\.com                 ) >; \s+
                 TO     : [^<]* < (?<TO>   jochen\+diskstation\d{3}-push-service\@hayek\.name ) >; \s+
                 SUBJECT: \s*     (?<SUBJECT> [^;]* ); \s+
		 Folder: \s+ (?<Folder>\. (topics|topics-computers|topics-finance|.*) \.(?<subtopic>admin|.*)\/\S*)

	}{[$plus{tags},Synology] $plus{SUBJECT}}gix;
    }

  ################################################################################

  # gigaset-elements.com

##my($rewritten_gigaset_home) = exists( $gigaset_elements_homes{$+{SUBJECT_gigaset_home}} ) ? $gigaset_elements_homes{$+{SUBJECT_gigaset_home}} : "{{$+{SUBJECT_gigaset_home}}}";

  if(
    $param{rec} =~ m{

	         \[(?<tags>[^\]]*?)] \s+
	    	 From   : \s+ (?<From>info\@gigaset-elements\.com); \s+
		 FROM   : \s+ (?<FROM>info\@gigaset-elements\.com); \s+
		 TO     : \s+ (?<TO>jochenPLUS(gigaset-elements-001)\@hayek\.name); \s+
		 SUBJECT:     (?<SUBJECT> \s* (?<SUBJECT_gigaset_home>[^:]*) : \s* (?<SUBJECT_rem>[^;]*) ); \s+
		 Folder: \s+ (?<Folder>\. (topics|topics-computers|topics-finance|.*) \.(?<subtopic>admin|.*)\/\S*)

      }gix
    ) 
    {
      my($home) = exists( $gigaset_elements_homes{$+{SUBJECT_gigaset_home}} ) ? $gigaset_elements_homes{$+{SUBJECT_gigaset_home}} : "\$gigaset_elements_homes{$+{SUBJECT_gigaset_home}}";

      my(%plus) = %+;

      $plus{SUBJECT_rem} =~ y/ /_/;

      $param{rec} =~ s{

	         \[(?<tags>[^\]]*?)] \s+
	      	 From   : \s+ (?<From>info\@gigaset-elements\.com); \s+
		 FROM   : \s+ (?<FROM>info\@gigaset-elements\.com); \s+
		 TO     : \s+ (?<TO>jochenPLUS(gigaset-elements-001)\@hayek\.name); \s+
		 SUBJECT:     (?<SUBJECT> \s* (?<SUBJECT_gigaset_home>[^:]*) : \s* (?<SUBJECT_rem>[^;]*) ); \s+
		 Folder: \s+ (?<Folder>\. (topics|topics-computers|topics-finance|.*) \.(?<topic>subadmin|.*)\/\S*)

	}{[${home},$plus{SUBJECT_rem}]}gix;

      printf "// %s=>{$+{SUBJECT_gigaset_home}}\n",
	'$+{SUBJECT_gigaset_home}' => $+{SUBJECT_gigaset_home} ,
	if 0 && !exists($gigaset_elements_homes{$+{SUBJECT_gigaset_home}});
    }

  ##,\,$gigaset_elements_homes{$+{SUBJECT_gigaset_home}}] SUBJECT: $+{SUBJECT_rem},gix;

  ##,\,$+{SUBJECT_gigaset_home}] SUBJECT: $+{SUBJECT_rem},gix;

  ##,\,`$+{SUBJECT_gigaset_home} =~ tr/ /_/`] SUBJECT: $+{SUBJECT_rem},gix;

  ################################################################################

  # jewish-singles.de

#	13:04:17 +0200 [_,SPF_mangled,social_networking] From: support@jewish-singles.de;
#		FROM: "Jewish German Social Network"  <support@jewish-singles.de>
#		TO: <jochenPLUSjewish-singles@hayek.name>;
#		SUBJECT: You have a new visitor!;
#		Folder: .topics.social_networking/new/1540551858.24263_1.mspo;

#		SUBJECT: You have a new visitor!;
#		SUBJECT: You have a new friend!;
#		SUBJECT: You have a new mutual attraction!;
#		SUBJECT: You have a new message!;

  $param{rec} =~ s{

                 \] \s+
            	 From	  : \s+ (?<From>             support\@jewish-singles\.de ); \s+
                 FROM	  : \s+ (?<FROM>[^<]*       <support\@jewish-singles\.de>);? \s+
		 TO  	  : \s+ (?<TO>.*); \s+
		 SUBJECT:     (?<SUBJECT>.*?); \s+
		 Folder : \s+ (?<Folder>[^/]*\/\S*)

    }{,jewish-singles.de,ACCOUNT] Subject: $+{SUBJECT};}gix;

  ################################################################################

  # okcupid

  $param{rec} =~ s{

                 \] \s+
            	 From	  : \s+ (?<From>             bounces.*\@.*\.oknotify2\.com ); \s+
                 FROM	  : \s+ (?<FROM>[^<]*       <bounces.*\@.*\.oknotify2\.com>); \s+
		 TO  	  : \s+ (?<TO>.*); \s+
		 SUBJECT:     (?<SUBJECT>.* Jochen, \s+ (?<okcupid_account>.*) \s+ likes \s+ you \s+ back !); \s+
		 Folder : \s+ (?<Folder>[^/]*\/\S*)

    }{,OkCupid,$+{okcupid_account}] From: ___ AKA $+{okcupid_account}; Subject: she likes you back;}gix;

  $param{rec} =~ s{

                 \] \s+
            	 From	  : \s+ (?<From>             bounces.*\@.*\.oknotify2\.com ); \s+
                 FROM	  : \s+ (?<FROM>[^<]*       <bounces.*\@.*\.oknotify2\.com>); \s+
		 TO  	  : \s+ (?<TO>.*); \s+
		 SUBJECT:     (?<SUBJECT>.* new \s+ message \s+ from \s+ (?<okcupid_account>.*) ); \s+
		 Folder : \s+ (?<Folder>[^/]*\/\S*)

    }{,OkCupid,$+{okcupid_account}] From: ___ AKA $+{okcupid_account};}gix;

  ################################################################################

  # postbank.de

  $param{rec} =~ s{

	         \] \s+
	    	 From	  : \s+ (?<From>direkt\@postbank\.de); \s+
		 FROM	  : \s+ (?<FROM>direkt\@postbank\.de); \s+
		 TO  	  : \s+ (?<TO>.*); \s+
		 SUBJECT:     (?<SUBJECT>.*); \s+
		 Folder : \s+ (?<Folder>\. (topics|topics-computers|topics-finance) \.(?<topic>money)\/\S*)

    }{,banking] From: $+{From}; TO: $+{TO}; SUBJECT:$+{SUBJECT};}gix;

  $param{rec} =~ s{

	         \] \s+
	    	 From	  : \s+ (?<From>direkt\@postbank\.de); \s+
		 FROM	  : \s+ (?<FROM>direkt\@postbank\.de); \s+
		 TO  	  : \s+ (?<TO>.*); \s+
		 SUBJECT:     (?<SUBJECT>.*); \s+
		 Folder : \s+ (?<Folder>\.folder.*\/\S*)

    }{,banking] From: $+{From}; TO: $+{TO}; SUBJECT:$+{SUBJECT};}gix;

  ################################################################################

  # using topics.$+{topic} as tag

  $param{rec} =~ s{

	         \] \s+
	    	 From	  : \s+ (?<From>[^;]*); \s+
		 FROM	  : \s+ (?<FROM>[^;]*); \s+
		 TO  	  : \s+ (?<TO>.*); \s+
		 SUBJECT:     (?<SUBJECT>.*); \s+
		 Folder : \s+ (?<Folder>\. (topics|topics-computers|topics-finance) \.(?<topic>[^\/]*)\/\S*)

    }{,$+{topic}] From: $+{From};
\t\tFROM: $+{FROM};
\t\tTO: $+{TO};
\t\tSUBJECT:$+{SUBJECT};
\t\tFolder: $+{Folder};}gix;

  ################################################################################

  # using persons.$+{topic} as tag

  $param{rec} =~ s{

	         \] \s+
	    	 From	  : \s+ (?<From>[^;]*); \s+
		 FROM	  : \s+ (?<FROM>[^;]*); \s+
		 TO  	  : \s+ (?<TO>.*); \s+
		 SUBJECT:     (?<SUBJECT>.*); \s+
		 Folder : \s+ (?<Folder>\.persons\.(?<topic>[^\/]*)\/\S*)

    }{,$+{topic}] From: $+{From};
\t\tFROM: $+{FROM};
\t\tTO: $+{TO};
\t\tSUBJECT:$+{SUBJECT};
\t\tFolder: $+{Folder};}gix;

  ################################################################################
  
  print $param{rec};
}

sub SPF_bullshit__rewrite_addr
{
  my(%param) = @_;

  my($new_addr) = '';

  if($param{addr} =~ m/^ (\w+?) \+ (\w+?) = (\w+?) = (?<after>.*?) = (?<before>.*) @ (.*) $/x)
    {
      $new_addr = "$+{before}\@$+{after}";
    }
  else
    {
      $new_addr = $param{addr};
    }
  
  return $new_addr;
}
  
__END__
