#! /usr/bin/perl -w


our $std_formatting_options = { 'separator' => ',', 'assign' => '=>', 'quoteLeft' => '{', 'quoteRight' => '}' };


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

  print $param{'target_folder'},"\n";

  if(0)
    {

      ################################################################################

      # 'v' => 
      # 'total_length' => 8 ,
      # 'post_decimal_point_digits' => 2 ,

      my($total_length)        		= $param{total_length};

      my($total_length_plus_1) 		= $param{total_length} + 1;
      my($post_decimal_point_digits_plus_1) = $param{post_decimal_point_digits} + 1;

      ################################################################################

      # the value displayed as intended
      # but with one more digit precision than intended:
      my($v__but_a_little_longer) = sprintf "%${total_length_plus_1}.${post_decimal_point_digits_plus_1}f", $param{v};

      my($pre_decimal_point);
      my($post_decimal_point);

      if($v__but_a_little_longer =~ m/^ \s* (?<pre_decimal_point>\d+) \. (?<post_decimal_point>\d+) $/x)
	{
	  $pre_decimal_point  = $+{pre_decimal_point};
	  $post_decimal_point = $+{post_decimal_point};
	}
      else
	{
	  die "cannot match ...";
	}

      my($post_decimal_point__plus_5) = $post_decimal_point + 5;
      my($length_of___post_decimal_point)         = length($post_decimal_point);
      my($length_of___post_decimal_point__plus_5) = length($post_decimal_point__plus_5);

      $return_value = sprintf "%${total_length}.$param{post_decimal_point_digits}f", $param{v};

      my($length_of_pre_decimal_point) = $total_length - $param{post_decimal_point_digits} - 1;

      if($length_of___post_decimal_point__plus_5 > $post_decimal_point_digits_plus_1)
	{
	  $return_value = sprintf( "%${length_of_pre_decimal_point}d" , ($pre_decimal_point + 1) ) .
	    '.' .
	    '0' x $param{post_decimal_point_digits}
	    ;
	}
      else
	{
	  $return_value = sprintf( "%${length_of_pre_decimal_point}d" , $pre_decimal_point ) .
	    '.' .
	    substr( $post_decimal_point__plus_5 , 0 , $param{post_decimal_point_digits} )
	    ;
	}

    ##printf STDERR "=%s,%d,%s: %s // %s\n",__FILE__,__LINE__,$proc_name
      printf STDERR "\n=%03.3d: %s // %s\n",__LINE__
	,&main::format_key_value_list($main::std_formatting_options,
				      '$param{v}' => $param{v} ,
				      '$v__but_a_little_longer' => $v__but_a_little_longer ,
				      '$return_value' => $return_value ,

				      '$post_decimal_point' => $post_decimal_point ,
				      '$length_of___post_decimal_point' => $length_of___post_decimal_point ,

				      '$post_decimal_point__plus_5' => $post_decimal_point__plus_5 ,
				      '$length_of___post_decimal_point__plus_5' => $length_of___post_decimal_point__plus_5 ,
				     )
	,'...'
       if 0 && $main::options{debug};

      ################################################################################

    }

  printf STDERR "<%s,%d,%s\n",__FILE__,__LINE__,$proc_name
    if 0 && $main::options{debug};

  return $return_value;
}
