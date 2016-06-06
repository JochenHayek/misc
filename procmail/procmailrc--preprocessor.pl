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

  my($e_mail_address_re) = $param{e_mail_address_re};

  my($return_path_re) = "* ^Return-Path: <${e_mail_address_re}>\$";

  printf "*** %s => %s\n",
    '$return_path_re' => $return_path_re,
    if 0;

  if(exists($param{target_folder__remote}))
    {
      print "\n:0\n";
      print "$return_path_re\n";
      print $param{target_folder__remote},"\n";
    }
  else
    {
      warn "\${e_mail_address_re}=>{${e_mail_address_re}} // !exists(\$param{target_folder__remote})";
    }

  printf STDERR "<%s,%d,%s\n",__FILE__,__LINE__,$proc_name
    if 0 && $main::options{debug};

  return $return_value;
}
