#! /usr/bin/perl -w

# rationale:
#
# there are CSV matrixes with far too many columns.
# serialise the matrix (colums 2..n),
# "prepending" the block# to each line / record !

# usage:
#
#   $ env SEPARATOR=';' ~/git-servers/github.com/JochenHayek/misc/csv/csv_serialize_matrix.pl ...
#
# example:
#
#   $ env SEPARATOR=';' ~/git-servers/github.com/JochenHayek/misc/csv/csv_serialize_matrix.pl Lohnabrechnung.txt
#
# sample input (within *--Lohn--Steuer_etc--period-*):
#
#   Lohnabrechnung.txt

# CAVEAT:
#
# -

################################################################################

# usage as described in 
#
#   vouchers--SKR03-1200/999999-000--2099__________--Lohn--Steuer_etc--period-2099mm.PLACEHOLDER.dir/HOWTO--monthly.IMPORTANT.txt

# to be postprocessed preferrably with something like this:
#
#   $ env SEPARATOR=';' ~/git-servers/github.com/JochenHayek/misc/csv/csv_reformat.pl

# together:
#
#   $ env SEPARATOR=';' ~/git-servers/github.com/JochenHayek/misc/csv/csv_serialize_matrix.pl Lohnabrechnung.txt | env SEPARATOR=';' ~/git-servers/github.com/JochenHayek/misc/csv/csv_reformat.pl /dev/stdin

################################################################################

use strict;
use warnings;

# http://Jochen.Hayek.name/wp/blog-en/category/csv/
# https://perlmaven.com/how-to-read-a-csv-file-using-perl
# https://metacpan.org/pod/Text::CSV

use Text::CSV;

{
  our($debug) = 0;

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
  
  my(@field_names);		# CAVEAT: this should get renamed
  my(@field_values);

##binmode(STDIN ,":encoding(utf8)");
##binmode(STDIN ,":crlf:encoding(utf8)");
  binmode(STDOUT,":encoding(utf8)");
  binmode(STDERR,":encoding(utf8)");

  my $csv = Text::CSV->new({ 
      binary => 1 , 
      auto_diag => 1 , 
      sep_char => $ENV{SEPARATOR} ,
    });
##$csv->eol ("\r\n");

  my $file = $ARGV[0] or die "Need to get CSV file on the command line\n";
##open(my $data, '<:encoding(utf8)', $file) or die "Could not open '$file' $!\n";
  open(my $data, '<:encoding(iso-8859-1)', $file) or die "Could not open '$file' $!\n";
##binmode($data ,":crlf:encoding(utf8)");

  my($max_length) = -1;

  while (my $fields = $csv->getline( $data )) 
    {
      my @F = @{$fields};

      push( @field_names  , shift @F);

      printf STDERR "=%03.3d: %s=>{%s},%s=>{%s},%s=>{%s} // %s\n",__LINE__,
	'$.' => $.,
        '$#F' => $#F,
	"\$field_names[ $#field_names ]" => $field_names[ $#field_names ],
	'...'
	if $::debug;

      $max_length = $#F
	if $#F > $max_length;

      push( @field_values , \@F );
    }

  if (not $csv->eof) 
    {
      $csv->error_diag();
    }
  close $data;

  printf STDERR "=%03.3d: %s=>{%s} // %s\n",__LINE__,
    '$#field_names' => $#field_names,
    '...'
    if $::debug;

  printf STDERR "=%03.3d: %s=>{%s} // %s\n",__LINE__,
    '$#{$field_values[0]}' => $#{$field_values[0]},
    '...'
    if $::debug;

  printf STDERR "=%03.3d: %s=>{%s} // %s\n",__LINE__,
    '$max_length' => $max_length,
    '...'
    if $::debug;

  for(my $j = 0;$j<=$max_length;$j++)
    {
      printf "\n",
	;
      for(my $i = 0;$i<=$#field_names;$i++)
	{
	  printf "%s$ENV{SEPARATOR}%s",
	    $j,
	    $field_names[$i],
	    ;
	  printf "$ENV{SEPARATOR}%s",
	    defined($field_values[$i][$j]) ? $field_values[$i][$j] : '',
	    ;
	  printf "\n",
	    ;
	}
    }
}
