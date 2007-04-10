#! /usr/bin/perl -ws

# Time-stamp: <2007-04-10 14:32:14 johayek>
# $Id: xml_multi_utility.pl 1.10 2007/04/10 12:32:35 johayek Exp $
# $Source: /Users/johayek/git-servers/github.com/JochenHayek/misc/xml/RCS/xml_multi_utility.pl $

# $ ~/Computers/Data_Formats/Markup_Languages/SGML/PropertyList/use_XML-Parser.pl -file=$HOME/Computers/Data_Formats/Markup_Languages/SGML/PropertyList/membran--chanson--contentsdb.xml

# the utility local_xml::load reads a file using XML::Parser .

# you can advise the utility local_xml::load to treat the data structure read
# as conforming to "-//Apple Computer//DTD PLIST 1.0//EN" (aka "Apple Property List").
# it will then create a corresponding PERL-ish data structure and return it, so that you can make further use of it.

{
  %main::options = ();

  $main::options{debug} = 1;

  die "!defined(-file)"
    unless defined($file);

  my($value) =
      &local_xml::load
	({ 'file' => $file
	 , 'process_PropertyList_p' => 1
         });

  printf STDERR "=%03d: {%s}=>{%s},{%s}=>{%s} // %s\n",__LINE__
    ,'$value'=>$value
    ,'ref($value)'=>ref($value)
    ,'this is the result of parsing the XML document'
    if 1 && $main::options{debug};

  if($main::options{debug})
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

	  printf STDERR "=%03d: {%s}=>{%s} // %s\n",__LINE__
	    ,'$value->{Application}'=>$value->{Application}
	    ,'...'
	    ;

	  if($value->{Application} =~ m/^iTunes v7\.0\.1$/)
	    {
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
}
#
package local_xml;

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
      @{$params_of_top_level_utility->{tree_stack}} = ();

      unshift(@{$tree},{});

      my($value) =
	  &proc_content($params_of_top_level_utility
		       ,{ 'content' => $tree
			});

      return $value;
    }
}

sub proc_content
{
  my($params_of_top_level_utility,$params) = @_;

  my($return_value);

  my(@pairs) = @{$params->{content}};

  {
    my($ref_attributes) = shift(@pairs); # man XML::Parser::Style::Tree : the first item in the array is a (possibly empty) hash reference containing attributes
    my(@attributes) = %{$ref_attributes};

    if($params_of_top_level_utility->{like_Style_Debug_p})
      {
	printf STDERR "=%03d: %s \\\\ (",__LINE__
	  ,join(' ',@{$params_of_top_level_utility->{tree_stack}})
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
		    ,join(' ',@{$params_of_top_level_utility->{tree_stack}})
		    ,$content
		    ;
		}

	      if($params_of_top_level_utility->{process_PropertyList_p})
		{
		  # within PropertyList_s we are only interested in PCDATA as part of a key or of "primitive types"

		  if   ($params_of_top_level_utility->{tree_stack}[$#{$params_of_top_level_utility->{tree_stack}}] =~ m/^(key|data|date|real|integer|string)$/)
		    {
		      $return_value = $content;
		    }
		  else
		    {
		      die "\$params_of_top_level_utility->{tree_stack}[$#{$params_of_top_level_utility->{tree_stack}}]=>{$params_of_top_level_utility->{tree_stack}[$#{$params_of_top_level_utility->{tree_stack}}]},\$content=>{$content}"
		    }
		}
	    }
	}
      elsif($tag ne '0') # man XML::Parser::Style::Tree : for elements, the content is an array reference
	{
	  push( @{$params_of_top_level_utility->{tree_stack}} , $tag );

	  my($value);		# we are going to visit "content", and $value is what we will get back from visiting the content during PropertyList processing

	  if   (0)
	    {
	    }
	  elsif($params_of_top_level_utility->{process_PropertyList_p} && ($params_of_top_level_utility->{tree_stack}[$#{$params_of_top_level_utility->{tree_stack}}] =~ m/^(true|false)$/))
	    {
	      if(0 && $params_of_top_level_utility->{debug})
		{
		  printf STDERR "=%03d: {%s}=>{%s} // %s\n",__LINE__
		    ,"\$params_of_top_level_utility->{tree_stack}[$#{$params_of_top_level_utility->{tree_stack}}]"=>$params_of_top_level_utility->{tree_stack}[$#{$params_of_top_level_utility->{tree_stack}}]
		    ,'...'
		    ;
		}

	      $value = $return_value = ($params_of_top_level_utility->{tree_stack}[$#{$params_of_top_level_utility->{tree_stack}}] =~ 'true')
	    }
	  elsif($params_of_top_level_utility->{process_PropertyList_p} && ($params_of_top_level_utility->{tree_stack}[$#{$params_of_top_level_utility->{tree_stack}}] =~ m/^dict$/))
	    {
	      my(%this_PropertyList_dict);

	      &proc_content($params_of_top_level_utility
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
	  elsif($params_of_top_level_utility->{process_PropertyList_p} && ($params_of_top_level_utility->{tree_stack}[$#{$params_of_top_level_utility->{tree_stack}}] =~ m/^array$/))
	    {
	      my(@this_PropertyList_array);

	      $value =
		  &proc_content($params_of_top_level_utility
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
			       ,{ 'content' => $content
				});
	    }

	  # after returning from visiting content ...

	  if($params_of_top_level_utility->{process_PropertyList_p})
	    {
	      if(!defined ($value))
		{
		  die "\$params_of_top_level_utility->{tree_stack}[$#{$params_of_top_level_utility->{tree_stack}}]=>{$params_of_top_level_utility->{tree_stack}[$#{$params_of_top_level_utility->{tree_stack}}]}"
		}
	      else
		{
		  if   (0)
		    {
		    }
		  elsif($params_of_top_level_utility->{tree_stack}[$#{$params_of_top_level_utility->{tree_stack}}] =~ m/^key$/)
		    {
		      # so that we will keep the name of the key in mind until we will find the value of this key

		      $current_PropertyList_dict_key = $value; # actually $value here is the key *name*

		      printf STDERR "=%03d: {%s}=>{%s} // %s\n",__LINE__
			,'$current_PropertyList_dict_key'=>$current_PropertyList_dict_key
			,'with value'
			if 0 && $params_of_top_level_utility->{debug};
		    }
		##elsif($params_of_top_level_utility->{tree_stack}[$#{$params_of_top_level_utility->{tree_stack}}] =~ m/^(data|date|real|integer|string|true|false)$/)
		  elsif(1)
		    {
		      if ($#{$params_of_top_level_utility->{tree_stack}} == 0)
			{
			  # ???

			  printf STDERR "=%03d: {%s}=>{%s} // %s\n",__LINE__
			    ,"\$params_of_top_level_utility->{tree_stack}[$#{$params_of_top_level_utility->{tree_stack}}]"=>$params_of_top_level_utility->{tree_stack}[$#{$params_of_top_level_utility->{tree_stack}}]
			    ,'$#{$params_of_top_level_utility->{tree_stack}} == 0 ...'
			    if 0 && $params_of_top_level_utility->{debug};
			}
		      elsif($params_of_top_level_utility->{tree_stack}[$#{$params_of_top_level_utility->{tree_stack}} - 1] eq 'plist')
			{
			  # ???

			  printf STDERR "=%03d: {%s}=>{%s},{%s}=>{%s} // %s\n",__LINE__
			    ,"\$params_of_top_level_utility->{tree_stack}[$#{$params_of_top_level_utility->{tree_stack}}]"=>$params_of_top_level_utility->{tree_stack}[$#{$params_of_top_level_utility->{tree_stack}}]
			    ,"\$params_of_top_level_utility->{tree_stack}[$#{$params_of_top_level_utility->{tree_stack}} - 1]"=>$params_of_top_level_utility->{tree_stack}[$#{$params_of_top_level_utility->{tree_stack}} - 1]
			    ,'...'
			    if 0 && $params_of_top_level_utility->{debug};
			}
		      elsif($params_of_top_level_utility->{tree_stack}[$#{$params_of_top_level_utility->{tree_stack}} - 1] eq 'dict')
			{
			  printf STDERR "=%03d: {%s}=>{%s},{%s}=>{%s} // %s\n",__LINE__
			    ,'$current_PropertyList_dict_key'=>$current_PropertyList_dict_key
			    ,'$value'=>$value
			    ,'...'
			    if 0 && $params_of_top_level_utility->{debug};

			  $params->{this_PropertyList_dict}{ $current_PropertyList_dict_key } = $value;
			}
		      elsif($params_of_top_level_utility->{tree_stack}[$#{$params_of_top_level_utility->{tree_stack}} - 1] eq 'array')
			{
			  printf STDERR "=%03d: {%s}=>{%s} // %s\n",__LINE__
			    ,'$value'=>$value
			    ,'pushing a value onto a stack ...'
			    if 0 && $params_of_top_level_utility->{debug};

			  push( @{$params->{this_PropertyList_array}} , $value );
			}
		      else
			{
			  die "\$params_of_top_level_utility->{tree_stack}[$#{$params_of_top_level_utility->{tree_stack}} - 1]=>{$params_of_top_level_utility->{tree_stack}[$#{$params_of_top_level_utility->{tree_stack}} - 1]}"
			}
		    }
		  else
		    {
		      die "\$params_of_top_level_utility->{tree_stack}[$#{$params_of_top_level_utility->{tree_stack}}]=>{$params_of_top_level_utility->{tree_stack}[$#{$params_of_top_level_utility->{tree_stack}}]}"
		    }
		}
	    }

	  pop( @{$params_of_top_level_utility->{tree_stack}} );
	}
      else
	{
	  die "\$tag=>{$tag}";
	}

    }

  if($params_of_top_level_utility->{like_Style_Debug_p})
    {
      printf STDERR "=%03d: %s //\n",__LINE__
	,join(' ',@{$params_of_top_level_utility->{tree_stack}})
	;
    }

  return $return_value;
}
