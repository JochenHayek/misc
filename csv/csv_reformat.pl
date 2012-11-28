#! /usr/bin/perl

# gets applied on:
# *--Lohn--Steuer_etc--period-*/Buchungsliste.txt

{
  my($sep_as_re) = qr(;);
  my($sep) = ';';

  while(<>)
    {
      chomp;

      my(@F) = split( $sep_as_re );

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
	    $sep;

	}
      print "\n";
    }
}
