#! /usr/bin/perl -w

# usage as described in 
# /media/_ARCHIVE/home/Aleph_Soft_GmbH-FROZEN-STUFF/Buchhaltung/SKR03-1200/Belege/999999-000--2014__________--Lohn--Steuer_etc--period-2014mm.PLACEHOLDER.dir/HOWTO--monthly.IMPORTANT.txt
# to be applied on Lohnabrechnung.txt :
# $ ~/Computers/Programming/Languages/Perl/csv_transpose_2_rows_matrix.pl Lohnabrechnung.txt

# to be postprocessed preferrably with something like this:
# $ env SEPARATOR=';' ~/Computers/Programming/Languages/Perl/csv_reformat.pl

# together:
# $ ~/Computers/Programming/Languages/Perl/csv_transpose_2_rows_matrix.pl Lohnabrechnung.txt | env SEPARATOR=';' ~/Computers/Programming/Languages/Perl/csv_reformat.pl

{
  my(@field_names);
  my(@field_values);

  binmode(STDOUT,":encoding(utf8)");
  binmode(STDERR,":encoding(utf8)");

  while(<>)
    {
      chomp;
      if   ($. == 1)
	{
	  @field_names = split( $ENV{SEPARATOR} );
	}
      elsif($. == 2)
	{
	  @field_values = split( $ENV{SEPARATOR} );
	}
      else
	{
	  die "\$.=>$. // but we only allow 2 columns"
	    if 0;
	}
    }

  die "\$#field_names=>$#field_names,\$#field_values=>$#field_values"
    if $#field_names >= $#field_values
    && 0			# we prefer to assume them as empty over dieing
    ;

  for(my $i = 0;$i<=$#field_names;$i++)
    {
      printf "%s;%s\n",
        $field_names[$i],
        defined($field_values[$i]) ? $field_values[$i] : '',
        ;
    }
}
