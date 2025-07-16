#! /usr/bin/perl -w

{
  our(%options);
  $main::options{debug} = 1;

  if(0)
    {
      foreach my $i ( @ARGV )
	{
	  printf STDERR "%03.3d: {%s}=>{%s} // %s\n",__LINE__,
	    '$i' => "$i",
	    '...'
	    if 1;
	}
    }

  my(%table);
  my(@lines);

  while(<STDIN>)
    {
      chomp;

      # <text  top="0093" left="0245" width="0053" height="0011" font="0">Stamm-K.</text> 		<!-- ... -->

      if( 1 &&
	  m/

	     <text
	     \s+	top="(?<top>-?\d+)" 
	     \s+   left="(?<left>-?\d+)" 
	     \s+  width="(?<width>-?\d+)" 
	     \s+ height="(?<height>-?\d+)" 
	     \s+ font="(?<font>-?\d+)" 
	     \s*
	     >(?<content>.*)
	     <\/text>
	     (?<remark>
	     \s*
	     <!-- .* -->
	     \s*
	     )?
	   /x
	)
	{
	  my(%plus) = %+;

	  ##$plus{reduced_left} = $plus{left};
	  $plus{reduced_left} = &left_2_reduced_left( left => $plus{left} , list => \@ARGV );

	  printf STDERR "%03.3d: {%s}=>{%s},{%s}=>{%s},{%s}=>{%s},{%s}=>{%s},{%s}=>{%s} // %s\n",__LINE__,
	    '$plus{top}' => $plus{top},
	    '$plus{left}' => $plus{left},
	    '$plus{width}' => $plus{width},
	    '$plus{height}' => $plus{height},
	    '$plus{reduced_left}' => $plus{reduced_left},
	    '...'
	    if 0;
	  push(@lines,\%plus)
	}
    }

  # …

  if(0)
    {
      my($i);
      for( $i=0 ; $i <= $#lines ; $i++ )
	{
	  printf STDERR "%03.3d: {%s}=>{%s} // %s\n",__LINE__,
	    "\$lines[$i]{reduced_left}" => "$lines[$i]{reduced_left}",
	    '...'
	    if 1;
	}
    }

  # …

  my(@sorted_lines) = sort
    { ( $a->{reduced_left} == $b->{reduced_left} ) ? $a->{top} <=> $b->{top} : $a->{reduced_left} <=> $b->{reduced_left} }
    @lines
    ;

  # …

  if(0)
    {
      my($i);
      for( $i=0 ; $i <= $#lines ; $i++ )
	{
	  printf STDERR "%03.3d: {%s}=>{%s} // %s\n",__LINE__,
	    "\$lines[$i]{reduced_left}" => "$lines[$i]{reduced_left}",
	    '...'
	    if 1;
	}
    }

  # …

  if(1)
    {
      foreach my $i ( @lines )
	{
	  my($remark) = defined($i->{remark}) ? $i->{remark} : '';

	  print <<EOF;
    <text  top="$i->{top}" left="$i->{left}" width="$i->{width}" height="$i->{height}" font="0">$i->{content}</text>${remark}
EOF
	}
    }
}
#
sub left_2_reduced_left
{
  my($package,$filename,$line,$proc_name) = caller(0);

  my(%param) = @_;

  my($return_value) = 0;

  printf STDERR ">%s,%d,%s\n",__FILE__,__LINE__,$proc_name
    if 0 && $main::options{debug};

  printf STDERR "=%s,%d,%s: %s=>{%s} // %s\n",__FILE__,__LINE__,$proc_name
    ,'$param{left}',$param{left}
    ,'...'
    if 0 && $main::options{debug};

  if(0 && $main::options{debug})
    {
      my($i);
      for( $i=0 ; $i <= $#{ $param{list} } ; $i++ )
        {
          my($left) = $param{list}[$i];

          printf STDERR "=%s,%d,%s: %s=>{%s} // %s\n",__FILE__,__LINE__,$proc_name
            ,"\$param{list}[$i]",$param{list}[$i]
            ,'...'
            ;
        }
    }

  if(   exists($param{list})
     && ($#{ $param{list} } >= 1)
    )
    {
      my($i);
      for( $i = $#{ $param{list} } ; $i >= 0 ; $i-- )
        {
          printf STDERR "=%s,%d,%s: %s=>{%s},%s=>{%s} // %s\n",__FILE__,__LINE__,$proc_name
            ,"\$param{list}[$i]",$param{list}[$i]
            ,'$param{left}',$param{left}
            ,'...'
            if 0 && $main::options{debug};

          if   ($param{left} >= $param{list}[$i] )
            {
              ##$return_value = $i;
              $return_value = $param{list}[$i];

              last;
            }
        }
    }
  else
    {
      $return_value = 0;
    }

  printf STDERR "=%s,%d,%s: %s=>{%s} // %s\n",__FILE__,__LINE__,$proc_name
    ,'$return_value',$return_value
    ,'...'
    if 0 && $main::options{debug};

  printf STDERR "<%s,%d,%s\n",__FILE__,__LINE__,$proc_name
    if 0 && $main::options{debug};

  return $return_value;
}
