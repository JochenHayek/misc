#! /usr/bin/perl -w

# usage:
#
#   $ env SEPARATOR=';' ~/git-servers/github.com/JochenHayek/misc/csv/csv_transpose_matrix.pl ...
#
# example:
#
#   $ ~/git-servers/github.com/JochenHayek/misc/csv/csv_transpose_matrix.pl Lohnabrechnung.txt
#
# sample input (within *--Lohn--Steuer_etc--period-*):
#
#   Lohnabrechnung.txt
#
# CAVEAT:
#
# yes, we should rather use a proper CSV module.
#
# steal code from csv_serialize_matrix.pl !

################################################################################

# usage as described in 
#
#   vouchers--SKR03-1200/999999-000--2099__________--Lohn--Steuer_etc--period-2099mm.PLACEHOLDER.dir/HOWTO--monthly.IMPORTANT.txt

# to be postprocessed preferrably with something like this:
#
#   $ env SEPARATOR=',' ~/git-servers/github.com/JochenHayek/misc/csv/csv_reformat.pl

# together:
#
#   $ ~/git-servers/github.com/JochenHayek/misc/csv/csv_transpose_matrix.pl Lohnabrechnung.txt | env SEPARATOR=';' ~/git-servers/github.com/JochenHayek/misc/csv/csv_reformat.pl

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

  binmode(STDOUT,":encoding(utf8)");
  binmode(STDERR,":encoding(utf8)");
  binmode(STDIN ,":crlf");

##local $/ = "\r\n";

  while(<>)
    {
      ##chomp;		# did not get it working
      s/\s+$//g;

      if   ($. == 1)
	{
	  @field_names = split( $ENV{SEPARATOR} );				# TBD: replace by a proper CSV module
	}
      elsif($. > 1)
	{
	  @{$field_values[$.-2]} = split( $ENV{SEPARATOR} );			# TBD: replace by a proper CSV module

	  while( $#{$field_values[$.-2]} >= 0 )
	    {
	      my($n) = $#{$field_values[$.-2]};

	      if(!defined($field_values[$.-2][$n]))
		 {
		  pop(@{$field_values[$.-2]});
		 }
	      elsif($field_values[$.-2][$n] =~ m/^\s*$/)
		{
		  pop(@{$field_values[$.-2]});
		}
	      else
		{
		  last;
		}
	    }

	  warn "\$field_values[$.-2][$n]=>{$field_values[$.-2][$n]}"
	    if $#field_names < $#{$field_values[$.-2]}
	    ;

	##die "\$#field_names=>$#field_names,\$#field_values=>$#field_values"
	  die "\$#field_names=>$#field_names,\$#{\$field_values[$.-2]}=>$#{$field_values[$.-2]}"
	    if $#field_names < $#{$field_values[$.-2]}
	    ;
	}
    }

  for(my $i = 0;$i<=$#field_names;$i++)
    {
      printf "%s",
        $field_names[$i],
        ;
      for(my $j = 0;$j<=$#field_values;$j++)
	{
	  printf "%s%s",
	    $ENV{SEPARATOR},
	    defined($field_values[$j][$i]) ? $field_values[$j][$i] : '',
	    ;
	}
      printf "\n",
        ;
    }
}
