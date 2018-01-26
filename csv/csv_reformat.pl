#! /usr/bin/perl

# regression testing:
#
# -> ~/Computers/Programming/Languages/Perl/t/csv_reformat/

################################################################################

# gets applied on:
#
#   *--Lohn--Steuer_etc--period-*/Buchungsliste.txt
#
# like this:
#
#   env SEPARATOR=';' ~/Computers/Programming/Languages/Perl/csv_reformat.pl

################################################################################

# regarding alignment see below!

{
  exists($ENV{SEPARATOR}) || die "!exists(\$ENV{SEPARATOR})";
  
  # do these two conflict / overlap?
  binmode( ARGV   , ":encoding(UTF-8)" );
##binmode( STDIN  , ":encoding(UTF-8)" );
  binmode( STDIN  , ":crlf:encoding(UTF-8)" );

  binmode( STDOUT , ":crlf:encoding(UTF-8)" );

  while(<>)
    {
      ##chomp;		# did not get it working
      s/\s+$//g;

      my(@F) = split( $ENV{SEPARATOR} );

      push( @lines , \@F );
    }

  my(@lengths);

  foreach my $ref_line (@lines)
    {
      my($i);
      for( $i=0 ; $i<=$#{$ref_line} ; $i++ )
	{
	  $lengths[$i] = length($ref_line->[$i])
	    if length($ref_line->[$i]) > $lengths[$i];
	}
    }

  foreach my $ref_line (@lines)
    {
      my($i);
      for( $i=0 ; $i<=$#{$ref_line} ; $i++ )
	{
	  # the strings get right-aligned,
	  # which is optically good for amonts of money,
	  # but otherwise it's not optimal though good enough for the time being.

	  printf "%$lengths[$i].$lengths[$i]s %s ",
	    $ref_line->[$i],
	    $ENV{SEPARATOR};

	}
      print "\n";
    }
}
