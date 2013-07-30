#! /usr/bin/perl -w

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
	  @field_names = split(/;/);
	}
      elsif($. == 2)
	{
	  @field_values = split(/;/);
	}
      else
	{
	  die;
	}
    }

  die "\$#field_names=>$#field_names,\$#field_values=>$#field_values"
    if $#field_names != $#field_values;

  for(my $i = 0;$i<=$#field_names;$i++)
    {
      printf "%s;%s\n",
        $field_names[$i],
        $field_values[$i],
        ;
    }
}
