#! /usr/bin/perl -w

# $Id: fetchmail--extract_fingerprints.pl 1.14 2014/12/18 00:19:51 johayek Exp johayek $ Jochen Hayek
# $Source: /home/jochen_hayek/Computers/Programming/Languages/Perl/RCS/fetchmail--extract_fingerprints.pl $

################################################################################

# how to call the script:

# $ ~/Computers/Programming/Languages/Perl/fetchmail--extract_fingerprints.pl ~/var/log/fetchmail.log

# actually we call it like this:

# $ ssh -n ... bin/fetchmail--extract_fingerprints.pl var/log/fetchmail.log

################################################################################

# how to download the script (it is named ".txt" in order to make your downloading simpler):

# $ curl --output fetchmail--extract_fingerprints.pl http://Jochen.Hayek.name/Computers/Programming/Languages/Perl/fetchmail--extract_fingerprints.txt

################################################################################

# $ rsync -vaz --rsync-path=/volume1/@hayek/bin/rsync $HOME/Computers/Programming/Languages/Perl/fetchmail--extract_fingerprints.pl diskstation002:ARCHIVE/www.b.shuttle.de-non-dated/Computers/Programming/Languages/Perl/
# $ rsync -vaz                                        $HOME/Computers/Programming/Languages/Perl/fetchmail--extract_fingerprints.pl                                  www.b.shuttle.de:Computers/Programming/Languages/Perl/
# $ rsync -vaz                                        $HOME/Computers/Programming/Languages/Perl/fetchmail--extract_fingerprints.pl                 www.b.shuttle.de:www/hayek/jochen/Computers/Programming/Languages/Perl/fetchmail--extract_fingerprints.txt

################################################################################

# 2014-12-15 :
#   the script also extracts from fetchmail's log file and then tells you,
#   whether a specific server's fingerprints still match.

# 2014-11-05 :
#   eventually created this script,
#   because it appeared to me, as if had done this job already a couple of times,
#   and it also appeared to me as tedious and errorprone,
#   so I made this a tiny little programming challenge.

################################################################################

{
  use Carp;
  use POSIX qw(strftime);

  our $std_formatting_options = { 'separator' => ',', 'assign' => '=>', 'quoteLeft' => '{', 'quoteRight' => '}' };

  $main::options{debug} = 0;

  my($package,$filename,$line,$proc_name) = caller(0);

  $proc_name = '(-)' if !defined($proc_name);

  $now_string = strftime "%Y-%m-%d-%H-%M-%S", localtime;

  while(<>)
    {

      # $+{time}=>{Sat Dec 13 11:20:23 2014}

      if( m/^ fetchmail: \s+ (?<version> \S+) \s+ querying \s+ (?<host> \S+) \s+ (?<z> .+) \s+ at \s+ (?<time> .+) : \s+ poll \s+ started $/x )
	{
	  my($time) = $+{time};

	  # get to the pieces of this date+time string:
	  # (actually we would rather prefer the month as a 2-digit-string over the 3-letter-shortname)

	  if ( $time =~ m/^ (?<wday>\S+) \s+ (?<month>\S+) \s+ (?<day>\d+) \s+ (?<HHMMSS>\S+) \s+ (?<year>\d+) $/x )
	    {
	      $now_string = "$+{year}-$+{month}-$+{day} $+{HHMMSS}";

	      printf STDOUT "    # {%s}\n",$now_string
		if 0;
	    }
	}

      # fetchmail: jh-gapps.gmail.com key fingerprint: 3E:D4:0B:B3:DE:CB:2D:4E:D3:FC:36:7D:A9:8E:B7:10

      elsif( m/^ fetchmail: \s+ (?<host> \S+) \s+ key \s+ fingerprint: \s+ (?<fingerprint> \S+) $/x )
	{
	  printf STDERR "=%s,%d,%s: %s // %s\n",__FILE__,__LINE__,$proc_name
	    , &main::format_key_value_list($main::std_formatting_options,
					   '$+{host}' => $+{host} ,
					   '$+{fingerprint}' => $+{fingerprint} ,
					  )
	    ,'...'
	    if 1 && $main::options{debug};
	  
	  printf STDOUT "  poll %s\n      sslfingerprint \"%s\"\t# >= %s\n",$+{host},$+{fingerprint},$now_string
	    if 1;
	}

      # this regexp will get refined, so that it will also tell us, if and when they will NOT match

      # fetchmail: jh60.gmx.net fingerprints match.
      # fetchmail: t-online.de fingerprints match.
      # fetchmail: jh-gapps.gmail.com fingerprints do not match!
      # fetchmail: jh.gmail.com fingerprints do not match!

      elsif( m/^ fetchmail: \s+ (?<all> (?<host> \S+) \s+ fingerprints (?<middle> \s+ .* \s+ | \s+ ) match. ) $/x )
	{
	  printf STDOUT "    # {%s}\n",$+{all}
	    if 1;
	}
    }
}
#
sub format_key_value_list
{
  my $refOptions = shift(@_);

  my $buf;

  confess '!defined($refOptions)' unless defined($refOptions);	    # -> use Carp

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
