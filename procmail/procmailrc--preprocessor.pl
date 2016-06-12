#! /usr/bin/perl -w

our($debug) = 0;

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
	  warn "matching macro-begin"
	    if $debug;

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
  # e_mail_address_list_raw
  # e_mail_address_single_raw
  # e_mail_address_single_AT_re
  # e_mail_address_misc_re
  # target_folder__remote
  # target_folder__local

  my($return_value) = 0;

  printf STDERR ">%s,%d,%s\n",__FILE__,__LINE__,$proc_name
    if 0 && $main::options{debug};

  my(@list_of_return_path_core_re);
  my(@list_SPFified_of_return_path_core_re);

  if(exists($param{e_mail_address_list_raw}))
    {
      foreach my $e (@{ $param{e_mail_address_list_raw} })
	{
	  my($h1) = $e;

	  $h1 =~ s/ ([\.\+]) /\\$1/gx;

	  push( @list_of_return_path_core_re , $h1 );

	  if($e =~ m/^ (?<before>.*) \@ (?<after>.*) $/x)
	    {
	      my($h0) = "$+{after}=$+{before}";

	      $h0 =~ s/ ([\.\+]) /\\$1/gx;

	      push( @list_SPFified_of_return_path_core_re ,     ${h0}      );
	    }
	}
    }
  elsif(exists($param{e_mail_address_single_raw}))
    {
      my($h1) = $param{e_mail_address_single_raw};

      $h1 =~ s/ ([\.\+]) /\\$1/gx;

      push( @list_of_return_path_core_re , $h1 );

      if($param{e_mail_address_single_raw} =~ m/^ (?<before>.*) \@ (?<after>.*) $/x)
	{
	  my($h0) = "$+{after}=$+{before}";

	  $h0 =~ s/ ([\.\+]) /\\$1/gx;

	  push( @list_SPFified_of_return_path_core_re ,     ${h0}      );
	}
    }
  elsif(exists($param{e_mail_address_single_AT_re}))
    {
      push( @list_of_return_path_core_re , $param{e_mail_address_single_AT_re} );

      if($param{e_mail_address_single_AT_re} =~ m/^ (?<before>.*) \@ (?<after>.*) $/x)
	{
	  my($h0) = "$+{after}=$+{before}";

	  push( @list_SPFified_of_return_path_core_re ,     ${h0}      );
	}
    }
  elsif(exists($param{e_mail_address_misc_re}))
    {
      push( @list_of_return_path_core_re , $param{e_mail_address_misc_re} );
    }
  elsif(0)
    {
      warn "...,\$param{target_folder__remote}=>{$param{target_folder__remote}} // !exists(\$param{e_mail_address_single_raw}) && !exists(\$param{e_mail_address_misc_re})"
	if exists($param{target_folder__remote});

      warn "...,\$param{target_folder__local}=>{$param{target_folder__local}} // !exists(\$param{e_mail_address_single_raw}) && !exists(\$param{e_mail_address_misc_re})"
	if exists($param{target_folder__local});

      warn "... // !exists(\$param{e_mail_address_single_raw}) && !exists(\$param{e_mail_address_misc_re})"
	if !exists($param{target_folder__remote}) && !exists($param{target_folder__local});

      return $return_value;
    }

  if   ($creating_remote_procmailrc_p && exists($param{target_folder__remote}))
    {
      if($#list_of_return_path_core_re == 0)
	{
	  my($e) = $list_of_return_path_core_re[0];
	  &print_rule( e_mail_address_misc_re => ${e} , target_folder => $param{target_folder__remote} );
	}
      elsif($#list_of_return_path_core_re > 0)
	{
	  my($h0) = join( '|' , @list_of_return_path_core_re );
	  my($h1) = '(' . ${h0} . ')';
	  &print_rule( e_mail_address_misc_re => ${h1} , target_folder => $param{target_folder__remote} );
	}

      if($#list_SPFified_of_return_path_core_re == 0)
	{
	  my($e) = $list_SPFified_of_return_path_core_re[0];
	  &print_rule( e_mail_address_misc_re => ".*=${e}\@.*" , target_folder => $param{target_folder__remote} );
	}
      elsif($#list_SPFified_of_return_path_core_re > 0)
	{
	  my($h0) = join( '|' , @list_SPFified_of_return_path_core_re );
	  &print_rule( e_mail_address_misc_re => ".*=(${h0})\@.*" , target_folder => $param{target_folder__remote} );
	}
    }
  elsif($creating_local_procmailrc_p && exists($param{target_folder__local}))
    {
      if($#list_of_return_path_core_re == 0)
	{
	  my($e) = $list_of_return_path_core_re[0];
	  &print_rule( e_mail_address_misc_re => ${e} , target_folder => $param{target_folder__local} );
	}
      elsif($#list_of_return_path_core_re > 0)
	{
	  my($h0) = join( '|' , @list_of_return_path_core_re );
	  my($h1) = '(' . ${h0} . ')';
	  &print_rule( e_mail_address_misc_re => ${h1} , target_folder => $param{target_folder__local} );
	}

      if($#list_SPFified_of_return_path_core_re == 0)
	{
	  my($e) = $list_SPFified_of_return_path_core_re[0];
	  &print_rule( e_mail_address_misc_re => ".*=${e}\@.*" , target_folder => $param{target_folder__local} );
	}
      elsif($#list_SPFified_of_return_path_core_re > 0)
	{
	  my($h0) = join( '|' , @list_SPFified_of_return_path_core_re );
	  &print_rule( e_mail_address_misc_re => ".*=(${h0})\@.*" , target_folder => $param{target_folder__local} );
	}
    }

  printf STDERR "<%s,%d,%s\n",__FILE__,__LINE__,$proc_name
    if 0 && $main::options{debug};

  return $return_value;
}
#
sub print_rule
{
  my($package,$filename,$line,$proc_name) = caller(0);

  my(%param) = @_;

  # e_mail_address_misc_re
  # target_folder

  my($return_value) = 0;

  printf STDERR ">%s,%d,%s\n",__FILE__,__LINE__,$proc_name
    if 0 && $main::options{debug};

  print "\n"; 
  print ":0\n"; 
  print '* ^Return-Path: <',$param{e_mail_address_misc_re},'>$',"\n";
  print $param{target_folder},"\n";

  printf STDERR "<%s,%d,%s\n",__FILE__,__LINE__,$proc_name
    if 0 && $main::options{debug};

  return $return_value;
}
