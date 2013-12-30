#! /usr/bin/perl -w

# read a procmail log file -> LOGFILE
# create diary entries

# $Id: procmail-from2diary.pl 1.33 2013/12/30 13:11:29 johayek Exp $
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
  my(%FROM_captures,%SUBJECT_captures,%from_captures,%subject_captures,%folder_captures);

  my($last_date) = '';

  binmode( STDIN  , ":encoding(UTF-8)" );
  binmode( STDOUT , ":encoding(UTF-8)" );
  binmode( STDERR , ":encoding(UTF-8)" );

  while(<>)			# this is only STDIN, if it's really STDIN; if it's "reading files filter-like from the command-line", it's not STDIN; no idea, what it is then
    {
      if(m/^FROM=\{(?<FROM>.*)\}$/x)
	{
	  printf STDERR "=%03.3d,%05.5d: {%s}=>{%s} // %s\n",__LINE__,$.
	    ,'$+{FROM}',$+{FROM}
	    ,'...' if 0;

	  %FROM_captures = %+;
	  %SUBJECT_captures = ();
	}
      elsif(m/^SUBJECT=\{(?<SUBJECT>.*)\}$/x)
	{
	  printf STDERR "=%03.3d,%05.5d: {%s}=>{%s} // %s\n",__LINE__,$.
	    ,'$+{SUBJECT}',$+{SUBJECT}
	    ,'...' if 0;

	  %SUBJECT_captures = %+;
	}
      elsif(m/^From \s+ (?<from>\S+) \s+ (?<wday>\w+) \s+ (?<month>\w+) \s+ (?<mday>\w+) \s+ (?<time>[\d:]+) \s+ (?<year>\d+)$/x)
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

	      printf "\t%s [_] %s: %s;\n\t\t %s:%s;\n\t\t %s: %s;\n\t\t %s:%s;\n\t\t %s: %s\n"
		,$from_captures{time}
		,'From',$from_captures{from}
		,'FROM', exists($FROM_captures{FROM}) ? $FROM_captures{FROM} : '{!exists(FROM)}'
		,'Subject', exists($subject_captures{subject}) ? $subject_captures{subject} : '{!exists(subject)}'
		,'SUBJECT', exists($SUBJECT_captures{SUBJECT}) ? $SUBJECT_captures{SUBJECT} : '{!exists(SUBJECT)}'
		,'Folder',$folder_captures{folder}
		;

	      printf "##shuttle:\n##shuttle: :0\n##shuttle: * ^Return-Path: <%s>\$%s\n"
		,$from_captures{from}
	        ,' // certain characters need to be back-slashed'
		;

	      if(exists($FROM_captures{FROM}))
		{
		  my($h) = $FROM_captures{FROM};

		  my($rp) = $h;
		  if($h =~ m/^ .* < (.*) > $/x)
		    {
		      $rp = $1;
		    }
		  printf "##shuttle: * ^Return-Path: <%s>\$ %s\n"
		    ,$rp
		    ,' // certain characters need to be back-slashed'
		    unless $rp eq $from_captures{from};
		}
	      printf "##shuttle: .folder-biz.prio-9/\n"
		;
	    }

	  %FROM_captures    = ();
	  %SUBJECT_captures = ();
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
		,'Subject', exists($subject_captures{subject}) ? $subject_captures{subject} : '{!exists(subject)}'
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

