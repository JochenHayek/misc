#! /usr/bin/perl -w

# ...

{
  while(<>)
    {
      chomp;

      if( m/^ \[\[ (?<book_orig>.*) \| (?<book_repl>.*) \]\] \s* (?<within_book>.*) $/x )
	{
	  my(%plus) = %+;

	  my($orig_within_book) = $plus{within_book};

	  $plus{within_book} =~ tr/,/:/; 
	  $plus{within_book} =~ s/–/-/g; 

	  my($url) = 
	    "https://www.tanach.us/Tanach.xml?" .
	    $plus{book_repl} .
	    $plus{within_book};

	  print $url, "\n"
	    if 0;

	  print <<EOF
<ref name="tanach.us-parascha">{{Internetquelle
| url=$url
| titel=$plus{book_repl} $orig_within_book
| titelerg=nach dem [[Codex Leningradensis]]
| werk=tanach.us
| zugriff=2017-10-05
}}</ref>
EOF

	  print <<EOF
<ref name="tanach.us-haftara">{{Internetquelle
| url=$url
| titel=$plus{book_repl} $orig_within_book
| titelerg=nach dem [[Codex Leningradensis]]
| werk=tanach.us
| zugriff=2017-10-05
}}</ref>
EOF
	}
    }
}
