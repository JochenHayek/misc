#! /usr/bin/perl -w

# -> ARCHIVE/Computers/Software/Groupware/Wiki/Wiki_Engines/PHP/MediaWiki/README--Vorlagen--Internetquelle--tanach-us.txt

# reads text like this:
#
#   <!-- {{tanach | name_at_the_server | name_at_WP   | name_to_show          | selection | from_chapter | from_verse | to_chapter | to_verse}} -->
#   1,9–5,7<!-- {{tanach | Isa | Jesaja | Jes | | 1 | 9 | 5 | 7}} -->
#   <!-- {{tanach | Isa | Jesaja | Jes | 1 | 1 | 1 | 1 | 27}} -->
#
#   0th parameter: abbreviation as used by tanach.us
#   ... parameter: the name at de.WP.org
#   ... parameter: the name we will provide as "titel" (i.e. "BOOK …") to Internetquelle

#   ... parameter: (abbr.) selection to show – if empty, we will show the selection as made up from the next parameters.

#   ... parameter: from/chapter
#   ... parameter: from/verse
#   ... parameter: to/chapter – if from/chapter = to/chapter, we will not show to/chapter
#   ... parameter: to/verse
#
#   there is no way to make tanach.us show an entire chapter w/o specifying from/verse .. to/verse.

$Codex_Leningradensis_already_linked_once_p = 0;

{
  while(<>)
    {
      chomp
	if 0;

      if( m/ \{\{ (?<content>tanach \s+ .*? ) \}\} /x )
	{
	  my(%plus) = %+;

	  printf STDERR "=%s,%d: %s=>{%s} // %s\n",__FILE__,__LINE__,
	    '$plus{content}' => $plus{content},
	    '...'
	    if 0;

	  if( m/ ^ (?<before>.*?) (?<old_selection> [\d\-,–]+ ) <!-- \s+ \{\{ (?<content>tanach \s+ .*? ) \}\} \s+ --> (?<after>.*) $ /x )
	    {
	      my(%plus) = %+;

	      printf STDERR "=%s,%d: %s=>{%s} // %s\n",__FILE__,__LINE__,
		'$plus{content}' => $plus{content},
		'...'
		if 0;

	      my(@h) = split( /\s*\|\s*/ , $plus{content} );

	      if($#h == 8)
		{
		  &print_ref_2( $plus{before} , $plus{content} , $plus{after} , @h );
		}
	      else
		{
		  printf STDERR "=%s,%d: %s=>{%s},%s=>{%s} // %s\n",__FILE__,__LINE__,
		    '$#h'   => $#h,
		    '$plus{content}' => $plus{content},
		    '$#h should be 8';
		  die;
		}
	    }
	}
      else
	{
	  print
	    if 1;
	}
    }

  exit(0);
}

sub print_ref_2
{
  my($package,$filename,$line,$proc_name) = caller(0);

  ##my(%param) = @_;
  my($before,$content,$after,
     $tanach,$name_at_the_server,$name_at_WP,$name_to_show,$selection,$from_chapter,$from_verse,$to_chapter,$to_verse
    ) = @_;

  my($return_value) = 0;

  my($new_selection_to_display);
  if($selection ne '')
    {
      $new_selection_to_display = $selection;
    }
  elsif($from_chapter eq $to_chapter)
    {
      $new_selection_to_display = "${from_chapter},${from_verse}–${to_verse}";
    }
  elsif($from_verse == 1)
    {
      $new_selection_to_display = "${from_chapter}–${to_chapter},${to_verse}";
    }
  else
    {
      $new_selection_to_display = "${from_chapter},${from_verse}–${to_chapter},${to_verse}";
    }

  my($new_selection_within_url);
  if($from_chapter eq $to_chapter)
    {
      $new_selection_within_url = "${from_chapter}:${from_verse}-${to_verse}";
    }
  else
    {
      $new_selection_within_url = "${from_chapter}:${from_verse}-${to_chapter}:${to_verse}";
    }

##my($page_at_WP) = $name_to_show ne '' ? "${name_at_WP}|${name_to_show}" : "${name_at_WP}";
  my($page_at_WP) = $name_to_show ne '' ? 		 ${name_to_show}  :  ${name_at_WP};

  my($string_Codex_Leningradensis) = $Codex_Leningradensis_already_linked_once_p ? 'Codex Leningradensis' : '[[Codex Leningradensis]]';

  $Codex_Leningradensis_already_linked_once_p = 1;

  print <<EOF;
${before}${new_selection_to_display}<!-- {{${content}}} --><ref>{{Internetquelle
| url=https://www.tanach.us/Tanach.xml?${name_at_the_server}${new_selection_within_url}
| titel=${page_at_WP} ${new_selection_to_display}
| titelerg=nach dem ${string_Codex_Leningradensis}
| werk=tanach.us
| zugriff=2017-10-09
}}</ref>${after}
EOF

  return $return_value;
}
