#! /usr/bin/perl -w

# usage:
#
#   ~/git-servers/github.com/JochenHayek/misc/perl/fritz-call_list-2-diary--fb_tools.pl ? > $(echo ? ).diary
#
# e.g.:
#
#   ~/git-servers/github.com/JochenHayek/misc/perl/fritz-call_list-2-diary--fb_tools.pl fritz-call_list-2-diary.t/FRITZ-Box_CallList.csv > fritz-call_list-2-diary.t/FRITZ-Box_CallList.csv.diary
#   ~/git-servers/github.com/JochenHayek/misc/perl/fritz-call_list-2-diary--fb_tools.pl ~/'diary.FRITZ!Box_CallList.csv' > ~/diary.FB-CallList

# sample input data:
#
#   sep=,
#   Type,Date,Name,Telephone number,Extension,Telephone Number,Duration
#   ring,2020-09-08 21:26:00,Antonio Guia Furtado,0306251413,,016090104554,0:00
#   in,2020-09-08 21:51:00,Antonio Guia Furtado,0306251413,Yachin*s iPod touch,Internet: 21479880,0:01
#   ring,2020-09-09 10:52:00,Ulrich Plate,030221831160,,016090104554,0:00
#   ring,2020-09-09 10:55:00,Jochen Hayek (atene KOM),030221831853,,016090104554,0:00
#
#   sep=;
#   Type;Date;Name;Telephone number;Extension;Telephone Number;Duration
#   4;18.06.20 10:58;CSX;04024739350;MT-F 80;Internet: 21479999;0:01
#   1;18.06.20 08:27;JGDBX;017173370266;MT-F 80;016090104999;0:01
#   2;16.06.20 08:20;;0245295999;;016090104999;0:00
#
# …

################################################################################

# sample output data:
#
#   ...
#   18 Jun 2020
#           10:58 + 0:01 [_,telecom,phone_call,Type=>outgoing_call] From: "MT-F 80" <Internet: 21479999@fon>; To: "CSX" <04024739350@fon>; Subject: ...
#   ...


################################################################################

use strict;
use warnings FATAL => 'all';

our $std_formatting_options    = { 'separator' => ',', 'assign' => '=>','nameQuoteLeft' => '{', 'nameQuoteRight' => '}', 'valueQuoteLeft' => '{', 'valueQuoteRight' => '}' };
our($separator) = ',';
our(@names);
our($prefix) = '                     ,            ,            ';

{
  use Carp;
  use utf8;

  %main::options = ();
  $main::options{debug} = 0;

  my($proc_name) = '-';

  my(@lines);

  our(@short_month_names) =
    ( 'Jan','Feb','Mar','Apr','May','Jun'
     ,'Jul','Aug','Sep','Oct','Nov','Dec'
     );
  unshift(@short_month_names,''); # in order to have an easier mapping `number : name`

  our(@phone_call_Type) = ( undef,'incoming_call','missed_incoming_call',undef,'outgoing_call');

  while(<>)
    {
    ##chomp;
      s/\s+$//;

      if   ($. == 1)
	{
	  my(@fields) = split(/=/);
	  $main::separator = $fields[1];
	}
      elsif($. == 2)
	{
	##my(@fields) = split(/;/);
	  my(@fields) = split($main::separator);

	  @main::names = @fields;

	  printf STDERR "=%s,%d,%s,%03.3d: %s // %s\n",__FILE__,__LINE__,$proc_name,$.,
	    &main::format_key_value_list($main::std_formatting_options, 
					 "\$#main::names" => $#main::names,
					),
	    '...'
	    if 0;

	  pop(@main::names)
	    if 0;

	  printf STDERR "=%s,%d,%s,%03.3d: %s // %s\n",__FILE__,__LINE__,$proc_name,$.,
	    &main::format_key_value_list($main::std_formatting_options, 
					 "\$#main::names" => $#main::names,
					),
	    '...'
	    if 0;

	  for (my $i=0;$i<=$#main::names;$i++)
	    {
	      $main::name2pos{ $main::names[$i] } = $i;
	    }
	}
      elsif($. > 2)
	{
	##my(@fields) = split(/;/);
	  my(@fields) = split($main::separator);

	  push(@lines, { 'line_no' => $. , 'line' => \@fields } );

	  printf STDERR "=%s,%d,%s,%03.3d: %s // %s\n",__FILE__,__LINE__,$proc_name,$.,
	    &main::format_key_value_list($main::std_formatting_options, 
					 "\$fields[6]" => $fields[6],
					),
	    '...'
	    if 0;
	}
    }

##for (my $i=$#lines;$i>=0;$i--)
  for (my $i=0;$i<=$#lines;$i++)
    {
      &proc_line(
	 'line_rec' => $lines[$i],
	 );
    }
}
#
sub proc_line
{
  my($package,$filename,$line,$proc_name) = caller(0);

  my(%param) = @_;

  my($return_value) = 0;

  printf STDERR ">%s,%d,%s\n",__FILE__,__LINE__,$proc_name
    if 0 && $main::options{debug};

  if(0)
    {
      for (my $i=0;$i<=$#main::names;$i++)
	{
	  printf STDERR "=%s,%d,%s,%03.3d: %s // %s\n",__FILE__,__LINE__,$proc_name,$param{line_rec}{line_no},
	    &main::format_key_value_list($main::std_formatting_options, 
					 $main::names[$i] => $param{line_rec}{line}[$i],
					),
	    '...'
	  ##if 0 && $main::options{debug};
	    if $param{line_rec}{line}[$i] ne '';

	}
    }

  # sample input data:
  #
  #   …
  #
  # sample output data:
  #
  #  … 

  if(0)
    {
      my($amount) = $param{line_rec}{line}[ $main::name2pos{ 'Betrag (€)' } ];
      $amount =~ s/ €$//;
      $amount =~ s/\.//;
      $amount =~ tr/,/./;

      printf STDERR "=%s,%d,%s,%03.3d: %s // %s\n",__FILE__,__LINE__,$proc_name,$param{line_rec}{line_no},
	&main::format_key_value_list($main::std_formatting_options, 
				   ##'$amount' => $amount,
				   ##'$balance' => $balance,
				    ),
	'...'
	if 0;
    }

  printf "\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\"\n",

  ##"YYYY-mm-dd-HH-MM-SS",					# "Datum/0,voll"
    &dd_mm_YYYY_2_YYYY_mm_dd( 'day' => $param{line_rec}{line}[ $main::name2pos{ 'Buchungsdatum' } ] ) . "-HH-MM-SS",					# "Datum/0,voll"
    &dd_mm_YYYY_2_YYYY_mm_dd( 'day' => $param{line_rec}{line}[ $main::name2pos{ 'Buchungsdatum' } ] ),
    &dd_mm_YYYY_2_YYYY_mm_dd( 'day' => $param{line_rec}{line}[ $main::name2pos{ 'Wertstellung' } ] ),

    ' ' x 27,							# 'Buchungstext', but only in the next line
    '999999.99',
  ##$param{line_rec}{line}[ $main::name2pos{ 'Betrag (€)' } ],	# '(Betrag [EUR])',
  ##$amount,
    '999999.99',
  ##$balance,
    if 0;

  my($From);
  my($To);
  if        ($param{line_rec}{line}[ $main::name2pos{ 'Type' } ] eq 'out') # outgoing
    {
      $From = '"' . $param{line_rec}{line}[ $main::name2pos{ 'Extension' } ] . '" <' . $param{line_rec}{line}[ $main::name2pos{ 'Telephone Number' } ] . '@fon>';
      $To   = '"' . $param{line_rec}{line}[ $main::name2pos{ 'Name'      } ] . '" <' . $param{line_rec}{line}[ $main::name2pos{ 'Telephone number' } ] . '@fon>';
    }
  elsif(    ($param{line_rec}{line}[ $main::name2pos{ 'Type' } ] eq 'in') # incoming …
	 || ($param{line_rec}{line}[ $main::name2pos{ 'Type' } ] eq 'ring') # incoming …
       )
    {
      $From = '"' . $param{line_rec}{line}[ $main::name2pos{ 'Name'      } ] . '" <' . $param{line_rec}{line}[ $main::name2pos{ 'Telephone number' } ] . '@fon>';
      $To   = '"' . $param{line_rec}{line}[ $main::name2pos{ 'Extension' } ] . '" <' . $param{line_rec}{line}[ $main::name2pos{ 'Telephone Number' } ] . '@fon>';
    }
  else
    {
      $From = '';
      $To   = '';
    }
	    

  printf "%s + %s [_,telecom,phone_call,%s=>%s] From: %s; To: %s; Subject: ...\n\n",
  ##&dd_mm_YY_HH_MM_2_diary_style( 'day' => $param{line_rec}{line}[ $main::name2pos{ 'Date' } ] ),
    &YYYY_mm_dd_HH_MM_2_diary_style( 'day' => $param{line_rec}{line}[ $main::name2pos{ 'Date' } ] ),
    $param{line_rec}{line}[ $main::name2pos{ 'Duration' } ],

    'Type' =>                     $param{line_rec}{line}[ $main::name2pos{ 'Type' } ],
  ##'Type' => defined( $::phone_call_Type[ $param{line_rec}{line}[ $main::name2pos{ 'Type' } ] ] ) ? $::phone_call_Type[ $param{line_rec}{line}[ $main::name2pos{ 'Type' } ] ] : $param{line_rec}{line}[ $main::name2pos{ 'Type' } ] ,

    $From,
    $To,
    'Telephone Number' => $param{line_rec}{line}[ $main::name2pos{ 'Extension' } ] => $param{line_rec}{line}[ $main::name2pos{ 'Telephone Number' } ],
    ;

  printf STDERR "=%s,%d,%s: %s // %s\n",__FILE__,__LINE__,$proc_name,
    &main::format_key_value_list($main::std_formatting_options, '$return_value' => $return_value ),
    '...'
    if 0 && $main::options{debug};
  printf STDERR "<%s,%d,%s\n",__FILE__,__LINE__,$proc_name
    if 0 && $main::options{debug};
}
#
sub dd_mm_YY_HH_MM_2_diary_style
{
  my($package,$filename,$line,$proc_name) = caller(0);

  my(%param) = @_;

  my($return_value) = '';

  printf STDERR ">%s,%d,%s\n",__FILE__,__LINE__,$proc_name
    if 0 && $main::options{debug};

  if( $param{day} =~ m/^ (?<dd>\d+) \. (?<mm>\d+) \. (?<YY>\d+) \s (?<HH>\d+) : (?<MM>\d+) $/x )
    {
      my(%plus) = %+;

      $return_value = $plus{dd} . ' ' . $::short_month_names[ $plus{mm} ] . " 20$plus{YY}\n\t$plus{HH}:$plus{MM}";
    }
  else
    {
      $return_value = "($param{day})";
    }

  printf STDERR "=%s,%d,%s: %s // %s\n",__FILE__,__LINE__,$proc_name,
    &main::format_key_value_list($main::std_formatting_options, '$return_value' => $return_value ),
    '...'
    if 0 && $main::options{debug};
  printf STDERR "<%s,%d,%s\n",__FILE__,__LINE__,$proc_name
    if 0 && $main::options{debug};

  return $return_value;
}
#
sub YYYY_mm_dd_HH_MM_2_diary_style
{
  my($package,$filename,$line,$proc_name) = caller(0);

  my(%param) = @_;

  my($return_value) = '';

  printf STDERR ">%s,%d,%s\n",__FILE__,__LINE__,$proc_name
    if 0 && $main::options{debug};

  if( $param{day} =~ m/^ (?<YYYY>\d+) - (?<mm>\d+) - (?<dd>\d+) \s+ (?<HH>\d+) : (?<MM>\d+) : (?<SS>\d+) $/x )
    {
      my(%plus) = %+;

      $return_value = $plus{dd} . ' ' . $::short_month_names[ $plus{mm} ] . " $plus{YYYY}\n\t$plus{HH}:$plus{MM}";
    }
  else
    {
      $return_value = "($param{day})";
    }

  printf STDERR "=%s,%d,%s: %s // %s\n",__FILE__,__LINE__,$proc_name,
    &main::format_key_value_list($main::std_formatting_options, '$return_value' => $return_value ),
    '...'
    if 0 && $main::options{debug};
  printf STDERR "<%s,%d,%s\n",__FILE__,__LINE__,$proc_name
    if 0 && $main::options{debug};

  return $return_value;
}
#
sub dd_mm_YYYY_2_YYYY_mm_dd
{
  my($package,$filename,$line,$proc_name) = caller(0);

  my(%param) = @_;

  my($return_value) = '';

  printf STDERR ">%s,%d,%s\n",__FILE__,__LINE__,$proc_name
    if 0 && $main::options{debug};

  if( $param{day} =~ m/^ (?<dd>\d+) \. (?<mm>\d+) \. (?<YYYY>\d+) $/x )
    {
      my(%plus) = %+;

      $return_value = "$plus{YYYY}-$plus{mm}-$plus{dd}";
    }
  else
    {
      $return_value = "($param{day})";
    }

  printf STDERR "=%s,%d,%s: %s // %s\n",__FILE__,__LINE__,$proc_name,
    &main::format_key_value_list($main::std_formatting_options, '$return_value' => $return_value ),
    '...'
    if 0 && $main::options{debug};
  printf STDERR "<%s,%d,%s\n",__FILE__,__LINE__,$proc_name
    if 0 && $main::options{debug};

  return $return_value;
}
#
sub format_key_value_list 
{
  my($package,$filename,$line,$proc_name) = caller(0);

  my $refOptions = shift(@_);

  my $buf;

  confess '!defined($refOptions)' unless defined($refOptions);

  my %options = %{$refOptions};

  foreach my $i ('separator', 'assign', 'nameQuoteLeft', 'nameQuoteRight', 'valueQuoteLeft', 'valueQuoteRight') {
    $options{$i} = '' unless defined($options{$i});
  }

  my ($name,$value);
  while($#_ >=0) {
    ($name,$value) = splice(@_,0,2);

    carp '!defined($name)'  unless defined $name;
    carp "\$name=>{$name},!defined(\$value)" unless defined $value;

    my $chunk = "$options{nameQuoteLeft}${name}$options{nameQuoteRight}$options{assign}$options{valueQuoteLeft}${value}$options{valueQuoteRight}";
    if (defined($buf)) {
      $buf .= "$options{separator}$chunk";
    } else {
      $buf  =                     $chunk;
    }
  }

  return $buf;
}
