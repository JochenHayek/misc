#! /usr/bin/perl -w

# one step after the other:

# $ fgrep -v 'empty {Date:} header field, so we are going to use From_captures to extract date+time'
# $ fgrep -iv 'will be removed, because'
# $ ~/Computers/Programming/Languages/Perl/diary.procmail-from.rewriting.pl

################################################################################

# all steps at once:

# $ fgrep -v 'empty {Date:} header field, so we are going to use From_captures to extract date+time' | fgrep -iv 'will be removed, because' | ~/Computers/Programming/Languages/Perl/diary.procmail-from.rewriting.pl

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

  # de.wikipedia.org

  # sample:
  #
  #   SUBJECT: Wikipedia-Seite Morris Wintschewski wurde von Nutzloses Wissen geändert;

  $param{rec} =~ s{

                 \] \s+
            	 From	  : \s+ (?<From>.*); \s+
                 FROM	  : \s+ (?<FROM>.*); \s+
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
                 FROM	  : \s+ (?<FROM>[^<]*        .* ); \s+
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

  #- : \[?<tags>[^\]]*?\] \s+
  #? : \[(?<tags>[^\]]*?)\] \s+
  #+ : [^\]]*?
  #+ : \[_.SPF_mangled] \s+

  if( $param{rec} =~ m,

	         \[(?<tags>[^\]]*?)] \s+
		 From	: \s+ Jochen\+FRITZ-Box.*\@Hayek\.name; \s+
		 FROM	: \s+ (?<callee_0>"[^"]*") \s+ <Jochen\+FRITZ-Box.*\@Hayek\.name>; \s+
		 TO  	: \s+ < (?<callee_1> Jochen\+ (FRITZ-Box-Anrufe|FRITZ-Box-Anrufbeantworter|FRITZ-Box-Faxfunktion) - (?<phone_number>.*) \@Hayek\.name ) >\,; \s+
		 SUBJECT: \s+ (?<what>Anruf|Fax|Nachricht) \s+ von \s+ (?<caller>[^;]*) ; \s+
		 Folder : \s+ (?<Folder>\.folder.*\/\S*)

    ,gix)
    {
      $param{rec} =~ s,

	         \[(?<tags>[^\]]*?)] \s+
		 From	: \s+ Jochen\+FRITZ-Box.*\@Hayek\.name; \s+
		 FROM	: \s+ (?<callee_0>"[^"]*") \s+ <Jochen\+FRITZ-Box.*\@Hayek\.name>; \s+
		 TO  	: \s+ < (?<callee_1> Jochen\+ (FRITZ-Box-Anrufe|FRITZ-Box-Anrufbeantworter|FRITZ-Box-Faxfunktion) - (?<phone_number>.*)\@Hayek\.name ) >\,; \s+
		 SUBJECT: \s+ (?<what>Anruf|Fax|Nachricht) \s+ von \s+ (?<caller>[^;]*) ; \s+
		 Folder : \s+ (?<Folder>\.folder.*\/\S*)

	,[$+{tags}\,telecom\,$fritz_box_messages{$+{what}}] From: "$+{caller}"; To: +$+{phone_number}; SUBJECT: Telefon-$+{what} …,gix;
    }
  else
    {
      $param{rec} =~ s,

	         \[(?<tags>[^\]]*?)] \s+
		 From	: \s+ Jochen\+FRITZ-Box.*\@Hayek\.name; \s+
		 FROM	: \s+ (?<callee_0>"[^"]*") \s+ <Jochen\+FRITZ-Box.*\@Hayek\.name>; \s+
		 TO  	: \s+ < (?<callee_1> Jochen\+ (FRITZ-Box-Anrufe|FRITZ-Box-Anrufbeantworter|FRITZ-Box-Faxfunktion) (.*) \@Hayek\.name ) >\,; \s+
		 SUBJECT: \s+ (?<what>Anruf|Fax|Nachricht) \s+ von \s+ (?<caller>[^;]*) ; \s+
		 Folder : \s+ (?<Folder>\.folder.*\/\S*)

	,[$+{tags}\,telecom\,$fritz_box_messages{$+{what}}] From: "$+{caller}"; To: $+{callee_0} / $+{callee_1}; SUBJECT: Telefon-$+{what} …,gix;
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
		 Folder : \s+ (?<Folder>\. (topics|\.topics-computers|\.topics-finance) \.(?<topic>[^\/]*)\/\S*)

    }{,$+{topic}] From: $+{From};
\t\tFROM: $+{FROM};
\t\tTO: $+{TO};
\t\tSUBJECT:$+{SUBJECT};
\t\tFolder: $+{Folder};}gix;

  ################################################################################

  # using fam.$+{topic} as tag

  $param{rec} =~ s{

	         \] \s+
	    	 From	  : \s+ (?<From>[^;]*); \s+
		 FROM	  : \s+ (?<FROM>[^;]*); \s+
		 TO  	  : \s+ (?<TO>.*); \s+
		 SUBJECT:     (?<SUBJECT>.*); \s+
		 Folder : \s+ (?<Folder>\.fam\.(?<topic>[^\/]*)\/\S*)

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
