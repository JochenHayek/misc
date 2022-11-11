#! /usr/bin/perl

{
  while(<>)
    {
      if(m/> (?<dd>\d\d) \. (?<mm>\d\d) \. (?<YYYY>\d\d\d\d) </x)
	{
	  $::date = 
	      sprintf "%02.2d %02.2d %04.4d",
		$+{dd},
		$+{mm},
		$+{YYYY},
		;

	  printf "%02.2d %02.2d %04.4d\n",
	    $+{dd},
	    $+{mm},
	    $+{YYYY},
	    if 0;

	  next;
	}
      elsif(m/> (?<w>KO|GE) </x)
	{
	  $::state = $+{w};

	  printf STDERR "=%s,%d: %s=>{%s} // %s\n",__FILE__,__LINE__,
	    '$::state' => $::state,
	    '...'
	    if 0;

	  next;
	}
      elsif(m/> (?<time> (?<hours>\d?\d) : (?<MM>\d\d) ) </x)
	{
	  my(%plus) = %+;
	  if($+{hours} =~ m/^\d$/)
	    {
	      $::time = '0' . $plus{hours} . ':' . $plus{MM};
	    }
	  else
	    {
	      $::time = $+{time};
	    }

	  printf STDERR "=%s,%d: %s=>{%s} // %s\n",__FILE__,__LINE__,
	    '$::time' => $::time,
	    '...'
	    if 0;
	  
	  if( ($::state eq 'KO') || ($::state eq 'GE')  || ($::state eq 'abgerundete_Istzeit') )
	    {
	      $t{$::state} = $::time;

	      printf STDERR "=%s,%d: %s=>{%s} // %s\n",__FILE__,__LINE__,
		"\$t{$::state}" => $t{$::state},
		'...'
		if 0;
	    }
	  
	  if( $::state eq 'GE' )
	    {
	      $::state = 'abgerundete_Istzeit';

	      if(0)
		{
		  print $::date,"\n";
		  printf "\t%s .. %s=...\n",
		    $t{KO},
		    $t{GE},
		    ;
		}
	    }
	  elsif( $::state eq 'abgerundete_Istzeit' )
	    {
	      $::state = '';
	      $t{$::state} = $::time;

	      print $::date,"\n";
	      printf "\t%s .. %s=%s=...\n",
	        $t{KO},
	        $t{GE},
	        $t{abgerundete_Istzeit},
	        ;
	    }
	}

      if($::state eq 'KO')
	{
	  ##printf "\t"
	}
    }
}
