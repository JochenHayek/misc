#! /usr/bin/perl -w

# read a procmail log file -> LOGFILE
# create diary entries

# $Id: procmail-from2diary.pl 1.11 2010/06/16 21:44:39 johayek Exp $
# $Source: /Users/johayek/git-servers/github.com/JochenHayek/misc/procmail/RCS/procmail-from2diary.pl $

{
  my(%from_captures,%subject_captures,%folder_captures);

  my($last_date) = '';

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
	}
      elsif(m/^ \s+ Subject: \s* (?<subject>.*) $/x)
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

	      if($date eq $last_date)
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

	      printf "\t%s %s: %s;\n\t\t %s: %s;\n\t\t %s: %s\n"
		,$from_captures{time}
		,'From',$from_captures{from}
		,'Subject',$subject_captures{subject}
		,'Folder',$folder_captures{folder}
		;
	    }
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

=over 8

=item B<xls-tar_1_32.pl>

first CPAN upload

=cut
