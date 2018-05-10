#! /usr/bin/perl

# usage:
#
#   $ env SEPARATOR=';' ~/git-servers/github.com/JochenHayek/misc/csv/csv_reformat.pl
#
# example:
#
#   $ env SEPARATOR=';' ~/git-servers/github.com/JochenHayek/misc/csv/csv_reformat.pl Buchungsliste.txt
#   $ env SEPARATOR=';' ~/git-servers/github.com/JochenHayek/misc/csv/csv_reformat.pl LStAnmeldung.txt
#
# sample input (within *--Lohn--Steuer_etc--period-*):
#
#   Buchungsliste.txt
#   LStAnmeldung.txt
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
  binmode( ARGV   , ":encoding(UTF-8)" );		# not naming ":crlf" here may cause problems
##binmode( STDIN  , ":encoding(UTF-8)" );
  binmode( STDIN  , ":crlf:encoding(UTF-8)" );

  binmode( STDOUT , ":crlf:encoding(UTF-8)" );

  while(<>)
    {
      ##chomp;		# did not get it working
      s/\s+$//g;

      my(@F) = split( $ENV{SEPARATOR} );		# TBD: replace by a proper CSV module

      splice( @F , $ENV{OFFSET} , $ENV{LENGTH} );

      my($resulting_line) =   join( $ENV{SEPARATOR} ,@F);

      print $resulting_line,"\n";
    }
}
