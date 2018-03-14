#! /usr/bin/perl

# usage:
#
#   $ env SEPARATOR=';' ~/git-servers/github.com/JochenHayek/misc/csv/csv_reformat.pl ...
#
# example:
#
#   $ env SEPARATOR=';' ~/git-servers/github.com/JochenHayek/misc/csv/csv_reformat.pl Buchungsliste.txt
#
# sample input (within *--Lohn--Steuer_etc--period-*):
#
#   Buchungsliste.txt
#
# regression testing:
#
#   -> ~/git-servers/github.com/JochenHayek/misc/csv/t/csv_reformat/

################################################################################

# regarding alignment see below!

{
  if(defined($ENV{SEPARATOR}))
    {
    }
  else
    {
      ##die '!defined($ENV{SEPARATOR})';
      $ENV{SEPARATOR} = ',';
    }

  if($ENV{SEPARATOR} eq '')
    {
      die "\$ENV{SEPARATOR}=>{$ENV{SEPARATOR}}";
    }
  
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
