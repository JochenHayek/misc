:

# -> README--extracting_timestamps.txt

# misc/using_timestamps_in_filenames/jpg-exif-suggest-*.sh
# misc/using_timestamps_in_filenames/jpg-exif-suggest-rename-as_vouchers.sh
# misc/using_timestamps_in_filenames/jpg-exif-suggest-rename-versioned.sh

# misc/using_timestamps_in_filenames/jpg-exiftool-suggest-*.sh
# misc/using_timestamps_in_filenames/jpg-exiftool-suggest-rename-as_vouchers.sh
# misc/using_timestamps_in_filenames/jpg-exiftool-suggest-rename-versioned.sh

################################################################################

# $ exiftool -s *.jpg | fgrep -i date

################################################################################

##Date=CreateDate
##Date=DateTimeOriginal
##Date=FileModifyDate
##Date=ModifyDate
  Date=ModifyDate

# CreateDate                      : 2014:08:30 10:04:37
# DateTimeOriginal                : 2014:08:30 10:04:37
# FileAccessDate                  : 2014:09:16 15:39:12+02:00
# FileInodeChangeDate             : 2014:09:16 13:20:38+02:00
# FileModifyDate                  : 2014:09:16 13:20:25+02:00
# ModifyDate                      : 2014:08:30 10:04:37
# PowerUpTime                     : 2014:08:30 10:03:26
##ProfileDateTime                 : 1998:02:09 06:49:00
# SubSecCreateDate                : 2014:08:30 10:04:37.29
# SubSecDateTimeOriginal          : 2014:08:30 10:04:37.29
# SubSecModifyDate                : 2014:08:30 10:04:37.29
  
for filename
do

  echo "*** ${filename}:"

##exiftool -s -${Date}   -FileName "${filename}" | 
  exiftool -s \
    -FileName \
    -CreateDate -DateTimeOriginal -FileAccessDate -FileInodeChangeDate -FileModifyDate -ModifyDate -PowerUpTime -SubSecCreateDate -SubSecDateTimeOriginal -SubSecModifyDate \
    "${filename}" | 

  perl -MFile::Basename \
    -s \
    -ne '

    if(m/^ FileName   \s* : \s+ (?<FileName>.*)                 /x)
      {
	$filename = $+{FileName};

	if   ( $filename =~ m/\.jpg/x )
	  {
	    our($basename) = basename($filename,".jpg");
	  }
	elsif( $filename =~ m/\.jpeg/x )
	  {
	    our($basename) = basename($filename,".jpeg");
	  }

	our($dirname)  = dirname($filename);
      }
    elsif(m/^ (?<n>\S*) \s* : \s+ (?<v> (?<Y>....).(?<m>..).(?<d>..).(?<H>..).(?<M>..).(?<S>..) ) /x)
      {
        my(%plus) = %+;

	$ts_YmdHMS  = "$+{Y}$+{m}$+{d}$+{H}$+{M}$+{S}";
	$ts_YmdHM_S = "$+{Y}$+{m}$+{d}$+{H}$+{M}.$+{S}";

	print "mv \"${filename}\" \"999990-000--${ts_YmdHMS}--${filename}\" # $n=>{$v}\n"
	  if 0;

	func(
	    dirname    => $dirname , 
	    filename   => $filename ,
	    basename   => $basename ,
	    ts_YmdHMS  => $ts_YmdHMS ,
	    ts_YmdHM_S => $ts_YmdHM_S ,
            n          => $plus{n} ,
            v          => $plus{v} ,
	  );
      }

    sub create_command_line_rename_as_vouchers
  ##sub func
    {
      my($package,$filename,$line,$proc_name) = caller(0);

      my(%param) = @_;

      my($return_value) = 0;

      # ----------

      printf "mv \"%s\" \"%s/%s--%s--%s.%s\" # %20s=>{%s} // %s\n",
	$param{filename},
	$param{dirname} , "999990-000" , $param{ts_YmdHMS} , $param{basename} , "jpg" ,
	$param{n} => $param{v},
	$param{filename},
	;

      # ----------

      return $return_value;
    }

    sub create_command_line_rename_versioned
  ##sub func
    {
      my($package,$filename,$line,$proc_name) = caller(0);

      my(%param) = @_;

      my($return_value) = 0;

      # ----------

      printf "mv \"%s\" \"%s/%s.%s.%s\" # %20s=>{%s} // %s\n",
	$param{filename},
	$param{dirname} , $param{basename} , $param{ts_YmdHMS} , "jpg" ,
	$param{n} => $param{v},
	$param{filename},
	;

      # ----------

      return $return_value;
    }

  ##sub create_command_line_touch
    sub func
    {
      my($package,$filename,$line,$proc_name) = caller(0);

      my(%param) = @_;

      my($return_value) = 0;

      # ----------

      printf "touch -t \"%s\" \"%s\" # %20s=>{%s}\n",
	$param{ts_YmdHM_S} ,
	$param{filename} ,
	$param{n} => $param{v},
	;

      # ----------

      return $return_value;
    }

  ' \
  -- -Date=${Date} "-filename=${filename}" |

  sort

done
