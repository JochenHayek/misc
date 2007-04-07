#! /usr/bin/perl -ws

# Time-stamp: <2007-04-07 23:40:21 johayek>
# $Id: xml_multi_utility.pl 1.1 2007/04/07 21:43:43 johayek Exp $
# $Source: /Users/johayek/git-servers/github.com/JochenHayek/misc/xml/RCS/xml_multi_utility.pl $

# $ ~/Computers/Programming/Languages/Perl/use_XML-Parser.pl -file=...

{
  %main::options = ();

  $main::options{debug} = 1;
  $main::options{like_Style_Debug} = 1;

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

  # When parsing a document, "parse()" will return a parse tree for the document. 
  # Each node in the tree takes the form of a tag, content pair. 
  # Text nodes are represented with a pseudo-tag of "0" and the string that is their content. 
  # For elements, the content is an array reference. 
  # The first item in the array is a (possibly empty) hash reference containing attributes. 
  # The remainder of the array is a sequence of tag-content pairs representing the content of the element.

  # <foo><head id="a">Hello <em>there</em></head><bar>Howdy<ref/></bar>do</foo>

  # Style=>Debug
  #
  #  \\ ()
  # foo \\ (id a)
  # foo head || Hello 
  # foo head \\ ()
  # foo head em || there
  # foo head //
  # foo //
  # foo \\ ()
  # foo bar || Howdy
  # foo bar \\ ()
  # foo bar //
  # foo //
  # foo || do
  #  //

  # [foo, [{}
  #       ,head, [{id => "a"}
  #              ,0, "Hello "
  #              ,em, [{}, 0, "there"]
  #              ]
  #       ,bar , [{}
  #              ,0, "Howdy"
  #              ,ref, [{}]
  #              ]
  #       ,0, "do"
  #       ]
  # ]

  if   ( $Style eq 'Debug'  )
    {
    }
  elsif( $Style eq 'Tree'  )
    {
      @main::stack_of_elements = ();

      unshift(@{$tree},{});

      &proc_content($tree);
    }
}
sub proc_content
{
  my(@pairs)      = @{$_[0]};
  my($ref_attributes) = shift(@pairs);

  my(@attributes) = %{$ref_attributes};

  if($main::options{like_Style_Debug})
    {
      printf "=%03d: %s \\\\ (",__LINE__
	,join(' ',@main::stack_of_elements)
	;

      my($separator) = '';
      while($#attributes >= 0)
	{
	  my($name ) = shift(@attributes);
	  my($value) = shift(@attributes);

	  print $separator , $name , ' "' , $value , '"';

	  if($separator eq '')
	    {
	      $separator = ' ';
	    }
	}

      printf ")\n";
    }

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
		  printf "=%03d: %s || {%s}\n",__LINE__
		    ,join(' ',@main::stack_of_elements)
		    ,$content
		    ;
		}
	    }
	}
      else
	{
	  push( @main::stack_of_elements , $tag );

	  &proc_content($content);

	  pop( @main::stack_of_elements );
	}
    }

  if($main::options{like_Style_Debug})
    {
      printf "=%03d: %s //\n",__LINE__
	,join(' ',@main::stack_of_elements)
	;
    }
}
