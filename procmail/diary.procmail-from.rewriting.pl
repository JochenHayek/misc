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
    ( 'Jochens Home'     =>  'Jochen_s_Home' ,
      'Gigaset elements' =>  'Gigaset_elements_Jochen_s_Home' ,
      'motion'           =>  'Gigaset_elements_Jochen_s_Home_motion' ,
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
		 Folder: \s+ (?<Folder>\. (folder-topics|.*) \.(?<subtopic>admin|.*)\/\S*)

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
                 SUBJECT: \s*     (?<SUBJECT> [^;]* ); \s+
		 Folder: \s+ (?<Folder>\. (folder-topics|.*) \.(?<subtopic>admin|.*)\/\S*)

	}{[$plus{tags},Synology] $plus{SUBJECT}}gix;
    }

  if(
    $param{rec} =~ m{

                 \[(?<tags>[^\]]*?)] \s+
                 From   : \s+     (?<From> noreply\@synologynotification\.com                 )  ; \s+
                 FROM   : [^<]* < (?<FROM> noreply\@synologynotification\.com                 ) >; \s+
                 TO     : [^<]* < (?<TO>   jochen\+diskstation\d{3}-push-service\@hayek\.name ) >; \s+
                 SUBJECT: \s*     (?<SUBJECT> [^;]* ); \s+
		 Folder: \s+ (?<Folder>\. (folder-topics|.*) \.(?<subtopic>admin|.*)\/\S*)

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
		 Folder: \s+ (?<Folder>\. (folder-topics|.*) \.(?<subtopic>admin|.*)\/\S*)

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
		 Folder: \s+ (?<Folder>\. (folder-topics|.*) \.(?<subtopic>admin|.*)\/\S*)

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
		 Folder: \s+ (?<Folder>\. (folder-topics|.*) \.(?<topic>subadmin|.*)\/\S*)

	}{[${home},$plus{SUBJECT_rem}]}gix;

      printf "// %s=>{$+{SUBJECT_gigaset_home}}\n",
	'$+{SUBJECT_gigaset_home}' => $+{SUBJECT_gigaset_home} ,
	if 0 && !exists($gigaset_elements_homes{$+{SUBJECT_gigaset_home}});
    }

  ##,\,$gigaset_elements_homes{$+{SUBJECT_gigaset_home}}] SUBJECT: $+{SUBJECT_rem},gix;

  ##,\,$+{SUBJECT_gigaset_home}] SUBJECT: $+{SUBJECT_rem},gix;

  ##,\,`$+{SUBJECT_gigaset_home} =~ tr/ /_/`] SUBJECT: $+{SUBJECT_rem},gix;

  ################################################################################

  # okcupid

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
		 Folder : \s+ (?<Folder>\.folder-topics\.(?<topic>money)\/\S*)

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

  # using folder-topics.$+{topic} as tag

  $param{rec} =~ s{

	         \] \s+
	    	 From	  : \s+ (?<From>[^;]*); \s+
		 FROM	  : \s+ (?<FROM>[^;]*); \s+
		 TO  	  : \s+ (?<TO>.*); \s+
		 SUBJECT:     (?<SUBJECT>.*); \s+
		 Folder : \s+ (?<Folder>\.folder-topics\.(?<topic>[^\/]*)\/\S*)

    }{,$+{topic}] From: $+{From};
\t\tFROM: $+{FROM}
\t\tTO: $+{TO};
\t\tSUBJECT:$+{SUBJECT};
\t\tFolder: $+{Folder};}gix;

  ################################################################################

  # using folders-fam.$+{topic} as tag

  $param{rec} =~ s{

	         \] \s+
	    	 From	  : \s+ (?<From>[^;]*); \s+
		 FROM	  : \s+ (?<FROM>[^;]*); \s+
		 TO  	  : \s+ (?<TO>.*); \s+
		 SUBJECT:     (?<SUBJECT>.*); \s+
		 Folder : \s+ (?<Folder>\.folders-fam\.(?<topic>[^\/]*)\/\S*)

    }{,$+{topic}] From: $+{From};
\t\tFROM: $+{FROM}
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
