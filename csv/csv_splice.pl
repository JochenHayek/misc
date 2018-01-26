#! /usr/bin/perl

# regression testing:
#
# -> ~/git-servers/github.com/JochenHayek/misc/csv/t/csv_reformat/

################################################################################

# gets applied on:
#
#   *--Lohn--Steuer_etc--period-*/Buchungsliste.txt
#   *--Lohn--Steuer_etc--period-*/LStAnmeldung.txt
#
# like this:
#
#   env SEPARATOR=';' ~/git-servers/github.com/JochenHayek/misc/csv/csv_reformat.pl

################################################################################

# regarding alignment see below!

{
  exists($ENV{SEPARATOR}) || die "!exists(\$ENV{SEPARATOR})";
  
  # do these two conflict / overlap?
  binmode( ARGV   , ":encoding(UTF-8)" );		# not naming ":crlf" here may cause problems
##binmode( STDIN  , ":encoding(UTF-8)" );
  binmode( STDIN  , ":crlf:encoding(UTF-8)" );

  binmode( STDOUT , ":crlf:encoding(UTF-8)" );

  while(<>)
    {
      ##chomp;		# did not get it working
      s/\s+$//g;

      my(@F)              = split( $ENV{SEPARATOR} );

      splice( @F , $ENV{OFFSET} , $ENV{LENGTH} );

      my($resulting_line) =   join( $ENV{SEPARATOR} ,@F);

      print $resulting_line,"\n";
    }
}
