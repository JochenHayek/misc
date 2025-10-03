#! /usr/bin/perl -w

# adapted from pdftohtml__adapt_top.pl

# USAGE within emacs:
#
#   C-u shell-command-on-region
#
#     sort --key 1.29,1.33 --key 1.17,1.21 | ~/bin/pdftohtml__adapt_left.pl | sort --key 1.29,1.33 --key 1.17,1.21

################################################################################

{
  my($last_left) = 0;

##my($THE_delta) = 1;
  my($THE_delta) = 5;

  while(<>)
    {
      if(m/^  (?<leading_space>\s*)

	    <   (?<text_or_image>text|image)
	    \s+	   top="(?<top>-?\d+)" 
	    \s+   left="(?<left>-?\d+)" 
	    \s+  width="(?<width>-?\d+)" 
	    \s+ height="(?<height>-?\d+)" 

	  /x)
	{
	  my(%plus) = %+;

	  $current_left = $plus{left};
	  $current_left =~ s/^\s*//;

	  if($current_left - $last_left <= $THE_delta)		# maybe it should be 2 or 3 instead of 1
	    {
	      $current_left = $last_left;
	    }

	  s/^  (?<leading_space>\s*)

	     <   (?<text_or_image>text|image)
	     \s+    top="(?<top>-?\d+)" 
	     \s+   left="(?<left>-?\d+)" 
	     \s+  width="(?<width>-?\d+)" 
	     \s+ height="(?<height>-?\d+)" 

	   /

	     sprintf "%s<%-5s %s=\"%04.4d\" %s=\"%04.4d\" %s=\"%04.4d\" %s=\"%04.4d\"",

			     $plus{leading_space} ,

			     $plus{text_or_image},

	       'top'    =>	 $plus{top}   ,

	       'left'   =>	 $current_left    ,

	       'width'  =>	 $plus{width}  ,

	       'height' =>	 $plus{height} ,
	       ;

	   /ex;

	  print;

	  $last_left = $current_left;

	}
      else
	{
	  print;
	}
    }
}

exit 0;
