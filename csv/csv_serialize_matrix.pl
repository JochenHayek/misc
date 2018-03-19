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

our($debug) = 0;

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

  my($max_length) = -1;

  while(<>)
    {
      ##chomp;		# did not get it working
      s/\s+$//g;

      my(@F) = split( $ENV{SEPARATOR} );		# TBD: replace by a proper CSV module

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
