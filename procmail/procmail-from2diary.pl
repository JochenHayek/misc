#! /usr/bin/perl -w

our($emacs_Time_stamp) = 'Time-stamp: <2013-12-30 15:08:10 johayek>' =~ m/<(.*)>/;

##our     $rcs_Id=(join(' ',((split(/\s/,'$Id: procmail-from2diary.pl 1.37 2013/12/30 14:08:56 johayek Exp $'))[1..6])));
##our   $rcs_Date=(join(' ',((split(/\s/,'$Date: 2013/12/30 14:08:56 $'))[1..2])));
##our $rcs_Author=(join(' ',((split(/\s/,'$Author: johayek $'))[1])));
##our    $RCSfile=(join(' ',((split(/\s/,'$RCSfile: procmail-from2diary.pl $'))[1])));
##our $rcs_Source=(join(' ',((split(/\s/,'$Source: /Users/johayek/git-servers/github.com/JochenHayek/misc/procmail/RCS/procmail-from2diary.pl $'))[1])));

# read a procmail log file -> LOGFILE
# create diary entries

# $Id: procmail-from2diary.pl 1.37 2013/12/30 14:08:56 johayek Exp $
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

use warnings;
use strict;

##our $VERSION = '1.36';

##our %executables;
##our %devices;
##our %directories;
##our %mount_points;
our $std_formatting_options = { 'separator' => ',', 'assign' => '=>', 'quoteLeft' => '{', 'quoteRight' => '}' };

{
  use Carp;
##use English;
##use FileHandle;
##use Encode;
##use File::Basename;  
##use File::Stat; # OOP interface for Perl's built-in stat() functions

  &main;
}

sub main
{
  my($package,$filename,$line,$proc_name) = caller(0);

  my(%param) = @_;

  my($return_value) = 0;

  # described in:
  #	camel book / ch. 7: the std. perl lib. / lib. modules / Getopt::Long - ...

  use Getopt::Long;
  use Pod::Usage;
  %main::options = ();

  $main::options{debug} = 0;

  printf STDERR ">%s,%d,%s\n",__FILE__,__LINE__,$proc_name
    if 0 && $main::options{debug};
##printf STDERR "=%s,%d,%s: %s=>{%s}\n",__FILE__,__LINE__,$proc_name
##  ,'$rcs_Id' => $rcs_Id
##  if 0 && $main::options{debug};
  printf STDERR "=%s,%d,%s: %s\n",__FILE__,__LINE__,$proc_name
    , &main::format_key_value_list($main::std_formatting_options, '$emacs_Time_stamp' => $emacs_Time_stamp )
    if 0 && $main::options{debug};

  {
    # defaults for the main::options;
    
    $main::options{dry_run}		       	= 0;
    $main::options{version}		       	= 0;
    $main::options{verbose}		       	= 0;
    $main::options{brief}		       	= 0;

    $main::options{job_anon} = 1;
  }

  my($result) =
    &GetOptions
      (\%main::options
     ##,'job_anon|ja!'

       ,'dry_run!'
       ,'version!'
       ,'help|?!'
       ,'man!'
       ,'debug!'
     ##,'verbose=s'		# sometimes we use it like this
       ,'verbose!'		# sometimes we use it like this 
       ,'brief!'

       ,'directories|directory=s@'
       );
  $result || pod2usage(2);

  pod2usage(1) if $main::options{help};
  pod2usage(-exitstatus => 0, -verbose => 2) if $main::options{man};

  if   ($main::options{job_anon}   ) { &job_anon; }
##elsif($main::options{job_extract}) { &job_extract; }
  else
    {
      die "no job to be carried out";
    }

  printf STDERR "=%s,%d,%s: %s\n",__FILE__,__LINE__,$proc_name
    ,&main::format_key_value_list($main::std_formatting_options, '$return_value' => $return_value )
    if 0 && $main::options{debug};
  printf STDERR "<%s,%d,%s\n",__FILE__,__LINE__,$proc_name
    if 0 && $main::options{debug};
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

    my $chunk = "$name$options{assign}$options{quoteLeft}$value$options{quoteRight}";
    if (defined($buf)) {
      $buf .= "$options{separator}$chunk";
    } else {
      $buf  =                     $chunk;
    }
  }

  return $buf;
}
#
sub job_anon
{
  my($package,$filename,$line,$proc_name) = caller(0);

  my(%param) = @_;

  my($return_value) = 0;

  printf STDERR ">%s,%d,%s\n",__FILE__,__LINE__,$proc_name
    if 0 && $main::options{debug};

  my(%FROM_captures,%SUBJECT_captures,%from_captures,%subject_captures,%folder_captures);

  my($date);
  my($last_date) = '';

  binmode( STDIN  , ":encoding(UTF-8)" );
  binmode( STDOUT , ":encoding(UTF-8)" );
  binmode( STDERR , ":encoding(UTF-8)" );

  while(<>)			# this is only STDIN, if it's really STDIN; if it's "reading files filter-like from the command-line", it's not STDIN; no idea, what it is then
    {
      if(m/^FROM=\{(?<FROM>.*)\}$/x)
	{
	  printf STDERR "=%03.3d,%05.5d: %s // %s\n",__LINE__,$.
	    , &main::format_key_value_list($main::std_formatting_options, '$+{FROM}' => $+{FROM} )
	    ,'...'
	    if 0;

	  %FROM_captures = %+;
	  %SUBJECT_captures = ();
	}
      elsif(m/^SUBJECT=\{(?<SUBJECT>.*)\}$/x)
	{
	  printf STDERR "=%03.3d,%05.5d: %s // %s\n",__LINE__,$.
	    , &main::format_key_value_list($main::std_formatting_options, '$+{SUBJECT}' => $+{SUBJECT} )
	    ,'...'
	    if 0;

	  %SUBJECT_captures = %+;
	}
      elsif(m/^From \s+ (?<from>\S+) \s+ (?<wday>\w+) \s+ (?<month>\w+) \s+ (?<mday>\w+) \s+ (?<time>[\d:]+) \s+ (?<year>\d+)$/x)
	{
	  printf STDERR "=%03.3d,%05.5d: %s // %s\n",__LINE__,$.
	    , &main::format_key_value_list($main::std_formatting_options
					   ,'$+{from}' => $+{from}
					   ,'$+{wday}' => $+{wday}
					   ,'$+{month}' => $+{month}
					   ,'$+{mday}' => $+{mday}
					   ,'$+{time}' => $+{time}
					   ,'$+{year}' => $+{year}
					   )
	    ,'...' if 0;

	  %from_captures = %+;
	  %subject_captures = ();
	}
      elsif(m/^ \s+ Subject: \s* (?<subject>.*) $/ix)
	{
	  printf STDERR "=%03.3d,%05.5d: %s // %s\n",__LINE__,$.
	    , &main::format_key_value_list($main::std_formatting_options
					   ,'$+{subject}' => $+{subject}
					   ,'$from_captures{from}' => $from_captures{from}
					   )
	    ,'...'
	    if 0;

	  %subject_captures = %+;

	  printf "%s %s %s\n\t%s %s: %s; %s: %s\n"
	    ,$from_captures{mday}
	    ,$from_captures{month}
	    ,$from_captures{year}
	    ,$from_captures{time}
	    ,'From' => $from_captures{from}
	    ,'Subject' => $subject_captures{subject}
	    if 0;
	}
      elsif(m/^ \s+ Folder: \s+ (?<folder>\S+) \s+ (?<size>\d+) $/x)
	{
	  printf STDERR "=%03.3d,%05.5d: %s // %s\n",__LINE__,$.
	     &main::format_key_value_list($main::std_formatting_options
					  ,'$+{folder}' => $+{folder}
					  ,'$+{size}' => $+{size}
					  )
	    ,'...'
	    if 0;

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
		,'From' => $from_captures{from}
		,'FROM', exists($FROM_captures{FROM}) ? $FROM_captures{FROM} : '{!exists(FROM)}'
		,'Subject', exists($subject_captures{subject}) ? $subject_captures{subject} : '{!exists(subject)}'
		,'SUBJECT', exists($SUBJECT_captures{SUBJECT}) ? $SUBJECT_captures{SUBJECT} : '{!exists(SUBJECT)}'
		,'Folder' => $folder_captures{folder}
		;

	      print_shuttle_procmailrc_entry(
		'from0' => $from_captures{from},
		'from1' => $FROM_captures{FROM},
		);
	    }

	  %FROM_captures    = ();
	  %SUBJECT_captures = ();
	  %from_captures    = ();
	  %subject_captures = ();
	  %folder_captures  = ();
	}
      elsif(m/^ \s+ Folder: \s+ (?<strange_folder>.*) \s+ (?<size>\d+) $/x)
	{
	  printf STDERR "=%03.3d,%05.5d: %s // %s\n",__LINE__,$.
	     &main::format_key_value_list($main::std_formatting_options
					  ,'$+{strange_folder}' => $+{strange_folder}
					  ,'$+{size}' => $+{size}
					  )
	    ,'...'
	    if 0;

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
		,'From' => $from_captures{from}
		,'FROM', exists($FROM_captures{FROM}) ? $FROM_captures{FROM} : '{!exists(FROM)}'
		,'Subject', exists($subject_captures{subject}) ? $subject_captures{subject} : '{!exists(subject)}'
		,'SUBJECT', exists($SUBJECT_captures{SUBJECT}) ? $SUBJECT_captures{SUBJECT} : '{!exists(SUBJECT)}'
		,'Folder' => $folder_captures{strange_folder}
		;
	    }

	  %FROM_captures    = ();
	  %SUBJECT_captures = ();
	  %from_captures    = ();
	  %subject_captures = ();
	  %folder_captures  = ();
	}
      else
	{
	  chomp;

	  printf STDERR "=%03.3d,%05.5d: %s // %s\n",__LINE__,$.
	     ,&main::format_key_value_list($main::std_formatting_options, '$_' => $_ )
	    ,'...'
	    if 1;
	}
    }

  printf STDERR "<%s,%d,%s\n",__FILE__,__LINE__,$proc_name
    if 0 && $main::options{debug};

  return $return_value;
}
#
sub backslash_e_mail_address
{
  my($package,$filename,$line,$proc_name) = caller(0);

  my(%param) = @_;

  my($return_value) = 0;

  printf STDERR ">%s,%d,%s\n",__FILE__,__LINE__,$proc_name
    if 0 && $main::options{debug};

  $return_value = $param{address};

  $return_value =~ s/ ([\.\+]) /\\$1/gx;

  printf STDERR "<%s,%d,%s\n",__FILE__,__LINE__,$proc_name
    if 0 && $main::options{debug};

  return $return_value;
}
#
sub print_shuttle_procmailrc_entry
{
  my($package,$filename,$line,$proc_name) = caller(0);

  my(%param) = @_;

  my($return_value) = 0;

  printf STDERR ">%s,%d,%s\n",__FILE__,__LINE__,$proc_name
    if 0 && $main::options{debug};

  # $param{from0}
  # $param{from1}

  printf "##shuttle:\n";
  printf "##shuttle: :0\n";
  printf "##shuttle: * ^Return-Path: <%s>\$\n"
    , &backslash_e_mail_address( 'address' => $param{from0} )
    ;

  if(defined($param{from1}))
    {
      my($h) = $param{from1};

      my($rp) = $h;
      if($h =~ m/^ .* < (.*) > $/x)
	{
	  $rp = $1;
	}
      printf "##shuttle: * ^Return-Path: <%s>\$\n"
	, &backslash_e_mail_address( 'address' => $rp )
	unless $rp eq $param{from0};
    }

  print "##shuttle: .folder-biz.prio-9/\n";

  printf STDERR "<%s,%d,%s\n",__FILE__,__LINE__,$proc_name
    if 0 && $main::options{debug};

  return $return_value;
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

