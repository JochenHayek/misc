#! /usr/bin/perl -w

{
  while(<>)
    {
      if(m/^From \s+ (?<from>.*) \s+/x)
	{
	  printf STDERR "=%03.3d,%05.5d: {%s}=>{%s} // %s\n",__LINE__,$.
	    ,'$+{from}',$+{from}
	    ,'...';
	}
    }
}
