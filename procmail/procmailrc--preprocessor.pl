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

  if(exists($param{e_mail_address_single_raw}))
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

  if(exists($param{e_mail_address_single_AT_re}))
    {
      push( @list_of_return_path_core_re , $param{e_mail_address_single_AT_re} );

      if($param{e_mail_address_single_AT_re} =~ m/^ (?<before>.*) \@ (?<after>.*) $/x)
	{
	  my($h0) = "$+{after}=$+{before}";

	  push( @list_SPFified_of_return_path_core_re ,     ${h0}      );
	}
    }

  if(exists($param{e_mail_address_list_of_simple_domains}))
    {
      foreach my $e (@{ $param{e_mail_address_list_of_simple_domains} })
	{
	  my($h1) = $e;

	  $h1 =~ s/ ([\.\+]) /\\$1/gx;

	  push( @list_of_return_path_core_re          , ".*\@${h1}" );

	  push( @list_SPFified_of_return_path_core_re , "${h1}=.*" );
	}
    }

  if(exists($param{e_mail_address_list_of_domains_with_possible_wildcard_subdomain}))
    {
      foreach my $e (@{ $param{e_mail_address_list_of_domains_with_possible_wildcard_subdomain} })
	{
	  my($h1) = $e;

	  $h1 =~ s/ ([\.\+]) /\\$1/gx;

	  push( @list_of_return_path_core_re          , ".*\@(|.*\\.)${h1}" );

	  push( @list_SPFified_of_return_path_core_re , "(|.*\\.)${h1}=.*" );
	}
    }

  if(exists($param{e_mail_address_misc_re}))
    {
      push( @list_of_return_path_core_re , $param{e_mail_address_misc_re} );
    }

  if   ($creating_remote_procmailrc_p && exists($param{target_folder__remote}))
    {
      &print_rule_m0__high_level(
	 local_or_remote => 'remote' ,
	 target_folder => $param{target_folder__remote} ,
	 list_of_return_path_core_re => \@list_of_return_path_core_re ,
	 list_SPFified_of_return_path_core_re => \@list_SPFified_of_return_path_core_re ,
	 );
    }
  elsif($creating_local_procmailrc_p && exists($param{target_folder__local}))
    {
      &print_rule_m0__high_level( 
	 local_or_remote => 'local' ,
	 target_folder => $param{target_folder__local} ,
	 list_of_return_path_core_re => \@list_of_return_path_core_re ,
	 list_SPFified_of_return_path_core_re => \@list_SPFified_of_return_path_core_re ,
	 );
    }

  printf STDERR "<%s,%d,%s\n",__FILE__,__LINE__,$proc_name
    if 0 && $main::options{debug};

  return $return_value;
}
#
sub m_list
{
  my($package,$filename,$line,$proc_name) = caller(0);

  my(%param) = @_;

  # orgName
  # comment
  # my_client_no
  # my_e_mail_address
  # my_account
  # my_password
  # my_profile
  # list_id
  # target_folder__remote

##shuttle-macro: m_list(
##shuttle-macro:   orgName => 'Hostsharing eG',
##shuttle-macro:   comment => 'Interne Mailingliste für Diskussionen mit Bezug zur Hostsharing eG für Mitglieder',
##shuttle-macro:   my_client_no => '', my_e_mail_address => '', my_account => '', my_password => '', my_profile => '',
##shuttle-macro:   list_id => 'members.hostsharing.net',
##shuttle-macro:   target_folder__remote => '.folder-bulk.prio-9/',
##shuttle-macro:   );

##shuttle:
##shuttle: :0
##shuttle: * ^List-ID:.*<members\.hostsharing\.net>$
##shuttle: .folder-bulk.prio-9/

  my($return_value) = 0;

  printf STDERR ">%s,%d,%s\n",__FILE__,__LINE__,$proc_name
    if 0 && $main::options{debug};

  if(exists($param{list_id}))
    {
      my($list_id_backslashed) = $param{list_id};

      $list_id_backslashed =~ s/ ([\.\+]) /\\$1/gx;

      print "##shuttle:\n"; 
      print "##shuttle: :0\n"; 
      print '##shuttle: * ^List-ID:.*<',$list_id_backslashed,'>$',"\n";
      print '##shuttle: ',$param{target_folder__remote},"\n";
    }

  printf STDERR "<%s,%d,%s\n",__FILE__,__LINE__,$proc_name
    if 0 && $main::options{debug};

  return $return_value;
}
#
sub print_rule_m0__high_level
{
  my($package,$filename,$line,$proc_name) = caller(0);

  my(%param) = @_;

  # $param{local_or_remote}
  # $param{target_folder}
  # $param{list_of_return_path_core_re}
  # $param{list_SPFified_of_return_path_core_re}

  my($return_value) = 0;

  printf STDERR ">%s,%d,%s\n",__FILE__,__LINE__,$proc_name
    if 0 && $main::options{debug};

  if($#{$param{list_of_return_path_core_re}} == 0)
    {
      my($e) = $param{list_of_return_path_core_re}[0];
      &print_rule_m0__low_level(
	straight_or_SPFified => 'straight' ,
	e_mail_address_misc_re => ${e} ,
	target_folder => $param{target_folder} ,
	);
    }
  elsif($#{$param{list_of_return_path_core_re}} > 0)
    {
      my($h0) = join( '|' , @{$param{list_of_return_path_core_re}} );
      my($h1) = '(' . ${h0} . ')';
      &print_rule_m0__low_level(
	straight_or_SPFified => 'straight' ,
	e_mail_address_misc_re => ${h1} ,
	target_folder => $param{target_folder} ,
	);
    }

  if   ($#{$param{list_SPFified_of_return_path_core_re}} == 0)
    {
      my($e) = $param{list_SPFified_of_return_path_core_re}[0];
      &print_rule_m0__low_level(
	straight_or_SPFified => 'SPFified' ,
      ##e_mail_address_misc_re => ".*=${e}\@udag\.de"  ,
	e_mail_address_misc_re => ".*=${e}\@.*"        ,
	target_folder => $param{target_folder} ,
	);
    }
  elsif($#{$param{list_SPFified_of_return_path_core_re}} > 0)
    {
      my($h0) = join( '|' , @{$param{list_SPFified_of_return_path_core_re}} );
      my($h1) = '(' . ${h0} . ')';
      &print_rule_m0__low_level(
	straight_or_SPFified => 'SPFified' ,
      ##e_mail_address_misc_re => ".*=${h1}\@udag\.de" ,
	e_mail_address_misc_re => ".*=${h1}\@.*"       ,
	target_folder => $param{target_folder} ,
	);
    }

  printf STDERR "<%s,%d,%s\n",__FILE__,__LINE__,$proc_name
    if 0 && $main::options{debug};

  return $return_value;
}
#
sub print_rule_m0__low_level
{
  my($package,$filename,$line,$proc_name) = caller(0);

  my(%param) = @_;

  # $param{straight_or_SPFified}
  # $param{local_or_remote} // unused?!
  # $param{e_mail_address_misc_re}
  # $param{target_folder}

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
