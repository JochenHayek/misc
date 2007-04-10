#! /usr/bin/perl -w

($emacs_Time_stamp) = 'Time-stamp: <2007-04-10 18:36:38 johayek>' =~ m/<(.*)>/;

# Time-stamp: <2007-04-10 16:00:13 johayek>
# $Id: xml_multi_utility.pl 1.17 2007/04/10 16:37:11 johayek Exp $
# $Source: /Users/johayek/git-servers/github.com/JochenHayek/misc/xml/RCS/xml_multi_utility.pl $

          $rcs_Id=(join(' ',((split(/\s/,'$Id: xml_multi_utility.pl 1.17 2007/04/10 16:37:11 johayek Exp $'))[1..6])));
#	$rcs_Date=(join(' ',((split(/\s/,'$Date: 2007/04/10 16:37:11 $'))[1..2])));
#     $rcs_Author=(join(' ',((split(/\s/,'$Author: johayek $'))[1])));
#   $rcs_Revision=(join(' ',((split(/\s/,'$Revision: 1.17 $'))[1])));
#	 $RCSfile=(join(' ',((split(/\s/,'$RCSfile: xml_multi_utility.pl $'))[1])));
#     $rcs_Source=(join(' ',((split(/\s/,'$Source: /Users/johayek/git-servers/github.com/JochenHayek/misc/xml/RCS/xml_multi_utility.pl $'))[1])));

# $ ~/Computers/Data_Formats/Markup_Languages/SGML/PropertyList/use_XML-Parser.pl --job_pl_validate --pl_file=$HOME/Computers/Data_Formats/Markup_Languages/SGML/PropertyList/membran--chanson--contentsdb.xml

# $ ~/Computers/Data_Formats/Markup_Languages/SGML/PropertyList/use_XML-Parser.pl --job_itunes_whatever --pl_file=$HOME/Computers/Data_Formats/Markup_Languages/SGML/PropertyList/membran--chanson--contentsdb.xml

# the subroutine local_xml_package::load reads a file using XML::Parser .

# you can advise the utility local_xml_package::load to treat the data structure read
# as conforming to "-//Apple Computer//DTD PLIST 1.0//EN" (aka "Apple Property List").
# it will then create a corresponding PERL-ish data structure and return it,
# so that you can make further use of it.

{
##use English;
##use FileHandle;
  use strict;

  &main;
}
#
sub main
{
  my($package,$filename,$line_no,$proc_name) = caller(0);

  my(%param) = @_;

  $return_value = 0;

  # described in:
  #	camel book / ch. 7: the std. perl lib. / lib. modules / Getopt::Long - ...

  use Getopt::Long;
  use Pod::Usage;
  %options = ();

  $main::options{debug} = 0;

  printf STDERR ">%d,%s\n",__LINE__,$proc_name
    if 0 && $main::options{debug};
  printf STDERR "=%d,%s: %s=>{%s}\n",__LINE__,$proc_name
    ,'$rcs_Id',$rcs_Id
    if 0 && $main::options{debug};
  printf STDERR "=%d,%s: %s=>{%s}\n",__LINE__,$proc_name
    ,'$emacs_Time_stamp',$emacs_Time_stamp
    if 0 && $main::options{debug};

  {
    # defaults for the main::options;
    
    $main::options{dry_run}		       	= 0;
    $main::options{version}		       	= 0;
    $main::options{verbose}		       	= 0;

    $main::options{job_propertylist_validate}                   = 0;

    $main::options{job_itunes_whatever}                   = 0;
    $main::options{job_whatever}                   = 0;

    $main::options{propertylist_file}	       	        = undef;
  }

  my($result) =
    &GetOptions
      (\%main::options

      ,'job_propertylist_validate|job_pl_validate!'

      ,'job_itunes_whatever!'
      ,'job_whatever!'

      ,'dry_run!'
      ,'version!'
      ,'help|?!'
      ,'man!'
      ,'debug!'
      ,'verbose=i'
      ,'params=s%'		# some "indirect" parameters

      ,'propertylist_file|pl_file=s'

      ,'test_cases=s%'
      );
  $result || pod2usage(2);

  pod2usage(1) if $main::options{help};
  pod2usage(-exitstatus => 0, -verbose => 2) if $main::options{man};

##$main::options{verbose}=0;
##$main::options{verbose}=2;			# JH: verbosest level here

  if   ($main::options{job_propertylist_validate})  { &main::job_propertylist_validate; }
  elsif($main::options{job_itunes_whatever})               { &main::job_iTunes_whatever; }
  elsif($main::options{job_whatever})               { &main::job_whatever; }
  else
    {
      die "no job to be carried out";
    }

  printf STDERR "=%d,%s: %s=>{%s} // %s\n",__LINE__,$proc_name
    ,'$return_value',$return_value
    ,'...'
    if 0 && $main::options{debug};
  printf STDERR "<%d,%s\n",__LINE__,$proc_name
    if 0 && $main::options{debug};
}
#
sub job_iTunes_whatever
{
  my($package,$filename,$line_no,$proc_name) = caller(0);

  my(%param) = @_;

  $return_value = 0;

  printf STDERR ">%d,%s\n",__LINE__,$proc_name
    if 1 && $main::options{debug};

  defined($main::options{propertylist_file}) 		        || die "--propertylist_file ???";

  my($value) =
      &local_xml_package::load
        ({ 'file' => $main::options{propertylist_file}
	, 'process_PropertyList_p' => 1
	});

  printf STDERR "=%03d: {%s}=>{%s},{%s}=>{%s} // %s\n",__LINE__
    ,'$value'=>$value
    ,'ref($value)'=>ref($value)
    ,'this is the result of parsing the XML document'
    if 1 && $main::options{debug};

  printf STDERR "=%03d: {%s}=>{%s} // %s\n",__LINE__
    ,'$value->{Application}'=>$value->{Application}
    ,'...'
    if 1 && $main::options{debug};

  if($value->{Application} =~ m/^iTunes v7\.0\.1$/)
    {
      if(1 || $main::options{debug})
	{
	  if(ref($value) eq 'HASH')
	    {
	      foreach my $k (sort keys %{$value})
		{
		  my($v) = $value->{$k};

		  if(ref(\$v) eq 'SCALAR')
		    {
		      printf STDERR "=%03d: {%s}=>{%s} // %s\n",__LINE__
			,$k=>$v
			,'another k=>v assoc ...'
			;
		    }
		  else
		    {
		      printf STDERR "=%03d: {%s}=>{%s},{%s}=>{%s} // %s\n",__LINE__
			,$k=>$v
			,"ref(\$value->{$k})"=>ref($value->{$k})
			,'another k=>v assoc ...'
			;
		    }
		}

	      foreach my $track (@{$value->{tracks}})
		{
		  printf STDERR "=%03d: {%s}=>{%s},{%s}=>{%s} // %s\n",__LINE__
		    ,'$track->{Artist}' => defined($track->{Artist}) ? $track->{Artist} : '{undef}'
		    ,'$track->{Name}'   => defined($track->{Name})   ? $track->{Name}   : '{undef}'
		    ,'...'
		    ;
		}
	    }
	}
    }

  printf STDERR "=%d,%s: %s=>{%s} // %s\n",__LINE__,$proc_name
    ,'$return_value',$return_value
    ,'...'
    if 0 && $main::options{debug};
  printf STDERR "<%d,%s\n",__LINE__,$proc_name
    if 1 && $main::options{debug};

  return $return_value;
}
#
sub job_whatever
{
  my($package,$filename,$line_no,$proc_name) = caller(0);

  my(%param) = @_;

  $return_value = 0;

  printf STDERR ">%d,%s\n",__LINE__,$proc_name
    if 1 && $main::options{debug};

  defined($main::options{propertylist_file}) 		        || die "--propertylist_file ???";

  my($value) =
      &local_xml_package::load
        ({ 'file' => $main::options{propertylist_file}
	, 'process_PropertyList_p' => 1
	});

  printf STDERR "=%03d: {%s}=>{%s},{%s}=>{%s} // %s\n",__LINE__
    ,'$value'=>$value
    ,'ref($value)'=>ref($value)
    ,'this is the result of parsing the XML document'
    if 1 && $main::options{debug};

  printf STDERR "=%03d: {%s}=>{%s} // %s\n",__LINE__
    ,'$value->{Application}'=>$value->{Application}
    ,'...'
    if 1 && $main::options{debug};

  if   ($value->{Application} eq 'files.pl regression test')
    {
      if(1 || $main::options{debug})
	{
	  foreach my $test_case (@{$value->{test_cases}})
	    {
	      printf STDERR "=%03d: {%s}=>{%s} // %s\n",__LINE__
		,'$test_case->{unique_id}'    => ( defined($test_case->{unique_id}) ? $test_case->{unique_id} : '{undef}' )
		,'...'
		if 1 && $main::options{debug};

	      if(exists($main::options{test_cases}{ $test_case->{unique_id} }))
		{
		  print "#\n" , '#' x 80 , "\n#\n";

		  printf "# =%03d: {%s}=>{%s} // %s\n",__LINE__
		    ,'$test_case->{unique_id}'    => ( defined($test_case->{unique_id}) ? $test_case->{unique_id} : '{undef}' )
		    ,'...'
		    ;

		  print "#\n(\n";

		  printf STDERR "=%03d: {%s}=>{%s} // %s\n",__LINE__
		    ,'$test_case->{command_line}' => ( defined($test_case->{command_line})   ? $test_case->{command_line}   : '{undef}' )
		    ,'...'
		    if 1 && $main::options{debug};

		  my($k,$v);
		  while( ($k,$v) = each %{$test_case->{shell_variables}} )
		    {
		      printf STDERR "=%03d: {%s}=>{%s} // %s\n",__LINE__
			,  ( defined($k) ? $k : '{undef}' )
			=> ( defined($v) ? $v : '{undef}' )
			,'another shell variable'
			if 1 && $main::options{debug};

		      printf "  %s='%s' # =%03d // %s\n"
			,  ( defined($k) ? $k : '# {undef}' )
			=> ( defined($v) ? $v : '"{undef}"' )
		        ,__LINE__
			,'another shell variable'
			;
		    }

		  printf "  %s # =%03d // %s\n"
		    , ( defined($test_case->{command_line})   ? $test_case->{command_line}   : '# {undef}' )
		    ,__LINE__
		    ,'...'
		    ;

		  print ")\n";
		}
	    }
	}
    }
  else
    {
      die "\$value->{Application}=>{$value->{Application}}"
    }

  printf STDERR "=%d,%s: %s=>{%s} // %s\n",__LINE__,$proc_name
    ,'$return_value',$return_value
    ,'...'
    if 0 && $main::options{debug};
  printf STDERR "<%d,%s\n",__LINE__,$proc_name
    if 1 && $main::options{debug};

  return $return_value;
}
#
sub job_propertylist_validate
{
  my($package,$filename,$line_no,$proc_name) = caller(0);

  my(%param) = @_;

  $return_value = 0;

  printf STDERR ">%d,%s\n",__LINE__,$proc_name
    if 1 && $main::options{debug};

  defined($main::options{propertylist_file}) 		        || die "--propertylist_file ???";

  system( 'env XML_CATALOG_FILES=$HOME/usr/share/xml/PropertyList/schema/dtd/1.0/catalog.xml xmllint --valid --noout '
	. $main::options{propertylist_file}
	);

  my($exit_value)  = $? >> 8;
  my($signal_num)  = $? & 127;
  my($dumped_core) = $? & 128;

  printf STDERR "=%s,%d,%s: %s=>{%s},%s=>{%s},%s=>{%s} // %s\n",__FILE__,__LINE__,$proc_name
    ,'$exit_value',$exit_value
    ,'$signal_num',$signal_num
    ,'$dumped_core',$dumped_core
    ,'...'
    if 1 || $main::options{debug};

  printf STDERR "=%d,%s: %s=>{%s} // %s\n",__LINE__,$proc_name
    ,'$return_value',$return_value
    ,'...'
    if 0 && $main::options{debug};
  printf STDERR "<%d,%s\n",__LINE__,$proc_name
    if 1 && $main::options{debug};

  return $return_value;
}
#
package local_xml_package;

sub load
{
  my($params_of_top_level_utility) = (@_);

  ################################################################################

  $params_of_top_level_utility->{debug} = 0
    unless defined($params_of_top_level_utility->{debug});

  $params_of_top_level_utility->{like_Style_Debug_p} = 0
    unless defined($params_of_top_level_utility->{like_Style_Debug_p});

  $params_of_top_level_utility->{Style} = 'Tree' # 'Debug' ?!?
    unless defined($params_of_top_level_utility->{Style});

  ################################################################################

  my(%local_variables_of_top_level_utility);

  ################################################################################

  use XML::Parser;

  my($p) = new XML::Parser(Style => $params_of_top_level_utility->{Style});

  my($tree);

  if   (1)
    {
      $tree = $p->parsefile($params_of_top_level_utility->{file});
    }
  else
    {
      # this is the example from
      # $ man XML::Parser::Style::Tree

      $tree = $p->parse('<foo><head id="a">Hello <em>there</em></head><bar>Howdy<ref/></bar>do</foo>');
    }

  if   ( $params_of_top_level_utility->{Style} eq 'Debug'  )
    {
    }
  elsif( $params_of_top_level_utility->{Style} eq 'Tree'  )
    {
      @{$local_variables_of_top_level_utility{tree_stack}} = ();

      unshift(@{$tree},{});

      my($value) =
	  &proc_content($params_of_top_level_utility
		       ,\%local_variables_of_top_level_utility
		       ,{ 'content' => $tree
			});

      $tree = undef;		# releasing the data structure created by the parser

      return $value;
    }
}

sub proc_content
{
  my($params_of_top_level_utility,$variables_of_top_level_utility,$params) = @_;

  my($return_value);

  my(@pairs) = @{$params->{content}};

  {
    my($ref_attributes) = shift(@pairs); # man XML::Parser::Style::Tree : the first item in the array is a (possibly empty) hash reference containing attributes
    my(@attributes) = %{$ref_attributes};

    if($params_of_top_level_utility->{like_Style_Debug_p})
      {
	printf STDERR "=%03d: %s \\\\ (",__LINE__
	  ,join(' ',@{$variables_of_top_level_utility->{tree_stack}})
	  ;

	my($separator) = '';
	while($#attributes >= 0)
	  {
	    my($name ) = shift(@attributes);
	    my($value) = shift(@attributes);

	    print STDERR $separator , $name , ' "' , $value , '"';

	    $separator = ' '
	      if($separator eq '');
	  }

	printf STDERR ")\n";
      }
  }

  my($current_PropertyList_dict_key);

  while($#pairs >= 0) # man XML::Parser::Style::Tree : the remainder of the array is a sequence of tag-content pairs representing the content of the element
    {
      my($tag    ) = shift(@pairs);
      my($content) = shift(@pairs);

      if   (!defined($tag))
	{
	  die '!defined($tag)';
	}
      elsif($tag eq '0') # man XML::Parser::Style::Tree : text nodes are represented with a pseudo-tag of "0" and the string (aka "PCDATA") is their content
	{
	  if( $content =~ m/^\s*$/ ) # as opposed to Style=>Debug, here we don't deal with the occurrence of space as PCDATA
	    {
	    }
	  else
	    {
	      if($params_of_top_level_utility->{like_Style_Debug_p})
		{
		  printf STDERR "=%03d: %s || {%s}\n",__LINE__
		    ,join(' ',@{$variables_of_top_level_utility->{tree_stack}})
		    ,$content
		    ;
		}

	      if($params_of_top_level_utility->{process_PropertyList_p})
		{
		  # within PropertyList_s we are only interested in PCDATA as part of a key or of "primitive types"

		  if   ($variables_of_top_level_utility->{tree_stack}[$#{$variables_of_top_level_utility->{tree_stack}}] =~ m/^(key|data|date|real|integer|string)$/)
		    {
		      $return_value = $content;
		    }
		  else
		    {
		      die "\$variables_of_top_level_utility->{tree_stack}[$#{$variables_of_top_level_utility->{tree_stack}}]=>{$variables_of_top_level_utility->{tree_stack}[$#{$variables_of_top_level_utility->{tree_stack}}]},\$content=>{$content}";
		    }
		}
	    }
	}
      elsif($tag ne '0') # man XML::Parser::Style::Tree : for elements, the content is an array reference
	{
	  push( @{$variables_of_top_level_utility->{tree_stack}} , $tag );

	  my($value);		# we are going to visit "content", and $value is what we will get back from visiting the content during PropertyList processing

	  if   (0)
	    {
	    }
	  elsif($params_of_top_level_utility->{process_PropertyList_p} && ($variables_of_top_level_utility->{tree_stack}[$#{$variables_of_top_level_utility->{tree_stack}}] =~ m/^(true|false)$/))
	    {
	      if(0 && $params_of_top_level_utility->{debug})
		{
		  printf STDERR "=%03d: {%s}=>{%s} // %s\n",__LINE__
		    ,"\$variables_of_top_level_utility->{tree_stack}[$#{$variables_of_top_level_utility->{tree_stack}}]"=>$variables_of_top_level_utility->{tree_stack}[$#{$variables_of_top_level_utility->{tree_stack}}]
		    ,'...'
		    ;
		}

	      $value = $return_value = ($variables_of_top_level_utility->{tree_stack}[$#{$variables_of_top_level_utility->{tree_stack}}] =~ 'true')
	    }
	  elsif($params_of_top_level_utility->{process_PropertyList_p} && ($variables_of_top_level_utility->{tree_stack}[$#{$variables_of_top_level_utility->{tree_stack}}] =~ m/^dict$/))
	    {
	      my(%this_PropertyList_dict);

	      &proc_content($params_of_top_level_utility
			   ,$variables_of_top_level_utility
			   ,{ 'content' => $content
			    , 'this_PropertyList_dict' => \%this_PropertyList_dict
			    });

	      # we are back from constructing the "dict",
	      # so now we can have a look at it:

	      if(0 && $params_of_top_level_utility->{debug})
		{
		  foreach my $k (sort keys %this_PropertyList_dict)
		    {
		      my($v) = $this_PropertyList_dict{$k};

		      if(ref(\$v) eq 'SCALAR')
			{
			  printf STDERR "=%03d: {%s}=>{%s} // %s\n",__LINE__
			    ,$k=>$v
			    ,'another k=>v assoc ...'
			    ;
			}
		      else
			{
			  printf STDERR "=%03d: {%s}=>{%s},{%s}=>{%s} // %s\n",__LINE__
			    ,"\$this_PropertyList_dict{$k}"=>$this_PropertyList_dict{$k}
			    ,"ref(\$this_PropertyList_dict{$k})"=>ref($this_PropertyList_dict{$k})
			    ,'another k=>v assoc ...'
			    ;
			}
		    }
		}

	      $value = $return_value = \%this_PropertyList_dict;
	    }
	  elsif($params_of_top_level_utility->{process_PropertyList_p} && ($variables_of_top_level_utility->{tree_stack}[$#{$variables_of_top_level_utility->{tree_stack}}] =~ m/^array$/))
	    {
	      my(@this_PropertyList_array);

	      $value =
		  &proc_content($params_of_top_level_utility
			       ,$variables_of_top_level_utility
			       ,{ 'content' => $content
				, 'this_PropertyList_array' => \@this_PropertyList_array
				});

	      # we are back from constructing the "array",
	      # so now we can have a look at it:

	      if(0 && $params_of_top_level_utility->{debug})
		{
		  my($i);
		  for($i=0;$i<=$#this_PropertyList_array;$i++)
		    {
		      my($v) = $this_PropertyList_array[$i];

		      if(ref(\$v) eq 'SCALAR')
			{
			  printf STDERR "=%03d: {%s}=>{%s} // %s\n",__LINE__
			    ,"\$this_PropertyList_array[$i]"=>$this_PropertyList_array[$i]
			    ,'...'
			    ;
			}
		      else
			{
			  printf STDERR "=%03d: {%s}=>{%s},{%s}=>{%s} // %s\n",__LINE__
			    ,"\$this_PropertyList_array[$i]"=>$this_PropertyList_array[$i]
			    ,"ref(\$this_PropertyList_array[$i])"=>ref($this_PropertyList_array[$i])
			    ,'...'
			    ;
			}
		    }
		}

	      $value = $return_value = \@this_PropertyList_array;
	    }
	  else
	    {
	      # this *may* still be according to $params_of_top_level_utility->{process_PropertyList_p}
	      # or just ordinary expat tree traversal

	      $value = $return_value =
		  &proc_content($params_of_top_level_utility
			       ,$variables_of_top_level_utility
			       ,{ 'content' => $content
				});
	    }

	  # after returning from visiting content ...

	  if($params_of_top_level_utility->{process_PropertyList_p})
	    {
	      if(!defined ($value))
		{
		  die "\$variables_of_top_level_utility->{tree_stack}[$#{$variables_of_top_level_utility->{tree_stack}}]=>{$variables_of_top_level_utility->{tree_stack}[$#{$variables_of_top_level_utility->{tree_stack}}]}"
		}
	      else
		{
		  if   (0)
		    {
		    }
		  elsif($variables_of_top_level_utility->{tree_stack}[$#{$variables_of_top_level_utility->{tree_stack}}] =~ m/^key$/)
		    {
		      # so that we will keep the name of the key in mind until we will find the value of this key

		      $current_PropertyList_dict_key = $value; # actually $value here is the key *name*

		      printf STDERR "=%03d: {%s}=>{%s} // %s\n",__LINE__
			,'$current_PropertyList_dict_key'=>$current_PropertyList_dict_key
			,'with value'
			if 0 && $params_of_top_level_utility->{debug};
		    }
		##elsif($variables_of_top_level_utility->{tree_stack}[$#{$variables_of_top_level_utility->{tree_stack}}] =~ m/^(data|date|real|integer|string|true|false)$/)
		  elsif(1)
		    {
		      if ($#{$variables_of_top_level_utility->{tree_stack}} == 0)
			{
			  # ???

			  printf STDERR "=%03d: {%s}=>{%s} // %s\n",__LINE__
			    ,"\$variables_of_top_level_utility->{tree_stack}[$#{$variables_of_top_level_utility->{tree_stack}}]"=>$variables_of_top_level_utility->{tree_stack}[$#{$variables_of_top_level_utility->{tree_stack}}]
			    ,'$#{$variables_of_top_level_utility->{tree_stack}} == 0 ...'
			    if 0 && $params_of_top_level_utility->{debug};
			}
		      elsif($variables_of_top_level_utility->{tree_stack}[$#{$variables_of_top_level_utility->{tree_stack}} - 1] eq 'plist')
			{
			  # ???

			  printf STDERR "=%03d: {%s}=>{%s},{%s}=>{%s} // %s\n",__LINE__
			    ,"\$variables_of_top_level_utility->{tree_stack}[$#{$variables_of_top_level_utility->{tree_stack}}]"=>$variables_of_top_level_utility->{tree_stack}[$#{$variables_of_top_level_utility->{tree_stack}}]
			    ,"\$variables_of_top_level_utility->{tree_stack}[$#{$variables_of_top_level_utility->{tree_stack}} - 1]"=>$variables_of_top_level_utility->{tree_stack}[$#{$variables_of_top_level_utility->{tree_stack}} - 1]
			    ,'...'
			    if 0 && $params_of_top_level_utility->{debug};
			}
		      elsif($variables_of_top_level_utility->{tree_stack}[$#{$variables_of_top_level_utility->{tree_stack}} - 1] eq 'dict')
			{
			  printf STDERR "=%03d: {%s}=>{%s},{%s}=>{%s} // %s\n",__LINE__
			    ,'$current_PropertyList_dict_key'=>$current_PropertyList_dict_key
			    ,'$value'=>$value
			    ,'...'
			    if 0 && $params_of_top_level_utility->{debug};

			  $params->{this_PropertyList_dict}{ $current_PropertyList_dict_key } = $value;
			}
		      elsif($variables_of_top_level_utility->{tree_stack}[$#{$variables_of_top_level_utility->{tree_stack}} - 1] eq 'array')
			{
			  printf STDERR "=%03d: {%s}=>{%s} // %s\n",__LINE__
			    ,'$value'=>$value
			    ,'pushing a value onto a stack ...'
			    if 0 && $params_of_top_level_utility->{debug};

			  push( @{$params->{this_PropertyList_array}} , $value );
			}
		      else
			{
			  die "\$variables_of_top_level_utility->{tree_stack}[$#{$variables_of_top_level_utility->{tree_stack}} - 1]=>{$variables_of_top_level_utility->{tree_stack}[$#{$variables_of_top_level_utility->{tree_stack}} - 1]}"
			}
		    }
		  else
		    {
		      die "\$variables_of_top_level_utility->{tree_stack}[$#{$variables_of_top_level_utility->{tree_stack}}]=>{$variables_of_top_level_utility->{tree_stack}[$#{$variables_of_top_level_utility->{tree_stack}}]}"
		    }
		}
	    }

	  pop( @{$variables_of_top_level_utility->{tree_stack}} );
	}
      else
	{
	  die "\$tag=>{$tag}";
	}

    }

  if($params_of_top_level_utility->{like_Style_Debug_p})
    {
      printf STDERR "=%03d: %s //\n",__LINE__
	,join(' ',@{$variables_of_top_level_utility->{tree_stack}})
	;
    }

  return $return_value;
}
__END__

=head1 NAME

... - ...

=head1 SYNOPSIS

... [options] [file ...]

Options:
    --help
    --man

    --job_...

    --propertylist_file

=head1 OPTIONS

=over 8

=item B<--help>

Print a brief help message and exits.

=item B<--man>

Prints the manual page and exits.

=item B<--job_propertylist_validate>

...

=item B<--job_iTunes_whatever>

...

=item B<--job_whatever>

...

=item B<--job_...>

...

=back

=head1 DESCRIPTION

B<This program> will ...

...

=head1 EXAMPLES

...

=cut
