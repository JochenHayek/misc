#! /usr/bin/perl -w


our($creating_remote_procmailrc_p) = 1;
our($creating_local_procmailrc_p)  = 0;

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

  # comment
  # e_mail_address_raw
  # e_mail_address_re
  # target_folder__remote
  # target_folder__local

  my($return_value) = 0;

  printf STDERR ">%s,%d,%s\n",__FILE__,__LINE__,$proc_name
    if 0 && $main::options{debug};

  my($return_path_re) = '';

  if(exists($param{e_mail_address_raw}))
    {
      my($e_mail_address_re) = $param{e_mail_address_raw};

      $e_mail_address_re =~ s/ ([\.\+]) /\\$1/gx;

      $return_path_re = '* ^Return-Path: <' . ${e_mail_address_re}      . '>$';
    }
  elsif(exists($param{e_mail_address_re}))
    {
      $return_path_re = '* ^Return-Path: <' . $param{e_mail_address_re} . '>$';
    }
  else
    {
      die "... // !exists(\$param{e_mail_address_raw}) && !exists(\$param{e_mail_address_re})";
    }

  printf "*** %s => %s\n",
    '$return_path_re' => $return_path_re,
    if 0;

  if   ($creating_remote_procmailrc_p && exists($param{target_folder__remote}))
    {

      &bla( e_mail_address_re => $return_path_re , target_folder => $param{target_folder__remote} );

    }
  elsif($creating_local_procmailrc_p && exists($param{target_folder__local}))
    {

      &bla( e_mail_address_re => $return_path_re , target_folder => $param{target_folder__local} );

    }

  printf STDERR "<%s,%d,%s\n",__FILE__,__LINE__,$proc_name
    if 0 && $main::options{debug};

  return $return_value;
}
#
sub bla
{
  my($package,$filename,$line,$proc_name) = caller(0);

  my(%param) = @_;

  # e_mail_address_re
  # target_folder

  my($return_value) = 0;

  printf STDERR ">%s,%d,%s\n",__FILE__,__LINE__,$proc_name
    if 0 && $main::options{debug};

  print "\n"; 
  print ":0\n"; 
  print $param{e_mail_address_re},"\n";
  print $param{target_folder},"\n";

  printf STDERR "<%s,%d,%s\n",__FILE__,__LINE__,$proc_name
    if 0 && $main::options{debug};

  return $return_value;
}
