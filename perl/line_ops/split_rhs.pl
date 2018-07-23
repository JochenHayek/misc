#! /usr/bin/perl -w

{
  our(@l);
  our($label);

  our($lhs) = "select ... from\t";

  our($rhs_left_quote ) = '';
  our($rhs_right_quote) = '';

  while(<>)
    {
      if( m/ ^ (?<prefix> \s+ ) (?<lhs>select \s+ \.\.\. \s from \s+) (?<rhs>.*) $/x )
	{
	  my(%plus) = %+;

	  printf "=%03.3d: %s=>{%s} // %s\n",__LINE__,
	    '$plus{rhs}' => $plus{rhs},
	    '...',
	    if 0;

	  my(@l) = split(/,\s*/,$plus{rhs});

	  printf "%s%s%s%s\%s\n",
	    ($#l == 0) ? '  ' : '//',		# !!!
	    $lhs,
	    $rhs_left_quote,
	    $plus{rhs},
	    $rhs_right_quote,
	    if 1;

	  if($#l == 0)
	    {
	      # in case there is nothing to be split,
	      # we leave the line "as is".

	      printf "%s%s%s%s\%s\n",
		($#l == 0) ? '  ' : '//',		# !!! prefix
		$lhs,
		$rhs_left_quote,
		$plus{rhs},
		$rhs_right_quote,
		if 0;
	    }
	  else
	    {
	      printf "%s%s%s%s\%s\n",
		'//',		# !!! prefix
		$lhs,
		$rhs_left_quote,
		$plus{rhs},
		$rhs_right_quote,
		if 0;

	      foreach my $e (@l)
		{
		  printf "=%03.3d: %s=>{%s} // %s\n",__LINE__,
		    '$e' => $e,
		    '...',
		    if 0;

		  printf "%s%s%s%s\%s\n",
		    '  ',		# !!! prefix
		    $lhs,
		    $rhs_left_quote,
		    $e,
		    $rhs_right_quote,

		}
	    }
	}
      else
	{
	  print;
	}
    }
}
