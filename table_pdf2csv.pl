#! /usr/bin/perl -w

# $ cd ~/Computers/Programming/Languages/Perl/table_pdf2csv.dir/ && ../table_pdf2csv.pl --debug --orig_file=List_of_Disciplinary_Actions.pdf --pdftohtml_xml_file=List_of_Disciplinary_Actions.pdf.pdftohtml-xml.0.xml
# $ ~/Computers/Programming/Languages/Perl/table_pdf2csv.pl --debug --orig_file=List_of_Disciplinary_Actions.pdf --pdftohtml_xml_file=List_of_Disciplinary_Actions.pdf.pdftohtml-xml.0.xml

# columns in ...:
#   __LINE__,$page_number,$text_i,top,left,$column

# pragmatic restriction:
#
# ...
#
# suggested improvement:
#
# ...
#
# history:
#
# http://cpanforum.com/posts/13593
# http://cpanforum.com/posts/13594
# http://blog-en.jochen.hayek.name/2012/01/tablepdf2csvpl-extracting-tables-as-csv.html
# ...

{
  use utf8;

  binmode(STDOUT,":encoding(utf8)");
  binmode(STDERR,":encoding(utf8)");

  use Carp;

  ##use Data::Dumper;

  my($proc_name) = '(main)';

  use Getopt::Long;
  use Pod::Usage;
  our(%options);
  $main::options{debug} = 0;
##$main::options{show_size_warnings_p} = 1;

  my($result) =
    &GetOptions
      (\%main::options

      ,'pdftohtml_xml_file=s'
      ,'orig_file=s'

      ,'left_specified_on_the_command_line=s@'

      ,'dry_run!'
      ,'version!'
      ,'help|?!'
      ,'man!'
      ,'debug!'
      ,'verbose=i'
      ,'params=s%'              # some "indirect" parameters
      );
  $result || pod2usage(2);

  pod2usage(1) if $main::options{help};
  pod2usage(-exitstatus => 0, -verbose => 2) if $main::options{man};

  ################################################################################

  {
    # reading the PDF file resp. ...

    exists($main::options{pdftohtml_xml_file}) || die "!exists(\$main::options{pdftohtml_xml_file})";

    # http://www.perlmonks.org/index.pl?node_id=490846 = Stepping up from XML::Simple to XML::LibXML

    use XML::LibXML;            # https://metacpan.org/module/XML::LibXML

    my $parser = XML::LibXML->new();
    our($our_dom)  = $parser->parse_file($main::options{pdftohtml_xml_file}); # https://metacpan.org/module/XML::LibXML::Parser
  }

  {
    if(1 && $main::options{debug})
      {
        foreach my $left (@{ $main::options{left_specified_on_the_command_line} })
          {
            printf STDERR "=%s,%d,%s: %s=>{%s} // %s\n",__FILE__,__LINE__,$proc_name
              ,'$left',$left
              ,'as specified on the command line'
              if 0;

            printf STDERR "%04.4d,%s,%s,%s,%s,%s: %s %s=%03.3d // %s\n",__LINE__
              ,'==='
              ,'==='
              ,'==='
              ,'==='
              ,'==='
              ,'========================================'
              ,'--left',$left
              ,'as specified on the command line'
              if 1 && $main::options{debug};
          }
      }

    if(   exists($main::options{left_specified_on_the_command_line})
       && ($#{ $main::options{left_specified_on_the_command_line} } >= 0)
       && (    $main::options{left_specified_on_the_command_line}[0] !=0 )
      )
      {
        printf STDERR "=%s,%d,%s: %s=>{%s} // %s\n",__FILE__,__LINE__,$proc_name
          ,'$main::options{left_specified_on_the_command_line}[0]',$main::options{left_specified_on_the_command_line}[0]
          ,'replacing value by 0 for first "left"'
          if 0;

        printf STDERR "%04.4d,%s,%s,%s,%s,%s: %s=%03.3d // %s\n",__LINE__
          ,'==='
          ,'==='
          ,'==='
          ,'==='
          ,'==='
          ,'--left',$main::options{left_specified_on_the_command_line}[0]
          ,'as specified on the command line -- the 1st, yet unreasonable one; replaced by 0'
          if 1 && $main::options{debug};

        $main::options{left_specified_on_the_command_line}[0] = 0;
      }

    push( @{ $main::options{left_specified_on_the_command_line} } , 999999 ); # there won't be a "left" beyond that, I assume
  }

  {
    # traversing our_dom

    my(%ells_within_this_document); # "ls" as in "lefts", but that's not a proper word, and I didn't want to call it columns either

    my($curr_top) = -1;
    my($curr_col) = 0;
    my($curr_left) = 0;

    foreach my $page_node ($our_dom->findnodes('/pdf2xml/page')) # https://metacpan.org/module/XML::LibXML::Node
      {
        # $page_node->hasAttribute('number'); # https://metacpan.org/module/XML::LibXML::Element

      ##my($page_number) = $page_node->getAttribute('number'); # https://metacpan.org/module/XML::LibXML::Element
        my($page_number) = $page_node->findvalue('@number'); # https://metacpan.org/module/XML::LibXML::XPathContext

        printf STDERR "=%s,%d,%s: %s=>{%s} // %s\n",__FILE__,__LINE__,$proc_name
          ,"\$page_number",$page_number
          ,'...'
          if 0 && $main::options{debug};

        $curr_top = -1;

        printf STDERR "%04.4d,%03.3d,%s,%s,%s,%s: %s // %s\n",__LINE__
          ,$page_number
          ,'==='
          ,'==='
          ,'==='
          ,'==='
          ,'========================================'
          ,'page break'
          if 1 && $main::options{debug};

        my(%ells_on_this_page); # "ls" as in "lefts", but that's not a proper word, and I didn't want to call it columns either

      ##my(@list_of_text) =                                    $page_node->findnodes('./text');
        my(@list_of_text) = sort cmp_coordinates_of_text_entry $page_node->findnodes('./text'); # https://metacpan.org/module/XML::LibXML::Node

        my($text_i);

        my(@content_at_this_top);

        my($curr_top) = 0;

        for($text_i=0;$text_i<=$#list_of_text;$text_i++)
          {
            my($text_at_i) = $list_of_text[ $text_i ];

            $ells_on_this_page{         $text_at_i->findvalue('@left') } += 1; # https://metacpan.org/module/XML::LibXML::XPathContext
            $ells_within_this_document{ $text_at_i->findvalue('@left') } += 1; # https://metacpan.org/module/XML::LibXML::XPathContext

            my($content) = '';
          ##my($content) = $text_at_i->to_literal; # https://metacpan.org/module/XML::LibXML::Node
          ##my($content) = $text_at_i->toString; # https://metacpan.org/module/XML::LibXML::Node
##          if(exists($text_at_i->{content}))
##            {
##              $content = $text_at_i->{content};
##            }

            # "pdf2html -xml" text element's content is actually mixed content, as they allow some <b>...</b> and <i>...</i> formatting.
            # in order to preserve this,
            # I "...->toString" all children individually.
            # of course I wasn't able to achieve this with XML::Simple.

            foreach my $childnode ($text_at_i->childNodes()) # https://metacpan.org/module/XML::LibXML::Node
              {
                my($chunk_of_content) = $childnode->toString; # https://metacpan.org/module/XML::LibXML::Node

                $content .= $chunk_of_content;

                printf STDERR "=%s,%d,%s: %s=>{%03.3d},%s=>{%03.3d},%s=>{%03.3d},%s=>{%03.3d},%s=>{%s} // %s\n",__FILE__,__LINE__,$proc_name
                  ,'$page_number',$page_number
                  ,'$text_i',$text_i
                  ,"\$text_at_i->findvalue('\@top')",$text_at_i->findvalue('@top') # https://metacpan.org/module/XML::LibXML::XPathContext
                  ,"\$text_at_i->findvalue('\@left')",$text_at_i->findvalue('@left') # https://metacpan.org/module/XML::LibXML::XPathContext
                  ,'$chunk_of_content',$chunk_of_content
                  ,'...'
                  if(0 && $main::options{debug});
              }

            printf STDERR "=%s,%d,%s: %s=>{%03.3d},%s=>{%03.3d},%s=>{%03.3d},%s=>{%03.3d},%s=>{%s} // %s\n",__FILE__,__LINE__,$proc_name
              ,'$page_number',$page_number
              ,'$text_i',$text_i
              ,"\$text_at_i->findvalue('\@top')",$text_at_i->findvalue('@top') # https://metacpan.org/module/XML::LibXML::XPathContext
              ,"\$text_at_i->findvalue('\@left')",$text_at_i->findvalue('@left') # https://metacpan.org/module/XML::LibXML::XPathContext
              ,'$content',$content
              ,'...'
              if 0 && $main::options{debug};

            my($column) = &left2column( 'left' => $text_at_i->findvalue('@left') , 'list' => $main::options{left_specified_on_the_command_line} );

            if($text_at_i->findvalue('@top') == $curr_top) # https://metacpan.org/module/XML::LibXML::XPathContext
              {
              }
            else
              {
                printf STDERR "%04.4d,%03.3d,%03.3d,%03.3d,%03.3d,%03.3d: %s // %s\n",__LINE__
                  ,$page_number
                  ,$text_i
                  ,$text_at_i->findvalue('@top') # https://metacpan.org/module/XML::LibXML::XPathContext
                  ,$text_at_i->findvalue('@left') # https://metacpan.org/module/XML::LibXML::XPathContext
                  ,$column
                  ,'========================================'
                  ,'top break'
                  if 1 && $main::options{debug};

                &process_content_at_this_top
                  ( l => \@content_at_this_top
                  , 'page_number' => $page_number
                  , 'top' => $curr_top
                  );

                $curr_top = $text_at_i->findvalue('@top'); # https://metacpan.org/module/XML::LibXML::XPathContext
                $curr_col  = 0;
                $curr_left = 0; # @main::options{left_specified_on_the_command_line}
              }

            $curr_top = $text_at_i->findvalue('@top'); # https://metacpan.org/module/XML::LibXML::XPathContext

            printf STDERR "%04.4d,%03.3d,%03.3d,%03.3d,%03.3d,%03.3d: {%s} // %s\n",__LINE__
              ,$page_number
              ,$text_i
              ,$text_at_i->findvalue('@top') # https://metacpan.org/module/XML::LibXML::XPathContext
              ,$text_at_i->findvalue('@left') # https://metacpan.org/module/XML::LibXML::XPathContext
              ,$column
              ,$content
              ,'...'
              if 1 && $main::options{debug};

            push( @{ $content_at_this_top[$column] } , $content );
          }

        &process_content_at_this_top
          ( l => \@content_at_this_top
          , 'page_number' => $page_number
          , 'top' => $curr_top
          );
        printf STDOUT "%04.4d,%03.3d%s%03.3d\r\n",__LINE__ # page break
          ,$page_number
          ,','
          ,-1
          ;

        if(1 && $main::options{debug})
          {
            foreach my $left (sort {$a <=> $b} keys %ells_on_this_page)
              {
                printf STDERR "=%s,%d,%s: %s=>{%03.3d} : %s=%03.3d // %s\n",__FILE__,__LINE__,$proc_name
                  ,'$page_number',$page_number
                  ,'--left',$left
                  ,'"left-s" on this page'
                  if 0;

                printf STDERR "%04.4d,%03.3d,%s,%s,%s,%s: %s %s=%03.3d // %s: %s{ %03.3d }=>%05.5d\n",__LINE__
                  ,$page_number
                  ,'==='
                  ,'==='
                  ,'==='
                  ,'==='
                  ,'========================================'
                  ,'--left',$left
                  ,'"left-s" on this page'
                  ,'$ells_on_this_page',$left,$ells_on_this_page{ $left }
                  if 1 && $main::options{debug};
              }
          }
      }

    if(1 && $main::options{debug})
      {
        foreach my $left (sort {$a <=> $b} keys %ells_within_this_document)
          {
            printf STDERR "=%s,%d,%s: %s=%03.3d // %s\n",__FILE__,__LINE__,$proc_name
              ,'--left',$left
              ,'"left-s" within this document'
              if 0;

            printf STDERR "%04.4d,%s,%s,%s,%s,%s: %s %s=%03.3d // %s: %s{ %03.3d }=>%05.5d\n",__LINE__
              ,'==='
              ,'==='
              ,'==='
              ,'==='
              ,'==='
              ,'========================================'
              ,'--left',$left
              ,'"left-s" within this document'
              ,'$ells_within_this_document',$left,$ells_within_this_document{ $left }
              if 1 && $main::options{debug};
          }
      }
  }

}
#
sub cmp_coordinates_of_text_entry
{
  my($package,$filename,$line,$proc_name) = caller(0);

  ##my(@params) = @_;

  my($return_value) = 0;

  printf STDERR ">%s,%d,%s\n",__FILE__,__LINE__,$proc_name
    if 0 && $main::options{debug};

  if   ($a->findvalue('@top') == $b->findvalue('@top')) # https://metacpan.org/module/XML::LibXML::XPathContext
    {
      $return_value = $a->findvalue('@left') <=> $b->findvalue('@left'); # https://metacpan.org/module/XML::LibXML::XPathContext
    }
  else
    {
      $return_value = $a->findvalue('@top') <=> $b->findvalue('@top'); # https://metacpan.org/module/XML::LibXML::XPathContext
    }

  printf STDERR "=%s,%d,%s: %s=>{%s} // %s\n",__FILE__,__LINE__,$proc_name
    ,'$return_value',$return_value
    ,'...'
    if 0 && $main::options{debug};
  printf STDERR "<%s,%d,%s\n",__FILE__,__LINE__,$proc_name
    if 0 && $main::options{debug};

  return $return_value;
}
#
sub left2column
{
  my($package,$filename,$line,$proc_name) = caller(0);

  my(%param) = @_;

  my($return_value) = 0;

  printf STDERR ">%s,%d,%s\n",__FILE__,__LINE__,$proc_name
    if 0 && $main::options{debug};

  printf STDERR "=%s,%d,%s: %s=>{%s} // %s\n",__FILE__,__LINE__,$proc_name
    ,'$param{left}',$param{left}
    ,'...'
    if 0 && $main::options{debug};

  if(0 && $main::options{debug})
    {
      my($i);
      for( $i=0 ; $i <= $#{ $param{list} } ; $i++ )
        {
          my($left) = $param{list}[$i];

          printf STDERR "=%s,%d,%s: %s=>{%s} // %s\n",__FILE__,__LINE__,$proc_name
            ,"\$param{list}[$i]",$param{list}[$i]
            ,'...'
            ;
        }
    }

  if(   exists($param{list})
     && ($#{ $param{list} } >= 1)
    )
    {
      my($i);
      for( $i = $#{ $param{list} } ; $i >= 0 ; $i-- )
        {
          printf STDERR "=%s,%d,%s: %s=>{%s},%s=>{%s} // %s\n",__FILE__,__LINE__,$proc_name
            ,"\$param{list}[$i]",$param{list}[$i]
            ,'$param{left}',$param{left}
            ,'...'
            if 0 && $main::options{debug};

          if   ($param{left} >= $param{list}[$i] )
            {
              $return_value = $i;

              last;
            }
        }
    }
  else
    {
      $return_value = 0;
    }

  printf STDERR "=%s,%d,%s: %s=>{%s} // %s\n",__FILE__,__LINE__,$proc_name
    ,'$return_value',$return_value
    ,'...'
    if 0 && $main::options{debug};

  printf STDERR "<%s,%d,%s\n",__FILE__,__LINE__,$proc_name
    if 0 && $main::options{debug};

  return $return_value;
}
#
sub process_content_at_this_top
{
  my($package,$filename,$line,$proc_name) = caller(0);

  my(%param) = @_;

  my($return_value) = 0;

  printf STDERR ">%s,%d,%s\n",__FILE__,__LINE__,$proc_name
    if 0 && $main::options{debug};

  printf STDERR "%04.4d,%03.3d,%s,%03.3d,%s,%s: // %s\n",__LINE__
    ,$param{page_number}
    ,'==='
    ,$param{top}
    ,'==='
    ,'==='
    ,'======================================== top break'
    if 0 && $main::options{debug};

  my($max_last) = -1;

  my($i);
  for($i=0 ; $i <= $#{ $param{l} } ; $i++)
    {
      if(defined($param{l}[$i]))
        {
          printf STDERR "=%s,%d,%s: %s=>{%s},%s=>{%s},%s=>{%s} // %s\n",__FILE__,__LINE__,$proc_name
            ,'$param{page_number}',$param{page_number}
            ,'$param{top}',$param{top}
            ,"\$#{ \$param{l}[$i] }",$#{ $param{l}[$i] }
            ,'...'
            if 0 && $main::options{debug};

          if( $#{ $param{l}[$i] } > $max_last )
            {
              $max_last = $#{ $param{l}[$i] };

              printf STDERR "=%s,%d,%s: %s=>{%s} // %s\n",__FILE__,__LINE__,$proc_name
                ,'$max_last',$max_last
                ,'...'
                if 0 && $main::options{debug};
            }
        }
    }

  my($n);
  for($n=0 ; $n <= $max_last ; $n++)
    {
      my($sep) = '';

      $sep = ',';
      printf STDOUT "%04.4d%s%03.3d%s%03.3d",__LINE__,$sep,$param{page_number},$sep,$param{top};

      for($i=0 ; $i <= $#{ $param{l} } ; $i++)
        {
          if(defined($param{l}[$i][$n]))
            {
              my($c) = $param{l}[$i][$n];

              $c =~ s/\s+$//g;

            ##$c =~ s/\"/\\\"/g;
            ##$c =~ s/\"/'/g;
              $c =~ s/\"/""/g;

              print STDOUT $sep,'"',$c,'"';
            }
          else
            {
              print STDOUT $sep;
            }
          $sep = ',';
        }

      print STDOUT "\r\n";
    }

  printf STDERR "=%s,%d,%s: %s=>{%s} // %s\n",__FILE__,__LINE__,$proc_name
    ,'$max_last',$max_last
    ,'...'
    if 0 && $main::options{debug};

  printf STDERR "%04.4d,%03.3d,%s,%03.3d,%s,%s: %s // %s: %s=>{%s}\n",__LINE__
    ,$param{page_number}
    ,'==='
    ,$param{top}
    ,'==='
    ,'==='
    ,'========================================'
    ,'top break'
    ,'$max_last',$max_last
    if 1 && $main::options{debug};

  @{ $param{l} } = ();          # reset

  printf STDERR "=%s,%d,%s: %s=>{%s} // %s\n",__FILE__,__LINE__,$proc_name
    ,'$return_value',$return_value
    ,'...'
    if 0 && $main::options{debug};
  printf STDERR "<%s,%d,%s\n",__FILE__,__LINE__,$proc_name
    if 0 && $main::options{debug};

  return $return_value;
}
#
sub dummy
{
  my($package,$filename,$line,$proc_name) = caller(0);

  my(%param) = @_;

  my($return_value) = 0;

  printf STDERR ">%s,%d,%s\n",__FILE__,__LINE__,$proc_name
    if 0 && $main::options{debug};

  printf STDERR "=%s,%d,%s: %s=>{%s} // %s\n",__FILE__,__LINE__,$proc_name
    ,'$return_value',$return_value
    ,'...'
    if 0 && $main::options{debug};
  printf STDERR "<%s,%d,%s\n",__FILE__,__LINE__,$proc_name
    if 0 && $main::options{debug};

  return $return_value;
}
__END__

=head1 NAME

table_pdf2csv.pl

=head1 SYNOPSIS

table_pdf2csv.pl [options] [file ...]

Options:
    --help
    --man

    --orig_file=FILE
    --pdftohtml_xml_file=FILE

    --left_specified_on_the_command_line=NUMBER // list

    --dry_run
    --version
    --help
    --man
    --debug
    --verbose

    --...

=head1 OPTIONS

=over 8

=item B<--help>

Print a brief help message and exits.

=item B<--man>

Prints the manual page and exits.

=item B<--orig_file=FILE>

We just want to know the name of the original file,
so we are able to issue messages refering to that name.

=item B<--pdftohtml_xml_file=FILE>

That's the intermediate file created by C<pdftohtml -xml> from the original file.
This is the XML file, we are processing.

=item B<--left_specified_on_the_command_line=NUMBER>

With the XML file, the coordinates get called B<left> for B<x>, and B<top> for B<y>,
the origin being on the upper left corner.

=item B<--[no]dry_run>

...

=item B<--version>

...

=item B<--help>

...

=item B<--man>

...

=item B<--debug=NUMBER>

...

=item B<--[no]verbose>

...

=item B<--...>

...

=back

=head1 DESCRIPTION

table_pdf2csv.pl ...

=head1 REQUIREMENTS

...

=head1 EXAMPLE

.../table_pdf2csv.pl ...

...

=head1 FORMAT OF THE CSV FILE

The content records, you are really interested in, got a few auxiliary columns inserted before each of them,
and you may want to hide or remove them,
before you proceed working with the content.

=over 8

=item column#1

Line number within the source code of this utility.
Usually only the developer is interested in this.

=item column#2

Page#.

=item column#3

Top, the y-coordinate.

=item further columns

The content, you are really interested in.

=back

=head1 FORMAT OF THE LOG FILE

Within this log file every single piece of text from the PDF file resp. the XML file gets listed and annotated on a single line of its own.

=over 8

=item column#1

Line number within the source code of this utility.
Usually only the developer is interested in this.

=item column#2

Page#.

=item column#3

Text item# within the page.

=item column#4

Top, the y-coordinate.

=item column#5

Left, the x-coordinate.

=item column#6

The logical column number.

=item remainder

Sometimes it's the actual content of the text item,
sometimes we show a summary here,
e.g. the "left-s" "of this page" together with their respective number of occurrences,
or   the "left-s" "within this document" together with their respective number of occurrences,

=back

=head1 RECIPES

=over 8

=item 1st run without left-s specified

On the first run you usually don't specify any C<--left> command line parameter,
as you have no idea, where the columns are located.

This utility creates a log file named after the original PDF file, with C<.log.txt> appended.

It also creates a CSV file named after the original PDF file, with C<.csv> appended.

Please study their formats!

You are now going to specify the x-coordinates of the logical columns.

The I<--left>-s (listed within the log file) with the most hits
are good candidates to be used themselves on further runs.

But for each logical column
we suggest you consider the one to the left,
and you may actually find,
it's the x-coordinate of a text string, 
that you seriously want to see within the same logical column,
so you choose this I<--left> instead of the original one for the logical column in question.

Keep in mind:
each I<--left> gets listed, because it does have hits,
and if you don't include it with the right logical column,
you may see it displaced.

=item further runs with lefts specified

On these next runs
you specify a couple of I<--left> command line parameters to the perl utility within the wrapper shell script.

Now it's worth having a look at the CSV file created from the PDF file.

=back

=head1 HISTORY

...

=cut
