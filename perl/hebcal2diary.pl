#! /usr/bin/perl -ws

# http://www.hebcal.com/sedrot/
#   Download for Diaspora
#     Microsoft Outlook CSV
#
# …/hebcal--torah-readings2diary.pl hebcal--torah-readings-diaspora.csv > hebcal--torah-readings-diaspora.diary

# "Subject","Start Date","Start Time","End Date","End Time","All day event","Description","Show time as","Location"
# "Parashat Shemot","1/2/2016",,,,"true","","3","Jewish Holidays"

# "Parashat Shemot" -> http://www.hebcal.com/sedrot/Shemot
# "1/2/2016" -> 02 01 ((resp. January)) 2016

our $std_formatting_options = { 'separator' => ',', 'assign' => '=>', 'lhs_quoteLeft' => '{', 'lhs_quoteRight' => '}', 'rhs_quoteLeft' => '{', 'rhs_quoteRight' => '}' };
our $json_formatting_options = { 'separator' => ',', 'assign' => ':', 'lhs_quoteLeft' => '"', 'lhs_quoteRight' => '"', 'rhs_quoteLeft' => '"', 'rhs_quoteRight' => '"' };

{
  use utf8;

  use open IO => ':utf8';

  use Carp;
##use FileHandle;

  %main::options = ();
  $main::options{debug} = 1;

  if   (!defined($main::date_format))
    {
      die "!defined(\$main::date_format)";
    }
  elsif($main::date_format eq 'day-month-year')
    {
    }
  elsif($main::date_format eq 'month-day-year')
    {
    }
  else
    {
      printf STDERR "=%03.3d: %s\n",__LINE__,
	&main::format_key_value_list($main::std_formatting_options, '$main::date_format' => $main::date_format ),
	if 1 && $main::options{debug};
      die;
    }
  printf STDERR "=%03.3d: %s\n",__LINE__,
    &main::format_key_value_list($main::std_formatting_options, '$main::date_format' => $main::date_format ),
    if 1 && $main::options{debug};
}

{
  %main::title2pos = ();
  @main::pos2title = ();
  @main::month_names = ('---','Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec');

  %main::Subject_hebcal2jewiki =

    # === [[1. Buch Mose|Bereschit (1. Buch Mose - Genesis)]] ===

    ("Parashat Bereshit"      	   => {"t" => "Bereschit_(Parascha)", "de" => "Am Anfang"              , "loc" => "Gen 1,1-6,8"     , "he" => "בראשית"},        
     "Parashat Noach"         	   => {"t" => "Noach_(Parascha)"    , "de" => "Noah"                   , "loc" => "Gen 6,9-11,32"   , "he" => "נח"},            
     "Parashat Lech-Lecha"    	   => {"t" => "Lech Lecha"          , "de" => "Gehe für dich"          , "loc" => "Gen 12,1-17,27"  , "he" => "לך לך"},         
     "Parashat Vayera"        	   => {"t" => "Wajera"              , "de" => "Und es erschien"        , "loc" => "Gen 18,1-22,24"  , "he" => "וירא"},          
     "Parashat Chayei Sara"   	   => {"t" => "Chaje Sara"          , "de" => "Das Leben Saras"        , "loc" => "Gen 23,1-25,18"  , "he" => "חיי שרה"},       
     "Parashat Toldot"        	   => {"t" => "Toledot"             , "de" => "Geschlechter"           , "loc" => "Gen 25,19-28,9"  , "he" => "תולדות"},        
     "Parashat Vayetzei"      	   => {"t" => "Wajeze"              , "de" => "Und er zog aus"         , "loc" => "Gen 28,10-32,3"  , "he" => "ויצא"},          
     "Parashat Vayishlach"    	   => {"t" => "Wajischlach"         , "de" => "Und er schickte"        , "loc" => "Gen 32,4-36,43"  , "he" => "וישלח"},         
     "Parashat Vayeshev"      	   => {"t" => "Wajeschew"           , "de" => "Und er wohnte"          , "loc" => "Gen 37,1-40,23"  , "he" => "וישב"},          
     "Parashat Miketz"        	   => {"t" => "Mikez"               , "de" => "Am Ende"                , "loc" => "Gen 41,1-44,17"  , "he" => "מקץ"},           
     "Parashat Vayigash"      	   => {"t" => "Wajigasch"           , "de" => "Und er trat heran"      , "loc" => "Gen 44,18-47,27" , "he" => "ויגש"},          
     "Parashat Vayechi"       	   => {"t" => "Wajechi"             , "de" => "Und er lebte"           , "loc" => "Gen 47,28-50,26" , "he" => "ויחי"},          

     # === [[2. Buch Mose|Sch'mot (2. Buch Mose - Exodus)]] ===

     "Parashat Shemot"        	   => {"t" => "Schemot_(Parascha)"  , "de" => "Namen"                  , "loc" => "Ex 1,1-6,1"      , "he" => "שמות"},    
     "Parashat Vaera"         	   => {"t" => "Wa'era"              , "de" => "Und ich erschien"       , "loc" => "Ex 6,2-9,35"     , "he" => "וארא"},    
     "Parashat Bo"            	   => {"t" => "Bo_(Parascha)"       , "de" => "Komm"                   , "loc" => "Ex 10,1-13,16"   , "he" => "בא"},      
     "Parashat Beshalach"     	   => {"t" => "Beschalach"          , "de" => "Als er ziehen ließ"     , "loc" => "Ex 13,17-17,16"  , "he" => "בשלח"},    
     "Parashat Yitro"         	   => {"t" => "Jitro_(Parascha)"    , "de" => "Jitro"                  , "loc" => "Ex 18,1-20,23"   , "he" => "יתרו"},    
     "Parashat Mishpatim"     	   => {"t" => "Mischpatim"          , "de" => "Rechte"                 , "loc" => "Ex 21,1-24,18"   , "he" => "משפטים"},  
     "Parashat Terumah"       	   => {"t" => "Teruma"              , "de" => "Hebopfer"               , "loc" => "Ex 25,1-27,19"   , "he" => "תרומה"},   
     "Parashat Tetzaveh"      	   => {"t" => "Tezawe"              , "de" => "Du sollst befehlen"     , "loc" => "Ex 27,20-30,10"  , "he" => "תצוה"},    
     "Parashat Ki Tisa"       	   => {"t" => "Ki_Tissa"            , "de" => "Wenn du erhebst"        , "loc" => "Ex 30,11-34,35"  , "he" => "כי תשא"},  
     "Parashat Vayakhel-Pekudei"   => {"t" => "Wajakhel_+_Pekude"   , "de" => ""                       , "loc" => ""                , "he" => ""},
     "Parashat Vayakhel"      	   => {"t" => "Wajakhel"            , "de" => "Und er versammelte"     , "loc" => "Ex 35,1-38,20"   , "he" => "ויקהל"},   
     "Parashat Pekudei"       	   => {"t" => "Pekude"              , "de" => "Die Zählungen"          , "loc" => "Ex 38,21-40,38"  , "he" => "פקודי"},   

     # === [[3. Buch Mose|Wajikra (3. Buch Mose - Leviticus)]] ===

     "Parashat Tazria-Metzora"      => {"t" => "Tazria_+_Metzora"               , "de" => ""                       , "loc" => ""                , "he" => ""},
     "Parashat Achrei Mot-Kedoshim" => {"t" => "Achare_Mot_+_Kedoschim"         , "de" => ""                       , "loc" => ""                , "he" => ""},
     "Parashat Behar-Bechukotai"    => {"t" => "Behar_(Parascha)_+_Bechukotaj"  , "de" => ""                       , "loc" => ""                , "he" => ""},

     "Parashat Vayikra"       	   => {"t" => "Wajikra_(Parascha)"  , "de" => "Und er rief"            , "loc" => "Lev 1,1-5,26"    , "he" => "ויקרא"},    
     "Parashat Tzav"          	   => {"t" => "Zaw"                 , "de" => "Gebiete!"               , "loc" => "Lev 6,1-8,36"    , "he" => "צו"},       
     "Parashat Shmini"        	   => {"t" => "Schemini"            , "de" => "Achter"                 , "loc" => "Lev 9,1-11,47"   , "he" => "שמיני"},    
     "Parashat Tazria"        	   => {"t" => "Tasria"              , "de" => "Sie empfängt"           , "loc" => "Lev 12,1-13,59"  , "he" => "תזריע"},    
     "Parashat Metzora"       	   => {"t" => "Mezora"              , "de" => "Aussätziger"            , "loc" => "Lev 14,1-15,33"  , "he" => "מצורע"},    
     "Parashat Achrei Mot"    	   => {"t" => "Achare_Mot"          , "de" => "Nach dem Tode"          , "loc" => "Lev 16,1-18,30"  , "he" => "אחרי מות"}, 
     "Parashat Kedoshim"      	   => {"t" => "Kedoschim"           , "de" => "Heilige"                , "loc" => "Lev 19,1-20,27"  , "he" => "קדושים"},   
     "Parashat Emor"          	   => {"t" => "Emor"                , "de" => "Sage"                   , "loc" => "Lev 21,1-24,23"  , "he" => "אמור"},     
     "Parashat Behar"         	   => {"t" => "Behar_(Parascha)"    , "de" => "Auf dem Berge"          , "loc" => "Lev 25,1-26,2"   , "he" => "בהר"},      
     "Parashat Bechukotai"    	   => {"t" => "Bechukotaj"          , "de" => "In meinen Satzungen"    , "loc" => "Lev 26,3-27,34"  , "he" => "בחוקותי"},  

     # === [[4. Buch Mose|Bemidbar (4. Buch Mose - Numeri)]] ===

     "Parashat Matot-Masei"   	   => {"t" => "Mattot_+_Mass'e"     , "de" => ""                       , "loc" => ""                , "he" => ""},

     "Parashat Bamidbar"      	   => {"t" => "Bemidbar_(Parascha)" , "de" => "In der Wüste"           , "loc" => "Num 1,1-4,20"    , "he" => "במדבר"},
     "Parashat Nasso"         	   => {"t" => "Nasso"               , "de" => "Erhebe"                 , "loc" => "Num 4,21-7,89"   , "he" => "נשא"},
     "Parashat Beha'alotcha"  	   => {"t" => "Beha'alotcha"        , "de" => "Wenn du anzündest"      , "loc" => "Num 8,1-12,16"   , "he" => "בהעלותך"},
     "Parashat Sh'lach"       	   => {"t" => "Schelach Lecha"      , "de" => "Schicke!"               , "loc" => "Num 13,1-15,41"  , "he" => "שלח לך"},
     "Parashat Korach"        	   => {"t" => "Korach_(Parascha)"   , "de" => "Korach"                 , "loc" => "Num 16,1-18,32"  , "he" => "קרח"},
     "Parashat Chukat"        	   => {"t" => "Chukkat"             , "de" => "Satzung"                , "loc" => "Num 19,1-22,1"   , "he" => "חֻקַּת"},
     "Parashat Balak"         	   => {"t" => "Balak_(Parascha)"    , "de" => "Balak"                  , "loc" => "Num 22,2-25,9"   , "he" => "בלק"},
     "Parashat Pinchas"       	   => {"t" => "Pinchas_(Parascha)"  , "de" => "Pinchas"                , "loc" => "Num 25,10-30,1"  , "he" => "פינחס"},
     "Parashat Matot"         	   => {"t" => "Mattot"              , "de" => "Stämme"                 , "loc" => "Num 30,2-32,42"  , "he" => "מטות"},
     "Parashat Masei"         	   => {"t" => "Mass'e"              , "de" => "Reisen"                 , "loc" => "Num 33,1-36,13"  , "he" => "מסעי"},

     # === [[5. Buch Mose|Dewarim (5. Buch Mose - Deuteronomium)]] ===

     "Parashat Nitzavim-Vayeilech" => {"t" => "Nizawim_+_Wajelech"  , "de" => ""                       , "loc" => ""                , "he" => ""},

     "Parashat Devarim"       	   => {"t" => "Dewarim_(Parascha)"  , "de" => "Reden"                  , "loc" => "Dtn 1,1-3,22"    , "he" => "דברים"},
     "Parashat Vaetchanan"    	   => {"t" => "Waetchanan"          , "de" => "Ich flehte"             , "loc" => "Dtn 3,23-7,11"   , "he" => "ואתחנן"},
     "Parashat Eikev"         	   => {"t" => "Ekew"                , "de" => "Sofern"                 , "loc" => "Dtn 7,12-11,25"  , "he" => "עקב"},
     "Parashat Re'eh"         	   => {"t" => "Re'eh"               , "de" => "Siehe!"                 , "loc" => "Dtn 11,26-16,17" , "he" => "ראה"},
     "Parashat Shoftim"       	   => {"t" => "Schoftim_(Parascha)" , "de" => "Richter"                , "loc" => "Dtn 16,18-21,9"  , "he" => "שֹׁפְטִים"},
     "Parashat Ki Teitzei"    	   => {"t" => "Ki_Teze"             , "de" => "Wenn du ziehst"         , "loc" => "Dtn 21,10-25,19" , "he" => "כִּי-תֵצֵא"},
     "Parashat Ki Tavo"       	   => {"t" => "Ki_Tawo"             , "de" => "Wenn du kommst"         , "loc" => "Dtn 26,1-29,8"   , "he" => "כִּי-תָבוֹא"},
     "Parashat Nitzavim"      	   => {"t" => "Nizawim"             , "de" => "Ihr steht"              , "loc" => "Dtn 29,9-30,20"  , "he" => "ניצבים"},
     "Parashat Vayeilech"     	   => {"t" => "Wajelech"            , "de" => "Und er ging"            , "loc" => "Dtn 31,1-30"     , "he" => "וילך"},
     "Parashat Ha'Azinu"      	   => {"t" => "Ha'asinu"            , "de" => "Höret!"                 , "loc" => "Dtn 32,1-52"     , "he" => "הַאֲזִינוּ"},
     "Parashat Vezot Haberakhah"   => {"t" => "Wesot_Habracha"      , "de" => "Und dies ist der Segen" , "loc" => "Dtn 33,1-34,12"  , "he" => "וזאת הברכה"},
    );
}

{
  $/ = "\r\n";
  while(<>)
    {
      chomp;

      my(@columns) = split(/,/);
      my($i) = -1;

      if($. == 1)
	{
	  foreach my $column (@columns)
	    {
	      $i++;

	      if($column =~ m/^ " (?<core> .* ) " $/x)
		{
		  $columns[$i] = $+{core};
		}
	      else
		{
		  printf STDERR "=%03.3d: %s\n",__LINE__,
		    &main::format_key_value_list($main::std_formatting_options, "\$columns[$i]" => $column ),
		    if 1 && $main::options{debug};
		  die "\$column is not quoted as expected";
		}

	      printf STDERR "=%03.3d: %s\n",__LINE__,
		&main::format_key_value_list($main::std_formatting_options, "\$columns[$i]" => $columns[$i] ),
		if 0 && $main::options{debug};

	      $main::title2pos{ $columns[$i] } = $i;
	      $main::pos2title[ $i ] = $columns[$i];
	    }

	  printf STDERR "=%03.3d: %s\n",__LINE__,
	    &main::format_key_value_list($main::std_formatting_options, '$columns[0]' => $columns[0] ),
	    if 0 && $main::options{debug};
	}
      else
	{
	  foreach my $column (@columns)
	    {
	      $i++;

	      if($column =~ m/^ " (?<core> .* ) " $/x)
		{
		  $columns[$i] = $+{core};
		}
	      elsif( ($column !~ m/^ " /x) && ($column !~ m/ " $/x) )
		{
		  $columns[$i] = $+{core};
		}
	      else
		{
		  printf STDERR "=%03.3d: %s\n",__LINE__,
		    &main::format_key_value_list($main::std_formatting_options, "\$columns[$i]" => $column ),
		    if 1 && $main::options{debug};
		  die "\$column is not quoted as expected";
		}

	      printf STDERR "=%03.3d: %s\n",__LINE__,
		&main::format_key_value_list($main::std_formatting_options, "\$columns[$i]" => $columns[$i] ),
		if 0 && $main::options{debug};

	      $values{ $main::pos2title[$i] } = $columns[$i];
	    }

	  ################################################################################

	  printf STDERR "=%03.3d: %s\n",__LINE__,
	    &main::format_key_value_list($main::std_formatting_options, 'Subject' => $values{Subject}, 'Start Date' => $values{'Start Date'} ),
	    if 0 && $main::options{debug};

	  my(%Start_Date);
	  if($values{'Start Date'} =~ m(^ (?<A>\d+) / (?<B>\d+) / (?<year>\d+) $)x)
	##if($values{'Start Date'} =~ m(^ (?<day>\d+) / (?<month>\d+) / (?<year>\d+) $)x)
      ####if($values{'Start Date'} =~ m(^ (?<month>\d+) / (?<day>\d+) / (?<year>\d+) $)x)
	    {
	    ##%Start_Date = %+;
	      if  ($main::date_format eq 'day-month-year')
		{
		  %Start_Date = ('day'=>$+{A},'month'=>$+{B},'year'=>$+{year});
		}
	      elsif($main::date_format eq 'month-day-year')
		{
		  %Start_Date = ('month'=>$+{A},'day'=>$+{B},'year'=>$+{year});
		}
	    }
	  else
	    {
	      printf STDERR "=%03.3d: %s\n",__LINE__,
		&main::format_key_value_list($main::std_formatting_options, 'Subject' => $values{Subject}, 'Start Date' => $values{'Start Date'} ),
		if 1 && $main::options{debug};
	      die;
	    }
	  printf STDERR "=%03.3d: %s\n",__LINE__,
	    &main::format_key_value_list($main::std_formatting_options,
					 'Subject'            => $values{Subject},
					 'Start Date'         => $values{'Start Date'},
					 '$Start_Date{year}'  => $Start_Date{year},
					 '$Start_Date{month}' => $Start_Date{month},
					 '$Start_Date{day}'   => $Start_Date{day},
	    ),
	    if 0 && $main::options{debug};

	  printf "%02d %s %s\n",
	    $Start_Date{day},
	    $main::month_names[$Start_Date{month}],
	    $Start_Date{year},
	    ;
	  printf "\t%s %s %s",
	    'HH:MM',
	    '[hebcal,misc]  ', # Outlook + ...
	    &main::format_key_value_list($main::std_formatting_options, 'Location' => $values{Location}, 'Subject' => $values{Subject} ),
	    if 1;
	  printf ",%s",
	    &main::format_key_value_list($main::std_formatting_options, 'Description' => $values{Description} ),
	    if $values{Description} ne '';
	  if($values{Subject} =~ m/^ Parashat \s+ (?<parasha>.*) $/x)
	    {
	      if(exists($Subject_hebcal2jewiki{ $values{Subject} }))
		{
		  printf ",%s",
		    &main::format_key_value_list($main::std_formatting_options,
						 'de'  => $Subject_hebcal2jewiki{ $values{Subject} }{de},
						 'loc' => $Subject_hebcal2jewiki{ $values{Subject} }{loc},
						 'he'  => $Subject_hebcal2jewiki{ $values{Subject} }{he},
		    );
		}
	    }
	  printf "\n",
	    if 1;
	  
	  if($values{Subject} =~ m/^ Parashat \s+ (?<parasha>.*) $/x)
	    {
	      my($parasha) = $+{parasha};
	      my($parasha_lc) = lc($+{parasha});

	      $parasha_lc =~ s/[\s+-]//g;

	      printf "\t%s %s %s%s\n",
		'HH:MM',
		'[hebcal,hebcal]',
		'http://www.hebcal.com/sedrot/',
		$parasha_lc,
		;

	    ##my($jewiki_Subject) = $values{Subject};
	      my($jewiki_Subject) = exists($Subject_hebcal2jewiki{ $values{Subject} }) ? $Subject_hebcal2jewiki{ $values{Subject} }{t} : "(($values{Subject}))";

	      printf "\t%s %s %s%s\n",
		'HH:MM',
		'[hebcal,jewiki]',
		'http://www.jewiki.net/wiki/',

	      ##$parasha,
		$jewiki_Subject,

		;
	    }
	  else
	    {
	      printf STDERR "=%03.3d: %s\n",__LINE__,
		&main::format_key_value_list($main::std_formatting_options, 'Subject' => $values{Subject}, 'Start Date' => $values{'Start Date'} ),
		if 0 && $main::options{debug};
	    }
	}
    }
}
#
sub format_key_value_list {
  my $refOptions = shift(@_);

  my $buf;

  confess '!defined($refOptions)' unless defined($refOptions);

  my %options = %{$refOptions};

  foreach my $i ('separator', 'assign', 'quoteLeft', 'quoteRight') {
    $options{$i} = '' unless defined($options{$i});
  }

  my ($name,$value);
  while($#_ >=0) {
    ($name,$value) = splice(@_,0,2);

    my $chunk = "$options{lhs_quoteLeft}$name$options{lhs_quoteRight}$options{assign}$options{rhs_quoteLeft}$value$options{rhs_quoteRight}";
    if (defined($buf)) {
      $buf .= "$options{separator}$chunk";
    } else {
      $buf  =                     $chunk;
    }
  }

  return $buf;
}
