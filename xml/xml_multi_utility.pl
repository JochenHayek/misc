#! /usr/bin/perl -ws

# Time-stamp: <2007-04-08 00:53:33 johayek>
# $Id: xml_multi_utility.pl 1.3 2007/04/07 22:54:14 johayek Exp $
# $Source: /Users/johayek/git-servers/github.com/JochenHayek/misc/xml/RCS/xml_multi_utility.pl $

# $ ~/Computers/Programming/Languages/Perl/use_XML-Parser.pl -file=...

{
  %main::options = ();

  $main::options{debug} = 1;
  $main::options{like_Style_Debug} = 0;

  use XML::Parser;

##my($Style) = 'Debug';
  my($Style) = 'Tree';

  my($tree);

  my($p) = new XML::Parser(Style => $Style);

  if   (1)
    {
      die "!defined(-file)"
	unless defined($file);

      $tree = $p->parsefile($file);
    }
  else
    {
      $tree = $p->parse('<foo><head id="a">Hello <em>there</em></head><bar>Howdy<ref/></bar>do</foo>');
    }

  if   ( $Style eq 'Debug'  )
    {
    }
  elsif( $Style eq 'Tree'  )
    {
      @main::stack_of_elements = ();

      unshift(@{$tree},{});

      &proc_content({ 'content' => $tree
		    });
    }
}
sub proc_content
{
  my($params) = @_;

  my($return_value);

  my(@pairs) = @{$params->{content}};
  my($ref_attributes) = shift(@pairs);

  my(@attributes) = %{$ref_attributes};

  if($main::options{like_Style_Debug})
    {
      printf STDERR "=%03d: %s \\\\ (",__LINE__
	,join(' ',@main::stack_of_elements)
	;

      my($separator) = '';
      while($#attributes >= 0)
	{
	  my($name ) = shift(@attributes);
	  my($value) = shift(@attributes);

	  print STDERR $separator , $name , ' "' , $value , '"';

	  if($separator eq '')
	    {
	      $separator = ' ';
	    }
	}

      printf STDERR ")\n";
    }

  my($current_pl_dict_key,$current_pl_dict_value);

  while($#pairs >= 0)
    {
      my($tag    ) = shift(@pairs);
      my($content) = shift(@pairs);

      if   (!defined($tag))
	{
	  die '!defined($tag)';
	}
      elsif($tag eq '0')
	{
	  if( $content =~ m/^\s*$/ ) # this is *not* like Style=>Debug
	    {
	    }
	  else
	    {
	      if($main::options{like_Style_Debug})
		{
		  printf STDERR "=%03d: %s || {%s}\n",__LINE__
		    ,join(' ',@main::stack_of_elements)
		    ,$content
		    ;
		}

	      if   ($main::stack_of_elements[$#main::stack_of_elements] =~ m/^(key|string|integer)$/)
		{
		  $return_value = $content;
		}
	    }
	}
      else
	{
	  push( @main::stack_of_elements , $tag );

	  my(%this_pl_dict);

	  my($value);

	  if   ($main::stack_of_elements[$#main::stack_of_elements] =~ m/^dict$/)
	    {
	      &proc_content({ 'content' => $content
			    , 'this_pl_dict' => \%this_pl_dict
			    });

	      if($main::options{debug})
		{
		  foreach my $k (sort keys %this_pl_dict)
		    {
		      printf STDERR "=%03d: {%s}=>{%s} // %s\n",__LINE__
			,$k=>$this_pl_dict{$k}
			,'...'
			;
		    }
		}
	    }
	  else
	    {
	      $value =
		  &proc_content({ 'content' => $content
				});
	    }

	  if(defined ($value))
	    {
	      if   ($main::stack_of_elements[$#main::stack_of_elements] =~ m/^dict$/)
		{
		}
	      elsif($main::stack_of_elements[$#main::stack_of_elements] =~ m/^key$/)
		{
		  $current_pl_dict_key = $value;

		  printf STDERR "=%03d: {%s}=>{%s} // %s\n",__LINE__
		    ,'$current_pl_dict_key'=>$current_pl_dict_key
		    ,'...'
		    if $main::options{debug};
		}
	      elsif($main::stack_of_elements[$#main::stack_of_elements] =~ m/^(string|integer)$/)
		{
		  $current_pl_dict_value = $value;

		  printf STDERR "=%03d: {%s}=>{%s},{%s}=>{%s} // %s\n",__LINE__
		    ,'$current_pl_dict_key'=>$current_pl_dict_key
		    ,'$current_pl_dict_value'=>$current_pl_dict_value
		    ,'...'
		    if $main::options{debug};

		  $params->{this_pl_dict}{$current_pl_dict_key} = $current_pl_dict_value;
		}
	    }

	  pop( @main::stack_of_elements );
	}
    }

  if($main::options{like_Style_Debug})
    {
      printf STDERR "=%03d: %s //\n",__LINE__
	,join(' ',@main::stack_of_elements)
	;
    }

  return $return_value;
}
