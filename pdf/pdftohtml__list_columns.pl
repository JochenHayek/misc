#! /usr/bin/perl -w

{
  my(%table);

  while(<>)
    {
      chomp;

      # <text  top="0093" left="0245" width="0053" height="0011" font="0">Stamm-K.</text> 		<!-- ... -->

      if( 0 &&
	  m/

	     <text
	   /x
	)
	{
	  printf "%03.3d,%d: %s\n",__LINE__,$.,
	    $_,
	    ;
	}

      if(
	  m/

	     <text
	     \s+	top="(?<top>-?\d+)" 
	     \s+   left="(?<left>-?\d+)" 
	   /x
	)
	{
	  printf "%03.3d,%d: %s\n",__LINE__,$.,
	    $+{left},
	    if 0;

	  my(%plus) = %+;

	  printf "%s\n",
	    $plus{left},
	    if 0;

	  $plus{left} =~ s/^0*//;

	  printf "%-4d\n",
	    $plus{left},
	    if 0;
	  $table{ $plus{left} } = 1;
	}

      if( 0 &&
	  m/

	     <text
	     \s+	top="(?<top>-?\d+)" 
	     \s+   left="(?<left>-?\d+)" 
	     \s+  width="(?<width>-?\d+)" 
	     \s+ height="(?<height>-?\d+)" 

	     \s*

	     <\/text>
	     (?<remark>
	     \s*
	     <!-- .* -->
	     \s*
	     )?
	   /x
	)
	{
	  printf "%s\n",$+{left};
	}
    }

  foreach my $i ( sort {$a <=> $b} keys %table )
    {
      print $i,"\n"
	if 1;
      
    }
}
