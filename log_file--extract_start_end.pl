#! /usr/bin/perl -ws

# $ gzip -cd typescript.load_tar_ball.20171026085300.gz | $USERPROFILE/git-servers/github.com/JochenHayek/misc/log_file--extract_start_end.pl -job_is_word_only_p
# $ gzip -cd typescript.load_tar_ball.20171026085300.gz | $USERPROFILE/git-servers/github.com/JochenHayek/misc/log_file--extract_start_end.pl -job_is_word_only_p=1
# $ gzip -cd typescript.load_tar_ball.20171026085300.gz | $USERPROFILE/git-servers/github.com/JochenHayek/misc/log_file--extract_start_end.pl -job_is_word_only_p=0

# $ gzip -cd typescript.load_tar_ball.20171026085300.gz | $HOME/bin/log_file--extract_start_end.pl -job_is_word_only_p
# $ gzip -cd typescript.load_tar_ball.20171026085300.gz | $HOME/bin/log_file--extract_start_end.pl -job_is_word_only_p=1
# $ gzip -cd typescript.load_tar_ball.20171026085300.gz | $HOME/bin/log_file--extract_start_end.pl -job_is_word_only_p=0

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

# format V2:

# ***>2017-10-25 22:52:23,convert: what=>{Part1}
# ***>2017-10-25 22:52:31,convert: what=>{Part1.00001}
# ***<2017-10-25 22:52:34,convert: what=>{Part1.00001}
# ***<2017-10-25 23:54:08,convert: what=>{Part1}

################################################################################
################################################################################
################################################################################

use Time::Local;

{
  my($package,$filename,$line,$proc_name) = ('','','','');

  ################################################################################

  $::job_is_word_only_p = 0
    unless defined($::job_is_word_only_p);

  printf STDERR "=%s,%03.03d,%07.07d: %s=>{%s} // %s\n",__FILE__,__LINE__,0,
    '$::job_is_word_only_p' => $::job_is_word_only_p,
    '...'
    if 0;

  ################################################################################

  %::table =();

  ################################################################################

  my($column_separator) = '+';
  my($krrr) = '-';

  $::separator_line = 
    sprintf "${column_separator}"
          . "${krrr}%-20.20s${krrr}${column_separator}"
          . "${krrr}%-20.20s${krrr}${column_separator}"
          . "${krrr}%-19.19s${krrr}${column_separator}"
          . "${krrr}%-19.19s${krrr}${column_separator}"
          . "${krrr}%-8.8s${krrr}${column_separator}"
          . "${krrr}%-20.20s${krrr}${column_separator}"
          . "\n",

  ##'what',
    '-' x 100,

  ##'job',
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
          . "${krrr}%-20.20s${krrr}${column_separator}"
          . "${krrr}%-19.19s${krrr}${column_separator}"
          . "${krrr}%-19.19s${krrr}${column_separator}"
          . "${krrr}%-8.8s${krrr}${column_separator}"
          . "${krrr}%-20.20s${krrr}${column_separator}"
          . "\n";

  printf $::format_data_line,

  ##'what',
    '',

  ##'job',
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

      if(0)
	{
	}

      elsif(m/ (?<marker>.) (?<timestamp>\d+ [\d\s\-:]*) , (?<job>[^:]*): \s+ what=>\{(?<what>[^}]*)\} /x)
	{
	  my(%plus) = %+;

	  printf STDERR "=%s,%d,%s: %s=>{%s},%s=>{%s},%s=>{%s},%s=>{%s} // %s\n",__FILE__,__LINE__,$proc_name,
	    '$plus{marker}' => $plus{marker},
	    '$plus{timestamp}' => $plus{timestamp},
	    '$plus{job}' => $plus{job},
	    '$plus{what}' => $plus{what},
	    '...'
	    if 0 && $main::options{debug};

	  if   (0)
	    {
	    }

	  elsif($::job_is_word_only_p && $plus{job} =~ m/,/) # we are not dealing with "TASK,..." for the time being
	    {
	      next;
	    }

	  elsif($plus{marker} eq '>')
	    {
	      $::table{ $plus{what} }{ $plus{job} }{ start }{human_readable} =                                $plus{timestamp};
	      $::table{ $plus{what} }{ $plus{job} }{ start }{in_seconds}     = &timestamp2epoch( timestamp => $plus{timestamp} );
	    }
	  elsif($plus{marker} eq '<')
	    {
	      $::table{ $plus{what} }{ $plus{job} }{ end   }{human_readable} =                                $plus{timestamp};
	      $::table{ $plus{what} }{ $plus{job} }{ end   }{in_seconds}     = &timestamp2epoch( timestamp => $plus{timestamp} );

	      &display_row(
		what => $plus{what} ,
		job => $plus{job} ,
		)
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

  # $param{what}
  # $param{job}
  # $param{...}

  my($return_value) = 0;

  printf STDERR ">%s,%d,%s: // %s\n",__FILE__,__LINE__,$proc_name,
    '...'
    if 0 && $main::options{debug};

  my($elapsed_in_seconds) = $::table{ $param{what} }{ $param{job} }{end}{in_seconds} - $::table{ $param{what} }{ $param{job} }{start}{in_seconds};

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
    $param{what},
    $param{job},
    $::table{ $param{what} }{ $param{job} }{start}{human_readable},
    $::table{ $param{what} }{ $param{job} }{end  }{human_readable},
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

# format V2:

# ***>2017-10-25 22:52:23,convert: what=>{Part1}
# ***>2017-10-25 22:52:31,convert: what=>{Part1.00001}
# ***<2017-10-25 22:52:34,convert: what=>{Part1.00001}
# ***<2017-10-25 23:54:08,convert: what=>{Part1}

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
