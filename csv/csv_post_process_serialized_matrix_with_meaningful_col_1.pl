#! /usr/bin/perl -w

# usage:
#
# ...
#
# as the filename (almost) says
# created as a postprocessor to csv_serialize_matrix.pl (living here in the vicinity),
# i.e. to be used on a CSV file with a matrix created by that tool.

# interface contract:
#
# all lines (apart from empty lines) consist of:
# * block#
# * name
# * value AKA $v

# task:
#
# create a separate file named "$ENV{NAME_START}${v}.csv" for each instance of $v !

# CAVEAT:
#
# so far we are expecting a "," a separator here,
# and also '"' to always enclose field values.
#
# yes, we should rather use a proper CSV module.

our($debug) = 0;

{
  my(%blocks);

  my($complete_name);

  while(<>)
    {
      printf STDERR "=%03.3d: %s=>{%s} // %s\n",__LINE__,
	'$.' => $.,
	'...'
	if 0 && $::debug;

      if(m/^ \s* "(?<block_no>\d+)" \s* , \s* " (?<n>[^\"]*) " \s* , \s* " (?<v>[^\"]*) " \s* , /x)		# TBD: replace with a proper CSV module
	{ 
	  printf STDERR "=%03.3d: %s=>{%s} // %s\n",__LINE__,
	    '$.' => $.,
	    '...'
	    if $::debug;

	  my($block_no,$n,$v) = ($+{block_no},$+{n},$+{v});

	  # if($n eq 'product_code_X')
	  #   {
	  #     $complete_name = "$ENV{NAME_START}${v}.csv";
	  #   }

	  printf STDERR "=%03.3d: %s=>{%s},%s=>{%s} // %s\n",__LINE__,
	    '$.' => $.,
	    '$block_no' => $block_no,
	    '...'
	    if $::debug;

	  if(!exists( $blocks{ $block_no } ))
	    {
	      $blocks{ $block_no } = 1;

	      $complete_name = "$ENV{NAME_START}${v}.csv";
	    }

	  if(defined($complete_name))
	    {
	      open my $fh, ">>:encoding(utf8)", $complete_name or die "$complete_name: $!";
	      print $fh $_;
	      close $fh;
	    }
	}
    }
}
