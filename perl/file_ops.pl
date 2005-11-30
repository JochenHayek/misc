#!/usr/bin/perl -w
#!/usr/bin/perl

($emacs_Time_stamp) = 'Time-stamp: <2005-12-01 00:42:52 johayek>' =~ m/<(.*)>/;

          $rcs_Id=(join(' ',((split(/\s/,'$Id: file_ops.pl 1.1 2005/11/30 23:44:03 johayek Exp $'))[1..6])));
#	$rcs_Date=(join(' ',((split(/\s/,'$Date: 2005/11/30 23:44:03 $'))[1..2])));
#     $rcs_Author=(join(' ',((split(/\s/,'$Author: johayek $'))[1])));
#	 $RCSfile=(join(' ',((split(/\s/,'$RCSfile: file_ops.pl $'))[1])));
#     $rcs_Source=(join(' ',((split(/\s/,'$Source: /home/jochen_hayek/git-servers/github.com/JochenHayek/misc/perl/RCS/file_ops.pl $'))[1])));

# usage:
#
#     ...

# purpose:
#
#     ...

# in:

# out:

# requirements:
{
  use English;
  use FileHandle;
  use strict;

  &main;
}
#
sub main
{
  my($package,$filename,$line,$proc_name) = caller(0);

  my(%param) = @_;

  $return_value = 0;

  # described in:
  #	camel book / ch. 7: the std. perl lib. / lib. modules / Getopt::Long - ...

  use Getopt::Long;
  use Pod::Usage;
  %options = ();

  $main::options{debug} = 0;

  printf STDERR ">%s,%d,%s\n",__FILE__,__LINE__,$proc_name
    if 0 && $main::options{debug};
  printf STDERR "=%s,%d,%s: %s=>{%s}\n",__FILE__,__LINE__,$proc_name
    ,'$rcs_Id',$rcs_Id
    if 0 && $main::options{debug};
  printf STDERR "=%s,%d,%s: %s=>{%s}\n",__FILE__,__LINE__,$proc_name
    ,'$emacs_Time_stamp',$emacs_Time_stamp
    if 0 && $main::options{debug};

  {
    # defaults for the main::options;
    
    $main::options{dry_run}		       	= 0;
    $main::options{version}		       	= 0;
    $main::options{verbose}		       	= 0;

  ##$main::options{curl_bin}		       	= 'curl';
    $main::options{curl_bin}		       	= 'curl-haxx-se';

    $main::options{job____}      = 1;

    $main::options{user}		       	= '';
    $main::options{passwd}		       	= '';

    $main::options{bank_html_file}	       	= undef;

    $main::options{payee_name}		       	= '';
    $main::options{payee_account}		= '';
    $main::options{payee_blz}		       	= '';
  ##$main::options{payee_bank}		       	= '';
    $main::options{amount}		       	= '';
    $main::options{memo_1}		       	= '';
    $main::options{memo_2}		       	= '';
    $main::options{debit_date}		       	= '';
  }

  my($result) =
    &GetOptions
      (\%main::options
       ,'job____!'

       ,'dry_run!'
       ,'version!'
       ,'help|?!'
       ,'man!'
       ,'debug!'
       ,'verbose=s'

       ,'curl_bin=s'

       ,'user=s'
       ,'passwd=s'

       ,'gen_csv!'

       ,'transaction_number|tan=s'

       ,'bank_html_file=s'

       ,'payee_name=s'
       ,'payee_account=s'
       ,'payee_blz=s'
     ##,'payee_bank=s'
       ,'amount=s'
       ,'memo_1=s'
       ,'memo_2=s'
       ,'debit_date=s'
       );
  $result || pod2usage(2);

  pod2usage(1) if $main::options{help};
  pod2usage(-exitstatus => 0, -verbose => 2) if $main::options{man};

  if   ($main::options{job____}) { &job____; }
##elsif($main::options{job_upload_transfer}   ) { &job_upload_transfer; }
  else
    {
      die "no job to be carried out";
    }

  printf STDERR "=%s,%d,%s: %s=>{%s}\n",__FILE__,__LINE__,$proc_name
    ,'$return_value',$return_value
    if 0 && $main::options{debug};
  printf STDERR "<%s,%d,%s\n",__FILE__,__LINE__,$proc_name
    if 0 && $main::options{debug};
}
#
sub job____
{
  my($package,$filename,$line,$proc_name) = caller(0);

  my(%param) = @_;

  $return_value = 0;

  printf STDERR ">%s,%d,%s\n",__FILE__,__LINE__,$proc_name
    if 1 && $main::options{debug};

  # ...

  printf STDERR "=%s,%d,%s: %s=>{%s}\n",__FILE__,__LINE__,$proc_name
    ,'$return_value',$return_value
    if 0 && $main::options{debug};
  printf STDERR "<%s,%d,%s\n",__FILE__,__LINE__,$proc_name
    if 1 && $main::options{debug};

  return $return_value;
}
__END__

=head1 NAME

~/com/postbank.de/web-banking/p.pl - ...

=head1 SYNOPSIS

~/com/postbank.de/web-banking/p.pl [options] [file ...]

Options:
    --help
    --man

    --job____
    --job_upload_transfer

    --user=s
    --passwd=s

=head1 OPTIONS

=over 8

=item B<--help>

Print a brief help message and exits.

=item B<--man>

Prints the manual page and exits.

=item B<--job____>

...

=item B<--job_upload_transfer>

...

=item B<--user>

Also known as the I<account>.
...

=item B<--passwd>

Also known as the I<PIN>.
...

=back

=head1 DESCRIPTION

B<This program> will ...,
and leave a file I<$PWD/%Y%m%d%H%M%S.html> (from I<localtime>),
that you will probably further process with ~/com/postbank.de/HTML/postbank_html2csv.pl ___.html > ____.csv .

Also read ~/com/postbank.de/HTML/README-web2csv !

=cut
