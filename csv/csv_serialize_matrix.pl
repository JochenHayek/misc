#! /usr/bin/perl -w

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

################################################################################

# usage as described in 
#
#   vouchers--SKR03-1200/999999-000--2099__________--Lohn--Steuer_etc--period-2099mm.PLACEHOLDER.dir/HOWTO--monthly.IMPORTANT.txt

# to be postprocessed preferrably with something like this:
#
#   $ env SEPARATOR=';' ~/git-servers/github.com/JochenHayek/misc/csv/csv_reformat.pl

# together:
#
#   $ env SEPARATOR=';' ~/git-servers/github.com/JochenHayek/misc/csv/csv_serialize_matrix.pl Lohnabrechnung.txt | env SEPARATOR=';' ~/git-servers/github.com/JochenHayek/misc/csv/csv_reformat.pl

################################################################################

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
  
  my(@field_names);
  my(@field_values);

##binmode(STDIN ,":encoding(utf8)");
  binmode(STDIN ,":crlf:encoding(utf8)");
  binmode(STDOUT,":encoding(utf8)");
  binmode(STDERR,":encoding(utf8)");

  while(<>)
    {
      ##chomp;		# did not get it working
      s/\s+$//g;

      my(@F) = split( $ENV{SEPARATOR} );		# TBD: replace by a proper CSV module

      push( @field_names  , shift @F);

      push( @field_values , \@F );
    }

  for(my $j = 0;$j<=$#{$field_values[0]};$j++)
##my $j = 0;
    {
      printf "\n",
	;
      for(my $i = 0;$i<=$#field_names;$i++)
	{
	  printf "%s;%s",
	    $j,
	    $field_names[$i],
	    ;
	  printf ";%s",
	    defined($field_values[$i][$j]) ? $field_values[$i][$j] : '',
	    ;
	  printf "\n",
	    ;
	}
    }
}
