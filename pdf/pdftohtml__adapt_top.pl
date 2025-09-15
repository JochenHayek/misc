#! /usr/bin/perl -w

# adapted from pdftohtml__postprocess.pl

# USAGE within emacs:
#
#   C-u shell-command-on-region
#
#     ~/bin/pdftohtml__adapt_top.pl | sort

################################################################################

{
  my($last_top) = 0;

##my($THE_delta) = 1;
  my($THE_delta) = 4;

  while(<>)
    {
      if(m/^  (?<leading_space>\s*)

	    <   (?<text_or_image>text|image)
	    \s+	top="(?<top>-?\d+)" 
	    \s+   left="(?<left>-?\d+)" 
	    \s+  width="(?<width>-?\d+)" 
	    \s+ height="(?<height>-?\d+)" 

	  /x)
	{
	  my(%plus) = %+;

	  $current_top = $plus{top};
	  $current_top =~ s/^\s*//;

	  if($current_top - $last_top <= $THE_delta)		# maybe it should be 2 or 3 instead of 1
	    {
	      $current_top = $last_top;
	    }

	  s/^  (?<leading_space>\s*)

	     <   (?<text_or_image>text|image)
	     \s+	top="(?<top>-?\d+)" 
	     \s+   left="(?<left>-?\d+)" 
	     \s+  width="(?<width>-?\d+)" 
	     \s+ height="(?<height>-?\d+)" 

	   /

	     sprintf "%s<%-5s %s=\"%04.4d\" %s=\"%04.4d\" %s=\"%04.4d\" %s=\"%04.4d\"",

			     $plus{leading_space} ,

			     $plus{text_or_image},

	       'top'    =>	 $current_top    ,

	       'left'   =>	 $plus{left}   ,

	       'width'  =>	 $plus{width}  ,

	       'height' =>	 $plus{height} ,
	       ;

	   /ex;

	  print;

	  $last_top = $current_top;

	}
      else
	{
	  print;
	}
    }
}

exit 0;
