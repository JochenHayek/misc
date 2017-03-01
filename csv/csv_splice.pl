#! /usr/bin/perl

# regression testing:
#
# -> ~/Computers/Programming/Languages/Perl/t/csv_reformat/

################################################################################

# gets applied on:
#
#   *--Lohn--Steuer_etc--period-*/Buchungsliste.txt
#   *--Lohn--Steuer_etc--period-*/LStAnmeldung.txt
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

      my(@F)              = split( $ENV{SEPARATOR} );

      shift(@F);

      my($resulting_line) =  join( $ENV{SEPARATOR} ,@F);

      print $resulting_line,"\n";
    }
}
