#! /usr/bin/perl

# print web page using ctrl-p and Destination "Save as PDF"

# input (pdftohtml) must be sorted.

# how to call this usitily:
#
#   $ cd ~/git-servers/github.com/JochenHayek/misc/diary/pdftohtml_tritom2diary.t/
#   $ ~/git-servers/github.com/JochenHayek/misc/diary/pdftohtml_tritom2diary.pl 202210.pdftohtml.xml > 202210.diary
#   $ ~/git-servers/github.com/JochenHayek/misc/diary/pdftohtml_tritom2diary.pl 202211.pdftohtml.xml > 202211.diary

{
  $::date = '';
  %::t = ( 'KO' => 'HH:MM' , 'GE' => 'HH:MM' , 'abgerundete_Istzeit' => 'HH:MM' , 'encountered_F7' => 0 , 'encountered_Abwesenheit' => 0 );
  $::state = 'abgerundete_Istzeit';

  %month_dd2mon =
    ( '01' => 'Jan' ,
      '02' => 'Feb' ,
      '03' => 'Mar' ,
      '04' => 'Apr' ,
      '05' => 'May' ,
      '06' => 'Jun' ,
      '07' => 'Jul' ,
      '08' => 'Aug' ,
      '09' => 'Sep' ,
      '10' => 'Oct' ,
      '11' => 'Nov' ,
      '12' => 'Dec' ,
    );

  while(<>)
    {
      if(m/> (?<dd>\d\d) \. (?<mm>\d\d) \. (?<YYYY>\d\d\d\d) </x)
	{
	  &proc_print;

	  $::date = 
	      sprintf "%02.2d %s %04.4d",
		$+{dd},
		$month_dd2mon{ $+{mm} },
		$+{YYYY},
		;

	  next;
	}
      elsif(m/> (?<w>KO|GE|PA|PE) </x)
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
	      $::time = "0$plus{hours}:$plus{MM}";
	    }
	  else
	    {
	      $::time = $+{time};
	    }
	  printf STDERR "=%s,%d: %s=>{%s} // %s\n",__FILE__,__LINE__,
	    '$::time' => $::time,
	    '...'
	    if 0;
	  
	  if( ($::state eq 'KO') || ($::state eq 'GE') || ($::state =~ m/^KO|GE|PA|PE$/) || ($::state eq 'abgerundete_Istzeit') )
	    {
	      $::t{$::state} = $::time;

	      printf STDERR "=%s,%d: %s=>{%s},%s=>{%s} // %s\n",__FILE__,__LINE__,
		'$::date' => $::date,
		"\$::t{$::state}" => $::t{$::state},
		'...'
		if 0;

	      printf STDERR "=%s,%d: %s=>{%s} // %s\n",__FILE__,__LINE__,
		'$::state' => $::state,
		'...'
		if 0;
	      if($::state =~ m/^KO|GE|PA|PE$/)
		{
		  $::state = 'abgerundete_Istzeit';
		}
	      elsif( $::state eq 'abgerundete_Istzeit' )
		{
		  $::state = '';
		}
	      printf STDERR "=%s,%d: %s=>{%s} // %s\n",__FILE__,__LINE__,
		'$::state' => $::state,
		'...'
		if 0;
	    }
	}
      elsif(m/> (?<w>F7) </x)
	{
	  $::t{encountered_F7} = 1;

	  printf STDERR "=%s,%d,%04.4d: %s=>{%s} // %s\n",__FILE__,__LINE__,$.,
	    '$+{w}' => $+{w},
	    '...'
	    if 0;
	}
      elsif(m/> (?<w>(U|K|KA|KR|GF)) </x)			# Urlaub / Krank / Krank… / KR=krank am Wochenende / gleitzeitfrei
	{
	  $::t{encountered_Abwesenheit} = $+{w};

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

  &proc_print;
}
#
sub proc_print
{
  my($package,$filename,$line,$proc_name) = caller(0);

  my(%param) = @_;

  $return_value = 0;

  printf STDERR ">%s,%d,%s\n",__FILE__,__LINE__,$proc_name
    if 0 && $main::options{debug};

  if($::date ne '')
    {
      print $::date,"\n";
      printf "\t%s .. %s=%s=%s+%s--S:999:99(999) [work\@KVBB,%s] // %s\n",
	$::t{KO} ne '' ? $::t{KO} : 'HH:MM',
	$::t{GE} ne '' ? $::t{GE} : 'HH:MM',
	'HH:MM',
	$::t{abgerundete_Istzeit},
	'HH:MM',

	$::t{encountered_Abwesenheit}  ? $::t{encountered_Abwesenheit}  : 'onsite',

	$::t{encountered_F7} ? 'F7' : '',
	;
      %::t = ( 'KO' => 'HH:MM' , 'GE' => 'HH:MM' , 'abgerundete_Istzeit' => 'HH:MM' , 'encountered_F7' => 0 , 'encountered_Abwesenheit' => 0 );
      $::state = 'abgerundete_Istzeit';
    }

  printf STDERR "<%s,%d,%s: %s=>%d\n",__FILE__,__LINE__,$proc_name
    ,'$return_value',$return_value
    if 0 && $main::options{debug};

  return $return_value;
}
