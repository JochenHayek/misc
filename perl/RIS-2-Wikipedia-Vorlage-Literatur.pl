#! /usr/bin/perl -w

# STDIN:
#   https://en.wikipedia.org/wiki/RIS_(file_format)
#
# STDOUT
#   https://de.wikipedia.org/wiki/Vorlage:Literatur

# manual pre-processing:
#
# * http://www.worldcat.org
# * go to tab Books
# * enter ISBN
# * Cite/Export
# * "Export to EndNote / Reference Manager(non-Latin)"
# * "WorldCat_*.ris"

# manual post-processing:
#
# * Autor : re-order 1st and last name, …
# * Datum : …
# * ISBN/ISSN : …

{
  %tags =
    (
      'TY' => '...',	# Type of reference (must be the first tag)
      'A1' => '...',	# First Author
      'A2' => '...',	# Secondary Author (each author on its own line preceded by the tag)
      'A3' => '...',	# Tertiary Author (each author on its own line preceded by the tag)
      'A4' => '...',	# Subsidiary Author (each author on its own line preceded by the tag)
      'AB' => '...',	# Abstract
      'AD' => '...',	# Author Address
      'AN' => '...',	# Accession Number
      'AU' => 'Autor',	# Author (each author on its own line preceded by the tag)
      'AV' => '...',	# Location in Archives
      'BT' => '...',	# This field maps to T2 for all reference types except for Whole Book and Unpublished Work references. It can contain alphanumeric characters. There is no practical limit to the length of this field.
      'C1' => '...',	# Custom 1
      'C2' => '...',	# Custom 2
      'C3' => '...',	# Custom 3
      'C4' => '...',	# Custom 4
      'C5' => '...',	# Custom 5
      'C6' => '...',	# Custom 6
      'C7' => '...',	# Custom 7
      'C8' => '...',	# Custom 8
      'CA' => '...',	# Caption
      'CN' => '...',	# Call Number
      'CP' => '...',	# This field can contain alphanumeric characters. There is no practical limit to the length of this field.
      'CT' => '...',	# Title of unpublished reference
      'CY' => 'Ort',	# Place Published
      'DA' => '...',	# Date
      'DB' => '...',	# Name of Database
      'DO' => '...',	# DOI
      'DP' => '...',	# Database Provider
      'ED' => '...',	# Editor
      'EP' => '...',	# End Page
      'ET' => '...',	# Edition
      'ID' => 'OCLC',	# Reference ID -- JH: supposing: DB="/z-wcorg/" and DP="http://worldcat.org"
      'IS' => '...',	# Issue number
      'J1' => '...',	# Periodical name: user abbreviation 1. This is an alphanumeric field of up to 255 characters.
      'J2' => '...',	# Alternate Title (this field is used for the abbreviated title of a book or journal name, the latter mapped to T2)
      'JA' => '...',	# Periodical name: standard abbreviation. This is the periodical in which the article was (or is to be, in the case of in-press references) published. This is an alphanumeric field of up to 255 characters.
      'JF' => '...',	# Journal/Periodical name: full format. This is an alphanumeric field of up to 255 characters.
      'JO' => '...',	# Journal/Periodical name: full format. This is an alphanumeric field of up to 255 characters.
      'KW' => '...',	# Keywords (keywords should be entered each on its own line preceded by the tag)
      'L1' => '...',	# Link to PDF. There is no practical limit to the length of this field. URL addresses can be entered individually, one per tag or multiple addresses can be entered on one line using a semi-colon as a separator.
      'L2' => '...',	# Link to Full-text. There is no practical limit to the length of this field. URL addresses can be entered individually, one per tag or multiple addresses can be entered on one line using a semi-colon as a separator.
      'L3' => '...',	# Related Records. There is no practical limit to the length of this field.
      'L4' => '...',	# Image(s). There is no practical limit to the length of this field.
      'LA' => 'Sprache',# Language
      'LB' => '...',	# Label
      'LK' => '...',	# Website Link
      'M1' => '...',	# Number
      'M2' => '...',	# Miscellaneous 2. This is an alphanumeric field and there is no practical limit to the length of this field.
      'M3' => '...',	# Type of Work
      'N1' => '...',	# Notes
      'N2' => '...',	# Abstract. This is a free text field and can contain alphanumeric characters. There is no practical length limit to this field.
      'NV' => '...',	# Number of Volumes
      'OP' => '...',	# Original Publication
      'PB' => 'Verlag',	# Publisher
      'PP' => '...',	# Publishing Place
      'PY' => '...',	# Publication year (YYYY/MM/DD)
      'RI' => '...',	# Reviewed Item
      'RN' => '...',	# Research Notes
      'RP' => '...',	# Reprint Edition
      'SE' => '...',	# Section
      'SN' => 'ISBN/ISSN',	# ISBN/ISSN
      'SP' => '...',	# Start Page
      'ST' => '...',	# Short Title
      'T1' => 'Titel',	# Primary Title
      'T2' => '...',	# Secondary Title (journal title, if applicable)
      'T3' => '...',	# Tertiary Title
      'TA' => '...',	# Translated Author
      'TI' => '...',	# Title
      'TT' => '...',	# Translated Title
      'U1' => '...',	# User definable 1. This is an alphanumeric field and there is no practical limit to the length of this field.
      'U2' => '...',	# User definable 2. This is an alphanumeric field and there is no practical limit to the length of this field.
      'U3' => '...',	# User definable 3. This is an alphanumeric field and there is no practical limit to the length of this field.
      'U4' => '...',	# User definable 4. This is an alphanumeric field and there is no practical limit to the length of this field.
      'U5' => '...',	# User definable 5. This is an alphanumeric field and there is no practical limit to the length of this field.
      'UR' => '...',	# URL
      'VL' => '...',	# Volume number
      'VO' => '...',	# Published Standard number
      'Y1' => 'Datum',	# Primary Date
      'Y2' => '...',	# Access Date
      'ER' => '...',	# End of Reference (must be empty and the last tag)
    );

  printf "{{Literatur\n";

  while(<>)
    {
      chomp;

      if( m/^ (?<lhs>..) \s+ - \s+ (?<rhs>.*)/gx )
	{
	  my(%plus) = %+;

	  my($new_tag) = '(undef)';

	  if(exists($tags{ $plus{lhs} }))
	    {
	      $new_tag = $tags{ $plus{lhs} };
	      if   ($plus{lhs} eq 'TY')
		{
		  printf "{{Literatur\n"
		    if 0;
		}
	      elsif($plus{lhs} eq 'ER')
		{
		  printf "}}\n"
		    if 0;
		}
	      elsif($new_tag eq '...')
		{
		  printf "##| %s=%s\n",$plus{lhs},$plus{rhs};
		}
	      else
		{
		  printf " | %s=%s\n",$new_tag,$plus{rhs};
		}
	    }

	  printf "=%03.3d: %s=>{%s},%s=>{%s},%s=>{%s} // %s\n",__LINE__,
	    '$plus{lhs}' => $plus{lhs},
	    '$new_tag' => $new_tag,
	    '$plus{rhs}' => $plus{rhs},
	    '...',
	    if 0;
	}
      elsif($_ eq '﻿') # ???
	{
	  warn "\$_=>{$_} // unexpected empty line"
	    if 0;
	}
      else
	{
	  warn "\$_=>{$_} // unexpected";
	}
    }

  printf "}}\n";

}
