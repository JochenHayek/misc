#! /usr/bin/perl

# gets applied on:

# *--Lohn--Steuer_etc--period-*/Buchungsliste.txt

# env SEPARATOR=';' ~/Computers/Programming/Languages/Perl/csv_reformat.pl

{
  exists($ENV{SEPARATOR}) || die "!exists(\$ENV{SEPARATOR})";
  
  binmode( STDOUT , ":encoding(UTF-8)" );

  while(<>)
    {
      chomp;

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
	  printf "%$lengths[$i].$lengths[$i]s %s ",
	    $ref_line->[$i],
	    $ENV{SEPARATOR};

	}
      print "\n";
    }
}
