#! /usr/bin/perl -w

# usage:
#
# $ cd ~/git-servers/github.com/JochenHayek/misc/tanach/
# $ ./parascha--haftara.pl          parascha.wiki.0--in.txt >          parascha.wiki.1--out.txt
# $ ./parascha--haftara.pl parascha--haftara.wiki.0--in.txt > parascha--haftara.wiki.1--out.txt

# [http://www.obohu.cz/bible?styl=BRU&vs=ano&lang=de&k=Iz&kap=42&verses=5 42,5–25]

{
  # https://de.wikipedia.org/wiki/Vorlage:Bibel
  # https://de.wikipedia.org/wiki/Wikipedia:Wie_zitiert_man_Bibelstellen

  my(%usual2obohu) = (

    '1. Buch Mose' => 'Gn',
    '2. Buch Mose' => 'Ex',
    '3. Buch Mose' => 'Lv',
    '4. Buch Mose' => 'Nu',
    '5. Buch Mose' => 'Dt',

    'Gen'          => 'Gn',
  ##'Ex'           => 'Ex',
    'Lev'          => 'Lv',
    'Num'          => 'Nu',
    'Dtn'          => 'Dt',

    'Jos'     => 'Joz',		# Josua
    'Richter' => 'Sd',		# Richter
  ##''        => 'Rt',		# Rut
    '1 Sam'   => '1S',
    '2 Sam'   => '2S',
    '1 Kön'   => '1Kr',
    '2 Kön'   => '2Kr',
    '1 Chr'   => '1Pa',		# Chronik…
    '2 Chr'   => '2Pa',		# Chronik…
  ##''        => 'Ezd',		# Esra
  ##''        => 'Neh',		# Nehemia
  ##''        => '',		# Ester
  ##''        => '',		# Hiob
  ##''        => '',		# Psalmen 
  ##''        => '',		# Sprichwörter
  ##''        => '',		# Prediger
  ##''        => '',		# Hoheslied
    'Jesaja'  => 'Iz',
    'Jeremia' => 'Jr',		# Jeremia
  ##''        => '',		# Klagelieder
    'Ezechiel'=> 'Ez',		# Ezechiel
  ##''        => '',		# Daniel
    'Hosea'   => 'Oz',		# Hosea
  ##''        => '',		# Joel
    'Amos'    => 'Am',		# Amos
    'Obadja'  => 'Abd',		# Obadja
  ##''        => '',		# Jona
    'Micha'   => 'Mi',		# Micha
  ##''        => '',		# Nahum
  ##''        => '',		# Habakuk
  ##''        => '',		# Zefanja
  ##''        => '',		# Haggai
    'Sacharja'=> 'Za',		# Sacharja
    'Maleachi'=> 'Mal',		# Maleachi
  ##''        => '',		# 
    );

  while(<>)
    {
      if   (0)
	{
	  print;
	}
      elsif(m/^       \| \s+ (?<no>\d*(a|s)?)
	        \s+ \|\| \s+ (?<name>.*?)
	        \s+ \|\| \s+ (?<loc_readable>.*?)
                \s+ \|\| \s+ (?<loc0>.*?)
                \s+ \|\| \s+ (?<loc_clickable_1>.*?)
                \s+ \|\| \s+ (?<loc_clickable_2>.*?)
                \s+ \|\| \s+ (?<loc_clickable_3>.*?)
                \s+ \|\| \s+ (?<Liss>.*?)
                \s+ \|\| \s+ (?<Abweichung>.*?)
	    /x)
	{
	  my(%plus) = %+;

	  printf STDERR "\n=%03.3d: %s=>{%s},%s=>{%s},%s=>{%s},%s=>{%s},%s=>{%s},%s=>{%s} // %s\n",__LINE__,
	    '$plus{no}' => $plus{no},
	    '$plus{name}' => $plus{name},
	    '$plus{loc_readable}' => $plus{loc_readable},
	    '$plus{loc0}' => $plus{loc0},
	    '$plus{Liss}' => $plus{Liss},
	    '$plus{Abweichung}' => $plus{Abweichung},
	    '...'
	    if 0;

	  printf STDERR "\n=%03.3d: %s=>{%s},%s=>{%s} // %s\n",__LINE__,
	    '$plus{no}' => $plus{no},
	    '$plus{loc0}' => $plus{loc0},
	    '...'
	    if 1;

	  my(%new_list0_of_loc_with_string);
	  my(%new_list0_of_loc_with_list);
	  my(%new_list1_of_loc_with_string);
	  my(%new_list1_of_loc_with_list);
	  foreach my $loc ('EU','BRU','NHTS')
	    {
	      my(@l) =
		split(/;<br \/>/,
		      $plus{loc0},
		     );
	      foreach my $e (@l)
		{
		  printf STDERR "=%03.3d: %s=>{%s},%s=>{%s} // %s\n",__LINE__,
		    '$plus{no}' => $plus{no},
		    '$e' => $e,
		    '...'
		    if 1;

		  my($h0) = $e;

		  $h0 =~ s/\|BHS\}\}$/|${loc}}}/;

		  printf STDERR "=%03.3d: %s=>{%s},%s=>{%s},%s=>{%s} // %s\n",__LINE__,
		    '$plus{no}' => $plus{no},
		    '$e' => $e,
		    '$h0' => $h0,
		    '...'
		    if 1;

		  my($h1) = '';

		##$h1 =~ s/^ \{\{ (?<Vorlage>[^|]*) \| (?<chapter>[^|]*) \| (?<verses>[^|]*) \| BHS \}\} $/|${loc}}}/x;
		  if( $e =~ m/^ \{\{ (?<Vorlage>[^\|]*) \| (?<book>[^\|]*) \| (?<chapter>[^\|]*) \| (?<verses>[^\|]*) \| BHS \}\} $/x )
		##if( $e =~ m/^ \{\{ (?<Vorlage>[^\|]*) \| (?<book>[^\|]*) \| (?<chapter>[^\|]*) \| 				   /x )
		##if( $e =~ m/^ \{\{ (?<Vorlage>[^\|]*) \| (?<book>[^\|]*) \| (?<chapter>[^\|]*) 				   /x )
		##if( $e =~ m/^ \{\{ (?<Vorlage>[^\|]*) \|						                           /x )
		    {
		      my(%plus1) = %+;

		      printf STDERR "=%03.3d: %s=>{%s},%s=>{%s},%s=>{%s} // %s\n",__LINE__,
			'$plus{no}' => $plus{no},
			'$e' => $e,
			'$plus1{chapter}' => $plus1{chapter},
			'...'
			if 1;

		      my($book);
		      if(  exists($usual2obohu{$plus1{book}})  )
			{
			  $book = $usual2obohu{$plus1{book}};
			}
		      else
			{
			  $book = $plus1{book};
			  $book =~ tr/ /_/;
			}

		      # http://www.obohu.cz/bible?styl=BRU&vs=ano&lang=de&k=Iz&kap=42&verses=5
		      $h1 = $plus1{chapter} .
			    ( $plus1{verses} ne '' ? ',' . $plus1{verses} : '' ) .
			    ' ' .

			    '[http://www.obohu.cz/bible?styl=' . $loc . '&vs=ano&lang=de&k=' . $book . '&kap=' . $plus1{chapter} . '&verses=' . $plus1{verses} .
			    ' ' .

			    $loc .
			    ']';

		    ##$h1 = $plus1{chapter};
		    ##$h1 = '999';
		    }

		  push(@{$new_list0_of_loc_with_list{ $loc }},$h0);
		  push(@{$new_list1_of_loc_with_list{ $loc }},$h1);
		}

	      $new_list0_of_loc_with_string{ $loc } =
		join(';<br />',
		     @{$new_list0_of_loc_with_list{ $loc }},
		    );

	      $new_list1_of_loc_with_string{ $loc } =
		join(';<br />',
		     @{$new_list1_of_loc_with_list{ $loc }},
		    );

	      printf STDERR "\n=%03.3d: %s=>{%s},%s=>{%s},%s=>{%s} // %s\n",__LINE__,
		'$plus{no}' => $plus{no},
		'$plus{loc0}' => $plus{loc0},
		"\$new_list0_of_loc_with_string{ $loc }" => $new_list0_of_loc_with_string{ $loc },
		'...'
		if 1;
	    }

	  print  "|-\n";
	  printf "| %s || %s || %s || %s || %s || %s || %s || %s || %s\n",
	    $plus{no},
	    $plus{name},
	    $plus{loc_readable},
	    $plus{loc0},

	    $new_list0_of_loc_with_string{ EU },
	    $new_list1_of_loc_with_string{ BRU },
	    $new_list1_of_loc_with_string{ NHTS },

	    $plus{Liss},
	    $plus{Abweichung},
	    ;
	}
    }
}
