#! /usr/bin/perl -sw

# $ ~/Computers/Programming/Languages/Perl/csv_extract_section.pl -section=1 < /media/NAS/johayek/_banks/BIC-PBNKDEFF/IBAN-DE81100100100637224104/vouchers--SKR03-1200/999990-000--20150428______--Telekom_Festnetz_BLN-4968976753--period-201505/2015_05_Rechnung_4968976753.csv 

# Jochen Hayek defining a CSV file section:
# a section is delimited by an empty (resp. white-space-only) line, start of file or EOF.

use strict;
use warnings FATAL => 'all';

##use English;

##use utf8;

{
##local($INPUT_RECORD_SEPARATOR) = "\r\n";
##local($OUTPUT_RECORD_SEPARATOR) = "\n";

  our($section);		# gets its value through -s : "enable rudimentary parsing for switches after programfile"

  my($current_section) = 0;

##binmode( STDIN  , ":encoding(ISO-8859-1)" ); # guessing from Encode::Supported
##binmode( STDOUT , ":encoding(UTF-8)" );
##binmode( STDOUT , ":encoding(ISO-8859-1)" );

##while(<>)	# cannot use <>, because "binmode(STDIN,...)" does not apply on it
  while(<STDIN>)
    {
      chomp;

      printf STDERR "*** %s=>{%s} // %s\n",
        'length($_)' => length($_),
        '...'
        if 0;

    ##if($_ eq '')
      if(m/^\s*$/)
	{
	  $current_section++;
	}
      elsif($current_section == $section)
	{
	  print;
	  print "\n";
	}
    }
}
