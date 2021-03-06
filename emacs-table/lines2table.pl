#! /usr/bin/perl -w

# convert a couple of lines into a basic 1-column emacs table

{
  my(@lines);
  my($max_line_length) = -1;

  while(<>)
    {
      chomp;

      $max_line_length = length($_)
	if length($_) >= $max_line_length;

      push(@lines,$_);
    }

  printf "+-%-${max_line_length}s-+\n",'-' x ${max_line_length};

  foreach my $line (@lines)
    {
      printf "| %-${max_line_length}s |\n",$line;

      printf "+-%-${max_line_length}s-+\n",'-' x ${max_line_length};
    }
}
