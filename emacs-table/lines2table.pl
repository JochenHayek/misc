#! /usr/bin/perl -w

# convert a couple of lines into a basic 1-column emacs table

# actually there is a builtin of the emacs tables feature,
# that already does the job, and even far more complete:

#   table-capture can be invoked from the menu: Tools → Table → Capture Region

#     (table-capture BEG END &optional COL-DELIM-REGEXP ROW-DELIM-REGEXP JUSTIFY MIN-CELL-WIDTH COLUMNS)

#     COL-DELIM-REGEXP : \|
#     ROW-DELIM-REGEXP : // use a quoted newline

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
