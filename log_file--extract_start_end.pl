#! /usr/bin/perl -w

# $ gzip -cd typescript.load_tar_ball.20171026085300.gz | $USERPROFILE/git-servers/github.com/JochenHayek/misc/log_file--extract_start_end.pl
# $ gzip -cd typescript.load_tar_ball.20171026085300.gz | $HOME/bin/log_file--extract_start_end.pl

# $ ~/bin/create_snapshot.sh *~ log_file--extract_start_end.pl

################################################################################
################################################################################
################################################################################
#
# we are reading a log file (formatted as shown below).
#
# we encounter "start" (">") lines and "end" ("<") lines.
#
# we computer elapsed times.
#
# we show a table with start time, end time, and elapsed time.
# for an example see here at the bottom!
#
################################################################################

# format V0:

# *** 2017-10-25 22:52:23,Part1: // start
# *** 2017-10-25 22:52:31,Part1,Part1.00001: // start
# *** 2017-10-25 22:52:34,Part1,Part1.00001: // end
# *** 2017-10-25 23:54:08,Part1: // end

################################################################################

# format V1:

# ***>2017-10-25 22:52:23,Part1: // ...
# ***>2017-10-25 22:52:31,Part1,Part1.00001: // ...
# ***<2017-10-25 22:52:34,Part1,Part1.00001: // ...
# ***<2017-10-25 23:54:08,Part1: // ...

################################################################################

# format V2 (not yet implemented - yet to be designed):

# ***>2017-10-25 22:52:23,main.sh,325,main: file=>{Part1}
# ***>2017-10-25 22:52:31,main.sh,325,main: file=>{Part1.00001}
# ***<2017-10-25 22:52:34,main.sh,325,main: file=>{Part1.00001}
# ***<2017-10-25 23:54:08,main.sh,325,main: file=>{Part1}

################################################################################
################################################################################
################################################################################

use Time::Local;

{
  my($package,$filename,$line,$proc_name) = ('','','','');

  %::table =();

  ################################################################################

  my($column_separator) = '+';
  my($krrr) = '-';

  $::separator_line = 
    sprintf "${column_separator}"
          . "${krrr}%-20.20s${krrr}${column_separator}"
          . "${krrr}%-19.19s${krrr}${column_separator}"
          . "${krrr}%-19.19s${krrr}${column_separator}"
          . "${krrr}%-8.8s${krrr}${column_separator}"
          . "${krrr}%-20.20s${krrr}${column_separator}"
          . "\n",

  ##'(1st ...)',
    '-' x 100,

  ##'2017-10-25 22:52:23',
    '-' x 100,

  ##'2017-10-25 22:52:23',
    '-' x 100,

  ##'HH:MM:SS',
    '-' x 100,

  ##'(comment)',
    '-' x 100,
    ;

  print  $::separator_line;

  ################################################################################

  $column_separator = '|';
  $krrr = ' ';
  $::format_data_line = 
            "${column_separator}"
          . "${krrr}%-20.20s${krrr}${column_separator}"
          . "${krrr}%-19.19s${krrr}${column_separator}"
          . "${krrr}%-19.19s${krrr}${column_separator}"
          . "${krrr}%-8.8s${krrr}${column_separator}"
          . "${krrr}%-20.20s${krrr}${column_separator}"
          . "\n";

  printf $::format_data_line,

  ##'(1st ...)',
    '',

  ##'2017-10-25 22:52:23',
    'start',

  ##'2017-10-25 22:52:23',
    'end',

  ##'HH:MM:SS',
    'elapsed',

  ##'comment',
    'comment',
    ;

  ################################################################################

  while(<>)
    {
      s/\s+$//;

      if(m/ (?<marker>.) (?<timestamp>\d+ [\d\s\-:]*) , (?<Part>Part.): \s+ \/\/ \s+ (?<start_or_end>.*)/x)
    ##if(m/ (?<marker>.) (?<timestamp>\d+ [\d\s\-:]*) , (?<Part>[^:]*): \s+ \/\/ \s+ (?<start_or_end>.*)/x)
    ##if(m/ (?<marker>.) (?<timestamp>\d+ [\d\s\-:]*) , (?<Part>Part.): \s+ \/\/ \s+ (?<start_or_end>start|end)/x)
    ##if(m/ (?<marker>.) (?<timestamp>\d+ [\d\s\-:]*) , (?<Part>[^:]*): \s+ \/\/ \s+ (?<start_or_end>start|end)/x)
	{
	  my(%plus) = %+;

	  if   (0)
	      {
	      }

	  elsif($plus{marker} eq '>')
	      {
		$::table{ $plus{Part} }{ start }{human_readable} =                                $plus{timestamp};
		$::table{ $plus{Part} }{ start }{in_seconds}     = &timestamp2epoch( timestamp => $plus{timestamp} );
	      }
	  elsif($plus{marker} eq '<')
	      {
		$::table{ $plus{Part} }{ end   }{human_readable} =                                $plus{timestamp};
		$::table{ $plus{Part} }{ end   }{in_seconds}     = &timestamp2epoch( timestamp => $plus{timestamp} );

		&display_row( Part => $plus{Part} )
		  if 1;
	      }

	  elsif($plus{start_or_end} eq 'start')
	      {
		$::table{ $plus{Part} }{ start }{human_readable} =                                $plus{timestamp};
		$::table{ $plus{Part} }{ start }{in_seconds}     = &timestamp2epoch( timestamp => $plus{timestamp} );
	      }
	  elsif($plus{start_or_end} eq 'end')
	      {
		$::table{ $plus{Part} }{ end   }{human_readable} =                                $plus{timestamp};
		$::table{ $plus{Part} }{ end   }{in_seconds}     = &timestamp2epoch( timestamp => $plus{timestamp} );

		&display_row( Part => $plus{Part} )
		  if 1;
	      }
	}
    }

  print  $::separator_line;
}
#
sub display_row
{
  my($package,$filename,$line,$proc_name) = caller(0);

  my(%param) = @_;

  # $param{...}

  my($return_value) = 0;

  printf STDERR ">%s,%d,%s: // %s\n",__FILE__,__LINE__,$proc_name,
    '...'
    if 0 && $main::options{debug};

  my($elapsed_in_seconds) = $::table{ $param{Part} }{end}{in_seconds} - $::table{ $param{Part} }{start}{in_seconds};

  my($SS_only)    = $elapsed_in_seconds %   60;
  my($MM_SS_only) = $elapsed_in_seconds % 3660;
  my($MM_only)    = $MM_SS_only         /   60;
  my($HH_only)    = $elapsed_in_seconds / 3660;

  my($elapsed_human_readable) =
    sprintf "%02.2d:%02.2d:%02.2d",
    $HH_only,
    $MM_only,
    $SS_only,
    ;

  printf STDERR "=%s,%d,%s: %s=>{%s},%s=>{%s} // %s\n",__FILE__,__LINE__,$proc_name,
    '$elapsed_in_seconds' => $elapsed_in_seconds,
    '$elapsed_human_readable' => $elapsed_human_readable,
    '...'
    if 0 && $main::options{debug};

  print  $::separator_line;

  printf $::format_data_line,
    $param{Part},
    $::table{ $param{Part} }{start}{human_readable},
    $::table{ $param{Part} }{end  }{human_readable},
  ##'HH:MM:SS',
    $elapsed_human_readable,
    '',
    ;

  printf STDERR "=%s,%d,%s: %s=>{%s} // %s\n",__FILE__,__LINE__,$proc_name,
    '$return_value' => $return_value,
    '...'
    if 0 && $main::options{debug};

  printf STDERR "<%s,%d,%s: // %s\n",__FILE__,__LINE__,$proc_name,
    '...'
    if 0 && $main::options{debug};

  return $return_value;
}
#
sub timestamp2epoch
{
  my($package,$filename,$line,$proc_name) = caller(0);

  my(%param) = @_;

  # $param{timestamp}
  # $param{...}

  my($return_value) = 0;

  printf STDERR ">%s,%d,%s: // %s\n",__FILE__,__LINE__,$proc_name,
    '...'
    if 0 && $main::options{debug};

  # http://Jochen.Hayek.name/wp/blog-en/2017/10/26/how-to-translate-human-readable-time-to-epoch/

  $param{timestamp} =~ m/^(?<YYYY>\d{4})-(?<mm>\d{2})-(?<dd>\d{2}) (?<HH>\d{2}):(?<MM>\d{2}):(?<SS>\d{2})$/;

  $return_value = timelocal($+{SS}, $+{MM}, $+{HH}, $+{dd}, $+{mm} - 1, $+{YYYY} - 1900);

  printf STDERR "=%s,%d,%s: %s=>{%s} // %s\n",__FILE__,__LINE__,$proc_name,
    '$return_value' => $return_value,
    '...'
    if 0 && $main::options{debug};

  printf STDERR "<%s,%d,%s: // %s\n",__FILE__,__LINE__,$proc_name,
    '...'
    if 0 && $main::options{debug};

  return $return_value;
}

__END__

################################################################################

# format V0:

# *** 2017-10-25 22:52:23,Part1: // start
# *** 2017-10-25 22:52:31,Part1,Part1.00001: // start
# *** 2017-10-25 22:52:34,Part1,Part1.00001: // end
# *** 2017-10-25 23:54:08,Part1: // end

################################################################################

# format V1:

# ***>2017-10-25 22:52:23,Part1: // ...
# ***>2017-10-25 22:52:31,Part1,Part1.00001: // ...
# ***<2017-10-25 22:52:34,Part1,Part1.00001: // ...
# ***<2017-10-25 23:54:08,Part1: // ...

################################################################################

$ gzip -cd typescript.load_tar_ball.20171026085300.gz | c:/Users/jochen.hayek/git-servers/github.com/JochenHayek/misc/log_file--extract_start_end.pl
+------------+---------------------+---------------------+----------+
|            | start               | end                 | elapsed  |
+------------+---------------------+---------------------+----------+
| Part1      | 2017-10-25 22:52:23 | 2017-10-25 23:54:08 | HH:MM:SS |
+------------+---------------------+---------------------+----------+
| Part2      | 2017-10-25 23:54:08 | 2017-10-26 00:55:13 | HH:MM:SS |
+------------+---------------------+---------------------+----------+
| Part3      | 2017-10-26 00:55:13 | 2017-10-26 01:56:51 | HH:MM:SS |
+------------+---------------------+---------------------+----------+
| Part4      | 2017-10-26 01:56:51 | 2017-10-26 02:57:33 | HH:MM:SS |
+------------+---------------------+---------------------+----------+
| Part5      | 2017-10-26 02:57:33 | 2017-10-26 03:55:25 | HH:MM:SS |
+------------+---------------------+---------------------+----------+
| Part6      | 2017-10-26 03:55:25 | 2017-10-26 04:57:23 | HH:MM:SS |
+------------+---------------------+---------------------+----------+
| Part7      | 2017-10-26 04:57:23 | 2017-10-26 05:58:54 | HH:MM:SS |
+------------+---------------------+---------------------+----------+
| Part8      | 2017-10-26 05:58:54 | 2017-10-26 07:00:21 | HH:MM:SS |
+------------+---------------------+---------------------+----------+
| Part9      | 2017-10-26 07:00:21 | 2017-10-26 07:56:49 | HH:MM:SS |
+------------+---------------------+---------------------+----------+
