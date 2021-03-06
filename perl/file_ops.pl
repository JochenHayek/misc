#!/usr/bin/perl -w
#!/usr/bin/perl

# usage:
#
#     ...

# purpose:
#
#     ...

# in:

# out:

# requirements:
{
  use English;
  use FileHandle;
  use strict;

  &main;
}
#
sub main
{
  my($package,$filename,$line,$proc_name) = caller(0);

  my(%param) = @_;

  $return_value = 0;

  # described in:
  #	camel book / ch. 7: the std. perl lib. / lib. modules / Getopt::Long - ...

  use Getopt::Long;
  use Pod::Usage;
  %options = ();

  $main::options{debug} = 0;

  printf STDERR ">%s,%d,%s\n",__FILE__,__LINE__,$proc_name
    if 0 && $main::options{debug};

  {
    # defaults for the main::options;
    
    $main::options{quiet}		       	= 0;
    $main::options{dry_run}		       	= 0;
    $main::options{version}		       	= 0;
    $main::options{verbose}		       	= 0;

    $main::options{job_merge_ab_with_bc}      = 0;
    $main::options{job_check_situation__left_ab__right_b}      = 0;
    $main::options{job_check_situation__left_ab__right_bc}     = 0;
    $main::options{job_check_situation__left_a__right_ab}      = 0;

    $main::options{ignore_header_line_on_right_side}		       	= 0;
    $main::options{ignore_header_lines}		       	= 0;

    $main::options{output_c_only}		       	= 0;
  }

  my($result) =
    &GetOptions
      (\%main::options			# -> http://www.gnu.org/prep/standards/standards.html#Option-Table

       ,'job_merge_ab_with_bc!'
       ,'job_check_situation__left_ab__right_b!'
       ,'job_check_situation__left_ab__right_bc!'
       ,'job_check_situation__left_a__right_ab!'

       ,'quiet|silent!'
       ,'dry_run|dry-run!'
       ,'version!'
       ,'help|?!'
       ,'man!'
       ,'debug!'
       ,'verbose=i'

       ,'left=s'
       ,'right=s'

       ,'ignore_header_line_on_right_side!'
       ,'ignore_header_lines!'
       ,'output_c_only!'
       );
  $result || pod2usage(2);

  pod2usage(1) if $main::options{help};
  pod2usage(-exitstatus => 0, -verbose => 2) if $main::options{man};

  if   ($main::options{job_merge_ab_with_bc}) { &job_merge_ab_with_bc; }
  elsif($main::options{job_check_situation__left_ab__right_b} ) { &job_check_situation__left_ab__right_b; }
  elsif($main::options{job_check_situation__left_ab__right_bc}) { &job_check_situation__left_ab__right_bc; }
  elsif($main::options{job_check_situation__left_a__right_ab} ) { &job_check_situation__left_a__right_ab; }
  else
    {
      die "*** no job to be carried out";
    }

  printf STDERR "=%s,%d,%s: %s=>{%s}\n",__FILE__,__LINE__,$proc_name
    ,'$return_value',$return_value
    if 0 && $main::options{debug};
  printf STDERR "<%s,%d,%s\n",__FILE__,__LINE__,$proc_name
    if 0 && $main::options{debug};
}
#
sub job_merge_ab_with_bc
{
  my($package,$filename,$line,$proc_name) = caller(0);

  my(%param) = @_;

  $return_value = 0;

  printf STDERR ">%s,%d,%s\n",__FILE__,__LINE__,$proc_name
    if 1 && $main::options{debug};

  # ...

  # $main::options{left}
  # $main::options{right}

  foreach my $what ('left','right')
    {
      if(exists($main::options{$what}))
	{}
      else
	{
	  pod2usage(-message => "!exists(\$main::options{$what})"
		   ,-exitval => 2
		   );
	}

      my($fh) = new FileHandle $main::options{$what};

      if(defined($fh))
	{}
      else
	{
	  pod2usage(-message => "could not open: \$main::options{$what}=>{$main::options{$what}},\$!=>{$!}"
		   ,-exitval => 2
		   );
	}

      while(<$fh>)
	{
	  chomp;
	  push(@{$lines{$what}},$_);
	}

      if(0 && $main::options{debug})
	{
	  for(my $i = 0 ; $i<= $#{$lines{$what}} ; $i++ )
	    {
	      printf STDERR "=%s,%d,%s: %s=>{%s}\n",__FILE__,__LINE__,$proc_name
		,"\$lines{$what}[$i]",$lines{$what}[$i]
		;
	    }
	}
    }

  my($within_common_block_p) = 0;

  my($right_i) = 0;

  $right_i = 1
    if $main::options{ignore_header_line_on_right_side};

  for( my $left_i = 0 ; $left_i <= $#{$lines{left}} ; $left_i++ )
    {
      printf STDERR "=%s,%d,%s: %s=>{%s},%s=>{%s} // %s\n",__FILE__,__LINE__,$proc_name
	,'$within_common_block_p',$within_common_block_p
	,"\$lines{left}[$left_i]",$lines{left}[$left_i]
	,'...'
	if 1 && $main::options{debug};

      if(   defined($lines{left}[$left_i])
	 && defined($lines{right}[$right_i])
	)
	{
	  if($lines{left}[$left_i] eq $lines{right}[$right_i])
	    {
	      printf STDERR "=%s,%d,%s: %s=>{%s},%s=>{%s} // %s\n",__FILE__,__LINE__,$proc_name
		,'$right_i',$right_i
		,"\$lines{left}[$left_i]",$lines{left}[$left_i]
		,'matching'
		if 1 && $main::options{debug};

	      $within_common_block_p = 1;

	      $right_i ++ ;
	    }
	  else
	    {
	      printf STDERR "=%s,%d,%s: %s=>{%s} // %s\n",__FILE__,__LINE__,$proc_name
		,"\$lines{left}[$left_i]",$lines{left}[$left_i]
		,'left only'
		if 1 && $main::options{debug};

	      if($within_common_block_p)
		{
		  printf STDERR "=%s,%d,%s: %s=>{%s} // %s\n",__FILE__,__LINE__,$proc_name
		    ,"\$lines{left}[$left_i]",$lines{left}[$left_i]
		    ,'end of common block, but still something on the left side'
		    if 1 && $main::options{debug};

		  die "*** \$main::options{left}=>{$main::options{left}},\$main::options{right}=>{$main::options{right}},\$left_i=>{$left_i},\$right_i=>{$right_i},\$proc_name=>{$proc_name} // end of common block, but still something on the left side";
		}
	    }
	}
      else
	{
	  printf STDERR "=%s,%d,%s: %s=>{%s} // %s\n",__FILE__,__LINE__,$proc_name
	    ,"\$lines{left}[$left_i]",$lines{left}[$left_i]
	    ,'end of common block, but still something on the left side (?!???)'
	    if 1 && $main::options{debug};

	  die "*** \$main::options{left}=>{$main::options{left}},\$main::options{right}=>{$main::options{right}},\$left_i=>{$left_i},\$right_i=>{$right_i},defined(\$lines{left}[\$left_i])=>{".defined($lines{left}[$left_i])."},defined(\$lines{right}[\$right_i])=>{".defined($lines{right}[$right_i])."},\$within_common_block_p=>{$within_common_block_p},\$proc_name=>{$proc_name} // ...";
	}

      print $lines{left}[$left_i],"\n"
	if !$main::options{output_c_only};
    }

  if($within_common_block_p)
    {
    }
  else
    {
      printf STDERR "=%s,%d,%s: // %s\n",__FILE__,__LINE__,$proc_name
	,'empty common block'
	if 1 && $main::options{debug};

      warn "*** \$main::options{left}=>{$main::options{left}},\$main::options{right}=>{$main::options{right}} // empty common block";
    }

  if($right_i > $#{$lines{right}})
    {
      printf STDERR "=%s,%d,%s: // %s\n",__FILE__,__LINE__,$proc_name
	,'end of common block and end of right side'
	if 1 && $main::options{debug};

      warn "*** \$main::options{left}=>{$main::options{left}},\$main::options{right}=>{$main::options{right}},\$right_i=>{$right_i} // end of common block and end of right side";
    }
  else
    {
    }

  for( ; $right_i <= $#{$lines{right}} ; $right_i++ )
    {
      printf STDERR "=%s,%d,%s: %s=>{%s} // %s\n",__FILE__,__LINE__,$proc_name
	,"\$lines{right}[$right_i]",$lines{right}[$right_i]
	,'...'
	if 1 && $main::options{debug};

      print $lines{right}[$right_i],"\n";
    }

  printf STDERR "=%s,%d,%s: %s=>{%s}\n",__FILE__,__LINE__,$proc_name
    ,'$return_value',$return_value
    if 0 && $main::options{debug};
  printf STDERR "<%s,%d,%s\n",__FILE__,__LINE__,$proc_name
    if 1 && $main::options{debug};

  return $return_value;
}
#
sub job_check_situation__left_ab__right_b
{
  my($package,$filename,$line,$proc_name) = caller(0);

  my(%param) = @_;

  $return_value = 0;

  printf STDERR ">%s,%d,%s\n",__FILE__,__LINE__,$proc_name
    if 1 && $main::options{debug};

  # ...

  # $main::options{left}
  # $main::options{right}

  foreach my $what ('left','right')
    {
      if(exists($main::options{$what}))
	{}
      else
	{
	  pod2usage(-message => "!exists(\$main::options{$what})"
		   ,-exitval => 2
		   );
	}

      my($fh) = new FileHandle $main::options{$what};

      if(defined($fh))
	{}
      else
	{
	  pod2usage(-message => "could not open: \$main::options{$what}=>{$main::options{$what}},\$!=>{$!}"
		   ,-exitval => 2
		   );
	}

      while(<$fh>)
	{
	  chomp;
	  push(@{$lines{$what}},$_);
	}

      if(0 && $main::options{debug})
	{
	  for(my $i = 0 ; $i<= $#{$lines{$what}} ; $i++ )
	    {
	      printf STDERR "=%s,%d,%s: %s=>{%s}\n",__FILE__,__LINE__,$proc_name
		,"\$lines{$what}[$i]",$lines{$what}[$i]
		;
	    }
	}
    }

  my($within_common_block_p) = 0;

  my($left_i)  = 0;
  my($right_i) = 0;

  if($main::options{ignore_header_lines})
    {
      $left_i  = 1;
      $right_i = 1;
    }

  if(!defined($lines{right}[$right_i]))
     {
       die "*** \$main::options{left}=>{$main::options{left}},\$main::options{right}=>{$main::options{right}},\$proc_name=>{$proc_name} // !defined(\$lines{right}[$right_i] -- maybe the right file is empty";
     }

  for( ; $left_i <= $#{$lines{left}} ; $left_i++ )
    {
      printf STDERR "=%s,%d,%s: %s=>{%s},%s=>{%s} // %s\n",__FILE__,__LINE__,$proc_name
	,'$within_common_block_p',$within_common_block_p
	,"\$lines{left}[$left_i]",$lines{left}[$left_i]
	,'...'
	if 1 && $main::options{debug};

      if   (!defined( $lines{right}[$right_i] ))
	{
	  printf STDERR "=%s,%d,%s: %s=>{%s} // %s\n",__FILE__,__LINE__,$proc_name
	    ,"\$lines{left}[$left_i]",$lines{left}[$left_i]
	    ,'left only'
	    if 1 && $main::options{debug};

	  if($within_common_block_p)
	    {
	      printf STDERR "=%s,%d,%s: %s=>{%s} // %s\n",__FILE__,__LINE__,$proc_name
		,"\$lines{left}[$left_i]",$lines{left}[$left_i]
		,'end of common block, but still something on the left side'
		if 1 && $main::options{debug};

	      die "*** \$main::options{left}=>{$main::options{left}},\$main::options{right}=>{$main::options{right}},\$left_i=>{$left_i},\$right_i=>{$right_i},\$proc_name=>{$proc_name} // end of common block, but still something on the left side";
	    }
	}
      elsif($lines{left}[$left_i] eq $lines{right}[$right_i])
	{
	  printf STDERR "=%s,%d,%s: %s=>{%s},%s=>{%s} // %s\n",__FILE__,__LINE__,$proc_name
	    ,'$right_i',$right_i
	    ,"\$lines{left}[$left_i]",$lines{left}[$left_i]
	    ,'matching'
	    if 1 && $main::options{debug};

	  $within_common_block_p = 1;

	  $right_i ++ ;
	}
      else
	{
	  printf STDERR "=%s,%d,%s: %s=>{%s} // %s\n",__FILE__,__LINE__,$proc_name
	    ,"\$lines{left}[$left_i]",$lines{left}[$left_i]
	    ,'left only'
	    if 1 && $main::options{debug};

	  if($within_common_block_p)
	    {
	      printf STDERR "=%s,%d,%s: %s=>{%s} // %s\n",__FILE__,__LINE__,$proc_name
		,"\$lines{left}[$left_i]",$lines{left}[$left_i]
		,'end of common block, but still something on the left side'
		if 1 && $main::options{debug};

	      die "*** \$main::options{left}=>{$main::options{left}},\$main::options{right}=>{$main::options{right}},\$left_i=>{$left_i},\$right_i=>{$right_i},\$proc_name=>{$proc_name} // end of common block, but still something on the left side";
	    }
	}
    }

  if($within_common_block_p)
    {
    }
  else
    {
      printf STDERR "=%s,%d,%s: %s=>{%s},%s=>{%s} // %s\n",__FILE__,__LINE__,$proc_name
	,'$main::options{left}'  => $main::options{left}
        ,'$main::options{right}' => $main::options{right}
	,'empty common block'
	if 1 && $main::options{debug};

      warn "*** \$main::options{left}=>{$main::options{left}},\$main::options{right}=>{$main::options{right}} // empty common block";

      exit(1);
    }

##if($right_i > $#{$lines{right}})
  if($right_i == $#{$lines{right}} + 1)
    {
      printf STDERR "=%s,%d,%s: %s=>{%s},%s=>{%s} // %s\n",__FILE__,__LINE__,$proc_name
	,'$main::options{left}'  => $main::options{left}
        ,'$main::options{right}' => $main::options{right}
	,'end of common block and end of right side'
	if 1 && $main::options{debug};

      exit(0);
    }
  else
    {
      printf STDERR "=%s,%d,%s: %s=>{%s},%s=>{%s} // %s\n",__FILE__,__LINE__,$proc_name
	,'$main::options{left}'  => $main::options{left}
        ,'$main::options{right}' => $main::options{right}
	,'end of common block, but there is more on the right side'
	if    1 && $main::options{debug};

      if($main::options{quiet})
	{
	  exit(1);
	}
      else
	{
	  die "*** \$main::options{left}=>{$main::options{left}},\$main::options{right}=>{$main::options{right}},\$left_i=>{$left_i},\$right_i=>{$right_i},\$proc_name=>{$proc_name} // end of common block, but there is more on the right side";
	}
    }

  printf STDERR "=%s,%d,%s: %s=>{%s}\n",__FILE__,__LINE__,$proc_name
    ,'$return_value',$return_value
    if 0 && $main::options{debug};
  printf STDERR "<%s,%d,%s\n",__FILE__,__LINE__,$proc_name
    if 1 && $main::options{debug};

  return $return_value;
}
#
sub job_check_situation__left_ab__right_bc
{
  my($package,$filename,$line,$proc_name) = caller(0);

  my(%param) = @_;

  $return_value = 0;

  printf STDERR ">%s,%d,%s\n",__FILE__,__LINE__,$proc_name
    if 1 && $main::options{debug};

  # ...

  # $main::options{left}
  # $main::options{right}

  foreach my $what ('left','right')
    {
      if(exists($main::options{$what}))
	{}
      else
	{
	  pod2usage(-message => "!exists(\$main::options{$what})"
		   ,-exitval => 2
		   );
	}

      my($fh) = new FileHandle $main::options{$what};

      if(defined($fh))
	{}
      else
	{
	  pod2usage(-message => "could not open: \$main::options{$what}=>{$main::options{$what}},\$!=>{$!}"
		   ,-exitval => 2
		   );
	}

      while(<$fh>)
	{
	  chomp;
	  push(@{$lines{$what}},$_);
	}

      if(0 && $main::options{debug})
	{
	  for(my $i = 0 ; $i<= $#{$lines{$what}} ; $i++ )
	    {
	      printf STDERR "=%s,%d,%s: %s=>{%s}\n",__FILE__,__LINE__,$proc_name
		,"\$lines{$what}[$i]",$lines{$what}[$i]
		;
	    }
	}
    }

  my($within_common_block_p) = 0;

  my($left_i)  = 0;
  my($right_i) = 0;

  if($main::options{ignore_header_lines})
    {
      $left_i  = 1;
      $right_i = 1;
    }

  if(!defined($lines{right}[$right_i]))
     {
       die "*** \$main::options{left}=>{$main::options{left}},\$main::options{right}=>{$main::options{right}},\$proc_name=>{$proc_name} // !defined(\$lines{right}[$right_i] -- maybe the right file is empty";
     }

  for( ; $left_i <= $#{$lines{left}} ; $left_i++ )
    {
      printf STDERR "=%s,%d,%s: %s=>{%s},%s=>{%s} // %s\n",__FILE__,__LINE__,$proc_name
	,'$within_common_block_p',$within_common_block_p
	,"\$lines{left}[$left_i]",$lines{left}[$left_i]
	,'...'
	if 1 && $main::options{debug};

      if   (!defined( $lines{right}[$right_i] ))
	{
	  printf STDERR "=%s,%d,%s: %s=>{%s} // %s\n",__FILE__,__LINE__,$proc_name
	    ,"\$lines{left}[$left_i]",$lines{left}[$left_i]
	    ,'left only'
	    if 1 && $main::options{debug};

	  if($within_common_block_p)
	    {
	      printf STDERR "=%s,%d,%s: %s=>{%s} // %s\n",__FILE__,__LINE__,$proc_name
		,"\$lines{left}[$left_i]",$lines{left}[$left_i]
		,'end of common block, but still something on the left side'
		if 1 && $main::options{debug};

	      die "*** \$main::options{left}=>{$main::options{left}},\$main::options{right}=>{$main::options{right}},\$left_i=>{$left_i},\$right_i=>{$right_i},\$proc_name=>{$proc_name} // end of common block, but still something on the left side";
	    }
	}
      elsif($lines{left}[$left_i] eq $lines{right}[$right_i])
	{
	  printf STDERR "=%s,%d,%s: %s=>{%s},%s=>{%s} // %s\n",__FILE__,__LINE__,$proc_name
	    ,'$right_i',$right_i
	    ,"\$lines{left}[$left_i]",$lines{left}[$left_i]
	    ,'matching'
	    if 1 && $main::options{debug};

	  $within_common_block_p = 1;

	  $right_i ++ ;
	}
      else
	{
	  printf STDERR "=%s,%d,%s: %s=>{%s} // %s\n",__FILE__,__LINE__,$proc_name
	    ,"\$lines{left}[$left_i]",$lines{left}[$left_i]
	    ,'left only'
	    if 1 && $main::options{debug};

	  if($within_common_block_p)
	    {
	      printf STDERR "=%s,%d,%s: %s=>{%s} // %s\n",__FILE__,__LINE__,$proc_name
		,"\$lines{left}[$left_i]",$lines{left}[$left_i]
		,'end of common block, but still something on the left side'
		if 1 && $main::options{debug};

	      die "*** \$main::options{left}=>{$main::options{left}},\$main::options{right}=>{$main::options{right}},\$left_i=>{$left_i},\$right_i=>{$right_i},\$proc_name=>{$proc_name} // end of common block, but still something on the left side";
	    }
	}
    }

  if($within_common_block_p)
    {
    }
  else
    {
      printf STDERR "=%s,%d,%s: %s=>{%s},%s=>{%s} // %s\n",__FILE__,__LINE__,$proc_name
	,'$main::options{left}'  => $main::options{left}
        ,'$main::options{right}' => $main::options{right}
	,'empty common block'
	if 1 && $main::options{debug};

      warn "*** \$main::options{left}=>{$main::options{left}},\$main::options{right}=>{$main::options{right}} // empty common block";

      exit(1);
    }

  if($right_i == $#{$lines{right}} + 1)
    {
      printf STDERR "=%s,%d,%s: %s=>{%s},%s=>{%s} // %s\n",__FILE__,__LINE__,$proc_name
	,'$main::options{left}'  => $main::options{left}
        ,'$main::options{right}' => $main::options{right}
	,'end of common block and end of right side'
	if 1 && $main::options{debug};

      if($main::options{quiet})
	{
	  exit(1);
	}
      else
	{
	  die "*** \$main::options{left}=>{$main::options{left}},\$main::options{right}=>{$main::options{right}},\$left_i=>{$left_i},\$right_i=>{$right_i},\$proc_name=>{$proc_name} // end of common block and end of right side, ie. no c";
	}
    }
  else
    {
      printf STDERR "=%s,%d,%s: %s=>{%s},%s=>{%s} // %s\n",__FILE__,__LINE__,$proc_name
	,'$main::options{left}'  => $main::options{left}
        ,'$main::options{right}' => $main::options{right}
	,'end of common block, but there is more on the right side'
	if    1 && $main::options{debug};

      exit(0);
    }

  printf STDERR "=%s,%d,%s: %s=>{%s}\n",__FILE__,__LINE__,$proc_name
    ,'$return_value',$return_value
    if 0 && $main::options{debug};
  printf STDERR "<%s,%d,%s\n",__FILE__,__LINE__,$proc_name
    if 1 && $main::options{debug};

  return $return_value;
}
#
sub job_check_situation__left_a__right_ab # assuming non-empty b
{
  my($package,$filename,$line,$proc_name) = caller(0);

  my(%param) = @_;

  $return_value = 0;

  printf STDERR ">%s,%d,%s\n",__FILE__,__LINE__,$proc_name
    if 1 && $main::options{debug};

  # ...

  # $main::options{left}
  # $main::options{right}

  foreach my $what ('left','right')
    {
      if(exists($main::options{$what}))
	{}
      else
	{
	  pod2usage(-message => "!exists(\$main::options{$what})"
		   ,-exitval => 2
		   );
	}

      my($fh) = new FileHandle $main::options{$what};

      if(defined($fh))
	{}
      else
	{
	  pod2usage(-message => "could not open: \$main::options{$what}=>{$main::options{$what}},\$!=>{$!}"
		   ,-exitval => 2
		   );
	}

      while(<$fh>)
	{
	  chomp;
	  push(@{$lines{$what}},$_);
	}

      if(0 && $main::options{debug})
	{
	  for(my $i = 0 ; $i<= $#{$lines{$what}} ; $i++ )
	    {
	      printf STDERR "=%s,%d,%s: %s=>{%s}\n",__FILE__,__LINE__,$proc_name
		,"\$lines{$what}[$i]",$lines{$what}[$i]
		;
	    }
	}
    }

  my($i)  = 0;

  if($main::options{ignore_header_lines})
    {
      $i  = 1;
    }

  for( ; $i <= $#{$lines{left}} ; $i++ )
    {
      printf STDERR "=%s,%d,%s: %s=>{%s} // %s\n",__FILE__,__LINE__,$proc_name
	,"\$lines{left}[$i]",$lines{left}[$i]
	,'...'
	if 1 && $main::options{debug};

      if($lines{left}[$i] eq $lines{right}[$i])
	{
	  printf STDERR "=%s,%d,%s: %s=>{%s},%s=>{%s} // %s\n",__FILE__,__LINE__,$proc_name
	    ,'$i',$i
	    ,"\$lines{left}[$i]",$lines{left}[$i]
	    ,'matching'
	    if 1 && $main::options{debug};
	}
      else
	{
	  if(1 && $main::options{debug})
	    {
	      warn "*** \$i=>{$i} // end of common block";
	    }

	  exit(1);
	}
    }

  if($i < $#{$lines{right}})
    {
      printf STDERR "=%s,%d,%s: // %s\n",__FILE__,__LINE__,$proc_name
	,'end of common block, but there is more on the right side'
	if 1 && $main::options{debug};

      exit(0);
    }
  else
    {
      printf STDERR "=%s,%d,%s: // %s\n",__FILE__,__LINE__,$proc_name
	,'end of common block, not a non-empty block b on the right side'
	if 1 && $main::options{debug};

      exit(1);
    }

  printf STDERR "=%s,%d,%s: %s=>{%s}\n",__FILE__,__LINE__,$proc_name
    ,'$return_value',$return_value
    if 0 && $main::options{debug};
  printf STDERR "<%s,%d,%s\n",__FILE__,__LINE__,$proc_name
    if 1 && $main::options{debug};

  return $return_value;
}
__END__

=head1 NAME

~/Computers/Programming/Languages/Perl/file_ops.pl - ...

=head1 SYNOPSIS

... [options] [file ...]

Options:
    --help
    --man

    --job_merge_ab_with_bc
    --job_check_situation__left_ab__right_b
    --job_check_situation__left_ab__right_bc
    --job_check_situation__left_a__right_ab

    --left=s
    --right=s

    --ignore_header_line_on_right_side
    --ignore_header_lines
    --output_c_only

=head1 OPTIONS

=over 8

=item B<--help>

Print a brief help message and exits.

=item B<--man>

Prints the manual page and exits.

=item B<--job_merge_ab_with_bc>

...

=item B<--job_check_situation__left_ab__right_b>

...

=item B<--left>

...

=item B<--right>
...

=back

=head1 DESCRIPTION

B<This program> will ...,

CAVEAT:

Yes, I know, both functions ignore the fact,
that there may be somthing that looks like b, but is not,
but there is something else, that in fact is a true b.

There is no backtracking at all at the moment.

=head1 EXAMPLES

~/Computers/Programming/Languages/Perl/file_ops.pl --job_merge_ab_with_bc --ignore_header_line_on_right_side --left=... --right=...
~/Computers/Programming/Languages/Perl/file_ops.pl --job_merge_ab_with_bc --ignore_header_line_on_right_side --left=ALL-RAW.csv     --right=20060125131133-statement.csv >     ALL-RAW.csv-
~/Computers/Programming/Languages/Perl/file_ops.pl --job_merge_ab_with_bc --ignore_header_line_on_right_side --left=JH-ALL-RAW.csv  --right=20060125131133-statement.csv >  JH-ALL-RAW.csv-
~/Computers/Programming/Languages/Perl/file_ops.pl --job_merge_ab_with_bc --ignore_header_line_on_right_side --left=ESH-ALL-RAW.csv --right=20060125131133-statement.csv > ESH-ALL-RAW.csv-

~/Computers/Programming/Languages/Perl/file_ops.pl --job_check_situation__left_ab__right_b  --ignore_header_lines --left=... --right=...

~/Computers/Programming/Languages/Perl/file_ops.pl --job_check_situation__left_ab__right_bc --ignore_header_lines --left=... --right=...

~/Computers/Programming/Languages/Perl/file_ops.pl --job_check_situation__left_a__right_ab  --ignore_header_lines --left=... --right=...

...

=cut
