#! /usr/bin/perl -w

# read a procmail log file -> LOGFILE
# create diary entries

# $Id: procmail-from2diary.pl 1.28 2013/04/26 11:28:11 johayek Exp $
# $Source: /Users/johayek/git-servers/github.com/JochenHayek/misc/procmail/RCS/procmail-from2diary.pl $

# e-mail subjects with "foreign" characters and .maildelivery resp. procmail-from
#
# samples:
#
#  Subject: =?ISO-8859-1?Q?ERINNERUNG=3A_Hebr=E4ischer_B=FCchermarkt_am_kommenden;
#  Subject: =?UTF-8?Q?Ab_auf_die_Piste_-_Winterspa=C3=9F_f=C3=BCr_die_ganze_Famil;
#  Subject: =?windows-1252?Q?Re=3A_Projektangebot_in_T=FCbingen_=28Perl-Prog?=;
#  Subject: =?UTF-8?B?...=?=
#
# assumption:
#
#  the entire subject value looks like this:
#
#  * "=?${ENCODING}?(?=[BQ])?...?="
#
#  * "=?${ENCODING}?(?=Q)?...?=" and then occurences
#   * of regular substrings
#   * and triplets of "=" and 2 base16 letters
#   * and space (0x20) characters are replaced by "_"
#
#  * "=?${ENCODING}?(?=B)?...=?=", where "..." are all supposedly base64 letters
#
#  env TEXT='=?UTF-8?B?IC0gMjIuMTEuMjAxMiwgMTQ6MDM=?=' perl -MEncode -e 'print encode("utf8",decode("MIME-Header",$ENV{TEXT})), "\n"'
#
#  env TEXT='=?UTF-8?B?IC0gMjIuMTEuMjAxMiwgMTQ6MDM=?=' perl -MEncode -e 'print decode("MIME-Header", $ENV{TEXT}), "\n"'
#
#  env TEXT='=?UTF-8?B?IC0gMjIuMTEuMjAxMiwgMTQ6MDM=?=' perl -e 'use Encode qw(decode); print decode("MIME-Header", $ENV{TEXT}), "\n"'

{
  use Encode qw(decode);

  my(%from_captures,%subject_captures,%folder_captures);

  my($last_date) = '';

  binmode( STDOUT , ":encoding(UTF-8)" );

  while(<>)
    {
      if(m/^From \s+ (?<from>\S+) \s+ (?<wday>\w+) \s+ (?<month>\w+) \s+ (?<mday>\w+) \s+ (?<time>[\d:]+) \s+ (?<year>\d+)$/x)
	{
	  printf STDERR "=%03.3d,%05.5d: {%s}=>{%s},{%s}=>{%s},{%s}=>{%s},{%s}=>{%s},{%s}=>{%s},{%s}=>{%s} // %s\n",__LINE__,$.
	    ,'$+{from}',$+{from}
	    ,'$+{wday}',$+{wday}
	    ,'$+{month}',$+{month}
	    ,'$+{mday}',$+{mday}
	    ,'$+{time}',$+{time}
	    ,'$+{year}',$+{year}
	    ,'...' if 0;

	  %from_captures = %+;
	  %subject_captures = ();
	}
      elsif(m/^ \s+ Subject: \s* (?<subject>.*) $/ix)
	{
	  printf STDERR "=%03.3d,%05.5d: {%s}=>{%s},{%s}=>{%s} // %s\n",__LINE__,$.
	    ,'$+{subject}',$+{subject}
	    ,'$from_captures{from}',$from_captures{from}
	    ,'...' if 0;

	  %subject_captures = %+;

	  $subject_captures{subject_decoded} = $subject_captures{subject_patched} = $subject_captures{subject};

	  if($subject_captures{subject} =~ m/^=\?/)
	    {
	      if($subject_captures{subject} =~ m/\?=$/)
		{}
	      else
		{
		  $subject_captures{subject_patched} .= '?=';
		}

	      # http://stackoverflow.com/questions/9197170/converting-base64-encoded-mail-subject-to-text

	      $subject_captures{subject_decoded} = decode( "MIME-Header" , $subject_captures{subject_patched} );

	      printf "%s %s %s\n\t%s %s: %s; %s: %s\n"
		,$from_captures{mday}
		,$from_captures{month}
		,$from_captures{year}
		,$from_captures{time}
		,'From',$from_captures{from}
		,'Subject/patched',$subject_captures{subject_patched}
		if 0;
	      printf "%s %s %s\n\t%s %s: %s; %s: %s\n"
		,$from_captures{mday}
		,$from_captures{month}
		,$from_captures{year}
		,$from_captures{time}
		,'From',$from_captures{from}
		,'Subject/decoded',$subject_captures{subject_decoded}
		if 0;
	    }

	  printf "%s %s %s\n\t%s %s: %s; %s: %s\n"
	    ,$from_captures{mday}
	    ,$from_captures{month}
	    ,$from_captures{year}
	    ,$from_captures{time}
	    ,'From',$from_captures{from}
	    ,'Subject',$subject_captures{subject}
	    if 0;
	}
      elsif(m/^ \s+ Folder: \s+ (?<folder>\S+) \s+ (?<size>\d+) $/x)
	{
	  printf STDERR "=%03.3d,%05.5d: {%s}=>{%s},{%s}=>{%s} // %s\n",__LINE__,$.
	    ,'$+{folder}',$+{folder}
	    ,'$+{size}',$+{size}
	    ,'...' if 0;

	  %folder_captures = %+;

	  if(exists($from_captures{from}))
	    {
	      # $last_date

	      $date = sprintf "%02.2d %s %s"
			,$from_captures{mday}
			,$from_captures{month}
			,$from_captures{year}
			;

	      if(0 && ($date eq $last_date)) # maybe we always want to print the calender day, otherwise: s/0/1/
		{
		  printf "\n";
		}
	      else
		{
		  printf "%s\n"
		    ,$date
		    ;
		}

	      $last_date = $date;

	      printf "\t%s [_] %s: %s;\n\t\t %s: %s;\n\t\t %s: %s;\n\t\t %s: %s;\n\t\t %s: %s\n"
		,$from_captures{time}
		,'From',$from_captures{from}
		,'Subject        ', exists($subject_captures{subject}        ) ? $subject_captures{subject}         : '{!exists(subject)}'
		,'Subject/patched', exists($subject_captures{subject_patched}) ? $subject_captures{subject_patched} : '{!exists(subject)}'
		,'Subject/decoded', exists($subject_captures{subject_decoded}) ? $subject_captures{subject_decoded} : '{!exists(subject)}'
		,'Folder',$folder_captures{folder}
		if 0;
	      printf "\t%s [_] %s: %s;\n\t\t %s: %s;\n\t\t %s: %s\n"
		,$from_captures{time}
		,'From',$from_captures{from}
		,'Subject', exists($subject_captures{subject_decoded}) ? $subject_captures{subject_decoded} : '{!exists(subject)}'
		,'Folder',$folder_captures{folder}
		;
	    }

	  %from_captures    = ();
	  %subject_captures = ();
	  %folder_captures  = ();
	}
      elsif(m/^ \s+ Folder: \s+ (?<strange_folder>.*) \s+ (?<size>\d+) $/x)
	{
	  printf STDERR "=%03.3d,%05.5d: {%s}=>{%s},{%s}=>{%s} // %s\n",__LINE__,$.
	    ,'$+{strange_folder}',$+{strange_folder}
	    ,'$+{size}',$+{size}
	    ,'...' if 0;

	  %folder_captures = %+;

	  if(exists($from_captures{from}))
	    {
	      # $last_date

	      $date = sprintf "%02.2d %s %s"
			,$from_captures{mday}
			,$from_captures{month}
			,$from_captures{year}
			;

	      if(0 && ($date eq $last_date)) # maybe we always want to print the calender day, otherwise: s/0/1/
		{
		  printf "\n";
		}
	      else
		{
		  printf "%s\n"
		    ,$date
		    ;
		}

	      $last_date = $date;

	      printf "\t%s [_] %s: %s;\n\t\t %s: %s;\n\t\t %s: %s\n"
		,$from_captures{time}
		,'From',$from_captures{from}
		,'Subject', exists($subject_captures{subject_decoded}) ? $subject_captures{subject_decoded} : '{!exists(subject)}'
		,'Folder',$folder_captures{strange_folder}
		;
	    }

	  %from_captures    = ();
	  %subject_captures = ();
	  %folder_captures  = ();
	}
      else
	{
	  chomp;

	  printf STDERR "=%03.3d,%05.5d: {%s}=>{%s} // %s\n",__LINE__,$.
	    ,'$_',$_
	    ,'...' if 1;
	}
    }
}

=head1 NAME

procmail-from2diary.pl

=head1 SYNOPSIS

tail -f $HOME/procmail-from | procmail-from2diary.pl

=head1 DESCRIPTION

This script reads the LOGFILE being written to by procmail,
which is usually called procmail-from,
and creates entries for a diary (in Emacs format).

=head1 README

This script reads the LOGFILE being written to by procmail,
which is usually called procmail-from,
and creates entries for a diary (in Emacs format).

=head1 EXAMPLE

tail -f $HOME/procmail-from | procmail-from2diary.pl

=head1 HISTORY

...

=head1 KNOWN PROBLEMS

...

=head1 PREREQUISITES

...

=head1 OSNAMES

any

=head1 SCRIPT CATEGORIES

Win32
Win32/Utilities

=head1 AUTHOR

Jochen Hayek E<lt>Jochen+CPAN@Hayek.nameE<gt>

=head1 HISTORY

