#! /usr/bin/perl -w

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

  # fritz.box / Anruf von …

  $param{rec} =~ s,

		 From: \s+ Jochen\+FRITZ-Box-Absender\@Hayek\.name; \s+
		 FROM: \s+ (?<callee>"Jochen \s+ Hayek's \s+ FRITZ!Box \s+ 7490 \s+ \@BER") \s+ <Jochen\+FRITZ-Box-Absender\@Hayek\.name>; \s+
		 TO: \s+ <Jochen\+FRITZ-Box-Anrufe\@Hayek\.name>\,; \s+
		 SUBJECT: \s+ Anruf \s+ von \s+ (?<caller>[^;]*) ; \s+
		 Folder: \s+ \.folder-topics\.admin\/.*

    ,From: "$+{caller}"; To: $+{callee}; SUBJECT: Telefon-Anruf …,gix;

  # gigaset-elements.com

  $param{rec} =~ s,

	  \] \s+ From: \s+ (?<From>info\@gigaset-elements\.com); \s+
		 FROM: \s+         info\@gigaset-elements\.com ; \s+
		 TO: \s+ jochenPLUSgigaset-elements-001\@hayek\.name; \s+
		 SUBJECT: (?<SUBJECT> \s* (?<SUBJECT_home>[^:]*) : \s* (?<SUBJECT_rem>[^;]*) ); \s+
		 Folder: \s+ \.folder-topics\.admin\/.*

    ,\,$gigaset_elements_homes{$+{SUBJECT_home}}] SUBJECT: $+{SUBJECT_rem},gix;

  ##,\,$+{SUBJECT_home}] SUBJECT: $+{SUBJECT_rem},gix;

  ##,\,`$+{SUBJECT_home} =~ tr/ /_/`] SUBJECT: $+{SUBJECT_rem},gix;

  # postbank.de

  $param{rec} =~ s,

		From: \s+ (?<From>direkt\@postbank\.de); \s+
		FROM: \s+         direkt\@postbank\.de ; \s+
		TO: \s+ (?<TO>.*); \s+
		SUBJECT:(?<SUBJECT>.*); \s+
		Folder: \s+ \.folder-topics\.money\/.*

    ,From: $+{From}; TO: $+{TO}; SUBJECT:$+{SUBJECT};,gix;

  ################################################################################
  
  print $param{rec};
}
  
__END__
