#! /usr/bin/perl -w

# reads a line like this:
#
#   [[5. Buch Mose|Dewarim/Deuteronomium]] 1,1–3,22

{
  while(<>)
    {
      chomp;

      if( m/^ ( \[\[ ( (?<book_orig>.*) \| )? (?<book_repl>.*) \]\] | (?<book_repl>.*?) ) \s* (?<within_book>.*) $/x )
	{
	  my(%plus) = %+;

	  my($orig_within_book) = $plus{within_book};

	  $plus{within_book} =~ tr/,/:/; 
	  $plus{within_book} =~ s/–/-/g; 

	  my($url) = 
	    "https://www.tanach.us/Tanach.xml?" .
	    $plus{book_repl} .
	    $plus{within_book};

	  &print_ref( 'url' => $url , 'book_repl' => $plus{book_repl} , 'orig_within_book' => $orig_within_book , 'ref_name' => 'tanach.us-parascha' );
	  &print_ref( 'url' => $url , 'book_repl' => $plus{book_repl} , 'orig_within_book' => $orig_within_book , 'ref_name' => 'tanach.us-haftara' );
	  &print_ref( 'url' => $url , 'book_repl' => $plus{book_repl} , 'orig_within_book' => $orig_within_book , 'ref_name' => 'tanach.us-haftara-aschkenasim' );
	  &print_ref( 'url' => $url , 'book_repl' => $plus{book_repl} , 'orig_within_book' => $orig_within_book , 'ref_name' => 'tanach.us-haftara-sephardim' );
	}
    }
}

sub print_ref
{
  my($package,$filename,$line,$proc_name) = caller(0);

  my(%param) = @_;

  my($return_value) = 0;

  print <<EOF;
<ref name="$param{ref_name}">{{Internetquelle
| url=$param{url}
| titel=$param{book_repl} $param{orig_within_book}
| titelerg=nach dem [[Codex Leningradensis]]
| werk=tanach.us
| zugriff=2017-10-05
}}</ref>
EOF

  return $return_value;
}
