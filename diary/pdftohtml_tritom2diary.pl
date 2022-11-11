#! /usr/bin/perl

{
  while(<>)
    {
      if(m/^ (?<dd>\d\d) \. (?<mm>\d\d) \. (?<YYYY>\d\d\d\d) \. $/x)
	{
	  printf "%02.2d %02.2d %04.4d\n"
	    $+{dd},
	    $+{mm},
	    $+{YYYY},
	    ;
	}
    }
}
