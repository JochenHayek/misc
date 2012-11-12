#! /usr/bin/perl -w

# read a procmail log file -> LOGFILE
# create diary entries

# $Id: procmail-from2diary.pl 1.18 2012/11/12 10:49:57 johayek Exp $
# $Source: /Users/johayek/git-servers/github.com/JochenHayek/misc/procmail/RCS/procmail-from2diary.pl $

{
  use Getopt::Long;
  use Pod::Usage;
  our(%options);
  $main::options{debug} = 0;
##$main::options{show_size_warnings_p} = 1;

  my($result) =
    &GetOptions
      (\%main::options

      ,'date=s'

      ,'dry_run!'
      ,'version!'
      ,'help|?!'
      ,'man!'
      ,'debug!'
      ,'verbose=i'
      ,'params=s%'		# some "indirect" parameters
      );
  $result || pod2usage(2);

  pod2usage(1) if $main::options{help};
  pod2usage(-exitstatus => 0, -verbose => 2) if $main::options{man};

  ################################################################################

  my(%from_captures,%subject_captures,%folder_captures);

  my($last_date) = '';

  while(<>)
    {
      # e.g.: From Georg.Kling@t-online.de  Sun Jan 16 20:25:25 2011

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

	  printf "%s %s %s\n\t%s %s: %s; %s: %s\n"
	    ,$from_captures{mday}
	    ,$from_captures{month}
	    ,$from_captures{year}
	    ,$from_captures{time}
	    ,'From',$from_captures{from}
	    ,'Subject',$subject_captures{subject}
	    if 0;
	}
      elsif(m/^ \s+ Folder: \s+ (?<folder>.*?) \s+ (?<size>\d+) $/x)
	{
	  printf STDERR "=%03.3d,%05.5d: {%s}=>{%s},{%s}=>{%s} // %s\n",__LINE__,$.
	    ,'$+{folder}',$+{folder}
	    ,'$+{size}',$+{size}
	    ,'...' if 0;

	  %folder_captures = %+;

	  my($folder_name_is_weird) = ( $folder_captures{folder} =~ m/\s/ ) ? 1 : 0;

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

	      printf "\t%s [_] %s: %s;\n\t\t %s: %s;\n\t\t %s: {%s} // %s=>{%s}\n"
		,$from_captures{time}
		,'From' => $from_captures{from}
		,'Subject' => exists($subject_captures{subject}) ? $subject_captures{subject} : '{!exists(subject)}'
		,'Folder' => $folder_captures{folder}
	        ,'$folder_name_is_weird' => $folder_name_is_weird
		;
	    }
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

...

=head1 SCRIPT CATEGORIES

...

=head1 AUTHOR

Jochen Hayek E<lt>Jochen+CPAN@Hayek.nameE<gt>

=head1 HISTORY

...

=cut
