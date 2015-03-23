#! /usr/bin/perl -w

our($emacs_Time_stamp) = 'Time-stamp: <2015-03-23 15:12:36 johayek>' =~ m/<(.*)>/;

# $Id: procmail-from2diary.pl 1.65 2015/03/23 14:23:21 johayek Exp $ Jochen Hayek
# $Source: /Users/johayek/git-servers/github.com/JochenHayek/misc/procmail/RCS/procmail-from2diary.pl $

##our     $rcs_Id=(join(' ',((split(/\s/,'$Id: procmail-from2diary.pl 1.65 2015/03/23 14:23:21 johayek Exp $'))[1..6])));
##our   $rcs_Date=(join(' ',((split(/\s/,'$Date: 2015/03/23 14:23:21 $'))[1..2])));
##our $rcs_Author=(join(' ',((split(/\s/,'$Author: johayek $'))[1])));
##our    $RCSfile=(join(' ',((split(/\s/,'$RCSfile: procmail-from2diary.pl $'))[1])));
##our $rcs_Source=(join(' ',((split(/\s/,'$Source: /Users/johayek/git-servers/github.com/JochenHayek/misc/procmail/RCS/procmail-from2diary.pl $'))[1])));

################################################################################

# read a procmail LOGFILE
# * as created by my .procmailrc
# * with rather special extra lines: DATE:..., FROM:..., MSG_TO=..., SUBJECT=...

# create diary entries on STDOUT
# create $HOME/var/log/procmailrc

################################################################################

# basically to be called like that:

# $ $HOME/Computers/Programming/Languages/Perl/procmail-from2diary.pl

# $                                  $HOME/bin/procmail-from2diary.pl

# but I want to "tail -f" the file on mail.shuttle.de like this,
# and if I create the pipe on that server, we are running into a buffering problem,
# which we don't run into, if the script runs locally:

# $ ssh -n mail.shuttle.de tail -1000f var/log/procmail-from | ~/bin/procmail-from2diary.pl

################################################################################

# because we also need to survey the certificate fingerprints,
# we created a more complex command line:

# $ ssh -n www.b.shuttle.de bin/fetchmail--extract_fingerprints.pl var/log/fetchmail.log; echo -e '\n\n********************'; ssh -n mail.shuttle.de quota --human-readable; echo -e '\n\n********************'; sleep 5; ssh -n mail.shuttle.de tail -1000f var/log/procmail-from | ~/bin/procmail-from2diary.pl

# $ ssh -n www.b.shuttle.de 'tail -500 var/log/fetchmail.log | bin/fetchmail--extract_fingerprints.pl'; echo -e '\n\n********************'; ssh -n mail.shuttle.de quota --human-readable; echo -e '\n\n********************'; sleep 5; ssh -n mail.shuttle.de tail -1000f var/log/procmail-from | ~/bin/procmail-from2diary.pl

################################################################################

# $ rsync -vaz --rsync-path=/volume1/@hayek/bin/rsync $HOME/Computers/Programming/Languages/Perl/procmail-from2diary.pl diskstation002:ARCHIVE/mail.shuttle.de-non-dated/Computers/Programming/Languages/Perl/
# $ rsync -vaz					      $HOME/Computers/Programming/Languages/Perl/procmail-from2diary.pl                                  mail.shuttle.de:Computers/Programming/Languages/Perl/
# $ rsync -vaz                                        $HOME/Computers/Programming/Languages/Perl/procmail-from2diary.pl                                           HayekW:Computers/Programming/Languages/Perl/
# $ rsync -vaz                                        $HOME/Computers/Programming/Languages/Perl/procmail-from2diary.pl                                         Hayek001:Computers/Programming/Languages/Perl/

################################################################################

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

use strict;
##use warnings FATAL => 'all';	# this creates an immediate exit with 'binmode(STDIN ,":encoding(UTF-8)" );' , when something non-UTF-8 gets encountered
use warnings;

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

  my(%DATE_captures,%FROM_captures,%MSG_TO_captures,%SUBJECT_captures,
     		    %From_captures,%to_captures,%subject_captures,
     %folder_captures);

  my($last_date) = '';

  # procmail creates 8-bit / 1-byte code,
  # presumably it lets subjects with German umlauts and "ß" pass through.

  # BUT:
  # the lines created like this:
  #   FROM=`formail    -c -xFrom:    | perl -MEncode -ne 'print encode("utf8",decode("MIME-Header",$_))'`
  # *do* create UTF-8 multi-byte characters.

  binmode( STDIN  , ":encoding(UTF-8)" );          # it is NOT UTF-8, and with "use warnings FATAL => 'all';" this creates an immediate exit, when something non-UTF-8 gets encountered
##binmode( STDIN  , ":encoding(ISO-8859-1)" );

  binmode( STDOUT , ":encoding(UTF-8)" );
  binmode( STDERR , ":encoding(UTF-8)" );

  our(%all_addresses);
  my($HOME_var_log_procmailrc) = "$ENV{HOME}/var/log/procmailrc";

  unlink($HOME_var_log_procmailrc);

  our($fh_procmailrc);

  open($main::fh_procmailrc,'>',"$HOME_var_log_procmailrc") || warn "\$HOME_var_log_procmailrc=>{$HOME_var_log_procmailrc} // cannot open: '$!'";
  if(fileno($main::fh_procmailrc))
    {
      $main::fh_procmailrc->autoflush(1);
    }

  while(<>)			# this is only STDIN, if it's really STDIN; if it's "reading files filter-like from the command-line", it's not STDIN; no idea, what it is then
    {

      if(m/^FROM=\{(?<FROM>.*)\}$/x)
	{
	  printf STDERR "=%03.3d,%05.5d: %s // %s\n",__LINE__,$.
	    , &main::format_key_value_list($main::std_formatting_options, '$+{FROM}' => $+{FROM} )
	    ,'...'
	    if 0;

	  %FROM_captures    = %+;
	  %DATE_captures    = ();
	  %MSG_TO_captures  = ();
	  %SUBJECT_captures = ();
	}

      # DATE={ 9 Mar 2015 12:36:39 -0400}
      # DATE={ Mon,  9 Mar 2015 16:58:18 +0100 (CET)}
      # DATE={ Mon, 09 Mar 2015 16:51:15 +0100}
      # DATE={ Mon, 9 Mar 2015 16:51:03 +0100}

      elsif(m/^DATE=\{ \s*  ( (?<wday>\w+) , \s+ )? (?<mday>\w+) \s+ (?<month>\w+) \s+ (?<year>\d+) \s+ (?<time>[\d:]+) \s+ (?<DST>.*) \}$/x)
	{
	  printf STDERR "=%03.3d,%05.5d: %s // %s\n",__LINE__,$.
	    , &main::format_key_value_list($main::std_formatting_options
					   ,'$+{mday}' => $+{mday}
					   ,'$+{month}' => $+{month}
					   ,'$+{year}' => $+{year}
					   ,'$+{time}' => $+{time}
					   ,'$+{DST}' => $+{DST}
					   )
	    ,'...' if 0;

	  %DATE_captures = %+;
	}
      elsif(m/^MSG_TO=\{(?<MSG_TO>.*)\}$/x)
	{
	  printf STDERR "=%03.3d,%05.5d: %s // %s\n",__LINE__,$.
	    , &main::format_key_value_list($main::std_formatting_options, '$+{MSG_TO}' => $+{MSG_TO} )
	    ,'...'
	    if 0;

	  %MSG_TO_captures = %+;
	}
      elsif(m/^SUBJECT=\{(?<SUBJECT>.*)\}$/x)
	{
	  printf STDERR "=%03.3d,%05.5d: %s // %s\n",__LINE__,$.
	    , &main::format_key_value_list($main::std_formatting_options, '$+{SUBJECT}' => $+{SUBJECT} )
	    ,'...'
	    if 0;

	  %SUBJECT_captures = %+;
	}

      elsif(m/^From \s+ (?<From>\S+) \s+ (?<wday>\w+) \s+ (?<month>\w+) \s+ (?<mday>\w+) \s+ (?<time>[\d:]+) \s+ (?<year>\d+)$/x)
	{
	  printf STDERR "=%03.3d,%05.5d: %s // %s\n",__LINE__,$.
	    , &main::format_key_value_list($main::std_formatting_options
					   ,'$+{From}' => $+{From}
					   ,'$+{wday}' => $+{wday}
					   ,'$+{month}' => $+{month}
					   ,'$+{mday}' => $+{mday}
					   ,'$+{time}' => $+{time}
					   ,'$+{year}' => $+{year}
					   )
	    ,'...' if 0;

	  %From_captures = %+;
	  %to_captures = ();
	  %subject_captures = ();
	}

      elsif(m/^ \s+ Subject: \s* (?<subject>.*) $/ix)
	{
	  printf STDERR "=%03.3d,%05.5d: %s // %s\n",__LINE__,$.
	    , &main::format_key_value_list($main::std_formatting_options
					   ,'$+{subject}' => $+{subject}
					   ,'$From_captures{From}' => $From_captures{From}
					   )
	    ,'...'
	    if 0;

	  %subject_captures = %+;

	  printf "%s %s %s\n\t%s %s: %s; %s: %s\n"
	    ,$From_captures{mday}
	    ,$From_captures{month}
	    ,$From_captures{year}
	    ,$From_captures{time}
	    ,'From' => $From_captures{From}
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
	  
	  &print_entry(
	    'ref_last_date'    => \$last_date,
	    'FROM_captures'    => \%FROM_captures,
	    'MSG_TO_captures'  => \%MSG_TO_captures,
	    'DATE_captures'    => \%DATE_captures,
	    'SUBJECT_captures' => \%SUBJECT_captures,
	    'From_captures'    => \%From_captures,
	    'to_captures'      => \%to_captures,
	    'subject_captures' => \%subject_captures,
	    'folder_captures'  => \%folder_captures,
	    );

	  %FROM_captures    = ();
	  %MSG_TO_captures  = ();
	  %DATE_captures    = ();
	  %SUBJECT_captures = ();
	  %From_captures    = ();
	  %to_captures      = ();
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
	  
	  &print_entry(
	    'ref_last_date'    => \$last_date,
	    'FROM_captures'    => \%FROM_captures,
	    'MSG_TO_captures'  => \%MSG_TO_captures,
	    'DATE_captures'    => \%DATE_captures,
	    'SUBJECT_captures' => \%SUBJECT_captures,
	    'From_captures'    => \%From_captures,
	    'to_captures'      => \%to_captures,
	    'subject_captures' => \%subject_captures,
	    'folder_captures'  => \%folder_captures,
	    );

	  %FROM_captures    = ();
	  %MSG_TO_captures  = ();
	  %DATE_captures    = ();
	  %SUBJECT_captures = ();
	  %From_captures    = ();
	  %to_captures      = ();
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

  close($main::fh_procmailrc);

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
sub print_entry
{
  my($package,$filename,$line,$proc_name) = caller(0);

  my(%param) = @_;

  my($return_value) = 0;

  printf STDERR ">%s,%d,%s\n",__FILE__,__LINE__,$proc_name
    if 0 && $main::options{debug};

  # $param{ref_last_date}
  # $param{FROM_captures}
  # $param{MSG_TO_captures}
  # $param{DATE_captures}
  # $param{SUBJECT_captures}
  # $param{From_captures}
  # $param{to_captures}
  # $param{subject_captures}
  # $param{folder_captures}

  if(exists($param{From_captures}{From}))
    {

      # in earlier times I used $From_captures{mday} etc,
      # but %From_captures reflects the arrival date+time, not the send date+time.
      # it took me quite a while to find the time to adapt this code.

      my($date);

      if   (exists($param{DATE_captures}{year}))
	{
	  $date = sprintf "%02.2d %s %s"
		    ,exists($param{DATE_captures}{mday})  ? $param{DATE_captures}{mday}  : '0'
		    ,exists($param{DATE_captures}{month}) ? $param{DATE_captures}{month} : '{MONTH}'
		    ,exists($param{DATE_captures}{year})  ? $param{DATE_captures}{year}  : '9999'
		    ;
	  printf "%s\n"
	    ,$date
	    ;
	}
      elsif(exists($param{From_captures}{year}))
	{
	  $date = sprintf "%02.2d %s %s"
		    ,exists($param{From_captures}{mday})  ? $param{From_captures}{mday}  : '0'
		    ,exists($param{From_captures}{month}) ? $param{From_captures}{month} : '{MONTH}'
		    ,exists($param{From_captures}{year})  ? $param{From_captures}{year}  : '9999'
		    ;
	  printf "%s // From_captures\n"
	    ,$date
	    ;
	}

    ##if(0 && ($date eq ${$param{ref_last_date}})) # maybe we always want to print the calender day, otherwise: s/0/1/
    ##  {
    ##    printf "\n";
    ##  }
    ##else
    ##  {
    ##    printf "%s\n"
    ##      ,$date
    ##      ;
    ##  }

      ${$param{ref_last_date}} = $date;

      printf "\t%s %s [_] %s: %s;\n" .
	"\t\t %s:%s;\n" .
	"\t\t %s:%s;\n" .
	''
	,              exists($param{DATE_captures}{time})       ? $param{DATE_captures}{time}       : '{!exists(DATE_captures{time})}'
	,              exists($param{DATE_captures}{DST})        ? $param{DATE_captures}{DST}        : '{!exists(DATE_captures{DST})}'
	, 'From'    =>                                             $param{From_captures}{From}
	, 'FROM'    => exists($param{FROM_captures}{FROM})       ? $param{FROM_captures}{FROM}       : '{!exists(FROM)}'
	, 'TO'      => exists($param{MSG_TO_captures}{MSG_TO})   ? $param{MSG_TO_captures}{MSG_TO}   : '{!exists(MSG_TO)}'
	;

      if   (  exists($param{subject_captures}{subject}) &&  exists($param{SUBJECT_captures}{SUBJECT}) )
	{
	  my($both_still_to_be_printed_p) = 1;

	  {
	    my($SUBJECT) = $param{SUBJECT_captures}{SUBJECT};
	    $SUBJECT =~ s/^ //;

	    if( $param{subject_captures}{subject} eq $SUBJECT )
	      {
		$both_still_to_be_printed_p = 0;

		printf 
		  "\t\t %s: %s; // %s\n"
		  , 'Subject' => $param{subject_captures}{subject}
		  , '*** WILL BE REMOVED, BECAUSE THE SUBJECTS ARE THE SAME ***'
		  ;
		  printf 
		    "\t\t %s:%s;\n"
		    , 'SUBJECT' => $param{SUBJECT_captures}{SUBJECT}
		    ;
	      }
	  }

	  if($both_still_to_be_printed_p)
	    {
	      my($SUBJECT) = $param{SUBJECT_captures}{SUBJECT};
	      $SUBJECT =~ s/^ //;

	      my($subject) = $param{subject_captures}{subject};
	      $subject =~ s/;$//;
	      my($length_of_subject) = length($subject);

	      printf STDERR "=%03.3d,%05.5d: %s // %s\n",__LINE__,$.
		 ,&main::format_key_value_list($main::std_formatting_options, 
					       '$SUBJECT' => $SUBJECT ,
					       '$subject' => $subject ,
					       '$length_of_subject' => $length_of_subject ,
					      )
		,'...'
		if 0;

	      if( substr($SUBJECT,0,$length_of_subject) eq $subject )
		{
		  $both_still_to_be_printed_p = 0;

		  printf 
		    "\t\t %s: %s; // %s\n"
		    , 'Subject' => $param{subject_captures}{subject}
		    , '*** WILL BE REMOVED, BECAUSE IT IS A SUBSTRING ***'
		    if 1;
		  printf 
		    "\t\t %s:%s;\n"
		    , 'SUBJECT' => $param{SUBJECT_captures}{SUBJECT}
		    ;
		}
	    }

	  if($both_still_to_be_printed_p)
	    {
	      if( $param{subject_captures}{subject} =~ m/(?<encoding>=\?UTF-8\?.\?)/i )
		{
		  $both_still_to_be_printed_p = 0;

		  printf 
		    "\t\t %s: %s; // %s=>{%s} // %s\n"
		    , 'Subject' => $param{subject_captures}{subject}
		    , 'encoding' => $+{encoding}
		    , '*** WILL BE REMOVED, BECAUSE IT IS ENCODED ***'
		    if 1;
		  printf 
		    "\t\t %s:%s;\n"
		    , 'SUBJECT' => $param{SUBJECT_captures}{SUBJECT}
		    ;
		}
	    }

	  if($both_still_to_be_printed_p)
	    {
	      if( $param{subject_captures}{subject} =~ m/(?<encoding>=\?ISO-8859-1\?.\?)/i )
		{
		  $both_still_to_be_printed_p = 0;

		  printf 
		    "\t\t %s: %s; // %s=>{%s} // %s\n"
		    , 'Subject' => $param{subject_captures}{subject}
		    , 'encoding' => $+{encoding}
		    , '*** WILL BE REMOVED, BECAUSE IT IS ENCODED ***'
		    if 1;
		  printf 
		    "\t\t %s:%s;\n"
		    , 'SUBJECT' => $param{SUBJECT_captures}{SUBJECT}
		    ;
		}
	    }

	  if($both_still_to_be_printed_p)
	    {
	      printf 
		"\t\t %s: %s;\n"
		, 'Subject' => $param{subject_captures}{subject}
		;
	      printf 
		"\t\t %s:%s;\n"
		, 'SUBJECT' => $param{SUBJECT_captures}{SUBJECT}
		;
	    }
	}
      else
	{
	  printf 
	    "\t\t %s: %s;\n"
	    , 'Subject' => exists($param{subject_captures}{subject}) ? $param{subject_captures}{subject} : '{!exists(subject)}'
	    ;

	  printf 
	    "\t\t %s:%s;\n"
	    , 'SUBJECT' => exists($param{SUBJECT_captures}{SUBJECT}) ? $param{SUBJECT_captures}{SUBJECT} : '{!exists(SUBJECT)}'
	    ;
	}

      printf "\t\t %s: %s\n"
	, 'Folder'  =>                                             $param{folder_captures}{folder}
	;

      &print_shuttle_procmailrc_entry(
	'from0' => $param{From_captures}{From},
	'from1' => $param{FROM_captures}{FROM},
	);
    }

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

  if(fileno($main::fh_procmailrc))
    {
      unless(exists( $main::all_addresses{ $param{from0} } ))
	{
	  $main::all_addresses{ $param{from0} } = 1;

	  printf $main::fh_procmailrc "#\n";
	  printf $main::fh_procmailrc "# %s=>{%s}\n"
	    , '$param{from0}' => $param{from0}
	    ;
	  printf $main::fh_procmailrc "#\n";
	  printf $main::fh_procmailrc "##shuttle:\n";
	  printf $main::fh_procmailrc "##shuttle: :0\n";
	  printf $main::fh_procmailrc "##shuttle: * ^Return-Path: <%s>\$\n"
	    , &backslash_e_mail_address( 'address' => $param{from0} )
	    ;
	  print $main::fh_procmailrc "##shuttle: .folder-biz.prio-9/\n";
	}

      if(defined($param{from1}))
	{
	  my($h) = $param{from1};

	  my($rp);
	  if($param{from1} =~ m/^ .* < (.*) > $/x)
	    {
	      $rp = $1;
	    }
	  else
	    {
	      $rp = $param{from1};
	      $rp =~ s/^ \s+ //x;
	    }

	  unless(exists( $main::all_addresses{ $rp } ))
	    {
	      $main::all_addresses{ $rp } = 1;

	      printf $main::fh_procmailrc "#\n";
	      printf $main::fh_procmailrc "# %s=>{%s}\n"
		, '$param{from1}' => $param{from1}
		;
	      printf $main::fh_procmailrc "#\n";
	      printf $main::fh_procmailrc "##shuttle:\n";
	      printf $main::fh_procmailrc "##shuttle: :0\n";
	      printf $main::fh_procmailrc "##shuttle: * ^Return-Path: <%s>\$\n"
		, &backslash_e_mail_address( 'address' => $rp )
		;
	      print $main::fh_procmailrc "##shuttle: .folder-biz.prio-9/\n";
	    }
	}
    }

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

=head1 AUTHOR

Jochen Hayek E<lt>Jochen+CPAN@Hayek.nameE<gt>

=head1 HISTORY

