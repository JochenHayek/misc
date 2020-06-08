#! /usr/bin/perl -w

use Fatal;

# this filter rewrite especially elements like this:
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

# this is my 1st "s///e",
# and I am rather astonished, that it worked immediately.

# I am also rather astonished, that the right side can have insignificant white space before and after the "expression", that creates the new text.

################################################################################

{
  while(<>)
    {
      s/

         <(?<text_or_image>text|image)
         \s+    top="(?<top>-?\d+)" 
         \s+   left="(?<left>-?\d+)" 
         \s+  width="(?<width>-?\d+)" 
         \s+ height="(?<height>-?\d+)" 

       /

         sprintf "<%-5s %s=\"%04.4d\" %s=\"%04.4d\" %s=\"%04.4d\" %s=\"%04.4d\"",
                       $+{text_or_image},
           'top'    => $+{top},
           'left'   => $+{left},
           'width'  => $+{width},
           'height' => $+{height},
           ;

       /ex;

      print;
    }
}
