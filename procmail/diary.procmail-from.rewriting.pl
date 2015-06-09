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
    ( 'Jochens Home' =>  'Jochen_s_Home' ,
    );

  while(<>)
    {
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

  $param{rec} =~ s,

		 From	: \s+ Jochen\+FRITZ-Box-Absender\@Hayek\.name; \s+
		 FROM	: \s+ (?<callee>"Jochen \s+ Hayek's \s+ FRITZ!Box \s+ 7490 \s+ \@BER") \s+ <Jochen\+FRITZ-Box-Absender\@Hayek\.name>; \s+
		 TO  	: \s+ <Jochen\+(FRITZ-Box-Anrufe|FRITZ-Box-Anrufbeantworter|FRITZ-Box-Faxfunktion)\@Hayek\.name>\,; \s+
		 SUBJECT: \s+ (?<what>Anruf|Fax|Nachricht) \s+ von \s+ (?<caller>[^;]*) ; \s+
		 Folder : \s+ \.folder-topics\.(?<topic>admin)\/.*

    ,From: "$+{caller}"; To: $+{callee}; SUBJECT: Telefon-$+{what} …,gix;

  ################################################################################

  # gigaset-elements.com

##my($rewritten_gigaset_home) = exists( $gigaset_elements_homes{$+{SUBJECT_gigaset_home}} ) ? $gigaset_elements_homes{$+{SUBJECT_gigaset_home}} : "{{$+{SUBJECT_gigaset_home}}}";

  if(
    $param{rec} =~ s{

	    \[_\] \s+ From   : \s+ (?<From>info\@gigaset-elements\.com); \s+
		      FROM   : \s+ (?<FROM>info\@gigaset-elements\.com); \s+
		      TO     : \s+ (?<TO>jochenPLUS(gigaset-elements-001)\@hayek\.name); \s+
		      SUBJECT:     (?<SUBJECT> \s* (?<SUBJECT_gigaset_home>[^:]*) : \s* (?<SUBJECT_rem>[^;]*) ); \s+
		      Folder: \s+ \.folder-topics\.(?<topic>admin)\/.*

      }{[$gigaset_elements_homes{$+{SUBJECT_gigaset_home}}] $+{SUBJECT_rem}}gix
    ) 
    {
      printf "// %s=>{$+{SUBJECT_gigaset_home}}\n",
	'$+{SUBJECT_gigaset_home}' => $+{SUBJECT_gigaset_home} ,
	if !exists($gigaset_elements_homes{$+{SUBJECT_gigaset_home}});
    }

  ##,\,$gigaset_elements_homes{$+{SUBJECT_gigaset_home}}] SUBJECT: $+{SUBJECT_rem},gix;

  ##,\,$+{SUBJECT_gigaset_home}] SUBJECT: $+{SUBJECT_rem},gix;

  ##,\,`$+{SUBJECT_gigaset_home} =~ tr/ /_/`] SUBJECT: $+{SUBJECT_rem},gix;

  ################################################################################

  # okcupid

  $param{rec} =~ s{

            \] \s+ From	  : \s+ (?<From>             bounces\@mail1\.oknotify2\.com ); \s+
                   FROM	  : \s+ (?<FROM>OkCupid \s+ <bounces\@mail1\.oknotify2\.com>); \s+
		   TO  	  : \s+ (?<TO>.*); \s+
		   SUBJECT:     (?<SUBJECT>.*); \s+
		   Folder : \s+ \.folder-topics\.(?<topic>social_networking)\/.*

    }{,OkCupid] From: $+{From}; SUBJECT:$+{SUBJECT};}gix;

  ################################################################################

  # postbank.de

  $param{rec} =~ s{

	    \] \s+ From	  : \s+ (?<From>direkt\@postbank\.de); \s+
		   FROM	  : \s+ (?<FROM>direkt\@postbank\.de); \s+
		   TO  	  : \s+ (?<TO>.*); \s+
		   SUBJECT:     (?<SUBJECT>.*); \s+
		   Folder : \s+ \.folder-topics\.(?<topic>money)\/.*

    }{,banking] From: $+{From}; TO: $+{TO}; SUBJECT:$+{SUBJECT};}gix;

  ################################################################################
  
  print $param{rec};
}
  
__END__
