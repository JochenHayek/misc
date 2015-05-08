#! /usr/bin/perl -w

{
  my($rec) = '';

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

  $param{rec} =~ s,

	       From: \s+ (?<From>info\@gigaset-elements.com); \s+
	       FROM: \s+         info\@gigaset-elements.com ; \s+
	       TO: \s+ jochenPLUSgigaset-elements-001\@hayek.name; \s+
	       SUBJECT:(?<SUBJECT>.*); \s+
	       Folder: \s+ \.folder-topics\.admin/.*

    ,From: $+{From}; SUBJECT:$+{SUBJECT},gix;

  $param{rec} =~ s,

		From: \s+ (?<From>direkt\@postbank.de); \s+
		FROM: \s+         direkt\@postbank.de ; \s+
		TO: \s+ (?<TO>.*); \s+
		SUBJECT:(?<SUBJECT>.*); \s+
		Folder: \s+ \.folder-topics\.money/.*

    ,From: $+{From}; TO: $+{TO}; SUBJECT:$+{SUBJECT};,gix;
  
  print $param{rec};
}
  
__END__
