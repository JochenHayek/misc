#! /usr/bin/perl -w

##use Fatal;	# 2021-06-03 : looks like Fatal.pm is outdated

# this filter rewrites especially elements like this:
#
#   <text top="92" left="33" width="38" height="13"
#   <image top="92" left="33" width="38" height="13"
#
# to look like this:
#
#   <text  top="0092" left="0033" width="0038" height="0013"
#   <image top="0092" left="0033" width="0038" height="0013"
#
# with nicely indented XML
# you are then able to sort your lines by geometry 
# (because every part of the coordinate spec now has 4 digits)
# and then re-ordering the text pieces (<text ...>...</text>) to your specific needs is a piece of cake.
#
################################################################################
#
# https://www.man7.org/linux/man-pages/man1/sort.1.html
#
# https://www.gnu.org/software/coreutils/manual/html_node/sort-invocation.html#sort-invocation
#
################################################################################
#
# e.g.:
#
# if a text block is aligned in columns, you may want to sort by left="....", then top="...." :
#
#   --key=3,3 : left="...." -- means to use the 3rd field by itself alone, otherwise "-k 3" means between the 3rd field and the end of the line.
#   --key=2,2 : top="...."
#
#     Specify a sort field that consists of the part of the line between pos1 and pos2 (or the end of the line, if pos2 is omitted), inclusive.
#
#   $ sort --key=3,3 --key=2,2
#
# e.g.:
#
#   $ sort -k 1.27,1.32 -k1.15,1.20
#
#   <text  top="0092" left="0033" width="0038" height="0013"
#
#          15-20      27-32
#
# group your text pieces ...

################################################################################

# experimenting on files which are almost identical,
# just that "top" and "height" attributes changed a little.

# possible almost useless for real-life examples

#   <text  top="0092" left="0033" width="0038" height="0013"

# in emacs on a buffer containing some PDFTOHTML XML resp. *region*:
#
#   TOP=-3 HEIGHT=9999 ~/git-servers/github.com/JochenHayek/misc/pdf/pdftohtml__postprocess.pl
#
# adds -3 to the "top" attribute,
# sets the "height" attribute to 9999.

################################################################################

# this is my 1st "s///e",
# and I am rather astonished, that it worked immediately.

# I am also rather astonished, that the right side can have insignificant white space before and after the "expression", that creates the new text.

################################################################################

{
  while(<>)
    {
      s/^  (?<leading_space>\s*)

	 <   (?<text_or_image>text|image)
	 \s+	top="(?<top>-?\d+)" 
	 \s+   left="(?<left>-?\d+)" 
	 \s+  width="(?<width>-?\d+)" 
	 \s+ height="(?<height>-?\d+)" 

       /

	 sprintf "%s<%-5s %s=\"%04.4d\" %s=\"%04.4d\" %s=\"%04.4d\" %s=\"%04.4d\"",

	   		 $+{leading_space} ,

		         $+{text_or_image},

	   'top'    =>	 $+{top}    ,

	   'left'   =>	 $+{left}   ,

	   'width'  =>	 $+{width}  ,

	   'height' =>	 $+{height} ,
	   ;

       /ex;

      # ================================================================================

      # remove "empty lines":
      #
      #   ^ *<text +[^>]*> *</text>$
      #   ^ *<text +[^>]*><b> *</b></text>$

      s,^ *<text +[^>]*> *</text>$,,;
      s,^ *<text +[^>]*><b> *</b></text>$,,;

      # remove trailing space:
      #
      #   > +</

      s, +</,</,;

      # ================================================================================

      print;
    }
}

exit 0;

{
  while(<>)
    {
      s/

	 <(?<text_or_image>text|image)
	 \s+	top="(?<top>-?\d+)" 
	 \s+   left="(?<left>-?\d+)" 
	 \s+  width="(?<width>-?\d+)" 
	 \s+ height="(?<height>-?\d+)" 

       /

	 sprintf "<%-5s %s=\"%04.4d\" %s=\"%04.4d\" %s=\"%04.4d\" %s=\"%04.4d\"",
		       $+{text_or_image},

	 ##'top'    =>	 $+{top}    ,
	   'top'    => ( $+{top}    + ( exists($ENV{TOP})    ? $ENV{TOP}    : 0		 ) ), # new_top = current_top + $ENV{TOP}

	   'left'   =>	 $+{left}   ,

	   'width'  =>	 $+{width}  ,

	 ##'height' =>	 $+{height} ,
	   'height'  =>		      ( exists($ENV{HEIGHT}) ? $ENV{HEIGHT} : $+{height} )  , # new_height = $ENV{HEIGHT} resp. current_height
	   ;

       /ex;

      print;
    }
}
