#! /usr/bin/perl -w

# usage as described in 
# /media/_ARCHIVE/home/Aleph_Soft_GmbH-FROZEN-STUFF/Buchhaltung/SKR03-1200/Belege/999999-000--2014__________--Lohn--Steuer_etc--period-2014mm.PLACEHOLDER.dir/HOWTO--monthly.IMPORTANT.txt
# to be applied on Lohnabrechnung.txt :
# $ ~/Computers/Programming/Languages/Perl/csv_transpose_matrix.pl Lohnabrechnung.txt

# to be postprocessed preferrably with something like this:
# $ env SEPARATOR=';' ~/Computers/Programming/Languages/Perl/csv_reformat.pl

# together:
# $ ~/Computers/Programming/Languages/Perl/csv_transpose_matrix.pl Lohnabrechnung.txt | env SEPARATOR=';' ~/Computers/Programming/Languages/Perl/csv_reformat.pl

{
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
	  @field_names = split( $ENV{SEPARATOR} );
	}
      elsif($. > 1)
	{
	  @{$field_values[$.-2]} = split( $ENV{SEPARATOR} );

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
	  printf ";%s",
	    defined($field_values[$j][$i]) ? $field_values[$j][$i] : '',
	    ;
	}
      printf "\n",
        ;
    }
}
