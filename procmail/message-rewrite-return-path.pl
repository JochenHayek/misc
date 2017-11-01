#! /usr/bin/perl -w

# * to be run on an entire message
# * rewriting only the "Return-Path:" header field
# * passing through unchanged everything else

# www.openSPF.org/SRS

# examples:
#
#   Return-Path: <SRS0+HTcn=R5=mail.neweredm.com=Return.EID2c252534.Job@udag.de>
#
#   Return-Path: <SRS0+m+zo=SA=stb-henseling.de=Carmen.Mayer@udag.de>

{

  while(<>)
    {

      if(m/^ Return-Path: \s+ < (?<addr>.*) > \r $/x)
	{
	  my($addr) = $+{addr};

	  if($addr =~ m/^ 
                        (?<SRS>SRS\d+) 
                        \+

                        ( (?<previous_forwarders>.*) 
                        = )?

                        (?<hash>[^=]*) 
                        =
                        (?<timestamp>..)
                        =
                        (?<after>.*?)
                        =
                        (?<before>.*)
                        @
                        (?<current_forwarder>.*) 
                        $/x)
	    {
	      my($previous_forwarders) = exists($+{previous_forwarders}) ? $+{previous_forwarders} : '';

	      printf STDERR "=%03.3d: %s=>{%s},%s=>{%s},%s=>{%s},%s=>{%s},%s=>{%s} // %s\n",__LINE__,
	      'SRS'                 => $+{SRS},
	      'previous_forwarders' => $previous_forwarders,
	      'hash'       	    => $+{hash},
	      'timestamp'  	    => $+{timestamp},
	      'current_forwarder'   => $+{current_forwarder},
	      '...'
	      if 0;

	      print "Return-Path: <$+{before}\@$+{after}>\r\n";
	    }
	  else			# no SRS-(un)mangling
	    {
	      print;
	    }
	}
      else			# not matching Return-Path:
	{
	  print;
	}
    }
}
