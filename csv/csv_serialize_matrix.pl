#! /usr/bin/perl -w

# usage as described in 
# /media/_ARCHIVE/home/Aleph_Soft_GmbH-FROZEN-STUFF/Buchhaltung/SKR03-1200/Belege/999999-000--2014__________--Lohn--Steuer_etc--period-2014mm.PLACEHOLDER.dir/HOWTO--monthly.IMPORTANT.txt
# to be applied on Lohnabrechnung.txt :
# $ ~/git-servers/github.com/JochenHayek/misc/csv/csv_transpose_2_rows_matrix.pl Lohnabrechnung.txt

# to be postprocessed preferrably with something like this:
# $ env SEPARATOR=';' ~/git-servers/github.com/JochenHayek/misc/csv/csv_reformat.pl

# together:
# $ ~/git-servers/github.com/JochenHayek/misc/csv/csv_transpose_2_rows_matrix.pl Lohnabrechnung.txt | env SEPARATOR=';' ~/git-servers/github.com/JochenHayek/misc/csv/csv_reformat.pl

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

      my(@F) = split( $ENV{SEPARATOR} );

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
