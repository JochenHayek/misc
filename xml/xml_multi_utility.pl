#! /usr/bin/perl -ws

# Time-stamp: <2007-04-09 01:28:06 johayek>
# $Id: xml_multi_utility.pl 1.7 2007/04/08 23:29:00 johayek Exp $
# $Source: /Users/johayek/git-servers/github.com/JochenHayek/misc/xml/RCS/xml_multi_utility.pl $

# $ ~/Computers/Data_Formats/Markup_Languages/SGML/PropertyList/use_XML-Parser.pl -file=$HOME/Computers/Data_Formats/Markup_Languages/SGML/PropertyList/membran--chanson--contentsdb.xml

# this utility reads a file conforming to "-//Apple Computer//DTD PLIST 1.0//EN" (aka "Apple Property List") using XML::Parser
# and creates a corresponding PERL-ish data structure.

{
  use XML::Parser;

  %main::options = ();

  $main::options{debug} = 1;

  $main::options{like_Style_Debug} = 0;

##$main::options{Style} = 'Debug';
  $main::options{Style} = 'Tree';

  $main::options{process_PropertyList_p} = 1;

  my($tree);

  my($p) = new XML::Parser(Style => $main::options{Style});

  if   (1)
    {
      die "!defined(-file)"
	unless defined($file);

      $tree = $p->parsefile($file);
    }
  else
    {
      # this is the example from
      # $ man XML::Parser::Style::Tree

      $tree = $p->parse('<foo><head id="a">Hello <em>there</em></head><bar>Howdy<ref/></bar>do</foo>');
    }

  if   ( $main::options{Style} eq 'Debug'  )
    {
    }
  elsif( $main::options{Style} eq 'Tree'  )
    {
      @main::stack = ();

      unshift(@{$tree},{});

      my($value) =
	  &proc_content({ 'content' => $tree
			});

      if($main::options{process_PropertyList_p})
	{
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
    }
}
sub proc_content
{
  my($params) = @_;

  my($return_value);

  my(@pairs) = @{$params->{content}};

  {
    my($ref_attributes) = shift(@pairs); # man XML::Parser::Style::Tree : the first item in the array is a (possibly empty) hash reference containing attributes
    my(@attributes) = %{$ref_attributes};

    if($main::options{like_Style_Debug})
      {
	printf STDERR "=%03d: %s \\\\ (",__LINE__
	  ,join(' ',@main::stack)
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

  my($current_pl_dict_key);

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
	      if($main::options{like_Style_Debug})
		{
		  printf STDERR "=%03d: %s || {%s}\n",__LINE__
		    ,join(' ',@main::stack)
		    ,$content
		    ;
		}

	      if($main::options{process_PropertyList_p})
		{
		  # within PropertyList_s we are only interested in PCDATA as part of a key or of "primitive types"

		  if   ($main::stack[$#main::stack] =~ m/^(key|data|date|real|integer|string)$/)
		    {
		      $return_value = $content;
		    }
		  else
		    {
		      die "\$main::stack[$#main::stack]=>{$main::stack[$#main::stack]},\$content=>{$content}"
		    }
		}
	    }
	}
      elsif($tag ne '0') # man XML::Parser::Style::Tree : for elements, the content is an array reference
	{
	  push( @main::stack , $tag );

	  my($value);		# we are going to visit "content", and $value is what we will get back from visiting the content during PropertyList processing

	  if   (0)
	    {
	    }
	  elsif($main::options{process_PropertyList_p} && ($main::stack[$#main::stack] =~ m/^(true|false)$/))
	    {
	      if(0 && $main::options{debug})
		{
		  printf STDERR "=%03d: {%s}=>{%s} // %s\n",__LINE__
		    ,"\$main::stack[$#main::stack]"=>$main::stack[$#main::stack]
		    ,'...'
		    ;
		}

	      $value = $return_value = ($main::stack[$#main::stack] =~ 'true')
	    }
	  elsif($main::options{process_PropertyList_p} && ($main::stack[$#main::stack] =~ m/^dict$/))
	    {
	      my(%this_pl_dict);

	      &proc_content({ 'content' => $content
			    , 'this_pl_dict' => \%this_pl_dict
			    });

	      # we are back from constructing the "dict",
	      # so now we can have a look at it:

	      if(0 && $main::options{debug})
		{
		  foreach my $k (sort keys %this_pl_dict)
		    {
		      my($v) = $this_pl_dict{$k};

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
			    ,"\$this_pl_dict{$k}"=>$this_pl_dict{$k}
			    ,"ref(\$this_pl_dict{$k})"=>ref($this_pl_dict{$k})
			    ,'another k=>v assoc ...'
			    ;
			}
		    }
		}

	      $value = $return_value = \%this_pl_dict;
	    }
	  elsif($main::options{process_PropertyList_p} && ($main::stack[$#main::stack] =~ m/^array$/))
	    {
	      my(@this_pl_array);

	      $value =
		  &proc_content({ 'content' => $content
				, 'this_pl_array' => \@this_pl_array
				});

	      # we are back from constructing the "array",
	      # so now we can have a look at it:

	      if(0 && $main::options{debug})
		{
		  my($i);
		  for($i=0;$i<=$#this_pl_array;$i++)
		    {
		      my($v) = $this_pl_array[$i];

		      if(ref(\$v) eq 'SCALAR')
			{
			  printf STDERR "=%03d: {%s}=>{%s} // %s\n",__LINE__
			    ,"\$this_pl_array[$i]"=>$this_pl_array[$i]
			    ,'...'
			    ;
			}
		      else
			{
			  printf STDERR "=%03d: {%s}=>{%s},{%s}=>{%s} // %s\n",__LINE__
			    ,"\$this_pl_array[$i]"=>$this_pl_array[$i]
			    ,"ref(\$this_pl_array[$i])"=>ref($this_pl_array[$i])
			    ,'...'
			    ;
			}
		    }
		}

	      $value = $return_value = \@this_pl_array;
	    }
	  else
	    {
	      # this *may* still be according to $main::options{process_PropertyList_p}
	      # or just ordinary expat tree traversal

	      $value = $return_value =
		  &proc_content({ 'content' => $content
				});
	    }

	  # after returning from visiting content ...

	  if($main::options{process_PropertyList_p})
	    {
	      if(!defined ($value))
		{
		  die "\$main::stack[$#main::stack]=>{$main::stack[$#main::stack]}"
		}
	      else
		{
		  if   (0)
		    {
		    }
		  elsif($main::stack[$#main::stack] =~ m/^key$/)
		    {
		      # so that we will keep the name of the key in mind until we will find the value of this key

		      $current_pl_dict_key = $value; # actually $value here is the key *name*

		      printf STDERR "=%03d: {%s}=>{%s} // %s\n",__LINE__
			,'$current_pl_dict_key'=>$current_pl_dict_key
			,'with value'
			if 0 && $main::options{debug};
		    }
		##elsif($main::stack[$#main::stack] =~ m/^(data|date|real|integer|string|true|false)$/)
		  elsif(1)
		    {
		      if ($#main::stack == 0)
			{
			  # ???

			  printf STDERR "=%03d: {%s}=>{%s} // %s\n",__LINE__
			    ,"\$main::stack[$#main::stack]"=>$main::stack[$#main::stack]
			    ,'$#main::stack == 0 ...'
			    if 0 && $main::options{debug};
			}
		      elsif($main::stack[$#main::stack - 1] eq 'plist')
			{
			  # ???

			  printf STDERR "=%03d: {%s}=>{%s},{%s}=>{%s} // %s\n",__LINE__
			    ,"\$main::stack[$#main::stack]"=>$main::stack[$#main::stack]
			    ,"\$main::stack[$#main::stack - 1]"=>$main::stack[$#main::stack - 1]
			    ,'...'
			    if 0 && $main::options{debug};
			}
		      elsif($main::stack[$#main::stack - 1] eq 'dict')
			{
			  printf STDERR "=%03d: {%s}=>{%s},{%s}=>{%s} // %s\n",__LINE__
			    ,'$current_pl_dict_key'=>$current_pl_dict_key
			    ,'$value'=>$value
			    ,'...'
			    if 0 && $main::options{debug};

			  $params->{this_pl_dict}{$current_pl_dict_key} = $value;
			}
		      elsif($main::stack[$#main::stack - 1] eq 'array')
			{
			  printf STDERR "=%03d: {%s}=>{%s} // %s\n",__LINE__
			    ,'$value'=>$value
			    ,'pushing a value onto a stack ...'
			    if 0 && $main::options{debug};

			  push( @{$params->{this_pl_array}} , $value );
			}
		      else
			{
			  die "\$main::stack[$#main::stack - 1]=>{$main::stack[$#main::stack - 1]}"
			}
		    }
		  else
		    {
		      die "\$main::stack[$#main::stack]=>{$main::stack[$#main::stack]}"
		    }
		}
	    }

	  pop( @main::stack );
	}
      else
	{
	  die "\$tag=>{$tag}";
	}

    }

  if($main::options{like_Style_Debug})
    {
      printf STDERR "=%03d: %s //\n",__LINE__
	,join(' ',@main::stack)
	;
    }

  return $return_value;
}
