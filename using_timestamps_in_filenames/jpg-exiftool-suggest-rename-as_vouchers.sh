:

# misc/using_timestamps_in_filenames/jpg-exiftool-suggest-rename-as_vouchers.sh

# -> README--rename.txt

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

  perl \
    -s \
    -ne '

    if(m/^ FileName   \s* : \s+ (?<FileName>.*)                 /x)
      {
	$FileName = $+{FileName};
      }
    elsif(m/^ (?<Date>\S*) \s* : \s+ (?<Y>....).(?<m>..).(?<d>..).(?<H>..).(?<M>..).(?<S>..) /x)
      {
	$Date = $+{Date};

      ##$time_stamp = "$+{Y}$2$3$4$5$6";
	$time_stamp = "$+{Y}$+{m}$+{d}$+{H}$+{M}$+{S}";

      ##print "mv \"${FileName}\" \"${time_stamp}--${FileName}\" # \$Date=>{$Date}\n";
	print "mv \"${FileName}\" \"999990-000--${time_stamp}--${FileName}\" # \$Date=>{$Date}\n";
      }

  ' \
  -- -Date=${Date} "-filename=${filename}"
done
