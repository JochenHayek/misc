#! /usr/bin/perl -w

# $ ~/git-servers/ber.jochen.hayek.name/johayek/banks/utilities/join_split_memo.pl
# $ ~/git-servers/github.com/JochenHayek/misc/pdf/pdftohtml__join.pl

{
  our(@l);
  our($prefix);

  while(<>)
    {

      # <text  top="0298" left="0160" width="0577" height="0019" font="7">Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</text>

    ##if( m/ " < (?<prefix>[^>]*) > " , " (?<value>.*) " /x )
      if( m,^ \s* (?<prefix> <text \s+ top="\d+" \s+ left="\d+" \s+ width="\d+" \s+ height="\d+" \s+ font="\d+"> ) (?<value>[^<]*) </text> $,x )
	{
	  $prefix = $+{prefix}
	    unless defined($prefix);
	  push(@l,$+{value});
	}
    }
}

END
  {
    print
      '    ',

      ${prefix},

      join('\n',@l),

      "</text>",
      ;
  }
