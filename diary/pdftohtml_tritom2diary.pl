#! /usr/bin/perl

# print web page using ctrl-p and Destination "Save as PDF"

# input (pdftohtml) must be sorted.

# how to call this usitily:
#
#   $ ~/git-servers/github.com/JochenHayek/misc/diary/pdftohtml_tritom2diary.pl 202210.pdftohtml.xml > 202210.diary
#   $ ~/git-servers/github.com/JochenHayek/misc/diary/pdftohtml_tritom2diary.pl 202211.pdftohtml.xml > 202211.diary

{
  $::encountered_F7 = 0;
  $::date = '';
  %t = ();

  while(<>)
    {
      if(m/> (?<dd>\d\d) \. (?<mm>\d\d) \. (?<YYYY>\d\d\d\d) </x)
	{
	  if( ($::date ne '') && ($t{KO} ne '') )
	    {
	      print $::date,"\n";
	      printf "\t%s .. %s=%s=%s+%s=... // %s\n",
	        $t{KO} ne '' ? $t{KO} : 'HH:MM',
	        $t{GE} ne '' ? $t{GE} : 'HH:MM',
	        'HH:MM',
	        $t{abgerundete_Istzeit},
	        'HH:MM',

	        ##'F7' => $::encountered_F7,
	        $::encountered_F7 ? 'F7' : '',
	        ;
	      $::encountered_F7 = 0;
	      %t = ();
	      $::state = 'abgerundete_Istzeit';
	    }

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

	      if( ($::state eq 'KO') || ($::state eq 'GE') )
		{
		  $::state = 'abgerundete_Istzeit';
		}
	      elsif( $::state eq 'abgerundete_Istzeit' )
		{
		  $::state = '';
		}
	    }
	}
      elsif(m/> (?<w>F7) </x)
	{
	  $::encountered_F7 = 1;

	  printf STDERR "=%s,%d,%04.4d: %s=>{%s} // %s\n",__FILE__,__LINE__,$.,
	    '$+{w}' => $+{w},
	    '...'
	    if 0;
	}

      if($::state eq 'KO')
	{
	  ##printf "\t"
	}
    }
}
