#! /usr/bin/perl -w


{
  my(@macro_lines) = ();

  while(<>)
    {
      if(m/^##shuttle: *(.*)$/)
	{
	  print $1,"\n";
	}
      elsif(m/^##shuttle-macro-begin$/)
	{
	  print '# orig: ',$_
	    if 0;

	  @macro_lines = ();
	}
      elsif(m/^##shuttle-macro-end$/)
	{
	  print '# orig: ',$_
	    if 0;

	  # what do do with @macro_lines?

	  if(0)
	    {
	      for my $l (@macro_lines)
		{
		  print '# the macro line {',$l,"}\n";
		}
	    }

	  my($macro) = join("\n",@macro_lines);

	  eval($macro);
	  die "\$@=>{$@} // ???" if $@;
	}
      elsif(m/^##shuttle-macro: ?(.*)$/)
	{
	  print '# orig: ',$_
	    if 0;

	  push(@macro_lines,$1);
	}
      else
	{
	}
    }
}
#
sub m0
{
  my($package,$filename,$line,$proc_name) = caller(0);

  my(%param) = @_;

  my($return_value) = 0;

  printf STDERR ">%s,%d,%s\n",__FILE__,__LINE__,$proc_name
    if 0 && $main::options{debug};

  print "\n:0\n";

  my($h) = $param{'Return-Path'};

  my($prefix) = '* ^Return-Path: ';

  $h =~ s/^ \^ (?<remainder>) /${prefix}$+{remainder}/x;

  printf "*** %s => %s\n",
    '$h' => $h,
    if 0;

  print $h,"\n";

  if(exists($param{target_folder__remote}))
    {
      print $param{target_folder__remote},"\n";
    }
  else
    {
      warn "\$param{'Return-Path'}=>{$param{'Return-Path'}} // !exists(\$param{target_folder__remote})";
    }

  printf STDERR "<%s,%d,%s\n",__FILE__,__LINE__,$proc_name
    if 0 && $main::options{debug};

  return $return_value;
}
